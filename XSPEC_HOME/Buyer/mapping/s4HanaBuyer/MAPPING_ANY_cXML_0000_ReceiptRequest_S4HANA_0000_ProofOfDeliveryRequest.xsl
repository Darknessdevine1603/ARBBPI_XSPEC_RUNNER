<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/EDI"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:template match="Combined">
        <!--   <Get the System Id -->
        <xsl:variable name="v_sysid">
            <xsl:call-template name="MultiErpSysIdIN">
                <xsl:with-param name="p_ansysid"
                    select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
                <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="v_currDT">
            <xsl:value-of select="current-dateTime()"/>
        </xsl:variable>
        <xsl:variable name="v_cigDT">
            <xsl:value-of
                select="concat(substring-before($v_currDT, 'T'), 'T', substring(substring-after($v_currDT, 'T'), 1, 8))" />
        </xsl:variable>
        <xsl:variable name="v_cigTS">
            <xsl:call-template name="ERPDateTime">
                <xsl:with-param name="p_date" select="$v_cigDT"/>
                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
            </xsl:call-template>
        </xsl:variable>
        <n0:ProofOfDeliveryRequest>
            <MessageHeader>
                <ID>
                    <xsl:value-of select="substring(Payload/cXML/@payloadID, 1, 35)"/>
                </ID>
                <CreationDateTime>
                    <xsl:value-of select="$v_cigTS"/>
                </CreationDateTime>
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="$v_sysid"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <ProofOfDelivery>
                <!-- Pick the first ShipNotice Number as Document reference/ whithin this feature only one Delivery is referenced (2111) -->
                    <DeliveryDocument>
                        <xsl:value-of select="Payload/cXML/Request/ReceiptRequest/ReceiptOrder[1]/ReceiptItem[1]/ReceiptItemReference[1]/ShipNoticeReference[1]/@shipNoticeID"/>
                    </DeliveryDocument>
                <!-- Time is not mapped, because it is not maintained by supplier -->
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate)) > 0">
                    <ProofOfDeliveryDate>
                        <xsl:value-of select="substring(Payload/cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate, 1, 10)" />
                    </ProofOfDeliveryDate> </xsl:if>
                <xsl:for-each select="Payload/cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptItem">
                    <xsl:if test="string-length(normalize-space(@receiptLineNumber)) > 0">
                    <ProofOfDeliveryItem>
                        <DeliveryDocumentItem>
                            <xsl:value-of select="ReceiptItemReference/ShipNoticeLineItemReference/@shipNoticeLineNumber"/>
                        </DeliveryDocumentItem>
                        <ProofOfDeliveryDifferences>
                            <ProofOfDeliveryQtyInSlsUnit>
                            <xsl:attribute name="unitCode">
                                <xsl:value-of select="UnitRate/UnitOfMeasure"/>
                            </xsl:attribute>
                            <xsl:value-of select="@quantity"/>
                        </ProofOfDeliveryQtyInSlsUnit>
                    </ProofOfDeliveryDifferences>
                    </ProofOfDeliveryItem>
                    </xsl:if>
                </xsl:for-each>
            </ProofOfDelivery>
        </n0:ProofOfDeliveryRequest>
    </xsl:template>
</xsl:stylesheet>
