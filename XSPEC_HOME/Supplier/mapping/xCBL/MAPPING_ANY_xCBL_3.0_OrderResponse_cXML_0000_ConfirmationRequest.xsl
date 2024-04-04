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
	<xsl:template match="OrderResponse">

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
			<xsl:variable name="ortype" select="OrderResponseHeader/OrderResponseDocTypeCoded"/>
			<Request>
				<xsl:choose>
					<xsl:when test="$anEnvName = 'PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<ConfirmationRequest>
					<ConfirmationHeader>
						<xsl:attribute name="noticeDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="input" select="OrderResponseHeader/OrderResponseIssueDate"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:variable name="type">
							<xsl:choose>
								<xsl:when test="OrderResponseHeader/ResponseType/ResponseTypeCoded = 'Accepted'">
									<xsl:text>accept</xsl:text>
								</xsl:when>
								<xsl:when test="OrderResponseHeader/ResponseType/ResponseTypeCoded = 'NotAccepted'">
									<xsl:text>reject</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>detail</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="type">
							<xsl:value-of select="$type"/>
						</xsl:attribute>

						<xsl:variable name="operation">
							<!--xsl:choose>
								<xsl:when test="$lastOCPayloadID!=''">
									<xsl:text>update</xsl:text>
								</xsl:when>
								<xsl:otherwise-->
							<xsl:text>new</xsl:text>
							<!--/xsl:otherwise>
							</xsl:choose-->
						</xsl:variable>
						<xsl:attribute name="operation">
							<xsl:value-of select="$operation"/>
						</xsl:attribute>
						<xsl:attribute name="confirmID">
							<xsl:value-of select="OrderResponseHeader/OrderResponseNumber/SellerOrderResponseNumber"/>
						</xsl:attribute>
						<Total>
							<Money>
								<xsl:attribute name="currency">
									<xsl:value-of select="OrderResponseSummary/RevisedOrderSummary/OrderSummary/TotalAmount/MonetaryValue/Currency/CurrencyCoded"/>
								</xsl:attribute>
								<xsl:value-of select="OrderResponseSummary/RevisedOrderSummary/OrderSummary/TotalAmount/MonetaryValue/MonetaryAmount"/>
							</Money>
						</Total>
						<xsl:if test="OrderResponseHeader/OrderResponseHeaderNote != '' or OrderResponseHeader/OrderHeaderChanges/OrderHeader/OrderHeaderAttachments/ListOfAttachment/Attachment">
							<Comments>
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="//Language/LanguageCoded">
											<xsl:value-of select="(//Language/LanguageCoded)[1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>en</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="OrderResponseHeader/OrderResponseHeaderNote"/>
								<xsl:for-each select="OrderResponseHeader/OrderHeaderChanges/OrderHeader/OrderHeaderAttachments/ListOfAttachment/Attachment">
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

						<xsl:if test="OrderResponseHeader/OrderResponseNumber/SellerOrderResponseNumber">
							<IdReference>
								<xsl:attribute name="domain">
									<xsl:value-of select="'supplierReference'"/>
								</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:value-of select="OrderResponseHeader/OrderResponseNumber/SellerOrderResponseNumber"/>
								</xsl:attribute>
							</IdReference>
						</xsl:if>
					</ConfirmationHeader>
					<OrderReference>
						<xsl:variable name="orderDate">
							<xsl:choose>
								<xsl:when test="OrderResponseHeader/ChangeOrderHeader/ChangeOrderIssueDate and OrderResponseHeader/ChangeOrderHeader/ChangeOrderIssueDate != ''">
									<xsl:call-template name="formatDate">
										<xsl:with-param name="input" select="OrderResponseHeader/ChangeOrderHeader/ChangeOrderIssueDate"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="OrderResponseHeader//OriginalOrderHeader/OrderHeader/OrderIssueDate and OrderResponseHeader//OriginalOrderHeader/OrderHeader/OrderIssueDate != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="input" select="OrderResponseHeader/OriginalOrderHeader/OrderHeader/OrderIssueDate"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="OrderResponseHeader//OrderHeaderChanges/OrderHeader/OrderIssueDate and OrderResponseHeader/OrderHeaderChanges/OrderHeader/OrderIssueDate != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="input" select="OrderResponseHeader/OrderHeaderChanges/OrderHeader/OrderIssueDate"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:attribute name="orderDate">
							<xsl:value-of select="$orderDate"/>
						</xsl:attribute>
						<xsl:attribute name="orderID">
							<xsl:value-of select="OrderResponseHeader/OrderReference/Reference/RefNum"/>
						</xsl:attribute>
						<DocumentReference>
							<xsl:attribute name="payloadID"> </xsl:attribute>
						</DocumentReference>
					</OrderReference>

					<xsl:variable name="sendItemTypeVal">
						<xsl:if test="//BaseItemDetail/ParentItemNumber/LineItemNumberReference != '' and //BaseItemDetail/ParentItemNumber/LineItemNumberReference">
							<xsl:text>true</xsl:text>
						</xsl:if>
					</xsl:variable>

					<xsl:if test="(OrderResponseHeader/ResponseType/ResponseTypeCoded != 'NotAccepted')">
						<xsl:for-each select="OrderResponseDetail/ListOfOrderResponseItemDetail/OrderResponseItemDetail">
							<xsl:choose>
								<xsl:when test="/OrderResponse/OrderResponseHeader//OrderHeader/OrderType/OrderTypeCoded = 'SupplyOrServiceOrder' and (ItemDetailChanges/ItemDetail/BaseItemDetail/ParentItemNumber or OriginalItemDetail/ItemDetail/BaseItemDetail/ParentItemNumber or ChangeOrderItemDetail/ItemDetail/BaseItemDetail/ParentItemNumber)"> </xsl:when>
								<xsl:otherwise>
									<ConfirmationItem>
										<xsl:variable name="LRCtype">
											<xsl:choose>
												<xsl:when test="ItemDetailResponseCoded = 'ItemAccepted'">

													<xsl:text>accept</xsl:text>
												</xsl:when>
												<xsl:when test="ItemDetailResponseCoded = 'ItemRejected'">
													<xsl:text>reject</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>detail</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>

										<xsl:choose>
											<xsl:when test="ItemDetailChanges">

												<xsl:call-template name="createORDetailItem">
													<xsl:with-param name="item" select="ItemDetailChanges/ItemDetail"/>
													<xsl:with-param name="LRCtype" select="$LRCtype"/>
													<xsl:with-param name="sendItemTypeVal" select="$sendItemTypeVal"> </xsl:with-param>
													<xsl:with-param name="OCQuantityDiff">
														<xsl:call-template name="calculateQty">
															<xsl:with-param name="OriginalQuantity" select="concat(OriginalItemDetail/ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
															<xsl:with-param name="OriginalChangeQuantity" select="concat(ChangeOrderItemDetail//ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
															<xsl:with-param name="QuantityChange" select="concat(ItemDetailChanges/ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="OriginalItemDetail">

												<xsl:call-template name="createORDetailItem">
													<xsl:with-param name="item" select="OriginalItemDetail/ItemDetail"> </xsl:with-param>
													<xsl:with-param name="LRCtype" select="$LRCtype"/>
													<xsl:with-param name="sendItemTypeVal" select="$sendItemTypeVal"/>
													<xsl:with-param name="OCQuantityDiff">
														<xsl:call-template name="calculateQty">
															<xsl:with-param name="OriginalQuantity" select="concat(OriginalItemDetail/ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
															<xsl:with-param name="OriginalChangeQuantity" select="concat(ChangeOrderItemDetail//ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
															<xsl:with-param name="QuantityChange" select="concat(ItemDetailChanges/ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="ChangeOrderItemDetail">

												<xsl:call-template name="createORDetailItem">
													<xsl:with-param name="item" select="ChangeOrderItemDetail/OriginalItemDetail/ItemDetail"> </xsl:with-param>
													<xsl:with-param name="LRCtype" select="$LRCtype"/>
													<xsl:with-param name="sendItemTypeVal" select="$sendItemTypeVal"/>
													<xsl:with-param name="OCQuantityDiff">
														<xsl:call-template name="calculateQty">
															<xsl:with-param name="OriginalQuantity" select="concat(OriginalItemDetail/ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
															<xsl:with-param name="OriginalChangeQuantity" select="concat(ChangeOrderItemDetail//ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
															<xsl:with-param name="QuantityChange" select="concat(ItemDetailChanges/ItemDetail/BaseItemDetail/TotalQuantity/Quantity/QuantityValue, '')"/>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</ConfirmationItem>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:if>
				</ConfirmationRequest>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template name="calculateQty">
		<xsl:param name="OriginalQuantity"/>
		<xsl:param name="QuantityChange"/>
		<xsl:param name="OriginalChangeQuantity"/>
		<xsl:choose>
			<xsl:when test="$OriginalQuantity != '' and $QuantityChange != ''">
				<xsl:value-of select="(number($OriginalQuantity) - number($QuantityChange))"/>
			</xsl:when>
			<xsl:when test="$OriginalChangeQuantity != '' and $QuantityChange != ''">
				<xsl:value-of select="(number($OriginalChangeQuantity) - number($QuantityChange))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createORDetailItem">
		<xsl:param name="item"/>
		<xsl:param name="LRCtype"/>
		<xsl:param name="OCQuantityDiff"/>
		<xsl:param name="sendItemTypeVal"/>
		<xsl:attribute name="lineNumber">
			<xsl:value-of select="$item/BaseItemDetail/LineItemNum/BuyerLineItemNum"/>
		</xsl:attribute>
		<xsl:attribute name="quantity">
			<xsl:choose>
				<xsl:when test="$OCQuantityDiff != '' and $OCQuantityDiff &lt; 0">

					<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/QuantityValue"/>
				</xsl:when>
				<xsl:otherwise>

					<xsl:value-of select="($item/BaseItemDetail/TotalQuantity/Quantity/QuantityValue + $OCQuantityDiff)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$item/BaseItemDetail/ParentItemNumber/LineItemNumberReference != ''">
			<xsl:attribute name="parentLineNumber">
				<xsl:value-of select="$item/BaseItemDetail/ParentItemNumber/LineItemNumberReference"/>
			</xsl:attribute>
		</xsl:if>

		<xsl:if test="$sendItemTypeVal and $sendItemTypeVal != ''">
			<xsl:call-template name="getORItemType">

				<xsl:with-param name="currentlinenum1" select="$item/BaseItemDetail/LineItemNum/BuyerLineItemNum"/>
			</xsl:call-template>
		</xsl:if>
		<UnitOfMeasure>
			<xsl:choose>
				<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded != 'Other'">
					<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
				</xsl:otherwise>
			</xsl:choose>
		</UnitOfMeasure>
		<ConfirmationStatus>
			<xsl:attribute name="type">
				<xsl:value-of select="$LRCtype"/>
			</xsl:attribute>
			<xsl:attribute name="quantity">
				<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/QuantityValue"/>
			</xsl:attribute>
			<xsl:if test="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate and $LRCtype != 'reject'">
				<xsl:attribute name="deliveryDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<UnitOfMeasure>
				<xsl:choose>
					<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded != 'Other'">
						<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
					</xsl:otherwise>
				</xsl:choose>
			</UnitOfMeasure>
			<xsl:if test="$LRCtype = 'detail'">
				<ItemIn>
					<xsl:attribute name="quantity">
						<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/QuantityValue"/>
					</xsl:attribute>
					<ItemID>
						<SupplierPartID>
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID"/>
						</SupplierPartID>
						<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != ''">
							<SupplierPartAuxiliaryID>
								<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt"/>
							</SupplierPartAuxiliaryID>
						</xsl:if>
					</ItemID>
					<ItemDetail>
						<UnitPrice>
							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="$item/PricingDetail/ListOfPrice/Price/UnitPrice/Currency/CurrencyCoded"/>
								<xsl:with-param name="value" select="$item/PricingDetail/ListOfPrice/Price/UnitPrice/UnitPriceValue"/>
							</xsl:call-template>
						</UnitPrice>
						<Description>
							<xsl:attribute name="xml:lang">
								<xsl:value-of select="(//Language/LanguageCoded)[1]"/>
							</xsl:attribute>
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/ItemDescription"/>
						</Description>
						<UnitOfMeasure>
							<xsl:choose>
								<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded != 'Other'">
									<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
								</xsl:otherwise>
							</xsl:choose>
						</UnitOfMeasure>
						<Classification>
							<xsl:attribute name="domain">UNSPSC</xsl:attribute>
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers//CommodityCode/Identifier[Agency/AgencyCoded = 'Other' and Agency/AgencyCodedOther = 'UNSPSC']/Ident"/>
						</Classification>
					</ItemDetail>
				</ItemIn>
			</xsl:if>
			<xsl:if test="$item/LineItemNote != ''">
				<Comments>
					<xsl:attribute name="xml:lang">
						<xsl:choose>
							<xsl:when test="//Language/LanguageCoded">
								<xsl:value-of select="(//Language/LanguageCoded)[1]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>en</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="$item/LineItemNote"/>
				</Comments>
			</xsl:if>
		</ConfirmationStatus>
		<xsl:if test="$OCQuantityDiff != '' and $OCQuantityDiff &gt; 0">
			<ConfirmationStatus>
				<xsl:attribute name="type">
					<xsl:text>unknown</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="quantity">
					<xsl:value-of select="$OCQuantityDiff"/>
				</xsl:attribute>
				<UnitOfMeasure>
					<xsl:choose>
						<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded != 'Other'">
							<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
						</xsl:otherwise>
					</xsl:choose>
				</UnitOfMeasure>
			</ConfirmationStatus>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getORItemType">
		<xsl:param name="currentlinenum1"/>
		<xsl:variable name="isChild">
			<xsl:if test="//BaseItemDetail[ParentItemNumber/LineItemNumberReference = $currentlinenum1]">

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
