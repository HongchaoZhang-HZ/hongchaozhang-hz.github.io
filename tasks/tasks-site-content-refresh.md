# Task Plan: Full Academic Site Refresh

## Status

Correction verified — commit/push authorized and pending

The full-site refresh passed its first final verification. The 2026-10-27 user correction reopens the task to restore publication year dividers, use one chronological timeline with inline under-review labels, and restore the public title `Outreach`. Commit and push are authorized after validation; no separate manual deployment is authorized.

## Inputs

- PRD: tasks/prd-site-content-refresh.md
- Stable task: DZSITE-20261026-001
- Expanded Stage 1 inventory: thread 01a17b61-acc3-7211-a791-4b45a66aad66, PASS
- Current task artifact: DROID Z binding for DZSITE-20261026-001
- Target repository: logical root website/, branch master at intake
- Read-only source repository: logical root AcadJob/job_app/
- Primary content sources:
  - AcadJob/job_app/cv/cv.tex and cv/cv.pdf
  - AcadJob/job_app/research_statement/body.tex, references.bib, research-statement.pdf, and figures/
  - AcadJob/job_app/teaching_statement/statement-body.tex and teaching-statement.pdf
- Approved scope: full local rewrite, metadata and link reconciliation, source-backed media work, fixture cleanup, build, rendered review, and independent verification
- Excluded actions: source-repository writes, separate manual deployment, external messages, and unrelated application-state changes. The main coordinator may commit and push only after T16 PASS.

## Protected Baseline

The current uncommitted mechanical refresh is the starting point and must not be lost:

- _bibliography/papers.bib
- _config.yml
- _pages/Outreach.md
- _pages/Teaching.md
- _pages/about.md
- _projects/DAECBF.md
- _projects/NashvilleWater.md
- _projects/NeuralBarrierCertificate.md
- assets/json/resume.json, deleted
- assets/pdf/Hongchao-Zhang-CV.pdf
- tasks/prd-site-content-refresh.md
- tasks/tasks-site-content-refresh.md
- tasks/verification-site-content-refresh.md

The active CV baseline SHA-256 is c0f564fd4cc9a0f8a91d632109c45809df927833d790419e9147bbc5ab2c1f53. The retained thesis baseline SHA-256 is d845c443e25c6019d9f5cde18f24edfd735a4bcff571674677c9124f882fa8f3. Recompute both at implementation start; do not treat these planning-time hashes as freshness proof.

The existing tasks/verification-site-content-refresh.md is historical evidence for the bounded mechanical pass. The main coordinator must mark it superseded before expanded final verification; it cannot satisfy T12 below.

## Final Site Architecture

| Order | Route | Source | Final role |
|---|---|---|---|
| Home | / | _pages/about.md | Research identity, position, three established research areas, education/experience, future directions, portrait, thesis |
| 1 | /publications/ | _pages/publications.md | One reverse-chronological timeline with visible year dividers and inline review status |
| 2 | /projects/ | _pages/projects.md | Five RS-aligned project cards and research overview |
| 3 | /Teaching/ | _pages/Teaching.md | Teaching philosophy, evidence, experience, mentoring, interests |
| 4 | /Outreach/ | _pages/Outreach.md | Academic service, talks, research support, awards and fellowships |
| 5 | /cv/ | _pages/cv.md | CV landing route with direct access to the active PDF |
| document | /assets/pdf/Hongchao-Zhang-CV.pdf | CV PDF | Direct active CV |
| utility | /404.html | 404.html | Retained error route |

Five project routes are retained through their existing filenames:

1. _projects/NeuralBarrierCertificate.md — Safe AI Control
2. _projects/FaultTolerantControl.md — Resilient Control and Verified Autonomy
3. _projects/DAECBF.md — DAE-Aware Safe Control
4. _projects/SNNV.md — AI Verification and Interpretation
5. _projects/NashvilleWater.md — Critical-Infrastructure Monitoring

## Relevant Files

### Planned content and renderer changes

- _config.yml — final site description, collection/feature cleanup, publication field filtering, exclusion policy
- _pages/about.md — full CV/RS-aligned About rewrite
- _pages/publications.md — one year-grouped publication timeline
- _pages/projects.md — five-project research overview
- _pages/Teaching.md — full TS/CV-aligned rewrite
- _pages/Outreach.md — service, invited talks, research support, awards and fellowships
- _pages/cv.md — clean direct-CV route
- _projects/NeuralBarrierCertificate.md — Safe AI Control rewrite
- _projects/FaultTolerantControl.md — Resilient Control and Verified Autonomy rewrite
- _projects/DAECBF.md — DAE-Aware Safe Control rewrite
- _projects/SNNV.md — AI Verification and Interpretation rewrite
- _projects/NashvilleWater.md — Critical-Infrastructure Monitoring rewrite
- _bibliography/papers.bib — 24 reconciled published/accepted records plus eight public preprint/under-review records
- _layouts/about.html — remove dead news/latest-post include branches only if their final references are removed
- _layouts/bib.html — status-safe links, title-based preview alt text, optional-data fallbacks, and animated-media handling if needed
- _includes/projects_horizontal.html — card semantics/alt text only if required by rendered review
- _includes/animated_media.html — add only if needed for static reduced-motion fallbacks
- _sass/_base.scss — add only the motion/focus/responsive rules required by acceptance
- site.webmanifest — satisfy the existing manifest reference with current site identity and icon paths
- Gemfile and Gemfile.lock — remove jekyll-get-json and update the lockfile
- assets/pdf/Hongchao-Zhang-CV.pdf — synchronize only if the active CV hash changed
- assets/img/research-overview.png — copy from the active RS research map
- assets/img/publication_preview/ — verified publication previews, optimized animations, and static fallbacks
- tasks/site-refresh-audit.rb — excluded deterministic audit for bibliography, deletion references, media provenance, local/generated links, and external-link inventory

