<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="cXMLAttachments"/>
	<xsl:param name="attachSeparator" select="'\|'"/>
	<xsl:param name="anSenderDefaultTimeZone"/>
	<!-- For local testing -->
	<!--xsl:variable name="lookups" select="document('cXML_EDILookups_EANCOM_D96A.xml')"/>
   <xsl:include href="Format_EANCOM_D96A_CXML_common.xsl"/-->

	<!-- for dynamic, reading from Partner Directory -->
	<xsl:include href="FORMAT_EANCOM_D96AEAN008_cXML_0000.xsl"/>
	<xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_EANCOM_D96AEAN008.xml')"/>

	<xsl:variable name="headerCurrency" select="ns0:Interchange/M_INVOIC/G_SG7/S_CUX/C_C504[D_6343 = '4']/D_6345"/>
	<xsl:variable name="headerCurrencyAlt" select="ns0:Interchange/M_INVOIC/G_SG7/S_CUX/C_C504[D_6343 = '11']/D_6345"/>

	<xsl:template match="ns0:*">
		<xsl:variable name="containsOrderInfo">
			<xsl:choose>
				<xsl:when test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != '' or M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="invType">
			<xsl:choose>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '380'">standard</xsl:when>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '381' and $containsOrderInfo = 'true'">lineLevelCreditMemo</xsl:when>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '381'">creditMemo</xsl:when>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '383' and $containsOrderInfo = 'true'">lineLevelDebitMemo</xsl:when>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '383'">debitMemo</xsl:when>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '385'">standard</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="isCreditMemo">
			<xsl:choose>
				<xsl:when test="$invType = 'lineLevelCreditMemo'">yes</xsl:when>
				<xsl:when test="$invType = 'creditMemo'">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currHead" select="M_INVOIC/G_SG7/S_CUX/C_C504[D_6347 = '2'][D_6343 = '4']/D_6345"/>
		<xsl:variable name="altCurrHead" select="M_INVOIC/G_SG7/S_CUX/C_C504_2[D_6347 = '3'][D_6343 = '11']/D_6345"/>
		<xsl:element name="cXML">
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="string(current-dateTime())"/>
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
				<xsl:element name="InvoiceDetailRequest">
					<xsl:element name="InvoiceDetailRequestHeader">
						<xsl:attribute name="invoiceID">
							<xsl:value-of select="M_INVOIC/S_BGM/D_1004"/>
						</xsl:attribute>
						<xsl:if test="M_INVOIC/S_BGM/D_1225 = '43' or M_INVOIC/S_BGM/D_1225 = '55'">
							<xsl:attribute name="isInformationOnly">yes</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="purpose">
							<xsl:value-of select="$invType"/>
						</xsl:attribute>
						<xsl:attribute name="operation">
							<xsl:choose>
								<xsl:when test="M_INVOIC/S_BGM/D_1225 = '3'">delete</xsl:when>
								<xsl:when test="M_INVOIC/S_BGM/D_1225 = '9'">new</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="invoiceDate">
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154 != '' and M_INVOIC/G_SG1[S_REF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '3']/D_2380 != ''">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="M_INVOIC/G_SG1[S_REF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '3']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="M_INVOIC/G_SG1[S_REF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '3']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/S_DTM/C_C507/D_2005 = '3'">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '3']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '3']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/S_DTM/C_C507/D_2005 = '137'">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '137']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '137']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="current-dateTime()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="invoiceOrigin">supplier</xsl:attribute>
						<xsl:element name="InvoiceDetailHeaderIndicator">
							<xsl:choose>
								<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '385' or $invType = 'creditMemo' or $invType = 'debitMemo'">
									<xsl:attribute name="isHeaderInvoice">yes</xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="InvoiceDetailLineIndicator">
							<xsl:if test="M_INVOIC/G_SG25/G_SG26/S_MOA/C_C516/D_5025 = '176'">
								<xsl:attribute name="isTaxInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if test="M_INVOIC/G_SG25/G_SG26/S_MOA/C_C516/D_5025 = '299'">
								<xsl:attribute name="isSpecialHandlingInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if test="M_INVOIC/G_SG25/G_SG26/S_MOA/C_C516/D_5025 = '144'">
								<xsl:attribute name="isShippingInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if test="M_INVOIC/G_SG25/G_SG38/S_ALC[D_5463 = 'A']/C_C214/D_7161 = 'DI'">
								<xsl:attribute name="isDiscountInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if test="M_INVOIC/G_SG25/G_SG38/S_ALC[D_5463 = 'N']/C_C214/D_7161 = 'AEC'">
								<xsl:attribute name="isAccountingInLine">yes</xsl:attribute>
							</xsl:if>
						</xsl:element>
						<!-- InvoicePartner -->
						<xsl:for-each select="M_INVOIC/G_SG2[S_NAD/D_3035 != 'SF' and S_NAD/D_3035 != 'ST' and S_NAD/D_3035 != 'CA']">
							<xsl:variable name="role">
								<xsl:value-of select="S_NAD/D_3035"/>
							</xsl:variable>
							<xsl:if test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
								<xsl:element name="InvoicePartner">
									<xsl:apply-templates select=".">
										<xsl:with-param name="role" select="$role"/>
										<xsl:with-param name="cMode" select="'partner'"/>
									</xsl:apply-templates>
									<xsl:for-each select="S_FII[D_3035 = $role]">
										<xsl:if test="C_C078/D_3194 != ''">
											<xsl:element name="IdReference">
												<xsl:attribute name="identifier">
													<xsl:value-of select="C_C078/D_3194"/>
												</xsl:attribute>
												<xsl:attribute name="domain">
													<xsl:choose>
														<xsl:when test="C_C088/D_3434 != ''">accountNumber</xsl:when>
														<xsl:otherwise>ibanID</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<xsl:if test="C_C078/D_3192 != ''">
											<xsl:element name="IdReference">
												<xsl:attribute name="identifier">
													<xsl:value-of select="C_C078/D_3192"/>
												</xsl:attribute>
												<xsl:attribute name="domain">
													<xsl:text>accountName</xsl:text>
												</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<xsl:if test="C_C078/D_3192_2 != ''">
											<xsl:element name="IdReference">
												<xsl:attribute name="identifier">
													<xsl:value-of select="C_C078/D_3192_2"/>
												</xsl:attribute>
												<xsl:attribute name="domain">
													<xsl:text>accountType</xsl:text>
												</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<xsl:if test="C_C088[D_1131 = '25'][D_3055 = '5']">
											<xsl:if test="C_C088/D_3433 != ''">
												<xsl:element name="IdReference">
													<xsl:attribute name="identifier">
														<xsl:value-of select="C_C088/D_3433"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:text>swiftID</xsl:text>
													</xsl:attribute>
												</xsl:element>
											</xsl:if>
										</xsl:if>
										<xsl:if test="C_C088[D_1131_2 = '25'][D_3055_2 = '5']">
											<xsl:if test="C_C088/D_3434 != ''">
												<xsl:element name="IdReference">
													<xsl:attribute name="identifier">
														<xsl:value-of select="C_C088/D_3434"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:text>bankCode</xsl:text>
													</xsl:attribute>
												</xsl:element>
											</xsl:if>
										</xsl:if>
										<xsl:if test="C_C088/D_3432 != ''">
											<xsl:element name="IdReference">
												<xsl:attribute name="identifier">
													<xsl:value-of select="C_C088/D_3432"/>
												</xsl:attribute>
												<xsl:attribute name="domain">
													<xsl:text>branchName</xsl:text>
												</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<xsl:if test="D_3207 != ''">
											<xsl:element name="IdReference">
												<xsl:attribute name="identifier">
													<xsl:value-of select="D_3207"/>
												</xsl:attribute>
												<xsl:attribute name="domain">
													<xsl:text>bankCountryCode</xsl:text>
												</xsl:attribute>
											</xsl:element>
										</xsl:if>
									</xsl:for-each>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']">
							<InvoicePartner>
								<Contact role="wireReceivingBank">
									<Name xml:lang="en-US">
										<xsl:choose>
											<xsl:when test="C_C088/D_3432 != ''">
												<xsl:value-of select="C_C088/D_3432"/>
											</xsl:when>
											<xsl:otherwise>Not Provided</xsl:otherwise>
										</xsl:choose>
									</Name>
								</Contact>
								<xsl:if test="C_C078/D_3194 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="C_C078/D_3194"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:choose>
												<xsl:when test="C_C088/D_3434 != ''">ibanID</xsl:when>
												<xsl:otherwise>accountNumber</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="C_C078/D_3192 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="C_C078/D_3192"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>accountName</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="C_C078/D_3192_2 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="C_C078/D_3192_2"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>accountType</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="C_C088[D_1131 = '25'][D_3055 = '5']">
									<xsl:if test="C_C088/D_3433 != ''">
										<xsl:element name="IdReference">
											<xsl:attribute name="identifier">
												<xsl:value-of select="C_C088/D_3433"/>
											</xsl:attribute>
											<xsl:attribute name="domain">
												<xsl:text>swiftID</xsl:text>
											</xsl:attribute>
										</xsl:element>
									</xsl:if>
								</xsl:if>
								<xsl:if test="C_C088[D_1131_2 = '25'][D_3055_2 = '5']">
									<xsl:if test="C_C088/D_3434 != ''">
										<xsl:element name="IdReference">
											<xsl:attribute name="identifier">
												<xsl:value-of select="C_C088/D_3434"/>
											</xsl:attribute>
											<xsl:attribute name="domain">
												<xsl:text>bankCode</xsl:text>
											</xsl:attribute>
										</xsl:element>
									</xsl:if>
								</xsl:if>
								<xsl:if test="C_C088/D_3432 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="C_C088/D_3432"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>branchName</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="D_3207 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="D_3207"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>bankCountryCode</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</InvoicePartner>
						</xsl:for-each>
						<!-- IG-1714 -->
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154 != ''">
							<xsl:element name="InvoiceIDInfo">
								<xsl:attribute name="invoiceID">
									<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154"/>
								</xsl:attribute>
								<xsl:if test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
									<xsl:attribute name="invoiceDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime">
												<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
											</xsl:with-param>
											<xsl:with-param name="dateTimeFormat">
												<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<!-- InvoiceDetailShipping -->
						<xsl:if test="(exists(//G_SG2/S_NAD[D_3035 = 'CA']) and exists(//G_SG2/S_NAD[D_3035 = 'SF']) and exists(//G_SG2/S_NAD[D_3035 = 'ST'])) or (exists(//G_SG2/S_NAD[D_3035 = 'SF']) and exists(//G_SG2/S_NAD[D_3035 = 'ST']))">
							<xsl:element name="InvoiceDetailShipping">
								<xsl:if test="M_INVOIC/S_DTM/C_C507[D_2005 = '11']/D_2380 != ''">
									<xsl:attribute name="shippingDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime">
												<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '11']/D_2380"/>
											</xsl:with-param>
											<xsl:with-param name="dateTimeFormat">
												<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '11']/D_2379"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
								<xsl:for-each select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SF' or S_NAD/D_3035 = 'ST' or S_NAD/D_3035 = 'CA']">
									<xsl:apply-templates select=".">
										<xsl:with-param name="role" select="S_NAD/D_3035"/>
									</xsl:apply-templates>
								</xsl:for-each>
								<xsl:for-each select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'CA']">
									<xsl:if test="S_NAD/C_C082/D_1131 = '172'">
										<xsl:choose>
											<xsl:when test="S_NAD/C_C082/D_3055 = '3'">
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>IATA</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="S_NAD/C_C082/D_3039"/>
												</xsl:element>
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>companyName</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="S_NAD/C_C082/D_3055 = '9'">
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>EAN</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="S_NAD/C_C082/D_3039"/>
												</xsl:element>
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>companyName</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="S_NAD/C_C082/D_3055 = '12'">
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>UIC</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="S_NAD/C_C082/D_3039"/>
												</xsl:element>
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>companyName</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="S_NAD/C_C082/D_3055 = '16'">
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>DUNS</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="S_NAD/C_C082/D_3039"/>
												</xsl:element>
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>companyName</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="S_NAD/C_C082/D_3055 = '182'">
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>SCAC</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="S_NAD/C_C082/D_3039"/>
												</xsl:element>
												<xsl:element name="CarrierIdentifier">
													<xsl:attribute name="domain">
														<xsl:text>companyName</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'CA']">
									<xsl:for-each select="G_SG3[S_RFF/C_C506/D_1153 = 'CN'][S_RFF/C_C506/D_1154 != ''][S_RFF/C_C506/D_4000 != '']">
										<xsl:element name="CarrierIdentifier">
											<xsl:attribute name="domain">
												<xsl:value-of select="S_RFF/C_C506/D_4000"/>
											</xsl:attribute>
											<xsl:value-of select="S_RFF/C_C506/D_1154"/>
										</xsl:element>
									</xsl:for-each>
								</xsl:for-each>
								<xsl:if test="exists(//G_SG2/S_NAD[D_3035 = 'CA']) and (M_INVOIC/G_SG2/S_NAD[D_3035 = 'CA']/C_C082/D_1131 = '172' or exists(M_INVOIC/G_SG2[S_NAD/D_3035 = 'CA']/G_SG3[S_RFF/C_C506/D_1153 = 'CN']))">
									<xsl:for-each select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SF' or S_NAD/D_3035 = 'ST']">
										<xsl:variable name="role">
											<xsl:value-of select="S_NAD/D_3035"/>
										</xsl:variable>
										<xsl:for-each select="G_SG3">
											<xsl:choose>
												<xsl:when test="S_RFF/C_C506/D_1153 = 'CN'">
													<xsl:element name="ShipmentIdentifier">
														<xsl:if test="S_DTM/C_C507/D_2005 = '89'">
															<xsl:attribute name="trackingNumberDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="S_DTM/C_C507[D_2005 = '89']/D_2380"/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="S_DTM/C_C507[D_2005 = '89']/D_2379"/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="S_RFF/C_C506/D_1154"/>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AAK']/D_1154 != ''">
							<xsl:element name="ShipNoticeIDInfo">
								<xsl:attribute name="shipNoticeID">
									<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AAK']/D_1154"/>
								</xsl:attribute>
								<xsl:if test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AAK']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
									<xsl:attribute name="shipNoticeDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime">
												<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AAK']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
											</xsl:with-param>
											<xsl:with-param name="dateTimeFormat">
												<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AAK']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:for-each select="M_INVOIC/G_SG8[S_PAT/D_4279 = '3' or S_PAT/D_4279 = '20' or S_PAT/D_4279 = '22']">
							<xsl:if test="normalize-space(S_PAT/C_C112/D_2152) != ''">
								<xsl:element name="PaymentTerm">
									<xsl:attribute name="payInNumberOfDays">
										<xsl:value-of select="S_PAT/C_C112/D_2152"/>
									</xsl:attribute>
									<xsl:if test="(S_PCD/C_C501[D_5245 = '15' or D_5245 = '12'][D_5249 = '13']/D_5482 != '' or S_MOA/C_C516[D_5025 = '52']/D_5004 != '') and S_PAT/D_4279 != '3'">
										<xsl:element name="Discount">
											<xsl:choose>
												<xsl:when test="S_PAT/D_4279 = '20' and S_PCD/C_C501[D_5245 = '15']/D_5482 != ''">
													<xsl:element name="DiscountPercent">
														<xsl:attribute name="percent">
															<xsl:value-of select="concat('-', S_PCD/C_C501[D_5245 = '15']/D_5482)"/>
														</xsl:attribute>
													</xsl:element>
												</xsl:when>
												<xsl:when test="S_PAT/D_4279 = '22' and S_PCD/C_C501[D_5245 = '12']/D_5482 != ''">
													<xsl:element name="DiscountPercent">
														<xsl:attribute name="percent">
															<xsl:value-of select="S_PCD/C_C501[D_5245 = '12']/D_5482"/>
														</xsl:attribute>
													</xsl:element>
												</xsl:when>
												<xsl:when test="S_MOA/C_C516[D_5025 = '52']/D_5004 != '' and S_PAT/D_4279 = '20'">
													<xsl:element name="DiscountAmount">
														<xsl:call-template name="createMoney">
															<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '52'][1]"/>
															<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '79'][D_6343 = '11']"/>
															<xsl:with-param name="isCreditMemo" select="'yes'"/>
														</xsl:call-template>
													</xsl:element>
													<!--xsl:element name="Money">															<xsl:attribute name="currency">																<xsl:value-of select="S_MOA/C_C516[D_5025='52']/D_6345"></xsl:value-of>															</xsl:attribute>															<xsl:value-of select="concat('-',S_MOA/C_C516[D_5025='52']/D_5004)"></xsl:value-of>														</xsl:element>													</xsl:element-->
												</xsl:when>
												<xsl:when test="S_MOA/C_C516[D_5025 = '52']/D_5004 != '' and S_PAT/D_4279 = '22'">
													<xsl:element name="DiscountAmount">
														<xsl:call-template name="createMoney">
															<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '52'][1]"/>
															<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '79'][D_6343 = '11']"/>
															<xsl:with-param name="isCreditMemo" select="'no'"/>
														</xsl:call-template>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:element>
									</xsl:if>
									<xsl:if test="S_PAT/D_4279 = '22' and S_DTM/C_C507[D_2005 = '12']">
										<Extrinsic>
											<xsl:attribute name="name">discountDueDate</xsl:attribute>
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime">
													<xsl:value-of select="S_DTM/C_C507[D_2005 = '12']/D_2380"/>
												</xsl:with-param>
												<xsl:with-param name="dateTimeFormat">
													<xsl:value-of select="S_DTM/C_C507[D_2005 = '12']/D_2379"/>
												</xsl:with-param>
											</xsl:call-template>
										</Extrinsic>
									</xsl:if>
									<xsl:if test="S_PAT/D_4279 = '3' and S_DTM/C_C507[D_2005 = '13']">
										<Extrinsic>
											<xsl:attribute name="name">netDueDate</xsl:attribute>
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime">
													<xsl:value-of select="S_DTM/C_C507[D_2005 = '13']/D_2380"/>
												</xsl:with-param>
												<xsl:with-param name="dateTimeFormat">
													<xsl:value-of select="S_DTM/C_C507[D_2005 = '13']/D_2379"/>
												</xsl:with-param>
											</xsl:call-template>
										</Extrinsic>
									</xsl:if>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="M_INVOIC/S_DTM/C_C507[D_2005 = '263']/D_2380 != '' and M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
							<xsl:element name="Period">
								<xsl:attribute name="startDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '263']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '263']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="endDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<!-- Comments -->
						<xsl:variable name="comment">
							<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'AAI']">
								<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="commentLang">
							<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'AAI']">
								<xsl:value-of select="D_3453"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:if test="$comment != '' or $cXMLAttachments != ''">
							<xsl:element name="Comments">
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="$commentLang != ''">
											<xsl:value-of select="substring($commentLang, 1, 2)"/>
										</xsl:when>
										<xsl:otherwise>en</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="$comment"/>
								<!--xsl:copy-of select="$cXMLAttachments"/-->
								<xsl:if test="$cXMLAttachments != ''">
									<xsl:variable name="tokenizedAttachments" select="tokenize($cXMLAttachments, $attachSeparator)"/>
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
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154 != ''">
							<xsl:element name="IdReference">
								<xsl:attribute name="domain">
									<xsl:text>customerReferenceID</xsl:text>
								</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'CR']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
							<xsl:element name="IdReference">
								<xsl:attribute name="domain">
									<xsl:text>customerReferenceDate</xsl:text>
								</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'CR']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'CR']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<!-- Header Extrinsics -->
						<!-- IG-2410 -->
						<xsl:if test="//M_INVOIC/S_FTX[D_4451 = 'REG']/C_C108/D_4440_2">
							<Extrinsic>
								<xsl:attribute name="name">
									<xsl:text>LegalStatus</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="//M_INVOIC/S_FTX[D_4451 = 'REG']/C_C108/D_4440_2"/>
							</Extrinsic>
						</xsl:if>
						<xsl:if test="//M_INVOIC/S_FTX[D_4451 = 'REG']/C_C108/D_4440_3">
							<Extrinsic>
								<xsl:attribute name="name">
									<xsl:text>LegalCapital</xsl:text>
								</xsl:attribute>
								<xsl:variable name="currVal">
									<xsl:value-of select="//M_INVOIC/S_FTX[D_4451 = 'REG']/C_C108/D_4440_3"/>
								</xsl:variable>
								<xsl:variable name="length">
									<xsl:value-of select="string-length($currVal)"/>
								</xsl:variable>
								<xsl:variable name="Currency">
									<xsl:value-of select="normalize-space(substring($currVal, ($length - 3), $length))"/>
								</xsl:variable>
								<xsl:variable name="CurrencyValue">
									<xsl:value-of select="normalize-space(substring($currVal, 1, ($length - 3)))"/>
								</xsl:variable>
								<Money>
									<xsl:attribute name="currency">
										<xsl:value-of select="$Currency"/>
									</xsl:attribute>
									<xsl:value-of select="$CurrencyValue"/>
								</Money>
							</Extrinsic>
						</xsl:if>
						<xsl:if test="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'GN']/D_1154 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name" select="'supplierCommercialIdentifier'"/>
								<xsl:value-of select="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'GN']/D_1154"/>
							</xsl:element>
						</xsl:if>

						<!-- IG-1754 -->
						<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'REG']/C_C108/D_4440_4">
							<Extrinsic>
								<xsl:attribute name="name">
									<xsl:text>supplierCommercialCredentials</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="M_INVOIC/S_FTX[D_4451 = 'REG']/C_C108/D_4440_4"/>
							</Extrinsic>
						</xsl:if>
						<!-- buyerVatID -->
						<xsl:choose>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'IV']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'buyerVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'IV']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SO']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'buyerVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SO']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
						<!-- supplierVatID -->
						<xsl:choose>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'supplierVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SE']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'supplierVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SE']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'II']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'supplierVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'II']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>deliveryNoteNumber</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>deliveryNoteDate</xsl:text>
								</xsl:attribute>
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="dateTime">
										<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
									</xsl:with-param>
									<xsl:with-param name="dateTimeFormat">
										<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2380 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>deliveryDate</xsl:text>
								</xsl:attribute>
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="dateTime">
										<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2380"/>
									</xsl:with-param>
									<xsl:with-param name="dateTimeFormat">
										<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2379"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AWE']/D_1154 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>IATAeI_CostCenter</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AWE']/D_1154"/>
							</xsl:element>
						</xsl:if>
						<!-- 07262017 CG : no standard extrinsics added -->
						<xsl:if test="M_INVOIC/S_BGM/C_C002/D_1000 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>documentName</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="M_INVOIC/S_BGM/C_C002/D_1000"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_DTM/C_C507[D_2005 = '200']/D_2380 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>pickUpCollectionDate</xsl:text>
								</xsl:attribute>
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="dateTime">
										<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '200']/D_2380"/>
									</xsl:with-param>
									<xsl:with-param name="dateTimeFormat">
										<xsl:value-of select="M_INVOIC/S_DTM/C_C507[D_2005 = '200']/D_2379"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_PAI/C_C534/D_4461 != ''">
							<xsl:variable name="codeExt" select="M_INVOIC/S_PAI/C_C534/D_4461"/>
							<xsl:variable name="codeExtLookup" select="$lookups/Lookups/PaymentMeans/PaymentMean[EDIFACTCode = $codeExt]/CXMLCode"/>
							<xsl:if test="$codeExtLookup != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">
										<xsl:text>paymentCategory</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="$codeExtLookup"/>
								</xsl:element>
							</xsl:if>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'AAB']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>paymentTermsDescription</xsl:text>
								</xsl:attribute>
								<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'AAB']">
									<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'ABN']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>accountingInformation</xsl:text>
								</xsl:attribute>
								<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'ABN']">
									<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'PMD']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>paymentDetails</xsl:text>
								</xsl:attribute>
								<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'PMD']">
									<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'SUR']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>supplierRemarks</xsl:text>
								</xsl:attribute>
								<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'SUR']">
									<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG12/C_C100/D_4053 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>incoTerms</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG12/C_C100/D_4053"/>
							</xsl:element>
						</xsl:if>
						<!-- IG-1853 added FTX01=PMT -->
						<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'PMT']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>paymentInformation</xsl:text>
								</xsl:attribute>
								<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'PMT']">
									<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<!-- end of added extrinsics -->
						<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'ZZZ']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:value-of select="C_C108/D_4440"/>
								</xsl:attribute>
								<xsl:value-of select="concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ZZZ']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:value-of select="./D_1154"/>
								</xsl:attribute>
								<xsl:value-of select="./D_4000"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:choose>
						<!-- Header Invoice -->
						<!--						<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '381' or M_INVOIC/S_BGM/C_C002/D_1001 = '383'">							<xsl:for-each select="M_INVOIC/G_SG25">								<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'CT'] or G_SG29/S_RFF/C_C506[D_1153 = 'ON'] or G_SG29/S_RFF/C_C506[D_1153 = 'VN']">								<xsl:element name="InvoiceDetailHeaderOrder">									<xsl:element name="InvoiceDetailOrderInfo">										<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != '' or G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">											<xsl:element name="MasterAgreementIDInfo">												<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">													<xsl:attribute name="agreementID">														<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'CT']/D_1154"/>													</xsl:attribute>												</xsl:if>												<xsl:if test="G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">													<xsl:attribute name="agreementDate">														<xsl:call-template name="convertToAribaDate">															<xsl:with-param name="dateTime">																<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380"/>															</xsl:with-param>															<xsl:with-param name="dateTimeFormat">																<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2379"/>															</xsl:with-param>														</xsl:call-template>													</xsl:attribute>												</xsl:if>												<xsl:attribute name="agreementType">													<xsl:text>scheduling_agreement</xsl:text>												</xsl:attribute>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != '' or G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != '' or G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">											<xsl:element name="OrderIDInfo">												<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">													<xsl:attribute name="orderID">														<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>													</xsl:attribute>												</xsl:if>												<xsl:choose>													<xsl:when test="G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">														<xsl:attribute name="orderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="dateTime">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>																</xsl:with-param>																<xsl:with-param name="dateTimeFormat">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>																</xsl:with-param>															</xsl:call-template>														</xsl:attribute>													</xsl:when>													<xsl:when test="G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">														<xsl:attribute name="orderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="dateTime">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>																</xsl:with-param>																<xsl:with-param name="dateTimeFormat">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>																</xsl:with-param>															</xsl:call-template>														</xsl:attribute>													</xsl:when>												</xsl:choose>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != '' or G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != '' or G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">											<xsl:element name="SupplierOrderInfo">												<xsl:if test="G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">													<xsl:attribute name="orderID">														<xsl:value-of select="G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154"/>													</xsl:attribute>												</xsl:if>												<xsl:choose>													<xsl:when test="G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">														<xsl:attribute name="orderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="dateTime">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>																</xsl:with-param>																<xsl:with-param name="dateTimeFormat">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>																</xsl:with-param>															</xsl:call-template>														</xsl:attribute>													</xsl:when>													<xsl:when test="G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">														<xsl:attribute name="orderDate">															<xsl:call-template name="convertToAribaDatePORef">																<xsl:with-param name="dateTime">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>																</xsl:with-param>																<xsl:with-param name="dateTimeFormat">																	<xsl:value-of select="G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>																</xsl:with-param>															</xsl:call-template>														</xsl:attribute>													</xsl:when>												</xsl:choose>											</xsl:element>										</xsl:if>									</xsl:element>									<xsl:element name="InvoiceDetailOrderSummary">										<xsl:attribute name="invoiceLineNumber">											<xsl:value-of select="S_LIN/D_1082"/>										</xsl:attribute>										<xsl:if test="S_DTM/C_C507[D_2005 = '351']/D_2380 != ''">											<xsl:attribute name="inspectionDate">												<xsl:call-template name="convertToAribaDate">													<xsl:with-param name="dateTime">														<xsl:value-of select="S_DTM/C_C507[D_2005 = '351']/D_2380"/>													</xsl:with-param>													<xsl:with-param name="dateTimeFormat">														<xsl:value-of select="S_DTM/C_C507[D_2005 = '351']/D_2380"/>													</xsl:with-param>												</xsl:call-template>											</xsl:attribute>										</xsl:if>										<xsl:element name="SubtotalAmount">											<xsl:call-template name="createMoneyAlt">												<xsl:with-param name="value" select="G_SG26/S_MOA/C_C516[D_5025 = '79']/D_5004"/>												<xsl:with-param name="cur">													<xsl:choose>														<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '79']/D_6345!=''">															<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '79']/D_6345"/>														</xsl:when>														<xsl:otherwise>															<xsl:value-of select="$currHead"/>														</xsl:otherwise>													</xsl:choose>												</xsl:with-param>												<xsl:with-param name="altvalue" select="G_SG26/S_MOA/C_C516[D_5025 = '79'][D_6343='11']/D_5004"></xsl:with-param>												<xsl:with-param name="altcur">													<xsl:choose>														<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '79'][D_6343='11']/D_6345!=''">															<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '79'][D_6343='11']/D_6345"/>														</xsl:when>														<xsl:otherwise>															<xsl:value-of select="$altCurrHead"/>														</xsl:otherwise>													</xsl:choose>												</xsl:with-param>												<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>											</xsl:call-template>										</xsl:element>										<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != '' and S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">											<xsl:element name="Period">												<xsl:attribute name="startDate">													<xsl:call-template name="convertToAribaDate">														<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>														<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>													</xsl:call-template>												</xsl:attribute>												<xsl:attribute name="endDate">													<xsl:call-template name="convertToAribaDate">														<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>														<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>													</xsl:call-template>												</xsl:attribute>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG26/S_MOA/C_C516[D_5025='176']/D_5004!=''">											<xsl:element name="Tax">												<xsl:call-template name="createMoney">													<xsl:with-param name="MOA" select="G_SG26/S_MOA/C_C516[D_5025='176']"/>													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>												</xsl:call-template>												<xsl:element name="Description">													<xsl:choose>														<xsl:when test="S_FTX[D_4451='TXD'][not(exists(D_4453)) or D_4453!='3']/C_C108/D_4440!=''">															<xsl:attribute name="xml:lang">																<xsl:choose>																	<xsl:when test="S_FTX[D_4451='TXD'][not(exists(D_4453)) or D_4453!='3'][1]/D_3453!=''">																		<xsl:value-of select="S_FTX[D_4451='TXD'][not(exists(D_4453)) or D_4453!='3'][1]/D_3453"/>																	</xsl:when>																	<xsl:otherwise>en</xsl:otherwise>																</xsl:choose>															</xsl:attribute>															<xsl:for-each select="S_FTX[D_4451='TXD'][not(exists(D_4453)) or D_4453!='3']">																<xsl:value-of select="concat(C_C108/D_4440,C_C108/D_4440_2,C_C108/D_4440_3,C_C108/D_4440_4,C_C108/D_4440_5)"/>															</xsl:for-each>														</xsl:when>														<xsl:otherwise>															<xsl:attribute name="xml:lang">en</xsl:attribute>															<xsl:text/>														</xsl:otherwise>													</xsl:choose>												</xsl:element>												<xsl:for-each select="G_SG33[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">													<xsl:variable name="taxCategory">														<xsl:choose>															<xsl:when test="S_TAX/C_C241/D_5153 = 'LOC' or S_TAX/C_C241/D_5153 = 'STT'">																<xsl:choose>																	<xsl:when test="S_TAX/C_C241/D_5152 = '.qc.ca'">																		<xsl:text>qst</xsl:text>																	</xsl:when>																	<xsl:when test="S_TAX/C_C241/D_5152 = '.ns.ca' or S_TAX/C_C241/D_5152 = '.nf.ca' or S_TAX/C_C241/D_5152 = '.nb.ca' or S_TAX/C_C241/D_5152 = '.on.ca'">																		<xsl:text>hst</xsl:text>																	</xsl:when>																	<xsl:when test="contains(S_TAX/C_C241/D_5152, '.ca')">																		<xsl:text>pst</xsl:text>																	</xsl:when>																	<xsl:otherwise>																		<xsl:text>sales</xsl:text>																	</xsl:otherwise>																</xsl:choose>															</xsl:when>															<xsl:when test="S_TAX/C_C241/D_5153 = 'VAT'">																<xsl:text>vat</xsl:text>															</xsl:when>															<xsl:otherwise>																<xsl:text>other</xsl:text>															</xsl:otherwise>														</xsl:choose>													</xsl:variable>													<xsl:variable name="vatNum">														<xsl:value-of select="S_TAX/D_3446"/>													</xsl:variable>													<xsl:element name="TaxDetail">														<xsl:attribute name="purpose">															<xsl:choose>																<xsl:when test="S_TAX/D_5283 = '5'">																	<xsl:text>duty</xsl:text>																</xsl:when>																<xsl:when test="S_TAX/D_5283 = '7'">																	<xsl:text>tax</xsl:text>																</xsl:when>															</xsl:choose>														</xsl:attribute>														<xsl:attribute name="category">															<xsl:value-of select="$taxCategory"/>														</xsl:attribute>														<xsl:if test="S_TAX/C_C243/D_5278 != ''">															<xsl:attribute name="percentageRate">																<xsl:value-of select="S_TAX/C_C243/D_5278"/>															</xsl:attribute>														</xsl:if>														<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">															<xsl:variable name="tpDate">																<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154=$vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2380"/>															</xsl:variable>															<xsl:variable name="tpDateFormat">																<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154=$vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2379"/>															</xsl:variable>															<xsl:variable name="payDate">																<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154=$vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2380"/>															</xsl:variable>															<xsl:variable name="payDateFormat">																<xsl:value-of select="../G_SG29[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154=$vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2379"/>															</xsl:variable>															<xsl:if test="$tpDate!=''">																<xsl:attribute name="taxPointDate">																	<xsl:call-template name="convertToAribaDate">																		<xsl:with-param name="dateTime" select="$tpDate"/>																		<xsl:with-param name="dateTimeFormat" select="$tpDateFormat"/>																	</xsl:call-template>																</xsl:attribute>															</xsl:if>															<xsl:if test="$payDate!=''">																<xsl:attribute name="paymentDate">																	<xsl:call-template name="convertToAribaDate">																		<xsl:with-param name="dateTime">																			<xsl:value-of select="$payDate"/>																		</xsl:with-param>																		<xsl:with-param name="dateTimeFormat">																			<xsl:value-of select="$payDateFormat"/>																		</xsl:with-param>																	</xsl:call-template>																</xsl:attribute>															</xsl:if>															<xsl:attribute name="isTriangularTransaction">yes</xsl:attribute>														</xsl:if>														<xsl:choose>															<xsl:when test="S_TAX/D_5305 = 'Z'">																<xsl:attribute name="exemptDetail">																	<xsl:text>zeroRated</xsl:text>																</xsl:attribute>															</xsl:when>															<xsl:when test="S_TAX/D_5305 = 'E'">																<xsl:attribute name="exemptDetail">																	<xsl:text>exempt</xsl:text>																</xsl:attribute>															</xsl:when>														</xsl:choose>														<xsl:if test="S_TAX/D_5286 != ''">															<xsl:element name="TaxableAmount">																<xsl:element name="Money">																	<xsl:attribute name="currency">																		<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>																	</xsl:attribute>																	<xsl:choose>																		<xsl:when test="$isCreditMemo = 'yes'">																			<xsl:value-of select="concat('-', S_TAX/D_5286)"/>																		</xsl:when>																		<xsl:otherwise>																			<xsl:value-of select="S_TAX/D_5286"/>																		</xsl:otherwise>																	</xsl:choose>																</xsl:element>															</xsl:element>														</xsl:if>														<xsl:element name="TaxAmount">															<xsl:element name="Money">																<xsl:attribute name="currency">																	<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>																</xsl:attribute>																<xsl:choose>																	<xsl:when test="$isCreditMemo = 'yes'">																		<xsl:value-of select="concat('-', S_MOA/C_C516[D_5025 = '124']/D_5004)"/>																	</xsl:when>																	<xsl:otherwise>																		<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_5004"/>																	</xsl:otherwise>																</xsl:choose>															</xsl:element>														</xsl:element>														<xsl:if test="S_TAX/C_C241/D_5152 != ''">															<xsl:element name="TaxLocation">																<xsl:attribute name="xml:lang">en</xsl:attribute>																<xsl:value-of select="S_TAX/C_C241/D_5152"/>															</xsl:element>														</xsl:if>														<xsl:choose>															<xsl:when test="not(S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat') and S_TAX/D_3446 != ''">																<xsl:element name="Description">																	<xsl:attribute name="xml:lang">en</xsl:attribute>																	<xsl:value-of select="S_TAX/D_3446"/>																</xsl:element>															</xsl:when>															<xsl:when test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat' and normalize-space(../G_SG29/S_RFF/C_C506[D_1153 = 'VA' and D_1154=$vatNum]/D_4000)!=''">																<xsl:element name="Description">																	<xsl:attribute name="xml:lang">en</xsl:attribute>																	<xsl:value-of select="normalize-space(../G_SG29/S_RFF/C_C506[D_1153 = 'VA' and D_1154=$vatNum]/D_4000)"/>																</xsl:element>															</xsl:when>														</xsl:choose>														<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">															<xsl:if test="S_FTX[D_4451='TXD'][D_4453='3']/C_C108/D_4440!=''">																<xsl:element name="TriangularTransactionLawReference">																	<xsl:attribute name="xml:lang">																		<xsl:choose>																			<xsl:when test="S_FTX[D_4451='TXD'][D_4453='3'][1]/D_3453!=''">																				<xsl:value-of select="S_FTX[D_4451='TXD'][D_4453='3'][1]/D_3453"/>																			</xsl:when>																			<xsl:otherwise>en</xsl:otherwise>																		</xsl:choose>																	</xsl:attribute>																	<xsl:for-each select="S_FTX[D_4451='TXD'][D_4453='3']">																		<xsl:value-of select="concat(C_C108/D_4440,C_C108/D_4440_2,C_C108/D_4440_3,C_C108/D_4440_4,C_C108/D_4440_5)"/>																	</xsl:for-each>																</xsl:element>															</xsl:if>														</xsl:if>														<xsl:if test="S_TAX/C_C243/D_5279 != ''">															<xsl:element name="Extrinsic">																<xsl:attribute name="name">																	<xsl:text>taxAccountcode</xsl:text>																</xsl:attribute>																<xsl:value-of select="S_TAX/C_C243/D_5279"/>															</xsl:element>														</xsl:if>														<xsl:if test="S_LOC[D_3227='157']/C_C517/D_3225!= ''">															<xsl:element name="Extrinsic">																<xsl:attribute name="name">																	<xsl:text>taxJurisdiction</xsl:text>																</xsl:attribute>																<xsl:value-of select="S_LOC[D_3227='157']/C_C517/D_3225"/>															</xsl:element>														</xsl:if>														<xsl:if test="S_TAX/D_5305 = 'S'">															<xsl:element name="Extrinsic">																<xsl:attribute name="name">																	<xsl:text>exemptType</xsl:text>																</xsl:attribute>																<xsl:text>Standard</xsl:text>															</xsl:element>														</xsl:if>													</xsl:element>												</xsl:for-each>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '130']/D_5004 != ''">											<xsl:element name="InvoiceDetailLineSpecialHandling">												<xsl:if test="S_FTX[D_4451 = 'SPH']/C_C108/D_4440 != ''">													<xsl:element name="Description">														<xsl:attribute name="xml:lang">															<xsl:choose>																<xsl:when test="S_FTX[D_4451 = 'SPH']/D_3453 != ''">																	<xsl:value-of select="S_FTX[D_4451 = 'SPH']/D_3453"/>																</xsl:when>																<xsl:otherwise>en</xsl:otherwise>															</xsl:choose>														</xsl:attribute>														<xsl:value-of select="concat(S_FTX[D_4451 = 'SPH']/C_C108/D_4440, S_FTX[D_4451 = 'SPH']/C_C108/D_4440_2, S_FTX[D_4451 = 'SPH']/C_C108/D_4440_3, S_FTX[D_4451 = 'SPH']/C_C108/D_4440_4, S_FTX[D_4451 = 'SPH']/C_C108/D_4440_5)"/>													</xsl:element>												</xsl:if>												<xsl:call-template name="createMoney">													<xsl:with-param name="MOA" select="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'SH']/G_SG41/S_MOA/C_C516[D_5025 = '52']"/>													<xsl:with-param name="altMOA" select="G_SG38[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'SH']/G_SG41/S_MOA/C_C516[D_5025 = '52'][D_6343='11']"/>													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>												</xsl:call-template>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '64']/D_5004 != ''">											<xsl:element name="InvoiceDetailLineShipping">												<xsl:element name="InvoiceDetailShipping">													<xsl:if test="S_DTM/C_C507[D_2005 = '110']/D_2380 != ''">														<xsl:attribute name="shippingDate">															<xsl:call-template name="convertToAribaDate">																<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '110']/D_2380"/>																<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '110']/D_2379"/>															</xsl:call-template>														</xsl:attribute>													</xsl:if>													<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'SF' or S_NAD/D_3035 = 'ST' or S_NAD/D_3035 = 'CA']">														<xsl:apply-templates select=".">															<xsl:with-param name="role" select="S_NAD/D_3035"/>														</xsl:apply-templates>													</xsl:for-each>													<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'CA']">														<xsl:if test="S_NAD/C_C082/D_1131 = '172'">															<xsl:choose>																<xsl:when test="S_NAD/C_C082/D_3055 = '3'">																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>IATA</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="S_NAD/C_C082/D_3039"/>																	</xsl:element>																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>companyName</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>																	</xsl:element>																</xsl:when>																<xsl:when test="S_NAD/C_C082/D_3055 = '9'">																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>EAN</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="S_NAD/C_C082/D_3039"/>																	</xsl:element>																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>companyName</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>																	</xsl:element>																</xsl:when>																<xsl:when test="S_NAD/C_C082/D_3055 = '12'">																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>UIC</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="S_NAD/C_C082/D_3039"/>																	</xsl:element>																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>companyName</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>																	</xsl:element>																</xsl:when>																<xsl:when test="S_NAD/C_C082/D_3055 = '16'">																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>DUNS</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="S_NAD/C_C082/D_3039"/>																	</xsl:element>																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>companyName</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>																	</xsl:element>																</xsl:when>																<xsl:when test="S_NAD/C_C082/D_3055 = '182'">																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>SCAC</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="S_NAD/C_C082/D_3039"/>																	</xsl:element>																	<xsl:element name="CarrierIdentifier">																		<xsl:attribute name="domain">																			<xsl:text>companyName</xsl:text>																		</xsl:attribute>																		<xsl:value-of select="concat(S_NAD/C_C058/D_3124, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"/>																	</xsl:element>																</xsl:when>															</xsl:choose>														</xsl:if>													</xsl:for-each>													<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'CA']">														<xsl:variable name="role">															<xsl:value-of select="S_NAD/D_3035"/>														</xsl:variable>														<xsl:for-each select="G_SG35">															<xsl:choose>																<xsl:when test="$role = 'CA' and S_RFF/C_C506/D_1153 = 'CN'">																	<xsl:element name="ShipmentIdentifier">																		<xsl:if test="S_DTM/C_C507/D_2005 = '89'">																			<xsl:attribute name="trackingNumberDate">																				<xsl:call-template name="convertToAribaDate">																					<xsl:with-param name="dateTime">																						<xsl:value-of select="S_DTM/C_C507[D_2005 = '89']/D_2380"/>																					</xsl:with-param>																					<xsl:with-param name="dateTimeFormat">																						<xsl:value-of select="S_DTM/C_C507[D_2005 = '89']/D_2379"/>																					</xsl:with-param>																				</xsl:call-template>																			</xsl:attribute>																		</xsl:if>																		<xsl:value-of select="S_RFF/C_C506/D_1154"/>																	</xsl:element>																</xsl:when>															</xsl:choose>														</xsl:for-each>													</xsl:for-each>												</xsl:element>												<xsl:call-template name="createMoneyAlt">													<xsl:with-param name="value" select="G_SG26/S_MOA/C_C516[D_5025 = '64']/D_5004"/>													<xsl:with-param name="cur">														<xsl:choose>															<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '64']/D_6345!=''">																<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '64']/D_6345"/>															</xsl:when>															<xsl:otherwise>																<xsl:value-of select="$currHead"/>															</xsl:otherwise>														</xsl:choose>													</xsl:with-param>													<xsl:with-param name="altvalue" select="G_SG26/S_MOA/C_C516[D_5025 = '64'][D_6343='11']/D_5004"></xsl:with-param>													<xsl:with-param name="altcur">														<xsl:choose>															<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '64'][D_6343='11']/D_6345!=''">																<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '64'][D_6343='11']/D_6345"/>															</xsl:when>															<xsl:otherwise>																<xsl:value-of select="$altCurrHead"/>															</xsl:otherwise>														</xsl:choose>													</xsl:with-param>													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>												</xsl:call-template>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '128']/D_5004 != ''">											<xsl:element name="GrossAmount">												<xsl:call-template name="createMoneyAlt">													<xsl:with-param name="value" select="G_SG26/S_MOA/C_C516[D_5025 = '128']/D_5004"/>													<xsl:with-param name="cur">														<xsl:choose>															<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '128']/D_6345!=''">																<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '128']/D_6345"/>															</xsl:when>															<xsl:otherwise>																<xsl:value-of select="$currHead"/>															</xsl:otherwise>														</xsl:choose>													</xsl:with-param>													<xsl:with-param name="altvalue" select="G_SG26/S_MOA/C_C516[D_5025 = '128'][D_6343='11']/D_5004"></xsl:with-param>													<xsl:with-param name="altcur">														<xsl:choose>															<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '128'][D_6343='11']/D_6345!=''">																<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '128'][D_6343='11']/D_6345"/>															</xsl:when>															<xsl:otherwise>																<xsl:value-of select="$altCurrHead"/>															</xsl:otherwise>														</xsl:choose>													</xsl:with-param>													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>												</xsl:call-template>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_MOA/C_C516[D_5025 = '52']/D_5004!= ''">											<xsl:element name="InvoiceDetailDiscount">												<xsl:if test="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG40/S_PCD/C_C501/D_5245 = '1' and G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG40/S_PCD/C_C501/D_5249 = '13'">													<xsl:attribute name="percentageRate">														<xsl:value-of select="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG40/S_PCD/C_C501/D_5482"/>													</xsl:attribute>												</xsl:if>												<xsl:call-template name="createMoney">													<xsl:with-param name="MOA" select="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_MOA/C_C516[D_5025 = '52']"/>													<xsl:with-param name="altMOA" select="G_SG38[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_MOA/C_C516[D_5025 = '52'][D_6343='11']"></xsl:with-param>													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>												</xsl:call-template>											</xsl:element>										</xsl:if>										<xsl:if test="G_SG26/S_MOA/C_C516[D_5025 = '38']/D_5004 != ''">											<xsl:element name="NetAmount">												<xsl:call-template name="createMoneyAlt">													<xsl:with-param name="value" select="G_SG26/S_MOA/C_C516[D_5025 = '38']/D_5004"/>													<xsl:with-param name="cur">														<xsl:choose>															<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '38']/D_6345!=''">																<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '38']/D_6345"/>															</xsl:when>															<xsl:otherwise>																<xsl:value-of select="$currHead"/>															</xsl:otherwise>														</xsl:choose>													</xsl:with-param>													<xsl:with-param name="altvalue" select="G_SG26/S_MOA/C_C516[D_5025 = '38'][D_6343='11']/D_5004"></xsl:with-param>													<xsl:with-param name="altcur">														<xsl:choose>															<xsl:when test="G_SG26/S_MOA/C_C516[D_5025 = '38'][D_6343='11']/D_6345!=''">																<xsl:value-of select="G_SG26/S_MOA/C_C516[D_5025 = '38'][D_6343='11']/D_6345"/>															</xsl:when>															<xsl:otherwise>																<xsl:value-of select="$altCurrHead"/>															</xsl:otherwise>														</xsl:choose>													</xsl:with-param>													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>												</xsl:call-template>											</xsl:element>										</xsl:if>										<xsl:variable name="comment">											<xsl:for-each select="S_FTX[D_4451 = 'AAI']">												<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>											</xsl:for-each>										</xsl:variable>										<xsl:variable name="commentLang">											<xsl:for-each select="S_FTX[D_4451 = 'AAI']">												<xsl:value-of select="D_3453"/>											</xsl:for-each>										</xsl:variable>										<xsl:if test="$comment!=''">											<xsl:element name="Comments">												<xsl:attribute name="xml:lang">													<xsl:choose>														<xsl:when test="$commentLang!= ''">															<xsl:value-of select="substring($commentLang, 1, 2)"/>														</xsl:when>														<xsl:otherwise>en</xsl:otherwise>													</xsl:choose>												</xsl:attribute>												<xsl:value-of select="$comment"/>											</xsl:element>										</xsl:if>										<xsl:for-each select="S_FTX[D_4451 = 'ZZZ']">											<xsl:element name="Extrinsic">												<xsl:attribute name="name">													<xsl:value-of select="C_C108/D_4440"/>												</xsl:attribute>												<xsl:value-of select="concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>											</xsl:element>										</xsl:for-each>										<xsl:for-each select="G_SG29/S_RFF/C_C506[D_1153 = 'ZZZ']">											<xsl:element name="Extrinsic">												<xsl:attribute name="name">													<xsl:value-of select="./D_1154"/>												</xsl:attribute>												<xsl:value-of select="./D_4000"/>											</xsl:element>										</xsl:for-each>									</xsl:element>								</xsl:element>								</xsl:if>							</xsl:for-each>						</xsl:when>						-->
						<!-- Summary Invoice -->
						<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '385'">
							<xsl:variable name="itemCount" select="count(M_INVOIC/G_SG25)"/>
							<xsl:variable name="onCount" select="count(//G_SG29/S_RFF/C_C506[D_1153 = 'ON'])"/>
							<xsl:variable name="vnCount" select="count(//G_SG29/S_RFF/C_C506[D_1153 = 'VN'])"/>
							<xsl:variable name="ctCount" select="count(//G_SG29/S_RFF/C_C506[D_1153 = 'CT'])"/>
							<xsl:variable name="groupType">
								<xsl:choose>
									<xsl:when test="$itemCount = $onCount">ON</xsl:when>
									<xsl:when test="$itemCount = $vnCount">VN</xsl:when>
									<xsl:when test="$itemCount = $ctCount">CN</xsl:when>
									<xsl:otherwise>ON</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:for-each-group select="M_INVOIC/G_SG25" group-by="G_SG29/S_RFF/C_C506[D_1153 = $groupType]/D_1154">
								<xsl:element name="InvoiceDetailOrder">
									<xsl:element name="InvoiceDetailOrderInfo">
										<!-- OrderReference -->
										<xsl:if test="current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != '' or current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
											<xsl:element name="OrderReference">
												<xsl:if test="current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
													<xsl:attribute name="orderID">
														<xsl:value-of select="(current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'ON']/D_1154)[1]"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDatePORef">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="(current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380)[1]"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="(current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379)[1]"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
												<DocumentReference payloadID=""/>
											</xsl:element>
										</xsl:if>
										<!-- MasterAgreementReference -->
										<xsl:if test="current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != '' or current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
											<xsl:element name="MasterAgreementReference">
												<xsl:if test="current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">
													<xsl:attribute name="agreementID">
														<xsl:value-of select="(current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'CT']/D_1154)[1]"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
													<xsl:attribute name="agreementDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="(current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380)[1]"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="(current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2379)[1]"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'CT']/D_1156 = '1'">
													<xsl:attribute name="agreementType">
														<xsl:text>scheduling_agreement</xsl:text>
													</xsl:attribute>
												</xsl:if>
												<DocumentReference payloadID=""/>
											</xsl:element>
										</xsl:if>
										<!-- SupplierOrderInfo -->
										<xsl:if test="current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != '' or current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
											<xsl:element name="SupplierOrderInfo">
												<xsl:if test="current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
													<xsl:attribute name="orderID">
														<xsl:value-of select="(current-group()//G_SG29/S_RFF/C_C506[D_1153 = 'VN']/D_1154)[1]"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDatePORef">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="(current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380)[1]"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="(current-group()//G_SG29[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2379)[1]"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
											</xsl:element>
										</xsl:if>
									</xsl:element>
									<xsl:for-each select="current-group()">
										<xsl:apply-templates select=".">
											<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
											<xsl:with-param name="itemMode">
												<xsl:choose>
													<xsl:when test="S_IMD[D_7077 = 'C']/C_C273/D_7009 = 'SER'">service</xsl:when>
													<xsl:otherwise>item</xsl:otherwise>
												</xsl:choose>
											</xsl:with-param>
										</xsl:apply-templates>
									</xsl:for-each>
								</xsl:element>
							</xsl:for-each-group>
						</xsl:when>
						<!-- Detail Invoice -->
						<xsl:otherwise>
							<xsl:element name="InvoiceDetailOrder">
								<xsl:element name="InvoiceDetailOrderInfo">
									<!-- OrderReference -->
									<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
										<xsl:element name="OrderReference">
											<xsl:attribute name="orderID">
												<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDatePORef">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDatePORef">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
											<DocumentReference payloadID=""/>
										</xsl:element>
									</xsl:if>
									<!-- MasterAgreementReference -->
									<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">
										<xsl:element name="MasterAgreementReference">
											<xsl:attribute name="agreementID">
												<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1154"/>
											</xsl:attribute>
											<xsl:if test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
												<xsl:attribute name="agreementDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="dateTime">
															<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380"/>
														</xsl:with-param>
														<xsl:with-param name="dateTimeFormat">
															<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2379"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'CT']/D_1156 = '1'">
												<xsl:attribute name="agreementType">
													<xsl:text>scheduling_agreement</xsl:text>
												</xsl:attribute>
											</xsl:if>
											<DocumentReference payloadID=""/>
										</xsl:element>
									</xsl:if>
									<!-- SupplierOrderInfo -->
									<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
										<xsl:element name="SupplierOrderInfo">
											<xsl:attribute name="orderID">
												<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154"/>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDatePORef">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDatePORef">
															<xsl:with-param name="dateTime">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
										</xsl:element>
									</xsl:if>
								</xsl:element>
								<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ALO']/D_1154 != ''">
									<xsl:element name="InvoiceDetailReceiptInfo">
										<xsl:element name="ReceiptIDInfo">
											<xsl:attribute name="receiptID">
												<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ALO']/D_1154"/>
											</xsl:attribute>
											<xsl:if test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ALO']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
												<xsl:attribute name="receiptDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="dateTime">
															<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ALO']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
														</xsl:with-param>
														<xsl:with-param name="dateTimeFormat">
															<xsl:value-of select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ALO']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
										</xsl:element>
									</xsl:element>
								</xsl:if>
								<xsl:for-each select="M_INVOIC/G_SG25[G_SG29/S_RFF/C_C506/D_1153 = 'AAK'][1]">
									<xsl:element name="InvoiceDetailShipNoticeInfo">
										<xsl:element name="ShipNoticeReference">
											<xsl:attribute name="shipNoticeID" select="G_SG29/S_RFF/C_C506[D_1153 = 'AAK']/D_1154"/>
											<xsl:if test="G_SG29/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
												<xsl:attribute name="shipNoticeDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="dateTime" select="G_SG29/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
														<xsl:with-param name="dateTimeFormat" select="G_SG29/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
													</xsl:call-template>
												</xsl:attribute>
											</xsl:if>
											<xsl:element name="DocumentReference">
												<xsl:attribute name="payloadID"/>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
								<xsl:for-each select="M_INVOIC/G_SG25">
									<xsl:apply-templates select=".">
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
										<xsl:with-param name="currHead" select="$currHead"/>
										<xsl:with-param name="altCurrHead" select="$altCurrHead"/>
										<xsl:with-param name="itemMode">
											<xsl:choose>
												<xsl:when test="S_IMD[D_7077 = 'C']/C_C273/D_7009 = 'SER'">service</xsl:when>
												<xsl:otherwise>item</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:apply-templates>
								</xsl:for-each>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:element name="InvoiceDetailSummary">
						<xsl:element name="SubtotalAmount">
							<xsl:call-template name="createMoney">
								<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '79'][1]"/>
								<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '79'][D_6343 = '11']"/>
								<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
							</xsl:call-template>
						</xsl:element>
						<xsl:element name="Tax">
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '176']/D_5004 != ''">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '176'][1]"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '176'][D_6343 = '11']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '124']/D_5004 != ''">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '124'][1]"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '124'][D_6343 = '11']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="Money">
										<xsl:attribute name="currency">
											<xsl:choose>
												<xsl:when test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '79']/D_6345 != ''">
													<xsl:value-of select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '79']/D_6345"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$headerCurrency"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:text>0.00</xsl:text>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:element name="Description">
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="M_INVOIC/S_FTX[D_4451 = 'TXD'][normalize-space(D_4453) = '']/D_3453 != ''">
											<xsl:value-of select="M_INVOIC/S_FTX[D_4451 = 'TXD'][normalize-space(D_4453) = ''][1]/D_3453"/>
										</xsl:when>
										<xsl:otherwise>en</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:choose>
									<xsl:when test="M_INVOIC/S_FTX[D_4451 = 'TXD'][normalize-space(D_4453) = '']/C_C108/D_4440 != ''">
										<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'TXD'][normalize-space(D_4453) = '']">
											<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:for-each select="M_INVOIC/G_SG50[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">
								<xsl:variable name="taxCategory">
									<xsl:choose>
										<xsl:when test="S_TAX/C_C241/D_5153 = 'GST'">
											<xsl:text>gst</xsl:text>
										</xsl:when>
										<xsl:when test="S_TAX/C_C241/D_5153 = 'VAT'">
											<xsl:text>vat</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>other</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="vatNum">
									<xsl:value-of select="S_TAX/D_3446"/>
								</xsl:variable>
								<xsl:element name="TaxDetail">
									<xsl:attribute name="purpose">
										<xsl:choose>
											<xsl:when test="S_TAX/D_5283 = '5'">
												<xsl:text>duty</xsl:text>
											</xsl:when>
											<xsl:when test="S_TAX/D_5283 = '7'">
												<xsl:text>tax</xsl:text>
											</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="category">
										<xsl:value-of select="$taxCategory"/>
									</xsl:attribute>
									<xsl:if test="S_TAX/C_C243/D_5278 != ''">
										<xsl:attribute name="percentageRate">
											<xsl:value-of select="S_TAX/C_C243/D_5278"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="S_TAX/C_C243/D_5279 != ''">
										<xsl:attribute name="taxRateType">
											<xsl:value-of select="S_TAX/C_C243/D_5279"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
										<xsl:variable name="tpDate">
											<xsl:value-of select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2380"/>
										</xsl:variable>
										<xsl:variable name="tpDateFormat">
											<xsl:value-of select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2379"/>
										</xsl:variable>
										<xsl:variable name="payDate">
											<xsl:value-of select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2380"/>
										</xsl:variable>
										<xsl:variable name="payDateFormat">
											<xsl:value-of select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2379"/>
										</xsl:variable>
										<xsl:if test="$tpDate != ''">
											<xsl:attribute name="taxPointDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime" select="$tpDate"/>
													<xsl:with-param name="dateTimeFormat" select="$tpDateFormat"/>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="$payDate != ''">
											<xsl:attribute name="paymentDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime">
														<xsl:value-of select="$payDate"/>
													</xsl:with-param>
													<xsl:with-param name="dateTimeFormat">
														<xsl:value-of select="$payDateFormat"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="isTriangularTransaction">yes</xsl:attribute>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="S_TAX/D_5305 = 'Z'">
											<xsl:attribute name="exemptDetail">
												<xsl:text>zeroRated</xsl:text>
											</xsl:attribute>
										</xsl:when>
										<xsl:when test="S_TAX/D_5305 = 'E'">
											<xsl:attribute name="exemptDetail">
												<xsl:text>exempt</xsl:text>
											</xsl:attribute>
										</xsl:when>
									</xsl:choose>
									<!-- TaxableAmount -->
									<xsl:choose>
										<xsl:when test="S_MOA/C_C516[D_5025 = '125']/D_5004 != ''">
											<xsl:element name="TaxableAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '125'][1]"/>
													<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '125'][D_6343 = '11']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_TAX/D_5286 != ''">
											<xsl:element name="TaxableAmount">
												<xsl:element name="Money">
													<xsl:attribute name="currency">
														<xsl:choose>
															<xsl:when test="S_MOA/C_C516[D_5025 = '124']/D_6345 != ''">
																<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$headerCurrency"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="S_TAX/D_5286 = '' or S_TAX/D_5286 = 0">
															<xsl:value-of select="S_TAX/D_5286"/>
														</xsl:when>
														<xsl:when test="$isCreditMemo = 'yes'">
															<xsl:value-of select="concat('-', S_TAX/D_5286)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="S_TAX/D_5286"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:element>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
									<xsl:element name="TaxAmount">
										<xsl:call-template name="createMoney">
											<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '124'][1]"/>
											<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '124'][D_6343 = '11']"/>
											<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
										</xsl:call-template>
									</xsl:element>
									<!-- TaxLocation -->
									<xsl:if test="S_TAX/C_C241/D_5152 != ''">
										<xsl:element name="TaxLocation">
											<xsl:attribute name="xml:lang">en</xsl:attribute>
											<xsl:value-of select="S_TAX/C_C241/D_5152"/>
										</xsl:element>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="not(S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat') and S_TAX/D_3446 != ''">
											<xsl:element name="Description">
												<xsl:attribute name="xml:lang">en</xsl:attribute>
												<xsl:value-of select="S_TAX/D_3446"/>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat' and normalize-space(//M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000) != ''">
											<xsl:element name="Description">
												<xsl:attribute name="xml:lang">en</xsl:attribute>
												<xsl:value-of select="normalize-space(//M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000)"/>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
									<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
										<xsl:if test="../S_FTX[D_4451 = 'TXD'][D_4453 = '3']/C_C108/D_4440 != ''">
											<xsl:element name="TriangularTransactionLawReference">
												<xsl:attribute name="xml:lang">
													<xsl:choose>
														<xsl:when test="../S_FTX[D_4451 = 'TXD'][D_4453 = '3'][1]/D_3453 != ''">
															<xsl:value-of select="../S_FTX[D_4451 = 'TXD'][D_4453 = '4'][1]/D_3453"/>
														</xsl:when>
														<xsl:otherwise>en</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:for-each select="../S_FTX[D_4451 = 'TXD'][D_4453 = '3']">
													<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
												</xsl:for-each>
											</xsl:element>
										</xsl:if>
									</xsl:if>
									<!--xsl:if test="S_TAX/C_C243/D_5279 != ''">										<xsl:element name="Extrinsic">											<xsl:attribute name="name">												<xsl:text>taxAccountcode</xsl:text>											</xsl:attribute>											<xsl:value-of select="S_TAX/C_C243/D_5279"/>										</xsl:element>									</xsl:if-->
									<xsl:if test="S_TAX/D_5305 = 'S' or S_TAX/D_5305 = 'A'">
										<xsl:element name="Extrinsic">
											<xsl:attribute name="name">
												<xsl:text>exemptType</xsl:text>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="S_TAX/D_5305 = 'A'">
													<xsl:text>Mixed</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Standard</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:for-each>
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG50[S_TAX/C_C533/D_5289 != 'TT']">
									<Extrinsic>
										<xsl:attribute name="name">
											<xsl:text>taxAccountCode</xsl:text>
										</xsl:attribute>
										<xsl:value-of select="M_INVOIC/G_SG50[S_TAX/C_C533/D_5289 != 'TT'][1]/S_TAX/C_C533/D_5289"/>
									</Extrinsic>
								</xsl:when>
								<xsl:when test="M_INVOIC/G_SG6[S_TAX/C_C533/D_5289 != 'TT']">
									<Extrinsic>
										<xsl:attribute name="name">
											<xsl:text>taxAccountCode</xsl:text>
										</xsl:attribute>
										<xsl:value-of select="M_INVOIC/G_SG6[S_TAX/C_C533/D_5289 != 'TT'][1]/S_TAX/C_C533/D_5289"/>
									</Extrinsic>
								</xsl:when>
							</xsl:choose>
						</xsl:element>
						<!-- SpecialHandlingAmount -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '130']/D_5004 != ''">
							<xsl:element name="SpecialHandlingAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '130'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '130'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
								<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'SPH']/C_C108/D_4440 != ''">
									<xsl:element name="Description">
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="M_INVOIC/S_FTX[D_4451 = 'SPH']/D_3453 != ''">
													<xsl:value-of select="M_INVOIC/S_FTX[D_4451 = 'SPH']/D_3453"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:value-of select="concat(M_INVOIC/S_FTX[D_4451 = 'SPH']/C_C108/D_4440, M_INVOIC/S_FTX[D_4451 = 'SPH']/C_C108/D_4440_2, M_INVOIC/S_FTX[D_4451 = 'SPH']/C_C108/D_4440_3, M_INVOIC/S_FTX[D_4451 = 'SPH']/C_C108/D_4440_4, M_INVOIC/S_FTX[D_4451 = 'SPH']/C_C108/D_4440_5)"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<!-- ShippingAmount -->
						<xsl:if test="M_INVOIC/G_SG15[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'FC']/G_SG19/S_MOA/C_C516[D_5025 = '23']/D_5004 != ''">
							<xsl:element name="ShippingAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG15[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'FC']/G_SG19/S_MOA/C_C516[D_5025 = '23'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG15[S_ALC/D_5463 = 'C' and S_ALC/C_C214/D_7161 = 'FC']/G_SG19/S_MOA/C_C516[D_5025 = '23'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- GrossAmount -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '128']/D_5004 != ''">
							<xsl:element name="GrossAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '128'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '128'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- InvoiceDetailDiscount -->
						<xsl:if test="M_INVOIC/G_SG15[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG19/S_MOA/C_C516[D_5025 = '52']/D_5004 != ''">
							<xsl:element name="InvoiceDetailDiscount">
								<xsl:if test="M_INVOIC/G_SG15[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG18/S_PCD/C_C501/D_5245 = '12' and M_INVOIC/G_SG15[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG18/S_PCD/C_C501/D_5249 = '13'">
									<xsl:attribute name="percentageRate">
										<xsl:value-of select="M_INVOIC/G_SG15[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG18/S_PCD/C_C501/D_5482"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG15[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG19/S_MOA/C_C516[D_5025 = '52'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG15[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG19/S_MOA/C_C516[D_5025 = '52'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- Modification updates -->
						<xsl:variable name="pcdAllowed" select="'|1|2|3|'"/>
						<xsl:variable name="moaAllowed" select="'|8|23|204|'"/>
						<xsl:variable name="cleanALCList">
							<xsl:for-each select="M_INVOIC/G_SG15[S_ALC/D_5463 = 'C' or S_ALC/D_5463 = 'A']">
								<xsl:choose>
									<xsl:when test="(S_ALC/D_5463 = 'C') and (contains($pcdAllowed, G_SG18/S_PCD/C_C501/D_5245) or (G_SG19[S_MOA/C_C516/D_5025 = '8'] or G_SG19[S_MOA/C_C516/D_5025 = '23'] or G_SG19[S_MOA/C_C516/D_5025 = '204']))">
										<G_ALC>
											<xsl:copy-of select="./child::*"/>
										</G_ALC>
									</xsl:when>
									<xsl:when test="(S_ALC/D_5463 = 'A') and (contains($pcdAllowed, G_SG18/S_PCD/C_C501/D_5245) or (G_SG19[S_MOA/C_C516/D_5025 = '8'] or G_SG19[S_MOA/C_C516/D_5025 = '23'] or G_SG19[S_MOA/C_C516/D_5025 = '204']))">
										<G_ALC>
											<xsl:copy-of select="./child::*"/>
										</G_ALC>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:if test="count($cleanALCList/G_ALC) &gt; 0">
							<xsl:element name="InvoiceHeaderModifications">
								<xsl:for-each select="$cleanALCList/G_ALC">
									<xsl:variable name="modCode">
										<xsl:value-of select="./S_ALC/C_C214/D_7161"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="S_ALC/D_5463 = 'A'">
											<xsl:element name="Modification">
												<xsl:if test="S_ALC/D_1227 != ''">
													<xsl:attribute name="level">
														<xsl:value-of select="S_ALC/D_1227"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="G_SG19/S_MOA/C_C516[D_5025 = '98']/D_5004 != ''">
													<xsl:element name="OriginalPrice">
														<xsl:element name="Money">
															<xsl:attribute name="currency">
																<xsl:choose>
																	<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '98']/D_6345 != ''">
																		<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '98']/D_6345"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$headerCurrency"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
															<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '98']/D_5004"/>
															<!--xsl:choose>												<xsl:when test="$isCreditMemo = 'yes'">												<xsl:value-of												select="concat('-', G_SG19/S_MOA/C_C516[D_5025 = '98']/D_5004)"												/>												</xsl:when>												<xsl:otherwise>												<xsl:value-of												select="G_SG19/S_MOA/C_C516[D_5025 = '98']/D_5004"												/>												</xsl:otherwise>												</xsl:choose-->
														</xsl:element>
													</xsl:element>
												</xsl:if>
												<xsl:element name="AdditionalDeduction">
													<xsl:choose>
														<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004 != ''">
															<xsl:element name="DeductionAmount">
																<xsl:element name="Money">
																	<xsl:attribute name="currency">
																		<xsl:choose>
																			<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_6345 != ''">
																				<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_6345"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="$headerCurrency"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:choose>
																		<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004 = '' or G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004 = '0'">
																			<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004"/>
																		</xsl:when>
																		<xsl:when test="$isCreditMemo = 'yes'">
																			<xsl:value-of select="concat('-', G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004)"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '204']/D_5004"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:element>
															</xsl:element>
														</xsl:when>
														<xsl:when test="G_SG18/S_PCD/C_C501/D_5245 != ''">
															<xsl:element name="DeductionPercent">
																<xsl:attribute name="percent">
																	<xsl:value-of select="G_SG18/S_PCD/C_C501/D_5482"/>
																</xsl:attribute>
															</xsl:element>
														</xsl:when>
														<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '296']/D_5004 != ''">
															<xsl:element name="DeductedPrice">
																<xsl:element name="Money">
																	<xsl:attribute name="currency">
																		<xsl:choose>
																			<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '296']/D_6345 != ''">
																				<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '296']/D_6345"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="$headerCurrency"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '296']/D_5004"/>
																</xsl:element>
															</xsl:element>
														</xsl:when>
													</xsl:choose>
												</xsl:element>
												<xsl:element name="ModificationDetail">
													<xsl:attribute name="name">
														<xsl:choose>
															<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
																<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$modCode"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
														<xsl:attribute name="startDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
														<xsl:attribute name="endDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:element name="Description">
														<xsl:attribute name="xml:lang">
															<xsl:text>en</xsl:text>
														</xsl:attribute>
														<xsl:if test="./S_ALC/C_C552/D_1230 != ''">
															<xsl:element name="ShortName">
																<xsl:value-of select="./S_ALC/C_C552/D_1230"/>
															</xsl:element>
														</xsl:if>
														<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
													</xsl:element>
													<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
														<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
														<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
														<xsl:if test="$codeSLookup != ''">
															<Extrinsic>
																<xsl:attribute name="name">settlementCode</xsl:attribute>
																<xsl:value-of select="$codeSLookup"/>
															</Extrinsic>
														</xsl:if>
													</xsl:if>
													<xsl:if test="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_5004 != ''">
														<Extrinsic>
															<xsl:attribute name="name">AllowanceChargeBasisAmount</xsl:attribute>
															<!-- IG-2360 : add money element inside extrinsic -->
															<Money>
																<xsl:attribute name="currency">
																	<xsl:choose>
																		<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_6345 != ''">
																			<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_6345"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$headerCurrency"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
																<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_5004"/>
															</Money>
														</Extrinsic>
													</xsl:if>
													<xsl:if test="G_SG19/S_MOA and G_SG18/S_PCD">
														<Extrinsic>
															<xsl:attribute name="name">deductionPercentage</xsl:attribute>
															<xsl:value-of select="G_SG18/S_PCD/C_C501/D_5482"/>
														</Extrinsic>
													</xsl:if>
													<xsl:if test="G_SG21/S_TAX[C_C241/D_5153 = 'VAT']/C_C243/D_5278 != ''">
														<Extrinsic>
															<xsl:attribute name="name">vatPercentageRate</xsl:attribute>
															<xsl:value-of select="G_SG21/S_TAX[C_C241/D_5153 = 'VAT'][1]/C_C243/D_5278"/>
														</Extrinsic>
													</xsl:if>
												</xsl:element>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_ALC/D_5463 = 'C'">
											<xsl:element name="Modification">
												<xsl:if test="S_ALC/D_1227 != ''">
													<xsl:attribute name="level">
														<xsl:value-of select="S_ALC/D_1227"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:element name="AdditionalCost">
													<xsl:choose>
														<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004 != ''">
															<xsl:element name="Money">
																<xsl:attribute name="currency">
																	<xsl:choose>
																		<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_6345 != ''">
																			<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_6345"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$headerCurrency"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
																<xsl:choose>
																	<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004 != '' or G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004 != '0'">
																		<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004"/>
																	</xsl:when>
																	<xsl:when test="$isCreditMemo = 'yes'">
																		<xsl:value-of select="concat('-', G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004)"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '8' or D_5025 = '23']/D_5004"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:element>
														</xsl:when>
														<xsl:when test="G_SG18/S_PCD/C_C501/D_5245 != ''">
															<xsl:element name="Percentage">
																<xsl:attribute name="percent">
																	<xsl:value-of select="G_SG18/S_PCD/C_C501/D_5482"/>
																</xsl:attribute>
															</xsl:element>
														</xsl:when>
													</xsl:choose>
												</xsl:element>
												<xsl:element name="ModificationDetail">
													<xsl:attribute name="name">
														<xsl:choose>
															<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
																<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$modCode"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
														<xsl:attribute name="startDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
														<xsl:attribute name="endDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:element name="Description">
														<xsl:attribute name="xml:lang">
															<xsl:text>en</xsl:text>
														</xsl:attribute>
														<xsl:if test="./S_ALC/C_C552/D_1230 != ''">
															<xsl:element name="ShortName">
																<xsl:value-of select="./S_ALC/C_C552/D_1230"/>
															</xsl:element>
														</xsl:if>
														<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
													</xsl:element>
													<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
														<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
														<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
														<xsl:if test="$codeSLookup != ''">
															<Extrinsic>
																<xsl:attribute name="name">settlementCode</xsl:attribute>
																<xsl:value-of select="$codeSLookup"/>
															</Extrinsic>
														</xsl:if>
													</xsl:if>
													<xsl:if test="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_5004 != ''">
														<Extrinsic>
															<xsl:attribute name="name">AllowanceChargeBasisAmount</xsl:attribute>
															<!-- IG-2360 : add money element inside extrinsic -->
															<Money>
																<xsl:attribute name="currency">
																	<xsl:choose>
																		<xsl:when test="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_6345 != ''">
																			<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_6345"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$headerCurrency"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
																<xsl:value-of select="G_SG19/S_MOA/C_C516[D_5025 = '25']/D_5004"/>
															</Money>
														</Extrinsic>
													</xsl:if>
													<xsl:if test="G_SG19/S_MOA and G_SG18/S_PCD">
														<Extrinsic>
															<xsl:attribute name="name">chargePercentage</xsl:attribute>
															<xsl:value-of select="G_SG18/S_PCD/C_C501/D_5482"/>
														</Extrinsic>
													</xsl:if>
													<xsl:if test="G_SG21/S_TAX[C_C241/D_5153 = 'VAT']/C_C243/D_5278 != ''">
														<Extrinsic>
															<xsl:attribute name="name">vatPercentageRate</xsl:attribute>
															<xsl:value-of select="G_SG21/S_TAX[C_C241/D_5153 = 'VAT'][1]/C_C243/D_5278"/>
														</Extrinsic>
													</xsl:if>
												</xsl:element>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<!-- IG-1754 InvoiceLineItemSummaryModification missing -->
						<xsl:variable name="cleanALCListItemSummary">
							<xsl:for-each select="M_INVOIC/G_SG51[S_ALC/D_5463 = 'C' or S_ALC/D_5463 = 'A']">
								<xsl:choose>
									<xsl:when test="(S_MOA/C_C516/D_5025 = '8' or S_MOA/C_C516/D_5025 = '131')">
										<G_ALC>
											<xsl:copy-of select="./child::*"/>
										</G_ALC>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:if test="count($cleanALCListItemSummary/G_ALC) &gt; 0">
							<xsl:element name="InvoiceDetailSummaryLineItemModifications">
								<xsl:for-each select="$cleanALCListItemSummary/G_ALC">
									<xsl:variable name="modCode">
										<xsl:value-of select="./S_ALC/C_C214/D_7161"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="S_ALC/D_5463 = 'A'">
											<xsl:element name="Modification">
												<xsl:if test="S_ALC/D_1227 != ''">
													<xsl:attribute name="level">
														<xsl:value-of select="S_ALC/D_1227"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:element name="AdditionalDeduction">
													<xsl:element name="DeductionAmount">
														<xsl:element name="Money">
															<xsl:attribute name="currency">
																<xsl:choose>
																	<xsl:when test="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_6345 != ''">
																		<xsl:value-of select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_6345"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$headerCurrency"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
															<xsl:choose>
																<xsl:when test="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_5004 = '' or S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_5004 = '0'">
																	<xsl:value-of select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_5004"/>
																</xsl:when>
																<xsl:when test="$isCreditMemo = 'yes'">
																	<xsl:value-of select="concat('-', S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_5004)"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_5004"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:element>
													</xsl:element>
												</xsl:element>
												<xsl:element name="ModificationDetail">
													<xsl:attribute name="name">
														<xsl:choose>
															<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
																<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$modCode"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
														<xsl:attribute name="startDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
														<xsl:attribute name="endDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:element name="Description">
														<xsl:attribute name="xml:lang">
															<xsl:text>en</xsl:text>
														</xsl:attribute>
														<xsl:if test="S_ALC/C_C552/D_1230 != ''">
															<xsl:element name="ShortName">
																<xsl:value-of select="S_ALC/C_C552/D_1230"/>
															</xsl:element>
														</xsl:if>
														<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
													</xsl:element>
													<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
														<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
														<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
														<xsl:if test="$codeSLookup != ''">
															<Extrinsic>
																<xsl:attribute name="name">settlementCode</xsl:attribute>
																<xsl:value-of select="$codeSLookup"/>
															</Extrinsic>
														</xsl:if>
													</xsl:if>
												</xsl:element>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_ALC/D_5463 = 'C'">
											<xsl:element name="Modification">
												<xsl:if test="S_ALC/D_1227 != ''">
													<xsl:attribute name="level">
														<xsl:value-of select="S_ALC/D_1227"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:element name="AdditionalCost">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:choose>
																<xsl:when test="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_6345 != ''">
																	<xsl:value-of select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_6345"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$headerCurrency"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$isCreditMemo = 'yes'">
																<xsl:value-of select="concat('-', S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_5004)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131']/D_5004"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:element>
												</xsl:element>
												<xsl:element name="ModificationDetail">
													<xsl:attribute name="name">
														<xsl:choose>
															<xsl:when test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
																<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$modCode"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:if test="S_DTM/C_C507[D_2005 = '263']/D_2380 != ''">
														<xsl:attribute name="startDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '263']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
														<xsl:attribute name="endDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '206']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:element name="Description">
														<xsl:attribute name="xml:lang">
															<xsl:text>en</xsl:text>
														</xsl:attribute>
														<xsl:if test="S_ALC/C_C552/D_1230 != ''">
															<xsl:element name="ShortName">
																<xsl:value-of select="S_ALC/C_C552/D_1230"/>
															</xsl:element>
														</xsl:if>
														<xsl:value-of select="concat(./S_ALC/C_C214/D_7160, ./S_ALC/C_C214/D_7160_2)"/>
													</xsl:element>
													<xsl:if test="normalize-space(./S_ALC/C_C552/D_4471) != ''">
														<xsl:variable name="codeS" select="normalize-space(./S_ALC/C_C552/D_4471)"/>
														<xsl:variable name="codeSLookup" select="$lookups/Lookups/Settlements/Settlement[EDIFACTCode = $modCode]/CXMLCode"/>
														<xsl:if test="$codeSLookup != ''">
															<Extrinsic>
																<xsl:attribute name="name">settlementCode</xsl:attribute>
																<xsl:value-of select="$codeSLookup"/>
															</Extrinsic>
														</xsl:if>
													</xsl:if>
												</xsl:element>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<!-- TotalCharges -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '259']/D_5004 != ''">
							<xsl:element name="TotalCharges">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '259'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '259'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- TotalAllowances -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '260']/D_5004 != ''">
							<xsl:element name="TotalAllowances">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '260'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '260'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- TotalAmountWithoutTax -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '125']/D_5004 != ''">
							<xsl:element name="TotalAmountWithoutTax">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '125'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '125'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<xsl:element name="NetAmount">
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '77']">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '77'][1]"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '77'][D_6343 = '11']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '128'][1]"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '128'][D_6343 = '11']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<!-- DepositAmount -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '113']/D_5004 != ''">
							<xsl:element name="DepositAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '113'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '113'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- DueAmount -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '9']/D_5004 != ''">
							<xsl:element name="DueAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '9'][1]"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '9'][D_6343 = '11']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- InvoiceDetailSummaryIndustry -->
						<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '11E' or D_5025 = 'XB5' or D_5025 = '37E' or D_5025 = '35E' or D_5025 = '36E' or D_5025 = '178']">
							<xsl:element name="InvoiceDetailSummaryIndustry">
								<xsl:element name="InvoiceDetailSummaryRetail">
									<xsl:element name="AdditionalAmounts">
										<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '11E']/D_5004 != ''">
											<xsl:element name="TotalRetailAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '11E'][1]"/>
													<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '11E'][D_6343 = '11']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = 'XB5']/D_5004 != ''">
											<xsl:element name="InformationalAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = 'XB5'][1]"/>
													<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = 'XB5'][D_6343 = '11']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '37E']/D_5004 != ''">
											<xsl:element name="GrossProgressPaymentAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '37E'][1]"/>
													<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '37E'][D_6343 = '11']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '35E']/D_5004 != ''">
											<xsl:element name="TotalReturnableItemsDepositAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '35E'][1]"/>
													<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '35E'][D_6343 = '11']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '36E']/D_5004 != ''">
											<xsl:element name="GoodsAndServiceAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '36E'][1]"/>
													<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '36E'][D_6343 = '11']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:if test="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '178']/D_5004 != ''">
											<xsl:element name="ExactAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '178'][1]"/>
													<xsl:with-param name="altMOA" select="M_INVOIC/G_SG48/S_MOA/C_C516[D_5025 = '178'][D_6343 = '11']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Functions -->
</xsl:stylesheet>
