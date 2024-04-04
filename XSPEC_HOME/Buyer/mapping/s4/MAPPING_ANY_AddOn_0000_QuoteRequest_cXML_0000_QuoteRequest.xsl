<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 	exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--		<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anERPName"/>
	<xsl:param name="anERPSystemID"/>
	<xsl:param name="anERPTimeZone"/>
	<xsl:param name="anIsMultiERP"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anSourceDocumentType"/>
	<xsl:param name="anTargetDocumentType"/>
	<xsl:param name="attachSeparator" select="'\|'"/>
	<xsl:param name="cXMLAttachments"/>
	<xsl:variable name="v_pd">
		<!--		<xsl:value-of select="'ParameterCrossreference.xml'"/>-->
		<xsl:call-template name="PrepareCrossref">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
			<xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_defaultLang">
		<xsl:call-template name="FillDefaultLang">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_getRegionDesc">
		<xsl:call-template name="GetRegionDesc">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_getDummyVendor">
		<xsl:call-template name="StrategicSourcingDummyVendor">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_ExternalServiceLineNote">
		<xsl:call-template name="ReadQuote">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
			<xsl:with-param name="p_attribute" select="'ExternalServiceLineNote'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="v_InternalServiceLineNote">
		<xsl:call-template name="ReadQuote">
			<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
			<xsl:with-param name="p_pd" select="$v_pd"/>
			<xsl:with-param name="p_attribute" select="'InternalServiceLineNote'"/>
		</xsl:call-template>
	</xsl:variable>
<!--	Begin of IG-37151-->
	<xsl:variable name="v_srcsystemid">
		<xsl:variable name="crossrefparamLookup" select="document($v_pd)"/>
		<xsl:value-of
			select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anTargetDocumentType]/SRCSYSTEMID)"
		/>
	</xsl:variable>
