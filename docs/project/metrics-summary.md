# Quantitative metrics summary

All figures are frozen unless explicitly marked pending. Raw failed checks are
not unique defects.

## Primary formal comparison

| Measure | Human-authored M-01 | Schemathesis F-01 to F-03 |
| --- | ---: | ---: |
| Selected endpoints | 2 | 2 |
| Executed or generated cases | 20 | 3,252 |
| Independent formal runs | 1 | 3 |
| Passing manual controls | 9 | Not applicable |
| Strict known-defect failures | 10 | Not applicable |
| Unexpected manual passes | 1 | Not applicable |
| Failing generated cases | Not applicable | 9 across three runs |
| Raw failed checks | Not applicable | 15 across three runs |
| Unique known defects reproduced | 8 | 3 |
| Unique novel defects confirmed | 0 | 0 |
| pytest or generator duration | 2.88 seconds | 552.58 seconds |
| Full runner duration | 8.769 seconds | Not separately recorded |
| Store-package line and branch coverage | 64.5 percent | Not instrumented comparably |

The 64.5 percent value is the formal M-01 baseline measurement. The
post-baseline `snapshot_experiment.py` exploratory evidence utility is excluded
from this coverage boundary.

## Per-run Schemathesis data

| Run | Seed | Cases | Failing cases | Raw failed checks | Duration |
| --- | ---: | ---: | ---: | ---: | ---: |
| F-01 | 9839 | 1,084 | 3 | 5 | 151.60 seconds |
| F-02 | 19839 | 1,084 | 3 | 5 | 164.89 seconds |
| F-03 | 29839 | 1,084 | 3 | 5 | 236.09 seconds |
| Total | | 3,252 | 9 | 15 | 552.58 seconds |

The valid runs consistently reduced to K-002, K-004, and K-009. The partial
first F-01 attempt is excluded because external orchestration terminated it
before completion.

## Exploratory E-01

| Measure | Result |
| --- | ---: |
| Timebox | 90 minutes 13 seconds actual |
| Tester-estimated design and execution | 30 minutes |
| Tester-estimated investigation and reporting | 60 minutes |
| Confirmed novel defects | 3 |
| Known defects reproduced | 1 |
| Non-defect observations retained | 2 |
| Rejected or resolved candidates | 1 |

The three confirmed novel defects are N-001, N-002, and N-003. K-006 was
independently reproduced.

## Exploratory E-02 and combined totals

| Measure | E-02 | E-01 and E-02 combined |
| --- | ---: | ---: |
| Timebox | 90 minutes | 180 minutes 13 seconds |
| Tester-estimated design and execution | 30 minutes | 60 minutes |
| Tester-estimated investigation and reporting | 60 minutes | 120 minutes |
| Confirmed novel defects | 0 | 3 |
| Unique known defects reproduced | 2, K-006 and K-009 | 2, K-006 and K-009 |
| Existing novel defects reproduced or extended | 1, N-002 | 1, N-002 |
| Non-defect observations retained | 1 | 3 |

E-02 produced five candidate observations. Three validation symptoms were
deduplicated to K-009, the expired-authentication symptom reproduced and
extended N-002, and the short numeric address was retained as a non-defect
observation because no address-format oracle was established. Five successful
orders also reproduced K-006. Expected controls rejected a short phone and a
phone containing an at sign, while a punctuation-rich address succeeded after
reauthentication.

## Human-effort limitation

- Human time spent designing the deterministic M-01 suite was not recorded
  prospectively and is unavailable as a defensible measurement.
- Human time spent configuring and triaging Schemathesis was not recorded
  prospectively and is unavailable as a defensible measurement.
- Confirmation and deduplication occurred across implementation and reporting
  work and cannot be separated reliably after the fact.

These are reported as unavailable rather than reconstructed from conversation
length or tool wall-clock duration. The missing formal human-effort measures are
a threat to construct validity and prevent a quantitative effort comparison.
