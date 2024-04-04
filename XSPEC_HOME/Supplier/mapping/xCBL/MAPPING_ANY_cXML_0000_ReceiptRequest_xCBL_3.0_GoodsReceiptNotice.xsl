<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:include href="pd:HCIOWNERPID:Format_CXML_XCBL_common:Binary"/>
	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>

	<xsl:template match="cXML/Request/ReceiptRequest">
		<Invoice>
			<InvoiceHeader>
				<InvoiceNumber>
					<Reference>
						<RefNum>
							<xsl:value-of select="ReceiptRequestHeader/@receiptID"/>
						</RefNum>
					</Reference>
				</InvoiceNumber>
				<InvoiceIssueDate>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="ReceiptRequestHeader/@receiptDate"/>
					</xsl:call-template>
				</InvoiceIssueDate>
				<InvoiceReferences>
					<PurchaseOrderReference>
						<PurchaseOrderNumber>
							<Reference>
								<xsl:choose>
									<xsl:when test="ReceiptOrder/ReceiptOrderInfo/OrderIDInfo/@orderID != ''">
										<RefNum>
											<xsl:value-of select="ReceiptOrder/ReceiptOrderInfo/OrderIDInfo/@orderID"/>
										</RefNum>
										<xsl:if test="ReceiptOrder/ReceiptOrderInfo/OrderIDInfo/@orderDate != ''">
											<RefDate>
												<xsl:call-template name="formatDate">
													<xsl:with-param name="DocDate" select="ReceiptOrder/ReceiptOrderInfo/OrderIDInfo/@orderDate"/>
												</xsl:call-template>
											</RefDate>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<RefNum>
											<xsl:value-of select="ReceiptOrder/ReceiptOrderInfo/OrderReference/@orderID"/>
										</RefNum>
										<xsl:if test="ReceiptOrder/ReceiptOrderInfo/OrderReference/@orderDate != ''">
											<RefDate>
												<xsl:call-template name="formatDate">
													<xsl:with-param name="DocDate" select="ReceiptOrder/ReceiptOrderInfo/OrderReference/@orderDate"/>
												</xsl:call-template>
											</RefDate>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</Reference>
						</PurchaseOrderNumber>
					</PurchaseOrderReference>
					<xsl:if test="ReceiptOrder/ReceiptOrderInfo/MasterAgreementReference/@agreementID != ''">
						<ContractReference>
							<Contract>
								<ContractID>
									<Identifier>
										<Ident>
											<xsl:value-of select="ReceiptOrder/ReceiptOrderInfo/MasterAgreementReference/@agreementID"/>
										</Ident>
									</Identifier>
								</ContractID>
							</Contract>
						</ContractReference>
					</xsl:if>
				</InvoiceReferences>
				<InvoicePurpose>
					<InvoicePurposeCoded>Original</InvoicePurposeCoded>
				</InvoicePurpose>
				<InvoiceType>
					<InvoiceTypeCoded>Other</InvoiceTypeCoded>
					<InvoiceTypeCodedOther>GoodsReceiptNotice</InvoiceTypeCodedOther>
				</InvoiceType>
				<InvoiceLanguage>
					<Language>
						<LanguageCoded>
							<xsl:value-of select="substring(/cXML/@xml:lang, 1, 2)"/>
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
										<CodeListIdentifierCoded>Other</CodeListIdentifierCoded>
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
										<CodeListIdentifierCoded>Other</CodeListIdentifierCoded>
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
				<xsl:if test="ReceiptRequestHeader/Extrinsic[@name = 'NoteID']">
					<ListOfStructuredNote>
						<xsl:for-each select="ReceiptRequestHeader/Extrinsic[@name = 'NoteID']">
							<StructuredNote>
								<GeneralNote>
									<xsl:value-of select="."/>
								</GeneralNote>
							</StructuredNote>
						</xsl:for-each>
					</ListOfStructuredNote>
				</xsl:if>
				<xsl:if test="ReceiptRequestHeader/Comments/Attachment">
					<InvoiceHeaderAttachments>
						<ListOfAttachment>
							<xsl:for-each select="ReceiptRequestHeader/Comments/Attachment">
								<Attachment>
									<AttachmentPurpose>Attachment</AttachmentPurpose>
									<FileName>
										<xsl:value-of select="substring-after(URL, 'cid:')"/>
									</FileName>
									<ReplacementFile>false</ReplacementFile>
									<AttachmentLocation>
										<xsl:value-of select="concat('urn:x-commerceone:package:com:commerceone:', substring-after(URL, 'cid:'))"/>
									</AttachmentLocation>
								</Attachment>
							</xsl:for-each>
						</ListOfAttachment>
					</InvoiceHeaderAttachments>
				</xsl:if>
			</InvoiceHeader>
			<InvoiceDetail>
				<ListOfInvoiceItemDetail>
					<xsl:for-each select="ReceiptOrder/ReceiptItem">
						<InvoiceItemDetail>
							<InvoiceBaseItemDetail>
								<LineItemNum>
									<BuyerLineItemNum>
										<xsl:value-of select="@receiptLineNumber"/>
									</BuyerLineItemNum>
								</LineItemNum>
								<ItemIdentifiers>
									<xsl:if test="ReceiptItemReference/ItemID/SupplierPartID != '' or ReceiptItemReference/ManufacturerPartID">
										<PartNumbers>
											<xsl:if test="ReceiptItemReference/ItemID/SupplierPartID != ''">
												<SellerPartNumber>
													<PartNum>
														<PartID>
															<xsl:value-of select="ReceiptItemReference/ItemID/SupplierPartID"/>
														</PartID>
														<xsl:if test="ReceiptItemReference/ItemID/SupplierPartAuxiliaryID != ''">
															<PartIDExt>
																<xsl:value-of select="ReceiptItemReference/ItemID/SupplierPartAuxiliaryID"/>
															</PartIDExt>
														</xsl:if>
													</PartNum>
												</SellerPartNumber>
											</xsl:if>
											<xsl:if test="ReceiptItemReference/ManufacturerPartID != ''">
												<ManufacturerPartNumber>
													<PartID>
														<xsl:value-of select="ReceiptItemReference/ManufacturerPartID"/>
													</PartID>
												</ManufacturerPartNumber>
											</xsl:if>
										</PartNumbers>
									</xsl:if>
									<ItemDescription>
										<xsl:value-of select="ReceiptItemReference/Description"/>
									</ItemDescription>
								</ItemIdentifiers>
								<TotalQuantity>
									<Quantity>
										<QuantityValue>
											<xsl:value-of select="@quantity"/>
										</QuantityValue>
										<UnitOfMeasurement>
											<UOMCoded>
												<xsl:value-of select="UnitRate/UnitOfMeasure"/>
											</UOMCoded>
										</UnitOfMeasurement>
									</Quantity>
								</TotalQuantity>
								<LineItemReferences>
									<InvoiceReferences>
										<PurchaseOrderReference>
											<PurchaseOrderNumber>
												<Reference>
													<RefNum>
														<xsl:value-of select="../ReceiptOrderInfo/OrderIDInfo/@orderID"/>
													</RefNum>
												</Reference>
											</PurchaseOrderNumber>
										</PurchaseOrderReference>
										<xsl:if test="ReceiptItemReference/ShipNoticeReference/@shipNoticeID != ''">
											<SupplierOrderNumber>
												<Reference>
													<RefNum>
														<xsl:value-of select="ReceiptItemReference/ShipNoticeReference/@shipNoticeID"/>
													</RefNum>
												</Reference>
											</SupplierOrderNumber>
										</xsl:if>
									</InvoiceReferences>
								</LineItemReferences>
							</InvoiceBaseItemDetail>
							<InvoicePricingDetail>
								<ListOfPrice>
									<Price>
										<UnitPrice>
											<UnitPriceValue>
												<xsl:value-of select="UnitRate/Money"/>
											</UnitPriceValue>
											<Currency>
												<CurrencyCoded>
													<xsl:value-of select="UnitRate/Money/@currency"/>
												</CurrencyCoded>
											</Currency>
											<UnitOfMeasurement>
												<UOMCoded>
													<xsl:value-of select="UnitRate/UnitOfMeasure"/>
												</UOMCoded>
											</UnitOfMeasurement>
										</UnitPrice>
										<xsl:if test="PriceBasisQuantity/@quantity != ''">
											<PriceBasisQuantity>
												<Quantity>
													<QuantityValue>
														<xsl:value-of select="PriceBasisQuantity/@quantity"/>
													</QuantityValue>
												</Quantity>
												<UnitOfMeasurement>
													<UOMCoded>Other</UOMCoded>
													<UOMCodedOther>
														<xsl:value-of select="PriceBasisQuantity/UnitOfMeasure"/>
													</UOMCodedOther>
												</UnitOfMeasurement>
											</PriceBasisQuantity>
										</xsl:if>
									</Price>
								</ListOfPrice>
								<InvoiceCurrencyTotalValue>
									<MonetaryValue>
										<MonetaryAmount>
											<xsl:value-of select="ReceivedAmount/Money"/>
										</MonetaryAmount>
										<Currency>
											<CurrencyCoded>
												<xsl:value-of select="ReceivedAmount/Money/@currency"/>
											</CurrencyCoded>
										</Currency>
									</MonetaryValue>
								</InvoiceCurrencyTotalValue>
							</InvoicePricingDetail>
							<xsl:if test="Extrinsic[@name = 'NoteID']">
								<ListOfStructuredNote>
									<xsl:for-each select="Extrinsic[@name = 'NoteID']">
										<StructuredNote>
											<GeneralNote>
												<xsl:value-of select="."/>
											</GeneralNote>
											<NoteID>NoteID</NoteID>
										</StructuredNote>
									</xsl:for-each>
								</ListOfStructuredNote>
							</xsl:if>
							<xsl:if test="Comments/Attachment">
								<LineItemAttachments>
									<ListOfAttachment>
										<xsl:for-each select="Comments/Attachment">
											<Attachment>
												<AttachmentPurpose>Attachment</AttachmentPurpose>
												<FileName>
													<xsl:value-of select="substring-after(URL, 'cid:urn:x-commerceone:package:com:commerceone:')"/>
												</FileName>
												<ReplacementFile>false</ReplacementFile>
												<AttachmentLocation>
													<xsl:value-of select="substring-after(URL, 'cid:')"/>
												</AttachmentLocation>
											</Attachment>
										</xsl:for-each>
									</ListOfAttachment>
								</LineItemAttachments>
							</xsl:if>
						</InvoiceItemDetail>
					</xsl:for-each>
				</ListOfInvoiceItemDetail>
			</InvoiceDetail>
			<InvoiceSummary>
				<InvoiceTotals>
					<NetValue>
						<MonetaryValue>
							<MonetaryAmount>
								<xsl:value-of select="Total/Money"/>
							</MonetaryAmount>
							<Currency>
								<CurrencyCoded>
									<xsl:value-of select="Total/Money/@currency"/>
								</CurrencyCoded>
							</Currency>
						</MonetaryValue>
					</NetValue>
					<GrossValue>
						<MonetaryValue>
							<MonetaryAmount>
								<xsl:value-of select="Total/Money"/>
							</MonetaryAmount>
							<Currency>
								<CurrencyCoded>
									<xsl:value-of select="Total/Money/@currency"/>
								</CurrencyCoded>
							</Currency>
						</MonetaryValue>
					</GrossValue>
				</InvoiceTotals>
			</InvoiceSummary>
		</Invoice>
	</xsl:template>

	<xsl:template match="text()"/>
</xsl:stylesheet>
