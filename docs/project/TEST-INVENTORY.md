# Submission test and known-defect inventory

This submission-facing inventory provides a readable map of the 20 collected
human-authored deterministic API cases. The executable source remains under
`backend/tests/manual/`. The final report contains the complete method,
consolidated defect table, analysis, and conclusions.

## Human-authored M-01 cases

The suite contains eight cart-update cases and twelve order-creation cases.
"Pass" means the intended control behaviour was observed. "XFAIL" means a
strict expected-failure case reproduced its mapped known defect. "XPASS" means
the expected failure did not occur; this led to rejection of K-008 rather than
counting it as a defect.

| No. | Endpoint | Pytest case | Principal oracle | Formal M-01 outcome |
| ---: | --- | --- | --- | --- |
| 1 | Cart update | `test_authentication_is_required` | Unauthenticated request returns 401 and quantity remains unchanged | Pass |
| 2 | Cart update | `test_owner_can_update_quantity` | Owner receives 200 and the new quantity persists | Pass |
| 3 | Cart update | `test_missing_quantity_is_rejected_without_state_change` | Missing quantity returns 400 without changing the cart item | Pass |
| 4 | Cart update | `test_unknown_item_is_reported_as_not_found` | Unknown item identifier returns 404 | Pass |
| 5 | Cart update | `test_user_cannot_update_another_users_item` | Cross-user update returns 403/404 and does not mutate the item | XFAIL — K-001 |
| 6 | Cart update | `test_non_integer_quantity_is_a_client_error` | Non-integer quantity returns 400 and preserves state | XFAIL — K-002 |
| 7 | Cart update | `test_zero_quantity_is_rejected_without_deleting_item` | Zero quantity returns 400 without deleting the item | XFAIL — K-003 |
| 8 | Cart update | `test_malformed_item_id_is_a_client_error` | Structured item identifier returns 400 and preserves state | XPASS — K-008 rejected |
| 9 | Order create | `test_authentication_is_required` | Unauthenticated request returns 401, creates no order, and preserves cart | Pass |
| 10 | Order create | `test_valid_order_is_created_from_cart` | Valid checkout creates the correct order/items/total and clears the cart | Pass |
| 11 | Order create | `test_empty_cart_is_rejected` | Empty cart returns 400 and creates no order | Pass |
| 12 | Order create | `test_invalid_phone_format_is_rejected[not-a-phone]` | Alphabetic phone returns 400 and preserves cart | Pass |
| 13 | Order create | `test_invalid_phone_format_is_rejected[123456789]` | Nine-digit boundary value returns 400 and preserves cart | Pass |
| 14 | Order create | `test_required_checkout_fields_are_validated[name]` | Missing name returns 400 and creates no order | XFAIL — K-009 |
| 15 | Order create | `test_required_checkout_fields_are_validated[address]` | Missing address returns 400 and creates no order | XFAIL — K-009 |
| 16 | Order create | `test_unknown_payment_method_is_rejected` | Unsupported payment choice returns 400 and creates no order | XFAIL — K-009 |
| 17 | Order create | `test_missing_phone_is_a_client_error` | Missing phone returns 400 and preserves cart | XFAIL — K-004 |
| 18 | Order create | `test_non_string_phone_is_a_client_error` | Structured non-string phone returns 400 and preserves cart | XFAIL — K-005 |
| 19 | Order create | `test_checkout_details_are_persisted` | Submitted name, address, phone, and payment method persist on the order | XFAIL — K-006 |
| 20 | Order create | `test_order_creation_rolls_back_if_an_item_cannot_be_written` | Injected second-item failure leaves no order/item writes and preserves cart | XFAIL — K-007 |

Formal M-01 therefore reported nine passes, ten expected failures, and one
strict unexpected pass. The process returned exit code 1 because pytest treats
the strict XPASS as a failure.

## Defects identified by preliminary code inspection

These seven root-cause candidates were recorded before the formal runs and
therefore could only be reproduced—not discovered as novel—by M-01,
Schemathesis, or exploratory testing.

| ID | Endpoint | Preliminary code-walkthrough observation | Human-authored evidence |
| --- | --- | --- | --- |
| K-001 | Cart update | Item lookup does not enforce authenticated-user ownership | `test_user_cannot_update_another_users_item` |
| K-002 | Cart update | A non-integer quantity can reach unhandled conversion and return HTTP 500 | `test_non_integer_quantity_is_a_client_error` |
| K-003 | Cart update | Quantity below one deletes the item before returning an error | `test_zero_quantity_is_rejected_without_deleting_item` |
| K-004 | Order create | Missing phone reaches unguarded `phone.isdigit()` and returns HTTP 500 | `test_missing_phone_is_a_client_error` |
| K-005 | Order create | A non-string phone value returns HTTP 500 | `test_non_string_phone_is_a_client_error` |
| K-006 | Order create | Checkout details are accepted but not persisted on the order | `test_checkout_details_are_persisted` |
| K-007 | Order create | Order and line-item writes are not enclosed in one atomic transaction | `test_order_creation_rolls_back_if_an_item_cannot_be_written` |

## Other candidates known before formal execution

K-008 and K-009 were recorded during the Schemathesis infrastructure smoke
phase, not during the preliminary code walkthrough.

| ID | Endpoint | Pre-formal observation | Final disposition |
| --- | --- | --- | --- |
| K-008 | Cart update | Initially classified as malformed item identifier causing HTTP 500 | Rejected after M-01: the smoke request actually contained a valid identifier and malformed quantity, duplicating K-002 |
| K-009 | Order create | Required checkout fields and payment-method choices were not validated | Confirmed by M-01 and F-01–F-03; also reproduced during E-02 |

Novel exploratory defects N-001–N-003 and the complete cross-technique defect
mapping are reported in the consolidated defect table in the final report.