---
layout: page
title: Vanilla Steering for LLM Arithmetic
description: Probe-based steering caps at ~10% flip rate; oracle logit steering hits 100%. Why a clean linear signal can be diagnostic without being a controllable lever.
img: assets/img/publication_preview/mi_steer_thumb.png
importance: 6
category: fun
related_publications: false
---

**Highlight.** A linear probe at layer 4 separates correct-from-incorrect 5-digit addition with **AUC = 1.0** — yet steering along that probe direction caps at a **9.8% flip rate**. Steering instead along the unembedding row of the correct digit at the last layer reaches **100% flip rate at α = 100**. The first is a clean *correlate* of difficulty; the second is a *causal* lever — and only the oracle one knows what the answer should be. The gap between "the model has a readable signal" and "the model can be steered with that signal" is the headline of this experiment.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_steer_thumb.png" title="Vanilla steering pipeline: probe direction at layer 4 vs. oracle logit direction at layer 23, both injected during digit-by-digit autoregressive generation." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## The arithmetic pipeline

Qwen2.5 uses digit-by-digit tokenization. A 5-digit addition problem becomes:

```
Prompt:   "1 2 3 4 5   +   6 7 8 9 0   ="
Tokens:    16 17 18 19 20 10 21 22 23 24 15 28

Generation (autoregressive, one digit per step):
           ↓    ↓    ↓    ↓    ↓
Output:   "8"  "0"  "2"  "3"  "5"   →  80235
```

At each generation step, the model runs the full transformer stack and selects the next token via argmax on the final logits.

## Where the model is wrong

The residual stream at the `=` token encodes problem difficulty: a linear probe at layer 4 reaches **AUC = 1.0** separating correct-from-incorrect problems on Qwen2.5-0.5B 5-digit addition. Despite this clean signal, **~87% of 5-digit problems are answered incorrectly**. The representation is a correlate of difficulty, not a causal computation switch — knowing whether the model will fail is not the same as making it succeed.

## Intervention points

```
Prompt tokens
      │
      ▼
 Layer 0
      │
      ▼
 Layer 1
      │  ← probe direction v lives here
     ...
      │
      ▼
 Layer 4  ────── best probe layer (AUC=1.0)
      │
     ...
      │
      ▼
 Layer 23 (last) ─────── oracle steering point
      │
      ▼
  final norm
      │
      ▼
   LM head  →  logits  →  argmax  →  next digit token
```

**Probe steering (Exp G/H).** Add `α · v` to the residual at layer 4. The direction `v` is either a mean-difference vector — `v = mean(correct hidden states) − mean(incorrect hidden states)` — or the first principal component of contrastive differences (RepE PCA).

**Oracle logit steering (Exp I).** At each digit-generation step, add `α · W_U[correct_digit]` to the layer-23 output before the final norm. `W_U[c]` is row `c` of the unembedding matrix — the direction in hidden space that maximally boosts digit `c`'s logit.

## How the intervention works

At a digit step with cached KV:

```
h  ∈ ℝ^896        ← last transformer layer output (seq_len = 1)

Probe steering:
  h' = h + α · v_probe        v_probe trained on residuals at "=" token

Oracle steering:
  h' = h + α · W_U[c]         c = correct digit for this position
                              W_U[c] ∈ ℝ^896, row of LM head weight

logits = lm_head(norm(h'))    ← recompute after modification
next_token = argmax(logits)
```

The `W_U[c]` direction works because

```
logit[c] = W_U[c] · norm(h)
```

so adding `α · W_U[c]` to `h` increases `logit[c]` by ≈ `α · ‖W_U[c]‖²`, while other digits get a smaller incidental boost via their inner product with `W_U[c]`.

## Effect on logits

A digit step where the model predicts `"1"` but the correct answer is `"8"`.

**Before steering (α = 0)** — raw logits over digit tokens 0–9:

```
  0  ████████████████████████████████
  1  ████████████████████████████████████████████  ← argmax, predicted ✗
  2  ████████████████████████████████████████
  3  ████████████████████████████████████
  4  ████████████████████████████████
  5  ██████████████████████████████
  6  ████████████████████████████
  7  ██████████████████████████
  8  ████████████████████████                      ← correct answer, suppressed
  9  ██████████████████████
```

**After oracle steering (α = 100)** — add `100 · W_U[8]` to the hidden state:

```
  0  ███████████████████████████████████████
  1  █████████████████████████████████████
  2  ████████████████████████████████████████
  3  ██████████████████████████████████████
  4  █████████████████████████████████████
  5  ████████████████████████████████████
  6  ███████████████████████████████████████████
  7  ████████████████████████████████████████████████
  8  ██████████████████████████████████████████████████████████████  ← argmax ✓
  9  ██████████████████████████████████████████████████
```

What happened: adding `α · W_U[8]` to `h` shifts every digit's logit by `α · (W_U[8] · W_U[d])`. Digit 8 gets the largest boost because its unembedding row is maximally aligned with itself.

```
Δ logit[d] = α · (W_U[8] · W_U[d])

d=8:  α · ‖W_U[8]‖²          ← largest (self-dot-product)
d=7:  α · (W_U[8] · W_U[7])  ← moderate (neighbors tend to be similar)
d=9:  α · (W_U[8] · W_U[9])  ← moderate
d=1:  α · (W_U[8] · W_U[1])  ← small (distant digit, low similarity)
```

Digit 8 jumps to the top while the others rise by a smaller, digit-dependent amount. Adjacent digits (7, 9) get a bigger incidental lift than distant ones (0, 1) because the unembedding rows for nearby digits are more similar — a quiet but consistent geometric property of the LM head.

The minimum α needed to flip the prediction from "1" to "8":

```
α_min = (logit[1] − logit[8]) / (‖W_U[8]‖² − W_U[8] · W_U[1])
         ─────────────────────   ───────────────────────────
           how wrong the model     how much more 8 benefits
           is (the logit gap)      than 1 from the steering
```

The numerator is the logit gap — how confidently wrong the model is. The denominator is the differential boost — how much more digit 8 gains than digit 1. A large denominator means the steering is efficient; a small one means α has to grow to overcome the gap. Empirically across all digit positions, **median α_min ≈ 28–34**, which is why α = 50 corrects 93% of problems and α = 100 corrects all of them.

## Results

| Method | Direction | Layer | Max flip rate |
|---|---|---|---|
| One-shot injection | probe mean-diff | 4 | 1.2% |
| Every-step RepE PCA | probe PCA | 4 | 5.8% |
| Adaptive α (upper bound) | probe PCA | 4 | 9.8% |
| Oracle logit steering | `W_U[correct digit]` | 23 | **100%** |

The probe-based ceiling is roughly **10%**. The probe direction is globally trained and cannot adapt per digit or per problem — it captures *that the model is in trouble* but not *which digit it should produce*. The oracle direction is exact per step and achieves full correction at α = 100, but requires knowing the answer externally, which is exactly the thing that makes it not a useful real-world steering primitive.

## What this gives me

A clean separation between two things that are easy to confuse: a **readable** signal in the residual stream and a **controllable** lever on the model's output. Linear-probe AUC = 1.0 tells us the model's hidden state contains the difficulty information; the 9.8% probe-steering ceiling tells us that information isn't in the geometric form needed to *change* the next-digit prediction. The unembedding-row direction shows what *is* in that form — but you only know the right row if you already know the answer. The gap between probe and oracle is the gap between "the model knows it's about to fail" and "the model can be redirected to succeed," and it sets the agenda for the next stage: instead of one global probe direction, decompose the digit-step computation into per-position carry features and ask whether *those* are linearly addable to flip the answer.
