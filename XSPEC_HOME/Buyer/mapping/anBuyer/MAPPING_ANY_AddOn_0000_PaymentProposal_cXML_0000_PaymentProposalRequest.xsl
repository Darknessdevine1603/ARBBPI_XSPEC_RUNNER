<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
	<xsl:param name="anIsMultiERP"/>
	<xsl:param name="anERPTimeZone"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anProviderANID">ANOO1</xsl:param>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anTargetDocumentType"/>
	<xsl:param name="anEnvName"/>

<!--	<xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
		<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/> 
	<xsl:variable name="v_pd">
		<xsl:call-template name="PrepareCrossref">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
			<xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
		</xsl:call-template>
	</xsl:variable>


	<xsl:template match="/n0:PaymentProposalRequest">
		<xsl:variable name="v_pp" select="item"/>
		<Combined>
			<Payload>
				<cXML>
					<xsl:attribute name="payloadID">
						<xsl:value-of select="$anPayloadID"/>
					</xsl:attribute>
					<xsl:attribute name="timestamp">
						<xsl:variable name="curDate">
							<xsl:value-of select="current-dateTime()"/>
						</xsl:variable>
						<xsl:value-of
							select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"
						/>
					</xsl:attribute>
					<Header>
						<From>
							<xsl:call-template name="MultiERPTemplateOut">
								<xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
								<xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
							</xsl:call-template>
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'NetworkID'"/>
								</xsl:attribute>
								<Identity>
									<xsl:value-of select="$anSupplierANID"/>
								</Identity>
							</Credential>
							<!--End Point Fix for CIG-->
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'EndPointID'"/>
								</xsl:attribute>
								<Identity>
									<xsl:value-of select="'CIG'"/>
								</Identity>
							</Credential> 
						</From>
						<To>
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'VendorID'"/>
								</xsl:attribute>
								<Identity>
											<xsl:value-of select="$v_pp/PAYEE/PAYEE"/>
								</Identity>
							</Credential>
							<Correspondent>
								<Contact>
									<xsl:attribute name="role" select="'correspondent'"/>
									<Name>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="$v_pp/PAYEE/LANGUAGE_ISO"/>
										</xsl:attribute>
										<xsl:value-of select="$v_pp/PAYEE/VENDOR_NAME"/>
									</Name>
									<PostalAddress>
										<DeliverTo>
											<xsl:value-of select="$v_pp/PAYEE/VENDOR_NAME"/>
										</DeliverTo>
										<Street>
											<xsl:value-of select="$v_pp/PAYEE/STREET1"/>
										</Street>
										<City>
											<xsl:value-of select="$v_pp/PAYEE/CITY"/>
										</City>
										<State>
											<xsl:value-of select="$v_pp/PAYEE/STATE"/>
										</State>
										<PostalCode>
											<xsl:value-of select="$v_pp/PAYEE/POSTAL_CODE"/>
										</PostalCode>
										<Country>
											<xsl:attribute name="isoCountryCode" select="$v_pp/PAYEE/COUNTRY"/>
										</Country>
									</PostalAddress>
									<Email>
										<xsl:attribute name="name">
											<xsl:value-of select="'routing'"/>
										</xsl:attribute>
										<xsl:value-of select="$v_pp/PAYEE/EMAIL"/>
									</Email>
									<Phone>
										<TelephoneNumber>
											<CountryCode>
												<xsl:attribute name="isoCountryCode"/>
											</CountryCode>
											<AreaOrCityCode> </AreaOrCityCode>
											<Number>
												<xsl:value-of select="$v_pp/PAYEE/PHONE"/>
											</Number>
										</TelephoneNumber>
									</Phone>
									<Fax>
										<TelephoneNumber>
											<CountryCode>
												<xsl:attribute name="isoCountryCode"/>
											</CountryCode>
											<AreaOrCityCode> </AreaOrCityCode>
											<Number>
												<xsl:value-of select="$v_pp/PAYEE/FAX"/>
											</Number>
										</TelephoneNumber>
									</Fax>
								</Contact>
							</Correspondent>
						</To>
						<Sender>
							<Credential domain="NetworkID">
								<Identity>
									<xsl:value-of select="$anProviderANID"/>
								</Identity>
								<SharedSecret>
									<xsl:value-of select="$anSharedSecrete"/>
								</SharedSecret>
							</Credential>
							<UserAgent>
								<xsl:value-of select="'Ariba Supplier'"/>
							</UserAgent>
						</Sender>
					</Header>
					<Request>
						<xsl:choose>
							<xsl:when test="$anEnvName = 'PROD'">
								<xsl:attribute name="deploymentMode">
									<xsl:value-of select="'production'"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="deploymentMode">
									<xsl:value-of select="'test'"/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="item">
							<PaymentProposalRequest>
								<xsl:attribute name="paymentProposalID">
									<xsl:value-of select="PROPOSAL/PROPOSALID"/>
								</xsl:attribute>
								<xsl:attribute name="operation">
									<xsl:value-of select="PROPOSAL/OPERATION"/>
								</xsl:attribute>
								<xsl:attribute name="paymentDate">
									<xsl:call-template name="ANDateTime">
										<xsl:with-param name="p_date">
											<xsl:value-of select="translate(PROPOSAL/DUE_DATE, '-', '')"/>
										</xsl:with-param>
										<xsl:with-param name="p_time">
											<xsl:value-of select="translate(PROPOSAL/REF_DOC_TIME, ':', '' )"/>
										</xsl:with-param>
										<xsl:with-param name="p_timezone">
											<xsl:value-of select="$anERPTimeZone"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="companyCode">
									<xsl:value-of select="PROPOSAL/PAY_COMPANY"/>
								</xsl:attribute>
								<PayableInfo>
									<PayableInvoiceInfo>
										<InvoiceIDInfo>
											<xsl:attribute name="invoiceID">
												<xsl:value-of select="PROPOSAL/REF_INV_NUM"/>
											</xsl:attribute>
											<xsl:attribute name="invoiceDate">
												<xsl:call-template name="ANDateTime">
													<xsl:with-param name="p_date">
														<xsl:value-of select="translate(PROPOSAL/REF_DOC_DATE, '-', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_time">
														<xsl:value-of select="translate(PROPOSAL/REF_DOC_TIME, ':', '')"/>
													</xsl:with-param>
													<xsl:with-param name="p_timezone">
														<xsl:value-of select="$anERPTimeZone"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</InvoiceIDInfo>
									</PayableInvoiceInfo>
								</PayableInfo>
								<PaymentMethod>
									<xsl:attribute name="type">
										<xsl:choose>
											<xsl:when
												test="(PROPOSAL/PAYMENT_METHOD = 'A' or PROPOSAL/PAYMENT_METHOD = 'T' or PROPOSAL/PAYMENT_METHOD = 'U')">
												
													<xsl:value-of select="'ach'"/>
												
											</xsl:when>
											<xsl:when test="(PROPOSAL/PAYMENT_METHOD = 'Z')">
												
													<xsl:value-of select="'wire'"/>
												
											</xsl:when>
											<xsl:when test="(PROPOSAL/PAYMENT_METHOD = 'C')">
												
													<xsl:value-of select="'check'"/>
												
											</xsl:when>
											<xsl:otherwise>
												
													<xsl:value-of select="'other'"/>
												
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<Description>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="PAYER/LANGUAGE_ISO"/>
										</xsl:attribute>
										<ShortName>
											<xsl:choose>
												<xsl:when test="normalize-space(PROPOSAL/PAYMENT_METHOD) = ''">
												
													<xsl:value-of select="'other'"/>
												
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="PROPOSAL/PAYMENT_METHOD_DESC"/>
												</xsl:otherwise>
											</xsl:choose>
										</ShortName>
									</Description>
								</PaymentMethod>
								<PaymentPartner>
									<Contact>
										<xsl:attribute name="role">
											<xsl:value-of select="'payer'"/>
										</xsl:attribute>
										<xsl:if test="string-length(normalize-space(PAYER/PAYER)) > 0">
											<xsl:attribute name="addressID">
												<xsl:value-of select="normalize-space(PAYER/PAYER)"/>
											</xsl:attribute>										
											<xsl:attribute name="addressIDDomain">
												<xsl:value-of select="'payeeID'"/>
											</xsl:attribute>
										</xsl:if>
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="PAYER/LANGUAGE_ISO"/>
											</xsl:attribute>
											<xsl:value-of select="PAYER/PAYER_NAME"/>
										</Name>
										<PostalAddress>
											<xsl:choose>
												<xsl:when test="string-length(normalize-space(PAYER/POSTALADDRESSNAME)) > 0">
													<xsl:attribute name="name">
														<xsl:value-of select="normalize-space(PAYER/POSTALADDRESSNAME)"/>
													</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="name">
														<xsl:value-of select="PAYER/POSTAL_ADDRESS"/>
													</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>											
											<Street>
												<xsl:value-of select="PAYER/STREET1"/>
											</Street>
											<Street>
												<xsl:value-of select="PAYER/STREET2"/>
											</Street>
											<Street>
												<xsl:value-of select="PAYER/STREET3"/>
											</Street>
											<City>
												<xsl:value-of select="PAYER/CITY"/>
											</City>
											<State>
												<xsl:value-of select="PAYER/STATE"/>
											</State>
											<PostalCode>
												<xsl:value-of select="PAYER/POSTAL_CODE"/>
											</PostalCode>
											<Country>
												<xsl:attribute name="isoCountryCode">
												<xsl:value-of select="PAYER/COUNTRY"/>
												</xsl:attribute>
												<xsl:value-of select="PAYER/COUNTRY"/>
											</Country>
										</PostalAddress>
										<Phone>
											<TelephoneNumber>
												<CountryCode>
												<xsl:attribute name="isoCountryCode">
												<xsl:value-of select="PAYER/COUNTRY"/>
												</xsl:attribute>
												<xsl:value-of select="PAYER/CNTRYISDCODE"/>
												</CountryCode>
												<AreaOrCityCode> </AreaOrCityCode>
												<Number>
												<xsl:value-of select="PAYER/PHONE"/>
												</Number>
												<Extension>
												<xsl:value-of select="PAYER/TELEEXTN"/>	
												</Extension>
											</TelephoneNumber>
										</Phone>
										<Fax>
											<TelephoneNumber>
												<CountryCode>
												<xsl:attribute name="isoCountryCode">
												<xsl:value-of select="PAYER/COUNTRY"/>
												</xsl:attribute>
												<xsl:value-of select="PAYER/CNTRYISDCODE"/>
												</CountryCode>
												<AreaOrCityCode> </AreaOrCityCode>
												<Number>
												<xsl:value-of select="PAYER/FAX"/>
												</Number>
												<Extension>
												<xsl:value-of select="PAYER/FAXEXTN"/>	
												</Extension>
											</TelephoneNumber>
										</Fax>
									</Contact>
									<IdReference>
										<xsl:attribute name="identifier">
											<xsl:value-of select="PAYEE/BANK_ACCOUNT_NUM"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:value-of select="'bankAccountID'"/>
										</xsl:attribute>
									</IdReference>
								</PaymentPartner>
								<PaymentPartner>
									<Contact>
										<xsl:attribute name="role">
											<xsl:value-of select="'payee'"/>
										</xsl:attribute>
										<xsl:if test="string-length(normalize-space(PAYEE/PAYEE)) > 0">
											<xsl:attribute name="addressID">
												<xsl:value-of select="normalize-space(replace(PAYEE/PAYEE,'^0+',''))"/>
											</xsl:attribute>									
											<xsl:attribute name="addressIDDomain">
												<xsl:value-of select="'payerID'"/>
											</xsl:attribute>
										</xsl:if>
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="PAYEE/LANGUAGE_ISO"/>
											</xsl:attribute>
											<xsl:value-of select="PAYEE/VENDOR_NAME"/>
										</Name>
										<PostalAddress>
											<xsl:attribute name="name">
												<xsl:value-of select="PAYEE/POSTAL_ADDRESS"/>
											</xsl:attribute>
											<Street>
												<xsl:value-of select="PAYEE/STREET1"/>
											</Street>
											<Street>
												<xsl:value-of select="PAYEE/STREET2"/>
											</Street>
											<Street>
												<xsl:value-of select="PAYEE/STREET3"/>
											</Street>
											<City>
												<xsl:value-of select="PAYEE/CITY"/>
											</City>
											<State>
												<xsl:value-of select="PAYEE/STATE"/>
											</State>
											<PostalCode>
												<xsl:value-of select="PAYEE/POSTAL_CODE"/>
											</PostalCode>
											<Country>
												<xsl:attribute name="isoCountryCode">
												<xsl:value-of select="PAYEE/COUNTRY"/>
												</xsl:attribute>
												<xsl:value-of select="PAYEE/COUNTRY"/>
											</Country>
										</PostalAddress>
										<xsl:if test="string-length(normalize-space(PAYEE/EMAIL)) > 0">
											<Email>											
												<xsl:attribute name="name">
													<xsl:value-of select="'default'"/>
												</xsl:attribute>
												<xsl:value-of select="normalize-space(PAYEE/EMAIL)"/>
											</Email>
										</xsl:if>
										<Phone>
											<TelephoneNumber>
												<CountryCode>
												<xsl:attribute name="isoCountryCode">
												<xsl:value-of select="PAYEE/COUNTRY"/>													
												</xsl:attribute>
												<xsl:value-of select="PAYEE/CNTRYISDCODE"/>
												</CountryCode>
												<AreaOrCityCode> </AreaOrCityCode>
												<Number>
												<xsl:value-of select="PAYEE/PHONE"/>
												</Number>
											</TelephoneNumber>
										</Phone>
										<Fax>
											<TelephoneNumber>
												<CountryCode>
												<xsl:attribute name="isoCountryCode">
												<xsl:value-of select="PAYEE/COUNTRY"/>
												</xsl:attribute>
												<xsl:value-of select="PAYER/CNTRYISDCODE"/>
												</CountryCode>
												<AreaOrCityCode> </AreaOrCityCode>
												<Number>
												<xsl:value-of select="PAYEE/FAX"/>
												</Number>
											</TelephoneNumber>
										</Fax>
									</Contact>
								</PaymentPartner>
								<xsl:if test="REC_BANK">
									<PaymentPartner>
										<Contact>
											<xsl:attribute name="role">
												<xsl:value-of select="'receivingBank'"/>
											</xsl:attribute>
											<xsl:attribute name="addressID">
												<xsl:value-of select="REC_BANK/RECV_BANK"/>
											</xsl:attribute>
											<Name>
												<xsl:attribute name="xml:lang">
												<xsl:value-of select="REC_BANK/LANGUAGE_ISO"/>
												</xsl:attribute>
												<xsl:value-of select="REC_BANK/BANK_NAME"/>
											</Name>
											<PostalAddress>
												<Street><xsl:value-of select="REC_BANK/STREET"/></Street>
												<Street> </Street>
												<Street> </Street>
												<City>
												<xsl:value-of select="REC_BANK/CITY"/>
												</City>
												<State>
												<xsl:value-of select="REC_BANK/STATE"/>
												</State>
												<Country>
												<xsl:attribute name="isoCountryCode">
												<xsl:value-of select="REC_BANK/COUNTRY"/>
												</xsl:attribute>
												<xsl:value-of select="REC_BANK/COUNTRY"/>
												</Country>
											</PostalAddress>
										</Contact>
										<IdReference>
											<xsl:attribute name="identifier">
												<xsl:value-of select="REC_BANK/BANK_ACCOUNT_NUM"/>
											</xsl:attribute>
											<xsl:attribute name="domain">
												<xsl:value-of select="'abaRoutingNumber'"/></xsl:attribute>
										</IdReference>
									</PaymentPartner>
								</xsl:if>
								<xsl:if test="HOUSE_BANK">
									<PaymentPartner>
										<Contact>
											<xsl:attribute name="role">
												<xsl:value-of select="'originatingBank'"/>
											</xsl:attribute>
											<Name>
												<xsl:attribute name="xml:lang">
													<xsl:value-of select="HOUSE_BANK/LANGUISO"/>
												</xsl:attribute>
												<xsl:value-of select="HOUSE_BANK/BANKNAME"/>																								
											</Name>
											<PostalAddress>
												<Street>
													<xsl:value-of select="HOUSE_BANK/STREET"/>
												</Street>
												<City>
													<xsl:value-of select="HOUSE_BANK/CITY"/>
												</City>
												<State>
													<xsl:value-of select="HOUSE_BANK/STATE"/>
												</State>												
												<Country>
													<xsl:attribute name="isoCountryCode">
														<xsl:value-of select="HOUSE_BANK/COUNTRY_ISO"/>
													</xsl:attribute>
													<xsl:value-of select="HOUSE_BANK/COUNTRY"/>
												</Country>
											</PostalAddress>
												<Phone>
													<TelephoneNumber>
														<CountryCode>
													    <xsl:attribute name="isoCountryCode">
														<xsl:value-of select="HOUSE_BANK/COUNTRY_ISO"/>
														</xsl:attribute>
														<xsl:value-of select="HOUSE_BANK/CNTRYISDCODE"/>
														</CountryCode>
														<AreaOrCityCode></AreaOrCityCode>	
														<Number>
														<xsl:value-of select="HOUSE_BANK/PHONE"/>	
														</Number>												   
													</TelephoneNumber>
												</Phone>																							
										</Contact>
										<IdReference>
											<xsl:attribute name="identifier">
												<xsl:value-of select="HOUSE_BANK/BANKACCOUNTNUM"/>
											</xsl:attribute>
											<xsl:attribute name="domain">
												<xsl:value-of select="'bankAccountID'"/>
											</xsl:attribute>
										</IdReference>
									</PaymentPartner>									
								</xsl:if>
								<xsl:if test="(string-length(normalize-space(PROPOSAL/ZTERM)) > 0)">
									<PaymentTerms>
										<xsl:attribute name="paymentTermCode">
											<xsl:value-of select="normalize-space(PROPOSAL/ZTERM)"/>
										</xsl:attribute>
									</PaymentTerms>
								</xsl:if>	
								<GrossAmount>
									<Money>
										<xsl:attribute name="currency">
											<xsl:value-of select="PROPOSAL/PYMNT_CURRENCY"/>
										</xsl:attribute>
										<xsl:value-of
											select="format-number(number(PROPOSAL/GROSS_AMT), '0.00')"
										/>
									</Money>
								</GrossAmount>
								<DiscountBasis>
									<Money>
										<xsl:attribute name="currency">
											<xsl:value-of select="PROPOSAL/PYMNT_CURRENCY"/>
										</xsl:attribute>
										<xsl:value-of
											select="format-number(number(PROPOSAL/DISCOUNTBASIS), '0.00')"
										/>
									</Money>
								</DiscountBasis>
								<DiscountAmount>
									<Money>
										<xsl:attribute name="currency">
											<xsl:value-of select="PROPOSAL/DISC_CURRENCY"/>
										</xsl:attribute>
										<xsl:value-of select="PROPOSAL/DISC_AMT"/>
									</Money>
								</DiscountAmount>
								<xsl:if test="./PROPOSAL/TAX/TAXITEM[@TAXAMOUNT]">
									<Tax>
										<xsl:choose>
											<xsl:when test="PROPOSAL/TOTALTAX">
												<xsl:for-each select="PROPOSAL/TOTALTAX">
												<Money>
												<xsl:attribute name="currency">
													
												<xsl:value-of select="../PYMNT_CURRENCY"/>
												</xsl:attribute>
												<xsl:value-of
												select="format-number(number(string(number(.))), '0.00')"
												/>
												</Money>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<Money>
												<xsl:attribute name="currency">
													
												<xsl:value-of select="PROPOSAL/PYMNT_CURRENCY"/> 
												</xsl:attribute>
												<xsl:value-of
												select="format-number(number('0'), '0.00')"/>
												</Money>
											</xsl:otherwise>
										</xsl:choose>
										<Description>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="'EN'"/>
											</xsl:attribute>
											<xsl:value-of select="'Tax Summary'"/>
										</Description>
										<xsl:for-each select="PROPOSAL/TAX/TAXITEM">
											<xsl:if test="@TAXAMOUNT">
																													
											<TaxDetail>
												<xsl:if test="not(@TAXCATEGORY)">
												<xsl:attribute name="category"/>
												</xsl:if>
												<xsl:if test="@TAXCATEGORY">
												<xsl:for-each select="@TAXCATEGORY">
												<xsl:attribute name="category">
												<xsl:value-of select="."/>
												</xsl:attribute>
												</xsl:for-each>
												</xsl:if>
												
												<xsl:if test="@TAXAMOUNT">
												<xsl:for-each select="@TAXAMOUNT">
												<TaxAmount>
												<Money>
												<xsl:attribute name="currency">
													
													<xsl:value-of select="../../../PYMNT_CURRENCY"/>
												</xsl:attribute>
												<xsl:value-of select="."/>
												</Money>
												</TaxAmount>
												</xsl:for-each>
												</xsl:if>												
												
												<xsl:choose>
												<xsl:when test="@TAXLOCATION">
												<xsl:for-each select="@TAXLOCATION">
												<TaxLocation>
												<xsl:attribute name="xml:lang">
													<xsl:value-of select="'EN'"/>
												</xsl:attribute>
												<xsl:value-of select="."/>
												</TaxLocation>
												</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												<TaxLocation>
												<xsl:attribute name="xml:lang">
													<xsl:value-of select="'EN'"/>
												</xsl:attribute>
												</TaxLocation>
												</xsl:otherwise>
												</xsl:choose>
											</TaxDetail>
											</xsl:if>
										</xsl:for-each>
									</Tax>
								</xsl:if>
								<NetAmount>
									<Money>
										<xsl:attribute name="currency">
											<xsl:value-of select="PROPOSAL/PYMNT_CURRENCY"/>
										</xsl:attribute>
										<xsl:value-of
											select="format-number(number(PROPOSAL/NET_AMT), '0.00')"
										/>
									</Money>
								</NetAmount>

								<!--Call Template to fill Comments-->
								<xsl:if
									test="/n0:PaymentProposalRequest/AribaComment/Item != ''"> 
								<Comments>
									<xsl:call-template name="CommentsFillProxyOut">
										<xsl:with-param name="p_aribaComment"
											select="/n0:PaymentProposalRequest/AribaComment"/>
										<xsl:with-param name="p_doctype"
											select="$anTargetDocumentType"/>
										<xsl:with-param name="p_pd" select="$v_pd"/>
									</xsl:call-template>
																		
								</Comments>
								</xsl:if>
								<!-- Start of IG-24086 updating partial paymen check validation -->
								<!-- <xsl:if test="string-length(normalize-space(PROPOSAL/PARTIAL)) > 0">-->
								<xsl:if test="string-length(normalize-space(PROPOSAL/PARTIAL)) = 0">
									<!-- End of IG-24086 updating partial paymen check validation -->
									<Extrinsic>
										<xsl:attribute name="name">
											<xsl:value-of select="'immediatepay'"/>
										</xsl:attribute>
									</Extrinsic>
								</xsl:if>
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="'Ariba.relaxedOperationCheck'"/>
									</xsl:attribute>
								</Extrinsic>
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="'organizationUnit'"/>
									</xsl:attribute>
									<xsl:value-of select="substring(PROPOSAL/PROPOSALID, 18, 4)"/>
								</Extrinsic>
								<xsl:if test="string-length(normalize-space(PROPOSAL/REF_INV_NUM)) > 0">
									<Extrinsic>
										<xsl:attribute name="name">
											<xsl:value-of select="'originalInvoiceNo'"/>
										</xsl:attribute>
										<xsl:value-of select="normalize-space(PROPOSAL/REF_INV_NUM)"/>
									</Extrinsic>
								</xsl:if>
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="'buyerInvoiceID'"/>
									</xsl:attribute>
									<xsl:value-of select="substring(PROPOSAL/PROPOSALID, 0, 11)"/>
								</Extrinsic>
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="'fiscalYear'"/>
									</xsl:attribute>
									<xsl:value-of select="substring(PROPOSAL/PROPOSALID, 11, 4)"/>
								</Extrinsic>
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="'earlyPaymentDiscount'"/>
									</xsl:attribute>
									<Money> 
										<xsl:attribute name="currency" select="PROPOSAL/DISC_CURRENCY"/>
										<xsl:value-of select="PROPOSAL/DISC_AMT"/> 
									</Money>
								</Extrinsic>
							</PaymentProposalRequest>
						</xsl:for-each>
					</Request>
				</cXML>
			</Payload>			
		</Combined>
	</xsl:template>

</xsl:stylesheet>
