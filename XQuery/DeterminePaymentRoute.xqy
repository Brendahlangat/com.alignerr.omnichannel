xquery version "1.0";

declare namespace pay = "http://brenda.example.com/omnichannel/payment";
declare variable $payment as element(pay:PaymentRequest) external;

let $transactionId := normalize-space(string($payment/pay:transactionId[1]))
let $customerId := normalize-space(string($payment/pay:customerId[1]))
let $amountText := normalize-space(string($payment/pay:amount[1]))
let $currency := normalize-space(string($payment/pay:currency[1]))
let $channel := normalize-space(string($payment/pay:channel[1]))
let $paymentType := normalize-space(string($payment/pay:paymentType[1]))
let $description := normalize-space(string($payment/pay:description[1]))
let $amountIsDecimal := $amountText castable as xs:decimal
(: Cast only after checking the amount's lexical form to avoid an invalid-cast failure. :)
let $amount := if ($amountIsDecimal) then xs:decimal($amountText) else ()
let $errorCode :=
    if ($transactionId = "") then "PAY-VAL-001"
    else if ($customerId = "") then "PAY-VAL-002"
    else if (not($amountIsDecimal)) then "PAY-VAL-003"
    else if ($amount <= 0) then "PAY-VAL-004"
    else if ($currency != "EUR") then "PAY-VAL-005"
    else if (not($channel = ("MOBILE", "USSD", "WEB", "AGENT", "MERCHANT_API"))) then "PAY-VAL-006"
    else if (not($paymentType = ("ACCOUNT_TRANSFER", "BILL_PAYMENT", "MERCHANT_PAYMENT", "WALLET_TRANSFER"))) then "PAY-VAL-007"
    else if ($channel = "MERCHANT_API" and $paymentType != "MERCHANT_PAYMENT") then "PAY-VAL-008"
    else ""
(: Validate first, then apply high-value review before any normal processor route. :)
let $processor :=
    if ($errorCode != "") then ""
    else if ($amount > 10000) then "MANUAL_REVIEW"
    else if ($paymentType = "MERCHANT_PAYMENT") then "MERCHANT_PAYMENT_PROCESSOR"
    else if ($channel = "MOBILE" or $channel = "USSD") then "MOBILE_PAYMENT_PROCESSOR"
    else if ($channel = "WEB") then "WEB_PAYMENT_PROCESSOR"
    else if ($channel = "AGENT") then "AGENT_PAYMENT_PROCESSOR"
    else ""
let $message :=
    if ($errorCode != "") then
        if ($errorCode = "PAY-VAL-001") then "transactionId is required"
        else if ($errorCode = "PAY-VAL-002") then "customerId is required"
        else if ($errorCode = "PAY-VAL-003") then "amount must be a valid decimal"
        else if ($errorCode = "PAY-VAL-004") then "amount must be greater than zero"
        else if ($errorCode = "PAY-VAL-005") then "currency must be EUR"
        else if ($errorCode = "PAY-VAL-006") then "channel is not supported"
        else if ($errorCode = "PAY-VAL-007") then "paymentType is not supported"
        else "No processor is configured for this channel and payment type"
    else concat("Routed to ", $processor)
return
    <pay:RoutingDecision>
        <pay:transactionId>{$transactionId}</pay:transactionId>
        <pay:customerId>{$customerId}</pay:customerId>
        <pay:status>{if ($errorCode = "") then "ROUTED" else "REJECTED"}</pay:status>
        {if ($errorCode = "") then <pay:processor>{$processor}</pay:processor> else ()}
        {if ($errorCode != "") then <pay:errorCode>{$errorCode}</pay:errorCode> else ()}
        <pay:message>{$message}</pay:message>
        <pay:description>{if ($description = "") then "Customer payment" else $description}</pay:description>
        <pay:correlationId>{concat("CORR-", if ($transactionId = "") then "UNAVAILABLE" else $transactionId)}</pay:correlationId>
    </pay:RoutingDecision>
