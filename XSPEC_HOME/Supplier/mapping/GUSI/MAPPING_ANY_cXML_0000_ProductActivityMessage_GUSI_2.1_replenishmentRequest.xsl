<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<xsl:param name="anDate"/>
	<xsl:param name="anTime"/>
	<xsl:param name="anICNValue"/>
	<xsl:param name="anCorrelationID"/>
	<xsl:param name="anEnvName"/>

	<xsl:include href="FORMAT_cXML_0000_GUSI_2.1.xsl"/>
	<!--xsl:include href="Format_cXML_to_GUSI.xsl"/-->

	<xsl:variable name="EANID" select="normalize-space(cXML/Header/From/Credential[@domain='EANID']/Identity)"/>

	<xsl:template match="cXML/Message/ProductActivityMessage">
		<sh:StandardBusinessDocument xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:plan="urn:ean.ucc:plan:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:call-template name="createGUSIHeader">
				<xsl:with-param name="version" select="'2.1'"/>
				<xsl:with-param name="type" select="'ReplenishmentRequest'"/>
				<xsl:with-param name="hdrversion" select="'2.2'"/>
				<xsl:with-param name="time" select="substring(/cXML/@timestamp,1,19)"/>
			</xsl:call-template>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="$anCorrelationID"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<xsl:call-template name="createContentOwner">
						</xsl:call-template>
					</contentOwner>
				</entityIdentification>
				<eanucc:transaction>
					<entityIdentification>
						<uniqueCreatorIdentification>
							<xsl:value-of select="$anCorrelationID"/>
						</uniqueCreatorIdentification>
						<contentOwner>
							<xsl:call-template name="createContentOwner">
							</xsl:call-template>
						</contentOwner>
					</entityIdentification>
					<command>
						<eanucc:documentCommand>
							<documentCommandHeader type="ADD">
								<entityIdentification>
									<uniqueCreatorIdentification>
										<xsl:value-of select="$anCorrelationID"/>
									</uniqueCreatorIdentification>
									<contentOwner>
										<xsl:call-template name="createContentOwner">
										</xsl:call-template>
									</contentOwner>
								</entityIdentification>
							</documentCommandHeader>
							<documentCommandOperand>
								<xsl:element name="plan:replenishmentRequest">
									<xsl:attribute name="creationDateTime">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="cxmlDate" select="normalize-space(ProductActivityHeader/@creationDate)"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="documentStatus">ORIGINAL</xsl:attribute>
									<xsl:attribute name="replenishmentRequestDocumentType">GROSS_REQUIREMENTS_AND_INVENTORY</xsl:attribute>
									<xsl:attribute name="structureType">LOCATION_BY_ITEM</xsl:attribute>
									<contentVersion>
										<versionIdentification>2.1</versionIdentification>
									</contentVersion>
									<documentStructureVersion>
										<versionIdentification>2.1</versionIdentification>
									</documentStructureVersion>
									<replenishmentRequestIdentification>
										<uniqueCreatorIdentification>
											<xsl:value-of select="normalize-space(ProductActivityHeader/@messageID)"/>
										</uniqueCreatorIdentification>
										<contentOwner>
											<xsl:call-template name="createContentOwner">
											</xsl:call-template>
										</contentOwner>
									</replenishmentRequestIdentification>
									<seller>
										<xsl:call-template name="createContentOwner">
										<xsl:with-param name="additionalPartyIdentificationValue" select="$anAlternativeReceiver"/>
										</xsl:call-template>
									</seller>
									<buyer>
										<xsl:call-template name="createContentOwner">
										</xsl:call-template>
									</buyer>
									<xsl:for-each select="ProductActivityDetails">
										<replenishmentRequestItemLocationInformation>
											<tradeItemIdentification>
												<gtin>
													<xsl:choose>
														<xsl:when test="normalize-space(Extrinsic[@name='EANID']) != ''">
															<xsl:value-of select="normalize-space(Extrinsic[@name='EANID'])"/>
														</xsl:when>
														<xsl:otherwise>00000000000000</xsl:otherwise>
													</xsl:choose>
												</gtin>
												<xsl:if test="normalize-space(ItemID/BuyerPartID) != ''">
													<additionalTradeItemIdentification>
														<additionalTradeItemIdentificationValue>
															<xsl:value-of select="normalize-space(ItemID/BuyerPartID)"/>
														</additionalTradeItemIdentificationValue>
														<additionalTradeItemIdentificationType>BUYER_ASSIGNED</additionalTradeItemIdentificationType>
													</additionalTradeItemIdentification>
												</xsl:if>
												<xsl:if test="normalize-space(ItemID/SupplierPartID) != ''">
													<additionalTradeItemIdentification>
														<additionalTradeItemIdentificationValue>
															<xsl:value-of select="normalize-space(ItemID/SupplierPartID)"/>
														</additionalTradeItemIdentificationValue>
														<additionalTradeItemIdentificationType>SUPPLIER_ASSIGNED</additionalTradeItemIdentificationType>
													</additionalTradeItemIdentification>
												</xsl:if>
											</tradeItemIdentification>
											<shipTo>
												<gln>
													<xsl:choose>
														<xsl:when test="normalize-space((Contact[@role='locationTo']/IdReference[@domain = 'EANID']/@identifier)[1]) != ''">
															<xsl:value-of select="normalize-space((Contact[@role='locationTo']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
														</xsl:when>
														<xsl:otherwise>0000000000000</xsl:otherwise>
													</xsl:choose>
												</gln>
												<xsl:if test="Contact[@role='locationTo' and IdReference[@domain='locationTo']][1]/IdReference[@domain='locationTo']/@identifier != ''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space(Contact[@role='locationTo' and IdReference[@domain='locationTo']][1]/IdReference[@domain='locationTo']/@identifier)"/>
														</additionalPartyIdentificationValue>
														<additionalPartyIdentificationType>
															<xsl:choose>
																<xsl:when test="normalize-space((Contact[@role='locationTo']/@addressIDDomain)[1]) != ''">
																	<xsl:value-of select="normalize-space((Contact[@role='locationTo']/@addressIDDomain)[1])"/>
																</xsl:when>
																<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
															</xsl:choose>
														</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:if>
												<xsl:if test="normalize-space((Contact[@role='locationTo']/Name)[1]) != ''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space((Contact[@role='locationTo']/Name)[1])"/>
														</additionalPartyIdentificationValue>
														<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:if>
											</shipTo>
											<inventoryLocation>
												<gln>
													<xsl:choose>
														<xsl:when test="normalize-space((Contact[@role = 'inventoryLocation']/IdReference[@domain = 'EANID']/@identifier)[1]) != ''">
															<xsl:value-of select="normalize-space((Contact[@role = 'inventoryLocation']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
														</xsl:when>
														<xsl:when test="normalize-space((Contact[@role = 'locationTo']/IdReference[@domain = 'EANID']/@identifier)[1]) != ''">
															<xsl:value-of select="normalize-space((Contact[@role = 'locationTo']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
														</xsl:when>
														<xsl:otherwise>0000000000000</xsl:otherwise>
													</xsl:choose>
												</gln>
												<xsl:choose>
													<xsl:when test="normalize-space((Contact[@role = 'inventoryLocation']/@addressID)[1])  != ''">
														<additionalPartyIdentification>
															<additionalPartyIdentificationValue>
																<xsl:value-of select="normalize-space((Contact[@role = 'inventoryLocation']/@addressID)[1])"/>
															</additionalPartyIdentificationValue>
															<additionalPartyIdentificationType>
																<xsl:choose>
																	<xsl:when test="normalize-space((Contact[@role = 'inventoryLocation']/@addressIDDomain)[1]) != ''">
																		<xsl:value-of select="normalize-space((Contact[@role = 'inventoryLocation']/@addressIDDomain)[1])"/>
																	</xsl:when>
																	<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
																</xsl:choose>
															</additionalPartyIdentificationType>
														</additionalPartyIdentification>
														<xsl:if test="normalize-space((Contact[@role = 'inventoryLocation']/Name)[1]) != ''">
															<additionalPartyIdentification>
																<additionalPartyIdentificationValue>
																	<xsl:value-of select="normalize-space((Contact[@role = 'inventoryLocation']/Name)[1])"/>
																</additionalPartyIdentificationValue>
																<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
															</additionalPartyIdentification>
														</xsl:if>
													</xsl:when>
													<xsl:when test="normalize-space((Contact[@role = 'locationTo']/IdReference[@domain = 'locationTo']/@identifier)[1])  != ''">
														<additionalPartyIdentification>
															<additionalPartyIdentificationValue>
																<xsl:value-of select="normalize-space((Contact[@role = 'locationTo']/IdReference[@domain = 'locationTo']/@identifier)[1])"/>
															</additionalPartyIdentificationValue>
															<additionalPartyIdentificationType>
																<xsl:choose>
																	<xsl:when test="normalize-space((Contact[@role = 'locationTo']/@addressIDDomain)[1]) != ''">
																		<xsl:value-of select="normalize-space((Contact[@role = 'locationTo']/@addressIDDomain)[1])"/>
																	</xsl:when>
																	<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
																</xsl:choose>
															</additionalPartyIdentificationType>
														</additionalPartyIdentification>
														<xsl:if test="normalize-space((Contact[@role = 'locationTo']/Name)[1]) != ''">
															<additionalPartyIdentification>
																<additionalPartyIdentificationValue>
																	<xsl:value-of select="normalize-space((Contact[@role = 'locationTo']/Name)[1])"/>
																</additionalPartyIdentificationValue>
																<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
															</additionalPartyIdentification>
														</xsl:if>
													</xsl:when>
												</xsl:choose>
											</inventoryLocation>
											<xsl:for-each select="TimeSeries/Forecast">
												<xsl:element name="replenishmentRequestRequirementsLineItem">
													<xsl:attribute name="number" select="position()"/>
													<xsl:attribute name="timeBucketSize">
														<xsl:choose>
															<xsl:when test="normalize-space(Extrinsic[@name='ScheduleFrequence'])!=''">
																<xsl:value-of select="normalize-space(Extrinsic[@name='ScheduleFrequence'])"/>
															</xsl:when>
															<xsl:otherwise>DAY</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<requiredQuantity>
														<value>
															<xsl:value-of select="normalize-space(ForecastQuantity/@quantity)"/>
														</value>
														<xsl:if test="normalize-space(ForecastQuantity/UnitOfMeasure)!=''">
															<unitOfMeasure>
																<measurementUnitCodeValue>
																	<xsl:value-of select="normalize-space(ForecastQuantity/UnitOfMeasure)"/>
																</measurementUnitCodeValue>
															</unitOfMeasure>
														</xsl:if>
													</requiredQuantity>
													<requirementsPeriod>
														<xsl:element name="timePeriod">
															<xsl:attribute name="beginDate">
																<xsl:value-of select="substring(normalize-space(Period/@startDate),1,10)"/>
															</xsl:attribute>
															<xsl:attribute name="endDate">
																<xsl:value-of select="substring(normalize-space(Period/@endDate),1,10)"/>
															</xsl:attribute>
														</xsl:element>
													</requirementsPeriod>
												</xsl:element>
											</xsl:for-each>
											<!-- IG-1713 -->
											<xsl:for-each select="PlanningTimeSeries/TimeSeriesDetails">
												<xsl:element name="replenishmentRequestRequirementsLineItem">
													<xsl:attribute name="number" select="position()"/>
													<xsl:attribute name="timeBucketSize">
														<xsl:choose>
															<xsl:when test="normalize-space(Extrinsic[@name='ScheduleFrequence'])!=''">
																<xsl:value-of select="normalize-space(Extrinsic[@name='ScheduleFrequence'])"/>
															</xsl:when>
															<xsl:otherwise>DAY</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<requiredQuantity>
														<value>
															<xsl:value-of select="normalize-space(TimeSeriesQuantity/@quantity)"/>
														</value>
														<xsl:if test="normalize-space(TimeSeriesQuantity/UnitOfMeasure)!=''">
															<unitOfMeasure>
																<measurementUnitCodeValue>
																	<xsl:value-of select="normalize-space(TimeSeriesQuantity/UnitOfMeasure)"/>
																</measurementUnitCodeValue>
															</unitOfMeasure>
														</xsl:if>
													</requiredQuantity>
													<requirementsPeriod>
														<xsl:element name="timePeriod">
															<xsl:attribute name="beginDate">
																<xsl:value-of select="substring(normalize-space(Period/@startDate),1,10)"/>
															</xsl:attribute>
															<xsl:attribute name="endDate">
																<xsl:value-of select="substring(normalize-space(Period/@endDate),1,10)"/>
															</xsl:attribute>
														</xsl:element>
													</requirementsPeriod>
												</xsl:element>
											</xsl:for-each>
											<replenishmentRequestInventoryStatusLineItem number="1">
												<inventoryStatusQuantitySpecification inventoryStatusType="ON_HAND">
													<quantityOfUnits>
														<value>
															<xsl:choose>
																<xsl:when test="normalize-space(Inventory/StockOnHandQuantity/@quantity)!=''">
																	<xsl:value-of select="normalize-space(Inventory/StockOnHandQuantity/@quantity)"/>
																</xsl:when>
																<xsl:otherwise>0.000</xsl:otherwise>
															</xsl:choose>
														</value>
														<xsl:if test="normalize-space(Inventory/StockOnHandQuantity/UnitOfMeasure)!=''">
															<unitOfMeasure>
																<measurementUnitCodeValue>
																	<xsl:value-of select="normalize-space(Inventory/StockOnHandQuantity/UnitOfMeasure)"/>
																</measurementUnitCodeValue>
															</unitOfMeasure>
														</xsl:if>
													</quantityOfUnits>
												</inventoryStatusQuantitySpecification>
												<xsl:if test="normalize-space(Inventory/QualityInspectionQuantity/@quantity)!=''">
													<inventoryStatusQuantitySpecification inventoryStatusType="QUARANTINED">
														<quantityOfUnits>
															<value>
																<xsl:choose>
																	<xsl:when test="normalize-space(Inventory/QualityInspectionQuantity/@quantity)!=''">
																		<xsl:value-of select="normalize-space(Inventory/QualityInspectionQuantity/@quantity)"/>
																	</xsl:when>
																	<xsl:otherwise>0.000</xsl:otherwise>
																</xsl:choose>
															</value>
															<xsl:if test="normalize-space(Inventory/QualityInspectionQuantity/UnitOfMeasure)!=''">
																<unitOfMeasure>
																	<measurementUnitCodeValue>
																		<xsl:value-of select="normalize-space(Inventory/QualityInspectionQuantity/UnitOfMeasure)"/>
																	</measurementUnitCodeValue>
																</unitOfMeasure>
															</xsl:if>
														</quantityOfUnits>
													</inventoryStatusQuantitySpecification>
												</xsl:if>
												<xsl:if test="normalize-space(Inventory/BlockedQuantity/@quantity)!=''">
													<inventoryStatusQuantitySpecification inventoryStatusType="ON_HOLD">
														<quantityOfUnits>
															<value>
																<xsl:choose>
																	<xsl:when test="normalize-space(Inventory/BlockedQuantity/@quantity)!=''">
																		<xsl:value-of select="normalize-space(Inventory/BlockedQuantity/@quantity)"/>
																	</xsl:when>
																	<xsl:otherwise>0.000</xsl:otherwise>
																</xsl:choose>
															</value>
															<xsl:if test="normalize-space(Inventory/BlockedQuantity/UnitOfMeasure)!=''">
																<unitOfMeasure>
																	<measurementUnitCodeValue>
																		<xsl:value-of select="normalize-space(Inventory/BlockedQuantity/UnitOfMeasure)"/>
																	</measurementUnitCodeValue>
																</unitOfMeasure>
															</xsl:if>
														</quantityOfUnits>
													</inventoryStatusQuantitySpecification>
												</xsl:if>
												<xsl:if test="normalize-space(Inventory/RequiredMinimumQuantity/@quantity)!=''">
													<inventoryStatusQuantitySpecification inventoryStatusType="MINIMUM_STOCK">
														<quantityOfUnits>
															<value>
																<xsl:choose>
																	<xsl:when test="normalize-space(Inventory/RequiredMinimumQuantity/@quantity)!=''">
																		<xsl:value-of select="normalize-space(Inventory/RequiredMinimumQuantity/@quantity)"/>
																	</xsl:when>
																	<xsl:otherwise>0.000</xsl:otherwise>
																</xsl:choose>
															</value>
															<xsl:if test="normalize-space(Inventory/RequiredMinimumQuantity/UnitOfMeasure)!=''">
																<unitOfMeasure>
																	<measurementUnitCodeValue>
																		<xsl:value-of select="normalize-space(Inventory/RequiredMinimumQuantity/UnitOfMeasure)"/>
																	</measurementUnitCodeValue>
																</unitOfMeasure>
															</xsl:if>
														</quantityOfUnits>
													</inventoryStatusQuantitySpecification>
												</xsl:if>
												<xsl:if test="normalize-space(Inventory/RequiredMaximumQuantity/@quantity)!=''">
													<inventoryStatusQuantitySpecification inventoryStatusType="MAXIMUM_STOCK">
														<quantityOfUnits>
															<value>
																<xsl:choose>
																	<xsl:when test="normalize-space(Inventory/RequiredMaximumQuantity/@quantity)!=''">
																		<xsl:value-of select="normalize-space(Inventory/RequiredMaximumQuantity/@quantity)"/>
																	</xsl:when>
																	<xsl:otherwise>0.000</xsl:otherwise>
																</xsl:choose>
															</value>
															<xsl:if test="normalize-space(Inventory/RequiredMaximumQuantity/UnitOfMeasure)!=''">
																<unitOfMeasure>
																	<measurementUnitCodeValue>
																		<xsl:value-of select="normalize-space(Inventory/RequiredMaximumQuantity/UnitOfMeasure)"/>
																	</measurementUnitCodeValue>
																</unitOfMeasure>
															</xsl:if>
														</quantityOfUnits>
													</inventoryStatusQuantitySpecification>
												</xsl:if>
											</replenishmentRequestInventoryStatusLineItem>
										</replenishmentRequestItemLocationInformation>
									</xsl:for-each>
								</xsl:element>
							</documentCommandOperand>
						</eanucc:documentCommand>
					</command>
				</eanucc:transaction>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>
	
	<xsl:template match="text()"/>
</xsl:stylesheet>
