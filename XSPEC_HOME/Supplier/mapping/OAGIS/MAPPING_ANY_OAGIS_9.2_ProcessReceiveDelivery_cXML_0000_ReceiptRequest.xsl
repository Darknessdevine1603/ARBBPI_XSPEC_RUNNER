<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>

	<xsl:template match="/">
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
				<ReceiptRequest>
					<ReceiptRequestHeader>
						<xsl:attribute name="receiptID">
							<xsl:value-of select="ProcessReceiveDelivery/ApplicationArea/BODID"/>
						</xsl:attribute>
						<xsl:attribute name="receiptDate">
							<xsl:value-of select="ProcessReceiveDelivery/DataArea/ReceiveDelivery/ReceiveDeliveryHeader/ReceivedDateTime"/>
						</xsl:attribute>
						<xsl:attribute name="operation">new</xsl:attribute>
					</ReceiptRequestHeader>
					<xsl:for-each select="ProcessReceiveDelivery/DataArea/ReceiveDelivery/ReceiveDeliveryUnit/ReceiveDeliveryUnitItem/PurchaseOrderReference/DocumentID/ID[not(. = following::ID)]">
						<ReceiptOrder>
							<ReceiptOrderInfo>
								<OrderReference>
									<xsl:attribute name="orderID">
										<xsl:value-of select="."/>
									</xsl:attribute>
									<DocumentReference>
										<xsl:attribute name="payloadID"/>
									</DocumentReference>
								</OrderReference>
							</ReceiptOrderInfo>
							<xsl:variable name="currentOrder" select="."/>
							<xsl:for-each select="//ReceiveDeliveryUnitItem[PurchaseOrderReference/DocumentID/ID = $currentOrder]">
								<ReceiptItem>
									<!-- IG-17574 : Change receiptLineNumber to map a unique number, this is linked to ReceiveDeliveryUnitItem position -->
									<xsl:attribute name="receiptLineNumber">
										<xsl:number level="any"/>
									</xsl:attribute>
									<xsl:attribute name="quantity">
										<xsl:value-of select="Quantity"/>
									</xsl:attribute>
									<xsl:attribute name="type">
										<xsl:text>received</xsl:text>
									</xsl:attribute>
									<ReceiptItemReference>
										<xsl:attribute name="lineNumber">
											<xsl:value-of select="PurchaseOrderReference/LineNumber"/>
										</xsl:attribute>
										<ItemID>
											<SupplierPartID> </SupplierPartID>
											<BuyerPartID>
												<xsl:value-of select="ItemID/ID"/>
											</BuyerPartID>
										</ItemID>
										<ManufacturerPartID> </ManufacturerPartID>
										<ManufacturerName> </ManufacturerName>
										<ShipNoticeReference>
											<xsl:if test="DocumentReference[@type = 'Shipment']/DocumentID[@agencyRole = 'LoadId']/ID != ''">
												<xsl:attribute name="shipNoticeID">
													<xsl:value-of select="DocumentReference[@type = 'Shipment']/DocumentID[@agencyRole = 'LoadId']/ID"/>
												</xsl:attribute>
											</xsl:if>
											<DocumentReference payloadID=""/>
										</ShipNoticeReference>
									</ReceiptItemReference>
									<UnitRate>
										<Money>
											<xsl:attribute name="currency">
												<xsl:value-of select="UserArea/Status/Code[@name = 'Currency']"/>
											</xsl:attribute>
											<xsl:text>0</xsl:text>
										</Money>
										<UnitOfMeasure>
											<xsl:value-of select="Quantity/@unitCode"/>
										</UnitOfMeasure>
									</UnitRate>
									<ReceivedAmount>
										<Money>
											<xsl:attribute name="currency">
												<xsl:value-of select="UserArea/Status/Code[@name = 'Currency']"/>
											</xsl:attribute>
											<xsl:text>0</xsl:text>
										</Money>
									</ReceivedAmount>
								</ReceiptItem>
							</xsl:for-each>
						</ReceiptOrder>
					</xsl:for-each>
					<Total>
						<Money>
							<xsl:attribute name="currency">
								<xsl:value-of select="ProcessReceiveDelivery/DataArea/ReceiveDelivery/ReceiveDeliveryHeader/UserArea/Status/Code[@name = 'Currency']"/>
							</xsl:attribute>
							<xsl:text>0</xsl:text>
						</Money>
					</Total>
				</ReceiptRequest>
			</Request>
		</cXML>
	</xsl:template>
</xsl:stylesheet>
