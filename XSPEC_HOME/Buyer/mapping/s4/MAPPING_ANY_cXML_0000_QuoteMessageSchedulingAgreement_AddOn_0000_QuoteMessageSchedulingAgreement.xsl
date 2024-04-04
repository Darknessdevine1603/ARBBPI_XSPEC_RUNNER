<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n0="http://sap.com/xi/ARBCIG2" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	<xsl:variable name="v_date">
		<xsl:value-of select="current-date()"/>
	</xsl:variable>
	<!-- parameter -->
	<xsl:param name="anReceiverID"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anERPTimeZone"/>
	<xsl:param name="anSourceDocumentType"/>
	<!--Local Testing-->
    <!--<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
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
	<xsl:variable name="v_privateid_exists">
		<xsl:value-of select="string-length(Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity)"/>
	</xsl:variable>
	<xsl:variable name="v_vendorId">
		<xsl:choose>
			<xsl:when test="$v_privateid_exists > 0">
				<xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="Combined/Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--    Main template-->
	<xsl:template match="Combined">
		<n0:SchedulingAgreementERPRequest xmlns:n0="http://sap.com/xi/ARBCIG1">
			<MessageHeader>
				<CreationDateTime>
					<xsl:variable name="v_date">
						<xsl:call-template name="ERPDateTime">
							<xsl:with-param name="p_date" select="$v_quoteDate"/>
							<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$v_date"/>
				</CreationDateTime>
				<SenderBusinessSystemID>
					<xsl:value-of select="'SOURCING'"/>
				</SenderBusinessSystemID>
				<RecipientBusinessSystemID>
					<xsl:value-of select="$anERPSystemID"/>
				</RecipientBusinessSystemID>
			</MessageHeader>
			<SchedulingAgreement>
				<xsl:attribute name="actionCode">
					<xsl:value-of select="'01'"/>
				</xsl:attribute>
				<ID/>
				<xsl:if test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteID != ''">
					<AribaContractID>
						<xsl:value-of
							select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/@quoteID"/>
					</AribaContractID>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic/@name = 'SourcingEventId'">
					<AribaSourcingEventID>
						<xsl:value-of
							select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Extrinsic[@name = 'SourcingEventId']"
						/>
					</AribaSourcingEventID>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier != ''">
					<CompanyID>
						<xsl:value-of
							select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
						/>
					</CompanyID>
				</xsl:if>
				<!--ProcessingTypeCode-->
				<ProcessingTypeCode>
					<xsl:value-of
						select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/QuoteHeaderInfo/FollowUpDocument/@category"
					/>
				</ProcessingTypeCode>
				<!--Header Validity Period-->
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
				<!--Header Target amount-->
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
				<!-- Seller Party -->
				<xsl:if
					test="$v_vendorId != ''">
					<SellerParty>
						<InternalID>
							<xsl:value-of
								select="$v_vendorId"/>
						</InternalID>
					</SellerParty>
				</xsl:if>
				<!-- ResponsiblePurchasingOrganisationParty  and ResponsiblePurchasingGroupParty -->
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
				<!--    CI-1844 : Populate the SA Header Partners structure    --> 
				<xsl:if test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
					<!--    Loop over the Header Partners and populate the Party structures   --> 
					<xsl:for-each select="Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/SupplierProductionFacilityRelations/ProductionFacilityAssociation">                   
						<Party>
							<InternalID>
								<xsl:value-of select="ProductionFacility/IdReference/@identifier"/>									
							</InternalID> 
							<RoleCode>
								<xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
							</RoleCode>
						</Party>                   
					</xsl:for-each>
				</xsl:if>				
				<!-- Delivery Terms at Header Level -->
				<xsl:if
					test="exists(Payload/cXML/Message/QuoteMessage/QuoteItemIn[1]/TermsOfDelivery/TransportTerms)">
					<DeliveryTerms>
						<Incoterms>
							<ClassificationCode>
								<xsl:value-of
									select="Payload/cXML/Message/QuoteMessage/QuoteItemIn[1]/TermsOfDelivery/TransportTerms/@value"
								/>
							</ClassificationCode>
							<TransferLocationName>
								<xsl:value-of
									select="substring(Payload/cXML/Message/QuoteMessage/QuoteItemIn[1]/TermsOfDelivery/TransportTerms,1,28)"
								/>
							</TransferLocationName>
						</Incoterms>
					</DeliveryTerms>
				</xsl:if>
				<!--Cash Discount-->
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
				<!-- Text Collection at header level-->
				<xsl:if test="exists(Payload/cXML/Message/QuoteMessage/QuoteMessageHeader/Comments)">
					<TextCollection>
						<Text>
							<TypeCode>
								<xsl:value-of>
									<xsl:call-template name="ReadQuote">
										<xsl:with-param name="p_doctype"
											select="'QuoteMessageSchedulingAgreement'"/>
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
				<!-- Item mapping-->
				<xsl:for-each select="Payload/cXML/Message/QuoteMessage/QuoteItemIn">
					<Item>
						<xsl:attribute name="actionCode">
							<xsl:value-of select="'01'"/>
						</xsl:attribute>
						<!--ERP Line Number-->
						<ID>
							<xsl:value-of select="@lineNumber"/>
						</ID>
						<!--Ariba Line Number-->
						<AribaContractItemID>
							<xsl:value-of select="@lineNumber"/>
						</AribaContractItemID>
						<!--Item Category-->
						<xsl:if test="normalize-space(@itemClassification) != ''">
							<ProcessingTypeCode>
								<xsl:if test="normalize-space(@itemClassification) = 'material'"
									>
									<xsl:value-of select="'0'"/>
								</xsl:if>
							</ProcessingTypeCode>
						</xsl:if>
						<!--Net Price details-->
						<Price>
							<NetAmount>
								<xsl:attribute name="currencyCode">
									<xsl:value-of select="ItemDetail/UnitPrice/Money/@currency"/>
								</xsl:attribute>
								<xsl:value-of select="ItemDetail/UnitPrice/Money"/>
							</NetAmount>
							<NetUnitPrice>
								<Amount>
									<xsl:attribute name="currencyCode">
										<xsl:value-of select="ItemDetail/UnitPrice/Money/@currency"
										/>
									</xsl:attribute>
									<xsl:value-of select="ItemDetail/UnitPrice/Money"/>
								</Amount>
								<BaseQuantity>
									<xsl:choose>
										<xsl:when test="ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']">
											<xsl:value-of
												select="ItemDetail/Extrinsic/Extrinsic[@name = 'PriceUnit']"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'1'"/>
										</xsl:otherwise>
									</xsl:choose>
								</BaseQuantity>
							</NetUnitPrice>
						</Price>
						<!--Item TargetQuantity-->
						<TargetQuantity>
							<xsl:attribute name="unitCode">
								<xsl:value-of select="ItemDetail/UnitOfMeasure"/>
							</xsl:attribute>
							<xsl:value-of select="@quantity"/>
						</TargetQuantity>
						<!--Item Description-->
						<Description>
							<xsl:attribute name="languageCode">
								<xsl:value-of select="ItemDetail/Description[1]/@xml:lang"/>
							</xsl:attribute>
							<xsl:value-of select="ItemDetail/Description[1]"/>
						</Description>						
						<!--Material Code and Material Group Code-->
						<xsl:if
							test="normalize-space(ItemID/BuyerPartID) != '' or ItemDetail/Classification[@domain = 'MaterialGroup']">
							<Product>
								<xsl:if test="ItemID/BuyerPartID != ''">
									<InternalID>
										<xsl:value-of select="ItemID/BuyerPartID"/>
									</InternalID>
								</xsl:if>
								<xsl:if test="ItemID/SupplierPartID != ''">
									<SellerID>
										<xsl:value-of select="ItemID/SupplierPartID"/>
									</SellerID>
								</xsl:if>
								<xsl:if test="ItemDetail/ManufacturerPartID != ''">
									<ManufacturerID>
										<xsl:value-of select="ItemDetail/ManufacturerPartID"/>
									</ManufacturerID>
								</xsl:if>
								<ProductCategoryInternalID>
									<xsl:if
										test="ItemDetail/Classification[@domain = 'MaterialGroup']">
										<xsl:value-of select="ItemDetail/Classification/@code"/>
									</xsl:if>
								</ProductCategoryInternalID>
							</Product>
						</xsl:if>
						<!--gross price-->
						<xsl:if
							test="not(ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod/ConditionTypes/ConditionType/@name = 'PRICE')">
							<PriceSpecification>
								<TypeCode>
									<xsl:value-of>
										<xsl:call-template name="ReadQuote">
											<xsl:with-param name="p_doctype"
												select="'QuoteMessageSchedulingAgreement'"/>
											<xsl:with-param name="p_pd" select="$v_pd"/>
											<xsl:with-param name="p_attribute"
												select="'grosspriceTypecode'"/>
										</xsl:call-template>
									</xsl:value-of>
								</TypeCode>
								<ValidityPeriod>
									<StartDate>
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
									</StartDate>
									<EndDate>
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
									</EndDate>
								</ValidityPeriod>
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
							</PriceSpecification>
						</xsl:if>
						<!--Material Conditions-->
						<xsl:choose>
							<!-- Pricing Conditions for each validity and each condition type -->
							<xsl:when test="exists(ItemDetail/UnitPrice/PricingConditions)">
								<xsl:for-each
									select="ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod">
									<xsl:for-each select="ConditionTypes/ConditionType">
										<xsl:if test="not(@name = 'EXTENDEDPRICE')">
											<PriceSpecification>
												<TypeCode>
												<xsl:value-of>
												<xsl:call-template name="LookupTemplate">
												<xsl:with-param name="p_anERPSystemID"
												select="$v_sysid"/>
												<xsl:with-param name="p_anSupplierANID"
												select="$anReceiverID"/>
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageSchedulingAgreement'"/>
												<xsl:with-param name="p_input" select="@name"/>
												<xsl:with-param name="p_lookupname"
												select="'PricingConditions'"/>
												<xsl:with-param name="p_producttype"
												select="'AribaSourcing'"/>
												</xsl:call-template>
												</xsl:value-of>
												</TypeCode>
												<ValidityPeriod>
												<StartDate>
												<xsl:value-of select="../../@from"/>
												</StartDate>
												<EndDate>
												<xsl:value-of select="../../@to"/>
												</EndDate>
												</ValidityPeriod>
												<!--If condition type is PRICE, Rate comes otherwise Fixedamount -->
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
												<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</xsl:attribute>												
												<xsl:choose>
												<xsl:when test="@name = 'DISCOUNT'">
												<xsl:value-of select="(CostTermValue/Money) * -1"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="CostTermValue/Money"/>
												</xsl:otherwise>
												</xsl:choose>											
												</FixedAmount>
												</xsl:if>
												<xsl:if test="CostTermValue/Percentage != ''">
												<Percent>
												<xsl:value-of select="CostTermValue/Percentage"/>
												</Percent>
												</xsl:if>
												<!-- Each scale -->
												<xsl:for-each select="Scales/Scale">
												<ScaleLine>
												<ScaleAxisStep>
												<ScaleAxisBaseCode>
												<xsl:if test="../@scaleBasis = 'quantity'"
												>
													<xsl:value-of select="'C'"/>
												</xsl:if>
												</ScaleAxisBaseCode>
												<IntervalBoundaryTypeCode>
												<xsl:choose>
												<xsl:when test="../@scaleType = 'From'"
												>
													<xsl:value-of select="'A'"/>
												</xsl:when>
												<xsl:when test="../@scaleType = 'To'">
													<xsl:value-of select="'B'"/>
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
												<!--If condition type is PRICE, Rate comes otherwise Fixedamount-->
												<xsl:if test="../../@name != 'PRICE'">
												<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</xsl:attribute>												
												<xsl:choose>
												<xsl:when test="../../@name = 'DISCOUNT'">
												<xsl:value-of select="(CostTermValue/Money) * -1"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="CostTermValue/Money"/>
												</xsl:otherwise>
												</xsl:choose>
												</FixedAmount>
												</xsl:if>
												<xsl:if test="CostTermValue/Percentage != ''">
												<Percent>
												<xsl:value-of select="CostTermValue/Percentage"/>
												</Percent>
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
											</PriceSpecification>
										</xsl:if>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:when>
							<!-- Each Modification- Additional deduction & cost -->
							<xsl:when test="exists(ItemDetail/UnitPrice/Modifications)">
								<xsl:for-each
									select="ItemDetail/UnitPrice/Modifications/Modification">
									<PriceSpecification>
										<TypeCode>
											<xsl:choose>
												<xsl:when test="exists(AdditionalDeduction)">
												<xsl:choose>
												<xsl:when
												test="exists(AdditionalDeduction/DeductionPercent/@percent)">
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageSchedulingAgreement'"/>
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
												select="'QuoteMessageSchedulingAgreement'"/>
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
												select="'QuoteMessageSchedulingAgreement'"/>
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
												select="'QuoteMessageSchedulingAgreement'"/>
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
										<ValidityPeriod>
											<StartDate>
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
											</StartDate>
											<EndDate>
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
											</EndDate>
										</ValidityPeriod>
										<!--For modification  Rate is always 0, fixed amount exists-->
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
												select="AdditionalDeduction/DeductionAmount/Money"
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
									</PriceSpecification>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
						<!-- ReceivingPlantID -->
						<xsl:if test="ShipTo/Address/@addressID != ''">
							<ReceivingPlantID>
								<xsl:value-of select="ShipTo/Address/@addressID"/>
							</ReceivingPlantID>
						</xsl:if>
						<!-- DeliveryTerms at item level -->
						<xsl:if test="exists(TermsOfDelivery/TransportTerms)">
							<DeliveryTerms>
								<Incoterms>
									<ClassificationCode>
										<xsl:value-of select="TermsOfDelivery/TransportTerms/@value"/>
									</ClassificationCode>
									<TransferLocationName>
										<xsl:value-of
											select="substring(TermsOfDelivery/TransportTerms,1,28)"/>
									</TransferLocationName>
								</Incoterms>
							</DeliveryTerms>
						</xsl:if>
						<!--Text Collection at item level-->
						<xsl:if test="exists(Comments)">
							<TextCollection>
								<Text>
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageSchedulingAgreement'"/>
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
						<!-- QuoteReference -->
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
						<!-- PurchaseRequestReference -->
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
						<!-- Account Assignment-->						
							<xsl:variable name="v_accassgncat">
								<xsl:value-of>
									<xsl:call-template name="ReadQuote">
										<xsl:with-param name="p_doctype"
											select="'QuoteMessageSchedulingAgreement'"/>
										<xsl:with-param name="p_pd" select="$v_pd"/>
										<xsl:with-param name="p_attribute"
											select="'AccountAssignmentCat'"/>
									</xsl:call-template>
								</xsl:value-of>
							</xsl:variable>
						<xsl:if test="normalize-space(ItemID/BuyerPartID) = '' or ( normalize-space($v_accassgncat) != '' and normalize-space($v_accassgncat) != 'U' )">
						<AccountingCodingBlockDistribution>
							<AccountingCodingBlockAssignment>
								<OrdinalNumberValue>
									<xsl:value-of select="'1'"/>
								</OrdinalNumberValue>
								<xsl:choose>
									<xsl:when test="normalize-space(ItemID/BuyerPartID) != '' or normalize-space($v_accassgncat) != ''">
										<AccountingCodingBlockTypeCode>
											<xsl:value-of select="$v_accassgncat"/>
										</AccountingCodingBlockTypeCode>
									</xsl:when>
									<xsl:otherwise>
										<AccountingCodingBlockTypeCode>
											<xsl:value-of select="'U'"/>
										</AccountingCodingBlockTypeCode>
									</xsl:otherwise>
								</xsl:choose>																
								<xsl:if test="$v_accassgncat != 'U' and normalize-space($v_accassgncat) != ''">
									<AccountDeterminationExpenseGroupCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageSchedulingAgreement'"/>
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
												select="'QuoteMessageSchedulingAgreement'"/>
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
												select="'QuoteMessageSchedulingAgreement'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'Asset'"/>
												</xsl:call-template>
											</xsl:value-of>
										</FundsManagementAccountID>
									</xsl:when>
									<xsl:when test="$v_accassgncat = 'F'">
										<InternalOrderID>
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageSchedulingAgreement'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'Order'"/>
												</xsl:call-template>
												</xsl:value-of>											
										</InternalOrderID>
									</xsl:when>
									<xsl:when test="$v_accassgncat = 'P'">
										<ProjectReference>
											<ProjectElementID>
												<xsl:value-of>
												<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'QuoteMessageSchedulingAgreement'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'WBSElement'"/>
												</xsl:call-template>
												</xsl:value-of>
											</ProjectElementID>
										</ProjectReference>
									</xsl:when>
								</xsl:choose>
							</AccountingCodingBlockAssignment>
						</AccountingCodingBlockDistribution>
						</xsl:if>
						<!-- 	CI-1844 : Populate the Item Partners information 		-->
						<xsl:if test="exists(SupplierProductionFacilityRelations/ProductionFacilityAssociation/ProductionFacility)">
							<!--	Loop over all Item Partners with respect to each Item number	--> 
							<xsl:for-each select="SupplierProductionFacilityRelations/ProductionFacilityAssociation">                   
								<Party>
									<InternalID>
										<xsl:value-of select="ProductionFacility/IdReference/@identifier"/>									
									</InternalID> 
									<RoleCode>
										<xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
									</RoleCode>
								</Party>                   
							</xsl:for-each>
						</xsl:if>	
					</Item>
				</xsl:for-each>
				<!--Call template to handle attachment-->
				<xsl:call-template name="InboundAttachsn0"> </xsl:call-template>
			</SchedulingAgreement>
		</n0:SchedulingAgreementERPRequest>
	</xsl:template>
</xsl:stylesheet>
