---
layout: page
title: LLM Internals for Math Reasoning
description: Does the Fourier structure that explains grokking in toy models show up inside pre-trained LLMs — and if so, why don't they generalize?
img: assets/img/publication_preview/mi_llm_dft_bars.png
importance: 2
category: fun
related_publications: false
---

**Highlight.** Running Fourier probes on pre-trained Pythia, Qwen2.5, and SmolLM2 reveals weak but real structure — concentrations 3–5× above random — and this structure correlates almost perfectly with behavioral accuracy (r = 0.99 on Qwen). But the same additive Fourier basis is used for both addition and multiplication: representational structure transfers from toy grokking to real LLMs; **algorithmic basis differentiation does not**. Fine-tuning a small LLM into toy-grokked representation levels still tops out at 20% generation accuracy — the embeddings move, the rest of the network doesn't. Across six stages, I traced where arithmetic commits, how prompt scaffolds unlock latent capability, and why understanding — not computation — is the binding constraint for word-problem reasoning at this scale.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_llm_dft_bars.png" title="Value-indexed DFT top-5 concentration across pre-trained models vs. a toy grokked baseline. LLMs sit 3–5x above random but an order of magnitude below the grokked toy." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Stage 1 — Probing: do pre-trained LLMs use the Fourier structure at all?

Linear probes on frozen Pythia (70M–410M), Qwen2.5-0.5B-Instruct, and SmolLM2-135M-Instruct predict `(a OP b) mod 59` from token embeddings and residual streams. Value-indexed DFT analysis measures additive (natural) and multiplicative (discrete-log) Fourier structure per layer.

| Model | Params | Add nat | Add dlog | Mul nat | Mul dlog | Gen acc (add) |
|---|---|---|---|---|---|---|
| Pythia-70M | 70M | 0.355 | 0.197 | 0.378 | 0.194 | 0.03% |
| Pythia-160M | 160M | 0.382 | 0.225 | 0.374 | 0.233 | — |
| Pythia-410M | 410M | 0.398 | 0.203 | 0.352 | 0.228 | 0.00% |
| **Qwen2.5-0.5B-Instruct** | 500M | **0.450** | 0.321 | **0.474** | 0.276 | **45.2%** |
| SmolLM2-135M-Instruct | 135M | 0.373 | 0.239 | 0.342 | 0.257 | 3.9% |
| Random baseline | — | 0.085 | 0.085 | 0.085 | 0.085 | — |
| Toy grokked | <500k | **0.976** | 0.095 | 0.105 | **0.555** | 100% |

DFT concentration correlates r = 0.994 with addition generation accuracy on Qwen, r = 0.972 on multiplication.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_llm_acc_vs_dft.png" title="Generation accuracy vs. value-indexed DFT concentration across models — nearly perfect correlation." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

The big negative finding: LLMs use additive DFT for *both* addition and multiplication, unlike toy models that grok into distinct bases (natural for `+`, discrete-log for `·`). Structural dimensionality transfers; operation-specialized representations do not.

Fine-tuning Pythia-70M for 60 epochs with the Fourier surrogate loss (λ=1) pushes DFT-nat from 0.38 to **0.957** — toy-grokked levels — but behavioral accuracy caps at 20.3% before collapsing. **The manifold is reachable; the rest of the network isn't wired to use it.**

## Stage 2 — Multi-token: where does arithmetic actually commit?

Qwen reaches 41% generation accuracy on addition, but a logit lens reads only 11% at the `=` token. So where is the answer committed? Position-conditioned teacher-forced probing finds the compute offset — the first non-trivial position where accuracy drops below 95%.

| Model | Compute offset | Off 0 | Off 1 | Off 2 | Off 3 | Gen acc |
|---|---|---|---|---|---|---|
| Pythia family | 0 | **0.000** | — | — | — | 0% |
| Qwen2.5-0.5B | 1 | 1.000 | **0.500** | 0.856 | 1.000 | **45.2%** |
| SmolLM2-135M | 1 | 1.000 | **0.100** | 0.526 | 0.833 | 3.9% |

Arithmetic commits not at `=` but at the position of the first answer digit — offset 0 for Pythia (single-token numbers) and offset 1 for Qwen/SmolLM (digit-split tokenizers). Compute-offset accuracy correlates r = 0.993 with generation accuracy.

Two surprises: (i) chain-of-thought slightly **hurts** plain arithmetic (37% → 32% strict) by fragmenting the answer stream. (ii) Carries are handled holistically (carry 47.3% vs no-carry 42.3% on 3,481 Qwen pairs) — not digit-by-digit as a naive independence hypothesis would predict.

## Stage 3 — Tool: prompting scaffolds unlock latent capability

