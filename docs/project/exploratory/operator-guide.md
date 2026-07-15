# Guided exploratory-testing operator guide

## Purpose and division of responsibility

The tester performs the exploration: observe the product, choose the next test,
explain the reason for that choice, and decide whether behaviour is suspicious.
Codex may reset data, start services, capture HTTP and database evidence, help
form a minimal reproduction, and facilitate the debrief. Codex must not invent
the tester journal or replace exploration with a predetermined script.

## Before each session

1. Close other services using ports 8000 or 5173.
2. Open PowerShell at the repository root.
3. Start the selected session environment:

       cd backend
       .\scripts\start_exploratory_environment.ps1 -SessionId E-01

   Use E-02 for the second charter. The command resets the isolated experiment
   records, starts Django and React, and writes the initial database snapshot.
4. Open http://127.0.0.1:5173/ in a browser.
5. Open browser developer tools, select Network, and enable Preserve log.
6. Open the matching session record and fill in tester, date, start time, and
   database reset identifier before beginning the 90-minute timebox.

## Deterministic accounts

- Primary user: experiment_user
- Second user: experiment_other_user
- Course-project-only password for both:
  CourseProject-Only-Password-Change-Me

These accounts exist only in the isolated experiment database. Do not use
personal credentials or personal data during testing.

## During the session

- Follow the mission and tours in the selected charter, but do not treat the
  suggested coverage list as a sequence of scripted test cases.
- Add a journal entry whenever the direction changes. Record the timestamp,
  action and data, observation, and why the observation motivated the next
  action.
- For a suspected fault, record the smallest known reproduction, visible
  outcome, expected outcome, and whether persistent state changed.
- Save useful screenshots and exported HTTP evidence with the session ID and a
  sequence number, for example E-01-03-cart-total.png.
- Do not assign a new N defect ID during the session. Use candidate labels such
  as E-01-C01 until post-session comparison with known-defects.md.
- If the application or testing environment becomes unavailable, record the
  interruption and time lost. Infrastructure failures are not product defects.

An additional database snapshot can be captured without resetting the session:

    .\scripts\capture_exploratory_snapshot.ps1 -SessionId E-01 -Label checkpoint-1

## Session completion

1. Stop at 90 minutes even if unexplored ideas remain; record those ideas under
   follow-up charters.
2. Record the end time and allocate time among setup, design and execution, and
   investigation and reporting.
3. Complete the debrief before consulting the formal manual or fuzz results.
4. Capture final state and stop both services:

       .\scripts\stop_exploratory_environment.ps1 -SessionId E-01

5. Index screenshots, HTTP captures, database snapshots, and logs in the
   session record.
6. Review each candidate against known-defects.md only after the debrief.

## Evidence locations

- Session record: docs/project/exploratory/E-01-session.md or E-02-session.md
- Database snapshots: docs/project/results/exploratory/
- Backend and frontend logs: docs/project/results/exploratory/
- Candidate and confirmed defect register: docs/project/defect-log.csv

## Bias disclosure

The project owner has already seen summaries of preliminary manual and fuzz
findings. The report must disclose this prior exposure as a threat to exploratory
independence. During each session, avoid opening known-defects.md or the formal
results summary until the charter and debrief are complete.
