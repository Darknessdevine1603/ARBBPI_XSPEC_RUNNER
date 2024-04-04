<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/" xmlns:n0="http://sap.com/xi/ARBCIS" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes" />
   <xsl:param name="anSupplierANID" />
   <xsl:param name="anProviderANID" />
   <xsl:param name="anTargetDocumentType" />
   <!-- Begin of IG-35839 XSLT code quality improvement -->
   <xsl:param name="anERPSystemID"/>
   <!-- End of IG-35839 XSLT code quality improvement -->
   <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
   <!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
   <xsl:variable name="v_remitTo" select="n0:InvoiceRequest/Invoice/BillFromParty/ContactPerson/Address" />
   <xsl:variable name="v_billTo" select="n0:InvoiceRequest/Invoice/BillToParty/ContactPerson/Address" />
   <xsl:variable name="v_item" select="n0:InvoiceRequest/Invoice/Item" />
   <xsl:variable name="v_supplierANID">
      <xsl:value-of select="/n0:InvoiceRequest/MessageHeader/AribaNetworkID/SupplierAribaNetworkID" />
   </xsl:variable>
   <xsl:variable name="v_buyerANID">
      <xsl:value-of select="/n0:InvoiceRequest/MessageHeader/AribaNetworkID/BuyerAribaNetworkID" />
   </xsl:variable>
   <xsl:variable name="v_deploymentMode">
      <xsl:value-of select="/n0:InvoiceRequest/MessageHeader/TestDataIndicator" />
   </xsl:variable>
   <!-- Begin of IG-35839 XSLT code quality improvement -->
   <xsl:variable name="v_pd">
      <xsl:call-template name="PrepareCrossref">
         <xsl:with-param name="p_doctype">
            <xsl:value-of select="$anTargetDocumentType"/>
         </xsl:with-param>
         <xsl:with-param name="p_erpsysid">
            <xsl:value-of select="$anERPSystemID"/>
         </xsl:with-param>
         <xsl:with-param name="p_ansupplierid">
            <xsl:value-of select="$anSupplierANID"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="v_defaultLang">
      <xsl:call-template name="FillDefaultLang">
         <xsl:with-param name="p_doctype">
            <xsl:value-of select="$anTargetDocumentType"/>
         </xsl:with-param>
         <xsl:with-param name="p_pd">
            <xsl:value-of select="$v_pd"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:variable>
   <!-- End of IG-35839 XSLT code quality improvement -->
   <xsl:template match="n0:InvoiceRequest">
      <Combined>
         <Payload>   
      <cXML>
         <xsl:attribute name="payloadID">
            <xsl:value-of select="MessageHeader/ID"/>
         </xsl:attribute> 
         <xsl:attribute name="timestamp">
            <xsl:value-of select="MessageHeader/CreationDateTime"/>
         </xsl:attribute> 
         <Header>
            <From>
               <Credential>
                  <xsl:attribute name="domain">
                     <xsl:value-of select="'NetworkID'"/>
                  </xsl:attribute>
                  <Identity>
                     <xsl:value-of select="$v_supplierANID" />
                  </Identity>
               </Credential>
            </From>
            <To>
               <Credential>
                  <xsl:attribute name="domain">
                     <xsl:value-of select="'NetworkID'"/>
                  </xsl:attribute>
                  <Identity>
                     <xsl:value-of select="$v_buyerANID" />
                  </Identity>
               </Credential>
            </To>
            <Sender>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anProviderANID" />
                  </Identity>
               </Credential>
               <UserAgent>
                  <xsl:value-of select="'Ariba Supplier'"/>
               </UserAgent>
            </Sender>
         </Header>
         <Request>
            <xsl:attribute name="deploymentMode">
               <xsl:choose>
                  <xsl:when test="($v_deploymentMode = 'true')">
                     <xsl:value-of select="'test'"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="'production'"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <InvoiceDetailRequest>
               <InvoiceDetailRequestHeader>
                  <xsl:attribute name="invoiceID">
                     <xsl:value-of select="Invoice/ID"/>
                  </xsl:attribute> 
                  <xsl:attribute name="purpose">
                     <xsl:choose>
                        <xsl:when test="Invoice/TypeCode = 'STD'">
                           <xsl:value-of select="'standard'" />
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="'lineLevelCreditMemo'" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="operation">
                     <xsl:choose>
                        <xsl:when test="Invoice/CancellationInvoiceIndicator = 'true'">
                           <xsl:value-of select="'delete'" />
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="'new'" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="invoiceDate">
                     <xsl:call-template name="Convert_UTC_cXML_Supplier">
                        <xsl:with-param name="p_utcTime">
                           <xsl:value-of select="Invoice/DateTime"/>
                        </xsl:with-param> 
                     </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="invoiceOrigin">
                     <xsl:value-of select="'supplier'"/>
                  </xsl:attribute> 
                   <InvoiceDetailHeaderIndicator/>
                  <InvoiceDetailLineIndicator>
                     <xsl:if test="$v_item/Price/TaxAmount">
                        <xsl:attribute name="isTaxInLine">
                           <xsl:value-of select="'yes'"/>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:for-each select="$v_item/Price">
                        <xsl:if test="Charges[Name ='SpecialHandlingCharges']">
                           <xsl:attribute name="isSpecialHandlingInLine">
                              <xsl:value-of select="'yes'"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="Charges[Name ='ShipmentAmount']">
                           <xsl:attribute name="isShippingInLine">
                              <xsl:value-of select="'yes'"/>
                           </xsl:attribute>
                        </xsl:if>
                     </xsl:for-each>
                  </InvoiceDetailLineIndicator>
                  <!-- REMIT To Partner Details(Company Info) -->
                  <InvoicePartner>
                     <Contact>
                        <xsl:attribute name="role">
                           <xsl:value-of select="'remitTo'"/> 
                        </xsl:attribute>
                        <xsl:attribute name="addressID">
                           <xsl:value-of select="Invoice/BillFromParty/InternalID"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressIDDomain">
                           <xsl:value-of select="'billToID'"/> 
                        </xsl:attribute>
                        <Name>
                           <!-- Begin of IG-35839 XSLT code quality improvement -->
                           <!-- Pass default language if langauge code is blank -->
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(Invoice/BillFromParty/Address/OrganisationFormOfAddress/Name/@languageCode)) > 0">
                                    <xsl:value-of select="Invoice/BillFromParty/Address/OrganisationFormOfAddress/Name/@languageCode"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_defaultLang"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <!-- End of IG-35839 XSLT code quality improvement -->
                           <xsl:value-of select="Invoice/BillFromParty/Address/OrganisationFormOfAddress/Name" />
                        </Name>
                        <PostalAddress>
                           <xsl:attribute name="name">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_remitTo/OrganisationFormOfAddress/Name)) &gt; 0">
                                    <xsl:value-of select="$v_remitTo/OrganisationFormOfAddress/Name" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="'default'"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <Street>
                              <xsl:value-of select="$v_remitTo/PhysicalAddress/StreetName" />
                           </Street>
                           <City>
                              <xsl:value-of select="$v_remitTo/PhysicalAddress/CityName" />
                           </City>
                           <State>
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Make ISO code as blank and pass RegionCode if RegionName is blank -->
                              <xsl:attribute name="isoStateCode"/>
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_remitTo/PhysicalAddress/RegionName)) > 0">
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/RegionName"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/RegionCode"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!-- End of IG-35839 XSLT code quality improvement -->
                           </State>
                           <PostalCode>
                              <xsl:value-of select="$v_remitTo/PhysicalAddress/POBoxPostalCode" />
                           </PostalCode>
                           <Country>
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Make ISO code as blank and pass CountryCode if CountryName is blank -->
                              <xsl:attribute name="isoCountryCode"/>
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_remitTo/PhysicalAddress/CountryName)) > 0">
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryName"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryCode"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!-- End of IG-35839 XSLT code quality improvement -->
                           </Country>
                        </PostalAddress>
                        <Phone>
                           <TelephoneNumber>
                              <CountryCode>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Make ISO code as blank and pass CountryCode if CountryName is blank -->
                                 <xsl:attribute name="isoCountryCode"/>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_remitTo/Communication/Telephone/Number/CountryCode)) > 0">
                                       <xsl:value-of select="$v_remitTo/Communication/Telephone/Number/CountryCode"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryCode"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </CountryCode>
                              <AreaOrCityCode>
                                 <xsl:value-of select="''" />
                              </AreaOrCityCode>
                              <Number>
                                 <xsl:value-of select="$v_remitTo/Communication/Telephone/Number/SubscriberID" />
                              </Number>
                              <Extension>
                                 <xsl:value-of select="$v_remitTo/Communication/Telephone/Number/ExtensionID" />
                              </Extension>
                           </TelephoneNumber>
                        </Phone>
                        <Fax>
                           <TelephoneNumber>
                              <CountryCode>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Make ISO code as blank and pass physical address CountryCode if communication CountryCode is blank -->
                                 <xsl:attribute name="isoCountryCode"/>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_remitTo/Communication/Facsimile/Number/CountryCode)) > 0">
                                       <xsl:value-of select="$v_remitTo/Communication/Facsimile/Number/CountryCode"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryCode"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </CountryCode>
                              <AreaOrCityCode>
                                 <xsl:value-of select="''" />
                              </AreaOrCityCode>
                              <Number>
                                 <xsl:value-of select="$v_remitTo/Communication/Facsimile/Number/SubscriberID" />
                              </Number>
                              <Extension>
                                 <xsl:value-of select="$v_remitTo/Communication/Facsimile/Number/ExtensionID" />
                              </Extension>
                           </TelephoneNumber>
                        </Fax>
                     </Contact>
                     <!-- CI-1606-->
                     <xsl:if test="string-length(normalize-space(Invoice/BillFromParty/VatID))>0">
                        <IdReference>
                           <xsl:attribute name="domain">                         
                              <xsl:value-of select="'vatID'"/>
                           </xsl:attribute>
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="Invoice/BillFromParty/VatID"/>
                           </xsl:attribute>
                        </IdReference>
                     </xsl:if>
                     <!-- CI-1606-->
                  </InvoicePartner>
                  <!-- REMIT From Partner Details -->
                  <InvoicePartner>
                     <Contact>
                        <xsl:attribute name="role">
                           <xsl:value-of select="'from'"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressID">
                           <xsl:value-of select="Invoice/BillFromParty/InternalID"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressIDDomain">
                           <xsl:value-of select="'billToID'"/>
                        </xsl:attribute> 
                        <Name>
                           <!-- Begin of IG-35839 XSLT code quality improvement -->
                           <!-- Pass default language if langauge code is blank -->
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(Invoice/BillFromParty/Address/OrganisationFormOfAddress/Name/@languageCode)) > 0">
                                    <xsl:value-of select="Invoice/BillFromParty/Address/OrganisationFormOfAddress/Name/@languageCode"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_defaultLang"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <!-- End of IG-35839 XSLT code quality improvement -->
                           <xsl:value-of select="Invoice/BillFromParty/Address/OrganisationFormOfAddress/Name" />
                        </Name>
                        <PostalAddress>
                           <xsl:attribute name="name">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_remitTo/OrganisationFormOfAddress/Name)) &gt; 0">
                                    <xsl:value-of select="$v_remitTo/OrganisationFormOfAddress/Name" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="'default'"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <Street>
                              <xsl:value-of select="$v_remitTo/PhysicalAddress/StreetName" />
                           </Street>
                           <City>
                              <xsl:value-of select="$v_remitTo/PhysicalAddress/CityName" />
                           </City>
                           <State>
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Make ISO code as blank and pass RegionCode if RegionName is blank -->
                              <xsl:attribute name="isoStateCode"/>
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_remitTo/PhysicalAddress/RegionName)) > 0">
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/RegionName"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/RegionCode"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!-- End of IG-35839 XSLT code quality improvement -->
                           </State>
                           <PostalCode>
                              <xsl:value-of select="$v_remitTo/PhysicalAddress/POBoxPostalCode" />
                           </PostalCode>
                           <Country>
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Make ISO code as blank and pass CountryCode if CountryName is blank -->
                              <xsl:attribute name="isoCountryCode"/>
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_remitTo/PhysicalAddress/CountryName)) > 0">
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryName"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryCode"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!-- End of IG-35839 XSLT code quality improvement -->
                           </Country>
                        </PostalAddress>
                        <Phone>
                           <TelephoneNumber>
                              <CountryCode>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Make ISO code as blank and pass physical address CountryCode if communication CountryCode is blank -->
                                 <xsl:attribute name="isoCountryCode"/>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_remitTo/Communication/Telephone/Number/CountryCode)) > 0">
                                       <xsl:value-of select="$v_remitTo/Communication/Telephone/Number/CountryCode"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryCode"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </CountryCode>
                              <AreaOrCityCode>
                                 <xsl:value-of select="''" />
                              </AreaOrCityCode>
                              <Number>
                                 <xsl:value-of select="$v_remitTo/Communication/Telephone/Number/SubscriberID" />
                              </Number>
                              <Extension>
                                 <xsl:value-of select="$v_remitTo/Communication/Telephone/Number/ExtensionID" />
                              </Extension>
                           </TelephoneNumber>
                        </Phone>
                        <Fax>
                           <TelephoneNumber>
                              <CountryCode>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Make ISO code as blank and pass physical address CountryCode if communication CountryCode is blank -->
                                 <xsl:attribute name="isoCountryCode"/>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_remitTo/Communication/Facsimile/Number/CountryCode)) > 0">
                                       <xsl:value-of select="$v_remitTo/Communication/Facsimile/Number/CountryCode"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_remitTo/PhysicalAddress/CountryCode"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </CountryCode>
                              <AreaOrCityCode>
                                 <xsl:value-of select="''" />
                              </AreaOrCityCode>
                              <Number>
                                 <xsl:value-of select="$v_remitTo/Communication/Facsimile/Number/SubscriberID" />
                              </Number>
                              <Extension>
                                 <xsl:value-of select="$v_remitTo/Communication/Facsimile/Number/ExtensionID" />
                              </Extension>
                           </TelephoneNumber>
                        </Fax>
                     </Contact>
                     <!-- CI-1606-->
                     <xsl:if test="string-length(normalize-space(Invoice/BillFromParty/VatID))>0">
                        <IdReference>
                           <xsl:attribute name="domain">
                              <xsl:value-of select="'vatID'"/>
                           </xsl:attribute>
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="Invoice/BillFromParty/VatID"/>
                           </xsl:attribute>
                        </IdReference> 
                     </xsl:if>
                     <!-- CI-1606-->  
                  </InvoicePartner>
                  <!-- BILL To Partner Details -->
                  <InvoicePartner>
                     <Contact>
                        <xsl:attribute name="role">
                           <xsl:value-of select="'billTo'"/>
                        </xsl:attribute> 
                        <xsl:attribute name="addressID">
                           <xsl:value-of select="Invoice/BillToParty/InternalID"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressIDDomain">
                           <xsl:value-of select="'billToID'"/>
                        </xsl:attribute> 
                        <Name>
                           <!-- Begin of IG-35839 XSLT code quality improvement -->
                           <!-- Pass default language if langauge code is blank -->
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(Invoice/BillToParty/Address/OrganisationFormOfAddress/Name/@languageCode)) > 0">
                                    <xsl:value-of select="Invoice/BillToParty/Address/OrganisationFormOfAddress/Name/@languageCode"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_defaultLang"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <!-- End of IG-35839 XSLT code quality improvement -->
                           <xsl:value-of select="Invoice/BillToParty/Address/OrganisationFormOfAddress/Name" />
                        </Name>
                        <PostalAddress>
                           <xsl:attribute name="name">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_billTo/OrganisationFormOfAddress/Name)) &gt; 0">
                                    <xsl:value-of select="$v_billTo/OrganisationFormOfAddress/Name" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="'default'"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <Street>
                              <xsl:value-of select="$v_billTo/PhysicalAddress/StreetName" />
                           </Street>
                           <City>
                              <xsl:value-of select="$v_billTo/PhysicalAddress/CityName" />
                           </City>
                           <State>
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Make ISO code as blank and pass RegionCode if RegionName is blank -->
                              <xsl:attribute name="isoStateCode"/>
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_billTo/PhysicalAddress/RegionName)) > 0">
                                    <xsl:value-of select="$v_billTo/PhysicalAddress/RegionName"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_billTo/PhysicalAddress/RegionCode"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!-- End of IG-35839 XSLT code quality improvement -->
                           </State>
                           <PostalCode>
                              <xsl:value-of select="$v_billTo/PhysicalAddress/POBoxPostalCode" />
                           </PostalCode>
                           <Country>
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Make ISO code as blank and pass CountryCode if CountryName is blank -->
                              <xsl:attribute name="isoCountryCode"/>
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_billTo/PhysicalAddress/CountryName)) > 0">
                                    <xsl:value-of select="$v_billTo/PhysicalAddress/CountryName"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_billTo/PhysicalAddress/CountryCode"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!-- End of IG-35839 XSLT code quality improvement -->
                           </Country>
                        </PostalAddress>
                        <Email>
                           <xsl:value-of select="$v_billTo/Communication/Email/URI"/>
                        </Email>
                        <Phone>
                           <TelephoneNumber>
                              <CountryCode>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Make ISO code as blank and pass physical address CountryCode if communication CountryCode is blank -->
                                 <xsl:attribute name="isoCountryCode"/>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_billTo/Communication/Telephone/Number/CountryCode)) > 0">
                                       <xsl:value-of select="$v_billTo/Communication/Telephone/Number/CountryCode"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_billTo/PhysicalAddress/CountryCode"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </CountryCode>
                              <AreaOrCityCode>
                                 <xsl:value-of select="''" />
                              </AreaOrCityCode>
                              <Number>
                                 <xsl:value-of select="$v_billTo/Communication/Telephone/Number/SubscriberID" />
                              </Number>
                              <Extension>
                                 <xsl:value-of select="$v_billTo/Communication/Telephone/Number/ExtensionID" />
                              </Extension>
                           </TelephoneNumber>
                        </Phone>
                        <Fax>
                           <TelephoneNumber>
                              <CountryCode>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Make ISO code as blank and pass physical address CountryCode if communication CountryCode is blank -->
                                 <xsl:attribute name="isoCountryCode"/>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_billTo/Communication/Facsimile/Number/CountryCode)) > 0">
                                       <xsl:value-of select="$v_billTo/Communication/Facsimile/Number/CountryCode"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_billTo/PhysicalAddress/CountryCode"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </CountryCode>
                              <AreaOrCityCode>
                                 <xsl:value-of select="''" />
                              </AreaOrCityCode>
                              <Number>
                                 <xsl:value-of select="$v_billTo/Communication/Facsimile/Number/SubscriberID" />
                              </Number>
                              <Extension>
                                 <xsl:value-of select="$v_billTo/Communication/Facsimile/Number/ExtensionID" />
                              </Extension>
                           </TelephoneNumber>
                        </Fax>
                     </Contact>
                     <!-- CI-1606-->
                     <xsl:if test="string-length(normalize-space(Invoice/BillToParty/VatID))>0">
                        <IdReference>
                           <xsl:attribute name="domain">
                              <xsl:value-of select="'vatID'"/>
                           </xsl:attribute>
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="Invoice/BillToParty/VatID"/>
                           </xsl:attribute>
                        </IdReference> 
                     </xsl:if>
                     <!-- CI-1606-->  
                  </InvoicePartner>
                  <!-- CI-1606-->
                  <!-- Wire receving bank Details -->
                  <xsl:for-each select="Invoice/Bank">
                     <InvoicePartner>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'wireReceivingBank'"/>
                           </xsl:attribute> 
                           <!-- Name mapped as blank as not populated from ERP and it is mandatory-->
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Pass default language code -->
                                 <xsl:value-of select="$v_defaultLang"/>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </xsl:attribute>
                           </Name>
                        </Contact>
                        <xsl:if test="string-length(normalize-space(BankName))>0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'bankName'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="BankName"/>
                              </xsl:attribute>
                           </IdReference> 
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(IbanID))>0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'ibanID'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="IbanID"/>
                              </xsl:attribute>
                           </IdReference>
                        </xsl:if> 
                        <xsl:if test="string-length(normalize-space(AccountName))>0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'accountName'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="AccountName"/>
                              </xsl:attribute>
                           </IdReference> 
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(BankCountryCode))>0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'bankCountryCode'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="BankCountryCode"/>
                              </xsl:attribute>
                           </IdReference>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(BankRoutingID))>0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'bankRoutingID'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="BankRoutingID"/>
                              </xsl:attribute>
                           </IdReference>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(AccountID))>0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'accountID'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="AccountID"/>
                              </xsl:attribute>
                           </IdReference>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(BranchName))>0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'branchName'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="BranchName"/>
                              </xsl:attribute>
                           </IdReference>
                        </xsl:if>              
                     </InvoicePartner>
                  </xsl:for-each>
                  <!-- CI-1606-->
                  <!-- Document Reference only when it is an cancel invoice -->
                  <xsl:if test="exists(Invoice/DocumentReference/PayloadID)">
                     <DocumentReference>
                        <xsl:attribute name="payloadID">
                           <xsl:value-of select="Invoice/DocumentReference/PayloadID"/>
                        </xsl:attribute>
                     </DocumentReference>
                  </xsl:if>
                  <!-- Payment Terms -->
                  <xsl:if test="exists(Invoice/CashDiscountTerms/MaximumCashDiscount/DaysValue)" >
                  <PaymentTerm>
                     <xsl:attribute name="payInNumberOfDays">
                        <xsl:value-of select="Invoice/CashDiscountTerms/MaximumCashDiscount/DaysValue"/>
                     </xsl:attribute>
                     <Discount>
                        <DiscountPercent>
                           <xsl:attribute name="percent">
                              <xsl:value-of select="Invoice/CashDiscountTerms/MaximumCashDiscount/Percent"/>
                           </xsl:attribute>
                        </DiscountPercent>
                     </Discount>
                  </PaymentTerm>
                  </xsl:if>
                  <xsl:if test="exists(Invoice/CashDiscountTerms/NormalCashDiscount/DaysValue)" >
                  <PaymentTerm>
                     <xsl:attribute name="payInNumberOfDays">
                        <xsl:value-of select="Invoice/CashDiscountTerms/NormalCashDiscount/DaysValue"/>
                     </xsl:attribute>
                     <Discount>
                        <DiscountPercent>
                           <xsl:attribute name="percent">
                              <xsl:value-of select="Invoice/CashDiscountTerms/NormalCashDiscount/Percent"/>
                           </xsl:attribute>
                        </DiscountPercent>
                     </Discount>
                  </PaymentTerm>
                  </xsl:if>
                  <xsl:if test="exists(Invoice/CashDiscountTerms/FullPaymentDueDaysValue)" >
                  <PaymentTerm>
                     <xsl:attribute name="payInNumberOfDays">
                        <xsl:value-of select="Invoice/CashDiscountTerms/FullPaymentDueDaysValue"/>
                     </xsl:attribute>
                  </PaymentTerm>
                  </xsl:if>
                  <!-- Header Comments-->
                  <xsl:for-each select="Invoice/Comments">
                     <xsl:for-each select="Comment">
                        <Comments>
                           <xsl:attribute name="xml:lang">
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Pass default language if langauge code is blank -->
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(@languageCode)) > 0">
                                    <xsl:value-of select="@languageCode"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_defaultLang"/>
                                 </xsl:otherwise>
                              </xsl:choose>                              
                              <!-- End of IG-35839 XSLT code quality improvement -->
                           </xsl:attribute>
                           <xsl:if test="string-length(normalize-space(../cXMLElementType)) > 0">
                              <xsl:attribute name="type">
                                 <xsl:value-of select="../cXMLElementType"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="."/>
                        </Comments>
                     </xsl:for-each>
                  </xsl:for-each>
                  <!-- Extrinsic -->
                  <Extrinsic>
                     <xsl:attribute name="name">
                        <xsl:value-of select="'invoiceSourceDocument'"/>
                     </xsl:attribute> 
                     <xsl:choose>
                        <xsl:when test="exists($v_item[1]/PurchaseOrderReference/ID)">
                           <xsl:value-of select="'PurchaseOrder'" />
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="'NoOrderInformation'" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </Extrinsic>
                  <Extrinsic>
                     <xsl:attribute name="name">
                        <xsl:value-of select="'invoiceSubmissionMethod'"/>
                     </xsl:attribute> 
                     <xsl:value-of select="'cXML'" />
                  </Extrinsic>
                  <!-- CI-1606-->
                  <xsl:if test="string-length(normalize-space(Invoice/BillToParty/VatID))>0">
                     <Extrinsic>
                        <xsl:attribute name="name">
                           <xsl:value-of select="'buyerVatID'"/>
                        </xsl:attribute>
                        <xsl:value-of select="Invoice/BillToParty/VatID"/>
                     </Extrinsic> 
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space(Invoice/BillFromParty/VatID))>0">
                     <Extrinsic>
                        <xsl:attribute name="name">
                           <xsl:value-of select="'supplierVatID'"/>
                        </xsl:attribute>
                        <xsl:value-of select="Invoice/BillFromParty/VatID"/>
                     </Extrinsic> 
                  </xsl:if>
                  <!-- CI-1606-->  
               </InvoiceDetailRequestHeader>
               <!-- Invoice Detail Order : Purchase order -->
               <xsl:for-each-group select="$v_item" group-by="PurchaseOrderReference/ID">
                  <InvoiceDetailOrder>
                     <InvoiceDetailOrderInfo>
                        <OrderIDInfo>
                           <xsl:attribute name="orderID">
                              <xsl:value-of select="PurchaseOrderReference/ID"/>
                           </xsl:attribute> 
                        </OrderIDInfo>
                     </InvoiceDetailOrderInfo>
                     <xsl:for-each select="current-group()">
                        <InvoiceDetailItem>
                           <xsl:attribute name="invoiceLineNumber">
                              <xsl:value-of select="ID"/>
                           </xsl:attribute>
                           <xsl:attribute name="quantity">
                              <xsl:value-of select="Quantity"/>
                           </xsl:attribute>
                           <UnitOfMeasure>
                              <xsl:value-of select="Quantity/@unitCode" />
                           </UnitOfMeasure>
                           <UnitPrice>
                              <Money>
                                 <xsl:attribute name="currency">
                                    <xsl:value-of select="Price/UnitPrice/Amount/@currencyCode"/>
                                 </xsl:attribute>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str">
                                       <xsl:value-of select="Price/UnitPrice/Amount"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </Money>
                           </UnitPrice>
                           <xsl:if test="exists(Price/UnitPrice/BaseQuantity)" >
                           <PriceBasisQuantity>
                              <xsl:attribute name="conversionFactor">
                                 <xsl:value-of select="Price/UnitPrice/BaseQuantity"/>
                              </xsl:attribute>
                               <xsl:attribute name="quantity">
                                  <xsl:value-of select="'1'"/>
                               </xsl:attribute> 
                              <UnitOfMeasure>
                                 <xsl:value-of select="Price/UnitPrice/BaseQuantity/@unitCode" />
                              </UnitOfMeasure>
                           </PriceBasisQuantity>
                           </xsl:if>
                           <InvoiceDetailItemReference>
                              <xsl:attribute name="lineNumber">
                                 <xsl:value-of select="PurchaseOrderReference/ItemID"/>
                              </xsl:attribute>
                              <ItemID>
                                 <SupplierPartID>
                                    <xsl:value-of select="Product/SellerID" />
                                 </SupplierPartID>
                                 <!--  IG-30866-Mapping BuyerPartID in SD Invoice -->
                                 <xsl:if test="string-length(normalize-space(Product/BuyerID))>0" >
                                    <BuyerPartID>
                                       <xsl:value-of select="Product/BuyerID" />
                                    </BuyerPartID>
                                 </xsl:if>
                                 <!--  IG-30866-Mapping BuyerPartID in SD Invoice  -->
                              </ItemID>
                              <Description>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <!-- Pass default language if langauge code is blank -->
                                 <xsl:attribute name="xml:lang">
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(Description/@languageCode)) > 0">
                                          <xsl:value-of select="Description/@languageCode"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                                 <xsl:value-of select="Description" />
                              </Description>
                           </InvoiceDetailItemReference>
                           <SubtotalAmount>
                              <Money>
                                 <xsl:attribute name="currency">
                                    <xsl:value-of select="Price/BaseAmount/@currencyCode"/>
                                 </xsl:attribute>
                                 <!-- IG-24393 -->
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str">
                                       <xsl:value-of select="Price/BaseAmount"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                                 <!-- IG-24393 -->
                              </Money>
                           </SubtotalAmount>
                            <!-- Line Level Tax -->
                           <xsl:if test="Price/TaxAmount">
                            <Tax>
                                <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="Price/TaxAmount/@currencyCode"/>
                                    </xsl:attribute>
                                    <!-- Begin of IG-35839 XSLT code quality improvement -->
                                    <xsl:call-template name="ParseNumber">
                                       <xsl:with-param name="p_str">
                                          <xsl:value-of select="Price/TaxAmount"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                    <!-- End of IG-35839 XSLT code quality improvement -->
                                </Money>
                                <Description>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="ProductTax[1]/TypeCode/@listAgencyID"/>
                                </Description>
                                <xsl:for-each select="ProductTax">
                                    <TaxDetail>
                                        <xsl:attribute name="category">
                                           <xsl:value-of select="TypeCode/@listID"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="percentageRate">
                                           <xsl:value-of select="Rate/DecimalValue"/>
                                        </xsl:attribute>
                                       <TaxableAmount>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="BaseAmount/@currencyCode"/>
                                             </xsl:attribute>
                                             <!-- Begin of IG-35839 XSLT code quality improvement -->
                                             <xsl:call-template name="ParseNumber">
                                                <xsl:with-param name="p_str">
                                                   <xsl:value-of select="BaseAmount"/>
                                                </xsl:with-param>
                                             </xsl:call-template>
                                             <!-- End of IG-35839 XSLT code quality improvement -->
                                          </Money>
                                       </TaxableAmount>
                                        <TaxAmount>
                                            <Money>
                                                <xsl:attribute name="currency">
                                                   <xsl:value-of select="Amount/@currencyCode"/>
                                                </xsl:attribute> 
                                               <!-- Begin of IG-35839 XSLT code quality improvement -->
                                               <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str">
                                                     <xsl:value-of select="Amount"/>
                                                  </xsl:with-param>
                                               </xsl:call-template>
                                               <!-- End of IG-35839 XSLT code quality improvement -->
                                            </Money>
                                        </TaxAmount>
                                        <Description>
                                            <!-- Begin of IG-35839 XSLT code quality improvement -->
                                            <!-- Pass default language if langauge code is blank -->
                                            <xsl:attribute name="xml:lang">
                                               <xsl:choose>
                                                  <xsl:when test="string-length(normalize-space(../Description/@languageCode)) > 0">
                                                     <xsl:value-of select="../Description/@languageCode"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                     <xsl:value-of select="$v_defaultLang"/>
                                                  </xsl:otherwise>
                                               </xsl:choose>
                                            </xsl:attribute>
                                            <!-- End of IG-35839 XSLT code quality improvement -->
                                            <xsl:value-of select="TypeCode/@listAgencyID" />
                                        </Description>
                                    </TaxDetail>
                                </xsl:for-each>
                            </Tax>
                           </xsl:if>
                           <!--SpecialHandlingAmount-->
                           <xsl:if
                              test="string-length(normalize-space(Price/Charges[Name ='SpecialHandlingCharges']/Amount)) &gt; 0">
                              <InvoiceDetailLineSpecialHandling>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of
                                          select="Price/Charges[Name ='SpecialHandlingCharges']/Amount/@currencyCode"
                                       />
                                    </xsl:attribute>
                                    <!-- Begin of IG-35839 XSLT code quality improvement -->
                                    <xsl:call-template name="ParseNumber">
                                       <xsl:with-param name="p_str">
                                          <xsl:value-of select="Price/Charges[Name ='SpecialHandlingCharges']/Amount"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                    <!-- End of IG-35839 XSLT code quality improvement -->
                                 </Money>
                              </InvoiceDetailLineSpecialHandling>   
                           </xsl:if>
                           <!--ShippingAmount-->
                           <xsl:if
                              test="string-length(normalize-space(Price/Charges[Name ='ShipmentAmount']/Amount)) &gt; 0">
                              <InvoiceDetailLineShipping>
                                 <InvoiceDetailShipping>
                                    <Contact>
                                       <xsl:attribute name="role">
                                          <xsl:value-of select="'shipFrom'"/>
                                       </xsl:attribute>                               
                                       <Name>   
                                          <!-- Begin of IG-35839 XSLT code quality improvement -->
                                          <!-- Pass default langauge code-->
                                          <xsl:attribute name="xml:lang">
                                             <xsl:value-of select="$v_defaultLang"/>
                                          </xsl:attribute>
                                          <!-- End of IG-35839 XSLT code quality improvement -->
                                       </Name>
                                    </Contact>
                                    <Contact>
                                       <xsl:attribute name="role">
                                          <xsl:value-of select="'shipTo'"/>
                                       </xsl:attribute>                               
                                       <Name> 
                                          <!-- Begin of IG-35839 XSLT code quality improvement -->
                                          <!-- Pass default langauge code-->
                                          <xsl:attribute name="xml:lang">
                                             <xsl:value-of select="$v_defaultLang"/>
                                          </xsl:attribute>
                                          <!-- End of IG-35839 XSLT code quality improvement -->
                                       </Name>
                                    </Contact>
                                 </InvoiceDetailShipping>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of
                                          select="Price/Charges[Name ='ShipmentAmount']/Amount/@currencyCode"
                                       />
                                    </xsl:attribute>
                                    <!-- Begin of IG-35839 XSLT code quality improvement -->
                                    <xsl:call-template name="ParseNumber">
                                       <xsl:with-param name="p_str">
                                          <xsl:value-of select="Price/Charges[Name ='ShipmentAmount']/Amount"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                    <!-- End of IG-35839 XSLT code quality improvement -->
                                 </Money>
                              </InvoiceDetailLineShipping>
                           </xsl:if>                    
                           <GrossAmount>
                              <Money>
                                 <xsl:attribute name="currency">
                                    <xsl:value-of select="Price/GrossAmount/@currencyCode"/>
                                 </xsl:attribute>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str">
                                       <xsl:value-of select="Price/GrossAmount"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </Money>
                           </GrossAmount>
                           <NetAmount>
                              <Money>
                                 <xsl:attribute name="currency">
                                    <xsl:value-of select="Price/NetAmount/@currencyCode"/>
                                 </xsl:attribute>
                                 <!-- IG-24393 -->
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str">
                                       <xsl:value-of select="Price/NetAmount"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                                 <!-- IG-24393 -->                                 
                              </Money>
                           </NetAmount>
                           <!-- Item Comment -->
                           <xsl:for-each select="Comments">
                              <xsl:for-each select="Comment">
                                 <Comments>
                                    <xsl:attribute name="xml:lang">
                                       <!-- Begin of IG-35839 XSLT code quality improvement -->
                                       <!-- Pass default language if langauge code is blank -->
                                       <xsl:choose>
                                          <xsl:when test="string-length(normalize-space(@languageCode)) > 0">
                                             <xsl:value-of select="@languageCode"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="$v_defaultLang"/>
                                          </xsl:otherwise>
                                       </xsl:choose>                              
                                       <!-- End of IG-35839 XSLT code quality improvement -->
                                    </xsl:attribute>
                                    <xsl:if test="string-length(normalize-space(../cXMLElementType)) > 0">
                                       <xsl:attribute name="type">
                                          <xsl:value-of select="../cXMLElementType"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="."/>
                                 </Comments>
                              </xsl:for-each>
                           </xsl:for-each>
                        </InvoiceDetailItem>
                     </xsl:for-each>
                  </InvoiceDetailOrder>
               </xsl:for-each-group>
               <!-- Invoice Detail Summary -->
               <InvoiceDetailSummary>
                  <SubtotalAmount>
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="Invoice/Price/BaseAmount/@currencyCode"/>
                        </xsl:attribute>
                        <!-- IG-24393 -->
                        <!-- Begin of IG-35839 XSLT code quality improvement -->
                        <xsl:call-template name="ParseNumber">
                           <xsl:with-param name="p_str">
                              <xsl:value-of select="Invoice/Price/BaseAmount"/>
                           </xsl:with-param>
                        </xsl:call-template>
                        <!-- End of IG-35839 XSLT code quality improvement -->
                        <!-- IG-24393 -->
                     </Money>
                  </SubtotalAmount>
                  <Tax>
                      <Money>
                          <xsl:attribute name="currency">
                             <xsl:value-of select="Invoice/Price/TaxAmount/@currencyCode"/>
                          </xsl:attribute>
                          <!-- Begin of IG-35839 XSLT code quality improvement -->
                          <xsl:call-template name="ParseNumber">
                             <xsl:with-param name="p_str">
                                <xsl:value-of select="Invoice/Price/TaxAmount"/>
                             </xsl:with-param>
                          </xsl:call-template>
                          <!-- End of IG-35839 XSLT code quality improvement -->
                      </Money>
                      <Description>
                          <xsl:attribute name="xml:lang">
                             <xsl:value-of select="$v_defaultLang"/>
                          </xsl:attribute>
                      </Description>
                     <xsl:for-each select="Invoice/ProductTax">
                        <TaxDetail>
                           <xsl:attribute name="category">
                              <xsl:value-of select="TypeCode/@listID"/>
                           </xsl:attribute>
                           <xsl:attribute name="percentageRate">
                              <xsl:value-of select="Rate/DecimalValue"/>
                           </xsl:attribute>
                           <TaxableAmount>
                              <Money>
                                 <xsl:attribute name="currency">
                                    <xsl:value-of select="BaseAmount/@currencyCode"/>
                                 </xsl:attribute>
                                 <!-- Begin of IG-35839 XSLT code quality improvement -->
                                 <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str">
                                       <xsl:value-of select="BaseAmount"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                                 <!-- End of IG-35839 XSLT code quality improvement -->
                              </Money>
                           </TaxableAmount>
                            <TaxAmount>
                                <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="Amount/@currencyCode"/>
                                    </xsl:attribute>
                                   <!-- Begin of IG-35839 XSLT code quality improvement -->
                                   <xsl:call-template name="ParseNumber">
                                      <xsl:with-param name="p_str">
                                         <xsl:value-of select="Amount"/>
                                      </xsl:with-param>
                                   </xsl:call-template>
                                   <!-- End of IG-35839 XSLT code quality improvement -->
                                </Money>
                            </TaxAmount>
                           <Description>
                              <!-- Begin of IG-35839 XSLT code quality improvement -->
                              <!-- Pass default language if langauge code is blank -->
                              <xsl:attribute name="xml:lang">
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(../Description/@languageCode)) > 0">
                                       <xsl:value-of select="../Description/@languageCode"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <!-- End of IG-35839 XSLT code quality improvement -->
                              <xsl:value-of select="TypeCode/@listAgencyID" />
                           </Description>
                        </TaxDetail>
                     </xsl:for-each>
                  </Tax>
                  <!--SpecialHandlingAmount-->
                  <xsl:if
                     test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Price/Charges[Name ='SpecialHandlingCharges']/Amount)) &gt; 0">
                     <SpecialHandlingAmount>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of
                                 select="/n0:InvoiceRequest/Invoice/Price/Charges[Name ='SpecialHandlingCharges']/Amount/@currencyCode"
                              />
                           </xsl:attribute> 
                           <!-- Begin of IG-35839 XSLT code quality improvement -->
                           <xsl:call-template name="ParseNumber">
                              <xsl:with-param name="p_str">
                                 <xsl:value-of select="/n0:InvoiceRequest/Invoice/Price/Charges[Name ='SpecialHandlingCharges']/Amount"/>
                              </xsl:with-param>
                           </xsl:call-template>
                           <!-- End of IG-35839 XSLT code quality improvement -->
                        </Money>
                     </SpecialHandlingAmount>   
                  </xsl:if>
                  <!--ShippingAmount-->
                  <xsl:if
                     test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Price/Charges[Name ='ShipmentAmount']/Amount)) &gt; 0">
                     <ShippingAmount>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of
                                 select="/n0:InvoiceRequest/Invoice/Price/Charges[Name ='ShipmentAmount']/Amount/@currencyCode"
                              />
                           </xsl:attribute>
                           <!-- Begin of IG-35839 XSLT code quality improvement -->
                           <xsl:call-template name="ParseNumber">
                              <xsl:with-param name="p_str">
                                 <xsl:value-of select="/n0:InvoiceRequest/Invoice/Price/Charges[Name ='ShipmentAmount']/Amount"/>
                              </xsl:with-param>
                           </xsl:call-template>
                           <!-- End of IG-35839 XSLT code quality improvement -->
                        </Money>
                     </ShippingAmount>
                  </xsl:if>         
                  <GrossAmount>
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="Invoice/Price/GrossAmount/@currencyCode"/>
                        </xsl:attribute>
                        <!-- Begin of IG-35839 XSLT code quality improvement -->
                        <xsl:call-template name="ParseNumber">
                           <xsl:with-param name="p_str">
                              <xsl:value-of select="Invoice/Price/GrossAmount"/>
                           </xsl:with-param>
                        </xsl:call-template>
                        <!-- End of IG-35839 XSLT code quality improvement -->
                     </Money>
                  </GrossAmount>
                  <NetAmount>
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="Invoice/Price/NetAmount/@currencyCode"/>
                        </xsl:attribute>
                        <!-- IG-24393 -->
                        <!-- Begin of IG-35839 XSLT code quality improvement -->
                        <xsl:call-template name="ParseNumber">
                           <xsl:with-param name="p_str">
                              <xsl:value-of select="Invoice/Price/NetAmount"/>
                           </xsl:with-param>
                        </xsl:call-template>
                        <!-- End of IG-35839 XSLT code quality improvement -->
                        <!-- IG-24393 -->
                     </Money>
                  </NetAmount>
               </InvoiceDetailSummary>
            </InvoiceDetailRequest>
         </Request>
      </cXML>
         </Payload>
      </Combined>
   </xsl:template>
   <!-- Begin of IG-35839 XSLT code quality improvement -->
   <!--User Define Templates for ParseNumber-->
   <xsl:template name="ParseNumber">
      <xsl:param name="p_str"/>
      <xsl:if test="string-length(normalize-space($p_str)) > 0">
         <xsl:value-of select="translate(translate(translate($p_str, ',', ''), 'USD', ''), '$', '')"/>
      </xsl:if>
   </xsl:template>
   <!-- End of IG-35839 XSLT code quality improvement -->   
</xsl:stylesheet>