<!--	End of IG-37151-->
	<xsl:template match="ARBCIG_REQOTE/IDOC">
		<xsl:variable name="v_vendor" select="E1EDKA1[PARVW = 'LF']"/>
		<xsl:variable name="v_ship" select="E1EDKA1[PARVW = 'WE']"/>
		<xsl:variable name="v_bill" select="E1EDKA1[PARVW = 'AG']"/>
		<xsl:variable name="v_bill" select="E1EDKA1[PARVW = 'AG']"/>
		<xsl:variable name="v_uzeit_sc" select="E1EDK03[IDDAT = 012]/UZEIT"/>
		<xsl:variable name="v_k03" select="E1EDK03[IDDAT = 012]"/>
		<xsl:variable name="v_k03a" select="E1EDK03[IDDAT = 019]"/>
		<xsl:variable name="v_k03b" select="E1EDK03[IDDAT = 004]"/>
		<xsl:variable name="v_k03c" select="E1EDK03[IDDAT = 020]"/>
		<xsl:variable name="v_empty" select="''"/>
		<xsl:variable name="v_id" select="'ID'"/>
		<xsl:variable name="v_attach" select="E1EDK01/E1ARBCIG_ATTACH_HDR_DET"/>
		<xsl:variable name="v_language" select="E1EDK01/E1ARBCIG_HEADER/COMPANY_LANG"/>
		<xsl:variable name="v_currency" select="E1EDK01/E1ARBCIG_HEADER/CURRENCY"/>
		<xsl:variable name="v_rfq_header" select="E1EDK01/E1ARBCIG_HEADER"/>
		<xsl:variable name="v_rfq_item" select="E1EDP01/E1ARBCIG_RFQITEM"/>
		<xsl:variable name="v_rfq_doctype" select="E1EDP01/E1ARBCIG_RFQITEM/REQUISITION_DOCTYPE"/>
		<xsl:variable name="v_rfq_child_lno" select="E1EDP01/E1EDC01/POSEX"/>
		<xsl:variable name="v_srvpack" select="E1EDP01/E1EDC01/E1EDCT1[TDID = 'PACK']"/>
		<xsl:variable name="v_srvtype" select="E1EDP01/E1EDC01/E1EDCT1[TDID = 'TYPE']"/>
		<xsl:variable name="v_zero_service_ln" select="'0000000000'"/>
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
						<xsl:value-of	select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"/>
					</xsl:attribute>
					<Header>
						<From>
							<xsl:call-template name="MultiERPTemplateOut">
								<xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
								<xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
							</xsl:call-template>
							<!--	Begin of IG-37151-->							
							<xsl:if	test="upper-case($anIsMultiERP) != 'TRUE' and string-length(normalize-space($v_srcsystemid)) > 0">
								<Credential>
									<xsl:attribute name="domain">SystemID</xsl:attribute>
									<Identity>
										<xsl:value-of select="$anERPSystemID"/>
									</Identity>
								</Credential>
							</xsl:if>
							<!--	End of IG-37151-->
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
									<xsl:value-of select="'NetworkID'"/>
								</xsl:attribute>
								<Identity>
									<xsl:value-of select="$anSupplierANID"/>
								</Identity>
							</Credential>
						</To>
						<Sender>
							<Credential>
								<xsl:attribute name="domain">
									<xsl:value-of select="'NetworkID'"/>
								</xsl:attribute>
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
						<QuoteRequest>
							<QuoteRequestHeader>
								<!-- requestID -->
								<xsl:attribute name="requestID">
									<xsl:value-of select="E1EDK01/BELNR"/>
								</xsl:attribute>
								<!-- requestDate -->
								<xsl:attribute name="requestDate">
									<xsl:variable name="v_uzeit_orddate">
										<xsl:choose>
											<xsl:when test="string-length($v_k03/UZEIT) > 0">
												<xsl:value-of select="$v_k03/UZEIT"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'000000'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="(string-length($v_k03/DATUM) > 0)">
											<xsl:call-template name="ANDateTime">
												<xsl:with-param name="p_date" select="$v_k03/DATUM"/>
												<xsl:with-param name="p_time"	select="$v_uzeit_orddate"/>
												<!-- <xsl:with-param name="p_timezone" select="$anERPTimeZone"/> -->
												<xsl:with-param name="p_timezone"	select="$v_rfq_header/USER_TIMEZONE"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:attribute>
								<!-- type -->
								<xsl:attribute name="type">
									<xsl:value-of select="$v_rfq_header/OPERATION"/>
								</xsl:attribute>
								<!-- openDate -->
								<xsl:attribute name="openDate">
									<xsl:variable name="v_uzeit_opendate">
										<xsl:choose>
											<xsl:when test="(string-length($v_k03a/UZEIT) > 0)">
												<xsl:value-of select="$v_k03a/UZEIT"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'000000'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="(string-length($v_k03a/DATUM) > 0)">
											<xsl:call-template name="ANDateTime">
												<xsl:with-param name="p_date" select="$v_k03a/DATUM"/>
												<xsl:with-param name="p_time"	select="$v_uzeit_opendate"/>
												<xsl:with-param name="p_timezone"	select="$v_rfq_header/USER_TIMEZONE"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="ANDateTime">
												<xsl:with-param name="p_date" select="$v_k03/DATUM"/>
												<xsl:with-param name="p_time"	select="$v_uzeit_opendate"/>
												<xsl:with-param name="p_timezone"	select="$v_rfq_header/USER_TIMEZONE"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<!-- closeDate -->
								<xsl:attribute name="closeDate">
									<xsl:variable name="v_uzeit_cldate">
										<xsl:choose>
											<xsl:when test="string-length($v_k03b/UZEIT) > 0">
												<xsl:value-of select="$v_k03b/UZEIT"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'000000'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="(string-length($v_k03b/DATUM) > 0)">
											<xsl:call-template name="ANDateTime">
												<xsl:with-param name="p_date" select="$v_k03b/DATUM"/>
												<xsl:with-param name="p_time"	select="$v_uzeit_cldate"/>
												<xsl:with-param name="p_timezone"	select="$v_rfq_header/USER_TIMEZONE"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:attribute>
								<!-- currency -->
								<xsl:attribute name="currency">
									<xsl:value-of select="$v_rfq_header/CURRENCY"/>
								</xsl:attribute>
								<!-- language -->
								<xsl:attribute name="xml:lang">
									<xsl:call-template name="FillLangOut">
										<xsl:with-param name="p_spras_iso"	select="$v_rfq_header/COMPANY_LANG_ISO"/>
										<xsl:with-param name="p_spras"	select="$v_rfq_header/COMPANY_LANG"/>
										<xsl:with-param name="p_lang" select="$v_defaultLang"/>
									</xsl:call-template>
								</xsl:attribute>
								<!-- quoteReceivingPreference -->
								<xsl:attribute name="quoteReceivingPreference">
									<xsl:value-of select="'winningOnly'"/>
								</xsl:attribute>
								<SupplierSelector>
									<!-- matchingType -->
									<xsl:attribute name="matchingType">
										<xsl:variable name="v_rfqtypeDesc">
											<xsl:call-template name="LookupTemplate">
												<xsl:with-param name="p_anERPSystemID"	select="$anERPSystemID"/>
												<xsl:with-param name="p_anSupplierANID"	select="$anSupplierANID"/>
												<xsl:with-param name="p_producttype"	select="'AribaNetwork'"/>
												<xsl:with-param name="p_doctype"	select="$anTargetDocumentType"/>
												<xsl:with-param name="p_lookupname"	select="'QuoteRequestMatchingType'"/>
												<xsl:with-param name="p_input"	select="E1EDK01/BSART"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$v_rfqtypeDesc = ''">
												<xsl:call-template name="LookupTemplate">
													<xsl:with-param name="p_anERPSystemID"	select="$anERPSystemID"/>
													<xsl:with-param name="p_anSupplierANID"	select="$anSupplierANID"/>
													<xsl:with-param name="p_producttype"	select="'AribaSourcing'"/>
													<xsl:with-param name="p_doctype"	select="$anTargetDocumentType"/>
													<xsl:with-param name="p_lookupname"	select="'QuoteRequestMatchingType'"/>
													<xsl:with-param name="p_input"	select="E1EDK01/BSART"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
										<xsl:value-of select="$v_rfqtypeDesc"/>
									</xsl:attribute>
									<xsl:if test="string-length($v_getDummyVendor) > 0">
										<SupplierInvitation>
											<OrganizationID>
												<Credential>
													<xsl:attribute name="domain">
														<xsl:value-of select="'PrivateID'"/>
													</xsl:attribute>
													<Identity>
														<xsl:value-of select="E1EDKA1[PARVW = 'LF']/PARTN"/>
													</Identity>
												</Credential>
											</OrganizationID>
											<Correspondent>
												<Contact>
													<xsl:attribute name="role">
														<xsl:value-of select="'correspondent'"/>
													</xsl:attribute>
													<Name>
														<xsl:attribute name="xml:lang">
															<xsl:choose>
																<xsl:when	test="string-length($v_rfq_header/VENDOR_LANG) > 0">
																	<xsl:value-of	select="$v_rfq_header/VENDOR_LANG_ISO"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$v_defaultLang"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of select="$v_rfq_header/NAME"/>
													</Name>
													<PostalAddress>
														<Street>
															<xsl:value-of select="$v_rfq_header/STREET"/>
														</Street>
														<City>
															<xsl:value-of select="$v_rfq_header/CITY"/>
														</City>
														<State>
															<xsl:choose>
																<xsl:when test="$v_getRegionDesc = 'YES'">
																	<xsl:value-of	select="$v_rfq_header/REGION_DESCRIPTION"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$v_rfq_header/STATE"/>
																</xsl:otherwise>
															</xsl:choose>
														</State>
														<PostalCode>
															<xsl:value-of select="$v_rfq_header/POSTAL"/>
														</PostalCode>
														<Country>
															<xsl:attribute name="isoCountryCode">
																<xsl:value-of select="$v_rfq_header/COUNTRY"/>
															</xsl:attribute>
															<xsl:value-of select="$v_rfq_header/COUNTRY"/>
														</Country>
													</PostalAddress>
													<Email>
														<xsl:attribute name="name">
															<xsl:choose>
																<xsl:when	test="string-length($v_rfq_header/EMAIL) > 0">
																	<xsl:value-of select="'routing'"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="' '"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of select="$v_rfq_header/EMAIL"/>
													</Email>
													<Fax>
														<xsl:attribute name="name">
															<xsl:choose>
																<xsl:when	test="string-length($v_rfq_header/FAX) > 0">
																	<xsl:value-of select="''"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="'routing'"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<TelephoneNumber>
															<CountryCode>
																<xsl:attribute name="isoCountryCode">
																	<xsl:value-of select="$v_rfq_header/COUNTRY"/>
																</xsl:attribute>
															</CountryCode>
															<AreaOrCityCode/>
															<Number>
																<xsl:value-of select="$v_rfq_header/FAX"/>
															</Number>
														</TelephoneNumber>
													</Fax>
												</Contact>
											</Correspondent>
										</SupplierInvitation>
									</xsl:if>
								</SupplierSelector>
								<xsl:if test="E1EDS01[SUMID = 002]">
									<Total>
										<xsl:if test="E1EDS01[SUMID = 002]">
											<Money>
												<xsl:attribute name="currency">
													<xsl:value-of select="$v_rfq_header/CURRENCY"/>
												</xsl:attribute>
												<xsl:value-of select="E1EDS01/SUMME"/>
											</Money>
										</xsl:if>
									</Total>
								</xsl:if>
								<xsl:if test="$v_ship">
									<ShipTo>
										<Address>
											<xsl:attribute name="isoCountryCode">
												<xsl:choose>
<!--													<xsl:when test="string-length(E1EDKA1/ISOAL) > 0">-->
													<xsl:when test="string-length($v_ship/ISOAL) > 0">
														<!--<xsl:value-of select="E1EDKA1/ISOAL"/>-->
														<xsl:value-of select="$v_ship/ISOAL"/>
													</xsl:when>
													<xsl:otherwise>
