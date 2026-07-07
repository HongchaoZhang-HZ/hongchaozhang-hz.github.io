---
layout: page
title: SNNV
description: Sound set-based robustness verification for first-to-fire Leaky Integrate-and-Fire spiking neural networks.
importance: 5
category: work
related_publications: false
github: https://github.com/HongchaoZhang-HZ/SNNV
---

SNNV is a verifier for first-to-fire (F2F) Leaky Integrate-and-Fire (LIF) spiking neural networks (SNNs). The project targets the temporal structure that makes SNN verification difficult: membrane state, threshold crossings, reset dynamics, and combinatorial firing schedules.

The main representation is the **spiking star set**. It separates the discrete spike pattern from affine propagation. With a pattern fixed, the network maps a generalized star input set to an output set by an affine map. Uncertainty across patterns is handled with symbolic relaxation and adaptive latency splitting.

[Project site](https://hongchaozhang-hz.github.io/SNNV/) · [Code](https://github.com/HongchaoZhang-HZ/SNNV)

## What it checks

- Computes score enclosures for F2F LIF SNNs under input sets.
- Certifies a classification margin when the target lower bound exceeds competing upper bounds.
- Reports when the margin cannot be certified.

## Companion site

The SNNV site explains the core idea, the spiking-star construction, the interactive playground, and the benchmark results browser.