### Planned deletions: pages and collections

- _projects/MI_Arithmetic.md
- _projects/MI_ConceptProbing.md
- _projects/MI_Grokking.md
- _projects/MI_LLMInternals.md
- _projects/MI_RepEReading.md
- _projects/MI_VanillaSteering.md
- _pages/dropdown.md
- _pages/repositories.md
- blog/index.html
- news.html
- _news/CDC2024a.md
- _news/CDC2024b.md
- _news/ICAA2024.md
- _news/NeurIPS2024.md

### Planned deletions: data and dependencies

- _data/cv.yml
- _data/repositories.yml
- _data/coauthors.yml
- _data/venues.yml
- assets/json/resume.json, already deleted in the protected baseline
- jekyll-get-json entries in Gemfile and Gemfile.lock

### Planned deletions: six-page MI asset set

- assets/img/publication_preview/ag_biology.png
- assets/img/publication_preview/ag_methods.png
- assets/img/publication_preview/mi_acceleration_heatmap.png
- assets/img/publication_preview/mi_arithmetic_thumb.png
- assets/img/publication_preview/mi_dim_fourier.png
- assets/img/publication_preview/mi_grokking_curves.png
- assets/img/publication_preview/mi_llm_acc_vs_dft.png
- assets/img/publication_preview/mi_llm_dft_bars.png
- assets/img/publication_preview/mi_repe_problemsolve.png
- assets/img/publication_preview/mi_steer_thumb.png

### Planned deletions: confirmed theme/demo fixtures

- assets/audio/epicaly-short-113909.mp3
- assets/video/pexels-engin-akyurt-6069112-960x540-30fps.mp4
- assets/plotly/demo.html
- assets/json/table_data.json
- assets/pdf/example_pdf.pdf
- assets/img/al-folio-preview.png
- assets/img/code-screenshot.png
- assets/img/distill-screenshot.png
- assets/img/math-screenshot.png
- assets/img/photos-screenshot.png
- assets/img/projects-screenshot.png
- assets/img/publications-screenshot.png
- assets/img/publication_preview/brownian-motion.gif
- assets/img/publication_preview/wave-mechanics.gif

### Conditional dead-code deletions

Delete only after repository-wide references are zero after the final page rewrites:

- _includes/repository/
- _includes/resume/
- _includes/cv/
- _includes/news.html
- _includes/latest_posts.html
- _layouts/cv.html
- news/blog-only archive layouts and pagination include

Generic components that remain transitively referenced must stay.

### Required preservation

- assets/img/my_pic_seaside_front_small.jpg and all personal portraits/photos, including assets/img/1.jpg through assets/img/12.jpg
- assets/pdf/Resilient_Safe_Control_of_Autonomous_Systems.pdf
- active CV PDF
- all favicon and platform icon assets
- current publication previews mapped to retained records unless a verified replacement is installed
- FTNCBF_Demo.gif, TAC25FTSCBF.gif, TAC25SNCBF.gif, daecbf_3link.gif, and daecbf_manipulator.gif, with verified optimization allowed
- unrelated user changes and repository infrastructure not listed for removal

### Execution state

- The protected mechanical baseline changed the ten product paths listed above.
- Stage 2 replaced the PRD and this task plan for the expanded scope.
- tasks/verification-site-content-refresh.md exists from the bounded pass and has not been edited in this stage.
- Expanded product implementation, repair, build, and local validation are complete. No commit, push, deployment, or publication has occurred.

## Privacy-Safe Provenance Contract

- Keep factual and media provenance only in this excluded task plan or later excluded verification evidence.
- Use logical references such as AcadJob/job_app/cv/cv.tex:160, website/_pages/about.md, DAE-aware_CBF/figures/example.pdf, or an authoritative public URL.
- Never persist a machine-local absolute path in repository artifacts.
- Do not add source comments to YAML, Markdown, BibTeX, HTML, JSON, CSS, or generated pages.
- For each copied or extracted figure, record source URL/path, PDF page, figure number or crop description, target file, and SHA-256.
- For each optimized animation, record original/final SHA-256, bytes, frame count, duration, dimensions, and static fallback.
- For deletions, record the zero-reference command and result before removal.
- AcadJob and all research repositories are read-only evidence.

## Publication Authority and Worklist

Every item below has completed metadata/link/media reconciliation. Published and accepted entries receive status_group = published. Public preprints and under-review entries receive status_group = preprint. The field is filtered from displayed BibTeX.

### Published and accepted: 24 records

- [x] P01 9303766
  - Authority: https://doi.org/10.1109/CDC42340.2020.9303766
  - Action: retain CDC 2020 metadata; add explicit paper/DOI URL; retain IEEECDC2020.png.
- [x] P02 9683019
  - Authority: https://doi.org/10.1109/CDC45484.2021.9683019
  - Action: retain CDC 2021 metadata; retain IEEECDC2021.jpg unless a verified higher-resolution paper figure is obtained.
- [x] P03 9561253
  - Authority: https://doi.org/10.1109/ICRA48506.2021.9561253
  - Action: retain ICRA 2021 metadata; rename misleading ICRA2020.gif to an ICRA 2021 name and update references without changing animation.
- [x] P04 9992432
  - Authority: https://doi.org/10.1109/CDC51059.2022.9992432
  - Action: retain CDC 2022 metadata and IEEECDC2022.png; add https://github.com/HongchaoZhang-HZ/FT-BarrierCertificate.
- [x] P05 zhang2023cooperative
  - Authority: https://doi.org/10.14722/vehiclesec.2023.23066
  - Action: normalize DOI URL, retain award note and VehicleSec23Thumbnail.png.
