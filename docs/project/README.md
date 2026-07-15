# ENGI 9839 experiment implementation

This directory contains the evidence and protocol for comparing human-authored
deterministic API tests with Schemathesis API fuzzing. Exploratory testing is a
separate required project component.

Current progress and the next experimental gate are maintained in
implementation-status.md. That file is the authoritative phase tracker.

For a second tester or another machine, begin with COLLABORATOR-HANDOFF.md and
PRE-PUSH-CHECKLIST.md. Local credentials and database state are intentionally
not shared through Git.

## Baseline rule

The application behaviour must remain unchanged until all three baseline
activities have finished:

1. Human-authored deterministic API tests.
2. Schemathesis runs.
3. Session-based exploratory testing.

Test infrastructure may be added before those runs. Functional defect fixes must
be made later in separately identifiable commits.

## Install experiment dependencies

From the repository root:

    .\.venv\Scripts\python.exe -m pip install -r backend\requirements-dev.txt

## Run human-authored tests and coverage

    cd backend
    ..\.venv\Scripts\python.exe -m coverage erase
    ..\.venv\Scripts\python.exe -m coverage run -m pytest
    ..\.venv\Scripts\python.exe -m coverage report
    ..\.venv\Scripts\python.exe -m coverage html

The backend.settings_test module prevents the configured test database name from
matching the development database name. Django creates and destroys the
PostgreSQL test database during the run.

Known preliminary defects are strict expected failures. A passing known-defect
test is reported as an unexpected pass and must be investigated.

## Validate the OpenAPI schema

    cd backend
    ..\.venv\Scripts\python.exe manage.py spectacular --validate --file schema.yml

The schema is intentionally restricted to:

- POST /api/cart/update/
- POST /api/orders/create/

## Prepare the dedicated fuzz database

Create the database named by FUZZ_DB_NAME in PostgreSQL. It must not be the same
database as DB_NAME. Copy the additional variables from backend/.env.example
into backend/.env.

In terminal one:

    cd backend
    .\scripts\start_fuzz_server.ps1

The script applies migrations, resets only experiment-owned seed records, and
starts Django with backend.settings_fuzz.

In terminal two:

    cd backend
    .\scripts\run_schemathesis.ps1 -MaxExamples 1000 -Seed 9839

The runner obtains a JWT for the seeded experiment user, limits generation to
the two selected endpoints, uses positive and negative generation, and saves a
timestamped log in docs/project/results.

Schemathesis exit code 1 is expected when it discovers a violation. The log must
be triaged into unique confirmed defects rather than counted as raw failures.

## Evidence locations

- implementation-status.md: authoritative implementation phase and completion status.
- COLLABORATOR-HANDOFF.md: clean-clone setup, E-02 execution, triage, and report continuation.
- PRE-PUSH-CHECKLIST.md: secret-safe staging and curated-evidence checks.
- evidence-index.md: authoritative mapping from claims and runs to evidence artifacts.
- metrics-summary.md: frozen quantitative values and explicitly pending measures.
- baseline.md: immutable starting revision and contamination controls.
- known-defects.md: issues known before the experiment.
- experiment-protocol.md: research questions, metrics, and execution order.
- exploratory/: session charters and report templates.
- defect-log.csv: one row per unique candidate or confirmed defect.
- literature-matrix.md: academic literature review working matrix.
- literature-review-draft.md: critical academic synthesis and verified references.
- report-draft.md: evidence-based report prose with E-02 placeholders.
- results/: generated logs, summaries, and coverage artifacts.