<!--														<xsl:value-of select="E1EDKA1/LAND1"/>-->
														<xsl:value-of select="$v_ship/LAND1"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="addressID">
												<!--<xsl:value-of select="E1EDKA1/LIFNR"/>-->
												<xsl:value-of select="$v_ship/LIFNR"/>
											</xsl:attribute>
											<xsl:attribute name="addressIDDomain">
												<xsl:value-of select="'buyerLocationID'"/>
											</xsl:attribute>
											<Name>
												<xsl:attribute name="xml:lang">
													<!--<xsl:if test="E1EDKA1[PARVW = WE]"><xsl:choose><xsl:when test="string-length(E1EDKA1/SPRAS) > 0"><xsl:value-of select="E1EDKA1/SPRAS"/></xsl:when><xsl:when test="(string-length(E1EDKA1/SPRAS_ISO) > 0 )"><xsl:value-of select="E1EDKA1/SPRAS_ISO"/></xsl:when><xsl:otherwise><xsl:value-of select="$v_defaultLang"/></xsl:otherwise></xsl:choose> </xsl:if>-->
													<xsl:call-template name="FillLangOut">
														<xsl:with-param name="p_spras_iso"	select="$v_ship/SPRAS_ISO"/>
														<xsl:with-param name="p_spras"	select="$v_ship/SPRAS"/>
														<xsl:with-param name="p_lang"	select="$v_defaultLang"/>
													</xsl:call-template>
												</xsl:attribute>
<!--												<xsl:value-of select="E1EDKA1/NAME1"/>-->
												<xsl:value-of select="$v_ship/NAME1"/>
											</Name>
											<PostalAddress>
												<Street>
													<!--<xsl:value-of select="E1EDKA1/STRAS"/>-->
													<xsl:value-of select="$v_ship/STRAS"/>
												</Street>
												<City>
													<!--<xsl:value-of select="E1EDKA1/ORT01"/>-->
													<xsl:value-of select="$v_ship/ORT01"/>
												</City>
												<State>
													<xsl:choose>
														<xsl:when test="$v_getRegionDesc = 'YES'">
															<xsl:value-of	select="$v_rfq_header/REGION_DESCRIPTION"/>
														</xsl:when>
														<xsl:otherwise>
															<!--<xsl:value-of select="E1EDKA1/REGIO"/>-->
															<xsl:value-of select="$v_ship/REGIO"/>
														</xsl:otherwise>
													</xsl:choose>
												</State>
												<PostalCode>													
													<!--<xsl:value-of select="E1EDKA1/PSTLZ"/>-->
													<xsl:value-of select="$v_ship/PSTLZ"/>
												</PostalCode>
												<Country>
													<xsl:attribute name="isoCountryCode">
														<xsl:choose>
															<!--<xsl:when test="string-length(E1EDKA1/LAND1) > 0">
																<xsl:value-of select="E1EDKA1/LAND1"/>-->
															<xsl:when test="string-length($v_ship/LAND1) > 0">
																<xsl:value-of select="$v_ship/LAND1"/>
															</xsl:when>
								<!--							<xsl:when test="string-length(E1EDKA1/ISOAL) > 0">
																<xsl:value-of select="E1EDKA1/ISOAL"/>-->
															<xsl:when test="string-length($v_ship/ISOAL) > 0">
																<xsl:value-of select="$v_ship/ISOAL"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="''"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
<!--													<xsl:value-of select="E1EDKA1/LAND1"/>-->
													<xsl:value-of select="$v_ship/LAND1"/>
												</Country>
											</PostalAddress>
											<xsl:if test="$v_ship">
												<Phone>
													<TelephoneNumber>
														<CountryCode>
															<xsl:attribute name="isoCountryCode">
																<xsl:choose>
<!--																	<xsl:when test="string-length(E1EDKA1/LAND1) > 0">
																		<xsl:value-of select="E1EDKA1/LAND1"/>-->
																	<xsl:when test="string-length($v_ship/LAND1) > 0">
																		<xsl:value-of select="$v_ship/LAND1"/>		
																	</xsl:when>
<!--																	<xsl:when test="string-length(E1EDKA1/ISOAL) > 0">
																		<xsl:value-of select="E1EDKA1/ISOAL"/>-->
																	<xsl:when test="string-length($v_ship/ISOAL) > 0">
																		<xsl:value-of select="$v_ship/ISOAL"/>																		
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="''"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
														</CountryCode>
														<AreaOrCityCode/>
														<Number>
															<xsl:value-of select="$v_ship/TELF1"/>
														</Number>
													</TelephoneNumber>
												</Phone>
											</xsl:if>
											<xsl:if test="$v_ship">
												<Fax>
													<TelephoneNumber>
														<CountryCode>
															<xsl:attribute name="isoCountryCode">
																<xsl:choose>
<!--																	<xsl:when test="string-length(E1EDKA1/LAND1) > 0">
																		<xsl:value-of select="E1EDKA1/LAND1"/>-->
																	<xsl:when test="string-length($v_ship/LAND1) > 0">
																		<xsl:value-of select="$v_ship/LAND1"/>																		
																	</xsl:when>
