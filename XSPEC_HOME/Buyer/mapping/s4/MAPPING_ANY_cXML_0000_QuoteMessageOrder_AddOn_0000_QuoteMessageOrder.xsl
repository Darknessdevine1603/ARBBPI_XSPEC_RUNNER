<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n1="urn:sap-com:document:sap:rfc:functions" exclude-result-prefixes="#all">
    <!-- format the output and indent-->

    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--Declare parameters-->
    <xsl:param name="AccAssCat" select="'AccountAssignmentCat'"/>
    <xsl:param name="AdditionalMoney" select="'AdditionalMoney'"/>
    <xsl:param name="AdditionalPercent" select="'AdditionalPercent'"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="Asset" select="'Asset'"/>
    <xsl:param name="CostCenter" select="'CostCenter'"/>
    <xsl:param name="DeductionAmount" select="'DeductionAmount'"/>
    <xsl:param name="DeductionPercent" select="'DeductionPercent'"/>
    <xsl:param name="DefaultPlant" select="'DefaultPlant'"/>
    <xsl:param name="Document_type" select="'QuoteMessageOrder'"/>
    <xsl:param name="FollowUpDocument" select="'DocType'"/>
    <xsl:param name="GLAccount" select="'GLAccount'"/>
    <xsl:param name="GrossPrice" select="'GrossPrice'"/>
    <xsl:param name="HeaderTextID" select="'HeaderTextID'"/>
    <xsl:param name="ItemCatMaterial" select="'ItemCatMaterial'"/>
    <xsl:param name="ItemCatService" select="'ItemCatService'"/>
    <xsl:param name="LineTextID" select="'LineTextID'"/>
    <xsl:param name="OneTimeVendor" select="'OneTimeVendor'"/>
    <xsl:param name="OrderID" select="'Order'"/>
    <xsl:param name="ServiceGrossPrice" select="'ServiceGrossPrice'"/>
    <xsl:param name="SpotQuoteID" select="'SpotQuoteID'"/>
    <xsl:param name="SubNumber" select="'SubNumber'"/>
    <xsl:param name="WBSElement" select="'WBSElement'"/>    
    <!--    End of parameter declaration-->

    <!--Declare variables-->
    <xsl:variable name="address"
        select="Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Contact"/>
    <xsl:variable name="header"
        select="Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader"/>
    <xsl:variable name="item" select="Combined/Payload/cXML/Message/QuoteMessage/QuoteItemIn"/>
    <!--Use for a reference for identification of Alternate Line number-->
    <xsl:variable name="v_loopItem" select="Combined/Payload/cXML/Message/QuoteMessage/QuoteItemIn"/>
    <xsl:variable name="doctype"
        select="string-length(Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/FollowUpDocument/@category)"/>
    <xsl:variable name="compcode"
        select="string-length(Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier)"/>
    <xsl:variable name="vendor"
        select="string-length(Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity)"/>
    <!--CI-1779  VendorID-->
    <!--If PrivateID is not available pass VendorID with preference to Private ID if both exists -->
    <!--Either Privateid or VendorID should always Exists -->
    <xsl:variable name="v_vendorid">
        <xsl:choose>
            <xsl:when test="$vendor > 0">
                <xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!--End of variable declaration-->

    <!--Include the Format_any_Addon common xslt-->
