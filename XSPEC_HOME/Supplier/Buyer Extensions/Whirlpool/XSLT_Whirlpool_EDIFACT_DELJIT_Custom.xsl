<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <!--xsl:variable name="Lookup" select="document('../../lookups/EDIFACT_D96A/LOOKUP_UN-EDIFACT_D96A.xml')"/-->
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_UN-EDIFACT_D96A:Binary')"/>
   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   <!-- Requirement 1 -->
   <xsl:template match="//S_BGM/C_C002/D_1000">
      <xsl:choose>
         <xsl:when test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) != ''">
            <D_1000>
               <xsl:value-of select="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType'])"/>
            </D_1000>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Requirement 2 -->
   <xsl:template match="//S_BGM/D_1225">
      <D_1225>9</D_1225>
   </xsl:template>

   <!-- Requirement 3 & 4-->
   <xsl:template match="//M_DELJIT/S_DTM[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[1]/ItemDetail/Extrinsic[@name = 'startDate']) != ''">
         <S_DTM>
            <C_C507>
               <D_2005>64</D_2005>
               <xsl:call-template name="formatDate">
                  <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[1]/ItemDetail/Extrinsic[@name = 'startDate'])"/>
               </xsl:call-template>
            </C_C507>
         </S_DTM>
      </xsl:if>
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[1]/ItemDetail/Extrinsic[@name = 'expirationDate']) != ''">
         <S_DTM>
            <C_C507>
               <D_2005>63</D_2005>
               <xsl:call-template name="formatDate">
                  <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[1]/ItemDetail/Extrinsic[@name = 'expirationDate'])"/>
               </xsl:call-template>
            </C_C507>
         </S_DTM>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 5 -->
   <xsl:template match="//M_DELJIT/G_SG1[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'scheduleRefNo']) != ''">
         <G_SG1>
            <S_RFF>
               <C_C506>
                  <D_1153>ACC</D_1153>
                  <D_1154>
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'scheduleRefNo']), 1, 35)"/>
                  </D_1154>
               </C_C506>
            </S_RFF>
         </G_SG1>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 6, 7, 8 -->
   <xsl:template match="//M_DELJIT/G_SG2[S_NAD/D_3035 = 'ZZZ']/S_NAD/D_3035">
      <xsl:choose>
         <xsl:when test="(normalize-space(//OrderRequest/OrderRequestHeader/Contact[@role = 'FreightManager1']/@addressID) = ../C_C082/D_3039) and (normalize-space(//OrderRequest/OrderRequestHeader/Contact[@role = 'FreightManager1']/Name) = ../C_C058/D_3124)">
            <D_3035>CA</D_3035>
         </xsl:when>
         <xsl:when test="(normalize-space(//OrderRequest/OrderRequestHeader/Contact[@role = 'FreightManager2']/@addressID) = ../C_C082/D_3039) and (normalize-space(//OrderRequest/OrderRequestHeader/Contact[@role = 'FreightManager2']/Name) = ../C_C058/D_3124)">
            <D_3035>FW</D_3035>
         </xsl:when>
         <xsl:when test="(normalize-space(//OrderRequest/OrderRequestHeader/Contact[@role = 'ThirdPartyLogisticsProvider']/@addressID) = ../C_C082/D_3039) and (normalize-space(//OrderRequest/OrderRequestHeader/Contact[@role = 'ThirdPartyLogisticsProvider']/Name) = ../C_C058/D_3124)">
            <D_3035>CG</D_3035>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- Requirement 9 -->
   <xsl:template match="//M_DELJIT/G_SG2/S_NAD/C_C082/D_3055">
      <D_3055>92</D_3055>
   </xsl:template>

   <!-- Requirement 10 -->
   <xsl:template match="//M_DELJIT/G_SG4/G_SG7/S_PIA[position()!=last()][D_4347 = '5' and C_C212/D_7143 = 'BP']/D_4347">
      <D_4347>1</D_4347>
   </xsl:template>

   <!-- Requirement 11, 12, 13 -->
   <xsl:template match="//M_DELJIT/G_SG4/G_SG7/S_PIA[last()]">
      <xsl:variable name="posItem" select="count(../preceding-sibling::*)"/>
      <xsl:choose>
         <xsl:when test="./D_4347 = '5' and ./C_C212/D_7143 = 'BP'">
            <S_PIA>
               <D_4347>1</D_4347>
               <xsl:copy-of select="./D_4347/following-sibling::*"/>
            </S_PIA>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemID/IdReference[@domain = 'buyerID']/@identifier) != ''">
         <S_PIA>
            <D_4347>1</D_4347>
            <C_C212>
               <D_7140>
                  <xsl:value-of select="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemID/IdReference[@domain = 'buyerID']/@identifier)"/>
               </D_7140>
               <D_7143>IN</D_7143>
            </C_C212>
         </S_PIA>
      </xsl:if>
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'deliveryDate']) != ''">
         <S_PIA>
            <D_4347>1</D_4347>
            <C_C212>
               <D_7140>
                  <xsl:value-of select="replace(substring(normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'deliveryDate']), 1, 10), '-', '')"/>
               </D_7140>
               <D_7143>EC</D_7143>
            </C_C212>
         </S_PIA>
      </xsl:if>
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'revisionID']) != ''">
         <S_PIA>
            <D_4347>1</D_4347>
            <C_C212>
               <D_7140>
                  <xsl:value-of select="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'revisionID'])"/>
               </D_7140>
               <D_7143>RN</D_7143>
            </C_C212>
         </S_PIA>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 14 to 27 -->
   <xsl:template match="//M_DELJIT/G_SG4/G_SG7/G_SG9[last()]">
      <xsl:variable name="posItem" select="count(../preceding-sibling::*)"/>
      <xsl:copy-of select="."/>
      <!-- Requirement 14 -->
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'binLocationNo']) != ''">
         <G_SG9>
            <S_LOC>
               <D_3227>11</D_3227>
               <C_C517>
                  <D_3225>
                     <xsl:value-of select="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'binLocationNo'])"/>
                  </D_3225>
               </C_C517>
            </S_LOC>
         </G_SG9>
      </xsl:if>
      <!-- Requirement 15 -->
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'carrierShipmentID']) != ''">
         <G_SG11>
            <S_QTY>
               <C_C186>
                  <D_6063>57</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'carrierShipmentID']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
         </G_SG11>
      </xsl:if>
      <!-- Requirement 16 -->
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'buyerDueShipQuantity']) != ''">
         <G_SG11>
            <S_QTY>
               <C_C186>
                  <D_6063>91</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'buyerDueShipQuantity']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
         </G_SG11>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) = 'DL'">
            <!-- Requirement 17, 18, 19 -->
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'deliveryNoteNumber']) != ''">
               <G_SG11>
                  <S_QTY>
                     <C_C186>
                        <D_6063>48</D_6063>
                        <D_6060>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'deliveryNoteNumber']"/>
                           </xsl:call-template>
                        </D_6060>
                        <D_6411>EA</D_6411>
                     </C_C186>
                  </S_QTY>
                  <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'T_C_Date_Stamp']) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>50</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'T_C_Date_Stamp'])"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
                  <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'packingListNo']) != ''">
                     <G_SG12>
                        <S_RFF>
                           <C_C506>
                              <D_1153>PK</D_1153>
                              <D_1154>
                                 <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'packingListNo']), 1, 35)"/>
                              </D_1154>
                           </C_C506>
                        </S_RFF>
                     </G_SG12>
                  </xsl:if>
               </G_SG11>
            </xsl:if>
         </xsl:when>
         <xsl:when test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) = 'SH'">
            <!-- Requirement 20, 21, 22 -->
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'carrierAssignedShipperNo']) != ''">
               <G_SG11>
                  <S_QTY>
                     <C_C186>
                        <D_6063>12</D_6063>
                        <D_6060>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'carrierAssignedShipperNo']"/>
                           </xsl:call-template>
                        </D_6060>
                        <D_6411>EA</D_6411>
                     </C_C186>
                  </S_QTY>
                  <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'endDate']) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>11</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'endDate'])"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
                  <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'consolidationShipmentNumber']) != ''">
                     <G_SG12>
                        <S_RFF>
                           <C_C506>
                              <D_1153>SRN</D_1153>
                              <D_1154>
                                 <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'consolidationShipmentNumber']), 1, 35)"/>
                              </D_1154>
                           </C_C506>
                        </S_RFF>
                     </G_SG12>
                  </xsl:if>
               </G_SG11>
            </xsl:if>
            <!-- Requirement 23, 24 -->
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'agentsShipmentNo']) != ''">
               <G_SG11>
                  <S_QTY>
                     <C_C186>
                        <D_6063>186</D_6063>
                        <D_6060>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'agentsShipmentNo']"/>
                           </xsl:call-template>
                        </D_6060>
                        <D_6411>EA</D_6411>
                     </C_C186>
                  </S_QTY>
                  <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate']) != ''">
                     <S_DTM>
                        <C_C507>
                           <D_2005>11</D_2005>
                           <xsl:call-template name="formatDate">
                              <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'])"/>
                           </xsl:call-template>
                        </C_C507>
                     </S_DTM>
                  </xsl:if>
               </G_SG11>
            </xsl:if>
         </xsl:when>
      </xsl:choose>
      <!-- Requirement 25, 26, 27 -->
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'poShipmentNumber']) != ''">
         <G_SG11>
            <S_QTY>
               <C_C186>
                  <D_6063>94</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'poShipmentNumber']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ReleaseInfo/@materialGoAheadEndDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>161</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[$posItem]/ReleaseInfo/@materialGoAheadEndDate)"/>
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'termsOfDeliveryCode']) != ''">
               <G_SG12>
                  <S_RFF>
                     <C_C506>
                        <D_1153>ZZZ</D_1153>
                        <D_1154>termsOfDeliveryCode</D_1154>
                        <D_4000>
                           <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'termsOfDeliveryCode']), 1, 35)"/>
                        </D_4000>
                     </C_C506>
                  </S_RFF>
               </G_SG12>
            </xsl:if>
         </G_SG11>
      </xsl:if>
      <!-- Requirement 28, 29, 30 -->
      <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'combinedShipment']) != ''">
         <G_SG11>
            <S_QTY>
               <C_C186>
                  <D_6063>90</D_6063>
                  <D_6060>
                     <xsl:call-template name="formatDecimal">
                        <xsl:with-param name="amount" select="//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'combinedShipment']"/>
                     </xsl:call-template>
                  </D_6060>
                  <D_6411>EA</D_6411>
               </C_C186>
            </S_QTY>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ReleaseInfo/@productionGoAheadEndDate) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>94</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[$posItem]/ReleaseInfo/@productionGoAheadEndDate)"/>
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'deliveryRegion']) != ''">
               <G_SG12>
                  <S_RFF>
                     <C_C506>
                        <D_1153>ZZZ</D_1153>
                        <D_1154>deliveryRegion</D_1154>
                        <D_4000>
                           <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'deliveryRegion']), 1, 35)"/>
                        </D_4000>
                     </C_C506>
                  </S_RFF>
               </G_SG12>
            </xsl:if>
         </G_SG11>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 31, 32, 33-->
   <xsl:template match="//M_DELJIT/G_SG4/G_SG7/G_SG11[S_QTY/C_C186/D_6063 = '70']">
      <xsl:variable name="posItem" select="count(../preceding-sibling::*)"/>
      <xsl:if test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) = 'DL'">
         <G_SG11>
            <xsl:copy-of select="S_QTY"/>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate']) != ''">
               <S_DTM>
                  <C_C507>
                     <D_2005>51</D_2005>
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate" select="normalize-space(//OrderRequest/ItemOut[$posItem]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'])"/>
                     </xsl:call-template>
                  </C_C507>
               </S_DTM>
            </xsl:if>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[$posItem]/ReleaseInfo/Extrinsic[@name = 'Release Number']) != ''">
               <G_SG12>
                  <S_RFF>
                     <C_C506>
                        <D_1153>RE</D_1153>
                        <D_1154>
                           <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[$posItem]/ReleaseInfo/Extrinsic[@name = 'Release Number']), 1, 35)"/>
                        </D_1154>
                     </C_C506>
                  </S_RFF>
               </G_SG12>
            </xsl:if>
         </G_SG11>
      </xsl:if>
   </xsl:template>

   <!-- Requirement 34, 35, 37, 38 -->
   <xsl:template match="//M_DELJIT/G_SG4/G_SG7/G_SG11[S_QTY/C_C186/D_6063 = '1']">
      <xsl:variable name="posItem" select="count(../preceding-sibling::*)"/>
      <xsl:variable name="posSchedLine" select="position() - count(./preceding-sibling::*[name()!='G_SG11']) - 1"/>
      <xsl:variable name="transactionType">
         <xsl:value-of select="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType'])"/>
      </xsl:variable>
      <G_SG11>
         <S_QTY>
            <C_C186>
               <D_6063>
                  <xsl:choose>
                     <xsl:when test="./S_SCC/D_4017 = '3'">99</xsl:when>
                     <xsl:when test="./S_SCC/D_4017 = '4'">99</xsl:when>
                     <xsl:when test="./S_SCC/D_4017 = '1'">113</xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="S_QTY/C_C186/D_6063"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </D_6063>
               <xsl:copy-of select="S_QTY/C_C186/D_6063/following-sibling::*"/>
            </C_C186>
         </S_QTY>
         <xsl:if test="S_SCC">
            <S_SCC>
               <D_4017>
                  <xsl:value-of select="S_SCC/D_4017"/>
               </D_4017>
               <D_4493>
                  <xsl:choose>
                     <xsl:when test="./S_SCC/D_4017 = '3'">P1</xsl:when>
                     <xsl:when test="./S_SCC/D_4017 = '4'">P1</xsl:when>
                     <xsl:when test="./S_SCC/D_4017 = '1'">DD</xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="S_SCC/D_4017"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </D_4493>
               <xsl:variable name="schExtrinsic" select="upper-case(normalize-space(//OrderRequest/ItemOut[$posItem]/ScheduleLine[$posSchedLine]/Extrinsic[@name='deliveryQuoteNo']))"/>
               <xsl:choose>
                  <xsl:when test="$schExtrinsic = 'C'">
                     <C_C329>
                        <D_2013>Y</D_2013>
                     </C_C329>
                  </xsl:when>
                  <xsl:when test="$schExtrinsic = 'M'">
                     <C_C329>
                        <D_2013>M</D_2013>
                     </C_C329>
                  </xsl:when>
                  <xsl:when test="$schExtrinsic = 'T'">
                     <C_C329>
                        <D_2013>T</D_2013>
                     </C_C329>
                  </xsl:when>
                  <xsl:when test="$schExtrinsic = 'W'">
                     <C_C329>
                        <D_2013>W</D_2013>
                     </C_C329>
                  </xsl:when>
                  <xsl:when test="$schExtrinsic = 'Z'">
                     <C_C329>
                        <D_2013>A</D_2013>
                     </C_C329>
                  </xsl:when>
               </xsl:choose>
            </S_SCC>
         </xsl:if>
         <xsl:for-each select="S_DTM">
            <xsl:choose>
               <xsl:when test="C_C507/D_2005 = '2' and $transactionType = 'SH'"/>
               <xsl:when test="C_C507/D_2005 = '10' and $transactionType = 'DL'"/>
               <xsl:otherwise>
                  <xsl:copy-of select="."/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </G_SG11>
   </xsl:template>

   <!-- Requirement 34, 35, 37, 38 -->
   <xsl:template match="//M_DELJIT/G_SG4/G_SG7/S_FTX[D_4451 = 'ZZZ']"> </xsl:template>

   <xsl:template name="formatDate">
      <!-- convert Ariba cXML date to EDI Format -->
      <xsl:param name="DocDate"/>
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
