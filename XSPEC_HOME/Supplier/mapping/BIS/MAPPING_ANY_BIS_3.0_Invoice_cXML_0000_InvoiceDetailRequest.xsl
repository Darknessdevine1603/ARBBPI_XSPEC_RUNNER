<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:n0="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="cXMLAttachments"/>
    <xsl:param name="anSenderDefaultTimeZone"/>
    <xsl:param name="attachSeparator" select="'\|'"/>
    <xsl:param name="adapterFrom"/>
    <xsl:include href="FORMAT_BIS_3.0_cXML_0000.xsl"/>
    <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_BIS_3.0.xml')"/>

    <!--<xsl:variable name="Lookup" select="document('LOOKUP_BIS_3.0.xml')"/>
    <xsl:include href="FORMAT_BIS_3.0_cXML_0000.xsl"/>-->

    <xsl:template match="*">
        <xsl:variable name="BIS_Invoice">
            <xsl:choose>
                <xsl:when test="contains( lower-case(cbc:CustomizationID), 'peppol')">peppol</xsl:when>
                <xsl:when test="contains( lower-case(cbc:CustomizationID), 'xrechnung')">xrechnung</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="invType">
            <xsl:choose>
                <xsl:when test="cbc:InvoiceTypeCode = '80'">lineLevelDebitMemo</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '82'">standard</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '84'">lineLevelDebitMemo</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '383'">lineLevelDebitMemo</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '386'">standard</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '393'">standard</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '395'">standard</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '575'">standard</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '623'">standard</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '780'">standard</xsl:when>
                <xsl:when test="cbc:InvoiceTypeCode = '380'">
                    <xsl:choose>
                        <xsl:when
                            test="contains(cac:LegalMonetaryTotal/cbc:LineExtensionAmount, '-') and contains(cac:InvoiceLine[1]/cbc:InvoicedQuantity, '-')"
                            >lineLevelCreditMemo</xsl:when>
                        <xsl:otherwise>standard</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="cXML">
            <xsl:attribute name="payloadID">
                <xsl:value-of select="$anPayloadID"/>
            </xsl:attribute>
            <xsl:attribute name="timestamp">
                <xsl:value-of
                    select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"
                />
            </xsl:attribute>
            <Header>
                <From>
                    <xsl:choose>
                        <xsl:when test="$adapterFrom = 'PP'">
                            <Credential domain="BusinessPartnerId">
                                <Identity>
                                    <IdReference>
                                        <xsl:attribute name="domain">iso6523</xsl:attribute>
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="normalize-space(concat(cac:AccountingSupplierParty/cac:Party/cbc:EndpointID/@schemeID, ':', cac:AccountingSupplierParty/cac:Party/cbc:EndpointID))"/>
                                        </xsl:attribute>
                                    </IdReference>
                                </Identity>
                            </Credential>
                        </xsl:when>
                        <xsl:otherwise>
                            <Credential domain="NetworkID">
                                <Identity>
                                    <xsl:value-of select="$anSupplierANID"/>
                                </Identity>
                            </Credential>
                        </xsl:otherwise>
                    </xsl:choose>
                    <Correspondent>
                        <xsl:attribute name="preferredLanguage">de</xsl:attribute>
                        <Contact role="correspondent">
                            <xsl:call-template name="CreateContact">
                                <xsl:with-param name="partyInfo"
                                    select="cac:AccountingSupplierParty/cac:Party"/>
                                <xsl:with-param name="partyRole" select="'correspondent'"/>
                            </xsl:call-template>
                        </Contact>
                        <xsl:if test="$adapterFrom = 'PP'">
                            <Routing>
                                <xsl:attribute name="destination">peppol</xsl:attribute>
                            </Routing>
                        </xsl:if>
                    </Correspondent>
                </From>
                <To>
                    <xsl:choose>
                        <xsl:when test="$adapterFrom = 'PP'">
                            <Credential domain="BusinessPartnerId">
                                <Identity>
                                    <IdReference>
                                        <xsl:attribute name="domain">iso6523</xsl:attribute>
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="normalize-space(concat(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/@schemeID, ':', cac:AccountingCustomerParty/cac:Party/cbc:EndpointID))"/>
                                        </xsl:attribute>
                                    </IdReference>
                                </Identity>
                            </Credential>
                        </xsl:when>
                        <xsl:otherwise>
                            <Credential domain="NetworkID">
                                <Identity>
                                    <xsl:value-of select="$anBuyerANID"/>
                                </Identity>
                            </Credential>   
                        </xsl:otherwise>
                    </xsl:choose>                                    
                </To>
                <Sender>
                    <Credential domain="NetworkId">
                        <Identity>
                            <xsl:value-of select="$anProviderANID"/>
                        </Identity>
                    </Credential>
                    <xsl:choose>
                        <xsl:when test="$adapterFrom = 'PP'">
                            <UserAgent>SAP Peppol AP</UserAgent>
                        </xsl:when>
                        <xsl:otherwise>
                            <UserAgent>
                                <xsl:value-of select="'Ariba Supplier'"/>
                            </UserAgent>
                        </xsl:otherwise>
                    </xsl:choose>
                </Sender>
            </Header>
            <Request>
                <xsl:choose>
                    <xsl:when test="$anEnvName = 'PROD'">
                        <xsl:attribute name="deploymentMode">production</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="deploymentMode">test</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <InvoiceDetailRequest>
                    <InvoiceDetailRequestHeader>
                        <xsl:attribute name="invoiceID">
                            <xsl:value-of select="cbc:ID"/>
                        </xsl:attribute>
                        <xsl:attribute name="invoiceDate">
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate" select="cbc:IssueDate"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="purpose">
                            <xsl:value-of select="$invType"/>
                        </xsl:attribute>
                        <xsl:attribute name="operation">new</xsl:attribute>
                        <InvoiceDetailHeaderIndicator/>

                        <InvoiceDetailLineIndicator>
                            <xsl:if
                                test="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:Amount != ''">
                                <xsl:attribute name="isDiscountInLine">yes</xsl:attribute>
                            </xsl:if>
                            <xsl:if
                                test="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SAA']/cbc:Amount != ''">
                                <xsl:attribute name="isShippingInLine">yes</xsl:attribute>
                            </xsl:if>
                            <xsl:if
                                test="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SH']/cbc:Amount != ''">
                                <xsl:attribute name="isSpecialHandlingInLine">yes</xsl:attribute>
                            </xsl:if>
                            <xsl:if
                                test="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID != ''">
                                <xsl:attribute name="isTaxInLine">yes</xsl:attribute>
                            </xsl:if>
                        </InvoiceDetailLineIndicator>
                        <!-- from -->
                        <xsl:if
                            test="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID/@schemeID != ''">
                            <InvoicePartner>
                                <Contact>
                                    <xsl:attribute name="role">from</xsl:attribute>
                                    <xsl:if test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID) != '' and normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID/@schemeID) != ''">
                                    <xsl:if
                                        test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID) != ''">
                                        <xsl:attribute name="addressID">
                                            <xsl:value-of
                                                select="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if
                                        test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID/@schemeID) != ''">
                                        <xsl:attribute name="addressIDDomain">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID/@schemeID = '0060'"
                                                  >DUNS</xsl:when>
                                                <xsl:when
                                                  test="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID/@schemeID = '0088'"
                                                  >EANID</xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification[1]/cbc:ID/@schemeID"
                                                  />
                                                </xsl:otherwise>
                                            </xsl:choose>

                                        </xsl:attribute>
                                    </xsl:if>
                                    </xsl:if>
                                    <xsl:call-template name="CreateContact">
                                        <xsl:with-param name="partyInfo"
                                            select="cac:AccountingSupplierParty/cac:Party"/>
                                        <xsl:with-param name="partyRole" select="'from'"/>
                                    </xsl:call-template>                                    
                                </Contact>
                                <xsl:call-template name="CreateIdReference">
                                    <xsl:with-param name="partyInfo"
                                        select="cac:AccountingSupplierParty/cac:Party"/>
                                    <xsl:with-param name="partyRole" select="'from'"/>
                                </xsl:call-template>
                            </InvoicePartner>
                        </xsl:if>
                        <!-- soldTo -->
                        <xsl:if
                            test="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/@schemeID != ''">
                            <InvoicePartner>
                                <Contact>
                                    <xsl:attribute name="role">soldTo</xsl:attribute>
                                    <xsl:if test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) != '' and normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) != ''">
                                    <xsl:if
                                        test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) != ''">
                                        <xsl:attribute name="addressID">
                                            <xsl:value-of
                                                select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if
                                        test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) != ''">
                                        <xsl:attribute name="addressIDDomain">
                                            <xsl:value-of
                                                select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    </xsl:if>
                                    <xsl:call-template name="CreateContact">
                                        <xsl:with-param name="partyInfo"
                                            select="cac:AccountingCustomerParty/cac:Party"/>
                                        <xsl:with-param name="partyRole" select="'soldTo'"/>
                                    </xsl:call-template>
                                </Contact>
                                <xsl:call-template name="CreateIdReference">
                                    <xsl:with-param name="partyInfo"
                                        select="cac:AccountingCustomerParty/cac:Party"/>
                                    <xsl:with-param name="partyRole" select="'soldTo'"/>
                                </xsl:call-template>
                            </InvoicePartner>
                        </xsl:if>
                        
                        <!-- BillTo -->
                        <xsl:if
                            test="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/@schemeID != ''">
                            <InvoicePartner>
                                <Contact>
                                    <xsl:attribute name="role">billTo</xsl:attribute>
                                    <xsl:if test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) != '' and normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) != ''">
                                        <xsl:if
                                            test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) != ''">
                                            <xsl:attribute name="addressID">
                                                <xsl:value-of
                                                    select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"
                                                />
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if
                                            test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) != ''">
                                            <xsl:attribute name="addressIDDomain">
                                                <xsl:value-of
                                                    select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"
                                                />
                                            </xsl:attribute>
                                        </xsl:if>
                                    </xsl:if>
                                    <xsl:call-template name="CreateContact">
                                        <xsl:with-param name="partyInfo"
                                            select="cac:AccountingCustomerParty/cac:Party"/>
                                        <xsl:with-param name="partyRole" select="'billTO'"/>
                                    </xsl:call-template>
                                </Contact>
                                <xsl:call-template name="CreateIdReference">
                                    <xsl:with-param name="partyInfo"
                                        select="cac:AccountingCustomerParty/cac:Party"/>
                                    <xsl:with-param name="partyRole" select="'billTO'"/>
                                </xsl:call-template>
                            </InvoicePartner>
                        </xsl:if>

                        <!-- payee -->
                        <xsl:if test="cac:PayeeParty">
                            <InvoicePartner>
                                <Contact>
                                    <xsl:attribute name="role">payee</xsl:attribute>
                                    <Name>
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when
                                                test="cac:PayeeParty/cac:PartyName/cbc:Name != ''">
                                                <xsl:value-of
                                                  select="cac:PayeeParty/cac:PartyName/cbc:Name"/>
                                            </xsl:when>
                                            <xsl:otherwise>Not Provided</xsl:otherwise>
                                        </xsl:choose>
                                    </Name>                                    

                                </Contact>
                                <xsl:if
                                    test="cac:PayeeParty/cac:PartyIdentification/cbc:ID != ''">
                                    <IdReference>
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of
                                                select="cac:PayeeParty/cac:PartyIdentification/cbc:ID"
                                            />
                                        </xsl:attribute>
                                        <xsl:attribute name="domain">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="cac:PayeeParty/cac:PartyIdentification/cbc:ID/@schemeID = '0060'"
                                                    >DUNS</xsl:when>
                                                <xsl:when
                                                    test="cac:PayeeParty/cac:PartyIdentification/cbc:ID/@schemeID = '0088'"
                                                    >EANID</xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of
                                                        select="cac:PayeeParty/cac:PartyIdentification/cbc:ID/@schemeID"
                                                    />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </IdReference>
                                </xsl:if>
                                
                                <!-- companyCode -->
                                <xsl:if
                                    test="cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID != ''">
                                    <IdReference>
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of
                                                select="cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID"
                                            />
                                        </xsl:attribute>
                                        <xsl:attribute name="domain">companyCode</xsl:attribute>
                                    </IdReference>
                                </xsl:if>
                            </InvoicePartner>
                        </xsl:if>

                        <!-- taxRepresentative -->
                        <xsl:if test="cac:TaxRepresentativeParty">
                            <InvoicePartner>
                                <Contact>
                                    <xsl:attribute name="role">taxRepresentative</xsl:attribute>

                                    <xsl:call-template name="CreateContact">
                                        <xsl:with-param name="partyInfo"
                                            select="cac:TaxRepresentativeParty"/>
                                        <xsl:with-param name="partyRole"
                                            select="'taxRepresentative'"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="CreateIdReference">
                                        <xsl:with-param name="partyInfo"
                                            select="cac:TaxRepresentativeParty"/>
                                        <xsl:with-param name="partyRole" select="'taxRepresentative'"/>
                                    </xsl:call-template>
                                </Contact>
                            </InvoicePartner>
                        </xsl:if>
                        <!--wireReceivingBank && receivingBank -->
                        <xsl:for-each select="cac:PaymentMeans">
                            <xsl:if test="cac:PayeeFinancialAccount">
                                <InvoicePartner>
                                    <Contact>
                                        <xsl:attribute name="role">wireReceivingBank</xsl:attribute>
                                        <Name>
                                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="cac:PayeeFinancialAccount/cbc:Name != ''">
                                                  <xsl:value-of
                                                  select="cac:PayeeFinancialAccount/cbc:Name"/>
                                                </xsl:when>
                                                <xsl:otherwise>Not Provided</xsl:otherwise>
                                            </xsl:choose>
                                        </Name>
                                    </Contact>
                                    <xsl:if test="cac:PayeeFinancialAccount/cbc:ID != ''">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                    select="cac:PayeeFinancialAccount/cbc:ID"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">ibanID</xsl:attribute>
                                        </IdReference>
                                    </xsl:if>
                                    <xsl:if test="cac:PayeeFinancialAccount/cbc:ID != ''">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                    select="cac:PayeeFinancialAccount/cbc:ID"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">accountID</xsl:attribute>
                                        </IdReference>
                                    </xsl:if>
                                    <xsl:if test="cac:PayeeFinancialAccount/cbc:Name != ''">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                    select="cac:PayeeFinancialAccount/cbc:Name"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain"
                                                >accountName</xsl:attribute>
                                        </IdReference>
                                    </xsl:if>
                                    <xsl:if
                                        test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID != ''">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                    select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"
                                                />
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">swiftID</xsl:attribute>
                                        </IdReference>
                                    </xsl:if>
                                </InvoicePartner>
                            </xsl:if>
                            <!-- receivingBank -->
                            <!--<xsl:if test="cac:PaymentMandate">
                                <InvoicePartner>
                                    <Contact>
                                        <xsl:attribute name="role">receivingBank</xsl:attribute>
                                        <Name>
                                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                                            <xsl:text>Not Provided</xsl:text>
                                        </Name>

                                        <xsl:if
                                            test="cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID != ''">
                                            <IdReference>
                                                <xsl:attribute name="identifier">
                                                  <xsl:value-of
                                                  select="cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID"
                                                  />
                                                </xsl:attribute>
                                                <xsl:attribute name="domain"
                                                  >accountID</xsl:attribute>
                                            </IdReference>
                                        </xsl:if>

                                        <xsl:if test="cac:PaymentMandate/cbc:ID != ''">
                                            <IdReference>
                                                <xsl:attribute name="identifier">
                                                  <xsl:value-of select="cac:PaymentMandate/cbc:ID"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="domain"
                                                  >bankRoutingID</xsl:attribute>
                                            </IdReference>
                                        </xsl:if>
                                    </Contact>
                                </InvoicePartner>
                            </xsl:if>-->
                        </xsl:for-each>

                        <!-- InvoiceIDInfo -->
                        <xsl:if
                            test="cac:BillingReference[1]/cac:InvoiceDocumentReference/cbc:ID != ''">
                            <InvoiceIDInfo>
                                <xsl:attribute name="invoiceID">
                                    <xsl:value-of
                                        select="cac:BillingReference[1]/cac:InvoiceDocumentReference/cbc:ID"
                                    />
                                </xsl:attribute>
                                <xsl:if
                                    test="cac:BillingReference[1]/cac:InvoiceDocumentReference/cbc:IssueDate">
                                    <xsl:attribute name="invoiceDate">
                                        <xsl:call-template name="formatDate">
                                            <xsl:with-param name="DocDate"
                                                select="cac:BillingReference[1]/cac:InvoiceDocumentReference/cbc:IssueDate"
                                            />
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </xsl:if>
                            </InvoiceIDInfo>
                        </xsl:if>                       
                        <!-- InvoiceDetailShipping -->
                        <xsl:if test="cac:Delivery">
                            <InvoiceDetailShipping>
                                <!-- shipTo -->
                                <Contact>
                                    <xsl:attribute name="role">shipTo</xsl:attribute>
                                    <xsl:if test="normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID) != '' and normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID/@schemeID) != ''">
                                        <xsl:if
                                            test="normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID) != ''">
                                            <xsl:attribute name="addressID">
                                                <xsl:value-of
                                                    select="cac:Delivery/cac:DeliveryLocation/cbc:ID"
                                                />
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if
                                            test="normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID/@schemeID) != ''">
                                            <xsl:attribute name="addressIDDomain">
                                                <xsl:value-of
                                                    select="cac:Delivery/cac:DeliveryLocation/cbc:ID/@schemeID"
                                                />
                                            </xsl:attribute>
                                        </xsl:if>
                                    </xsl:if>
                                    <Name>
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when
                                                test="cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name != ''">
                                                <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>Not Provided</xsl:otherwise>
                                        </xsl:choose>
                                    </Name>
                                    <PostalAddress>
                                        <xsl:choose>
                                            <xsl:when
                                                test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName != '' or cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName != '' or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine != '' or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line != ''">
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName"
                                                  />
                                                  </Street>
                                                </xsl:if>
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"
                                                  />
                                                  </Street>
                                                </xsl:if>
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line"
                                                  />
                                                  </Street>
                                                </xsl:if>
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine"
                                                  />
                                                  </Street>
                                                </xsl:if>

                                            </xsl:when>
                                            <xsl:otherwise>
                                                <Street> </Street>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <City>
                                            <xsl:value-of
                                                select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName"
                                            />
                                        </City>
                                        <State>
                                            <xsl:value-of
                                                select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity"
                                            />
                                        </State>
                                        <xsl:if
                                            test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone != ''">
                                            <PostalCode>
                                                <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone"
                                                />
                                            </PostalCode>
                                        </xsl:if>
                                        <Country>
                                            <xsl:attribute name="isoCountryCode">
                                                <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"
                                                />
                                            </xsl:attribute>
                                            <xsl:variable name="isoCountry">
                                                <xsl:value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"/>
                                            </xsl:variable>
                                            <xsl:if test="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode != ''">
                                                <xsl:value-of select="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode"/>
                                            </xsl:if>
                                        </Country>
                                    </PostalAddress>
                                    <!--<xsl:if test="cac:Delivery/cac:DeliveryLocation/cbc:ID != ''">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cbc:ID"
                                                />
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">EANID</xsl:attribute>
                                        </IdReference>
                                    </xsl:if>-->
                                </Contact>
                                <!-- shipFrom -->
                                <Contact>
                                    <xsl:attribute name="role">shipFrom</xsl:attribute>
                                    <xsl:if test="normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID) != '' and normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID/@schemeID) != ''">
                                        <xsl:if
                                            test="normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID) != ''">
                                            <xsl:attribute name="addressID">
                                                <xsl:value-of
                                                    select="cac:Delivery/cac:DeliveryLocation/cbc:ID"
                                                />
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if
                                            test="normalize-space(cac:Delivery/cac:DeliveryLocation/cbc:ID/@schemeID) != ''">
                                            <xsl:attribute name="addressIDDomain">
                                                <xsl:value-of
                                                    select="cac:Delivery/cac:DeliveryLocation/cbc:ID/@schemeID"
                                                />
                                            </xsl:attribute>
                                        </xsl:if>
                                    </xsl:if>
                                    <Name>
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>Not
                                        Provided</Name>
                                    <PostalAddress>
                                        <xsl:choose>
                                            <xsl:when
                                                test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName != '' or cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName != '' or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine != '' or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line != ''">
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName"
                                                  />
                                                  </Street>
                                                </xsl:if>
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"
                                                  />
                                                  </Street>
                                                </xsl:if>
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line"
                                                  />
                                                  </Street>
                                                </xsl:if>
                                                <xsl:if
                                                  test="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine != ''">
                                                  <Street>
                                                  <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine"
                                                  />
                                                  </Street>
                                                </xsl:if>

                                            </xsl:when>
                                            <xsl:otherwise>
                                                <Street> </Street>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <City>
                                            <xsl:value-of
                                                select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName"
                                            />
                                        </City>
                                        <State>
                                            <xsl:value-of
                                                select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity"
                                            />
                                        </State>
                                        <xsl:if
                                            test="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone != ''">
                                            <PostalCode>
                                                <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone"
                                                />
                                            </PostalCode>
                                        </xsl:if>
                                        <Country>
                                            <xsl:attribute name="isoCountryCode">
                                                <xsl:value-of select="cac:AdditionalDocumentReference[cbc:DocumentDescription = 'ShipFromCountryCode']/cbc:ID"/>
                                            </xsl:attribute>
                                            <xsl:variable name="isoCountry">
                                                <xsl:value-of select="cac:AdditionalDocumentReference[cbc:DocumentDescription = 'ShipFromCountryCode']/cbc:ID"/>
                                            </xsl:variable>
                                            <xsl:if test="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode != ''">
                                                <xsl:value-of select="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode"/>
                                            </xsl:if>
                                        </Country>                                        
                                    </PostalAddress>
                                    <!--<xsl:if test="cac:Delivery/cac:DeliveryLocation/cbc:ID != ''">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                  select="cac:Delivery/cac:DeliveryLocation/cbc:ID"
                                                />
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">EANID</xsl:attribute>
                                        </IdReference>
                                    </xsl:if>-->
                                </Contact>
                            </InvoiceDetailShipping>
                        </xsl:if>
                        <!-- ShipNoticeIDInfo -->
                        <xsl:if test="cac:DespatchDocumentReference/cbc:ID != ''">
                            <ShipNoticeIDInfo>
                                <xsl:attribute name="shipNoticeID">
                                    <xsl:value-of select="cac:DespatchDocumentReference/cbc:ID"/>
                                </xsl:attribute>                                
                            </ShipNoticeIDInfo>
                        </xsl:if>
                        <!-- PaymentTerm -->
                        <xsl:if test="$BIS_Invoice = 'xrechnung' and cac:PaymentTerms/cbc:Note!=''">
                                <xsl:for-each select="tokenize(cac:PaymentTerms/cbc:Note),'#'">
                                    <xsl:if test="string-length(.)>1">
                                           <PaymentTerm>                                                                                                  
                                                    <xsl:if test="contains(.,'TAGE')">
                                                        <xsl:variable name="days">
                                                            <xsl:value-of select="substring-before(substring-after(substring-after(.,'TAGE'),'='),'#')"/>
                                                        </xsl:variable>
                                                        <xsl:variable name="percent">
                                                            <xsl:value-of select="substring-before(substring-after(substring-after(.,'PROZENT'),'='),'#')"/>
                                                        </xsl:variable>
                                                        <xsl:attribute name="payInNumberOfDays"><xsl:value-of select="$days"/></xsl:attribute>
                                                        <Discount>
                                                            <xsl:choose>
                                                                    <xsl:when test="contains(.,'SKONTO')">
                                                                        <DiscountPercent>
                                                                            <xsl:attribute name="percent"><xsl:value-of select="$percent"/></xsl:attribute>
                                                                        </DiscountPercent>
                                                                    </xsl:when>
                                                                <xsl:when test="contains(.,'VERZUG')">
                                                                    <DiscountPercent>
                                                                        <xsl:attribute name="percent"><xsl:value-of select=" concat('-',$percent)"/></xsl:attribute>
                                                                    </DiscountPercent>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </Discount>
                                                    </xsl:if>                                                
                                            </PaymentTerm>
                                    </xsl:if>
                                </xsl:for-each>
                        </xsl:if>                       
                        <!-- Period -->
                        <xsl:if
                            test="cac:InvoicePeriod/cbc:StartDate != '' and cac:InvoicePeriod/cbc:EndDate != ''">
                            <Period>
                                <xsl:attribute name="startDate">
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="DocDate"
                                            select="cac:InvoicePeriod/cbc:StartDate"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="endDate">
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="DocDate"
                                            select="cac:InvoicePeriod/cbc:EndDate"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </Period>
                        </xsl:if>

                        <!-- Comments -->
                        <xsl:if test="cbc:Note != '' or $cXMLAttachments != '' or $BIS_Invoice!=''">
                            <Comments>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="'en'"/>
                                </xsl:attribute>
                                <xsl:value-of select="cbc:Note"/>
                                <xsl:if test="$cXMLAttachments != ''">
                                    <xsl:variable name="tokenizedAttachments"
                                        select="tokenize($cXMLAttachments, $attachSeparator)"/>
                                    <xsl:for-each select="$tokenizedAttachments">
                                        <xsl:if test="normalize-space(.) != ''">
                                            <Attachment>
                                                <URL>
                                                  <xsl:value-of select="."/>
                                                </URL>
                                            </Attachment>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </Comments>
                        </xsl:if>

                        <!-- IdReference -->
                        <!-- Extrinsic -->                        
                        <xsl:if
                            test="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID != ''">
                            <xsl:element name="Extrinsic">
                                <xsl:attribute name="name"
                                    >supplierCommercialIdentifier</xsl:attribute>
                                <xsl:value-of
                                    select="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"
                                />
                            </xsl:element>
                        </xsl:if>
                        <xsl:if
                            test="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID != '' and cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/@schemeID!='9930'">
                            <xsl:element name="Extrinsic">
                                <xsl:attribute name="name">buyerVatID</xsl:attribute>
                                <xsl:value-of
                                    select="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID"
                                />
                            </xsl:element>
                        </xsl:if>

                        <xsl:if test="cac:PaymentTerms/cbc:Note != ''">
                            <xsl:element name="Extrinsic">
                                <xsl:attribute name="name">paymentTermsNote</xsl:attribute>
                                <xsl:value-of select="cac:PaymentTerms/cbc:Note"/>
                            </xsl:element>
                        </xsl:if>

                        <xsl:for-each select="cac:PaymentMeans">
                            <xsl:variable name="payMethod"
                                select="normalize-space(cbc:PaymentMeansCode)"/>
                            <xsl:if test="$payMethod != ''">
                                <Extrinsic>
                                    <xsl:attribute name="name">paymentMethod</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$Lookup/Lookups/PaymentMeansCodes/PaymentMeansCode[UBL = $payMethod]/CXMLCode != ''">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/PaymentMeansCodes/PaymentMeansCode[UBL = $payMethod]/CXMLCode"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>other</xsl:otherwise>
                                    </xsl:choose>
                                </Extrinsic>
                            </xsl:if>
                            <xsl:if test="cbc:PaymentID != ''">
                                <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">paymentReference</xsl:attribute>
                                    <xsl:value-of select="cbc:PaymentID"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if
                            test="cac:AdditionalDocumentReference[cbc:ID/@schemeID = 'ZZZ']/cbc:ID != '' and cac:AdditionalDocumentReference[cbc:ID/@schemeID = 'ZZZ']/cbc:DocumentDescription != ''">
                            <xsl:element name="Extrinsic">
                                <xsl:attribute name="name">
                                    <xsl:value-of
                                        select="cac:AdditionalDocumentReference[cbc:ID/@schemeID = 'ZZZ']/cbc:DocumentDescription"
                                    />
                                </xsl:attribute>
                                <xsl:value-of
                                    select="cac:AdditionalDocumentReference[cbc:ID/@schemeID = 'ZZZ']/cbc:ID"
                                />
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="cac:Delivery/cbc:ActualDeliveryDate != ''">
                            <xsl:element name="Extrinsic">
                                <xsl:attribute name="name">deliveryDate</xsl:attribute>
                                <xsl:call-template name="formatDate">
                                    <xsl:with-param name="DocDate"
                                        select="cac:Delivery/cbc:ActualDeliveryDate"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:if>

                        <Extrinsic name="invoiceSourceDocument">
                            <xsl:choose>
                                <xsl:when test="cac:OrderReference/cbc:ID != ''">
                                    <xsl:text>PurchaseOrder</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>NoOrderInformation</xsl:otherwise>
                            </xsl:choose>
                        </Extrinsic>                        
                        <Extrinsic name="invoiceSubmissionMethod">LegalDocumentViaXML</Extrinsic>
                        <Extrinsic name="taxInvoiceRepresentation">Tax</Extrinsic>
                        <Extrinsic name="taxInvoiceFormat">XML</Extrinsic>
                        <xsl:if test="$BIS_Invoice = 'peppol'">                            
                            <Extrinsic name="taxInvoiceAttachmentName">cid:PeppolUBL</Extrinsic>
                        </xsl:if>
                        <xsl:if test="$BIS_Invoice = 'xrechnung'">                            
                            <Extrinsic name="taxInvoiceAttachmentName">cid:X_RECHNUNG</Extrinsic>
                        </xsl:if>
                        
                        <xsl:if
                            test="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID != ''and cac:AccountingSupplierParty/cac:Party/cbc:EndpointID/@schemeID!='9930'">
                            <xsl:element name="Extrinsic">
                                <xsl:attribute name="name">supplierVatID</xsl:attribute>
                                <xsl:value-of
                                    select="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID"
                                />
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="($BIS_Invoice = 'xrechnung' and cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/@schemeID!='0204') and cbc:BuyerReference!=''">
                            <Extrinsic name="buyerLeitwegID">
                                <xsl:value-of select="cbc:BuyerReference"/>
                            </Extrinsic>
                        </xsl:if>
                        <xsl:if test="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/@schemeID ='0204'">
                            <Extrinsic name="buyerLeitwegID">
                                <xsl:value-of select="cac:AccountingCustomerParty/cac:Party[cbc:EndpointID/@schemeID ='0204']/cbc:EndpointID"/>
                            </Extrinsic>
                        </xsl:if>
                        <xsl:if test="$BIS_Invoice = 'peppol' and cac:PaymentTerms/cbc:Note!=''">                            
                            <Extrinsic name="discountInformation"><xsl:value-of select="cac:PaymentTerms/cbc:Note"/></Extrinsic>
                            <Extrinsic name="netTermInformation"><xsl:value-of select="cac:PaymentTerms/cbc:Note"/></Extrinsic>
                        </xsl:if>
                        <xsl:if test="$BIS_Invoice = 'xrechnung' and   contains(cac:PaymentTerms/cbc:Note,'#')">                            
                            <Extrinsic name="discountInformation"><xsl:value-of select="cac:PaymentTerms/cbc:Note"/></Extrinsic>
                            <Extrinsic name="netTermInformation"><xsl:value-of select="cac:PaymentTerms/cbc:Note"/></Extrinsic>
                        </xsl:if>
                    </InvoiceDetailRequestHeader>
                    <InvoiceDetailOrder>
                        <!-- InvoiceDetailOrderInfo -->
                        <InvoiceDetailOrderInfo>
                            <xsl:if test="cac:OrderReference/cbc:ID != ''">
                                <OrderReference>
                                    <xsl:attribute name="orderID">
                                        <xsl:value-of select="cac:OrderReference/cbc:ID"/>
                                    </xsl:attribute>
                                    <DocumentReference>
                                        <xsl:attribute name="payloadID"> </xsl:attribute>
                                    </DocumentReference>
                                </OrderReference>
                            </xsl:if>
                            <xsl:if test="cac:ContractDocumentReference/cbc:ID != ''">
                                <MasterAgreementReference>
                                    <xsl:attribute name="agreementID">
                                        <xsl:value-of select="cac:ContractDocumentReference/cbc:ID"
                                        />
                                    </xsl:attribute>
                                    <DocumentReference>
                                        <xsl:attribute name="payloadID"> </xsl:attribute>
                                    </DocumentReference>
                                </MasterAgreementReference>
                            </xsl:if>
                            <xsl:if test="cac:OrderReference/cbc:SalesOrderID != ''">
                                <SupplierOrderInfo>
                                    <xsl:attribute name="orderID">
                                        <xsl:value-of select="cac:OrderReference/cbc:SalesOrderID"/>
                                    </xsl:attribute>
                                </SupplierOrderInfo>
                            </xsl:if>
                        </InvoiceDetailOrderInfo>
                        <!-- InvoiceDetailReceiptInfo -->
                        <xsl:if test="cac:ReceiptDocumentReference/cbc:ID">
                            <InvoiceDetailReceiptInfo>
                                <ReceiptReference>
                                    <xsl:attribute name="receiptID">
                                        <xsl:value-of select="cac:ReceiptDocumentReference/cbc:ID"/>
                                    </xsl:attribute>
                                    <DocumentReference>
                                        <xsl:attribute name="payloadID"> </xsl:attribute>
                                    </DocumentReference>
                                </ReceiptReference>
                            </InvoiceDetailReceiptInfo>
                        </xsl:if>

                        <!-- InvoiceDetailShipNoticeInfo -->
                        <xsl:if
                            test="cac:InvoiceLine[1]/cac:DocumentReference[cbc:ID/@schemeID = 'MA']/cbc:ID != ''">
                            <InvoiceDetailShipNoticeInfo>
                                <ShipNoticeReference>
                                    <xsl:attribute name="shipNoticeID">
                                        <xsl:value-of
                                            select="cac:InvoiceLine[1]/cac:DocumentReference[cbc:ID/@schemeID = 'MA']/cbc:ID"
                                        />
                                    </xsl:attribute>
                                    <DocumentReference>
                                        <xsl:attribute name="payloadID"> </xsl:attribute>
                                    </DocumentReference>
                                </ShipNoticeReference>
                            </InvoiceDetailShipNoticeInfo>
                        </xsl:if>
                        <!-- InvoiceDetailItem -->
                        <xsl:for-each select="cac:InvoiceLine">                            
                            <xsl:choose>
                                <!-- InvoiceDetailServiceItem -->
                                <xsl:when test="exists(cac:InvoicePeriod)">
                                    <InvoiceDetailServiceItem>
                                        <xsl:call-template name="LineItem">
                                            <xsl:with-param name="itemMode" select="'InvoiceDetailServiceItem'"/>
                                            <xsl:with-param name="invType" select="$invType"/>
                                            <!-- Invoice or Cerdit Note -->
                                            <xsl:with-param name="Type" select="'Invoice'"/>
                                        </xsl:call-template>
                                    </InvoiceDetailServiceItem>
                                </xsl:when>
                                <!-- InvoiceDetailItem -->
                                <xsl:otherwise>
                                    <InvoiceDetailItem>
                                        <xsl:call-template name="LineItem">
                                            <xsl:with-param name="itemMode" select="'InvoiceDetailItem'"/>
                                            <xsl:with-param name="invType" select="$invType"/>
                                            <!-- Invoice or Cerdit Note -->
                                            <xsl:with-param name="Type" select="'Invoice'"/>
                                        </xsl:call-template>
                                    </InvoiceDetailItem>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        
                        
                    </InvoiceDetailOrder>

                    <!-- InvoiceDetailSummary -->
                    <InvoiceDetailSummary>

                        <xsl:call-template name="InvoiceDetailSummary">
                            <xsl:with-param name="invType" select="$invType"/>
                            <!-- Invoice or Cerdit Note -->
                            <xsl:with-param name="Type" select="'Invoice'"/>
                        </xsl:call-template>


                    </InvoiceDetailSummary>

                </InvoiceDetailRequest>
            </Request>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
