<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
   <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--   <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
   <xsl:param name="exchange"/>
   <xsl:param name="anIsMultiERP"/>
   <xsl:param name="anERPTimeZone"/>
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anERPSystemID"/>
   <xsl:param name="anTargetDocumentType"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anSharedSecrete"/>
   <xsl:param name="ancxmlversion"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="anContentID"/>
   <xsl:variable name="v_pd">
      <xsl:call-template name="PrepareCrossref">
         <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
         <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
         <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="v_defaultLang">
      <xsl:call-template name="FillDefaultLang">
         <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
         <xsl:with-param name="p_pd" select="$v_pd"/>
      </xsl:call-template>
   </xsl:variable>
   <!-- IG-41238 start -->
   <xsl:variable name="v_BuyingandInvoicingEnabled">
      <xsl:call-template name="BuyingandInvoicingEnabled">
         <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
         <xsl:with-param name="p_pd" select="$v_pd"/>
      </xsl:call-template>
   </xsl:variable>
   <!-- IG-41238 end -->
   <xsl:variable name="v_sesdate">
      <xsl:value-of select="replace(substring(n0:ERPServiceEntrySheetRequest/ServiceAcknowledgement/CreationDateTime,1,10),'-','')"/>
   </xsl:variable>
   <xsl:variable name="v_sestime">
      <xsl:value-of select="replace(substring(n0:ERPServiceEntrySheetRequest/ServiceAcknowledgement/CreationDateTime,12,8),':','')"/>
   </xsl:variable>
   <xsl:variable name="v_sesID">
      <xsl:value-of select="n0:ERPServiceEntrySheetRequest/ServiceAcknowledgement/AribaDocumentID"/>
   </xsl:variable>
   <xsl:variable name="v_vendorId">
      <xsl:value-of select="n0:ERPServiceEntrySheetRequest/ServiceAcknowledgement/VendorParty/InternalID"/>
   </xsl:variable>
   <xsl:variable name="v_sellerID">
      <xsl:value-of select="n0:ERPServiceEntrySheetRequest/ServiceAcknowledgement/SellerID"/>
   </xsl:variable>
   <xsl:variable name="v_curDate">
      <xsl:value-of select="current-dateTime()"/>
   </xsl:variable>
   <xsl:variable name="v_timestamp">
      <xsl:value-of select="concat(substring($v_curDate, 1, 19), substring($v_curDate, 24, 29))"/>
   </xsl:variable>  
   <xsl:variable name="cXMLEnvelopeHeader">
      <xsl:choose>
         <xsl:when test="upper-case($anIsMultiERP) = 'TRUE'">
            <xsl:value-of
               select="concat('&lt;cXML payloadID=&quot;', $anPayloadID, '&quot; timestamp=&quot;', $v_timestamp, '&quot; version=&quot;', $ancxmlversion, '&quot; xml:lang=&quot;en-US&quot;&gt; &lt;Header&gt;&lt;From&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anSupplierANID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;Credential domain=&quot;SystemID&quot;&gt;&lt;Identity&gt;', $anERPSystemID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/From&gt;&lt;To&gt;&lt;Credential domain=&quot;VendorID&quot;&gt;&lt;Identity&gt;', $v_vendorId, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/To&gt;&lt;Sender&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anProviderANID, '&lt;/Identity&gt;&lt;SharedSecret&gt;', $anSharedSecrete, '&lt;/SharedSecret&gt;&lt;/Credential&gt;&lt;UserAgent&gt;Ariba SN Buyer Adapter&lt;/UserAgent&gt;&lt;/Sender&gt;&lt;/Header&gt;')"
            />
         </xsl:when>
         <xsl:otherwise>
      <xsl:value-of
         select="concat('&lt;cXML payloadID=&quot;', $anPayloadID, '&quot; timestamp=&quot;', $v_timestamp, '&quot; version=&quot;', $ancxmlversion, '&quot; xml:lang=&quot;en-US&quot;&gt; &lt;Header&gt;&lt;From&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anSupplierANID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/From&gt;&lt;To&gt;&lt;Credential domain=&quot;VendorID&quot;&gt;&lt;Identity&gt;', $v_vendorId, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/To&gt;&lt;Sender&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anProviderANID, '&lt;/Identity&gt;&lt;SharedSecret&gt;', $anSharedSecrete, '&lt;/SharedSecret&gt;&lt;/Credential&gt;&lt;UserAgent&gt;Ariba SN Buyer Adapter&lt;/UserAgent&gt;&lt;/Sender&gt;&lt;/Header&gt;')"
      />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="cXMLEnvelopeRequest">
      <xsl:value-of
         select="concat('&lt;Request&gt; &lt;CopyRequest&gt; &lt;cXMLAttachment&gt; &lt;Attachment&gt;&lt;URL&gt;', 'cid:', $anContentID, '&lt;/URL&gt; &lt;/Attachment&gt; &lt;/cXMLAttachment&gt; &lt;/CopyRequest&gt; &lt;/Request&gt; &lt;/cXML&gt;')"
      />
   </xsl:variable>
   <xsl:variable name="cXMLEnvelope">
      <xsl:value-of select="concat($cXMLEnvelopeHeader, ' ', $cXMLEnvelopeRequest)"/>
   </xsl:variable>
   <xsl:template match="n0:ERPServiceEntrySheetRequest">
      <xsl:variable name="v_empty" select="''"/>
      <xsl:variable name="v_id1" select="'ID'"/>
      <Combined>
         <Payload>
            <cXML>
               <xsl:attribute name="payloadID">
                  <xsl:value-of select="concat($anPayloadID, $v_timestamp)"/>
               </xsl:attribute>
               <xsl:attribute name="timestamp">
                  <xsl:variable name="curDate">
                     <xsl:value-of select="current-dateTime()"/>
                  </xsl:variable>
                  <xsl:value-of
                     select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"/>
               </xsl:attribute>
               <Header>
                  <From>
                     <Credential domain="VendorID">
                        <Identity>
                           <xsl:value-of select="$v_vendorId"/>
                        </Identity>
                     </Credential>
                     <!--End Point Fix for CIG-->
                     <Credential>
                        <xsl:attribute name="domain">
                           <xsl:value-of select="'EndPointID'"/>
                        </xsl:attribute>
                        <Identity>CIG</Identity>
                     </Credential> 
                     <Correspondent>
                        <Contact role="correspondent">
                           <Name>
                           <xsl:call-template name="FillLangOut">
                              <xsl:with-param name="p_spras_iso"
                                 select="ServiceAcknowledgement/VendorParty/InternalID/@schemeID"/>
                              <xsl:with-param name="p_spras"
                                 select="ServiceAcknowledgement/VendorParty/InternalID/@schemeID"/>
                              <xsl:with-param name="p_lang"
                                 select="$v_defaultLang"/>
                           </xsl:call-template>
                           <xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PersonName/BirthName"/>
                           </Name>
                           <Email name="routing">
                              <xsl:value-of
                                 select="ServiceAcknowledgement/VendorParty/Address/Communication/Email/URI"
                              />
                           </Email>
                        </Contact>
                     </Correspondent>
                  </From>
                  <To>
                     <!-- Multi ERP check-->
                     <xsl:call-template name="MultiERPTemplateOut">
                        <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                     </xsl:call-template>
                     <Credential domain="NetworkID">
                        <Identity>
                           <xsl:value-of select="$anSupplierANID"/>
                        </Identity>
                     </Credential>
                  </To>
                  <Sender>
                     <Credential domain="NetworkID">
                        <Identity>
                           <xsl:value-of select="$anSupplierANID"/>
                        </Identity>
                     </Credential>
                     <UserAgent>
                        <xsl:value-of select="'Ariba Supplier'"/>
                     </UserAgent>
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
                  <ServiceEntryRequest>
                     <ServiceEntryRequestHeader>
                        <xsl:attribute name="serviceEntryDate">
                           <xsl:call-template name="ANDateTime">
                              <xsl:with-param name="p_date"
                                 select="$v_sesdate"/>
                              <xsl:with-param name="p_time"
                                 select="$v_sestime"/>
                              <xsl:with-param name="p_timezone"
                                 select="$anERPTimeZone"/>
                           </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="serviceEntryID">
                           <xsl:value-of select= "$v_sesID"/>
                        </xsl:attribute>
                        <xsl:attribute name="supplierReferenceNumber">
                           <xsl:value-of select="$v_sellerID"/>
                        </xsl:attribute>
                        <xsl:attribute name="operation">
                           <xsl:value-of select="'new'"/>
                        </xsl:attribute>
                        <PartnerContact>
                           <Contact role="requester">
                              <Name>
                                 <xsl:call-template name="FillLangOut">
                                    <xsl:with-param name="p_spras_iso"
                                       select="VendorParty/InternalID/@schemeID"/>
                                    <xsl:with-param name="p_spras"
                                       select="VendorParty/InternalID/@schemeID"/>
                                    <xsl:with-param name="p_lang"
                                       select="$v_defaultLang"/>
                                 </xsl:call-template>
                                 <xsl:value-of select="ServiceAcknowledgement/Requester"/>
                              </Name>
                           </Contact>
                        </PartnerContact>
                        <PartnerContact>
                           <Contact role="FieldEngineer">
                              <Name>
                                 <xsl:call-template name="FillLangOut">
                                 <xsl:with-param name="p_spras_iso"
                                    select="FieldEngineer/@schemeID"/>
                                 <xsl:with-param name="p_spras"
                                    select="FieldEngineer/@schemeID"/>
                                 <xsl:with-param name="p_lang"
                                    select="$v_defaultLang"/>
                                    </xsl:call-template>
                                 <xsl:value-of select="ServiceAcknowledgement/FieldEngineer"/>
                              </Name>
                           </Contact>
                        </PartnerContact>
                        <PartnerContact>
                           <Contact role="from">
                              <xsl:attribute name="addressID">
                                 <xsl:value-of select="ServiceAcknowledgement/VendorParty/InternalID"/>
                              </xsl:attribute>
                              <Name>
                                 <xsl:call-template name="FillLangOut">
                                    <xsl:with-param name="p_spras_iso"
                                       select="ServiceAcknowledgement/VendorParty/InternalID/@schemeID"/>
                                    <xsl:with-param name="p_spras"
                                       select="ServiceAcknowledgement/VendorParty/InternalID/@schemeID"/>
                                    <xsl:with-param name="p_lang"
                                       select="$v_defaultLang"/>
                                 </xsl:call-template>
                                 <xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PersonName/BirthName"/>
                              </Name>
                              <PostalAddress>
                                 <Street><xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PhysicalAddress/StreetName"/></Street>
                                 <City><xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PhysicalAddress/CityName"/></City>
                                 <State>
                                    <xsl:attribute name="isoStateCode"><xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PhysicalAddress/RegionCode"/></xsl:attribute>
                                    <xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PhysicalAddress/RegionName"/>
                                 </State>
                                 <PostalCode><xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PhysicalAddress/POBoxPostalCode"/></PostalCode>
                                 <Country><xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PhysicalAddress/CountryCode"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/PhysicalAddress/CountryName"/></Country>
                              </PostalAddress>
                              <Email><xsl:value-of select="ServiceAcknowledgement/VendorParty/Address/Communication/Email/URI"/></Email>
                              <xsl:for-each select="ServiceAcknowledgement/VendorParty/Address/Communication/Telephone">
                              <Phone>
                                 <TelephoneNumber>
                                    <CountryCode><xsl:attribute name="isoCountryCode">
                                       <xsl:value-of select="../../PhysicalAddress/CountryCode"/>
                                    </xsl:attribute>
                                    </CountryCode>
                                    <AreaOrCityCode></AreaOrCityCode>
                                    <Number><xsl:value-of select="translate(Number/SubscriberID,'.','')"/></Number>
                                 </TelephoneNumber>
                              </Phone>
                              </xsl:for-each>
                              <xsl:for-each select="ServiceAcknowledgement/VendorParty/Address/Communication/Facsimile">
                              <Fax>
                                 <TelephoneNumber>
                                    <CountryCode><xsl:attribute name="isoCountryCode">
                                       <xsl:value-of select="../../PhysicalAddress/CountryCode"/>
                                    </xsl:attribute>
                                    </CountryCode>
                                    <AreaOrCityCode></AreaOrCityCode>
                                    <Number><xsl:value-of select="translate(Number/SubscriberID,'.','')"/></Number>
                                 </TelephoneNumber>
                              </Fax>
                              </xsl:for-each>
                           </Contact>
                        </PartnerContact>
                        <PartnerContact>
                           <Contact role="to">
                              <xsl:attribute name="addressID">
                                 <xsl:value-of select="ServiceAcknowledgement/BillToParty/InternalID"/>
                              </xsl:attribute>
                              <Name>
                                 <xsl:call-template name="FillLangOut">
                                    <xsl:with-param name="p_spras_iso"
                                       select="ServiceAcknowledgement/BillToParty/InternalID/@schemeID"/>
                                    <xsl:with-param name="p_spras"
                                       select="ServiceAcknowledgement/BillToParty/InternalID/@schemeID"/>
                                    <xsl:with-param name="p_lang"
                                       select="$v_defaultLang"/>
                                 </xsl:call-template>
                                 <xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PersonName/BirthName"/>
                              </Name>
                              <PostalAddress>
                                 <Street><xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PhysicalAddress/StreetName"/></Street>
                                 <City><xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PhysicalAddress/CityName"/></City>
                                 <State>
                                    <xsl:attribute name="isoStateCode"><xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PhysicalAddress/RegionCode"/></xsl:attribute>
                                    <xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PhysicalAddress/RegionName"/>
                                 </State>
                                 <PostalCode><xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PhysicalAddress/POBoxPostalCode"/></PostalCode>
                                 <Country><xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PhysicalAddress/CountryCode"/>
                                 </xsl:attribute>
                                    <xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/PhysicalAddress/CountryName"/></Country>
                              </PostalAddress>
                              <Email><xsl:value-of select="ServiceAcknowledgement/BillToParty/Address/Communication/Email/URI"/></Email>
                              <xsl:for-each select="ServiceAcknowledgement/BillToParty/Address/Communication/Telephone">
                                 <Phone>
                                    <TelephoneNumber>
                                       <CountryCode><xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="../../PhysicalAddress/CountryCode"/>
                                       </xsl:attribute>
                                       </CountryCode>
                                       <AreaOrCityCode></AreaOrCityCode>
                                       <Number><xsl:value-of select="translate(Number/SubscriberID,'.','')"/></Number>
                                    </TelephoneNumber>
                                 </Phone>
                              </xsl:for-each>
                              <xsl:for-each select="ServiceAcknowledgement/BillToParty/Address/Communication/Facsimile">
                                 <Fax>
                                    <TelephoneNumber>
                                       <CountryCode><xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="../../PhysicalAddress/CountryCode"/>
                                       </xsl:attribute>
                                       </CountryCode>
                                       <AreaOrCityCode></AreaOrCityCode>
                                       <Number><xsl:value-of select="translate(Number/SubscriberID,'.','')"/></Number>
                                    </TelephoneNumber>
                                 </Fax>
                              </xsl:for-each>
                           </Contact>
                        </PartnerContact>
                        <xsl:if test="ServiceAcknowledgement/ValidityPeriod">
                        <Period>
                           <xsl:attribute name="startDate">
                              <xsl:call-template name="ANDateTime">
                                 <xsl:with-param name="p_date"
                                    select="replace(substring(ServiceAcknowledgement/ValidityPeriod/StartDate,1,10),'-','')"/>
                                 <xsl:with-param name="p_time"
                                    select="replace(substring(ServiceAcknowledgement/ValidityPeriod/StartDate,12,8),':','')"/>
                                 <xsl:with-param name="p_timezone"
                                    select="$anERPTimeZone"/>
                              </xsl:call-template>
                           </xsl:attribute>
                           <xsl:attribute name="endDate">
                              <xsl:call-template name="ANDateTime">
                                 <xsl:with-param name="p_date"
                                    select="replace(substring(ServiceAcknowledgement/ValidityPeriod/EndDate,1,10),'-','')"/>
                                 <xsl:with-param name="p_time"
                                    select="replace(substring(ServiceAcknowledgement/ValidityPeriod/EndDate,12,8),':','')"/>
                                 <xsl:with-param name="p_timezone"
                                    select="$anERPTimeZone"/>
                              </xsl:call-template>
                           </xsl:attribute>
                        </Period>
                        </xsl:if>
                        <!--Call Template to fill Comments-->
                        <xsl:if
                           test="..//AribaComment/Item != ''"> 
                           <Comments>
                              <xsl:call-template name="MapMultiple_Text_Comments_Proxy_To_cXML">
                                 <xsl:with-param name="p_aribaComment"
                                    select="/n0:ERPServiceEntrySheetRequest/AribaComment"/>
                                 <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                 <xsl:with-param name="p_pd" select="$v_pd"/>
                              </xsl:call-template>  
                           </Comments>
                        </xsl:if>
                        <!-- IG-24945 Added the SuppplierReference info to replicate into AN -->
                        <IdReference domain="supplierReference"> 
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="$v_sellerID"/>
                           </xsl:attribute>
                        </IdReference>                        
                     </ServiceEntryRequestHeader>
                     <ServiceEntryOrder>
                        <ServiceEntryOrderInfo>
                           <OrderIDInfo>
                              <xsl:attribute name="orderID">
                                 <xsl:value-of select="ServiceAcknowledgement/Item[1]/PurchaseOrderReference/ID"/>
                              </xsl:attribute>
                              <xsl:attribute name="orderDate">
                                <xsl:call-template name="ANDateTime">
                                 <xsl:with-param name="p_date"
                                    select="replace(substring(ServiceAcknowledgement/Item[1]/PurchaseOrderReference/Date,1,10),'-','')"/>
                                 <xsl:with-param name="p_time" select="'120000'"/>
                                 <xsl:with-param name="p_timezone"
                                    select="$anERPTimeZone"/>
                              </xsl:call-template>
                              </xsl:attribute>
                           </OrderIDInfo> 
                        </ServiceEntryOrderInfo>
                        <xsl:for-each select="ServiceAcknowledgement/Item">
                           <!-- IG-15092 added v_iteration to use it for comments section to avoid concatenation of other service items long text into all service items -->                           
                           <xsl:variable name="v_iteration">
                              <xsl:value-of select="position()"/>
                           </xsl:variable>                            
                        <ServiceEntryItem>
                           <xsl:attribute name="serviceLineNumber">
                              <xsl:value-of select="ServiceLineNo"/>
                           </xsl:attribute>
                           <xsl:attribute name="quantity">
                              <xsl:value-of select="format-number(Quantity,'0.000')"/>
                           </xsl:attribute>
                           <xsl:attribute name="type">
                              <xsl:value-of select="'service'"/>
                           </xsl:attribute>
                           <xsl:if test="ProcessingTypeCode = 'U'">
                           <xsl:attribute name="isAdHoc">
                              <xsl:value-of select="'yes'"/>
                           </xsl:attribute>
                           </xsl:if>
                           <ItemReference>
                              <xsl:attribute name="lineNumber">
                                 <xsl:value-of select="ID"/>
                              </xsl:attribute>
                              <ItemID>
                                 <SupplierPartID>
                                    <!-- IG-33396: External Service Number truncated -->
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(ServicePerformerParty/InternalID/@schemeID)) > 0">
                                          <xsl:value-of select="ServicePerformerParty/InternalID/@schemeID"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="SellerID"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </SupplierPartID>
                              </ItemID>
                              <Description>
                                 <xsl:call-template name="FillLangOut">
                                    <xsl:with-param name="p_spras_iso"
                                       select="Description/@languageCode"/>
                                    <xsl:with-param name="p_spras"
                                       select="Description/@languageCode"/>
                                    <xsl:with-param name="p_lang"
                                       select="$v_defaultLang"/>
                                 </xsl:call-template>
                                 <xsl:value-of select="Description"/>
                              </Description>
                           </ItemReference>
                           <xsl:for-each select="PurchasingContractReference">
                           <MasterAgreementIDInfo>
                              <xsl:attribute name="agreementID">
                                 <xsl:value-of select="ID"/>
                              </xsl:attribute>
                           </MasterAgreementIDInfo>
                           </xsl:for-each>
                           <UnitOfMeasure>
                              <!-- IG-25707 Added the UOM Template  -->
                              <xsl:call-template name="UOMTemplate_Out">
                                 <xsl:with-param name="p_UOMinput" select="Quantity/@unitCode"/>
                                 <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                 <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                              </xsl:call-template> 
                           </UnitOfMeasure>
                           <UnitPrice>
                              <!-- IG-27349 Unit Price is populated from ERP   -->
                              <xsl:choose>
                                 <!--                                 <xsl:when test="exists(unit_price)">-->
                                 <xsl:when test="string-length(normalize-space(UnitPrice)) > 0">
                                    <Money>
                                       <xsl:attribute name="currency">
                                          <xsl:value-of select="Price/Amount/@currencyCode"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="(UnitPrice)"/>
                                    </Money>                                   
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when test="Quantity > 0">
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="Price/Amount/@currencyCode"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="(Price/Amount) div (Quantity)"/>
                                          </Money>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="Price/Amount/@currencyCode"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="Price/Amount"/>
                                          </Money>
                                       </xsl:otherwise>
                                    </xsl:choose>                                    
                                 </xsl:otherwise>
                              </xsl:choose>
                           </UnitPrice>
                           <SubtotalAmount>
                              <Money>
                                 <xsl:attribute name="currency">
                                    <xsl:value-of select="Price/Amount/@currencyCode"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="Price/Amount"/>
                              </Money>
                           </SubtotalAmount>
                           <xsl:for-each select="AccountAssignment/AccountingCodingBlockAssignment">
                           <Distribution>
                              <Accounting name="DistributionCharge">
                                 <xsl:if test="GeneralLedgerAccountReference/ID"> 
                                 <AccountingSegment>
                                    <xsl:attribute name="id">
                                       <xsl:value-of select="GeneralLedgerAccountReference/ID"/>
                                    </xsl:attribute>
                                    <Name><xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute>
                                       <xsl:value-of select="'GeneralLedger'"/>
                                    </Name>
                                    <Description>
                                       <xsl:attribute name="xml:lang">
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="'ID'"/>
                                    </Description>
                                 </AccountingSegment>
                                 </xsl:if>
                                 <xsl:if test="CostCentreID">
                                 <AccountingSegment> 
                                    <xsl:attribute name="id">
                                       <xsl:value-of select="CostCentreID"/>
                                    </xsl:attribute>
                                    <Name><xsl:attribute name="xml:lang">
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="'CostCenter'"/>
                                    </Name>
                                    <Description><xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute>
                                       <xsl:value-of select="'ID'"/>
                                    </Description>
                                 </AccountingSegment>
                                 </xsl:if> <xsl:choose>
                                     <xsl:when test="../../Distrib = '1'">
                                    <AccountingSegment>
                                    <xsl:attribute name="id">
                                       <xsl:value-of select="Quantity"/>
                                    </xsl:attribute>
                                       <Name><xsl:attribute name="xml:lang">
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:attribute>
                                          <xsl:value-of select="'Quantity'"/>
                                       </Name>
                                       <Description><xsl:attribute name="xml:lang">
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:attribute></Description>
                                       </AccountingSegment>
                                     </xsl:when>
                                     <xsl:when test="../../Distrib = '3'">
                                        <AccountingSegment>
                                           <xsl:attribute name="id">
                                              <xsl:value-of select="Amount"/>
                                           </xsl:attribute>
                                           <Name><xsl:attribute name="xml:lang">
                                              <xsl:value-of select="$v_defaultLang"/>
                                           </xsl:attribute>
                                              <xsl:value-of select="'Amount'"/>
                                           </Name>
                                           <Description><xsl:attribute name="xml:lang">
                                              <xsl:value-of select="$v_defaultLang"/>
                                           </xsl:attribute></Description>
                                        </AccountingSegment>
                                     </xsl:when>
                                        <xsl:when test="../../Distrib eq '2'">
                                           <AccountingSegment>
                                              <xsl:attribute name="id">
                                                 <xsl:value-of select="Percent"/>
                                              </xsl:attribute>
                                              <Name><xsl:attribute name="xml:lang">
                                                 <xsl:value-of select="$v_defaultLang"/>
                                              </xsl:attribute>
                                                 <xsl:value-of select="'Percent'"/>
                                              </Name>
                                              <Description><xsl:attribute name="xml:lang">
                                                 <xsl:value-of select="$v_defaultLang"/>
                                              </xsl:attribute></Description>
                                           </AccountingSegment>
                                     </xsl:when>
                                     <xsl:otherwise>
                                        <AccountingSegment>
                                           <xsl:attribute name="id">
                                              <xsl:value-of select="Percent"/>
                                           </xsl:attribute>
                                           <Name><xsl:attribute name="xml:lang">
                                              <xsl:value-of select="$v_defaultLang"/>
                                           </xsl:attribute>
                                              <xsl:value-of select="'Percent'"/>
                                           </Name>
                                           <Description><xsl:attribute name="xml:lang">
                                              <xsl:value-of select="$v_defaultLang"/>
                                           </xsl:attribute></Description>
                                        </AccountingSegment>
                                     </xsl:otherwise>
                                  </xsl:choose>
                                 
                                 <!--  IG-41238 start   -\->-->
                                 <xsl:choose>
                                    <xsl:when test="$v_BuyingandInvoicingEnabled = 'X'">
                                       <xsl:if test="InternalOrderID">
                                          <AccountingSegment> 
                                             <xsl:attribute name="id">
                                                <xsl:value-of select="InternalOrderID"/>
                                             </xsl:attribute>
                                             <Name><xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                                <xsl:value-of select="'InternalOrder'"/>
                                             </Name>
                                             <Description><xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                                <xsl:value-of select="'ID'"/>
                                             </Description>
                                          </AccountingSegment>
                                       </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:if test="InternalOrderID">
                                          <AccountingSegment> 
                                             <xsl:attribute name="id">
                                                <xsl:value-of select="InternalOrderID"/>
                                             </xsl:attribute>
                                             <Name><xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                                <xsl:value-of select="'InternalOrderID'"/>
                                             </Name>
                                             <Description><xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                                <xsl:value-of select="'ID'"/>
                                             </Description>
                                          </AccountingSegment>
                                       </xsl:if>
                                    </xsl:otherwise>
                                 </xsl:choose>    
                                 <!--   IG-41238 end   -->
                                 <xsl:if test="FixedAssetReference/MasterFixedAssetID">
                                 <AccountingSegment> 
                                    <xsl:attribute name="id">
                                       <xsl:value-of select="FixedAssetReference/MasterFixedAssetID"/>
                                    </xsl:attribute>
                                    <Name><xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute><xsl:value-of select="'Asset'"/>
                                    </Name>
                                    <Description><xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute>
                                       <xsl:value-of select="'ID'"/>
                                    </Description>
                                 </AccountingSegment>
                              </xsl:if>
                              <xsl:if test="ProjectReference/ProjectID">
                                 <AccountingSegment> 
                                    <xsl:attribute name="id">
                                       <xsl:value-of select="ProjectReference/ProjectID"/>
                                    </xsl:attribute>
                                    <Name><xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute>
                                       <xsl:value-of select="'WBSElement'"/>
                                    </Name>
                                    <Description><xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute>
                                       <xsl:value-of select="'ID'"/>
                                    </Description>
                                 </AccountingSegment>
                              </xsl:if>
                                 <xsl:if test="SerialNumber">
                                    <AccountingSegment>
                                       <xsl:attribute name="id">
                                          <xsl:value-of select="SerialNumber"/>
                                       </xsl:attribute>
                                       <Name xml:lang="en">SAPSerialNumber</Name>
                                       <Description><xsl:attribute name="xml:lang">
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:attribute></Description>
                                    </AccountingSegment>
                                 </xsl:if>
                              </Accounting>
                              <Charge>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="Amount/@currencyCode"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="Amount"/></Money>
                              </Charge>
                           </Distribution>
                           </xsl:for-each>
                           <xsl:if test="../../AribaComment/Item/ItemNumber">
                              <Comments>
                                 <xsl:call-template name="MapMultiple_Text_Comments_Proxy_To_cXML">
                                    <xsl:with-param name="p_itemNumber"
                                       select="ServiceLineNo"/>
                                    <xsl:with-param name="p_aribaComment"
                                       select="../../AribaComment"/>
                                    <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                 </xsl:call-template>  
                              </Comments>
                           </xsl:if>
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'punchinItemFromCatalog'"/>
                              </xsl:attribute>
                              <xsl:value-of select="'no'"/>
                           </Extrinsic>
                           <!-- Defect Fix IG-32194 PurchaseOrderItemID does dont exists, use ID instead -->
                           <xsl:for-each select="PurchaseOrderReference/ID">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'parentPOLineNumber'"/>
                              </xsl:attribute>
                              <xsl:value-of select="../ItemID"/>
                             </Extrinsic>
                           </xsl:for-each>
                           <xsl:choose>
                              <xsl:when test="ProcessingTypeCode = 'P'">
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'isLineFromPO'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="'yes'"/>
                                 </Extrinsic>
                              </xsl:when>
                              <xsl:otherwise>
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'isLineFromPO'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="'no'"/>
                                 </Extrinsic>
                              </xsl:otherwise>
                           </xsl:choose>
                        </ServiceEntryItem>
                        </xsl:for-each>
                     </ServiceEntryOrder>
                     <ServiceEntrySummary>
                        <SubtotalAmount>
                           <Money><xsl:attribute name="currency">
                              <xsl:value-of select="ServiceAcknowledgement/TotalAmount/@currencyCode"/></xsl:attribute>
                              <xsl:value-of select="ServiceAcknowledgement/TotalAmount"/>
                           </Money>
                        </SubtotalAmount>
                     </ServiceEntrySummary>
                  </ServiceEntryRequest>
               </Request>
            </cXML>
         </Payload>  
      </Combined>
      
      
      
   </xsl:template>
</xsl:stylesheet>
