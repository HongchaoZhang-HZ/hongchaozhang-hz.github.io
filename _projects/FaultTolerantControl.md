---
layout: page
title: Resilient CPS
description: Safety and stability under sensor faults, actuator failures, and adversarial attacks — from CDC 2020 fault-tolerant CBFs to GM-award LiDAR defense.
img: assets/img/publication_preview/FTNCBF_Demo.gif
importance: 4
category: work
related_publications: true
---

Safety-critical CPS — autonomous vehicles, surgical robots, power grids — live in adversarial environments with sensor noise, sensor faults, actuator failures, and active cyber-attacks. Adversarial inputs invalidate the dynamical and measurement models underlying every nominal safety guarantee. This project builds the theory and practice of **resilient safe control**: controllers and observers that jointly ensure safety and stability *even when a bounded subset of sensors is compromised*, with provable guarantees under explicit fault-and-attack models.

## The first fault-tolerant CBFs (CDC 2020)

*Control Barrier Functions for Safe CPS Under Sensor Faults and Attacks* (Clark, Li, Zhang; CDC 2020) introduced the first fault-tolerant Control Barrier Function framework. The construction bounds the number of compromised sensors and shows that a CBF built from the **intersection of safe sets computed under every feasible fault pattern** preserves forward invariance — safety — as long as at least one uncorrupted sensor reading is consistent with the true state. This converted an adversarial security problem into a standard control-synthesis problem, at the cost of a combinatorial enumeration of fault patterns that the paper managed via structural properties of the observability Gramian.

## Extensions to high relative degree (IEEE TAC 2025)

*Safe Control for Nonlinear Systems under Faults and Attacks via Control Barrier Functions* (Zhang, Li, Clark; IEEE TAC 2025) generalized the CDC 2020 result to nonlinear systems with high-relative-degree CBFs, sensor and actuator faults, and bounded disturbances — a class that covers autonomous vehicles with multi-sensor perception stacks and underactuated platforms. The paper establishes joint safety and stability guarantees and provides a synthesis procedure for the fault-tolerant barrier itself, rather than requiring it as given.

## Fault-tolerant *neural* CBFs (ICRA 2024)

Classical FT-CBFs are polynomial or analytically specified, which limits their expressiveness for high-dimensional sensor stacks. *Fault-Tolerant Neural Control Barrier Functions for Robotic Systems under Sensor Faults and Attacks* (Zhang, Niu, Clark, Poovendran; ICRA 2024) extends the fault-tolerant construction to neural CBFs, coupling the stochastic state-estimation / fault-isolation structure of the classical framework with neural CBF parameterization. This yields expressive safety certificates that still carry resilience guarantees under bounded sensor-attack models, verified via the exact NCBF machinery from the [Safe AI-Embedded Robots](../neuralbarriercertificate/) thread.

## LiDAR-specific attack-resilience (CDC 2022, VehicleSec 2023)

Autonomous vehicles depend on high-dimensional sensors — LiDAR being the canonical case — that are content-rich and vulnerable to point-cloud spoofing. Fault-detection methods designed for scalar sensor faults don't carry over. *Barrier Certificate based Safe Control for LiDAR-based Systems under Sensor Faults and Attacks* (Zhang, Cheng, Niu, Clark; CDC 2022) used the **inconsistency** of spoofed LiDAR readings against redundant complementary sensors as a detection signal, then reconstructed the 2D LiDAR measurement from maps and fused it with localization priors to jointly detect faults and preserve safety.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/ft_estimation.png" title="Fault-tolerant state estimation — reconstructing a consistent state estimate from a combination of potentially spoofed LiDAR and complementary sensors." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

*Cooperative Perception for Safe Control of Autonomous Vehicles under LiDAR Spoofing Attacks* (Zhang, Li, Cheng, Clark; VehicleSec 2023) extended this to 3D LiDAR and multi-vehicle scenarios. The key observation is that different vehicles see an attacker's injected points from different angles, and **cross-vehicle inconsistency** is a strong detection signal for three distinct classes of LiDAR spoofing attack. After identifying and removing poisoned points, safe regions are reconstructed from purified data with provable guarantees. This work received the **General Motors AutoDriving Security Award (Best Paper)** at VehicleSec 2023.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/VehicleSec23Thumbnail.png" title="Cooperative perception pipeline across multiple autonomous vehicles under coordinated LiDAR spoofing — cross-vehicle inconsistency reveals the attack." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## What this thread gives

A vertical slice from theory to deployed demonstration: the theoretical resilience result (CDC 2020) that made adversarial-sensor safety a solvable control problem, the journal-paper generalization (IEEE TAC 2025) that extended it to realistic nonlinear systems with actuator faults, the neural extension (ICRA 2024) that made it expressive enough for real sensor stacks, and the security-venue case studies (CDC 2022, VehicleSec 2023) that proved the pipeline out on LiDAR — the most adversarially-exposed sensor modality in autonomous driving. The VehicleSec 2023 GM award is the visible artifact; the infrastructure underneath is what connects this line back to [DAE-CBF](../daecbf/) (for constrained, networked extensions) and forward to the AI-generated-code verification thread in my future research agenda.

## Selected papers

- Zhang, Li, Clark. *Safe Control for Nonlinear Systems under Faults and Attacks via Control Barrier Functions.* IEEE TAC, 2025.
- Zhang, Niu, Clark, Poovendran. *Fault-Tolerant Neural Control Barrier Functions for Robotic Systems under Sensor Faults and Attacks.* ICRA 2024.
- Zhang, Li, Cheng, Clark. *Cooperative Perception for Safe Control of Autonomous Vehicles under LiDAR Spoofing Attacks.* VehicleSec (ISOC Symposium on Vehicle Security and Privacy) 2023. **General Motors AutoDriving Security Award.**
- Zhang, Cheng, Niu, Clark. *Barrier Certificate based Safe Control for LiDAR-based Systems under Sensor Faults and Attacks.* CDC 2022.
- Clark, Li, Zhang. *Control Barrier Functions for Safe CPS Under Sensor Faults and Attacks.* CDC 2020.
