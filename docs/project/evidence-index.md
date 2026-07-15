# Evidence artifact index

Last updated: 2026-07-15

## Revision identity

- Immutable application baseline: acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4.
- Current post-baseline implementation commit observed during consolidation:
  b6d084c8b2c187073d4f9f472e4deedebf7a8e60.
- Formal-run database server family recorded from the isolated environment:
  PostgreSQL 18.1 on x86_64-windows, 64-bit.
- Product validation, authorization, persistence, and transaction defects were
  not fixed before formal M-01, F-01 through F-03, or E-01.
- Test instrumentation, evidence scripts, and documentation exist after the
  application baseline and must not be described as baseline product features.

## Requirements and planning evidence

| Artifact | Purpose | Status |
| --- | --- | --- |
| ENGI_9839_Course_Project.pdf | Instructor project requirements | Source document |
| ENGI9839_Project_Proposal_Final_Submission.pdf | Approved project topic and proposed comparison | Source document |
| Exploratory_Testing.pdf | Instructor exploratory-testing lecture material | Source document |
| Exploratory_Testing_Examples.pdf | Instructor exploratory examples | Source document |
| baseline.md | Baseline revision and contamination controls | Complete |
| experiment-protocol.md | Research question, measures, oracles, and fairness controls | Frozen |
| formal-execution-plan.md | Formal runs, budgets, sequence, and validity rules | Formal runs complete; E-02 pending |
| implementation-status.md | Authoritative phase tracker | Current |

## Human-authored deterministic test evidence

| Artifact | Description |
| --- | --- |
| manual-test-design.md | Human-selected partitions, boundaries, and oracles |
| backend/tests/manual/ | Frozen pytest implementation |
| results/M-01-20260714-204047.log | Formal terminal output and coverage report |
| results/M-01-20260714-204047.xml | Formal JUnit report |
| results/M-01-coverage-20260714-204047.xml | Machine-readable coverage report |
| results/coverage-html/index.html | Browsable coverage evidence |

## Schemathesis evidence

| Artifact | Description |
| --- | --- |
| backend/schemathesis.toml | Frozen generation and hook configuration |
| backend/schemathesis_hooks.py | Per-request deterministic state restoration |
| backend/scripts/run_schemathesis.ps1 | Authenticated repeatable runner |
| results/schemathesis-20260714-203403.log | Pre-formal hardening run containing the corrected response-schema artifact |
| results/schemathesis-20260714-203915.log | Final short harness validation |
| results/schemathesis-20260714-204316.log | Invalid partial F-01 attempt terminated by orchestration timeout |
| results/schemathesis-20260714-204827.log | Valid formal F-01, seed 9839 |
| results/schemathesis-20260714-205225.log | Valid formal F-02, seed 19839 |
| results/schemathesis-20260714-205539.log | Valid formal F-03, seed 29839 |

Earlier Schemathesis logs at 19:58 and 19:59 are infrastructure-development
artifacts and are excluded from formal results.

## Exploratory E-01 evidence

| Artifact | Description |
| --- | --- |
| exploratory/ET-01-business-data-flow.md | Frozen charter |
| exploratory/ET-01-session.md | Tester journal, candidates, debrief, and evidence index |
| results/exploratory/E-01-before-20260715-124843.json | Reset state before the session |
| results/exploratory/E-01-after-lamp-quantity-20260715-132310.json | Single-product checkpoint |
| results/exploratory/E-01-two-product-cart-20260715-135254.json | Two-product totals checkpoint |
| results/exploratory/E-01-after-first-zero-boundary-20260715-140117.json | Expected UI-removal checkpoint |
| results/exploratory/E-01-empty-cart-20260715-140814.json | N-002 evidence: UI empty while Table persisted |
| results/exploratory/E-01-after-20260715-142907.json | Final order and empty-cart state |
| results/exploratory/E-01-backend-error.log | HTTP request method, path, status, and time evidence |
| results/exploratory/E-01-backend.log | Migration, seed, and server setup evidence |
| results/exploratory/E-01-frontend.log | Vite session log |
| results/exploratory/E-01-frontend-error.log | Frontend server error stream |

No screenshots or HAR export were supplied for E-01. Contemporaneous tester
observations, server logs, source confirmation, and database snapshots form its
evidence chain. This limitation must be reported.

## Exploratory E-02 evidence

E-02 is explicitly deferred. No E-02 server, reset, snapshot, journal action,
or testing result exists yet. Its pending status must not be interpreted as a
zero-defect session.

## Defect and analysis records

| Artifact | Purpose |
| --- | --- |
| known-defects.md | Preliminary K register and rejected K-008 audit trail |
| defect-log.csv | One row per unique known, rejected, or novel root cause |
| comparison-table.md | Cross-technique measures and overlap |
| results/README.md | Narrative run summaries and dispositions |
| literature-matrix.md | Academic evidence extraction |
| literature-review-draft.md | Critical literature synthesis |

## Preservation warning

Generated log and XML patterns are ignored by Git. Before final submission,
copy or force-add the selected formal artifacts to the submission evidence
package and verify their hashes. Do not rely on the current working directory as
the sole copy of experimental evidence.
