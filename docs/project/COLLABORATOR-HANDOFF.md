# Collaborator handoff for E-02 and report completion

## What is already complete

The primary comparison is complete:

- Formal human-authored deterministic API run M-01: complete.
- Formal Schemathesis runs F-01, F-02, and F-03: complete.
- Formal result triage and K-008 correction: complete.
- E-01 business and data-flow exploratory session: complete and debriefed.
- E-01 novel findings N-001 through N-003: confirmed and logged.
- Literature matrix, critical review draft, metrics, evidence index, and report
  draft through E-01: complete.

Do not rerun M-01 or F-01 through F-03 as replacement formal results. Existing
evidence is authoritative. Re-execution for environment learning must be labeled
non-formal and must not overwrite or be pooled with the recorded runs.

## What remains

1. Conduct E-02 as a new 90-minute validation and misuse session.
2. Debrief and triage E-02 candidates against existing K and N roots.
3. Update the metrics, comparison, results, and report draft.
4. Complete final discussion, conclusion, presentation material, and evidence
   preservation.
5. Optionally fix defects only after E-02 is complete, in separate commits.

## May E-02 use another computer and database?

Yes. E-02 should use the collaborator's own local clone and a separate local
PostgreSQL database. It does not require Olaleye's running process, database, or
machine. The deterministic seed command recreates the required users, products,
and cart state. Different database row IDs are expected and are not a validity
problem.

Using another machine provides a useful reproducibility check. Record the
collaborator's operating system, Python, Node, PostgreSQL, Django, and
Schemathesis versions. The report must also disclose that E-01 and E-02 used
different testers and environments. This reduces E-01 learning carryover but
introduces tester-experience and environment variation as a threat to validity.

## Clean-clone setup on Windows

From PowerShell after cloning and checking out the shared branch:

    python -m venv .venv
    .\.venv\Scripts\python.exe -m pip install -r backend\requirements-dev.txt
    Set-Location frontend
    npm ci
    Set-Location ..
    Copy-Item backend\.env.example backend\.env
    Copy-Item frontend\.env.example frontend\.env

Install and start PostgreSQL if it is not already available. Create an isolated
database using a PostgreSQL account with database-creation permission:

    createdb -U postgres ecommerce_course_project_fuzz

Edit backend/.env locally with the correct PostgreSQL username and password.
Keep FUZZ_DB_NAME different from DB_NAME. Never commit backend/.env. The default
experiment usernames and password are non-personal course-project fixtures and
may remain as shown in the example file.

Validate the setup:

    .\backend\scripts\check_collaborator_setup.ps1

If the local database has not yet been created, use -SkipDatabase to validate
only static prerequisites, then create the database and rerun the full check.

## Mandatory non-formal readiness rehearsal

Before E-02, use the separate READINESS identifier:

    Set-Location backend
    .\scripts\start_exploratory_environment.ps1 -SessionId READINESS

Confirm that http://127.0.0.1:5173/ loads and that experiment_user can log in.
Then stop the rehearsal:

    .\scripts\stop_exploratory_environment.ps1 -SessionId READINESS

Do not interpret readiness actions as E-02 results. Update
exploratory/readiness-record.md only if the collaborator environment exposes a
new setup issue.

## Starting E-02

Read these files before setup, but do not read known-defects.md or detailed
formal failure results immediately before testing:

- exploratory/ET-02-validation-misuse.md
- exploratory/ET-02-session.md
- exploratory/operator-guide.md
- exploratory/E-02-handoff.md

Start the environment:

    Set-Location backend
    .\scripts\start_exploratory_environment.ps1 -SessionId E-02

The launcher resets only deterministic experiment records, starts Django and
React, and creates the before snapshot. Open the frontend, enable Preserve log
in the browser Network panel, and fill tester, environment, date, reset ID, and
start time in ET-02-session.md. Start the 90-minute clock only when the tester
and evidence tools are ready.

The tester-selected initial direction is checkout with missing or invalid
customer values, especially phone data. It is a starting direction, not a fixed
script. The tester must record why each observation motivates the next action.

Use candidate labels E-02-C01, E-02-C02, and so on during execution. Do not
assign K or N IDs until the session and debrief are complete.

## E-02 evidence expectations

- Timestamped journal actions and decision rationale.
- Browser screenshots for important visible states.
- Network request and response status, body, and method.
- HAR export when practical, saved under
  docs/project/results/exploratory/E-02-network.har.
- Database checkpoints before and after suspicious state changes.
- Minimal reproduction for each candidate.
- Clear distinction among product defects, known roots, usability observations,
  setup failures, and tester mistakes.

Capture a checkpoint at any time with:

    .\scripts\capture_exploratory_snapshot.ps1 -SessionId E-02 -Label checkpoint-1

At 90 minutes, stop even if ideas remain. Capture final state and stop services:

    .\scripts\stop_exploratory_environment.ps1 -SessionId E-02

## E-02 debrief questions

1. What behavior was most important or surprising?
2. What felt confusing, unsafe, or inconsistent?
3. What remained untested?
4. How much time was design/execution versus investigation/reporting?
5. Which observations should become deterministic regression tests?

## Post-session triage and report update

Only after the debrief:

1. Compare each E-02-C candidate with known-defects.md and defect-log.csv.
2. Reproduce a potentially novel root cause once with a minimal request or UI
   path.
3. Assign the next N ID only when no K or existing N root matches.
4. Update:
   - exploratory/ET-02-session.md
   - defect-log.csv
   - implementation-status.md
   - metrics-summary.md
   - comparison-table.md
   - results/README.md
   - report-draft.md
   - evidence-index.md
5. Run git diff --check and parse defect-log.csv before committing.

## Important validity rules

- Never count raw requests or failed checks as unique defects.
- Never count a known K root as novel.
- Do not convert E-02 findings into the already-frozen M-01 suite and then claim
  them as independent manual discoveries.
- Do not fix product behavior until E-02 completes.
- Preserve aborted and false-positive evidence with an explanation.
- E-01 and E-02 are additional exploratory evidence, not part of the primary
  manual-versus-Schemathesis defect-count denominator.

## Source of truth

- implementation-status.md: authoritative phase status.
- evidence-index.md: artifact identity and inclusion rules.
- metrics-summary.md: frozen numerical results.
- defect-log.csv: root-cause identity and status.
- report-draft.md: current report prose and pending sections.
