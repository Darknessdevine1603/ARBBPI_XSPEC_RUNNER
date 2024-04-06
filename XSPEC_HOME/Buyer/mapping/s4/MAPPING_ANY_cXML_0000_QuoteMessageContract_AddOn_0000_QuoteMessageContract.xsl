<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="http://sap.com/xi/ARBCIG1"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <xsl:variable name="v_currDate">
        <xsl:value-of select="current-date()"/>
    </xsl:variable>

    <!-- Parameters -->
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anSourceDocumentType"/>
   <!-- <xsl:param name="PD_ref" select="v_pd"/>-->
  
    <xsl:param name="Document_type" select="'QuoteMessageContract'"/>
    <xsl:variable name="header" select="/Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader"/>

    <!--Local Testing-->
   <!-- <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
     <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>

    <!-- System ID incase of MultiERP -->
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="/Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
        </xsl:call-template>
    </xsl:variable>

    <!--PD path-->
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

    <!--Creation Date -->
    <xsl:variable name="v_createDate">
        <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="/Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>
    </xsl:variable>


    <!--Effective Date -->
    <xsl:variable name="v_effectiveDate">
        <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="/Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Expiration Date -->
    <xsl:variable name="v_expirationDate">
        <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="$header/@expirationDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Agreement Date -->
    <xsl:variable name="v_agreementDate">
        <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="$header/@agreementDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Language -->
    <xsl:variable name="v_lang">
       
        <xsl:value-of select="upper-case(/Combined/Payload/cXML/@xml:lang)"/>
    </xsl:variable>

    <!--    C r o s s - r e f e r e n c e s    -->

    <!--C o n d i t i o n     T y p e s -->

    <!--Gross Price -->
    <xsl:variable name="v_grossPrice">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="$Document_type"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'GrossPrice'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Discount Amount -->
    <xsl:variable name="v_deductionAmount">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="$Document_type"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'DeductionAmount'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Discount Percentage -->
    <xsl:variable name="v_deductionPercent">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="$Document_type"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'DeductionPercent'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Additional Cost Amount -->
    <xsl:variable name="v_additionalAmount">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="$Document_type"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'AdditionalMoney'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Additional Cost Percentage -->
    <xsl:variable name="v_additionalPercent">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="$Document_type"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'AdditionalPercent'"/>
        </xsl:call-template>
    </xsl:variable>
    <!--CI-1779 PrivateID / VendorID-->
    <!--If PrivateID is not available pass VendorID  -->
    <!--Either Privateid or VendorID should always Exists -->
    <xsl:variable name="v_privateid_exists">
        <xsl:value-of select="string-length(Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity)"/>
    </xsl:variable>
    <xsl:variable name="v_vendorId">
        <xsl:choose>
            <xsl:when test="$v_privateid_exists > 0">
                <xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="Combined">
        <n0:PurchasingContractERPCreateRequest>
            <MessageHeader>
                <CreationDateTime>
                    <xsl:value-of select="$v_createDate"/>
                </CreationDateTime>
                <!-- Sender Business System -->
                <!--<xsl:value-of select="Header/From/Credential[@domain = 'SystemID']/Identity"/>-->
                <SenderBusinessSystemID>
                    <xsl:value-of select="'SOURCING'"/>
                </SenderBusinessSystemID>
                <RecipientBusinessSystemID>					
                    <xsl:value-of select="$anERPSystemID"/>
                </RecipientBusinessSystemID>
                <!--Payload ID -->
                <AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <!-- Sender Party -->
                <SenderParty>
                    <InternalID>
                        <xsl:attribute name="schemeID">
                            <xsl:value-of select="'NetworkID'"/>
                        </xsl:attribute>
                        <xsl:attribute name="schemeagencyID">
                            <xsl:value-of select="'www.ariba.com'"/>
                        </xsl:attribute>
                        <xsl:value-of
                            select="Payload/cXML/Header/From/Credential[@domain = 'NetworkId']/Identity"/>
                    </InternalID>
                </SenderParty>
            </MessageHeader>
            <PurchasingContract>
                <!-- SAP Contract ID-->
                <ID>
                    <!--<xsl:value-of select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteID"/>-->
                </ID>
                <!-- Ariba Network Supplier ID-->
                <NetworkID>
                    <xsl:value-of
                        select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/OrganizationID/Credential[@domain = 'NetworkID']/Identity"/>
                </NetworkID>
                <!--Ariba Contract ID-->
                <xsl:if test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic/@name = 'SourcingEventId'">
                    <AribaContractID>
                        <xsl:value-of select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'SourcingEventId']"/>   
                    </AribaContractID>
                </xsl:if>
                <!--ERP System ID-->
                <SystemID>
                    <xsl:value-of select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
                </SystemID>
                <!--Creation Date and Time-->
                <CreationDateTime>
                    <xsl:value-of select="$v_createDate"/>
                </CreationDateTime>
                <Operation>
                    <xsl:value-of select="'01'"/>
                </Operation>
                <!-- Language -->
               <Language>
                    <xsl:value-of select="upper-case($v_lang)"/>
               </Language>
                <!-- Company Code -->
                <CompanyID>
                    <xsl:value-of
                        select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
                    />
                </CompanyID>
                <!-- Contract Document Type -->
                <!--Cross-reference   value-WK  quantity-MK-->
                <ProcessingTypeCode>
                    <xsl:value-of select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/FollowUpDocument/@category"/>
                </ProcessingTypeCode>
                <!--Validity Period-->                
                <!--<xsl:if test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate' or 'ValidityEndDate']">
                -->    <ValidityPeriod>
                    <StartDate>
                        <xsl:choose>
                            <xsl:when test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']">
                                
                                <xsl:variable name="v_date">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of select="substring($v_date, 1, 10)"/>
                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteDate,1,10)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </StartDate>
                        <EndDate>
                            <xsl:choose>
                                <xsl:when test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']">
                                    <xsl:variable name="v_date">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date" select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']"/>
                                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                    <xsl:value-of select="substring($v_date, 1, 10)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'9999-12-31'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </EndDate>
                    </ValidityPeriod>
                <!--</xsl:if>-->              
                <ExchangeRate>
                    <ExchangeRate>
                        <UnitCurrency>
                            <xsl:value-of
                                select="Payload/cXML/Message/QuoteMessage/QuoteItemIn[1]/ItemDetail/UnitPrice/Money/@currency"
                            />
                        </UnitCurrency>
                        <QuotedCurrency>
                            <xsl:value-of select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@currency"
                            />
                        </QuotedCurrency>
                        <Rate>
                            <xsl:value-of select="'0'"/>
                        </Rate>
                        <QuotationDateTime>
                            <xsl:value-of select="substring($v_agreementDate, 1, 10)"/>
                        </QuotationDateTime>
                    </ExchangeRate>
                    <ExchangeRateFixedIndicator>
                        <xsl:value-of select="'1'"/>
                    </ExchangeRateFixedIndicator>
                </ExchangeRate>
                <!-- Target Amount -->
                <TargetAmount>
                    <xsl:if test="(string-length(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Total/Money) > 0)">
                        <xsl:attribute name="currencyCode">
                            <xsl:value-of
                                select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Total/Money/@currency"
                            />
                        </xsl:attribute>
                        <xsl:value-of
                            select="normalize-space(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Total/Money)"/>
                    </xsl:if>
                </TargetAmount>
                <!-- Vendor -->
                <SellerParty>
                    <InternalID>
                        <xsl:value-of select="$v_vendorId"/>
                    </InternalID>
                </SellerParty>
                <!--Purchasing Organization -->
                <xsl:if
                    test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier != ''">
                    <ResponsiblePurchasingOrganisationParty>
                        <InternalID>
                            <xsl:value-of
                                select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier"
                            />
                        </InternalID>
                    </ResponsiblePurchasingOrganisationParty>
                </xsl:if>
                <xsl:if
                    test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier != ''">
                    <ResponsiblePurchasingGroupParty>
                        <InternalID>
                            <xsl:value-of
                                select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier"
                            />
                        </InternalID>
                    </ResponsiblePurchasingGroupParty>
                </xsl:if>
                <!--    CI-1844 : Populate the Contract Header Partners structure    --> 
                <xsl:if test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
                    <!--    Loop over the Header Partners and populate the Party structures   --> 
                    <xsl:for-each select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/SupplierProductionFacilityRelations/ProductionFacilityAssociation">                   
                        <Party>
                            <InternalID>
                                <xsl:value-of select="ProductionFacility/IdReference/@identifier"/>									
                            </InternalID> 
                            <ResponsiblePurchasingOrganisationParty>
                                <InternalID>
                                    <xsl:value-of select="OrganizationalUnit/IdReference/@identifier"/>
                                </InternalID>
                            </ResponsiblePurchasingOrganisationParty>                            
                            <RoleCode>
                                <xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
                            </RoleCode>
                            <DefaultIndicator></DefaultIndicator>
                        </Party>                   
                    </xsl:for-each>
                </xsl:if>                 
                <xsl:if test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/PaymentTerms)">
                <CashDiscountTerms>
                    <Code>
                        <xsl:value-of select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/PaymentTerms/@paymentTermCode"/>                       
                    </Code>
                </CashDiscountTerms>
                </xsl:if>
                <!-- Header Text-->
                
                <xsl:if test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Comments)">
                    <TextCollection>
                        <Text>
                            <TypeCode>
                                <xsl:value-of>
                                    <!--Cross-reference Ariba Text ID to SAP Text ID-->
                                    <xsl:call-template name="ReadQuote">
                                        <xsl:with-param name="p_doctype" select="$Document_type"/>
                                        <xsl:with-param name="p_pd" select="$v_pd"/>
                                        <xsl:with-param name="p_attribute"
                                            select="$header/Comments/@type"/>
                                    </xsl:call-template>
                                </xsl:value-of>
                            </TypeCode>
                            <ContentText>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="upper-case($v_lang)"/>
                                </xsl:attribute>
                               
                                <xsl:variable name="v_comments">
                                    <xsl:call-template name="removeChild">
                                        <xsl:with-param name="p_comment" select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Comments"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:value-of select="normalize-space($v_comments)"/>
                            </ContentText>
                        </Text>
                    </TextCollection>
                </xsl:if>
               
                <!-- Ariba Quote ID-->
                
                <TextCollection>
                    <Text>
                        <ContentText>                                                     
                            <xsl:value-of select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteID"/>
                        </ContentText>
                    </Text>
                </TextCollection>
                
                <!--Item Mapping-->
                <xsl:for-each select="Payload/cXML/Message/QuoteMessage/QuoteItemIn">
                    <Item>
                        <xsl:attribute name="actionCode">
                            <xsl:choose>
                                <xsl:when test="@operation = 'new'">
                                    <xsl:value-of select="'01'"/>
                                </xsl:when>
                                <xsl:when test="@operation = 'update'">
                                    <xsl:value-of select="'02'"/>
                                </xsl:when>
                                <xsl:when test="@operation = 'delete'">
                                    <xsl:value-of select="'03'"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <!-- SAP Line Number - Mapped to Ariba Linenumber for create scenario and handled in ABAP, Mapped to SAP Line number for change scenario -->
                        <ID>
                           
                            <xsl:value-of select="@lineNumber"/>
                        </ID>
                      
                        <!--Ariba Line Number -->
                        <AribaItemID>
                            <xsl:value-of select="@lineNumber"/>
                        </AribaItemID>
                        <!--Item Category -->
                        <!--Cross-reference material-0 service-9 -->
                        <ProcessingTypeCode>
                            <xsl:variable name="v_itemCategory">
                                <xsl:value-of select="@itemClassification"/>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="normalize-space(@itemClassification) = 'service'">
                                    <xsl:value-of select="'9'"/>
                                </xsl:when>
                                <xsl:when test="normalize-space(@itemClassification) = 'material'">
                                    <xsl:value-of select="'0'"/>
                                </xsl:when>
                            </xsl:choose>
                        </ProcessingTypeCode>
                        <DeliveryBasedInvoiceVerificationIndicator>
                            <xsl:value-of select="'1'"/>
                        </DeliveryBasedInvoiceVerificationIndicator>
                        <!--Target Quantity and Unit of Measure -->
                        <xsl:if test="@quantity != ''">
                            <TargetQuantity>
                                <xsl:attribute name="unitCode">
                                    <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                                </xsl:attribute>
                                <xsl:value-of select="@quantity"/>
                            </TargetQuantity>
                        </xsl:if>
                        <!--Buyer Part ID, Supplier Part ID and Manufacture Part ID -->
                        <Product>
                            <InternalID>
                                <xsl:value-of select="ItemID/BuyerPartID"/>
                            </InternalID>
                            <SellerID>
                                <xsl:value-of select="ItemID/SupplierPartID"/>
                            </SellerID>
                            <ManufacturerID>
                                <xsl:value-of select="ItemDetail/ManufacturerPartID"/>
                            </ManufacturerID>
                        </Product>
                        <!--Material Group -->
                        <ProductCategory>
                            <xsl:if test="ItemDetail/Classification[@domain = 'MaterialGroup']">
                                <InternalID>
                                    <xsl:value-of
                                        select="ItemDetail/Classification/@code"
                                    />
                                </InternalID>
                            </xsl:if>
                        </ProductCategory>
                        <!-- Pricing Conditions - Gross Price -->
                        <PriceSpecificationElement>
                            <TypeCode>
                                <xsl:value-of select="$v_grossPrice"/>
                            </TypeCode>
                            <CategoryCode>
                                <xsl:value-of select="'1'"/>
                            </CategoryCode>
                            <ValidityPeriod>
                                <IntervalBoundaryTypeCode>
                                    <xsl:value-of select="'9'"/>
                                </IntervalBoundaryTypeCode>
                                <StartTimePoint>
                                    <TypeCode>
                                        <xsl:value-of select="'1'"/>
                                    </TypeCode>
                                    <Date>
                                        <xsl:choose>
                                            <xsl:when test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate) > 0">
                                                <xsl:value-of select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate,1,10)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring($v_createDate, 1, 10)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </Date>
                                </StartTimePoint>
                                <EndTimePoint>
                                    <TypeCode>
                                        <xsl:value-of select="'1'"/>
                                    </TypeCode>
                                    <Date>
                                        <xsl:choose>
                                            <xsl:when test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate) > 0">
                                                <xsl:value-of select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate,1,10)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'9999-12-31'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </Date>
                                </EndTimePoint>
                            </ValidityPeriod>
                            <PropertyDefinitionClassCode>
                                <xsl:value-of select="'1'"/>
                            </PropertyDefinitionClassCode>
                            <!--<xsl:if test="ItemIn/ItemDetail[exists(UnitPrice)]">-->
                                <Rate>
                                    <DecimalValue>
                                        <xsl:value-of select="ItemDetail/UnitPrice/Money"/>
                                       </DecimalValue>
                                    <MeasureUnitCode>         
                                        <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                                    </MeasureUnitCode>
                                    <CurrencyCode>
                                        
                                        <xsl:value-of select="ItemDetail/UnitPrice/Money/@currency"/>
                                    </CurrencyCode>
                                </Rate>
                            <!--</xsl:if>-->
                        </PriceSpecificationElement>
                        <!--Pricing Conditions - Discounts/Surcharges -->
                        <xsl:for-each
                            select="ItemDetail/UnitPrice/Modifications/Modification">
                           
                            <PriceSpecificationElement>
                                <TypeCode>
                                    <xsl:choose>
                                        <xsl:when test="AdditionalDeduction/DeductionAmount">
                                            <xsl:value-of select="$v_deductionAmount"/>
                                        </xsl:when>
                                        <xsl:when test="AdditionalDeduction/DeductionPercent">
                                            <xsl:value-of select="$v_deductionPercent"/>
                                        </xsl:when>
                                        <xsl:when test="AdditionalCost/Money">
                                            <xsl:value-of select="$v_additionalAmount"/>
                                        </xsl:when>
                                        <xsl:when test="AdditionalCost/Percentage">
                                            <xsl:value-of select="$v_additionalPercent"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </TypeCode>
                                <CategoryCode>
                                    <xsl:choose>
                                        <xsl:when test="exists(AdditionalDeduction)">
                                            <xsl:value-of select="'2'"/>
                                        </xsl:when>
                                        <xsl:when test="exists(AdditionalCost)">
                                            <xsl:value-of select="'3'"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </CategoryCode>
                                <ValidityPeriod>
                                    <IntervalBoundaryTypeCode>
                                        <xsl:value-of select="'9'"/>
                                    </IntervalBoundaryTypeCode>
                                    <StartTimePoint>
                                        <TypeCode>
                                            <xsl:value-of select="'1'"/>
                                        </TypeCode>
                                        <Date>
                                            <xsl:choose>
                                                <xsl:when test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate) > 0">
                                                    <xsl:value-of select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate,1,10)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="substring($v_createDate, 1, 10)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </Date>
                                    </StartTimePoint>
                                    <EndTimePoint>
                                        <TypeCode>
                                            <xsl:value-of select="'1'"/>
                                        </TypeCode>
                                        <Date> 
                                            <xsl:choose>
                                            <xsl:when test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate) > 0">
                                                <xsl:value-of select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate,1,10)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'9999-12-31'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        </Date>
                                    </EndTimePoint>
                                </ValidityPeriod>
                                <PropertyDefinitionClassCode>
                                    <xsl:value-of select="'1'"/>
                                </PropertyDefinitionClassCode>
                                <!--Condition Value - Currency-->
                                <Rate>
                                    <DecimalValue>
                                        <xsl:value-of select="'0'"/>
                                    </DecimalValue>
                                    <CurrencyCode>
                                        <xsl:value-of select="../../Money/@currency"/>
                                       
                                    </CurrencyCode>
                                </Rate>
                                <!--Condition Value - Discount/Surcharge Percentage -->
                                <xsl:choose>
                                    <xsl:when
                                        test="exists(AdditionalDeduction/DeductionPercent/@percent)">
                                        <Percent>
                                            <xsl:value-of
                                                select="AdditionalDeduction/DeductionPercent/@percent"
                                            />
                                        </Percent>
                                    </xsl:when>
                                    <xsl:when test="exists(AdditionalCost/Percentage/@percent)">
                                        <Percent>
                                            <xsl:value-of
                                                select="AdditionalCost/Percentage/@percent"/>
                                        </Percent>
                                    </xsl:when>
                                </xsl:choose>
                                <!--Condition Value - Discount/Surcharge Amount -->
                                <xsl:choose>
                                    <xsl:when
                                        test="exists(AdditionalDeduction/DeductionAmount/Money)">
                                        <FixedAmount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of
                                                  select="AdditionalDeduction/DeductionAmount/Money/@currency"
                                                />
                                            </xsl:attribute>

                                            <xsl:value-of
                                                select="(AdditionalDeduction/DeductionAmount/Money) * -1"
                                            />
                                        </FixedAmount>
                                    </xsl:when>
                                    <xsl:when test="exists(AdditionalCost/Money)">
                                        <FixedAmount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of
                                                  select="AdditionalCost/Money/@currency"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="AdditionalCost/Money"/>
                                        </FixedAmount>
                                    </xsl:when>
                                </xsl:choose>
                            </PriceSpecificationElement>
                        </xsl:for-each>
                        <!--Receiving Plant -->
                        
                        <xsl:if test="ShipTo/Address/@addressID != ''">
                            <ReceivingPlantID>
                                <xsl:value-of select="ShipTo/Address/@addressID"/>
                            </ReceivingPlantID>
                        </xsl:if>
                        <!--Incoterms -->
                        <xsl:if test="exists(TermsOfDelivery)">
                            <DeliveryTerms>
                                <Incoterms>
                                    <ClassificationCode>
                                        <xsl:value-of
                                            select="TermsOfDelivery/TransportTerms/@value"/>
                                    </ClassificationCode>
                                    <TransferLocationName>
                                        <xsl:value-of select="TermsOfDelivery/TransportTerms"/>
                                    </TransferLocationName>
                                </Incoterms>
                            </DeliveryTerms>
                        </xsl:if>
                        <!--Item Texts -->
                        <xsl:if test="exists(Comments)">
                            <TextCollection>
                                <Text>
                                    <TypeCode>
                                        <xsl:value-of>
                                            <!--Cross-reference Ariba Text ID to SAP Text ID-->
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                  select="Comments/@type"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </TypeCode>
                                    <ContentText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="Comments/@xml:lang"/>
                                           
                                        </xsl:attribute>
                                        
                                        <xsl:variable name="v_comments">
                                            <xsl:call-template name="removeChild">
                                                <xsl:with-param name="p_comment" select="Comments"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:value-of select="normalize-space($v_comments)"/>
                                        
                                    </ContentText>
                                </Text>
                            </TextCollection>
                        </xsl:if>
                      
                        <RFQReference>
                                <ID>
                                    <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType='quoteRequest']/@documentID"/>
                                </ID>
                               
                                <ItemID>
                                    <xsl:value-of select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'quoteRequest']]/@lineNumber"/>
                                </ItemID>
                                
                            </RFQReference>
                            <RequisitionReference>
                                <ID>
                                    <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType='requisition']/@documentID"/>
                                </ID>
                               
                                    <ItemID>
                                        <xsl:value-of select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'requisition']]/@lineNumber"/>
                                </ItemID>
                                
                            </RequisitionReference>
                        <Description>
                            <xsl:attribute name="languageCode">
                                <xsl:value-of select="$v_lang"/>    
                            </xsl:attribute>
                            <xsl:value-of select="ItemDetail/Description"/>
                        </Description>
                        <!-- 	CI-1844 : Populate the Item Partners information 		-->
                        <xsl:if test="exists(SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
                            <!--	Loop over all Item Partners with respect to each Item number	--> 
                            <xsl:for-each select="SupplierProductionFacilityRelations/ProductionFacilityAssociation">                   
                                <Party>
                                    <InternalID>
                                        <xsl:value-of select="ProductionFacility/IdReference/@identifier"/>									
                                    </InternalID> 
                                    <ResponsiblePurchasingOrganisationParty>
                                        <InternalID>
                                            <xsl:value-of select="OrganizationalUnit/IdReference/@identifier"/>
                                        </InternalID>
                                    </ResponsiblePurchasingOrganisationParty> 
                                    <ReceivingPlantID>
                                        <xsl:value-of select="../../ShipTo/Address/@addressID"/>                                                                             
                                    </ReceivingPlantID>                                    
                                    <RoleCode>
                                        <xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
                                    </RoleCode>
                                    <DefaultIndicator></DefaultIndicator>                                    
                                </Party>                  
                            </xsl:for-each>
                        </xsl:if>                          
                    </Item>
                </xsl:for-each>
            </PurchasingContract>
            <!--Call template to handle attachment-->
          
          <xsl:call-template name="InboundAttachs"> </xsl:call-template>
            
        </n0:PurchasingContractERPCreateRequest>
    </xsl:template>
</xsl:stylesheet>
