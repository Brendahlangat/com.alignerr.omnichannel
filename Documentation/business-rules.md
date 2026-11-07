# Business rules

These are fictional rules for a learning exercise; they do not represent a real bank.

## Request validation

- `transactionId` and `customerId` are required.
- `amount` must be a valid decimal greater than zero.
- `currency` must be `EUR`.
- `channel` must be one of `MOBILE`, `USSD`, `WEB`, `AGENT`, or `MERCHANT_API`.
- `paymentType` must be one of `ACCOUNT_TRANSFER`, `BILL_PAYMENT`, `MERCHANT_PAYMENT`, or `WALLET_TRANSFER`.
- `customerTier` must be one of `STANDARD`, `PREMIUM`, or `CORPORATE`.
- If `description` is absent or blank, use `Customer payment`.

## Routing precedence

1. Reject invalid required fields, amount, currency, or unsupported channel/payment type.
2. If the valid amount is greater than EUR 10,000, route to `MANUAL_REVIEW`.
3. Otherwise, `MERCHANT_PAYMENT` routes to `MERCHANT_PAYMENT_PROCESSOR`.
4. `MOBILE` and `USSD` route to `MOBILE_PAYMENT_PROCESSOR`.
5. `WEB` routes to `WEB_PAYMENT_PROCESSOR`.
6. `AGENT` routes to `AGENT_PAYMENT_PROCESSOR`.

High-value review takes precedence over normal processor routing. An unsupported channel is rejected and is never sent to a processor.

## Test data

All customer IDs, transaction IDs, and destination references in `TestData/` are fictional placeholders. Do not add production endpoints, credentials, or real banking information.
