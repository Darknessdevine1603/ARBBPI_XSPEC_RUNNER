<?xml version="1.0"?>
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
                    <xsl:value-of select="concat($dateTime, '000000')"/>
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
                        <xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EANCOMCode = substring($tempDateTime, 15)]/CXMLCode != ''">
                            <xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EANCOMCode = substring($tempDateTime, 15)]/CXMLCode"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$anSenderDefaultTimeZone"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$anSenderDefaultTimeZone"/>
                </xsl:otherwise>
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
                        <xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EANCOMCode = substring($dateTime, 13)]/CXMLCode != ''">
                            <xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EANCOMCode = substring($dateTime, 13)]/CXMLCode"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$dateTimeFormat = '304'">
                    <xsl:choose>
                        <xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EANCOMCode = substring($dateTime, 15)]/CXMLCode != ''">
                            <xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EANCOMCode = substring($dateTime, 15)]/CXMLCode"/>
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
                            <xsl:when test="$comName = 'IC' or $comName = 'SD' or $comName = 'ZZZ'">
                                <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                            </xsl:when>
                            <xsl:when test="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode != ''">
                                <xsl:value-of select="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode"/>
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
                            <xsl:when test="$comName = 'IC' or $comName = 'SD' or $comName = 'ZZZ'">
                                <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                            </xsl:when>
                            <xsl:when test="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode != ''">
                                <xsl:value-of select="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode"/>
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
                            <xsl:when test="$comName = 'IC' or $comName = 'SD' or $comName = 'ZZZ'">
                                <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                            </xsl:when>
                            <xsl:when test="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode != ''">
                                <xsl:value-of select="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode"/>
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
            <xsl:when test="C_C076/D_3155 = 'WWW'">
                <xsl:element name="URL">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$comName = 'IC' or $comName = 'SD' or $comName = 'ZZZ'">
                                <xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
                            </xsl:when>
                            <xsl:when test="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode != ''">
                                <xsl:value-of select="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode"/>
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
        <xsl:param name="grpRFF"/>
        <xsl:param name="buildRFFType"/>
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
                            <xsl:value-of select="$lookups/Lookups/Roles/Role[EANCOMCode = $role]/CXMLCode"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="addrDomain">
                <xsl:value-of select="S_NAD/C_C082/D_3055"/>
            </xsl:variable>
            <xsl:if test="$lookups/Lookups/AddrDomains/AddrDomain[EANCOMCode = $addrDomain]">
                <xsl:attribute name="addressID">
                    <xsl:value-of select="S_NAD/C_C082/D_3039"/>
                </xsl:attribute>
                <xsl:if test="$addrDomain != 91 and $addrDomain != 92">
                    <xsl:attribute name="addressIDDomain">
                        <xsl:value-of select="normalize-space($lookups/Lookups/AddrDomains/AddrDomain[EANCOMCode = $addrDomain]/CXMLCode)"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:element name="Name">
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:value-of select="concat(S_NAD/C_C080/D_3036, S_NAD/C_C080/D_3036_2, S_NAD/C_C080/D_3036_3, S_NAD/C_C080/D_3036_4, S_NAD/C_C080/D_3036_5)"/>
            </xsl:element>
            <!-- PostalAddress -->
            <xsl:if test="S_NAD/D_3164 != ''">
                <xsl:element name="PostalAddress">
                    <!-- <xsl:attribute name="name"/> -->
                    <xsl:if test="S_NAD/C_C058/D_3124 != ''">
                        <xsl:element name="DeliverTo">
                            <xsl:value-of select="S_NAD/C_C058/D_3124"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="S_NAD/C_C058/D_3124_2 != ''">
                        <xsl:element name="DeliverTo">
                            <xsl:value-of select="S_NAD/C_C058/D_3124_2"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="S_NAD/C_C058/D_3124_3 != ''">
                        <xsl:element name="DeliverTo">
                            <xsl:value-of select="S_NAD/C_C058/D_3124_3"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="S_NAD/C_C058/D_3124_4 != ''">
                        <xsl:element name="DeliverTo">
                            <xsl:value-of select="S_NAD/C_C058/D_3124_4"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="S_NAD/C_C058/D_3124_5 != ''">
                        <xsl:element name="DeliverTo">
                            <xsl:value-of select="S_NAD/C_C058/D_3124_5"/>
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
                    <xsl:variable name="stateCodeEDI">
                        <xsl:value-of select="S_NAD/D_3229"/>
                    </xsl:variable>
                    <xsl:if test="$stateCodeEDI != ''">
                        <xsl:element name="State">
                            <xsl:attribute name="isoStateCode">
                                <xsl:value-of select="$stateCodeEDI"/>
                            </xsl:attribute>
                            <xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCodeEDI]/stateName"/>
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
            <xsl:for-each select=".//S_COM[C_C076/D_3155 = 'WWW']">
                <xsl:call-template name="CommunicationInfo">
                    <xsl:with-param name="role" select="$role"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$cMode = 'partners'">
                <xsl:for-each select="G_SG4[S_RFF/C_C506/D_1153 != 'ZZZ']">
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
                        <xsl:when test="S_RFF/C_C506[D_1153 = 'FC']/D_1154 != ''">
                            <xsl:element name="IdReference">
                                <xsl:attribute name="domain">fiscalNumber</xsl:attribute>
                                <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'FC']/D_1154"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="S_RFF/C_C506[D_1153 = 'IA']/D_1154 != ''">
                            <xsl:element name="IdReference">
                                <xsl:attribute name="domain">vendorNumber</xsl:attribute>
                                <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'IA']/D_1154"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="S_RFF/C_C506[D_1153 = 'IT']/D_1154 != ''">
                            <xsl:element name="IdReference">
                                <xsl:attribute name="domain">companyCode</xsl:attribute>
                                <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'IT']/D_1154"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="S_RFF/C_C506[D_1153 = 'SD']/D_1154 != ''">
                            <xsl:element name="IdReference">
                                <xsl:attribute name="domain">departmentName</xsl:attribute>
                                <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'SD']/D_1154"/>
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
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
            <xsl:if test="$grpRFF != ''">
                <xsl:choose>
                    <xsl:when test="$buildRFFType = 'IdRef'">
                        <xsl:for-each select="$grpRFF">
                            <xsl:variable name="refID" select="S_RFF/C_C506/D_1153"/>
                            <xsl:if test="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EANCOMCode = $refID] and S_RFF/C_C506/D_1154 != ''">
                                <xsl:choose>
                                    <xsl:when test="$refID = 'AP'">
                                        <xsl:if test="$role = 'IV'">
                                            <xsl:element name="IdReference">
                                                <xsl:attribute name="domain">
                                                    <xsl:value-of select="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EANCOMCode = $refID]/CXMLCode"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="identifier" select="S_RFF/C_C506/D_1154"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="IdReference">
                                            <xsl:attribute name="domain">
                                                <xsl:value-of select="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EANCOMCode = $refID]/CXMLCode"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="identifier" select="S_RFF/C_C506/D_1154"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$grpRFF">
                            <xsl:variable name="refID" select="S_RFF/C_C506/D_1153"/>
                            <xsl:if test="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EANCOMCode = $refID] and S_RFF/C_C506/D_1154 != ''">
                                <xsl:choose>
                                    <xsl:when test="$refID = 'AP'">
                                        <xsl:if test="$role = 'IV'">
                                            <xsl:element name="Extrinsic">
                                                <xsl:attribute name="name">
                                                    <xsl:value-of select="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EANCOMCode = $refID]/CXMLCode"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="S_RFF/C_C506/D_1154"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="Extrinsic">
                                            <xsl:attribute name="name">
                                                <xsl:value-of select="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EANCOMCode = $refID]/CXMLCode"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="S_RFF/C_C506/D_1154"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:element>
        <xsl:if test="$cMode = 'partner'">
            <xsl:for-each select="G_SG3/G_SG4[S_RFF/C_C506/D_1153 != 'ZZZ']">
                <xsl:choose>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'AMT']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">gstID</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AMT']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'FC']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">fiscalNumber</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'FC']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'GN']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">governmentNumber</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'GN']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="($role = 'SE' or $role = 'SF' or $role = 'SU') and S_RFF/C_C506[D_1153 = 'IA']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">vendorNumber</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'IA']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'IT']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">companyCode</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'IT']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'TL']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">taxExemptionID</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'TL']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'SD']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">departmentName</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'SD']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">vatID</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'XA']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">companyRegistrationNumber</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'XA']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="S_RFF/C_C506[D_1153 = 'YC1']/D_1154 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">additionalPartyID</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'YC1']/D_1154"/>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="G_SG17" mode="SNItem">
        <xsl:element name="ShipNoticeItem">
            <xsl:variable name="itemQty" select="S_QTY/C_C186[D_6063 = '12']/D_6060"/>
            <xsl:attribute name="quantity">
                <xsl:value-of select="$itemQty"/>
            </xsl:attribute>
            <xsl:attribute name="lineNumber">
                <xsl:choose>
                    <xsl:when test="G_SG18/S_RFF/C_C506[D_1153 = 'ON']/D_1156 != ''">
                        <xsl:value-of select="G_SG18/S_RFF/C_C506[D_1153 = 'ON']/D_1156"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="position()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <!-- parentLineNumber -->
            <xsl:if test="S_LIN/C_C829[D_5495 = '1']/D_1082 != '' and G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_1154 = 'item'">
                <xsl:attribute name="parentLineNumber">
                    <xsl:value-of select="S_LIN/C_C829[D_5495 = '1']/D_1082"/>
                </xsl:attribute>
            </xsl:if>
            <!-- shipNoticeLineNumber -->
            <xsl:if test="S_LIN/D_1082 != ''">
                <xsl:attribute name="shipNoticeLineNumber">
                    <xsl:value-of select="S_LIN/D_1082"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_1154 != ''">
                <xsl:attribute name="itemType">
                    <xsl:choose>
                        <xsl:when test="G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_1154 = 'item'">item</xsl:when>
                        <xsl:when test="G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_1154 = 'composite'">composite</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_1154 = 'composite' and (G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_4000 = 'itemLevel' or G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_4000 = 'groupLevel')">
                <xsl:attribute name="compositeItemType">
                    <xsl:choose>
                        <xsl:when test="G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_4000 = 'itemLevel'">itemLevel</xsl:when>
                        <xsl:when test="G_SG18/S_RFF/C_C506[D_1153 = 'FI']/D_4000 = 'groupLevel'">groupLevel</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <!-- ItemID -->
            <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'SA'] != '' or S_LIN/C_C212[D_7143 = 'SRV']/D_7140 != ''">
                <xsl:element name="ItemID">
                    <xsl:element name="SupplierPartID">
                        <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'SA'] != ''">
                            <xsl:value-of select="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'SA']"/>
                        </xsl:if>
                    </xsl:element>
                    <xsl:if test="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'IN'] != ''">
                        <xsl:element name="BuyerPartID">
                            <xsl:value-of select="S_PIA[D_4347 = '5']//D_7140[../D_7143 = 'IN']"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="S_LIN/C_C212[D_7143 = 'SRV']/D_7140 != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">EAN-13</xsl:attribute>
                            <xsl:attribute name="identifier" select="S_LIN/C_C212[D_7143 = 'SRV']/D_7140"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <xsl:variable name="desc">
                <xsl:for-each select="S_IMD[./D_7077 = 'F']">
                    <xsl:value-of select="concat(C_C273/D_7008, C_C273/D_7008_2)"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="descLang">
                <xsl:for-each select="S_IMD[./D_7077 = 'F' or ./D_7077 = 'E']">
                    <xsl:value-of select="C_C273/D_3453"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="shortName">
                <xsl:for-each select="S_IMD[./D_7077 = 'E']">
                    <xsl:value-of select="concat(C_C273/D_7008, C_C273/D_7008_2)"/>
                </xsl:for-each>
            </xsl:variable>
            <!-- ShipNoticeItemDetail -->
            <xsl:if test="S_MEA[D_6311 = 'PD'][C_C174/D_6411 != ''][C_C174/D_6314 != ''][C_C502/D_6313 != '']/C_C174/D_6411 != '' or S_LIN/C_C212[D_7143 = 'SRV']/D_7140 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'EWC']/D_7140 != '' or exists(S_IMD[D_7077 = 'B']) or S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'GD'] != '' or S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'MF'] != '' or S_PIA[D_4347 = '1']//D_7140[../D_7143 = 'ZZZ'] != '' or S_MOA/C_C516[D_5025 = '146']/D_5004 != '' or $desc != ''">
                <xsl:element name="ShipNoticeItemDetail">
                    <xsl:if test="S_MOA/C_C516[D_5025 = '146']/D_5004 != ''">
                        <xsl:element name="UnitPrice">
                            <xsl:call-template name="createMoney">
                                <xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '146']"/>
                            </xsl:call-template>
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
                        <xsl:value-of select="S_QTY/C_C186[D_6063 = '12']/D_6411"/>
                    </xsl:element>
                    <xsl:for-each select="S_PIA[D_4347 = '1']//.[D_7143 = 'GD']">
                        <xsl:element name="Classification">
                            <xsl:attribute name="domain">
                                <xsl:text>UNSPSC</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="code">
                                <xsl:value-of select="D_7140"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:if test="S_PIA[D_4347 = '5']//.[D_7143 = 'MF']/D_7140 != ''">
                        <xsl:element name="ManufacturerPartID">
                            <xsl:value-of select="S_PIA[D_4347 = '5']//.[D_7143 = 'MF']/D_7140"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="S_MEA[D_6311 = 'PD'][C_C174/D_6411 != ''][C_C174/D_6314 != ''][C_C502/D_6313 != '']">
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
                    <xsl:if test="S_LIN/C_C212[D_7143 = 'SRV']/D_7140 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'EWC']/D_7140 != '' or exists(S_IMD[D_7077 = 'B'])">
                        <xsl:element name="ItemDetailIndustry">
                            <xsl:element name="ItemDetailRetail">
                                <xsl:if test="S_LIN/C_C212[D_7143 = 'SRV']/D_7140 != ''">
                                    <xsl:element name="EANID">
                                        <xsl:value-of select="S_LIN/C_C212[D_7143 = 'SRV']/D_7140"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'EWC']/D_7140 != ''">
                                    <xsl:element name="EuropeanWasteCatalogID">
                                        <xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'EWC']/D_7140"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:for-each select="S_IMD[D_7077 = 'B']">
                                    <xsl:variable name="charCode" select="C_C272/D_7081"/>
                                    <xsl:if test="$lookups/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[EANCOMCode = $charCode]/CXMLCode != ''">
                                        <xsl:element name="Characteristic">
                                            <xsl:attribute name="domain" select="$lookups/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[EANCOMCode = $charCode]/CXMLCode"/>
                                            <xsl:attribute name="value" select="C_C273/D_7008"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <xsl:variable name="itemUOM" select="S_QTY/C_C186[D_6063 = '12']/D_6411"/>
            <xsl:choose>
                <xsl:when test="$itemUOM != ''">
                    <xsl:element name="UnitOfMeasure">
                        <xsl:value-of select="$itemUOM"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="UnitOfMeasure">
                        <xsl:value-of select="'EA'"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Packaging -->
            <xsl:choose>
                <xsl:when test="G_SG22[exists(S_PCI)][S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17']">
                    <xsl:choose>
                        <xsl:when test="G_SG22[exists(S_PCI)][S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17'][not(exists(G_SG23/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']))]"><!-- Map Sequence 3 -->
                            <xsl:for-each select="G_SG22[exists(S_PCI)][not(exists(G_SG23/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']))][S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17']">
                                <xsl:element name="Packaging">
                                    <xsl:for-each select="S_MEA[D_6311 = 'PD']">
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
                                    <xsl:element name="Description">
                                        <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                                        <xsl:attribute name="type">Material</xsl:attribute>
                                    </xsl:element>
                                    <xsl:call-template name="createShippingMark">
                                        <xsl:with-param name="PCIGrp" select="S_PCI"/>
                                    </xsl:call-template>
                                    <xsl:if test="S_QTY/C_C186[D_6063 = '12']/D_6060 != ''">
                                        <xsl:element name="DispatchQuantity">
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="S_QTY/C_C186[D_6063 = '12']/D_6060"/>
                                            </xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="S_QTY/C_C186[D_6063 = '12']/D_6411 != ''">
                                                    <xsl:element name="UnitOfMeasure">
                                                        <xsl:value-of select="S_QTY/C_C186[D_6063 = '12']/D_6411"/>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:element name="UnitOfMeasure">
                                                        <xsl:value-of select="'EA'"/>
                                                    </xsl:element>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
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
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise> <!-- 4.1 -->
                            <xsl:variable name="currCPSGrp" select=".."/>
                            <xsl:variable name="curCPSParent" select="../S_CPS/D_7166"/>
                            <xsl:variable name="packTypeIdCode">
                                <xsl:if test="not(exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']))">
                                    <xsl:value-of select="($currCPSGrp/G_SG11/S_PAC/C_C202/D_7065)[1]"/>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="mxPackLvlCode">
                                <xsl:call-template name="findMaxPackLevelCode">
                                    <xsl:with-param name="currCPSParent">
                                        <xsl:choose>
                                            <xsl:when test="exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW'])">
                                                <xsl:value-of select="$curCPSParent"/>
                                            </xsl:when>
                                            <xsl:when test="not(exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']))">
                                                <xsl:value-of select="//G_SG10[S_CPS/D_7164 = $curCPSParent]/S_CPS/D_7166"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="shipSerialCode">
                                <xsl:choose>
                                    <xsl:when test="exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW'])">
                                        <xsl:value-of select="../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402"/>
                                    </xsl:when>
                                    <xsl:when test="not(exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']))">
                                        <xsl:value-of select="//G_SG10[S_CPS/D_7164 = $curCPSParent]/G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="parentCPSGrp" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]"/>
                            <!-- Map Sequence 4.1.2 -->
                            <xsl:if test="$curCPSParent and exists(//G_SG10/S_CPS[D_7164 = $curCPSParent]) and not(exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW'])) and $mxPackLvlCode != 1">
                                <xsl:call-template name="Packaging">
                                    <xsl:with-param name="CPSGrp" select="$parentCPSGrp"/>
                                    <xsl:with-param name="packLevelCode" select="$mxPackLvlCode - 1"/>
                                </xsl:call-template>
                            </xsl:if>
                            <!-- Map Sequence 4.1.1 -->
                            <xsl:if test="$curCPSParent and exists(//G_SG10/S_CPS[D_7164 = $curCPSParent]) and exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW'])">
                                <xsl:call-template name="Packaging">
                                    <xsl:with-param name="CPSGrp" select="$currCPSGrp"/>
                                    <xsl:with-param name="packLevelCode" select="$mxPackLvlCode - 1"/>
                                </xsl:call-template>
                            </xsl:if>
                            <!-- Map Sequence 4.1 main/child-->
                            <xsl:for-each select="G_SG22[exists(S_PCI)][exists(G_SG23/S_GIN)]">
                                <xsl:variable name="SG22GRP" select="."/>
                                <xsl:call-template name="mapSequence41">
                                    <xsl:with-param name="SG22GRP" select="$SG22GRP"/>
                                    <xsl:with-param name="mxPackLvlCode" select="$mxPackLvlCode"/>
                                    <xsl:with-param name="shipSerialCode" select="$shipSerialCode"/>
                                    <xsl:with-param name="packTypeIdCode" select="$packTypeIdCode"/>
                                    <xsl:with-param name="currCPSGrp" select="$currCPSGrp"/>
                                    <xsl:with-param name="parentType">
                                            <xsl:if test="not(exists(../G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']))">412</xsl:if>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise> <!-- 4.2 -->
                    <xsl:variable name="curCPSParent" select="../S_CPS/D_7166"/>
                    <xsl:variable name="currCPSGrp" select="../."/>
                    <xsl:if test="($currCPSGrp/S_CPS/D_7164 &gt; 1)">
                        <xsl:choose>
                            <xsl:when test="(exists($currCPSGrp/G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']))">
                                <xsl:variable name="map43">
                                    <xsl:if test="$currCPSGrp/G_SG11[exists(S_PAC)][not(exists(G_SG13))]">
                                        <xsl:text>yes</xsl:text>
                                    </xsl:if>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$map43 = 'yes'">
                                        <!-- Map Sequence 4.3 -->
                                        <xsl:variable name="totalLin" select="count(../G_SG17)"/>
                                        <xsl:variable name="totalQty" select="sum(../G_SG17/S_QTY/C_C186[D_6063 = '12']/D_6060)"/>
                                        <xsl:variable name="packLvlCode">1</xsl:variable>
                                        <xsl:variable name="packTypeIdCode" select="($currCPSGrp/G_SG11[exists(S_PAC)][exists(G_SG13)]/S_PAC/C_C202/D_7065)[1]"/>
                                        <xsl:variable name="shipSerialCode">
                                            <xsl:if test="($currCPSGrp/G_SG11[exists(S_PAC)]/G_SG13[S_PCI/D_4233 = '33E']/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402)[1] != ''">
                                                <xsl:value-of select="($currCPSGrp/G_SG11[exists(S_PAC)]/G_SG13[S_PCI/D_4233 = '33E']/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402)[1]"/>
                                            </xsl:if>
                                        </xsl:variable>
                                        <xsl:element name="Packaging">
                                            <xsl:element name="PackagingCode">
                                                <xsl:attribute name="xml:lang" select="'en'"/>
                                                <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $packTypeIdCode]/CXMLCode"/>
                                            </xsl:element>
                                            <xsl:for-each select="$currCPSGrp/G_SG11[exists(S_PAC)][exists(G_SG13)]/S_MEA[D_6311 = 'PD']">
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
                                            <xsl:element name="Description">
                                                <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                                                <xsl:attribute name="type">Package</xsl:attribute>
                                            </xsl:element>
                                            <xsl:element name="PackagingLevelCode">
                                                <xsl:value-of select="format-number($packLvlCode, '0000')"/>
                                            </xsl:element>
                                            <xsl:if test="$packTypeIdCode != ''">
                                                <xsl:element name="PackageTypeCodeIdentifierCode">
                                                    <xsl:value-of select="$packTypeIdCode"/>
                                                </xsl:element>
                                            </xsl:if>
                                            <xsl:if test="$shipSerialCode">
                                                <xsl:element name="ShippingContainerSerialCode">
                                                    <xsl:value-of select="$shipSerialCode"/>
                                                </xsl:element>
                                            </xsl:if>
                                            <xsl:for-each select="$currCPSGrp/G_SG11/G_SG13[S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17']">
                                                <xsl:call-template name="createShippingMark">
                                                    <xsl:with-param name="PCIGrp" select="S_PCI"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </xsl:element>
                                        <xsl:variable name="packTypeIdCode" select="($currCPSGrp/G_SG11[exists(S_PAC)][not(exists(G_SG13))]/S_PAC/C_C202/D_7065)[1]"/>
                                        <xsl:variable name="loopCount">
                                            <xsl:choose>
                                                <xsl:when test="($currCPSGrp/G_SG11[exists(S_PAC)][not(exists(G_SG13))]/S_PAC/D_7224 = $totalQty) and ($totalLin > 1)">
                                                    <xsl:value-of select="S_QTY/C_C186[D_6063 = '12']/D_6060"/>
                                                </xsl:when>
                                                <xsl:when test="$totalLin = 1">
                                                    <xsl:value-of select="$currCPSGrp/G_SG11[exists(S_PAC)][not(exists(G_SG13))]/S_PAC/D_7224"/>
                                                </xsl:when>
                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:for-each select="1 to $loopCount">
                                            <xsl:call-template name="mapSequence43">
                                                <xsl:with-param name="packLvlCode" select="$packLvlCode + 1"/>
                                                <xsl:with-param name="packTypeIdCode" select="$packTypeIdCode"/>
                                                <xsl:with-param name="shipSerialCode" select="$shipSerialCode"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- Map Sequence 5 -->
                                        <xsl:variable name="curCPSParent" select="../S_CPS/D_7166"/>
                                        <xsl:variable name="currCPSGrp" select="../."/>
                                        <xsl:variable name="parentCPSGrp" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]"/>
                                        <xsl:variable name="packTypeIdCode" select="($currCPSGrp/G_SG11/S_PAC/C_C202/D_7065)[1]"/>
                                        <xsl:variable name="shipSerialCode" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]/G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402"/>
                                        <xsl:variable name="mxPackLvlCode">
                                            <xsl:call-template name="findMaxPackLevelCode">
                                                <xsl:with-param name="currCPSParent" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]/S_CPS/D_7166"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:if test="$curCPSParent and exists(//G_SG10/S_CPS[D_7164 = $curCPSParent]) and $mxPackLvlCode != 1">
                                            <xsl:call-template name="Packaging">
                                                <xsl:with-param name="CPSGrp" select="$parentCPSGrp"/>
                                                <xsl:with-param name="packLevelCode" select="$mxPackLvlCode - 1"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:call-template name="mapSequence42">
                                            <xsl:with-param name="currCPSGrp" select="$currCPSGrp"/>
                                            <xsl:with-param name="shipSerialCode" select="$shipSerialCode"/>
                                            <xsl:with-param name="packLevelCode" select="$mxPackLvlCode"/>
                                            <xsl:with-param name="itemQty" select="$itemQty"/>
                                            <xsl:with-param name="itemUOM" select="$itemUOM"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- Map Sequence 4.3.1-->
                            <xsl:otherwise>
                                <xsl:variable name="curCPSParent" select="../S_CPS/D_7166"/>
                                <xsl:variable name="parentCPSGrp" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]"/>
                                <xsl:variable name="totalLin" select="count(../G_SG17)"/>
                                <xsl:variable name="totalQty" select="sum(../G_SG17/S_QTY/C_C186[D_6063 = '12']/D_6060)"/>
                                <xsl:variable name="packLvlCode">1</xsl:variable>
                                <xsl:variable name="packTypeIdCode" select="($parentCPSGrp/G_SG11[exists(S_PAC)][exists(G_SG13)]/S_PAC/C_C202/D_7065)[1]"/>
                                <xsl:variable name="shipSerialCode">
                                    <xsl:if test="($parentCPSGrp/G_SG11[exists(S_PAC)]/G_SG13[S_PCI/D_4233 = '33E']/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402)[1] != ''">
                                        <xsl:value-of select="($parentCPSGrp/G_SG11[exists(S_PAC)]/G_SG13[S_PCI/D_4233 = '33E']/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402)[1]"/>
                                    </xsl:if>
                                </xsl:variable>
                                <xsl:element name="Packaging">
                                    <xsl:element name="PackagingCode">
                                        <xsl:attribute name="xml:lang" select="'en'"/>
                                        <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $packTypeIdCode]/CXMLCode"/>
                                    </xsl:element>
                                    <xsl:for-each select="$parentCPSGrp/G_SG11[exists(S_PAC)][exists(G_SG13)]/S_MEA[D_6311 = 'PD']">
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
                                    <xsl:element name="Description">
                                        <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                                        <xsl:attribute name="type">Package</xsl:attribute>
                                    </xsl:element>
                                    <xsl:element name="PackagingLevelCode">
                                        <xsl:value-of select="format-number($packLvlCode, '0000')"/>
                                    </xsl:element>
                                    <xsl:if test="$packTypeIdCode != ''">
                                        <xsl:element name="PackageTypeCodeIdentifierCode">
                                            <xsl:value-of select="$packTypeIdCode"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="$shipSerialCode">
                                        <xsl:element name="ShippingContainerSerialCode">
                                            <xsl:value-of select="$shipSerialCode"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:for-each select="$parentCPSGrp/G_SG11">
                                        <xsl:for-each select="G_SG13[S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17']">
                                            <xsl:call-template name="createShippingMark">
                                                <xsl:with-param name="PCIGrp" select="S_PCI"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:element>
                                <xsl:variable name="packTypeIdCode" select="($currCPSGrp/G_SG11[exists(S_PAC)][not(exists(G_SG13))]/S_PAC/C_C202/D_7065)[1]"/>
                                <xsl:variable name="loopCount">
                                    <xsl:choose>
                                        <xsl:when test="($currCPSGrp/G_SG11[exists(S_PAC)][not(exists(G_SG13))]/S_PAC/D_7224 = $totalQty) and ($totalLin > 1)">
                                            <xsl:value-of select="S_QTY/C_C186[D_6063 = '12']/D_6060"/>
                                        </xsl:when>
                                        <xsl:when test="$totalLin = 1">
                                            <xsl:value-of select="$currCPSGrp/G_SG11[exists(S_PAC)][not(exists(G_SG13))]/S_PAC/D_7224"/>
                                        </xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:for-each select="1 to $loopCount">
                                    <xsl:call-template name="mapSequence43">
                                        <xsl:with-param name="packLvlCode" select="$packLvlCode + 1"/>
                                        <xsl:with-param name="packTypeIdCode" select="$packTypeIdCode"/>
                                        <xsl:with-param name="shipSerialCode" select="$shipSerialCode"/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Batch -->
            <xsl:for-each select="G_SG22[S_PCI/D_4233 = '36E']">
                <xsl:if test="S_DTM/C_C507[D_2005 = '36' or D_2005 = '94' or D_2005 = '351'][D_2379 = '102']/D_2380 != '' or S_QTY/C_C186[D_6063 = '12']/D_6060 != ''">
                    <xsl:element name="Batch">
                        <xsl:if test="S_DTM/C_C507[D_2005 = '36'][D_2379 = '102']/D_2380 != ''">
                            <xsl:attribute name="expirationDate">
                                <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '36'][D_2379 = '102']/D_2380"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="S_DTM/C_C507[D_2005 = '94'][D_2379 = '102']/D_2380 != ''">
                            <xsl:attribute name="productionDate">
                                <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '94'][D_2379 = '102']/D_2380"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="S_DTM/C_C507[D_2005 = '351'][D_2379 = '102']/D_2380 != ''">
                            <xsl:attribute name="inspectionDate">
                                <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '351'][D_2379 = '102']/D_2380"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="S_QTY/C_C186[D_6063 = '12']/D_6060 != ''">
                            <xsl:attribute name="batchQuantity">
                                <xsl:value-of select="S_QTY/C_C186[D_6063 = '12']/D_6060"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <!-- BuyerBatchID -->
            <xsl:for-each select="G_SG22[S_PCI/D_4233 = '36E']">
                <xsl:for-each select="G_SG23/S_GIN[D_7405 = 'BX'][C_C208/D_7402_2 = '92'][C_C208/D_7402 != '']">
                    <xsl:element name="Batch">
                        <xsl:element name="BuyerBatchID">
                            <xsl:value-of select="C_C208/D_7402"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="G_SG23/S_GIN[D_7405 = 'BX'][C_C208_2/D_7402_2 = '92'][C_C208_2/D_7402 != '']">
                    <xsl:element name="Batch">
                        <xsl:element name="BuyerBatchID">
                            <xsl:value-of select="C_C208_2/D_7402"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
            <!-- SupplierBatchID -->
            <xsl:for-each select="G_SG22[S_PCI/D_4233 = '36E']">
                <xsl:for-each select="G_SG23/S_GIN[D_7405 = 'BX'][C_C208/D_7402_2 = '91'][C_C208/D_7402 != '']">
                    <xsl:element name="Batch">
                        <xsl:element name="SupplierBatchID">
                            <xsl:value-of select="C_C208/D_7402"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="G_SG23/S_GIN[D_7405 = 'BX'][C_C208_2/D_7402_2 = '91'][C_C208_2/D_7402 != '']">
                    <xsl:element name="Batch">
                        <xsl:element name="SupplierBatchID">
                            <xsl:value-of select="C_C208_2/D_7402"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:for-each>
            <!-- AssetInfo -->
            <xsl:for-each select="S_PIA[D_4347 = '1']//.[D_7143 = 'SN']//.[D_7140 != '']">
                <xsl:element name="AssetInfo">
                    <xsl:attribute name="serialNumber">
                        <xsl:value-of select=".//D_7140"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
            <!-- AssetInfo -->
            <xsl:for-each select="S_FTX[D_4451 = 'MKS']/C_C108[D_4440_2 != '']">
                <xsl:element name="AssetInfo">
                    <xsl:choose>
                        <xsl:when test="D_4440 = 'SN'">
                            <xsl:attribute name="serialNumber">
                                <xsl:value-of select="concat(D_4440_2, D_4440_3, D_4440_4, D_4440_5)"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="D_4440 = 'TA'">
                            <xsl:attribute name="tagNumber">
                                <xsl:value-of select="concat(D_4440_2, D_4440_3, D_4440_4, D_4440_5)"/>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
            <!-- OrderedQuantity -->
            <xsl:if test="S_QTY/C_C186[D_6063 = '21']/D_6060 != ''">
                <xsl:element name="OrderedQuantity">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="S_QTY/C_C186[D_6063 = '21']/D_6060"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="S_QTY/C_C186[D_6063 = '21']/D_6411 != ''">
                            <xsl:element name="UnitOfMeasure">
                                <xsl:value-of select="S_QTY/C_C186[D_6063 = '21']/D_6411"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="UnitOfMeasure">
                                <xsl:value-of select="'EA'"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <!-- ShipNoticeItemIndustry -->
            <xsl:if test="S_DTM/C_C507[D_2005 = '36']/D_2380 != '' or S_DTM/C_C507[D_2005 = '361']/D_2380 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'PV']/D_7140 != '' or S_QTY/C_C186[D_6063 = '192']/D_6060 != ''">
                <xsl:element name="ShipNoticeItemIndustry">
                    <xsl:element name="ShipNoticeItemRetail">
                        <!-- BestBeforeDate -->
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
                        <!-- ExpiryDate -->
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
                        <!-- FreeGoodsQuantity -->
                        <xsl:if test="S_QTY/C_C186[D_6063 = '192']/D_6060 != ''">
                            <xsl:element name="FreeGoodsQuantity">
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="S_QTY/C_C186[D_6063 = '192']/D_6060"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="S_QTY/C_C186[D_6063 = '192']/D_6411 != ''">
                                        <xsl:element name="UnitOfMeasure">
                                            <xsl:value-of select="S_QTY/C_C186[D_6063 = '192']/D_6411"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="UnitOfMeasure">
                                            <xsl:value-of select="'EA'"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:if>
                        <!-- PromotionDealID -->
                        <xsl:if test="G_SG18/S_RFF/C_C506[D_1153 = 'PD']/D_1154 != ''">
                            <xsl:element name="PromotionDealID">
                                <xsl:value-of select="G_SG18/S_RFF/C_C506[D_1153 = 'PD']/D_1154"/>
                            </xsl:element>
                        </xsl:if>
                        <!-- PromotionVariantID -->
                        <xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'PV']/D_7140 != ''">
                            <xsl:element name="PromotionVariantID">
                                <xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'PV']/D_7140"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <!-- Comments -->
            <xsl:for-each select="S_FTX[D_4451 = 'AAI']">
                <xsl:variable name="comment">
                    <xsl:value-of select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
                </xsl:variable>
                <xsl:variable name="commentLang">
                    <xsl:value-of select="D_3453"/>
                </xsl:variable>
                <xsl:if test="$comment != ''">
                    <xsl:element name="Comments">
                        <xsl:attribute name="xml:lang">
                            <xsl:choose>
                                <xsl:when test="$commentLang != ''">
                                    <xsl:value-of select="substring($commentLang, 1, 2)"/>
                                </xsl:when>
                                <xsl:otherwise>en</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="$comment"/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <!-- Extrinsic -->
            <xsl:if test="G_SG25/S_QVR/C_C279[D_6063 = '21']/D_6064 != ''">
                <xsl:element name="Extrinsic">
                    <xsl:attribute name="name">QuantityVariance</xsl:attribute>
                    <xsl:value-of select="G_SG25/S_QVR/C_C279[D_6063 = '21']/D_6064"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="G_SG25/S_QVR[C_C279/D_6063 = '21']/D_4221 != ''">
                <xsl:element name="Extrinsic">
                    <xsl:attribute name="name">DiscrepancyNatureIdentificationCode</xsl:attribute>
                    <xsl:value-of select="G_SG25/S_QVR[C_C279/D_6063 = '21']/D_4221"/>
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
            <xsl:for-each select="G_SG18[S_RFF/C_C506/D_1153 = 'ZZZ']">
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
                        <xsl:value-of select="C_C108/D_4440"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5))"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="createShippingMark">
        <xsl:param name="PCIGrp"/>
        <xsl:if test="$PCIGrp/C_C210/D_7102 != ''">
            <xsl:element name="ShippingMark">
                <xsl:value-of select="$PCIGrp/C_C210/D_7102"/>
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
        <xsl:if test="C_C210/D_7102_9 != ''">
            <xsl:element name="ShippingMark">
                <xsl:value-of select="C_C210/D_7102_9"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="C_C210/D_7102_10 != ''">
            <xsl:element name="ShippingMark">
                <xsl:value-of select="C_C210/D_7102_10"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Packaging">
        <xsl:param name="CPSGrp"/>
        <xsl:param name="packLevelCode"/>
        <xsl:variable name="curCPSParent" select="$CPSGrp/S_CPS/D_7166"/>
        <xsl:variable name="serialCode" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]/G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/C_C208/D_7402"/>
        <xsl:if test="$packLevelCode != 1">
            <xsl:call-template name="Packaging">
                <xsl:with-param name="CPSGrp" select="//G_SG10[S_CPS/D_7164 = $curCPSParent]"/>
                <xsl:with-param name="packLevelCode" select="$packLevelCode - 1"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:variable name="serialCodes">
            <xsl:for-each select="$CPSGrp/G_SG11/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
                <xsl:variable name="startSerial" select="D_7402"/>
                <xsl:variable name="endSerial">
                    <xsl:choose>
                        <xsl:when test="D_7402_2 != ''">
                            <xsl:value-of select="D_7402_2"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="generateSerialCodes">
                    <xsl:with-param name="startSerial" select="$startSerial"/>
                    <xsl:with-param name="endSerial" select="$endSerial"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$serialCodes/Serial">
            <xsl:element name="Packaging">
                <xsl:if test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $CPSGrp/G_SG11/S_PAC/C_C202/D_7065]/CXMLCode != ''">
                    <xsl:element name="PackagingCode">
                        <xsl:attribute name="xml:lang" select="'en'"/>
                        <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $CPSGrp/G_SG11/S_PAC/C_C202/D_7065]/CXMLCode"/>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="$CPSGrp/G_SG11/S_MEA[D_6311 = 'PD']">
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
                <xsl:element name="Description">
                    <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                    <xsl:attribute name="type">Package</xsl:attribute>
                </xsl:element>
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
                    <xsl:if test="($CPSGrp/G_SG11/G_SG13[S_PCI/D_4233 = '34E']/G_SG15/S_GIN[D_7405 = 'CU']/C_C208/D_7402)[1] != ''">
                        <xsl:element name="PackageID">
                            <xsl:element name="GlobalIndividualAssetID">
                                <xsl:value-of select="($CPSGrp/G_SG11/G_SG13[S_PCI/D_4233 = '34E']/G_SG15/S_GIN[D_7405 = 'CU']/C_C208/D_7402)[1]"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:if>
                <xsl:for-each select="$CPSGrp/G_SG11">
                    <xsl:for-each select="G_SG13[S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17']">
                        <xsl:call-template name="createShippingMark">
                            <xsl:with-param name="PCIGrp" select="S_PCI"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="findMaxPackLevelCode">
        <xsl:param name="currCPSParent"/>
        <xsl:param name="counter" select="0"/>
        <xsl:choose>
            <xsl:when test="$currCPSParent and exists(//G_SG10/S_CPS[D_7164 = $currCPSParent])">
                <xsl:call-template name="findMaxPackLevelCode">
                    <xsl:with-param name="currCPSParent" select="//G_SG10/S_CPS[D_7164 = $currCPSParent]/D_7166"/>
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
        <xsl:param name="SG22GRP"/>
        <xsl:param name="packTypeIdCode"/>
        <xsl:param name="mxPackLvlCode"/>
        <xsl:param name="shipSerialCode"/>
        <xsl:param name="currCPSGrp"/>
        <xsl:param name="parentType"/>
        <xsl:for-each select="$SG22GRP/G_SG23[S_GIN/D_7405 = 'BJ' or S_GIN/D_7405 = 'AW'][S_GIN/C_C208/D_7402 != ''][count(S_GIN/*) = 2][count(S_GIN/C_C208/*) >= 1]">
            <!--  All serial numbers supported-->
            <xsl:variable name="serialCodes">
                <xsl:for-each select="S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
                    <xsl:variable name="startSerial" select="D_7402"/>
                    <xsl:variable name="endSerial">
                        <xsl:choose>
                            <xsl:when test="D_7402_2 != ''">
                                <xsl:value-of select="D_7402_2"/>
                            </xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="generateSerialCodes">
                        <xsl:with-param name="startSerial" select="$startSerial"/>
                        <xsl:with-param name="endSerial" select="$endSerial"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="$serialCodes/Serial">
                <xsl:element name="Packaging">
                    <xsl:if test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $packTypeIdCode]/CXMLCode != ''">
                        <xsl:element name="PackagingCode">
                            <xsl:attribute name="xml:lang" select="'en'"/>
                            <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $packTypeIdCode]/CXMLCode"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$parentType = '412'">
                            <xsl:for-each select="$currCPSGrp/G_SG11">
                                <xsl:for-each select="S_MEA[D_6311 = 'PD']">
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
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$SG22GRP/S_MEA[D_6311 = 'PD']">
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
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:element name="Description">
                        <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                        <xsl:attribute name="type">Material</xsl:attribute>
                    </xsl:element>
                    <xsl:if test="$packTypeIdCode != ''">
                        <xsl:element name="PackageTypeCodeIdentifierCode">
                            <xsl:value-of select="$packTypeIdCode"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$mxPackLvlCode != 0">
                        <xsl:element name="PackagingLevelCode">
                            <xsl:value-of select="format-number($mxPackLvlCode, '0000')"/>
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
                    <xsl:for-each select="$SG22GRP[S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17']">
                        <xsl:call-template name="createShippingMark">
                            <xsl:with-param name="PCIGrp" select="S_PCI"/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:if test="$SG22GRP/S_QTY/C_C186[D_6063 = '12']/D_6060 != ''">
                        <xsl:element name="DispatchQuantity">
                            <xsl:attribute name="quantity">
                                <xsl:value-of select="$SG22GRP/S_QTY/C_C186[D_6063 = '12']/D_6060"/>
                            </xsl:attribute>
                            <xsl:if test="$SG22GRP/S_QTY/C_C186[D_6063 = '12']/D_6411 != ''">
                                <xsl:element name="UnitOfMeasure">
                                    <xsl:value-of select="$SG22GRP/S_QTY/C_C186[D_6063 = '12']/D_6411"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$SG22GRP/S_DTM/C_C507[D_2005 = '361']/D_2380 != ''">
                        <xsl:element name="BestBeforeDate">
                            <xsl:attribute name="date">
                                <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="dateTime">
                                        <xsl:value-of select="$SG22GRP/S_DTM/C_C507[D_2005 = '361']/D_2380"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="dateTimeFormat">
                                        <xsl:value-of select="$SG22GRP/S_DTM/C_C507[D_2005 = '361']/D_2379"/>
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
        <xsl:param name="shipSerialCode"/>
        <xsl:param name="packLevelCode"/>
        <xsl:param name="itemQty"/>
        <xsl:param name="itemUOM"/>
        <xsl:for-each select="$currCPSGrp/G_SG11">
            <xsl:variable name="packTypeIdCode" select="S_PAC/C_C202/D_7065"/>
            <xsl:for-each select="G_SG13">
                <xsl:for-each select="G_SG15">
                    <!-- Check Serial Codes -->
                    <xsl:variable name="SG15Grp" select="."/>
                    <xsl:variable name="serialCodes">
                        <xsl:for-each select="./S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
                            <xsl:variable name="startSerial" select="./D_7402"/>
                            <xsl:variable name="endSerial">
                                <xsl:choose>
                                    <xsl:when test="./D_7402_2 != ''">
                                        <xsl:value-of select="./D_7402_2"/>
                                    </xsl:when>
                                    <xsl:otherwise>0</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:call-template name="generateSerialCodes">
                                <xsl:with-param name="startSerial" select="$startSerial"/>
                                <xsl:with-param name="endSerial" select="$endSerial"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:for-each select="$serialCodes/Serial">
                        <xsl:element name="Packaging">
                            <xsl:element name="PackagingCode">
                                <xsl:attribute name="xml:lang" select="'en'"/>
                                <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $packTypeIdCode]/CXMLCode"/>
                            </xsl:element>
                            <xsl:for-each select="$SG15Grp/../../S_MEA[D_6311 = 'PD']">
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
                            <xsl:element name="Description">
                                <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                                <xsl:attribute name="type">Material</xsl:attribute>
                            </xsl:element>
                            <xsl:if test="$packLevelCode != ''">
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
                            <xsl:if test="$shipSerialCode != ''">
                                <xsl:element name="ShippingContainerSerialCodeReference">
                                    <xsl:value-of select="$shipSerialCode"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$SG15Grp/../../S_PAC/D_7224 = '1'">
                                <xsl:if test="($SG15Grp/../../G_SG13[S_PCI/D_4233 = '34E']/G_SG15/S_GIN[D_7405 = 'CU']/C_C208/D_7402)[1] != ''">
                                    <xsl:element name="PackageID">
                                        <xsl:element name="GlobalIndividualAssetID">
                                            <xsl:value-of select="($SG15Grp/../../G_SG13[S_PCI/D_4233 = '34E']/G_SG15/S_GIN[D_7405 = 'CU']/C_C208/D_7402)[1]"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:if>
                            <xsl:for-each select="$SG15Grp/..[S_PCI/D_4233 = '33E' or S_PCI/D_4233 = '17']">
                                <xsl:call-template name="createShippingMark">
                                    <xsl:with-param name="PCIGrp" select="S_PCI"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <xsl:if test="$SG15Grp/../../S_PAC/D_7224 = '1' and $itemQty != '' and $itemUOM != ''">
                                <xsl:element name="DispatchQuantity">
                                    <xsl:attribute name="quantity" select="$itemQty"/>
                                    <xsl:element name="UnitOfMeasure">
                                        <xsl:value-of select="$itemUOM"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="mapSequence43">
        <xsl:param name="packLvlCode"/>
        <xsl:param name="packTypeIdCode"/>
        <xsl:param name="shipSerialCode"/>
        <xsl:element name="Packaging">
            <xsl:if test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $packTypeIdCode]/CXMLCode != ''">
                <xsl:element name="PackagingCode">
                    <xsl:attribute name="xml:lang" select="'en'"/>
                    <xsl:value-of select="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[EANCOMCode = $packTypeIdCode]/CXMLCode"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="Description">
                <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                <xsl:attribute name="type">Material</xsl:attribute>
            </xsl:element>
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
