# ENGI 9839 course project report draft

Working title: Comparing Human-Authored Deterministic API Tests with
Schema-Driven API Fuzzing on a Django E-Commerce Application

Status: submission review candidate. The evidence-based content and final Word
export are complete, and unavailable formal-technique human-effort measures are
disclosed. Selected screenshot insertion, colleague review, and final visual
inspection remain.

## Abstract

This case study compared human-authored deterministic API tests with
Schemathesis schema-driven fuzzing on two authenticated endpoints of an
existing React and Django e-commerce application. A frozen suite executed 20
human-designed cases and reproduced eight known root causes; three seeded
Schemathesis runs generated 3,252 cases and repeatedly reproduced three known
input-contract defects. Neither formal technique found a novel root cause.
Store-package combined line and branch coverage for the formal M-01 baseline
was 64.5 percent, while comparable fuzz coverage was unavailable. Two required
90-minute exploratory sessions separately found three novel frontend and
authentication-lifecycle defects and reproduced two known defects. The small
manual suite could check ownership, persistence, and transaction behavior
directly, while schema-driven fuzzing explored malformed inputs at much higher
volume and repeated the same failures across seeds. All failures were grouped by
root cause, and the conclusions are limited to this application and these two
endpoints.

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

To keep the comparison reproducible, the project uses a frozen suite of
human-designed tests, three recorded Schemathesis seeds, explicit
false-positive and root-cause triage, and timeboxed exploratory sessions. Raw
failed requests are kept separate from unique defects, and defects known before
formal execution are kept separate from new findings.

## 2. Background and related work

Schema-driven API fuzzing derives requests from a machine-readable contract.
Hatfield-Dodds and Dygalo present Schemathesis as a property-based generator for
OpenAPI and GraphQL services [1]. Their evaluation of eight fuzzers on sixteen
open-source services reported broad schema compatibility and more unique
defects for Schemathesis than the next-best tool on each target. Sartaj, Ali,
and Gjøby later included Schemathesis in an industrial study spanning 17 APIs,
120 endpoints, and 14 releases [2]. Their separation of tests, failures,
potential faults, coverage, regressions, and cost supports this project's
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
project therefore reports coverage alongside confirmed root causes and
oracles, not as proof of superiority.

## 3. System under test and baseline

The system comprises a React 19 frontend, Django 5.2 and Django REST Framework
backend, JWT authentication, and PostgreSQL persistence. The application was
already implemented before this project and contained no dedicated verification
or validation infrastructure. The application baseline was frozen before formal
execution. No product defects were corrected until the human-authored,
Schemathesis, and exploratory baseline activities were completed.

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
and twelve for order creation, including parameterized input variants. Inputs were selected
from authentication, ownership, identifier, quantity, cart-state, phone,
required-field, payment-choice, and transaction-failure partitions. Although
pytest automates execution, generation and oracle design are human-authored.
The proposal used the phrase manual unit testing; in this report, manual means
human-authored rather than hand-executed. Because the cases call authenticated
API views and inspect PostgreSQL state, they are more accurately described as
deterministic API-level integration tests.

Known defects are represented as strict expected failures. This retains
executable evidence while causing unexpected correction or incorrect
classification to fail the run. Tests also inspect database state, totals,
ownership, order items, and rollback behavior rather than checking status codes
alone. pytest-django provides the transactional database isolation used by the
suite [8], while coverage.py records both line and branch execution [9].

### 4.3 Schema-driven fuzzing

drf-spectacular generates an OpenAPI 3.0.3 contract restricted to the two
experiment endpoints. Request schemas describe documented fields and
constraints, while response schemas include application and framework error
bodies. Only JSON request media is advertised. The tool supports customizable
OpenAPI generation for Django REST Framework views and serializers [6].

Schemathesis 4.22.4 runs positive, negative, coverage, and fuzzing phases with
checks for server errors, status and content-type conformance, response-schema
conformance, and negative-data rejection. A hook restores the isolated
experiment user's cart and order state before every generated call so one case
cannot empty the cart or create an order that changes the next case's reachable
behavior. Three formal seeds use a maximum of 500 fuzz examples per operation.
Schemathesis documents phase, check, example-budget, authentication, and hook
configuration through its command-line and TOML interfaces [7].

