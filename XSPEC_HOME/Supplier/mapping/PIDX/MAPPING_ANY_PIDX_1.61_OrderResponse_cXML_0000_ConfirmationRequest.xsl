<?xml version="1.0" encoding="utf-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="cXMLAttachments"/>
	<xsl:param name="anSenderDefaultTimeZone"/>
	<xsl:param name="anANSILookupFlag"/>
	<xsl:param name="attachSeparator" select="'\|'"/>
	<xsl:param name="anAllDetailOCFlag"/> <!-- used for allDetail logic -->
	<xsl:variable name="cXMLPIDXLookupList"
		select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_PIDX_1.61.xml')"/>
	<!--xsl:variable name="cXMLPIDXLookupList" select="document('cXML_PIDXLookups.xsl')"/-->
	<xsl:template match="/">
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of
					select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"
				/>
			</xsl:attribute>
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<Header>
				<xsl:variable name="ToDUNSValue">
					<xsl:choose>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']"
							/>
						</xsl:when>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNSNumber']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='SoldTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNSNumber']"
							/>
						</xsl:when>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']"
							/>
						</xsl:when>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNSNumber']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='ShipToParty']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNSNumber']"
							/>
						</xsl:when>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']"
							/>
						</xsl:when>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNSNumber']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='BillTo']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNSNumber']"
							/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="FromDUNSValue">
					<xsl:choose>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']"
							/>
						</xsl:when>
						<xsl:when
							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNSNumber']">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PartnerInformation[@partnerRoleIndicator='Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator='DUNS+4Number']"
							/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<!-- IG-2276 Remove systemID mapping 				<xsl:variable name="systemID">					<xsl:choose>						<xsl:when							test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:ReferenceInformation[lower-case(translate(pidx:Description,' ',''))='billtopurchasergroup']/pidx:ReferenceNumber!=''">							<xsl:value-of								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:ReferenceInformation[lower-case(translate(pidx:Description,' ',''))='billtopurchasergroup']/pidx:ReferenceNumber"							/>						</xsl:when>					</xsl:choose>				</xsl:variable-->
				<From>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anSupplierANID"/>
						</Identity>
					</Credential>
					<xsl:if test="$FromDUNSValue!=''">
						<Credential domain="DUNS">
							<Identity>
								<xsl:value-of select="$FromDUNSValue"/>
							</Identity>
						</Credential>
					</xsl:if>
				</From>
				<To>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anBuyerANID"/>
						</Identity>
					</Credential>
					<xsl:if test="$ToDUNSValue!=''">
						<Credential domain="DUNS">
							<Identity>
								<xsl:value-of select="$ToDUNSValue"/>
							</Identity>
						</Credential>
					</xsl:if>
					<!-- IG-2278 Remove systemID mapping					<xsl:if test="$systemID!=''">						<Credential domain="SYSTEMID">							<Identity>								<xsl:value-of select="$systemID"/>							</Identity>						</Credential>					</xsl:if-->
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
				<!--IG-20146 IG-20291 allDetail mapping logic rollback-\-removed variable mapAllDetail-->
				<xsl:choose>
					<xsl:when test="$anEnvName='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="language">
					<xsl:choose>
						<xsl:when
							test="normalize-space(pidx:OrderResponse/pidx:OrderResponseProperties/pidx:LanguageCode)!=''">
							<xsl:value-of
								select="lower-case(normalize-space(pidx:OrderResponse/pidx:OrderResponseProperties/pidx:LanguageCode))"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'en'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<ConfirmationRequest>
					<ConfirmationHeader>
						<xsl:variable name="headerCurrency"
							select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PrimaryCurrency/pidx:CurrencyCode"/>
						<xsl:attribute name="noticeDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate"
									select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:OrderResponseDate"
								/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="type">
							<!-- IG-2238 non case-sensitive lookup -->
							<xsl:variable name="typeOR"
								select="lower-case(pidx:OrderResponse/pidx:OrderResponseProperties/pidx:AcknowledgementType)"/>
							<xsl:choose>
								<!--IG-20146 IG-20291 allDetail mapping logic rollback-->
								
								<xsl:when
									test="$cXMLPIDXLookupList/Lookups/ConfirmationTypes/ConfirmationType[PIDXCode=$typeOR]/CXMLCode!=''">
									<xsl:value-of
										select="$cXMLPIDXLookupList/Lookups/ConfirmationTypes/ConfirmationType[PIDXCode=$typeOR]/CXMLCode"
									/>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="operation">
							<xsl:variable name="operation"
								select="pidx:OrderResponse/@pidx:transactionPurposeIndicator"/>
							<xsl:choose>
								<xsl:when
									test="$cXMLPIDXLookupList/Lookups/TransactionPurposeIndicators/TransactionPurposeIndicator[PIDXCode=$operation]/CXMLCode!=''">
									<xsl:value-of
										select="$cXMLPIDXLookupList/Lookups/TransactionPurposeIndicators/TransactionPurposeIndicator[PIDXCode=$operation]/CXMLCode"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>new</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="confirmID">
							<xsl:value-of
								select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:OrderResponseNumber"
							/>
						</xsl:attribute>
						<xsl:variable name="incoterms"
							select="pidx:OrderResponse/pidx:OrderResponseDetails/pidx:OrderResponseLineItem[1]/pidx:TransportInformation/pidx:ShipmentTermsCode"/>
						<xsl:choose>
							<xsl:when
								test="$cXMLPIDXLookupList/Lookups/IncotermsCodes/IncotermsCode[PIDXCode=$incoterms]/CXMLCode!=''">
								<xsl:attribute name="incoTerms">
									<xsl:value-of
										select="$cXMLPIDXLookupList/Lookups/IncotermsCodes/IncotermsCode[PIDXCode=$incoterms]/CXMLCode"
									/>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="string-length($incoterms)=3">
								<xsl:attribute name="incoTerms">
									<xsl:value-of select="lower-case($incoterms)"/>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					   <xsl:if test="pidx:OrderResponse/@pidx:transactionPurposeIndicator != 'Original'">
					      <xsl:element name="DocumentReference">
					         <xsl:attribute name="payloadID"/>
					      </xsl:element>
					   </xsl:if>						
                  <Total>
							<Money>
								<xsl:attribute name="currency">
									<xsl:value-of select="$headerCurrency"/>
								</xsl:attribute>
								<xsl:value-of
									select="pidx:OrderResponse/pidx:OrderResponseSummary/pidx:TotalAmount/pidx:MonetaryAmount"
								/>
							</Money>
						</Total>
						<xsl:if
							test="normalize-space(pidx:OrderResponse/pidx:OrderResponseProperties/pidx:Comment)!=''">
							<Comments>
								<xsl:attribute name="xml:lang">
									<xsl:value-of select="$language"/>
								</xsl:attribute>
								<xsl:value-of
									select="normalize-space(pidx:OrderResponse/pidx:OrderResponseProperties/pidx:Comment)"/>
								<!-- Attachment URL -->
								<xsl:if test="$cXMLAttachments!=''">
									<xsl:variable name="tokenizedAttachments"
										select="tokenize($cXMLAttachments, $attachSeparator)"/>
									<xsl:for-each select="$tokenizedAttachments">
										<xsl:if test="normalize-space(.)!=''">
											<Attachment>
												<URL>
												<xsl:value-of select="."/>
												</URL>
											</Attachment>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</Comments>
						</xsl:if>
						<xsl:for-each
							select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:ReferenceInformation[@referenceInformationIndicator='Other' and lower-case(pidx:ReferenceNumber) != 'alldetail']">
							<xsl:if test="normalize-space(pidx:Description)!=''">
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="normalize-space(pidx:Description)"/>
									</xsl:attribute>
									<xsl:value-of select="normalize-space(pidx:ReferenceNumber)"/>									
								</Extrinsic>
							</xsl:if>
						</xsl:for-each>
					</ConfirmationHeader>
					<OrderReference>
						<!--xsl:attribute name="orderDate">														<xsl:choose>								<xsl:when test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderIssuedDate">									<xsl:call-template name="formatDate">										<xsl:with-param name="DocDate" select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderIssuedDate"/>									</xsl:call-template>								</xsl:when>								<xsl:otherwise>									<xsl:call-template name="formatDate">										<xsl:with-param name="DocDate" select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:ChangeOrderInformation/pidx:PurchaseOrderIssuedDate"/>									</xsl:call-template>								</xsl:otherwise>							</xsl:choose>						</xsl:attribute-->
						<xsl:attribute name="orderID">
							<xsl:choose>
								<xsl:when
									test="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber">
									<xsl:value-of
										select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:PurchaseOrderInformation/pidx:PurchaseOrderNumber"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="pidx:OrderResponse/pidx:OrderResponseProperties/pidx:ChangeOrderInformation/pidx:PurchaseOrderNumber"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<DocumentReference>
							<xsl:attribute name="payloadID">
								<xsl:value-of select="''"/>
							</xsl:attribute>
						</DocumentReference>
					</OrderReference>
					<!-- CSN Fix - needs to be outside the loop -->
					<xsl:variable name="sendItemTypeVal">
						<xsl:if
							test="//BaseItemDetail/ParentItemNumber/LineItemNumberReference!='' and //BaseItemDetail/ParentItemNumber/LineItemNumberReference">
							<xsl:text>true</xsl:text>
						</xsl:if>
					</xsl:variable>
					<!-- CC-018913 Added to not map item acceptance for service orders, as AN doesn't allow it -->
					<!--IG-20146 IG-20291 allDetail mapping logic rollback-\-removed condition $mapAllDetail='true'-->
				   <xsl:if test="lower-case(pidx:OrderResponse/pidx:OrderResponseProperties/pidx:AcknowledgementType)!='reject'">
					<xsl:for-each
						select="pidx:OrderResponse/pidx:OrderResponseDetails/pidx:OrderResponseLineItem">
						<ConfirmationItem>
							<!-- IG-2238 non case-sensitive lookup -->
							<xsl:variable name="LRCtype1">
								<xsl:value-of select="lower-case(pidx:LineResponseReasonCode)"/>
							</xsl:variable>
							<xsl:attribute name="lineNumber">
								<xsl:value-of select="pidx:PurchaseOrderLineItemNumber"/>
							</xsl:attribute>
							<xsl:attribute name="quantity">
								<xsl:value-of select="pidx:OrderQuantity/pidx:Quantity"/>
								<!-- needs to be original qty -->
							</xsl:attribute>
							<xsl:call-template name="UOMCodeConversion">
								<xsl:with-param name="UOMCode"
									select="pidx:OrderQuantity/pidx:UnitOfMeasureCode"/>
							</xsl:call-template>
							<ConfirmationStatus>
								<xsl:variable name="LRCtype">
									<xsl:choose>
										<!--IG-20146 IG-20291 allDetail mapping logic rollback-Removed condition $mapAllDetail='true'-->
									   
									   <xsl:when test="lower-case($cXMLPIDXLookupList/Lookups/ConfirmationTypes/ConfirmationType[lower-case(PIDXCode)=$LRCtype1]/CXMLCode) = 'detail'">
									      <xsl:text>detail</xsl:text>
									   </xsl:when>
										<xsl:when
											test="$cXMLPIDXLookupList/Lookups/ConfirmationTypes/ConfirmationType[lower-case(PIDXCode)=$LRCtype1]/CXMLCode!=''">
											<xsl:value-of
												select="$cXMLPIDXLookupList/Lookups/ConfirmationTypes/ConfirmationType[lower-case(PIDXCode)=$LRCtype1]/CXMLCode"
											/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:attribute name="type">
									<xsl:value-of select="$LRCtype"/>
								</xsl:attribute>
								<xsl:attribute name="quantity">
									<xsl:value-of select="pidx:OrderQuantity/pidx:Quantity"/>
								</xsl:attribute>
								<!--IG-20146 IG-20291 allDetail mapping logic rollback-Removed condition $LRCtype='allDetail'-->
								<xsl:if
									test="$LRCtype='detail' or $LRCtype='accept'">
									<xsl:if
										test="pidx:ServiceDateTime[@dateTypeIndicator='RequestedForDelivery']">
										<xsl:attribute name="deliveryDate">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="pidx:ServiceDateTime[@dateTypeIndicator='RequestedForDelivery']"
												/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:if>
									<xsl:if
										test="pidx:ServiceDateTime[@dateTypeIndicator='RequestedShipment']">
										<xsl:attribute name="shipmentDate">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="pidx:ServiceDateTime[@dateTypeIndicator='RequestedShipment']"
												/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:if>
								</xsl:if>
								<xsl:call-template name="UOMCodeConversion">
									<xsl:with-param name="UOMCode"
										select="pidx:OrderQuantity/pidx:UnitOfMeasureCode"/>
								</xsl:call-template>
								<!--IG-20146 IG-20291 allDetail mapping logic rollback-Removed condition $mapAllDetail='true'-->
							   <xsl:if test="$LRCtype='detail'">
									<ItemIn>
										<xsl:attribute name="quantity">
											<xsl:value-of select="pidx:OrderQuantity/pidx:Quantity"
											/>
										</xsl:attribute>
										<ItemID>
											<SupplierPartID>
												<xsl:value-of
												select="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator='AssignedBySeller']"
												/>
											</SupplierPartID>
											<xsl:if
												test="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator='AssignedByBuyer']!=''">
												<BuyerPartID>
												<xsl:value-of
												select="pidx:LineItemInformation/pidx:LineItemIdentifier[@identifierIndicator = 'AssignedByBuyer']"
												/>
												</BuyerPartID>
											</xsl:if>
										</ItemID>
										<ItemDetail>
											<UnitPrice>
												<Money>
												<xsl:attribute name="currency">
												<xsl:value-of
												select="pidx:Pricing/pidx:UnitPrice/pidx:CurrencyCode"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="pidx:Pricing/pidx:UnitPrice/pidx:MonetaryAmount"
												/>
												</Money>
											</UnitPrice>
											<Description>
												<xsl:attribute name="xml:lang">
												<xsl:value-of select="$language"/>
												</xsl:attribute>
												<xsl:value-of
												select="pidx:LineItemInformation/pidx:LineItemDescription"
												/>
											</Description>
											<xsl:call-template name="UOMCodeConversion">
												<xsl:with-param name="UOMCode"
												select="pidx:OrderQuantity/pidx:UnitOfMeasureCode"
												/>
											</xsl:call-template>
											<xsl:if
												test="pidx:Pricing/pidx:PriceBasis/pidx:Measurement and pidx:Pricing/pidx:PriceBasis/pidx:UnitOfMeasureCode">
												<PriceBasisQuantity>
												<xsl:attribute name="quantity">
												<xsl:value-of
												select="pidx:Pricing/pidx:PriceBasis/pidx:Measurement"
												/>
												</xsl:attribute>
												<xsl:attribute name="conversionFactor">
												<xsl:text>1</xsl:text>
												</xsl:attribute>
												<xsl:call-template name="UOMCodeConversion">
												<xsl:with-param name="UOMCode"
												select="pidx:Pricing/pidx:PriceBasis/pidx:UnitOfMeasureCode"
												/>
												</xsl:call-template>
												</PriceBasisQuantity>
											</xsl:if>
											<Classification>
												<xsl:attribute name="domain">UNSPSC</xsl:attribute>
												<xsl:value-of
												select="pidx:CommodityCode[@agencyIndicator='UNSPSC']"
												/>
											</Classification>
										</ItemDetail>
									</ItemIn>
								</xsl:if>
								<xsl:if test="normalize-space(pidx:Comment)!=''">
									<Comments>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="$language"/>
										</xsl:attribute>
										<xsl:value-of select="normalize-space(pidx:Comment)"/>
									</Comments>
								</xsl:if>
								<xsl:if
									test="pidx:ServiceDateTime[@dateTypeIndicator='ServicePeriodStart']">
									<Extrinsic>
										<xsl:attribute name="name">
											<xsl:text>startDate</xsl:text>
										</xsl:attribute>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate"
												select="pidx:ServiceDateTime[@dateTypeIndicator='ServicePeriodStart']"
											/>
										</xsl:call-template>
									</Extrinsic>
								</xsl:if>
							</ConfirmationStatus>
						</ConfirmationItem>
					</xsl:for-each>
				   </xsl:if>
            </ConfirmationRequest>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template name="formatDate">
		<xsl:param name="DocDate"/>
		<xsl:choose>
			<xsl:when test="$DocDate">
				<xsl:variable name="Time1" select="substring($DocDate,11)"/>
				<xsl:variable name="Time">
					<xsl:choose>
						<xsl:when test="string-length($Time1) &gt; 0">
							<xsl:variable name="timezone"
								select="concat(substring-after($Time1, '+'), substring-after($Time1, '-'))"/>
							<xsl:choose>
								<xsl:when test="string-length($timezone) &gt; 0">
									<xsl:value-of select="''"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$anSenderDefaultTimeZone"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('T00:00:00',$anSenderDefaultTimeZone)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="concat($DocDate, $Time)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="UOMCodeConversion">
		<xsl:param name="UOMCode"/>
		<xsl:choose>
			<xsl:when
				test="lower-case($anANSILookupFlag) = 'true' and $cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[PIDXCode = $UOMCode]">
				<xsl:element name="UnitOfMeasure">
					<xsl:value-of
						select="$cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[PIDXCode = $UOMCode]/CXMLCode"
					/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="UnitOfMeasure">
					<xsl:value-of select="$UOMCode"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:transform>
