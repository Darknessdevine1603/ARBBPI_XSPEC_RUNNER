<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>

	<!-- Local testing-->
	<!--xsl:include href="FORMAT_cXML_0000_OAGIS_9.2.xsl"/>
	<xsl:variable name="Lookups" select="document('LOOKUP_OAGIS_9.2.xml')"/-->
	<!-- PD Entries-->
	<xsl:include href="FORMAT_cXML_0000_OAGIS_9.2.xsl"/>
	<xsl:variable name="Lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_OAGIS_9.2.xml')"/>

	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<xsl:template match="/">
		<NotifyPlanningSchedule>
			<ApplicationArea>
				<Sender>
					<LogicalID>
						<xsl:value-of select="$anAlternativeSender"/>
					</LogicalID>
					<TaskID>FORECAST</TaskID>
				</Sender>
				<CreationDateTime>
					<xsl:value-of select="cXML/@timestamp"/>
				</CreationDateTime>
				<BODID>
					<xsl:value-of select="cXML/@payloadID"/>
				</BODID>
			</ApplicationArea>
			<DataArea>
				<Notify>
					<ActionCriteria>
						<ActionExpression actionCode="Add">Create</ActionExpression>
						<ChangeStatus>
							<Code name="Priority">Normal</Code>
						</ChangeStatus>
					</ActionCriteria>
				</Notify>
				<PlanningSchedule>
					<PlanningScheduleHeader>
						<DocumentReference>
							<DocumentDateTime>
								<xsl:value-of select="cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate"/>
							</DocumentDateTime>
						</DocumentReference>
						<Party>
							<PartyIDs>
								<ID>
									<xsl:value-of select="$anAlternativeReceiver"/>
								</ID>
							</PartyIDs>
						</Party>
						<ShipToParty>
							<PartyIDs>
								<ID>
									<xsl:value-of select="$anAlternativeSender"/>
								</ID>
							</PartyIDs>
						</ShipToParty>
					</PlanningScheduleHeader>
					<xsl:for-each select="cXML/Message/ProductActivityMessage/ProductActivityDetails">
						<PlanningScheduleLine>
							<LineNumber>
								<xsl:value-of select="position()"/>
							</LineNumber>
							<xsl:if test="Classification">
								<DocumentReference>
									<xsl:for-each select="Classification">
										<Status>
											<Description>
												<xsl:attribute name="type">
													<xsl:value-of select="@domain"/>
												</xsl:attribute>
												<xsl:attribute name="languageID">
													<xsl:text>en</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="."/>
											</Description>
										</Status>
									</xsl:for-each>
								</DocumentReference>
							</xsl:if>
							<ManufacturingItem>
								<xsl:if test="ItemID/BuyerPartID != ''">
									<CustomerItemID>
										<ID>
											<xsl:value-of select="ItemID/BuyerPartID"/>
										</ID>
									</CustomerItemID>
								</xsl:if>
								<xsl:if test="ItemID/SupplierPartID != ''">
									<SupplierItemID>
										<ID>
											<xsl:value-of select="ItemID/SupplierPartID"/>
										</ID>
									</SupplierItemID>
								</xsl:if>
								<Description>
									<xsl:attribute name="languageID">
										<xsl:choose>
											<xsl:when test="Description/@xml:lang != ''">
												<xsl:value-of select="Description/@xml:lang"/>
											</xsl:when>
											<xsl:otherwise>en</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:value-of select="Description"/>
								</Description>
								<xsl:if test="LeadTime != ''">
									<LeadTimeDuration>
										<xsl:value-of select="concat('P', LeadTime, 'D')"/>
									</LeadTimeDuration>
								</xsl:if>
							</ManufacturingItem>
							<ShipToParty>
								<xsl:call-template name="CreateParty">
									<xsl:with-param name="PartyInfo" select="Contact[@role = 'locationTo']"/>
									<xsl:with-param name="IDInfo" select="Contact/IdReference[@domain = 'locationTo']/@identifier"/>
								</xsl:call-template>
							</ShipToParty>
							<xsl:for-each select="TimeSeries/Forecast">
								<PlanningScheduleDetail>
									<EffectiveTimePeriod>
										<StartDateTime>
											<xsl:value-of select="Period/@startDate"/>
										</StartDateTime>
										<EndDateTime>
											<xsl:value-of select="Period/@endDate"/>
										</EndDateTime>
									</EffectiveTimePeriod>
									<ItemQuantity>
										<xsl:attribute name="unitCode">
											<xsl:value-of select="ForecastQuantity/UnitOfMeasure"/>
										</xsl:attribute>
										<xsl:value-of select="normalize-space(ForecastQuantity/@quantity)"/>
									</ItemQuantity>
								</PlanningScheduleDetail>
							</xsl:for-each>							
						</PlanningScheduleLine>
					</xsl:for-each>
				</PlanningSchedule>
			</DataArea>
		</NotifyPlanningSchedule>
	</xsl:template>
</xsl:stylesheet>
