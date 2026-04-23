---
layout: page
title: Mechanistic Interpretability of Small LLMs
description: Fourier structure, grokking acceleration, and where math reasoning breaks in small transformers.
img: assets/img/publication_preview/mi_grokking_curves.png
importance: 1
category: fun
related_publications: false
---

A side quest into what happens inside small language models when they (try to) do math. Three connected experimental phases, each starting from a different entry point and converging on the same question: when a model produces the wrong answer, what is actually wrong inside?

Phase 1 (`grokking_fourier_dim`) trains toy transformers from scratch on modular arithmetic and studies the grokking transition. Phase 2 (`llm_inter`) asks whether the same structure shows up in pre-trained LLMs. Phase 3 (`probing_concept`) probes whether larger LLMs (Phi-2, Qwen-2.5-3B) represent word-problem concepts as abstract entities or pattern-match surface forms. Together they map how Fourier structure, behavior, and downstream computation decouple at scale.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_grokking_curves.png" title="The grokking signature on (a + b) mod 59: memorize first, generalize much later." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

## Phase 1 — Grokking and the Fourier manifold

Training a 1-layer transformer (128d, 4 heads) on `(a + b) mod 59` reproduces the canonical grokking phenomenon: train accuracy saturates almost immediately; test accuracy stays at random for tens of thousands of epochs; then, somewhere around epoch 55,000, generalization clicks on.

The diff-of-means (DiM) direction between grokked and memorized checkpoints concentrates **93.7% of its energy in the top-5 Fourier modes**, and the manifold distance (1 − Fourier energy fraction) collapses from 0.92 to 0.007 right at the transition. The Fourier subspace is causally necessary: ablating it drops accuracy by 97.3%, while ablating the single DiM direction barely moves the needle.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_dim_fourier.png" title="DiM direction between grokked and memorized checkpoints aligns with the top-5 Fourier modes (93.7% energy)." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

With that structure named, a differentiable surrogate loss that penalizes energy outside the top-5 DFT modes can steer the model onto the manifold early. Grokking happens at epoch **1,416 instead of 55,000 — a 39× speedup**, with no curriculum required. Curricula alone help modestly (4.4× at best) and antagonize the regularizer when combined.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_acceleration_heatmap.png" title="Grokking epoch across (curriculum × Fourier-regularizer strength). λ=10 alone gives the 39× speedup." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

Pushing further exposes where this acceleration stops being automatic. Manifold-agnostic methods — spectral entropy, online DiM, Grokfast — each win one task and lose another. Spectral entropy helps multiplication (stalled → 23,217 epochs) but crushes rank to 1 and destroys addition. Enforcing the right rank without the right basis (SVD top-5) still stalls. **Knowing the basis is what matters; knowing only the rank is not enough.** And when a 1-layer model is asked to switch between addition and multiplication based on an operator token, embeddings can hold dual Fourier structure (77% concentration in both natural and discrete-log bases) but compute can't exploit it — per-operation accuracy stays at 16–26%. Two layers roughly doubles accuracy but still fails to grok both operations within 200k epochs. Multi-mode routing is a distinct bottleneck from single-operation grokking.

## Phase 2 — Do pre-trained LLMs use the same structure?

Running the same Fourier probes on Pythia (70M–410M), Qwen2.5-0.5B, and SmolLM2-135M reveals weak but real structure: value-indexed DFT concentrations 3–5× above random, peaking at 0.45 for Qwen on addition. Structure correlates almost perfectly with behavior (r = 0.99 between DFT concentration and generation accuracy in Qwen). But specialization is missing: LLMs use additive DFT for both addition *and* multiplication, unlike toy models that grok into distinct bases (natural for `+`, discrete-log for `×`). **Representational structure transfers; algorithmic basis differentiation does not.**

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_llm_dft_bars.png" title="Value-indexed DFT top-5 concentration across pre-trained models vs. a toy grokked baseline. LLMs sit 3–5× above random but an order of magnitude below the grokked toy." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

