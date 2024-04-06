<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="#all" xmlns:n0="http://sap.com/xi/ARBCIG1">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
        <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <!--Parameters-->
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anEnvName"/>
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_DefaultLang">
<!--Fill language ISO Code from Material Description Field. Fill from default only if this is empty-->
<!--This was discussed that Material description will always have an ISO value coded.-->
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(n0:QualityInspectionRequest/QualityInspectionRequestHeader/MaterialDescription/@languageCode)) > 0">
                <xsl:value-of select="n0:QualityInspectionRequest/QualityInspectionRequestHeader/MaterialDescription/@languageCode"/>   
            </xsl:when>
            <xsl:otherwise>
<!--Just in case we do not get a value ,then call FilldefaultLang-->
                <xsl:call-template name="FillDefaultLang">
                    <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                </xsl:call-template>             
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="n0:QualityInspectionRequest">
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
                                <Identity>
                                    <xsl:value-of select="'CIG'"/>
                                </Identity>
                            </Credential> 
                        </From>
                        <To>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'VendorID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="QualityInspectionRequestHeader/VendorContactInfo/InternalID"/>
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
                            <UserAgent>CIG</UserAgent>
                        </Sender>
                    </Header>
                    <Request>
                        <xsl:choose>
                            <xsl:when test="$anEnvName = 'PROD'">
                                <xsl:attribute name="deploymentMode">
                                    <xsl:value-of select="'production'"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="deploymentMode">
                                    <xsl:value-of select="'test'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <QualityInspectionRequest>
                            <QualityInspectionRequestHeader>
                                <xsl:attribute name="requestID"
                                    select="QualityInspectionRequestHeader/InspectionLotId"/>
                                <xsl:variable name="v_InsDate">
                                    <!--Extract date from InspectionLotDate field that has both Date and time from ERP  -->
                                    <xsl:value-of
                                        select="substring(QualityInspectionRequestHeader/InspectionLotDate, 1, 8)"
                                    />
                                </xsl:variable>
                                <xsl:variable name="v_InsTime">
                                    <!--Extract Time from InspectionLotDate field that has both Date and time from ERP  -->
                                    <xsl:choose>
                                        <xsl:when test="string-length(substring(QualityInspectionRequestHeader/InspectionLotDate, 10, 6)) > 0">
                                            <xsl:value-of
                                                select="substring(QualityInspectionRequestHeader/InspectionLotDate, 10, 6)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'000000'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:attribute name="requestDate">
                                    <!--Convert to AN Readable format-->
                                    <xsl:call-template name="ANDateTime">
                                        <xsl:with-param name="p_date" select="$v_InsDate"/>
                                        <xsl:with-param name="p_time" select="$v_InsTime"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="operation">
                                    <!--Action code will denote mode of transaction , new or update-->
                                    <xsl:choose>
                                        <xsl:when
                                            test="QualityInspectionRequestHeader/ActionCode = 'CREATED'">
                                            <xsl:value-of select="'new'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'update'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <!--Created by-->
                                <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/CreatedBy)) > 0">
                                <xsl:attribute name="createdBy"
                                    select="QualityInspectionRequestHeader/CreatedBy"/>
                                </xsl:if>
                                <IdReference>
                                    <!--Inspection Type-->
                                    <xsl:attribute name="identifier"
                                        select="QualityInspectionRequestHeader/InspectionType"/>
                                    <xsl:attribute name="domain" select="'inspectionType'"/>
                                    <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/InspectionTypeDescription)) > 0" >
                                    <Description>
                                        <!--Inspection Description-->
                                        <xsl:attribute name="xml:lang"
                                            select="$v_DefaultLang"/>
                                        <xsl:value-of
                                            select="QualityInspectionRequestHeader/InspectionTypeDescription"
                                        />
                                    </Description>
                                    </xsl:if>
                                </IdReference>
                                <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/VendorContactInfo/InternalID)) > 0">
                                <Contact>
                                    <!--Seller Party contact details-->
                                    <xsl:attribute name="role" select="'sellerParty'"/>
                                    <!--Assign internal ID-->
                                    <xsl:attribute name="addressID"
                                        select="QualityInspectionRequestHeader/VendorContactInfo/InternalID"/>
                                    <!--Assign Name-->
                                    <Name>
                                        <xsl:attribute name="xml:lang" select="$v_DefaultLang"/>
                                        <xsl:value-of
                                            select="QualityInspectionRequestHeader/VendorContactInfo/Address/OrganisationFormOfAddress/Name"
                                        />
                                    </Name>
                                    <!--Postal Address details-->
                                    <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/StreetName)) > 0">
                                    <PostalAddress>
                                        <xsl:attribute name="name"
                                            select="QualityInspectionRequestHeader/VendorContactInfo/Address/PersonName/GivenName"/>
                                        <Street>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/StreetName"
                                            />
                                        </Street>
                                        <City>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/CityName"
                                            />
                                        </City>
                                        <State>
                                            <xsl:attribute name="isoStateCode"
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/RegionCode"/>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/RegionName"
                                            />
                                        </State>
                                        <PostalCode>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/POBoxPostalCode"
                                            />
                                        </PostalCode>
                                        <Country>
                                            <xsl:attribute name="isoCountryCode"
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/CountryCode"/>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/PhysicalAddress/CountryName"
                                            />
                                        </Country>
                                    </PostalAddress>
                                    </xsl:if>
                                    <!--E-MAIL Address details-->
                                    <xsl:if test="(string-length(normalize-space(QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Email)) > 0)">
                                        <Email>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Email/URI"
                                            />
                                        </Email>
                                    </xsl:if>
                                    <!--Multiple telephone values possible-->
                                    <xsl:for-each
                                        select="QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Telephone">
                                        <Phone>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode"
                                                  select="Number/CountryCode"/>
                                                  <xsl:value-of select="Number/CountryDiallingCode"
                                                  />
                                                </CountryCode>
                                                <AreaOrCityCode>
                                                  <xsl:value-of select="Number/AreaID"/>
                                                </AreaOrCityCode>
                                                <Number>
                                                  <xsl:value-of select="Number/SubscriberID"/>
                                                </Number>
                                                <Extension>
                                                  <xsl:value-of select="Number/ExtensionID"/>
                                                </Extension>
                                            </TelephoneNumber>
                                        </Phone>
                                    </xsl:for-each>
                                    <!--Fax communication details-->
                                    <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Facsimile)) > 0">
                                        <Fax>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode"
                                                  select="QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Facsimile/Number/CountryCode"/>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Facsimile/Number/CountryDiallingCode"
                                                  />
                                                </CountryCode>
                                                <AreaOrCityCode>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Facsimile/Number/AreaID"
                                                  />
                                                </AreaOrCityCode>
                                                <Number>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Facsimile/Number/SubscriberID"
                                                  />
                                                </Number>
                                                <Extension>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/VendorContactInfo/Address/Communication/Facsimile/Number/ExtensionID"
                                                  />
                                                </Extension>
                                            </TelephoneNumber>
                                        </Fax>
                                    </xsl:if>
                                </Contact>
                                </xsl:if>
                                <!--BuyerParty details fetched from CompanyContactInfo-->
                                <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/CompanyContactInfo/InternalId)) > 0">
                                <Contact>
                                    <xsl:attribute name="role" select="'buyerParty'"/>
                                    <xsl:attribute name="addressID"
                                        select="QualityInspectionRequestHeader/CompanyContactInfo/InternalId"/>
                                    <Name>
                                        <xsl:attribute name="xml:lang" select="$v_DefaultLang"/>
                                        <xsl:value-of
                                            select="QualityInspectionRequestHeader/CompanyContactInfo/Address/OrganisationFormOfAddress/Name"
                                        />
                                    </Name>
                                    <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/StreetName)) > 0">
                                    <PostalAddress>
                                        <Street>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/StreetName"
                                            />
                                        </Street>
                                        <City>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/CityName"
                                            />
                                        </City>
                                        <State>
                                            <xsl:attribute name="isoStateCode"
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/RegionCode"/>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/RegionName"
                                            />
                                        </State>
                                        <PostalCode>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/POBoxPostalCode"
                                            />
                                        </PostalCode>
                                        <Country>
                                            <xsl:attribute name="isoCountryCode"
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/CountryCode"/>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/PhysicalAddress/CountryName"
                                            />
                                        </Country>
                                    </PostalAddress>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Email)) > 0">
                                        <Email>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Email/URI"
                                            />
                                        </Email>
                                    </xsl:if>
                                    <!--Multiple Telephone values possible-->
                                    <xsl:for-each
                                        select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Telephone">
                                        <Phone>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode"
                                                  select="Number/CountryCode"/>
                                                  <xsl:value-of select="Number/CountryDiallingCode"
                                                  />
                                                </CountryCode>
                                                <AreaOrCityCode>
                                                  <xsl:value-of select="Number/AreaID"/>
                                                </AreaOrCityCode>
                                                <Number>
                                                  <xsl:value-of select="Number/SubscriberID"/>
                                                </Number>
                                                <Extension>
                                                  <xsl:value-of select="Number/ExtensionID"/>
                                                </Extension>
                                            </TelephoneNumber>
                                        </Phone>
                                    </xsl:for-each>
                                    <!--Fax comm details-->
                                    <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Facsimile)) > 0">
                                        <Fax>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode"
                                                  select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Facsimilie/Number/CountryCode"/>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Facsimile/Number/CountryDiallingCode"
                                                  />
                                                </CountryCode>
                                                <AreaOrCityCode>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Facsimile/Number/AreaID"
                                                  />
                                                </AreaOrCityCode>
                                                <Number>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Facsimile/Number/SubscriberID"
                                                  />
                                                </Number>
                                                <Extension>
                                                  <xsl:value-of
                                                  select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Facsimile/Number/ExtensionID"
                                                  />
                                                </Extension>
                                            </TelephoneNumber>
                                        </Fax>
                                    </xsl:if>
                                    <URL>
                                        <xsl:attribute name="name"
                                            select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Web/URI/URIDescription"/>
                                        <xsl:value-of
                                            select="QualityInspectionRequestHeader/CompanyContactInfo/Address/Communication/Web/URI"
                                        />
                                    </URL>
                                </Contact>
                                </xsl:if>
                                <!--Inspection Period start and end date-->
                                <!--Needs to be fed in AN format. Calling template ANDateTime-->
                                <Period>
                                    <xsl:attribute name="startDate">
                                        <xsl:variable name="v_StartDate"
                                            select="substring(QualityInspectionRequestHeader/PeriodStartDate, 1, 8)"/>
                                        <xsl:variable name="v_StartTime">
                                            <xsl:choose>
                                                <xsl:when test="string-length(substring(QualityInspectionRequestHeader/PeriodStartDate, 10, 6)) > 0">
                                                    <xsl:value-of select="substring(QualityInspectionRequestHeader/PeriodStartDate, 10, 6)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'000000'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:call-template name="ANDateTime">
                                            <xsl:with-param name="p_date" select="$v_StartDate"/>
                                            <xsl:with-param name="p_time" select="$v_StartTime"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="endDate">
                                        <xsl:variable name="v_EndDate"
                                            select="substring(QualityInspectionRequestHeader/PeriodEndDate, 1, 8)"/>
                                        <xsl:variable name="v_EndTime">
                                            <xsl:choose>
                                                <xsl:when test="string-length(substring(QualityInspectionRequestHeader/PeriodEndDate, 10, 6)) > 0">
                                                    <xsl:value-of select="substring(QualityInspectionRequestHeader/PeriodEndDate, 10, 6)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'000000'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>                                   
                                        </xsl:variable>
                                        <xsl:call-template name="ANDateTime">
                                            <xsl:with-param name="p_date" select="$v_EndDate"/>
                                            <xsl:with-param name="p_time" select="$v_EndTime"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </Period>
                                <!--Reference Document details-->
                                <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/PurchaseOrderNumber)) > 0">
                                <ReferenceDocumentInfo>
                                    <xsl:attribute name="lineNumber"
                                        select="QualityInspectionRequestHeader/PurchaseOrderLineNo"/>
                                        <DocumentInfo>
                                            <xsl:attribute name="documentID"
                                                select="QualityInspectionRequestHeader/PurchaseOrderNumber"/>
                                            <!--Purchase order date also needs to be converted to AN format-->
                                            <xsl:attribute name="documentDate">
                                                <xsl:variable name="v_PurOrdDate"
                                                  select="substring(QualityInspectionRequestHeader/PurchaseOrderDate, 1, 8)"/>
                                                <xsl:variable name="v_PurOrdTime">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(substring(QualityInspectionRequestHeader/PurchaseOrderDate, 10, 6)) > 0">
                                                            <xsl:value-of select="substring(QualityInspectionRequestHeader/PurchaseOrderDate, 10, 6)"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <!-- IG-15089 time stamp adjusted as per change in OrderRequest XSLT to get hyper link for PO in QI in AN -->                                                            
                                                            <xsl:value-of select="'120000'"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>                                                  
                                                <xsl:call-template name="ANDateTime">
                                                  <xsl:with-param name="p_date" select="$v_PurOrdDate"/>
                                                  <xsl:with-param name="p_time" select="$v_PurOrdTime"/>
                                                  <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:attribute name="documentType"
                                                select="'PurchaseOrder'"/>
                                        </DocumentInfo>                                    
                                </ReferenceDocumentInfo>
                                </xsl:if>
                                <ItemInfo>
                                    <xsl:attribute name="quantity"
                                        select="QualityInspectionRequestHeader/InspectionLotSize"/>
                                    <ItemID>
                                        <SupplierPartID>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorMaterialNumber"
                                            />
                                        </SupplierPartID>
                                        <BuyerPartID>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/MaterialNumber"
                                            />
                                        </BuyerPartID>
                                        <IdReference>
                                            <xsl:attribute name="domain" select="'buyerLocationID'"/>
                                            <xsl:attribute name="identifier"
                                                select="QualityInspectionRequestHeader/Plant"/>
                                            <Description>
                                                <xsl:attribute name="xml:lang"
                                                  select="$v_DefaultLang"/>
                                                <xsl:value-of
                                                  select="QualityInspectionRequestHeader/PlantName"
                                                />
                                            </Description>
                                        </IdReference>
                                    </ItemID>
                                    <Description>
                                        <xsl:attribute name="xml:lang"
                                            select="$v_DefaultLang"/>
                                        <xsl:value-of
                                            select="QualityInspectionRequestHeader/MaterialDescription"
                                        />
                                    </Description>
                                    <UnitOfMeasure>
                                        <!--Unit Code has to be converted to AN format using template UOMTemplate_OUT instead of direct mapping-->
                                        <xsl:call-template name="UOMTemplate_Out">
                                            <xsl:with-param name="p_UOMinput"
                                                select="QualityInspectionRequestHeader/InspectionLotSize/unitCode"/>
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anSupplierANID"/>
                                        </xsl:call-template>
                                    </UnitOfMeasure>
                                </ItemInfo>
                                <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/BatchId)) > 0">
                                    <Batch>
                                        <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/BatchExpirationDate)) > 0 and QualityInspectionRequestHeader/BatchExpirationDate != '00000000'">
                                        <xsl:attribute name="expirationDate">
                                            <xsl:variable name="v_expDate" select="substring(QualityInspectionRequestHeader/BatchExpirationDate,1,8)"/>
                                            <xsl:variable name="v_expTime">
                                                <xsl:choose>
                                                    <xsl:when test="string-length(substring(QualityInspectionRequestHeader/BatchExpirationDate,10,6)) > 0">
                                                        <xsl:value-of select="substring(QualityInspectionRequestHeader/BatchExpirationDate,10,6)"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="'000000'"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date" select="$v_expDate"/>
                                                <xsl:with-param name="p_time" select="$v_expTime"/>
                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                            </xsl:call-template>                                            
                                        </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="QualityInspectionRequestHeader/BatchOriginCountry">
                                        <xsl:attribute name="originCountryCode"
                                            select="QualityInspectionRequestHeader/BatchOriginCountry"/>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/BatchProductionDate)) > 0 and QualityInspectionRequestHeader/BatchProductionDate != '00000000'">
                                        <xsl:attribute name="productionDate">
                                            <xsl:variable name="v_PrdDate" select="substring(QualityInspectionRequestHeader/BatchProductionDate,1,8)"/>
                                            <xsl:variable name="v_PrdTime">
                                                <xsl:choose>
                                                    <xsl:when test="string-length(substring(QualityInspectionRequestHeader/BatchProductionDate,10,6)) > 0">
                                                        <xsl:value-of select="substring(QualityInspectionRequestHeader/BatchProductionDate,10,6)"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="'000000'"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date" select="$v_PrdDate"/>
                                                <xsl:with-param name="p_time" select="$v_PrdTime"/>
                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/BatchInspectionDate)) > 0 and QualityInspectionRequestHeader/BatchInspectionDate != '00000000'">
                                        <xsl:attribute name="inspectionDate">
                                            <xsl:variable name="v_BIDate" select="substring(QualityInspectionRequestHeader/BatchInspectionDate,1,8)"/>
                                            <xsl:variable name="v_BITime">
                                                <xsl:choose>
                                                    <xsl:when test="string-length(substring(QualityInspectionRequestHeader/BatchInspectionDate,10,6)) > 0">
                                                        <xsl:value-of select="substring(QualityInspectionRequestHeader/BatchInspectionDate,10,6)"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="'000000'"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date" select="$v_BIDate"/>
                                                <xsl:with-param name="p_time" select="$v_BITime"/>
                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:attribute>  
                                        </xsl:if>
                                        <BuyerBatchID>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/BatchId"/>
                                        </BuyerBatchID>
                                        <xsl:if test="QualityInspectionRequestHeader/VendorBatchId">
                                        <SupplierBatchID>
                                            <xsl:value-of
                                                select="QualityInspectionRequestHeader/VendorBatchId"
                                            />
                                        </SupplierBatchID>
                                        </xsl:if>
                                        <!--Map Batch Characteristics-->
                                        <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/BatchCharacteristics[1])) > 0 and                                             
                                            string-length(normalize-space(QualityInspectionRequestHeader/BatchCharacteristics[1]/CharName)) > 0 and                                            
                                            string-length(normalize-space(QualityInspectionRequestHeader/BatchCharacteristics[1]/CharValueDescription)) > 0 ">
                                            <PropertyValuation>
                                                <PropertyReference>
                                                    <xsl:for-each select="QualityInspectionRequestHeader/BatchCharacteristics">
                                                        <IdReference>
                                                            <xsl:attribute name="identifier">
                                                                <xsl:value-of select="CharName"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="domain">
                                                                <xsl:value-of select="CharValueDescription"/>
                                                            </xsl:attribute>
                                                        </IdReference>
                                                    </xsl:for-each>
                                                </PropertyReference>
                                            </PropertyValuation>                                            
                                        </xsl:if>  
                                    </Batch>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/QMControlKeyCode)) > 0 
                                    or string-length(normalize-space(QualityInspectionRequestHeader/QMCertificateTypeCode)) > 0">
                                    <QualityInfo>
                                        <!--Set requiresQualityProcess flag-->
                                        <xsl:attribute name="requiresQualityProcess" select="'yes'"/>
                                        <!--Quality Info details-->
                                        <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/QMControlKeyCode)) > 0 
                                            and not(exists(QualityInspectionRequestHeader/QMCertificateFlag))">
                                        <IdReference>
                                            <!--Pass QMControlKey value-->
                                            <xsl:attribute name="identifier"
                                                select="QualityInspectionRequestHeader/QMControlKeyCode"/>
                                            <xsl:attribute name="domain" select="'controlCode'"/>
                                            <Description>
                                                <xsl:attribute name="xml:lang"
                                                    select="$v_DefaultLang"/>
                                                    <!--Pass description-->
                                                    <xsl:value-of
                                                        select="QualityInspectionRequestHeader/QMControlKey"
                                                    />                                                
                                            </Description>
                                        </IdReference>
                                        </xsl:if>                                                                                                           
                                        <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/QMCertificateTypeCode)) > 0">
                                            <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/QMCertificateFlag)) > 0">
                                                <CertificateInfo isRequired="yes">
                                                    <IdReference>
                                                        <!--Pass QMCertificateTypeCode value-->
                                                        <xsl:attribute name="identifier"
                                                            select="QualityInspectionRequestHeader/QMCertificateTypeCode"/>
                                                        <xsl:attribute name="domain" select="'certificateType'"/>
                                                        <Description>
                                                            <!--Pass description along with Lang ISO Code-->
                                                            <xsl:attribute name="xml:lang"
                                                                select="$v_DefaultLang"/>                                              
                                                            <xsl:value-of
                                                                select="QualityInspectionRequestHeader/QMCertificateType"
                                                            />                                                
                                                        </Description>
                                                    </IdReference>
                                                </CertificateInfo>
                                            </xsl:if>
                                        </xsl:if>
                                            <xsl:if test="not(exists(QualityInspectionRequestHeader/QMCertificateFlag)) and (exists(QualityInspectionRequestHeader/QMCertificateTypeCode))">
                                                <IdReference>
                                                    <xsl:attribute name="identifier" select="QualityInspectionRequestHeader/QMCertificateTypeCode"/>
                                                    <xsl:attribute name="domain" select="'certificateType'"/>
                                                    <Description>
                                                        <!--Pass description along with Lang ISO Code-->
                                                        <xsl:attribute name="xml:lang"
                                                            select="$v_DefaultLang"/>                                              
                                                        <xsl:value-of
                                                            select="QualityInspectionRequestHeader/QMCertificateType"
                                                        />                                                
                                                    </Description>                                                
                                                </IdReference>
                                        </xsl:if>
                                    </QualityInfo>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="exists(AribaComment/Item[not(ItemNumber)] | Attachments/Item)">
                                        <Comments>
                                            <xsl:call-template name="CommentsFillProxyOut">
                                                <xsl:with-param name="p_aribaComment"
                                                    select="AribaComment"/>
                                                <xsl:with-param name="p_doctype"
                                                    select="$anTargetDocumentType"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                            </xsl:call-template>
                                            <xsl:call-template name="addContenId">
                                                <xsl:with-param name="eachAtt" select="Attachments/Item"
                                                />
                                            </xsl:call-template>
                                        </Comments>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="string-length(normalize-space(QualityInspectionRequestHeader/ShortText)) > 0">
                                            <Comments>
                                                <xsl:attribute name="xml:lang">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space(QualityInspectionRequestHeader/ShortText/@languageCode)) > 0">
                                                            <xsl:value-of select="QualityInspectionRequestHeader/ShortText/@languageCode"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$v_DefaultLang"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:value-of select="QualityInspectionRequestHeader/ShortText"/>
                                            </Comments>
                                        </xsl:if>                                  
                                    </xsl:otherwise>
                                </xsl:choose>
                            </QualityInspectionRequestHeader>
                            <QualityInspectionRequestDetail>
                                <xsl:for-each select="QualityInspectionRequestDetails">
                                    <QualityInspectionCharacteristic>
                                        <xsl:attribute name="characteristicID"
                                            select="InspectionCharacteristic"/>
                                        <xsl:attribute name="operationNumber"
                                            select="OperationNumber"/>
                                        <xsl:attribute name="workCenter" select="WorkCenter"/>
                                        <xsl:if test="string-length(normalize-space(SpecificationStatus)) > 0 and SpecificationStatus = 'locked'">
                                            <xsl:attribute name="isLocked" select="'yes'"/>
                                        </xsl:if>
                                        <xsl:attribute name="characteristicType">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="string-length(normalize-space(ObligatoryConfirmation)) > 0"
                                                    ><xsl:value-of select="'required'"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'optional'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:if test="CharacteristicType = '01'">
                                            <xsl:attribute name="isQuantitative" select="'yes'"/>
                                        </xsl:if>
                                        <xsl:attribute name="recordingType">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="exists(SingleResult) and string-length(normalize-space(SingleResult)) > 0"
                                                    >singleResult</xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'summarizedRecording'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:if test="string-length(normalize-space(InspectionPoint)) > 0 ">
                                        <xsl:attribute name="inspectionPoint" 
                                                    select="InspectionPoint"/>
                                        </xsl:if>
                                        <Description>
                                            <xsl:attribute name="xml:lang"
                                                select="$v_DefaultLang"/>
                                            <!-- IG-8726 Start -->
                                            <ShortName>
                                            <xsl:value-of select="InspectionCharDescription"/>
                                            </ShortName>
                                            <!-- IG-8726 End -->    
                                        </Description>                                        
                                        <IdReference>
                                            <xsl:attribute name="identifier"
                                                select="InspectionCharacteristic"/>
                                            <xsl:attribute name="domain"
                                                select="'buyerInspectionCode'"/>
                                            <Description>
                                                <xsl:attribute name="xml:lang"
                                                  select="$v_DefaultLang"/>
                                                <xsl:value-of select="InspectionCharDescription"/>
                                            </Description>
                                        </IdReference>
                                        <AllowedValues>
                                         <xsl:choose>
                                             <xsl:when test="CharacteristicType = '01'">
                                                 <xsl:attribute name="type" select="'numeric'"/>
                                             </xsl:when>
                                             <xsl:when test="CharacteristicType = '02'">
                                             <xsl:attribute name="type" select="'choice'"/>
                                                 <PropertyValue>
                                                     <xsl:for-each select="CodeList">
                                                         <Characteristic>
                                                             <xsl:attribute name="domain" select="CodeGroup"/>
                                                             <xsl:attribute name="value" select="CodeText"/>
                                                             <xsl:attribute name="code" select="Code"/>
                                                         </Characteristic>
                                                     </xsl:for-each>
                                                 </PropertyValue>                                            
                                             </xsl:when>
                                             <xsl:when test="CharacteristicType = '03'">
                                                 <xsl:attribute name="type" select="'decision'"/>
                                             </xsl:when>
                                         </xsl:choose>   
                                        </AllowedValues>
                                        <!-- IG-8573 Start -->
                                        <xsl:choose>
                                            <xsl:when test="CharacteristicType = '01'">
                                                <ExpectedResult>
                                                    <xsl:attribute name="targetValue"
                                                        select="TargetValues"/>
                                                    <xsl:if test="string-length(normalize-space(LowerTotalLimit)) > 0">
                                                        <MinimumLimit>
                                                            <ComparatorInfo>
                                                                <xsl:attribute name="comparatorType"
                                                                    select="'greaterOrEqual'"/>
                                                                <xsl:attribute name="comparatorValue"
                                                                    select="LowerTotalLimit"/>
                                                            </ComparatorInfo>
                                                        </MinimumLimit>
                                                    </xsl:if>
                                                    <xsl:if test="string-length(normalize-space(UpperTotalLimit)) > 0">
                                                        <MaximumLimit>
                                                            <ComparatorInfo>
                                                                <xsl:attribute name="comparatorType"
                                                                    select="'lessOrEqual'"/>
                                                                <xsl:attribute name="comparatorValue"
                                                                    select="UpperTotalLimit"/>
                                                            </ComparatorInfo>
                                                        </MaximumLimit>
                                                    </xsl:if>
                                                </ExpectedResult>
                                            </xsl:when>
                                            <xsl:when test="CharacteristicType = '02'">
                                                <ExpectedResult>
                                                    <PropertyValue>
                                                        <xsl:for-each select="CodeList">
                                                            <xsl:if test="CodeValuation = 'A'">
                                                                <Characteristic>
                                                                    <xsl:attribute name="domain" select="CodeGroup"/>
                                                                    <xsl:attribute name="value" select="CodeText"/>
                                                                    <xsl:attribute name="code" select="Code"/>
                                                                </Characteristic>
                                                            </xsl:if>    
                                                        </xsl:for-each>
                                                    </PropertyValue>
                                                </ExpectedResult>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <ExpectedResult>
                                                    <PropertyValue>
                                                        <Characteristic domain="" value="Accept" code="YES"/>
                                                    </PropertyValue>
                                                </ExpectedResult>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- IG-8573 End -->
                                        <SampleDefinition>
                                            <xsl:attribute name="sampleSize" select="SampleSize"/>
                                            <xsl:attribute name="sampleType"
                                                select="'samplingProcedure'"/>
                                        </SampleDefinition>
                                        <xsl:if
                                            test="(AribaComment/Item/ItemNumber) | Attachments/Item">
                                            <Comments>
                                                <xsl:call-template name="CommentsFillProxyOut">
                                                  <xsl:with-param name="p_aribaComment"
                                                  select="AribaComment"/>
                                                  <xsl:with-param name="p_doctype"
                                                  select="$anTargetDocumentType"/>
                                                  <xsl:with-param name="p_pd" select="$v_pd"/>
                                                </xsl:call-template>
                                                <xsl:call-template name="addContenId">
                                                  <xsl:with-param name="eachAtt"
                                                  select="Attachments/Item"/>
                                                </xsl:call-template>
                                            </Comments>
                                        </xsl:if>
                                    </QualityInspectionCharacteristic>
                                </xsl:for-each>
                            </QualityInspectionRequestDetail>
                        </QualityInspectionRequest>
                    </Request>
                </cXML>
            </Payload>
<!-- IG-38084, Sending attachments to AN from ERP -->            
            <xsl:if test="Attachments/Item != ''">
                <xsl:call-template name="OutBoundAttach"/>
            </xsl:if>            
        </Combined>
    </xsl:template>
</xsl:stylesheet>
