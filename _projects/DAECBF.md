---
layout: page
title: "{DAE-CBF}: Safety on the Constraint Manifold"
description: Safety verification and control for differential-algebraic systems.
img: assets/img/8.jpg
importance: 2
category: work
related_publications: true
---

Many safety-critical CPS are governed by differential-algebraic equations (DAEs): power grids with voltage stability constraints, robotic manipulators with kinematic constraints, and water networks governed by flow conservation. Standard Control Barrier Function (CBF) theory assumes ODE dynamics and breaks down when algebraic constraints are present.

We extend CBFs to DAE systems, providing verification and forward-invariance conditions for safety on the constraint manifold. This bridges resilient control, neural certificates, and constrained infrastructure applications.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/8.jpg" title="CBFs on the DAE constraint manifold" class="img-fluid rounded z-depth-1" %}
    </div>
</div>

Related work: *Verification and Forward Invariance of Control Barrier Functions for Differential-Algebraic Systems* (IEEE TAC, under review).
