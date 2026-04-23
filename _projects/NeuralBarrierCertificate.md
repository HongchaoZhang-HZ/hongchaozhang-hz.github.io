---
layout: page
title: Safe AI-Embedded Robots
description: End-to-end safety verification and synthesis for robotic systems whose controllers — or whose safety certificates themselves — are neural networks.
img: assets/img/publication_preview/zhang2024seev_poster.jpg
importance: 3
category: work
related_publications: true
---

Modern robotic systems increasingly embed learning-enabled components — neural controllers, perception modules, learned dynamics — because they outperform hand-designed alternatives on perception-rich, high-dimensional tasks. The same opacity that makes them expressive makes them hard to certify: neither the controller nor the safety monitor is a polynomial one can write down, and the compositions of ReLU layers interact with physical dynamics in ways that exhaustive simulation cannot cover. This project develops the theory and tooling to provide **exact** safety guarantees for neural control barrier functions (NCBFs) and NCBF-certified controllers, at scales that matter for real robots.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/zhang2024seev_poster.jpg" title="NeurIPS 2024 poster — SEEV: Synthesis with Efficient Exact Verification for ReLU Neural Barrier Functions." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Exact verification of ReLU neural barrier functions (NeurIPS 2023)

The starting point is a hard negative: sound-but-incomplete NCBF verifiers (based on interval bound propagation or Lipschitz arguments) routinely reject barrier functions that are actually correct, because their over-approximations balloon at every ReLU. We reformulated NCBF verification as **exact decomposition along activation patterns**, turning a global non-convex problem into a bounded set of local linear subproblems — one per activation pattern touching the decision boundary. Each local subproblem is either a linear program or a small SMT query, both of which modern solvers close quickly.

The pipeline searches activation patterns adjacent to the zero level set (the NCBF boundary) and checks the safety condition exactly on each. Compared to bound-propagation baselines, the exact verifier certifies NCBFs that previous methods rejected and scales to dynamical systems in the tens of state dimensions that otherwise required prohibitive relaxations.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/zhang2023exact.png" title="NeurIPS 2023 poster — exact decomposition of ReLU NCBF verification along activation patterns." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## SEEV — Synthesis with Efficient Exact Verification (NeurIPS 2024)

Verification is only half the problem: a certified NCBF also has to be trainable in the first place. SEEV (*Synthesis with Efficient Exact Verification for ReLU Neural Barrier Functions*) closes the loop by co-designing the training procedure with the exact verifier. The key idea is to **prune unreachable activation patterns during training**, so the set the verifier has to check at the end is only those patterns the network actually realizes on boundary-relevant inputs. This gives roughly **100× scalability** over naive train-then-verify pipelines and brings NCBFs into practical ranges for autonomous driving and quadrotor obstacle avoidance.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/seev_training.jpg" title="SEEV training framework: activation-pattern pruning is interleaved with standard NCBF training losses, yielding a verified-from-the-start certificate at the end of training." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

SEEV supports NCBFs of non-trivial relative degree via a neural HOCBF extension, handles both low-dim analytical benchmarks (Obstacle Avoidance, Darboux) and higher-dim systems (satellite attitude, 6-DOF quadrotor), and provides counterexamples when training hasn't converged — a useful artifact for diagnosing why a candidate barrier fails.

## Fault-tolerant neural CBFs for robotic systems (ICRA 2024)

Real robots don't face benign inputs. The *Fault-Tolerant Neural CBFs* line (ICRA 2024) extends NCBFs to the adversarial-sensor setting: the network receives sensor observations that may be spoofed or faulted, and must still maintain a safety certificate. The construction couples a fault-tolerant CBF structure (from the [Resilient CPS](../faulttolerantcontrol/) thread) with a neural CBF parameterization, proving joint safety + stability under bounded sensor attack models. Demonstrated on a wheeled robot and a quadrotor with simulated LiDAR spoofing.

## Stochastic neural CBFs (IEEE TAC, under review)

Extending to stochastic dynamics, *Stochastic Neural Control Barrier Functions* (Zhang, Tayal, Cox, Jagtap, Kolathaya, Clark; IEEE TAC under review) provides probabilistic forward-invariance guarantees for NCBF-certified controllers under stochastic disturbances and learning-enabled perception. The probabilistic bounds are tight enough to be useful and the training procedure remains tractable on standard GPUs.

## Connection to the broader program

This project sits at the "algorithm-level certification" end of a larger research program on trustworthy AI-enabled CPS. The [DAE-CBF](../daecbf/) work extends neural-CBF ideas to systems with algebraic constraints; the [Resilient CPS](../faulttolerantcontrol/) work supplies the fault-tolerant scaffolding; and the side-project [concept-probing](../mi_conceptprobing/) thread on mechanistic interpretability of LLMs is methodologically adjacent — both projects treat activation patterns as first-class objects rather than black-box summaries.

## Selected papers

- Zhang, Qin, Gao, Clark. *SEEV: Synthesis with Efficient Exact Verification for ReLU Neural Barrier Functions.* NeurIPS 2024.
- Zhang, Wu, Vorobeychik, Clark. *Exact Verification of ReLU Neural Control Barrier Functions.* NeurIPS 2023.
- Zhang, Niu, Clark, Poovendran. *Fault-Tolerant Neural Control Barrier Functions for Robotic Systems under Sensor Faults and Attacks.* ICRA 2024.
- Zhang, Tayal, Cox, Jagtap, Kolathaya, Clark. *Stochastic Neural Control Barrier Functions.* IEEE TAC, under review.
