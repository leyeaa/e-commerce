# ET-01 session record

## Identification

- Session ID: E-01
- Tester: Olaleye
- Git revision: acde2ec2a76e5f9cabbbf1b0cfaaaa46f79b00b4 plus test-only instrumentation
- Database reset identifier: E-01-before-20260715-124843.json
- Date: 2026-07-15
- Start time: 12:58:54 -02:30
- End time: 14:29:07 -02:30
- Duration target: 90 minutes
- Actual duration: 90 minutes 13 seconds
- Mission: trace the authenticated cart-to-order business and data flow
- Charter: ET-01-business-data-flow.md
- Tours: Guidebook and Fed-Ex

## Time allocation

- Setup time: began before 12:46; environment verified ready at 12:49:18 -02:30
- Test design and execution time: approximately 30 minutes
- Investigation and reporting time: approximately 60 minutes
- Setup percentage: excluded from the 90-minute timebox; approximately 3 minutes before start
- Test design and execution percentage: approximately 33.3 percent
- Investigation and reporting percentage: approximately 66.7 percent

## Coverage checklist

- [x] Authentication and session lifecycle
- [x] One-product and multi-product cart journeys
- [x] Quantity changes, removal, and re-addition
- [x] UI, API, and database totals agree
- [ ] Both displayed payment-method journeys
- [x] Checkout fields and order records agree
- [ ] Cart cleanup, refresh, back navigation, and repeat submission

## Testing journal

| Time | Action and data | Observation | Next action and rationale |
| --- | --- | --- | --- |
| 13:08:20 | Logged in as experiment_user and performed an orientation tour of the home page, navigation, product list, and browser diagnostics | Login succeeded; products showed names and prices. The upper-right cart icon did not show whether the seeded cart contained items. Products without images produced repeated React warnings that an empty string was passed to the image src attribute | Select a product and add it to the cart to learn whether cart state becomes visible and whether the displayed cart agrees with the API |
| 13:23:14 | Opened Experiment Lamp, added it to the cart, increased its quantity, inspected the cart page and Console, and captured database checkpoint E-01-after-lamp-quantity-20260715-132310.json | Product details displayed correctly. The badge appeared after the add and increased with quantity. Cart showed quantity, unit price, and one total but no observed per-line subtotal. Console continued the empty-image warning and logged the Cart Items array. Checkpoint confirmed Lamp quantity 3 at 25.00 and total 75.00, but the Table quantity 2 present in the before snapshot was absent | Clarify whether Table was intentionally removed, then add a second distinct product to learn whether the page presents line subtotals and whether the badge counts units or distinct products |
| 13:30:59 | Clarified the earlier multi-product and removal path and reviewed captured Django request evidence | Tester intentionally added Table and Lamp to confirm two products could coexist, then used each remove button to assess removal. Both operations behaved successfully. Server log records 200 for cart add, remove, refresh, and later quantity-update requests. The missing Table in the checkpoint was therefore expected | Recreate a stable two-product cart and explicitly inspect each row for unit price, quantity, subtotal, badge meaning, and grand total |
| 13:52:57 | Recreated a two-product cart, varied quantities with plus and minus controls, inspected row information, badge, and total, and captured E-01-two-product-cart-20260715-135254.json | Both products coexisted. Badge showed total units. Product name, unit price, and quantity were clear; no per-line subtotal was shown. Plus and minus controls worked in the normal range and the grand total changed accordingly. Snapshot recorded Lamp quantity 3, Table quantity 2, and grand total 326.00 | Follow the tester's question about the lower boundary by reducing one product from quantity 1 and observing response, visible feedback, persistent state, and refresh behaviour |
| 14:01:19 | Reduced Lamp to quantity 1 and clicked minus again, then captured E-01-after-first-zero-boundary-20260715-140117.json and reviewed the request log and UI handler | Lamp disappeared and the badge decreased consistently. Technical review showed the UI intentionally called POST /api/cart/remove/, which returned 200, rather than sending zero to cart update. Snapshot confirmed only Table quantity 2 remained at total 251.00. This is expected removal behaviour and does not reproduce K-003 | Apply the same path to the final product to inspect empty-cart messaging, badge state, persistence after refresh, and navigation options |
| 14:08:15 | Attempted to reduce the final Table item below one, observed an empty-cart page with no badge or checkout link, refreshed, and captured E-01-empty-cart-20260715-140814.json | UI continued to say Your cart is empty after refresh, but Django logs showed POST cart update and subsequent GET cart returned 401 after token expiry. The frontend treated the unauthorized response as empty cart data. Database snapshot proved Table still existed at quantity 2 and total 251.00 | Preserve screenshot and Network 401 evidence, re-authenticate, and revisit the cart to determine whether the hidden persistent item reappears before checkout |
| 14:19:37 | Re-authenticated successfully and navigated to the cart; also opened the update endpoint directly in the browser while investigating authorization | Token request returned 200, but no cart GET followed login and the React page remained in its stale empty state with no badge. Direct browser GET to the protected POST endpoint returned the expected unauthenticated 401 and is not an application fault | Refresh the React application after login to force CartProvider remount, then check whether the persistent Table reappears and whether one authenticated decrement behaves normally |
| 14:29:07 | Fully refreshed the authenticated frontend, reduced the restored Table from quantity 2 to 1, and completed checkout with E01 Customer, 1 Exploration Avenue, 7095550100, and COD | Reload triggered successful cart GETs and restored Table quantity 2. Authenticated decrement returned 200 and correctly showed quantity 1, badge 1, and total 125.50. Checkout returned 200, displayed Order placed successfully, cleared the badge, and redirected home. Final snapshot E-01-after-20260715-142907.json contains order 2012 with one Table at quantity 1 and total 125.50 and an empty cart. Checkout details are not persisted, independently reproducing K-006 | End the timebox, preserve evidence, and debrief before assigning N identifiers |