<!--    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>

    <!--Multi ERP Scenario-->
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
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
    <xsl:variable name="v_lang">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>

    <!--Creation Date -->
    <xsl:variable name="v_createDate">
        <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date"
                select="/Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>
    </xsl:variable>
    
    <!-- Main Template-->
    <xsl:template match="Combined">
        <n1:ARBCIG_QUOTE>
            <!--For IG-23000, multiple segments were reordered-->
            <!--Populate the Ariba Event ID-->
            <ARIBA_EVENTID>
                <xsl:value-of select="$header/Extrinsic[@name = 'SourcingEventId']"/>
            </ARIBA_EVENTID>
            
            <!--Populate the extra fields for Ariba Quote Message-->
            <ARIBA_QUOTEEXTRA>
                <!--format RFQ ID to 10 digits-->
                <xsl:if test="string-length($header/QuoteRequestReference/@requestID) > 0">
                    <RFQID>
                        <xsl:choose>
                            <xsl:when test=" number($header/QuoteRequestReference/@requestID)">
                                <xsl:value-of select="format-number($header/QuoteRequestReference/@requestID, '0000000000')"/>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$header/QuoteRequestReference/@requestID"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </RFQID>
                </xsl:if>
                
                <!--Covert Date coming from An to ERP format-->
                <xsl:variable name="v_date">
                    <xsl:call-template name="ERPDateTime">
                        <xsl:with-param name="p_date"
                            select="$header/QuoteRequestReference/@requestDate"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <RFQDATE>
                    <xsl:value-of select="substring($v_date, 1, 10)"/>
                </RFQDATE>
            </ARIBA_QUOTEEXTRA>
            <!--Attachments-->
            <xsl:variable name="v_attachment" select="AttachmentList/Attachment"/>
            <xsl:if test="$v_attachment">
                <ATTACHMENT>
                    <xsl:for-each select="$v_attachment">
                        <item>
                            <FILE_NAME>
                                <xsl:value-of select="/Combined/AttachmentList/Attachment/AttachmentName"/>
                            </FILE_NAME>
                            <xsl:if test="string-length(/Combined/AttachmentList/Attachment/LineNumber) > 0">
                                <LINE_NUMBER>
                                    <xsl:value-of select="/Combined/AttachmentList/Attachment/LineNumber"/>
                                </LINE_NUMBER>
                            </xsl:if>  
                            <CONTENT_ID>
                                <xsl:value-of select="/Combined/AttachmentList/Attachment/AttachmentID"/>
                            </CONTENT_ID>
                            <CONTENT_TYPE>
                                <xsl:value-of select="/Combined/AttachmentList/Attachment/AttachmentType"/>
                            </CONTENT_TYPE>
                            <CONTENT>
                                <xsl:value-of select="/Combined/AttachmentList/Attachment/AttachmentContent"/>
                            </CONTENT>
                        </item>
                    </xsl:for-each>
                </ATTACHMENT>
            </xsl:if>
    <!--Message Header-->
            <MESSAGEHEADER>
                <CREATIONDATETIME>
                    <xsl:value-of select="$v_createDate"/>
                </CREATIONDATETIME>
                <!-- Sender Business System -->
                <!--<xsl:value-of select="Header/From/Credential[@domain = 'SystemID']/Identity"/>-->
                <SENDERBUSINESSSYSTEMID>
                    <xsl:value-of select="'SOURCING'"/>
                </SENDERBUSINESSSYSTEMID>
                <RECIPIENTBUSINESSSYSTEMID>
                    <xsl:value-of select="$anERPSystemID"/>
                </RECIPIENTBUSINESSSYSTEMID>
                <!--Payload ID -->
                <ARIBANETWORKPAYLOADID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </ARIBANETWORKPAYLOADID>
                <!-- Sender Party -->
                <SENDERPARTY>
                    <INTERNALID>
                        <xsl:attribute name="schemeID">
                            <xsl:value-of select="'NetworkID'"/>
                        </xsl:attribute>
                        <xsl:attribute name="schemeagencyID">
                            <xsl:value-of select="'www.ariba.com'"/>
                        </xsl:attribute>
                        <xsl:value-of
                            select="Payload/cXML/Header/From/Credential[@domain = 'NetworkId']/Identity"
                        />
                    </INTERNALID>
                </SENDERPARTY>
            </MESSAGEHEADER>
            <!--Populate No price from PO if followup document is not initial-->
            <xsl:if test="string-length($header/QuoteHeaderInfo/FollowUpDocument/@category) > 0">
                <NO_PRICE_FROM_PO>
                    <xsl:value-of select="'X'"/>
                </NO_PRICE_FROM_PO>
            </xsl:if>
            <!--*****************************************************************************************************************************************-->
            <!-- Populate the vendor Addrerss only if contact role = SupplierCorporate-->
            <xsl:if test="$address[@role = 'supplierCorporate']">

                <POADDRVENDOR>
                    <xsl:if test="$address[@role = 'supplierCorporate']">
                        <ADDR_NO>
                            <xsl:value-of select="$address[@role = 'supplierCorporate']/@addressID"
                            />
                        </ADDR_NO>

                        <NAME>
                            <xsl:value-of select="$address/Name"/>
                        </NAME>

                        <CITY>
                            <xsl:value-of select="$address/PostalAddress/City"/>
                        </CITY>

                        <POSTL_COD1>
                            <xsl:value-of select="$address/PostalAddress/PostalCode"/>
                        </POSTL_COD1>

                        <STREET>
                            <xsl:value-of select="$address/PostalAddress/Street"/>
                        </STREET>

                        <COUNTRY>
                            <xsl:value-of select="$address/PostalAddress/Country/@isoCountryCode"/>
                        </COUNTRY>

                        <REGION>
                            <xsl:value-of select="$address/PostalAddress/State"/>
                        </REGION>

                        <!--concatenate the country code city code and number-->
                        <TEL1_NUMBR>
                            <xsl:value-of
                                select="concat($address/Phone/TelephoneNumber/CountryCode/@isoCountryCode, $address/Phone/TelephoneNumber/AreaOrCityCode, $address/Phone/TelephoneNumber/Number)"
                            />
                        </TEL1_NUMBR>

                        <TEL1_EXT>
                            <xsl:value-of select="$address/Phone/TelephoneNumber/Extension"/>
                        </TEL1_EXT>

                        <!--concatenate the country code city code and number-->
                        <FAX_NUMBER>
                            <xsl:value-of
                                select="concat($address/Fax/TelephoneNumber/CountryCode/@isoCountryCode, $address/Fax/TelephoneNumber/AreaOrCityCode, $address/Fax/TelephoneNumber/Number)"
                            />
                        </FAX_NUMBER>

                        <FAX_EXTENS>
                            <xsl:value-of select="$address/Fax/TelephoneNumber/Extension"/>
                        </FAX_EXTENS>

                        <E_MAIL>
                            <xsl:value-of select="$address/Email/@name"/>
                        </E_MAIL>

                        <COUNTRYISO>
                            <xsl:value-of select="$address/PostalAddress/Country/@isoCountryCode"/>
                        </COUNTRYISO>

                        <LANGU_ISO>
                            <xsl:value-of select="substring(upper-case($address/Name/@xml:lang),1,2)"/>
                        </LANGU_ISO>

                    </xsl:if>
                </POADDRVENDOR>
            </xsl:if>

            <!--*********************************************************************************************************************************************************-->
            <!--Map PO header-->
            <POHEADER>
                <!--check for Quote Automation condition-->
                <!--If company code,vendor and doc type is initial then read from Cross reference file-->
                <xsl:choose>
                    <!--Spot Quote Scenario-->
                    <xsl:when test="($compcode = 0 and $doctype = 0)">
                        <!--Read Document type from Cross reference file-->
                        <DOC_TYPE>
                            <xsl:value-of>
                                <xsl:call-template name="ReadQuote">
                                    <xsl:with-param name="p_doctype" select="$Document_type"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                    <xsl:with-param name="p_attribute" select="$FollowUpDocument"/>
                                </xsl:call-template>
                            </xsl:value-of>
                        </DOC_TYPE>

                        <!-- IG-33442 VENDOR MAPPING -->
                        <VENDOR>
                            <xsl:choose>
                                <!-- Map From cXML -->
                                <xsl:when test="string-length(string($v_vendorid)) > 0">
                                    <xsl:value-of select="$v_vendorid"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!--Read one time vendor from Cross reference file-->
                                    <xsl:value-of>
                                        <xsl:call-template name="ReadQuote">
                                            <xsl:with-param name="p_doctype" select="$Document_type"/>
                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                            <xsl:with-param name="p_attribute" select="$OneTimeVendor"/>
                                        </xsl:call-template>
                                    </xsl:value-of>
                                </xsl:otherwise>
                            </xsl:choose>
                        </VENDOR>
                        <!-- IG-33442 -->
                    </xsl:when>

                    <!--Otherwise map from cxml-->
                    <xsl:otherwise>
                        <!--Map company code-->
                        <COMP_CODE>
                            <xsl:value-of
                                select="$header/QuoteHeaderInfo/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
                            />
                        </COMP_CODE>

                        <!--Map the documen type-->
                        <DOC_TYPE>
                            <xsl:value-of
                                select="$header/QuoteHeaderInfo/FollowUpDocument/@category"/>
                        </DOC_TYPE>

                        <!--Map the vendor-->
                        <VENDOR>
                            <!--CI-1779 PrivateID / VendorID-->
                            <xsl:value-of select='$v_vendorid'/>
                        </VENDOR>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="$header/Contact[@role = 'buyer']">
                    <CREATED_BY>
                        <xsl:value-of select="$header/Contact[@role = 'buyer']/Name"/>
                    </CREATED_BY>
                </xsl:if>

                <LANGU_ISO>
                    <xsl:value-of select="substring(upper-case($header/@xml:lang),1,2)"/>
                </LANGU_ISO>

                <!--populate only if payment terms is not empty-->
                <xsl:if
                    test="string-length($header/QuoteHeaderInfo/PaymentTerms/@paymentTermCode) > 0">
                    <PMNTTRMS>
                        <xsl:value-of select="$header/QuoteHeaderInfo/PaymentTerms/@paymentTermCode"
                        />
                    </PMNTTRMS>
                </xsl:if>

                <PURCH_ORG>
                    <xsl:value-of
                        select="$header/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier"
                    />
                </PURCH_ORG>

                <xsl:if
                    test="string-length($header/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier) > 0">
                    <PUR_GROUP>
                        <xsl:value-of
                            select="$header/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier"
                        />
                    </PUR_GROUP>
                </xsl:if>

                <CURRENCY_ISO>
                    <xsl:value-of select="$header/@currency"/>
                </CURRENCY_ISO>

                <!--Covert Date coming from An to ERP format-->
                <xsl:variable name="v_date">
                    <xsl:call-template name="ERPDateTime">
                        <xsl:with-param name="p_date" select="$header/@quoteDate"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                    </xsl:call-template>
                </xsl:variable>
                <DOC_DATE>
                    <xsl:value-of select="substring($v_date, 1, 10)"/>
                </DOC_DATE>

                <xsl:choose>
                <xsl:when
                    test="string-length($header/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']) > 0">
                    <!--Covert Date coming from An to ERP format-->
                    <xsl:variable name="v_date">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date"
                                select="$header/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <VPER_START>
                        <xsl:value-of select="substring($v_date, 1, 10)"/>
                    </VPER_START>
                </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="v_vperdate">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date" select="$header/@quoteDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <VPER_START>
                            <xsl:value-of select="substring($v_vperdate,1,10)"/>
                        </VPER_START>                                                                          
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when
                    test="string-length($header/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']) > 0">
                    <!--Covert Date coming from An to ERP format-->
                    <xsl:variable name="v_date">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date"
                                select="$header/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <VPER_END>
                        <xsl:value-of select="substring($v_date, 1, 10)"/>
                    </VPER_END>
                    </xsl:when>
                    <xsl:otherwise>
                        <VPER_END>
                            <xsl:value-of select="'9999-12-31'"/>
                        </VPER_END>                                                                            
                    </xsl:otherwise>
                </xsl:choose>
                <QUOTATION>
                    <xsl:value-of select="substring($header/@quoteID,string-length($header/@quoteID)-9,10)"/>
                </QUOTATION>

                <!--Covert Date coming from An to ERP format-->
                <xsl:variable name="v_date">
                    <xsl:call-template name="ERPDateTime">
                        <xsl:with-param name="p_date" select="$header/@quoteDate"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                    </xsl:call-template>
                </xsl:variable>
                <QUOT_DATE>
                    <xsl:value-of select="substring($v_date, 1, 10)"/>
                </QUOT_DATE>               
            </POHEADER>
            <!--*****************************End of Header map******************************************************************************-->

            <!--******************************* Map the PO Account item ******************************************************************-->
            <!--Map the POACCUNT-->
            <POACCOUNT>
                <!--Loop over all the items-->
                <xsl:for-each select="$item">
                    <!--populate item only if Material is initial and PR ref is initial and line is parent line-->
                    <xsl:if
                        test="((ItemID/BuyerPartID = '') and (not(ReferenceDocumentInfo/DocumentInfo/@documentType = 'requisition')) and (string-length(@parentLineNumber) = 0))">
                        <item>
                            <PO_ITEM>
                                <xsl:value-of select="@lineNumber"/>
                            </PO_ITEM>

                            <SERIAL_NO>
                                <xsl:value-of select="'01'"/>
                            </SERIAL_NO>

                            <QUANTITY>
                                <xsl:value-of select="@quantity"/>
                            </QUANTITY>

                            <!--get the Account assignment maintained in PD-->
                            <xsl:variable name="AccAssCat">
                                <xsl:call-template name="ReadQuote">
                                    <xsl:with-param name="p_doctype" select="$Document_type"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                    <xsl:with-param name="p_attribute" select="$AccAssCat"/>
                                </xsl:call-template>
                            </xsl:variable>

                            <xsl:choose>
                                <!--Fetch the cost center and gl account if account category is K-->
                                <xsl:when test="$AccAssCat = 'K'">

                                    <GL_ACCOUNT>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                  select="$GLAccount"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </GL_ACCOUNT>
                                    <COSTCENTER>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                    select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                    select="$CostCenter"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </COSTCENTER>
                                </xsl:when>

                                <xsl:when test="$AccAssCat = 'A'">
                                    <!--Fetch Asset Number and subnumber if account category is A-->
                                    <ASSET_NO>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute" select="$Asset"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </ASSET_NO>

                                    <SUB_NUMBER>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                  select="$SubNumber"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </SUB_NUMBER>
                                </xsl:when>

                                <!--Fetch the Order ID and GL Account if account category is F-->
                                <xsl:when test="$AccAssCat = 'F'">

                                    <GL_ACCOUNT>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                  select="$GLAccount"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </GL_ACCOUNT>
                                    <ORDERID>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                    select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute" select="$OrderID"
                                                />
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </ORDERID>
                                </xsl:when>

                                <!--Fetch the WBS Element and GL Account if the account category is P-->
                                <xsl:when test="$AccAssCat = 'P'">
                                    <GL_ACCOUNT>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                  select="$GLAccount"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </GL_ACCOUNT>
                                    <WBS_ELEMENT>
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                    select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                    select="$WBSElement"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </WBS_ELEMENT>
                                    
                                </xsl:when>
                            </xsl:choose>
                        </item>
                    </xsl:if>
                </xsl:for-each>
            </POACCOUNT>
            <!--*********************************************Map the conditions table************************************************************************-->
            <!--            Map the PO conditions -->
            <POCOND>
                <!--Loop over all the items-->
                <xsl:for-each select="$item">
                    <!--Define gross price for parent/material item and service specification-->
                    <xsl:if
                        test="((not(exists(@parentLineNumber))) or ((exists(@parentLineNumber)) and @itemType = 'item'))">
                        <!--Map the Gross Price Condition-->
                        <xsl:if test="exists(ItemDetail/UnitPrice/Money)">
                            <item>
                                <ITM_NUMBER>
                                    <xsl:value-of select="@lineNumber"/>
                                </ITM_NUMBER>
                                <CONDITION_NO>
                                    <xsl:value-of select="'1'"/>
                                </CONDITION_NO>
                                <COND_TYPE>
                                    <xsl:if test="(not(exists(@parentLineNumber)))">
                                        <xsl:variable name="v_grosspricewithoutspace">
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype" select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute" select="$GrossPrice"
                                                />
                                            </xsl:call-template>
                                        </xsl:value-of>
                                        </xsl:variable>
                                        <xsl:value-of select="normalize-space($v_grosspricewithoutspace)"/>
                                    </xsl:if>
                                    <xsl:if test="((exists(@parentLineNumber)) and @itemType = 'item')">
                                        <xsl:variable name="v_ServiceGrossPricewithoutspace">
                                        <xsl:value-of>
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype" select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute" select="$ServiceGrossPrice"
                                                />
                                            </xsl:call-template>
                                        </xsl:value-of>
                                        </xsl:variable>
                                        <xsl:value-of select="normalize-space($v_ServiceGrossPricewithoutspace)"/>
                                    </xsl:if>
                                </COND_TYPE>
                                <COND_VALUE>
                                    <xsl:value-of select="ItemDetail/UnitPrice/Money"/>
                                </COND_VALUE>
                                <!--Map the Change ID as Insert-->
                                <CHANGE_ID>
                                    <xsl:value-of select="'I'"/>
                                </CHANGE_ID>
                                <!--Map the Currency-->
                                <CURRENCY>
                                    <xsl:value-of select="ItemDetail/UnitPrice/Money/@currency"/>
                                </CURRENCY>
                               
                            </item>
                        </xsl:if>
                    </xsl:if>
                    
                    <!--populate conditions only for parent items-->
                    <xsl:if test="(not(exists(@parentLineNumber)))">
                        <!--update all the modifications as conditions in ECC-->
                        <xsl:for-each select="ItemDetail/UnitPrice/Modifications/Modification">
                            <item>
                                <ITM_NUMBER>
                                    <xsl:value-of select="../../../../@lineNumber"/>
                                </ITM_NUMBER>
                                <!--Map condition number to Position-->
                                <CONDITION_NO>
                                    <xsl:value-of select="position() + 1"/>
                                </CONDITION_NO>
                                <!--Read the condition type maintained in Crosreference-->
                                <!--Mapping the condition type-->
                                <xsl:choose>
                                    <xsl:when
                                        test="exists(AdditionalDeduction/DeductionPercent[@percent])">
                                        <COND_TYPE>
                                            <xsl:variable name="v_DeductionPercentwithoutspace">
                                            <xsl:value-of>
                                                <xsl:call-template name="ReadQuote">
                                                  <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                  <xsl:with-param name="p_pd" select="$v_pd"/>
                                                  <xsl:with-param name="p_attribute"
                                                  select="$DeductionPercent"/>
                                                </xsl:call-template>
                                            </xsl:value-of>
                                            </xsl:variable>
                                            <xsl:value-of select="normalize-space($v_DeductionPercentwithoutspace)"/>
                                        </COND_TYPE>
                                        <COND_VALUE>
                                            <xsl:value-of
                                                select="AdditionalDeduction/DeductionPercent/@percent"
                                            />
                                        </COND_VALUE>
                                    </xsl:when>
                                    <xsl:when
                                        test="exists(AdditionalDeduction/DeductionAmount/Money)">
                                        <COND_TYPE>
                                            <xsl:variable name="v_DeductionAmountwithoutspace">
                                            <xsl:value-of>
                                                <xsl:call-template name="ReadQuote">
                                                  <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                  <xsl:with-param name="p_pd" select="$v_pd"/>
                                                  <xsl:with-param name="p_attribute"
                                                  select="$DeductionAmount"/>
                                                </xsl:call-template>
                                            </xsl:value-of>
                                            </xsl:variable>
                                            <xsl:value-of select="normalize-space($v_DeductionAmountwithoutspace)"/>
                                        </COND_TYPE>
                                        <COND_VALUE>
                                            <xsl:value-of
                                                select="AdditionalDeduction/DeductionAmount/Money"/>
                                        </COND_VALUE>
                                        <!--Map the Currency-->
                                        <CURRENCY>
                                            <xsl:value-of select="AdditionalDeduction/DeductionAmount/Money/@currency"/>
                                        </CURRENCY>
                                    </xsl:when>
                                    <xsl:when test="exists(AdditionalCost/Percentage[@percent])">
                                        <COND_TYPE>
                                            <xsl:variable name="v_AdditionalPercentwithoutspace">
                                            <xsl:value-of>
                                                <xsl:call-template name="ReadQuote">
                                                  <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                  <xsl:with-param name="p_pd" select="$v_pd"/>
                                                  <xsl:with-param name="p_attribute"
                                                  select="$AdditionalPercent"/>
                                                </xsl:call-template>
                                            </xsl:value-of>
                                            </xsl:variable>
                                            <xsl:value-of select="normalize-space($v_AdditionalPercentwithoutspace)"/>
                                        </COND_TYPE>
                                        <COND_VALUE>
                                            <xsl:value-of
                                                select="AdditionalCost/Percentage/@percent"/>
                                        </COND_VALUE>
                                    </xsl:when>
                                    <xsl:when test="exists(AdditionalCost/Money)">
                                        <COND_TYPE>
                                            <xsl:variable name="v_AdditionalMoneywithoutspace">
                                            <xsl:value-of>
                                                <xsl:call-template name="ReadQuote">
                                                  <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                  <xsl:with-param name="p_pd" select="$v_pd"/>
                                                  <xsl:with-param name="p_attribute"
                                                  select="$AdditionalMoney"/>
                                                </xsl:call-template>
                                            </xsl:value-of>
                                            </xsl:variable>
                                            <xsl:value-of select="normalize-space($v_AdditionalMoneywithoutspace)"/>
                                        </COND_TYPE>
                                        <COND_VALUE>
                                            <xsl:value-of select="AdditionalCost/Money"/>
                                        </COND_VALUE>
                                        <!--Map the Currency-->
                                        <CURRENCY>
                                            <xsl:value-of select="AdditionalCost/Money/@currency"/>
                                        </CURRENCY>
                                    </xsl:when>
                                </xsl:choose>
                                <!--Map the Change ID as Insert-->
                                <CHANGE_ID>
                                    <xsl:value-of select="'I'"/>
                                </CHANGE_ID>
                            </item>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
            </POCOND>
            
            <!--*****************************Map PO Item************************************************************************************-->
            <!--IG-41073 Re-organized the elements to adhere schema-->
            <POITEM>
                <!--loop over all the items-->
                <xsl:for-each select="$item">
                    <!--if parent line number is initial then map it to PO item-->
                    <xsl:if test="(not(exists(@parentLineNumber)))">
                        <item>
                            <PO_ITEM>
                                <xsl:value-of select="@lineNumber"/>
                            </PO_ITEM>

                            <SHORT_TEXT>
                                <xsl:value-of select="substring(ItemDetail/Description,1,40)"/> <!-- IG-32867 -->
                            </SHORT_TEXT>

                            <xsl:if test="not(ItemID/BuyerPartID = '')">
                                <xsl:if test="string-length(ItemID/BuyerPartID) lt 19">
                                <MATERIAL>
                                    <xsl:value-of select="ItemID/BuyerPartID"/>
                                </MATERIAL>
                                </xsl:if>
                            </xsl:if>

                            <xsl:choose>
                                <!--spot quote scenario identified-->
                                <xsl:when test="($compcode = 0 and $doctype = 0)">
                                    <!--Read plant from cross reference-->
                                    <PLANT>
                                        <xsl:value-of>
                                            <!--call the template to read Crossreferencevalues-->
                                            <xsl:call-template name="ReadQuote">
                                                <xsl:with-param name="p_doctype"
                                                  select="$Document_type"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                <xsl:with-param name="p_attribute"
                                                  select="$DefaultPlant"/>
                                            </xsl:call-template>
                                        </xsl:value-of>
                                    </PLANT>
                                </xsl:when>
                                <!--Otherwise map plant coming from cxml-->
                                <xsl:otherwise>
                                    <xsl:if test="string-length(ShipTo/Address/@addressID) > 0">
                                        <PLANT>
                                            <xsl:value-of select="ShipTo/Address/@addressID"/>
                                        </PLANT>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>

                            <MATL_GROUP>
                                <xsl:value-of
                                    select="ItemDetail/Classification[@domain = 'MaterialGroup']/@code"
                                />
                            </MATL_GROUP>

                            <VEND_MAT>
                                <xsl:value-of select="ItemID/SupplierPartID"/>
                            </VEND_MAT>

                            <QUANTITY>
                                <xsl:value-of select="@quantity"/>
                            </QUANTITY>

                            <PO_UNIT_ISO>
                                <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                            </PO_UNIT_ISO>

                            <xsl:if
                                test="string-length(ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']) > 0">
                                <PRICE_UNIT>
                                    <xsl:value-of
                                        select="ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']"
                                    />
                                </PRICE_UNIT>
                            </xsl:if>

                            <!--Map the item category based on entries in PD-->
                            <xsl:choose>
                                <xsl:when test="@itemClassification = 'service'">
                                    <ITEM_CAT>
                                        <xsl:value-of select="'9'"/>
                                    </ITEM_CAT>
                                </xsl:when>
                                <xsl:when test="@itemClassification = 'material'">
                                    <ITEM_CAT>
                                        <xsl:value-of select="'0'"/>
                                    </ITEM_CAT>
                                </xsl:when>
                            </xsl:choose>

                            <!--Moving the PO Account assignment logic to XSLT-->
                            <!--Map the ACCTASSCAT only if PR reference and Material is initial and item is parent item-->
                            <xsl:if
                                test="((ItemID/BuyerPartID = '') and (not(ReferenceDocumentInfo/DocumentInfo/@documentType = 'requisition')) and (string-length(@parentLineNumber) = 0))">
                                <ACCTASSCAT>
                                    <xsl:value-of>
                                        <xsl:call-template name="ReadQuote">
                                            <xsl:with-param name="p_doctype" select="$Document_type"/>
                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                            <xsl:with-param name="p_attribute" select="$AccAssCat"/>
                                        </xsl:call-template>
                                    </xsl:value-of>
                                </ACCTASSCAT>
                            </xsl:if>

                            <xsl:if test="string-length(TermsOfDelivery/TransportTerms/@value) > 0">
                                <INCOTERMS1>
                                    <xsl:value-of select="TermsOfDelivery/TransportTerms/@value"/>
                                </INCOTERMS1>
                            </xsl:if>

                            <xsl:if test="string-length(TermsOfDelivery/TransportTerms) > 0">
                                <INCOTERMS2>
                                    <xsl:value-of select="TermsOfDelivery/TransportTerms"/>
                                </INCOTERMS2>
                            </xsl:if>
                            
                            <xsl:if
                                test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'quoteRequest'] and string-length(ReferenceDocumentInfo/DocumentInfo[@documentType = 'quoteRequest']/@documentID) > 0">
                                <RFQ_NO>
                                    <xsl:choose>
                                        <xsl:when test="number(ReferenceDocumentInfo/DocumentInfo[@documentType = 'quoteRequest']/@documentID)">
                                            <xsl:value-of select="format-number(ReferenceDocumentInfo/DocumentInfo[@documentType = 'quoteRequest']/@documentID, '0000000000')"/>                                
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'quoteRequest']/@documentID"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </RFQ_NO>
                                
                                <RFQ_ITEM>
                                    <xsl:value-of
                                        select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'quoteRequest']/../@lineNumber"
                                    />
                                </RFQ_ITEM>
                            </xsl:if>

                            <xsl:if
                                test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition'] and string-length(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID) > 0">
                                <PREQ_NO>
                                    <xsl:choose>
                                        <xsl:when test="number(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID)">
                                            <xsl:value-of select="format-number(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID, '0000000000')"/>                                
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID"/>
                                        </xsl:otherwise>
                                    </xsl:choose>       
                                </PREQ_NO>

                                <PREQ_ITEM>
                                    <xsl:value-of
                                        select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/../@lineNumber"
                                    />
                                </PREQ_ITEM>
                            </xsl:if>

                            <xsl:if test="@itemClassification = 'service'">
                                <PCKG_NO>
                                    <xsl:value-of select="@lineNumber"/>
                                </PCKG_NO>
                            </xsl:if>

                            <xsl:if test="not(ItemID/BuyerPartID = '')">
                                <MATERIAL_LNG>
                                    <xsl:value-of select="ItemID/BuyerPartID"/>
                                </MATERIAL_LNG>
                            </xsl:if>
                        </item>
                    </xsl:if>                   
                </xsl:for-each>
            </POITEM>
            <!--End of Item map-->           
            <!--    Populate the PO Item Partners structure    -->            
            <POITEMPARTNER>
                <xsl:if test="exists($item/SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
                    <!--Loop over all the items-->
                    <xsl:for-each select="$item">
                        <xsl:if test="(not(exists(@parentLineNumber)))">
                            <xsl:variable name="v_number">
                                <xsl:value-of select="@lineNumber"/>
                            </xsl:variable>
                            <!--Loop over all Item Partners with respect to PO Item number-->                
                            <xsl:for-each select="$item[@lineNumber = $v_number]/SupplierProductionFacilityRelations/ProductionFacilityAssociation">                               
                                <item>
                                    <PO_ITEM>
                                        <xsl:value-of select="../../@lineNumber"/>
                                    </PO_ITEM>
                                    <PARTNERDESC>
                                        <xsl:value-of
                                            select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"
                                        />
                                    </PARTNERDESC>
                                    <LANGU>
                                        <xsl:value-of select="'E'"/>
                                    </LANGU>
                                    <BUSPARTNO>
                                        <xsl:value-of select="ProductionFacility/IdReference/@identifier"/>
                                    </BUSPARTNO>
                                </item>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </POITEMPARTNER>   
            <!--******************************************* Map the limits table ***********************************************************-->
            <!--    Populate the Limits structure only if Expected or Overall limit exists-->
            <xsl:if
                test="((exists($item/ItemDetail/ExpectedLimit/Money)) or (exists($item/ItemDetail/OverallLimit/Money)))">
                <POLIMITS>

                    <xsl:for-each select="$item">

                        <!--If parentLineNumber does not exists and line is a service line build the item-->
                        <xsl:if
                            test="((not(exists(@parentLineNumber)) and (@itemClassification = 'service')))">
                            <item>
                                <PCKG_NO>
                                    <xsl:if test="@itemClassification = 'service'">
                                        <xsl:value-of select="@lineNumber"/>
                                    </xsl:if>
                                </PCKG_NO>

                                <!--if overall limit money exists then map or map to default ''-->
                                <xsl:choose>
                                    <xsl:when test="not(ItemDetail/OverallLimit/Money = '')">
                                        <LIMIT>
                                            <xsl:value-of select="ItemDetail/OverallLimit/Money"/>
                                        </LIMIT>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        <LIMIT>
                                            <xsl:value-of select="''"/>
                                        </LIMIT>
                                    </xsl:otherwise>
                                </xsl:choose>

                                <!--If overall limit does not exist map to 'X'-->
                                <xsl:if test="(not(exists(ItemDetail/OverallLimit)))">
                                    <NO_LIMIT>
                                        <xsl:value-of select="'X'"/>
                                    </NO_LIMIT>
                                </xsl:if>

                                <!--map if expected limit is present else map to default ''-->
                                <xsl:choose>
                                    <xsl:when test="not(ItemDetail/ExpectedLimit/Money = '')">
                                        <EXP_VALUE>
                                            <xsl:value-of select="ItemDetail/ExpectedLimit/Money"/>
                                        </EXP_VALUE>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        <EXP_VALUE>
                                            <xsl:value-of select="''"/>
                                        </EXP_VALUE>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </item>
                        </xsl:if>
                    </xsl:for-each>
                </POLIMITS>
            </xsl:if>           
            <!--    Populate the PO Header Partners structure    -->              
            <POPARTNER>
                <xsl:if test="exists($header/SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
                    <xsl:for-each select="$header/SupplierProductionFacilityRelations/ProductionFacilityAssociation">                   
                        <item>
                            <PARTNERDESC>
                                <xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
                            </PARTNERDESC> 
                            <LANGU>
                                <xsl:value-of select="'E'"/>
                            </LANGU>
                            <BUSPARTNO>
                                <xsl:value-of select="ProductionFacility/IdReference/@identifier"/>
                            </BUSPARTNO>
                        </item>                   
                    </xsl:for-each>
                </xsl:if>
            </POPARTNER>
            <!--********************************************** Map the schedule lines ************************************************-->
            <!--Populate the schedule line items-->
            <POSCHEDULE>
                <!--Loop over all the items-->
                <xsl:for-each select="$item">
                    <!--Map the schedule lines for all parent items-->
                    <xsl:if test="(not(exists(@parentLineNumber)))">
                        <item>
                            <PO_ITEM>
                                <xsl:value-of select="@lineNumber"/>
                            </PO_ITEM>

                            <!--Covert Date coming from An to ERP format-->
                            <xsl:variable name="v_date">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date" select="@requestedDeliveryDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <DELIVERY_DATE>
                               <!-- <xsl:value-of <!-\-s-\->elect="substring($v_date, 1, 10)"/>-->
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of select="translate(substring($v_date, 1, 10), '-', '')" />
                            </DELIVERY_DATE>

                            <QUANTITY>
                                <xsl:value-of select="@quantity"/>
                            </QUANTITY>

                            <xsl:if
                                test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition'] and string-length(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID) > 0">
                                <PREQ_NO>
                                    <xsl:choose>
                                        <xsl:when test="number(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID)">
                                            <xsl:value-of select="format-number(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID, '0000000000')"/>                                
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID"/>
                                        </xsl:otherwise>
                                    </xsl:choose>   
                                </PREQ_NO>

                                <PREQ_ITEM>
                                    <xsl:value-of
                                        select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/../@lineNumber"
                                    />
                                </PREQ_ITEM>
                            </xsl:if>

                        </item>
                    </xsl:if>
                </xsl:for-each>
            </POSCHEDULE>

            <!--*************************************Map the services table****************************************88-->
            <POSERVICES>
                <!--Loop over all the items-->
                <xsl:for-each select="$item">
                    <xsl:variable name="Counter" select="12340"/>

                    <!--itemClassification = service and if this is a parent service item or an outline item, create this node-->
                    <xsl:choose>
                        <!--Mapping followed if child service item or itemtype is composite -->
                        <xsl:when
                            test="((not(exists(@parentLineNumber)) and @itemClassification = 'service') or @itemType = 'composite')">
                            <item>
                                <LINE_NO>
                                    <xsl:value-of select="@lineNumber"/>
                                </LINE_NO>

                                <EXT_LINE>
                                    <xsl:choose>
                                        <xsl:when
                                            test="(not(exists(@parentLineNumber)) and (@itemType = 'composite'))">
                                            <xsl:value-of select="'0'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
