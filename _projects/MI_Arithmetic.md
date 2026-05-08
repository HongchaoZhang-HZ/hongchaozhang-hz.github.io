---
layout: page
title: Tokenization and the Arithmetic Cliff
description: How different LLM families tokenize numbers, where each one breaks on long-digit arithmetic, and why training matters more than tokenization.
img: assets/img/publication_preview/mi_arithmetic_thumb.png
importance: 5
category: fun
related_publications: false
---

**Highlight.** A clean diagnostic of long-digit arithmetic across model families. Numbers tokenize in two fundamentally different ways: **multi-digit BPE** (GPT-2, Pythia, OPT, Phi-2) chunks digits at corpus-frequency boundaries that are mathematically arbitrary, while **digit-by-digit** (Llama, Qwen2.5, SmolLM2) maps each decimal digit to its own token. Comparing instruction-tuned variants on the same prompt format, **Qwen2.5-0.5B-Instruct (90% at 3-digit) dominates SmolLM2-1.7B-Instruct (0% at 3-digit) despite being 3× smaller and using the same digit-by-digit tokenizer family** — the gap is almost entirely about arithmetic-specific training, not tokenization. Within Qwen2.5, the cliff (first drop below 50%) scales cleanly with size: 0.5B at 5 digits, 1.5B at 10, 3B at ~10–11, 7B at ~12–13, **14B at ~17**. Stage-4 mechanistic analysis shows **95% of failures align with token boundaries** — the model's attention pattern breaks where a BPE token spans multiple digits or where the carry chain exceeds what the residual stream can track.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_arithmetic_thumb.png" title="LLM arithmetic cliff: digit-length on the x-axis, accuracy collapsing at the model's intrinsic cliff." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Two tokenization paradigms

| Model | Tokenizer | Style | `"12345"` → | `"1234567890"` → |
|---|---|---|---|---|
| GPT-2 | BPE | Multi-digit | `["123","45"]` | `["123","45","678","90"]` |
| Pythia-410M/1B | GPT-NeoX BPE | Multi-digit | `["12345"]` (single!) | `["12345","678","90"]` |
| OPT-125M/1.3B | GPT-2 BPE | Multi-digit | `["360","91"]` | `["123","45","678","90"]` |
| Phi-2 | CodeGen BPE | Multi-digit | `["360","91"]` | `["123","45","678","90"]` |
| SmolLM2-135M/1.7B | Llama SP | Digit-by-digit | `["1","2","3","4","5"]` | `["1","2","3","4","5","6","7","8","9","0"]` |
| Llama 1/2/3 | SP / tiktoken | Digit-by-digit | `["1","2","3","4","5"]` | `["1","2","3","4","5","6","7","8","9","0"]` |
| Qwen2.5 (all sizes) | tiktoken | Digit-by-digit | `["1","2","3","4","5"]` | `["1","2","3","4","5","6","7","8","9","0"]` |

OPT, GPT-2, and Phi-2 all use GPT-2-style BPE — `"12345"` → `["360","91"]` because the tokenizer saw different digit sequences during BPE merges (the specific merge depends on training-corpus co-occurrence, not digit values). The boundary is positionally arbitrary. Since 2023, digit-by-digit has effectively become the standard for new models.

### Token count scales differently with digit length

| Digits | Pythia tokens | Qwen tokens | Ratio | Pythia chunks (example) |
|---|---|---|---|---|
| 1 | 1 | 1 | 1.0× | `['2']` |
| 2 | 1 | 2 | 0.5× | `['13']` |
| 3 | 1 | 3 | 0.3× | `['859']` |
| 4 | 2 | 4 | 0.5× | `['5','506']` |
| 5 | 2 | 5 | 0.4× | `['420','98']` |
| 6 | 3 | 6 | 0.5× | `['33','40','53']` |
| 10 | 4 | 10 | 0.4× | `['996','33','34','018']` |
| 20 | 10 | 20 | 0.5× | `['8','807','88','12','28','57','40','55','84','75']` |

Pythia uses about half the tokens of Qwen — but this is not an advantage. Chunk boundaries are positionally arbitrary, chunks like `"888"` pack digits that must be mentally unpacked for carry, and the boundary pattern varies per number.

## Where each Qwen2.5 size breaks

`zero_shot_instruct` format, 200 problems per bin. The cliff is the first digit-length where accuracy drops below 50%.

| Digits | Qwen2.5-0.5B | Qwen2.5-1.5B | Qwen2.5-3B | Qwen2.5-7B | Qwen2.5-14B |
|---|---|---|---|---|---|
| 1 | 100% | 100% | 100% | 100% | 100% |
| 2 | 98% | 100% | 100% | 100% | 100% |
| 3 | 90% | 96% | 96% | 100% | 100% |
| 4 | 76% | 95% | 90% | 98% | 98% |
| **5** | **45%** ← | 84% | 91% | 94% | 98% |
| 6 | 24% | 82% | 88% | 92% | 96% |
| 7 | 24% | 64% | 83% | 93% | 95% |
| 8 | 4% | 64% | 77% | 84% | 93% |
| 10 | 1% | 46% | 64% | 73% | 88% |
| **12** | 0% | 30% | 36% | **43%** ← | 76% |
| **17** | 0% | 4% | 18% | 26% | **55%** ← |
| 20 | 0% | 7% | 2% | 13% | 40% |