### 4.4 Exploratory testing

Exploratory work is reported separately. E-01 used a 90-minute business and
data-flow charter with Guidebook and Fed-Ex tours. A deterministic environment
captured before, checkpoint, and after database snapshots plus Django and Vite
logs. The tester chose subsequent actions from observations and completed a
debrief. E-02 used a separate 90-minute validation and misuse charter with
Couch Potato, Saboteur, and Antisocial tours. It followed checkout validation,
authentication expiry, state preservation, and punctuation handling from each
preceding observation rather than executing a fixed case list.

### 4.5 Measures and comparison controls

The primary outcome is the number of unique confirmed root causes reproduced or
discovered by each formal technique. Secondary outcomes are generated or
executed case count, raw failed cases, false classifications, fault type,
coverage where measured comparably, tool wall-clock duration, and available
human-effort estimates. A defect identity requires a distinct cause, not merely
a different malformed value or a second failed assertion. K identifiers denote
behavior known before formal execution; N identifiers denote roots first found
during valid experimental activity.

Both techniques target the same baseline revision and endpoints, but they use
the kinds of oracles for which they were designed. The manual suite inspects
persistence, ownership, totals, and transaction rollback, while Schemathesis
applies black-box response and schema properties. The difference in oracle
depth is therefore part of the comparison rather than something artificially
removed from it. The isolated manual database,
dedicated fuzz database, deterministic seed, and per-generated-case reset limit
cross-case contamination. Exploratory results are kept outside the direct
manual-versus-fuzzing count because they cover a broader frontend journey.

## 5. Verification infrastructure implementation

Separate Django settings prevent the automatically managed test database and
standalone fuzz database from matching the development database. A management
command creates two deterministic users, two products, carts, and known
quantities. Another command serializes experiment-owned cart, order, and line
state as JSON for exploratory evidence.

The manual runner erases prior coverage data, executes the frozen suite, writes
JUnit and coverage XML, produces HTML coverage, and records wall-clock time.
The coverage boundary excludes migrations, the legacy test module, and the
post-baseline exploratory snapshot command. The snapshot command was introduced
after M-01 to collect evidence and is not application functionality exercised
by the manual suite.
The Schemathesis runner obtains a fresh JWT, limits execution to the selected
paths, records the seed and budget, and saves the complete console log.

An exploratory launcher verifies that ports are free, resets only experiment
records, starts the isolated Django server and Vite frontend, waits for both
services, and writes a before snapshot. The stop workflow captures after state
and terminates only the documented Python and Node listeners. A separate
READINESS rehearsal validated service startup, authentication, CORS, snapshots,
and clean shutdown before E-01.

### 5.1 Implementation challenges and responses

Several practical problems arose during setup and execution. Preliminary code
inspection had already exposed several product defects. Fixing those defects
before the experiment would have changed the subject and made the techniques
operate on different behavior. The project therefore froze the application,
registered the issues as known K defects, and separated test instrumentation
from product corrections. As a result, the formal runs mainly reproduced known
defects rather than discovering new ones. That is still a valid outcome and is
reported without inflating the novel-defect count.

Database state was another central challenge. Cart update and order creation are
destructive operations, and a successful order empties the cart. Separate test
and fuzz databases, database-name guards, deterministic seed data, snapshots,
and per-generated-case restoration were needed both to protect development data
and to keep generated cases comparable. The reset hook increased repeatability,
but it also imposed a controlled state that does not represent every possible
production sequence.

The OpenAPI contract and test harness also needed refinement. Early Schemathesis
checks exposed inaccurate descriptions of framework 401 and parse-error bodies,
as well as incorrect request-media assumptions. These were test-setup problems
rather than application defects, so the test-only schema was corrected and the
pre-formal logs retained. A later F-01 attempt was stopped when the surrounding
command reached its time limit. Its partial log was preserved as invalid, and the run was repeated
with the same seed, schema, budget, baseline, and reset hook; only the external
allowance changed.

