---
layout: page
title: "{Trustworthy AI+CPS}"
description: Safety Guarantees of Learning-Enabled CPS
img: assets/img/12.jpg
importance: 1
category: work
related_publications: true
---
Safety is critical in Cyber-Physical Systems (CPS) applications, including autonomous driving systems, power grids, and medical robots, and faces multiple challenges. 

CPS are increasingly integrated with learning-enabled components such as Neural Networks (NNs) to enhance performance and adaptability. Such integration increases the complexity of safety verification due to the lack of transparency and interpretability of the NN components.



<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/1.jpg" title="map" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.html path="assets/img/2.jpg" title="patterns" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-3 mt-3 mt-md-0">
        {% include figure.html path="assets/img/3.jpg" title="phylo" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Caption test test
</div>

The goal of my research is to design trustworthy learning-enabled CPS and ensure continued safe operation. The work consists of two major aspects: (i). safety verification for learning-enabled systems and (ii). safe control policy training with formal guarantees.



<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/zhang2023exact.png" title="cor" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    NeurIPS 2023 Poster: Exact Verification of ReLU Neural Control Barrier Functions
</div>


Safety verification of learning-enabled CPS is challenging due to the high dimensionality and nonlinear dynamics of the underlying physical system, as well as the complexity of the ML models. Existing approaches mitigate these challenges either by exhaustive search over the state space (which may not scale to high-dimensional systems) or constructing over-approximations of the output space of the NNs, leading to  over-conservative verification.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/zhang2024seev_poster.jpg" title="cor" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    NeurIPS 2024 Poster: SEEV: Synthesis with Efficient Exact Verification for ReLU Neural Barrier Functions 
</div>