# Baseline record

## Revision

- Baseline commit: acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4
- Commit date: 2026-07-14T04:51:31-02:30
- Commit subject: Brand Update
- System under test: Django REST Framework and PostgreSQL backend
- Selected endpoints: cart update and order creation

At capture time the four instructor/project PDF files were untracked. No
verification or testing implementation existed in the baseline commit.

## Permitted pre-experiment changes

- Test-only dependencies and configuration.
- Separate PostgreSQL test and fuzz database settings.
- Deterministic fixtures and seed commands.
- OpenAPI generation and annotations.
- Test scripts, session templates, logging, and coverage instrumentation.

## Prohibited before baseline runs finish

- Changes to endpoint validation or authorization behaviour.
- Model constraint or persistence changes.
- Transaction handling fixes.
- Any correction of a known or newly discovered functional defect.

## Contamination controls

- Preliminary findings use IDs beginning with K.
- New experimental findings use IDs beginning with N.
- Known findings are excluded from the primary novel-defect count.
- A technique may receive secondary credit for reproducing a K defect.
- Manual tests, fuzzing configuration, and exploratory charters are frozen
  before results are exchanged between techniques.
- Every run uses a reset database and records the exact Git revision.