Triage introduced a different challenge. M-01 unexpectedly passed the proposed
K-008 malformed-item-identifier case. Investigation showed that the original
smoke evidence actually contained a valid identifier and malformed quantity,
so K-008 duplicated K-002. Rejecting the classification reduced the defect count
but improved validity. During exploration, JWT expiry interrupted intended
workflows and produced misleading empty-cart and Order failed states. Request
logs, snapshots, reauthentication, and identical retries were required to
separate authentication failure from cart loss or address punctuation.

Human effort collection was imperfect. Time for manual-suite design, fuzz
configuration, and triage was not recorded prospectively and cannot now be
reconstructed defensibly. Those values are reported as unavailable rather than
replaced with tool runtime. The complete challenge register and mitigations are
preserved in implementation-challenges.md.

## 6. Results

The principal quantitative results are summarized below. Raw failures are kept
separate from unique defects to prevent repeated manifestations from inflating
effectiveness.

| Measure | Human-authored M-01 | Schemathesis F-01 to F-03 | Exploratory E-01/E-02 |
| --- | ---: | ---: | ---: |
| Cases or actions | 20 cases | 3,252 generated cases | Adaptive journal actions |
| Unique known defects reproduced | 8 | 3 | 2 |
| Unique novel defects | 0 | 0 | 3 |
| False or rejected classifications | 1 | 0 after hardening | 1 resolved candidate and 1 non-defect observation |
| Execution or session duration | 2.88 s pytest; 8.769 s runner | 552.58 s | 180 min 13 s |
| Comparable code coverage | 64.5 percent (formal M-01 scope) | Not collected | Not collected |

### 6.1 Consolidated defect table

The table below makes the report self-contained by listing every coded finding
in the final register. A known defect is one documented before formal
experimental execution; a novel defect is one first confirmed through valid
exploratory testing. K-008 is retained only to show the audit trail: it was
rejected as a duplicate of K-002 and is not included in any defect count.

| ID | Classification | Area | Consolidated finding | Severity | Reproduced or confirmed by | Final disposition |
| --- | --- | --- | --- | --- | --- | --- |
| K-001 | Known | Cart update | An authenticated user can update another user's cart item because the item lookup does not enforce ownership. | High | Human-authored M-01 | Confirmed known defect; reproduced. |
| K-002 | Known | Cart update | A malformed, non-integer quantity is converted without safe validation and can cause HTTP 500 instead of a client error. | Medium | Human-authored M-01; Schemathesis F-01 to F-03 | Confirmed known defect; reproduced by both formal techniques. |
| K-003 | Known | Cart update | A quantity below one deletes the cart item even though the request is rejected, so an invalid request changes persistent state. | High | Human-authored M-01 | Confirmed known defect; reproduced. |
| K-004 | Known | Order creation | An omitted phone value reaches string-specific validation and causes HTTP 500 instead of a client error. | Medium | Human-authored M-01; Schemathesis F-01 to F-03 | Confirmed known defect; reproduced by both formal techniques. |
| K-005 | Known | Order creation | A non-string phone value causes HTTP 500 because its type is not checked before string-specific validation. | Medium | Human-authored M-01 | Confirmed known defect; reproduced. |
| K-006 | Known | Order creation | Checkout accepts name, address, phone, and payment method, but those details are not persisted with the order. | High | Human-authored M-01; exploratory E-01 and E-02 | Confirmed known defect; reproduced in formal and exploratory testing. |
| K-007 | Known | Order creation | Order and line-item writes are not atomic; an item-write failure can leave a partial order in the database. | High | Human-authored M-01 with an injected item-write failure | Confirmed known defect; reproduced. |
| K-008 | Rejected classification | Cart update | The proposed malformed-item-identifier failure was not distinct: the original smoke request actually contained a malformed quantity already covered by K-002. | Not applicable | M-01 investigation and smoke-evidence review | Rejected as a duplicate of K-002; not counted as a defect. |
| K-009 | Known | Order creation | Required checkout values and allowed payment choices are not consistently validated; examples included an omitted name, a 17-digit phone, and whitespace-only name or address. | High | Human-authored M-01; Schemathesis F-01 to F-03; exploratory E-02 | Confirmed known defect; reproduced by all three approaches. |
| N-001 | Novel | Frontend cart/authentication | Successful login stores the tokens and navigates home but does not refetch the user's persistent cart, leaving its items and badge hidden until a full reload. | Medium | Exploratory E-01 | Confirmed novel defect. |
| N-002 | Novel | Frontend authentication lifecycle | Expired authentication is shown as an empty cart or generic Order failed state instead of telling the user to log in again, even while persisted cart data remains. | Medium | Exploratory E-01; reproduced and extended in E-02 | Confirmed novel defect. |
| N-003 | Novel | Frontend product display | Products without images are rendered with an empty image source, producing repeated React warnings and possible unnecessary page requests. | Low | Exploratory E-01 | Confirmed novel defect. |

