# PaymentPipeline design

## Request pipeline
1. Validate PaymentRequest against `XSD/OmnichannelPayment.xsd`.
2. Reject amount <= 0 using `PAY-VAL-001`.
3. Check required transaction/customer information.
4. Execute `XQuery/DeterminePaymentRoute.xqy`.
5. Route to the selected Business Service.

## Route outcomes
- amount > 10000 -> MANUAL_REVIEW
- MERCHANT_PAYMENT -> MERCHANT_PAYMENT_PROCESSOR
- MOBILE or USSD -> MOBILE_PAYMENT_PROCESSOR
- WEB -> WEB_PAYMENT_PROCESSOR
- AGENT -> AGENT_PAYMENT_PROCESSOR
- anything else -> UNSUPPORTED_CHANNEL

## Error handler
Classify technical/business failures using `XQuery/ClassifyPaymentError.xqy` and return a standardized PaymentResponse.

## Evaluation note
The XQuery intentionally leaves reviewable design issues, including validation placement, decimal conversion safety, route precedence, correlation-ID quality, and retry assumptions. These are useful for comparing model responses.
