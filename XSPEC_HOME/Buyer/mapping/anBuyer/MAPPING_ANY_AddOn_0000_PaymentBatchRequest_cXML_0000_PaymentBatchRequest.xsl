<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:n0="http://sap.com/xi/SAPGlobal20/Global" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--Parameters-->
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anTargetDocumentType"/>
	<xsl:param name="anPayloadID"/>

<!--    <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
        <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <!--PD path  -->
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--DefaultLanguage-->
    <xsl:variable name="v_lang">
        <xsl:variable name="v_defLang">
            <xsl:call-template name="FillDefaultLang">
                <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($v_defLang)) > 0">
                <xsl:value-of select="$v_defLang"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'en'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="n0:CollectivePaymentOrderBulkRequest">
    <Combined>
       <Payload> 
        <cXML>
            <xsl:attribute name="payloadID" select="$anPayloadID"/>
            <xsl:attribute name="timestamp" select="current-dateTime()"/>
            <Header>
                <From>
                    <xsl:call-template name="MultiERPTemplateOut">
                        <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                    </xsl:call-template>
                    <Credential>
                        <xsl:attribute name="domain">
                            <xsl:value-of select="'NetworkID'"/>
                        </xsl:attribute>
                        <Identity>
                            <xsl:value-of select="$anSupplierANID"/>
                        </Identity>
                    </Credential>
                    <!--End Point Fix for CIG-->
                    <Credential>
                        <xsl:attribute name="domain">
                            <xsl:value-of select="'EndPointID'"/>
                        </xsl:attribute>
                        <Identity>CIG</Identity>
                    </Credential> 
                </From>
                <To>
                    <Credential>
                        <xsl:attribute name="domain">
                            <xsl:value-of select="'NetworkID'"/>
                        </xsl:attribute>
                        <Identity>
                            <xsl:value-of
                                select="$anSupplierANID"
                            />
                        </Identity>
                    </Credential>
                </To>
                <Sender>
                    <Credential domain="NetworkID">
                        <xsl:attribute name="domain">
                            <xsl:value-of select="'NetworkID'"/>
                        </xsl:attribute>
                        <Identity>
                            <xsl:value-of select="$anProviderANID"/>
                        </Identity>
                    </Credential>
                    <UserAgent/>
                </Sender>
            </Header>
            <Request>
                <PaymentBatchRequest>
                    <PaymentBatchRequestHeader>
                        <xsl:attribute name="batchID">
                            <xsl:value-of
                                select="normalize-space(concat(CollectivePaymentOrderRequestMessage[1]/CollectivePaymentOrder/ID/@schemeID,CollectivePaymentOrderRequestMessage[1]/CollectivePaymentOrder/ID))"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="paymentDate">
                            <xsl:call-template name="ANDateTime">
                                <xsl:with-param name="p_date"
                                    select='translate(substring(CollectivePaymentOrderRequestMessage[1]/CollectivePaymentOrder/PaymentExecutionDate, 1, 10), "-","")'/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="creationDate">
                            <xsl:value-of
                                select="concat(CollectivePaymentOrderRequestMessage[1]/MessageHeader/CreationDateTime, $anERPTimeZone)"
                            />
                        </xsl:attribute>
                        <PaymentMethod>
                            <xsl:attribute name="type" select="'other'"/>
                            <Description>
                                <xsl:attribute name="xml:lang" select="$v_lang"/>
                                <xsl:if test="string-length(normalize-space(CollectivePaymentOrderRequestMessage[1]/CollectivePaymentOrder/ID/@schemeAgencyID))>0">
                                <ShortName>
                                    <xsl:value-of
                                        select="CollectivePaymentOrderRequestMessage[1]/CollectivePaymentOrder/ID/@schemeAgencyID"
                                    />
                                </ShortName>
                                </xsl:if>
                            </Description>
                        </PaymentMethod>
                        <xsl:if test=" count(distinct-values(CollectivePaymentOrderRequestMessage/CollectivePaymentOrder/PaymentOrder/PaymentExplanationItem/NetAmount/normalize-space(@currencyCode)))>1">
                        <Extrinsic name="isMultiCurrency">
                            <xsl:value-of select="'yes'"/>
                        </Extrinsic>
                        </xsl:if>
                    </PaymentBatchRequestHeader>
                    <PaymentBatchSummary>
                        <ControlSum>
                            <xsl:value-of
                                select="format-number(sum(CollectivePaymentOrderRequestMessage/CollectivePaymentOrder/PaymentOrder/PaymentExplanationItem/NetAmount), '#0.00')"
                            />
                        </ControlSum>
                        <NumberOfPayments>
                            <xsl:value-of
                                select="count(CollectivePaymentOrderRequestMessage/CollectivePaymentOrder/PaymentOrder)"
                            />
                        </NumberOfPayments>
                    </PaymentBatchSummary>
                    <xsl:for-each
                        select="CollectivePaymentOrderRequestMessage/CollectivePaymentOrder/PaymentOrder">
                        <PaymentRemittanceRequest>
                            <PaymentRemittanceRequestHeader>
                                <xsl:attribute name="paymentRemittanceID"
                                    select="substring(PaymentReference/ID, 5, 10)"/>
                                <xsl:attribute name="paymentDate">
                                    <xsl:call-template name="ANDateTime">
                                        <xsl:with-param name="p_date"
                                            select='translate(substring(../PaymentExecutionDate[1], 1, 10), "-","")'/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="status" select="'new'"/>
                                <xsl:attribute name="companyCode"
                                    select="../PaymentTransactionInitiatorParty/InternalID"/>
                                <PaymentMethod>
                                    <xsl:attribute name="type" select="'other'"/>
                                    <Description>
                                        <xsl:attribute name="xml:lang" select="$v_lang"/>
                                        <xsl:if test="string-length(normalize-space(../ID/@schemeAgencyID))>0">
                                        <ShortName>
                                            <xsl:value-of select="../ID/@schemeAgencyID"/>
                                        </ShortName>
                                        </xsl:if>
                                    </Description>
                                </PaymentMethod>
                                <xsl:variable name="v_bank_cntry">
                                    <xsl:value-of
                                        select="PaymentTransactionDestinatedBankAccount/Bank/CountryCode"
                                    />
                                </xsl:variable>                                

                                <!--PaymentPartner role payer-->
                                <PaymentPartner>
                                    <!--Contact-->
                                    <xsl:call-template name="Contact">
                                        <xsl:with-param name="p_role" select="'payer'"/>
                                        <xsl:with-param name="p_addr"
                                            select="../PaymentTransactionInitiatorParty"/>
                                    </xsl:call-template>
                                    
                                    <xsl:if
                                        test="string-length(normalize-space(../PaymentTransactionInitiatorParty/TaxID)) > 0">
                                        <IdReference>
                                            <xsl:attribute name="identifier"
                                                select="../PaymentTransactionInitiatorParty/TaxID"/>
                                            <xsl:attribute name="domain"
                                                select="'federalTaxId'"/>
                                        </IdReference>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(../PaymentTransactionInitiatorBankAccount/ID)) > 0">
                                    <IdReference>
                                        <xsl:attribute name="identifier"
                                            select="../PaymentTransactionInitiatorBankAccount/ID"/>
                                        <xsl:attribute name="domain" select="'bankAccountID'"/>
                                    </IdReference>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(../PaymentTransactionInitiatorBankAccount/StandardID)) > 0">
                                        <IdReference>
                                            <xsl:attribute name="identifier"
                                                select="../PaymentTransactionInitiatorBankAccount/StandardID"/>
                                            <xsl:attribute name="domain" select="'ibanID'"/>
                                        </IdReference>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(PaymentInstruction/ID[@schemeID='CLIENTID'])) > 0">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of select="PaymentInstruction/ID[@schemeID='CLIENTID']"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain" select="'accountID'"/>
                                        </IdReference>
                                        </xsl:if>
                                    <xsl:if test="string-length(normalize-space(PaymentInstruction/ID[@schemeID='CRN_PAYER'])) > 0">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of select="PaymentInstruction/ID[@schemeID='CRN_PAYER']"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain" select="'companyRegistrationNumber'"/>
                                        </IdReference>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(../PaymentTransactionInitiatorBankAccount/CurrencyCode)) > 0">
                                        <AccountCurrency>
                                            <xsl:attribute name="code" 
                                                select="../PaymentTransactionInitiatorBankAccount/CurrencyCode"/>  
                                        </AccountCurrency>
                                    </xsl:if>                                    
                                </PaymentPartner>

                                <!--PaymentPartner role payee-->
                                <xsl:if
                                    test="string-length(normalize-space(PaymentTransactionDestinatedParty)) > 0">
                                    <PaymentPartner>

                                        <!--Contact-->
                                        <xsl:call-template name="Contact">
                                            <xsl:with-param name="p_role" select="'payee'"/>
                                            <xsl:with-param name="p_addr"
                                                select="PaymentTransactionDestinatedParty"/>                                                        
                                        </xsl:call-template>
                                        
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedParty/TaxID)) > 0">
                                            <IdReference>
                                                <xsl:attribute name="identifier"
                                                    select="PaymentTransactionDestinatedParty/TaxID"/>
                                                <xsl:attribute name="domain"
                                                    select="'federalTaxID'"/>
                                            </IdReference>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount/ID)) > 0">
                                            <IdReference>
                                                <xsl:attribute name="identifier"
                                                  select="PaymentTransactionDestinatedBankAccount/ID"/>
                                                <xsl:attribute name="domain"
                                                  select="'bankAccountID'"/>
                                            </IdReference>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedParty/PaymentTransactionDestinatedID)) > 0">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                  select="PaymentTransactionDestinatedParty/PaymentTransactionDestinatedID"
                                                />
                                            </xsl:attribute>
                                            <xsl:attribute name="domain" select="'VendorID'"/>
                                        </IdReference>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount/StandardID)) > 0">
                                            <IdReference>
                                                <xsl:attribute name="identifier">
                                                  <xsl:value-of
                                                  select="PaymentTransactionDestinatedBankAccount/StandardID"
                                                  />
                                                </xsl:attribute>
                                                <xsl:attribute name="domain" select="'ibanID'"/>
                                            </IdReference>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(PaymentInstruction/ID[@schemeID = 'CRN'])) > 0">
                                            <IdReference>
                                                <xsl:attribute name="identifier">
                                                    <xsl:value-of
                                                    select="PaymentInstruction/ID[@schemeID = 'CRN']"
                                                    />
                                                </xsl:attribute>
                                                <xsl:attribute name="domain" select="'companyRegistrationNumber'"/>
                                            </IdReference>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(PaymentInstruction/ID[@schemeID = 'BUSTYPE'])) > 0">
                                            <NatureOfBusiness>
                                                <xsl:value-of
                                                select="PaymentInstruction/ID[@schemeID = 'BUSTYPE']"
                                                />
                                            </NatureOfBusiness>
                                        </xsl:if>    
                                        <xsl:if test="string-length(normalize-space(PaymentInstruction/ID[@schemeID = 'INDTYPE'])) > 0">
                                            <IncorporationType>
                                                <xsl:value-of
                                                select="PaymentInstruction/ID[@schemeID = 'INDTYPE']"
                                                />
                                            </IncorporationType>
                                        </xsl:if>    
                                    </PaymentPartner>
                                </xsl:if>
                                <!--PaymentPartner role = originatingBank-->
                                <PaymentPartner>
                                    <!--Contact-->
                                    <xsl:call-template name="Contact">
                                        <xsl:with-param name="p_role" select="'originatingBank'"/>
                                        <xsl:with-param name="p_addr"
                                            select="../PaymentTransactionInitiatorBankAccount/Bank"
                                        />
                                    </xsl:call-template>
                                    <xsl:if
                                        test="string-length(normalize-space(../PaymentTransactionInitiatorBankAccount/Bank/RoutingID)) > 0">
                                        <IdReference>
                                            <xsl:attribute name="identifier"
                                                select="../PaymentTransactionInitiatorBankAccount/Bank/RoutingID"/>
                                            <xsl:attribute name="domain" select="'abaRoutingNumber'"
                                            />
                                        </IdReference>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(../PaymentTransactionInitiatorBankAccount/Bank/StandardID)) > 0">
                                        <IdReference>
                                            <xsl:attribute name="identifier"
                                                select="../PaymentTransactionInitiatorBankAccount/Bank/StandardID"/>
                                            <xsl:attribute name="domain" select="'swiftID'"/>
                                        </IdReference>
                                    </xsl:if>
                                    <IdReference>
                                        <xsl:attribute name="identifier" select="'checking'"/>
                                        <xsl:attribute name="domain" select="'accountType'"/>
                                    </IdReference>
                                </PaymentPartner>

                                <!--PaymentPartner role = receivingBank-->
                                <xsl:if
                                    test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount)) > 0">
                                    <PaymentPartner>
                                        <!--Contact-->
                                        <xsl:call-template name="Contact">
                                            <xsl:with-param name="p_role" select="'receivingBank'"/>
                                            <xsl:with-param name="p_addr"
                                                select="PaymentTransactionDestinatedBankAccount/Bank"
                                            />
                                        </xsl:call-template>
                                        <!-- Map bankRoutingID only for UK-->
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount/Bank/RoutingID))>0 and $v_bank_cntry = 'GB'">
                                            <IdReference>
                                                <xsl:attribute name="identifier"
                                                    select="PaymentTransactionDestinatedBankAccount/Bank/RoutingID"/>
                                                <xsl:attribute name="domain"
                                                    select="'bankRoutingID'"/>
                                            </IdReference>
                                        </xsl:if>                                        
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount/Bank/RoutingID))>0">
                                            <IdReference>
                                                <xsl:attribute name="identifier"
                                                  select="PaymentTransactionDestinatedBankAccount/Bank/RoutingID"/>
                                                <xsl:attribute name="domain"
                                                  select="'abaRoutingNumber'"/>
                                            </IdReference>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount/Bank/StandardID))>0">
                                            <IdReference>
                                                <xsl:attribute name="identifier"
                                                    select="PaymentTransactionDestinatedBankAccount/Bank/StandardID"/>
                                                <xsl:attribute name="domain" select="'isoBicID'"/>
                                            </IdReference>
                                        </xsl:if>                                        
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount/Bank/StandardID))>0">
                                            <IdReference>
                                                <xsl:attribute name="identifier"
                                                  select="PaymentTransactionDestinatedBankAccount/Bank/StandardID"/>
                                                <xsl:attribute name="domain" select="'swiftID'"/>
                                            </IdReference>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(PaymentTransactionDestinatedBankAccount/StandardID)) > 0">
                                            <IdReference>
                                                <xsl:attribute name="identifier">
                                                    <xsl:value-of 
                                                        select="PaymentTransactionDestinatedBankAccount/StandardID"
                                                    />
                                                </xsl:attribute>
                                                <xsl:attribute name="domain" select="'ibanID'"/>
                                            </IdReference>
                                        </xsl:if>                                        
                                        <IdReference>
                                            <xsl:attribute name="identifier" select="'checking'"/>
                                            <xsl:attribute name="domain" select="'accountType'"/>
                                        </IdReference>
                                    </PaymentPartner>                                    
                                </xsl:if>
