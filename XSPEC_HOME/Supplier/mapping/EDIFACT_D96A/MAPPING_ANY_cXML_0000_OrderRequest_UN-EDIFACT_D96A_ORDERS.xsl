<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output indent="yes" omit-xml-declaration="yes"/>
   <!-- For local testing -->
   <!--<xsl:variable name="Lookup" select="document('LOOKUP_UN-EDIFACT_D96A.xml')"/>
   <xsl:include href="FORMAT_cXML_0000_UN-EDIFACT_D96A.xsl"/>-->
   <xsl:include href="FORMAT_cXML_0000_UN-EDIFACT_D96A.xsl"/>
   <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>
  
   <xsl:param name="anISASender"/>
   <xsl:param name="anISASenderQual"/>
   <xsl:param name="anISAReceiver"/>
   <xsl:param name="anISAReceiverQual"/>
   <xsl:param name="anDate"/>
   <xsl:param name="anTime"/>
   <xsl:param name="anICNValue"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="anSenderGroupID"/>
   <xsl:param name="anReceiverGroupID"/>
   <xsl:template match="/">
      <xsl:variable name="dateNow" select="current-dateTime()"/>
      <ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:orders:d.96a">
         <S_UNA>:+.? '</S_UNA>
         <S_UNB>
            <C_S001>
               <D_0001>UNOC</D_0001>
               <D_0002>3</D_0002>
            </C_S001>
            <C_S002>
               <D_0004>
                  <xsl:value-of select="$anISASender"/>
               </D_0004>
               <D_0007>
                  <xsl:value-of select="$anISASenderQual"/>
               </D_0007>
               <D_0008>
                  <xsl:value-of select="$anSenderGroupID"/>
               </D_0008>
            </C_S002>
            <C_S003>
               <D_0010>
                  <xsl:value-of select="$anISAReceiver"/>
               </D_0010>
               <D_0007>
                  <xsl:value-of select="$anISAReceiverQual"/>
               </D_0007>
               <D_0014>
                  <xsl:value-of select="$anReceiverGroupID"/>
               </D_0014>
            </C_S003>
            <C_S004>
               <D_0017>
                  <xsl:value-of select="format-dateTime($dateNow, '[Y01][M01][D01]')"/>
               </D_0017>
               <D_0019>
                  <xsl:value-of select="format-dateTime($dateNow, '[H01][M01]')"/>
               </D_0019>
            </C_S004>
            <D_0020>
               <xsl:value-of select="$anICNValue"/>
            </D_0020>
            <D_0026>ORDERS</D_0026>
            <xsl:if test="upper-case($anEnvName) = 'TEST'">
               <D_0035>1</D_0035>
            </xsl:if>
         </S_UNB>
         <xsl:element name="M_ORDERS">
            <S_UNH>
               <D_0062>0001</D_0062>
               <C_S009>
                  <D_0065>ORDERS</D_0065>
                  <D_0052>D</D_0052>
                  <D_0054>96A</D_0054>
                  <D_0051>UN</D_0051>
               </C_S009>
            </S_UNH>
            <S_BGM>
               <xsl:variable name="ordType">
                  <xsl:choose>
                     <xsl:when
                        test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'dropship'"
                        >dropship</xsl:when>
                     <xsl:when
                        test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'rushorder'"
                        >rushorder</xsl:when>
                     <xsl:when
                        test="cXML/Request/OrderRequest/OrderRequestHeader/@isInternalVersion = 'yes'"
                        >internal</xsl:when>
                     <xsl:when
                        test="cXML/Request/OrderRequest/OrderRequestHeader/@orderType = 'release'"
                        >release</xsl:when>
                     <xsl:when
                        test="cXML/Request/OrderRequest/OrderRequestHeader/@orderType = 'blanket'"
                        >blanket</xsl:when>
                     <xsl:otherwise>regular</xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:if test="$ordType != ''">
                  <C_C002>
                     <D_1001>
                        <xsl:value-of
                           select="$Lookup/Lookups/OrderTypes/OrderType[CXMLCode = $ordType]/EDIFACTCode"
                        />
                     </D_1001>
                     <D_1000>
                        <xsl:value-of
                           select="$Lookup/Lookups/OrderTypes/OrderType[CXMLCode = $ordType]/Description"
                        />
                     </D_1000>
                  </C_C002>
               </xsl:if>
               <D_1004>
                  <xsl:value-of
                     select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 35)"
                  />
               </D_1004>
               <xsl:variable name="oType"
                  select="cXML/Request/OrderRequest/OrderRequestHeader/@type"/>
               <xsl:if
                  test="$oType != '' and $Lookup/Lookups/OrderActionTypes/OrderActionType[CXMLCode = $oType]/EDIFACTCode != ''">
                  <D_1225>
                     <xsl:choose>
                        <xsl:when
                           test="$Lookup/Lookups/OrderActionTypes/OrderActionType[CXMLCode = $oType]/EDIFACTCode != ''">
                           <xsl:value-of
                              select="$Lookup/Lookups/OrderActionTypes/OrderActionType[CXMLCode = $oType]/EDIFACTCode"
                           />
                        </xsl:when>
                        <xsl:otherwise>9</xsl:otherwise>
                     </xsl:choose>
                  </D_1225>
               </xsl:if>
               <D_4343>AB</D_4343>
            </S_BGM>
            <!-- Order Date -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>4</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate)"
                        />
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <!-- effectiveDate -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>7</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate)"
                        />
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <!-- expirationDate -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>36</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate)"
                        />
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <!-- pickUpDate -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>200</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate)"
                        />
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <!-- requestedDeliveryDate -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>2</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate)"
                        />
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <!-- DeliveryPeriod Start Date-->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>64</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate)"
                        />
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <!-- DeliveryPeriod End Date-->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>63</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate)"
                        />
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <!-- Comments -->
            <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Comments">
               <xsl:variable name="varComments" select="normalize-space(.)"/>
               <xsl:variable name="iteration">
                  <xsl:value-of select="position()"/>
               </xsl:variable>
               <xsl:choose>
                  <!-- always first Comment to AAI -->
                  <xsl:when test="$varComments != '' and $iteration eq '1'">
                     <xsl:call-template name="FTXLoop">
                        <xsl:with-param name="FTXData" select="$varComments"/>
                        <xsl:with-param name="FTXQual" select="'AAI'"/>
                        <xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
                     </xsl:call-template>
                  </xsl:when>
                  <!-- After 1st comment, following  comments should go to ACB. and If '@type' is null pass space value. to create first D_4440-->
                  <xsl:when test="$varComments != '' and $iteration gt '1'">
                     <xsl:variable name="ACBtype">
                        <xsl:choose>
                           <xsl:when test="@type = '' or not(exists(@type))">
                              <xsl:text>  </xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="normalize-space(@type)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:call-template name="FTXLoop">
                        <xsl:with-param name="FTXData" select="$varComments"/>
                        <xsl:with-param name="domain" select="$ACBtype"/>
                        <xsl:with-param name="FTXQual" select="'ACB'"/>
                        <xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
                     </xsl:call-template>
                  </xsl:when>
               </xsl:choose>
            </xsl:for-each>

            <!--  Extrinsic -->
            <xsl:for-each
               select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name != 'hideUnitPrice' and @name != 'hideAmount']">
               <xsl:if test="normalize-space(./@name) != ''">
                  <xsl:call-template name="FTXExtrinsic">
                     <xsl:with-param name="FTXName" select="./@name"/>
                     <xsl:with-param name="FTXData" select="normalize-space(.)"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:for-each>
            <!--  Shipping Instruction Description -->
            <xsl:variable name="SIDesc"
               select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description)"/>
            <xsl:if test="$SIDesc != ''">
               <xsl:call-template name="FTXLoop">
                  <xsl:with-param name="FTXData" select="$SIDesc"/>
                  <xsl:with-param name="FTXQual" select="'TDT'"/>
                  <xsl:with-param name="langCode"
                     select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description/@xml:lang)"
                  />
               </xsl:call-template>
            </xsl:if>
            <!--  Tax Description -->
            <xsl:variable name="TaxDesc"
               select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Tax/Description)"/>
            <xsl:if test="$TaxDesc != ''">
               <xsl:call-template name="FTXLoop">
                  <xsl:with-param name="FTXData" select="$TaxDesc"/>
                  <xsl:with-param name="FTXQual" select="'TXD'"/>
                  <xsl:with-param name="langCode"
                     select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Tax/Description/@xml:lang)"
                  />
               </xsl:call-template>
            </xsl:if>
            <!-- IG-1471 start-->
            <xsl:if
               test="normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@level) != ''">
               <S_FTX>
                  <D_4451>PRI</D_4451>
                  <C_C108>
                     <D_4440>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@level), 1, 70)"
                        />
                     </D_4440>
                     <xsl:if
                        test="normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/Priority/Description) != ''">
                        <D_4440_2>
                           <xsl:value-of
                              select="substring(normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/Priority/Description), 1, 70)"
                           />
                        </D_4440_2>
                     </xsl:if>
                     <xsl:if
                        test="normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@sequence) != ''">
                        <D_4440_3>
                           <xsl:value-of
                              select="substring(normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@sequence), 1, 70)"
                           />
                        </D_4440_3>
                     </xsl:if>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType/@documentType) != ''">
               <S_FTX>
                  <D_4451>DOC</D_4451>
                  <C_C107>
                     <D_4441>EXT</D_4441>
                  </C_C107>
                  <C_C108>
                     <D_4440>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType/@documentType), 1, 70)"
                        />
                     </D_4440>
                     <xsl:if
                        test="normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType/Description) != ''">
                        <D_4440_2>
                           <xsl:value-of
                              select="substring(normalize-space(//OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType/Description), 1, 70)"
                           />
                        </D_4440_2>
                     </xsl:if>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/ControlKeys/OCInstruction/@value) != ''">
               <S_FTX>
                  <D_4451>SIN</D_4451>
                  <C_C108>
                     <D_4440>OCValue</D_4440>
                     <D_4440_2>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/ControlKeys/OCInstruction/@value), 1, 70)"
                        />
                     </D_4440_2>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit) != ''">
               <S_FTX>
                  <D_4451>SIN</D_4451>
                  <C_C108>
                     <D_4440>OCLowerTimeToleranceInDays</D_4440>
                     <D_4440_2>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit), 1, 70)"
                        />
                     </D_4440_2>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit) != ''">
               <S_FTX>
                  <D_4451>SIN</D_4451>
                  <C_C108>
                     <D_4440>OCUpperTimeToleranceInDays</D_4440>
                     <D_4440_2>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit), 1, 70)"
                        />
                     </D_4440_2>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/ControlKeys/ASNInstruction/@value) != ''">
               <S_FTX>
                  <D_4451>SIN</D_4451>
                  <C_C108>
                     <D_4440>ASNValue</D_4440>
                     <D_4440_2>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/ControlKeys/ASNInstruction/@value), 1, 70)"
                        />
                     </D_4440_2>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/ControlKeys/InvoiceInstruction/@value) != ''">
               <S_FTX>
                  <D_4451>SIN</D_4451>
                  <C_C108>
                     <D_4440>INVValue</D_4440>
                     <D_4440_2>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/ControlKeys/InvoiceInstruction/@value), 1, 70)"
                        />
                     </D_4440_2>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/ControlKeys/SESInstruction/@value) != ''">
               <S_FTX>
                  <D_4451>SIN</D_4451>
                  <C_C108>
                     <D_4440>SESValue</D_4440>
                     <D_4440_2>
                        <xsl:value-of
                           select="substring(normalize-space(//OrderRequestHeader/ControlKeys/SESInstruction/@value), 1, 70)"
                        />
                     </D_4440_2>
                  </C_C108>
               </S_FTX>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other' or @value = 'other']) != ''">
               <xsl:call-template name="FTXLoopNoLang">
                  <xsl:with-param name="FTXData"
                     select="normalize-space(//OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other' or @value = 'other'])"/>
                  <xsl:with-param name="FTXQual" select="'AAR'"/>
                  <xsl:with-param name="FTXsubQual" select="'TDC'"/>
               </xsl:call-template>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod[@value = 'Other' or @value = 'other']) != ''">
               <xsl:call-template name="FTXLoopNoLang">
                  <xsl:with-param name="FTXData"
                     select="normalize-space(//OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod[@value = 'Other' or @value = 'other'])"/>
                  <xsl:with-param name="FTXQual" select="'AAR'"/>
                  <xsl:with-param name="FTXsubQual" select="'SPM'"/>
               </xsl:call-template>
            </xsl:if>
            <xsl:if
               test="normalize-space(//OrderRequestHeader/TermsOfDelivery/TransportTerms[@value = 'Other' or @value = 'other']) != ''">
               <xsl:call-template name="FTXLoopNoLang">
                  <xsl:with-param name="FTXData"
                     select="normalize-space(//OrderRequestHeader/TermsOfDelivery/TransportTerms[@value = 'Other' or @value = 'other'])"/>
                  <xsl:with-param name="FTXQual" select="'AAR'"/>
                  <xsl:with-param name="FTXsubQual" select="'TTC'"/>
               </xsl:call-template>
            </xsl:if>
            <!-- IG-1471 end-->
            <!-- hideUnitPrice -->
            <xsl:variable name="hideUnitPriceHdr">
               <xsl:if
                  test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideUnitPrice']">
                  <xsl:text>yes</xsl:text>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="hideAmtHdr">
               <xsl:if
                  test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideAmount']">
                  <xsl:text>yes</xsl:text>
               </xsl:if>
            </xsl:variable>
            <!-- requisitionID -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>AGI</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- releaseRequired -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@releaseRequired) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>RE</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@releaseRequired), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- agreementID -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>CT</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- parentAgreementID -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>BC</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- payloadID                 <xsl:if test="cXML/@payloadID !=''"><xsl:call-template name="mapPayloadID"><xsl:with-param name="payloadID" select="normalize-space(cXML/@payloadID)"/><xsl:with-param name="payloadQUAL" select="'IL'"/></xsl:call-template></xsl:if>-->
            <!-- OrderID and orderDate -->
            <G_SG1>
               <S_RFF>
                  <C_C506>
                     <D_1153>ON</D_1153>
                     <D_1154>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderID"
                        />
                     </D_1154>
                     <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion != ''">
                        <D_4000>
                           <xsl:value-of
                              select="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion"/>
                        </D_4000>
                     </xsl:if>
                  </C_C506>
               </S_RFF>
               <S_DTM>
                  <C_C507>
                     <D_2005>4</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="cXML/Request/OrderRequest/OrderRequestHeader/@orderDate"/>
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </G_SG1>
            <!-- Supplier OrderID and orderDate -->
            <xsl:if
               test="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>VN</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
                  <xsl:if
                     test="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderDate != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>4</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate"
                                 select="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderDate"
                              />
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
               </G_SG1>
            </xsl:if>
            <!-- CustomerReferenceID -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>CR</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- UltimateCustomerReferenceID -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'UltimateCustomerReferenceID']/@identifier) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>UC</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'UltimateCustomerReferenceID']/@identifier), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- AdditionalReferenceID -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'AdditionalReferenceID']/@identifier) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>ACD</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'AdditionalReferenceID']/@identifier), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- governmentNumber -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'governmentNumber']/@identifier) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>GN</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'governmentNumber']/@identifier), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- Pcard -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@number) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>AIU</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@number), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
                  <!-- Payment Pay card Expiration Date -->
                  <xsl:if
                     test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@expiration) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>36</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate"
                                 select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@expiration)"
                              />
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
               </G_SG1>
            </xsl:if>
            <!-- AribaNetworkID -->
            <xsl:if
               test="normalize-space(cXML/Header/From/Credential[@domain = 'AribaNetworkID']/Identity) != ''">
               <G_SG1>
                  <S_RFF>
                     <C_C506>
                        <D_1153>IT</D_1153>
                        <D_1154>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Header/From/Credential[@domain = 'AribaNetworkID']/Identity), 1, 35)"
                           />
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG1>
            </xsl:if>
            <!-- IG-1471 start -->
            <xsl:for-each
               select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail[lower-case(normalize-space(@isTriangularTransaction)) = 'yes']">
               <xsl:if test="normalize-space(Description) != ''">
                  <G_SG1>
                     <S_RFF>
                        <C_C506>
                           <D_1153>VA</D_1153>
                           <D_1154>
                              <xsl:value-of select="substring(normalize-space(Description), 1, 35)"
                              />
                           </D_1154>
                        </C_C506>
                     </S_RFF>
                     <xsl:if test="normalize-space(@taxPointDate) != ''">
                        <S_DTM>
                           <C_C507>
                              <D_2005>131</D_2005>
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="normalize-space(@taxPointDate)"/>
                              </xsl:call-template>
                           </C_C507>
                        </S_DTM>
                     </xsl:if>
                     <xsl:if test="normalize-space(@paymentDate) != ''">
                        <S_DTM>
                           <C_C507>
                              <D_2005>140</D_2005>
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="normalize-space(@paymentDate)"/>
                              </xsl:call-template>
                           </C_C507>
                        </S_DTM>
                     </xsl:if>
                  </G_SG1>
               </xsl:if>
            </xsl:for-each>
            <!-- IG-1471 end -->
            <!-- Bill To -->
            <G_SG2>
               <xsl:call-template name="createNAD">
                  <xsl:with-param name="Address"
                     select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address"/>
                  <xsl:with-param name="role" select="'billTo'"/>
               </xsl:call-template>
               <xsl:call-template name="CTACOMLoop">
                  <xsl:with-param name="contact"
                     select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address"/>
                  <xsl:with-param name="contactType" select="'BillTo'"/>
               </xsl:call-template>
            </G_SG2>
            <!-- Ship To -->
            <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo">
               <G_SG2>
                  <xsl:call-template name="createNAD">
                     <xsl:with-param name="Address"
                        select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
                     <xsl:with-param name="role" select="'shipTo'"/>
                  </xsl:call-template>
                  <xsl:call-template name="CTACOMLoop">
                     <xsl:with-param name="contact"
                        select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
                     <xsl:with-param name="contactType" select="'ShipTo'"/>
                  </xsl:call-template>
               </G_SG2>
            </xsl:if>
            <!-- TermsOfDelivery -->
            <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address">
               <G_SG2>
                  <xsl:call-template name="createNAD">
                     <xsl:with-param name="Address"
                        select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address"/>
                     <xsl:with-param name="role" select="'deliveryParty'"/>
                  </xsl:call-template>
                  <xsl:call-template name="CTACOMLoop">
                     <xsl:with-param name="contact"
                        select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address"/>
                     <xsl:with-param name="contactType" select="'TermsOfDelivery'"/>
                  </xsl:call-template>
               </G_SG2>
            </xsl:if>
            <!-- Contact -->
            <xsl:for-each
               select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[96 &gt;= position()]">
               <G_SG2>
                  <xsl:call-template name="createNAD">
                     <xsl:with-param name="Address" select="."/>
                     <xsl:with-param name="role" select="@role"/>
                  </xsl:call-template>
                  <xsl:call-template name="CTACOMLoop">
                     <xsl:with-param name="contact" select="."/>
                     <xsl:with-param name="contactType" select="@role"/>
                     <xsl:with-param name="ContactDepartmentID"
                        select="IdReference[@domain = 'ContactDepartmentID']/@identifier"/>
                     <xsl:with-param name="ContactPerson"
                        select="IdReference[@domain = 'ContactPerson']/@identifier"/>
                  </xsl:call-template>
               </G_SG2>
            </xsl:for-each>
            <!-- OrderRequestHeader/Tax/TaxDetail -->
            <xsl:for-each
               select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail[5 &gt;= position()]">
               <G_SG6>
                  <S_TAX>
                     <D_5283>
                        <xsl:choose>
                           <xsl:when test="@purpose = 'duty'">5</xsl:when>
                           <xsl:otherwise>7</xsl:otherwise>
                        </xsl:choose>
                     </D_5283>
                     <C_C241>
                        <D_5153>
                           <xsl:choose>
                              <xsl:when test="@category = 'sales'">LOC</xsl:when>
                              <xsl:when test="@category = 'usage'">FRE</xsl:when>
                              <xsl:when test="@category = 'vat'">VAT</xsl:when>
                              <xsl:when test="@category = 'gst'">GST</xsl:when>
                              <xsl:otherwise>OTH</xsl:otherwise>
                           </xsl:choose>
                        </D_5153>
                        <xsl:if test="TaxLocation != ''">
                           <D_5152>
                              <xsl:value-of select="TaxLocation"/>
                           </D_5152>
                        </xsl:if>
                     </C_C241>
                     <xsl:if test="normalize-space(@isVatRecoverable) != ''">
                        <C_C533>
                           <D_5289>
                              <xsl:value-of select="normalize-space(@isVatRecoverable)"/>
                           </D_5289>
                        </C_C533>
                     </xsl:if>
                     <xsl:if
                        test="normalize-space(replace(normalize-space(TaxableAmount/Money), ',', '')) != ''">
                        <D_5286>
                           <xsl:choose>
                              <xsl:when test="$hideAmtHdr = 'yes'">0.00</xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of
                                    select="normalize-space(replace(normalize-space(TaxableAmount/Money), ',', ''))"
                                 />
                              </xsl:otherwise>
                           </xsl:choose>
                        </D_5286>
                     </xsl:if>
                     <xsl:if
                        test="normalize-space(@isTriangularTransaction) != '' or normalize-space(@percentageRate) != ''">
                        <C_C243>
                           <xsl:if test="normalize-space(@isTriangularTransaction) != ''">
                              <D_5279>TT</D_5279>
                           </xsl:if>
                           <xsl:if test="normalize-space(@percentageRate) != ''">
                              <D_5278>
                                 <xsl:value-of select="normalize-space(@percentageRate)"/>
                              </D_5278>
                           </xsl:if>
                        </C_C243>
                     </xsl:if>
                     <xsl:choose>
                        <xsl:when
                           test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'exemptType']) = 'Mixed'">
                           <D_5305>A</D_5305>
                        </xsl:when>
                        <xsl:when
                           test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'exemptType']) = 'Standard'">
                           <D_5305>S</D_5305>
                        </xsl:when>
                        <xsl:when test="normalize-space(@exemptDetail) != ''">
                           <D_5305>
                              <xsl:choose>
                                 <xsl:when
                                    test="lower-case(normalize-space(@exemptDetail)) = 'exempt'"
                                    >E</xsl:when>
                                 <xsl:when
                                    test="lower-case(normalize-space(@exemptDetail)) = 'zerorated'"
                                    >Z</xsl:when>
                              </xsl:choose>
                           </D_5305>
                        </xsl:when>
                     </xsl:choose>
                     <xsl:if
                        test="normalize-space(@isTriangularTransaction) = 'yes' and normalize-space(Description) != ''">
                        <D_3446>
                           <xsl:value-of select="substring(normalize-space(Description), 1, 20)"/>
                        </D_3446>
                     </xsl:if>
                  </S_TAX>
                  <xsl:call-template name="createMOA">
                     <xsl:with-param name="qual" select="'124'"/>
                     <xsl:with-param name="money" select="TaxAmount"/>
                     <xsl:with-param name="hideAmt" select="$hideAmtHdr"/>
                  </xsl:call-template>
               </G_SG6>
            </xsl:for-each>
            <!-- Total/@currency -->
            <G_SG7>
               <S_CUX>
                  <C_C504>
                     <D_6347>2</D_6347>
                     <D_6345>
                        <xsl:value-of
                           select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency"
                        />
                     </D_6345>
                     <D_6343>9</D_6343>
                  </C_C504>
                  <xsl:if
                     test="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency != ''">
                     <C_C504_2>
                        <D_6347>3</D_6347>
                        <D_6345>
                           <xsl:value-of
                              select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency"
                           />
                        </D_6345>
                        <D_6343>7</D_6343>
                     </C_C504_2>
                  </xsl:if>
               </S_CUX>
            </G_SG7>
            <!-- PaymentTerm Loop -->
            <xsl:for-each
               select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[10 &gt;= position()]">
               <G_SG8>
                  <S_PAT>
                     <D_4279>
                        <xsl:choose>
                           <xsl:when test="exists(Discount)">22</xsl:when>
                           <xsl:otherwise>20</xsl:otherwise>
                        </xsl:choose>
                     </D_4279>
                     <C_C112>
                        <D_2475>5</D_2475>
                        <D_2009>3</D_2009>
                        <D_2151>D</D_2151>
                        <xsl:if test="@payInNumberOfDays">
                           <D_2152>
                              <xsl:value-of select="@payInNumberOfDays"/>
                           </D_2152>
                        </xsl:if>
                     </C_C112>
                  </S_PAT>
                  <S_PCD>
                     <C_C501>
                        <D_5245>
                           <xsl:choose>
                              <xsl:when test="exists(Discount)">12</xsl:when>
                              <xsl:otherwise>15</xsl:otherwise>
                           </xsl:choose>
                        </D_5245>
                        <D_5482>
                           <xsl:choose>
                              <xsl:when test="Discount/DiscountPercent/@percent != ''">
                                 <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                              </xsl:when>
                              <xsl:otherwise>0</xsl:otherwise>
                           </xsl:choose>
                        </D_5482>
                        <D_5249>13</D_5249>
                     </C_C501>
                  </S_PCD>
                  <xsl:if test="Discount/DiscountAmount/Money != ''">
                     <xsl:call-template name="createMOA">
                        <xsl:with-param name="qual" select="'52'"/>
                        <xsl:with-param name="money" select="Discount/DiscountAmount"/>
                        <xsl:with-param name="hideAmt" select="$hideAmtHdr"/>
                     </xsl:call-template>
                  </xsl:if>
               </G_SG8>
            </xsl:for-each>
            <!-- ShipTo - TransportationInformation -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/Route/@method) != ''">
               <xsl:for-each
                  select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation[10 &gt;= position()]">
                  <xsl:variable name="route" select="normalize-space(Route/@method)"/>
                  <xsl:if
                     test="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $route]/EDIFACTCode != ''">
                     <G_SG9>
                        <S_TDT>
                           <D_8051>20</D_8051>
                           <C_C220>
                              <D_8067>
                                 <xsl:value-of
                                    select="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $route]/EDIFACTCode"
                                 />
                              </D_8067>
                              <D_8066>
                                 <xsl:value-of select="substring(normalize-space($route), 1, 17)"/>
                              </D_8066>
                           </C_C220>
                           <!-- IG-1471 start -->
                           <xsl:if test="normalize-space(Route/@means) != ''">
                              <C_C228>
                                 <D_8178>
                                    <xsl:value-of
                                       select="substring(normalize-space(Route/@means), 1, 17)"/>
                                 </D_8178>
                              </C_C228>
                           </xsl:if>
                           <!-- IG-1471 end -->
                           <xsl:if
                              test="normalize-space(../CarrierIdentifier/@domain) != '' or normalize-space(../CarrierIdentifier/Name) != ''">
                              <C_C040>
                                 <xsl:if test="normalize-space(../CarrierIdentifier/@domain) != ''">
                                    <D_3127>
                                       <xsl:value-of
                                          select="substring(normalize-space(../CarrierIdentifier/@domain), 1, 17)"
                                       />
                                    </D_3127>
                                 </xsl:if>
                                 <xsl:if test="normalize-space(../CarrierIdentifier/Name) != ''">
                                    <D_3128>
                                       <xsl:value-of
                                          select="substring(normalize-space(../CarrierIdentifier/Name), 1, 35)"
                                       />
                                    </D_3128>
                                 </xsl:if>
                              </C_C040>
                           </xsl:if>
                           <xsl:if test="normalize-space(ShippingContractNumber) != ''">
                              <C_C401>
                                 <D_8457>ZZZ</D_8457>
                                 <D_8459>ZZZ</D_8459>
                                 <D_7130>
                                    <xsl:value-of
                                       select="substring(normalize-space(ShippingContractNumber), 1, 17)"
                                    />
                                 </D_7130>
                              </C_C401>
                           </xsl:if>
                        </S_TDT>
                     </G_SG9>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <!-- TermsOfDelivery -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode/@value) != ''">
               <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery">
                  <xsl:variable name="TODCode" select="normalize-space(TermsOfDeliveryCode/@value)"/>
                  <xsl:variable name="SPMCode"
                     select="normalize-space(ShippingPaymentMethod/@value)"/>
                  <xsl:variable name="TTCode" select="normalize-space(TransportTerms/@value)"/>
                  <G_SG11>
                     <S_TOD>
                        <xsl:choose>
                           <xsl:when
                              test="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode != ''">
                              <D_4055>
                                 <xsl:value-of
                                    select="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode"
                                 />
                              </D_4055>
                           </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                           <xsl:when
                              test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode != ''">
                              <D_4215>
                                 <xsl:value-of
                                    select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode"
                                 />
                              </D_4215>
                           </xsl:when>
                           <xsl:otherwise>
                              <D_4215>ZZZ</D_4215>
                           </xsl:otherwise>
                        </xsl:choose>
                        <!-- IG-1420 - Ashish added condition for checking TTCode itself as valid -->
                        <xsl:if
                           test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode != '' or $Lookup/Lookups/TransportTermsCodes/TransportTermsCode[EDIFACTCode = $TTCode]/CXMLCode != '' or normalize-space(Comments[@type = 'TermsOfDelivery']) != '' or normalize-space(Comments[@type = 'Transport']) != ''">
                           <C_C100>
                              <xsl:choose>
                                 <xsl:when
                                    test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode != ''">
                                    <D_4053>
                                       <xsl:value-of
                                          select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode"
                                       />
                                    </D_4053>
                                 </xsl:when>
                                 <!-- IG-1420 - Ashish - If TTCode is a valid code, then write TTCode itself -->
                                 <xsl:when
                                    test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[EDIFACTCode = $TTCode]/CXMLCode != ''">
                                    <D_4053>
                                       <xsl:value-of select="$TTCode"/>
                                    </D_4053>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <D_4053>ZZZ</D_4053>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <xsl:if
                                 test="normalize-space(Comments[@type = 'TermsOfDelivery']) != ''">
                                 <D_4052>
                                    <xsl:value-of
                                       select="substring(normalize-space(Comments[@type = 'TermsOfDelivery']), 1, 70)"
                                    />
                                 </D_4052>
                              </xsl:if>
                              <xsl:if
                                 test="normalize-space(Comments[@type = 'Transport']) != '' and normalize-space(Comments[@type = 'TermsOfDelivery']) != ''">
                                 <D_4052_2>
                                    <xsl:value-of
                                       select="substring(normalize-space(Comments[@type = 'Transport']), 1, 70)"
                                    />
                                 </D_4052_2>
                              </xsl:if>
                              <xsl:if
                                 test="normalize-space(Comments[@type = 'Transport']) != '' and (normalize-space(Comments[@type = 'TermsOfDelivery']) = '' or not(Comments[@type = 'TermsOfDelivery']))">
                                 <D_4052>
                                    <xsl:value-of
                                       select="substring(normalize-space(Comments[@type = 'Transport']), 1, 70)"
                                    />
                                 </D_4052>
                              </xsl:if>
                           </C_C100>
                        </xsl:if>
                     </S_TOD>
                     <xsl:if
                        test="normalize-space(TermsOfDeliveryCode[@value = 'Other']) != '' or normalize-space(ShippingPaymentMethod[@value = 'Other']) != '' or normalize-space(TransportTerms[@value = 'Other']) != '' or $Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode = '' or $Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode = '' or $Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode = ''">
                        <S_LOC>
                           <D_3227>ZZZ</D_3227>
                           <C_C517>
                              <D_3225>TDC</D_3225>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(TermsOfDeliveryCode[@value = 'Other']) != ''">
                                    <D_3224>
                                       <xsl:value-of
                                          select="substring(normalize-space(TermsOfDeliveryCode[@value = 'Other']), 1, 70)"
                                       />
                                    </D_3224>
                                 </xsl:when>
                                 <xsl:when
                                    test="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode = ''">
                                    <D_3224>
                                       <xsl:value-of
                                          select="substring(normalize-space($TODCode), 1, 70)"/>
                                    </D_3224>
                                 </xsl:when>
                              </xsl:choose>
                           </C_C517>
                           <C_C519>
                              <D_3223>SPM</D_3223>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(ShippingPaymentMethod[@value = 'Other']) != ''">
                                    <D_3222>
                                       <xsl:value-of
                                          select="substring(normalize-space(ShippingPaymentMethod[@value = 'Other']), 1, 70)"
                                       />
                                    </D_3222>
                                 </xsl:when>
                                 <xsl:when
                                    test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode = ''">
                                    <D_3222>
                                       <xsl:value-of
                                          select="substring(normalize-space($SPMCode), 1, 70)"/>
                                    </D_3222>
                                 </xsl:when>
                              </xsl:choose>
                           </C_C519>
                           <C_C553>
                              <D_3233>TTC</D_3233>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(TransportTerms[@value = 'Other']) != ''">
                                    <D_3232>
                                       <xsl:value-of
                                          select="substring(normalize-space(TransportTerms[@value = 'Other']), 1, 70)"
                                       />
                                    </D_3232>
                                 </xsl:when>
                                 <xsl:when
                                    test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode = ''">
                                    <D_3232>
                                       <xsl:value-of
                                          select="substring(normalize-space($TTCode), 1, 70)"/>
                                    </D_3232>
                                 </xsl:when>
                              </xsl:choose>
                           </C_C553>
                        </S_LOC>
                     </xsl:if>
                  </G_SG11>
               </xsl:for-each>
            </xsl:if>
            <!-- shipComplete -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@shipComplete) = 'yes'">
               <G_SG15>
                  <S_SCC>
                     <D_4017>1</D_4017>
                     <D_4493>SC</D_4493>
                  </S_SCC>
               </G_SG15>
            </xsl:if>
            <!-- Shipping -->
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain) != ''">
               <G_SG18>
                  <S_ALC>
                     <D_5463>C</D_5463>
                     <C_C552>
                        <D_1230>
                           <xsl:value-of
                              select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain), 1, 35)"
                           />
                        </D_1230>
                     </C_C552>
                     <C_C214>
                        <D_7161>SAA</D_7161>
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/ShortName) != ''">
                              <D_7160>
                                 <xsl:value-of
                                    select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/ShortName), 1, 35)"
                                 />
                              </D_7160>
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description) != ''">
                              <D_7160>
                                 <xsl:value-of
                                    select="substring(normalize-space(Shipping/Description), 1, 35)"
                                 />
                              </D_7160>
                           </xsl:when>
                           <xsl:otherwise>
                              <D_7160>Default Shipping</D_7160>
                           </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if
                           test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId) != ''">
                           <D_7160_2>
                              <xsl:value-of
                                 select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId), 1, 35)"
                              />
                           </D_7160_2>
                        </xsl:if>
                     </C_C214>
                  </S_ALC>
                  <xsl:call-template name="createMOA">
                     <xsl:with-param name="grpNum" select="'G_SG21'"/>
                     <xsl:with-param name="qual" select="'23'"/>
                     <xsl:with-param name="money"
                        select="cXML/Request/OrderRequest/OrderRequestHeader/Shipping"/>
                     <xsl:with-param name="createAlternate" select="'yes'"/>
                     <xsl:with-param name="hideAmt" select="$hideAmtHdr"/>
                  </xsl:call-template>
               </G_SG18>
            </xsl:if>
            <!-- OrderRequestHeader><Total><Modifications><Modification -->
            <xsl:for-each
               select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Modifications/Modification[ModificationDetail/@name != ''][14 &gt;= position()]">
               <xsl:variable name="modDetail" select="normalize-space(ModificationDetail/@name)"/>
               <xsl:if
                  test="$Lookup/Lookups/Modifications/Modification[CXMLCode = $modDetail]/EDIFACTCode != ''">
                  <G_SG18>
                     <S_ALC>
                        <D_5463>
                           <xsl:choose>
                              <xsl:when test="AdditionalDeduction">A</xsl:when>
                              <xsl:when test="AdditionalCost">C</xsl:when>
                           </xsl:choose>
                        </D_5463>
                        <C_C214>
                           <D_7161>
                              <xsl:value-of
                                 select="$Lookup/Lookups/Modifications/Modification[CXMLCode = $modDetail]/EDIFACTCode"
                              />
                           </D_7161>
                           <D_1131>ZZZ</D_1131>
                           <D_3055>92</D_3055>
                           <xsl:variable name="modDesc"
                              select="normalize-space(ModificationDetail/Description)"/>
                           <xsl:if test="$modDesc != ''">
                              <D_7160>
                                 <xsl:value-of select="normalize-space(substring($modDesc, 1, 35))"
                                 />
                              </D_7160>
                           </xsl:if>
                           <xsl:if test="normalize-space(substring($modDesc, 36)) != ''">
                              <D_7160_2>
                                 <xsl:value-of select="normalize-space(substring($modDesc, 36, 35))"
                                 />
                              </D_7160_2>
                           </xsl:if>
                        </C_C214>
                     </S_ALC>
                     <xsl:if test="normalize-space(ModificationDetail/@startDate) != ''">
                        <S_DTM>
                           <C_C507>
                              <D_2005>194</D_2005>
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="normalize-space(ModificationDetail/@startDate)"/>
                              </xsl:call-template>
                           </C_C507>
                        </S_DTM>
                     </xsl:if>
                     <xsl:if test="normalize-space(ModificationDetail/@endDate) != ''">
                        <S_DTM>
                           <C_C507>
                              <D_2005>206</D_2005>
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="normalize-space(ModificationDetail/@endDate)"/>
                              </xsl:call-template>
                           </C_C507>
                        </S_DTM>
                     </xsl:if>
                     <xsl:if
                        test="normalize-space(AdditionalDeduction/DeductionPercent/@percent) != '' or normalize-space(AdditionalCost/Percentage/@percent) != ''">
                        <G_SG20>
                           <S_PCD>
                              <C_C501>
                                 <D_5245>
                                    <xsl:choose>
                                       <xsl:when test="AdditionalDeduction">1</xsl:when>
                                       <xsl:when test="AdditionalCost">2</xsl:when>
                                    </xsl:choose>
                                 </D_5245>
                                 <D_5482>
                                    <xsl:choose>
                                       <xsl:when
                                          test="normalize-space(AdditionalDeduction/DeductionPercent/@percent) != ''">
                                          <xsl:value-of
                                             select="substring(normalize-space(AdditionalDeduction/DeductionPercent/@percent), 1, 10)"
                                          />
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of
                                             select="substring(normalize-space(AdditionalCost/Percentage/@percent), 1, 10)"
                                          />
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </D_5482>
                              </C_C501>
                           </S_PCD>
                        </G_SG20>
                     </xsl:if>
                     <xsl:if test="normalize-space(OriginalPrice/Money) != ''">
                        <xsl:call-template name="createMOA">
                           <xsl:with-param name="grpNum" select="'G_SG21'"/>
                           <xsl:with-param name="qual" select="'98'"/>
                           <xsl:with-param name="money" select="OriginalPrice"/>
                           <xsl:with-param name="hideAmt" select="$hideAmtHdr"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if
                        test="normalize-space(AdditionalCost/Money) != '' or normalize-space(AdditionalDeduction/DeductionAmount/Money) != '' or normalize-space(AdditionalDeduction/DeductedPrice/Money) != ''">
                        <xsl:call-template name="createMOA">
                           <xsl:with-param name="grpNum" select="'G_SG21'"/>
                           <xsl:with-param name="qual">
                              <xsl:choose>
                                 <xsl:when
                                    test="AdditionalCost/Money != '' or AdditionalDeduction/DeductionAmount != ''"
                                    >8</xsl:when>
                                 <xsl:when test="AdditionalDeduction/DeductedPrice != ''"
                                    >4</xsl:when>
                              </xsl:choose>
                           </xsl:with-param>
                           <xsl:with-param name="money">
                              <xsl:choose>
                                 <xsl:when test="AdditionalCost/Money != ''">
                                    <xsl:copy-of select="AdditionalCost/Money"/>
                                 </xsl:when>
                                 <xsl:when test="AdditionalDeduction/DeductionAmount/Money != ''">
                                    <xsl:copy-of select="AdditionalDeduction/DeductionAmount/Money"
                                    />
                                 </xsl:when>
                                 <xsl:when test="AdditionalDeduction/DeductedPrice/Money != ''">
                                    <xsl:copy-of select="AdditionalDeduction/DeductedPrice/Money"/>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:with-param>
                           <xsl:with-param name="hideAmt" select="$hideAmtHdr"/>
                        </xsl:call-template>
                     </xsl:if>
                  </G_SG18>
               </xsl:if>
            </xsl:for-each>
            <!-- Item Out -->
            <xsl:for-each select="cXML/Request/OrderRequest/ItemOut">
               <G_SG25>
                  <S_LIN>
                     <D_1082>
                        <xsl:choose>
                           <xsl:when test="normalize-space(@lineNumber) != ''">
                              <xsl:value-of
                                 select="substring(format-number(@lineNumber, '#'), 1, 6)"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="position()"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </D_1082>
                     <xsl:if test="normalize-space(ItemID/SupplierPartID) != ''">
                        <C_C212>
                           <D_7140>
                              <xsl:value-of
                                 select="substring(normalize-space(ItemID/SupplierPartID), 1, 35)"/>
                           </D_7140>
                           <D_7143>VN</D_7143>
                        </C_C212>
                     </xsl:if>
                     <xsl:if test="normalize-space(@parentLineNumber)">
                        <C_C829>
                           <D_5495>1</D_5495>
                           <D_1082>
                              <xsl:value-of
                                 select="substring(format-number(@parentLineNumber, '#'), 1, 6)"/>
                           </D_1082>
                        </C_C829>
                     </xsl:if>
                  </S_LIN>
                  <!-- ItemIDs -->
                  <xsl:if
                     test="normalize-space(ItemID/SupplierPartAuxiliaryID) != '' or normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != '' or normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier) != '' or normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                     <S_PIA>
                        <D_4347>1</D_4347>
                        <xsl:choose>
                           <xsl:when test="normalize-space(ItemID/SupplierPartAuxiliaryID) != ''">
                              <C_C212>
                                 <D_7140>
                                    <xsl:value-of
                                       select="substring(normalize-space(ItemID/SupplierPartAuxiliaryID), 1, 35)"
                                    />
                                 </D_7140>
                                 <D_7143>VS</D_7143>
                                 <D_1131>57</D_1131>
                                 <D_3055>91</D_3055>
                              </C_C212>
                              <xsl:if
                                 test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != '' or normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier) != ''">
                                 <C_C212_2>
                                    <D_7140>
                                       <xsl:choose>
                                          <xsl:when
                                             test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != ''">
                                             <xsl:value-of
                                                select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID), 1, 35)"
                                             />
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of
                                                select="substring(normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier), 1, 35)"
                                             />
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </D_7140>
                                    <D_7143>EN</D_7143>
                                    <D_1131>57</D_1131>
                                    <D_3055>9</D_3055>
                                 </C_C212_2>
                              </xsl:if>
                              <xsl:if
                                 test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                 <C_C212_3>
                                    <D_7140>
                                       <xsl:value-of
                                          select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"
                                       />
                                    </D_7140>
                                    <D_7143>ZZZ</D_7143>
                                    <D_1131>57</D_1131>
                                    <D_3055>9</D_3055>
                                 </C_C212_3>
                              </xsl:if>
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != '' or normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier) != ''">
                              <C_C212>
                                 <D_7140>
                                    <xsl:choose>
                                       <xsl:when
                                          test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != ''">
                                          <xsl:value-of
                                             select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID), 1, 35)"
                                          />
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of
                                             select="substring(normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier), 1, 35)"
                                          />
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </D_7140>
                                 <D_7143>EN</D_7143>
                                 <D_1131>57</D_1131>
                                 <D_3055>9</D_3055>
                              </C_C212>
                              <xsl:if
                                 test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                 <C_C212_2>
                                    <D_7140>
                                       <xsl:value-of
                                          select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"
                                       />
                                    </D_7140>
                                    <D_7143>ZZZ</D_7143>
                                    <D_1131>57</D_1131>
                                    <D_3055>9</D_3055>
                                 </C_C212_2>
                              </xsl:if>
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                              <C_C212>
                                 <D_7140>
                                    <xsl:value-of
                                       select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"
                                    />
                                 </D_7140>
                                 <D_7143>ZZZ</D_7143>
                                 <D_1131>57</D_1131>
                                 <D_3055>9</D_3055>
                              </C_C212>
                           </xsl:when>
                        </xsl:choose>
                     </S_PIA>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(ItemID/BuyerPartID) != '' or normalize-space(ItemDetail/ManufacturerPartID) != ''">
                     <S_PIA>
                        <D_4347>5</D_4347>
                        <xsl:choose>
                           <xsl:when test="normalize-space(ItemID/BuyerPartID) != ''">
                              <C_C212>
                                 <D_7140>
                                    <xsl:value-of
                                       select="substring(normalize-space(ItemID/BuyerPartID), 1, 35)"
                                    />
                                 </D_7140>
                                 <D_7143>BP</D_7143>
                                 <D_1131>57</D_1131>
                                 <D_3055>92</D_3055>
                              </C_C212>
                              <xsl:if test="normalize-space(ItemDetail/ManufacturerPartID) != ''">
                                 <C_C212_2>
                                    <D_7140>
                                       <xsl:value-of
                                          select="substring(normalize-space(ItemDetail/ManufacturerPartID), 1, 35)"
                                       />
                                    </D_7140>
                                    <D_7143>MF</D_7143>
                                    <D_1131>57</D_1131>
                                    <D_3055>90</D_3055>
                                 </C_C212_2>
                              </xsl:if>
                           </xsl:when>
                           <xsl:when test="normalize-space(ItemDetail/ManufacturerPartID) != ''">
                              <C_C212>
                                 <D_7140>
                                    <xsl:value-of
                                       select="substring(normalize-space(ItemDetail/ManufacturerPartID), 1, 35)"
                                    />
                                 </D_7140>
                                 <D_7143>MF</D_7143>
                                 <D_1131>57</D_1131>
                                 <D_3055>90</D_3055>
                              </C_C212>
                           </xsl:when>
                        </xsl:choose>
                     </S_PIA>
                  </xsl:if>
                  <!-- Description shortName -->
                  <xsl:if
                     test="normalize-space(BlanketItemDetail/Description/ShortName) != '' or normalize-space(ItemDetail/Description/ShortName) != ''">
                     <xsl:variable name="shortName">
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(BlanketItemDetail/Description/ShortName) != ''">
                              <xsl:value-of
                                 select="normalize-space(BlanketItemDetail/Description/ShortName)"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of
                                 select="normalize-space(ItemDetail/Description/ShortName)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="langCode">
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(BlanketItemDetail/Description/@xml:lang) != ''">
                              <xsl:value-of
                                 select="normalize-space(BlanketItemDetail/Description/@xml:lang)"/>
                           </xsl:when>
                           <xsl:when test="normalize-space(ItemDetail/Description/@xml:lang) != ''">
                              <xsl:value-of
                                 select="normalize-space(ItemDetail/Description/@xml:lang)"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:if test="$shortName != ''">
                        <xsl:call-template name="IMDLoop">
                           <xsl:with-param name="IMDQual" select="'E'"/>
                           <xsl:with-param name="IMDData" select="$shortName"/>
                           <xsl:with-param name="langCode" select="$langCode"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:if>
                  <!-- Description -->
                  <xsl:if
                     test="normalize-space(BlanketItemDetail/Description) != '' or normalize-space(ItemDetail/Description) != ''">
                     <xsl:variable name="descText">
                        <xsl:choose>
                           <xsl:when test="normalize-space(BlanketItemDetail/Description) != ''">
                              <xsl:value-of select="normalize-space(BlanketItemDetail/Description)"
                              />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="normalize-space(ItemDetail/Description)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="langCode">
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(BlanketItemDetail/Description/@xml:lang) != ''">
                              <xsl:value-of
                                 select="normalize-space(BlanketItemDetail/Description/@xml:lang)"/>
                           </xsl:when>
                           <xsl:when test="normalize-space(ItemDetail/Description/@xml:lang) != ''">
                              <xsl:value-of
                                 select="normalize-space(ItemDetail/Description/@xml:lang)"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:if test="$descText != ''">
                        <xsl:call-template name="IMDLoop">
                           <xsl:with-param name="IMDQual" select="'F'"/>
                           <xsl:with-param name="IMDData" select="$descText"/>
                           <xsl:with-param name="langCode" select="$langCode"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:if>
                  <!-- Characteristic -->
                  <xsl:for-each
                     select="ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[99 &gt;= position()]">
                     <xsl:variable name="charDomain" select="normalize-space(@domain)"/>
                     <xsl:if
                        test="$Lookup/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[CXMLCode = $charDomain]/EDIFACTCode != '' and position() &lt; 98">
                        <S_IMD>
                           <D_7077>B</D_7077>
                           <D_7081>
                              <xsl:value-of
                                 select="$Lookup/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[CXMLCode = $charDomain]/EDIFACTCode"
                              />
                           </D_7081>
                           <xsl:if test="normalize-space(@value) != ''">
                              <C_C273>
                                 <D_7009>
                                    <xsl:value-of select="@value"/>
                                 </D_7009>
                              </C_C273>
                           </xsl:if>
                        </S_IMD>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- IG-1471 start -->
                  <xsl:if
                     test="normalize-space(ItemDetail/ItemDetailIndustry/@isConfigurableMaterial) = 'yes'">
                     <S_IMD>
                        <D_7077>E</D_7077>
                        <C_C273>
                           <D_7009>Configurable</D_7009>
                        </C_C273>
                     </S_IMD>
                  </xsl:if>
                  <!-- IG-1471 end -->
                  <!-- Dimension -->
                  <xsl:for-each select="ItemDetail/Dimension[5 &gt;= position()]">
                     <S_MEA>
                        <D_6311>AAE</D_6311>
                        <C_C502>
                           <D_6313>
                              <xsl:variable name="dimType" select="normalize-space(@type)"/>
                              <xsl:choose>
                                 <xsl:when
                                    test="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dimType]/EDIFACTCode != ''">
                                    <xsl:value-of
                                       select="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dimType]/EDIFACTCode"
                                    />
                                 </xsl:when>
                                 <xsl:otherwise>ZZZ</xsl:otherwise>
                              </xsl:choose>
                           </D_6313>
                        </C_C502>
                        <xsl:if test="normalize-space(UnitOfMeasure) != ''">
                           <C_C174>
                              <D_6411>
                                 <xsl:value-of select="normalize-space(UnitOfMeasure)"/>
                              </D_6411>
                              <xsl:if test="normalize-space(@quantity) != ''">
                                 <D_6314>
                                    <xsl:call-template name="formatDecimal">
                                       <xsl:with-param name="amount" select="@quantity"/>
                                    </xsl:call-template>
                                 </D_6314>
                              </xsl:if>
                           </C_C174>
                        </xsl:if>
                     </S_MEA>
                  </xsl:for-each>
                  <!-- ItemOut @quantity -->
                  <xsl:if test="normalize-space(@quantity) != ''">
                     <S_QTY>
                        <C_C186>
                           <D_6063>21</D_6063>
                           <D_6060>
                              <xsl:call-template name="formatDecimal">
                                 <xsl:with-param name="amount" select="@quantity"/>
                              </xsl:call-template>
                           </D_6060>
                           <xsl:choose>
                              <xsl:when
                                 test="normalize-space(BlanketItemDetail/UnitOfMeasure) != ''">
                                 <D_6411>
                                    <xsl:value-of
                                       select="normalize-space(BlanketItemDetail/UnitOfMeasure)"/>
                                 </D_6411>
                              </xsl:when>
                              <xsl:when test="normalize-space(ItemDetail/UnitOfMeasure) != ''">
                                 <D_6411>
                                    <xsl:value-of select="normalize-space(ItemDetail/UnitOfMeasure)"
                                    />
                                 </D_6411>
                              </xsl:when>
                           </xsl:choose>
                        </C_C186>
                     </S_QTY>
                  </xsl:if>
                  <!-- MaxQuantity -->
                  <xsl:if test="normalize-space(BlanketItemDetail/MaxQuantity) != ''">
                     <S_QTY>
                        <C_C186>
                           <D_6063>54</D_6063>
                           <D_6060>
                              <xsl:call-template name="formatDecimal">
                                 <xsl:with-param name="amount"
                                    select="BlanketItemDetail/MaxQuantity"/>
                              </xsl:call-template>
                           </D_6060>
                           <xsl:if test="normalize-space(BlanketItemDetail/UnitOfMeasure)">
                              <D_6411>
                                 <xsl:value-of
                                    select="normalize-space(BlanketItemDetail/UnitOfMeasure)"/>
                              </D_6411>
                           </xsl:if>
                        </C_C186>
                     </S_QTY>
                  </xsl:if>
                  <!-- MinQuantity -->
                  <xsl:if test="normalize-space(BlanketItemDetail/MinQuantity) != ''">
                     <S_QTY>
                        <C_C186>
                           <D_6063>53</D_6063>
                           <D_6060>
                              <xsl:call-template name="formatDecimal">
                                 <xsl:with-param name="amount"
                                    select="BlanketItemDetail/MinQuantity"/>
                              </xsl:call-template>
                           </D_6060>
                           <xsl:if test="normalize-space(BlanketItemDetail/UnitOfMeasure) != ''">
                              <D_6411>
                                 <xsl:value-of
                                    select="normalize-space(BlanketItemDetail/UnitOfMeasure)"/>
                              </D_6411>
                           </xsl:if>
                        </C_C186>
                     </S_QTY>
                  </xsl:if>
                  <!-- IG-1812 -->
                  <!-- SpendDetail -->
                  <xsl:if test="exists(SpendDetail)">
                     <S_ALI>
                        <D_4183>94</D_4183>
                     </S_ALI>
                  </xsl:if>
                  <!-- requestedDeliveryDate -->
                  <xsl:if test="normalize-space(@requestedDeliveryDate) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>2</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate"
                                 select="normalize-space(@requestedDeliveryDate)"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
                  <!-- requestedShipmentDate -->
                  <xsl:if test="normalize-space(@requestedShipmentDate) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>10</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate"
                                 select="normalize-space(@requestedShipmentDate)"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
                  <!-- IG-1812 -->
                  <!-- LeadTime -->
                  <xsl:if test="normalize-space(ItemDetail/LeadTime) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>169</D_2005>
                           <D_2380>
                              <xsl:value-of select="ItemDetail/LeadTime"/>
                           </D_2380>
                           <D_2379>804</D_2379>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
                  <!-- UnitPrice -->
                  <xsl:variable name="hideUnitPrice">
                     <xsl:choose>
                        <xsl:when test="$hideUnitPriceHdr = 'yes'">
                           <xsl:text>yes</xsl:text>
                        </xsl:when>
                        <xsl:when test="ItemDetail/Extrinsic[@name = 'hideUnitPrice']">
                           <xsl:text>yes</xsl:text>
                        </xsl:when>
                        <xsl:when test="BlanketItemDetail/Extrinsic[@name = 'hideUnitPrice']">
                           <xsl:text>yes</xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:if
                     test="normalize-space(BlanketItemDetail/UnitPrice/Money) != '' or normalize-space(ItemDetail/UnitPrice/Money) != ''">
                     <xsl:call-template name="createMOA">
                        <xsl:with-param name="qual" select="'146'"/>
                        <xsl:with-param name="money">
                           <xsl:choose>
                              <xsl:when test="BlanketItemDetail/UnitPrice/Money != ''">
                                 <xsl:copy-of select="BlanketItemDetail/UnitPrice/Money"/>
                              </xsl:when>
                              <xsl:when test="ItemDetail/UnitPrice/Money != ''">
                                 <xsl:copy-of select="ItemDetail/UnitPrice/Money"/>
                              </xsl:when>
                           </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="hideAmt" select="$hideUnitPrice"/>
                        <xsl:with-param name="createAlternate" select="'yes'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- ItemOut Tax -->
                  <xsl:if test="normalize-space(Tax/Money) != ''">
                     <xsl:call-template name="createMOA">
                        <xsl:with-param name="qual" select="'124'"/>
                        <xsl:with-param name="money" select="Tax"/>
                        <xsl:with-param name="createAlternate" select="'yes'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- MaxAmount -->
                  <xsl:if test="normalize-space(BlanketItemDetail/MaxAmount/Money) != ''">
                     <xsl:call-template name="createMOA">
                        <xsl:with-param name="qual" select="'179'"/>
                        <xsl:with-param name="money" select="BlanketItemDetail/MaxAmount"/>
                        <xsl:with-param name="createAlternate" select="'yes'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- MinAmount -->
                  <xsl:if test="normalize-space(BlanketItemDetail/MinAmount/Money) != ''">
                     <xsl:call-template name="createMOA">
                        <xsl:with-param name="qual" select="'173'"/>
                        <xsl:with-param name="money" select="BlanketItemDetail/MinAmount"/>
                        <xsl:with-param name="createAlternate" select="'yes'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- PriceBasisQuantity Description -->
                  <xsl:if
                     test="normalize-space(BlanketItemDetail/PriceBasisQuantity/Description) != '' or normalize-space(ItemDetail/PriceBasisQuantity/Description) != ''">
                     <xsl:variable name="PBQDesc">
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(BlanketItemDetail/PriceBasisQuantity/Description) != ''">
                              <xsl:value-of
                                 select="normalize-space(BlanketItemDetail/PriceBasisQuantity/Description)"
                              />
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(ItemDetail/PriceBasisQuantity/Description) != ''">
                              <xsl:value-of
                                 select="normalize-space(ItemDetail/PriceBasisQuantity/Description)"
                              />
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="PBQLang">
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(BlanketItemDetail/PriceBasisQuantity/Description) != ''">
                              <xsl:value-of
                                 select="upper-case(substring(normalize-space(BlanketItemDetail/PriceBasisQuantity/Description/@xml:lang), 1, 2))"
                              />
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(ItemDetail/PriceBasisQuantity/Description/@xml:lang) != ''">
                              <xsl:value-of
                                 select="upper-case(substring(normalize-space(ItemDetail/PriceBasisQuantity/Description/@xml:lang), 1, 2))"
                              />
                           </xsl:when>
                           <xsl:otherwise>EN</xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:call-template name="FTXLoop">
                        <xsl:with-param name="FTXData" select="$PBQDesc"/>
                        <xsl:with-param name="FTXQual" select="'AAK'"/>
                        <xsl:with-param name="langCode" select="$PBQLang"/>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- IG-1812 -->
                  <!-- URL -->
                  <xsl:if test="normalize-space(ItemDetail/URL/@name) != ''">
                     <S_FTX>
                        <D_4451>ACB</D_4451>
                        <C_C108>
                           <D_4440>URL</D_4440>
                           <D_4440_2>
                              <xsl:value-of select="normalize-space(ItemDetail/URL/@name)"/>
                           </D_4440_2>
                           <xsl:if test="normalize-space(ItemDetail/URL) != ''">
                              <D_4440_3>
                                 <xsl:value-of select="substring(ItemDetail/URL, 1, 70)"/>
                              </D_4440_3>
                              <xsl:if
                                 test="substring(normalize-space(ItemDetail/URL), 70, 70) != ''">
                                 <D_4440_4>
                                    <xsl:value-of select="substring(ItemDetail/URL, 70, 70)"/>
                                 </D_4440_4>
                              </xsl:if>
                              <xsl:if
                                 test="substring(normalize-space(ItemDetail/URL), 140, 70) != ''">
                                 <D_4440_5>
                                    <xsl:value-of select="substring(ItemDetail/URL, 140, 70)"/>
                                 </D_4440_5>
                              </xsl:if>
                           </xsl:if>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <!-- Comments -->
                  <xsl:for-each select="Comments">
                     <xsl:variable name="varComments" select="normalize-space(.)"/>
                     <xsl:variable name="iteration">
                        <xsl:value-of select="position()"/>
                     </xsl:variable>
                     <xsl:choose>
                        <!-- always first Comment to AAI -->
                        <xsl:when test="$varComments != '' and $iteration eq '1'">
                           <xsl:call-template name="FTXLoop">
                              <xsl:with-param name="FTXData" select="$varComments"/>
                              <xsl:with-param name="FTXQual" select="'AAI'"/>
                              <xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
                           </xsl:call-template>
                        </xsl:when>
                        <!-- After 1st comment, following  comments should go to ACB. and If '@type' is null pass space value. to create first D_4440-->
                        <xsl:when test="$varComments != '' and $iteration gt '1'">
                           <xsl:variable name="ACBtype">
                              <xsl:choose>
                                 <xsl:when test="@type = '' or not(exists(@type))">
                                    <xsl:text>  </xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(@type)"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:call-template name="FTXLoop">
                              <xsl:with-param name="FTXData" select="$varComments"/>
                              <xsl:with-param name="domain" select="$ACBtype"/>
                              <xsl:with-param name="FTXQual" select="'ACB'"/>
                              <xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
                           </xsl:call-template>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:for-each>
                  <!-- IG-1471 start -->
                  <xsl:if
                     test="normalize-space(TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other' or @value = 'other']) != ''">
                     <xsl:call-template name="FTXLoopNoLang">
                        <xsl:with-param name="FTXData"
                           select="normalize-space(TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other' or @value = 'other'])"/>
                        <xsl:with-param name="FTXQual" select="'AAR'"/>
                        <xsl:with-param name="FTXsubQual" select="'TDC'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(TermsOfDelivery/ShippingPaymentMethod[@value = 'Other' or @value = 'other']) != ''">
                     <xsl:call-template name="FTXLoopNoLang">
                        <xsl:with-param name="FTXData"
                           select="normalize-space(TermsOfDelivery/ShippingPaymentMethod[@value = 'Other' or @value = 'other'])"/>
                        <xsl:with-param name="FTXQual" select="'AAR'"/>
                        <xsl:with-param name="FTXsubQual" select="'SPM'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(TermsOfDelivery/TransportTerms[@value = 'Other' or @value = 'other']) != ''">
                     <xsl:call-template name="FTXLoopNoLang">
                        <xsl:with-param name="FTXData"
                           select="normalize-space(TermsOfDelivery/TransportTerms[@value = 'Other' or @value = 'other'])"/>
                        <xsl:with-param name="FTXQual" select="'AAR'"/>
                        <xsl:with-param name="FTXsubQual" select="'TTC'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- IG-1471 end -->
                  <!-- BlanketItemDetail/Extrinsic -->
                  <xsl:for-each select="BlanketItemDetail/Extrinsic">
                     <xsl:if test="normalize-space(./@name) != ''">
                        <xsl:call-template name="FTXExtrinsic">
                           <xsl:with-param name="FTXName" select="./@name"/>
                           <xsl:with-param name="FTXData" select="normalize-space(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- ItemDetail/Extrinsic -->
                  <xsl:for-each select="ItemDetail/Extrinsic">
                     <xsl:if test="normalize-space(./@name) != ''">
                        <xsl:call-template name="FTXExtrinsic">
                           <xsl:with-param name="FTXName" select="./@name"/>
                           <xsl:with-param name="FTXData" select="normalize-space(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
                  <!--  Shipping Instruction Description -->
                  <xsl:variable name="SIDesc"
                     select="normalize-space(ShipTo/TransportInformation/ShippingInstructions/Description)"/>
                  <xsl:if test="$SIDesc != ''">
                     <xsl:call-template name="FTXLoop">
                        <xsl:with-param name="FTXData" select="$SIDesc"/>
                        <xsl:with-param name="FTXQual" select="'TDT'"/>
                        <xsl:with-param name="langCode"
                           select="normalize-space(ShipTo/TransportInformation/ShippingInstructions/Description/@xml:lang)"
                        />
                     </xsl:call-template>
                  </xsl:if>
                  <!--  Tax Description -->
                  <xsl:variable name="TaxDesc" select="normalize-space(Tax/Description)"/>
                  <xsl:if test="$TaxDesc != ''">
                     <xsl:call-template name="FTXLoop">
                        <xsl:with-param name="FTXData" select="$TaxDesc"/>
                        <xsl:with-param name="FTXQual" select="'TXD'"/>
                        <xsl:with-param name="langCode"
                           select="normalize-space(Tax/Description/@xml:lang)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <!-- IG-1471 start-->
                  <xsl:if test="normalize-space(ControlKeys/OCInstruction/@value) != ''">
                     <S_FTX>
                        <D_4451>SIN</D_4451>
                        <C_C108>
                           <D_4440>OCValue</D_4440>
                           <D_4440_2>
                              <xsl:value-of
                                 select="substring(normalize-space(ControlKeys/OCInstruction/@value), 1, 70)"
                              />
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit) != ''">
                     <S_FTX>
                        <D_4451>SIN</D_4451>
                        <C_C108>
                           <D_4440>OCLowerTimeToleranceInDays</D_4440>
                           <D_4440_2>
                              <xsl:value-of
                                 select="substring(normalize-space(ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit), 1, 70)"
                              />
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if
                     test="normalize-space(ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit) != ''">
                     <S_FTX>
                        <D_4451>SIN</D_4451>
                        <C_C108>
                           <D_4440>OCUpperTimeToleranceInDays</D_4440>
                           <D_4440_2>
                              <xsl:value-of
                                 select="substring(normalize-space(ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit), 1, 70)"
                              />
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if test="normalize-space(ControlKeys/ASNInstruction/@value) != ''">
                     <S_FTX>
                        <D_4451>SIN</D_4451>
                        <C_C108>
                           <D_4440>ASNValue</D_4440>
                           <D_4440_2>
                              <xsl:value-of
                                 select="substring(normalize-space(ControlKeys/ASNInstruction/@value), 1, 70)"
                              />
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if test="normalize-space(ControlKeys/InvoiceInstruction/@value) != ''">
                     <S_FTX>
                        <D_4451>SIN</D_4451>
                        <C_C108>
                           <D_4440>INVValue</D_4440>
                           <D_4440_2>
                              <xsl:value-of
                                 select="substring(normalize-space(ControlKeys/InvoiceInstruction/@value), 1, 70)"
                              />
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if test="normalize-space(ControlKeys/SESInstruction/@value) != ''">
                     <S_FTX>
                        <D_4451>SIN</D_4451>
                        <C_C108>
                           <D_4440>SESValue</D_4440>
                           <D_4440_2>
                              <xsl:value-of
                                 select="substring(normalize-space(ControlKeys/SESInstruction/@value), 1, 70)"
                              />
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if test="normalize-space(@isReturn) = 'yes'">
                     <S_FTX>
                        <D_4451>ORI</D_4451>
                        <C_C108>
                           <D_4440>Return Item</D_4440>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if test="exists(ItemOutIndustry/QualityInfo)">
                     <S_FTX>
                        <D_4451>ACL</D_4451>
                        <C_C108>
                           <D_4440>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(ItemOutIndustry/QualityInfo/@requiresQualityProcess) = 'yes'"
                                    >yes</xsl:when>
                                 <xsl:otherwise>no</xsl:otherwise>
                              </xsl:choose>
                           </D_4440>
                           <xsl:if
                              test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/@identifier) != ''">
                              <D_4440_2>
                                 <xsl:value-of
                                    select="substring(normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/@identifier), 1, 70)"
                                 />
                              </D_4440_2>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/Description) != ''">
                              <D_4440_3>
                                 <xsl:value-of
                                    select="substring(normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/Description), 1, 70)"
                                 />
                              </D_4440_3>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/@identifier) != ''">
                              <D_4440_4>
                                 <xsl:value-of
                                    select="substring(normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/@identifier), 1, 70)"
                                 />
                              </D_4440_4>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/Description) != ''">
                              <D_4440_5>
                                 <xsl:value-of
                                    select="substring(normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/Description), 1, 70)"
                                 />
                              </D_4440_5>
                           </xsl:if>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <!-- IG-1471 end-->
                  <!-- IG-15213 add new segment FTX+ORI for @isDeliveryCompleted-->
                  <xsl:if test="normalize-space(@isDeliveryCompleted) = 'yes'">
                     <S_FTX>
                        <D_4451>ORI</D_4451>
                        <C_C108>
                           <D_4440>Delivery is completed</D_4440>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>

                  <!--         IG-20205-\-SubcontractingComponent enhancement-->
                  <xsl:if test="normalize-space(@subcontractingType) != ''">
                     <S_FTX>
                        <D_4451>PRD</D_4451>
                        <C_C108>
                           <D_4440>subcontractingType</D_4440>
                           <D_4440_2>
                              <xsl:value-of select="substring(normalize-space(@subcontractingType),1,70)"/>
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <xsl:if test="normalize-space(@itemCategory) != ''">
                     <S_FTX>
                        <D_4451>PRD</D_4451>
                        <C_C108>
                           <D_4440>itemCategory</D_4440>
                           <D_4440_2>
                              <xsl:value-of select="substring(normalize-space(@itemCategory),1,70)"/>
                           </D_4440_2>
                        </C_C108>
                     </S_FTX>
                  </xsl:if>
                  <!-- BlanketItemDetail/Classification -->
                  <xsl:for-each select="BlanketItemDetail/Classification">
                     <xsl:if test="normalize-space(@domain) != '' and normalize-space(.) != ''">
                        <G_SG26>
                           <S_CCI>
                              <C_C240>
                                 <D_7037>
                                    <xsl:value-of select="substring(normalize-space(.), 1, 17)"/>
                                 </D_7037>
                                 <D_7036>
                                    <xsl:value-of
                                       select="substring(normalize-space(@domain), 1, 35)"/>
                                 </D_7036>
                              </C_C240>
                           </S_CCI>
                        </G_SG26>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- ItemDetail/Classification -->
                  <xsl:for-each select="ItemDetail/Classification">
                     <xsl:if test="normalize-space(@domain) != '' and normalize-space(.) != ''">
                        <G_SG26>
                           <S_CCI>
                              <C_C240>
                                 <D_7037>
                                    <xsl:value-of select="substring(normalize-space(.), 1, 17)"/>
                                 </D_7037>
                                 <D_7036>
                                    <xsl:value-of
                                       select="substring(normalize-space(@domain), 1, 35)"/>
                                 </D_7036>
                              </C_C240>
                           </S_CCI>
                        </G_SG26>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- PriceBasisQuantity -->
                  <xsl:if
                     test="BlanketItemDetail/PriceBasisQuantity or ItemDetail/PriceBasisQuantity">
                     <G_SG28>
                        <S_PRI>
                           <C_C509>
                              <D_5125>CAL</D_5125>
                              <D_5387>PBQ</D_5387>
                           </C_C509>
                        </S_PRI>
                        <S_APR>
                           <D_4043>WS</D_4043>
                           <C_C138>
                              <xsl:choose>
                                 <xsl:when
                                    test="BlanketItemDetail/PriceBasisQuantity/@conversionFactor != ''">
                                    <D_5394>
                                       <xsl:value-of
                                          select="BlanketItemDetail/PriceBasisQuantity/@conversionFactor"
                                       />
                                    </D_5394>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <D_5394>
                                       <xsl:value-of
                                          select="ItemDetail/PriceBasisQuantity/@conversionFactor"/>
                                    </D_5394>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <D_5393>CSD</D_5393>
                           </C_C138>
                        </S_APR>
                        <S_RNG>
                           <D_6167>4</D_6167>
                           <C_C280>
                              <xsl:choose>
                                 <xsl:when
                                    test="BlanketItemDetail/PriceBasisQuantity/UnitOfMeasure != ''">
                                    <D_6411>
                                       <xsl:value-of
                                          select="BlanketItemDetail/PriceBasisQuantity/UnitOfMeasure"
                                       />
                                    </D_6411>
                                    <D_6162>
                                       <xsl:call-template name="formatDecimal">
                                          <xsl:with-param name="amount"
                                             select="BlanketItemDetail/PriceBasisQuantity/@quantity"
                                          />
                                       </xsl:call-template>
                                    </D_6162>
                                    <D_6152>
                                       <xsl:call-template name="formatDecimal">
                                          <xsl:with-param name="amount"
                                             select="BlanketItemDetail/PriceBasisQuantity/@quantity"
                                          />
                                       </xsl:call-template>
                                    </D_6152>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <D_6411>
                                       <xsl:value-of
                                          select="ItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                                    </D_6411>
                                    <D_6162>
                                       <xsl:call-template name="formatDecimal">
                                          <xsl:with-param name="amount"
                                             select="ItemDetail/PriceBasisQuantity/@quantity"/>
                                       </xsl:call-template>
                                    </D_6162>
                                    <D_6152>
                                       <xsl:call-template name="formatDecimal">
                                          <xsl:with-param name="amount"
                                             select="ItemDetail/PriceBasisQuantity/@quantity"/>
                                       </xsl:call-template>
                                    </D_6152>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </C_C280>
                        </S_RNG>
                     </G_SG28>
                  </xsl:if>
                  <!-- requisitionID -->
                  <xsl:if test="normalize-space(@requisitionID)">
                     <G_SG29>
                        <S_RFF>
                           <C_C506>
                              <D_1153>AGI</D_1153>
                              <D_1154>
                                 <xsl:value-of
                                    select="substring(normalize-space(@requisitionID), 1, 35)"/>
                              </D_1154>
                           </C_C506>
                        </S_RFF>
                     </G_SG29>
                  </xsl:if>
                  <!-- itemType and compositeItemType-->
                  <xsl:if test="normalize-space(@itemType) != ''">
                     <G_SG29>
                        <S_RFF>
                           <C_C506>
                              <D_1153>FI</D_1153>
                              <D_1154>
                                 <xsl:value-of select="normalize-space(@itemType)"/>
                              </D_1154>
                              <xsl:if test="normalize-space(@compositeItemType) != ''">
                                 <D_4000>
                                    <xsl:value-of select="normalize-space(@compositeItemType)"/>
                                 </D_4000>
                              </xsl:if>
                           </C_C506>
                        </S_RFF>
                     </G_SG29>
                  </xsl:if>
                  <!-- Master Agreement ID -->
                  <xsl:if test="normalize-space(MasterAgreementIDInfo/@agreementID) != ''">
                     <G_SG29>
                        <S_RFF>
                           <C_C506>
                              <D_1153>CT</D_1153>
                              <D_1154>
                                 <xsl:value-of
                                    select="substring(normalize-space(MasterAgreementIDInfo/@agreementID), 1, 35)"
                                 />
                              </D_1154>
                              <xsl:if
                                 test="MasterAgreementIDInfo/@agreementType = 'scheduling_agreement'">
                                 <D_1153>1</D_1153>
                              </xsl:if>
                           </C_C506>
                        </S_RFF>
                        <xsl:if test="MasterAgreementIDInfo/@agreementDate != ''">
                           <S_DTM>
                              <C_C507>
                                 <D_2005>126</D_2005>
                                 <xsl:call-template name="formatDate">
                                    <xsl:with-param name="DocDate"
                                       select="MasterAgreementIDInfo/@agreementDate"/>
                                 </xsl:call-template>
                              </C_C507>
                           </S_DTM>
                        </xsl:if>
                     </G_SG29>
                  </xsl:if>
                  <!-- PromotionDealID -->
                  <xsl:if
                     test="normalize-space(ItemOutIndustry/ItemOutRetail/PromotionDealID) != ''">
                     <G_SG29>
                        <S_RFF>
                           <C_C506>
                              <D_1153>PD</D_1153>
                              <D_1154>
                                 <xsl:value-of
                                    select="substring(normalize-space(ItemOutIndustry/ItemOutRetail/PromotionDealID), 1, 35)"
                                 />
                              </D_1154>
                           </C_C506>
                        </S_RFF>
                     </G_SG29>
                  </xsl:if>
                  <!-- IG-1471 start -->
                  <xsl:if test="normalize-space(@returnAuthorizationNumber) != ''">
                     <G_SG29>
                        <S_RFF>
                           <C_C506>
                              <D_1153>ALQ</D_1153>
                              <D_1154>
                                 <xsl:value-of
                                    select="substring(normalize-space(@returnAuthorizationNumber), 1, 35)"
                                 />
                              </D_1154>
                           </C_C506>
                        </S_RFF>
                     </G_SG29>
                  </xsl:if>
                  <xsl:for-each
                     select="Tax/TaxDetail[lower-case(normalize-space(@isTriangularTransaction)) = 'yes']">
                     <xsl:if test="normalize-space(Description) != ''">
                        <G_SG29>
                           <S_RFF>
                              <C_C506>
                                 <D_1153>VA</D_1153>
                                 <D_1154>
                                    <xsl:value-of
                                       select="substring(normalize-space(Description), 1, 35)"/>
                                 </D_1154>
                              </C_C506>
                           </S_RFF>
                           <xsl:if test="normalize-space(@taxPointDate) != ''">
                              <S_DTM>
                                 <C_C507>
                                    <D_2005>131</D_2005>
                                    <xsl:call-template name="formatDate">
                                       <xsl:with-param name="DocDate"
                                          select="normalize-space(@taxPointDate)"/>
                                    </xsl:call-template>
                                 </C_C507>
                              </S_DTM>
                           </xsl:if>
                           <xsl:if test="normalize-space(@paymentDate) != ''">
                              <S_DTM>
                                 <C_C507>
                                    <D_2005>140</D_2005>
                                    <xsl:call-template name="formatDate">
                                       <xsl:with-param name="DocDate"
                                          select="normalize-space(@paymentDate)"/>
                                    </xsl:call-template>
                                 </C_C507>
                              </S_DTM>
                           </xsl:if>
                        </G_SG29>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- IG-1471 end -->
                  <!-- ItemOut > Packaging -->
                  <xsl:for-each select="Packaging[10 &gt;= position()]">
                     <G_SG30>
                        <S_PAC>
                           <D_7224>1</D_7224>
                           <xsl:if test="normalize-space(PackagingLevelCode) != ''">
                              <C_C531>
                                 <xsl:choose>
                                    <xsl:when test="PackagingLevelCode = 'inner'">
                                       <D_7075>1</D_7075>
                                    </xsl:when>
                                    <xsl:when test="PackagingLevelCode = 'outer'">
                                       <D_7075>3</D_7075>
                                    </xsl:when>
                                    <xsl:when test="PackagingLevelCode = 'intermediate'">
                                       <D_7075>2</D_7075>
                                    </xsl:when>
                                 </xsl:choose>
                              </C_C531>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(PackageTypeCodeIdentifierCode) != '' or normalize-space(ShippingContainerSerialCodeReference) != ''">
                              <C_C202>
                                 <xsl:if test="normalize-space(PackageTypeCodeIdentifierCode) != ''">
                                    <D_7065>
                                       <xsl:value-of
                                          select="normalize-space(PackageTypeCodeIdentifierCode)"/>
                                    </D_7065>
                                 </xsl:if>
                                 <xsl:if
                                    test="normalize-space(ShippingContainerSerialCodeReference) != ''">
                                    <D_7064>
                                       <xsl:value-of
                                          select="normalize-space(ShippingContainerSerialCodeReference)"
                                       />
                                    </D_7064>
                                 </xsl:if>
                              </C_C202>
                           </xsl:if>
                           <xsl:if test="normalize-space(Description) != ''">
                              <C_C402>
                                 <D_7077>A</D_7077>
                                 <D_7064>
                                    <xsl:value-of select="substring(Description, 1, 35)"/>
                                 </D_7064>
                                 <D_7143>ZZZ</D_7143>
                                 <xsl:if
                                    test="substring(normalize-space(Description), 36, 35) != ''">
                                    <D_7064_2>
                                       <xsl:value-of
                                          select="substring(normalize-space(Description), 36, 35)"/>
                                    </D_7064_2>
                                    <D_7143_2>ZZZ</D_7143_2>
                                 </xsl:if>
                              </C_C402>
                           </xsl:if>
                        </S_PAC>
                        <xsl:for-each select="Dimension[5 &gt;= position()]">
                           <S_MEA>
                              <D_6311>AAE</D_6311>
                              <C_C502>
                                 <D_6313>
                                    <xsl:variable name="meaCode" select="@type"/>
                                    <xsl:choose>
                                       <xsl:when
                                          test="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $meaCode]/EDIFACTCode != ''">
                                          <xsl:value-of
                                             select="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $meaCode]/EDIFACTCode"
                                          />
                                       </xsl:when>
                                       <xsl:otherwise>ZZZ</xsl:otherwise>
                                    </xsl:choose>
                                 </D_6313>
                              </C_C502>
                              <xsl:if test="normalize-space(UnitOfMeasure) != ''">
                                 <C_C174>
                                    <D_6411>
                                       <xsl:value-of select="normalize-space(UnitOfMeasure)"/>
                                    </D_6411>
                                    <D_6314>
                                       <xsl:call-template name="formatDecimal">
                                          <xsl:with-param name="amount"
                                             select="substring(normalize-space(@quantity), 1, 18)"/>
                                       </xsl:call-template>
                                    </D_6314>
                                 </C_C174>
                              </xsl:if>
                           </S_MEA>
                        </xsl:for-each>
                        <xsl:if test="normalize-space(OrderedQuantity/@quantity) != ''">
                           <S_QTY>
                              <C_C186>
                                 <D_6063>21</D_6063>
                                 <D_6060>
                                    <xsl:call-template name="formatDecimal">
                                       <xsl:with-param name="amount"
                                          select="substring(normalize-space(OrderedQuantity/@quantity), 1, 15)"
                                       />
                                    </xsl:call-template>
                                 </D_6060>
                                 <xsl:if test="normalize-space(OrderedQuantity/UnitOfMeasure) != ''">
                                    <D_6411>
                                       <xsl:value-of
                                          select="normalize-space(OrderedQuantity/UnitOfMeasure)"/>
                                    </D_6411>
                                 </xsl:if>
                              </C_C186>
                           </S_QTY>
                        </xsl:if>
                        <xsl:if test="normalize-space(DispatchQuantity/@quantity) != ''">
                           <S_QTY>
                              <C_C186>
                                 <D_6063>12</D_6063>
                                 <D_6060>
                                    <xsl:call-template name="formatDecimal">
                                       <xsl:with-param name="amount"
                                          select="substring(normalize-space(DispatchQuantity/@quantity), 1, 15)"
                                       />
                                    </xsl:call-template>
                                 </D_6060>
                                 <xsl:if test="normalize-space(OrderedQuantity/UnitOfMeasure) != ''">
                                    <D_6411>
                                       <xsl:value-of
                                          select="normalize-space(DispatchQuantity/UnitOfMeasure)"/>
                                    </D_6411>
                                 </xsl:if>
                              </C_C186>
                           </S_QTY>
                        </xsl:if>
                        <xsl:if test="normalize-space(FreeGoodsQuantity/@quantity) != ''">
                           <S_QTY>
                              <C_C186>
                                 <D_6063>192</D_6063>
                                 <D_6060>
                                    <xsl:call-template name="formatDecimal">
                                       <xsl:with-param name="amount"
                                          select="substring(normalize-space(FreeGoodsQuantity/@quantity), 1, 15)"
                                       />
                                    </xsl:call-template>
                                 </D_6060>
                                 <xsl:if test="normalize-space(OrderedQuantity/UnitOfMeasure) != ''">
                                    <D_6411>
                                       <xsl:value-of
                                          select="normalize-space(FreeGoodsQuantity/UnitOfMeasure)"
                                       />
                                    </D_6411>
                                 </xsl:if>
                              </C_C186>
                           </S_QTY>
                        </xsl:if>
                        <xsl:if test="normalize-space(PackageID/PackageTrackingID) != ''">
                           <G_SG31>
                              <S_RFF>
                                 <C_C506>
                                    <D_1153>AAS</D_1153>
                                    <D_1154>
                                       <xsl:value-of
                                          select="substring(normalize-space(PackageID/PackageTrackingID), 1, 35)"
                                       />
                                    </D_1154>
                                 </C_C506>
                              </S_RFF>
                           </G_SG31>
                        </xsl:if>
                        <xsl:if test="normalize-space(ShippingContainerSerialCode) != ''">
                           <G_SG32>
                              <S_PCI>
                                 <D_4233>30</D_4233>
                              </S_PCI>
                              <S_GIN>
                                 <D_7405>AW</D_7405>
                                 <C_C208>
                                    <D_7402>
                                       <xsl:value-of
                                          select="substring(normalize-space(ShippingContainerSerialCode), 1, 35)"
                                       />
                                    </D_7402>
                                 </C_C208>
                              </S_GIN>
                           </G_SG32>
                        </xsl:if>
                        <xsl:apply-templates select="ShippingMark[position() mod 10 = 1]"
                           mode="SG32"/>
                     </G_SG30>
                  </xsl:for-each>

                  <!-- IG-20205: added new loop SG30 PAC+0 for Batch in sync with addition for SubcontractingComponent, if itemout/batch exists-->
                  <xsl:if test="exists(Batch)">
                     
                        
                     <xsl:call-template name="subContract">
                    <xsl:with-param name="path" select="."/>
                     </xsl:call-template>
                  
                  </xsl:if>

                  <!-- Item tax -->
                  <xsl:for-each select="Tax/TaxDetail[10 &gt;= position()]">
                     <G_SG34>
                        <S_TAX>
                           <D_5283>
                              <xsl:choose>
                                 <xsl:when test="@purpose = 'duty'">5</xsl:when>
                                 <xsl:otherwise>7</xsl:otherwise>
                              </xsl:choose>
                           </D_5283>
                           <C_C241>
                              <D_5153>
                                 <xsl:choose>
                                    <xsl:when test="@category = 'sales'">LOC</xsl:when>
                                    <xsl:when test="@category = 'usage'">FRE</xsl:when>
                                    <xsl:when test="@category = 'vat'">VAT</xsl:when>
                                    <xsl:when test="@category = 'gst'">GST</xsl:when>
                                    <xsl:otherwise>OTH</xsl:otherwise>
                                 </xsl:choose>
                              </D_5153>
                              <xsl:if test="normalize-space(TaxLocation) != ''">
                                 <D_5152>
                                    <xsl:value-of
                                       select="substring(normalize-space(TaxLocation), 1, 35)"/>
                                 </D_5152>
                              </xsl:if>
                           </C_C241>
                           <xsl:if test="normalize-space(@isVatRecoverable) != ''">
                              <C_C533>
                                 <D_5289>
                                    <xsl:value-of select="normalize-space(@isVatRecoverable)"/>
                                 </D_5289>
                              </C_C533>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(replace(normalize-space(TaxableAmount/Money), ',', '')) != ''">
                              <D_5286>
                                 <xsl:call-template name="formatDecimal">
                                    <xsl:with-param name="amount" select="TaxableAmount/Money"/>
                                 </xsl:call-template>
                              </D_5286>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(@isTriangularTransaction) != '' or normalize-space(@percentageRate) != ''">
                              <C_C243>
                                 <xsl:if test="normalize-space(@isTriangularTransaction) != ''">
                                    <D_5279>TT</D_5279>
                                 </xsl:if>
                                 <xsl:if test="normalize-space(@percentageRate) != ''">
                                    <D_5278>
                                       <xsl:value-of select="normalize-space(@percentageRate)"/>
                                    </D_5278>
                                 </xsl:if>
                              </C_C243>
                           </xsl:if>
                           <xsl:choose>
                              <xsl:when
                                 test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'exemptType']) = 'Mixed'">
                                 <D_5305>A</D_5305>
                              </xsl:when>
                              <xsl:when
                                 test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'exemptType']) = 'Standard'">
                                 <D_5305>S</D_5305>
                              </xsl:when>
                              <xsl:when test="normalize-space(@exemptDetail) != ''">
                                 <D_5305>
                                    <xsl:choose>
                                       <xsl:when
                                          test="lower-case(normalize-space(@exemptDetail)) = 'exempt'"
                                          >E</xsl:when>
                                       <xsl:when
                                          test="lower-case(normalize-space(@exemptDetail)) = 'zerorated'"
                                          >Z</xsl:when>
                                    </xsl:choose>
                                 </D_5305>
                              </xsl:when>
                           </xsl:choose>
                           <xsl:if
                              test="normalize-space(@isTriangularTransaction) = 'yes' and normalize-space(Description) != ''">
                              <D_3446>
                                 <xsl:value-of select="substring(Description, 1, 20)"/>
                              </D_3446>
                           </xsl:if>
                        </S_TAX>
                        <xsl:if test="normalize-space(TaxAmount/Money) != ''">
                           <xsl:call-template name="createMOA">
                              <xsl:with-param name="qual" select="'124'"/>
                              <xsl:with-param name="money" select="TaxAmount"/>
                           </xsl:call-template>
                        </xsl:if>
                     </G_SG34>
                  </xsl:for-each>
                  <!-- Manufacturer Name -->
                  <xsl:if test="normalize-space(ItemDetail/ManufacturerName) != ''">
                     <G_SG35>
                        <S_NAD>
                           <D_3035>MF</D_3035>
                           <xsl:variable name="manufName"
                              select="normalize-space(ItemDetail/ManufacturerName)"/>
                           <C_C058>
                              <D_3124>
                                 <xsl:call-template name="rTrim">
                                    <xsl:with-param name="inData"
                                       select="substring($manufName, 1, 35)"/>
                                 </xsl:call-template>
                              </D_3124>
                              <xsl:if test="substring($manufName, 36, 35) != ''">
                                 <D_3124_2>
                                    <xsl:call-template name="rTrim">
                                       <xsl:with-param name="inData"
                                          select="substring($manufName, 36, 35)"/>
                                    </xsl:call-template>
                                 </D_3124_2>
                              </xsl:if>
                              <xsl:if test="substring($manufName, 71, 35) != ''">
                                 <D_3124_3>
                                    <xsl:call-template name="rTrim">
                                       <xsl:with-param name="inData"
                                          select="substring($manufName, 71, 35)"/>
                                    </xsl:call-template>
                                 </D_3124_3>
                              </xsl:if>
                              <xsl:if test="substring($manufName, 106, 35) != ''">
                                 <D_3124_4>
                                    <xsl:call-template name="rTrim">
                                       <xsl:with-param name="inData"
                                          select="substring($manufName, 106, 35)"/>
                                    </xsl:call-template>
                                 </D_3124_4>
                              </xsl:if>
                              <xsl:if test="substring($manufName, 141, 35) != ''">
                                 <D_3124_5>
                                    <xsl:call-template name="rTrim">
                                       <xsl:with-param name="inData"
                                          select="substring($manufName, 141, 35)"/>
                                    </xsl:call-template>
                                 </D_3124_5>
                              </xsl:if>
                           </C_C058>
                        </S_NAD>
                     </G_SG35>
                  </xsl:if>
                  <!-- ItemOut Supplier ID -->
                  <xsl:if test="normalize-space(SupplierID) != ''">
                     <G_SG35>
                        <S_NAD>
                           <D_3035>SU</D_3035>
                           <C_C082>
                              <D_3039>
                                 <xsl:value-of
                                    select="substring(normalize-space(SupplierID), 1, 35)"/>
                              </D_3039>
                              <D_1131>ZZZ</D_1131>
                              <xsl:choose>
                                 <xsl:when test="normalize-space(SupplierID/@domain) = 'DUNS'">
                                    <D_3055>16</D_3055>
                                 </xsl:when>
                                 <xsl:when
                                    test="normalize-space(SupplierID/@domain) = 'AribaNetworkID'">
                                    <D_3055>ZZZ</D_3055>
                                 </xsl:when>
                              </xsl:choose>
                           </C_C082>
                        </S_NAD>
                     </G_SG35>
                  </xsl:if>
                  <!-- Item Terms Of Delivery -->
                  <xsl:if test="TermsOfDelivery/Address">
                     <G_SG35>
                        <xsl:call-template name="createNAD">
                           <xsl:with-param name="Address" select="TermsOfDelivery/Address"/>
                           <xsl:with-param name="role" select="'deliveryParty'"/>
                        </xsl:call-template>
                        <xsl:call-template name="CTACOMLoop">
                           <xsl:with-param name="contact" select="TermsOfDelivery/Address"/>
                           <xsl:with-param name="contactType" select="'TermsOfDelivery'"/>
                           <xsl:with-param name="level" select="'detail'"/>
                        </xsl:call-template>
                     </G_SG35>
                  </xsl:if>
                  <!-- Item ShipTo -->
                  <xsl:if test="ShipTo">
                     <G_SG35>
                        <xsl:call-template name="createNAD">
                           <xsl:with-param name="Address" select="ShipTo/Address"/>
                           <xsl:with-param name="role" select="'shipTo'"/>
                        </xsl:call-template>
                        <xsl:call-template name="CTACOMLoop">
                           <xsl:with-param name="contact" select="ShipTo/Address"/>
                           <xsl:with-param name="contactType" select="'ShipTo'"/>
                           <xsl:with-param name="level" select="'detail'"/>
                        </xsl:call-template>
                     </G_SG35>
                  </xsl:if>
                  <!-- Contacts -->
                  <xsl:for-each select="Contact[@role != 'supplierCorporate']">
                     <xsl:if test="@role != ''">
                        <G_SG35>
                           <xsl:call-template name="createNAD">
                              <xsl:with-param name="Address" select="."/>
                              <xsl:with-param name="role" select="@role"/>
                           </xsl:call-template>
                           <xsl:call-template name="CTACOMLoop">
                              <xsl:with-param name="contact" select="."/>
                              <xsl:with-param name="contactType" select="@role"/>
                              <xsl:with-param name="ContactDepartmentID"
                                 select="normalize-space(IdReference[@domain = 'ContactDepartmentID']/@identifier)"/>
                              <xsl:with-param name="ContactPerson"
                                 select="normalize-space(IdReference[@domain = 'ContactPerson']/@identifier)"/>
                              <xsl:with-param name="level" select="'detail'"/>
                           </xsl:call-template>
                        </G_SG35>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- Shipping -->
                  <xsl:if test="normalize-space(Shipping/Money) != ''">
                     <G_SG39>
                        <S_ALC>
                           <D_5463>C</D_5463>
                           <xsl:if test="normalize-space(Shipping/@trackingDomain) != ''">
                              <C_C552>
                                 <D_1230>
                                    <xsl:value-of
                                       select="substring(normalize-space(Shipping/@trackingDomain), 1, 35)"
                                    />
                                 </D_1230>
                              </C_C552>
                           </xsl:if>
                           <C_C214>
                              <D_7161>SAA</D_7161>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(Shipping/Description/ShortName) != ''">
                                    <D_7160>
                                       <xsl:value-of
                                          select="substring(normalize-space(Shipping/Description/ShortName), 1, 35)"
                                       />
                                    </D_7160>
                                 </xsl:when>
                                 <xsl:when test="Shipping/Description">
                                    <D_7160>
                                       <xsl:value-of
                                          select="substring(normalize-space(Shipping/Description), 1, 35)"
                                       />
                                    </D_7160>
                                 </xsl:when>
                              </xsl:choose>
                              <xsl:if test="normalize-space(Shipping/@trackingId)">
                                 <D_7160_2>
                                    <xsl:value-of
                                       select="substring(normalize-space(Shipping/@trackingId), 1, 35)"
                                    />
                                 </D_7160_2>
                              </xsl:if>
                           </C_C214>
                        </S_ALC>
                        <xsl:call-template name="createMOA">
                           <xsl:with-param name="grpNum" select="'G_SG42'"/>
                           <xsl:with-param name="qual" select="'23'"/>
                           <xsl:with-param name="money" select="Shipping"/>
                           <xsl:with-param name="createAlternate" select="'yes'"/>
                        </xsl:call-template>
                     </G_SG39>
                  </xsl:if>
                  <!-- Distribution -->
                  <xsl:for-each select="Distribution[Accounting/AccountingSegment/@id != '']">
                     <G_SG39>
                        <S_ALC>
                           <D_5463>N</D_5463>
                           <C_C214>
                              <D_7161>ADT</D_7161>
                              <D_1131>175</D_1131>
                              <D_3055>92</D_3055>
                              <xsl:apply-templates select="Accounting" mode="ele"/>
                              <D_7160_2>LISA</D_7160_2>
                           </C_C214>
                        </S_ALC>
                        <xsl:call-template name="createMOA">
                           <xsl:with-param name="grpNum" select="'G_SG42'"/>
                           <xsl:with-param name="qual" select="'54'"/>
                           <xsl:with-param name="money" select="Charge"/>
                           <xsl:with-param name="createAlternate" select="'yes'"/>
                        </xsl:call-template>
                     </G_SG39>
                  </xsl:for-each>
                  <!-- UnitPrice > Modifications -->
                  <xsl:for-each
                     select="ItemDetail/UnitPrice/Modifications/Modification[ModificationDetail/@name != ''][50 &gt;= position()]">
                     <xsl:variable name="modDetail"
                        select="normalize-space(ModificationDetail/@name)"/>
                     <xsl:if
                        test="$Lookup/Lookups/Modifications/Modification[CXMLCode = $modDetail]/EDIFACTCode != ''">
                        <G_SG39>
                           <S_ALC>
                              <xsl:choose>
                                 <xsl:when test="AdditionalDeduction">
                                    <D_5463>A</D_5463>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <D_5463>C</D_5463>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <xsl:variable name="modName"
                                 select="normalize-space(ModificationDetail/@name)"/>
                              <xsl:if
                                 test="ModificationDetail and $Lookup/Lookups/Modifications/Modification[CXMLCode = $modName]/EDIFACTCode != ''">
                                 <C_C214>
                                    <D_7161>
                                       <xsl:choose>
                                          <xsl:when
                                             test="$Lookup/Lookups/Modifications/Modification[CXMLCode = $modName]/EDIFACTCode != ''">
                                             <xsl:value-of
                                                select="$Lookup/Lookups/Modifications/Modification[CXMLCode = $modName]/EDIFACTCode"
                                             />
                                          </xsl:when>
                                       </xsl:choose>
                                    </D_7161>
                                    <D_1131>ZZZ</D_1131>
                                    <D_3055>92</D_3055>
                                    <xsl:variable name="modDesc"
                                       select="normalize-space(ModificationDetail/Description)"/>
                                    <xsl:if test="$modDesc != ''">
                                       <D_7160>
                                          <xsl:value-of select="substring($modDesc, 1, 35)"/>
                                       </D_7160>
                                    </xsl:if>
                                    <xsl:if test="substring($modDesc, 36, 35) != ''">
                                       <D_7160_2>
                                          <xsl:value-of select="substring($modDesc, 36, 35)"/>
                                       </D_7160_2>
                                    </xsl:if>
                                 </C_C214>
                              </xsl:if>
                           </S_ALC>
                           <xsl:if test="normalize-space(ModificationDetail/@startDate) != ''">
                              <S_DTM>
                                 <C_C507>
                                    <D_2005>194</D_2005>
                                    <xsl:call-template name="formatDate">
                                       <xsl:with-param name="DocDate"
                                          select="normalize-space(ModificationDetail/@startDate)"/>
                                    </xsl:call-template>
                                 </C_C507>
                              </S_DTM>
                           </xsl:if>
                           <xsl:if test="normalize-space(ModificationDetail/@endDate) != ''">
                              <S_DTM>
                                 <C_C507>
                                    <D_2005>206</D_2005>
                                    <xsl:call-template name="formatDate">
                                       <xsl:with-param name="DocDate"
                                          select="normalize-space(ModificationDetail/@endDate)"/>
                                    </xsl:call-template>
                                 </C_C507>
                              </S_DTM>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(AdditionalDeduction/DeductionPercent/@percent) != '' or normalize-space(AdditionalCost/Percentage/@percent) != ''">
                              <G_SG41>
                                 <S_PCD>
                                    <C_C501>
                                       <xsl:choose>
                                          <xsl:when test="AdditionalDeduction != ''">
                                             <D_5245>1</D_5245>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <D_5245>2</D_5245>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                       <xsl:choose>
                                          <xsl:when
                                             test="normalize-space(AdditionalDeduction/DeductionPercent/@percent) != ''">
                                             <D_5482>
                                                <xsl:value-of
                                                  select="normalize-space(AdditionalDeduction/DeductionPercent/@percent)"
                                                />
                                             </D_5482>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <D_5482>
                                                <xsl:value-of
                                                  select="normalize-space(AdditionalCost/Percentage/@percent)"
                                                />
                                             </D_5482>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </C_C501>
                                 </S_PCD>
                              </G_SG41>
                           </xsl:if>
                           <xsl:if test="normalize-space(OriginalPrice/Money) != ''">
                              <xsl:call-template name="createMOA">
                                 <xsl:with-param name="grpNum" select="'G_SG42'"/>
                                 <xsl:with-param name="qual" select="'98'"/>
                                 <xsl:with-param name="money" select="OriginalPrice"/>
                              </xsl:call-template>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(AdditionalCost/Money) != '' or normalize-space(AdditionalDeduction/DeductionAmount/Money) != '' or normalize-space(AdditionalDeduction/DeductedPrice/Money) != ''">
                              <xsl:call-template name="createMOA">
                                 <xsl:with-param name="grpNum" select="'G_SG42'"/>
                                 <xsl:with-param name="qual">
                                    <xsl:choose>
                                       <xsl:when
                                          test="normalize-space(AdditionalCost/Money) != '' or normalize-space(AdditionalDeduction/DeductionAmount/Money) != ''"
                                          >8</xsl:when>
                                       <xsl:when
                                          test="normalize-space(AdditionalDeduction/DeductedPrice/Money) != ''"
                                          >4</xsl:when>
                                    </xsl:choose>
                                 </xsl:with-param>
                                 <xsl:with-param name="money">
                                    <xsl:choose>
                                       <xsl:when test="normalize-space(AdditionalCost/Money) != ''">
                                          <xsl:copy-of select="AdditionalCost/Money"/>
                                       </xsl:when>
                                       <xsl:when
                                          test="normalize-space(AdditionalDeduction/DeductionAmount/Money) != ''">
                                          <xsl:copy-of
                                             select="AdditionalDeduction/DeductionAmount/Money"/>
                                       </xsl:when>
                                       <xsl:when
                                          test="normalize-space(AdditionalDeduction/DeductedPrice/Money) != ''">
                                          <xsl:copy-of
                                             select="AdditionalDeduction/DeductedPrice/Money"/>
                                       </xsl:when>
                                    </xsl:choose>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:if>
                        </G_SG39>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- ShipTo transportation -->
                  <xsl:if test="normalize-space(ShipTo/TransportInformation/Route/@method) != ''">
                     <G_SG45>
                        <S_TDT>
                           <D_8051>20</D_8051>
                           <C_C220>
                              <xsl:variable name="routeMethod"
                                 select="normalize-space(ShipTo/TransportInformation/Route/@method)"/>
                              <xsl:choose>
                                 <xsl:when
                                    test="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $routeMethod]/EDIFACTCode != ''">
                                    <D_8067>
                                       <xsl:value-of
                                          select="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $routeMethod]/EDIFACTCode"
                                       />
                                    </D_8067>
                                 </xsl:when>
                              </xsl:choose>
                              <D_8066>
                                 <xsl:value-of
                                    select="substring(normalize-space(ShipTo/TransportInformation/Route/@method), 1, 17)"
                                 />
                              </D_8066>
                           </C_C220>
                           <!-- IG-1471 start -->
                           <xsl:if test="normalize-space(Route/@means) != ''">
                              <C_C228>
                                 <D_8178>
                                    <xsl:value-of
                                       select="substring(normalize-space(Route/@means), 1, 17)"/>
                                 </D_8178>
                              </C_C228>
                           </xsl:if>
                           <!-- IG-1471 end -->
                           <xsl:if test="normalize-space(ShipTo/CarrierIdentifier) != ''">
                              <C_C040>
                                 <D_3127>
                                    <xsl:value-of
                                       select="substring(normalize-space(ShipTo/CarrierIdentifier/@domain), 1, 17)"
                                    />
                                 </D_3127>
                                 <D_3128>
                                    <xsl:value-of
                                       select="substring(normalize-space(ShipTo/CarrierIdentifier), 1, 35)"
                                    />
                                 </D_3128>
                              </C_C040>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(ShipTo/TransportInformation/ShippingContractNumber) != ''">
                              <C_C401>
                                 <D_8457>ZZZ</D_8457>
                                 <D_8459>ZZZ</D_8459>
                                 <D_7130>
                                    <xsl:value-of
                                       select="substring(normalize-space(ShipTo/TransportInformation/ShippingContractNumber), 1, 17)"
                                    />
                                 </D_7130>
                              </C_C401>
                           </xsl:if>
                        </S_TDT>
                     </G_SG45>
                  </xsl:if>
                  <!-- ItemOut TermsOfDelivery -->
                  <xsl:if test="TermsOfDelivery/TermsOfDeliveryCode/@value != ''">
                     <G_SG47>
                        <xsl:variable name="TODCode"
                           select="normalize-space(TermsOfDelivery/TermsOfDeliveryCode/@value)"/>
                        <xsl:variable name="SPMCode"
                           select="normalize-space(TermsOfDelivery/ShippingPaymentMethod/@value)"/>
                        <xsl:variable name="TTCode"
                           select="normalize-space(TermsOfDelivery/TransportTerms/@value)"/>
                        <S_TOD>
                           <xsl:choose>
                              <xsl:when
                                 test="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode != ''">
                                 <D_4055>
                                    <xsl:value-of
                                       select="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode"
                                    />
                                 </D_4055>
                              </xsl:when>
                           </xsl:choose>
                           <xsl:choose>
                              <xsl:when
                                 test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode != ''">
                                 <D_4215>
                                    <xsl:value-of
                                       select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode"
                                    />
                                 </D_4215>
                              </xsl:when>
                           </xsl:choose>
                           <!-- IG-1420 - Ashish - Added condition to check if TTCode itself is a valid code -->
                           <xsl:if
                              test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode != '' or $Lookup/Lookups/TransportTermsCodes/TransportTermsCode[EDIFACTCode = $TTCode]/CXMLCode != '' or TermsOfDelivery/Comments[@type = 'TermsOfDelivery'] != '' or TermsOfDelivery/Comments[@type = 'Transport'] != ''">
                              <C_C100>
                                 <xsl:choose>
                                    <xsl:when
                                       test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode != ''">
                                       <D_4053>
                                          <xsl:value-of
                                             select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode"
                                          />
                                       </D_4053>
                                    </xsl:when>
                                    <!-- IG-1420 - Ashish - If TTCode is a valid code, then write TTCode itself -->
                                    <xsl:when
                                       test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[EDIFACTCode = $TTCode]/CXMLCode != ''">
                                       <D_4053>
                                          <xsl:value-of select="$TTCode"/>
                                       </D_4053>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <D_4053>ZZZ</D_4053>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:if
                                    test="normalize-space(TermsOfDelivery/Comments[@type = 'TermsOfDelivery']) != ''">
                                    <D_4052>
                                       <xsl:value-of
                                          select="substring(normalize-space(TermsOfDelivery/Comments[@type = 'TermsOfDelivery']), 1, 70)"
                                       />
                                    </D_4052>
                                 </xsl:if>
                                 <xsl:if
                                    test="normalize-space(TermsOfDelivery/Comments[@type = 'Transport']) != ''">
                                    <D_4052_2>
                                       <xsl:value-of
                                          select="substring(normalize-space(TermsOfDelivery/Comments[@type = 'Transport']), 1, 70)"
                                       />
                                    </D_4052_2>
                                 </xsl:if>
                              </C_C100>
                           </xsl:if>
                        </S_TOD>
                        <xsl:if
                           test="normalize-space(TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other']) != '' or normalize-space(TermsOfDelivery/ShippingPaymentMethod[@value = 'Other']) != '' or normalize-space(TermsOfDelivery/TransportTerms[@value = 'Other']) != '' or $Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode = '' or $Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode = '' or $Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode = ''">
                           <S_LOC>
                              <D_3227>ZZZ</D_3227>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other']) != ''">
                                    <C_C517>
                                       <D_3225>TDC</D_3225>
                                       <D_3224>
                                          <xsl:value-of
                                             select="substring(normalize-space(TermsOfDelivery/TermsOfDeliveryCode[@value = 'Other']), 1, 70)"
                                          />
                                       </D_3224>
                                    </C_C517>
                                 </xsl:when>
                                 <xsl:when
                                    test="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EDIFACTCode = ''">
                                    <C_C517>
                                       <D_3225>TDC</D_3225>
                                       <D_3224>
                                          <xsl:value-of
                                             select="substring(normalize-space($TODCode), 1, 70)"/>
                                       </D_3224>
                                    </C_C517>
                                 </xsl:when>
                              </xsl:choose>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(TermsOfDelivery/ShippingPaymentMethod[@value = 'Other']) != ''">
                                    <C_C519>
                                       <D_3223>SPM</D_3223>
                                       <D_3222>
                                          <xsl:value-of
                                             select="substring(normalize-space(TermsOfDelivery/ShippingPaymentMethod[@value = 'Other']), 1, 70)"
                                          />
                                       </D_3222>
                                    </C_C519>
                                 </xsl:when>
                                 <xsl:when
                                    test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EDIFACTCode = ''">
                                    <C_C519>
                                       <D_3223>SPM</D_3223>
                                       <D_3222>
                                          <xsl:value-of
                                             select="substring(normalize-space($SPMCode), 1, 70)"/>
                                       </D_3222>
                                    </C_C519>
                                 </xsl:when>
                              </xsl:choose>
                              <xsl:choose>
                                 <xsl:when
                                    test="normalize-space(TermsOfDelivery/TransportTerms[@value = 'Other']) != ''">
                                    <C_C553>
                                       <D_3233>TTC</D_3233>
                                       <D_3232>
                                          <xsl:value-of
                                             select="substring(normalize-space(TermsOfDelivery/TransportTerms[@value = 'Other']), 1, 70)"
                                          />
                                       </D_3232>
                                    </C_C553>
                                 </xsl:when>
                                 <xsl:when
                                    test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTCode]/EDIFACTCode = ''"
                                    >"> <C_C553><D_3233>TTC</D_3233><D_3232><xsl:value-of
                                             select="substring(normalize-space($TTCode), 1, 70)"
                                          /></D_3232></C_C553></xsl:when>
                              </xsl:choose>
                           </S_LOC>
                        </xsl:if>
                     </G_SG47>
                  </xsl:if>
                  <!-- ItemOut>ScheduleLine -->
                  <xsl:for-each select="ScheduleLine">
                     <xsl:if test="@quantity != ''">
                        <G_SG49>
                           <S_SCC>
                              <D_4017>
                                 <xsl:choose>
                                    <xsl:when
                                       test="ScheduleLineReleaseInfo/@commitmentCode = 'firm'"
                                       >1</xsl:when>
                                    <xsl:when
                                       test="ScheduleLineReleaseInfo/@commitmentCode = 'tradeoff'"
                                       >26</xsl:when>
                                    <xsl:when
                                       test="ScheduleLineReleaseInfo/@commitmentCode = 'forecast'"
                                       >4</xsl:when>
                                    <xsl:otherwise>1</xsl:otherwise>
                                 </xsl:choose>
                              </D_4017>
                           </S_SCC>

                           <!--IG-20205-->
                           <S_RFF>
                              <C_C506>
                                 <D_1153>AAN</D_1153>
                                 <D_1156>
                                    <xsl:value-of select="@lineNumber"/>
                                 </D_1156>
                              </C_C506>
                           </S_RFF>
                          

                           <xsl:if test="normalize-space(@quantity) != ''">
                              <G_SG50>
                                 <S_QTY>
                                    <C_C186>
                                       <D_6063>21</D_6063>
                                       <D_6060>
                                          <xsl:call-template name="formatDecimal">
                                             <xsl:with-param name="amount" select="@quantity"/>
                                          </xsl:call-template>
                                       </D_6060>
                                       <xsl:if test="normalize-space(UnitOfMeasure) != ''">
                                          <D_6411>
                                             <xsl:value-of select="UnitOfMeasure"/>
                                          </D_6411>
                                       </xsl:if>
                                    </C_C186>
                                 </S_QTY>
                                 <xsl:variable name="rdDate">
                                    <xsl:call-template name="formatDate1">
                                       <xsl:with-param name="DocDate"
                                          select="normalize-space(@requestedDeliveryDate)"/>
                                    </xsl:call-template>
                                 </xsl:variable>
                                 <xsl:variable name="rdDate1">
                                    <xsl:call-template name="formatDate2">
                                       <xsl:with-param name="DocDate"
                                          select="normalize-space(@requestedDeliveryDate)"/>
                                    </xsl:call-template>
                                 </xsl:variable>
                                 <xsl:variable name="dWindow">
                                    <xsl:choose>
                                       <xsl:when test="@deliveryWindow">
                                          <xsl:value-of select="normalize-space(@deliveryWindow)"/>
                                       </xsl:when>
                                       <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:variable>
                                 <xsl:variable name="testDate" as="xs:date">
                                    <xsl:value-of select="xs:date($rdDate1)"/>
                                 </xsl:variable>
                                 <xsl:variable name="endDate">
                                    <xsl:choose>
                                       <xsl:when test="$dWindow castable as xs:duration">
                                          <xsl:value-of
                                             select="$testDate + xs:dayTimeDuration($dWindow)"/>
                                       </xsl:when>
                                       <xsl:when test="$dWindow castable as xs:decimal">
                                          <xsl:value-of
                                             select="$testDate + xs:dayTimeDuration(concat('P', $dWindow, 'D'))"
                                          />
                                       </xsl:when>
                                    </xsl:choose>
                                 </xsl:variable>
                                 <S_DTM>
                                    <C_C507>
                                       <D_2005>2</D_2005>
                                       <D_2380>
                                          <xsl:value-of
                                             select="concat($rdDate, '-', replace($endDate, '-', ''))"
                                          />
                                       </D_2380>
                                       <D_2379>718</D_2379>
                                    </C_C507>
                                 </S_DTM>
                              </G_SG50>
                           </xsl:if>
                           <xsl:if
                              test="normalize-space(ScheduleLineReleaseInfo/@cumulativeScheduledQuantity) != ''">
                              <G_SG50>
                                 <S_QTY>
                                    <C_C186>
                                       <D_6063>3</D_6063>
                                       <D_6060>
                                          <xsl:call-template name="formatDecimal">
                                             <xsl:with-param name="amount"
                                                select="ScheduleLineReleaseInfo/@cumulativeScheduledQuantity"
                                             />
                                          </xsl:call-template>
                                       </D_6060>
                                       <xsl:if
                                          test="normalize-space(ScheduleLineReleaseInfo/UnitOfMeasure) != ''">
                                          <D_6411>
                                             <xsl:value-of
                                                select="normalize-space(ScheduleLineReleaseInfo/UnitOfMeasure)"
                                             />
                                          </D_6411>
                                       </xsl:if>
                                    </C_C186>
                                 </S_QTY>
                              </G_SG50>
                           </xsl:if>
                        </G_SG49>
                     </xsl:if>
                  </xsl:for-each>
               </G_SG25>
            </xsl:for-each>

            <!--IG-20205-added new loop SG25 (LIN++:MP with 7083="A") for SubcontractingComponent-->
            <xsl:for-each select="cXML/Request/OrderRequest/ItemOut/ScheduleLine">
               <xsl:for-each select="SubcontractingComponent">
                  <G_SG25>
                     <S_LIN>
                        <C_C212>
                           <D_7140>
                              <xsl:value-of select="normalize-space(ComponentID)"/>
                           </D_7140>
                           <D_7143>AB</D_7143>
                        </C_C212>
                        <C_C829>
                           <D_5495>1</D_5495>
                           <D_1082>
                              <xsl:value-of select="../../@lineNumber"/>
                           </D_1082>
                        </C_C829>
                        <D_7083>A</D_7083>
                     </S_LIN>
                     <!-- ItemIDs -->
                     <xsl:variable name="piaList">
                        <PartsList>                           
                           <xsl:if test="normalize-space(Product/SupplierPartID) != ''">
                              <Part>
                                 <Qualifier>VN</Qualifier>
                                 <Value>
                                    <xsl:value-of
                                       select="substring(normalize-space(Product/SupplierPartID), 1, 35)"/>
                                 </Value>
                              </Part>
                           </xsl:if>
                           <xsl:if test="normalize-space(Product/SupplierPartAuxiliaryID) != ''">
                              <Part>
                                 <Qualifier>VS</Qualifier>
                                 <Value>
                                    <xsl:value-of
                                       select="substring(normalize-space(Product/SupplierPartAuxiliaryID), 1, 35)"/>
                                 </Value>
                              </Part>
                           </xsl:if><xsl:if test="normalize-space(Product/BuyerPartID) != ''">
                              <Part>
                                 <Qualifier>BP</Qualifier>
                                 <Value>
                                    <xsl:value-of
                                       select="substring(normalize-space(Product/BuyerPartID), 1, 35)"/>
                                 </Value>
                              </Part>
                           </xsl:if><xsl:if test="normalize-space(ProductRevisionID) != ''">
                              <Part>
                                 <Qualifier>DR</Qualifier>
                                 <Value>
                                    <xsl:value-of
                                       select="substring(normalize-space(ProductRevisionID), 1, 35)"/>
                                 </Value>
                              </Part>
                           </xsl:if>
                        </PartsList>
                     </xsl:variable>

                     <xsl:if test="$piaList/PartsList/Part">                    
                        <S_PIA>
                           <D_4347>1</D_4347>
                           <xsl:for-each select="$piaList/PartsList/Part">
                              <xsl:choose>
                                 <xsl:when test="position() = 1">					
                                    <C_C212>					
                                       <xsl:element name="D_7140">
                                          <xsl:value-of select="./Value"/>
                                       </xsl:element>
                                       <xsl:element name="D_7143">
                                          <xsl:value-of select="./Qualifier"/>
                                       </xsl:element>						
                                    </C_C212>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:element name="{concat('C_C212', '_', position())}">
                                       <xsl:element name="D_7140">
                                          <xsl:value-of select="./Value"/>
                                       </xsl:element>
                                       <xsl:element name="D_7143">
                                          <xsl:value-of select="./Qualifier"/>
                                       </xsl:element>	
                                    </xsl:element>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:for-each>
                        </S_PIA>
                     </xsl:if>
                     <!-- Description shortName -->
                     <xsl:if
                        test="normalize-space(Description/ShortName) != ''">
                        <xsl:variable name="shortName">
                          
                                 <xsl:value-of
                                    select="normalize-space(Description/ShortName)"/>
                        </xsl:variable>
                        <xsl:variable name="langCode">
                        
                              
                              <xsl:if
                                 test="normalize-space(Description/@xml:lang) != ''">
                                 <xsl:value-of
                                    select="normalize-space(Description/@xml:lang)"/>
                              </xsl:if>
                           
                        </xsl:variable>
                        <xsl:if test="$shortName != ''">
                           <xsl:call-template name="IMDLoop">
                              <xsl:with-param name="IMDQual" select="'E'"/>
                              <xsl:with-param name="IMDData" select="$shortName"/>
                              <xsl:with-param name="langCode" select="$langCode"/>
                           </xsl:call-template>
                        </xsl:if>
                     </xsl:if>
                     <!-- Just Description -->
                     <xsl:if
                        test="normalize-space(Description) != ''">
                        <xsl:variable name="descText">
                           
                                 <xsl:value-of select="normalize-space(Description)"/>
                        </xsl:variable>
                        <xsl:variable name="langCode">
                          
                                 <xsl:value-of
                                    select="normalize-space(Description/@xml:lang)"/>
                             
                           
                        </xsl:variable>
                        <xsl:if test="$descText != ''">
                           <xsl:call-template name="IMDLoop">
                              <xsl:with-param name="IMDQual" select="'F'"/>
                              <xsl:with-param name="IMDData" select="$descText"/>
                              <xsl:with-param name="langCode" select="$langCode"/>
                           </xsl:call-template>
                        </xsl:if>
                     </xsl:if>
               
                     
                     <!-- SubcontractingComponent @quantity -->
                     <xsl:if test="normalize-space(@quantity) != ''">
                        <S_QTY>
                           <C_C186>
                              <D_6063>163</D_6063>
                              <D_6060>
                                 <xsl:call-template name="formatDecimal">
                                    <xsl:with-param name="amount" select="@quantity"/>
                                 </xsl:call-template>
                              </D_6060>
                             
                                 <xsl:if
                                    test="normalize-space(UnitOfMeasure) != ''">
                                    <D_6411>
                                       <xsl:value-of
                                          select="normalize-space(UnitOfMeasure)"
                                       />
                                    </D_6411>
                                 </xsl:if>
                                 
                           </C_C186>
                        </S_QTY>
                     </xsl:if>
                   
                     
                     <!-- SubcontractingComponent @requirementDate -->
                     <xsl:if test="normalize-space(@requirementDate) != ''">
                        <S_DTM>
                           <C_C507>
                              <D_2005>318</D_2005>
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="normalize-space(@requirementDate)"/>
                              </xsl:call-template>
                           </C_C507>
                        </S_DTM>
                     </xsl:if>
     
                     
                     <!-- ScheduleLine @lineNumber -->
                     <xsl:if test="normalize-space(../@lineNumber)">
                        <G_SG29>
                           <S_RFF>
                              <C_C506>
                                 <D_1153>AAN</D_1153>
                                 <D_1156>
                                    <xsl:value-of
                                       select="normalize-space(../@lineNumber)"/>
                                 </D_1156>
                              </C_C506>
                           </S_RFF>
                        </G_SG29>
                     </xsl:if>
                     <!-- SubcontractingComponent/@materialProvisionIndicator-->
                     <xsl:if test="normalize-space(@materialProvisionIndicator) != ''">
                        <G_SG29>
                           <S_RFF>
                              <C_C506>
                                 <D_1153>ACJ</D_1153>
                                 <D_1154>
                                    <xsl:value-of select="normalize-space(@materialProvisionIndicator)"/>
                                 </D_1154>
                                 
                              </C_C506>
                           </S_RFF>
                        </G_SG29>
                     </xsl:if>
                    
                     <!-- IG-20205: added new loop SG30 PAC+0 for Batch in sync with addition for SubcontractingComponent, if SubcontractingComponent/batch exists -->
                     <xsl:if test="exists(Batch)">
                       
                        <xsl:call-template name="subContract">
                           <xsl:with-param name="path" select="."/>
                        </xsl:call-template>
                        
                     </xsl:if>

             
                     
                  </G_SG25>
               </xsl:for-each>
            </xsl:for-each>

            <!--- Summary -->
            <S_UNS>
               <D_0081>S</D_0081>
            </S_UNS>
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Total/Money) != ''">
               <xsl:call-template name="createMOA">
                  <xsl:with-param name="qual" select="'128'"/>
                  <xsl:with-param name="money"
                     select="cXML/Request/OrderRequest/OrderRequestHeader/Total"/>
                  <xsl:with-param name="createAlternate" select="'yes'"/>
               </xsl:call-template>
            </xsl:if>
            <xsl:if
               test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Tax/Money) != ''">
               <xsl:call-template name="createMOA">
                  <xsl:with-param name="qual" select="'124'"/>
                  <xsl:with-param name="money"
                     select="cXML/Request/OrderRequest/OrderRequestHeader/Tax"/>
                  <xsl:with-param name="createAlternate" select="'yes'"/>
               </xsl:call-template>
            </xsl:if>
            <S_CNT>
               <C_C270>
                  <D_6069>2</D_6069>
                  <D_6066>
                     <xsl:value-of select="count(cXML/Request/OrderRequest/ItemOut)"/>
                  </D_6066>
               </C_C270>
            </S_CNT>
            <S_UNT>
               <D_0074>#segCount#</D_0074>
               <D_0062>0001</D_0062>
            </S_UNT>
         </xsl:element>
         <S_UNZ>
            <D_0036>1</D_0036>
            <D_0020>
               <xsl:value-of select="$anICNValue"/>
            </D_0020>
         </S_UNZ>
      </ns0:Interchange>
   </xsl:template>
   <!-- IG-20205 ER - EDIFACT ORDERS D96A Out - to add SubcontractingComponent for SCC-->
   <xsl:template name="subContract">
      <xsl:param name="path"/>
      <G_SG30>
         
         <S_PAC>
            <D_7224>0</D_7224>
            <C_C402>
               <D_7077>A</D_7077>
               <D_7064>batchInformation</D_7064>
            </C_C402>
            
         </S_PAC>
         
         <xsl:if test="normalize-space($path/Batch/@batchQuantity) != ''">
            <S_QTY>
               <C_C186>
                  <D_6063>21</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                                    <xsl:with-param name="amount"
                                       select="substring(normalize-space($path/Batch/@batchQuantity), 1, 15)"
                                    />
                                 </xsl:call-template>
                     
                     
                  </D_6060>
                  
               </C_C186>
            </S_QTY>
         </xsl:if>
         
         <xsl:if test="normalize-space($path/Batch/@expirationDate) != ''">
            <S_DTM>
               <C_C507>
                  <D_2005>36</D_2005>
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="normalize-space($path/Batch/@expirationDate)"/>
                  </xsl:call-template>
               </C_C507>
            </S_DTM>
         </xsl:if>
         <xsl:if test="normalize-space($path/Batch/@productionDate) != ''">
            <S_DTM>
               <C_C507>
                  <D_2005>94</D_2005>
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="normalize-space($path/Batch/@productionDate)"/>
                  </xsl:call-template>
               </C_C507>
            </S_DTM>
         </xsl:if>
         <xsl:if test="normalize-space($path/Batch/@inspectionDate) != ''">
            <S_DTM>
               <C_C507>
                  <D_2005>351</D_2005>
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="normalize-space($path/Batch/@inspectionDate)"/>
                  </xsl:call-template>
               </C_C507>
            </S_DTM>
            
         </xsl:if>
         
         <G_SG31>
            <S_RFF>
               <C_C506>
                  <D_1153>BT</D_1153>
                  
                  <xsl:if test="$path/Batch/@originCountryCode != ''">
                     <D_1154>
                        <xsl:value-of
                           select="normalize-space($path/Batch/@originCountryCode)"/>
                     </D_1154>
                  </xsl:if>
                  <xsl:if test="$path/Batch/@shelfLife != ''">
                     <D_4000>
                        <xsl:value-of select="normalize-space($path/Batch/@shelfLife)"/>
                     </D_4000>
                  </xsl:if>
               </C_C506>
            </S_RFF>
         </G_SG31>
         
         <xsl:if test="$path/Batch/BuyerBatchID != '' or $path/Batch/SupplierBatchID != ''">
            <G_SG32>
               <S_PCI>
                  <D_4233>10</D_4233>
               </S_PCI>
               <S_GIN>
                  <D_7405>BX</D_7405>
                  <xsl:choose>
                     <xsl:when test="$path/Batch/BuyerBatchID != ''">
                        <C_C208>
                           <D_7402>
                              <xsl:value-of
                                 select="substring(normalize-space($path/Batch/BuyerBatchID),1,35)"/>
                           </D_7402>
                           <D_7402_2>92</D_7402_2>
                        </C_C208>
                        <xsl:if test="$path/Batch/SupplierBatchID != ''">
                           <C_C208_2>
                              <D_7402>
                                 <xsl:value-of
                                    select="substring(normalize-space($path/Batch/SupplierBatchID),1,35)"/>
                              </D_7402>
                              <D_7402_2>91</D_7402_2>
                           </C_C208_2>
                        </xsl:if>
                     </xsl:when>
                     <xsl:otherwise>
                        <C_C208>
                           <D_7402>
                              <xsl:value-of
                                 select="substring(normalize-space($path/Batch/SupplierBatchID),1,35)"/>
                           </D_7402>
                           <D_7402_2>91</D_7402_2>
                        </C_C208>
                     </xsl:otherwise>
                  </xsl:choose>
               </S_GIN>
            </G_SG32>
         </xsl:if>
         
         
      </G_SG30>
   </xsl:template>
</xsl:stylesheet>
