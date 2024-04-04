<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<!--xsl:variable name="serviceCodes" select="document('LOOKUP_XCBL_3.xsl')"/>
	<xsl:include href="Format_XCBL_CXML_common.xsl"/-->
	<xsl:include href="pd:HCIOWNERPID:Format_XCBL_CXML_common:Binary"/>
	<xsl:variable name="serviceCodes" select="document('pd:HCIOWNERPID:LOOKUP_XCBL_3:Binary')"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>
	<xsl:param name="anMaskANID" select="'_CIGSDRID_'"/>

	<xsl:template match="Invoice">
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="current-dateTime()"/>
			</xsl:attribute>
			<xsl:attribute name="payloadID">
				<xsl:value-of select="concat($anPayloadID, $anMaskANID, $anBuyerANID)"/>
				<!--xsl:value-of select="$anPayloadID"/-->
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

				<xsl:variable name="invoiceCurrency">
					<xsl:choose>
						<xsl:when test="InvoiceHeader/InvoiceCurrency/Currency/CurrencyCoded = 'Other'">
							<xsl:value-of select="InvoiceHeader/InvoiceCurrency/Currency/CurrencyCodedOther"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="InvoiceHeader/InvoiceCurrency/Currency/CurrencyCoded"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<InvoiceDetailRequest>
					<InvoiceDetailRequestHeader>
						<xsl:attribute name="invoiceID">
							<xsl:value-of select="InvoiceHeader/InvoiceNumber/Reference/RefNum"/>
						</xsl:attribute>
						<xsl:attribute name="invoiceDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="input" select="InvoiceHeader/InvoiceIssueDate"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="operation">new</xsl:attribute>
						<xsl:attribute name="purpose">
							<xsl:choose>
								<xsl:when test="contains(translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">lineLevelCreditMemo</xsl:when>
								<xsl:otherwise>standard</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<InvoiceDetailHeaderIndicator> </InvoiceDetailHeaderIndicator>
						<InvoiceDetailLineIndicator>
							<xsl:if test="InvoiceDetail/ListOfInvoiceItemDetail/InvoiceItemDetail/InvoicePricingDetail/Tax/TaxableAmount and InvoiceDetail/ListOfInvoiceItemDetail/InvoiceItemDetail/InvoicePricingDetail/Tax/TaxableAmount != ''">
								<xsl:attribute name="isTaxInLine">
									<xsl:text>yes</xsl:text>
								</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="InvoiceHeader/InvoiceParty/ShipToParty"> </xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="isShippingInLine">yes</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</InvoiceDetailLineIndicator>
						<InvoicePartner>
							<Contact role="soldTo">
								<xsl:attribute name="addressID">
									<xsl:value-of select="InvoiceHeader/InvoiceParty/BuyerParty/Party/PartyID/Identifier/Ident"/>
								</xsl:attribute>
								<xsl:call-template name="CreateContact">
									<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/BuyerParty"/>
								</xsl:call-template>
							</Contact>
						</InvoicePartner>
						<InvoicePartner>
							<Contact role="from">
								<xsl:attribute name="addressID">
									<xsl:value-of select="InvoiceHeader/InvoiceParty/SellerParty/Party/PartyID/Identifier/Ident"/>
								</xsl:attribute>
								<xsl:call-template name="CreateContact">
									<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/SellerParty"/>
								</xsl:call-template>
							</Contact>
						</InvoicePartner>
						<xsl:choose>
							<xsl:when test="InvoiceHeader/InvoiceParty/RemitToParty">
								<InvoicePartner>
									<Contact role="remitTo">
										<xsl:attribute name="addressID">
											<xsl:value-of select="InvoiceHeader/InvoiceParty/RemitToParty/Party/PartyID/Identifier/Ident"/>
										</xsl:attribute>
										<xsl:call-template name="CreateContact">
											<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/RemitToParty"/>
										</xsl:call-template>
									</Contact>
								</InvoicePartner>
							</xsl:when>
							<xsl:otherwise>
								<InvoicePartner>
									<Contact role="remitTo">
										<xsl:attribute name="addressID">
											<xsl:value-of select="InvoiceHeader/InvoiceParty/SellerParty/Party/PartyID/Identifier/Ident"/>
										</xsl:attribute>
										<xsl:call-template name="CreateContact">
											<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/SellerParty"/>
										</xsl:call-template>
									</Contact>
									<IdReference>
										<xsl:attribute name="domain">supplierTaxID</xsl:attribute>
										<xsl:attribute name="identifier">
											<xsl:choose>
												<xsl:when test="InvoiceHeader/InvoiceParty/SellerTaxInformation/PartyTaxInformation/TaxIdentifier/Identifier/Ident != ''">
													<xsl:value-of select="InvoiceHeader/InvoiceParty/SellerTaxInformation/PartyTaxInformation/TaxIdentifier/Identifier/Ident"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="InvoiceHeader/InvoiceParty/SellerTaxInformation/PartyTaxInformation/CompanyRegistrationNumber"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</IdReference>
								</InvoicePartner>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="InvoiceHeader/InvoiceParty/BillToParty">
							<InvoicePartner>
								<Contact role="billTo">
									<xsl:choose>
										<xsl:when test="InvoiceHeader/InvoiceParty/BillToParty">
											<xsl:attribute name="addressID">
												<xsl:value-of select="InvoiceHeader/InvoiceParty/BillToParty/Party/PartyID/Identifier/Ident"/>
											</xsl:attribute>
											<xsl:call-template name="CreateContact">
												<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/BillToParty"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="addressID">
												<xsl:value-of select="InvoiceHeader/InvoiceParty/BuyerParty/Party/PartyID/Identifier/Ident"/>
											</xsl:attribute>
											<xsl:call-template name="CreateContact">
												<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/BuyerParty"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</Contact>
							</InvoicePartner>
						</xsl:if>
						<xsl:if test="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'TaxRepresentative']">
							<InvoicePartner>
								<Contact role="taxRepresentative">
									<xsl:attribute name="addressID">
										<xsl:value-of select="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'TaxRepresentative']/PartyID/Identifier/Ident"/>
									</xsl:attribute>
									<xsl:call-template name="CreateContact">
										<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'TaxRepresentative']"/>
									</xsl:call-template>
								</Contact>
								<IdReference domain="vatID">
									<xsl:attribute name="identifier">
										<xsl:value-of select="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'TaxRepresentative']/PartyID/Identifier/AgencyDescription"/>
									</xsl:attribute>
								</IdReference>
							</InvoicePartner>
						</xsl:if>
						<xsl:if test="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'subsequentBuyer']">
							<InvoicePartner>
								<Contact role="subsequentBuyer">
									<Name>
										<xsl:value-of select="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'subsequentBuyer']/PartyID/Identifier/Ident"/>
									</Name>
								</Contact>
								<IdReference domain="vatID">
									<xsl:attribute name="identifier">
										<xsl:value-of select="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'subsequentBuyer']/PartyID/Identifier/AgencyDescription"/>
									</xsl:attribute>
								</IdReference>
							</InvoicePartner>
						</xsl:if>
						<xsl:if test="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'Approver']">
							<InvoicePartner>
								<Contact role="requester">
									<Name>
										<xsl:value-of select="InvoiceHeader/InvoiceParty/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'Approver']/NameAddress/Name1"/>
									</Name>
									<Email>
										<xsl:value-of select="InvoiceParty/Invoice/InvoiceHeader/ListOfPartyCoded/PartyCoded[PartyRoleCodedOther = 'Approver']/OtherContacts/ListOfContact/Contact/ListOfContactNumber/ContactNumber[ContactNumberTypeCoded = 'Email']/ContactNumberValue"/>
									</Email>
								</Contact>
							</InvoicePartner>
						</xsl:if>
						<xsl:if test="contains(translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
							<InvoiceIDInfo>
								<xsl:attribute name="invoiceID">
									<xsl:value-of select="InvoiceHeader/InvoiceReferences/OtherInvoiceReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded = 'OriginalInvoiceNumber']/PrimaryReference/Reference/RefNum"/>
								</xsl:attribute>
								<xsl:if test="InvoiceHeader/InvoiceReferences/OtherInvoiceReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded = 'OriginalInvoiceNumber']/PrimaryReference/Reference/RefDate != ''">
									<xsl:attribute name="invoiceID">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/OtherInvoiceReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded = 'OriginalInvoiceNumber']/PrimaryReference/Reference/RefDate"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
							</InvoiceIDInfo>
						</xsl:if>
						<xsl:if test="InvoiceHeader/InvoiceParty/ShipToParty">
							<InvoiceDetailShipping>
								<Contact role="shipTo">
									<xsl:attribute name="addressID">
										<xsl:value-of select="InvoiceHeader/InvoiceParty/ShipToParty/Party/PartyID/Identifier/Ident"/>
									</xsl:attribute>
									<xsl:call-template name="CreateContact">
										<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/ShipToParty"/>
									</xsl:call-template>
								</Contact>
								<xsl:choose>
									<xsl:when test="InvoiceHeader/InvoiceParty/ShipFromParty">
										<Contact role="shipFrom">
											<xsl:attribute name="addressID">
												<xsl:value-of select="InvoiceHeader/InvoiceParty/ShipFromParty/Party/PartyID/Identifier/Ident"/>
											</xsl:attribute>
											<xsl:call-template name="CreateContact">
												<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/ShipFromParty"/>
											</xsl:call-template>
										</Contact>
									</xsl:when>
									<xsl:otherwise>
										<Contact role="shipFrom">
											<xsl:attribute name="addressID">
												<xsl:value-of select="InvoiceHeader/InvoiceParty/SellerParty/Party/PartyID/Identifier/Ident"/>
											</xsl:attribute>
											<xsl:call-template name="CreateContact">
												<xsl:with-param name="PartyInfo" select="InvoiceHeader/InvoiceParty/SellerParty"/>
											</xsl:call-template>
										</Contact>
									</xsl:otherwise>
								</xsl:choose>
							</InvoiceDetailShipping>
						</xsl:if>
						<xsl:if test="InvoiceHeader/InvoicePaymentInstructions/PaymentInstructions/PaymentTerms/PaymentTerm/PaymentTermDetails/Discounts/NetDaysDue != ''">
							<PaymentTerm>
								<xsl:attribute name="payInNumberOfDays">
									<xsl:value-of select="InvoiceHeader/InvoicePaymentInstructions/PaymentInstructions/PaymentTerms/PaymentTerm/PaymentTermDetails/Discounts/NetDaysDue"/>
								</xsl:attribute>
							</PaymentTerm>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="InvoiceHeader/InvoiceDates/InvoicingPeriod/ValidityDates">
								<Period>
									<xsl:attribute name="startDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="InvoiceHeader/InvoiceDates/InvoicingPeriod/ValidityDates/StartDate"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="endDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="InvoiceHeader/InvoiceDates/InvoicingPeriod/ValidityDates/EndDate"/>
										</xsl:call-template>
									</xsl:attribute>
								</Period>
							</xsl:when>
							<xsl:when test="InvoiceDetail/ListOfInvoiceItemDetail/InvoiceItemDetail/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded = 'ServicePeriodStart']/Date != '' and InvoiceDetail/ListOfInvoiceItemDetail/InvoiceItemDetail/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded = 'ServicePeriodEnd']/Date != ''">
								<Period>
									<xsl:attribute name="startDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="InvoiceDetail/ListOfInvoiceItemDetail/InvoiceItemDetail/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded = 'ServicePeriodStart']/Date"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="endDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="InvoiceDetail/ListOfInvoiceItemDetail/InvoiceItemDetail/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded = 'ServicePeriodEnd']/Date"/>
										</xsl:call-template>
									</xsl:attribute>
								</Period>
							</xsl:when>
						</xsl:choose>
						<Comments>
							<xsl:attribute name="xml:lang">
								<xsl:value-of select="InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
							</xsl:attribute>
							<xsl:value-of select="InvoiceHeader/InvoiceHeaderNote"/>
							<xsl:for-each select="InvoiceHeader/InvoiceHeaderAttachments/ListOfAttachment/Attachment">
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

						<xsl:if test="InvoiceHeader/InvoiceReferences/OtherInvoiceReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'InternalControlNumber']/PrimaryReference/Reference/RefNum != ''">
							<IdReference>
								<xsl:attribute name="domain">
									<xsl:value-of select="'supplierReference'"/>
								</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:value-of select="InvoiceHeader/InvoiceReferences/OtherInvoiceReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther = 'InternalControlNumber']/PrimaryReference/Reference/RefNum"/>
								</xsl:attribute>
							</IdReference>
						</xsl:if>
						<Extrinsic name="buyerVatID">
							<xsl:choose>
								<xsl:when test="InvoiceHeader/InvoiceParty/BuyerTaxInformation/PartyTaxInformation/TaxIdentifier/Identifier/Ident != ''">
									<xsl:value-of select="InvoiceHeader/InvoiceParty/BuyerTaxInformation/PartyTaxInformation/TaxIdentifier/Identifier/Ident"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="InvoiceHeader/InvoiceParty/BuyerTaxInformation/PartyTaxInformation/CompanyRegistrationNumber"/>
								</xsl:otherwise>
							</xsl:choose>
						</Extrinsic>
						<Extrinsic name="supplierVatID">
							<xsl:choose>
								<xsl:when test="InvoiceHeader/InvoiceParty/SellerTaxInformation/PartyTaxInformation/TaxIdentifier/Identifier/Ident != ''">
									<xsl:value-of select="InvoiceHeader/InvoiceParty/SellerTaxInformation/PartyTaxInformation/TaxIdentifier/Identifier/Ident"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="InvoiceHeader/InvoiceParty/SellerTaxInformation/PartyTaxInformation/CompanyRegistrationNumber"/>
								</xsl:otherwise>
							</xsl:choose>
						</Extrinsic>
					</InvoiceDetailRequestHeader>
					<InvoiceDetailOrder>
						<InvoiceDetailOrderInfo>
							<OrderReference>
								<xsl:if test="InvoiceHeader/InvoiceReferences/PurchaseOrderReference/PurchaseOrderNumber/Reference/RefNum != ''">
									<xsl:attribute name="orderID">
										<xsl:value-of select="InvoiceHeader/InvoiceReferences/PurchaseOrderReference/PurchaseOrderNumber/Reference/RefNum"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="InvoiceHeader/InvoiceReferences/PurchaseOrderReference/PurchaseOrderNumber/Reference/RefDate != ''">
									<xsl:attribute name="orderDate">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/PurchaseOrderReference/PurchaseOrderNumber/Reference/RefDate"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
								<DocumentReference>
									<xsl:attribute name="payloadID"> </xsl:attribute>
								</DocumentReference>
							</OrderReference>
							<xsl:if test="InvoiceHeader/InvoiceReferences/SupplierOrderNumber/Reference/RefNum != ''">
								<SupplierOrderInfo>
									<xsl:attribute name="orderID">
										<xsl:value-of select="InvoiceHeader/InvoiceReferences/SupplierOrderNumber/Reference/RefNum"/>
									</xsl:attribute>
								</SupplierOrderInfo>
							</xsl:if>
						</InvoiceDetailOrderInfo>
						<xsl:for-each select="InvoiceDetail/ListOfInvoiceItemDetail/InvoiceItemDetail">
							<xsl:variable name="parentLineNum">
								<xsl:value-of select="InvoiceBaseItemDetail/ParentItemNumber/LineItemNumberReference"/>
							</xsl:variable>
							<xsl:variable name="lNum" select="InvoiceBaseItemDetail/LineItemNum/BuyerLineItemNum"/>
							<xsl:variable name="itemType">
								<xsl:choose>
									<xsl:when test="$parentLineNum != ''">
										<xsl:value-of select="'item'"/>
									</xsl:when>
									<xsl:when test="InvoiceBaseItemDetail/ParentItemNumber/LineItemNumberReference = $lNum">
										<xsl:value-of select="'composite'"/>
									</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="InvoiceBaseItemDetail/LineItemType/LineItemTypeCodedOther = 'Services' or InvoiceBaseItemDetail/ItemIdentifiers/ListOfItemCharacteristic/ItemCharacteristic/ItemCharacteristicCoded = 'Services'">
									<InvoiceDetailServiceItem>
										<xsl:call-template name="createInvoiceDetailItem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="type" select="'Service'"/>
											<xsl:with-param name="parentLine" select="$parentLineNum"/>
											<xsl:with-param name="itemType" select="$itemType"/>
										</xsl:call-template>
									</InvoiceDetailServiceItem>
								</xsl:when>
								<xsl:otherwise>
									<InvoiceDetailItem>
										<xsl:call-template name="createInvoiceDetailItem">
											<xsl:with-param name="item" select="."/>
											<xsl:with-param name="parentLine" select="$parentLineNum"/>
											<xsl:with-param name="itemType" select="$itemType"/>
										</xsl:call-template>
									</InvoiceDetailItem>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</InvoiceDetailOrder>
					<InvoiceDetailSummary>
						<xsl:variable name="subTotal">

							<xsl:call-template name="CreditCheck">
								<xsl:with-param name="iscredit" select="translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
								<xsl:with-param name="value" select="InvoiceSummary/InvoiceTotals/GrossValue/MonetaryValue/MonetaryAmount"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="totalAllowances">
							<xsl:call-template name="CreditCheck">
								<xsl:with-param name="iscredit" select="translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
								<xsl:with-param name="value" select="sum(//ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Allowance']/TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="totalCharges">
							<xsl:call-template name="CreditCheck">
								<xsl:with-param name="iscredit" select="translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
								<xsl:with-param name="value" select="sum(//ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Charge']/TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="totalTax">
							<xsl:call-template name="CreditCheck">
								<xsl:with-param name="iscredit" select="translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
								<xsl:with-param name="value" select="InvoiceSummary/InvoiceTotals/TotalTaxAmount/MonetaryValue/MonetaryAmount"/>
							</xsl:call-template>
						</xsl:variable>
						<SubtotalAmount>
							<Money>
								<xsl:attribute name="currency">
									<xsl:value-of select="$invoiceCurrency"/>
								</xsl:attribute>
								<xsl:value-of select="$subTotal"/>
							</Money>
						</SubtotalAmount>

						<Tax>
							<xsl:if test="InvoiceSummary/InvoiceTotals/TotalTaxAmount/MonetaryValue/MonetaryAmount">

								<Money>
									<xsl:attribute name="currency">
										<xsl:value-of select="$invoiceCurrency"/>
									</xsl:attribute>
									<xsl:value-of select="$totalTax"/>
								</Money>
								<Description>
									<xsl:attribute name="xml:lang">
										<xsl:value-of select="InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
									</xsl:attribute>
								</Description>
							</xsl:if>
							<xsl:for-each select="//Tax[TaxFunctionQualifierCodedOther != 'SummaryTaxes']">
								<TaxDetail>
									<xsl:if test="TaxCategoryCoded = 'ValueAddedTaxDueFromAPreviousInvoice'">
										<xsl:attribute name="isVatRecoverable">
											<xsl:text>yes</xsl:text>
										</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="category">
										<xsl:choose>
											<xsl:when test="TaxTypeCoded = 'OtherTaxes'">Sales</xsl:when>
											<xsl:when test="TaxTypeCoded != 'Other'">
												<xsl:value-of select="TaxTypeCoded"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="TaxTypeCodedOther/Identifier/Ident != ''">
														<xsl:value-of select="TaxTypeCodedOther/Identifier/Ident"/>
													</xsl:when>
													<xsl:when test="TaxTypeCodedOther/Identifier/Ident = ''">Sales</xsl:when>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:if test="TaxPercent != ''">
										<xsl:attribute name="percentageRate">
											<xsl:value-of select="TaxPercent"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="/Invoice/InvoiceHeader/TaxPointDate">
										<xsl:attribute name="taxPointDate">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="input" select="/Invoice/InvoiceHeader/TaxPointDate"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:if>
									<TaxableAmount>
										<Money>
											<xsl:attribute name="currency">
												<xsl:value-of select="$invoiceCurrency"/>
											</xsl:attribute>
											<xsl:call-template name="CreditCheck">
												<xsl:with-param name="iscredit" select="translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
												<xsl:with-param name="value" select="TaxableAmount"/>
											</xsl:call-template>
										</Money>
									</TaxableAmount>
									<TaxAmount>
										<Money>
											<xsl:attribute name="currency">
												<xsl:value-of select="$invoiceCurrency"/>
											</xsl:attribute>
											<xsl:call-template name="CreditCheck">
												<xsl:with-param name="iscredit" select="translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
												<xsl:with-param name="value" select="TaxAmount"/>
											</xsl:call-template>
										</Money>
									</TaxAmount>
									<Description>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
										</xsl:attribute>
										<xsl:value-of select="ReasonTaxExemptCodedOther"/>
									</Description>
									<xsl:if test="TaxTypeCodedOther/Identifier[Agency/AgencyCodedOther = 'TriangularTransactionReference']/Ident != ''">
										<TriangularTransactionLawReference>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
											</xsl:attribute>
											<xsl:value-of select="TaxTypeCodedOther/Identifier[Agency/AgencyCodedOther = 'TriangularTransactionReference']/Ident"/>
										</TriangularTransactionLawReference>
									</xsl:if>
								</TaxDetail>
							</xsl:for-each>
						</Tax>
						<GrossAmount>

							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="InvoiceHeader/InvoiceCurrency/Currency"/>
								<xsl:with-param name="value" select="format-number(($subTotal + $totalTax + $totalCharges), '#0.00##')"/>
							</xsl:call-template>
						</GrossAmount>
						<xsl:if test="InvoiceHeader/InvoiceAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge">
							<InvoiceHeaderModifications>
								<xsl:for-each select="InvoiceHeader/InvoiceAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge">
									<xsl:variable name="serviceCode">
										<xsl:choose>
											<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded = 'Other'">
												<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<Modification>
										<xsl:choose>
											<xsl:when test="IndicatorCoded = 'Allowance'">
												<AdditionalDeduction>
													<xsl:if test="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount != ''">
														<DeductionAmount>
															<Money>
																<xsl:attribute name="currency">
																	<xsl:value-of select="$invoiceCurrency"/>
																</xsl:attribute>
																<xsl:call-template name="CreditCheck">
																	<xsl:with-param name="iscredit" select="translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
																	<xsl:with-param name="value" select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
																</xsl:call-template>
															</Money>
														</DeductionAmount>
													</xsl:if>
													<xsl:if test="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent != ''">
														<DeductionPercent>
															<xsl:attribute name="percent">
																<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent"/>
															</xsl:attribute>
														</DeductionPercent>
													</xsl:if>
												</AdditionalDeduction>
											</xsl:when>
											<xsl:when test="IndicatorCoded = 'Charge'">
												<AdditionalCost>
													<xsl:if test="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount != ''">
														<Money>
															<xsl:attribute name="currency">
																<xsl:value-of select="$invoiceCurrency"/>
															</xsl:attribute>
															<xsl:call-template name="CreditCheck">
																<xsl:with-param name="iscredit" select="translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
																<xsl:with-param name="value" select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
															</xsl:call-template>
														</Money>
													</xsl:if>
													<xsl:if test="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent != ''">
														<Percentage>
															<xsl:attribute name="percent">
																<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent"/>
															</xsl:attribute>
														</Percentage>
													</xsl:if>
												</AdditionalCost>
											</xsl:when>
										</xsl:choose>
										<xsl:if test="Tax">
											<Tax>
												<Money>
													<xsl:attribute name="currency">
														<xsl:value-of select="$invoiceCurrency"/>
													</xsl:attribute>
													<xsl:call-template name="CreditCheck">
														<xsl:with-param name="iscredit" select="translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
														<xsl:with-param name="value" select="Tax/TaxAmount"/>
													</xsl:call-template>
												</Money>
												<Description>
													<xsl:attribute name="xml:lang">
														<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
													</xsl:attribute>
												</Description>
												<xsl:for-each select="Tax">
													<TaxDetail>
														<xsl:attribute name="category">
															<xsl:choose>
																<xsl:when test="TaxTypeCoded = 'OtherTaxes'">Sales</xsl:when>
																<xsl:when test="TaxTypeCoded != 'Other'">
																	<xsl:value-of select="TaxTypeCoded"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:choose>
																		<xsl:when test="TaxTypeCodedOther/Identifier/Ident != ''">
																			<xsl:value-of select="TaxTypeCodedOther/Identifier/Ident"/>
																		</xsl:when>
																		<xsl:when test="TaxTypeCodedOther/Identifier/Ident = ''">Sales</xsl:when>
																	</xsl:choose>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:if test="TaxPercent">
															<xsl:attribute name="percentageRate">
																<xsl:value-of select="TaxPercent"/>
															</xsl:attribute>
														</xsl:if>
														<xsl:if test="TaxableAmount">
															<TaxableAmount>
																<Money>
																	<xsl:attribute name="currency">
																		<xsl:value-of select="$invoiceCurrency"/>
																	</xsl:attribute>
																	<xsl:call-template name="CreditCheck">
																		<xsl:with-param name="iscredit" select="translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
																		<xsl:with-param name="value" select="TaxableAmount"/>
																	</xsl:call-template>
																</Money>
															</TaxableAmount>
														</xsl:if>
														<TaxAmount>
															<Money>
																<xsl:attribute name="currency">
																	<xsl:value-of select="$invoiceCurrency"/>
																</xsl:attribute>
																<xsl:call-template name="CreditCheck">
																	<xsl:with-param name="iscredit" select="translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
																	<xsl:with-param name="value" select="TaxAmount"/>
																</xsl:call-template>
															</Money>
														</TaxAmount>
														<Description>
															<xsl:attribute name="xml:lang">
																<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
															</xsl:attribute>
															<xsl:value-of select="ReasonTaxExemptCodedOther"/>
														</Description>
														<xsl:if test="TaxLocation/Location/LocationIdentifier/LocID/Identifier/Ident != ''">
															<TaxLocation>
																<xsl:attribute name="xml:lang">
																	<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
																</xsl:attribute>
																<xsl:value-of select="TaxLocation/Location/LocationIdentifier/LocID/Identifier/Ident"/>
															</TaxLocation>
														</xsl:if>
													</TaxDetail>
												</xsl:for-each>
											</Tax>
										</xsl:if>
										<ModificationDetail>
											<xsl:if test="ValidityDates/EndDate">
												<xsl:attribute name="endDate">
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="ValidityDates/EndDate"/>
													</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test="ValidityDates/StartDate">
												<xsl:attribute name="startDate">
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="ValidityDates/StartDate"/>
													</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="name">
												<xsl:choose>
													<xsl:when test="$serviceCode/LookUp/Entry[xCBLCode = $serviceCode]/cXMLCode != ''">
														<xsl:value-of select="$serviceCodes/LookUp/Entry[xCBLCode = $serviceCode]/cXMLCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$serviceCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>

											<xsl:if test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded = 'Other'">
												<xsl:attribute name="code">
													<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
												</xsl:attribute>
											</xsl:if>

											<Description>
												<xsl:if test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language">
													<xsl:attribute name="xml:lang">
														<xsl:choose>
															<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LocaleCoded">
																<xsl:value-of select="concat(concat(AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LanguageCoded, ''), concat('-', AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LocaleCoded))"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="concat(AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LanguageCoded, '')"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
												</xsl:if>

												<xsl:choose>
													<xsl:when test="IndicatorCoded = 'Charges'">
														<xsl:choose>
															<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText != ''"> </xsl:when>
															<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded = 'Other'">
																<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText"/>
													</xsl:otherwise>
												</xsl:choose>
											</Description>
										</ModificationDetail>
									</Modification>
								</xsl:for-each>
							</InvoiceHeaderModifications>
						</xsl:if>

						<xsl:if test="format-number($totalCharges, '#0.00##') != '0.00' or format-number($totalCharges, '#0.00##') != '-0.00'">
							<TotalCharges>
								<xsl:call-template name="formatMoney">
									<xsl:with-param name="currency" select="InvoiceHeader/InvoiceCurrency/Currency"/>
									<xsl:with-param name="value" select="format-number($totalCharges, '#0.00##')"/>
								</xsl:call-template>
							</TotalCharges>
						</xsl:if>
						<xsl:if test="format-number($totalAllowances, '#0.00##') != '0.00' or format-number($totalAllowances, '#0.00##') != '-0.00'">
							<TotalAllowances>
								<xsl:call-template name="formatMoney">
									<xsl:with-param name="currency" select="InvoiceHeader/InvoiceCurrency/Currency"/>
									<xsl:with-param name="value" select="format-number($totalAllowances, '#0.00##')"/>
								</xsl:call-template>
							</TotalAllowances>
						</xsl:if>
						<TotalAmountWithoutTax>
							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="InvoiceHeader/InvoiceCurrency/Currency"/>
								<xsl:with-param name="value" select="format-number((($subTotal + $totalCharges) - $totalAllowances), '#0.00##')"/>
							</xsl:call-template>
						</TotalAmountWithoutTax>
						<NetAmount>
							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="InvoiceHeader/InvoiceCurrency/Currency"/>
								<xsl:with-param name="value" select="format-number((($subTotal + $totalTax + $totalCharges) - $totalAllowances), '#0.00##')"/>
							</xsl:call-template>
						</NetAmount>
						<xsl:if test="InvoiceSummary/InvoiceTotals/PrepaidAmount/MonetaryValue/MonetaryAmount">
							<DepositAmount>
								<Money>
									<xsl:attribute name="currency">
										<xsl:value-of select="$invoiceCurrency"/>
									</xsl:attribute>
									<xsl:call-template name="CreditCheck">
										<xsl:with-param name="iscredit" select="translate(InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha)"/>
										<xsl:with-param name="value" select="InvoiceSummary/InvoiceTotals/PrepaidAmount/MonetaryValue/MonetaryAmount"/>
									</xsl:call-template>
								</Money>
							</DepositAmount>
						</xsl:if>
						<DueAmount>
							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="InvoiceHeader/InvoiceCurrency/Currency"/>
								<xsl:with-param name="value" select="format-number((($subTotal + $totalTax + $totalCharges) - $totalAllowances), '#0.00##')"/>
							</xsl:call-template>
						</DueAmount>
					</InvoiceDetailSummary>
				</InvoiceDetailRequest>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template name="createInvoiceDetailItem">
		<xsl:param name="item"/>
		<xsl:param name="type"/>
		<xsl:param name="itemType"/>
		<xsl:param name="parentLine"/>

		<xsl:param name="validServiceCodes" select="'Allowance,ContractAllowance,Discount-Special,VolumeDiscount,AccessCharges,AccountNumberCorrectionCharge,AcidBattery,Adjustment,Carrier,Charge,Freight,FreightBasedOnDollarMinimum,Handling,Insurance,Royalties'"/>
		<xsl:attribute name="invoiceLineNumber">
			<xsl:choose>
				<xsl:when test="$item/InvoiceBaseItemDetail/LineItemNum/SellerLineItemNum != ''">
					<xsl:value-of select="$item/InvoiceBaseItemDetail/LineItemNum/SellerLineItemNum"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$item/InvoiceBaseItemDetail/LineItemNum/BuyerLineItemNum"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:variable name="invLineNum">
			<xsl:choose>
				<xsl:when test="$item/InvoiceBaseItemDetail/LineItemNum/SellerLineItemNum != ''">
					<xsl:value-of select="$item/InvoiceBaseItemDetail/LineItemNum/SellerLineItemNum"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$item/InvoiceBaseItemDetail/LineItemNum/BuyerLineItemNum"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:attribute name="quantity">
			<xsl:choose>
				<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
					<xsl:value-of select="concat('-', $item/InvoiceBaseItemDetail/TotalQuantity/Quantity/QuantityValue)"/>
				</xsl:when>
				<xsl:when test="/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCodedOther = 'CTE'">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$item/InvoiceBaseItemDetail/TotalQuantity/Quantity/QuantityValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<xsl:if test="string-length($parentLine) &gt; 0">
			<xsl:attribute name="parentInvoiceLineNumber">
				<xsl:value-of select="$parentLine"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length($itemType) &gt; 2">
			<xsl:attribute name="itemType">
				<xsl:value-of select="$itemType"/>
			</xsl:attribute>
		</xsl:if>

		<xsl:if test="$type != 'Service'">
			<xsl:choose>
				<xsl:when test="$item/InvoiceBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded = 'Other'">
					<UnitOfMeasure>
						<xsl:value-of select="$item/InvoiceBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
					</UnitOfMeasure>
				</xsl:when>
				<xsl:otherwise>
					<UnitOfMeasure>
						<xsl:value-of select="$item/InvoiceBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
					</UnitOfMeasure>
				</xsl:otherwise>
			</xsl:choose>
			<UnitPrice>
				<xsl:call-template name="formatMoney">
					<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
					<xsl:with-param name="value" select="concat($item/InvoicePricingDetail/ListOfPrice/Price/UnitPrice/UnitPriceValue, '')"/>
				</xsl:call-template>
			</UnitPrice>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$type = 'Service'">
				<InvoiceDetailServiceItemReference>
					<xsl:attribute name="lineNumber">
						<xsl:choose>
							<xsl:when test="$item/InvoiceBaseItemDetail/LineItemReferences/InvoiceReferences/PurchaseOrderReference/PurchaseOrderLineItemNumber">
								<xsl:value-of select="$item/InvoiceBaseItemDetail/LineItemReferences/InvoiceReferences/PurchaseOrderReference/PurchaseOrderLineItemNumber"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$invLineNum"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<ItemID>
						<SupplierPartID>
							<xsl:choose>
								<xsl:when test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID">
									<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'Not Available'"/>
								</xsl:otherwise>
							</xsl:choose>
						</SupplierPartID>

						<xsl:if
							test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' or $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '' or $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != ''">
							<SupplierPartAuxiliaryID>
								<xsl:choose>
									<xsl:when
										test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != ''">
										<xsl:value-of
											select="concat($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier)"
										/>
									</xsl:when>
									<xsl:when
										test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '' and not($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != '')">
										<xsl:value-of select="concat($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier)"/>
									</xsl:when>
									<xsl:when
										test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != '' and not($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '')">
										<xsl:value-of select="concat($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier)"/>
									</xsl:when>

									<xsl:when test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != ''">
										<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt"/>
									</xsl:when>
								</xsl:choose>
							</SupplierPartAuxiliaryID>
						</xsl:if>
					</ItemID>
					<xsl:if test="$item/InvoiceBaseItemDetail/ItemIdentifiers/ItemDescription != ''">
						<Description>
							<xsl:attribute name="xml:lang">
								<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
							</xsl:attribute>
							<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/ItemDescription"/>
						</Description>
					</xsl:if>
				</InvoiceDetailServiceItemReference>
			</xsl:when>
			<xsl:otherwise>
				<InvoiceDetailItemReference>
					<xsl:attribute name="lineNumber">
						<xsl:choose>
							<xsl:when test="$item/InvoiceBaseItemDetail/LineItemReferences/InvoiceReferences/PurchaseOrderReference/PurchaseOrderLineItemNumber">
								<xsl:value-of select="$item/InvoiceBaseItemDetail/LineItemReferences/InvoiceReferences/PurchaseOrderReference/PurchaseOrderLineItemNumber"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$invLineNum"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<ItemID>
						<SupplierPartID>
							<xsl:choose>
								<xsl:when test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID">
									<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'Not Available'"/>
								</xsl:otherwise>
							</xsl:choose>
						</SupplierPartID>
						<xsl:if
							test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' or $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '' or $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != ''">
							<SupplierPartAuxiliaryID>
								<xsl:choose>
									<xsl:when
										test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != ''">
										<xsl:value-of
											select="concat($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier)"
										/>
									</xsl:when>
									<xsl:when
										test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '' and not($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != '')">
										<xsl:value-of select="concat($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier)"/>
									</xsl:when>
									<xsl:when
										test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != '' and $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier != '' and not($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier != '')">
										<xsl:value-of select="concat($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt, '-', $item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier)"/>
									</xsl:when>

									<xsl:when test="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt != ''">
										<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt"/>
									</xsl:when>
								</xsl:choose>
							</SupplierPartAuxiliaryID>
						</xsl:if>
					</ItemID>
					<xsl:if test="$item/InvoiceBaseItemDetail/ItemIdentifiers/ItemDescription != ''">
						<Description>
							<xsl:attribute name="xml:lang">
								<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
							</xsl:attribute>
							<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/ItemDescription"/>
						</Description>
					</xsl:if>
					<xsl:if test="normalize-space($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/ManufacturerPartNumber/PartNum/PartID) != '' and normalize-space($item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/ManufacturerPartNumber/ManufacturerID/Identifier/Ident) != ''">
						<ManufacturerPartID>
							<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/ManufacturerPartNumber/PartNum/PartID"/>
						</ManufacturerPartID>
						<ManufacturerName>
							<xsl:value-of select="$item/InvoiceBaseItemDetail/ItemIdentifiers/PartNumbers/ManufacturerPartNumber/ManufacturerID/Identifier/Ident"/>
						</ManufacturerName>
					</xsl:if>
				</InvoiceDetailItemReference>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="subTotalAmount">
			<xsl:choose>
				<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
					<xsl:value-of select="concat('-', $item/InvoicePricingDetail/TotalValue/MonetaryValue/MonetaryAmount)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($item/InvoicePricingDetail/TotalValue/MonetaryValue/MonetaryAmount, '')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<SubtotalAmount>
			<xsl:call-template name="formatMoney">
				<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
				<xsl:with-param name="value" select="$subTotalAmount"/>
			</xsl:call-template>
		</SubtotalAmount>
		<xsl:if test="$type = 'Service' and $item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate">
			<Period>
				<xsl:attribute name="startDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded = 'InvoicePeriodEnd']/Date">
						<xsl:attribute name="endDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded = 'InvoicePeriodEnd']/Date"/>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="endDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate"/>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</Period>
		</xsl:if>
		<xsl:if test="$type = 'Service'">
			<xsl:choose>
				<xsl:when test="$item/InvoiceBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded = 'Other'">
					<UnitOfMeasure>
						<xsl:value-of select="$item/InvoiceBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
					</UnitOfMeasure>
				</xsl:when>
				<xsl:otherwise>
					<UnitOfMeasure>
						<xsl:value-of select="$item/InvoiceBaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
					</UnitOfMeasure>
				</xsl:otherwise>
			</xsl:choose>
			<UnitPrice>
				<xsl:call-template name="formatMoney">
					<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
					<xsl:with-param name="value" select="concat($item/InvoicePricingDetail/ListOfPrice/Price/UnitPrice/UnitPriceValue, '')"/>
				</xsl:call-template>
			</UnitPrice>
		</xsl:if>
		<xsl:if test="$item/InvoicePricingDetail/Tax">
			<Tax>
				<xsl:call-template name="formatMoney">
					<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
					<xsl:with-param name="value">
						<xsl:choose>
							<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
								<xsl:value-of select="concat('-', sum($item/InvoicePricingDetail/Tax/TaxAmount))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="sum($item/InvoicePricingDetail/Tax/TaxAmount)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
				<Description>
					<xsl:attribute name="xml:lang">
						<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
					</xsl:attribute>
				</Description>
				<xsl:for-each select="$item/InvoicePricingDetail/Tax">
					<TaxDetail>
						<xsl:if test="TaxCategoryCoded = 'ValueAddedTaxDueFromAPreviousInvoice'">
							<xsl:attribute name="isVatRecoverable">
								<xsl:text>yes</xsl:text>
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="category">
							<xsl:choose>
								<xsl:when test="TaxTypeCoded = 'OtherTaxes'">Sales</xsl:when>
								<xsl:when test="TaxTypeCoded != 'Other'">
									<xsl:value-of select="TaxTypeCoded"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="TaxTypeCodedOther/Identifier/Ident != ''">
											<xsl:value-of select="TaxTypeCodedOther/Identifier/Ident"/>
										</xsl:when>
										<xsl:when test="TaxTypeCodedOther/Identifier/Ident = ''">Sales</xsl:when>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="percentageRate">
							<xsl:value-of select="TaxPercent"/>
						</xsl:attribute>
						<xsl:if test="/Invoice/InvoiceHeader/TaxPointDate">
							<xsl:attribute name="taxPointDate">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="input" select="/Invoice/InvoiceHeader/TaxPointDate"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<TaxableAmount>
							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
											<xsl:value-of select="concat('-', TaxableAmount)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="TaxableAmount"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</TaxableAmount>
						<TaxAmount>
							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
											<xsl:value-of select="concat('-', TaxAmount)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="TaxAmount"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</TaxAmount>
						<Description>
							<xsl:attribute name="xml:lang">
								<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
							</xsl:attribute>
							<xsl:value-of select="ReasonTaxExemptCodedOther"/>
						</Description>
						<TriangularTransactionLawReference>
							<xsl:attribute name="xml:lang">
								<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
							</xsl:attribute>
							<xsl:value-of select="TaxTypeCodedOther/Identifier[Agency/AgencyCodedOther = 'TriangularTransactionReference']/Ident"/>
						</TriangularTransactionLawReference>
					</TaxDetail>
				</xsl:for-each>
			</Tax>
		</xsl:if>

		<xsl:if test="$type != 'Service' and $item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate">
			<ShipNoticeIDInfo>
				<xsl:attribute name="shipNoticeID">
					<xsl:value-of select="''"/>
				</xsl:attribute>
				<IdReference>
					<xsl:attribute name="domain">
						<xsl:value-of select="'deliveryNoteDate'"/>
					</xsl:attribute>
					<xsl:attribute name="identifier">
						<xsl:value-of select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate"/>
					</xsl:attribute>
				</IdReference>
			</ShipNoticeIDInfo>
		</xsl:if>

		<xsl:variable name="invoiceCurrency">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/InvoiceCurrency/Currency/CurrencyCoded = 'Other'">
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency/CurrencyCodedOther"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency/CurrencyCoded"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="totalCharges">
			<xsl:choose>
				<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
					<xsl:value-of select="concat('-', sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Charge']/TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Charge']/TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="totalAllowances">
			<xsl:choose>
				<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
					<xsl:value-of select="concat('-', sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Allowance']/TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Allowance']/TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="totalTax">
			<xsl:choose>
				<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
					<xsl:value-of select="concat('-', sum($item/InvoicePricingDetail/Tax/TaxAmount))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="sum($item/InvoicePricingDetail/Tax/TaxAmount)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="totalTaxCharges">
			<xsl:choose>
				<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
					<xsl:value-of select="concat('-', sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Charge']/Tax/TaxAmount))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Charge']/Tax/TaxAmount)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="totalTaxAllowances">
			<xsl:choose>
				<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
					<xsl:value-of select="concat('-', sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Allowance']/Tax/TaxAmount))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="sum($item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[IndicatorCoded = 'Allowance']/Tax/TaxAmount)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<GrossAmount>
			<xsl:call-template name="formatMoney">
				<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
				<xsl:with-param name="value" select="format-number((($subTotalAmount + $totalTax + $totalCharges + $totalTaxCharges) - $totalTaxAllowances), '#0.00##')"/>
			</xsl:call-template>
		</GrossAmount>
		<xsl:if test="$item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge">
			<InvoiceItemModifications>
				<xsl:for-each select="$item/InvoicePricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge">
					<xsl:variable name="serviceCode">
						<xsl:choose>
							<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded = 'Other'">
								<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<Modification>
						<OriginalPrice>
							<xsl:call-template name="formatMoney">
								<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
								<xsl:with-param name="value" select="$item/InvoicePricingDetail/TotalValue/MonetaryValue/MonetaryAmount"/>
							</xsl:call-template>
						</OriginalPrice>
						<xsl:choose>
							<xsl:when test="IndicatorCoded = 'Allowance'">
								<AdditionalDeduction>
									<xsl:if test="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount != ''">
										<DeductionAmount>
											<xsl:call-template name="formatMoney">
												<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
												<xsl:with-param name="value">
													<xsl:choose>
														<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">

															<xsl:value-of select="concat('-', TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
											</xsl:call-template>
										</DeductionAmount>
									</xsl:if>
									<xsl:if test="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent != ''">
										<DeductionPercent>
											<xsl:attribute name="percent">
												<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent"/>
											</xsl:attribute>
										</DeductionPercent>
									</xsl:if>
								</AdditionalDeduction>
							</xsl:when>
							<xsl:when test="IndicatorCoded = 'Charge'">
								<AdditionalCost>
									<xsl:if test="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount != ''">
										<xsl:call-template name="formatMoney">
											<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
											<xsl:with-param name="value">
												<xsl:choose>
													<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
														<xsl:value-of select="concat('-', TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent != ''">
										<Percentage>
											<xsl:attribute name="percent">
												<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent"/>
											</xsl:attribute>
										</Percentage>
									</xsl:if>
								</AdditionalCost>
							</xsl:when>
						</xsl:choose>
						<xsl:if test="Tax">
							<Tax>
								<xsl:call-template name="formatMoney">
									<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
									<xsl:with-param name="value">
										<xsl:choose>
											<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">

												<xsl:value-of select="concat('-', Tax/TaxAmount)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="Tax/TaxAmount"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
								<Description>
									<xsl:attribute name="xml:lang">
										<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
									</xsl:attribute>
								</Description>
								<xsl:for-each select="Tax">
									<TaxDetail>
										<xsl:attribute name="category">
											<xsl:choose>
												<xsl:when test="TaxTypeCoded = 'OtherTaxes'">Sales</xsl:when>
												<xsl:when test="TaxTypeCoded != 'Other'">
													<xsl:value-of select="TaxTypeCoded"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="TaxTypeCodedOther/Identifier/Ident != ''">
															<xsl:value-of select="TaxTypeCodedOther/Identifier/Ident"/>
														</xsl:when>
														<xsl:when test="TaxTypeCodedOther/Identifier/Ident = ''">Sales</xsl:when>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:if test="TaxPercent">
											<xsl:attribute name="percentageRate">
												<xsl:value-of select="TaxPercent"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="TaxableAmount">
											<TaxableAmount>
												<xsl:call-template name="formatMoney">
													<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
													<xsl:with-param name="value">
														<xsl:choose>
															<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
																<xsl:value-of select="concat('-', TaxableAmount)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="TaxableAmount"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
												</xsl:call-template>
											</TaxableAmount>
										</xsl:if>
										<TaxAmount>
											<xsl:call-template name="formatMoney">
												<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
												<xsl:with-param name="value">
													<xsl:choose>
														<xsl:when test="contains(translate(/Invoice/InvoiceHeader/InvoiceType/InvoiceTypeCoded, $upperAlpha, $lowerAlpha), 'credit')">
															<xsl:value-of select="concat('-', TaxAmount)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="TaxAmount"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:with-param>
											</xsl:call-template>
										</TaxAmount>
										<Description>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
											</xsl:attribute>
											<xsl:value-of select="ReasonTaxExemptCodedOther"/>
										</Description>
										<xsl:if test="TaxLocation/Location/LocationIdentifier/LocID/Identifier/Ident != ''">
											<TaxLocation>
												<xsl:attribute name="xml:lang">
													<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
												</xsl:attribute>
												<xsl:value-of select="TaxLocation/Location/LocationIdentifier/LocID/Identifier/Ident"/>
											</TaxLocation>
										</xsl:if>
									</TaxDetail>
								</xsl:for-each>
							</Tax>
						</xsl:if>
						<ModificationDetail>
							<xsl:if test="ValidityDates/EndDate">
								<xsl:attribute name="endDate">
									<xsl:call-template name="formatDate">
										<xsl:with-param name="input" select="ValidityDates/EndDate"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="ValidityDates/StartDate">
								<xsl:attribute name="startDate">
									<xsl:call-template name="formatDate">
										<xsl:with-param name="input" select="ValidityDates/StartDate"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="name">
								<xsl:choose>
									<xsl:when test="$serviceCodes/LookUp/Entry[xCBLCode = $serviceCode]/cXMLCode != ''">
										<xsl:value-of select="$serviceCodes/LookUp/Entry[xCBLCode = $serviceCode]/cXMLCode"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$serviceCode"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<Description>
								<xsl:if test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language">
									<xsl:attribute name="xml:lang">
										<xsl:choose>
											<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LocaleCoded">
												<xsl:value-of select="concat(concat(AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LanguageCoded, ''), concat('-', AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LocaleCoded))"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat(AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/Language/LanguageCoded, '')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="IndicatorCoded = 'Charges'">
										<xsl:choose>
											<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText != ''"> </xsl:when>
											<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded = 'Other'">
												<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText"/>
									</xsl:otherwise>
								</xsl:choose>
							</Description>
						</ModificationDetail>
					</Modification>
				</xsl:for-each>
			</InvoiceItemModifications>
		</xsl:if>
		<xsl:if test="format-number($totalCharges, '#0.00##') != '0.00'">
			<TotalCharges>
				<xsl:call-template name="formatMoney">
					<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
					<xsl:with-param name="value" select="format-number($totalCharges, '#0.00##')"/>
				</xsl:call-template>
			</TotalCharges>
		</xsl:if>
		<xsl:if test="format-number($totalAllowances, '#0.00##') != '0.00'">
			<TotalAllowances>
				<xsl:call-template name="formatMoney">
					<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
					<xsl:with-param name="value" select="format-number($totalAllowances, '#0.00##')"/>
				</xsl:call-template>
			</TotalAllowances>
		</xsl:if>
		<TotalAmountWithoutTax>
			<xsl:call-template name="formatMoney">
				<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
				<xsl:with-param name="value" select="format-number(($subTotalAmount + $totalCharges - $totalAllowances), '#0.00##')"/>
			</xsl:call-template>
		</TotalAmountWithoutTax>
		<NetAmount>
			<xsl:call-template name="formatMoney">
				<xsl:with-param name="currency" select="/Invoice/InvoiceHeader/InvoiceCurrency/Currency"/>
				<xsl:with-param name="value" select="format-number(((($subTotalAmount + $totalTax + $totalCharges + $totalTaxCharges) - $totalTaxAllowances) - $totalAllowances), '#0.00##')"/>
			</xsl:call-template>
		</NetAmount>
		<Comments>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceLanguage/Language/LanguageCoded"/>
			</xsl:attribute>
			<xsl:value-of select="$item/LineItemNote"/>
			<xsl:for-each select="$item/ListOfStructuredNote/StructuredNote">
				<xsl:value-of select="concat(' ', GeneralNote)"/>
			</xsl:for-each>
		</Comments>
	</xsl:template>
</xsl:stylesheet>
