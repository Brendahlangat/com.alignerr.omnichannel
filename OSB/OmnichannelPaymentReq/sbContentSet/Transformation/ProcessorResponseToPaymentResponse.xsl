<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oracle-xsl-mapper="http://www.oracle.com/xsl/mapper/schemas"
    xmlns:processor="http://example.local/omnichannel/processor"
    xmlns:pay="http://brenda.example.com/omnichannel/payment"
    exclude-result-prefixes="processor oracle-xsl-mapper">
    <oracle-xsl-mapper:schema>
        <oracle-xsl-mapper:mapSources>
            <oracle-xsl-mapper:source type="XSD">
                <oracle-xsl-mapper:schema location="../../../../BusinessServices/XSD/PaymentProcessorContract.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="ProcessorPaymentResponse"
                    namespace="http://example.local/omnichannel/processor"/>
            </oracle-xsl-mapper:source>
        </oracle-xsl-mapper:mapSources>
        <oracle-xsl-mapper:mapTargets>
            <oracle-xsl-mapper:target type="XSD">
                <oracle-xsl-mapper:schema location="../../../../BusinessServices/MockPaymentProcessor/OmnichannelPayment.xsd"/>
                <oracle-xsl-mapper:rootElement
                    name="PaymentResponse"
                    namespace="http://brenda.example.com/omnichannel/payment"/>
            </oracle-xsl-mapper:target>
        </oracle-xsl-mapper:mapTargets>
    </oracle-xsl-mapper:schema>

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/processor:ProcessorPaymentResponse">
        <pay:PaymentResponse>
            <pay:transactionId>
                <xsl:value-of select="processor:transactionId"/>
            </pay:transactionId>
            <pay:status>
                <xsl:value-of select="processor:status"/>
            </pay:status>
            <xsl:if test="normalize-space(processor:processor) != ''">
                <pay:processor>
                    <xsl:value-of select="processor:processor"/>
                </pay:processor>
            </xsl:if>
            <xsl:if test="normalize-space(processor:errorCode) != ''">
                <pay:errorCode>
                    <xsl:value-of select="processor:errorCode"/>
                </pay:errorCode>
            </xsl:if>
            <pay:message>
                <xsl:value-of select="processor:message"/>
            </pay:message>
            <pay:correlationId>
                <xsl:value-of select="processor:correlationId"/>
            </pay:correlationId>
        </pay:PaymentResponse>
    </xsl:template>
</xsl:stylesheet>