Fine-tuning Pythia-70M with the Fourier surrogate loss lifts DFT concentration from 0.38 to 0.96 — toy-grokked levels — yet behavioral accuracy only reaches 20% before collapsing. The manifold is reachable, but the rest of the network isn't wired to use it. Position-conditioned probing locates arithmetic commitment not at the `=` token but at the first answer digit, with compute-offset accuracy correlating r = 0.99 with generation accuracy. Chain-of-thought slightly *hurts* plain arithmetic (37% → 32%) by fragmenting the answer stream. Carries are handled holistically, not digit by digit.

Prompt scaffolds matter more than one might hope: Qwen2.5-0.5B jumps from 37% plain to 91% with a native chat template and to 100% with few-shot examples, while Pythia stays at 0% across every template — instruction tuning is a floor, not a ceiling. The same scaffolds raise residual-stream DFT concentration by +15pp.

Finally, when we push small LLMs onto word-problem optimization with a four-stage pipeline (extract → formulate → derive → code), computation scales steeply with model size (10% → 90% from Qwen-0.5B to Qwen-3B) but *comprehension plateaus* — formulation quality stays around 72% regardless of size. Models get lucky when missing implicit constraints happen not to bind at the optimum. Domain-axiom grounding lifts constraint recall by +20% on average and unlocks Phi-2 dramatically (0/3 → 2/3 solve, +73% recall), but Qwen2.5-3B paradoxically degrades under grounding — larger models already know the domains and external axioms interfere.

## Phase 3 — Are concepts represented, and where do errors originate?

Phase 3 goes residual-hunting. Two 2.7–3.1B models (Phi-2, Qwen-2.5-3B), two problems (maximize rectangle area, compute impact velocity), 200 paraphrased prompts per cell with variable-name / domain / value axes, K=32 samples each at T=0.7. Keep paraphrases that produce both a correct and an incorrect completion, so correctness varies with everything else held fixed. Capture all-layer residual-stream activations on the teacher-forced prompt+answer pair. ~600 matched pairs, about 100 GB of HDF5.

Three pre-registered probes run per layer on each side of the pair: P1 (k-means clustering of variable vectors against gold role labels), P2 (cosine similarity of variable vectors under paraphrase perturbations that change name, role, or domain), P3 (logistic regression decoding which relation is being formed — perimeter-eq vs. area-eq, or kinematic-eq vs. sqrt-form — with 5-fold cross-validation grouped by paraphrase to block idiom leakage).

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/publication_preview/mi_phi2_relation.png" title="Relation structure is near-perfectly decodable from mid-depth onward. The same shape holds whether the completion is correct or incorrect." class="img-fluid rounded z-depth-1" %}
    </div>
</div>

Three predictions — binding failure, concept regression, relation collapse — would each have produced a visible gap between correct and incorrect probe curves. None did. Relation probes hit macro-F1 ∈ [0.95, 1.00] from the quarter-depth layer onward, identical on both sides to within 0.03. Variable clusters start distinct at L0 and *decay* with depth (opposite of the predicted mid-layer emergence), also identical across sides. Concept-over-name cosine peaks mid-depth and regresses at output in every cell; again, identical.

**By elimination, errors do not live in the represented concepts.** Whatever goes wrong when these models produce an incorrect answer lives downstream of the residual stream — in arithmetic, value binding, or final decoding. That negative result lines up with Phase 2's computation–comprehension gap: the structure is there; the compute path that should consume it isn't.

## What this gives me

A shared mental model across three very different setups: the Fourier phase that controls grokking in toy models is detectable in pre-trained LLMs but not differentiated across operations; the structure is causally necessary but not sufficient to explain behavior; and inside larger LLMs on real math word problems, the concept representations look fine but the downstream computation is where reasoning fails. The next moves are clear — push Phase 3's MLP-activation probes to localize the arithmetic site, and explore whether domain-axiom grounding can be internalized rather than injected.

Code and per-stage write-ups live in [`HongchaoZhang-HZ/MI`](https://github.com/HongchaoZhang-HZ/MI) (private).
