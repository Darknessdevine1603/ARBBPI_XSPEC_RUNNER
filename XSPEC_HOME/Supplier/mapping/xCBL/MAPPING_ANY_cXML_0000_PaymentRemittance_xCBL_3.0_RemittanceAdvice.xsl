<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="pd:HCIOWNERPID:Format_CXML_XCBL_common:Binary"/>
	<!--xsl:include href="Format_CXML_XCBL_common.xsl"/-->
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>

	<xsl:param name="timestamp" select="cXML/@timestamp"/>

	<xsl:template match="cXML/Request/PaymentRemittanceRequest">
		<RemittanceAdvice>
			<RemittanceAdviceHeader>
				<RemittanceAdvicePurpose>
					<Purpose>
						<xsl:choose>
							<xsl:when test="PaymentRemittanceRequestHeader/Extrinsic[@name = 'purpose']">
								<PurposeCoded>Other</PurposeCoded>
								<PurposeCodedOther>
									<xsl:value-of select="PaymentRemittanceRequestHeader/Extrinsic[@name = 'purpose']"/>
								</PurposeCodedOther>
							</xsl:when>
							<xsl:otherwise>
								<PurposeCoded>Original</PurposeCoded>
							</xsl:otherwise>
						</xsl:choose>
					</Purpose>
				</RemittanceAdvicePurpose>
				<RemittaceAdviceIssueDate>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="$timestamp"/>
					</xsl:call-template>
				</RemittaceAdviceIssueDate>
				<RemittanceAdviceID>
					<Reference>
						<RefNum>
							<xsl:value-of select="PaymentRemittanceRequestHeader/@paymentRemittanceID"/>
						</RefNum>
						<RefDate>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="$timestamp"/>
							</xsl:call-template>
						</RefDate>
					</Reference>
				</RemittanceAdviceID>
				<PaymentSettlementDate>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="PaymentRemittanceRequestHeader/@paymentDate"/>
					</xsl:call-template>
				</PaymentSettlementDate>
				<TotalAmountPaid>
					<MonetaryValue>
						<MonetaryAmount>
							<xsl:value-of select="translate(PaymentRemittanceSummary/NetAmount/Money, '-$,', '')"/>
						</MonetaryAmount>
					</MonetaryValue>
				</TotalAmountPaid>
				<PaymentCurrency>
					<Currency>
						<CurrencyCoded>
							<xsl:value-of select="PaymentRemittanceSummary/NetAmount/Money/@currency"/>
						</CurrencyCoded>
					</Currency>
				</PaymentCurrency>
				<Language>
					<LanguageCoded>
						<xsl:choose>
							<xsl:when test="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payer']/Name/@xml:lang != ''">
								<xsl:value-of select="translate(substring(PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payer']/Name/@xml:lang, 1, 2), $upperAlpha, $lowerAlpha)"/>
							</xsl:when>
							<xsl:when test="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']/Name/@xml:lang != ''">
								<xsl:value-of select="translate(substring(PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']/Name/@xml:lang, 1, 2), $upperAlpha, $lowerAlpha)"/>
							</xsl:when>
							<xsl:otherwise>en</xsl:otherwise>
						</xsl:choose>
					</LanguageCoded>
				</Language>
				<PaymentInstructions>
					<PaymentTerms>
						<PaymentTerm>
							<PaymentTermCoded>Other</PaymentTermCoded>
						</PaymentTerm>
					</PaymentTerms>
					<PaymentMethod>
						<xsl:variable name="paymentMeanCoded" select="PaymentRemittanceRequestHeader/PaymentMethod/@type"/>
						<PaymentMeanCoded>
							<xsl:choose>
								<xsl:when test="$paymentMeanCoded = 'cash'">Cash</xsl:when>
								<xsl:when test="$paymentMeanCoded = 'check'">Cheque</xsl:when>
								<xsl:when test="$paymentMeanCoded = 'creditCard'">CreditCard</xsl:when>
								<xsl:when test="$paymentMeanCoded = 'debitCard'">BankCard</xsl:when>
								<xsl:when test="$paymentMeanCoded = 'draft'">BankDraft</xsl:when>
								<xsl:when test="$paymentMeanCoded = 'wire'">WireTransfer</xsl:when>
								<xsl:otherwise>Other</xsl:otherwise>
							</xsl:choose>
						</PaymentMeanCoded>
						<xsl:if test="$paymentMeanCoded = 'other' or $paymentMeanCoded = 'ach'">
							<PaymentMeanCodedOther>
								<xsl:choose>
									<xsl:when test="$paymentMeanCoded = 'ach'">ACH</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentMethod/Description"/>
									</xsl:otherwise>
								</xsl:choose>
							</PaymentMeanCodedOther>
						</xsl:if>
						<xsl:if test="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']">
							<OriginatingFIAccount>
								<FIAccount>
									<AccountDetail>
										<AccountID>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankAccountID']/@identifier"/>
										</AccountID>
										<AccountTypeCoded>Other</AccountTypeCoded>
										<AccountTypeCodedOther>Other</AccountTypeCodedOther>
										<AccountName1>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payer']/Name"/>
										</AccountName1>
									</AccountDetail>
									<FinancialInstitution>
										<FinancialInstitutionID>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankBranchID']/@identifier"/>
										</FinancialInstitutionID>
										<FinancialInstitutionName>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']/Name"/>
										</FinancialInstitutionName>
									</FinancialInstitution>
								</FIAccount>
							</OriginatingFIAccount>
						</xsl:if>
						<xsl:if test="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']">
							<ReceivingFIAccount>
								<FIAccount>
									<AccountDetail>
										<AccountID>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankAccountID']/@identifier"/>
										</AccountID>
										<AccountTypeCoded>Other</AccountTypeCoded>
										<AccountTypeCodedOther>Other</AccountTypeCodedOther>
										<AccountName1>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']/Name"/>
										</AccountName1>
									</AccountDetail>
									<FinancialInstitution>
										<FinancialInstitutionID>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankBranchID']/@identifier"/>
										</FinancialInstitutionID>
										<FinancialInstitutionName>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']/Name"/>
										</FinancialInstitutionName>
									</FinancialInstitution>
								</FIAccount>
							</ReceivingFIAccount>
						</xsl:if>
					</PaymentMethod>
				</PaymentInstructions>
				<PaymentParty>
					<PayerParty>
						<xsl:call-template name="createInnerParty">
							<xsl:with-param name="Party" select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payer']"/>
							<xsl:with-param name="TPID" select="$anAlternativeSender"/>
						</xsl:call-template>
					</PayerParty>
					<PayeeParty>
						<xsl:call-template name="createParty">
							<xsl:with-param name="Party" select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']"/>
							<xsl:with-param name="TPID" select="$anAlternativeReceiver"/>
							<xsl:with-param name="TaxID" select="PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'taxID']/@identifier"/>
						</xsl:call-template>
					</PayeeParty>
					<xsl:if test="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']/@addressID">
						<SupplierParty>
							<Party>
								<PartyID>
									<Identifier>
										<Agency>
											<AgencyCoded>Other</AgencyCoded>
											<AgencyCodedOther>SAP Vendor ID</AgencyCodedOther>
											<AgencyDescription>
												<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']/@addressID"/>
											</AgencyDescription>
										</Agency>
										<Ident>
											<xsl:value-of select="PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']/@addressID"/>
										</Ident>
									</Identifier>
								</PartyID>
							</Party>
						</SupplierParty>
					</xsl:if>
				</PaymentParty>
				<xsl:if test="count(RemittanceDetail/PayableInfo/PayableInvoiceInfo/InvoiceIDInfo) = 1">
					<ListOfRemittanceAdviceReference>
						<ListOfReferenceCoded>
							<ReferenceCoded>
								<ReferenceTypeCoded>CommercialInvoiceNumber</ReferenceTypeCoded>
								<PrimaryReference>
									<Reference>
										<RefNum>
											<xsl:value-of select="concat(RemittanceDetail/PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID, '')"/>
										</RefNum>
										<xsl:if test="RemittanceDetail/PayableInfo/PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate">
											<RefDate>
												<xsl:call-template name="formatDate">
													<xsl:with-param name="DocDate" select="concat(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate, '')"/>
												</xsl:call-template>
											</RefDate>
										</xsl:if>
									</Reference>
								</PrimaryReference>
							</ReferenceCoded>
						</ListOfReferenceCoded>
					</ListOfRemittanceAdviceReference>
				</xsl:if>
				<xsl:if test="PaymentRemittanceRequestHeader/Comments != ''">
					<GeneralNote>
						<xsl:value-of select="PaymentRemittanceRequestHeader/Comments"/>
					</GeneralNote>
				</xsl:if>
			</RemittanceAdviceHeader>
			<ListOfRemittanceAdviceDetail>
				<RemittanceAdviceDetail>
					<ListOfInvoicingDetail>
						<xsl:for-each select="RemittanceDetail">
							<InvoicingDetail>
								<InvoicingDetailReference>
									<ReferenceCoded>
										<ReferenceTypeCoded>Other</ReferenceTypeCoded>
										<ReferenceTypeCodedOther>InvoiceNumber</ReferenceTypeCodedOther>
										<PrimaryReference>
											<Reference>
												<RefNum>
													<xsl:value-of select="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID"/>
												</RefNum>
												<xsl:if test="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate">
													<RefDate>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate"/>
														</xsl:call-template>
													</RefDate>
												</xsl:if>
											</Reference>
										</PrimaryReference>
									</ReferenceCoded>
								</InvoicingDetailReference>
								<InvoicingDetailAmountPaid>
									<MonetaryValue>
										<MonetaryAmount>
											<xsl:value-of select="translate(GrossAmount/Money, '-$,', '')"/>
										</MonetaryAmount>
										<xsl:if test="GrossAmount/Money/@currency != ''">
											<Currency>
												<CurrencyCoded>
													<xsl:value-of select="GrossAmount/Money/@currency"/>
												</CurrencyCoded>
											</Currency>
										</xsl:if>
									</MonetaryValue>
								</InvoicingDetailAmountPaid>
								<InvoicingItemDetail>
									<InvoiceItemDetail>
										<InvoiceBaseItemDetail>
											<LineItemNum>
												<BuyerLineItemNum>
													<xsl:value-of select="position()"/>
												</BuyerLineItemNum>
											</LineItemNum>
											<xsl:if test="PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID != ''">
												<LineItemReferences>
													<InvoiceReferences>
														<PurchaseOrderReference>
															<PurchaseOrderNumber>
																<Reference>
																	<RefNum>
																		<xsl:value-of select="PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID"/>
																	</RefNum>
																</Reference>
															</PurchaseOrderNumber>
															<xsl:if test="PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderDate">
																<PurchaseOrderDate>
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="DocDate" select="PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderDate"/>
																	</xsl:call-template>
																</PurchaseOrderDate>
															</xsl:if>
														</PurchaseOrderReference>
													</InvoiceReferences>
												</LineItemReferences>
											</xsl:if>
										</InvoiceBaseItemDetail>
										<InvoicePricingDetail>
											<ListOfPrice>
												<Price>
													<UnitPrice>
														<UnitPriceValue>0.00</UnitPriceValue>
													</UnitPrice>
												</Price>
											</ListOfPrice>
											<InvoiceCurrencyTotalValue>
												<MonetaryValue>
													<MonetaryAmount>0.00</MonetaryAmount>
												</MonetaryValue>
											</InvoiceCurrencyTotalValue>
										</InvoicePricingDetail>
										<xsl:if test="Extrinsic[@name = 'InvoiceDueDate']">
											<LineItemDates>
												<InvoiceDates>
													<InvoiceDueDate>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="Extrinsic[@name = 'InvoiceDueDate']"/>
														</xsl:call-template>
													</InvoiceDueDate>
												</InvoiceDates>
											</LineItemDates>
										</xsl:if>
									</InvoiceItemDetail>
								</InvoicingItemDetail>
								<xsl:if test="AdjustmentAmount/Money != ''">
									<ListOfAdjustments>
										<Adjustment>
											<AdjustmentReasonCoded>Other</AdjustmentReasonCoded>
											<AdjustmentReasonCodedOther>Other</AdjustmentReasonCodedOther>
											<AdjustmentAmount>
												<MonetaryValue>
													<MonetaryAmount>
														<xsl:value-of select="translate(AdjustmentAmount/Money, '-$,', '')"/>
													</MonetaryAmount>
													<xsl:if test="AdjustmentAmount/Money/@currency != ''">
														<Currency>
															<CurrencyCoded>
																<xsl:value-of select="AdjustmentAmount/Money/@currency"/>
															</CurrencyCoded>
														</Currency>
													</xsl:if>
												</MonetaryValue>
											</AdjustmentAmount>
											<ActualAmount>
												<MonetaryValue>
													<MonetaryAmount>
														<xsl:value-of select="translate(NetAmount/Money, '-$,', '')"/>
													</MonetaryAmount>
													<xsl:if test="NetAmount/Money/@currency != ''">
														<Currency>
															<CurrencyCoded>
																<xsl:value-of select="NetAmount/Money/@currency"/>
															</CurrencyCoded>
														</Currency>
													</xsl:if>
												</MonetaryValue>
											</ActualAmount>
										</Adjustment>
									</ListOfAdjustments>
								</xsl:if>
							</InvoicingDetail>
						</xsl:for-each>
					</ListOfInvoicingDetail>
					<xsl:if test="RemittanceDetail/Comments != ''">
						<GeneralNote>
							<xsl:value-of select="RemittanceDetail/Comments"/>
						</GeneralNote>
					</xsl:if>
				</RemittanceAdviceDetail>
			</ListOfRemittanceAdviceDetail>
			<RemittanceAdviceSummary>
				<PaymentRequestSummary>
					<TotalSettlementAmount>
						<MonetaryValue>
							<MonetaryAmount>
								<xsl:value-of select="translate(PaymentRemittanceSummary/NetAmount/Money, '-$,', '')"/>
							</MonetaryAmount>
							<xsl:if test="PaymentRemittanceSummary/NetAmount/Money/@currency != ''">
								<Currency>
									<CurrencyCoded>
										<xsl:value-of select="PaymentRemittanceSummary/NetAmount/Money/@currency"/>
									</CurrencyCoded>
								</Currency>
							</xsl:if>
						</MonetaryValue>
					</TotalSettlementAmount>
				</PaymentRequestSummary>
			</RemittanceAdviceSummary>
		</RemittanceAdvice>
	</xsl:template>

	<xsl:template match="cXML/Header | cXML/AttachmentList | cXML/text()"/>
</xsl:stylesheet>
