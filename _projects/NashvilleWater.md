---
layout: page
title: Critical-Infrastructure Monitoring
permalink: /projects/nashvillewater/
description: Spectral graph anomaly detection and field-informed monitoring for water and electric infrastructure.
img: assets/img/publication_preview/nashvillewater.png
img_alt: Water-network monitoring interface and field instrumentation.
importance: 5
category: work
related_publications: true
---

Critical infrastructure must continue serving communities despite incomplete measurements, limited historical data, legacy equipment, and changing demand. This project combines graph anomaly detection with operational knowledge from Nashville Metro Water.

## Spectral anomaly detection

Our ICML 2026 paper develops a node-level spectral-energy formulation for graph anomaly detection. The method identifies both increases and decreases in spectral-energy variation, including anomalies that can appear normal to detectors focused only on increased variation. The formulation supports static and time-series graphs through graph message passing.

{% include figure.html path="assets/img/publication_preview/nashvillewater.png" title="Graph-based anomaly analysis for water-distribution measurements." class="img-fluid rounded z-depth-1" alt="Water-network graph used to illustrate node-level anomaly monitoring." %}

[Paper](https://proceedings.mlr.press/v306/liu26gb.html) · [code](https://github.com/AICPS-Lab/Spectral-Energy-Shifts-in-GAD)

## Nashville Metro Water collaboration

The collaboration studies leak detection under limited sensor coverage, limited historical data, and legacy-system constraints. Work with domain engineers and operators has helped identify actual leaks in the city's water network. This field experience informs what evidence a monitoring method must provide and how physical and operational constraints affect its use.

## Critical-infrastructure direction

The Nashville work supports the Vanderbilt Center for Sustainability, Energy, and Climate project *Reliable AI and Critical Infrastructure: Compliance, Resilience, and Explainability in Electric and Water Networks*. The project brings together computer science, engineering, and law to study how AI data-center growth affects electric and water systems. The direction is supported by the 2026 VSEC Seed Project Fund Award ($200,000 total).

Future work will connect physical constraints, anomaly analysis, and formal verification when measurements are incomplete. The goal is to assess whether operating or recovery decisions satisfy specified requirements without assuming a completed deployment or operator dashboard.
