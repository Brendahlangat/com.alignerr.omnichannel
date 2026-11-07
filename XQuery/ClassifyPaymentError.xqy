xquery version "1.0";

declare variable $errorCode external;
declare variable $processorStatus external;

let $code := normalize-space(string($errorCode))
let $status := normalize-space(string($processorStatus))
let $category :=
    if (starts-with($code, "PAY-VAL-")) then "BUSINESS_VALIDATION"
    else if (starts-with($code, "AUTH-") or $status = "AUTHENTICATION_ERROR") then "AUTHENTICATION_ERROR"
    else if (starts-with($code, "DOWNSTREAM-TIMEOUT") or $status = "TIMEOUT") then "DOWNSTREAM_TIMEOUT"
    else if (starts-with($code, "DOWNSTREAM-UNAVAILABLE") or $status = "UNAVAILABLE") then "DOWNSTREAM_UNAVAILABLE"
    else "TECHNICAL_ERROR"
(: A timeout can follow a completed charge; retry only when the processor confirms it was never sent. :)
let $retryable :=
    $status = "NOT_SENT"
    and ($category = "DOWNSTREAM_UNAVAILABLE" or $category = "TECHNICAL_ERROR")
let $classifiedCode :=
    if ($code != "") then $code
    else if ($category = "BUSINESS_VALIDATION") then "PAY-VAL-UNKNOWN"
    else if ($category = "AUTHENTICATION_ERROR") then "AUTH-UNKNOWN"
    else if ($category = "DOWNSTREAM_TIMEOUT") then "DOWNSTREAM-TIMEOUT"
    else if ($category = "DOWNSTREAM_UNAVAILABLE") then "DOWNSTREAM-UNAVAILABLE"
    else "TECH-UNKNOWN"
return
    <ErrorClassification>
        <category>{$category}</category>
        <retryable>{$retryable}</retryable>
        <errorCode>{$classifiedCode}</errorCode>
    </ErrorClassification>
