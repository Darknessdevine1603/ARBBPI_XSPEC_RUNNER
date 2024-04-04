<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<!--xsl:variable name="SURStatus" select="document('SURStatusCodes.xml')"/-->
	<xsl:variable name="SURStatus" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_SURStatus.xml')"/>
	<xsl:template match="/">
		<xsl:variable name="code">
			<xsl:value-of select="cXML/Request/StatusUpdateRequest/Status/@code"/>
		</xsl:variable>
		<ConfirmBOD>
			<ApplicationArea>
				<Sender>
					<LogicalID>
						<xsl:value-of select="$anAlternativeSender"/>
					</LogicalID>
					<ComponentID>StatusUpdateRequest</ComponentID>
				</Sender>
				<CreationDateTime>
					<xsl:value-of select="cXML/@timestamp"/>
				</CreationDateTime>
				<BODID>
					<xsl:value-of select="cXML/@payloadID"/>
				</BODID>
				<UserArea>
					<DUNSID schemeID="ReceiverKey">
						<xsl:value-of select="$anAlternativeReceiver"/>
					</DUNSID>
				</UserArea>
			</ApplicationArea>
			<DataArea>
				<Confirm>
					<OriginalApplicationArea>
						<Sender>
							<LogicalID>
								<xsl:value-of select="$anAlternativeReceiver"/>
							</LogicalID>
						</Sender>
						<CreationDateTime>
							<xsl:value-of select="cXML/@timestamp"/>
						</CreationDateTime>
						<BODID>
							<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentReference/@payloadID"/>
						</BODID>
						<UserArea>
							<DUNSID>
								<xsl:value-of select="$anAlternativeSender"/>
							</DUNSID>
						</UserArea>
					</OriginalApplicationArea>
					<ResponseCriteria>
						<ResponseExpression>
							<xsl:attribute name="actionCode">
								<xsl:choose>
									<xsl:when test="cXML/Request/StatusUpdateRequest/Status/@text = 'accepted'">
										<xsl:text>Accepted</xsl:text>
									</xsl:when>
									<xsl:when test="cXML/Request/StatusUpdateRequest/Status/@text = 'rejected'">
										<xsl:text>Rejected</xsl:text>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
						</ResponseExpression>
					</ResponseCriteria>
				</Confirm>
				<BOD>
					<xsl:choose>
						<xsl:when test="cXML/Request/StatusUpdateRequest/Status/@text = 'accepted'">
							<BODSuccessMessage>
								<NounSuccessMessage>
									<ProcessMessage>
										<Description>
											<xsl:value-of select="cXML/Request/StatusUpdateRequest/Status"/>
										</Description>
									</ProcessMessage>
								</NounSuccessMessage>
							</BODSuccessMessage>
						</xsl:when>
						<xsl:when test="cXML/Request/StatusUpdateRequest/Status/@text = 'rejected'">
							<BODFailureMessage>
								<ErrorProcessMessage>
									<Description>
										<xsl:value-of select="cXML/Request/StatusUpdateRequest/Status"/>
									</Description>
								</ErrorProcessMessage>
							</BODFailureMessage>
						</xsl:when>
					</xsl:choose>
				</BOD>
			</DataArea>
		</ConfirmBOD>
	</xsl:template>
</xsl:stylesheet>
