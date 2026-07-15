# Literature review evidence matrix

Metadata was checked against paper, institutional, publisher, or bibliographic
records on 2026-07-15. The critical prose synthesis is maintained in
literature-review-draft.md. Official tool documentation belongs in the
implementation references but does not replace these academic publications.

| Source | Method and subjects | Relevance | Measures and findings | Limitation and project use |
| --- | --- | --- | --- | --- |
| Hatfield-Dodds and Dygalo, ICSE Companion, 2022, pp. 345-346, doi: 10.1109/ICSE-Companion55297.2022.9793781 | Thirty runs of eight fuzzers on sixteen containerized open-source web services | Introduces and evaluates Schemathesis | Service compatibility and unique defects; Schemathesis handled more than two-thirds of targets and found 1.4 to 4.5 times the unique defects of the next-best tool per target | Short companion paper and selected open-source targets limit generalization; supports seeded runs and root-cause counts |
| Sartaj, Ali, and Gjøby, ACM TOSEM, 2025, doi: 10.1145/3765744 | Five REST API tools on 17 APIs, 120 endpoints, and 14 releases of a healthcare IoT system | Includes Schemathesis in an industrial regression study | Failures, faults, coverage, regressions, and cost; 18 potential faults, up to 84 percent coverage, 23 regressions, and more than 70 percent of tests exposing no failure | One application domain; supports separate reporting of volume, faults, coverage, regressions, and cost |
| Itkonen and Rautiainen, ISESE, 2005, pp. 84-93, doi: 10.1109/ISESE.2005.1541817 | Interviews with seven practitioners in three companies | Empirical exploratory-testing practice | Versatility and rapid learning were perceived benefits; coverage management was a central weakness | Interview evidence does not prove causal superiority; supports charters, journals, coverage prompts, and debriefs |
| Itkonen, Mäntylä, and Lassenius, ESEM, 2007, pp. 61-70, doi: 10.1109/ESEM.2007.56 | Controlled comparison using two 90-minute testing sessions | Test-case-based versus exploratory testing | No significant defect-detection difference reported; test-case-based work generated more false reports in that experiment | Participant and subject context limit transfer; supports equal timeboxes and false-report tracking |
| Inozemtseva and Holmes, ICSE, 2014, pp. 435-445, doi: 10.1145/2568225.2568271 | 31,000 suites over five Java systems up to 724,000 lines, evaluated with mutation testing | Interpretation of structural coverage | Only low-to-moderate correlation after suite size was controlled; stronger coverage forms gave no greater insight | Java and mutation context differ; coverage is reported as context, not the primary effectiveness outcome |

## Extraction completeness

| Source | Problem | Subjects | Method | Metrics | Findings | Limitations | Project connection |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Hatfield-Dodds and Dygalo | Complete | Complete | Complete | Complete | Complete | Complete | Complete |
| Sartaj, Ali, and Gjøby | Complete | Complete | Complete | Complete | Complete | Complete | Complete |
| Itkonen and Rautiainen | Complete | Complete | Complete | Complete | Complete | Complete | Complete |
| Itkonen, Mäntylä, and Lassenius | Complete | Complete | Complete | Complete | Complete | Complete | Complete |
| Inozemtseva and Holmes | Complete | Complete | Complete | Complete | Complete | Complete | Complete |

Before final submission, reconcile bibliography punctuation, capitalization,
and online-access fields with the instructor's required IEEE reference style.
