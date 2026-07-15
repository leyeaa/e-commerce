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
independently reproduced. E-02 remains pending, so final exploratory totals and
cross-technique conclusions are not yet frozen.

## Effort data still required

- Human time spent designing the deterministic M-01 suite.
- Human time spent configuring and triaging Schemathesis.
- Time spent confirming and deduplicating K and N defects.
- E-02 design, execution, investigation, and reporting allocation.

These must be reported honestly from available work records or described as
unavailable estimates. Tool wall-clock duration must not be substituted for
human effort.
