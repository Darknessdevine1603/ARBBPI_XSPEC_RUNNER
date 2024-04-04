<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:ordrsp:d.96a" exclude-result-prefixes="#all">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <!--		Description: map "xSLT_EDIFACT_cXML_ORDRSP.xsl" to transform EDIFACT 96A ORDRSP to cXML OrderConfirmation.		Date: 12/18/2015		Created: Ramachandra Motati.		Version: 1.0	-->
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="cXMLAttachments"/>
   <xsl:param name="attachSeparator" select="'\|'"/>
   <xsl:param name="anAllDetailOCFlag"/>
   <!-- used for allDetail logic -->
   <xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>
   <!--<xsl:variable name="lookups" select="document('LOOKUP_UN-EDIFACT_D96A.xml')"/>-->
   <xsl:template match="*">
      <xsl:element name="cXML">
         <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
         </xsl:attribute>
         <xsl:attribute name="timestamp">
            <xsl:value-of
               select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][Z]')"
            />
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
             <!--IG-19729 IG-19901 Removed allDetail logic for variable mapAllDetail-->
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
                  <xsl:if
                     test="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2380 or M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2380">
                     <xsl:choose>
                        <xsl:when test="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2380 != ''">
                           <xsl:attribute name="noticeDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="dateTime">
                                    <xsl:value-of
                                       select="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2380"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="dateTimeFormat">
                                    <xsl:value-of
                                       select="M_ORDRSP/S_DTM/C_C507[D_2005 = '8']/D_2379"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2380 != ''">
                           <xsl:attribute name="noticeDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="dateTime">
                                    <xsl:value-of
                                       select="M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2380"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="dateTimeFormat">
                                    <xsl:value-of
                                       select="M_ORDRSP/S_DTM/C_C507[D_2005 = '137']/D_2379"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:if>
                  <xsl:attribute name="type">
                     <xsl:choose>
                        <!--IG-19729 IG-19901 Removed allDetail logic-->
                       <xsl:when test="M_ORDRSP/S_BGM/D_4343 = 'AP'">
                           <xsl:text>accept</xsl:text>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_BGM/D_4343 = 'AI'">
                           <xsl:text>except</xsl:text>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_BGM/D_4343 = 'AC'">
                           <xsl:text>detail</xsl:text>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_BGM/D_4343 = 'RE'">
                           <xsl:text>reject</xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="operation">
                     <xsl:choose>
                        <xsl:when test="M_ORDRSP/S_BGM/D_1225 = '5'">
                           <xsl:text>update</xsl:text>
                        </xsl:when>
                        <xsl:when test="M_ORDRSP/S_BGM/D_1225 = '9'">
                           <xsl:text>new</xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="confirmID">
                     <xsl:value-of select="M_ORDRSP/S_BGM[C_C002/D_1001 = '231']/D_1004"/>
                  </xsl:attribute>
                  <xsl:if test="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'SRN']/D_1154">
                     <xsl:attribute name="incoTerms">
                        <xsl:variable name="IncoVal"
                           select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'SRN']/D_1154"/>
                        <xsl:value-of select="lower-case($IncoVal)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'ACW']/D_1154">
                     <DocumentReference>
                        <xsl:attribute name="payloadID">
                           <xsl:choose>
                              <xsl:when
                                 test="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'ACW']/D_1154 != ''">
                                 <xsl:value-of
                                    select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'ACW']/D_1154"
                                 />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of
                                    select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'ACW']/D_4000"
                                 />
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                     </DocumentReference>
                  </xsl:if>
                  <xsl:if test="M_ORDRSP/S_MOA/C_C516[D_5025 = '128']/D_6345">
                     <Total>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of select="M_ORDRSP/S_MOA/C_C516[D_5025 = '128']/D_6345"/>
                           </xsl:attribute>
                           <xsl:value-of select="M_ORDRSP/S_MOA/C_C516[D_5025 = '128']/D_5004"/>
                        </Money>
                     </Total>
                  </xsl:if>
                  <xsl:if
                     test="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']/D_5004">
                     <Shipping>
                        <xsl:if test="M_ORDRSP/G_SG19/S_ALC[D_5463 = 'C']/C_C552/D_1230">
                           <xsl:attribute name="trackingDomain">
                              <xsl:value-of
                                 select="M_ORDRSP/G_SG19/S_ALC[D_5463 = 'C']/C_C552/D_1230"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7161 = 'SAA'">
                           <xsl:attribute name="trackingId">
                              <xsl:value-of
                                 select="M_ORDRSP/G_SG19/S_ALC/C_C214[D_7161 = 'SAA']/D_7160_2"/>
                           </xsl:attribute>
                        </xsl:if>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of
                                 select="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']/D_6345"
                              />
                           </xsl:attribute>
                           <xsl:if
                              test="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '7']/D_5004">
                              <xsl:attribute name="alternateAmount">
                                 <xsl:value-of
                                    select="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '7']/D_5004"
                                 />
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if
                              test="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '7']/D_6345">
                              <xsl:attribute name="alternateCurrency">
                                 <xsl:value-of
                                    select="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '7']/D_6345"
                                 />
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:value-of
                              select="M_ORDRSP/G_SG19/G_SG22/S_MOA/C_C516[D_5025 = '23'][D_6343 = '9']/D_5004"
                           />
                        </Money>
                        <Description>
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="M_ORDRSP/S_FTX[D_4451 = 'TRA']/D_4451">
                                    <xsl:value-of
                                       select="distinct-values(M_ORDRSP/S_FTX[D_4451 = 'TRA']/D_3453)"
                                    />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text>en</xsl:text>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:if
                              test="M_ORDRSP/G_SG19/S_ALC[C_C214/D_7161 = 'SAA']/C_C214/D_7160_1">
                              <ShortName>
                                 <xsl:value-of
                                    select="M_ORDRSP/G_SG19/S_ALC[C_C214/D_7161 = 'SAA']/C_C214/D_7160_1"
                                 />
                              </ShortName>
                           </xsl:if>
                           <xsl:for-each select="M_ORDRSP/S_FTX[D_4451 = 'TRA']">
                              <xsl:value-of select="C_C108/D_4440_1"/>
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
                        </Description>
                        <xsl:if test="M_ORDRSP/G_SG19[S_ALC/C_C214/D_7161 != 'SAA']">
                           <Modifications>
                              <xsl:for-each select="M_ORDRSP/G_SG19[S_ALC/C_C214/D_7161 != 'SAA']">
                                 <xsl:if
                                    test="G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004 or G_SG22/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482 or G_SG22/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_5004">
                                    <Modification>
                                       <xsl:if
                                          test="G_SG22/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_5004">
                                          <OriginalPrice>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_6345"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_5004"
                                                />
                                             </Money>
                                          </OriginalPrice>
                                       </xsl:if>
                                       <xsl:choose>
                                          <xsl:when test="S_ALC/D_5463 = 'A'">
                                             <AdditionalDeduction>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004">
                                                  <DeductionAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </DeductionAmount>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="G_SG22/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482">
                                                  <DeductionPercent>
                                                  <xsl:attribute name="percent">
                                                  <xsl:value-of
                                                  select="G_SG22/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482"
                                                  />
                                                  </xsl:attribute>
                                                  </DeductionPercent>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="G_SG22/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_5004">
                                                  <DeductedPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </DeductedPrice>
                                                  </xsl:when>
                                                </xsl:choose>
                                             </AdditionalDeduction>
                                          </xsl:when>
                                          <xsl:when test="S_ALC/D_5463 = 'C'">
                                             <AdditionalCost>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004"
                                                  />
                                                </Money>
                                             </AdditionalCost>
                                          </xsl:when>
                                       </xsl:choose>
                                       <ModificationDetail>
                                          <xsl:attribute name="name">
                                             <xsl:value-of
                                                select="M_ORDRSP/G_SG19/S_ALC/C_C214/D_7161"/>
                                          </xsl:attribute>
                                          <xsl:if test="S_DTM/C_C507[D_2005 = '194']">
                                             <xsl:attribute name="startDate">
                                                <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '194']/D_2380"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '194']/D_2379"/>
                                                  </xsl:with-param>
                                                </xsl:call-template>
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:if test="S_DTM/C_C507[D_2005 = '206']">
                                             <xsl:attribute name="endDate">
                                                <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
                                                  </xsl:with-param>
                                                </xsl:call-template>
                                             </xsl:attribute>
                                          </xsl:if>
                                          <Description>
                                             <xsl:value-of
                                                select="concat(substring(S_ALC/C_C214/D_7160_1, 0, 35), substring(M_ORDRSP/G_SG19/S_ALC/C_C214/D_7160_2, 0, 35))"
                                             />
                                          </Description>
                                       </ModificationDetail>
                                    </Modification>
                                 </xsl:if>
                              </xsl:for-each>
                           </Modifications>
                        </xsl:if>
                     </Shipping>
                  </xsl:if>
                  <xsl:if test="M_ORDRSP/S_MOA/C_C516[D_5025 = '124']/D_5004">
                     <Tax>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of select="M_ORDRSP/S_MOA/C_C516[D_5025 = '124']/D_6345"/>
                           </xsl:attribute>
                           <xsl:value-of select="M_ORDRSP/S_MOA/C_C516[D_5025 = '124']/D_5004"/>
                        </Money>
                        <xsl:if test="M_ORDRSP/S_FTX[D_4451 = 'TXD']">
                           <Description>
                              <xsl:attribute name="xml:lang">
                                 <xsl:choose>
                                    <xsl:when test="M_ORDRSP/S_FTX[D_4451 = 'TXD']/D_3453">
                                       <xsl:value-of
                                          select="(M_ORDRSP/S_FTX[D_4451 = 'TXD']/D_3453)[1]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:text>en</xsl:text>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:for-each select="M_ORDRSP/S_FTX[D_4451 = 'TXD']">
                                 <xsl:value-of select="C_C108/D_4440_1"/>
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
                              <xsl:if test="M_ORDRSP/G_SG7/S_TAX/D_3446 != ''">
                                 <ShortName>
                                    <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/D_3446"/>
                                 </ShortName>
                              </xsl:if>
                           </Description>
                        </xsl:if>
                        <xsl:if test="M_ORDRSP/G_SG7/S_TAX">
                           <TaxDetail>
                              <xsl:attribute name="purpose">
                                 <xsl:choose>
                                    <xsl:when test="M_ORDRSP/G_SG7/S_TAX/D_5283 = '5'">
                                       <xsl:text>duty</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:text>tax</xsl:text>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:attribute name="category">
                                 <xsl:variable name="category"
                                    select="M_ORDRSP/G_SG7/S_TAX/C_C241/D_5153"/>
                                 <xsl:value-of
                                    select="$lookups/Lookups/TaxCodes/TaxCode[EDIFACTCode = $category]/CXMLCode"
                                 />
                              </xsl:attribute>
                              <xsl:attribute name="percentageRate">
                                 <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/C_C243/D_5278"/>
                              </xsl:attribute>
                              <xsl:attribute name="isVatRecoverable">
                                 <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/C_C533/D_5289"/>
                              </xsl:attribute>
                              <xsl:if test="M_ORDRSP/G_SG7/S_DTM/C_C507[D_2005 = '131']/D_2380">
                                 <xsl:attribute name="taxPointDate">
                                    <xsl:call-template name="convertToAribaDate">
                                       <xsl:with-param name="dateTime">
                                          <xsl:value-of
                                             select="M_ORDRSP/G_SG7/S_DTM/C_C507[D_2005 = '131']/D_2380"
                                          />
                                       </xsl:with-param>
                                       <xsl:with-param name="dateTimeFormat">
                                          <xsl:value-of
                                             select="M_ORDRSP/G_SG7/S_DTM/C_C507[D_2005 = '131']/D_2379"
                                          />
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:if test="M_ORDRSP/G_SG7/S_DTM/C_C507[D_2005 = '140']/D_2380">
                                 <xsl:attribute name="paymentDate">
                                    <xsl:call-template name="convertToAribaDate">
                                       <xsl:with-param name="dateTime">
                                          <xsl:value-of
                                             select="M_ORDRSP/G_SG7/S_DTM/C_C507[D_2005 = '140']/D_2380"
                                          />
                                       </xsl:with-param>
                                       <xsl:with-param name="dateTimeFormat">
                                          <xsl:value-of
                                             select="M_ORDRSP/G_SG7/S_DTM/C_C507[D_2005 = '140']/D_2379"
                                          />
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:if test="M_ORDRSP/G_SG7/S_TAX/C_C243/D_5279">
                                 <xsl:attribute name="isTriangularTransaction">
                                    <xsl:choose>
                                       <xsl:when
                                          test="upper-case(M_ORDRSP/G_SG7/S_TAX/C_C243/D_5279) = 'IT'">
                                          <xsl:text>yes</xsl:text>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:text>no</xsl:text>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:if test="M_ORDRSP/G_SG7/S_TAX/C_C243/D_5305">
                                 <xsl:attribute name="exemptDetail">
                                    <xsl:choose>
                                       <xsl:when
                                          test="upper-case(M_ORDRSP/G_SG7/S_TAX/C_C243/D_5305) = 'Z'">
                                          <xsl:text>zeroRated</xsl:text>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:text>exempt</xsl:text>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                              </xsl:if>
                              <TaxableAmount>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="M_ORDRSP/G_SG7/S_MOA/C_C516/D_6345"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="alternateAmount">
                                       <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/C_C243/D_5279"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/C_C533/D_5286"/>
                                 </Money>
                              </TaxableAmount>
                              <TaxAmount>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of
                                          select="M_ORDRSP/G_SG7/S_MOA/C_C516[D_5025 = '124']/D_6345"
                                       />
                                    </xsl:attribute>
                                    <xsl:value-of
                                       select="M_ORDRSP/G_SG7/S_MOA/C_C516[D_5025 = '124']/D_5004"/>
                                 </Money>
                              </TaxAmount>
                              <xsl:if test="M_ORDRSP/G_SG7/S_TAX/C_C241/D_5152">
                                 <TaxLocation xml:lang="'en'">
                                    <xsl:value-of select="M_ORDRSP/G_SG7/S_TAX/C_C241/D_5152"/>
                                 </TaxLocation>
                              </xsl:if>
                           </TaxDetail>
                        </xsl:if>
                     </Tax>
                  </xsl:if>
                  <xsl:for-each select="M_ORDRSP/G_SG3/S_NAD">
                     <xsl:variable name="role" select="D_3035"/>
                     <xsl:if test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of
                                 select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"
                              />
                           </xsl:attribute>
                           <xsl:attribute name="addressID">
                              <xsl:value-of select="C_C082/D_3039"/>
                           </xsl:attribute>
                           <xsl:attribute name="addressIDDomain">
                              <xsl:value-of select="C_C082/D_3055"/>
                           </xsl:attribute>
                           <xsl:call-template name="CreateContact">
                              <xsl:with-param name="contactPath" select="."/>
                           </xsl:call-template>
                           <xsl:call-template name="PhoneFaxEmailLoop">
                              <xsl:with-param name="contactInfo" select="../G_SG6"/>
                              <xsl:with-param name="countrycode" select="D_3207"/>
                           </xsl:call-template>
                        </Contact>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="M_ORDRSP/S_FTX[upper-case(D_4451) = 'AAI']">
                     <Comments>
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when test="M_ORDRSP/S_FTX[upper-case(D_4451) = 'AAI']/D_3453">
                                 <xsl:value-of
                                    select="distinct-values(M_ORDRSP/S_FTX[upper-case(D_4451) = 'AAI']/D_3453)"
                                 />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>en</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:for-each select="M_ORDRSP/S_FTX[upper-case(D_4451) = 'AAI']">
                           <xsl:value-of select="C_C108/D_4440_1"/>
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
                     </Comments>
                  </xsl:if>
                  <!-- IG-12806 -->
                  <xsl:if test="M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'AEU']">
                     <IdReference>
                        <xsl:attribute name="domain">supplierReference</xsl:attribute>
                        <xsl:attribute name="identifier">
                           <xsl:value-of select="M_ORDRSP/G_SG1/S_RFF/C_C506[D_1153 = 'AEU']/D_1154"
                           />
                        </xsl:attribute>
                     </IdReference>
                  </xsl:if>
                  <xsl:for-each
                     select="M_ORDRSP/S_FTX[upper-case(D_4451) = 'ZZZ' and lower-case(C_C108/D_4440_1) != 'alldetail']">
                     <Extrinsic>
                        <xsl:attribute name="name">
                           <xsl:value-of select="C_C108/D_4440_1"/>
                        </xsl:attribute>
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
                     </Extrinsic>
                  </xsl:for-each>
                  <xsl:if
                     test="(M_ORDRSP/S_BGM/D_4343 = 'RE') and M_ORDRSP/S_FTX[upper-case(D_4451) = 'ACD']/C_C108/D_4440_1 != ''">
                     <xsl:variable name="rejreason"
                        select="M_ORDRSP/S_FTX[upper-case(D_4451) = 'ACD']/C_C108/D_4440_1"/>
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:value-of select="'RejectionReasonComments'"/>
                        </xsl:attribute>
                        <xsl:value-of select="$rejreason"/>
                     </xsl:element>
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:value-of select="'RejectionReason'"/>
                        </xsl:attribute>
                        <xsl:choose>
                           <xsl:when
                              test="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EDIFACTCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode != ''">
                              <xsl:value-of
                                 select="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EDIFACTCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode"
                              />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>other</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:element>
                  </xsl:if>
               </ConfirmationHeader>
               <OrderReference>
                  <xsl:if test="M_ORDRSP/G_SG1/S_DTM[C_C507/D_2005 = '4']">
                     <xsl:attribute name="orderDate">
                        <xsl:call-template name="convertToAribaDatePORef">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of
                                 select="M_ORDRSP/G_SG1/S_DTM[C_C507/D_2005 = '4']/C_C507/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat">
                              <xsl:value-of
                                 select="M_ORDRSP/G_SG1/S_DTM[C_C507/D_2005 = '4']/C_C507/D_2379"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                     <xsl:when test="M_ORDRSP/G_SG1/S_RFF/C_C506/upper-case(D_1153) = 'ON'">
                        <xsl:attribute name="orderID">
                           <xsl:value-of
                              select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'ON']/D_1154"
                           />
                        </xsl:attribute>
                     </xsl:when>
                     <xsl:when test="M_ORDRSP/G_SG1/S_RFF/C_C506/upper-case(D_1153) = 'VN'">
                        <xsl:attribute name="confirmID">
                           <xsl:value-of
                              select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'VN']/D_1154"
                           />
                        </xsl:attribute>
                     </xsl:when>
                     <xsl:when test="M_ORDRSP/G_SG1/S_RFF/C_C506/upper-case(D_1153) = 'IV'">
                        <xsl:attribute name="invoiceID">
                           <xsl:value-of
                              select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'IV']/D_1154"
                           />
                        </xsl:attribute>
                     </xsl:when>
                  </xsl:choose>
                  <DocumentReference>
                     <xsl:attribute name="payloadID">
                        <xsl:choose>
                           <xsl:when
                              test="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'IL']/D_1154 != ''">
                              <xsl:value-of
                                 select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'IL']/D_1154"
                              />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of
                                 select="M_ORDRSP/G_SG1/S_RFF/C_C506[upper-case(D_1153) = 'IL']/D_4000"
                              />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </DocumentReference>
               </OrderReference>
               <!-- Line Level Mapping -->
               <!--IG-19729 IG-19901 Remove allDetail logic $mapAllDetail = 'true'-->
               <xsl:if test="M_ORDRSP/S_BGM/D_4343 != 'RE'">
                  <xsl:for-each select="M_ORDRSP/G_SG26">
                     <xsl:variable name="lineNr" select="S_LIN/D_1082"/>
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
                        <xsl:if test="G_SG31/S_RFF/C_C506[D_1153 = 'FI']/D_4000">
                           <xsl:attribute name="compositeItemType">
                              <xsl:value-of select="G_SG31/S_RFF/C_C506[D_1153 = 'FI']/D_4000"/>
                           </xsl:attribute>
                        </xsl:if>
                        <UnitOfMeasure>
                           <xsl:value-of select="S_QTY[C_C186/D_6063 = '21']/C_C186/D_6411"/>
                        </UnitOfMeasure>
                        <xsl:for-each select="G_SG37/S_NAD">
                           <xsl:variable name="role" select="D_3035"/>
                           <xsl:if
                              test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
                              <Contact>
                                 <xsl:attribute name="role">
                                    <xsl:value-of
                                       select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"
                                    />
                                 </xsl:attribute>
                                 <xsl:attribute name="addressID">
                                    <xsl:value-of select="C_C082/D_3039"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="C_C082/D_3055"/>
                                 </xsl:attribute>
                                 <xsl:call-template name="CreateContact">
                                    <xsl:with-param name="contactPath" select="."/>
                                 </xsl:call-template>
                                 <xsl:call-template name="PhoneFaxEmailLoop">
                                    <xsl:with-param name="contactInfo" select="../G_SG40"/>
                                    <xsl:with-param name="countrycode" select="../D_3207"/>
                                 </xsl:call-template>
                              </Contact>
                           </xsl:if>
                        </xsl:for-each>
                        <xsl:variable name="ackQty" select="sum(G_SG51/G_SG52/S_QTY/C_C186/D_6060)"/>
                        <xsl:variable name="unkQty"
                           select="S_QTY/C_C186[D_6063 = '21']/D_6060 - $ackQty"/>
                        <xsl:for-each select="G_SG51/G_SG52">
                           <ConfirmationStatus>
                              <xsl:variable name="itemConfStatus">
                                 <xsl:choose>
                                    <!--IG-19729 IG-19901 Remove allDetail logic-->
                                  <xsl:when
                                       test="S_QTY/C_C186/D_6063 = '194' and ../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'CUP' or D_5387 = 'AAK']/D_5118">
                                       <xsl:text>detail</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="S_QTY/C_C186/D_6063 = '194'">
                                       <xsl:text>accept</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="S_QTY/C_C186/D_6063 = '185'">
                                       <xsl:text>reject</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="S_QTY/C_C186/D_6063 = '83'">
                                       <xsl:text>backordered</xsl:text>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:variable>
                              <xsl:attribute name="type">
                                 <xsl:value-of select="$itemConfStatus"/>
                              </xsl:attribute>
                              <xsl:attribute name="quantity">
                                 <xsl:choose>
                                    <!-- <xsl:when test="C_C186/D_6063='21'">												<xsl:value-of select="C_C186[D_6063='21']/D_6060"/>											</xsl:when>											-->
                                    <xsl:when test="S_QTY/C_C186/D_6063 = '194'">
                                       <xsl:value-of select="S_QTY/C_C186[D_6063 = '194']/D_6060"/>
                                    </xsl:when>
                                    <xsl:when test="S_QTY/C_C186/D_6063 = '185'">
                                       <xsl:value-of select="S_QTY/C_C186[D_6063 = '185']/D_6060"/>
                                    </xsl:when>
                                    <xsl:when test="S_QTY/C_C186/D_6063 = '83'">
                                       <xsl:value-of select="S_QTY/C_C186[D_6063 = '83']/D_6060"/>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:if test="S_DTM/C_C507/D_2005 = '69'">
                                 <xsl:attribute name="deliveryDate">
                                    <xsl:call-template name="convertToAribaDate">
                                       <xsl:with-param name="dateTime">
                                          <xsl:value-of select="S_DTM/C_C507[D_2005 = '69']/D_2380"
                                          />
                                       </xsl:with-param>
                                       <xsl:with-param name="dateTimeFormat">
                                          <xsl:value-of select="S_DTM/C_C507[D_2005 = '69']/D_2379"
                                          />
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:if test="S_DTM/C_C507/D_2005 = '10'">
                                 <xsl:attribute name="shipmentDate">
                                    <xsl:call-template name="convertToAribaDate">
                                       <xsl:with-param name="dateTime">
                                          <xsl:value-of select="S_DTM/C_C507[D_2005 = '10']/D_2380"
                                          />
                                       </xsl:with-param>
                                       <xsl:with-param name="dateTimeFormat">
                                          <xsl:value-of select="S_DTM/C_C507[D_2005 = '10']/D_2379"
                                          />
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:attribute>
                              </xsl:if>
                              <UnitOfMeasure>
                                 <xsl:value-of select="(S_QTY/C_C186/D_6411)[1]"/>
                              </UnitOfMeasure>
                              <!-- ItemIn -->
                              <xsl:choose>
                                <!-- Removed the logic $mapAllDetail = 'true' IG-19729 IG-19901-->
                                 <xsl:when
                                    test="($itemConfStatus = 'detail' and ../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'CUP']/D_5118 != '') or ($itemConfStatus = 'backordered' and ../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL']/D_5118 != '')">
                                    <ItemIn>
                                       <xsl:attribute name="quantity">
                                          <xsl:choose>
                                             <xsl:when test="S_QTY/C_C186/D_6063 = '194'">
                                                <xsl:value-of
                                                  select="S_QTY/C_C186[D_6063 = '194']/D_6060"/>
                                             </xsl:when>
                                             <xsl:when test="S_QTY/C_C186/D_6063 = '185'">
                                                <xsl:value-of
                                                  select="S_QTY/C_C186[D_6063 = '185']/D_6060"/>
                                             </xsl:when>
                                             <xsl:when test="S_QTY/C_C186/D_6063 = '83'">
                                                <xsl:value-of
                                                  select="S_QTY/C_C186[D_6063 = '83']/D_6060"/>
                                             </xsl:when>
                                          </xsl:choose>
                                       </xsl:attribute>
                                       <ItemID>
                                          <SupplierPartID>
                                             <xsl:value-of
                                                select="../../S_LIN/C_C212[upper-case(D_7143) = 'VN']/D_7140"
                                             />
                                          </SupplierPartID>
                                          <xsl:if
                                             test="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'VS']/D_7140 != ''">
                                             <SupplierPartAuxiliaryID>
                                                <xsl:value-of
                                                  select="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'VS']/D_7140"
                                                />
                                             </SupplierPartAuxiliaryID>
                                          </xsl:if>
                                          <xsl:if
                                             test="../../S_PIA[D_4347 = '5']//.[upper-case(D_7143) = 'BP']/D_7140 != ''">
                                             <BuyerPartID>
                                                <xsl:value-of
                                                  select="../../S_PIA[D_4347 = '5']//.[upper-case(D_7143) = 'BP']/D_7140"
                                                />
                                             </BuyerPartID>
                                          </xsl:if>
                                       </ItemID>
                                       <ItemDetail>
                                          <xsl:choose>
                                             <xsl:when
                                                test="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'CUP']/D_5118">
                                                <UnitPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_CUX/C_C504_1[D_6347 = '5'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'CUP']/D_5118"
                                                  />
                                                  </Money>
                                                </UnitPrice>
                                             </xsl:when>
                                             <xsl:when
                                                test="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'AAK']/D_5118">
                                                <UnitPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_CUX/C_C504_1[D_6347 = '5'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'AAK']/D_5118"
                                                  />
                                                  </Money>
                                                </UnitPrice>
                                             </xsl:when>
                                             <xsl:when
                                                test="../../S_MOA/C_C516[D_5025 = '146']/D_6345">
                                                <UnitPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../S_MOA/C_C516[D_5025 = '146']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="../../S_MOA/C_C516[D_5025 = '146']/D_5004"
                                                  />
                                                  </Money>
                                                </UnitPrice>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <UnitPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="//S_CUX/C_C504_1/D_6345"/>
                                                  </xsl:attribute>
                                                  </Money>
                                                </UnitPrice>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                          <Description>
                                             <xsl:variable name="LongDescp">
                                                <xsl:for-each select="../../S_IMD[D_7077 = 'F']">
                                                  <xsl:value-of
                                                  select="concat(C_C273/D_7008_1, C_C273/D_7008_2, ' ')"
                                                  />
                                                </xsl:for-each>
                                             </xsl:variable>
                                             <xsl:variable name="ShortDescp">
                                                <xsl:for-each select="../../S_IMD[D_7077 = 'E']">
                                                  <xsl:value-of select="C_C273/D_7009"/>
                                                </xsl:for-each>
                                             </xsl:variable>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="../../S_IMD[D_7077 = 'E']/C_C273/D_3453">
                                                  <xsl:value-of
                                                  select="(../../S_IMD[D_7077 = 'E']/C_C273/D_3453)[1]"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="../../S_IMD[D_7077 = 'F']/C_C273/D_3453">
                                                  <xsl:value-of
                                                  select="(../../S_IMD[D_7077 = 'F']/C_C273/D_3453)[1]"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>en</xsl:text>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                             </xsl:attribute>
                                             <xsl:if test="normalize-space($ShortDescp) != ''">
                                                <ShortName>
                                                  <xsl:value-of select="$ShortDescp"/>
                                                </ShortName>
                                             </xsl:if>
                                             <xsl:value-of select="$LongDescp"/>
                                          </Description>
                                          <UnitOfMeasure>
                                             <xsl:choose>
                                                <xsl:when
                                                  test="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL']/D_6411">
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL']/D_6411"
                                                  />
                                                </xsl:when>
                                                <xsl:when test="S_QTY/C_C186/D_6411">
                                                  <xsl:value-of select="(S_QTY/C_C186/D_6411)[1]"/>
                                                </xsl:when>
                                             </xsl:choose>
                                          </UnitOfMeasure>
                                          <xsl:if
                                             test="normalize-space(../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL']/D_5284) != ''">
                                             <PriceBasisQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL']/D_5284"
                                                  />
                                                </xsl:attribute>
                                                <xsl:attribute name="conversionFactor"
                                                  >1</xsl:attribute>
                                                <xsl:if
                                                  test="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL']/D_6411">
                                                  <UnitOfMeasure>
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL']/D_6411"
                                                  />
                                                  </UnitOfMeasure>
                                                </xsl:if>
                                             </PriceBasisQuantity>
                                          </xsl:if>
                                       	<xsl:choose>
                                       		<xsl:when test="exists(../../G_SG27)">
                                       			<xsl:for-each select="../../G_SG27">
                                       				<Classification>                                                
                                       					<xsl:attribute name="domain">
                                       						<xsl:choose>
                                       							<xsl:when
                                       								test="S_CCI/C_C240/D_7036_1">
                                       								<xsl:value-of
                                       									select="S_CCI/C_C240/D_7036_1"/>
                                       							</xsl:when>
                                       							<xsl:otherwise>
                                       								<xsl:text>NotAvailable</xsl:text>
                                       							</xsl:otherwise>
                                       						</xsl:choose>
                                       					</xsl:attribute>
                                       					<xsl:value-of select="S_CCI/C_C240/D_7037"
                                       					/>
                                       				</Classification>
                                       			</xsl:for-each>
                                       		</xsl:when>
                                       		<xsl:otherwise>
                                       			<Classification>                                                
                                       				<xsl:attribute name="domain">
                                       					<xsl:text>NotAvailable</xsl:text>
                                       				</xsl:attribute>
                                       			</Classification>
                                       		</xsl:otherwise>
                                       	</xsl:choose>
                                          <xsl:if
                                             test="../../S_PIA[D_4347 = '5']//.[upper-case(D_7143) = 'MF']/D_7140 != ''">
                                             <ManufacturerPartID>
                                                <xsl:value-of
                                                  select="../../S_PIA[D_4347 = '5']//.[upper-case(D_7143) = 'MF']/D_7140"
                                                />
                                             </ManufacturerPartID>
                                          </xsl:if>
                                          <xsl:if
                                             test="../../G_SG37/S_NAD[D_3035 = 'MF']/C_C080/D_3036_1 != ''">
                                             <ManufacturerName>
                                                <xsl:value-of
                                                  select="concat(../../G_SG37/S_NAD[D_3035 = 'MF']/C_C080/D_3036_1, ../../G_SG37/S_NAD[D_3035 = 'MF']/C_C080/D_3036_2, ../../G_SG37/S_NAD[D_3035 = 'MF']/C_C080/D_3036_3, ../../G_SG37/S_NAD[D_3035 = 'MF']/C_C080/D_3036_4, ../../G_SG37/S_NAD[D_3035 = 'MF']/C_C080/D_3036_5)"
                                                />
                                             </ManufacturerName>
                                          </xsl:if>
                                          <xsl:if
                                             test="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'EN']/D_7140 != ''">
                                             <ItemDetailIndustry>
                                                <ItemDetailRetail>
                                                  <xsl:if
                                                  test="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'EN']/D_7140 != ''">
                                                  <EANID>
                                                  <xsl:value-of
                                                  select="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'EN']/D_7140"
                                                  />
                                                  </EANID>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'ZZZ']/D_7140 != ''">
                                                  <EuropeanWasteCatalogID>
                                                  <xsl:value-of
                                                  select="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'ZZZ']/D_7140"
                                                  />
                                                  </EuropeanWasteCatalogID>
                                                  </xsl:if>
                                                </ItemDetailRetail>
                                             </ItemDetailIndustry>
                                          </xsl:if>
                                          <xsl:if test="../../S_DTM/C_C507[D_2005 = '143'][D_2379 = '804']/D_2380!=''">
                                             <PlannedAcceptanceDays>
                                                <xsl:value-of select="../../S_DTM/C_C507[D_2005 = '143'][D_2379 = '804']/D_2380"/>
                                             </PlannedAcceptanceDays>
                                          </xsl:if>
                                       </ItemDetail>
                                       <xsl:if
                                          test="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/G_SG44/S_MOA/C_C516[D_5025 = '64'][D_6343 = '9']/D_5004">
                                          <Shipping>
                                             <xsl:if
                                                test="../../G_SG41/S_ALC[D_5463 = 'C']/C_C552/D_1230">
                                                <xsl:attribute name="trackingDomain">
                                                  <xsl:value-of
                                                  select="../../G_SG41/S_ALC[D_5463 = 'C']/C_C552/D_1230"
                                                  />
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if
                                                test="../../G_SG41/S_ALC[D_7161 = 'SAA']/C_C214/D_7160">
                                                <xsl:attribute name="trackingId">
                                                  <xsl:value-of
                                                  select="../../G_SG41/S_ALC[D_7161 = 'SAA']/C_C214/D_7160"
                                                  />
                                                </xsl:attribute>
                                             </xsl:if>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/G_SG44/S_MOA/C_C516[D_5025 = '64'][D_6343 = '9']/D_6345"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/G_SG44/S_MOA/C_C516[D_5025 = '64'][D_6343 = '9']/D_5004"
                                                />
                                             </Money>
                                             <Description>
                                                <xsl:attribute name="xml:lang">
                                                  <xsl:choose>
                                                  <xsl:when test="../S_FTX[D_4451 = 'TRA']/D_4451">
                                                  <xsl:value-of
                                                  select="distinct-values(../S_FTX[D_4451 = 'TRA']/D_3453)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>en</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:if
                                                  test="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/C_C214/D_7160">
                                                  <ShortName>
                                                  <xsl:value-of
                                                  select="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/C_C214/D_7160"
                                                  />
                                                  </ShortName>
                                                </xsl:if>
                                             </Description>
                                             <xsl:if
                                                test="../../G_SG41[S_ALC/C_C214/D_7161 != 'SAA']">
                                                <Modifications>
                                                  <xsl:for-each
                                                  select="../../G_SG41[S_ALC/C_C214/D_7161 != 'SAA']">
                                                  <xsl:if
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004 or G_SG43/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482 or G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_5004">
                                                  <Modification>
                                                  <xsl:if
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_6345">
                                                  <OriginalPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </OriginalPrice>
                                                  </xsl:if>
                                                  <xsl:choose>
                                                  <xsl:when test="S_ALC/D_5463 = 'A'">
                                                  <AdditionalDeduction>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004">
                                                  <DeductionAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </DeductionAmount>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="G_SG43/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482">
                                                  <DeductionPercent>
                                                  <xsl:attribute name="percent">
                                                  <xsl:value-of
                                                  select="G_SG43/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482"
                                                  />
                                                  </xsl:attribute>
                                                  </DeductionPercent>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_6345">
                                                  <DeductedPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </DeductedPrice>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </AdditionalDeduction>
                                                  </xsl:when>
                                                  <xsl:when test="S_ALC/D_5463 = 'C'">
                                                  <AdditionalCost>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </AdditionalCost>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  <ModificationDetail>
                                                  <Description>
                                                  <xsl:value-of
                                                  select="concat(substring(S_ALC/C_C214/D_7160_1, 0, 35), substring(S_ALC/C_C214/D_7160_2, 0, 35))"
                                                  />
                                                  </Description>
                                                  <xsl:attribute name="name">
                                                  <xsl:value-of select="S_ALC/C_C214/D_7161"/>
                                                  </xsl:attribute>
                                                  <xsl:if test="S_DTM/C_C507[D_2005 = '194']">
                                                  <xsl:attribute name="startDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '194']/D_2380"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '194']/D_2379"/>
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:if test="S_DTM/C_C507[D_2005 = '206']">
                                                  <xsl:attribute name="endDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  </ModificationDetail>
                                                  </Modification>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                </Modifications>
                                             </xsl:if>
                                          </Shipping>
                                       </xsl:if>
                                       <xsl:if test="../../G_SG36/S_TAX">
                                          <Tax>
                                             <TaxDetail>
                                                <xsl:attribute name="purpose">
                                                  <xsl:choose>
                                                  <xsl:when test="../../G_SG36/S_TAX/D_5283 = '5'">
                                                  <xsl:text>duty</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>tax</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:attribute name="category">
                                                  <xsl:variable name="category"
                                                  select="../../G_SG36/S_TAX/C_C241/D_5153"/>
                                                  <xsl:value-of
                                                  select="$lookups/Lookups/TaxCodes/TaxCode[EDIFACTCode = $category]/CXMLCode"
                                                  />
                                                </xsl:attribute>
                                                <xsl:attribute name="percentageRate">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C243/D_5278"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="isVatRecoverable">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C533/D_5289"/>
                                                </xsl:attribute>
                                                <xsl:if
                                                  test="../../G_SG31/S_DTM/C_C507[D_2005 = '131']/D_2380">
                                                  <xsl:attribute name="taxPointDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '131']/D_2380"
                                                  />
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '131']/D_2379"
                                                  />
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                </xsl:if>
                                                <xsl:if
                                                  test="../../G_SG31/S_DTM/C_C507[D_2005 = '140']/D_2380">
                                                  <xsl:attribute name="paymentDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '140']/D_2380"
                                                  />
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '140']/D_2379"
                                                  />
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="../../G_SG36/S_TAX/C_C243/D_5279">
                                                  <xsl:attribute name="isTriangularTransaction">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="upper-case(../../G_SG36/S_TAX/C_C243/D_5279) = 'IT'">
                                                  <xsl:text>yes</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>no</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="../../G_SG36/S_TAX/C_C243/D_5305">
                                                  <xsl:attribute name="exemptDetail">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="upper-case(../../G_SG36/S_TAX/C_C243/D_5305) = 'Z'">
                                                  <xsl:text>zeroRated</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>exempt</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="../../G_SG36/S_MOA/C_C516/D_6345">
                                                  <TaxableAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_MOA/C_C516/D_6345"/>
                                                  </xsl:attribute>
                                                  <xsl:if test="../../G_SG36/S_TAX/C_C243/D_5279">
                                                  <xsl:attribute name="alternateAmount">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C243/D_5279"/>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C533/D_5286"/>
                                                  </Money>
                                                  </TaxableAmount>
                                                </xsl:if>
                                                <TaxAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_MOA/C_C516[D_5025 = '124']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="../../G_SG36/C_C516[D_5025 = '124']/D_5004"
                                                  />
                                                  </Money>
                                                </TaxAmount>
                                                <xsl:if test="../../G_SG36/S_TAX/C_C241/D_5152">
                                                  <TaxLocation xml:lang="'en'">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C241/D_5152"/>
                                                  </TaxLocation>
                                                </xsl:if>
                                             </TaxDetail>
                                          </Tax>
                                       </xsl:if>
                                    </ItemIn>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when
                                          test="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'AAK']/D_5118">
                                          <UnitPrice>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG30/S_CUX/C_C504_1[D_6347 = '5'][D_6343 = '9']/D_6345"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="../../G_SG30/S_PRI/C_C509[D_5125 = 'CAL'][D_5387 = 'AAK']/D_5118"
                                                />
                                             </Money>
                                          </UnitPrice>
                                       </xsl:when>
                                       <xsl:when
                                          test="../../S_MOA/C_C516[D_5025 = '146'][D_6343 = '9']/D_6345">
                                          <UnitPrice>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../S_MOA/C_C516[D_5025 = '146'][D_6343 = '9']/D_6345"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="../../S_MOA/C_C516[D_5025 = '146'][D_6343 = '9']/D_5004"
                                                />
                                             </Money>
                                          </UnitPrice>
                                       </xsl:when>
                                    </xsl:choose>
                                    <xsl:if test="../../G_SG36/S_TAX">
                                       <Tax>
                                          <TaxDetail>
                                             <xsl:attribute name="purpose">
                                                <xsl:choose>
                                                  <xsl:when test="../../G_SG36/S_TAX/D_5283 = '5'">
                                                  <xsl:text>duty</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>tax</xsl:text>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                             </xsl:attribute>
                                             <xsl:attribute name="category">
                                                <xsl:variable name="category"
                                                  select="../../G_SG36/S_TAX/C_C241/D_5153"/>
                                                <xsl:value-of
                                                  select="$lookups/Lookups/TaxCodes/TaxCode[EDIFACTCode = $category]/CXMLCode"
                                                />
                                             </xsl:attribute>
                                             <xsl:attribute name="percentageRate">
                                                <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C243/D_5278"/>
                                             </xsl:attribute>
                                             <xsl:attribute name="isVatRecoverable">
                                                <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C533/D_5289"/>
                                             </xsl:attribute>
                                             <xsl:if
                                                test="../../G_SG31/S_DTM/C_C507[D_2005 = '131']/D_2380">
                                                <xsl:attribute name="taxPointDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '131']/D_2380"
                                                  />
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '131']/D_2379"
                                                  />
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if
                                                test="../../G_SG31/S_DTM/C_C507[D_2005 = '140']/D_2380">
                                                <xsl:attribute name="paymentDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '140']/D_2380"
                                                  />
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="../../G_SG31/S_DTM/C_C507[D_2005 = '140']/D_2379"
                                                  />
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if test="G_SG36/S_TAX/C_C243/D_5279">
                                                <xsl:attribute name="isTriangularTransaction">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="upper-case(../../G_SG36/S_TAX/C_C243/D_5279) = 'IT'">
                                                  <xsl:text>yes</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>no</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if test="../G_SG36/S_TAX/C_C243/D_5305">
                                                <xsl:attribute name="exemptDetail">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="upper-case(../../G_SG36/S_TAX/C_C243/D_5305) = 'Z'">
                                                  <xsl:text>zeroRated</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>exempt</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                             </xsl:if>
                                             <xsl:if test="../../G_SG36/S_MOA/C_C516/D_6345">
                                                <TaxableAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_MOA/C_C516/D_6345"/>
                                                  </xsl:attribute>
                                                  <xsl:if test="../../G_SG36/S_TAX/C_C243/D_5279">
                                                  <xsl:attribute name="alternateAmount">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C243/D_5279"/>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C533/D_5286"/>
                                                  </Money>
                                                </TaxableAmount>
                                             </xsl:if>
                                             <TaxAmount>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_MOA/C_C516[D_5025 = '124']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="../../G_SG36/C_C516[D_5025 = '124']/D_5004"
                                                  />
                                                </Money>
                                             </TaxAmount>
                                             <xsl:if test="../../G_SG36/S_TAX/C_C241/D_5152">
                                                <TaxLocation xml:lang="'en'">
                                                  <xsl:value-of
                                                  select="../../G_SG36/S_TAX/C_C241/D_5152"/>
                                                </TaxLocation>
                                             </xsl:if>
                                          </TaxDetail>
                                       </Tax>
                                    </xsl:if>
                                    <xsl:if
                                       test="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/G_SG44/S_MOA/C_C516[D_5025 = '64'][D_6343 = '9']/D_5004">
                                       <Shipping>
                                          <xsl:if
                                             test="../../G_SG41/S_ALC[D_5463 = 'C']/C_C552/D_1230">
                                             <xsl:attribute name="trackingDomain">
                                                <xsl:value-of
                                                  select="../../G_SG41/S_ALC[D_5463 = 'C']/C_C552/D_1230"
                                                />
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:if
                                             test="../../G_SG41/S_ALC[D_7161 = 'SAA']/C_C214/D_7160">
                                             <xsl:attribute name="trackingId">
                                                <xsl:value-of
                                                  select="../../G_SG41/S_ALC[D_7161 = 'SAA']/C_C214/D_7160"
                                                />
                                             </xsl:attribute>
                                          </xsl:if>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of
                                                  select="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/G_SG44/S_MOA/C_C516[D_5025 = '64'][D_6343 = '9']/D_6345"
                                                />
                                             </xsl:attribute>
                                             <xsl:value-of
                                                select="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/G_SG44/S_MOA/C_C516[D_5025 = '64'][D_6343 = '9']/D_5004"
                                             />
                                          </Money>
                                          <Description>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                  <xsl:when test="../S_FTX[D_4451 = 'TRA']/D_4451">
                                                  <xsl:value-of
                                                  select="distinct-values(../S_FTX[D_4451 = 'TRA']/D_3453)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>en</xsl:text>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                             </xsl:attribute>
                                             <xsl:if
                                                test="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/C_C214/D_7160">
                                                <ShortName>
                                                  <xsl:value-of
                                                  select="../../G_SG41[S_ALC/C_C214/D_7161 = 'SAA']/C_C214/D_7160"
                                                  />
                                                </ShortName>
                                             </xsl:if>
                                          </Description>
                                          <xsl:if test="../../G_SG41[S_ALC/C_C214/D_7161 != 'SAA']">
                                             <Modifications>
                                                <xsl:for-each
                                                  select="../../G_SG41[S_ALC/C_C214/D_7161 != 'SAA']">
                                                  <xsl:if
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004 or G_SG43/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482 or G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_5004">
                                                  <Modification>
                                                  <xsl:if
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_6345">
                                                  <OriginalPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '98'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </OriginalPrice>
                                                  </xsl:if>
                                                  <xsl:choose>
                                                  <xsl:when test="S_ALC/D_5463 = 'A'">
                                                  <AdditionalDeduction>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004">
                                                  <DeductionAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </DeductionAmount>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="G_SG43/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482">
                                                  <DeductionPercent>
                                                  <xsl:attribute name="percent">
                                                  <xsl:value-of
                                                  select="G_SG43/S_PCD/C_C501[D_5245 = '3'][D_5249 = '13']/D_5482"
                                                  />
                                                  </xsl:attribute>
                                                  </DeductionPercent>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_6345">
                                                  <DeductedPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '4'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </DeductedPrice>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </AdditionalDeduction>
                                                  </xsl:when>
                                                  <xsl:when test="S_ALC/D_5463 = 'C'">
                                                  <AdditionalCost>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="G_SG44/G_SG22/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_6345"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="G_SG44/S_MOA/C_C516[D_5025 = '8'][D_6343 = '9']/D_5004"
                                                  />
                                                  </Money>
                                                  </AdditionalCost>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  <ModificationDetail>
                                                  <Description>
                                                  <xsl:value-of
                                                  select="concat(substring(S_ALC/C_C214/D_7160_1, 0, 35), substring(S_ALC/C_C214/D_7160_2, 0, 35))"
                                                  />
                                                  </Description>
                                                  <xsl:attribute name="name">
                                                  <xsl:value-of select="S_ALC/C_C214/D_7161"/>
                                                  </xsl:attribute>
                                                  <xsl:if test="S_DTM/C_C507[D_2005 = '194']">
                                                  <xsl:attribute name="startDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '194']/D_2380"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '194']/D_2379"/>
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:if test="S_DTM/C_C507[D_2005 = '206']">
                                                  <xsl:attribute name="endDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="dateTime">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="dateTimeFormat">
                                                  <xsl:value-of
                                                  select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  </ModificationDetail>
                                                  </Modification>
                                                  </xsl:if>
                                                </xsl:for-each>
                                             </Modifications>
                                          </xsl:if>
                                       </Shipping>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <xsl:if
                                 test="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'NB']/D_7140 != ''">
                                 <SupplierBatchID>
                                    <xsl:value-of
                                       select="../../S_PIA[D_4347 = '1']//.[upper-case(D_7143) = 'NB']/D_7140"
                                    />
                                 </SupplierBatchID>
                              </xsl:if>
                              <xsl:if test="../S_FTX[upper-case(D_4451) = 'AAI']">
                                 <Comments>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:choose>
                                          <xsl:when
                                             test="../S_FTX[upper-case(D_4451) = 'AAI']/D_3453">
                                             <xsl:value-of
                                                select="distinct-values(../S_FTX[upper-case(D_4451) = 'AAI']/D_3453)"
                                             />
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:text>en</xsl:text>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:for-each select="../S_FTX[upper-case(D_4451) = 'AAI']">
                                       <xsl:value-of select="C_C108/D_4440_1"/>
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
                                    <!-- enable it for attachments									<Attachment>										<URL>											<xsl:attribute name="name">												<xsl:value-of select="FileName"/>											</xsl:attribute>											<xsl:value-of select="AttachmentLocation"/>										</URL>									</Attachment>									-->
                                 </Comments>
                              </xsl:if>
                              <xsl:if
                                 test="$itemConfStatus = 'reject' and ../S_FTX[upper-case(D_4451) = 'ACD']/C_C108/D_4440_1">
                                 <xsl:variable name="rejreason"
                                    select="../S_FTX[upper-case(D_4451) = 'ACD']/C_C108/D_4440_1"/>
                                 <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'RejectionReasonComments'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$rejreason"/>
                                 </xsl:element>
                                 <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'RejectionReason'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                       <xsl:when
                                          test="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EDIFACTCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode != ''">
                                          <xsl:value-of
                                             select="$lookups/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(EDIFACTCode, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode"
                                          />
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:text>other</xsl:text>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:element>
                              </xsl:if>
                              <xsl:for-each select="../S_FTX[upper-case(D_4451) = 'ZZZ']">
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="C_C108/D_4440_1"/>
                                    </xsl:attribute>
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
                                 </Extrinsic>
                              </xsl:for-each>
                           </ConfirmationStatus>
                        </xsl:for-each>
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
   <xsl:template name="CreateContact">
      <xsl:param name="contactPath"/>
      <Name>
         <xsl:attribute name="xml:lang">
            <xsl:value-of select="'en'"/>
         </xsl:attribute>
         <xsl:value-of select="$contactPath/C_C058/D_3124_1"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="$contactPath/C_C058/D_3124_2"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="$contactPath/C_C058/D_3124_3"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="$contactPath/C_C058/D_3124_4"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="$contactPath/C_C058/D_3124_5"/>
      </Name>
      <PostalAddress>
         <DeliverTo>
            <xsl:value-of select="$contactPath/C_C080/D_3036_1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$contactPath/C_C080/D_3036_2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$contactPath/C_C080/D_3036_3"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$contactPath/C_C080/D_3036_4"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$contactPath/C_C080/D_3036_5"/>
         </DeliverTo>
         <Street>
            <xsl:value-of select="$contactPath/C_C059/D_3042_1"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$contactPath/C_C059/D_3042_2"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$contactPath/C_C059/D_3042_3"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$contactPath/C_C059/D_3042_4"/>
         </Street>
         <City>
            <xsl:value-of select="$contactPath/D_3164"/>
         </City>
         <PostalCode>
            <xsl:value-of select="$contactPath/D_3251"/>
         </PostalCode>
         <xsl:variable name="isoCountryCode">
            <xsl:value-of select="$contactPath/D_3207"/>
         </xsl:variable>
         <Country>
            <xsl:attribute name="isoCountryCode">
               <xsl:value-of select="$isoCountryCode"/>
            </xsl:attribute>
            <xsl:value-of
               select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
            />
         </Country>
      </PostalAddress>
   </xsl:template>
   <xsl:template name="PhoneFaxEmail">
      <xsl:param name="contactName"/>
      <xsl:param name="phone"/>
      <xsl:param name="fax"/>
      <xsl:param name="email"/>
      <xsl:param name="countrycode"/>
      <xsl:param name="attributeName"/>
      <xsl:if test="$email and $email != ''">
         <Email>
            <xsl:attribute name="name">
               <xsl:value-of select="$attributeName"/>
            </xsl:attribute>
            <xsl:value-of select="$email"/>
         </Email>
      </xsl:if>
      <xsl:if test="$phone and $phone != ''">
         <Phone>
            <xsl:attribute name="name">
               <xsl:value-of select="$attributeName"/>
            </xsl:attribute>
            <xsl:call-template name="convertToTelephone">
               <xsl:with-param name="phoneNum" select="$phone"/>
            </xsl:call-template>
         </Phone>
      </xsl:if>
      <xsl:if test="$fax and $fax != ''">
         <Fax>
            <xsl:attribute name="name">
               <xsl:value-of select="$attributeName"/>
            </xsl:attribute>
            <xsl:call-template name="convertToTelephone">
               <xsl:with-param name="phoneNum" select="$fax"/>
            </xsl:call-template>
         </Fax>
      </xsl:if>
   </xsl:template>
   <xsl:template name="PhoneFaxEmailLoop">
      <xsl:param name="contactName"/>
      <xsl:param name="contactInfo"/>
      <xsl:param name="countrycode"/>
      <xsl:for-each select="$contactInfo/S_COM[C_C076/D_3155 = 'EM']">
         <Email>
            <xsl:attribute name="name">
               <xsl:value-of select="../S_CTA[D_3139 = 'IC']/C_C056/D_3412"/>
            </xsl:attribute>
            <xsl:value-of select="C_C076/D_3148"/>
         </Email>
      </xsl:for-each>
      <xsl:for-each select="$contactInfo/S_COM[C_C076/D_3155 = 'TE']">
         <Phone>
            <xsl:attribute name="name">
               <xsl:value-of select="../S_CTA[D_3139 = 'IC']/C_C056/D_3412"/>
            </xsl:attribute>
            <xsl:call-template name="convertToTelephone">
               <xsl:with-param name="phoneNum" select="C_C076/D_3148"/>
            </xsl:call-template>
         </Phone>
      </xsl:for-each>
      <xsl:for-each select="$contactInfo/S_COM[C_C076/D_3155 = 'FX']">
         <Fax>
            <xsl:attribute name="name">
               <xsl:value-of select="../S_CTA[D_3139 = 'IC']/C_C056/D_3412"/>
            </xsl:attribute>
            <xsl:call-template name="convertToTelephone">
               <xsl:with-param name="phoneNum" select="C_C076/D_3148"/>
            </xsl:call-template>
         </Fax>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="convertToTelephone">
      <xsl:param name="phoneNum"/>
      <xsl:variable name="phoneNumTemp">
         <xsl:value-of select="$phoneNum"/>
      </xsl:variable>
      <xsl:variable name="phoneArr" select="tokenize($phoneNumTemp, '-')"/>
      <xsl:variable name="countryCode">
         <xsl:value-of select="replace($phoneArr[1], '\+', '')"/>
      </xsl:variable>
      <xsl:element name="TelephoneNumber">
         <xsl:element name="CountryCode">
            <xsl:attribute name="isoCountryCode">
               <xsl:value-of
                  select="$lookups/Lookups/Countries/Country[phoneCode = $countryCode]/countryCode"
               />
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
   <xsl:template name="convertToAribaDate">
      <xsl:param name="dateTime"/>
      <xsl:param name="dateTimeFormat"/>
      <xsl:variable name="dtmFormat">
         <xsl:choose>
            <xsl:when test="$dateTimeFormat != ''">
               <xsl:value-of select="$dateTimeFormat"/>
            </xsl:when>
            <xsl:otherwise>102</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="tempDateTime">
         <xsl:choose>
            <xsl:when test="$dtmFormat = 102">
               <xsl:value-of select="concat($dateTime, '120000')"/>
            </xsl:when>
            <xsl:when test="$dtmFormat = 203">
               <xsl:value-of select="concat($dateTime, '00')"/>
            </xsl:when>
            <xsl:when test="$dtmFormat = 204">
               <xsl:value-of select="$dateTime"/>
            </xsl:when>
            <xsl:when test="$dtmFormat = 303">
               <xsl:value-of
                  select="concat(substring($dateTime, 0, 12), '00', substring($dateTime, 12))"/>
            </xsl:when>
            <xsl:when test="$dtmFormat = 304">
               <xsl:value-of select="$dateTime"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="timeZone">
         <xsl:choose>
            <xsl:when test="$dateTimeFormat = '303' or $dateTimeFormat = '304'">
               <xsl:choose>
                  <xsl:when
                     test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode != ''">
                     <xsl:value-of
                        select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode"
                     />
                  </xsl:when>
                  <xsl:otherwise>+00:00</xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>+00:00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of
         select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"
      />
   </xsl:template>
   <xsl:template name="convertToAribaDatePORef">
      <xsl:param name="dateTime"/>
      <xsl:param name="dateTimeFormat"/>
      <xsl:variable name="dtmFormat">
         <xsl:choose>
            <xsl:when test="$dateTimeFormat != ''">
               <xsl:value-of select="$dateTimeFormat"/>
            </xsl:when>
            <xsl:otherwise>102</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="timeZone">
         <xsl:choose>
            <xsl:when test="$dateTimeFormat = '303'">
               <xsl:choose>
                  <xsl:when
                     test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 13)]/CXMLCode != ''">
                     <xsl:value-of
                        select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 13)]/CXMLCode"
                     />
                  </xsl:when>
                  <xsl:otherwise/>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="$dateTimeFormat = '304'">
               <xsl:choose>
                  <xsl:when
                     test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 15)]/CXMLCode != ''">
                     <xsl:value-of
                        select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 15)]/CXMLCode"
                     />
                  </xsl:when>
                  <xsl:otherwise/>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$dtmFormat = '102'">
            <xsl:value-of
               select="concat(substring($dateTime, 0, 5), '-', substring($dateTime, 5, 2), '-', substring($dateTime, 7, 2))"
            />
         </xsl:when>
         <xsl:when test="$dtmFormat = '203' or $dateTimeFormat = '303'">
            <xsl:value-of
               select="concat(substring($dateTime, 0, 5), '-', substring($dateTime, 5, 2), '-', substring($dateTime, 7, 2), 'T', substring($dateTime, 9, 2), ':', substring($dateTime, 11, 2), $timeZone)"
            />
         </xsl:when>
         <xsl:when test="$dtmFormat = '204' or $dateTimeFormat = '304'">
            <xsl:value-of
               select="concat(substring($dateTime, 0, 5), '-', substring($dateTime, 5, 2), '-', substring($dateTime, 7, 2), 'T', substring($dateTime, 9, 2), ':', substring($dateTime, 11, 2), ':', substring($dateTime, 13, 2), $timeZone)"
            />
         </xsl:when>
      </xsl:choose>
      <!--xsl:value-of select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"/-->
   </xsl:template>
</xsl:stylesheet>
