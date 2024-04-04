<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anPayloadID"/>
	<xsl:param name="anCorrelationID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anSenderID"/>
	<xsl:param name="anReceiverID"/>
	<xsl:param name="anDocNumber"/>
	<xsl:param name="anDocType"/>
	<xsl:param name="anDocReferenceID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anOrginalPayloadID"/>

	<!--xsl:variable name="ErrorCodeLookup" select="document('EDI_ACKErrorCodes.xml')"/-->
	<xsl:variable name="ErrorCodeLookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ERRORCODES_D96A.xml')"/>

	<xsl:template match="*">
		<xsl:variable name="date" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
		<xsl:variable name="time" select="format-time(current-time(), '[H01]:[m01]:[s01] [Z]')"/>
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="concat($date,'T',$time)"/>
			</xsl:attribute>
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<Header>
				<From>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anSenderID"/>
						</Identity>
					</Credential>
				</From>
				<To>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anReceiverID"/>
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
				<xsl:choose>
					<xsl:when test="$anEnvName='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="code1" select="FunctionalGroup/M_997/G_AK2/S_AK5/D_718_1"/>
				<xsl:variable name="code2" select="FunctionalGroup/M_997/G_AK2/S_AK5/D_718_2"/>
				<xsl:variable name="code3" select="FunctionalGroup/M_997/G_AK2/S_AK5/D_718_3"/>
				<xsl:variable name="code4" select="FunctionalGroup/M_997/G_AK2/S_AK5/D_718_4"/>
				<xsl:variable name="code5" select="FunctionalGroup/M_997/G_AK2/S_AK5/D_718_5"/>

				<xsl:variable name="scode1" select="FunctionalGroup/M_997/S_AK9/D_716_1"/>
				<xsl:variable name="scode2" select="FunctionalGroup/M_997/S_AK9/D_716_2"/>
				<xsl:variable name="scode3" select="FunctionalGroup/M_997/S_AK9/D_716_3"/>
				<xsl:variable name="scode4" select="FunctionalGroup/M_997/S_AK9/D_716_4"/>
				<xsl:variable name="scode5" select="FunctionalGroup/M_997/S_AK9/D_716_5"/>
				<xsl:variable name="errorNotes">
					<xsl:choose>
						<xsl:when test="FunctionalGroup/M_997/G_AK2">
							<xsl:value-of select="normalize-space(concat($ErrorCodeLookup/Lookups/X12_D718_Codes/X12_D718_Code[X12Code=$code1]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D718_Codes/X12_D718_Code[X12Code=$code2]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D718_Codes/X12_D718_Code[X12Code=$code3]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D718_Codes/X12_D718_Code[X12Code=$code4]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D718_Codes/X12_D718_Code[X12Code=$code5]/X12Description))"/>
						</xsl:when>
						<xsl:when test="FunctionalGroup/M_997/S_AK9">
							<xsl:value-of select="normalize-space(concat($ErrorCodeLookup/Lookups/X12_D716_Codes/X12_D716_Code[X12Code=$scode1]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D716_Codes/X12_D716_Code[X12Code=$scode2]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D716_Codes/X12_D716_Code[X12Code=$scode3]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D716_Codes/X12_D716_Code[X12Code=$scode4]/X12Description, ' ', $ErrorCodeLookup/Lookups/X12_D716_Codes/X12_D716_Code[X12Code=$scode5]/X12Description))"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>

				<StatusUpdateRequest>
					<DocumentReference>
						<xsl:attribute name="payloadID">
							<xsl:value-of select="$anOrginalPayloadID"/>
						</xsl:attribute>
					</DocumentReference>
					<Status>
						<xsl:attribute name="text">
							<xsl:choose>
								<xsl:when test="FunctionalGroup/M_997/G_AK2/S_AK5/D_717 = 'A'">Received</xsl:when>
								<xsl:when test="FunctionalGroup/M_997/S_AK9/D_715 = 'A'">Received</xsl:when>
								<xsl:otherwise>Failed</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="code">
							<xsl:choose>
								<xsl:when test="FunctionalGroup/M_997/G_AK2/S_AK5/D_717 = 'A'">201</xsl:when>
								<xsl:when test="FunctionalGroup/M_997/S_AK9/D_715 = 'A'">201</xsl:when>
								<xsl:otherwise>400</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="FunctionalGroup/M_997/G_AK2/S_AK5/D_717 = 'A'">
								<xsl:text>Positive 997 received.</xsl:text>
							</xsl:when>
							<xsl:when test="FunctionalGroup/M_997/S_AK9/D_715 = 'A'">
								<xsl:text>Positive 997 received.</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space(concat('Negative 997 received. ', $errorNotes))"/>
							</xsl:otherwise>
						</xsl:choose>
					</Status>

					<IntegrationStatus>
						<xsl:attribute name="documentStatus">
							<xsl:choose>
								<xsl:when test="FunctionalGroup/M_997/G_AK2/S_AK5/D_717 = 'A'">customerReceived</xsl:when>
								<xsl:when test="FunctionalGroup/M_997/S_AK9/D_715 = 'A'">customerReceived</xsl:when>
								<xsl:otherwise>customerFailed</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<IntegrationMessage>
							<xsl:attribute name="isSuccessful">
								<xsl:choose>
									<xsl:when test="FunctionalGroup/M_997/G_AK2/S_AK5/D_717 = 'A'">
										<xsl:text>yes</xsl:text>
									</xsl:when>
									<xsl:when test="FunctionalGroup/M_997/S_AK9/D_715 = 'A'">
										<xsl:text>yes</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>no</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="type">
								<xsl:text>997</xsl:text>
							</xsl:attribute>
						</IntegrationMessage>
					</IntegrationStatus>
				</StatusUpdateRequest>
			</Request>
		</cXML>
	</xsl:template>
</xsl:stylesheet>
