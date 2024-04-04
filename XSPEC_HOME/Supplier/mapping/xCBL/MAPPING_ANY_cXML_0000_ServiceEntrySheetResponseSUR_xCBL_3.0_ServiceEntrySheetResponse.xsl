<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="pd:HCIOWNERPID:Format_CXML_XCBL_common:Binary"/>
	<!--xsl:include href="Format_CXML_XCBL_common.xsl"/-->
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>

	<xsl:variable name="CurrentDate" select="current-dateTime()"/>

	<xsl:template match="/">
		<Invoice>
			<InvoiceHeader>
				<InvoiceNumber>
					<Reference>
						<RefNum>
							<xsl:value-of select="cXML/@payloadID"/>
						</RefNum>
						<RefDate>

							<xsl:value-of select="$CurrentDate"/>
						</RefDate>
					</Reference>
				</InvoiceNumber>
				<InvoiceIssueDate>
					<xsl:value-of select="$CurrentDate"/>
				</InvoiceIssueDate>
				<InvoiceReferences>
					<OtherInvoiceReferences>
						<ListOfReferenceCoded>
							<xsl:call-template name="createOtherReferences">
								<xsl:with-param name="refCode">ServiceEntrySheet</xsl:with-param>
								<xsl:with-param name="refValue">
									<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID"/>
								</xsl:with-param>
							</xsl:call-template>
						</ListOfReferenceCoded>
					</OtherInvoiceReferences>
				</InvoiceReferences>
				<InvoicePurpose>
					<InvoicePurposeCoded>Other</InvoicePurposeCoded>
					<InvoicePurposeCodedOther>
						<xsl:choose>
							<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/@type = 'approved'">Accepted</xsl:when>
							<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/@type = 'rejected'">NotAccepted</xsl:when>
						</xsl:choose>
					</InvoicePurposeCodedOther>
				</InvoicePurpose>
				<InvoiceType>
					<InvoiceTypeCoded>Other</InvoiceTypeCoded>
					<InvoiceTypeCodedOther>ServiceEntrySheetResponse</InvoiceTypeCodedOther>
				</InvoiceType>
				<InvoiceLanguage>
					<Language>
						<LanguageCoded>
							<xsl:choose>
								<xsl:when test="cXML/@xml:lang != ''">
									<xsl:value-of select="substring(cXML/@xml:lang, 1, 2)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'en'"/>
								</xsl:otherwise>
							</xsl:choose>
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
				<xsl:if test="cXML/Request/StatusUpdateRequest/DocumentStatus/Comments">
					<InvoiceHeaderNote>
						<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/Comments"/>
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
						<LineItemNote>This is a Dummy line item. Please refer to Invoice Header for the SESR Status</LineItemNote>
					</InvoiceItemDetail>
				</ListOfInvoiceItemDetail>
			</InvoiceDetail>
		</Invoice>
	</xsl:template>
</xsl:stylesheet>
