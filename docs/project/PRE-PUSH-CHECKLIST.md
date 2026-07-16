# GitHub pre-push checklist

## Safety

- [x] Confirm backend/.env is ignored and not staged at this checkpoint.
- [x] Confirm no personal credentials, access tokens, or database dumps are
  staged.
- [x] Confirm all test credentials are the documented non-personal experiment
  fixtures.
- [x] Review every staged binary or PDF intentionally.

Useful checks:

    git check-ignore backend/.env
    git diff --cached --check
    git diff --cached --stat
    git status --short

## Required implementation and documentation

- [x] Isolated test and fuzz settings.
- [x] pytest and Schemathesis configuration and scripts.
- [x] Deterministic seed and snapshot commands.
- [x] Manual suite and OpenAPI instrumentation.
- [x] Exploratory launcher, stopper, charters, and completed E-01/E-02 records.
- [x] Status, defect log, evidence index, metrics, literature, comparison, and
  report draft.
- [x] Requirements traceability, presentation draft, and presentation-source
  summaries.
- [x] Implementation challenge register and report challenge section.

## Curated evidence that should appear as staged files

- [x] M-01 log, JUnit XML, and coverage XML.
- [x] Formal F-01, F-02, and F-03 Schemathesis logs.
- [x] Harness validation and invalid partial-run logs referenced by the report.
- [x] E-01 JSON snapshots and backend request logs.
- [x] E-01 session report.
- [x] E-02 JSON snapshots and backend/frontend logs.
- [x] E-02 session report.
- [x] E-02 screenshots copied, meaningfully named, and indexed under curated evidence.

The `.gitignore` exceptions deliberately expose these curated artifacts while
leaving generic logs, process records, local environments, database settings,
and Schemathesis working data ignored.

## Final collaboration and submission

- [x] Commit message distinguishes test infrastructure/evidence from product
  defect fixes.
- [x] Push review package to origin/main; content commit: 0f3ca52e9357e9b9e4042044c195e1de23225ac5.
- [ ] Collaborator reviews the report claims, bibliography, and presentation.
- [x] Final collaborator handoff identifies authoritative review files, frozen facts, and review priorities.
- [x] Export the Word report and verify at least 12 pages and maximum 12-point
  font: 20 pages and maximum 12 point verified.
- [ ] Insert selected exploratory screenshots at the marked figure placeholders
  and perform the final visual layout review.
- [x] Convert presentation-slides.md to the submitted slide format and retain
  citations plus the IEEE bibliography slide: eight-slide PPTX verified.
- [ ] Rehearse slides 1–7 within approximately 6 minutes and prepare for 2
  minutes of questions.
- [x] Export the five-source presentation literature summary and complete IEEE
  bibliography to a standalone Word document.
- [ ] Submit final/ENGI9839_Presentation_Literature_Summary.docx with the
  presentation materials.
- [x] Keep all product fixes out of the baseline commit; label later regression
  work separately.
