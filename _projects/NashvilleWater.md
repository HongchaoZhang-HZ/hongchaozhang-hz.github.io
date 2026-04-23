---
layout: page
title: Explainable AI for Nashville Water System
description: AI-powered anomaly detection for urban water distribution — combining graph neural networks, physics-informed hydraulics, and explainable real-time diagnostics.
img: assets/img/publication_preview/nashvillewater.png
importance: 1
category: work
related_publications: true
---

Efficient water service management requires timely detection of irregularities — valve malfunctions, pressure drops, unexpected usage, slow leaks hidden inside otherwise normal demand patterns. Traditional practice relies on reactive measures, generalized thresholds, and post-hoc simulation replay, which are slow and coarse. We are developing an AI-powered anomaly detection system for the Nashville metro water network that analyzes historical and real-time sensing data — pressure, flow, consumption — to surface anomalies at **node-level granularity**, with an explicit emphasis on explainability so that engineers and operators can interpret, trust, and act on the model's outputs.

This is a research-centered pilot jointly with **Dr. Meiyi Ma**, **Prof. Ahmad F. Taha**, and **Prof. Taylor T. Johnson** at Vanderbilt ISIS, working with domain engineers and operators from the Nashville metro water utility.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/nashvillewater.png" title="Converting a water pipeline system into a graph representation: valves, junctions, tanks, and pumps become nodes; pipes become edges." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Why graph neural networks

Water distribution systems (WDS) are natively graph-structured: nodes represent junctions, tanks, pumps, and valves; edges represent pipes with attributes like length, diameter, and roughness. Standard deep learning operates on Euclidean data and cannot exploit this structure. Graph neural networks (GNNs) update each node's embedding by aggregating messages from its neighbors through successive layers — message computation, aggregation, and update — letting a node incorporate information from multi-hop neighbors and capture both local pipe-level behavior and network-wide flow patterns in a single end-to-end model.

The same graph architecture supports three levels of analytic task — node-level (anomaly at a specific junction), edge-level (fault on a specific pipe), and graph-level (whole-subnetwork events) — which maps cleanly onto the operational questions a utility actually needs answered.

## Theoretical foundation — spectral energy shifts for camouflaged anomalies

The hard cases in water networks are not spike-like faults but **camouflaged anomalies**: slow leaks, valve drifts, and pressure shifts that look statistically normal at every individual sensor and only reveal themselves in the joint behavior across the network. Prior graph anomaly detection (GAD) methods characterize anomalies through *increased* variation in spectral energy distributions — effectively detecting disruptions that make a node spectrally louder. But anomalies that cause *decreased* variation, i.e., anomalies that silence a node into looking more normal than a real normal node, persist across multiple benchmark datasets and remain undetectable by existing spectral approaches.

Our under-review ICML 2026 submission develops the theoretical foundation for detecting both directions of spectral shift. The core contribution is a **node-level spectral energy formulation** that is fully compatible with standard graph message passing, making it a drop-in addition to a GNN rather than a separate pipeline. Built on this, we introduce an **energy-aware graph learning framework** with energy-driven message passing that handles static graphs (fixed network topology, steady-state anomalies) and time-series graphs (temporal evolution, sliding-window anomaly scoring) in a unified architecture — no specialized sequence modules needed, and efficient even under long sliding windows. Large-scale benchmark experiments demonstrate effectiveness, scalability, and robustness relative to prior GAD baselines.

For the Nashville water setting, this matters directly: the worst-case leak is the one that blends into demand variability. The spectral-energy formulation is what gives the GNN pipeline below a principled theoretical guarantee for catching that case, rather than an ad-hoc detection heuristic.

## Project structure

The project is organized around six objectives spanning two phases.

### Phase 1 — foundational model

**Objective 1 — Domain expert–centered design and historical data analysis.** Start with a one-year dataset from a small pilot area, focusing on water pressure, flow rates, and usage patterns to identify baseline behavior and historical anomalies. Data preprocessing handles missing values, synchronizes heterogeneous time series, and filters erroneous readings with rule-based and statistical screens. A recurring challenge is that anomalies are rare compared to normal operations — we address this both with data augmentation (statistical and simulation-based synthesis) and with anomaly-property identification and knowledge injection into the model.

