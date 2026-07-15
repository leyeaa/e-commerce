# Cross-technique comparison working table

Do not fill exploratory results until E-01 and E-02 have been completed and
debriefed. Count confirmed root causes, not raw failed checks or requests.

| Measure | Human-authored M-01 | Schemathesis F-01 to F-03 | Exploratory E-01/E-02 |
| --- | ---: | ---: | ---: |
| Executed or generated cases | 20 | 3,252 | Not applicable; journal actions pending |
| Passing controls | 9 | Not used | Pending |
| Raw failing cases | 10 expected failures plus 1 unexpected pass | 9 across runs | Pending |
| Raw failed checks | Not applicable | 15 | Pending |
| Unique confirmed known defects | 8 | 3 | E-01: 1, K-006; E-02 pending |
| Unique confirmed novel defects | 0 | 0 | E-01: 3, N-001 through N-003; E-02 pending |
| Rejected candidates or false classifications | 1, K-008 | 0 after harness hardening | E-01: 1 resolved tester-action candidate; E-02 pending |
| Tool execution time | 2.88 seconds pytest; 8.769 seconds full runner | 552.58 seconds | Pending |
| Human design effort | Record from project work log | Record setup and triage effort | Pending |
| Line and branch coverage | 64.5 percent store package | Not instrumented comparably | Pending |

## Known-defect overlap

| Defect | Manual | Formal Schemathesis | Exploratory |
| --- | --- | --- | --- |
| K-001 cross-user cart update | Reproduced | Not reproduced | Pending |
| K-002 malformed quantity 500 | Reproduced | Reproduced in all three runs | Pending |
| K-003 rejected zero deletes state | Reproduced | Not reproduced as a retained formal minimal failure | Pending |
| K-004 missing phone 500 | Reproduced | Reproduced in all three runs | Pending |
| K-005 non-string phone 500 | Reproduced | Not retained as a formal minimal failure | Pending |
| K-006 checkout details not persisted | Reproduced | Outside response-only fuzz oracle | Reproduced in E-01 |
| K-007 partial order without rollback | Reproduced by injected failure | Outside black-box generated oracle | Pending |
| K-009 missing required checkout data accepted | Reproduced | Reproduced in all three runs | Pending |

K-008 is excluded because it was rejected as a duplicate classification of
K-002 rather than a distinct application defect.
