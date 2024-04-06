<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n0="http://sap.com/xi/ARBCIG2" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:variable name="v_date">
		<xsl:value-of select="current-date()"/>
	</xsl:variable>
	<!-- parameter -->
	<xsl:param name="anReceiverID"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anERPTimeZone"/>
	<xsl:param name="anSourceDocumentType"/>
	<!--Local Testing-->
<!--	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
	<!--    System ID incase of MultiERP-->
	<xsl:variable name="v_sysid">
		<xsl:call-template name="MultiErpSysIdIN">
			<xsl:with-param name="p_ansysid"
				select="/Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
			<xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
		</xsl:call-template>
	</xsl:variable>
	<!--PD path    -->
	<xsl:variable name="v_pd">
		<xsl:call-template name="PrepareCrossref">
			<xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
			<xsl:with-param name="p_erpsysid" select="$v_sysid"/>
			<xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
		</xsl:call-template>
	</xsl:variable>
	<!--Get the Language code-->
	<xsl:variable name="v_lang">
		<xsl:call-template name="FillDefaultLang">
			<xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
		</xsl:call-template>
	</xsl:variable>
	<!--Get the Language code-->
	<xsl:variable name="v_quoteDate">
		<xsl:value-of
			select="/Combined/Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteDate"/>
	</xsl:variable>
	<!--CI-1779 PrivateID / VendorID-->
	<!--If PrivateID is not available pass VendorID  -->
	<!--Either Privateid or VendorID should always Exists -->
	<xsl:variable name="v_vendorId">
		<xsl:choose>
			<xsl:when test="exists(Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity)">
				<xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	
	<!--    Main template-->
	<xsl:template match="Combined">
		<n0:PurchasingContractERPRequest_V1 xmlns:n0="http://sap.com/xi/ARBCIG2">
			<MessageHeader>
				<CreationDateTime>
					<xsl:variable name="v_date">
						<xsl:call-template name="ERPDateTime">
							<xsl:with-param name="p_date" select="$v_quoteDate"/>
							<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
						</xsl:call-template>
					</xsl:variable>
					<!--Convert the final date into SAP format is 'YYYYMMDD'-->
					<xsl:value-of select="substring($v_date, 1, 10)"/>
				</CreationDateTime>
				<SenderBusinessSystemID>
					<xsl:value-of select="'SOURCING'"/>
				</SenderBusinessSystemID>
				<RecipientBusinessSystemID>
					<xsl:value-of select="$anERPSystemID"/>
				</RecipientBusinessSystemID>
				<SenderParty> </SenderParty>
			</MessageHeader>
			<PurchasingContract>
				<xsl:attribute name="actionCode">
					<xsl:value-of select="'01'"/>
				</xsl:attribute>
				<xsl:attribute name="itemListCompleteTransmissionIndicator">
					<xsl:value-of select="'true'"/>
				</xsl:attribute>
				<xsl:if
					test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic/@name = 'SourcingEventId'">
					<ID>
						<xsl:attribute name="schemeID">
							<xsl:value-of
								select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'SourcingEventId']"
							/>
						</xsl:attribute>
					</ID>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier != ''">
					<CompanyID>
						<xsl:value-of
							select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
						/>
					</CompanyID>
				</xsl:if>
				<ProcessingTypeCode>
					<xsl:value-of
						select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/FollowUpDocument/@category"
					/>
				</ProcessingTypeCode>
				<!--<xsl:if test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate' or 'ValidityEndDate']">-->
				<ValidityPeriod>
					<StartDate>
						<xsl:choose>
							<xsl:when
								test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']">
								<xsl:variable name="v_date">
									<xsl:call-template name="ERPDateTime">
										<xsl:with-param name="p_date"
											select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']"/>
										<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
									</xsl:call-template>
								</xsl:variable>
								<!--Convert the final date into SAP format is 'YYYYMMDD'-->
								<xsl:value-of select="substring($v_date, 1, 10)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="substring(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteDate, 1, 10)"
								/>
							</xsl:otherwise>
						</xsl:choose>
					</StartDate>
					<xsl:choose>
						<xsl:when
							test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']">
							<xsl:variable name="v_date">
								<xsl:call-template name="ERPDateTime">
									<xsl:with-param name="p_date"
										select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']"/>
									<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
								</xsl:call-template>
							</xsl:variable>
							<EndDate>
								<xsl:value-of select="substring($v_date, 1, 10)"/>
							</EndDate>
						</xsl:when>
						<xsl:otherwise>
							<EndDate>
								<xsl:value-of select="'9999-12-31'"/>
							</EndDate>
						</xsl:otherwise>
					</xsl:choose>
				</ValidityPeriod>
				<!--</xsl:if>-->
				<ExchangeRate>
					<ExchangeRate>
						<UnitCurrency>
							<xsl:value-of
								select="Payload/cXML/Message/QuoteMessage/QuoteItemIn[1]/ItemDetail/UnitPrice/Money/@currency"
							/>
						</UnitCurrency>
						<QuotedCurrency>
							<xsl:value-of
								select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@currency"
							/>
						</QuotedCurrency>
						<Rate>
							<xsl:value-of select="'0'"/>
						</Rate>
						<QuotationDateTime>
							<xsl:variable name="v_date">
								<xsl:call-template name="ERPDateTime">
									<xsl:with-param name="p_date" select="$v_quoteDate"/>
									<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="substring($v_date, 1, 10)"/>
						</QuotationDateTime>
					</ExchangeRate>
					<ExchangeRateFixedIndicator>
						<xsl:value-of select="'1'"/>
					</ExchangeRateFixedIndicator>
				</ExchangeRate>
				<xsl:if
					test="normalize-space(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Total/Money) != ''">
					<TargetAmount>
						<xsl:attribute name="currencyCode">
							<xsl:value-of
								select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Total/Money/@currency"
							/>
						</xsl:attribute>
						<xsl:value-of
							select="normalize-space(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Total/Money)"
						/>
					</TargetAmount>
				</xsl:if>
				<xsl:if test="string-length($v_vendorId) > 0">
					<SellerParty>
						<InternalID>
							<xsl:value-of select='$v_vendorId'/>
						</InternalID>
						<BuyerID>
							<xsl:value-of select='$v_vendorId'/>
						</BuyerID>
					</SellerParty>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier != ''">
					<ResponsiblePurchasingOrganisationParty>
						<InternalID>
							<xsl:value-of
								select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier"
							/>
						</InternalID>
					</ResponsiblePurchasingOrganisationParty>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier != ''">
					<ResponsiblePurchasingGroupParty>
						<InternalID>
							<xsl:value-of
								select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier"
							/>
						</InternalID>
					</ResponsiblePurchasingGroupParty>
				</xsl:if>
				<!--    CI-1844 : Populate the Service Contract Header Partners structure    --> 
				<xsl:if test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
					<!--    Loop over the Header Partners and populate the Party structures   --> 
					<xsl:for-each select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/SupplierProductionFacilityRelations/ProductionFacilityAssociation">                   
						<Party>
							<xsl:attribute name="actionCode">
								<xsl:value-of select="'01'"/>
							</xsl:attribute>
							<InternalID>
								<xsl:value-of select="ProductionFacility/IdReference/@identifier"/>									
							</InternalID> 
							<ResponsiblePurchasingOrganisationParty>
								<BuyerID>
									<xsl:value-of select="OrganizationalUnit/IdReference/@identifier"/>
								</BuyerID>
							</ResponsiblePurchasingOrganisationParty>                            
							<RoleCode>
								<xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
							</RoleCode>
							<DefaultIndicator></DefaultIndicator>
						</Party>                   
					</xsl:for-each>
				</xsl:if> 				
				<xsl:if
					test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/PaymentTerms[1]/@paymentTermCode)">
					<CashDiscountTerms>
						<Code>
							<xsl:value-of
								select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/PaymentTerms[1]/@paymentTermCode"
							/>
						</Code>
					</CashDiscountTerms>
				</xsl:if>
				<!--                Text Collection-->
				<xsl:if test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Comments)">
					<TextCollection>
						<Text>
							<xsl:attribute name="actionCode">
								<xsl:choose>
									<xsl:when
										test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@operation = 'new'"
										>
										<xsl:value-of select="'01'"/>
									</xsl:when>
									<xsl:when
										test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@operation = 'update'"
										>
										<xsl:value-of select="'02'"/>
									</xsl:when>
									<xsl:when
										test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@operation = 'delete'"
										>
										<xsl:value-of select="'03'"/>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<TypeCode>
								<xsl:value-of>
									<xsl:call-template name="ReadQuote">
										<xsl:with-param name="p_doctype"
											select="'QuoteMessageContractServices'"/>
										<xsl:with-param name="p_pd" select="$v_pd"/>
										<xsl:with-param name="p_attribute"
											select="'HeaderTextTypecode'"/>
									</xsl:call-template>
								</xsl:value-of>
							</TypeCode>
							<ContentText>
								<xsl:attribute name="languageCode">
									<xsl:value-of
										select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Comments/@xml:lang"
									/>
								</xsl:attribute>
								<xsl:variable name="v_comments">
									<xsl:call-template name="removeChild">
										<xsl:with-param name="p_comment"
											select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Comments"
										/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="normalize-space($v_comments)"/>
							</ContentText>
						</Text>
					</TextCollection>
				</xsl:if>
				<xsl:for-each select="Payload/cXML/Message/QuoteMessage/QuoteItemIn">
					<Item>
						<xsl:attribute name="actionCode">
							<xsl:value-of select="'01'"/>
						</xsl:attribute>
						<ID>
							<xsl:value-of select="@lineNumber"/>
						</ID>
						<TypeCode>
							<xsl:choose>
								<xsl:when test="normalize-space(@serviceLineType) != ''">
									<xsl:choose>
										<xsl:when test="@serviceLineType = 'contingency'">
											<xsl:value-of select="'302'"/>
										</xsl:when>
										<xsl:when test="@serviceLineType = 'blanket'">
											<xsl:value-of select="'301'"/>
										</xsl:when>
										<xsl:when test="@serviceLineType = 'information'">
											<xsl:value-of select="'305'"/>
										</xsl:when>
										<xsl:when test="@serviceLineType = 'openquantity'">
											<xsl:value-of select="'303'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when
									test="normalize-space(@itemType) = 'composite' and normalize-space(@parentLineNumber) != ''"
									>
									<xsl:value-of select="'21'"/>
								</xsl:when>
								<xsl:when test="normalize-space(@itemClassification) != ''">
									<xsl:choose>
										<xsl:when
											test="normalize-space(@itemClassification) = 'service'"
											>
											<xsl:value-of select="'9'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(@itemClassification) = 'material'"
											>
											<xsl:value-of select="'0'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</TypeCode>
						<xsl:if test="normalize-space(@itemClassification) != ''">
							<ProcessingTypeCode>
								<xsl:choose>
									<xsl:when
										test="normalize-space(@itemClassification) = 'service'"
										>
										<xsl:value-of select="'9'"/>
									</xsl:when>
									<xsl:when
										test="normalize-space(@itemClassification) = 'material'"
										>
										<xsl:value-of select="'0'"/>
									</xsl:when>
								</xsl:choose>
							</ProcessingTypeCode>
						</xsl:if>
						<CancelledIndicator>
							<xsl:value-of select="'0'"/>
						</CancelledIndicator>
						<BlockedIndicator>
							<xsl:value-of select="'0'"/>
						</BlockedIndicator>
						<!--condition-->
						<TargetQuantity>
							<xsl:attribute name="unitCode">
								<xsl:value-of select="ItemDetail/UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="@quantity"/>
						</TargetQuantity>
						<xsl:if
							test="normalize-space(@itemType) = 'composite' and normalize-space(@parentLineNumber) != ''">
							<FormattedName>
								<xsl:value-of select="ItemDetail/Description/ShortName"/>
							</FormattedName>
						</xsl:if>
						<xsl:if test="normalize-space(@parentLineNumber) != ''">
							<HierarchyRelationship>
								<ParentItemID>
									<xsl:choose>
										<xsl:when test="normalize-space(@itemType) = 'composite'">
											<xsl:value-of select= "@parentLineNumber"/>
										</xsl:when>
										<xsl:otherwise>											
											<xsl:value-of select= "format-number(@parentLineNumber, '0000000000')"/>
										</xsl:otherwise>
									</xsl:choose>									
								</ParentItemID>
								<TypeCode>
									<xsl:value-of select="'007'"/>
								</TypeCode>
							</HierarchyRelationship>
						</xsl:if>
						<xsl:if test="normalize-space(ItemID/BuyerPartID) != ''">
							<Product>
								<InternalID>
									<xsl:value-of select="ItemID/BuyerPartID"/>
								</InternalID>
								<SellerID>
									<xsl:value-of select="ItemID/SupplierPartID"/>
								</SellerID>
								<xsl:if test="ItemDetail/ManufacturerPartID != ''">
									<ManufacturerID>
										<xsl:value-of select="ItemDetail/ManufacturerPartID"/>
									</ManufacturerID>
								</xsl:if>
							</Product>
						</xsl:if>
						<ProductCategory>
							<xsl:if test="ItemDetail/Classification[@domain = 'MaterialGroup']">
								<InternalID>
									<xsl:value-of select="ItemDetail/Classification/@code"/>
								</InternalID>
							</xsl:if>
							<xsl:if test="ItemDetail/Classification[@domain = 'MaterialGroup']">
								<BuyerID>
									<xsl:value-of select="ItemDetail/Classification/@code"/>
								</BuyerID>
							</xsl:if>
						</ProductCategory>
						<!--gross price-->
						<xsl:if test="@itemType = 'composite' and not(@parentLineNumber)">
							<PriceSpecificationElement>
								<xsl:attribute name="actionCode">
									<xsl:value-of select="'01'"/>
								</xsl:attribute>
								<xsl:if test="@itemClassification = 'service'">
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'grosspriceTypecode'"/>
											</xsl:call-template>
										</xsl:value-of>
									</TypeCode>
								</xsl:if>
								<CategoryCode>
									<xsl:value-of select="'1'"/>
								</CategoryCode>
								<ValidityPeriod>
									<IntervalBoundaryTypeCode>
										<xsl:value-of select="'9'"/>
									</IntervalBoundaryTypeCode>
									<StartTimePoint>
										<TypeCode>
											<xsl:value-of select="'1'"/>
										</TypeCode>
										<Date>
											<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate) > 0">
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="$v_quoteDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:otherwise>
											</xsl:choose>
										</Date>
									</StartTimePoint>
									<EndTimePoint>
										<TypeCode>
											<xsl:value-of select="'1'"/>
										</TypeCode>
										<Date>
											<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate) > 0">
												<xsl:value-of
												select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate, 1, 10)"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'9999-12-31'"/>
												</xsl:otherwise>
											</xsl:choose>
										</Date>
									</EndTimePoint>
								</ValidityPeriod>
								<PropertyDefinitionClassCode>
									<xsl:value-of select="'1'"/>
								</PropertyDefinitionClassCode>
								<xsl:if test="ItemDetail[exists(UnitPrice)]">
									<Rate>
										<DecimalValue>
											<xsl:value-of select="ItemDetail/UnitPrice/Money"/>
										</DecimalValue>
										<MeasureUnitCode>
											<xsl:value-of select="ItemDetail/UnitOfMeasure"/>
										</MeasureUnitCode>
										<xsl:if test="ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']">
											<BaseDecimalValue>
												<xsl:value-of
												select="ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']"
												/>
											</BaseDecimalValue>
										</xsl:if>
										<CurrencyCode>
											<xsl:value-of
												select="ItemDetail/UnitPrice/Money/@currency"/>
										</CurrencyCode>
									</Rate>
								</xsl:if>
							</PriceSpecificationElement>
						</xsl:if>
						<!--gross price-->
						<xsl:if
							test="@itemType = 'item' and not(ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod/ConditionTypes/ConditionType/@name = 'PRICE')">
							<PriceSpecificationElement>
								<xsl:attribute name="actionCode">
									<xsl:value-of select="'01'"/>
								</xsl:attribute>
								<xsl:if test="@itemClassification = 'service'">
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'servicegrosspriceTypecode'"/>
											</xsl:call-template>
										</xsl:value-of>
									</TypeCode>
								</xsl:if>
								<xsl:if test="@itemClassification = 'material'">
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'grosspriceTypecode'"/>
											</xsl:call-template>
										</xsl:value-of>
									</TypeCode>
								</xsl:if>
								<CategoryCode>
									<xsl:value-of select="'1'"/>
								</CategoryCode>
								<ValidityPeriod>
									<IntervalBoundaryTypeCode>
										<xsl:value-of select="'9'"/>
									</IntervalBoundaryTypeCode>
									<StartTimePoint>
										<TypeCode>
											<xsl:value-of select="'1'"/>
										</TypeCode>
										<Date>
											<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate) > 0">
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="$v_quoteDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="$v_quoteDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:otherwise>
											</xsl:choose>
										</Date>
									</StartTimePoint>
									<EndTimePoint>
										<TypeCode>
											<xsl:value-of select="'1'"/>
										</TypeCode>
										<Date>
											<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate) > 0">
												<xsl:value-of
												select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate, 1, 10)"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'9999-12-31'"/>
												</xsl:otherwise>
											</xsl:choose>
										</Date>
									</EndTimePoint>
								</ValidityPeriod>
								<PropertyDefinitionClassCode>
									<xsl:value-of select="'1'"/>
								</PropertyDefinitionClassCode>
								<xsl:if test="ItemDetail[exists(UnitPrice)]">
									<Rate>
										<DecimalValue>
											<xsl:value-of select="ItemDetail/UnitPrice/Money"/>
										</DecimalValue>
										<MeasureUnitCode>
											<xsl:value-of select="ItemDetail/UnitOfMeasure"/>
										</MeasureUnitCode>
										<xsl:if test="ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']">
											<BaseDecimalValue>
												<xsl:value-of
												select="ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']"
												/>
											</BaseDecimalValue>
										</xsl:if>
										<CurrencyCode>
											<xsl:value-of
												select="ItemDetail/UnitPrice/Money/@currency"/>
										</CurrencyCode>
									</Rate>
								</xsl:if>
							</PriceSpecificationElement>
						</xsl:if>
						<!--Materail Conditions-->
						<xsl:if test="not(@parentLineNumber)">
							<xsl:choose>
								<xsl:when test="exists(ItemDetail/UnitPrice/PricingConditions)">
									<xsl:for-each
										select="ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod">
										<xsl:for-each select="ConditionTypes/ConditionType">
											<xsl:if test="not(@name = 'EXTENDEDPRICE')">
												<PriceSpecificationElement>
												<xsl:attribute name="actionCode"
												>
													<xsl:value-of select="'01'"/>
												</xsl:attribute>
												<TypeCode>
												<xsl:value-of>
												<xsl:call-template name="LookupTemplate">
												<xsl:with-param name="p_anERPSystemID"
												select="$v_sysid"/>
												<xsl:with-param name="p_anSupplierANID"
												select="$anReceiverID"/>
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_input" select="@name"/>
												<xsl:with-param name="p_lookupname"
												select="'PricingConditions'"/>
												<xsl:with-param name="p_producttype"
												select="'AribaSourcing'"/>
												</xsl:call-template>
												</xsl:value-of>
												</TypeCode>
												<xsl:if test="not(@name = 'PRICE')">
												<CategoryCode>
												<xsl:choose>
												<xsl:when test="@name = 'DISCOUNT'">
													<xsl:value-of select="'2'"/>
												</xsl:when>
												<xsl:when test="@name = 'SURCHARGE'">
													<xsl:value-of select="'3'"/>
												</xsl:when>
												</xsl:choose>
												</CategoryCode>
												</xsl:if>
												<ValidityPeriod>
												<IntervalBoundaryTypeCode>
													<xsl:value-of select="'3'"/>
												</IntervalBoundaryTypeCode>
												<StartTimePoint>
												<TypeCode>
													<xsl:value-of select="'1'"/>
												</TypeCode>
												<Date>
												<xsl:value-of select="../../@from"/>
												</Date>
												</StartTimePoint>
												<EndTimePoint>
												<TypeCode>
													<xsl:value-of select="'1'"/>
												</TypeCode>
												<Date>
												<xsl:value-of select="../../@to"/>
												</Date>
												</EndTimePoint>
												</ValidityPeriod>
												<PropertyDefinitionClassCode>
													<xsl:value-of select="'M'"/>
												</PropertyDefinitionClassCode>
												<xsl:if test="@name = 'PRICE'">
												<Rate>
												<DecimalValue>
												<xsl:value-of select="CostTermValue/Money"/>
												</DecimalValue>
												<MeasureUnitCode>
												<xsl:value-of
												select="../../../../../../UnitOfMeasure"/>
												</MeasureUnitCode>
												<CurrencyCode>
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</CurrencyCode>
												<xsl:if
												test="../../../../../../Extrinsic/Extrinsic[@name = 'PriceUnit']">
												<BaseDecimalValue>
												<xsl:value-of
												select="../../../../../../Extrinsic/Extrinsic[@name = 'PriceUnit']"
												/>
												</BaseDecimalValue>
												<BaseMeasureUnitCode>
												<xsl:value-of
												select="../../../../../../UnitOfMeasure"/>
												</BaseMeasureUnitCode>
												<BaseCurrencyCode>
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</BaseCurrencyCode>
												</xsl:if>
												</Rate>
												</xsl:if>
												<xsl:if test="@name != 'PRICE'">
												<Rate>
												<DecimalValue>
													<xsl:value-of select="'0'"/>
												</DecimalValue>
												<CurrencyCode>
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</CurrencyCode>
												</Rate>
												<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="@name = 'DISCOUNT'">
												<xsl:value-of select="(CostTermValue/Money) * -1"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="CostTermValue/Money"/>
												</xsl:otherwise>
												</xsl:choose>
												</FixedAmount>
												</xsl:if>
												<xsl:for-each select="Scales/Scale">
												<ScaleLine>
												<ScaleAxisStep>
												<ScaleAxisBaseCode>
												<xsl:if test="../@scaleBasis = 'quantity'"
												>
													<xsl:value-of select="'1'"/>
												</xsl:if>
												</ScaleAxisBaseCode>
												<IntervalBoundaryTypeCode>
												<xsl:choose>
												<xsl:when test="../@scaleType = 'From'"
												>
													<xsl:value-of select="'1'"/>
												</xsl:when>
												<xsl:when test="../@scaleType = 'To'">
													<xsl:value-of select="'2'"/>
												</xsl:when>
												</xsl:choose>
												</IntervalBoundaryTypeCode>
												<Quantity>
												<xsl:attribute name="unitCode">
												<xsl:value-of
												select="../../../../../../../../UnitOfMeasure"/>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="exists(@from)">
												<xsl:value-of select="@from"/>
												</xsl:when>
												<xsl:when test="exists(@to)">
												<xsl:value-of select="@to"/>
												</xsl:when>
												</xsl:choose>
												</Quantity>
												</ScaleAxisStep>
												<xsl:if test="../../@name != 'PRICE'">
												<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="../../@name = 'DISCOUNT'">
												<xsl:value-of select="(CostTermValue/Money) * -1"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="CostTermValue/Money"/>
												</xsl:otherwise>
												</xsl:choose>
												</FixedAmount>
												</xsl:if>
												<xsl:if test="../../@name = 'PRICE'">
												<Rate>
												<DecimalValue>
												<xsl:value-of select="CostTermValue/Money"/>
												</DecimalValue>
												<MeasureUnitCode>
												<xsl:value-of
												select="../../../../../../../../UnitOfMeasure"/>
												</MeasureUnitCode>
												<CurrencyCode>
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</CurrencyCode>
												<xsl:if
												test="../../../../../../../../Extrinsic/Extrinsic[@name = 'PriceUnit']">
												<BaseDecimalValue>
												<xsl:value-of
												select="../../../../../../../../Extrinsic/Extrinsic[@name = 'PriceUnit']"
												/>
												</BaseDecimalValue>
												<BaseMeasureUnitCode>
												<xsl:value-of
												select="../../../../../../../../UnitOfMeasure"/>
												</BaseMeasureUnitCode>
												<BaseCurrencyCode>
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</BaseCurrencyCode>
												</xsl:if>
												</Rate>
												</xsl:if>
												</ScaleLine>
												</xsl:for-each>
												</PriceSpecificationElement>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="exists(ItemDetail/UnitPrice/Modifications)">
									<xsl:for-each
										select="ItemDetail/UnitPrice/Modifications/Modification">
										<PriceSpecificationElement>
											<xsl:attribute name="actionCode">
												<xsl:value-of select="'01'"/>
											</xsl:attribute>
											<TypeCode>
												<xsl:choose>
												<xsl:when test="exists(AdditionalDeduction)">
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalDeduction/DeductionPercent/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'DeductionPercent'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												<xsl:when
												test="not(AdditionalDeduction/DeductionPercent/@percent)">
												<xsl:if
												test="exists(AdditionalDeduction/DeductionAmount/Money)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'DeductionAmount'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:if>
												</xsl:when>
												</xsl:choose>
												</xsl:when>
												<xsl:when test="not(AdditionalDeduction)">
												<xsl:if test="exists(AdditionalCost)">
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalCost/Percentage/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'AdditionalPercent'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												<xsl:when
												test="not(AdditionalCost/Percentage/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'AdditionalMoney'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												</xsl:choose>
												</xsl:if>
												</xsl:when>
												</xsl:choose>
											</TypeCode>
											<CategoryCode>
												<xsl:choose>
												<xsl:when test="exists(AdditionalDeduction)"
												>
													<xsl:value-of select="'2'"/>
												</xsl:when>
												<xsl:when test="exists(AdditionalCost)"
												>
													<xsl:value-of select="'3'"/>
												</xsl:when>
												</xsl:choose>
											</CategoryCode>
											<ValidityPeriod>
												<IntervalBoundaryTypeCode>
													<xsl:value-of select="'9'"/>
												</IntervalBoundaryTypeCode>
												<StartTimePoint>
												<TypeCode>
													<xsl:value-of select="'1'"/>
												</TypeCode>
												<Date>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate) > 0">
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="$v_quoteDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:otherwise>
												</xsl:choose>
												</Date>
												</StartTimePoint>
												<EndTimePoint>
												<TypeCode>
													<xsl:value-of select="'1'"/>
												</TypeCode>
												<Date>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate) > 0">
												<xsl:value-of
												select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate, 1, 10)"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'9999-12-31'"/>
												</xsl:otherwise>
												</xsl:choose>
												</Date>
												</EndTimePoint>
											</ValidityPeriod>
											<PropertyDefinitionClassCode>
												<xsl:value-of select="'1'"/>
											</PropertyDefinitionClassCode>
											<Rate>
												<DecimalValue>
													<xsl:value-of select="'0'"/>
												</DecimalValue>
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalDeduction/DeductionAmount/Money)">
												<CurrencyCode>
												<xsl:value-of
												select="AdditionalDeduction/DeductionAmount/Money/@currency"
												/>
												</CurrencyCode>
												</xsl:when>
												<xsl:when test="exists(AdditionalCost/Money)">
												<CurrencyCode>
												<xsl:value-of
												select="AdditionalCost/Money/@currency"/>
												</CurrencyCode>
												</xsl:when>
												</xsl:choose>
											</Rate>
											<xsl:choose>
												<xsl:when
												test="exists(AdditionalDeduction/DeductionPercent/@percent)">
												<Percent>
												<xsl:value-of
												select="AdditionalDeduction/DeductionPercent/@percent"
												/>
												</Percent>
												</xsl:when>
												<xsl:when
												test="exists(AdditionalCost/Percentage/@percent)">
												<Percent>
												<xsl:value-of
												select="AdditionalCost/Percentage/@percent"/>
												</Percent>
												</xsl:when>
											</xsl:choose>
											<xsl:choose>
												<xsl:when
												test="exists(AdditionalDeduction/DeductionAmount/Money)">
												<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="AdditionalDeduction/DeductionAmount/Money/@currency"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="(AdditionalDeduction/DeductionAmount/Money) * -1"
												/>
												</FixedAmount>
												</xsl:when>
												<xsl:when test="exists(AdditionalCost/Money)">
												<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="AdditionalCost/Money/@currency"/>
												</xsl:attribute>
												<xsl:value-of select="AdditionalCost/Money"/>
												</FixedAmount>
												</xsl:when>
											</xsl:choose>
										</PriceSpecificationElement>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						<!-- Service Child Conditions-->
						<xsl:if test="@itemType = 'item' and exists(@parentLineNumber)">
							<xsl:for-each select="ItemDetail/UnitPrice/Modifications/Modification">
								<PriceSpecificationElement>
									<xsl:attribute name="actionCode">
										<xsl:value-of select="'01'"/>
									</xsl:attribute>
									<TypeCode>
										<xsl:choose>
											<xsl:when test="exists(AdditionalDeduction)">
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalDeduction/DeductionPercent/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'SDeductionPercent'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												<xsl:when
												test="not(AdditionalDeduction/DeductionPercent/@percent)">
												<xsl:if
												test="exists(AdditionalDeduction/DeductionAmount/Money)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'SDeductionAmount'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:if>
												</xsl:when>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="not(AdditionalDeduction)">
												<xsl:if test="exists(AdditionalCost)">
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalCost/Percentage/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'SAdditionalPercent'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												<xsl:when
												test="not(AdditionalCost/Percentage/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'SAdditionalMoney'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												</xsl:choose>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</TypeCode>
									<CategoryCode>
										<xsl:choose>
											<xsl:when test="exists(AdditionalDeduction)"
												>
												<xsl:value-of select="'2'"/>
											</xsl:when>
											<xsl:when test="exists(AdditionalCost)">
												<xsl:value-of select="'3'"/>
											</xsl:when>
										</xsl:choose>
									</CategoryCode>
									<ValidityPeriod>
										<IntervalBoundaryTypeCode>
											<xsl:value-of select="'9'"/>
										</IntervalBoundaryTypeCode>
										<StartTimePoint>
											<TypeCode>
												<xsl:value-of select="'1'"/>
											</TypeCode>
											<Date>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate) > 0">
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="$v_quoteDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:otherwise>
												</xsl:choose>
											</Date>
										</StartTimePoint>
										<EndTimePoint>
											<TypeCode>
												<xsl:value-of select="'1'"/>
											</TypeCode>
											<Date>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate) > 0">
												<xsl:value-of
												select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate, 1, 10)"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'9999-12-31'"/>
												</xsl:otherwise>
												</xsl:choose>
											</Date>
										</EndTimePoint>
									</ValidityPeriod>
									<PropertyDefinitionClassCode>
										<xsl:value-of select="'1'"/>
									</PropertyDefinitionClassCode>
									<Rate>
										<DecimalValue>
											<xsl:value-of select="'0'"/>
										</DecimalValue>
										<xsl:choose>
											<xsl:when
												test="exists(AdditionalDeduction/DeductionAmount/Money)">
												<CurrencyCode>
												<xsl:value-of
												select="AdditionalDeduction/DeductionAmount/Money/@currency"
												/>
												</CurrencyCode>
											</xsl:when>
											<xsl:when test="exists(AdditionalCost/Money)">
												<CurrencyCode>
												<xsl:value-of
												select="AdditionalCost/Money/@currency"/>
												</CurrencyCode>
											</xsl:when>
										</xsl:choose>
									</Rate>
									<xsl:choose>
										<xsl:when
											test="exists(AdditionalDeduction/DeductionPercent/@percent)">
											<Percent>
												<xsl:value-of
												select="AdditionalDeduction/DeductionPercent/@percent"
												/>
											</Percent>
										</xsl:when>
										<xsl:when test="exists(AdditionalCost/Percentage/@percent)">
											<Percent>
												<xsl:value-of
												select="AdditionalCost/Percentage/@percent"/>
											</Percent>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when
											test="exists(AdditionalDeduction/DeductionAmount/Money)">
											<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="AdditionalDeduction/DeductionAmount/Money/@currency"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="(AdditionalDeduction/DeductionAmount/Money) * -1"
												/>
											</FixedAmount>
										</xsl:when>
										<xsl:when test="exists(AdditionalCost/Money)">
											<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="AdditionalCost/Money/@currency"/>
												</xsl:attribute>
												<xsl:value-of select="AdditionalCost/Money"/>
											</FixedAmount>
										</xsl:when>
									</xsl:choose>
								</PriceSpecificationElement>
							</xsl:for-each>
						</xsl:if>
						<!--OutLine Conditions-->
						<xsl:if test="@itemType = 'composite' and exists(@parentLineNumber)">
							<xsl:for-each select="ItemDetail/UnitPrice/Modifications/Modification">
								<PriceSpecificationElement>
									<TypeCode>
										<xsl:choose>
											<xsl:when test="exists(AdditionalDeduction)">
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalDeduction/DeductionPercent/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'ODeductionPercent'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												<xsl:when
												test="not(AdditionalDeduction/DeductionPercent/@percent)">
												<xsl:if
												test="exists(AdditionalDeduction/DeductionAmount/Money)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'ODeductionAmount'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:if>
												</xsl:when>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="not(AdditionalDeduction)">
												<xsl:if test="exists(AdditionalCost)">
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalCost/Percentage/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'OAdditionalPercent'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												<xsl:when
												test="not(AdditionalCost/Percentage/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'OAdditionalMoney'"/>
												</xsl:call-template>
												</xsl:value-of>
												</xsl:when>
												</xsl:choose>
												</xsl:if>
											</xsl:when>
										</xsl:choose>
									</TypeCode>
									<CategoryCode>
										<xsl:choose>
											<xsl:when test="exists(AdditionalDeduction)"
												>
												<xsl:value-of select="'2'"/>
											</xsl:when>
											<xsl:when test="exists(AdditionalCost)">
												<xsl:value-of select="'3'"/>
											</xsl:when>
										</xsl:choose>
									</CategoryCode>
									<ValidityPeriod>
										<IntervalBoundaryTypeCode>
											<xsl:value-of select="'9'"/>
										</IntervalBoundaryTypeCode>
										<StartTimePoint>
											<TypeCode>
												<xsl:value-of select="'1'"/>
											</TypeCode>
											<Date>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate) > 0">
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@startDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="$v_quoteDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
												</xsl:variable>
												<xsl:value-of select="substring($v_date, 1, 10)"/>
												</xsl:otherwise>
												</xsl:choose>
											</Date>
										</StartTimePoint>
										<EndTimePoint>
											<TypeCode>
												<xsl:value-of select="'1'"/>
											</TypeCode>
											<Date>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate) > 0">
												<xsl:value-of
												select="substring(ItemDetail/UnitPrice/Modifications/Modification/ModificationDetail/@endDate, 1, 10)"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'9999-12-31'"/>
												</xsl:otherwise>
												</xsl:choose>
											</Date>
										</EndTimePoint>
									</ValidityPeriod>
									<PropertyDefinitionClassCode>
										<xsl:value-of select="'1'"/>
									</PropertyDefinitionClassCode>
									<Rate>
										<DecimalValue>
											<xsl:value-of select="'0'"/>
										</DecimalValue>
										<xsl:choose>
											<xsl:when
												test="exists(AdditionalDeduction/DeductionAmount/Money)">
												<CurrencyCode>
												<xsl:value-of
												select="AdditionalDeduction/DeductionAmount/Money/@currency"
												/>
												</CurrencyCode>
											</xsl:when>
											<xsl:when test="exists(AdditionalCost/Money)">
												<CurrencyCode>
												<xsl:value-of
												select="AdditionalCost/Money/@currency"/>
												</CurrencyCode>
											</xsl:when>
										</xsl:choose>
									</Rate>
									<xsl:choose>
										<xsl:when
											test="exists(AdditionalDeduction/DeductionPercent/@percent)">
											<Percent>
												<xsl:value-of
												select="AdditionalDeduction/DeductionPercent/@percent"
												/>
											</Percent>
										</xsl:when>
										<xsl:when test="exists(AdditionalCost/Percentage/@percent)">
											<Percent>
												<xsl:value-of
												select="AdditionalCost/Percentage/@percent"/>
											</Percent>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when
											test="exists(AdditionalDeduction/DeductionAmount/Money)">
											<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="AdditionalDeduction/DeductionAmount/Money/@currency"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="(AdditionalDeduction/DeductionAmount/Money) * -1"
												/>
											</FixedAmount>
										</xsl:when>
										<xsl:when test="exists(AdditionalCost/Money)">
											<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="AdditionalCost/Money/@currency"/>
												</xsl:attribute>
												<xsl:value-of select="AdditionalCost/Money"/>
											</FixedAmount>
										</xsl:when>
									</xsl:choose>
								</PriceSpecificationElement>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="ShipTo/Address/@addressID != ''">
							<ReceivingPlantID>
								<xsl:value-of select="ShipTo/Address/@addressID"/>
							</ReceivingPlantID>
						</xsl:if>
						<xsl:if test="exists(TermsOfDelivery/TermsOfDeliveryCode)">
							<DeliveryTerms>
								<Incoterms>
									<ClassificationCode>
										<xsl:value-of select="TermsOfDelivery/TransportTerms/@value"/>
									</ClassificationCode>
									<TransferLocationName>
										<xsl:value-of
											select="TermsOfDelivery/TransportTerms"/>
									</TransferLocationName>
								</Incoterms>
							</DeliveryTerms>
						</xsl:if>
						<xsl:if test="exists(Comments)">
							<TextCollection>
								<Text>
									<xsl:attribute name="actionCode">
										<xsl:choose>
											<xsl:when test="@operation = 'new'">
												<xsl:value-of select="'01'"/>
											</xsl:when>
											<xsl:when test="@operation = 'update'">
												<xsl:value-of select="'02'"/>
											</xsl:when>
											<xsl:when test="@operation = 'delete'">
												<xsl:value-of select="'03'"/>
											</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'ItemTextTypecode'"/>
											</xsl:call-template>
										</xsl:value-of>
									</TypeCode>
									<ContentText>
										<xsl:attribute name="languageCode">
											<xsl:value-of select="Comments/@xml:lang"/>
										</xsl:attribute>
										<xsl:variable name="v_comments">
											<xsl:call-template name="removeChild">
												<xsl:with-param name="p_comment" select="Comments"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:value-of select="normalize-space($v_comments)"/>
									</ContentText>
								</Text>
							</TextCollection>
						</xsl:if>
						<xsl:if test="../QuoteMessageHeader/@quoteID != ''">

							<QuoteReference>
								<ID>
									<xsl:value-of
										select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'quoteRequest']/@documentID"
									/>
								</ID>
								<ItemID>
									<xsl:value-of
										select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'quoteRequest']]/@lineNumber"
									/>
								</ItemID>
							</QuoteReference>

						</xsl:if>
						<xsl:if
							test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']">
							<PurchaseRequestReference>
								<ID>
									<xsl:value-of
										select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'requisition']/@documentID"
									/>
								</ID>
								<ItemID>
									<xsl:value-of
										select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'requisition']]/@lineNumber"
									/>
								</ItemID>
							</PurchaseRequestReference>
						</xsl:if>
						<!--    Account Assignment-->
						<AccountingCodingBlockDistribution>
							<xsl:variable name="v_accassgncat">
								<xsl:value-of>
									<xsl:call-template name="ReadQuote">
										<xsl:with-param name="p_doctype"
											select="'QuoteMessageContractServices'"/>
										<xsl:with-param name="p_pd" select="$v_pd"/>
										<xsl:with-param name="p_attribute"
											select="'AccountAssignmentCat'"/>
									</xsl:call-template>
								</xsl:value-of>
							</xsl:variable>
							<AccountingCodingBlockAssignment>
								<AccountingCodingBlockTypeCode>
									<xsl:value-of select="$v_accassgncat"/>
								</AccountingCodingBlockTypeCode>
								<xsl:if test="$v_accassgncat != 'U'">
									<AccountDeterminationExpenseGroupCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'GLAccount'"/>
											</xsl:call-template>
										</xsl:value-of>
									</AccountDeterminationExpenseGroupCode>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$v_accassgncat = 'K'">
										<CostCentreID>
											<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'CostCenter'"/>
												</xsl:call-template>
											</xsl:value-of>
										</CostCentreID>
									</xsl:when>
									<xsl:when test="$v_accassgncat = 'A'">
										<FundsManagementAccountID>
											<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'Asset'"/>
												</xsl:call-template>
											</xsl:value-of>
										</FundsManagementAccountID>
									</xsl:when>
									<xsl:when test="$v_accassgncat = 'F'">
										<MaintenanceOrderReference>
											<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'Order'"/>
												</xsl:call-template>
											</xsl:value-of>
										</MaintenanceOrderReference>
									</xsl:when>
									<xsl:when test="$v_accassgncat = 'P'">
										<FundsManagementFundID>
											<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageContractServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'WBSElement'"/>
												</xsl:call-template>
											</xsl:value-of>
										</FundsManagementFundID>
									</xsl:when>
								</xsl:choose>
							</AccountingCodingBlockAssignment>
						</AccountingCodingBlockDistribution>
						<Description>
							<xsl:attribute name="languageCode">
								<xsl:value-of select="ItemDetail/Description[1]/@xml:lang"/>
							</xsl:attribute>
							<xsl:value-of select="ItemDetail/Description[1]"/>
						</Description>
						<!-- 	CI-1844 : Populate the Item Partners information 		-->
						<xsl:if test="exists(SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
							<!--	Loop over all Item Partners with respect to each Item number	--> 
							<xsl:for-each select="SupplierProductionFacilityRelations/ProductionFacilityAssociation">                   
								<n0:Party>
									<xsl:attribute name="actionCode">
										<xsl:value-of select="'01'"/>
									</xsl:attribute>
									<InternalID>
										<xsl:value-of select="ProductionFacility/IdReference/@identifier"/>									
									</InternalID> 
									<ResponsiblePurchasingOrganisationParty>
										<BuyerID>
											<xsl:value-of select="OrganizationalUnit/IdReference/@identifier"/>
										</BuyerID>
									</ResponsiblePurchasingOrganisationParty> 
									<ReceivingPlantID>
										<xsl:value-of select="../../ShipTo/Address/@addressID"/>                                                                             
									</ReceivingPlantID>                                    
									<RoleCode>
										<xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
									</RoleCode>
									<DefaultIndicator></DefaultIndicator>                                    
								</n0:Party>                   
							</xsl:for-each>
						</xsl:if> 						
					</Item>
				</xsl:for-each>
				<xsl:if
					test="normalize-space(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteID) != ''">
					<n0:AribaContractID>
						<xsl:value-of
							select="normalize-space(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteID)"
						/>
					</n0:AribaContractID>
				</xsl:if>
				<!--Call template to handle attachment-->
				<xsl:call-template name="InboundAttachsn0"> </xsl:call-template>
			</PurchasingContract>
		</n0:PurchasingContractERPRequest_V1>
	</xsl:template>
</xsl:stylesheet>
