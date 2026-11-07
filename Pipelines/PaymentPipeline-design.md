# PaymentPipeline design

## Request pipeline
1. Accept the document/literal `PaymentRequest` from the WSDL operation.
2. Validate its XML structure, required elements, and enumerated values against `BusinessServices/MockPaymentProcessor/OmnichannelPayment.xsd`.
3. Apply business validation: transaction and customer IDs must not be blank, amount must be a valid decimal greater than zero, and currency must be `EUR`. Reject failures with a stable `PAY-VAL-*` code before invoking a Business Service.
4. Execute `Transformation/DeterminePaymentRoute.xsl`. It returns `ROUTED` or `REJECTED`; validate the request against the XSD before applying XSLT numeric routing comparisons.
5. Use `Customer payment` when the request description is missing or blank.
6. Dispatch a routed request to its selected Business Service. Do not dispatch a rejected request.
7. Map the result to `PaymentResponse` and propagate the correlation ID.

## Route outcomes
- Invalid required data, amount, currency, channel, or payment type -> `REJECTED`; do not call a processor.
- Valid amount > 10000 EUR -> `MANUAL_REVIEW` (before normal processor routing).
- `MERCHANT_PAYMENT` -> `MERCHANT_PAYMENT_PROCESSOR`.
- `MOBILE` or `USSD` -> `MOBILE_PAYMENT_PROCESSOR`.
- `WEB` -> `WEB_PAYMENT_PROCESSOR`.
- `AGENT` -> `AGENT_PAYMENT_PROCESSOR`.
- `MERCHANT_API` with a non-merchant payment type -> `REJECTED`; no processor is defined for this combination.

## Error handler
Classify errors using `Transformation/ClassifyPaymentError.xsl` with the `PaymentErrorContext` source schema and return an error classification. Only mark an error retryable when the downstream status explicitly confirms the request was not sent. A timeout can happen after a processor has accepted a payment; retrying in that case risks duplicate processing. Use downstream idempotency guarantees and reconciliation before designing automatic retries.

## Test fixtures

- `TestData/valid-mobile-payment.xml`: valid mobile request.
- `TestData/valid-web-payment.xml`: valid web request.
- `TestData/high-value-payment.xml`: valid request routed to manual review.
- `TestData/invalid-amount.xml`: well-formed XML with a negative amount; expected business rejection.
- `TestData/missing-customer.xml`: well-formed XML missing a required element; expected schema/required-field rejection.

The fixtures contain fictional identifiers only. Local/mock endpoints and native OSB configuration must be supplied separately in Oracle tooling.
