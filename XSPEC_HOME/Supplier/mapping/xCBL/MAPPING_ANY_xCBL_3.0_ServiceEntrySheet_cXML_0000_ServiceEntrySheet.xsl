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
			<Request>
				<xsl:choose>
					<xsl:when test="$anEnvName = 'PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<ServiceEntryRequest>
					<ServiceEntryRequestHeader>
						<xsl:attribute name="serviceEntryDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="input" select="OrderResponseHeader/OrderResponseIssueDate"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="serviceEntryID">
							<xsl:value-of select="OrderResponseHeader/OrderResponseNumber/SellerOrderResponseNumber"/>
						</xsl:attribute>
						<PartnerContact>
							<Contact role="soldTo">
								<xsl:attribute name="addressID">
									<xsl:value-of select="OrderResponseHeader/BuyerParty/Party/PartyID/Identifier/Ident"/>
								</xsl:attribute>
								<xsl:call-template name="CreateContact">
									<xsl:with-param name="PartyInfo" select="OrderResponseHeader/BuyerParty"/>
								</xsl:call-template>
								<xsl:if test="OrderResponseHeader/BuyerParty/Party/OrderContact">
									<xsl:call-template name="PhoneFaxEmail">
										<xsl:with-param name="phone" select="OrderResponseHeader/BuyerParty/Party/OrderContact/Contact/ListOfContactNumber/ContactNumber[ContactNumberTypeCoded = 'TelephoneNumber']/ContactNumberValue"/>
										<xsl:with-param name="email" select="OrderResponseHeader/BuyerParty/Party/OrderContact/Contact/ListOfContactNumber/ContactNumber[ContactNumberTypeCoded = 'EmailAddress']/ContactNumberValue"/>
										<xsl:with-param name="fax" select="OrderResponseHeader/BuyerParty/Party/OrderContact/Contact/ListOfContactNumber/ContactNumber[ContactNumberTypeCoded = 'FaxNumber']/ContactNumberValue"/>
									</xsl:call-template>
								</xsl:if>
							</Contact>
						</PartnerContact>
						<PartnerContact>
							<Contact role="supplierrole">
								<xsl:attribute name="addressID">
									<xsl:value-of select="OrderResponseHeader/SellerParty/Party/PartyID/Identifier/Ident"/>
								</xsl:attribute>
								<xsl:call-template name="CreateContact">
									<xsl:with-param name="PartyInfo" select="OrderResponseHeader/SellerParty"/>
								</xsl:call-template>
							</Contact>
						</PartnerContact>
						<xsl:if test="OrderResponseHeader/OrderResponseHeaderNote != '' or OrderResponseHeader/OrderHeaderChanges/OrderHeader/OrderHeaderAttachments/ListOfAttachment/Attachment">
							<Comments>
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="(//Language/LanguageCoded)[1] != ''">
											<xsl:value-of select="(//Language/LanguageCoded)[1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>en</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="OrderResponseHeader//OrderResponseHeaderNote"/>
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

						<!-- CC-020061 -->
						<xsl:if test="OrderResponseHeader/OrderResponseNumber/SellerOrderResponseNumber != ''">
							<IdReference>
								<xsl:attribute name="identifier">
									<xsl:value-of select="OrderResponseHeader/OrderResponseNumber/SellerOrderResponseNumber"/>
								</xsl:attribute>
								<xsl:attribute name="domain">supplierReference</xsl:attribute>
							</IdReference>
						</xsl:if>

						<xsl:if test="OrderResponseHeader/SellerParty/Party/ListOfIdentifier/Identifier[AgencyCodedOther = 'RAMSESID']/Ident">
							<Extrinsic>
								<xsl:attribute name="name">VendorIDNo</xsl:attribute>
								<xsl:value-of select="OrderResponseHeader/SellerParty/Party/ListOfIdentifier/Identifier[AgencyCodedOther = 'RAMSESID']/Ident"/>
							</Extrinsic>
						</xsl:if>
						<xsl:if test="OrderResponseHeader/SellerParty/Party/PartyID/Identifier/Ident">
							<Extrinsic>
								<xsl:attribute name="name">vendorIdNumber</xsl:attribute>
								<xsl:value-of select="OrderResponseHeader/SellerParty/Party/PartyID/Identifier/Ident"/>
							</Extrinsic>
						</xsl:if>
						<xsl:if test="OrderResponseHeader/SellerParty/Party/ListOfIdentifier/Identifier[AgencyCodedOther = 'ERPCode']/Ident">
							<Extrinsic>
								<xsl:attribute name="name">SiteID</xsl:attribute>
								<xsl:value-of select="OrderResponseHeader/SellerParty/Party/ListOfIdentifier/Identifier[AgencyCodedOther = 'ERPCode']/Ident"/>
							</Extrinsic>
						</xsl:if>
						<Extrinsic>
							<xsl:attribute name="name">contractNo</xsl:attribute>
							<xsl:value-of select="OrderResponseHeader/OriginalOrderHeader/OrderHeader/OrderReferences/ContractReferences/ListOfContract/Contract/ContractID/Identifier/Ident"/>
						</Extrinsic>
						<!--<xsl:if test="$QNLegacyFlag">
						<Extrinsic name="AribaNetwork.LegacyDocument">
							<xsl:text>true</xsl:text>
						</Extrinsic>
					</xsl:if> -->
					</ServiceEntryRequestHeader>
					<ServiceEntryOrder>
						<ServiceEntryOrderInfo>
							<OrderIDInfo>
								<xsl:variable name="orderDate">
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
								</xsl:variable>

								<xsl:attribute name="orderDate">
									<xsl:value-of select="$orderDate"/>
								</xsl:attribute>
								<xsl:attribute name="orderID">
									<xsl:value-of select="OrderResponseHeader/OriginalOrderHeader/OrderHeader/OrderNumber/BuyerOrderNumber"/>
								</xsl:attribute>
							</OrderIDInfo>
						</ServiceEntryOrderInfo>
						<xsl:for-each select="OrderResponseDetail/ListOfOrderResponseItemDetail/OrderResponseItemDetail[ItemDetailChanges/ItemDetail/BaseItemDetail/ParentItemNumber/LineItemNumberReference != '' or OriginalItemDetail/ItemDetail/BaseItemDetail/ParentItemNumber/LineItemNumberReference != '']">
							<ServiceEntryItem>
								<xsl:choose>
									<xsl:when test="ItemDetailChanges">

										<xsl:call-template name="createSESDetailItem">
											<xsl:with-param name="item" select="ItemDetailChanges/ItemDetail"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="OriginalItemDetail">

										<xsl:call-template name="createSESDetailItem">
											<xsl:with-param name="item" select="OriginalItemDetail/ItemDetail"> </xsl:with-param>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</ServiceEntryItem>
						</xsl:for-each>
					</ServiceEntryOrder>
					<ServiceEntrySummary>
						<SubtotalAmount>
							<Money>
								<xsl:attribute name="currency">
									<xsl:value-of select="OrderResponseSummary/RevisedOrderSummary/OrderSummary/TotalAmount/MonetaryValue/Currency/CurrencyCoded"/>
								</xsl:attribute>
								<xsl:value-of select="OrderResponseSummary/RevisedOrderSummary/OrderSummary/TotalAmount/MonetaryValue/MonetaryAmount"/>
							</Money>
						</SubtotalAmount>
					</ServiceEntrySummary>
				</ServiceEntryRequest>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template name="createSESDetailItem">
		<xsl:param name="item"/>
		<xsl:attribute name="serviceLineNumber">
			<xsl:value-of select="$item/BaseItemDetail/LineItemNum/BuyerLineItemNum"/>
		</xsl:attribute>
		<xsl:attribute name="quantity">
			<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/QuantityValue"/>
		</xsl:attribute>
		<xsl:variable name="getType">
			<xsl:choose>
				<xsl:when test="$item/BaseItemDetail/LineItemType[LineItemTypeCoded = 'Other']/LineItemTypeCodedOther = 'Services' or $item/BaseItemDetail/LineItemType/LineItemTypeCoded = 'Services'">
					<xsl:text>service</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>material</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:attribute name="type">
			<xsl:value-of select="$getType"/>
		</xsl:attribute>
		<ItemReference>
			<xsl:attribute name="lineNumber">
				<xsl:value-of select="$item/BaseItemDetail/LineItemNum/BuyerLineItemNum"/>
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
			<Description>
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="/OrderResponseHeader/OriginalOrderHeader/OrderHeader/OrderLanguage/Language/LanguageCoded"/>
				</xsl:attribute>
				<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/ItemDescription"/>
			</Description>
		</ItemReference>
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
		<UnitPrice>
			<Money>
				<xsl:attribute name="currency">
					<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/UnitPrice/Currency/CurrencyCoded"/>
				</xsl:attribute>
				<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/UnitPrice/UnitPriceValue"/>
			</Money>
		</UnitPrice>
		<SubtotalAmount>
			<Money>
				<xsl:attribute name="currency">
					<xsl:value-of select="$item/PricingDetail/TotalValue/MonetaryValue/Currency/CurrencyCoded"/>
				</xsl:attribute>
				<xsl:value-of select="$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount"/>
			</Money>
		</SubtotalAmount>
		<Comments>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="/OrderResponseHeader/OriginalOrderHeader/OrderHeader/OrderLanguage/Language/LanguageCoded"/>
			</xsl:attribute>
			<xsl:value-of select="$item/LineItemNote"/>
		</Comments>
		<Extrinsic>
			<xsl:attribute name="name">CustomerPartNo</xsl:attribute>
			<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID"/>
		</Extrinsic>
	</xsl:template>
</xsl:stylesheet>
