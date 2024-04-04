<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<xsl:param name="anDate"/>
	<xsl:param name="anTime"/>
	<xsl:param name="anICNValue"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anCorrelationID"/>

	<xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_GUSI_2.1.xml')"/>
	<xsl:include href="FORMAT_cXML_0000_GUSI_2.1.xsl"/>

	<!--xsl:variable name="lookups" select="document('cXML_GUSI_lookup.xml')"/>
	<xsl:include href="Format_cXML_to_GUSI.xsl"/-->

	<xsl:template match="//OrderRequest">
		<sh:StandardBusinessDocument xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:order="urn:ean.ucc:order:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:call-template name="createGUSIHeader">
				<xsl:with-param name="version" select="'2.1'"/>
				<xsl:with-param name="type" select="'MultiShipmentOrder'"/>
				<xsl:with-param name="hdrversion" select="'2.2'"/>
				<xsl:with-param name="time" select="substring(/cXML/@timestamp,1,19)"/>
			</xsl:call-template>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="$anCorrelationID"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressIDDomain)"/>
						<xsl:call-template name="createContentOwner">
							<xsl:with-param name="gln" select="normalize-space(OrderRequestHeader/BillTo/IdReference[@domain='EANID']/@identifier)"/>
							<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressID)"/>
							<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
						</xsl:call-template>
					</contentOwner>
				</entityIdentification>
				<eanucc:transaction>
					<entityIdentification>
						<uniqueCreatorIdentification>
							<xsl:value-of select="$anCorrelationID"/>
						</uniqueCreatorIdentification>
						<contentOwner>
							<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressIDDomain)"/>
							<xsl:call-template name="createContentOwner">
								<xsl:with-param name="gln" select="normalize-space(OrderRequestHeader/BillTo/IdReference[@domain='EANID']/@identifier)"/>
								<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressID)"/>
								<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
							</xsl:call-template>
						</contentOwner>
					</entityIdentification>
					<command>
						<eanucc:documentCommand>
							<documentCommandHeader type="ADD">
								<entityIdentification>
									<uniqueCreatorIdentification>0000000000001</uniqueCreatorIdentification>
									<contentOwner>
										<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressIDDomain)"/>
										<xsl:call-template name="createContentOwner">
											<xsl:with-param name="gln" select="normalize-space(OrderRequestHeader/BillTo/IdReference[@domain='EANID']/@identifier)"/>
											<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressID)"/>
											<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
										</xsl:call-template>
									</contentOwner>
								</entityIdentification>
							</documentCommandHeader>
							<documentCommandOperand>
								<xsl:element name="order:multiShipmentOrder">
									<xsl:attribute name="creationDateTime">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="cxmlDate" select="normalize-space(OrderRequestHeader/@orderDate)"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="documentStatus">
										<xsl:choose>
											<xsl:when test="normalize-space(OrderRequestHeader/@type)='new'">ORIGINAL</xsl:when>
											<xsl:when test="normalize-space(OrderRequestHeader/@type)='update'">REPLACE</xsl:when>
											<xsl:otherwise>ORIGINAL</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<contentVersion>
										<versionIdentification>2.1.1</versionIdentification>
									</contentVersion>
									<documentStructureVersion>
										<versionIdentification>2.1.1</versionIdentification>
									</documentStructureVersion>
									<orderIdentification>
										<uniqueCreatorIdentification>
											<xsl:value-of select="normalize-space(OrderRequestHeader/@orderID)"/>
										</uniqueCreatorIdentification>
										<contentOwner>
											<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressIDDomain)"/>
											<xsl:call-template name="createContentOwner">
												<xsl:with-param name="gln" select="normalize-space(OrderRequestHeader/BillTo/IdReference[@domain='EANID']/@identifier)"/>
												<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressID)"/>
												<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
											</xsl:call-template>
										</contentOwner>
									</orderIdentification>
									<orderPartyInformation>
										<seller>
											<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/@addressIDDomain)"/>
											<xsl:call-template name="createContentOwner">
												<xsl:with-param name="gln" select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/IdReference[@domain='EANID']/@identifier)"/>
												<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/@addressID)"/>
												<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
											</xsl:call-template>
											<xsl:if test="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/Name)!=''">
												<additionalPartyIdentification>
													<additionalPartyIdentificationValue>
														<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/Name)"/>
													</additionalPartyIdentificationValue>
													<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
												</additionalPartyIdentification>
											</xsl:if>
										</seller>
										<billTo>
											<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressIDDomain)"/>
											<xsl:call-template name="createContentOwner">
												<xsl:with-param name="gln" select="normalize-space(OrderRequestHeader/BillTo/IdReference[@domain='EANID']/@identifier)"/>
												<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(OrderRequestHeader/BillTo/Address/@addressID)"/>
												<xsl:with-param name="additionalPartyIdentificationType" select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
											</xsl:call-template>
											<xsl:if test="normalize-space(OrderRequestHeader/BillTo/Address/Name)!=''">
												<additionalPartyIdentification>
													<additionalPartyIdentificationValue>
														<xsl:value-of select="normalize-space(OrderRequestHeader/BillTo/Address/Name)"/>
													</additionalPartyIdentificationValue>
													<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
												</additionalPartyIdentification>
											</xsl:if>
										</billTo>
										<buyer>
											<gln>
												<xsl:choose>
													<xsl:when test="normalize-space(OrderRequestHeader/Contact[@role='buyer']/IdReference[@domain='EANID']/@identifier)!=''">
														<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='buyer']/IdReference[@domain='EANID']/@identifier)"/>
													</xsl:when>
													<xsl:when test="normalize-space(OrderRequestHeader/ShipTo/IdReference[@domain='EANID']/@identifier)!=''">
														<xsl:value-of select="normalize-space(OrderRequestHeader/ShipTo/IdReference[@domain='EANID']/@identifier)"/>
													</xsl:when>
													<xsl:otherwise>0000000000000</xsl:otherwise>
												</xsl:choose>
											</gln>
											<xsl:choose>
												<xsl:when test="normalize-space(OrderRequestHeader/Contact[@role='buyer']/@addressID)!=''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='buyer']/@addressID)"/>
														</additionalPartyIdentificationValue>
														<additionalPartyIdentificationType>
															<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/Contact[@role='buyer']/@addressIDDomain)"/>
															<xsl:choose>
																<xsl:when test="$lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode != ''">

																	<xsl:value-of select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
																</xsl:when>
																<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
															</xsl:choose>
														</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:when>
												<xsl:when test="normalize-space(OrderRequestHeader/ShipTo/Address/@addressID)!=''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space(OrderRequestHeader/ShipTo/Address/@addressID)"/>
														</additionalPartyIdentificationValue>
														<additionalPartyIdentificationType>
															<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/ShipTo/Address/@addressIDDomain)"/>
															<xsl:choose>
																<xsl:when test="$lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode != ''">

																	<xsl:value-of select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
																</xsl:when>
																<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
															</xsl:choose>
														</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:when>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="normalize-space(OrderRequestHeader/Contact[@role='buyer']/Name)!=''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='buyer']/Name)"/>
														</additionalPartyIdentificationValue>
														<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:when>
												<xsl:when test="normalize-space(OrderRequestHeader/ShipTo/Address/Name)!=''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space(OrderRequestHeader/ShipTo/Address/Name)"/>
														</additionalPartyIdentificationValue>
														<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:when>
											</xsl:choose>
										</buyer>
									</orderPartyInformation>
									<orderLogisticalInformation>
										<shipToLogistics>
											<shipTo>
												<gln>
													<xsl:choose>
														<xsl:when test="normalize-space(OrderRequestHeader/ShipTo/IdReference[@domain='EANID']/@identifier)!=''">
															<xsl:value-of select="normalize-space(OrderRequestHeader/ShipTo/IdReference[@domain='EANID']/@identifier)"/>
														</xsl:when>
														<xsl:otherwise>0000000000000</xsl:otherwise>
													</xsl:choose>
												</gln>
												<xsl:if test="normalize-space(OrderRequestHeader/ShipTo/Address/@addressID)!=''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space(OrderRequestHeader/ShipTo/Address/@addressID)"/>
														</additionalPartyIdentificationValue>

														<additionalPartyIdentificationType>
															<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/ShipTo/Address/@addressIDDomain)"/>
															<xsl:choose>
																<xsl:when test="$lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode=$addrssIDDm]/GUSICode!= ''">

																	<xsl:value-of select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode=$addrssIDDm]/GUSICode)"/>
																</xsl:when>
																<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
															</xsl:choose>
														</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:if>
												<xsl:if test="normalize-space(OrderRequestHeader/ShipTo/Address/Name)!=''">
													<additionalPartyIdentification>
														<additionalPartyIdentificationValue>
															<xsl:value-of select="normalize-space(OrderRequestHeader/ShipTo/Address/Name)"/>
														</additionalPartyIdentificationValue>
														<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
													</additionalPartyIdentification>
												</xsl:if>
											</shipTo>
											<xsl:choose>
												<xsl:when test="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/Name)!=''">
													<shipFrom>
														<gln>
															<xsl:choose>
																<xsl:when test="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/IdReference[@domain='EANID']/@identifier)!=''">
																	<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/IdReference[@domain='EANID']/@identifier)"/>
																</xsl:when>
																<xsl:otherwise>0000000000000</xsl:otherwise>
															</xsl:choose>
														</gln>
														<xsl:if test="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/@addressID)!=''">
															<additionalPartyIdentification>
																<additionalPartyIdentificationValue>
																	<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/@addressID)"/>
																</additionalPartyIdentificationValue>

																<additionalPartyIdentificationType>
																	<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/@addressIDDomain)"/>
																	<xsl:choose>
																		<xsl:when test="$lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode != ''">

																			<xsl:value-of select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
																		</xsl:when>
																		<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
																	</xsl:choose>
																</additionalPartyIdentificationType>
															</additionalPartyIdentification>
														</xsl:if>
														<xsl:if test="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/Name)!=''">
															<additionalPartyIdentification>
																<additionalPartyIdentificationValue>
																	<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='shipFrom']/Name)"/>
																</additionalPartyIdentificationValue>
																<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
															</additionalPartyIdentification>
														</xsl:if>
													</shipFrom>
												</xsl:when>
												<xsl:when test="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/Name)!=''">
													<shipFrom>
														<gln>
															<xsl:choose>
																<xsl:when test="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/IdReference[@domain='EANID']/@identifier)!=''">
																	<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/IdReference[@domain='EANID']/@identifier)"/>
																</xsl:when>
																<xsl:otherwise>0000000000000</xsl:otherwise>
															</xsl:choose>
														</gln>
														<xsl:if test="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/@addressID)!=''">
															<additionalPartyIdentification>
																<additionalPartyIdentificationValue>
																	<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/@addressID)"/>
																</additionalPartyIdentificationValue>

																<additionalPartyIdentificationType>
																	<xsl:variable name="addrssIDDm" select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/@addressIDDomain)"/>
																	<xsl:choose>
																		<xsl:when test="$lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode != ''">

																			<xsl:value-of select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
																		</xsl:when>
																		<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
																	</xsl:choose>
																</additionalPartyIdentificationType>
															</additionalPartyIdentification>
														</xsl:if>
														<xsl:if test="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/Name)!=''">
															<additionalPartyIdentification>
																<additionalPartyIdentificationValue>
																	<xsl:value-of select="normalize-space(OrderRequestHeader/Contact[@role='supplierCorporate']/Name)"/>
																</additionalPartyIdentificationValue>
																<additionalPartyIdentificationType>FOR_INTERNAL_USE_1</additionalPartyIdentificationType>
															</additionalPartyIdentification>
														</xsl:if>
													</shipFrom>
												</xsl:when>
											</xsl:choose>
										</shipToLogistics>
										<orderLogisticalDateGroup>
											<requestedDeliveryDateRange>
												<earliestDate>
													<xsl:choose>
														<xsl:when test="OrderRequestHeader/DeliveryPeriod/Period/@startDate!=''">
															<xsl:call-template name="formatDateOnly">
																<xsl:with-param name="cxmlDate" select="OrderRequestHeader/DeliveryPeriod/Period/@startDate"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:when test="OrderRequestHeader/@effectiveDate!=''">
															<xsl:call-template name="formatDateOnly">
																<xsl:with-param name="cxmlDate" select="OrderRequestHeader/@effectiveDate"/>
															</xsl:call-template>
														</xsl:when>
													</xsl:choose>
												</earliestDate>
												<latestDate>
													<xsl:choose>
														<xsl:when test="OrderRequestHeader/DeliveryPeriod/Period/@endDate!=''">
															<xsl:call-template name="formatDateOnly">
																<xsl:with-param name="cxmlDate" select="OrderRequestHeader/DeliveryPeriod/Period/@endDate"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:when test="OrderRequestHeader/DeliveryPeriod/Period/@startDate!=''">
															<xsl:call-template name="formatDateOnly">
																<xsl:with-param name="cxmlDate" select="OrderRequestHeader/DeliveryPeriod/Period/@startDate"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:when test="OrderRequestHeader/@expirationDate!=''">
															<xsl:call-template name="formatDateOnly">
																<xsl:with-param name="cxmlDate" select="OrderRequestHeader/@expirationDate"/>
															</xsl:call-template>
														</xsl:when>
													</xsl:choose>
												</latestDate>
											</requestedDeliveryDateRange>
										</orderLogisticalDateGroup>
									</orderLogisticalInformation>
									<xsl:for-each select="ItemOut">
										<xsl:element name="multiShipmentOrderLineItem">
											<xsl:attribute name="number">
												<xsl:value-of select="normalize-space(@lineNumber)"/>
											</xsl:attribute>
											<requestedQuantity>
												<value>
													<xsl:value-of select="normalize-space(@quantity)"/>
												</value>
												<unitOfMeasure>
													<xsl:value-of select="ItemDetail/UnitOfMeasure"/>
												</unitOfMeasure>
											</requestedQuantity>
											<tradeItemIdentification>
												<gtin>
													<xsl:choose>
														<xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)!=''">
															<xsl:value-of select="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)"/>
														</xsl:when>
														<xsl:otherwise>00000000000000</xsl:otherwise>
													</xsl:choose>
												</gtin>
												<xsl:if test="normalize-space(ItemID/BuyerPartID)!=''">
													<additionalTradeItemIdentification>
														<additionalTradeItemIdentificationValue>
															<xsl:value-of select="normalize-space(ItemID/BuyerPartID)"/>
														</additionalTradeItemIdentificationValue>
														<additionalTradeItemIdentificationType>BUYER_ASSIGNED</additionalTradeItemIdentificationType>
													</additionalTradeItemIdentification>
												</xsl:if>
											</tradeItemIdentification>
											<purchaseConditions>
												<xsl:element name="documentLineReference">
													<xsl:attribute name="number">
														<xsl:choose>
															<xsl:when test="normalize-space(ItemOutIndustry/ReferenceDocumentInfo[DocumentInfo/@documentType='purchaseOrder']/@lineNumber)!=''">
																<xsl:value-of select="normalize-space(ItemOutIndustry/ReferenceDocumentInfo[DocumentInfo/@documentType='purchaseOrder']/@lineNumber)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="normalize-space(@lineNumber)"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:element name="documentReference">
														<xsl:choose>
															<xsl:when test="normalize-space(ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo[@documentType='purchaseOrder']/@documentDate)">
																<xsl:attribute name="creationDateTime">
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="cxmlDate" select="normalize-space(ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo[@documentType='purchaseOrder']/@documentDate)"/>
																	</xsl:call-template>
																</xsl:attribute>
															</xsl:when>
															<xsl:when test="normalize-space(MasterAgreementIDInfo/@agreementDate)!=''">
																<xsl:attribute name="creationDateTime">
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="cxmlDate" select="normalize-space(MasterAgreementIDInfo/@agreementDate)"/>
																	</xsl:call-template>
																</xsl:attribute>
															</xsl:when>
														</xsl:choose>
														<uniqueCreatorIdentification>
															<xsl:choose>
																<xsl:when test="ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo[@documentType='purchaseOrder']/@documentID">
																	<xsl:value-of select="ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo[@documentType='purchaseOrder']/@documentID"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="normalize-space(MasterAgreementIDInfo/@agreementID)"/>
																</xsl:otherwise>
															</xsl:choose>
														</uniqueCreatorIdentification>
														<contentOwner>
															<gln>
																<xsl:choose>
																	<xsl:when test="$anAlternativeSender!=''">
																		<xsl:text>0000000000000</xsl:text>
																	</xsl:when>

																	<xsl:when test="normalize-space(Contact[@role='buyer']/IdReference[@domain='EANID']/@identifier)!=''">
																		<xsl:value-of select="normalize-space(Contact[@role='buyer']/IdReference[@domain='EANID']/@identifier)"/>
																	</xsl:when>
																	<xsl:otherwise>0000000000000</xsl:otherwise>
																</xsl:choose>
															</gln>
															<xsl:choose>

																<xsl:when test="normalize-space(Contact[@role='buyer']/@addressID)!=''">
																	<additionalPartyIdentification>
																		<additionalPartyIdentificationValue>
																			<xsl:value-of select="normalize-space(Contact[@role='buyer']/@addressID)"/>
																		</additionalPartyIdentificationValue>

																		<additionalPartyIdentificationType>
																			<xsl:variable name="addrssIDDm" select="normalize-space(Contact[@role='buyer']/@addressIDDomain)"/>
																			<xsl:choose>
																				<xsl:when test="$lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode != ''">

																					<xsl:value-of select="normalize-space($lookups/Lookups/additionalPartyIdentificationTypes/additionalPartyIdentificationType[cXMLCode = $addrssIDDm]/GUSICode)"/>
																				</xsl:when>
																				<xsl:otherwise>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</xsl:otherwise>
																			</xsl:choose>
																		</additionalPartyIdentificationType>
																	</additionalPartyIdentification>
																</xsl:when>
																<xsl:when test="$anAlternativeSender!=''">
																	<additionalPartyIdentification>
																		<additionalPartyIdentificationValue>
																			<xsl:value-of select="normalize-space($anAlternativeSender)"/>
																		</additionalPartyIdentificationValue>
																		<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
																	</additionalPartyIdentification>
																</xsl:when>
															</xsl:choose>
														</contentOwner>
													</xsl:element>
												</xsl:element>
											</purchaseConditions>
											<xsl:for-each select="ScheduleLine">
												<shipmentDetail>
													<requestedQuantity>
														<value>
															<xsl:value-of select="normalize-space(@quantity)"/>
														</value>
														<unitOfMeasure>
															<measurementUnitCodeValue>
																<xsl:value-of select="normalize-space(UnitOfMeasure)"/>
															</measurementUnitCodeValue>
														</unitOfMeasure>
													</requestedQuantity>
													<xsl:if test="normalize-space(Extrinsic[@name='InventoryLocationID'])!=''">
														<inventoryLocation>
															<gln>0000000000000</gln>
															<additionalPartyIdentification>
																<additionalPartyIdentificationValue>
																	<xsl:value-of select="normalize-space(Extrinsic[@name='InventoryLocationID'])"/>
																</additionalPartyIdentificationValue>
																<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
															</additionalPartyIdentification>
														</inventoryLocation>
													</xsl:if>
													<xsl:if test="normalize-space(@lineNumber)!=''">
														<purchaseConditions>
															<xsl:element name="documentLineReference">
																<xsl:attribute name="number">
																	<xsl:value-of select="normalize-space(@lineNumber)"/>
																</xsl:attribute>
															</xsl:element>
														</purchaseConditions>
													</xsl:if>
													<xsl:if test="normalize-space(@requestedDeliveryDate)!=''">
														<orderLogisticalDateGroup>
															<requestedDeliveryDateRange>
																<earliestDate>
																	<xsl:call-template name="formatDateOnly">
																		<xsl:with-param name="cxmlDate" select="normalize-space(@requestedDeliveryDate)"/>
																	</xsl:call-template>
																</earliestDate>
																<latestDate>
																	<xsl:choose>
																		<xsl:when test="normalize-space(@deliveryWindow)!=''">
																			<xsl:call-template name="formatDate1">
																				<xsl:with-param name="cxmlDate" select="normalize-space(@requestedDeliveryDate)"/>
																				<xsl:with-param name="numDays" select="normalize-space(@deliveryWindow)"></xsl:with-param>
																			</xsl:call-template>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:call-template name="formatDateOnly">
																				<xsl:with-param name="cxmlDate" select="normalize-space(@requestedDeliveryDate)"/>
																			</xsl:call-template>
																		</xsl:otherwise>
																	</xsl:choose>
																</latestDate>
																<earliestTime>
																	<xsl:value-of select="substring(substring-after(normalize-space(@requestedDeliveryDate),'T'),1,8)"/>
																</earliestTime>
																<latestTime>


																	<xsl:value-of select="substring(substring-after(normalize-space(@requestedDeliveryDate),'T'),1,8)"/>
																</latestTime>
															</requestedDeliveryDateRange>
														</orderLogisticalDateGroup>
													</xsl:if>
												</shipmentDetail>
											</xsl:for-each>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
							</documentCommandOperand>
						</eanucc:documentCommand>
					</command>
				</eanucc:transaction>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>
	<xsl:template match="cXML/Header"/>

	<xsl:template name="formatDate1">
		<xsl:param name="cxmlDate"/>
		<xsl:param name="numDays"/>
		<xsl:variable name="tempDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="cxmlDate" select="$cxmlDate"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="xs:dateTime($tempDate) + xs:dayTimeDuration($numDays)"/>
		<!--xsl:value-of select="xs:date($tempDate) + xs:dayTimeDuration(concat('P',$numDays,'D'))"/-->
	</xsl:template>

	<xsl:template name="formatDateOnly">
		<xsl:param name="cxmlDate"/>

		<xsl:value-of select="substring-before($cxmlDate,'T')"/>
	</xsl:template>
</xsl:stylesheet>
