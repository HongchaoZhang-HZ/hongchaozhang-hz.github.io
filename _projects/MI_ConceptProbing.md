---
layout: page
title: Concept Probing in Large LLMs
description: Where in a 2–3B transformer does a word-problem error actually originate? A matched-pair probing rig puts every obvious hypothesis on trial.
img: assets/img/publication_preview/mi_phi2_relation.png
importance: 3
category: fun
related_publications: false
---

**Highlight.** When a 2–3B LLM answers a math word problem wrong, where does the error live? Three pre-registered hypotheses — binding failure, concept regression, relation collapse — each predict a gap between correct and incorrect probe curves. A clean matched-pair dataset (same prompt, two different samples at T=0.7, one right and one wrong) holds everything else fixed so the probes can see that gap if it exists. **It doesn't.** All three probes show superimposable correct-vs-incorrect curves within 0.02–0.03. By elimination, whatever goes wrong lives downstream of the residual stream — in arithmetic, value binding, or final decoding — not in the represented concepts. This is the negative result that splits "the model misunderstood the problem" from "the model computed the wrong number."

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_phi2_relation.png" title="Relation structure is near-perfectly decodable from mid-depth onward on Phi-2. The shape is identical whether the completion is correct or incorrect." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Stage 1 — Matched-pair data collection and activation capture

An earlier grounded-vs-ungrounded contrast was confounded by off-topic divergence (ungrounded runs ran away from the problem altogether). This phase pivots to a cleaner contrast: **correct vs. incorrect on identical grounded prompts**, with both classes generated from the same input via stochastic sampling at T=0.7.

Two 2.7–3.1B models (Phi-2, Qwen2.5-3B) on two problems (farmer: maximize rectangle area given perimeter; ball-drop: compute impact velocity from height). For each `(model, problem)` cell: 200 paraphrased prompts with axes varying variable names (5 variants), domain/context (4–5), and numeric values (5). Generate K=32 completions per paraphrase at T=0.7, max-new-tokens=512. Label each as correct / incorrect / off-topic by regex and numeric tolerance (1% farmer, 2% ball). For paraphrases with ≥1 correct and ≥1 incorrect sample, capture **all-layer residual-stream activations** (fp16, gzipped HDF5) via teacher-forced forward pass on the prompt + canonical-pair tokens.

| Cell | Matched pairs | Match rate | Activations.h5 |
|---|---|---|---|
| phi2_farmer | 191 | 96% | 33 GB |
| phi2_ball | 200 | 100% | 32 GB |
| qwen3b_farmer | 195 | 98% | 29 GB |
| qwen3b_ball | 46* | 23% | 6.6 GB |
| **total** | **~632** | | **~100 GB** |

*qwen3b_ball is an under-count: 82% of samples labeled "off-topic" actually contain a correct `\boxed{X}` that the regex misses, and 65% hit the 512-token cap. Re-labeling (no re-sampling) lifts true yield past 150.

## Stage 2a — Residual-space probes (P1, P2, P3)

Three pre-registered mechanistic probes applied per layer to each matched-pair cell, run separately on the correct and incorrect members.

- **P1 — Variable clustering.** k-means (k=4) on residual vectors at variable-mention positions, scored by silhouette against gold role labels.
- **P2 — Concept-over-name invariance.** Cosine similarity of variable vectors across paraphrase pairs differing in one axis (variable name, role identity, or domain). A concept-based encoding predicts `rename ≈ domain >> role_swap`; a token-based encoding predicts the opposite.
- **P3 — Relation decoder.** L2-regularized logistic regression decoding operator-position relation type (perimeter-eq vs. area-eq vs. bound for farmer; kinematic-eq vs. sqrt-form for ball) per layer, using **5-fold GroupKFold by paraphrase** to block idiom leakage. Reports macro-F1.

### P1 — Variables are distinct at L0 and *decay* with depth

| Cell | L0 | L¼ | L½ | L¾ | L_last |
|---|---|---|---|---|---|
| phi2_farmer | 0.32 | 0.19 | 0.17 | 0.12 | 0.08 |
| phi2_ball | 0.64 | 0.48 | 0.43 | 0.36 | 0.25 |
| qwen3b_farmer | 0.44 | 0.37 | 0.35 | 0.28 | 0.17 |
| qwen3b_ball | 0.65 | 0.52 | 0.52 | 0.37 | 0.11 |

