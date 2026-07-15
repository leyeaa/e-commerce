# Baseline results

## Human-authored suite: initial infrastructure run

- Date: 2026-07-14
- Baseline application revision: acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4
- Tests collected: 14
- Passing control tests: 7
- Strict expected failures for known defects: 7
- Unexpected failures: 0
- Unexpected passes: 0
- Store-package line and branch coverage: 66.3 percent

This was an infrastructure verification run. It confirms that every preliminary
K defect has executable evidence, but it is not the final independent
manual-versus-fuzzing result.

## Schemathesis infrastructure smoke run

- Seed: 9839
- Maximum fuzz examples per operation: 25
- Operations selected: 2 of 2
- Generated cases across phases: 204
- Failing cases: 5
- Raw failed checks: 7

Two response-schema checks were instrumentation false positives caused by the
provisional 401 schema. They have been corrected. The smoke run also reproduced
known missing-input failures and identified K-008 and K-009. All smoke findings
are excluded from the later formal novel-defect count.

## Hardened harness validation

- Date: 2026-07-14
- Seed: 9839
- Maximum fuzz examples per operation: 25
- Generated cases across phases: 134
- Failing cases: 3
- Raw failed checks: 5

After restricting requests to JSON, documenting framework and application
client-error bodies, and restoring experiment state before each call, the
validation produced no instrumentation false positives or cross-case state
contamination. Its three failing requests map to known K-002, K-004, and K-009
behaviour. This remains a pre-formal validation and is excluded from the novel
defect comparison.

### Known defects reproduced

- K-001: cross-user cart-item update.
- K-002: malformed cart quantity server error.
- K-003: rejected zero quantity deletes persistent state.
- K-004: missing phone server error.
- K-005: non-string phone server error.
- K-006: accepted checkout details not persisted.
- K-007: partial order persists after an item-write failure.

## Tool versions

- Python 3.14.0
- Django 5.2.16
- Django REST Framework 3.17.1
- pytest 9.1.1
- pytest-django 4.12.0
- coverage.py 7.15.1
- drf-spectacular 0.30.0
- Schemathesis 4.22.4
- PostgreSQL 18.1 on x86_64-windows, 64-bit

Generated logs and HTML reports are ignored by Git. Preserve final submission
artifacts separately or adjust the ignore policy when the evidence is frozen.

## Formal human-authored run M-01

- Date: 2026-07-14
- Collected cases: 20
- Passing controls: 9
- Strict expected failures reproduced: 10
- Unexpected passes: 1
- Unexpected failures: 0
- Store-package line and branch coverage: 64.5 percent
- Test execution reported by pytest: 2.88 seconds
- Full runner wall-clock time including reports: 8.769 seconds
- Evidence log: M-01-20260714-204047.log
- JUnit: M-01-20260714-204047.xml
- Coverage XML: M-01-coverage-20260714-204047.xml

The unexpected pass was the proposed K-008 malformed-item-ID case. The API
returned the expected 400 for the human-selected object value. Review of the
original smoke evidence showed that K-008 had been misclassified: its 500
request used a valid item ID and an object quantity and therefore duplicated
K-002. K-008 is rejected and the M-01 run is preserved without repetition.

## Formal Schemathesis runs

| Run | Seed | Generated cases | Failing cases | Raw failed checks | Tool duration |
| --- | ---: | ---: | ---: | ---: | ---: |
| F-01 | 9839 | 1,084 | 3 | 5 | 151.60 seconds |
| F-02 | 19839 | 1,084 | 3 | 5 | 164.89 seconds |
| F-03 | 29839 | 1,084 | 3 | 5 | 236.09 seconds |
| Total | | 3,252 | 9 | 15 | 552.58 seconds |

Every valid formal fuzz run reproduced the same three known root causes:
K-002 malformed quantity causes a 500, K-004 missing phone causes a 500, and
K-009 missing name is accepted. No new root cause was confirmed. Raw requests
and failed checks are not counted as unique defects.

The first F-01 attempt was terminated by an external 184-second orchestration
limit before Schemathesis completed. Its partial
schemathesis-20260714-204316.log is retained as an invalid infrastructure-abort
artifact. F-01 was repeated with the identical seed, budget, schema, baseline,
and database-restoration hook; only the external process allowance changed.

Formal fuzz evidence logs:

- F-01: schemathesis-20260714-204827.log
- F-02: schemathesis-20260714-205225.log
- F-03: schemathesis-20260714-205539.log

## Exploratory session E-01

- Date: 2026-07-15
- Tester: Olaleye
- Duration: 90 minutes 13 seconds
- Charter: authenticated cart-to-order business and data flow
- Confirmed novel defects: N-001, N-002, and N-003
- Known defects reproduced: K-006
- Non-defect observations retained: missing line subtotals and Cart Items Console logging
- Rejected candidate: one apparent item disappearance explained by intentional tester removal

The most consequential result was N-002: after JWT expiry, unauthorized cart
responses were rendered as a genuine empty cart while the navigation still
showed Logout. A database snapshot proved the Table item remained persistent.
Reauthentication alone did not refresh the cart, confirming separate N-001;
a full frontend reload restored the item. The session then completed a valid
COD order and verified cart cleanup and the known K-006 persistence gap.
