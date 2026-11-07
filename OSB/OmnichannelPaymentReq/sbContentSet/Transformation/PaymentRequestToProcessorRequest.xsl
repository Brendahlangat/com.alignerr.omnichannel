<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oracle-xsl-mapper="http://www.oracle.com/xsl/mapper/schemas"
    xmlns:pay="http://brenda.example.com/omnichannel/payment"
    xmlns:processor="http://example.local/omnichannel/processor"
    exclude-result-prefixes="pay oracle-xsl-mapper">
    <oracle-xsl-mapper:schema>
        <oracle-xsl-mapper:mapSources>
            <oracle-xsl-mapper:source type="XSD">
                <oracle-xsl-mapper:schema location="../../../../BusinessServices/MockPaymentProcessor/OmnichannelPayment.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="PaymentRequest"
                    namespace="http://brenda.example.com/omnichannel/payment"/>
            </oracle-xsl-mapper:source>
        </oracle-xsl-mapper:mapSources>
        <oracle-xsl-mapper:mapTargets>
            <oracle-xsl-mapper:target type="XSD">
                <oracle-xsl-mapper:schema location="../../../../BusinessServices/XSD/PaymentProcessorContract.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="ProcessorPaymentRequest"
                    namespace="http://example.local/omnichannel/processor"/>
            </oracle-xsl-mapper:target>
        </oracle-xsl-mapper:mapTargets>
    </oracle-xsl-mapper:schema>

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/pay:PaymentRequest">
        <processor:ProcessorPaymentRequest>
            <processor:transactionId>
                <xsl:value-of select="pay:transactionId"/>
            </processor:transactionId>
            <processor:customerId>
                <xsl:value-of select="pay:customerId"/>
            </processor:customerId>
            <processor:channel>
                <xsl:value-of select="pay:channel"/>
            </processor:channel>
            <processor:paymentType>
                <xsl:value-of select="pay:paymentType"/>
            </processor:paymentType>
            <processor:amount>
                <xsl:value-of select="pay:amount"/>
            </processor:amount>
            <processor:currency>
                <xsl:value-of select="pay:currency"/>
            </processor:currency>
            <processor:destinationAccount>
                <xsl:value-of select="pay:destinationAccount"/>
            </processor:destinationAccount>
            <processor:customerTier>
                <xsl:value-of select="pay:customerTier"/>
            </processor:customerTier>
            <processor:description>
                <xsl:choose>
                    <xsl:when test="normalize-space(pay:description) != ''">
                        <xsl:value-of select="pay:description"/>
                    </xsl:when>
                    <xsl:otherwise>Customer payment</xsl:otherwise>
                </xsl:choose>
            </processor:description>
        </processor:ProcessorPaymentRequest>
    </xsl:template>
</xsl:stylesheet>
