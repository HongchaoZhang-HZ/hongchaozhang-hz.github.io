# PRD: Full Academic Site Refresh

## Status

Approved

Approval basis: the full-site rewrite was authorized without per-section approval pauses. On 2026-10-27, the user explicitly corrected the publication presentation and Outreach title and authorized commit and push. The correction supersedes the former two-section publication layout and the earlier no-commit/no-push boundary. `AcadJob/` remains read-only.

## Problem

The public site mixes current academic facts with stale prose, unsupported project claims, incomplete publication metadata, broken or missing links, uneven media, and al-folio fixtures. The first mechanical refresh corrected a protected set of facts, but it did not reconcile the full site with the active Curriculum Vitae (CV), Research Statement (RS), and Teaching Statement (TS). Six mechanistic-interpretability project pages present detailed unpublished results that the active sources do not establish. Publications are not separated by status, several accepted records lack links and previews, and unused news, repository, CV, demo, and media fixtures remain publicly buildable.

## Goal

Produce a locally verified academic site whose information architecture, authored prose, publications, five research project pages, teaching, service, links, downloadable documents, and media are aligned with current auditable sources. Remove unsupported or unused public material, preserve the protected mechanical baseline and unrelated user work, and leave the site ready for a later human publication decision.

## Users and Use Cases

- Research and hiring readers: understand the research program, current projects, publications, teaching, service, and funding record.
- Collaborators and students: find verified papers, code repositories, project sites, teaching areas, and mentoring information.
- Site maintainer: audit every public fact, link, publication record, and derived figure without exposing machine-local provenance.
- Independent verifier: reproduce content, metadata, media, link, build, rendering, accessibility, and source-repository checks from the task plan.

## Source Authority

1. `AcadJob/job_app/cv/cv.tex` and `cv/cv.pdf` control identity, position, education, publication status, teaching roles, mentoring, invited talks, service, funding, and awards.
2. `AcadJob/job_app/research_statement/body.tex`, `references.bib`, and `figures/` control research framing, project structure, scoped technical claims, future directions, and RS-owned figures.
3. `AcadJob/job_app/teaching_statement/statement-body.tex` controls teaching philosophy, instructional examples, mentoring framing, course interests, and the proposed elective.
4. Primary publisher, venue, DOI, arXiv, OpenReview, author-maintained publication, paper PDF, and source-repository records control publication metadata, links, code, and media.
5. The expanded Stage 1 report in thread `01a17b61-acc3-7211-a791-4b45a66aad66` supplies the verified replacement, publication, link, page, and asset inventory.

If sources conflict, the implementation must stop on the affected fact and preserve the rest of the approved work. It must not resolve a conflict by invention.

## Final Information Architecture

| Route | Source file | Disposition |
|---|---|---|
| `/` | `_pages/about.md` | Full rewrite: current position, collaborators, research identity, three established areas, education, experience, and two future directions. Retain portrait and thesis link; remove street address and template comments. |
| `/publications/` | `_pages/publications.md` | One reverse-chronological timeline with the original year dividers. Mark under-review records inline after the title. |
| `/projects/` | `_pages/projects.md` | Rewrite as the RS-aligned research overview and show exactly five project cards. |
| `/projects/neuralbarriercertificate/` | `_projects/NeuralBarrierCertificate.md` | Retitle and rewrite as `Safe AI Control`. |
| `/projects/faulttolerantcontrol/` | `_projects/FaultTolerantControl.md` | Retitle and rewrite as `Resilient Control and Verified Autonomy`. |
| `/projects/daecbf/` | `_projects/DAECBF.md` | Retitle and rewrite as `DAE-Aware Safe Control`. |
| `/projects/snnv/` | `_projects/SNNV.md` | Retitle and rewrite as `AI Verification and Interpretation`; retain the verified SNNV interactive site and remove the broken GitHub link. |
| `/projects/nashvillewater/` | `_projects/NashvilleWater.md` | Retitle and rewrite as `Critical-Infrastructure Monitoring`. |
| `/Teaching/` | `_pages/Teaching.md` | Full TS- and CV-aligned rewrite. |
| `/Outreach/` | `_pages/Outreach.md` | Retain the route and public title `Outreach`; content covers academic service, invited talks, funding, and recognition. |
| `/assets/pdf/Hongchao-Zhang-CV.pdf` | `_pages/cv.md`, `assets/pdf/Hongchao-Zhang-CV.pdf` | Retain direct PDF route and active three-page CV. Remove template comments from the route source. |
| `/404.html` | `404.html` | Retain and verify the home link and redirect behavior. |
| `/blog/` | `blog/index.html` | Delete because no current posts or approved blog content exist. |
| `/news/` | `news.html`, `_news/*.md` | Delete the disabled, incomplete 2024 snapshot and its public route. |
| `/repositories/` | `_pages/repositories.md` | Delete; verified code links belong on publications and project pages. |
| unused submenu page | `_pages/dropdown.md` | Delete the theme fixture. |

