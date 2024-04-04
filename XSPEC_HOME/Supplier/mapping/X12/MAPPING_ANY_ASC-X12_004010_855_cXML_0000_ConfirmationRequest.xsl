<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:855:004010" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<!--		Description: map to transform X12 855 to cXML OrderConfirmation.		Date: 12/18/2015		Created: Ramachandra Motati.		Version: 1.0	-->
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="cXMLAttachments"/>
	<xsl:param name="attachSeparator" select="'\|'"/>
	<!--xsl:param name="anAllDetailOCFlag"/> removed as part of IG-19120 -->
	<!-- used for allDetail logic -->
	<xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
   <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>-->
	
	<!-- for dynamic, reading from Partner Directory -->
	<!--xsl:variable name="lookups" select="document('cXML_EDILookups_X12.xml')"/-->
	
	<!-- CG: IG-16765 - 1500 Extrinsics -->
	<xsl:variable name="mappingLookup">
		<xsl:call-template name="getLookupValues">
			<xsl:with-param name="cXMLDocType" select="'ConfirmationRequest'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="useExtrinsicsLookup">
		<xsl:choose>
			<xsl:when test="$mappingLookup/MappingLookup/EnableStandardExtrinsics != ''">
				<xsl:value-of select="lower-case($mappingLookup/MappingLookup/EnableStandardExtrinsics)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'no'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="incoterms"
		select="tokenize('cfr,cif,cip,cpt,daf,ddp,ddu,deq,des,exw,fas,fca,fob', ',')"/>
	<xsl:template match="*">
		<xsl:element name="cXML">
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<xsl:attribute name="timestamp">
				<xsl:call-template name="convertToAribaDate">
					<xsl:with-param name="Date">
						<xsl:value-of
							select="substring(replace(string(current-dateTime()), '-', ''), 1, 8)"/>
					</xsl:with-param>
					<xsl:with-param name="Time">
						<xsl:value-of
							select="substring(replace(replace(string(current-dateTime()), '-', ''), ':', ''), 10, 6)"
						/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:element name="Header">
				<xsl:element name="From">
					<xsl:element name="Credential">
						<xsl:attribute name="domain">NetworkID</xsl:attribute>
						<xsl:element name="Identity">
							<xsl:value-of select="$anSupplierANID"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="To">
					<xsl:element name="Credential">
						<xsl:attribute name="domain">NetworkID</xsl:attribute>
						<xsl:element name="Identity">
							<xsl:value-of select="$anBuyerANID"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="Sender">
					<xsl:element name="Credential">
						<xsl:attribute name="domain">NetworkID</xsl:attribute>
						<xsl:element name="Identity">
							<xsl:value-of select="$anProviderANID"/>
						</xsl:element>
						<xsl:element name="SharedSecret">
							<xsl:value-of select="$anSharedSecrete"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="UserAgent">
						<xsl:value-of select="'Ariba Supplier'"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="Request">
				<xsl:choose>
					<xsl:when test="$anEnvName = 'PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:element name="ConfirmationRequest">
					<xsl:variable name="hdrCurrency"
						select="FunctionalGroup/M_855/S_CUR[D_98_1 = 'BY']/D_100_1"/>
					<xsl:element name="ConfirmationHeader">
						<xsl:if test="FunctionalGroup/M_855/S_BAK/D_127">
							<xsl:attribute name="confirmID">
								<xsl:value-of select="FunctionalGroup/M_855/S_BAK/D_127"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="operation">
							<xsl:choose>
								<xsl:when test="FunctionalGroup/M_855/S_BAK/D_353 = '00'">
									<xsl:text>new</xsl:text>
								</xsl:when>
								<xsl:when test="FunctionalGroup/M_855/S_BAK/D_353 = '05'">
									<xsl:text>update</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<!-- CG: IG-19120 - Remove mapAllDetail reference -->
						<xsl:attribute name="type">
							<xsl:choose>
								<xsl:when test="FunctionalGroup/M_855/S_BAK/D_587 = 'AC'">
									<xsl:text>detail</xsl:text>
								</xsl:when>
								<xsl:when test="FunctionalGroup/M_855/S_BAK/D_587 = 'AE'">
									<xsl:text>except</xsl:text>
								</xsl:when>
								<xsl:when test="FunctionalGroup/M_855/S_BAK/D_587 = 'AT'">
									<xsl:text>accept</xsl:text>
								</xsl:when>
								<xsl:when test="FunctionalGroup/M_855/S_BAK/D_587 = 'RJ'">
									<xsl:text>reject</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="noticeDate">
							<xsl:choose>
								<xsl:when
									test="FunctionalGroup/M_855/S_DTM[D_374 = 'ACK']/D_373 != ''">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="Date"
											select="FunctionalGroup/M_855/S_DTM[D_374 = 'ACK']/D_373"/>
										<xsl:with-param name="Time"
											select="FunctionalGroup/M_855/S_DTM[D_374 = 'ACK']/D_337"/>
										<xsl:with-param name="TimeCode"
											select="FunctionalGroup/M_855/S_DTM[D_374 = 'ACK']/D_623"
										/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="FunctionalGroup/M_855/S_BAK/D_373_2 != ''">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="Date">
											<xsl:value-of
												select="FunctionalGroup/M_855/S_BAK/D_373_2"/>
										</xsl:with-param>
										<xsl:with-param name="Time">
											<xsl:value-of select="'1200'"/>
										</xsl:with-param>
										<xsl:with-param name="TimeCode"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="FunctionalGroup/M_855/S_REF[D_128 = 'IV']/D_127 != ''">
							<xsl:attribute name="invoiceID">
								<xsl:value-of
									select="FunctionalGroup/M_855/S_REF[D_128 = 'IV']/D_127"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if
							test="FunctionalGroup/M_855/S_FOB[D_146 = 'DE' and D_334 = '01']/D_335 != ''">
							<xsl:attribute name="incoTerms">
								<xsl:variable name="IncoVal"
									select="lower-case(FunctionalGroup/M_855/S_FOB[D_146 = 'DE' and D_334 = '01']/D_335)"/>
								<xsl:if test="$IncoVal = $incoterms">
									<xsl:attribute name="incoTerms">
										<xsl:value-of select="$IncoVal"/>
									</xsl:attribute>
								</xsl:if>
							</xsl:attribute>
						</xsl:if>
						<!--xsl:if test="FunctionalGroup/M_855/S_REF[D_128 = 'F8' and D_127 = 'payloadID']/D_352 != ''"-->
						<xsl:if test="FunctionalGroup/M_855/S_BAK/D_353 = '05'">
							<xsl:element name="DocumentReference">
								<xsl:attribute name="payloadID"/>
							</xsl:element>
						</xsl:if>
						<xsl:if
							test="FunctionalGroup/M_855/G_CTT/S_AMT[D_522 = 'TT']/D_782 != '' and FunctionalGroup/M_855/S_CUR[D_98_1 = 'BY']/D_100_1 != ''">
							<xsl:element name="Total">
								<xsl:element name="Money">
									<xsl:attribute name="currency">
										<xsl:value-of select="$hdrCurrency"/>
									</xsl:attribute>
									<xsl:value-of
										select="FunctionalGroup/M_855/G_CTT/S_AMT[D_522 = 'TT']/D_782"
									/>
								</xsl:element>
								<xsl:if
									test="exists(FunctionalGroup/M_855/G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840'])">
									<xsl:element name="Modifications">
										<xsl:for-each
											select="FunctionalGroup/M_855/G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840']">
											<xsl:variable name="modCode">
												<xsl:value-of select="S_SAC/D_1300"/>
											</xsl:variable>
											<xsl:variable name="curr"
												select="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1"/>
											<xsl:element name="Modification">
												<xsl:if test="S_SAC/D_127 != ''">
												<xsl:element name="OriginalPrice">
												<xsl:if test="S_SAC/D_770 != ''">
												<xsl:attribute name="type" select="S_SAC/D_770"/>
												</xsl:if>
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="S_SAC/D_127"/>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:choose>
												<xsl:when test="S_SAC/D_248 = 'A'">
												<xsl:element name="AdditionalDeduction">
												<xsl:choose>
												<xsl:when
												test="S_SAC/D_331 = '13' and S_SAC/D_610 != ''">
												<xsl:element name="DeductionAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:element>
												</xsl:when>
												<xsl:when test="S_SAC/D_610 != ''">
												<xsl:element name="DeductedPrice">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:element>
												</xsl:when>
												<xsl:when
												test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
												<xsl:element name="DeductionPercent">
												<xsl:attribute name="percent">
												<xsl:value-of select="S_SAC/D_332"/>
												</xsl:attribute>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												</xsl:element>
												</xsl:when>
												<xsl:when test="S_SAC/D_248 = 'C'">
												<xsl:element name="AdditionalCost">
												<xsl:choose>
												<xsl:when test="S_SAC/D_610 != ''">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:when>
												<xsl:when
												test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
												<xsl:element name="Percentage">
												<xsl:attribute name="percent">
												<xsl:value-of select="S_SAC/D_332"/>
												</xsl:attribute>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												<xsl:if
												test="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode != ''">
												<xsl:element name="ModificationDetail">
												<xsl:attribute name="name">
												<xsl:value-of
												select="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode"
												/>
												</xsl:attribute>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_373_1">
												<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_373_1"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_337_1"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_373_1">
												<xsl:attribute name="endDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_373_1"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_337_1"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_2 = '196']/D_373_2">
												<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_2 = 'BY'][D_374_2 = '196']/D_373_2"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_2 = 'BY'][D_374_2 = '196']/D_337_2"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_373_2">
												<xsl:attribute name="endDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_373_2"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_337_2"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if test="S_SAC/D_352 != ''">
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when test="S_SAC/D_819 != ''">
												<xsl:value-of select="S_SAC/D_819"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:value-of select="S_SAC/D_352"/>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:if
							test="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 != '' and FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_352 != ''">
							<xsl:element name="Shipping">
								<xsl:if
									test="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_127 != ''">
									<xsl:attribute name="trackingId">
										<xsl:value-of
											select="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_127"
										/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if
									test="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_770 != ''">
									<xsl:attribute name="trackingDomain">
										<xsl:value-of
											select="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_770"
										/>
									</xsl:attribute>
								</xsl:if>
								<xsl:element name="Money">
									<xsl:attribute name="currency">
										<xsl:value-of
											select="FunctionalGroup/M_855/G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'G830']/S_CUR[D_98_1 = 'BY']/D_100_1"
										/>
									</xsl:attribute>
									<xsl:value-of
										select="(FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_610 div 100)"
									/>
								</xsl:element>
								<xsl:element name="Description">
									<xsl:attribute name="xml:lang">
										<xsl:choose>
											<xsl:when
												test="FunctionalGroup/M_855/G_N9/S_N9[D_128 = 'L1' and D_369 = 'shipping']/D_127 != ''">
												<xsl:value-of
												select="FunctionalGroup/M_855/G_N9/S_N9[D_128 = 'L1' and D_369 = 'shipping'][1]/D_127"
												/>
											</xsl:when>
											<xsl:when
												test="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_819 != ''">
												<xsl:value-of
												select="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_819"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>en</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when
											test="FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'shipping']/S_MSG/D_933 != ''">
											<xsl:for-each
												select="FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'shipping']/S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of
												select="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_352"
											/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if
							test="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_610 != ''">
							<xsl:element name="Tax">
								<xsl:element name="Money">
									<xsl:attribute name="currency">
										<xsl:value-of
											select="FunctionalGroup/M_855/G_SAC[S_SAC/D_248 = 'C' and S_SAC/D_1300 = 'H850']/S_CUR[D_98_1 = 'BY']/D_100_1"
										/>
									</xsl:attribute>
									<xsl:value-of
										select="(FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610 div 100)"
									/>
								</xsl:element>
								<xsl:element name="Description">
									<xsl:attribute name="xml:lang">
										<xsl:choose>
											<xsl:when
												test="FunctionalGroup/M_855/G_N9/S_N9[D_128 = 'L1' and D_369 = 'tax']/D_127 != ''">
												<xsl:value-of select="D_127[1]"/>
											</xsl:when>
											<xsl:when
												test="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_819 != ''">
												<xsl:value-of
												select="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_819"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>en</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when
											test="FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'tax']/S_MSG/D_933 != ''">
											<xsl:for-each
												select="FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'tax']/S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of
												select="FunctionalGroup/M_855/G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_352"
											/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
								<xsl:for-each select="FunctionalGroup/M_855/S_TXI">
									<xsl:variable name="taxCat" select="D_963"/>
									<xsl:if
										test="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/CXMLCode != ''">
										<xsl:element name="TaxDetail">
											<xsl:if test="D_954 != ''">
												<xsl:attribute name="percentageRate">
												<xsl:value-of select="D_954"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="category">
												<xsl:value-of
												select="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/CXMLCode"
												/>
											</xsl:attribute>
											<xsl:attribute name="purpose">
												<xsl:text>tax</xsl:text>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="D_441 = '0'">
												<xsl:attribute name="exemptDetail">
												<xsl:text>zeroRated</xsl:text>
												</xsl:attribute>
												</xsl:when>
												<xsl:when test="D_441 = '2'">
												<xsl:attribute name="exemptDetail">
												<xsl:text>exempt</xsl:text>
												</xsl:attribute>
												</xsl:when>
											</xsl:choose>
											<xsl:if test="D_828 != ''">
												<xsl:element name="TaxableAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$hdrCurrency"/>
												</xsl:attribute>
												<xsl:value-of select="D_828"/>
												</xsl:element>
												</xsl:element>
											</xsl:if>
											<xsl:if test="D_782 != ''">
												<xsl:element name="TaxAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$hdrCurrency"/>
												</xsl:attribute>
												<xsl:value-of select="D_782"/>
												</xsl:element>
												</xsl:element>
											</xsl:if>
											<xsl:if test="D_955 = 'VD' and D_956 != ''">
												<xsl:element name="TaxLocation">
												<xsl:attribute name="xml:lang" select="'en'"/>
												<xsl:value-of select="D_956"/>
												</xsl:element>
											</xsl:if>
											<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:text>en</xsl:text>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="$taxCat = 'ZZ' and D_350 != ''">
												<xsl:value-of select="D_350"/>
												</xsl:when>
												<xsl:when
												test="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/Description != ''">
												<xsl:value-of
												select="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/Description"
												/>
												</xsl:when>
												<xsl:otherwise>Default tax
												description</xsl:otherwise>
												</xsl:choose>
											</xsl:element>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<xsl:for-each select="FunctionalGroup/M_855/G_N1">
							<xsl:call-template name="createContact">
								<xsl:with-param name="contact" select="."/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each
							select="FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'L1' and lower-case(S_N9/D_369) = 'comments']">
							<xsl:element name="Comments">
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="S_N9/D_127 != ''">
											<xsl:value-of select="S_N9/D_127[1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>en</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:for-each select="S_MSG">
									<xsl:choose>
										<xsl:when test="D_934 = 'LC'">
											<xsl:value-of select="D_933"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat(nl, D_933)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								<xsl:if test="$cXMLAttachments != ''">
									<xsl:variable name="tokenizedAttachments"
										select="tokenize($cXMLAttachments, $attachSeparator)"/>
									<xsl:for-each select="$tokenizedAttachments">
										<xsl:if test="normalize-space(.) != ''">
											<Attachment>
												<URL>
												<xsl:value-of select="."/>
												</URL>
											</Attachment>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</xsl:element>
						</xsl:for-each>
					   <xsl:if test="FunctionalGroup/M_855/S_REF[D_128 = 'CR']/D_127">
					      <xsl:element name="IdReference">
					         <xsl:attribute name="identifier">
					            <xsl:value-of select="FunctionalGroup/M_855/S_REF[D_128 = 'CR']/D_127"/>
					         </xsl:attribute>
					         <xsl:attribute name="domain">
					            <xsl:text>CustomerReferenceID</xsl:text>
					         </xsl:attribute>
					      </xsl:element>
                  </xsl:if>
						<xsl:if test="FunctionalGroup/M_855/S_REF[D_128 = 'D2']/D_127">
							<xsl:element name="IdReference">
								<xsl:attribute name="identifier">
									<xsl:value-of select="FunctionalGroup/M_855/S_REF[D_128 = 'D2']/D_127"/>
								</xsl:attribute>
								<xsl:attribute name="domain">
									<xsl:text>supplierReference</xsl:text>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					   <xsl:if test="FunctionalGroup/M_855/S_REF[D_128 = 'ZB']/D_127">
					      <xsl:element name="IdReference">
					         <xsl:attribute name="identifier">
					            <xsl:value-of select="FunctionalGroup/M_855/S_REF[D_128 = 'ZB']/D_127"/>
					         </xsl:attribute>
					         <xsl:attribute name="domain">
					            <xsl:text>UltimateCustomerReferenceID</xsl:text>
					         </xsl:attribute>
					      </xsl:element>
					   </xsl:if>
                  
                  <!-- IG-8547 CG: Logic to map extrinsics only when name is sent -->
						<xsl:for-each
							select="FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'ZZ'][S_N9/D_127 != '' and lower-case(S_N9/D_127) != 'alldetail']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:value-of select="S_N9/D_127"/>
								</xsl:attribute>
								<!-- IG-8547 CG: As per specs 369 and MSG would contain same information, we should map from MSG when sent -->
								<xsl:choose>
									<xsl:when test="not(exists(S_MSG))">
										<xsl:value-of select="S_N9/D_369"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="S_MSG">
											<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="FunctionalGroup/M_855/S_REF[D_128 = 'ZZ']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:value-of select="D_127"/>
								</xsl:attribute>
								<xsl:value-of select="D_352"/>
							</xsl:element>
						</xsl:for-each>
						<!-- CG: IG-16765 - 1500 Extrinsics -->
						<xsl:if test="$useExtrinsicsLookup = 'yes'">
							<xsl:for-each select="FunctionalGroup/M_855/S_REF[D_128 != 'ZZ']">
								<xsl:variable name="refQualVal" select="D_128"/>
								<xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/ConfReqHeaderEx))][1]/CXMLCode"/>
								<xsl:if test="$extNameL != ''">
									<xsl:element name="Extrinsic">
										<xsl:attribute name="name">
											<xsl:value-of select="$extNameL"/>
										</xsl:attribute>
										<xsl:value-of select="concat(D_127,D_352)"/>
									</xsl:element>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
						<!-- IG-8547 CG: Map rejection reason only when type is reject -->
						<xsl:if
							test="(FunctionalGroup/M_855/S_BAK/D_587 = 'RJ') and FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'L1'][lower-case(S_N9/D_369) = 'rejectionreason']/S_MSG/D_933 != ''">
							<xsl:variable name="rejreason"
								select="FunctionalGroup/M_855/G_N9[S_N9/D_128 = 'L1'][lower-case(S_N9/D_369) = 'rejectionreason']/S_MSG/D_933"/>
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:value-of select="'RejectionReasonComments'"/>
								</xsl:attribute>
								<xsl:value-of select="$rejreason"/>
							</xsl:element>
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:value-of select="'RejectionReason'"/>
								</xsl:attribute>
								<xsl:choose>
									<xsl:when
										test="$Lookup/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(X12Code, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode != ''">
										<xsl:value-of
											select="$Lookup/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(X12Code, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>other</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:if>
					</xsl:element>
					<!-- End of Confirmation Header -->
					<xsl:element name="OrderReference">
						<xsl:variable name="chkOrderDate">
							<xsl:choose>
								<xsl:when
									test="FunctionalGroup/M_855/S_DTM[D_374 = '004']/D_373 != ''">
									<xsl:call-template name="convertToAribaDatePORef">
										<xsl:with-param name="Date"
											select="FunctionalGroup/M_855/S_DTM[D_374 = '004']/D_373"/>
										<xsl:with-param name="Time"
											select="FunctionalGroup/M_855/S_DTM[D_374 = '004']/D_337"/>
										<xsl:with-param name="TimeCode"
											select="FunctionalGroup/M_855/S_DTM[D_374 = '004']/D_623"
										/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="convertToAribaDatePORef">
										<xsl:with-param name="Date"
											select="FunctionalGroup/M_855/S_BAK/D_373_1"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="$chkOrderDate != ''">
							<xsl:attribute name="orderDate">
								<xsl:value-of select="$chkOrderDate"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="orderID">
							<xsl:choose>
								<xsl:when
									test="FunctionalGroup/M_855/S_REF[D_128 = 'ON']/D_127 != ''">
									<xsl:value-of
										select="FunctionalGroup/M_855/S_REF[D_128 = 'ON']/D_127"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="FunctionalGroup/M_855/S_BAK/D_324"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:element name="DocumentReference">
							<xsl:attribute name="payloadID">
								<xsl:text/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<!-- End of OrderReference -->
					<!-- Line Level Mapping -->
					<!-- IG-19120 remove mapAllDetail reference -->
					<xsl:if
						test="FunctionalGroup/M_855/S_BAK/D_587 != 'RJ'">
						<xsl:for-each select="FunctionalGroup/M_855/G_PO1">
							<xsl:variable name="lineCurr">
								<xsl:choose>
									<xsl:when
										test="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1 != ''">
										<xsl:value-of
											select="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$hdrCurrency"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="ConfirmationItem">
								<xsl:attribute name="quantity">
									<xsl:value-of select="S_PO1/D_330"/>
								</xsl:attribute>
								<xsl:attribute name="lineNumber">
									<xsl:value-of select="S_PO1/D_350"/>
								</xsl:attribute>
								<xsl:if test="S_REF[D_128 = 'FL']/D_127 != ''">
									<xsl:attribute name="parentLineNumber">
										<xsl:value-of select="S_REF[D_128 = 'FL']/D_127"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="S_REF[D_128 = 'FL']/D_352 != ''">
									<xsl:attribute name="itemType">
										<xsl:value-of select="lower-case(S_REF[D_128 = 'FL']/D_352)"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:element name="UnitOfMeasure">
									<xsl:variable name="uomcode" select="S_PO1/D_355"/>
								   <xsl:choose>
								      <xsl:when
								         test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode != ''">
								         <xsl:value-of
								            select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode"
								         />
								      </xsl:when>
								      <xsl:otherwise>ZZ</xsl:otherwise>
								   </xsl:choose>
								</xsl:element>
								<xsl:for-each select="G_N1">
									<xsl:call-template name="createContact">
										<xsl:with-param name="contact" select="."/>
									</xsl:call-template>
								</xsl:for-each>
								<xsl:variable name="ackQty" select="sum(G_ACK/S_ACK/D_380)"/>
								<xsl:variable name="unkQty" select="S_PO1/D_330 - $ackQty"/>
								<xsl:variable name="ACKCount">									
									<xsl:value-of select="count(G_ACK)"/>
								</xsl:variable>
								<xsl:for-each select="G_ACK">
									<xsl:if
										test="S_ACK/D_668 = 'IA' or S_ACK/D_668 = 'IB' or S_ACK/D_668 = 'IR' or S_ACK/D_668 = 'IC'">
										<xsl:variable name="ack">
											<xsl:call-template name="createACK">
												<xsl:with-param name="ACK" select="S_ACK"/>
											</xsl:call-template>
										</xsl:variable>
										<!-- IG-19120 remove mapAllDetail reference -->
										<xsl:element name="ConfirmationStatus">
											<xsl:attribute name="type">
												<xsl:choose>
													<xsl:when test="S_ACK/D_668 = 'IA'">
														<xsl:text>accept</xsl:text>
													</xsl:when>
													<xsl:when test="S_ACK/D_668 = 'IB'">
														<xsl:text>backordered</xsl:text>
													</xsl:when>
													<xsl:when test="S_ACK/D_668 = 'IR'">
														<xsl:text>reject</xsl:text>
													</xsl:when>
													<xsl:when
														test="S_ACK/D_668 = 'IC'">
														<xsl:text>detail</xsl:text>
													</xsl:when>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="quantity">
												<xsl:value-of select="S_ACK/D_380"/>
											</xsl:attribute>
											<xsl:if test="S_ACK/D_373 != '' and S_ACK/D_374 = '068'">
												<xsl:attribute name="shipmentDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date" select="S_ACK/D_373"/>
												<xsl:with-param name="Time" select="'120000'"/>
												</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test="S_DTM[D_374 = '017']/D_373 != ''">
												<xsl:attribute name="deliveryDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_DTM[D_374 = '017']/D_373"/>
												<xsl:with-param name="Time"
												select="S_DTM[D_374 = '017']/D_337"/>
												<xsl:with-param name="TimeCode"
												select="S_DTM[D_374 = '017']/D_623"/>
												</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:element name="UnitOfMeasure">
												<xsl:variable name="uomcode" select="S_ACK/D_355"/>
												<xsl:choose>
												<xsl:when
												test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode != ''">
												<xsl:value-of
												select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode"
												/>
												</xsl:when>
												<xsl:otherwise>ZZ</xsl:otherwise>
												</xsl:choose>
											</xsl:element>
											<!-- CG: IG-19120 - Remove mapAllDetail reference -->
											<xsl:choose>
												<xsl:when
												test="(S_ACK/D_668 = 'IC' and ../S_CTP[D_236 = 'CUP']/D_212 != '')">
												<xsl:element name="ItemIn">
												<xsl:attribute name="quantity">
												<xsl:value-of
												select="format-number(S_ACK/D_380, '0.##')"/>
												</xsl:attribute>
												<xsl:attribute name="lineNumber">
												<xsl:value-of select="../S_PO1/D_350"/>
												</xsl:attribute>
												<xsl:element name="ItemID">
												<xsl:element name="SupplierPartID">
												<xsl:value-of
												select="$ack/ack/element[@name = 'VP']/@value"/>
												</xsl:element>
												<xsl:if
												test="$ack/ack/element[@name = 'VS']/@value != ''">
												<xsl:element name="SupplierPartAuxiliaryID">
												<xsl:value-of
												select="$ack/ack/element[@name = 'VS']/@value"/>
												</xsl:element>
												</xsl:if>
												<xsl:if
												test="$ack/ack/element[@name = 'BP']/@value != ''">
												<xsl:element name="BuyerPartID">
												<xsl:value-of
												select="$ack/ack/element[@name = 'BP']/@value"/>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												<xsl:element name="ItemDetail">
												<xsl:element name="UnitPrice">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$lineCurr"/>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when
												test="../S_CTP[D_236 = 'CUP']/D_212 != ''">
												<xsl:value-of
												select="../S_CTP[D_236 = 'CUP']/D_212"/>
												</xsl:when>
												<xsl:when
												test="../S_CTP[D_236 = 'CHG']/D_212 != ''">
												<xsl:value-of
												select="../S_CTP[D_236 = 'CHG']/D_212"/>
												</xsl:when>
												</xsl:choose>
												</xsl:element>
												<xsl:if
												test="exists(../G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840'])">
												<xsl:element name="Modifications">
												<xsl:for-each
												select="../G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840']">
												<xsl:variable name="modCode">
												<xsl:value-of select="S_SAC/D_1300"/>
												</xsl:variable>
												<xsl:variable name="curr"
												select="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1"/>
												<xsl:element name="Modification">
												<xsl:if test="S_SAC/D_127 != ''">
												<xsl:element name="OriginalPrice">
												<xsl:if test="S_SAC/D_770 != ''">
												<xsl:attribute name="type" select="S_SAC/D_770"/>
												</xsl:if>
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="S_SAC/D_127"/>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:choose>
												<xsl:when test="S_SAC/D_248 = 'A'">
												<xsl:element name="AdditionalDeduction">
												<xsl:choose>
												<xsl:when
												test="S_SAC/D_331 = '13' and S_SAC/D_610 != ''">
												<xsl:element name="DeductionAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:element>
												</xsl:when>
												<xsl:when test="S_SAC/D_610 != ''">
												<xsl:element name="DeductedPrice">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:element>
												</xsl:when>
												<xsl:when
												test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
												<xsl:element name="DeductionPercent">
												<xsl:attribute name="percent">
												<xsl:value-of select="S_SAC/D_332"/>
												</xsl:attribute>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												</xsl:element>
												</xsl:when>
												<xsl:when test="S_SAC/D_248 = 'C'">
												<xsl:element name="AdditionalCost">
												<xsl:choose>
												<xsl:when test="S_SAC/D_610 != ''">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:when>
												<xsl:when
												test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
												<xsl:element name="Percentage">
												<xsl:attribute name="percent">
												<xsl:value-of select="S_SAC/D_332"/>
												</xsl:attribute>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												<xsl:if
												test="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode != ''">
												<xsl:element name="ModificationDetail">
												<xsl:attribute name="name">
												<xsl:value-of
												select="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode"
												/>
												</xsl:attribute>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_373_1">
												<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_373_1"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_337_1"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_373_1">
												<xsl:attribute name="endDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_373_1"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_337_1"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_2 = '196']/D_373_2">
												<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_2 = 'BY'][D_374_2 = '196']/D_373_2"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_2 = 'BY'][D_374_2 = '196']/D_337_2"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_373_2">
												<xsl:attribute name="endDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_373_2"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_337_2"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if test="S_SAC/D_352 != ''">
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when test="S_SAC/D_819 != ''">
												<xsl:value-of select="S_SAC/D_819"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:value-of select="S_SAC/D_352"/>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												</xsl:for-each>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												<xsl:if
												test="../G_PID/S_PID[D_349 = 'F']/D_352 != '' or $ack/ack/element[@name = 'PD']/@value != ''">
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when
												test="../G_PID/S_PID[D_349 = 'F']/D_819 != ''">
												<xsl:value-of
												select="(../G_PID/S_PID[D_349 = 'F']/D_819)[1]"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:if
												test="../G_PID/S_PID[D_349 = 'F'][D_750 = 'GEN']/D_352 != ''">
												<xsl:element name="ShortName">
												<xsl:for-each
												select="../G_PID[S_PID/D_349 = 'F'][S_PID/D_750 = 'GEN']">
												<xsl:value-of select="S_PID/D_352"/>
												</xsl:for-each>
												</xsl:element>
												</xsl:if>
												<xsl:choose>
												<xsl:when
												test="$ack/ack/element[@name = 'PD']/@value != ''">
												<xsl:value-of
												select="$ack/ack/element[@name = 'PD']/@value"/>
												</xsl:when>
												<xsl:when
												test="../G_PID/S_PID[D_349 = 'F'][D_750 != 'GEN' or empty(D_750)]/D_352 != ''">
												<xsl:for-each
												select="../G_PID[S_PID/D_349 = 'F'][S_PID/D_750 != 'GEN' or empty(S_PID/D_750)]">
												<xsl:value-of select="S_PID/D_352"/>
												</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>Item Description Not
												Provided</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												</xsl:if>
												<xsl:element name="UnitOfMeasure">
												<xsl:variable name="uomcode" select="S_ACK/D_355"/>
												<xsl:choose>
												<xsl:when
												test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode != ''">
												<xsl:value-of
												select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode"
												/>
												</xsl:when>
												<xsl:otherwise>ZZ</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												<xsl:if
												test="../S_CTP[D_687 = 'WS']/D_380 != '' and ../S_CTP[D_687 = 'WS'][D_648 = 'CSD']/D_649 != '' and ../S_CTP[D_687 = 'WS']/C_C001/D_355_1">
												<xsl:element name="PriceBasisQuantity">
												<xsl:attribute name="quantity">
												<xsl:value-of
												select="format-number(../S_CTP[D_687 = 'WS']/D_380, '0.##')"
												/>
												</xsl:attribute>
												<xsl:attribute name="conversionFactor">
												<xsl:value-of
												select="../S_CTP[D_687 = 'WS'][D_648 = 'CSD']/D_649"
												/>
												</xsl:attribute>
												<xsl:element name="UnitOfMeasure">
												<xsl:variable name="uomcode"
												select="../S_CTP[D_687 = 'WS']/C_C001/D_355_1"/>
												<xsl:choose>
												<xsl:when
												test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode != ''">
												<xsl:value-of
												select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode"
												/>
												</xsl:when>
												<xsl:otherwise>ZZ</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:element name="Classification">
												<xsl:attribute name="domain"
												>UNSPSC</xsl:attribute>
												<xsl:attribute name="code">
												<xsl:value-of
												select="$ack/ack/element[@name = 'C3']/@value"/>
												</xsl:attribute>
												</xsl:element>
												<xsl:if
												test="$ack/ack/element[@name = 'MG']/@value != ''">
												<xsl:element name="ManufacturerPartID">
												<xsl:value-of
												select="$ack/ack/element[@name = 'MG']/@value"/>
												</xsl:element>
												</xsl:if>
												<xsl:if
												test="$ack/ack/element[@name = 'MF']/@value != ''">
												<xsl:element name="ManufacturerName">
												<xsl:value-of
												select="$ack/ack/element[@name = 'MF']/@value"/>
												</xsl:element>
												</xsl:if>
                                    <xsl:for-each select="../S_MEA[D_737='PD']">
                                       <xsl:variable name="uomcode"
                                          select="C_C001/D_355_1"/>
                                       <xsl:variable name="meaType" select="D_738"/>   
												   <xsl:element name="Dimension">
												      <xsl:attribute name="quantity">
												         <xsl:value-of select="D_739"/>
												      </xsl:attribute>
												      <xsl:if test="$Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $meaType]/CXMLCode != ''">
												         <xsl:attribute name="type"><xsl:value-of select="normalize-space($Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $meaType]/CXMLCode)"/></xsl:attribute>
												      </xsl:if>
												      <xsl:element name="UnitOfMeasure">
												         <xsl:choose>
												            <xsl:when
												               test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode != ''">
												               <xsl:value-of
												                  select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode)"
												               />
												            </xsl:when>
												            <xsl:otherwise>ZZ</xsl:otherwise>
												         </xsl:choose>
												      </xsl:element>
												   </xsl:element>
                                    </xsl:for-each>
												<xsl:if
												test="$ack/ack/element[@name = 'UP']/@value != ''">
												<xsl:element name="Extrinsic">
												<xsl:attribute name="name" select="'UPCID'"/>
												<xsl:value-of
												select="$ack/ack/element[@name = 'UP']/@value"/>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												<!-- Shipping -->
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 != '' and ../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_352 != ''">
												<xsl:element name="Shipping">
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_127 != ''">
												<xsl:attribute name="trackingId">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_127"
												/>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_770 != ''">
												<xsl:attribute name="trackingDomain">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_770"
												/>
												</xsl:attribute>
												</xsl:if>
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of
												select="../G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'G830']/S_CUR[D_98_1 = 'BY']/D_100_1"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="(../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_610 div 100)"
												/>
												</xsl:element>
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when
												test="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'shipping']/D_127 != ''">
												<xsl:value-of
												select="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'shipping'][1]/D_127"
												/>
												</xsl:when>
												<xsl:when
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_819 != ''">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_819"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:text>en</xsl:text>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when
												test="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'shipping']/S_MSG/D_933 != ''">
												<xsl:for-each
												select="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'shipping']/S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_352"
												/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<!-- Tax -->
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_610 != ''">
												<xsl:element name="Tax">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of
												select="../G_SAC[S_SAC/D_248 = 'C' and S_SAC/D_1300 = 'H850']/S_CUR[D_98_1 = 'BY']/D_100_1"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="(../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610 div 100)"
												/>
												</xsl:element>
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when
												test="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'tax'][1]/D_127 != ''">
												<xsl:value-of
												select="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'tax'][1]/D_127"
												/>
												</xsl:when>
												<xsl:when
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_819 != ''">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_819"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:text>en</xsl:text>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when
												test="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'tax']/S_MSG/D_933 != ''">
												<xsl:for-each
												select="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'tax']/S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_352"
												/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												<xsl:for-each select="../S_TXI">
												<xsl:variable name="taxCat" select="D_963"/>
												<xsl:if
												test="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/CXMLCode != ''">
												<xsl:element name="TaxDetail">
												<xsl:if test="D_954 != ''">
												<xsl:attribute name="percentageRate">
												<xsl:value-of select="D_954"/>
												</xsl:attribute>
												</xsl:if>
												<xsl:attribute name="category">
												<xsl:value-of
												select="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/CXMLCode"
												/>
												</xsl:attribute>
												<xsl:attribute name="purpose">
												<xsl:text>tax</xsl:text>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="D_441 = '0'">
												<xsl:attribute name="exemptDetail">
												<xsl:text>zeroRated</xsl:text>
												</xsl:attribute>
												</xsl:when>
												<xsl:when test="D_441 = '2'">
												<xsl:attribute name="exemptDetail">
												<xsl:text>exempt</xsl:text>
												</xsl:attribute>
												</xsl:when>
												</xsl:choose>
												<xsl:if test="D_828 != ''">
												<xsl:element name="TaxableAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$hdrCurrency"/>
												</xsl:attribute>
												<xsl:value-of select="D_828"/>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:if test="D_782 != ''">
												<xsl:element name="TaxAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$hdrCurrency"/>
												</xsl:attribute>
												<xsl:value-of select="D_782"/>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:if test="D_955 = 'VD' and D_956 != ''">
												<xsl:element name="TaxLocation">
												<xsl:attribute name="xml:lang" select="'en'"/>
												<xsl:value-of select="D_956"/>
												</xsl:element>
												</xsl:if>
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:text>en</xsl:text>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="$taxCat = 'ZZ' and D_350 != ''">
												<xsl:value-of select="D_350"/>
												</xsl:when>
												<xsl:when
												test="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/Description != ''">
												<xsl:value-of
												select="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/Description"
												/>
												</xsl:when>
												<xsl:otherwise>Default tax
												description</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												</xsl:for-each>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												</xsl:when>
												<xsl:when test="../S_CTP[D_236 = 'CHG']/D_212 != ''">
												<xsl:element name="UnitPrice">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$lineCurr"/>
												</xsl:attribute>
												<xsl:value-of
												select="../S_CTP[D_236 = 'CHG']/D_212"/>
												</xsl:element>
												<xsl:if
												test="exists(../G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840'])">
												<xsl:element name="Modifications">
												<xsl:for-each
												select="../G_SAC[S_SAC/D_1300 != 'C310' and S_SAC/D_1300 != 'G830' and S_SAC/D_1300 != 'H090' and S_SAC/D_1300 != 'H850' and S_SAC/D_1300 != 'B840']">
												<xsl:variable name="modCode">
												<xsl:value-of select="S_SAC/D_1300"/>
												</xsl:variable>
												<xsl:variable name="curr"
												select="S_CUR[D_98_1 = 'BY' or D_98_1 = 'SE']/D_100_1"/>
												<xsl:element name="Modification">
												<xsl:if test="S_SAC/D_127 != ''">
												<xsl:element name="OriginalPrice">
												<xsl:if test="S_SAC/D_770 != ''">
												<xsl:attribute name="type" select="S_SAC/D_770"/>
												</xsl:if>
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="S_SAC/D_127"/>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:choose>
												<xsl:when test="S_SAC/D_248 = 'A'">
												<xsl:element name="AdditionalDeduction">
												<xsl:choose>
												<xsl:when
												test="S_SAC/D_331 = '13' and S_SAC/D_610 != ''">
												<xsl:element name="DeductionAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:element>
												</xsl:when>
												<xsl:when test="S_SAC/D_610 != ''">
												<xsl:element name="DeductedPrice">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:element>
												</xsl:when>
												<xsl:when
												test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
												<xsl:element name="DeductionPercent">
												<xsl:attribute name="percent">
												<xsl:value-of select="S_SAC/D_332"/>
												</xsl:attribute>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												</xsl:element>
												</xsl:when>
												<xsl:when test="S_SAC/D_248 = 'C'">
												<xsl:element name="AdditionalCost">
												<xsl:choose>
												<xsl:when test="S_SAC/D_610 != ''">
												<xsl:element name="Money">
												<xsl:attribute name="currency" select="$curr"/>
												<xsl:value-of select="(S_SAC/D_610 div 100)"/>
												</xsl:element>
												</xsl:when>
												<xsl:when
												test="S_SAC/D_332 != '' and S_SAC/D_378 = '3'">
												<xsl:element name="Percentage">
												<xsl:attribute name="percent">
												<xsl:value-of select="S_SAC/D_332"/>
												</xsl:attribute>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												</xsl:element>
												</xsl:when>
												</xsl:choose>
												<xsl:if
												test="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode != ''">
												<xsl:element name="ModificationDetail">
												<xsl:attribute name="name">
												<xsl:value-of
												select="$Lookup/Lookups/Modifications/Modification[X12Code = $modCode]/CXMLCode"
												/>
												</xsl:attribute>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_373_1">
												<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_373_1"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '196']/D_337_1"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_373_1">
												<xsl:attribute name="endDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_373_1"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_1 = '197']/D_337_1"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_2 = '196']/D_373_2">
												<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_2 = 'BY'][D_374_2 = '196']/D_373_2"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_2 = 'BY'][D_374_2 = '196']/D_337_2"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_373_2">
												<xsl:attribute name="endDate">
												<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date"
												select="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_373_2"/>
												<xsl:with-param name="Time"
												select="S_CUR[D_98_1 = 'BY'][D_374_2 = '197']/D_337_2"/>
												<xsl:with-param name="TimeCode" select="''"/>
												</xsl:call-template>
												</xsl:attribute>
												</xsl:if>
												<xsl:if test="S_SAC/D_352 != ''">
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when test="S_SAC/D_819 != ''">
												<xsl:value-of select="S_SAC/D_819"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:value-of select="S_SAC/D_352"/>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												</xsl:for-each>
												</xsl:element>
												</xsl:if>
												</xsl:element>
												<!-- Tax -->
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_610 != ''">
												<xsl:element name="Tax">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of
												select="../G_SAC[S_SAC/D_248 = 'C' and S_SAC/D_1300 = 'H850']/S_CUR[D_98_1 = 'BY']/D_100_1"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="(../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'H850']/D_610 div 100)"
												/>
												</xsl:element>
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when
												test="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'tax'][1]/D_127 != ''">
												<xsl:value-of
												select="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'tax'][1]/D_127"
												/>
												</xsl:when>
												<xsl:when
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_819 != ''">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_819"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:text>en</xsl:text>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when
												test="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'tax']/S_MSG/D_933 != ''">
												<xsl:for-each
												select="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'tax']/S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'H850']/D_352"
												/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												<xsl:for-each select="../S_TXI">
												<xsl:variable name="taxCat" select="D_963"/>
												<xsl:if
												test="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/CXMLCode != ''">
												<xsl:element name="TaxDetail">
												<xsl:if test="D_954 != ''">
												<xsl:attribute name="percentageRate">
												<xsl:value-of select="D_954"/>
												</xsl:attribute>
												</xsl:if>
												<xsl:attribute name="category">
												<xsl:value-of
												select="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/CXMLCode"
												/>
												</xsl:attribute>
												<xsl:attribute name="purpose">
												<xsl:text>tax</xsl:text>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="D_441 = '0'">
												<xsl:attribute name="exemptDetail">
												<xsl:text>zeroRated</xsl:text>
												</xsl:attribute>
												</xsl:when>
												<xsl:when test="D_441 = '2'">
												<xsl:attribute name="exemptDetail">
												<xsl:text>exempt</xsl:text>
												</xsl:attribute>
												</xsl:when>
												</xsl:choose>
												<xsl:if test="D_828 != ''">
												<xsl:element name="TaxableAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$hdrCurrency"/>
												</xsl:attribute>
												<xsl:value-of select="D_828"/>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:if test="D_782 != ''">
												<xsl:element name="TaxAmount">
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of select="$hdrCurrency"/>
												</xsl:attribute>
												<xsl:value-of select="D_782"/>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												<xsl:if test="D_955 = 'VD' and D_956 != ''">
												<xsl:element name="TaxLocation">
												<xsl:attribute name="xml:lang" select="'en'"/>
												<xsl:value-of select="D_956"/>
												</xsl:element>
												</xsl:if>
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:text>en</xsl:text>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when test="$taxCat = 'ZZ' and D_350 != ''">
												<xsl:value-of select="D_350"/>
												</xsl:when>
												<xsl:when
												test="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/Description != ''">
												<xsl:value-of
												select="$Lookup/Lookups/TaxCodes/TaxCode[X12Code = $taxCat]/Description"
												/>
												</xsl:when>
												<xsl:otherwise>Default tax
												description</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												</xsl:for-each>
												</xsl:element>
												</xsl:if>
												<!-- Shipping -->
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_610 != '' and ../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_352 != ''">
												<xsl:element name="Shipping">
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_127 != ''">
												<xsl:attribute name="trackingId">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_127"
												/>
												</xsl:attribute>
												</xsl:if>
												<xsl:if
												test="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_770 != ''">
												<xsl:attribute name="trackingDomain">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_770"
												/>
												</xsl:attribute>
												</xsl:if>
												<xsl:element name="Money">
												<xsl:attribute name="currency">
												<xsl:value-of
												select="../G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'G830']/S_CUR[D_98_1 = 'BY']/D_100_1"
												/>
												</xsl:attribute>
												<xsl:value-of
												select="(../G_SAC/S_SAC[D_248 = 'C'][D_1300 = 'G830']/D_610 div 100)"
												/>
												</xsl:element>
												<xsl:element name="Description">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when
												test="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'shipping']/D_127 != ''">
												<xsl:value-of
												select="../G_N9/S_N9[D_128 = 'L1' and D_369 = 'shipping'][1]/D_127"
												/>
												</xsl:when>
												<xsl:when
												test="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_819 != ''">
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_819"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:text>en</xsl:text>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when
												test="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'shipping']/S_MSG/D_933 != ''">
												<xsl:for-each
												select="../G_N9[S_N9/D_128 = 'L1' and S_N9/D_369 = 'shipping']/S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="../G_SAC/S_SAC[D_248 = 'C' and D_1300 = 'G830']/D_352"
												/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
												</xsl:element>
												</xsl:if>
												</xsl:when>
											</xsl:choose>
											<xsl:if
												test="$ack/ack/element[@name = 'B8']/@value != ''">
												<xsl:element name="SupplierBatchID">
												<xsl:value-of
												select="$ack/ack/element[@name = 'B8']/@value"/>
												</xsl:element>
											</xsl:if>
																						
											<xsl:variable name="AckLine">
												<xsl:value-of select="S_ACK/D_326"/>
											</xsl:variable>
											
										   <!-- IG-32697 -->
											<xsl:for-each select="../G_SCH">	
												<xsl:choose>
													<xsl:when test="S_SCH/D_380!='' and S_SCH[D_374_1 = '002']/D_373_1!='' and $ACKCount='1'">
														<ScheduleLineReference>														
															<xsl:attribute name="quantity">
																<xsl:value-of select="S_SCH/D_380"/>														
															</xsl:attribute>													
															<xsl:attribute name="requestedDeliveryDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="Date"
																		select="S_SCH[D_374_1 = '002']/D_373_1"/>
																	<xsl:with-param name="Time"
																		select="S_SCH[D_374_1 = '002']/D_337_1"/>
																	<!-- IG-38822 add time zone in dependence of condition    start  -->
																	<xsl:with-param name="TimeCode"
																		select="S_REF[D_128 = '0N'][D_127 = 'SCH05TimeZone']/D_352"/>
																	<!-- IG-38822 add time zone in dependence of condition    end  -->
																</xsl:call-template>
															</xsl:attribute>
															<xsl:if test="normalize-space(S_SCH/D_326)!=''">
																<xsl:attribute name="lineNumber">
																	<xsl:value-of select="S_SCH/D_326"/>
																</xsl:attribute>
															</xsl:if>
															
															<xsl:for-each select="S_REF[D_128='ZZ' and D_127!='']">
																<xsl:element name="Extrinsic">
																	<xsl:attribute name="name">
																		<xsl:value-of select="D_127"/>
																	</xsl:attribute>
																	<xsl:value-of select="D_352"/>
																</xsl:element>
															</xsl:for-each>										
														</ScheduleLineReference>
													</xsl:when>
													<!-- if we have multiple ACK REF-ACK06 is mandatory. this is updated ay Guide -->
													<xsl:when test="(S_SCH/D_380!='' and S_SCH[D_374_1 = '002']/D_373_1!='') and S_REF[D_128='0L' and D_127='ACK06' and D_352=$AckLine] and S_SCH/D_326=$AckLine">
														<ScheduleLineReference>														
															<xsl:attribute name="quantity">
																<xsl:value-of select="S_SCH/D_380"/>														
															</xsl:attribute>													
															<xsl:attribute name="requestedDeliveryDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="Date"
																		select="S_SCH[D_374_1 = '002']/D_373_1"/>
																	<xsl:with-param name="Time"
																		select="S_SCH[D_374_1 = '002']/D_337_1"/>
																	<!-- IG-38822 add time zone in dependence of condition    start  -->
																	<xsl:with-param name="TimeCode"
																		select="S_REF[D_128 = '0N'][D_127 = 'SCH05TimeZone']/D_352"/>
																	<!-- IG-38822 add time zone in dependence of condition    end  -->
																</xsl:call-template>
															</xsl:attribute>
															<xsl:if test="normalize-space(S_SCH/D_326)!=''">
																<xsl:attribute name="lineNumber">
																	<xsl:value-of select="S_SCH/D_326"/>
																</xsl:attribute>
															</xsl:if>
															
															<xsl:for-each select="S_REF[D_128='ZZ' and D_127!='']">
																<xsl:element name="Extrinsic">
																	<xsl:attribute name="name">
																		<xsl:value-of select="D_127"/>
																	</xsl:attribute>
																	<xsl:value-of select="D_352"/>
																</xsl:element>
															</xsl:for-each>										
														</ScheduleLineReference>
													</xsl:when>
													
												</xsl:choose>												
												
											</xsl:for-each>
											
											<xsl:for-each
												select="../G_N9[S_N9/D_128 = 'L1' and lower-case(S_N9/D_369) = 'comments']">
												<xsl:element name="Comments">
												<xsl:attribute name="xml:lang">
												<xsl:choose>
												<xsl:when test="S_N9/D_127 != ''">
												<xsl:value-of select="S_N9/D_127[1]"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:text>en</xsl:text>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:attribute>
												<xsl:for-each select="S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:for-each>
												</xsl:element>
											</xsl:for-each>
											<!-- IG-8547 CG: Logic to map extrinsics only when name is sent -->
											<xsl:for-each
												select="../G_N9[S_N9/D_128 = 'ZZ'][S_N9/D_127 != '']">
												<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
												<xsl:value-of select="S_N9/D_127"/>
												</xsl:attribute>
												<!-- IG-8547 CG: As per specs 369 and MSG would contain same information, we should map from MSG when sent -->
												<xsl:choose>
												<xsl:when test="not(exists(S_MSG))">
												<xsl:value-of select="S_N9/D_369"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:for-each select="S_MSG">
												<xsl:choose>
												<xsl:when test="D_934 = 'LC'">
												<xsl:value-of select="D_933"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="concat(nl, D_933)"/>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:for-each>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
											</xsl:for-each>
											<!-- CG: IG-16765 - 1500 Extrinsics -->
											<xsl:if test="$useExtrinsicsLookup = 'yes'">
												<xsl:for-each select="../G_N9/S_REF[D_128 != 'ZZ']">
													<xsl:variable name="refQualVal" select="D_128"/>
													<xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/ConfReqLineEx))][1]/CXMLCode"/>
													<xsl:if test="$extNameL != ''">
														<xsl:element name="Extrinsic">
															<xsl:attribute name="name">
																<xsl:value-of select="$extNameL"/>
															</xsl:attribute>
															<xsl:value-of select="concat(D_127,D_352)"/>
														</xsl:element>
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
											<!-- IG-8547 CG: Map rejection reason only when type is reject -->
											<xsl:if
												test="S_ACK/D_668 = 'IR' and (../G_N9[S_N9/D_128 = 'L1'][lower-case(S_N9/D_369) = 'rejectionreason']/S_MSG/D_933 != '')">
												<xsl:variable name="rejreason"
												select="../G_N9[S_N9/D_128 = 'L1'][lower-case(S_N9/D_369) = 'rejectionreason']/S_MSG/D_933"/>
												<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
												<xsl:value-of select="'RejectionReasonComments'"/>
												</xsl:attribute>
												<xsl:value-of select="$rejreason"/>
												</xsl:element>
												<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
												<xsl:value-of select="'RejectionReason'"/>
												</xsl:attribute>
												<xsl:choose>
												<xsl:when
												test="$Lookup/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(X12Code, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode != ''">
												<xsl:value-of
												select="$Lookup/Lookups/ConfirmationRejectionReasons/ConfirmationRejectionReason[lower-case(translate(X12Code, ' ', '')) = lower-case(translate($rejreason, ' ', ''))]/CXMLCode"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:text>other</xsl:text>
												</xsl:otherwise>
												</xsl:choose>
												</xsl:element>
											</xsl:if>
											<xsl:for-each select="../S_REF[D_128 = 'ZZ']">
												<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
												<xsl:value-of select="D_127"/>
												</xsl:attribute>
												<xsl:value-of select="D_352"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test="$unkQty &gt; 0">
									<xsl:element name="ConfirmationStatus">
										<xsl:attribute name="type">unknown</xsl:attribute>
										<xsl:attribute name="quantity">
											<xsl:value-of select="$unkQty"/>
										</xsl:attribute>
										<xsl:element name="UnitOfMeasure">
											<xsl:variable name="uomcode" select="S_PO1/D_355"/>
										   <xsl:choose>
										      <xsl:when
										         test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode != ''">
										         <xsl:value-of
										            select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode"
										         />
										      </xsl:when>
										      <xsl:otherwise>ZZ</xsl:otherwise>
										   </xsl:choose>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:for-each>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="S_PER">
		<xsl:variable name="PER02">
			<xsl:choose>
				<xsl:when test="D_93 != ''">
					<xsl:value-of select="D_93"/>
				</xsl:when>
				<xsl:otherwise>default</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="D_365_1 = 'EM'">
				<Con>
					<xsl:attribute name="type">Email</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_1)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_1 = 'UR'">
				<Con>
					<xsl:attribute name="type">URL</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_1)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_1 = 'TE'">
				<Con>
					<xsl:attribute name="type">Phone</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, '(')">
								<xsl:value-of select="substring-before(D_364_1, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, '-')">
								<xsl:value-of select="substring-before(D_364_1, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"
						/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, 'x')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, 'X')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_1, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_1, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_1 = 'FX'">
				<Con>
					<xsl:attribute name="type">Fax</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, '(')">
								<xsl:value-of select="substring-before(D_364_1, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, '-')">
								<xsl:value-of select="substring-before(D_364_1, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"
						/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_1, 'x')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_1, 'X')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_1, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_1, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="D_365_2 = 'EM'">
				<Con>
					<xsl:attribute name="type">Email</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_2)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_2 = 'UR'">
				<Con>
					<xsl:attribute name="type">URL</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_2)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_2 = 'TE'">
				<Con>
					<xsl:attribute name="type">Phone</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, '(')">
								<xsl:value-of select="substring-before(D_364_2, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, '-')">
								<xsl:value-of select="substring-before(D_364_2, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"
						/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, 'x')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, 'X')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_2, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_2, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_2 = 'FX'">
				<Con>
					<xsl:attribute name="type">Fax</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, '(')">
								<xsl:value-of select="substring-before(D_364_2, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, '-')">
								<xsl:value-of select="substring-before(D_364_2, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"
						/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, 'x')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, 'X')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_2, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_2, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="D_365_3 = 'EM'">
				<Con>
					<xsl:attribute name="type">Email</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_3)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_3 = 'UR'">
				<Con>
					<xsl:attribute name="type">URL</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364_3)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_3 = 'TE'">
				<Con>
					<xsl:attribute name="type">Phone</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, '(')">
								<xsl:value-of select="substring-before(D_364_3, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, '-')">
								<xsl:value-of select="substring-before(D_364_3, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"
						/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, 'x')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, 'X')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_3, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_3, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365_3 = 'FX'">
				<Con>
					<xsl:attribute name="type">Fax</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, '(')">
								<xsl:value-of select="substring-before(D_364_3, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, '-')">
								<xsl:value-of select="substring-before(D_364_3, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"
						/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, 'x')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, 'X')">
								<xsl:value-of
									select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364_3, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364_3, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createContact">
		<xsl:param name="contact"/>
		<xsl:variable name="role">
			<xsl:value-of select="$contact/S_N1/D_98_1"/>
		</xsl:variable>
		<xsl:if test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
			<xsl:element name="Contact">
				<xsl:attribute name="role">
					<xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode"/>
				</xsl:attribute>
				<xsl:if test="$contact/S_N1/D_67 != ''">
					<xsl:attribute name="addressID">
						<xsl:value-of select="$contact/S_N1/D_67"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="addrDomain">
					<xsl:value-of select="$contact/S_N1/D_66"/>
				</xsl:variable>
				<xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
					<xsl:if
						test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain] != ''">
						<xsl:attribute name="addressIDDomain">
							<xsl:value-of
								select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"
							/>
						</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:element name="Name">
					<xsl:attribute name="xml:lang">en</xsl:attribute>
					<xsl:value-of select="$contact/S_N1/D_93"/>
				</xsl:element>
				<!-- PostalAddress -->
				<xsl:if
					test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
					<xsl:element name="PostalAddress">
						<xsl:for-each select="$contact/S_N2">
							<xsl:element name="DeliverTo">
								<xsl:value-of select="D_93_1"/>
							</xsl:element>
							<xsl:if test="D_93_2 != ''">
								<xsl:element name="DeliverTo">
									<xsl:value-of select="D_93_2"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="$contact/S_N3">
							<xsl:element name="Street">
								<xsl:value-of select="D_166_1"/>
							</xsl:element>
							<xsl:if test="D_166_2 != ''">
								<xsl:element name="Street">
									<xsl:value-of select="D_166_2"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="$contact/S_N4"/>
						<xsl:element name="City">
							<!-- <xsl:attribute name="cityCode"/> -->
							<xsl:value-of select="$contact/S_N4/D_19"/>
						</xsl:element>
					   <xsl:variable name="sCode">
					      <xsl:choose>
					         <xsl:when test="$contact/S_N4/D_310 != '' and not($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA')">
					            <xsl:value-of select="$contact/S_N4/D_310"/>
					         </xsl:when>
					         <xsl:when test="$contact/S_N4/D_156 != ''">
					            <xsl:value-of select="$contact/S_N4/D_156"/>
					         </xsl:when>
					      </xsl:choose>
					   </xsl:variable>
					   <xsl:if test="$sCode != ''">
					      <xsl:element name="State">
					         <xsl:value-of select="$sCode"/>
					      </xsl:element>
					   </xsl:if>
						<xsl:if test="$contact/S_N4/D_116 != ''">
							<xsl:element name="PostalCode">
								<xsl:value-of select="$contact/S_N4/D_116"/>
							</xsl:element>
						</xsl:if>
						<xsl:variable name="isoCountryCode">
							<xsl:value-of select="$contact/S_N4/D_26"/>
						</xsl:variable>
						<xsl:element name="Country">
							<xsl:attribute name="isoCountryCode">
								<xsl:value-of select="$isoCountryCode"/>
							</xsl:attribute>
							<xsl:value-of
								select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
							/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:variable name="contactList">
					<xsl:apply-templates select="$contact/S_PER"/>
				</xsl:variable>
				<xsl:for-each select="$contactList/Con[@type = 'Email']">
					<xsl:sort select="@name"/>
					<xsl:element name="Email">
						<xsl:attribute name="name">
							<xsl:value-of select="./@name"/>
						</xsl:attribute>
						<xsl:value-of select="./@value"/>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="$contactList/Con[@type = 'Phone']">
					<xsl:sort select="@name"/>
					<xsl:variable name="cCode" select="@cCode"/>
					<xsl:element name="Phone">
						<xsl:attribute name="name">
							<xsl:value-of select="./@name"/>
						</xsl:attribute>
						<xsl:element name="TelephoneNumber">
							<xsl:element name="CountryCode">
								<xsl:attribute name="isoCountryCode">
									<xsl:choose>
										<xsl:when
											test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
											<xsl:value-of
												select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
											/>
										</xsl:when>
										<xsl:otherwise>US</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="replace(@cCode, '\+', '')"/>
							</xsl:element>
							<xsl:element name="AreaOrCityCode">
								<xsl:value-of select="@aCode"/>
							</xsl:element>
							<xsl:element name="Number">
								<xsl:value-of select="@num"/>
							</xsl:element>
							<xsl:if test="@ext != ''">
								<xsl:element name="Extension">
									<xsl:value-of select="@ext"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="$contactList/Con[@type = 'Fax']">
					<xsl:sort select="@name"/>
					<xsl:variable name="cCode" select="@cCode"/>
					<xsl:element name="Fax">
						<xsl:attribute name="name">
							<xsl:value-of select="./@name"/>
						</xsl:attribute>
						<xsl:element name="TelephoneNumber">
							<xsl:element name="CountryCode">
								<xsl:attribute name="isoCountryCode">
									<xsl:choose>
										<xsl:when
											test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
											<xsl:value-of
												select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
											/>
										</xsl:when>
										<xsl:otherwise>US</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="replace(@cCode, '\+', '')"/>
							</xsl:element>
							<xsl:element name="AreaOrCityCode">
								<xsl:value-of select="@aCode"/>
							</xsl:element>
							<xsl:element name="Number">
								<xsl:value-of select="@num"/>
							</xsl:element>
							<xsl:if test="@ext != ''">
								<xsl:element name="Extension">
									<xsl:value-of select="@ext"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="$contactList/Con[@type = 'URL']">
					<xsl:sort select="@name"/>
					<xsl:element name="URL">
						<xsl:attribute name="name">
							<xsl:value-of select="./@name"/>
						</xsl:attribute>
						<xsl:value-of select="./@value"/>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="S_REF">
					<xsl:choose>
						<xsl:when test="$role = 'RI' and D_128 = 'BAA'">
							<xsl:element name="IdReference">
								<xsl:attribute name="identifier">
									<xsl:value-of select="D_352"/>
								</xsl:attribute>
								<xsl:attribute name="domain">
									<xsl:text>SupplierTaxID</xsl:text>
								</xsl:attribute>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="IDRefDomain" select="D_128"/>
							<xsl:choose>
								<xsl:when test="$IDRefDomain = 'ZZ' and D_127 != '' and D_352 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="D_352"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:value-of select="D_127"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:when>
								<xsl:when
									test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="D_352"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:value-of
												select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"
											/>
										</xsl:attribute>
									</xsl:element>
								</xsl:when>
								<xsl:when
									test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="D_352"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:value-of
												select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"
											/>
										</xsl:attribute>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="convertToTelephone">
		<xsl:param name="phoneNum"/>
		<xsl:variable name="phoneNumTemp">
			<xsl:value-of select="$phoneNum"/>
		</xsl:variable>
		<xsl:variable name="phoneArr" select="tokenize($phoneNumTemp, '-')"/>
		<xsl:variable name="countryCode">
			<xsl:value-of select="replace($phoneArr[1], '\+', '')"/>
		</xsl:variable>
		<xsl:element name="TelephoneNumber">
			<xsl:element name="CountryCode">
				<xsl:attribute name="isoCountryCode">
					<xsl:value-of
						select="$Lookup/Lookups/Countries/Country[phoneCode = $countryCode]/countryCode"
					/>
				</xsl:attribute>
				<xsl:value-of select="replace($phoneArr[1], '\+', '')"/>
			</xsl:element>
			<xsl:element name="AreaOrCityCode">
				<xsl:value-of select="$phoneArr[2]"/>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="contains($phoneArr[3], 'x')">
					<xsl:variable name="extTemp">
						<xsl:value-of select="tokenize($phoneArr[3], 'x')"/>
					</xsl:variable>
					<xsl:element name="Number">
						<xsl:value-of select="$extTemp[1]"/>
					</xsl:element>
					<xsl:element name="Extension">
						<xsl:value-of select="$extTemp[2]"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="exists($phoneArr[4])">
					<xsl:element name="Number">
						<xsl:value-of select="$phoneArr[3]"/>
					</xsl:element>
					<xsl:element name="Extension">
						<xsl:value-of select="$phoneArr[4]"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="Number">
						<xsl:value-of select="$phoneArr[3]"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="convertToAribaDatePORef">
		<xsl:param name="Date"/>
		<xsl:param name="Time"/>
		<xsl:param name="TimeCode"/>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when
					test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
					<xsl:value-of
						select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
					/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tempDate">
			<xsl:value-of
				select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
			/>
		</xsl:variable>
		<xsl:variable name="tempTime">
			<xsl:choose>
				<xsl:when test="$Time != '' and string-length($Time) = 6">
					<xsl:value-of
						select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
					/>
				</xsl:when>
				<xsl:when test="$Time != '' and string-length($Time) = 4">
					<xsl:value-of
						select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2))"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$tempTime = ''">
				<xsl:value-of select="''"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($tempDate, $tempTime, $timeZone)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createACK">
		<xsl:param name="ACK"/>
		<ack>
			<xsl:for-each select="$ACK/*[starts-with(name(), 'D_23')]">
				<xsl:if test="starts-with(name(), 'D_235')">
					<element>
						<xsl:attribute name="name">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of
								select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"
							/>
						</xsl:attribute>
					</element>
				</xsl:if>
			</xsl:for-each>
		</ack>
	</xsl:template>
</xsl:stylesheet>
