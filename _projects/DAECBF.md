---
layout: page
title: DAE-CBF
description: Safety on the constraint manifold — verification and control for differential-algebraic systems.
img: assets/img/publication_preview/daecbf_manipulator.gif
importance: 2
category: work
related_publications: true
---

Many safety-critical cyber-physical systems are governed by differential-algebraic equations (DAEs) rather than ordinary differential equations: power grids coupled by Kirchhoff's laws and voltage stability constraints, robotic manipulators with kinematic closure, chemical reactors with mass and energy balance, and water distribution networks governed by flow conservation. Standard Control Barrier Function (CBF) theory assumes purely ODE dynamics — ignoring the algebraic constraints can render the CBF-QP infeasible along trajectories of the true system, or worse, certify safety that the system does not actually satisfy.

We develop DAE-aware CBFs that treat the constraint manifold as a first-class object. The core construction derives a manifold-compatibility condition from the algebraic part of the DAE and uses it to project the dynamics onto the manifold, yielding well-posed projected vector fields on which a standard CBF inequality can be enforced. Safety is then guaranteed by forward invariance of the barrier set intersected with the manifold, rather than in ambient Euclidean space.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/daecbf_manifold.png" title="Constraint manifold and the safe region projected onto it" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

The framework handles index-1 DAEs through a single projected compatibility condition, and extends to higher-index DAEs via a hierarchy of projections. Verification decomposes into two checks: correctness — the barrier set sits inside the safe set on the manifold — and feasibility — a control input exists that satisfies the compatibility and CBF conditions simultaneously. For polynomial systems, both reduce to sum-of-squares (SOS) certificates via Positivstellensatz; for general nonlinear systems, nonlinear programming returns counterexamples that drive synthesis refinement.

Application domains under active development include water distribution anomaly detection, power-network voltage safety, and constrained manipulation.

Related work: *Control Barrier Functions for Safety-Critical Control of Differential-Algebraic Systems* (Zhang, Kazma, Ma, Johnson, Taha; arXiv:2406.18914) and *Verification and Forward Invariance of Control Barrier Functions for Differential-Algebraic Systems* (IEEE TAC, under review).