### 6.2 Human-authored run M-01

M-01 collected 20 cases. Nine controls passed, ten strict known-defect tests
failed as expected, and one strict expected failure unexpectedly passed. There
were no ordinary unexpected failures. Store-package combined line and branch
coverage was 64.5 percent for the formal M-01 baseline. The post-baseline
exploratory snapshot command is excluded from this boundary because it is an
evidence utility rather than application functionality evaluated by the suite.
pytest execution took 2.88 seconds and the complete runner, including reports,
took 8.769 seconds.

The unexpected pass prompted an important correction. K-008 had claimed that a
malformed item identifier produced a server error, but the selected object value
correctly received 400. Review of the earlier smoke request showed a valid item
identifier and malformed quantity, making K-008 a duplicate misclassification
of K-002. K-008 was rejected and M-01 was not repeated.

The manual suite reproduced eight unique known defects: K-001 through K-007 and
K-009. These included cross-user modification, mutation on rejected input,
unhandled types, missing checkout persistence, and non-atomic order creation.
No novel defect was confirmed by the formal manual run.

### 6.3 Formal Schemathesis runs

F-01, F-02, and F-03 each generated 1,084 cases. Across 3,252 cases, nine cases
failed fifteen raw checks in 552.58 seconds. All three seeds reduced to the same
known root causes: a malformed quantity caused a server error (K-002), a missing
phone caused a server error (K-004), and a missing name was accepted (K-009).
No new root cause was found.

An initial F-01 attempt was terminated by an external orchestration timeout and
is retained as an invalid partial artifact. The valid repeat changed only the
external process allowance, not the seed, schema, budget, baseline, or reset
hook. Earlier smoke checks exposed provisional 401 and parse-error schema
inaccuracies. Those instrumentation artifacts were corrected before formal
execution and are not counted as application failures.

### 6.4 Exploratory E-01

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

> **Figure placeholder E-01-A:** Insert the exploratory screenshot showing
> **Your cart is empty** while the interface still shows **Logout**. If the
> screenshot also contains the Network 401, retain that portion. Suggested
> caption: *Expired authentication was presented as an empty cart even though
> the database snapshot retained Table quantity 2 (N-002).*

> **Optional figure placeholder E-01-B:** Insert the browser Console screenshot
> containing the empty `src` React warning. Suggested caption: *Products without
> images caused repeated empty-source warnings (N-003).*

E-01 also reproduced known K-006. Checkout accepted name, address, phone, and
COD, returned 200, persisted order 2012 with one Table at quantity 1 and total
125.50, and cleared the cart. The final order had no persisted checkout-detail
fields. Missing cart-line subtotals and Console logging of Cart Items were
retained as usability and code-quality observations rather than inflated into
defect counts.

### 6.5 Exploratory E-02

Olaleye completed E-02 in exactly 90 minutes and estimated 30 minutes for test
design and execution and 60 minutes for investigation and evidence reporting.
The initial short-phone control, 709764, was rejected with HTTP 400 and an
Invalid Phone number message without changing the cart. In contrast, the
17-digit value 70911122299988874 produced HTTP 200, created an order, and
cleared the cart. Whitespace-only name and address values also produced
successful orders. These three symptoms were deduplicated to known K-009,
missing checkout request validation, rather than counted as novel defects.

