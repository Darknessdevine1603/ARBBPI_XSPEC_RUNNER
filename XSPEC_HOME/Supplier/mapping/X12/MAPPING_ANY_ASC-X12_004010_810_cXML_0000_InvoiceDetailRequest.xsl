<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:810:004010" exclude-result-prefixes="#all">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anSharedSecrete"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="cXMLAttachments"/>
   <xsl:param name="attachSeparator" select="'\|'"/>
   <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>
   <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
   <!--xsl:variable name="Lookup" select="document('../../lookups/X12/LOOKUP_ASC-X12_004010.xml')"/>
   <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/-->
   
   <!-- CG: IG-16765 - 1500 Extrinsics -->
   <xsl:variable name="mappingLookup">
      <xsl:call-template name="getLookupValues">
         <xsl:with-param name="cXMLDocType" select="'InvoiceDetailRequest'"/>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="useExtrinsicsLookup">
      <xsl:choose>
         <xsl:when test="$mappingLookup/MappingLookup/EnableStandardExtrinsics != ''">
            <xsl:value-of select="lower-case($mappingLookup/MappingLookup/EnableStandardExtrinsics)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'no'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   
   <xsl:template match="ns0:*">
      <xsl:variable name="invType">
         <xsl:choose>
            <xsl:when test="FunctionalGroup/M_810/S_BIG/D_640 = 'CN'">lineLevelCreditMemo</xsl:when>
            <xsl:when test="FunctionalGroup/M_810/S_BIG/D_640 = 'DC'">lineLevelDebitMemo</xsl:when>
            <xsl:when test="FunctionalGroup/M_810/S_BIG/D_640 = 'DI'">standard</xsl:when>
            <xsl:when test="FunctionalGroup/M_810/S_BIG/D_640 = 'CR'">creditMemo</xsl:when>
            <xsl:when test="FunctionalGroup/M_810/S_BIG/D_640 = 'DR'">debitMemo</xsl:when>
            <xsl:when test="FunctionalGroup/M_810/S_BIG/D_640 = 'FD'">standard</xsl:when>
            <xsl:otherwise>standard</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="HeaderPoRef">
         <xsl:choose>
            <xsl:when test="normalize-space(FunctionalGroup/M_810/S_BIG/D_324) != ''">yes</xsl:when>
            <xsl:when test="normalize-space(FunctionalGroup/M_810/S_BIG/D_324) = 'NONPO'"
               >yes</xsl:when>
            <xsl:when test="normalize-space(FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127) != ''"
               >yes</xsl:when>
            <xsl:when test="normalize-space(FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127) != ''"
               >yes</xsl:when>
            <xsl:when test="normalize-space(FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127) != ''"
               >yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="isCreditMemo">
         <xsl:choose>
            <xsl:when test="$invType = 'lineLevelCreditMemo'">yes</xsl:when>
            <xsl:when test="$invType = 'creditMemo'">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="isLinePriceAdjustment">
         <xsl:if
            test="(FunctionalGroup/M_810/S_BIG/D_640 = 'CN' or FunctionalGroup/M_810/S_BIG/D_640 = 'DC') and ((FunctionalGroup/M_810/G_IT1/S_CTP[D_687 = 'WS']/D_236)[1] = 'CHG')">
            <xsl:text>yes</xsl:text>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="headerCurr">
         <xsl:if
            test="FunctionalGroup/M_810/S_CUR/D_98_1 = 'BY' or FunctionalGroup/M_810/S_CUR/D_98_1 = 'SE'">
            <xsl:value-of select="FunctionalGroup/M_810/S_CUR/D_100_1"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="headerAltCurr">
         <xsl:if
            test="FunctionalGroup/M_810/S_CUR/D_98_2 = 'BY' or FunctionalGroup/M_810/S_CUR/D_98_2 = 'SE'">
            <xsl:value-of select="FunctionalGroup/M_810/S_CUR/D_100_2"/>
         </xsl:if>
      </xsl:variable>
      <xsl:element name="cXML">
         <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
         </xsl:attribute>
         <xsl:attribute name="timestamp">
            <xsl:call-template name="convertToAribaDate">
               <xsl:with-param name="Date">
                  <xsl:value-of
                     select="substring(replace(string(current-dateTime()), '-', ''), 1, 8)"/>
               </xsl:with-param>
               <xsl:with-param name="Time">
                  <xsl:value-of
                     select="substring(replace(replace(string(current-dateTime()), '-', ''), ':', ''), 10, 6)"
                  />
               </xsl:with-param>
            </xsl:call-template>
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
               <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = '06']/D_127 != ''">
                  <xsl:element name="Credential">
                     <xsl:attribute name="domain">SystemID</xsl:attribute>
                     <xsl:element name="Identity">
                        <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = '06']/D_127"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
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
            <xsl:element name="InvoiceDetailRequest">
               <xsl:element name="InvoiceDetailRequestHeader">
                  <xsl:attribute name="invoiceID">
                     <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_810/S_REF[D_128 = 'IV']/D_127 != ''">
                           <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'IV']/D_127"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="FunctionalGroup/M_810/S_BIG/D_76_1"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:if test="FunctionalGroup/M_810/S_BIG/D_306 = 'NA'">
                     <xsl:attribute name="isInformationOnly">yes</xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="purpose">
                     <xsl:value-of select="$invType"/>
                  </xsl:attribute>
                  <xsl:attribute name="operation">
                     <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_810/S_BIG/D_353 = 00">new</xsl:when>
                        <xsl:when test="FunctionalGroup/M_810/S_BIG/D_353 = 03">delete</xsl:when>
                        <xsl:otherwise>new</xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="invoiceDate">
                     <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_810/S_DTM[D_374 = '003']/D_373 != ''">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '003']/D_373"/>
                              </xsl:with-param>
                              <xsl:with-param name="Time">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '003']/D_337"/>
                              </xsl:with-param>
                              <xsl:with-param name="TimeCode">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '003']/D_623"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date">
                                 <xsl:value-of select="FunctionalGroup/M_810/S_BIG/D_373_1"/>
                              </xsl:with-param>
                              <xsl:with-param name="Time">120000</xsl:with-param>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="invoiceOrigin">supplier</xsl:attribute>
                  <xsl:element name="InvoiceDetailHeaderIndicator">
                     <xsl:choose>
                        <xsl:when
                           test="FunctionalGroup/M_810/S_BIG/D_640 = 'CR' or FunctionalGroup/M_810/S_BIG/D_640 = 'DR'">
                           <xsl:attribute name="isHeaderInvoice">yes</xsl:attribute>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:element>
                  <xsl:element name="InvoiceDetailLineIndicator">
                     <xsl:if
                        test="FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610 != ''">
                        <xsl:attribute name="isTaxInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if
                        test="FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610 != ''">
                        <xsl:attribute name="isSpecialHandlingInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if
                        test="FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 != ''">
                        <xsl:attribute name="isShippingInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if
                        test="FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 != ''">
                        <xsl:attribute name="isDiscountInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if
                        test="FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_248 = 'N' and D_1300 = 'B840']/D_610 != ''">
                        <xsl:attribute name="isAccountingInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if test="$isLinePriceAdjustment = 'yes'">
                        <xsl:attribute name="isPriceAdjustmentInLine">yes</xsl:attribute>
                     </xsl:if>
                     <xsl:if
                        test="FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 != ''">
                        <xsl:attribute name="isDiscountInLine">yes</xsl:attribute>
                     </xsl:if>
                  </xsl:element>
                  <!-- InvoicePartner -->
                  <xsl:for-each
                     select="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 != 'SF' and S_N1/D_98_1 != 'ST' and S_N1/D_98_1 != 'CA']">
                     <xsl:variable name="role">
                        <xsl:value-of select="S_N1/D_98_1"/>
                     </xsl:variable>
                     <xsl:if test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
                        <xsl:element name="InvoicePartner">
                           <xsl:call-template name="createContact">
                              <xsl:with-param name="contact" select="."/>
                           </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- DocumentReference -->
                  <xsl:if
                     test="FunctionalGroup/M_810/S_REF[D_128 = 'F8' and D_127 = 'payloadID']/D_352">
                     <xsl:element name="DocumentReference">
                        <xsl:attribute name="payloadID">
                           <xsl:for-each
                              select="FunctionalGroup/M_810/S_REF[D_128 = 'F8' and D_127 = 'payloadID']">
                              <xsl:value-of select="D_352"/>
                           </xsl:for-each>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- InvoiceIDInfo -->
                  <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'I5']/D_127 != ''">
                     <xsl:element name="InvoiceIDInfo">
                        <xsl:attribute name="invoiceID">
                           <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'I5']/D_127"/>
                        </xsl:attribute>
                        <xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '922']/D_373 != ''">
                           <xsl:attribute name="invoiceDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="Date">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '922']/D_373"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="Time">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '922']/D_337"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="TimeCode">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '922']/D_623"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
                  <!--PaymentProposalIDInfo-->
                  <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = '4N']/D_127 != ''">
                     <xsl:element name="PaymentProposalIDInfo">
                        <xsl:attribute name="paymentProposalID">
                           <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = '4N']/D_127"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- InvoiceDetailShipping -->
                  <xsl:if
                     test="(FunctionalGroup/M_810/G_N1/S_N1/D_98_1 = 'CA' and FunctionalGroup/M_810/G_N1/S_N1/D_98_1 = 'SF' and FunctionalGroup/M_810/G_N1/S_N1/D_98_1 = 'ST') or (FunctionalGroup/M_810/G_N1/S_N1/D_98_1 = 'SF' and FunctionalGroup/M_810/G_N1/S_N1/D_98_1 = 'ST')">
                     <xsl:element name="InvoiceDetailShipping">
                        <xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '011']/D_373 != ''">
                           <xsl:attribute name="shippingDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="Date">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '011']/D_373"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="Time">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '011']/D_337"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="TimeCode">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '011']/D_623"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if
                           test="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST']">
                           <xsl:choose>
                              <xsl:when
                                 test="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'SF'] and FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'ST']">
                                 <xsl:for-each
                                    select="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST']">
                                    <xsl:call-template name="createContact">
                                       <xsl:with-param name="contact" select="."/>
                                    </xsl:call-template>
                                 </xsl:for-each>
                              </xsl:when>
                              <xsl:when test="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'SF']">
                                 <xsl:call-template name="createContact">
                                    <xsl:with-param name="contact"
                                       select="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'SF']"/>
                                 </xsl:call-template>
                                 <xsl:element name="Contact">
                                    <xsl:attribute name="role">shipTo</xsl:attribute>
                                    <xsl:element name="Name">
                                       <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:when>
                              <xsl:when test="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'ST']">
                                 <xsl:call-template name="createContact">
                                    <xsl:with-param name="contact"
                                       select="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'ST']"/>
                                 </xsl:call-template>
                                 <xsl:element name="Contact">
                                    <xsl:attribute name="role">shipFrom</xsl:attribute>
                                    <xsl:element name="Name">
                                       <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:when>

                           </xsl:choose>
                        </xsl:if>
                        <xsl:if test="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'CA']">
                           <xsl:call-template name="createContact">
                              <xsl:with-param name="contact"
                                 select="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'CA']"/>
                           </xsl:call-template>
                        </xsl:if>

                        <xsl:if
                           test="(FunctionalGroup/M_810/G_N1/S_N1/D_98_1 = 'CA' and FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'SF'][S_REF/D_128 = 'SI'])">
                           <xsl:for-each select="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'CA']">
                              <xsl:element name="CarrierIdentifier">
                                 <xsl:attribute name="domain">companyName</xsl:attribute>
                                 <xsl:value-of select="S_N1/D_93"/>
                              </xsl:element>
                              <xsl:for-each select="S_REF[D_128 = 'CN']">
                                 <xsl:element name="CarrierIdentifier">
                                    <xsl:attribute name="domain">
                                       <xsl:choose>
                                          <xsl:when test="D_127 = '1'">DUNS</xsl:when>
                                          <xsl:when test="D_127 = '2'">SCAC</xsl:when>
                                          <xsl:when test="D_127 = '4'">IATA</xsl:when>
                                          <xsl:when test="D_127 = '9'">DUNS+4</xsl:when>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="D_352"/>
                                 </xsl:element>
                              </xsl:for-each>
                           </xsl:for-each>
                           <xsl:for-each select="FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'SF']">
                              <xsl:for-each select="S_REF[D_128 = 'SI']">
                                 <xsl:element name="ShipmentIdentifier">
                                    <xsl:if test="D_352 != ''">
                                       <xsl:attribute name="trackingNumberDate">
                                          <xsl:value-of select="D_352"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="D_127"/>
                                 </xsl:element>
                              </xsl:for-each>
                           </xsl:for-each>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
                  <!-- ShipNoticeIDInfo -->
                  <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'MA']/D_127 != ''">
                     <xsl:element name="ShipNoticeIDInfo">
                        <xsl:attribute name="shipNoticeID">
                           <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'MA']/D_127"/>
                        </xsl:attribute>
                        <xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '111']/D_373 != ''">
                           <xsl:attribute name="shipNoticeDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="Date">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '111']/D_373"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="Time">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '111']/D_337"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="TimeCode">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_810/S_DTM[D_374 = '111']/D_623"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'PK']/D_127 != ''">
                           <xsl:element name="IdReference">
                              <xsl:attribute name="domain">packListID</xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_REF[D_128 = 'PK']/D_127"/>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'BM']/D_127 != ''">
                           <xsl:element name="IdReference">
                              <xsl:attribute name="domain">freightBillID</xsl:attribute>
                              <xsl:attribute name="identifier">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_REF[D_128 = 'BM']/D_127"/>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
                  <!-- InvoiceDetailPaymentTerm -->
                  <xsl:for-each select="FunctionalGroup/M_810/S_ITD">
                     <xsl:if test="(D_338 != '' or D_362 != '') and D_351 != ''">
                        <xsl:element name="PaymentTerm">
                           <xsl:attribute name="payInNumberOfDays">
                              <xsl:value-of select="D_351"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="D_338 != ''">
                                 <xsl:element name="Discount">
                                    <xsl:element name="DiscountPercent">
                                       <xsl:attribute name="percent">
                                          <xsl:value-of select="D_338"/>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:when>
                              <xsl:when test="D_362 != ''">
                                 <xsl:element name="Discount">
                                    <xsl:element name="DiscountAmount">
                                       <xsl:element name="Money">
                                          <xsl:attribute name="currency">
                                             <xsl:value-of select="$headerCurr"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="D_362"/>
                                       </xsl:element>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:when>
                           </xsl:choose>
                           <xsl:if test="D_370 != ''">
                              <xsl:element name="Extrinsic">
                                 <xsl:attribute name="name">discountDueDate</xsl:attribute>
                                 <xsl:value-of select="D_370"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                     <xsl:if test="D_386 != '' and (D_954 != '' or D_389 != '')">
                        <xsl:element name="PaymentTerm">
                           <xsl:attribute name="payInNumberOfDays">
                              <xsl:value-of select="D_386"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="D_954 != ''">
                                 <xsl:element name="Discount">
                                    <xsl:element name="DiscountPercent">
                                       <xsl:attribute name="percent">
                                          <xsl:choose>
                                             <xsl:when test="D_954 = 0">0</xsl:when>
                                             <xsl:otherwise>
                                                <xsl:value-of select="concat('-', D_954)"/>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:when>
                              <xsl:when test="D_389 != ''">
                                 <xsl:element name="Discount">
                                    <xsl:element name="DiscountAmount">
                                       <xsl:element name="Money">
                                          <xsl:attribute name="currency">
                                             <xsl:value-of select="$headerCurr"/>
                                          </xsl:attribute>
                                          <xsl:choose>
                                             <xsl:when test="D_389 = 0">0</xsl:when>
                                             <xsl:otherwise>
                                                <xsl:value-of select="concat('-', D_389)"/>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:element>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:when>
                           </xsl:choose>
                           <xsl:if test="D_370 != ''">
                              <xsl:element name="Extrinsic">
                                 <xsl:attribute name="name">discountDueDate</xsl:attribute>
                                 <xsl:value-of select="D_370"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- Period -->
                  <xsl:if
                     test="FunctionalGroup/M_810/S_DTM[D_374 = '186']/D_373 != '' and FunctionalGroup/M_810/S_DTM[D_374 = '187']/D_373 != ''">
                     <xsl:element name="Period">
                        <xsl:attribute name="startDate">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '186']/D_373"/>
                              </xsl:with-param>
                              <xsl:with-param name="Time">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '186']/D_337"/>
                              </xsl:with-param>
                              <xsl:with-param name="TimeCode">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '186']/D_623"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="endDate">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '187']/D_373"/>
                              </xsl:with-param>
                              <xsl:with-param name="Time">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '187']/D_337"/>
                              </xsl:with-param>
                              <xsl:with-param name="TimeCode">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/S_DTM[D_374 = '187']/D_623"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- Comments -->
                  <xsl:if
                     test="FunctionalGroup/M_810/G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'Comments']/S_MSG/D_933 != '' or $cXMLAttachments != ''">
                     <xsl:element name="Comments">
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when test="FunctionalGroup/M_810/G_N9/S_N9/D_127 != ''">
                                 <xsl:value-of select="FunctionalGroup/M_810/G_N9/S_N9/D_127"/>
                              </xsl:when>
                              <xsl:otherwise>en</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:for-each
                           select="FunctionalGroup/M_810/G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'Comments']">
                           <xsl:for-each select="S_MSG">
                              <xsl:choose>
                                 <xsl:when test="D_934 = 'LC'">
                                    <xsl:value-of select="D_933"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="concat(nl, D_933)"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:for-each>
                        </xsl:for-each>
                        <!--xsl:copy-of select="$cXMLAttachments"/-->
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
                     </xsl:element>
                  </xsl:if>
                  <!--References-IG1461-->
                  <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'CR']/D_127 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">
                           <xsl:text>customerReferenceID</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'CR']/D_127"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- Header Extrinsics -->
                  <xsl:element name="Extrinsic">
                     <xsl:attribute name="name">invoiceSubmissionMethod</xsl:attribute>
                     <xsl:value-of select="'CIG_X12'"/>
                  </xsl:element>
                  <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'KK']/D_127 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:text>DeliveryNoteNumber</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'KK']/D_127"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'EU']/D_127 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:text>ultimateCustomerReferenceID</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'EU']/D_127"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- CG 1/4/2017 -->
                  <xsl:if
                     test="normalize-space((FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_559 = 'AB']/D_1301)[1]) != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:text>specialProcessingCode</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of
                           select="normalize-space((FunctionalGroup/M_810/G_IT1/G_SAC/S_SAC[D_559 = 'AB']/D_1301)[1])"
                        />
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="FunctionalGroup/M_810/S_CTT/D_354 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:text>totalNumberOfLineItems</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="FunctionalGroup/M_810/S_CTT/D_354"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:for-each
                     select="FunctionalGroup/M_810/G_N1/S_REF[D_128 = 'AEC'][D_352 != '']">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:text>supplierCommercialIdentifier</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="D_352"/>
                     </xsl:element>
                  </xsl:for-each>
                  <!-- Extrinsics -->
                  <xsl:for-each select="FunctionalGroup/M_810/S_REF[D_128 = 'ZZ']">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:value-of select="./D_127"/>
                        </xsl:attribute>
                        <xsl:value-of select="D_352"/>
                     </xsl:element>
                  </xsl:for-each>
                  <!-- Default extrinsics -->
                  <xsl:element name="Extrinsic">
                     <xsl:attribute name="name">
                        <xsl:text>invoiceSourceDocument</xsl:text>
                     </xsl:attribute>
                     <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_810/S_BIG/D_324 = 'NONPO'">
                           <xsl:text>ExternalPurchaseOrder</xsl:text>
                        </xsl:when>
                        <xsl:when
                           test="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127 != '' or FunctionalGroup/M_810/S_BIG/D_324 != ''">
                           <xsl:text>PurchaseOrder</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>NoOrderInformation</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
                  <!-- IG-1422-->
                  <xsl:if test="FunctionalGroup/M_810/S_ITD/D_107 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:text>paymentMethod</xsl:text>
                        </xsl:attribute>
                        <xsl:variable name="paymentX12Code"
                           select="FunctionalGroup/M_810/S_ITD/D_107"/>
                        <xsl:choose>
                           <xsl:when
                              test="$Lookup/Lookups/ITDPaymentMethodCodes/ITDPaymentMethodCode[X12Code = $paymentX12Code]/CXMLCode != ''">
                              <xsl:value-of
                                 select="$Lookup/Lookups/ITDPaymentMethodCodes/ITDPaymentMethodCode[X12Code = $paymentX12Code]/CXMLCode"
                              />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$paymentX12Code"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:element>
                  </xsl:if>
                  <!-- IG-5742 -->
                  <xsl:if test="//FunctionalGroup/M_810/S_NTE[D_363 = 'REG']/D_352 != ''">
                     <xsl:call-template name="LegalStatus">
                        <xsl:with-param name="REG"
                           select="//FunctionalGroup/M_810/S_NTE[D_363 = 'REG']/D_352"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="//FunctionalGroup/M_810/S_NTE[D_363 = 'CBH']/D_352 != ''">
                     <xsl:call-template name="LegalCapital">
                        <xsl:with-param name="CBH"
                           select="//FunctionalGroup/M_810/S_NTE[D_363 = 'CBH']/D_352"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if
                     test="//FunctionalGroup/M_810/S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_280 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:value-of select="'taxExchangeRate'"/>
                        </xsl:attribute>
                        <xsl:value-of
                           select="//FunctionalGroup/M_810/S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_280"
                        />
                     </xsl:element>
                  </xsl:if>
                  <!-- CG: IG-16765 - 1500 Extrinsics -->
                  <xsl:if test="$useExtrinsicsLookup = 'yes'">
                     <xsl:for-each select="FunctionalGroup/M_810/S_REF[D_128 != 'ZZ']">
                        <xsl:variable name="refQualVal" select="D_128"/>
                        <xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/InvHeaderEx))][1]/CXMLCode"/>
                        <xsl:if test="$extNameL != ''">
                           <xsl:element name="Extrinsic">
                              <xsl:attribute name="name">
                                 <xsl:value-of select="$extNameL"/>
                              </xsl:attribute>
                              <xsl:value-of select="concat(D_127,D_352)"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:if>
               </xsl:element>
               <xsl:choose>
                  <!-- Header Invoice -->
                  <xsl:when
                     test="FunctionalGroup/M_810/S_BIG/D_640 = 'CR' or FunctionalGroup/M_810/S_BIG/D_640 = 'DR'">
                     <xsl:for-each select="FunctionalGroup/M_810/G_IT1">
                        <xsl:variable name="lin">
                           <xsl:call-template name="createLIN">
                              <xsl:with-param name="LIN" select="S_IT1"/>
                           </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="$lin/lin/element[@name = 'PO']/@value != ''">
                           <xsl:variable name="lineCurr">
                              <xsl:choose>
                                 <xsl:when
                                    test="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1 != ''">
                                    <xsl:value-of select="S_CUR/D_100_1"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$headerCurr"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:variable name="lineAltCurr">
                              <xsl:choose>
                                 <xsl:when
                                    test="S_CUR[D_98_2 = 'BY' or D_98_2 = 'SE']/D_100_2 != ''">
                                    <xsl:value-of select="S_CUR/D_100_2"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$headerAltCurr"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:element name="InvoiceDetailHeaderOrder">
                              <xsl:element name="InvoiceDetailOrderInfo">
                                 <!-- IG-1925 -->
                                 <xsl:choose>
                                    <!-- NONPO Case-->
                                    <xsl:when test="FunctionalGroup/M_810/S_BIG/D_324 = 'NONPO'">
                                       <xsl:if test="S_REF[D_128 = 'AH']/D_127 != ''">
                                          <!-- MasterAgreementID -->
                                          <xsl:element name="MasterAgreementIDInfo">
                                             <xsl:if test="S_REF[D_128 = 'AH']/D_127 != ''">
                                                <xsl:attribute name="agreementID">
                                                  <xsl:value-of select="S_REF[D_128 = 'AH']/D_127"/>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if test="S_DTM[D_374 = 'LEA']/D_373 != ''">
                                                <xsl:attribute name="agreementDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = 'LEA']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = 'LEA']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = 'LEA']/D_623"/>
                                                  </xsl:call-template>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if test="S_REF[D_128 = 'AH']/D_352 = '1'">
                                                <xsl:attribute name="agreementType">
                                                  <xsl:text>scheduling_agreement</xsl:text>
                                                </xsl:attribute>
                                             </xsl:if>
                                          </xsl:element>
                                       </xsl:if>
                                       <xsl:if test="$lin/lin/element[@name = 'PO']/@value != ''">
                                          <!-- OrderID -->
                                          <xsl:element name="OrderIDInfo">
                                             <xsl:attribute name="orderID">
                                                <xsl:value-of
                                                  select="$lin/lin/element[@name = 'PO']/@value"/>
                                             </xsl:attribute>
                                             <xsl:if test="S_DTM[D_374 = '004']/D_373 != ''">
                                                <xsl:variable name="chkOrderDate">
                                                  <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = '004']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = '004']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = '004']/D_623"/>
                                                  </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:if test="$chkOrderDate != ''">
                                                  <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                  </xsl:attribute>
                                                </xsl:if>
                                             </xsl:if>
                                          </xsl:element>
                                       </xsl:if>
                                       <xsl:if
                                          test="($lin/lin/element[@name = 'VO']/@value != '') or (S_REF[D_128 = 'VN']/D_127 != '')">
                                          <!-- SupplierOrderID -->
                                          <xsl:element name="SupplierOrderInfo">
                                             <xsl:choose>
                                                <xsl:when
                                                  test="$lin/lin/element[@name = 'VO']/@value != ''">
                                                  <xsl:attribute name="orderID">
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'VO']/@value"/>
                                                  </xsl:attribute>
                                                </xsl:when>
                                                <xsl:when test="S_REF[D_128 = 'VN']/D_127 != ''">
                                                  <xsl:attribute name="orderID">
                                                  <xsl:value-of select="S_REF[D_128 = 'VN']/D_127"/>
                                                  </xsl:attribute>
                                                </xsl:when>
                                             </xsl:choose>
                                             <xsl:if test="S_DTM[D_374 = '008']/D_373 != ''">
                                                <xsl:variable name="chkOrderDate">
                                                  <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = '008']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = '008']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = '008']/D_623"/>
                                                  </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:if test="$chkOrderDate != ''">
                                                  <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                  </xsl:attribute>
                                                </xsl:if>
                                             </xsl:if>
                                          </xsl:element>
                                       </xsl:if>
                                    </xsl:when>
                                    <!-- PO Reference Case-->
                                    <xsl:when
                                       test="($lin/lin/element[@name = 'PO']/@value != '') or (S_REF[D_128 = 'AH']/D_127 != '') or (FunctionalGroup/M_810/S_BIG/D_324 != '')">
                                       <xsl:variable name="tempPONumber">
                                          <xsl:choose>
                                             <xsl:when
                                                test="($lin/lin/element[@name = 'PO']/@value != '')">
                                                <xsl:value-of
                                                  select="$lin/lin/element[@name = 'PO']/@value"/>
                                             </xsl:when>
                                             <xsl:when
                                                test="(FunctionalGroup/M_810/S_BIG/D_324 != '')">
                                                <xsl:value-of
                                                  select="FunctionalGroup/M_810/S_BIG/D_324"/>
                                             </xsl:when>
                                          </xsl:choose>
                                       </xsl:variable>
                                       <xsl:if test="$tempPONumber != ''">
                                          <!-- OrderID -->
                                          <xsl:element name="OrderReference">
                                             <xsl:attribute name="orderID">
                                                <xsl:value-of select="$tempPONumber"/>
                                             </xsl:attribute>
                                             <xsl:if test="S_DTM[D_374 = '004']/D_373 != ''">
                                                <xsl:variable name="chkOrderDate">
                                                  <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = '004']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = '004']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = '004']/D_623"/>
                                                  </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:if test="$chkOrderDate != ''">
                                                  <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                  </xsl:attribute>
                                                </xsl:if>
                                             </xsl:if>
                                             <DocumentReference payloadID=""/>
                                          </xsl:element>
                                       </xsl:if>
                                       <xsl:if test="S_REF[D_128 = 'AH']/D_127 != ''">
                                          <!-- MasterAgreementID -->
                                          <xsl:element name="MasterAgreementReference">
                                             <xsl:if test="S_REF[D_128 = 'AH']/D_127 != ''">
                                                <xsl:attribute name="agreementID">
                                                  <xsl:value-of select="S_REF[D_128 = 'AH']/D_127"/>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if test="S_DTM[D_374 = 'LEA']/D_373 != ''">
                                                <xsl:attribute name="agreementDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = 'LEA']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = 'LEA']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = 'LEA']/D_623"/>
                                                  </xsl:call-template>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if test="S_REF[D_128 = 'AH']/D_352 = '1'">
                                                <xsl:attribute name="agreementType">
                                                  <xsl:text>scheduling_agreement</xsl:text>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <DocumentReference payloadID=""/>
                                          </xsl:element>
                                       </xsl:if>
                                       <xsl:if
                                          test="($lin/lin/element[@name = 'VO']/@value != '') or (S_REF[D_128 = 'VN']/D_127 != '')">
                                          <!-- SupplierOrderID -->
                                          <xsl:element name="SupplierOrderInfo">
                                             <xsl:choose>
                                                <xsl:when
                                                  test="$lin/lin/element[@name = 'VO']/@value != ''">
                                                  <xsl:attribute name="orderID">
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'VO']/@value"/>
                                                  </xsl:attribute>
                                                </xsl:when>
                                                <xsl:when test="S_REF[D_128 = 'VN']/D_127 != ''">
                                                  <xsl:attribute name="orderID">
                                                  <xsl:value-of select="S_REF[D_128 = 'VN']/D_127"/>
                                                  </xsl:attribute>
                                                </xsl:when>
                                             </xsl:choose>
                                             <xsl:if test="S_DTM[D_374 = '008']/D_373 != ''">
                                                <xsl:variable name="chkOrderDate">
                                                  <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = '008']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = '008']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = '008']/D_623"/>
                                                  </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:if test="$chkOrderDate != ''">
                                                  <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                  </xsl:attribute>
                                                </xsl:if>
                                             </xsl:if>
                                          </xsl:element>
                                       </xsl:if>
                                    </xsl:when>
                                    <!-- Supplier Order Case-->
                                    <xsl:when
                                       test="($lin/lin/element[@name = 'VO']/@value != '') or (S_REF[D_128 = 'VN']/D_127 != '')">
                                       <xsl:element name="SupplierOrderInfo">
                                          <xsl:choose>
                                             <xsl:when
                                                test="$lin/lin/element[@name = 'VO']/@value != ''">
                                                <xsl:attribute name="orderID">
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'VO']/@value"/>
                                                </xsl:attribute>
                                             </xsl:when>
                                             <xsl:when test="S_REF[D_128 = 'VN']/D_127 != ''">
                                                <xsl:attribute name="orderID">
                                                  <xsl:value-of select="S_REF[D_128 = 'VN']/D_127"/>
                                                </xsl:attribute>
                                             </xsl:when>
                                          </xsl:choose>
                                          <xsl:if test="S_DTM[D_374 = '008']/D_373 != ''">
                                             <xsl:variable name="chkOrderDate">
                                                <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = '008']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = '008']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = '008']/D_623"/>
                                                </xsl:call-template>
                                             </xsl:variable>
                                             <xsl:if test="$chkOrderDate != ''">
                                                <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                </xsl:attribute>
                                             </xsl:if>
                                          </xsl:if>
                                       </xsl:element>
                                    </xsl:when>
                                    <!-- Not any PO reference Case-->
                                    <xsl:otherwise>
                                       <!-- Empty OrderID -->
                                       <xsl:element name="OrderIDInfo">
                                          <xsl:attribute name="orderID">
                                             <xsl:value-of select="''"/>
                                          </xsl:attribute>
                                       </xsl:element>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!--											<xsl:if test="S_REF[D_128 = 'AH']/D_127!= '' or S_DTM[D_374 = 'LEA']/D_373!= ''">												<xsl:element name="MasterAgreementIDInfo">													<xsl:if test="S_REF[D_128 = 'AH']/D_127!= ''">														<xsl:attribute name="agreementID">															<xsl:value-of select="S_REF[D_128 = 'AH']/D_127"/>														</xsl:attribute>													</xsl:if>													<xsl:if test="S_DTM[D_374 = 'LEA']/D_373!= ''">														<xsl:attribute name="agreementDate">															<xsl:call-template name="convertToAribaDate">																<xsl:with-param name="Date" select="S_DTM[D_374 = 'LEA']/D_373"/>																<xsl:with-param name="Time" select="S_DTM[D_374 = 'LEA']/D_337"/>																<xsl:with-param name="TimeCode" select="S_DTM[D_374 = 'LEA']/D_623"/>															</xsl:call-template>														</xsl:attribute>													</xsl:if>													<xsl:if test="S_DTM[D_128 = 'AH']/D_352='yes'">														<xsl:attribute name="agreementType">															<xsl:text>scheduling_agreement</xsl:text>														</xsl:attribute>													</xsl:if>												</xsl:element>											</xsl:if>																						<xsl:if test="$lin/lin/element[@name='PO']/@value!=''">												<xsl:element name="OrderIDInfo">													<xsl:attribute name="orderID">														<xsl:value-of select="$lin/lin/element[@name='PO']/@value"/>													</xsl:attribute>													<xsl:if test="S_DTM[D_374 = '004']/D_373!= ''">														<xsl:variable name="chkOrderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="Date" select="S_DTM[D_374 = '004']/D_373"/>																<xsl:with-param name="Time" select="S_DTM[D_374 = '004']/D_337"/>																<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '004']/D_623"/>															</xsl:call-template>														</xsl:variable>														<xsl:if test="$chkOrderDate!=''">															<xsl:attribute name="orderDate">																<xsl:value-of select="$chkOrderDate"/>															</xsl:attribute>														</xsl:if>													</xsl:if>												</xsl:element>											</xsl:if>																						<xsl:if test="($lin/lin/element[@name='VO']/@value!='') or S_REF[D_128 = 'VN']/D_127!= '' or S_DTM[D_374 = '008']/D_373!= ''">												<xsl:element name="SupplierOrderInfo">													<xsl:choose>														<xsl:when test="$lin/lin/element[@name='VO']/@value!=''">															<xsl:attribute name="orderID">																<xsl:value-of select="$lin/lin/element[@name='VO']/@value"/>															</xsl:attribute>														</xsl:when>														<xsl:when test="S_REF[D_128 = 'VN']/D_127!= ''">															<xsl:attribute name="orderID">																<xsl:value-of select="S_REF[D_128 = 'VN']/D_127"/>															</xsl:attribute>														</xsl:when>													</xsl:choose>													<xsl:if test="S_DTM[D_374 = '008']/D_373!= ''">														<xsl:variable name="chkOrderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="Date" select="S_DTM[D_374 = '008']/D_373"/>																<xsl:with-param name="Time" select="S_DTM[D_374 = '008']/D_337"/>																<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '008']/D_623"/>															</xsl:call-template>														</xsl:variable>														<xsl:if test="$chkOrderDate!=''">															<xsl:attribute name="orderDate">																<xsl:value-of select="$chkOrderDate"/>															</xsl:attribute>														</xsl:if>													</xsl:if>												</xsl:element>											</xsl:if>										-->
                              </xsl:element>
                              <xsl:element name="InvoiceDetailOrderSummary">
                                 <xsl:attribute name="invoiceLineNumber">
                                    <xsl:value-of select="S_REF[D_128 = 'FJ']/D_127"/>
                                 </xsl:attribute>
                                 <!-- inspectionDate -->
                                 <xsl:if test="S_DTM[D_374 = '517']/D_373 != ''">
                                    <xsl:attribute name="inspectionDate">
                                       <xsl:call-template name="convertToAribaDate">
                                          <xsl:with-param name="Date"
                                             select="S_DTM[D_374 = '517']/D_373"/>
                                          <xsl:with-param name="Time"
                                             select="S_DTM[D_374 = '517']/D_337"/>
                                          <xsl:with-param name="TimeCode"
                                             select="S_DTM[D_374 = '517']/D_623"/>
                                       </xsl:call-template>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:element name="SubtotalAmount">
                                    <xsl:choose>
                                       <xsl:when test="S_PAM[D_522 = '1']/D_782 != ''">
                                          <xsl:call-template name="createMoney">
                                             <xsl:with-param name="money"
                                                select="S_PAM[D_522 = '1']/D_782"/>
                                             <xsl:with-param name="Curr" select="$lineCurr"/>
                                             <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                             <xsl:with-param name="isCreditMemo"
                                                select="$isCreditMemo"/>
                                          </xsl:call-template>
                                       </xsl:when>
                                       <xsl:when test="S_IT1/D_212 != ''">
                                          <xsl:call-template name="createMoney">
                                             <xsl:with-param name="money" select="S_IT1/D_212"/>
                                             <xsl:with-param name="Curr" select="$lineCurr"/>
                                             <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                             <xsl:with-param name="isCreditMemo"
                                                select="$isCreditMemo"/>
                                          </xsl:call-template>
                                       </xsl:when>
                                    </xsl:choose>
                                 </xsl:element>
                                 <!-- Period -->
                                 <xsl:if
                                    test="S_DTM[D_374 = '150']/D_373 != '' and S_DTM[D_374 = '151']/D_373 != ''">
                                    <xsl:element name="Period">
                                       <xsl:attribute name="startDate">
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="Date"
                                                select="S_DTM[D_374 = '150']/D_373"/>
                                             <xsl:with-param name="Time"
                                                select="S_DTM[D_374 = '150']/D_337"/>
                                             <xsl:with-param name="TimeCode"
                                                select="S_DTM[D_374 = '150']/D_623"/>
                                          </xsl:call-template>
                                       </xsl:attribute>
                                       <xsl:attribute name="endDate">
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="Date"
                                                select="S_DTM[D_374 = '151']/D_373"/>
                                             <xsl:with-param name="Time"
                                                select="S_DTM[D_374 = '151']/D_337"/>
                                             <xsl:with-param name="TimeCode"
                                                select="S_DTM[D_374 = '151']/D_623"/>
                                          </xsl:call-template>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:if>
                                 <!-- Tax -->
                                 <xsl:element name="Tax">
                                    <xsl:call-template name="createMoney">
                                       <xsl:with-param name="Curr" select="$headerCurr"/>
                                       <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                                       <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                                       <!--<xsl:with-param name="money" select="(G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610 div 100)"/>-->
                                       <xsl:with-param name="money"
                                          select="xs:decimal(G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610) div xs:decimal(100)"/>
                                       <xsl:with-param name="altAmt"
                                          select="normalize-space(G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_127)"
                                       />
                                    </xsl:call-template>
                                    <xsl:element name="Description">
                                       <xsl:attribute name="xml:lang">
                                          <xsl:choose>
                                             <xsl:when
                                                test="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_819 != ''">
                                                <xsl:value-of
                                                  select="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_819"
                                                />
                                             </xsl:when>
                                             <xsl:otherwise>en</xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:attribute>
                                       <xsl:if
                                          test="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_352 != ''">
                                          <xsl:value-of
                                             select="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_352"
                                          />
                                       </xsl:if>
                                    </xsl:element>
                                    <xsl:choose>
                                       <!-- CG: IG-23185 -->
                                       <xsl:when test="$headerAltCurr = ''">
                                          <xsl:for-each select="FunctionalGroup/M_810/G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI">
                                             <xsl:call-template name="mapTaxDetail">
                                                <xsl:with-param name="mainCurrency" select="$headerCurr"/>
                                                <xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
                                                <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                                <xsl:with-param name="ignoreTPDate" select="'true'"/>
                                             </xsl:call-template>
                                          </xsl:for-each>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:for-each-group
                                             select="FunctionalGroup/M_810/G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI"
                                             group-by="D_963">
                                             <xsl:choose>
                                                <xsl:when test="count(current-group()) &gt; 1">
                                                   <xsl:for-each select="current-group()[position() mod 2 = 1]">
                                                      <xsl:variable name="tc" select="D_963"/>
                                                      <xsl:variable name="altAmount" select="following-sibling::S_TXI[D_963 = $tc][1]/D_782"/>
                                                      <xsl:call-template name="mapTaxDetail">
                                                         <xsl:with-param name="mainCurrency" select="$headerCurr"/>
                                                         <xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
                                                         <xsl:with-param name="alternateAmount" select="$altAmount"/>
                                                         <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                                         <xsl:with-param name="ignoreTPDate" select="'true'"/>
                                                      </xsl:call-template>
                                                   </xsl:for-each>   
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:call-template name="mapTaxDetail">
                                                      <xsl:with-param name="mainCurrency" select="$headerCurr"/>
                                                      <xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
                                                      <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                                      <xsl:with-param name="ignoreTPDate" select="'true'"/>
                                                   </xsl:call-template>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:for-each-group>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:element>
                                 <!-- InvoiceDetailLineSpecialHandling-->
                                 <xsl:if
                                    test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610 != ''">
                                    <xsl:element name="InvoiceDetailLineSpecialHandling">
                                       <xsl:if
                                          test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_352 != ''">
                                          <xsl:element name="Description">
                                             <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_819 != ''">
                                                  <xsl:value-of
                                                  select="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_819"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>en</xsl:otherwise>
                                                </xsl:choose>
                                             </xsl:attribute>
                                             <xsl:value-of
                                                select="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_352"
                                             />
                                          </xsl:element>
                                       </xsl:if>
                                       <xsl:call-template name="createMoney">
                                          <!--<xsl:with-param name="money" select="(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610 div 100)"/>-->
                                          <xsl:with-param name="money"
                                             select="xs:decimal(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610) div xs:decimal(100)"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:if>
                                 <!-- InvoiceDetailLineShipping -->
                                 <xsl:if
                                    test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 != '' and G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST' or S_N1/D_98_1 = 'CA']">
                                    <xsl:element name="InvoiceDetailLineShipping">
                                       <xsl:element name="InvoiceDetailShipping">
                                          <xsl:if test="S_DTM[D_374 = '011']/D_373 != ''">
                                             <xsl:attribute name="shippingDate">
                                                <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date"
                                                  select="S_DTM[D_374 = '011']/D_373"/>
                                                  <xsl:with-param name="Time"
                                                  select="S_DTM[D_374 = '011']/D_337"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="S_DTM[D_374 = '011']/D_623"/>
                                                </xsl:call-template>
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:if
                                             test="G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST']">
                                             <xsl:choose>
                                                <xsl:when
                                                  test="G_N1[S_N1/D_98_1 = 'SF'] and G_N1[S_N1/D_98_1 = 'ST']">
                                                  <xsl:for-each
                                                  select="G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST']">
                                                  <xsl:call-template name="createContact">
                                                  <xsl:with-param name="contact" select="."/>
                                                  </xsl:call-template>
                                                  </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="G_N1[S_N1/D_98_1 = 'SF']">
                                                  <xsl:call-template name="createContact">
                                                  <xsl:with-param name="contact"
                                                  select="G_N1[S_N1/D_98_1 = 'SF']"/>
                                                  </xsl:call-template>
                                                  <xsl:element name="Contact">
                                                  <xsl:attribute name="role">shipTo</xsl:attribute>
                                                  <xsl:element name="Name">
                                                  <xsl:attribute name="xml:lang">en</xsl:attribute>
                                                  </xsl:element>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when test="G_N1[S_N1/D_98_1 = 'ST']">
                                                  <xsl:call-template name="createContact">
                                                  <xsl:with-param name="contact"
                                                  select="G_N1[S_N1/D_98_1 = 'ST']"/>
                                                  </xsl:call-template>
                                                  <xsl:element name="Contact">
                                                  <xsl:attribute name="role"
                                                  >shipFrom</xsl:attribute>
                                                  <xsl:element name="Name">
                                                  <xsl:attribute name="xml:lang">en</xsl:attribute>
                                                  </xsl:element>
                                                  </xsl:element>
                                                </xsl:when>
                                             </xsl:choose>
                                          </xsl:if>
                                          <xsl:if test="G_N1[S_N1/D_98_1 = 'CA']">
                                             <xsl:call-template name="createContact">
                                                <xsl:with-param name="contact"
                                                  select="G_N1[S_N1/D_98_1 = 'CA']"/>
                                             </xsl:call-template>
                                          </xsl:if>
                                          <xsl:if
                                             test="(G_N1/S_N1/D_98_1 = 'CA' and G_N1[S_N1/D_98_1 = 'SF'][S_REF/D_128 = 'SI'])">

                                             <xsl:for-each select="G_N1[S_N1/D_98_1 = 'CA']">
                                                <xsl:element name="CarrierIdentifier">
                                                  <xsl:attribute name="domain"
                                                  >companyName</xsl:attribute>
                                                  <xsl:value-of select="S_N1/D_93"/>
                                                </xsl:element>
                                                <xsl:for-each select="S_REF[D_128 = 'CN']">
                                                  <xsl:element name="CarrierIdentifier">
                                                  <xsl:attribute name="domain">
                                                  <xsl:choose>
                                                  <xsl:when test="D_127 = '1'">DUNS</xsl:when>
                                                  <xsl:when test="D_127 = '2'">SCAC</xsl:when>
                                                  <xsl:when test="D_127 = '4'">IATA</xsl:when>
                                                  <xsl:when test="D_127 = '9'">DUNS+4</xsl:when>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="D_352"/>
                                                  </xsl:element>
                                                </xsl:for-each>
                                             </xsl:for-each>
                                             <xsl:for-each select="G_N1[S_N1/D_98_1 = 'SF']">
                                                <xsl:for-each select="S_REF[D_128 = 'SI']">
                                                  <xsl:element name="ShipmentIdentifier">
                                                  <xsl:if test="D_352 != ''">
                                                  <xsl:attribute name="trackingNumberDate">
                                                  <xsl:value-of select="D_352"/>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:value-of select="D_127"/>
                                                  </xsl:element>
                                                </xsl:for-each>
                                             </xsl:for-each>
                                          </xsl:if>
                                       </xsl:element>
                                       <xsl:call-template name="createMoney">
                                          <!-- <xsl:with-param name="money" select="(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 div 100)"/>-->
                                          <xsl:with-param name="money"
                                             select="xs:decimal(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610) div xs:decimal(100)"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:if>
                                 <!-- GrossAmount -->
                                 <xsl:if test="S_PAM[D_522 = 'KK']/D_782 != ''">
                                    <xsl:element name="GrossAmount">
                                       <xsl:call-template name="createMoney">
                                          <xsl:with-param name="money"
                                             select="S_PAM[D_522 = 'KK']/D_782"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:if>
                                 <!-- InvoiceDetailDiscount-->
                                 <xsl:if
                                    test="G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 != ''">
                                    <xsl:element name="InvoiceDetailDiscount">
                                       <xsl:if
                                          test="G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310' and D_378 = '3']/D_332 != ''">
                                          <xsl:attribute name="percentageRate">
                                             <xsl:value-of
                                                select="G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310' and D_378 = '3']/D_332"
                                             />
                                          </xsl:attribute>
                                       </xsl:if>
                                       <xsl:call-template name="createMoney">
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                                          <!-- <xsl:with-param name="money" select="(G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 div 100)"/>-->
                                          <xsl:with-param name="money"
                                             select="xs:decimal(G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610) div xs:decimal(100)"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:if>
                                 <!-- NetAmount -->
                                 <xsl:if test="S_PAM[D_522 = 'N']/D_782 != ''">
                                    <xsl:element name="NetAmount">
                                       <xsl:call-template name="createMoney">
                                          <xsl:with-param name="money"
                                             select="S_PAM[D_522 = 'N']/D_782"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:if>
                                 <!-- Comments -->
                                 <xsl:if test="S_REF[D_128 = 'L1']/D_352 != ''">
                                    <xsl:element name="Comments">
                                       <xsl:attribute name="xml:lang">
                                          <xsl:choose>
                                             <xsl:when test="S_REF[D_128 = 'L1']/D_127 != ''">
                                                <xsl:value-of select="S_REF[D_128 = 'L1']/D_127"/>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:text>en</xsl:text>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:attribute>
                                       <xsl:value-of select="S_REF[D_128 = 'L1']/D_352"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <!-- Extrinsics -->
                                 <xsl:for-each select="S_REF[D_128 = 'ZZ']">
                                    <xsl:element name="Extrinsic">
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="D_127"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="D_352"/>
                                    </xsl:element>
                                 </xsl:for-each>
                                 <!-- CG: IG-16765 - 1500 Extrinsics -->
                                 <xsl:if test="$useExtrinsicsLookup = 'yes'">
                                    <xsl:for-each select="S_REF[D_128 != 'ZZ']">
                                       <xsl:variable name="refQualVal" select="D_128"/>
                                       <xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/InvHeaderEx))][1]/CXMLCode"/>
                                       <xsl:if test="$extNameL != ''">
                                          <xsl:element name="Extrinsic">
                                             <xsl:attribute name="name">
                                                <xsl:value-of select="$extNameL"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="concat(D_127,D_352)"/>
                                          </xsl:element>
                                       </xsl:if>
                                    </xsl:for-each>
                                 </xsl:if>
                              </xsl:element>
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:when>
                  <!-- Summary Invoice -->
                  <xsl:when
                     test="FunctionalGroup/M_810/S_BIG/D_640 = 'FD' or (FunctionalGroup/M_810/S_BIG/D_640 = 'DI' and $HeaderPoRef = 'no')">
                     <xsl:variable name="itemCount" select="count(FunctionalGroup/M_810/G_IT1)"/>
                     <xsl:variable name="onCount" select="count(//G_IT1/S_REF[D_128 = 'PO'])"/>
                     <xsl:variable name="vnCount" select="count(//G_IT1/S_REF[D_128 = 'VN'])"/>
                     <xsl:variable name="ahCount" select="count(//G_IT1/S_REF[D_128 = 'AH'])"/>
                     <xsl:variable name="groupType">
                        <xsl:choose>
                           <xsl:when test="$itemCount = $onCount">PO</xsl:when>
                           <xsl:when test="$itemCount = $vnCount">VN</xsl:when>
                           <xsl:when test="$itemCount = $ahCount">AH</xsl:when>
                           <xsl:otherwise>ON</xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <!--xsl:for-each-group select="FunctionalGroup/M_810/G_IT1[S_IT1/D_235_1='SH' or S_IT1/D_235_1='SN']" group-by="S_REF[D_128=$groupType]/D_127"-->
                     <xsl:for-each-group select="FunctionalGroup/M_810/G_IT1"
                        group-by="S_REF[D_128 = $groupType]/D_127">
                        <xsl:variable name="linSum">
                           <xsl:call-template name="createLIN">
                              <xsl:with-param name="LIN" select="S_IT1"/>
                           </xsl:call-template>
                        </xsl:variable>
                        <xsl:element name="InvoiceDetailOrder">
                           <xsl:element name="InvoiceDetailOrderInfo">
                              <!-- IG-1925 -->
                              <xsl:choose>
                                 <!-- NONPO Case-->
                                 <xsl:when test="FunctionalGroup/M_810/S_BIG/D_324 = 'NONPO'">
                                    <xsl:if test="current-group()//S_REF[D_128 = 'AH']/D_127 != ''">
                                       <!-- MasterAgreementID -->
                                       <xsl:element name="MasterAgreementIDInfo">
                                          <xsl:if
                                             test="current-group()//S_REF[D_128 = 'AH']/D_127 != ''">
                                             <xsl:attribute name="agreementID">
                                                <xsl:value-of
                                                  select="(current-group()//S_REF[D_128 = 'AH']/D_127)[1]"
                                                />
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:if
                                             test="current-group()//S_DTM[D_374 = 'LEA']/D_373 != ''">
                                             <xsl:attribute name="agreementDate">
                                                <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date"
                                                  select="(current-group()//S_DTM[D_374 = 'LEA']/D_373)[1]"/>
                                                  <xsl:with-param name="Time"
                                                  select="(current-group()//S_DTM[D_374 = 'LEA']/D_337)[1]"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="(current-group()//S_DTM[D_374 = 'LEA']/D_623)[1]"
                                                  />
                                                </xsl:call-template>
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:if
                                             test="current-group()//S_REF[D_128 = 'AH']/D_352 = '1'">
                                             <xsl:attribute name="agreementType">
                                                <xsl:text>scheduling_agreement</xsl:text>
                                             </xsl:attribute>
                                          </xsl:if>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="current-group()//S_REF[D_128 = 'PO']/D_127 != ''">
                                       <!-- OrderID -->
                                       <xsl:element name="OrderIDInfo">
                                          <xsl:attribute name="orderID">
                                             <xsl:value-of
                                                select="(current-group()//S_REF[D_128 = 'PO']/D_127)[1]"
                                             />
                                          </xsl:attribute>
                                          <xsl:if
                                             test="current-group()//S_DTM[D_374 = '004']/D_373 != ''">
                                             <xsl:variable name="chkOrderDate">
                                                <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="(current-group()//S_DTM[D_374 = '004']/D_373)[1]"/>
                                                  <xsl:with-param name="Time"
                                                  select="(current-group()//S_DTM[D_374 = '004']/D_337)[1]"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="(current-group()//S_DTM[D_374 = '004']/D_623)[1]"
                                                  />
                                                </xsl:call-template>
                                             </xsl:variable>
                                             <xsl:if test="$chkOrderDate != ''">
                                                <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                </xsl:attribute>
                                             </xsl:if>
                                          </xsl:if>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if
                                       test="(current-group()//S_REF[D_128 = 'VN']/D_127 != '')">
                                       <!-- SupplierOrderID -->
                                       <xsl:element name="SupplierOrderInfo">
                                          <xsl:attribute name="orderID">
                                             <xsl:value-of
                                                select="(current-group()//S_REF[D_128 = 'VN']/D_127)[1]"
                                             />
                                          </xsl:attribute>
                                          <xsl:if
                                             test="current-group()//S_DTM[D_374 = '008']/D_373 != ''">
                                             <xsl:variable name="chkOrderDate">
                                                <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_373)[1]"/>
                                                  <xsl:with-param name="Time"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_337)[1]"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_623)[1]"
                                                  />
                                                </xsl:call-template>
                                             </xsl:variable>
                                             <xsl:if test="$chkOrderDate != ''">
                                                <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                </xsl:attribute>
                                             </xsl:if>
                                          </xsl:if>
                                       </xsl:element>
                                    </xsl:if>
                                 </xsl:when>
                                 <!-- PO Reference Case-->
                                 <xsl:when
                                    test="(current-group()//S_REF[D_128 = 'PO']/D_127 != '') or (current-group()//S_REF[D_128 = 'AH']/D_127 != '') or (FunctionalGroup/M_810/S_BIG/D_324 != '')">
                                    <xsl:variable name="tempPONumber">
                                       <xsl:choose>
                                          <xsl:when
                                             test="(current-group()//S_REF[D_128 = 'PO']/D_127 != '')">
                                             <xsl:value-of
                                                select="(current-group()//S_REF[D_128 = 'PO']/D_127)[1]"
                                             />
                                          </xsl:when>
                                          <xsl:when test="(FunctionalGroup/M_810/S_BIG/D_324 != '')">
                                             <xsl:value-of
                                                select="FunctionalGroup/M_810/S_BIG/D_324"/>
                                          </xsl:when>
                                       </xsl:choose>
                                    </xsl:variable>
                                    <xsl:if test="$tempPONumber != ''">
                                       <!-- OrderID -->
                                       <xsl:element name="OrderReference">
                                          <xsl:attribute name="orderID">
                                             <xsl:value-of select="$tempPONumber"/>
                                          </xsl:attribute>
                                          <xsl:if
                                             test="current-group()//S_DTM[D_374 = '004']/D_373 != ''">
                                             <xsl:variable name="chkOrderDate">
                                                <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="(current-group()//S_DTM[D_374 = '004']/D_373)[1]"/>
                                                  <xsl:with-param name="Time"
                                                  select="(current-group()//S_DTM[D_374 = '004']/D_337)[1]"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="(current-group()//S_DTM[D_374 = '004']/D_623)[1]"
                                                  />
                                                </xsl:call-template>
                                             </xsl:variable>
                                             <xsl:if test="$chkOrderDate != ''">
                                                <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                </xsl:attribute>
                                             </xsl:if>
                                          </xsl:if>
                                          <DocumentReference payloadID=""/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="current-group()//S_REF[D_128 = 'AH']/D_127 != ''">
                                       <!-- MasterAgreementID -->
                                       <xsl:element name="MasterAgreementReference">
                                          <xsl:if
                                             test="current-group()//S_REF[D_128 = 'AH']/D_127 != ''">
                                             <xsl:attribute name="agreementID">
                                                <xsl:value-of
                                                  select="(current-group()//S_REF[D_128 = 'AH']/D_127)[1]"
                                                />
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:if
                                             test="current-group()//S_DTM[D_374 = 'LEA']/D_373 != ''">
                                             <xsl:attribute name="agreementDate">
                                                <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date"
                                                  select="(current-group()//S_DTM[D_374 = 'LEA']/D_373)[1]"/>
                                                  <xsl:with-param name="Time"
                                                  select="(current-group()//S_DTM[D_374 = 'LEA']/D_337)[1]"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="(current-group()//S_DTM[D_374 = 'LEA']/D_623)[1]"
                                                  />
                                                </xsl:call-template>
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:if
                                             test="current-group()//S_REF[D_128 = 'AH']/D_352 = '1'">
                                             <xsl:attribute name="agreementType">
                                                <xsl:text>scheduling_agreement</xsl:text>
                                             </xsl:attribute>
                                          </xsl:if>
                                          <DocumentReference payloadID=""/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if
                                       test="(current-group()//S_REF[D_128 = 'VN']/D_127 != '')">
                                       <!-- SupplierOrderID -->
                                       <xsl:element name="SupplierOrderInfo">
                                          <xsl:attribute name="orderID">
                                             <xsl:value-of
                                                select="(current-group()//S_REF[D_128 = 'VN']/D_127)[1]"
                                             />
                                          </xsl:attribute>
                                          <xsl:if
                                             test="current-group()//S_DTM[D_374 = '008']/D_373 != ''">
                                             <xsl:variable name="chkOrderDate">
                                                <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_373)[1]"/>
                                                  <xsl:with-param name="Time"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_337)[1]"/>
                                                  <xsl:with-param name="TimeCode"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_623)[1]"
                                                  />
                                                </xsl:call-template>
                                             </xsl:variable>
                                             <xsl:if test="$chkOrderDate != ''">
                                                <xsl:attribute name="orderDate">
                                                  <xsl:value-of select="$chkOrderDate"/>
                                                </xsl:attribute>
                                             </xsl:if>
                                          </xsl:if>
                                       </xsl:element>
                                    </xsl:if>
                                 </xsl:when>
                                 <!-- Supplier Order Case-->
                                 <xsl:when test="(current-group()//S_REF[D_128 = 'VN']/D_127 != '')">
                                    <xsl:element name="SupplierOrderInfo">
                                       <xsl:attribute name="orderID">
                                          <xsl:value-of
                                             select="(current-group()//S_REF[D_128 = 'VN']/D_127)[1]"
                                          />
                                       </xsl:attribute>
                                       <xsl:if
                                          test="current-group()//S_DTM[D_374 = '008']/D_373 != ''">
                                          <xsl:variable name="chkOrderDate">
                                             <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_373)[1]"/>
                                                <xsl:with-param name="Time"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_337)[1]"/>
                                                <xsl:with-param name="TimeCode"
                                                  select="(current-group()//S_DTM[D_374 = '008']/D_623)[1]"
                                                />
                                             </xsl:call-template>
                                          </xsl:variable>
                                          <xsl:if test="$chkOrderDate != ''">
                                             <xsl:attribute name="orderDate">
                                                <xsl:value-of select="$chkOrderDate"/>
                                             </xsl:attribute>
                                          </xsl:if>
                                       </xsl:if>
                                    </xsl:element>
                                 </xsl:when>
                                 <!-- Not any PO reference Case-->
                                 <xsl:otherwise>
                                    <!-- Empty OrderID -->
                                    <xsl:element name="OrderIDInfo">
                                       <xsl:attribute name="orderID">
                                          <xsl:value-of select="''"/>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!--										<xsl:if test="current-group()//S_REF[D_128 = 'AH']/D_127!= ''">											<xsl:element name="MasterAgreementIDInfo">												<xsl:if test="current-group()//S_REF[D_128 = 'AH']/D_127!= ''">													<xsl:attribute name="agreementID">														<xsl:value-of select="(current-group()//S_REF[D_128 = 'AH']/D_127)[1]"/>													</xsl:attribute>												</xsl:if>												<xsl:if test="current-group()//S_DTM[D_374 = 'LEA']/D_373!= ''">													<xsl:attribute name="agreementDate">														<xsl:call-template name="convertToAribaDate">															<xsl:with-param name="Date" select="(current-group()//S_DTM[D_374 = 'LEA']/D_373)[1]"/>															<xsl:with-param name="Time" select="(current-group()//S_DTM[D_374 = 'LEA']/D_337)[1]"/>															<xsl:with-param name="TimeCode" select="(current-group()//S_DTM[D_374 = 'LEA']/D_623)[1]"/>														</xsl:call-template>													</xsl:attribute>												</xsl:if>												<xsl:if test="current-group()//S_REF[D_128 = 'AH']/D_352='yes'">													<xsl:attribute name="agreementType">														<xsl:text>scheduling_agreement</xsl:text>													</xsl:attribute>												</xsl:if>											</xsl:element>										</xsl:if>																				<xsl:if test="current-group()//S_REF[D_128 = 'PO']/D_127!=''">											<xsl:element name="OrderIDInfo">												<xsl:attribute name="orderID">													<xsl:value-of select="(current-group()//S_REF[D_128 = 'PO']/D_127)[1]"/>												</xsl:attribute>												<xsl:if test="current-group()//S_DTM[D_374 = '004']/D_373!='' ">													<xsl:variable name="chkOrderDate">														<xsl:call-template name="convertToAribaDatePORef">															<xsl:with-param name="Date" select="(current-group()//S_DTM[D_374 = '004']/D_373)[1]"/>															<xsl:with-param name="Time" select="(current-group()//S_DTM[D_374 = '004']/D_337)[1]"/>															<xsl:with-param name="TimeCode" select="(current-group()//S_DTM[D_374 = '004']/D_623)[1]"/>														</xsl:call-template>													</xsl:variable>													<xsl:if test="$chkOrderDate!=''">														<xsl:attribute name="orderDate">															<xsl:value-of select="$chkOrderDate"/>														</xsl:attribute>													</xsl:if>												</xsl:if>											</xsl:element>										</xsl:if>																				<xsl:if test="current-group()//S_REF[D_128 = 'VN']/D_127!=''">											<xsl:element name="SupplierOrderInfo">												<xsl:attribute name="orderID">													<xsl:value-of select="(current-group()//S_REF[D_128 = 'VN']/D_127)[1]"/>												</xsl:attribute>												<xsl:if test="current-group()//S_DTM[D_374 = '008']/D_373!=''">													<xsl:variable name="chkOrderDate">														<xsl:call-template name="convertToAribaDatePORef">															<xsl:with-param name="Date" select="(current-group()//S_DTM[D_374 = '008']/D_373)[1]"/>															<xsl:with-param name="Time" select="(current-group()//S_DTM[D_374 = '008']/D_337)[1]"/>															<xsl:with-param name="TimeCode" select="(current-group()//S_DTM[D_374 = '008']/D_623)[1]"/>														</xsl:call-template>													</xsl:variable>													<xsl:if test="$chkOrderDate!=''">														<xsl:attribute name="orderDate">															<xsl:value-of select="$chkOrderDate"/>														</xsl:attribute>													</xsl:if>												</xsl:if>											</xsl:element>										</xsl:if>										-->
                           </xsl:element>
                           <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'RV']/D_127 != ''">
                              <xsl:element name="InvoiceDetailReceiptInfo">
                                 <xsl:choose>
                                    <xsl:when test="FunctionalGroup/M_810/S_BIG/D_324 = 'NONPO'">
                                       <xsl:element name="ReceiptIDInfo">
                                          <xsl:attribute name="receiptID">
                                             <xsl:value-of
                                                select="FunctionalGroup/M_810/S_REF[D_128 = 'RV']/D_127"
                                             />
                                          </xsl:attribute>
                                       </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:element name="ReceiptReference">
                                          <xsl:attribute name="receiptID">
                                             <xsl:value-of
                                                select="FunctionalGroup/M_810/S_REF[D_128 = 'RV']/D_127"
                                             />
                                          </xsl:attribute>
                                          <DocumentReference payloadID=""/>
                                       </xsl:element>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:element>
                           </xsl:if>
                           <xsl:for-each select="current-group()">
                              <xsl:apply-templates select=".">
                                 <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                                 <xsl:with-param name="headerCurr" select="$headerCurr"/>
                                 <xsl:with-param name="headerAltCurr" select="$headerAltCurr"/>
                              </xsl:apply-templates>
                           </xsl:for-each>
                        </xsl:element>
                     </xsl:for-each-group>
                  </xsl:when>
                  <!-- Detail Invoice -->
                  <xsl:otherwise>
                     <xsl:element name="InvoiceDetailOrder">
                        <xsl:element name="InvoiceDetailOrderInfo">
                           <!-- IG-1925 -->
                           <xsl:choose>
                              <!-- NONPO Case-->
                              <xsl:when
                                 test="FunctionalGroup/M_810/S_BIG/D_324 = 'NONPO' and not(FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127 != '' or FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127 != '' or FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127 != '')">
                                 <!-- Empty OrderID -->
                                 <xsl:element name="OrderIDInfo">
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of select="''"/>
                                    </xsl:attribute>
                                 </xsl:element>
                              </xsl:when>
                              <xsl:when test="FunctionalGroup/M_810/S_BIG/D_324 = 'NONPO'">
                                 <xsl:if
                                    test="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127 != ''">
                                    <!-- MasterAgreementID -->
                                    <xsl:element name="MasterAgreementIDInfo">
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127 != ''">
                                          <xsl:attribute name="agreementID">
                                             <xsl:value-of
                                                select="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127"
                                             />
                                          </xsl:attribute>
                                       </xsl:if>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_373 != ''">
                                          <xsl:attribute name="agreementDate">
                                             <xsl:call-template name="convertToAribaDate">
                                                <xsl:with-param name="Date"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_373"/>
                                                <xsl:with-param name="Time"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_337"/>
                                                <xsl:with-param name="TimeCode"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_623"
                                                />
                                             </xsl:call-template>
                                          </xsl:attribute>
                                       </xsl:if>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_352 = '1'">
                                          <xsl:attribute name="agreementType">
                                             <xsl:text>scheduling_agreement</xsl:text>
                                          </xsl:attribute>
                                       </xsl:if>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if
                                    test="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127 != ''">
                                    <!-- OrderID -->
                                    <xsl:element name="OrderIDInfo">
                                       <xsl:attribute name="orderID">
                                          <xsl:value-of
                                             select="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127"
                                          />
                                       </xsl:attribute>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373 != ''">
                                          <xsl:variable name="chkOrderDate">
                                             <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373"/>
                                                <xsl:with-param name="Time"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_337"/>
                                                <xsl:with-param name="TimeCode"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_623"
                                                />
                                             </xsl:call-template>
                                          </xsl:variable>
                                          <xsl:if test="$chkOrderDate != ''">
                                             <xsl:attribute name="orderDate">
                                                <xsl:value-of select="$chkOrderDate"/>
                                             </xsl:attribute>
                                          </xsl:if>
                                       </xsl:if>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if
                                    test="(FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127 != '')">
                                    <!-- SupplierOrderID -->
                                    <xsl:element name="SupplierOrderInfo">
                                       <xsl:attribute name="orderID">
                                          <xsl:value-of
                                             select="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127"
                                          />
                                       </xsl:attribute>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373 != ''">
                                          <xsl:variable name="chkOrderDate">
                                             <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373"/>
                                                <xsl:with-param name="Time"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_337"/>
                                                <xsl:with-param name="TimeCode"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_623"
                                                />
                                             </xsl:call-template>
                                          </xsl:variable>
                                          <xsl:if test="$chkOrderDate != ''">
                                             <xsl:attribute name="orderDate">
                                                <xsl:value-of select="$chkOrderDate"/>
                                             </xsl:attribute>
                                          </xsl:if>
                                       </xsl:if>
                                    </xsl:element>
                                 </xsl:if>
                              </xsl:when>
                              <!-- PO Reference Case-->
                              <xsl:when
                                 test="(FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127 != '') or (FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127 != '') or (FunctionalGroup/M_810/S_BIG/D_324 != '')">
                                 <xsl:variable name="tempPONumber">
                                    <xsl:choose>
                                       <xsl:when
                                          test="(FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127 != '')">
                                          <xsl:value-of
                                             select="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127"
                                          />
                                       </xsl:when>
                                       <xsl:when test="(FunctionalGroup/M_810/S_BIG/D_324 != '')">
                                          <xsl:value-of select="FunctionalGroup/M_810/S_BIG/D_324"/>
                                       </xsl:when>
                                    </xsl:choose>
                                 </xsl:variable>
                                 <xsl:if test="$tempPONumber != ''">
                                    <!-- OrderID -->
                                    <xsl:element name="OrderReference">
                                       <xsl:attribute name="orderID">
                                          <xsl:value-of select="$tempPONumber"/>
                                       </xsl:attribute>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373 != ''">
                                          <xsl:variable name="chkOrderDate">
                                             <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373"/>
                                                <xsl:with-param name="Time"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_337"/>
                                                <xsl:with-param name="TimeCode"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_623"
                                                />
                                             </xsl:call-template>
                                          </xsl:variable>
                                          <xsl:if test="$chkOrderDate != ''">
                                             <xsl:attribute name="orderDate">
                                                <xsl:value-of select="$chkOrderDate"/>
                                             </xsl:attribute>
                                          </xsl:if>
                                       </xsl:if>
                                       <DocumentReference payloadID=""/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if
                                    test="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127 != ''">
                                    <!-- MasterAgreementID -->
                                    <xsl:element name="MasterAgreementReference">
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127 != ''">
                                          <xsl:attribute name="agreementID">
                                             <xsl:value-of
                                                select="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127"
                                             />
                                          </xsl:attribute>
                                       </xsl:if>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_373 != ''">
                                          <xsl:attribute name="agreementDate">
                                             <xsl:call-template name="convertToAribaDate">
                                                <xsl:with-param name="Date"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_373"/>
                                                <xsl:with-param name="Time"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_337"/>
                                                <xsl:with-param name="TimeCode"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_623"
                                                />
                                             </xsl:call-template>
                                          </xsl:attribute>
                                       </xsl:if>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_352 = '1'">
                                          <xsl:attribute name="agreementType">
                                             <xsl:text>scheduling_agreement</xsl:text>
                                          </xsl:attribute>
                                       </xsl:if>
                                       <DocumentReference payloadID=""/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if
                                    test="(FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127 != '')">
                                    <!-- SupplierOrderID -->
                                    <xsl:element name="SupplierOrderInfo">
                                       <xsl:attribute name="orderID">
                                          <xsl:value-of
                                             select="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127"
                                          />
                                       </xsl:attribute>
                                       <xsl:if
                                          test="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373 != ''">
                                          <xsl:variable name="chkOrderDate">
                                             <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373"/>
                                                <xsl:with-param name="Time"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_337"/>
                                                <xsl:with-param name="TimeCode"
                                                  select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_623"
                                                />
                                             </xsl:call-template>
                                          </xsl:variable>
                                          <xsl:if test="$chkOrderDate != ''">
                                             <xsl:attribute name="orderDate">
                                                <xsl:value-of select="$chkOrderDate"/>
                                             </xsl:attribute>
                                          </xsl:if>
                                       </xsl:if>
                                    </xsl:element>
                                 </xsl:if>
                              </xsl:when>
                              <!-- Supplier Order Case-->
                              <xsl:when
                                 test="(FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127 != '')">
                                 <xsl:element name="SupplierOrderInfo">
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of
                                          select="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127"/>
                                    </xsl:attribute>
                                    <xsl:if
                                       test="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373 != ''">
                                       <xsl:variable name="chkOrderDate">
                                          <xsl:call-template name="convertToAribaDatePORef">
                                             <xsl:with-param name="Date"
                                                select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373"/>
                                             <xsl:with-param name="Time"
                                                select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_337"/>
                                             <xsl:with-param name="TimeCode"
                                                select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_623"
                                             />
                                          </xsl:call-template>
                                       </xsl:variable>
                                       <xsl:if test="$chkOrderDate != ''">
                                          <xsl:attribute name="orderDate">
                                             <xsl:value-of select="$chkOrderDate"/>
                                          </xsl:attribute>
                                       </xsl:if>
                                    </xsl:if>
                                 </xsl:element>
                              </xsl:when>
                              <!-- Not any PO reference Case-->
                              <xsl:otherwise>
                                 <!-- Empty OrderID -->
                                 <xsl:element name="OrderIDInfo">
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of select="''"/>
                                    </xsl:attribute>
                                 </xsl:element>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                        <xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'RV']/D_127 != ''">
                           <xsl:element name="InvoiceDetailReceiptInfo">
                              <xsl:choose>
                                 <xsl:when test="FunctionalGroup/M_810/S_BIG/D_324 = 'NONPO'">
                                    <xsl:element name="ReceiptIDInfo">
                                       <xsl:attribute name="receiptID">
                                          <xsl:value-of
                                             select="FunctionalGroup/M_810/S_REF[D_128 = 'RV']/D_127"
                                          />
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:element name="ReceiptReference">
                                       <xsl:attribute name="receiptID">
                                          <xsl:value-of
                                             select="FunctionalGroup/M_810/S_REF[D_128 = 'RV']/D_127"
                                          />
                                       </xsl:attribute>
                                       <DocumentReference payloadID=""/>
                                    </xsl:element>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:element>
                        </xsl:if>
                        <!--									<xsl:choose>										<xsl:when test="(FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127!='')">											<xsl:element name="MasterAgreementIDInfo">												<xsl:attribute name="agreementID">													<xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'AH']/D_127"/>												</xsl:attribute>												<xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_373!= ''">													<xsl:attribute name="agreementDate">														<xsl:call-template name="convertToAribaDate">															<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_373"/>															<xsl:with-param name="Time" select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_337"/>															<xsl:with-param name="TimeCode" select="FunctionalGroup/M_810/S_DTM[D_374 = 'LEA']/D_623"/>														</xsl:call-template>													</xsl:attribute>												</xsl:if>												<xsl:if test="FunctionalGroup/M_810/S_DTM[D_128 = 'AH']/D_352='yes'">													<xsl:attribute name="agreementType">														<xsl:text>scheduling_agreement</xsl:text>													</xsl:attribute>												</xsl:if>											</xsl:element>											<xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127!='' or FunctionalGroup/M_810/S_BIG/D_324!=''">												<xsl:element name="OrderIDInfo">													<xsl:attribute name="orderID">														<xsl:choose>															<xsl:when test="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127!=''">																<xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127"/>															</xsl:when>															<xsl:when test="FunctionalGroup/M_810/S_BIG/D_324!='NONPO'">																<xsl:value-of select="FunctionalGroup/M_810/S_BIG/D_324"/>															</xsl:when>														</xsl:choose>													</xsl:attribute>													<xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373!='' or FunctionalGroup/M_810/S_BIG/D_373_2!=''">														<xsl:variable name="chkOrderDate">															<xsl:choose>																<xsl:when test="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373!=''">																	<xsl:call-template name="convertToAribaDatePORef">																		<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373"/>																		<xsl:with-param name="Time" select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_337"/>																		<xsl:with-param name="TimeCode" select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_623"/>																	</xsl:call-template>																</xsl:when>																<xsl:otherwise>																	<xsl:call-template name="convertToAribaDatePORef">																		<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_BIG/D_373_2"/>																	</xsl:call-template>																</xsl:otherwise>															</xsl:choose>														</xsl:variable>														<xsl:if test="$chkOrderDate!=''">															<xsl:attribute name="orderDate">																<xsl:value-of select="$chkOrderDate"/>															</xsl:attribute>														</xsl:if>													</xsl:if>												</xsl:element>											</xsl:if>											<xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127!=''">												<xsl:element name="SupplierOrderInfo">													<xsl:attribute name="orderID">														<xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127"/>													</xsl:attribute>													<xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373!=''">														<xsl:variable name="chkOrderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373"/>																<xsl:with-param name="Time" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_337"/>																<xsl:with-param name="TimeCode" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_623"/>															</xsl:call-template>														</xsl:variable>														<xsl:if test="$chkOrderDate!=''">															<xsl:attribute name="orderDate">																<xsl:value-of select="$chkOrderDate"/>															</xsl:attribute>														</xsl:if>													</xsl:if>												</xsl:element>											</xsl:if>										</xsl:when>										<xsl:when test="(FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127!='' or FunctionalGroup/M_810/S_BIG/D_324!='')">											<xsl:element name="OrderIDInfo">												<xsl:attribute name="orderID">													<xsl:choose>														<xsl:when test="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127!=''">															<xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'PO']/D_127"/>														</xsl:when>														<xsl:when test="FunctionalGroup/M_810/S_BIG/D_324!='NONPO'">															<xsl:value-of select="FunctionalGroup/M_810/S_BIG/D_324"/>														</xsl:when>													</xsl:choose>												</xsl:attribute>												<xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373!='' or FunctionalGroup/M_810/S_BIG/D_373_2!=''">													<xsl:variable name="chkOrderDate">														<xsl:choose>															<xsl:when test="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373!=''">																<xsl:call-template name="convertToAribaDatePORef">																	<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_373"/>																	<xsl:with-param name="Time" select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_337"/>																	<xsl:with-param name="TimeCode" select="FunctionalGroup/M_810/S_DTM[D_374 = '004']/D_623"/>																</xsl:call-template>															</xsl:when>															<xsl:otherwise>																<xsl:call-template name="convertToAribaDatePORef">																	<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_BIG/D_373_2"/>																</xsl:call-template>															</xsl:otherwise>														</xsl:choose>													</xsl:variable>													<xsl:if test="$chkOrderDate!=''">														<xsl:attribute name="orderDate">															<xsl:value-of select="$chkOrderDate"/>														</xsl:attribute>													</xsl:if>												</xsl:if>											</xsl:element>											<xsl:if test="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127!=''">												<xsl:element name="SupplierOrderInfo">													<xsl:attribute name="orderID">														<xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127"/>													</xsl:attribute>													<xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373!=''">														<xsl:variable name="chkOrderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373"/>																<xsl:with-param name="Time" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_337"/>																<xsl:with-param name="TimeCode" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_623"/>															</xsl:call-template>														</xsl:variable>														<xsl:if test="$chkOrderDate!=''">															<xsl:attribute name="orderDate">																<xsl:value-of select="$chkOrderDate"/>															</xsl:attribute>														</xsl:if>													</xsl:if>												</xsl:element>											</xsl:if>										</xsl:when>										<xsl:when test="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127!=''">											<xsl:element name="SupplierOrderInfo">												<xsl:attribute name="orderID">													<xsl:value-of select="FunctionalGroup/M_810/S_REF[D_128 = 'VN']/D_127"/>												</xsl:attribute>												<xsl:if test="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373!=''">													<xsl:variable name="chkOrderDate">														<xsl:call-template name="convertToAribaDatePORef">															<xsl:with-param name="Date" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_373"/>															<xsl:with-param name="Time" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_337"/>															<xsl:with-param name="TimeCode" select="FunctionalGroup/M_810/S_DTM[D_374 = '008']/D_623"/>														</xsl:call-template>													</xsl:variable>													<xsl:if test="$chkOrderDate!=''">														<xsl:attribute name="orderDate">															<xsl:value-of select="$chkOrderDate"/>														</xsl:attribute>													</xsl:if>												</xsl:if>											</xsl:element>										</xsl:when>										<xsl:otherwise>											<xsl:element name="OrderIDInfo">												<xsl:attribute name="orderID"></xsl:attribute>											</xsl:element>										</xsl:otherwise>									</xsl:choose>								</xsl:element>								-->
                        <!-- InvoiceDetailShipNoticeInfo -->
                        <xsl:for-each select="FunctionalGroup/M_810/G_IT1[S_REF/D_128 = 'MA'][1]">
                           <xsl:element name="InvoiceDetailShipNoticeInfo">
                              <xsl:element name="ShipNoticeReference">
                                 <xsl:attribute name="shipNoticeID"
                                    select="S_REF[D_128 = 'MA']/D_127"/>
                                 <xsl:if test="S_DTM/D_374 = '111'">
                                    <xsl:attribute name="shipNoticeDate">
                                       <xsl:call-template name="convertToAribaDate">
                                          <xsl:with-param name="Date">
                                             <xsl:value-of select="S_DTM[D_374 = '111']/D_373"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="Time">
                                             <xsl:value-of select="S_DTM[D_374 = '111']/D_337"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="TimeCode">
                                             <xsl:value-of select="S_DTM[D_374 = '111']/D_623"/>
                                          </xsl:with-param>
                                       </xsl:call-template>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:element name="DocumentReference">
                                    <xsl:attribute name="payloadID"/>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:element>
                        </xsl:for-each>
                        <!--xsl:for-each select="FunctionalGroup/M_810/G_IT1[S_IT1/D_235_1='SH' or S_IT1/D_235_1='SN']"-->
                        <xsl:for-each select="FunctionalGroup/M_810/G_IT1">
                           <xsl:variable name="lineCurr">
                              <xsl:choose>
                                 <xsl:when
                                    test="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1 != ''">
                                    <xsl:value-of select="S_CUR/D_100_1"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$headerCurr"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:variable name="lineAltCurr">
                              <xsl:choose>
                                 <xsl:when
                                    test="S_CUR[D_98_2 = 'BY' or D_98_2 = 'SE']/D_100_2 != ''">
                                    <xsl:value-of select="S_CUR/D_100_2"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$headerAltCurr"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:apply-templates select=".">
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="headerCurr" select="$headerCurr"/>
                              <xsl:with-param name="headerAltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="invType" select="$invType"/>
                           </xsl:apply-templates>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:element name="InvoiceDetailSummary">
                  <xsl:element name="SubtotalAmount">
                     <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_810/S_AMT[D_522 = '1']/D_782 != ''">
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="money"
                                 select="(FunctionalGroup/M_810/S_AMT[D_522 = '1']/D_782)[1]"/>
                              <xsl:with-param name="altAmt"
                                 select="(FunctionalGroup/M_810/S_AMT[D_522 = '1']/D_782)[2]"/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="FunctionalGroup/M_810/S_TDS/D_610_2 != ''">
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <!--<xsl:with-param name="money" select="(FunctionalGroup/M_810/S_TDS/D_610_2 div 100)"/>-->
                              <xsl:with-param name="money"
                                 select="xs:decimal(FunctionalGroup/M_810/S_TDS/D_610_2) div xs:decimal(100)"
                              />
                           </xsl:call-template>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:element>
                  <xsl:element name="Tax">
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="Curr" select="$headerCurr"/>
                        <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                        <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                        <!--<xsl:with-param name="money" select="(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610 div 100)"/>-->
                        <xsl:with-param name="money"
                           select="xs:decimal(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610) div xs:decimal(100)"/>
                        <xsl:with-param name="altAmt"
                           select="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_127"
                        />
                     </xsl:call-template>
                     <xsl:element name="Description">
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when
                                 test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_819 != ''">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_819"
                                 />
                              </xsl:when>
                              <xsl:otherwise>en</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:if
                           test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_352 != ''">
                           <xsl:value-of
                              select="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_352"
                           />
                        </xsl:if>
                     </xsl:element>
                     <xsl:choose>
                        <!-- CG: IG-23185 -->
                        <xsl:when test="$headerAltCurr = ''">
                           <xsl:for-each select="FunctionalGroup/M_810/G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI">
                              <xsl:call-template name="mapTaxDetail">
                                 <xsl:with-param name="mainCurrency" select="$headerCurr"/>
                                 <xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
                                 <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                 <xsl:with-param name="tpDTM" select="FunctionalGroup/M_810/S_DTM[D_374 = '983']"/>
                                 <xsl:with-param name="pdDTM" select="FunctionalGroup/M_810/S_DTM[D_374 = '814']"/>
                              </xsl:call-template>
                           </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:for-each-group
                              select="FunctionalGroup/M_810/G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI"
                              group-by="D_963">
                              <xsl:choose>
                                 <xsl:when test="count(current-group()) &gt; 1">
                                    <xsl:for-each select="current-group()[position() mod 2 = 1]">
                                       <xsl:variable name="tc" select="D_963"/>
                                       <xsl:variable name="altAmount" select="following-sibling::S_TXI[D_963 = $tc][1]/D_782"/>
                                       <xsl:call-template name="mapTaxDetail">
                                          <xsl:with-param name="mainCurrency" select="$headerCurr"/>
                                          <xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
                                          <xsl:with-param name="alternateAmount" select="$altAmount"/>
                                          <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                          <xsl:with-param name="tpDTM" select="FunctionalGroup/M_810/S_DTM[D_374 = '983']"/>
                                          <xsl:with-param name="pdDTM" select="FunctionalGroup/M_810/S_DTM[D_374 = '814']"/>
                                       </xsl:call-template>
                                    </xsl:for-each>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:call-template name="mapTaxDetail">
                                       <xsl:with-param name="mainCurrency" select="$headerCurr"/>
                                       <xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
                                       <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                       <xsl:with-param name="tpDTM" select="FunctionalGroup/M_810/S_DTM[D_374 = '983']"/>
                                       <xsl:with-param name="pdDTM" select="FunctionalGroup/M_810/S_DTM[D_374 = '814']"/>
                                    </xsl:call-template>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:for-each-group>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
                  <!-- SpecialHandlingAmount -->
                  <xsl:if
                     test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610 != ''">
                     <xsl:element name="SpecialHandlingAmount">
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <!--<xsl:with-param name="money" select="(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610 div 100)"/>-->
                           <xsl:with-param name="money"
                              select="xs:decimal(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610) div xs:decimal(100)"
                           />
                        </xsl:call-template>
                        <xsl:if
                           test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_352 != ''">
                           <xsl:element name="Description">
                              <xsl:attribute name="xml:lang">
                                 <xsl:choose>
                                    <xsl:when
                                       test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_819 != ''">
                                       <xsl:value-of
                                          select="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_819"
                                       />
                                    </xsl:when>
                                    <xsl:otherwise>en</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:value-of
                                 select="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_352"
                              />
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
                  <!-- ShippingAmount -->
                  <xsl:if
                     test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 != ''">
                     <xsl:element name="ShippingAmount">
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <!-- <xsl:with-param name="money" select="(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 div 100)"/>-->
                           <xsl:with-param name="money"
                              select="xs:decimal(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610) div xs:decimal(100)"
                           />
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <!-- GrossAmount -->
                  <xsl:if test="FunctionalGroup/M_810/S_TDS/D_610_1 != ''">
                     <xsl:element name="GrossAmount">
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <!--<xsl:with-param name="money" select="(FunctionalGroup/M_810/S_TDS/D_610_1 div 100)"/>-->
                           <xsl:with-param name="money"
                              select="xs:decimal(FunctionalGroup/M_810/S_TDS/D_610_1) div xs:decimal(100)"
                           />
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <!-- InvoiceDetailDiscount -->
                  <xsl:if
                     test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 != ''">
                     <xsl:element name="InvoiceDetailDiscount">
                        <xsl:if
                           test="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310' and D_378 = '3']/D_332 != ''">
                           <xsl:attribute name="percentageRate">
                              <xsl:value-of
                                 select="FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310' and D_378 = '3']/D_332"
                              />
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <!--<xsl:with-param name="money" select="(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 div 100)"/>-->
                           <xsl:with-param name="money"
                              select="xs:decimal(FunctionalGroup/M_810/G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610) div xs:decimal(100)"
                           />
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <!-- InvoiceHeaderModifications -->
                  <xsl:if
                     test="exists(FunctionalGroup/M_810/G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840'])">
                     <xsl:element name="InvoiceHeaderModifications">
                        <xsl:for-each
                           select="FunctionalGroup/M_810/G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840']">
                           <xsl:variable name="modCode">
                              <xsl:value-of select="S_SAC/D_1300"/>
                           </xsl:variable>
                           <xsl:element name="Modification">
                              <xsl:if test="S_SAC/D_127 != ''">
                                 <xsl:element name="OriginalPrice">
                                    <xsl:if test="S_SAC/D_770 != ''">
                                       <xsl:attribute name="type" select="S_SAC/D_770"/>
                                    </xsl:if>
                                    <xsl:call-template name="createMoney">
                                       <xsl:with-param name="Curr" select="$headerCurr"/>
                                       <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                                       <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                                       <xsl:with-param name="money" select="S_SAC/D_127"/>
                                    </xsl:call-template>
                                 </xsl:element>
                              </xsl:if>
                              <xsl:choose>
                                 <xsl:when test="S_SAC/D_248 = 'A'">
                                    <xsl:element name="AdditionalDeduction">
                                       <xsl:choose>
                                          <xsl:when test="S_SAC/D_331 = '13' and S_SAC/D_610 != ''">
                                             <xsl:element name="DeductionAmount">
                                                <xsl:call-template name="createMoney">
                                                  <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                                  <xsl:with-param name="money"
                                                  select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                                  <xsl:with-param name="Curr" select="$headerCurr"/>
                                                  <xsl:with-param name="AltCurr"
                                                  select="$headerAltCurr"/>
                                                  <xsl:with-param name="isCreditMemo"
                                                  select="$isCreditMemo"/>
                                                </xsl:call-template>
                                             </xsl:element>
                                          </xsl:when>
                                          <xsl:when test="S_SAC/D_610 != ''">
                                             <xsl:element name="DeductedPrice">
                                                <xsl:call-template name="createMoney">
                                                  <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                                  <xsl:with-param name="money"
                                                  select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                                  <xsl:with-param name="Curr" select="$headerCurr"/>
                                                  <xsl:with-param name="AltCurr"
                                                  select="$headerAltCurr"/>
                                                  <xsl:with-param name="isCreditMemo"
                                                  select="$isCreditMemo"/>
                                                </xsl:call-template>
                                             </xsl:element>
                                          </xsl:when>
                                          <xsl:when test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
                                             <xsl:element name="DeductionPercent">
                                                <xsl:attribute name="percent">
                                                  <xsl:value-of select="S_SAC/D_332"/>
                                                </xsl:attribute>
                                             </xsl:element>
                                          </xsl:when>
                                       </xsl:choose>
                                    </xsl:element>
                                 </xsl:when>
                                 <xsl:when test="S_SAC/D_248 = 'C'">
                                    <xsl:element name="AdditionalCost">
                                       <xsl:choose>
                                          <xsl:when test="S_SAC/D_610 != ''">
                                             <xsl:call-template name="createMoney">
                                                <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                                <xsl:with-param name="money"
                                                  select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                                <xsl:with-param name="Curr" select="$headerCurr"/>
                                                <xsl:with-param name="AltCurr"
                                                  select="$headerAltCurr"/>
                                                <xsl:with-param name="isCreditMemo"
                                                  select="$isCreditMemo"/>
                                             </xsl:call-template>
                                          </xsl:when>
                                          <xsl:when test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
                                             <xsl:element name="Percentage">
                                                <xsl:attribute name="percent">
                                                  <xsl:value-of select="S_SAC/D_332"/>
                                                </xsl:attribute>
                                             </xsl:element>
                                          </xsl:when>
                                       </xsl:choose>
                                    </xsl:element>
                                 </xsl:when>
                              </xsl:choose>
                              <xsl:if test="exists(S_TXI[D_963 = 'ZZ' or D_963 = 'TX'])">
                                 <xsl:element name="Tax">
                                    <xsl:call-template name="createMoney">
                                       <xsl:with-param name="Curr" select="$headerCurr"/>
                                       <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                                       <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                                       <xsl:with-param name="money"
                                          select="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_782"/>
                                    </xsl:call-template>
                                    <xsl:element name="Description">
                                       <xsl:attribute name="xml:lang">en</xsl:attribute>
                                       <xsl:if
                                          test="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_352 != ''">
                                          <xsl:value-of
                                             select="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_352"/>
                                       </xsl:if>
                                    </xsl:element>
                                    <xsl:for-each select="S_TXI[D_963 != 'ZZ' and D_963 != 'TX']">
                                       <!-- CG: IG-23185 -->
                                       <xsl:call-template name="mapTaxDetail">
                                          <xsl:with-param name="mainCurrency" select="$headerCurr"/>
                                          <xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
                                          <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                          <xsl:with-param name="ignoreTPDate" select="'true'"/>
                                       </xsl:call-template>
                                    </xsl:for-each>
                                 </xsl:element>
                              </xsl:if>
                              <!-- ModificationDetail -->
                              <xsl:if
                                 test="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode != ''">
                                 <xsl:element name="ModificationDetail">
                                    <xsl:attribute name="name">
                                       <xsl:value-of
                                          select="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode"
                                       />
                                    </xsl:attribute>
                                    <xsl:if test="S_SAC/D_352 != ''">
                                       <xsl:element name="Description">
                                          <xsl:attribute name="xml:lang">
                                             <xsl:choose>
                                                <xsl:when test="S_SAC/D_819 != ''">
                                                  <xsl:value-of select="S_SAC/D_819"/>
                                                </xsl:when>
                                                <xsl:otherwise>en</xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:attribute>
                                          <xsl:value-of select="S_SAC/D_352"/>
                                       </xsl:element>
                                    </xsl:if>
                                 </xsl:element>
                              </xsl:if>
                           </xsl:element>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:if>
                  <!-- TotalCharges -->
                  <xsl:if test="FunctionalGroup/M_810/S_AMT[D_522 = 'GW']/D_782 != ''">
                     <xsl:element name="TotalCharges">
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <xsl:with-param name="money"
                              select="FunctionalGroup/M_810/S_AMT[D_522 = 'GW']/D_782"/>
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <!-- TotalAllowances -->
                  <xsl:if test="FunctionalGroup/M_810/S_AMT[D_522 = 'EC']/D_782 != ''">
                     <xsl:element name="TotalAllowances">
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <xsl:with-param name="money"
                              select="FunctionalGroup/M_810/S_AMT[D_522 = 'EC']/D_782"/>
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <!-- TotalAmountWithoutTax -->
                  <xsl:if test="FunctionalGroup/M_810/S_AMT[D_522 = 'ZZ']/D_782 != ''">
                     <xsl:element name="TotalAmountWithoutTax">
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <xsl:with-param name="money"
                              select="(FunctionalGroup/M_810/S_AMT[D_522 = 'ZZ']/D_782)[1]"/>
                           <xsl:with-param name="altAmt"
                              select="(FunctionalGroup/M_810/S_AMT[D_522 = 'ZZ']/D_782)[2]"/>
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <xsl:element name="NetAmount">
                     <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_810/S_AMT[D_522 = 'N']/D_782 != ''">
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="money"
                                 select="(FunctionalGroup/M_810/S_AMT[D_522 = 'N']/D_782)"/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <!--<xsl:with-param name="money" select="(FunctionalGroup/M_810/S_TDS/D_610_3 div 100)"/>-->
                              <xsl:with-param name="money"
                                 select="xs:decimal(FunctionalGroup/M_810/S_TDS/D_610_3) div xs:decimal(100)"
                              />
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
                  <!-- DepositAmount -->
                  <xsl:if test="FunctionalGroup/M_810/S_AMT[D_522 = '3']/D_782 != ''">
                     <xsl:element name="DepositAmount">
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="Curr" select="$headerCurr"/>
                           <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           <xsl:with-param name="money"
                              select="FunctionalGroup/M_810/S_AMT[D_522 = '3']/D_782"/>
                        </xsl:call-template>
                     </xsl:element>
                  </xsl:if>
                  <!-- DueAmount -->
                  <xsl:choose>
                     <xsl:when test="FunctionalGroup/M_810/S_AMT[D_522 = 'BAP']/D_782 != ''">
                        <xsl:element name="DueAmount">
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="money"
                                 select="(FunctionalGroup/M_810/S_AMT[D_522 = 'BAP']/D_782)[1]"/>
                              <xsl:with-param name="altAmt"
                                 select="(FunctionalGroup/M_810/S_AMT[D_522 = 'BAP']/D_782)[2]"/>
                           </xsl:call-template>
                        </xsl:element>
                     </xsl:when>
                     <xsl:when test="FunctionalGroup/M_810/S_TDS/D_610_4 != ''">
                        <xsl:element name="DueAmount">
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <!--<xsl:with-param name="money" select="(FunctionalGroup/M_810/S_TDS/D_610_4 div 100)"/>-->
                              <xsl:with-param name="money"
                                 select="xs:decimal(FunctionalGroup/M_810/S_TDS/D_610_4) div xs:decimal(100)"
                              />
                           </xsl:call-template>
                        </xsl:element>
                     </xsl:when>
                  </xsl:choose>
               </xsl:element>
            </xsl:element>
         </xsl:element>
      </xsl:element>
   </xsl:template>
   <!-- Functions -->
   <xsl:template name="createMoney">
      <xsl:param name="Curr"/>
      <xsl:param name="AltCurr"/>
      <xsl:param name="isCreditMemo"/>
      <xsl:param name="money"/>
      <xsl:param name="altAmt"/>
      <xsl:param name="isLineNegPriceAdjustment"/>
      <xsl:variable name="mainMoney">
         <xsl:choose>
            <xsl:when test="string($money) != ''">
               <xsl:value-of select="$money"/>
            </xsl:when>
            <xsl:otherwise>0.00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:element name="Money">
         <xsl:attribute name="currency">
            <xsl:value-of select="$Curr"/>
         </xsl:attribute>
         <xsl:if test="$AltCurr != '' and $altAmt != ''">
            <xsl:attribute name="alternateCurrency">
               <xsl:value-of select="$AltCurr"/>
            </xsl:attribute>
            <xsl:attribute name="alternateAmount">
               <xsl:choose>
                  <xsl:when test="$isCreditMemo = 'yes'">
                     <xsl:value-of select="concat('-', replace(string($altAmt), '-', ''))"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$altAmt"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$isLineNegPriceAdjustment = 'yes'">
               <xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
            </xsl:when>
            <xsl:when test="$isLineNegPriceAdjustment = 'no'">
               <xsl:value-of select="$mainMoney"/>
            </xsl:when>
            <xsl:when test="$isCreditMemo = 'yes'">
               <xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$mainMoney"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template match="S_PER">
      <xsl:variable name="PER02">
         <xsl:choose>
            <xsl:when test="D_93 != ''">
               <xsl:value-of select="D_93"/>
            </xsl:when>
            <xsl:otherwise>default</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="D_365_1 = 'EM'">
            <Con>
               <xsl:attribute name="type">Email</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="value">
                  <xsl:value-of select="normalize-space(D_364_1)"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_1 = 'UR'">
            <Con>
               <xsl:attribute name="type">URL</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="value">
                  <xsl:value-of select="normalize-space(D_364_1)"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_1 = 'TE'">
            <Con>
               <xsl:attribute name="type">Phone</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="cCode">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_1, '(')">
                        <xsl:value-of select="substring-before(D_364_1, '(')"/>
                     </xsl:when>
                     <xsl:when test="contains(D_364_1, '-')">
                        <xsl:value-of select="substring-before(D_364_1, '-')"/>
                     </xsl:when>
                     <xsl:otherwise>1</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="aCode">
                  <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
               </xsl:attribute>
               <xsl:attribute name="num">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_1, 'x')">
                        <xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"
                        />
                     </xsl:when>
                     <xsl:when test="contains(D_364_1, 'X')">
                        <xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"
                        />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring-after(D_364_1, '-')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="ext">
                  <xsl:value-of select="substring-after(D_364_1, 'x')"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_1 = 'FX'">
            <Con>
               <xsl:attribute name="type">Fax</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="cCode">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_1, '(')">
                        <xsl:value-of select="substring-before(D_364_1, '(')"/>
                     </xsl:when>
                     <xsl:when test="contains(D_364_1, '-')">
                        <xsl:value-of select="substring-before(D_364_1, '-')"/>
                     </xsl:when>
                     <xsl:otherwise>1</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="aCode">
                  <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
               </xsl:attribute>
               <xsl:attribute name="num">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_1, 'x')">
                        <xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"
                        />
                     </xsl:when>
                     <xsl:when test="contains(D_364_1, 'X')">
                        <xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"
                        />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring-after(D_364_1, '-')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="ext">
                  <xsl:value-of select="substring-after(D_364_1, 'x')"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="D_365_2 = 'EM'">
            <Con>
               <xsl:attribute name="type">Email</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="value">
                  <xsl:value-of select="normalize-space(D_364_2)"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_2 = 'UR'">
            <Con>
               <xsl:attribute name="type">URL</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="value">
                  <xsl:value-of select="normalize-space(D_364_2)"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_2 = 'TE'">
            <Con>
               <xsl:attribute name="type">Phone</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="cCode">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_2, '(')">
                        <xsl:value-of select="substring-before(D_364_2, '(')"/>
                     </xsl:when>
                     <xsl:when test="contains(D_364_2, '-')">
                        <xsl:value-of select="substring-before(D_364_2, '-')"/>
                     </xsl:when>
                     <xsl:otherwise>1</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="aCode">
                  <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
               </xsl:attribute>
               <xsl:attribute name="num">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_2, 'x')">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"
                        />
                     </xsl:when>
                     <xsl:when test="contains(D_364_2, 'X')">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"
                        />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring-after(D_364_2, '-')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="ext">
                  <xsl:value-of select="substring-after(D_364_2, 'x')"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_2 = 'FX'">
            <Con>
               <xsl:attribute name="type">Fax</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="cCode">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_2, '(')">
                        <xsl:value-of select="substring-before(D_364_2, '(')"/>
                     </xsl:when>
                     <xsl:when test="contains(D_364_2, '-')">
                        <xsl:value-of select="substring-before(D_364_2, '-')"/>
                     </xsl:when>
                     <xsl:otherwise>1</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="aCode">
                  <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
               </xsl:attribute>
               <xsl:attribute name="num">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_2, 'x')">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"
                        />
                     </xsl:when>
                     <xsl:when test="contains(D_364_2, 'X')">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"
                        />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring-after(D_364_2, '-')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="ext">
                  <xsl:value-of select="substring-after(D_364_2, 'x')"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="D_365_3 = 'EM'">
            <Con>
               <xsl:attribute name="type">Email</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="value">
                  <xsl:value-of select="normalize-space(D_364_3)"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_3 = 'UR'">
            <Con>
               <xsl:attribute name="type">URL</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="value">
                  <xsl:value-of select="normalize-space(D_364_3)"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_3 = 'TE'">
            <Con>
               <xsl:attribute name="type">Phone</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="cCode">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_3, '(')">
                        <xsl:value-of select="substring-before(D_364_3, '(')"/>
                     </xsl:when>
                     <xsl:when test="contains(D_364_3, '-')">
                        <xsl:value-of select="substring-before(D_364_3, '-')"/>
                     </xsl:when>
                     <xsl:otherwise>1</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="aCode">
                  <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
               </xsl:attribute>
               <xsl:attribute name="num">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_3, 'x')">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"
                        />
                     </xsl:when>
                     <xsl:when test="contains(D_364_3, 'X')">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"
                        />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring-after(D_364_3, '-')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="ext">
                  <xsl:value-of select="substring-after(D_364_3, 'x')"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
         <xsl:when test="D_365_3 = 'FX'">
            <Con>
               <xsl:attribute name="type">Fax</xsl:attribute>
               <xsl:attribute name="name">
                  <xsl:value-of select="$PER02"/>
               </xsl:attribute>
               <xsl:attribute name="cCode">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_3, '(')">
                        <xsl:value-of select="substring-before(D_364_3, '(')"/>
                     </xsl:when>
                     <xsl:when test="contains(D_364_3, '-')">
                        <xsl:value-of select="substring-before(D_364_3, '-')"/>
                     </xsl:when>
                     <xsl:otherwise>1</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="aCode">
                  <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
               </xsl:attribute>
               <xsl:attribute name="num">
                  <xsl:choose>
                     <xsl:when test="contains(D_364_3, 'x')">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"
                        />
                     </xsl:when>
                     <xsl:when test="contains(D_364_3, 'X')">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"
                        />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring-after(D_364_3, '-')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="ext">
                  <xsl:value-of select="substring-after(D_364_3, 'x')"/>
               </xsl:attribute>
            </Con>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="createAddress">
      <xsl:param name="contact"/>
      <xsl:element name="Address">
         <xsl:if test="$contact/S_N1/D_66 != '' or $contact/S_N1/D_67 != ''">
            <xsl:variable name="addrDomain">
               <xsl:value-of select="$contact/S_N1/D_66"/>
            </xsl:variable>
            <xsl:variable name="addressID">
               <xsl:value-of select="$contact/S_N1/D_67"/>
            </xsl:variable>
            <xsl:if test="$addressID != ''">
               <xsl:attribute name="addressID">
                  <xsl:value-of select="$addressID"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
               <xsl:if test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain] != ''">
                  <xsl:attribute name="addressIDDomain">
                     <xsl:value-of
                        select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"
                     />
                  </xsl:attribute>
               </xsl:if>
            </xsl:if>
         </xsl:if>
         <xsl:element name="Name">
            <xsl:attribute name="xml:lang">en</xsl:attribute>
            <xsl:value-of select="$contact/S_N1/D_93"/>
         </xsl:element>
         <!-- PostalAddress -->
         <xsl:if
            test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
            <xsl:element name="PostalAddress">
               <xsl:if test="S_REF[D_128 = 'ME']/D_127 != ''">
                  <xsl:attribute name="name">
                     <xsl:value-of select="S_REF[D_128 = 'ME']/D_127"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:for-each select="$contact/S_N2">
                  <xsl:element name="DeliverTo">
                     <xsl:value-of select="D_93_1"/>
                  </xsl:element>
                  <xsl:if test="D_93_2 != ''">
                     <xsl:element name="DeliverTo">
                        <xsl:value-of select="D_93_2"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$contact/S_N3">
                  <xsl:element name="Street">
                     <xsl:value-of select="D_166_1"/>
                  </xsl:element>
                  <xsl:if test="D_166_2 != ''">
                     <xsl:element name="Street">
                        <xsl:value-of select="D_166_2"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
               <xsl:element name="City">
                  <xsl:value-of select="$contact/S_N4/D_19"/>
               </xsl:element>
               <xsl:variable name="sCode">
                  <xsl:choose>
                     <xsl:when
                        test="$contact/S_N4/D_310 != '' and not($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA')">
                        <xsl:value-of select="$contact/S_N4/D_310"/>
                     </xsl:when>
                     <xsl:when test="$contact/S_N4/D_156 != ''">
                        <xsl:value-of select="$contact/S_N4/D_156"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:variable>
               <xsl:if test="$sCode != ''">
                  <xsl:element name="State">
                     <xsl:value-of select="$sCode"/>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$contact/S_N4/D_116 != ''">
                  <xsl:element name="PostalCode">
                     <xsl:value-of select="$contact/S_N4/D_116"/>
                  </xsl:element>
               </xsl:if>
               <xsl:variable name="isoCountryCode">
                  <xsl:value-of select="$contact/S_N4/D_26"/>
               </xsl:variable>
               <xsl:element name="Country">
                  <xsl:attribute name="isoCountryCode">
                     <xsl:value-of select="$isoCountryCode"/>
                  </xsl:attribute>
                  <xsl:value-of
                     select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
                  />
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:variable name="contactList">
            <xsl:apply-templates select="$contact/S_PER"/>
         </xsl:variable>
         <xsl:for-each select="$contactList/Con[@type = 'Email'][1]">
            <xsl:element name="Email">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:value-of select="./@value"/>
            </xsl:element>
         </xsl:for-each>
         <xsl:for-each select="$contactList/Con[@type = 'Phone'][1]">
            <xsl:sort select="@name"/>
            <xsl:variable name="ccCode" select="@cCode"/>
            <xsl:element name="Phone">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:element name="TelephoneNumber">
                  <xsl:element name="CountryCode">
                     <xsl:attribute name="isoCountryCode">
                        <xsl:choose>
                           <xsl:when
                              test="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode != ''">
                              <xsl:value-of
                                 select="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode"
                              />
                           </xsl:when>
                           <xsl:otherwise>US</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:value-of select="replace(@cCode, '\+', '')"/>
                  </xsl:element>
                  <xsl:element name="AreaOrCityCode">
                     <xsl:value-of select="@aCode"/>
                  </xsl:element>
                  <xsl:element name="Number">
                     <xsl:value-of select="@num"/>
                  </xsl:element>
                  <xsl:if test="@ext != ''">
                     <xsl:element name="Extension">
                        <xsl:value-of select="@ext"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:element>
         </xsl:for-each>
         <xsl:for-each select="$contactList/Con[@type = 'Fax'][1]">
            <xsl:sort select="@name"/>
            <xsl:variable name="ccCode" select="@cCode"/>
            <xsl:element name="Fax">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:element name="TelephoneNumber">
                  <xsl:element name="CountryCode">
                     <xsl:attribute name="isoCountryCode">
                        <xsl:choose>
                           <xsl:when
                              test="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode != ''">
                              <xsl:value-of
                                 select="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode"
                              />
                           </xsl:when>
                           <xsl:otherwise>US</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:value-of select="replace(@cCode, '\+', '')"/>
                  </xsl:element>
                  <xsl:element name="AreaOrCityCode">
                     <xsl:value-of select="@aCode"/>
                  </xsl:element>
                  <xsl:element name="Number">
                     <xsl:value-of select="@num"/>
                  </xsl:element>
                  <xsl:if test="@ext != ''">
                     <xsl:element name="Extension">
                        <xsl:value-of select="@ext"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:element>
         </xsl:for-each>
         <xsl:for-each select="$contactList/Con[@type = 'URL'][1]">
            <xsl:sort select="@name"/>
            <xsl:element name="URL">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:value-of select="./@value"/>
            </xsl:element>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createContact">
      <xsl:param name="contact"/>
      <xsl:variable name="role">
         <xsl:value-of select="$contact/S_N1/D_98_1"/>
      </xsl:variable>
      <xsl:if test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
         <xsl:element name="Contact">
            <xsl:attribute name="role">
               <xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode"/>
            </xsl:attribute>
            <xsl:if test="$contact/S_N1/D_67 != ''">
               <xsl:attribute name="addressID">
                  <xsl:value-of select="$contact/S_N1/D_67"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:variable name="addrDomain">
               <xsl:value-of select="$contact/S_N1/D_66"/>
            </xsl:variable>
            <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
               <xsl:if test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain] != ''">
                  <xsl:attribute name="addressIDDomain">
                     <xsl:value-of
                        select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"
                     />
                  </xsl:attribute>
               </xsl:if>
            </xsl:if>
            <xsl:element name="Name">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
               <xsl:value-of select="$contact/S_N1/D_93"/>
            </xsl:element>
            <!-- PostalAddress -->
            <xsl:if
               test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
               <xsl:element name="PostalAddress">
                  <xsl:if test="S_REF[D_128 = 'ME']/D_127 != ''">
                     <xsl:attribute name="name">
                        <xsl:value-of select="S_REF[D_128 = 'ME']/D_127"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:for-each select="$contact/S_N2">
                     <xsl:element name="DeliverTo">
                        <xsl:value-of select="D_93_1"/>
                     </xsl:element>
                     <xsl:if test="D_93_2 != ''">
                        <xsl:element name="DeliverTo">
                           <xsl:value-of select="D_93_2"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="$contact/S_N3">
                     <xsl:element name="Street">
                        <xsl:value-of select="D_166_1"/>
                     </xsl:element>
                     <xsl:if test="D_166_2 != ''">
                        <xsl:element name="Street">
                           <xsl:value-of select="D_166_2"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:element name="City">
                     <xsl:value-of select="$contact/S_N4/D_19"/>
                  </xsl:element>
                  <xsl:variable name="sCode">
                     <xsl:choose>
                        <xsl:when
                           test="$contact/S_N4/D_310 != '' and not($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA')">
                           <xsl:value-of select="$contact/S_N4/D_310"/>
                        </xsl:when>
                        <xsl:when test="$contact/S_N4/D_156 != ''">
                           <xsl:value-of select="$contact/S_N4/D_156"/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="$sCode != ''">
                     <xsl:element name="State">
                        <xsl:value-of select="$sCode"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="$contact/S_N4/D_116 != ''">
                     <xsl:element name="PostalCode">
                        <xsl:value-of select="$contact/S_N4/D_116"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:variable name="isoCountryCode">
                     <xsl:value-of select="$contact/S_N4/D_26"/>
                  </xsl:variable>
                  <xsl:element name="Country">
                     <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCountryCode"/>
                     </xsl:attribute>
                     <xsl:value-of
                        select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
                     />
                  </xsl:element>
               </xsl:element>
            </xsl:if>
            <xsl:variable name="contactList">
               <xsl:apply-templates select="$contact/S_PER"/>
            </xsl:variable>
            <xsl:for-each select="$contactList/Con[@type = 'Email']">
               <xsl:sort select="@name"/>
               <xsl:element name="Email">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:value-of select="./@value"/>
               </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'Phone']">
               <xsl:sort select="@name"/>
               <xsl:variable name="ccCode" select="@ccCode"/>
               <xsl:element name="Phone">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:element name="TelephoneNumber">
                     <xsl:element name="CountryCode">
                        <xsl:attribute name="isoCountryCode">
                           <xsl:choose>
                              <xsl:when
                                 test="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode != ''">
                                 <xsl:value-of
                                    select="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode"
                                 />
                              </xsl:when>
                              <xsl:otherwise>US</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="replace(@cCode, '\+', '')"/>
                     </xsl:element>
                     <xsl:element name="AreaOrCityCode">
                        <xsl:value-of select="@aCode"/>
                     </xsl:element>
                     <xsl:element name="Number">
                        <xsl:value-of select="@num"/>
                     </xsl:element>
                     <xsl:if test="@ext != ''">
                        <xsl:element name="Extension">
                           <xsl:value-of select="@ext"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'Fax']">
               <xsl:sort select="@name"/>
               <xsl:variable name="ccCode" select="@cCode"/>
               <xsl:element name="Fax">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:element name="TelephoneNumber">
                     <xsl:element name="CountryCode">
                        <xsl:attribute name="isoCountryCode">
                           <xsl:choose>
                              <xsl:when
                                 test="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode != ''">
                                 <xsl:value-of
                                    select="$Lookup/Lookups/Countries/Country[phoneCode = $ccCode][1]/countryCode"
                                 />
                              </xsl:when>
                              <xsl:otherwise>US</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="replace(@cCode, '\+', '')"/>
                     </xsl:element>
                     <xsl:element name="AreaOrCityCode">
                        <xsl:value-of select="@aCode"/>
                     </xsl:element>
                     <xsl:element name="Number">
                        <xsl:value-of select="@num"/>
                     </xsl:element>
                     <xsl:if test="@ext != ''">
                        <xsl:element name="Extension">
                           <xsl:value-of select="@ext"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'URL']">
               <xsl:sort select="@name"/>
               <xsl:element name="URL">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:value-of select="./@value"/>
               </xsl:element>
            </xsl:for-each>
            <xsl:if test="$role = 'SF' or $role = 'ST' or $role = 'CA'">
               <xsl:for-each select="S_REF">
                  <xsl:variable name="IDRefDomain" select="D_128"/>
                  <xsl:choose>
                     <xsl:when test="$IDRefDomain = 'ZZ' and D_127 != '' and D_352 != ''">
                        <xsl:element name="IdReference">
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="D_352"/>
                           </xsl:attribute>
                           <xsl:attribute name="domain">
                              <xsl:value-of select="D_127"/>
                           </xsl:attribute>
                        </xsl:element>
                     </xsl:when>
                     <xsl:when
                        test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
                        <xsl:element name="IdReference">
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="D_352"/>
                           </xsl:attribute>
                           <xsl:attribute name="domain">
                              <xsl:value-of
                                 select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"
                              />
                           </xsl:attribute>
                        </xsl:element>
                     </xsl:when>
                     <xsl:when
                        test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
                        <xsl:element name="IdReference">
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="D_352"/>
                           </xsl:attribute>
                           <xsl:attribute name="domain">
                              <xsl:value-of
                                 select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"
                              />
                           </xsl:attribute>
                        </xsl:element>
                     </xsl:when>
                  </xsl:choose>
                  <xsl:if test="$IDRefDomain = 'GT'">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="D_352"/>
                        </xsl:attribute>
                        <xsl:attribute name="domain">
                           <xsl:value-of select="'gstID'"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <!-- IG-31034 -->
            <xsl:if test="$role = 'FR' or $role = 'SO' or $role = 'CA'">
               <xsl:for-each select="S_REF">
                  <xsl:variable name="IDRefDomain" select="D_128"/>
                  <xsl:if test="($IDRefDomain = '4G' or $IDRefDomain = '4O')">
                     <xsl:choose>
                        <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
                           <xsl:element name="IdReference">
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="D_352"/>
                              </xsl:attribute>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"/>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
                           <xsl:element name="IdReference">
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="D_352"/>
                              </xsl:attribute>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"/>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:if>
                  
                  <xsl:if test="$IDRefDomain = 'GT'">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="D_352"/>
                        </xsl:attribute>
                        <xsl:attribute name="domain">
                           <xsl:value-of select="'gstID'"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <!-- Extrinsic -->
            <!-- IG-5742 -->
            <xsl:if test="$role = 'FR'">
               <!-- LegalStatus -->
               <xsl:if test="//FunctionalGroup/M_810/S_NTE[D_363 = 'REG']/D_352 != ''">
                  <xsl:call-template name="LegalStatus">
                     <xsl:with-param name="REG"
                        select="//FunctionalGroup/M_810/S_NTE[D_363 = 'REG']/D_352"/>
                  </xsl:call-template>
               </xsl:if>
               <!-- LegalCapital -->
               <xsl:if test="//FunctionalGroup/M_810/S_NTE[D_363 = 'CBH']/D_352 != ''">
                  <xsl:call-template name="LegalCapital">
                     <xsl:with-param name="CBH"
                        select="//FunctionalGroup/M_810/S_NTE[D_363 = 'CBH']/D_352"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:if>
         </xsl:element>
         <xsl:if test="$role != 'SF' and $role != 'ST' and $role != 'CA'">
            <xsl:for-each select="S_REF">
               <xsl:choose>
                  <xsl:when test="$role = 'RI' and D_128 = 'BAA'">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="D_352"/>
                        </xsl:attribute>
                        <xsl:attribute name="domain">
                           <xsl:text>supplierTaxID</xsl:text>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:variable name="IDRefDomain" select="D_128"/>
                     <xsl:choose>
                        <xsl:when test="$IDRefDomain = 'ZZ' and D_127 != '' and D_352 != ''">
                           <xsl:element name="IdReference">
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="D_352"/>
                              </xsl:attribute>
                              <xsl:attribute name="domain">
                                 <xsl:value-of select="D_127"/>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when
                           test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
                           <xsl:element name="IdReference">
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="D_352"/>
                              </xsl:attribute>
                              <xsl:attribute name="domain">
                                 <xsl:value-of
                                    select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"
                                 />
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when
                           test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
                           <xsl:element name="IdReference">
                              <xsl:attribute name="identifier">
                                 <xsl:value-of select="D_352"/>
                              </xsl:attribute>
                              <xsl:attribute name="domain">
                                 <xsl:value-of
                                    select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"
                                 />
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                     </xsl:choose>
                     <xsl:if test="$IDRefDomain = 'GT'">
                        <xsl:element name="IdReference">
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="D_352"/>
                           </xsl:attribute>
                           <xsl:attribute name="domain">
                              <xsl:value-of select="'gstID'"/>
                           </xsl:attribute>
                        </xsl:element>
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   <xsl:template name="convertToTelephone">
      <xsl:param name="phoneNum"/>
      <xsl:variable name="phoneNumTemp">
         <xsl:value-of select="$phoneNum"/>
      </xsl:variable>
      <xsl:variable name="phoneArr" select="tokenize($phoneNumTemp, '-')"/>
      <xsl:variable name="cCode">
         <xsl:value-of select="replace($phoneArr[1], '\+', '')"/>
      </xsl:variable>
      <xsl:element name="TelephoneNumber">
         <xsl:element name="CountryCode">
            <xsl:attribute name="isoCountryCode">
               <xsl:value-of
                  select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode]/countryCode"/>
            </xsl:attribute>
            <xsl:value-of select="replace($phoneArr[1], '\+', '')"/>
         </xsl:element>
         <xsl:element name="AreaOrCityCode">
            <xsl:value-of select="$phoneArr[2]"/>
         </xsl:element>
         <xsl:choose>
            <xsl:when test="contains($phoneArr[3], 'x')">
               <xsl:variable name="extTemp">
                  <xsl:value-of select="tokenize($phoneArr[3], 'x')"/>
               </xsl:variable>
               <xsl:element name="Number">
                  <xsl:value-of select="$extTemp[1]"/>
               </xsl:element>
               <xsl:element name="Extension">
                  <xsl:value-of select="$extTemp[2]"/>
               </xsl:element>
            </xsl:when>
            <xsl:when test="exists($phoneArr[4])">
               <xsl:element name="Number">
                  <xsl:value-of select="$phoneArr[3]"/>
               </xsl:element>
               <xsl:element name="Extension">
                  <xsl:value-of select="$phoneArr[4]"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="Number">
                  <xsl:value-of select="$phoneArr[3]"/>
               </xsl:element>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template match="G_IT1">
      <xsl:param name="isCreditMemo"/>
      <xsl:param name="headerCurr"/>
      <xsl:param name="headerAltCurr"/>
      <xsl:param name="invType"/>
      <xsl:variable name="lin">
         <xsl:call-template name="createLIN">
            <xsl:with-param name="LIN" select="S_IT1"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="itemMode">
         <xsl:choose>
            <xsl:when test="$lin/lin/element[@name = 'SH']">service</xsl:when>
            <xsl:otherwise>item</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="eleName">
         <xsl:if test="$itemMode = 'item'">InvoiceDetailItem</xsl:if>
         <xsl:if test="$itemMode = 'service'">InvoiceDetailServiceItem</xsl:if>
      </xsl:variable>
      <xsl:variable name="lineCurr">
         <xsl:choose>
            <xsl:when test="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1 != ''">
               <xsl:value-of select="S_CUR/D_100_1"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$headerCurr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="lineAltCurr">
         <xsl:choose>
            <xsl:when test="S_CUR[D_98_2 = 'BY' or D_98_2 = 'SE']/D_100_2 != ''">
               <xsl:value-of select="S_CUR/D_100_2"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$headerAltCurr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$eleName}">
         <xsl:attribute name="invoiceLineNumber">
            <xsl:choose>
               <xsl:when test="S_REF[D_128 = 'FJ']/D_127 != ''">
                  <xsl:value-of select="S_REF[D_128 = 'FJ']/D_127"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="S_IT1/D_350"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:attribute name="quantity">
            <xsl:choose>
               <xsl:when
                  test="$invType = 'lineLevelCreditMemo' and (not(exists(S_CTP[D_687 = 'WS'][D_236 = 'CHG'])))">
                  <xsl:value-of select="concat('-', S_IT1/D_358)"/>
               </xsl:when>
               <xsl:when test="$invType = 'creditMemo'">
                  <xsl:value-of select="concat('-', S_IT1/D_358)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="S_IT1/D_358"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:if test="S_REF[D_128 = 'FL']/D_127 != ''">
            <xsl:attribute name="itemType">
               <xsl:value-of select="S_REF[D_128 = 'FL']/D_127"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="$itemMode = 'item'">
            <xsl:if test="S_REF[D_128 = 'FL']/D_352 != ''">
               <xsl:attribute name="compositeItemType">
                  <xsl:value-of select="S_REF[D_128 = 'FL']/D_352"/>
               </xsl:attribute>
            </xsl:if>
         </xsl:if>
         <xsl:if test="$itemMode = 'item' and $invType = 'lineLevelCreditMemo'">
            <xsl:if test="S_YNQ[D_1321 = 'Q3']/D_1073 = 'Y'">
               <xsl:attribute name="reason">
                  <xsl:value-of select="'return'"/>
               </xsl:attribute>
            </xsl:if>
         </xsl:if>
         <xsl:if test="S_YNQ[D_933_4 = 'ad-hoc item']/D_1073 = 'Y'">
            <xsl:attribute name="isAdHoc">
               <xsl:value-of select="'yes'"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="S_REF[D_128 = 'FL']/C_C040[D_128_1 = 'LI']/D_127_1 != ''">
            <xsl:attribute name="parentInvoiceLineNumber">
               <xsl:value-of select="S_REF[D_128 = 'FL']/C_C040[D_128_1 = 'LI']/D_127_1"/>
            </xsl:attribute>
         </xsl:if>
         <!-- referenceDate -->
         <xsl:if test="S_DTM[D_374 = '214']/D_373 != ''">
            <xsl:attribute name="referenceDate">
               <xsl:call-template name="convertToAribaDate">
                  <xsl:with-param name="Date" select="S_DTM[D_374 = '214']/D_373"/>
                  <xsl:with-param name="Time" select="S_DTM[D_374 = '214']/D_337"/>
                  <xsl:with-param name="TimeCode" select="S_DTM[D_374 = '214']/D_623"/>
               </xsl:call-template>
            </xsl:attribute>
         </xsl:if>
         <!-- inspectionDate -->
         <xsl:if test="S_DTM[D_374 = '517']/D_373 != ''">
            <xsl:attribute name="inspectionDate">
               <xsl:call-template name="convertToAribaDate">
                  <xsl:with-param name="Date" select="S_DTM[D_374 = '517']/D_373"/>
                  <xsl:with-param name="Time" select="S_DTM[D_374 = '517']/D_337"/>
                  <xsl:with-param name="TimeCode" select="S_DTM[D_374 = '517']/D_623"/>
               </xsl:call-template>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="$itemMode = 'service'">
            <xsl:element name="InvoiceDetailServiceItemReference">
               <xsl:attribute name="lineNumber">
                  <xsl:value-of select="S_IT1/D_350"/>
               </xsl:attribute>
               <xsl:if test="$lin/lin/element[@name = 'C3'][1]/@value != ''">
                  <xsl:element name="Classification">
                     <xsl:attribute name="domain">
                        <xsl:text>UNSPSC</xsl:text>
                     </xsl:attribute>
                     <xsl:value-of select="$lin/lin/element[@name = 'C3'][1]/@value"/>
                     <!--xsl:attribute name="code">								<xsl:value-of select="S_IT1[D_235_4='C3']/D_234_4"/>							</xsl:attribute-->
                  </xsl:element>
               </xsl:if>
               <xsl:element name="ItemID">
                  <xsl:element name="SupplierPartID">
                     <xsl:value-of select="$lin/lin/element[@name = 'SH']/@value"/>
                  </xsl:element>
                  <!-- SupplierPartAuxiliaryID -->
                  <xsl:if test="$lin/lin/element[@name = 'VS']/@value != ''">
                     <xsl:element name="SupplierPartAuxiliaryID">
                        <xsl:value-of select="$lin/lin/element[@name = 'VS']/@value"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- BuyerPartID -->
                  <xsl:if test="$lin/lin/element[@name = 'BP']/@value != ''">
                     <xsl:element name="BuyerPartID">
                        <xsl:value-of select="$lin/lin/element[@name = 'BP']/@value"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="$lin/lin/element[@name = 'UP']/@value != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">
                           <xsl:text>UPCConsumerPackageCode</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="$lin/lin/element[@name = 'UP']/@value"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
               <xsl:variable name="descLang">
                  <xsl:value-of select="S_PID[D_349 = 'F'][1]/D_819"/>
               </xsl:variable>
               <xsl:if test="G_PID/S_PID[D_349 = 'F']/D_352 != ''">
                  <xsl:variable name="descLang">
                     <xsl:choose>
                        <xsl:when test="G_PID/S_PID[D_349 = 'F']/D_819 != ''">
                           <xsl:value-of select="(G_PID/S_PID[D_349 = 'F']/D_819)[1]"/>
                        </xsl:when>
                        <xsl:otherwise>en</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:element name="Description">
                     <xsl:attribute name="xml:lang">
                        <xsl:value-of select="$descLang"/>
                     </xsl:attribute>
                     <xsl:for-each
                        select="G_PID[S_PID/D_349 = 'F' and (not(S_PID/D_750) or S_PID/D_750 = '')]">
                        <xsl:value-of
                           select="S_PID[D_349 = 'F' and (not(D_750) or D_750 = '')]/D_352"/>
                     </xsl:for-each>
                     <xsl:if test="G_PID/S_PID[D_349 = 'F' and D_750 = 'GEN']/D_352 != ''">
                        <xsl:element name="ShortName">
                           <xsl:for-each select="G_PID[S_PID/D_349 = 'F' and S_PID/D_750 = 'GEN']">
                              <xsl:value-of select="S_PID/D_352"/>
                           </xsl:for-each>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:if>
            </xsl:element>
            <!-- ServiceEntryItemReference -->
            <xsl:if
               test="S_REF[D_128 = 'ACE']/D_127 != '' and S_REF[D_128 = 'ACE']/C_C040[D_128_1 = 'LI']/D_127_1 != ''">
               <xsl:element name="ServiceEntryItemReference">
                  <xsl:if test="S_REF[D_128 = 'ACE']/D_127 != ''">
                     <xsl:attribute name="serviceEntryID">
                        <xsl:value-of select="S_REF[D_128 = 'ACE']/D_127"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="serviceLineNumber">
                     <xsl:value-of select="S_REF[D_128 = 'ACE']/C_C040[D_128_1 = 'LI']/D_127_1"/>
                  </xsl:attribute>
                  <xsl:if test="S_DTM[D_374 = '472']/D_373 != ''">
                     <xsl:attribute name="serviceEntryDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="Date" select="S_DTM[D_374 = '472']/D_373"/>
                           <xsl:with-param name="Time" select="S_DTM[D_374 = '472']/D_337"/>
                           <xsl:with-param name="TimeCode" select="S_DTM[D_374 = '472']/D_623"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:element name="DocumentReference">
                     <xsl:attribute name="payloadID"/>
                  </xsl:element>
               </xsl:element>
            </xsl:if>
            <!-- SubtotalAmount-->
            <xsl:choose>
               <xsl:when test="S_PAM[D_522 = '1']/D_782 != ''">
                  <!-- if element is not sent then cXML should fail -->
                  <xsl:element name="SubtotalAmount">
                     <xsl:call-template name="createMoney">
                        <xsl:with-param name="money" select="S_PAM[D_522 = '1']/D_782"/>
                        <xsl:with-param name="Curr" select="$lineCurr"/>
                        <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                        <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                     </xsl:call-template>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
            <!-- Period -->
            <xsl:if test="S_DTM[D_374 = '150']/D_373 != '' and S_DTM[D_374 = '151']/D_373 != ''">
               <xsl:element name="Period">
                  <xsl:attribute name="startDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="Date" select="S_DTM[D_374 = '150']/D_373"/>
                        <xsl:with-param name="Time" select="S_DTM[D_374 = '150']/D_337"/>
                        <xsl:with-param name="TimeCode" select="S_DTM[D_374 = '150']/D_623"/>
                     </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="endDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="Date" select="S_DTM[D_374 = '151']/D_373"/>
                        <xsl:with-param name="Time" select="S_DTM[D_374 = '151']/D_337"/>
                        <xsl:with-param name="TimeCode" select="S_DTM[D_374 = '151']/D_623"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </xsl:element>
            </xsl:if>
         </xsl:if>
         <xsl:element name="UnitOfMeasure">
            <xsl:variable name="uom" select="S_IT1/D_355"/>
            <xsl:choose>
               <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                  <xsl:value-of
                     select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$uom"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:element>
         <xsl:variable name="isLineNegPriceAdjustment">
            <xsl:choose>
               <xsl:when
                  test="$invType = 'lineLevelCreditMemo' and S_CTP[D_687 = 'WS']/D_236 = 'CHG'">
                  <xsl:text>yes</xsl:text>
               </xsl:when>
               <xsl:when test="$invType = 'lineLevelCreditMemo'">
                  <xsl:text>no</xsl:text>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <xsl:element name="UnitPrice">
            <xsl:call-template name="createMoney">
               <xsl:with-param name="Curr" select="$lineCurr"/>
               <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
               <xsl:with-param name="money" select="S_IT1/D_212"/>
               <xsl:with-param name="isLineNegPriceAdjustment" select="$isLineNegPriceAdjustment"/>
            </xsl:call-template>
            <xsl:for-each select="G_SAC[S_SAC/D_331 = '02']">
               <xsl:variable name="modCode">
                  <xsl:value-of select="S_SAC/D_1300"/>
               </xsl:variable>
               <xsl:element name="Modifications">
                  <xsl:element name="Modification">
                     <xsl:if test="S_SAC/D_127 != ''">
                        <xsl:element name="OriginalPrice">
                           <xsl:if test="S_SAC/D_770 != ''">
                              <xsl:attribute name="type" select="S_SAC/D_770"/>
                           </xsl:if>
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="money" select="S_SAC/D_127"/>
                           </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                     <xsl:choose>
                        <xsl:when test="S_SAC/D_248 = 'A'">
                           <xsl:element name="AdditionalDeduction">
                              <xsl:choose>
                                 <xsl:when test="S_SAC/D_331 = '13' and S_SAC/D_610 != ''">
                                    <xsl:element name="DeductionAmount">
                                       <xsl:call-template name="createMoney">
                                          <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                          <xsl:with-param name="money"
                                             select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:when>
                                 <xsl:when test="S_SAC/D_610 != ''">
                                    <xsl:element name="DeductedPrice">
                                       <xsl:call-template name="createMoney">
                                          <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                          <xsl:with-param name="money"
                                             select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:when>
                                 <xsl:when test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
                                    <xsl:element name="DeductionPercent">
                                       <xsl:attribute name="percent">
                                          <xsl:value-of select="S_SAC/D_332"/>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test="S_SAC/D_248 = 'C'">
                           <xsl:element name="AdditionalCost">
                              <xsl:choose>
                                 <xsl:when test="S_SAC/D_610 != ''">
                                    <xsl:call-template name="createMoney">
                                       <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                       <xsl:with-param name="money"
                                          select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                       <xsl:with-param name="Curr" select="$lineCurr"/>
                                       <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                       <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                                    </xsl:call-template>
                                 </xsl:when>
                                 <xsl:when test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
                                    <xsl:element name="Percentage">
                                       <xsl:attribute name="percent">
                                          <xsl:value-of select="S_SAC/D_332"/>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:element>
                        </xsl:when>
                     </xsl:choose>
                     <xsl:if test="exists(S_TXI[D_963 = 'ZZ' or D_963 = 'TX'])">
                        <xsl:element name="Tax">
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$lineCurr"/>
                              <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="money"
                                 select="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_782"/>
                           </xsl:call-template>
                           <xsl:element name="Description">
                              <xsl:attribute name="xml:lang">en</xsl:attribute>
                              <xsl:if test="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_350 != ''">
                                 <xsl:value-of select="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_350"/>
                              </xsl:if>
                           </xsl:element>
                           <xsl:for-each select="S_TXI[D_963 != 'ZZ' and D_963 != 'TX']">
                              <!-- CG: IG-23185 -->
                              <xsl:call-template name="mapTaxDetail">
                                 <xsl:with-param name="mainCurrency" select="$lineCurr"/>
                                 <xsl:with-param name="alternateCurrency" select="$lineAltCurr"/>
                                 <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                 <xsl:with-param name="ignoreTPDate" select="'true'"/>
                              </xsl:call-template>
                           </xsl:for-each>
                        </xsl:element>
                     </xsl:if>
                     <!-- ModificationDetail -->
                     <xsl:if
                        test="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode != ''">
                        <xsl:element name="ModificationDetail">
                           <xsl:attribute name="name">
                              <xsl:value-of
                                 select="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode"
                              />
                           </xsl:attribute>
                           <xsl:if test="S_SAC/D_352 != ''">
                              <xsl:element name="Description">
                                 <xsl:attribute name="xml:lang">
                                    <xsl:choose>
                                       <xsl:when test="S_SAC/D_819 != ''">
                                          <xsl:value-of select="S_SAC/D_819"/>
                                       </xsl:when>
                                       <xsl:otherwise>en</xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <xsl:value-of select="S_SAC/D_352"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:element>
            </xsl:for-each>
         </xsl:element>
         <!-- PriceBasisQuantity -->
         <xsl:if
            test="S_CTP/D_687 = 'WS' and S_CTP/D_648 = 'CSD' and S_CTP/D_380 != '' and S_CTP/D_649 != '' and S_CTP/C_C001/D_355_1 != ''">
            <xsl:variable name="uom" select="S_CTP/C_C001/D_355_1"/>
            <xsl:element name="PriceBasisQuantity">
               <xsl:attribute name="quantity">
                  <xsl:choose>
                     <xsl:when test="$invType = 'lineLevelCreditMemo'">
                        <xsl:value-of select="S_CTP/D_380"/>
                     </xsl:when>
                     <xsl:when test="$invType = 'creditMemo'">
                        <xsl:value-of select="concat('-', S_CTP/D_380)"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="S_CTP/D_380"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:attribute name="conversionFactor">
                  <xsl:value-of select="S_CTP/D_649"/>
               </xsl:attribute>
               <xsl:element name="UnitOfMeasure">
                  <xsl:choose>
                     <xsl:when
                        test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                        <xsl:value-of
                           select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$uom"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="$itemMode = 'item'">
            <xsl:element name="InvoiceDetailItemReference">
               <xsl:attribute name="lineNumber">
                  <xsl:value-of select="S_IT1/D_350"/>
               </xsl:attribute>
               <xsl:if test="$lin/lin/element[@name = 'SN']/@value != ''">
                  <xsl:attribute name="serialNumber">
                     <xsl:value-of select="($lin/lin/element[@name = 'SN']/@value)[1]"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:if
                  test="$lin/lin/element[@name = 'VP' or @name = 'VS' or @name = 'BP' or @name = 'UP']/@value != ''">
                  <xsl:element name="ItemID">
                     <xsl:element name="SupplierPartID">
                        <xsl:value-of select="$lin/lin/element[@name = 'VP']/@value"/>
                     </xsl:element>
                     <!-- SupplierPartAuxiliaryID -->
                     <xsl:if test="$lin/lin/element[@name = 'VS']/@value != ''">
                        <xsl:element name="SupplierPartAuxiliaryID">
                           <xsl:value-of select="$lin/lin/element[@name = 'VS']/@value"/>
                        </xsl:element>
                     </xsl:if>
                     <!-- BuyerPartID -->
                     <xsl:if test="$lin/lin/element[@name = 'BP']/@value">
                        <xsl:element name="BuyerPartID">
                           <xsl:value-of select="$lin/lin/element[@name = 'BP']/@value"/>
                        </xsl:element>
                     </xsl:if>
                     <xsl:if test="$lin/lin/element[@name = 'UP']/@value != ''">
                        <xsl:element name="IdReference">
                           <xsl:attribute name="domain">
                              <xsl:text>UPCConsumerPackageCode</xsl:text>
                           </xsl:attribute>
                           <xsl:attribute name="identifier">
                              <xsl:value-of select="$lin/lin/element[@name = 'UP']/@value"/>
                           </xsl:attribute>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="G_PID/S_PID[D_349 = 'F']/D_352 != ''">
                  <xsl:variable name="descLang">
                     <xsl:choose>
                        <xsl:when test="G_PID/S_PID[D_349 = 'F']/D_819 != ''">
                           <xsl:value-of select="(G_PID/S_PID[D_349 = 'F']/D_819)[1]"/>
                        </xsl:when>
                        <xsl:otherwise>en</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:element name="Description">
                     <xsl:attribute name="xml:lang">
                        <xsl:value-of select="$descLang"/>
                     </xsl:attribute>
                     <xsl:for-each
                        select="G_PID[S_PID/D_349 = 'F' and (not(S_PID/D_750) or S_PID/D_750 = '')]">
                        <xsl:value-of
                           select="S_PID[D_349 = 'F' and (not(D_750) or D_750 = '')]/D_352"/>
                     </xsl:for-each>
                     <xsl:if test="G_PID/S_PID[D_349 = 'F' and D_750 = 'GEN']/D_352 != ''">
                        <xsl:element name="ShortName">
                           <xsl:for-each select="G_PID[S_PID/D_349 = 'F' and S_PID/D_750 = 'GEN']">
                              <xsl:value-of select="S_PID/D_352"/>
                           </xsl:for-each>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$lin/lin/element[@name = 'C3'][1]/@value != ''">
                  <xsl:element name="Classification">
                     <xsl:attribute name="domain">UNSPSC</xsl:attribute>
                     <xsl:value-of select="$lin/lin/element[@name = 'C3'][1]/@value"/>
                     <!--xsl:attribute name="code">								<xsl:value-of select="S_IT1[D_235_10 = 'C3']/D_234_10"/>							</xsl:attribute-->
                  </xsl:element>
               </xsl:if>
               <xsl:if
                  test="$lin/lin/element[@name = 'MG']/@value != '' and $lin/lin/element[@name = 'MF']/@value != ''">
                  <xsl:element name="ManufacturerPartID">
                     <xsl:value-of select="$lin/lin/element[@name = 'MG']/@value"/>
                  </xsl:element>
                  <xsl:element name="ManufacturerName">
                     <xsl:value-of select="normalize-space($lin/lin/element[@name = 'MF']/@value)"/>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$lin/lin/element[@name = 'CH']/@value != ''">
                  <xsl:element name="Country">
                     <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$lin/lin/element[@name = 'CH']/@value"/>
                     </xsl:attribute>
                     <xsl:variable name="cCode" select="$lin/lin/element[@name = 'CH']/@value"/>
                     <xsl:value-of
                        select="$Lookup/Lookups/Countries/Country[countryCode = $cCode]/countryName"
                     />
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$lin/lin/element[@name = 'SN']/@value">
                  <xsl:element name="SerialNumber">
                     <xsl:value-of select="."/>
                  </xsl:element>
               </xsl:for-each>
               <xsl:if test="S_REF[D_128 = 'BT']/D_127 != ''">
                  <xsl:element name="SupplierBatchID">
                     <xsl:value-of select="S_REF[D_128 = 'BT']/D_127"/>
                  </xsl:element>
               </xsl:if>

               <xsl:if
                  test="$lin/lin/element[@name = 'EN']/@value != '' or $lin/lin/element[@name = 'EA']/@value != ''">
                  <xsl:element name="InvoiceDetailItemReferenceIndustry">
                     <xsl:element name="InvoiceDetailItemReferenceRetail">
                        <xsl:if test="$lin/lin/element[@name = 'EN']/@value != ''">
                           <xsl:element name="EANID">
                              <xsl:value-of select="$lin/lin/element[@name = 'EN']/@value"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$lin/lin/element[@name = 'EA']/@value != ''">
                           <xsl:element name="EuropeanWasteCatalogID">
                              <xsl:value-of select="$lin/lin/element[@name = 'EA']/@value"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
            </xsl:element>
            <xsl:if test="S_REF[D_128 = 'RV']/C_C040[D_128_1 = 'LI']/D_127_1 != ''">
               <xsl:element name="ReceiptLineItemReference">
                  <xsl:attribute name="receiptLineNumber"
                     select="S_REF[D_128 = 'RV']/C_C040[D_128_1 = 'LI']/D_127_1"/>
               </xsl:element>
            </xsl:if>
            <!-- IG-716 -->
            <xsl:if test="S_REF[D_128 = 'MA']/C_C040[D_128_1 = 'LI']/D_127_1 != ''">
               <xsl:element name="ShipNoticeLineItemReference">
                  <xsl:attribute name="shipNoticeLineNumber"
                     select="S_REF[D_128 = 'MA']/C_C040[D_128_1 = 'LI']/D_127_1"/>
               </xsl:element>
            </xsl:if>
            <xsl:if
               test="S_REF[D_128 = 'ACE']/D_127 != '' and S_REF[D_128 = 'ACE']/C_C040[D_128_1 = 'LI']/D_127_1 != ''">
               <xsl:element name="ServiceEntryItemReference">
                  <xsl:if test="S_REF[D_128 = 'ACE']/D_127 != ''">
                     <xsl:attribute name="serviceEntryID">
                        <xsl:value-of select="S_REF[D_128 = 'ACE']/D_127"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="serviceLineNumber">
                     <xsl:value-of select="S_REF[D_128 = 'ACE']/C_C040[D_128_1 = 'LI']/D_127_1"/>
                  </xsl:attribute>
                  <xsl:if test="S_DTM[D_374 = '472']/D_373 != ''">
                     <xsl:attribute name="serviceEntryDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="Date" select="S_DTM[D_374 = '472']/D_373"/>
                           <xsl:with-param name="Time" select="S_DTM[D_374 = '472']/D_337"/>
                           <xsl:with-param name="TimeCode" select="S_DTM[D_374 = '472']/D_623"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:element name="DocumentReference">
                     <xsl:attribute name="payloadID"/>
                  </xsl:element>
               </xsl:element>
            </xsl:if>
            <!-- SubtotalAmount-->
            <xsl:if test="S_PAM[D_522 = '1']/D_782 != ''">
               <xsl:element name="SubtotalAmount">
                  <xsl:call-template name="createMoney">
                     <xsl:with-param name="money" select="S_PAM[D_522 = '1']/D_782"/>
                     <xsl:with-param name="Curr" select="$lineCurr"/>
                     <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                     <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  </xsl:call-template>
               </xsl:element>
            </xsl:if>
         </xsl:if>
         <!-- Tax -->
         <xsl:element name="Tax">
            <xsl:call-template name="createMoney">
               <xsl:with-param name="Curr" select="$headerCurr"/>
               <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
               <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               <!--<xsl:with-param name="money" select="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610 div 100"/>-->
               <xsl:with-param name="money"
                  select="xs:decimal(G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610) div xs:decimal(100)"/>
               <xsl:with-param name="altAmt"
                  select="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_127"/>
            </xsl:call-template>
            <xsl:element name="Description">
               <xsl:attribute name="xml:lang">
                  <xsl:choose>
                     <xsl:when test="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_819 != ''">
                        <xsl:value-of select="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_819"/>
                     </xsl:when>
                     <xsl:otherwise>en</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:if test="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_352 != ''">
                  <xsl:value-of select="G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_352"/>
               </xsl:if>
            </xsl:element>
            <xsl:choose>
               <!-- CG: IG-23185 -->
               <xsl:when test="$lineAltCurr = ''">
                  <xsl:for-each select="G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI">
                     <xsl:call-template name="mapTaxDetail">
                        <xsl:with-param name="mainCurrency" select="$lineCurr"/>
                        <xsl:with-param name="alternateCurrency" select="$lineAltCurr"/>
                        <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                        <xsl:with-param name="tpDTM" select="S_DTM[D_374 = '983']"/>
                        <xsl:with-param name="pdDTM" select="S_DTM[D_374 = '814']"/>
                     </xsl:call-template>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each-group select="G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI"
                     group-by="D_963">
                     <xsl:choose>
                        <xsl:when test="count(current-group()) &gt; 1">
                           <xsl:for-each select="current-group()[position() mod 2 = 1]">
                              <xsl:variable name="tc" select="D_963"/>
                              <xsl:variable name="altAmount" select="following-sibling::S_TXI[D_963 = $tc]/D_782"/>
                              <xsl:call-template name="mapTaxDetail">
                                 <xsl:with-param name="mainCurrency" select="$lineCurr"/>
                                 <xsl:with-param name="alternateCurrency" select="$lineAltCurr"/>
                                 <xsl:with-param name="alternateAmount" select="$altAmount"/>
                                 <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                 <xsl:with-param name="tpDTM" select="S_DTM[D_374 = '983']"/>
                                 <xsl:with-param name="pdDTM" select="S_DTM[D_374 = '814']"/>
                              </xsl:call-template>
                           </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                           <!-- CG: IG-23185 -->
                           <xsl:call-template name="mapTaxDetail">
                              <xsl:with-param name="mainCurrency" select="$lineCurr"/>
                              <xsl:with-param name="alternateCurrency" select="$lineAltCurr"/>
                              <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                              <xsl:with-param name="tpDTM" select="S_DTM[D_374 = '983']"/>
                              <xsl:with-param name="pdDTM" select="S_DTM[D_374 = '814']"/>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each-group>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:element>
         <xsl:if test="$itemMode = 'item'">
            <!-- InvoiceDetailLineSpecialHandling -->
            <xsl:if test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610 != ''">
               <xsl:element name="InvoiceDetailLineSpecialHandling">
                  <xsl:if test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_352 != ''">
                     <xsl:element name="Description">
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when
                                 test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_819 != ''">
                                 <xsl:value-of
                                    select="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_819"/>
                              </xsl:when>
                              <xsl:otherwise>en</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_352"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:call-template name="createMoney">
                     <!--<xsl:with-param name="money" select="(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610 div 100)"/>-->
                     <xsl:with-param name="money"
                        select="xs:decimal(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H090']/D_610) div xs:decimal(100)"/>
                     <xsl:with-param name="Curr" select="$lineCurr"/>
                     <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                     <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  </xsl:call-template>
               </xsl:element>
            </xsl:if>
            <!-- InvoiceDetailLineShipping -->
            <xsl:if
               test="G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 != '' and G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST' or S_N1/D_98_1 = 'CA']">
               <xsl:element name="InvoiceDetailLineShipping">
                  <xsl:element name="InvoiceDetailShipping">
                     <xsl:if test="S_DTM[D_374 = '011']/D_373 != ''">
                        <xsl:attribute name="shippingDate">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date" select="S_DTM[D_374 = '011']/D_373"/>
                              <xsl:with-param name="Time" select="S_DTM[D_374 = '011']/D_337"/>
                              <xsl:with-param name="TimeCode" select="S_DTM[D_374 = '011']/D_623"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:if test="G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST']">
                        <xsl:choose>
                           <xsl:when test="G_N1[S_N1/D_98_1 = 'SF'] and G_N1[S_N1/D_98_1 = 'ST']">
                              <xsl:for-each select="G_N1[S_N1/D_98_1 = 'SF' or S_N1/D_98_1 = 'ST']">
                                 <xsl:call-template name="createContact">
                                    <xsl:with-param name="contact" select="."/>
                                 </xsl:call-template>
                              </xsl:for-each>
                           </xsl:when>
                           <xsl:when test="G_N1[S_N1/D_98_1 = 'SF']">
                              <xsl:call-template name="createContact">
                                 <xsl:with-param name="contact" select="G_N1[S_N1/D_98_1 = 'SF']"/>
                              </xsl:call-template>
                              <xsl:element name="Contact">
                                 <xsl:attribute name="role">shipTo</xsl:attribute>
                                 <xsl:element name="Name">
                                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:when>
                           <xsl:when test="G_N1[S_N1/D_98_1 = 'ST']">
                              <xsl:call-template name="createContact">
                                 <xsl:with-param name="contact" select="G_N1[S_N1/D_98_1 = 'ST']"/>
                              </xsl:call-template>
                              <xsl:element name="Contact">
                                 <xsl:attribute name="role">shipFrom</xsl:attribute>
                                 <xsl:element name="Name">
                                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:when>

                        </xsl:choose>


                     </xsl:if>
                     <xsl:if test="G_N1[S_N1/D_98_1 = 'CA']">
                        <xsl:call-template name="createContact">
                           <xsl:with-param name="contact" select="G_N1[S_N1/D_98_1 = 'CA']"/>
                        </xsl:call-template>
                     </xsl:if>

                     <xsl:if
                        test="(G_N1/S_N1/D_98_1 = 'CA' and G_N1[S_N1/D_98_1 = 'SF'][S_REF/D_128 = 'SI'])">

                        <xsl:for-each select="G_N1[S_N1/D_98_1 = 'CA']">
                           <xsl:element name="CarrierIdentifier">
                              <xsl:attribute name="domain">companyName</xsl:attribute>
                              <xsl:value-of select="S_N1/D_93"/>
                           </xsl:element>
                           <xsl:for-each select="S_REF[D_128 = 'CN']">
                              <xsl:element name="CarrierIdentifier">
                                 <xsl:attribute name="domain">
                                    <xsl:choose>
                                       <xsl:when test="D_127 = '1'">DUNS</xsl:when>
                                       <xsl:when test="D_127 = '2'">SCAC</xsl:when>
                                       <xsl:when test="D_127 = '4'">IATA</xsl:when>
                                       <xsl:when test="D_127 = '9'">DUNS+4</xsl:when>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <xsl:value-of select="D_352"/>
                              </xsl:element>
                           </xsl:for-each>
                        </xsl:for-each>
                        <xsl:for-each select="G_N1[S_N1/D_98_1 = 'SF']">
                           <xsl:for-each select="S_REF[D_128 = 'SI']">
                              <xsl:element name="ShipmentIdentifier">
                                 <xsl:if test="D_352 != ''">
                                    <xsl:attribute name="trackingNumberDate">
                                       <xsl:value-of select="D_352"/>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:value-of select="D_127"/>
                              </xsl:element>
                           </xsl:for-each>
                        </xsl:for-each>
                     </xsl:if>
                  </xsl:element>
                  <xsl:call-template name="createMoney">
                     <!--<xsl:with-param name="money" select="(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 div 100)"/>-->
                     <xsl:with-param name="money"
                        select="xs:decimal(G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610) div xs:decimal(100)"/>
                     <xsl:with-param name="Curr" select="$lineCurr"/>
                     <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                     <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  </xsl:call-template>
               </xsl:element>
            </xsl:if>
            <!-- ShipNoticeIDInfo -->
            <!-- IG-27541 - Update to map IdReferences even when shipNoticeID is not present -->
            <xsl:if test="(S_REF[D_128 = 'MA']/D_127 != '') or (S_REF[D_128 = 'RV']/D_127 != '') or (S_REF[D_128 = 'KK']/D_127 != '') or (S_DTM[D_374 = '192']/D_373 != '')">
               <xsl:element name="ShipNoticeIDInfo">
                  <xsl:attribute name="shipNoticeID">
                     <xsl:value-of select="S_REF[D_128 = 'MA']/D_127"/>
                  </xsl:attribute>
                  <xsl:if test="S_DTM[D_374 = '111']/D_373 != ''">
                     <xsl:attribute name="shipNoticeDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="Date">
                              <xsl:value-of select="S_DTM[D_374 = '111']/D_373"/>
                           </xsl:with-param>
                           <xsl:with-param name="Time">
                              <xsl:value-of select="S_DTM[D_374 = '111']/D_337"/>
                           </xsl:with-param>
                           <xsl:with-param name="TimeCode">
                              <xsl:value-of select="S_DTM[D_374 = '111']/D_623"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_REF[D_128 = 'PK']/D_127 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">packListID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="S_REF[D_128 = 'PK']/D_127"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="S_REF[D_128 = 'BM']/D_127 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">freightBillID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="S_REF[D_128 = 'BM']/D_127"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- IG-1738 -->
                  <xsl:if test="S_REF[D_128 = 'KK']/D_127 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">deliveryNoteID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="S_REF[D_128 = 'KK']/D_127"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="S_REF[D_128 = 'RV']/D_127 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">ReceivingAdviceID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="S_REF[D_128 = 'RV']/D_127"/>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <!-- IG-27541 - Added deliveryNoteDate -->
                  <xsl:if test="S_DTM[D_374 = '192']/D_373 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain">deliveryNoteDate</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date">
                                 <xsl:value-of select="S_DTM[D_374 = '192']/D_373"/>
                              </xsl:with-param>
                              <xsl:with-param name="Time">
                                 <xsl:value-of select="S_DTM[D_374 = '192']/D_337"/>
                              </xsl:with-param>
                              <xsl:with-param name="TimeCode">
                                 <xsl:value-of select="S_DTM[D_374 = '192']/D_623"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>                  
               </xsl:element>
            </xsl:if>
         </xsl:if>
         <!-- GrossAmount -->
         <xsl:if test="S_PAM[D_522 = 'KK']/D_782 != ''">
            <xsl:element name="GrossAmount">
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="money" select="S_PAM[D_522 = 'KK']/D_782"/>
                  <xsl:with-param name="Curr" select="$lineCurr"/>
                  <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <!-- InvoiceDetailDiscount -->
         <xsl:if test="G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 != ''">
            <xsl:element name="InvoiceDetailDiscount">
               <xsl:if
                  test="G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310' and D_378 = '3']/D_332 != ''">
                  <xsl:attribute name="percentageRate">
                     <xsl:value-of
                        select="G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310' and D_378 = '3']/D_332"
                     />
                  </xsl:attribute>
               </xsl:if>
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="Curr" select="$lineCurr"/>
                  <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  <!--<xsl:with-param name="money" select="(G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610 div 100)"/>-->
                  <xsl:with-param name="money"
                     select="xs:decimal(G_SAC/S_SAC[D_248 = 'A' and D_1300 = 'C310']/D_610) div xs:decimal(100)"
                  />
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <!-- InvoiceItemModifications -->
         <xsl:if
            test="exists(G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840' and S_SAC/D_331 != '02'])">
            <xsl:element name="InvoiceItemModifications">
               <xsl:for-each
                  select="G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840' and S_SAC/D_331 != '02']">
                  <xsl:variable name="modCode">
                     <xsl:value-of select="S_SAC/D_1300"/>
                  </xsl:variable>
                  <xsl:element name="Modification">
                     <xsl:if test="S_SAC/D_127 != ''">
                        <xsl:element name="OriginalPrice">
                           <xsl:if test="S_SAC/D_770 != ''">
                              <xsl:attribute name="type" select="S_SAC/D_770"/>
                           </xsl:if>
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$headerCurr"/>
                              <xsl:with-param name="AltCurr" select="$headerAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="money" select="S_SAC/D_127"/>
                           </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                     <xsl:choose>
                        <xsl:when test="S_SAC/D_248 = 'A'">
                           <xsl:element name="AdditionalDeduction">
                              <xsl:choose>
                                 <xsl:when test="S_SAC/D_331 = '13' and S_SAC/D_610 != ''">
                                    <xsl:element name="DeductionAmount">
                                       <xsl:call-template name="createMoney">
                                          <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                          <xsl:with-param name="money"
                                             select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:when>
                                 <xsl:when test="S_SAC/D_610 != ''">
                                    <xsl:element name="DeductedPrice">
                                       <xsl:call-template name="createMoney">
                                          <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                          <xsl:with-param name="money"
                                             select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                          <xsl:with-param name="Curr" select="$lineCurr"/>
                                          <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                          <xsl:with-param name="isCreditMemo" select="$isCreditMemo"
                                          />
                                       </xsl:call-template>
                                    </xsl:element>
                                 </xsl:when>
                                 <xsl:when test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
                                    <xsl:element name="DeductionPercent">
                                       <xsl:attribute name="percent">
                                          <xsl:value-of select="S_SAC/D_332"/>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test="S_SAC/D_248 = 'C'">
                           <xsl:element name="AdditionalCost">
                              <xsl:choose>
                                 <xsl:when test="S_SAC/D_610 != ''">
                                    <xsl:call-template name="createMoney">
                                       <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                                       <xsl:with-param name="money"
                                          select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                                       <xsl:with-param name="Curr" select="$lineCurr"/>
                                       <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                                       <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                                    </xsl:call-template>
                                 </xsl:when>
                                 <xsl:when test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
                                    <xsl:element name="Percentage">
                                       <xsl:attribute name="percent">
                                          <xsl:value-of select="S_SAC/D_332"/>
                                       </xsl:attribute>
                                    </xsl:element>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:element>
                        </xsl:when>
                     </xsl:choose>
                     <xsl:if test="exists(S_TXI[D_963 = 'ZZ' or D_963 = 'TX'])">
                        <xsl:element name="Tax">
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="Curr" select="$lineCurr"/>
                              <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                              <xsl:with-param name="money"
                                 select="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_782"/>
                           </xsl:call-template>
                           <xsl:element name="Description">
                              <xsl:attribute name="xml:lang">en</xsl:attribute>
                              <xsl:if test="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_350 != ''">
                                 <xsl:value-of select="S_TXI[D_963 = 'ZZ' or D_963 = 'TX']/D_350"/>
                              </xsl:if>
                           </xsl:element>
                           <xsl:for-each select="S_TXI[D_963 != 'ZZ' and D_963 != 'TX']">
                              <!-- CG: IG-23185 -->
                              <xsl:call-template name="mapTaxDetail">
                                 <xsl:with-param name="mainCurrency" select="$lineCurr"/>
                                 <xsl:with-param name="alternateCurrency" select="$lineAltCurr"/>
                                 <xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
                                 <xsl:with-param name="ignoreTPDate" select="'true'"/>
                              </xsl:call-template>
                           </xsl:for-each>
                        </xsl:element>
                     </xsl:if>
                     <!-- ModificationDetail -->
                     <xsl:if
                        test="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode != ''">
                        <xsl:element name="ModificationDetail">
                           <xsl:attribute name="name">
                              <xsl:value-of
                                 select="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode"
                              />
                           </xsl:attribute>
                           <xsl:if test="S_SAC/D_352 != ''">
                              <xsl:element name="Description">
                                 <xsl:attribute name="xml:lang">
                                    <xsl:choose>
                                       <xsl:when test="S_SAC/D_819 != ''">
                                          <xsl:value-of select="S_SAC/D_819"/>
                                       </xsl:when>
                                       <xsl:otherwise>en</xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <xsl:value-of select="S_SAC/D_352"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:for-each>
            </xsl:element>
         </xsl:if>
         <!-- TotalCharges -->
         <xsl:if test="S_PAM[D_522 = 'GW']/D_782 != ''">
            <xsl:element name="TotalCharges">
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="money" select="S_PAM[D_522 = 'GW']/D_782"/>
                  <xsl:with-param name="Curr" select="$lineCurr"/>
                  <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <!-- TotalAllowances  -->
         <xsl:if test="S_PAM[D_522 = 'EC']/D_782 != ''">
            <xsl:element name="TotalAllowances">
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="money" select="S_PAM[D_522 = 'EC']/D_782"/>
                  <xsl:with-param name="Curr" select="$lineCurr"/>
                  <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <!-- TotalAmountWithoutTax -->
         <xsl:if test="S_PAM[D_522 = 'ZZ']/D_782 != ''">
            <xsl:element name="TotalAmountWithoutTax">
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="money" select="S_PAM[D_522 = 'ZZ']/D_782"/>
                  <xsl:with-param name="Curr" select="$lineCurr"/>
                  <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <!-- NetAmount -->
         <xsl:if test="S_PAM[D_522 = 'N']/D_782 != ''">
            <xsl:element name="NetAmount">
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="money" select="S_PAM[D_522 = 'N']/D_782"/>
                  <xsl:with-param name="Curr" select="$lineCurr"/>
                  <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <!-- Distribution -->
         <xsl:for-each
            select="G_SAC[S_SAC/D_248 = 'N' and S_SAC/D_1300 = 'B840' and S_SAC/D_559 = 'AB' and S_SAC/D_1301 != '']">
            <xsl:element name="Distribution">
               <xsl:element name="Accounting">
                  <xsl:attribute name="name">
                     <xsl:value-of select="S_SAC/D_1301"/>
                  </xsl:attribute>
                  <xsl:element name="AccountingSegment">
                     <xsl:attribute name="id">
                        <xsl:value-of select="S_SAC/D_127"/>
                     </xsl:attribute>
                     <xsl:element name="Name">
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when test="S_SAC/D_819 != ''">
                                 <xsl:value-of select="S_SAC/D_819"/>
                              </xsl:when>
                              <xsl:otherwise>en</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="S_SAC/D_770"/>
                     </xsl:element>
                     <xsl:element name="Description">
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when test="S_SAC/D_819 != ''">
                                 <xsl:value-of select="S_SAC/D_819"/>
                              </xsl:when>
                              <xsl:otherwise>en</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="S_SAC/D_352"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
               <xsl:element name="Charge">
                  <xsl:call-template name="createMoney">
                     <!--<xsl:with-param name="money" select="(S_SAC/D_610 div 100)"/>-->
                     <xsl:with-param name="money"
                        select="xs:decimal(S_SAC/D_610) div xs:decimal(100)"/>
                     <xsl:with-param name="Curr" select="$lineCurr"/>
                     <xsl:with-param name="AltCurr" select="$lineAltCurr"/>
                     <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  </xsl:call-template>
               </xsl:element>
            </xsl:element>
         </xsl:for-each>
         <xsl:if test="S_REF[D_128 = 'PD']/D_127 != ''">
            <xsl:element name="InvoiceDetailItemIndustry">
               <xsl:element name="InvoiceDetailItemRetail">
                  <xsl:element name="PromotionDealID">
                     <xsl:value-of select="S_REF[D_128 = 'PD']/D_127"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <!-- Comments a-->
         <xsl:if test="S_REF[D_128 = 'L1']/D_352 != ''">
            <xsl:element name="Comments">
               <xsl:attribute name="xml:lang">
                  <xsl:choose>
                     <xsl:when test="S_REF[D_128 = 'L1']/D_127 != ''">
                        <xsl:value-of select="S_REF[D_128 = 'L1']/D_127"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>en</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:value-of select="S_REF[D_128 = 'L1']/D_352"/>
            </xsl:element>
         </xsl:if>
         <!-- Extrinsics -->
         <xsl:for-each select="S_REF[D_128 = 'ZZ']">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="D_127"/>
               </xsl:attribute>
               <xsl:value-of select="D_352"/>
            </xsl:element>
         </xsl:for-each>
         <!-- CG: IG-16765 - 1500 Extrinsics -->
         <xsl:if test="$useExtrinsicsLookup = 'yes'">
            <xsl:for-each select="S_REF[D_128 != 'ZZ']">
               <xsl:variable name="refQualVal" select="D_128"/>
               <xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/InvLineEx))][1]/CXMLCode"/>
               <xsl:if test="$extNameL != ''">
                  <xsl:element name="Extrinsic">
                     <xsl:attribute name="name">
                        <xsl:value-of select="$extNameL"/>
                     </xsl:attribute>
                     <xsl:value-of select="concat(D_127,D_352)"/>
                  </xsl:element>
               </xsl:if>
            </xsl:for-each>
         </xsl:if>         
      </xsl:element>
   </xsl:template>
   <xsl:template name="convertToAribaDatePORef">
      <xsl:param name="Date"/>
      <xsl:param name="Time"/>
      <xsl:param name="TimeCode"/>
      <xsl:variable name="timeZone">
         <xsl:choose>
            <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
               <xsl:value-of
                  select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
               />
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="tempDate">
         <xsl:value-of
            select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
         />
      </xsl:variable>
      <xsl:variable name="tempTime">
         <xsl:choose>
            <xsl:when test="$Time != '' and string-length($Time) = 6">
               <xsl:value-of
                  select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
               />
            </xsl:when>
            <xsl:when test="$Time != '' and string-length($Time) = 4">
               <xsl:value-of
                  select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2))"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$tempTime = ''">
            <xsl:value-of select="''"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat($tempDate, $tempTime, $timeZone)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="createLIN">
      <xsl:param name="LIN"/>
      <lin>
         <xsl:for-each select="$LIN/*[starts-with(name(), 'D_23')]">
            <xsl:if test="starts-with(name(), 'D_235')">
               <element>
                  <xsl:attribute name="name">
                     <xsl:value-of select="normalize-space(.)"/>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                     <xsl:value-of
                        select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"
                     />
                  </xsl:attribute>
               </element>
            </xsl:if>
         </xsl:for-each>
      </lin>
   </xsl:template>
   <!-- IG-5742 -->
   <xsl:template name="LegalStatus">
      <xsl:param name="REG"/>
      <xsl:element name="Extrinsic">
         <xsl:attribute name="name">
            <xsl:text>LegalStatus</xsl:text>
         </xsl:attribute>
         <xsl:value-of select="$REG"/>
      </xsl:element>
   </xsl:template>
   <xsl:template name="LegalCapital">
      <xsl:param name="CBH"/>
      <xsl:element name="Extrinsic">
         <xsl:attribute name="name">
            <xsl:text>LegalCapital</xsl:text>
         </xsl:attribute>
         <xsl:variable name="val1" select="normalize-space($CBH)"/>
         <xsl:element name="Money">
            <xsl:attribute name="currency">
               <xsl:value-of select="substring($val1, string-length($val1) - 2)"/>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(substring($val1, 1, string-length($val1) - 3))"/>
         </xsl:element>
      </xsl:element>
   </xsl:template>
   
   <!-- IG-23185 -->
   <xsl:template name="mapTaxDetail">
      <xsl:param name="mainCurrency"/>
      <xsl:param name="alternateCurrency"/>
      <xsl:param name="creditMemoFlag"/>
      <xsl:param name="alternateAmount" required="no"/>
      <xsl:param name="ignoreTPDate" required="no"></xsl:param>
      <xsl:param name="tpDTM" required="no"/>
      <xsl:param name="pdDTM" required="no"/>
      
      <xsl:variable name="taxCategory">
         <xsl:choose>
            <xsl:when test="D_963 = 'PG' or D_963 = 'PS' or D_963 = 'ST'">
               <xsl:choose>
                  <xsl:when test="contains(D_956, '.qc.ca')">
                     <xsl:text>qst</xsl:text>
                  </xsl:when>
                  <!-- IG-16906 - Added .pe.ca value -->
                  <xsl:when test="contains(D_956, '.ns.ca') or contains(D_956, '.nf.ca') or contains(D_956, '.nb.ca') or contains(D_956, '.on.ca') or contains(D_956, '.pe.ca')">
                     <xsl:text>hst</xsl:text>
                  </xsl:when>
                  <xsl:when test="contains(D_956, '.ca')">
                     <xsl:text>pst</xsl:text>
                  </xsl:when>
                  <xsl:when test="D_963 = 'PG' or D_963 = 'PS'">
                     <xsl:text>other</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>sales</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="D_963 = 'VA'">
               <xsl:text>vat</xsl:text>
            </xsl:when>
            <xsl:when test="D_963 = 'CG' or D_963 = 'CV' or D_963 = 'GS'">
               <xsl:text>gst</xsl:text>
            </xsl:when>
            <xsl:when test="D_963 = 'LT' or D_963 = 'LS'">
               <xsl:text>sales</xsl:text>
            </xsl:when>
            <xsl:when test="D_963 = 'ZC' or D_963 = 'UT' or D_963 = 'TT' or D_963 = 'SE' or D_963 = 'FD'">
               <xsl:text>usage</xsl:text>
            </xsl:when>
            <xsl:when test="D_963 = 'FI'">
               <xsl:text>withholdingTax</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>other</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:element name="TaxDetail">
         <xsl:attribute name="purpose">
            <xsl:text>tax</xsl:text>
         </xsl:attribute>
         <xsl:attribute name="category">
            <xsl:choose>
               <xsl:when test="D_325 != ''">
                  <xsl:value-of select="D_325"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$taxCategory"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:if test="$taxCategory = 'withholdingTax'">
            <xsl:attribute name="isWithholdingTax">
               <xsl:text>yes</xsl:text>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="D_954 != ''">
            <xsl:attribute name="percentageRate">
               <xsl:value-of select="D_954"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="$taxCategory = 'vat' and $ignoreTPDate != 'true'">
            <xsl:variable name="tpDate" select="$tpDTM/D_373"/>
            <xsl:variable name="tpTime" select="$tpDTM/D_337"/>
            <xsl:variable name="tpTimeCode" select="$tpDTM/D_623"/>
            <xsl:variable name="pdDate" select="$pdDTM/D_373"/>
            <xsl:variable name="pdTime" select="$pdDTM/D_337"/>
            <xsl:variable name="pdTimeCode" select="$pdDTM/D_623"/>
            
            <xsl:choose>
               <xsl:when test="$tpDate != ''">
                  <xsl:attribute name="taxPointDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="Date" select="$tpDate"/>
                        <xsl:with-param name="Time" select="$tpTime"/>
                        <xsl:with-param name="TimeCode" select="$tpTimeCode"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="string-length(D_350) = 16 or string-length(D_350) &lt; 16">
                  <xsl:variable name="dt" select="concat(substring(D_350, 1, 4), '-', substring(D_350, 5, 2), '-', substring(D_350, 7, 2), 'T', substring(D_350, 9, 2), ':', substring(D_350, 11, 2), ':', substring(D_350, 13, 2))"/>
                  <xsl:variable name="dt1" select="concat(substring(D_350, 1, 4), '-', substring(D_350, 5, 2), '-', substring(D_350, 7, 2))"/>
                  <xsl:choose>
                     <xsl:when test="$dt castable as xs:dateTime">
                        <xsl:attribute name="taxPointDate">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date" select="substring(D_350, 1, 8)"/>
                              <xsl:with-param name="Time" select="substring(D_350, 9, 6)"/>
                              <xsl:with-param name="TimeCode" select="substring(D_350, 14, 2)"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:when>
                     <xsl:when test="$dt1 castable as xs:date">
                        <xsl:attribute name="taxPointDate">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="Date" select="substring(D_350, 1, 8)"/>
                              <xsl:with-param name="Time" select="substring(D_350, 9, 6)"/>
                              <xsl:with-param name="TimeCode" select="substring(D_350, 14, 2)"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:when>
                  </xsl:choose>
               </xsl:when>
               
            </xsl:choose>
            <xsl:if test="$pdDate != ''">
               <xsl:attribute name="paymentDate">
                  <xsl:call-template name="convertToAribaDate">
                     <xsl:with-param name="Date" select="$pdDate"/>
                     <xsl:with-param name="Time" select="$pdTime"/>
                     <xsl:with-param name="TimeCode" select="$pdTimeCode"/>
                  </xsl:call-template>
               </xsl:attribute>
            </xsl:if>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="D_441 = '0'">
               <xsl:attribute name="exemptDetail">
                  <xsl:text>zeroRated</xsl:text>
               </xsl:attribute>
            </xsl:when>
            <xsl:when test="D_441 = '2'">
               <xsl:attribute name="exemptDetail">
                  <xsl:text>exempt</xsl:text>
               </xsl:attribute>
            </xsl:when>
         </xsl:choose>
         <!-- TaxableAmount -->
         <xsl:if test="D_828 != ''">
            <xsl:element name="TaxableAmount">
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="Curr" select="$mainCurrency"/>
                  <xsl:with-param name="AltCurr" select="$alternateCurrency"/>
                  <xsl:with-param name="isCreditMemo" select="$creditMemoFlag"/>
                  <xsl:with-param name="money" select="D_828"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <xsl:element name="TaxAmount">
            <xsl:call-template name="createMoney">
               <xsl:with-param name="Curr" select="$mainCurrency"/>
               <xsl:with-param name="AltCurr" select="$alternateCurrency"/>
               <xsl:with-param name="altAmt" select="$alternateAmount"/>
               <xsl:with-param name="isCreditMemo" select="$creditMemoFlag"/>
               <xsl:with-param name="money" select="D_782"/>
            </xsl:call-template>
         </xsl:element>
         <!-- TaxLocation -->
         <xsl:if test="D_955 = 'VD' and D_956 != ''">
            <xsl:element name="TaxLocation">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
               <xsl:value-of select="D_956"/>
            </xsl:element>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="D_441 = '0' and $taxCategory = 'vat'">
               <xsl:element name="Description">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
                  <xsl:value-of select="'Zero rated tax'"/>
               </xsl:element>
            </xsl:when>
            <xsl:when test="D_441 = '0' and not(exists(D_350))">
               <xsl:element name="Description">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
                  <xsl:value-of select="'Zero rated tax'"/>
               </xsl:element>
            </xsl:when>
            <xsl:when test="D_350 != ''">
               <xsl:element name="Description">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
                  <xsl:value-of select="D_350"/>
               </xsl:element>
            </xsl:when>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
