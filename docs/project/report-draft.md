# ENGI 9839 course project report draft

Working title: Comparing Human-Authored Deterministic API Tests with
Schema-Driven API Fuzzing on a Django E-Commerce Application

Status: partial draft. E-02, final cross-technique triage, final effort values,
abstract, and conclusions remain pending.

## 1. Introduction

Web APIs must reject malformed requests, enforce authorization boundaries, and
preserve consistent state across multi-step operations. Conventional tests can
encode detailed business and persistence oracles, but their effectiveness
depends on which cases a person anticipates. Schema-driven fuzzing can generate
many diverse requests automatically, but its results depend on schema accuracy,
available response oracles, and the ability to reach meaningful application
state. This project evaluates those complementary strengths on an existing
React and Django e-commerce application.

The primary research question is: for two selected Django REST API endpoints,
how do human-authored deterministic tests and Schemathesis schema-driven fuzzing
differ in defect detection, coverage, setup and execution effort, and the types
of faults detected? Session-based exploratory testing is conducted as a
separate required method and is not merged into the primary two-technique
comparison.

The study contributes a reproducible case-study protocol, a frozen suite of
human-designed tests, three seeded Schemathesis runs, explicit false-positive
and root-cause triage, and timeboxed exploratory evidence. It deliberately
separates raw failed requests from unique defects and separates known defects
from novel findings.

## 2. Background and related work

Schema-driven API fuzzing derives requests from a machine-readable contract.
Hatfield-Dodds and Dygalo present Schemathesis as a property-based generator for
OpenAPI and GraphQL services [1]. Their evaluation of eight fuzzers on sixteen
open-source services reported broad schema compatibility and more unique
defects for Schemathesis than the next-best tool on each target. Sartaj, Ali,
and Gjøby later included Schemathesis in an industrial study spanning 17 APIs,
120 endpoints, and 14 releases [2]. Their separation of tests, failures,
potential faults, coverage, regressions, and cost supports the present study's
decision not to treat generated volume as defect count.

Exploratory testing combines learning, design, and execution during the test
session. Itkonen and Rautiainen's multiple-case study describes versatility and
rapid learning as perceived benefits while identifying coverage management as
a weakness [3]. Itkonen, Mäntylä, and Lassenius compare exploratory and
test-case-based work in controlled 90-minute sessions and report no significant
difference in defect-detection effectiveness in that setting [4]. These works
motivate the use of charters, journals, timeboxes, evidence indexes, and
debriefs rather than undocumented ad hoc testing.

Coverage is included as supporting evidence rather than a quality target.
Inozemtseva and Holmes found only low-to-moderate correlation between coverage
and mutation-based effectiveness after controlling for suite size [5]. The
present study therefore reports coverage alongside confirmed root causes and
oracles, not as proof of superiority.

## 3. System under test and baseline

The system comprises a React 19 frontend, Django 5.2 and Django REST Framework
backend, JWT authentication, and PostgreSQL persistence. The application was
already implemented before this project and contained no dedicated verification
or validation infrastructure. The immutable application baseline is commit
acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4.

The primary comparison targets two authenticated endpoints:

- POST /api/cart/update/, which updates a cart-item quantity.
- POST /api/orders/create/, which transforms the current cart into an order.

They were selected because they combine typed input, authorization, business
rules, destructive state changes, totals, and multi-model persistence. Product
defects were not fixed before baseline testing. Test dependencies, isolated
database settings, deterministic fixtures, OpenAPI annotations, and evidence
scripts were permitted because they did not correct endpoint behavior.

## 4. Methodology

### 4.1 Defect identity and behavioral oracles

Findings known before formal execution use K identifiers and are excluded from
novel-defect counts. Findings first confirmed during valid experimental work use
N identifiers. One defect is one distinct root cause; repeated requests, failed
checks, and symptom variants are not counted separately.

The principal oracles require that unauthorized users cannot modify another
user's data, invalid input receives a documented client response rather than a
server error, rejected requests do not mutate persistent state, order creation
is atomic, cart and order totals agree, empty carts do not produce orders,
required checkout values satisfy the contract, and successful responses conform
to the OpenAPI response schema.

### 4.2 Human-authored deterministic testing

The human-designed technique contains 20 pytest cases: eight for cart update
and twelve for order creation after parameter expansion. Inputs were selected
from authentication, ownership, identifier, quantity, cart-state, phone,
required-field, payment-choice, and transaction-failure partitions. Although
pytest automates execution, generation and oracle design are human-authored.

Known defects are represented as strict expected failures. This retains
executable evidence while causing unexpected correction or incorrect
classification to fail the run. Tests also inspect database state, totals,
ownership, order items, and rollback behavior rather than checking status codes
alone.

