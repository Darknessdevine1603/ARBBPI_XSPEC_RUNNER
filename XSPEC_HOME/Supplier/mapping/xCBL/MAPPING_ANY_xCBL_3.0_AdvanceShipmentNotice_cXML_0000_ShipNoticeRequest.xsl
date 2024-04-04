<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<!--xsl:include href="Format_XCBL_CXML_common.xsl"/-->

	<xsl:include href="pd:HCIOWNERPID:Format_XCBL_CXML_common:Binary"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>


	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>

	<xsl:template match="AdvanceShipmentNotice">
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
							<xsl:value-of select="ASNHeader/ASNNumber/Reference/RefNum"/>
						</xsl:attribute>
						<xsl:attribute name="noticeDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="input" select="ASNHeader/ASNIssueDate"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="operation">
							<xsl:choose>
								<xsl:when test="ASNHeader/ASNPurpose/ASNPurposeCoded = 'Original'">new</xsl:when>
								<xsl:when test="ASNHeader/ASNPurpose/ASNPurposeCoded = 'Cancel'">delete</xsl:when>
								<xsl:otherwise>update</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="shipmentType">
							<xsl:choose>
								<xsl:when test="ASNHeader/ASNType/ASNTypeCoded = 'Other'">
									<xsl:value-of select="translate(ASNHeader/ASNType/ASNTypeCodedOther, $upperAlpha, $lowerAlpha)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="translate(ASNHeader/ASNType/ASNTypeCoded, $upperAlpha, $lowerAlpha)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<!-- CC-018913 Map for scenario with Logistic Provider (CSN) -->
						<xsl:if test="ASNHeader/ASNDates/DeliveryDate != '' or ASNHeader/ListOfTransportRouting/TransportRouting/TransportLocationList/StartTransportLocation/TransportLocation/EstimatedArrivalDate">
							<xsl:choose>
								<xsl:when test="ASNHeader/ASNDates/DeliveryDate != ''">
									<xsl:attribute name="deliveryDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="ASNHeader/ASNDates/DeliveryDate"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:when>
								<xsl:when test="ASNHeader/ListOfTransportRouting/TransportRouting/TransportLocationList/StartTransportLocation/TransportLocation/EstimatedArrivalDate != ''">
									<xsl:attribute name="deliveryDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="concat(ASNHeader/ListOfTransportRouting/TransportRouting/TransportLocationList/StartTransportLocation/TransportLocation/EstimatedArrivalDate, '')"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						<!-- CC-018913 Map for scenario with Logistic Provider (CSN) -->
						<xsl:if test="ASNHeader/ASNDates/ShippedDate != '' or ASNHeader/ListOfTransportRouting/TransportRouting/TransportLocationList/StartTransportLocation/TransportLocation/EstimatedArrivalDate">
							<xsl:choose>
								<xsl:when test="ASNHeader/ASNDates/ShippedDate != ''">
									<xsl:attribute name="shipmentDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="ASNHeader/ASNDates/ShippedDate"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:when>
								<xsl:when test="ASNHeader/ListOfTransportRouting/TransportRouting/TransportLocationList/StartTransportLocation/TransportLocation/EstimatedArrivalDate != ''">
									<xsl:attribute name="shipmentDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="concat(ASNHeader/ListOfTransportRouting/TransportRouting/TransportLocationList/StartTransportLocation/TransportLocation/EstimatedArrivalDate, '')"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						<ServiceLevel>
							<xsl:attribute name="xml:lang">
								<xsl:value-of select="ASNHeader/ASNLanguage/Language/LanguageCoded"/>
							</xsl:attribute>
							<xsl:value-of select="ASNHeader/ListOfTransportRouting/TransportRouting/ServiceLevel/ServiceLevelCodedOther"/>
						</ServiceLevel>
						<Contact role="soldTo">
							<xsl:attribute name="addressID">
								<xsl:value-of select="ASNHeader/ASNParty/OrderParty/BuyerParty/Party/PartyID/Identifier/Ident"/>
							</xsl:attribute>
							<xsl:call-template name="CreateContact">
								<xsl:with-param name="PartyInfo" select="ASNHeader/ASNParty/OrderParty/BuyerParty"/>
							</xsl:call-template>
						</Contact>
						<Contact role="from">
							<xsl:attribute name="addressID">
								<xsl:value-of select="ASNHeader/ASNParty/OrderParty/SellerParty/Party/PartyID/Identifier/Ident"/>
							</xsl:attribute>
							<xsl:call-template name="CreateContact">
								<xsl:with-param name="PartyInfo" select="ASNHeader/ASNParty/OrderParty/SellerParty"/>
							</xsl:call-template>
						</Contact>
						<Contact role="shipTo">
							<xsl:attribute name="addressID">
								<xsl:value-of select="ASNHeader/ASNParty/OrderParty/ShipToParty/Party/PartyID/Identifier/Ident"/>
							</xsl:attribute>
							<xsl:call-template name="CreateContact">
								<xsl:with-param name="PartyInfo" select="ASNHeader/ASNParty/OrderParty/ShipToParty"/>
							</xsl:call-template>
						</Contact>
						<xsl:if test="ASNHeader/ASNParty/OrderParty/BillToParty">
							<Contact role="billTo">
								<xsl:attribute name="addressID">
									<xsl:value-of select="ASNHeader/ASNParty/OrderParty/BillToParty/Party/PartyID/Identifier/Ident"/>
								</xsl:attribute>
								<xsl:call-template name="CreateContact">
									<xsl:with-param name="PartyInfo" select="ASNHeader/ASNParty/OrderParty/BillToParty"/>
								</xsl:call-template>
							</Contact>
						</xsl:if>
						<Contact role="shipFrom">
							<xsl:attribute name="addressID">
								<xsl:value-of select="ASNHeader/ASNParty/OrderParty/ShipFromParty/Party/PartyID/Identifier/Ident"/>
							</xsl:attribute>
							<xsl:call-template name="CreateContact">
								<xsl:with-param name="PartyInfo" select="ASNHeader/ASNParty/OrderParty/ShipFromParty"/>
							</xsl:call-template>
						</Contact>
						<xsl:if test="ASNHeader/ASNParty/OrderParty/RemitToParty">
							<Contact role="remitTo">
								<xsl:attribute name="addressID">
									<xsl:value-of select="ASNHeader/ASNParty/OrderParty/RemitToParty/Party/PartyID/Identifier/Ident"/>
								</xsl:attribute>
								<xsl:call-template name="CreateContact">
									<xsl:with-param name="PartyInfo" select="ASNHeader/ASNParty/OrderParty/RemitToParty"/>
								</xsl:call-template>
							</Contact>
						</xsl:if>
						<Comments type="ReasonForShipment">
							<xsl:value-of select="ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'ReasonForShipment']/PrimaryReference/Reference/RefNum"/>
						</Comments>
						<Comments type="TransitDirection">
							<xsl:choose>
								<xsl:when test="ASNHeader/ListOfTransportRouting/TransportRouting/TransitDirection/TransitDirectionCoded = 'Other'">
									<xsl:value-of select="ASNHeader/ListOfTransportRouting/TransportRouting/TransitDirection/TransitDirectionCodedOther"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ASNHeader/ListOfTransportRouting/TransportRouting/TransitDirection/TransitDirectionCoded"/>
								</xsl:otherwise>
							</xsl:choose>
						</Comments>
						<Comments type="CommentsToBuyer">
							<xsl:value-of select="ASNHeader/ASNHeaderNote"/>
						</Comments>
						<Comments>
							<xsl:value-of select="ASNHeader/ASNHeaderNote"/>
							<xsl:for-each select="ASNHeader/ASNHeaderAttachments/ListOfAttachment/Attachment">
								<Attachment>
									<URL>
										<xsl:attribute name="name">
											<xsl:value-of select="FileName"/>
										</xsl:attribute>
										<xsl:choose>
											<xsl:when test="starts-with(AttachmentLocation, 'cid:')">
												<xsl:value-of select="AttachmentLocation"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat('cid:', AttachmentLocation)"/>
											</xsl:otherwise>
										</xsl:choose>
									</URL>
								</Attachment>
							</xsl:for-each>
						</Comments>
						<xsl:if test="ASNHeader/ASNTermsOfDelivery">
							<TermsOfDelivery>
								<TermsOfDeliveryCode value="Other">
									<xsl:choose>
										<xsl:when test="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TermsOfDeliveryFunctionCoded = 'Other'">
											<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TermsOfDeliveryFunctionCodedOther"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TermsOfDeliveryFunctionCoded"/>
										</xsl:otherwise>
									</xsl:choose>
								</TermsOfDeliveryCode>
								<ShippingPaymentMethod value="Other">
									<xsl:choose>
										<xsl:when test="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/ShipmentMethodOfPaymentCoded = 'Other'">
											<xsl:choose>
												<xsl:when test="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/ShipmentMethodOfPaymentCodedOther">
													<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/ShipmentMethodOfPaymentCodedOther"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Other</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/ShipmentMethodOfPaymentCoded"/>
										</xsl:otherwise>
									</xsl:choose>
								</ShippingPaymentMethod>
								<xsl:if test="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TransportTermsCoded">
									<TransportTerms value="Other">
										<xsl:choose>
											<xsl:when test="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TransportTermsCoded = 'Other'">

												<xsl:choose>
													<xsl:when test="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TransportTermsCodedOther">
														<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TransportTermsCodedOther"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>Other</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TransportTermsCoded"/>
											</xsl:otherwise>
										</xsl:choose>
									</TransportTerms>
								</xsl:if>
								<Comments type="TermsOfDelivery">
									<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TermsOfDeliveryDescription"/>
								</Comments>
								<Comments type="Transport">
									<xsl:value-of select="ASNHeader/ASNTermsOfDelivery/TermsOfDelivery/TransportDescription"/>
								</Comments>
							</TermsOfDelivery>
						</xsl:if>

						<!-- CC-018913 : Map Packaging Dimensions -->
						<xsl:if test="ASNSummary/TransportPackagingTotals/GrossVolume or ASNSummary/TransportPackagingTotals/TotalGrossWeight or ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[SupportingReference = 'Length'] or ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[SupportingReference = 'Width'] or ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[SupportingReference = 'Height']">
							<Packaging>
								<xsl:if test="ASNSummary/TransportPackagingTotals/GrossVolume">
									<Dimension>
										<xsl:attribute name="type">
											<xsl:text>grossVolume</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="quantity">
											<xsl:value-of select="ASNSummary/TransportPackagingTotals/GrossVolume/Measurement/MeasurementValue"/>
										</xsl:attribute>
										<UnitOfMeasure>
											<xsl:value-of select="ASNSummary/TransportPackagingTotals/GrossVolume/Measurement/UnitOfMeasurement/UOMCoded"/>
										</UnitOfMeasure>
									</Dimension>
								</xsl:if>
								<xsl:if test="ASNSummary/TransportPackagingTotals/TotalGrossWeight">
									<Dimension>
										<xsl:attribute name="type">
											<xsl:text>grossVolume</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="quantity">
											<xsl:value-of select="ASNSummary/TransportPackagingTotals/TotalGrossWeight/Measurement/MeasurementValue"/>
										</xsl:attribute>
										<UnitOfMeasure>
											<xsl:value-of select="ASNSummary/TransportPackagingTotals/TotalGrossWeight/Measurement/UnitOfMeasurement/UOMCoded"/>
										</UnitOfMeasure>
									</Dimension>
								</xsl:if>
								<xsl:for-each select="ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'PackageNumber']">
									<xsl:choose>
										<xsl:when test="SupportingReference/Reference/RefNum = 'Length'">
											<Dimension>
												<xsl:attribute name="type">
													<xsl:text>length</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="quantity">
													<xsl:value-of select="PrimaryReference/Reference/RefNum"/>
												</xsl:attribute>
												<UnitOfMeasure>
													<xsl:value-of select="SupportingSubReference/Reference/RefNum"/>
												</UnitOfMeasure>
											</Dimension>
										</xsl:when>
										<xsl:when test="SupportingReference/Reference/RefNum = 'Width'">
											<Dimension>
												<xsl:attribute name="type">
													<xsl:text>width</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="quantity">
													<xsl:value-of select="PrimaryReference/Reference/RefNum"/>
												</xsl:attribute>
												<UnitOfMeasure>
													<xsl:value-of select="SupportingSubReference/Reference/RefNum"/>
												</UnitOfMeasure>
											</Dimension>
										</xsl:when>
										<xsl:when test="SupportingReference/Reference/RefNum = 'Height'">
											<Dimension>
												<xsl:attribute name="type">
													<xsl:text>height</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="quantity">
													<xsl:value-of select="PrimaryReference/Reference/RefNum"/>
												</xsl:attribute>
												<UnitOfMeasure>
													<xsl:value-of select="SupportingSubReference/Reference/RefNum"/>
												</UnitOfMeasure>
											</Dimension>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</Packaging>
						</xsl:if>
						<xsl:if test="ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'GovernmentReferenceNumber']/PrimaryReference/Reference/RefNum != ''">
							<IdReference>
								<xsl:attribute name="identifier">
									<xsl:value-of select="ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'GovernmentReferenceNumber']/PrimaryReference/Reference/RefNum"/>
								</xsl:attribute>
								<xsl:attribute name="domain">governmentNumber</xsl:attribute>
							</IdReference>
						</xsl:if>
						<xsl:if test="ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'SupplierReferenceNumber']/PrimaryReference/Reference/RefNum != ''">
							<IdReference>
								<xsl:attribute name="identifier">
									<xsl:value-of select="ASNHeader/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'SupplierReferenceNumber']/PrimaryReference/Reference/RefNum"/>
								</xsl:attribute>
								<xsl:attribute name="domain">supplierReference</xsl:attribute>
							</IdReference>
						</xsl:if>
					</ShipNoticeHeader>
					<ShipControl>
						<CarrierIdentifier domain=""/>
						<ShipmentIdentifier>
							<xsl:value-of select="ASNHeader/ASNReferences/TrackingInformation/TrackingNumber/Reference/RefNum"/>
						</ShipmentIdentifier>
					</ShipControl>
					<xsl:for-each select="ASNHeader/ASNOrderNumber">
						<xsl:variable name="orderNum" select="BuyerOrderNumber"/>
						<ShipNoticePortion>
							<OrderReference>
								<xsl:attribute name="orderID">
									<xsl:value-of select="$orderNum"/>
								</xsl:attribute>

								<xsl:if test="//ASNBaseItemDetail/LineItemOrderReference/PurchaseOrderReference/PurchaseOrderNumber/Reference[RefNum = $orderNum]/RefDate != ''">
									<xsl:attribute name="orderDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="//ASNBaseItemDetail/LineItemOrderReference/PurchaseOrderReference/PurchaseOrderNumber/Reference[RefNum = $orderNum]/RefDate"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>

								<DocumentReference payloadID=""/>
							</OrderReference>
							<!-- Cinthia: We need to make two loops since all Comments should be listed together before any ShipNoticeItem node -->
							<xsl:for-each select="../../ASNDetail/ListOfASNItemDetail/ASNItemDetail[ASNBaseItemDetail/LineItemOrderReference/PurchaseOrderReference/PurchaseOrderNumber/Reference/RefNum = $orderNum]">
								<xsl:if test="LineItemNote != '' or LineItemAttachments/ListOfAttachment/Attachment">
									<Comments>
										<xsl:value-of select="LineItemNote"/>
										<xsl:for-each select="LineItemAttachments/ListOfAttachment/Attachment">
											<Attachment>
												<URL>
													<xsl:attribute name="name">
														<xsl:value-of select="FileName"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="starts-with(AttachmentLocation, 'cid:')">
															<xsl:value-of select="AttachmentLocation"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="concat('cid:', AttachmentLocation)"/>
														</xsl:otherwise>
													</xsl:choose>
												</URL>
											</Attachment>
										</xsl:for-each>
									</Comments>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="../../ASNDetail/ListOfASNItemDetail/ASNItemDetail[ASNBaseItemDetail/LineItemOrderReference/PurchaseOrderReference/PurchaseOrderNumber/Reference/RefNum = $orderNum]">
								<ShipNoticeItem>
									<xsl:attribute name="lineNumber">
										<xsl:value-of select="ASNBaseItemDetail/LineItemNum/BuyerLineItemNum"/>
									</xsl:attribute>
									<xsl:if test="ASNBaseItemDetail/ParentItemNumber/LineItemNumberReference != ''">
										<xsl:attribute name="parentLineNumber">
											<xsl:value-of select="ASNBaseItemDetail/ParentItemNumber/LineItemNumberReference"/>
										</xsl:attribute>
									</xsl:if>

									<xsl:if test=".//AdvanceShipmentNotice/ASNDetail/ListOfASNItemDetail/ASNItemDetail/ASNBaseItemDetail/ParentItemNumber/LineItemNumberReference != '' and .//AdvanceShipmentNotice/ASNDetail/ListOfASNItemDetail/ASNItemDetail/ASNBaseItemDetail/ParentItemNumber/LineItemNumberReference">
										<xsl:call-template name="ItemTypeCalc">

											<xsl:with-param name="currentlinenum1" select="ASNBaseItemDetail/LineItemNum/BuyerLineItemNum"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:attribute name="quantity">
										<xsl:value-of select="ASNBaseItemDetail/TotalQuantity/Quantity/QuantityValue"/>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when test="ASNBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded = 'Other'">
											<UnitOfMeasure>
												<xsl:value-of select="ASNBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
											</UnitOfMeasure>
										</xsl:when>
										<xsl:otherwise>
											<UnitOfMeasure>
												<xsl:value-of select="ASNBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
											</UnitOfMeasure>
										</xsl:otherwise>
									</xsl:choose>
									<!-- CC-020062 -->
									<xsl:choose>
										<xsl:when test="ASNBaseItemDetail/ASNLineItemReferences/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'ProductionDate']/PrimaryReference/Reference/RefNum">
											<Batch>
												<xsl:attribute name="productionDate">
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="ASNBaseItemDetail/ASNLineItemReferences/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'ProductionDate']/PrimaryReference/Reference/RefDate"/>
													</xsl:call-template>
												</xsl:attribute>
											</Batch>
										</xsl:when>
										<xsl:when test="ASNBaseItemDetail/ASNLineItemReferences/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'ManufacturingDate']/PrimaryReference/Reference/RefNum">
											<Batch>
												<xsl:attribute name="productionDate">
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="ASNBaseItemDetail/ASNLineItemReferences/ASNReferences/OtherASNReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'ManufacturingDate']/PrimaryReference/Reference/RefDate"/>
													</xsl:call-template>
												</xsl:attribute>
											</Batch>
										</xsl:when>
									</xsl:choose>
									<!-- CC-020062 -->
								</ShipNoticeItem>
							</xsl:for-each>
						</ShipNoticePortion>
					</xsl:for-each>
				</ShipNoticeRequest>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template name="ItemTypeCalc">
		<xsl:param name="currentlinenum1"/>
		<xsl:variable name="isChild">
			<xsl:if test="//AdvanceShipmentNotice/ASNDetail/ListOfASNItemDetail/ASNItemDetail/ASNBaseItemDetail[ParentItemNumber/LineItemNumberReference = $currentlinenum1]">

				<xsl:text>true</xsl:text>
			</xsl:if>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="contains($isChild, 'true')">
				<xsl:attribute name="itemType">
					<xsl:text>composite</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="itemType">
					<xsl:text>item</xsl:text>
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
