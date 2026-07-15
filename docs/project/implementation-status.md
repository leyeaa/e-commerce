# Implementation plan and status

Last updated: 2026-07-15

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
| 8. Human exploratory sessions | E-01 complete; E-02 assigned for later collaboration | E-01 completed and debriefed with three confirmed novel defects. A portable collaborator handoff prepares a second tester to conduct E-02 on an independently seeded local database |
| 9. Cross-technique triage and comparison | E-01 incorporated; blocked by E-02 | E-01 candidates are deduplicated and reflected in the comparison; final totals wait for E-02 |
| 10. Academic literature review | Draft complete | Five-source critical synthesis and metadata matrix complete; final IEEE formatting remains |
| 11. Final report assembly | Draft complete through E-01 | Evidence-based report prose, metrics, evidence index, comparison table, and literature draft exist; E-02-dependent sections remain open |
| 12. Optional defect correction and regression | Deferred | May begin only after E-01 and E-02 baseline sessions finish |

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

E-01 is complete. E-02 is intentionally deferred until the user has another
uninterrupted 90-minute window. Independent evidence consolidation, analysis,
literature, and report drafting may continue without modifying application
behaviour. Final cross-technique conclusions remain provisional until E-02 is
executed and debriefed.

The colleague may use a separate clone, machine, and PostgreSQL instance. The
deterministic seed, setup checker, READINESS rehearsal, E-02 handoff, evidence
requirements, and post-session report updates are documented in
COLLABORATOR-HANDOFF.md. This environment variation must be recorded as a threat
to validity, not treated as a requirement to share Olaleye's database.

## Remaining deliverables

1. Completed E-01 and E-02 session records and evidence indexes.
2. Reproduced and deduplicated exploratory findings in defect-log.csv.
3. Manual-versus-Schemathesis comparison, with exploratory results reported
   separately as required by the course.
4. Critical literature synthesis with verified IEEE references.
5. Threats to validity, lessons learned, conclusions, and presentation assets.
6. Optional post-baseline fixes and regression evidence, clearly separated
   from the baseline comparison.

## Change-control rule

Do not modify endpoint validation, authorization, persistence, or transaction
behaviour until E-01 and E-02 are complete. Test infrastructure and report
documentation may continue to change if those changes do not alter application
behaviour under test.
