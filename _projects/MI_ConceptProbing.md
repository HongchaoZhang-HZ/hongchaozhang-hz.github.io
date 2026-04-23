---
layout: page
title: Concept Probing in Large LLMs
description: Where in a 2.7–14B transformer does a word-problem error actually originate? A matched-pair probing rig scales up across three sizes and puts every obvious hypothesis on trial.
img: assets/img/publication_preview/mi_phi2_relation.png
importance: 3
category: fun
related_publications: false
---

**Highlight.** When a large LLM answers a math word problem wrong, where does the error live? Four pre-registered representational hypotheses — binding failure, variable-category collapse, concept regression under error, and relation-representation collapse — each predict a gap between correct and incorrect probe curves. A clean matched-pair rig (same prompt, two different samples at T=0.7, one right and one wrong) holds everything else fixed so the probes can see that gap if it exists. Scaled across **three sizes (Phi-2 2.7B, Qwen-2.5-3B, Qwen-2.5-14B)** and two problems (farmer, ball), all four hypotheses are **rejected**: P1 silhouette gaps ≤ 0.09, P2 rename gaps ≤ 0.04, P3 macro-F1 gaps ≤ 0.03 across every cell. Relations are represented as **linear directions** in the residual stream — P3 saturates at 0.95–1.00 from the quarter-depth layer onward at every scale — and concept information is carried by those directions, not by Euclidean clusters. Whatever goes wrong at generation time lives downstream of the residual stream. One 14B cell (qwen14b_ball) shows the first faint representational error signature at 0.09 P1 gap — a lead for the next round.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_phi2_relation.png" title="Relation structure is near-perfectly linearly decodable from mid-depth onward on Phi-2. The same shape holds whether the completion is correct or incorrect — and holds across 3B and 14B Qwen." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Stage 1 — Matched-pair data collection and activation capture

An earlier grounded-vs-ungrounded contrast was confounded by off-topic divergence (ungrounded runs ran away from the problem altogether). This phase pivots to a cleaner contrast: **correct vs. incorrect on identical grounded prompts**, with both classes generated from the same input via stochastic sampling at T=0.7. This isolates reasoning-side variation from the rest of the decoding signal.

Three frozen models (Phi-2 2.7B, Qwen-2.5-3B, Qwen-2.5-14B-Instruct) on two problems (farmer: maximize rectangle area given perimeter; ball-drop: compute impact velocity from height). For each `(model, problem)` cell: 200 paraphrased prompts with axes varying variable names (5 variants), domain/context (4–5), and numeric values (5). Generate K=32 completions per paraphrase at T=0.7, max-new-tokens=512. Label each as correct / incorrect / off-topic by regex + numeric tolerance (1% farmer, 2% ball). For paraphrases with ≥1 correct and ≥1 incorrect sample, capture **all-layer residual-stream activations** (fp16, gzipped HDF5) via a teacher-forced forward pass on the prompt + canonical-pair tokens.

| Cell | Matched pairs | Match rate | Activations.h5 |
|---|---|---|---|
| phi2_farmer | 191 | 96% | 33 GB |
| phi2_ball | 200 | 100% | 32 GB |
| qwen3b_farmer | 195 | 98% | 29 GB |
| qwen3b_ball | 46* | 23% | 6.6 GB |
| qwen14b_farmer | — | — | (Qwen-14B cells) |
| qwen14b_ball | — | — |  |

*qwen3b_ball is under-counted, not under-achieving: 82% of samples labeled "off-topic" actually contain a correct `\boxed{X}` that the regex misses, and 65% hit the 512-token cap. Re-labeling (no re-sampling) lifts true yield past 150. Probes on the 46 retained pairs still return clean signals (P3 macro-F1 = 1.00).

## Stage 2a — Residual-space probes (P1, P1b, P2, P3)

Four pre-registered mechanistic probes applied per layer to each cell, run separately on the correct and incorrect members.

- **P1 — Within-variable clustering.** k-means (k=4) on residual vectors at variable-mention positions, scored by silhouette against gold role labels.
- **P1b — Across-category clustering.** Same silhouette test, now for the hypothesis that *variables collectively form a category* distinct from operators / numbers / other tokens. An anti-cluster result here kills the weaker fallback that P1 might be too fine-grained.
- **P2 — Concept-over-name invariance.** Cosine similarity of variable vectors across paraphrase pairs differing in one axis (variable name, role identity, or domain). A concept-based encoding predicts `rename ≈ domain >> role_swap`; a token-based encoding predicts the opposite.
- **P3 — Relation decoder.** L2-regularized logistic regression decoding operator-position relation type (perimeter-eq vs. area-eq vs. bound for farmer; kinematic-eq vs. sqrt-form for ball) per layer, using **5-fold GroupKFold by paraphrase** to block idiom leakage. Reports macro-F1.

### P1 and P1b — Variables are not Euclidean clusters at any depth

| Cell | P1 silhouette (L0 → L_last) | P1b across-category (L0 → L_last) |
|---|---|---|
| phi2_farmer | 0.32 → 0.08 | +0.13 → +0.03 (**negative at mid**) |
| qwen3b_farmer | 0.44 → 0.17 | +0.28 → +0.12 |
| qwen14b_farmer | 0.41 → 0.18 | +0.15 → +0.08 |
| qwen14b_ball | 0.55 → 0.36 (rises to 0.62 at L¼) | +0.15 → +0.06 |

Both clustering tests peak at L0 and **decline with depth** in every cell except qwen14b_ball, which briefly rises at L¼ before declining — the only cell showing anything resembling the textbook "middle-layer emergence" pattern, and still not close to the rest-of-network separations found in vision models. P1b goes *negative* for Phi-2 farmer in the middle layers: the variable category actively overlaps with other token categories there. The naive hypothesis "variables are encoded as a category of distance-separable points in a concept space" fails at every scale. **Concept information lives in linear directions, not in Euclidean clusters** — which is exactly what P3 is built to detect.

