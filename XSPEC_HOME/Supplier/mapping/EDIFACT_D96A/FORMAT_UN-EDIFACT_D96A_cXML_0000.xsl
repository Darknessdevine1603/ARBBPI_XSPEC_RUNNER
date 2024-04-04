<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
               <xsl:value-of select="concat(substring($dateTime, 0, 12), '00', substring($dateTime, 12))"/>
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
                  <xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode != ''">
                     <xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode"/>
                  </xsl:when>
                  <xsl:otherwise>+00:00</xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>+00:00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"/>
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
                  <xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 13)]/CXMLCode != ''">
                     <xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 13)]/CXMLCode"/>
                  </xsl:when>
                  <xsl:otherwise/>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="$dateTimeFormat = '304'">
               <xsl:choose>
                  <xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 15)]/CXMLCode != ''">
                     <xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($dateTime, 15)]/CXMLCode"/>
                  </xsl:when>
                  <xsl:otherwise/>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$dtmFormat = '102'">
            <xsl:value-of select="concat(substring($dateTime, 0, 5), '-', substring($dateTime, 5, 2), '-', substring($dateTime, 7, 2))"/>
         </xsl:when>
         <xsl:when test="$dtmFormat = '203' or $dateTimeFormat = '303'">
            <xsl:value-of select="concat(substring($dateTime, 0, 5), '-', substring($dateTime, 5, 2), '-', substring($dateTime, 7, 2), 'T', substring($dateTime, 9, 2), ':', substring($dateTime, 11, 2), $timeZone)"/>
         </xsl:when>
         <xsl:when test="$dtmFormat = '204' or $dateTimeFormat = '304'">
            <xsl:value-of select="concat(substring($dateTime, 0, 5), '-', substring($dateTime, 5, 2), '-', substring($dateTime, 7, 2), 'T', substring($dateTime, 9, 2), ':', substring($dateTime, 11, 2), ':', substring($dateTime, 13, 2), $timeZone)"/>
         </xsl:when>
      </xsl:choose>
      <!--xsl:value-of select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"/-->
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
               <xsl:value-of select="$lookups/Lookups/Countries/Country[phoneCode = $cCode]/countryCode"/>
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
   <xsl:template name="createMoney">
      <xsl:param name="MOA"/>
      <xsl:param name="altMOA"/>
      <xsl:param name="isCreditMemo"/>
      <xsl:element name="Money">
         <xsl:attribute name="currency">
            <xsl:value-of select="$MOA/D_6345"/>
         </xsl:attribute>
         <xsl:if test="$altMOA">
            <xsl:if test="$altMOA/D_5004 != ''">
               <xsl:attribute name="alternateAmount">
                  <xsl:choose>
                     <xsl:when test="$isCreditMemo = 'yes'">
                        <xsl:value-of select="concat('-', $altMOA/D_5004)"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$altMOA/D_5004"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </xsl:if>
            <xsl:if test="$altMOA/D_6345 != ''">
               <xsl:attribute name="alternateCurrency">
                  <xsl:value-of select="$altMOA/D_6345"/>
               </xsl:attribute>
            </xsl:if>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$isCreditMemo = 'yes'">
               <xsl:value-of select="concat('-', $MOA/D_5004)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$MOA/D_5004"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createMoneyCux">
      <xsl:param name="MOAGRP"/>
      <xsl:param name="isCreditMemo"/>
      <xsl:element name="Money">
         <xsl:attribute name="currency">
            <xsl:value-of select="$MOAGRP/S_MOA/C_C516/D_6345"/>
         </xsl:attribute>
         <xsl:if test="$MOAGRP/S_CUX[C_C504/D_6347 = '3']/D_5402 != ''">
            <xsl:attribute name="alternateAmount">
               <xsl:choose>
                  <xsl:when test="$isCreditMemo = 'yes'">
                     <xsl:value-of select="concat('-', $MOAGRP/S_CUX[C_C504/D_6347 = '3']/D_5402)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$MOAGRP/S_CUX[C_C504/D_6347 = '3']/D_5402"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="$MOAGRP/S_CUX/C_C504[D_6347 = '3']/D_6345 != ''">
            <xsl:attribute name="alternateCurrency">
               <xsl:value-of select="$MOAGRP/S_CUX/C_C504[D_6347 = '3']/D_6345"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$isCreditMemo = 'yes'">
               <xsl:value-of select="concat('-', $MOAGRP/S_MOA/C_C516/D_5004)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$MOAGRP/S_MOA/C_C516/D_5004"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createMoneyAlt">
      <xsl:param name="value"/>
      <xsl:param name="altvalue"/>
      <xsl:param name="cur"/>
      <xsl:param name="altcur"/>
      <xsl:param name="isCreditMemo"/>
      <xsl:element name="Money">
         <xsl:attribute name="currency">
            <xsl:value-of select="$cur"/>
         </xsl:attribute>
         <xsl:if test="$altvalue">
            <xsl:attribute name="alternateAmount">
               <xsl:choose>
                  <xsl:when test="$isCreditMemo = 'yes'">
                     <xsl:value-of select="concat('-', $altvalue)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$altvalue"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:if test="$altcur != ''">
               <xsl:attribute name="alternateCurrency">
                  <xsl:value-of select="$altcur"/>
               </xsl:attribute>
            </xsl:if>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$isCreditMemo = 'yes'">
               <xsl:value-of select="concat('-', $value)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$value"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template name="CommunicationInfo">
      <xsl:param name="role"/>
      <xsl:variable name="comName">
         <xsl:value-of select="../S_CTA/D_3139"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="C_C076/D_3155 = 'EM'">
            <xsl:element name="Email">
               <xsl:attribute name="name">
                  <xsl:choose>
                     <xsl:when test="$comName = 'ZZZ'">
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
         <xsl:when test="C_C076/D_3155 = 'TE'">
            <xsl:element name="Phone">
               <xsl:attribute name="name">
                  <xsl:choose>
                     <xsl:when test="$comName = 'ZZZ'">
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
         <xsl:when test="C_C076/D_3155 = 'FX'">
            <xsl:element name="Fax">
               <xsl:attribute name="name">
                  <xsl:choose>
                     <xsl:when test="$comName = 'ZZZ'">
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
         <xsl:when test="C_C076/D_3155 = 'AH'">
            <xsl:element name="URL">
               <xsl:attribute name="name">
                  <xsl:choose>
                     <xsl:when test="$comName = 'ZZZ'">
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
   </xsl:template>
   <xsl:template match="G_SG2 | G_SG3 | G_SG37 | G_SG34 | G_SG1">
      <xsl:param name="role"/>
      <xsl:param name="cMode"/>
      <xsl:param name="buildAddressElement"/>
      <xsl:variable name="rootContact">
         <xsl:choose>
            <xsl:when test="$buildAddressElement = 'true'">
               <xsl:text>Address</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>Contact</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$rootContact}">
         <xsl:if test="not($buildAddressElement)">
            <xsl:attribute name="role">
               <xsl:choose>
                  <xsl:when test="$role = 'ST' and $cMode = 'replenishDoc'">
                     <xsl:text>locationTo</xsl:text>
                  </xsl:when>
                  <xsl:when test="$role = 'SU' and $cMode = 'replenishDoc'">
                     <xsl:text>locationFrom</xsl:text>
                  </xsl:when>
                  <xsl:when test="$role = 'GY' and $cMode = 'replenishDoc'">
                     <xsl:text>inventoryOwner</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="S_NAD/C_C082/D_1131 = '160' or S_NAD/C_C082/D_1131 = 'ZZZ'">
            <xsl:variable name="addrDomain">
               <xsl:value-of select="S_NAD/C_C082/D_3055"/>
            </xsl:variable>
            <xsl:if test="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]">
               <xsl:attribute name="addressID">
                  <xsl:value-of select="S_NAD/C_C082/D_3039"/>
               </xsl:attribute>
               <xsl:if test="$addrDomain != 91 and $addrDomain != 92">
                  <xsl:attribute name="addressIDDomain">
                     <xsl:value-of select="normalize-space($lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]/CXMLCode)"/>
                  </xsl:attribute>
               </xsl:if>
            </xsl:if>
         </xsl:if>
         <xsl:element name="Name">
            <xsl:attribute name="xml:lang">en</xsl:attribute>
            <xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
         </xsl:element>
         <!-- PostalAddress -->
         <xsl:if test="S_NAD/D_3164 != ''">
            <xsl:element name="PostalAddress">
               <!-- <xsl:attribute name="name"/> -->
               <xsl:if test="S_NAD/C_C080/D_3036 != ''">
                  <xsl:element name="DeliverTo">
                     <xsl:value-of select="S_NAD/C_C080/D_3036"/>
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
               <xsl:if test="S_NAD/C_C059/D_3042 != ''">
                  <xsl:element name="Street">
                     <xsl:value-of select="S_NAD/C_C059/D_3042"/>
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
               <xsl:variable name="stateCode">
                  <xsl:value-of select="S_NAD/D_3229"/>
               </xsl:variable>
               <xsl:if test="$stateCode != ''">
                  <xsl:element name="State">
                     <xsl:attribute name="isoStateCode">
                        <xsl:value-of select="$stateCode"/>
                     </xsl:attribute>
                     <xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCode]/stateName"/>
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
         <xsl:for-each select=".//S_COM[C_C076/D_3155 = 'EM']">
            <xsl:call-template name="CommunicationInfo">
               <xsl:with-param name="role" select="$role"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select=".//S_COM[C_C076/D_3155 = 'TE']">
            <xsl:call-template name="CommunicationInfo">
               <xsl:with-param name="role" select="$role"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select=".//S_COM[C_C076/D_3155 = 'FX']">
            <xsl:call-template name="CommunicationInfo">
               <xsl:with-param name="role" select="$role"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select=".//S_COM[C_C076/D_3155 = 'AH']">
            <xsl:call-template name="CommunicationInfo">
               <xsl:with-param name="role" select="$role"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="$cMode = 'partner'">
            <xsl:for-each select="G_SG3">
               <xsl:choose>
                  <xsl:when test="S_RFF/C_C506[D_1153 = 'AGU']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">memberNumber</xsl:attribute>
                        <xsl:value-of select="S_RFF/C_C506[D_1153 = 'AGU']/D_1154"/>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="S_RFF/C_C506[D_1153 = 'AIH']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">transactionReference</xsl:attribute>
                        <xsl:value-of select="S_RFF/C_C506[D_1153 = 'AIH']/D_1154"/>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="S_RFF/C_C506[D_1153 = 'FC']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">fiscalNumber</xsl:attribute>
                        <xsl:value-of select="S_RFF/C_C506[D_1153 = 'FC']/D_1154"/>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="S_RFF/C_C506[D_1153 = 'IA']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">vendorNumber</xsl:attribute>
                        <xsl:value-of select="S_RFF/C_C506[D_1153 = 'IA']/D_1154"/>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="S_RFF/C_C506[D_1153 = 'IT']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">companyCode</xsl:attribute>
                        <xsl:value-of select="S_RFF/C_C506[D_1153 = 'IT']/D_1154"/>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154 != ''">
                     <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154"/>
                        </xsl:attribute>
                        <xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_4000"/>
                     </xsl:element>
                  </xsl:when>
               </xsl:choose>
            </xsl:for-each>
         </xsl:if>
         <xsl:if test="$cMode = 'replenishDoc'">
            <xsl:choose>
               <xsl:when test="$role = 'ST' or $role = 'SU'">
                  <IdReference>
                     <xsl:attribute name="domain">
                        <xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153 = 'WS']/D_1154"/>
                     </xsl:attribute>
                     <xsl:attribute name="identifier">
                        <xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153 = 'WS']/D_4000"/>
                     </xsl:attribute>
                  </IdReference>
               </xsl:when>
               <xsl:when test="$role = 'GY'">
                  <IdReference>
                     <xsl:attribute name="domain">
                        <xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153 = 'AEN']/D_1154"/>
                     </xsl:attribute>
                     <xsl:attribute name="identifier">
                        <xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153 = 'AEN']/D_4000"/>
                     </xsl:attribute>
                  </IdReference>
               </xsl:when>
            </xsl:choose>
         </xsl:if>
      </xsl:element>
      <xsl:if test="$cMode = 'partner'">
         <xsl:for-each select="G_SG3[S_RFF/C_C506/D_1153 != 'ZZZ']">
            <xsl:choose>
               <xsl:when test="$role = 'RE' and S_RFF/C_C506[D_1153 = 'AHP']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">supplierTaxID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AHP']/D_1154"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="$role = 'RE' and S_RFF/C_C506[D_1153 = 'PY']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">accountID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'PY']/D_1154"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="$role = 'RE' and S_RFF/C_C506[D_1153 = 'RT']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">bankRoutingID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'RT']/D_1154"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">vatID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="S_RFF/C_C506[D_1153 = 'TL']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">taxExemptionID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'TL']/D_1154"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="S_RFF/C_C506[D_1153 = 'AMT']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">gstID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AMT']/D_1154"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="S_RFF/C_C506[D_1153 = 'AP']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">accountReceivableID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AP']/D_1154"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="S_RFF/C_C506[D_1153 = 'AV']/D_1154 != ''">
                  <xsl:element name="IdReference">
                     <xsl:attribute name="domain">accountPayableID</xsl:attribute>
                     <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AV']/D_1154"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <xsl:template name="createShippingMark">
      <xsl:param name="PCIGrp"/>
      <xsl:if test="$PCIGrp/C_C210/D_7102_1 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_1"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_2 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_2"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_3 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_3"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_4 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_4"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_5 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_5"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_6 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_6"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_7 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_7"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_8 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_8"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_9 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_9"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$PCIGrp/C_C210/D_7102_10 != ''">
         <xsl:element name="ShippingMark">
            <xsl:value-of select="$PCIGrp/C_C210/D_7102_10"/>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <xsl:template name="Packaging">
      <xsl:param name="CPSGrp"/>
      <xsl:param name="packLevelCode"/>
      <xsl:param name="maxLevel" select="0"/>
      <xsl:variable name="curCPSParent" select="$CPSGrp/S_CPS/D_7166"/>
      <xsl:variable name="serialCode" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]/G_SG11/G_SG13/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208_1/D_7402_1"/>
      <xsl:if test="$packLevelCode &gt; 1">
         <xsl:call-template name="Packaging">
            <xsl:with-param name="CPSGrp" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]"/>
            <xsl:with-param name="packLevelCode" select="$packLevelCode - 1"/>
            <xsl:with-param name="maxLevel" select="$maxLevel"/>
         </xsl:call-template>
      </xsl:if>
      <xsl:variable name="serialCodes">
         <xsl:for-each select="$CPSGrp/G_SG11/G_SG13/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
            <xsl:variable name="startSerial" select="D_7402_1"/>
            <xsl:variable name="endSerial">
               <xsl:choose>
                  <xsl:when test="D_7402_2 != ''">
                     <xsl:value-of select="D_7402_2"/>
                  </xsl:when>
                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="$endSerial=0 and $startSerial!=''">
                  <Serial>
                     <xsl:value-of select="$startSerial"/>
                  </Serial>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="generateSerialCodes">
                     <xsl:with-param name="startSerial" select="$startSerial"/>
                     <xsl:with-param name="endSerial" select="$endSerial"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:for-each select="$serialCodes/Serial">
         <xsl:element name="Packaging">
            <xsl:choose>
               <xsl:when test="$CPSGrp/G_SG11/S_PAC/C_C202/D_7064 != ''">
                  <xsl:element name="PackagingCode">
                     <xsl:attribute name="xml:lang" select="'en'"/>
                     <xsl:value-of select="$CPSGrp/G_SG11/S_PAC/C_C202/D_7064"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $CPSGrp/G_SG11/S_PAC/C_C202/D_7065]/CXMLCode != ''">
                  <xsl:element name="PackagingCode">
                     <xsl:attribute name="xml:lang" select="'en'"/>
                     <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $CPSGrp/G_SG11/S_PAC/C_C202/D_7065]/CXMLCode"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
            <xsl:for-each select="$CPSGrp/G_SG11/S_MEA[D_6311 = 'AAE']">
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
            <xsl:choose>
               <xsl:when test="$packLevelCode = $maxLevel">
                  <Description type="Material" xml:lang="en-US"/>
               </xsl:when>
               <xsl:otherwise>
                  <Description type="Packaging" xml:lang="en-US"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="PackagingLevelCode">
               <xsl:value-of select="format-number($packLevelCode, '0000')"/>
            </xsl:element>
            <xsl:if test="$CPSGrp/G_SG11/S_PAC/C_C202/D_7065 != ''">
               <xsl:element name="PackageTypeCodeIdentifierCode">
                  <xsl:value-of select="$CPSGrp/G_SG11/S_PAC/C_C202/D_7065"/>
               </xsl:element>
            </xsl:if>
            <xsl:element name="ShippingContainerSerialCode">
               <xsl:value-of select="."/>
            </xsl:element>
            <xsl:if test="$serialCode">
               <xsl:element name="ShippingContainerSerialCodeReference">
                  <xsl:value-of select="$serialCode"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$CPSGrp/G_SG11/S_PAC/D_7224 = '1'">
               <xsl:if test="($CPSGrp/G_SG11/G_SG13[S_PCI/D_4233 = 'ZZZ']/G_SG14/S_GIN[D_7405 = 'ML']/C_C208/D_7402)[1] != ''">
                  <xsl:element name="PackageID">
                     <xsl:element name="GlobalIndividualAssetID">
                        <xsl:value-of select="($CPSGrp/G_SG11/G_SG13[S_PCI/D_4233 = 'ZZZ']/G_SG14/S_GIN[D_7405 = 'ML']/C_C208/D_7402)[1]"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
            </xsl:if>
            <xsl:for-each select="$CPSGrp/G_SG11">
               <xsl:for-each select="G_SG13[S_PCI/D_4233 = '30' or S_PCI/D_4233 = '17']">
                  <xsl:call-template name="createShippingMark">
                     <xsl:with-param name="PCIGrp" select="S_PCI"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:if test="$CPSGrp/G_SG11/S_QTY/C_C186[D_6063 = '52']/D_6060 != ''">
               <xsl:element name="DispatchQuantity">
                  <xsl:attribute name="quantity">
                     <xsl:value-of select="$CPSGrp/G_SG11/S_QTY/C_C186[D_6063 = '52']/D_6060"/>
                  </xsl:attribute>
                  <xsl:element name="UnitOfMeasure">
                     <xsl:choose>
                        <xsl:when test="$CPSGrp/G_SG11/S_QTY/C_C186[D_6063 = '52']/D_6411 != ''">
                           <xsl:value-of select="$CPSGrp/G_SG11/S_QTY/C_C186[D_6063 = '52']/D_6411"/>
                        </xsl:when>
                        <xsl:otherwise>EA</xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
               </xsl:element>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="findMaxPackLevelCode">
      <xsl:param name="currCPSParent"/>
      <xsl:param name="currCPS"/>
      <xsl:param name="counter" select="0"/>
      <xsl:choose>
         <xsl:when test="$currCPS=$currCPSParent">
            <xsl:value-of select="$counter + 1"/>
         </xsl:when>
         <xsl:when test="$currCPSParent and exists(//G_SG10/S_CPS[D_7164 = $currCPSParent])">
            <xsl:call-template name="findMaxPackLevelCode">
               <xsl:with-param name="currCPSParent" select="//G_SG10/S_CPS[D_7164 = $currCPSParent]/D_7166"/>
               <xsl:with-param name="currCPS" select="$currCPSParent"></xsl:with-param>
               <xsl:with-param name="counter" select="$counter + 1"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$counter + 1"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="generateSerialCodes">
      <xsl:param name="endSerial" as="xs:integer" select="1"/>
      <xsl:param name="startSerial" as="xs:integer"/>
      <Serial>
         <xsl:value-of select="$startSerial"/>
      </Serial>
      <xsl:if test="$endSerial and $endSerial > $startSerial">
         <xsl:call-template name="generateSerialCodes">
            <xsl:with-param name="endSerial" select="$endSerial"/>
            <xsl:with-param name="startSerial" select="$startSerial + 1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="mapSequence41">
      <xsl:param name="SG20GRP"/>
      <xsl:param name="packTypeIdCode"/>
      <xsl:param name="packLevelCode"/>
      <xsl:param name="maxPackLevel"/>
      <xsl:param name="shipSerialCode"/>
      <xsl:param name="currCPSGrp"/>
      <xsl:param name="parentType"/>
      <xsl:param name="isSinglePacklvl"/>
      <xsl:for-each select="$SG20GRP/G_SG21[S_GIN/D_7405 = 'BJ' or S_GIN/D_7405 = 'AW'][S_GIN/C_C208_1/D_7402_1 != ''][count(S_GIN/*) = 2][count(S_GIN/C_C208_1/*) >= 1]">
         <!--  All serial numbers supported-->
         <xsl:variable name="serialCodes">
            <xsl:for-each select="S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
               <xsl:variable name="startSerial" select="D_7402_1"/>
               <xsl:variable name="endSerial">
                  <xsl:choose>
                     <xsl:when test="D_7402_2 != ''">
                        <xsl:value-of select="D_7402_2"/>
                     </xsl:when>
                     <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="$endSerial=0 and $startSerial!=''">
                     <Serial>
                        <xsl:value-of select="$startSerial"/>
                     </Serial>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="generateSerialCodes">
                        <xsl:with-param name="startSerial" select="$startSerial"/>
                        <xsl:with-param name="endSerial" select="$endSerial"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:variable>
         <xsl:for-each select="$serialCodes/Serial">
            <xsl:element name="Packaging">
               <xsl:choose>
                  <xsl:when test="$packLevelCode != $maxPackLevel and $lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode != ''">
                     <xsl:element name="PackagingCode">
                        <xsl:attribute name="xml:lang" select="'en'"/>
                        <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode"/>
                     </xsl:element>
                  </xsl:when>
               </xsl:choose>
               <!--xsl:if test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode != ''">                  <xsl:element name="PackagingCode">                     <xsl:attribute name="xml:lang" select="'en'"/>                     <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode"/>                  </xsl:element>               </xsl:if-->
               <xsl:choose>
                  <xsl:when test="$parentType = '412' and $currCPSGrp/S_CPS/D_7164='1'">
                     <xsl:for-each select="$SG20GRP/S_MEA[D_6311 = 'AAE']">
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
                  </xsl:when>
                  <xsl:when test="$parentType = '411'">
                     <xsl:for-each select="$SG20GRP/S_MEA[D_6311 = 'AAE']">
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
                  </xsl:when>
                  <xsl:when test="$parentType = '412'">
                     <xsl:for-each select="$currCPSGrp/G_SG11">
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
                     </xsl:for-each>
                  </xsl:when>
               </xsl:choose>
               <xsl:choose>
                  <xsl:when test="$packLevelCode = $maxPackLevel or $isSinglePacklvl='true'">
                     <Description type="Material" xml:lang="en-US"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <Description type="Packaging" xml:lang="en-US"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:if test="$maxPackLevel &gt; 1">
                  <xsl:element name="PackagingLevelCode">
                     <xsl:value-of select="format-number($maxPackLevel, '0000')"/>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$packTypeIdCode != '' and $packLevelCode != $maxPackLevel">
                  <xsl:element name="PackageTypeCodeIdentifierCode">
                     <xsl:value-of select="$packTypeIdCode"/>
                  </xsl:element>
               </xsl:if>
               <xsl:element name="ShippingContainerSerialCode">
                  <xsl:value-of select="."/>
               </xsl:element>
               <xsl:if test="$shipSerialCode != ''">
                  <xsl:element name="ShippingContainerSerialCodeReference">
                     <xsl:value-of select="$shipSerialCode"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$SG20GRP[S_PCI/D_4233 = '30']">
                  <xsl:call-template name="createShippingMark">
                     <xsl:with-param name="PCIGrp" select="S_PCI"/>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:if test="$SG20GRP/S_QTY/C_C186[D_6063 = '52' or D_6063 = '12']/D_6060 != ''">
                  <xsl:element name="DispatchQuantity">
                     <xsl:attribute name="quantity">
                        <xsl:value-of select="$SG20GRP/S_QTY/C_C186[D_6063 = '52' or D_6063 = '12']/D_6060"/>
                     </xsl:attribute>
                     <xsl:element name="UnitOfMeasure">
                        <xsl:choose>
                           <xsl:when test="$SG20GRP/S_QTY/C_C186[D_6063 = '52' or D_6063 = '12']/D_6411 != ''">
                              <xsl:value-of select="$SG20GRP/S_QTY/C_C186[D_6063 = '52' or D_6063 = '12']/D_6411"/>
                           </xsl:when>
                           <xsl:otherwise>EA</xsl:otherwise>
                        </xsl:choose>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$SG20GRP/S_DTM/C_C507[D_2005 = '361']/D_2380 != ''">
                  <xsl:element name="BestBeforeDate">
                     <xsl:attribute name="date">
                        <xsl:call-template name="convertToAribaDate">
                           <xsl:with-param name="dateTime">
                              <xsl:value-of select="$SG20GRP/S_DTM/C_C507[D_2005 = '361']/D_2380"/>
                           </xsl:with-param>
                           <xsl:with-param name="dateTimeFormat">
                              <xsl:value-of select="$SG20GRP/S_DTM/C_C507[D_2005 = '361']/D_2379"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:attribute>
                  </xsl:element>
               </xsl:if>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="mapSequence42">
      <xsl:param name="currCPSGrp"/>
      <xsl:param name="itemQty"/>
      <xsl:param name="itemUOM"/>
      <xsl:param name="packLevelCode"/>
      <xsl:param name="isSinglePacklvl"/>
      <xsl:param name="maxLevel" select="0"/>
      <xsl:variable name="curCPSParent" select="$currCPSGrp/S_CPS/D_7166"/>
      <xsl:variable name="curCPS" select="$currCPSGrp/S_CPS/D_7164"/>
      <xsl:variable name="shipSerialRef">
         <xsl:choose>
            <xsl:when test="$curCPSParent!=1">
               <xsl:value-of select="//G_SG10[S_CPS/D_7164 = $curCPSParent]/G_SG11[exists(S_PAC)]/G_SG13[S_PCI/D_4233 = '30']/G_SG14/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208_1/D_7402_1"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="$packLevelCode != 1 and $packLevelCode != 0">
         <xsl:call-template name="mapSequence42">
            <xsl:with-param name="currCPSGrp" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]"/>
            <xsl:with-param name="packLevelCode" select="$packLevelCode - 1"> </xsl:with-param>
            <xsl:with-param name="maxLevel" select="$maxLevel"/>
         </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="$currCPSGrp/G_SG11">
         <xsl:variable name="packTypeIdCode" select="S_PAC/C_C202/D_7065"/>
         <xsl:variable name="packType" select="S_PAC/C_C202/D_7064"/>
         <xsl:variable name="serialCodes">
            <xsl:for-each select="G_SG13">
               <xsl:for-each select="G_SG14">
                  <xsl:for-each select="S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
                     <xsl:variable name="startSerial" select="D_7402_1"/>
                     <xsl:variable name="endSerial">
                        <xsl:choose>
                           <xsl:when test="D_7402_2 != ''">
                              <xsl:value-of select="D_7402_2"/>
                           </xsl:when>
                           <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:choose>
                        <xsl:when test="$endSerial=0 and $startSerial!=''">
                           <Serial>
                              <xsl:value-of select="$startSerial"/>
                           </Serial>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:call-template name="generateSerialCodes">
                              <xsl:with-param name="startSerial" select="$startSerial"/>
                              <xsl:with-param name="endSerial" select="$endSerial"/>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:variable>
         <xsl:variable name="SG11Grp" select="."/>
         <xsl:for-each select="$serialCodes/Serial">
            <xsl:element name="Packaging">
               <xsl:element name="PackagingCode">
                  <xsl:attribute name="xml:lang" select="'en'"/>
                  <xsl:choose>
                     <xsl:when test="$packType!=''">
                        <xsl:value-of select="$packType"/>
                     </xsl:when>
                     <xsl:when test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode != ''">
                        <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode"/>
                     </xsl:when>
                     </xsl:choose>
               </xsl:element>
               <xsl:for-each select="$SG11Grp/S_MEA[D_6311 = 'AAE']">
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
               <xsl:choose>
                  <xsl:when test="$packLevelCode = $maxLevel or $isSinglePacklvl='true'">
                     <Description type="Material" xml:lang="en-US"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <Description type="Packaging" xml:lang="en-US"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:if test="string($packLevelCode) != '' and $isSinglePacklvl!='true'">
                  <xsl:element name="PackagingLevelCode">
                     <xsl:value-of select="format-number($packLevelCode, '0000')"/>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$packTypeIdCode != ''">
                  <xsl:element name="PackageTypeCodeIdentifierCode">
                     <xsl:value-of select="$packTypeIdCode"/>
                  </xsl:element>
               </xsl:if>
               <xsl:element name="ShippingContainerSerialCode">
                  <xsl:value-of select="."/>
               </xsl:element>
               <xsl:if test="$shipSerialRef != ''">
                  <xsl:element name="ShippingContainerSerialCodeReference">
                     <xsl:value-of select="$shipSerialRef"/>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$SG11Grp/S_PAC/D_7224 = '1'">
                  <xsl:if test="($SG11Grp/G_SG13[S_PCI/D_4233 = 'ZZZ']/G_SG14/S_GIN[D_7405 = 'ML']/C_C208_1/D_7402_1)[1] != ''">
                     <xsl:element name="PackageID">
                        <xsl:element name="GlobalIndividualAssetID">
                           <xsl:value-of select="($SG11Grp/G_SG13[S_PCI/D_4233 = 'ZZZ']/G_SG14/S_GIN[D_7405 = 'ML']/C_C208_1/D_7402_1)[1]"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
               </xsl:if>
               <xsl:for-each select="$SG11Grp/G_SG13[S_PCI/D_4233 = '30']">
                  <xsl:call-template name="createShippingMark">
                     <xsl:with-param name="PCIGrp" select="S_PCI"/>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:choose>
                  <xsl:when test="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6060 != ''">
                     <xsl:element name="DispatchQuantity">
                        <xsl:attribute name="quantity">
                           <xsl:value-of select="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6060"/>
                        </xsl:attribute>
                        <xsl:element name="UnitOfMeasure">
                           <xsl:choose>
                              <xsl:when test="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6411 != ''">
                                 <xsl:value-of select="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6411"/>
                              </xsl:when>
                              <xsl:otherwise>EA</xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6060 != ''">
                     <xsl:element name="DispatchQuantity">
                        <xsl:attribute name="quantity">
                           <xsl:value-of select="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6060"/>
                        </xsl:attribute>
                        <xsl:element name="UnitOfMeasure">
                           <xsl:choose>
                              <xsl:when test="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6411 != ''">
                                 <xsl:value-of select="$SG11Grp/S_QTY/C_C186[D_6063 = '52']/D_6411"/>
                              </xsl:when>
                              <xsl:otherwise>EA</xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="$SG11Grp/S_PAC/D_7224 = '1' and $itemQty != '' and $itemUOM != ''">
                     <xsl:element name="DispatchQuantity">
                        <xsl:attribute name="quantity" select="$itemQty"/>
                        <xsl:element name="UnitOfMeasure">
                           <xsl:value-of select="$itemUOM"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:when>
               </xsl:choose>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="mapSequence43">
      <xsl:param name="packLvlCode"/>
      <xsl:param name="packTypeIdCode"/>
      <xsl:param name="shipSerialCode"/>
      <xsl:param name="maxLevel" select="0"/>
      <xsl:element name="Packaging">
         <xsl:if test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode != ''">
            <xsl:element name="PackagingCode">
               <xsl:attribute name="xml:lang" select="'en'"/>
               <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $packTypeIdCode]/CXMLCode"/>
            </xsl:element>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$packLvlCode = $maxLevel">
               <Description type="Material" xml:lang="en-US"/>
            </xsl:when>
            <xsl:otherwise>
               <Description type="Packaging" xml:lang="en-US"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:element name="PackagingLevelCode">
            <xsl:value-of select="format-number($packLvlCode, '0000')"/>
         </xsl:element>
         <xsl:if test="$packTypeIdCode != ''">
            <xsl:element name="PackageTypeCodeIdentifierCode">
               <xsl:value-of select="$packTypeIdCode"/>
            </xsl:element>
         </xsl:if>
         <xsl:if test="$shipSerialCode != ''">
            <xsl:element name="ShippingContainerSerialCodeReference">
               <xsl:value-of select="$shipSerialCode"/>
            </xsl:element>
         </xsl:if>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