- [x] P06 11006510
  - Authority: https://doi.org/10.1109/TAC.2025.3571338 and AcadJob/job_app/cv/cv.tex:159-160
  - Action: retain final TAC 70(11), 7334--7349, November 2025 metadata; normalize title capitalization; retain and optimize TAC25FTSCBF.gif with fallback.
- [x] P07 10384199
  - Authority: https://doi.org/10.1109/CDC49753.2023.10384199
  - Action: retain CDC 2023 metadata and IEEECDC2023.png; add https://github.com/HongchaoZhang-HZ/Sampling_CBF_Synthesis_Verification.
- [x] P08 NEURIPS2023_120ed726
  - Authority: https://proceedings.neurips.cc/paper_files/paper/2023/file/120ed726cf129dbeb8375b6f8a0686f8-Paper-Conference.pdf
  - Action: retain volume/pages; use a method figure rather than a dense page image when auditable; add https://github.com/HongchaoZhang-HZ/exactverif-reluncbf-nips23.
- [x] P09 NEURIPS2024_b7868ded
  - Authority: https://proceedings.neurips.cc/paper_files/paper/2024/file/b7868dedad7192f83c9efb042da43317-Paper-Conference.pdf and AcadJob/job_app/research_statement/references.bib:42-54
  - Action: preserve equal-contribution note; use seev_training.jpg as preview; retain poster as secondary media; add https://github.com/HongchaoZhang-HZ/SEEV.
- [x] P10 niu2024responsibleexplainingsafetyviolations
  - Authority: https://arxiv.org/abs/2410.20288 and AcadJob/job_app/cv/cv.tex:211-212
  - Action: change article to inproceedings, use the full IEEE ICAA venue, and replace the text-heavy preview only if the public paper yields a clear source figure.
- [x] P11 10886052
  - Authority: https://doi.org/10.1109/CDC56724.2024.10886052
  - Action: retain CDC 2024 metadata and IEEECDC2024.gif.
- [x] P12 10885943
  - Authority: https://doi.org/10.1109/CDC56724.2024.10885943
  - Action: retain CDC 2024 metadata; replace cdc24compatible.jpg only if a verified higher-resolution source figure is available.
- [x] P13 10610491
  - Authority: https://doi.org/10.1109/ICRA57147.2024.10610491
  - Action: retain ICRA 2024 metadata; optimize FTNCBF_Demo.gif with fallback; add https://github.com/HongchaoZhang-HZ/FTNCBF.
- [x] P14 zhang2025stochasticneuralcontrolbarrier
  - Authority: https://arxiv.org/abs/2506.21697 and AcadJob/job_app/cv/cv.tex:161-163
  - Action: retain IEEE TAC to-appear March 2027 status; retain TAC25SNCBF.gif; add https://github.com/tayalmanan28/Stochastic-NCBF.
- [x] P15 liu2026spectral
  - Authority: https://proceedings.mlr.press/v306/liu26gb.html
  - Action: retain ICML 2026/PMLR 306/pages; add https://github.com/AICPS-Lab/Spectral-Energy-Shifts-in-GAD; add a framework preview from the publisher paper or verified source repository.
- [x] P16 zhang2026synthesis
  - Authority: https://css.paperplaza.net/conferences/conferences/CDC26/program/CDC26_ContentListWeb_5.html and https://woodingben.com/papers/daecbf2026.pdf
  - Action: retain CDC 2026 to-appear status; add program/PDF and https://github.com/HongchaoZhang-HZ/DAE-aware_CBF; prefer DAECBC_Draft/figures/DAECBF_Overview.pdf or the author-PDF overview.
- [x] P17 kazma2026safe
  - Authority: https://css.paperplaza.net/conferences/conferences/CDC26/program/CDC26_ContentListWeb_5.html and https://woodingben.com/papers/semiexplicitdae2026.pdf
  - Action: retain CDC 2026 to-appear status; add links and DAE code; extract an overview only with page/figure provenance.
- [x] P18 wooding2026takeover
  - Authority: https://css.paperplaza.net/conferences/conferences/CDC26/program/CDC26_ContentListWeb_3.html and https://woodingben.com/papers/safetakeover2026.pdf
  - Action: retain CDC 2026 to-appear status; add program/PDF; extract the descriptor-system overview only with page/figure provenance.
- [x] P19 wooding2027selfcorrecting
  - Authority: https://link.springer.com/chapter/10.1007/978-3-032-32357-6_9
  - Action: retain SAIV 2026, LNCS 16831, pages 191--211, citation year 2027 and online-2026 note; omit preview unless a reusable overview is confirmed.
- [x] P20 wooding2026kinductive
  - Authority: https://arxiv.org/abs/2605.20108 and https://woodingben.com/papers/kinductiveneural2026.pdf
  - Action: retain NeuS 2026/PMLR acceptance; add links; extract the author-PDF overview only with page/figure provenance.
- [x] P21 tumlin2026nnv3
  - Authority: https://conf.researchr.org/details/aplas-atva-2026/atva-2026/18/NNV3-Expanding-Neural-Network-Verification-to-New-Architectures-and-Domains and https://woodingben.com/papers/nnv3_2026.pdf
  - Action: retain ATVA 2026/Springer/to-appear and equal-contribution note; add official/PDF links; extract the architecture/domain overview.
- [x] P22 wang2025contest
  - Authority: https://doi.org/10.1145/3719027.3765129 and AcadJob/job_app/research_statement/references.bib:108-119
  - Action: retain ACM CCS 2025, pages 3311--3325, DOI and equal-contribution note; add a preview only from an auditable public paper overview.
- [x] P23 ijcai2026p789
  - Authority: https://ijcai.org/proceedings/2026/789 and https://ijcai.org/proceedings/2026/0789.pdf
  - Action: retain IJCAI 2026, pages 7093--7101 and DOI; add official paper link and an overview only with page/figure provenance.
