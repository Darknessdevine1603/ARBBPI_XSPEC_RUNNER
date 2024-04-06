<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n0="http://sap.com/xi/ARBCIG2" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:variable name="v_date">
		<xsl:value-of select="current-date()"/>
	</xsl:variable>
	<!-- parameter -->
	<xsl:param name="anReceiverID"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anERPTimeZone"/>
	<xsl:param name="anSourceDocumentType"/>

	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>

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
		<!-- start of IG-28141: Removing timezone conversion as its not needed  -->
<!--    <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@effectiveDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>-->
		<xsl:value-of select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@effectiveDate"/>
		<!-- End of IG-28141: Removing timezone conversion as its not needed  -->
	</xsl:variable>

	<!--Expiration Date -->
	<xsl:variable name="v_expirationDate">
		<!-- start of IG-28141: Removing timezone conversion as its not needed  -->
<!--    <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@expirationDate"/>
            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
        </xsl:call-template>-->
		<xsl:value-of select="/Combined/Payload/cXML/Request/ContractRequest/ContractRequestHeader/@expirationDate"/>
		<!-- End of IG-28141: Removing timezone conversion as its not needed  -->
	</xsl:variable>

	<!--    Main template-->
	<xsl:template match="Combined">
		<n0:PurchasingContractERPRequest_V1 xmlns:n0="http://sap.com/xi/ARBCIG2">
			<MessageHeader>
				<ReferenceID>
					<xsl:value-of select="'ACM'"/>
				</ReferenceID>
				<CreationDateTime>
					<xsl:variable name="v_date">
						<xsl:call-template name="ERPDateTime">
							<xsl:with-param name="p_date" select="$v_docCreateDate"/>
							<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
						</xsl:call-template>
					</xsl:variable>
					<!--Convert the final date into SAP format is 'YYYYMMDD'-->
					<xsl:value-of select="substring($v_date, 1, 10)"/>
				</CreationDateTime>
				<SenderBusinessSystemID>
					<xsl:value-of select="'CONTRACT'"/>
				</SenderBusinessSystemID>
				<RecipientBusinessSystemID>
					<xsl:value-of select="$anERPSystemID"/>
				</RecipientBusinessSystemID>
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
			</MessageHeader>
			<PurchasingContract>
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
				<xsl:attribute name="itemListCompleteTransmissionIndicator">
					<xsl:value-of select="'TRUE'"/>
				</xsl:attribute>
				<!--ID-->
				<ID>
					<xsl:if
						test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@operation != 'new'">
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/DocumentInfo/@documentID"
						/>
					</xsl:if>
				</ID>
				<!--Companycode-->
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier != ''">
					<CompanyID>
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
						/>
					</CompanyID>
				</xsl:if>
				<xsl:variable name="v_doctyp">
					<xsl:choose>
						<xsl:when
							test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@type = 'value'">
							<xsl:value-of>
								<xsl:call-template name="ReadQuote">
									<xsl:with-param name="p_doctype"
										select="'ContractRequestServices'"/>
									<xsl:with-param name="p_pd" select="$v_pd"/>
									<xsl:with-param name="p_attribute" select="'ValueContract'"/>
								</xsl:call-template>
							</xsl:value-of>
						</xsl:when>
						<xsl:when
							test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@type = 'quantity'">
							<xsl:value-of>
								<xsl:call-template name="ReadQuote">
									<xsl:with-param name="p_doctype"
										select="'ContractRequestServices'"/>
									<xsl:with-param name="p_pd" select="$v_pd"/>
									<xsl:with-param name="p_attribute" select="'QuantityContract'"/>
								</xsl:call-template>
							</xsl:value-of>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="v_documentType">
					<xsl:value-of
						select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/FollowUpDocument/@category"
					/>
				</xsl:variable>
				<xsl:variable name="v_doctyp_lookup">
					<xsl:value-of>
						<xsl:call-template name="LookupTemplate">
							<xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
							<xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
							<xsl:with-param name="p_doctype" select="'ContractRequestServices'"/>
							<xsl:with-param name="p_input" select="$v_documentType"/>
							<xsl:with-param name="p_lookupname" select="'SAPDocType'"/>
							<xsl:with-param name="p_producttype" select="'AribaSourcing'"/>
						</xsl:call-template>
					</xsl:value-of>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length($v_documentType) != 0">
						<ProcessingTypeCode>
							<xsl:choose>
								<xsl:when test="string-length($v_doctyp_lookup) != 0">
									<xsl:value-of select="$v_doctyp_lookup"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$v_doctyp"/>
								</xsl:otherwise>
							</xsl:choose>
						</ProcessingTypeCode>
					</xsl:when>
					<xsl:otherwise>
						<ProcessingTypeCode>
							<xsl:value-of select="$v_doctyp"/>
						</ProcessingTypeCode>
					</xsl:otherwise>
				</xsl:choose>
				<!--               Validity period-->
				<!--<xsl:if test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate' or 'ValidityEndDate']">
				-->
				<ValidityPeriod>
					<StartDate>
						<xsl:choose>
							<xsl:when
								test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']">

								<xsl:variable name="v_date">
									<xsl:call-template name="ERPDateTime">
										<xsl:with-param name="p_date"
											select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/Extrinsic[@name = 'Terms']/Extrinsic[@name = 'ValidityStartDate']"/>
										<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
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
										<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
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
				<!--</xsl:if>-->
				<!--                Exchange Rate-->
				<ExchangeRate>
					<ExchangeRate>
						<UnitCurrency>
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractItemIn[1]/ItemIn/ItemDetail/UnitPrice/Money/@currency"
							/>
						</UnitCurrency>
						<QuotedCurrency>
							<xsl:value-of
								select="Payload/cXML/Request/ContractRequest/ContractItemIn[1]/ItemIn/ItemDetail/UnitPrice/Money/@currency"
							/>
						</QuotedCurrency>
						<Rate>
							<xsl:value-of select="'0'"/>
						</Rate>
						<QuotationDateTime>
							<xsl:variable name="v_date">
								<xsl:call-template name="ERPDateTime">
									<xsl:with-param name="p_date"
										select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@agreementDate"/>
									<xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
								</xsl:call-template>
							</xsl:variable>
							<!--Convert the final date into SAP format is 'YYYYMMDD'-->
							<xsl:value-of select="$v_date"/>
						</QuotationDateTime>
					</ExchangeRate>
					<ExchangeRateFixedIndicator>
						<xsl:value-of select="'1'"/>
					</ExchangeRateFixedIndicator>
				</ExchangeRate>
				<!--                Target amount-->
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
				<xsl:for-each select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/SupplierProductionFacilityRelations/ProductionFacilityAssociation">
					<xsl:if test="@operation = 'new' or @operation = 'update'">
						<Party>
							<xsl:attribute name="actionCode">
								<xsl:choose>
									<xsl:when test="@operation = 'new'">
										<xsl:value-of select="'01'"/>
									</xsl:when>
									<xsl:when test="@operation = 'update'">
										<xsl:value-of select="'02'"/>
									</xsl:when>
