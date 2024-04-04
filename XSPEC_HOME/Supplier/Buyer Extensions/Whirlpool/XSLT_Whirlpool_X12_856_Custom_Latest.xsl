<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>
	<!--xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/-->
	<!-- for dynamic, reading from Partner Directory -->
	<xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>

	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//ShipNoticeRequest/ShipNoticeHeader/Extrinsic[last()]">
		<xsl:copy-of select="."/>
		<xsl:call-template name="createExtrinsics"/>
	</xsl:template>
	<xsl:template match="//ShipNoticeRequest/ShipNoticeHeader[not(exists(Extrinsic))]">
		<xsl:element name="ShipNoticeHeader">
			<xsl:apply-templates select="(node()|@*)[name(.)!='IdReference']"/>
			<xsl:call-template name="createExtrinsics"/>
			<xsl:apply-templates select="IdReference"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//ShipNoticeRequest/ShipNoticeHeader/Contact[last()]">
		<xsl:copy-of select="."/>

		<xsl:if test="/Combined/source//M_856/G_HL[S_HL/D_735 = 'S']/G_N1[S_N1/D_98_1 = '13']">

			<xsl:call-template name="createContact">
				<xsl:with-param name="contact" select="//M_856//G_HL[S_HL/D_735 = 'S']/G_N1[S_N1/D_98_1 = '13']"/>
				<xsl:with-param name="role" select="'thirdPartyLogisticsProvider'"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>
	<xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem">
		<xsl:element name="ShipNoticeItem">
			<xsl:variable name="linenum" select="@shipNoticeLineNumber"/>
			<xsl:apply-templates select="@* | node()"> </xsl:apply-templates>
			<!--xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'D2']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">supplierDocumentID</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'D2']/D_127"/>
				</xsl:element>
			</xsl:if-->
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_SN1/D_646 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">agentsShipmentNumber</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_SN1/D_646"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'BO']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">binLocationNo</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'BO']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = '55']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">sequenceNo</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = '55']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'LF']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">assemblyLineFeedLocation</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'LF']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'MI']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">millOrderNo</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'MI']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'LS']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">barCodedSerialNo</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'LS']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'HC']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">heatCode</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'HC']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'SZ']/D_127 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">revisionNo</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'SZ']/D_127"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SupplierPartID">
		<xsl:variable name="linenum" select="../../@shipNoticeLineNumber"/>
		<xsl:element name="SupplierPartID">
			<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'SZ']/D_127 != ''">
				<xsl:attribute name="revisionID">
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_REF[D_128 = 'SZ']/D_127"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@* | node()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="createExtrinsics">
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'YE']/D_93 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">servicer</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'YE']/D_93"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'YE']/D_67 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">servicePerformedCode</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'YE']/D_67"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'SP']/D_93 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">freightBillNo</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'SP']/D_93"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'SP']/D_67 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">freightPayorReferenceNo</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = 'SP']/D_67"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = '98']/D_93 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">serviceRequestNo</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = '98']/D_93"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = '98']/D_67 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">serviceOrderNo</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/G_N1/S_N1[D_98_1 = '98']/D_67"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S']/S_REF[D_128 = 'PE']/D_127 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">plantNo</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/S_REF[D_128 = 'PE']/D_127"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="createContact">
		<xsl:param name="contact"/>
		<xsl:param name="role"/>
		<xsl:element name="Contact">
			<xsl:attribute name="role">
				<xsl:value-of select="$role"/>
			</xsl:attribute>
			<xsl:if test="$contact/S_N1/D_66 != '' or $contact/S_N1/D_67 != ''">
				<xsl:variable name="addrDomain">
					<xsl:value-of select="$contact/S_N1/D_66"/>
				</xsl:variable>
				<xsl:variable name="addressID">
					<xsl:value-of select="$contact/S_N1/D_67"/>
				</xsl:variable>
				<xsl:if test="$addressID != ''">
					<xsl:attribute name="addressID">
						<xsl:value-of select="$addressID"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
					<xsl:if test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode != ''">
						<xsl:attribute name="addressIDDomain">
							<xsl:value-of select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:element name="Name">
				<xsl:attribute name="xml:lang">en</xsl:attribute>
				<xsl:value-of select="$contact/S_N1/D_93"/>
			</xsl:element>
			<!-- PostalAddress -->
			<xsl:if test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
				<xsl:element name="PostalAddress">
					<xsl:for-each select="$contact/S_N2">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="D_93_1"/>
						</xsl:element>
						<xsl:if test="D_93_2 != ''">
							<xsl:element name="DeliverTo">
								<xsl:value-of select="D_93_2"/>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="$contact/S_N3">
						<xsl:element name="Street">
							<xsl:value-of select="D_166_1"/>
						</xsl:element>
						<xsl:if test="D_166_2 != ''">
							<xsl:element name="Street">
								<xsl:value-of select="D_166_2"/>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
					<xsl:element name="City">
						<xsl:value-of select="$contact/S_N4/D_19"/>
					</xsl:element>
					<xsl:variable name="stateCode">
						<xsl:choose>
							<xsl:when test="$contact/S_N4/D_310 != '' and not(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA'))">
								<xsl:value-of select="$contact/S_N4/D_310"/>
							</xsl:when>
							<xsl:when test="$contact/S_N4/D_156 != ''">
								<xsl:value-of select="$contact/S_N4/D_156"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$stateCode != ''">
						<xsl:element name="State">
							<xsl:if test="$contact/S_N4/D_156 != ''">
								<xsl:attribute name="isoStateCode">
									<xsl:value-of select="$stateCode"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA') and $Lookup/Lookups/States/State[stateCode = $stateCode]/stateName != '')">
									<xsl:value-of select="$Lookup/Lookups/States/State[stateCode = $stateCode]/stateName"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stateCode"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$contact/S_N4/D_116 != ''">
						<xsl:element name="PostalCode">
							<xsl:value-of select="$contact/S_N4/D_116"/>
						</xsl:element>
					</xsl:if>
					<xsl:variable name="isoCountryCode">
						<xsl:value-of select="$contact/S_N4/D_26"/>
					</xsl:variable>
					<xsl:element name="Country">
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$isoCountryCode"/>
						</xsl:attribute>
						<xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:variable name="contactList">
				<xsl:apply-templates select="$contact/S_PER"/>
			</xsl:variable>
			<xsl:for-each select="$contactList/Con[@type = 'Email']">
				<xsl:sort select="@name"/>
				<xsl:element name="Email">
					<xsl:attribute name="name">
						<xsl:value-of select="./@name"/>
					</xsl:attribute>
					<xsl:value-of select="./@value"/>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="$contactList/Con[@type = 'Phone']">
				<xsl:sort select="@name"/>
				<xsl:variable name="cCode" select="@cCode"/>
				<xsl:element name="Phone">
					<xsl:attribute name="name">
						<xsl:value-of select="./@name"/>
					</xsl:attribute>
					<xsl:element name="TelephoneNumber">
						<xsl:element name="CountryCode">
							<xsl:attribute name="isoCountryCode">
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
										<xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
									</xsl:when>
									<xsl:otherwise>US</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:value-of select="replace(@cCode, '\+', '')"/>
						</xsl:element>
						<xsl:element name="AreaOrCityCode">
							<xsl:value-of select="@aCode"/>
						</xsl:element>
						<xsl:element name="Number">
							<xsl:value-of select="@num"/>
						</xsl:element>
						<xsl:if test="@ext != ''">
							<xsl:element name="Extension">
								<xsl:value-of select="@ext"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="$contactList/Con[@type = 'Fax']">
				<xsl:sort select="@name"/>
				<xsl:variable name="cCode" select="@cCode"/>
				<xsl:element name="Fax">
					<xsl:attribute name="name">
						<xsl:value-of select="./@name"/>
					</xsl:attribute>
					<xsl:element name="TelephoneNumber">
						<xsl:element name="CountryCode">
							<xsl:attribute name="isoCountryCode">
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
										<xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
									</xsl:when>
									<xsl:otherwise>US</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:value-of select="replace(@cCode, '\+', '')"/>
						</xsl:element>
						<xsl:element name="AreaOrCityCode">
							<xsl:value-of select="@aCode"/>
						</xsl:element>
						<xsl:element name="Number">
							<xsl:value-of select="@num"/>
						</xsl:element>
						<xsl:if test="@ext != ''">
							<xsl:element name="Extension">
								<xsl:value-of select="@ext"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="$contactList/Con[@type = 'URL']">
				<xsl:sort select="@name"/>
				<xsl:element name="URL">
					<xsl:attribute name="name">
						<xsl:value-of select="./@name"/>
					</xsl:attribute>
					<xsl:value-of select="./@value"/>
				</xsl:element>
			</xsl:for-each>

			<xsl:if test="$contact/S_REF[D_128 = 'VR']">
				<xsl:element name="IdReference">
					<xsl:attribute name="domain">
						<xsl:value-of select="'vendorID'"/>
					</xsl:attribute>
					<xsl:attribute name="identifier">
						<xsl:value-of select="normalize-space($contact/S_REF[D_128 = 'VR']/D_127)"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="S_PER">
		<xsl:variable name="PER02">
			<xsl:choose>
				<xsl:when test="D_93 != ''">
					<xsl:value-of select="D_93"/>
				</xsl:when>
				<xsl:otherwise>default</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="D_365_1 = 'EM'">
				<Con>
					<xsl:attribute name="type">Email</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_1)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_1 = 'UR'">
				<Con>
					<xsl:attribute name="type">URL</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_1)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_1 = 'TE'">
				<Con>
					<xsl:attribute name="type">Phone</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, '(')">
								<xsl:value-of select="substring-before(D_364_1, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, '-')">
								<xsl:value-of select="substring-before(D_364_1, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_1, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_1, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_1 = 'FX'">
				<Con>
					<xsl:attribute name="type">Fax</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, '(')">
								<xsl:value-of select="substring-before(D_364_1, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, '-')">
								<xsl:value-of select="substring-before(D_364_1, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_1, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_1, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="D_365_2 = 'EM'">
				<Con>
					<xsl:attribute name="type">Email</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_2)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_2 = 'UR'">
				<Con>
					<xsl:attribute name="type">URL</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_2)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_2 = 'TE'">
				<Con>
					<xsl:attribute name="type">Phone</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, '(')">
								<xsl:value-of select="substring-before(D_364_2, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, '-')">
								<xsl:value-of select="substring-before(D_364_2, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_2, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_2, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_2 = 'FX'">
				<Con>
					<xsl:attribute name="type">Fax</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, '(')">
								<xsl:value-of select="substring-before(D_364_2, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, '-')">
								<xsl:value-of select="substring-before(D_364_2, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_2, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_2, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="D_365_3 = 'EM'">
				<Con>
					<xsl:attribute name="type">Email</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_3)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_3 = 'UR'">
				<Con>
					<xsl:attribute name="type">URL</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_3)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_3 = 'TE'">
				<Con>
					<xsl:attribute name="type">Phone</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, '(')">
								<xsl:value-of select="substring-before(D_364_3, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, '-')">
								<xsl:value-of select="substring-before(D_364_3, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_3, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_3, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_3 = 'FX'">
				<Con>
					<xsl:attribute name="type">Fax</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, '(')">
								<xsl:value-of select="substring-before(D_364_3, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, '-')">
								<xsl:value-of select="substring-before(D_364_3, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_3, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_3, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
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
