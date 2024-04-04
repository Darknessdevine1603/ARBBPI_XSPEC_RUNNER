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

	<!-- For local testing -->
	<!--xsl:variable name="lookups" select="document('cXML_EDILookups_D96A.xml')"/>
	<xsl:include href="Format_D96A_CXML_common.xsl"/-->
	<!-- for dynamic, reading from Partner Directory -->
	<xsl:include href="FORMAT_UN-EDIFACT_D96A_cXML_0000.xsl"/>
	<xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>

	<xsl:template match="ns0:*">
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:call-template name="convertToAribaDate">
					<xsl:with-param name="dateTime">
						<xsl:value-of select="replace(replace(string(current-dateTime()),'-',''),':','')"/>
					</xsl:with-param>
					<xsl:with-param name="dateTimeFormat">
						<xsl:value-of select="304"/>
					</xsl:with-param>
				</xsl:call-template>
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
			<Request>
				<xsl:choose>
					<xsl:when test="$anEnvName='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<TransportConfirmation>
					<TransportConfirmationHeader>
						<xsl:if test="normalize-space(M_IFTSTA/S_BGM/D_1004)!=''">
							<xsl:attribute name="confirmationID">
								<xsl:value-of select="normalize-space(M_IFTSTA/S_BGM/D_1004)"/>
							</xsl:attribute>
						</xsl:if>

						<xsl:if test="normalize-space(M_IFTSTA/S_BGM/D_1225)!=''">
							<xsl:attribute name="operation">
								<xsl:choose>
									<xsl:when test="normalize-space(M_IFTSTA/S_BGM/D_1225) = '3'">delete</xsl:when>
									<xsl:when test="normalize-space(M_IFTSTA/S_BGM/D_1225) = '9'">new</xsl:when>
									<xsl:when test="normalize-space(M_IFTSTA/S_BGM/D_1225) = '5'">update</xsl:when>
								</xsl:choose>
							</xsl:attribute>
						</xsl:if>

						<xsl:if test="normalize-space(M_IFTSTA/S_DTM/C_C507[D_2005 = '137']/D_2380)!=''">
							<xsl:attribute name="confirmationDate">
								<xsl:choose>
									<xsl:when test="normalize-space(M_IFTSTA/S_DTM/C_C507/D_2005) = '137'">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime">
												<xsl:value-of select="M_IFTSTA/S_DTM/C_C507[D_2005 = '137']/D_2380"/>
											</xsl:with-param>
											<xsl:with-param name="dateTimeFormat">
												<xsl:value-of select="M_IFTSTA/S_DTM/C_C507[D_2005 = '137']/D_2379"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
						</xsl:if>
						<TransportPartner>
							<xsl:attribute name="role">carrier</xsl:attribute>
							<xsl:for-each select="M_IFTSTA/G_SG1">
								<xsl:call-template name="Map_G_SG1">
									<xsl:with-param name="g_SG1" select="."/>
									<!--<xsl:with-param name="role" select="S_NAD/D_3035"/>-->
									<xsl:with-param name="cMode" select="'partner'"/>
								</xsl:call-template>
							</xsl:for-each>
						</TransportPartner>
					</TransportConfirmationHeader>
					<TransportReference>
						<xsl:if test="normalize-space(M_IFTSTA/G_SG3/S_RFF/C_C506/D_1153)='AGI'">
							<xsl:attribute name="requestID">
								<xsl:value-of select="M_IFTSTA/G_SG3/S_RFF/C_C506/D_1154"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="normalize-space(M_IFTSTA/G_SG3/S_DTM/C_C507/D_2005) = '318' or normalize-space(M_IFTSTA/G_SG3/S_DTM/C_C507/D_2005) = '171'">
							<xsl:attribute name="requestDate">
								<xsl:choose>
									<xsl:when test="normalize-space(M_IFTSTA/G_SG3/S_DTM/C_C507/D_2380)!=''">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="dateTime">
												<xsl:value-of select="M_IFTSTA/S_DTM/C_C507/D_2380"/>
											</xsl:with-param>
											<xsl:with-param name="dateTimeFormat">
												<xsl:value-of select="M_IFTSTA/S_DTM/C_C507/D_2379"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</xsl:attribute>
						</xsl:if>
						<DocumentReference>
							<xsl:attribute name="payloadID"/>
						</DocumentReference>
					</TransportReference>
					<xsl:for-each select="M_IFTSTA/G_SG4">
						<xsl:variable name="conID">
							<xsl:value-of select="S_CNI/C_C503/D_1004"/>
						</xsl:variable>

						<xsl:variable name="numPac">
							<xsl:if test="normalize-space(C_C270/D_6069) ='11'">
								<xsl:value-of select="C_C270/D_6066"/>
							</xsl:if>
						</xsl:variable>
						<xsl:for-each select="G_SG5">
							<ConsignmentConfirmation>
								<xsl:attribute name="consignmentID">
									<xsl:value-of select="$conID"/>
								</xsl:attribute>
								<xsl:variable name="Status">
									<xsl:value-of select="normalize-space(S_STS/C_C555/D_9011)"/>
								</xsl:variable>
								<xsl:variable name="consStatus">
									<xsl:choose>
										<xsl:when test="$Status = '7'">cancelled</xsl:when>
										<xsl:when test="$Status = '13'">collected</xsl:when>
										<xsl:when test="$Status = '69'">rejected</xsl:when>
										<xsl:when test="$Status = '72'">accepted</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:attribute name="consignmentStatus">
									<xsl:value-of select="$consStatus"/>
								</xsl:attribute>
								<xsl:if test="normalize-space(C_C556/D_9013) = '3'">
									<xsl:attribute name="rejectionReason">
										<xsl:value-of select="C_C556/D_9012"/>
									</xsl:attribute>
								</xsl:if>
								<ConsignmentConfirmationHeader>
									<xsl:if test="$numPac!=''">
										<xsl:attribute name="numberOfPackages">
											<xsl:value-of select="$numPac"/>
										</xsl:attribute>
									</xsl:if>
									<Hazard>
										<Description>
											<xsl:attribute name="xml:lang">
												<xsl:value-of select="(S_FTX[D_4451 = 'HAZ']/D_3453)[1]"/>
											</xsl:attribute>
											<xsl:for-each select="S_FTX[D_4451 = 'HAZ']">
												<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
											</xsl:for-each>
										</Description>
										<xsl:if test="normalize-space(S_FTX[D_4451 = 'AAC'])">
											<Classification>
												<xsl:attribute name="domain">
													<xsl:value-of select="S_FTX[D_4451 = 'AAC']/C_C108/D_4440"/>
												</xsl:attribute>
												<xsl:for-each select="S_FTX[D_4451 = 'AAC']">
													<xsl:value-of select="concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
												</xsl:for-each>
											</Classification>
										</xsl:if>
									</Hazard>
									<xsl:for-each select="../S_CNT">
										<xsl:if test="normalize-space(C_C270/D_6069)='7' or normalize-space(C_C270/D_6069)='15'">
											<Dimension>
												<xsl:choose>
													<xsl:when test="C_C270/D_6069='7'">
														<xsl:attribute name="quantity">
															<xsl:value-of select="C_C270/D_6066"/>
														</xsl:attribute>
														<xsl:attribute name="type">grossWeight</xsl:attribute>
														<UnitOfMeasure>
															<xsl:value-of select="C_C270/D_6411"/>
														</UnitOfMeasure>
													</xsl:when>
													<xsl:when test="C_C270/D_6069='15'">
														<xsl:attribute name="quantity">
															<xsl:value-of select="C_C270/D_6066"/>
														</xsl:attribute>
														<xsl:attribute name="type">volume</xsl:attribute>
														<UnitOfMeasure>
															<xsl:value-of select="C_C270/D_6411"/>
														</UnitOfMeasure>
													</xsl:when>
												</xsl:choose>
											</Dimension>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="S_RFF">
										<xsl:if test="normalize-space(C_C506/D_1153)!='CN'">
											<ReferenceDocumentInfo>
												<DocumentInfo>

													<xsl:attribute name="documentID">
														<xsl:value-of select="C_C506/D_1154"/>
													</xsl:attribute>
													<xsl:attribute name="documentType">
														<xsl:choose>
															<xsl:when test="normalize-space(C_C506/D_1153) = 'AAO'">consigneeReference</xsl:when>
															<xsl:when test="normalize-space(C_C506/D_1153) = 'BM'">billOfLading</xsl:when>
															<xsl:when test="normalize-space(C_C506/D_1153) = 'CT'">agreement</xsl:when>
															<xsl:when test="normalize-space(C_C506/D_1153) = 'MA'">shipNotice</xsl:when>
															<xsl:when test="normalize-space(C_C506/D_1153) = 'ON'">order</xsl:when>
														</xsl:choose>
													</xsl:attribute>
												</DocumentInfo>
											</ReferenceDocumentInfo>
										</xsl:if>
									</xsl:for-each>
									<ShipmentIdentifier>
										<xsl:for-each select="S_RFF">
											<xsl:if test="normalize-space(C_C506/D_1153)='CN'">
												<xsl:choose>
													<xsl:when test="normalize-space(C_C506/D_4000)='TrackingURL'">
														<xsl:attribute name="trackingURL">
															<xsl:value-of select="C_C506/D_1154"/>
														</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="domain">
															<xsl:value-of select="C_C506/D_4000"/>
														</xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:for-each>
										<xsl:if test="normalize-space(S_DTM/C_C507/D_2005)='85'">
											<xsl:attribute name="trackingNumberDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="dateTime">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '85']/D_2380"/>
													</xsl:with-param>
													<xsl:with-param name="dateTimeFormat">
														<xsl:value-of select="S_DTM/C_C507[D_2005 = '85']/D_2379"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:if>
									</ShipmentIdentifier>
									<OriginConfirmation>
										<xsl:for-each select="G_SG6">
											<xsl:if test="normalize-space(S_TDT/D_8051)='12'">
												<xsl:for-each select="S_DTM">
													<xsl:choose>
														<xsl:when test="C_C507/D_2005='133'">
															<DateInfo>
																<xsl:attribute name="type">expectedShipmentDate</xsl:attribute>
																<xsl:attribute name="date">
																	<xsl:call-template name="convertToAribaDate">
																		<xsl:with-param name="dateTime">
																			<xsl:value-of select="C_C507[D_2005 = '133']/D_2380"/>
																		</xsl:with-param>
																		<xsl:with-param name="dateTimeFormat">
																			<xsl:value-of select="C_C507[D_2005 = '133']/D_2379"/>
																		</xsl:with-param>
																	</xsl:call-template>
																</xsl:attribute>
															</DateInfo>
														</xsl:when>
														<xsl:when test="C_C507/D_2005='200'">
															<xsl:variable name="dateType">
																<xsl:choose>
																	<xsl:when test="$consStatus='accepted'">
																		<xsl:text>expectedPickUpDate</xsl:text>
																	</xsl:when>
																	<xsl:when test="$consStatus='collected'">
																		<xsl:text>actualPickUpDate</xsl:text>
																	</xsl:when>
																</xsl:choose>
															</xsl:variable>
															<xsl:if test="$dateType!=''">
																<DateInfo>
																	<xsl:attribute name="type">
																		<xsl:value-of select="$dateType"/>
																	</xsl:attribute>
																	<xsl:attribute name="date">
																		<xsl:call-template name="convertToAribaDate">
																			<xsl:with-param name="dateTime">
																				<xsl:value-of select="C_C507[D_2005 = '200']/D_2380"/>
																			</xsl:with-param>
																			<xsl:with-param name="dateTimeFormat">
																				<xsl:value-of select="C_C507[D_2005 = '200']/D_2379"/>
																			</xsl:with-param>
																		</xsl:call-template>
																	</xsl:attribute>
																</DateInfo>
															</xsl:if>
														</xsl:when>
													</xsl:choose>
												</xsl:for-each>
											</xsl:if>
										</xsl:for-each>
									</OriginConfirmation>
									<DestinationConfirmation>
										<xsl:for-each select="G_SG6">
											<xsl:if test="normalize-space(S_TDT/D_8051)='13'">
												<xsl:for-each select="S_DTM">

													<xsl:if test="C_C507/D_2005='17'">
														<DateInfo>
															<xsl:attribute name="type">expectedDeliveryDate</xsl:attribute>
															<xsl:attribute name="date">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="C_C507[D_2005 = '17']/D_2380"/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="C_C507[D_2005 = '17']/D_2379"/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</DateInfo>
													</xsl:if>


													<xsl:if test="C_C507/D_2005='2'">
														<DateInfo>
															<xsl:attribute name="type">requestedDeliveryDate</xsl:attribute>
															<xsl:attribute name="date">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="C_C507[D_2005 = '2']/D_2380"/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="C_C507[D_2005 = '2']/D_2379"/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</DateInfo>
													</xsl:if>

													<xsl:if test="C_C507/D_2005='35'">
														<DateInfo>
															<xsl:attribute name="type">actualDeliveryDate</xsl:attribute>
															<xsl:attribute name="date">
																<xsl:call-template name="convertToAribaDate">
																	<xsl:with-param name="dateTime">
																		<xsl:value-of select="C_C507[D_2005 = '35']/D_2380"/>
																	</xsl:with-param>
																	<xsl:with-param name="dateTimeFormat">
																		<xsl:value-of select="C_C507[D_2005 = '35']/D_2379"/>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:attribute>
														</DateInfo>
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
										</xsl:for-each>
									</DestinationConfirmation>
									<Comments>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="S_FTX[D_4451 = 'ACD'][1]/D_3453"/>
										</xsl:attribute>
										<xsl:for-each select="S_FTX[D_4451 = 'ACD']">
											<xsl:value-of select="concat(C_C108/D_4440, C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
										</xsl:for-each>
									</Comments>
									<xsl:if test="S_FTX[D_4451 = 'ZZZ']">
										<Extrinsic>
											<xsl:attribute name="name">
												<xsl:value-of select="S_FTX[D_4451 = 'ZZZ']/C_C108/D_4440"/>
											</xsl:attribute>
											<xsl:for-each select="S_FTX[D_4451 = 'ZZZ']">
												<xsl:value-of select="concat(C_C108/D_4440_2, C_C108/D_4440_3, C_C108/D_4440_4, C_C108/D_4440_5)"/>
											</xsl:for-each>
										</Extrinsic>
									</xsl:if>
								</ConsignmentConfirmationHeader>
								<xsl:for-each select="G_SG7">
									<TransportEquipment>
										<xsl:attribute name="equipmentID">
											<xsl:value-of select="S_EQD/C_C237/D_8260"/>
										</xsl:attribute>
										<xsl:if test="normalize-space(S_EQD/D_8053)!=''">
											<xsl:attribute name="type">
												<xsl:choose>
													<xsl:when test="normalize-space(S_EQD/D_8053) = 'CN'">tankContainer30ft</xsl:when>
													<xsl:when test="normalize-space(S_EQD/D_8053) = 'EFP'">exchangeablePallet</xsl:when>
													<xsl:when test="normalize-space(S_EQD/D_8053) = 'PA'">missing</xsl:when>
													<xsl:when test="normalize-space(S_EQD/D_8053) = 'RG'">temperatureControllerContainer30ft</xsl:when>
													<xsl:when test="normalize-space(S_EQD/D_8053) = 'TE'">trailer</xsl:when>
												</xsl:choose>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="normalize-space(S_EQD/D_8077)!=''">
											<xsl:choose>
												<xsl:when test="normalize-space(S_EQD/D_8077)='1'">
													<xsl:attribute name="providedBy">
														<xsl:value-of select="'sender'"/>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="normalize-space(S_EQD/D_8077)='2'">
													<xsl:attribute name="providedBy">
														<xsl:value-of select="'carrier'"/>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
										</xsl:if>
										<xsl:if test="normalize-space(S_EQD/D_8169)!=''">
											<xsl:choose>
												<xsl:when test="normalize-space(S_EQD/D_8169)='4'">
													<xsl:attribute name="status">
														<xsl:value-of select="'empty'"/>
													</xsl:attribute>
												</xsl:when>
												<xsl:when test="normalize-space(S_EQD/D_8169)='5'">
													<xsl:attribute name="status">
														<xsl:value-of select="'full'"/>
													</xsl:attribute>
												</xsl:when>
											</xsl:choose>
										</xsl:if>
									</TransportEquipment>
								</xsl:for-each>
							</ConsignmentConfirmation>
						</xsl:for-each>
					</xsl:for-each>
				</TransportConfirmation>
			</Request>
		</cXML>
	</xsl:template>

	<xsl:template name="Map_G_SG1">
		<xsl:param name="g_SG1"/>
		<xsl:param name="role"/>
		<xsl:param name="cMode"/>
		<xsl:param name="buildAddressElement"/>

		<xsl:variable name="rootContact">
			<xsl:choose>
				<xsl:when test="$buildAddressElement='true'">
					<xsl:text>Address</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Contact</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$rootContact}">

			<xsl:if test="$g_SG1/S_NAD/C_C082/D_3039">
				<xsl:variable name="addrDomain">
					<xsl:value-of select="normalize-space($g_SG1/S_NAD/C_C082/D_3055)"/>
				</xsl:variable>
				<xsl:if test="$lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]">
					<xsl:attribute name="addressID">
						<xsl:value-of select="$g_SG1/S_NAD/C_C082/D_3039"/>
					</xsl:attribute>
					<xsl:attribute name="addressIDDomain">
						<xsl:value-of select="normalize-space($lookups/Lookups/AddrDomains/AddrDomain[EDIFACTCode = $addrDomain]/CXMLCode)"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<xsl:element name="Name">
				<xsl:attribute name="xml:lang">en</xsl:attribute>
				<xsl:value-of select="concat($g_SG1/S_NAD/C_C058/D_3124, $g_SG1/S_NAD/C_C058/D_3124_2, $g_SG1/S_NAD/C_C058/D_3124_3, $g_SG1/S_NAD/C_C058/D_3124_4, $g_SG1/S_NAD/C_C058/D_3124_5)"/>
			</xsl:element>
			<!-- PostalAddress -->
			<xsl:if test="$g_SG1/S_NAD/D_3164!=''">
				<xsl:element name="PostalAddress">
					<!-- <xsl:attribute name="name"/> -->
					<xsl:if test="$g_SG1/S_NAD/C_C080/D_3036!= ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="$g_SG1/S_NAD/C_C080/D_3036"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C080/D_3036_2 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="$g_SG1/S_NAD/C_C080/D_3036_2"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C080/D_3036_3 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="$g_SG1/S_NAD/C_C080/D_3036_3"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C080/D_3036_4 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="$g_SG1/S_NAD/C_C080/D_3036_4"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C080/D_3036_5 != ''">
						<xsl:element name="DeliverTo">
							<xsl:value-of select="$g_SG1/S_NAD/C_C080/D_3036_5"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C059/D_3042!= ''">
						<xsl:element name="Street">
							<xsl:value-of select="$g_SG1/S_NAD/C_C059/D_3042"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C059/D_3042_2 != ''">
						<xsl:element name="Street">
							<xsl:value-of select="$g_SG1/S_NAD/C_C059/D_3042_2"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C059/D_3042_3 != ''">
						<xsl:element name="Street">
							<xsl:value-of select="$g_SG1/S_NAD/C_C059/D_3042_3"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/C_C059/D_3042_4 != ''">
						<xsl:element name="Street">
							<xsl:value-of select="$g_SG1/S_NAD/C_C059/D_3042_4"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/D_3164 != ''"/>
					<xsl:element name="City">
						<xsl:value-of select="$g_SG1/S_NAD/D_3164"/>
					</xsl:element>
					<xsl:variable name="stateCode">
						<xsl:value-of select="$g_SG1/S_NAD/D_3229"/>
					</xsl:variable>
					<xsl:if test="$stateCode!=''">
						<xsl:element name="State">
							<xsl:attribute name="isoStateCode">
								<xsl:value-of select="$stateCode"/>
							</xsl:attribute>
							<xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCode]/stateName"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$g_SG1/S_NAD/D_3251!=''">
						<xsl:element name="PostalCode">
							<xsl:value-of select="$g_SG1/S_NAD/D_3251"/>
						</xsl:element>
					</xsl:if>
					<xsl:variable name="isoCountryCode">
						<xsl:value-of select="$g_SG1/S_NAD/D_3207"/>
					</xsl:variable>
					<xsl:element name="Country">
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$isoCountryCode"/>
						</xsl:attribute>
						<xsl:value-of select="$lookups/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="$g_SG1//S_COM[C_C076/D_3155='EM']">
				<xsl:call-template name="CommunicationInfo">
					<xsl:with-param name="role" select="$role"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="$g_SG1//S_COM[C_C076/D_3155='TE']">
				<xsl:call-template name="CommunicationInfo">
					<xsl:with-param name="role" select="$role"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="$g_SG1//S_COM[C_C076/D_3155='FX']">
				<xsl:call-template name="CommunicationInfo">
					<xsl:with-param name="role" select="$role"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="$g_SG1//S_COM[C_C076/D_3155='AH']">
				<xsl:call-template name="CommunicationInfo">
					<xsl:with-param name="role" select="$role"/>
				</xsl:call-template>
			</xsl:for-each>


			<xsl:if test="$cMode='partner'">
				<xsl:for-each select="$g_SG1/G_SG3">
					<xsl:choose>
						<xsl:when test="S_RFF/C_C506[D_1153 = 'AGU']/D_1154!=''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">memberNumber</xsl:attribute>
								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'AGU']/D_1154"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="S_RFF/C_C506[D_1153 = 'AIH']/D_1154!=''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">transactionReference</xsl:attribute>
								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'AIH']/D_1154"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="S_RFF/C_C506[D_1153 = 'FC']/D_1154!=''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">fiscalNumber</xsl:attribute>
								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'FC']/D_1154"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="S_RFF/C_C506[D_1153 = 'IA']/D_1154!=''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">vendorNumber</xsl:attribute>
								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'IA']/D_1154"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="S_RFF/C_C506[D_1153 = 'IT']/D_1154!=''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">companyCode</xsl:attribute>
								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'IT']/D_1154"/>
							</xsl:element>
						</xsl:when>
						<xsl:when test="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154!=''">
							<xsl:element name="Extrinsic">
								<xsl:attribute name="name">
									<xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_1154"/>
								</xsl:attribute>
								<xsl:value-of select="S_RFF/C_C506[D_1153 = 'ZZZ']/D_4000"/>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
		</xsl:element>
		<xsl:if test="$cMode='partner'">
			<xsl:for-each select="$g_SG1/G_SG3[S_RFF/C_C506/D_1153 != 'ZZZ']">
				<xsl:choose>
					<xsl:when test="$role = 'RE' and S_RFF/C_C506[D_1153 = 'AHP']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">supplierTaxID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AHP']/D_1154"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$role = 'RE' and S_RFF/C_C506[D_1153 = 'PY']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">accountID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'PY']/D_1154"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$role = 'RE' and S_RFF/C_C506[D_1153 = 'RT']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">bankRoutingID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'RT']/D_1154"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="S_RFF/C_C506[D_1153 = 'VA']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">vatID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'VA']/D_1154"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="S_RFF/C_C506[D_1153 = 'TL']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">taxExemptionID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'TL']/D_1154"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="S_RFF/C_C506[D_1153 = 'AMT']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">gstID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AMT']/D_1154"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="S_RFF/C_C506[D_1153 = 'AP']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">accountReceivableID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AP']/D_1154"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="S_RFF/C_C506[D_1153 = 'AV']/D_1154!=''">
						<xsl:element name="IdReference">
							<xsl:attribute name="domain">accountPayableID</xsl:attribute>
							<xsl:attribute name="identifier" select="S_RFF/C_C506[D_1153 = 'AV']/D_1154"/>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
