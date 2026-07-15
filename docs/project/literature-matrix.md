# Literature review working matrix

The final report must synthesize these works by method, evidence, limitations,
and relationship to this experiment. Official tool documentation belongs in the
implementation references but does not replace academic literature.

| Source | Method and system | Tool or technique relevance | Measures | Result to evaluate critically | Connection to this project |
|---|---|---|---|---|---|
| Z. Hatfield-Dodds and D. Dygalo, Deriving Semantics-Aware Fuzzers from Web API Schemas, 2021. https://arxiv.org/abs/2112.10328 | Evaluation of eight fuzzers on sixteen open-source web services | Introduces and evaluates Schemathesis | Service compatibility, unique defects, repeated runs | Schemathesis handled more target schemas and found more unique defects than comparison tools in that study | Justifies schema-driven fuzzing and reproducible defect counts |
| H. Sartaj, S. Ali, and J. M. Gjøby, REST API Testing in DevOps: A Study on an Evolving Healthcare IoT Application, ACM TOSEM, 2025. https://doi.org/10.1145/3765744 | Industrial study of seventeen APIs across fourteen releases | Uses Schemathesis and four other REST API testing tools | Failures, faults, coverage, regressions, cost | Tools produced duplicate and non-fault-revealing tests as well as confirmed faults | Supports deduplication, coverage, and effort metrics |
| J. Itkonen and K. Rautiainen, Exploratory Testing: A Multiple Case Study, ISESE, 2005. https://doi.org/10.1109/ISESE.2005.1541817 | Interviews and observations across three companies | Exploratory testing in industry | Usage reasons, perceived benefits, effort and defect observations | Versatility and rapid learning were benefits; coverage management was a weakness | Supports session charters, tracking, and debrief evidence |
| J. Itkonen, M. V. Mantyla, and C. Lassenius, Defect Detection Efficiency: Test Case Based vs. Exploratory Testing, ESEM, 2007. https://doi.org/10.1109/ESEM.2007.56 | Controlled experiment with two ninety-minute testing sessions | Test-case-based versus exploratory testing | Defects, efficiency, type, severity, false reports | No significant defect-detection difference; test-case-based work produced more false reports in that experiment | Informs separate reporting of exploratory and deterministic testing |
| L. Inozemtseva and R. Holmes, Coverage Is Not Strongly Correlated with Test Suite Effectiveness, ICSE, 2014. https://doi.org/10.1145/2568225.2568271 | 31,000 suites over five Java systems with mutation-based effectiveness | Coverage as an adequacy metric | Statement, decision, condition coverage and effectiveness | Coverage had only low-to-moderate correlation with effectiveness after suite size was controlled | Supports treating coverage as context rather than the main outcome |

## Extraction prompts for each source

For the required one-to-three-paragraph source summary, capture:

1. Research problem and motivation.
2. System or dataset studied.
3. Experimental method and tools.
4. Metrics and principal findings.
5. Threats to validity and limitations.
6. What is adopted, changed, or challenged in this project.

Verify final bibliographic metadata against the publisher record and format every
entry in IEEE style before submission.
