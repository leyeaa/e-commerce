# ET-02 session record

Status: complete and debriefed by Olaleye on 2026-07-16.

## Identification

- Session ID: E-02
- Tester: Olaleye
- Git revision: acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4 plus test-only instrumentation
- Database reset identifier: E-02-before-20260716-095958.json
- Date: 2026-07-16
- Start time: 10:05:33 -02:30
- End time: 11:35:33 -02:30
- Duration target: 90 minutes
- Actual duration: 90 minutes
- Mission: probe validation, authorization, state safety, and misuse handling
- Charter: ET-02-validation-misuse.md
- Tours: Couch Potato, Saboteur, and Antisocial

## Tester-selected starting direction

Olaleye requested that E-02 begin by investigating whether checkout can proceed
when valid customer details are not supplied, especially invalid, missing,
blank, short, non-digit, and structurally non-string phone values. This is a
starting direction rather than a fixed script; observations during execution
determine subsequent tests.

Do not consult known-defects.md or the formal results immediately before the
session. Candidate observations must be journaled before post-session matching
to K identifiers.

## Time allocation

- Setup time: environment verified ready at 10:00:54 -02:30 before the timebox
- Test design and execution time: 30 minutes
- Investigation and reporting time: 60 minutes
- Setup percentage: excluded from the 90-minute session
- Test design and execution percentage: 33.3 percent
- Investigation and reporting percentage: 66.7 percent

## Coverage checklist

- [x] Missing-value variants through whitespace-only name and address
- [ ] Cross-type values including arrays, objects, and booleans
- [ ] Quantity boundaries and extreme values
- [ ] Unknown and cross-user identifiers
- [x] Expired authentication during checkout
- [ ] Empty cart and incorrectly ordered actions
- [ ] Repeated submission and rapid repeated actions
- [x] Persistent cart state after rejected phone and expired-auth requests

## Testing journal

| Time | Action and data | Observation | Next action and rationale |
| --- | --- | --- | --- |
| 10:15:06 | Submitted checkout with valid-looking name and address and short phone 709764 | Browser sent POST orders/create. API returned 400 and UI displayed Invalid Phone number. Snapshot E-02-short-phone-rejected-20260716-101502.json confirmed no order, Table quantity 2, and total 251.00, so rejection preserved state | Explore the tester-selected opposite phone-length boundary using an excessively long digit string and observe validation, order creation, and cart state |
| 10:22:10 | Submitted checkout with 17-digit phone 70911122299988874 and otherwise valid-looking details | No effective maximum prevented submission. API returned 200, UI displayed order placed successfully, redirected home, and cleared visible cart state. Snapshot E-02-long-phone-accepted-20260716-102208.json confirmed order 2013 with Table quantity 2 and total 251.00 and an empty cart | Tester proposed a two-letter name; refine the oracle because short real names exist, then use an unambiguously invalid whitespace-only name with a fresh cart item |
| 10:32:34 | Added Experiment Lamp and submitted checkout with three spaces as name, valid phone 7095550100, and valid-looking address | Browser required validation accepted the visually blank name. API returned 200, order placed successfully was displayed, and the cart cleared. Snapshot E-02-whitespace-name-accepted-20260716-103232.json confirmed order 2014 with Lamp quantity 1 and total 25.00 | Tester proposed a short numeric address; distinguish exploratory domain suspicion from a strong oracle and prefer whitespace-only address for an unambiguous missing-value test |
| 10:40:39 | Added Experiment Table and submitted checkout with three spaces as address and otherwise valid-looking fields | Browser required validation accepted the visually blank address. API returned 200, order placed successfully was displayed, and the cart cleared. Snapshot E-02-whitespace-address-accepted-20260716-104038.json confirmed order 2015 with Table quantity 1 and total 125.50 | Continue with the tester-selected short numeric address, but classify it as domain/usability evidence unless a stronger stated address-format oracle exists |
| 10:50:12 | Added Experiment Lamp and submitted checkout with address 12 and otherwise valid-looking fields | Browser and API accepted the non-empty numeric string. API returned 200, checkout succeeded, redirected home, and cleared the cart. Snapshot E-02-numeric-address-accepted-20260716-105011.json confirmed order 2016 with Lamp quantity 1 and total 25.00 | Retain as a domain-validation observation because no address-format requirement was established; next test a phone-length value containing a special character to isolate digit validation |
| 10:57:57 | Added Experiment Lamp and submitted checkout with phone 70955@0100 and valid-looking name and address | Browser sent the request. API returned 400 and UI displayed Invalid Phone Number. Snapshot E-02-special-phone-rejected-20260716-105755.json confirmed no new order and preserved Lamp quantity 2 with total 50.00 | Use the retained cart for a legitimate punctuation-rich address control, including apostrophe, period, and at sign, and observe transport and checkout stability |
| 11:15:36 | Replaced the phone with a valid value and attempted checkout using address 12 St. John's Road, Apt @ 2 | Request returned 401 after JWT expiry and UI displayed generic Order failed rather than requesting reauthentication. Snapshot E-02-punctuation-address-auth-expired-20260716-111534.json confirmed no new order and preserved Lamp quantity 2 with total 50.00, so the address was not evaluated | Treat as a reproduction/extension of N-002, re-authenticate and fully reload because of N-001, then retry the identical address with fresh authentication |
| 11:29:47 | Re-authenticated, used the existing Lamp quantity 2 cart, and retried checkout with address 12 St. John's Road, Apt @ 2 and otherwise valid-looking fields | Fresh authentication and full reload produced successful cart GETs. Clicking the badge later reused current state without another GET. Checkout returned 200, displayed order placed successfully, redirected home, and cleared the cart. Snapshot E-02-punctuation-address-accepted-20260716-112943.json confirmed order 2017 with Lamp quantity 2 and total 50.00 | Treat punctuation handling as a successful robustness control, stop active testing near the 90-minute boundary, and use remaining time for debrief |

