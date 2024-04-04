<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	<!-- version of internal application release -->
	<!--  Local Testing -->
	<!--xsl:include href="Format_CXML_OAGIS_Common.xsl"/>	<xsl:variable name="Lookups" select="document('OAGIS_cXML_Lookup.xml')"/-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_OAGIS_9.2.xsl"/>
	<xsl:variable name="Lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_OAGIS_9.2.xml')"/>
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anCRFlag"/>
	<xsl:template match="/">
		<NotifyShipment>
			<xsl:attribute name="releaseID">9.2</xsl:attribute>
			<xsl:attribute name="systemEnvironmentCode">
				<xsl:choose>
					<xsl:when test="$anEnvName = 'PROD'">Production</xsl:when>
					<xsl:otherwise>Test</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="versionID">1.0</xsl:attribute>
			<ApplicationArea>
				<Sender>
					<LogicalID>
						<xsl:value-of select="$anAlternativeSender"/>
					</LogicalID>
					<ComponentID>
						<xsl:choose>
							<xsl:when test="$anCRFlag = 'Yes'">
								<xsl:text>CopyASN</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ASN</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</ComponentID>
					<TaskID>
						<xsl:text>NotifyShipment</xsl:text>
					</TaskID>
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
				<Notify>
					<ActionCriteria>
						<xsl:variable name="aexp"
							select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation"/>
						<xsl:choose>
							<xsl:when test="$aexp = 'new'">
								<ActionExpression actionCode="Add">new</ActionExpression>
							</xsl:when>
							<xsl:when test="$aexp = 'update'">
								<ActionExpression actionCode="Replace">update</ActionExpression>
							</xsl:when>
							<xsl:when test="$aexp = 'delete'">
								<ActionExpression actionCode="Delete">delete</ActionExpression>
							</xsl:when>
						</xsl:choose>
					</ActionCriteria>
				</Notify>
				<Shipment>
					<ShipmentHeader>
						<DocumentID>
							<ID>
								<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID"/>
							</ID>
						</DocumentID>
						<DocumentDateTime>
							<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate"/>
							<!-- should be changed using template-->
						</DocumentDateTime>
						<DocumentReference>
							<DocumentID>
								<xsl:attribute name="agencyRole">
									<xsl:text>invoiceID</xsl:text>
								</xsl:attribute>
								<ID>
									<xsl:value-of
										select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'InvoiceID']"
									/>
								</ID>
							</DocumentID>
						</DocumentReference>
						<xsl:if
							test="cXML/Request/ShipNoticeRequest/ShipControl/Extrinsic[@name = 'carrierShipmentID'] != ''">
							<Status>
								<Code>
									<xsl:attribute name="name">
										<xsl:text>shipmentInformationKey</xsl:text>
									</xsl:attribute>
									<xsl:value-of
										select="cXML/Request/ShipNoticeRequest/ShipControl/Extrinsic[@name = 'carrierShipmentID']"
									/>
								</Code>
							</Status>
						</xsl:if>
						<xsl:if
							test="cXML/Request/ShipNoticeRequest/ShipControl[CarrierIdentifier/@domain = 'billOfLading']/ShipmentIdentifier">
							<BillOfLadingReference>
								<DocumentID>
									<ID>
										<xsl:value-of
											select="cXML/Request/ShipNoticeRequest/ShipControl[CarrierIdentifier/@domain = 'billOfLading']/ShipmentIdentifier"
										/>
									</ID>
								</DocumentID>
								<xsl:variable name="packagecode"
									select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/PackgingCode"/>
								<Note>
									<xsl:attribute name="type">
										<xsl:text>PackCode</xsl:text>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when test="$packagecode = 'Carton'">
											<xsl:text>CTN</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>25</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</Note>
							</BillOfLadingReference>
						</xsl:if>
						<ActualShipDateTime>
							<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentDate"/>
						</ActualShipDateTime>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate != ''">
							<ScheduledDeliveryDateTime>
								<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate"
								/>
							</ScheduledDeliveryDateTime>
						</xsl:if>
						<xsl:if
							test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']">
							<GrossWeightMeasure>
								<xsl:attribute name="unitCode">
									<xsl:value-of
										select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']/UnitOfMeasure"
									/>
								</xsl:attribute>
								<xsl:value-of
									select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']/@quantity"
								/>
							</GrossWeightMeasure>
						</xsl:if>
						<xsl:choose>
							<xsl:when
								test="cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/Route/@method != ''">
								<TransportationMethodCode>
									<xsl:attribute name="name">
										<xsl:text>Type</xsl:text>
									</xsl:attribute>
									<xsl:value-of
										select="cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/Route/@method"
									/>
								</TransportationMethodCode>
							</xsl:when>
							<xsl:when test="cXML/Request/ShipNoticeRequest/ShipControl/Route/@method != ''">
								<TransportationMethodCode>
									<xsl:attribute name="name">
										<xsl:text>Type</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipControl/Route/@method"/>
								</TransportationMethodCode>
							</xsl:when>
						</xsl:choose>
						<xsl:if
							test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']">
							<ShipFromParty>
								<xsl:call-template name="CreateParty">
									<xsl:with-param name="PartyInfo"
										select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']"/>
									<xsl:with-param name="IDInfo"
										select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/@addressID"
									/>
								</xsl:call-template>
							</ShipFromParty>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'SCAC']">
							<CarrierParty>
								<xsl:call-template name="CreateParty">
									<xsl:with-param name="PartyInfo"
										select="cXML/Request/ShipNoticeRequest/ShipControl/CarrierIdentifier[@domain = 'SCAC']"/>
									<xsl:with-param name="IDInfo"
										select="cXML/Request/ShipNoticeRequest/ShipControl/CarrierIdentifier[@domain = 'SCAC']/@addressID"
									/>
								</xsl:call-template>
							</CarrierParty>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'soldTo']">
							<Party>
								<xsl:attribute name="role">Tenant</xsl:attribute>
								<PartyIDs>
									<ID>
										<xsl:value-of
											select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'soldTo']/Name/text()"
										/>
									</ID>
								</PartyIDs>
							</Party>
						</xsl:if>
						<xsl:choose>
							<xsl:when
								test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipTo']">
								<ShipToParty>
									<xsl:call-template name="CreateParty">
										<xsl:with-param name="PartyInfo"
											select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipTo']"/>
										<xsl:with-param name="IDInfo"
											select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipTo']/@addressID"
										/>
									</xsl:call-template>
								</ShipToParty>
							</xsl:when>
							<xsl:when
								test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Address">
								<ShipToParty>
									<xsl:call-template name="CreateParty">
										<xsl:with-param name="PartyInfo"
											select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Address"/>
										<xsl:with-param name="IDInfo"
											select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Address/@addressID"
										/>
									</xsl:call-template>
								</ShipToParty>
							</xsl:when>
						</xsl:choose>
						<ShipmentServiceLevelCode>
							<xsl:variable name="servicecode"
								select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/ServiceLevel/text()"/>
							<xsl:choose>
								<xsl:when test="$servicecode = 'Ground'">
									<xsl:text>00</xsl:text>
								</xsl:when>
								<xsl:when test="$servicecode = 'Overnight - 1day'">
									<xsl:text>01</xsl:text>
								</xsl:when>
								<xsl:when test="$servicecode = '2Day Air'">
									<xsl:text>02</xsl:text>
								</xsl:when>
							</xsl:choose>
						</ShipmentServiceLevelCode>
						<TransportationTerm>
							<IncotermsCode>
								<xsl:variable name="incoterm"
									select="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TransportTerms/@value)"/>
								<xsl:choose>
									<xsl:when
										test="$Lookups/Lookups/IncoTermsCodes/IncoTermsCode[CXMLCode = $incoterm]/OAGCode">
										<xsl:value-of
											select="normalize-space($Lookups/Lookups/IncoTermsCodes/IncoTermsCode[CXMLCode = $incoterm]/OAGCode)"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>ZZZ</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</IncotermsCode>
						</TransportationTerm>
						<xsl:if
							test="cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[domain = 'trackingNumber'] != ''">
							<TrackingID>
								<xsl:value-of
									select="cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[domain = 'trackingNumber']"
								/>
							</TrackingID>
						</xsl:if>
					</ShipmentHeader>
					<!-- Item Level-->
					<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem">
						<ShipmentItem>
							<CustomerItemID>
								<ID>
									<xsl:value-of select="ItemID/BuyerPartID"/>
								</ID>
							</CustomerItemID>
							<xsl:if test="Batch/SupplierBatchID != ''">
								<SerializedLot>
									<Lot>
										<LotIDs>
											<ID>
												<xsl:value-of select="Batch/SupplierBatchID"/>
											</ID>
										</LotIDs>
									</Lot>
								</SerializedLot>
							</xsl:if>
							<ShippedQuantity>
								<xsl:attribute name="unitCode">
									<xsl:value-of select="UnitOfMeasure"/>
								</xsl:attribute>
								<xsl:value-of select="@quantity"/>
							</ShippedQuantity>
							<PurchaseOrderReference>
								<DocumentID>
									<ID>
										<xsl:value-of select="../OrderReference/@orderID"/>
									</ID>
								</DocumentID>
								<LineNumber>
									<xsl:value-of select="@lineNumber"/>
								</LineNumber>
							</PurchaseOrderReference>
							<DocumentReference>
								<LineNumber>
									<xsl:value-of select="@shipNoticeLineNumber"/>
								</LineNumber>
							</DocumentReference>
						</ShipmentItem>
					</xsl:for-each>
				</Shipment>
			</DataArea>
		</NotifyShipment>
	</xsl:template>
</xsl:stylesheet>
