# Implementation plan and status

Last updated: 2026-07-16

This file is the authoritative project status. Detailed protocols, raw evidence,
and report material remain in their linked files. Status changes must be made
here when a phase starts or finishes so progress is not represented only in
conversation history.

## Phase status

| Phase | Status | Evidence or next action |
| --- | --- | --- |
| 1. Requirements and proposal analysis | Complete | Course requirements, proposal scope, and exploratory-testing requirement incorporated into the protocol |
| 2. Baseline capture and contamination controls | Complete | baseline.md and immutable baseline commit recorded |
| 3. Test and measurement infrastructure | Complete | Isolated settings, deterministic seed, OpenAPI schema, coverage, pytest, and Schemathesis runners |
| 4. Preliminary defect registration | Complete | known-defects.md and defect-log.csv; K-008 retained as a rejected classification |
| 5. Human-authored deterministic testing | Complete | Formal M-01: 20 cases, 9 pass, 10 expected failures, 1 unexpected pass |
| 6. Schema-driven API fuzzing | Complete | F-01 through F-03: 3,252 generated cases across three seeds |
| 7. Exploratory-testing preparation | Complete | Reproducible environment, operator guide, charters, session records, and passed READINESS rehearsal |
| 8. Human exploratory sessions | Complete | E-01 and E-02 completed and debriefed; combined time 180 minutes 13 seconds |
| 9. Cross-technique triage and comparison | Complete | E-02 reproduced K-006, K-009, and N-002 but added no novel root cause |
| 10. Academic literature review | Complete | Five-source synthesis, verified metadata, IEEE references, and presentation source summaries are complete |
| 11. Final report assembly | Review candidate complete | Word export verified at 20 pages, 4,247 words, and maximum 12-point font; E-02 screenshots are indexed, while selected insertion, peer review, and final layout inspection remain |
| 12. Optional defect correction and regression | Ready but optional | Baseline is frozen; any fixes must use separate commits and regression evidence |
| 13. Presentation and literature summary | Review candidate complete | Eight-slide deck, notes, visible results/challenges, IEEE bibliography, five source discussions, and standalone literature-summary DOCX exist; peer review and timed rehearsal remain |

## Completed formal baseline

- Baseline application commit:
  acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4.
- Product defect fixes applied before baseline completion: none.
- Formal manual run: M-01.
- Formal fuzz runs: F-01, F-02, and F-03.
- Confirmed known defects reproduced by the manual suite: K-001 through K-007
  and K-009.
- Confirmed known defects reproduced by formal fuzzing: K-002, K-004, and
  K-009.
- Novel confirmed defects from formal manual or fuzz execution: zero.
- Rejected candidate: K-008, because its smoke evidence duplicated K-002 and
  the human malformed-item-ID case correctly returned 400.

## Current gate

Initial review package commit: 0f3ca52e9357e9b9e4042044c195e1de23225ac5 on origin/main.

Both exploratory sessions and all formal baseline executions are complete.
Application behavior remains unfixed so the evidence describes one consistent
baseline. The current gate is peer review and submission quality control:
review the report and slide deck, insert selected screenshots, inspect the final
Word layout, rehearse the presentation, and preserve the final submission
package.

## Remaining deliverables

1. Obtain collaborator review of the report, citations, and presentation.
2. Insert selected indexed screenshots at the marked Word placeholders and
   perform final visual review; retain the unavailable-effort disclosure.
3. Rehearse the presentation and submit the literature summary in the requested
   format.
4. Preserve the review commit and later submission package; keep any optional
   post-baseline fixes separate from the baseline comparison.

## Change-control rule

The comparison baseline is complete and immutable. Any endpoint validation,
authorization, persistence, or transaction fix must now be isolated in a
post-baseline commit and must not replace the recorded results.
