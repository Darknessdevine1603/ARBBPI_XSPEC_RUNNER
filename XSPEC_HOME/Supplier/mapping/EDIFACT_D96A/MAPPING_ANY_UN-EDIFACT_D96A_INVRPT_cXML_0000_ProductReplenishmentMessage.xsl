<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>

	<!-- <xsl:variable name="lookups" select="document('cXML_EDILookups.xsl')"/> -->
	 <xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>

	<xsl:template match="*">
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="current-dateTime()"/>
			</xsl:attribute>
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<Header>
				<From>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anSupplierANID"/>
						</Identity>
					</Credential>
				</From>
				<To>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anBuyerANID"/>
						</Identity>
					</Credential>
				</To>
				<Sender>
					<Credential domain="NetworkId">
						<Identity>
							<xsl:value-of select="$anProviderANID"/>
						</Identity>
					</Credential>
					<UserAgent>
						<xsl:value-of select="'Ariba Supplier'"/>
					</UserAgent>
				</Sender>
			</Header>

			<Message>
				<xsl:choose>
					<xsl:when test="$anEnvName='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<ProductReplenishmentMessage>
					<ProductReplenishmentHeader>
						<xsl:attribute name="creationDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="dateTime" select="M_INVRPT/S_DTM/C_C507[D_2005='97']/D_2380"/>
								<xsl:with-param name="dateTimeFormat" select="M_INVRPT/S_DTM/C_C507[D_2005='97']/D_2379"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="messageID">
							<xsl:value-of select="M_INVRPT/S_BGM/D_1004"/>
						</xsl:attribute>
					</ProductReplenishmentHeader>

					<xsl:choose>
						<!-- 35 for Inventory Report -->
						<xsl:when test="M_INVRPT/S_BGM/C_C002/D_1001='35'">
							<xsl:for-each select="M_INVRPT/G_SG9">
								<ProductReplenishmentDetails>
									<ItemID>
										<xsl:if test="S_LIN/C_C212/D_7143='VP'">
											<SupplierPartID>
												<xsl:value-of select="S_LIN/C_C212/D_7140"/>
											</SupplierPartID>
										</xsl:if>
										<xsl:if test="S_PIA/C_C212_2/D_7143='VS'">
											<SupplierPartAuxiliaryID>
												<xsl:value-of select="S_PIA/C_C212_2/D_7140"/>
											</SupplierPartAuxiliaryID>
										</xsl:if>
										<BuyerPartID>
											<xsl:if test="S_PIA/C_C212/D_7143='BP'">
												<xsl:value-of select="S_PIA/C_C212/D_7140"/>
											</xsl:if>
										</BuyerPartID>
									</ItemID>
									<xsl:if test="S_IMD/D_7077 = 'F'">
										<Description>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="lower-case(S_IMD[D_7077='F']/C_C273/D_3453)"/>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="S_IMD[D_7077='F']/C_C273/D_7008_2 != ''">
													<xsl:value-of select="concat(S_IMD[D_7077='F']/C_C273/D_7008, S_IMD[D_7077='F']/C_C273/D_7008_2)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="S_IMD[D_7077='F']/C_C273/D_7008"/>
												</xsl:otherwise>
											</xsl:choose>
										</Description>
									</xsl:if>
									<xsl:for-each select="G_SG11">
										<xsl:for-each select="G_SG12">
											<xsl:if test="S_NAD">
												<xsl:variable name="role" select="S_NAD/D_3035"/>
												<!--<Defect IG-1310> create contact only if role = ST,SU or GY-->
												<xsl:if test="$role='ST'or $role='SU' or $role='GY' ">
												<Contact>
													<xsl:attribute name="role">
														<xsl:choose>
															<xsl:when test="$role='ST'">
																<xsl:text>locationTo</xsl:text>
															</xsl:when>
															<xsl:when test="$role='SU'">
																<xsl:text>locationFrom</xsl:text>
															</xsl:when>
															<xsl:when test="$role='GY'">
																<xsl:text>inventoryOwner</xsl:text>
															</xsl:when>															
														</xsl:choose>
													</xsl:attribute>
													
													<xsl:call-template name="CreateContact">
														<xsl:with-param name="contactPath" select="S_NAD"/>
													</xsl:call-template>
													<xsl:choose>
														<xsl:when test="$role = 'ST' or $role = 'SU'">
															<IdReference>
																<xsl:attribute name="domain">
																	<xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153='WS']/D_1154"/>
																</xsl:attribute>
																<xsl:attribute name="identifier">
																	<xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153='WS']/D_4000"/>
																</xsl:attribute>
															</IdReference>
														</xsl:when>
														<xsl:when test="$role = 'GY'">
															<IdReference>
																<xsl:attribute name="domain">
																	<xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153='AEN']/D_1154"/>
																</xsl:attribute>
																<xsl:attribute name="identifier">
																	<xsl:value-of select="../G_SG14/S_RFF/C_C506[D_1153='AEN']/D_4000"/>
																</xsl:attribute>
															</IdReference>
														</xsl:when>
													</xsl:choose>
												</Contact>
												</xsl:if>
											</xsl:if>
										</xsl:for-each>

										<xsl:variable name="qtyQual" select="S_QTY/C_C186/D_6063"/>

										<xsl:choose>
											<xsl:when test="$qtyQual = '17' or $qtyQual = '24'">
												<Inventory>
													<xsl:if test="$qtyQual = '17'">
														<UnrestrictedUseQuantity>
															<xsl:attribute name="quantity">
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6060"/>
															</xsl:attribute>
															<UnitOfMeasure>
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6411"/>
															</UnitOfMeasure>
														</UnrestrictedUseQuantity>
													</xsl:if>
													<xsl:if test="$qtyQual = '24'">
														<QualityInspectionQuantity>
															<xsl:attribute name="quantity">
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6060"/>
															</xsl:attribute>
															<UnitOfMeasure>
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6411"/>
															</UnitOfMeasure>
														</QualityInspectionQuantity>
													</xsl:if>
												</Inventory>
												<xsl:if test="$qtyQual = '17'">
													<ConsignmentInventory>
														<UnrestrictedUseQuantity>
															<xsl:attribute name="quantity">
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6060"/>
															</xsl:attribute>
															<UnitOfMeasure>
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6411"/>
															</UnitOfMeasure>
														</UnrestrictedUseQuantity>
													</ConsignmentInventory>
												</xsl:if>
												<xsl:if test="$qtyQual = '24'">
													<ConsignmentInventory>
														<QualityInspectionQuantity>
															<xsl:attribute name="quantity">
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6060"/>
															</xsl:attribute>
															<UnitOfMeasure>
																<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6411"/>
															</UnitOfMeasure>
														</QualityInspectionQuantity>
													</ConsignmentInventory>
												</xsl:if>
											</xsl:when>
											<xsl:when test="$qtyQual = '96'">
												<Inventory>
													<BlockedQuantity>
														<xsl:attribute name="quantity">
															<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6060"/>
														</xsl:attribute>
														<UnitOfMeasure>
															<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6411"/>
														</UnitOfMeasure>
													</BlockedQuantity>
												</Inventory>
												<ConsignmentInventory>
													<BlockedQuantity>
														<xsl:attribute name="quantity">
															<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6060"/>
														</xsl:attribute>
														<UnitOfMeasure>
															<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6411"/>
														</UnitOfMeasure>
													</BlockedQuantity>
												</ConsignmentInventory>
											</xsl:when>
											<xsl:when test="$qtyQual = '57'">
												<Inventory>
													<StockInTransferQuantity>
														<xsl:attribute name="quantity">
															<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6060"/>
														</xsl:attribute>
														<UnitOfMeasure>
															<xsl:value-of select="S_QTY/C_C186[D_6063=$qtyQual]/D_6411"/>
														</UnitOfMeasure>
													</StockInTransferQuantity>
												</Inventory>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>

									<xsl:if test="M_INVRPT/S_DTM/C_C507/D_2005 ='366'">
										<Extrinsic name="InventoryDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime" select="M_INVRPT/S_DTM/C_C507[D_2005 ='366']/D_2380"/>
												<xsl:with-param name="dateTimeFormat" select="M_INVRPT/S_DTM/C_C507[D_2005 ='366']/D_2379"/>
											</xsl:call-template>
										</Extrinsic>
									</xsl:if>
									<xsl:if test="S_PIA/C_C212_3[D_1131='156'][D_7143='ZZZ']/D_7140 !=''">
										<Extrinsic name="materialStorageLocation">
											<xsl:value-of select="S_PIA/C_C212_3[D_1131='156'][D_7143='ZZZ']/D_7140"/>
										</Extrinsic>
									</xsl:if>
								</ProductReplenishmentDetails>
							</xsl:for-each>
						</xsl:when>
						<!-- for non inventory documents -->
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</ProductReplenishmentMessage>
			</Message>
		</cXML>
	</xsl:template>

	<xsl:template name="CreateContact">
		<xsl:param name="contactPath"/>
		<Name>
			<xsl:attribute name="xml:lang">
				<xsl:value-of select="'en'"/>
			</xsl:attribute>
			<xsl:value-of select="$contactPath/C_C058/D_3124"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$contactPath/C_C058/D_3124_2"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$contactPath/C_C058/D_3124_3"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$contactPath/C_C058/D_3124_4"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$contactPath/C_C058/D_3124_5"/>
		</Name>
		<PostalAddress>
			<DeliverTo>
				<xsl:value-of select="$contactPath/C_C080/D_3036"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$contactPath/C_C080/D_3036_2"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$contactPath/C_C080/D_3036_3"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$contactPath/C_C080/D_3036_4"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$contactPath/C_C080/D_3036_5"/>
			</DeliverTo>
			<Street>
				<xsl:value-of select="$contactPath/C_C059/D_3042"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$contactPath/C_C059/D_3042_2"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$contactPath/C_C059/D_3042_3"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$contactPath/C_C059/D_3042_4"/>
			</Street>
			<City>
				<xsl:value-of select="$contactPath/D_3164"/>
			</City>
			<PostalCode>
				<xsl:value-of select="$contactPath/D_3251"/>
			</PostalCode>
			<xsl:variable name="isoCountryCode">
				<xsl:value-of select="$contactPath/D_3207"/>
			</xsl:variable>
			<Country>
				<xsl:attribute name="isoCountryCode">
					<xsl:value-of select="$isoCountryCode"/>
				</xsl:attribute>
				<xsl:value-of select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
			</Country>
		</PostalAddress>
	</xsl:template>

	<xsl:template name="PhoneFaxEmail">
		<xsl:param name="contactName"/>
		<xsl:param name="phone"/>
		<xsl:param name="fax"/>
		<xsl:param name="email"/>
		<xsl:param name="countrycode"/>
		<xsl:param name="attributeName"/>

		<xsl:if test="$email and $email!=''">
			<Email>
				<xsl:attribute name="name">
					<xsl:value-of select="$attributeName"/>
				</xsl:attribute>
				<xsl:value-of select="$email"/>
			</Email>
		</xsl:if>
		<xsl:if test="$phone and $phone!=''">
			<Phone>
				<xsl:attribute name="name">
					<xsl:value-of select="$attributeName"/>
				</xsl:attribute>
				<xsl:call-template name="convertToTelephone">
					<xsl:with-param name="phoneNum" select="$phone"/>
				</xsl:call-template>
			</Phone>
		</xsl:if>
		<xsl:if test="$fax and $fax!=''">
			<Fax>
				<xsl:attribute name="name">
					<xsl:value-of select="$attributeName"/>
				</xsl:attribute>
				<xsl:call-template name="convertToTelephone">
					<xsl:with-param name="phoneNum" select="$fax"/>
				</xsl:call-template>
			</Fax>
		</xsl:if>
	</xsl:template>

	<xsl:template name="PhoneFaxEmailLoop">
		<xsl:param name="contactName"/>
		<xsl:param name="phone"/>
		<xsl:param name="fax"/>
		<xsl:param name="email"/>
		<xsl:param name="countrycode"/>

		<xsl:if test="$email and $email!=''">
			<xsl:for-each select="$email">
				<Email>
					<xsl:attribute name="name">
						<xsl:value-of select="S_CTA[D_3139='IC']/C_C056/D_3412"/>
					</xsl:attribute>
					<xsl:value-of select="S_COM/C_C076[D_3155='EM']/D_3148"/>
				</Email>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$phone and $phone!=''">
			<xsl:for-each select="$phone">
				<Phone>
					<xsl:attribute name="name">
						<xsl:value-of select="S_CTA[D_3139='IC']/C_C056/D_3412"/>
					</xsl:attribute>
					<xsl:call-template name="convertToTelephone">
						<xsl:with-param name="phoneNum" select="S_COM/C_C076[D_3155='TE']/D_3148"/>
					</xsl:call-template>
				</Phone>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$fax and $fax!=''">
			<xsl:for-each select="$fax">
				<Fax>
					<xsl:attribute name="name">
						<xsl:value-of select="S_CTA[D_3139='IC']/C_C056/D_3412"/>
					</xsl:attribute>
					<xsl:call-template name="convertToTelephone">
						<xsl:with-param name="phoneNum" select="S_COM/C_C076[D_3155='FX']/D_3148"/>
					</xsl:call-template>
				</Fax>
			</xsl:for-each>
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
					<xsl:value-of select="$lookups/Lookups/Countries/Country[phoneCode = $countryCode]/countryCode"/>
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

	<xsl:template name="convertToAribaDate">
		<xsl:param name="dateTime"/>
		<xsl:param name="dateTimeFormat"/>

		<xsl:variable name="dtmFormat">
			<xsl:choose>
				<xsl:when test="$dateTimeFormat!=''">
					<xsl:value-of select="$dateTimeFormat"/>
				</xsl:when>
				<xsl:otherwise>102</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tempDateTime">
			<xsl:choose>
				<xsl:when test="$dtmFormat = 102">
					<xsl:value-of select="concat($dateTime, '000000')"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 203">
					<xsl:value-of select="concat($dateTime, '00')"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 204">
					<xsl:value-of select="$dateTime"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 303">
					<xsl:value-of select="concat(substring($dateTime, 0, 12), '00', substring($dateTime, 12))"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 304">
					<xsl:value-of select="$dateTime"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$dateTimeFormat = '303' or $dateTimeFormat = '304'">
					<xsl:choose>
						<xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode!=''">
							<xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode"/>
						</xsl:when>
						<xsl:otherwise>+00:00</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"/>
	</xsl:template>
</xsl:stylesheet>