Six template variants (plain, marker-only, chat, CoT tags, few-shot, tool-mention) tested on p=59 addition and multiplication, with Pythia-base as an instruction-tuning-free control.

| Model | T0 plain | T1 marker | T2 chat | T3 CoT | T4 few-shot | T5 tool |
|---|---|---|---|---|---|---|
| Pythia-410M | 0% | 0% | 2% | 0% | 1% | 0% |
| **Qwen2.5-0.5B** | 37% | 33% | **91%** | 74% | **100%** | **100%** |
| SmolLM2-135M | 4% | 0% | 3% | 0% | **69%** | 1% |

Few-shot examples (T4) and native chat format (T2) unlock Qwen to 91–100%; Pythia stays near zero across every template. **Instruction tuning is a floor, not a ceiling.** Structural priming lifts residual-stream DFT-nat by +15pp (T0 0.48 → T4 0.63). Multiplication is harder — 86% vs 100% for addition — and all failures on products ≥ 696 are middle-digit interpolation errors.

## Stage 4 — Opt: computation vs. comprehension in optimization

Four-stage reasoning pipeline — extract → formulate → derive → code — on Qwen2.5-0.5B / 1.5B / 3B across 15 optimization word problems, with Lean 4 verification of derived claims.

| Stage | What it tests | Qwen-0.5B | Qwen-1.5B | Qwen-3B |
|---|---|---|---|---|
| Understand | Identify objective / vars / constraints | 90% | 100% | 70% |
| Reason | CoT derivation | 93% | 87% | 93% |
| Lean verify | Ground-truth claims compile | 100% | 100% | 100% |
| Code | Executable + correct | **10%** | **70%** | **90%** |

Computation scales steeply with size (10% → 90% S4 Code from 0.5B to 3B); understanding plateaus. Three independent failure modes on the farmer problem: omission (misses `L > 0`, `L ≤ 50`), fabrication (invents `x > y`), incompleteness (weak global-optimality proofs). Given the equation directly, Qwen-3B codes the solution 100% of the time; given the word problem, only 2 of 8 formulations are correct. **Comprehension of implicit constraints — not mathematical ability — is the binding constraint.**

## Stage 5 — Form-opt bench: measuring the gap itself

Designed a 3-dimensional benchmark over 20 problems × 4 tiers with explicitly annotated implicit constraints, fabrication traps, and consistency checks. Scoring axes: D1 — implicit condition recall; D2 — fabrication rate; D3 — internal contradiction. Positioned as a response to the 18pp gap between 90% solve accuracy and 72% formulation quality found in Stage 4. Implementation in progress.

## Stage 6 — Reason-gnd: grounding via domain axioms

Three optimization problems (kinematics, farmer, cost) in two conditions: ungrounded (text only) and grounded (text + domain axioms: governing equations, constants, physical constraints). Gold standard via quantifier elimination in SymPy. Seven models from 0.5B to 3B.

| Model | Params | Δ Solve | Δ Constraint recall | Δ Physics |
|---|---|---|---|---|
| Qwen2.5-0.5B | 0.5B | +0/3 | +13% | +0% |
| TinyLlama-1.1B | 1.1B | +1/3 | +7% | +0% |
| Qwen2.5-1.5B | 1.5B | +0/3 | +0% | +0% |
| StableLM-1.6B | 1.6B | +0/3 | +20% | +33% |
| SmolLM2-1.7B | 1.7B | −1/3 | +27% | +33% |
| **Phi-2** | **2.7B** | **+2/3** | **+73%** | **+33%** |
| Qwen2.5-3B | 3B | **−2/3** | +0% | +0% |

Grounding improves constraint recall by +20% on average but solve accuracy is flat. Phi-2's effect is striking — 0/3 → 2/3 solve, +73% recall — while Qwen2.5-3B paradoxically degrades, suggesting larger models already know the domains and external axioms interfere. No model exceeds 73% recall; derived bounds (`L ≤ 50`, `t ≤ 4.08`) are consistently missed — no bound tightening happens in any condition.

Phi-2 residual probing in this stage sets up the handoff to the concept-probing thread: relation structure is linearly decodable at macro-F1 ≈ 0.98 from layer 4 onward; variable binding shows role-swap cosine 0.80 vs. rename cosine 0.48 (lexical encoding); an α = 4 steering intervention at layer 8 lifts perimeter-equation emission from 0/20 to 4/20; at layer 16 the effect is a dead zone.

## What this gives me

Pre-trained LLMs carry the same *kind* of structure that grokked toy models use, detectable with the same probes, correlating with behavior the same way. But specialization, scaffolding dependence, and the computation–comprehension gap all show up at scale. The next move — taken up in the concept-probing thread — is to ask whether the failures live in the represented concepts themselves or somewhere downstream.
