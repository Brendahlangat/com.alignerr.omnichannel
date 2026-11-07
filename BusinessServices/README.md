# Business Services design

`MockPaymentProcessor/` contains a sample HTTP POST Business Service contract and a localhost-only OSB `.biz` example. Its WADL and WSDL describe the fictional `processPayment` operation; see that folder's README for the endpoint and setup notes.

For a fuller OSB implementation, create additional Business Services using local/mock endpoints only:

1. MobilePaymentBusinessService - MOBILE/USSD processing
2. WebPaymentBusinessService - WEB processing
3. AgentPaymentBusinessService - AGENT processing
4. MerchantPaymentBusinessService - MERCHANT_PAYMENT processing
5. ManualReviewBusinessService - fictional high-value review path

These are design names, not configured OSB resources. Keep endpoint URLs local or mocked for this exercise; do not use production banking endpoints.
