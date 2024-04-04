<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anSenderDefaultTimeZone"/>

	<!--xsl:variable name="Lookups" select="document('../../lookups/OAGIS/LOOKUP_OAGIS_9.2.xml')"/-->
	<xsl:variable name="Lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_OAGIS_9.2.xml')"/>

	<xsl:template match="/">
		<xsl:variable name="BODID" select="concat(NotifyPlanningSchedule/ApplicationArea/BODID, '')"/>
		<xsl:variable name="CreationDateTime" select="concat(NotifyPlanningSchedule/ApplicationArea/CreationDateTime, '')"/>
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"/>
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
			<Message>
				<xsl:choose>
					<xsl:when test="$anEnvName = 'PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:variable name="processTypeVal" select="lower-case(NotifyPlanningSchedule/DataArea/PlanningSchedule/PlanningScheduleLine[1]/PlanningScheduleDetail[1]/DocumentReference/@type)"/>
				<xsl:variable name="replenishmentType">
					<xsl:value-of select="$Lookups/Lookups/ReplenishmentTypes/ReplenishmentType[lower-case(OAGISCode) = $processTypeVal]/cXMLCode"/>
				</xsl:variable>
				
				<ProductReplenishmentMessage>
					<ProductReplenishmentHeader>
						<xsl:attribute name="messageID">
							<xsl:value-of select="NotifyPlanningSchedule/ApplicationArea/BODID"/>
						</xsl:attribute>
						<xsl:attribute name="creationDate">
							<xsl:value-of select="NotifyPlanningSchedule/DataArea/PlanningSchedule/PlanningScheduleHeader/DocumentReference/DocumentDateTime"/>
						</xsl:attribute>
						<xsl:attribute name="processType">
							<xsl:value-of select="$replenishmentType"/>
						</xsl:attribute>
					</ProductReplenishmentHeader>
					<xsl:for-each select="NotifyPlanningSchedule/DataArea/PlanningSchedule/PlanningScheduleLine">
						<ProductReplenishmentDetails>
							<ItemID>
								<SupplierPartID>
									<xsl:value-of select="ManufacturingItem/SupplierItemID/ID"/>
								</SupplierPartID>
								<BuyerPartID>
									<xsl:value-of select="ManufacturingItem/CustomerItemID/ID"/>
								</BuyerPartID>
							</ItemID>
							<Description>
								<xsl:attribute name="xml:lang">
									<xsl:value-of select="ManufacturingItem/Description/@languageID"/>
								</xsl:attribute>
								<xsl:value-of select="ManufacturingItem/Description[not(@type)]"/>
							</Description>
							<xsl:if test="ManufacturingItem/LeadTimeDuration">
								<LeadTime>
									<xsl:value-of select="substring-after(substring-before(ManufacturingItem/LeadTimeDuration, 'D'), 'P')"/>
								</LeadTime>
							</xsl:if>

							<!-- IG-1335 -->
							<xsl:for-each select="ManufacturingItem/Description[@type != '']">
								<Characteristic>
									<xsl:attribute name="domain">
										<xsl:value-of select="@type"/>
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="./text()"/>
									</xsl:attribute>
								</Characteristic>
							</xsl:for-each>
							<xsl:if test="ShipToParty">
								<Contact>
									<xsl:attribute name="role">locationTo</xsl:attribute>
									<Name>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="ManufacturingItem/Description/@languageID"/>
										</xsl:attribute>
										<xsl:value-of select="ShipToParty/Name"/>
									</Name>
									<xsl:for-each select="ShipToParty/PartyIDs/ID">
										<IdReference>
											<xsl:attribute name="domain">
												<xsl:choose>
													<xsl:when test="./@schemeName != ''">
														<xsl:value-of select="./@schemeName"/>
													</xsl:when>
													<xsl:otherwise>buyerLocationID</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="identifier">
												<xsl:value-of select="./text()"/>
											</xsl:attribute>
											<Description>
												<xsl:attribute name="xml:lang">en</xsl:attribute>
												<xsl:value-of select="../../Location/Name"/>
											</Description>
										</IdReference>
									</xsl:for-each>
								</Contact>
							</xsl:if>
							<xsl:if test="Party[@role = 'MRPArea']">
								<Contact role="MRPArea">
									<Name xml:lang="EN">
										<xsl:value-of select="Party[@role = 'MRPArea']/Name"/>
									</Name>
									<xsl:for-each select="Party[@role = 'MRPArea']/PartyIDs/ID">
										<IdReference>
											<xsl:attribute name="domain">
												<xsl:choose>
													<xsl:when test="./@schemeName != ''">
														<xsl:value-of select="./@schemeName"/>
													</xsl:when>
													<xsl:otherwise>buyerLocationID</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="identifier">
												<xsl:value-of select="./text()"/>
											</xsl:attribute>
											<Description>
												<xsl:attribute name="xml:lang">en</xsl:attribute>
												<xsl:value-of select="../../Location/Name"/>
											</Description>
										</IdReference>
									</xsl:for-each>									
								</Contact>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$replenishmentType != 'Forecast'">
									<xsl:for-each select="PlanningScheduleDetail">
										<ReplenishmentTimeSeries>
											<xsl:variable name="replenishType" select="lower-case(DocumentReference/@type)"/>
											<xsl:variable name="timeSeriesLookup" select="$Lookups/Lookups/TimeSeriesTypes/TimeSeriesType[lower-case(OAGISCode) = $replenishType]/cXMLCode"/>
											<xsl:attribute name="type">
												<xsl:choose>
													<xsl:when test="$timeSeriesLookup != ''">
														<xsl:value-of select="$timeSeriesLookup"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="DocumentReference/@type"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:if test="$timeSeriesLookup = 'custom'">
												<xsl:attribute name="customType">
													<xsl:value-of select="DocumentReference/@type"/>
												</xsl:attribute>
											</xsl:if>
											<TimeSeriesDetails>
												<Period>
													<xsl:attribute name="startDate">
														<xsl:value-of select="EffectiveTimePeriod/StartDateTime"/>
													</xsl:attribute>
													<xsl:attribute name="endDate">
														<xsl:value-of select="EffectiveTimePeriod/EndDateTime"/>
													</xsl:attribute>
												</Period>
												<TimeSeriesQuantity>
													<xsl:attribute name="quantity">
														<xsl:value-of select="ItemQuantity"/>
													</xsl:attribute>
													<UnitOfMeasure>
														<xsl:value-of select="ItemQuantity/@unitCode"/>
													</UnitOfMeasure>
												</TimeSeriesQuantity>
											</TimeSeriesDetails>
										</ReplenishmentTimeSeries>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each-group select="PlanningScheduleDetail" group-by="DocumentReference/@type">
										<ReplenishmentTimeSeries>
											<xsl:variable name="replenishType" select="lower-case(DocumentReference/@type)"/>
											<xsl:variable name="timeSeriesLookup" select="$Lookups/Lookups/TimeSeriesTypes/TimeSeriesType[lower-case(OAGISCode) = $replenishType]/cXMLCode"/>
											<xsl:attribute name="type">
												<xsl:choose>
													<xsl:when test="$timeSeriesLookup != ''">
														<xsl:value-of select="$timeSeriesLookup"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="DocumentReference/@type"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:if test="$timeSeriesLookup = 'custom'">
												<xsl:attribute name="customType">
													<xsl:value-of select="DocumentReference/@type"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:for-each select="current-group()">
												<TimeSeriesDetails>
													<Period>
														<xsl:attribute name="startDate">
															<xsl:value-of select="EffectiveTimePeriod/StartDateTime"/>
														</xsl:attribute>
														<xsl:attribute name="endDate">
															<xsl:value-of select="EffectiveTimePeriod/EndDateTime"/>
														</xsl:attribute>
													</Period>
													<TimeSeriesQuantity>
														<xsl:attribute name="quantity">
															<xsl:value-of select="ItemQuantity"/>
														</xsl:attribute>
														<UnitOfMeasure>
															<xsl:value-of select="ItemQuantity/@unitCode"/>
														</UnitOfMeasure>
													</TimeSeriesQuantity>
												</TimeSeriesDetails>
											</xsl:for-each>
										</ReplenishmentTimeSeries>
									</xsl:for-each-group>
								</xsl:otherwise>
							</xsl:choose>
							
						</ProductReplenishmentDetails>
					</xsl:for-each>
				</ProductReplenishmentMessage>
			</Message>
		</cXML>
	</xsl:template>
</xsl:stylesheet>
