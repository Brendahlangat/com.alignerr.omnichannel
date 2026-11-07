# V3 architecture overview

V3 models a small Oracle Service Bus (OSB) payment integration without claiming to be a deployable OSB application. It keeps the original payment schema and uses OSB concepts: a Proxy Service, request/response pipelines, routing, and downstream Business Services. EquitySoa informed only this high-level separation; its SOA Suite composite, BPEL implementation, and environment-specific artifacts are not copied.

```text
SOAP client
    |
    v
OmnichannelPaymentProxy (conceptual OSB Proxy Service)
    |
    v
Request pipeline: validate against the XSD
    |
    v
DeterminePaymentRoute.xqy (routing decision)
    |                         \
    | valid route              \ rejected request
    v                           v
Mock Business Service       Error pipeline
    |                           |
    +---------- PaymentResponse+
```

## Request flow

1. The conceptual OSB Proxy Service exposes the WSDL's document/literal `processPayment` operation and accepts the `PaymentRequest` element defined by the original project schema.
2. The request pipeline validates the XML structure and enumerated values against `XSD/OmnichannelPayment.xsd`. It also applies business validation for positive amounts, EUR currency, and required non-blank identifiers.
3. `XQuery/DeterminePaymentRoute.xqy` returns a `RoutingDecision`. It rejects invalid routing input, sends valid amounts above EUR 10,000 to manual review, and otherwise selects a processor according to payment type and channel.
4. The routing node invokes the matching local/mock Business Service. A real OSB pipeline would map the service result to the original schema's `PaymentResponse`.
5. The error pipeline uses `XQuery/ClassifyPaymentError.xqy` to return a category, retryability decision, and error code. It must not blindly retry a payment when the downstream processing outcome is unknown.

## OSB resource map

- **Proxy Service:** `OmnichannelPaymentProxy` (conceptual), using the WSDL contract.
- **Request pipeline:** schema/business validation, description defaulting, then the routing XQuery.
- **Routing:** dispatch a `ROUTED` decision to its named Business Service; send a `REJECTED` decision to the error response path.
- **Business Services:** local/mock processor and manual-review targets listed in `BusinessServices/README.md`.
- **Error pipeline:** classify the failure and map it to the original schema's `PaymentResponse`.

These names and steps are an implementation guide, not importable OSB configuration.

## Correlation and scope

For clarity, the sample XQuery derives a correlation identifier from the transaction ID. An actual integration should generate a unique correlation ID at ingress and propagate it through the request, downstream call, logs, and response. The WSDL uses only a localhost placeholder. All example data is fictional; there are no production services or credentials in this project. Proxy Service, pipeline, and Business Service assets are described in Markdown and are not native OSB deployment resources.
