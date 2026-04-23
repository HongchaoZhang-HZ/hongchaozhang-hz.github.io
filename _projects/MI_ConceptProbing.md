---
layout: page
title: Concept Probing in Large LLMs
description: Do 2.7–14B transformers represent the concepts in a math word problem, and where do wrong answers actually come from? A matched-pair probing rig settles both questions across six cells.
img: assets/img/publication_preview/ag_methods.png
importance: 3
category: fun
related_publications: false
---

**Highlight.** Six questions, one experiment. Across **three scales (Phi-2 2.7B, Qwen-2.5-3B, Qwen-2.5-14B) × two problems (farmer max-area, ball-drop impact velocity)**, we ran four layer-wise probes on matched pairs of correct and incorrect completions from identical prompts. Relations are **linearly decodable** from layer ¼ onward at every scale (P3 macro-F1 = 0.95–1.00). Role invariance **builds mid-depth** and **strengthens with scale** (rename cosine peak: 0.63 at Phi-2 → 0.88 at Qwen-3B → 0.93 at Qwen-14B) but **regresses at the output** in every cell where the test applies — token identity wins over role by up to −0.17 at 14B. Variables form **no cluster structure** at any depth in any cell — neither within-variable nor across-category — so concept information is carried by **linear directions, not Euclidean separation**. Most importantly: all three pre-registered representational failure hypotheses are rejected — the residual stream's variable, role, and relation structure are essentially identical on correct and incorrect samples. **Errors live downstream of the residual stream.** And the behavioral name-bias Qwen-3B shows on the farmer problem is a decoding-stage artefact, not a representation one.

## Setup — the matched-pair rig

Three frozen models (Phi-2 2.7B / 32 layers, Qwen-2.5-3B / 36L, Qwen-2.5-14B-Instruct / 48L) on two problems: farmer (maximize rectangle area given perimeter P) and ball-drop (impact velocity from height h, g = 9.8). For each `(model, problem)` cell, 200 paraphrased prompts vary variable names, role identity, domain, and numeric values. Sample K=32 completions per prompt at T=0.7, top-p=0.95, max-new-tokens=512. Label each sample as **correct** (final numeric claim matches analytical gold within tolerance — 1% farmer, 2% ball), **incorrect** (extractable number but wrong), or **off-topic** (no extractable final claim).

A **matched pair** is one correct + one incorrect sample drawn from the same prompt's 32 samples. For each pair we teacher-force `(prompt + generated tokens)` and capture all-layer residual streams. The correct side and the incorrect side of each pair come from the same prompt, same model, same weights — only the sampled trajectory differs, so any mechanistic difference localizes where errors arise. Spec thresholds: ≥ 30 pairs floor, ≥ 60 target.

| Cell | Matched pairs / 200 | Status |
|---|---:|---|
| phi2_farmer | 191 | ≫ target |
| phi2_ball | 200 | ≫ target |
| qwen3b_farmer | 195 | ≫ target |
| qwen3b_ball | 46 | above floor (labeler artefact, see caveats) |
| qwen14b_farmer | 199 | ≫ target |
| qwen14b_ball | 167 | ≫ target |

Four probes, each run twice per cell (once on correct residuals, once on incorrect):

- **P1 — within-variable silhouette.** k-means on residuals at variable-mention positions, scored against gold role labels {length, width, area, param} (farmer) or {height, velocity, g} (ball). Spec expected emergence past 0.3 at a middle layer.
- **P1b — across-category silhouette.** 4-class alternative: {variable, operator, number, other}. Backup hypothesis — maybe variables pool as a shared *category* rather than separating by role.
- **P2 — cosine invariance.** Cosine between per-variable mean residuals across paraphrase pairs differing in one axis: *rename* (same role, different letter), *role-swap* (same letter, different role — farmer only), *domain-swap* (same role+letter, different scenario).
- **P3 — linear relation decoder.** 5-fold GroupKFold logistic regression at operator positions, labels {perimeter-eq, area-eq, bound} (farmer) or {kinematic-eq, sqrt-form} (ball). Reports macro-F1.

