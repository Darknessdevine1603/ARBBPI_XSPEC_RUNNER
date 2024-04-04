<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	
	<!-- Use this template to format dates into valid xCBL formats.  Expects Input dates in yyyy-mm-dd format -->
	<xsl:template name="formatDate">
		<xsl:param name="DocDate"/>
		<xsl:choose>
			<xsl:when test="$DocDate">
				<xsl:variable name="Year" select="substring($DocDate,1,4)"/>
				<xsl:variable name="Month" select="substring($DocDate,6,2)"/>
				<xsl:variable name="Day" select="substring($DocDate,9,2)"/>
				<xsl:variable name="Time1" select="substring($DocDate,11)"/>
				<xsl:variable name="Time">
					<xsl:choose>
						<xsl:when test="string-length($Time1)&gt;0">
							<xsl:value-of select="$Time1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>T00:00:00</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="concat($Year,$Month, $Day, $Time)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="toLower">
		<xsl:param name="inString"/>
		<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:value-of select="translate($inString,$ucletters,$lcletters)"/>
	</xsl:template>

	<xsl:template name="createParty">
		<!--Common-->
		<xsl:param name="TPID"/>
		<xsl:param name="Party"/>
		<xsl:param name="vatID"/>
		<xsl:param name="Ident"/>
		<xsl:param name="PartyLang"/>
		<xsl:param name="PartyType"/>
		<xsl:param name="isOSR"/>
		<!-- CC-018746 -->
		<xsl:param name="BuyerSystemID"/>
		<xsl:param name="SellerSystemID"/>
		<xsl:param name="TaxID"/>
		<Party>
			<xsl:call-template name="createInnerParty">
				<xsl:with-param name="TPID" select="$TPID"/>
				<xsl:with-param name="Party" select="$Party"/>
				<xsl:with-param name="PartyType" select="$PartyType"/>
				<xsl:with-param name="vatID" select="$vatID"/>
				<xsl:with-param name="Ident" select="$Ident"/>
				<xsl:with-param name="PartyLang" select="$PartyLang"/>
				<xsl:with-param name="BuyerSystemID" select="$BuyerSystemID"/>
				<xsl:with-param name="SellerSystemID" select="$SellerSystemID"/>
				<xsl:with-param name="TaxID" select="$TaxID"/>
			</xsl:call-template>
		</Party>
	</xsl:template>

	<xsl:template name="createInnerParty">
		<!--Common-->
		<xsl:param name="TPID"/>
		<xsl:param name="Party"/>
		<xsl:param name="vatID"/>
		<xsl:param name="Ident"/>
		<xsl:param name="PartyLang"/>
		<xsl:param name="PartyType"/>
		<xsl:param name="BuyerSystemID"/>
		<xsl:param name="SellerSystemID"/>
		<xsl:param name="TaxID"/>
		<PartyID>
			<Identifier>
				<Agency>
					<AgencyCoded>Other</AgencyCoded>
					<AgencyCodedOther>QuadremMarketPlace</AgencyCodedOther>
					<xsl:if test="$vatID">
						<AgencyDescription>
							<xsl:value-of select="$vatID"/>
						</AgencyDescription>
					</xsl:if>
					<xsl:if test="$TPID!=''">
						<CodeListIdentifierCoded>
							<xsl:text>Other</xsl:text>
						</CodeListIdentifierCoded>
						<CodeListIdentifierCodedOther>
							<xsl:value-of select="$TPID"/>
						</CodeListIdentifierCodedOther>
					</xsl:if>
				</Agency>
				<Ident>
					<xsl:value-of select="$Party/@addressID"/>
				</Ident>
			</Identifier>
		</PartyID>
		<xsl:if test="$Party/@addressID!='' or $SellerSystemID or $BuyerSystemID or $TaxID">
			<ListOfIdentifier>
				<xsl:if test="$TaxID">
					<Identifier>
						<Agency>
							<AgencyCoded>Other</AgencyCoded>
							<AgencyCodedOther>TAX</AgencyCodedOther>
						</Agency>
						<Ident>
							<xsl:value-of select="$TaxID"/>
						</Ident>
					</Identifier>
				</xsl:if>
				<xsl:if test="$Party/@addressID">
					<Identifier>
						<Agency>
							<AgencyCoded>Other</AgencyCoded>
							<AgencyCodedOther>AssignedByBuyerOrBuyersAgent</AgencyCodedOther>
						</Agency>
						<Ident>
							<xsl:value-of select="$Party/@addressID"/>
						</Ident>
					</Identifier>
				</xsl:if>
				<xsl:if test="$BuyerSystemID and $BuyerSystemID!=''">
					<Identifier>
						<Agency>
							<AgencyCoded>Other</AgencyCoded>
							<AgencyCodedOther>ANSystemID</AgencyCodedOther>
						</Agency>
						<Ident>
							<xsl:value-of select="$BuyerSystemID"/>
						</Ident>
					</Identifier>
				</xsl:if>
				<xsl:if test="$SellerSystemID and $SellerSystemID!=''">
					<Identifier>
						<Agency>
							<AgencyCoded>Other</AgencyCoded>
							<AgencyCodedOther>ANSystemID</AgencyCodedOther>
						</Agency>
						<Ident>
							<xsl:value-of select="$SellerSystemID"/>
						</Ident>
					</Identifier>
				</xsl:if>
			</ListOfIdentifier>
		</xsl:if>

		<xsl:call-template name="createNameAddress">
			<xsl:with-param name="Party" select="$Party"/>
		</xsl:call-template>
		<xsl:if test="$Party/Phone/TelephoneNumber/Number!='' or $Party/Fax/TelephoneNumber/Number!='' or $Party/Email!=''">
			<OrderContact>
				<xsl:call-template name="contactInfo">
					<xsl:with-param name="Party" select="$Party"/>
				</xsl:call-template>
			</OrderContact>
		</xsl:if>
		<CorrespondenceLanguage>
			<Language>
				<LanguageCoded>
					<xsl:choose>
						<xsl:when test="string-length($PartyLang) &gt; 1">
							<xsl:value-of select="$PartyLang"/>
						</xsl:when>
						<xsl:otherwise>en</xsl:otherwise>
					</xsl:choose>
				</LanguageCoded>
			</Language>
		</CorrespondenceLanguage>
	</xsl:template>

	<xsl:template name="createNameAddress">
		<!--Common-->
		<xsl:param name="Party"/>
		<NameAddress>
			<Name1>
				<xsl:value-of select="$Party/Name"/>
			</Name1>
			<xsl:if test="$Party/PostalAddress/Street[3]!=''">
				<Name2>
					<xsl:value-of select="$Party/PostalAddress/Street[1]"/>
				</Name2>
			</xsl:if>
			<xsl:if test="$Party/PostalAddress/Street[4]!=''">
				<Name3>
					<xsl:value-of select="$Party/PostalAddress/Street[2]"/>
				</Name3>
			</xsl:if>
			<Street>
				<xsl:choose>
					<xsl:when test="$Party/PostalAddress/Street[4]!=''">
						<xsl:value-of select="$Party/PostalAddress/Street[3]"/>
					</xsl:when>
					<xsl:when test="$Party/PostalAddress/Street[3]!='' and not($Party/PostalAddress/Street[4]!='')">
						<xsl:value-of select="$Party/PostalAddress/Street[2]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$Party/PostalAddress/Street[1]"/>
					</xsl:otherwise>
				</xsl:choose>
			</Street>
			<StreetSupplement1>
				<xsl:choose>
					<xsl:when test="$Party/PostalAddress/Street[4]!=''">
						<xsl:value-of select="$Party/PostalAddress/Street[4]"/>
					</xsl:when>
					<xsl:when test="$Party/PostalAddress/Street[3]!='' and not($Party/PostalAddress/Street[4]!='')">
						<xsl:value-of select="$Party/PostalAddress/Street[3]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$Party/PostalAddress/Street[2]"/>
					</xsl:otherwise>
				</xsl:choose>
			</StreetSupplement1>
			<PostalCode>
				<xsl:value-of select="$Party/PostalAddress/PostalCode"/>
			</PostalCode>
			<City>
				<xsl:value-of select="$Party/PostalAddress/City"/>
			</City>
			<xsl:if test="$Party/PostalAddress/State!=''">
				<Region>
					<RegionCoded>Other</RegionCoded>
					<RegionCodedOther>
						<xsl:value-of select="$Party/PostalAddress/State"/>
					</RegionCodedOther>
				</Region>
			</xsl:if>
			<xsl:if test="$Party/PostalAddress/Country/@isoCountryCode!=''">
				<Country>
					<CountryCoded>
						<xsl:value-of select="$Party/PostalAddress/Country/@isoCountryCode"/>
					</CountryCoded>
				</Country>
			</xsl:if>
		</NameAddress>
	</xsl:template>

	<xsl:template name="createFinalRecipient">
		<!--Common-->
		<xsl:param name="Party"/>
		<Party>
			<PartyID>
				<Identifier>
					<Agency>
						<AgencyCoded>Other</AgencyCoded>
						<AgencyCodedOther>QuadremMarketPlace</AgencyCodedOther>
						<AgencyDescription>Other</AgencyDescription>
					</Agency>
					<Ident>
						<xsl:value-of select="$Party/@addressID"/>
					</Ident>
				</Identifier>
			</PartyID>
			<NameAddress>
				<Name1>
					<xsl:value-of select="$Party/Name"/>
				</Name1>
				<Street>
					<xsl:value-of select="$Party/PostalAddress/Street[1]"/>
				</Street>
				<StreetSupplement1>
					<xsl:value-of select="$Party/PostalAddress/Street[2]"/>
				</StreetSupplement1>
				<StreetSupplement2>
					<xsl:value-of select="$Party/PostalAddress/Street[3]"/>
				</StreetSupplement2>
				<PostalCode>
					<xsl:value-of select="$Party/PostalAddress/PostalCode"/>
				</PostalCode>
				<City>
					<xsl:value-of select="$Party/PostalAddress/City"/>
				</City>
				<xsl:if test="$Party/PostalAddress/Country/@isoCountryCode!=''">
					<Country>
						<CountryCoded>
							<xsl:value-of select="$Party/PostalAddress/Country/@isoCountryCode"/>
						</CountryCoded>
					</Country>
				</xsl:if>
			</NameAddress>
			<xsl:if test="$Party/Phone/TelephoneNumber/Number!='' or $Party/Fax/TelephoneNumber/Number!='' or $Party/Email!=''">
				<OrderContact>
					<xsl:call-template name="contactInfo">
						<xsl:with-param name="Party" select="$Party"/>
					</xsl:call-template>
				</OrderContact>
			</xsl:if>
		</Party>
	</xsl:template>

	<xsl:template name="contactInfo">
		<!--Common-->
		<xsl:param name="Party"/>
		<Contact>
			<ContactName>
				<xsl:value-of select="$Party/PostalAddress/DeliverTo"/>
			</ContactName>
			<ListOfContactNumber>
				<xsl:if test="$Party/Phone/TelephoneNumber/Number!=''">
					<ContactNumber>
						<ContactNumberValue>
							<xsl:value-of select="$Party/Phone/TelephoneNumber/Number"/>
						</ContactNumberValue>
						<ContactNumberTypeCoded>TelephoneNumber</ContactNumberTypeCoded>
					</ContactNumber>
				</xsl:if>
				<xsl:if test="$Party/Fax/TelephoneNumber/Number!=''">
					<ContactNumber>
						<ContactNumberValue>
							<xsl:value-of select="$Party/Fax/TelephoneNumber/Number"/>
						</ContactNumberValue>
						<ContactNumberTypeCoded>FaxNumber</ContactNumberTypeCoded>
					</ContactNumber>
				</xsl:if>
				<xsl:if test="$Party/Email!=''">
					<ContactNumber>
						<ContactNumberValue>
							<xsl:value-of select="$Party/Email"/>
						</ContactNumberValue>
						<ContactNumberTypeCoded>EmailAddress</ContactNumberTypeCoded>
					</ContactNumber>
				</xsl:if>
			</ListOfContactNumber>
		</Contact>
	</xsl:template>

	<xsl:template name="createDetail">
		<!--Order/ChangeOrder-->
		<xsl:param name="detailItem"/>
		<BaseItemDetail>
			<LineItemNum>
				<BuyerLineItemNum>
					<xsl:value-of select="$detailItem/@lineNumber"/>
				</BuyerLineItemNum>
				<!--xsl:if test="$detailItem/ItemDetail/Extrinsic[@name='SellerLineItemNum']!=''">
					<SellerLineItemNum>
						<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='SellerLineItemNum']"/>
					</SellerLineItemNum>
				</xsl:if-->
			</LineItemNum>
			<xsl:choose>
				<!--xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='ItemType']!=''">
					<LineItemType>
						<LineItemTypeCoded>Other</LineItemTypeCoded>
						<LineItemTypeCodedOther>
							<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='ItemType']"/>
						</LineItemTypeCodedOther>
					</LineItemType>
				</xsl:when>
				<xsl:when test="$detailItem/SpendDetail/Extrinsic[@name='GenericServiceCategory']">
					<LineItemType>
						<LineItemTypeCoded>Other</LineItemTypeCoded>
						<LineItemTypeCodedOther>
							<xsl:value-of select="$detailItem/SpendDetail/Extrinsic[@name='GenericServiceCategory']"/>
						</LineItemTypeCodedOther>
					</LineItemType>
				</xsl:when>
				<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']!=''">
					<LineItemType>
						<LineItemTypeCoded>Other</LineItemTypeCoded>
						<LineItemTypeCodedOther>
							<xsl:choose>
								<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']='Planned' or $detailItem/ItemDetail/Extrinsic[@name='serviceType']='Palnned'">
									<xsl:text>ServiceItem</xsl:text>
								</xsl:when>
								<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']='Unplanned'">
									<xsl:text>UnplannedServiceItem</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='serviceType']"/>
								</xsl:otherwise>
							</xsl:choose>
						</LineItemTypeCodedOther>
					</LineItemType>
				</xsl:when-->
				<xsl:when test="$detailItem/@itemType='composite' and $detailItem/../ItemOut[@parentLineNumber=$detailItem/@lineNumber]/SpendDetail">
					<LineItemType>
						<LineItemTypeCoded>Other</LineItemTypeCoded>
						<LineItemTypeCodedOther>
							<xsl:text>ServiceItem</xsl:text>
						</LineItemTypeCodedOther>
					</LineItemType>
				</xsl:when>
				<xsl:when test="$detailItem/SpendDetail">
					<LineItemType>
						<LineItemTypeCoded>Other</LineItemTypeCoded>
						<LineItemTypeCodedOther>
							<xsl:text>ServiceItem</xsl:text>
						</LineItemTypeCodedOther>
					</LineItemType>
				</xsl:when>
			</xsl:choose>

			<xsl:if test="$detailItem/@parentLineNumber!='' and $detailItem/@itemType='item'">
				<ParentItemNumber>
					<LineItemNumberReference>
						<xsl:value-of select="$detailItem/@parentLineNumber"/>
					</LineItemNumberReference>
				</ParentItemNumber>
			</xsl:if>
			<xsl:if test="$detailItem/ItemID/SupplierPartID!='' or $detailItem//Extrinsic[@name='customersPartNo']!='' or $detailItem/ItemDetail/ManufacturerPartID!='' or $detailItem/ItemDetail/Description!='' or $detailItem//Classification[@domain='SPSC']!='' or $detailItem/@itemType='composite'">
				<ItemIdentifiers>
					<xsl:if test="$detailItem/ItemID/SupplierPartID!='' or $detailItem//Extrinsic[@name='customersPartNo']!='' or $detailItem//ManufacturerPartID!=''">
						<PartNumbers>
							<xsl:if test="$detailItem/ItemID/SupplierPartID!=''">
								<SellerPartNumber>
									<PartNum>
										<PartID>
											<xsl:value-of select="$detailItem/ItemID/SupplierPartID"/>
										</PartID>
									</PartNum>
								</SellerPartNumber>
							</xsl:if>
							<xsl:choose>

								<xsl:when test="$detailItem//Extrinsic[@name='customersPartNo']!=''">
									<BuyerPartNumber>
										<PartNum>
											<PartID>

												<xsl:value-of select="$detailItem//Extrinsic[@name='customersPartNo']"/>
											</PartID>
										</PartNum>
									</BuyerPartNumber>
								</xsl:when>
								<xsl:when test="$detailItem/ItemID/BuyerPartID!=''">
									<BuyerPartNumber>
										<PartNum>
											<PartID>

												<xsl:value-of select="$detailItem/ItemID/BuyerPartID"/>
											</PartID>
										</PartNum>
									</BuyerPartNumber>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="$detailItem/ItemDetail/ManufacturerPartID!=''">
								<ManufacturerPartNumber>
									<PartID>
										<xsl:value-of select="$detailItem/ItemDetail/ManufacturerPartID"/>
									</PartID>
								</ManufacturerPartNumber>
							</xsl:if>
						</PartNumbers>
					</xsl:if>
					<xsl:if test="$detailItem//Description!=''">
						<ItemDescription>

							<xsl:value-of select="$detailItem//Description"/>
						</ItemDescription>
					</xsl:if>
					<xsl:choose>
						<!--xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='ItemType']!=''">
							<ListOfItemCharacteristic>
								<ItemCharacteristic>
									<ItemCharacteristicCoded>Other</ItemCharacteristicCoded>
									<ItemCharacteristicCodedOther>
										<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='ItemType']"/>
									</ItemCharacteristicCodedOther>
									<ItemCharacteristicValue>
										<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='ItemType']"/>
									</ItemCharacteristicValue>
								</ItemCharacteristic>
							</ListOfItemCharacteristic>
						</xsl:when>
						<xsl:when test="$detailItem/SpendDetail/Extrinsic[@name='GenericServiceCategory']">
							<ListOfItemCharacteristic>
								<ItemCharacteristic>
									<ItemCharacteristicCoded>Services</ItemCharacteristicCoded>
								</ItemCharacteristic>
							</ListOfItemCharacteristic>
						</xsl:when>
						<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']!=''">
							<ListOfItemCharacteristic>
								<ItemCharacteristic>
									<ItemCharacteristicCoded>Other</ItemCharacteristicCoded>
									<ItemCharacteristicCodedOther>
										<xsl:choose>
											<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']!='' and ($detailItem/ItemDetail/Extrinsic[@name='serviceType']='Planned' or $detailItem/ItemDetail/Extrinsic[@name='serviceType']='Palnned')">
												<xsl:text>ServiceItem</xsl:text>
											</xsl:when>
											<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']!='' and $detailItem/ItemDetail/Extrinsic[@name='serviceType']='Unplanned'">
												<xsl:text>UnplannedServiceItem</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='serviceType']"/>
											</xsl:otherwise>
										</xsl:choose>
									</ItemCharacteristicCodedOther>
									<ItemCharacteristicValue>
										<xsl:choose>
											<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']!='' and ($detailItem/ItemDetail/Extrinsic[@name='serviceType']='Planned' or $detailItem/ItemDetail/Extrinsic[@name='serviceType']='Palnned')">
												<xsl:text>ServiceItem</xsl:text>
											</xsl:when>
											<xsl:when test="$detailItem/ItemDetail/Extrinsic[@name='serviceType']!='' and $detailItem/ItemDetail/Extrinsic[@name='serviceType']='Unplanned'">
												<xsl:text>UnplannedServiceItem</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='serviceType']"/>
											</xsl:otherwise>
										</xsl:choose>
									</ItemCharacteristicValue>
								</ItemCharacteristic>
							</ListOfItemCharacteristic>
						</xsl:when-->
						<xsl:when test="$detailItem/@itemType='composite' and $detailItem/../ItemOut[@parentLineNumber=$detailItem/@lineNumber]/SpendDetail">
							<ListOfItemCharacteristic>
								<ItemCharacteristic>
									<ItemCharacteristicCoded>Services</ItemCharacteristicCoded>
									<ItemCharacteristicValue>Services</ItemCharacteristicValue>
								</ItemCharacteristic>
							</ListOfItemCharacteristic>
						</xsl:when>
						<xsl:when test="$detailItem/SpendDetail">
							<ListOfItemCharacteristic>
								<ItemCharacteristic>
									<ItemCharacteristicCoded>Services</ItemCharacteristicCoded>
									<ItemCharacteristicValue>Services</ItemCharacteristicValue>
								</ItemCharacteristic>
							</ListOfItemCharacteristic>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="$detailItem//Classification[@domain='UNSPSC']!=''">
						<CommodityCode>
							<Identifier>
								<Agency>
									<AgencyCoded>Other</AgencyCoded>
								</Agency>
								<Ident>

									<xsl:value-of select="$detailItem//Classification[@domain='UNSPSC']"/>
								</Ident>
							</Identifier>
						</CommodityCode>
					</xsl:if>
				</ItemIdentifiers>
			</xsl:if>

			<TotalQuantity>
				<Quantity>
					<QuantityValue>
						<xsl:value-of select="translate($detailItem/@quantity,',','')"/>
					</QuantityValue>
					<xsl:if test="$detailItem//UnitOfMeasure!=''">
						<UnitOfMeasurement>
							<UOMCoded>Other</UOMCoded>
							<UOMCodedOther>

								<xsl:value-of select="$detailItem//UnitOfMeasure"/>
							</UOMCodedOther>
						</UnitOfMeasurement>
					</xsl:if>
				</Quantity>
			</TotalQuantity>
			<!--xsl:if test="$detailItem/ItemDetail/Extrinsic[@name='receiverAssignedDropZone']!='' or $detailItem/ItemDetail/Extrinsic[@name='recipientID']!='' or $detailItem/BlanketItemDetail/MaxAmount/Money"-->
			<!-- CIG : To Review -->
			<xsl:if test="$detailItem/BlanketItemDetail/MaxAmount/Money">
				<ListOfItemReferences>
					<ListOfReferenceCoded>
						<!--xsl:if test="$detailItem/ItemDetail/Extrinsic[@name='receiverAssignedDropZone']!=''">
							<xsl:call-template name="createOtherInvoiceReferences">
								<xsl:with-param name="refCode">ReceiverAssignedDropZone</xsl:with-param>
								<xsl:with-param name="refValue">
									<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='receiverAssignedDropZone']"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="$detailItem/ItemDetail/Extrinsic[@name='recipientID']!=''">
							<xsl:call-template name="createOtherInvoiceReferences">
								<xsl:with-param name="refCode">Receiver</xsl:with-param>
								<xsl:with-param name="refValue">
									<xsl:value-of select="$detailItem/ItemDetail/Extrinsic[@name='recipientID']"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if-->
						<xsl:if test="$detailItem/BlanketItemDetail/MaxAmount/Money">
							<xsl:call-template name="createOtherReferences">
								<xsl:with-param name="refCode">Spend_Limit</xsl:with-param>
								<xsl:with-param name="refValue">
									<xsl:value-of select="$detailItem/BlanketItemDetail/MaxAmount/Money"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</ListOfReferenceCoded>
				</ListOfItemReferences>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$detailItem/ShipTo/Address">
					<FinalRecipient>
						<xsl:call-template name="createFinalRecipient">
							<xsl:with-param name="Party" select="$detailItem/ShipTo/Address"/>
						</xsl:call-template>
					</FinalRecipient>
				</xsl:when>
				<xsl:otherwise>
					<FinalRecipient>
						<xsl:call-template name="createFinalRecipient">
							<xsl:with-param name="Party" select="/cXML//OrderRequest/OrderRequestHeader/ShipTo/Address"/>
						</xsl:call-template>
					</FinalRecipient>
				</xsl:otherwise>
			</xsl:choose>
		</BaseItemDetail>
		<PricingDetail>
			<ListOfPrice>
				<Price>
					<UnitPrice>
						<UnitPriceValue>
							<xsl:choose>
								<xsl:when test="$detailItem//UnitPrice/Money!=''">
									<xsl:value-of select="translate($detailItem//UnitPrice/Money,'$,','')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</UnitPriceValue>
						<xsl:if test="$detailItem//UnitPrice/Money/@currency!=''">
							<Currency>
								<CurrencyCoded>
									<xsl:value-of select="$detailItem//UnitPrice/Money/@currency"/>
								</CurrencyCoded>
							</Currency>
						</xsl:if>
						<xsl:if test="$detailItem//UnitOfMeasure!=''">
							<UnitOfMeasurement>
								<UOMCoded>Other</UOMCoded>
								<UOMCodedOther>
									<xsl:value-of select="$detailItem//UnitOfMeasure"/>
								</UOMCodedOther>
							</UnitOfMeasurement>
						</xsl:if>
					</UnitPrice>

					<PriceBasisQuantity>
						<Quantity>
							<QuantityValue>
								<xsl:choose>
									<xsl:when test="$detailItem//PriceBasisQuantity/@quantity!='1' and $detailItem/ItemDetail/PriceBasisQuantity/@quantity!=''">
										<xsl:value-of select="translate($detailItem//PriceBasisQuantity/@quantity,',','')"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</QuantityValue>
							<UnitOfMeasurement>
								<UOMCoded>Other</UOMCoded>
								<UOMCodedOther>
									<xsl:choose>
										<xsl:when test="$detailItem//PriceBasisQuantity/@quantity!='' and $detailItem//PriceBasisQuantity/UnitOfMeasure=''">
											<xsl:value-of select="$detailItem//PriceBasisQuantity/UnitOfMeasure"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$detailItem//UnitOfMeasure"/>
										</xsl:otherwise>
									</xsl:choose>
								</UOMCodedOther>
							</UnitOfMeasurement>
						</Quantity>
					</PriceBasisQuantity>


					<xsl:if test="$detailItem//PriceBasisQuantity/Description!=''">
						<PriceMultiplier>
							<PriceMultiplierCoded>Other</PriceMultiplierCoded>
							<PriceMultiplierCodedOther>
								<xsl:value-of select="$detailItem//PriceBasisQuantity/Description"/>
							</PriceMultiplierCodedOther>
							<Multiplier>
								<xsl:choose>
									<xsl:when test="$detailItem//PriceBasisQuantity/@conversionFactor!=''">
										<xsl:value-of select="$detailItem//PriceBasisQuantity/@conversionFactor"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</Multiplier>
						</PriceMultiplier>
					</xsl:if>
				</Price>
			</ListOfPrice>
			<xsl:for-each select="$detailItem/Tax/TaxDetail">
				<Tax>
					<TaxFunctionQualifierCoded>Tax</TaxFunctionQualifierCoded>
					<TaxCategoryCoded>Other</TaxCategoryCoded>
					<!-- CIG : To Review -->
					<xsl:choose>
						<xsl:when test="Extrinsic[@name='ExcludedFromTotal'] = 'Yes'">
							<TaxCategoryCodedOther>ExcludedFromTaxTotals</TaxCategoryCodedOther>
						</xsl:when>
						<xsl:otherwise>
							<TaxCategoryCodedOther>Other</TaxCategoryCodedOther>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="@category='sales'">
							<TaxTypeCoded>UseTax</TaxTypeCoded>
						</xsl:when>
						<xsl:when test="@category='vat'">
							<TaxTypeCoded>ValueAddedTax</TaxTypeCoded>
						</xsl:when>
						<xsl:when test="@category='gst'">
							<TaxTypeCoded>GoodsAndServicesTax</TaxTypeCoded>
						</xsl:when>
						<xsl:otherwise>
							<TaxTypeCoded>Other</TaxTypeCoded>
							<TaxTypeCodedOther>
								<Identifier>
									<Agency>
										<AgencyCoded>Other</AgencyCoded>
									</Agency>
									<Ident>
										<xsl:value-of select="@category"/>
									</Ident>
								</Identifier>
							</TaxTypeCodedOther>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@percentageRate!=''">
						<TaxPercent>
							<xsl:value-of select="@percentageRate"/>
						</TaxPercent>
					</xsl:if>
					<xsl:if test="TaxableAmount!=''">
						<TaxableAmount>
							<xsl:value-of select="translate(TaxableAmount,'$,','')"/>
						</TaxableAmount>
					</xsl:if>
					<TaxAmount>
						<xsl:value-of select="normalize-space(translate(TaxAmount,'$,',''))"/>
					</TaxAmount>
					<xsl:if test="TaxLocation!=''">
						<TaxLocation>
							<Location>
								<LocationIdentifier>
									<LocID>
										<Identifier>
											<Agency>
												<AgencyCoded>Other</AgencyCoded>
											</Agency>
											<Ident>
												<xsl:value-of select="TaxLocation"/>
											</Ident>
										</Identifier>
									</LocID>
								</LocationIdentifier>
							</Location>
						</TaxLocation>
					</xsl:if>
				</Tax>
			</xsl:for-each>
			<xsl:if test="$detailItem/ItemDetail/UnitPrice/Modifications">
				<ItemAllowancesOrCharges>
					<ListOfAllowOrCharge>
						<xsl:for-each select="$detailItem/ItemDetail/UnitPrice/Modifications/Modification">
							<AllowOrCharge>
								<IndicatorCoded>
									<xsl:choose>
										<xsl:when test="AdditionalDeduction">Allowance</xsl:when>
										<xsl:otherwise>Charge</xsl:otherwise>
									</xsl:choose>
								</IndicatorCoded>
								<BasisCoded>
									<xsl:choose>
										<xsl:when test="AdditionalDeduction/DeductionAmount or AdditionalCost/Money">MonetaryAmount</xsl:when>
										<xsl:otherwise>Percent</xsl:otherwise>
									</xsl:choose>
								</BasisCoded>
								<MethodOfHandlingCoded>Other</MethodOfHandlingCoded>
								<AllowanceOrChargeDescription>
									<AllowOrChgDesc>
										<ListOfDescription>
											<Description>
												<DescriptionText>
													<xsl:value-of select="ModificationDetail/Description"/>
												</DescriptionText>
											</Description>
										</ListOfDescription>
										<ServiceCoded>Other</ServiceCoded>
										<ServiceCodedOther>
											<xsl:value-of select="ModificationDetail/@name"/>
										</ServiceCodedOther>
									</AllowOrChgDesc>
								</AllowanceOrChargeDescription>
								<ValidityDates>
									<StartDate>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="ModificationDetail/@startDate"/>
										</xsl:call-template>
									</StartDate>
									<EndDate>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="ModificationDetail/@endDate"/>
										</xsl:call-template>
									</EndDate>
								</ValidityDates>
								<TypeOfAllowOrCharge>
									<xsl:choose>
										<xsl:when test="AdditionalDeduction/DeductionAmount or AdditionalCost/Money">
											<MonetaryValue>
												<MonetaryAmount>
													<xsl:choose>
														<xsl:when test="AdditionalDeduction">
															<xsl:value-of select="translate(AdditionalDeduction/DeductionAmount/Money,'$,','')"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="translate(AdditionalCost/Money,'$,','')"/>
														</xsl:otherwise>
													</xsl:choose>
												</MonetaryAmount>
											</MonetaryValue>
										</xsl:when>
										<xsl:otherwise>
											<PercentageAllowanceOrCharge>
												<PercentQualifier>
													<PercentQualifierCoded>Other</PercentQualifierCoded>
													<Percent>
														<xsl:choose>
															<xsl:when test="AdditionalDeduction">
																<xsl:value-of select="AdditionalDeduction/Percentage/@percent"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="AdditionalCost/Percentage/@percent"/>
															</xsl:otherwise>
														</xsl:choose>
													</Percent>
												</PercentQualifier>
											</PercentageAllowanceOrCharge>
										</xsl:otherwise>
									</xsl:choose>
								</TypeOfAllowOrCharge>
							</AllowOrCharge>
						</xsl:for-each>
					</ListOfAllowOrCharge>
				</ItemAllowancesOrCharges>
			</xsl:if>

			<xsl:variable name="quantity1" select="translate($detailItem/@quantity,',','')"/>

			<xsl:variable name="money1" select="translate($detailItem//UnitPrice/Money,'$,','')"/>

			<xsl:variable name="PBQ_qty" select="translate($detailItem//PriceBasisQuantity/@quantity,',','')"/>

			<xsl:variable name="PBQ_conv" select="$detailItem//PriceBasisQuantity/@conversionFactor"/>


			<xsl:variable name="calculatedTotalValue">
				<xsl:choose>
					<xsl:when test="$quantity1!='' and $money1!='' and $PBQ_qty!='' and $PBQ_conv!=''">
						<xsl:value-of select="format-number(((($quantity1*$money1)div $PBQ_qty)*$PBQ_conv),'#0.00##')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>skip</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!--xsl:if test="$detailItem//Extrinsic[@name='TotalAmount']!='' or $detailItem/Distribution/Charge/Money!='' or $calculatedTotalValue!='skip'"-->
			<xsl:if test="$detailItem/Distribution/Charge/Money!='' or $calculatedTotalValue!='skip'">
				<TotalValue>
					<MonetaryValue>
						<MonetaryAmount>
							<xsl:choose>
								<!--xsl:when test="$detailItem//Extrinsic[@name='TotalAmount']!=''">
									<xsl:value-of select="translate($detailItem//Extrinsic[@name='TotalAmount'],'$,','')"/>
								</xsl:when-->
								<xsl:when test="$detailItem/Distribution/Charge/Money!=''">
									<xsl:choose>
										<xsl:when test="$detailItem/Distribution/Accounting/Segment[@description='Percentage']/@id = '100'">
											<xsl:value-of select="translate($detailItem/Distribution/Charge/Money,'$,','')"/>
										</xsl:when>
										<xsl:when test="$calculatedTotalValue!='skip'">
											<xsl:value-of select="translate($calculatedTotalValue,'$,','')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($quantity1*$money1,'#0.00##')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="$calculatedTotalValue!='skip'">
									<xsl:value-of select="translate($calculatedTotalValue,'$,','')"/>
								</xsl:when>
							</xsl:choose>
						</MonetaryAmount>
						<xsl:if test="$detailItem/ItemDetail/UnitPrice/Money/@currency!=''">
							<Currency>
								<CurrencyCoded>
									<xsl:value-of select="$detailItem/ItemDetail/UnitPrice/Money/@currency"/>
								</CurrencyCoded>
							</Currency>
						</xsl:if>
					</MonetaryValue>
				</TotalValue>
			</xsl:if>
		</PricingDetail>

		<xsl:if test="$detailItem/ScheduleLine/@quantity!='' or $detailItem/ScheduleLine/@requestedDeliveryDate!=''  or $detailItem/@requestedDeliveryDate!=''">
			<DeliveryDetail>
				<ListOfScheduleLine>
					<ScheduleLine>
						<!-- CIG : To Review -->
						<!--xsl:if test="$detailItem//Extrinsic[@name='ScheduleLineNumber']!=''">
							<ScheduleLineID>
								<xsl:value-of select="$detailItem//Extrinsic[@name='ScheduleLineNumber']"/>
							</ScheduleLineID>
						</xsl:if-->

						<Quantity>
							<QuantityValue>
								<xsl:choose>
									<xsl:when test="$detailItem/ScheduleLine/@quantity!=''">
										<xsl:value-of select="$detailItem/ScheduleLine/@quantity"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="translate($detailItem/@quantity,',','')"/>
									</xsl:otherwise>
								</xsl:choose>
							</QuantityValue>
							<UnitOfMeasurement>
								<UOMCoded>Other</UOMCoded>
								<UOMCodedOther>
									<xsl:choose>
										<xsl:when test="$detailItem/ScheduleLine/UnitOfMeasure!=''">
											<xsl:value-of select="$detailItem/ScheduleLine/UnitOfMeasure"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$detailItem//UnitOfMeasure"/>
										</xsl:otherwise>
									</xsl:choose>
								</UOMCodedOther>
							</UnitOfMeasurement>
						</Quantity>
						<xsl:if test="$detailItem/ScheduleLine/@requestedDeliveryDate!='' or $detailItem/@requestedDeliveryDate!=''">
							<RequestedDeliveryDate>
								<xsl:choose>
									<xsl:when test="$detailItem/ScheduleLine/@requestedDeliveryDate!=''">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="$detailItem/ScheduleLine/@requestedDeliveryDate"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="$detailItem/@requestedDeliveryDate"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</RequestedDeliveryDate>
						</xsl:if>
					</ScheduleLine>
				</ListOfScheduleLine>
				<xsl:if test="$detailItem/TermsOfDelivery">
					<TermsOfDelivery>
						<TermsOfDeliveryFunctionCoded>Other</TermsOfDeliveryFunctionCoded>
						<TermsOfDeliveryFunctionCodedOther>
							<xsl:value-of select="$detailItem/TermsOfDelivery/TermsOfDeliveryCode/@value"/>
						</TermsOfDeliveryFunctionCodedOther>
						<TransportTermsCoded>Other</TransportTermsCoded>
						<TransportTermsCodedOther>
							<xsl:value-of select="$detailItem/TermsOfDelivery/TransportTerms/@value"/>
						</TransportTermsCodedOther>
						<ShipmentMethodOfPaymentCoded>Other</ShipmentMethodOfPaymentCoded>
						<ShipmentMethodOfPaymentCodedOther>
							<xsl:value-of select="$detailItem/TermsOfDelivery/ShippingPaymentMethod/@value"/>
						</ShipmentMethodOfPaymentCodedOther>
						<TermsOfDeliveryDescription>
							<xsl:value-of select="$detailItem/TermsOfDelivery/Comments[@type='TermsOfDelivery']"/>
						</TermsOfDeliveryDescription>
						<TransportDescription>
							<xsl:value-of select="$detailItem/TermsOfDelivery/Comments[@type='Transport']"/>
						</TransportDescription>
					</TermsOfDelivery>
				</xsl:if>
			</DeliveryDetail>
		</xsl:if>

		<xsl:if test="$detailItem/Comments/text()!=''">
			<LineItemNote>
				<xsl:value-of select="$detailItem/Comments/text()"/>
			</LineItemNote>
		</xsl:if>

		<xsl:if test="$detailItem//Extrinsic or $detailItem/Distribution/Accounting/Segment">
			<ListOfStructuredNote>
				<xsl:for-each select="$detailItem//Extrinsic">
					<StructuredNote>
						<GeneralNote>
							<xsl:value-of select="."/>
						</GeneralNote>
						<NoteID>
							<xsl:value-of select="@name"/>
						</NoteID>
					</StructuredNote>
				</xsl:for-each>
				<xsl:if test="$detailItem/Distribution/Accounting/Segment">
					<xsl:for-each select="$detailItem/Distribution/Accounting">
						<StructuredNote>
							<GeneralNote>
								<xsl:for-each select="Segment">
									<xsl:value-of select="concat(@type,':',@description,':',@id,'&#xA;')"/>
								</xsl:for-each>
							</GeneralNote>
							<NoteID>
								<xsl:value-of select="@name"/>
							</NoteID>
						</StructuredNote>
					</xsl:for-each>
				</xsl:if>
			</ListOfStructuredNote>
		</xsl:if>

		<xsl:if test="$detailItem/Comments/child::Attachment">
			<LineItemAttachments>
				<ListOfAttachment>
					<xsl:for-each select="$detailItem/Comments/Attachment">
						<Attachment>
							<AttachmentPurpose>Attachment</AttachmentPurpose>
							<FileName>
								<xsl:value-of select="substring-after(URL,'cid:')"/>
							</FileName>
							<ReplacementFile>false</ReplacementFile>
							<AttachmentLocation>
								<xsl:value-of select="concat('urn:x-commerceone:package:com:commerceone:',substring-after(URL,'cid:'))"/>
							</AttachmentLocation>
						</Attachment>
					</xsl:for-each>
				</ListOfAttachment>
			</LineItemAttachments>
		</xsl:if>
	</xsl:template>

	<xsl:template name="createOtherReferences">
		<!--Common-->
		<xsl:param name="refCode"/>
		<xsl:param name="refName"/>
		<xsl:param name="refValue"/>
		<ReferenceCoded>
			<ReferenceTypeCoded>Other</ReferenceTypeCoded>
			<ReferenceTypeCodedOther>
				<xsl:value-of select="$refCode"/>
			</ReferenceTypeCodedOther>
			<PrimaryReference>
				<Reference>
					<RefNum>
						<xsl:value-of select="$refValue"/>
					</RefNum>
				</Reference>
			</PrimaryReference>
			<xsl:if test="$refName">
				<ReferenceDescription>
					<xsl:value-of select="$refName"/>
				</ReferenceDescription>
			</xsl:if>
		</ReferenceCoded>
	</xsl:template>
</xsl:stylesheet>