> **Figure placeholder E-02-A:** Insert the screenshot showing **Invalid Phone
> Number** for the short or non-digit phone control, preferably with the Network
> 400 visible. Suggested caption: *The application rejected a clearly invalid
> phone and preserved the cart, providing a validation control.*

> **Figure placeholder E-02-B:** If available, insert a screenshot that shows
> the 17-digit value and the successful-order outcome together. A generic
> success popup without the entered value should be illustrative only, not the
> sole evidence for K-009; the request log and snapshot remain the proof.

A short numeric address was accepted but retained only as a domain observation
because no requirement established an address-format oracle. A phone containing
an at sign was correctly rejected. A punctuation-rich address containing an
apostrophe, period, comma, and at sign first appeared to fail with generic Order
failed, but the request was HTTP 401 after JWT expiry. After reauthentication,
the identical address succeeded. This isolated punctuation from the failure and
reproduced N-002 in checkout: authentication expiry is not presented as a clear
need to log in again. Snapshots confirmed that rejected and unauthorized calls
preserved cart state. Each successful checkout also reproduced K-006 because
the supplied customer details were absent from persisted order data.

> **Figure placeholder E-02-C:** Insert the screenshot showing **Order failed**
> and, if captured, the Network 401. Suggested caption: *An expired JWT produced
> a generic checkout failure rather than a reauthentication instruction
> (N-002 reproduction).*

E-02 confirmed no new root cause. Across E-01 and E-02, exploratory testing took
180 minutes 13 seconds, confirmed three novel defects, and reproduced two
unique known defects, K-006 and K-009. E-02 additionally reproduced the existing
novel authentication-lifecycle defect N-002.

## 7. Discussion

The primary comparison shows complementarity rather than a universal
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

Exploratory testing found three novel frontend and lifecycle defects because it
followed the visible cart-to-order journey instead of stopping at the two API
operations. Those findings do not prove that exploratory testing was superior
over the primary techniques: scope and oracles differ. E-02 added no new root
cause but strengthened the evidence for missing checkout validation and showed
how authentication expiry can mislead a tester or customer into blaming valid
address punctuation. Together, the sessions show how exploratory work adds
system-level insight into token lifecycle, navigation, rendering, and state
visibility.

The outcome also illustrates why raw counts require context. The manual suite's
eight known roots, Schemathesis's three known roots, and exploratory testing's
three novel roots arose under different scopes and oracles. The exploratory
findings are therefore reported separately, not used as a direct numerical win
over the two API techniques. Human effort for formal suite design and fuzz-tool
configuration remains an unavailable retrospective value and must be disclosed
rather than reconstructed from tool runtime.

The clearest answer to the research question is that the techniques differed in
oracle depth and in the kinds of faults they exposed. The human suite reproduced
more known backend defects with far fewer cases because it deliberately crossed
ownership boundaries and checked the database after each request. Schemathesis
found malformed-input and contract failures repeatedly without requiring each
input to be written by hand, but thousands of requests reduced to three root
causes. In practice, the techniques fit together: generation broadens the input
surface, while human-authored tests express business rules that are absent from
the response schema.

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
API endpoints, one manual suite, one fuzzing tool, three seeds, and one tester
for both exploratory sessions. Results should not be generalized into broad
rankings of manual testing, Schemathesis, or exploratory testing.

Reliability is supported by fixed revisions, dependency versions, seeds,
commands, isolated databases, per-case reset, session timestamps, server logs,
and JSON snapshots. The tester confirms that exploratory screenshots were taken,
but they have not yet been copied into the repository or indexed by filename.
The report marks the useful insertion points; until those files are added, the
technical claims rely on contemporaneous reports, request logs, snapshots, and
source confirmation. HAR was not captured, but the timestamped Django request
logs already establish the relevant 400, 401, and 200 responses. Selected E-01
and E-02 logs are explicitly unignored, while other generated artifacts require
deliberate preservation before submission.

## 9. Post-baseline correction

No functional defect correction is part of the baseline comparison. With E-02
and final triage complete, selected K and N defects may be fixed in separately
identified commits. Applicable tests should then be rerun as regression
evidence, but fixed results must not replace or be pooled with baseline results.

