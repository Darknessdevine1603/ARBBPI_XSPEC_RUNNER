<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output indent="yes" omit-xml-declaration="yes"/>

	<!-- For local testing -->
	<!--xsl:variable name="Lookup" select="document('cXML_EDILookups_D96A.xml')"/>
	<xsl:include href="Format_CXML_D96A_common.xsl"/-->
	<!-- for dynamic, reading from Partner Directory -->
	<xsl:include href="FORMAT_cXML_0000_UN-EDIFACT_D96A.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>

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

	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact">
			<S_UNA>:+.? '</S_UNA>
			<S_UNB>
				<C_S001>
					<D_0001>UNOC</D_0001>
					<D_0002>3</D_0002>
				</C_S001>
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
						<D_0054>96A</D_0054>
						<D_0051>UN</D_0051>
					</C_S009>
				</S_UNH>
				<S_BGM>
					<C_C002>
						<D_1001>481</D_1001>
						<D_1131>150</D_1131>
						<D_3055>92</D_3055>
						<D_1000>Payment Remittance</D_1000>
					</C_C002>
					<D_1004>
						<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentRemittanceID"/>
					</D_1004>
					<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic/@name='isDuplicate'">
						<D_1225>7</D_1225>
					</xsl:if>
				</S_BGM>
				<!-- Doc date -->
				<xsl:if test="cXML/@timestamp!=''">
					<S_DTM>
						<C_C507>
							<D_2005>137</D_2005>
							<D_2380>
								<xsl:value-of select="replace(substring(cXML/@timestamp,0,11),'-','')"/>
							</D_2380>
							<D_2379>102</D_2379>
						</C_C507>
					</S_DTM>
				</xsl:if>
				<!-- paymentDate -->
				<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate!=''">
					<S_DTM>
						<C_C507>
							<D_2005>203</D_2005>
							<D_2380>
								<xsl:value-of select="replace(substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate,0,11),'-','')"/>
							</D_2380>
							<D_2379>102</D_2379>
						</C_C507>
					</S_DTM>
				</xsl:if>
				<!-- Payment OrderID (1)-->
				<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name='PaymentOrderID'])!=''">
					<S_RFF>
						<C_C506>
							<D_1153>AEK</D_1153>
							<D_1154>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name='PaymentOrderID']),1,35)"/>
							</D_1154>
						</C_C506>
					</S_RFF>
				</xsl:if>
				<!-- Payment Reference Number (2) -->
				<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentReferenceNumber)!=''">
					<S_RFF>
						<C_C506>
							<D_1153>PQ</D_1153>
							<D_1154>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentReferenceNumber), 1, 35)"/>
							</D_1154>
						</C_C506>
					</S_RFF>
				</xsl:if>
				<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain='bankAccountID']/@identifier)!=''">
					<S_FII>
						<D_3035>PR</D_3035>
						<C_C078>
							<D_3194>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain='bankAccountID']/@identifier), 1, 35)"/>
							</D_3194>

							<xsl:variable name="conName" select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payer']/Name)"/>
							<xsl:if test="$conName!=''">
								<D_3192>
									<xsl:value-of select="substring($conName,1,35)"></xsl:value-of>
								</D_3192>
							</xsl:if>
							<xsl:if test="substring($conName,36)!=''">
								<D_3192_2>
									<xsl:value-of select="substring($conName,36,35)"></xsl:value-of>
								</D_3192_2>
							</xsl:if>
						</C_C078>
					</S_FII>
				</xsl:if>
				<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain='bankAccountID']/@identifier)!=''">
					<S_FII>
						<D_3035>PE</D_3035>
						<C_C078>
							<D_3194>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain='bankAccountID']/@identifier), 1, 35)"/>
							</D_3194>
							<xsl:variable name="conName" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'payee']/Name"/>
							<xsl:if test="$conName!=''">
								<D_3192>
									<xsl:value-of select="substring($conName,1,35)"></xsl:value-of>
								</D_3192>
							</xsl:if>
							<xsl:if test="substring($conName,36)!=''">
								<D_3192_2>
									<xsl:value-of select="substring($conName,36,35)"></xsl:value-of>
								</D_3192_2>
							</xsl:if>
						</C_C078>
					</S_FII>
				</xsl:if>
				<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain='bankRoutingID']/@identifier)!=''">
					<S_FII>
						<D_3035>PB</D_3035>
						<C_C088>
							<D_3433>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain='bankRoutingID']/@identifier), 1, 11)"/>
							</D_3433>
							<D_1131>150</D_1131>
							<D_3055>ZZZ</D_3055>
							<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']/Name)!=''">
								<D_3432>
									<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'originatingBank']/Name),1,70)"></xsl:value-of>
								</D_3432>
							</xsl:if>
						</C_C088>
					</S_FII>
				</xsl:if>
				<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain='bankRoutingID']/@identifier)!=''">
					<S_FII>
						<D_3035>RB</D_3035>
						<C_C088>
							<D_3433>
								<xsl:value-of select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain='bankRoutingID']/@identifier)"/>
							</D_3433>
							<D_1131>150</D_1131>
							<D_3055>ZZZ</D_3055>
							<xsl:if test="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']/Name),1,70)!=''">
								<D_3192>
									<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact[@role = 'receivingBank']/Name),1,70)"></xsl:value-of>
								</D_3192>
							</xsl:if>
						</C_C088>
					</S_FII>
				</xsl:if>

				<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name='PaymentConditionsCode']      or (normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/@type)!='')">
					<S_PAI>
						<C_C534>
							<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name='PaymentConditionsCode'])!=''">
								<D_4439>TBP</D_4439>
							</xsl:if>
							<xsl:variable name="paymethodtype" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/@type"/>
							<xsl:if test="$Lookup/Lookups/PaymentMethodTypes/PaymentMethodType/PaymentMethod[CXMLCode=$paymethodtype]/EDIFACTCode!=''">
								<D_4461>
									<xsl:value-of select="$Lookup/Lookups/PaymentMethodTypes/PaymentMethodType/PaymentMethod[CXMLCode=$paymethodtype]/EDIFACTCode"/>
								</D_4461>
							</xsl:if>
						</C_C534>
					</S_PAI>
				</xsl:if>

				<!-- Comments -->
				<xsl:variable name="Comments" select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Comments)"/>
				<xsl:if test="$Comments!=''">
					<S_FTX>
						<D_4451>AAI</D_4451>
						<D_4453>4</D_4453>
						<C_C108>
							<xsl:if test="substring($Comments,1,70) != ''">
								<D_4440>
									<xsl:value-of select="substring($Comments,1,70)"/>
								</D_4440>
							</xsl:if>
							<xsl:if test="substring($Comments,71,70) != ''">
								<D_4440_2>
									<xsl:value-of select="substring($Comments,71,70)"/>
								</D_4440_2>
							</xsl:if>
							<xsl:if test="substring($Comments,141,70) != ''">
								<D_4440_3>
									<xsl:value-of select="substring($Comments,141,70)"/>
								</D_4440_3>
							</xsl:if>
							<xsl:if test="substring($Comments,211,70) != ''">
								<D_4440_4>
									<xsl:value-of select="substring($Comments,211,70)"/>
								</D_4440_4>
							</xsl:if>
							<xsl:if test="substring($Comments,281,70) != ''">
								<D_4440_5>
									<xsl:value-of select="substring($Comments,281,70)"/>
								</D_4440_5>
							</xsl:if>
						</C_C108>
						<D_3453>
							<xsl:choose>
								<xsl:when test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Comments/@xml:lang)!= ''">
									<xsl:value-of select="upper-case(substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Comments/@xml:lang), 1, 3))"/>
								</xsl:when>
								<xsl:otherwise>EN</xsl:otherwise>
							</xsl:choose>
						</D_3453>
					</S_FTX>
				</xsl:if>

				<!-- Comments -->
				<xsl:variable name="paymentDesc" select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/Description)"/>
				<xsl:if test="$paymentDesc!=''">
					<S_FTX>
						<D_4451>PAI</D_4451>
						<D_4453>4</D_4453>
						<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/Description/ShortName)!= ''">
							<C_C107>
								<D_4441>
									<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/Description/ShortName), 1, 3)"/>
								</D_4441>
							</C_C107>
						</xsl:if>
						<C_C108>
							<xsl:if test="substring($paymentDesc,1,70) != ''">
								<D_4440>
									<xsl:value-of select="substring($paymentDesc,1,70)"/>
								</D_4440>
							</xsl:if>
							<xsl:if test="substring($paymentDesc,71,70) != ''">
								<D_4440_2>
									<xsl:value-of select="substring($paymentDesc,71,70)"/>
								</D_4440_2>
							</xsl:if>
							<xsl:if test="substring($paymentDesc,141,70) != ''">
								<D_4440_3>
									<xsl:value-of select="substring($paymentDesc,141,70)"/>
								</D_4440_3>
							</xsl:if>
							<xsl:if test="substring($paymentDesc,211,70) != ''">
								<D_4440_4>
									<xsl:value-of select="substring($paymentDesc,211,70)"/>
								</D_4440_4>
							</xsl:if>
							<xsl:if test="substring($paymentDesc,281,70) != ''">
								<D_4440_5>
									<xsl:value-of select="substring($paymentDesc,281,70)"/>
								</D_4440_5>
							</xsl:if>
						</C_C108>
						<D_3453>
							<xsl:choose>
								<xsl:when test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/Description/@xml:lang) != ''">
									<xsl:value-of select="upper-case(substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/Description/@xml:lang), 1, 3))"/>
								</xsl:when>
								<xsl:otherwise>EN</xsl:otherwise>
							</xsl:choose>
						</D_3453>
					</S_FTX>
				</xsl:if>
				<!--  Extrinsic -->
				<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic[@name!='isDuplicate' and @name!='PaymentOrderID' and @name!='PaymentConditionsCode']">
					<S_FTX>
						<D_4451>ZZZ</D_4451>
						<D_4453>4</D_4453>
						<!--xsl:if test="normalize-space(./@name)!= ''">
							<C_C107>
								<D_4441>
									<xsl:value-of select="./@name"/>
								</D_4441>
							</C_C107>
						</xsl:if-->
						<xsl:variable name="Extr" select="normalize-space(.)"/>
						<C_C108>
							<D_4440>
								<xsl:value-of select="substring(normalize-space(./@name),1,70)"/>
							</D_4440>
							<xsl:if test="substring($Extr,1,70)!=''">
								<D_4440_2>
									<xsl:value-of select="substring($Extr,1,70)"/>
								</D_4440_2>
							</xsl:if>
							<xsl:if test="substring($Extr,71,70)!=''">
								<D_4440_3>
									<xsl:value-of select="substring($Extr,71,70)"/>
								</D_4440_3>
							</xsl:if>
							<xsl:if test="substring($Extr,141,70)!=''">
								<D_4440_4>
									<xsl:value-of select="substring($Extr,141,70)"/>
								</D_4440_4>
							</xsl:if>
							<xsl:if test="substring($Extr,211,70)!=''">
								<D_4440_5>
									<xsl:value-of select="substring($Extr,211,70)"/>
								</D_4440_5>
							</xsl:if>
						</C_C108>
					</S_FTX>
				</xsl:for-each>
				<!-- Contact -->
				<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner/Contact">
					<G_SG1>
						<S_NAD>
							<D_3035>
								<xsl:variable name="role" select="@role"/>
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode=$role]/EDIFACTCode!=''">
										<xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode=$role]/EDIFACTCode"/>
									</xsl:when>
									<xsl:otherwise>ZZZ</xsl:otherwise>
								</xsl:choose>
							</D_3035>
							<xsl:if test="normalize-space(@addressID)!=''">
								<C_C082>
									<D_3039>
										<xsl:value-of select="substring(normalize-space(@addressID), 1, 35)"/>
									</D_3039>
									<xsl:variable name="addrDomain" select="normalize-space(@addressIDDomain)"/>
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode=$addrDomain]/EDIFACTCode!=''">
											<D_3055>
												<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode=$addrDomain]/EDIFACTCode"/>
											</D_3055>
										</xsl:when>
									</xsl:choose>
								</C_C082>
							</xsl:if>
							<xsl:variable name="CAddressName" select="normalize-space(Name)"/>
							<xsl:if test="$CAddressName!=''">
								<C_C058>
									<D_3124>
										<xsl:value-of select="substring($CAddressName,1,35)"/>
									</D_3124>
									<xsl:if test="normalize-space(substring($CAddressName,36, 35))!= ''">
										<D_3124_2>
											<xsl:value-of select="normalize-space(substring($CAddressName,36, 35))"/>
										</D_3124_2>
									</xsl:if>
								</C_C058>
							</xsl:if>

							<xsl:variable name="delTo">
								<DeliverToList>
									<xsl:for-each select="PostalAddress/DeliverTo">
										<xsl:if test="normalize-space(.)!=''">
											<DeliverToItem>
												<xsl:value-of select="substring(normalize-space(.), 1, 35)"/>
											</DeliverToItem>
										</xsl:if>
									</xsl:for-each>
								</DeliverToList>
							</xsl:variable>
							<xsl:if test="$delTo!=''">
								<C_C080>
									<xsl:for-each select="$delTo/DeliverToList/DeliverToItem[5 &gt;= position()]">
										<xsl:choose>
												<xsl:when test="position()=1">
													<xsl:element name="D_3036">
														<xsl:value-of select="substring(normalize-space(.),1,35)"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:element name="{concat('D_3036_', position())}">
														<xsl:value-of select="substring(normalize-space(.),1,35)"/>
													</xsl:element>
												</xsl:otherwise>
											</xsl:choose>
									</xsl:for-each>
								</C_C080>
							</xsl:if>
							<xsl:if test="PostalAddress">
								<xsl:variable name="street">
									<StreetList>
										<xsl:for-each select="PostalAddress/Street">
											<xsl:if test="normalize-space(.)!=''">
												<StreetItem>
													<xsl:value-of select="substring(normalize-space(.), 1,35)"/>
												</StreetItem>
											</xsl:if>
										</xsl:for-each>
									</StreetList>
								</xsl:variable>
								<xsl:if test="$street!=''">
									<C_C059>
										<xsl:for-each select="$street/StreetList/StreetItem[4 &gt;= position()]">
											<xsl:choose>
												<xsl:when test="position()=1">
													<xsl:element name="D_3042">
														<xsl:value-of select="substring(normalize-space(.),1,35)"/>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:element name="{concat('D_3042_', position())}">
														<xsl:value-of select="substring(normalize-space(.),1,35)"/>
													</xsl:element>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</C_C059>
								</xsl:if>

								<xsl:if test="normalize-space(PostalAddress/City)!=''">
									<D_3164>
										<xsl:value-of select="substring(normalize-space(PostalAddress/City), 1, 35)"/>
									</D_3164>
								</xsl:if>
								<xsl:if test="normalize-space(PostalAddress/State)!=''">
									<D_3229>
										<xsl:value-of select="substring(normalize-space(PostalAddress/State), 1, 9)"/>
									</D_3229>
								</xsl:if>
								<xsl:if test="normalize-space(PostalAddress/PostalCode)!=''">
									<D_3251>
										<xsl:value-of select="substring(normalize-space(PostalAddress/PostalCode), 1, 9)"/>
									</D_3251>
								</xsl:if>
								<xsl:if test="normalize-space(PostalAddress/Country/@isoCountryCode)!=''">
									<D_3207>
										<xsl:value-of select="substring(normalize-space(PostalAddress/Country/@isoCountryCode), 1, 3)"/>
									</D_3207>
								</xsl:if>
							</xsl:if>
						</S_NAD>
						<xsl:call-template name="CTACOMLoop">
							<xsl:with-param name="contact" select="."/>
							<xsl:with-param name="contactType" select="@role"/>
							<xsl:with-param name="ContactDepartmentID" select="IdReference[@domain='ContactDepartmentID']/@identifier"/>
							<xsl:with-param name="ContactPerson" select="IdReference[@domain='ContactPerson']/@identifier"/>
							<xsl:with-param name="isRemittence" select="'true'"/>
						</xsl:call-template>
					</G_SG1>
				</xsl:for-each>
				<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@currency)!=''">
					<G_SG3>
						<S_CUX>
							<C_C504>
								<D_6347>2</D_6347>
								<D_6345>
									<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@currency), 1, 3)"/>
								</D_6345>
								<D_6343>11</D_6343>
							</C_C504>
						</S_CUX>
					</G_SG3>
				</xsl:if>
				<!-- Remittance Detail -->
				<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/RemittanceDetail">
					<xsl:variable name="rffCount" select="'1'"/>
					<G_SG4>
						<S_DOC>
							<C_C002>
								<D_1001>481</D_1001>
								<D_1131>150</D_1131>
								<D_3055>92</D_3055>
								<D_1000>Payment Remittance</D_1000>
							</C_C002>
						</S_DOC>
						<xsl:if test="GrossAmount/Money!=''">
							<S_MOA>
								<C_C516>
									<D_5025>77</D_5025>
									<D_5004>
										<xsl:value-of select="GrossAmount/Money"/>
									</D_5004>
									<D_6345>
										<xsl:value-of select="substring(normalize-space(GrossAmount/Money/@currency), 1, 3)"></xsl:value-of>
									</D_6345>
								</C_C516>
							</S_MOA>
						</xsl:if>
						<xsl:if test="AdjustmentAmount/Money!=''">
							<S_MOA>
								<C_C516>
									<D_5025>165</D_5025>
									<D_5004>
										<xsl:value-of select="AdjustmentAmount/Money"/>
									</D_5004>
									<D_6345>
										<xsl:value-of select="substring(normalize-space(AdjustmentAmount/Money/@currency), 1, 3)"></xsl:value-of>
									</D_6345>
								</C_C516>
							</S_MOA>
						</xsl:if>
						<xsl:if test="NetAmount/Money!=''">
							<S_MOA>
								<C_C516>
									<D_5025>11</D_5025>
									<D_5004>
										<xsl:value-of select="NetAmount/Money"/>
									</D_5004>
									<D_6345>
										<xsl:value-of select="substring(normalize-space(NetAmount/Money/@currency), 1, 3)"></xsl:value-of>
									</D_6345>
								</C_C516>
							</S_MOA>
						</xsl:if>
						<xsl:if test="DiscountAmount/Money!=''">
							<S_MOA>
								<C_C516>
									<D_5025>52</D_5025>
									<D_5004>
										<xsl:value-of select="DiscountAmount/Money"/>
									</D_5004>
									<D_6345>
										<xsl:value-of select="substring(normalize-space(DiscountAmount/Money/@currency), 1, 3)"></xsl:value-of>
									</D_6345>
								</C_C516>
							</S_MOA>
						</xsl:if>
						<xsl:if test="normalize-space(Extrinsic[@name='TaxAmount'])!=''">
							<S_MOA>
								<C_C516>
									<D_5025>52</D_5025>
									<D_5004>
										<xsl:value-of select="normalize-space(Extrinsic[@name='TaxAmount'])"/>
									</D_5004>
								</C_C516>
							</S_MOA>
						</xsl:if>

						<xsl:if test="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate!=''">
							<S_DTM>
								<C_C507>
									<D_2005>3</D_2005>
									<D_2380>
										<xsl:value-of select="replace(substring(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate,0,11),'-','')"/>
									</D_2380>
									<D_2379>102</D_2379>
								</C_C507>
							</S_DTM>
						</xsl:if>

						<!-- Order Date -->
						<xsl:if test="PayableInfo/PayableOrderInfo/OrderIDInfo/@orderDate!=''">
							<S_DTM>
								<C_C507>
									<D_2005>4</D_2005>
									<D_2380>
										<xsl:value-of select="replace(substring(PayableInfo/PayableOrderInfo/OrderIDInfo/@orderDate,0,11),'-','')"/>
									</D_2380>
									<D_2379>102</D_2379>
								</C_C507>
							</S_DTM>
						</xsl:if>

						<!-- Aggrement Date -->
						<xsl:if test="PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate!=''">
							<S_DTM>
								<C_C507>
									<D_2005>315</D_2005>
									<D_2380>
										<xsl:value-of select="replace(substring(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate,0,11),'-','')"/>
									</D_2380>
									<D_2379>102</D_2379>
								</C_C507>
							</S_DTM>
						</xsl:if>

						<xsl:if test="PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID !=''">
							<S_RFF>
								<C_C506>
									<D_1153>CT</D_1153>
									<D_1154>
										<xsl:value-of select="PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID"/>
									</D_1154>
									<D_1156>
										<xsl:value-of select="./@lineNumber"/>
									</D_1156>
								</C_C506>
							</S_RFF>
						</xsl:if>
						<xsl:if test="PayableInfo/PayableOrderInfo/OrderIDInfo/@orderID!=''">
							<S_RFF>
								<C_C506>
									<D_1153>CO</D_1153>
									<D_1154>
										<xsl:value-of select="PayableInfo/PayableOrderInfo/OrderIDInfo/@orderID"/>
									</D_1154>
								</C_C506>
							</S_RFF>
						</xsl:if>
						<xsl:if test="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID!=''">
							<S_RFF>
								<C_C506>
									<D_1153>IV</D_1153>
									<D_1154>
										<xsl:value-of select="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID"/>
									</D_1154>
								</C_C506>
							</S_RFF>
						</xsl:if>
						<xsl:variable name="extrList">
							<xsl:for-each select="Extrinsic[@name!='TaxAmount' and @name!='AdjustmentReasonCode' and @name!='MutuallyDefinedReferenceID' and @name!='AdjustmentText_TextTypeCode']">
								<xsl:variable name="extName" select="./@name"/>
								<xsl:if test="$Lookup/Lookups/Extrinsics/Extrinsic[CXMLCode=$extName]/EDIFACTCode!=''">
									<ExtItem>
										<Name>
											<xsl:value-of select="$Lookup/Lookups/Extrinsics/Extrinsic[CXMLCode=$extName]/EDIFACTCode"/>
										</Name>
										<Value>
											<xsl:value-of select="normalize-space(.)"/>
										</Value>
									</ExtItem>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:for-each select="$extrList/ExtItem[2 &gt;= position()]">
							<S_RFF>
								<C_C506>
									<D_1153>
										<xsl:value-of select="Name"/>
									</D_1153>
									<D_1154>
										<xsl:value-of select="Value"/>
									</D_1154>
								</C_C506>
							</S_RFF>
						</xsl:for-each>
						<xsl:variable name="adjustmentCode" select="$Lookup/Lookups/AdjustmentCodes/AdjustmentCode[CXMLCode=normalize-space(Extrinsic[@name='AdjustmentReasonCode'])]/EDIFACTCode"/>
						<xsl:if test="$adjustmentCode!=''">
							<G_SG6>
								<S_AJT>
									<C_C516>
										<D_4465>
											<xsl:value-of select="$adjustmentCode"/>
										</D_4465>
										<D_1082>
											<xsl:value-of select="./@lineNumber"/>
										</D_1082>
									</C_C516>
								</S_AJT>
							</G_SG6>
						</xsl:if>
					</G_SG4>
				</xsl:for-each>
				<!--- Summary -->
				<S_UNS>
					<D_0081>S</D_0081>
				</S_UNS>
				<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money!=''">
					<S_MOA>
						<C_C516>
							<D_5025>9</D_5025>
							<D_5004>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money"/>
							</D_5004>
							<D_6345>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/GrossAmount/Money/@currency"></xsl:value-of>
							</D_6345>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money!=''">
					<S_MOA>
						<C_C516>
							<D_5025>165</D_5025>
							<D_5004>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money"/>
							</D_5004>
							<D_6345>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/AdjustmentAmount/Money/@currency"></xsl:value-of>
							</D_6345>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money!=''">
					<S_MOA>
						<C_C516>
							<D_5025>12</D_5025>
							<D_5004>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money"/>
							</D_5004>
							<D_6345>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@currency"></xsl:value-of>
							</D_6345>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money!=''">
					<S_MOA>
						<C_C516>
							<D_5025>52</D_5025>
							<D_5004>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money"/>
							</D_5004>
							<D_6345>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/DiscountAmount/Money/@currency"></xsl:value-of>
							</D_6345>
						</C_C516>
					</S_MOA>
				</xsl:if>
				<S_UNT>
					<D_0074>#segCount#</D_0074>
					<D_0062>0001</D_0062>
				</S_UNT>
			</xsl:element>
			<!--/M_REMADV-->
			<S_UNZ>
				<D_0036>1</D_0036>
				<D_0020>
					<xsl:value-of select="$anICNValue"/>
				</D_0020>
			</S_UNZ>
		</ns0:Interchange>
	</xsl:template>


</xsl:stylesheet>
