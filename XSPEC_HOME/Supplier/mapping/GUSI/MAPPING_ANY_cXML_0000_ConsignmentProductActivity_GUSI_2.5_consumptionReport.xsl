<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<xsl:param name="anDate"/>
	<xsl:param name="anTime"/>
	<xsl:param name="anICNValue"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anCorrelationID"/>

	<!-- For local testing -->
	<!--xsl:include href="Format_cXML_to_GUSI.xsl"/-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_GUSI_2.1.xsl"/>

	<xsl:variable name="EANID" select="normalize-space(cXML/Header/From/Credential[@domain='EANID']/Identity)"/>

	<xsl:template match="cXML/Message/ProductActivityMessage">
		<sh:StandardBusinessDocument xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:deliver="urn:ean.ucc:deliver:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:call-template name="createGUSIHeader">
				<xsl:with-param name="version" select="'2.5'"/>
				<xsl:with-param name="type" select="'ConsumptionReport'"/>
					<xsl:with-param name="hdrversion" select="'1.0'"/>
				<xsl:with-param name="time" select="substring(/cXML/@timestamp,1,19)"/>
			</xsl:call-template>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="$anCorrelationID"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<xsl:call-template name="createContentOwner">
							<xsl:with-param name="gln" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
							<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressID)[1])"/>
							<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressIDDomain)[1])"/>
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
								<xsl:with-param name="gln" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
								<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressID)[1])"/>
								<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressIDDomain)[1])"/>
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
											<xsl:with-param name="gln" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
											<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressID)[1])"/>
											<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressIDDomain)[1])"/>
										</xsl:call-template>
									</contentOwner>
								</entityIdentification>
							</documentCommandHeader>
							<documentCommandOperand>
								<xsl:element name="deliver:consumptionReport">
									<xsl:attribute name="creationDateTime">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="cxmlDate" select="normalize-space(ProductActivityHeader/@creationDate)"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="documentStatus">ORIGINAL</xsl:attribute>
									<contentVersion>
										<versionIdentification>2.5</versionIdentification>
									</contentVersion>
									<documentStructureVersion>
										<versionIdentification>2.5</versionIdentification>
									</documentStructureVersion>
									<consumptionReportIdentification>
										<uniqueCreatorIdentification>
											<xsl:value-of select="normalize-space(ProductActivityHeader/@messageID)"/>
										</uniqueCreatorIdentification>
										<contentOwner>
											<xsl:call-template name="createContentOwner">
												<xsl:with-param name="gln" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
												<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressID)[1])"/>
												<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space((ProductActivityDetails/Contact[@role='locationTo']/@addressIDDomain)[1])"/>
											</xsl:call-template>
										</contentOwner>
									</consumptionReportIdentification>
									<buyer>
										<xsl:call-template name="createContentOwner">
										</xsl:call-template>
									</buyer>
									<seller>
										<xsl:call-template name="createContentOwner">
											<xsl:with-param name="additionalPartyIdentificationValue" select="$anAlternativeReceiver"/>
										</xsl:call-template>
									</seller>
									<xsl:for-each select="ProductActivityDetails">
										<consumptionReportItemLocationInformation>
											<shipTo>
												<xsl:call-template name="createContentOwner">
													<xsl:with-param name="gln" select="normalize-space((Contact[@role='locationTo']/IdReference[@domain = 'EANID']/@identifier)[1])"/>
													<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(Contact[@role='locationTo' and IdReference[@domain='locationTo']][1]/IdReference[@domain='locationTo']/@identifier)"/>
													<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space((Contact[@role='locationTo']/@addressIDDomain)[1])"/>
												</xsl:call-template>
												
											</shipTo>

											<xsl:for-each select="ConsignmentMovement">
												<xsl:element name="consumptionReportLineItem">
													<xsl:attribute name="number" select="ProductMovementItemIDInfo/@movementLineNumber"/>

													<consumedQuantity>
														<value>
															<xsl:value-of select="MovementQuantity/@quantity"/>
														</value>
														<xsl:if test="MovementQuantity/UnitOfMeasure!=''">
															<unitOfMeasure>
																<measurementUnitCodeValue>
																	<xsl:value-of select="MovementQuantity/UnitOfMeasure"/>
																</measurementUnitCodeValue>
															</unitOfMeasure>
														</xsl:if>
													</consumedQuantity>
													<consumptionPeriod>
														<xsl:element name="timePeriod">
															<xsl:attribute name="beginDate">
																<xsl:value-of select="substring(normalize-space(ProductMovementItemIDInfo/@movementDate),1,10)"/>
															</xsl:attribute>
															<xsl:attribute name="endDate">
																<xsl:value-of select="substring(normalize-space(ProductMovementItemIDInfo/@movementDate),1,10)"/>
															</xsl:attribute>
														</xsl:element>
													</consumptionPeriod>
												</xsl:element>
											</xsl:for-each>

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
											</tradeItemIdentification>
										</consumptionReportItemLocationInformation>
									</xsl:for-each>
								</xsl:element>
							</documentCommandOperand>
						</eanucc:documentCommand>
					</command>
				</eanucc:transaction>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
</xsl:stylesheet>
