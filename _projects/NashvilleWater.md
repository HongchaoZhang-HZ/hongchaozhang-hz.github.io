---
layout: page
title: Explainable AI for Nashville Water System
description: Anomaly detection, safe operation, and interpretable diagnostics for urban water distribution — with Nashville metro as the living testbed.
img: assets/img/7.jpg
importance: 1
category: work
related_publications: true
---

Urban water distribution networks deliver clean water through tens of thousands of pipes, valves, pumps, and tanks, coupled by flow-conservation and nonlinear head-loss equations. Aging infrastructure and sparse metering make leakage, valve faults, and pressure anomalies common and difficult to localize: a single large leak can manifest as only a faint pressure drop distributed across many downstream sensors, while calibration drift, demand variability, and pump-schedule transients cloud the signal further. Non-revenue water — water produced but not billed — is a first-order operational problem in most American cities.

The Nashville metro system is our testbed: thousands of kilometers of pipe, a mix of gravity-fed and pumped zones, and a real utility partner supplying network geometry and operational data. The goal is not only a working detector but an **explainable** one: diagnoses that a human operator can interpret, trust, and act on, with provable bounds when possible.

## Pipeline

The detection pipeline has three interlocking components.

**Physics-informed graph neural networks (PIGNN).** A graph neural network that respects flow conservation and Darcy–Weisbach head loss as inductive priors. Trained against EPANET-based simulations and (where available) real meter readings, the PIGNN fills in unobserved nodes and produces a full pressure/flow field consistent with the physics — a prerequisite for any localization logic that relies on residuals against an expected hydraulic state.

**Coarse-to-fine localization.** Anomaly scoring happens first at a subregion level (campus, downtown, residential), surfacing the zone most likely to contain a leak or valve fault. A second pass narrows to specific nodes or pipes, using residual patterns and graph connectivity to exploit the fact that a leak downstream of a sensor distorts all upstream head losses in a pattern the physics constrains.

**Subgraph decomposition by usage pattern.** The network is partitioned by usage: university campuses, downtown commercial, residential zones, and industrial feeders. Each subgraph has its own demand profile and its own local model, audited and recombined into a whole-network estimator. This matters both for accuracy (demand patterns differ wildly) and for explainability (an operator understands a campus subgraph faster than a flat 10⁴-node graph).

## Why explainable — and how

Two pressures push toward explainability. First, operators will not replace their existing SCADA intuition with a black-box detector that occasionally says "anomaly somewhere." Second, this project sits inside a broader research thread on **reasoning grounding in small language models** (see the concept-probing and LLM-internals side projects): we already know that small LLMs can recover implicit domain constraints only partially, and miss derived bounds almost entirely. The water setting is a concrete domain where explicit domain axioms — flow conservation, pressure bounds, storage limits — are both formal enough to feed to a reasoning system and operationally meaningful enough that a partial recovery is still useful.

Practically, we expose each detection with (i) the physical residual it's based on, (ii) the subgraph window it was computed in, and (iii) a plain-language summary of which constraint is strained. A leak candidate near a campus pump might surface as "5.2 psi residual at node 14,712; flow-conservation slack rising for 18 minutes; consistent with a leak ≥ 3 L/s on pipe 8,901."

## Connection to DAE-aware safety

Water-network dynamics are governed by differential-algebraic equations: differential equations for tank heads and pump transients, algebraic equations for flow conservation at each junction. This is exactly the structure the [DAE-CBF](../daecbf/) project handles. Treating the network as a DAE rather than an ODE lets us reason about **safe operating regions** — pressure bounds, storage limits, contaminant containment — jointly with the anomaly detector, and gives the detector a principled language for "operating envelope violation" as distinct from "statistical outlier."

## Current status

The PIGNN diffuser and the coarse-to-fine localization strategy are implemented; validation is ongoing against EPANET scenarios and Nashville metro meter data, with dataset limitations being the current bottleneck rather than modeling. Open-source components draw on the EPA's EPANET and the USEPA `WNTR` toolkit. The longer-term goal is a live-deployed pilot on a defined Nashville subregion, with operator-in-the-loop evaluation.