<!--                                            Reverting code for 33406 for IG-37707-->
                                            <!--                                            Begin of IG-33406-->
                                                                                        <xsl:value-of select="@parentLineNumber"/>
                                            <!--<xsl:choose>
                                                <xsl:when test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition'] and string-length(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID) > 0">
                                                    <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/../@lineNumber"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@parentLineNumber"/>
                                                </xsl:otherwise>
                                            </xsl:choose>  -->                                          
                                            <!--                                            End of IG-33406-->
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </EXT_LINE>

                                <OUTL_NO>
                                    <xsl:choose>
                                        <xsl:when
                                            test="(not(exists(@parentLineNumber)) and (@itemType = 'composite'))">
                                            <xsl:value-of
                                                select="substring(ItemDetail/Description, 1, 8)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="substring(ItemDetail/Description/ShortName, 1, 8)"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </OUTL_NO>

                                <OUTL_IND>
                                    <xsl:if test="@itemType = 'composite'">
                                        <xsl:value-of select="'X'"/>
                                    </xsl:if>
                                </OUTL_IND>

                                <SUBPCKG_NO>
                                    <xsl:if test="@itemType = 'composite'">
                                        <xsl:value-of select="@lineNumber + 1"/>
                                    </xsl:if>
                                </SUBPCKG_NO>

                                <SHORT_TEXT>
                                    <xsl:value-of
                                        select="substring(ItemDetail/Description[not(exists(ShortName))],1,40)"/> <!-- IG-32867 -->
                                </SHORT_TEXT>
