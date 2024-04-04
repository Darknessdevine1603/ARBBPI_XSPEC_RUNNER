<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="pd:HCIOWNERPID:Format_CXML_XCBL_common:Binary"/>
	<!--xsl:include href="Format_CXML_XCBL_common.xsl"/-->
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>

	<xsl:variable name="CurrentDate" select="current-date()"/>

	<xsl:template match="/">
		<Invoice>
			<InvoiceHeader>
				<InvoiceNumber>
					<Reference>
						<RefNum>
							<xsl:value-of select="cXML/@payloadID"/>
						</RefNum>
						<RefDate>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="substring(concat($CurrentDate, ''), 1, 10)"/>
							</xsl:call-template>
						</RefDate>
					</Reference>
				</InvoiceNumber>
				<InvoiceIssueDate>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="substring(concat($CurrentDate, ''), 1, 10)"/>
					</xsl:call-template>
				</InvoiceIssueDate>
				<InvoiceReferences>
					<OtherInvoiceReferences>
						<ListOfReferenceCoded>

							<ReferenceCoded>
								<ReferenceTypeCoded>Other</ReferenceTypeCoded>
								<ReferenceTypeCodedOther>OriginalInvoiceNumber</ReferenceTypeCodedOther>
								<PrimaryReference>
									<Reference>
										<RefNum>
											<xsl:value-of select="cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID"/>
										</RefNum>
									</Reference>
								</PrimaryReference>
							</ReferenceCoded>
						</ListOfReferenceCoded>
					</OtherInvoiceReferences>
				</InvoiceReferences>
				<xsl:variable name="INVRStatus" select="concat(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type, '')"/>
				<InvoicePurpose>
					<InvoicePurposeCoded>Other</InvoicePurposeCoded>
					<InvoicePurposeCodedOther>
						<xsl:choose>
							<xsl:when test="$INVRStatus = 'processing'">In Progress</xsl:when>
							<xsl:when test="$INVRStatus = 'reconciled'">Approved</xsl:when>
							<xsl:when test="$INVRStatus = 'rejected'">Rejected</xsl:when>
							<xsl:when test="$INVRStatus = 'paid'">Paid</xsl:when>
							<xsl:when test="$INVRStatus = 'paying'">Approved</xsl:when>
							<xsl:otherwise>Other</xsl:otherwise>
						</xsl:choose>
					</InvoicePurposeCodedOther>
				</InvoicePurpose>
				<InvoiceType>
					<InvoiceTypeCoded>Other</InvoiceTypeCoded>
					<InvoiceTypeCodedOther>InvoiceResponse</InvoiceTypeCodedOther>
				</InvoiceType>
				<InvoiceLanguage>
					<Language>
						<LanguageCoded>
							<xsl:value-of select="substring(cXML/@xml:lang, 1, 2)"/>
						</LanguageCoded>
					</Language>
				</InvoiceLanguage>
				<InvoiceParty>
					<BuyerParty>
						<Party>
							<PartyID>
								<Identifier>
									<Agency>
										<AgencyCoded>Other</AgencyCoded>
										<AgencyCodedOther>Other</AgencyCodedOther>
										<CodeListIdentifierCoded>
											<xsl:text>Other</xsl:text>
										</CodeListIdentifierCoded>
										<CodeListIdentifierCodedOther>
											<xsl:value-of select="$anAlternativeSender"/>
										</CodeListIdentifierCodedOther>
									</Agency>
									<Ident/>
								</Identifier>
							</PartyID>
						</Party>
					</BuyerParty>
					<SellerParty>
						<Party>
							<PartyID>
								<Identifier>
									<Agency>
										<AgencyCoded>Other</AgencyCoded>
										<AgencyCodedOther>Other</AgencyCodedOther>
										<CodeListIdentifierCoded>
											<xsl:text>Other</xsl:text>
										</CodeListIdentifierCoded>
										<CodeListIdentifierCodedOther>
											<xsl:value-of select="$anAlternativeReceiver"/>
										</CodeListIdentifierCodedOther>
									</Agency>
									<Ident/>
								</Identifier>
							</PartyID>
						</Party>
					</SellerParty>
				</InvoiceParty>
				<xsl:if test="cXML/Request/StatusUpdateRequest/InvoiceStatus/Comments/text()">
					<InvoiceHeaderNote>
						<xsl:value-of select="concat(cXML/Request/StatusUpdateRequest/InvoiceStatus/Comments/text(), '')"/>
					</InvoiceHeaderNote>
				</xsl:if>
			</InvoiceHeader>
			<InvoiceDetail>
				<ListOfInvoiceItemDetail>

					<InvoiceItemDetail>
						<InvoiceBaseItemDetail>
							<LineItemNum>
								<BuyerLineItemNum>1</BuyerLineItemNum>
							</LineItemNum>
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
						<LineItemNote>This is a Dummy line item. Please refer to Invoice Header for the INVR Status</LineItemNote>
					</InvoiceItemDetail>
				</ListOfInvoiceItemDetail>
			</InvoiceDetail>
		</Invoice>
	</xsl:template>
</xsl:stylesheet>