### 4.3 Schema-driven fuzzing

drf-spectacular generates an OpenAPI 3.0.3 contract restricted to the two
experiment endpoints. Request schemas describe documented fields and
constraints, while response schemas include application and framework error
bodies. Only JSON request media is advertised.

Schemathesis 4.22.4 runs positive, negative, coverage, and fuzzing phases with
checks for server errors, status and content-type conformance, response-schema
conformance, and negative-data rejection. A hook restores the isolated
experiment user's cart and order state before every generated call so one case
cannot empty the cart or create an order that changes the next case's reachable
behavior. Three formal seeds use a maximum of 500 fuzz examples per operation.

### 4.4 Exploratory testing

Exploratory work is reported separately. E-01 used a 90-minute business and
data-flow charter with Guidebook and Fed-Ex tours. A deterministic environment
captured before, checkpoint, and after database snapshots plus Django and Vite
logs. The tester chose subsequent actions from observations and completed a
debrief. E-02 will use validation and misuse tours but is explicitly deferred;
no result is inferred for it.

## 5. Verification infrastructure implementation

Separate Django settings prevent the automatically managed test database and
standalone fuzz database from matching the development database. A management
command creates two deterministic users, two products, carts, and known
quantities. Another command serializes experiment-owned cart, order, and line
state as JSON for exploratory evidence.

The manual runner erases prior coverage data, executes the frozen suite, writes
JUnit and coverage XML, produces HTML coverage, and records wall-clock time.
The Schemathesis runner obtains a fresh JWT, limits execution to the selected
paths, records the seed and budget, and saves the complete console log.

An exploratory launcher verifies that ports are free, resets only experiment
records, starts the isolated Django server and Vite frontend, waits for both
services, and writes a before snapshot. The stop workflow captures after state
and terminates only the documented Python and Node listeners. A separate
READINESS rehearsal validated service startup, authentication, CORS, snapshots,
and clean shutdown before E-01.

## 6. Results

### 6.1 Human-authored run M-01

M-01 collected 20 cases. Nine controls passed, ten strict known-defect tests
failed as expected, and one strict expected failure unexpectedly passed. There
were no ordinary unexpected failures. Store-package combined line and branch
coverage was 64.5 percent. pytest execution took 2.88 seconds and the complete
runner, including reports, took 8.769 seconds.

The unexpected pass was valuable validity evidence. K-008 had claimed that a
malformed item identifier produced a server error, but the selected object value
correctly received 400. Review of the earlier smoke request showed a valid item
identifier and malformed quantity, making K-008 a duplicate misclassification
of K-002. K-008 was rejected and M-01 was not repeated.

The manual suite reproduced eight unique known defects: K-001 through K-007 and
K-009. These included cross-user modification, mutation on rejected input,
unhandled types, missing checkout persistence, and non-atomic order creation.
No novel defect was confirmed by the formal manual run.

### 6.2 Formal Schemathesis runs

F-01, F-02, and F-03 each generated 1,084 cases. Across 3,252 cases, nine cases
failed fifteen raw checks in 552.58 seconds. All three seeds reduced to the same
known root causes: malformed quantity caused a server error (K-002), missing
phone caused a server error (K-004), and missing name was accepted (K-009).
There was no novel confirmed root cause.

An initial F-01 attempt was terminated by an external orchestration timeout and
is retained as an invalid partial artifact. The valid repeat changed only the
external process allowance, not the seed, schema, budget, baseline, or reset
hook. Earlier smoke checks exposed provisional 401 and parse-error schema
inaccuracies. Those instrumentation artifacts were corrected before formal
execution and are not counted as application failures.

### 6.3 Exploratory E-01

Olaleye completed E-01 in 90 minutes 13 seconds and estimated 30 minutes for
test design and execution and 60 minutes for investigation and reporting. The
session covered login, one- and two-product carts, add, remove, normal quantity
changes, badge semantics, totals, refresh, COD checkout, order persistence, and
cart cleanup.

Three novel defects were confirmed. N-001 occurs because a successful login
stores tokens and navigates home but does not trigger a cart refetch; persistent
items and the badge remain hidden until a full frontend reload. N-002 occurs
after token expiry: unauthorized cart responses are interpreted as empty cart
data while Navbar continues to show Logout based only on token presence. A JSON
snapshot proved that Table quantity 2 and total 251.00 remained in PostgreSQL
while the UI claimed the cart was empty. N-003 occurs when products have no
image: the resolver returns an empty string and product components render it as
an image source, producing repeated React warnings.

