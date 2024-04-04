<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<!-- For local testing -->
	<!--<xsl:include href="Format_CXML_EANCOM_common.xsl"/>
	<xsl:variable name="Lookup" select="document('cXML_EDILookups_EANCOM.xml')"/>-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_EANCOM_D01BEAN010.xsl"/>	
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_EANCOM_D01BEAN005.xml')"/>
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
	<xsl:param name="anGLNFlip"/>
	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:9:eancom">
			<S_UNA>:+.? '</S_UNA>
			<S_UNB>
				<C_S001>
					<D_0001>UNOC</D_0001>
					<D_0002>3</D_0002>
				</C_S001>
				<xsl:choose>
					<xsl:when test="lower-case($anGLNFlip) = 'true'">
						<C_S002>
							<D_0004>
								<xsl:value-of select="$anSenderGroupID"/>
							</D_0004>
							<D_0007>
								<xsl:value-of select="$anISASenderQual"/>
							</D_0007>
							<!--D_0008>								<xsl:value-of select="$anSenderGroupID"/>							</D_0008-->
						</C_S002>
					</xsl:when>
					<xsl:otherwise>
						<C_S002>
							<D_0004>
								<xsl:value-of select="$anISASender"/>
							</D_0004>
							<D_0007>
								<xsl:value-of select="$anISASenderQual"/>
							</D_0007>
							<D_0008>
								<xsl:value-of select="$anSenderGroupID"/>
							</D_0008>
						</C_S002>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="lower-case($anGLNFlip) = 'true'">
						<C_S003>
							<D_0010>
								<xsl:value-of select="$anISAReceiver"/>
							</D_0010>
							<D_0007>
								<xsl:value-of select="$anISAReceiverQual"/>
							</D_0007>
							<!--D_0014>
								<xsl:value-of select="$anReceiverGroupID"/>
							</D_0014-->
						</C_S003>
					</xsl:when>
					<xsl:otherwise>
						<C_S003>
							<D_0010>
								<xsl:value-of select="$anISAReceiver"/>
							</D_0010>
							<D_0007>
								<xsl:value-of select="$anISAReceiverQual"/>
							</D_0007>
							<D_0014>
								<xsl:value-of select="$anReceiverGroupID"/>
							</D_0014>
						</C_S003>
					</xsl:otherwise>
				</xsl:choose>
				<C_S004>
					<D_0017>
						<xsl:value-of select="format-dateTime($dateNow, '[Y01][M01][D01]')"/>
					</D_0017>
					<D_0019>
						<xsl:value-of select="format-dateTime($dateNow, '[H01][M01]')"/>
					</D_0019>
				</C_S004>
				<D_0020>
					<xsl:value-of select="$anICNValue"/>
				</D_0020>
				<D_0026>REMADV</D_0026>
				<xsl:if test="upper-case($anEnvName) = 'TEST'">
					<D_0035>1</D_0035>
				</xsl:if>
			</S_UNB>
			<xsl:element name="M_REMADV">
				<S_UNH>
					<D_0062>0001</D_0062>
					<C_S009>
						<D_0065>REMADV</D_0065>
						<D_0052>D</D_0052>
						<D_0054>01B</D_0054>
						<D_0051>UN</D_0051>
						<D_0057>EAN005</D_0057>
					</C_S009>
				</S_UNH>
				<S_BGM>
					<C_C002>
						<D_1001>481</D_1001>
					</C_C002>
					<C_C106>
						<D_1004>
							<xsl:value-of
								select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentRemittanceID)"
							/>
						</D_1004>
					</C_C106>
					<D_1225>
						<xsl:choose>
							<xsl:when
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name = 'isDuplicate']"
								>31</xsl:when>
							<xsl:otherwise>9</xsl:otherwise>
						</xsl:choose>
					</D_1225>
				</S_BGM>
				<!-- paymentDate -->
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate) != ''">
					<S_DTM>
						<C_C507>
							<D_2005>137</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate"
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate"
								/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>
				<!--PaymentIDInfoDate-->
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentIDInfo/@paymentDate) != ''">
					<S_DTM>
						<C_C507>
							<D_2005>138</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate"
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentIDInfo/@paymentDate"
								/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>
				<!-- Payment Reference Number -->
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentReferenceNumber) != ''">
					<S_RFF>
						<C_C506>
							<D_1153>PQ</D_1153>
							<D_1154>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentReferenceNumber), 1, 35)"
								/>
							</D_1154>
						</C_C506>
					</S_RFF>
				</xsl:if>
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentIDInfo/@paymentRemittanceID) != ''">
					<S_RFF>
						<C_C506>
							<D_1153>ACW</D_1153>
							<D_1154>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentIDInfo/@paymentRemittanceID), 1, 35)"
								/>
							</D_1154>
						</C_C506>
					</S_RFF>
				</xsl:if>
				<!-- IG-7682 -->
				<!--<xsl:for-each select="/cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name != 'isDuplicate'][@name != 'PaymentConditionsCode']">
					<S_RFF>
						<C_C506>
							<D_1153>ZZZ</D_1153>
							<D_1154>
								<xsl:value-of select="@name"/>
							</D_1154>
							<D_4000>
								<xsl:value-of select="."/>
							</D_4000>
						</C_C506>
					</S_RFF>
				</xsl:for-each>-->
				<!--<S_FII> -->
				<!--payer-->
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'bankAccountID']/@identifier) != ''">
					<S_FII>
						<D_3035>PB</D_3035>
						<C_C078>
							<D_3194>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'bankAccountID']/@identifier), 1, 35)"
								/>
							</D_3194>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountName']/@identifier != ''">
								<D_3192>
									<xsl:value-of
										select="substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountName']/@identifier, 1, 35)"
									/>
								</D_3192>
							</xsl:if>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountType']/@identifier != ''">
								<D_3192_2>
									<xsl:value-of
										select="substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountType']/@identifier, 1, 35)"
									/>
								</D_3192_2>
							</xsl:if>
						</C_C078>
						<xsl:if
							test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankBranchID']">
							<C_C088>
								<D_3434>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankBranchID']/@identifier), 1, 17)"
									/>
								</D_3434>
								<D_1131_2>25</D_1131_2>
								<D_3055_2>5</D_3055_2>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']/Name) != ''">
									<D_3432>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']/Name), 1, 70)"
										/>
									</D_3432>
								</xsl:if>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankRoutingID']/@identifier) != ''">
									<D_3436>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankRoutingID']/@identifier), 1, 70)"
										/>
									</D_3436>
								</xsl:if>
							</C_C088>
						</xsl:if>
					</S_FII>
				</xsl:if>
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'ibanID']/@identifier) != ''">
					<S_FII>
						<D_3035>PB</D_3035>
						<C_C078>
							<D_3194>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'ibanID']/@identifier), 1, 35)"
								/>
							</D_3194>
							<xsl:if
								test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountName']/@identifier) != ''">
								<D_3192>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountName']/@identifier), 1, 35)"
									/>
								</D_3192>
							</xsl:if>
							<xsl:if
								test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountType']/@identifier) != ''">
								<D_3192_2>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'accountType']/@identifier), 1, 35)"
									/>
								</D_3192_2>
							</xsl:if>
						</C_C078>
						<xsl:if
							test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'swiftID']/@identifier) != ''">
							<C_C088>
								<D_3434>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'swiftID']/@identifier), 1, 17)"
									/>
								</D_3434>
								<D_1131_2>25</D_1131_2>
								<D_3055_2>17</D_3055_2>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']/Name) != ''">
									<D_3432>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']/Name), 1, 70)"
										/>
									</D_3432>
								</xsl:if>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankRoutingID']/@identifier) != ''">
									<D_3436>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = 'bankRoutingID']/@identifier), 1, 70)"
										/>
									</D_3436>
								</xsl:if>
							</C_C088>
						</xsl:if>
					</S_FII>
				</xsl:if>
				<!--payee-->
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'bankAccountID']/@identifier) != ''">
					<S_FII>
						<D_3035>RB</D_3035>
						<C_C078>
							<D_3194>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'bankAccountID']/@identifier), 1, 35)"
								/>
							</D_3194>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountName']/@identifier != ''">
								<D_3192>
									<xsl:value-of
										select="substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountName']/@identifier, 1, 35)"
									/>
								</D_3192>
							</xsl:if>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountType']/@identifier != ''">
								<D_3192_2>
									<xsl:value-of
										select="substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountType']/@identifier, 1, 35)"
									/>
								</D_3192_2>
							</xsl:if>
						</C_C078>
						<xsl:if
							test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankBranchID']">
							<C_C088>
								<D_3434>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankBranchID']/@identifier), 1, 17)"
									/>
								</D_3434>
								<D_1131_2>25</D_1131_2>
								<D_3055_2>5</D_3055_2>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']/Name) != ''">
									<D_3432>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']/Name), 1, 70)"
										/>
									</D_3432>
								</xsl:if>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier) != ''">
									<D_3436>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier), 1, 70)"
										/>
									</D_3436>
								</xsl:if>
							</C_C088>
						</xsl:if>
					</S_FII>
				</xsl:if>
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'ibanID']/@identifier) != ''">
					<S_FII>
						<D_3035>RB</D_3035>
						<C_C078>
							<D_3194>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'ibanID']/@identifier), 1, 35)"
								/>
							</D_3194>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountName']/@identifier != ''">
								<D_3192>
									<xsl:value-of
										select="substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountName']/@identifier, 1, 35)"
									/>
								</D_3192>
							</xsl:if>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountType']/@identifier != ''">
								<D_3192_2>
									<xsl:value-of
										select="substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'accountType']/@identifier, 1, 35)"
									/>
								</D_3192_2>
							</xsl:if>
						</C_C078>
						<xsl:if
							test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'swiftID']">
							<C_C088>
								<D_3434>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'swiftID']/@identifier), 1, 17)"
									/>
								</D_3434>
								<D_1131_2>25</D_1131_2>
								<D_3055_2>17</D_3055_2>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']/Name) != ''">
									<D_3432>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']/Name), 1, 70)"
										/>
									</D_3432>
								</xsl:if>
								<xsl:if
									test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier) != ''">
									<D_3436>
										<xsl:value-of
											select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier), 1, 70)"
										/>
									</D_3436>
								</xsl:if>
							</C_C088>
						</xsl:if>
					</S_FII>
				</xsl:if>
				<xsl:variable name="paymethodtype"
					select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/@type"/>
				<xsl:variable name="paymentmethod_code"
					select="$Lookup/Lookups/PaymentMethodTypes/PaymentMethodType/PaymentMethod[CXMLCode = $paymethodtype]/EANCOMCode"/>
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name = 'PaymentConditionsCode'] = 'directPayment' or $paymentmethod_code != ''">
					<S_PAI>
						<C_C534>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name = 'PaymentConditionsCode'] = 'directPayment'">
								<D_4439>
									<xsl:value-of select="'1'"/>
								</D_4439>
							</xsl:if>
							<xsl:if test="$paymentmethod_code != ''">
								<D_4461>
									<xsl:value-of select="$paymentmethod_code"/>
								</D_4461>
							</xsl:if>
						</C_C534>
					</S_PAI>
				</xsl:if>
				<!-- Contact -->
				<xsl:for-each
					select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact">
					<xsl:if test="@role != 'originatingBank' and @role != 'receivingBank'">
						<G_SG1>
							<xsl:call-template name="createNAD">
								<xsl:with-param name="party" select="."/>
								<xsl:with-param name="role" select="@role"/>
							</xsl:call-template>
							<xsl:call-template name="CTACOMLoop">
								<xsl:with-param name="contact" select="."/>
								<xsl:with-param name="isJITorFOR" select="'true'"/>
								<xsl:with-param name="level" select="'Header'"/>
							</xsl:call-template>
						</G_SG1>
					</xsl:if>
				</xsl:for-each>
				<xsl:if
					test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@currency) != '' or normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateCurrency) != ''">
					<G_SG4>
						<S_CUX>
							<C_C504>
								<D_6347>2</D_6347>
								<D_6345>
									<xsl:value-of
										select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@currency"
									/>
								</D_6345>
								<D_6343>11</D_6343>
							</C_C504>
							<xsl:if
								test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateCurrency != ''">
								<C_C504_2>
									<D_6347>3</D_6347>
									<D_6345>
										<xsl:value-of
											select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateCurrency"
										/>
									</D_6345>
									<D_6343>4</D_6343>
								</C_C504_2>
							</xsl:if>
						</S_CUX>
					</G_SG4>
				</xsl:if>
				<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/RemittanceDetail">
					<G_SG5>
						<S_DOC>
							<C_C002>
								<D_1001>
									<xsl:choose>
										<xsl:when test="exists(PayableInfo/PayableInvoiceInfo)"
											>380</xsl:when>
										<xsl:when test="exists(PayableInfo/PayableOrderInfo)"
											>220</xsl:when>
										<xsl:when
											test="exists(PayableInfo/PayableMasterAgreementInfo)"
											>315</xsl:when>
									</xsl:choose>
								</D_1001>
							</C_C002>
							<!-- correct xPath -->
							<!--<xsl:if test="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID)!=''">								<C_C503>									<D_1004>										<xsl:value-of select="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID)"/>									</D_1004>								</C_C503>							</xsl:if>-->
							<C_C503>
								<D_1004>
									<!-- IG-3408 -->
									<xsl:choose>
										<xsl:when
											test="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID) != ''">
											<xsl:value-of
												select="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID)"
											/>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceReference/@invoiceID) != ''">
											<xsl:value-of
												select="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceReference/@invoiceID)"
											/>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableOrderInfo/OrderReference/@orderID) != ''">
											<xsl:value-of
												select="normalize-space(PayableInfo/PayableOrderInfo/OrderReference/@orderID)"
											/>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableOrderInfo/OrderIDInfo/@orderID) != ''">
											<xsl:value-of
												select="normalize-space(PayableInfo/PayableOrderInfo/OrderIDInfo/@orderID)"
											/>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementID) != ''">
											<xsl:value-of
												select="normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementID)"
											/>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID) != ''">
											<xsl:value-of
												select="normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID)"
											/>
										</xsl:when>
									</xsl:choose>
								</D_1004>
							</C_C503>
						</S_DOC>
						<xsl:if test="normalize-space(GrossAmount/Money) != ''">
							<S_MOA>
								<C_C516>
									<D_5025>9</D_5025>
									<D_5004>
										<xsl:call-template name="formatAmount">
											<xsl:with-param name="amount"
												select="normalize-space(GrossAmount/Money)"/>
										</xsl:call-template>
									</D_5004>
									<D_6345>
										<xsl:value-of
											select="normalize-space(GrossAmount/Money/@currency)"/>
									</D_6345>
									<D_6343>11</D_6343>
								</C_C516>
							</S_MOA>
						</xsl:if>
						<xsl:if test="normalize-space(NetAmount/Money) != ''">
							<S_MOA>
								<C_C516>
									<D_5025>12</D_5025>
									<D_5004>
										<xsl:call-template name="formatAmount">
											<xsl:with-param name="amount"
												select="normalize-space(NetAmount/Money)"/>
										</xsl:call-template>
									</D_5004>
									<D_6345>
										<xsl:value-of
											select="normalize-space(NetAmount/Money/@currency)"/>
									</D_6345>
									<D_6343>11</D_6343>
								</C_C516>
							</S_MOA>
						</xsl:if>
						<xsl:if test="normalize-space(DiscountAmount/Money) != ''">
							<S_MOA>
								<C_C516>
									<D_5025>52</D_5025>
									<D_5004>
										<xsl:call-template name="formatAmount">
											<xsl:with-param name="amount"
												select="normalize-space(DiscountAmount/Money)"/>
										</xsl:call-template>
									</D_5004>
									<D_6345>
										<xsl:value-of
											select="normalize-space(DiscountAmount/Money/@currency)"
										/>
									</D_6345>
									<D_6343>11</D_6343>
								</C_C516>
							</S_MOA>
						</xsl:if>
						<xsl:for-each select="AdjustmentAmount">
							<xsl:if test="normalize-space(@type) = '' or exists(Modifications)">
								<S_MOA>
									<C_C516>
										<D_5025>165</D_5025>
										<D_5004>
											<xsl:call-template name="formatAmount">
												<xsl:with-param name="amount"
												select="normalize-space(Money)"/>
											</xsl:call-template>
										</D_5004>
										<D_6345>
											<xsl:value-of select="normalize-space(Money/@currency)"
											/>
										</D_6345>
										<D_6343>11</D_6343>
									</C_C516>
								</S_MOA>
							</xsl:if>
						</xsl:for-each>
						<!-- IG-3408 -->
						<xsl:if
							test="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate != '' or PayableInfo/PayableInvoiceInfo/InvoiceReference/@invoiceDate != ''">
							<S_DTM>
								<C_C507>
									<D_2005>3</D_2005>
									<xsl:choose>
										<xsl:when
											test="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate"
												/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when
											test="PayableInfo/PayableInvoiceInfo/InvoiceReference/@invoiceDate != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableInvoiceInfo/InvoiceReference/@invoiceDate"
												/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</C_C507>
							</S_DTM>
						</xsl:if>
						<!-- IG-3408 -->
						<xsl:if
							test="(normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderReference/@orderDate) != '' or normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderDate) != '') or (normalize-space(PayableInfo/PayableOrderInfo/OrderReference/@orderDate) != '' or normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate) != '')">
							<S_DTM>
								<C_C507>
									<D_2005>4</D_2005>
									<xsl:choose>
										<xsl:when
											test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderReference/@orderDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderReference/@orderDate"
												/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderDate"
												/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableOrderInfo/OrderReference/@orderDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableOrderInfo/OrderReference/@orderDate"
												/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate"
												/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</C_C507>
							</S_DTM>
						</xsl:if>
						<!-- Aggrement Date -->
						<!-- IG-3408 -->
						<xsl:if
							test="(normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementDate) != '' or normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate) != '') or (normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementDate) != '' or normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate) != '')">
							<S_DTM>
								<C_C507>
									<D_2005>126</D_2005>
									<xsl:choose>
										<xsl:when
											test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementDate"
												/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate"
												/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementDate"
												/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when
											test="normalize-space(PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate) != ''">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate"
												select="PayableInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate"
												/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</C_C507>
							</S_DTM>
						</xsl:if>
						<!-- IG-3408 -->
						<xsl:if
							test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderReference/@orderID) != '' or normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID) != ''">
							<S_RFF>
								<C_C506>
									<D_1153>ON</D_1153>
									<D_1154>
										<xsl:choose>
											<xsl:when
												test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderReference/@orderID) != ''">
												<xsl:value-of
												select="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderReference/@orderID)"
												/>
											</xsl:when>
											<xsl:when
												test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID) != ''">
												<xsl:value-of
												select="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID)"
												/>
											</xsl:when>
										</xsl:choose>
									</D_1154>
								</C_C506>
							</S_RFF>
						</xsl:if>
						<xsl:if
							test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID) != '' or normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementID) != ''">
							<S_RFF>
								<C_C506>
									<D_1153>CT</D_1153>
									<D_1154>
										<xsl:choose>
											<xsl:when
												test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID) != ''">
												<xsl:value-of
												select="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID)"
												/>
											</xsl:when>
											<xsl:when
												test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementID) != ''">
												<xsl:value-of
												select="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementReference/@agreementID)"
												/>
											</xsl:when>
										</xsl:choose>
									</D_1154>
								</C_C506>
							</S_RFF>
						</xsl:if>
						<xsl:if test="@referenceDocumentNumber != ''">
							<S_RFF>
								<C_C506>
									<D_1153>ACE</D_1153>
									<D_1154>
										<xsl:value-of select="@referenceDocumentNumber"/>
									</D_1154>
								</C_C506>
							</S_RFF>
						</xsl:if>
						<!-- Ig7682 -->
						<xsl:for-each select="Extrinsic">
							<xsl:choose>
								<xsl:when test="@name = 'PaymentProposalID'">
									<S_RFF>
										<C_C506>
											<D_1153>AGA</D_1153>
											<D_1154>
												<xsl:value-of select="."/>
											</D_1154>
										</C_C506>
									</S_RFF>
								</xsl:when>
								<xsl:otherwise>
									<S_RFF>
										<C_C506>
											<D_1153>ZZZ</D_1153>
											<D_1154>
												<xsl:value-of select="@name"/>
											</D_1154>
											<D_4000>
												<xsl:value-of select="."/>
											</D_4000>
										</C_C506>
									</S_RFF>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="AdjustmentAmount">
							<xsl:variable name="AdjType">
								<xsl:value-of select="@type"/>
							</xsl:variable>
							<xsl:for-each select="Modifications/Modification">
								<xsl:variable name="AddType">
									<xsl:value-of select="AdditionalDeduction/@type"/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="AdditionalDeduction/@type != ''">
										<G_SG7>
											<S_AJT>
												<D_4465>
												<xsl:value-of
												select="$Lookup/Lookups/AdjustmentCodes/AdjustmentCode[CXMLCode = $AddType]/EANCOMCode"
												/>
												</D_4465>
											</S_AJT>
											<xsl:if test="normalize-space(../../Description) != ''">
												<S_FTX>
												<D_4451>ACB</D_4451>
												<xsl:variable name="StrLen"
												select="string-length(../../Description)"/>
												<C_C108>
												<D_4440>
												<xsl:value-of
												select="substring(../../Description, 1, 512)"/>
												</D_4440>
												<xsl:if test="$StrLen &gt; 512">
												<D_4440_2>
												<xsl:value-of
												select="substring(../../Description, 513, 512)"/>
												</D_4440_2>
												</xsl:if>
												</C_C108>
												<D_3453>
												<xsl:value-of
												select="upper-case(../../Description/@xml:lang)"/>
												</D_3453>
												</S_FTX>
											</xsl:if>
										</G_SG7>
									</xsl:when>
									<xsl:otherwise>
										<G_SG7>
											<S_AJT>
												<D_4465>
												<xsl:choose>
												<xsl:when test="$AdjType != ''">
												<xsl:value-of
												select="$Lookup/Lookups/AdjustmentCodes/AdjustmentCode[CXMLCode = $AdjType]/EANCOMCode"
												/>
												</xsl:when>
												<xsl:otherwise>ZZZ</xsl:otherwise>
												</xsl:choose>
												</D_4465>
											</S_AJT>
											<xsl:if test="normalize-space(../../Description) != ''">
												<S_FTX>
												<D_4451>ACB</D_4451>
												<xsl:variable name="StrLen"
												select="string-length(../../Description)"/>
												<C_C108>
												<D_4440>
												<xsl:value-of
												select="substring(../../Description, 1, 512)"/>
												</D_4440>
												<xsl:if test="$StrLen &gt; 512">
												<D_4440_2>
												<xsl:value-of
												select="substring(../../Description, 513, 512)"/>
												</D_4440_2>
												</xsl:if>
												</C_C108>
												<D_3453>
												<xsl:value-of
												select="upper-case(../../Description/@xml:lang)"/>
												</D_3453>
												</S_FTX>
											</xsl:if>
										</G_SG7>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
							<xsl:if test="not(exists(Modifications/Modification))">
								<G_SG7>
									<S_AJT>
										<D_4465>
											<xsl:choose>
												<xsl:when test="$AdjType != ''">
												<xsl:value-of
												select="$Lookup/Lookups/AdjustmentCodes/AdjustmentCode[CXMLCode = $AdjType]/EANCOMCode"
												/>
												</xsl:when>
												<xsl:otherwise>ZZZ</xsl:otherwise>
											</xsl:choose>
										</D_4465>
									</S_AJT>
									<xsl:if test="normalize-space(Money) != ''">
										<S_MOA>
											<C_C516>
												<D_5025>165</D_5025>
												<D_5004>
												<xsl:call-template name="formatAmount">
												<xsl:with-param name="amount"
												select="normalize-space(Money)"/>
												</xsl:call-template>
												</D_5004>
												<D_6345>
												<xsl:value-of
												select="normalize-space(Money/@currency)"/>
												</D_6345>
												<D_6343>11</D_6343>
											</C_C516>
										</S_MOA>
									</xsl:if>
									<xsl:if test="normalize-space(Description) != ''">
										<S_FTX>
											<D_4451>ACB</D_4451>
											<xsl:variable name="StrLen"
												select="string-length(Description)"/>
											<C_C108>
												<D_4440>
												<xsl:value-of
												select="substring(Description, 1, 512)"/>
												</D_4440>
												<xsl:if test="$StrLen &gt; 512">
												<D_4440_2>
												<xsl:value-of
												select="substring(Description, 513, 512)"/>
												</D_4440_2>
												</xsl:if>
											</C_C108>
											<D_3453>
												<xsl:value-of
												select="upper-case(Description/@xml:lang)"/>
											</D_3453>
										</S_FTX>
									</xsl:if>
								</G_SG7>
							</xsl:if>
						</xsl:for-each>
					</G_SG5>
				</xsl:for-each>
				<!--- Summary -->
				<S_UNS>
					<D_0081>S</D_0081>
				</S_UNS>
				<!--NetAmount-->
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money != ''">
					<S_MOA>
						<C_C516>
							<D_5025>12</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@currency"
								/>
							</D_6345>
							<D_6343>11</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateAmount != ''">
					<S_MOA>
						<C_C516>
							<D_5025>12</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateAmount)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateCurrency"
								/>
							</D_6345>
							<D_6343>4</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<!--GrossAmount-->
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money != ''">
					<S_MOA>
						<C_C516>
							<D_5025>9</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money/@currency"
								/>
							</D_6345>
							<D_6343>11</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money/@alternateAmount != ''">
					<S_MOA>
						<C_C516>
							<D_5025>9</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money/@alternateAmount)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money/@alternateCurrency"
								/>
							</D_6345>
							<D_6343>4</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<!--DiscountAmount-->
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money != ''">
					<S_MOA>
						<C_C516>
							<D_5025>138</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money/@currency"
								/>
							</D_6345>
							<D_6343>11</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money/@alternateAmount != ''">
					<S_MOA>
						<C_C516>
							<D_5025>138</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money/@alternateAmount)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money/@alternateCurrency"
								/>
							</D_6345>
							<D_6343>4</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<!--AdjustmentAmount-->
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money != ''">
					<S_MOA>
						<C_C516>
							<D_5025>165</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money/@currency"
								/>
							</D_6345>
							<D_6343>11</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<xsl:if
					test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money/@alternateAmount != ''">
					<S_MOA>
						<C_C516>
							<D_5025>165</D_5025>
							<D_5004>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount"
										select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money/@alternateAmount)"
									/>
								</xsl:call-template>
							</D_5004>
							<D_6345>
								<xsl:value-of
									select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money/@alternateCurrency"
								/>
							</D_6345>
							<D_6343>4</D_6343>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<S_UNT>
					<D_0074>#segCount#</D_0074>
					<D_0062>0001</D_0062>
				</S_UNT>
			</xsl:element>
			<S_UNZ>
				<D_0036>1</D_0036>
				<D_0020>
					<xsl:value-of select="$anICNValue"/>
				</D_0020>
			</S_UNZ>
		</ns0:Interchange>
	</xsl:template>
</xsl:stylesheet>