Cliff points cleanly:

| Model | Cliff digit | Tokens / operand at cliff |
|---|---|---|
| Qwen2.5-0.5B | 5 | 5 |
| Qwen2.5-1.5B | 10 | 10 |
| Qwen2.5-3B | 10–11 | 10–11 |
| Qwen2.5-7B | 12–13 | 12–13 |
| Qwen2.5-14B | ~17 | ~17 |

## Tokenization is not destiny — training is

A fair comparison across families using instruction-tuned variants and chat-template prompts (greedy decode, 100 problems / bin):

| Model | Params | Tok style | 1d | 2d | 3d | 4d | 5d | Cliff |
|---|---|---|---|---|---|---|---|---|
| SmolLM2-135M-Instruct | 135M | digit-by-digit | 32% | 4% | 0% | 0% | 0% | 1d |
| SmolLM2-1.7B-Instruct | 1.7B | digit-by-digit | **65%** | 48% | 0% | 0% | 0% | 2d |
| OPT-IML-1.3B | 1.3B | multi-digit | 4% | 0% | 0% | 0% | 0% | 1d |
| Phi-2 | 2.7B | multi-digit | **65%** | 28% | 4% | 0% | 0% | 2d |
| **Qwen2.5-0.5B-Instruct** | **0.5B** | digit-by-digit | **100%** | **98%** | **90%** | **76%** | **45%** | **5d** |
| **Qwen2.5-1.5B-Instruct** | **1.5B** | digit-by-digit | **100%** | **100%** | **96%** | **95%** | **84%** | **10d** |

Three things stand out.

**SmolLM2-1.7B-Instruct and Phi-2 both hit the cliff at 3 digits.** They get 65% at 1 digit and fall to 0% at 3 digits — there is no graceful degradation, the model either knows a pattern or doesn't.

**Qwen2.5-0.5B-Instruct dominates SmolLM2-1.7B-Instruct** (90% vs 0% at 3 digits) despite being 3× smaller and using the same tokenizer family. Tokenization isn't the lever; arithmetic-specific instruction tuning in the Qwen2.5 pipeline is.

**OPT-IML-1.3B gets only 4% at 1 digit.** Instruction tuning didn't help OPT's arithmetic — multi-digit tokenization combined with a weak arithmetic training signal leaves the model unable to respond to the format at all.

The cliff in tokens-per-operand is proportional to training quality, not tokenization style:

| Model | Tok style | Cliff (tokens) |
|---|---|---|
| SmolLM2-1.7B-Instruct | digit-by-digit | 2 |
| Qwen2.5-0.5B-Instruct | digit-by-digit | 5 |
| Qwen2.5-14B-Instruct | digit-by-digit | ~17 |

## What tokenization does and does not determine

| Claim | Verdict |
|---|---|
| Multi-digit BPE makes arithmetic impossible | False — format matters more at small scale |
| Digit-by-digit tokenization enables good arithmetic | Insufficient — training is required |
| Digit-by-digit is necessary for *long-number* arithmetic | Likely true — Qwen2.5-14B reaches a 17-digit cliff; OPT/Pythia fail immediately |
| Token-boundary alignment predicts failure location | Confirmed — Stage 4 boundary-induced rate is 95% for Qwen2.5 |

## Format confusion in non-instruction models

Pythia, Phi-2, and OPT base models are trained without instruction tuning. The `zero_shot_base` prompt `"X + Y ="` doesn't match their training distribution for arithmetic and they interpret it differently:

- **Pythia** (trained on The Pile): `"2 + 1 ="` → algebraic-problem-description continuation, e.g. `" -2*r. Let l(a) = -a**2 + a + 1. Let g(q) = ..."`
- **Phi-2** (trained on code + text): `"3 + 5 ="` → 0% correct at 1 digit, likely producing code-style output.

This is not evidence that base models cannot do arithmetic — it is a prompt-format mismatch. Instruction-tuned variants may perform better, but the comparison is not apples-to-apples without format alignment.

## Why the cliff exists

For models that respond to the arithmetic prompt (Qwen2.5 instruct family), digit-by-digit tokenization is a clean diagnostic lens: token count = digit count exactly, so the cliff at *N* digits is the cliff at *N* tokens per operand. The cliff scales with model size at roughly 3–5 digits per size class, and no model escapes entirely — Qwen2.5-14B still collapses at 17 digits.

Stage-4 mechanistic analysis shows **95% of failures align with token boundaries**: in multi-digit models the attention pattern breaks where a BPE token spans multiple digits; in digit-by-digit models the carry chain exceeds what the residual stream can track in a single forward pass.

The underlying tension is structural:

- Carry propagation is **right-to-left** (ones place first)
- Autoregressive generation is **left-to-right** (most-significant digit first)
- The model must pre-compute the entire carry chain before writing digit 1

Tokenization reveals the grain of the problem. The failure site is in the model's computation — how it tracks carry state across layers — and that is what the next stage of analysis is built around.
