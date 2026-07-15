# GitHub pre-push checklist

## Safety

- [ ] Confirm backend/.env is ignored and not staged.
- [ ] Confirm no personal credentials, access tokens, or database dumps are
  staged.
- [ ] Confirm all test credentials are the documented non-personal experiment
  fixtures.
- [ ] Review every staged binary or PDF intentionally.

Useful checks:

    git check-ignore backend/.env
    git diff --cached --check
    git diff --cached --stat
    git status --short

## Required implementation and documentation

- [ ] Isolated test and fuzz settings.
- [ ] pytest and Schemathesis configuration and scripts.
- [ ] Deterministic seed and snapshot commands.
- [ ] Manual suite and OpenAPI instrumentation.
- [ ] Exploratory launcher, stopper, charters, session records, and handoff.
- [ ] Status, defect log, evidence index, metrics, literature, comparison, and
  report draft.

## Curated evidence that should appear as staged files

- [ ] M-01 log, JUnit XML, and coverage XML.
- [ ] Formal F-01, F-02, and F-03 Schemathesis logs.
- [ ] Harness validation and invalid partial-run logs referenced by the report.
- [ ] E-01 JSON snapshots and backend request logs.
- [ ] E-01 session report.

The `.gitignore` exceptions deliberately expose these curated artifacts while
leaving generic logs, process records, local environments, database settings,
and Schemathesis working data ignored.

## Collaboration

- [ ] Commit message distinguishes test infrastructure/evidence from product
  defect fixes.
- [ ] Push the intended branch and share its exact name and commit hash.
- [ ] Ask the collaborator to run check_collaborator_setup.ps1 and the
  READINESS rehearsal before E-02.
- [ ] Do not merge product fixes into the collaborator handoff before E-02.
