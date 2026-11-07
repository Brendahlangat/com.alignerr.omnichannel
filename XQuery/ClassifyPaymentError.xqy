xquery version "1.0";
declare variable $errorCode external;
declare variable $processorStatus external;
<ErrorClassification><category>{if (starts-with($errorCode,"PAY-VAL-")) then "BUSINESS_VALIDATION" else if ($processorStatus="TIMEOUT") then "DOWNSTREAM_TIMEOUT" else if ($processorStatus="UNAVAILABLE") then "DOWNSTREAM_UNAVAILABLE" else "UNCLASSIFIED_ERROR"}</category><retryable>{if ($processorStatus="TIMEOUT" or $processorStatus="UNAVAILABLE") then true() else false()}</retryable></ErrorClassification>