## Project Disposition

| Current file | Final page | Required content |
|---|---|---|
| `_projects/NeuralBarrierCertificate.md` | Safe AI Control | Exact ReLU neural control barrier function verification, SEEV synthesis, stochastic extensions, scoped guarantees, publications, verified code, and source-backed media. |
| `_projects/FaultTolerantControl.md` | Resilient Control and Verified Autonomy | Fault/attack models, estimator-bank diagnosis, control-barrier-function intervention, cooperative perception, Vanderbilt testbed, publications, code, and retained animations. Do not claim a deployed demonstration. |
| `_projects/DAECBF.md` | DAE-Aware Safe Control | Differential-algebraic-system verification, synthesis, semi-explicit systems, descriptor-system takeover, infrastructure relevance, DAE code, and verified media. Remove unsupported high-index and implementation claims. |
| `_projects/SNNV.md` | AI Verification and Interpretation | NNV3, spiking-network verification, neuro-symbolic reasoning, and high-level ongoing reasoning analysis. Do not preserve unsupported MI metrics. Keep `https://hongchaozhang-hz.github.io/SNNV/`; remove `https://github.com/HongchaoZhang-HZ/SNNV`. |
| `_projects/NashvilleWater.md` | Critical-Infrastructure Monitoring | Operational constraints, spectral anomaly detection, Nashville Metro Water collaboration, actual-leak identification, legacy/limited-data constraints, and the VSEC direction. Remove the speculative six-objective deployment and dashboard narrative. |
| `_projects/MI_Arithmetic.md` | Delete | Unsupported detailed unpublished results; no standalone replacement. |
| `_projects/MI_ConceptProbing.md` | Delete | Merge only source-supported high-level direction into AI Verification and Interpretation. |
| `_projects/MI_Grokking.md` | Delete | Unsupported detailed unpublished results; no standalone replacement. |
| `_projects/MI_LLMInternals.md` | Delete | Merge only source-supported high-level direction into AI Verification and Interpretation. |
| `_projects/MI_RepEReading.md` | Delete | Merge only source-supported high-level direction into AI Verification and Interpretation. |
| `_projects/MI_VanillaSteering.md` | Delete | Merge only source-supported high-level direction into AI Verification and Interpretation. |

## Functional Requirements

