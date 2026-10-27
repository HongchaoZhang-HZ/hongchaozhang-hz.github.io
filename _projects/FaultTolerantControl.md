---
layout: page
title: Resilient Control and Verified Autonomy
permalink: /projects/faulttolerantcontrol/
description: Safe control under sensor faults and attacks, cooperative perception, and verified autonomous navigation.
img: assets/img/publication_preview/FTNCBF_Demo.gif
img_fallback: assets/img/publication_preview/FTNCBF_Demo-static.png
img_alt: Animated robot demonstration of fault-tolerant neural safety control.
importance: 2
category: work
related_publications: true
---

Autonomous systems must remain safe when sensing is faulty or adversarially manipulated. This project connects fault diagnosis, state estimation, and control-barrier-function intervention under explicit fault and attack models.

## Fault-tolerant safe control

Our CDC 2020 work introduced a fault-tolerant CBF framework for safe control under sensor faults and attacks. The 2025 IEEE Transactions on Automatic Control paper extends the approach to nonlinear systems. A bank of extended Kalman filters estimates the state under different hypotheses about compromised sensors. Consistency checks exclude incompatible estimates, and the controller enforces CBF constraints for the remaining plausible states while accounting for estimation error.

## Neural certificates and cooperative perception

The ICRA 2024 work extends fault-tolerant control to neural CBFs. The controller combines learned safety certificates with the fault-isolation structure while retaining guarantees under the stated sensor-fault and attack assumptions.

{% include animated_media.html path="/assets/img/publication_preview/FTNCBF_Demo.gif" fallback="/assets/img/publication_preview/FTNCBF_Demo-static.png" caption="Fault-tolerant neural control barrier function demonstration." alt="Animated robot demonstration of fault-tolerant neural control barrier function control." %}

{% include figure.html path="assets/img/publication_preview/ft_estimation.png" title="State-estimation structure for fault-tolerant safe control." class="img-fluid rounded z-depth-1" alt="Diagram of multiple state estimators used to identify sensor faults and support safe control." %}

For LiDAR-based autonomy, the CDC 2022 work combines barrier-certificate control with fault detection and state estimation. The VehicleSec 2023 extension uses cross-vehicle inconsistency to identify LiDAR spoofing in cooperative perception. That paper received the General Motors AutoDriving Security Award.

## Verified autonomy testbed

At Vanderbilt's Verification and Validation for Intelligent and Trustworthy Autonomy Laboratory, we built an indoor drone-navigation testbed for studying verified safety conditions in cluttered environments. The Safe Flight manuscript uses a verified union of neural CBFs. The manuscript remains under review; this page does not claim a deployed system or accepted result.

## Papers and code

- [Safe Control for Nonlinear Systems under Faults and Attacks via Control Barrier Functions](https://doi.org/10.1109/TAC.2025.3571338)
- [Fault Tolerant Neural Control Barrier Functions for Robotic Systems under Sensor Faults and Attacks](https://doi.org/10.1109/ICRA57147.2024.10610491) · [code](https://github.com/HongchaoZhang-HZ/FTNCBF)
- [Barrier Certificate based Safe Control for LiDAR-based Systems under Sensor Faults and Attacks](https://doi.org/10.1109/CDC51059.2022.9992432) · [code](https://github.com/HongchaoZhang-HZ/FT-BarrierCertificate)
- [Cooperative Perception for Safe Control of Autonomous Vehicles under LiDAR Spoofing Attacks](https://doi.org/10.14722/vehiclesec.2023.23066)
