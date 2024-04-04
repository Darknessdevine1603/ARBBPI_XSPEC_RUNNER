<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact" exclude-result-prefixes="#all">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <!-- For local testing -->
   <!--xsl:variable name="lookups" select="document('LOOKUP_EANCOM_D01BEAN009.xml')"/>
      <xsl:include href="FORMAT_EANCOM_D01BEAN011_CXML_0000.xsl"/-->
   <!-- PD references -->
   <xsl:include href="FORMAT_EANCOM_D01BEAN011_cXML_0000.xsl"/>
   <xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_EANCOM_D01BEAN009.xml')"/>
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="cXMLAttachments"/>
   <xsl:param name="attachSeparator" select="'\|'"/>
   <xsl:param name="anSenderDefaultTimeZone"/>
   <xsl:variable name="headerCurrency" select="/ns0:Interchange/M_ORDRSP/G_SG8/S_CUX/C_C504[D_6347 = '2' and D_6343 = '9']/D_6345"/>
   <xsl:variable name="headerAltCurrency" select="/ns0:Interchange/M_ORDRSP/G_SG8/S_CUX/C_C504[D_6347 = '2' and D_6343 = '9']/D_6345"/>
   <xsl:variable name="deliveryDateDTM" select="/ns0:Interchange/M_ORDRSP/S_DTM[C_C507/D_2005 = '2']"/>
   <xsl:param name="anAllDetailOCFlag"/> <!-- used for allDetail logic -->
   <xsl:template match="ns0:*">
      <xsl:element name="cXML">
         <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
         </xsl:attribute>
         <xsl:attribute name="timestamp">
            <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][Z]')"/>
         </xsl:attribute>
         <Header>
            <From>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anSupplierANID"/>
                  </Identity>
               </Credential>
            </From>
            <To>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anBuyerANID"/>
                  </Identity>
               </Credential>
            </To>
            <Sender>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anProviderANID"/>
                  </Identity>
               </Credential>
               <UserAgent>
                  <xsl:value-of select="'Ariba Supplier'"/>
               </UserAgent>
            </Sender>
         </Header>
         <Request>
            <!--IG-19733 IG-19895 Remove AllDetail logic for variable mapAllDetail-->
           <xsl:choose>
               <xsl:when test="$anEnvName = 'PROD'">
                  <xsl:attribute name="deploymentMode">production</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="deploymentMode">test</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
            <ConfirmationRequest>
               <ConfirmationHeader>
                  <xsl:if test="normalize-space(M_ORDRSP/S_BGM[C_C002/D_1001 = '231']/C_C106/D_1004) != ''">
                     <xsl:attribute name="confirmID">
                        <xsl:value-of select="M_ORDRSP/S_BGM[C_C002/D_1001 = '231']/C_C106/D_1004"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="operation">
                     <xsl:choose>
                        <xsl:when test="normalize-space(M_ORDRSP/S_BGM/C_C106/D_1060) != ''">
                           <xsl:text>update</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>new</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="type">
                     <xsl:choose>
                        <!--IG-19733 IG-19895 Remove AllDetail logic $mapAllDetail='true'-->
                        <xsl:when test="M_ORDRSP/S_BGM/D_1225 = '29'">
                           <xsl:text>accept</xsl:text>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_BGM/D_1225 = '27'">
                           <xsl:text>reject</xsl:text>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_BGM/D_1225 = '4'">
                           <xsl:text>detail</xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:if test="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2380 or M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2380">
                     <xsl:choose>
                        <xsl:when test="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2380 != ''">
                           <xsl:attribute name="noticeDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="dateTime">
                                    <xsl:value-of select="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2380"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="dateTimeFormat">
                                    <xsl:value-of select="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2379"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2380 != ''">
                           <xsl:attribute name="noticeDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="dateTime">
                                    <xsl:value-of select="M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2380"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="dateTimeFormat">
                                    <xsl:value-of select="M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2379"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:if>
                  <xsl:if test="normalize-space(M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154) != ''">
                     <xsl:attribute name="invoiceID">
                        <xsl:value-of select="M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="normalize-space(M_ORDRSP/G_SG12/S_TOD/C_C100/D_4053) != ''">
                     <xsl:attribute name="incoTerms">
                        <xsl:value-of select="lower-case(M_ORDRSP/G_SG12/S_TOD/C_C100/D_4053)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="M_ORDRSP/G_SG26/G_SG41/G_SG44/S_MOA/C_C516[D_5025 = '128'][D_6343 = '9']">
                     <Total>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="MOA" select="M_ORDRSP/G_SG26/G_SG41/G_SG44/S_MOA/C_C516[D_5025 = '128'][D_6343 = '9']"/>
                           <xsl:with-param name="altMOA" select="M_ORDRSP/G_SG26/G_SG41/G_SG44/S_MOA/C_C516[D_5025 = '128'][D_6343 = '11']"/>
                        </xsl:call-template>
                        <xsl:if test="M_ORDRSP/G_SG19/S_ALC">
                           <Modifications>
                              <Modification>
                                 <xsl:if test="normalize-space(M_ORDRSP/G_SG19/S_ALC/C_C552/D_1227) != ''">
                                    <xsl:attribute name="level">
                                       <xsl:value-of select="M_ORDRSP/G_SG19/S_ALC/C_C552/D_1227"/>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:if test="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_5004">
                                    <OriginalPrice>
                                       <xsl:call-template name="createMoney">
                                          <xsl:with-param name="MOA" select="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']"/>
                                       </xsl:call-template>
                                    </OriginalPrice>
                                 </xsl:if>
                                 <xsl:choose>
                                    <xsl:when test="M_ORDRSP/G_SG19/S_ALC[D_5463 = 'A']">
                                       <AdditionalDeduction>
                                          <xsl:choose>
                                             <xsl:when test="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG22/S_MOA/C_C516[D_5025 = '204'][D_6343 = '9']">
                                                <DeductionAmount>
                                                   <xsl:call-template name="createMoney">
                                                      <xsl:with-param name="MOA" select="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG22/S_MOA/C_C516[D_5025 = '204'][D_6343 = '9']"/>
                                                   </xsl:call-template>
                                                </DeductionAmount>
                                             </xsl:when>
                                             <xsl:when test="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG21/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']">
                                                <DeductionPercent>
                                                   <xsl:attribute name="percent">
                                                      <xsl:value-of select="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG21/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']/D_5482"/>
                                                   </xsl:attribute>
                                                </DeductionPercent>
                                             </xsl:when>
                                             <xsl:when test="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG22/S_MOA/C_C516[D_5025 = '296'][D_6343 = '9']">
                                                <DeductedPrice>
                                                   <xsl:call-template name="createMoney">
                                                      <xsl:with-param name="MOA" select="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG22/S_MOA/C_C516[D_5025 = '296'][D_6343 = '9']"/>
                                                   </xsl:call-template>
                                                </DeductedPrice>
                                             </xsl:when>
                                          </xsl:choose>
                                       </AdditionalDeduction>
                                    </xsl:when>
                                    <xsl:when test="M_ORDRSP/G_SG19/S_ALC[D_5463 = 'C']">
                                       <AdditionalCost>
                                          <xsl:call-template name="createMoney">
                                             <xsl:with-param name="MOA" select="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'C']/G_SG22/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23'][D_6343 = '9']"/>
                                          </xsl:call-template>
                                          <xsl:if test="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG21/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']">
                                             <Percentage>
                                                <xsl:attribute name="Percent">
                                                   <xsl:value-of select="M_ORDRSP/G_SG19[S_ALC/D_5463 = 'A']/G_SG21/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']/D_5482"/>
                                                </xsl:attribute>
                                             </Percentage>
                                          </xsl:if>
                                       </AdditionalCost>
                                    </xsl:when>
                                 </xsl:choose>
                                 <ModificationDetail>
                                    <xsl:attribute name="name">
                                       <xsl:choose>
                                          <xsl:when test="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7161 = 'AJ'">Adjustment</xsl:when>
                                          <xsl:when test="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7161 = 'HD'">Handling</xsl:when>
                                          <xsl:when test="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7161 = 'IN'">Insurance</xsl:when>
                                          <xsl:when test="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7161 = 'VAB'">Volume Discount</xsl:when>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:if test="S_DTM/C_C507[D_2005 = '194']">
                                       <xsl:attribute name="startDate">
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="dateTime">
                                                <xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2380"/>
                                             </xsl:with-param>
                                             <xsl:with-param name="dateTimeFormat">
                                                <xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2379"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="S_DTM/C_C507[D_2005 = '206']">
                                       <xsl:attribute name="endDate">
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="dateTime">
                                                <xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
                                             </xsl:with-param>
                                             <xsl:with-param name="dateTimeFormat">
                                                <xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <Description>
                                       <xsl:attribute name="xml:lang">en</xsl:attribute>
                                       <xsl:variable name="Desc">
                                          <xsl:value-of select="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7160"/>
                                       </xsl:variable>
                                       <xsl:variable name="Desc1">
                                          <xsl:value-of select="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7160_2"/>
                                       </xsl:variable>
                                       <xsl:value-of select="concat($Desc, $Desc1)"/>
                                    </Description>
                                 </ModificationDetail>
                              </Modification>
                           </Modifications>
                        </xsl:if>
                     </Total>
                  </xsl:if>
                  <!-- Shipping-->
                  <xsl:variable name="shipping">
                     <xsl:for-each select="M_ORDRSP/S_FTX[D_4451 = 'TRA']">
                        <xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
                     </xsl:for-each>
                  </xsl:variable>
                  <xsl:if test="$shipping != '' and M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']/D_5004 != ''">
                     <Shipping>
                        <xsl:if test="M_ORDRSP/G_SG19/S_ALC[D_5463 = 'C']/C_C552/D_1230">
                           <xsl:attribute name="trackingDomain">
                              <xsl:value-of select="M_ORDRSP/G_SG19/S_ALC[D_5463 = 'C']/C_C552/D_1230"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7161 = 'FC'">
                           <xsl:attribute name="trackingId">
                              <xsl:value-of select="M_ORDRSP/G_SG19/S_ALC/C_C214[D_7161 = 'FC']/D_7160_2"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="MOA" select="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']"/>
                           <xsl:with-param name="altMOA" select="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '11']"/>
                        </xsl:call-template>
                        <Description>
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="M_ORDRSP/S_FTX[D_4451 = 'TRA']/D_4451">
                                    <xsl:value-of select="M_ORDRSP/S_FTX[D_4451 = 'TRA']/D_3453"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text>en</xsl:text>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:value-of select="M_ORDRSP/G_SG19/S_ALC/C_C214[D_7161 = 'FC']/D_7160"/>
                        </Description>
                     </Shipping>
                  </xsl:if>
                  <!-- Tax -->
                  <xsl:variable name="tax">
                     <xsl:for-each select="M_ORDRSP/S_FTX[D_4451 = 'TXD']">
                        <xsl:if test="normalize-space(D_4453) = ''">
                           <xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:variable>
                  <xsl:if test="M_ORDRSP/G_SG26/G_SG41/G_SG44/S_MOA/C_C516[D_5025 = '124' or D_5025 = '176'][D_6343 = '9']">
                     <Tax>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="MOA" select="(M_ORDRSP/G_SG26/G_SG41/G_SG44/S_MOA/C_C516[D_5025 = '124' or D_5025 = '176'][D_6343 = '9'])[1]"/>
                           <xsl:with-param name="altMOA" select="(M_ORDRSP/G_SG26/G_SG41/G_SG44/S_MOA/C_C516[D_5025 = '124' or D_5025 = '176'][D_6343 = '11'])[1]"/>
                        </xsl:call-template>
                        <Description>
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="M_ORDRSP/S_FTX[D_4451 = 'TXD']/D_4451">
                                    <xsl:value-of select="M_ORDRSP/S_FTX[D_4451 = 'TXD'][not(D_4453)]/D_3453"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text>en</xsl:text>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:value-of select="$tax"/>
                        </Description>
                        <TaxDetail>
                           <xsl:if test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_5283) != ''">
                              <xsl:attribute name="purpose">
                                 <xsl:choose>
                                    <xsl:when test="M_ORDRSP/G_SG7/S_TAX/D_5283 = '5'">
                                       <xsl:text>duty</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="M_ORDRSP/G_SG7/S_TAX/D_5283 = '7'">
                                       <xsl:text>tax</xsl:text>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:attribute name="category">
                              <xsl:variable name="category" select="M_ORDRSP/G_SG7/S_TAX/C_C241/D_5153"/>
                              <xsl:variable name="categoryvalue">
                                 <xsl:value-of select="$lookups/Lookups/TaxCodes/TaxCode[EANCOMCode = $category]/CXMLCode"/>
                              </xsl:variable>
                              <xsl:choose>
                                 <xsl:when test="$categoryvalue != ''">
                                    <xsl:value-of select="$categoryvalue"/>
                                 </xsl:when>
                                 <xsl:otherwise>other</xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:if test="normalize-space(M_ORDRSP/G_SG7/S_TAX/C_C243/D_5278) != ''">
                              <xsl:attribute name="percentageRate">
                                 <xsl:value-of select="normalize-space(M_ORDRSP/G_SG7/S_TAX/C_C243/D_5278)"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_5305) != ''">
                              <xsl:attribute name="exemptDetail">
                                 <xsl:choose>
                                    <xsl:when test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_5305) = 'Z'">
                                       <xsl:text>zeroRated</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_5305) = 'E'">
                                       <xsl:text>exempt</xsl:text>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="normalize-space(M_ORDRSP/G_SG7/S_TAX/C_C243/D_5279) != ''">
                              <xsl:attribute name="taxRateType">
                                 <xsl:value-of select="normalize-space(M_ORDRSP/G_SG7/S_TAX/C_C243/D_5279)"/>
                              </xsl:attribute>
                           </xsl:if>
                           <TaxAmount>
                              <xsl:call-template name="createMoney">
                                 <xsl:with-param name="MOA" select="M_ORDRSP/G_SG7/S_MOA/C_C516[D_5025 = '124']"/>
                              </xsl:call-template>
                           </TaxAmount>
                           <xsl:if test="normalize-space(M_ORDRSP/G_SG7/S_TAX/C_C241/D_5153) != ''">
                              <TaxLocation>
                                 <xsl:attribute name="xml:lang">en</xsl:attribute>
                                 <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/C_C241/D_5152"/>
                              </TaxLocation>
                           </xsl:if>
                           <xsl:if test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_3446) != ''">
                              <Description>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:text>en</xsl:text>
                                 </xsl:attribute>
                                 <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/D_3446"/>
                              </Description>
                           </xsl:if>
                           <xsl:if test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_5305) != ''">
                              <xsl:choose>
                                 <xsl:when test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_5305) = 'S'">
                                    <Extrinsic>
                                       <xsl:attribute name="name">exemptType</xsl:attribute>Standard</Extrinsic>
                                 </xsl:when>
                                 <xsl:when test="normalize-space(M_ORDRSP/G_SG7/S_TAX/D_5305) = 'A'">
                                    <Extrinsic>
                                       <xsl:attribute name="name">exemptType</xsl:attribute>Mixed</Extrinsic>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:if>
                        </TaxDetail>
                     </Tax>
                  </xsl:if>
                  <!-- Contact-->
                  <xsl:for-each select="M_ORDRSP/G_SG3">
                     <xsl:apply-templates select=".">
                        <xsl:with-param name="role" select="S_NAD/D_3035"/>
                        <xsl:with-param name="cMode" select="'partners'"/>
                     </xsl:apply-templates>
                  </xsl:for-each>
                  <!--- Comments-->
                  <xsl:variable name="comment">
                     <xsl:for-each select="M_ORDRSP/S_FTX[D_4451 = 'AAI']">
                        <xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
                     </xsl:for-each>
                  </xsl:variable>
                  <xsl:if test="$comment != ''">
                     <Comments>
                        <xsl:value-of select="$comment"/>
                     </Comments>
                  </xsl:if>
                  <xsl:if test="normalize-space(M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154) != ''">
                     <IdReference>
                        <xsl:attribute name="domain">CustomerReferenceID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154"/>
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if test="normalize-space(M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154) != ''">
                     <IdReference>
                        <xsl:attribute name="domain">UltimateCustomerReferenceID</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154"/>
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:if test="M_ORDRSP/S_BGM/D_1225 = '27'">
                     <xsl:if test="M_ORDRSP/S_FTX[D_4451 = 'ACD']/C_C108/D_4440 != ''">
                        <xsl:variable name="rejreason" select="M_ORDRSP/S_FTX[D_4451 = 'ACD']/C_C108/D_4440"/>
                        <xsl:variable name="rejcomment" select="M_ORDRSP/S_FTX[D_4451 = 'AAO']/C_C108/D_4440"/>
                        <xsl:element name="Extrinsic">
                           <xsl:attribute name="name">
                              <xsl:value-of select="'RejectionReasonComments'"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="$rejcomment!=''">
                                 <xsl:value-of select="$rejcomment"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>other</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                        <xsl:element name="Extrinsic">
                           <xsl:attribute name="name">
                              <xsl:value-of select="'RejectionReason'"/>
                           </xsl:attribute>
                           <xsl:choose>
                              <xsl:when test="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EANCOMCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode != ''">
                                 <xsl:value-of select="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EANCOMCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>other</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:if>
                  </xsl:if>
               </ConfirmationHeader>
               <OrderReference>
                  <xsl:attribute name="orderID">
                     <xsl:choose>
                        <xsl:when test="M_ORDRSP/G_SG1/S_RFF/C_C506/D_1153 = 'ON'">
                           <xsl:value-of select="M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/G_SG1/S_RFF/C_C506/D_1153 = 'PP'">
                           <xsl:value-of select="M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'PP']/D_1154"/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:if test="M_ORDRSP/G_SG1/S_DTM[C_C507/D_2005 = '171']">
                     <xsl:attribute name="orderDate">
                        <xsl:call-template name="convertToAribaDatePORef">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="M_ORDRSP/G_SG1/S_DTM[C_C507/D_2005 = '171']/C_C507/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat">
                              <xsl:value-of select="M_ORDRSP/G_SG1/S_DTM[C_C507/D_2005 = '171']/C_C507/D_2379"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <DocumentReference>
                     <xsl:attribute name="payloadID"/>
                  </DocumentReference>
               </OrderReference>
               <!-- Line Level Mapping -->
               <!--IG-19733 IG-19895 Remove all detail logic $mapAllDetail='true'-->
               <xsl:if test="M_ORDRSP/S_BGM/D_1225 != '27'">
                  <xsl:for-each select="M_ORDRSP/G_SG26">
                     <xsl:variable name="lineNr">
                        <xsl:choose>
                           <xsl:when test="normalize-space(G_SG31/S_RFF/C_C506[D_1153 = 'ON']/D_1156) != ''">
                              <xsl:value-of select="normalize-space(G_SG31/S_RFF/C_C506[D_1153 = 'ON']/D_1156)"/>
                           </xsl:when>
                           <xsl:when test="normalize-space(G_SG31/S_RFF/C_C506[D_1153 = 'PP']/D_1156) != ''">
                              <xsl:value-of select="normalize-space(G_SG31/S_RFF/C_C506[D_1153 = 'PP']/D_1156)"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="S_LIN/D_1082"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <ConfirmationItem>
                        <xsl:attribute name="quantity">
                           <xsl:value-of select="S_QTY/C_C186[D_6063 = '21']/D_6060"/>
                        </xsl:attribute>
                        <xsl:attribute name="lineNumber">
                           <xsl:value-of select="$lineNr"/>
                        </xsl:attribute>
                        <xsl:if test="S_LIN/C_C829[D_5495 = '1']/D_1082">
                           <xsl:attribute name="parentLineNumber">
                              <xsl:value-of select="S_LIN/C_C829[D_5495 = '1']/D_1082"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="G_SG31/S_RFF/C_C506[D_1153 = 'FI']/D_1154">
                           <xsl:attribute name="itemType">
                              <xsl:value-of select="G_SG31/S_RFF/C_C506[D_1153 = 'FI']/D_1154"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="mapUnitOfMeasure">
                           <xsl:with-param name="uomCode" select="normalize-space(S_QTY/C_C186[D_6063 = '21']/D_6411)"/>
                        </xsl:call-template>
                        <xsl:for-each select="G_SG37">
                           <xsl:apply-templates select=".">
                              <xsl:with-param name="role" select="S_NAD/D_3035"/>
                           </xsl:apply-templates>
                        </xsl:for-each>
                        <xsl:variable name="confTypeLIN">
                           <xsl:choose>
                              <!--IG-19733 IG-19895 Remove all detail logic $mapAllDetail='true'-->
                              <xsl:when test="S_LIN/D_1229 = '6'">
                                 <xsl:text>detail</xsl:text>
                              </xsl:when>
                              <xsl:when test="S_LIN/D_1229 = '5'">
                                 <xsl:text>accept</xsl:text>
                              </xsl:when>
                              <xsl:when test="S_LIN/D_1229 = '7'">
                                 <xsl:text>reject</xsl:text>
                              </xsl:when>
                              <xsl:when test="S_LIN/D_1229 = '3'">
                                 <xsl:text>detail</xsl:text>
                              </xsl:when>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="ackQty" select="sum(S_QTY/C_C186[D_6063 = '113' or D_6063 = '185' or D_6063 = '83']/D_6060)"/>
                        <xsl:variable name="unkQty">
                           <xsl:choose>
                              <xsl:when test="$ackQty=0">
                                 <xsl:text>0</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="S_QTY/C_C186[D_6063 = '21']/D_6060 - $ackQty"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:for-each select="S_QTY[C_C186/D_6063 != '21']">
                           <xsl:variable name="confUOM">
                              <xsl:choose>
                                 <xsl:when test="C_C186[D_6063 = '113']/D_6411 != ''">
                                    <xsl:value-of select="C_C186[D_6063 = '113']/D_6411"/>
                                 </xsl:when>
                                 <xsl:when test="C_C186[D_6063 = '185']/D_6411 != ''">
                                    <xsl:value-of select="C_C186[D_6063 = '185']/D_6411"/>
                                 </xsl:when>
                                 <xsl:when test="C_C186[D_6063 = '83']/D_6411 != ''">
                                    <xsl:value-of select="S_QTY/C_C186[D_6063 = '83']/D_6411"/>
                                 </xsl:when>
                                 <xsl:when test="../S_QTY/C_C186[D_6063 = '21']/D_6411 != ''">
                                    <xsl:value-of select="../S_QTY/C_C186[D_6063 = '21']/D_6411"/>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:variable name="confType">
                              <xsl:choose>
                                 <!--IG-19733 IG-19895 Remove all detail logic $mapAllDetail='true'-->
                                  <xsl:when test="C_C186[D_6063 = '113']/D_6411 != '' and ../G_SG30/S_PRI/C_C509[D_5125 = 'AAA'][D_5387='AAE' or D_5387='AAK']/D_5118">
                                    <xsl:text>detail</xsl:text>
                                 </xsl:when>
                                 <xsl:when test="C_C186[D_6063 = '113']/D_6411 != '' ">
                                    <xsl:text>accept</xsl:text>
                                 </xsl:when>
                                 <xsl:when test="C_C186[D_6063 = '185']/D_6411 != '' ">
                                    <xsl:text>reject</xsl:text>
                                 </xsl:when>
                                 <xsl:when test="C_C186[D_6063 = '83']/D_6411 != '' ">
                                    <xsl:text>backordered</xsl:text>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:variable name="confQty">
                              <xsl:choose>
                                 <xsl:when test="C_C186[D_6063 = '113']/D_6060 != ''">
                                    <xsl:value-of select="C_C186[D_6063 = '113']/D_6060"/>
                                 </xsl:when>
                                 <xsl:when test="C_C186[D_6063 = '185']/D_6060 != ''">
                                    <xsl:value-of select="C_C186[D_6063 = '185']/D_6060"/>
                                 </xsl:when>
                                 <xsl:when test="C_C186[D_6063 = '83']/D_6060 != ''">
                                    <xsl:value-of select="C_C186[D_6063 = '83']/D_6060"/>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:call-template name="createConfirmationStatus">
                              <xsl:with-param name="confirmationType" select="$confType"/>
                              <xsl:with-param name="confirmationQty" select="$confQty"/>
                              <xsl:with-param name="confirmationUOM" select="$confUOM"/>
                              <!--IG-19733 IG-19895 Remove param name alldetail logic-->
                              <xsl:with-param name="confStatusDetails" select="../."/>
                           </xsl:call-template>
                        </xsl:for-each>
                        <xsl:if test="S_QTY/C_C186[D_6063 = '21']/D_6411 != '' and not(exists(S_QTY/C_C186[D_6063 = '113' or D_6063 = '185' or D_6063 = '83']))">
                           <xsl:call-template name="createConfirmationStatus">
                              <xsl:with-param name="confirmationType" select="$confTypeLIN"/>
                              <xsl:with-param name="confirmationQty" select="S_QTY/C_C186[D_6063 = '21']/D_6060"/>
                              <xsl:with-param name="confirmationUOM" select="S_QTY/C_C186[D_6063 = '21']/D_6411"/>
                              <!--IG-19733 IG-19895 Remove all detail logic-->
                            <xsl:with-param name="confStatusDetails" select="."/>
                           </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="$unkQty &gt; 0">
                           <xsl:element name="ConfirmationStatus">
                              <xsl:attribute name="type">unknown</xsl:attribute>
                              <xsl:attribute name="quantity">
                                 <xsl:value-of select="$unkQty"/>
                              </xsl:attribute>
                              <xsl:element name="UnitOfMeasure">
                                 <xsl:value-of select="S_QTY/C_C186[D_6063 = '21']/D_6411"/>
                              </xsl:element>
                           </xsl:element>
                        </xsl:if>
                     </ConfirmationItem>
                  </xsl:for-each>
               </xsl:if>
            </ConfirmationRequest>
         </Request>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createConfirmationStatus">
      <xsl:param name="confirmationType"/>
      <xsl:param name="confirmationQty"/>
      <xsl:param name="confirmationUOM"/>
      <xsl:param name="confStatusDetails"/>
    <!--  IG-19733 IG-19895 Remove all detail logic-->
     
      <ConfirmationStatus>
         <xsl:attribute name="quantity">
            <xsl:value-of select="$confirmationQty"/>
         </xsl:attribute>
         <xsl:attribute name="type">
            <xsl:value-of select="$confirmationType"/>
         </xsl:attribute>
         <!--IG-19733 IG-19895 Remove all detail logic $mapAllDetail='true' and $$confirmationType = 'alldetail'-->
         <xsl:if test="($confirmationType = 'detail' or $confirmationType = 'accept' or $confirmationType = 'backordered')">
            <xsl:if test="$confStatusDetails/S_DTM/C_C507[D_2005 = '11']">
               <xsl:attribute name="shipmentDate">
                  <xsl:call-template name="convertToAribaDate">
                     <xsl:with-param name="dateTime">
                        <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '11']/D_2380"/>
                     </xsl:with-param>
                     <xsl:with-param name="dateTimeFormat">
                        <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '11']/D_2379"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:attribute>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="$confStatusDetails/S_DTM/C_C507[D_2005 = '2']">
                  <xsl:attribute name="deliveryDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="dateTime">
                           <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '2']/D_2380"/>
                        </xsl:with-param>
                        <xsl:with-param name="dateTimeFormat">
                           <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '2']/D_2379"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="$confStatusDetails/S_DTM/C_C507[D_2005 = '69']">
                  <xsl:attribute name="deliveryDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="dateTime">
                           <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '69']/D_2380"/>
                        </xsl:with-param>
                        <xsl:with-param name="dateTimeFormat">
                           <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '69']/D_2379"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="$confStatusDetails/S_DTM/C_C507[D_2005 = '506']">
                  <xsl:attribute name="deliveryDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="dateTime">
                           <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '506']/D_2380"/>
                        </xsl:with-param>
                        <xsl:with-param name="dateTimeFormat">
                           <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '506']/D_2379"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="$deliveryDateDTM">
                  <xsl:attribute name="deliveryDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="dateTime">
                           <xsl:value-of select="$deliveryDateDTM/C_C507/D_2380"/>
                        </xsl:with-param>
                        <xsl:with-param name="dateTimeFormat">
                           <xsl:value-of select="$deliveryDateDTM/C_C507/D_2379"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:attribute>
               </xsl:when>
            </xsl:choose>
         </xsl:if>
         <xsl:call-template name="mapUnitOfMeasure">
            <xsl:with-param name="uomCode" select="normalize-space($confirmationUOM)"/>
         </xsl:call-template>
         <xsl:choose>
            <!--IG-19733 IG-19895 Removed AllDetail Logic $mapAllDetail='true' and $$confirmationType = 'alldetail' -->
            <xsl:when test="($confirmationType = 'detail'  and $confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA'][D_5387 = 'AAE']/D_5118) or $confirmationType = 'backordered'">
               <ItemIn>
                  <xsl:attribute name="quantity">
                     <xsl:value-of select="$confirmationQty"/>
                  </xsl:attribute>
                  <!-- SupplierPartID -->
                  <xsl:element name="ItemID">
                     <xsl:element name="SupplierPartID">
                        <xsl:value-of select="$confStatusDetails/S_PIA[D_4347 = '5']//.[D_7143 = 'SA']/D_7140"/>
                     </xsl:element>
                     <!-- BuyerPartID -->
                     <xsl:if test="$confStatusDetails/S_PIA[D_4347 = '5']//.[D_7143 = 'IN']/D_7140 != ''">
                        <xsl:element name="BuyerPartID">
                           <xsl:choose>
                              <xsl:when test="$confStatusDetails/S_PIA[D_4347 = '5']//.[D_7143 = 'IN']/D_7140">
                                 <xsl:value-of select="$confStatusDetails/S_PIA[D_4347 = '5']//.[D_7143 = 'IN']/D_7140"/>
                              </xsl:when>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
                  <ItemDetail>
                     <xsl:if test="$confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA']/D_5118">
                        <xsl:call-template name="mapUnitPrice">
                           <xsl:with-param name="confDetails" select="$confStatusDetails"/>
                        </xsl:call-template>
                     </xsl:if>
                     <Description>
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when test="$confStatusDetails/S_IMD[D_7077 = 'F']/C_C273/D_3453">
                                 <xsl:value-of select="$confStatusDetails/S_IMD[D_7077 = 'F']/C_C273/D_3453"/>
                              </xsl:when>
                              <xsl:when test="$confStatusDetails/S_IMD[D_7077 = 'E']/C_C273/D_3453">
                                 <xsl:value-of select="$confStatusDetails/S_IMD[D_7077 = 'E']/C_C273/D_3453"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>en</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:if test="$confStatusDetails/S_IMD[D_7077 = 'E']/C_C273/D_7008_1 or S_IMD[D_7077 = 'E']/C_C273/D_7008_2">
                           <ShortName>
                              <xsl:value-of select="concat($confStatusDetails/S_IMD[D_7077 = 'E']/C_C273/D_7008, ' ', $confStatusDetails/S_IMD[D_7077 = 'E']/C_C273/D_7008_2)"/>
                           </ShortName>
                        </xsl:if>
                        <xsl:value-of select="concat($confStatusDetails/S_IMD[D_7077 = 'F']/C_C273/D_7008, ' ', $confStatusDetails/S_IMD[D_7077 = 'F']/C_C273/D_7008_2)"/>
                     </Description>
                     <xsl:call-template name="mapUnitOfMeasure">
                        <xsl:with-param name="uomCode" select="normalize-space($confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA']/D_6411)"/>
                     </xsl:call-template>
                     <xsl:if test="normalize-space($confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA']/D_5284) != ''">
                        <PriceBasisQuantity>
                           <xsl:attribute name="quantity">
                              <xsl:value-of select="$confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA']/D_5284"/>
                           </xsl:attribute>
                           <xsl:attribute name="conversionFactor">1</xsl:attribute>
                           <xsl:call-template name="mapUnitOfMeasure">
                              <xsl:with-param name="uomCode" select="normalize-space($confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA']/D_6411)"/>
                           </xsl:call-template>
                        </PriceBasisQuantity>
                     </xsl:if>
                     <!-- Classification-->
                     <xsl:choose>
                        <xsl:when test="$confStatusDetails/S_PIA[D_4347 = '1']//.[D_7143 = 'GD']/D_7140 != ''">
                           <xsl:element name="Classification">
                              <xsl:attribute name="domain">
                                 <xsl:text>UNSPSC</xsl:text>
                              </xsl:attribute>
                              <xsl:attribute name="code">
                                 <xsl:value-of select="$confStatusDetails/S_PIA[D_4347 = '1']//.[D_7143 = 'GD']/D_7140"/>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:element name="Classification">
                              <xsl:attribute name="domain" select="''"/>
                              <xsl:attribute name="code"/>
                           </xsl:element>
                        </xsl:otherwise>
                     </xsl:choose>
                     
                     
                     <!--IG-27644 -->
                     <xsl:if test="$confStatusDetails/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']/D_7008_2!=''">                        
                        <xsl:element name="Classification">
                           <xsl:choose>
                              <xsl:when test="$confStatusDetails/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']/D_7008!=''">
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="$confStatusDetails/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']/D_7008"/>
                                 </xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:attribute name="domain" select="'NotAvailable'"/>
                              </xsl:otherwise>
                           </xsl:choose>
                           
                           <xsl:attribute name="code">
                              <xsl:value-of select="$confStatusDetails/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']/D_7008_2"/>
                           </xsl:attribute>
                        </xsl:element>
                     </xsl:if>
                     <!-- ManufacturerPartID -->
                     <xsl:if test="$confStatusDetails/S_PIA[D_4347 = '5']//.[D_7143 = 'MF']/D_7140 != ''">
                        <xsl:element name="ManufacturerPartID">
                           <xsl:value-of select="$confStatusDetails/S_PIA[D_4347 = '5']//.[D_7143 = 'MF']/D_7140"/>
                        </xsl:element>
                     </xsl:if>
                     <xsl:for-each select="$confStatusDetails/S_MEA[D_6311 = 'PD']">
                        <Dimension>
                           <xsl:attribute name="quantity">
                              <xsl:value-of select="C_C174/D_6314"/>
                           </xsl:attribute>
                           <xsl:attribute name="type">
                              <xsl:variable name="dtype" select="C_C502/D_6313"/>
                              <xsl:variable name="dtypevalue">
                                 <xsl:value-of select="$lookups/Lookups/Dimensions/Dimension[EANCOMCode = $dtype]/CXMLCode"/>
                              </xsl:variable>
                              <xsl:value-of select="$dtypevalue"/>
                           </xsl:attribute>
                           <xsl:call-template name="mapUnitOfMeasure">
                              <xsl:with-param name="uomCode" select="normalize-space(C_C174/D_6411)"/>
                           </xsl:call-template>
                        </Dimension>
                     </xsl:for-each>
                     <ItemDetailIndustry>
                        <ItemDetailRetail>
                           <xsl:if test="normalize-space($confStatusDetails/S_LIN/C_C212/D_7140) != ''">
                              <EANID>
                                 <xsl:value-of select="$confStatusDetails/S_LIN/C_C212/D_7140"/>
                              </EANID>
                           </xsl:if>
                           <!-- EuropeanWasteCatalogID -->
                           <xsl:if test="$confStatusDetails/S_PIA[D_4347 = '1']//.[D_7143 = 'EWC']/D_7140 != ''">
                              <xsl:element name="EuropeanWasteCatalogID">
                                 <xsl:value-of select="$confStatusDetails/S_PIA[D_4347 = '1']//.[D_7143 = 'EWC']/D_7140"/>
                              </xsl:element>
                           </xsl:if>
                           <xsl:variable name="iccode">
                              <xsl:value-of select="$confStatusDetails/S_IMD[D_7077 = 'B']/C_C272/D_7081"/>
                           </xsl:variable>
                           <xsl:variable name="iccodevalue">
                              <xsl:value-of select="$lookups/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[EANCOMCode = $iccode]/CXMLCode"/>
                           </xsl:variable>
                           <xsl:if test="$confStatusDetails/S_IMD[D_7077 = 'B']/C_C273/D_7008!='' and $iccodevalue!=''">
                              <Characteristic>
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="$iccodevalue"></xsl:value-of>
                                 </xsl:attribute>
                                 <xsl:attribute name="value">
                                    <xsl:value-of select="$confStatusDetails/S_IMD[D_7077 = 'B']/C_C273/D_7008"/>
                                 </xsl:attribute>
                              </Characteristic>
                           </xsl:if>
                        </ItemDetailRetail>
                     </ItemDetailIndustry>
                  </ItemDetail>
                  <xsl:if test="$confStatusDetails/G_SG41[S_ALC[D_5463 = 'C']/C_C214/D_7161 = 'FC']/G_SG44/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']">
                     <xsl:call-template name="mapShipping">
                        <xsl:with-param name="confDetails" select="$confStatusDetails"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="$confStatusDetails/G_SG36/S_MOA/C_C516[D_5025 = '124']">
                     <xsl:call-template name="mapTax">
                        <xsl:with-param name="confDetails" select="$confStatusDetails"/>
                     </xsl:call-template>
                  </xsl:if>
               </ItemIn>
            </xsl:when>
            <xsl:otherwise>
               <xsl:if test="$confirmationType != 'accept' and $confirmationType != 'reject' and $confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA'][D_5387='AAK']/D_5118">
                  <xsl:call-template name="mapUnitPrice">
                     <xsl:with-param name="confDetails" select="$confStatusDetails"/>
                  </xsl:call-template>
               </xsl:if>
               <xsl:if test="$confStatusDetails/G_SG36/S_MOA/C_C516[D_5025 = '124']">
                  <xsl:call-template name="mapTax">
                     <xsl:with-param name="confDetails" select="$confStatusDetails"/>
                  </xsl:call-template>
               </xsl:if>
               <xsl:if test="$confStatusDetails/G_SG41[S_ALC[D_5463 = 'C']/C_C214/D_7161 = 'FC']/G_SG44/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']">
                  <xsl:call-template name="mapShipping">
                     <xsl:with-param name="confDetails" select="$confStatusDetails"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:if test="$confStatusDetails/S_FTX[D_4451 = 'AAI']">
            <Comments>
               <xsl:attribute name="xml:lang">
                  <xsl:choose>
                     <xsl:when test="$confStatusDetails/S_FTX[D_4451 = 'AAI']/D_3453 != ''">
                        <xsl:value-of select="$confStatusDetails/S_FTX[D_4451 = 'AAI']/D_3453"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>en</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:for-each select="$confStatusDetails/S_FTX[D_4451 = 'AAI']">
                  <xsl:value-of select="C_C108/D_4440"/>
                  <xsl:text> </xsl:text>
                  <xsl:if test="C_C108/D_4440_2 != ''">
                     <xsl:value-of select="C_C108/D_4440_2"/>
                     <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:if test="C_C108/D_4440_3 != ''">
                     <xsl:value-of select="C_C108/D_4440_3"/>
                     <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:if test="C_C108/D_4440_4 != ''">
                     <xsl:value-of select="C_C108/D_4440_4"/>
                     <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:if test="C_C108/D_4440_5 != ''">
                     <xsl:value-of select="C_C108/D_4440_5"/>
                  </xsl:if>
               </xsl:for-each>
            </Comments>
         </xsl:if>
         <xsl:if test="normalize-space($confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAE']/D_5118) != ''">
            <Extrinsic name="informationPrice">
               <xsl:value-of select="$confStatusDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAE']/D_5118"/>
            </Extrinsic>
         </xsl:if>
         <xsl:if test="$confStatusDetails/S_DTM/C_C507[D_2005 = '200']">
            <Extrinsic name="pickUpCollectionDate">
               <xsl:call-template name="convertToAribaDate">
                  <xsl:with-param name="dateTime">
                     <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '10']/D_2380"/>
                  </xsl:with-param>
                  <xsl:with-param name="dateTimeFormat">
                     <xsl:value-of select="$confStatusDetails/S_DTM/C_C507[D_2005 = '10']/D_2379"/>
                  </xsl:with-param>
               </xsl:call-template>
            </Extrinsic>
         </xsl:if>
         <xsl:if test="$confStatusDetails/S_QTY/C_C186[D_6063 = '192']">
            <Extrinsic name="freeGoodsQuantity">
               <xsl:value-of select="$confStatusDetails/S_QTY/C_C186[D_6063 = '192']/D_6060"/>
            </Extrinsic>
            <xsl:if test="normalize-space($confStatusDetails/S_QTY/C_C186[D_6063 = '192']/D_6411) != ''">
               <Extrinsic name="freeGoodsQuantityUOM">
                  <xsl:variable name="uome">
                     <xsl:value-of select="$confStatusDetails/S_QTY/C_C186[D_6063 = '192']/D_6411"/>
                  </xsl:variable>
                  <xsl:variable name="uomevalue">
                     <xsl:value-of select="$lookups/Lookups/UnitOfMeasures/UnitOfMeasure[EANCOMCode = $uome]/CXMLCode"/>
                  </xsl:variable>
                  <xsl:choose>
                     <xsl:when test="$uomevalue != ''">
                        <xsl:value-of select="$uomevalue"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$confStatusDetails/S_QTY/C_C186[D_6063 = '192']/D_6411"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </Extrinsic>
            </xsl:if>
         </xsl:if>
         <xsl:if test="$confirmationType = 'reject'">
            <xsl:if test="$confStatusDetails/S_FTX[D_4451 = 'ACD']/C_C108/D_4440 != ''">
               <xsl:variable name="rejreason" select="$confStatusDetails/S_FTX[D_4451 = 'ACD']/C_C108/D_4440"/>
               <xsl:variable name="rejcomment" select="$confStatusDetails/S_FTX[D_4451 = 'AAO']/C_C108/D_4440"/>
               <xsl:element name="Extrinsic">
                  <xsl:attribute name="name">
                     <xsl:value-of select="'RejectionReasonComments'"/>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="$rejcomment!=''">
                        <xsl:value-of select="$rejcomment"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>other</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:element>
               <xsl:element name="Extrinsic">
                  <xsl:attribute name="name">
                     <xsl:value-of select="'RejectionReason'"/>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EANCOMCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode != ''">
                        <xsl:value-of select="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EANCOMCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>other</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:element>
            </xsl:if>
         </xsl:if>
      </ConfirmationStatus>
   </xsl:template>
   <xsl:template name="mapUnitPrice">
      <xsl:param name="confDetails" required="yes"></xsl:param>
      <UnitPrice>
         <xsl:element name="Money">
            <xsl:attribute name="currency">
               <xsl:choose>
                  <xsl:when test="$confDetails/G_SG30/S_CUX/C_C504/D_6345">
                     <xsl:value-of select="$confDetails/G_SG30/S_CUX/C_C504/D_6345"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$headerCurrency"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="$confDetails/G_SG30/S_PRI/C_C509[D_5125 = 'AAA']/D_5118"/>
         </xsl:element>
         <xsl:if test="$confDetails/G_SG41/S_ALC">
            <Modifications>
               <Modification>
                  <xsl:if test="normalize-space($confDetails/G_SG41/S_ALC/C_C552/D_1227) != ''">
                     <xsl:attribute name="level">
                        <xsl:value-of select="$confDetails/G_SG41/S_ALC/C_C552/D_1227"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$confDetails/G_SG41/G_SG22/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_5004">
                     <OriginalPrice>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="MOA" select="$confDetails/G_SG41/G_SG22/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']"/>
                        </xsl:call-template>
                     </OriginalPrice>
                  </xsl:if>
                  <xsl:choose>
                     <xsl:when test="$confDetails/G_SG41/S_ALC[D_5463 = 'A']">
                        <AdditionalDeduction>
                           <xsl:choose>
                              <xsl:when test="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG44/S_MOA/C_C516[D_5025 = '204'][D_6343 = '9']">
                                 <DeductionAmount>
                                    <xsl:call-template name="createMoney">
                                       <xsl:with-param name="MOA" select="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG44/S_MOA/C_C516[D_5025 = '204'][D_6343 = '9']"/>
                                    </xsl:call-template>
                                 </DeductionAmount>
                              </xsl:when>
                              <xsl:when test="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG43/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']">
                                 <DeductionPercent>
                                    <xsl:attribute name="percent">
                                       <xsl:value-of select="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG43/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']/D_5482"/>
                                    </xsl:attribute>
                                 </DeductionPercent>
                              </xsl:when>
                              <xsl:when test="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG44/S_MOA/C_C516[D_5025 = '296'][D_6343 = '9']">
                                 <DeductedPrice>
                                    <xsl:call-template name="createMoney">
                                       <xsl:with-param name="MOA" select="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG44/S_MOA/C_C516[D_5025 = '296'][D_6343 = '9']"/>
                                    </xsl:call-template>
                                 </DeductedPrice>
                              </xsl:when>
                           </xsl:choose>
                        </AdditionalDeduction>
                     </xsl:when>
                     <xsl:when test="$confDetails/G_SG41/S_ALC[D_5463 = 'C']">
                        <AdditionalCost>
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="MOA" select="$confDetails/G_SG41[S_ALC/D_5463 = 'C']/G_SG22/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23'][D_6343 = '9']"/>
                           </xsl:call-template>
                           <xsl:if test="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG21/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']">
                              <Percentage>
                                 <xsl:attribute name="percent">
                                    <xsl:value-of select="$confDetails/G_SG41[S_ALC/D_5463 = 'A']/G_SG43/S_PCD/C_C501[D_5245 = '1' or D_5245 = '2' or D_5245 = '3'][D_5249 = '13']/D_5482"/>
                                 </xsl:attribute>
                              </Percentage>
                           </xsl:if>
                        </AdditionalCost>
                     </xsl:when>
                  </xsl:choose>
                  <ModificationDetail>
                     <xsl:attribute name="name">
                        <xsl:choose>
                           <xsl:when test="$confDetails/G_SG41/S_ALC/C_C214/D_7161 = 'AJ'">Adjustment</xsl:when>
                           <xsl:when test="$confDetails/G_SG41/S_ALC/C_C214/D_7161 = 'HD'">Handling</xsl:when>
                           <xsl:when test="$confDetails/G_SG41/S_ALC/C_C214/D_7161 = 'IN'">Insurance</xsl:when>
                           <xsl:when test="$confDetails/G_SG41/S_ALC/C_C214/D_7161 = 'VAB'">Volume Discount</xsl:when>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:if test="$confDetails/G_SG41/S_DTM/C_C507[D_2005 = '194']">
                        <xsl:attribute name="startDate">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="dateTime">
                                 <xsl:value-of select="$confDetails/G_SG41/S_DTM/C_C507[D_2005 = '194']/D_2380"/>
                              </xsl:with-param>
                              <xsl:with-param name="dateTimeFormat">
                                 <xsl:value-of select="$confDetails/G_SG41/S_DTM/C_C507[D_2005 = '194']/D_2379"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:if test="$confDetails/G_SG41/S_DTM/C_C507[D_2005 = '206']">
                        <xsl:attribute name="endDate">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="dateTime">
                                 <xsl:value-of select="$confDetails/G_SG41/S_DTM/C_C507[D_2005 = '206']/D_2380"/>
                              </xsl:with-param>
                              <xsl:with-param name="dateTimeFormat">
                                 <xsl:value-of select="$confDetails/G_SG41/S_DTM/C_C507[D_2005 = '206']/D_2379"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:if>
                     <Description>
                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                        <xsl:variable name="Desc">
                           <xsl:value-of select="$confDetails/G_SG41/S_ALC/C_C214/D_7160"/>
                        </xsl:variable>
                        <xsl:variable name="Desc1">
                           <xsl:value-of select="$confDetails/G_SG41/S_ALC/C_C214/D_7160_2"/>
                        </xsl:variable>
                        <xsl:value-of select="concat($Desc, $Desc1)"/>
                     </Description>
                  </ModificationDetail>
               </Modification>
            </Modifications>
         </xsl:if>
      </UnitPrice>
   </xsl:template>
   <xsl:template name="mapShipping">
      <xsl:param name="confDetails" required="yes"></xsl:param>
      <Shipping>
         <xsl:if test="($confDetails/G_SG41/S_ALC[D_5463 = 'C']/C_C552/D_1230)[1]">
            <xsl:attribute name="trackingDomain">
               <xsl:value-of select="($confDetails/G_SG41/S_ALC[D_5463 = 'C']/C_C552/D_1230)[1]"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="$confDetails/G_SG41/S_ALC[D_5463 = 'C']/C_C214[D_7161 = 'FC']/D_7160_2">
            <xsl:attribute name="trackingId">
               <xsl:value-of select="$confDetails/G_SG41/S_ALC[D_5463 = 'C']/C_C214[D_7161 = 'FC']/D_7160_2"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:call-template name="createMoney">
            <xsl:with-param name="MOA" select="$confDetails/G_SG41[S_ALC/C_C214/D_7161 = 'FC']/G_SG44/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']"/>
            <xsl:with-param name="altMOA" select="$confDetails/G_SG41[S_ALC/C_C214/D_7161 = 'FC']/G_SG44/S_MOA/C_C516[D_5025 = '23'][D_6343 = '11']"/>
         </xsl:call-template>
         <xsl:if test="$confDetails/G_SG41/S_ALC[D_5463 = 'C']/C_C214[D_7161 = 'FC']/D_7160">
            <Description>
               <xsl:attribute name="xml:lang">en</xsl:attribute>
               <xsl:value-of select="$confDetails/G_SG41/S_ALC[D_5463 = 'C']/C_C214[D_7161 = 'FC']/D_7160"/>
            </Description>
         </xsl:if>
      </Shipping>
   </xsl:template>
   <xsl:template name="mapTax">
      <xsl:param name="confDetails" required="yes"></xsl:param>
      <xsl:variable name="tax">
         <xsl:for-each select="$confDetails/S_FTX[D_4451 = 'TXD']">
            <xsl:if test="normalize-space(D_4453) = ''">
               <xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <Tax>
         <xsl:call-template name="createMoney">
            <xsl:with-param name="MOA" select="$confDetails/G_SG36/S_MOA/C_C516[D_5025 = '124']"/>
         </xsl:call-template>
         <Description>
            <xsl:attribute name="xml:lang">
               <xsl:choose>
                  <xsl:when test="$confDetails/S_FTX[D_4451 = 'TXD']/D_4451">
                     <xsl:value-of select="$confDetails/S_FTX[D_4451 = 'TXD'][not(D_4453)]/D_3453"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>en</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="$tax"/>
         </Description>
         <TaxDetail>
            <xsl:if test="normalize-space($confDetails/G_SG36/S_TAX/D_5283) != ''">
               <xsl:attribute name="purpose">
                  <xsl:choose>
                     <xsl:when test="$confDetails/G_SG36/S_TAX/D_5283 = '5'">
                        <xsl:text>duty</xsl:text>
                     </xsl:when>
                     <xsl:when test="$confDetails/G_SG36/S_TAX/D_5283 = '7'">
                        <xsl:text>tax</xsl:text>
                     </xsl:when>
                  </xsl:choose>
               </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="category">
               <xsl:variable name="category" select="$confDetails/G_SG36/S_TAX/C_C241/D_5153"/>
               <xsl:variable name="categoryvalue">
                  <xsl:value-of select="$lookups/Lookups/TaxCodes/TaxCode[EANCOMCode = $category]/CXMLCode"/>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="$categoryvalue != ''">
                     <xsl:value-of select="$categoryvalue"/>
                  </xsl:when>
                  <xsl:otherwise>other</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:if test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5278) != ''">
               <xsl:attribute name="percentageRate">
                  <xsl:value-of select="G_SG36/S_TAX/C_C243/D_5278"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:if test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5305) != ''">
               <xsl:attribute name="exemptDetail">
                  <xsl:choose>
                     <xsl:when test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5305) = 'Z'">
                        <xsl:text>zeroRated</xsl:text>
                     </xsl:when>
                     <xsl:when test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5305) = 'E'">
                        <xsl:text>exempt</xsl:text>
                     </xsl:when>
                  </xsl:choose>
               </xsl:attribute>
            </xsl:if>
            <xsl:if test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5279) != ''">
               <xsl:attribute name="taxRateType">
                  <xsl:value-of select="$confDetails/G_SG36/S_TAX/C_C243/D_5279"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:if test="$confDetails/G_SG36/S_MOA/C_C516/D_6345">
               <TaxableAmount>
                  <xsl:call-template name="createMoneyAlt">
                     <xsl:with-param name="value" select="$confDetails/G_SG36/S_TAX/C_C533/D_5286"/>
                     <xsl:with-param name="altvalue" select="$confDetails/G_SG36/S_TAX/C_C243/D_5279"/>
                     <xsl:with-param name="cur" select="$confDetails/G_SG36/S_MOA/C_C516/D_6345"/>
                  </xsl:call-template>
               </TaxableAmount>
            </xsl:if>
            <TaxAmount>
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="MOA" select="$confDetails/G_SG36/S_MOA/C_C516[D_5025 = '124']"/>
               </xsl:call-template>
            </TaxAmount>
            <xsl:if test="normalize-space($confDetails/G_SG36/S_TAX/C_C241/D_5153) != ''">
               <TaxLocation>
                  <xsl:attribute name="xml:lang">
                     <xsl:text>en</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="$confDetails/G_SG36/S_TAX/C_C241/D_5152"/>
               </TaxLocation>
            </xsl:if>
            <xsl:if test="normalize-space($confDetails/G_SG36/S_TAX/D_3446) != ''">
               <Description>
                  <xsl:attribute name="xml:lang">
                     <xsl:text>en</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="$confDetails/G_SG36/S_TAX/D_3446"/>
               </Description>
            </xsl:if>
            <xsl:if test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5305) != ''">
               <xsl:choose>
                  <xsl:when test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5305) = 'S'">
                     <Extrinsic>
                        <xsl:attribute name="name">exemptType</xsl:attribute>Standard</Extrinsic>
                  </xsl:when>
                  <xsl:when test="normalize-space($confDetails/G_SG36/S_TAX/C_C243/D_5305) = 'A'">
                     <Extrinsic>
                        <xsl:attribute name="name">exemptType</xsl:attribute>Mixed</Extrinsic>
                  </xsl:when>
               </xsl:choose>
            </xsl:if>
         </TaxDetail>
      </Tax>
   </xsl:template>
</xsl:stylesheet>
