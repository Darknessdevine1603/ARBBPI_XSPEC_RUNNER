<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
	xmlns:eanucc="urn:ean.ucc:2" xmlns:dl="urn:ean.ucc:deliver:2"
	exclude-result-prefixes="sh eanucc dl xs">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anSenderDefaultTimeZone"/>
	<!--  <xsl:param name="cXMLAttachments"/>    		
		<xsl:param name="attachSeparator" select="'\|'"/>-->
	<xsl:variable name="currentDate" select="current-dateTime()"/>

	<xsl:template
		match="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/dl:despatchAdvice">
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:call-template name="convertToAribaDate">
					<xsl:with-param name="Date">
						<xsl:value-of select="$currentDate"/>
					</xsl:with-param>
				</xsl:call-template>
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
				<ShipNoticeRequest>
					<ShipNoticeHeader>
						<xsl:attribute name="shipmentID">
							<xsl:value-of
								select="normalize-space(despatchAdviceIdentification/uniqueCreatorIdentification)"
							/>
						</xsl:attribute>
						<xsl:if test="normalize-space(@documentStatus) != ''">
							<xsl:attribute name="operation">
								<xsl:choose>
									<xsl:when test="normalize-space(@documentStatus) = 'ORIGINAL'"
										>new</xsl:when>
								</xsl:choose>
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="noticeDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="Date">
									<xsl:value-of select="normalize-space(@creationDateTime)"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:if
							test="normalize-space(despatchInformation/actualShipping/actualShipDateTime) != ''">
							<xsl:attribute name="shipmentDate">
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="Date">
										<xsl:value-of
											select="normalize-space(despatchInformation/actualShipping/actualShipDateTime)"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<xsl:if
							test="normalize-space(despatchInformation/actualShipping/estimatedDeliveryDateTime) != ''">
							<xsl:attribute name="deliveryDate">
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="Date">
										<xsl:value-of
											select="normalize-space(despatchInformation/actualShipping/estimatedDeliveryDateTime)"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<!-- Contact -->
						<!--Defect IG-1539-->
						<!-- Shipfrom -->
						<xsl:choose>
							<xsl:when
								test="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
								<Contact>
									<xsl:attribute name="role">shipFrom</xsl:attribute>
									<xsl:if
										test="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
										<xsl:attribute name="addressID">
											<xsl:value-of
												select="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"
											/>
										</xsl:attribute>
										<xsl:attribute name="addressIDDomain">
											<xsl:text>Assigned by buyer or buyer's agent</xsl:text>
										</xsl:attribute>
									</xsl:if>
									<Name>
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:value-of
											select="normalize-space(shipFrom/additionalPartyIdentification[additionalPartyIdentificationType = 'FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"
										/>
									</Name>
									<xsl:if test="normalize-space(shipFrom/gln) != '0000000000000'">
										<IdReference>
											<xsl:attribute name="identifier">
												<xsl:value-of select="normalize-space(shipFrom/gln)"
												/>
											</xsl:attribute>
											<xsl:attribute name="domain">EANID</xsl:attribute>
										</IdReference>
									</xsl:if>
								</Contact>
							</xsl:when>
							<xsl:when
								test="normalize-space(shipper/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
								<Contact>
									<xsl:attribute name="role">shipFrom</xsl:attribute>
									<xsl:if
										test="normalize-space(shipper/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
										<xsl:attribute name="addressID">
											<xsl:value-of
												select="normalize-space(shipper/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"
											/>
										</xsl:attribute>
										<xsl:attribute name="addressIDDomain">
											<xsl:text>Assigned by buyer or buyer's agent</xsl:text>
										</xsl:attribute>
									</xsl:if>
									<Name>
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:value-of
											select="normalize-space(shipper/additionalPartyIdentification[additionalPartyIdentificationType = 'FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"
										/>
									</Name>
									<xsl:if test="normalize-space(shipper/gln) != '0000000000000'">
										<IdReference>
											<xsl:attribute name="identifier">
												<xsl:value-of select="normalize-space(shipper/gln)"
												/>
											</xsl:attribute>
											<xsl:attribute name="domain">EANID</xsl:attribute>
										</IdReference>
									</xsl:if>
								</Contact>
							</xsl:when>
						</xsl:choose>
						<!-- ShipTo -->
						<xsl:if
							test="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
							<Contact>
								<xsl:attribute name="role">shipTo</xsl:attribute>
								<xsl:if
									test="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
									<xsl:attribute name="addressID">
										<xsl:value-of
											select="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"
										/>
									</xsl:attribute>
									<xsl:attribute name="addressIDDomain">
										<xsl:text>Assigned by buyer or buyer's agent</xsl:text>
									</xsl:attribute>
								</xsl:if>
								<Name>
									<xsl:attribute name="xml:lang">en</xsl:attribute>
									<xsl:value-of
										select="normalize-space(shipTo/additionalPartyIdentification[additionalPartyIdentificationType = 'FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"
									/>
								</Name>
								<xsl:if test="normalize-space(shipTo/gln) != '0000000000000'">
									<IdReference>
										<xsl:attribute name="identifier">
											<xsl:value-of select="normalize-space(shipTo/gln)"/>
										</xsl:attribute>
										<xsl:attribute name="domain">EANID</xsl:attribute>
									</IdReference>
								</xsl:if>
							</Contact>
						</xsl:if>
						<!-- endUser -->
						<xsl:if
							test="normalize-space(receiver/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
							<Contact>
								<xsl:attribute name="role">endUser</xsl:attribute>
								<xsl:if
									test="normalize-space(receiver/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
									<xsl:attribute name="addressID">
										<xsl:value-of
											select="normalize-space(receiver/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"
										/>
									</xsl:attribute>
									<xsl:attribute name="addressIDDomain">
										<xsl:text>Assigned by buyer or buyer's agent</xsl:text>
									</xsl:attribute>
								</xsl:if>
								<Name>
									<xsl:attribute name="xml:lang">en</xsl:attribute>
									<xsl:value-of
										select="normalize-space(receiver/additionalPartyIdentification[additionalPartyIdentificationType = 'FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"
									/>
								</Name>
								<xsl:if test="normalize-space(receiver/gln) != '0000000000000'">
									<IdReference>
										<xsl:attribute name="identifier">
											<xsl:value-of select="normalize-space(receiver/gln)"/>
										</xsl:attribute>
										<xsl:attribute name="domain">EANID</xsl:attribute>
									</IdReference>
								</xsl:if>
							</Contact>
						</xsl:if>
						<!-- carrierCorporate -->
						<xsl:if
							test="normalize-space(carrier/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
							<Contact>
								<xsl:attribute name="role">carrierCorporate</xsl:attribute>
								<xsl:if
									test="normalize-space(carrier/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue) != ''">
									<xsl:attribute name="addressID">
										<xsl:value-of
											select="normalize-space(carrier/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue)"
										/>
									</xsl:attribute>
									<xsl:attribute name="addressIDDomain">
										<xsl:text>Assigned by buyer or buyer's agent</xsl:text>
									</xsl:attribute>
								</xsl:if>
								<Name>
									<xsl:attribute name="xml:lang">en</xsl:attribute>
									<xsl:value-of
										select="normalize-space(carrier/additionalPartyIdentification[additionalPartyIdentificationType = 'FOR_INTERNAL_USE_1']/additionalPartyIdentificationValue)"
									/>
								</Name>
								<xsl:if test="normalize-space(carrier/gln) != '0000000000000'">
									<IdReference>
										<xsl:attribute name="identifier">
											<xsl:value-of select="normalize-space(carrier/gln)"/>
										</xsl:attribute>
										<xsl:attribute name="domain">EANID</xsl:attribute>
									</IdReference>
								</xsl:if>
							</Contact>
						</xsl:if>
						<xsl:if
							test="normalize-space(deliveryAndTransportInformation/deliveryOrTransportTerms) != ''">
							<TermsOfTransport>
								<TransportTerms>
									<xsl:attribute name="value">
										<xsl:value-of
											select="normalize-space(deliveryAndTransportInformation/deliveryOrTransportTerms)"
										/>
									</xsl:attribute>
								</TransportTerms>
							</TermsOfTransport>
						</xsl:if>
					</ShipNoticeHeader>
					<ShipControl>
						<xsl:if
							test="normalize-space(deliveryAndTransportInformation/modeOfTransport) != ''">
							<CarrierIdentifier>
								<xsl:attribute name="domain">companyID</xsl:attribute>
								<xsl:value-of
									select="normalize-space(carrier/additionalPartyIdentification[1]/additionalPartyIdentificationValue)"
								/>
							</CarrierIdentifier>
						</xsl:if>
						<ShipmentIdentifier>
							<xsl:attribute name="domain">billOfLading</xsl:attribute>
							<xsl:if
								test="deliveryAndTransportInformation/billOfLadingNumber/referenceDateTime">
								<xsl:attribute name="trackingNumberDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="Date">
											<xsl:value-of
												select="normalize-space(deliveryAndTransportInformation/billOfLadingNumber/referenceDateTime)"
											/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of
								select="normalize-space(deliveryAndTransportInformation/billOfLadingNumber/referenceIdentification)"
							/>
						</ShipmentIdentifier>
						<xsl:if
							test="normalize-space(deliveryAndTransportInformation/modeOfTransport) != ''">
							<Route>
								<xsl:attribute name="method">
									<xsl:choose>
										<xsl:when
											test="normalize-space(deliveryAndTransportInformation/modeOfTransport) = 'AIR'"
											>air</xsl:when>
										<xsl:when
											test="normalize-space(deliveryAndTransportInformation/modeOfTransport) = 'OCEAN'"
											>ship</xsl:when>
										<xsl:when
											test="normalize-space(deliveryAndTransportInformation/modeOfTransport) = 'RAIL'"
											>rail</xsl:when>
										<xsl:when
											test="normalize-space(deliveryAndTransportInformation/modeOfTransport) = 'MOTOR'"
											>motor</xsl:when>
										<xsl:when
											test="normalize-space(deliveryAndTransportInformation/modeOfTransport) = 'SUPPLIER_TRUCK'"
											>motor</xsl:when>
									</xsl:choose>
								</xsl:attribute>
							</Route>
						</xsl:if>
					</ShipControl>
					<!-- Defect IG-1542 -->
					<xsl:for-each-group select="despatchAdviceItemContainmentLineItem"
						group-by="purchaseOrder/documentLineReference/documentReference/uniqueCreatorIdentification">
						<!--<xsl:for-each select="despatchAdviceItemContainmentLineItem">-->
						<ShipNoticePortion>
							<xsl:if
								test="normalize-space(purchaseOrder/documentLineReference/documentReference/uniqueCreatorIdentification) != ''">
								<OrderReference>
									<xsl:attribute name="orderID">
										<xsl:value-of
											select="normalize-space(purchaseOrder/documentLineReference/documentReference/uniqueCreatorIdentification)"
										/>
									</xsl:attribute>
									<DocumentReference>
										<xsl:attribute name="payloadID"/>
									</DocumentReference>
								</OrderReference>
							</xsl:if>
							<!-- Defect IG-1542 -->
							<xsl:for-each select="current-group()">
								<ShipNoticeItem>
									<xsl:attribute name="quantity">
										<xsl:value-of
											select="normalize-space(quantityContained/value)"/>
									</xsl:attribute>
									<xsl:attribute name="lineNumber">
										<xsl:value-of
											select="normalize-space(purchaseOrder/documentLineReference/@number)"
										/>
									</xsl:attribute>
									<xsl:if test="normalize-space(@number)">
										<xsl:attribute name="shipNoticeLineNumber">
											<xsl:value-of select="normalize-space(@number)"/>
										</xsl:attribute>
									</xsl:if>
									<ItemID>
										<xsl:for-each
											select="containedItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType = 'SUPPLIER_ASSIGNED']">
											<!--<xsl:if test="additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED'"> -->
											<SupplierPartID>
												<xsl:value-of
												select="normalize-space(additionalTradeItemIdentificationValue)"/>
											</SupplierPartID>
											<!--</xsl:if>-->
										</xsl:for-each>
										<xsl:for-each
											select="containedItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType = 'BUYER_ASSIGNED']">
											<!--<xsl:if test="additionalTradeItemIdentificationType='BUYER_ASSIGNED'">  -->
											<BuyerPartID>
												<xsl:value-of
												select="normalize-space(additionalTradeItemIdentificationValue)"/>
											</BuyerPartID>
											<!--</xsl:if>-->
										</xsl:for-each>
									</ItemID>
									<ShipNoticeItemDetail>
										<xsl:for-each
											select="containedItemIdentification/additionalTradeItemIdentification">
											<xsl:if
												test="additionalTradeItemIdentificationType = 'INDUSTRY_ASSIGNED'">
												<ManufacturerPartID>
												<xsl:value-of
												select="normalize-space(additionalTradeItemIdentificationValue)"/>
												</ManufacturerPartID>
											</xsl:if>
										</xsl:for-each>
										<xsl:if
											test="normalize-space(containedItemIdentification/gtin) != '00000000000000'">
											<ItemDetailIndustry>
												<ItemDetailRetail>
												<EANID>
												<xsl:value-of
												select="normalize-space(containedItemIdentification/gtin)"
												/>
												</EANID>
												</ItemDetailRetail>
											</ItemDetailIndustry>
										</xsl:if>
									</ShipNoticeItemDetail>
									<UnitOfMeasure>
										<xsl:value-of
											select="quantityContained/unitOfMeasure/measurementUnitCodeValue"
										/>
									</UnitOfMeasure>
									<!-- Defect IG-1542 -->
									<xsl:if
										test="normalize-space(extendedAttributes/lotNumber) != '' or normalize-space(extendedAttributes/batchNumber) != ''">
										<Batch>
											<xsl:if
												test="normalize-space(extendedAttributes/lotNumber) != ''">
												<BuyerBatchID>
												<xsl:value-of
												select="normalize-space(extendedAttributes/lotNumber)"
												/>
												</BuyerBatchID>
											</xsl:if>
											<xsl:if
												test="normalize-space(extendedAttributes/batchNumber) != ''">
												<SupplierBatchID>
												<xsl:value-of
												select="normalize-space(extendedAttributes/batchNumber)"
												/>
												</SupplierBatchID>
											</xsl:if>
										</Batch>
									</xsl:if>
									<xsl:if
										test="normalize-space(extendedAttributes/bestBeforeDate) != '' or normalize-space(extendedAttributes/itemExpirationDate) != ''">
										<ShipNoticeItemIndustry>
											<ShipNoticeItemRetail>
												<xsl:if
												test="normalize-space(extendedAttributes/bestBeforeDate) != ''">
												<BestBeforeDate>
												<xsl:attribute name="date">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date">
												<xsl:value-of
												select="extendedAttributes/bestBeforeDate"/>
												</xsl:with-param>
												</xsl:call-template>
												</xsl:attribute>
												</BestBeforeDate>
												</xsl:if>
												<xsl:if
												test="normalize-space(extendedAttributes/itemExpirationDate) != ''">
												<ExpiryDate>
												<xsl:attribute name="date">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date">
												<xsl:value-of
												select="extendedAttributes/itemExpirationDate"/>
												</xsl:with-param>
												</xsl:call-template>
												</xsl:attribute>
												</ExpiryDate>
												</xsl:if>
											</ShipNoticeItemRetail>
										</ShipNoticeItemIndustry>
									</xsl:if>
								</ShipNoticeItem>
							</xsl:for-each>
						</ShipNoticePortion>
					</xsl:for-each-group>
				</ShipNoticeRequest>
			</Request>
		</cXML>
	</xsl:template>

	<xsl:template name="convertToAribaDate">
		<xsl:param name="Date"/>
		<xsl:variable name="date">
			<xsl:choose>
				<xsl:when test="contains($Date, 'T')">
					<xsl:value-of select="substring-before($Date, 'T')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring($Date, 1, 10)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:choose>
				<xsl:when test="contains($Date, 'T')">
					<xsl:value-of select="substring($Date, 11)"/>
				</xsl:when>
				<xsl:when test="normalize-space(substring($Date, 11)) != ''">
					<xsl:value-of select="substring($Date, 11)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'T00:00:00'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="defaultTimezone">
			<xsl:choose>
				<xsl:when test="contains($time, '-') or contains($time, '+')">
					<xsl:value-of select="''"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$anSenderDefaultTimeZone"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($date, $time, $defaultTimezone)"/>
	</xsl:template>


	<xsl:template match="@* | node()">
		<xsl:apply-templates select="@* | node()"/>
	</xsl:template>
</xsl:stylesheet>
