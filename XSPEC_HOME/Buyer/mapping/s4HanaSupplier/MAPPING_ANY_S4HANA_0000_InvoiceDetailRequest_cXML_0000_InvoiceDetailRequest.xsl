<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="http://sap.com/xi/EDI"
   version="2.0" exclude-result-prefixes="#all">
   <xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
   <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
<!--<xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
   <xsl:param name="anTargetDocumentType"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="anERPSystemID"/>
   <xsl:param name="anSenderDefaultTimeZone"/>
   <xsl:param name="anSenderID"/>
   <xsl:param name="anReceiverID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:variable name="v_lang">
      <xsl:choose>
         <xsl:when
            test="string-length(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/Address/CorrespondenceLanguage) &gt; 0">
            <xsl:value-of
               select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/Address/CorrespondenceLanguage"
            />
         </xsl:when>
         <xsl:when
            test="string-length(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/Address/CorrespondenceLanguage) &gt; 0">
            <xsl:value-of
               select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/Address/CorrespondenceLanguage"
            />
         </xsl:when>
         <xsl:when
            test="string-length(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/Address/CorrespondenceLanguage) &gt; 0">
            <xsl:value-of
               select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/Address/CorrespondenceLanguage"
            />
         </xsl:when>
         <xsl:otherwise>EN</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="v_currDT">
      <xsl:value-of select="current-dateTime()"/>
   </xsl:variable>
   <xsl:variable name="v_cigDT">
      <xsl:value-of
         select="concat(substring-before($v_currDT, 'T'), 'T', substring(substring-after($v_currDT, 'T'), 1, 8))"
      />
   </xsl:variable>
   <xsl:variable name="v_cigTS">
      <xsl:call-template name="ERPDateTime">
         <xsl:with-param name="p_date" select="$v_cigDT"/>
         <xsl:with-param name="p_timezone" select="$anSenderDefaultTimeZone"/>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="v_erpDT">
      <xsl:call-template name="ERPDateTime">
         <xsl:with-param name="p_date" select="/n0:InvoiceRequest/MessageHeader/CreationDateTime"/>
         <xsl:with-param name="p_timezone" select="$anSenderDefaultTimeZone"/>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="v_inv_typ">
      <xsl:choose>
         <xsl:when test="/n0:InvoiceRequest/Invoice/SupplierInvoiceTypeCode = '004'">
            <xsl:value-of select="'standard'"/>
         </xsl:when>
         <xsl:when test="/n0:InvoiceRequest/Invoice/SupplierInvoiceTypeCode = '005'">
            <xsl:value-of select="'lineLevelCreditMemo'"/>
         </xsl:when>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="v_sign">
      <xsl:choose>
         <xsl:when test="$v_inv_typ = 'standard'">
            <xsl:value-of select="number(1)"/>
         </xsl:when>
         <xsl:when test="$v_inv_typ = 'lineLevelCreditMemo'">
            <xsl:value-of select="number(-1)"/>
         </xsl:when>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="v_billFrom"
      select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/Address"/>
   <xsl:variable name="v_billTo"
      select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/Address"/>
   <xsl:variable name="v_soldTo"
      select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/Address"/>
   <xsl:variable name="v_shipTo"
      select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/Address"/>
   <xsl:variable name="v_shipFrom"
      select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipFrom']/Address"/>
   <xsl:variable name="v_order_nr">
      <xsl:choose>
         <xsl:when
            test="count(distinct-values(/n0:InvoiceRequest/Invoice/Item/PurchaseOrderID)) = 1">
            <xsl:value-of select="/n0:InvoiceRequest/Invoice/Item[1]/PurchaseOrderID"/>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
   </xsl:variable>
   <xsl:template match="/n0:InvoiceRequest">
      <cXML>
         <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
         </xsl:attribute>
         <xsl:attribute name="timestamp">
            <xsl:value-of select="$v_cigTS"/>
         </xsl:attribute>
         <Header>
            <From>
               <Credential>
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <Identity>
                     <xsl:choose>
                        <xsl:when test="string-length(normalize-space(Invoice/SupplierSystemID)) > 0">
                           <xsl:value-of select="Invoice/SupplierSystemID"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$anSenderID" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </Identity>
               </Credential>
            </From>
            <To>
               <Credential>
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <Identity>
                     <xsl:choose>
                        <xsl:when test="string-length(normalize-space(Invoice/BuyerSystemID)) > 0">
                           <xsl:value-of select="Invoice/BuyerSystemID"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$anReceiverID" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </Identity>
               </Credential>
            </To>
            <Sender>
               <Credential>
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <Identity>
                     <xsl:value-of select="'AN01000000087'"/>
                  </Identity>
               </Credential>
               <UserAgent>Ariba_Supplier</UserAgent>
            </Sender>
         </Header>
         <Request>
            <xsl:attribute name="deploymentMode">
               <xsl:choose>
                  <xsl:when test="($anEnvName = 'PROD')">production</xsl:when>
                  <xsl:otherwise>test</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <InvoiceDetailRequest>
               <InvoiceDetailRequestHeader>
                  <xsl:attribute name="invoiceDate">
                     <!-- Begin of CI-2921 XSLT Enhancement -->
                     <!-- Pick invoice date from DocumentDate and remove timezone conversion logic as its only date from source -->
                     <!--<!-\- Start of IG-37930 Replace 'Z' with +00:00 in invoiceDate as these failing in AN Network -\->
                     <xsl:choose>
                        <xsl:when test="contains($v_erpDT, 'Z')">
                           <xsl:value-of select = "replace($v_erpDT,'Z','+00:00')"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$v_erpDT"/>
                        </xsl:otherwise>
                     </xsl:choose>
                     <!-\- End of IG-37930 Replace 'Z' with +00:00 in invoiceDate as these failing in AN Network -\->-->
                     <xsl:value-of select="/n0:InvoiceRequest/Invoice/DocumentDate"/>
                     <!-- End of CI-2921 XSLT Enhancement -->
                  </xsl:attribute>
                  <xsl:attribute name="invoiceID">
                     <xsl:choose>
                        <xsl:when test="($v_inv_typ = 'standard')">
                           <xsl:value-of
                              select="concat('INV_', /n0:InvoiceRequest/Invoice/SupplierInvoiceID)"
                           />
                        </xsl:when>
                        <xsl:when test="($v_inv_typ = 'lineLevelCreditMemo')">
                           <xsl:value-of
                              select="concat('CREM_', /n0:InvoiceRequest/Invoice/SupplierInvoiceID)"
                           />
                        </xsl:when>
                        <xsl:otherwise/>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="invoiceOrigin">
                     <xsl:value-of select="'supplier'"/>
                  </xsl:attribute>
                  <xsl:attribute name="operation">
                     <xsl:value-of select="'new'"/>
                  </xsl:attribute>
                  <xsl:attribute name="purpose">
                     <xsl:value-of select="$v_inv_typ"/>
                  </xsl:attribute>
                  <InvoiceDetailHeaderIndicator/>
                  <InvoiceDetailLineIndicator>
                     <xsl:if test="exists(/n0:InvoiceRequest/Invoice/Item/ItemTax)">
                        <xsl:attribute name="isTaxInLine">yes</xsl:attribute>
                     </xsl:if>
                  </InvoiceDetailLineIndicator>
                  <xsl:if test="exists($v_billFrom)">
                     <InvoicePartner>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'remitTo'"/>
                           </xsl:attribute>
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <xsl:value-of select="$v_billFrom/CorrespondenceLanguage"/>
                              </xsl:attribute>
                              <!-- Begin of CI-2921 XSLT Enhancement -->
                              <!-- Name is contatenation of AddressName and AddressAdditionalName -->
                              <xsl:value-of select="concat($v_billFrom/AddressName,$v_billFrom/AddressAdditionalName)"/>
                              <!-- End of CI-2921 XSLT Enhancement -->
                           </Name>
                           <PostalAddress>
                              <Street>
                                 <xsl:value-of select="$v_billFrom/StreetAddressName"/>
                              </Street>
                              <City>
                                 <xsl:value-of select="$v_billFrom/CityName"/>
                              </City>
                              <PostalCode>
                                 <xsl:value-of select="$v_billFrom/PostalCode"/>
                              </PostalCode>
                              <Country>
                                 <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="$v_billFrom/Country"/>
                                 </xsl:attribute>
                              </Country>
                           </PostalAddress>
                           <!-- Begin of CI-2921 XSLT Enhancement -->
                           <!-- Create node for Phone Number -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/PhoneNumber)) > 0">
                              <Phone>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billFrom/PhoneNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Phone>
                           </xsl:if>
                           <!-- Create node for Fax Number -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/FaxNumber)) > 0">
                              <Fax>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billFrom/FaxNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Fax>
                           </xsl:if>
                           <!-- Create node for Email address -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/EmailAddress)) > 0">
                              <Email>
                                 <xsl:value-of select="$v_billFrom/EmailAddress"/>
                              </Email>
                           </xsl:if>
                           <!-- Create IdReference for GlobalLocationNumber -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/GlobalLocationNumber)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'ILN'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/GlobalLocationNumber"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for buyerID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/BuyerPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'buyerID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/BuyerPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for supplierID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/SupplierPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'supplierID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/SupplierPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- End of CI-2921 XSLT Enhancement -->
                        </Contact>
                     </InvoicePartner>
                     <InvoicePartner>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'from'"/>
                           </xsl:attribute>
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <xsl:value-of select="$v_billFrom/CorrespondenceLanguage"/>
                              </xsl:attribute>
                              <!-- Begin of CI-2921 XSLT Enhancement -->
                              <!-- Name is contatenation of AddressName and AddressAdditionalName -->
                              <xsl:value-of select="concat($v_billFrom/AddressName,$v_billFrom/AddressAdditionalName)"/>
                              <!-- End of CI-2921 XSLT Enhancement -->
                           </Name>
                           <PostalAddress>
                              <Street>
                                 <xsl:value-of select="$v_billFrom/StreetAddressName"/>
                              </Street>
                              <City>
                                 <xsl:value-of select="$v_billFrom/CityName"/>
                              </City>
                              <PostalCode>
                                 <xsl:value-of select="$v_billFrom/PostalCode"/>
                              </PostalCode>
                              <Country>
                                 <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="$v_billFrom/Country"/>
                                 </xsl:attribute>
                              </Country>
                           </PostalAddress>
                           <!-- Begin of CI-2921 XSLT Enhancement -->
                           <!-- Create node for Phone Number -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/PhoneNumber)) > 0">
                              <Phone>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billFrom/PhoneNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Phone>
                           </xsl:if>
                           <!-- Create node for Fax Number -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/FaxNumber)) > 0">
                              <Fax>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billFrom/FaxNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Fax>
                           </xsl:if>
                           <!-- Create node for Email address -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/EmailAddress)) > 0">
                              <Email>
                                 <xsl:value-of select="$v_billFrom/EmailAddress"/>
                              </Email>
                           </xsl:if>
                           <!-- Create IdReference for GlobalLocationNumber -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/GlobalLocationNumber)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'ILN'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/GlobalLocationNumber"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for buyerID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/BuyerPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'buyerID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/BuyerPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for supplierID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/SupplierPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'supplierID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillFrom']/SupplierPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- End of CI-2921 XSLT Enhancement -->
                        </Contact>
                        <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/SupplierVATRegistration)) > 0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'vatID'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of
                                    select="/n0:InvoiceRequest/Invoice/SupplierVATRegistration"/>
                              </xsl:attribute>
                           </IdReference>
                        </xsl:if>
                     </InvoicePartner>
                  </xsl:if>
                  <xsl:if test="exists($v_billTo)">
                     <InvoicePartner>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'billTo'"/>
                           </xsl:attribute>
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <xsl:value-of select="$v_billTo/CorrespondenceLanguage"/>
                              </xsl:attribute>
                              <!-- Begin of CI-2921 XSLT Enhancement -->
                              <!-- Name is contatenation of AddressName and AddressAdditionalName -->
                              <xsl:value-of select="concat($v_billTo/AddressName,$v_billTo/AddressAdditionalName)"/>
                              <!-- End of CI-2921 XSLT Enhancement -->
                           </Name>
                           <PostalAddress>
                              <Street>
                                 <xsl:value-of select="$v_billTo/StreetAddressName"/>
                              </Street>
                              <City>
                                 <xsl:value-of select="$v_billTo/CityName"/>
                              </City>
                              <PostalCode>
                                 <xsl:value-of select="$v_billTo/PostalCode"/>
                              </PostalCode>
                              <Country>
                                 <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="$v_billTo/Country"/>
                                 </xsl:attribute>
                              </Country>
                           </PostalAddress>
                           <!-- Begin of CI-2921 XSLT Enhancement -->
                           <!-- Create node for Phone Number -->
                           <xsl:if test="string-length(normalize-space($v_billTo/PhoneNumber)) > 0">
                              <Phone>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billTo/PhoneNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Phone>
                           </xsl:if>
                           <!-- Create node for Fax Number -->
                           <xsl:if test="string-length(normalize-space($v_billTo/FaxNumber)) > 0">
                              <Fax>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billTo/FaxNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Fax>
                           </xsl:if>
                           <!-- Create node for Email address -->
                           <xsl:if test="string-length(normalize-space($v_billTo/EmailAddress)) > 0">
                              <Email>
                                 <xsl:value-of select="$v_billTo/EmailAddress"/>
                              </Email>
                           </xsl:if>
                           <!-- Create IdReference for GlobalLocationNumber -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/GlobalLocationNumber)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'ILN'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/GlobalLocationNumber"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for buyerID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/BuyerPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'buyerID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/BuyerPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for supplierID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/SupplierPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'supplierID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'BillTo']/SupplierPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- End of CI-2921 XSLT Enhancement -->
                        </Contact>
                        <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/BuyerVATRegistration)) > 0">
                           <IdReference>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="'vatID'"/>
                              </xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of
                                    select="/n0:InvoiceRequest/Invoice/BuyerVATRegistration"/>
                              </xsl:attribute>
                           </IdReference>
                        </xsl:if>
                     </InvoicePartner>
                  </xsl:if>
                  <xsl:if test="exists($v_soldTo)">
                     <InvoicePartner>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'soldTo'"/>
                           </xsl:attribute>
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <xsl:value-of select="$v_soldTo/CorrespondenceLanguage"/>
                              </xsl:attribute>
                              <!-- Begin of CI-2921 XSLT Enhancement -->
                              <!-- Name is contatenation of AddressName and AddressAdditionalName -->
                              <xsl:value-of select="concat($v_soldTo/AddressName,$v_soldTo/AddressAdditionalName)"/>
                              <!-- End of CI-2921 XSLT Enhancement -->
                           </Name>
                           <PostalAddress>
                              <Street>
                                 <xsl:value-of select="$v_soldTo/StreetAddressName"/>
                              </Street>
                              <City>
                                 <xsl:value-of select="$v_soldTo/CityName"/>
                              </City>
                              <PostalCode>
                                 <xsl:value-of select="$v_soldTo/PostalCode"/>
                              </PostalCode>
                              <Country>
                                 <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="$v_soldTo/Country"/>
                                 </xsl:attribute>
                              </Country>
                           </PostalAddress>
                           <!-- Begin of CI-2921 XSLT Enhancement -->
                           <!-- Create node for Phone Number -->
                           <xsl:if test="string-length(normalize-space($v_soldTo/PhoneNumber)) > 0">
                              <Phone>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_soldTo/PhoneNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Phone>
                           </xsl:if>
                           <!-- Create node for Fax Number -->
                           <xsl:if test="string-length(normalize-space($v_soldTo/FaxNumber)) > 0">
                              <Fax>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_soldTo/FaxNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Fax>
                           </xsl:if>
                           <!-- Create node for Email address -->
                           <xsl:if test="string-length(normalize-space($v_soldTo/EmailAddress)) > 0">
                              <Email>
                                 <xsl:value-of select="$v_soldTo/EmailAddress"/>
                              </Email>
                           </xsl:if>
                           <!-- Create IdReference for GlobalLocationNumber -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/GlobalLocationNumber)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'ILN'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/GlobalLocationNumber"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for buyerID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/BuyerPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'buyerID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/BuyerPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for supplierID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/SupplierPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'supplierID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'SoldTo']/SupplierPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- End of CI-2921 XSLT Enhancement -->
                        </Contact>
                     </InvoicePartner>
                  </xsl:if>
                  <xsl:if test="exists($v_shipTo) or exists($v_shipFrom)">
                     <InvoiceDetailShipping>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'shipFrom'"/>
                           </xsl:attribute>
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <xsl:value-of select="$v_billFrom/CorrespondenceLanguage"/>
                              </xsl:attribute>
                              <!-- Begin of CI-2921 XSLT Enhancement -->
                              <!-- Name is contatenation of AddressName and AddressAdditionalName -->
                              <xsl:value-of select="concat($v_billFrom/AddressName,$v_billFrom/AddressAdditionalName)"/>
                              <!-- End of CI-2921 XSLT Enhancement -->
                           </Name>
                           <PostalAddress>
                              <Street>
                                 <xsl:value-of select="$v_billFrom/StreetAddressName"/>
                              </Street>
                              <City>
                                 <xsl:value-of select="$v_billFrom/CityName"/>
                              </City>
                              <PostalCode>
                                 <xsl:value-of select="$v_billFrom/PostalCode"/>
                              </PostalCode>
                              <Country>
                                 <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="$v_billFrom/Country"/>
                                 </xsl:attribute>
                              </Country>
                           </PostalAddress>
                           <!-- Begin of CI-2921 XSLT Enhancement -->
                           <!-- Create node for Phone Number -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/PhoneNumber)) > 0">
                              <Phone>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billFrom/PhoneNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Phone>
                           </xsl:if>
                           <!-- Create node for Fax Number -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/FaxNumber)) > 0">
                              <Fax>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_billFrom/FaxNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Fax>
                           </xsl:if>
                           <!-- Create node for Email address -->
                           <xsl:if test="string-length(normalize-space($v_billFrom/EmailAddress)) > 0">
                              <Email>
                                 <xsl:value-of select="$v_billFrom/EmailAddress"/>
                              </Email>
                           </xsl:if>
                           <!-- Create IdReference for GlobalLocationNumber -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipFrom']/GlobalLocationNumber)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'ILN'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipFrom']/GlobalLocationNumber"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for buyerID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipFrom']/BuyerPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'buyerID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipFrom']/BuyerPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for supplierID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipFrom']/SupplierPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'supplierID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipFrom']/SupplierPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- End of CI-2921 XSLT Enhancement -->
                        </Contact>
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="'shipTo'"/>
                           </xsl:attribute>
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <xsl:value-of select="$v_shipTo/CorrespondenceLanguage"/>
                              </xsl:attribute>
                              <!-- Begin of CI-2921 XSLT Enhancement -->
                              <!-- Name is contatenation of AddressName and AddressAdditionalName -->
                              <xsl:value-of select="concat($v_shipTo/AddressName,$v_shipTo/AddressAdditionalName)"/>
                              <!-- End of CI-2921 XSLT Enhancement -->
                           </Name>
                           <PostalAddress>
                              <Street>
                                 <xsl:value-of select="$v_shipTo/StreetAddressName"/>
                              </Street>
                              <City>
                                 <xsl:value-of select="$v_shipTo/CityName"/>
                              </City>
                              <PostalCode>
                                 <xsl:value-of select="$v_shipTo/PostalCode"/>
                              </PostalCode>
                              <Country>
                                 <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="$v_shipTo/Country"/>
                                 </xsl:attribute>
                              </Country>
                           </PostalAddress>
                           <!-- Begin of CI-2921 XSLT Enhancement -->
                           <!-- Create node for Phone Number -->
                           <xsl:if test="string-length(normalize-space($v_shipTo/PhoneNumber)) > 0">
                              <Phone>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_shipTo/PhoneNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Phone>
                           </xsl:if>
                           <!-- Create node for Fax Number -->
                           <xsl:if test="string-length(normalize-space($v_shipTo/FaxNumber)) > 0">
                              <Fax>
                                 <TelephoneNumber>
                                    <Number>
                                       <xsl:value-of select="$v_shipTo/FaxNumber"/>
                                    </Number>
                                 </TelephoneNumber>
                              </Fax>
                           </xsl:if>
                           <!-- Create node for Email address -->
                           <xsl:if test="string-length(normalize-space($v_shipTo/EmailAddress)) > 0">
                              <Email>
                                 <xsl:value-of select="$v_shipTo/EmailAddress"/>
                              </Email>
                           </xsl:if>
                           <!-- Create IdReference for GlobalLocationNumber -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/GlobalLocationNumber)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'ILN'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/GlobalLocationNumber"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for buyerID -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/BuyerPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'buyerID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/BuyerPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- Create IdReference for supplier -->
                           <xsl:if test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/SupplierPartyID)) > 0">
                              <IdReference>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'supplierID'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="identifier">
                                    <xsl:value-of select="/n0:InvoiceRequest/Invoice/Party[@PartyType = 'ShipTo']/SupplierPartyID"/>
                                 </xsl:attribute>
                              </IdReference>
                           </xsl:if>
                           <!-- End of CI-2921 XSLT Enhancement -->
                        </Contact>
                     </InvoiceDetailShipping>
                  </xsl:if>
                  <!-- Start IG-24714 if percent is missing populate as NetPaymentDays without Discount node -->
                  <xsl:if test="exists(Invoice/PaymentTerms/CashDiscount1Days)">
                     <PaymentTerm>
                        <xsl:attribute name="payInNumberOfDays">
                           <xsl:value-of
                              select="Invoice/PaymentTerms/CashDiscount1Days"/>
                        </xsl:attribute>
                        <xsl:if test="Invoice/PaymentTerms/CashDiscount1Percent > 0">
                           <Discount>
                              <DiscountPercent>
                                 <xsl:attribute name="percent">
                                    <xsl:value-of
                                       select="Invoice/PaymentTerms/CashDiscount1Percent"/>
                                 </xsl:attribute>
                              </DiscountPercent>
                           </Discount>
                        </xsl:if>
                     </PaymentTerm>
                  </xsl:if>
                  <xsl:if test="exists(Invoice/PaymentTerms/CashDiscount2Days)">
                     <PaymentTerm>
                        <xsl:attribute name="payInNumberOfDays">
                           <xsl:value-of
                              select="Invoice/PaymentTerms/CashDiscount2Days"/>
                        </xsl:attribute>
                        <xsl:if test="Invoice/PaymentTerms/CashDiscount2Percent > 0">
                           <Discount>
                              <DiscountPercent>
                                 <xsl:attribute name="percent">
                                    <xsl:value-of
                                       select="Invoice/PaymentTerms/CashDiscount2Percent"/>
                                 </xsl:attribute>
                              </DiscountPercent>
                           </Discount>
                        </xsl:if>
                     </PaymentTerm>
                  </xsl:if>
                  <!-- End IG-24714 -->
                  <xsl:if
                     test="string-length(/n0:InvoiceRequest/Invoice/PaymentTerms/NetPaymentDays) &gt; 0">
                     <PaymentTerm>
                        <xsl:attribute name="payInNumberOfDays">
                           <xsl:value-of
                              select="/n0:InvoiceRequest/Invoice/PaymentTerms/NetPaymentDays"/>
                        </xsl:attribute>
                     </PaymentTerm>
                  </xsl:if>
                  <!-- Begin of CI-2921 XSLT Enhancement -->
                  <!-- Create node for Header Texts Comments -->
                  <xsl:if test="exists(/n0:InvoiceRequest/Invoice/DocumentHeaderText)">
                     <xsl:for-each select="/n0:InvoiceRequest/Invoice/DocumentHeaderText">
                        <Comments>
                           <xsl:attribute name="xml:lang">
                              <xsl:value-of select="TextElementLanguage"/>
                           </xsl:attribute>
                           <xsl:attribute name="type">
                              <xsl:value-of select="@Type"/>
                           </xsl:attribute>
                           <xsl:value-of select="TextElementText"/>
                        </Comments>
                     </xsl:for-each>
                  </xsl:if>
                  <!-- Create Extrinsic for incoTerms -->
                  <xsl:if
                     test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Incoterms/IncotermsClassification)) > 0">
                     <Extrinsic name="incoTerms">
                        <xsl:value-of select="/n0:InvoiceRequest/Invoice/Incoterms/IncotermsClassification"/>
                     </Extrinsic>
                  </xsl:if>
                  <!-- Create Extrinsic for invoiceSourceDocument -->
                  <xsl:if
                     test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/Item[1]/PurchaseOrderID)) > 0">
                     <Extrinsic name="invoiceSourceDocument">
                        <xsl:value-of select="/n0:InvoiceRequest/Invoice/Item[1]/PurchaseOrderID"/>
                     </Extrinsic>
                  </xsl:if>
                  <!-- End of CI-2921 XSLT Enhancement -->
                  <xsl:if
                     test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/BuyerVATRegistration)) > 0">
                     <Extrinsic name="BuyerVATID">
                        <xsl:value-of select="/n0:InvoiceRequest/Invoice/BuyerVATRegistration"/>
                     </Extrinsic>
                  </xsl:if>
                  <xsl:if
                     test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/SupplierVATRegistration)) > 0">
                     <Extrinsic name="SupplierVATID">
                        <xsl:value-of select="/n0:InvoiceRequest/Invoice/SupplierVATRegistration"/>
                     </Extrinsic>
                  </xsl:if>
               </InvoiceDetailRequestHeader>
               <InvoiceDetailOrder>
                  <InvoiceDetailOrderInfo>
                     <OrderReference>
                        <xsl:attribute name="orderID">
                           <xsl:value-of select="$v_order_nr"/>
                        </xsl:attribute>
                        <DocumentReference>
                           <xsl:attribute name="payloadID"/>
                        </DocumentReference>
                     </OrderReference>
                  </InvoiceDetailOrderInfo>
                  <xsl:for-each select="Invoice/Item">
                     <InvoiceDetailItem>
                        <xsl:attribute name="invoiceLineNumber">
                           <xsl:value-of select="SupplierInvoiceItemID"/>
                        </xsl:attribute>
                        <xsl:attribute name="quantity">
                           <xsl:value-of select="InvoicedQuantity * $v_sign"/>
                        </xsl:attribute>
                        <UnitOfMeasure>
                           <xsl:value-of select="InvoicedQuantity/@unitCode"/>
                        </UnitOfMeasure>
                        <!-- Begin of CI-2921 XSLT Enhancement -->
                        <!-- Update Unit price from 'PricingElement[SupplierConditionType = 'UNPR']/ConditionAmount'. Put negative sign only if 
                             InvoiceRequest/Invoice/SupplierInvoiceTypeCode = '005' -->
                        <xsl:if test="PricingElement/SupplierConditionType = 'UNPR'">
                           <xsl:choose>
                              <xsl:when test="/n0:InvoiceRequest/Invoice/SupplierInvoiceTypeCode = '005'">
                                 <UnitPrice>
                                    <Money>
                                       <xsl:attribute name="currency">
                                          <xsl:value-of select="PricingElement[SupplierConditionType = 'UNPR']/ConditionAmount/@currencyCode"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="PricingElement[SupplierConditionType = 'UNPR']/ConditionAmount * $v_sign"/>
                                    </Money>
                                 </UnitPrice>
                              </xsl:when>
                              <xsl:otherwise>
                                 <UnitPrice>
                                    <Money>
                                       <xsl:attribute name="currency">
                                          <xsl:value-of select="PricingElement[SupplierConditionType = 'UNPR']/ConditionAmount/@currencyCode"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="PricingElement[SupplierConditionType = 'UNPR']/ConditionAmount"/>
                                    </Money>
                                 </UnitPrice>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:if>
                        <!-- End of CI-2921 XSLT Enhancement -->
                        <InvoiceDetailItemReference>
                           <xsl:attribute name="lineNumber">
                              <xsl:value-of select="PurchaseOrderItemID"/>
                           </xsl:attribute>
                           <ItemID>
                              <SupplierPartID>
                                 <xsl:value-of select="Product/SupplierProductID"/>
                              </SupplierPartID>
                              <!-- IG-34318 -->
                              <!-- Removing Hard coded value for BuyerPartId -->
                              <BuyerPartID>
                                 <xsl:if test="string-length(Product/BuyerProductID) &gt; 0">
                                    <xsl:value-of select="Product/BuyerProductID" />
                                 </xsl:if>
                              </BuyerPartID>
                              <!-- IG-34318 -->
                           </ItemID>
                           <!-- CI-2772 - 4A1 - Invoice Item Description in SOAP API -->
                           <xsl:if test="string-length(normalize-space(BillingDocumentItemText)) > 0">
                              <Description>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                 </xsl:attribute>
                                 <ShortName>
                                    <xsl:value-of select="BillingDocumentItemText"/>
                                 </ShortName>
                              </Description>
                           </xsl:if>
                           <!-- CI-2772 -->
                           <!-- Begin of CI-2921 XSLT Enhancement -->
                           <!-- Create node for Manufacturer Part Number -->
                           <xsl:if test="string-length(normalize-space(Product/ManufacturerPartNumber)) > 0">
                              <ManufacturerPartID>
                                 <xsl:value-of select="Product/ManufacturerPartNumber"/>
                              </ManufacturerPartID>
                           </xsl:if>
                           <!-- Create node for EANID  -->
                           <xsl:if test="string-length(normalize-space(Product/GlobalTradeItemNumber)) > 0">
                              <InvoiceDetailItemReferenceIndustry>
                                 <InvoiceDetailItemReferenceRetail>
                                    <EANID>
                                       <xsl:value-of select="Product/GlobalTradeItemNumber"/>
                                    </EANID>
                                 </InvoiceDetailItemReferenceRetail>
                              </InvoiceDetailItemReferenceIndustry>
                           </xsl:if>
                           <!-- End of CI-2921 XSLT Enhancement -->
                        </InvoiceDetailItemReference>
                        <SubtotalAmount>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="NetAmount/@currencyCode"/>
                              </xsl:attribute>
                              <xsl:value-of select="format-number(number(NetAmount * $v_sign),'#.######')"/>
                           </Money>
                        </SubtotalAmount>
                        <xsl:if test="string-length(normalize-space(TaxAmount)) > 0 or string-length(normalize-space(ItemTax/Amount)) > 0">
                           <Tax>
                              <xsl:choose>
                                 <xsl:when
                                    test="string-length(normalize-space(TaxAmount)) > 0">
                                    <Money>
                                       <xsl:attribute name="currency">
                                          <xsl:value-of
                                             select="TaxAmount/@currencyCode"/>
                                       </xsl:attribute>
                                       <xsl:value-of
                                          select="format-number(number(TaxAmount * $v_sign), '#.######')"/>
                                    </Money>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <Money>
                                       <xsl:attribute name="currency">
                                          <xsl:value-of
                                             select="ItemTax/Amount/@currencyCode"/>
                                       </xsl:attribute>
                                       <xsl:value-of
                                          select="format-number(number(ItemTax/Amount * $v_sign), '#.######')"/>
                                    </Money>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <Description>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                 </xsl:attribute>
                              </Description>
                              <xsl:for-each select="ItemTax">
                                 <xsl:if test="string-length(normalize-space(Amount)) > 0">
                                    <TaxDetail>
                                       <xsl:attribute name="category">
                                          <xsl:value-of select="upper-case(SupplierTaxTypeCode)"/>
                                       </xsl:attribute>
                                       <xsl:attribute name="percentageRate">
                                          <xsl:value-of select="TaxPercentage"/>
                                       </xsl:attribute>
                                       <!-- Begin of CI-2921 XSLT Enhancement -->
                                       <!-- Create attribute for tax determination Date -->
                                       <xsl:if test="string-length(normalize-space(TaxDeterminationDate)) > 0">
                                          <xsl:attribute name="taxPointDate">
                                             <xsl:value-of select="TaxDeterminationDate"/>
                                          </xsl:attribute>
                                       </xsl:if>
                                       <!-- Create node for Tax location -->
                                       <xsl:if test="string-length(normalize-space(TaxJurisdiction)) > 0">
                                          <TaxLocation>
                                             <xsl:value-of select="TaxJurisdiction"/>
                                          </TaxLocation>
                                       </xsl:if>
                                       <!-- End of CI-2921 XSLT Enhancement -->
                                       <xsl:if test="../NetAmount > 0">
                                          <TaxableAmount>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                   <xsl:value-of select="../NetAmount/@currencyCode"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="format-number(number(../NetAmount * $v_sign), '#.######')"/>
                                             </Money>
                                          </TaxableAmount>
                                       </xsl:if>
                                       <TaxAmount>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="Amount/@currencyCode"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="format-number(number(Amount * $v_sign), '#.######')"/>
                                          </Money>
                                       </TaxAmount> 
                                    </TaxDetail>
                                 </xsl:if>
                              </xsl:for-each>
                           </Tax>
                        </xsl:if>            
                        <GrossAmount>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="GrossAmount/@currencyCode"/>
                              </xsl:attribute>
                              <xsl:value-of select="format-number(number(GrossAmount * $v_sign),'#.######')"/>
                           </Money>
                        </GrossAmount>
                        <NetAmount>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="NetAmount/@currencyCode"/>
                              </xsl:attribute>
                              <xsl:value-of select="format-number(number(NetAmount * $v_sign),'#.######')"/>
                           </Money>
                        </NetAmount>
                        <!-- Begin of CI-2921 XSLT Enhancement -->
                        <!-- Create node for Ship Notice ID Info -->
                        <xsl:if test="string-length(normalize-space(DeliveryNote)) > 0">
                           <ShipNoticeIDInfo>
                              <xsl:attribute name="shipNoticeID">
                                 <xsl:value-of select="DeliveryNote"/>
                              </xsl:attribute>
                           </ShipNoticeIDInfo>
                        </xsl:if>
                        <!-- create node for Line Item Texts -->
                        <xsl:if test="exists(DocumentItemText)">
                           <xsl:for-each select="DocumentItemText">
                              <Comments>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="TextElementLanguage"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="type">
                                    <xsl:value-of select="@Type"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="TextElementText"/>
                              </Comments>
                           </xsl:for-each>
                        </xsl:if>
                        <!-- End of CI-2921 XSLT Enhancement -->
                     </InvoiceDetailItem>
                     <!-- Begin of CI-2921 XSLT Enhancement -->
                     <!-- Create new node InvoiceDetailShipNoticeInfo for each line item -->
                     <xsl:if test="string-length(normalize-space(DeliveryNote)) > 0">
                        <InvoiceDetailShipNoticeInfo>
                           <ShipNoticeReference>
                              <xsl:attribute name="shipNoticeID">
                                 <xsl:value-of select="DeliveryNote"/>
                              </xsl:attribute>
                           </ShipNoticeReference>
                        </InvoiceDetailShipNoticeInfo>
                     </xsl:if>
                     <!-- End of CI-2921 XSLT Enhancement -->
                  </xsl:for-each>
               </InvoiceDetailOrder>
               <InvoiceDetailSummary>
                  <SubtotalAmount>
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="/n0:InvoiceRequest/Invoice/NetAmount/@currencyCode"
                           />
                        </xsl:attribute>
                        <xsl:value-of select="format-number(number(/n0:InvoiceRequest/Invoice/NetAmount * $v_sign),'#.######')"/>
                     </Money>
                  </SubtotalAmount>
                  <Tax>
                     <xsl:choose>
                        <xsl:when
                           test="string-length(normalize-space(/n0:InvoiceRequest/Invoice/TaxAmount)) > 0">
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of
                                    select="/n0:InvoiceRequest/Invoice/TaxAmount/@currencyCode"/>
                              </xsl:attribute>
                              <xsl:value-of
                                 select="format-number(number(/n0:InvoiceRequest/Invoice/TaxAmount * $v_sign), '#.######')"
                              />
                           </Money>
                        </xsl:when>
                        <xsl:otherwise>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of
                                    select="/n0:InvoiceRequest/Invoice/HeaderTax/Amount/@currencyCode"
                                 />
                              </xsl:attribute>
                              <xsl:value-of
                                 select="format-number(number(/n0:InvoiceRequest/Invoice/HeaderTax/Amount * $v_sign), '#.######')"
                              />
                           </Money>
                        </xsl:otherwise>
                     </xsl:choose>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="$v_lang"/>
                        </xsl:attribute>
                     </Description>
                     <xsl:for-each select="/n0:InvoiceRequest/Invoice/HeaderTax">
                        <TaxDetail>
                           <xsl:attribute name="category">
                              <xsl:value-of select="upper-case(SupplierTaxTypeCode)"/>
                           </xsl:attribute>
                           <xsl:attribute name="percentageRate">
                              <xsl:value-of select="TaxPercentage"/>
                           </xsl:attribute>    
                           <TaxAmount>
                              <Money>
                                 <xsl:attribute name="currency">
                                    <xsl:value-of select="Amount/@currencyCode"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="format-number(number(Amount * $v_sign),'#.######')"/>
                              </Money>
                           </TaxAmount>
                        </TaxDetail>
                     </xsl:for-each>
                  </Tax>
                  <!--SpecialHandlingAmount-->
                  <xsl:if
                     test="string-length(/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HSVA']/ConditionAmount) &gt; 0">
                     <SpecialHandlingAmount>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of
                                 select="/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HSVA']/ConditionAmount/@currencyCode"
                              />
                           </xsl:attribute>
                           <xsl:value-of
                              select="/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HSVA']/ConditionAmount"
                           />
                        </Money>
                     </SpecialHandlingAmount>
                  </xsl:if>
                  <!--ShippingAmount-->
                  <xsl:if
                     test="string-length(/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HFVA']/ConditionAmount) &gt; 0">
                     <ShippingAmount>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of
                                 select="/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HFVA']/ConditionAmount/@currencyCode"
                              />
                           </xsl:attribute>
                           <xsl:value-of
                              select="/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HFVA']/ConditionAmount"
                           />
                        </Money>
                     </ShippingAmount>
                  </xsl:if>
                  <GrossAmount>
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of
                              select="/n0:InvoiceRequest/Invoice/GrossAmount/@currencyCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="format-number(number(/n0:InvoiceRequest/Invoice/GrossAmount * $v_sign),'#.######')"/>
                     </Money>
                  </GrossAmount>
                  <!--<!InvoiceDetailDiscount-->
                  <xsl:if
                     test="string-length(/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HDVA']/ConditionAmount) &gt; 0">
                     <InvoiceDetailDiscount>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of
                                 select="/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HDVA']/ConditionAmount/@currencyCode"
                              />
                           </xsl:attribute>
                           <xsl:value-of
                              select="/n0:InvoiceRequest/Invoice/PricingElement[SupplierConditionType = 'HDVA']/ConditionAmount"
                           />
                        </Money>
                     </InvoiceDetailDiscount>
                  </xsl:if>
                  <NetAmount>
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="/n0:InvoiceRequest/Invoice/NetAmount/@currencyCode"
                           />
                        </xsl:attribute>
                        <xsl:value-of select="format-number(number(/n0:InvoiceRequest/Invoice/NetAmount * $v_sign),'#.######')"/>
                     </Money>
                  </NetAmount>
                  <DueAmount>
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of
                              select="/n0:InvoiceRequest/Invoice/GrossAmount/@currencyCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="format-number(number(/n0:InvoiceRequest/Invoice/GrossAmount * $v_sign),'#.######')"/>
                     </Money>
                  </DueAmount>
               </InvoiceDetailSummary>
            </InvoiceDetailRequest>
         </Request>
      </cXML>
   </xsl:template>
</xsl:stylesheet>