**Objective 2 — GNN-based deep learning model.** Construct a graph where nodes are valves, junctions, tanks, and pumps, edges are pipes, and node features are time series of pressure, flow, and consumption plus connectivity attributes. The architecture combines **Graph Convolutional Networks (GCNs)** or **Graph Attention Networks (GATs)** for spatial relationships with **Recurrent Graph Neural Networks (RGNNs)** or **Temporal Graph Networks (TGNs)** for time-dependent behavior, wrapped in an encoder–decoder that models normal operational patterns. Anomaly detection runs semi-supervised or unsupervised via reconstruction-based approaches (Autoencoders, Variational Autoencoders) and contrastive learning, yielding an interpretable, scalable framework.

**Objective 3 — Physics-informed GNN.** We pair the data-driven GNN with a physics-driven model, embedding hydraulic constraints directly into the architecture via message passing or loss terms:

- **Mass conservation** at junctions: `∑Q_in = ∑Q_out`.
- **Energy conservation** along pipe segments (Darcy–Weisbach head loss): `h_f = f · (L/D) · (v²/2g)`.
- **Hazen–Williams** for pressurized flow: `h_f = 10.67 · L / (C^1.85 · D^4.87) · Q^1.85`.

These are the laws the utility already uses in simulation, and enforcing them in the learning model gives predictions that respect continuity and pressure behavior rather than drifting into physically impossible territory — a precondition for operator trust.

**Objective 4 — Pilot case study and evaluation.** A controlled study on the one-year pilot dataset with train/validation/test splits, sensitivity analysis, and benchmarking against simulation baselines. Robustness is measured against sensor noise, drift, and missing data, with Precision, Recall, and F1 as headline metrics.

### Phase 2 — deployment

**Objective 5 — Real-time data integration.** The gap between simulated training data and the real system is a first-order challenge. Simulations assume uniform pipe quality; reality includes pipes over 100 years old with internal corrosion that alters friction, unknown material composition, and unrecorded structural anomalies. We refine the model to handle noisy, incomplete, and uncertain real-world streams, closing the simulation-to-reality gap that otherwise limits the model at deployment time.

**Objective 6 — Operator dashboard.** An interactive dashboard that overlays real-time predictions and key system information onto the network graph — flow rates, pressure levels, predicted leaks or abnormal patterns. Operators see which nodes or pipes are affected, compare against historical trends, and receive color-coded alerts. The dashboard is what turns model outputs into actionable insights; without it, the GNN is a monitoring service that operators cannot route around their existing SCADA intuition.

## Datasets and benchmarks

Public WDS benchmarks are used for model development before transferring to the Nashville network:

| | Hanoi | L-Town |
|---|---|---|
| Nodes | 31 | 388 |
| Pipes | 43 | 429 |
| Reservoirs | 3 | 1 |
| Pipe attributes | length, diameter, roughness | — |
| Available data | hydraulic heads, pressures | flow, pressure, demand |
| Time-series | — | yes (multi-day) |

Hanoi (Vrachimis et al., 2018) is the standard synthetic benchmark for leak detection and pipe failure. L-Town (Vrachimis et al., 2020 — BattLeDIM) is the medium-scale realistic benchmark used for anomaly detection and sensor placement strategies.

## Connection to DAE-aware safety

Water-network dynamics are governed by differential-algebraic equations: differential equations for tank heads and pump transients, algebraic equations for mass and energy conservation at every junction. This is exactly the structure the [DAE-CBF](../daecbf/) project handles. Treating the network as a DAE rather than an ODE lets us reason about **safe operating regions** — pressure bounds, storage limits, contaminant containment — jointly with the anomaly detector, and gives the detector a principled language for "operating envelope violation" as distinct from "statistical outlier." The explainability thread and the safety thread meet in the same formalism.

## Deliverables

- A data integration and analysis pipeline combining historical and real-time sensor feeds under domain-expert guidance.
- A GNN-based deep learning model detecting spatial–temporal anomalies across the network.
- A hybrid physics-informed extension embedding mass, energy, and Hazen–Williams constraints into the learned model.
- A pilot evaluation against the one-year dataset with precision/recall/F1 benchmarking.
- A real-time prediction pipeline and operator-facing dashboard.

## References

1. Vrachimis, S.; Kyriakou, M.; Eliades, D.; Polycarpou, M. *LeakDB: A benchmark dataset for leakage diagnosis in water distribution networks.* WDSA/CCWI Joint Conference, 2018.
2. Vrachimis, S. G.; Eliades, D. G.; Taormina, R.; Ostfeld, A.; Kapelan, Z.; Liu, S.; Kyriakou, M.; Pavlou, P.; Qiu, M.; Polycarpou, M. M. *BattLeDIM: Battle of the leakage detection and isolation methods.* CCWI/WDSA Joint Conference, 2020.
