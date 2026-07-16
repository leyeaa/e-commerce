# Literature summary for the presentation

This document satisfies the course requirement for a one- to three-paragraph
discussion of each source used to prepare the presentation. Reference numbers
match presentation-slides.md.

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

Use the bibliography on slide 8 of presentation-slides.md without changing its
reference numbering. Metadata and DOI fields were rechecked on 2026-07-16.
