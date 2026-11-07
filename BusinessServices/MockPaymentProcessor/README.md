# Mock Payment Processor Business Service

This sample models an outbound HTTP Business Service for the fictional processor contract in `../XSD/PaymentProcessorContract.xsd`.

- `MockPaymentProcessor.biz` is a native REST/HTTP OSB resource example. Its endpoint is the localhost placeholder `http://localhost:9001/mock-payment-processor`, and its HTTP method is `POST`.
- `RestReference.wadl` describes `POST /payments` with XML processor request and response elements.
- `RestReference.wsdl` provides the corresponding WSDL 1.1 HTTP binding.

The `.biz` entry intentionally has retries disabled. In payment flows, retrying after an uncertain downstream outcome can duplicate a transaction. The mock endpoint is not a running service; create/configure native resources with the target Oracle Service Bus version and supply a local mock implementation before invoking it. Do not substitute production endpoints or credentials.
