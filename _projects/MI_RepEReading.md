---
layout: page
title: Representation Engineering of LLM Reasoning
description: What lives in the residual stream when an LLM solves a math word problem — relation type, value binding, and schema correctness — read off via RepE on 8 model × problem cells.
img: assets/img/publication_preview/mi_repe_problemsolve.png
importance: 4
category: fun
related_publications: false
---

**Highlight.** Stage 3 of the concept-probing thread asks one question: *how* are variable relationships represented inside the model when it solves a math word problem? Using **Representation Engineering (RepE)** — population-level reading directions extracted from contrastive activation pairs — we read four candidate coordinates (`s_relation`, `s_value`, `s_schema`, `s_name_diagnostic`) out of the residual stream at the commit layer L\*, across **8 cells (Phi-2, Qwen2.5-3B, Qwen2.5-7B, Qwen2.5-14B-Instruct × farmer, ball)**. The clean result: **relation type is a stable, low-rank, scale-invariant linear feature** — AUC ≥ 0.99 in every cell. The conditional result: **value binding is readable** in some Qwen-farmer cells (3B 0.96 → 7B 0.86 → 14B 1.00). The negative result: **schema correctness is not a universal RepE direction** — its readability is non-monotonic with scale (peaks at Qwen-7B 0.76), and *the position where it lives reverses across model sizes inside the same architecture family*. Higher rank, orthogonalization against other coordinates, and uncertainty calibration all fail to rescue schema as a single-direction feature. The reading-only frame has been pushed to its limit; the next move is symbolic KG validation, not more directions.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_repe_problemsolve.png" title="The RepE reading frame: hidden states at variable and relation token positions are mapped to four reading coordinates, then z-state separation between correct and incorrect trajectories is measured at the commit layer L*." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Setting

Stage 3 reads from residual streams captured by the parent matched-pair experiment ([Concept Probing](../mi_conceptprobing/)) and uses **trusted problem metadata** as supervision — no symbolic claim is asked of the model itself. Eight cells are run end-to-end:

```text
Phi-2 (2.7B), Qwen-2.5-3B, Qwen-2.5-7B, Qwen-2.5-14B-Instruct
       ×       farmer (max area | perimeter)  +  ball (impact velocity | height)
```

Reading directions are learned at each cell's commit layer L\* via simple primitives — `v = mean(h_+) − mean(h_−)` for binary contrasts, top right singular vectors of class-mean differences for multi-class — then projected onto held-out trajectories with grouped 5-fold splits by paraphrase to block idiom leakage. The state vector is

```text
z[layer, token] = [s_relation, s_value, s_schema, s_name_diagnostic]
```

Each coordinate is a scalar produced by `s = h ⋅ v`. Per the spec, none of this proves a symbolic property — it asks only whether the residual stream **contains readable information** about variable roles, problem values, and relation types.

## What worked

### Relation type — clean, low-rank, scale-invariant

| Cell | L\* | Relation AUC | Rank |
|---|---:|---:|---:|
| phi2_farmer | 21 | **0.99** | rank-2 |
| phi2_ball | 21 | **1.00** | rank-1 |
| qwen3b_farmer | 32 | **0.99** | rank-2 |
| qwen3b_ball | 33 | **1.00** | rank-1 |
| qwen7b_farmer | 25 | **1.00** | rank-2 |
| qwen7b_ball | 25 | **1.00** | rank-1 |
| qwen14b_farmer | 43 | **1.00** | rank-2 |
| qwen14b_ball | 43 | **1.00** | rank-1 |

Ball uses a rank-1 relation direction (kinematic-eq vs. sqrt-form). Farmer uses a rank-2 subspace (perimeter-eq, area-eq, bound). This is the headline RepE positive: relation type is the same kind of object across architectures and scales.

### Value binding — usable in some Qwen-farmer cells

| Cell | Value AUC at L\* |
|---|---:|
| qwen3b_farmer | **0.96** |
| qwen7b_farmer | **0.86** |
| qwen14b_farmer | **1.00** |
| Phi-2 farmer | 0.61 |
| All ball cells | 0.47 – 0.67 |

At a relation use-site (the perimeter equation for farmer, the kinematic equation for ball), the relevant problem value is linearly readable from the residual in Qwen farmer cells. The trend across Qwen scale is non-monotonic but stays in the strong band. Phi-2 and ball cells are weak at L\* — value reading is conditional, not universal.

### z-state separates correct from incorrect — in 3 / 8 cells cleanly

| Cell | zAUC @ L\* | zAUC max (layer) |
|---|---:|---:|
| phi2_farmer | 0.49 | 0.63 (L32) |
| phi2_ball | 0.52 | 0.65 (L32) |
| qwen3b_farmer | 0.36 | 0.68 (L4) |
| qwen3b_ball | **0.93** | **0.94 (L36)** |
| qwen7b_farmer | **0.72** | 0.76 (L4) |
| qwen7b_ball (n=21) | **0.74** | **0.85 (L8)** |
| qwen14b_farmer | 0.69 | 0.70 (L32) |
| qwen14b_ball | **0.71** | 0.72 (L1) |

The 4-D z-state separates correct from incorrect trajectories cleanly in three cells and borderline in a fourth. **qwen3b_ball is the cleanest**; **qwen7b_farmer is the strongest farmer z-state across all four farmer cells** (others 0.49 / 0.36 / 0.69) — the 7B scale point lifts the farmer side into the readable band for the first time.

## What failed or stayed weak

### Schema correctness is not a universal direction