E-01 also reproduced known K-006. Checkout accepted name, address, phone, and
COD, returned 200, persisted order 2012 with one Table at quantity 1 and total
125.50, and cleared the cart. The final order had no persisted checkout-detail
fields. Missing cart-line subtotals and Console logging of Cart Items were
retained as usability and code-quality observations rather than inflated into
defect counts.

### 6.4 E-02 pending

E-02 is deferred to a later independent 90-minute window. The tester selected
invalid checkout details, especially phone values, as the initial direction.
E-02 results, candidate triage, and final exploratory totals must be added after
that session. A pending session is not a zero-defect result.

## 7. Provisional discussion

The current primary comparison shows complementarity rather than a universal
winner. The manual suite reproduced eight known root causes with 20 carefully
selected cases because it encoded ownership, persistent-state, transaction, and
injected-failure oracles. Schemathesis produced far more inputs and repeatedly
identified three input-contract failures, but response-level black-box checks
could not directly identify missing checkout persistence or partial database
transactions.

Generated volume did not translate directly to unique defects: 3,252 formal
cases reduced to three already-known root causes. This does not make generation
valueless; it demonstrates repeatability across seeds and exercises malformed
input classes without manually enumerating them. It also illustrates the study
by Sartaj et al. [2], where many generated tests did not expose failures and
cost and deduplication remained important.

E-01 found three novel frontend and lifecycle defects because its scope followed
the user-visible cart-to-order journey rather than only the two selected API
operations. Those findings must not be used to claim exploratory superiority
over the primary techniques: scope and oracles differ. Instead, they show why
the required exploratory component adds system-level learning about token
lifecycle, navigation, rendering, and state visibility.

Final discussion must add E-02 results, complete effort estimates, and an
overlap diagram after all candidates are triaged.

## 8. Threats to validity

Construct validity is limited by the operational definition of a defect and by
available oracles. Status and schema checks detect crashes and contract
violations but not all business errors. Coverage is measured only for the manual
suite and is not a direct effectiveness score. Human effort estimates are
retrospective and partly unavailable.

Internal validity is affected by prior code inspection, smoke testing, and the
project owner's exposure to formal findings before E-01. Known K defects are
therefore separated from novel N defects, smoke findings are excluded, and the
exploratory report discloses prior exposure. Test-only OpenAPI annotations and
state-restoration hooks could influence tool reachability, although endpoint
implementation behavior was not corrected.

External validity is limited to one small e-commerce application, two selected
API endpoints, one manual suite, one fuzzing tool, three seeds, and one E-01
tester. Results should not be generalized into broad rankings of manual testing,
Schemathesis, or exploratory testing.

Reliability is supported by fixed revisions, dependency versions, seeds,
commands, isolated databases, per-case reset, session timestamps, server logs,
and JSON snapshots. E-01 lacks screenshots and HAR export, so its evidence chain
relies on contemporaneous tester reports, logs, snapshots, and source
confirmation. Generated artifacts are Git-ignored and require deliberate
preservation before submission.

## 9. Post-baseline correction

No functional defect correction is part of the baseline comparison. After E-02
and final triage, selected K and N defects may be fixed in separately identified
commits. Applicable tests should then be rerun as regression evidence, but fixed
results must not replace or be pooled with baseline results.

## 10. Conclusion

Pending E-02 and final analysis. The current evidence indicates that
human-authored tests expressed deeper persistence and transaction oracles,
Schemathesis efficiently and repeatedly exercised contract-invalid inputs, and
exploratory testing exposed user-visible authentication lifecycle failures
outside the two-operation comparison. The final conclusion must remain scoped
to this application and protocol.

## Working references

[1] Z. Hatfield-Dodds and D. Dygalo, 'Deriving semantics-aware fuzzers
from Web API schemas,' in 2022 IEEE/ACM 44th International Conference on
Software Engineering: Companion Proceedings, 2022, pp. 345-346.

[2] H. Sartaj, S. Ali, and J. M. Gjøby, 'REST API testing in DevOps: A
study on an evolving healthcare IoT application,' ACM Transactions on Software
Engineering and Methodology, 2025.

[3] J. Itkonen and K. Rautiainen, 'Exploratory testing: A multiple case
study,' in 2005 International Symposium on Empirical Software Engineering,
2005, pp. 84-93.

[4] J. Itkonen, M. V. Mäntylä, and C. Lassenius, 'Defect detection
efficiency: Test case based vs. exploratory testing,' in First International
Symposium on Empirical Software Engineering and Measurement, 2007, pp. 61-70.

[5] L. Inozemtseva and R. Holmes, 'Coverage is not strongly correlated
with test suite effectiveness,' in Proceedings of the 36th International
Conference on Software Engineering, 2014, pp. 435-445.

Use the DOI-complete versions in literature-review-draft.md for the final
bibliography.
