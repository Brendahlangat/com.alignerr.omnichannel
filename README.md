# Omnichannel Payment Gateway
A small Oracle Service Bus-style source project for an AI coding-evaluation assignment, based on fictional banking/payment integration scenarios.

## Includes
- XML Schema contract
- XQuery payment routing
- XQuery error classification
- XML test payloads
- business rules

## Suggested evaluation rounds
1. Review DeterminePaymentRoute.xqy for correctness, validation, namespaces, route precedence, and edge cases.
2. Review ClassifyPaymentError.xqy for retry safety and error classification.
3. Generate tests for validation, routing, duplicate handling, timeout, malformed responses, and authentication failure.

This is source material for VS Code and evaluation. It is not by itself a complete deployable Oracle Service Bus application; OSB-specific proxy/business-service/pipeline configuration can be added in Oracle tooling later.

## Next artifacts added
- `WSDL/OmnichannelPayment.wsdl`: SOAP contract importing the payment schema.
- `BusinessServices/README.md`: downstream OSB Business Service design.
- `Pipelines/PaymentPipeline-design.md`: pipeline/routing/error-handler blueprint.
- `Documentation/evaluation-task.md`: ready-to-use first evaluation prompt.

## Recommended workflow
Open the folder in VS Code. Review the schema and tests first, then the XQuery. If you later use Oracle JDeveloper/OSB, create native proxy, pipeline, and `.biz` resources using these contracts and design notes rather than renaming Markdown files as OSB resources.
