<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oracle-xsl-mapper="http://www.oracle.com/xsl/mapper/schemas"
    xmlns:pay="http://brenda.example.com/omnichannel/payment"
    exclude-result-prefixes="oracle-xsl-mapper">
    <oracle-xsl-mapper:schema>
        <oracle-xsl-mapper:mapSources>
            <oracle-xsl-mapper:source type="XSD">
                <oracle-xsl-mapper:schema location="../BusinessServices/MockPaymentProcessor/OmnichannelPayment.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="PaymentRequest"
                    namespace="http://brenda.example.com/omnichannel/payment"/>
            </oracle-xsl-mapper:source>
        </oracle-xsl-mapper:mapSources>
        <oracle-xsl-mapper:mapTargets>
            <oracle-xsl-mapper:target type="XSD">
                <oracle-xsl-mapper:schema location="../BusinessServices/XSD/RoutingDecision.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="RoutingDecision"
                    namespace="http://brenda.example.com/omnichannel/payment"/>
            </oracle-xsl-mapper:target>
        </oracle-xsl-mapper:mapTargets>
    </oracle-xsl-mapper:schema>

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/pay:PaymentRequest">
        <xsl:variable name="transactionId" select="normalize-space(pay:transactionId)"/>
        <xsl:variable name="customerId" select="normalize-space(pay:customerId)"/>
        <xsl:variable name="amountText" select="normalize-space(pay:amount)"/>
        <!-- Validate the request against the payment XSD before this map; number() is guarded for malformed input. -->
        <xsl:variable name="amount" select="number($amountText)"/>
        <xsl:variable name="currency" select="normalize-space(pay:currency)"/>
        <xsl:variable name="channel" select="normalize-space(pay:channel)"/>
        <xsl:variable name="paymentType" select="normalize-space(pay:paymentType)"/>
        <xsl:variable name="description" select="normalize-space(pay:description)"/>
        <xsl:variable name="errorCode">
            <xsl:choose>
                <xsl:when test="$transactionId = ''">PAY-VAL-001</xsl:when>
                <xsl:when test="$customerId = ''">PAY-VAL-002</xsl:when>
                <xsl:when test="not($amount = $amount)">PAY-VAL-003</xsl:when>
                <xsl:when test="$amount &lt;= 0">PAY-VAL-004</xsl:when>
                <xsl:when test="$currency != 'EUR'">PAY-VAL-005</xsl:when>
                <xsl:when test="not($channel = 'MOBILE' or $channel = 'USSD' or $channel = 'WEB' or $channel = 'AGENT' or $channel = 'MERCHANT_API')">PAY-VAL-006</xsl:when>
                <xsl:when test="not($paymentType = 'ACCOUNT_TRANSFER' or $paymentType = 'BILL_PAYMENT' or $paymentType = 'MERCHANT_PAYMENT' or $paymentType = 'WALLET_TRANSFER')">PAY-VAL-007</xsl:when>
                <xsl:when test="$channel = 'MERCHANT_API' and $paymentType != 'MERCHANT_PAYMENT'">PAY-VAL-008</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="processor">
            <xsl:choose>
                <xsl:when test="string($errorCode) != ''"/>
                <!-- High-value review takes precedence over all normal processor routes. -->
                <xsl:when test="$amount &gt; 10000">MANUAL_REVIEW</xsl:when>
                <xsl:when test="$paymentType = 'MERCHANT_PAYMENT'">MERCHANT_PAYMENT_PROCESSOR</xsl:when>
                <xsl:when test="$channel = 'MOBILE' or $channel = 'USSD'">MOBILE_PAYMENT_PROCESSOR</xsl:when>
                <xsl:when test="$channel = 'WEB'">WEB_PAYMENT_PROCESSOR</xsl:when>
                <xsl:when test="$channel = 'AGENT'">AGENT_PAYMENT_PROCESSOR</xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <pay:RoutingDecision>
            <pay:transactionId><xsl:value-of select="$transactionId"/></pay:transactionId>
            <pay:customerId><xsl:value-of select="$customerId"/></pay:customerId>
            <pay:status>
                <xsl:choose>
                    <xsl:when test="string($errorCode) = ''">ROUTED</xsl:when>
                    <xsl:otherwise>REJECTED</xsl:otherwise>
                </xsl:choose>
            </pay:status>
            <xsl:if test="string($errorCode) = ''">
                <pay:processor><xsl:value-of select="$processor"/></pay:processor>
            </xsl:if>
            <xsl:if test="string($errorCode) != ''">
                <pay:errorCode><xsl:value-of select="$errorCode"/></pay:errorCode>
            </xsl:if>
            <pay:message>
                <xsl:choose>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-001'">transactionId is required</xsl:when>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-002'">customerId is required</xsl:when>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-003'">amount must be a valid decimal</xsl:when>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-004'">amount must be greater than zero</xsl:when>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-005'">currency must be EUR</xsl:when>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-006'">channel is not supported</xsl:when>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-007'">paymentType is not supported</xsl:when>
                    <xsl:when test="string($errorCode) = 'PAY-VAL-008'">No processor is configured for this channel and payment type</xsl:when>
                    <xsl:otherwise><xsl:value-of select="concat('Routed to ', string($processor))"/></xsl:otherwise>
                </xsl:choose>
            </pay:message>
            <pay:description>
                <xsl:choose>
                    <xsl:when test="$description != ''"><xsl:value-of select="$description"/></xsl:when>
                    <xsl:otherwise>Customer payment</xsl:otherwise>
                </xsl:choose>
            </pay:description>
            <pay:correlationId>
                <xsl:value-of select="concat('CORR-', $transactionId)"/>
            </pay:correlationId>
        </pay:RoutingDecision>
    </xsl:template>
</xsl:stylesheet>
