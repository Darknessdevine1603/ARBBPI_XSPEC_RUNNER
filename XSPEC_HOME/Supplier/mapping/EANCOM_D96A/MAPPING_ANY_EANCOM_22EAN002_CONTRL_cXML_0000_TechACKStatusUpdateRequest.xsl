<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
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
	<xsl:variable name="ErrorCodeLookup"
		select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ERRORCODES_D96A.xml')"/>
	<xsl:template match="*">
		<xsl:variable name="date" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
		<xsl:variable name="time" select="format-time(current-time(), '[H01]:[m01]:[s01] [Z]')"/>
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="concat($date, 'T', $time)"/>
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
					<xsl:when test="$anEnvName = 'PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="errorCode" select="M_CONTRL/S_UCI/D_0085"/>
				<xsl:variable name="errorNotes">
					<xsl:choose>
						<xsl:when
							test="$ErrorCodeLookup/Lookups/ContrlErrorMsgs/ContrlErrorMsg[ErrorCode = $errorCode]/ErrorDescription">
							<xsl:value-of
								select="$ErrorCodeLookup/Lookups/ContrlErrorMsgs/ContrlErrorMsg[ErrorCode = $errorCode]/ErrorDescription"
							/>
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
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '7' and M_CONTRL/G_SG1/S_UCM/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))"
									>Received</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '8' and M_CONTRL/G_SG1/S_UCM/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))"
									>Received</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
									>Received</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
									>Received</xsl:when>
								<xsl:otherwise>Failed</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="code">
							<xsl:choose>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '7' and M_CONTRL/G_SG1/S_UCM/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))"
									>201</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '8' and M_CONTRL/G_SG1/S_UCM/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))"
									>201</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
									>201</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
									>201</xsl:when>
								<xsl:otherwise>400</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when
								test="M_CONTRL/S_UCI/D_0083 = '7' and M_CONTRL/G_SG1/S_UCM/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))">
								<xsl:text>Positive CONTRL received.</xsl:text>
							</xsl:when>
							<xsl:when
								test="M_CONTRL/S_UCI/D_0083 = '8' and M_CONTRL/G_SG1/S_UCM/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))">
								<xsl:text>Positive CONTRL received.</xsl:text>
							</xsl:when>
							<xsl:when
								test="M_CONTRL/S_UCI/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
								>Positive CONTRL received.</xsl:when>
							<xsl:when
								test="M_CONTRL/S_UCI/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
								>Positive CONTRL received.</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="normalize-space(concat('Negative CONTRL received. ', $errorNotes))"/>
							</xsl:otherwise>
						</xsl:choose>
					</Status>
					<IntegrationStatus>
						<xsl:attribute name="documentStatus">
							<xsl:choose>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '7' and M_CONTRL/G_SG1/S_UCM/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))"
									>customerReceived</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '8' and M_CONTRL/G_SG1/S_UCM/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))"
									>customerReceived</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
									>customerReceived</xsl:when>
								<xsl:when
									test="M_CONTRL/S_UCI/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
									>customerReceived</xsl:when>
								<xsl:otherwise>customerFailed</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<IntegrationMessage>
							<xsl:attribute name="isSuccessful">
								<xsl:choose>
									<xsl:when
										test="M_CONTRL/S_UCI/D_0083 = '7' and M_CONTRL/G_SG1/S_UCM/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))">
										<xsl:text>yes</xsl:text>
									</xsl:when>
									<xsl:when
										test="M_CONTRL/S_UCI/D_0083 = '8' and M_CONTRL/G_SG1/S_UCM/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/G_SG2/S_UCS))">
										<xsl:text>yes</xsl:text>
									</xsl:when>
									<xsl:when
										test="M_CONTRL/S_UCI/D_0083 = '7' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
										>yes</xsl:when>
									<xsl:when
										test="M_CONTRL/S_UCI/D_0083 = '8' and not(exists(M_CONTRL/G_SG1/S_UCM/D_0083))"
										>yes</xsl:when>
									<xsl:otherwise>
										<xsl:text>no</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="type">
								<xsl:text>CONTRL</xsl:text>
							</xsl:attribute>
						</IntegrationMessage>
					</IntegrationStatus>
				</StatusUpdateRequest>
			</Request>
		</cXML>
	</xsl:template>
</xsl:stylesheet>
