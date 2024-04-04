<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="pd:HCIOWNERPID:Format_CXML_XCBL_common:Binary"/>
	<!--xsl:include href="Format_CXML_XCBL_common.xsl"/-->
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>

	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>

	<xsl:strip-space elements="Money TaxAmount TaxableAmount"/>

	<xsl:template match="cXML/Request">
		<Order>
			<OrderHeader>
				<OrderNumber>
					<BuyerOrderNumber>
						<xsl:value-of select="OrderRequest/OrderRequestHeader/@orderID"/>
					</BuyerOrderNumber>
					<xsl:if test="OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID">
						<SellerOrderNumber>
							<xsl:value-of select="OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID"/>
						</SellerOrderNumber>
					</xsl:if>
				</OrderNumber>
				<OrderIssueDate>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="OrderRequest/OrderRequestHeader/@orderDate"/>
					</xsl:call-template>
				</OrderIssueDate>
				<OrderReferences>
					<xsl:choose>
						<xsl:when test="OrderRequest/OrderRequestHeader/Extrinsic/@name = 'buyerPurchasingCode'">
							<!-- CIG : To Review -->
							<AccountCode>
								<Reference>
									<RefNum>
										<xsl:value-of select="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'buyerPurchasingCode']"/>
									</RefNum>
								</Reference>
							</AccountCode>
						</xsl:when>
						<xsl:when test="OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID != ''">
							<AccountCode>
								<Reference>
									<RefNum>
										<xsl:value-of select="OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID"/>
									</RefNum>
								</Reference>
							</AccountCode>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="OrderRequest/OrderRequestHeader/@agreementID != ''">
						<ContractReferences>
							<ListOfContract>
								<Contract>
									<ContractID>
										<Identifier>
											<Agency>
												<AgencyCoded>AssignedByBuyerOrBuyersAgent</AgencyCoded>
											</Agency>
											<Ident>
												<xsl:value-of select="OrderRequest/OrderRequestHeader/@agreementID"/>
											</Ident>
										</Identifier>
									</ContractID>
								</Contract>
							</ListOfContract>
						</ContractReferences>
					</xsl:if>
				</OrderReferences>
				<xsl:if test="OrderRequest/OrderRequestHeader/@orderVersion != ''">
					<ReleaseNumber>
						<xsl:value-of select="OrderRequest/OrderRequestHeader/@orderVersion"/>
					</ReleaseNumber>
				</xsl:if>
				<Purpose>
					<PurposeCoded>Original</PurposeCoded>
				</Purpose>
				<OrderType>
					<OrderTypeCoded>
						<xsl:choose>
							<xsl:when test="OrderRequest/OrderRequestHeader/@orderType = 'release'">ReleaseOrDeliveryOrder</xsl:when>
							<xsl:when test="OrderRequest/OrderRequestHeader/@orderType = 'blanket'">BlanketOrder</xsl:when>
							<!-- CC-018913 Check if SpendDetail exist to mark service orders -->
							<xsl:when test="OrderRequest/ItemOut/SpendDetail">SupplyOrServiceOrder</xsl:when>
							<xsl:otherwise>Order</xsl:otherwise>
						</xsl:choose>
					</OrderTypeCoded>
				</OrderType>
				<OrderCurrency>
					<Currency>
						<CurrencyCoded>
							<xsl:value-of select="OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
						</CurrencyCoded>
					</Currency>
				</OrderCurrency>
				<OrderLanguage>
					<Language>
						<LanguageCoded>
							<xsl:choose>
								<xsl:when test="/cXML/@xml:lang != ''">
									<xsl:value-of select="translate(substring(/cXML/@xml:lang, 1, 2), $upperAlpha, $lowerAlpha)"/>
								</xsl:when>
								<xsl:otherwise>en</xsl:otherwise>
							</xsl:choose>
						</LanguageCoded>
					</Language>
				</OrderLanguage>
				<xsl:if test="OrderRequest/OrderRequestHeader/Tax/TaxDetail/TaxAmount">
					<OrderTaxReference>
						<TaxReference>
							<TaxFunctionQualifierCoded>Tax</TaxFunctionQualifierCoded>
							<TaxCategoryCoded>Other</TaxCategoryCoded>
							<xsl:choose>
								<xsl:when test="OrderRequest/OrderRequestHeader/Tax/TaxDetail/@category = 'sales'">
									<TaxTypeCoded>UseTax</TaxTypeCoded>
								</xsl:when>
								<xsl:when test="OrderRequest/OrderRequestHeader/Tax/TaxDetail/@category = 'vat'">
									<TaxTypeCoded>ValueAddedTax</TaxTypeCoded>
								</xsl:when>
								<xsl:when test="OrderRequest/OrderRequestHeader/Tax/TaxDetail/@category = 'gst'">
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
												<xsl:value-of select="OrderRequest/OrderRequestHeader/Tax/TaxDetail/@category"/>
											</Ident>
										</Identifier>
									</TaxTypeCodedOther>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="OrderRequest/OrderRequestHeader/Tax/TaxDetail/@percentageRate != ''">
								<TaxPercent>
									<xsl:value-of select="OrderRequest/OrderRequestHeader/Tax/TaxDetail/@percentageRate"/>
								</TaxPercent>
							</xsl:if>
							<xsl:if test="OrderRequest/OrderRequestHeader/Tax/TaxDetail/TaxableAmount != ''">
								<TaxableAmount>
									<xsl:value-of select="translate(OrderRequest/OrderRequestHeader/Tax/TaxDetail/TaxableAmount, ',', '')"/>
								</TaxableAmount>
							</xsl:if>
							<TaxAmount>
								<xsl:value-of select="translate(OrderRequest/OrderRequestHeader/Tax/TaxDetail/TaxAmount, ',', '')"/>
							</TaxAmount>
							<xsl:if test="OrderRequest/OrderRequestHeader/Tax/TaxDetail/TaxLocation != ''">
								<TaxLocation>
									<Location>
										<LocationIdentifier>
											<LocID>
												<Identifier>
													<Agency>
														<AgencyCoded>Other</AgencyCoded>
													</Agency>
													<Ident>
														<xsl:value-of select="OrderRequest/OrderRequestHeader/Tax/TaxDetail/TaxLocation"/>
													</Ident>
												</Identifier>
											</LocID>
										</LocationIdentifier>
									</Location>
								</TaxLocation>
							</xsl:if>
							<TaxTreatmentCoded>Other</TaxTreatmentCoded>
						</TaxReference>
					</OrderTaxReference>
				</xsl:if>
				<xsl:if test="OrderRequest/OrderRequestHeader/@effectiveDate != '' or OrderRequest/OrderRequestHeader/@expirationDate != ''">
					<OrderDates>
						<ValidityDates>
							<StartDate>
								<xsl:choose>
									<xsl:when test="OrderRequest/OrderRequestHeader/@effectiveDate != ''">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="OrderRequest/OrderRequestHeader/@effectiveDate"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="OrderRequest/OrderRequestHeader/@orderDate"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</StartDate>
							<EndDate>
								<xsl:choose>
									<xsl:when test="OrderRequest/OrderRequestHeader/@expirationDate != 'Perpetual'">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="OrderRequest/OrderRequestHeader/@expirationDate"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>20300101T00:00:00</xsl:otherwise>
								</xsl:choose>
							</EndDate>
						</ValidityDates>
					</OrderDates>
				</xsl:if>
				<OrderParty>
					<BuyerParty>
						<xsl:choose>
							<xsl:when test="OrderRequest/OrderRequestHeader/Contact[@role = 'soldTo']">
								<xsl:call-template name="createParty">
									<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/Contact[@role = 'soldTo']"/>
									<xsl:with-param name="TPID" select="$anAlternativeSender"/>
									<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/Contact[@role = 'soldTo']/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
									<xsl:with-param name="PartyType" select="'Buyer'"/>
									<xsl:with-param name="BuyerSystemID" select="/cXML/Header/Sender/Credential[@domain = 'SystemID']/Identity"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="createParty">
									<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/ShipTo/Address"/>
									<xsl:with-param name="TPID" select="$anAlternativeSender"/>
									<xsl:with-param name="Ident" select="OrderRequest/OrderRequestHeader/Contact[@role = 'purchasingAgent']/@addressID"/>
									<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/ShipTo/Address/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
									<xsl:with-param name="PartyType" select="'Buyer'"/>
									<xsl:with-param name="BuyerSystemID" select="/cXML/Header/Sender/Credential[@domain = 'SystemID']/Identity"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</BuyerParty>
					<xsl:if test="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'buyerVatID'] != ''">
						<!-- CIG: To Review -->
						<BuyerTaxInformation>
							<PartyTaxInformation>
								<TaxIdentifier>
									<Identifier>
										<Agency>
											<AgencyCoded>Other</AgencyCoded>
										</Agency>
										<Ident>
											<xsl:value-of select="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'buyerVatID']"/>
										</Ident>
									</Identifier>
								</TaxIdentifier>
							</PartyTaxInformation>
						</BuyerTaxInformation>
					</xsl:if>
					<SellerParty>
						<xsl:choose>
							<xsl:when test="OrderRequest/OrderRequestHeader/Contact[@role = 'from']">
								<xsl:call-template name="createParty">
									<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/Contact[@role = 'from']"/>
									<xsl:with-param name="TPID" select="$anAlternativeReceiver"/>
									<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/Contact[@role = 'from']/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
									<xsl:with-param name="SellerSystemID" select="/cXML/Header/To/Credential[@domain = 'SystemID']/Identity"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']">
								<xsl:call-template name="createParty">
									<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']"/>
									<xsl:with-param name="TPID" select="$anAlternativeReceiver"/>
									<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
									<xsl:with-param name="SellerSystemID" select="/cXML/Header/To/Credential[@domain = 'SystemID']/Identity"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="OrderRequest/OrderRequestHeader/Contact[@role = 'supplierMasterAccount']">
								<xsl:call-template name="createParty">
									<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/Contact[@role = 'supplierMasterAccount']"/>
									<xsl:with-param name="TPID" select="$anAlternativeReceiver"/>
									<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/Contact[@role = 'supplierMasterAccount']/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
									<xsl:with-param name="SellerSystemID" select="/cXML/Header/To/Credential[@domain = 'SystemID']/Identity"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="OrderRequest/OrderRequestHeader/Contact[@role = 'supplierAccount']">
								<xsl:call-template name="createParty">
									<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/Contact[@role = 'supplierAccount']"/>
									<xsl:with-param name="TPID" select="$anAlternativeReceiver"/>
									<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/Contact[@role = 'supplierAccount']/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
									<xsl:with-param name="SellerSystemID" select="/cXML/Header/To/Credential[@domain = 'SystemID']/Identity"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="createParty">
									<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/Contact[@role = 'sales']"/>
									<xsl:with-param name="TPID" select="$anAlternativeReceiver"/>
									<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/Contact[@role = 'from']/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
									<xsl:with-param name="SellerSystemID" select="/cXML/Header/To/Credential[@domain = 'SystemID']/Identity"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</SellerParty>
					<xsl:if test="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'supplierVatID'] != ''">
						<!-- CIG: To Review -->
						<SellerTaxInformation>
							<PartyTaxInformation>
								<TaxIdentifier>
									<Identifier>
										<Agency>
											<AgencyCoded>Other</AgencyCoded>
										</Agency>
										<Ident>
											<xsl:value-of select="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'supplierVatID']"/>
										</Ident>
									</Identifier>
								</TaxIdentifier>
							</PartyTaxInformation>
						</SellerTaxInformation>
					</xsl:if>
					<xsl:if test="OrderRequest/OrderRequestHeader/ShipTo">
						<ShipToParty>
							<xsl:call-template name="createParty">
								<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/ShipTo/Address"/>
								<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/ShipTo/Address/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
								<xsl:with-param name="PartyType" select="'ShipTo'"/>
							</xsl:call-template>
						</ShipToParty>
					</xsl:if>
					<xsl:if test="OrderRequest/OrderRequestHeader/BillTo">
						<BillToParty>
							<xsl:call-template name="createParty">
								<xsl:with-param name="Party" select="OrderRequest/OrderRequestHeader/BillTo/Address"/>
								<xsl:with-param name="PartyLang" select="translate(OrderRequest/OrderRequestHeader/BillTo/Address/Name/@xml:lang, $upperAlpha, $lowerAlpha)"/>
							</xsl:call-template>
						</BillToParty>
					</xsl:if>
				</OrderParty>
				<xsl:if test="OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingContractNumber != '' or OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description != ''">
					<ListOfTransport>
						<Transport>
							<TransportID>1</TransportID>
							<xsl:if test="OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingContractNumber != ''">
								<CustShippingContractNum>
									<xsl:value-of select="OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingContractNumber"/>
								</CustShippingContractNum>
							</xsl:if>
							<xsl:if test="OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description != ''">
								<ShippingInstructions>
									<xsl:value-of select="OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description"/>
								</ShippingInstructions>
							</xsl:if>
						</Transport>
					</ListOfTransport>
				</xsl:if>
				<xsl:if test="OrderRequest/OrderRequestHeader/TermsOfDelivery">
					<OrderTermsOfDelivery>
						<TermsOfDelivery>
							<TermsOfDeliveryFunctionCoded>Other</TermsOfDeliveryFunctionCoded>
							<TermsOfDeliveryFunctionCodedOther>
								<xsl:value-of select="OrderRequest/OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode/@value"/>
							</TermsOfDeliveryFunctionCodedOther>
							<TransportTermsCoded>Other</TransportTermsCoded>
							<TransportTermsCodedOther>
								<xsl:value-of select="OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value"/>
							</TransportTermsCodedOther>
							<ShipmentMethodOfPaymentCoded>Other</ShipmentMethodOfPaymentCoded>
							<ShipmentMethodOfPaymentCodedOther>
								<xsl:value-of select="OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
							</ShipmentMethodOfPaymentCodedOther>
							<TermsOfDeliveryDescription>
								<xsl:value-of select="OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery']"/>
							</TermsOfDeliveryDescription>
							<TransportDescription>
								<xsl:value-of select="OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport']"/>
							</TransportDescription>
						</TermsOfDelivery>
					</OrderTermsOfDelivery>
				</xsl:if>
				<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/DiscountPercent/@percent != '' or OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue'] != '' or OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays != '' or OrderRequest/OrderRequestHeader/Extrinsic[@name = 'termsofPayment'] != ''">
					<OrderPaymentInstructions>
						<PaymentInstructions>
							<PaymentTerms>
								<PaymentTerm>
									<PaymentTermCoded>Other</PaymentTermCoded>
									<!-- CC-018913 : Change 'SAP:' with 'Other' -->
									<PaymentTermCodedOther>Other</PaymentTermCodedOther>
									<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays != ''">
										<PaymentTermValue>
											<xsl:value-of select="OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays"/>
										</PaymentTermValue>
									</xsl:if>
									<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays != ''">
										<PaymentTermDetails>

											<Discounts>
												<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/DiscountPercent/@percent != ''">
													<DiscountPercent>
														<xsl:value-of select="OrderRequest/OrderRequestHeader/PaymentTerm/DiscountPercent/@percent"/>
													</DiscountPercent>
												</xsl:if>
												<xsl:if test="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue'] != ''">
													<DiscountDaysDue>
														<xsl:value-of select="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue']"/>
													</DiscountDaysDue>
												</xsl:if>
												<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays != ''">
													<NetDaysDue>
														<xsl:value-of select="OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays"/>
													</NetDaysDue>
												</xsl:if>
											</Discounts>
										</PaymentTermDetails>
									</xsl:if>
								</PaymentTerm>
								<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/DiscountPercent/@percent != '' or OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue'] != '' or OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays != ''">
									<Discounts>
										<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/DiscountPercent/@percent != ''">
											<DiscountPercent>
												<xsl:value-of select="OrderRequest/OrderRequestHeader/PaymentTerm/DiscountPercent/@percent"/>
											</DiscountPercent>
										</xsl:if>
										<xsl:if test="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue'] != ''">
											<DiscountDaysDue>
												<xsl:value-of select="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue']"/>
											</DiscountDaysDue>
										</xsl:if>
										<xsl:if test="OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays != ''">
											<NetDaysDue>
												<xsl:value-of select="OrderRequest/OrderRequestHeader/PaymentTerm/@payInNumberOfDays"/>
											</NetDaysDue>
										</xsl:if>
									</Discounts>
								</xsl:if>
								<xsl:if test="OrderRequest/OrderRequestHeader/Extrinsic[@name = 'termsofPayment'] != '' or OrderRequest/OrderRequestHeader/Extrinsic[@name = 'PaymentTermsNote'] != ''">
									<PaymentTermsNote>
										<xsl:value-of select="normalize-space(concat(OrderRequest/OrderRequestHeader/Extrinsic[@name = 'PaymentTermsNote'], ' ', OrderRequest/OrderRequestHeader/Extrinsic[@name = 'termsofPayment']))"/>
									</PaymentTermsNote>
								</xsl:if>
							</PaymentTerms>
							<PaymentMethod>
								<PaymentMeanCoded>Other</PaymentMeanCoded>
							</PaymentMethod>
						</PaymentInstructions>
					</OrderPaymentInstructions>
				</xsl:if>
				<xsl:if test="OrderRequest/OrderRequestHeader/Total/Modifications">
					<OrderAllowancesOrCharges>
						<ListOfAllowOrCharge>
							<xsl:for-each select="OrderRequest/OrderRequestHeader/Total/Modifications/Modification">
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
													<Language>
														<LanguageCoded>
															<xsl:choose>
																<xsl:when test="/cXML/@xml:lang != ''">
																	<xsl:value-of select="translate(substring(/cXML/@xml:lang, 1, 2), $upperAlpha, $lowerAlpha)"/>
																</xsl:when>
																<xsl:otherwise>en</xsl:otherwise>
															</xsl:choose>
														</LanguageCoded>
													</Language>
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
									<TypeOfAllowanceOrCharge>
										<xsl:choose>
											<xsl:when test="AdditionalDeduction/DeductionAmount or AdditionalCost/Money">
												<MonetaryValue>
													<MonetaryAmount>
														<xsl:choose>
															<xsl:when test="AdditionalDeduction">
																<xsl:value-of select="translate(AdditionalDeduction/DeductionAmount/Money, ',', '')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="translate(AdditionalCost/Money, ',', '')"/>
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
									</TypeOfAllowanceOrCharge>
								</AllowOrCharge>
							</xsl:for-each>
						</ListOfAllowOrCharge>
					</OrderAllowancesOrCharges>
				</xsl:if>
				<OrderHeaderNote>
					<xsl:value-of select="OrderRequest/OrderRequestHeader/Comments/text()"/>
				</OrderHeaderNote>
				<xsl:if test="OrderRequest/OrderRequestHeader/Extrinsic or OrderRequest/OrderRequestHeader/BillTo/Address/URL != ''">
					<ListOfStructuredNote>
						<xsl:if test="OrderRequest/OrderRequestHeader/BillTo/Address/URL != ''">
							<!-- CIG : To Review -->
							<!-- BOA -->
							<StructuredNote>
								<GeneralNote>
									<xsl:value-of select="OrderRequest/OrderRequestHeader/BillTo/Address/URL"/>
								</GeneralNote>
								<NoteID>
									<xsl:value-of select="'Buyer TaxID'"/>
								</NoteID>
							</StructuredNote>
						</xsl:if>
						<xsl:for-each select="OrderRequest/OrderRequestHeader/Extrinsic">
							<StructuredNote>
								<GeneralNote>
									<xsl:value-of select="."/>
								</GeneralNote>
								<NoteID>
									<xsl:value-of select="@name"/>
								</NoteID>
							</StructuredNote>
						</xsl:for-each>
					</ListOfStructuredNote>
				</xsl:if>
				<!--Begin changes CC-15346-->
				<xsl:if test="OrderRequest/OrderRequestHeader/Comments/Attachment">
					<OrderHeaderAttachments>
						<ListOfAttachment>
							<xsl:for-each select="OrderRequest/OrderRequestHeader/Comments/Attachment">
								<Attachment>
									<AttachmentPurpose>Attachment</AttachmentPurpose>
									<FileName>
										<xsl:value-of select="substring-after(URL, 'cid:')"/>
									</FileName>
									<ReplacementFile>false</ReplacementFile>
									<AttachmentLocation>
										<xsl:value-of select="substring-after(URL, 'cid:')"/>
									</AttachmentLocation>
								</Attachment>
							</xsl:for-each>
						</ListOfAttachment>
					</OrderHeaderAttachments>
				</xsl:if>
				<!--End changes CC-15346-->
			</OrderHeader>
			<OrderDetail>
				<ListOfItemDetail>
					<xsl:for-each select="OrderRequest/ItemOut">
						<ItemDetail>
							<xsl:call-template name="createDetail">
								<xsl:with-param name="detailItem" select="."/>
							</xsl:call-template>
						</ItemDetail>
					</xsl:for-each>
				</ListOfItemDetail>
			</OrderDetail>
			<OrderSummary>
				<xsl:if test="OrderRequest/OrderRequestHeader/Tax/Money != ''">
					<TotalTax>
						<MonetaryValue>
							<MonetaryAmount>
								<xsl:value-of select="translate(OrderRequest/OrderRequestHeader/Tax/Money, ',', '')"/>
							</MonetaryAmount>
						</MonetaryValue>
					</TotalTax>
				</xsl:if>
				<TotalAmount>
					<MonetaryValue>
						<MonetaryAmount>
							<xsl:value-of select="translate(OrderRequest/OrderRequestHeader/Total/Money, ',', '')"/>
						</MonetaryAmount>
						<xsl:if test="OrderRequest/OrderRequestHeader/Total/Money/@currency != ''">
							<Currency>
								<CurrencyCoded>
									<xsl:value-of select="OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
								</CurrencyCoded>
							</Currency>
						</xsl:if>
					</MonetaryValue>
				</TotalAmount>
			</OrderSummary>
		</Order>
	</xsl:template>


	<xsl:template match="cXML/Header | cXML/text()"/>
</xsl:stylesheet>
