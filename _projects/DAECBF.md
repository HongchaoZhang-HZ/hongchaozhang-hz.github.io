---
layout: page
title: DAE-CBF
description: Safety on the constraint manifold — verification and control for differential-algebraic systems.
img: assets/img/publication_preview/daecbf_manipulator.gif
importance: 2
category: work
related_publications: true
---

Many safety-critical cyber-physical systems are governed by differential-algebraic equations (DAEs) rather than ordinary differential equations: power grids coupled by Kirchhoff's laws and voltage stability constraints, robotic manipulators with kinematic closure, chemical reactors with mass and energy balance, and water distribution networks governed by flow conservation. Standard Control Barrier Function (CBF) theory assumes purely ODE dynamics — ignoring the algebraic constraints can render the CBF quadratic program infeasible along real trajectories, or worse, certify safety that the system does not actually satisfy. This project builds the theory, verification machinery, and implementations to treat DAE structure as a first-class object in safety-critical control.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/daecbf_manipulator.gif" title="Flexible manipulator with kinematic closure constraints executing a DAE-aware CBF-QP online." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## System model

We work with nonlinear DAEs in semi-explicit form:

$$
\dot x_d = f(x_d, x_a) + g(x_d, x_a)\, u, \qquad 0 = \varphi(x_d, x_a),
$$

where `x_d` is the differential state, `x_a` the algebraic state, and the constraint manifold is `M = { x : φ(x) = 0 }`. The **differentiation index** `ν` — how many times `φ` must be differentiated to recover an ODE — determines how many compatibility conditions the controller must respect simultaneously. Index-1 systems cover a broad class of mechanical and network-flow problems; higher-index systems (power grids with swing equations under algebraic voltage constraints, constrained manipulators) require the hierarchy developed in Stage 2.

## Core construction — projected vector fields

Differentiating the algebraic constraint gives the compatibility condition

$$
J_d(f_d + g_d u) + J_a\, \dot x_a = 0,
$$

which, on the regular part of `M`, is solved by `\dot x_a = -J_a^\dagger J_d (f_d + g_d u)`. Substituting back yields **projected vector fields** on `M`:

$$
\hat f = \begin{bmatrix} f_d \\ -J_a^\dagger J_d f_d \end{bmatrix}, \qquad
\hat g = \begin{bmatrix} g_d \\ -J_a^\dagger J_d g_d \end{bmatrix},
$$

so the closed-loop dynamics on the manifold become `\dot x = \hat f(x) + \hat g(x) u`. A CBF inequality formulated with these projected fields — together with the compatibility projection `P(x) = I - J_a J_a^\dagger` — certifies **forward invariance of `D ∩ M`**, the intersection of the barrier set with the manifold, rather than an ambient set that ignores the constraint.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/daecbf_manifold.png" title="Three-dimensional constraint manifold with a CBF-induced safe region projected onto it." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Index-1 and index-ν safety theorems

For index-1 DAEs, a single projected compatibility condition plus a standard CBF inequality on the projected Lie derivatives is sufficient for positive invariance of `D ∩ M`. The corollary extends this to high-relative-degree barriers via the HOCBF ψ-hierarchy, preserving the `d = ν + d' - 1` relationship between differentiation index and effective relative degree.

For higher-index DAEs (`ν ≥ 2`), the theorem generalizes to a **hierarchy of `ν` projections** `P^{(1)}, ..., P^{(ν)}`, each enforcing compatibility at a different derivative order, together with projected vector fields `\hat f^{(ν)}, \hat g^{(ν)}` built from the hierarchical Jacobians. The resulting QP adds `ν` equality constraints to the standard CBF-QP but keeps it convex — solvable online at control rates.

## Verification — SOS for polynomial, NLP for general nonlinear

Verifying a DAE-aware CBF decomposes into two checks:

- **Correctness.** `D ∩ M ⊆ C ∩ M` — the barrier set sits inside the safe set *on the manifold*. For polynomial systems this reduces to a Positivstellensatz SOS certificate; for general nonlinear systems, an NLP minimizing the safety function `h(x)` under `φ(x) = 0` and `b(x) ≥ 0` either certifies correctness or returns a counterexample.
- **Feasibility.** At every point in `D ∩ M`, an input `u` exists satisfying the compatibility and CBF conditions simultaneously. Interior feasibility uses a Farkas-style dual system `A_int u ≤ r_int`; boundary feasibility combines Nagumo tangency with the compatibility projection. Polynomial case: SOS certs per Proposition 3. General nonlinear: NLP on the dual system.

Counterexamples from either check feed back into synthesis — either directly refining a candidate CBF or seeding neural-CBF training data. The verifier and the synthesizer share the same polynomial / SMT infrastructure as the [sampling-SOS-CBF](https://github.com/HongchaoZhang-HZ/Sampling_CBF_Synthesis_Verification) line of work.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/daecbf_3link.gif" title="Three-link DAE-CBF executing online on a manipulator with kinematic closure — the SOS-synthesized barrier keeps the end-effector inside the safe workspace while respecting the algebraic joint constraints." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/daecbf_3link_final.png" title="Final DAE-CBF state: the synthesized barrier level set sits inside the intersection of the safe set and the constraint manifold." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Application domains under active development

- **Water distribution networks.** Flow conservation is the algebraic constraint; tank-head dynamics are differential. Ties directly to the [Nashville Water System](../nashvillewater/) anomaly-detection work.
- **Power networks.** Swing equations for generator rotors plus algebraic voltage/Kirchhoff constraints. Index-2 in the standard semi-explicit formulation.
- **Constrained manipulation.** Kinematic closure in closed-chain manipulators (parallel robots, exoskeletons), contact constraints, and compliant-surface interaction.

## Related work

- *Control Barrier Functions for Safety-Critical Control of Differential-Algebraic Systems* — Zhang, Kazma, Ma, Johnson, Taha; arXiv:2406.18914.
- *Verification and Forward Invariance of Control Barrier Functions for Differential-Algebraic Systems* — Zhang, Kazma, Ma, Johnson, Taha; IEEE TAC, under review.
