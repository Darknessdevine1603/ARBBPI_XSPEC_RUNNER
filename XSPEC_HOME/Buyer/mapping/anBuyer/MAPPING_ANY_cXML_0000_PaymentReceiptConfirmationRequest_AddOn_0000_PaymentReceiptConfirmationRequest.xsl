<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!-- parameter -->
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <!--    System ID incase of MultiERP-->
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="/Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--PD path    -->
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
            <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--Get the Language code-->
    <xsl:variable name="v_defaultLang">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <!--    Main template-->
    <xsl:template match="Combined">
        <xsl:variable name="v_header_path"
            select="Payload/cXML/Request/PaymentReceiptConfirmationRequest/PaymentReceiptConfirmationRequestHeader"/>
        <n0:PaymentReceiptConfirmationRequest>
            <MessageHeader>
                <CreationDateTime>
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="Payload/cXML/@timestamp"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                    <xsl:value-of select="$v_erpdate"/>
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
            <PaymentReceiptConfirmationRequestHeader>
                <PaymentMethod>
                    <xsl:attribute name="type">
                        <xsl:value-of select="$v_header_path/PaymentMethod/@type"/>
                    </xsl:attribute>
                </PaymentMethod>
                <xsl:for-each select="$v_header_path/PaymentPartner">
                    <PaymentPartner>
                        <xsl:if test="Contact">
                            <Contact>
                                <xsl:if test="string-length(normalize-space(Contact/@role)) > 0">
                                    <xsl:attribute name="role">
                                        <xsl:value-of select="Contact/@role"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <Name>
                                    <xsl:choose>
                                        <xsl:when
                                            test="string-length(normalize-space(Contact/PostalAddress/DeliverTo[1])) > 0">
                                            <xsl:attribute name="languageCode">
                                                <xsl:value-of select="Contact/Name/@xml:lang"/>
                                            </xsl:attribute>
                                            <xsl:value-of
                                                select="Contact/PostalAddress/DeliverTo[1]"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:attribute name="languageCode">
                                                  <xsl:value-of select="Contact/Name/@xml:lang"/>
                                                </xsl:attribute>
                                            <xsl:value-of select="Contact/Name"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Name>
                                <xsl:for-each select="Contact/PostalAddress">
                                    <PostalAddress>
                                        <Street>
                                            <xsl:value-of select="Street[1]"/>
                                        </Street>
                                        <City>
                                            <xsl:value-of select="City"/>
                                        </City>
                                        <xsl:if
                                            test="string-length(normalize-space(PostalCode)) > 0">
                                            <PostalCode>
                                                <xsl:value-of select="PostalCode"/>
                                            </PostalCode>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(State)) > 0">
                                            <Region>
                                                <xsl:if
                                                  test="string-length(normalize-space(State/@isoStateCode)) > 0">
                                                  <xsl:attribute name="listAgencySchemeID">
                                                  <xsl:value-of select="State/@isoStateCode"/>
                                                  </xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="State"/>
                                            </Region>
                                        </xsl:if>
                                        <Country>
                                            <xsl:value-of select="Country/@isoCountryCode"/>
                                        </Country>
                                    </PostalAddress>
                                </xsl:for-each>
                            </Contact>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(IdReference[@domain = 'bankAccountID']/@identifier)) > 0">
                            <BankAccountID>
                                <xsl:value-of
                                    select="IdReference[@domain = 'bankAccountID']/@identifier"/>
                            </BankAccountID>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(IdReference[@domain = 'taxID']/@identifier)) > 0">
                            <TaxID>
                                <xsl:value-of select="IdReference[@domain = 'taxID']/@identifier"/>
                            </TaxID>
                        </xsl:if>
                    </PaymentPartner>
                </xsl:for-each>
                <xsl:if test="string-length(normalize-space($v_header_path/@paymentReceiptID)) > 0">
                    <PaymentReceiptID>
                        <xsl:value-of select="$v_header_path/@paymentReceiptID"/>
                    </PaymentReceiptID>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($v_header_path/@issuedDate)) > 0">
                    <PaymentIssuedDate>
                        <xsl:variable name="v_issuedate">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date" select="$v_header_path/@issuedDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                        <xsl:value-of select="translate(substring($v_issuedate, 1, 10), '-', '')"/>
                    </PaymentIssuedDate>
                </xsl:if>
                <xsl:if
                    test="string-length(normalize-space($v_header_path/@paymentReceivedDate)) > 0">
                    <PaymentReceivedDate>
                        <xsl:variable name="v_paymentdate">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date"
                                    select="$v_header_path/@paymentReceivedDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                        <xsl:value-of select="translate(substring($v_paymentdate, 1, 10), '-', '')"
                        />
                    </PaymentReceivedDate>
                </xsl:if>
                <xsl:if
                    test="string-length(normalize-space($v_header_path/Extrinsic[@name = 'externalTxnID'])) > 0">
                    <PaymentReceiptUUID>
                        <xsl:value-of
                            select="$v_header_path/Extrinsic[@name = 'externalTxnID']"/>
                    </PaymentReceiptUUID>
                </xsl:if>
                <xsl:if test="$v_header_path/Extrinsic[@name = 'serviceCode']">
                    <ServiceCode>
                        <xsl:for-each
                            select="$v_header_path/Extrinsic[@name = 'serviceCode']/Classification">
                            <Classification>
                                <xsl:if test="string-length(normalize-space(@domain)) > 0">
                                    <xsl:attribute name="schemeID">
                                        <xsl:value-of select="@domain"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="."/>
                            </Classification>
                        </xsl:for-each>
                    </ServiceCode>
                </xsl:if>
                <xsl:for-each select="$v_header_path/Extrinsic">
                    <xsl:if test="@name != 'serviceCode'">
                        <AdditionalInfo>
                            <xsl:attribute name="schemeID">
                                <xsl:value-of select="@name"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </AdditionalInfo>
                    </xsl:if>
                </xsl:for-each>
            </PaymentReceiptConfirmationRequestHeader>
            <xsl:for-each
                select="Payload/cXML/Request/PaymentReceiptConfirmationRequest/PaymentReceiptDetails/PaymentReceiptItem">
                <PaymentReceiptConfirmationRequestItem>
                    <xsl:if test="string-length(normalize-space(@installmentNumber)) > 0">
                        <xsl:attribute name="installmentNumber">
                            <xsl:value-of select="@installmentNumber"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="paymentLineNumber">
                        <xsl:value-of select="@paymentLineNumber"/>
                    </xsl:attribute>
                    <PaymentDetails>
                        <PaymentAmount>
                            <xsl:attribute name="currencyCode">
                                <xsl:value-of select="PaymentDetails/PaymentAmount/Money/@currency"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="PaymentDetails/PaymentAmount/Money"/>
                        </PaymentAmount>
                        <xsl:if
                            test="string-length(normalize-space(PaymentDetails/PreviousBalance/Money)) > 0">
                            <PreviousBalance>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of
                                        select="PaymentDetails/PreviousBalance/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="PaymentDetails/PreviousBalance/Money"/>
                            </PreviousBalance>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(PaymentDetails/PresentBalance/Money)) > 0">
                            <PresentBalance>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of
                                        select="PaymentDetails/PresentBalance/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="PaymentDetails/PresentBalance/Money"/>
                            </PresentBalance>
                        </xsl:if>
                    </PaymentDetails>
                    <ReferenceDocumentNumber>
                        <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo/@documentID"/>
                    </ReferenceDocumentNumber>
                    <ReferenceDocumentType>
                        <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo/@documentType"/>
                    </ReferenceDocumentType>
                    <xsl:if test="string-length(normalize-space(ReferenceDocumentInfo/DocumentInfo/@documentDate)) > 0">
                        <ReferenceDocumentDate>
                            <xsl:variable name="v_refdocdate">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date" select="ReferenceDocumentInfo/DocumentInfo/@documentDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                            <xsl:value-of select="translate(substring($v_refdocdate, 1, 10), '-', '')"/>
                        </ReferenceDocumentDate>
                    </xsl:if>
                   <!-- Mapping Extrinsics under ReferenceDocumentInfo to Item AdditionalInfo-->
                    <xsl:for-each select="ReferenceDocumentInfo/Extrinsic">
                        <AdditionalInfo>
                            <xsl:attribute name="schemeID">
                                <xsl:value-of select="@name"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </AdditionalInfo>
                    </xsl:for-each>
                    <xsl:for-each select="Extrinsic">
                        <AdditionalInfo>
                            <xsl:attribute name="schemeID">
                                <xsl:value-of select="@name"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </AdditionalInfo>
                    </xsl:for-each>
                </PaymentReceiptConfirmationRequestItem>
            </xsl:for-each>
            <xsl:variable name="v_summary_path"
                select="Payload/cXML/Request/PaymentReceiptConfirmationRequest/PaymentReceiptSummary"/>
            <xsl:if test="$v_summary_path/NetAmount/Money">
                <PaymentReceiptSummary>
                    <NetAmount>
                        <xsl:attribute name="currencyCode">
                            <xsl:value-of select="$v_summary_path/NetAmount/Money/@currency"/>
                        </xsl:attribute>
                        <xsl:value-of select="$v_summary_path/NetAmount/Money"/>
                    </NetAmount>
                    <xsl:for-each select="$v_summary_path/Extrinsic">
                        <AdditionalInfo>
                            <xsl:attribute name="schemeID">
                                <xsl:value-of select="@name"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </AdditionalInfo>
                    </xsl:for-each>
                </PaymentReceiptSummary>
            </xsl:if>
            <!--  <xsl:for-each
                select="Payload/cXML/Request/PaymentReceiptConfirmationRequest/PaymentReceiptDetails/Extrinsic">
                <AdditionalInfo>
                    <xsl:attribute name="schemeID">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </AdditionalInfo>
            </xsl:for-each>-->
            <xsl:if test="$v_header_path/Comments">
                <AribaComments>
                    <xsl:variable name="v_commentsLang">
                        <xsl:choose>
                            <xsl:when test="string-length($v_header_path/Comments/@xml:lang) > 0">
                                <xsl:value-of select="$v_header_path/Comments/@xml:lang"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$v_defaultLang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="CommentsFillProxyIn">
                        <xsl:with-param name="p_comments" select="$v_header_path/Comments"/>
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_lang" select="$v_commentsLang"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </AribaComments>
            </xsl:if>
            <!--Map attachments , Call template to handle this-->
            <xsl:call-template name="InboundAttachs"/>
        </n0:PaymentReceiptConfirmationRequest>
    </xsl:template>
</xsl:stylesheet>
