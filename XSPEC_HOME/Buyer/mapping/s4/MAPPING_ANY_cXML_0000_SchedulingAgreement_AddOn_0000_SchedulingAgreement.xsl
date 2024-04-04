<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
	<xsl:param name="anAddOnCIVersion"/>

	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>

<!--	<xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->

	<!--    System ID incase of MultiERP-->
	<xsl:variable name="v_sysid">
		<xsl:call-template name="MultiErpSysIdIN">
			<xsl:with-param name="p_ansysid"
				select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
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

	<!--Get the Document Create Date-->
	<xsl:variable name="v_docCreateDate">
		<xsl:value-of
			select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@createDate"
		/>
	</xsl:variable>

	<!--Effective Date -->
	<xsl:variable name="v_effectiveDate">
		<!-- IG-29961: Removing timezone conversion as its not needed  -->
		<!--<xsl:call-template name="ERPDateTime">
			<xsl:with-param name="p_date"
				select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@effectiveDate"/>
			<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
		</xsl:call-template>-->
		<xsl:value-of
			select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@effectiveDate"
		/>
	</xsl:variable>

	<!--Expiration Date -->
	<xsl:variable name="v_expirationDate">
		<!-- IG-29961: Removing timezone conversion as its not needed  -->
		<!--<xsl:call-template name="ERPDateTime">
			<xsl:with-param name="p_date"
				select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@expirationDate"/>
			<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
		</xsl:call-template>-->
		<xsl:value-of
			select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@expirationDate"
		/>
	</xsl:variable>

	<!--    Main template-->
	<xsl:template match="Combined">
		<n0:SchedulingAgreementERPRequest xmlns:n0="http://sap.com/xi/ARBCIG1">
			<MessageHeader>
				<AribaNetworkPayloadID>
					<xsl:value-of select="Payload/cXML/@payloadID"/>
				</AribaNetworkPayloadID>
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationID/Credential[@domain = 'NetworkID']/Identity != ''">
					<AribaNetworkID>
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationID/Credential[@domain = 'NetworkID']/Identity"
						/>
					</AribaNetworkID>
				</xsl:if>
				<CreationDateTime>
					<xsl:variable name="v_date">
						<xsl:call-template name="ERPDateTime">
							<xsl:with-param name="p_date" select="$v_docCreateDate"/>
							<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$v_date"/>
				</CreationDateTime>
				<SenderBusinessSystemID/>
				<SenderParty>
					<InternalID>
						<xsl:attribute name="schemeID">
							<xsl:value-of select="'NetworkID'"/>
						</xsl:attribute>
						<xsl:attribute name="schemeAgencyID">
							<xsl:value-of select="'www.ariba.com'"/>
						</xsl:attribute>
						<xsl:if
							test="Payload/cXML/Header/From/Credential[@domain = 'NetworkId']/Identity != ''">
							<xsl:value-of
								select="Payload/cXML/Header/From/Credential[@domain = 'NetworkId']/Identity"
							/>
						</xsl:if>
					</InternalID>
				</SenderParty>
				<RecipientParty>
					<InternalID>
						<xsl:value-of select="$v_sysid"/>
					</InternalID>
				</RecipientParty>
			</MessageHeader>
			<SchedulingAgreement>
				<xsl:attribute name="actionCode">
					<xsl:choose>
						<xsl:when
							test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation = 'new'"
							>
							<xsl:value-of select="'01'"/>
						</xsl:when>
						<xsl:when
							test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation = 'update'"
							>
							<xsl:value-of select="'02'"/>
						</xsl:when>
						<xsl:when
							test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation = 'delete'"
							>
							<xsl:value-of select="'03'"/>
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<!--ERP ID-->
				<ID>
					<xsl:if
						test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation != 'new'">
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/DocumentInfo/@documentID"
						/>
					</xsl:if>
				</ID>
				<!--Ariba Contract ID-->
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@contractID != ''">
					<AribaContractID>
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@contractID"
						/>
					</AribaContractID>
				</xsl:if>
				<!--Companycode-->
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier != ''">
					<CompanyID>
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
						/>
					</CompanyID>
				</xsl:if>

				<!-- SAP Document Type using LoopUp Table -->
				<xsl:variable name="v_category">
					<xsl:value-of
						select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/FollowUpDocument/@category"
					/>
				</xsl:variable>
				<ProcessingTypeCode>
					<xsl:value-of>
						<xsl:call-template name="LookupTemplate">
							<xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
							<xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
							<xsl:with-param name="p_doctype" select="'SchedulingAgreement'"/>
							<xsl:with-param name="p_input" select="$v_category"/>
							<xsl:with-param name="p_lookupname" select="'SAPDocType'"/>
							<xsl:with-param name="p_producttype" select="'AribaSourcing'"/>
						</xsl:call-template>
					</xsl:value-of>
				</ProcessingTypeCode>
				<!--Validity period-->
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate' or 'ValidityEndDate'] or $v_effectiveDate != ''">
					<ValidityPeriod>
						<StartDate>
							<xsl:choose>
								<xsl:when
									test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']">

									<xsl:variable name="v_date">
										<xsl:call-template name="ERPDateTime">
											<xsl:with-param name="p_date"
												select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']"/>
											<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
										</xsl:call-template>
									</xsl:variable>
									<!--Convert the final date into SAP format is 'YYYYMMDD'-->
									<xsl:value-of select="substring($v_date, 1, 10)"/>

								</xsl:when>
								<xsl:when test="$v_effectiveDate != ''">
									<xsl:value-of select="substring($v_effectiveDate, 1, 10)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring($v_docCreateDate, 1, 10)"/>
								</xsl:otherwise>
							</xsl:choose>
						</StartDate>
						<EndDate>
							<xsl:choose>
								<xsl:when
									test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']">
									<xsl:variable name="v_date">
										<xsl:call-template name="ERPDateTime">
											<xsl:with-param name="p_date"
												select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityEndDate']"/>
											<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
										</xsl:call-template>
									</xsl:variable>
									<!--Convert the final date into SAP format is 'YYYYMMDD'-->
									<xsl:value-of select="substring($v_date, 1, 10)"/>
								</xsl:when>
								<xsl:when test="$v_expirationDate != ''">
									<xsl:value-of select="substring($v_expirationDate, 1, 10)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'9999-12-31'"/>
								</xsl:otherwise>
							</xsl:choose>
						</EndDate>
					</ValidityPeriod>
				</xsl:if>

				<!--Target amount-->
				<xsl:if
					test="normalize-space(Payload/cXML/Request/ContractRequest/ContractRequestHeader/MaxAmount/Money) != ''">
					<TargetAmount>
						<xsl:attribute name="currencyCode">
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/MaxAmount/Money/@currency"
							/>
						</xsl:attribute>
						<xsl:value-of
							select="normalize-space(Payload/cXML/Request/ContractRequest/ContractRequestHeader/MaxAmount/Money)"
						/>
					</TargetAmount>
				</xsl:if>
				<!--                Seller Party and Buyer ID-->
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationID/Credential[@domain = 'PrivateID']/Identity != ''">
					<SellerParty>
						<InternalID>
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationID/Credential[@domain = 'PrivateID']/Identity"
							/>
						</InternalID>
						<BuyerID>
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationID/Credential[@domain = 'PrivateID']/Identity"
							/>
						</BuyerID>
					</SellerParty>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier != ''">
					<ResponsiblePurchasingOrganisationParty>
						<InternalID>
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier"
							/>
						</InternalID>
					</ResponsiblePurchasingOrganisationParty>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier != ''">
					<ResponsiblePurchasingGroupParty>
						<InternalID>
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier"
							/>
						</InternalID>
					</ResponsiblePurchasingGroupParty>
				</xsl:if>
				<!-- Delivery Terms at Header Level -->
				<xsl:if
					test="exists(Payload/cXML/Request/ContractRequest/ContractItemIn[1]/TermsOfDelivery)">
					<DeliveryTerms>
						<Incoterms>
							<ClassificationCode>
								<xsl:value-of
									select="Payload/cXML/Request/ContractRequest/ContractItemIn[1]/TermsOfDelivery/TransportTerms/@value"
								/>
							</ClassificationCode>
							<TransferLocationName>
								<xsl:value-of
									select="substring(Payload/cXML/Request/ContractRequest/ContractItemIn[1]/TermsOfDelivery/TransportTerms, 1, 28)"
								/>
							</TransferLocationName>
						</Incoterms>
					</DeliveryTerms>
				</xsl:if>
				<!--Cash Discount-->
				<xsl:if
					test="exists(Payload/cXML/Request/ContractRequest/ContractRequestHeader/PaymentTerm[1]/Extrinsic[@name = 'ID'])">
					<CashDiscountTerms>
						<Code>
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/PaymentTerm[1]/Extrinsic[@name = 'ID']"
							/>
						</Code>
					</CashDiscountTerms>
				</xsl:if>
				<!--Text Collection-->
				<xsl:if
					test="exists(Payload/cXML/Request/ContractRequest/ContractRequestHeader/Comments)">
					<TextCollection>
						<Text>
							<TypeCode>
								<xsl:value-of>
									<xsl:call-template name="ReadQuote">
										<xsl:with-param name="p_doctype"
											select="'SchedulingAgreement'"/>
										<xsl:with-param name="p_pd" select="$v_pd"/>
										<xsl:with-param name="p_attribute"
											select="'HeaderTextTypecode'"/>
									</xsl:call-template>
								</xsl:value-of>
							</TypeCode>
							<ContentText>
								<xsl:attribute name="languageCode">
									<xsl:variable name="v_lang">
										<xsl:value-of
											select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Comments/@xml:lang"
										/>
									</xsl:variable>
									<xsl:value-of select="upper-case($v_lang)"/>
								</xsl:attribute>

								<xsl:variable name="v_comments">
									<xsl:call-template name="removeChild">
										<xsl:with-param name="p_comment"
											select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Comments"
										/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="normalize-space($v_comments)"/>
							</ContentText>
						</Text>
					</TextCollection>
				</xsl:if>
				<!--Item-->
				<xsl:for-each select="Payload/cXML/Request/ContractRequest/ContractItemIn">
					<Item>
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
						<!--ERP Line Number-->
						<ID>
							<xsl:if test="@operation = 'new'">
								<xsl:value-of select="ItemIn/@lineNumber"/>
							</xsl:if>
							<xsl:if test="@operation != 'new'">
								<xsl:value-of
									select="ItemIn/ItemID/IdReference[@domain = 'SAPLineNumber']/@identifier"
								/>
							</xsl:if>
						</ID>
						<!--Ariba Line Number-->
						<AribaContractItemID>
							<xsl:value-of select="ItemIn/@lineNumber"/>
						</AribaContractItemID>
						<!--Plant ID-->
						<xsl:if test="ItemIn/ShipTo/Address/@addressID != ''">
							<ReceivingPlantID>
								<xsl:value-of select="ItemIn/ShipTo/Address/@addressID"/>
							</ReceivingPlantID>
						</xsl:if>
						<!--Item Catergory-->
						<ProcessingTypeCode>
							<xsl:choose>
								<xsl:when test="normalize-space(ItemIn/@itemCategory) != ''">
									<xsl:choose>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'limit'"
											>
											<xsl:value-of select="'1'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'consignment'"
											>
											<xsl:value-of select="'2'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'subcontract'"
											>
											<xsl:value-of select="'3'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'materialUnknown'"
											>
											<xsl:value-of select="'4'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'thirdParty'"
											>
											<xsl:value-of select="'5'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'text'"
											>
											<xsl:value-of select="'6'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'stockTransfer'"
											>
											<xsl:value-of select="'7'"/>
										</xsl:when>
										<xsl:when
											test="normalize-space(ItemIn/@itemCategory) = 'materialGroup'"
											>
											<xsl:value-of select="'8'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="normalize-space(ItemIn/@itemClassification) != ''">
									<xsl:choose>
										<xsl:when
											test="normalize-space(ItemIn/@itemClassification) = 'material'"
											>
											<xsl:value-of select="'0'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</ProcessingTypeCode>
						<Description>
							<xsl:attribute name="languageCode">
								<!--<xsl:variable name="v_lang">
									<xsl:value-of select="ItemIn/ItemDetail/Description/@xml:lang"/>
								</xsl:variable>-->
								<xsl:value-of select="ItemIn/ItemDetail/Description[1]/@xml:lang"/>
							</xsl:attribute>
							<xsl:value-of select="substring(ItemIn/ItemDetail/Description[1] , 0 , 40)"/>
						</Description>

						<Price>
							<NetAmount>
								<xsl:attribute name="currencyCode">
									<xsl:value-of
										select="ItemIn/ItemDetail/UnitPrice/Money/@currency"/>
								</xsl:attribute>
								<xsl:value-of select="ItemIn/ItemDetail/UnitPrice/Money"/>
							</NetAmount>
							<NetUnitPrice>
								<Amount>
									<xsl:attribute name="currencyCode">
										<xsl:value-of
											select="ItemIn/ItemDetail/UnitPrice/Money/@currency"/>
									</xsl:attribute>
									<xsl:value-of select="ItemIn/ItemDetail/UnitPrice/Money"/>
								</Amount>
								<BaseQuantity>
									<xsl:choose>
										<xsl:when
											test="ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']">
											<xsl:value-of
												select="ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'1'"/>
										</xsl:otherwise>
									</xsl:choose>
								</BaseQuantity>
							</NetUnitPrice>
						</Price>
						<!--Quantity-->
						<xsl:if test="ItemIn/@quantity != ''">
							<TargetQuantity>
								<xsl:attribute name="unitCode">
									<xsl:value-of select="ItemIn/ItemDetail/UnitOfMeasure"/>
								</xsl:attribute>
								<xsl:value-of select="ItemIn/@quantity"/>
							</TargetQuantity>
						</xsl:if>
						<!--Material Code and Material Group Code-->
						<xsl:if
							test="normalize-space(ItemIn/ItemID/BuyerPartID) != '' or ItemIn/ItemDetail/Classification[@domain = 'MaterialGroup']">
							<Product>
								<xsl:if test="ItemIn/ItemID/BuyerPartID != ''">
									<InternalID>
										<xsl:value-of select="ItemIn/ItemID/BuyerPartID"/>
									</InternalID>
								</xsl:if>
								<xsl:if test="ItemIn/ItemID/SupplierPartID != ''">
									<SellerID>
										<xsl:value-of select="ItemIn/ItemID/SupplierPartID"/>
									</SellerID>
								</xsl:if>
								<xsl:if test="ItemIn/ItemDetail/ManufacturerPartID != ''">
									<ManufacturerID>
										<xsl:value-of select="ItemIn/ItemDetail/ManufacturerPartID"
										/>
									</ManufacturerID>
								</xsl:if>
								<ProductCategoryInternalID>
									<xsl:value-of
										select="ItemIn/ItemDetail/Classification[@domain = 'MaterialGroup']"
									/>
								</ProductCategoryInternalID>
							</Product>
						</xsl:if>

						<!--gross price-->
						<xsl:choose>
							<xsl:when
								test="ItemIn/ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod/ConditionTypes/ConditionType/@name = 'PRICE' and substring($anAddOnCIVersion, 9) > '09'">
								<xsl:for-each
									select="ItemIn/ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod">
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
												select="'SchedulingAgreement'"/>
												<xsl:with-param name="p_input"><xsl:value-of select="@name"/></xsl:with-param>
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
												<xsl:if test="@name = 'PRICE'">
												<Rate>
												<DecimalValue>
												<xsl:value-of select="CostTermValue/Money"/>
												</DecimalValue>
												<MeasureUnitCode>
												<xsl:value-of
												select="../../../../../../UnitOfMeasure"/>
												</MeasureUnitCode>
												<xsl:if
												test="../../../../../../Extrinsic[@name = 'PriceUnit']">
												<BaseDecimalValue>
												<xsl:value-of
												select="../../../../../../Extrinsic[@name = 'PriceUnit']"
												/>
												</BaseDecimalValue>
												</xsl:if>
												<CurrencyCode>
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</CurrencyCode>
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
												<xsl:value-of select="CostTermValue/Money * -1"
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
												<xsl:if test="../../@name != 'PRICE'">
												<FixedAmount>
												<xsl:attribute name="currencyCode">
												<xsl:value-of
												select="CostTermValue/Money/@currency"/>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="../../@name = 'DISCOUNT'">
												<xsl:value-of select="CostTermValue/Money * -1"
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
												test="../../../../../../../../Extrinsic[@name = 'PriceUnit']">
												<BaseDecimalValue>
												<xsl:value-of
												select="../../../../../../../../Extrinsic[@name = 'PriceUnit']"
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
							<xsl:otherwise>
								<PriceSpecification>
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'SchedulingAgreement'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'grosspriceTypecode'"/>
											</xsl:call-template>
										</xsl:value-of>
									</TypeCode>
									<ValidityPeriod>
										<StartDate>
											<xsl:variable name="v_date">
												<xsl:call-template name="ERPDateTime">
												<xsl:with-param name="p_date"
												select="$v_docCreateDate"/>
												<xsl:with-param name="p_timezone"
												select="$anERPTimeZone"/>
												</xsl:call-template>
											</xsl:variable>
											<!--Convert the final date into SAP format is 'YYYYMMDD'-->
											<xsl:value-of select="substring($v_date, 1, 10)"/>
										</StartDate>
										<EndDate>
											<xsl:value-of select="'9999-12-31'"/>
										</EndDate>
									</ValidityPeriod>
									<xsl:if test="ItemIn/ItemDetail[exists(UnitPrice)]">
										<Rate>
											<DecimalValue>
												<xsl:value-of
												select="ItemIn/ItemDetail/UnitPrice/Money"/>
											</DecimalValue>
											<MeasureUnitCode>
												<xsl:value-of
												select="ItemIn/ItemDetail/UnitOfMeasure"/>
											</MeasureUnitCode>
											<xsl:if
												test="ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']">
												<BaseDecimalValue>
												<xsl:value-of select="ItemIn/ItemDetail/Extrinsic"
												/>
												</BaseDecimalValue>
											</xsl:if>
											<CurrencyCode>
												<xsl:value-of
												select="ItemIn/ItemDetail/UnitPrice/Money/@currency"
												/>
											</CurrencyCode>
										</Rate>
									</xsl:if>
								</PriceSpecification>
								
								<!--Materail Conditions-->
								
								<xsl:for-each
									select="ItemIn/ItemDetail/UnitPrice/Modifications/Modification">
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
																		select="'SchedulingAgreement'"/>
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
																			select="'SchedulingAgreement'"/>
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
																			select="'SchedulingAgreement'"/>
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
																			select="'SchedulingAgreement'"/>
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
												<xsl:variable name="v_date">
													<xsl:call-template name="ERPDateTime">
														<xsl:with-param name="p_date"
															select="$v_docCreateDate"/>
														<xsl:with-param name="p_timezone"
															select="$anERPTimeZone"/>
													</xsl:call-template>
												</xsl:variable>
												<!--Convert the final date into SAP format is 'YYYYMMDD'-->
												<xsl:value-of select="substring($v_date, 1, 10)"/>
											</StartDate>
											<EndDate>
												<xsl:value-of select="'9999-12-31'"/>
											</EndDate>
										</ValidityPeriod>
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
								
							</xsl:otherwise>
						</xsl:choose>

						
						<xsl:if test="exists(TermsOfDelivery)">
							<DeliveryTerms>
								<Incoterms>
									<ClassificationCode>
										<xsl:value-of select="TermsOfDelivery/TransportTerms/@value"
										/>
									</ClassificationCode>
									<TransferLocationName>
										<xsl:value-of select="substring(TermsOfDelivery/TransportTerms, 1 , 28)"/>
									</TransferLocationName>
								</Incoterms>
							</DeliveryTerms>
						</xsl:if>
						<xsl:if test="exists(ItemIn/Comments)">
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
												select="'SchedulingAgreement'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'ItemTextTypecode'"/>
											</xsl:call-template>
										</xsl:value-of>
									</TypeCode>
									<ContentText>
										<xsl:attribute name="languageCode">
											<xsl:variable name="v_lang">
												<xsl:value-of select="ItemIn/Comments/@xml:lang"/>
											</xsl:variable>
											<xsl:value-of select="upper-case($v_lang)"/>
										</xsl:attribute>
										<xsl:variable name="v_comments">
											<xsl:call-template name="removeChild">
												<xsl:with-param name="p_comment"
												select="ItemIn/Comments"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:value-of select="normalize-space($v_comments)"/>
									</ContentText>
								</Text>
							</TextCollection>
						</xsl:if>
						<!--<IG-33017 : RFQ Number and Line item mapping >-->
						<xsl:if
							test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'RFQ']">
							<QuoteReference>
								<ID>
									<xsl:value-of
										select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'RFQ']/@documentID"/>
								</ID>
								<ItemID>
									<xsl:value-of
										select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'RFQ']]/@lineNumber"/>
								</ItemID>
							</QuoteReference>
						</xsl:if>
						<!--<IG-33017 : RFQ Number and Line item mapping >-->
						<xsl:if
							test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'Requisition']">
							<PurchaseRequestReference>
								<ID>
									<xsl:value-of
										select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'Requisition']/@documentID"
									/>
								</ID>
								<ItemID>
									<xsl:value-of
										select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'Requisition']]/@lineNumber"
									/>
								</ItemID>
							</PurchaseRequestReference>
						</xsl:if>
						<!--    Account Assignment-->
						<xsl:variable name="v_accassgncat">
							<xsl:value-of>
								<xsl:call-template name="ReadQuote">
									<xsl:with-param name="p_doctype" select="'SchedulingAgreement'"/>
									<xsl:with-param name="p_pd" select="$v_pd"/>
									<xsl:with-param name="p_attribute"
										select="'AccountAssignmentCat'"/>
								</xsl:call-template>
							</xsl:value-of>
						</xsl:variable>
						<xsl:if
							test="normalize-space(ItemIn/ItemID/BuyerPartID) = '' or ( normalize-space($v_accassgncat) != '' and normalize-space($v_accassgncat) != 'U' )">
							<AccountingCodingBlockDistribution>								
								<AccountingCodingBlockAssignment>
									<OrdinalNumberValue>
										<xsl:value-of select="'1'"/>
									</OrdinalNumberValue>
									<xsl:choose>
										<xsl:when
											test="normalize-space(ItemIn/ItemID/BuyerPartID) != '' or normalize-space($v_accassgncat) != ''">
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
									<xsl:if
										test="$v_accassgncat != 'U' and normalize-space($v_accassgncat) != ''">
										<AccountDeterminationExpenseGroupCode>
											<xsl:value-of>
												<xsl:call-template name="ReadQuote">
													<xsl:with-param name="p_doctype"
														select="'SchedulingAgreement'"/>
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
												select="'SchedulingAgreement'"/>
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
												select="'SchedulingAgreement'"/>
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
												select="'SchedulingAgreement'"/>
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
												select="'SchedulingAgreement'"/>
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
					</Item>
				</xsl:for-each>
				<!--Call template to handle attachment-->
				<xsl:call-template name="InboundAttachsn0"> </xsl:call-template>
			</SchedulingAgreement>
		</n0:SchedulingAgreementERPRequest>
	</xsl:template>
</xsl:stylesheet>