1. FR-1: Work must remain within task `DZSITE-20261026-001`, modify only `website/`, and treat `AcadJob/job_app/` as read-only.
2. FR-2: The current verified mechanical diff must be preserved as a protected baseline. It is not final completion evidence for this expanded scope.
3. FR-3: The existing verification report must be treated as historical evidence for the bounded pass and marked superseded by the main coordinator before expanded final verification.
4. FR-4: `_pages/about.md` must be fully rewritten from the active CV and RS with current position, collaborators, research identity, three research areas, education, experience, and the future directions `Trustworthy AI Autonomy` and `Critical Infrastructure`.
5. FR-5: About must retain `my_pic_seaside_front_small.jpg` and the thesis PDF, remove the street address and template comments, and contain no unsupported contact or profile field.
6. FR-6: `_pages/projects.md` must introduce the RS-aligned program and render exactly the five retained project pages in the order shown above.
7. FR-7: The five retained project files must be rewritten to the structures in the Project Disposition table, using only claims supported by the active RS, CV, primary papers, or verified project repositories.
8. FR-8: The six `MI_*.md` pages must be deleted after internal-reference and asset-reference checks. Their detailed numerical and experimental claims must not be migrated.
9. FR-9: `_pages/publications.md` and the bibliography renderer must show one reverse-chronological timeline with visible year dividers. Under-review work must carry `Under review` immediately after the title; accepted work must not carry that label.
10. FR-10: All 24 current bibliography records must be individually reconciled against the authoritative mapping in the task plan, including entry type, title, author order, venue, year, pages, DOI/URL, acceptance status, equal-contribution note, and available paper/code/project links.
11. FR-11: Eight public preprint or under-review records must remain in the year-grouped timeline and carry the inline status label: `zhang2026dae`, `zhang2027semiimplicit`, `zhang2027error`, `liu2027vocabulary`, `wooding2027inputagnostic`, `he2027formal`, `woodingSafeFlight`, and `atiq2027robustness`.
12. FR-12: Every public bibliography record must have one authoritative source mapping in the excluded task plan. Public product files must contain no task provenance comments.
13. FR-13: Every publication must expose all verified applicable DOI, paper, code, poster, project, and interactive links. Missing links must be omitted rather than inferred.
14. FR-14: A publication preview must be used only when an auditable overview or representative figure is available from an existing verified asset, a source repository, or a public/author paper PDF. Weak or ambiguous candidates must remain without a preview.
15. FR-15: Each new or derived media file must have a task-plan provenance record containing the logical source repository path or public PDF URL plus page and figure identifier. No fabricated or generative visual is allowed.
16. FR-16: Existing verified publication animations and project media must be preserved where relevant. Large retained GIFs must be losslessly optimized or replaced by an equivalent animated format with a static fallback; animation, legibility, and meaning must remain intact.
17. FR-17: Motion must not be required to understand content. Animated media must have descriptive text and a usable static fallback for reduced-motion users.
18. FR-18: The SNNV interactive site must remain linked and pass link validation. Its confirmed broken GitHub link must be removed from front matter and body content.
19. FR-19: `_pages/Teaching.md` must be fully rewritten from the TS and CV around understanding, implementation, validation, six instructional roles, mentoring, teaching interests, and the proposed `Trustworthy AI-Enabled Cyber-Physical Systems` elective.
20. FR-20: Teaching claims must retain the scope and caveats in the TS. Survey percentages must preserve their stated unit and denominator context if used; prospective course content must be presented as proposed, not delivered.
21. FR-21: `_pages/Outreach.md` must be rewritten to include service leadership, conference and journal reviewing, three invited talks, the VSEC award with `$200,000 total`, the NSF contribution framed as research support, the General Motors award, and the Lee Fellowship. It must not invent generic outreach activity.
22. FR-22: The public CV must remain byte-identical to the active CV at implementation completion and retain three pages with embedded fonts. The 211-page thesis PDF must remain linked and renderable.
23. FR-23: `_pages/dropdown.md`, `_pages/repositories.md`, `blog/index.html`, `news.html`, and `_news/*.md` must be deleted after reference checks.
24. FR-24: `_data/cv.yml`, `_data/repositories.yml`, `_data/coauthors.yml`, and `_data/venues.yml` must be deleted after confirming their records are theme/demo data or unused by the final site. The bibliography renderer must continue to render authors and venue badges safely when those optional data files are absent.
25. FR-25: The obsolete `jekyll-get-json` dependency must be removed from `Gemfile` and `Gemfile.lock`; no `jekyll_get_json`, `jsonresume`, or deleted JSON dependency may remain active.
26. FR-26: Unused CV/resume, repository, news, and latest-post includes or layouts may be deleted only after a repository-wide reference check proves the final routes do not use them.
27. FR-27: Confirmed theme fixtures must be deleted: the example PDF, sample audio/video, demo Plotly/JSON, al-folio screenshot assets, and `brownian-motion.gif`/`wave-mechanics.gif`. Personal portraits/photos, favicon assets, the thesis, active CV, and mapped research media must remain.
28. FR-28: The final configuration must remove stale blog/news/repository/demo settings, retain dark mode and responsive-image support, and keep `tasks` excluded from generated output.
29. FR-29: All authored prose must be scientific, concise, and result-focused. It must avoid marketing language, unsupported superlatives, stale institution names, and claims broader than their stated assumptions.
30. FR-30: Every local image, document, project, and navigation reference must resolve after deletions. Every external DOI, paper, code, project-site, and collaborator link must be checked; HTTP 2xx/3xx and the known IEEE DOI 202 response are acceptable.
31. FR-31: The production site must build with `JEKYLL_ENV=production bundle exec jekyll build --trace` without a new error and without tracking generated output.
32. FR-32: The home page, publications, projects index, five project pages, Teaching, Outreach, CV route, thesis link, and 404 route must receive rendered review at desktop, tablet, and mobile widths in light and dark modes.
33. FR-33: Rendered review must cover heading hierarchy, contrast, keyboard navigation, visible focus, alt text, image cropping, caption legibility, mobile overflow, publication controls, GIF playback, reduced-motion fallbacks, and broken local links.
34. FR-34: Final validation must confirm unique bibliography keys and titles, correct chronological year grouping and inline status labels, required metadata, source-mapped media, no orphaned deleted assets, no machine-local paths, no public task comments, and unchanged `AcadJob/job_app/` HEAD and status.
35. FR-35: An independent read-only verifier must map every requirement and task gate to the actual expanded diff and return `PASS`, `FAIL`, or `BLOCKED` before the expanded refresh can be called complete.
36. FR-36: Commit and push to the existing `master` branch are authorized after all validation passes. No other external message or application-state change is authorized. A push may trigger the repository's existing GitHub Pages publication workflow.

