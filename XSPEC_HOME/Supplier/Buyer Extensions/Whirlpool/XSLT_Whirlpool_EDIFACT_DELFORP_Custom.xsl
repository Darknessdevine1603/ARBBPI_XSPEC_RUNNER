<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <!--xsl:variable name="Lookup" select="document('../../lookups/EDIFACT_D96A/LOOKUP_UN-EDIFACT_D96A.xml')"/-->
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_UN-EDIFACT_D96A:Binary')"/>
   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   <!-- Requirement 1 -->
   <xsl:template match="//S_BGM/C_C002">
      <xsl:choose>
         <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType']) != ''">
            <C_C002>
               <xsl:copy-of select="D_1001"/>
               <xsl:copy-of select="D_1131"/>
               <xsl:copy-of select="D_3055"/>
               <D_1000>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType'])"/>
               </D_1000>
            </C_C002>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Requirement 2, 3, 4, 5, 6, 7-->
   <xsl:template match="//M_DELFOR/S_DTM[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Extrinsic[@name = 'startDate']) != ''">
         <S_DTM>
            <C_C507>
               <D_2005>64</D_2005>
               <xsl:call-template name="formatDate">
                  <xsl:with-param name="DocDate" select="normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Extrinsic[@name = 'startDate'])"/>
               </xsl:call-template>
            </C_C507>
         </S_DTM>
      </xsl:if>
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Extrinsic[@name = 'expirationDate']) != ''">
         <S_DTM>
            <C_C507>
               <D_2005>63</D_2005>
               <xsl:call-template name="formatDate">
                  <xsl:with-param name="DocDate" select="normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Extrinsic[@name = 'expirationDate'])"/>
               </xsl:call-template>
            </C_C507>
         </S_DTM>
      </xsl:if>

      <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'orderNo']) != ''">
         <G_SG1>
            <S_RFF>
               <C_C506>
                  <D_1153>ON</D_1153>
                  <D_1154>
                     <xsl:value-of select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'orderNo'])"/>
                  </D_1154>
               </C_C506>
            </S_RFF>
         </G_SG1>
      </xsl:if>

      <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'releaseNo']) != ''">
         <G_SG1>
            <S_RFF>
               <C_C506>
                  <D_1153>RE</D_1153>
                  <D_1154>
                     <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/Extrinsic[@name = 'releaseNo']), 1, 35)"/>
                  </D_1154>
               </C_C506>
            </S_RFF>
            <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'accessorialStatusCode']) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>161</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="FormattedDate" select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'accessorialStatusCode'])"/>
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
         </G_SG1>
      </xsl:if>

      <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'unitsShipped']) != ''">
         <G_SG1>
            <S_RFF>
               <C_C506>
                  <D_1153>ACC</D_1153>
                  <D_1154>
                     <xsl:value-of select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'unitsShipped'])"/>
                  </D_1154>
               </C_C506>
            </S_RFF>
         </G_SG1>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 8, 9, 10 -->
   <xsl:template match="//M_DELFOR/G_SG2[S_NAD/D_3035 = 'ZZZ']/S_NAD/D_3035">
      <xsl:choose>
         <xsl:when test="(normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Contact[@role = 'SP']/@addressID) = ../C_C082/D_3039) and (normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Contact[@role = 'SP']/Name) = ../C_C058/D_3124)">
            <D_3035>CA</D_3035>
         </xsl:when>
         <xsl:when test="(normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Contact[@role = 'SLS']/@addressID) = ../C_C082/D_3039) and (normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Contact[@role = 'SLS']/Name) = ../C_C058/D_3124)">
            <D_3035>FW</D_3035>
         </xsl:when>
         <xsl:when test="(normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Contact[@role = '98']/@addressID) = ../C_C082/D_3039) and (normalize-space(//ProductActivityMessage/ProductActivityDetails[1]/Contact[@role = '98']/Name) = ../C_C058/D_3124)">
            <D_3035>CG</D_3035>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Requirement 11 -->
   <xsl:template match="//M_DELJIT/G_SG2/S_NAD/C_C082/D_3055">
      <D_3055>92</D_3055>
   </xsl:template>

   <!-- Requirement 12 -->
   <xsl:template match="//M_DELFOR/G_SG4/S_NAD">
      <xsl:copy-of select="."/>
      <xsl:variable name="locationToID" select="C_C082/D_3039"/>
      <xsl:variable name="sourceItem" select="//ProductActivityMessage/ProductActivityDetails[Contact[@role = 'locationTo']/@addressID = $locationToID]"/>
      <xsl:if test="$sourceItem and ($sourceItem/Extrinsic[@name = 'plantNo'])">
         <S_LOC>
            <D_3227>7</D_3227>
            <C_C517>
               <D_3225>
                  <xsl:value-of select="$sourceItem/Extrinsic[@name = 'plantNo']"/>
               </D_3225>
            </C_C517>
         </S_LOC>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 13, 14 -->
   <xsl:template match="//M_DELFOR/G_SG4/G_SG8/S_PIA[last()]">
      <xsl:copy-of select="."/>
      <xsl:variable name="locationToID" select="../../S_NAD/C_C082/D_3039"/>
      <xsl:variable name="sourceItem" select="//ProductActivityMessage/ProductActivityDetails[Contact[@role = 'locationTo']/@addressID = $locationToID]"/>
      <xsl:if test="normalize-space($sourceItem/ItemID/SupplierPartID/@revisionID) != ''">
         <S_PIA>
            <D_4347>1</D_4347>
            <C_C212>
               <D_7140>
                  <xsl:value-of select="normalize-space($sourceItem/ItemID/SupplierPartID/@revisionID)"/>
               </D_7140>
               <D_7143>RN</D_7143>
            </C_C212>
         </S_PIA>
      </xsl:if>
      <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'deliveryDate']) != ''">
         <S_PIA>
            <D_4347>1</D_4347>
            <C_C212>
               <D_7140>
                  <xsl:value-of select="replace(substring(normalize-space($sourceItem/Extrinsic[@name = 'deliveryDate']), 1, 10), '-', '')"/>
               </D_7140>
               <D_7143>EC</D_7143>
            </C_C212>
         </S_PIA>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 15, 20 to 27 -->
   <xsl:template match="//M_DELFOR/G_SG4/G_SG8/S_DTM[1]">
      <xsl:variable name="locationToID" select="../../S_NAD/C_C082/D_3039"/>
      <xsl:variable name="sourceItem" select="//ProductActivityMessage/ProductActivityDetails[Contact[@role = 'locationTo']/@addressID = $locationToID]"/>
      <!-- Requirement 15 -->
      <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'binLocationNo']) != ''">
         <S_LOC>
            <D_3227>11</D_3227>
            <C_C517>
               <D_3225>
                  <xsl:value-of select="normalize-space($sourceItem/Extrinsic[@name = 'binLocationNo'])"/>
               </D_3225>
            </C_C517>
         </S_LOC>
      </xsl:if>
      <xsl:copy-of select="../S_DTM | ../S_FTX | ../G_SG9 | ../G_SG10 | ../G_SG11"/>
      <!-- Requirement 20 -->
      <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'carrierShipmentID']) != ''">
         <G_SG12>
            <S_QTY>
               <C_C186>
                  <D_6063>57</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="//$sourceItem/Extrinsic[@name = 'carrierShipmentID']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
         </G_SG12>
      </xsl:if>
      <!-- Requirement 21 to 23 -->
      <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'poShipmentNumber']) != ''">
         <G_SG12>
            <S_QTY>
               <C_C186>
                  <D_6063>94</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="$sourceItem/Extrinsic[@name = 'poShipmentNumber']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'hourstodate']) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>161</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate" select="normalize-space($sourceItem/Extrinsic[@name = 'hourstodate'])"/>
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'termsOfDeliveryCode']) != ''">
               <G_SG13>
                  <S_RFF>
                     <C_C506>
                        <D_1153>ZZZ</D_1153>
                        <D_1154>termsOfDeliveryCode</D_1154>
                        <D_4000>
                           <xsl:value-of select="substring(normalize-space($sourceItem/Extrinsic[@name = 'termsOfDeliveryCode']), 1, 35)"/>
                        </D_4000>
                     </C_C506>
                  </S_RFF>
               </G_SG13>
            </xsl:if>
         </G_SG12>
      </xsl:if>
      <!-- Requirement 24 to 26 -->
      <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'combinedShipment']) != ''">
         <G_SG12>
            <S_QTY>
               <C_C186>
                  <D_6063>90</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="$sourceItem/Extrinsic[@name = 'combinedShipment']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'lossdate']) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>94</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate" select="normalize-space($sourceItem/Extrinsic[@name = 'lossdate'])"/>
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'deliveryRegion']) != ''">
               <G_SG13>
                  <S_RFF>
                     <C_C506>
                        <D_1153>ZZZ</D_1153>
                        <D_1154>deliveryRegion</D_1154>
                        <D_4000>
                           <xsl:value-of select="substring(normalize-space($sourceItem/Extrinsic[@name = 'deliveryRegion']), 1, 35)"/>
                        </D_4000>
                     </C_C506>
                  </S_RFF>
               </G_SG13>
            </xsl:if>
         </G_SG12>
      </xsl:if>

      <xsl:choose>
         <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType']) = 'DL'">
            <!-- Requirement 27, 28, 29 -->
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'deliveryNoteNumber']) != ''">
               <G_SG12>
                  <S_QTY>
                     <C_C186>
                        <D_6063>48</D_6063>
                        <D_6060>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="$sourceItem/Extrinsic[@name = 'deliveryNoteNumber']"/>
                           </xsl:call-template>
                        </D_6060>
                        <D_6411>EA</D_6411>
                     </C_C186>
                  </S_QTY>
                  <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'T_C_Date_Stamp']) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>50</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate" select="normalize-space($sourceItem/Extrinsic[@name = 'T_C_Date_Stamp'])"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
                  <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'packingListNo']) != ''">
                     <G_SG13>
                        <S_RFF>
                           <C_C506>
                              <D_1153>PK</D_1153>
                              <D_1154>
                                 <xsl:value-of select="substring(normalize-space($sourceItem/Extrinsic[@name = 'packingListNo']), 1, 35)"/>
                              </D_1154>
                           </C_C506>
                        </S_RFF>
                     </G_SG13>
                  </xsl:if>
               </G_SG12>
            </xsl:if>
            <!-- Requirement 30, 31 -->
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'minQtyPerRelease']) != ''">
               <G_SG12>
                  <S_QTY>
                     <C_C186>
                        <D_6063>70</D_6063>
                        <D_6060>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="$sourceItem/Extrinsic[@name = 'minQtyPerRelease']"/>
                           </xsl:call-template>
                        </D_6060>
                        <D_6411>EA</D_6411>
                     </C_C186>
                  </S_QTY>
                  <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'touAcceptanceDate']) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>51</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate" select="normalize-space($sourceItem/Extrinsic[@name = 'touAcceptanceDate'])"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
               </G_SG12>
            </xsl:if>
         </xsl:when>
         <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType']) = 'SH'">
            <!-- Requirement 32, 33, 34 -->
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'carrierAssignedShipperNo']) != ''">
               <G_SG12>
                  <S_QTY>
                     <C_C186>
                        <D_6063>12</D_6063>
                        <D_6060>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="$sourceItem/Extrinsic[@name = 'carrierAssignedShipperNo']"/>
                           </xsl:call-template>
                        </D_6060>
                        <D_6411>EA</D_6411>
                     </C_C186>
                  </S_QTY>
                  <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'endDate']) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>11</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate" select="normalize-space($sourceItem/Extrinsic[@name = 'endDate'])"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
                  <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'consolidationShipmentNumber']) != ''">
                     <G_SG13>
                        <S_RFF>
                           <C_C506>
                              <D_1153>SRN</D_1153>
                              <D_1154>
                                 <xsl:value-of select="substring(normalize-space($sourceItem/Extrinsic[@name = 'consolidationShipmentNumber']), 1, 35)"/>
                              </D_1154>
                           </C_C506>
                        </S_RFF>
                     </G_SG13>
                  </xsl:if>
               </G_SG12>
            </xsl:if>
            <!-- Requirement 35, 36 -->
            <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'agentsShipmentNo']) != ''">
               <G_SG12>
                  <S_QTY>
                     <C_C186>
                        <D_6063>186</D_6063>
                        <D_6060>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="$sourceItem/Extrinsic[@name = 'agentsShipmentNo']"/>
                           </xsl:call-template>
                        </D_6060>
                        <D_6411>EA</D_6411>
                     </C_C186>
                  </S_QTY>
                  <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'touAcceptanceDate']) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>51</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate" select="normalize-space($sourceItem/Extrinsic[@name = 'touAcceptanceDate'])"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
               </G_SG12>
            </xsl:if>
         </xsl:when>
      </xsl:choose>

      <xsl:if test="normalize-space($sourceItem/Extrinsic[@name = 'buyerDueShipQuantity']) != ''">
         <G_SG11>
            <S_QTY>
               <C_C186>
                  <D_6063>91</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="$sourceItem/Extrinsic[@name = 'buyerDueShipQuantity']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
         </G_SG11>
      </xsl:if>
   </xsl:template>

   <xsl:template match="//M_DELFOR/G_SG4/G_SG8">
      <xsl:variable name="locationToID" select="../S_NAD/C_C082/D_3039"/>
      <xsl:variable name="sourceItem" select="//ProductActivityMessage/ProductActivityDetails[Contact[@role = 'locationTo']/@addressID = $locationToID]"/>
      <G_SG8>
         <xsl:apply-templates select="./child::*[name() != 'G_SG12']"/>
         <xsl:copy-of select="G_SG12[S_SCC != '4']"/>
         <xsl:for-each select="G_SG12[S_SCC = '4']">
            <xsl:variable name="posForecastQty">
               <xsl:number level="any"/>
            </xsl:variable>
            <xsl:variable name="forecastItem" select="$sourceItem/TimeSeries/Forecast[number($posForecastQty)]"/>
            <G_SG12>
               <S_QTY>
                  <C_C186>
                     <D_6063>
                        <xsl:choose>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'firm'">113</xsl:when>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'forecast'">99</xsl:when>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'tradeoff'">99</xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="S_QTY/C_C186/D_6063"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </D_6063>
                     <xsl:copy-of select="S_QTY/C_C186/D_6063/following-sibling::*"/>
                  </C_C186>
               </S_QTY>
               <S_SCC>
                  <D_4017>
                     <xsl:choose>
                        <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'firm'">1</xsl:when>
                        <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'forecast'">4</xsl:when>
                        <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'tradeoff'">4</xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="S_SCC/D_4017"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </D_4017>
                  <D_4493>
                     <xsl:choose>
                        <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'firm'">DD</xsl:when>
                        <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'forecast'">P1</xsl:when>
                        <xsl:when test="$forecastItem/Extrinsic[@name = 'refinerID'] = 'tradeoff'">P1</xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="S_SCC/D_4493"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </D_4493>
                  <C_C329>
                     <D_2013>
                        <xsl:choose>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'deliveryQuoteNo'] = 'C'">Y</xsl:when>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'deliveryQuoteNo'] = 'M'">M</xsl:when>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'deliveryQuoteNo'] = 'T'">T</xsl:when>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'deliveryQuoteNo'] = 'W'">W</xsl:when>
                           <xsl:when test="$forecastItem/Extrinsic[@name = 'deliveryQuoteNo'] = 'Z'">A</xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="S_SCC/C_C329/D_2013"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </D_2013>
                     <xsl:value-of select="S_SCC/D_4493/D_2013/following-sibling::*"/>
                  </C_C329>
               </S_SCC>
               <xsl:copy-of select="S_SCC/following-sibling::*"/>
            </G_SG12>
         </xsl:for-each>
      </G_SG8>
   </xsl:template>

   <xsl:template name="formatDate">
      <!-- convert Ariba cXML date to EDI Format -->
      <xsl:param name="DocDate"/>
      <xsl:param name="FormattedDate" required="no"/>
      <xsl:choose>
         <xsl:when test="$DocDate">
            <xsl:variable name="date">
               <xsl:choose>
                  <xsl:when test="contains($DocDate, 'T')">
                     <xsl:value-of select="replace(substring-before($DocDate, 'T'), '-', '')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="replace(substring($DocDate, 1, 10), '-', '')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="time">
               <xsl:value-of select="substring-after($DocDate, 'T')"/>
            </xsl:variable>
            <xsl:variable name="timezone">
               <xsl:if test="$time != ''">
                  <xsl:choose>
                     <xsl:when test="contains($time, '-')">
                        <xsl:value-of select="concat('-', substring-after($time, '-'))"/>
                     </xsl:when>
                     <xsl:when test="contains($time, '+')">
                        <xsl:value-of select="concat('+', substring-after($time, '+'))"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="time">
               <xsl:if test="$time != ''">
                  <xsl:choose>
                     <xsl:when test="contains($time, '-')">
                        <xsl:value-of select="replace(substring-before($time, '-'), ':', '')"/>
                     </xsl:when>
                     <xsl:when test="contains($time, '+')">
                        <xsl:value-of select="replace(substring-before($time, '+'), ':', '')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="replace($time, ':', '')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="SS">
               <xsl:if test="string-length($time) = 6">
                  <xsl:value-of select="substring($time, 5)"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="HH">
               <xsl:value-of select="substring($time, 3, 2)"/>
            </xsl:variable>
            <xsl:variable name="TZone" select="concat($Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timezone][1]/EDIFACTCode, '')"/>
            <D_2380>
               <xsl:value-of select="concat($date, $time, $TZone)"/>
            </D_2380>
            <D_2379>304</D_2379>
         </xsl:when>
         <xsl:when test="$FormattedDate">
            <D_2380>
               <xsl:value-of select="$FormattedDate"/>
            </D_2380>
            <D_2379>102</D_2379></xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="formatDecimal">
      <xsl:param name="amount"/>
      <xsl:variable name="tempAmount" select="replace(normalize-space($amount), ',', '')"/>
      <xsl:choose>
         <xsl:when test="$tempAmount castable as xs:decimal">
            <xsl:value-of select="xs:decimal($tempAmount)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="normalize-space($tempAmount)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Extension Ends -->
   <xsl:template match="//Combined">
      <xsl:apply-templates select="@* | node()"/>
   </xsl:template>
   <xsl:template match="//target">
      <xsl:apply-templates select="@* | node()"/>
   </xsl:template>
   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>