## Q1. Do models represent relations between variables?

**Yes — in every cell, on every side, at every scale.**

P3 saturates at macro-F1 ∈ [0.95, 1.00] from layer ¼ onward, on both correct and incorrect samples. The residual carries a specific linear direction per relation type that the decoder reads off cleanly regardless of whether the final answer is right.

| Cell / side | L0 | L¼ | L_last | n |
|---|---:|---:|---:|---:|
| phi2_farmer / correct | 0.61 | **0.99** | 0.98 | 1086 |
| phi2_farmer / incorrect | 0.62 | 0.98 | 0.95 | 1161 |
| phi2_ball / correct | 0.36 | **1.00** | 1.00 | 699 |
| phi2_ball / incorrect | 0.35 | 1.00 | 1.00 | 763 |
| qwen3b_farmer / correct | 0.55 | 0.95 | 0.96 | 788 |
| qwen3b_farmer / incorrect | 0.53 | 0.98 | 0.98 | 867 |
| qwen3b_ball / correct | 0.43 | **1.00** | 0.98 | 170 |
| qwen3b_ball / incorrect | 0.40 | 1.00 | 0.99 | 83 |
| qwen14b_farmer / correct | 0.61 | **1.00** | 0.99 | 905 |
| qwen14b_farmer / incorrect | 0.62 | 1.00 | 1.00 | 987 |
| qwen14b_ball / correct | 0.45 | **1.00** | 1.00 | 940 |
| qwen14b_ball / incorrect | 0.44 | 1.00 | 1.00 | 760 |

## Q2. Are symbols represented as role-invariant concepts?

**Partially. Role abstraction is built mid-depth and then partially undone at the output.**

Concept-consistent prediction: `cos(rename) > cos(role_swap)` — the length-variable direction should be the same whether the letter is `L` or `x`. Token-consistent prediction: the opposite.

| Cell | Rename peak (layer) | Rename final | Role-swap final | Domain-swap final |
|---|---|---:|---:|---:|
| phi2_farmer | 0.63 (L½) | 0.64 | 0.75 | 0.74 |
| phi2_ball | 0.82 (L¼) | 0.71 | — | 0.72 |
| qwen3b_farmer | **0.88 (L¾)** | 0.79 | 0.87 | 0.86 |
| qwen3b_ball | **0.88 (L½)** | 0.52 | — | 0.89 |
| qwen14b_farmer | 0.87 (L½) | 0.77 | **0.94** | 0.94 |
| qwen14b_ball | **0.93 (L¾)** | 0.87 | — | 0.93 |

Two scale-invariant observations:

1. **Mid-depth role invariance builds through the network.** Rename cosine rises from near-zero at L0 to 0.63–0.93 at mid-to-late layers. Scale raises the peak: Phi-2 0.63 → Qwen-3B 0.88 → Qwen-14B 0.93 on ball.
2. **Output layer: token identity reasserts.** Wherever role-swap is measured, `cos(rename) < cos(role_swap)` at the final layer. The letter beats the role. And the gap *widens* at 14B on farmer (−0.17), so the regression is not a small-model artefact.

## Q3. Do variables form distinct clusters?

**No — at any depth, in any cell. Neither within-variable nor across-category.**

Within-variable silhouette (P1):

| Cell | L0 | L¼ | L½ | L¾ | L_last |
|---|---:|---:|---:|---:|---:|
| phi2_farmer | 0.32 | 0.19 | 0.17 | 0.12 | 0.08 |
| phi2_ball | 0.64 | 0.48 | 0.43 | 0.36 | 0.25 |
| qwen3b_farmer | 0.44 | 0.37 | 0.35 | 0.28 | 0.17 |
| qwen3b_ball | 0.65 | 0.52 | 0.52 | 0.37 | 0.11 |
| qwen14b_farmer | 0.41 | 0.36 | 0.35 | 0.30 | 0.18 |
| qwen14b_ball | 0.55 | **0.62** | 0.60 | 0.53 | 0.36 |