## Acceptance Criteria

- AC-1: The final navigation and public routes match the Final Information Architecture table; no deleted stale route is linked internally.
- AC-2: About, Projects, all five retained projects, Teaching, and Outreach are reconciled with the active CV, RS, and TS, and contain no contradicted or unsupported claims identified by Stage 1.
- AC-3: Exactly five project source pages remain. The six MI pages and their ten unreferenced MI assets are absent, and no internal link points to them.
- AC-4: Publications show all 32 records in one reverse-chronological timeline with year dividers; the eight preprint/under-review records carry an inline `Under review` label. Keys and normalized titles are unique.
- AC-5: Every bibliography entry matches its task-plan authority mapping and exposes only verified links and status language.
- AC-6: Every preview or project image has a recorded logical source; optional previews with weak evidence are absent.
- AC-7: The SNNV interactive site works, its broken GitHub link is absent, and all other code/project links pass the link policy.
- AC-8: Teaching reflects the TS/CV instructional framework and roles; Outreach reflects CV service, talks, research support, awards, and fellowships without adding unsupported outreach claims.
- AC-9: The active CV is byte-identical to the source CV, the CV and thesis open, their page counts remain 3 and 211, and their fonts are embedded.
- AC-10: Required animations remain animated and understandable; optimized replacements are smaller or equal in size, retain frame/duration evidence, and have reduced-motion fallbacks.
- AC-11: Deleted theme fixtures, data, pages, dependency entries, and optional dead includes/layouts have zero live references before deletion and are absent afterward.
- AC-12: `JEKYLL_ENV=production bundle exec jekyll build --trace` exits 0; generated output is untracked; no new build warning indicates a broken route, missing asset, duplicate destination, or invalid bibliography record.
- AC-13: All required routes pass desktop/tablet/mobile and dark/light review, with recorded screenshots or equivalent browser evidence and no blocking accessibility defect.
- AC-14: Repository validation finds no machine-local path, public provenance comment, stale institute name, Albert Einstein fixture, broken local asset, duplicate bibliography identity, or unrelated diff.
- AC-15: `AcadJob/job_app/` has identical pre/post HEAD and porcelain status and a clean diff when it began clean.
- AC-16: The prior bounded verification is explicitly historical; only the new independent verdict can accept the expanded refresh.
- AC-17: One validated commit is pushed to the existing `master` branch. No separate manual deployment action occurs.

