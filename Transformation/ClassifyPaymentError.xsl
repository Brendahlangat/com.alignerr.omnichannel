<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oracle-xsl-mapper="http://www.oracle.com/xsl/mapper/schemas"
    xmlns:error="http://example.local/omnichannel/errors"
    exclude-result-prefixes="oracle-xsl-mapper">
    <oracle-xsl-mapper:schema>
        <oracle-xsl-mapper:mapSources>
            <oracle-xsl-mapper:source type="XSD">
                <oracle-xsl-mapper:schema location="../BusinessServices/XSD/PaymentErrorContext.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="PaymentErrorContext"
                    namespace="http://example.local/omnichannel/errors"/>
            </oracle-xsl-mapper:source>
        </oracle-xsl-mapper:mapSources>
        <oracle-xsl-mapper:mapTargets>
            <oracle-xsl-mapper:target type="XSD">
                <oracle-xsl-mapper:schema location="../BusinessServices/XSD/PaymentErrorClassification.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="ErrorClassification"
                    namespace="http://example.local/omnichannel/errors"/>
            </oracle-xsl-mapper:target>
        </oracle-xsl-mapper:mapTargets>
    </oracle-xsl-mapper:schema>

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/error:PaymentErrorContext">
        <xsl:variable name="code" select="normalize-space(error:errorCode)"/>
        <xsl:variable name="processorStatus" select="normalize-space(error:processorStatus)"/>
        <xsl:variable name="category">
            <xsl:choose>
                <xsl:when test="starts-with($code, 'PAY-VAL-')">BUSINESS_VALIDATION</xsl:when>
                <xsl:when test="starts-with($code, 'AUTH-') or $processorStatus = 'AUTHENTICATION_ERROR'">AUTHENTICATION_ERROR</xsl:when>
                <xsl:when test="starts-with($code, 'DOWNSTREAM-TIMEOUT') or $processorStatus = 'TIMEOUT'">DOWNSTREAM_TIMEOUT</xsl:when>
                <xsl:when test="starts-with($code, 'DOWNSTREAM-UNAVAILABLE') or $processorStatus = 'UNAVAILABLE'">DOWNSTREAM_UNAVAILABLE</xsl:when>
                <xsl:otherwise>TECHNICAL_ERROR</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- A timeout may follow a completed charge; retry only when the processor confirms it was never sent. -->
        <xsl:variable name="retryable"
            select="$processorStatus = 'NOT_SENT' and (string($category) = 'DOWNSTREAM_UNAVAILABLE' or string($category) = 'TECHNICAL_ERROR')"/>
        <error:ErrorClassification>
            <error:category><xsl:value-of select="$category"/></error:category>
            <error:retryable>
                <xsl:choose>
                    <xsl:when test="$retryable">true</xsl:when>
                    <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
            </error:retryable>
            <error:errorCode>
                <xsl:choose>
                    <xsl:when test="$code != ''"><xsl:value-of select="$code"/></xsl:when>
                    <xsl:when test="string($category) = 'BUSINESS_VALIDATION'">PAY-VAL-UNKNOWN</xsl:when>
                    <xsl:when test="string($category) = 'AUTHENTICATION_ERROR'">AUTH-UNKNOWN</xsl:when>
                    <xsl:when test="string($category) = 'DOWNSTREAM_TIMEOUT'">DOWNSTREAM-TIMEOUT</xsl:when>
                    <xsl:when test="string($category) = 'DOWNSTREAM_UNAVAILABLE'">DOWNSTREAM-UNAVAILABLE</xsl:when>
                    <xsl:otherwise>TECH-UNKNOWN</xsl:otherwise>
                </xsl:choose>
            </error:errorCode>
        </error:ErrorClassification>
    </xsl:template>
</xsl:stylesheet>
