<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
				<!-- 								<xsl:when test="$dtmFormat = 303">					<xsl:value-of select="concat(substring($dateTime, 0, 12), '00', substring($dateTime, 12))"/>				</xsl:when>				<xsl:when test="$dtmFormat = 304">					<xsl:value-of select="$dateTime"/>				</xsl:when> -->
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$dateTimeFormat = '303' or $dateTimeFormat = '304'">
					<xsl:choose>
						<xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode != ''">
							<xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode"/>
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
				<xsl:choose>
					<xsl:when test="$MOA/D_6345 != ''">
						<xsl:value-of select="$MOA/D_6345"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$headerCurrency"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$altMOA">
				<xsl:if test="$altMOA/D_5004 != ''">
					<xsl:attribute name="alternateAmount">
						<xsl:choose>
							<xsl:when test="$isCreditMemo = 'yes'">
								<xsl:value-of select="concat('-', replace($altMOA/D_5004, '-', ''))"/>
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
			<xsl:if test="$MOA/D_5004">
				<xsl:choose>
					<xsl:when test="$MOA/D_5004 = '' or $MOA/D_5004 = 0">
						<xsl:value-of select="$MOA/D_5004"/>
					</xsl:when>
					<xsl:when test="$isCreditMemo = 'yes'">
						<xsl:value-of select="concat('-', $MOA/D_5004)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$MOA/D_5004"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
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
				<xsl:choose>
					<xsl:when test="$cur != ''">
						<xsl:value-of select="$cur"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$headerCurrency"/>
					</xsl:otherwise>
				</xsl:choose>
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
				<xsl:choose>
					<xsl:when test="$altcur != ''">
						<xsl:attribute name="alternateCurrency">
							<xsl:value-of select="$altcur"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="$headerCurrencyAlt != ''">
						<xsl:attribute name="alternateCurrency">
							<xsl:value-of select="$headerCurrencyAlt"/>
						</xsl:attribute>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$value">
				<xsl:choose>
					<xsl:when test="$value = '' or $value = 0">
						<xsl:value-of select="$value"/>
					</xsl:when>
					<xsl:when test="$isCreditMemo = 'yes'">
						<xsl:value-of select="concat('-', $value)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
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
			<xsl:when test="C_C076/D_3155 = 'WWW'">
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
	<xsl:template match="G_SG2 | G_SG3 | G_SG37 | G_SG34">
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
			<xsl:if test="S_NAD/C_C082/D_3039 != ''">
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
				<xsl:value-of select="concat(S_NAD/C_C080/D_3036, S_NAD/C_C080/D_3036_2, S_NAD/C_C080/D_3036_3, S_NAD/C_C080/D_3036_4, S_NAD/C_C080/D_3036_5)"/>
			</xsl:element>
			<!-- PostalAddress -->
			<xsl:if test="S_NAD/D_3164 != ''">
				<xsl:element name="PostalAddress">
					<!-- <xsl:attribute name="name"/> -->
					<xsl:if test="S_NAD/C_C080/D_3124 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C058/D_3124"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3124_2 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C058/D_3124_2"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3124_3 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C058/D_3124_3"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3124_4 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C058/D_3124_4"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3124_5 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C058/D_3124_5"/>
						</xsl:element>
					</xsl:if>
					<xsl:element name="Street">
						<xsl:value-of select="S_NAD/C_C059/D_3042"/>
					</xsl:element>
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
			<!--xsl:if test="$cMode='partner'">				<xsl:for-each select="G_SG3">					<xsl:choose>						<xsl:when test="S_RFF/C_C506[D_1153 = 'AGU']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">memberNumber</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'AGU']/D_1154"/>							</xsl:element>						</xsl:when>						<xsl:when test="S_RFF/C_C506[D_1153 = 'AIH']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">transactionReference</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'AIH']/D_1154"/>							</xsl:element>						</xsl:when>						<xsl:when test="S_RFF/C_C506[D_1153 = 'FC']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">fiscalNumber</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'FC']/D_1154"/>							</xsl:element>						</xsl:when>						<xsl:when test="S_RFF/C_C506[D_1153 = 'IA']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">vendorNumber</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'IA']/D_1154"/>							</xsl:element>						</xsl:when>						<xsl:when test="S_RFF/C_C506[D_1153 = 'IT']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">companyCode</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'IT']/D_1154"/>							</xsl:element>						</xsl:when>												<xsl:when test="S_RFF/C_C506[D_1153 = 'API']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">additionalPartyID</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'IT']/D_1154"/>							</xsl:element>						</xsl:when>						<xsl:when test="S_RFF/C_C506[D_1153 = 'XA']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">companyRegistrationNumber</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'IT']/D_1154"/>							</xsl:element>						</xsl:when>												<xsl:when test="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">									<xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154"/>								</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_4000"/>							</xsl:element>						</xsl:when>					</xsl:choose>				</xsl:for-each>			</xsl:if-->
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
				<xsl:variable name="refCode" select="S_RFF/C_C506/D_1153"/>
				<xsl:variable name="idRefDomain" select="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EDIFACTCode = $refCode]/CXMLCode"/>
				<xsl:variable name="refValue" select="S_RFF/C_C506/D_1154"/>
				<xsl:if test="$idRefDomain != ''">
					<xsl:element name="IdReference">
						<xsl:attribute name="domain">
							<xsl:value-of select="$idRefDomain"/>
						</xsl:attribute>
						<xsl:attribute name="identifier" select="$refValue"/>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="G_SG25">
		<xsl:param name="isCreditMemo"/>
		<xsl:param name="itemMode"/>
		<xsl:param name="currHead"/>
		<xsl:param name="altCurrHead"/>
		<xsl:variable name="eleName">
			<xsl:choose>
				<xsl:when test="$itemMode = 'service'">InvoiceDetailServiceItem</xsl:when>
				<xsl:otherwise>InvoiceDetailItem</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$eleName}">
			<xsl:attribute name="invoiceLineNumber">
				<xsl:value-of select="S_LIN/D_1082"/>
			</xsl:attribute>
			<xsl:attribute name="quantity">
				<xsl:choose>
					<xsl:when test="$isCreditMemo = 'yes'">
						<xsl:value-of select="concat('-', replace(S_QTY/C_C186[D_6063 = '47']/D_6060, '-', ''))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="S_QTY/C_C186[D_6063 = '47']/D_6060"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
				<xsl:attribute name="referenceDate">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '171']/D_2380"/>
						<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '171']/D_2379"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="S_DTM/C_C507[D_2005 = '351']/D_2380 != ''">
				<xsl:attribute name="inspectionDate">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '351']/D_2380"/>
						<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '351']/D_2379"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="S_LIN/C_C829[D_5495 = '1']/D_1082">
				<xsl:attribute name="parentInvoiceLineNumber" select="S_LIN/C_C829[D_5495 = '1']/D_1082"/>
			</xsl:if>
			<xsl:if test="$itemMode = 'service'">
				<xsl:element name="InvoiceDetailServiceItemReference">
					<xsl:attribute name="lineNumber">
						<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1156"/>
					</xsl:attribute>
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
					<xsl:if test="S_PIA[D_4347 = '1']//D_7143 = 'VN' or S_PIA[D_4347 = '1']//D_7143 = 'SA'">
						<xsl:element name="ItemID">
							<xsl:element name="SupplierPartID">
								<xsl:choose>
									<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'VN']/D_7140 != ''">
										<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'VN']/D_7140"/>
									</xsl:when>
									<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'SA']/D_7140">
										<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'SA']/D_7140"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
							<!-- SupplierPartAuxiliaryID -->
							<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140 != ''">
								<xsl:element name="SupplierPartAuxiliaryID">
									<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140"/>
								</xsl:element>
							</xsl:if>
							<!-- BuyerPartID -->
							<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140 != ''">
								<xsl:element name="BuyerPartID">
									<xsl:choose>
										<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != ''">
											<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140"/>
										</xsl:when>
										<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140">
											<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140"/>
										</xsl:when>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_IMD[D_7077 = 'F']/C_C273/D_7008 != '' or S_IMD[D_7077 = 'E']/C_C273/D_7008 != ''">
						<xsl:variable name="descLang">
							<xsl:for-each select="S_IMD[D_7077 = 'F']">
								<xsl:value-of select="C_C273/D_3453"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:element name="Description">
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="$descLang != ''">
										<xsl:value-of select="substring($descLang, 1, 2)"/>
									</xsl:when>
									<xsl:when test="S_IMD[D_7077 = 'E']/C_C273/D_3453 != ''">
										<xsl:value-of select="S_IMD[D_7077 = 'E']/C_C273/D_3453"/>
									</xsl:when>
									<xsl:otherwise>en</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:variable name="desc">
								<xsl:for-each select="S_IMD[D_7077 = 'F']/C_C273">
									<xsl:value-of select="concat(D_7008, D_7008_2)"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:value-of select="$desc"/>
							<xsl:if test="S_IMD[D_7077 = 'E']/C_C273/D_7008 != ''">
								<xsl:element name="ShortName">
								   <xsl:value-of select="concat(S_IMD[D_7077 = 'E']/C_C273/D_7008,' ',S_IMD[D_7077 = 'E']/C_C273/D_7008_2)"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<!-- SubtotalAmount-->
				<xsl:element name="SubtotalAmount">
					<xsl:call-template name="createMoneyAlt">
						<xsl:with-param name="value" select="G_SG26/S_MOA/C_C516[D_5025 = '289'][1]/D_5004"/>
						<xsl:with-param name="cur">
							<xsl:choose>
								<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '289'][1]/D_6345 != ''">
									<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '289'][1]/D_6345"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$currHead"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="altvalue" select="G_SG26/S_MOA/C_C516[D_5025 = '289'][D_6343 = '11']/D_5004"/>
						<xsl:with-param name="altcur">
							<xsl:choose>
								<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '289'][D_6343 = '11']/D_6345 != ''">
									<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '289'][D_6343 = '11']/D_6345"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$altCurrHead"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
				<!-- Period -->
				<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != '' and S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
					<xsl:element name="Period">
						<xsl:attribute name="startDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
								<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="endDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
								<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<xsl:element name="UnitOfMeasure">
				<xsl:value-of select="S_QTY/C_C186[D_6063 = '47']/D_6411"/>
			</xsl:element>
			<!-- InvoiceItemModifications -->
			<xsl:variable name="pcdAllowed" select="'|1|2|3|'"/>
			<xsl:variable name="moaAllowed" select="'|8|23|204|'"/>
			<xsl:variable name="cleanALCListUnitPrice">
				<xsl:for-each select="G_SG38[(S_ALC/D_5463 = 'C' or S_ALC/D_5463 = 'A') and (S_ALC/D_4471 = '2')]">
					<xsl:choose>
						<xsl:when
							test="(S_ALC/D_5463 = 'C') and (contains($pcdAllowed, G_SG40/S_PCD/C_C501/D_5245) or (G_SG41[S_MOA/C_C516/D_5025 = '8'] or G_SG41[S_MOA/C_C516/D_5025 = '23'] or G_SG41[S_MOA/C_C516/D_5025 = '204']))">
							<G_ALC>
								<xsl:copy-of select="./child::*"/>
							</G_ALC>
						</xsl:when>
						<xsl:when
							test="(S_ALC/D_5463 = 'A') and (contains($pcdAllowed, G_SG40/S_PCD/C_C501/D_5245) or (G_SG41[S_MOA/C_C516/D_5025 = '8'] or G_SG41[S_MOA/C_C516/D_5025 = '23'] or G_SG41[S_MOA/C_C516/D_5025 = '204']))">
							<G_ALC>
								<xsl:copy-of select="./child::*"/>
							</G_ALC>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="cleanALCList">
				<xsl:for-each select="G_SG38[(S_ALC/D_5463 = 'C' or S_ALC/D_5463 = 'A') and (S_ALC/D_4471 != '2')]">
					<xsl:choose>
						<xsl:when
							test="(S_ALC/D_5463 = 'C') and (contains($pcdAllowed, G_SG40/S_PCD/C_C501/D_5245) or (G_SG41[S_MOA/C_C516/D_5025 = '8'] or G_SG41[S_MOA/C_C516/D_5025 = '23'] or G_SG41[S_MOA/C_C516/D_5025 = '204']))">
							<G_ALC>
								<xsl:copy-of select="./child::*"/>
							</G_ALC>
						</xsl:when>
						<xsl:when
							test="(S_ALC/D_5463 = 'A') and (contains($pcdAllowed, G_SG40/S_PCD/C_C501/D_5245) or (G_SG41[S_MOA/C_C516/D_5025 = '8'] or G_SG41[S_MOA/C_C516/D_5025 = '23'] or G_SG41[S_MOA/C_C516/D_5025 = '204']))">
							<G_ALC>
								<xsl:copy-of select="./child::*"/>
							</G_ALC>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:variable>
			<xsl:element name="UnitPrice">
				<xsl:element name="Money">
					<xsl:attribute name="currency">
						<xsl:value-of select="$currHead"/>
					</xsl:attribute>
					<xsl:if test="$altCurrHead">
						<xsl:attribute name="alternateCurrency">
							<xsl:value-of select="$altCurrHead"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAA']/D_5118"/>
					<!--xsl:choose>						<xsl:when test="$isCreditMemo = 'yes'">							<xsl:value-of								select="concat('-', G_SG28/S_PRI/C_C509[D_5125 = 'AAA']/D_5118)"/>						</xsl:when>						<xsl:otherwise>							<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAA']/D_5118"/>						</xsl:otherwise>					</xsl:choose-->
				</xsl:element>
				<!-- IG-2189 UnitPrice/ItemModifications -->
				<xsl:if test="count($cleanALCListUnitPrice/G_ALC) &gt; 0">
					<xsl:element name="Modifications">
						<xsl:for-each select="$cleanALCListUnitPrice/G_ALC">
							<xsl:variable name="modCode">
								<xsl:value-of select="./S_ALC/C_C214/D_7161"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="S_ALC/D_5463 = 'A'">
									<xsl:element name="Modification">
										<xsl:if test="S_ALC/D_1227 != ''">
											<xsl:attribute name="level">
												<xsl:value-of select="S_ALC/D_1227"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="G_SG41/S_MOA/C_C516[D_5025 = '98']/D_5004 != ''">
											<xsl:element name="OriginalPrice">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="G_SG41/S_MOA/C_C516[D_5025 = '98']"/>
													<!--xsl:with-param name="isCreditMemo"												select="$isCreditMemo"/-->
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:element name="AdditionalDeduction">
											<xsl:choose>
												<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004 != ''">
													<xsl:element name="DeductionAmount">
														<xsl:call-template name="createMoney">
															<xsl:with-param name="MOA" select="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']"/>
															<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
														</xsl:call-template>
													</xsl:element>
												</xsl:when>
												<xsl:when test="G_SG40/S_PCD/C_C501/D_5245 != ''">
													<xsl:element name="DeductionPercent">
														<xsl:attribute name="percent">
															<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
														</xsl:attribute>
													</xsl:element>
												</xsl:when>
												<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '296']/D_5004 != ''">
													<xsl:element name="DeductedPrice">
														<xsl:element name="Money">
															<xsl:attribute name="currency">
																<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '296']/D_6345"/>
															</xsl:attribute>
															<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '296']/D_5004"/>
														</xsl:element>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:element>
										<xsl:element name="ModificationDetail">
											<xsl:attribute name="name">
												<xsl:choose>
													<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
														<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$modCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
												<xsl:attribute name="startDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="dateTime">
															<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
														</xsl:with-param>
														<xsl:with-param name="dateTimeFormat">
															<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
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
											<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
													<xsl:text>en</xsl:text>
												</xsl:attribute>
												<xsl:if test="./S_ALC/C_C552/D_1230 != ''">
													<xsl:element name="ShortName">
														<xsl:value-of select="./S_ALC/C_C552/D_1230"/>
													</xsl:element>
												</xsl:if>
												<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
											</xsl:element>
											<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
												<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
												<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
												<xsl:if test="$codeSLookup != ''">
													<Extrinsic>
														<xsl:attribute name="name">settlementCode</xsl:attribute>
														<xsl:value-of select="$codeSLookup"/>
													</Extrinsic>
												</xsl:if>
											</xsl:if>
											<xsl:if test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004 != ''">
												<Extrinsic>
													<xsl:attribute name="name">AllowanceChargeBasisAmount</xsl:attribute>
													<!-- IG-2360 : add money element inside extrinsic -->
													<Money>
														<xsl:attribute name="currency">
															<xsl:choose>
																<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345 != ''">
																	<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$currHead"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004"/>
													</Money>
												</Extrinsic>
											</xsl:if>
											<xsl:if test="G_SG41/S_MOA and G_SG40/S_PCD">
												<Extrinsic>
													<xsl:attribute name="name">deductionPercentage</xsl:attribute>
													<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
												</Extrinsic>
											</xsl:if>
											<xsl:if test="G_SG43/S_TAX[C_C241/D_5153 = 'VAT']/C_C243/D_5278 != ''">
												<Extrinsic>
													<xsl:attribute name="name">vatPercentageRate</xsl:attribute>
													<xsl:value-of select="G_SG43/S_TAX[C_C241/D_5153 = 'VAT'][1]/C_C243/D_5278"/>
												</Extrinsic>
											</xsl:if>
										</xsl:element>
									</xsl:element>
								</xsl:when>
								<xsl:when test="S_ALC/D_5463 = 'C'">
									<xsl:element name="Modification">
										<xsl:if test="S_ALC/D_1227 != ''">
											<xsl:attribute name="level">
												<xsl:value-of select="S_ALC/D_1227"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:element name="AdditionalCost">
											<xsl:choose>
												<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004 != ''">
													<xsl:call-template name="createMoney">
														<xsl:with-param name="MOA" select="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']"/>
														<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="G_SG40/S_PCD/C_C501/D_5245 != ''">
													<xsl:element name="Percentage">
														<xsl:attribute name="percent">
															<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
														</xsl:attribute>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:element>
										<xsl:element name="ModificationDetail">
											<xsl:attribute name="name">
												<xsl:choose>
													<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
														<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$modCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
												<xsl:attribute name="startDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="dateTime">
															<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
														</xsl:with-param>
														<xsl:with-param name="dateTimeFormat">
															<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
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
											<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
													<xsl:text>en</xsl:text>
												</xsl:attribute>
												<xsl:if test="./S_ALC/C_C552/D_1230 != ''">
													<xsl:element name="ShortName">
														<xsl:value-of select="./S_ALC/C_C552/D_1230"/>
													</xsl:element>
												</xsl:if>
												<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
											</xsl:element>
											<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
												<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
												<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
												<xsl:if test="$codeSLookup != ''">
													<Extrinsic>
														<xsl:attribute name="name">settlementCode</xsl:attribute>
														<xsl:value-of select="$codeSLookup"/>
													</Extrinsic>
												</xsl:if>
											</xsl:if>
											<xsl:if test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004 != ''">
												<Extrinsic>
													<xsl:attribute name="name">AllowanceChargeBasisAmount</xsl:attribute>
													<!-- IG-2360 : add money element inside extrinsic -->
													<Money>
														<xsl:attribute name="currency">
															<xsl:choose>
																<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345 != ''">
																	<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$currHead"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004"/>
													</Money>
												</Extrinsic>
											</xsl:if>
											<xsl:if test="G_SG41/S_MOA and G_SG40/S_PCD">
												<Extrinsic>
													<xsl:attribute name="name">chargePercentage</xsl:attribute>
													<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
												</Extrinsic>
											</xsl:if>
											<xsl:if test="G_SG43/S_TAX[C_C241/D_5153 = 'VAT']/C_C243/D_5278 != ''">
												<Extrinsic>
													<xsl:attribute name="name">vatPercentageRate</xsl:attribute>
													<xsl:value-of select="G_SG43/S_TAX[C_C241/D_5153 = 'VAT'][1]/C_C243/D_5278"/>
												</Extrinsic>
											</xsl:if>
										</xsl:element>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
			</xsl:element>
			<!-- PriceBasisQuantity -->
			<xsl:if test="G_SG28/S_PRI/C_C509/D_5125 = 'AAA' and G_SG28/S_PRI/C_C509/D_5284 != '' and G_SG28/S_PRI/C_C509/D_6411 != ''">
				<xsl:element name="PriceBasisQuantity">
					<xsl:attribute name="quantity">
						<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAA']/D_5284"/>
						<!--xsl:choose>							<xsl:when test="$isCreditMemo = 'yes'">								<xsl:value-of									select="concat('-', G_SG28/S_PRI/C_C509[D_5125 = 'AAA']/D_5284)"								/>							</xsl:when>							<xsl:otherwise>								<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAA']/D_5284"/>							</xsl:otherwise>						</xsl:choose-->
					</xsl:attribute>
					<xsl:attribute name="conversionFactor">
						<xsl:value-of select="'1'"/>
					</xsl:attribute>
					<xsl:element name="UnitOfMeasure">
						<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAA']/D_6411"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$itemMode = 'item'">
				<xsl:element name="InvoiceDetailItemReference">
					<xsl:attribute name="lineNumber">
						<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1156"/>
					</xsl:attribute>
					<xsl:if test="S_PIA[D_4347 = '1']//D_7143 = 'SN'">
						<xsl:attribute name="serialNumber">
							<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'SN']/D_7140[1]"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="S_PIA[D_4347 = '5']//D_7143 = 'VN' or S_PIA[D_4347 = '5']//D_7143 = 'SA'">
						<xsl:element name="ItemID">
							<xsl:element name="SupplierPartID">
								<xsl:choose>
									<xsl:when test="S_PIA[D_4347 = '5']//.[D_7143 = 'VN']/D_7140 != ''">
										<xsl:value-of select="S_PIA[D_4347 = '5']//.[D_7143 = 'VN']/D_7140"/>
									</xsl:when>
									<xsl:when test="S_PIA[D_4347 = '5']//.[D_7143 = 'SA']/D_7140">
										<xsl:value-of select="S_PIA[D_4347 = '5']//.[D_7143 = 'SA']/D_7140"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
							<!-- SupplierPartAuxiliaryID -->
							<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140 != ''">
								<xsl:element name="SupplierPartAuxiliaryID">
									<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140"/>
								</xsl:element>
							</xsl:if>
							<!-- BuyerPartID -->
							<xsl:if test="S_PIA[D_4347 = '5']//.[D_7143 = 'BP']/D_7140 != '' or S_PIA[D_4347 = '5']//.[D_7143 = 'IN']/D_7140 != ''">
								<xsl:element name="BuyerPartID">
									<xsl:choose>
										<xsl:when test="S_PIA[D_4347 = '5']//.[D_7143 = 'BP']/D_7140 != ''">
											<xsl:value-of select="S_PIA[D_4347 = '5']//.[D_7143 = 'BP']/D_7140"/>
										</xsl:when>
										<xsl:when test="S_PIA[D_4347 = '5']//.[D_7143 = 'IN']/D_7140">
											<xsl:value-of select="S_PIA[D_4347 = '5']//.[D_7143 = 'IN']/D_7140"/>
										</xsl:when>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
							<xsl:if test="S_LIN/C_C212[D_7143 = 'UP']/D_7140">
								<xsl:element name="IdReference">
									<xsl:attribute name="domain">UPCID</xsl:attribute>
									<xsl:attribute name="identifier">
										<xsl:value-of select="S_LIN/C_C212[D_7143 = 'UP']/D_7140"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_IMD[D_7077 = 'F']/C_C273/D_7008 != '' or S_IMD[D_7077 = 'E']/C_C273/D_7008 != ''">
						<xsl:variable name="descLang">
							<xsl:for-each select="S_IMD[D_7077 = 'F']">
								<xsl:value-of select="C_C273/D_3453"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:element name="Description">
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="$descLang != ''">
										<xsl:value-of select="substring($descLang, 1, 2)"/>
									</xsl:when>
									<xsl:when test="S_IMD[D_7077 = 'E']/C_C273/D_3453 != ''">
										<xsl:value-of select="S_IMD[D_7077 = 'E']/C_C273/D_3453"/>
									</xsl:when>
									<xsl:otherwise>en</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:variable name="desc">
								<xsl:for-each select="S_IMD[D_7077 = 'F']/C_C273">
									<xsl:value-of select="concat(D_7008, D_7008_2)"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:value-of select="$desc"/>
							<xsl:if test="S_IMD[D_7077 = 'E']/C_C273/D_7008 != ''">
								<xsl:element name="ShortName">
								   <xsl:value-of select="concat(S_IMD[D_7077 = 'E']/C_C273/D_7008,' ',S_IMD[D_7077 = 'E']/C_C273/D_7008_2)"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
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
					<xsl:if test="S_PIA[D_4347 = '5']//.[D_7143 = 'MF']/D_7140 != '' and G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124 != ''">
						<xsl:element name="ManufacturerPartID">
							<xsl:value-of select="S_PIA[D_4347 = '5']//.[D_7143 = 'MF']/D_7140"/>
						</xsl:element>
						<xsl:element name="ManufacturerName">
							<xsl:value-of
								select="normalize-space(concat(G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_2, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_3, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_4, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_5))"
							/>
						</xsl:element>
					</xsl:if>
					<xsl:for-each select="S_PIA[D_4347 = '1']//.[D_7143 = 'SN']">
						<xsl:element name="SerialNumber">
							<xsl:value-of select="D_7140"/>
						</xsl:element>
					</xsl:for-each>
					<xsl:if test="S_LIN/C_C212[D_7143 = 'EN']/D_7140 != '' or S_IMD[D_7077 = 'B']/C_C273/D_7008 != ''">
						<xsl:element name="InvoiceDetailItemReferenceIndustry">
							<xsl:element name="InvoiceDetailItemReferenceRetail">
								<xsl:if test="S_LIN/C_C212[D_7143 = 'EN']/D_7140 != ''">
									<xsl:element name="EANID">
										<xsl:value-of select="S_LIN/C_C212[D_7143 = 'EN']/D_7140"/>
									</xsl:element>
								</xsl:if>
								<xsl:for-each select="S_IMD[D_7077 = 'B']">
									<xsl:element name="Characteristic">
										<xsl:attribute name="domain">
											<xsl:choose>
												<xsl:when test="D_7081 = '13'">quality</xsl:when>
												<xsl:when test="D_7081 = '38'">grade</xsl:when>
												<xsl:when test="D_7081 = '35'">color</xsl:when>
												<xsl:when test="D_7081 = 'SGR'">sizeGrid</xsl:when>
												<xsl:when test="D_7081 = '98'">size</xsl:when>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="C_C273/D_7008"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'AAK']/D_1156 != ''">
					<xsl:element name="ShipNoticeLineItemReference">
						<xsl:attribute name="shipNoticeLineNumber" select="G_SG29/S_RFF/C_C506[D_1153 = 'AAK']/D_1156"/>
					</xsl:element>
				</xsl:if>
				<!-- SubtotalAmount-->
				<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '289']/D_5004 != ''">
					<xsl:element name="SubtotalAmount">
						<xsl:call-template name="createMoneyAlt">
							<xsl:with-param name="value" select="G_SG26/S_MOA/C_C516[D_5025 = '289'][1]/D_5004"/>
							<xsl:with-param name="cur">
								<xsl:choose>
									<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '289'][1]/D_6345 != ''">
										<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '289'][1]/D_6345"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$currHead"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="altvalue" select="G_SG26/S_MOA/C_C516[D_5025 = '289'][D_6343 = '11']/D_5004"/>
							<xsl:with-param name="altcur">
								<xsl:choose>
									<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '289'][D_6343 = '11']/D_6345 != ''">
										<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '289'][D_6343 = '11']/D_6345"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$altCurrHead"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<!-- Tax -->
			<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '176']/D_5004 != ''">
				<xsl:element name="Tax">
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA" select="G_SG26/S_MOA/C_C516[D_5025 = '176']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
					<xsl:element name="Description">
						<xsl:choose>
							<xsl:when test="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '3']/C_C108/D_4440 != ''">
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '3'][1]/D_3453 != ''">
											<xsl:value-of select="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '3'][1]/D_3453"/>
										</xsl:when>
										<xsl:otherwise>en</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:for-each select="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '3']">
									<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="xml:lang">en</xsl:attribute>
								<xsl:text/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:for-each select="G_SG33[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">
						<xsl:variable name="taxCategory">
							<xsl:choose>
								<xsl:when test="S_TAX/C_C241/D_5153 = 'LOC' or S_TAX/C_C241/D_5153 = 'STT'">
									<xsl:choose>
										<xsl:when test="S_TAX/C_C241/D_5152 = '.qc.ca'">
											<xsl:text>qst</xsl:text>
										</xsl:when>
										<xsl:when
											test="S_TAX/C_C241/D_5152 = '.ns.ca' or S_TAX/C_C241/D_5152 = '.nf.ca' or S_TAX/C_C241/D_5152 = '.nb.ca' or S_TAX/C_C241/D_5152 = '.on.ca'">
											<xsl:text>hst</xsl:text>
										</xsl:when>
										<xsl:when test="contains(S_TAX/C_C241/D_5152, '.ca')">
											<xsl:text>pst</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>sales</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="S_TAX/C_C241/D_5153 = 'VAT'">
									<xsl:text>vat</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>other</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="vatNum">
							<xsl:value-of select="S_TAX/D_3446"/>
						</xsl:variable>
						<xsl:element name="TaxDetail">
							<xsl:attribute name="purpose">
								<xsl:choose>
									<xsl:when test="S_TAX/D_5283 = '5'">
										<xsl:text>duty</xsl:text>
									</xsl:when>
									<xsl:when test="S_TAX/D_5283 = '7'">
										<xsl:text>tax</xsl:text>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="category">
								<xsl:value-of select="$taxCategory"/>
							</xsl:attribute>
							<xsl:if test="S_TAX/C_C243/D_5278 != ''">
								<xsl:attribute name="percentageRate">
									<xsl:value-of select="S_TAX/C_C243/D_5278"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
								<xsl:variable name="tpDate">
									<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2380"/>
								</xsl:variable>
								<xsl:variable name="tpDateFormat">
									<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2379"/>
								</xsl:variable>
								<xsl:variable name="payDate">
									<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2380"/>
								</xsl:variable>
								<xsl:variable name="payDateFormat">
									<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2379"/>
								</xsl:variable>
								<xsl:if test="$tpDate != ''">
									<xsl:attribute name="taxPointDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime" select="$tpDate"/>
											<xsl:with-param name="dateTimeFormat" select="$tpDateFormat"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="$payDate != ''">
									<xsl:attribute name="paymentDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime">
												<xsl:value-of select="$payDate"/>
											</xsl:with-param>
											<xsl:with-param name="dateTimeFormat">
												<xsl:value-of select="$payDateFormat"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="isTriangularTransaction">yes</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="S_TAX/D_5305 = 'Z'">
									<xsl:attribute name="exemptDetail">
										<xsl:text>zeroRated</xsl:text>
									</xsl:attribute>
								</xsl:when>
								<xsl:when test="S_TAX/D_5305 = 'E'">
									<xsl:attribute name="exemptDetail">
										<xsl:text>exempt</xsl:text>
									</xsl:attribute>
								</xsl:when>
							</xsl:choose>
							<!-- TaxableAmount -->
							<xsl:if test="S_TAX/D_5286 != ''">
								<xsl:element name="TaxableAmount">
									<xsl:element name="Money">
										<xsl:attribute name="currency">
											<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
										</xsl:attribute>
										<xsl:if test="S_TAX/D_5286">
											<xsl:choose>
												<xsl:when test="S_TAX/D_5286 = '' or S_TAX/D_5286 = '0'">
													<xsl:value-of select="S_TAX/D_5286"/>
												</xsl:when>
												<xsl:when test="$isCreditMemo = 'yes'">
													<xsl:value-of select="concat('-', S_TAX/D_5286)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="S_TAX/D_5286"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:element name="TaxAmount">
								<xsl:element name="Money">
									<xsl:attribute name="currency">
										<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
									</xsl:attribute>
									<xsl:if test="S_MOA/C_C516[D_5025 = '124']/D_5004">
										<xsl:choose>
											<xsl:when test="S_MOA/C_C516[D_5025 = '124']/D_5004 = '' or S_MOA/C_C516[D_5025 = '124']/D_5004 = '0'">
												<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_5004"/>
											</xsl:when>
											<xsl:when test="$isCreditMemo = 'yes'">
												<xsl:value-of select="concat('-', S_MOA/C_C516[D_5025 = '124']/D_5004)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_5004"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:element>
							</xsl:element>
							<!-- TaxLocation -->
							<xsl:if test="S_TAX/C_C241/D_5152 != ''">
								<xsl:element name="TaxLocation">
									<xsl:attribute name="xml:lang">en</xsl:attribute>
									<xsl:value-of select="S_TAX/C_C241/D_5152"/>
								</xsl:element>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="not(S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat') and S_TAX/D_3446 != ''">
									<xsl:element name="Description">
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:value-of select="S_TAX/D_3446"/>
									</xsl:element>
								</xsl:when>
								<xsl:when
									test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat' and normalize-space(../G_SG29/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000) != ''">
									<xsl:element name="Description">
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:value-of select="normalize-space(../G_SG29/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000)"/>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
								<xsl:if test="S_FTX[D_4451 = 'TXD'][D_4453 = '3']/C_C108/D_4440 != ''">
									<xsl:element name="TriangularTransactionLawReference">
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="S_FTX[D_4451 = 'TXD'][D_4453 = '3'][1]/D_3453 != ''">
													<xsl:value-of select="S_FTX[D_4451 = 'TXD'][D_4453 = '3'][1]/D_3453"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:for-each select="S_FTX[D_4451 = 'TXD'][D_4453 = '3']">
											<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:if>
							<xsl:if test="S_TAX/C_C243/D_5279 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">
										<xsl:text>taxAccountcode</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="S_TAX/C_C243/D_5279"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="S_LOC[D_3227 = '157']/C_C517/D_3225 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">
										<xsl:text>taxJurisdiction</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="S_LOC[D_3227 = '157']/C_C517/D_3225"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="S_TAX/D_5305 = 'S' or S_TAX/D_5305 = 'A'">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">
										<xsl:text>exemptType</xsl:text>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when test="S_TAX/D_5305 = 'A'">
											<xsl:text>Mixed</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Standard</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$itemMode = 'item'">
				<!-- InvoiceDetailLineSpecialHandling -->
				<xsl:if test="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'SH']/G_SG41/S_MOA/C_C516[D_5025 = '23']/D_5004 != ''">
					<xsl:element name="InvoiceDetailLineSpecialHandling">
						<xsl:if test="G_SG38/S_ALC[D_5463 = 'C']/C_C214[D_7161 = 'SH']/D_7160 != ''">
							<xsl:element name="Description">
								<xsl:attribute name="xml:lang" select="'en'"/>
								<xsl:value-of
									select="concat(G_SG38/S_ALC[D_5463 = 'C']/C_C214[D_7161 = 'SH']/D_7160, G_SG38/S_ALC[D_5463 = 'C']/C_C214[D_7161 = 'SH']/D_7160_2)"/>
							</xsl:element>
						</xsl:if>
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'SH']/G_SG41/S_MOA/C_C516[D_5025 = '23'][1]"/>
							<xsl:with-param name="altMOA" select="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'SH']/G_SG41/S_MOA/C_C516[D_5025 = '23'][D_6343 = '11']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>
				<!-- InvoiceDetailLineShipping -->
				<xsl:if test="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'FC']/G_SG41/S_MOA/C_C516[D_5025 = '23']/D_5004 != ''">
					<xsl:element name="InvoiceDetailLineShipping">
						<xsl:element name="InvoiceDetailShipping">
							<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'SF' or S_NAD/D_3035 = 'ST' or S_NAD/D_3035 = 'CA']">
								<xsl:apply-templates select=".">
									<xsl:with-param name="role" select="S_NAD/D_3035"/>
								</xsl:apply-templates>
							</xsl:for-each>
							<!-- CarrierIdentifier -->
							<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'CA']">
								<xsl:if test="S_NAD/C_C082/D_1131 = '172'">
									<xsl:choose>
										<xsl:when test="S_NAD/C_C082/D_3055 = '3'">
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>IATA</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="S_NAD/C_C082/D_3039"/>
											</xsl:element>
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>companyName</xsl:text>
												</xsl:attribute>
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_NAD/C_C082/D_3055 = '9'">
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>EAN</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="S_NAD/C_C082/D_3039"/>
											</xsl:element>
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>companyName</xsl:text>
												</xsl:attribute>
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_NAD/C_C082/D_3055 = '12'">
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>UIC</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="S_NAD/C_C082/D_3039"/>
											</xsl:element>
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>companyName</xsl:text>
												</xsl:attribute>
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_NAD/C_C082/D_3055 = '16'">
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>DUNS</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="S_NAD/C_C082/D_3039"/>
											</xsl:element>
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>companyName</xsl:text>
												</xsl:attribute>
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_NAD/C_C082/D_3055 = '182'">
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>SCAC</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="S_NAD/C_C082/D_3039"/>
											</xsl:element>
											<xsl:element name="CarrierIdentifier">
												<xsl:attribute name="domain">
													<xsl:text>companyName</xsl:text>
												</xsl:attribute>
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'CA']">
								<xsl:for-each select="G_SG35[S_RFF/C_C506/D_1153 = 'CN'][S_RFF/C_C506/D_1154 != ''][S_RFF/C_C506/D_4000 != '']">
									<xsl:element name="CarrierIdentifier">
										<xsl:attribute name="domain">
											<xsl:value-of select="S_RFF/C_C506/D_4000"/>
										</xsl:attribute>
										<xsl:value-of select="S_RFF/C_C506/D_1154"/>
									</xsl:element>
								</xsl:for-each>
							</xsl:for-each>
							<!-- ShipmentIdentifier -->
							<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'CA']">
								<xsl:variable name="role">
									<xsl:value-of select="S_NAD/D_3035"/>
								</xsl:variable>
								<xsl:for-each select="G_SG35">
									<xsl:choose>
										<xsl:when test="$role = 'CA' and S_RFF/C_C506/D_1153 = 'CN'">
											<xsl:element name="ShipmentIdentifier">
												<xsl:if test="S_DTM/C_C507/D_2005 = '89'">
													<xsl:attribute name="trackingNumberDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="S_DTM/C_C507[D_2005 = '89']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="S_DTM/C_C507[D_2005 = '89']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="S_RFF/C_C506/D_1154"/>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:element>
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'FC']/G_SG41/S_MOA/C_C516[D_5025 = '23'][1]"/>
							<xsl:with-param name="altMOA" select="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'FC']/G_SG41/S_MOA/C_C516[D_5025 = '23'][D_6343 = '11']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>
				<!-- ShipNoticeIDInfo -->
				<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'AAK']/D_1154 != ''">
					<xsl:element name="ShipNoticeIDInfo">
						<xsl:attribute name="shipNoticeID" select="G_SG29/S_RFF/C_C506[D_1153 = 'AAK']/D_1154"/>
						<xsl:if test="G_SG29[S_RFF/C_C506/D_1153 = 'AAK']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
							<xsl:attribute name="shipNoticeDate">
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="dateTime" select="G_SG29[S_RFF/C_C506/D_1153 = 'AAK']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
									<xsl:with-param name="dateTimeFormat" select="G_SG29[S_RFF/C_C506/D_1153 = 'AAK']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'DQ']/D_1154 != ''">
							<xsl:element name="IdReference ">
								<xsl:attribute name="domain">deliveryNoteID</xsl:attribute>
								<xsl:attribute name="identifier" select="G_SG29/S_RFF/C_C506[D_1153 = 'DQ']/D_1154"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="G_SG29[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380 != ''">
							<xsl:element name="IdReference ">
								<xsl:attribute name="domain">deliveryNoteDate</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime" select="G_SG29[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380"/>
										<xsl:with-param name="dateTimeFormat" select="G_SG29[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2379"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="G_SG29[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
							<xsl:element name="IdReference ">
								<xsl:attribute name="domain">deliveryNoteDate</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime" select="G_SG29[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
										<xsl:with-param name="dateTimeFormat" select="G_SG29[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'PK']/D_1154 != ''">
							<xsl:element name="IdReference ">
								<xsl:attribute name="domain">
									<xsl:text>packListID</xsl:text>
								</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'PK']/D_1154"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<!-- GrossAmount -->
			<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '128']/D_5004 != ''">
				<xsl:element name="GrossAmount">
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA" select="G_SG26/S_MOA/C_C516[D_5025 = '128']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<!-- InvoiceDetailDiscount -->
			<xsl:if test="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_MOA/C_C516[D_5025 = '52']/D_5004 != ''">
				<xsl:element name="InvoiceDetailDiscount">
					<xsl:if
						test="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG40/S_PCD/C_C501/D_5245 = '12' and G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG40/S_PCD/C_C501/D_5249 = '13'">
						<xsl:attribute name="percentageRate">
							<xsl:value-of select="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG40/S_PCD/C_C501/D_5482"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA" select="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_MOA/C_C516[D_5025 = '52'][1]"/>
						<xsl:with-param name="altMOA" select="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_MOA/C_C516[D_5025 = '52'][D_6343 = '11']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<xsl:if test="count($cleanALCList/G_ALC) &gt; 0">
				<xsl:element name="InvoiceItemModifications">
					<xsl:for-each select="$cleanALCList/G_ALC">
						<xsl:variable name="modCode">
							<xsl:value-of select="./S_ALC/C_C214/D_7161"/>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="S_ALC/D_5463 = 'A'">
								<xsl:element name="Modification">
									<xsl:if test="S_ALC/D_1227 != ''">
										<xsl:attribute name="level">
											<xsl:value-of select="S_ALC/D_1227"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="G_SG41/S_MOA/C_C516[D_5025 = '98']/D_5004 != ''">
										<xsl:element name="OriginalPrice">
											<xsl:call-template name="createMoney">
												<xsl:with-param name="MOA" select="G_SG41/S_MOA/C_C516[D_5025 = '98']"/>
												<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
											</xsl:call-template>
										</xsl:element>
									</xsl:if>
									<xsl:element name="AdditionalDeduction">
										<xsl:choose>
											<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004 != ''">
												<xsl:element name="DeductionAmount">
													<xsl:call-template name="createMoney">
														<xsl:with-param name="MOA" select="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']"/>
														<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
													</xsl:call-template>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG40/S_PCD/C_C501/D_5245 != ''">
												<xsl:element name="DeductionPercent">
													<xsl:attribute name="percent">
														<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
													</xsl:attribute>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '296']/D_5004 != ''">
												<xsl:element name="DeductedPrice">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '296']/D_6345"/>
														</xsl:attribute>
														<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '296']/D_5004"/>
													</xsl:element>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
									<xsl:element name="ModificationDetail">
										<xsl:attribute name="name">
											<xsl:choose>
												<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
													<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$modCode"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
											<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
													</xsl:with-param>
													<xsl:with-param name="dateTimeFormat">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
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
										<xsl:element name="Description">
											<xsl:attribute name="xml:lang">
												<xsl:text>en</xsl:text>
											</xsl:attribute>
											<xsl:if test="./S_ALC/C_C552/D_1230 != ''">
												<xsl:element name="ShortName">
													<xsl:value-of select="./S_ALC/C_C552/D_1230"/>
												</xsl:element>
											</xsl:if>
											<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
										</xsl:element>
										<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
											<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
											<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
											<xsl:if test="$codeSLookup != ''">
												<Extrinsic>
													<xsl:attribute name="name">settlementCode</xsl:attribute>
													<xsl:value-of select="$codeSLookup"/>
												</Extrinsic>
											</xsl:if>
										</xsl:if>
										<xsl:if test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004 != ''">
											<Extrinsic>
												<xsl:attribute name="name">AllowanceChargeBasisAmount</xsl:attribute>
												<!-- IG-2360 : add money element inside extrinsic -->
												<Money>
													<xsl:attribute name="currency">
														<xsl:choose>
															<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345 != ''">
																<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$currHead"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004"/>
												</Money>
											</Extrinsic>
										</xsl:if>
										<xsl:if test="G_SG41/S_MOA and G_SG40/S_PCD">
											<Extrinsic>
												<xsl:attribute name="name">deductionPercentage</xsl:attribute>
												<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
											</Extrinsic>
										</xsl:if>
										<xsl:if test="G_SG43/S_TAX[C_C241/D_5153 = 'VAT']/C_C243/D_5278 != ''">
											<Extrinsic>
												<xsl:attribute name="name">vatPercentageRate</xsl:attribute>
												<xsl:value-of select="G_SG43/S_TAX[C_C241/D_5153 = 'VAT'][1]/C_C243/D_5278"/>
											</Extrinsic>
										</xsl:if>
									</xsl:element>
								</xsl:element>
							</xsl:when>
							<xsl:when test="S_ALC/D_5463 = 'C'">
								<xsl:element name="Modification">
									<xsl:if test="S_ALC/D_1227 != ''">
										<xsl:attribute name="level">
											<xsl:value-of select="S_ALC/D_1227"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:element name="AdditionalCost">
										<xsl:choose>
											<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004 != ''">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="G_SG41/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="G_SG40/S_PCD/C_C501/D_5245 != ''">
												<xsl:element name="Percentage">
													<xsl:attribute name="percent">
														<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
													</xsl:attribute>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
									<xsl:element name="ModificationDetail">
										<xsl:attribute name="name">
											<xsl:choose>
												<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
													<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$modCode"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
											<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
													</xsl:with-param>
													<xsl:with-param name="dateTimeFormat">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
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
										<xsl:element name="Description">
											<xsl:attribute name="xml:lang">
												<xsl:text>en</xsl:text>
											</xsl:attribute>
											<xsl:if test="./S_ALC/C_C552/D_1230 != ''">
												<xsl:element name="ShortName">
													<xsl:value-of select="./S_ALC/C_C552/D_1230"/>
												</xsl:element>
											</xsl:if>
											<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
										</xsl:element>
										<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
											<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
											<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
											<xsl:if test="$codeSLookup != ''">
												<Extrinsic>
													<xsl:attribute name="name">settlementCode</xsl:attribute>
													<xsl:value-of select="$codeSLookup"/>
												</Extrinsic>
											</xsl:if>
										</xsl:if>
										<xsl:if test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004 != ''">
											<Extrinsic>
												<xsl:attribute name="name">AllowanceChargeBasisAmount</xsl:attribute>
												<!-- IG-2360 : add money element inside extrinsic -->
												<Money>
													<xsl:attribute name="currency">
														<xsl:choose>
															<xsl:when test="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345 != ''">
																<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_6345"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$currHead"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:value-of select="G_SG41/S_MOA/C_C516[D_5025 = '25']/D_5004"/>
												</Money>
											</Extrinsic>
										</xsl:if>
										<xsl:if test="G_SG41/S_MOA and G_SG40/S_PCD">
											<Extrinsic>
												<xsl:attribute name="name">chargePercentage</xsl:attribute>
												<xsl:value-of select="G_SG40/S_PCD/C_C501/D_5482"/>
											</Extrinsic>
										</xsl:if>
										<xsl:if test="G_SG43/S_TAX[C_C241/D_5153 = 'VAT']/C_C243/D_5278 != ''">
											<Extrinsic>
												<xsl:attribute name="name">vatPercentageRate</xsl:attribute>
												<xsl:value-of select="G_SG43/S_TAX[C_C241/D_5153 = 'VAT'][1]/C_C243/D_5278"/>
											</Extrinsic>
										</xsl:if>
									</xsl:element>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			<!-- NetAmount -->
			<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '203']/D_5004 != ''">
				<xsl:element name="NetAmount">
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA" select="G_SG26/S_MOA/C_C516[D_5025 = '203']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<!-- Distribution -->
			<xsl:for-each select="G_SG38[S_ALC/D_5463 = 'N' and S_ALC/C_C214/D_7161 = 'ADR']">
				<xsl:element name="Distribution">
					<xsl:element name="Accounting">
						<xsl:attribute name="name">
							<xsl:value-of select="S_ALC/C_C552/D_1230"/>
						</xsl:attribute>
						<xsl:element name="AccountingSegment">
							<xsl:attribute name="id">
								<xsl:value-of select="S_ALC/C_C214/D_7160"/>
							</xsl:attribute>
							<xsl:element name="Name">
								<xsl:attribute name="xml:lang">en</xsl:attribute>
								<xsl:value-of select="S_ALC/C_C214/D_7160_2"/>
							</xsl:element>
							<xsl:element name="Description">
								<xsl:attribute name="xml:lang">en</xsl:attribute>
								<xsl:value-of select="S_ALC/C_C214/D_7160_2"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="Charge">
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG41/S_MOA/C_C516[D_5025 = '8'][1]"/>
							<xsl:with-param name="altMOA" select="G_SG41/S_MOA/C_C516[D_5025 = '8'][D_6343 = '11']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:if test="$itemMode = 'item'">
				<xsl:for-each
					select="G_SG30[S_PAC/C_C202/D_7065 != '' or (S_MEA[D_6311 = 'PD']/C_C502/D_6313 != '' and S_MEA[D_6311 = 'PD']/C_C174/D_6314 != '' and S_MEA[D_6311 = 'PD']/C_C174/D_6411 != '')]">
					<xsl:element name="Packaging">
						<xsl:if test="S_PAC/C_C202/D_7065 != ''">
							<xsl:element name="PackagingCode">
								<xsl:value-of select="S_PAC/C_C202/D_7065"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 != ''">
							<xsl:element name="Dimension">
								<xsl:attribute name="quantity">
									<xsl:value-of select="S_MEA[D_6311 = 'PD']/C_C174/D_6314"/>
								</xsl:attribute>
								<xsl:attribute name="type">
									<xsl:choose>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'AAA'">unitNetWeight</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'AAB'">unitGrossWeight</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'AAC'">weight</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'AAD'">grossWeight</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'AAW'">grossVolume</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'AAX'">volume</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'HT'">height</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'LN'">length</xsl:when>
										<xsl:when test="S_MEA[D_6311 = 'PD']/C_C502/D_6313 = 'WD'">width</xsl:when>
									</xsl:choose>
								</xsl:attribute>
								<xsl:element name="UnitOfMeasure">
									<xsl:value-of select="S_MEA[D_6311 = 'PD']/C_C174/D_6411"/>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if test="S_PAC/C_C202/D_7064 != ''">
							<xsl:element name="Description">
								<xsl:attribute name="xml:lang">en</xsl:attribute>
								<xsl:value-of select="S_PAC/C_C202/D_7064"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:for-each>
				<xsl:if
					test="S_PIA[D_4347 = '1']//.[D_7143 = 'PV']/D_7140 != '' or G_SG26/S_MOA/C_C516[D_5025 = '11E']/D_5004 != '' or G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5118 != '' or G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5118 != '' or G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5118 != ''">
					<xsl:element name="InvoiceDetailItemIndustry">
						<xsl:element name="InvoiceDetailItemRetail">
							<xsl:if
								test="G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5118 != '' or G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5118 != '' or G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5118 != ''">
								<xsl:element name="AdditionalPrices">
									<xsl:if test="G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5118 != ''">
										<xsl:element name="UnitGrossPrice">
											<xsl:call-template name="createMoneyAlt">
												<xsl:with-param name="value" select="G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5118"/>
												<xsl:with-param name="cur" select="$currHead"/>
												<xsl:with-param name="altcur" select="$altCurrHead"/>
												<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
											</xsl:call-template>
											<!-- PriceBasisQuantity -->
											<xsl:if test="G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5284 != '' and G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_6411 != ''">
												<xsl:element name="PriceBasisQuantity">
													<xsl:attribute name="quantity">
														<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5284"/>
														<!--xsl:choose>												<xsl:when test="$isCreditMemo = 'yes'">												<xsl:value-of												select="concat('-', G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5284)"												/>												</xsl:when>												<xsl:otherwise>												<xsl:value-of												select="G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_5284"												/>												</xsl:otherwise>												</xsl:choose-->
													</xsl:attribute>
													<xsl:attribute name="conversionFactor">
														<xsl:value-of select="'1'"/>
													</xsl:attribute>
													<xsl:element name="UnitOfMeasure">
														<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAB']/D_6411"/>
													</xsl:element>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>
									<xsl:if test="G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5118 != ''">
										<xsl:element name="InformationalPrice">
											<xsl:call-template name="createMoneyAlt">
												<xsl:with-param name="value" select="G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5118"/>
												<xsl:with-param name="cur" select="$currHead"/>
												<xsl:with-param name="altcur" select="$altCurrHead"/>
												<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
											</xsl:call-template>
											<!-- PriceBasisQuantity -->
											<xsl:if test="G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5284 != '' and G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_6411 != ''">
												<xsl:element name="PriceBasisQuantity">
													<xsl:attribute name="quantity">
														<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5284"/>
														<!--xsl:choose>												<xsl:when test="$isCreditMemo = 'yes'">												<xsl:value-of												select="concat('-', G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5284)"												/>												</xsl:when>												<xsl:otherwise>												<xsl:value-of												select="G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_5284"												/>												</xsl:otherwise>												</xsl:choose-->
													</xsl:attribute>
													<xsl:attribute name="conversionFactor">
														<xsl:value-of select="'1'"/>
													</xsl:attribute>
													<xsl:element name="UnitOfMeasure">
														<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAE']/D_6411"/>
													</xsl:element>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>
									<xsl:if test="G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5118 != ''">
										<xsl:element name="InformationalPriceExclTax">
											<xsl:call-template name="createMoneyAlt">
												<xsl:with-param name="value" select="G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5118"/>
												<xsl:with-param name="cur" select="$currHead"/>
												<xsl:with-param name="altcur" select="$altCurrHead"/>
												<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
											</xsl:call-template>
											<!-- PriceBasisQuantity -->
											<xsl:if test="G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5284 != '' and G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_6411 != ''">
												<xsl:element name="PriceBasisQuantity">
													<xsl:attribute name="quantity">
														<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5284"/>
														<!--xsl:choose>												<xsl:when test="$isCreditMemo = 'yes'">												<xsl:value-of												select="concat('-', G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5284)"												/>												</xsl:when>												<xsl:otherwise>												<xsl:value-of												select="G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_5284"												/>												</xsl:otherwise>												</xsl:choose-->
													</xsl:attribute>
													<xsl:attribute name="conversionFactor">
														<xsl:value-of select="'1'"/>
													</xsl:attribute>
													<xsl:element name="UnitOfMeasure">
														<xsl:value-of select="G_SG28/S_PRI/C_C509[D_5125 = 'AAF']/D_6411"/>
													</xsl:element>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:if>
							<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '11E']">
								<xsl:element name="TotalRetailAmount">
									<xsl:call-template name="createMoneyAlt">
										<xsl:with-param name="value" select="G_SG26/S_MOA/C_C516[D_5025 = '11E']/D_5004"/>
										<xsl:with-param name="cur" select="G_SG26/S_MOA/C_C516[D_5025 = '11E']/D_6345"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:element>
							</xsl:if>
							<xsl:for-each select="S_IMD[D_7077 = 'C']">
								<xsl:variable name="indicatorCode" select="normalize-space(C_C273/D_7009)"/>
								<xsl:variable name="indicatorLookup" select="$lookups/Lookups/RetailItemIndicators/RetailItemIndicator[EDIFACTCode = $indicatorCode]/CXMLCode"/>
								<xsl:if test="$indicatorLookup != ''">
									<xsl:element name="ItemIndicator">
										<xsl:attribute name="value">
											<xsl:value-of select="$indicatorCode"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:value-of select="$indicatorLookup"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:for-each>
							<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'PV']/D_7140 != ''">
								<xsl:element name="PromotionVariantID">
									<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'PV']/D_7140"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<!-- Comments -->
			<xsl:variable name="comment">
				<xsl:for-each select="S_FTX[D_4451 = 'AAI']">
					<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="commentLang">
				<xsl:for-each select="S_FTX[D_4451 = 'AAI']">
					<xsl:value-of select="D_3453"/>
				</xsl:for-each>
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
			<!-- Extrinsics -->
			<xsl:if test="S_FTX[D_4451 = 'ACB']">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>SGPositionText</xsl:text>
					</xsl:attribute>
					<xsl:for-each select="S_FTX[D_4451 = 'ACB']">
						<xsl:value-of select="concat(C_C108/D_4440, S_FTX/C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>supplierOrderLineNum</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'ADE']/D_1154 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>GLAccount</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'ADE']/D_1154"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$itemMode = 'item'">
				<xsl:if test="G_SG32/S_LOC[D_3227 = '27']/C_C517/D_3225 != ''">
					<xsl:element name="Extrinsic">
						<xsl:attribute name="name">
							<xsl:text>ShipFromCountry</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="G_SG32/S_LOC[D_3227 = '27']/C_C517/D_3225"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="G_SG32/S_LOC[D_3227 = '28']/C_C517/D_3225 != ''">
					<xsl:element name="Extrinsic">
						<xsl:attribute name="name">
							<xsl:text>ShipToCountry</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="G_SG32/S_LOC[D_3227 = '28']/C_C517/D_3225"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="G_SG32/S_LOC[D_3227 = '19']/C_C517/D_3225 != ''">
					<xsl:element name="Extrinsic">
						<xsl:attribute name="name">
							<xsl:text>plantCode</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="G_SG32/S_LOC[D_3227 = '27']/C_C517/D_3225"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="S_QTY/C_C186[D_6063 = '52']">
					<xsl:element name="Extrinsic">
						<xsl:attribute name="name">
							<xsl:text>quantityPerPack</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="S_QTY/C_C186[D_6063 = '52']/D_6060"/>
					</xsl:element>
					<xsl:if test="S_QTY/C_C186[D_6063 = '52']/D_6411">
						<xsl:element name="Extrinsic">
							<xsl:attribute name="name">
								<xsl:text>quantityPerPackUOM</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="S_QTY/C_C186[D_6063 = '52']/D_6411"/>
						</xsl:element>
					</xsl:if>
				</xsl:if>
				<xsl:if test="S_QTY/C_C186[D_6063 = '59']">
					<xsl:element name="Extrinsic">
						<xsl:attribute name="name">
							<xsl:text>consumerUnitQuantity</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="S_QTY/C_C186[D_6063 = '59']/D_6060"/>
					</xsl:element>
					<xsl:if test="S_QTY/C_C186[D_6063 = '59']/D_6411">
						<xsl:element name="Extrinsic">
							<xsl:attribute name="name">
								<xsl:text>consumerUnitQuantityUOM</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="S_QTY/C_C186[D_6063 = '59']/D_6411"/>
						</xsl:element>
					</xsl:if>
				</xsl:if>
				<xsl:if test="S_QTY/C_C186[D_6063 = '192']">
					<xsl:element name="Extrinsic">
						<xsl:attribute name="name">
							<xsl:text>freeGoodsQuantity</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="S_QTY/C_C186[D_6063 = '192']/D_6060"/>
					</xsl:element>
					<xsl:if test="S_QTY/C_C186[D_6063 = '192']/D_6411">
						<xsl:element name="Extrinsic">
							<xsl:attribute name="name">
								<xsl:text>freeGoodsQuantityUOM</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="S_QTY/C_C186[D_6063 = '192']/D_6411"/>
						</xsl:element>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:for-each select="S_FTX[D_4451 = 'ZZZ']">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:value-of select="C_C108/D_4440"/>
					</xsl:attribute>
					<xsl:value-of select="concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
				</xsl:element>
			</xsl:for-each>
			<!-- IG-1853 -->
			<xsl:if test="G_SG30[S_PAC/D_7224 != '']">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>numberOfPackages</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="G_SG30[S_PAC/D_7224 != '']/S_PAC/D_7224"/>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="G_SG29/S_RFF/C_C506[D_1153 = 'ZZZ']">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:value-of select="./D_1154"/>
					</xsl:attribute>
					<xsl:value-of select="./D_4000"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
