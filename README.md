# ENGI 9839 Course Project: E-Commerce Application Testing

This submission contains an existing React/Django e-commerce application and
the implementation artifacts for comparing human-authored deterministic API
tests with Schemathesis schema-driven API fuzzing. It also includes the
exploratory-testing evidence.

This root README is the primary instruction document for the submission. The
more detailed experiment artifact map is in
[`docs/project/README.md`](docs/project/README.md).

## What is included

- `backend/`: Django REST API, isolated test/fuzz settings, human-authored
  pytest suite, OpenAPI schema, and PowerShell runners.
- `frontend/`: React/Vite user interface.
- `docs/project/results/`: retained sample logs, XML results, snapshots, and
  exploratory evidence.
- `docs/project/final/`: Word report, PowerPoint presentation, and presentation
  literature summary.
- `docs/project/`: test design, protocol, defect register, metrics, and
  reproducibility documentation.

## Verified environment

- Windows PowerShell
- Python 3.14.0
- PostgreSQL 18.1
- Node.js `20.19+` or `22.12+` (required by the locked Vite version)

Other compatible versions may work, but the project was verified with the
environment above.

## 1. Set up a clean copy

Run the following commands from the repository root, which is the directory
containing `backend`, `frontend`, and this README.

### Create the Python environment

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -r backend\requirements-dev.txt
```

`requirements-dev.txt` installs both the application dependencies and the test
tools: pytest, pytest-django, coverage.py, and Schemathesis.

### Configure PostgreSQL

Copy the environment template:

```powershell
Copy-Item backend\.env.example backend\.env
```

Edit `backend/.env` and supply the local PostgreSQL username and password. Keep
these three database names different:

```env
DB_NAME=ecommerce_db
TEST_DB_NAME=ecommerce_course_project_test
FUZZ_DB_NAME=ecommerce_course_project_fuzz
```

Create `DB_NAME` and `FUZZ_DB_NAME` in PostgreSQL. Do not manually create
`TEST_DB_NAME`; Django creates and removes that database during the manual test
run. The configured PostgreSQL user must have permission to create test
databases.

For example, an administrator can run:

```sql
CREATE DATABASE ecommerce_db;
CREATE DATABASE ecommerce_course_project_fuzz;
```

`backend/.env` contains local credentials and must not be included in the
submission.

## 2. Run the application

### Backend terminal

From the repository root:

```powershell
cd backend
..\.venv\Scripts\python.exe manage.py migrate
..\.venv\Scripts\python.exe manage.py seed_experiment --reset
..\.venv\Scripts\python.exe manage.py runserver
```

The API is available at `http://127.0.0.1:8000`. The seed command creates sample
products and the experiment user defined in `backend/.env.example`.

### Frontend terminal

Open another terminal at the repository root:

```powershell
cd frontend
npm install
Copy-Item .env.example .env
npm run dev
```

Open the URL shown by Vite, normally `http://127.0.0.1:5173` or
`http://localhost:5173`.

With the unchanged example configuration, the seeded login is:

```text
Username: experiment_user
Password: CourseProject-Only-Password-Change-Me
```

These are local experiment credentials, not production credentials.

## 3. Run the human-authored test suite

PostgreSQL must be running, but the Django development server does not need to
be running. From the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File backend\scripts\run_manual_tests.ps1
```

Expected summary:

```text
1 failed, 9 passed, 10 xfailed
TOTAL ... 64.5%
```

This is the expected defect-reproduction result:

- Nine control tests pass.
- Ten strict expected failures reproduce known defects.
- The single reported failure is the strict XPASS for rejected classification
  K-008. It is retained to show the audit trail and is not an infrastructure
  failure.
- The process returns exit code `1` because K-008 is strict.

The 64.5% figure is combined line-and-branch coverage for the formal M-01
application scope. The post-baseline exploratory snapshot utility is excluded
because it is evidence-collection code rather than application functionality
evaluated by the suite.

Timestamped logs and XML reports are written under `docs/project/results/`.

## 4. Run Schemathesis API fuzzing

Stop any normal Django development server using port 8000 before starting the
isolated fuzz server.

### Terminal 1: start the isolated server

From the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File backend\scripts\start_fuzz_server.ps1
```

Leave this terminal running. The script verifies the dedicated fuzz database,
applies migrations, resets experiment-owned seed data, and starts Django with
`backend.settings_fuzz`.

### Terminal 2: reproduce F-01

From the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File backend\scripts\run_schemathesis.ps1 -MaxExamples 500 -Seed 9839
```

Expected summary:

```text
Operations: 2 selected / 2 tested
1084 generated, 3 found 5 unique failures
Seed: 9839
```

The three failing cases reproduce:

- K-002: malformed cart quantity causes HTTP 500.
- K-004: omitted phone causes HTTP 500.
- K-009: a request missing the required name is accepted with HTTP 200.

Schemathesis reports five failed checks because each HTTP 500 violates both the
server-error and documented-status checks. These are three failing cases and
three known root causes, not five application defects. Exit code `1` is
expected when the violations are found.

To repeat the other two formal seeds while Terminal 1 remains running:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File backend\scripts\run_schemathesis.ps1 -MaxExamples 500 -Seed 19839
powershell -NoProfile -ExecutionPolicy Bypass -File backend\scripts\run_schemathesis.ps1 -MaxExamples 500 -Seed 29839
```

Stop Terminal 1 with `Ctrl+C` after testing.

## 5. Sample results and findings

| Technique | Recorded result | Main finding |
| --- | --- | --- |
| Human-authored M-01 | 20 cases; 9 passed, 10 xfailed, 1 strict XPASS; 64.5% coverage | Reproduced eight known root causes using ownership, persistence, validation, and transaction oracles |
| Schemathesis F-01-F-03 | 3,252 generated cases; 9 failing cases; 15 failed checks | Reproduced K-002, K-004, and K-009 consistently across three seeds |
| Exploratory E-01/E-02 | 180 minutes 13 seconds | Confirmed N-001, N-002, and N-003 and reproduced K-006 and K-009 |

The main conclusion is that the approaches were complementary. Human-authored
tests achieved deeper business-state checking with a small number of targeted
cases, while Schemathesis achieved systematic input breadth. Exploratory
testing found frontend and authentication-lifecycle problems that neither
formal API technique identified as novel root causes.

Representative retained outputs:

- `docs/project/results/M-01-20260714-204047.log`
- `docs/project/results/M-01-20260714-204047.xml`
- `docs/project/results/M-01-coverage-20260714-204047.xml`
- `docs/project/results/schemathesis-20260714-204827.log`
- `docs/project/results/schemathesis-20260714-205225.log`
- `docs/project/results/schemathesis-20260714-205539.log`
- `docs/project/results/README.md`
- `docs/project/exploratory/ET-01-session.md`
- `docs/project/exploratory/ET-02-session.md`
- `docs/project/defect-log.csv`

## Troubleshooting

- **Port 8000 is already in use:** stop the existing Django process before
  starting `start_fuzz_server.ps1`.
- **No active account found:** confirm Terminal 1 is the isolated fuzz server,
  not the normal development server, and keep the experiment credentials from
  `backend/.env.example` consistent.
- **Database creation or permission error:** confirm PostgreSQL is running and
  that `DB_USER` can create Django's temporary test database.
- **Schemathesis displays symbols such as `Γ£à`:** this is a Windows PowerShell
  Unicode-display issue and does not affect results.
- **The test process exits with code 1:** compare the final summary with the
  expected results above. Both formal runners intentionally return `1` when
  the documented application violations are reproduced.