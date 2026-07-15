# Preliminary known-defect register

These issues were identified by code inspection before experimental execution.
They must not be claimed as novel discoveries by any testing technique.

| ID | Endpoint | Preliminary observation | Evidence test |
|---|---|---|---|
| K-001 | Cart update | Item lookup does not enforce authenticated-user ownership. | test_user_cannot_update_another_users_item |
| K-002 | Cart update | A non-integer quantity can cause an unhandled server error. | test_non_integer_quantity_is_a_client_error |
| K-003 | Cart update | Quantity below one deletes the item while returning an error. | test_zero_quantity_is_rejected_without_deleting_item |
| K-004 | Order creation | Missing phone reaches phone.isdigit and returns a server error. | test_missing_phone_is_a_client_error |
| K-005 | Order creation | A non-string phone value returns a server error. | test_non_string_phone_is_a_client_error |
| K-006 | Order creation | Name, address, phone, and payment method are accepted but not persisted. | test_checkout_details_are_persisted |
| K-007 | Order creation | Order and item writes are not enclosed in one atomic transaction. | test_order_creation_rolls_back_if_an_item_cannot_be_written |
| K-008 | Cart update | Rejected candidate: the smoke evidence was a malformed quantity duplicate of K-002, not a malformed item identifier defect. | test_malformed_item_id_is_a_client_error |
| K-009 | Order creation | Required checkout fields and payment-method choices are not validated. | test_required_checkout_fields_are_validated |

## Interpretation

K-001 through K-007 came from preliminary code inspection. K-008 and K-009 were
recorded during the Schemathesis infrastructure smoke run. Formal M-01 produced
an unexpected pass for the K-008 test, and review of the original request showed
that K-008 was a mistaken duplicate classification of K-002. K-008 is rejected,
not counted as a defect, and retained here as an audit trail. K-009 remains
excluded from the formal novel-defect count.

The human-authored tests mark these cases as strict expected failures. If a
technique reproduces one, record it as confirmed by that technique. Use a new N
identifier only when the root cause was not in this register before execution.
