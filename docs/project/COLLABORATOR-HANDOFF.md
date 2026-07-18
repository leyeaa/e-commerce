# Final report and presentation review handoff

Last updated: 2026-07-16

## Purpose

The formal human-authored run, three formal Schemathesis runs, and both required
exploratory sessions are complete. This handoff is for final peer review of the
report, presentation, citations, and selected screenshot placement. It replaces
the earlier E-02 execution handoff; E-02 must not be repeated as a replacement
result.

## Authoritative review files

- docs/project/final/ENGI9839_Course_Project_Final_Report.docx: generated
  22-page report review candidate with the full consolidated defect table.
- docs/project/report-draft.md: authoritative report content used by the Word
  exporter.
- docs/project/final/ENGI9839_Course_Project_Presentation.pptx: verified
  eight-slide presentation with notes on slides 1-7.
- docs/project/presentation-slides.md: timed slide wording and speaking notes.
- docs/project/presentation-literature-summary.md: required source-by-source
  presentation literature discussion.
- docs/project/final/ENGI9839_Presentation_Literature_Summary.docx: standalone
  literature-summary submission candidate with complete IEEE bibliography.
- docs/project/requirements-traceability.md: course requirement mapping.
- docs/project/implementation-status.md: authoritative completion status.
- docs/project/evidence-index.md: claim-to-evidence map.
- docs/project/results/exploratory/screenshots/: named E-02 screenshots.

The locally ignored file ENGI9839_Course_Project_Final_Report_updated.docx is
not authoritative. It incorrectly states that Chiemerie conducted E-02. The
journals, logs, snapshots, and report source establish that Olaleye conducted
both E-01 and E-02.

## Facts that must remain consistent

- Formal scope: POST /api/cart/update/ and POST /api/orders/create/.
- Human-authored M-01: 20 cases, 9 passing controls, 10 strict expected
  failures, 1 unexpected pass, 8 unique known roots reproduced, and 0 novel
  roots.
- K-008 was rejected as a mistaken duplicate classification; it was not fixed
  and must not be counted.
- Schemathesis F-01 to F-03: 3,252 generated cases, 9 failing cases, 15 raw
  failed checks, 3 unique known roots reproduced, and 0 novel roots.
- Schemathesis reproduced K-002, K-004, and K-009.
- Human-authored tests reproduced K-001 through K-007 and K-009.
- Exploratory E-01 and E-02 totalled 180 minutes 13 seconds and are reported
  separately from the primary formal comparison.
- Olaleye conducted and debriefed E-01 and E-02.
- Formal human-effort measurements were not recorded prospectively and must
  remain disclosed as unavailable.
- Product defects were intentionally left unfixed on the frozen baseline.

## Requested report review

1. Check that the research question, methodology, results, discussion, threats
   to validity, challenges, and conclusion tell one consistent story.
2. Confirm that known roots are not described as novel and raw generated
   requests or failed checks are not described as defects.
3. Review the clarification that "manual" means human-authored test design;
   pytest performed the execution, and the cases are technically API-level
   integration tests.
4. Review IEEE citations and confirm that each literature claim is supported by
   its cited source.
5. Confirm that exploratory findings remain separate from the two-endpoint
   formal comparison.
6. Review the selected screenshot placements and captions. The best E-02 report
   figures are:
   - E-02-short-phone-rejected-ui.png for the rejection control;
   - E-02-long-phone-accepted-ui.png for the excessive-phone finding;
   - E-02-punctuation-address-auth-expired-ui.png for the misleading
     Order failed behaviour; and
   - E-02-punctuation-address-accepted-ui.png as the reauthentication control.
   Backend logs and database snapshots establish the associated 400/401/200
   statuses and state changes when those details are not visible in the image.
7. After screenshots are inserted, update all Word fields with Ctrl+A, F9 and
   inspect pagination, captions, table layout, and image readability.

E-01 screenshots were reported as taken but are not currently present in the
repository. Their absence does not invalidate the findings because the indexed
Django logs, source confirmation, tester journal, and database snapshots provide
the technical evidence. If Olaleye supplies them later, use only the marked
E-01 figure positions.

## Requested presentation review

1. Confirm that slides 1-7 can be delivered in approximately six minutes.
2. Check that slide 3 distinguishes request volume, failing cases, failed
   checks, and unique root causes.
3. Check that slide 4 visibly shows the formal overlap: human-authored K-001
   through K-007 and K-009; Schemathesis K-002, K-004, and K-009.
4. Check that slide 6 visibly presents implementation challenges and limits.
5. Confirm that exploratory findings are not presented as part of the formal
   defect-count denominator.
6. Confirm that slide 8 contains the complete IEEE bibliography.
7. Record speaking ownership and complete at least two timed rehearsals.

## Review workflow

Use a separate branch or provide comments before rewriting evidence-backed
numbers. Do not rerun formal tests as replacement evidence, fix baseline product
behaviour, invent missing effort values, or overwrite preserved logs. Suggested
review comments should identify the file, section or slide, proposed change, and
reason.

After review, the remaining submission gates are screenshot insertion and Word
layout inspection, timed presentation rehearsal, submission of the exported literature summary, and preservation of the final
commit hash.