- [x] P24 serbinowska2026fmas
  - Authority: https://fmasworkshop.github.io/FMAS2026/ and https://www.taylortjohnson.com/bibtexbrowser.php?bib=johnson_taylor_t.bib&key=serbinowska2026fmas
  - Action: normalize venue and move to-appear language to note; omit preview until a public paper or author figure exists.

### Public preprints and under review: eight records

- [x] P25 zhang2026dae
  - Authority: https://arxiv.org/abs/2603.13509 and AcadJob/job_app/cv/cv.tex:165-171
  - Action: add arXiv preprint with Under review at International Journal of Robust and Nonlinear Control; use a DAE overview only with source provenance.
- [x] P26 zhang2027semiimplicit
  - Authority: https://openreview.net/forum?id=IzG8PUZzVA and AcadJob/job_app/cv/cv.tex:234-235
  - Action: retain as an under-review record in the chronological timeline; use no preview unless the public paper supplies an auditable overview.
- [x] P27 zhang2027error
  - Authority: https://openreview.net/forum?id=A3GcPTSUMW and AcadJob/job_app/cv/cv.tex:236-237
  - Action: retain as an under-review record in the chronological timeline; do not reuse unsupported MI-page claims or graphics.
- [x] P28 liu2027vocabulary
  - Authority: https://openreview.net/forum?id=G9XcJvABUT and AcadJob/job_app/cv/cv.tex:238-239
  - Action: retain as an under-review record in the chronological timeline; use a public-paper overview only.
- [x] P29 wooding2027inputagnostic
  - Authority: https://openreview.net/forum?id=O5PJn9pKNh and AcadJob/job_app/cv/cv.tex:240-241
  - Action: retain as an under-review record in the chronological timeline; use a public-paper overview only.
- [x] P30 he2027formal
  - Authority: https://openreview.net/forum?id=QXpqiE7Syr and AcadJob/job_app/cv/cv.tex:242-243
  - Action: retain as an under-review record in the chronological timeline; use a public-paper overview only.
- [x] P31 woodingSafeFlight
  - Authority: AcadJob/job_app/cv/cv.tex:244-246 and AcadJob/writing-team/statements/RS-20261022-REVISION/survey/own-work-new-entries.bib:78-85
  - Action: retain ICRA under-review status and equal contribution; use the source-recorded 2026 manuscript year for chronological grouping without claiming a conference edition; omit the dead author-PDF link.
- [x] P32 atiq2027robustness
  - Authority: AcadJob/job_app/cv/cv.tex:247-248 and AcadJob/job_app/research_statement/references.bib:304-310
  - Action: add TACAS 2027 under-review status; no public paper URL or publication preview unless implementation finds a new authoritative public source. Use project-page media rather than a fabricated publication preview.

## Media Acquisition and Optimization Ledger

The following targets are approved only after source inspection. A worker may omit any optional preview rather than weaken provenance.

| Target | Source candidate | Required evidence |
|---|---|---|
| assets/img/research-overview.png | AcadJob/job_app/research_statement/figures/research-venn-two-directions.png | source/final SHA-256 and unchanged visual content |
| assets/img/publication_preview/liu2026spectral-framework.png | PMLR paper or verified spectral-energy source repository | PDF page/figure or logical repository path |
| assets/img/publication_preview/zhang2026synthesis-overview.png | DAECBC_Draft/figures/DAECBF_Overview.pdf or author PDF | source path/URL, page/figure, crop |
| assets/img/publication_preview/kazma2026safe-overview.png | semiexplicitdae2026.pdf | URL, page/figure, crop |
| assets/img/publication_preview/wooding2026takeover-overview.png | safetakeover2026.pdf | URL, page/figure, crop |
| assets/img/publication_preview/wooding2026kinductive-overview.png | kinductiveneural2026.pdf | URL, page/figure, crop |
| assets/img/publication_preview/tumlin2026nnv3-overview.png | nnv3_2026.pdf | URL, page/figure, crop |
| assets/img/publication_preview/ijcai2026pace-overview.png | official IJCAI PDF | URL, page/figure, crop |
| assets/img/publication_preview/zhang2026dae-overview.png | arXiv 2603.13509 | URL, page/figure, crop |
| assets/img/publication_preview/woodingSafeFlight-overview.png | safeflight2026.pdf | URL, page/figure, crop |
| static fallback PNGs for retained GIFs | first meaningful frame from each retained GIF | source GIF hash, frame selection, fallback hash |

Existing preview disposition:

- Retain: IEEECDC2020.png, IEEECDC2021.jpg unless replaced, IEEECDC2022.png, VehicleSec23Thumbnail.png, IEEECDC2023.png, seev_training.jpg, IEEECDC2024.gif, FTNCBF_Demo.gif, TAC25FTSCBF.gif, TAC25SNCBF.gif, daecbf_3link.gif, daecbf_manipulator.gif, ft_estimation.png.
- Retain as secondary or replace in primary slot: zhang2023exact.png, zhang2024seev_poster.jpg, cdc24compatible.jpg, icaa2024.png, daecbf_manifold.png, nashvillewater.png.
- Rename with reference update: ICRA2020.gif to a truthful ICRA 2021 name.
- Delete only if unreferenced after final rewrites: FTNCBF_comp.gif and any superseded retained-record preview.

## Validation Strategy

### Baseline and privacy

- Working state:

    git status --short --branch --untracked-files=all
    git diff --name-status
    git diff --stat

- Source fingerprint:

    test -n "$ACADJOB_ROOT"
    git -C "$ACADJOB_ROOT" rev-parse HEAD
    git -C "$ACADJOB_ROOT" status --porcelain=v1 -uall
    shasum -a 256 "$ACADJOB_ROOT/cv/cv.pdf" "$ACADJOB_ROOT/research_statement/body.tex" "$ACADJOB_ROOT/research_statement/references.bib" "$ACADJOB_ROOT/teaching_statement/statement-body.tex"

