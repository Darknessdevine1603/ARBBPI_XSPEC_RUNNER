<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <xsl:variable name="v_currDate">
        <xsl:value-of select="current-date()"/>
    </xsl:variable>

    <!-- Parameters -->
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSourceDocumentType"/>
    <!-- <xsl:param name="PD_ref" select="v_pd"/>-->

    <xsl:param name="Document_type" select="'ContractRequest'"/>
    <xsl:variable name="header"
        select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader"/>
    <xsl:variable name="item" select="/Combined/Payload/cXML/Request/ContractRequest/ContractItemIn"/>

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
            <xsl:with-param name="p_date" select="$header/@createDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>       
    </xsl:variable>


    <!--Effective Date -->
    <xsl:variable name="v_effectiveDate">
        <!-- IG-29961: Removing timezone conversion as its not needed  -->
       <!-- <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="$header/@effectiveDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>-->
        <xsl:value-of select="$header/@effectiveDate"/>
    </xsl:variable>

    <!--Expiration Date -->
    <xsl:variable name="v_expirationDate">
        <!-- IG-29961: Removing timezone conversion as its not needed  -->
       <!-- <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="$header/@expirationDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>-->
        <xsl:value-of select="$header/@expirationDate"/>
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
        <xsl:value-of select="upper-case($header/@xml:lang)"/>
    </xsl:variable>

    <!--    C r o s s - r e f e r e n c e s    -->

    <!--C o n d i t i o n     T y p e s -->

    <!--Gross Price -->
    <xsl:variable name="v_grossPrice">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="'ContractRequest'"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'GrossPrice'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Discount Amount -->
    <xsl:variable name="v_deductionAmount">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="'ContractRequest'"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'DeductionAmount'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Discount Percentage -->
    <xsl:variable name="v_deductionPercent">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="'ContractRequest'"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'DeductionPercent'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Additional Cost Amount -->
    <xsl:variable name="v_additionalAmount">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="'ContractRequest'"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'AdditionalAmount'"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Additional Cost Percentage -->
    <xsl:variable name="v_additionalPercent">
        <xsl:call-template name="ReadQuote">
            <xsl:with-param name="p_doctype" select="'ContractRequest'"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'AdditionalPercent'"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:template match="Combined">
        <n0:PurchasingContractERPCreateRequest>
            <MessageHeader>
                <CreationDateTime>
                    <xsl:value-of select="$v_createDate"/>
                </CreationDateTime>
                <!-- Sender Business System -->
                <SenderBusinessSystemID>
                    <xsl:value-of
                        select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"
                    />
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
                            select="Payload/cXML/Header/From/Credential[@domain = 'NetworkId']/Identity"
                        />
                    </InternalID>
                </SenderParty>
            </MessageHeader>
            <PurchasingContract>
                <!-- SAP Contract ID-->
                <ID>
                    <xsl:value-of select="$header/DocumentInfo/@documentID"/>
                </ID>
                <!-- Ariba Network Supplier ID-->
                <NetworkID>
                    <xsl:value-of
                        select="$header/OrganizationID/Credential[@domain = 'NetworkID']/Identity"/>
                </NetworkID>
                <!--Ariba Contract ID-->
                <AribaContractID>
                    <xsl:value-of select="$header/@contractID"/>
                </AribaContractID>
                <!--ERP System ID-->
                <SystemID>
                    <xsl:value-of
                        select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"
                    />
                </SystemID>
                <!--Creation Date and Time-->
                <CreationDateTime>
                    <xsl:value-of select="$v_createDate"/>
                </CreationDateTime>
                <!--Operation - Create/Update/Delete-->
                <!-- Cross-reference Create-CREAT Update-UPDAT Delete-DELET-->
                <Operation>
                    <!--  <xsl:value-of select="$header/@operation"/>-->
                    <xsl:choose>
                        <xsl:when
                            test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation = 'new'"
                            >
                            <xsl:value-of select="'01'"/>
                        </xsl:when>
                        <xsl:when
                            test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation = 'update'"
                            >
                            <xsl:value-of select="'02'"/>
                        </xsl:when>
                        <xsl:when
                            test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation = 'delete'"
                            >
                            <xsl:value-of select="'03'"/>
                        </xsl:when>
                    </xsl:choose>

                </Operation>
                <!-- Language -->
                <Language>

                    <xsl:value-of select="upper-case($v_lang)"/>
                </Language>
                <!-- Company Code -->
                <CompanyID>
                    <xsl:value-of
                        select="$header/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
                    />
                </CompanyID>
                <!-- Contract Document Type -->
                <!--Cross-reference   value-WK  quantity-MK-->
                <xsl:variable name="v_documentType">
                    <xsl:value-of
                        select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/FollowUpDocument/@category"
                    />
                </xsl:variable>
                <xsl:variable name="v_doctyp">
                    <xsl:value-of>
                        <xsl:call-template name="LookupTemplate">
                            <xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
                            <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                            <xsl:with-param name="p_doctype" select="'ContractRequest'"/>
                            <xsl:with-param name="p_input" select="$v_documentType"/>
                            <xsl:with-param name="p_lookupname" select="'SAPDocType'"/>
                            <xsl:with-param name="p_producttype" select="'AribaSourcing'"/>
                        </xsl:call-template>
                    </xsl:value-of>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($v_documentType) != 0">
                        <ProcessingTypeCode>
                            <xsl:choose>
                                <xsl:when test="string-length($v_doctyp) != 0">
                                    <xsl:value-of select="$v_doctyp"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of>
                                        <xsl:call-template name="ReadQuote">
                                            <xsl:with-param name="p_doctype"
                                                select="'ContractRequest'"/>
                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                            <xsl:with-param name="p_attribute"
                                                select="$v_documentType"/>
                                        </xsl:call-template>
                                    </xsl:value-of>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ProcessingTypeCode>
                    </xsl:when>
                    <xsl:otherwise>
                        <ProcessingTypeCode>
                            <xsl:value-of>
                                <xsl:call-template name="ReadQuote">
                                    <xsl:with-param name="p_doctype" select="'ContractRequest'"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                    <xsl:with-param name="p_attribute"
                                        select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@type"
                                    />
                                </xsl:call-template>
                            </xsl:value-of>
                        </ProcessingTypeCode>
                    </xsl:otherwise>
                </xsl:choose>
                <!--Validity Period-->
                <!--<xsl:if test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate' or 'ValidityEndDate']">
                 -->
                <ValidityPeriod>
                    <StartDate>
                        <xsl:choose>
                            <xsl:when
                                test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']">
                                <xsl:variable name="v_date">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date"
                                            select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of select="substring($v_date, 1, 10)"/>
                            </xsl:when>
                            <xsl:when test="$v_effectiveDate != ''">
                                <xsl:value-of select="substring($v_effectiveDate, 1, 10)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="substring(Payload/cXML/Request/ContractRequest/ContractRequestHeader/@createDate, 1, 10)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </StartDate>
                    <EndDate>
                        <xsl:choose>
                            <xsl:when
                                test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']">
                                <xsl:variable name="v_date">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date"
                                            select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of select="substring($v_date, 1, 10)"/>
                            </xsl:when>
                            <xsl:when test="$v_expirationDate != ''">
                                <xsl:value-of select="substring($v_expirationDate, 1, 10)"/>
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
                                select="Payload/cXML/Request/ContractRequest/ContractItemIn[1]/ItemIn/ItemDetail/UnitPrice/Money/@currency"
                            />
                        </UnitCurrency>
                        <QuotedCurrency>
                            <xsl:value-of
                                select="Payload/cXML/Request/ContractRequest/ContractItemIn[1]/ItemIn/ItemDetail/UnitPrice/Money/@currency"
                            />
                        </QuotedCurrency>
                        <Rate>
                            <xsl:value-of select="'0'"/>
                        </Rate>
                        <QuotationDateTime>
                            <!-- Defect Fix IG-5446     <xsl:value-of select="substring($v_agreementDate, 1, 10)"/>-->
                            <xsl:value-of select="$v_agreementDate"/>
                        </QuotationDateTime>
                    </ExchangeRate>
                    <ExchangeRateFixedIndicator>
                        <xsl:value-of select="'1'"/>
                    </ExchangeRateFixedIndicator>
                </ExchangeRate>
                <!-- Target Amount -->
                <xsl:if test="exists($header/MaxAmount/Money)">
                    <!--Defect Fix IG-5464-->
                    <TargetAmount>
                        <xsl:if test="(string-length($header/MaxAmount/Money) > 0)">
                            <xsl:attribute name="currencyCode">
                                <xsl:value-of select="$header/MaxAmount/Money/@currency"/>
                            </xsl:attribute>
                            <xsl:value-of
                                select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/MaxAmount/Money"
                            />
                        </xsl:if>
                    </TargetAmount>
                </xsl:if>
                <!--Defect Fix IG-5464-->
                <!-- Vendor -->
                <SellerParty>
                    <InternalID>
                        <xsl:value-of
                            select="$header/OrganizationID/Credential[@domain = 'PrivateID']/Identity"
                        />
                    </InternalID>
                </SellerParty>
                <!--Purchasing Organization -->
                <xsl:if
                    test="$header/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier != ''">
                    <ResponsiblePurchasingOrganisationParty>
                        <InternalID>
                            <xsl:value-of
                                select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier"
                            />
                        </InternalID>
                    </ResponsiblePurchasingOrganisationParty>
                </xsl:if>
                <xsl:if
                    test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier != ''">
                    <ResponsiblePurchasingGroupParty>
                        <InternalID>
                            <xsl:value-of
                                select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier"
                            />
                        </InternalID>
                    </ResponsiblePurchasingGroupParty>
                </xsl:if>
                <!-- Incoterms --><!-- Delivery Terms at Header Level -->
                <xsl:if
                    test="exists(Payload/cXML/Request/ContractRequest/ContractItemIn[1]/TermsOfDelivery)">
                    <DeliveryTerms>
                        <Incoterms>
                            <ClassificationCode>
                                <xsl:value-of
                                    select="Payload/cXML/Request/ContractRequest/ContractItemIn[1]/TermsOfDelivery/TransportTerms/@value"
                                />
                            </ClassificationCode>
                            <TransferLocationName>
                                <xsl:value-of
                                    select="substring(Payload/cXML/Request/ContractRequest/ContractItemIn[1]/TermsOfDelivery/TransportTerms, 1, 28)"
                                />
                            </TransferLocationName>
                        </Incoterms>
                    </DeliveryTerms>
                </xsl:if>
                <!-- Payment Terms -->
                <xsl:if
                    test="exists(Payload/cXML/Request/ContractRequest/ContractRequestHeader/PaymentTerm[1]/Extrinsic[@name = 'ID'])">
                    <CashDiscountTerms>
                        <Code>
                            <xsl:value-of
                                select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/PaymentTerm[1]/Extrinsic[@name = 'ID']"
                            />
                        </Code>
                        <MaximumCashDiscount>
                            <DaysValue>
                                <xsl:value-of
                                    select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/PaymentTerm[1]/@payInNumberOfDays"
                                />
                            </DaysValue>
                            <Percent>
                                <xsl:value-of
                                    select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/PaymentTerm[1]/Discount/DiscountPercent/@percent"
                                />
                            </Percent>
                        </MaximumCashDiscount>
                    </CashDiscountTerms>
                </xsl:if>
                <!-- Header Text-->
                <xsl:if
                    test="exists(Payload/cXML/Request/ContractRequest/ContractRequestHeader/Comments)">
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
                                        <xsl:with-param name="p_comment"
                                            select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Comments"
                                        />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:value-of select="normalize-space($v_comments)"/>

                            </ContentText>
                        </Text>
                    </TextCollection>
                </xsl:if>
                <!--Item Mapping-->
                <xsl:for-each select="Payload/cXML/Request/ContractRequest/ContractItemIn">
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
                            <xsl:choose>
                                <xsl:when test="$header/@operation = 'new'">
                                    <!--Insert a new line in Create Scenario -->
                                    <xsl:value-of select="ItemIn/@lineNumber"/>
                                </xsl:when>
                                <xsl:when test="$header/@operation = 'update'">
                                    <xsl:choose>
                                        <xsl:when
                                            test="ItemIn/ItemID/IdReference/@domain = 'SAPLineNumber'">
                                            <!--Update an existing line in Change Scenario -->
                                            <xsl:if
                                                test="string-length(ItemIn/ItemID/IdReference/@identifier) > 0">
                                                <xsl:value-of
                                                  select="ItemIn/ItemID/IdReference/@identifier"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <!--Insert a new line in Change Scenario - Defaulted to '01' and handled in ABAP -->
                                        <xsl:when test="@operation = 'new'">
                                            <xsl:value-of select="'01'"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="$header/@operation = 'delete'">
                                    <xsl:if
                                        test="ItemIn/ItemID/IdReference/@domain = 'SAPLineNumber'">
                                        <!--Delete an existing line in Delete Scenario -->
                                        <xsl:if
                                            test="string-length(ItemIn/ItemID/IdReference/@identifier) > 0">
                                            <xsl:value-of
                                                select="ItemIn/ItemID/IdReference/@identifier"/>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </ID>

                        <!--Ariba Line Number -->
                        <AribaItemID>
                            <xsl:value-of select="ItemIn/@lineNumber"/>
                        </AribaItemID>
                        <!--Item Category -->
                        <!--Cross-reference material-0 service-9 -->
                        <ProcessingTypeCode>
                            <xsl:variable name="v_itemCategory">
                                <xsl:value-of select="ItemIn/@itemClassification"/>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="normalize-space(ItemIn/@itemCategory) != ''">
                                    <xsl:choose>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'limit'"
                                            >
                                            <xsl:value-of select="'1'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'consignment'"
                                            >
                                            <xsl:value-of select="'2'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'subcontract'"
                                            >
                                            <xsl:value-of select="'3'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'materialUnknown'"
                                            >
                                            <xsl:value-of select="'4'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'thirdParty'"
                                            >
                                            <xsl:value-of select="'5'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'text'"
                                            >
                                            <xsl:value-of select="'6'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'stockTransfer'"
                                            >
                                            <xsl:value-of select="'7'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="normalize-space(ItemIn/@itemCategory) = 'materialGroup'"
                                            >
                                            <xsl:value-of select="'8'"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="$v_itemCategory != ''">
                                    <xsl:choose>
                                        <xsl:when test="$v_itemCategory = 'material'">
                                            <xsl:value-of select="'0'"/>
                                        </xsl:when>
                                        <xsl:when test="$v_itemCategory = 'service'">
                                            <xsl:value-of select="'9'"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                            </xsl:choose>
                        </ProcessingTypeCode>
                        <DeliveryBasedInvoiceVerificationIndicator>
                            <xsl:value-of select="'1'"/>
                        </DeliveryBasedInvoiceVerificationIndicator>
                        <!--Target Quantity and Unit of Measure -->
                        <xsl:if test="ItemIn/@quantity != ''">
                            <TargetQuantity>
                                <xsl:attribute name="unitCode">
                                    <xsl:value-of select="ItemIn/ItemDetail/UnitOfMeasure"/>
                                </xsl:attribute>
                                <xsl:value-of select="ItemIn/@quantity"/>
                            </TargetQuantity>
                        </xsl:if>
                        <!--Buyer Part ID, Supplier Part ID and Manufacture Part ID -->
                        <Product>
                            <InternalID>
                                <xsl:value-of select="ItemIn/ItemID/BuyerPartID"/>
                            </InternalID>
                            <SellerID>
                                <xsl:value-of select="ItemIn/ItemID/SupplierPartID"/>
                            </SellerID>
                            <ManufacturerID>
                                <xsl:value-of select="ItemIn/ItemDetail/ManufacturerPartID"/>
                            </ManufacturerID>
                        </Product>
                        <!--Material Group -->
                        <ProductCategory>
                            <xsl:if
                                test="ItemIn/ItemDetail/Classification[@domain = 'MaterialGroup']">
                                <InternalID>
                                    <xsl:value-of
                                        select="ItemIn/ItemDetail/Classification[@domain = 'MaterialGroup']"
                                    />
                                </InternalID>
                            </xsl:if>
                        </ProductCategory>
                        <!-- Unit Price and Unit of Measure -->
                        <Price>
                            <NetUnitPrice>
                                <Amount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of
                                            select="ItemIn/ItemDetail/UnitPrice/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="ItemIn/ItemDetail/UnitPrice/Money"/>

                                </Amount>
                                <BaseQuantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:value-of select="ItemIn/ItemDetail/UnitOfMeasure"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="'1'"/>
                                </BaseQuantity>
                            </NetUnitPrice>
                        </Price>
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
                                            <xsl:when test="ModificationDetail/@startDate">
                                                <xsl:value-of
                                                  select="substring(ModificationDetail/@startDate, 1, 10)"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="substring($v_createDate, 1, 10)"/>
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
                                            <xsl:when test="ModificationDetail/@endDate">
                                                <xsl:value-of
                                                  select="substring(ModificationDetail/@endDate, 1, 10)"
                                                />
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
                            <xsl:if test="ItemIn/ItemDetail[exists(UnitPrice)]">
                                <Rate>
                                    <DecimalValue>
                                        <xsl:value-of select="ItemIn/ItemDetail/UnitPrice/Money"/>
                                    </DecimalValue>
                                    <MeasureUnitCode>
                                        <xsl:value-of select="ItemIn/ItemDetail/UnitOfMeasure"/>
                                    </MeasureUnitCode>
                                    <CurrencyCode>
                                        <xsl:value-of
                                            select="ItemIn/ItemDetail/UnitPrice/Money/@currency"/>
                                    </CurrencyCode>
                                </Rate>
                            </xsl:if>
                        </PriceSpecificationElement>
                        <!--Pricing Conditions - Discounts/Surcharges -->
                        <xsl:for-each
                            select="ItemIn/ItemDetail/UnitPrice/Modifications/Modification">
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
                                                <xsl:when test="ModificationDetail/@startDate">
                                                  <xsl:value-of
                                                  select="substring(ModificationDetail/@startDate, 1, 10)"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring($v_createDate, 1, 10)"/>
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
                                                <xsl:when test="ModificationDetail/@endDate">
                                                  <xsl:value-of
                                                  select="substring(ModificationDetail/@endDate, 1, 10)"
                                                  />
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
                                        <!--<xsl:choose>
                                            <xsl:when
                                                test="exists(AdditionalDeduction/DeductionAmount/Money)">
                                                <xsl:value-of
                                                  select="AdditionalDeduction/DeductionAmount/Money/@currency"
                                                />
                                            </xsl:when>
                                            <xsl:when test="exists(AdditionalCost/Money)">
                                                <xsl:value-of
                                                  select="AdditionalCost/Money/@currency"/>
                                            </xsl:when>
                                        </xsl:choose>-->
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
                        <xsl:if test="ItemIn/ShipTo/Address/@addressID != ''">
                            <ReceivingPlantID>
                                <xsl:value-of select="ItemIn/ShipTo/Address/@addressID"/>
                            </ReceivingPlantID>
                        </xsl:if>
                        <!--Incoterms -->
                        <xsl:if test="exists(TermsOfDelivery)">
                            <DeliveryTerms>
                                <Incoterms>
                                    <ClassificationCode>
                                        <xsl:value-of select="TermsOfDelivery/TransportTerms/@value"
                                        />
                                    </ClassificationCode>
                                    <TransferLocationName>
                                        <xsl:value-of select="TermsOfDelivery/TransportTerms"/>
                                    </TransferLocationName>
                                </Incoterms>
                            </DeliveryTerms>
                        </xsl:if>
                        <!--Item Texts -->
                        <xsl:if test="exists(ItemIn/Comments)">
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
                                                  select="$item/ItemIn/Comments/@type"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </TypeCode>
                                    <ContentText>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="ItemIn/Comments/@xml:lang"/>
                                        </xsl:attribute>

                                        <xsl:variable name="v_comments">
                                            <xsl:call-template name="removeChild">
                                                <xsl:with-param name="p_comment"
                                                  select="$item/ItemIn/Comments"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:value-of select="normalize-space($v_comments)"/>
                                    </ContentText>
                                </Text>
                            </TextCollection>
                        </xsl:if>
                        <RFQReference>
                            <ID>
                                <xsl:value-of
                                    select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'RFQ']/@documentID"
                                />
                            </ID>
                            <ItemID>

                                <xsl:value-of
                                    select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'RFQ']]/@lineNumber"
                                />
                            </ItemID>
                        </RFQReference>
                        <RequisitionReference>
                            <ID>
                                <xsl:value-of
                                    select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'Requisition']/@documentID"
                                />
                            </ID>
                            <ItemID>
                                <xsl:value-of
                                    select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'Requisition']]/@lineNumber"
                                />
                            </ItemID>
                        </RequisitionReference>
                        <Description>
                            <xsl:attribute name="languageCode">
                                <xsl:value-of select="$v_lang"/>
                            </xsl:attribute>
                            <xsl:value-of select="ItemIn/ItemDetail/Description"/>
                        </Description>
                    </Item>
                </xsl:for-each>
            </PurchasingContract>
            <!--Call template to handle attachment-->
            <xsl:call-template name="InboundAttachs"> </xsl:call-template>
        </n0:PurchasingContractERPCreateRequest>
    </xsl:template>
</xsl:stylesheet>
