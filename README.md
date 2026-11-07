# Omnichannel Payment Gateway - V3

A small, fictional Oracle Service Bus-style integration exercise covering SOAP, WSDL, XML Schema, XQuery routing, error classification, and test payloads.

## V3 design

V3 keeps the original, user-authored `XSD/OmnichannelPayment.xsd` unchanged. It applies a simple OSB-style separation between the SOAP contract, proxy-service request/response flow, routing logic, and downstream Business Services. The EquitySoa repository informed this high-level separation only; no repository-specific endpoints, credentials, customer data, or SOA Suite deployment artifacts are included.

## Project contents

- `XSD/OmnichannelPayment.xsd` defines the request and response contracts.
- `WSDL/OmnichannelPayment.wsdl` exposes the document/literal `processPayment` SOAP operation.
- `XQuery/DeterminePaymentRoute.xqy` validates routing inputs and builds a routing decision.
- `XQuery/ClassifyPaymentError.xqy` classifies errors and conservatively determines retry safety.
- `Pipelines/PaymentPipeline-design.md` describes the intended OSB pipeline flow.
- `TestData/` contains fictional valid and invalid request examples.
- `Documentation/` contains the business rules and a high-level architecture overview.

## Routing summary

After required-field, amount, currency, and supported-channel validation, amounts over EUR 10,000 go to `MANUAL_REVIEW`. Other valid requests route by payment type and channel; unsupported channels are rejected. Missing descriptions default to `Customer payment`.

The sample correlation identifier is derived from the transaction ID to keep the XQuery understandable. A real integration should assign and propagate a unique correlation ID in its pipeline.

## Example test cases

| File | Scenario | Expected result |
| --- | --- | --- |
| `TestData/valid-mobile-payment.xml` | MOBILE wallet transfer, EUR 275.50 | `MOBILE_PAYMENT_PROCESSOR` |
| `TestData/valid-web-payment.xml` | WEB account transfer, EUR 850.00 | `WEB_PAYMENT_PROCESSOR` |
| `TestData/high-value-payment.xml` | WEB account transfer, EUR 15,000.00 | `MANUAL_REVIEW` |
| `TestData/invalid-amount.xml` | Negative amount | Rejected with a business-validation error |
| `TestData/missing-customer.xml` | Missing customer ID | Rejected by request validation |

## Scope and safety

All customers, transactions, and destinations in this exercise are fictional. The WSDL endpoint is a localhost placeholder; do not replace it with a production banking endpoint or add real credentials.

This repository is learning material, not a complete deployable Oracle Service Bus application. It contains no Java/Spring Boot services or native OSB proxy, pipeline, or Business Service resources. The Markdown design notes explain how the concepts could map to OSB tooling.

## Suggested review exercises

1. Validate the WSDL and schema, then inspect the request-pipeline design.
2. Trace the routing precedence and try additional invalid requests.
3. Review the error classifications, especially timeout and duplicate-payment retry risks.
