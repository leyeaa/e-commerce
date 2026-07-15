# Course project report outline

## 1. Introduction

- Problem context and motivation.
- Primary comparison: human-authored deterministic API tests versus
  schema-driven Schemathesis fuzzing.
- Required additional exploratory-testing component.
- Research question, scope, and contribution.

## 2. Background and literature review

- Verification, validation, and API testing concepts used in the project.
- Human-designed deterministic testing.
- Property-based and schema-driven API fuzzing.
- Exploratory testing and session-based controls.
- Coverage, defect counts, and measurement cautions.
- Critical synthesis from literature-review-draft.md.

## 3. System under test

- React, Django REST Framework, and PostgreSQL architecture.
- Baseline revision and reason for selecting an existing application.
- Selected cart-update and order-create endpoints.
- Baseline constraints and known-defect classification.

## 4. Methodology

- Case-study and comparative design.
- Manual test partitions and behavioral oracles.
- OpenAPI instrumentation and Schemathesis configuration.
- Seeds, budgets, isolated databases, and per-case state restoration.
- Exploratory charters, tours, 90-minute sessions, and evidence capture.
- Primary and secondary measures.
- Defect confirmation and deduplication rules.

## 5. Implementation

- Test dependencies and isolated settings.
- Deterministic seed and snapshot commands.
- pytest suite and coverage runner.
- OpenAPI scope and response instrumentation.
- Schemathesis runner and state-reset hook.
- Exploratory environment and session records.
- Distinction between instrumentation and product fixes.

## 6. Results

- Infrastructure smoke and harness-hardening results.
- Formal M-01 results and K-008 unexpected-pass investigation.
- F-01 through F-03 generated cases, duration, and root causes.
- E-01 and E-02 coverage and findings.
- Cross-technique overlap and novel-defect table.
- Coverage, effort, execution time, and false-positive results.

## 7. Discussion

- Answer to the research question.
- Fault types each technique exposed or missed.
- Generator volume versus unique defects.
- Human design effort versus tool execution and triage effort.
- Role and limits of coverage.
- Value added by exploratory testing.

## 8. Threats to validity

- Two-endpoint single-application scope.
- Known-defect and smoke-run contamination.
- Prior tester exposure to formal findings before exploratory sessions.
- OpenAPI accuracy and instrumentation influence.
- Seed and request-budget sensitivity.
- Expected-failure tests and oracle subjectivity.
- Researcher/tester overlap and effort-measurement accuracy.

## 9. Post-baseline defect correction

- Optional fixes in separately identifiable commits.
- Regression results without mixing them into the baseline comparison.

## 10. Conclusion and future work

- Main result and practical implications.
- Limits on generalization.
- Broader endpoint scope, additional tools, mutation testing, and independent
  testers as future work.

## Appendices

- Commands, versions, seeds, and environment details.
- Manual case inventory.
- Exploratory charters and session reports.
- Defect log and minimal reproductions.
- Evidence artifact index.
