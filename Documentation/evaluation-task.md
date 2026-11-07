# Evaluation task: add a payment limit

## What to do

Update the payment routing so that a payment over **EUR 1,000,000** is rejected.

- Return status `REJECTED` and error code `PAY-VAL-009`.
- Explain in the error message that the amount is over the limit.
- Do not send a rejected payment to a processor.
- An amount of exactly EUR 1,000,000 is allowed and goes to `MANUAL_REVIEW`.
- Amounts over EUR 10,000 and up to EUR 1,000,000 continue to go to
  `MANUAL_REVIEW`.
- Keep all existing validation and routing rules working as they do now.

## Files to update

1. `Transformation/DeterminePaymentRoute.xsl` - add the amount-limit check.
   Check it after the existing input validations and before the
   `MANUAL_REVIEW` route.
2. `Documentation/business-rules.md` and `Pipelines/PaymentPipeline-design.md`
   - explain the new limit.
3. `TestData/` - add one fictional example for exactly EUR 1,000,000 and one
   for an amount just above the limit. State the expected result for each.

Keep the amount as `xs:decimal` in the existing schema so the routing logic can
return `PAY-VAL-009`. Use XSLT 1.0, and do not add frameworks, real payment
details, production endpoints, or credentials.

## How to check your work

- EUR 1,000,000 -> `ROUTED` to `MANUAL_REVIEW`.
- EUR 1,000,000.01 -> `REJECTED` with `PAY-VAL-009` and no processor.
- Other existing routes and validation errors still work.
- The documentation and examples match the routing behavior.

This project is a learning example, not a deployable Oracle Service Bus
application.
