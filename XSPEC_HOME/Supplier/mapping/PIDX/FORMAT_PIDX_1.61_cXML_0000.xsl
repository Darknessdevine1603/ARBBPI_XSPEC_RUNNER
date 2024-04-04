<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="#all" version="2.0">
    <xsl:template name="formatDate">
        <xsl:param name="DocDate"/>
        <xsl:choose>
            <xsl:when test="$DocDate">
                <xsl:variable name="Time1" select="substring($DocDate, 11)"/>
                <xsl:variable name="Time">
                    <xsl:choose>
                        <xsl:when test="string-length($Time1) &gt; 0">
                            <xsl:variable name="timezone"
                                select="concat(substring-after($Time1, '+'), substring-after($Time1, '-'))"/>
                            <xsl:choose>
                                <xsl:when test="string-length($timezone) &gt; 0">
                                    <xsl:value-of select="''"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$anSenderDefaultTimeZone"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('T00:00:00', $anSenderDefaultTimeZone)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($DocDate, $Time)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="CreateContact">
        <xsl:param name="partyInfo"/>
        <xsl:param name="partyRole"/>
        <Name>
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="$docLang"/>
            </xsl:attribute>
            <xsl:value-of select="$partyInfo/pidx:PartnerName"/>
        </Name>
        <PostalAddress>
            <xsl:choose>
                <xsl:when test="$partyInfo/pidx:AddressInformation/pidx:AddressLine != ''">
                    <xsl:for-each select="$partyInfo/pidx:AddressInformation/pidx:AddressLine">
                        <Street>
                            <xsl:value-of
                                select="$partyInfo/pidx:AddressInformation/pidx:AddressLine"/>
                        </Street>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <Street> </Street>
                </xsl:otherwise>
            </xsl:choose>
            <City>
                <xsl:value-of select="$partyInfo/pidx:AddressInformation/pidx:CityName"/>
            </City>
            <State>
                <xsl:value-of select="$partyInfo/pidx:AddressInformation/pidx:StateProvince"/>
            </State>
            <xsl:if test="$partyInfo/pidx:AddressInformation/pidx:PostalCode != ''">
                <PostalCode>
                    <xsl:value-of select="$partyInfo/pidx:AddressInformation/pidx:PostalCode"/>
                </PostalCode>
            </xsl:if>
            <Country>
                <xsl:attribute name="isoCountryCode">
                    <xsl:value-of
                        select="$partyInfo/pidx:AddressInformation/pidx:PostalCountry/pidx:CountryCode"
                    />
                </xsl:attribute>
            </Country>
        </PostalAddress>
        <xsl:if test="$partyInfo/pidx:ContactInformation">
            <xsl:for-each select="$partyInfo/pidx:ContactInformation/pidx:EmailAddress">
                <Email>
                    <xsl:attribute name="name">
                        <xsl:value-of select="../@contactInformationIndicator"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </Email>
            </xsl:for-each>
            <xsl:for-each
                select="$partyInfo/pidx:ContactInformation/pidx:Telephone[@telephoneIndicator = 'Voice']">
                <xsl:if test="pidx:PhoneNumber != ''">
                    <Phone>
                        <xsl:attribute name="name">
                            <xsl:value-of select="../@contactInformationIndicator"/>
                        </xsl:attribute>
                        <TelephoneNumber>
                            <CountryCode>
                                <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="pidx:TelecomCountryCode"/>
                                </xsl:attribute>
                            </CountryCode>
                            <AreaOrCityCode>
                                <xsl:value-of select="pidx:TelecomAreaCode"/>
                            </AreaOrCityCode>
                            <Number>
                                <xsl:value-of select="pidx:PhoneNumber"/>
                            </Number>
                            <Extension/>
                        </TelephoneNumber>
                    </Phone>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each
                select="$partyInfo/pidx:ContactInformation/pidx:Telephone[@telephoneIndicator = 'Fax']">
                <xsl:if test="pidx:PhoneNumber != ''">
                    <Fax>
                        <xsl:attribute name="name">
                            <xsl:value-of select="../@contactInformationIndicator"/>
                        </xsl:attribute>
                        <TelephoneNumber>
                            <CountryCode>
                                <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="pidx:TelecomCountryCode"/>
                                </xsl:attribute>
                            </CountryCode>
                            <AreaOrCityCode>
                                <xsl:value-of select="pidx:TelecomAreaCode"/>
                            </AreaOrCityCode>
                            <Number>
                                <xsl:value-of select="pidx:PhoneNumber"/>
                            </Number>
                            <Extension/>
                        </TelephoneNumber>
                    </Fax>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="$partyInfo/pidx:URL!= ''">
                <URL>
                    <xsl:value-of select="normalize-space($partyInfo/pidx:URL)"/>
                </URL>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$partyRole!='Consignee'">
            <xsl:for-each
                select="$partyInfo/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySeller' or @partnerIdentifierIndicator = 'DUNS+4Number' or @partnerIdentifierIndicator = 'DUNSNumber']">
                <xsl:variable name="IdRef" select="@partnerIdentifierIndicator"/>
                <xsl:variable name="domain"
                    select="$cXMLPIDXLookupList/Lookups/IDReferences/IDReference[PIDXCode = $IdRef]/CXMLCode"/>
                <xsl:choose>
                    <xsl:when
                        test="$IdRef = 'AssignedBySeller' and exists(../pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'])">
                        <IdReference>
                            <xsl:attribute name="domain">
                                <xsl:value-of select="$domain"/>
                            </xsl:attribute>
                            <xsl:attribute name="identifier">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:attribute>
                        </IdReference>
                    </xsl:when>
                    <xsl:when test="$IdRef = 'DUNSNumber' or $IdRef = 'DUNS+4Number'">
                        <IdReference>
                            <xsl:attribute name="domain">
                                <xsl:value-of select="$domain"/>
                            </xsl:attribute>
                            <xsl:attribute name="identifier">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:attribute>
                        </IdReference>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