Silhouette exceeds the 0.3 threshold at L0 in every cell and monotonically declines with depth — the opposite of the predicted middle-layer emergence pattern. **Variable distinctness at the residual is tokenizer-driven, not computed.** Incorrect-side curves are within 0.02 of correct everywhere.

### P2 — Concept abstraction forms mid-depth, regresses at output

| Cell | Rename peak (layer) | Rename final | Role-swap final | Domain-swap final |
|---|---|---|---|---|
| phi2_farmer | 0.63 (L½) | 0.64 | 0.75 | 0.74 |
| phi2_ball | 0.82 (L¼) | 0.71 | — | 0.72 |
| qwen3b_farmer | **0.88 (L¾)** | 0.79 | 0.87 | 0.86 |
| qwen3b_ball | **0.88 (L½)** | 0.52 | — | 0.89 |

At the final layer, `rename < role_swap` in every cell where role-swap is measured — token identity *reasserts* at output. Qwen3b_farmer has 0.88 rename invariance despite only 0.34 behavioral name-spread — so name-binding lives downstream of the residual.

### P3 — Relations are near-perfectly linearly decodable

| Cell | Side | L0 | L¼ | L½ | L¾ | L_last | n |
|---|---|---|---|---|---|---|---|
| phi2_farmer | correct | 0.61 | 0.99 | 0.99 | 0.98 | 0.98 | 1086 |
| phi2_farmer | incorrect | 0.62 | 0.98 | 0.98 | 0.98 | 0.95 | 1161 |
| phi2_ball | correct | 0.36 | 1.00 | 1.00 | 1.00 | 1.00 | 699 |
| phi2_ball | incorrect | 0.35 | 1.00 | 1.00 | 1.00 | 1.00 | 763 |
| qwen3b_farmer | correct | 0.55 | 0.95 | 0.94 | 0.96 | 0.96 | 788 |
| qwen3b_farmer | incorrect | 0.53 | 0.98 | 0.98 | 0.98 | 0.98 | 867 |
| qwen3b_ball | correct | 0.43 | 1.00 | 1.00 | 1.00 | 0.98 | 170 |
| qwen3b_ball | incorrect | 0.40 | 1.00 | 1.00 | 0.99 | 0.99 | 83 |

Relations hit macro-F1 ∈ [0.95, 1.00] across all cells from the quarter-depth layer onward, and **the correct–incorrect delta never exceeds 0.03**.

### All three pre-registered failure hypotheses are rejected

| Hypothesis | Predicted signature | Observed |
|---|---|---|
| Binding failure | P1 smears on incorrect | within 0.02 — **rejected** |
| Concept regression | P2 rename drops on incorrect | within 0.02 — **rejected** |
| Relation collapse | P3 F1 drops on incorrect | within 0.03 — **rejected** |

## Phi-2 residual probing — layer-wise behavior and causal steering

On the farmer problem in a sibling experiment on Phi-2, layer-wise analysis shows relation structure decodable at macro-F1 ≈ 0.98 from layer 4 onward (33 layers total), and variable binding with role-swap cosine 0.80 vs. rename 0.48 — lexical encoding near output.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_concept_layers.png" title="Layer-wise variable binding in Phi-2 across all 33 layers on the farmer problem." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

Causal steering intervention at layer 8 (α = 4) lifts perimeter-equation emission from 0 / 20 to **4 / 20** — a real but partial causal handle. Steering at layer 16 produces no behavioral effect — a "dead zone" where the relation-structure signal is present but no longer consumed downstream.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_concept_steer.png" title="Causal steering at L8 with perimeter-equation injection, alpha sweep. 4/20 emissions at alpha=4; L16 is a dead zone." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## What this gives me

A negative result sharper than a positive one. Word-problem errors in 2–3B LLMs don't live in the residual-stream representation of the problem: the variables, the concept abstractions, and the relation structure all survive intact through the network on failing runs, and match the structure on succeeding runs to within probe noise. That pushes the search downstream — into MLPs, attention heads, and the final decoding path — and gives a clean target for the next round of mechanistic probes. It also lines up with the computation–comprehension gap from the Stage-4 optimization work in the sibling thread: the model understood the problem; it just failed to compute with that understanding.
