xquery version "1.0";
declare namespace pay = "http://brenda.example.com/omnichannel/payment";
declare variable $payment external;
declare function local:determine-processor($channel as xs:string, $paymentType as xs:string, $amount as xs:decimal) as xs:string {
 if ($amount > 10000) then "MANUAL_REVIEW"
 else if ($paymentType = "MERCHANT_PAYMENT") then "MERCHANT_PAYMENT_PROCESSOR"
 else if ($channel = "MOBILE" or $channel = "USSD") then "MOBILE_PAYMENT_PROCESSOR"
 else if ($channel = "WEB") then "WEB_PAYMENT_PROCESSOR"
 else if ($channel = "AGENT") then "AGENT_PAYMENT_PROCESSOR"
 else "UNSUPPORTED_CHANNEL"
};
<RoutingDecision><transactionId>{data($payment/pay:transactionId)}</transactionId><customerId>{data($payment/pay:customerId)}</customerId><processor>{local:determine-processor(data($payment/pay:channel),data($payment/pay:paymentType),xs:decimal($payment/pay:amount))}</processor><correlationId>{concat("CORR-",data($payment/pay:transactionId))}</correlationId></RoutingDecision>
