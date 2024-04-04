<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:desadv:d.96a" exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anSharedSecrete"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="cXMLAttachments"/>
   <xsl:param name="attachSeparator" select="'\|'"/>
   <xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>
   <xsl:include href="FORMAT_UN-EDIFACT_D96A_cXML_0000.xsl"/>
   <!--<xsl:variable name="lookups" select="document('LOOKUP_UN-EDIFACT_D96A.xml')"/>   
      <xsl:include href="FORMAT_UN-EDIFACT_D96A_cXML_0000.xsl"/>-->
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
                  <!-- IG-4778 -->
                  <xsl:variable name="shipID">
                     <xsl:value-of select="normalize-space(M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_1004)"/>
                  </xsl:variable>
                  <xsl:attribute name="shipmentID">
                     <xsl:choose>
                        <!-- IG-4778 -->
                        <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_1225 = '3'">
                           <xsl:value-of select="concat($shipID, '_1')"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$shipID"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <!-- IG-4778 -->
                  <xsl:if test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_1225 != ''">
                     <xsl:attribute name="operation">
                        <xsl:choose>
                           <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_1225 = '3'">delete</xsl:when>
                           <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_1225 = '5' or M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_1225 = '4'">update</xsl:when>
                           <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_1225 = '9'">new</xsl:when>
                           <xsl:otherwise>new</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </xsl:if>
                  <!-- IG-4778 -->
                  <xsl:if test="M_DESADV/S_DTM/C_C507[D_2005 = '124']/D_2380 != '' or M_DESADV/S_DTM/C_C507[D_2005 = '137']/D_2380 != ''">
                     <xsl:attribute name="noticeDate">
                        <xsl:choose>
                           <xsl:when test="M_DESADV/S_DTM/C_C507[D_2005 = '124']/D_2380 != ''">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="dateTime">
                                    <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '124']/D_2380"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="dateTimeFormat">
                                    <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '124']/D_2379"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:when>
                           <xsl:when test="M_DESADV/S_DTM/C_C507[D_2005 = '137']/D_2380 != ''">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="dateTime">
                                    <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '137']/D_2380"/>
                                 </xsl:with-param>
                                 <xsl:with-param name="dateTimeFormat">
                                    <xsl:value-of select="M_DESADV/S_DTM/C_C507[D_2005 = '137']/D_2379"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:attribute>
                  </xsl:if>
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
                  <!-- IG-4778 start-->
                  <xsl:if test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_4343 != ''">
                     <xsl:attribute name="shipmentType">
                        <xsl:choose>
                           <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_4343 = 'AP'">actual</xsl:when>
                           <xsl:when test="M_DESADV/S_BGM[C_C002/D_1001 = '345' or C_C002/D_1001 = '351']/D_4343 = 'CA'">planned</xsl:when>
                           <xsl:otherwise>planned</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="M_DESADV/S_BGM/C_C002[D_1001 = '345' or D_1001 = '351']/D_1000 != ''">
                     <xsl:attribute name="fulfillmentType">
                        <xsl:value-of select="normalize-space(M_DESADV/S_BGM/C_C002[D_1001 = '345' or D_1001 = '351']/D_1000)"/>
                     </xsl:attribute>
                  </xsl:if>
                  <!-- IG-4778 end-->
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
                  <xsl:for-each select="M_DESADV/G_SG5/S_FTX[D_4451 = 'SSR' and C_C108/D_4440_1 != '']">
                     <xsl:element name="ServiceLevel">
                        <xsl:attribute name="xml:lang">
                           <xsl:choose>
                              <xsl:when test="D_3453 != ''">
                                 <xsl:value-of select="D_3453"/>
                              </xsl:when>
                              <xsl:otherwise>en</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(C_C108/D_4440_1)"/>
                     </xsl:element>
                     <xsl:if test="C_C108/D_4440_2 != ''">
                        <xsl:element name="ServiceLevel">
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="D_3453 != ''">
                                    <xsl:value-of select="D_3453"/>
                                 </xsl:when>
                                 <xsl:otherwise>en</xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:value-of select="normalize-space(C_C108/D_4440_2)"/>
                        </xsl:element>
                     </xsl:if>
                     <xsl:if test="C_C108/D_4440_3 != ''">
                        <xsl:element name="ServiceLevel">
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="D_3453 != ''">
                                    <xsl:value-of select="D_3453"/>
                                 </xsl:when>
                                 <xsl:otherwise>en</xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:value-of select="normalize-space(C_C108/D_4440_3)"/>
                        </xsl:element>
                     </xsl:if>
                     <xsl:if test="C_C108/D_4440_4 != ''">
                        <xsl:element name="ServiceLevel">
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="D_3453 != ''">
                                    <xsl:value-of select="D_3453"/>
                                 </xsl:when>
                                 <xsl:otherwise>en</xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:value-of select="normalize-space(C_C108/D_4440_4)"/>
                        </xsl:element>
                     </xsl:if>
                     <xsl:if test="C_C108/D_4440_5 != ''">
                        <xsl:element name="ServiceLevel">
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="D_3453 != ''">
                                    <xsl:value-of select="D_3453"/>
                                 </xsl:when>
                                 <xsl:otherwise>en</xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:value-of select="normalize-space(C_C108/D_4440_5)"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="M_DESADV/G_SG2[S_NAD/D_3035 != 'DP']">
                     <xsl:variable name="role">
                        <xsl:value-of select="S_NAD/D_3035"/>
                     </xsl:variable>
                     <xsl:variable name="roleValue" select="normalize-space($lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode)"/>
                     <xsl:if test="$roleValue != ''">
                        <xsl:element name="Contact">
                           <xsl:attribute name="role">
                              <xsl:value-of select="$roleValue"/>
                           </xsl:attribute>
                           <xsl:if test="S_NAD/C_C082/D_1131 = '160' or S_NAD/C_C082/D_1131 = 'ZZZ'">
                              <xsl:variable name="addrDomain">
                                 <xsl:value-of select="S_NAD/C_C082/D_3055"/>
                              </xsl:variable>
                              <xsl:if test="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]">
                                 <xsl:attribute name="addressID">
                                    <xsl:value-of select="S_NAD/C_C082/D_3039"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="normalize-space($lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]/CXMLCode)"/>
                                 </xsl:attribute>
                              </xsl:if>
                           </xsl:if>
                           <xsl:element name="Name">
                              <xsl:attribute name="xml:lang">en</xsl:attribute>
                              <xsl:value-of select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
                           </xsl:element>
                           <!-- PostalAddress -->
                           <xsl:if test="S_NAD/D_3164 != ''">
                              <xsl:element name="PostalAddress">
                                 <!-- <xsl:attribute name="name"/> -->
                                 <xsl:if test="S_NAD/C_C080/D_3036_1 != ''">
                                    <xsl:element name="DeliverTo">
                                       <xsl:value-of select="S_NAD/C_C080/D_3036_1"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C080/D_3036_2 != ''">
                                    <xsl:element name="DeliverTo">
                                       <xsl:value-of select="S_NAD/C_C080/D_3036_2"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C080/D_3036_3 != ''">
                                    <xsl:element name="DeliverTo">
                                       <xsl:value-of select="S_NAD/C_C080/D_3036_3"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C080/D_3036_4 != ''">
                                    <xsl:element name="DeliverTo">
                                       <xsl:value-of select="S_NAD/C_C080/D_3036_4"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C080/D_3036_5 != ''">
                                    <xsl:element name="DeliverTo">
                                       <xsl:value-of select="S_NAD/C_C080/D_3036_5"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C059/D_3042_1 != ''">
                                    <xsl:element name="Street">
                                       <xsl:value-of select="S_NAD/C_C059/D_3042_1"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C059/D_3042_2 != ''">
                                    <xsl:element name="Street">
                                       <xsl:value-of select="S_NAD/C_C059/D_3042_2"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C059/D_3042_3 != ''">
                                    <xsl:element name="Street">
                                       <xsl:value-of select="S_NAD/C_C059/D_3042_3"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/C_C059/D_3042_4 != ''">
                                    <xsl:element name="Street">
                                       <xsl:value-of select="S_NAD/C_C059/D_3042_4"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/D_3164 != ''"/>
                                 <xsl:element name="City">
                                    <xsl:value-of select="S_NAD/D_3164"/>
                                 </xsl:element>
                                 <xsl:variable name="sCode">
                                    <xsl:value-of select="S_NAD/D_3229"/>
                                 </xsl:variable>
                                 <xsl:if test="$sCode != ''">
                                    <xsl:element name="State">
                                       <xsl:value-of select="$lookups/Lookups/States/State[stateCode = $sCode]/stateName"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:if test="S_NAD/D_3251 != ''">
                                    <xsl:element name="PostalCode">
                                       <xsl:value-of select="S_NAD/D_3251"/>
                                    </xsl:element>
                                 </xsl:if>
                                 <xsl:variable name="isoCountryCode">
                                    <xsl:value-of select="S_NAD/D_3207"/>
                                 </xsl:variable>
                                 <xsl:element name="Country">
                                    <xsl:attribute name="isoCountryCode">
                                       <xsl:value-of select="$isoCountryCode"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:if>
                           <xsl:for-each select="G_SG4">
                              <xsl:variable name="comName">
                                 <xsl:value-of select="S_CTA/D_3139"/>
                              </xsl:variable>
                              <xsl:for-each select="S_COM">
                                 <xsl:choose>
                                    <xsl:when test="C_C076/D_3155 = 'EM'">
                                       <xsl:element name="Email">
                                          <xsl:attribute name="name">
                                             <xsl:choose>
                                                <xsl:when test="$comName = 'IC'">
                                                   <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                                                </xsl:when>
                                                <xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
                                                   <xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:text>default</xsl:text>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:attribute>
                                          <xsl:value-of select="C_C076/D_3148"/>
                                       </xsl:element>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:for-each>
                           </xsl:for-each>
                           <xsl:for-each select="G_SG4">
                              <xsl:variable name="comName">
                                 <xsl:value-of select="S_CTA/D_3139"/>
                              </xsl:variable>
                              <xsl:for-each select="S_COM">
                                 <xsl:choose>
                                    <xsl:when test="C_C076/D_3155 = 'TE'">
                                       <xsl:element name="Phone">
                                          <xsl:attribute name="name">
                                             <xsl:choose>
                                                <xsl:when test="$comName = 'IC'">
                                                   <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                                                </xsl:when>
                                                <xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
                                                   <xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:text>default</xsl:text>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:attribute>
                                          <xsl:call-template name="convertToTelephone">
                                             <xsl:with-param name="phoneNum">
                                                <xsl:value-of select="C_C076/D_3148"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:element>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:for-each>
                           </xsl:for-each>
                           <xsl:for-each select="G_SG4">
                              <xsl:variable name="comName">
                                 <xsl:value-of select="S_CTA/D_3139"/>
                              </xsl:variable>
                              <xsl:for-each select="S_COM">
                                 <xsl:choose>
                                    <xsl:when test="C_C076/D_3155 = 'FX'">
                                       <xsl:element name="Fax">
                                          <xsl:attribute name="name">
                                             <xsl:choose>
                                                <xsl:when test="$comName = 'IC'">
                                                   <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                                                </xsl:when>
                                                <xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
                                                   <xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:text>default</xsl:text>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:attribute>
                                          <xsl:call-template name="convertToTelephone">
                                             <xsl:with-param name="phoneNum">
                                                <xsl:value-of select="C_C076/D_3148"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:element>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:for-each>
                           </xsl:for-each>
                           <xsl:for-each select="G_SG4">
                              <xsl:variable name="comName">
                                 <xsl:value-of select="S_CTA/D_3139"/>
                              </xsl:variable>
                              <xsl:for-each select="S_COM">
                                 <xsl:choose>
                                    <xsl:when test="C_C076/D_3155 = 'AH'">
                                       <xsl:element name="URL">
                                          <xsl:attribute name="name">
                                             <xsl:choose>
                                                <xsl:when test="$comName = 'IC'">
                                                   <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                                                </xsl:when>
                                                <xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
                                                   <xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:text>default</xsl:text>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:attribute>
                                          <xsl:value-of select="C_C076/D_3148"/>
                                       </xsl:element>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:for-each>
                           </xsl:for-each>
                           <!-- IG-4778 start-->
                           <xsl:for-each select="G_SG3">
                              <xsl:variable name="rffCode" select="S_RFF/C_C506/D_1153"/>
                              <xsl:variable name="rffValue" select="S_RFF/C_C506/D_1154"/>
                              <xsl:choose>
                                 <xsl:when test="$rffCode = 'AP'">
                                    <xsl:if test="$roleValue='buyer' or $roleValue = 'shipTo' or $roleValue = 'soldTo' or $roleValue = 'billTo'">
                                       <xsl:element name="IdReference">
                                          <xsl:attribute name="domain" select="'accountReceivableID'"/>
                                          <xsl:attribute name="identifier" select="normalize-space(M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AP']/D_1154)"/>
                                       </xsl:element>
                                    </xsl:if>
                                 </xsl:when>
                                 <xsl:when test="$rffCode = 'AV'">
                                    <xsl:if test="$roleValue='from' or $roleValue = 'issuerOfInvoice' or $roleValue = 'supplierCorporate'">
                                       <xsl:element name="IdReference">
                                          <xsl:attribute name="domain" select="'accountPayableID'"/>
                                          <xsl:attribute name="identifier" select="normalize-space(M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AV']/D_1154)"/>
                                       </xsl:element>
                                    </xsl:if>
                                 </xsl:when>
                                 <xsl:when test="$rffCode = 'IA'">
                                    <xsl:if test="$roleValue='from' or $roleValue = 'supplierCorporate' or $roleValue = 'supplierAccount'or $roleValue = 'issuerOfInvoice'">
                                       <xsl:element name="IdReference">
                                          <xsl:attribute name="domain" select="'vendorNumber'"/>
                                          <xsl:attribute name="identifier" select="normalize-space(M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'IA']/D_1154)"/>
                                       </xsl:element>
                                    </xsl:if>
                                 </xsl:when>
                              </xsl:choose>
                              <xsl:if test="normalize-space($lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EDIFACTCode = $rffCode]/CXMLCode) != ''">
                                 <xsl:element name="IdReference">
                                    <xsl:attribute name="domain" select="normalize-space($lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EDIFACTCode = $rffCode]/CXMLCode)"/>
                                    <xsl:attribute name="identifier" select="$rffValue"/>
                                 </xsl:element>
                              </xsl:if>
                           </xsl:for-each>
                           <!-- IG-4778 end -->
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <!-- IG-4778 start-->
                  <xsl:for-each select="M_DESADV/G_SG10[S_CPS/D_7164='1']/S_FTX[D_4451 = 'AAI'][C_C108/D_4440_1 != '' or C_C108/D_4440_2 != '']">
                     <xsl:element name="Comments">
                        <xsl:if test="C_C108/D_4440_1 != ''">
                           <xsl:attribute name="type" select="C_C108/D_4440_1"/>
                        </xsl:if>
                        <xsl:if test="D_3453 != ''">
                           <xsl:attribute name="xml:lang" select="substring(D_3453,1,2)"/>
                        </xsl:if>
                        <xsl:value-of select="concat(C_C108/D_4440_2,C_C108/D_4440_3,C_C108/D_4440_4,C_C108/D_4440_5)"/>
                     </xsl:element>
                  </xsl:for-each>
                  <!-- IG-4778 end-->
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
                  <xsl:if test="M_DESADV/G_SG5/S_TOD/D_4215 != ''">
                     <xsl:variable name="TODCode">
                        <xsl:value-of select="M_DESADV/G_SG5/S_TOD/D_4055"/>
                     </xsl:variable>
                     <xsl:variable name="SPMCode">
                        <xsl:value-of select="M_DESADV/G_SG5/S_TOD/D_4215"/>
                     </xsl:variable>
                     <xsl:variable name="TTCode">
                        <xsl:value-of select="M_DESADV/G_SG5/S_TOD/C_C100/D_4053"/>
                     </xsl:variable>
                     <xsl:element name="TermsOfDelivery">
                        <xsl:element name="TermsOfDeliveryCode">
                           <xsl:attribute name="value">
                              <xsl:choose>
                                 <xsl:when test="M_DESADV/G_SG5/S_FTX[D_4451 = 'AAR'][C_C107/D_4441 = 'TDC']/C_C108/D_4440_1 != ''">other</xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$lookups/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[EDIFACTCode = $TODCode]/CXMLCode"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:if test="M_DESADV/G_SG5/S_FTX[D_4451 = 'AAR'][C_C107/D_4441 = 'TDC']/C_C108/D_4440_1 != ''">
                              <xsl:value-of select="M_DESADV/G_SG5/S_FTX[D_4451 = 'AAR'][C_C107/D_4441 = 'TDC']/C_C108/D_4440_1"/>
                           </xsl:if>
                        </xsl:element>
                        <xsl:element name="ShippingPaymentMethod">
                           <xsl:attribute name="value">
                              <xsl:value-of select="$lookups/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[EDIFACTCode = $SPMCode]/CXMLCode"/>
                           </xsl:attribute>
                           <xsl:if test="$SPMCode = 'ZZZ' and M_DESADV/G_SG5/S_FTX[D_4451 = 'AAR'][C_C107/D_4441 = 'SPM']/C_C108/D_4440_1 != ''">
                              <xsl:value-of select="M_DESADV/G_SG5/S_FTX[D_4451 = 'AAR'][C_C107/D_4441 = 'SPM']/C_C108/D_4440_1"/>
                           </xsl:if>
                        </xsl:element>
                        <xsl:if test="$TTCode != ''">
                           <xsl:element name="TransportTerms">
                              <xsl:attribute name="value">
                                 <xsl:value-of select="$lookups/Lookups/TransportTermsCodes/TransportTermsCode[EDIFACTCode = $TTCode]/CXMLCode"/>
                              </xsl:attribute>
                              <xsl:if test="$TTCode = 'ZZZ' and M_DESADV/G_SG5/S_FTX[D_4451 = 'AAR'][C_C107/D_4441 = 'TTC']/C_C108/D_4440_1 != ''">
                                 <xsl:value-of select="M_DESADV/G_SG5/S_FTX[D_4451 = 'AAR'][C_C107/D_4441 = 'TTC']/C_C108/D_4440_1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                        <xsl:for-each select="M_DESADV/G_SG2[S_NAD/D_3035 = 'DP']">
                           <xsl:element name="Address">
                              <xsl:if test="S_NAD/C_C082/D_1131 = '160' or S_NAD/C_C082/D_1131 = 'ZZZ'">
                                 <xsl:variable name="addrDomain">
                                    <xsl:value-of select="S_NAD/C_C082/D_3055"/>
                                 </xsl:variable>
                                 <xsl:if test="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]">
                                    <xsl:attribute name="addressID">
                                       <xsl:value-of select="S_NAD/C_C082/D_3039"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="addressIDDomain">
                                       <xsl:value-of select="normalize-space($lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]/CXMLCode)"/>
                                    </xsl:attribute>
                                 </xsl:if>
                              </xsl:if>
                              <xsl:element name="Name">
                                 <xsl:attribute name="xml:lang">en</xsl:attribute>
                                 <xsl:value-of select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
                              </xsl:element>
                              <!-- PostalAddress -->
                              <xsl:if test="S_NAD/D_3164 != ''">
                                 <xsl:element name="PostalAddress">
                                    <!-- <xsl:attribute name="name"/> -->
                                    <xsl:if test="S_NAD/C_C080/D_3036_1 != ''">
                                       <xsl:element name="DeliverTo">
                                          <xsl:value-of select="S_NAD/C_C080/D_3036_1"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C080/D_3036_2 != ''">
                                       <xsl:element name="DeliverTo">
                                          <xsl:value-of select="S_NAD/C_C080/D_3036_2"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C080/D_3036_3 != ''">
                                       <xsl:element name="DeliverTo">
                                          <xsl:value-of select="S_NAD/C_C080/D_3036_3"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C080/D_3036_4 != ''">
                                       <xsl:element name="DeliverTo">
                                          <xsl:value-of select="S_NAD/C_C080/D_3036_4"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C080/D_3036_5 != ''">
                                       <xsl:element name="DeliverTo">
                                          <xsl:value-of select="S_NAD/C_C080/D_3036_5"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C059/D_3042_1 != ''">
                                       <xsl:element name="Street">
                                          <xsl:value-of select="S_NAD/C_C059/D_3042_1"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C059/D_3042_2 != ''">
                                       <xsl:element name="Street">
                                          <xsl:value-of select="S_NAD/C_C059/D_3042_2"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C059/D_3042_3 != ''">
                                       <xsl:element name="Street">
                                          <xsl:value-of select="S_NAD/C_C059/D_3042_3"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/C_C059/D_3042_4 != ''">
                                       <xsl:element name="Street">
                                          <xsl:value-of select="S_NAD/C_C059/D_3042_4"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/D_3164 != ''"/>
                                    <xsl:element name="City">
                                       <!-- <xsl:attribute name="cityCode"/> -->
                                       <xsl:value-of select="S_NAD/D_3164"/>
                                    </xsl:element>
                                    <xsl:variable name="sCode">
                                       <xsl:value-of select="S_NAD/D_3229"/>
                                    </xsl:variable>
                                    <xsl:if test="$sCode != ''">
                                       <xsl:element name="State">
                                          <xsl:value-of select="$lookups/Lookups/States/State[stateCode = $sCode]/stateName"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="S_NAD/D_3251 != ''">
                                       <xsl:element name="PostalCode">
                                          <xsl:value-of select="S_NAD/D_3251"/>
                                       </xsl:element>
                                    </xsl:if>
                                    <xsl:variable name="isoCountryCode">
                                       <xsl:value-of select="S_NAD/D_3207"/>
                                    </xsl:variable>
                                    <xsl:element name="Country">
                                       <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="$isoCountryCode"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:if>
                              <xsl:for-each select="G_SG4[S_COM/C_C076/D_3155 = 'EM'][1]">
                                 <xsl:variable name="comName">
                                    <xsl:value-of select="S_CTA/D_3139"/>
                                 </xsl:variable>
                                 <xsl:element name="Email">
                                    <xsl:attribute name="name">
                                       <xsl:choose>
                                          <xsl:when test="$comName = 'IC' or $comName = 'DL'">
                                             <xsl:value-of select="normalize-space(concat(S_CTA/C_C056/D_3413, S_CTA/C_C056/D_3412))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:text>DeliveryParty</xsl:text>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="S_COM/C_C076[D_3155 = 'EM']/D_3148"/>
                                 </xsl:element>
                              </xsl:for-each>
                              <xsl:for-each select="G_SG4[S_COM/C_C076/D_3155 = 'TE'][1]">
                                 <xsl:variable name="comName">
                                    <xsl:value-of select="S_CTA/D_3139"/>
                                 </xsl:variable>
                                 <xsl:element name="Phone">
                                    <xsl:attribute name="name">
                                       <xsl:choose>
                                          <xsl:when test="$comName = 'IC' or $comName = 'DL'">
                                             <xsl:value-of select="normalize-space(concat(S_CTA/C_C056/D_3413, S_CTA/C_C056/D_3412))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:text>DeliveryParty</xsl:text>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:call-template name="convertToTelephone">
                                       <xsl:with-param name="phoneNum">
                                          <xsl:value-of select="S_COM/C_C076[D_3155 = 'TE']/D_3148"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:element>
                              </xsl:for-each>
                              <xsl:for-each select="G_SG4[S_COM/C_C076/D_3155 = 'FX'][1]">
                                 <xsl:variable name="comName">
                                    <xsl:value-of select="S_CTA/D_3139"/>
                                 </xsl:variable>
                                 <xsl:element name="Fax">
                                    <xsl:attribute name="name">
                                       <xsl:choose>
                                          <xsl:when test="$comName = 'IC' or $comName = 'DL'">
                                             <xsl:value-of select="normalize-space(concat(S_CTA/C_C056/D_3413, S_CTA/C_C056/D_3412))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:text>DeliveryParty</xsl:text>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:call-template name="convertToTelephone">
                                       <xsl:with-param name="phoneNum">
                                          <xsl:value-of select="S_COM/C_C076[D_3155 = 'FX']/D_3148"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:element>
                              </xsl:for-each>
                              <xsl:for-each select="G_SG4[S_COM/C_C076/D_3155 = 'AH'][1]">
                                 <xsl:variable name="comName">
                                    <xsl:value-of select="S_CTA/D_3139"/>
                                 </xsl:variable>
                                 <xsl:element name="URL">
                                    <xsl:attribute name="name">
                                       <xsl:choose>
                                          <xsl:when test="$comName = 'IC' or $comName = 'DL'">
                                             <xsl:value-of select="normalize-space(concat(S_CTA/C_C056/D_3413, S_CTA/C_C056/D_3412))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:text>DeliveryParty</xsl:text>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="S_COM/C_C076[D_3155 = 'AH']/D_3148"/>
                                 </xsl:element>
                              </xsl:for-each>
                           </xsl:element>
                        </xsl:for-each>
                        <xsl:if test="M_DESADV/G_SG5/S_TOD/C_C100/D_4052_1 != '' or M_DESADV/G_SG5/S_TOD/C_C100/D_4052_2 != ''">
                           <xsl:element name="Comments">
                              <xsl:attribute name="xml:lang">en</xsl:attribute>
                              <xsl:attribute name="type">
                                 <xsl:choose>
                                    <xsl:when test="$TODCode = '5'">Transport</xsl:when>
                                    <xsl:when test="$TODCode = '6'">TermsOfDelivery</xsl:when>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:value-of select="normalize-space(concat(M_DESADV/G_SG5/S_TOD/C_C100/D_4052_1, M_DESADV/G_SG5/S_TOD/C_C100/D_4052_2))"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:for-each select="M_DESADV/G_SG5/S_FTX[D_4451 = 'AAI' and C_C108/D_4440_2 != '']">
                           <xsl:element name="Comments">
                              <xsl:attribute name="xml:lang">
                                 <xsl:choose>
                                    <xsl:when test="D_3453 != ''">
                                       <xsl:value-of select="D_3453"/>
                                    </xsl:when>
                                    <xsl:otherwise>en</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:if test="C_C108/D_4440_1 != ''">
                                 <xsl:attribute name="type">
                                    <xsl:value-of select="C_C108/D_4440_1"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:value-of select="normalize-space(concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5))"/>
                           </xsl:element>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:if>
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
                        <xsl:for-each select="S_MEA[D_6311 = 'AAE' and C_C174/D_6411 != '' and C_C174/D_6314 != '']">
                           <xsl:variable name="mCode" select="C_C502/D_6313"/>
                           <xsl:if test="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode != ''">
                              <xsl:element name="Dimension">
                                 <xsl:attribute name="quantity">
                                    <xsl:value-of select="C_C174/D_6314"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="type">
                                    <xsl:value-of select="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode"/>
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
                  <xsl:if test="M_DESADV/S_MEA[D_6311 = 'AAE']">
                  <xsl:element name="Packaging">
                     <xsl:for-each select="M_DESADV/S_MEA[D_6311 = 'AAE']">
                        <xsl:variable name="mCode" select="C_C502/D_6313"/>
                        <xsl:if test="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode != ''">
                           <xsl:element name="Dimension">
                              <xsl:attribute name="quantity">
                                 <xsl:value-of select="C_C174/D_6314"/>
                              </xsl:attribute>
                              <xsl:attribute name="type">
                                 <xsl:value-of select="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode"/>
                              </xsl:attribute>
                              <xsl:element name="UnitOfMeasure">
                                 <xsl:value-of select="C_C174/D_6411"/>
                              </xsl:element>
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:element>
                  </xsl:if>
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
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AAN']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">DeliverySheduleID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AAN']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">DeliveryNoteID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">InvoiceID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">SupplierOrderID</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- IG-4778 start-->
                  <xsl:if test="M_DESADV/G_SG10[S_CPS/D_7164='1']/G_SG11/S_PAC/D_7224 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">totalOfPackages</xsl:attribute>
                        <xsl:value-of select="M_DESADV/G_SG10[S_CPS/D_7164='1']/G_SG11/S_PAC/D_7224"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- IG-10703  -->
                  <xsl:for-each select="M_DESADV/G_SG10/S_FTX">
                     <xsl:if test="D_4451 = 'ZZZ'">
                        <xsl:element name="Extrinsic">
                           <xsl:attribute name="name">
                              <xsl:value-of select="C_C108/D_4440_1"/>                              
                           </xsl:attribute>                       
                           <xsl:value-of select="normalize-space(concat(C_C108/D_4440_2,' ',C_C108/D_4440_3,' ',C_C108/D_4440_4,' ',C_C108/D_4440_5))"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain" select="'CustomerReferenceID'"/>
                        <xsl:attribute name="identifier" select="normalize-space(M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154)"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154 != ''">
                     <xsl:element name="IdReference">
                        <xsl:attribute name="domain" select="'UltimateCustomerReferenceID'"/>
                        <xsl:attribute name="identifier" select="normalize-space(M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154)"/>
                     </xsl:element>
                  </xsl:if>
                  <!-- IG-4778 end-->
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
               <xsl:for-each select="M_DESADV/G_SG6[S_TDT/D_8051 = '20']">
                  <xsl:element name="ShipControl">
                     <xsl:element name="CarrierIdentifier">
                        <xsl:attribute name="domain">
                           <xsl:choose>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '3'">IATA</xsl:when>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '9'">EAN</xsl:when>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '12'">UIC</xsl:when>
                              <xsl:when test="S_TDT/C_C040/D_3055 = '16'">DUNS</xsl:when>
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
                     <xsl:element name="ShipmentIdentifier">
                        <xsl:if test="S_TDT/C_C401[D_8457 = 'ZZZ' and D_8459 = 'ZZZ']/D_7130 != ''">
                           <xsl:attribute name="domain">
                              <xsl:value-of select="S_TDT/C_C401[D_8457 = 'ZZZ' and D_8459 = 'ZZZ']/D_7130"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="S_TDT/C_C222/D_8212 != '' or G_SG7/S_LOC[D_3227='92']/C_C517/D_3224 != ''">
                           <xsl:attribute name="trackingURL">
                              <xsl:value-of select="concat(S_TDT/C_C222/D_8212,G_SG7/S_LOC[D_3227='92']/C_C517/D_3224)"/>
                           </xsl:attribute>
                        </xsl:if>
                           <xsl:if test="G_SG7/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
                              <xsl:attribute name="trackingNumberDate">
                                 <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="dateTime">
                                       <xsl:value-of select="G_SG7/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="dateTimeFormat">
                                       <xsl:value-of select="G_SG7/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
                                    </xsl:with-param>
                                 </xsl:call-template>
                              </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="S_TDT/D_8028"/>
                     </xsl:element>
                     <xsl:variable name="routeMeans" select="normalize-space(S_TDT/C_C228/D_8178)"/>
                     <xsl:if test="S_TDT/C_C228/D_8179 = '6' or S_TDT/C_C228/D_8179 = '11' or S_TDT/C_C228/D_8179 = '23' or S_TDT/C_C228/D_8179 = '31' or S_TDT/C_C220[D_8067 = 'ZZZ']/D_8066 != '' or (G_SG7[S_LOC/D_3227 = 'ZZZ' and S_LOC/C_C517/D_3055 != ''])">
                        <xsl:element name="TransportInformation">
                           <xsl:if test="S_TDT/C_C228/D_8179 = '6' or S_TDT/C_C228/D_8179 = '11' or S_TDT/C_C228/D_8179 = '23' or S_TDT/C_C228/D_8179 = '31'">
                              <xsl:element name="Route">
                                 <xsl:attribute name="method">
                                    <xsl:choose>
                                       <xsl:when test="S_TDT/C_C228/D_8179 = '6'">air</xsl:when>
                                       <xsl:when test="S_TDT/C_C228/D_8179 = '11'">ship</xsl:when>
                                       <xsl:when test="S_TDT/C_C228/D_8179 = '23'">rail</xsl:when>
                                       <xsl:when test="S_TDT/C_C228/D_8179 = '31'">motor</xsl:when>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <xsl:if test="$routeMeans != ''">
                                    <xsl:attribute name="means" select="$routeMeans"/>
                                 </xsl:if>
                              </xsl:element>
                           </xsl:if>
                           <xsl:if test="S_TDT/C_C220[D_8067 = 'ZZZ']/D_8066 != ''">
                              <xsl:element name="ShippingContractNumber">
                                 <xsl:value-of select="S_TDT/C_C220[D_8067 = 'ZZZ']/D_8066"/>
                              </xsl:element>
                           </xsl:if>
                           <xsl:for-each select="G_SG7[S_LOC/D_3227 = 'ZZZ' and S_LOC/C_C517/D_3224 != '']">
                              <xsl:element name="ShippingInstructions">
                                 <xsl:element name="Description">
                                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    <xsl:value-of select="concat('', S_LOC/C_C517/D_3224, S_LOC/C_C519/D_3222, S_LOC/C_C553/D_3232)"/>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:for-each>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:for-each>
               <xsl:choose>
                  <xsl:when test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
                     <xsl:element name="ShipNoticePortion">
                        <xsl:element name="OrderReference">
                           <xsl:attribute name="orderID">
                              <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
                           </xsl:attribute>
                           <xsl:if test="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4' or D_2005 = '171']/D_2380 != ''">
                              <xsl:attribute name="orderDate">
                                 <xsl:choose>
                                    <xsl:when test="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
                                       <xsl:call-template name="convertToAribaDate">
                                          <xsl:with-param name="dateTime">
                                             <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="dateTimeFormat">
                                             <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
                                          </xsl:with-param>
                                       </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:call-template name="convertToAribaDate">
                                          <xsl:with-param name="dateTime">
                                             <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
                                          </xsl:with-param>
                                          <xsl:with-param name="dateTimeFormat">
                                             <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
                                          </xsl:with-param>
                                       </xsl:call-template>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:element name="DocumentReference">
                              <xsl:attribute name="payloadID">
                                 <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'IL']/D_1154"/>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:element>
                        <xsl:if test="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">
                           <xsl:element name="MasterAgreementIDInfo">
                              <xsl:attribute name="agreementID">
                                 <xsl:value-of select="M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1154"/>
                              </xsl:attribute>
                              <xsl:if test="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126' or D_2005 = '171']/D_2380 != ''">
                                 <xsl:attribute name="agreementDate">
                                    <xsl:choose>
                                       <xsl:when test="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="dateTime">
                                                <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380"/>
                                             </xsl:with-param>
                                             <xsl:with-param name="dateTimeFormat">
                                                <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2379"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="dateTime">
                                                <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
                                             </xsl:with-param>
                                             <xsl:with-param name="dateTimeFormat">
                                                <xsl:value-of select="M_DESADV/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:attribute name="agreementType">scheduling_agreement</xsl:attribute>
                           </xsl:element>
                        </xsl:if>
                        <xsl:for-each select="M_DESADV/G_SG10">
                           <!--[S_CPS/D_7164 = '1']-->
                           <xsl:for-each select="G_SG15">
                              <xsl:apply-templates select="."/>
                           </xsl:for-each>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:for-each select="M_DESADV/G_SG10[S_CPS/D_7164 = '1']">
                        <xsl:for-each-group select="G_SG15" group-by="G_SG16/S_RFF/C_C506[D_1153 = 'ON']/D_1154">
                           <xsl:element name="ShipNoticePortion">
                              <xsl:element name="OrderReference">
                                 <xsl:attribute name="orderID">
                                    <xsl:value-of select="G_SG16/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
                                 </xsl:attribute>
                                 <xsl:choose>
                                    <xsl:when test="G_SG16[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
                                       <xsl:attribute name="orderDate">
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="dateTime">
                                                <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
                                             </xsl:with-param>
                                             <xsl:with-param name="dateTimeFormat">
                                                <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="G_SG16[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
                                       <xsl:attribute name="orderDate">
                                          <xsl:call-template name="convertToAribaDate">
                                             <xsl:with-param name="dateTime">
                                                <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
                                             </xsl:with-param>
                                             <xsl:with-param name="dateTimeFormat">
                                                <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
                                             </xsl:with-param>
                                          </xsl:call-template>
                                       </xsl:attribute>
                                    </xsl:when>
                                 </xsl:choose>
                                 <xsl:element name="DocumentReference">
                                    <xsl:attribute name="payloadID">
                                       <xsl:value-of select="G_SG16/S_RFF/C_C506[D_1153 = 'IL']/D_1154"/>
                                    </xsl:attribute>
                                 </xsl:element>
                              </xsl:element>
                              <xsl:if test="G_SG16/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">
                                 <xsl:element name="MasterAgreementIDInfo">
                                    <xsl:attribute name="agreementID">
                                       <xsl:value-of select="G_SG16/S_RFF/C_C506[D_1153 = 'CT']/D_1154"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                       <xsl:when test="G_SG16[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
                                          <xsl:attribute name="agreementDate">
                                             <xsl:call-template name="convertToAribaDate">
                                                <xsl:with-param name="dateTime">
                                                   <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="dateTimeFormat">
                                                   <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2379"/>
                                                </xsl:with-param>
                                             </xsl:call-template>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="G_SG16[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
                                          <xsl:attribute name="agreementDate">
                                             <xsl:call-template name="convertToAribaDate">
                                                <xsl:with-param name="dateTime">
                                                   <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="dateTimeFormat">
                                                   <xsl:value-of select="G_SG16[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
                                                </xsl:with-param>
                                             </xsl:call-template>
                                          </xsl:attribute>
                                       </xsl:when>
                                    </xsl:choose>
                                    <xsl:attribute name="agreementType">scheduling_agreement</xsl:attribute>
                                 </xsl:element>
                              </xsl:if>
                              <xsl:for-each select="current-group()">
                                 <xsl:apply-templates select="."/>
                              </xsl:for-each>
                           </xsl:element>
                        </xsl:for-each-group>
                     </xsl:for-each>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:element>
         </xsl:element>
      </xsl:element>
   </xsl:template>
   <xsl:template match="G_SG15">
      <xsl:element name="ShipNoticeItem">
         <xsl:variable name="itemQty" select="S_QTY/C_C186[D_6063 = '12']/D_6060"/>
         <xsl:variable name="itemUOM">
            <xsl:choose>
               <xsl:when test="S_QTY/C_C186[D_6063 = '12']/D_6411 != ''">
                  <xsl:value-of select="S_QTY/C_C186[D_6063 = '12']/D_6411"/>
               </xsl:when>
               <xsl:otherwise>EA</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:attribute name="quantity">
            <xsl:value-of select="$itemQty"/>
         </xsl:attribute>
         <xsl:attribute name="lineNumber">
            <xsl:value-of select="S_LIN/C_C212[D_7143 = 'PL']/D_7140"/>
         </xsl:attribute>
         <xsl:choose>
            <xsl:when test="G_SG16/S_RFF/C_C506[D_1153 = 'LI' and D_4000 = 'item']/D_1154 != ''">
               <xsl:attribute name="parentLineNumber">
                  <xsl:value-of select="G_SG16/S_RFF/C_C506[D_1153 = 'LI' and D_4000 = 'item']/D_1154"/>
               </xsl:attribute>
            </xsl:when>
            <xsl:when test="S_LIN/C_C829[D_5495 = '1']/D_1082 != ''">
               <xsl:attribute name="parentLineNumber">
                  <xsl:value-of select="S_LIN/C_C829[D_5495 = '1']/D_1082"/>
               </xsl:attribute>
            </xsl:when>
         </xsl:choose>
         <xsl:if test="S_LIN/D_1082 != ''">
            <xsl:attribute name="shipNoticeLineNumber">
               <xsl:value-of select="S_LIN/D_1082"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="G_SG16/S_RFF/C_C506[D_1153 = 'LI']/D_4000 = 'item' or G_SG16/S_RFF/C_C506[D_1153 = 'LI']/D_4000 = 'composite' or S_LIN/C_C829[D_5495 = '1']/D_1082 != ''">
            <xsl:attribute name="itemType">
               <xsl:choose>
                  <xsl:when test="G_SG16/S_RFF/C_C506[D_1153 = 'LI']/D_4000 = 'item'">item</xsl:when>
                  <xsl:when test="G_SG16/S_RFF/C_C506[D_1153 = 'LI']/D_4000 = 'composite'">composite</xsl:when>
                  <xsl:when test="S_LIN/C_C829[D_5495 = '1']/D_1082 != ''">item</xsl:when>
               </xsl:choose>
            </xsl:attribute>
         </xsl:if>
         <!-- ItemID -->
         <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'VN'] != '' or S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'VS'] != '' or S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'BP'] != ''">
            <xsl:element name="ItemID">
               <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'VN'] != ''">
                  <xsl:element name="SupplierPartID">
                     <xsl:value-of select="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'VN']"/>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'VS'] != ''">
                  <xsl:element name="SupplierPartAuxiliaryID">
                     <xsl:value-of select="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'VS']"/>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'BP'] != ''">
                  <xsl:element name="BuyerPartID">
                     <xsl:value-of select="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'BP']"/>
                  </xsl:element>
               </xsl:if>
            </xsl:element>
         </xsl:if>
         <xsl:variable name="desc">
            <xsl:for-each select="S_IMD[./D_7077 = 'F']">
               <xsl:value-of select="concat(C_C273/D_7008_1, C_C273/D_7008_2)"/>
            </xsl:for-each>
         </xsl:variable>
         <xsl:variable name="descLang">
            <xsl:for-each select="S_IMD[./D_7077 = 'F']">
               <xsl:value-of select="C_C273/D_3453"/>
            </xsl:for-each>
         </xsl:variable>
         <xsl:variable name="shortName">
            <xsl:for-each select="S_IMD[./D_7077 = 'E']">
               <xsl:value-of select="concat(C_C273/D_7008_1, C_C273/D_7008_2)"/>
            </xsl:for-each>
         </xsl:variable>
         <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'EN'] != '' or S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'MF'] != '' or S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'ZZZ'] != '' or S_MOA/C_C516[D_5025 = '146']/D_5004 != '' or $desc != ''">
            <xsl:element name="ShipNoticeItemDetail">
               <xsl:if test="S_MOA/C_C516[D_5025 = '146']/D_5004 != ''">
                  <xsl:element name="UnitPrice">
                     <xsl:element name="Money">
                        <xsl:attribute name="currency">
                           <xsl:value-of select="S_MOA/C_C516[D_5025 = '146']/D_6345"/>
                        </xsl:attribute>
                        <xsl:value-of select="S_MOA/C_C516[D_5025 = '146']/D_5004"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$desc != ''">
                  <xsl:element name="Description">
                     <xsl:attribute name="xml:lang">
                        <xsl:choose>
                           <xsl:when test="$descLang != ''">
                              <xsl:value-of select="substring($descLang, 1, 2)"/>
                           </xsl:when>
                           <xsl:otherwise>en</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:value-of select="$desc"/>
                     <xsl:if test="$shortName != ''">
                        <xsl:element name="ShortName">
                           <xsl:value-of select="$shortName"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:if>
               <xsl:element name="UnitOfMeasure">
                  <xsl:value-of select="$itemUOM"/>
               </xsl:element>
               <xsl:for-each select="S_PIA[D_4347 = '1']//.[D_7143 = 'CC']">
                  <xsl:element name="Classification">
                     <xsl:attribute name="domain">
                        <xsl:text>UNSPSC</xsl:text>
                     </xsl:attribute>
                     <xsl:attribute name="code">
                        <xsl:value-of select="D_7140"/>
                     </xsl:attribute>
                  </xsl:element>
               </xsl:for-each>
               <!-- IG-18044 -->
               <xsl:for-each select="S_IMD[./D_7077 = 'B'][./C_C273/D_7009 = 'ACA']">
                  <xsl:element name="Classification">
                     <xsl:attribute name="domain">
                        <xsl:choose>
                           <xsl:when test="C_C273/D_7008_1 != ''">
                              <xsl:value-of select="C_C273/D_7008_1"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>NotAvailable</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>                        
                     </xsl:attribute>
                     <xsl:attribute name="code">
                        <xsl:value-of select="C_C273/D_7008_2"/>
                     </xsl:attribute>
                  </xsl:element>
               </xsl:for-each>
               <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'MF'] != ''">
                  <xsl:element name="ManufacturerPartID">
                     <xsl:value-of select="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'MF']"/>
                  </xsl:element>
               </xsl:if>
               <!-- IG-18044 -->
               <xsl:if test="exists(./S_GIR[D_7297 = '1'][./child::*[starts-with(name(), 'C_C206')]/D_7405='AN'])">
                  <xsl:element name="ManufacturerName">
                     <xsl:value-of select="./S_GIR[D_7297 = '1'][./child::*[starts-with(name(), 'C_C206')]/D_7405='AN']//D_7402"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="S_MEA[D_6311 = 'AAE']">
                  <xsl:variable name="mCode" select="C_C502/D_6313"/>
                  <xsl:if test="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode != ''">
                     <xsl:element name="Dimension">
                        <xsl:attribute name="quantity">
                           <xsl:value-of select="C_C174/D_6314"/>
                        </xsl:attribute>
                        <xsl:attribute name="type">
                           <xsl:value-of select="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode"/>
                        </xsl:attribute>
                        <xsl:element name="UnitOfMeasure">
                           <xsl:value-of select="C_C174/D_6411"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
               <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'EN'] != '' or S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'ZZZ'] != '' or exists(S_IMD[D_7077 = 'B'][D_7081 !=''][C_C273/D_7008_1 != ''])">
                  <xsl:element name="ItemDetailIndustry">
                     <xsl:element name="ItemDetailRetail">
                        <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'EN'] != ''">
                           <xsl:element name="EANID">
                              <xsl:value-of select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'EN']"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'ZZZ'] != ''">
                           <xsl:element name="EuropeanWasteCatalogID">
                              <xsl:value-of select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'ZZZ']"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:for-each select="S_IMD[D_7077 = 'B'][D_7081 !=''][C_C273/D_7008_1 != '']">
                           <xsl:variable name="charCode" select="D_7081"/>
                           <xsl:variable name="charValue" select="normalize-space($lookups/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[EDIFACTCode = $charCode]/CXMLCode)"/>
                           <xsl:if test="$charValue != ''">
                              <xsl:element name="Characteristic">
                                 <xsl:attribute name="domain" select="$charValue"/>
                                 <xsl:attribute name="value" select="C_C273/D_7008_1"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
            </xsl:element>
         </xsl:if>
         <xsl:element name="UnitOfMeasure">
            <xsl:value-of select="$itemUOM"/>
         </xsl:element>
         <!-- Packaging -->
         <xsl:variable name="maxPackLevel" as="xs:double">
            <xsl:call-template name="findMaxPackLevelCode">
               <xsl:with-param name="currCPSParent" select="../S_CPS/D_7166"/>
               <xsl:with-param name="currCPS" select="../S_CPS/D_7164"/>
            </xsl:call-template>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="exists(G_SG20[S_PCI/D_4233 = '24' or S_PCI/D_4233 = '30'])">
               <!--4.1 A, B,C and 4.2 F -->
               <xsl:choose>
                  <xsl:when test="exists(G_SG20/G_SG21/S_GIN)">
                     <!--4.1 A, B,C and 4.2 F -->
                     <!-- Map Sequence 4.1 -->
                     <xsl:variable name="parentType">
                        <xsl:choose>
                           <xsl:when test="exists(../G_SG11/G_SG13/G_SG14/S_GIN)">411</xsl:when>
                           <xsl:otherwise>412</xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="isSinglePacklvl">
                        <xsl:choose>
                           <xsl:when test="$maxPackLevel =1">
                              <xsl:value-of select="'true'"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="currCPSParentID" select="../S_CPS/D_7166"/>
                     <xsl:variable name="currCPSID" select="../S_CPS/D_7164"/>
                     <xsl:variable name="parentCPS">
                        <xsl:choose>
                           <xsl:when test="$parentType!=412">
                              <xsl:value-of select="//G_SG10[S_CPS/D_7164 = $currCPSID]"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="//G_SG10[S_CPS/D_7164 = $currCPSParentID]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="shipSerialCode">
                        <xsl:choose>
                           <xsl:when test="$currCPSParentID != 1 and $parentType='412'">
                              <xsl:value-of select="//G_SG10[S_CPS/D_7164 = $currCPSParentID]/G_SG11/G_SG13/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208_1/D_7402_1"/>
                           </xsl:when>
                           <xsl:when test="../G_SG11/G_SG13/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208_1/D_7402_1">
                              <xsl:value-of select="../G_SG11/G_SG13/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208_1/D_7402_1"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:choose>
                        <!-- Map Sequence 4.1.1 -->
                        <xsl:when test="exists(../G_SG11/G_SG13/G_SG14/S_GIN)">
                           <xsl:call-template name="Packaging">
                              <xsl:with-param name="CPSGrp" select=".."/>
                              <xsl:with-param name="packLevelCode" select="$maxPackLevel - 1"/>
                              <xsl:with-param name="maxLevel" select="$maxPackLevel"/>
                           </xsl:call-template>
                        </xsl:when>
                        <!-- Map Sequence 4.1.2 and 4.1.0 -->
                        <xsl:otherwise>
                           <xsl:call-template name="Packaging">
                              <xsl:with-param name="CPSGrp" select=".."/>
                              <xsl:with-param name="packLevelCode" select="$maxPackLevel - 1"/>
                              <xsl:with-param name="maxLevel" select="$maxPackLevel"/>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:variable name="packLevel">
                        <xsl:choose>
                           <xsl:when test="not(../S_CPS/D_7164 &gt; 1)">0</xsl:when>
                           <xsl:when test="$parentType = 412">
                              <xsl:value-of select="$maxPackLevel - 1"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$maxPackLevel"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="packIDCode">
                        <xsl:choose>
                           <xsl:when test="$parentType = 412">
                              <xsl:value-of select="../../G_SG11/S_PAC/C_C202/D_7065"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:for-each select="G_SG20">
                        <xsl:call-template name="mapSequence41">
                           <xsl:with-param name="SG20GRP" select="."/>
                           <xsl:with-param name="parentType" select="$parentType"/>
                           <xsl:with-param name="packLevelCode" select="$packLevel"/>
                           <xsl:with-param name="shipSerialCode" select="$shipSerialCode"/>
                           <xsl:with-param name="maxPackLevel" select="$packLevel"/>
                           <xsl:with-param name="currCPSGrp" select="../.."/>
                           <xsl:with-param name="packTypeIdCode" select="../../G_SG11/S_PAC/C_C202/D_7065"/>
                           <xsl:with-param name="isSinglePacklvl" select="$isSinglePacklvl"/>
                        </xsl:call-template>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:for-each select="G_SG20[S_PCI/D_4233 = '24' or S_PCI/D_4233 = '30']">
                        <xsl:call-template name="createPackaging">
                           <xsl:with-param name="pkgGrp" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <!-- Map Sequene 4.2 (A to E) -->
               <xsl:if test="../S_CPS/D_7164 &gt; 1">
                  <xsl:choose>
                     <xsl:when test="exists(../G_SG11/G_SG13/G_SG14/S_GIN)">
                        <xsl:variable name="packTypeIdCode" select="(../G_SG11[exists(S_PAC)][(exists(G_SG13))]/S_PAC/C_C202/D_7065)[1]"/>
                        <xsl:variable name="shipSerialCode">
                           <xsl:if test="(../G_SG11[exists(S_PAC)]/G_SG13[S_PCI/D_4233 = '30']/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208_1/D_7402_1)[1] != ''">
                              <xsl:value-of select="(../G_SG11[exists(S_PAC)]/G_SG13[S_PCI/D_4233 = '30']/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208_1/D_7402_1)[1]"/>
                           </xsl:if>
                        </xsl:variable>
                        <xsl:variable name="packLvlCode" select="1"/>
                        <xsl:variable name="isSinglePacklvl">
                           <xsl:choose>
                              <xsl:when test="$maxPackLevel - $packLvlCode =1">
                                 <xsl:value-of select="'true'"/>
                              </xsl:when>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="mapSequence42">
                           <xsl:with-param name="currCPSGrp" select="../."/>
                           <xsl:with-param name="itemQty" select="$itemQty"/>
                           <xsl:with-param name="itemUOM" select="$itemUOM"/>
                           <xsl:with-param name="packLevelCode" select="$maxPackLevel - 1"> </xsl:with-param>
                           <xsl:with-param name="maxLevel" select="$maxPackLevel - 1"/>
                           <xsl:with-param name="isSinglePacklvl" select="$isSinglePacklvl"/>
                        </xsl:call-template>
                     </xsl:when>
                  </xsl:choose>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
         <!-- Batch and SupplierBatchID -->
         <xsl:for-each select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'NB']">
            <xsl:for-each select="../../../G_SG20[S_PCI/D_4233 = '10'][exists(S_DTM) or exists(S_QTY)]"> 
               <xsl:element name="Batch">
                  <xsl:if test="S_DTM/C_C507[D_2005 = '36'][D_2379 = '102']/D_2380 != ''">
                     <xsl:attribute name="expirationDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="S_DTM/C_C507[D_2005 = '36']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat" select="'102'"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_DTM/C_C507[D_2005 = '94'][D_2379 = '102']/D_2380 != ''">
                     <xsl:attribute name="productionDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="S_DTM/C_C507[D_2005 = '94']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat" select="'102'"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_DTM/C_C507[D_2005 = '351'][D_2379 = '102']/D_2380 != ''">
                     <xsl:attribute name="inspectionDate">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="S_DTM/C_C507[D_2005 = '351']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat" select="'102'"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:if>
                  
                  <xsl:if test="S_QTY/C_C186[D_6063 = '12']/D_6060 != ''">
                     <xsl:attribute name="batchQuantity" select="S_QTY/C_C186[D_6063 = '12']/D_6060"/>
                  </xsl:if>
                  
                  <!-- BuyerBatchID -->
                     <xsl:choose>
                        <!-- check bacth ID at C_C208_1 --> 
                        <xsl:when test="G_SG21/S_GIN[D_7405='BX'][C_C208_1/D_7402_2 = '92'][C_C208_1/D_7402_1 != '']">
                           <xsl:element name="BuyerBatchID">
                              <xsl:value-of select="G_SG21/S_GIN[D_7405='BX'][C_C208_1/D_7402_2 = '92']/C_C208_1/D_7402_1"/>
                           </xsl:element>
                        </xsl:when>
                        <!-- check bacth ID at C_C208_2 -->
                        <xsl:when test="G_SG21/S_GIN[D_7405='BX'][C_C208_2/D_7402_2 = '92'][C_C208_2/D_7402_1 != '']">
                           <xsl:element name="BuyerBatchID">
                              <xsl:value-of select="G_SG21/S_GIN[D_7405='BX'][C_C208_2/D_7402_2 = '92']/C_C208_2/D_7402_1"/>
                           </xsl:element>
                        </xsl:when>
                     </xsl:choose>  
                  <!-- SupplierBatchID -->
                  <xsl:choose>
                     <!-- check Supplier BatchID at C_C208_1 -->
                     <xsl:when test="G_SG21/S_GIN[D_7405='BX'][C_C208_1/D_7402_2 = '91'][C_C208_1/D_7402_1 != '']">
                        <xsl:element name="SupplierBatchID">
                           <xsl:value-of select="G_SG21/S_GIN[D_7405='BX'][C_C208_1/D_7402_2 = '91']/C_C208_1/D_7402_1"/>
                        </xsl:element>
                     </xsl:when>
                     <!-- check Supplier BatchID at C_C208_2 -->
                     <xsl:when test="G_SG21/S_GIN[D_7405='BX'][C_C208_2/D_7402_2 = '91'][C_C208_2/D_7402_1 != '']">
                        <xsl:element name="SupplierBatchID">
                           <xsl:value-of select="G_SG21/S_GIN[D_7405='BX'][C_C208_2/D_7402_2 = '91']/C_C208_2/D_7402_1"/>
                        </xsl:element>
                     </xsl:when>
                     <!-- if C_C208_1/D_7402_2 = null and C_C208_2 not exist, then it is supplierBatchID. no BuyerBatchID sent in this scenario-->
                     <xsl:when test="G_SG21/S_GIN[D_7405='BX'][not(exists(C_C208_1/D_7402_2))][not(exists(C_C208_2))][C_C208_1/D_7402_1 != '']">
                        <xsl:element name="SupplierBatchID">
                           <xsl:value-of select="G_SG21/S_GIN[D_7405='BX'][not(exists(C_C208_1/D_7402_2))][not(exists(C_C208_2))]/C_C208_1/D_7402_1"/>
                        </xsl:element>
                     </xsl:when>
                  </xsl:choose>
                  
               </xsl:element>
               
            </xsl:for-each>
         </xsl:for-each>
         <xsl:for-each select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'NB']">
            <xsl:element name="SupplierBatchID">
               <xsl:value-of select="."/>
            </xsl:element>
         </xsl:for-each>
         <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'SN'] != ''">
            <xsl:element name="AssetInfo">
               <xsl:attribute name="serialNumber">
                  <xsl:value-of select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'SN']"/>
               </xsl:attribute>
            </xsl:element>
         </xsl:if>
         <xsl:for-each select="S_GIR[D_7297 = '1'][//D_7405 = 'AP' or //D_7405 = 'BN']">
            <xsl:element name="AssetInfo">
               <xsl:choose>
                  <xsl:when test="C_C206_1[D_7405 = 'AP']/D_7402 != '' and C_C206_2[D_7405 = 'BN']/D_7402 != ''">
                     <xsl:attribute name="tagNumber">
                        <xsl:value-of select="C_C206_1[D_7405 = 'AP']/D_7402"/>
                     </xsl:attribute>
                     <xsl:attribute name="serialNumber">
                        <xsl:value-of select="C_C206_2[D_7405 = 'BN']/D_7402"/>
                     </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="C_C206_1[D_7405 = 'AP']/D_7402 != ''">
                     <xsl:attribute name="tagNumber">
                        <xsl:value-of select="C_C206_1[D_7405 = 'AP']/D_7402"/>
                     </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="C_C206_1[D_7405 = 'BN']/D_7402 != ''">
                     <xsl:attribute name="serialNumber">
                        <xsl:value-of select="C_C206_1[D_7405 = 'BN']/D_7402"/>
                     </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="C_C206_2[D_7405 = 'AP']/D_7402 != ''">
                     <xsl:attribute name="tagNumber">
                        <xsl:value-of select="C_C206_2[D_7405 = 'AP']/D_7402"/>
                     </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="C_C206_2[D_7405 = 'BN']/D_7402 != ''">
                     <xsl:attribute name="serialNumber">
                        <xsl:value-of select="C_C206_2[D_7405 = 'BN']/D_7402"/>
                     </xsl:attribute>
                  </xsl:when>
               </xsl:choose>
            </xsl:element>
         </xsl:for-each>
         <xsl:if test="S_QTY/C_C186[D_6063 = '21']/D_6060 != ''">
            <xsl:element name="OrderedQuantity">
               <xsl:attribute name="quantity">
                  <xsl:value-of select="S_QTY/C_C186[D_6063 = '21']/D_6060"/>
               </xsl:attribute>
               <xsl:element name="UnitOfMeasure">
                  <xsl:choose>
                     <xsl:when test="S_QTY/C_C186[D_6063 = '21']/D_6411 != ''">
                        <xsl:value-of select="S_QTY/C_C186[D_6063 = '21']/D_6411"/>
                     </xsl:when>
                     <xsl:otherwise>EA</xsl:otherwise>
                  </xsl:choose>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <!-- ShipNoticeItemIndustry -->
         <xsl:if test="S_DTM/C_C507[D_2005 = '36']/D_2380 != '' or S_DTM/C_C507[D_2005 = '361']/D_2380 != '' or S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'PV'] != '' or S_QTY/C_C186[D_6063 = '192']/D_6060 != ''">
            <xsl:element name="ShipNoticeItemIndustry">
               <xsl:element name="ShipNoticeItemRetail">
                  <xsl:if test="S_DTM/C_C507[D_2005 = '361']/D_2380 != ''">
                     <xsl:element name="BestBeforeDate">
                        <xsl:attribute name="date">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="dateTime">
                                 <xsl:value-of select="S_DTM/C_C507[D_2005 = '361']/D_2380"/>
                              </xsl:with-param>
                              <xsl:with-param name="dateTimeFormat">
                                 <xsl:value-of select="S_DTM/C_C507[D_2005 = '361']/D_2379"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="S_DTM/C_C507[D_2005 = '36']/D_2380 != ''">
                     <xsl:element name="ExpiryDate">
                        <xsl:attribute name="date">
                           <xsl:call-template name="convertToAribaDate">
                              <xsl:with-param name="dateTime">
                                 <xsl:value-of select="S_DTM/C_C507[D_2005 = '36']/D_2380"/>
                              </xsl:with-param>
                              <xsl:with-param name="dateTimeFormat">
                                 <xsl:value-of select="S_DTM/C_C507[D_2005 = '36']/D_2379"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="S_QTY/C_C186[D_6063 = '192']/D_6060 != ''">
                     <xsl:element name="FreeGoodsQuantity">
                        <xsl:attribute name="quantity">
                           <xsl:value-of select="S_QTY/C_C186[D_6063 = '192']/D_6060"/>
                        </xsl:attribute>
                        <xsl:element name="UnitOfMeasure">
                           <xsl:choose>
                              <xsl:when test="S_QTY/C_C186[D_6063 = '192']/D_6411 != ''">
                                 <xsl:value-of select="S_QTY/C_C186[D_6063 = '192']/D_6411"/>
                              </xsl:when>
                              <xsl:otherwise>EA</xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'PV'] != ''">
                     <xsl:element name="PromotionDealID">
                        <xsl:value-of select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'PV']"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <!-- IG-4778 start-->
         <xsl:for-each select="S_FTX[D_4451 = 'AAI'][C_C108/D_4440_1 != '' or C_C108/D_4440_2 != '']">
            <xsl:element name="Comments">
               <xsl:if test="C_C108/D_4440_1 != ''">
                  <xsl:attribute name="type" select="C_C108/D_4440_1"/>
               </xsl:if>
               <xsl:if test="D_3453 != ''">
                  <xsl:attribute name="xml:lang" select="substring(D_3453,1,2)"/>
               </xsl:if>
               <xsl:value-of select="concat(C_C108/D_4440_2,C_C108/D_4440_3,C_C108/D_4440_4,C_C108/D_4440_5)"/>
            </xsl:element>
         </xsl:for-each>
         <!-- IG-4778 end-->
         <xsl:if test="G_SG23/S_QVR/C_C279[D_6063 = '21']/D_6064 != ''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">QuantityVariance</xsl:attribute>
               <xsl:value-of select="G_SG23/S_QVR/C_C279[D_6063 = '21']/D_6064"/>
            </xsl:element>
         </xsl:if>
         <xsl:if test="G_SG23/S_QVR/D_4221 != ''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">DiscrepancyNatureIdentificationCode</xsl:attribute>
               <xsl:value-of select="G_SG23/S_QVR/D_4221"/>
            </xsl:element>
         </xsl:if>
         <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'HS'] != ''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">HarmonizedSystemID</xsl:attribute>
               <xsl:value-of select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'HS']"/>
            </xsl:element>
         </xsl:if>
         <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'GN'] != ''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">ClassOfGoodsNational</xsl:attribute>
               <xsl:value-of select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'GN']"/>
            </xsl:element>
         </xsl:if>
         <xsl:if test="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'UP'] != ''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">ProductIDUPC</xsl:attribute>
               <xsl:value-of select="S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'UP']"/>
            </xsl:element>
         </xsl:if>
         <xsl:for-each select="G_SG16[S_RFF/C_C506/D_1153 = 'ZZZ']">
            <xsl:if test="S_RFF/C_C506/D_1154 != ''">
               <xsl:element name="Extrinsic">
                  <xsl:attribute name="name">
                     <xsl:value-of select="S_RFF/C_C506/D_1154"/>
                  </xsl:attribute>
               </xsl:element>
            </xsl:if>
         </xsl:for-each>
         <xsl:for-each select="S_FTX[D_4451 = 'ZZZ']">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="C_C108/D_4440_1"/>
               </xsl:attribute>
               <xsl:value-of select="normalize-space(concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5))"/>
            </xsl:element>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createPackaging">
      <xsl:param name="pkgGrp"/>
      <xsl:element name="Packaging">
         <xsl:for-each select="$pkgGrp/S_MEA[D_6311 = 'AAE']">
            <xsl:variable name="mCode" select="C_C502/D_6313"/>
            <xsl:if test="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode != ''">
               <xsl:element name="Dimension">
                  <xsl:attribute name="quantity">
                     <xsl:value-of select="C_C174/D_6314"/>
                  </xsl:attribute>
                  <xsl:attribute name="type">
                     <xsl:value-of select="$lookups/Lookups/MeasureCodes/MeasureCode[EDIFACTCode = $mCode]/CXMLCode"/>
                  </xsl:attribute>
                  <xsl:element name="UnitOfMeasure">
                     <xsl:value-of select="C_C174/D_6411"/>
                  </xsl:element>
               </xsl:element>
            </xsl:if>
         </xsl:for-each>
         <Description type="Material" xml:lang="en-US"/>
         <xsl:if test="$pkgGrp/G_SG21/S_GIN[D_7405 = 'BJ']/C_C208_1/D_7402_1 != ''">
            <xsl:element name="ShippingContainerSerialCode">
               <xsl:value-of select="$pkgGrp/G_SG21/S_GIN[D_7405 = 'BJ']/C_C208_1/D_7402_1"/>
            </xsl:element>
         </xsl:if>
         <xsl:call-template name="createShippingMark">
            <xsl:with-param name="PCIGrp" select="$pkgGrp/S_PCI"/>
         </xsl:call-template>
         <xsl:if test="$pkgGrp/S_QTY/C_C186[D_6063 = '12']/D_6060 != ''">
            <xsl:element name="DispatchQuantity">
               <xsl:attribute name="quantity">
                  <xsl:value-of select="$pkgGrp/S_QTY/C_C186[D_6063 = '12']/D_6060"/>
               </xsl:attribute>
               <xsl:element name="UnitOfMeasure">
                  <xsl:choose>
                     <xsl:when test="$pkgGrp/S_QTY/C_C186[D_6063 = '12']/D_6411 != ''">
                        <xsl:value-of select="$pkgGrp/S_QTY/C_C186[D_6063 = '12']/D_6411"/>
                     </xsl:when>
                     <xsl:otherwise>EA</xsl:otherwise>
                  </xsl:choose>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="$pkgGrp/S_DTM/C_C507[D_2005 = '361']/D_2380 != ''">
            <xsl:element name="BestBeforeDate">
               <xsl:attribute name="date">
                  <xsl:call-template name="convertToAribaDate">
                     <xsl:with-param name="dateTime">
                        <xsl:value-of select="$pkgGrp/S_DTM/C_C507[D_2005 = '361']/D_2380"/>
                     </xsl:with-param>
                     <xsl:with-param name="dateTimeFormat">
                        <xsl:value-of select="$pkgGrp/S_DTM/C_C507[D_2005 = '361']/D_2379"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:attribute>
            </xsl:element>
         </xsl:if>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
