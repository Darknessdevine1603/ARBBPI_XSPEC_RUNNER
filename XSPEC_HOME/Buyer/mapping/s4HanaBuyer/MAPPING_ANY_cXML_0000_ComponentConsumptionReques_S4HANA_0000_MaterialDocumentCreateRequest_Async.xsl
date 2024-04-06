<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:n0="http://sap.com/xi/APPL/Global2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
        <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <!-- Main Template-->
    <xsl:template match="Combined/Payload">
        <n0:MaterialDocumentCreateRequest_Async>
            <MessageHeader>
                <ID>
                    <xsl:value-of select="substring-before(cXML/@payloadID, '@')"/>
                </ID>
                <CreationDateTime>
                    <xsl:value-of select="cXML/@timestamp"/>
                </CreationDateTime>
                <ReconciliationIndicator>false</ReconciliationIndicator>
                <SenderBusinessSystemID>Ariba_Network</SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="cXML/Header/To/Credential[@domain = 'NetworkID']/Identity"/>
                </RecipientBusinessSystemID>
                <SenderParty>
                    <InternalID>
                        <xsl:value-of
                            select="cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
                    </InternalID>
                </SenderParty>
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of
                            select="cXML/Header/To/Credential[@domain = 'NetworkID']/Identity"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <MaterialDocument>
                <!-- GM_Code 03: Goods issue -->
                <GoodsMovementCode>
                    <xsl:value-of select="'03'"/>
                </GoodsMovementCode>
                <PostingDate>
                    <xsl:value-of
                        select="substring(cXML/Request/ComponentConsumptionRequest/ComponentConsumptionHeader/@creationDate, 1, 10)"/>
                </PostingDate>
                <xsl:variable name="v_orderID">
                    <xsl:value-of
                        select="substring(cXML/Request/ComponentConsumptionRequest/ComponentConsumptionPortion/OrderReference/@orderID, 1, 16)"/>
                </xsl:variable>
                <ReferenceDocument>
                    <xsl:value-of select="$v_orderID"/>
                </ReferenceDocument>
                <xsl:for-each
                    select="cXML/Request/ComponentConsumptionRequest/ComponentConsumptionPortion/ComponentConsumptionItem">
                    <xsl:variable name="v_poLineNumber">
                        <xsl:value-of select="substring(@poLineNumber, 1, 10)"/>
                    </xsl:variable>
                    <xsl:variable name="v_BuyerPartID">
                        <xsl:value-of select="substring(ItemID/BuyerPartID, 1,16)"/>
                    </xsl:variable>
                    <xsl:variable name="v_SupplierPartID">
                        <xsl:value-of select="substring(ItemID/SupplierPartID, 1, 16)"/>
                    </xsl:variable>
                    <xsl:for-each select="ComponentConsumptionDetails">
                        <MaterialDocumentItem>
                            <GoodsMovementType>
                                <xsl:value-of select="'543'"/>
                            </GoodsMovementType>
                            <xsl:if test="string-length(normalize-space(BuyerBatchID)) > 0">
                                <Batch>
                                    <xsl:value-of select="substring(BuyerBatchID, 1, 20)"/>
                                </Batch>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(SupplierBatchID)) > 0">
                                <BatchBySupplier>
                                    <xsl:value-of select="substring(SupplierBatchID, 1, 20)"/>
                                </BatchBySupplier>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(@quantity)) > 0">
                                <QuantityInEntryUnit>
                                    <xsl:value-of select="substring(@quantity, 1, 31)"/>
                                </QuantityInEntryUnit>
                            </xsl:if>
                            <Customer>
                                <xsl:value-of select="$v_BuyerPartID"/>
                            </Customer>
                            <Supplier>
                                <xsl:value-of select="$v_SupplierPartID"/>
                            </Supplier>
                            <PurchaseOrder>
                                <xsl:value-of select="substring($v_orderID, 1 ,10)"/>
                            </PurchaseOrder>
                            <PurchaseOrderItem>
                                <xsl:value-of select="$v_poLineNumber"/>
                            </PurchaseOrderItem>
                        </MaterialDocumentItem>
                    </xsl:for-each>
                </xsl:for-each>
            </MaterialDocument>
        </n0:MaterialDocumentCreateRequest_Async>
    </xsl:template>
</xsl:stylesheet>
