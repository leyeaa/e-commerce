# ENGI 9839 experiment implementation

This directory contains the evidence and protocol for comparing human-authored
deterministic API tests with Schemathesis API fuzzing. Exploratory testing is a
separate required project component.

Current progress and the next experimental gate are maintained in
implementation-status.md. That file is the authoritative phase tracker.

For final collaboration and submission, begin with PRE-PUSH-CHECKLIST.md and
requirements-traceability.md. COLLABORATOR-HANDOFF.md is retained as historical
reproducibility guidance. Local credentials and database state are
intentionally not shared through Git.

## Baseline rule

All three baseline activities are complete:

1. Human-authored deterministic API tests.
2. Schemathesis runs.
3. Session-based exploratory testing.

The recorded baseline is now immutable. Functional defect fixes must be made in
later, separately identifiable commits and must not replace baseline evidence.

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
- implementation-challenges.md: difficulties encountered, mitigations, residual limitations, and lessons.
- requirements-traceability.md: course and proposal commitments mapped to evidence and final gates.
- presentation-slides.md: timed six-minute slide content, speaker prompts, and bibliography.
- presentation-literature-summary.md: required source-by-source presentation literature discussion.
- COLLABORATOR-HANDOFF.md: current final report and presentation peer-review handoff.
- PRE-PUSH-CHECKLIST.md: secret-safe staging and curated-evidence checks.
- evidence-index.md: authoritative mapping from claims and runs to evidence artifacts.
- metrics-summary.md: frozen quantitative values and explicitly unavailable measures.
- baseline.md: immutable starting revision and contamination controls.
- known-defects.md: issues known before the experiment.
- experiment-protocol.md: research questions, metrics, and execution order.
- exploratory/: session charters and completed E-01/E-02 records.
- defect-log.csv: one row per unique candidate or confirmed defect.
- literature-matrix.md: academic literature review working matrix.
- literature-review-draft.md: critical academic synthesis and verified references.
- report-draft.md: authoritative evidence-based report source and submission review candidate.
- export-report-to-docx.ps1: reproducible Microsoft Word exporter for the Markdown report.
- final/ENGI9839_Course_Project_Final_Report.docx: generated 20-page, maximum-12-point report review candidate; selected screenshot insertion remains.
- final/ENGI9839_Course_Project_Presentation.pptx: verified eight-slide presentation review candidate with speaker notes.
- final/ENGI9839_Presentation_Literature_Summary.docx: required five-source literature discussion and complete IEEE bibliography.
- results/: generated logs, summaries, and coverage artifacts.

## Export the Word report

Microsoft Word is required on Windows. From the repository root:

    powershell -ExecutionPolicy Bypass -File docs\project\export-report-to-docx.ps1

The exporter rebuilds the DOCX from report-draft.md, adds the title and contents
pages, preserves tables and figure placeholders, and reports Word's page and
word counts.