- Privacy-safe workflow/product files:

    LOCAL_PATH_PREFIX="/""Users/"
    ! rg -n "$LOCAL_PATH_PREFIX" tasks/prd-site-content-refresh.md tasks/tasks-site-content-refresh.md _config.yml _pages _projects _bibliography
    ! rg -n '^[[:space:]]*(<!--|#|%)[[:space:]]*source:' _config.yml _pages _projects _bibliography

### Information architecture and deletions

- Exactly five project sources:

    test "$(find _projects -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')" -eq 5

- Required routes and titles:

    for f in _pages/about.md _pages/publications.md _pages/projects.md _pages/Teaching.md _pages/Outreach.md _pages/cv.md _projects/NeuralBarrierCertificate.md _projects/FaultTolerantControl.md _projects/DAECBF.md _projects/SNNV.md _projects/NashvilleWater.md; do test -f "$f" || exit 1; done
    rg -n 'Safe AI Control|Resilient Control and Verified Autonomy|DAE-Aware Safe Control|AI Verification and Interpretation|Critical-Infrastructure Monitoring' _projects

- Deleted page/fixture reference audit is run before and after deletion:

    ruby tasks/site-refresh-audit.rb --check-deletions

### Bibliography

- Unique keys and normalized titles:

    test -z "$(rg -o '^[[:space:]]*@[A-Za-z]+\{[^,]+' _bibliography/papers.bib | sed -E 's/.*\{//' | tr '[:upper:]' '[:lower:]' | sort | uniq -d)"
    ruby tasks/site-refresh-audit.rb --check-bibliography

- Required count and status groups:

    test "$(rg -c '^[[:space:]]*@[A-Za-z]+\{' _bibliography/papers.bib)" -eq 32
    test "$(rg -c 'status_group[[:space:]]*=[[:space:]]*\{published\}' _bibliography/papers.bib)" -eq 24
    test "$(rg -c 'status_group[[:space:]]*=[[:space:]]*\{preprint\}' _bibliography/papers.bib)" -eq 8

