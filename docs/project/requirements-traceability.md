# Course requirements traceability

Source requirements were re-read from ENGI_9839_Course_Project.pdf and the
commitments from ENGI9839_Project_Proposal_Final_Submission.pdf on 2026-07-16.

| Requirement or commitment | Repository evidence | Status / final human gate |
| --- | --- | --- |
| Approved verification/testing topic | Proposal PDF and report Sections 1–2 | Complete |
| Existing system or case study permitted | Baseline application and report Section 3 | Complete |
| Practical implementation component | pytest suite, Schemathesis configuration, OpenAPI instrumentation, scripts, exploratory tooling | Complete |
| Source code and relevant artifacts | backend tests/scripts/settings plus docs/project evidence | Complete; stage and push intentionally |
| Clear run instructions | docs/project/README.md and collaborator setup checker | Complete |
| Sample output or results | docs/project/results/README.md, logs, XML, snapshots, report Section 6 | Complete |
| Brief implementation explanation and findings | Report Sections 5–7 | Complete |
| Instructor-requested implementation challenges | implementation-challenges.md and Report Section 5.1 | Complete; retain difficulties and residual limitations rather than presenting an unrealistically smooth process |
| Manual unit/API testing with pytest-django | M-01 design, executable tests, log, and coverage artifacts | Complete |
| Automated API fuzzing with Schemathesis and OpenAPI | F-01 to F-03, schema instrumentation, hooks, and logs | Complete |
| Dedicated isolated databases | backend.settings_test, backend.settings_fuzz, safety scripts | Complete |
| Compare defects, coverage, effort, and fault type | protocol, metrics, comparison table, report Sections 6–7 | Complete except unavailable retrospective formal human-effort values must remain disclosed |
| Additional exploratory testing | E-01 and E-02 charters, journals, debriefs, logs, snapshots, and indexed E-02 screenshots | Complete |
| Report at least 12 pages, maximum 12-point font | report-draft.md and final/ENGI9839_Course_Project_Final_Report.docx | Word export verified at 20 pages and maximum rendered font of 12 point; insert selected screenshots at marked placeholders and perform final visual review |
| IEEE citations for all sources | report bibliography and literature files | Metadata verified; visually check final export |
| Approximately 6-minute presentation plus 2-minute Q&A | presentation-slides.md and final/ENGI9839_Course_Project_Presentation.pptx | Eight-slide PPTX verified; timed rehearsal remains |
| Submit slide copy with citations and IEEE bibliography | final/ENGI9839_Course_Project_Presentation.pptx, slide 8 | Export complete; final human review and submission remain |
| One-to-three-paragraph summary of each presentation source | presentation-literature-summary.md | Complete |

## Non-negotiable final checks

1. Do not claim that 3,252 generated cases equal 3,252 defects.
2. Do not count K defects as novel or K-008 as confirmed.
3. Keep exploratory findings separate from the primary two-endpoint comparison.
4. Do not invent missing human-effort measurements; disclose their absence.
5. Do not replace baseline evidence with results from any corrected version.
6. Confirm the exported report is at least 12 pages and uses no font larger
   than 12 point where the requirement applies.