## Required Preservation

- The current mechanical content and CV corrections unless a newer authoritative source directly supersedes them.
- `assets/img/my_pic_seaside_front_small.jpg` and other personal portraits/photos.
- `assets/pdf/Resilient_Safe_Control_of_Autonomous_Systems.pdf`.
- `assets/pdf/Hongchao-Zhang-CV.pdf`, synchronized only from the active CV.
- Relevant publication previews and the retained animations `FTNCBF_Demo.gif`, `TAC25FTSCBF.gif`, `TAC25SNCBF.gif`, `daecbf_3link.gif`, and `daecbf_manipulator.gif`, subject to verified optimization/renaming.
- Favicon and platform icon assets.
- Unrelated user changes.

## Non-Goals

- Redesign the Jekyll theme or replace the site framework.
- Fabricate publication metadata, project results, links, images, diagrams, or quantitative claims.
- Preserve unsupported MI experiment details merely because they are already public locally.
- Require a preview image for every publication.
- Add private review material, application state, credentials, private paths, or provenance comments to public files.
- Modify active application materials or any research source repository.
- Contact another person or service, or perform a separate manual deployment beyond the authorized Git push.

## Constraints

- Target root: logical `website/`, branch `master` at intake.
- Source root: logical `AcadJob/job_app/`, read-only.
- The eight-hour timebox prioritizes correctness, the five-page research structure, publication status/link integrity, source-backed media, fixture removal, and verification. Optional media is omitted when its evidence or processing would threaten those gates.
- Deletion requires a live reference check immediately before the deletion.
- Every target and source must be re-read immediately before editing.
- Generated build and visual-review artifacts must stay ignored or outside the repository.
- Privacy-safe provenance belongs only in excluded workflow artifacts and may use logical repository paths or public URLs, never machine-local absolute paths.

## Design and Technical Notes

- Reuse the five existing project filenames to preserve their current routes while changing titles and content.
- Retain the non-rendered BibTeX field `status_group` with values `published` and `preprint`, filter it from displayed BibTeX, and use it only to add the inline `Under review` label while Jekyll Scholar groups the single list by year.
- Use the RS research-map PNG as the shared About/Projects overview after copying it from the read-only source into a clearly named website asset and recording its logical origin.
- Prefer existing verified animated demonstrations on project pages. Publication thumbnails should favor method/architecture figures over posters or dense page screenshots.
- For reduced motion, provide static first-frame or representative fallbacks and descriptive captions; do not make a result understandable only through animation.
- Delete dead rendering infrastructure only after final-page references are known. Generic theme components that remain transitively required must be retained.

## Assumptions

- The active CV, RS, and TS remain the intended public authority at implementation time; their source commit and hashes must be refreshed before edits.
- The expanded Stage 1 primary-link checks remain current enough to seed implementation, but every external link must be replayed before acceptance.
- The existing project slugs may remain stable while page titles and content change.

## Open Questions

None. Missing optional media or links are omitted when authoritative evidence is unavailable; they do not trigger another human approval gate.