## Candidate faults

| Candidate ID | Summary | Minimal reproduction | Evidence | Related K ID |
| --- | --- | --- | --- | --- |
| E-01-C01 | N-001 confirmed: successful login does not refetch the persistent cart, leaving the badge and cart page in stale empty state | Begin unauthenticated, log in successfully, and inspect the badge and cart without a full application reload | Tester observations plus 14:15 token 200 with no subsequent cart GET in Django log | None; distinct trigger from N-002 |
| E-01-C02 | N-003 confirmed: missing product image is rendered with an empty src and produces repeated React warnings | Open the home page containing seeded products without image files and inspect the Console | Tester-provided warning text and ProductCard/ProductDetails render path | None |
| E-01-C03 | Usability observation, not counted as a defect: cart rows omit per-line subtotals | Create a two-product cart with quantities above one and inspect both rows | Tester observation and E-01-two-product-cart-20260715-135254.json | No requirement establishes a line subtotal oracle |
| E-01-C04 | Code-quality observation, not counted as a product defect: Cart Items is logged to the browser Console | Open the populated cart page and inspect the Console | Tester observation and CartPage console.log statement | None |
| E-01-C05 | Resolved observation: seeded Table disappeared because the tester intentionally exercised removal | Compare the two snapshots with the tester journal and Django request log | Rejected as a defect; expected user action confirmed at 13:30:59 | None identified |
| E-01-C06 | N-002 confirmed: expired authentication is silently presented as an empty cart, hiding persistent items and checkout navigation | Allow the one-hour JWT to expire, attempt a cart quantity action, and refresh the cart | UI observation, 401 request log, and E-01-empty-cart-20260715-140814.json proving Table quantity 2 remained | None; related authentication lifecycle to N-001 but distinct response-handling root cause |
| E-01-C07 | Accepted checkout identity, address, phone, and payment choice are not persisted with the successful order | Complete checkout with identifiable test values and inspect the resulting order state | Order 2012 in E-01-after-20260715-142907.json contains only user, total, and line items | K-006 |

## Debrief

- Features covered: login and token lifecycle, one- and two-product carts, add, remove, quantity boundaries, badge semantics, totals, refresh, COD checkout, redirect, order persistence, and cart cleanup.
- Main risks learned: an expired session remained visually logged in because Logout stayed visible, while unauthorized cart responses were shown as a genuine empty cart. Re-login still did not restore visible persistent state until a full frontend reload.
- Areas not covered: invalid checkout values, Online Payment, browser back after checkout, repeated order submission, and rapid repeated actions.
- Setup or testing issues: existing repository development servers occupied ports before the timebox and were replaced with the isolated environment. No infrastructure failure reduced the 90-minute session.
- Follow-up charters: prioritize missing and invalid customer details, especially phone validation, during E-02; also cover payment choices and repeated submission.
- Post-baseline regression-test ideas: cart refetch after login; explicit expired-session handling and redirect; missing-image fallback without empty src; checkout-detail persistence; cart and order state after refresh.

## Evidence index

- Screenshots: tester confirms screenshots were taken; filenames and repository
  copies are pending final report assembly. Prioritize the empty-cart/Logout and
  Console empty-src-warning images.
- HTTP requests and responses: E-01-backend-error.log, including login 200, cart 401/200, quantity 200, remove 200, and order-create 200.
- Database snapshots: E-01-before-20260715-124843.json; E-01-after-lamp-quantity-20260715-132310.json; E-01-two-product-cart-20260715-135254.json; E-01-after-first-zero-boundary-20260715-140117.json; E-01-empty-cart-20260715-140814.json; E-01-after-20260715-142907.json.
- Server or browser logs: E-01-backend.log, E-01-backend-error.log, E-01-frontend.log, and E-01-frontend-error.log.