- Required new keys:

    for key in zhang2026dae zhang2027semiimplicit zhang2027error liu2027vocabulary wooding2027inputagnostic he2027formal woodingSafeFlight atiq2027robustness; do test "$(rg -ci "^[[:space:]]*@[A-Za-z]+\{$key," _bibliography/papers.bib)" -eq 1 || exit 1; done

### Assets and animation

- Active asset references, excluding comments:

    ( sed -E 's/[[:space:]]*#.*$//' _config.yml; find _pages _projects -type f \( -name '*.md' -o -name '*.html' \) -print0 | xargs -0 perl -0pe 's/<!--.*?-->//gs'; sed -E '/^[[:space:]]*%/d' _bibliography/*.bib ) | rg -o 'assets/[A-Za-z0-9_./-]+' | sort -u | while IFS= read -r asset; do test -e "$asset" || { echo "missing active asset $asset"; exit 1; }; done

- Media provenance and orphan checks:

    ruby tasks/site-refresh-audit.rb --check-media --check-orphans

- For each optimized GIF, record and compare:

    identify optimized.gif | wc -l
    identify -format '%T\n' optimized.gif | awk '{sum += $1} END {print sum}'
    identify -format '%wx%h\n' optimized.gif | sort -u
    wc -c original.gif optimized.gif

  Require more than one frame, equal playback duration within one centisecond, intended dimensions/crop, smaller or equal bytes, and a static fallback.

### Links and generated site

- External source-link inventory and status:

    ruby tasks/site-refresh-audit.rb --list-external-links > tasks/site-refresh-links.txt
    while IFS= read -r url; do code="$(curl -L -sS -o /dev/null -w '%{http_code}' --max-time 30 "$url")" || exit 1; case "$code" in 2*|3*) ;; *) echo "bad $code $url"; exit 1;; esac; done < tasks/site-refresh-links.txt

- Explicit SNNV policy:

    rg -n -F 'https://hongchaozhang-hz.github.io/SNNV/' _projects/SNNV.md
    ! rg -n -F 'https://github.com/HongchaoZhang-HZ/SNNV' _projects/SNNV.md _pages _bibliography

- Production build:

    JEKYLL_ENV=production bundle exec jekyll build --trace

- Generated local-link, image, heading, and duplicate-ID audit:

    ruby tasks/site-refresh-audit.rb --site _site --check-html

- Generated output stays untracked:

    test -z "$(git ls-files _site .jekyll-cache .jekyll-metadata)"

### PDF documents

- CV identity and page/font checks:

    cmp -s assets/pdf/Hongchao-Zhang-CV.pdf "$ACADJOB_ROOT/cv/cv.pdf"
    test "$(pdfinfo assets/pdf/Hongchao-Zhang-CV.pdf | awk '/^Pages:/ {print $2}')" -eq 3
    ! pdffonts assets/pdf/Hongchao-Zhang-CV.pdf | awk 'NR>2 && $(NF-4) != "yes" {bad=1} END {exit bad}'

- Thesis checks:

    test "$(pdfinfo assets/pdf/Resilient_Safe_Control_of_Autonomous_Systems.pdf | awk '/^Pages:/ {print $2}')" -eq 211
    ! pdffonts assets/pdf/Resilient_Safe_Control_of_Autonomous_Systems.pdf | awk 'NR>2 && $(NF-4) != "yes" {bad=1} END {exit bad}'

### Rendered visual and accessibility review

Serve the production build locally:

    JEKYLL_ENV=production bundle exec jekyll serve --host 127.0.0.1 --port 4010

Review these 12 HTML routes (72 = 12 routes × 3 viewports × 2 themes):

- /
- /publications/
- /projects/
- /projects/neuralbarriercertificate/
- /projects/faulttolerantcontrol/
- /projects/daecbf/
- /projects/snnv/
- /projects/nashvillewater/
- /Teaching/
- /Outreach/
- /cv/
- /404.html

Check this document separately:

- /assets/pdf/Hongchao-Zhang-CV.pdf

For every HTML route, capture or record browser evidence at 1440x900, 1024x768, and 390x844 in light and dark modes. Check first paint, full-page scroll, navigation, heading order, keyboard tab order, visible focus, link names, image alt text, caption legibility, image crops, publication controls, mobile overflow, animation playback, static reduced-motion fallback, and absence of console errors. Record failures by route/viewport/theme and repair before acceptance.

### Final source and scope checks

- Source unchanged:

    git -C "$ACADJOB_ROOT" rev-parse HEAD
    git -C "$ACADJOB_ROOT" status --porcelain=v1 -uall
    git -C "$ACADJOB_ROOT" diff --exit-code

- Final diff:

    git diff --check
    git status --short --branch --untracked-files=all
    git diff --name-status
    git diff --stat

No changed path outside this plan is accepted without an explicit recorded deviation.

## Tasks

- [x] P0 Replace the bounded mechanical PRD/task plan with the approved expanded plan.
  - Dependencies: expanded Stage 1 PASS and latest human authorization
  - Scope: tasks/prd-site-content-refresh.md, tasks/tasks-site-content-refresh.md
  - Owner: main
  - Acceptance: full scope, architecture, file disposition, publication/media ledger, task graph, and gates are recorded; no product file is edited.
  - Validate: inspect both artifacts; scan for machine-local paths; confirm product Git status is unchanged from intake.
  - Evidence: completed in Stage 2; expanded implementation remains pending.

- [x] T1 Freeze the expanded execution baseline and supersede the bounded verification status.
  - Dependencies: P0
  - Scope: current diff, task artifact, active source files, tasks/verification-site-content-refresh.md
  - Owner: main
  - Acceptance: all target/source hashes and Git states are refreshed; the protected mechanical diff is identified; the former verification is labeled superseded without deleting its evidence; no overlap is lost.
  - Validate: run Baseline and privacy commands; compare the live diff to Protected Baseline.
  - Evidence: website HEAD `facf7b01cc201d69b0b5707ac70b124f2a368b8c`; protected binary diff SHA-256 `e4334efd92c958615e567907d41f9039bbd85b40c6a6f9507ee3e09789449007`. `AcadJob/job_app` clean at HEAD `71064afc0e3d3e835455d62f46c9666de540e35d`. Source hashes: CV source `ea191250...cca3`, CV PDF `c0f564fd...1f53`, RS body `70f7b18b...2eae`, RS bibliography `a83fe34d...e747`, RS PDF `0dcf0bcf...ea1`, TS body `20b23c1e...6e4`, TS PDF `2709e12d...fa8c`. The earlier verification report is labeled historical and superseded without deleting its evidence.

- [x] T2 Remove obsolete configuration, dependency, route, and theme-fixture infrastructure.
  - Dependencies: T1
  - Scope: _config.yml, Gemfile, Gemfile.lock, dropdown/repository/blog/news routes, four _news items, four _data files, confirmed demo fixtures, conditional dead includes/layouts
  - Owner: worker
  - Acceptance: every deletion has a zero-reference receipt; stale public routes and demo data are absent; jekyll-get-json is absent; required generic theme code remains; tasks stays excluded.
  - Validate: ruby tasks/site-refresh-audit.rb --check-deletions; rg dependency/config tokens; bundle check.
  - Evidence: `ruby tasks/site-refresh-audit.rb --check-deletions` passes with 75 deletion receipts and 81 zero-reference checks; removed dependencies/config tokens are absent; `bundle check` passes. Obsolete routes, four news records, four data files, dead layouts/includes, demo fixtures, and unused plugin code are absent.

- [x] T3 Rewrite About and the Projects index and add the shared RS overview.
  - Dependencies: T1
  - Scope: _pages/about.md, _pages/projects.md, assets/img/research-overview.png
  - Owner: worker
  - Acceptance: About and Projects match the PRD architecture and active CV/RS; portrait/thesis remain; address/template text is gone; three established research areas and two future directions are present; source image provenance is recorded.
  - Validate: focused text checks, active-asset gate, word-diff review against the source map, visual review of / and /projects/.
  - Evidence: About and Projects render the three established areas and two future directions with the retained profile/thesis links. `assets/img/research-overview.png` is recorded in the media ledger with SHA-256 `24d8ec6c9e1e024ce47344431218c27443f0cc39b8e0292844ab9e5cb688464f`.

- [x] T4 Reconcile all 32 publication records and preserve status metadata.
  - Dependencies: T2
  - Scope: _bibliography/papers.bib, _pages/publications.md, _layouts/bib.html, _config.yml publication filtering
  - Owner: worker
  - Acceptance: P01--P32 each pass; all 32 records render in one year-grouped timeline; 24 retain published/accepted status metadata and eight retain preprint/under-review metadata plus the inline title label; all keys/titles are unique; metadata/status/link fields match the ledger; missing optional data is omitted.
  - Validate: all Bibliography commands; production build; inspect the generated year-grouped timeline and inline labels.
  - Evidence: bibliography audit passes with 32 unique records: 24 published/accepted and eight preprint/under-review. The final timeline renders year dividers from 2027 through 2020 and exactly eight inline labels. The bibliography layout resets optional month/year values per entry, preventing cross-record date leakage; Safe Flight uses the source-recorded 2026 manuscript year without claiming a conference edition.

- [x] T5 Acquire or extract only auditable publication and overview media.
  - Dependencies: T4
  - Scope: approved targets in Media Acquisition and Optimization Ledger
  - Owner: worker
  - Acceptance: each added preview has source path/URL, page/figure/crop, SHA-256, descriptive alt/caption, and legible crop; records with weak evidence have no preview.
  - Validate: media provenance/orphan audit; inspect original PDF page beside target crop; active-asset gate; visual review in both themes.
  - Evidence: media provenance audit passes for 28 active records. The RS overview, publication/project images, and seven animation fallbacks have target hashes, logical sources, and alt text; optional publication previews without sufficient provenance were omitted.

- [x] T6 Rewrite the five project pages and retire the six MI pages.
  - Dependencies: T3, T4, T5
  - Scope: all 11 current _projects/*.md files and the ten MI assets
  - Owner: worker
  - Acceptance: exactly five project files remain with the required titles/structures; RS-scoped claims and project links are accurate; unsupported MI details are absent; SNNV site remains and broken GitHub link is gone; MI assets are deleted only after zero-reference checks.
  - Validate: project count/title checks, SNNV checks, deletion audit, active-asset gate, per-route visual review.
  - Evidence: exactly five project sources and routes remain with required titles. Six MI pages and ten MI assets were removed after reference checks. The SNNV interactive site returns HTTP 200; the dead SNNV GitHub link is absent.

- [x] T7 Rewrite Teaching and Outreach from the active TS and CV.
  - Dependencies: T1
  - Scope: _pages/Teaching.md, _pages/Outreach.md
  - Owner: worker
  - Acceptance: Teaching follows understanding/implementation/validation, six roles, mentoring, interests, and proposed elective with TS caveats; Outreach covers service, talks, research support, awards, and fellowships without unsupported generic outreach.
  - Validate: source-to-page checklist, proper-noun/status checks, no stale template sections, route visual review.
  - Evidence: Teaching contains the understanding/implementation/validation framework, six teaching roles, mentoring, course interests, and proposed-elective caveat. Outreach contains service, invited talks, research support with status caveats, award, and fellowship entries from the active CV.

- [x] T8 Revalidate the CV, thesis, profile identity, and retained personal assets.
  - Dependencies: T1
  - Scope: _pages/cv.md, assets/pdf/Hongchao-Zhang-CV.pdf, thesis PDF, profile/social configuration, retained portraits/icons
  - Owner: worker
  - Acceptance: CV is byte-identical to current source; CV/thesis page counts and embedded fonts pass; direct routes work; no unsupported address/profile field is introduced; required portraits/icons remain.
  - Validate: PDF commands, profile link audit, active-asset gate, browser PDF route checks.
  - Evidence: website CV is byte-identical to the active AcadJob CV, is three pages, and passes embedded-font checks. The retained thesis is 211 pages and passes embedded-font checks. Direct PDF routes respond; retained portrait/profile assets pass the active-asset audit.

- [x] T9 Optimize retained animations and remove remaining unreferenced media.
  - Dependencies: T5, T6, T8
  - Scope: retained GIFs, static fallbacks, superseded previews, FTNCBF_comp.gif if unreferenced
  - Owner: worker
  - Acceptance: required animations remain meaningful and animated; large files are losslessly reduced or replaced by equivalent accessible animation; frame/duration/dimension/size evidence is recorded; every deleted media file is unreferenced; reduced-motion fallback works.
  - Validate: animation commands, media/orphan audit, light/dark/reduced-motion visual review.
  - Evidence: all seven retained GIFs remain animated and have static reduced-motion fallbacks. `daecbf_manipulator.gif` was losslessly reduced from 3,691,670 to 641,228 bytes with equal frame count, duration, dimensions, and coalesced-frame signatures. Other candidates were retained when tested outputs changed frames. Orphan audit passes; unreferenced `FTNCBF_comp.gif` is removed.

- [x] T10 Run focused content, metadata, link, asset, privacy, PDF, and scope validation.
  - Dependencies: T2--T9
  - Scope: all changed website sources and tasks/site-refresh-audit.rb
  - Owner: main
  - Acceptance: every non-visual command in Validation Strategy passes; external 4xx/5xx links are repaired or removed; no generated output or private path is tracked; AcadJob remains unchanged.
  - Validate: complete Baseline, IA, Bibliography, Assets, Links, PDF, Source, and Final scope command groups.
  - Evidence: deletion, bibliography, media, orphan, active-asset, privacy, PDF, diff, and generated-output gates pass. All 52 content/config external links return 2xx/3xx. `AcadJob/job_app` remains clean at `71064afc0e3d3e835455d62f46c9666de540e35d`, with recorded CV/RS/TS hashes unchanged.

- [x] T11 Run production build and rendered desktop/tablet/mobile accessibility review.
  - Dependencies: T10
  - Scope: production _site output and all required routes
  - Owner: main
  - Acceptance: production build exits 0; all route/viewport/theme checks pass; no blocking console, layout, focus, keyboard, alt-text, contrast, motion, or overflow defect remains; generated evidence stays outside tracked output.
  - Validate: build/serve commands and the exact route/viewport/theme matrix in Validation Strategy.
  - Evidence: `JEKYLL_ENV=production bundle exec jekyll build --trace` exits 0 and generated HTML audit passes for 12 HTML routes: Home, Publications, Projects, five project pages, Teaching, Outreach, CV, and 404. The CV PDF was checked separately. Browser review passes all 72 HTML route/theme/viewport combinations at 1440x900, 1024x768, and 390x844 with no overflow, missing alt text, broken images, empty interactive names, heading skips, or console errors. Keyboard order, visible focus, mobile navigation, bottom clearance, publication controls, animation playback, and reduced-motion fallback structure were checked. After independent review found an incorrect generated CV redirect target, the repaired `/cv/` route was re-tested in a live browser: its named download link targets `/assets/pdf/Hongchao-Zhang-CV.pdf`, the timed redirect reaches the same PDF, and `/404.html` retains its root redirect.

- [x] T12 Obtain independent read-only verification of the expanded refresh.
  - Dependencies: T11
  - Scope: current task artifact, approved PRD/plan, actual diff, source fingerprints, command evidence, rendered evidence
  - Owner: main; execution by independent verifier
  - Acceptance: verifier maps FR-1--FR-36 and AC-1--AC-17 to concrete evidence, inspects the actual diff and rendered output, makes no edits, and returns PASS, FAIL, or BLOCKED.
  - Validate: verifier report explicitly identifies DZSITE-20261026-001, the five-page architecture, 24 published/accepted plus eight under-review status records, media provenance, deletions, build, visual/accessibility evidence, and AcadJob no-change evidence.
  - Evidence: verifier session `01a17b75-1ba1-72c2-a1c1-34fb5b175275` returned final PASS after replaying all prior repairs and the CV-route repair. It mapped FR-1--FR-36 and AC-1--AC-17 to the current diff and evidence, confirmed 24+8 publications, five projects, 28 media records, 75 deletion receipts, 81 zero-reference checks, 12 generated HTML routes, live `/cv/` and 404 behavior, and the clean AcadJob revision.

- [x] T13 Integrate the final expanded verification result without publishing.
  - Dependencies: T12 PASS
  - Scope: tasks/tasks-site-content-refresh.md and tasks/verification-site-content-refresh.md
  - Owner: main
  - Acceptance: completed task gates have exact evidence; the final report distinguishes local readiness from publication; no commit/push/deploy occurs.
  - Validate: final diff/status and task-artifact reconciliation.
  - Evidence: `tasks/verification-site-content-refresh.md` records the final expanded PASS and local-only publication boundary. This plan and the stable task artifact are reconciled; final status/diff checks pass; no commit, push, deployment, or publication occurred.

## File Ownership and Execution Order

- Main owns PRD/plan status, baseline reconciliation, validation integration, visual review coordination, and final claims.
- Product workers receive exclusive ownership of one task's listed files at a time. T2 precedes T4 because both can touch _config.yml. T4 precedes T5 and T6. T5 and T7 may run independently only if their file sets remain disjoint.
- No worker may edit this approved plan, broaden scope, mutate AcadJob/research repositories, commit, push, deploy, or publish.
- The verifier is read-only and independent of implementation.

## Timebox Order

Within the eight-hour execution window, protect these gates in order:

1. Source/baseline integrity and final architecture.
2. About, five project pages, Teaching, and Outreach.
3. Publication metadata/status/link integrity for all 32 records.
4. Verified media reuse and the highest-value overview figures.
5. Fixture/dependency removal and animation optimization.
6. Production build, link/media/PDF checks, rendered review, and independent verification.

Optional previews are omitted before any content, metadata, privacy, build, accessibility, or verification gate is weakened.

## Deviations and Decisions

- The latest human request supersedes the prior mechanical-only scope and all T9/T10 prose approval gates.
- The protected mechanical baseline passed its bounded verification, but that report is not evidence of expanded completion.
- Existing project filenames are retained to avoid unnecessary route churn; titles and content change.
- The six MI pages are deleted because the active CV/RS supports only high-level ongoing AI reasoning work, not their detailed results.
- Publications use the filtered `status_group` field only for inline review labels; Jekyll Scholar renders one list grouped by year.
- The SNNV interactive site is retained; the broken SNNV GitHub link is removed.
- Optional publication previews are evidence-gated and may be absent.
- No public file carries audit provenance.
- `site.webmanifest` was added during implementation because the existing page head already references `/site.webmanifest`; recording the file closes that route without expanding the public information architecture.

## 2026-10-27 Continuation

- [x] T14 Restore the publication chronology and inline review status.
  - Scope: `_pages/publications.md`, `_layouts/bib.html`, `tasks/site-refresh-audit.rb`
  - Acceptance: one list contains all 32 records; visible year dividers run in descending order; exactly eight titles carry `(Under review)`; the former two status-section headings are absent.
  - Validate: production build; bibliography/accessibility/generated-HTML audits; rendered publication inspection.
  - Evidence: production build passes; generated output contains year dividers `2027` through `2020` in descending order, all 32 records in one list, and exactly eight `(Under review)` title labels. The two former status-section headings are absent. Browser accessibility inspection confirms the visible year headings and inline labels.

- [x] T15 Restore the public page and navigation name `Outreach`.
  - Scope: `_pages/Outreach.md`
  - Acceptance: `/Outreach/` retains its content and renders `Outreach` as page and navigation title; `Service and Recognition` is absent from generated navigation.
  - Validate: production build and generated HTML inspection.
  - Evidence: `/Outreach/` renders page title and H1 as `Outreach`; generated home navigation uses `Outreach`; `Service and Recognition` is absent from generated navigation. Browser inspection reports no console errors.

- [x] T16 Re-verify the corrected complete site.
  - Dependencies: T14--T15
  - Scope: current diff, all repository audits, production output, publication and Outreach browser behavior, AcadJob no-change evidence
  - Acceptance: focused and full audits pass; independent read-only verification returns PASS.
  - Validate: audit script, build, browser review, independent verifier report.
  - Evidence: all deterministic audits and the production build pass; browser inspection confirms the year timeline, eight inline labels, and Outreach name. Independent verifier session `01a17b75-1ba1-72c2-a1c1-34fb5b175275` returned PASS after coordination replay, with zero blocking Standards or Spec findings. AcadJob remains clean at `71064afc0e3d3e835455d62f46c9666de540e35d`.

- [ ] T17 Commit and push the validated complete refresh.
  - Dependencies: T16 PASS
  - Scope: all authorized website changes for DZSITE-20261026-001
  - Acceptance: one commit exists on `master`; push to `origin/master` succeeds; local and remote branch revisions match.
  - Validate: `git status`, `git rev-parse HEAD`, and `git rev-parse origin/master` after push.

## Blockers

None at continuation start.
