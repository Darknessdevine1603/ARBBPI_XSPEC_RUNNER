<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:include href="FORMAT_OAGIS_9.2_cXML_0000.xsl"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="cXMLAttachments"/>
	<xsl:param name="attachSeparator" select="'\|'"/>

	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>

	<xsl:template match="NotifyShipment">
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
							<xsl:value-of select="DataArea/Shipment/ShipmentHeader/DocumentID/ID"/>
						</xsl:attribute>
						<xsl:variable name="documentid" select="concat(DataArea/Shipment/ShipmentHeader/DocumentID/ID, '')"/>
						<xsl:attribute name="noticeDate">
							<xsl:value-of select="DataArea/Shipment/ShipmentHeader/DocumentDateTime"/>
						</xsl:attribute>
						<xsl:attribute name="operation">
							<xsl:choose>
								<xsl:when test="DataArea/Notify/ActionCriteria/ActionExpression/@actionCode = 'Delete'">
									<xsl:text>delete</xsl:text>
								</xsl:when>
								<xsl:when test="DataArea/Notify/ActionCriteria/ActionExpression/@actionCode = 'Replace'">
									<xsl:text>update</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>new</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="DataArea/Shipment/ShipmentHeader/ScheduledDeliveryDateTime != ''">
							<xsl:attribute name="shipmentType">
								<xsl:text>planned</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="deliveryDate">

								<xsl:value-of select="DataArea/Shipment/ShipmentHeader/ScheduledDeliveryDateTime"/>
							</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="shipmentDate">

							<xsl:value-of select="DataArea/Shipment/ShipmentHeader/ActualShipDateTime"/>
						</xsl:attribute>

						<ServiceLevel>
							<xsl:attribute name="xml:lang"> </xsl:attribute>
							<xsl:value-of select="DataArea/Shipment/ShipmentHeader/ShipmentServiceLevelCode"/>
						</ServiceLevel>



						<xsl:for-each select="DataArea/Shipment/ShipmentHeader/ShipFromParty">
							<xsl:call-template name="createParty">
								<xsl:with-param name="partyInfo" select="."/>
								<xsl:with-param name="role" select="'shipFrom'"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select="DataArea/Shipment/ShipmentHeader/ShipToParty">
							<xsl:call-template name="createParty">
								<xsl:with-param name="partyInfo" select="."/>
								<xsl:with-param name="role" select="'shipTo'"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:if test="$cXMLAttachments != ''">
							<Comments>
								<xsl:variable name="tokenizedAttachments" select="tokenize($cXMLAttachments, $attachSeparator)"/>
								<xsl:for-each select="$tokenizedAttachments">
									<xsl:if test="normalize-space(.) != ''">
										<Attachment>
											<URL>
												<xsl:value-of select="."/>
											</URL>
										</Attachment>
									</xsl:if>
								</xsl:for-each>
							</Comments>
						</xsl:if>
						<xsl:if test="DataArea/Shipment/ShipmentHeader/FreightTermCode or DataArea/Shipment/ShipmentHeader/TransportationTerm/IncotermsCode">
							<TermsOfDelivery>
								<TermsOfDeliveryCode value="DeliveryCondition"> </TermsOfDeliveryCode>
								<ShippingPaymentMethod value="Other">
									<xsl:value-of select="DataArea/Shipment/ShipmentHeader/FreightTermCode"/>
								</ShippingPaymentMethod>
								<TransportTerms value="Other">
									<xsl:value-of select="DataArea/Shipment/ShipmentHeader/TransportationTerm/IncotermsCode"/>
								</TransportTerms>
							</TermsOfDelivery>
						</xsl:if>
						<Packaging>
							<Dimension>
								<xsl:attribute name="quantity">
									<xsl:value-of select="DataArea/Shipment/ShipmentHeader/GrossWeightMeasure"/>
								</xsl:attribute>
								<xsl:attribute name="type">grossWeight</xsl:attribute>
								<UnitOfMeasure>
									<xsl:value-of select="DataArea/Shipment/ShipmentHeader/GrossWeightMeasure/@type"/>
								</UnitOfMeasure>
							</Dimension>
						</Packaging>
					</ShipNoticeHeader>
					<ShipControl>
						<CarrierIdentifier domain="SCAC">
							<xsl:value-of select="DataArea/Shipment/ShipmentHeader/CarrierParty/PartyIDs/ID"/>
						</CarrierIdentifier>
						<xsl:if test="DataArea/Shipment/ShipmentHeader/CarrierParty/Name">
							<CarrierIdentifier domain="companyName">
								<xsl:value-of select="DataArea/Shipment/ShipmentHeader/CarrierParty/Name"/>
							</CarrierIdentifier>
						</xsl:if>
						<ShipmentIdentifier domain="billOfLading">
							<xsl:value-of select="DataArea/Shipment/ShipmentHeader/BillOfLadingReference/DocumentID/ID"/>
						</ShipmentIdentifier>
						<ShipmentIdentifier domain="trackingNumber">
							<xsl:value-of select="DataArea/Shipment/ShipmentHeader/TrackingID"/>
						</ShipmentIdentifier>
						<xsl:variable name="rCode" select="DataArea/Shipment/ShipmentHeader/TransportationMethodCode"/>
						<xsl:if test="$rCode = 'A' or $rCode = 'AE' or $rCode = 'E' or $rCode = 'TM' or $rCode = 'D' or $rCode = 'M' or $rCode = 'LT' or $rCode = 'TL' or $rCode = 'U' or $rCode = 'S'">
							<TransportInformation>
								<Route>
									<xsl:attribute name="method">
										<xsl:choose>
											<xsl:when test="$rCode = 'A' or $rCode = 'AE' or $rCode = 'E' or $rCode = 'TM'">
												<xsl:text>air</xsl:text>
											</xsl:when>

											<xsl:when test="$rCode = 'M' or $rCode = 'D' or $rCode = 'LT' or $rCode = 'TL' or $rCode = 'U'">
												<xsl:text>motor</xsl:text>
											</xsl:when>
											<xsl:when test="$rCode = 'S'">
												<xsl:text>ship</xsl:text>
											</xsl:when>
										</xsl:choose>
									</xsl:attribute>
								</Route>
							</TransportInformation>
						</xsl:if>
						<xsl:if test="DataArea/Shipment/ShipmentHeader/Status/Code[@name = 'shipmentInformationKey'] != ''">
							<Extrinsic>
								<xsl:attribute name="name">
									<xsl:text>carrierShipmentID</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="DataArea/Shipment/ShipmentHeader/Status/Code[@name = 'shipmentInformationKey']"/>
							</Extrinsic>
						</xsl:if>
					</ShipControl>
					<xsl:for-each select="DataArea/Shipment/ShipmentItem/PurchaseOrderReference/DocumentID/ID[not(. = following::ID)]">
						<xsl:variable name="curOrder" select="."/>

						<ShipNoticePortion>
							<OrderReference>
								<xsl:attribute name="orderID">
									<xsl:value-of select="$curOrder"/>
								</xsl:attribute>

								<DocumentReference payloadID=""/>
							</OrderReference>

							<xsl:for-each select="//DataArea/Shipment/ShipmentItem[PurchaseOrderReference/DocumentID/ID = $curOrder]">
								<ShipNoticeItem>
									<xsl:attribute name="shipNoticeLineNumber">
										<xsl:value-of select="DocumentReference/LineNumber"/>
									</xsl:attribute>
									<xsl:attribute name="lineNumber">
										<xsl:value-of select="PurchaseOrderReference/LineNumber"/>
									</xsl:attribute>
									<xsl:attribute name="quantity">
										<xsl:value-of select="ShippedQuantity"/>
									</xsl:attribute>

									<ItemID>
										<SupplierPartID/>
										<BuyerPartID>
											<xsl:value-of select="CustomerItemID/ID"/>
										</BuyerPartID>
									</ItemID>
									<ShipNoticeItemDetail>
										<UnitOfMeasure>
											<xsl:value-of select="ShippedQuantity/@unitCode"/>
										</UnitOfMeasure>
									</ShipNoticeItemDetail>
									<UnitOfMeasure>
										<xsl:value-of select="ShippedQuantity/@unitCode"/>
									</UnitOfMeasure>
									<xsl:if test="SerializedLot/Lot/LotIDs/ID != ''">
										<Batch>
											<SupplierBatchID>
												<xsl:value-of select="SerializedLot/Lot/LotIDs/ID"/>
											</SupplierBatchID>
										</Batch>
									</xsl:if>
								</ShipNoticeItem>
							</xsl:for-each>
						</ShipNoticePortion>
					</xsl:for-each>
				</ShipNoticeRequest>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template name="createParty">
		<xsl:param name="role"/>
		<xsl:param name="partyInfo"/>

		<Contact>
			<xsl:attribute name="role">
				<xsl:value-of select="$role"/>
			</xsl:attribute>
			<xsl:attribute name="addressID">
				<xsl:value-of select="$partyInfo/PartyIDs/ID"/>
			</xsl:attribute>
			<Name>
				<xsl:attribute name="xml:lang"> </xsl:attribute>
				<xsl:value-of select="$partyInfo/Name"/>
			</Name>
			<xsl:if test="$partyInfo/Location/Address/LineOne != '' and $partyInfo/Location/Address/CityName != '' and $partyInfo/Location/Address/CountryCode != ''">
				<PostalAddress>
					<xsl:if test="$partyInfo/Location/Address/CareOfName != ''">
						<DeliverTo>
							<xsl:value-of select="$partyInfo/Location/Address/CareOfName"/>
						</DeliverTo>
					</xsl:if>


					<Street>
						<xsl:value-of select="$partyInfo/Location/Address/LineOne"/>
					</Street>

					<xsl:if test="$partyInfo/Location/Address/LineTwo != ''">
						<Street>
							<xsl:value-of select="$partyInfo/Location/Address/LineTwo"/>
						</Street>
					</xsl:if>
					<xsl:if test="$partyInfo/Location/Address/LineThree">
						<Street>
							<xsl:value-of select="$partyInfo/Location/Address/LineThree"/>
						</Street>
					</xsl:if>


					<City>
						<xsl:value-of select="$partyInfo/Location/Address/CityName"/>
					</City>
					<State>
						<xsl:value-of select="$partyInfo/Location/Address/CountrySubDivisionCode"/>
					</State>
					<PostalCode>
						<xsl:value-of select="$partyInfo/Location/Address/PostalCode"/>
					</PostalCode>
					<Country>
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$partyInfo/Location/Address/CountryCode"/>
						</xsl:attribute>
					</Country>
				</PostalAddress>
			</xsl:if>

			<xsl:for-each select="$partyInfo/Contact">
				<xsl:if test="@type = 'EMAIL'">
					<Email name="">

						<xsl:value-of select="Communication/URI"/>
					</Email>
				</xsl:if>
				<xsl:if test="@type = 'Phone'">
					<Phone>
						<xsl:attribute name="name"> </xsl:attribute>

						<TelephoneNumber>
							<CountryCode>
								<xsl:attribute name="isoCountryCode"> </xsl:attribute>
								<xsl:value-of select="Communication/CountryDialing"/>
							</CountryCode>
							<AreaOrCityCode>
								<xsl:value-of select="Communication/AreaDialing"/>
							</AreaOrCityCode>
							<Number>

								<xsl:value-of select="Communication/DialNumber"/>
							</Number>
							<Extension/>
						</TelephoneNumber>
					</Phone>
				</xsl:if>

				<xsl:if test="@type = 'FAX'">
					<Fax name="">

						<TelephoneNumber>
							<CountryCode>
								<xsl:attribute name="isoCountryCode"> </xsl:attribute>
								<xsl:value-of select="Communication/CountryDialing"/>
							</CountryCode>
							<AreaOrCityCode>
								<xsl:value-of select="Communication/AreaDialing"/>
							</AreaOrCityCode>
							<Number>

								<xsl:value-of select="Communication/DialNumber"/>
							</Number>
							<Extension/>
						</TelephoneNumber>
					</Fax>
				</xsl:if>
			</xsl:for-each>
		</Contact>
	</xsl:template>
</xsl:stylesheet>
