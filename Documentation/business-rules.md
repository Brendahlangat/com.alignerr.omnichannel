# Business rules
- Amount must be greater than zero.
- Payments over EUR 10,000 route to MANUAL_REVIEW (fictional exercise rule).
- MOBILE and USSD route to MOBILE_PAYMENT_PROCESSOR.
- WEB routes to WEB_PAYMENT_PROCESSOR.
- AGENT routes to AGENT_PAYMENT_PROCESSOR.
- MERCHANT_PAYMENT routes to MERCHANT_PAYMENT_PROCESSOR.
- Unsupported channels are rejected.
- All test customers/accounts are fictional.