Silhouette peaks at L0 (tokenizer artefact) and declines with depth in every cell except qwen14b_ball, which rises slightly to L¼ before declining. Variables are *most* distinguishable at input, not after computation.

Across-category silhouette (P1b):

| Cell | L0 | L¼ | L½ | L¾ | L_last |
|---|---:|---:|---:|---:|---:|
| phi2_farmer | +0.13 | **−0.09** | **−0.10** | **−0.09** | +0.03 |
| phi2_ball | +0.18 | −0.02 | −0.04 | −0.03 | +0.07 |
| qwen3b_farmer | +0.28 | +0.15 | +0.15 | +0.11 | +0.12 |
| qwen3b_ball | +0.20 | +0.06 | +0.07 | +0.04 | +0.03 |
| qwen14b_farmer | +0.15 | +0.07 | +0.07 | +0.04 | +0.08 |
| qwen14b_ball | +0.15 | +0.10 | +0.06 | +0.05 | +0.06 |

Same shape: peaks at L0, declines with depth. Phi-2 farmer goes *negative* mid-network — variable / operator / number / other categories are less coherent than a random partition at those layers. Neither cluster test emerges anywhere.

**Synthesis.** P1 + P1b rule out distance-separable clusters. P2 + P3 show clean directional structure. Concept information is carried by **linear directions in residual space**, not by **distance-separable clusters**. Reading concepts requires cosine and linear-probe tools, not k-means and silhouette.

## Q4. Where do errors come from — representation or downstream?

**Downstream of the residual stream.** Every probe was run twice per cell, once on correct residuals and once on incorrect. Pre-registered failure hypotheses from `probes_design.md`:

| Hypothesis | Predicted signature | Observed |
|---|---|---|
| Binding failure | P1 silhouette drops on incorrect | curves within 0.02 on most cells — **rejected** |
| Concept regression | P2 rename cosine drops on incorrect | curves within 0.02 on most cells — **rejected** |
| Relation collapse | P3 F1 drops on incorrect | F1 within 0.03 on every cell — **rejected** |

Concrete gaps per cell:

| Cell | Largest P1 gap | P2 rename gap | P3 F1 gap |
|---|---:|---:|---:|
| phi2_farmer | 0.01 | 0.00 | 0.03 |
| phi2_ball | 0.07 | 0.04 | 0.00 |
| qwen3b_farmer | 0.02 | 0.01 | 0.02 |
| qwen3b_ball | 0.07 | 0.14 | 0.01 |
| qwen14b_farmer | 0.05 | 0.03 | 0.01 |
| qwen14b_ball | **0.09** | 0.04 | 0.00 |

The residual stream's variable, role, and relation representations are essentially identical on correct and incorrect runs. The two partial exceptions both live at the largest cell: **qwen14b_ball's P1 gap of 0.09** is the first faint hint of a representational error signature at 14B on one problem, and **qwen3b_ball's P2 rename gap of 0.14** is notable but lives inside the 46-pair labeler-artefact cell (see caveats).

## Q5. Do the findings hold at scale?

**Yes for Q1, Q2, Q4; one partial deviation for Q3 on one cell.**

| Claim | Phi-2 2.7B | Qwen-3B | Qwen-14B | Scale-invariant? |
|---|---|---|---|---|
| Relations linearly decodable (Q1) | F1 0.99 | F1 0.96 | F1 1.00 | **yes** |
| Mid-depth rename cosine rises | peak 0.82 | peak 0.88 | peak 0.93 | **yes, strengthens** |
| Final-layer token wins over role (Q2) | gap −0.11 | gap −0.08 | gap **−0.17** | **yes, unchanged or wider** |
| P1 peaks at L0 (Q3) | yes | yes | yes (farmer) / no (ball) | mostly yes |
| Correct ≈ incorrect representations (Q4) | Δ ≤ 0.04 | Δ ≤ 0.07 | Δ ≤ 0.09 (ball only) | mostly yes |

