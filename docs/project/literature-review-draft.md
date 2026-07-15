# Literature review draft

## Scope and selection rationale

The review covers publications that directly evaluate Schemathesis, empirical
studies of exploratory testing, and one study that qualifies the interpretation
of code coverage. Official pytest, coverage.py, OpenAPI, drf-spectacular, and
Schemathesis documentation should be cited in the implementation section, but
tool documentation is not substituted for academic evidence here.

## Schema-driven API fuzzing and Schemathesis

Hatfield-Dodds and Dygalo present Schemathesis as a property-based generator for
OpenAPI and GraphQL services. Their evaluation used eight API fuzzers, sixteen
containerized open-source services, and thirty independent runs. Schemathesis
was the only evaluated tool that handled more than two-thirds of the services
without a fatal internal error and it reported between 1.4 and 4.5 times as many
unique defects as the next-best tool for each target. The study directly
supports choosing Schemathesis and counting unique defects instead of raw
requests. Its generalizability is limited by the selected open-source services,
black-box oracles, and the fact that the peer-reviewed companion publication is
short; the associated preprint contains the fuller method and results.

Sartaj, Ali, and Gjøby evaluate Schemathesis together with RESTest, EvoMaster,
RESTler, and RestTestGen on an evolving healthcare IoT system. Their study spans
17 APIs, 120 endpoints, and 14 releases and measures failures, faults, coverage,
regressions, and cost. The tools collectively exposed 18 potential faults,
reached up to 84 percent coverage, and detected 23 regressions, while more than
70 percent of generated tests did not expose failures. This is particularly
relevant to the present protocol: generator volume is not treated as defect
count, repeated failures are deduplicated by root cause, and execution cost is
reported separately. The industrial context improves realism but one evolving
healthcare application cannot establish universal tool rankings.

Together, these studies justify schema-driven fuzzing while warning against
equating generated-case count, failed checks, code coverage, and unique faults.
The present project adopts repeated seeded runs, explicit schema and harness
validation, isolated state restoration, and root-cause triage. It differs by
comparing one generator with human-authored deterministic tests on only two
authenticated endpoints; conclusions must therefore remain local to this case
study.

## Exploratory testing

Itkonen and Rautiainen study exploratory testing through interviews with seven
practitioners in three companies. Practitioners described its advantages as
versatility, rapid formation of an overall quality picture, and suitability for
complex functionality or an end-user viewpoint. Coverage management was the
most prominent shortcoming. This supports using timeboxed charters, a journal,
coverage prompts, evidence indexing, and a debrief rather than conducting
undocumented ad hoc clicking. Because the evidence is interview-based and drawn
from three organizations, perceived benefits should not be presented as causal
proof of superior effectiveness.

Itkonen, Mäntylä, and Lassenius compare test-case-based and exploratory testing
in a controlled setting with two 90-minute sessions. Their reported results did
not establish a significant difference in defect-detection effectiveness, while
the test-case-based work generated more false defect reports in that experiment.
The paper supports equal 90-minute exploratory timeboxes and explicit tracking
of false reports. Differences in participant experience, subject system, and
experimental context limit transfer to this e-commerce application, so the
present project reports exploratory testing as an additional method rather than
folding it into the primary manual-versus-fuzzing comparison.

## Coverage as supporting evidence

Inozemtseva and Holmes generated 31,000 suites for five Java systems of up to
724,000 lines and used mutation testing to estimate effectiveness. After test
suite size was controlled, statement, decision, and modified-condition coverage
had only low-to-moderate correlation with effectiveness, and stronger coverage
forms did not provide greater insight. This project therefore reports line and
branch coverage as context about exercised code, not as proof that one technique
is better or that the application is well verified. The study concerns Java
systems and mutation-based effectiveness, so it does not directly predict the
relationship for this small Python API case study.

## Verified IEEE-style working references

[1] Z. Hatfield-Dodds and D. Dygalo, 'Deriving semantics-aware fuzzers
from Web API schemas,' in 2022 IEEE/ACM 44th International Conference on
Software Engineering: Companion Proceedings, 2022, pp. 345-346,
doi: 10.1109/ICSE-Companion55297.2022.9793781.

[2] H. Sartaj, S. Ali, and J. M. Gjøby, 'REST API testing in DevOps: A
study on an evolving healthcare IoT application,' ACM Transactions on Software
Engineering and Methodology, 2025, doi: 10.1145/3765744.

[3] J. Itkonen and K. Rautiainen, 'Exploratory testing: A multiple case
study,' in 2005 International Symposium on Empirical Software Engineering,
2005, pp. 84-93, doi: 10.1109/ISESE.2005.1541817.

[4] J. Itkonen, M. V. Mäntylä, and C. Lassenius, 'Defect detection
efficiency: Test case based vs. exploratory testing,' in First International
Symposium on Empirical Software Engineering and Measurement, 2007, pp. 61-70,
doi: 10.1109/ESEM.2007.56.

[5] L. Inozemtseva and R. Holmes, 'Coverage is not strongly correlated
with test suite effectiveness,' in Proceedings of the 36th International
Conference on Software Engineering, 2014, pp. 435-445,
doi: 10.1145/2568225.2568271.

Final formatting must be checked against the instructor's required IEEE variant
and the accessible publisher records when the report bibliography is assembled.
