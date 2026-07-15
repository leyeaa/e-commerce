# Formal execution plan

## Freeze point

Run all techniques against baseline revision
acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4 plus test-only instrumentation.
Do not apply product defect fixes until the manual, fuzzing, and exploratory
baseline activities are complete. Record any instrumentation-only changes and
show that they do not alter endpoint implementation behaviour.

## Execution matrix

| Run | Technique | Budget | Reset and evidence |
| --- | --- | --- | --- |
| M-01 | Human-authored pytest suite | 20 collected cases, one formal run | Fresh Django test database; terminal log, JUnit XML, coverage XML and HTML |
| F-01 | Schemathesis | seed 9839, maximum 500 examples per operation | Per-case experiment-state restoration; timestamped log |
| F-02 | Schemathesis | seed 19839, maximum 500 examples per operation | Same as F-01 |
| F-03 | Schemathesis | seed 29839, maximum 500 examples per operation | Same as F-01 |
| E-01 | Exploratory session | 90 minutes | Fresh deterministic data; session sheet and evidence |
| E-02 | Exploratory session | 90 minutes | Fresh deterministic data; session sheet and evidence |

The three fuzz runs provide up to 3,000 generated examples across two
operations, in addition to Schemathesis example, coverage, and stateful phases.
Report the actual generated-case count from each log rather than claiming the
maximum budget.

## Formal sequence

1. Record Git status, baseline hash, dependency versions, operating system,
   PostgreSQL version, date, and start time.
2. Validate the generated OpenAPI document and collect the manual suite without
   executing it.
3. Execute M-01 exactly once using run_manual_tests.ps1.
4. Start the isolated fuzz server and execute F-01 through F-03 without changing
   application or test code between runs.
5. Conduct E-01 and E-02 using the frozen charters.
6. Triage only after independent execution is complete. Reduce raw failures to
   unique root causes and distinguish known defects, novel candidates, schema
   inaccuracies, and tool failures.
7. Confirm candidates with minimal reproductions. Update defect-log.csv and the
   final results summary.
8. If time permits, fix selected defects in separate post-baseline commits and
   rerun applicable regression tests. Do not merge fixed-version results into
   the baseline comparison.

## Timing and effort

For every run record wall-clock duration. Record human setup, test-design,
triage, and confirmation time separately in person-minutes. Tool execution time
must not be presented as human effort.

## Stop and validity rules

- A Schemathesis exit code of 1 means a property violation was found, not that
  the harness failed.
- Abort and repeat a run only for infrastructure failure, such as server loss,
  database loss, or invalid authentication. Preserve and explain the aborted
  log.
- Do not repeat a valid run merely to obtain a preferred outcome.
- Count unique confirmed root causes, not individual requests or failed checks.
- K-009 was known from the smoke run and cannot count as a novel formal
  discovery. K-008 is retained as a rejected classification because its smoke
  evidence duplicated K-002.
