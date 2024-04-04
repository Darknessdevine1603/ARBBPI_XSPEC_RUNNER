<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>

	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>
	<!--xsl:variable name="SURStatus" select="document('SURStatusCodes.xml')"/-->
	<xsl:variable name="SURStatus" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_SURStatus.xml')"/>

	<xsl:template match="/">
		<xsl:variable name="BODID" select="concat(ConfirmBOD/ApplicationArea/BODID, '')"/>
		<xsl:variable name="documentid" select="concat(ConfirmBOD/ApplicationArea/BODID, '')"/>
		<xsl:variable name="CreationDateTime" select="concat(ConfirmBOD/ApplicationArea/CreationDateTime, '')"/>

		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="current-dateTime()"/>
			</xsl:attribute>
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
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
					<Credential domain="NetworkId">
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
				<xsl:choose>
					<xsl:when test="$anEnvName = 'PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<StatusUpdateRequest>
					<DocumentReference>
						<xsl:attribute name="payloadID">
							<xsl:value-of select="concat(ConfirmBOD/DataArea/Confirm/OriginalApplicationArea/BODID, '')"/>
						</xsl:attribute>
					</DocumentReference>
					<Status>
						<xsl:variable name="actionCode">
							<xsl:value-of select="ConfirmBOD/DataArea/Confirm/ResponseCriteria/ResponseExpression/@actionCode"/>
						</xsl:variable>
						<xsl:attribute name="code">
							<xsl:value-of select="concat($SURStatus/SURStatusLookup/SURStatus[SupplierFormat = 'OAGIS'][SupplierText = $actionCode]/cXMLCode, '')"/>
						</xsl:attribute>
						<xsl:attribute name="text">
							<xsl:value-of select="concat($SURStatus/SURStatusLookup/SURStatus[SupplierFormat = 'OAGIS'][SupplierText = $actionCode]/cXMLText, '')"/>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="ConfirmBOD/DataArea/BOD/BODSuccessMessage/NounSuccessMessage">
								<xsl:value-of select="normalize-space(concat(ConfirmBOD/DataArea/BOD/BODSuccessMessage/NounSuccessMessage/ProcessMessage/Description, ' ', ConfirmBOD/DataArea/BOD/BODSuccessMessage/NounSuccessMessage/WarningProcessMessage/Description))"/>
							</xsl:when>
							<xsl:when test="ConfirmBOD/DataArea/BOD/BODFailureMessage">
								<xsl:value-of select="normalize-space(concat(ConfirmBOD/DataArea/BOD/BODFailureMessage/ErrorProcessMessage/Description, ' ', ConfirmBOD/DataArea/BOD/BODFailureMessage/WarningProcessMessage/Description))"/>
							</xsl:when>
						</xsl:choose>
					</Status>
				</StatusUpdateRequest>
			</Request>
		</cXML>
	</xsl:template>
</xsl:stylesheet>
