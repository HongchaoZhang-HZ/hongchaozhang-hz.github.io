---
layout: page
title: Safe AI Control
permalink: /projects/neuralbarriercertificate/
description: Learning, exact verification, and stochastic extensions of neural safety certificates.
img: assets/img/publication_preview/seev_training.jpg
img_alt: SEEV neural-barrier synthesis and exact-verification workflow.
importance: 1
category: work
related_publications: true
---

Control barrier functions (CBFs) define conditions under which a controller keeps a dynamical system inside a specified safe set. Neural CBFs can represent complex safety geometries, but a learned candidate is useful only when its safety conditions can be checked.

## Exact verification

For rectified linear unit (ReLU) neural CBFs, smooth-function conditions do not apply at nondifferentiable boundaries. Ignoring those boundaries can accept a candidate that does not establish safety. Our NeurIPS 2023 work derived necessary and sufficient conditions for the studied class and an exact verification method that checks the activation regions intersecting the barrier boundary.

## Synthesis with verification

SEEV integrates synthesis with exact verification. Training shapes the activation regions near the safety boundary so that the final verification problem is smaller, while counterexamples from verification guide subsequent synthesis.

{% include figure.html path="assets/img/publication_preview/seev_training.jpg" title="SEEV couples neural-barrier synthesis with exact verification of boundary-relevant activation regions." class="img-fluid rounded z-depth-1" alt="Diagram of the SEEV neural barrier synthesis and exact verification workflow." %}

{% include figure.html path="assets/img/publication_preview/zhang2024seev_poster.jpg" title="SEEV verification and synthesis results." class="img-fluid rounded z-depth-1" alt="Research poster summarizing synthesis with efficient exact verification for ReLU neural barrier functions." %}

## Stochastic systems

This line also addresses stochastic dynamics. Our CDC 2024 work learns a formally verified CBF in a stochastic environment. *Stochastic Neural Control Barrier Functions*, to appear in IEEE Transactions on Automatic Control in March 2027, develops probabilistic forward-invariance guarantees under its stated stochastic-system assumptions.

## Papers and code

- [Exact Verification of ReLU Neural Control Barrier Functions](https://proceedings.neurips.cc/paper_files/paper/2023/file/120ed726cf129dbeb8375b6f8a0686f8-Paper-Conference.pdf) · [code](https://github.com/HongchaoZhang-HZ/exactverif-reluncbf-nips23)
- [SEEV: Synthesis with Efficient Exact Verification for ReLU Neural Barrier Functions](https://proceedings.neurips.cc/paper_files/paper/2024/file/b7868dedad7192f83c9efb042da43317-Paper-Conference.pdf) · [code](https://github.com/HongchaoZhang-HZ/SEEV)
- [Stochastic Neural Control Barrier Functions](https://arxiv.org/abs/2506.21697) · [code](https://github.com/tayalmanan28/Stochastic-NCBF)
