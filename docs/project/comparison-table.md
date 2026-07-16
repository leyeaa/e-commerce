# Cross-technique comparison working table

E-01 and E-02 are complete and debriefed. Counts use confirmed root causes,
not raw failed checks or requests.

| Measure | Human-authored M-01 | Schemathesis F-01 to F-03 | Exploratory E-01/E-02 |
| --- | ---: | ---: | ---: |
| Executed or generated cases | 20 | 3,252 | Adaptive journal actions; not a fixed case count |
| Passing controls | 9 | Not used | E-02: 3 explicit validation/robustness controls |
| Raw failing cases | 10 expected failures plus 1 unexpected pass | 9 across runs | Not comparable to scripted case failures |
| Raw failed checks | Not applicable | 15 | Not applicable; findings were journaled and triaged |
| Unique confirmed known defects | 8 | 3 | 2, K-006 and K-009 |
| Unique confirmed novel defects | 0 | 0 | 3, N-001 through N-003 |
| Rejected candidates or false classifications | 1, K-008 | 0 after harness hardening | 1 resolved tester-action candidate; 1 E-02 non-defect observation |
| Tool execution time | 2.88 seconds pytest; 8.769 seconds full runner | 552.58 seconds | Human timeboxes: 180 minutes 13 seconds |
| Human design effort | Not recorded prospectively; unavailable | Not recorded prospectively; unavailable | 60 minutes estimated design/execution across two sessions |
| Line and branch coverage | 64.5 percent store package | Not instrumented comparably | Not measured |

## Known-defect overlap

| Defect | Manual | Formal Schemathesis | Exploratory |
| --- | --- | --- | --- |
| K-001 cross-user cart update | Reproduced | Not reproduced | Not reproduced |
| K-002 malformed quantity 500 | Reproduced | Reproduced in all three runs | Not reproduced |
| K-003 rejected zero deletes state | Reproduced | Not reproduced as a retained formal minimal failure | Not reproduced |
| K-004 missing phone 500 | Reproduced | Reproduced in all three runs | Not reproduced |
| K-005 non-string phone 500 | Reproduced | Not retained as a formal minimal failure | Not reproduced |
| K-006 checkout details not persisted | Reproduced | Outside response-only fuzz oracle | Reproduced in E-01 and E-02 |
| K-007 partial order without rollback | Reproduced by injected failure | Outside black-box generated oracle | Not reproduced |
| K-009 missing required checkout data accepted | Reproduced | Reproduced in all three runs | Reproduced in E-02 |

K-008 is excluded because it was rejected as a duplicate classification of
K-002 rather than a distinct application defect.
