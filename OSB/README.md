# Oracle Service Bus project scaffold

This directory mirrors the provider/requester separation in the supplied JDeveloper structure. It is an organizational scaffold for the existing fictional payment example, not an importable or deployable OSB application. Create the native workspace, project metadata, and OSB resources in Oracle tooling.

## Layout

```text
OSB/
├── OmnichannelPaymentProv/
│   ├── sbContentSet/
│   │   ├── Adapter/
│   │   ├── Business/
│   │   ├── Pipeline/
│   │   ├── Proxy/
│   │   ├── SplitJoin/
│   │   └── Transformation/
│   └── pom.xml
└── OmnichannelPaymentReq/
    ├── sbContentSet/
    │   ├── Business/
    │   ├── Pipeline/
    │   ├── Proxy/
    │   ├── Resources/
    │   └── Transformation/
    └── pom.xml
```

The provider project represents the inbound payment service. The requester project represents outbound calls to fictional local/mock payment processors. Existing contracts and XSLT routing/error mappings remain in the repository's `WSDL/`, `BusinessServices/`, and top-level `Transformation/` directories; no copies are maintained here.

The requester includes `sbContentSet/Transformation/PaymentRequestToProcessorRequest.xsl`, a simple XSLT 1.0 request map from the original `PaymentRequest` into the fictional processor contract in `BusinessServices/XSD/PaymentProcessorContract.xsd`. It defaults a missing or blank description to `Customer payment`. The paired `sbContentSet/Transformation/ProcessorResponseToPaymentResponse.xsl` maps the processor response back to the original `PaymentResponse`, preserving optional processor and error-code fields.

Both transformations include Oracle XSL Mapper source/target metadata. The mapping data models are `BusinessServices/MockPaymentProcessor/OmnichannelPayment.xsd` and `BusinessServices/XSD/PaymentProcessorContract.xsd`; the mapper metadata selects the specific request and response root elements from those schemas. Keep these schema paths and namespace/root-element declarations in sync if the model files move or change. No authentication or credential fields are included.

`pom.xml` files record project coordinates only. They do not configure an OSB Maven plugin or create a deployable service. Native JDeveloper `.jws`, `servicebus.sboverview`, Proxy Service, Pipeline, and Business Service files are intentionally left for Oracle tooling to generate.
