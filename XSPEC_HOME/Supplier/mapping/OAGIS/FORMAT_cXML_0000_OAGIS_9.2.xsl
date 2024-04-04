<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="$date"/>
	</xsl:template>
	<xsl:template name="CreateParty">
		<xsl:param name="PartyInfo"/>
		<xsl:param name="IDInfo"/>
		<PartyIDs>
		<ID>
			<xsl:value-of select="$IDInfo"/>
		</ID>
		</PartyIDs>
		<xsl:if test="$PartyInfo/Name != ''">
			<Name>
				<xsl:value-of select="$PartyInfo/Name"/>
			</Name>
		</xsl:if>
		<xsl:if test="$PartyInfo/PostalAddress/Street or $PartyInfo/Name != ''">
			<Location>
				<xsl:if test="$PartyInfo/Name != ''">
					<Name>
						<xsl:value-of select="$PartyInfo/Name"/>
					</Name>
				</xsl:if>
				<xsl:if test="$PartyInfo/PostalAddress/Street">
					<Address type="Physical">
						<LineOne>
							<xsl:value-of select="$PartyInfo/PostalAddress/Street"/>
						</LineOne>
						<CityName>
							<xsl:value-of select="$PartyInfo/PostalAddress/City"/>
						</CityName>
						<xsl:if test="$PartyInfo/PostalAddress/State != ''">
							<CountrySubDivisionCode>
								<xsl:value-of select="$PartyInfo/PostalAddress/State"/>
							</CountrySubDivisionCode>
						</xsl:if>
						<CountryCode>
							<xsl:value-of select="$PartyInfo/PostalAddress/Country/@isoCountryCode"/>
						</CountryCode>
						<PostalCode>
							<xsl:value-of select="$PartyInfo/PostalAddress/PostalCode"/>
						</PostalCode>
					</Address>
				</xsl:if>
			</Location>
		</xsl:if>
		<xsl:if test="$PartyInfo/Email != ''">
			<Contact>
				<xsl:attribute name="type">EMAIL</xsl:attribute>
				<Communication>
					<URI>
						<xsl:value-of select="$PartyInfo/Email"/>
					</URI>
				</Communication>
			</Contact>
		</xsl:if>
		<xsl:if test="$PartyInfo/Phone/TelephoneNumber/Number != ''">
			<Contact>
				<xsl:attribute name="type">Phone</xsl:attribute>
				<Communication>
					<CountryDialing>
						<xsl:value-of select="$PartyInfo/Phone/TelephoneNumber/CountryCode"/>
					</CountryDialing>
					<AreaDialing>
						<xsl:value-of select="$PartyInfo/Phone/TelephoneNumber/AreaOrCityCode"/>
					</AreaDialing>
					<DialNumber>
						<xsl:value-of select="$PartyInfo/Phone/TelephoneNumber/Number"/>
					</DialNumber>
				</Communication>
			</Contact>
		</xsl:if>
		<xsl:if test="$PartyInfo/Fax/TelephoneNumber/Number != ''">
			<Contact>
				<xsl:attribute name="type">FAX</xsl:attribute>
				<Communication>
					<CountryDialing>
						<xsl:value-of select="$PartyInfo/Fax/TelephoneNumber/CountryCode"/>
					</CountryDialing>
					<AreaDialing>
						<xsl:value-of select="$PartyInfo/Fax/TelephoneNumber/AreaOrCityCode"/>
					</AreaDialing>
					<DialNumber>
						<xsl:value-of select="$PartyInfo/Fax/TelephoneNumber/Number"/>
					</DialNumber>
				</Communication>
			</Contact>
		</xsl:if>
	</xsl:template>
	<xsl:template name="createlineitemPO">
		<xsl:param name="item"/>
		<LineNumber>
			<xsl:value-of select="$item/@lineNumber"/>
		</LineNumber>
		<!-- IG-3591 IG-3682 start -->
		<xsl:for-each select="$item/ItemDetail/Description[normalize-space(.) != '']">
			<xsl:element name="Description">
				<xsl:if test="normalize-space(./@xml:lang) != ''">
					<xsl:attribute name="languageID" select="./@xml:lang"/>
				</xsl:if>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:element>
		</xsl:for-each>
		<xsl:for-each select="$item/BlanketItemDetail/Description[normalize-space(.) != '']">
			<xsl:element name="Description">
				<xsl:if test="normalize-space(./@xml:lang) != ''">
					<xsl:attribute name="languageID" select="./@xml:lang"/>
				</xsl:if>
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:element>
		</xsl:for-each>
		<!-- IG-3591 IG-3682 end -->
		<DocumentReference>
			<xsl:if test="$item/ItemOutIndustry/@planningType != ''">
				<!-- IG-4810 : CG - New logic to support planning type codes -->
				<xsl:variable name="cxmlPlanningType" select="$item/ItemOutIndustry/@planningType"/>
				<xsl:variable name="oagisPlanningType" select="$Lookups/Lookups/PlanningTypes/PlanningType[CXMLCode = $cxmlPlanningType]/OAGISCode"/>
				<xsl:if test="$oagisPlanningType != ''">
					<AlternateDocumentID>
						<xsl:attribute name="agencyRole">BuildType</xsl:attribute>
						<ID>
							<xsl:attribute name="schemeID">
								<xsl:value-of select="$Lookups/Lookups/PlanningTypes/PlanningType[CXMLCode = $cxmlPlanningType]/OAGISSchemeID"/>
							</xsl:attribute>
							<xsl:value-of select="$oagisPlanningType"/>
						</ID>
					</AlternateDocumentID>
				</xsl:if>
			</xsl:if>
			<xsl:if test="normalize-space($item/@requestedDeliveryDate) != ''">
				<Status>
					<Code listID="002" name="DateType">DeliveryDate</Code>
					<EffectiveDateTime>
						<xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="$item/@requestedDeliveryDate"/>
						</xsl:call-template>
					</EffectiveDateTime>
				</Status>
			</xsl:if>
			<!-- IG-3591 IG-3682 start -->
			<xsl:if test="normalize-space($item/@itemType) != ''">
				<Status>
					<Code name="ItemType">
						<xsl:value-of select="normalize-space($item/@itemType)"/>
					</Code>
				</Status>
			</xsl:if>
			<xsl:if test="lower-case(normalize-space($item/@requiresServiceEntry)) = 'yes'">
				<Status>
					<Code name="RequiresServiceEntry">yes</Code>
				</Status>
			</xsl:if>
			<xsl:if test="normalize-space($item/@parentLineNumber) != ''">
				<Status>
					<Code name="ParentLineNumber">
						<xsl:value-of select="normalize-space($item/@parentLineNumber)"/>
					</Code>
				</Status>
			</xsl:if>
			<!-- IG-3591 IG-3682 end -->
			<xsl:if test="$item/@requestedShipmentDate != ''">
				<Status>
					<Code listID="010" name="DateType">ShipDate</Code>
					<EffectiveDateTime>
						<xsl:call-template name="formatDate">
							<xsl:with-param name="date" select="$item/@requestedShipmentDate"/>
						</xsl:call-template>
					</EffectiveDateTime>
				</Status>
			</xsl:if>
			<xsl:if test="$item/ItemDetail/Extrinsic[@name = 'isItemChanged'] != ''">
				<Status>
					<Code name="LineItemChangeFlag">
						<xsl:value-of select="$item/ItemDetail/Extrinsic[@name = 'isItemChanged']"/>
					</Code>
					<Description type="ReasonForChange">
						<xsl:value-of select="$item/ItemDetail/Extrinsic[@name = 'reasonForChange']"/>
					</Description>
				</Status>
			</xsl:if>
			<xsl:for-each select="$item/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic">
				<Status>
					<xsl:if test="lower-case(@domain) != 'potype'">
						<Code name="ConfigurableLineIndicatorFlag">
							<xsl:value-of select="../$item/ItemDetail/Extrinsic[@name = 'isConfigurableItem']"/>
						</Code>
					</xsl:if>
					<Description>
						<xsl:attribute name="type">
							<xsl:choose>
								<xsl:when test="lower-case(@domain) = 'engraving'">
									<xsl:value-of select="'engraving'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@domain"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:value-of select="@value"/>
					</Description>
				</Status>
			</xsl:for-each>
			<ItemIDs>
				<xsl:if test="$item/ItemID/BuyerPartID != ''">
					<ItemID agencyRole="MSPartNumber">
						<ID schemeID="BP">
							<xsl:value-of select="$item/ItemID/BuyerPartID"/>
						</ID>
						<RevisionID>NA</RevisionID>
					</ItemID>
				</xsl:if>
				<xsl:if test="$item/ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID != ''">
					<ItemID agencyRole="UPC">
						<ID schemeID="UP">
							<xsl:value-of select="$item/ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID"/>
						</ID>
						<RevisionID>NA</RevisionID>
					</ItemID>
				</xsl:if>
				<xsl:if test="$item/ItemID/SupplierPartID != ''">
					<ItemID agencyRole="VendorPartNumber">
						<ID schemeID="PI">
							<xsl:value-of select="$item/ItemID/SupplierPartID"/>
						</ID>
						<RevisionID>NA</RevisionID>
					</ItemID>
				</xsl:if>
				<xsl:if test="$item/ItemID/IdReference[@domain = 'custSKU']/@identifier != ''">
					<ItemID agencyRole="CustomerPartNumber">
						<ID schemeID="PI">
							<xsl:value-of select="$item/ItemID/IdReference[@domain = 'custSKU']/@identifier"/>
						</ID>
						<RevisionID>NA</RevisionID>
					</ItemID>
				</xsl:if>
			</ItemIDs>
			<xsl:for-each select="$item/ItemOutIndustry/ReferenceDocumentInfo">
				<SalesOrderReference>
					<DocumentID>
						<xsl:attribute name="agencyRole">
							<xsl:value-of select="DocumentInfo/@documentType"/>
						</xsl:attribute>
						<ID>
							<xsl:value-of select="DocumentInfo/@documentID"/>
						</ID>
					</DocumentID>
					<Description type="OrderType">
						<xsl:value-of select="Extrinsic[@name = 'customerOrderNo']"/>
					</Description>
					<xsl:if test="DateInfo[@type = 'expectedDeliveryDate']/@date != ''">
						<Status>
							<Code name="DateType">ExpectedDeliveryDate</Code>
							<EffectiveDateTime>
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="DateInfo[@type = 'expectedDeliveryDate']/@date"/>
								</xsl:call-template>
							</EffectiveDateTime>
						</Status>
					</xsl:if>
					<xsl:if test="DateInfo/Extrinsic[@name = 'customerDeliveryDate'] != ''">
						<Status>
							<Code name="DateType">CustomerDeliveryDate</Code>
							<EffectiveDateTime>
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="DateInfo/Extrinsic[@name = 'customerDeliveryDate']"/>
								</xsl:call-template>
							</EffectiveDateTime>
						</Status>
					</xsl:if>
					<xsl:if test="DateInfo[@type = 'expectedShipmentDate']/@date != ''">
						<Status>
							<Code name="DateType">ExpectedShipmentDate</Code>
							<EffectiveDateTime>
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="DateInfo[@type = 'expectedShipmentDate']/@date"/>
								</xsl:call-template>
							</EffectiveDateTime>
						</Status>
					</xsl:if>
					<xsl:if test="DateInfo/Extrinsic[@name = 'expectedRSD'] != ''">
						<Status>
							<Code name="DateType">ExpectedRSD</Code>
							<EffectiveDateTime>
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="DateInfo/Extrinsic[@name = 'expectedRSD']"/>
								</xsl:call-template>
							</EffectiveDateTime>
						</Status>
					</xsl:if>
					<xsl:if test="DateInfo/Extrinsic[@name = 'calculatedDeliveryDate'] != ''">
						<Status>
							<Code name="DateType">CalculatedDeliveryDate</Code>
							<EffectiveDateTime>
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="DateInfo/Extrinsic[@name = 'calculatedDeliveryDate']"/>
								</xsl:call-template>
							</EffectiveDateTime>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'tenantCountry'] != ''">
						<Status>
							<Code name="tenantCountry">
								<xsl:value-of select="Extrinsic[@name = 'tenantCountry']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'tenantLocale'] != ''">
						<Status>
							<Code name="tenantLocale">
								<xsl:value-of select="Extrinsic[@name = 'tenantLocale']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'tenantID'] != ''">
						<Status>
							<Code name="tenantID">
								<xsl:value-of select="Extrinsic[@name = 'tenantID']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'launchFlag'] != ''">
						<Status>
							<Code name="launchFlag">
								<xsl:value-of select="Extrinsic[@name = 'launchFlag']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'salesCurrency'] != ''">
						<Status>
							<Code name="salesCurrency">
								<xsl:value-of select="Extrinsic[@name = 'salesCurrency']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'deliveryNoteNumber'] != ''">
						<Status>
							<Code name="DeliveryCompletionIndicator">
								<xsl:value-of select="Extrinsic[@name = 'deliveryNoteNumber']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'productHierarchy'] != ''">
						<Status>
							<Code name="ProductHierarchy">
								<xsl:value-of select="Extrinsic[@name = 'productHierarchy']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'productDivision'] != ''">
						<Status>
							<Code name="ProductDivision">
								<xsl:value-of select="Extrinsic[@name = 'productDivision']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'productName'] != ''">
						<Status>
							<Code name="ProductName">
								<xsl:value-of select="Extrinsic[@name = 'productName']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'productGrouping'] != ''">
						<Status>
							<Code name="ProductGrouping">
								<xsl:value-of select="Extrinsic[@name = 'productGrouping']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'productModule'] != ''">
						<Status>
							<Code name="ProductModule">
								<xsl:value-of select="Extrinsic[@name = 'productModule']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'productVersion'] != ''">
						<Status>
							<Code name="ProductVersion">
								<xsl:value-of select="Extrinsic[@name = 'productVersion']"/>
							</Code>
						</Status>
					</xsl:if>
					<xsl:if test="@lineNumber != ''">
						<LineNumber>
							<xsl:value-of select="@lineNumber"/>
						</LineNumber>
					</xsl:if>
					<xsl:if test="Extrinsic[@name = 'scheduleRefNo'] != ''">
						<ScheduleLineNumber>
							<xsl:value-of select="Extrinsic[@name = 'scheduleRefNo']"/>
						</ScheduleLineNumber>
					</xsl:if>
				</SalesOrderReference>
			</xsl:for-each>
			<OperationReference>
				<xsl:if test="$item/ShipTo/IdReference[@domain = 'storageLocation']/@identifier != ''">
					<Status>
						<Code name="storageLocation">
							<xsl:value-of select="$item/ShipTo/IdReference[@domain = 'storageLocation']/@identifier"/>
						</Code>
					</Status>
				</xsl:if>
				<xsl:if test="$item/ShipTo/IdReference[@domain = 'loadingPoint']/@identifier != ''">
					<Status>
						<Code name="loadingPoint">
							<xsl:value-of select="$item/ShipTo/IdReference[@domain = 'loadingPoint']/@identifier"/>
						</Code>
					</Status>
				</xsl:if>
				<xsl:if test="$item/ShipTo/Address/@addressID != ''">
					<Status>
						<Code name="SAPPlant">
							<xsl:value-of select="$item/ShipTo/Address/@addressID"/>
						</Code>
					</Status>
				</xsl:if>
			</OperationReference>
		</DocumentReference>
		<!-- IG-3591 IG-3682 start -->
		<Status>
			<Code>
				<xsl:attribute name="listID">
					<xsl:choose>
						<xsl:when test="$item/BlanketItemDetail/UnitOfMeasure != ''">
							<xsl:value-of select="$item/BlanketItemDetail/UnitOfMeasure"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$item/ItemDetail/UnitOfMeasure"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="name">UOM</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$item/BlanketItemDetail/UnitOfMeasure != ''">
						<xsl:value-of select="$item/BlanketItemDetail/UnitOfMeasure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$item/ItemDetail/UnitOfMeasure"/>
					</xsl:otherwise>
				</xsl:choose>
			</Code>
		</Status>
		<!-- IG-3591 IG-3682 end -->
		<xsl:if test="$item/Batch/SupplierBatchID != ''">
			<SerializedLot>
				<Lot>
					<LotIDs>
						<ID>
							<xsl:value-of select="$item/Batch/SupplierBatchID"/>
						</ID>
					</LotIDs>
				</Lot>
			</SerializedLot>
		</xsl:if>
		<!-- IG-3591 IG-3682 start -->
		<xsl:choose>
			<xsl:when test="$item/ItemDetail/UnitPrice/Money != ''">
				<UnitPrice>
					<Amount>
						<xsl:attribute name="currencyID">
							<xsl:value-of select="$item/ItemDetail/UnitPrice/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="$item/ItemDetail/UnitPrice/Money"/>
					</Amount>
					<PerQuantity>
						<xsl:choose>
							<xsl:when test="$item/ItemDetail/PriceBasisQuantity/@quantity != ''">
								<xsl:attribute name="unitCode" select="$item/ItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
								<xsl:value-of select="$item/ItemDetail/PriceBasisQuantity/@quantity"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</PerQuantity>
					<Code name="PriceType">UnitPrice</Code>
				</UnitPrice>
			</xsl:when>
			<xsl:when test="$item/BlanketItemDetail/UnitPrice/Money != ''">
				<UnitPrice>
					<Amount>
						<xsl:attribute name="currencyID">
							<xsl:value-of select="$item/BlanketItemDetail/UnitPrice/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="$item/BlanketItemDetail/UnitPrice/Money"/>
					</Amount>
					<PerQuantity>
						<xsl:choose>
							<xsl:when test="$item/BlanketItemDetail/PriceBasisQuantity/@quantity != ''">
								<xsl:attribute name="unitCode" select="$item/BlanketItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
								<xsl:value-of select="$item/BlanketItemDetail/PriceBasisQuantity/@quantity"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</PerQuantity>
					<Code name="PriceType">UnitPrice</Code>
				</UnitPrice>
			</xsl:when>
		</xsl:choose>
		<!-- IG-3591 IG-3682 end -->
		<TransportationTerm>
			<IncotermsCode>
				<!--xsl:attribute name="name">						<xsl:value-of select="$item/TermsOfDelivery/TransportTerms"/>					</xsl:attribute-->
				<xsl:value-of select="//OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'incoTerm']"/>
			</IncotermsCode>
			<PlaceOfOwnershipTransferLocation>
				<Name>
					<xsl:value-of select="//OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'incoTermDesc']"/>
				</Name>
			</PlaceOfOwnershipTransferLocation>
			<FreightTermCode name="ShipmentTerms">
				<xsl:value-of select="$item/TermsOfDelivery/ShippingPaymentMethod"/>
			</FreightTermCode>
			<UserArea>
				<xsl:if test="$item/ShipTo/CarrierIdentifier != ''">
					<CarrierParty>
						<PartyIDs>
							<ID>
								<xsl:value-of select="$item/ShipTo/CarrierIdentifier"/>
							</ID>
						</PartyIDs>
					</CarrierParty>
				</xsl:if>
				<xsl:if test="$item/ItemDetail/Extrinsic[@name = 'servicePerformedCode'] != ''">
					<Code name="ServiceLevelCode">
						<xsl:value-of select="$item/ItemDetail/Extrinsic[@name = 'servicePerformedCode']"/>
					</Code>
				</xsl:if>
				<xsl:if test="$item/ItemDetail/Extrinsic[@name = 'shippingNoteNumber'] != ''">
					<Code name="HandlingCode">
						<xsl:value-of select="$item/ItemDetail/Extrinsic[@name = 'shippingNoteNumber']"/>
					</Code>
				</xsl:if>
				<xsl:if test="$item/ItemDetail/Extrinsic[@name = 'transportRoute'] != ''">
					<Code name="TransportMethod">
						<xsl:value-of select="$item/ItemDetail/Extrinsic[@name = 'transportRoute']"/>
					</Code>
				</xsl:if>
			</UserArea>
		</TransportationTerm>
		<xsl:if test="$item/ShipTo/TransportInformation/ShippingInstructions/Description != ''">
			<ShippingInstructions>
				<xsl:value-of select="$item/ShipTo/TransportInformation/ShippingInstructions/Description"/>
			</ShippingInstructions>
		</xsl:if>
		<OpenQuantity unitCode="Each">
			<xsl:value-of select="$item/@quantity"/>
		</OpenQuantity>
		<xsl:for-each select="$item/ScheduleLine/SubcontractingComponent">
			<PurchaseOrderSubLine>
				<LineNumber>
					<xsl:value-of select="ComponentID"/>
				</LineNumber>
				<Description>
					<xsl:value-of select="Description"/>
				</Description>
				<DocumentReference>
					<xsl:attribute name="type">
						<xsl:text>requirementDate</xsl:text>
					</xsl:attribute>
					<DocumentDateTime>
						<xsl:value-of select="@requirementDate"/>
					</DocumentDateTime>
				</DocumentReference>
				<Item>
					<ItemID>
						<ID>
							<xsl:value-of select="Product/BuyerPartID"/>
						</ID>
					</ItemID>
				</Item>
				<Quantity>
					<xsl:value-of select="@quantity"/>
				</Quantity>
				<UserArea>
					<Status>
						<Code>
							<xsl:attribute name="listID">
								<xsl:value-of select="UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:attribute name="name">UOM</xsl:attribute>
							<xsl:value-of select="UnitOfMeasure"/>
						</Code>
					</Status>
				</UserArea>
			</PurchaseOrderSubLine>
		</xsl:for-each>
		<!-- IG-3591 IG-3682 start -->
		<xsl:if test="normalize-space($item/BlanketItemDetail/MinQuantity) != '' or normalize-space($item/BlanketItemDetail/MaxQuantity) != '' or normalize-space($item/ControlKeys/OCInstruction/@value) != '' or normalize-space($item/ControlKeys/ASNInstruction/@value) != '' or normalize-space($item/ControlKeys/InvoiceInstruction/@value) != ''">
			<UserArea>
				<xsl:if test="normalize-space($item/BlanketItemDetail/MinQuantity) != '' or normalize-space($item/BlanketItemDetail/MaxQuantity) != ''">
					<Quantity>
						<xsl:if test="normalize-space($item/BlanketItemDetail/MinQuantity) != ''">
							<MinQuantity>
								<xsl:value-of select="normalize-space($item/BlanketItemDetail/MinQuantity)"/>
							</MinQuantity>
						</xsl:if>
						<xsl:if test="normalize-space($item/BlanketItemDetail/MaxQuantity) != ''">
							<MaxQuantity>
								<xsl:value-of select="normalize-space($item/BlanketItemDetail/MaxQuantity)"/>
							</MaxQuantity>
						</xsl:if>
					</Quantity>
				</xsl:if>
				<xsl:if test="normalize-space($item/ControlKeys/OCInstruction/@value) != '' or normalize-space($item/ControlKeys/ASNInstruction/@value) != '' or normalize-space($item/ControlKeys/InvoiceInstruction/@value) != ''">
					<ControlKeys>
						<xsl:if test="normalize-space($item/ControlKeys/OCInstruction/@value) != ''">
							<OCInstruction>
								<xsl:attribute name="type">
									<xsl:value-of select="normalize-space($item/ControlKeys/OCInstruction/@value)"/>
								</xsl:attribute>
								<xsl:if test="normalize-space($item/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance/@type) != '' and normalize-space($item/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance/@limit) != ''">
									<LowerTolerances>
										<TimeTolerances>
											<xsl:attribute name="type">
												<xsl:value-of select="normalize-space($item/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance/@type)"/>
											</xsl:attribute>
											<xsl:value-of select="normalize-space($item/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance/@limit)"/>
										</TimeTolerances>
									</LowerTolerances>
								</xsl:if>
								<xsl:if test="normalize-space($item/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance/@type) != '' and normalize-space($item/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance/@limit) != ''">
									<UpperTolerances>
										<TimeTolerances>
											<xsl:attribute name="type">
												<xsl:value-of select="normalize-space($item/ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance/@type)"/>
											</xsl:attribute>
											<xsl:value-of select="normalize-space($item/ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance/@limit)"/>
										</TimeTolerances>
									</UpperTolerances>
								</xsl:if>
							</OCInstruction>
						</xsl:if>
						<xsl:if test="normalize-space($item/ControlKeys/ASNInstruction/@value) != ''">
							<ASNInstruction>
								<xsl:attribute name="type">
									<xsl:value-of select="normalize-space($item/ControlKeys/ASNInstruction/@value)"/>
								</xsl:attribute>
							</ASNInstruction>
						</xsl:if>
						<xsl:if test="normalize-space($item/ControlKeys/InvoiceInstruction/@value) != ''">
							<InvoiceInstruction>
								<xsl:attribute name="type">
									<xsl:value-of select="normalize-space($item/ControlKeys/InvoiceInstruction/@value)"/>
								</xsl:attribute>
							</InvoiceInstruction>
						</xsl:if>
					</ControlKeys>
				</xsl:if>
			</UserArea>
		</xsl:if>
		<!-- IG-3591 IG-3682 end -->
	</xsl:template>
</xsl:stylesheet>
