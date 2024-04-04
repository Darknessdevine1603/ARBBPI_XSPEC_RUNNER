<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anISASender"/>
	<xsl:param name="anISASenderQual"/>
	<xsl:param name="anISAReceiver"/>
	<xsl:param name="anISAReceiverQual"/>
	<xsl:param name="anDate"/>
	<xsl:param name="anTime"/>
	<xsl:param name="anICNValue"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anSenderGroupID"/>
	<xsl:param name="anReceiverGroupID"/>
	<xsl:param name="exchange"/>

	<!-- For local testing -->
	<!-- xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>
	<xsl:include href="Format_CXML_ASC-X12_common.xsl"/-->
	<!-- PD references -->

	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>

	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>SM</D_479>
					<D_142>
						<xsl:choose>
							<xsl:when test="$anSenderGroupID != ''">
								<xsl:value-of select="$anSenderGroupID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ARIBA</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</D_142>
					<D_124>
						<xsl:choose>
							<xsl:when test="$anReceiverGroupID != ''">
								<xsl:value-of select="$anReceiverGroupID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ARIBA</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</D_124>
					<D_373>
						<xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
					</D_373>
					<D_337>
						<xsl:value-of select="format-dateTime($dateNow, '[H01][m01][s01]')"/>
					</D_337>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
					<D_455>X</D_455>
					<D_480>004010</D_480>
				</S_GS>
				<M_204>
					<S_ST>
						<D_143>204</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<!-- beginning of document mapping -->
					<S_B2>
						<xsl:if test="normalize-space(cXML/Request/TransportRequest/TransportRequestHeader/@requestID) != ''">
							<D_145>
								<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/TransportRequestHeader/@requestID), 1, 30)"/>
							</D_145>
						</xsl:if>
						<xsl:for-each select="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Dimension[UnitOfMeasure = 'grossWeight' or UnitOfMeasure = 'unitGrossWeight' or UnitOfMeasure = 'unitNetWeight']">
							<xsl:if test="position() = 1">
								<xsl:variable name="uomCode" select="UnitOfMeasure"/>
								<xsl:variable name="uomX12" select="$Lookup/Lookups/WeightUnitCodes/WeightUnitCode[CXMLCode = $uomCode]/X12Code"/>
								<D_188>
									<xsl:choose>
										<xsl:when test="$uomX12 != ''">
											<xsl:value-of select="$uomX12"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$uomCode"/>
										</xsl:otherwise>
									</xsl:choose>
								</D_188>
							</xsl:if>
						</xsl:for-each>
						<D_146>DE</D_146>
						<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/CommercialTerms/@incoterms)">
							<xsl:variable name="tCode" select="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/CommercialTerms/@incoterms)"/>
							<xsl:variable name="lookupResult" select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $tCode]/X12Code"/>
							<xsl:choose>
								<xsl:when test="$lookupResult != ''">
									<D_591>
										<xsl:value-of select="$lookupResult"/>
									</D_591>
								</xsl:when>
								<xsl:otherwise>
									<D_591>
										<xsl:value-of select="'ZZZ'"/>
									</D_591>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</S_B2>
					<S_B2A>
						<D_353>
							<xsl:choose>
								<xsl:when test="cXML/Request/TransportRequest/TransportRequestHeader/@operation = 'delete'">
									<xsl:value-of select="'03'"/>
								</xsl:when>
								<xsl:when test="cXML/Request/TransportRequest/TransportRequestHeader/@operation = 'update'">
									<xsl:value-of select="'05'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'00'"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_353>
					</S_B2A>
					<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/@consignmentID) != ''">
						<S_L11>
							<D_127>
								<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/@consignmentID), 1, 30)"/>
							</D_127>
							<D_128>CI</D_128>
						</S_L11>
					</xsl:if>
					<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier/@domain) != ''">
						<S_L11>
							<D_127>
								<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier/@domain), 1, 30)"/>
							</D_127>
							<D_128>CN</D_128>
							<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier) != ''">
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier), 1, 80)"/>
								</D_352>
							</xsl:if>
						</S_L11>
					</xsl:if>
					<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier/@trackingNumberDate) != ''">
						<S_L11>
							<D_127>
								<xsl:value-of select="replace(substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier/@trackingNumberDate), 0, 11), '-', '')"/>
							</D_127>
							<D_128>2I</D_128>
							<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier/@trackingURL) != ''">
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ShipmentIdentifier/@trackingURL), 1, 80)"/>
								</D_352>
							</xsl:if>
						</S_L11>
					</xsl:if>
					<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Description) != ''">
						<S_L11>
							<D_127>Hazard Description</D_127>
							<D_128>UN</D_128>
							<D_352>
								<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Description), 1, 80)"/>
							</D_352>
						</S_L11>
					</xsl:if>
					<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Classification[1]/@domain) != ''">
						<S_L11>
							<D_127>
								<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Classification[1]/@domain), 1, 30)"/>
							</D_127>
							<D_128>UN</D_128>
							<xsl:if test="normalize-space(concat(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Classification[1], ' ', cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Classification[1]/@code)) != ''">
								<D_352>
									<xsl:value-of select="substring(normalize-space(concat(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Classification[1], ' ', cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportRequirements/Hazard[1]/Classification[1]/@code)), 1, 80)"/>
								</D_352>
							</xsl:if>
						</S_L11>
					</xsl:if>
					<xsl:for-each select="cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Extrinsic">
						<S_L11>
							<D_127>
								<xsl:value-of select="substring(normalize-space(./@name), 1, 30)"/>
							</D_127>
							<D_128>ZZ</D_128>
							<xsl:if test="normalize-space(./text()) != ''">
								<D_352>
									<xsl:value-of select="substring(normalize-space(./text()), 1, 80)"/>
								</D_352>
							</xsl:if>
						</S_L11>
					</xsl:for-each>
					<xsl:for-each select="cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/ReferenceDocumentInfo">
						<xsl:variable name="rCode" select="DocumentInfo/@documentType"/>
						<xsl:variable name="refCode" select="$Lookup/Lookups/ConsigmentReferenceCodes/ConsigmentReferenceCode[CXMLCode = $rCode]/X12Code"/>
						<S_L11>
							<D_127>
								<xsl:value-of select="substring(normalize-space(DocumentInfo/@documentID), 1, 30)"/>
							</D_127>
							<D_128>ZZ</D_128>
						</S_L11>
					</xsl:for-each>
					<xsl:if test="cXML/Request/TransportRequest/TransportRequestHeader/@requestDate">
						<S_G62>
							<D_432>85</D_432>
							<xsl:call-template name="createDTM_NoGroup">
								<xsl:with-param name="cXMLDate" select="cXML/Request/TransportRequest/TransportRequestHeader/@requestDate"/>
							</xsl:call-template>
						</S_G62>
					</xsl:if>
					<xsl:if test="string-length(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Route/Contact[@addressIDDomain = 'SCAC']/@addressID)) &gt; 2">
						<S_MS3>
							<D_140>
								<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Route/Contact[@addressIDDomain = 'SCAC']/@addressID), 1, 4)"/>
							</D_140>
							<D_133>B</D_133>
							<xsl:if test="string-length(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Route/Contact[@addressIDDomain = 'SCAC']/Name)) &gt; 2">
								<D_19>
									<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Route/Contact[@addressIDDomain = 'SCAC']/Name), 1, 30)"/>
								</D_19>
							</xsl:if>
							<xsl:variable name="routeCode" select="normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Route/@method)"/>
							<xsl:variable name="routeLookup" select="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $routeCode]/X12Code"/>
							<D_91>
								<xsl:choose>
									<xsl:when test="$routeLookup != ''">
										<xsl:value-of select="$routeLookup"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'ZZ'"/>
									</xsl:otherwise>
								</xsl:choose>
							</D_91>
							<D_156>st</D_156>
						</S_MS3>
					</xsl:if>
					<xsl:if test="cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportCondition/Priority">
						<S_AT5>
							<D_152>PYS</D_152>
							<D_153>
								<xsl:variable name="prio" select="substring(normalize-space(cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportCondition/Priority/@level), 1, 30)"/>
								<xsl:choose>
									<xsl:when test="string-length($prio) = 1">
										<xsl:value-of select="concat('0', $prio)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$prio"/>
									</xsl:otherwise>
								</xsl:choose>
							</D_153>
						</S_AT5>
					</xsl:if>
					<xsl:variable name="commentsTxt">
						<xsl:for-each select="cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Comments">
							<xsl:value-of select="concat(normalize-space(.), ' ')"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="StrLen" select="string-length($commentsTxt)"/>
					<xsl:if test="normalize-space($commentsTxt) != ''">
						<xsl:call-template name="TextLoop">
							<xsl:with-param name="Desc" select="normalize-space($commentsTxt)"/>
							<xsl:with-param name="StrLen" select="$StrLen"/>
							<xsl:with-param name="Pos" select="1"/>
							<xsl:with-param name="CurrentEndPos" select="1"/>
						</xsl:call-template>
					</xsl:if>


					<xsl:for-each select="cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/TransportPartner/Contact">
						<xsl:variable name="code" select="@role"/>
						<xsl:variable name="tRole">
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode = $code]/X12Code != ''">
									<xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $code]/X12Code"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:if test="$tRole != ''">
							<G_0100>
								<xsl:call-template name="createN1_NoGroup">
									<xsl:with-param name="party" select="."/>
									<xsl:with-param name="role" select="$tRole"/>
								</xsl:call-template>

								<xsl:variable name="listOfContactInfo">
									<ContactInfoList>
										<xsl:for-each select="Email">
											<xsl:if test="normalize-space(.) != ''">
												<ContactInfo>
													<Value>
														<xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
													</Value>
													<CCode>Email</CCode>
													<CName>
														<xsl:choose>
															<xsl:when test="normalize-space(@name) != ''">
																<xsl:value-of select="substring(normalize-space(@name), 1, 60)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="'default'"/>
															</xsl:otherwise>
														</xsl:choose>
													</CName>
												</ContactInfo>
											</xsl:if>
										</xsl:for-each>
										<xsl:for-each select="Phone">
											<xsl:if test="normalize-space(.) != ''">
												<ContactInfo>
													<Value>
														<xsl:variable name="isoCCode" select="TelephoneNumber/CountryCode/@isoCountryCode"/>
														<xsl:variable name="ccCode">
															<xsl:choose>
																<xsl:when test="normalize-space(TelephoneNumber/CountryCode) != ''">
																	<xsl:value-of select="TelephoneNumber/CountryCode"/>
																</xsl:when>
																<xsl:when test="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1] != ''">
																	<xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1]"/>
																</xsl:when>
																<xsl:otherwise>1</xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<xsl:variable name="areaCode">
															<xsl:if test="normalize-space(TelephoneNumber/AreaOrCityCode) != ''">
																<xsl:value-of select="concat('(', normalize-space(TelephoneNumber/AreaOrCityCode), ')')"/>
															</xsl:if>
														</xsl:variable>
														<xsl:variable name="TelNum">
															<xsl:if test="normalize-space(TelephoneNumber/Number) != ''">
																<xsl:value-of select="concat('-', replace(normalize-space(TelephoneNumber/Number), '-', ''))"/>
															</xsl:if>
														</xsl:variable>
														<xsl:variable name="ext">
															<xsl:if test="normalize-space(TelephoneNumber/Extension) != ''">
																<xsl:value-of select="concat('x', replace(normalize-space(TelephoneNumber/Extension), '-', ''))"/>
															</xsl:if>
														</xsl:variable>
														<xsl:variable name="Number" select="concat($ccCode, $areaCode, $TelNum, $ext)"/>
														<xsl:choose>
															<xsl:when test="starts-with($Number, '-')">
																<xsl:value-of select="substring(normalize-space(substring($Number, 2)), 1, 80)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="substring(normalize-space($Number), 1, 80)"/>
															</xsl:otherwise>
														</xsl:choose>
													</Value>
													<CCode>Phone</CCode>
													<CName>
														<xsl:choose>
															<xsl:when test="normalize-space(@name) != ''">
																<xsl:value-of select="substring(normalize-space(@name), 1, 60)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="'default'"/>
															</xsl:otherwise>
														</xsl:choose>
													</CName>
												</ContactInfo>
											</xsl:if>
										</xsl:for-each>
										<xsl:for-each select="Fax">
											<xsl:if test="normalize-space(.) != ''">
												<ContactInfo>
													<Value>
														<xsl:variable name="isoCCode" select="TelephoneNumber/CountryCode/@isoCountryCode"/>
														<xsl:variable name="ccCode">
															<xsl:choose>
																<xsl:when test="normalize-space(TelephoneNumber/CountryCode) != ''">
																	<xsl:value-of select="TelephoneNumber/CountryCode"/>
																</xsl:when>
																<xsl:when test="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1] != ''">
																	<xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCCode]/phoneCode[1]"/>
																</xsl:when>
																<xsl:otherwise>1</xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<xsl:variable name="areaCode">
															<xsl:if test="normalize-space(TelephoneNumber/AreaOrCityCode) != ''">
																<xsl:value-of select="concat('(', normalize-space(TelephoneNumber/AreaOrCityCode), ')')"/>
															</xsl:if>
														</xsl:variable>
														<xsl:variable name="TelNum">
															<xsl:if test="normalize-space(TelephoneNumber/Number) != ''">
																<xsl:value-of select="concat('-', replace(normalize-space(TelephoneNumber/Number), '-', ''))"/>
															</xsl:if>
														</xsl:variable>
														<xsl:variable name="ext">
															<xsl:if test="normalize-space(TelephoneNumber/Extension) != ''">
																<xsl:value-of select="concat('x', replace(normalize-space(TelephoneNumber/Extension), '-', ''))"/>
															</xsl:if>
														</xsl:variable>
														<xsl:variable name="Number" select="concat($ccCode, $areaCode, $TelNum, $ext)"/>
														<xsl:choose>
															<xsl:when test="starts-with($Number, '-')">
																<xsl:value-of select="substring(normalize-space(substring($Number, 2)), 1, 80)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="substring(normalize-space($Number), 1, 80)"/>
															</xsl:otherwise>
														</xsl:choose>
													</Value>
													<CCode>Fax</CCode>
													<CName>
														<xsl:choose>
															<xsl:when test="normalize-space(@name) != ''">
																<xsl:value-of select="substring(normalize-space(@name), 1, 60)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="'default'"/>
															</xsl:otherwise>
														</xsl:choose>
													</CName>
												</ContactInfo>
											</xsl:if>
										</xsl:for-each>
										<xsl:for-each select="URL">
											<xsl:if test="normalize-space(.) != ''">
												<ContactInfo>
													<Value>
														<xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
													</Value>
													<CCode>URL</CCode>
													<CName>
														<xsl:choose>
															<xsl:when test="normalize-space(@name) != ''">
																<xsl:value-of select="substring(normalize-space(@name), 1, 60)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="'default'"/>
															</xsl:otherwise>
														</xsl:choose>
													</CName>
												</ContactInfo>
											</xsl:if>
										</xsl:for-each>
									</ContactInfoList>
								</xsl:variable>
								<xsl:for-each select="$listOfContactInfo/ContactInfoList/ContactInfo[position() &lt;= 3]">
									<S_G61>
										<D_366>CN</D_366>
										<D_93>
											<xsl:value-of select="CName"/>
										</D_93>
										<D_365>
											<xsl:choose>
												<xsl:when test="CCode = 'Email'">
													<xsl:value-of select="'EM'"/>
												</xsl:when>
												<xsl:when test="CCode = 'Phone'">
													<xsl:value-of select="'TE'"/>
												</xsl:when>
												<xsl:when test="CCode = 'Fax'">
													<xsl:value-of select="'FX'"/>
												</xsl:when>
												<xsl:when test="CCode = 'URL'">
													<xsl:value-of select="'UR'"/>
												</xsl:when>
											</xsl:choose>
										</D_365>
										<D_364>
											<xsl:value-of select="Value"/>
										</D_364>
									</S_G61>
								</xsl:for-each>
							</G_0100>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="cXML/Request/TransportRequest/Consignment/TransportEquipment">
						<xsl:if test="normalize-space(@equipmentID) != ''">
							<G_0200>
								<S_N7>
									<D_207>
										<xsl:value-of select="substring(normalize-space(@equipmentID), 1, 10)"/>
									</D_207>

									<xsl:variable name="provBy" select="normalize-space(@providedBy)"/>
									<xsl:if test="$provBy != ''">
										<xsl:variable name="provByCode" select="$Lookup/Lookups/OwnershipCodes/OwnershipCode[CXMLCode = $provBy]/X12Code"/>
										<D_102>
											<xsl:choose>
												<xsl:when test="$provByCode != ''">
													<xsl:value-of select="$provByCode"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'N'"/>
												</xsl:otherwise>
											</xsl:choose>
										</D_102>
									</xsl:if>

									<xsl:variable name="equip" select="normalize-space(@type)"/>
									<xsl:variable name="equipCode" select="$Lookup/Lookups/TransportEquipmentCodes/TransportEquipmentCode[CXMLCode = $equip]/X12Code"/>
									<xsl:variable name="equipLength" select="$Lookup/Lookups/TransportEquipmentCodes/TransportEquipmentCode[CXMLCode = $equip]/Length"/>
									<xsl:if test="$equipCode != ''">
										<D_40>
											<xsl:value-of select="$equipCode"/>
										</D_40>
									</xsl:if>
									<xsl:if test="$equipLength != ''">
										<D_24>
											<xsl:value-of select="$equipLength"/>
										</D_24>
									</xsl:if>

									<xsl:if test="normalize-space(@status) != ''">
										<D_301>
											<xsl:choose>
												<xsl:when test="normalize-space(@status) = 'empty'">
													<xsl:value-of select="'4'"/>
												</xsl:when>
												<xsl:when test="normalize-space(@status) = 'full'">
													<xsl:value-of select="'5'"/>
												</xsl:when>
											</xsl:choose>
										</D_301>
									</xsl:if>
								</S_N7>
							</G_0200>
						</xsl:if>
					</xsl:for-each>
					<!-- origin -->
					<G_0300>
						<S_S5>
							<D_165>0</D_165>
							<D_163>SL</D_163>
							<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Origin/Address/Name) != ''">
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Origin/Address/Name), 1, 80)"/>
								</D_352>
							</xsl:if>
							<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Origin/Address/@addressID) != ''">
								<D_154>
									<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Origin/Address/@addressID), 1, 80)"/>
								</D_154>
							</xsl:if>
						</S_S5>
						<xsl:for-each select="cXML/Request/TransportRequest/Consignment[1]/ConsignmentHeader/Origin/DateInfo">
							<xsl:variable name="dateQfy">
								<xsl:choose>
									<xsl:when test="@type = 'requestedPickUpDate'">
										<xsl:value-of select="'10'"/>
									</xsl:when>
									<xsl:when test="@type = 'expectedShipmentDate'">
										<xsl:value-of select="'11'"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="string-length($dateQfy) = 2">
								<S_G62>
									<D_432>
										<xsl:value-of select="$dateQfy"/>
									</D_432>
									<xsl:call-template name="createDTM_NoGroup">
										<xsl:with-param name="cXMLDate" select="@date"/>
									</xsl:call-template>
								</S_G62>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Origin/Address">
							<G_0310>
								<xsl:call-template name="createN1_NoGroup">
									<xsl:with-param name="party" select="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Origin/Address"/>
									<xsl:with-param name="role" select="'LP'"/>
								</xsl:call-template>
							</G_0310>
						</xsl:if>
					</G_0300>

					<!-- destination -->
					<G_0300>
						<S_S5>
							<D_165>00</D_165>
							<D_163>SU</D_163>
							<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Destination/Address/Name) != ''">
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Destination/Address/Name), 1, 80)"/>
								</D_352>
							</xsl:if>
							<xsl:if test="normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Destination/Address/@addressID) != ''">
								<D_154>
									<xsl:value-of select="substring(normalize-space(cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Destination/Address/@addressID), 1, 80)"/>
								</D_154>
							</xsl:if>
						</S_S5>
						<xsl:for-each select="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Destination/DateInfo">
							<xsl:variable name="dateQfy">
								<xsl:choose>
									<xsl:when test="@type = 'expectedDeliveryDate'">
										<xsl:value-of select="'17'"/>
									</xsl:when>
									<xsl:when test="@type = 'requestedDeliveryDate'">
										<xsl:value-of select="'02'"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="string-length($dateQfy) = 2">
								<S_G62>
									<D_432>
										<xsl:value-of select="$dateQfy"/>
									</D_432>
									<xsl:call-template name="createDTM_NoGroup">
										<xsl:with-param name="cXMLDate" select="@date"/>
									</xsl:call-template>
								</S_G62>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Destination/Address">
							<G_0310>
								<xsl:call-template name="createN1_NoGroup">
									<xsl:with-param name="party" select="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Destination/Address"/>
									<xsl:with-param name="role" select="'UP'"/>
								</xsl:call-template>
							</G_0310>
						</xsl:if>
					</G_0300>

					<xsl:for-each select="cXML/Request/TransportRequest/Consignment/ConsignmentLineDetail">
						<G_0300>
							<S_S5>
								<D_165>
									<xsl:value-of select="substring(normalize-space(@lineNumber), 1, 3)"/>
								</D_165>
								<D_163>CL</D_163>
								<xsl:for-each select="TransportPackage[Packaging/PackagingLevelCode = 'inner' or Packaging/PackagingLevelCode = '']/ItemInfo">
									<xsl:if test="position() = 1">
										<D_382>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty" select="@quantity"/>
											</xsl:call-template>

										</D_382>
										<xsl:variable name="uom" select="UnitOfMeasure"/>
										<D_355>
											<xsl:choose>
												<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
													<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
												</xsl:when>
												<xsl:otherwise>ZZ</xsl:otherwise>
											</xsl:choose>
										</D_355>
									</xsl:if>
								</xsl:for-each>
							</S_S5>
							<xsl:if test="normalize-space(TransportRequirements/Hazard[1]/Description) != ''">
								<S_L11>
									<D_127>Hazard Description</D_127>
									<D_128>UN</D_128>
									<D_352>
										<xsl:value-of select="substring(normalize-space(TransportRequirements/Hazard[1]/Description), 1, 80)"/>
									</D_352>
								</S_L11>
							</xsl:if>
							<xsl:if test="normalize-space(TransportRequirements/Hazard[1]/Classification[1]/@domain) != ''">
								<S_L11>
									<D_127>
										<xsl:value-of select="substring(normalize-space(TransportRequirements/Hazard[1]/Classification[1]/@domain), 1, 30)"/>
									</D_127>
									<D_128>UN</D_128>
									<xsl:if test="normalize-space(concat(TransportRequirements/Hazard[1]/Classification[1], ' ', TransportRequirements/Hazard[1]/Classification[1]/@code)) != ''">
										<D_352>
											<xsl:value-of select="substring(normalize-space(concat(TransportRequirements/Hazard[1]/Classification[1], ' ', TransportRequirements/Hazard[1]/Classification[1]/@code)), 1, 80)"/>
										</D_352>
									</xsl:if>
								</S_L11>
							</xsl:if>
							<xsl:for-each select="Extrinsic">
								<S_L11>
									<D_127>
										<xsl:value-of select="substring(normalize-space(./@name), 1, 30)"/>
									</D_127>
									<D_128>ZZ</D_128>
									<xsl:if test="normalize-space(./text()) != ''">
										<D_352>
											<xsl:value-of select="substring(normalize-space(./text()), 1, 80)"/>
										</D_352>
									</xsl:if>
								</S_L11>
							</xsl:for-each>
							<xsl:for-each select="ReferenceDocumentInfo">
								<xsl:variable name="rCode" select="DocumentInfo/@documentType"/>
								<xsl:variable name="refCode" select="$Lookup/Lookups/ConsigmentReferenceCodes/ConsigmentReferenceCode[CXMLCode = $rCode]/X12Code"/>
								<S_L11>
									<D_127>
										<xsl:value-of select="substring(normalize-space(DocumentInfo/@documentID), 1, 30)"/>
									</D_127>
									<D_128>ZZ</D_128>
								</S_L11>
							</xsl:for-each>

							<S_AT8>
								<xsl:if test="count(TransportPackage[Packaging/PackagingLevelCode = 'inner']) &gt; 0">
									<D_80>
										<xsl:value-of select="count(TransportPackage[Packaging/PackagingLevelCode = 'inner'])"/>
									</D_80>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="count(TransportPackage[Packaging/PackagingLevelCode = 'outer']) &gt; 0">
										<D_80_2>
											<xsl:value-of select="count(TransportPackage[Packaging/PackagingLevelCode = 'outer'])"/>
										</D_80_2>
									</xsl:when>
									<xsl:when test="count(TransportPackage[Packaging/PackagingLevelCode = '']) &gt; 0">
										<D_80_2>
											<xsl:value-of select="@numberOfPackages"/>
										</D_80_2>
									</xsl:when>
									<xsl:when test="count(TransportPackage[not(Packaging/PackagingLevelCode)]) &gt; 0">
										<D_80_2>
											<xsl:value-of select="@numberOfPackages"/>
										</D_80_2>
									</xsl:when>
								</xsl:choose>
							</S_AT8>

							<xsl:for-each select="TransportPackage[Packaging/PackagingLevelCode = 'inner' or Packaging/PackagingLevelCode = '' or not(Packaging/PackagingLevelCode)]">
								<xsl:if test="ItemInfo/ItemID">
									<S_LAD>
										<xsl:call-template name="createItemParts">
											<xsl:with-param name="itemID" select="ItemInfo/ItemID"/>
										</xsl:call-template>
									</S_LAD>
								</xsl:if>
								<xsl:if test="normalize-space(ItemInfo/SupplierBatchID) != '' or normalize-space(ItemInfo/Classification[@domain = 'UNSPSC']) != ''">
									<S_LAD>
										<xsl:variable name="partsList">
											<PartsList>
												<xsl:if test="normalize-space(ItemInfo/SupplierBatchID) != ''">
													<Part>
														<Qualifier>B8</Qualifier>
														<Value>
															<xsl:value-of select="substring(normalize-space(ItemInfo/SupplierBatchID), 1, 48)"/>
														</Value>
													</Part>
												</xsl:if>
												<xsl:if test="normalize-space(ItemInfo/Classification[@domain = 'UNSPSC']) != ''">
													<Part>
														<Qualifier>C3</Qualifier>
														<Value>
															<xsl:value-of select="substring(normalize-space(ItemInfo/Classification[@domain = 'UNSPSC']), 1, 48)"/>
														</Value>
													</Part>
												</xsl:if>
											</PartsList>
										</xsl:variable>

										<xsl:for-each select="$partsList/PartsList/Part">
											<xsl:choose>
												<xsl:when test="position() = 1">
													<xsl:element name="D_235">
														<xsl:value-of select="./Qualifier"/>
													</xsl:element>
													<xsl:element name="D_234">
														<xsl:value-of select="./Value"/>
													</xsl:element>
												</xsl:when>

												<xsl:otherwise>
													<xsl:element name="{concat('D_235', '_', position())}">
														<xsl:value-of select="./Qualifier"/>
													</xsl:element>
													<xsl:element name="{concat('D_234', '_', position())}">
														<xsl:value-of select="./Value"/>
													</xsl:element>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</S_LAD>
								</xsl:if>
							</xsl:for-each>

							<xsl:if test="TransportRequirements/TransportTemperature/@temperature">
								<S_AT5>
									<D_152>OTC</D_152>
									<D_153>
										<xsl:value-of select="TransportRequirements/TransportTemperature/@temperature"/>
									</D_153>
								</S_AT5>
							</xsl:if>
							<xsl:variable name="tempCode" select="normalize-space(TransportRequirements/TransportTemperature/UnitOfMeasure)"/>
							<xsl:variable name="tempLookup" select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $tempCode]/X12Code"/>
							<xsl:if test="$tempLookup != ''">
								<S_AT5>
									<D_152>H1</D_152>
									<D_153>
										<xsl:value-of select="$tempLookup"/>
									</D_153>
								</S_AT5>
							</xsl:if>

							<xsl:if test="Comments">
								<xsl:variable name="commentsTxt">
									<xsl:for-each select="Comments">
										<xsl:value-of select="concat(normalize-space(.), ' ')"/>
									</xsl:for-each>
								</xsl:variable>
								<xsl:variable name="StrLen" select="string-length($commentsTxt)"/>
								<xsl:if test="normalize-space($commentsTxt) != ''">
									<xsl:call-template name="TextLoop">
										<xsl:with-param name="Desc" select="normalize-space($commentsTxt)"/>
										<xsl:with-param name="StrLen" select="$StrLen"/>
										<xsl:with-param name="Pos" select="1"/>
										<xsl:with-param name="CurrentEndPos" select="1"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>

							<xsl:for-each select="TransportPackage">
								<G_0320>
									<S_L5>
										<xsl:if test="normalize-space(Packaging/Description) != ''">
											<D_79>
												<xsl:value-of select="substring(normalize-space(Packaging/Description), 1, 50)"/>
											</D_79>
										</xsl:if>

										<xsl:variable name="pCode" select="lower-case(Packaging/PackagingCode)"/>
										<xsl:variable name="pLookup" select="$Lookup/Lookups/PackagingCodes/PackagingCode[CXMLCode = $pCode]/X12Code"/>
										<xsl:if test="$pLookup != ''">
											<D_103>
												<xsl:value-of select="$pLookup"/>
											</D_103>
										</xsl:if>

										<xsl:if test="normalize-space(Packaging/ShippingContainerSerialCode) != ''">
											<D_87>
												<xsl:value-of select="substring(normalize-space(Packaging/ShippingContainerSerialCode), 1, 48)"/>
											</D_87>
										</xsl:if>

										<D_88>AA</D_88>
									</S_L5>

									<xsl:variable name="dimensionList">
										<DimensionList>
											<xsl:for-each select="Packaging/Dimension">
												<xsl:sort select="Packaging/Dimension/@type"/>
												<xsl:variable name="wType" select="normalize-space(@type)"/>
												<xsl:choose>
													<xsl:when test="contains(lower-case($wType), 'weight')">
														<xsl:variable name="wuom" select="normalize-space(UnitOfMeasure)"/>
														<xsl:variable name="tLookup" select="$Lookup/Lookups/WeightUnitCodes/WeightUnitCode[CXMLCode = $wuom]/X12Code"/>
														<xsl:choose>
															<xsl:when test="$tLookup != ''">
																<Dimension>
																	<DCode>
																		<xsl:value-of select="$tLookup"/>
																	</DCode>
																	<DValue>
																		<xsl:call-template name="formatQty">
																			<xsl:with-param name="qty" select="@quantity"/>
																		</xsl:call-template>

																	</DValue>
																	<DIdent>weight</DIdent>
																	<DType>
																		<xsl:value-of select="$wType"/>
																	</DType>
																</Dimension>
															</xsl:when>
															<xsl:otherwise>
																<Dimension>
																	<DCode>
																		<xsl:value-of select="'nocode'"/>
																	</DCode>
																	<DValue>
																		<xsl:call-template name="formatQty">
																			<xsl:with-param name="qty" select="@quantity"/>
																		</xsl:call-template>

																	</DValue>
																	<DIdent>weight</DIdent>
																	<DType>
																		<xsl:value-of select="$wType"/>
																	</DType>
																</Dimension>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:when test="$wType = 'volume' or $wType = 'grossVolume'">
														<xsl:variable name="wuom" select="normalize-space(UnitOfMeasure)"/>
														<xsl:variable name="tLookup" select="$Lookup/Lookups/VolumeUnitCodes/VolumeUnitCode[CXMLCode = $wuom]/X12Code"/>
														<xsl:choose>
															<xsl:when test="$tLookup != ''">
																<Dimension>
																	<DCode>
																		<xsl:value-of select="$tLookup"/>
																	</DCode>
																	<DValue>
																		<xsl:call-template name="formatQty">
																			<xsl:with-param name="qty" select="@quantity"/>
																		</xsl:call-template>

																	</DValue>
																	<DIdent>volume</DIdent>
																</Dimension>
															</xsl:when>
															<xsl:otherwise>
																<Dimension>
																	<DCode>
																		<xsl:value-of select="'nocode'"/>
																	</DCode>
																	<DValue>
																		<xsl:call-template name="formatQty">
																			<xsl:with-param name="qty" select="@quantity"/>
																		</xsl:call-template>

																	</DValue>
																	<DIdent>volume</DIdent>
																</Dimension>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
												</xsl:choose>
											</xsl:for-each>
										</DimensionList>
									</xsl:variable>
									<S_AT8>
										<xsl:if test="$dimensionList/DimensionList/Dimension[DIdent = 'weight']">
											<xsl:variable name="cType" select="($dimensionList/DimensionList/Dimension[DIdent = 'weight'])[1]/DType"/>

											<xsl:variable name="cLookup" select="$Lookup/Lookups/ConsignmentPackageDimensionCodes/ConsignmentPackageDimensionCode[CXMLCode = $cType]/X12Code"/>
											<xsl:if test="$cLookup != ''">
												<D_187>
													<xsl:value-of select="$cLookup"/>
												</D_187>
											</xsl:if>
											<xsl:if test="($dimensionList/DimensionList/Dimension[DIdent = 'weight'])[1]/DCode != 'nocode'">
												<D_188>
													<xsl:value-of select="($dimensionList/DimensionList/Dimension[DIdent = 'weight'])[1]/DCode"/>
												</D_188>
											</xsl:if>

											<D_81>
												<xsl:value-of select="($dimensionList/DimensionList/Dimension[DIdent = 'weight'])[1]/DValue"/>
											</D_81>
										</xsl:if>

										<xsl:if test="$dimensionList/DimensionList/Dimension[DIdent = 'volume']">
											<xsl:if test="($dimensionList/DimensionList/Dimension[DIdent = 'volume'])[1]/DCode != 'nocode'">
												<D_184>
													<xsl:value-of select="($dimensionList/DimensionList/Dimension[DIdent = 'volume'])[1]/DCode"/>
												</D_184>
											</xsl:if>
											<D_183>
												<xsl:value-of select="($dimensionList/DimensionList/Dimension[DIdent = 'volume'])[1]/DValue"/>
											</D_183>
										</xsl:if>
									</S_AT8>
								</G_0320>
							</xsl:for-each>
						</G_0300>
					</xsl:for-each>


					<xsl:variable name="dimensionList">
						<DimensionList>
							<xsl:for-each select="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Dimension">
								<xsl:sort select="cXML/Request/TransportRequest/Consignment/ConsignmentHeader/Dimension/@type"/>
								<xsl:variable name="wType" select="normalize-space(@type)"/>
								<xsl:choose>
									<xsl:when test="contains(lower-case($wType), 'weight')">
										<xsl:variable name="wuom" select="normalize-space(UnitOfMeasure)"/>
										<xsl:variable name="tLookup" select="$Lookup/Lookups/WeightUnitCodes/WeightUnitCode[CXMLCode = $wuom]/X12Code"/>
										<xsl:choose>
											<xsl:when test="$tLookup != ''">
												<Dimension>
													<DCode>
														<xsl:value-of select="$tLookup"/>
													</DCode>
													<DValue>
														<xsl:call-template name="formatQty">
															<xsl:with-param name="qty" select="@quantity"/>
														</xsl:call-template>

													</DValue>
													<DIdent>weight</DIdent>
													<DType>
														<xsl:value-of select="$wType"/>
													</DType>
												</Dimension>
											</xsl:when>
											<xsl:otherwise>
												<Dimension>
													<DCode>
														<xsl:value-of select="'nocode'"/>
													</DCode>
													<DValue>
														<xsl:call-template name="formatQty">
															<xsl:with-param name="qty" select="@quantity"/>
														</xsl:call-template>

													</DValue>
													<DIdent>weight</DIdent>
													<DType>
														<xsl:value-of select="$wType"/>
													</DType>
												</Dimension>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$wType = 'volume' or $wType = 'grossVolume'">
										<xsl:variable name="wuom" select="normalize-space(UnitOfMeasure)"/>
										<xsl:variable name="tLookup" select="$Lookup/Lookups/VolumeUnitCodes/VolumeUnitCode[CXMLCode = $wuom]/X12Code"/>
										<xsl:choose>
											<xsl:when test="$tLookup != ''">
												<Dimension>
													<DCode>
														<xsl:value-of select="$tLookup"/>
													</DCode>
													<DValue>
														<xsl:call-template name="formatQty">
															<xsl:with-param name="qty" select="@quantity"/>
														</xsl:call-template>

													</DValue>
													<DIdent>volume</DIdent>
												</Dimension>
											</xsl:when>
											<xsl:otherwise>
												<Dimension>
													<DCode>
														<xsl:value-of select="'nocode'"/>
													</DCode>
													<DValue>
														<xsl:call-template name="formatQty">
															<xsl:with-param name="qty" select="@quantity"/>
														</xsl:call-template>

													</DValue>
													<DIdent>volume</DIdent>
												</Dimension>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</DimensionList>
					</xsl:variable>

					<S_L3>
						<xsl:if test="$dimensionList/DimensionList/Dimension[DIdent = 'weight']">
							<xsl:variable name="cType" select="($dimensionList/DimensionList/Dimension[DIdent = 'weight'])[1]/DType"/>
							<xsl:variable name="cLookup" select="$Lookup/Lookups/ConsignmentPackageDimensionCodes/ConsignmentPackageDimensionCode[CXMLCode = $cType]/X12Code"/>

							<D_81>
								<xsl:value-of select="($dimensionList/DimensionList/Dimension[DIdent = 'weight'])[1]/DValue"/>
							</D_81>
							<xsl:if test="$cLookup != ''">
								<D_187>
									<xsl:value-of select="$cLookup"/>
								</D_187>
							</xsl:if>
						</xsl:if>

						<xsl:if test="cXML/Request/TransportRequest/TransportSummary/FreightChargesAmount/Money != ''">
							<D_58>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount" select="cXML/Request/TransportRequest/TransportSummary/FreightChargesAmount/Money"/>
									<xsl:with-param name="formatDecimals" select="'N2'"/>
								</xsl:call-template>
							</D_58>
						</xsl:if>

						<xsl:if test="cXML/Request/TransportRequest/TransportSummary/InsuranceValue/Money != ''">
							<D_191>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount" select="cXML/Request/TransportRequest/TransportSummary/InsuranceValue/Money"/>
									<xsl:with-param name="formatDecimals" select="'N2'"/>
								</xsl:call-template>
							</D_191>
						</xsl:if>
						<D_150>400</D_150>
						<xsl:if test="$dimensionList/DimensionList/Dimension[DIdent = 'volume']">
							<D_183>
								<xsl:value-of select="($dimensionList/DimensionList/Dimension[DIdent = 'volume'])[1]/DValue"/>
							</D_183>
							<xsl:if test="($dimensionList/DimensionList/Dimension[DIdent = 'volume'])[1]/DCode != 'nocode'">
								<D_184>
									<xsl:value-of select="($dimensionList/DimensionList/Dimension[DIdent = 'volume'])[1]/DCode"/>
								</D_184>
							</xsl:if>
						</xsl:if>
						<xsl:if test="cXML/Request/TransportRequest/TransportSummary/@numberOfPackages != ''">
							<D_80>
								<xsl:value-of select="cXML/Request/TransportRequest/TransportSummary/@numberOfPackages"/>
							</D_80>
						</xsl:if>
						<xsl:if test="cXML/Request/TransportRequest/TransportSummary/SubtotalAmount/Money != ''">
							<D_74>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount" select="cXML/Request/TransportRequest/TransportSummary/SubtotalAmount/Money"/>
									<xsl:with-param name="formatDecimals" select="'N2'"/>
								</xsl:call-template>
							</D_74>
						</xsl:if>
					</S_L3>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_204>
				<S_GE>
					<D_97>1</D_97>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
				</S_GE>
			</FunctionalGroup>
			<S_IEA>
				<D_I16>1</D_I16>
				<D_I12>
					<xsl:value-of select="$anICNValue"/>
				</D_I12>
			</S_IEA>
		</ns0:Interchange>
	</xsl:template>

	<xsl:template name="createDTM_NoGroup">
		<xsl:param name="D374_Qual"/>
		<xsl:param name="cXMLDate"/>
		<xsl:if test="$D374_Qual">
			<D_374>
				<xsl:value-of select="$D374_Qual"/>
			</D_374>
		</xsl:if>
		<D_373>
			<xsl:value-of select="replace(substring($cXMLDate, 0, 11), '-', '')"/>
		</D_373>
		<xsl:if test="replace(substring($cXMLDate, 12, 8), ':', '') != ''">
			<D_337>
				<xsl:value-of select="replace(substring($cXMLDate, 12, 8), ':', '')"/>
			</D_337>
		</xsl:if>
		<xsl:variable name="timeZone" select="replace(replace(substring($cXMLDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
		<xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
			<D_623>
				<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
			</D_623>
		</xsl:if>
	</xsl:template>

	<xsl:template name="TextLoop">
		<xsl:param name="Desc"/>
		<xsl:param name="StrLen"/>
		<xsl:param name="Pos"/>
		<xsl:param name="CurrentEndPos"/>
		<xsl:variable name="Length" select="$Pos + 80"/>

		<S_NTE>
			<D_363>GEN</D_363>
			<D_352>
				<xsl:value-of select="substring(normalize-space($Desc), $Pos, 80)"/>
			</D_352>
		</S_NTE>
		<xsl:if test="$Length &lt; $StrLen">
			<xsl:call-template name="TextLoop">
				<xsl:with-param name="Pos" select="$Length"/>
				<xsl:with-param name="Desc" select="$Desc"/>
				<xsl:with-param name="StrLen" select="$StrLen"/>
				<xsl:with-param name="CurrentEndPos" select="$Pos"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="createN1_NoGroup">
		<xsl:param name="party"/>
		<xsl:param name="role"/>

		<S_N1>
			<D_98>
				<xsl:value-of select="$role"/>
			</D_98>
			<D_93>
				<xsl:choose>
					<xsl:when test="$party/Name != ''">
						<xsl:value-of select="substring(normalize-space($party/Name), 1, 60)"/>
					</xsl:when>
					<xsl:otherwise>Not Available</xsl:otherwise>
				</xsl:choose>
			</D_93>
			<xsl:variable name="addrDomain" select="$party/@addressIDDomain"/>
			<!-- CG -->
			<xsl:if test="string-length($party/@addressID) &gt; 1">
				<D_66>
					<xsl:choose>
						<xsl:when test="$addrDomain = ''">92</xsl:when>
						<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code != ''">
							<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code"/>
						</xsl:when>
						<xsl:otherwise>92</xsl:otherwise>
					</xsl:choose>
				</D_66>
				<D_67>
					<xsl:value-of select="substring(normalize-space($party/@addressID), 1, 80)"/>
				</D_67>
			</xsl:if>
		</S_N1>

		<xsl:call-template name="createN2N3N4_FromAddress">
			<xsl:with-param name="address" select="$party/PostalAddress"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