<!--									<xsl:when test="@operation = 'delete'">03</xsl:when>-->
								</xsl:choose>	
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
								<xsl:value-of select="ShipTo/Address/@addressID"/>
							</ReceivingPlantID>
							<RoleCode>
								<xsl:value-of select="ProductionFacility/ProductionFacilityRole/IdReference/@identifier"/>
							</RoleCode>
							<DefaultIndicator></DefaultIndicator>
						</Party>
					</xsl:if>
				</xsl:for-each>
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
								<!-- IG-34746 : Incoterms more than the 28 char length causing the SRT: Serialization / Deserialization failed error in SAP  -->
								<xsl:value-of
									select="normalize-space(substring(Payload/cXML/Request/ContractRequest/ContractItemIn[1]/TermsOfDelivery/TransportTerms, 1, 28))"
								/>
							</TransferLocationName>
						</Incoterms>
					</DeliveryTerms>
				</xsl:if>
				<!--                Cash Discount-->
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
				<!--                Text Collection-->
				<xsl:if
					test="exists(Payload/cXML/Request/ContractRequest/ContractRequestHeader/Comments)">
					<TextCollection>
						<Text>
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
							<TypeCode>
								<xsl:value-of>
									<xsl:call-template name="ReadQuote">
										<xsl:with-param name="p_doctype"
											select="'ContractRequestServices'"/>
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
				<!--                Item-->
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
						<TypeCode>
							<xsl:choose>
								<xsl:when
									test="ItemIn/ItemDetail/Extrinsic/@name = 'serviceLineType'">
									<xsl:choose>
										<xsl:when
											test="ItemIn/ItemDetail/Extrinsic[@name = 'serviceLineType'] = 'contingency'"
											>
											<xsl:value-of select="'302'"/>
										</xsl:when>
										<xsl:when
											test="ItemIn/ItemDetail/Extrinsic[@name = 'serviceLineType'] = 'blanket'"
											>
											<xsl:value-of select="'301'"/>
										</xsl:when>
										<xsl:when
											test="ItemIn/ItemDetail/Extrinsic[@name = 'serviceLineType'] = 'information'"
											>
											<xsl:value-of select="'305'"/>
										</xsl:when>
										<xsl:when
											test="ItemIn/ItemDetail/Extrinsic[@name = 'serviceLineType'] = 'openquantity'"
											>
											<xsl:value-of select="'303'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when
									test="normalize-space(ItemIn/@itemType) = 'composite' and normalize-space(ItemIn/@parentLineNumber) != ''"
									>
									<xsl:value-of select="'21'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'19'"/>
								</xsl:otherwise>
							</xsl:choose>
						</TypeCode>
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
										<xsl:when
											test="normalize-space(ItemIn/@itemClassification) = 'service'"
											>
											<xsl:value-of select="'9'"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</ProcessingTypeCode>
						<CancelledIndicator>
							<xsl:value-of select="'0'"/>
						</CancelledIndicator>
						<BlockedIndicator>
							<xsl:value-of select="'0'"/>
						</BlockedIndicator>
						<xsl:if test="ItemIn/@quantity != ''">
							<TargetQuantity>
								<xsl:attribute name="unitCode">
									<xsl:value-of select="ItemIn/ItemDetail/UnitOfMeasure"/>
								</xsl:attribute>
								<xsl:value-of select="ItemIn/@quantity"/>
							</TargetQuantity>
						</xsl:if>
						<xsl:if
							test="normalize-space(ItemIn/@itemType) = 'composite' and normalize-space(ItemIn/@parentLineNumber) != ''">
							<FormattedName>
								<xsl:value-of select="ItemIn/ItemDetail/Description/ShortName"/>
							</FormattedName>
						</xsl:if>
						<xsl:if test="normalize-space(ItemIn/@parentLineNumber) != ''">
							<HierarchyRelationship>
								<ParentItemID>
									<xsl:choose>
										<xsl:when test="@operation = 'new'">
											<xsl:choose>
												<xsl:when test="ItemIn/ItemID/IdReference[@domain = 'SAPParentLineNumber']/@identifier != ''">
													<xsl:value-of select="ItemIn/ItemID/IdReference[@domain = 'SAPParentLineNumber']/@identifier"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="../ContractRequestHeader/@operation = 'update'">
															<xsl:value-of select="ItemIn/@parentLineNumber"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="normalize-space(ItemIn/@itemType) = 'composite'">
																	<xsl:value-of select="ItemIn/@parentLineNumber"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="format-number(ItemIn/@parentLineNumber,'0000000000')"/>
																</xsl:otherwise>
															</xsl:choose>															
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="ItemIn/ItemID/IdReference[@domain = 'SAPParentLineNumber']/@identifier"/>
										</xsl:otherwise>
									</xsl:choose>
								</ParentItemID>
								<TypeCode>
									<xsl:value-of select="'007'"/>
								</TypeCode>
							</HierarchyRelationship>
						</xsl:if>
						<xsl:if test="normalize-space(ItemIn/ItemID/BuyerPartID) != ''">
							<Product>
								<InternalID>
									<xsl:value-of select="ItemIn/ItemID/BuyerPartID"/>
								</InternalID>
								<SellerID>
									<xsl:value-of select="ItemIn/ItemID/SupplierPartID"/>
								</SellerID>
								<xsl:if test="ItemIn/ItemDetail/ManufacturerPartID != ''">
									<ManufacturerID>
										<xsl:value-of select="ItemIn/ItemDetail/ManufacturerPartID"
										/>
									</ManufacturerID>
								</xsl:if>
							</Product>
						</xsl:if>
						<ProductCategory>
							<InternalID>
								<xsl:value-of
									select="ItemIn/ItemDetail/Classification[@domain = 'MaterialGroup']"
								/>
							</InternalID>
							<BuyerID>
								<xsl:value-of
									select="ItemIn/ItemDetail/Classification[@domain = 'MaterialGroup']"
								/>
							</BuyerID>
						</ProductCategory>
						<xsl:if test="ItemIn/@itemClassification = 'service'">
							<ServiceItemSpecificDetails>
								<AlternateAllowedIndicator>
									<xsl:value-of select="'X'"/>
								</AlternateAllowedIndicator>
								<ByBidderProvidedIndicator>
									<xsl:value-of select="'X'"/>
								</ByBidderProvidedIndicator>
								<PriceChangeAllowedIndicator>
									<xsl:value-of select="'X'"/>
								</PriceChangeAllowedIndicator>
							</ServiceItemSpecificDetails>
						</xsl:if>
						<!--gross price-->
						<xsl:if
							test="ItemIn/@itemType = 'composite' and not(ItemIn/@parentLineNumber)">
							<PriceSpecificationElement>
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
								<xsl:if test="ItemIn/@itemClassification = 'service'">
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'ContractRequestServices'"/>
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
										</Date>
									</StartTimePoint>
									<EndTimePoint>
										<TypeCode>
											<xsl:value-of select="'1'"/>
										</TypeCode>
										<Date>
											<xsl:value-of select="'9999-12-31'"/>
										</Date>
									</EndTimePoint>
								</ValidityPeriod>
								<PropertyDefinitionClassCode>
									<xsl:value-of select="'1'"/>
								</PropertyDefinitionClassCode>
								<xsl:if test="ItemIn/ItemDetail[exists(UnitPrice)]">
									<Rate>
										<DecimalValue>
											<xsl:value-of select="ItemIn/ItemDetail/UnitPrice/Money"
											/>
										</DecimalValue>
										<MeasureUnitCode>
											<xsl:value-of select="ItemIn/ItemDetail/UnitOfMeasure"/>
										</MeasureUnitCode>
										<xsl:if
											test="ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']">
											<BaseDecimalValue>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']) != 0">
												<xsl:value-of
												select="ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'1'"/>
												</xsl:otherwise>
												</xsl:choose>
											</BaseDecimalValue>
										</xsl:if>
										<CurrencyCode>
											<xsl:value-of
												select="ItemIn/ItemDetail/UnitPrice/Money/@currency"
											/>
										</CurrencyCode>
									</Rate>
								</xsl:if>
							</PriceSpecificationElement>
						</xsl:if>
						<!--gross price-->
						<xsl:if
							test="ItemIn/@itemType = 'item' and not(ItemIn/ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod/ConditionTypes/ConditionType/@name = 'PRICE')">
							<PriceSpecificationElement>
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
								<xsl:if test="ItemIn/@itemClassification = 'service'">
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'ContractRequestServices'"/>
												<xsl:with-param name="p_pd" select="$v_pd"/>
												<xsl:with-param name="p_attribute"
												select="'servicegrosspriceTypecode'"/>
											</xsl:call-template>
										</xsl:value-of>
									</TypeCode>
								</xsl:if>
								<xsl:if test="ItemIn/@itemClassification = 'material'">
									<TypeCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'ContractRequestServices'"/>
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
										</Date>
									</StartTimePoint>
									<EndTimePoint>
										<TypeCode>
											<xsl:value-of select="'1'"/>
										</TypeCode>
										<Date>
											<xsl:value-of select="'9999-12-31'"/>
										</Date>
									</EndTimePoint>
								</ValidityPeriod>
								<PropertyDefinitionClassCode>
									<xsl:value-of select="'1'"/>
								</PropertyDefinitionClassCode>
								<xsl:if test="ItemIn/ItemDetail[exists(UnitPrice)]">
									<Rate>
										<DecimalValue>
											<xsl:value-of select="ItemIn/ItemDetail/UnitPrice/Money"
											/>
										</DecimalValue>
										<MeasureUnitCode>
											<xsl:value-of select="ItemIn/ItemDetail/UnitOfMeasure"/>
										</MeasureUnitCode>
										<xsl:if
											test="ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']">
											<BaseDecimalValue>
												<xsl:choose>
												<xsl:when
												test="string-length(ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']) != 0">
												<xsl:value-of
												select="ItemIn/ItemDetail/Extrinsic[@name = 'PriceUnit']"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'1'"/>
												</xsl:otherwise>
												</xsl:choose>
											</BaseDecimalValue>
										</xsl:if>
										<CurrencyCode>
											<xsl:value-of
												select="ItemIn/ItemDetail/UnitPrice/Money/@currency"
											/>
										</CurrencyCode>
									</Rate>
								</xsl:if>
							</PriceSpecificationElement>
						</xsl:if>
						<!--Materail Conditions-->
						<xsl:if test="not(ItemIn/@parentLineNumber)">
							<xsl:choose>
								<xsl:when
									test="exists(ItemIn/ItemDetail/UnitPrice/PricingConditions)">
									<xsl:for-each
										select="ItemIn/ItemDetail/UnitPrice/PricingConditions/ValidityPeriods/ValidityPeriod">
										<xsl:for-each select="ConditionTypes/ConditionType">
											<xsl:if
												test="not(@name = 'EXTENDEDPRICE')">
												<PriceSpecificationElement>
												<xsl:attribute name="actionCode">
												<xsl:choose>
												<xsl:when
												test="../../../../../../../../@operation = 'new'"
												>
													<xsl:value-of select="'01'"/>
												</xsl:when>
												<xsl:when
												test="../../../../../../../../@operation = 'update'"
												>
													<xsl:value-of select="'02'"/>
												</xsl:when>
												<xsl:when
												test="../../../../../../../../@operation = 'delete'"
												>
													<xsl:value-of select="'03'"/>
												</xsl:when>
												</xsl:choose>
												</xsl:attribute>
												<TypeCode>
												<xsl:value-of>
												<xsl:call-template name="LookupTemplate">
												<xsl:with-param name="p_anERPSystemID"
												select="$v_sysid"/>
												<xsl:with-param name="p_anSupplierANID"
												select="$anReceiverID"/>
												<xsl:with-param name="p_doctype"
												select="'ContractRequestServices'"/>
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
												test="../../../../../../Extrinsic[@name = 'PriceUnit']">
												<BaseDecimalValue>
												<xsl:choose>
												<xsl:when
												test="string-length(../../../../../../Extrinsic[@name = 'PriceUnit']) != 0">
												<xsl:value-of
												select="../../../../../../Extrinsic[@name = 'PriceUnit']"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'1'"/>
												</xsl:otherwise>
												</xsl:choose>
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
												test="../../../../../../../../Extrinsic[@name = 'PriceUnit']">
												<BaseDecimalValue>
												<xsl:choose>
												<xsl:when
												test="string-length(../../../../../../../../Extrinsic[@name = 'PriceUnit']) != 0">
												<xsl:value-of
												select="../../../../../../../../Extrinsic[@name = 'PriceUnit']"
												/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'1'"/>
												</xsl:otherwise>
												</xsl:choose>
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
								<xsl:when test="exists(ItemIn/ItemDetail/UnitPrice/Modifications)">
									<xsl:for-each
										select="ItemIn/ItemDetail/UnitPrice/Modifications/Modification">
										<PriceSpecificationElement>
											<xsl:attribute name="actionCode">
												<xsl:choose>
												<xsl:when test="../../../../../@operation = 'new'"
												>
													<xsl:value-of select="'01'"/>
												</xsl:when>
												<xsl:when
												test="../../../../../@operation = 'update'"
												>
													<xsl:value-of select="'02'"/>
												</xsl:when>
												<xsl:when
												test="../../../../../@operation = 'delete'"
												>
													<xsl:value-of select="'03'"/>
												</xsl:when>
												</xsl:choose>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												</Date>
												</StartTimePoint>
												<EndTimePoint>
												<TypeCode>
													<xsl:value-of select="'1'"/>
												</TypeCode>
												<Date>
													<xsl:value-of select="'9999-12-31'"/>
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
												<CurrencyCode>
												<xsl:value-of select="../../Money/@currency"/>
												</CurrencyCode>
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
						<xsl:if
							test="ItemIn/@itemType = 'item' and exists(ItemIn/@parentLineNumber)">
							<xsl:for-each
								select="ItemIn/ItemDetail/UnitPrice/Modifications/Modification">
								<PriceSpecificationElement>
									<xsl:attribute name="actionCode">
										<xsl:choose>
											<xsl:when test="../../../../../@operation = 'new'"
												>
												<xsl:value-of select="'01'"/>
											</xsl:when>
											<xsl:when test="../../../../../@operation = 'update'"
												>
												<xsl:value-of select="'02'"/>
											</xsl:when>
											<xsl:when test="../../../../../@operation = 'delete'"
												>
												<xsl:value-of select="'03'"/>
											</xsl:when>
										</xsl:choose>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
											</Date>
										</StartTimePoint>
										<EndTimePoint>
											<TypeCode>
												<xsl:value-of select="'1'"/>
											</TypeCode>
											<Date>
												<xsl:value-of select="'9999-12-31'"/>
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
										<CurrencyCode>
											<xsl:value-of select="../../Money/@currency"/>
										</CurrencyCode>
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
						<xsl:if
							test="ItemIn/@itemType = 'composite' and exists(ItemIn/@parentLineNumber)">
							<xsl:for-each
								select="ItemIn/ItemDetail/UnitPrice/Modifications/Modification">
								<PriceSpecificationElement>
									<xsl:attribute name="actionCode">
										<xsl:choose>
											<xsl:when test="../../../../../@operation = 'new'"
												>
												<xsl:value-of select="'01'"/>
											</xsl:when>
											<xsl:when test="../../../../../@operation = 'update'"
												>
												<xsl:value-of select="'02'"/>
											</xsl:when>
											<xsl:when test="../../../../../@operation = 'delete'"
												>
												<xsl:value-of select="'03'"/>
											</xsl:when>
										</xsl:choose>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
											</Date>
										</StartTimePoint>
										<EndTimePoint>
											<TypeCode>
												<xsl:value-of select="'1'"/>
											</TypeCode>
											<Date>
												<xsl:value-of select="'9999-12-31'"/>
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
										<CurrencyCode>
											<xsl:value-of select="../../Money/@currency"/>
										</CurrencyCode>
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
						<xsl:if test="ItemIn/ShipTo/Address/@addressID != ''">
							<ReceivingPlantID>
								<xsl:value-of select="ItemIn/ShipTo/Address/@addressID"/>
							</ReceivingPlantID>
						</xsl:if>
						<xsl:if test="exists(TermsOfDelivery)">
							<DeliveryTerms>
								<Incoterms>
									<ClassificationCode>
										<xsl:value-of select="TermsOfDelivery/TransportTerms/@value"
										/>
									</ClassificationCode>
									<TransferLocationName>
										<!-- IG-34746 : Incoterms more than the 28 char length causing the SRT: Serialization / Deserialization failed error in SAP  -->
										<xsl:value-of select="normalize-space(substring(TermsOfDelivery/TransportTerms, 1, 28))"/>
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
												select="'ContractRequestServices'"/>
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
						<xsl:if test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'RFQ']">
							<QuoteReference>
								<ID>
									<xsl:value-of
										select="ReferenceDocumentInfo/DocumentInfo[@documentType = 'RFQ']/@documentID"
									/>
								</ID>
								<ItemID>
									<xsl:value-of
										select="ReferenceDocumentInfo[DocumentInfo[@documentType = 'RFQ']]/@lineNumber"
									/>
								</ItemID>
							</QuoteReference>
						</xsl:if>

						<xsl:if test="ReferenceDocumentInfo/DocumentInfo[@documentType = 'Requisition']">
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
						<AccountingCodingBlockDistribution>
							<xsl:variable name="v_accassgncat">
								<xsl:value-of>
									<xsl:call-template name="ReadQuote">
										<xsl:with-param name="p_doctype"
											select="'ContractRequestServices'"/>
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
								<xsl:if
									test="ItemIn/@itemType = 'item' and exists(ItemIn/@parentLineNumber)">
									<OrdinalNumberValue>
										<xsl:value-of select="'1'"/>
									</OrdinalNumberValue>
								</xsl:if>
								<xsl:if test="$v_accassgncat != 'U'">
									<AccountDeterminationExpenseGroupCode>
										<xsl:value-of>
											<xsl:call-template name="ReadQuote">
												<xsl:with-param name="p_doctype"
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
												select="'ContractRequestServices'"/>
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
								<!--<xsl:variable name="v_lang">
									<xsl:value-of select="ItemIn/ItemDetail/Description/@xml:lang"/>
								</xsl:variable>-->
								<xsl:value-of select="ItemIn/ItemDetail/Description[1]/@xml:lang"/>
							</xsl:attribute>
							<xsl:value-of select="ItemIn/ItemDetail/Description[1]"/>
						</Description>
						<n0:AribaContractItemID>
							<xsl:value-of select="ItemIn/@lineNumber"/>
						</n0:AribaContractItemID>
					</Item>
				</xsl:for-each>
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationID/Credential[@domain = 'NetworkID']/Identity != ''">
					<n0:AribaSupplierNetworkID>
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/OrganizationID/Credential[@domain = 'NetworkID']/Identity"
						/>
					</n0:AribaSupplierNetworkID>
				</xsl:if>
				<xsl:if
					test="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@contractID != ''">
					<n0:AribaContractID>
						<xsl:value-of
							select="Payload/cXML/Request/ContractRequest/ContractRequestHeader/@contractID"
						/>
					</n0:AribaContractID>
				</xsl:if>
				<!--Call template to handle attachment-->
				<xsl:call-template name="InboundAttachsn0"> </xsl:call-template>
			</PurchasingContract>
		</n0:PurchasingContractERPRequest_V1>
	</xsl:template>
</xsl:stylesheet>
