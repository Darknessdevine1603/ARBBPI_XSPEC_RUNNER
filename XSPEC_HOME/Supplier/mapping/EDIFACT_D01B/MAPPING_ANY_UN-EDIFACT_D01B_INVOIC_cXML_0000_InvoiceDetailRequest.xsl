<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:invoic:d.01b" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="cXMLAttachments"/>
	<xsl:param name="attachSeparator" select="'\|'"/>
	<xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D01B.xml')"/>
	<!--<xsl:variable name="lookups" select="document('cXML_EDILookups_D01B.xml')"/>-->
	<xsl:template match="ns0:*">
		<xsl:variable name="invType">
			<xsl:choose>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '81'">lineLevelCreditMemo</xsl:when>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '380'">standard</xsl:when>
				<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '381'">creditMemo</xsl:when>
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
		<xsl:element name="cXML">
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<xsl:attribute name="timestamp">
				<xsl:call-template name="convertToAribaDate">
					<xsl:with-param name="dateTime">
						<xsl:value-of select="replace(replace(string(current-dateTime()), '-', ''), ':', '')"/>
					</xsl:with-param>
					<xsl:with-param name="dateTimeFormat">
						<xsl:value-of select="304"/>
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
					<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AEG']/D_1154 != ''">
						<xsl:element name="Credential">
							<xsl:attribute name="domain">SystemID</xsl:attribute>
							<xsl:element name="Identity">
								<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AEG']/D_1154"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
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
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154 != ''">
									<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IV']/D_1154"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="M_INVOIC/S_BGM/C_C106/D_1004"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="M_INVOIC/S_BGM/D_1225 = '14' or M_INVOIC/S_BGM/D_1225 = '43' or M_INVOIC/S_BGM/D_1225 = '55'">
							<xsl:attribute name="isInformationOnly">yes</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="purpose">
							<xsl:value-of select="$invType"/>
						</xsl:attribute>
						<xsl:attribute name="operation">
							<xsl:choose>
								<xsl:when test="M_INVOIC/S_BGM/D_1225 = '3'">delete</xsl:when>
								<xsl:when test="M_INVOIC/S_BGM/D_1225 = '9'">new</xsl:when>
								<xsl:when test="M_INVOIC/S_BGM/D_1225 = '14'">new</xsl:when>
								<xsl:when test="M_INVOIC/S_BGM/D_1225 = '43'">new</xsl:when>
								<xsl:when test="M_INVOIC/S_BGM/D_1225 = '55'">new</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="invoiceDate">
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '3']/D_2380 != ''">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime"
											select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '3']/D_2380"/>
										<xsl:with-param name="dateTimeFormat"
											select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '3']/D_2379"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime"
											select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
										<xsl:with-param name="dateTimeFormat"
											select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IV']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/S_DTM/C_C507/D_2005 = '3'">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime" select="M_INVOIC/S_DTM/C_C507[D_2005 = '3']/D_2380"/>
										<xsl:with-param name="dateTimeFormat" select="M_INVOIC/S_DTM/C_C507[D_2005 = '3']/D_2379"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/S_DTM/C_C507/D_2005 = '137'">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime" select="M_INVOIC/S_DTM/C_C507[D_2005 = '137']/D_2380"/>
										<xsl:with-param name="dateTimeFormat" select="M_INVOIC/S_DTM/C_C507[D_2005 = '137']/D_2379"/>
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
								<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '381' or M_INVOIC/S_BGM/C_C002/D_1001 = '383'">
									<xsl:attribute name="isHeaderInvoice">yes</xsl:attribute>
								</xsl:when>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="InvoiceDetailLineIndicator">
							<xsl:if test="M_INVOIC/G_SG26/G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']/D_5004 != ''">
								<xsl:attribute name="isTaxInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if test="M_INVOIC/G_SG26/G_SG27/S_MOA/C_C516/D_5025 = '299'">
								<xsl:attribute name="isSpecialHandlingInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if
								test="M_INVOIC/G_SG26/G_SG39[S_ALC/D_5463 = 'C'][S_ALC/C_C214/D_7161 = 'SAA']/G_SG42/S_MOA/C_C516[D_5025 = '23'][D_6343 = '4']/D_5004 != ''">
								<xsl:attribute name="isShippingInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if
								test="M_INVOIC/G_SG26/G_SG39/S_ALC[D_5463 = 'A'][S_ALC/C_C214/D_7161 = 'DI']/G_SG42/S_MOA/C_C516[D_5025 = '52'][D_6343 = '4']/D_5004 != ''">
								<xsl:attribute name="isDiscountInLine">yes</xsl:attribute>
							</xsl:if>
							<xsl:if test="M_INVOIC/G_SG26/G_SG39/S_ALC[D_5463 = 'N']/C_C214/D_7161 = 'AEC'">
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
									<!--<xsl:for-each										select="S_FII[D_3035 = $role][C_C088/D_1131_1='25']">										<xsl:choose>											<xsl:when												test="C_C088/D_3055_1='5' or C_C088/D_3055_1='17'">												<xsl:if test="C_C078/D_3194!=''">												<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="C_C078/D_3194"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>ibanID</xsl:text>												</xsl:attribute>												</xsl:element>												</xsl:if>												<xsl:if test="C_C088/D_3433!=''">												<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="C_C088/D_3433"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>swiftID</xsl:text>												</xsl:attribute>												</xsl:element>												</xsl:if>											</xsl:when>											<xsl:when test="C_C088/D_3055_1='131'">												<xsl:if test="C_C078/D_3194!=''">												<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="C_C078/D_3194"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>accountNumber</xsl:text>												</xsl:attribute>												</xsl:element>												</xsl:if>												<xsl:if test="C_C088/D_3433!=''">												<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="C_C088/D_3433"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>bankCode</xsl:text>												</xsl:attribute>												</xsl:element>												</xsl:if>											</xsl:when>										</xsl:choose>										<xsl:if test="C_C078/D_3192_1!=''">											<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="C_C078/D_3192_1"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>accountName</xsl:text>												</xsl:attribute>											</xsl:element>										</xsl:if>										<xsl:if test="C_C078/D_3192_2!=''">											<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="C_C078/D_3192_2"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>accountType</xsl:text>												</xsl:attribute>											</xsl:element>										</xsl:if>										<xsl:if test="C_C088/D_3432!=''">											<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="C_C088/D_3432"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>branchName</xsl:text>												</xsl:attribute>											</xsl:element>										</xsl:if>										<xsl:if test="D_3207!=''">											<xsl:element name="IdReference">												<xsl:attribute name="identifier">												<xsl:value-of select="D_3207"/>												</xsl:attribute>												<xsl:attribute name="domain">												<xsl:text>bankCountryCode</xsl:text>												</xsl:attribute>											</xsl:element>										</xsl:if>									</xsl:for-each>-->
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:if
							test="M_INVOIC/G_SG2//S_FII[D_3035 = 'RB'][C_C088/D_1131_1 = '25'] or M_INVOIC/G_SG2[S_NAD/D_3035 = 'RE'][S_FII/D_3035 = 'RB']/G_SG3/S_RFF/C_C506[D_1153 = 'RT']/D_1154 != '' or M_INVOIC/G_SG2[S_NAD/D_3035 = 'RE'][S_FII/D_3035 = 'RB']/G_SG3/S_RFF/C_C506[D_1153 = 'PY']/D_1154 != ''">
							<InvoicePartner>
								<Contact role="wireReceivingBank">
									<Name xml:lang="en-US">
										<xsl:choose>
											<xsl:when test="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C088/D_3432)[1] != ''">
												<xsl:value-of select="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C088/D_3432)[1]"/>
											</xsl:when>
											<xsl:otherwise>Not Provided</xsl:otherwise>
										</xsl:choose>
									</Name>
								</Contact>
								<xsl:for-each select="M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']">
									<xsl:choose>
										<xsl:when test="C_C088/D_3055_1 = '5' or C_C088/D_3055_1 = '17'">
											<xsl:if test="C_C078/D_3194 != ''">
												<xsl:element name="IdReference">
													<xsl:attribute name="identifier">
														<xsl:value-of select="C_C078/D_3194"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:text>ibanID</xsl:text>
													</xsl:attribute>
												</xsl:element>
											</xsl:if>
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
										</xsl:when>
										<xsl:when test="C_C088/D_3055_1 = '131'">
											<xsl:if test="C_C078/D_3194 != ''">
												<xsl:element name="IdReference">
													<xsl:attribute name="identifier">
														<xsl:value-of select="C_C078/D_3194"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:text>accountNumber</xsl:text>
													</xsl:attribute>
												</xsl:element>
											</xsl:if>
											<xsl:if test="C_C088/D_3433 != ''">
												<xsl:element name="IdReference">
													<xsl:attribute name="identifier">
														<xsl:value-of select="C_C088/D_3433"/>
													</xsl:attribute>
													<xsl:attribute name="domain">
														<xsl:text>bankCode</xsl:text>
													</xsl:attribute>
												</xsl:element>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
								<xsl:if test="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C078/D_3192_1)[1] != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C078/D_3192_1)[1]"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>accountName</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C078/D_3192_2)[1] != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C078/D_3192_2)[1]"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>accountType</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C088/D_3432)[1] != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/C_C088/D_3432)[1]"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>branchName</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/D_3207)[1] != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB']/D_3207)[1]"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>bankCountryCode</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="not(exists(M_INVOIC/G_SG2//S_FII[D_3035 = 'RB'][C_C088/D_3055_1 = '131']/C_C078/D_3194))">
									<xsl:if
										test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'RE'][S_FII/D_3035 = 'RB']/G_SG3/S_RFF/C_C506[D_1153 = 'PY']/D_1154 != ''">
										<xsl:element name="IdReference">
											<xsl:attribute name="identifier">
												<xsl:value-of
													select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'RE'][S_FII/D_3035 = 'RB']/G_SG3/S_RFF/C_C506[D_1153 = 'PY']/D_1154"
												/>
											</xsl:attribute>
											<xsl:attribute name="domain">
												<xsl:text>accountID</xsl:text>
											</xsl:attribute>
										</xsl:element>
									</xsl:if>
								</xsl:if>
								<xsl:if
									test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'RE'][S_FII/D_3035 = 'RB']/G_SG3/S_RFF/C_C506[D_1153 = 'RT']/D_1154 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of
												select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'RE'][S_FII/D_3035 = 'RB']/G_SG3/S_RFF/C_C506[D_1153 = 'RT']/D_1154"
											/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:text>bankRoutingID</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</InvoicePartner>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ACW']/D_1154 != ''">
							<xsl:element name="DocumentReference">
								<xsl:attribute name="payloadID">
									<xsl:for-each select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ACW']">
										<xsl:value-of select="concat(S_RFF/C_C506/D_1154, S_RFF/C_C506/D_4000)"/>
									</xsl:for-each>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'OI']/D_1154 != ''">
							<xsl:element name="InvoiceIDInfo">
								<xsl:attribute name="invoiceID">
									<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'OI']/D_1154"/>
								</xsl:attribute>
								<xsl:choose>
									<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'OI']/S_DTM/C_C507[D_2005 = '3']/D_2380 != ''">
										<xsl:attribute name="invoiceDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'OI']/S_DTM/C_C507[D_2005 = '3']/D_2380"/>
												<xsl:with-param name="dateTimeFormat"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'OI']/S_DTM/C_C507[D_2005 = '3']/D_2379"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:when>
									<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'OI']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
										<xsl:attribute name="invoiceDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'OI']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
												<xsl:with-param name="dateTimeFormat"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'OI']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
						</xsl:if>
						<!-- InvoiceDetailShipping -->
						<xsl:if
							test="(M_INVOIC//G_SG2/S_NAD/D_3035 = 'CA' and M_INVOIC//G_SG2/S_NAD/D_3035 = 'SF' and M_INVOIC//G_SG2/S_NAD/D_3035 = 'ST') or (M_INVOIC//G_SG2/S_NAD/D_3035 = 'SF' and M_INVOIC//G_SG2/S_NAD/D_3035 = 'ST')">
							<xsl:element name="InvoiceDetailShipping">
								<xsl:if test="M_INVOIC/S_DTM/C_C507[D_2005 = '110']/D_2380 != ''">
									<xsl:attribute name="shippingDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime" select="M_INVOIC/S_DTM/C_C507[D_2005 = '110']/D_2380"/>
											<xsl:with-param name="dateTimeFormat" select="M_INVOIC/S_DTM/C_C507[D_2005 = '110']/D_2379"/>
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
													<xsl:value-of
														select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
													/>
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
													<xsl:value-of
														select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
													/>
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
													<xsl:value-of
														select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
													/>
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
													<xsl:value-of
														select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
													/>
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
													<xsl:value-of
														select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
													/>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'CA']">
									<xsl:variable name="role">
										<xsl:value-of select="S_NAD/D_3035"/>
									</xsl:variable>
									<xsl:for-each select="G_SG3">
										<xsl:choose>
											<xsl:when test="$role = 'CA' and S_RFF/C_C506[D_1153 = 'CN']/D_1154 != ''">
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
													<xsl:value-of select="S_RFF/C_C506[D_1153 = 'CN']/D_1154"/>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<!-- ShipNoticeIDInfo -->
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'MA']/D_1154 != ''">
							<xsl:element name="ShipNoticeIDInfo">
								<xsl:attribute name="shipNoticeID">
									<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'MA']/D_1154"/>
								</xsl:attribute>
								<xsl:choose>
									<xsl:when test="M_INVOIC/G_SG1/S_DTM/C_C507[D_2005 = '111']/D_2380 != ''">
										<xsl:attribute name="shipNoticeDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime" select="M_INVOIC/G_SG1/S_DTM/C_C507[D_2005 = '111']/D_2380"/>
												<xsl:with-param name="dateTimeFormat" select="M_INVOIC/G_SG1/S_DTM/C_C507[D_2005 = '111']/D_2379"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:when>
									<xsl:when test="M_INVOIC/G_SG1/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
										<xsl:attribute name="shipNoticeDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime" select="M_INVOIC/G_SG1/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
												<xsl:with-param name="dateTimeFormat" select="M_INVOIC/G_SG1/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'PK']/D_1154 != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="domain">packListID</xsl:attribute>
										<xsl:attribute name="identifier">
											<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'PK']/D_1154"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:for-each select="M_INVOIC/G_SG8[S_PAT/D_4279 = '3' or S_PAT/D_4279 = '20' or S_PAT/D_4279 = '22']">
							<xsl:element name="PaymentTerm">
								<xsl:attribute name="payInNumberOfDays">
									<xsl:value-of select="S_PAT/C_C112/D_2152"/>
								</xsl:attribute>
								<xsl:if
									test="(S_PCD/C_C501[D_5245 = '15' or D_5245 = '12'][D_5249 = '13']/D_5482 != '' or S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_5004 != '') and S_PAT/D_4279 != '3'">
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
											<xsl:when test="S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_5004 != '' and S_PAT/D_4279 = '20'">
												<xsl:element name="DiscountAmount">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_6345"/>
														</xsl:attribute>
														<xsl:value-of select="concat('-', S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_5004)"/>
													</xsl:element>
												</xsl:element>
											</xsl:when>
											<xsl:when test="S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_5004 != '' and S_PAT/D_4279 = '22'">
												<xsl:element name="DiscountAmount">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_6345"/>
														</xsl:attribute>
														<xsl:value-of select="S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_5004"/>
													</xsl:element>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="S_PAT/D_4279 = '3'">
										<xsl:if test="S_DTM/C_C507[D_2005 = '13']/D_2380 != ''">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:text>netDueDate</xsl:text>
												</xsl:attribute>
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '13']/D_2380"/>
													<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '13']/D_2379"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
									</xsl:when>
									<xsl:when test="S_PAT/D_4279 = '20'">
										<xsl:if test="S_DTM/C_C507[D_2005 = '265']/D_2380 != ''">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:text>penaltyDueDate</xsl:text>
												</xsl:attribute>
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '265']/D_2380"/>
													<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '265']/D_2379"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
									</xsl:when>
									<xsl:when test="S_PAT/D_4279 = '22'">
										<xsl:if test="S_DTM/C_C507[D_2005 = '12']/D_2380 != ''">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:text>discountDueDate</xsl:text>
												</xsl:attribute>
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '12']/D_2380"/>
													<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '12']/D_2379"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
									</xsl:when>
								</xsl:choose>
								<xsl:if test="S_DTM/C_C507[D_2005 = '209']/D_2380 != ''">
									<xsl:element name="Extrinsic">
										<xsl:attribute name="name">
											<xsl:text>valueDate</xsl:text>
										</xsl:attribute>
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime" select="S_DTM/C_C507[D_2005 = '209']/D_2380"/>
											<xsl:with-param name="dateTimeFormat" select="S_DTM/C_C507[D_2005 = '209']/D_2379"/>
										</xsl:call-template>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:for-each>
						<xsl:if
							test="M_INVOIC/S_DTM/C_C507[D_2005 = '194']/D_2380 != '' and M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
							<xsl:element name="Period">
								<xsl:attribute name="startDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime" select="M_INVOIC/S_DTM/C_C507[D_2005 = '194']/D_2380"/>
										<xsl:with-param name="dateTimeFormat" select="M_INVOIC/S_DTM/C_C507[D_2005 = '194']/D_2379"/>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:attribute name="endDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime" select="M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2380"/>
										<xsl:with-param name="dateTimeFormat" select="M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2379"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<!-- Comments -->
						<xsl:variable name="comment">
							<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'AAI']">
								<xsl:value-of select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"
								/>
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
						<!-- Header Extrinsics -->
						<xsl:element name="Extrinsic">
							<xsl:attribute name="name">invoiceSubmissionMethod</xsl:attribute>
							<xsl:value-of select="'CIG_EDIFact'"/>
						</xsl:element>
						<!--IG-16908/IG-16910 - Extrinsic name = "taxExchangeRate" map only first occurence of SG7-->
						<xsl:if test="M_INVOIC/G_SG7[1]/S_CUX/D_5402 != ''">
								<xsl:element name="Extrinsic">
							<xsl:attribute name="name">taxExchangeRate</xsl:attribute>
									<xsl:value-of select="M_INVOIC/G_SG7[1]/S_CUX/D_5402"/>
						</xsl:element>
							</xsl:if>
						
						<!-- buyerVatID -->
						<xsl:choose>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'BT']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'buyerVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'BT']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SO']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'buyerVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'SO']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
						<!--<Defect IG-1236>-->
						<xsl:if test="M_INVOIC/G_SG2/S_LOC[D_3227 = '89'] and M_INVOIC/G_SG2/S_NAD[D_3035 = 'FR']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">supplierCommercialCredentials</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/S_LOC[D_3227 = '89']/C_C517/D_3224"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG2/G_SG3/S_RFF/C_C506[D_1153 = 'GN'] and M_INVOIC/G_SG2/S_NAD[D_3035 = 'FR']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">supplierCommercialIdentifier</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'GN']/D_1154"/>
							</xsl:element>
						</xsl:if>
						<!-- supplierVatID -->
						<xsl:choose>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'supplierVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="M_INVOIC/G_SG2[S_NAD/D_3035 = 'II']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name" select="'supplierVatID'"/>
									<xsl:value-of select="M_INVOIC/G_SG2[S_NAD/D_3035 = 'II']/G_SG3/S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
						<xsl:if test="M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2380 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">deliveryDate</xsl:attribute>
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="dateTime" select="M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2380"/>
									<xsl:with-param name="dateTimeFormat" select="M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2379"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/S_PAI/C_C534[D_4439 = 'ZZZ' and D_4431 = '10']/D_4461 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">PaymentMean</xsl:attribute>
								<xsl:value-of select="M_INVOIC/S_PAI/C_C534[D_4439 = 'ZZZ' and D_4431 = '10']/D_4461"/>
							</xsl:element>
						</xsl:if>
						<xsl:for-each select="M_INVOIC/S_LOC[D_3227 = '27' or D_3227 = '28']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:choose>
										<xsl:when test="D_3227 = '27'">
											<xsl:text>shipFromCountry</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>shipToCountry</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="C_C517/D_3225"/>
							</xsl:element>
						</xsl:for-each>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>DeliveryNoteNum</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154"/>
							</xsl:element>
							<xsl:if
								test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124' or D_2005 = '171']/D_2380 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">DeliveryNoteDate</xsl:attribute>
									<xsl:choose>
										<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380 != ''">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380"/>
												<xsl:with-param name="dateTimeFormat"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2379"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
												<xsl:with-param name="dateTimeFormat"
													select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:text>ultimateCustomerReferenceID</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'UC']/D_1154"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AWE']/D_1154 != ''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">costCenter</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AWE']/D_1154"/>
							</xsl:element>
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">ApprovalUserCostCenter</xsl:attribute>
								<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AWE']/D_1154"/>
							</xsl:element>
						</xsl:if>
						<!-- Extrinsics -->
						<!--Defect IG-1386-->
						<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'ZZZ']">
							<xsl:element name="Extrinsic">
								<!--<xsl:attribute name="name" select="C_C107/D_4441"/>-->
								<xsl:attribute name="name" select="C_C108/D_4440"/>
								<xsl:value-of select="concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ZZZ']">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name" select="S_RFF/C_C506/D_1154"/>
								<xsl:value-of select="S_RFF/C_C506/D_4000"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:choose>
						<!-- Header Invoice -->
						<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '381' or M_INVOIC/S_BGM/C_C002/D_1001 = '383'">
							<xsl:for-each select="M_INVOIC/G_SG26">
								<xsl:element name="InvoiceDetailHeaderOrder">
									<xsl:element name="InvoiceDetailOrderInfo">
										<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'IL']/D_1154 != ''">
											<xsl:element name="OrderReference">
												<xsl:if
													test="G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
													<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
														<xsl:attribute name="orderID">
															<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
														</xsl:attribute>
													</xsl:if>
													<xsl:choose>
														<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
															<xsl:attribute name="orderDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</xsl:when>
														<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
															<xsl:attribute name="orderDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"
																		/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"
																		/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</xsl:when>
													</xsl:choose>
												</xsl:if>
												<xsl:element name="DocumentReference">
													<xsl:attribute name="payloadID">
														<xsl:for-each select="G_SG30[S_RFF/C_C506/D_1153 = 'IL']">
															<xsl:value-of select="S_RFF/C_C506/D_1154"/>
														</xsl:for-each>
													</xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:if>
										<!-- MasterAgreementIDInfo -->
										<xsl:if
											test="G_SG30/S_RFF/C_C506[D_1153 = 'AJS']/D_1154 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '126']/D_2380 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
											<xsl:element name="MasterAgreementIDInfo">
												<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'AJS']/D_1154 != ''">
													<xsl:attribute name="agreementID">
														<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AJS']/D_1154"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
														<xsl:attribute name="agreementDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '126']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '126']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:when>
													<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '629']/D_2380 != ''">
														<xsl:attribute name="agreementDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '629']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '629']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:when>
													<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
														<xsl:attribute name="agreementDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:when>
												</xsl:choose>
												<xsl:attribute name="agreementType">
													<xsl:text>scheduling_agreement</xsl:text>
												</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<!-- OrderIDInfo -->
										<xsl:if
											test="not(G_SG30/S_RFF/C_C506[D_1153 = 'IL']/D_1154) or G_SG30/S_RFF/C_C506[D_1153 = 'IL']/D_1154 = ''">
											<xsl:if
												test="G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
												<xsl:element name="OrderIDInfo">
													<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
														<xsl:attribute name="orderID">
															<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
														</xsl:attribute>
													</xsl:if>
													<xsl:choose>
														<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
															<xsl:attribute name="orderDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</xsl:when>
														<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
															<xsl:attribute name="orderDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"
																		/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"
																		/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</xsl:when>
													</xsl:choose>
												</xsl:element>
											</xsl:if>
										</xsl:if>
										<!-- SupplierOrderInfo -->
										<xsl:if
											test="G_SG30/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != '' or G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
											<xsl:element name="SupplierOrderInfo">
												<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
													<xsl:attribute name="orderID">
														<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'VN']/D_1154"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
														<xsl:attribute name="orderDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:when>
													<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
														<xsl:attribute name="orderDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:when>
												</xsl:choose>
											</xsl:element>
										</xsl:if>
									</xsl:element>
									<xsl:element name="InvoiceDetailOrderSummary">
										<xsl:attribute name="invoiceLineNumber">
											<xsl:value-of select="S_LIN/D_1082"/>
										</xsl:attribute>
										<xsl:if test="S_DTM/C_C507[D_2005 = '351']/D_2380 != ''">
											<xsl:attribute name="inspectionDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '351']/D_2380"/>
													</xsl:with-param>
													<xsl:with-param name="dateTimeFormat">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '351']/D_2380"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:if>
										<xsl:element name="SubtotalAmount">
											<xsl:choose>
												<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']/D_5004 != ''">
													<xsl:call-template name="createMoney">
														<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']"/>
														<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '7']"/>
														<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']/D_5004 != ''">
													<xsl:call-template name="createMoney">
														<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']"/>
														<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '7']"/>
														<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
													</xsl:call-template>
												</xsl:when>
											</xsl:choose>
										</xsl:element>
										<!-- Period -->
										<xsl:if test="S_DTM/C_C507[D_2005 = '194']/D_2380 != '' and S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
											<xsl:element name="Period">
												<xsl:attribute name="startDate">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="dateTime">
															<xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2380"/>
														</xsl:with-param>
														<xsl:with-param name="dateTimeFormat">
															<xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2379"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
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
											</xsl:element>
										</xsl:if>
										<!-- Tax -->
										<xsl:if
											test="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']/D_5004 != '' or G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']/D_5004 != ''">
											<xsl:element name="Tax">
												<xsl:choose>
													<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']/D_5004 != ''">
														<xsl:call-template name="createMoney">
															<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
															<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
															<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']/D_5004 != ''">
														<xsl:call-template name="createMoney">
															<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']"/>
															<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '7']"/>
															<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
														</xsl:call-template>
													</xsl:when>
												</xsl:choose>
												<xsl:element name="Description">
													<xsl:choose>
														<xsl:when test="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4']/C_C108/D_4440_1 != ''">
															<xsl:attribute name="xml:lang">
																<xsl:choose>
																	<xsl:when test="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4'][1]/D_3453 != ''">
																		<xsl:value-of select="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4'][1]/D_3453"/>
																	</xsl:when>
																	<xsl:otherwise>en</xsl:otherwise>
																</xsl:choose>
															</xsl:attribute>
															<xsl:for-each select="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4']">
																<xsl:value-of
																	select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"
																/>
															</xsl:for-each>
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="xml:lang">en</xsl:attribute>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:element>
												<xsl:for-each select="G_SG34[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">
													<xsl:variable name="taxCategory">
														<xsl:choose>
															<xsl:when test="S_TAX/C_C241/D_5153 = 'LOC' or S_TAX/C_C241/D_5153 = 'STT'">
																<xsl:choose>
																	<xsl:when test="S_TAX/C_C241/D_5152 = '.qc.ca'">
																		<xsl:text>qst</xsl:text>
																	</xsl:when>
																	<xsl:when
																		test="S_TAX/C_C241/D_5152 = '.ns.ca' or S_TAX/C_C241/D_5152 = '.nf.ca' or S_TAX/C_C241/D_5152 = '.nb.ca' or S_TAX/C_C241/D_5152 = '.on.ca'">
																		<xsl:text>hst</xsl:text>
																	</xsl:when>
																	<xsl:when test="contains(S_TAX/C_C241/D_5152, '.ca')">
																		<xsl:text>pst</xsl:text>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:text>sales</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
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
														<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
															<xsl:variable name="tpDate">
																<xsl:value-of
																	select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2380"
																/>
															</xsl:variable>
															<xsl:variable name="tpDateFormat">
																<xsl:value-of
																	select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2379"
																/>
															</xsl:variable>
															<xsl:variable name="payDate">
																<xsl:value-of
																	select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2380"
																/>
															</xsl:variable>
															<xsl:variable name="payDateFormat">
																<xsl:value-of
																	select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2379"
																/>
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
															<xsl:when test="S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']/D_5004 != ''">
																<xsl:element name="TaxableAmount">
																	<xsl:call-template name="createMoney">
																		<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']"/>
																		<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '125' and D_6343 = '7']"/>
																		<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
																	</xsl:call-template>
																</xsl:element>
															</xsl:when>
															<xsl:when test="S_TAX/D_5286 != ''">
																<xsl:element name="TaxableAmount">
																	<xsl:element name="Money">
																		<xsl:attribute name="currency">
																			<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
																		</xsl:attribute>
																		<xsl:choose>
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
																<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
																<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
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
															<xsl:when
																test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat' and normalize-space(../G_SG30/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000) != ''">
																<xsl:element name="Description">
																	<xsl:attribute name="xml:lang">en</xsl:attribute>
																	<xsl:value-of
																		select="normalize-space(../G_SG30/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000)"/>
																</xsl:element>
															</xsl:when>
														</xsl:choose>
														<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
															<xsl:if test="S_FTX[D_4451 = 'TXD'][D_4453 = '4']/C_C108/D_4440_1 != ''">
																<xsl:element name="TriangularTransactionLawReference">
																	<xsl:attribute name="xml:lang">
																		<xsl:choose>
																			<xsl:when test="S_FTX[D_4451 = 'TXD'][D_4453 = '4'][1]/D_3453 != ''">
																				<xsl:value-of select="S_FTX[D_4451 = 'TXD'][D_4453 = '4'][1]/D_3453"/>
																			</xsl:when>
																			<xsl:otherwise>en</xsl:otherwise>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:for-each select="S_FTX[D_4451 = 'TXD'][D_4453 = '4']">
																		<xsl:value-of
																			select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"
																		/>
																	</xsl:for-each>
																</xsl:element>
															</xsl:if>
														</xsl:if>
														<xsl:if test="S_TAX/C_C243/D_5279 != ''">
															<xsl:element name="Extrinsic">
																<xsl:attribute name="name">
																	<xsl:text>taxAccountcode</xsl:text>
																</xsl:attribute>
																<xsl:value-of select="S_TAX/C_C243/D_5279"/>
															</xsl:element>
														</xsl:if>
														<xsl:if test="S_LOC[D_3227 = '157']/C_C517/D_3225 != ''">
															<xsl:element name="Extrinsic">
																<xsl:attribute name="name">
																	<xsl:text>taxJurisdiction</xsl:text>
																</xsl:attribute>
																<xsl:value-of select="S_LOC[D_3227 = '157']/C_C517/D_3225"/>
															</xsl:element>
														</xsl:if>
														<xsl:if test="S_TAX/D_5305 = 'S'">
															<xsl:element name="Extrinsic">
																<xsl:attribute name="name">
																	<xsl:text>exemptType</xsl:text>
																</xsl:attribute>
																<xsl:text>Standard</xsl:text>
															</xsl:element>
														</xsl:if>
													</xsl:element>
												</xsl:for-each>
											</xsl:element>
										</xsl:if>
										<!-- InvoiceDetailLineSpecialHandling -->
										<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '299' and D_6343 = '4']/D_5004 != ''">
											<xsl:element name="InvoiceDetailLineSpecialHandling">
												<xsl:if test="S_FTX[D_4451 = 'SPH']/C_C108/D_4440_1 != ''">
													<xsl:element name="Description">
														<xsl:attribute name="xml:lang">
															<xsl:choose>
																<xsl:when test="S_FTX[D_4451 = 'SPH']/D_3453 != ''">
																	<xsl:value-of select="S_FTX[D_4451 = 'SPH'][1]/D_3453"/>
																</xsl:when>
																<xsl:otherwise>en</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:for-each select="S_FTX[D_4451 = 'SPH']">
															<xsl:value-of
																select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"
															/>
														</xsl:for-each>
													</xsl:element>
												</xsl:if>
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '299' and D_6343 = '4']"/>
													<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '299' and D_6343 = '7']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<!-- InvoiceDetailLineShipping -->
										<xsl:if
											test="G_SG39[S_ALC/D_5463 = 'C'][S_ALC/C_C214/D_7161 = 'SAA']/G_SG42/S_MOA/C_C516[D_5025 = '23'][D_6343 = '4']/D_5004 != ''">
											<xsl:element name="InvoiceDetailLineShipping">
												<xsl:element name="InvoiceDetailShipping">
													<xsl:if test="S_DTM/C_C507[D_2005 = '110']/D_2380 != ''">
														<xsl:attribute name="shippingDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '110']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="S_DTM/C_C507[D_2005 = '110']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:for-each select="G_SG35[S_NAD/D_3035 = 'SF' or S_NAD/D_3035 = 'ST' or S_NAD/D_3035 = 'CA']">
														<xsl:variable name="role">
															<xsl:value-of select="S_NAD/D_3035"/>
														</xsl:variable>
														<xsl:element name="Contact">
															<xsl:attribute name="role">
																<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
															</xsl:attribute>
															<xsl:if
																test="S_NAD/C_C082/D_1131 = '160' or S_NAD/C_C082/D_1131 = 'ZZZ' or not(S_NAD/C_C082/D_1131)">
																<xsl:variable name="addrDomain">
																	<xsl:value-of select="S_NAD/C_C082/D_3055"/>
																</xsl:variable>
																<xsl:if
																	test="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain][1]/CXMLCode != ''">
																	<xsl:attribute name="addressID">
																		<xsl:value-of select="S_NAD/C_C082/D_3039"/>
																	</xsl:attribute>
																	<xsl:attribute name="addressIDDomain">
																		<xsl:value-of
																			select="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain][1]/CXMLCode"/>
																	</xsl:attribute>
																</xsl:if>
															</xsl:if>
															<xsl:element name="Name">
																<xsl:attribute name="xml:lang">en</xsl:attribute>
																<xsl:value-of
																	select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
																/>
															</xsl:element>
															<xsl:if test="S_NAD/D_3164 != ''">
																<xsl:element name="PostalAddress">
																	<!-- <xsl:attribute name="name"/> -->
																	<xsl:if test="S_NAD/C_C080/D_3036_1 != ''">
																		<xsl:element name="DeliverTo">
																			<xsl:value-of select="S_NAD/C_C080/D_3036_1"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C080/D_3036_2 != ''">
																		<xsl:element name="DeliverTo">
																			<xsl:value-of select="S_NAD/C_C080/D_3036_2"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C080/D_3036_3 != ''">
																		<xsl:element name="DeliverTo">
																			<xsl:value-of select="S_NAD/C_C080/D_3036_3"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C080/D_3036_4 != ''">
																		<xsl:element name="DeliverTo">
																			<xsl:value-of select="S_NAD/C_C080/D_3036_4"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C080/D_3036_5 != ''">
																		<xsl:element name="DeliverTo">
																			<xsl:value-of select="S_NAD/C_C080/D_3036_5"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C059/D_3042_1 != ''">
																		<xsl:element name="Street">
																			<xsl:value-of select="S_NAD/C_C059/D_3042_1"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C059/D_3042_2 != ''">
																		<xsl:element name="Street">
																			<xsl:value-of select="S_NAD/C_C059/D_3042_2"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C059/D_3042_3 != ''">
																		<xsl:element name="Street">
																			<xsl:value-of select="S_NAD/C_C059/D_3042_3"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/C_C059/D_3042_4 != ''">
																		<xsl:element name="Street">
																			<xsl:value-of select="S_NAD/C_C059/D_3042_4"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/D_3164 != ''">
																		<xsl:element name="City">
																			<!-- <xsl:attribute name="cityCode"/> -->
																			<xsl:value-of select="S_NAD/D_3164"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:variable name="stateCode">
																		<xsl:value-of select="S_NAD/D_3229"/>
																	</xsl:variable>
																	<xsl:if test="$stateCode">
																		<xsl:element name="State">
																			<xsl:attribute name="isoStateCode">
																				<xsl:value-of select="$stateCode"/>
																			</xsl:attribute>
																			<xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCode]/stateName"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:if test="S_NAD/D_3251 != ''">
																		<xsl:element name="PostalCode">
																			<xsl:value-of select="S_NAD/D_3251"/>
																		</xsl:element>
																	</xsl:if>
																	<xsl:variable name="isoCountryCode">
																		<xsl:value-of select="S_NAD/D_3207"/>
																	</xsl:variable>
																	<xsl:element name="Country">
																		<xsl:attribute name="isoCountryCode">
																			<xsl:value-of select="$isoCountryCode"/>
																		</xsl:attribute>
																		<xsl:value-of
																			select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
																	</xsl:element>
																</xsl:element>
															</xsl:if>
															<xsl:for-each select="G_SG38">
																<xsl:variable name="comName">
																	<xsl:value-of select="S_CTA/D_3139"/>
																</xsl:variable>
																<xsl:for-each select="S_COM">
																	<xsl:choose>
																		<xsl:when test="C_C076/D_3155 = 'EM'">
																			<xsl:element name="Email">
																				<xsl:attribute name="name">
																					<xsl:choose>
																						<xsl:when test="$comName = 'ZZZ'">
																							<xsl:value-of
																								select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																						</xsl:when>
																						<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																							<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:text>default</xsl:text>
																						</xsl:otherwise>
																					</xsl:choose>
																				</xsl:attribute>
																				<xsl:value-of select="C_C076/D_3148"/>
																				<!--	<xsl:attribute name="preferredLang"/> -->
																			</xsl:element>
																		</xsl:when>
																	</xsl:choose>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="G_SG38">
																<xsl:variable name="comName">
																	<xsl:value-of select="S_CTA/D_3139"/>
																</xsl:variable>
																<xsl:for-each select="S_COM">
																	<xsl:choose>
																		<xsl:when test="C_C076/D_3155 = 'TE'">
																			<xsl:element name="Phone">
																				<xsl:attribute name="name">
																					<xsl:choose>
																						<xsl:when test="$comName = 'ZZZ'">
																							<xsl:value-of
																								select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																						</xsl:when>
																						<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																							<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:text>default</xsl:text>
																						</xsl:otherwise>
																					</xsl:choose>
																				</xsl:attribute>
																				<xsl:call-template name="convertToTelephone">
																					<xsl:with-param name="phoneNum">
																						<xsl:value-of select="C_C076/D_3148"/>
																					</xsl:with-param>
																				</xsl:call-template>
																			</xsl:element>
																		</xsl:when>
																	</xsl:choose>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="G_SG38">
																<xsl:variable name="comName">
																	<xsl:value-of select="S_CTA/D_3139"/>
																</xsl:variable>
																<xsl:for-each select="S_COM">
																	<xsl:choose>
																		<xsl:when test="C_C076/D_3155 = 'FX'">
																			<xsl:element name="Fax">
																				<xsl:attribute name="name">
																					<xsl:choose>
																						<xsl:when test="$comName = 'ZZZ'">
																							<xsl:value-of
																								select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																						</xsl:when>
																						<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																							<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:text>default</xsl:text>
																						</xsl:otherwise>
																					</xsl:choose>
																				</xsl:attribute>
																				<xsl:call-template name="convertToTelephone">
																					<xsl:with-param name="phoneNum">
																						<xsl:value-of select="C_C076/D_3148"/>
																					</xsl:with-param>
																				</xsl:call-template>
																			</xsl:element>
																		</xsl:when>
																	</xsl:choose>
																</xsl:for-each>
															</xsl:for-each>
															<xsl:for-each select="G_SG38">
																<xsl:variable name="comName">
																	<xsl:value-of select="S_CTA/D_3139"/>
																</xsl:variable>
																<xsl:for-each select="S_COM">
																	<xsl:choose>
																		<xsl:when test="C_C076/D_3155 = 'AH'">
																			<xsl:element name="URL">
																				<xsl:attribute name="name">
																					<xsl:choose>
																						<xsl:when test="$comName = 'ZZZ'">
																							<xsl:value-of
																								select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																						</xsl:when>
																						<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																							<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:text>default</xsl:text>
																						</xsl:otherwise>
																					</xsl:choose>
																				</xsl:attribute>
																				<xsl:value-of select="C_C076/D_3148"/>
																			</xsl:element>
																		</xsl:when>
																	</xsl:choose>
																</xsl:for-each>
															</xsl:for-each>
														</xsl:element>
													</xsl:for-each>
													<xsl:for-each select="G_SG35[S_NAD/D_3035 = 'CA']">
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
																		<xsl:value-of
																			select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
																		/>
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
																		<xsl:value-of
																			select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
																		/>
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
																		<xsl:value-of
																			select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
																		/>
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
																		<xsl:value-of
																			select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
																		/>
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
																		<xsl:value-of
																			select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
																		/>
																	</xsl:element>
																</xsl:when>
															</xsl:choose>
														</xsl:if>
													</xsl:for-each>
													<xsl:for-each select="G_SG35[S_NAD/D_3035 = 'CA']">
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
												</xsl:element>
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA"
														select="G_SG39[S_ALC/D_5463 = 'C'][S_ALC/C_C214/D_7161 = 'SAA']/G_SG42/S_MOA/C_C516[D_5025 = '23' and D_6343 = '4']"/>
													<xsl:with-param name="altMOA"
														select="G_SG39[S_ALC/D_5463 = 'C'][S_ALC/C_C214/D_7161 = 'SAA']/G_SG42/S_MOA/C_C516[D_5025 = '23' and D_6343 = '7']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<!-- GrossAmount -->
										<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '128' and D_6343 = '4']/D_5004 != ''">
											<xsl:element name="GrossAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '128' and D_6343 = '4']"/>
													<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '128' and D_6343 = '7']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<!-- InvoiceDetailDiscount -->
										<xsl:if
											test="G_SG39/S_ALC/D_5463 = 'A' and G_SG39/S_ALC/C_C214/D_7161 = 'DI' and G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG42/S_MOA/C_C516[D_5025 = '52']/D_5004 != ''">
											<xsl:element name="InvoiceDetailDiscount">
												<xsl:if
													test="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_PCD/C_C501/D_5245 = '12' and G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_PCD/C_C501/D_5249 = '13'">
													<xsl:attribute name="percentageRate">
														<xsl:value-of
															select="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_PCD/C_C501/D_5482"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA"
														select="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG42/S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']"/>
													<xsl:with-param name="altMOA"
														select="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG42/S_MOA/C_C516[D_5025 = '52' and D_6343 = '7']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<!-- NetAmount -->
										<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '38' and D_6343 = '4']/D_5004 != ''">
											<xsl:element name="NetAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '38' and D_6343 = '4']"/>
													<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '38' and D_6343 = '7']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<!-- Comments -->
										<xsl:variable name="comment">
											<xsl:for-each select="S_FTX[D_4451 = 'AAI']">
												<xsl:value-of
													select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
											</xsl:for-each>
										</xsl:variable>
										<xsl:variable name="commentLang">
											<xsl:for-each select="S_FTX[D_4451 = 'AAI']">
												<xsl:value-of select="D_3453"/>
											</xsl:for-each>
										</xsl:variable>
										<xsl:if test="$comment != ''">
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
											</xsl:element>
										</xsl:if>
										<!-- Extrinsics -->
										<!--Defect IG-1386-->
										<xsl:for-each select="S_FTX[D_4451 = 'ZZZ']">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<!--<xsl:value-of select="C_C107/D_4441"/>-->
													<xsl:value-of select="C_C108/D_4440"/>
												</xsl:attribute>
												<xsl:value-of select="concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
											</xsl:element>
										</xsl:for-each>
										<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'AWE']/D_1154 != ''">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:text>costCenter</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AWE']/D_1154"/>
											</xsl:element>
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:text>ApprovalUserCostCenter</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AWE']/D_1154"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'AOU']/D_1154 != ''">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:text>GLAccount</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AOU']/D_1154"/>
											</xsl:element>
										</xsl:if>
										<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'AKW']/D_1154 != ''">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:text>FreightCostKey</xsl:text>
												</xsl:attribute>
												<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AKW']/D_1154"/>
											</xsl:element>
										</xsl:if>
										<xsl:for-each select="G_SG30/S_RFF/C_C506[D_1153 = 'ZZZ']">
											<xsl:element name="Extrinsic">
												<xsl:attribute name="name">
													<xsl:value-of select="./D_1154"/>
												</xsl:attribute>
												<xsl:value-of select="./D_4000"/>
											</xsl:element>
										</xsl:for-each>
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
						</xsl:when>
						<!-- Summary Invoice -->
						<xsl:when test="M_INVOIC/S_BGM/C_C002/D_1001 = '385'">
							<xsl:variable name="itemCount" select="count(M_INVOIC/G_SG26)"/>
							<xsl:variable name="onCount" select="count(//G_SG30/S_RFF/C_C506[D_1153 = 'ON'])"/>
							<xsl:variable name="vnCount" select="count(//G_SG30/S_RFF/C_C506[D_1153 = 'VN'])"/>
							<xsl:variable name="ctCount" select="count(//G_SG30/S_RFF/C_C506[D_1153 = 'CT'])"/>
							<xsl:variable name="groupType">
								<xsl:choose>
									<xsl:when test="$itemCount = $onCount">ON</xsl:when>
									<xsl:when test="$itemCount = $vnCount">VN</xsl:when>
									<xsl:when test="$itemCount = $ctCount">CN</xsl:when>
									<xsl:otherwise>ON</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:for-each-group select="M_INVOIC/G_SG26" group-by="G_SG30/S_RFF/C_C506[D_1153 = $groupType]/D_1154">
								<xsl:element name="InvoiceDetailOrder">
									<xsl:element name="InvoiceDetailOrderInfo">
										<!-- MasterAgreementIDInfo -->
										<xsl:if
											test="current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != '' or current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
											<xsl:element name="MasterAgreementIDInfo">
												<xsl:if test="current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'CT']/D_1154 != ''">
													<xsl:attribute name="agreementID">
														<xsl:value-of select="(current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'CT']/D_1154)[1]"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if
													test="current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
													<xsl:attribute name="agreementDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="(current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2380)[1]"
																/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="(current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'CT']/S_DTM/C_C507[D_2005 = '126']/D_2379)[1]"
																/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
												<xsl:attribute name="agreementType">
													<xsl:text>scheduling_agreement</xsl:text>
												</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<!-- OrderIDInfo -->
										<xsl:if
											test="current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != '' or current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
											<xsl:element name="OrderIDInfo">
												<xsl:if test="current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
													<xsl:attribute name="orderID">
														<xsl:value-of select="(current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'ON']/D_1154)[1]"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="(current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380)[1]"
																/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="(current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379)[1]"
																/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:if>
											</xsl:element>
										</xsl:if>
										<!-- SupplierOrderInfo -->
										<xsl:if
											test="current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != '' or current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
											<xsl:element name="SupplierOrderInfo">
												<xsl:if test="current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
													<xsl:attribute name="orderID">
														<xsl:value-of select="(current-group()//G_SG30/S_RFF/C_C506[D_1153 = 'VN']/D_1154)[1]"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="(current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380)[1]"
																/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="(current-group()//G_SG30[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2379)[1]"
																/>
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
													<xsl:when test="S_LIN/C_C212/D_7143 = 'MP'">service</xsl:when>
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
									<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IL']/D_1154 != ''">
										<xsl:element name="OrderReference">
											<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != ''">
												<xsl:attribute name="orderID">
													<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
											<xsl:element name="DocumentReference">
												<xsl:attribute name="payloadID">
													<xsl:for-each select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'IL']">
														<xsl:value-of select="S_RFF/C_C506/D_1154"/>
													</xsl:for-each>
												</xsl:attribute>
											</xsl:element>
										</xsl:element>
									</xsl:if>
									<!-- MasterAgreementIDInfo -->
									<xsl:if test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AJS']/D_1154 != ''">
										<xsl:element name="MasterAgreementIDInfo">
											<xsl:attribute name="agreementID">
												<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'AJS']/D_1154"/>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '126']/D_2380 != ''">
													<xsl:attribute name="agreementDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '126']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '126']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '629']/D_2380 != ''">
													<xsl:attribute name="agreementDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '629']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '629']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
													<xsl:attribute name="agreementDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'AJS']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
											<xsl:attribute name="agreementType">
												<xsl:text>scheduling_agreement</xsl:text>
											</xsl:attribute>
										</xsl:element>
									</xsl:if>
									<!-- OrderIDInfo -->
									<xsl:if
										test="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154 != '' and (not(M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IL']/D_1154) or M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'IL']/D_1154 = '')">
										<xsl:element name="OrderIDInfo">
											<xsl:attribute name="orderID">
												<xsl:value-of select="M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'ON']/D_1154"/>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'ON']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
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
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '4']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
													<xsl:attribute name="orderDate">
														<xsl:call-template name="convertToAribaDate">
															<xsl:with-param name="dateTime">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
															</xsl:with-param>
															<xsl:with-param name="dateTimeFormat">
																<xsl:value-of
																	select="M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VN']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
										</xsl:element>
									</xsl:if>
								</xsl:element>
								<!-- Defect IG-716 -->
								<!--InvoiceDetailShipNoticeInfo-->
								<xsl:for-each select="M_INVOIC/G_SG26">
									<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'MA']/D_1154 != ''">
										<xsl:element name="InvoiceDetailShipNoticeInfo">
											<xsl:element name="ShipNoticeReference">
												<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'MA']/D_1154 != ''">
													<xsl:attribute name="shipNoticeID">
														<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'MA']/D_1154"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
															<xsl:attribute name="shipNoticeDate">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '171']/D_2380"
																		/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '171']/D_2379"
																		/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</xsl:when>
													</xsl:choose>
													<xsl:element name="DocumentReference">
														<xsl:attribute name="payloadID">
															<xsl:value-of select="$anPayloadID"/>
														</xsl:attribute>
													</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="M_INVOIC/G_SG26">
									<xsl:apply-templates select=".">
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
										<xsl:with-param name="itemMode">
											<xsl:choose>
												<xsl:when test="S_LIN/C_C212/D_7143 = 'MP'">service</xsl:when>
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
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']/D_5004 != ''">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '79' and D_6343 = '7']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']/D_5004 != ''">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '289' and D_6343 = '7']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="Tax">
							<xsl:choose>
								<xsl:when test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']/D_5004 != ''">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']/D_5004 != ''">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '176' and D_6343 = '7']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="Money">
										<xsl:attribute name="currency">USD</xsl:attribute>
										<xsl:text>0.00</xsl:text>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:element name="Description">
								<!-- Defect IG-1453 -->
								<xsl:choose>
									<xsl:when test="M_INVOIC/S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4']/C_C108/D_4440_1 != ''">
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="M_INVOIC/S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4'][1]/D_3453 != ''">
													<xsl:value-of select="M_INVOIC/S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4'][1]/D_3453"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4']">
											<xsl:value-of
												select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="xml:lang">en</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:for-each select="M_INVOIC/G_SG52[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">
								<xsl:variable name="taxCategory">
									<xsl:choose>
										<xsl:when test="S_TAX/C_C241/D_5153 = 'LOC' or S_TAX/C_C241/D_5153 = 'STT'">
											<xsl:choose>
												<xsl:when test="S_TAX/C_C241/D_5152 = '.qc.ca'">
													<xsl:text>qst</xsl:text>
												</xsl:when>
												<xsl:when
													test="S_TAX/C_C241/D_5152 = '.ns.ca' or S_TAX/C_C241/D_5152 = '.nf.ca' or S_TAX/C_C241/D_5152 = '.nb.ca' or S_TAX/C_C241/D_5152 = '.on.ca'">
													<xsl:text>hst</xsl:text>
												</xsl:when>
												<xsl:when test="contains(S_TAX/C_C241/D_5152, '.ca')">
													<xsl:text>pst</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>sales</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
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
									<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
										<xsl:variable name="tpDate">
											<xsl:value-of
												select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2380"
											/>
										</xsl:variable>
										<xsl:variable name="tpDateFormat">
											<xsl:value-of
												select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2379"
											/>
										</xsl:variable>
										<xsl:variable name="payDate">
											<xsl:value-of
												select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2380"
											/>
										</xsl:variable>
										<xsl:variable name="payDateFormat">
											<xsl:value-of
												select="//M_INVOIC/G_SG1[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2379"
											/>
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
										<xsl:when test="S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']/D_5004 != ''">
											<xsl:element name="TaxableAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']"/>
													<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '125' and D_6343 = '7']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:when>
										<xsl:when test="S_TAX/D_5286 != ''">
											<xsl:element name="TaxableAmount">
												<xsl:element name="Money">
													<xsl:attribute name="currency">
														<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
													</xsl:attribute>
													<xsl:choose>
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
											<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
											<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
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
										<xsl:when
											test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat' and normalize-space(//M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000) != ''">
											<xsl:element name="Description">
												<xsl:attribute name="xml:lang">en</xsl:attribute>
												<xsl:value-of
													select="normalize-space(//M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000)"/>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
									<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
										<xsl:if test="../S_FTX[D_4451 = 'TXD'][D_4453 = '4']/C_C108/D_4440_1 != ''">
											<xsl:element name="TriangularTransactionLawReference">
												<xsl:attribute name="xml:lang">
													<xsl:choose>
														<xsl:when test="../S_FTX[D_4451 = 'TXD'][D_4453 = '4'][1]/D_3453 != ''">
															<xsl:value-of select="../S_FTX[D_4451 = 'TXD'][D_4453 = '4'][1]/D_3453"/>
														</xsl:when>
														<xsl:otherwise>en</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:for-each select="../S_FTX[D_4451 = 'TXD'][D_4453 = '4']">
													<xsl:value-of
														select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
												</xsl:for-each>
											</xsl:element>
										</xsl:if>
									</xsl:if>
									<xsl:if test="S_TAX/C_C243/D_5279 != ''">
										<xsl:element name="Extrinsic">
											<xsl:attribute name="name">
												<xsl:text>taxAccountcode</xsl:text>
											</xsl:attribute>
											<xsl:value-of select="S_TAX/C_C243/D_5279"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="S_LOC[D_3227 = '157']/C_C517/D_3225 != ''">
										<xsl:element name="Extrinsic">
											<xsl:attribute name="name">
												<xsl:text>taxJurisdiction</xsl:text>
											</xsl:attribute>
											<xsl:value-of select="S_LOC[D_3227 = '157']/C_C517/D_3225"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="S_TAX/D_5305 = 'S'">
										<xsl:element name="Extrinsic">
											<xsl:attribute name="name">
												<xsl:text>exemptType</xsl:text>
											</xsl:attribute>
											<xsl:text>Standard</xsl:text>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:for-each>
							<!--defect IG-1410 -->
							<!--Shipping Tax and specialHandlingTax Details-->
							<xsl:for-each select="M_INVOIC/G_SG16[S_ALC/C_C214/D_7161 = 'SAA']">
								<xsl:if test="S_ALC/C_C214/D_7161 = 'SAA'">
									<xsl:call-template name="ShippingTax_specialHandlingTax">
										<xsl:with-param name="Group" select="G_SG22"/>
										<xsl:with-param name="purpose">shippingTax</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="M_INVOIC/G_SG16[S_ALC/C_C214/D_7161 = 'SH']">
								<xsl:if test="S_ALC/C_C214/D_7161 = 'SH'">
									<xsl:call-template name="ShippingTax_specialHandlingTax">
										<xsl:with-param name="Group" select="G_SG22"/>
										<xsl:with-param name="purpose">specialHandlingTax</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
						<!-- SpecialHandlingAmount -->
						<xsl:if test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '299' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="SpecialHandlingAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '299' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '299' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
								<xsl:if test="M_INVOIC/S_FTX[D_4451 = 'SPH']/C_C108/D_4440_1 != ''">
									<xsl:element name="Description">
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="M_INVOIC/S_FTX[D_4451 = 'SPH']/D_3453 != ''">
													<xsl:value-of select="M_INVOIC/S_FTX[D_4451 = 'SPH'][1]/D_3453"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:for-each select="M_INVOIC/S_FTX[D_4451 = 'SPH']">
											<xsl:value-of
												select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<!-- ShippingAmount -->
						<xsl:if test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '144' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="ShippingAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '144' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '144' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- GrossAmount -->
						<xsl:if test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '128' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="GrossAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '128' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '128' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- InvoiceDetailDiscount -->
						<xsl:if
							test="M_INVOIC/G_SG16[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG20/S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="InvoiceDetailDiscount">
								<xsl:if
									test="M_INVOIC/G_SG16[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG19/S_PCD/C_C501/D_5245 = '12' and M_INVOIC/G_SG16[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG19/S_PCD/C_C501/D_5249 = '13'">
									<xsl:attribute name="percentageRate">
										<xsl:value-of
											select="M_INVOIC/G_SG16[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG19/S_PCD/C_C501/D_5482"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA"
										select="M_INVOIC/G_SG16[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG20/S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA"
										select="M_INVOIC/G_SG16[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG20/S_MOA/C_C516[D_5025 = '52' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- InvoiceHeaderModifications -->
						<xsl:if
							test="count(M_INVOIC/G_SG16/S_ALC[D_5463 = 'C'][C_C214/D_7161 != 'TX']) &gt; 0 or count(M_INVOIC/G_SG16/S_ALC[D_5463 = 'A'][C_C214/D_7161 != 'DI']) &gt; 0">
							<xsl:element name="InvoiceHeaderModifications">
								<xsl:for-each
									select="M_INVOIC/G_SG16[(S_ALC/D_5463 = 'A' or S_ALC/D_5463 = 'C') and (not(exists(S_ALC/C_C552/D_1230)) or S_ALC/C_C552/D_1230 = '') and (S_ALC[D_5463 = 'C']/C_C214/D_7161 != 'TX' or S_ALC[D_5463 = 'A']/C_C214/D_7161 != 'DI')]">
									<xsl:variable name="modCode">
										<xsl:value-of select="S_ALC/C_C214/D_7161"/>
									</xsl:variable>
									<xsl:if test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
										<xsl:element name="Modification">
											<xsl:if test="G_SG20/S_MOA/C_C516[D_5025 = '98' and D_6343 = '4']/D_5004 != ''">
												<xsl:element name="OriginalPrice">
													<xsl:call-template name="createMoney">
														<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '98' and D_6343 = '4']"/>
														<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
													</xsl:call-template>
												</xsl:element>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="S_ALC/D_5463 = 'A'">
													<xsl:element name="AdditionalDeduction">
														<xsl:choose>
															<xsl:when test="G_SG20/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
																<xsl:element name="DeductionAmount">
																	<xsl:call-template name="createMoney">
																		<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '8' and D_6343 = '4']"/>
																		<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
																	</xsl:call-template>
																</xsl:element>
															</xsl:when>
															<xsl:when test="G_SG19/S_PCD/C_C501/D_5245 = '12' and G_SG19/S_PCD/C_C501/D_5249 = '13'">
																<xsl:element name="DeductionPercent">
																	<xsl:attribute name="percent">
																		<xsl:value-of select="G_SG19/S_PCD/C_C501/D_5482"/>
																	</xsl:attribute>
																</xsl:element>
															</xsl:when>
															<xsl:when test="G_SG20/S_MOA/C_C516[D_5025 = '4']/D_5004 != ''">
																<xsl:element name="DeductedPrice">
																	<xsl:call-template name="createMoney">
																		<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '4' and D_6343 = '4']"/>
																		<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
																	</xsl:call-template>
																</xsl:element>
															</xsl:when>
														</xsl:choose>
													</xsl:element>
												</xsl:when>
												<xsl:when
													test="S_ALC/D_5463 = 'C' and (G_SG20/S_MOA/C_C516[D_5025 = '8']/D_5004 != '' or (G_SG19/S_PCD/C_C501/D_5245 = '12' and G_SG19/S_PCD/C_C501/D_5249 = '13' and G_SG19/S_PCD/C_C501/D_5482 != ''))">
													<xsl:element name="AdditionalCost">
														<xsl:choose>
															<xsl:when test="G_SG20/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
																<xsl:call-template name="createMoney">
																	<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '8' and D_6343 = '4']"/>
																	<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
																</xsl:call-template>
															</xsl:when>
															<xsl:when test="G_SG19/S_PCD/C_C501/D_5245 = '12' and G_SG19/S_PCD/C_C501/D_5249 = '13'">
																<xsl:element name="Percentage">
																	<xsl:attribute name="percent">
																		<xsl:value-of select="G_SG19/S_PCD/C_C501/D_5482"/>
																	</xsl:attribute>
																</xsl:element>
															</xsl:when>
														</xsl:choose>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
											<!-- Modification Tax -->
											<xsl:if
												test="G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' or D_5025 = '124']/D_5004 != '' and G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' or D_5025 = '124']/D_6345 != '' and G_SG22/S_TAX[D_5283 = '9']/D_3446 != ''">
												<xsl:element name="Tax">
													<xsl:choose>
														<xsl:when test="G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '124']/D_5004 != ''">
															<xsl:call-template name="createMoney">
																<xsl:with-param name="MOA"
																	select="G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
																<xsl:with-param name="altMOA"
																	select="G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
																<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:when test="G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176']/D_5004 != ''">
															<xsl:call-template name="createMoney">
																<xsl:with-param name="MOA"
																	select="G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']"/>
																<xsl:with-param name="altMOA"
																	select="G_SG22[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' and D_6343 = '7']"/>
																<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
															</xsl:call-template>
														</xsl:when>
													</xsl:choose>
													<xsl:element name="Description">
														<xsl:attribute name="xml:lang">en</xsl:attribute>
														<xsl:choose>
															<xsl:when test="G_SG22/S_TAX[D_5283 = '9']/D_3446 != ''">
																<xsl:value-of select="G_SG22/S_TAX[D_5283 = '9']/D_3446"/>
															</xsl:when>
														</xsl:choose>
													</xsl:element>
													<xsl:for-each select="G_SG22[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">
														<xsl:variable name="taxCategory">
															<xsl:choose>
																<xsl:when test="S_TAX/C_C241/D_5153 = 'LOC' or S_TAX/C_C241/D_5153 = 'STT'">
																	<xsl:choose>
																		<xsl:when test="S_TAX/C_C241/D_5152 = '.qc.ca'">
																			<xsl:text>qst</xsl:text>
																		</xsl:when>
																		<xsl:when
																			test="S_TAX/C_C241/D_5152 = '.ns.ca' or S_TAX/C_C241/D_5152 = '.nf.ca' or S_TAX/C_C241/D_5152 = '.nb.ca' or S_TAX/C_C241/D_5152 = '.on.ca'">
																			<xsl:text>hst</xsl:text>
																		</xsl:when>
																		<xsl:when test="contains(S_TAX/C_C241/D_5152, '.ca')">
																			<xsl:text>pst</xsl:text>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:text>sales</xsl:text>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:when test="S_TAX/C_C241/D_5153 = 'VAT'">
																	<xsl:text>vat</xsl:text>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>other</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
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
															<xsl:if test="S_TAX/D_5286 != ''">
																<xsl:element name="TaxableAmount">
																	<xsl:element name="Money">
																		<xsl:attribute name="currency">
																			<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
																		</xsl:attribute>
																		<xsl:choose>
																			<xsl:when test="$isCreditMemo = 'yes'">
																				<xsl:value-of select="concat('-', S_TAX/D_5286)"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="S_TAX/D_5286"/>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:element>
																</xsl:element>
															</xsl:if>
															<xsl:element name="TaxAmount">
																<xsl:call-template name="createMoney">
																	<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
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
															<xsl:if test="S_TAX/D_3446 != ''"/>
															<xsl:element name="Description">
																<xsl:attribute name="xml:lang">en</xsl:attribute>
																<xsl:value-of select="S_TAX/D_3446"/>
															</xsl:element>
														</xsl:element>
													</xsl:for-each>
												</xsl:element>
											</xsl:if>
											<!-- ModificationDetail -->
											<xsl:if test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
												<xsl:element name="ModificationDetail">
													<xsl:attribute name="name">
														<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
													</xsl:attribute>
													<xsl:if test="G_SG17[S_RFF/C_C506/D_1153 = 'ZZZ']/S_DTM/C_C507[D_2005 = '194']/D_2380 != ''">
														<xsl:attribute name="startDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="G_SG17[S_RFF/C_C506/D_1153 = 'ZZZ']/S_DTM/C_C507[D_2005 = '194']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="G_SG17[S_RFF/C_C506/D_1153 = 'ZZZ']/S_DTM/C_C507[D_2005 = '194']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="G_SG17[S_RFF/C_C506/D_1153 = 'ZZZ']/S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
														<xsl:attribute name="endDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="dateTime">
																	<xsl:value-of select="G_SG17[S_RFF/C_C506/D_1153 = 'ZZZ']/S_DTM/C_C507[D_2005 = '206']/D_2380"/>
																</xsl:with-param>
																<xsl:with-param name="dateTimeFormat">
																	<xsl:value-of select="G_SG17[S_RFF/C_C506/D_1153 = 'ZZZ']/S_DTM/C_C507[D_2005 = '206']/D_2379"/>
																</xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:choose>
														<xsl:when test="G_SG17/RFF/C_C506[D_1153 = 'ZZZ']/D_1154 != ''">
															<xsl:element name="Description">
																<xsl:attribute name="xml:lang">
																	<xsl:choose>
																		<xsl:when test="G_SG17/RFF/C_C506[D_1153 = 'ZZZ']/D_1156 != ''">
																			<xsl:value-of select="G_SG17/RFF/C_C506[D_1153 = 'ZZZ']/D_1156"/>
																		</xsl:when>
																		<xsl:otherwise>en</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
																<xsl:value-of
																	select="concat(G_SG17/RFF/C_C506[D_1153 = 'ZZZ']/D_1154, G_SG17/RFF/C_C506[D_1153 = 'ZZZ']/D_4000)"
																/>
															</xsl:element>
														</xsl:when>
														<xsl:when test="S_ALC/C_C214/D_7160_1 != ''">
															<xsl:element name="Description">
																<xsl:attribute name="xml:lang">en</xsl:attribute>
																<xsl:value-of select="concat(S_ALC/C_C214/D_7160_1, S_ALC/C_C214/D_7160_2)"/>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:element name="Description">
																<xsl:attribute name="xml:lang">en</xsl:attribute>
																<xsl:value-of
																	select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
															</xsl:element>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="M_INVOIC/G_SG16[(S_ALC/D_5463 = 'A' or S_ALC/D_5463 = 'C') and (S_ALC/C_C552/D_1230 != '')]">
									<xsl:element name="Modification">
										<xsl:if test="G_SG20/S_MOA/C_C516[D_5025 = '98' and D_6343 = '4']/D_5004 != ''">
											<xsl:element name="OriginalPrice">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '98' and D_6343 = '4']"/>
													<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
												</xsl:call-template>
											</xsl:element>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="S_ALC/D_5463 = 'A'">
												<xsl:element name="AdditionalDeduction">
													<xsl:choose>
														<xsl:when test="G_SG20/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
															<xsl:element name="DeductionAmount">
																<xsl:call-template name="createMoney">
																	<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '8' and D_6343 = '4']"/>
																	<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
																</xsl:call-template>
															</xsl:element>
														</xsl:when>
														<xsl:when test="G_SG19/S_PCD/C_C501/D_5245 = '12' and G_SG19/S_PCD/C_C501/D_5249 = '13'">
															<xsl:element name="DeductionPercent">
																<xsl:attribute name="percent">
																	<xsl:value-of select="G_SG19/S_PCD/C_C501/D_5482"/>
																</xsl:attribute>
															</xsl:element>
														</xsl:when>
														<xsl:when test="G_SG20/S_MOA/C_C516[D_5025 = '4']/D_5004 != ''">
															<xsl:element name="DeductedPrice">
																<xsl:call-template name="createMoney">
																	<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '4' and D_6343 = '4']"/>
																	<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
																</xsl:call-template>
															</xsl:element>
														</xsl:when>
													</xsl:choose>
												</xsl:element>
											</xsl:when>
											<xsl:when
												test="S_ALC/D_5463 = 'C' and (G_SG20/S_MOA/C_C516[D_5025 = '8']/D_5004 != '' or (G_SG19/S_PCD/C_C501/D_5245 = '12' and G_SG19/S_PCD/C_C501/D_5249 = '13' and G_SG19/S_PCD/C_C501/D_5482 != ''))">
												<xsl:element name="AdditionalCost">
													<xsl:choose>
														<xsl:when test="G_SG20/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
															<xsl:call-template name="createMoney">
																<xsl:with-param name="MOA" select="G_SG20/S_MOA/C_C516[D_5025 = '8' and D_6343 = '4']"/>
																<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:when test="G_SG19/S_PCD/C_C501/D_5245 = '12' and G_SG19/S_PCD/C_C501/D_5249 = '13'">
															<xsl:element name="Percentage">
																<xsl:attribute name="percent">
																	<xsl:value-of select="G_SG19/S_PCD/C_C501/D_5482"/>
																</xsl:attribute>
															</xsl:element>
														</xsl:when>
													</xsl:choose>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
										<xsl:element name="ModificationDetail">
											<xsl:attribute name="name">
												<xsl:choose>
													<xsl:when test="S_ALC/D_5463 = 'A'">Allowance</xsl:when>
													<xsl:when test="S_ALC/D_5463 = 'C'">Charge</xsl:when>
												</xsl:choose>
											</xsl:attribute>
											<xsl:element name="Description">
												<xsl:attribute name="xml:lang">en</xsl:attribute>
												<xsl:value-of select="S_ALC/C_C552/D_1230"/>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<!-- InvoiceDetailSummaryLineItemModifications -->
						<xsl:if
							test="count(M_INVOIC/G_SG53/S_ALC[D_5463 = 'C'][C_C214/D_7161 != 'TX']) &gt; 0 or count(M_INVOIC/G_SG53/S_ALC[D_5463 = 'A'][C_C214/D_7161 != 'DI']) &gt; 0">
							<xsl:element name="InvoiceDetailSummaryLineItemModifications">
								<xsl:for-each
									select="M_INVOIC/G_SG53[(S_ALC/D_5463 = 'A' or S_ALC/D_5463 = 'C') and (S_ALC[D_5463 = 'C']/C_C214/D_7161 != 'TX' or S_ALC[D_5463 = 'A']/C_C214/D_7161 != 'DI')]">
									<xsl:variable name="modCode">
										<xsl:value-of select="S_ALC/C_C214/D_7161"/>
									</xsl:variable>
									<xsl:if test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
										<xsl:element name="Modification">
											<xsl:choose>
												<xsl:when
													test="S_ALC/D_5463 = 'A' and S_MOA/C_C516[D_5025 = '8' or D_5025 = '131'][D_6343 = '4']/D_5004 != ''">
													<xsl:element name="AdditionalDeduction">
														<xsl:element name="DeductionAmount">
															<xsl:call-template name="createMoney">
																<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131'][D_6343 = '4']"/>
																<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131'][D_6343 = '7']"/>
																<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
															</xsl:call-template>
														</xsl:element>
													</xsl:element>
												</xsl:when>
												<xsl:when
													test="S_ALC/D_5463 = 'C' and S_MOA/C_C516[D_5025 = '8' or D_5025 = '131'][D_6343 = '4']/D_5004 != ''">
													<xsl:element name="AdditionalCost">
														<xsl:call-template name="createMoney">
															<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131'][D_6343 = '4']"/>
															<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '8' or D_5025 = '131'][D_6343 = '7']"/>
															<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
														</xsl:call-template>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
											<!-- ModificationDetail -->
											<xsl:if test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
												<xsl:element name="ModificationDetail">
													<xsl:attribute name="name">
														<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="S_ALC/C_C214/D_7160_1 != ''">
															<xsl:element name="Description">
																<xsl:attribute name="xml:lang">en</xsl:attribute>
																<xsl:value-of select="concat(S_ALC/C_C214/D_7160_1, S_ALC/C_C214/D_7160_2)"/>
																<xsl:if test="S_ALC/C_C552/D_1230 != ''">
																	<xsl:element name="ShortName">
																		<xsl:value-of select="S_ALC/C_C552/D_1230"/>
																	</xsl:element>
																</xsl:if>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:element name="Description">
																<xsl:attribute name="xml:lang">en</xsl:attribute>
																<xsl:value-of
																	select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
																<xsl:if test="S_ALC/C_C552/D_1230 != ''">
																	<xsl:element name="ShortName">
																		<xsl:value-of select="S_ALC/C_C552/D_1230"/>
																	</xsl:element>
																</xsl:if>
															</xsl:element>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<!-- TotalCharges -->
						<xsl:if test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '259' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="TotalCharges">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '259' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '259' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- TotalAllowances -->
						<xsl:if test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '260' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="TotalAllowances">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '260' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '260' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- TotalAmountWithoutTax -->
						<xsl:choose>
							<xsl:when test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = 'ZZZ']/D_5004 != ''">
								<xsl:element name="TotalAmountWithoutTax">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = 'ZZZ' and D_6343 = '4']"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = 'ZZZ' and D_6343 = '7']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:element>
							</xsl:when>
							<xsl:when test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '125']/D_5004 != ''">
								<xsl:element name="TotalAmountWithoutTax">
									<xsl:call-template name="createMoney">
										<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']"/>
										<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '125' and D_6343 = '7']"/>
										<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
									</xsl:call-template>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
						<xsl:element name="NetAmount">
							<xsl:call-template name="createMoney">
								<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '77' and D_6343 = '4']"/>
								<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '77' and D_6343 = '7']"/>
								<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
							</xsl:call-template>
						</xsl:element>
						<!-- DepositAmount -->
						<xsl:if test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '113' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="DepositAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '113' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '113' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
						<!-- DueAmount -->
						<xsl:if test="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '9' and D_6343 = '4']/D_5004 != ''">
							<xsl:element name="DueAmount">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '9' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '9' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- Functions -->
	<!--defect IG-1410 -->
	<xsl:template name="ShippingTax_specialHandlingTax">
		<xsl:param name="Group"/>
		<xsl:param name="purpose"/>
		<xsl:for-each select="$Group[S_TAX/D_5283 = '7']">
			<xsl:if test="S_TAX[D_5283 = '7']">
				<xsl:element name="TaxDetail">
					<xsl:attribute name="purpose">
						<xsl:value-of select="$purpose"/>
					</xsl:attribute>
					<xsl:attribute name="category">
						<xsl:choose>
							<xsl:when test="S_TAX[D_5283 = '7']/C_C241/D_5153 = 'VAT'">
								<xsl:text>vat</xsl:text>
							</xsl:when>
							<xsl:when test="S_TAX[D_5283 = '7']/C_C241/D_5153 = 'GST'">
								<xsl:text>gst</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>other</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="normalize-space(S_TAX[D_5283 = '7']/C_C243/D_5278) != ''">
						<xsl:attribute name="percentageRate">
							<xsl:value-of select="normalize-space(S_TAX[D_5283 = '7']/C_C243/D_5278)"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(S_TAX[D_5283 = '7']/C_C243/D_5305) != ''">
						<xsl:attribute name="exemptDetail">
							<xsl:choose>
								<xsl:when test="normalize-space(S_TAX[D_5283 = '7']/C_C243/D_5305) = 'Z'">
									<xsl:text>zeroRated</xsl:text>
								</xsl:when>
								<xsl:when test="normalize-space(S_TAX[D_5283 = '7']/C_C243/D_5305) = 'E'">
									<xsl:text>exempt</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
					</xsl:if>
					<!--Taxable Amount-->
					<xsl:element name="TaxableAmount">
						<xsl:element name="Money">
							<xsl:attribute name="currency">
								<xsl:if test="S_TAX[D_5283 = '7']">
									<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
								</xsl:if>
							</xsl:attribute>
							<xsl:value-of select="S_TAX[D_5283 = '7']/D_5286"/>
						</xsl:element>
					</xsl:element>
					<!--TaxAmount-->
					<xsl:element name="TaxAmount">
						<xsl:element name="Money">
							<xsl:attribute name="currency">
								<xsl:if test="S_TAX[D_5283 = '7']">
									<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
								</xsl:if>
							</xsl:attribute>
							<xsl:if test="S_TAX[D_5283 = '7']">
								<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_5004"/>
							</xsl:if>
						</xsl:element>
					</xsl:element>
					<!-- TaxLocation -->
					<xsl:if test="normalize-space(S_TAX[D_5283 = '7']/C_C241/D_5152) != ''">
						<xsl:element name="TaxLocation">
							<xsl:attribute name="xml:lang">en</xsl:attribute>
							<xsl:value-of select="normalize-space(S_TAX[D_5283 = '7']/C_C241/D_5152)"/>
						</xsl:element>
					</xsl:if>
					<!--Description-->
					<xsl:if test="normalize-space(S_TAX[D_5283 = '7']/D_3446) != ''">
						<xsl:element name="Description">
							<xsl:attribute name="xml:lang">en</xsl:attribute>
							<xsl:value-of select="normalize-space(S_TAX[D_5283 = '7']/D_3446)"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="normalize-space(S_TAX[D_5283 = '7']/C_C243/D_5305) = 'S'">
						<xsl:element name="Extrinsic">
							<xsl:attribute name="name">
								<xsl:text>exemptType</xsl:text>
							</xsl:attribute>
							<xsl:text>Standard</xsl:text>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="createMoney">
		<xsl:param name="MOA"/>
		<xsl:param name="altMOA"/>
		<xsl:param name="isCreditMemo"/>
		<xsl:element name="Money">
			<xsl:attribute name="currency">
				<xsl:value-of select="$MOA/D_6345"/>
			</xsl:attribute>
			<xsl:if test="$altMOA">
				<xsl:if test="$altMOA/D_5004 != ''">
					<xsl:attribute name="alternateAmount">
						<xsl:choose>
							<xsl:when test="$isCreditMemo = 'yes'">
								<xsl:value-of select="concat('-', $altMOA/D_5004)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$altMOA/D_5004"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$altMOA/D_6345 != ''">
					<xsl:attribute name="alternateCurrency">
						<xsl:value-of select="$altMOA/D_6345"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$isCreditMemo = 'yes'">
					<xsl:value-of select="concat('-', $MOA/D_5004)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$MOA/D_5004"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
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
				<xsl:when test="$dateTimeFormat != ''">
					<xsl:value-of select="$dateTimeFormat"/>
				</xsl:when>
				<xsl:otherwise>102</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tempDateTime">
			<xsl:choose>
				<xsl:when test="$dtmFormat = 102">
					<xsl:value-of select="concat($dateTime, '120000')"/>
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
						<xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode != ''">
							<xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode"/>
						</xsl:when>
						<xsl:otherwise>+00:00</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of
			select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"
		/>
	</xsl:template>
	<!-- template for Contact -->
	<xsl:template match="G_SG2">
		<xsl:param name="role"/>
		<xsl:param name="cMode"/>
		<xsl:element name="Contact">
			<xsl:attribute name="role">
				<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
			</xsl:attribute>
			<xsl:if test="S_NAD/C_C082/D_1131 = '160' or S_NAD/C_C082/D_1131 = 'ZZZ' or not(S_NAD/C_C082/D_1131)">
				<xsl:variable name="addrDomain">
					<xsl:value-of select="S_NAD/C_C082/D_3055"/>
				</xsl:variable>
				<xsl:if test="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain][1]/CXMLCode != ''">
					<xsl:attribute name="addressID">
						<xsl:value-of select="S_NAD/C_C082/D_3039"/>
					</xsl:attribute>
					<xsl:attribute name="addressIDDomain">
						<xsl:value-of select="normalize-space($lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain][1]/CXMLCode)"
						/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:element name="Name">
				<xsl:attribute name="xml:lang">en</xsl:attribute>
				<!-- Defect IG-1236 -->
				<xsl:choose>
					<xsl:when test="$role = 'FR' and not(S_NAD/C_C058)">
						<xsl:value-of select="../S_FTX[D_4451 = 'REG']/C_C108/D_4440_1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
						/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<!-- PostalAddress -->
			<xsl:if test="S_NAD/D_3164 != ''">
				<xsl:element name="PostalAddress">
					<!-- <xsl:attribute name="name"/> -->
					<xsl:if test="S_NAD/C_C080/D_3036_1 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C080/D_3036_1"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3036_2 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C080/D_3036_2"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3036_3 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C080/D_3036_3"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3036_4 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C080/D_3036_4"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C080/D_3036_5 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="S_NAD/C_C080/D_3036_5"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C059/D_3042_1 != ''">
						<xsl:element name="Street">
							<xsl:value-of select="S_NAD/C_C059/D_3042_1"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C059/D_3042_2 != ''">
						<xsl:element name="Street">
							<xsl:value-of select="S_NAD/C_C059/D_3042_2"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C059/D_3042_3 != ''">
						<xsl:element name="Street">
							<xsl:value-of select="S_NAD/C_C059/D_3042_3"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/C_C059/D_3042_4 != ''">
						<xsl:element name="Street">
							<xsl:value-of select="S_NAD/C_C059/D_3042_4"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/D_3164 != ''"/>
					<xsl:element name="City">
						<xsl:value-of select="S_NAD/D_3164"/>
					</xsl:element>
					<xsl:variable name="stateCode">
						<xsl:value-of select="S_NAD/D_3229"/>
					</xsl:variable>
					<xsl:if test="$stateCode != ''">
						<xsl:element name="State">
							<xsl:attribute name="isoStateCode">
								<xsl:value-of select="$stateCode"/>
							</xsl:attribute>
							<xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCode]/stateName"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_NAD/D_3251 != ''">
						<xsl:element name="PostalCode">
							<xsl:value-of select="S_NAD/D_3251"/>
						</xsl:element>
					</xsl:if>
					<xsl:variable name="isoCountryCode">
						<xsl:value-of select="S_NAD/D_3207"/>
					</xsl:variable>
					<xsl:element name="Country">
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$isoCountryCode"/>
						</xsl:attribute>
						<xsl:value-of select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="G_SG5">
				<xsl:variable name="comName">
					<xsl:value-of select="S_CTA/D_3139"/>
				</xsl:variable>
				<xsl:for-each select="S_COM">
					<xsl:choose>
						<xsl:when test="C_C076/D_3155 = 'EM'">
							<xsl:element name="Email">
								<xsl:attribute name="name">
									<xsl:choose>
										<xsl:when test="$comName = 'ZZZ'">
											<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
										</xsl:when>
										<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
											<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>default</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="C_C076/D_3148"/>
								<!--	<xsl:attribute name="preferredLang"/> -->
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="G_SG5">
				<xsl:variable name="comName">
					<xsl:value-of select="S_CTA/D_3139"/>
				</xsl:variable>
				<xsl:for-each select="S_COM">
					<xsl:choose>
						<xsl:when test="C_C076/D_3155 = 'TE'">
							<xsl:element name="Phone">
								<xsl:attribute name="name">
									<xsl:choose>
										<xsl:when test="$comName = 'ZZZ'">
											<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
										</xsl:when>
										<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
											<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>default</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:call-template name="convertToTelephone">
									<xsl:with-param name="phoneNum">
										<xsl:value-of select="C_C076/D_3148"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="G_SG5">
				<xsl:variable name="comName">
					<xsl:value-of select="S_CTA/D_3139"/>
				</xsl:variable>
				<xsl:for-each select="S_COM">
					<xsl:choose>
						<xsl:when test="C_C076/D_3155 = 'FX'">
							<xsl:element name="Fax">
								<xsl:attribute name="name">
									<xsl:choose>
										<xsl:when test="$comName = 'ZZZ'">
											<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
										</xsl:when>
										<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
											<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>default</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:call-template name="convertToTelephone">
									<xsl:with-param name="phoneNum">
										<xsl:value-of select="C_C076/D_3148"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="G_SG5">
				<xsl:variable name="comName">
					<xsl:value-of select="S_CTA/D_3139"/>
				</xsl:variable>
				<xsl:for-each select="S_COM">
					<xsl:choose>
						<xsl:when test="C_C076/D_3155 = 'AH'">
							<xsl:element name="URL">
								<xsl:attribute name="name">
									<xsl:choose>
										<xsl:when test="$comName = 'ZZZ'">
											<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
										</xsl:when>
										<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
											<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>default</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="C_C076/D_3148"/>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>
			<!-- Defect IG-1236 -->
			<xsl:if test="$role = 'FR' and ../S_FTX[D_4451 = 'REG']/C_C108/D_4440_2 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">LegalStatus</xsl:attribute>
					<xsl:value-of select="../S_FTX[D_4451 = 'REG']/C_C108/D_4440_2"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$role = 'FR' and ../S_FTX[D_4451 = 'REG']/C_C108/D_4440_3 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">LegalCapital</xsl:attribute>
					<xsl:variable name="CurrencyLength">3</xsl:variable>
					<xsl:variable name="D_4440_3">
						<xsl:value-of select="../S_FTX[D_4451 = 'REG']/C_C108/D_4440_3"/>
					</xsl:variable>
					<xsl:variable name="length">
						<xsl:value-of select="string-length($D_4440_3)"/>
					</xsl:variable>
					<xsl:variable name="Currency">
						<xsl:value-of select="normalize-space(substring($D_4440_3, ($length - $CurrencyLength), $length))"/>
					</xsl:variable>
					<xsl:variable name="CurrencyValue">
						<xsl:value-of select="normalize-space(substring($D_4440_3, 1, ($length - $CurrencyLength)))"/>
					</xsl:variable>
					<Money>
						<xsl:attribute name="currency">
							<xsl:value-of select="$Currency"/>
						</xsl:attribute>
						<xsl:value-of select="$CurrencyValue"/>
					</Money>
				</xsl:element>
			</xsl:if>
			<!--xsl:if test="$cMode='partner'"-->
		</xsl:element>
		<!-- contact IdReference map -->
		<xsl:if test="$cMode = 'partner'">
			<xsl:for-each select="G_SG3[S_RFF/C_C506/D_1153 != 'ZZZ']">
				<xsl:variable name="refCode" select="S_RFF/C_C506/D_1153"/>
				<xsl:variable name="idRefDomain"
					select="$lookups/Lookups/IdReferenceDomains/IdReferenceDomain[EDIFACTCode = $refCode]/CXMLCode"/>
				<xsl:variable name="refValue" select="S_RFF/C_C506/D_1154"/>
				<xsl:choose>
					<xsl:when test="$role = 'RE' and $idRefDomain = 'supplierTaxID'">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">supplierTaxID</xsl:attribute>
							<xsl:attribute name="identifier" select="$refValue"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$role = 'RE' and $idRefDomain = 'accountID'">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">accountID</xsl:attribute>
							<xsl:attribute name="identifier" select="$refValue"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$role = 'RE' and $idRefDomain = 'bankRoutingID'">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">bankRoutingID</xsl:attribute>
							<xsl:attribute name="identifier" select="$refValue"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$idRefDomain != ''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">
								<xsl:value-of select="$idRefDomain"/>
							</xsl:attribute>
							<xsl:attribute name="identifier" select="$refValue"/>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
		<!--xsl:when test="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154!=''">							<xsl:element name="Extrinsic">								<xsl:attribute name="name">									<xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154"/>								</xsl:attribute>								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_4000"/>							</xsl:element>						</xsl:when-->
	</xsl:template>
	<!-- Mapping for InvoiceDetailItem-->
	<xsl:template match="G_SG26">
		<xsl:param name="isCreditMemo"/>
		<xsl:param name="itemMode"/>
		<xsl:variable name="eleName">
			<xsl:if test="$itemMode = 'item'">InvoiceDetailItem</xsl:if>
			<xsl:if test="$itemMode = 'service'">InvoiceDetailServiceItem</xsl:if>
		</xsl:variable>
		<xsl:element name="{$eleName}">
			<xsl:attribute name="invoiceLineNumber">
				<xsl:value-of select="S_LIN/D_1082"/>
			</xsl:attribute>
			<xsl:attribute name="quantity">
				<xsl:choose>
					<xsl:when test="$isCreditMemo = 'yes'">
						<xsl:value-of select="concat('-', S_QTY/C_C186[D_6063 = '47']/D_6060)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="S_QTY/C_C186[D_6063 = '47']/D_6060"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
				<xsl:attribute name="referenceDate">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime">
							<xsl:value-of select="S_DTM/C_C507[D_2005 = '171']/D_2380"/>
						</xsl:with-param>
						<xsl:with-param name="dateTimeFormat">
							<xsl:value-of select="S_DTM/C_C507[D_2005 = '171']/D_2379"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="S_DTM/C_C507[D_2005 = '351']/D_2380 != ''">
				<xsl:attribute name="inspectionDate">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime">
							<xsl:value-of select="S_DTM/C_C507[D_2005 = '351']/D_2380"/>
						</xsl:with-param>
						<xsl:with-param name="dateTimeFormat">
							<xsl:value-of select="S_DTM/C_C507[D_2005 = '351']/D_2379"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$itemMode = 'service'">
				<xsl:element name="InvoiceDetailServiceItemReference">
					<xsl:attribute name="lineNumber">
						<xsl:value-of select="S_LIN/C_C212[D_7143 = 'MP']/D_7140"/>
					</xsl:attribute>
					<xsl:for-each select="S_PIA[D_4347 = '1']//.[D_7143 = 'CC']">
						<xsl:element name="Classification">
							<xsl:attribute name="domain">
								<xsl:text>UNSPSC</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="code">
								<xsl:value-of select="D_7140"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
					<xsl:if test="S_PIA[D_4347 = '1']//D_7143 = 'VN' or S_PIA[D_4347 = '1']//D_7143 = 'SA' or S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140 != ''">
						<xsl:element name="ItemID">
							<xsl:element name="SupplierPartID">
								<xsl:choose>
									<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'VN']/D_7140 != ''">
										<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'VN']/D_7140"/>
									</xsl:when>
									<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'SA']/D_7140">
										<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'SA']/D_7140"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
							<!-- SupplierPartAuxiliaryID -->
							<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140 != ''">
								<xsl:element name="SupplierPartAuxiliaryID">
									<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140"/>
								</xsl:element>
							</xsl:if>
							<!-- BuyerPartID -->
							<xsl:if
								test="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140 != ''">
								<xsl:element name="BuyerPartID">
									<xsl:choose>
										<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != ''">
											<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140"/>
										</xsl:when>
										<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140">
											<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140"/>
										</xsl:when>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_IMD[D_7077 = 'F']/C_C273/D_7008_1 != '' or S_IMD[D_7077 = 'E']/C_C273/D_7008_1 != ''">
						<xsl:variable name="descLang">
							<xsl:for-each select="S_IMD[D_7077 = 'F']">
								<xsl:value-of select="C_C273/D_3453"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:element name="Description">
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="$descLang != ''">
										<xsl:value-of select="substring($descLang, 1, 2)"/>
									</xsl:when>
									<xsl:when test="S_IMD[D_7077 = 'E']/C_C273/D_3453 != ''">
										<xsl:value-of select="S_IMD[D_7077 = 'E']/C_C273/D_3453"/>
									</xsl:when>
									<xsl:otherwise>en</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:variable name="desc">
								<xsl:for-each select="S_IMD[D_7077 = 'F']/C_C273">
									<xsl:value-of select="concat(D_7008_1, D_7008_2)"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:value-of select="$desc"/>
							<xsl:if test="S_IMD[D_7077 = 'E']/C_C273/D_7008_1 != ''">
								<xsl:element name="ShortName">
									<xsl:value-of select="S_IMD[D_7077 = 'E']/C_C273/D_7008_1"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<!-- SubtotalAmount-->
				<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '289' or D_5025 = '79'][D_6343 = '4']/D_5004 != ''">
					<xsl:element name="SubtotalAmount">
						<xsl:choose>
							<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']/D_5004 != ''">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']/D_5004 != ''">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
				<!-- Period -->
				<xsl:if test="S_DTM/C_C507[D_2005 = '194']/D_2380 != '' and S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
					<xsl:element name="Period">
						<xsl:attribute name="startDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="dateTime">
									<xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2380"/>
								</xsl:with-param>
								<xsl:with-param name="dateTimeFormat">
									<xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2379"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:attribute>
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
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<xsl:element name="UnitOfMeasure">
				<xsl:value-of select="S_QTY/C_C186[D_6063 = '47']/D_6411"/>
			</xsl:element>
			<xsl:element name="UnitPrice">
				<xsl:choose>
					<xsl:when test="G_SG29/S_PRI/C_C509[D_5125 = 'CAL' and D_5118 != '' and empty(D_5387)][1]/D_5118 != ''">
						<xsl:element name="Money">
							<xsl:attribute name="currency">
								<xsl:value-of
									select="G_SG29[S_PRI/C_C509/D_5125 = 'CAL' and S_PRI/C_C509/D_5118 != '' and empty(S_PRI/C_C509/D_5387)][1]/S_CUX/C_C504_1[D_6347 = '2' and D_6343 = '4']/D_6345"
								/>
							</xsl:attribute>
							<xsl:if test="G_SG29/S_PRI/C_C509[D_5125 = 'CAL' and D_5118 != '' and D_5387 = 'ALT'][1]/D_5118 != ''">
								<xsl:attribute name="alternateAmount">
									<xsl:value-of select="G_SG29/S_PRI/C_C509[D_5125 = 'CAL' and D_5118 != '' and D_5387 = 'ALT'][1]/D_5118"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if
								test="G_SG29[S_PRI/C_C509/D_5125 = 'CAL' and S_PRI/C_C509/D_5118 != '' and S_PRI/C_C509/D_5387 = 'ALT'][1]/S_CUX/C_C504_1[D_6347 = '3' and D_6343 = '7']/D_6345 != ''">
								<xsl:attribute name="alternateCurrency">
									<xsl:value-of
										select="G_SG29[S_PRI/C_C509/D_5125 = 'CAL' and S_PRI/C_C509/D_5118 != '' and S_PRI/C_C509/D_5387 = 'ALT'][1]/S_CUX/C_C504_1[D_6347 = '3' and D_6343 = '7']/D_6345"
									/>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="G_SG29/S_PRI/C_C509[D_5125 = 'CAL' and D_5118 != '' and empty(D_5387)][1]/D_5118"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '146' and D_6343 = '4']/D_5004 != ''">
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '146' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '146' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
			<!-- PriceBasisQuantity -->
			<xsl:if
				test="G_SG29/S_PRI/C_C509/D_5125 = 'CAL' and G_SG29/S_APR/D_4043 = 'WS' and G_SG29/S_APR/C_C138/D_5393 = 'CSD' and G_SG29/S_RNG/D_6167 = '4'">
				<xsl:element name="PriceBasisQuantity">
					<xsl:attribute name="quantity">
						<xsl:choose>
							<xsl:when test="$isCreditMemo = 'yes'">
								<xsl:value-of select="concat('-', G_SG29/S_RNG/C_C280/D_6162)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="G_SG29/S_RNG/C_C280/D_6162"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="conversionFactor">
						<xsl:value-of select="G_SG29/S_APR/C_C138/D_5394"/>
					</xsl:attribute>
					<xsl:element name="UnitOfMeasure">
						<xsl:value-of select="G_SG29/S_RNG/C_C280/D_6411"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<!--InvoiceDetailItemReference-->
			<xsl:if test="$itemMode = 'item'">
				<xsl:element name="InvoiceDetailItemReference">
					<xsl:attribute name="lineNumber">
						<xsl:value-of select="S_LIN/C_C212[D_7143 = 'PL']/D_7140"/>
					</xsl:attribute>
					<xsl:if test="S_PIA[D_4347 = '1']//D_7143 = 'SN'">
						<xsl:attribute name="serialNumber">
							<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'SN']/D_7140[1]"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="S_PIA[D_4347 = '1']//D_7143 = 'VN' or S_PIA[D_4347 = '1']//D_7143 = 'SA' or S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140 != ''">
						<xsl:element name="ItemID">
							<xsl:element name="SupplierPartID">
								<xsl:choose>
									<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'VN']/D_7140 != ''">
										<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'VN']/D_7140"/>
									</xsl:when>
									<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'SA']/D_7140">
										<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'SA']/D_7140"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
							<!-- SupplierPartAuxiliaryID -->
							<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140 != ''">
								<xsl:element name="SupplierPartAuxiliaryID">
									<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'VS']/D_7140"/>
								</xsl:element>
							</xsl:if>
							<!-- BuyerPartID -->
							<xsl:if
								test="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != '' or S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140 != ''">
								<xsl:element name="BuyerPartID">
									<xsl:choose>
										<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140 != ''">
											<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'BP']/D_7140"/>
										</xsl:when>
										<xsl:when test="S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140">
											<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'IN']/D_7140"/>
										</xsl:when>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					<xsl:if test="S_IMD[D_7077 = 'F']/C_C273/D_7008_1 != '' or S_IMD[D_7077 = 'E']/C_C273/D_7008_1 != ''">
						<xsl:variable name="descLang">
							<xsl:for-each select="S_IMD[D_7077 = 'F']">
								<xsl:value-of select="C_C273/D_3453"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:element name="Description">
							<xsl:attribute name="xml:lang">
								<xsl:choose>
									<xsl:when test="$descLang != ''">
										<xsl:value-of select="substring($descLang, 1, 2)"/>
									</xsl:when>
									<xsl:when test="S_IMD[D_7077 = 'E']/C_C273/D_3453 != ''">
										<xsl:value-of select="S_IMD[D_7077 = 'E']/C_C273/D_3453"/>
									</xsl:when>
									<xsl:otherwise>en</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:variable name="desc">
								<xsl:for-each select="S_IMD[D_7077 = 'F']/C_C273">
									<xsl:value-of select="concat(D_7008_1, D_7008_2)"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:value-of select="$desc"/>
							<xsl:if test="S_IMD[D_7077 = 'E']/C_C273/D_7008_1 != ''">
								<xsl:element name="ShortName">
									<xsl:value-of select="S_IMD[D_7077 = 'E']/C_C273/D_7008_1"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					<xsl:for-each select="S_PIA[D_4347 = '1']//.[D_7143 = 'CC']">
						<xsl:element name="Classification">
							<xsl:attribute name="domain">
								<xsl:text>UNSPSC</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="code">
								<xsl:value-of select="D_7140"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
					<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'MF']/D_7140 != '' and G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_1 != ''">
						<xsl:element name="ManufacturerPartID">
							<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'MF']/D_7140"/>
						</xsl:element>
						<xsl:element name="ManufacturerName">
							<xsl:value-of
								select="normalize-space(concat(G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_1, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_2, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_3, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_4, G_SG34/S_NAD[D_3035 = 'MF']/C_C058/D_3124_5))"
							/>
						</xsl:element>
					</xsl:if>
					<xsl:for-each select="S_PIA[D_4347 = '1']//.[D_7143 = 'SN']">
						<xsl:element name="SerialNumber">
							<xsl:value-of select="D_7140"/>
						</xsl:element>
					</xsl:for-each>
					<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'EN']/D_7140 != ''">
						<!-- Reduntant condition reserverd for future use -->
						<xsl:element name="InvoiceDetailItemReferenceIndustry">
							<xsl:element name="InvoiceDetailItemReferenceRetail">
								<xsl:if test="S_PIA[D_4347 = '1']//.[D_7143 = 'EN']/D_7140 != ''">
									<xsl:element name="EANID">
										<xsl:value-of select="S_PIA[D_4347 = '1']//.[D_7143 = 'EN']/D_7140"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<!--Defect IG-716-->
				<!--ShipNoticeLineItemReference-->
				<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'MA']/D_1156 != ''">
					<xsl:element name="ShipNoticeLineItemReference">
						<xsl:attribute name="shipNoticeLineNumber">
							<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'MA']/D_1156"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<!-- SubtotalAmount-->
				<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '79' or D_5025 = '289'][D_6343 = '4']/D_5004 != ''">
					<xsl:element name="SubtotalAmount">
						<xsl:choose>
							<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']/D_5004 != ''">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '79' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']/D_5004 != ''">
								<xsl:call-template name="createMoney">
									<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '289' and D_6343 = '7']"/>
									<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<!-- Tax -->
			<xsl:if
				test="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']/D_5004 != '' or G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']/D_5004 != '' or G_SG39/S_ALC/C_C214[D_7161 = 'SAA'] or G_SG39/S_ALC/C_C214[D_7161 = 'SH']">
				<xsl:element name="Tax">
					<xsl:choose>
						<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']/D_5004 != ''">
							<xsl:call-template name="createMoney">
								<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
								<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
								<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']/D_5004 != ''">
							<xsl:call-template name="createMoney">
								<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']"/>
								<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '176' and D_6343 = '7']"/>
								<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:element name="Description">
						<xsl:choose>
							<xsl:when test="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4']/C_C108/D_4440_1 != ''">
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4'][1]/D_3453 != ''">
											<xsl:value-of select="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4'][1]/D_3453"/>
										</xsl:when>
										<xsl:otherwise>en</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:for-each select="S_FTX[D_4451 = 'TXD'][not(exists(D_4453)) or D_4453 != '4']">
									<xsl:value-of
										select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="xml:lang">en</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:for-each select="G_SG34[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">
						<xsl:variable name="taxCategory">
							<xsl:choose>
								<xsl:when test="S_TAX/C_C241/D_5153 = 'LOC' or S_TAX/C_C241/D_5153 = 'STT'">
									<xsl:choose>
										<xsl:when test="S_TAX/C_C241/D_5152 = '.qc.ca'">
											<xsl:text>qst</xsl:text>
										</xsl:when>
										<xsl:when
											test="S_TAX/C_C241/D_5152 = '.ns.ca' or S_TAX/C_C241/D_5152 = '.nf.ca' or S_TAX/C_C241/D_5152 = '.nb.ca' or S_TAX/C_C241/D_5152 = '.on.ca'">
											<xsl:text>hst</xsl:text>
										</xsl:when>
										<xsl:when test="contains(S_TAX/C_C241/D_5152, '.ca')">
											<xsl:text>pst</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>sales</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
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
							<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
								<xsl:variable name="tpDate">
									<xsl:value-of
										select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2380"
									/>
								</xsl:variable>
								<xsl:variable name="tpDateFormat">
									<xsl:value-of
										select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '131']/D_2379"
									/>
								</xsl:variable>
								<xsl:variable name="payDate">
									<xsl:value-of
										select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2380"
									/>
								</xsl:variable>
								<xsl:variable name="payDateFormat">
									<xsl:value-of
										select="../G_SG30[S_RFF/C_C506/D_1153 = 'VA' and S_RFF/C_C506/D_1154 = $vatNum]/S_DTM/C_C507[D_2005 = '140']/D_2379"
									/>
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
								<xsl:when test="S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']/D_5004 != ''">
									<xsl:element name="TaxableAmount">
										<xsl:call-template name="createMoney">
											<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']"/>
											<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '125' and D_6343 = '7']"/>
											<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
										</xsl:call-template>
									</xsl:element>
								</xsl:when>
								<xsl:when test="S_TAX/D_5286 != ''">
									<xsl:element name="TaxableAmount">
										<xsl:element name="Money">
											<xsl:attribute name="currency">
												<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
											</xsl:attribute>
											<xsl:choose>
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
									<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
									<xsl:with-param name="altMOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
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
								<xsl:when
									test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat' and normalize-space(../G_SG30/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000) != ''">
									<xsl:element name="Description">
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:value-of select="normalize-space(../G_SG30/S_RFF/C_C506[D_1153 = 'VA' and D_1154 = $vatNum]/D_4000)"/>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="S_TAX/C_C533/D_5289 = 'TT' and $taxCategory = 'vat'">
								<xsl:if test="S_FTX[D_4451 = 'TXD'][D_4453 = '4']/C_C108/D_4440_1 != ''">
									<xsl:element name="TriangularTransactionLawReference">
										<xsl:attribute name="xml:lang">
											<xsl:choose>
												<xsl:when test="S_FTX[D_4451 = 'TXD'][D_4453 = '4'][1]/D_3453 != ''">
													<xsl:value-of select="S_FTX[D_4451 = 'TXD'][D_4453 = '4'][1]/D_3453"/>
												</xsl:when>
												<xsl:otherwise>en</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:for-each select="S_FTX[D_4451 = 'TXD'][D_4453 = '4']">
											<xsl:value-of
												select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:if>
							<xsl:if test="S_TAX/C_C243/D_5279 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">
										<xsl:text>taxAccountcode</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="S_TAX/C_C243/D_5279"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="S_LOC[D_3227 = '157']/C_C517/D_3225 != ''">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">
										<xsl:text>taxJurisdiction</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="S_LOC[D_3227 = '157']/C_C517/D_3225"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="S_TAX/D_5305 = 'S'">
								<xsl:element name="Extrinsic">
									<xsl:attribute name="name">
										<xsl:text>exemptType</xsl:text>
									</xsl:attribute>
									<xsl:text>Standard</xsl:text>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:for-each>
					<!--defect IG-1410 -->
					<!--Shipping Tax and specialHandlingTax Details-->
					<xsl:for-each select="G_SG39[S_ALC/C_C214/D_7161 = 'SAA']">
						<xsl:if test="S_ALC/C_C214/D_7161 = 'SAA'">
							<xsl:call-template name="ShippingTax_specialHandlingTax">
								<xsl:with-param name="Group" select="G_SG44"/>
								<xsl:with-param name="purpose">shippingTax</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="G_SG39[S_ALC/C_C214/D_7161 = 'SH']">
						<xsl:if test="S_ALC/C_C214/D_7161 = 'SH'">
							<xsl:call-template name="ShippingTax_specialHandlingTax">
								<xsl:with-param name="Group" select="G_SG44"/>
								<xsl:with-param name="purpose">specialHandlingTax</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$itemMode = 'item'">
				<!-- InvoiceDetailLineSpecialHandling -->
				<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '299' and D_6343 = '4']/D_5004 != ''">
					<xsl:element name="InvoiceDetailLineSpecialHandling">
						<xsl:if test="S_FTX[D_4451 = 'SPH']/C_C108/D_4440_1 != ''">
							<xsl:element name="Description">
								<xsl:attribute name="xml:lang">
									<xsl:choose>
										<xsl:when test="S_FTX[D_4451 = 'SPH'][1]/D_3453 != ''">
											<xsl:value-of select="S_FTX[D_4451 = 'SPH'][1]/D_3453"/>
										</xsl:when>
										<xsl:otherwise>en</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:for-each select="S_FTX[D_4451 = 'SPH']">
									<xsl:value-of
										select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '299' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '299' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>
				<!-- InvoiceDetailLineShipping -->
				<xsl:if
					test="G_SG39[S_ALC/D_5463 = 'C'][S_ALC/C_C214/D_7161 = 'SAA']/G_SG42/S_MOA/C_C516[D_5025 = '23'][D_6343 = '4']/D_5004 != ''">
					<xsl:element name="InvoiceDetailLineShipping">
						<xsl:element name="InvoiceDetailShipping">
							<xsl:if test="S_DTM/C_C507[D_2005 = '110']/D_2380 != ''">
								<xsl:attribute name="shippingDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="S_DTM/C_C507[D_2005 = '110']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="S_DTM/C_C507[D_2005 = '110']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:if>
							<xsl:for-each select="G_SG35[S_NAD/D_3035 = 'SF' or S_NAD/D_3035 = 'ST' or S_NAD/D_3035 = 'CA']">
								<xsl:variable name="role">
									<xsl:value-of select="S_NAD/D_3035"/>
								</xsl:variable>
								<xsl:element name="Contact">
									<xsl:attribute name="role">
										<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
									</xsl:attribute>
									<xsl:if test="S_NAD/C_C082/D_1131 = '160' or S_NAD/C_C082/D_1131 = 'ZZZ' or not(S_NAD/C_C082/D_1131)">
										<xsl:variable name="addrDomain">
											<xsl:value-of select="S_NAD/C_C082/D_3055"/>
										</xsl:variable>
										<xsl:if test="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]">
											<xsl:attribute name="addressID">
												<xsl:value-of select="S_NAD/C_C082/D_3039"/>
											</xsl:attribute>
											<xsl:if test="$addrDomain != 91 and $addrDomain != 92">
												<xsl:attribute name="addressIDDomain">
													<xsl:value-of select="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]/CXMLCode"/>
												</xsl:attribute>
											</xsl:if>
										</xsl:if>
									</xsl:if>
									<xsl:element name="Name">
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:value-of
											select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
										/>
									</xsl:element>
									<xsl:if test="S_NAD/D_3164 != ''">
										<xsl:element name="PostalAddress">
											<!-- <xsl:attribute name="name"/> -->
											<xsl:if test="S_NAD/C_C080/D_3036_1 != ''">
												<xsl:element name="DeliverTo">
													<xsl:value-of select="S_NAD/C_C080/D_3036_1"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C080/D_3036_2 != ''">
												<xsl:element name="DeliverTo">
													<xsl:value-of select="S_NAD/C_C080/D_3036_2"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C080/D_3036_3 != ''">
												<xsl:element name="DeliverTo">
													<xsl:value-of select="S_NAD/C_C080/D_3036_3"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C080/D_3036_4 != ''">
												<xsl:element name="DeliverTo">
													<xsl:value-of select="S_NAD/C_C080/D_3036_4"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C080/D_3036_5 != ''">
												<xsl:element name="DeliverTo">
													<xsl:value-of select="S_NAD/C_C080/D_3036_5"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C059/D_3042_1 != ''">
												<xsl:element name="Street">
													<xsl:value-of select="S_NAD/C_C059/D_3042_1"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C059/D_3042_2 != ''">
												<xsl:element name="Street">
													<xsl:value-of select="S_NAD/C_C059/D_3042_2"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C059/D_3042_3 != ''">
												<xsl:element name="Street">
													<xsl:value-of select="S_NAD/C_C059/D_3042_3"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/C_C059/D_3042_4 != ''">
												<xsl:element name="Street">
													<xsl:value-of select="S_NAD/C_C059/D_3042_4"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/D_3164 != ''">
												<xsl:element name="City">
													<xsl:value-of select="S_NAD/D_3164"/>
												</xsl:element>
											</xsl:if>
											<xsl:variable name="stateCode">
												<xsl:value-of select="S_NAD/D_3229"/>
											</xsl:variable>
											<xsl:if test="$stateCode != ''">
												<xsl:element name="State">
													<xsl:attribute name="isoStateCode">
														<xsl:value-of select="$stateCode"/>
													</xsl:attribute>
													<xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCode]/stateName"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="S_NAD/D_3251 != ''">
												<xsl:element name="PostalCode">
													<xsl:value-of select="S_NAD/D_3251"/>
												</xsl:element>
											</xsl:if>
											<xsl:variable name="isoCountryCode">
												<xsl:value-of select="S_NAD/D_3207"/>
											</xsl:variable>
											<xsl:element name="Country">
												<xsl:attribute name="isoCountryCode">
													<xsl:value-of select="$isoCountryCode"/>
												</xsl:attribute>
												<xsl:value-of select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
											</xsl:element>
										</xsl:element>
									</xsl:if>
									<xsl:for-each select="G_SG38">
										<xsl:variable name="comName">
											<xsl:value-of select="S_CTA/D_3139"/>
										</xsl:variable>
										<xsl:for-each select="S_COM">
											<xsl:choose>
												<xsl:when test="C_C076/D_3155 = 'EM'">
													<xsl:element name="Email">
														<xsl:attribute name="name">
															<xsl:choose>
																<xsl:when test="$comName = 'ZZZ'">
																	<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																</xsl:when>
																<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																	<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>default</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of select="C_C076/D_3148"/>
														<!--	<xsl:attribute name="preferredLang"/> -->
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</xsl:for-each>
									<xsl:for-each select="G_SG38">
										<xsl:variable name="comName">
											<xsl:value-of select="S_CTA/D_3139"/>
										</xsl:variable>
										<xsl:for-each select="S_COM">
											<xsl:choose>
												<xsl:when test="C_C076/D_3155 = 'TE'">
													<xsl:element name="Phone">
														<xsl:attribute name="name">
															<xsl:choose>
																<xsl:when test="$comName = 'ZZZ'">
																	<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																</xsl:when>
																<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																	<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>default</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:call-template name="convertToTelephone">
															<xsl:with-param name="phoneNum">
																<xsl:value-of select="C_C076/D_3148"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</xsl:for-each>
									<xsl:for-each select="G_SG38">
										<xsl:variable name="comName">
											<xsl:value-of select="S_CTA/D_3139"/>
										</xsl:variable>
										<xsl:for-each select="S_COM">
											<xsl:choose>
												<xsl:when test="C_C076/D_3155 = 'FX'">
													<xsl:element name="Fax">
														<xsl:attribute name="name">
															<xsl:choose>
																<xsl:when test="$comName = 'ZZZ'">
																	<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																</xsl:when>
																<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																	<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>default</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:call-template name="convertToTelephone">
															<xsl:with-param name="phoneNum">
																<xsl:value-of select="C_C076/D_3148"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</xsl:for-each>
									<xsl:for-each select="G_SG38">
										<xsl:variable name="comName">
											<xsl:value-of select="S_CTA/D_3139"/>
										</xsl:variable>
										<xsl:for-each select="S_COM">
											<xsl:choose>
												<xsl:when test="C_C076/D_3155 = 'AH'">
													<xsl:element name="URL">
														<xsl:attribute name="name">
															<xsl:choose>
																<xsl:when test="$comName = 'ZZZ'">
																	<xsl:value-of select="normalize-space(concat(../S_CTA/C_C056/D_3413, ../S_CTA/C_C056/D_3412))"/>
																</xsl:when>
																<xsl:when test="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode != ''">
																	<xsl:value-of select="$lookups/Lookups/Roles/Role[EDIFACTCode = $role]/CXMLCode"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>default</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of select="C_C076/D_3148"/>
													</xsl:element>
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:element>
							</xsl:for-each>
							<!-- CarrierIdentifier -->
							<xsl:for-each select="G_SG35[S_NAD/D_3035 = 'CA']">
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
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
												/>
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
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
												/>
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
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
												/>
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
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
												/>
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
												<xsl:value-of
													select="concat(S_NAD/C_C058/D_3124_1, S_NAD/C_C058/D_3124_2, S_NAD/C_C058/D_3124_3, S_NAD/C_C058/D_3124_4, S_NAD/C_C058/D_3124_5)"
												/>
											</xsl:element>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
							<!-- ShipmentIdentifier -->
							<xsl:for-each select="G_SG34[S_NAD/D_3035 = 'CA']">
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
						</xsl:element>
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA"
								select="G_SG39[S_ALC/D_5463 = 'C'][S_ALC/C_C214/D_7161 = 'SAA']/G_SG42/S_MOA/C_C516[D_5025 = '23' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA"
								select="G_SG39[S_ALC/D_5463 = 'C'][S_ALC/C_C214/D_7161 = 'SAA']/G_SG42/S_MOA/C_C516[D_5025 = '23' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:if>
				<!-- ShipNoticeIDInfo -->
				<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'MA']/D_1154 != ''">
					<xsl:element name="ShipNoticeIDInfo">
						<xsl:attribute name="shipNoticeID">
							<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'MA']/D_1154"/>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '111']/D_2380 != ''">
								<xsl:attribute name="shipNoticeDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '111']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '111']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
								<xsl:attribute name="shipNoticeDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime">
											<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
										</xsl:with-param>
										<xsl:with-param name="dateTimeFormat">
											<xsl:value-of select="G_SG30[S_RFF/C_C506/D_1153 = 'MA']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<!-- Defect IG-1453 -->
						<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'DQ']/D_1154 != ''">
							<xsl:element name="IdReference ">
								<xsl:attribute name="domain">deliveryNoteID</xsl:attribute>
								<xsl:attribute name="identifier" select="G_SG30/S_RFF/C_C506[D_1153 = 'DQ']/D_1154"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="G_SG30[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380 != ''">
							<xsl:element name="IdReference ">
								<xsl:attribute name="domain">deliveryNoteDate</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime"
											select="G_SG30[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380"/>
										<xsl:with-param name="dateTimeFormat"
											select="G_SG30[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2379"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="G_SG30[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
							<xsl:element name="IdReference ">
								<xsl:attribute name="domain">deliveryNoteDate</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="dateTime"
											select="G_SG30[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
										<xsl:with-param name="dateTimeFormat"
											select="G_SG30[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2379"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'PK']/D_1154 != ''">
							<xsl:element name="IdReference">
								<xsl:attribute name="domain">packListID</xsl:attribute>
								<xsl:attribute name="identifier">
									<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'PK']/D_1154"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<!-- GrossAmount -->
			<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '128' and D_6343 = '4']/D_5004 != ''">
				<xsl:element name="GrossAmount">
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '128' and D_6343 = '4']"/>
						<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '128' and D_6343 = '7']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<!-- InvoiceDetailDiscount -->
			<xsl:if
				test="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG42/S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']/D_5004 != ''">
				<xsl:element name="InvoiceDetailDiscount">
					<xsl:if
						test="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_PCD/C_C501/D_5245 = '12' and G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_PCD/C_C501/D_5249 = '13'">
						<xsl:attribute name="percentageRate">
							<xsl:value-of select="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG41/S_PCD/C_C501/D_5482"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA"
							select="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG42/S_MOA/C_C516[D_5025 = '52' and D_6343 = '4']"/>
						<xsl:with-param name="altMOA"
							select="G_SG39[S_ALC/D_5463 = 'A' and S_ALC/C_C214/D_7161 = 'DI']/G_SG42/S_MOA/C_C516[D_5025 = '52' and D_6343 = '7']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<!-- InvoiceItemModifications -->
			<xsl:if
				test="count(G_SG39/S_ALC[D_5463 = 'C'][C_C214/D_7161 != 'TX']) &gt; 0 or count(G_SG39/S_ALC[D_5463 = 'A'][C_C214/D_7161 != 'DI']) &gt; 0">
				<xsl:element name="InvoiceItemModifications">
					<xsl:for-each
						select="G_SG39[(S_ALC/D_5463 = 'A' or S_ALC/D_5463 = 'C') and (not(exists(S_ALC/C_C552/D_1230)) or S_ALC/C_C552/D_1230 = '') and (S_ALC[D_5463 = 'C']/C_C214/D_7161 != 'TX' or S_ALC[D_5463 = 'A']/C_C214/D_7161 != 'DI')]">
						<xsl:variable name="modCode">
							<xsl:value-of select="S_ALC/C_C214/D_7161"/>
						</xsl:variable>
						<xsl:element name="Modification">
							<xsl:if test="G_SG42/S_MOA/C_C516[D_5025 = '98']/D_5004 != ''">
								<xsl:element name="OriginalPrice">
									<xsl:element name="Money">
										<xsl:attribute name="currency">
											<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '98']/D_6345"/>
										</xsl:attribute>
										<xsl:choose>
											<xsl:when test="$isCreditMemo = 'yes'">
												<xsl:value-of select="concat('-', G_SG42/S_MOA/C_C516[D_5025 = '98']/D_5004)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '98']/D_5004"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="S_ALC/D_5463 = 'A'">
									<xsl:element name="AdditionalDeduction">
										<xsl:choose>
											<xsl:when test="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
												<xsl:element name="DeductionAmount">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_6345"/>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$isCreditMemo = 'yes'">
																<xsl:value-of select="concat('-', G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:element>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG41/S_PCD/C_C501/D_5245 = '12' and G_SG41/S_PCD/C_C501/D_5249 = '13'">
												<xsl:element name="DeductionPercent">
													<xsl:attribute name="percent">
														<xsl:value-of select="G_SG41/S_PCD/C_C501/D_5482"/>
													</xsl:attribute>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG42/S_MOA/C_C516[D_5025 = '4']/D_5004 != ''">
												<xsl:element name="DeductedPrice">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '4']/D_6345"/>
														</xsl:attribute>
														<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '4']/D_5004"/>
													</xsl:element>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
								</xsl:when>
								<xsl:when
									test="S_ALC/D_5463 = 'C' and ((G_SG41/S_PCD/C_C501/D_5245 = '12' and G_SG41/S_PCD/C_C501/D_5249 = '13' and G_SG41/S_PCD/C_C501/D_5482 != '') or (G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''))">
									<xsl:element name="AdditionalCost">
										<xsl:choose>
											<xsl:when test="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
												<xsl:element name="Money">
													<xsl:attribute name="currency">
														<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_6345"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="$isCreditMemo = 'yes'">
															<xsl:value-of select="concat('-', G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG41/S_PCD/C_C501/D_5245 = '12' and G_SG41/S_PCD/C_C501/D_5249 = '13'">
												<xsl:element name="Percentage">
													<xsl:attribute name="percent">
														<xsl:value-of select="G_SG41/S_PCD/C_C501/D_5482"/>
													</xsl:attribute>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
							<!-- Modification Tax -->
							<xsl:if
								test="G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' or D_5025 = '124']/D_5004 != '' and G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' or D_5025 = '124']/D_6345 != '' and G_SG44/S_TAX[D_5283 = '9']/D_3446 != ''">
								<xsl:element name="Tax">
									<xsl:choose>
										<xsl:when test="G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '124']/D_5004 != ''">
											<xsl:call-template name="createMoney">
												<xsl:with-param name="MOA"
													select="G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
												<xsl:with-param name="altMOA"
													select="G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '124' and D_6343 = '7']"/>
												<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176']/D_5004 != ''">
											<xsl:call-template name="createMoney">
												<xsl:with-param name="MOA"
													select="G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' and D_6343 = '4']"/>
												<xsl:with-param name="altMOA"
													select="G_SG44[S_TAX/D_5283 = '9']/S_MOA/C_C516[D_5025 = '176' and D_6343 = '7']"/>
												<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
									<xsl:element name="Description">
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:choose>
											<xsl:when test="G_SG44/S_TAX[D_5283 = '9']/D_3446 != ''">
												<xsl:value-of select="G_SG44/S_TAX[D_5283 = '9']/D_3446"/>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
									<xsl:for-each select="G_SG44[S_TAX/D_5283 = '5' or S_TAX/D_5283 = '7']">
										<xsl:variable name="taxCategory">
											<xsl:choose>
												<xsl:when test="S_TAX/C_C241/D_5153 = 'LOC' or S_TAX/C_C241/D_5153 = 'STT'">
													<xsl:choose>
														<xsl:when test="S_TAX/C_C241/D_5152 = '.qc.ca'">
															<xsl:text>qst</xsl:text>
														</xsl:when>
														<xsl:when
															test="S_TAX/C_C241/D_5152 = '.ns.ca' or S_TAX/C_C241/D_5152 = '.nf.ca' or S_TAX/C_C241/D_5152 = '.nb.ca' or S_TAX/C_C241/D_5152 = '.on.ca'">
															<xsl:text>hst</xsl:text>
														</xsl:when>
														<xsl:when test="contains(S_TAX/C_C241/D_5152, '.ca')">
															<xsl:text>pst</xsl:text>
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>sales</xsl:text>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:when test="S_TAX/C_C241/D_5153 = 'VAT'">
													<xsl:text>vat</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>other</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
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
											<xsl:if test="S_TAX/D_5286 != ''">
												<xsl:element name="TaxableAmount">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="S_MOA/C_C516[D_5025 = '124']/D_6345"/>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$isCreditMemo = 'yes'">
																<xsl:value-of select="concat('-', S_TAX/D_5286)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="S_TAX/D_5286"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:element>
												</xsl:element>
											</xsl:if>
											<xsl:element name="TaxAmount">
												<xsl:call-template name="createMoney">
													<xsl:with-param name="MOA" select="S_MOA/C_C516[D_5025 = '124' and D_6343 = '4']"/>
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
											<xsl:if test="S_TAX/D_3446 != ''">
												<xsl:element name="Description">
													<xsl:attribute name="xml:lang">en</xsl:attribute>
													<xsl:value-of select="S_TAX/D_3446"/>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode != ''">
								<xsl:element name="ModificationDetail">
									<xsl:attribute name="name">
										<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
									</xsl:attribute>
									<xsl:if test="S_DTM/C_C507[D_2005 = '194']/D_2380 != ''">
										<xsl:attribute name="startDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="dateTime">
													<xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2380"/>
												</xsl:with-param>
												<xsl:with-param name="dateTimeFormat">
													<xsl:value-of select="S_DTM/C_C507[D_2005 = '194']/D_2379"/>
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
										<xsl:value-of select="$lookups/Lookups/Modifications/Modification[EDIFACTCode = $modCode]/CXMLCode"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:for-each>
					<xsl:for-each select="G_SG39[(S_ALC/D_5463 = 'A' or S_ALC/D_5463 = 'C') and (S_ALC/C_C552/D_1230 != '')]">
						<xsl:element name="Modification">
							<xsl:if test="G_SG42/S_MOA/C_C516[D_5025 = '98']/D_5004 != ''">
								<xsl:element name="OriginalPrice">
									<xsl:element name="Money">
										<xsl:attribute name="currency">
											<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '98']/D_6345"/>
										</xsl:attribute>
										<xsl:choose>
											<xsl:when test="$isCreditMemo = 'yes'">
												<xsl:value-of select="concat('-', G_SG42/S_MOA/C_C516[D_5025 = '98']/D_5004)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '98']/D_5004"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="S_ALC/D_5463 = 'A'">
									<xsl:element name="AdditionalDeduction">
										<xsl:choose>
											<xsl:when test="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
												<xsl:element name="DeductionAmount">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_6345"/>
														</xsl:attribute>
														<xsl:choose>
															<xsl:when test="$isCreditMemo = 'yes'">
																<xsl:value-of select="concat('-', G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:element>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG41/S_PCD/C_C501/D_5245 = '12' and G_SG41/S_PCD/C_C501/D_5249 = '13'">
												<xsl:element name="DeductionPercent">
													<xsl:attribute name="percent">
														<xsl:value-of select="G_SG41/S_PCD/C_C501/D_5482"/>
													</xsl:attribute>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG42/S_MOA/C_C516[D_5025 = '4']/D_5004 != ''">
												<xsl:element name="DeductedPrice">
													<xsl:element name="Money">
														<xsl:attribute name="currency">
															<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '4']/D_6345"/>
														</xsl:attribute>
														<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '4']/D_5004"/>
													</xsl:element>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
								</xsl:when>
								<xsl:when test="S_ALC/D_5463 = 'C'">
									<xsl:element name="AdditionalCost">
										<xsl:choose>
											<xsl:when test="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004 != ''">
												<xsl:element name="Money">
													<xsl:attribute name="currency">
														<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_6345"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="$isCreditMemo = 'yes'">
															<xsl:value-of select="concat('-', G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="G_SG42/S_MOA/C_C516[D_5025 = '8']/D_5004"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:element>
											</xsl:when>
											<xsl:when test="G_SG41/S_PCD/C_C501/D_5245 = '12' and G_SG41/S_PCD/C_C501/D_5249 = '13'">
												<xsl:element name="Percentage">
													<xsl:attribute name="percent">
														<xsl:value-of select="G_SG41/S_PCD/C_C501/D_5482"/>
													</xsl:attribute>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
							<xsl:element name="ModificationDetail">
								<xsl:attribute name="name">
									<xsl:choose>
										<xsl:when test="S_ALC/D_5463 = 'A'">Allowance</xsl:when>
										<xsl:when test="S_ALC/D_5463 = 'C'">Charge</xsl:when>
									</xsl:choose>
								</xsl:attribute>
								<xsl:element name="Description">
									<xsl:attribute name="xml:lang">en</xsl:attribute>
									<xsl:value-of select="S_ALC/C_C552/D_1230"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			<!-- TotalCharges -->
			<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '259' and D_6343 = '4']/D_5004 != ''">
				<xsl:element name="TotalCharges">
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '259' and D_6343 = '4']"/>
						<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '259' and D_6343 = '7']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<!-- TotalAllowances -->
			<xsl:if test="G_SG27/S_MOA/C_C516[D_5025 = '260' and D_6343 = '4']/D_5004 != ''">
				<xsl:element name="TotalAllowances">
					<xsl:call-template name="createMoney">
						<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '260' and D_6343 = '4']"/>
						<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '260' and D_6343 = '7']"/>
						<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<!-- TotalAmountWithoutTax -->
			<xsl:choose>
				<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = 'ZZZ' and D_6343 = '4']/D_5004 != ''">
					<xsl:element name="TotalAmountWithoutTax">
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = 'ZZZ' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = 'ZZZ' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
				<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']/D_5004 != ''">
					<xsl:element name="TotalAmountWithoutTax">
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '125' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '125' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<!-- NetAmount -->
			<xsl:choose>
				<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '38' and D_6343 = '4']/D_5004 != ''">
					<xsl:element name="NetAmount">
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '38' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '38' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
				<xsl:when test="G_SG27/S_MOA/C_C516[D_5025 = '203' and D_6343 = '4']/D_5004 != ''">
					<xsl:element name="NetAmount">
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG27/S_MOA/C_C516[D_5025 = '203' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA" select="G_SG27/S_MOA/C_C516[D_5025 = '203' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<!-- Distribution -->
			<xsl:for-each select="G_SG39[S_ALC/D_5463 = 'N' and S_ALC/C_C214/D_7161 = 'AEC']">
				<xsl:element name="Distribution">
					<xsl:element name="Accounting">
						<xsl:attribute name="name">
							<xsl:value-of select="S_ALC/C_C552/D_1230"/>
						</xsl:attribute>
						<xsl:element name="AccountingSegment">
							<xsl:attribute name="id">
								<xsl:value-of select="S_ALC/C_C214/D_7160_1"/>
							</xsl:attribute>
							<xsl:element name="Name">
								<xsl:attribute name="xml:lang">en</xsl:attribute>
								<xsl:value-of select="S_ALC/C_C214/D_7160_2"/>
							</xsl:element>
							<xsl:element name="Description">
								<xsl:attribute name="xml:lang">en</xsl:attribute>
								<xsl:value-of select="S_ALC/C_C214/D_7160_2"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="Charge">
						<xsl:call-template name="createMoney">
							<xsl:with-param name="MOA" select="G_SG42/S_MOA/C_C516[D_5025 = '54' and D_6343 = '4']"/>
							<xsl:with-param name="altMOA" select="G_SG42/S_MOA/C_C516[D_5025 = '54' and D_6343 = '7']"/>
							<xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<!-- Comments -->
			<xsl:variable name="comment">
				<xsl:for-each select="S_FTX[D_4451 = 'AAI']">
					<xsl:value-of select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="commentLang">
				<xsl:for-each select="S_FTX[D_4451 = 'AAI']">
					<xsl:value-of select="D_3453"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="$comment != ''">
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
				</xsl:element>
			</xsl:if>
			<!-- Extrinsics -->
			<xsl:for-each select="./G_SG33[S_LOC/D_3227 = '27' or S_LOC/D_3227 = '28']">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:choose>
							<xsl:when test="S_LOC/D_3227 = '27'">
								<xsl:text>shipFromCountry</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>shipToCountry</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="S_LOC/C_C517/D_3225"/>
				</xsl:element>
			</xsl:for-each>
			<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'AWE']/D_1154 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>costCenter</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AWE']/D_1154"/>
				</xsl:element>
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>ApprovalUserCostCenter</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AWE']/D_1154"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'AOU']/D_1154 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>GLAccount</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AOU']/D_1154"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="G_SG30/S_RFF/C_C506[D_1153 = 'AKW']/D_1154 != ''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:text>FreightCostKey</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="G_SG30/S_RFF/C_C506[D_1153 = 'AKW']/D_1154"/>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="S_FTX[D_4451 = 'ZZZ']">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:value-of select="C_C107/D_4441"/>
					</xsl:attribute>
					<xsl:value-of select="concat(C_C108/D_4440_1, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="G_SG30/S_RFF/C_C506[D_1153 = 'ZZZ']">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">
						<xsl:value-of select="./D_1154"/>
					</xsl:attribute>
					<xsl:value-of select="./D_4000"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