## Candidate faults

| Candidate ID | Summary | Minimal reproduction | Evidence | Related K ID |
| --- | --- | --- | --- | --- |
| E-02-C01 | Checkout accepts a phone longer than the documented 15-digit maximum | Submit a non-empty cart with phone 70911122299988874 and otherwise valid-looking fields | HTTP 200 request log and E-02-long-phone-accepted-20260716-102208.json | K-009: additional symptom of missing checkout request validation |
| E-02-C02 | Checkout accepts a whitespace-only customer name | Submit a non-empty cart with name containing three spaces and otherwise valid-looking fields | HTTP 200 request log and E-02-whitespace-name-accepted-20260716-103232.json | K-009: additional symptom of missing checkout request validation |
| E-02-C03 | Checkout accepts a whitespace-only customer address | Submit a non-empty cart with address containing three spaces and otherwise valid-looking fields | HTTP 200 request log and E-02-whitespace-address-accepted-20260716-104038.json | K-009: additional symptom of missing checkout request validation |
| E-02-C04 | Observation: checkout accepts short numeric address 12 | Submit a non-empty cart with address 12 and otherwise valid-looking fields | HTTP 200 request log and E-02-numeric-address-accepted-20260716-105011.json | Non-defect observation: no established address-format oracle |
| E-02-C05 | Expired checkout authentication is shown as generic Order failed instead of a reauthentication instruction | Allow JWT to expire and submit otherwise valid checkout | 401 request log and E-02-punctuation-address-auth-expired-20260716-111534.json proving cart persistence | N-002 reproduction and checkout-specific extension |

## Debrief

- Features covered: checkout field validation, rejected-request state safety,
  expired authentication during checkout, and punctuation-rich address handling.
- Main risks learned: the most surprising result was successful ordering with
  an unnecessarily long 17-digit phone number. The most confusing result was
  the generic Order failed message after authentication expired; without a
  re-login instruction, a customer could wrongly attribute the failure to the
  address or another entered value.
- Areas not covered: structured JSON types, quantity and identifier extremes,
  cross-user identifiers, empty-cart ordering, rapid repeated submission, and
  invalid payment choices. These are objective charter coverage gaps rather
  than additional statements attributed to the tester.
- Setup or testing issues: JWT expiry interrupted the first punctuation-address
  control. Reauthentication allowed the identical address to succeed, isolating
  the failure from address punctuation.
- Follow-up charters: authentication-expiry recovery and repeated checkout
  submission under slow or interrupted responses.
- Post-baseline regression-test ideas: reject phones longer than 15 digits;
  trim and reject whitespace-only names and addresses; map checkout 401
  responses to a clear reauthentication flow while retaining cart state.

## Evidence index

- Screenshots: eight named files are preserved under
  docs/project/results/exploratory/screenshots/. Prioritize the short-phone
  rejection, long-phone acceptance, and expired-authentication images for the
  report; the punctuation-address success image is the reauthentication control.
- HTTP requests and responses: docs/project/results/exploratory/E-02-backend.log
- Database snapshots: E-02-before-20260716-095958.json; all eight named action
  snapshots in the journal; E-02-after-20260716-113028.json.
- Server or browser logs: E-02-backend.log, E-02-backend-error.log,
  E-02-frontend.log, and E-02-frontend-error.log.