<!--                                Partner Role =  payeeContact-->
                                <xsl:if test="string-length(normalize-space(PaymentInstruction/ID[@schemeID='SUPPLIERNAME'])) > 0">
                                    <PaymentPartner>
                                        <!--Contact-->
                                        <xsl:call-template name="Contact">
                                            <xsl:with-param name="p_role" select="'payeeContact'"/>
                                            <xsl:with-param name="p_addr" select = "PaymentInstruction/ID[@schemeID = 'SUPPLIERNAME']" />
                                        </xsl:call-template>
                                    </PaymentPartner>                                    
                                </xsl:if>
				<!-- IG-24092: The attribute 'code' must be populated fro mSource payload value as preference. Else it must be defaulted to 'other'-->
                                <xsl:if test="string-length(normalize-space(PaymentInstruction[1]/CodeDescription)) > 0">
                                    <PaymentPurpose>
                                        <xsl:attribute name="code">                                            
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(PaymentInstruction[1]/Code)) > 0">
                                                    <xsl:value-of select="PaymentInstruction[1]/Code"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'other'"/></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="PaymentInstruction[1]/CodeDescription">                                                   
                                        </xsl:value-of>
                                    </PaymentPurpose>
                                </xsl:if>
                            </PaymentRemittanceRequestHeader>
                            <PaymentRemittanceSummary>
                                <NetAmount>
                                    <Money>
                                        <xsl:attribute name="currency"
                                            select="PaymentExplanationItem[1]/NetAmount/@currencyCode"/>
                                        <xsl:value-of
                                            select="format-number(sum(PaymentExplanationItem/NetAmount), '#0.00')"
                                        />
                                    </Money>
                                </NetAmount>
                                <GrossAmount>
                                    <Money>
                                        <xsl:attribute name="currency"
                                            select="PaymentExplanationItem[1]/GrossAmount/@currencyCode"/>
                                        <xsl:value-of
                                            select="format-number(sum(PaymentExplanationItem/GrossAmount), '#0.00')"
                                        />
                                    </Money>
                                </GrossAmount>
                                <xsl:if test="string-length(normalize-space(PaymentExplanationItem[1]/CashDiscountAmount))>0">
                                    <DiscountAmount>
                                        <Money>
                                            <xsl:attribute name="currency"
                                                select="PaymentExplanationItem[1]/CashDiscountAmount/@currencyCode"/>
                                            <xsl:value-of
                                                select="format-number(sum(PaymentExplanationItem/CashDiscountAmount), '#0.00')"
                                            />
                                        </Money>
                                    </DiscountAmount>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(PaymentExplanationItem[1]/WithholdingTaxAmount))>0">
                                    <AdjustmentAmount>
                                        <Money>
                                            <xsl:attribute name="currency"
                                                select="PaymentExplanationItem[1]/WithholdingTaxAmount/@currencyCode"/>
                                            <xsl:value-of
                                                select="format-number(sum(PaymentExplanationItem/WithholdingTaxAmount), '#0.00')"
                                            />
                                        </Money>
                                    </AdjustmentAmount>
                                </xsl:if>
                            </PaymentRemittanceSummary>
                            <xsl:for-each select="PaymentExplanationItem">
                                <RemittanceDetail>
                                    <xsl:attribute name="lineNumber" select="position()"/>
                                    <!-- Begin of IG-17276 mapped referenceDocumentNumber with PaymentTransactionInitiatorInvoiceID. Earlier we were mapping with PaymentTransactionDestinatedInvoiceReference/ID -->                                    
                                    <xsl:if        
                                        test=" string-length(normalize-space(PaymentTransactionInitiatorInvoiceReference/ID)) > 0">
                                        <xsl:attribute name="referenceDocumentNumber"
                                            select="PaymentTransactionInitiatorInvoiceReference/ID"
                                        />
                                    </xsl:if>
                                    <!-- End of IG-17276 -->
                                    <xsl:attribute name="paymentProposalID"
                                        select="ScandinavianPaymentReferenceID"/>
                                    <PayableInfo>
                                        <PayableInvoiceInfo>                                           
                                            <InvoiceIDInfo>
                                                <!-- Begin of IG-18061 -->
                                                <xsl:attribute name="invoiceID">                                                
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space(PaymentTransactionDestinatedInvoiceReference/ID)) > 0">
                                                            <xsl:value-of
                                                                select="PaymentTransactionDestinatedInvoiceReference/ID"/>  <!-- Begin of IG-17166 mapped invoiceID with PaymentTransactionDestinatedInvoiceReference/ID. Earlier it was mapped with PaymentTransactionInitiatorInvoiceReference/ID -->
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of
                                                                select="PaymentTransactionInitiatorInvoiceReference/ID"/>
                                                        </xsl:otherwise>                                                    
                                                    </xsl:choose>
                                                </xsl:attribute> 
                                                <!-- End of IG-18061 -->                                                
                                                <xsl:attribute name="invoiceDate"
                                                  select="BusinessTransactionDocumentDate"/>
                                            </InvoiceIDInfo>
                                            <xsl:if test="string-length(normalize-space(PaymentTransactionInitiatorPurchaseOrderReference/ID)) > 0">
                                                <PayableOrderInfo>
                                                    <OrderIDInfo>
                                                        <xsl:attribute name="orderID"
                                                            select="PaymentTransactionInitiatorPurchaseOrderReference/ID"
                                                        />
                                                    </OrderIDInfo>
                                                </PayableOrderInfo>
                                            </xsl:if>
                                        </PayableInvoiceInfo>
                                    </PayableInfo>
                                    <NetAmount>
                                        <Money>
                                            <xsl:attribute name="currency"
                                                select="NetAmount/@currencyCode"/>
                                            <xsl:value-of select="NetAmount"/>
                                        </Money>
                                    </NetAmount>
                                    <GrossAmount>
                                        <Money>
                                            <xsl:attribute name="currency"
                                                select="GrossAmount/@currencyCode"/>
                                            <xsl:value-of select="GrossAmount"/>
                                        </Money>
                                    </GrossAmount>

                                    <xsl:if
                                        test="string-length(normalize-space(CashDiscountAmount)) > 0">
                                        <DiscountAmount>
                                            <Money>
                                                <xsl:attribute name="currency"
                                                  select="CashDiscountAmount/@currencyCode"/>
                                                <xsl:value-of select="CashDiscountAmount"/>
                                            </Money>
                                        </DiscountAmount>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(WithholdingTaxAmount)) > 0">
                                        <AdjustmentAmount>
                                            <Money>
                                                <xsl:attribute name="currency"
                                                  select="WithholdingTaxAmount/@currencyCode"/>
                                                <xsl:value-of select="WithholdingTaxAmount"/>
                                            </Money>
                                            <Modifications>
                                                <Modification>
                                                  <AdditionalDeduction>
                                                  <xsl:attribute name="type"
                                                  select="'withholdingTax'"/>
                                                  <DeductionAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency"
                                                  select="WithholdingTaxAmount/@currencyCode"/>
                                                  <xsl:value-of select="WithholdingTaxAmount"/>
                                                  </Money>
                                                  </DeductionAmount>
                                                  </AdditionalDeduction>
                                                </Modification>
                                            </Modifications>
                                        </AdjustmentAmount>
                                    </xsl:if>
                                </RemittanceDetail>
                            </xsl:for-each>
                        </PaymentRemittanceRequest>
                    </xsl:for-each>
                </PaymentBatchRequest>
            </Request>
        </cXML>
       </Payload>
    </Combined>
    </xsl:template>
    <xsl:template name="Contact">
        <xsl:param name="p_role"/>
        <xsl:param name="p_addr"/>

        <Contact>
            <xsl:attribute name="role" select="$p_role"/>
            <xsl:if test="$p_role = 'payer'">
                <xsl:attribute name="addressID"
                    select="../PaymentTransactionInitiatorParty/InternalID"/>
            </xsl:if>
            <Name>
                <xsl:attribute name="xml:lang" select="$v_lang"/>
                <xsl:choose>
                    <xsl:when test="$p_role = 'payeeContact'">
                        <xsl:value-of select="$p_addr"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$p_addr/Address/OrganisationFormattedName[1]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </Name>
            <xsl:if
                test="
                (string-length(normalize-space($p_addr/Address/PhysicalAddress/CountryCode)) > 0) and
                 (string-length(normalize-space($p_addr/Address/PhysicalAddress/StreetName)) > 0) and
                 (string-length(normalize-space($p_addr/Address/PhysicalAddress/CityName)) > 0) and
                ($p_role = 'payer' and string-length(normalize-space($p_addr/Address/OrganisationFormattedName[1])) > 0 or $p_role != 'payer' or
                $p_role = 'originatingBank' or $p_role = 'receivingBank')">
                <PostalAddress>
                    <DeliverTo>
                        <xsl:choose>
                            <xsl:when test="$p_role = 'payee'">
                                <xsl:value-of
                                    select="$p_addr/ContactPerson/Address/OrganisationFormattedName[1]"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$p_addr/Address/OrganisationFormattedName[1]"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </DeliverTo>
                    <Street>
                        <xsl:value-of select="$p_addr/Address/PhysicalAddress/StreetName"/>
                    </Street>
                    <City>
                        <xsl:value-of select="$p_addr/Address/PhysicalAddress/CityName"/>
                    </City>
                    <xsl:if test="string-length(normalize-space($p_addr/Address/PhysicalAddress/RegionCode))>0">
                    <State>
                        <xsl:value-of select="$p_addr/Address/PhysicalAddress/RegionCode"/>
                    </State>
                    </xsl:if>
                    <xsl:variable name="v_boxPostalCode" select="$p_addr/Address/PhysicalAddress/POBoxPostalCode"/>
                    <xsl:variable name="v_streetPostalCode" select="$p_addr/Address/PhysicalAddress/StreetPostalCode"/>
                    <xsl:if test="(string-length(normalize-space($v_boxPostalCode)) > 0 ) or 
                        (string-length(normalize-space($v_streetPostalCode)) > 0)">
                        <PostalCode>
                            <xsl:choose>
                                <xsl:when
                                    test="exists($p_addr/Address/PhysicalAddress/POBoxPostalCode)">
                                    <xsl:value-of
                                        select="$p_addr/Address/PhysicalAddress/POBoxPostalCode"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="$p_addr/Address/PhysicalAddress/StreetPostalCode"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </PostalCode>
                    </xsl:if>
                    <Country>
                        <xsl:attribute name="isoCountryCode"
                            select="$p_addr/Address/PhysicalAddress/CountryCode"/>
                        <xsl:value-of select="$p_addr/Address/PhysicalAddress/CountryCode"/>
                    </Country>
                </PostalAddress>
                <Email>
                    <xsl:value-of
                        select="./PaymentTransactionDestinatedParty/Address/Communication/Email/URI"
                    />
                </Email>
                <xsl:if test="string-length(normalize-space($p_addr/Address/Communication/Telephone[1]/Number/SubscriberID)) >0">
                    <Phone>
                        <TelephoneNumber>
                            <CountryCode>
                                <xsl:attribute name="isoCountryCode"
                                    select="$p_addr/Address/Communication/Telephone[1]/Number/CountryCode"/>
                                <xsl:value-of
                                    select="$p_addr/Address/Communication/Telephone[1]/Number/CountryCode"
                                />
                            </CountryCode>
                            <AreaOrCityCode/>
                            <Number>
                                <xsl:value-of
                                    select="$p_addr/Address/Communication/Telephone[1]/Number/SubscriberID"
                                />
                            </Number>
                        </TelephoneNumber>
                    </Phone>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($p_addr/Address/Communication/Facsimile[1]/Number/SubscriberID)) >0 ">
                    <Fax>
                        <TelephoneNumber>
                            <CountryCode>
                                <xsl:attribute name="isoCountryCode"
                                    select="$p_addr/Address/Communication/Facsimile[1]/Number/CountryCode"/>
                                <xsl:value-of
                                    select="$p_addr/Address/Communication/Facsimile[1]/Number/CountryCode"
                                />
                            </CountryCode>
                            <AreaOrCityCode/>
                            <Number>
                                <xsl:value-of
                                    select="$p_addr/Address/Communication/Facsimile[1]/Number/SubscriberID"
                                />
                            </Number>
                        </TelephoneNumber>
                    </Fax>
                </xsl:if>
            </xsl:if>
        </Contact>
    </xsl:template>
</xsl:stylesheet>
