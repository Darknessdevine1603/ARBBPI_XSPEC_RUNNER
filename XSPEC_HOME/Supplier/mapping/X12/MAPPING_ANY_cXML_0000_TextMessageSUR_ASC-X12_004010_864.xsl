<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anEnvName"/>
	<xsl:param name="anISASender"/>
	<xsl:param name="anISASenderQual"/>
	<xsl:param name="anISAReceiver"/>
	<xsl:param name="anISAReceiverQual"/>
	<xsl:param name="anICNValue"/>
	<xsl:param name="anSenderGroupID"/>
	<xsl:param name="anReceiverGroupID"/>
	<xsl:param name="exchange"/>

	<!-- For local testing -->
	<!-- xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>
		<xsl:include href="Format_CXML_ASC-X12_common.xsl"/-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>


	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>

		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:824:004010">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>

			<FunctionalGroup>
				<S_GS>
					<D_479>TX</D_479>
					<D_142>
						<xsl:choose>
							<xsl:when test="$anSenderGroupID != ''">
								<xsl:value-of select="$anSenderGroupID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ARIBA</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</D_142>
					<D_124>
						<xsl:choose>
							<xsl:when test="$anReceiverGroupID != ''">
								<xsl:value-of select="$anReceiverGroupID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ARIBA</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</D_124>
					<D_373>
						<xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
					</D_373>
					<D_337>
						<xsl:value-of select="format-dateTime($dateNow, '[H01][m01][s01]')"/>
					</D_337>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
					<D_455>X</D_455>
					<D_480>004010</D_480>
				</S_GS>

				<M_864>
					<S_ST>
						<D_143>864</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BMG>
						<xsl:element name="D_353">SU</xsl:element>
						<xsl:element name="D_352">
							<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType"/>
						</xsl:element>
					</S_BMG>
					<xsl:variable name="surDate" select="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate"/>
					<xsl:if test="$surDate != ''">
						<S_DTM>
							<D_374>999</D_374>
							<D_373>
								<xsl:value-of select="replace(substring($surDate, 0, 11), '-', '')"/>
							</D_373>
							<D_337>
								<xsl:value-of select="replace(substring($surDate, 12, 8), ':', '')"/>
							</D_337>
							<xsl:variable name="timeZone" select="replace(replace(substring($surDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
							<xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
								<D_623>
									<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
								</D_623>
							</xsl:if>
						</S_DTM>
					</xsl:if>
					<G_MIT>
						<S_MIT>
							<D_127>
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID"/>
							</D_127>
							<D_352>
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/@type"/>
							</D_352>
						</S_MIT>
						<xsl:if test="lower-case(cXML/Request/StatusUpdateRequest/DocumentStatus/@type) = 'declined'">
							<S_MSG>
								<D_933>
									<xsl:value-of select="cXML/Request/StatusUpdateRequest/Status/@code"/>
								</D_933>
							</S_MSG>
							<S_MSG>
								<D_933>
									<xsl:value-of select="cXML/Request/StatusUpdateRequest/Status/@text"/>
								</D_933>
							</S_MSG>
						</xsl:if>
						<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/Comments) != ''">
							<S_MSG>
								<D_933>
									<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/Comments"/>
								</D_933>
							</S_MSG>
						</xsl:if>
						<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/Status) != ''">
							<xsl:variable name="comments" select="normalize-space(cXML/Request/StatusUpdateRequest/Status)"/>
							<xsl:variable name="StrLen" select="string-length($comments)"/>
							<xsl:call-template name="MSGLoop">
								<xsl:with-param name="Desc" select="$comments"/>
								<xsl:with-param name="StrLen" select="$StrLen"/>
								<xsl:with-param name="Pos" select="1"/>
								<xsl:with-param name="CurrentEndPos" select="1"/>
							</xsl:call-template>
						</xsl:if>
					</G_MIT>

					<!-- Summary -->
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_864>
				<S_GE>
					<D_97>1</D_97>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
				</S_GE>
			</FunctionalGroup>

			<S_IEA>
				<D_I16>1</D_I16>
				<D_I12>
					<xsl:value-of select="$anICNValue"/>
				</D_I12>
			</S_IEA>
		</ns0:Interchange>

	</xsl:template>


</xsl:stylesheet>