| Cell | Rank-1 schema_dir AUC at L\*, t\* |
|---|---:|
| phi2_farmer | 0.54 |
| phi2_ball | 0.66 |
| qwen3b_farmer | 0.51 |
| qwen3b_ball | **0.84** |
| qwen7b_farmer | **0.76** |
| qwen7b_ball (n=21) | 0.75 |
| qwen14b_farmer | 0.68 |
| qwen14b_ball | 0.66 |

Schema reads strongly in qwen3b_ball and acceptably in qwen7b. It fails at Phi-2 and at qwen3b_farmer / qwen14b_farmer / qwen14b_ball. **It is not a universal direction.**

### Higher rank doesn't fix schema (Stage 3b)

A rank sweep over K ∈ {1, 2, 4, 8, 16} at the same `(L\*, t\*)` position shows best-K AUC at most **0.04** above K=1 across all 8 cells. The problem isn't a low-rank bottleneck at the position — it's the position-and-feature combination itself.

### Orthogonalization doesn't fix schema (Stage 3d)

Projecting the residual onto the orthogonal complement of {`v_relation`, `v_value`, `v_name_anchor`} and re-extracting schema removes only **0.6 – 7.0%** of variance and changes AUC by **≤ 0.03** in every cell. Relation, value, and name don't contaminate the schema reading — they live in mostly different residual subspaces. There was no noise to remove.

### Schema *position* reverses across Qwen scales (Stage 3c)

| Cell | Best variant | Best AUC | `op_positions` AUC |
|---|---|---:|---:|
| qwen3b_farmer | `op_positions` | **0.78** | 0.78 |
| qwen7b_farmer | `layer-1@t*` (≈ tied with `t*`) | **0.77** | **0.20** |
| qwen14b_farmer | `op_positions` | **0.74** | 0.74 |

For Qwen-3B and Qwen-14B farmer, schema lives at the relation operator tokens. For Qwen-7B farmer, schema at relation tokens is **anti-predictive (0.20)** and instead lives at the divergence position itself. **Same architecture family, same problem, opposite location.** This falsifies the earlier "farmer schema lives at relation tokens" claim; the position is scale-dependent, not just problem-dependent.

### Single-position single-prefix patching ceiling drops with Qwen scale

The Step-5 patching flip rate on farmer: **3B 0.80 → 7B 0.42 → 14B 0.50**. Larger Qwen models are progressively *less* rescuable by single-layer single-prefix patching, even though linear schema readability at L\* peaks at 7B. Linear readability and single-position controllability are not the same axis.

### Uncertainty calibration not yet usable

Evidential heads (Sensoy 2018) trained per coordinate. Schema ECE best is **0.20 at qwen7b_farmer**, well above the usable target of ≈ 0.10. Calibration improves modestly with scale but is not headline-grade.

## Final answer

Variable-relationship representations are not one monolithic state. They split into:

1. **Relation type** — stable, low-rank, scale-invariant. AUC ≥ 0.99 in every cell. Reusable for downstream symbolic checking.
2. **Value binding** — readable only in some model × problem settings, particularly Qwen farmer at L\*. Conditional.
3. **Schema correctness** — *not* a universal RepE direction. Position-, problem-, and scale-dependent. Peaks at Qwen-7B (0.76 farmer) and is non-monotonic with scale; the position where schema reads best inside the same architecture family changes between 3B / 7B / 14B.

The refined claim:

> Variable relationships split into a stable linear part (relation type, sometimes value) and a position- and scale-dependent part (schema correctness). RepE recovers the first cleanly; the second requires an instrument we do not yet have.

## Stage 4 gate

The spec's gate for advancing to a broad steering / control study fails on the uniform reading:

| Gate | Result | Status |
|---|---|---|
| Stable schema readable in ≥ 4/8 cells (uniform AUC ≥ 0.80) | 1/8 | fail |
| zAUC @ L\* ≥ 0.70 in ≥ 4/8 cells | 3/8 (qwen3b_ball, qwen7b_farmer, qwen14b_ball) | fail |
| Descriptive set enriched for correct trajectories | 7/8 | pass |
| No unsupported `v_goal` needed | yes | pass |

**Verdict: do not advance to broad Stage 4.** Defensible pilot cells for methodology testing — three scales × the two-problem axis — are `qwen3b_ball`, `qwen7b_farmer`, `qwen14b_ball`. Phi-2 schema directions should not be used for steering (schema_dir ≤ 0.66, zAUC @ L\* ≤ 0.52 in both Phi-2 cells).

## What this gives me

A clean negative for the "one schema direction" hypothesis, and a clean positive for the "relation is a stable RepE direction" claim. Stage 3 has now exhausted single-position linear constructions — rank, orthogonalization, position sweep, and uncertainty calibration all replicate as either negative or position-and-scale-dependent. The next move is not more directions: it is to bridge from internal representation to symbolic validity. The bridge

```text
s_relation high → model represents the relation type
                → generated relation edge can be checked by KG validation
```

splits the work cleanly: probing measures *whether the relation is represented*; KG validation measures *whether the represented relation is sound and complete*. That separation is what the next stage of the concept-probing thread is built around.

## References

- Zou et al. (2023/2025), [*Representation Engineering: A Top-Down Approach to AI Transparency*](https://arxiv.org/abs/2310.01405). The RepE frame for population-level representation reading and control. [Code](https://github.com/andyzoujm/representation-engineering).
- Alain & Bengio (2016), [*Understanding intermediate layers using linear classifier probes*](https://arxiv.org/abs/1610.01644). The classical reference for linear probes as residual-stream readouts.
- Belinkov (2022), [*Probing Classifiers: Promises, Shortcomings, and Advances*](https://direct.mit.edu/coli/article/48/1/207/107571/). The caveat: probe readability ≠ causal use ≠ symbolic validity.
