---
layout: page
title: "{Safe Water Networks}"
description: Anomaly detection and safe operation for urban water distribution.
img: assets/img/7.jpg
importance: 1
category: work
related_publications: true
---

Urban water distribution networks deliver clean water through thousands of pipes, valves, pumps, and tanks coupled by flow-conservation and head-loss equations. Aging infrastructure and sparse metering make leakage, valve faults, and pressure anomalies common and difficult to localize: a single large leak can manifest as only a faint pressure drop across many sensors, while calibration drift and demand variability cloud the signal further.

We are building an anomaly detection and diagnostics pipeline for the Nashville metro water network that combines physics-based hydraulic models with machine learning. The approach has three components. First, a physics-informed graph neural network (PIGNN) fills in unobserved nodes and reproduces flow and pressure dynamics across the pipe graph, drawing on EPANET-based simulations for training data. Second, a coarse-to-fine localization strategy identifies the subregion most likely to contain a leak, then narrows to specific nodes or pipes. Third, subgraph learning decomposes the network by usage pattern — campus, downtown, residential — so that local models can be trained, audited, and recombined into a whole-network estimator.

This work connects to our effort on DAE-aware safety certificates: the flow-conservation equations that govern water networks are exactly the algebraic constraints that standard CBFs ignore. Treating the network as a differential-algebraic system lets us reason about safe operating regions — pressure bounds, storage limits, contaminant containment — jointly with the anomaly detector.

Tooling: EPANET and WNTR for simulation, Nashville metro network for validation.