<!--                                Begin of IG-37707-->
                                <TMP_PCKG>
                                    <xsl:value-of select="@lineNumber"/>
                                </TMP_PCKG>
                                <TMP_LINE>
                                    <xsl:choose>
                                                <xsl:when test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition'] and string-length(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID) > 0">
                                                    <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/../@lineNumber"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@parentLineNumber"/>
                                                </xsl:otherwise>
                                            </xsl:choose>     
                                </TMP_LINE>
<!--                                End of IG-37707-->
                            </item>
                        </xsl:when>

                        <!--itemClassification = service and if this is a child service item-->

                        <xsl:when test="(exists(@parentLineNumber) and @itemType = 'item')">
                            <item>
                                <PCKG_NO>
                                    <xsl:value-of select="@parentLineNumber + 1"/>
                                </PCKG_NO>

                                <!--Counter is set to 12340 and incremented for each item-->
                                <LINE_NO>
                                    <xsl:value-of select="$Counter + position()"/>
                                </LINE_NO>

                                <EXT_LINE>
<!--                                    Reverting code for 33406 for IG-37707-->
                                    <!--                                            Begin of IG-33406-->                                   
                                    <xsl:value-of select="@lineNumber"/>
                                  <!--  <xsl:choose>
                                        <xsl:when test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition'] and string-length(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID) > 0">
                                            <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/../@lineNumber"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@lineNumber"/>
                                        </xsl:otherwise>
                                    </xsl:choose>   -->                                         
                                    <!--                                            End of IG-33406-->   
                                </EXT_LINE>

                                <xsl:if test="(not(ItemID/BuyerPartID = ''))">
                                    <SERVICE>
                                        <xsl:value-of select="ItemID/BuyerPartID"/>
                                    </SERVICE>
                                </xsl:if>

                                <QUANTITY>
                                    <xsl:value-of select="@quantity"/>
                                </QUANTITY>

                                <UOM_ISO>
                                    <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                                </UOM_ISO>

                                <xsl:if test="string-length(ItemDetail/UnitPrice/Money) > 0">
                                    <GR_PRICE>
                                        <xsl:value-of
                                            select="(format-number(ItemDetail/UnitPrice/Money, '0.00'))"
                                        />
                                    </GR_PRICE>
                                </xsl:if>

                                <SHORT_TEXT>
                                    <xsl:value-of select="substring(ItemDetail/Description,1,40)"/> <!-- IG-32867 -->
                                </SHORT_TEXT>
                                <!--                                Begin of IG-37707-->
                                <TMP_PCKG>
                                    <xsl:value-of select="@parentLineNumber + 1"/>
                                </TMP_PCKG>
                                <TMP_LINE>
                                      <xsl:choose>
                                        <xsl:when test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition'] and string-length(ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID) > 0">
                                            <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/../@lineNumber"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@lineNumber"/>
                                        </xsl:otherwise>
                                    </xsl:choose>     
                                </TMP_LINE>
                                <!--                                End of IG-37707-->
                                <xsl:if test="@serviceLineType = 'openquantity'">
                                    <OPEN_QTY>
                                        <xsl:value-of select="'X'"/>
                                    </OPEN_QTY>
                                </xsl:if>

                                <xsl:if test="@serviceLineType = 'information'">
                                    <INFORM>
                                        <xsl:value-of select="'X'"/>
                                    </INFORM>
                                </xsl:if>

                                <xsl:if test="@serviceLineType = 'blanket'">
                                    <BLANKET>
                                        <xsl:value-of select="'X'"/>
                                    </BLANKET>
                                </xsl:if>

                                <xsl:if test="@serviceLineType = 'contingency'">
                                    <EVENTUAL>
                                        <xsl:value-of select="'X'"/>
                                    </EVENTUAL>
                                </xsl:if>

                                <xsl:if test="ItemDetail/Classification[@domain = 'MaterialGroup']">
                                    <MATL_GROUP>
                                        <xsl:value-of
                                            select="ItemDetail/Classification[@domain = 'MaterialGroup']/@code"
                                        />
                                    </MATL_GROUP>
                                </xsl:if>

                            <!--Mapping  Alternative--> 
                                <xsl:if test="exists(Alternative)">
                                    <xsl:choose>
                                        <xsl:when test="Alternative/@alternativeType = 'basicLine'">
                                            <BASIC_LINE>
                                                <xsl:value-of select="'X'"/>
                                            </BASIC_LINE>
                                        </xsl:when>
                                        <xsl:when test="Alternative/@alternativeType = 'alternativeLine'">
                                            <ALTERNAT>
                                                <xsl:value-of select="'X'"/>
                                            </ALTERNAT>
                                            <BASLINE_NO>
                                        <!--Not using the Alternate Line from cXML payload directly , instead use it 
                                            to fetch the corresponding dynamically allocated INTRO number-->
                                                <xsl:variable name="v_altLine" select="Alternative/@basicLineNumber"/>                                                
                                                <xsl:for-each select="$v_loopItem">
                                                    <xsl:if test="@lineNumber = $v_altLine ">
                                                        <xsl:value-of select="$Counter + position()"/>
                                                    </xsl:if>
                                                </xsl:for-each> 
                                            </BASLINE_NO>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:if>                                
                            </item>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </POSERVICES>

            <!--Map the Service Account Assignment table-->
            <POSRVACCESSVALUES>
                <!--Loop over all the items-->
                <xsl:for-each select="$item">
                    <xsl:variable name="Counter" select="12340"/>
                    <xsl:choose>
                        <!--Mapping followed when service parent item and limits does not exist -->
                        <xsl:when
                            test="(((not(exists(@parentLineNumber))) and (@itemClassification = 'service')) and (not(exists(ItemDetail/ExpectedLimit/Money) or exists(ItemDetail/OverallLimit/Money))))">
                            <item>
                                <PCKG_NO>
                                    <xsl:value-of select="@lineNumber"/>
                                </PCKG_NO>

                                <LINE_NO>
                                    <xsl:value-of select="@lineNumber"/>
                                </LINE_NO>

                                <SERNO_LINE>
                                    <xsl:value-of select="'00'"/>
                                </SERNO_LINE>

                                <SERIAL_NO>
                                    <xsl:value-of select="'00'"/>
                                </SERIAL_NO>

                                <QUANTITY>
                                    <xsl:value-of select="@quantity"/>
                                </QUANTITY>

                                <xsl:if test="string-length(ItemDetail/UnitPrice/Money) > 0">
                                    <NET_VALUE>
                                        <xsl:value-of
                                            select="format-number(ItemDetail/UnitPrice/Money, '0.00')"
                                        />
                                    </NET_VALUE>
                                </xsl:if>

                            </item>
                        </xsl:when>

                        <!--Mapping followed when child service item and line type is not information -->
                        <xsl:when
                            test="(((exists(@parentLineNumber)) and @itemType = 'item') and (not(@serviceLineType = 'Information')))">
                            <item>

                                <PCKG_NO>
                                    <xsl:value-of select="@parentLineNumber + 1"/>
                                </PCKG_NO>

                                <LINE_NO>
                                    <xsl:value-of select="$Counter + position()"/>
                                </LINE_NO>

                                <SERNO_LINE>
                                    <xsl:value-of select="'01'"/>
                                </SERNO_LINE>

                                <SERIAL_NO>
                                    <xsl:value-of select="'01'"/>
                                </SERIAL_NO>

                                <QUANTITY>
                                    <xsl:value-of select="@quantity"/>
                                </QUANTITY>

                                <xsl:if test="string-length(ItemDetail/UnitPrice/Money) > 0">
                                    <NET_VALUE>
                                        <xsl:value-of
                                            select="format-number(ItemDetail/UnitPrice/Money, '0.00')"
                                        />
                                    </NET_VALUE>
                                </xsl:if>
                            </item>

                        </xsl:when>

                        <!--Mapping followed when child service item and limits exists-->
                        <xsl:when
                            test="(((not(exists(@parentLineNumber))) and (@itemClassification = 'service')) and ((exists(ItemDetail/ExpectedLimit/Money)) or (exists(ItemDetail/OverallLimit/Money))))">
                            <item>
                                <PCKG_NO>
                                    <xsl:value-of select="@lineNumber"/>
                                </PCKG_NO>

                                <LINE_NO>
                                    <xsl:value-of select="'0'"/>
                                </LINE_NO>

                                <SERNO_LINE>
                                    <xsl:value-of select="'01'"/>
                                </SERNO_LINE>

                                <SERIAL_NO>
                                    <xsl:value-of select="'01'"/>
                                </SERIAL_NO>

                                <QUANTITY>
                                    <xsl:value-of select="'1'"/>
                                </QUANTITY>

                                <xsl:if test="string-length(ItemDetail/ExpectedLimit/Money) > 0">
                                    <NET_VALUE>
                                        <xsl:value-of
                                            select="format-number(ItemDetail/ExpectedLimit/Money, '0.00')"
                                        />
                                    </NET_VALUE>
                                </xsl:if>
                            </item>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </POSRVACCESSVALUES>
            
            <!--Populate the header text table-->
            <!--populate header texts get the header textid from PD-->
            <POTEXTHEADER>
                <xsl:if test="exists($header/Comments)">                
                    <xsl:call-template name="ExtractComments">
                        <xsl:with-param name="p_comments" select="$header/Comments"/>
                        <xsl:with-param name="p_lang" select="$v_lang"/>
                        <xsl:with-param name="p_doctype" select="$Document_type"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                        <xsl:with-param name="p_attribute" select="$HeaderTextID"/>
                    </xsl:call-template>              
                </xsl:if>
                
                <xsl:if test="string-length($header/@quoteID) > 10">                
                    <xsl:call-template name="ExtractComments">
                        <xsl:with-param name="p_comments" select="$header/@quoteID"/>
                        <xsl:with-param name="p_lang" select="$v_lang"/>
                        <xsl:with-param name="p_doctype" select="$Document_type"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                        <xsl:with-param name="p_attribute" select="$SpotQuoteID"/>
                    </xsl:call-template>
                </xsl:if>
                
                <item>
                    <TEXT_ID>
                        <xsl:value-of select="'QMID'"/>                             <!-- IG-41026 -->
                    </TEXT_ID>
                    <TEXT_LINE>
                        <xsl:value-of select="$header/@quoteID"/>
                    </TEXT_LINE>
                </item>  
            </POTEXTHEADER>    
            <!--********************************************* Map the Item texts table *****************************************************************-->
            <!--Populate Item texts get the item text ID from PD-->
            <xsl:if test="exists($item/Comments)">
                <POTEXTITEM>
                    <!--Loop over all the items-->
                    <xsl:for-each select="$item">
                        <xsl:if test="exists(Comments)">
                                                        
                                     <xsl:call-template name="ExtractComments">
                                        <xsl:with-param name="p_comments" select="Comments"/>
                                        <xsl:with-param name="p_lang" select="$v_lang"/>
                                        <xsl:with-param name="p_doctype" select="$Document_type"/>
                                        <xsl:with-param name="p_pd" select="$v_pd"/>
                                        <xsl:with-param name="p_linenum" select="@lineNumber"/>
                                        <xsl:with-param name="p_attribute" select="$LineTextID"/>
                                    </xsl:call-template>
                                
                            
                        </xsl:if>
                    </xsl:for-each>
                </POTEXTITEM>
            </xsl:if>           
        </n1:ARBCIG_QUOTE>
    </xsl:template>
</xsl:stylesheet>
