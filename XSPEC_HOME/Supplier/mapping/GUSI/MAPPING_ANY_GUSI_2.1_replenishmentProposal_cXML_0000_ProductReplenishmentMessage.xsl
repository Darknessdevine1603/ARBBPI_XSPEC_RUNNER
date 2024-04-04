<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                xmlns:eanucc="urn:ean.ucc:2" xmlns:plan="urn:ean.ucc:plan:2" xmlns:xalan="http://xml.apache.org/xalan">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anSenderDefaultTimeZone"/>

	<xsl:template match="//sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/plan:replenishmentProposal">
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
			<Message>
				<xsl:choose>
					<xsl:when test="upper-case($anEnvName)='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<ProductReplenishmentMessage>
					<ProductReplenishmentHeader>
						<xsl:attribute name="creationDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="Date" select="normalize-space(@creationDateTime)"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="messageID">
							<xsl:value-of select="normalize-space(replenishmentProposalIdentification/uniqueCreatorIdentification)"/>
						</xsl:attribute>
						<xsl:attribute name="processType">
							<xsl:value-of select="'SMI'"/>
						</xsl:attribute>
					</ProductReplenishmentHeader>
					<xsl:for-each select="replenishmentProposalItemLocationInformation">
						<ProductReplenishmentDetails>
							<ItemID>
								<SupplierPartID>
									<xsl:value-of select="normalize-space(tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue)"/>
								</SupplierPartID>
								<xsl:if test="normalize-space(tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue)!=''">
									<BuyerPartID>
										<xsl:value-of select="normalize-space(tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue)"/>
									</BuyerPartID>
								</xsl:if>
							</ItemID>
							<xsl:choose>
								<xsl:when test="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
									<Contact>
										<xsl:attribute name="role" select="'locationTo'"/>
										<xsl:if test="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
											<xsl:attribute name="addressID">
												<xsl:value-of select="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
											</xsl:attribute>
											<xsl:attribute name="addressIDDomain">Assigned by buyer or buyer's agent</xsl:attribute>
										</xsl:if>
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="'en'"/>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)!=''">
													<xsl:value-of select="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
												</xsl:when>
												<xsl:when test="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)">
													<xsl:value-of select="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
												</xsl:when>
											</xsl:choose>
										</Name>
										<xsl:choose>
											<xsl:when test="normalize-space(../buyer/gln)!='' and normalize-space(../buyer/gln)!='0000000000000'">
												<IdReference>
													<xsl:attribute name="domain">EANID</xsl:attribute>
													<xsl:attribute name="identifier">
														<xsl:value-of select="normalize-space(../buyer/gln)"/>
													</xsl:attribute>
												</IdReference>
											</xsl:when>
											<xsl:when test="normalize-space(shipTo/gln)!='' and normalize-space(shipTo/gln)!='0000000000000'">
												<IdReference>
													<xsl:attribute name="domain">EANID</xsl:attribute>
													<xsl:attribute name="identifier">
														<xsl:value-of select="normalize-space(shipTo/gln)"/>
													</xsl:attribute>
												</IdReference>
											</xsl:when>
										</xsl:choose>
										<xsl:if test="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
											<IdReference>
												<xsl:attribute name="domain">buyerLocationID</xsl:attribute>
												<xsl:attribute name="identifier">
													<xsl:value-of select="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
												</xsl:attribute>
											</IdReference>
										</xsl:if>
									</Contact>
								</xsl:when>

								<xsl:when test="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
									<Contact>
										<xsl:attribute name="role" select="'locationTo'"/>
										<!--xsl:if test="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
										<xsl:attribute name="addressID">
											<xsl:value-of select="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
										</xsl:attribute>
										<xsl:attribute name="addressIDDomain">Assigned by buyer or buyer's agent</xsl:attribute>
									</xsl:if-->
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="'en'"/>
											</xsl:attribute>
											<xsl:value-of select="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
										</Name>
										<xsl:if test="normalize-space(shipTo/gln)!='' and normalize-space(shipTo/gln)!='0000000000000'">
											<IdReference>
												<xsl:attribute name="domain">EANID</xsl:attribute>
												<xsl:attribute name="identifier">
													<xsl:value-of select="normalize-space(shipTo/gln)"/>
												</xsl:attribute>
											</IdReference>
										</xsl:if>
										<xsl:if test="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
											<IdReference>
												<xsl:attribute name="domain">buyerLocationID</xsl:attribute>
												<xsl:attribute name="identifier">
													<xsl:value-of select="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
												</xsl:attribute>
											</IdReference>
										</xsl:if>
									</Contact>
								</xsl:when>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
									<Contact>
										<xsl:attribute name="role" select="'supplierCorporate'"/>
										<xsl:if test="normalize-space(../seller/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
											<xsl:attribute name="addressID">
												<xsl:value-of select="normalize-space(../seller/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
											</xsl:attribute>
											<xsl:attribute name="addressIDDomain">Assigned by buyer or buyer's agent</xsl:attribute>
										</xsl:if>
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="'en'"/>
											</xsl:attribute>
											<xsl:value-of select="normalize-space(../seller/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
										</Name>
										<xsl:if test="normalize-space(../seller/gln)!='' and normalize-space(../seller/gln)!='0000000000000'">
											<IdReference>
												<xsl:attribute name="domain">EANID</xsl:attribute>
												<xsl:attribute name="identifier">
													<xsl:value-of select="normalize-space(../seller/gln)"/>
												</xsl:attribute>
											</IdReference>
										</xsl:if>
									</Contact>
									<Contact>
										<xsl:attribute name="role" select="'locationFrom'"/>
										<xsl:if test="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
											<xsl:attribute name="addressID">
												<xsl:value-of select="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
											</xsl:attribute>
											<xsl:attribute name="addressIDDomain">Assigned by buyer or buyer's agent</xsl:attribute>
										</xsl:if>
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="'en'"/>
											</xsl:attribute>
											<xsl:value-of select="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
										</Name>
										<xsl:if test="normalize-space(shipFrom/gln)!='' and normalize-space(shipFrom/gln)!='0000000000000'">
											<IdReference>
												<xsl:attribute name="domain">EANID</xsl:attribute>
												<xsl:attribute name="identifier">
													<xsl:value-of select="normalize-space(shipFrom/gln)"/>
												</xsl:attribute>
											</IdReference>
										</xsl:if>
									</Contact>
								</xsl:when>
								<xsl:otherwise>
									<Contact>
										<xsl:attribute name="role" select="'locationFrom'"/>
										<xsl:if test="normalize-space(../seller/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
											<xsl:attribute name="addressID">
												<xsl:value-of select="normalize-space(../seller/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
											</xsl:attribute>
											<xsl:attribute name="addressIDDomain">Assigned by buyer or buyer's agent</xsl:attribute>
										</xsl:if>
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="'en'"/>
											</xsl:attribute>
											<xsl:value-of select="normalize-space(../seller/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
										</Name>
										<xsl:if test="normalize-space(../seller/gln)!='' and normalize-space(../seller/gln)!='0000000000000'">
											<IdReference>
												<xsl:attribute name="domain">EANID</xsl:attribute>
												<xsl:attribute name="identifier">
													<xsl:value-of select="normalize-space(../seller/gln)"/>
												</xsl:attribute>
											</IdReference>
										</xsl:if>
									</Contact>
								</xsl:otherwise>
							</xsl:choose>
							<!--xsl:if test="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)!=''">
								<Contact>
									<xsl:attribute name="role" select="'buyer'"/>
									<xsl:if test="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
										<xsl:attribute name="addressID">
											<xsl:value-of select="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
										</xsl:attribute>
										<xsl:attribute name="addressIDDomain">Assigned by buyer or buyer's agent</xsl:attribute>
									</xsl:if>
									<Name>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="'en'"/>
										</xsl:attribute>
										<xsl:value-of select="normalize-space(../buyer/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
									</Name>
									<xsl:if test="normalize-space(../buyer/gln)!='' and normalize-space(../buyer/gln)!='0000000000000'">
										<IdReference>
											<xsl:attribute name="domain">EANID</xsl:attribute>
											<xsl:attribute name="identifier">
												<xsl:value-of select="normalize-space(../buyer/gln)"/>
											</xsl:attribute>
										</IdReference>
									</xsl:if>
								</Contact>
							</xsl:if-->
							<xsl:if test="normalize-space(../materialRequirementsPlanner/personOrDepartmentName/description/text)!=''">
								<Contact>
									<xsl:attribute name="role" select="'BuyerPlannerCode'"/>
									<Name>
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="normalize-space(../materialRequirementsPlanner/personOrDepartmentName/description/language/languageISOCode)!=''">
													<xsl:value-of select="normalize-space(../materialRequirementsPlanner/personOrDepartmentName/description/language/languageISOCode)"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:value-of select="normalize-space(../materialRequirementsPlanner/personOrDepartmentName/description/text)"/>
									</Name>
									<xsl:for-each select="../materialRequirementsPlanner/communicationChannel[normalize-space(@communicationChannelCode)='EMAIL']">
										<xsl:if test="normalize-space(@communicationNumber)!=''">
											<Email>
												<xsl:value-of select="normalize-space(@communicationNumber)"/>
											</Email>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="../materialRequirementsPlanner/communicationChannel[normalize-space(@communicationChannelCode)='TELEPHONE']">
										<xsl:if test="normalize-space(@communicationNumber)!=''">
											<Phone>
												<TelephoneNumber>
													<CountryCode isoCountryCode=""/>
													<AreaOrCityCode/>
													<Number>
														<xsl:value-of select="normalize-space(@communicationNumber)"/>
													</Number>
												</TelephoneNumber>
											</Phone>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="../materialRequirementsPlanner/communicationChannel[normalize-space(@communicationChannelCode)='TELEFAX']">
										<xsl:if test="normalize-space(@communicationNumber)!=''">
											<Fax>
												<TelephoneNumber>
													<CountryCode isoCountryCode=""/>
													<AreaOrCityCode/>
													<Number>
														<xsl:value-of select="normalize-space(@communicationNumber)"/>
													</Number>
												</TelephoneNumber>
											</Fax>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="../materialRequirementsPlanner/communicationChannel[normalize-space(@communicationChannelCode)='WEBSITE']">
										<xsl:if test="normalize-space(@communicationNumber)!=''">
											<URL>
												<xsl:value-of select="normalize-space(@communicationNumber)"/>
											</URL>
										</xsl:if>
									</xsl:for-each>
								</Contact>
							</xsl:if>
							<xsl:if test="normalize-space(inventoryLocation/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)!=''">
								<Contact>
									<xsl:attribute name="role" select="'inventoryLocation'"/>
									<xsl:if test="normalize-space(inventoryLocation/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)!=''">
										<xsl:attribute name="addressID">
											<xsl:value-of select="normalize-space(inventoryLocation/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"/>
										</xsl:attribute>
										<xsl:attribute name="addressIDDomain">Assigned by buyer or buyer's agent</xsl:attribute>
									</xsl:if>
									<Name>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="'en'"/>
										</xsl:attribute>
										<xsl:value-of select="normalize-space(inventoryLocation/additionalPartyIdentification[additionalPartyIdentificationType='FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"/>
									</Name>
									<xsl:if test="normalize-space(inventoryLocation/gln)!='' and normalize-space(inventoryLocation/gln)!='0000000000000'">
										<IdReference>
											<xsl:attribute name="domain">EANID</xsl:attribute>
											<xsl:attribute name="identifier">
												<xsl:value-of select="normalize-space(inventoryLocation/gln)"/>
											</xsl:attribute>
										</IdReference>
									</xsl:if>
								</Contact>
							</xsl:if>
							<xsl:if test="exists(replenishmentProposalLineItem)">
								<ReplenishmentTimeSeries>
									<xsl:attribute name="type" select="'plannedReceipt'"/>
									<xsl:for-each select="replenishmentProposalLineItem">
										<TimeSeriesDetails>
											<Period>
												<xsl:attribute name="startDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="Date" select="normalize-space(periodOfReplenishment/timePeriod/@beginDate)"/>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:attribute name="endDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="Date" select="normalize-space(periodOfReplenishment/timePeriod/@endDate)"/>
													</xsl:call-template>
												</xsl:attribute>
											</Period>
											<TimeSeriesQuantity>
												<xsl:attribute name="quantity">
													<xsl:value-of select="normalize-space(proposedQuantity/value)"/>
												</xsl:attribute>
												<UnitOfMeasure>
													<xsl:value-of select="normalize-space(proposedQuantity/unitOfMeasure/measurementUnitCodeValue)"/>
												</UnitOfMeasure>
											</TimeSeriesQuantity>
											<xsl:if test="normalize-space(@timeBucketSize)!=''">
												<Extrinsic name="ScheduleFrequence">
													<xsl:value-of select="normalize-space(@timeBucketSize)"/>
												</Extrinsic>
											</xsl:if>
										</TimeSeriesDetails>
									</xsl:for-each>
								</ReplenishmentTimeSeries>
							</xsl:if>
							<xsl:if test="normalize-space(tradeItemIdentification/gtin)!=''">
								<Extrinsic name="EANID">
									<xsl:value-of select="normalize-space(tradeItemIdentification/gtin)"/>
								</Extrinsic>
							</xsl:if>
							<xsl:if test="normalize-space(replenishmentProposalLineItem[1]/purchaseConditions/documentLineReference/@number)!=''">
								<Extrinsic name="purchaseOrderLineItemNo">
									<xsl:value-of select="normalize-space(replenishmentProposalLineItem[1]/purchaseConditions/documentLineReference/@number)"/>
								</Extrinsic>
							</xsl:if>
							<xsl:if test="normalize-space(replenishmentProposalLineItem[1]/purchaseConditions/documentLineReference/documentReference/uniqueCreatorIdentification)!=''">
								<Extrinsic name="purchaseOrderNo">
									<xsl:value-of select="normalize-space(replenishmentProposalLineItem[1]/purchaseConditions/documentLineReference/documentReference/uniqueCreatorIdentification)"/>
								</Extrinsic>
							</xsl:if>
						</ProductReplenishmentDetails>
					</xsl:for-each>
				</ProductReplenishmentMessage>
			</Message>
		</cXML>
	</xsl:template>
	<xsl:template name="convertToAribaDate">
		<xsl:param name="Date"/>
		<xsl:variable name="date">
			<xsl:choose>
				<xsl:when test="contains($Date,'T')">
					<xsl:value-of select="substring-before($Date,'T')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($Date,1,10)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:choose>
				<xsl:when test="contains($Date,'T')">
					<xsl:value-of select="substring-after($Date,'T')"/>
				</xsl:when>
				<xsl:when test="normalize-space(substring($Date,11))!=''">
					<xsl:value-of select="substring($Date,11)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="timezone">
			<xsl:choose>
				<xsl:when test="$time!=''">
					<xsl:choose>
						<xsl:when test="contains($time,'-')">
							<xsl:value-of select="concat('-',substring-after($time,'-'))"/>
						</xsl:when>
						<xsl:when test="contains($time,'+')">
							<xsl:value-of select="concat('+',substring-after($time,'+'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$anSenderDefaultTimeZone"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$anSenderDefaultTimeZone"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time2">
			<xsl:if test="$time!=''">
				<xsl:choose>
					<xsl:when test="contains($time,'-')">
						<xsl:value-of select="substring-before($time,'-')"/>
					</xsl:when>
					<xsl:when test="contains($time,'+')">
						<xsl:value-of select="substring-before($time,'+')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$time"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="time3">
			<xsl:choose>
				<xsl:when test="$time2=''">00:00:00</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$time2"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($date,'T',$time3,$timezone)"/>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
</xsl:stylesheet>