<!--																	<xsl:when test="string-length(E1EDKA1/ISOAL) > 0">
																		<xsl:value-of select="E1EDKA1/ISOAL"/>-->
																	<xsl:when test="string-length($v_ship/ISOAL) > 0">
																		<xsl:value-of select="$v_ship/ISOAL"/>																	
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="''"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
														</CountryCode>
														<AreaOrCityCode/>
														<Number>
															<xsl:value-of select="$v_ship/TELFX"/>
														</Number>
													</TelephoneNumber>
												</Fax>
											</xsl:if>
										</Address>
									</ShipTo>
								</xsl:if>
								<xsl:if test="string-length($v_rfq_header/CREATOR_NAME) > 0">
									<Contact>
										<xsl:attribute name="role">
											<xsl:value-of select="'buyer'"/>
										</xsl:attribute>
										<xsl:attribute name="addressID">
											<xsl:value-of select="$v_rfq_header/CREATOR_ADDRESS"/>
										</xsl:attribute>
										<Name>
											<xsl:attribute name="xml:lang">
												<xsl:choose>
													<xsl:when	test="string-length($v_rfq_header/CREATOR_LANG) > 0">
														<xsl:value-of	select="$v_rfq_header/CREATOR_LANG_ISO"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$v_defaultLang"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:value-of select="$v_rfq_header/CREATOR_NAME"/>
										</Name>
										<PostalAddress>
											<Street>
												<xsl:value-of select="$v_rfq_header/CREATOR_STREET"/>
											</Street>
											<City>
												<xsl:value-of select="$v_rfq_header/CREATOR_CITY"/>
											</City>
											<State>
												<xsl:value-of select="$v_rfq_header/CREATOR_STATE"/>
											</State>
											<PostalCode>
												<xsl:value-of select="$v_rfq_header/CREATOR_POSTAL"/>
											</PostalCode>
											<Country>
												<xsl:attribute name="isoCountryCode">
													<xsl:value-of	select="$v_rfq_header/CREATOR_COUNTRY"/>
												</xsl:attribute>
												<xsl:value-of select="$v_rfq_header/CREATOR_COUNTRY"/>
											</Country>
										</PostalAddress>
										<xsl:if	test="string-length($v_rfq_header/CREATOR_EMAIL) > 0">
											<Email>
												<xsl:attribute name="preferredLang">
													<xsl:choose>
														<xsl:when	test="string-length($v_rfq_header/CREATOR_LANG) > 0">
															<xsl:value-of	select="$v_rfq_header/CREATOR_LANG_ISO"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$v_defaultLang"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:value-of select="$v_rfq_header/CREATOR_EMAIL"/>
											</Email>
										</xsl:if>
										<xsl:if test="string-length($v_rfq_header/CREATOR_FAX) > 0">
											<Fax>
												<TelephoneNumber>
													<CountryCode>
														<xsl:attribute name="isoCountryCode">
															<xsl:value-of	select="$v_rfq_header/CREATOR_COUNTRY"/>
														</xsl:attribute>
													</CountryCode>
													<AreaOrCityCode/>
													<Number>
														<xsl:value-of select="$v_rfq_header/CREATOR_FAX"/>
													</Number>
												</TelephoneNumber>
											</Fax>
										</xsl:if>
									</Contact>
								</xsl:if>
								<!-- **************** Comments & Attachments ********** -->
								<xsl:variable name="v_comm_hdr">
									<xsl:for-each select="E1EDKT1">
										<xsl:if	test="normalize-space(TDOBJECT) = '' or TDOBJECT != 'ZTERM'">
											<xsl:value-of select="'1'"/>
										</xsl:if>
									</xsl:for-each>
								</xsl:variable>
								<xsl:variable name="v_att">
									<xsl:for-each select="$v_attach">
										<xsl:if test="normalize-space(LINENUMBER) = ''">
											<xsl:value-of select="'1'"/>
										</xsl:if>
									</xsl:for-each>
								</xsl:variable>
								<xsl:if	test="string-length(normalize-space($v_att)) > 0 or string-length(normalize-space($v_comm_hdr)) > 0">
									<Comments>
										<xsl:call-template name="CommentsFillIdocOutPO">
											<xsl:with-param name="p_aribaComment" select="E1EDKT1"/>
											<xsl:with-param name="p_doctype"	select="$anTargetDocumentType"/>
											<xsl:with-param name="p_pd" select="$v_pd"/>
										</xsl:call-template>
										<xsl:call-template name="addContenIdIDOC">
											<xsl:with-param name="eachAtt" select="$v_attach"/>
										</xsl:call-template>
									</Comments>
								</xsl:if>
								<QuoteHeaderInfo>
									<xsl:choose>
										<xsl:when test="(E1EDK14[QUALF = 011])">
											<LegalEntity>
												<IdReference>
													<xsl:attribute name="identifier">
														<xsl:value-of select="E1EDK14[QUALF = 011]/ORGID"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:value-of select="'CompanyCode'"/>
													</xsl:attribute>
													<Description>
														<xsl:attribute name="xml:lang">
															<xsl:choose>
																<xsl:when	test="string-length($v_rfq_header/COMPANY_LANG) > 0">
																	<xsl:value-of	select="$v_rfq_header/COMPANY_LANG_ISO"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$v_defaultLang"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of	select="$v_rfq_header/COMPANY_CODE_NAME"/>
													</Description>
												</IdReference>
											</LegalEntity>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="(E1EDK14[QUALF = 014])">
											<!-- and (string-length(E1EDK14/ORGID) > 0) "-->
											<OrganizationalUnit>
												<IdReference>
													<xsl:attribute name="identifier">
														<xsl:value-of select="E1EDK14[QUALF = 014]/ORGID"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:value-of select="'PurchasingOrganization'"/>
													</xsl:attribute>
													<Description>
														<xsl:attribute name="xml:lang">
															<xsl:choose>
																<xsl:when	test="string-length($v_rfq_header/COMPANY_LANG) > 0">
																	<xsl:value-of	select="$v_rfq_header/COMPANY_LANG_ISO"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$v_defaultLang"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of	select="$v_rfq_header/PURCHASING_ORG_DESCRIPTION"/>
													</Description>
												</IdReference>
											</OrganizationalUnit>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="(E1EDK14[QUALF = 009])">
											<!-- and (string-length(E1EDK14/ORGID) > 0) "-->
											<OrganizationalUnit>
												<IdReference>
													<xsl:attribute name="identifier">
														<xsl:value-of select="E1EDK14[QUALF = 009]/ORGID"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:value-of select="'PurchasingGroup'"/>
													</xsl:attribute>
													<Description>
														<xsl:attribute name="xml:lang">
															<xsl:choose>
																<xsl:when	test="string-length($v_rfq_header/COMPANY_LANG) > 0">
																	<xsl:value-of	select="$v_rfq_header/COMPANY_LANG_ISO"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$v_defaultLang"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of	select="$v_rfq_header/PURCHASING_GROUP_DESCRIPTION"/>
													</Description>
												</IdReference>
											</OrganizationalUnit>
										</xsl:when>
									</xsl:choose>
									<xsl:if test="string-length(E1EDK01/ZTERM) > 0">
										<PaymentTerms>
											<xsl:attribute name="paymentTermCode">
												<xsl:value-of select="E1EDK01/ZTERM"/>
											</xsl:attribute>
											<Description>
												<xsl:attribute name="xml:lang">
													<xsl:choose>
														<xsl:when	test="string-length($v_rfq_header/COMPANY_LANG) > 0">
															<xsl:value-of	select="$v_rfq_header/COMPANY_LANG_ISO"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$v_defaultLang"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:value-of	select="$v_rfq_header/PAYMENT_TERMS_DESCRIPTION"/>
											</Description>
										</PaymentTerms>
									</xsl:if>
								</QuoteHeaderInfo>
								<Extrinsic>
									<xsl:attribute name="name">
										<xsl:value-of select="'Terms'"/>
									</xsl:attribute>
									<xsl:if test="E1EDKT1/E1EDKT2/E1ARBCIG_HDR_INTERNALNOTE">
										<Extrinsic>
											<xsl:attribute name="name">
												<xsl:value-of select="'InternalNote'"/>
											</xsl:attribute>
											<xsl:for-each	select="E1EDKT1/E1EDKT2/E1ARBCIG_HDR_INTERNALNOTE">
												<xsl:value-of	select="COMMENTS"/>
												<!-- Start of IG-20781 Add new line at end of each comment -->
												<xsl:if test="(TDFORMAT = '*') or (TDFORMAT = '/')">
													
														<xsl:value-of select="'&#xa;'"/>
													
												</xsl:if>
												<!-- End of IG-20781 Add new line at end of each comment -->													
											</xsl:for-each>
										</Extrinsic>
									</xsl:if>
									<Extrinsic>
										<xsl:attribute name="name">
											<xsl:value-of select="'PRDocumentType'"/>
										</xsl:attribute>
										<xsl:for-each select="E1EDP01/E1ARBCIG_RFQITEM">
											<xsl:if test="position() = 1">
												<xsl:value-of select="REQUISITION_DOCTYPE"/>
											</xsl:if>
										</xsl:for-each>
									</Extrinsic>
									<xsl:if test="E1EDKT1/E1EDKT2/E1ARBCIG_HDR_EXTERNALNOTE">
										<Extrinsic>
											<xsl:attribute name="name">
												<xsl:value-of select="'ExternalNote'"/>
											</xsl:attribute>
											<xsl:for-each	select="E1EDKT1/E1EDKT2/E1ARBCIG_HDR_EXTERNALNOTE">
												<xsl:value-of	select="COMMENTS"/>
												<!-- Start of IG-20781 Add new line at end of each comment -->
												<xsl:if test="(TDFORMAT = '*') or (TDFORMAT = '/')">
													
														<xsl:value-of select="'&#xa;'"/>
													
												</xsl:if>
												<!-- End of IG-20781 Add new line at end of each comment -->												
											</xsl:for-each>
										</Extrinsic>
									</xsl:if>
									<Extrinsic>
										<xsl:attribute name="name">
											<xsl:value-of select="'TargetValue'"/>
										</xsl:attribute>
										<xsl:value-of select="E1EDS01/SUMME"/>
									</Extrinsic>
									<xsl:if test="string-length($v_k03c/DATUM) > 0">
										<Extrinsic>
											<xsl:attribute name="name">
												<xsl:value-of select="'ValidityEndDate'"/>
											</xsl:attribute>
											<xsl:variable name="v_uzeit_vetdate">
												<xsl:choose>
													<xsl:when test="string-length($v_k03c/UZEIT) > 0">
														<xsl:value-of select="$v_k03c/UZEIT"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="'000000'"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="(string-length($v_k03c/DATUM) > 0)">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date"	select="$v_k03c/DATUM"/>
														<xsl:with-param name="p_time"	select="$v_uzeit_vetdate"/>
														<!-- <xsl:with-param name="p_timezone" select="$anERPTimeZone"/> -->
														<xsl:with-param name="p_timezone"	select="$v_rfq_header/USER_TIMEZONE"/>
													</xsl:call-template>
												</xsl:when>
											</xsl:choose>
										</Extrinsic>
									</xsl:if>
									<xsl:if test="string-length($v_k03a/DATUM) > 0">
										<Extrinsic>
											<xsl:attribute name="name">
												<xsl:value-of select="'ValidityStartDate'"/>
											</xsl:attribute>
											<xsl:variable name="v_uzeit_vstdate">
												<xsl:choose>
													<xsl:when test="string-length($v_k03a/UZEIT) > 0">
														<xsl:value-of select="$v_k03a/UZEIT"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="'000000'"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="(string-length($v_k03a/DATUM) > 0)">
													<xsl:call-template name="ANDateTime">
														<xsl:with-param name="p_date"	select="$v_k03a/DATUM"/>
														<xsl:with-param name="p_time"	select="$v_uzeit_vstdate"/>
														<!-- <xsl:with-param name="p_timezone" select="$anERPTimeZone"/> -->
														<xsl:with-param name="p_timezone"	select="$v_rfq_header/USER_TIMEZONE"/>
													</xsl:call-template>
												</xsl:when>
											</xsl:choose>
										</Extrinsic>
									</xsl:if>
								</Extrinsic>
							</QuoteRequestHeader>
							<xsl:for-each select="E1EDP01">
								<QuoteItemOut>
									<xsl:attribute name="quantity">
										<xsl:value-of select="format-number(MENGE, '0.000')"/>
									</xsl:attribute>
									<xsl:attribute name="lineNumber">
										<xsl:value-of select="POSEX"/>
									</xsl:attribute>
									<xsl:attribute name="requestedDeliveryDate">
										<xsl:variable name="v_req_delivdate">
											<xsl:choose>
												<xsl:when test="(string-length(E1EDP20/EZEIT) > 0)">
													<xsl:value-of select="E1EDP20/EZEIT"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'000000'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:if test="(string-length(E1EDP20/EDATU) > 0)">
											<xsl:call-template name="ANDateTime">
												<xsl:with-param name="p_date" select="E1EDP20/EDATU"/>
												<xsl:with-param name="p_time"	select="$v_req_delivdate"/>
												<!-- <xsl:with-param name="p_timezone" select="$anERPTimeZone"/> -->
												<xsl:with-param name="p_timezone"	select="$v_rfq_header/USER_TIMEZONE"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="itemClassification">
										<xsl:choose>
											<xsl:when test="PSTYP = '0'">
												<xsl:value-of select="'material'"/>
											</xsl:when>
											<xsl:when test="PSTYP = '9'">
												<xsl:value-of select="'service'"/>
											</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<!--									<xsl:if test="PSTYP = 9">-->
									<xsl:attribute name="itemType">
										<xsl:choose>
											<xsl:when test="PSTYP = '0'">
												<xsl:value-of select="'item'"/>
											</xsl:when>
											<xsl:when test="PSTYP = '9'">
												<xsl:value-of select="'composite'"/>
											</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<!--</xsl:if>-->
									<xsl:if	test="(string-length(E1EDP19[QUALF = 001]/IDTNR) >= 0) or (string-length(E1EDP19[QUALF = 002]/IDTNR) >= 0)"><ItemID>
												<SupplierPartID>
													<xsl:value-of select="E1EDP19[QUALF = 002]/IDTNR"/>
												</SupplierPartID>
												<BuyerPartID>
													<xsl:value-of select="E1EDP19[QUALF = 001]/IDTNR"/>
												</BuyerPartID>
											</ItemID>
										</xsl:if>
										<ItemDetail>
											<UnitPrice>
												<Money>
													<xsl:attribute name="currency">
														<xsl:value-of select="$v_rfq_header/CURRENCY"/>
													</xsl:attribute>
												</Money>
											</UnitPrice>
											<xsl:if test="E1EDP19[QUALF = 001]">
												<Description>
													<xsl:attribute name="xml:lang">
														<xsl:call-template name="FillLangOut">
															<xsl:with-param name="p_spras_iso"	select="$v_rfq_header/COMPANY_LANG_ISO"/>
															<xsl:with-param name="p_spras"	select="$v_rfq_header/COMPANY_LANG"/>
															<xsl:with-param name="p_lang"	select="$v_defaultLang"/>
														</xsl:call-template>
													</xsl:attribute>
													<xsl:value-of select="E1EDP19[QUALF = 001]/KTEXT"/>
												</Description>
											</xsl:if>
											<xsl:if	test="not(E1ARBCIG_RFQITEM/SUMNOLIM) and (E1ARBCIG_RFQITEM/SUMLIMIT)">
												<OverallLimit>
													<Money>
														<xsl:attribute name="currency">
															<xsl:value-of select="$v_rfq_header/CURRENCY"/>
														</xsl:attribute>
														<xsl:value-of select="E1ARBCIG_RFQITEM/SUMLIMIT"/>
													</Money>
												</OverallLimit>
											</xsl:if>
											<xsl:if test="E1ARBCIG_RFQITEM/COMMITMENT">
												<ExpectedLimit>
													<Money>
														<xsl:attribute name="currency">
															<xsl:value-of select="$v_rfq_header/CURRENCY"/>
														</xsl:attribute>
														<xsl:value-of select="E1ARBCIG_RFQITEM/COMMITMENT"/>
													</Money>
												</ExpectedLimit>
											</xsl:if>
											<UnitOfMeasure>
												<xsl:value-of select="MENEE"/>
											</UnitOfMeasure>
											<Classification>
												<xsl:attribute name="domain">
													<xsl:value-of select="'MaterialGroup'"/>
												</xsl:attribute>
												<xsl:attribute name="code">
													<xsl:value-of select="MATKL"/>
												</xsl:attribute>
												<xsl:value-of	select="E1ARBCIG_RFQITEM/MATERIAL_GROUP_DESCRIPTION"/>
											</Classification>
											<Classification>
												<xsl:attribute name="domain">
													<xsl:value-of select="'NotAvailable'"/>
												</xsl:attribute>
												<xsl:attribute name="code">
													<xsl:value-of select="MATKL"/>
												</xsl:attribute>
												<xsl:value-of	select="E1ARBCIG_RFQITEM/MATERIAL_GROUP_DESCRIPTION"/>
											</Classification>
											<Extrinsic>
												<xsl:attribute name="name">
													<xsl:value-of select="'Terms'"/>
												</xsl:attribute>
											<Extrinsic>
												<xsl:attribute name="name">
													<xsl:value-of select="'TrackingNumber'"/>
												</xsl:attribute>
												<xsl:value-of select="E1ARBCIG_RFQITEM/TRACKING_NUMBER"/>
											</Extrinsic>
											<xsl:if test="E1EDPT1/E1EDPT2/E1ARBCIG_ITM_EXTERNALNOTE">
												<Extrinsic>
													<xsl:attribute name="name">
														<xsl:value-of select="'ExternalNote'"/>
													</xsl:attribute>
													<xsl:for-each	select="E1EDPT1/E1EDPT2/E1ARBCIG_ITM_EXTERNALNOTE">
														<xsl:value-of	select="COMMENTS"/>
														<!-- Start of IG-20781 Add new line at end of each comment -->
														<xsl:if test="(TDFORMAT = '*') or (TDFORMAT = '/')">
															
																<xsl:value-of select="'&#xa;'"/>
															
														</xsl:if>
														<!-- End of IG-20781 Add new line at end of each comment -->															
													</xsl:for-each>
												</Extrinsic>
											</xsl:if>
											<xsl:if	test="E1EDPT1/E1EDPT2/E1ARBCIG_ITM_INTERNALNOTE/COMMENTS">
												<Extrinsic>
													<xsl:attribute name="name">
														<xsl:value-of select="'InternalNote'"/>
													</xsl:attribute>
													<xsl:for-each	select="E1EDPT1/E1EDPT2/E1ARBCIG_ITM_INTERNALNOTE">
														<xsl:value-of	select="COMMENTS"/>
														<!-- Start of IG-20781 Add new line at end of each comment -->
														<xsl:if test="(TDFORMAT = '*') or (TDFORMAT = '/')">
															
																<xsl:value-of select="'&#xa;'"/>
															
														</xsl:if>
														<!-- End of IG-20781 Add new line at end of each comment -->															
													</xsl:for-each>
												</Extrinsic>
											</xsl:if>
											</Extrinsic>
										</ItemDetail>
										<xsl:if test="E1EDPA1/PARVW = 'WE'">
											<ShipTo>
												<Address>
													<xsl:attribute name="isoCountryCode">
														<xsl:choose>
															<xsl:when test="string-length(E1EDPA1/ISOAL) > 0">
																<xsl:value-of select="E1EDPA1/ISOAL"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="E1EDPA1/LAND1"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:attribute name="addressID">
														<xsl:value-of select="E1EDPA1/LIFNR"/>
													</xsl:attribute>
													<xsl:attribute name="addressIDDomain">
														<xsl:value-of select="'buyerLocationID'"/>
													</xsl:attribute>
													<Name>
														<xsl:call-template name="FillLangOut">
															<xsl:with-param name="p_spras_iso"	select="E1EDPA1/SPRAS_ISO"/>
															<xsl:with-param name="p_spras"	select="E1EDPA1/SPRAS"/>
															<xsl:with-param name="p_lang"	select="$v_defaultLang"/>
														</xsl:call-template>
														<xsl:value-of select="E1EDPA1/NAME1"/>
													</Name>
													<PostalAddress>
														<Street>
															<xsl:value-of select="E1EDPA1/STRAS"/>
														</Street>
														<City>
															<xsl:value-of select="E1EDPA1/ORT01"/>
														</City>
														<State>
															<xsl:choose>
																<xsl:when test="$v_getRegionDesc = 'YES'">
																	<xsl:value-of	select="E1ARBCIG_RFQITEM/REGION_DESCRIPTION"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="E1EDPA1/REGIO"/>
																</xsl:otherwise>
															</xsl:choose>
														</State>
														<PostalCode>
															<xsl:value-of select="E1EDPA1/PSTLZ"/>
														</PostalCode>
														<Country>
															<xsl:attribute name="isoCountryCode">
																<xsl:choose>
																	<xsl:when test="string-length(E1EDPA1/ISOAL) > 0">
																		<xsl:value-of select="E1EDPA1/ISOAL"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="E1EDPA1/LAND1"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
														</Country>
													</PostalAddress>
													<xsl:if test="string-length(E1EDPA1/TELF1) > 0">
														<Phone>
															<TelephoneNumber>
																<CountryCode>
																	<xsl:attribute name="isoCountryCode">
																		<xsl:choose>
																			<xsl:when test="string-length(E1EDPA1/LAND1) > 0">
																				<xsl:value-of select="E1EDPA1/LAND1"/>
																			</xsl:when>
																			<xsl:when test="string-length(E1EDPA1/ISOAL) > 0">
																				<xsl:value-of select="E1EDPA1/ISOAL"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="''"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>
																</CountryCode>
																<AreaOrCityCode/>
																<Number>
																	<xsl:value-of select="E1EDPA1/TELF1"/>
																</Number>
															</TelephoneNumber>
														</Phone>
													</xsl:if>
													<xsl:if test="string-length(E1EDPA1/TELF1) > 0">
														<Fax>
															<TelephoneNumber>
																<CountryCode>
																	<xsl:attribute name="isoCountryCode">
																		<xsl:choose>
																			<xsl:when test="string-length(E1EDPA1/LAND1) > 0">
																				<xsl:value-of select="E1EDPA1/LAND1"/>
																			</xsl:when>
																			<xsl:when test="string-length(E1EDPA1/ISOAL) > 0">
																				<xsl:value-of select="E1EDPA1/ISOAL"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="''"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>
																</CountryCode>
																<AreaOrCityCode/>
																<Number>
																	<xsl:value-of select="E1EDPA1/TELFX"/>
																</Number>
															</TelephoneNumber>
														</Fax>
													</xsl:if>
												</Address>
											</ShipTo>
										</xsl:if>
										<xsl:if test="E1EDP02[QUALF = 016]">
											<ReferenceDocumentInfo>
												<xsl:attribute name="lineNumber">
													<xsl:value-of select="E1EDP02[QUALF = 016]/ZEILE"/>
												</xsl:attribute>
												<DocumentInfo>
													<xsl:attribute name="documentID">
														<xsl:value-of select="E1EDP02[QUALF = 016]/BELNR"/>
													</xsl:attribute>
													<xsl:attribute name="documentType">
														<xsl:value-of select="'requisition'"/>
													</xsl:attribute>
												</DocumentInfo>
											</ReferenceDocumentInfo>
										</xsl:if>
										<xsl:variable name="v_att_line">
											<xsl:for-each select="$v_attach[LINENUMBER != '']">
												<xsl:value-of select="'1'"/>
											</xsl:for-each>
										</xsl:variable>
									<xsl:variable name="v_posex" select="number(POSEX)"/>
									<xsl:if test="($v_attach[number(LINENUMBER) = $v_posex]) or (E1EDPT1)">
										    <Comments>
												<xsl:call-template name="CommentsFillIdocOutPO">
													<xsl:with-param name="p_aribaComment"	select="E1EDPT1"/>
													<xsl:with-param name="p_itemNumber" select="POSEX"/>
													<xsl:with-param name="p_doctype"	select="$anTargetDocumentType"/>
													<xsl:with-param name="p_pd" select="$v_pd"/>
												</xsl:call-template>
												<xsl:call-template name="addContenIdIDOC">
													<xsl:with-param name="eachAtt" select="$v_attach"/>
													<xsl:with-param name="lineNumber" select="POSEX"/>
												</xsl:call-template>
											</Comments>
									</xsl:if>
									</QuoteItemOut>
								</xsl:for-each>
								<xsl:for-each select="//ARBCIG_REQOTE/IDOC/E1EDP01/E1EDC01">
									<xsl:if test="POSEX != $v_zero_service_ln">
										<QuoteItemOut>
											<xsl:variable name="v_srvmapkey">
												<xsl:value-of select="E1ARBCIG_SERVICE_INFO/SRVMAPKEY"/>
											</xsl:variable>
											<xsl:attribute name="quantity">
												<xsl:choose>
													<xsl:when test="string-length(MENGE) > 0">
														<xsl:value-of	select="format-number(MENGE, '0.000')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="'0.000'"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="lineNumber">
												<xsl:choose>
													<xsl:when test="substring($v_srvmapkey, 1, 1) = '5' and string-length($v_srvmapkey) = 10">
														<xsl:value-of	select="concat(1, substring($v_srvmapkey, 2))"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$v_srvmapkey"/>														
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="parentLineNumber">
												<xsl:variable name="v_removeLeadingZero" select="format-number(E1ARBCIG_SERVICE_INFO/PARENT_LINE, '#')"/>
												<xsl:choose>
													<xsl:when test="string-length($v_removeLeadingZero) > 5">
														<xsl:value-of	select="E1ARBCIG_SERVICE_INFO/PARENT_LINE"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring(E1ARBCIG_SERVICE_INFO/PARENT_LINE, 6)"/>
														<xsl:variable name="v_NumCheck"	select="substring(E1ARBCIG_SERVICE_INFO/PARENT_LINE, 6)"/>
														<xsl:if test="string-length($v_NumCheck) = 0">
															<xsl:value-of	select="E1ARBCIG_SERVICE_INFO/PARENT_LINE"/>
														</xsl:if>
													</xsl:otherwise>
												</xsl:choose>													
											</xsl:attribute>												
											<xsl:attribute name="itemClassification"	>
												<xsl:value-of select="'service'"/>
											</xsl:attribute>
											<xsl:attribute name="itemType">
												<xsl:choose>
													<xsl:when test="SGTYP = '001'">
														<xsl:value-of select="'composite'"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="'item'"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="serviceLineType">
												<xsl:if test="../POSEX != $v_zero_service_ln">
													<xsl:variable name="v_servicelinetype"	select="E1ARBCIG_SERVICE_INFO/TDLINE"/>
													<xsl:choose>
														<xsl:when test="$v_servicelinetype = 'STNDLN'">
															<xsl:value-of select="'standard'"/>
														</xsl:when>
														<xsl:when test="$v_servicelinetype = 'BLKTLN'">
															<xsl:value-of select="'blanket'"/>
														</xsl:when>
														<xsl:when test="$v_servicelinetype = 'CNTGLN'">
															<xsl:value-of select="'contingency'"/>
														</xsl:when>
														<xsl:when test="$v_servicelinetype = 'OPNQLN'">
															<xsl:value-of select="'openquantity'"/>
														</xsl:when>
														<xsl:when test="$v_servicelinetype = 'INFRLN'">
															<xsl:value-of select="'information'"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="'standard'"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:attribute>
											<xsl:if	test="POSEX != $v_zero_service_ln and (string-length(E1EDC19[QUALF = '031']) > 0 or string-length(E1EDC19[QUALF = '032']) > 0)">
												<ItemID>
														<!-- S4HANA check for IDTNR and IDTNR_LONG -->
														<xsl:choose>
															<xsl:when	test="string-length(E1EDC19[QUALF = 032]/IDTNR_LONG) > 0">
																<SupplierPartID>
																	<xsl:value-of	select="E1EDC19[QUALF = 032]/IDTNR_LONG"/>
																</SupplierPartID>
															</xsl:when>
															<xsl:otherwise>
																<SupplierPartID>
																	<xsl:value-of select="E1EDC19[QUALF = 032]/IDTNR"/>
																</SupplierPartID>
															</xsl:otherwise>
														</xsl:choose>
														<!--</xsl:if>-->
														<xsl:if test="E1EDC19[QUALF = 031]">
															<!-- S4HANA check for IDTNR and IDTNR_LONG -->
															<xsl:choose>
																<xsl:when	test="string-length(E1EDC19[QUALF = 031]/IDTNR_LONG) > 0">
																	<BuyerPartID>
																		<xsl:value-of	select="E1EDC19[QUALF = 031]/IDTNR_LONG"/>
																	</BuyerPartID>
																</xsl:when>
																<xsl:otherwise>
																	<BuyerPartID>
																		<xsl:value-of select="E1EDC19[QUALF = 031]/IDTNR"/>
																	</BuyerPartID>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</ItemID>
												</xsl:if>
												<ItemDetail>
													<UnitPrice>
														<Money>
															<xsl:attribute name="currency">
																<xsl:if test="POSEX != $v_zero_service_ln">
																	<xsl:choose>
																		<xsl:when test="string-length(CURCY) > 0">
																			<xsl:value-of select="CURCY"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of	select="../../E1EDK01/E1ARBCIG_HEADER/CURRENCY"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:if>
															</xsl:attribute>
														</Money>
													</UnitPrice>
													<xsl:if test="../POSEX != $v_zero_service_ln">
														<xsl:if test="SGTYP = '001'">
															<Description>
																<xsl:attribute name="xml:lang">
																	<xsl:choose>
																		<xsl:when	test="string-length($v_rfq_header/COMPANY_LANG) > 0">
																			<xsl:value-of	select="$v_rfq_header/COMPANY_LANG_ISO"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$v_defaultLang"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
																<ShortName>
																	<xsl:value-of select="EXGRP"/>
																</ShortName>
															</Description>
														</xsl:if>
													</xsl:if>
													<Description>
														<xsl:if	test="../POSEX != $v_zero_service_ln and string-length(KTXT1) > 0">
															<xsl:attribute name="xml:lang">
																<xsl:choose>
																	<xsl:when	test="string-length($v_rfq_header/COMPANY_LANG) > 0">
																		<xsl:value-of	select="$v_rfq_header/COMPANY_LANG_ISO"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$v_defaultLang"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
															<xsl:value-of select="KTXT1"/>
														</xsl:if>
													</Description>
													<UnitOfMeasure>
														<xsl:if test="../POSEX != $v_zero_service_ln">
															<xsl:choose>
																<xsl:when test="string-length(MENEE) > 0">
																	<xsl:value-of select="MENEE"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="'EA'"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</UnitOfMeasure>
													<Classification>
														<xsl:attribute name="domain"	>
															<xsl:value-of select="'MaterialGroup'"/>
														</xsl:attribute>
														<xsl:attribute name="code">
															<xsl:if test="../POSEX != $v_zero_service_ln">
																<xsl:choose>
																	<xsl:when test="string-length(MATKL) > 0">
																		<xsl:value-of select="MATKL"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="'000'"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
														</xsl:attribute>
														<xsl:if test="../POSEX != $v_zero_service_ln">
															<xsl:choose>
																<xsl:when	test="string-length(E1ARBCIG_SERVICE_INFO/WGBEZ) > 0">
																	<xsl:value-of select="E1ARBCIG_SERVICE_INFO/WGBEZ"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="'Services'"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</Classification>
													<!--Mapping Service Comments-->
													<!-- IG-33887 -->
													<xsl:if
														test="exists(E1EDCT1/E1EDCT2/E1ARBCIG_SERVICE_TXT)">
														<Extrinsic>
															<xsl:attribute name="name" select="'ServiceText'"/>
															<xsl:if test="E1EDCT1/E1EDCT2/TDLINE = 'INTERNAL'">
																<Extrinsic>
																	<xsl:attribute name="name">
																		<xsl:variable name="v_interaltext">
																			<xsl:call-template name="LookupTemplate">
																				<xsl:with-param name="p_anERPSystemID"
																					select="$anERPSystemID"/>
																				<xsl:with-param name="p_anSupplierANID"
																					select="$anSupplierANID"/>
																				<xsl:with-param name="p_producttype"
																					select="'AribaSourcing'"/>
																				<xsl:with-param name="p_doctype"
																					select="$anTargetDocumentType"/>
																				<xsl:with-param name="p_lookupname"
																					select="'ServiceLineNote'"/>
																				<xsl:with-param name="p_input"
																					select="'InternalServiceLineNote'"/>
																			</xsl:call-template>
																		</xsl:variable>
																		<xsl:choose>
																			<xsl:when test="$v_interaltext != ''">
																				<xsl:value-of select="$v_interaltext"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="'InternalServiceLineNote'"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:for-each
																		select="E1EDCT1/E1EDCT2/E1ARBCIG_SERVICE_TXT">
																		<xsl:if test="../TDLINE = 'INTERNAL'">
																			<xsl:choose>
																				<!-- New Line  -->
																				<xsl:when test="TDFORMAT = '* ' or '/ '">
																					<xsl:value-of
																						select="concat('&#xA;', normalize-space(COMMENTS))"
																					/>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of
																						select="concat(' ', normalize-space(COMMENTS))"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</xsl:if>
																	</xsl:for-each>
																</Extrinsic>
															</xsl:if>
															<xsl:if test="E1EDCT1/E1EDCT2/TDLINE = 'EXTERNAL'">
																<Extrinsic>
																	<xsl:attribute name="name">
																		<xsl:variable name="v_externaltext">
																			<xsl:call-template name="LookupTemplate">
																				<xsl:with-param name="p_anERPSystemID"
																					select="$anERPSystemID"/>
																				<xsl:with-param name="p_anSupplierANID"
																					select="$anSupplierANID"/>
																				<xsl:with-param name="p_producttype"
																					select="'AribaSourcing'"/>
																				<xsl:with-param name="p_doctype"
																					select="$anTargetDocumentType"/>
																				<xsl:with-param name="p_lookupname"
																					select="'ServiceLineNote'"/>
																				<xsl:with-param name="p_input"
																					select="'ExternalServiceLineNote'"/>
																			</xsl:call-template>
																		</xsl:variable>
																		<xsl:choose>
																			<xsl:when test="$v_externaltext != ''">
																				<xsl:value-of select="$v_externaltext"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="'ExternalServiceLineNote'"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:for-each
																		select="E1EDCT1/E1EDCT2/E1ARBCIG_SERVICE_TXT">
																		<xsl:if test="../TDLINE = 'EXTERNAL'">
																			<xsl:choose>
																				<!-- New Line  -->
																				<xsl:when test="TDFORMAT = '* ' or '/ '">
																					<xsl:value-of
																						select="concat('&#xA;', normalize-space(COMMENTS))"
																					/>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of
																						select="concat(' ', normalize-space(COMMENTS))"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</xsl:if>
																	</xsl:for-each>
																</Extrinsic>
															</xsl:if>
														</Extrinsic>
													</xsl:if>
													<!--Mapping Alternetive-->
												</ItemDetail>
												<ReferenceDocumentInfo>
													<xsl:attribute name="lineNumber">
														<xsl:value-of select="$v_srvmapkey"/>
													</xsl:attribute>
													<DocumentInfo>
														<xsl:attribute name="documentID">
															<xsl:value-of select="../E1EDP02[QUALF = 016]/BELNR"/>
														</xsl:attribute>
														<xsl:attribute name="documentType">
															<xsl:value-of select="'requisition'"/>
														</xsl:attribute>
													</DocumentInfo>
												</ReferenceDocumentInfo>
												<xsl:if test="exists(E1ARBCIG_SERVICE_INFO/ALTERNATIVES)">
													<Alternative>
														<xsl:attribute name="alternativeType">
															<xsl:choose>
																<xsl:when	test="E1ARBCIG_SERVICE_INFO/ALTERNATIVES = 'BASIC'">
																	<xsl:value-of select="'basicLine'"/>
																</xsl:when>
																<xsl:when	test="starts-with(E1ARBCIG_SERVICE_INFO/ALTERNATIVES, 'ALTER')">
																	<xsl:value-of select="'alternativeLine'"/>
																</xsl:when>
																<xsl:when	test="E1ARBCIG_SERVICE_INFO/ALTERNATIVES = 'STNRD'">
																	<xsl:value-of select="'noAlternative'"/>
																</xsl:when>
															</xsl:choose>
														</xsl:attribute>
														<xsl:if	test="starts-with(E1ARBCIG_SERVICE_INFO/ALTERNATIVES, 'ALTER')">
															<xsl:attribute name="basicLineNumber">
																<xsl:value-of	select="E1ARBCIG_SERVICE_INFO/BASIC_LINE"/>
															</xsl:attribute>
														</xsl:if>
													</Alternative>
												</xsl:if>
											<xsl:variable name="v_att_line">
												<xsl:for-each select="$v_attach[LINENUMBER!='']">                                 
													<xsl:value-of select="'1'"/>                                 
												</xsl:for-each>   
											</xsl:variable>
											<xsl:if test="$v_attach/LINENUMBER = POSEX or (E1EDPT1)">
											<Comments>
												<xsl:call-template name="CommentsFillIdocOutPO">
													<xsl:with-param name="p_aribaComment"	select="E1EDPT1"/>
													<xsl:with-param name="p_itemNumber" select="POSEX"/>
													<xsl:with-param name="p_doctype"	select="$anTargetDocumentType"/>
													<xsl:with-param name="p_pd" select="$v_pd"/>
												</xsl:call-template>
												<xsl:call-template name="addContenIdIDOC">
													<xsl:with-param name="eachAtt" select="$v_attach"/>
													<xsl:with-param name="lineNumber" select="POSEX"/>
												</xsl:call-template>
											</Comments>
											</xsl:if>
											</QuoteItemOut>
										</xsl:if>
									</xsl:for-each>
								</QuoteRequest>
							</Request>
						</cXML>
					</Payload>
 					<xsl:call-template name="OutBoundAttachIDOC">
						<xsl:with-param name="eachAtt" select="$v_attach"/>
					</xsl:call-template>
				</Combined>
			</xsl:template>
		</xsl:stylesheet>
