# ENGI 9839 experiment implementation

This directory contains the detailed evidence and protocol for comparing
human-authored deterministic API tests with Schemathesis API fuzzing.
Exploratory testing is a separate required project component. The repository
root README.md is the primary clean-setup and execution guide for the final
submission; this file is the supplementary experiment-artifact map.

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

The project evaluated testing approaches rather than defect correction.
Confirmed defects were documented but not fixed during the experiment so every
technique examined the same application baseline.

## Install experiment dependencies

From the repository root:

    .\.venv\Scripts\python.exe -m pip install -r backend\requirements-dev.txt

## Run human-authored tests and coverage

From the repository root, use the reproducible runner:

    powershell -NoProfile -ExecutionPolicy Bypass -File backend\scripts\run_manual_tests.ps1

The backend.settings_test module prevents the configured test database name from
matching the development database name. Django creates and destroys the
PostgreSQL test database during the run.

Known preliminary defects are strict expected failures. A passing known-defect
test is reported as an unexpected pass and must be investigated. The expected
baseline summary is 1 failed, 9 passed, and 10 xfailed. The single failure is
the strict unexpected pass for rejected classification K-008, not an
infrastructure failure. Because that case is strict, the runner returns process
exit code 1 for this expected baseline summary.

The formal M-01 coverage result is 64.5 percent combined line and branch
coverage. The coverage configuration excludes migrations, the legacy test
module, and `snapshot_experiment.py`. The snapshot command was added after M-01
to collect exploratory evidence and is outside the formal application-coverage
boundary.

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
    .\scripts\run_schemathesis.ps1 -MaxExamples 500 -Seed 9839

The runner obtains a JWT for the seeded experiment user, limits generation to
the two selected endpoints, uses positive and negative generation, and saves a
timestamped log in docs/project/results. An F-01-equivalent run should report
1,084 generated cases, three failing cases, and five failed checks. These reduce
to known defects K-002, K-004, and K-009 rather than five unique defects.

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
- final/ENGI9839_Course_Project_Final_Report.docx: generated 22-page, maximum-12-point report review candidate with the full consolidated defect table; selected screenshot insertion remains.
- final/ENGI9839_Course_Project_Presentation.pptx: verified eight-slide presentation review candidate with speaker notes.
- final/ENGI9839_Presentation_Literature_Summary.docx: required five-source literature discussion and complete IEEE bibliography.
- results/: generated logs, summaries, and coverage artifacts.

## Export the Word report

Microsoft Word is required on Windows. From the repository root:

    powershell -ExecutionPolicy Bypass -File docs\project\export-report-to-docx.ps1

The exporter rebuilds the DOCX from report-draft.md, adds the title and contents
pages, preserves tables and figure placeholders, and reports Word's page and
word counts.
