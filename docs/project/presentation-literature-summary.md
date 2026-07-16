# Literature summary for the presentation

This document discusses the five academic sources used to prepare the
presentation. Reference numbers match the slide deck and the complete IEEE
bibliography at the end of this summary.

## [1] Hatfield-Dodds and Dygalo

Hatfield-Dodds and Dygalo describe Schemathesis as a semantics-aware,
property-based fuzzer derived from OpenAPI or GraphQL schemas. Their evaluation
used eight API fuzzers, sixteen containerized open-source services, and thirty
runs. Schemathesis handled more targets without fatal internal errors and found
more unique defects than the next-best tool on each target. This source supports
our selection of Schemathesis, seeded repetition, and the decision to compare
unique root causes rather than raw generated requests. Its short companion-paper
format and selected open-source subjects limit generalization to our Django case.

## [2] Sartaj, Ali, and Gjøby

This industrial study compares RESTest, EvoMaster, Schemathesis, RESTler, and
RestTestGen on 17 APIs, 120 endpoints, and 14 releases of an evolving healthcare
IoT application. It separates generated tests from failures, potential faults,
coverage, regressions, and cost. The tools collectively exposed 18 potential
faults, reached up to 84 percent coverage, and identified 23 regressions. It is
especially relevant because it shows why generated volume and raw failures must
not be reported as unique defects. The single healthcare context means its tool
ranking cannot automatically be transferred to our e-commerce application.

## [3] Itkonen and Rautiainen

Itkonen and Rautiainen interviewed seven testing practitioners across three
companies about exploratory testing. Participants emphasized versatility,
rapid learning, complex-function testing, and the end-user perspective, while
coverage management emerged as a major weakness. This evidence motivated our
use of explicit charters, tour prompts, journals, evidence indexes, timeboxes,
and debriefs instead of undocumented ad hoc clicking. Because the results are
practitioner perceptions from a small multiple-case study, they do not prove
that exploratory testing is causally superior.

## [4] Itkonen, Mäntylä, and Lassenius

This controlled study compared test-case-based and exploratory manual testing
in 90-minute sessions. It did not establish a statistically significant
difference in defect-detection effectiveness in that setting, while the
test-case-based condition produced more false defect reports. The study
supports our equal exploratory timeboxes and explicit candidate rejection and
deduplication. Differences in participant population, application, experience,
and protocol mean that its result should not be treated as a universal ranking.

## [5] Inozemtseva and Holmes

Inozemtseva and Holmes generated 31,000 suites for five Java systems of up to
724,000 lines and evaluated effectiveness with mutation testing. After
controlling for suite size, statement, decision, and modified-condition coverage
showed only low-to-moderate correlation with effectiveness, and stronger
coverage forms did not provide greater insight. We therefore report the manual
suite's 64.5 percent coverage as supporting execution evidence, not proof of
superior quality. The Java and mutation-testing context differs from this small
Python API experiment.

## Complete IEEE bibliography

[1] Z. Hatfield-Dodds and D. Dygalo, "Deriving semantics-aware fuzzers from
Web API schemas," in *2022 IEEE/ACM 44th International Conference on Software
Engineering: Companion Proceedings*, 2022, pp. 345-346,
doi: 10.1109/ICSE-Companion55297.2022.9793781.

[2] H. Sartaj, S. Ali, and J. M. Gjøby, "REST API testing in DevOps: A study
on an evolving healthcare IoT application," *ACM Transactions on Software
Engineering and Methodology*, vol. 35, no. 6, pp. 1-46, 2026,
doi: 10.1145/3765744.

[3] J. Itkonen and K. Rautiainen, "Exploratory testing: A multiple case study,"
in *2005 International Symposium on Empirical Software Engineering*, 2005,
pp. 84-93, doi: 10.1109/ISESE.2005.1541817.

[4] J. Itkonen, M. V. Mäntylä, and C. Lassenius, "Defect detection efficiency:
Test case based vs. exploratory testing," in *First International Symposium on
Empirical Software Engineering and Measurement*, 2007, pp. 61-70,
doi: 10.1109/ESEM.2007.56.

[5] L. Inozemtseva and R. Holmes, "Coverage is not strongly correlated with
test suite effectiveness," in *Proceedings of the 36th International Conference
on Software Engineering*, 2014, pp. 435-445,
doi: 10.1145/2568225.2568271.

Metadata and DOI fields were rechecked on 2026-07-16. Reference numbering
matches the presentation slide deck.
