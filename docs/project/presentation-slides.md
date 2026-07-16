# ENGI 9839 presentation slide draft

Target: approximately 6 minutes plus 2 minutes for questions. Keep the final
deck visually sparse; the notes below are speaking prompts, not slide text.

## Slide 1 — Question and case study (35 seconds)

### On slide

**Manual API Tests vs. Schema-Driven API Fuzzing**

Django/PostgreSQL e-commerce case study

Olaleye Adeniyi Akinuli and Chiemerie Cletus Obijiaku

- Can generated input volume replace targeted business-state oracles?
- Two authenticated endpoints; one frozen existing application

### Speaker notes

We compared human-authored deterministic API tests with Schemathesis fuzzing on
cart update and order creation. Exploratory testing was a separate required
system-level activity. Our question was not which technique wins universally,
but how they differ in defects, coverage, effort, and fault type on this case.

## Slide 2 — Experimental design (50 seconds)

### On slide

- Immutable application baseline; product defects left unfixed
- Manual: 20 pytest cases with database and transaction oracles
- Automated: 3 Schemathesis seeds, OpenAPI 3.0.3, per-case state reset
- Exploratory: two 90-minute chartered sessions
- Count unique root causes, not requests or failed checks [1], [2]

### Speaker notes

Both formal techniques targeted the same two endpoints and baseline. The manual
suite deliberately checked ownership, mutation after rejection, persistence,
totals, and rollback. Schemathesis generated positive, negative, coverage, and
fuzz inputs and checked response properties. Known defects were tagged K and
excluded from novel counts. This avoided claiming repeated symptoms as separate
defects.

## Slide 3 — Primary quantitative result (55 seconds)

### On slide

| Measure | Manual M-01 | Schemathesis F-01–F-03 |
| --- | ---: | ---: |
| Cases | 20 | 3,252 |
| Known root causes reproduced | 8 | 3 |
| Novel root causes | 0 | 0 |
| Duration | 2.88 s test / 8.769 s runner | 552.58 s |
| Comparable coverage | 64.5% | Not collected |

### Speaker notes

The 3,252 generated cases produced nine failing cases and fifteen raw failed
checks, but these reduced to only K-002, K-004, and K-009. The manual suite
reproduced K-001 through K-007 and K-009. One expected manual failure passed and
led us to reject K-008 as a duplicate misclassification, which is an important
validity result rather than a product success claim.

## Slide 4 — What each technique could see (55 seconds)

### On slide

**Manual strengths**

- Cross-user ownership
- State mutation after rejection
- Missing persistence
- Transaction rollback

**Known roots reproduced:** K-001 through K-007 and K-009.

**Schemathesis strengths**

- High-volume malformed input
- Repeatability across seeds
- Contract/status/schema violations

**Known roots reproduced:** K-002, K-004, and K-009.

Generated volume is not defect count [2]. Coverage is supporting evidence, not
a quality verdict [5].

### Speaker notes

The manual advantage came from deeper application-specific oracles, not from
manual execution—the tests themselves ran automatically. Schemathesis reduced
case-by-case input design and repeatedly exposed input-validation failures, but
response-level black-box checks could not directly detect missing database
fields or partial transactions.

## Slide 5 — Required exploratory testing (55 seconds)

### On slide

- E-01 and E-02: 180 min 13 s total
- Three novel roots: N-001, N-002, N-003
- Two known roots reproduced: K-006 and K-009
- Most surprising: 17-digit phone accepted
- Most confusing: expired session shown as generic **Order failed**

Charters and debriefs address exploratory coverage risk [3], [4].

### Speaker notes

Exploration followed the complete frontend journey and therefore found issues
outside the two-operation formal scope: no cart refetch after login, misleading
expired-authentication handling, and empty image-source warnings. E-02 added no
new root cause, but showed that long and whitespace checkout values reproduced
missing validation. Retrying the punctuation-rich address after login proved
that punctuation was not the cause of the earlier 401 failure.

## Slide 6 — Answer, limitations, and recommendation (55 seconds)

### On slide

**Answer:** complementary techniques, not a universal winner

- Pair generated contract exploration with business-state assertions
- Add timeboxed exploratory journeys for lifecycle and usability failures
- Do not compare raw volume with deduplicated defects

**Challenges handled:** destructive state, schema/harness inaccuracies, one
aborted fuzz run, a rejected preliminary defect, and expired JWTs.

Limits: one application, two endpoints, one fuzzing tool, one exploratory
tester, prior system knowledge, incomplete formal human-effort records.

### Speaker notes

For this case, 20 targeted tests expressed more defect-revealing backend
oracles than thousands of generated cases, while fuzzing provided systematic
input breadth and repeatability. Exploratory testing added user-visible findings
but had broader scope, so it is reported separately rather than declared the
winner. These results cannot support a general ranking of manual and automated
testing. The process also required engineering and investigation: isolated
databases and reset hooks protected state, schema inaccuracies were removed
before formal runs, an externally terminated run was preserved and repeated
under the validity rule, and an unexpected pass corrected K-008. Prospective
formal-effort logs remain a limitation.

## Slide 7 — Conclusion and future work (35 seconds)

### On slide

- Human-designed oracles found deeper data-integrity and transaction faults
- Schemathesis efficiently exercised the contract-invalid input surface
- Exploratory testing exposed authentication and frontend lifecycle behavior
- Next: more endpoints/tools, independent testers, mutation testing, and
  post-baseline regression fixes

**Questions?**

## Slide 8 — IEEE bibliography (not timed)

[1] Z. Hatfield-Dodds and D. Dygalo, “Deriving semantics-aware fuzzers from
Web API schemas,” in *2022 IEEE/ACM 44th International Conference on Software
Engineering: Companion Proceedings*, 2022, pp. 345–346,
doi: 10.1109/ICSE-Companion55297.2022.9793781.

[2] H. Sartaj, S. Ali, and J. M. Gjøby, “REST API testing in DevOps: A study
on an evolving healthcare IoT application,” *ACM Transactions on Software
Engineering and Methodology*, vol. 35, no. 6, pp. 1–46, 2026,
doi: 10.1145/3765744.

[3] J. Itkonen and K. Rautiainen, “Exploratory testing: A multiple case study,”
in *2005 International Symposium on Empirical Software Engineering*, 2005,
pp. 84–93, doi: 10.1109/ISESE.2005.1541817.

[4] J. Itkonen, M. V. Mäntylä, and C. Lassenius, “Defect detection efficiency:
Test case based vs. exploratory testing,” in *First International Symposium on
Empirical Software Engineering and Measurement*, 2007, pp. 61–70,
doi: 10.1109/ESEM.2007.56.

[5] L. Inozemtseva and R. Holmes, “Coverage is not strongly correlated with
test suite effectiveness,” in *Proceedings of the 36th International Conference
on Software Engineering*, 2014, pp. 435–445,
doi: 10.1145/2568225.2568271.

## Rehearsal gate

- [x] Convert this content to the submitted slide format.
- [ ] Keep slides 1–7 at or below 6 minutes; bibliography is not presented.
- [ ] Both team members agree on speaking ownership.
- [ ] Perform at least two timed rehearsals and record actual duration.
- [ ] Prepare short answers on fairness, lack of novel formal defects, coverage,
  known-defect contamination, and why exploratory results are separate.
