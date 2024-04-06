<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <!--<xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="Combined">
        <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
        <xsl:variable name="v_sysid">
            <xsl:call-template name="MultiErpSysIdIN">
                <xsl:with-param name="p_ansysid"
                    select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
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
        <!--Get the Language code-->
        <xsl:variable name="v_lang">
            <xsl:choose>
                <xsl:when
                    test="Payload/cXML/Request/PaymentProposalRequest/Comments/@xml:lang != ''">
                    <xsl:value-of
                        select="Payload/cXML/Request/PaymentProposalRequest/Comments/@xml:lang"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="FillDefaultLang">
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>       
        <xsl:if test="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentRemittanceID">
            <n0:RemittanceAdvice>
                <MessageHeader>
                    <ID>
                        <xsl:value-of select="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentRemittanceID"/>
                    </ID>
                    <AribaNetworkPayloadID>
                        <xsl:value-of select="Payload/cXML/@payloadID"/>
                    </AribaNetworkPayloadID>
                    <AribaNetworkID>
                        <xsl:value-of select="$anReceiverID"/>
                    </AribaNetworkID>                    
                    <CreationDateTime>
                        <xsl:value-of select="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate"/>
                    </CreationDateTime>
                    <SenderParty>
                        <InternalID>
                            <xsl:value-of select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"/>
                        </InternalID>
                    </SenderParty>                    
                    <RecipientParty>
                        <InternalID>
                            <xsl:value-of select="$v_sysid"/>
                        </InternalID>
                    </RecipientParty>
                </MessageHeader>
                <DocumentReference>
                    <PaymentRemittanceID>
                        <xsl:value-of select="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentRemittanceID"/>
                    </PaymentRemittanceID>
                    <xsl:if test="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic/@name = 'SCFRemittanceType'">
                        <RemittanceType>
                            <xsl:value-of select="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic"/>
                        </RemittanceType>
                    </xsl:if>
                    <PaymentMethod>
                        <xsl:value-of select="'other'"/>
                    </PaymentMethod>
                    <PaymentDate>
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </PaymentDate>
                </DocumentReference>
                <xsl:for-each
                    select="Payload/cXML/Request/PaymentRemittanceRequest/RemittanceDetail">
                    <RemittanceDetail>
                        <PayableInfo>
                            <InvoiceNo>
                                <xsl:value-of
                                    select="substring(Extrinsic[@name = 'PaymentProposalID'], 1, 10)"
                                />
                            </InvoiceNo>
                            <InvoiceYear>
                                <xsl:value-of
                                    select="substring(Extrinsic[@name = 'PaymentProposalID'], 11, 4)"
                                />
                            </InvoiceYear>
                            <CompanyCode>
                                <xsl:value-of
                                    select="substring(Extrinsic[@name = 'PaymentProposalID'], 18, 4)"
                                />
                            </CompanyCode>
                        </PayableInfo>
                        <PriceDetail>
                            <xsl:if test="GrossAmount/Money != ''">
                                <GrossAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="GrossAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="GrossAmount/Money"/>
                                </GrossAmount>
                            </xsl:if>
                            <xsl:if test="DiscountAmount/Money != ''">
                                <DiscountAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="DiscountAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="DiscountAmount/Money"/>
                                </DiscountAmount>
                            </xsl:if>
                            <xsl:if test="AdjustmentAmount/Money != ''">
                                <AdjustmentAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="AdjustmentAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="AdjustmentAmount/Money"/>
                                </AdjustmentAmount>
                            </xsl:if>
                            <xsl:if test="NetAmount/Money != ''">
                                <NetAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="NetAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="NetAmount/Money"/>
                                </NetAmount>
                            </xsl:if>
                        </PriceDetail>
                    </RemittanceDetail>
                </xsl:for-each>
                <xsl:for-each
                    select="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary">
                    <RemittanceSummary>
                        <xsl:if test="GrossAmount/Money != ''">
                            <GrossAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="GrossAmount/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="GrossAmount/Money"/>
                            </GrossAmount>
                        </xsl:if>
                        <xsl:if test="DiscountAmount/Money != ''">
                            <DiscountAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="DiscountAmount/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="DiscountAmount/Money"/>
                            </DiscountAmount>
                        </xsl:if>
                        <xsl:if test="AdjustmentAmount/Money != ''">
                            <AdjustmentAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="AdjustmentAmount/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="AdjustmentAmount/Money"/>
                            </AdjustmentAmount>
                        </xsl:if>
                        <xsl:if test="NetAmount/Money != ''">
                            <NetAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="NetAmount/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="NetAmount/Money"/>
                            </NetAmount>
                        </xsl:if>
                    </RemittanceSummary>
                </xsl:for-each>
                <xsl:if test="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Comments/text()">
                    <!-- Comments Fill-->
                    <AribaComment>
                        <xsl:call-template name="CommentsFillProxyIn">
                            <xsl:with-param name="p_comments" select="Payload/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Comments"/>
                            <xsl:with-param name="p_lang" select="$v_lang"/>
                            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                            <xsl:with-param name="p_pd" select="$v_pd"/>
                        </xsl:call-template>
                    </AribaComment>
                </xsl:if>
                <xsl:if test="AttachmentList">
                    <!--Call Template to fill Attachments-->
                    <xsl:call-template name="InboundAttach"/>
                </xsl:if>
            </n0:RemittanceAdvice>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
