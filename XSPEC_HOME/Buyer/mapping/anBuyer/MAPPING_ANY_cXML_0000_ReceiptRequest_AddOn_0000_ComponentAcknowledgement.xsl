<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes"  omit-xml-declaration="yes"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>  -->
    <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--Prepare the CrossRef path-->
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
            <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_shipnoticeid"
        select="Combined/Payload/cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptItem/ReceiptItemReference/ShipNoticeReference/@shipNoticeID"/>
    <xsl:template match="/Combined">
        <n0:ComponentAcknowledgement>
            <MessageHeader>
                <CreationDateTime>
                    <xsl:value-of select="current-dateTime()"/>
                </CreationDateTime>
				<AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of select="$anReceiverID"/>
                </AribaNetworkID>                
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="$v_sysid"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>            
                <ReceiptRequestHeader>
                    <xsl:attribute name="receiptID">
                        <xsl:value-of select="Payload/cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptID"/>
                    </xsl:attribute>
                    <xsl:attribute name="receiptDate">
                        <xsl:value-of select="substring(Payload/cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate, 1, 10)"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="Payload/cXML/Request/ReceiptRequest/ReceiptRequestHeader/@operation = 'new'">
                            <xsl:attribute name="operation">
                                <xsl:value-of select="'01'"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="Payload/cXML/Request/ReceiptRequest/ReceiptRequestHeader/@operation = 'change'">
                            <xsl:attribute name="operation">
                                <xsl:value-of select="'02'"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="Payload/cXML/Request/ReceiptRequest/ReceiptRequestHeader/@operation = 'delete'">
                            <xsl:attribute name="operation">
                                <xsl:value-of select="'03'"/>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity != ''">
                        <VendorID>
                            <InternalID>
                                <xsl:value-of
                                    select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                                />
                            </InternalID>    
                        </VendorID>
                    </xsl:if>
                    <xsl:if test="Payload/cXML/Request/ReceiptRequest/Total/Money != ''">
                        <Total>
                            <xsl:attribute name="currencyCode">
                                <xsl:value-of select="Payload/cXML/Request/ReceiptRequest/Total/Money/@currency"/>
                            </xsl:attribute>
                            <xsl:value-of select="Payload/cXML/Request/ReceiptRequest/Total/Money"/>
                        </Total>
                    </xsl:if>
                    <xsl:if test="Payload/cXML/Request/ReceiptRequest/Total/Money = ''">
                        <Total>
                            <xsl:attribute name="currencyCode">
                                <xsl:value-of select="Payload/cXML/Request/ReceiptRequest/Total/Money/@currency"/>
                            </xsl:attribute>
                           
                                <xsl:value-of select="'0'"/>
                            
                        </Total>
                    </xsl:if>
                    <xsl:for-each select="Payload/cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptItem">
                        <ReceiptItem>
                            <xsl:attribute name="lineNumber">
                            <xsl:choose>
                                <xsl:when test="ReceiptItemReference/ShipNoticeLineItemReference/@shipNoticeLineNumber">
                                    <xsl:value-of select="ReceiptItemReference/ShipNoticeLineItemReference/@shipNoticeLineNumber"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ReceiptItemReference/@lineNumber"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="receiptLineNumber">
                                <xsl:value-of select="@receiptLineNumber"/>
                            </xsl:attribute>  
                            <!-- CI-1586 -->
                            <xsl:attribute name="PO_lineNumber">
                                <xsl:value-of select="ReceiptItemReference/@lineNumber"/>
                            </xsl:attribute>
                            <!-- CI-1586 -->
                            <ShipNoticeID>
                                <xsl:choose>
                                    <xsl:when test="(string-length(ReceiptItemReference/ShipNoticeReference/@shipNoticeID) > 0)">
                                        <xsl:value-of select="ReceiptItemReference/ShipNoticeReference/@shipNoticeID"/>  
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeID"/>   
                                    </xsl:otherwise>
                                </xsl:choose>                                                                 
                            </ShipNoticeID>
                            <SupplierPartID>
                                <xsl:value-of select="ReceiptItemReference/ItemID/SupplierPartID"/>
                            </SupplierPartID>
                            <BuyerPartID>
                                <xsl:value-of select="ReceiptItemReference/ItemID/BuyerPartID"/>
                            </BuyerPartID>                                                           
                            <!-- Begin of Chagnes IG-29617 -->
                            <!-- this is required so that we match 'Batch' on ECC with BuyerBatchID -->
                            <xsl:if test="string-length(normalize-space(Batch/BuyerBatchID)) > 0">
                                <BuyerBatchID>
                                    <xsl:value-of select="Batch/BuyerBatchID"/>
                                </BuyerBatchID>
                            </xsl:if>
                            <!-- End of Chagnes IG-29617 -->                            
                            <SupplierBatchID>
                                <xsl:value-of select="Batch/SupplierBatchID"/>
                            </SupplierBatchID>                                     
                            <Description>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="ReceiptItemReference/Description/@xml:lang"/>
                                </xsl:attribute>
                                <xsl:value-of select="ReceiptItemReference/Description"/>
                            </Description>
                            <Quantity>
                                <xsl:attribute name="unitCode">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="UnitRate/UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>                                    
                                </xsl:attribute>
                                <xsl:value-of select="@quantity"/>
                            </Quantity>
                                <orderID>
                                    <xsl:choose>
                                        <xsl:when test="(string-length(substring(../ReceiptOrderInfo/OrderReference/@orderID, 1, 10)) > 0)">
                                            <xsl:value-of select="substring(../ReceiptOrderInfo/OrderReference/@orderID, 1, 10)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring(../ReceiptOrderInfo/OrderIDInfo/@orderID, 1, 10)"/>                                        
                                        </xsl:otherwise>
                                    </xsl:choose>    
                         </orderID>					
                        </ReceiptItem>                        
                    </xsl:for-each>
                </ReceiptRequestHeader>
                <AribaComment>
                    <!--            Header      -->
                    <xsl:call-template name="CommentsFillProxyIn">
                        <xsl:with-param name="p_comments"
                            select="ReceiptRequestHeader/Comments"/>
                        <xsl:with-param name="p_lang"
                            select="ReceiptRequestHeader/Comments/@xml:lang"/>
                        <xsl:with-param name="p_doctype"
                            select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                    <!--            Line        -->
                    <xsl:for-each select="ReceiptOrder/ReceiptItem">
                        <xsl:call-template name="CommentsFillProxyIn">
                            <xsl:with-param name="p_comments"
                                select="Comments"/>
                            <xsl:with-param name="p_lang"
                                select="Comments/@xml:lang"/>
                            <xsl:with-param name="p_itemNumber"
                                select="@receiptLineNumber"/>
                            <xsl:with-param name="p_doctype"
                                select="$anSourceDocumentType"/>
                            <xsl:with-param name="p_pd" select="$v_pd"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </AribaComment>
                <!--Call Template to fill Attachments-->
            <!--</xsl:for-each-group>-->
            <xsl:call-template name="InboundAttach"/>
        </n0:ComponentAcknowledgement>
    </xsl:template>
</xsl:stylesheet>
