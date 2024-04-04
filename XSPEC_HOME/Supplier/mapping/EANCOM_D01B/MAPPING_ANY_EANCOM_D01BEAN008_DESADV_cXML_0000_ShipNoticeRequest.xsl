<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact" version="2.0" exclude-result-prefixes="#all">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anSharedSecrete"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="cXMLAttachments"/>
   <xsl:param name="attachSeparator" select="'\|'"/>
   <xsl:param name="anSenderDefaultTimeZone"/>
   <!-- For local testing -->
   <!--xsl:variable name="lookups" select="document('LOOKUP_EANCOM_D01BEAN008.xml')"/>
   <xsl:include href="FORMAT_EANCOM_D01BEAN008_cXML_0000.xsl"/-->
   <!--  PD references  -->
   <xsl:include href="FORMAT_EANCOM_D01BEAN008_cXML_0000.xsl"/>
   <xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_EANCOM_D01BEAN008.xml')"/>

   <xsl:template match="ns0:*">
      <xsl:element name="cXML">
         <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
         </xsl:attribute>
         <xsl:attribute name="timestamp">
            <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][Z]')"/>
         </xsl:attribute>
         <xsl:element name="Header">
            <xsl:element name="From">
               <xsl:element name="Credential">
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <xsl:element name="Identity">
                     <xsl:value-of select="$anSupplierANID"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
            <xsl:element name="To">
               <xsl:element name="Credential">
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <xsl:element name="Identity">
                     <xsl:value-of select="$anBuyerANID"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
            <xsl:element name="Sender">
               <xsl:element name="Credential">
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <xsl:element name="Identity">
                     <xsl:value-of select="$anProviderANID"/>
                  </xsl:element>
                  <xsl:element name="SharedSecret">
                     <xsl:value-of select="$anSharedSecrete"/>
                  </xsl:element>
               </xsl:element>
               <xsl:element name="UserAgent">
                  <xsl:value-of select="'Ariba Supplier'"/>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:element name="Request">
            <xsl:choose>
               <xsl:when test="$anEnvName = 'PROD'">
                  <xsl:attribute name="deploymentMode">production</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="deploymentMode">test</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="ShipNoticeRequest">
               <xsl:element name="ShipNoticeHeader">
                  <xsl:attribute name="shipmentID">
                     <xsl:choose>
                        <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '351' or C_C002/D_1001 = '345']/D_1225 = '3'">
                           <xsl:value-of select="concat(normalize-space(M_DESADV/S_BGM[C_C002/D_1001 = '351' or C_C002/D_1001 = '345']/C_C106/D_1004), '_1')"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="normalize-space(M_DESADV/S_BGM[C_C002/D_1001 = '351' or C_C002/D_1001 = '345']/C_C106/D_1004)"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="operation">
                     <xsl:choose>
                        <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '351' or C_C002/D_1001 = '345']/D_1225 = '3'">delete</xsl:when>
                        <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '351' or C_C002/D_1001 = '345']/D_1225 = '5'">update</xsl:when>
                        <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '351' or C_C002/D_1001 = '345']/D_1225 = '9'">new</xsl:when>
                        <xsl:otherwise>new</xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="noticeDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="dateTime">
                           <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '137']/D_2380"/>
                        </xsl:with-param>
                        <xsl:with-param name="dateTimeFormat">
                           <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '137']/D_2379"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:attribute>
                  <!-- shipmentDate -->
                  <xsl:if test="M_DESADV/S_DTM/C_C507[D_2005 = '11']/D_2380 != ''">
                     <xsl:attribute name="shipmentDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '11']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '11']/D_2379"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <!-- deliveryDate -->
                  <xsl:if test="M_DESADV/S_DTM/C_C507[D_2005 = '17']/D_2380 != ''">
                     <xsl:attribute name="deliveryDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '17']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '17']/D_2379"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <!-- shipmentType -->
                  <xsl:choose>
                     <xsl:when test="M_DESADV/S_BGM/C_C002/D_1001 = '351'">
                        <xsl:attribute name="shipmentType" select="'actual'"/>
                     </xsl:when>
                     <xsl:when test="M_DESADV/S_BGM/C_C002/D_1001 = '345'">
                        <xsl:attribute name="shipmentType" select="'planned'"/>
                     </xsl:when>
                  </xsl:choose>
                  <!-- fulfillmentType -->
                  <xsl:if test="M_DESADV/S_ALI/D_4183 != ''">
                     <xsl:attribute name="fulfillmentType">
                        <xsl:choose>
                           <xsl:when test="M_DESADV/S_ALI/D_4183 = '164'">complete</xsl:when>
                           <xsl:when test="M_DESADV/S_ALI/D_4183 = '165'">partial</xsl:when>
                           <xsl:otherwise>complete</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </xsl:if>
                  <!-- requestedDeliveryDate -->
                  <xsl:if test="M_DESADV/S_DTM/C_C507[D_2005 = '2']/D_2380 != ''">
                     <xsl:attribute name="requestedDeliveryDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '2']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '2']/D_2379"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <!-- Contacts -->
                  <xsl:for-each select="M_DESADV/G_SG2[S_NAD/D_3035 != 'DP']">
                     <xsl:apply-templates select=".">
                        <xsl:with-param name="role" select="S_NAD/D_3035"/>
                        <xsl:with-param name="grpRFF" select="G_SG3"/>
                        <xsl:with-param name="buildRFFType" select="'IdRef'"/>
                     </xsl:apply-templates>
                  </xsl:for-each>
                  <!-- Comments / Attachments -->
                  <xsl:if test="$cXMLAttachments != ''">
                     <xsl:element name="Comments">
                        <xsl:variable name="tokenizedAttachments" select="tokenize($cXMLAttachments, $attachSeparator)"/>
                        <xsl:for-each select="$tokenizedAttachments">
                           <xsl:if test="normalize-space(.) != ''">
                              <Attachment>
                                 <URL>
                                    <xsl:value-of select="."/>
                                 </URL>
                              </Attachment>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:if>
                  <!-- TermsOfDelivery -->
                  <xsl:if test="M_DESADV/G_SG5/S_TOD/D_4215 != '' and M_DESADV/G_SG5/S_TOD/D_4055 != ''">
                     <xsl:variable name="TODCode" select="M_DESADV/G_SG5/S_TOD/D_4055"/>
                     <xsl:variable name="SPMCode" select="M_DESADV/G_SG5/S_TOD/D_4215"/>
                     <xsl:variable name="TTCode" select="M_DESADV/G_SG5/S_TOD/C_C100/D_4053"/>
                     <xsl:if test="$lookups/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[EANCOMCode = $TODCode]/CXMLCode != '' and $lookups/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[EANCOMCode = $SPMCode]/CXMLCode != ''">
                        <xsl:element name="TermsOfDelivery">
                           <xsl:element name="TermsOfDeliveryCode">
                              <xsl:attribute name="value">
                                 <xsl:value-of select="$lookups/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[EANCOMCode = $TODCode]/CXMLCode"/>
                              </xsl:attribute>
                           </xsl:element>
                           <xsl:element name="ShippingPaymentMethod">
                              <xsl:attribute name="value">
                                 <xsl:value-of select="$lookups/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[EANCOMCode = $SPMCode]/CXMLCode"/>
                              </xsl:attribute>
                           </xsl:element>
                           <xsl:if test="$lookups/Lookups/TransportTermsCodes/TransportTermsCode[EANCOMCode = $TTCode]/CXMLCode != ''">
                              <xsl:element name="TransportTerms">
                                 <xsl:attribute name="value">
                                    <xsl:value-of select="$lookups/Lookups/TransportTermsCodes/TransportTermsCode[EANCOMCode = $TTCode]/CXMLCode"/>
                                 </xsl:attribute>
                              </xsl:element>
                           </xsl:if>
                           <xsl:for-each select="M_DESADV/G_SG2[S_NAD/D_3035 = 'DP']">
                              <xsl:apply-templates select=".">
                                 <xsl:with-param name="role" select="S_NAD/D_3035"/>
                                 <xsl:with-param name="buildAddressElement" select="'true'"/>
                              </xsl:apply-templates>
                           </xsl:for-each>
                           <xsl:if test="M_DESADV/G_SG5/S_TOD/C_C100/D_4052 != '' or M_DESADV/G_SG5/S_TOD/C_C100/D_4052_2 != ''">
                              <xsl:element name="Comments">
                                 <xsl:attribute name="xml:lang">en</xsl:attribute>
                                 <xsl:attribute name="type">
                                    <xsl:choose>
                                       <xsl:when test="$TODCode = '5'">Transport</xsl:when>
                                       <xsl:when test="$TODCode = '6'">TermsOfDelivery</xsl:when>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <xsl:value-of select="normalize-space(concat(M_DESADV/G_SG5/S_TOD/C_C100/D_4052, M_DESADV/G_SG5/S_TOD/C_C100/D_4052_2))"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </xsl:if>
                  <!-- TermsOfTransport -->
                  <xsl:for-each select="M_DESADV/G_SG8[S_EQD/D_8053 != '']">
                     <xsl:element name="TermsOfTransport">
                        <xsl:if test="S_SEL/D_9308 != ''">
                           <xsl:element name="SealID">
                              <xsl:value-of select="S_SEL/D_9308"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="S_SEL/C_C215/D_9303 != ''">
                           <xsl:element name="SealingPartyCode">
                              <xsl:value-of select="S_SEL/C_C215/D_9303"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="S_EQD/D_8053 != ''">
                           <xsl:element name="EquipmentIdentificationCode">
                              <xsl:value-of select="S_EQD/D_8053"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:for-each select="S_MEA[D_6311 = 'PD'][C_C174/D_6411 != ''][C_C174/D_6314 != '']">
                           <xsl:variable name="mCode" select="C_C502/D_6313"/>
                           <xsl:if test="$lookups/Lookups/MeasureCodes/MeasureCode[EANCOMCode = $mCode]/CXMLCode != ''">
                              <xsl:element name="Dimension">
                                 <xsl:attribute name="quantity">
                                    <xsl:value-of select="C_C174/D_6314"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="type">
                                    <xsl:value-of select="$lookups/Lookups/MeasureCodes/MeasureCode[EANCOMCode = $mCode]/CXMLCode"/>
                                 </xsl:attribute>
                                 <xsl:element name="UnitOfMeasure">
                                    <xsl:value-of select="C_C174/D_6411"/>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="S_EQD/C_C237/D_8260 != ''">
                           <xsl:element name="Extrinsic">
                              <xsl:attribute name="name">EquipmentID</xsl:attribute>
                              <xsl:value-of select="S_EQD/C_C237/D_8260"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:for-each>
                  <!-- PickUpDate -->
                  <xsl:if test="M_DESADV/S_DTM/C_C507[D_2005 = '200']/D_2380 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">PickUpDate</xsl:attribute>
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '200']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat">
                              <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '200']/D_2379"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <!-- DeliverySheduleID -->
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AAN']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">DeliverySheduleID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AAN']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- DeliveryNoteID -->
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">DeliveryNoteID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- InvoiceID -->
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">InvoiceID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- SupplierOrderID -->
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">SupplierOrderID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- totalOfPackages -->
                  <xsl:if test="M_DESADV/G_SG10[S_CPS/D_7164 = '1']/G_SG11/S_PAC/D_7224 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">totalOfPackages</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG10[S_CPS/D_7164 = '1']/G_SG11/S_PAC/D_7224"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- CustomerReferenceID -->
                  <xsl:if test="M_DESADV/G_SG10/S_RFF/C_C506[D_1153 = 'CR']/D_1154 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">CustomerReferenceID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- UltimateCustomerReferenceID -->
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">UltimateCustomerReferenceID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- Header IdReference -->
                  <xsl:for-each select="M_DESADV/G_SG1/S_RFF[C_C506/D_1153 = 'GN' or C_C506/D_1153 = 'AEU' or C_C506/D_1153 = 'DM']">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">
                           <xsl:choose>
                              <xsl:when test="C_C506/D_1153 = 'GN'">governmentNumber</xsl:when>
                              <xsl:when test="C_C506/D_1153 = 'AEU'">supplierReference</xsl:when>
                              <xsl:when test="C_C506/D_1153 = 'DM'">documentName</xsl:when>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="normalize-space(C_C506/D_1154)"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:for-each>
               </xsl:element>
               <!-- ShipControl -->
               <xsl:for-each select="M_DESADV/G_SG6[S_TDT/D_8051 = '20']">
                  <xsl:element name="ShipControl">
                     <xsl:element name="CarrierIdentifier">
                        <xsl:attribute name="domain">
                           <xsl:choose>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '3'">IATA</xsl:when>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '9'">EAN</xsl:when>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '91'">Assigned by seller or seller's agent</xsl:when>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '92'">Assigned by buyer or buyer's agent</xsl:when>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '182'">SCAC</xsl:when>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="S_TDT/C_C040/D_3127"/>
                     </xsl:element>
                     <xsl:if test="S_TDT/C_C040/D_3128 != ''">
                        <xsl:element name="CarrierIdentifier">
                           <xsl:attribute name="domain">companyName</xsl:attribute>
                           <xsl:value-of select="S_TDT/C_C040/D_3128"/>
                        </xsl:element>
                     </xsl:if>
                     <xsl:for-each select="G_SG7[S_LOC/D_3227 = '92']">
                        <xsl:element name="ShipmentIdentifier">
                           <xsl:if test="S_LOC/C_C517/D_3224 != ''">
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="S_LOC/C_C517/D_3224"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="S_LOC/C_C553/D_3232 != ''">
                              <xsl:attribute name="trackingURL">
                                 <xsl:value-of select="S_LOC/C_C553/D_3232"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:value-of select="S_LOC/C_C519/D_3222"/>
                        </xsl:element>
                     </xsl:for-each>
                     <xsl:variable name="routeCode" select="S_TDT/C_C220/D_8067"/>
                     <xsl:variable name="shipInstructions" select="concat(G_SG7/S_LOC[D_3227 = '22E']/C_C517/D_3224, G_SG7/S_LOC[D_3227 = '22E']/C_C519/D_3222, G_SG7/S_LOC[D_3227 = '22E']/C_C553/D_3232)"/>
                     <xsl:if test="$lookups/Lookups/TransportInformations/TransportInformation[EANCOMCode = $routeCode] or S_TDT/C_C401[D_8457 = 'ZZZ' and D_8459 = 'ZZZ']/D_7130 != '' or $shipInstructions != ''">
                        <xsl:element name="TransportInformation">
                           <xsl:if test="$lookups/Lookups/TransportInformations/TransportInformation[EANCOMCode = $routeCode]">
                              <xsl:element name="Route">
                                 <xsl:attribute name="method">
                                    <xsl:value-of select="$lookups/Lookups/TransportInformations/TransportInformation[EANCOMCode = $routeCode]/CXMLCode"/>
                                 </xsl:attribute>
                                 <!-- IG-3853 start -->
                                 <xsl:if test="S_TDT/C_C228/D_8178 != ''">
                                    <xsl:attribute name="means">
                                       <xsl:value-of select="S_TDT/C_C228/D_8178"/>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <!-- IG-3853 end -->
                                 <xsl:if test="G_SG7[S_LOC/D_3227 = '5']/S_DTM/C_C507[D_2005 = '194']/D_2380 != ''">
                                    <xsl:attribute name="startDate">
                                       <xsl:call-template name="convertToAribaDate">
                                          <xsl:with-param name="dateTime">
                                             <xsl:value-of select="(G_SG7[S_LOC/D_3227 = '5']/S_DTM/C_C507[D_2005 = '194']/D_2380)[1]"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="dateTimeFormat">
                                             <xsl:value-of select="(G_SG7[S_LOC/D_3227 = '5']/S_DTM/C_C507[D_2005 = '194']/D_2379)[1]"/>
                                          </xsl:with-param>
                                       </xsl:call-template>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:if test="G_SG7[S_LOC/D_3227 = '8']/S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
                                    <xsl:attribute name="endDate">
                                       <xsl:call-template name="convertToAribaDate">
                                          <xsl:with-param name="dateTime">
                                             <xsl:value-of select="(G_SG7[S_LOC/D_3227 = '8']/S_DTM/C_C507[D_2005 = '206']/D_2380)[1]"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="dateTimeFormat">
                                             <xsl:value-of select="(G_SG7[S_LOC/D_3227 = '8']/S_DTM/C_C507[D_2005 = '206']/D_2379)[1]"/>
                                          </xsl:with-param>
                                       </xsl:call-template>
                                    </xsl:attribute>
                                 </xsl:if>
                              </xsl:element>
                           </xsl:if>
                           <xsl:if test="S_TDT/C_C401[D_8457 = 'ZZZ' and D_8459 = 'ZZZ']/D_7130 != ''">
                              <xsl:element name="ShippingContractNumber">
                                 <xsl:value-of select="S_TDT/C_C401[D_8457 = 'ZZZ' and D_8459 = 'ZZZ']/D_7130"/>
                              </xsl:element>
                           </xsl:if>
                           <xsl:if test="$shipInstructions != ''">
                              <xsl:element name="ShippingInstructions">
                                 <xsl:element name="Description">
                                    <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                                    <xsl:value-of select="$shipInstructions"/>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:for-each>
               <!-- ShipNoticePortion -->
               <xsl:variable name="nonPOLineCount" select="count(M_DESADV/G_SG10/G_SG17[not(exists(G_SG18/S_RFF/C_C506[D_1153 = 'ON']/D_1154)) or G_SG18/S_RFF/C_C506[D_1153 = 'ON']/D_1154 = ''])"/>
               <xsl:choose>
                  <xsl:when test="(M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'ON']) or ($nonPOLineCount &gt; 0)">
                     <xsl:element name="ShipNoticePortion">
                        <xsl:element name="OrderReference">
                           <xsl:attribute name="orderID">
                              <xsl:value-of select="normalize-space(M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154)"/>
                           </xsl:attribute>
                           <xsl:if test="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
                              <xsl:attribute name="orderDate">
                                 <xsl:call-template name="convertToAribaDatePORef">
                                    <xsl:with-param name="dateTime">
                                       <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="dateTimeFormat">
                                       <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:element name="DocumentReference">
                              <xsl:attribute name="payloadID"/>
                           </xsl:element>
                        </xsl:element>
                        <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">
                           <xsl:element name="MasterAgreementIDInfo">
                              <xsl:attribute name="agreementID">
                                 <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1154"/>
                              </xsl:attribute>
                              <xsl:if test="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
                                 <xsl:attribute name="agreementDate">
                                    <xsl:call-template name="convertToAribaDatePORef">
                                       <xsl:with-param name="dateTime">
                                          <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
                                       </xsl:with-param>
                                       <xsl:with-param name="dateTimeFormat">
                                          <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:attribute name="agreementType">scheduling_agreement</xsl:attribute>
                           </xsl:element>
                        </xsl:if>
                        <xsl:for-each select="M_DESADV/G_SG10">
                           <xsl:apply-templates select="G_SG17" mode="SNItem"/>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:for-each-group select="M_DESADV//G_SG17" group-by="G_SG18/S_RFF/C_C506[D_1153 = 'ON']/D_1154">
                        <xsl:element name="ShipNoticePortion">
                           <xsl:element name="OrderReference">
                              <xsl:attribute name="orderID">
                                 <xsl:value-of select="(current-group()/G_SG18/S_RFF/C_C506[D_1153 = 'ON']/D_1154)[1]"/>
                              </xsl:attribute>
                              <xsl:attribute name="orderDate">
                                 <xsl:call-template name="convertToAribaDatePORef">
                                    <xsl:with-param name="dateTime">
                                       <xsl:value-of select="(current-group()/G_SG18[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380)[1]"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="dateTimeFormat">
                                       <xsl:value-of select="(current-group()/G_SG18[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379)[1]"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                              </xsl:attribute>
                              <xsl:element name="DocumentReference">
                                 <xsl:attribute name="payloadID"/>
                              </xsl:element>
                           </xsl:element>
                           <xsl:if test="current-group()/G_SG18/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">
                              <xsl:element name="MasterAgreementIDInfo">
                                 <xsl:attribute name="agreementID">
                                    <xsl:value-of select="(current-group()/G_SG18/S_RFF/C_C506[D_1153 = 'CT']/D_1154)[1]"/>
                                 </xsl:attribute>
                                 <xsl:if test="current-group()/G_SG18[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
                                    <xsl:attribute name="agreementDate">
                                       <xsl:call-template name="convertToAribaDatePORef">
                                          <xsl:with-param name="dateTime">
                                             <xsl:value-of select="(current-group()/G_SG18[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2380)[1]"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="dateTimeFormat">
                                             <xsl:value-of select="(current-group()/G_SG18[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2379)[1]"/>
                                          </xsl:with-param>
                                       </xsl:call-template>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:if test="(current-group()/G_SG18/S_RFF/C_C506[D_1153 = 'CT']/D_1156)[1] = '1'">
                                    <xsl:attribute name="agreementType">scheduling_agreement</xsl:attribute>
                                 </xsl:if>
                              </xsl:element>
                           </xsl:if>
                           <xsl:apply-templates select="current-group()" mode="SNItem"/>
                        </xsl:element>
                     </xsl:for-each-group>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:element>
         </xsl:element>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