## 10. Conclusion

On this application, the 20 human-authored tests reproduced eight known defects
because they checked ownership, persistence, and transaction behavior directly.
Schemathesis generated 3,252 repeatable cases and exposed three known
input-contract defects across every seed, but its response-level checks did not
reveal the deeper database problems. Neither formal technique found a new root
cause. The exploratory sessions added three new user-visible frontend and
authentication-lifecycle defects and reproduced two known defects, although
their broader scope prevents a direct numerical comparison. The practical
lesson is to combine focused business-state assertions with generated contract
exploration, then use timeboxed exploratory sessions to examine user journeys
and confusing failure states that endpoint-only tests do not cover.

### 10.1 Future work

Future work should expand the endpoint sample to authentication, product,
cart-removal, and order-history operations and repeat the experiment on a second
application. Additional generators such as RESTler, RESTest, or EvoMaster would
show whether the current result is tool-specific. White-box or stateful
properties could assert database invariants after generated sequences, reducing
the present black-box oracle gap. Mutation testing could evaluate whether the
manual suite's 64.5 percent structural coverage corresponds to sensitivity to
plausible implementation faults.

The exploratory component would benefit from independent testers who have not
seen the implementation or formal findings, counterbalanced charter order, and
prospective person-minute effort records. Finally, the recorded baseline
defects can be corrected in separate commits and the existing tests converted
from expected failures to regression assertions. That follow-up would evaluate
repair completeness without rewriting the evidence reported here.

## Supplementary materials and reproducibility

This report contains the methods, findings, comparisons, challenges,
limitations, and conclusions needed to understand the study independently of
the project repository. The submitted repository provides supplementary
reproducibility material, including the executable human-authored test suite,
OpenAPI and Schemathesis configuration, exploratory-testing records, execution
logs, database snapshots, and the deduplicated defect register. These artifacts
provide an audit trail for the evidence presented in the report and allow the
study's procedures and recorded results to be independently examined.

## References

[1] Z. Hatfield-Dodds and D. Dygalo, “Deriving semantics-aware fuzzers
from Web API schemas,” in 2022 IEEE/ACM 44th International Conference on
Software Engineering: Companion Proceedings, 2022, pp. 345-346,
doi: 10.1109/ICSE-Companion55297.2022.9793781.

[2] H. Sartaj, S. Ali, and J. M. Gjøby, “REST API testing in DevOps: A
study on an evolving healthcare IoT application,” ACM Transactions on Software
Engineering and Methodology, vol. 35, no. 6, pp. 1-46, 2026,
doi: 10.1145/3765744.

[3] J. Itkonen and K. Rautiainen, “Exploratory testing: A multiple case
study,” in 2005 International Symposium on Empirical Software Engineering,
2005, pp. 84-93, doi: 10.1109/ISESE.2005.1541817.

[4] J. Itkonen, M. V. Mäntylä, and C. Lassenius, “Defect detection
efficiency: Test case based vs. exploratory testing,” in First International
Symposium on Empirical Software Engineering and Measurement, 2007, pp. 61-70,
doi: 10.1109/ESEM.2007.56.

[5] L. Inozemtseva and R. Holmes, “Coverage is not strongly correlated
with test suite effectiveness,” in Proceedings of the 36th International
Conference on Software Engineering, 2014, pp. 435-445,
doi: 10.1145/2568225.2568271.

[6] drf-spectacular, “drf-spectacular documentation.” [Online]. Available:
https://drf-spectacular.readthedocs.io/en/stable/. [Accessed: Jul. 16, 2026].

[7] Schemathesis, “Configuration.” [Online]. Available:
https://schemathesis.readthedocs.io/en/stable/configuration/. [Accessed:
Jul. 16, 2026].

[8] pytest-django, “Database access.” [Online]. Available:
https://pytest-django.readthedocs.io/en/latest/database.html. [Accessed:
Jul. 16, 2026].

[9] Coverage.py, “Branch coverage measurement.” [Online]. Available:
https://coverage.readthedocs.io/en/latest/branch.html. [Accessed: Jul. 16,
2026].
