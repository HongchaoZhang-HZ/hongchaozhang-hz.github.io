---
layout: page
title: DAE-Aware Safe Control
permalink: /projects/daecbf/
description: Verification and synthesis of safety certificates for differential-algebraic systems.
img: assets/img/publication_preview/daecbf_manipulator.gif
img_fallback: assets/img/publication_preview/daecbf_manipulator-static.png
img_alt: Animated constrained manipulator under DAE-aware safety control.
importance: 3
category: work
related_publications: true
---

Many physical systems combine differential dynamics with algebraic constraints. Power networks, water networks, and constrained robots are examples. Treating these systems as ordinary differential equations can ignore the constraint manifold on which their trajectories evolve.

## Verification and forward invariance

Our journal manuscript develops CBF verification and forward-invariance conditions for differential-algebraic systems (DAEs). The conditions check safety on the intersection of the barrier set and the algebraic constraint manifold. The manuscript is available as [arXiv:2603.13509](https://arxiv.org/abs/2603.13509) and is under review at the *International Journal of Robust and Nonlinear Control*.

## Synthesis and semi-explicit systems

The CDC 2026 paper *Control Barrier Function Synthesis for Differential-Algebraic Systems* develops synthesis methods that account for the DAE constraints. A companion CDC 2026 paper studies semi-explicit DAEs and sum-of-squares verification. Both papers are to appear.

{% include animated_media.html path="/assets/img/publication_preview/daecbf_manipulator.gif" fallback="/assets/img/publication_preview/daecbf_manipulator-static.png" caption="DAE-aware safe control of a constrained manipulator." alt="Animated constrained manipulator operating under a DAE-aware safety controller." %}

{% include figure.html path="assets/img/publication_preview/daecbf_manifold.png" title="Safety verification on the DAE constraint manifold." class="img-fluid rounded z-depth-1" alt="Geometric illustration of a barrier set intersecting a differential-algebraic constraint manifold." %}

## Descriptor-system takeover

The CDC 2026 paper *Safe Autonomous Takeover for Unknown Descriptor Systems* studies safety during control takeover when the descriptor-system dynamics are not fully known. This line connects DAE-aware analysis to resilient autonomy without assuming that algebraic constraints can be discarded.

{% include animated_media.html path="/assets/img/publication_preview/daecbf_3link.gif" fallback="/assets/img/publication_preview/daecbf_3link-static.png" caption="Three-link constrained-system example for DAE-aware control." alt="Animated three-link constrained system under DAE-aware control." %}

These methods support future work on constrained infrastructure systems, including electric and water networks, where operating requirements and algebraic network relations must be considered together.

[DAE-aware CBF code](https://github.com/HongchaoZhang-HZ/DAE-aware_CBF)