### P2 — Rename invariance strengthens with scale, but the output-layer regression is scale-invariant

| Cell | Rename peak (layer) | Rename final | Role-swap final | Verdict |
|---|---|---|---|---|
| phi2_farmer | 0.63 (L½) | 0.64 | 0.75 | token wins, gap −0.11 |
| qwen3b_farmer | **0.88 (L¾)** | 0.79 | 0.87 | token wins, gap −0.08 |
| qwen14b_farmer | 0.87 (L½) | 0.77 | **0.94** | token wins, **widest gap −0.17** |
| qwen14b_ball | **0.93 (L¾)** | 0.87 | — | mid-depth peak, partial regress |

Scale *strengthens* the role-invariant "length-variable" direction mid-depth (Phi-2 0.63 → Qwen-3B 0.88 → Qwen-14B 0.93 on ball). But at the final layer, `cos(rename) < cos(role_swap)` in every cell where role-swap is measured — token identity reasserts at output, and the rename/role-swap gap actually *widens* with scale on the farmer problem (−0.11 → −0.17). This regression is not a small-model artefact. Qwen-3B farmer illustrates the stakes: rename invariance at L¾ is 0.88 despite the model having a 0.34 behavioral name-spread in Stage 1 — name-binding lives downstream of the residual, and the conditional prediction filed in the spec fired exactly as written.

### P3 — Relations are linearly decodable at every scale, both sides

| Cell / side | L0 | L¼ | L_last | n |
|---|---|---|---|---|
| phi2_farmer / correct | 0.61 | **0.99** | 0.98 | 1086 |
| phi2_farmer / incorrect | 0.62 | 0.98 | 0.95 | 1161 |
| phi2_ball / correct | 0.36 | **1.00** | 1.00 | 699 |
| phi2_ball / incorrect | 0.35 | 1.00 | 1.00 | 763 |
| qwen3b_farmer / correct | 0.55 | 0.95 | 0.96 | 788 |
| qwen3b_farmer / incorrect | 0.53 | 0.98 | 0.98 | 867 |
| qwen14b_farmer / correct | 0.61 | **1.00** | 0.99 | 905 |
| qwen14b_ball / correct | 0.45 | **1.00** | 1.00 | 940 |

Relations saturate at macro-F1 ∈ [0.95, 1.00] from the quarter-depth layer onward, at every scale, on both correct and incorrect samples, on both problems. This is the strongest positive probe in the suite: **relations are encoded as explicit linear directions in residual space**, and the encoding is robust to scale and to error.

### All four pre-registered failure hypotheses are rejected

Correct-vs-incorrect gaps (max over layers) at every scale:

| Cell | P1 gap | P2 rename gap | P3 F1 gap |
|---|---|---|---|
| phi2_farmer | 0.01 | 0.00 | 0.03 |
| qwen3b_farmer | 0.02 | 0.01 | 0.02 |
| qwen14b_farmer | 0.05 | 0.03 | 0.01 |
| qwen14b_ball | **0.09** | 0.04 | 0.00 |

| Hypothesis | Predicted signature | Observed |
|---|---|---|
| Binding failure | P1 smears on incorrect | gap ≤ 0.09 — **rejected** |
| Variable-category collapse | P1b drops on incorrect | within 0.03 — **rejected** |
| Concept regression | P2 rename drops on incorrect | within 0.04 — **rejected** |
| Relation collapse | P3 F1 drops on incorrect | within 0.03 — **rejected** |

qwen14b_ball is the one cell where a P1 gap (0.09) crosses the noise floor — the first faint representational error signature at 14B on one problem. It is not by itself a positive result for any of the pre-registered hypotheses, but it is the only signal so far that says "the correct and incorrect sides differ in their residual-stream geometry." The other three cells say the residual-stream representation of the problem is identical on failing and succeeding runs.

## Phi-2 residual probing — layer-wise behavior and causal steering

On the farmer problem in a sibling experiment on Phi-2, layer-wise analysis shows relation structure decodable at macro-F1 ≈ 0.98 from layer 4 onward (33 layers total), and variable binding with role-swap cosine 0.80 vs. rename cosine 0.48 — lexical encoding near the output.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_concept_layers.png" title="Layer-wise variable binding in Phi-2 across all 33 layers on the farmer problem." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

Causal steering intervention at layer 8 (α = 4) lifts perimeter-equation emission from 0/20 to **4/20** — a real but partial causal handle. Steering at layer 16 produces no behavioral effect — a "dead zone" where the relation-structure signal is present but no longer consumed downstream.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_concept_steer.png" title="Causal steering at L8 with perimeter-equation injection, alpha sweep. 4/20 emissions at alpha=4; L16 is a dead zone." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## What this gives me

A negative result sharpened by scaling. Word-problem errors in 2.7–14B LLMs don't live in the residual-stream representation of the problem: the variables, the concept abstractions, and the relation structure all survive intact on failing runs, and match the structure on succeeding runs to within probe noise. The concept-as-linear-direction framing is scale-robust — both the cluster hypotheses fail at every size, both the relation-decoder succeeds at every size. The output-layer rename-vs-role-swap regression is scale-invariant and actually widens on the farmer problem at 14B, arguing that whatever re-tokenizes the variable at generation time is a load-bearing part of the architecture, not an artefact of small models. qwen14b_ball's P1 gap of 0.09 is the first hint that representational error signatures might exist at 14B on some problems; that's the lead into the next round of probes, which push into MLP activations and attention heads to ask where the downstream arithmetic / binding / decoding step actually breaks.
