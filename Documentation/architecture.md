# V3 architecture overview

V3 models a small Oracle Service Bus (OSB) payment integration without claiming to be a deployable OSB application. It keeps the original payment schema and uses OSB concepts: a Proxy Service, request/response pipelines, routing, and downstream Business Services. The example uses project-specific fictional payment scenarios and does not include third-party customer records, bank data, production endpoints, or credentials.

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
DeterminePaymentRoute.xsl (routing decision)
    |                         \
    | valid route              \ rejected request
    v                           v
Mock Business Service       Error pipeline
    |                           |
    +---------- PaymentResponse+
```

## Request flow

1. The conceptual OSB Proxy Service exposes the WSDL's document/literal `processPayment` operation and accepts the `PaymentRequest` element defined by the original project schema.
2. The request pipeline validates the XML structure and enumerated values against `BusinessServices/MockPaymentProcessor/OmnichannelPayment.xsd`. It also applies business validation for positive amounts, EUR currency, and required non-blank identifiers.
3. Run `Transformation/DeterminePaymentRoute.xsl` to return a `RoutingDecision`. The request pipeline validates the request against the payment XSD first. The map rejects invalid business values, sends valid amounts above EUR 10,000 to manual review, and otherwise selects a processor according to payment type and channel.
4. The requester maps the validated request with `OSB/OmnichannelPaymentReq/sbContentSet/Transformation/PaymentRequestToProcessorRequest.xsl` into the fictional processor contract at `BusinessServices/XSD/PaymentProcessorContract.xsd`, then invokes the matching local/mock Business Service. The map defaults an absent or blank description to `Customer payment`.
5. `OSB/OmnichannelPaymentReq/sbContentSet/Transformation/ProcessorResponseToPaymentResponse.xsl` maps a processor response back to the original `PaymentResponse` contract.
6. The error pipeline passes a `PaymentErrorContext` to `Transformation/ClassifyPaymentError.xsl` to return a category, retryability decision, and error code. It must not blindly retry a payment when the downstream processing outcome is unknown.

## OSB resource map

- `OSB/OmnichannelPaymentProv/` and `OSB/OmnichannelPaymentReq/` provide provider/requester project boundaries matching the JDeveloper-style folder layout.
- **Proxy Service:** `OmnichannelPaymentProxy` (conceptual), using the WSDL contract.
- **Request pipeline:** validate against the XSD, apply the routing XSLT, then dispatch only accepted routing decisions.
- **Routing:** dispatch a `ROUTED` decision to its named Business Service; send a `REJECTED` decision to the error response path.
- **Business Services:** the sample local HTTP service is described in `BusinessServices/MockPaymentProcessor/`; other local/mock targets are listed in `BusinessServices/README.md`.
- **Error pipeline:** classify the failure and map it to the original schema's `PaymentResponse`.

These directories, names, and steps are an implementation guide, not importable OSB configuration. The Maven files contain coordinates only; create the `.jws`, `servicebus.sboverview`, and native Service Bus resources with Oracle tooling.

## Correlation and scope

For clarity, the sample XSLT derives a correlation identifier from the transaction ID. An actual integration should generate a unique correlation ID at ingress and propagate it through the request, downstream call, logs, and response. The WSDL uses only a localhost placeholder. All example data is fictional; there are no production services or credentials in this project. Proxy Service, pipeline, and Business Service assets are described in Markdown and are not native OSB deployment resources.
