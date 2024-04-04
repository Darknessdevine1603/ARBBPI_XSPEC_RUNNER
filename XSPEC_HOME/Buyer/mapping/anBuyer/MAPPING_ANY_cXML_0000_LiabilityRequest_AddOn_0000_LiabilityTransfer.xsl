<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <!--          <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
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
        <xsl:variable name="li" select="Payload/cXML/Request/PaymentProposalRequest"/>
        <xsl:variable name="vendorId">
            <xsl:value-of
                select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"/>
        </xsl:variable>
        <xsl:if test="$li/@paymentProposalID">
            <n0:LiabilityTransfer>
                <MessageHeader>
                    <ID>
                        <xsl:value-of select="$li/@paymentProposalID"/>
                    </ID>
                    <AribaNetworkPayloadID>
                        <xsl:value-of select="Payload/cXML/@payloadID"/>
                    </AribaNetworkPayloadID>
                    <AribaNetworkID>
                        <xsl:value-of select="$anReceiverID"/>
                    </AribaNetworkID>                    
                    <CreationDateTime>
                        <xsl:value-of select="(current-dateTime())"/>
                    </CreationDateTime>
                    <RecipientParty>
                        <InternalID>
                            <xsl:value-of select="$v_sysid"/>
                        </InternalID>
                    </RecipientParty>
                </MessageHeader>
                <DocumentReference>
                    <InvoiceNo>
                        <xsl:value-of select="substring($li/@paymentProposalID, 1, 10)"/>
                    </InvoiceNo>
                    <InvoiceYear>
                        <xsl:value-of select="substring($li/@paymentProposalID, 11, 4)"/>
                    </InvoiceYear>
                    <CompanyCode>
                        <xsl:value-of select="substring($li/@paymentProposalID, 18, 4)"/>
                    </CompanyCode>
                    <PaymentMethod>other</PaymentMethod>
                </DocumentReference>
                <xsl:for-each select="$li/PaymentPartner">
                    <xsl:if test="Contact[@role = 'payer']">
                        <PaymentPartner>
                            <InternalID>
                                <xsl:attribute name="schemeID">
                                    <xsl:value-of select="'VendorID'"/>
                                </xsl:attribute>
                                <xsl:value-of select="$vendorId"/>
                            </InternalID>
                        </PaymentPartner>
                    </xsl:if>
                    <xsl:if test="Contact[@role = 'payee']">
                        <PaymentPartner>
                            <xsl:if test="IdReference/@domain = 'financialInstitutionID'">
                                <InternalID>
                                    <xsl:attribute name="schemeID">
                                        <xsl:value-of select="'financialInstitutionID'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="IdReference/@identifier"/>
                                </InternalID>
                            </xsl:if>
                        </PaymentPartner>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="$li/Comments/text()">
                    <!-- Comments Fill-->
                    <AribaComment>
                        <xsl:call-template name="CommentsFillProxyIn">
                            <xsl:with-param name="p_comments" select="$li/Comments"/>
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
            </n0:LiabilityTransfer>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