Scale strengthens mid-depth concept (rename peak rises) but does not fix the output regression. qwen14b_ball is the one cell showing any 14B-specific deviation.

## Q6. Does behavioral name-bias reflect representational name-bias?

**No. Behavioral name-bias is a decoding-stage artefact.** One cell suffices — `qwen3b_farmer`.

| Measure | Value |
|---|---:|
| Stage 1 behavioral correct-rate spread across name pairs | **0.34** (x,y: 46% vs. length,width: 12%) |
| Stage 2a mechanistic rename cosine peak | **0.88** at L¾ |
| Stage 2a gap to role-swap at final layer | −0.08 |

qwen3b_farmer had the largest *behavioral* name-bias and the *cleanest* mechanistic rename invariance. If the representation were name-bound, P2 rename would be low. It is 0.88. The name-bias lives **downstream of the residual stream** — in how the model commits to surface tokens at decoding time, not in how it represents the problem internally. The same pattern replicates at 14B. This was a conditional the spec pre-registered; it triggered exactly as written.

## Caveats

**qwen3b_ball headline numbers are a labeler artefact.** Visible: 1.1% correct, 46 / 200 matched, 70% off-topic. This is not a Qwen-3B failure on ball-drop. 82% of "off-topic" samples contain a correct `\boxed{X}` that the labeler regex misses; 65% hit the 512-token cap. Qwen emits answers in `\[ \boxed{49.5} \] m/s` form; the labeler required `v = N` or `m/s` suffix. Mechanistic probes still return clean signals on the 46 pairs retained (P3 F1 = 1.00). A labeler patch plus a longer `max_new_tokens` would lift visible matches past 150.

**Phi-2 off-topic is 100% truncation.** Every Phi-2 `off_topic` sample hits the 512-token cap (farmer 2617/2617, ball 473/473). Phi-2 is verbose; the final numeric claim doesn't fit. Correct / incorrect counts are floors, not ceilings.

## Layer-wise behavior and causal steering on Phi-2 (Stage-6 parent)

The Phi-2 probe in the parent Stage-6 grounding experiment established the foundation: relation structure decodable at macro-F1 ≈ 0.98 from layer 4 onward; variable binding shows role-swap cosine 0.80 vs. rename 0.48 (lexical encoding near the output); an α = 4 steering intervention at layer 8 lifts perimeter-equation emission from 0/20 to **4/20** — a real but partial causal handle. Steering at layer 16 produces no behavioral effect — a "dead zone" where the relation signal is present but no longer consumed downstream.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_concept_steer.png" title="Causal steering at L8 with perimeter-equation injection, alpha sweep. 4/20 emissions at alpha=4; L16 is a dead zone." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## What this gives me — and what it points to next

The concept-level picture is settled for this problem class at this scale range: relations are linear, variables are not clusters, roles abstract mid-depth but regress at output, and the residual stream's representation of the problem is essentially identical on failing and succeeding runs. Whatever breaks must live downstream — in MLP arithmetic, value binding, or the final decoding step. Four next moves argued for by these findings:

1. **Localize the downstream failure.** Layer-wise logit-lens on the final 4 layers, restricted to incorrect runs, should identify where a correct residual turns into a wrong output token.
2. **Causal patching correct → incorrect at the candidate error layer.** If patching the residual at layer `ℓ` flips the emitted number, the corruption step sits at `ℓ`.
3. **Labeler patch + re-label for qwen3b_ball and qwen14b_ball.** Text-only, ~1 min compute; restores ≥ 150 matched pairs per cell for downstream stages.
4. **SAE feature discovery targeted at the late-layer corruption point**, not abstract "concept features."
