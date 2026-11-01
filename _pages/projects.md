---
layout: page
title: Projects
permalink: /projects/
description: Research on safe control, formal verification, trustworthy AI, and critical infrastructure.
nav: true
nav_order: 2
horizontal: true
---

My research connects formal verification, control theory, and artificial intelligence to establish when physical AI systems satisfy specified requirements. The five projects below develop this program across safety certificates, resilient autonomy, differential-algebraic systems, neural-network verification, and infrastructure monitoring.

{% include figure.html path="assets/img/challenges-and-research.png" class="research-position img-fluid rounded z-depth-1" alt="Physical AI research map connecting a sensing-decision-action loop and its adversarial and black-box challenges to resilient control, safe physical AI, anomaly detection, verification, and verified intelligent autonomy." %}

<div class="projects">
  {%- assign sorted_projects = site.projects | sort: "importance" -%}
  <div class="container">
    <div class="row row-cols-1">
      {%- for project in sorted_projects -%}
        {% include projects_horizontal.html %}
      {%- endfor -%}
    </div>
  </div>
</div>
