---
layout: page
title: Grokking and the Fourier Manifold
description: A 39x training speedup by naming the manifold that grokking lives on, and the limits of manifold-agnostic tricks.
img: assets/img/publication_preview/mi_grokking_curves.png
importance: 1
category: fun
related_publications: false
---

**Highlight.** A 1-layer transformer trained on `(a + b) mod p` normally groks around epoch 55,000. If we extract the diff-of-means (DiM) direction between grokked and memorized checkpoints, **93.7% of its energy lands in the top-5 Fourier modes** — naming the manifold the model ultimately lives on. Using that as a differentiable surrogate loss, the same model groks at epoch **1,416 — a 39x speedup** — with no curriculum and no extra data. Pushing the idea past the Fourier case exposes where it stops being automatic: manifold-agnostic methods win one task and lose another, and multi-operation mode switching is a separate bottleneck that single-layer models cannot clear.

## Stage 1 — DiM identifies the computational manifold

A 1-layer transformer (128-d model, 4 heads, ReLU MLP) is trained on `(a + b) mod 59` with a 30/70 train/test split over 55,000 epochs. We track train and test accuracy, Fourier concentration of embeddings and residual-stream activations at three sites, and run causal interventions via directional ablation and activation addition.

The diff-of-means direction between grokked (test > 95%) and memorized (test < 30%) checkpoints concentrates **93.7% of its energy in the top-5 Fourier modes** (64.4% for p=113 seed 42). The manifold distance — one minus the Fourier energy fraction — drops sharply from 0.92 to 0.007 right at the grokking transition, and is tightly correlated with test accuracy throughout training.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_dim_fourier.png" title="DiM direction between grokked and memorized checkpoints aligns with the top-5 Fourier modes (93.7% energy concentration)." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

Ablating the Fourier subspace (around 10 directions) drops accuracy by 97.3% — it is **causally necessary** for correct computation. Ablating the single DiM direction alone moves accuracy by 0.03% — it reliably detects the manifold but is too coarse to serve as a sole intervention target.

| Metric | p=59, seed 0 | p=113, seed 42 |
|---|---|---|
| Grokking epoch | ~55,000 | ~35,400 |
| DiM–Fourier energy (top-5) | 0.937 | 0.964 |
| Manifold distance (final) | 0.007 | 0.0025 |
| Post-grok Fourier conc. (W_E) | 0.82 | 0.82 |
| Post-grok Fourier conc. (resid post-MLP) | 0.96 | 0.96 |
| Attention effective rank (95% var) | 7 | 8 |
| Fourier-subspace ablation | −97.3% acc | — |
| DiM single-direction ablation | −0.03% acc | — |

## Stage 2 — A surrogate loss accelerates training 39x

With the Fourier manifold named, a differentiable surrogate can pull embeddings onto it during training. The loss is `L_CE + λ · L_Fourier`, where `L_Fourier` penalizes energy outside the top-5 DFT modes of the embeddings. A 4 × 5 grid over curriculum (none, frequency-ordered, task-relevant-first, small-p transfer) × regularizer strength λ ∈ {0, 0.01, 0.1, 1, 10} gives 20 runs.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_acceleration_heatmap.png" title="Grokking epoch across (curriculum × Fourier-regularizer strength). High-lambda alone is enough — curriculum doesn't help and actively harms when combined." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

The baseline (no curriculum, λ=0) stalls past 55k. No curriculum + λ=10 groks at **epoch 1,416** — a 38.8× speedup. Curriculum alone produces at most 4.4× (task-relevant-first, λ=0). Combining curriculum with high λ is antagonistic: data restriction during the curriculum phase conflicts with the regularizer's direct representation guidance, leaving the combination slower than either lever alone.

|  | λ=0 | λ=0.01 | λ=0.1 | λ=1.0 | λ=10.0 |
|---|---|---|---|---|---|
| C0 (none) | stalled | 9,361 | 5,290 | 2,156 | **1,416** |
| C1 (fund-first) | 29,819 | 10,117 | 10,094 | 10,050 | 10,055 |
| C2 (task-rel) | 12,559 | 12,811 | 11,027 | 15,546 | 10,059 |
| C3 (small-p) | 37,963 | 35,930 | 15,852 | 15,658 | 15,246 |

## Stage 3 — Manifold-agnostic methods have task-dependent limits

Can we accelerate grokking without knowing the target manifold in advance? A 4 × 5 grid across tasks (addition mod p, multiplication mod p, max, a > b) × methods (baseline, Fourier DFT, spectral entropy, online DiM, Grokfast) says no universal method exists.

Spectral regularization succeeds on multiplication (23,217 epochs, from stalled) but fails on addition by crushing rank to 1, destroying the 5-dimensional Fourier structure addition needs. Enforcing the right rank with the wrong basis (SVD top-5) maintains rank but yields five arbitrary directions — and stalls. **Dimensionality is necessary but not sufficient; the basis matters.** Online DiM (single-direction) fails on every task. Non-Fourier test tasks (max, comparison) grok trivially without the delay that makes acceleration meaningful.

|  | baseline | Fourier DFT | spectral | online DiM | Grokfast |
|---|---|---|---|---|---|
| (a+b)%p | stalled | **1,416** | stalled | stalled | stalled |
| (a·b)%p | stalled | stalled | **23,217** | stalled | 41,688 |
| max(a,b) | **50** | 52 | 52 | 209 | 2,092 |
| a>b | **57** | 60 | 59 | 500 | 66 |

Hierarchy of inductive bias: right rank alone → stalls. Right rank and right basis → 39×.

## Stage 4 — Multi-operation mode switching is a distinct bottleneck

Can a single model switch bases based on an operation token `[a, OP, b, =]`? Even with a dual DFT loss that encourages concentration in both the natural Fourier basis (for `+`) and the discrete-log Fourier basis (for `·`), a 1-layer model only reaches 16–26% per-operation accuracy — embeddings hit 77% dual concentration, but compute can't exploit it. Two layers roughly double per-operation accuracy and show asymmetric learning (multiplication climbs to 63% while addition stalls at 33%), suggesting sequential rather than simultaneous algorithm discovery. λ=1 beats λ=10; too-strong regularization creates conflicting gradients. None reach full grokking on both operations within 200k epochs.

| Condition | Add acc | Mul acc | DFT nat | DFT dlog | Verdict |
|---|---|---|---|---|---|
| 1L baseline | 1.1% | 4.7% | 0.158 | 0.138 | stalled |
| 1L dual (λ=10) | 25.7% | 15.9% | **0.776** | **0.768** | embedding works, compute can't switch |
| 2L dual (λ=10) | 35% | 32% | 0.776 | 0.762 | better but stuck |
| 2L dual (λ=1) | 33% | **63%** | 0.71 | 0.73 | **mul leads, add lags** |

## What this gives me

A sharp picture of what grokking is and what it isn't. The grokking transition is *definable* as a motion onto a specific low-dimensional manifold; that manifold is detectable with a cheap direction between grokked and memorized weights; naming it lets you skip most of training. The moment you strip away the basis information, acceleration becomes task-dependent or disappears — rank structure alone is not algorithm. And the algorithm-discovery process itself scales with architectural capacity: a single transformer block cannot hold two different Fourier algorithms conditioned on a token, even when its embeddings can.
