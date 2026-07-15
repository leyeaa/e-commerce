# ET-02: validation and misuse session

## Mission

Evaluate whether cart update and order creation safely reject incomplete,
malformed, unauthorized, extreme, and incorrectly ordered actions without
crashing or corrupting persistent state.

## Charter

Explore the selected endpoints using Couch Potato, Saboteur, and Antisocial
tours to discover validation, authorization, state-management, and
data-integrity failures.

## Timebox

90 minutes.

## Suggested coverage

- Blank, missing, null, and default fields.
- Strings, numbers, arrays, objects, and booleans in unexpected positions.
- Zero, negative, fractional, and extremely large quantities.
- Nonexistent product, cart, and cart-item identifiers.
- Another authenticated user cart-item identifier.
- Empty-cart checkout.
- Invalid and missing JWT tokens.
- Repeated submission and rapid repeated clicks.
- Invalid payment method and unusual phone values.
- Browser back, refresh, or closure during checkout.
- Database state after every rejected operation.

## Evidence

Capture minimal reproductions, status codes, response bodies, server logs, and
before-and-after database state. Complete session-template.md during execution.
