# Evaluation task: Round 1

I am reviewing an Oracle Service Bus-style omnichannel payment gateway. The `DeterminePaymentRoute.xqy` file makes routing decisions for MOBILE, USSD, WEB, AGENT, and merchant payments.

Review the XQuery against the business rules in `Documentation/business-rules.md` and schema in `XSD/OmnichannelPayment.xsd`.

Identify correctness, validation, namespace, type-safety, routing-precedence, correlation-ID, and error-handling issues. Then provide a corrected OSB-compatible XQuery.

Requirements:
1. Amount must be greater than zero.
2. Payments over EUR 10,000 must route to MANUAL_REVIEW.
3. MERCHANT_PAYMENT routes to MERCHANT_PAYMENT_PROCESSOR unless manual review applies first.
4. MOBILE and USSD route to MOBILE_PAYMENT_PROCESSOR.
5. WEB routes to WEB_PAYMENT_PROCESSOR.
6. AGENT routes to AGENT_PAYMENT_PROCESSOR.
7. Unsupported input must not silently reach a processor.
8. Explain every material change.
