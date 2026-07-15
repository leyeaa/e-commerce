# Exploratory environment readiness record

## Rehearsal

- Identifier: READINESS
- Date: 2026-07-15
- Purpose: validate the complete environment workflow without consuming or
  contaminating E-01 or E-02.
- Application baseline: unchanged.
- Database: isolated ecommerce_course_project_fuzz database.

## Checks completed

- All PowerShell runner files parsed without syntax errors.
- Django backend.settings_fuzz system check passed.
- Experiment snapshot command returned valid JSON for two deterministic users.
- React production build completed successfully with 53 transformed modules.
- Launcher rejected a pre-existing port listener rather than using it silently.
- The listener was confirmed as a stale project backend.settings_fuzz process
  before it was stopped.
- Clean launcher reset the isolated records and started Django on port 8000.
- Clean launcher started Vite on port 5173.
- Frontend root returned HTTP 200.
- Primary deterministic user obtained a JWT using the documented credentials.
- Browser-origin CORS preflight allowed the React origin.
- Before-state database snapshot was created.
- Stop workflow created the after-state database snapshot.
- Stop workflow terminated only the Node and Python listeners on the two
  documented ports.
- Ports 5173 and 8000 were confirmed free after shutdown.

## Evidence

- READINESS-before-20260715-044654.json
- READINESS-after-20260715-044742.json
- READINESS backend and frontend logs in docs/project/results/exploratory/

## Outcome

Passed. The environment is ready for E-01. Do not treat READINESS actions or
snapshots as exploratory-test results.
