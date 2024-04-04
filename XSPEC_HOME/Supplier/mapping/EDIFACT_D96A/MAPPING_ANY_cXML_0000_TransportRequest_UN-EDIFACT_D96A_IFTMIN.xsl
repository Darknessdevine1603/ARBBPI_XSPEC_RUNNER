<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output indent="yes" omit-xml-declaration="yes"/>

	<!-- For local testing -->
	<!-- xsl:variable name="Lookup" select="document('cXML_EDILookups_D96A.xml')"/>
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

	<xsl:template match="cXML/Request/TransportRequest">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:iftmin:d.96a">
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
				<D_0026>IFTMIN</D_0026>
				<xsl:if test="upper-case($anEnvName) = 'TEST'">
					<D_0035>1</D_0035>
				</xsl:if>
			</S_UNB>
			<xsl:element name="M_IFTMIN">
				<S_UNH>
					<D_0062>0001</D_0062>
					<C_S009>
						<D_0065>IFTMIN</D_0065>
						<D_0052>D</D_0052>
						<D_0054>96A</D_0054>
						<D_0051>UN</D_0051>
					</C_S009>
				</S_UNH>
				<S_BGM>
					<C_C002>
						<D_1001>610</D_1001>
					</C_C002>
					<D_1004>
						<xsl:value-of select="TransportRequestHeader/@requestID"/>
					</D_1004>
					<D_1225>
						<xsl:choose>
							<xsl:when test="TransportRequestHeader/@operation = 'delete'">
								<xsl:text>3</xsl:text>
							</xsl:when>
							<xsl:when test="TransportRequestHeader/@operation = 'update'">
								<xsl:text>5</xsl:text>
							</xsl:when>
							<xsl:when test="TransportRequestHeader/@operation = 'new'">
								<xsl:text>9</xsl:text>
							</xsl:when>
						</xsl:choose>
					</D_1225>
					<D_4343>AB</D_4343>
				</S_BGM>
				<xsl:if test="TransportRequestHeader/@requestDate != ''">
					<S_DTM>
						<C_C507>
							<D_2005>318</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="normalize-space(TransportRequestHeader/@requestDate)"/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>

				<xsl:for-each select="Consignment">
					<xsl:if test="normalize-space(ConsignmentHeader/TransportCondition/Priority/@level) != ''">
						<S_TSR>
							<C_C537>
								<D_4219>
									<xsl:value-of select="ConsignmentHeader/TransportCondition/Priority/@level"/>
								</D_4219>
							</C_C537>
						</S_TSR>
					</xsl:if>
					<xsl:if test="normalize-space(ConsignmentHeader/NetAmount) != ''">
						<xsl:call-template name="createMOA">
							<xsl:with-param name="qual" select="'38'"/>
							<xsl:with-param name="money" select="ConsignmentHeader/NetAmount"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>

				<xsl:if test="normalize-space(TransportSummary/FreightChargesAmount) != ''">
					<xsl:call-template name="createMOA">
						<xsl:with-param name="qual" select="'64'"/>
						<xsl:with-param name="money" select="TransportSummary/FreightChargesAmount"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="normalize-space(TransportSummary/SubtotalAmount) != ''">
					<xsl:call-template name="createMOA">
						<xsl:with-param name="qual" select="'289'"/>
						<xsl:with-param name="money" select="TransportSummary/SubtotalAmount"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="normalize-space(TransportSummary/InsuranceValue) != ''">
					<xsl:call-template name="createMOA">
						<xsl:with-param name="qual" select="'64'"/>
						<xsl:with-param name="money" select="TransportSummary/InsuranceValue"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="Consignment">

					<xsl:for-each select="ConsignmentHeader/TransportRequirements/Hazard/Description">
						<xsl:call-template name="FTXLoop">
							<xsl:with-param name="FTXData" select="normalize-space(.)"/>
							<xsl:with-param name="FTXQual" select="'HAZ'"/>
							<xsl:with-param name="langCode" select="@xml:lang"/>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:for-each select="ConsignmentHeader/TransportRequirements/Hazard/Classification">
						<xsl:call-template name="FTXLoop">
							<xsl:with-param name="domain" select="@domain"/>
							<xsl:with-param name="FTXQual" select="'AAC'"/>
							<xsl:with-param name="FTXData" select="normalize-space(.)"/>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:for-each select="ConsignmentHeader/Extrinsic">
						<xsl:call-template name="FTXExtrinsic">
							<xsl:with-param name="FTXName" select="@name"/>
							<xsl:with-param name="FTXData" select="normalize-space(.)"/>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:for-each select="ConsignmentHeader/Comments">
						<xsl:call-template name="FTXLoop">
							<xsl:with-param name="FTXData" select="normalize-space(.)"/>
							<xsl:with-param name="FTXQual" select="'AAI'"/>
							<xsl:with-param name="langCode" select="@xml:lang"/>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:if test="normalize-space(ConsignmentHeader/@numberOfPackages) != ''">
						<S_CNT>
							<C_C270>
								<D_6069>11</D_6069>
								<D_6066>
									<xsl:value-of select="ConsignmentHeader/@numberOfPackages"/>
								</D_6066>
							</C_C270>
						</S_CNT>
					</xsl:if>

					<xsl:for-each select="ConsignmentHeader/Dimension[@type = 'grossWeight']">
						<S_CNT>
							<C_C270>
								<D_6069>7</D_6069>
								<D_6066>
									<xsl:call-template name="formatDecimal">
										<xsl:with-param name="amount" select="normalize-space(@quantity)"/>
									</xsl:call-template>
								</D_6066>
								<D_6411>
									<xsl:value-of select="UnitOfMeasure"/>
								</D_6411>
							</C_C270>
						</S_CNT>
					</xsl:for-each>

					<xsl:for-each select="ConsignmentHeader/Dimension[@type = 'volume']">
						<S_CNT>
							<C_C270>
								<D_6069>7</D_6069>
								<D_6066>
									<xsl:call-template name="formatDecimal">
										<xsl:with-param name="amount" select="normalize-space(@quantity)"/>
									</xsl:call-template>
								</D_6066>
								<D_6411>
									<xsl:value-of select="UnitOfMeasure"/>
								</D_6411>
							</C_C270>
						</S_CNT>
					</xsl:for-each>
				</xsl:for-each>

				<xsl:for-each select="Consignment">
					<G_SG1>
						<S_LOC>
							<D_3227>5</D_3227>
							<C_C517>
								<xsl:if test="ConsignmentHeader/Origin/Address/@addressID != ''">
									<D_3225>
										<xsl:value-of select="ConsignmentHeader/Origin/Address/@addressID"/>
									</D_3225>
								</xsl:if>
								<xsl:variable name="addrDomain" select="normalize-space(ConsignmentHeader/Origin/Address/@addressIDDomain)"/>
								<xsl:if test="$addrDomain != ''">
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/EDIFACTCode != ''">
											<D_3055>
												<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/EDIFACTCode"/>
											</D_3055>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
								<D_3224>
									<xsl:value-of select="ConsignmentHeader/Origin/Address/Name"/>
								</D_3224>
							</C_C517>
						</S_LOC>
						<xsl:for-each select="ConsignmentHeader/Origin/DateInfo">

							<xsl:if test="normalize-space(@type) = 'expectedShipmentDate'">
								<S_DTM>
									<C_C507>
										<D_2005>133</D_2005>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="@date"/>
										</xsl:call-template>
									</C_C507>
								</S_DTM>
							</xsl:if>
							<xsl:if test="@type = 'requestedPickUpDate'">
								<S_DTM>
									<C_C507>
										<D_2005>200</D_2005>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="@date"/>
										</xsl:call-template>
									</C_C507>
								</S_DTM>
							</xsl:if>
						</xsl:for-each>
					</G_SG1>

					<G_SG1>
						<S_LOC>
							<D_3227>8</D_3227>
							<C_C517>
								<xsl:if test="ConsignmentHeader/Origin/Address/@addressID != ''">
									<D_3225>
										<xsl:value-of select="ConsignmentHeader/Origin/Address/@addressID"/>
									</D_3225>
								</xsl:if>
								<xsl:variable name="addrDomain" select="normalize-space(ConsignmentHeader/Origin/Address/@addressIDDomain)"/>
								<xsl:if test="$addrDomain != ''">
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/EDIFACTCode != ''">
											<D_3055>
												<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/EDIFACTCode"/>
											</D_3055>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
								<D_3224>
									<xsl:value-of select="ConsignmentHeader/Origin/Address/Name"/>
								</D_3224>
							</C_C517>
						</S_LOC>
						<xsl:for-each select="ConsignmentHeader/Origin/DateInfo">
							<xsl:if test="normalize-space(@type) = 'expectedDeliveryDate'">
								<S_DTM>
									<C_C507>
										<D_2005>17</D_2005>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="normalize-space(@date)"/>
										</xsl:call-template>
									</C_C507>
								</S_DTM>
							</xsl:if>
							<xsl:if test="@type = 'requestedDeliveryDate'">
								<S_DTM>
									<C_C507>
										<D_2005>2</D_2005>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="normalize-space(@date)"/>
										</xsl:call-template>
									</C_C507>
								</S_DTM>
							</xsl:if>
						</xsl:for-each>
					</G_SG1>
					<xsl:if test="normalize-space(ConsignmentHeader/CommercialTerms/@incoterms) != ''">
						<G_SG2>
							<S_TOD>
								<D_4055>6</D_4055>
								<C_C100>
									<D_4053>
										<xsl:value-of select="ConsignmentHeader/CommercialTerms/@incoterms"/>
									</D_4053>
								</C_C100>
							</S_TOD>
						</G_SG2>
					</xsl:if>
					<xsl:if test="normalize-space(@consignmentID) != ''">
						<G_SG3>


							<S_RFF>
								<C_C506>
									<D_1153>UCN</D_1153>
									<D_1154>
										<xsl:value-of select="normalize-space(@consignmentID)"/>
									</D_1154>
								</C_C506>
							</S_RFF>
						</G_SG3>
					</xsl:if>
					<xsl:if test="normalize-space(ConsignmentHeader/ShipmentIdentifier) != '' or normalize-space(ConsignmentHeader/ShipmentIdentifier/@trackingNumberDate) != ''">
						<G_SG3>

							<xsl:if test="normalize-space(ConsignmentHeader/ShipmentIdentifier) != ''">

								<S_RFF>
									<C_C506>
										<D_1153>CN</D_1153>
										<D_1154>
											<xsl:value-of select="ConsignmentHeader/ShipmentIdentifier"/>
										</D_1154>
										<D_4000>
											<xsl:value-of select="ConsignmentHeader/ShipmentIdentifier/@domain"/>
										</D_4000>
									</C_C506>
								</S_RFF>
							</xsl:if>
							<xsl:if test="normalize-space(ConsignmentHeader/ShipmentIdentifier/@trackingNumberDate) != ''">
								<S_DTM>
									<C_C507>
										<D_2005>85</D_2005>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="normalize-space(ConsignmentHeader/ShipmentIdentifier/@trackingNumberDate)"/>
										</xsl:call-template>
									</C_C507>
								</S_DTM>
							</xsl:if>
						</G_SG3>
					</xsl:if>
					<xsl:if test="normalize-space(ConsignmentHeader/ShipmentIdentifier/@trackingURL) != ''">
						<G_SG3>



							<S_RFF>
								<C_C506>
									<D_1153>CN</D_1153>
									<D_1154>
										<xsl:value-of select="ConsignmentHeader/ShipmentIdentifier/@trackingURL"/>
									</D_1154>
									<D_4000>TrackingURL</D_4000>
								</C_C506>
							</S_RFF>
						</G_SG3>
					</xsl:if>


					<xsl:for-each select="ConsignmentHeader/ReferenceDocumentInfo">
						<xsl:variable name="docType" select="DocumentInfo/@documentType"/>
						<xsl:if test="normalize-space(DocumentInfo/@documentID) != '' or normalize-space(DocumentInfo/@documentDate) != ''">
							<G_SG3>

								<xsl:if test="normalize-space(DocumentInfo/@documentID) != ''">
									<S_RFF>
										<C_C506>
											<xsl:choose>
												<xsl:when test="$Lookup/Lookups/DocumentTypes/DocumentType[CXMLCode = $docType]/EDIFACTCode != ''">
													<D_1153>
														<xsl:value-of select="$Lookup/Lookups/DocumentTypes/DocumentType[CXMLCode = $docType]/EDIFACTCode"/>
													</D_1153>
												</xsl:when>
											</xsl:choose>
											<D_1154>
												<xsl:value-of select="DocumentInfo/@documentID"/>
											</D_1154>
											<D_4000/>
										</C_C506>
									</S_RFF>
								</xsl:if>
								<xsl:if test="normalize-space(DocumentInfo/@documentDate) != ''">
									<S_DTM>
										<C_C507>
											<xsl:choose>
												<xsl:when test="$Lookup/Lookups/DocumentTypes/DocumentType[CXMLCode = $docType]/DTM != ''">
													<D_2005>
														<xsl:value-of select="$Lookup/Lookups/DocumentTypes/DocumentType[CXMLCode = $docType]/DTM"/>
													</D_2005>
												</xsl:when>
											</xsl:choose>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="DocDate" select="normalize-space(DocumentInfo/@documentDate)"/>
											</xsl:call-template>
										</C_C507>
									</S_DTM>
								</xsl:if>
							</G_SG3>
						</xsl:if>
					</xsl:for-each>

					<G_SG8>
						<S_TDT>
							<D_8051>20</D_8051>
							<C_C220>
								<xsl:variable name="method" select="ConsignmentHeader/Route/@method"/>
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/TransportModes/TransportMode[CXMLCode = $method]/EDIFACTCode != ''">
										<D_8067>
											<xsl:value-of select="$Lookup/Lookups/TransportModes/TransportMode[CXMLCode = $method]/EDIFACTCode"/>
										</D_8067>
									</xsl:when>
								</xsl:choose>
								<D_8066>
									<xsl:value-of select="ConsignmentHeader/Route/@method"/>
								</D_8066>
							</C_C220>
							<C_C228>
								<xsl:variable name="means" select="ConsignmentHeader/Route/@means"/>

								<xsl:choose>
									<xsl:when test="normalize-space(ConsignmentHeader/Route/@method) = 'air'">
										<D_8179>6</D_8179>
									</xsl:when>
									<xsl:when test="$Lookup/Lookups/TransportMeans/TransportMean[CXMLCode = $means]/EDIFACTCode != ''">
										<D_8179>
											<xsl:value-of select="$Lookup/Lookups/TransportMeans/TransportMean[CXMLCode = $means]/EDIFACTCode"/>
										</D_8179>
									</xsl:when>
								</xsl:choose>
								<D_8178>
									<xsl:value-of select="ConsignmentHeader/Route/@means"/>
								</D_8178>
							</C_C228>
							<xsl:for-each select="ConsignmentHeader/Route/Contact">
								<xsl:if test="normalize-space(@role) = 'carrier'">
									<C_C040>
										<D_3127>
											<xsl:value-of select="@addressID"/>
										</D_3127>
										<xsl:variable name="addrDomain1" select="normalize-space(@addressIDDomain)"/>
										<xsl:if test="$addrDomain1 != ''">
											<xsl:choose>
												<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain1]/EDIFACTCode != ''">
													<D_3055>
														<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain1]/EDIFACTCode"/>
													</D_3055>
												</xsl:when>
											</xsl:choose>
										</xsl:if>
										<D_3128>
											<xsl:value-of select="Name"/>
										</D_3128>
									</C_C040>
								</xsl:if>
							</xsl:for-each>

							<xsl:if test="normalize-space(ConsignmentHeader/Route/@startDate) != ''">
								<S_DTM>
									<C_C507>
										<D_2005>194</D_2005>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="normalize-space(ConsignmentHeader/Route/@startDate)"/>
										</xsl:call-template>
									</C_C507>
								</S_DTM>
							</xsl:if>
							<xsl:if test="ConsignmentHeader/Route/@endDate">
								<S_DTM>
									<C_C507>
										<D_2005>206</D_2005>
										<xsl:call-template name="formatDate">
											<xsl:with-param name="DocDate" select="normalize-space(ConsignmentHeader/Route/@endDate)"/>
										</xsl:call-template>
									</C_C507>
								</S_DTM>
							</xsl:if>
						</S_TDT>
					</G_SG8>

					<G_SG11>
						<xsl:call-template name="createNAD">
							<xsl:with-param name="Address" select="ConsignmentHeader/Origin/Address"/>
							<xsl:with-param name="role" select="'consignmentOrigin'"/>
							<!--<xsl:with-param name="NADQual" select="'LP'"/>-->
						</xsl:call-template>
					</G_SG11>

					<G_SG11>
						<xsl:call-template name="createNAD">
							<xsl:with-param name="Address" select="ConsignmentHeader/Destination/Address"/>
							<xsl:with-param name="role" select="'consignmentDestination'"/>
							<!--<xsl:with-param name="NADQual" select="'UP'"/>-->
						</xsl:call-template>
					</G_SG11>
					<xsl:for-each select="ConsignmentHeader/TransportPartner">
						<xsl:for-each select="Contact">
							<G_SG11>
								<xsl:variable name="qual" select="@role"/>

								<xsl:call-template name="createNAD">
									<xsl:with-param name="Address" select="."/>
									<xsl:with-param name="role" select="normalize-space(@role)"/>
								</xsl:call-template>

								<xsl:call-template name="CTACOMLoop">
									<xsl:with-param name="contact" select="."/>
									<!--<xsl:with-param name="contactType" select="IC"/>-->
									<xsl:with-param name="isIFTMIN" select="'true'"/>
									<xsl:with-param name="ContactDepartmentID" select="IdReference[@domain = 'ContactDepartmentID']/@identifier"/>
									<xsl:with-param name="ContactPerson" select="IdReference[@domain = 'ContactPerson']/@identifier"/>
								</xsl:call-template>
							</G_SG11>
						</xsl:for-each>
					</xsl:for-each>

					<xsl:for-each select="ConsignmentLineDetail">


						<G_SG18>
							<S_GID>

								<D_1496>
									<xsl:value-of select="@lineNumber"/>
								</D_1496>

								<xsl:for-each select="TransportPackage">
									<xsl:if test="position() &lt; 4">
										<xsl:if test="normalize-space(Packaging/PackagingLevelCode) = 'outer'">
											<xsl:variable name="segPosC213">
												<xsl:choose>
													<xsl:when test="position() = 1"> </xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="concat('_', (position() mod 4))"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:element name="{concat('C_C213', $segPosC213)}">
												<D_7224>
													<xsl:value-of select="position()"/>
												</D_7224>

												<D_7064>
													<xsl:value-of select="Packaging/PackagingCode"/>
												</D_7064>
											</xsl:element>
										</xsl:if>

										<xsl:if test="normalize-space(Packaging/PackagingLevelCode) = 'inner'">
											<xsl:variable name="segPosC213">
												<xsl:choose>
													<xsl:when test="position() = 1"> </xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="concat('_', position() mod 4)"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:element name="{concat('C_C213', $segPosC213)}">
												<D_7224>
													<xsl:value-of select="position()"/>
												</D_7224>

												<D_7064>
													<xsl:value-of select="Packaging/PackagingCode"/>
												</D_7064>
											</xsl:element>
										</xsl:if>
									</xsl:if>
								</xsl:for-each>
							</S_GID>
							<S_TMP>
								<D_6245>2</D_6245>
								<xsl:if test="TransportRequirements/TransportTemperature/@temperature != '' or TransportRequirements/TransportTemperature/UnitOfMeasure != ''">
									<C_C239>
										<xsl:if test="TransportRequirements/TransportTemperature/@temperature != ''">
											<D_6246>
												<xsl:value-of select="TransportRequirements/TransportTemperature/@temperature"/>
											</D_6246>
										</xsl:if>
										<xsl:if test="TransportRequirements/TransportTemperature/UnitOfMeasure != ''">
											<D_6411>
												<xsl:value-of select="TransportRequirements/TransportTemperature/UnitOfMeasure"/>
											</D_6411>
										</xsl:if>
									</C_C239>
								</xsl:if>
							</S_TMP>

							<xsl:for-each select="TransportPackage">
								<!-- Need to cross check this -->
								<xsl:if test="normalize-space(Packaging/PackagingLevelCode) = 'inner'">
									<xsl:if test="normalize-space(ItemInfo/ItemID/SupplierPartAuxiliaryID) != '' or normalize-space(ItemInfo/SupplierBatchID) != '' or normalize-space(ItemInfo/Classification/@domain) != ''">
										<S_PIA>
											<D_4347>1</D_4347>
											<xsl:choose>
												<xsl:when test="normalize-space(ItemInfo/ItemID/SupplierPartAuxiliaryID) != ''">
													<C_C212>
														<D_7140>
															<xsl:value-of select="normalize-space(ItemInfo/ItemID/SupplierPartAuxiliaryID)"/>
														</D_7140>
														<D_7143>VS</D_7143>
														<D_3055>91</D_3055>
													</C_C212>
													<xsl:if test="normalize-space(ItemInfo/SupplierBatchID) != ''">
														<C_C212_2>
															<D_7140>
																<xsl:value-of select="normalize-space(ItemInfo/SupplierBatchID)"/>
															</D_7140>
															<D_7143>NB</D_7143>
															<D_3055>91</D_3055>
														</C_C212_2>
													</xsl:if>
													<xsl:if test="normalize-space(ItemInfo/Classification/@domain) = 'UNSPSC'">
														<C_C212_3>
															<D_7140>
																<xsl:value-of select="normalize-space(ItemInfo/Classification/@domain)"/>
															</D_7140>
															<D_7143>CC</D_7143>
														</C_C212_3>
													</xsl:if>
												</xsl:when>
												<xsl:when test="normalize-space(ItemInfo/SupplierBatchID) != ''">
													<C_C212>
														<D_7140>
															<xsl:value-of select="normalize-space(ItemInfo/SupplierBatchID)"/>
														</D_7140>
														<D_7143>NB</D_7143>
														<D_3055>91</D_3055>
													</C_C212>
													<xsl:if test="normalize-space(ItemInfo/Classification/@domain) = 'UNSPSC'">
														<C_C212_2>
															<D_7140>
																<xsl:value-of select="normalize-space(ItemInfo/Classification/@domain)"/>
															</D_7140>
															<D_7143>CC</D_7143>
														</C_C212_2>
													</xsl:if>
												</xsl:when>
												<xsl:when test="normalize-space(ItemInfo/Classification/@domain) != 'UNSPSC'">
													<C_C212>
														<D_7140>
															<xsl:value-of select="normalize-space(ItemInfo/Classification/@domain)"/>
														</D_7140>
														<D_7143>CC</D_7143>
													</C_C212>
												</xsl:when>
											</xsl:choose>
										</S_PIA>
									</xsl:if>
									<xsl:if test="normalize-space(ItemInfo/ItemID/BuyerPartID) != '' or normalize-space(ItemInfo/ItemID/SupplierPartID) != ''">
										<S_PIA>
											<D_4347>5</D_4347>
											<xsl:choose>
												<xsl:when test="normalize-space(ItemInfo/ItemID/BuyerPartID) != ''">
													<C_C212>
														<D_7140>
															<xsl:value-of select="normalize-space(ItemInfo/ItemID/BuyerPartID)"/>
														</D_7140>
														<D_7143>BP</D_7143>
														<D_3055>92</D_3055>
													</C_C212>
													<xsl:if test="normalize-space(ItemInfo/ItemID/SupplierPartID) != ''">
														<C_C212_2>
															<D_7140>
																<xsl:value-of select="normalize-space(ItemInfo/ItemID/SupplierPartID)"/>
															</D_7140>
															<D_7143>VN</D_7143>
															<D_3055>91</D_3055>
														</C_C212_2>
													</xsl:if>
												</xsl:when>
												<xsl:when test="normalize-space(ItemInfo/ItemID/SupplierPartID) != ''">
													<C_C212>
														<D_7140>
															<xsl:value-of select="normalize-space(ItemInfo/ItemID/SupplierPartID)"/>
														</D_7140>
														<D_7143>VN</D_7143>
														<D_3055>91</D_3055>
													</C_C212>
												</xsl:when>
											</xsl:choose>
										</S_PIA>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="TransportRequirements/Hazard">
								<xsl:call-template name="FTXLoop">
									<xsl:with-param name="FTXData" select="normalize-space(.)"/>
									<xsl:with-param name="FTXQual" select="'HAZ'"/>
									<xsl:with-param name="langCode" select="@xml:lang"/>
								</xsl:call-template>
							</xsl:for-each>

							<xsl:for-each select="TransportRequirements/Classification">
								<xsl:call-template name="FTXLoop">
									<xsl:with-param name="domain" select="@domain"/>
									<xsl:with-param name="FTXQual" select="'AAC'"/>
									<xsl:with-param name="FTXData" select="normalize-space(.)"/>
								</xsl:call-template>
							</xsl:for-each>

							<xsl:for-each select="Extrinsic">
								<xsl:call-template name="FTXExtrinsic">
									<xsl:with-param name="FTXName" select="@name"/>
									<xsl:with-param name="FTXData" select="normalize-space(.)"/>
								</xsl:call-template>
							</xsl:for-each>

							<xsl:for-each select="Comments">
								<xsl:call-template name="FTXLoop">
									<xsl:with-param name="FTXData" select="normalize-space(.)"/>
									<xsl:with-param name="FTXQual" select="'AAI'"/>
									<xsl:with-param name="langCode" select="@xml:lang"/>
								</xsl:call-template>
							</xsl:for-each>


							<xsl:for-each select="TransportPackage">
								<xsl:if test="normalize-space(Packaging/PackagingLevelCode) = 'inner'">
									<xsl:if test="ItemInfo/UnitOfMeasure != ''">
										<G_SG20>
											<S_MEA>
												<D_6311>CT</D_6311>
												<C_C174>
													<D_6411>
														<xsl:value-of select="ItemInfo/UnitOfMeasure"/>
													</D_6411>
													<xsl:if test="ItemInfo/@quantity">
														<D_6314>
															<xsl:call-template name="formatDecimal">
																<xsl:with-param name="amount" select="normalize-space(ItemInfo/@quantity)"/>
															</xsl:call-template>
														</D_6314>
													</xsl:if>
												</C_C174>
											</S_MEA>
										</G_SG20>
									</xsl:if>
								</xsl:if>

								<xsl:if test="normalize-space(Packaging/PackagingLevelCode) = 'outer'">
									<xsl:for-each select="Packaging/Dimension">
										<G_SG20>
											<S_MEA>
												<D_6311>AAE</D_6311>
												<C_502>
													<xsl:variable name="Pdimen" select="@type"/>
													<D_6313>
														<xsl:choose>
															<xsl:when test="$Lookup/Lookups/Dimensions/Dimension[CXMLCode = $Pdimen]/EDIFACTCode != ''">
																<xsl:value-of select="$Lookup/Lookups/Dimensions/Dimension[CXMLCode = $Pdimen]/EDIFACTCode"/>
															</xsl:when>
														</xsl:choose>
													</D_6313>
												</C_502>

												<C_C174>
													<D_6411>

														<xsl:value-of select="UnitOfMeasure"/>
													</D_6411>
													<D_6314>
														<xsl:call-template name="formatDecimal">
															<xsl:with-param name="amount" select="normalize-space(@quantity)"/>
														</xsl:call-template>
													</D_6314>
												</C_C174>
											</S_MEA>
										</G_SG20>
									</xsl:for-each>
								</xsl:if>
							</xsl:for-each>
							<!--SG22 -->
							<xsl:for-each select="ReferenceDocumentInfo">
								<G_SG22>
									<xsl:if test="normalize-space(DocumentInfo/@documentID) != ''">
										<xsl:variable name="docType" select="DocumentInfo/@documentType"/>
										<S_RFF>
											<C_C506>
												<xsl:choose>
													<xsl:when test="$Lookup/Lookups/DocumentTypes/DocumentType[CXMLCode = $docType]/EDIFACTCode != ''">
														<D_1153>
															<xsl:value-of select="$Lookup/Lookups/DocumentTypes/DocumentType[CXMLCode = $docType]/EDIFACTCode"/>
														</D_1153>
													</xsl:when>
												</xsl:choose>

												<D_1154>
													<xsl:value-of select="DocumentInfo/@documentID"/>
												</D_1154>
											</C_C506>
										</S_RFF>
									</xsl:if>
									<xsl:if test="normalize-space(DocumentInfo/@documentDate) != ''">
										<S_DTM>
											<C_C507>
												<D_2005>85</D_2005>
												<xsl:call-template name="formatDate">
													<xsl:with-param name="DocDate" select="normalize-space(DocumentInfo/@documentDate)"/>
												</xsl:call-template>
											</C_C507>
										</S_DTM>
									</xsl:if>
								</G_SG22>
							</xsl:for-each>

							<!--SG23-->
							<xsl:for-each select="TransportPackage">
								<G_SG23>
									<S_PCI>
										<D_4233>33E</D_4233>
									</S_PCI>
									<xsl:for-each select="Packaging/ShippingMark">

										<C_C210>

											<xsl:variable name="SMark" select="normalize-space(.)"/>
											<xsl:if test="$SMark != ''">
												<D_7102>
													<xsl:value-of select="substring($SMark, 1, 35)"/>
												</D_7102>
											</xsl:if>
											<xsl:if test="substring($SMark, 36, 35) != ''">
												<D_7102_2>
													<xsl:value-of select="substring($SMark, 36, 35)"/>
												</D_7102_2>
											</xsl:if>
											<xsl:if test="substring($SMark, 71, 35) != ''">
												<D_7102_3>
													<xsl:value-of select="substring($SMark, 71, 35)"/>
												</D_7102_3>
											</xsl:if>
											<xsl:if test="substring($SMark, 106, 35) != ''">
												<D_7102_4>
													<xsl:value-of select="substring($SMark, 106, 35)"/>
												</D_7102_4>
											</xsl:if>
											<xsl:if test="substring($SMark, 141, 35) != ''">
												<D_7102_5>
													<xsl:value-of select="substring($SMark, 141, 35)"/>
												</D_7102_5>
											</xsl:if>
											<xsl:if test="substring($SMark, 176, 35) != ''">
												<D_7102_6>
													<xsl:value-of select="substring($SMark, 176, 35)"/>
												</D_7102_6>
											</xsl:if>
											<xsl:if test="substring($SMark, 211, 35) != ''">
												<D_7102_6>
													<xsl:value-of select="substring($SMark, 211, 35)"/>
												</D_7102_6>
											</xsl:if>
										</C_C210>
									</xsl:for-each>
									<xsl:if test="normalize-space(Packaging/PackagingLevelCode) = 'inner' and normalize-space(Packaging/ShippingContainerSerialCodeReference) != ''">
										<S_RFF>
											<C_C506>
												<D_1153>AAT</D_1153>
												<D_1154>
													<xsl:value-of select="Packaging/ShippingContainerSerialCodeReference"/>
												</D_1154>
											</C_C506>
										</S_RFF>
									</xsl:if>
									<S_GIN>
										<D_7405>BJ</D_7405>
										<C_C208>
											<D_7402>
												<xsl:value-of select="Packaging/ShippingContainerSerialCode"/>
											</D_7402>
										</C_C208>
									</S_GIN>
								</G_SG23>
							</xsl:for-each>

							<xsl:for-each select="TransportPlacement">
								<G_SG29>
									<S_SGP>
										<C_C237>
											<D_8260>
												<xsl:value-of select="@equipmentID"/>
											</D_8260>
										</C_C237>
										<xsl:if test="@numberOfPackages != ''">
											<D_7224>
												<xsl:value-of select="@numberOfPackages"/>
											</D_7224>
										</xsl:if>
									</S_SGP>
								</G_SG29>
							</xsl:for-each>
						</G_SG18>
					</xsl:for-each>

					<xsl:for-each select="TransportEquipment[@equipmentID != '']">

						<xsl:variable name="type" select="$Lookup/Lookups/Equipments/Equipment[CXMLCode = normalize-space(@type)]/EDIFACTCode"/>

						<xsl:if test="$type != ''">
							<G_SG37>

								<S_EQD>
									<D_8053>
										<xsl:value-of select="$type"/>
									</D_8053>

									<C_C237>
										<D_8260>
											<xsl:value-of select="@equipmentID"/>
										</D_8260>
									</C_C237>
									<xsl:if test="@providedBy = '1' or @providedBy = '2'">

										<D_8077>
											<xsl:choose>
												<xsl:when test="normalize-space(@providedBy) = 'carrier'">2</xsl:when>
												<xsl:when test="normalize-space(@providedBy) = 'sender'">1</xsl:when>
											</xsl:choose>
										</D_8077>
									</xsl:if>
									<xsl:if test="@status = '4' or @status = '5'">
										<D_8169>
											<xsl:choose>
												<xsl:when test="normalize-space(@status) = 'empty'">4</xsl:when>
												<xsl:when test="normalize-space(@status) = 'full'">5</xsl:when>
											</xsl:choose>
										</D_8169>
									</xsl:if>
								</S_EQD>
								<xsl:if test="@numberOfEquipments != ''">
									<S_EQN>
										<C_C523>
											<D_6350>
												<xsl:value-of select="@numberOfEquipments"/>
											</D_6350>
										</C_C523>
									</S_EQN>
								</xsl:if>
							</G_SG37>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
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


	<xsl:template match="/cXML/Header"/>
</xsl:stylesheet>
