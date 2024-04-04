<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
   <!-- Functions -->
   <xsl:template name="MSGLoop">
      <xsl:param name="Desc"/>
      <xsl:param name="StrLen"/>
      <xsl:param name="Pos"/>
      <xsl:param name="CurrentEndPos"/>
      <xsl:variable name="Length" select="$Pos + 264"/>
      <S_MSG>
         <D_933>
            <xsl:value-of select="substring(normalize-space($Desc), $Pos, 264)"/>
         </D_933>
         <xsl:if test="$Pos &gt; 1">
            <D_934>LC</D_934>
         </xsl:if>
      </S_MSG>
      <xsl:if test="$Length &lt; $StrLen">
         <xsl:call-template name="MSGLoop">
            <xsl:with-param name="Pos" select="$Length"/>
            <xsl:with-param name="Desc" select="$Desc"/>
            <xsl:with-param name="StrLen" select="$StrLen"/>
            <xsl:with-param name="CurrentEndPos" select="$Pos"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createREF">
      <xsl:param name="qual"/>
      <xsl:param name="ref02"/>
      <xsl:param name="ref03"/>
      <S_REF>
         <D_128>
            <xsl:value-of select="$qual"/>
         </D_128>
         <xsl:if test="exists($ref02) and $ref02 != ''">
            <D_127>
               <xsl:value-of select="substring($ref02, 1, 30)"/>
            </D_127>
         </xsl:if>
         <xsl:if test="exists($ref03) and $ref03 != ''">
            <D_352>
               <xsl:value-of select="substring($ref03, 1, 80)"/>
            </D_352>
         </xsl:if>
      </S_REF>
      <xsl:if test="(string-length($ref02) &gt; 30) or (string-length($ref03) &gt; 80)">
         <xsl:call-template name="createREF">
            <xsl:with-param name="qual" select="$qual"/>
            <xsl:with-param name="ref02">
               <xsl:choose>
                  <xsl:when test="string-length($ref02) &gt; 30">
                     <xsl:value-of select="substring($ref02, 31)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$ref02"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="ref03">
               <xsl:choose>
                  <xsl:when test="string-length($ref03) &gt; 80">
                     <xsl:value-of select="substring($ref03, 81)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$ref03"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="payloadID">
      <xsl:param name="PayloadID"/>
      <S_REF>
         <D_128>IL</D_128>
         <D_127>payloadID</D_127>
         <D_352>
            <xsl:value-of select="substring(normalize-space($PayloadID), 1, 80)"/>
         </D_352>
      </S_REF>
      <xsl:if test="substring(normalize-space($PayloadID), 81) != ''">
         <xsl:call-template name="payloadID">
            <xsl:with-param name="PayloadID" select="substring(normalize-space($PayloadID), 81)"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="shippingInstructions">
      <xsl:param name="instructions"/>
      <xsl:param name="langCode"/>
      <xsl:variable name="xmlLang">
         <xsl:choose>
            <xsl:when test="string-length(normalize-space($langCode)) &gt; 1">
               <xsl:value-of select="upper-case(substring(normalize-space($langCode), 1, 2))"/>
            </xsl:when>
            <xsl:otherwise>EN</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <S_PID>
         <D_349>F</D_349>
         <D_750>93</D_750>
         <D_352>
            <xsl:value-of select="substring(normalize-space($instructions), 1, 80)"/>
         </D_352>
         <D_819>
            <xsl:value-of select="$xmlLang"/>
         </D_819>
      </S_PID>
      <xsl:if test="substring(normalize-space($instructions), 81) != ''">
         <xsl:call-template name="shippingInstructions">
            <xsl:with-param name="instructions" select="substring(normalize-space($instructions), 81)"/>
            <xsl:with-param name="langCode" select="$xmlLang"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createDTM">
      <xsl:param name="D374_Qual"/>
      <xsl:param name="cXMLDate"/>
      <S_DTM>
         <D_374>
            <xsl:value-of select="$D374_Qual"/>
         </D_374>
         <D_373>
            <xsl:value-of select="replace(substring($cXMLDate, 0, 11), '-', '')"/>
         </D_373>
         <xsl:if test="replace(substring($cXMLDate, 12, 8), ':', '') != ''">
            <D_337>
               <xsl:value-of select="replace(substring($cXMLDate, 12, 8), ':', '')"/>
            </D_337>
         </xsl:if>
         <xsl:variable name="timeZone" select="replace(replace(substring($cXMLDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
         <xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
            <D_623>
               <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
            </D_623>
         </xsl:if>
      </S_DTM>
   </xsl:template>
   <xsl:template name="createN2N3N4_FromAddress">
      <xsl:param name="address"/>
      <xsl:variable name="delTo">
         <DeliverToList>
            <xsl:for-each select="$address/DeliverTo">
               <xsl:if test="normalize-space(.) != ''">
                  <DeliverToItem>
                     <xsl:value-of select="normalize-space(.)"/>
                  </DeliverToItem>
               </xsl:if>
            </xsl:for-each>
         </DeliverToList>
      </xsl:variable>
      <xsl:variable name="delToCount" select="count($delTo/DeliverToList/DeliverToItem)"/>
      <xsl:choose>
         <xsl:when test="$delToCount = 1">      
            <S_N2>
               <D_93>
               	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[1], 1, 60)"/>
               </D_93>
               <xsl:if
               	test="substring($delTo/DeliverToList/DeliverToItem[1], 60, 60) != ''">
               <D_93_2>
               	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[1], 60, 60)"/>
               </D_93_2>
               </xsl:if>
            </S_N2>
            <xsl:if
            	test="substring($delTo/DeliverToList/DeliverToItem[1], 120, 60) != ''">
            <S_N2>
               <D_93>
               	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[1], 120, 60)"/>
               </D_93>
               <xsl:if
               	test="substring($delTo/DeliverToList/DeliverToItem[1], 180, 60) != ''">
               <D_93_2>
               	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[1], 180, 60)"/>
               </D_93_2>
               </xsl:if>
            </S_N2>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="$delToCount = 2">
                  <S_N2>
                     <D_93>
                        <xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[1], 1, 60)"/>
                     </D_93>
                     <D_93_2>
                        <xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[2], 1, 60)"/>
                     </D_93_2>
                  </S_N2>
               </xsl:when>
               <xsl:when test="$delToCount = 3">
                  <S_N2>
                     <D_93>
                     	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[1], 1, 60)"/>
                     </D_93>
                     <D_93_2>
                     	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[2], 1, 60)"/>
                     </D_93_2>
                  </S_N2>
                  <S_N2>
                     <D_93>
                     	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[3], 1, 60)"/>
                     </D_93>
                  </S_N2>
               </xsl:when>
               <xsl:when test="$delToCount &gt; 3">
                  <S_N2>
                     <D_93>
                     	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[1], 1, 60)"/>
                     </D_93>
                     <D_93_2>
                     	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[2], 1, 60)"/>
                     </D_93_2>
                  </S_N2>
                  <S_N2>
                     <D_93>
                     	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[3], 1, 60)"/>
                     </D_93>
                     <D_93_2>
                     	<xsl:value-of select="substring($delTo/DeliverToList/DeliverToItem[4], 1, 60)"/>
                     </D_93_2>
                  </S_N2>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
      
      <!-- Street logic changed -->
      <xsl:variable name="street">
         <StreetList>
            <xsl:for-each select="$address/Street">
               <xsl:if test="normalize-space(.) != ''">
                  <StreetItem>
                     <xsl:value-of select="substring(normalize-space(.), 0, 55)"/>
                  </StreetItem>
               </xsl:if>
            </xsl:for-each>
         </StreetList>
      </xsl:variable>
      <xsl:variable name="streetCount" select="count($street/StreetList/StreetItem)"/>
      <xsl:choose>
         <xsl:when test="$streetCount = 1">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
               </D_166>
            </S_N3>
         </xsl:when>
         <xsl:when test="$streetCount = 2">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$street/StreetList/StreetItem[2]"/>
               </D_166_2>
            </S_N3>
         </xsl:when>
         <xsl:when test="$streetCount = 3">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$street/StreetList/StreetItem[2]"/>
               </D_166_2>
            </S_N3>
            <S_N3>
               <D_166>
                  <xsl:value-of select="$street/StreetList/StreetItem[3]"/>
               </D_166>
            </S_N3>
         </xsl:when>
         <xsl:when test="$streetCount &gt; 3">
            <S_N3>
               <D_166>
                  <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$street/StreetList/StreetItem[2]"/>
               </D_166_2>
            </S_N3>
            <S_N3>
               <D_166>
                  <xsl:value-of select="$street/StreetList/StreetItem[3]"/>
               </D_166>
               <D_166_2>
                  <xsl:value-of select="$street/StreetList/StreetItem[4]"/>
               </D_166_2>
            </S_N3>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="normalize-space($address/City) != '' or normalize-space($address/State) != '' or normalize-space($address/PostalCode) != '' or $address/Country/@isoCountryCode != ''">
         <S_N4>
            <xsl:if test="string-length(normalize-space($address/City)) &gt; 1">
               <D_19>
                  <xsl:value-of select="substring(normalize-space($address/City), 1, 30)"/>
               </D_19>
            </xsl:if>
            <!--xsl:if test="$address/State != ''">					<xsl:variable name="stateCode" select="$address/State"/>					<D_156>						<xsl:choose>							<xsl:when test="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode != ''">								<xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode"/>							</xsl:when>							<xsl:when test="string-length($stateCode) = 2">								<xsl:value-of select="upper-case($stateCode)"/>							</xsl:when>							<xsl:otherwise>ZZ</xsl:otherwise>						</xsl:choose>					</D_156>				</xsl:if-->
            <xsl:variable name="uscaStateCode">
               <xsl:if test="($address/Country/@isoCountryCode = 'US' or $address/Country/@isoCountryCode = 'CA') and normalize-space($address/State) != ''">
                  <xsl:variable name="stCode" select="normalize-space($address/State)"/>
                  <xsl:choose>
                     <xsl:when test="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode != ''">
                        <xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode"/>
                     </xsl:when>
                     <xsl:when test="string-length($stCode) = 2">
                        <xsl:value-of select="upper-case($stCode)"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:if>
            </xsl:variable>
            <xsl:if test="$uscaStateCode != ''">
               <D_156>
                  <xsl:value-of select="$uscaStateCode"/>
               </D_156>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($address/PostalCode)) &gt; 2">
               <D_116>
                  <xsl:value-of select="substring(normalize-space($address/PostalCode), 1, 15)"/>
               </D_116>
            </xsl:if>
            <xsl:if test="$address/Country/@isoCountryCode != ''">
               <D_26>
                  <xsl:value-of select="$address/Country/@isoCountryCode"/>
               </D_26>
            </xsl:if>
            <xsl:if test="$uscaStateCode = '' and normalize-space($address/State) != ''">
               <D_309>SP</D_309>
               <D_310>
                  <xsl:value-of select="normalize-space($address/State)"/>
               </D_310>
            </xsl:if>
         </S_N4>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createN1">
      <xsl:param name="party"/>
      <xsl:param name="mapFOB"/>
      <xsl:param name="isOrder"/>
      <xsl:variable name="role">
         <xsl:choose>
            <xsl:when test="name($party) = 'BillTo'">BT</xsl:when>
            <xsl:when test="name($party) = 'ShipTo'">ST</xsl:when>
            <xsl:when test="name($party) = 'TermsOfDelivery'">DA</xsl:when>
         </xsl:choose>
      </xsl:variable>
      <G_N1>
         <S_N1>
            <D_98>
               <xsl:value-of select="$role"/>
            </D_98>
            <D_93>
               <xsl:choose>
                  <xsl:when test="$party/Address/Name != ''">
                     <xsl:value-of select="substring($party/Address/Name, 1, 60)"/>
                  </xsl:when>
                  <xsl:otherwise>Not Available</xsl:otherwise>
               </xsl:choose>
            </D_93>
            <xsl:variable name="addrDomain" select="$party/Address/@addressIDDomain"/>
            <!-- CG -->
            <xsl:if test="string-length($party/Address/@addressID) &gt; 1">
               <D_66>
                  <xsl:choose>
                     <xsl:when test="$addrDomain = ''">92</xsl:when>
                     <xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code != ''">
                        <xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code"/>
                     </xsl:when>
                     <xsl:otherwise>92</xsl:otherwise>
                  </xsl:choose>
               </D_66>
               <D_67>
                  <xsl:value-of select="substring($party/Address/@addressID, 1, 80)"/>
               </D_67>
            </xsl:if>
         </S_N1>
         <xsl:call-template name="createN2N3N4_FromAddress">
            <xsl:with-param name="address" select="$party/Address/PostalAddress"/>
         </xsl:call-template>
         <xsl:for-each select="$party/IdReference">
            <xsl:variable name="domain" select="./@domain"/>
            <xsl:if test="normalize-space(./@identifier) != ''">
               <xsl:choose>
                  <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code != ''">
                     <S_REF>
                        <D_128>
                           <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code"/>
                        </D_128>
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                        </D_352>
                     </S_REF>
                  </xsl:when>
                  <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code != ''">
                     <S_REF>
                        <D_128>
                           <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code"/>
                        </D_128>
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                        </D_352>
                     </S_REF>
                  </xsl:when>
                  <xsl:otherwise>
                     <S_REF>
                        <D_128>ZZ</D_128>
                        <D_127>
                           <xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
                        </D_127>
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                        </D_352>
                     </S_REF>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </xsl:for-each>
         <xsl:if test="$role = 'BT' and $party/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID'] != ''">
            <S_REF>
               <D_128>
                  <xsl:text>VX</xsl:text>
               </D_128>
               <D_352>
                  <xsl:value-of select="substring(normalize-space($party/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID']), 1, 80)"/>
               </D_352>
            </S_REF>
         </xsl:if>
         <xsl:if test="$role = 'SU' and $party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID'] != ''">
            <S_REF>
               <D_128>
                  <xsl:text>VX</xsl:text>
               </D_128>
               <D_352>
                  <xsl:value-of select="substring(normalize-space($party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']), 1, 80)"/>
               </D_352>
            </S_REF>
         </xsl:if>
         <!-- IG-1958 -->
         <!--xsl:if test="exists($party/ancestor::OrderRequestHeader) and ($party/Address/PostalAddress/@name!='')"-->
         <xsl:if test="$isOrder = 'true' and normalize-space($party/Address/PostalAddress/@name) != ''">
            <S_REF>
               <D_128>
                  <xsl:text>ME</xsl:text>
               </D_128>
               <D_352>
                  <xsl:value-of select="substring(normalize-space($party/Address/PostalAddress/@name), 1, 80)"/>
               </D_352>
            </S_REF>
         </xsl:if>
         <xsl:call-template name="createCom">
            <xsl:with-param name="party" select="$party"/>
         </xsl:call-template>
         <xsl:if test="name($party) = 'ShipTo'">
            <xsl:choose>
               <xsl:when test="$mapFOB = 'true'">
                  <!-- TermsOfDelivery -->
                  <xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value != ''">
                     <xsl:variable name="TOD" select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
                     <S_FOB>
                        <D_146>
                           <xsl:choose>
                              <xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code != ''">
                                 <xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code"/>
                              </xsl:when>
                              <xsl:otherwise>DF</xsl:otherwise>
                           </xsl:choose>
                        </D_146>
                        <xsl:if test="exists(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms)">
                           <xsl:variable name="TTVal" select="normalize-space(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value)"/>
                           <D_334>01</D_334>
                           <D_335>
                              <xsl:choose>
                                 <xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code != ''">
                                    <xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code"/>
                                 </xsl:when>
                                 <!-- IG-31554 -->
                                 <xsl:when test="$isOrder = 'true' and ($Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $TTVal]/X12Code != '')">
                                    <xsl:value-of select="$TTVal"/>
                                 </xsl:when>
                                 <xsl:otherwise>ZZZ</xsl:otherwise>
                              </xsl:choose>
                           </D_335>
                        </xsl:if>
                     </S_FOB>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each select="$party/TransportInformation">
                     <xsl:if test="position() &lt; 13">
                        <xsl:if test="ShippingContractNumber != '' or Route/@method != ''">
                           <S_TD5>
                              <D_133>Z</D_133>
                              <D_66>ZZ</D_66>
                              <xsl:if test="ShippingContractNumber != ''">
                                 <D_67>
                                    <xsl:value-of select="ShippingContractNumber"/>
                                 </D_67>
                              </xsl:if>
                              <xsl:if test="Route/@method != ''">
                                 <D_91>
                                    <xsl:choose>
                                       <xsl:when test="Route/@method = 'air'">A</xsl:when>
                                       <xsl:when test="Route/@method = 'motor'">J</xsl:when>
                                       <xsl:when test="Route/@method = 'rail'">R</xsl:when>
                                       <xsl:when test="Route/@method = 'ship'">S</xsl:when>
                                    </xsl:choose>
                                 </D_91>
                              </xsl:if>
                              <xsl:if test="normalize-space(ShippingInstructions/Description) != ''">
                                 <D_387>
                                    <xsl:value-of select="substring(normalize-space(ShippingInstructions/Description), 1, 35)"/>
                                 </D_387>
                              </xsl:if>
                           </S_TD5>
                        </xsl:if>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="$party/CarrierIdentifier">
                     <xsl:if test="position() &lt; 6">
                        <S_TD4>
                           <D_152>ZZZ</D_152>
                           <D_352>
                              <xsl:value-of select="concat(., '@domain', ./@domain)"/>
                           </D_352>
                        </S_TD4>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
      </G_N1>
   </xsl:template>
   <xsl:template name="createN1_FromPartner">
      <xsl:param name="party"/>
      <xsl:variable name="role">
         <xsl:choose>
            <xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode = $party/Contact/@role]/X12Code != ''">
               <xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $party/Contact/@role]/X12Code"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="$role != ''">
         <G_N1>
            <S_N1>
               <D_98>
                  <xsl:value-of select="$role"/>
               </D_98>
               <D_93>
                  <xsl:choose>
                     <xsl:when test="normalize-space($party/Contact/Name) != ''">
                        <xsl:value-of select="substring(normalize-space($party/Contact/Name), 1, 60)"/>
                     </xsl:when>
                     <xsl:otherwise>Not Available</xsl:otherwise>
                  </xsl:choose>
               </D_93>
               <xsl:if test="string-length(normalize-space($party/Contact/@addressID)) &gt; 1">
                  <D_66>92</D_66>
                  <D_67>
                     <xsl:value-of select="substring(normalize-space($party/Contact/@addressID), 1, 80)"/>
                  </D_67>
               </xsl:if>
            </S_N1>
            <xsl:call-template name="createN2N3N4_FromAddress">
               <xsl:with-param name="address" select="$party/Contact/PostalAddress"/>
            </xsl:call-template>
            <xsl:for-each select="$party/IdReference">
               <xsl:variable name="domain" select="./@domain"/>
               <xsl:choose>
                  <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code != '' and normalize-space(./@identifier) != ''">
                     <S_REF>
                        <D_128>
                           <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code"/>
                        </D_128>
                        <D_127>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 30)"/>
                        </D_127>
                     </S_REF>
                  </xsl:when>
                  <xsl:when test="$domain = 'bankNationalID' and $party/Contact/PostalAddress/Country/@isoCountryCode = 'CA' and ($role = 'O1' or $role = 'RB') and normalize-space(./@identifier) != ''">
                     <S_REF>
                        <D_128>04</D_128>
                        <D_127>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 30)"/>
                        </D_127>
                     </S_REF>
                  </xsl:when>
               </xsl:choose>
            </xsl:for-each>
            <xsl:if test="$party/PCard/@number != ''">
               <S_REF>
                  <D_128>PSM</D_128>
                  <D_127>
                     <xsl:value-of select="substring(normalize-space($party/PCard/@number), 1, 30)"/>
                  </D_127>
                  <xsl:if test="$party/PCard/@name != ''">
                     <D_352>
                        <xsl:value-of select="substring(normalize-space($party/PCard/@name), 1, 80)"/>
                     </D_352>
                  </xsl:if>
               </S_REF>
            </xsl:if>
            <xsl:call-template name="createCom">
               <xsl:with-param name="party" select="$party"/>
            </xsl:call-template>
            <!--Card expiration Date -->
            <xsl:if test="$party/PCard/@expiration != ''">
               <S_DTM>
                  <D_374>036</D_374>
                  <D_373>
                     <xsl:value-of select="replace(substring($party/PCard/@expiration, 1, 10), '-', '')"/>
                  </D_373>
               </S_DTM>
            </xsl:if>
         </G_N1>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createContact">
      <xsl:param name="party"/>
      <xsl:param name="sprole"/>
      <xsl:param name="isOrder"/>
      <xsl:variable name="role">
         <xsl:choose>
            <xsl:when test="$sprole = 'yes' and $party/@role = 'locationTo'">ST</xsl:when>
            <xsl:when test="$sprole = 'yes' and $party/@role = 'locationFrom'">SU</xsl:when>
            <xsl:when test="$sprole = 'yes' and $party/@role = 'BuyerPlannerCode'">MI</xsl:when>
            <xsl:when test="$sprole = 'QN' and $party/@role = 'buyerParty'">BY</xsl:when>
            <xsl:when test="$sprole = 'QN' and $party/@role = 'sellerParty'">SU</xsl:when>
            <xsl:when test="$sprole = 'QN' and $party/@role = 'senderParty'">FR</xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code != ''">
                     <xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code"/>
                  </xsl:when>
                  <xsl:otherwise>ZZ</xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <G_N1>
         <S_N1>
            <D_98>
               <xsl:value-of select="$role"/>
            </D_98>
            <D_93>
               <xsl:choose>
                  <xsl:when test="$party/Name != ''">
                     <xsl:value-of select="substring(normalize-space($party/Name), 1, 60)"/>
                  </xsl:when>
                  <xsl:otherwise>Not Available</xsl:otherwise>
               </xsl:choose>
            </D_93>
            <xsl:variable name="addrDomain" select="$party/@addressIDDomain"/>
            <!-- CG -->
            <xsl:if test="string-length($party/@addressID) &gt; 1">
               <D_66>
                  <xsl:choose>
                     <xsl:when test="$addrDomain = ''">92</xsl:when>
                     <xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code != ''">
                        <xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code"/>
                     </xsl:when>
                     <xsl:otherwise>92</xsl:otherwise>
                  </xsl:choose>
               </D_66>
               <D_67>
                  <xsl:value-of select="substring(normalize-space($party/@addressID), 1, 80)"/>
               </D_67>
            </xsl:if>
         </S_N1>
         <!-- DeliverTO logic changed -->
         <xsl:variable name="delTo">
            <DeliverToList>
               <xsl:for-each select="$party/PostalAddress/DeliverTo">
                  <xsl:if test="normalize-space(.) != ''">
                     <DeliverToItem>
                        <xsl:value-of select="substring(normalize-space(.), 0, 60)"/>
                     </DeliverToItem>
                  </xsl:if>
               </xsl:for-each>
            </DeliverToList>
         </xsl:variable>
         <xsl:variable name="delToCount" select="count($delTo/DeliverToList/DeliverToItem)"/>
         
         <xsl:choose>
            <xsl:when test="$delToCount = 1">            
               <S_N2>
                  <D_93>
                     <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 1, 60)"/>
                  </D_93>
                  <xsl:if
                     test="substring(normalize-space($party/PostalAddress/DeliverTo), 60, 60) != ''">
                     <D_93_2>
                        <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 60, 60)"/>
                     </D_93_2>
                  </xsl:if>
               </S_N2>
               <xsl:if
                  test="substring(normalize-space($party/PostalAddress/DeliverTo), 120, 60) != ''">
                  <S_N2>
                     <D_93>
                        <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 120, 60)"/>
                     </D_93>
                     <xsl:if
                        test="substring(normalize-space($party/PostalAddress/DeliverTo), 180, 60) != ''">
                        <D_93_2>
                           <xsl:value-of select="substring($party/PostalAddress/DeliverTo, 180, 60)"/>
                        </D_93_2>
                     </xsl:if>
                  </S_N2>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="$delToCount = 1">
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
                        </D_93>
                     </S_N2>
                  </xsl:when>
                  <xsl:when test="$delToCount = 2">
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
                        </D_93>
                        <D_93_2>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
                        </D_93_2>
                     </S_N2>
                  </xsl:when>
                  <xsl:when test="$delToCount = 3">
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
                        </D_93>
                        <D_93_2>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
                        </D_93_2>
                     </S_N2>
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
                        </D_93>
                     </S_N2>
                  </xsl:when>
                  <xsl:when test="$delToCount &gt; 3">
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
                        </D_93>
                        <D_93_2>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
                        </D_93_2>
                     </S_N2>
                     <S_N2>
                        <D_93>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
                        </D_93>
                        <D_93_2>
                           <xsl:value-of select="$delTo/DeliverToList/DeliverToItem[4]"/>
                        </D_93_2>
                     </S_N2>
                  </xsl:when>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
         
         <!-- Street logic changed -->
         <xsl:variable name="street">
            <StreetList>
               <xsl:for-each select="$party/PostalAddress/Street">
                  <xsl:if test="normalize-space(.) != ''">
                     <StreetItem>
                        <xsl:value-of select="substring(normalize-space(.), 0, 55)"/>
                     </StreetItem>
                  </xsl:if>
               </xsl:for-each>
            </StreetList>
         </xsl:variable>
         <xsl:variable name="streetCount" select="count($street/StreetList/StreetItem)"/>
         <xsl:choose>
            <xsl:when test="$streetCount = 1">
               <S_N3>
                  <D_166>
                     <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
                  </D_166>
               </S_N3>
            </xsl:when>
            <xsl:when test="$streetCount = 2">
               <S_N3>
                  <D_166>
                     <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
                  </D_166>
                  <D_166_2>
                     <xsl:value-of select="$street/StreetList/StreetItem[2]"/>
                  </D_166_2>
               </S_N3>
            </xsl:when>
            <xsl:when test="$streetCount = 3">
               <S_N3>
                  <D_166>
                     <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
                  </D_166>
                  <D_166_2>
                     <xsl:value-of select="$street/StreetList/StreetItem[2]"/>
                  </D_166_2>
               </S_N3>
               <S_N3>
                  <D_166>
                     <xsl:value-of select="$street/StreetList/StreetItem[3]"/>
                  </D_166>
               </S_N3>
            </xsl:when>
            <xsl:when test="$streetCount &gt; 3">
               <S_N3>
                  <D_166>
                     <xsl:value-of select="$street/StreetList/StreetItem[1]"/>
                  </D_166>
                  <D_166_2>
                     <xsl:value-of select="$street/StreetList/StreetItem[2]"/>
                  </D_166_2>
               </S_N3>
               <S_N3>
                  <D_166>
                     <xsl:value-of select="$street/StreetList/StreetItem[3]"/>
                  </D_166>
                  <D_166_2>
                     <xsl:value-of select="$street/StreetList/StreetItem[4]"/>
                  </D_166_2>
               </S_N3>
            </xsl:when>
         </xsl:choose>
         <xsl:if test="normalize-space($party/PostalAddress/City) != '' or normalize-space($party/PostalAddress/State) != '' or normalize-space($party/PostalAddress/PostalCode) != '' or normalize-space($party/PostalAddress/Country/@isoCountryCode) != ''">
            <S_N4>
               <xsl:if test="string-length(normalize-space($party/PostalAddress/City)) &gt; 1">
                  <D_19>
                     <xsl:value-of select="substring(normalize-space($party/PostalAddress/City), 1, 30)"/>
                  </D_19>
               </xsl:if>
               <xsl:variable name="uscaStateCode">
                  <xsl:if test="($party/PostalAddress/Country/@isoCountryCode = 'US' or $party/PostalAddress/Country/@isoCountryCode = 'CA') and normalize-space($party/PostalAddress/State) != ''">
                     <xsl:variable name="stCode" select="normalize-space($party/PostalAddress/State)"/>
                     <xsl:choose>
                        <xsl:when test="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode != ''">
                           <xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode"/>
                        </xsl:when>
                        <xsl:when test="string-length($stCode) = 2">
                           <xsl:value-of select="upper-case($stCode)"/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:if>
               </xsl:variable>
               <xsl:if test="$uscaStateCode != ''">
                  <D_156>
                     <xsl:value-of select="$uscaStateCode"/>
                  </D_156>
               </xsl:if>
               <xsl:if test="string-length(normalize-space($party/PostalAddress/PostalCode)) &gt; 2">
                  <D_116>
                     <xsl:value-of select="substring(normalize-space($party/PostalAddress/PostalCode), 1, 15)"/>
                  </D_116>
               </xsl:if>
               <xsl:if test="$party/PostalAddress/Country/@isoCountryCode != ''">
                  <D_26>
                     <xsl:value-of select="$party/PostalAddress/Country/@isoCountryCode"/>
                  </D_26>
               </xsl:if>
               <xsl:if test="$uscaStateCode = '' and normalize-space($party/PostalAddress/State) != ''">
                  <D_309>SP</D_309>
                  <D_310>
                     <xsl:value-of select="normalize-space($party/PostalAddress/State)"/>
                  </D_310>
               </xsl:if>
            </S_N4>
         </xsl:if>
         <xsl:for-each select="$party/IdReference">
            <xsl:variable name="domain" select="./@domain"/>
            <xsl:choose>
               <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code != ''">
                  <S_REF>
                     <D_128>
                        <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code"/>
                     </D_128>
                     <D_352>
                        <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                     </D_352>
                  </S_REF>
               </xsl:when>
               <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code != ''">
                  <S_REF>
                     <D_128>
                        <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code"/>
                     </D_128>
                     <D_352>
                        <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                     </D_352>
                  </S_REF>
               </xsl:when>
               <xsl:otherwise>
                  <S_REF>
                     <D_128>ZZ</D_128>
                     <D_127>
                        <xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
                     </D_127>
                     <D_352>
                        <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                     </D_352>
                  </S_REF>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <!-- IG-1958 -->
         <xsl:if test="$isOrder = 'true' and normalize-space($party/PostalAddress/@name) != ''">
            <S_REF>
               <D_128>
                  <xsl:text>ME</xsl:text>
               </D_128>
               <D_352>
                  <xsl:value-of select="substring(normalize-space($party/PostalAddress/@name), 1, 80)"/>
               </D_352>
            </S_REF>
         </xsl:if>
         <!-- IG-1960 -->
         <xsl:if test="$role = 'SU' and $party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID'] != ''">
            <S_REF>
               <D_128>
                  <xsl:text>VX</xsl:text>
               </D_128>
               <D_352>
                  <xsl:value-of select="substring(normalize-space($party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']), 1, 80)"/>
               </D_352>
            </S_REF>
         </xsl:if>
         <xsl:call-template name="createCom">
            <xsl:with-param name="party" select="$party"/>
         </xsl:call-template>
      </G_N1>
   </xsl:template>
   <xsl:template match="Email">
      <xsl:if test=". != ''">
         <Con>
            <xsl:attribute name="type">EM</xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template match="URL">
      <xsl:if test=". != ''">
         <Con>
            <xsl:attribute name="type">UR</xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template match="Fax">
      <xsl:if test=". != ''">
         <Con>
            <xsl:attribute name="type">FX</xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:variable name="isoCCode" select="TelephoneNumber/CountryCode/@isoCountryCode"/>
            <xsl:variable name="ccCode">
               <xsl:choose>
                  <xsl:when test="normalize-space(TelephoneNumber/CountryCode) != ''">
                     <xsl:value-of select="TelephoneNumber/CountryCode"/>
                  </xsl:when>
                  <xsl:when test="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1] != ''">
                     <xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1]"/>
                  </xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="areaCode">
               <xsl:if test="normalize-space(TelephoneNumber/AreaOrCityCode) != ''">
                  <xsl:value-of select="concat('(', normalize-space(TelephoneNumber/AreaOrCityCode), ')')"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="TelNum">
               <xsl:if test="normalize-space(TelephoneNumber/Number) != ''">
                  <xsl:value-of select="concat('-', replace(normalize-space(TelephoneNumber/Number), '-', ''))"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="ext">
               <xsl:if test="normalize-space(TelephoneNumber/Extension) != ''">
                  <xsl:value-of select="concat('x', replace(normalize-space(TelephoneNumber/Extension), '-', ''))"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="Number" select="concat($ccCode, $areaCode, $TelNum, $ext)"/>
            <xsl:choose>
               <xsl:when test="starts-with($Number, '-')">
                  <xsl:value-of select="substring(normalize-space(substring($Number, 2)), 1, 80)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="substring(normalize-space($Number), 1, 80)"/>
               </xsl:otherwise>
            </xsl:choose>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template match="Phone">
      <xsl:if test=". != ''">
         <Con>
            <xsl:attribute name="type">TE</xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:variable name="isoCCode" select="TelephoneNumber/CountryCode/@isoCountryCode"/>
            <xsl:variable name="ccCode">
               <xsl:choose>
                  <xsl:when test="normalize-space(TelephoneNumber/CountryCode) != ''">
                     <xsl:value-of select="TelephoneNumber/CountryCode"/>
                  </xsl:when>
                  <xsl:when test="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1] != ''">
                     <xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1]"/>
                  </xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="areaCode">
               <xsl:if test="normalize-space(TelephoneNumber/AreaOrCityCode) != ''">
                  <xsl:value-of select="concat('(', normalize-space(TelephoneNumber/AreaOrCityCode), ')')"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="TelNum">
               <xsl:if test="normalize-space(TelephoneNumber/Number) != ''">
                  <xsl:value-of select="concat('-', replace(normalize-space(TelephoneNumber/Number), '-', ''))"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="ext">
               <xsl:if test="normalize-space(TelephoneNumber/Extension) != ''">
                  <xsl:value-of select="concat('x', replace(normalize-space(TelephoneNumber/Extension), '-', ''))"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="Number" select="concat($ccCode, $areaCode, $TelNum, $ext)"/>
            <xsl:choose>
               <xsl:when test="starts-with($Number, '-')">
                  <xsl:value-of select="substring(normalize-space(substring($Number, 2)), 1, 80)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="substring(normalize-space($Number), 1, 80)"/>
               </xsl:otherwise>
            </xsl:choose>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createCom">
      <xsl:param name="party"/>
      <xsl:variable name="contactType">
         <xsl:value-of select="name($party)"/>
      </xsl:variable>
      <xsl:variable name="contactList">
         <xsl:apply-templates select="$party//Email"/>
         <xsl:apply-templates select="$party//Phone"/>
         <xsl:apply-templates select="$party//Fax"/>
         <xsl:apply-templates select="$party//URL"/>
      </xsl:variable>
      <xsl:for-each-group select="$contactList/Con" group-by="./@name">
         <xsl:sort select="@name"/>
         <xsl:variable name="PER02" select="current-grouping-key()"/>
         <xsl:for-each-group select="current-group()" group-by="(position() - 1) idiv 3">
            <xsl:element name="S_PER">
               <D_366>
                  <xsl:choose>
                     <xsl:when test="$contactType = 'BillTo'">AP</xsl:when>
                     <xsl:when test="$contactType = 'ShipTo'">RE</xsl:when>
                     <xsl:otherwise>CN</xsl:otherwise>
                  </xsl:choose>
               </D_366>
               <D_93>
                  <xsl:value-of select="$PER02"/>
               </D_93>
               <xsl:for-each select="current-group()">
                  <xsl:choose>
                     <xsl:when test="(position() mod 4) = 1">
                        <xsl:element name="D_365">
                           <xsl:value-of select="./@type"/>
                        </xsl:element>
                        <xsl:element name="D_364">
                           <xsl:value-of select="."/>
                        </xsl:element>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:element name="{concat('D_365_', position() mod 4)}">
                           <xsl:value-of select="./@type"/>
                        </xsl:element>
                        <xsl:element name="{concat('D_364_', position() mod 4)}">
                           <xsl:value-of select="."/>
                        </xsl:element>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each-group>
      </xsl:for-each-group>
   </xsl:template>
   <xsl:template name="PIDloop">
      <xsl:param name="Desc"/>
      <xsl:param name="langCode"/>
      <xsl:param name="isShipIns"/>
      <xsl:variable name="xmlLang">
         <xsl:choose>
            <xsl:when test="string-length(normalize-space($langCode)) &gt; 1">
               <xsl:value-of select="upper-case(substring(normalize-space($langCode), 1, 2))"/>
            </xsl:when>
            <xsl:otherwise>EN</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <G_PID>
         <S_PID>
            <D_349>F</D_349>
            <xsl:if test="$isShipIns = 'yes'">
               <D_750>93</D_750>
            </xsl:if>
            <D_352>
               <xsl:value-of select="substring($Desc, 1, 80)"/>
            </D_352>
            <D_819>
               <xsl:value-of select="$xmlLang"/>
            </D_819>
         </S_PID>
      </G_PID>
      <xsl:if test="string-length($Desc) &gt; 80">
         <xsl:call-template name="PIDloop">
            <xsl:with-param name="Desc" select="substring($Desc, 81)"/>
            <xsl:with-param name="langCode" select="$xmlLang"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="formatAmount">
      <xsl:param name="amount"/>
      <xsl:param name="formatDecimals"/>
      <xsl:variable name="tempAmount" select="replace($amount, ',', '')"/>
      <xsl:choose>
         <xsl:when test="$formatDecimals = 'N2'">
            <xsl:value-of select="replace(format-number(number(replace($amount, ',', '')), '0.00'), '\.', '')"/>
         </xsl:when>
         <xsl:when test="$tempAmount castable as xs:decimal">
            <xsl:value-of select="xs:decimal($tempAmount)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="replace($amount, ',', '')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="formatQty">
      <xsl:param name="qty"/>
      <xsl:variable name="tempQty" select="replace($qty, ',', '')"/>
      <xsl:if test="$tempQty castable as xs:decimal">
         <xsl:value-of select="xs:decimal($tempQty)"/>
      </xsl:if>
      <!--xsl:value-of select="replace($qty, ',', '')"/-->
   </xsl:template>
   <xsl:template name="createFOB_FromTermsOfDelivery">
      <!-- create FOB segment from cXML TermOfDelivery -->
      <xsl:param name="termOfDelivery"/>
      <xsl:variable name="spmVal" select="$termOfDelivery/ShippingPaymentMethod/@value"/>
      <xsl:variable name="todVal" select="$termOfDelivery/TermsOfDeliveryCode/@value"/>
      <xsl:variable name="ttVal" select="$termOfDelivery/TransportTerms/@value"/>
      <S_FOB>
         <D_146>
            <xsl:choose>
               <xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $spmVal]/X12Code != ''">
                  <xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $spmVal]/X12Code"/>
               </xsl:when>
               <xsl:otherwise>DF</xsl:otherwise>
            </xsl:choose>
         </D_146>
         <!-- IG-4714 -->
         <xsl:if test="$todVal != '' or normalize-space(/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transportResponsibilityLocation']) != ''">
            <D_309>
               <xsl:choose>
                  <xsl:when test="normalize-space(/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transportResponsibilityLocation']) != ''">
                     <xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transportResponsibilityLocation']"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="lower-case($todVal) = 'other'">ZZ</xsl:when>
                        <xsl:otherwise>OF</xsl:otherwise>
                     </xsl:choose>
                  </xsl:otherwise>
               </xsl:choose>
            </D_309>
            <D_352>
               <xsl:choose>
                  <xsl:when test="lower-case($todVal) = 'other'">
                     <xsl:value-of select="$termOfDelivery/TermsOfDeliveryCode"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$todVal"/>
                  </xsl:otherwise>
               </xsl:choose>
            </D_352>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $ttVal]/X12Code != ''">
               <D_334>ZZ</D_334>
               <D_335>
                  <xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $ttVal]/X12Code"/>
               </D_335>
            </xsl:when>
            <!-- IG-31554 -->
            <xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $ttVal]/X12Code != ''">               
               <D_334>ZZ</D_334>
               <D_335>
                  <xsl:value-of select="$ttVal"/>
               </D_335>
            </xsl:when>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="$spmVal = 'other'">
               <D_309_2>ZZ</D_309_2>
               <D_352_2>
                  <xsl:value-of select="$termOfDelivery/ShippingPaymentMethod"/>
               </D_352_2>
            </xsl:when>
            <xsl:when test="$spmVal != ''">
               <D_309_2>ZZ</D_309_2>
               <D_352_2>
                  <xsl:value-of select="$spmVal"/>
               </D_352_2>
            </xsl:when>
         </xsl:choose>
      </S_FOB>
   </xsl:template>
   <xsl:template name="createSAC_FromModifications">
      <!-- create SAC segment from cXML Modifications -->
      <xsl:param name="modification"/>
      <xsl:if test="exists($modification/OriginalPrice) and normalize-space($modification/OriginalPrice/Money) != ''">
         <G_SAC>
            <S_SAC>
               <D_248>N</D_248>
               <D_1300>F050</D_1300>
               <D_610>
                  <xsl:call-template name="formatAmount">
                     <xsl:with-param name="amount" select="$modification/OriginalPrice/Money"/>
                     <xsl:with-param name="formatDecimals" select="'N2'"/>
                  </xsl:call-template>
               </D_610>
               <xsl:if test="$modification/OriginalPrice/@type != ''">
                  <D_127>
                     <xsl:value-of select="$modification/OriginalPrice/@type"/>
                  </D_127>
               </xsl:if>
               <D_352>Original Price</D_352>
               <D_819>
                  <xsl:choose>
                     <xsl:when test="string-length(normalize-space($modification/ModificationDetail/Description/@xml:lang)) &gt; 1">
                        <xsl:value-of select="upper-case(substring(normalize-space($modification/ModificationDetail/Description/@xml:lang), 1, 2))"/>
                     </xsl:when>
                     <xsl:otherwise>EN</xsl:otherwise>
                  </xsl:choose>
               </D_819>
            </S_SAC>
            <S_CUR>
               <D_98>BY</D_98>
               <D_100>
                  <xsl:value-of select="$modification/OriginalPrice/Money/@currency"/>
               </D_100>
            </S_CUR>
         </G_SAC>
      </xsl:if>
      <xsl:variable name="modName" select="$modification/ModificationDetail/@name"/>
      <G_SAC>
         <S_SAC>
            <D_248>
               <xsl:choose>
                  <xsl:when test="exists($modification/AdditionalDeduction)">A</xsl:when>
                  <xsl:when test="exists($modification/AdditionalCost)">C</xsl:when>
               </xsl:choose>
            </D_248>
            <D_1300>
               <xsl:choose>
                  <xsl:when test="$Lookup/Lookups/Modifications/Modification[CXMLCode = $modName]/X12Code != ''">
                     <xsl:value-of select="$Lookup/Lookups/Modifications/Modification[CXMLCode = $modName]/X12Code"/>
                  </xsl:when>
                  <xsl:otherwise>ZZZZ</xsl:otherwise>
               </xsl:choose>
            </D_1300>
            <xsl:choose>
               <xsl:when test="$modification/AdditionalCost/Money != ''">
                  <D_610>
                     <xsl:call-template name="formatAmount">
                        <xsl:with-param name="amount" select="$modification/AdditionalCost/Money"/>
                        <xsl:with-param name="formatDecimals" select="'N2'"/>
                     </xsl:call-template>
                  </D_610>
               </xsl:when>
               <xsl:when test="$modification/AdditionalDeduction/DeductionAmount/Money != ''">
                  <D_610>
                     <xsl:call-template name="formatAmount">
                        <xsl:with-param name="amount" select="$modification/AdditionalDeduction/DeductionAmount/Money"/>
                        <xsl:with-param name="formatDecimals" select="'N2'"/>
                     </xsl:call-template>
                  </D_610>
               </xsl:when>
               <xsl:when test="$modification/AdditionalDeduction/DeductedPrice/Money != ''">
                  <D_610>
                     <xsl:call-template name="formatAmount">
                        <xsl:with-param name="amount" select="$modification/AdditionalDeduction/DeductedPrice/Money"/>
                        <xsl:with-param name="formatDecimals" select="'N2'"/>
                     </xsl:call-template>
                  </D_610>
               </xsl:when>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="$modification/AdditionalCost/Percentage/@percent != ''">
                  <D_378>6</D_378>
                  <D_332>
                     <xsl:value-of select="$modification/AdditionalCost/Percentage/@percent"/>
                  </D_332>
               </xsl:when>
               <xsl:when test="$modification/AdditionalDeduction/DeductionPercent/@percent != ''">
                  <D_378>6</D_378>
                  <D_332>
                     <xsl:value-of select="$modification/AdditionalDeduction/DeductionPercent/@percent"/>
                  </D_332>
               </xsl:when>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="$modification/AdditionalDeduction/DeductionAmount/Money != ''">
                  <D_127>AMT_PRI</D_127>
                  <D_770>1</D_770>
               </xsl:when>
               <xsl:when test="$modification/AdditionalDeduction/DeductedPrice/Money != ''">
                  <D_127>AMT_PRI</D_127>
                  <D_770>2</D_770>
               </xsl:when>
            </xsl:choose>
            <D_352>
               <xsl:choose>
                  <xsl:when test="$modification/ModificationDetail/Description != ''">
                     <xsl:value-of select="substring($modification/ModificationDetail/Description, 1, 80)"/>
                  </xsl:when>
                  <xsl:otherwise>No Description Provided</xsl:otherwise>
               </xsl:choose>
            </D_352>
            <D_819>
               <xsl:choose>
                  <xsl:when test="string-length(normalize-space($modification/ModificationDetail/Description/@xml:lang)) &gt; 1">
                     <xsl:value-of select="upper-case(substring(normalize-space($modification/ModificationDetail/Description/@xml:lang), 1, 2))"/>
                  </xsl:when>
                  <xsl:otherwise>EN</xsl:otherwise>
               </xsl:choose>
            </D_819>
         </S_SAC>
         <xsl:if test="$modification/AdditionalCost/Money != '' or $modification/AdditionalDeduction/DeductionAmount/Money != '' or $modification/AdditionalDeduction/DeductedPrice/Money != ''">
            <S_CUR>
               <D_98>BY</D_98>
               <xsl:choose>
                  <xsl:when test="$modification/AdditionalCost/Money != ''">
                     <D_100>
                        <xsl:value-of select="$modification/AdditionalCost/Money/@currency"/>
                     </D_100>
                  </xsl:when>
                  <xsl:when test="$modification/AdditionalDeduction/DeductionAmount/Money != ''">
                     <D_100>
                        <xsl:value-of select="AdditionalDeduction/DeductionAmount/Money/@currency"/>
                     </D_100>
                  </xsl:when>
                  <xsl:when test="$modification/AdditionalDeduction/DeductedPrice/Money != ''">
                     <D_100>
                        <xsl:value-of select="AdditionalDeduction/DeductedPrice/Money/@currency"/>
                     </D_100>
                  </xsl:when>
               </xsl:choose>
               <xsl:if test="$modification/ModificationDetail/@startDate != ''">
                  <D_374>196</D_374>
                  <D_373>
                     <xsl:value-of select="replace(substring($modification/ModificationDetail/@startDate, 0, 11), '-', '')"/>
                  </D_373>
                  <D_337>
                     <xsl:value-of select="replace(substring($modification/ModificationDetail/@startDate, 12, 8), ':', '')"/>
                  </D_337>
               </xsl:if>
               <xsl:if test="$modification/ModificationDetail/@endDate != ''">
                  <D_374_2>197</D_374_2>
                  <D_373_2>
                     <xsl:value-of select="replace(substring($modification/ModificationDetail/@endDate, 0, 11), '-', '')"/>
                  </D_373_2>
                  <D_337_2>
                     <xsl:value-of select="replace(substring($modification/ModificationDetail/@endDate, 12, 8), ':', '')"/>
                  </D_337_2>
               </xsl:if>
            </S_CUR>
         </xsl:if>
      </G_SAC>
   </xsl:template>
   <xsl:template name="createITD_FromPaymentTerms">
      <!-- create ITD segment from cXML PaymentTerms -->
      <xsl:param name="paymentTerm"/>
      <S_ITD>
         <D_336>
            <xsl:choose>
               <xsl:when test="exists($paymentTerm/Discount)">52</xsl:when>
               <xsl:otherwise>05</xsl:otherwise>
            </xsl:choose>
         </D_336>
         <D_333>3</D_333>
         <xsl:if test="$paymentTerm/Discount/DiscountPercent/@percent != ''">
            <D_338>
               <xsl:value-of select="$paymentTerm/Discount/DiscountPercent/@percent"/>
            </D_338>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="exists($paymentTerm/Discount)">
               <D_351>
                  <xsl:value-of select="$paymentTerm/@payInNumberOfDays"/>
               </D_351>
            </xsl:when>
            <xsl:otherwise>
               <D_386>
                  <xsl:value-of select="$paymentTerm/@payInNumberOfDays"/>
               </D_386>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:if test="exists($paymentTerm/Discount/DiscountAmount)">
            <D_362>
               <xsl:call-template name="formatAmount">
                  <xsl:with-param name="amount" select="$paymentTerm/Discount/DiscountAmount/Money"/>
                  <xsl:with-param name="formatDecimals" select="'N2'"/>
               </xsl:call-template>
            </D_362>
         </xsl:if>
         <!-- IG-4714 -->
         <xsl:if test="normalize-space(/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'paymentTermsDescription']) != ''">
            <D_352>
               <xsl:value-of select="substring(/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'paymentTermsDescription'], 1, 80)"/>
            </D_352>
         </xsl:if>
         <xsl:if test="not(exists($paymentTerm/Discount))">
            <D_954>0</D_954>
         </xsl:if>
      </S_ITD>
   </xsl:template>
   <xsl:template name="createTXI_FromTaxDetail">
      <xsl:param name="taxDetail"/>
      <xsl:variable name="taxCategory">
         <xsl:choose>
            <xsl:when test="lower-case($taxDetail/@category) = 'gst'">
               <xsl:text>GS</xsl:text>
            </xsl:when>
            <xsl:when test="lower-case($taxDetail/@category) = 'vat'">
               <xsl:text>VA</xsl:text>
            </xsl:when>
            <xsl:when test="lower-case($taxDetail/@category) = 'sales' or lower-case($taxDetail/@category) = 'qst' or lower-case($taxDetail/@category) = 'hst' or lower-case($taxDetail/@category) = 'pst'">
               <xsl:text>ST</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>ZZ</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <S_TXI>
         <D_963>
            <xsl:value-of select="$taxCategory"/>
         </D_963>
         <D_782>
            <xsl:call-template name="formatAmount">
               <xsl:with-param name="amount" select="$taxDetail/TaxAmount/Money"/>
            </xsl:call-template>
         </D_782>
         <xsl:if test="normalize-space($taxDetail/@percentageRate) != ''">
            <D_954>
               <xsl:value-of select="normalize-space($taxDetail/@percentageRate)"/>
            </D_954>
         </xsl:if>
         <xsl:if test="normalize-space($taxDetail/TaxLocation) != ''">
            <D_955>CD</D_955>
            <D_956>
               <xsl:value-of select="substring($taxDetail/TaxLocation, 0, 10)"/>
            </D_956>
         </xsl:if>
         <xsl:if test="normalize-space($taxDetail/@exemptDetail) != ''">
            <D_441>
               <xsl:choose>
                  <xsl:when test="$taxDetail/@exemptDetail = 'zeroRated'">0</xsl:when>
                  <xsl:when test="$taxDetail/@exemptDetail = 'exempt'">2</xsl:when>
               </xsl:choose>
            </D_441>
         </xsl:if>
         <xsl:if test="normalize-space($taxDetail/TaxableAmount/Money) != ''">
            <D_828>
               <xsl:call-template name="formatAmount">
                  <xsl:with-param name="amount" select="$taxDetail/TaxableAmount/Money"/>
               </xsl:call-template>
            </D_828>
         </xsl:if>
         <xsl:if test="$taxCategory = 'ZZ' and lower-case($taxDetail/@category) != 'other'">
            <D_325>
               <xsl:value-of select="substring($taxDetail/@category, 0, 20)"/>
            </D_325>
         </xsl:if>
         <xsl:if test="normalize-space($taxDetail/Description) != ''">
            <D_350>
               <xsl:value-of select="substring($taxDetail/Description, 0, 20)"/>
            </D_350>
         </xsl:if>
      </S_TXI>
   </xsl:template>
   <!-- IG-28972  Add null check  -->
   <xsl:template name="createSAC_FromDistribution">
      <xsl:param name="distribution"/>
      <xsl:if test="exists($distribution/Charge/Money) and normalize-space($distribution/Charge/Money) != ''">
      <G_SAC>
         <S_SAC>
            <D_248>N</D_248>
            <D_1300>B840</D_1300>
            <D_610>
               <xsl:call-template name="formatAmount">
                  <xsl:with-param name="amount" select="$distribution/Charge/Money"/>
                  <xsl:with-param name="formatDecimals" select="'N2'"/>
               </xsl:call-template>
               <!--xsl:value-of select="replace(format-number(number(replace(Charge/Money,',','')),'#.00'),'\.','')"/-->
            </D_610>
            <xsl:variable name="accID">
               <xsl:for-each select="$distribution/Accounting/Segment">
                  <xsl:value-of select="concat('-', @id)"/>
               </xsl:for-each>
               <xsl:for-each select="$distribution/Accounting/AccountingSegment">
                  <xsl:value-of select="concat('-', @id)"/>
               </xsl:for-each>
            </xsl:variable>
            <D_127>
               <xsl:value-of select="substring($accID, 1, 30)"/>
            </D_127>
            <xsl:variable name="accDesc">
               <xsl:for-each select="$distribution/Accounting/AccountingSegment">
                  <xsl:if test="normalize-space(Description/ShortName) != ''">
                     <xsl:value-of select="concat('-', normalize-space(Description/ShortName))"/>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$distribution/Accounting/Segment">
                  <xsl:if test="normalize-space(@description) != ''">
                     <xsl:value-of select="concat('-', normalize-space(@description))"/>
                  </xsl:if>
               </xsl:for-each>
            </xsl:variable>
            <D_352>
               <xsl:choose>
                  <xsl:when test="normalize-space($accDesc) != ''">
                     <xsl:value-of select="substring(normalize-space($accDesc), 1, 80)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>LISA</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </D_352>
            <D_819>
               <xsl:choose>
                  <xsl:when test="string-length(normalize-space($distribution/Accounting/AccountingSegment[1]/Description[1]/@xml:lang)) &gt; 1">
                     <xsl:value-of select="upper-case(substring(normalize-space($distribution/Accounting/AccountingSegment[1]/Description[1]/@xml:lang), 1, 2))"/>
                  </xsl:when>
                  <xsl:otherwise>EN</xsl:otherwise>
               </xsl:choose>
            </D_819>
         </S_SAC>
         <S_CUR>
            <D_98>BY</D_98>
            <D_100>
               <xsl:value-of select="$distribution/Charge/Money/@currency"/>
            </D_100>
         </S_CUR>
      </G_SAC>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createSCH_FromScheduleLine">
      <xsl:param name="scheduleLine"/>
      <xsl:param name="mapREF"/>
      <xsl:variable name="uom" select="$scheduleLine/UnitOfMeasure"/>
      <G_SCH>
         <S_SCH>
            <D_380>
               <xsl:call-template name="formatQty">
                  <xsl:with-param name="qty" select="$scheduleLine/@quantity"/>
               </xsl:call-template>
               <!--xsl:value-of select="format-number(@quantity,'0.##')"/-->
            </D_380>
            <D_355>
               <xsl:choose>
                  <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                     <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
                  </xsl:when>
                  <xsl:otherwise>ZZ</xsl:otherwise>
               </xsl:choose>
            </D_355>
            <xsl:if test="normalize-space($scheduleLine/ShipTo/Address/Name) !=''">
               <D_98>
                  <xsl:text>ST</xsl:text>
               </D_98>
               <D_93>
                  <xsl:value-of select="normalize-space($scheduleLine/ShipTo/Address/Name)"/>
               </D_93>
            </xsl:if>
            <D_374>002</D_374>
            <D_373>
               <xsl:value-of select="replace(substring($scheduleLine/@requestedDeliveryDate, 0, 11), '-', '')"/>
            </D_373>
            <D_337>
               <xsl:value-of select="replace(substring($scheduleLine/@requestedDeliveryDate, 12, 8), ':', '')"/>
            </D_337>
            <xsl:if test="$scheduleLine/@requestedShipmentDate != ''">
               <D_374_2>010</D_374_2>
               <D_373_2>
                  <xsl:value-of select="replace(substring($scheduleLine/@requestedShipmentDate, 0, 11), '-', '')"/>
               </D_373_2>
               <D_337_2>
                  <xsl:value-of select="replace(substring($scheduleLine/@requestedShipmentDate, 12, 8), ':', '')"/>
               </D_337_2>
            </xsl:if>
            <xsl:if test="$scheduleLine/@lineNumber">
               <D_326>
                  <xsl:value-of select="$scheduleLine/@lineNumber"/>
               </D_326>
            </xsl:if>
            <!-- IG-28883 -->
            <xsl:if test="$scheduleLine/@deliveryWindow">
               <xsl:variable name="deliveryWindow">
                  <xsl:value-of select="$scheduleLine/@deliveryWindow"/>
               </xsl:variable>                                
               <xsl:choose>
                  <xsl:when test="$deliveryWindow castable as xs:duration">
                     <D_350> 
                        <xsl:value-of select="concat(replace(string(xs:date(substring($scheduleLine/@requestedDeliveryDate, 0, 11)) + xs:dayTimeDuration(@deliveryWindow)), '-', ''), (replace(substring(@requestedDeliveryDate, 12, 8), ':', '')))"/>
                     </D_350>
                  </xsl:when>
                  <xsl:when test="$deliveryWindow castable as xs:decimal">
                     <D_350>
                        <xsl:value-of select="concat(replace(string(xs:date(substring($scheduleLine/@requestedDeliveryDate, 0, 11)) + xs:dayTimeDuration(concat('P', @deliveryWindow, 'D'))), '-', ''), (replace(substring(@requestedDeliveryDate, 12, 8), ':', '')))"/>
                     </D_350>
                  </xsl:when>
               </xsl:choose>
            </xsl:if>
         </S_SCH>
         <!-- CG 07262017 : [IG-1279] - REF segment added -->
         <xsl:if test="$mapREF = 'true'">
            <xsl:if test="normalize-space($scheduleLine/Extrinsic[@name = 'assignedContractNo']) != ''">
               <S_REF>
                  <D_128>CT</D_128>
                  <D_127>
                     <xsl:value-of select="substring(normalize-space($scheduleLine/Extrinsic[@name = 'assignedContractNo']), 1, 30)"/>
                  </D_127>
               </S_REF>
            </xsl:if>
         </xsl:if>
      </G_SCH>
   </xsl:template>
   <xsl:template name="createPKG_FromPackaging">
      <!-- create G_PKG by default or S_PKG if noGroup variable is set to true -->
      <xsl:param name="packaging"/>
      <xsl:param name="noGroup"/>
      <xsl:choose>
         <xsl:when test="$noGroup = 'true'">
            <xsl:call-template name="createSPKG">
               <xsl:with-param name="packg" select="$packaging"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <G_PKG>
               <xsl:call-template name="createSPKG">
                  <xsl:with-param name="packg" select="$packaging"/>
               </xsl:call-template>
               <xsl:for-each select="$packaging/Dimension">
                  <xsl:call-template name="createMEA_FromDimension">
                     <xsl:with-param name="dimension" select="."/>
                     <xsl:with-param name="meaQual" select="'PD'"/>
                  </xsl:call-template>
               </xsl:for-each>
            </G_PKG>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="createSPKG">
      <xsl:param name="packg"/>
      <S_PKG>
         <D_349>F</D_349>
         <D_753>01</D_753>
         <D_559>ZZ</D_559>
         <xsl:if test="$packg/Description/@type != ''">
            <D_754>
               <xsl:value-of select="substring($packg/Description/@type,1,7)"/>
            </D_754>
         </xsl:if>
         <D_352>
            <xsl:choose>
               <xsl:when test="normalize-space($packg/Description) != ''">
                  <xsl:value-of select="substring(normalize-space($packg/Description), 1, 80)"/>
               </xsl:when>
               <xsl:otherwise>Packaging Description Not Provided</xsl:otherwise>
            </xsl:choose>
         </D_352>
      </S_PKG>
   </xsl:template>
   <xsl:template name="createMEA_FromDimension">
      <xsl:param name="dimension"/>
      <xsl:param name="meaQual"/>
      <xsl:variable name="dType" select="$dimension/@type"/>
      <xsl:if test="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dType]/X12Code != ''">
         <S_MEA>
            <xsl:variable name="uom" select="$dimension/UnitOfMeasure"/>
            <D_737>
               <xsl:value-of select="$meaQual"/>
            </D_737>
            <D_738>
               <xsl:value-of select="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dType]/X12Code"/>
            </D_738>
            <D_739>
               <xsl:call-template name="formatQty">
                  <xsl:with-param name="qty" select="$dimension/@quantity"/>
               </xsl:call-template>
               <!--xsl:value-of select="format-number(@quantity,'0.##')"/-->
            </D_739>
            <C_C001>
               <D_355>
                  <xsl:choose>
                     <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                        <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
                     </xsl:when>
                     <xsl:otherwise>ZZ</xsl:otherwise>
                  </xsl:choose>
               </D_355>
            </C_C001>
         </S_MEA>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createOrderCommonREF">
      <xsl:param name="doExtrinsicsLookup" required="no"/>
      <!-- SystemID -->
      <xsl:if test="normalize-space(cXML/Header/From/Credential[@domain = 'SystemID']/Identity) != ''">
         <S_REF>
            <D_128>06</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Header/From/Credential[@domain = 'SystemID']/Identity), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- Other TransportTerms -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms[@value = 'Other']) != ''">
         <S_REF>
            <D_128>0L</D_128>
            <D_127>FOB05</D_127>
            <D_352>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms[@value = 'Other']), 1, 80)"/>
            </D_352>
         </S_REF>
      </xsl:if>
      <!-- orderID -->
      <xsl:call-template name="createREF">
         <xsl:with-param name="qual" select="'PO'"/>
         <xsl:with-param name="ref02" select="cXML/Request/OrderRequest/OrderRequestHeader/@orderID"/>
      </xsl:call-template>
      <!-- orderType -->
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] != ''">
         <S_REF>
            <D_128>8X</D_128>
            <D_127>orderType</D_127>
            <D_352>
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType']"/>
            </D_352>
         </S_REF>
      </xsl:if>
      <!-- requisitionID -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID) != ''">
         <xsl:call-template name="createREF">
            <xsl:with-param name="qual" select="'RQ'"/>
            <xsl:with-param name="ref02" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID)"/>
         </xsl:call-template>
      </xsl:if>
      <!-- parentAgreementID -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID) != ''">
         <xsl:call-template name="createREF">
            <xsl:with-param name="qual" select="'BO'"/>
            <xsl:with-param name="ref03" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID)"/>
         </xsl:call-template>
      </xsl:if>
      <!-- agreementID -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID) != ''">
         <xsl:call-template name="createREF">
            <xsl:with-param name="qual" select="'AH'"/>
            <xsl:with-param name="ref03" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID)"/>
         </xsl:call-template>
      </xsl:if>
      <!-- orderVersion -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion) != ''">
         <S_REF>
            <D_128>PP</D_128>
            <D_127>
               <xsl:value-of select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- Shipping -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId) != ''">
         <S_REF>
            <D_128>2I</D_128>
            <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain) != ''">
               <D_127>
                  <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain), 1, 30)"/>
               </D_127>
            </xsl:if>
            <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId) != ''">
               <D_352>
                  <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId), 1, 80)"/>
               </D_352>
            </xsl:if>
         </S_REF>
      </xsl:if>
      <!-- CustomerReferenceID -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier) != ''">
         <S_REF>
            <D_128>CR</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- UltimateCustomerReferenceID -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'UltimateCustomerReferenceID']/@identifier) != ''">
         <S_REF>
            <D_128>ZB</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'UltimateCustomerReferenceID']/@identifier), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- governmentNumber -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'governmentNumber']/@identifier) != ''">
         <S_REF>
            <D_128>AEC</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'governmentNumber']/@identifier), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- supplierReference -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'supplierReference']/@identifier) != ''">
         <S_REF>
            <D_128>D2</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'supplierReference']/@identifier), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- documentName -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'documentName']/@identifier) != ''">
         <S_REF>
            <D_128>DD</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'documentName']/@identifier), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- Priority -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@level) != ''">
         <S_REF>
            <D_128>RPP</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@level), 1, 30)"/>
            </D_127>
            <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/Description) != ''">
               <D_352>
                  <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/Description), 1, 80)"/>
               </D_352>
            </xsl:if>
            <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@sequence) != ''">
               <C_C040>
                  <D_128>RPP</D_128>
                  <D_127>
                     <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@sequence), 1, 30)"/>
                  </D_127>
               </C_C040>
            </xsl:if>
         </S_REF>
      </xsl:if>
      <!-- CG -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'internalVendorNo']) != ''">
         <S_REF>
            <D_128>IA</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'internalVendorNo']), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'contractNo']) != ''">
         <S_REF>
            <D_128>CT</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'contractNo']), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- CG 07262017 : [IG-1279] - quoteNo REF segment added -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'quoteNo']) != ''">
         <S_REF>
            <D_128>Q1</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'quoteNo']), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- IG - 4714 -->
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'promotionalDealID']) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'promotionalDealIDDesc']) != ''">
         <S_REF>
            <D_128>PD</D_128>
            <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'promotionalDealID']) != ''">    
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'promotionalDealID']), 1, 30)"/>
            </D_127>
            </xsl:if>
            <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'promotionalDealIDDesc']) != ''">
               <D_352>
                  <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'promotionalDealIDDesc']), 1, 80)"/>
               </D_352>
            </xsl:if>
         </S_REF>
      </xsl:if>
      <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID) != ''">
         <S_REF>
            <D_128>VN</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <!-- 10042018 CG: Mapping of all remaining extrinsics added to template and update to use properties that can be dynamically updated            - Whenever adding an extrinsic mapped to an standard field, we should update lookup -->
      <xsl:variable name="standardExtrinsics" select="tokenize($Lookup/Lookups/Properties/OrderHeaderStandardExtrinsics, ',')"/>
      <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[not(@name = $standardExtrinsics)]">
         <xsl:choose>
            <!-- CG: IG-16765 - 1500 Extrinsics support --> 
            <xsl:when test="$doExtrinsicsLookup = 'yes'">
               <xsl:variable name="nameExt" select="normalize-space(@name)"/>
               <xsl:variable name="extLookupCode" select="$Lookup/Lookups/Extrinsics/Extrinsic[CXMLCode=$nameExt][not(exists(ExcludeDocType/OrderHeaderEx))]/X12Code"/>
               <xsl:choose>
                  <xsl:when test="$extLookupCode!='' and normalize-space(.) != ''">
                     <S_REF>
                        <D_128>
                           <xsl:value-of select="$extLookupCode"/>
                        </D_128>
                        <D_127>
                           <xsl:value-of select="substring(normalize-space(.), 1, 30)"/>
                        </D_127>
                        <xsl:if test="string-length(normalize-space(.))&gt; 30">
                           <D_352>
                              <xsl:value-of select="substring(normalize-space(.), 31, 110)"/>
                           </D_352>
                        </xsl:if>
                     </S_REF>
                  </xsl:when>
                  <xsl:when test="$nameExt != ''">
                     <S_REF>
                        <D_128>ZZ</D_128>
                        <D_127>
                           <xsl:value-of select="substring(normalize-space($nameExt), 1, 30)"/>
                        </D_127>
                        <xsl:if test="normalize-space(.) != ''">
                           <D_352>
                              <xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
                           </D_352>
                        </xsl:if>
                     </S_REF>
                  </xsl:when>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <S_REF>
                  <D_128>ZZ</D_128>
                  <D_127>
                     <xsl:value-of select="substring(normalize-space(@name), 1, 30)"/>
                  </D_127>
                  <xsl:if test="normalize-space(.) != ''">
                     <D_352>
                        <xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
                     </D_352>
                  </xsl:if>
               </S_REF>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <!-- CG: IG-16765 - 1500 Extrinsics support -->
   <xsl:template name="mapItemPOCOExtrinsics">
      <xsl:param name="doExtrinsicsLookup"/>      
      <xsl:choose>
         <xsl:when test="$doExtrinsicsLookup = 'yes'">
            <xsl:variable name="nameExt" select="normalize-space(@name)"/>
            <xsl:variable name="extLookupCode" select="$Lookup/Lookups/Extrinsics/Extrinsic[CXMLCode=$nameExt][not(exists(ExcludeDocType/OrderLineEx))]/X12Code"/>
            <xsl:choose>
               <xsl:when test="$extLookupCode!='' and normalize-space(.) != ''">
                  <S_REF>
                     <D_128>
                        <xsl:value-of select="$extLookupCode"/>
                     </D_128>
                     <D_127>
                        <xsl:value-of select="substring(normalize-space(.), 1, 30)"/>
                     </D_127>
                     <xsl:if test="string-length(normalize-space(.))&gt; 30">
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(.), 31, 110)"/>
                        </D_352>
                     </xsl:if>
                  </S_REF>
               </xsl:when>
               <xsl:when test="$nameExt != ''">
                  <S_REF>
                     <D_128>ZZ</D_128>
                     <D_127>
                        <xsl:value-of select="substring(normalize-space($nameExt), 1, 30)"/>
                     </D_127>
                     <xsl:if test="normalize-space(.) != ''">
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
                        </D_352>
                     </xsl:if>
                  </S_REF>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <S_REF>
               <D_128>ZZ</D_128>
               <D_127>
                  <xsl:value-of select="substring(normalize-space(@name), 1, 30)"/>
               </D_127>
               <xsl:if test="normalize-space(.) != ''">
                  <D_352>
                     <xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
                  </D_352>
               </xsl:if>
            </S_REF>
         </xsl:otherwise>
      </xsl:choose>      
   </xsl:template>
   
   <xsl:template name="createOrderCommonDTM">
      <!-- orderDate -->
      <xsl:call-template name="createDTM">
         <xsl:with-param name="D374_Qual">004</xsl:with-param>
         <xsl:with-param name="cXMLDate">
            <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderDate"/>
         </xsl:with-param>
      </xsl:call-template>
      <!-- effectiveDate -->
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate != ''">
         <xsl:call-template name="createDTM">
            <xsl:with-param name="D374_Qual">007</xsl:with-param>
            <xsl:with-param name="cXMLDate">
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <!-- expirationDate -->
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate != ''">
         <xsl:call-template name="createDTM">
            <xsl:with-param name="D374_Qual">036</xsl:with-param>
            <xsl:with-param name="cXMLDate">
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <!-- pickUpDate -->
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate != ''">
         <xsl:call-template name="createDTM">
            <xsl:with-param name="D374_Qual">118</xsl:with-param>
            <xsl:with-param name="cXMLDate">
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <!-- requestedDeliveryDate -->
      <!-- CG -->
      <xsl:choose>
         <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate != ''">
            <xsl:call-template name="createDTM">
               <xsl:with-param name="D374_Qual">002</xsl:with-param>
               <xsl:with-param name="cXMLDate">
                  <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'requestedDeliveryDate'] != ''">
            <xsl:call-template name="createDTM">
               <xsl:with-param name="D374_Qual">002</xsl:with-param>
               <xsl:with-param name="cXMLDate">
                  <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'requestedDeliveryDate']"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
      <!-- CG -->
      <!-- Missing shipDate and CancelDate -->
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'ShipDate'] != ''">
         <xsl:call-template name="createDTM">
            <xsl:with-param name="D374_Qual">010</xsl:with-param>
            <xsl:with-param name="cXMLDate">
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'ShipDate']"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'CancelDate'] != ''">
         <xsl:call-template name="createDTM">
            <xsl:with-param name="D374_Qual">177</xsl:with-param>
            <xsl:with-param name="cXMLDate">
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'CancelDate']"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <!-- Delivery Period startDate -->
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate != ''">
         <xsl:call-template name="createDTM">
            <xsl:with-param name="D374_Qual">070</xsl:with-param>
            <xsl:with-param name="cXMLDate">
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <!-- Delivery Period endDate -->
      <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate != ''">
         <xsl:call-template name="createDTM">
            <xsl:with-param name="D374_Qual">073</xsl:with-param>
            <xsl:with-param name="cXMLDate">
               <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createItemParts">
      <!-- this applies to PO/CO where not only supplier / buyer partID are considered, but also manufacturer partID -->
      <xsl:param name="itemID"/>
      <xsl:param name="itemDetail"/>
      <xsl:param name="description"/>
      <xsl:param name="lineRef"/>
      <xsl:param name="isReceiptRequest"/>
      <xsl:param name="itemCategory" required="no"/>
   	<xsl:param name="isSMI" required="no"/>
   	
   	<xsl:variable name="partsList">
         <PartsList>
            <xsl:if test="normalize-space($lineRef) != ''">
               <Part>
                  <Qualifier>PL</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(normalize-space($lineRef), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="replace($itemID/SupplierPartID,'^\s+|\s+$','') != ''">
               <Part>
                  <Qualifier>VP</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(replace($itemID/SupplierPartID,'^\s+|\s+$',''), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="replace($itemID/BuyerPartID,'^\s+|\s+$','') != ''">
               <Part>
                  <Qualifier>BP</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(replace($itemID/BuyerPartID,'^\s+|\s+$',''), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="replace($itemID/SupplierPartAuxiliaryID,'^\s+|\s+$','') != ''">
               <Part>
                  <Qualifier>VS</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(replace($itemID/SupplierPartAuxiliaryID,'^\s+|\s+$',''), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="$itemDetail">
               <xsl:if test="replace($itemDetail/ManufacturerPartID,'^\s+|\s+$','') != ''">
                  <Part>
                     <Qualifier>MG</Qualifier>
                     <Value>
                        <xsl:value-of select="substring(replace($itemDetail/ManufacturerPartID,'^\s+|\s+$',''), 1, 48)"/>
                     </Value>
                  </Part>
               </xsl:if>
               <xsl:if test="replace($itemDetail/ManufacturerName,'^\s+|\s+$','') != ''">
                  <Part>
                     <Qualifier>MF</Qualifier>
                     <Value>
                        <xsl:value-of select="substring(replace($itemDetail/ManufacturerName,'^\s+|\s+$',''), 1, 48)"/>
                     </Value>
                  </Part>
               </xsl:if>
               <xsl:if test="$isSMI != 'yes' and replace($itemDetail/Classification[1],'^\s+|\s+$','') != ''">
                  <Part>
                     <Qualifier>C3</Qualifier>
                     <Value>
                        <xsl:value-of select="substring(replace($itemDetail/Classification[1],'^\s+|\s+$',''), 1, 48)"/>
                     </Value>
                  </Part>
               </xsl:if>
               <!--<xsl:if test="normalize-space($itemDetail/Batch/SupplierBatchID) != ''">            <Part>              <Qualifier>B8</Qualifier>              <Value>                <xsl:value-of                  select="substring(normalize-space($itemDetail/Batch/SupplierBatchID), 1, 48)"/>              </Value>            </Part>          </xsl:if>-->
            </xsl:if>
            <xsl:choose>
               <xsl:when test="$itemDetail and replace($itemDetail/ItemDetailIndustry/ItemDetailRetail/EANID,'^\s+|\s+$','') != ''">
                  <Part>
                     <Qualifier>EN</Qualifier>
                     <Value>
                        <xsl:value-of select="substring(replace($itemDetail/ItemDetailIndustry/ItemDetailRetail/EANID,'^\s+|\s+$',''), 1, 48)"/>
                     </Value>
                  </Part>
               </xsl:when>
            	<xsl:when test="$isSMI != 'yes' and $itemID and replace($itemID/IdReference[@domain='EAN-13']/@identifier,'^\s+|\s+$','') != ''">
                  <Part>
                     <Qualifier>EN</Qualifier>
                     <Value>
                        <xsl:value-of select="substring(replace($itemID/IdReference[@domain='EAN-13']/@identifier,'^\s+|\s+$',''), 1, 48)"/>
                     </Value>
                  </Part>
               </xsl:when>
            </xsl:choose>
            <!-- Defect IG-3120 -->
            <xsl:if test="$isReceiptRequest = 'yes'">
               <xsl:if test="normalize-space(Batch/SupplierBatchID) != ''">
                  <Part>
                     <Qualifier>B8</Qualifier>
                     <Value>
                        <xsl:value-of select="substring(normalize-space(Batch/SupplierBatchID), 1, 48)"/>
                     </Value>
                  </Part>
               </xsl:if>
               <xsl:if test="normalize-space(Batch/BuyerBatchID) != ''">
                  <Part>
                     <Qualifier>LT</Qualifier>
                     <Value>
                        <xsl:value-of select="substring(normalize-space(Batch/BuyerBatchID), 1, 48)"/>
                     </Value>
                  </Part>
               </xsl:if>
            </xsl:if>
         	<xsl:if test="$isSMI != 'yes' and normalize-space($itemID/IdReference[@domain = 'custSKU']/@identifier) != ''">
               <Part>
                  <Qualifier>SK</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(normalize-space($itemID/IdReference[@domain = 'custSKU']/@identifier), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <!-- IG-4714 -->
         	<xsl:if test="$isSMI != 'yes' and normalize-space($itemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier) != ''">
               <Part>
                  <Qualifier>UP</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(normalize-space($itemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="normalize-space($description) != ''">
               <Part>
                  <Qualifier>PD</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(normalize-space($description), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>
            <!-- IG-16250 -->
            <xsl:if test="replace($itemCategory,'^\s+|\s+$','') != ''">
               <Part>
                  <Qualifier>KB</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(replace($itemCategory,'^\s+|\s+$',''), 1, 48)"/>
                  </Value>
               </Part>
            </xsl:if>            
         </PartsList>
      </xsl:variable>
      <xsl:for-each select="$partsList/PartsList/Part">
         <xsl:choose>
            <xsl:when test="position() = 1">
               <xsl:element name="D_235">
                  <xsl:value-of select="./Qualifier"/>
               </xsl:element>
               <xsl:element name="D_234">
                  <xsl:value-of select="./Value"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="{concat('D_235', '_', position())}">
                  <xsl:value-of select="./Qualifier"/>
               </xsl:element>
               <xsl:element name="{concat('D_234', '_', position())}">
                  <xsl:value-of select="./Value"/>
               </xsl:element>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      <!--xsl:if test="normalize-space($itemID/SupplierPartID)!=''">			<D_235>VP</D_235>			<D_234>				<xsl:value-of select="substring(normalize-space($itemID/SupplierPartID),1,48)"/>			</D_234>		</xsl:if>		<xsl:if test="normalize-space($itemID/BuyerPartID)!=''">			<D_235_2>BP</D_235_2>			<D_234_2>				<xsl:value-of select="substring(normalize-space($itemID/BuyerPartID),1,48)"/>			</D_234_2>		</xsl:if>		<xsl:if test="normalize-space($itemID/SupplierPartAuxiliaryID)!=''">			<D_235_3>VS</D_235_3>			<D_234_3>				<xsl:value-of select="substring(normalize-space($itemID/SupplierPartAuxiliaryID),1,48)"/>			</D_234_3>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/ManufacturerPartID)!=''">			<D_235_4>MG</D_235_4>			<D_234_4>				<xsl:value-of select="substring(normalize-space($itemDetail/ManufacturerPartID),1,48)"/>			</D_234_4>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/ManufacturerName)!=''">			<D_235_5>MF</D_235_5>			<D_234_5>				<xsl:value-of select="substring(normalize-space($itemDetail/ManufacturerName),1,48)"/>			</D_234_5>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/Classification)!=''">			<D_235_6>C3</D_235_6>			<D_234_6>				<xsl:value-of select="substring(normalize-space($itemDetail/Classification[1]),1,48)"/>			</D_234_6>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)!=''">			<D_235_7>EN</D_235_7>			<D_234_7>				<xsl:value-of select="substring(normalize-space($itemDetail/ItemDetailIndustry/ItemDetailRetail/EANID),1,48)"/>			</D_234_7>		</xsl:if>		<xsl:if test="normalize-space($itemID/IdReference[@domain='custSKU']/@identifier)!=''">			<D_235_8>SK</D_235_8>			<D_234_8>				<xsl:value-of select="substring(normalize-space($itemID/IdReference[@domain='custSKU']/@identifier),1,48)"/>			</D_234_8>		</xsl:if-->
   </xsl:template>
   
   <!-- 06292020 CG: IG-20369 IG-20382 -->
   <xsl:template name="MapControlKeys">
      <xsl:param name="keys"/>
      <xsl:param name="level" required="no"/>
      
      <xsl:if test="$keys">
         <xsl:if test="normalize-space($keys/OCInstruction/@value) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>OCValue</D_127>
                  <D_369>
                     <xsl:value-of select="substring(normalize-space($keys/OCInstruction/@value), 1, 45)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="normalize-space($keys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>OCLowerTimeToleranceInDays</D_127>
                  <D_369>
                     <xsl:value-of select="normalize-space($keys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="normalize-space($keys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>OCUpperTimeToleranceInDays</D_127>
                  <D_369>
                     <xsl:value-of select="normalize-space($keys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="$level = 'detail'">
            <xsl:if test="normalize-space($keys/OCInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>OCLowerQtyTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/OCInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
            <xsl:if test="normalize-space($keys/OCInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>OCUpperQtyTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/OCInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
            <xsl:if test="normalize-space($keys/OCInstruction/Lower/Tolerances/PriceTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>OCLowerPriceTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/OCInstruction/Lower/Tolerances/PriceTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
            <xsl:if test="normalize-space($keys/OCInstruction/Upper/Tolerances/PriceTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>OCUpperPriceTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/OCInstruction/Upper/Tolerances/PriceTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
         </xsl:if>
         <xsl:if test="normalize-space($keys/ASNInstruction/@value) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>ASNValue</D_127>
                  <D_369>
                     <xsl:value-of select="substring(normalize-space($keys/ASNInstruction/@value), 1, 45)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="$level = 'detail'">
            <xsl:if test="normalize-space($keys/ASNInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>ASNLowerQtyTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/ASNInstruction/Lower/Tolerances/QuantityTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
            <xsl:if test="normalize-space($keys/ASNInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>ASNUpperQtyTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/ASNInstruction/Upper/Tolerances/QuantityTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
            <xsl:if test="normalize-space($keys/ASNInstruction/Lower/Tolerances/PriceTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>ASNLowerPriceTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/ASNInstruction/Lower/Tolerances/PriceTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
            <xsl:if test="normalize-space($keys/ASNInstruction/Upper/Tolerances/PriceTolerance/Percentage/@percent) != ''">
               <G_N9>
                  <S_N9>
                     <D_128>KD</D_128>
                     <D_127>ASNUpperPriceTolerancePercent</D_127>
                     <D_369>
                        <xsl:value-of select="normalize-space($keys/ASNInstruction/Upper/Tolerances/PriceTolerance/Percentage/@percent)"/>
                     </D_369>
                  </S_N9>
               </G_N9>
            </xsl:if>
         </xsl:if>
         <xsl:if test="normalize-space($keys/InvoiceInstruction/@value) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>INVValue</D_127>
                  <D_369>
                     <xsl:value-of select="substring(normalize-space($keys/InvoiceInstruction/@value), 1, 45)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="normalize-space($keys/InvoiceInstruction/@verificationType) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>
                     <xsl:text>INVVerification</xsl:text>
                  </D_127>
                  <D_369>
                     <xsl:value-of select="substring(normalize-space($keys/InvoiceInstruction/@verificationType), 1, 45)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="normalize-space($keys/InvoiceInstruction/@unitPriceEditable) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>
                     <xsl:text>INV_unitPriceEditable</xsl:text>
                  </D_127>
                  <D_369>
                     <xsl:value-of select="substring(normalize-space($keys/InvoiceInstruction/@unitPriceEditable), 1, 45)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="normalize-space($keys/SESInstruction/@value) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>SESValue</D_127>
                  <D_369>
                     <xsl:value-of select="substring(normalize-space($keys/SESInstruction/@value), 1, 45)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
         <xsl:if test="normalize-space($keys/SESInstruction/@unitPriceEditable) != ''">
            <G_N9>
               <S_N9>
                  <D_128>KD</D_128>
                  <D_127>SES_UnitPriceEditable</D_127>
                  <D_369>
                     <xsl:value-of select="substring(normalize-space($keys/SESInstruction/@unitPriceEditable), 1, 45)"/>
                  </D_369>
               </S_N9>
            </G_N9>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   
   <!-- 07012020 CG: IG-18119 -->
   <xsl:template name="mapPackageDistribution">
      <xsl:param name="pckgDist"></xsl:param>
      
      <xsl:variable name="uomP" select="normalize-space($pckgDist/UnitOfMeasure)"/>
      <xsl:variable name="pUOM">
         <xsl:choose>
            <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomP]/X12Code != ''">
               <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomP]/X12Code"/>
            </xsl:when>
            <xsl:otherwise>ZZ</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="$pUOM!='' and normalize-space($pckgDist/StoreCode)!='' and normalize-space($pckgDist/@quantity) != ''">
         <S_SDQ>
            <D_355>
               <xsl:value-of select="$pUOM"/>
            </D_355>
            <D_66>54</D_66>
            <D_67>
               <xsl:value-of select="substring(normalize-space($pckgDist/StoreCode), 1, 80)"/>
            </D_67>
            <D_380>
               <xsl:value-of select="normalize-space($pckgDist/@quantity)"/>
            </D_380>
         </S_SDQ>
      </xsl:if>
   </xsl:template>
   
   <!-- CG: IG-16765 1500 Extrinsics -->
   <xsl:template name="getLookupValues">
      <xsl:param name="cXMLDocType"/>
      <xsl:variable name="buyerANIDL" select="(/cXML/Header/From/Credential[lower-case(@domain)='networkid']/Identity)[1]"/>
      <xsl:variable name="supplierANIDL" select="(/cXML/Header/To/Credential[lower-case(@domain)='networkid']/Identity)[1]"/>
      <xsl:variable name="buyerSpecificT" select="/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUPTABLE_ALL.xml"/>
      <xsl:variable name="allBuyersT" select="/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUPTABLE_ALL.xml"/>
      <!--xsl:variable name="buyerSpecificT" select="concat('pd', '_', $supplierANIDL, '_LOOKUPTABLE_', $buyerANIDL, '.xml')"/>
      <xsl:variable name="allBuyersT" select="concat('pd', '_', $supplierANIDL, '_LOOKUPTABLE_ALL.xml')"/-->
      <xsl:variable name="lookupFileT">
         <xsl:choose>
            <xsl:when test="doc-available($buyerSpecificT)">
               <xsl:value-of select="$buyerSpecificT"/>
            </xsl:when>
            <xsl:when test="doc-available($allBuyersT)">
               <xsl:value-of select="$allBuyersT"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'NotAvailable'"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <MappingLookup>
         <xsl:choose>
            <xsl:when test="$lookupFileT!='NotAvailable'">
               <xsl:variable name="lookupTable" select="document($lookupFileT)"/>
               <EnableStandardExtrinsics>
                  <xsl:value-of select="$lookupTable/LOOKUPTABLE/Parameter[Name='EnableStandardExtrinsics' and DocumentType = $cXMLDocType][1]/ListOfItems/Item[Name = 'ASC-X12']/Value"/>
               </EnableStandardExtrinsics>
            </xsl:when>
         </xsl:choose>
      </MappingLookup>
   </xsl:template>
   
   <xsl:template name="createISA">
      <xsl:param name="dateNow"/>
      <xsl:variable name="subFieldDelim">
         <xsl:call-template name="findDelimeter"/>
      </xsl:variable>
      <S_ISA>
         <D_I01>00</D_I01>
         <D_I02>
            <xsl:value-of select="'          '"/>
         </D_I02>
         <D_I03>00</D_I03>
         <D_I04>
            <xsl:value-of select="'          '"/>
         </D_I04>
         <D_I05_1>
            <xsl:choose>
               <xsl:when test="$anISASenderQual != ''">
                  <xsl:value-of select="$anISASenderQual"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>ZZ</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </D_I05_1>
         <D_I06>
            <xsl:choose>
               <xsl:when test="$anISASender != ''">
                  <xsl:value-of select="concat($anISASender, substring('               ', 1, 15 - string-length($anISASender)))"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat('ARIBA', substring('               ', 1, 15 - string-length('ARIBA')))"/>
               </xsl:otherwise>
            </xsl:choose>
         </D_I06>
         <D_I05_2>
            <xsl:choose>
               <xsl:when test="$anISAReceiverQual != ''">
                  <xsl:value-of select="$anISAReceiverQual"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>ZZ</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </D_I05_2>
         <D_I07>
            <xsl:choose>
               <xsl:when test="$anISAReceiver != ''">
                  <xsl:value-of select="concat($anISAReceiver, substring('               ', 1, 15 - string-length($anISAReceiver)))"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat('ARIBA', substring('               ', 1, 15 - string-length('ARIBA')))"/>
               </xsl:otherwise>
            </xsl:choose>
         </D_I07>
         <D_I08>
            <xsl:value-of select="format-dateTime($dateNow, '[Y01][M01][D01]')"/>
         </D_I08>
         <D_I09>
            <xsl:value-of select="format-dateTime($dateNow, '[H01][m01]')"/>
         </D_I09>
         <D_I10>U</D_I10>
         <D_I11>
            <xsl:text>00401</xsl:text>
         </D_I11>
         <D_I12>
            <xsl:value-of select="$anICNValue"/>
         </D_I12>
         <D_I13>0</D_I13>
         <D_I14>
            <xsl:choose>
               <xsl:when test="upper-case($anEnvName) = 'PROD'">
                  <xsl:text>P</xsl:text>
               </xsl:when>
               <xsl:when test="upper-case($anEnvName) = 'TEST'">
                  <xsl:text>T</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>P</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </D_I14>
         <D_I15>
            <xsl:value-of select="$subFieldDelim"/>
         </D_I15>
      </S_ISA>
   </xsl:template>
   <xsl:template name="findDelimeter" match="node() | @*">
      <xsl:param name="characters" as="xs:string*" select="'*', '~', '^', '|', '%', '!', ')', '(', '$', '#', ':', '&gt;', '&lt;'"/>
      <xsl:variable name="nodes-to-inspect" as="node()*" select="//text() | //@*"/>
      <xsl:call-template name="FormatDelimiters">
         <xsl:with-param name="delimToUse" select="               string-join(for $delimTest in $characters               return                  $delimTest[not($nodes-to-inspect[contains(., $delimTest)])], ',')"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="FormatDelimiters">
      <xsl:param name="delimToUse"/>
      <xsl:variable name="tokenizeDelim" select="tokenize($delimToUse, ',')"/>
      <xsl:choose>
         <xsl:when test="number(count($tokenizeDelim)) &gt; 3">
            
            
            
            <xsl:value-of select="$tokenizeDelim[3]"/>
         </xsl:when>
         <xsl:otherwise>
            
            
            
            <xsl:value-of select="'¦'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
