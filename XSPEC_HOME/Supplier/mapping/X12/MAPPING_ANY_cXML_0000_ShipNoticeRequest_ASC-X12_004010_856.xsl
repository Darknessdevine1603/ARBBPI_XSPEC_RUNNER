<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
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
	<!--xsl:param name="ASNType" select="//ShipNoticeHeader/Extrinsic[@name='ASNType']"/-->
	<!--local testing-->
	<!-- For local testing -->
	<!--<xsl:variable name="Lookup" select="document('LOOKUP_X12_4010.xml')"/>
		<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>-->
	<!-- for dynamic, reading from Partner Directory -->

	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:variable name="dateNow" select="current-dateTime()"/>
	<xsl:variable name="buyerANID" select="(/cXML/Header/From/Credential[lower-case(@domain) = 'networkid']/Identity)[1]"/>
	<xsl:variable name="supplierANID" select="(/cXML/Header/To/Credential[lower-case(@domain) = 'networkid']/Identity)[1]"/>
	<xsl:variable name="buyerSpecific" select="concat('pd', ':', $supplierANID, ':LOOKUPTABLE_', $buyerANID, ':', 'Binary')"/>
	<xsl:variable name="allBuyers" select="/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUPTABLE_ALL.xml"/>
	<xsl:variable name="lookupFile">
		<!--xsl:variable name="buyerSpecific" select="concat('pd', '_', $supplierANID, '_LOOKUPTABLE_', $buyerANID, '.xml')"/><xsl:variable name="allBuyers" select="concat('pd', '_', $supplierANID, '_LOOKUPTABLE_ALL.xml')"/-->
		<xsl:choose>
			<xsl:when test="doc-available($buyerSpecific)">
				<xsl:value-of select="$buyerSpecific"/>
			</xsl:when>
			<xsl:when test="doc-available($allBuyers)">
				<xsl:value-of select="$allBuyers"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'NotAvailable'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ASNType">
		<xsl:choose>
			<xsl:when test="$lookupFile != 'NotAvailable'">
				<xsl:variable name="lookupTable" select="document($lookupFile)"/>
				<xsl:value-of select="$lookupTable/LOOKUPTABLE/Parameter[Name = 'PackagingStructure']/ListOfItems/Item[Name = 'ASC-X12']/Value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'SOPI'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="/">
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>SH</D_479>
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
				<M_856>
					<S_ST>
						<D_143>856</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BSN>
						<D_353>
							<xsl:variable name="operation" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation"/>
							<xsl:choose>
								<xsl:when test="cXML/Header/To/UserAgent = 'Copy'">07</xsl:when>
								<xsl:when test="$operation = 'new'">00</xsl:when>
								<xsl:when test="$operation = 'delete'">03</xsl:when>
								<xsl:when test="$operation = 'update'">05</xsl:when>
							</xsl:choose>
						</D_353>
						<D_396>
							<xsl:choose>
								<xsl:when test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation = 'delete'">
									<xsl:value-of select="substring-before(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID, '_1')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_396>
						<D_373>
							<xsl:value-of select="translate(substring-before(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate, 'T'), '-', '')"/>
						</D_373>
						<D_337>
							<xsl:value-of select="substring(translate(substring-after(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate, 'T'), ':-', ''), 1, 6)"/>
						</D_337>
						<D_1005>
							<xsl:choose>
								<xsl:when test="$ASNType = 'SOIP' and exists(//ShipNoticeItem/Packaging)">
									<xsl:text>0002</xsl:text>
								</xsl:when>
								<xsl:when test="$ASNType = 'SOPI' and exists(//ShipNoticeItem/Packaging)">
									<xsl:text>0001</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'0004'"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_1005>
						<xsl:variable name="shipmenttype" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentType"/>
						<xsl:choose>
							<xsl:when test="$shipmenttype = 'actual'">
								<D_640>09</D_640>
							</xsl:when>
							<xsl:when test="$shipmenttype = 'planned'">
								<D_640>PL</D_640>
							</xsl:when>
						</xsl:choose>
						<xsl:variable name="fulfilmenttype" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@fulfillmentType"/>
						<xsl:choose>
							<xsl:when test="$fulfilmenttype = 'complete'">
								<D_641>C20</D_641>
							</xsl:when>
							<xsl:when test="$fulfilmenttype = 'partial'">
								<D_641>B44</D_641>
							</xsl:when>
						</xsl:choose>
					</S_BSN>
					<xsl:call-template name="createShipCommonDTM"/>
					<!-- Beginning of Header HL Segment -->
					<G_HL>
						<S_HL>
							<D_628>
								<xsl:text>1</xsl:text>
							</D_628>
							<D_735>
								<xsl:text>S</xsl:text>
							</D_735>
							<D_736>1</D_736>
						</S_HL>
						<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Comments">
							<xsl:if test="(normalize-space(./text()[1]) != '') and not(exists(@type)) and not(exists(Attachment))">
								<S_PID>
									<D_349>F</D_349>
									<D_750>GEN</D_750>
									<D_352>
										<xsl:value-of select="substring(normalize-space(./text()[1]), 1, 80)"/>
									</D_352>
									<D_819>
										<xsl:value-of select="substring(normalize-space(./@xml:lang), 1, 2)"/>
									</D_819>
								</S_PID>
							</xsl:if>
						</xsl:for-each>
						<xsl:variable name="totalOfPackagesLevel0001" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackagesLevel0001']"/>
						<xsl:variable name="totalOfPackagesLevel0002" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackagesLevel0002']"/>
						<xsl:if test="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackagesLevel0002']) != ''">
							<S_TD1>
								<D_103>
									<xsl:choose>
										<xsl:when test="count(distinct-values(cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[PackagingLevelCode = '0002']/PackageTypeCodeIdentifierCode)) = 1 and $totalOfPackagesLevel0002 = count(//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[PackagingLevelCode = '0002']/PackageTypeCodeIdentifierCode)">
											<xsl:value-of select="(cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[PackagingLevelCode = '0002']/PackageTypeCodeIdentifierCode)[1]"/>
										</xsl:when>
										<xsl:otherwise>MXD</xsl:otherwise>
									</xsl:choose>
								</D_103>
								<D_80>
									<xsl:value-of select="normalize-space($totalOfPackagesLevel0002)"/>
								</D_80>
							</S_TD1>
						</xsl:if>
						<xsl:if test="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackagesLevel0001']) != ''">
							<S_TD1>
								<D_103>
									<xsl:choose>
										<xsl:when test="count(distinct-values(//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[PackagingLevelCode = '0001']/PackageTypeCodeIdentifierCode)) = 1 and $totalOfPackagesLevel0001 = count(//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[PackagingLevelCode = '0001']/PackageTypeCodeIdentifierCode)">
											<xsl:value-of select="(cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[PackagingLevelCode = '0001']/PackageTypeCodeIdentifierCode)[1]"/>
										</xsl:when>
										<xsl:otherwise>MXD</xsl:otherwise>
									</xsl:choose>
								</D_103>
								<D_80>
									<xsl:value-of select="normalize-space($totalOfPackagesLevel0001)"/>
								</D_80>
							</S_TD1>
						</xsl:if>
						<xsl:if test="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackages']) != ''">
							<S_TD1>
								<D_103>
									<xsl:choose>
										<xsl:when test="count(distinct-values(//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[not(exists(PackagingLevelCode))]/PackageTypeCodeIdentifierCode)) = 1">
											<xsl:value-of select="ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[not(exists(PackagingLevelCode))]/PackageTypeCodeIdentifierCode"/>
										</xsl:when>
										<xsl:otherwise>MXD</xsl:otherwise>
									</xsl:choose>
								</D_103>
								<D_80>
									<xsl:value-of select="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'totalOfPackages'])"/>
								</D_80>
							</S_TD1>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension/@type = 'grossWeight'">
							<xsl:variable name="uom" select="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']/UnitOfMeasure)"/>
							<S_TD1>
								<D_187>G</D_187>
								<D_81>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']/@quantity"/>
								</D_81>
								<D_355_1>
									<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
								</D_355_1>
							</S_TD1>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension/@type = 'weight'">
							<xsl:variable name="uom" select="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'weight']/UnitOfMeasure)"/>
							<S_TD1>
								<D_187>N</D_187>
								<D_81>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'weight']/@quantity"/>
								</D_81>
								<D_355_1>
									<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
								</D_355_1>
							</S_TD1>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension/@type = 'grossVolume'">
							<xsl:variable name="uom" select="normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossVolume']/UnitOfMeasure)"/>
							<S_TD1>
								<D_183>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossVolume']/@quantity"/>
								</D_183>
								<D_355_2>
									<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
								</D_355_2>
							</S_TD1>
						</xsl:if>
						<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipControl/CarrierIdentifier">
							<xsl:if test="@domain = 'DUNS' or @domain = 'SCAC' or @domain = 'IATA'">
								<S_TD5>
									<D_66>
										<xsl:choose>
											<xsl:when test="@domain = 'DUNS'">
												<xsl:text>1</xsl:text>
											</xsl:when>
											<xsl:when test="@domain = 'SCAC'">
												<xsl:text>2</xsl:text>
											</xsl:when>
											<xsl:when test="@domain = 'IATA'">
												<xsl:text>4</xsl:text>
											</xsl:when>
										</xsl:choose>
									</D_66>
									<D_67>
										<xsl:value-of select="./text()"/>
									</D_67>
									<xsl:variable name="routeMethod">
										<xsl:choose>
											<xsl:when test="../../ShipControl/TransportInformation/Route/@method = 'custom'">
												<xsl:value-of select="normalize-space(../../ShipControl/TransportInformation/Route)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="normalize-space(../../ShipControl/TransportInformation/Route/@method)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'standard']/X12Code != ''">
											<D_91>
												<xsl:value-of select="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'standard']/X12Code"/>
											</D_91>
										</xsl:when>
										<xsl:when test="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'custom']/X12Code != ''">
											<D_91>
												<xsl:value-of select="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'custom']/X12Code"/>
											</D_91>
										</xsl:when>
									</xsl:choose>
									<xsl:if test="../../ShipControl/CarrierIdentifier[@domain = 'companyName']/text() != ''">
										<D_387>
											<xsl:value-of select="../../ShipControl/CarrierIdentifier[@domain = 'companyName']/text()"/>
										</D_387>
									</xsl:if>
									<D_309>ZZ</D_309>
									<D_310>
										<xsl:choose>
											<xsl:when test="../../ShipControl/ShipmentIdentifier[@domain = 'trackingNumber']/text() != ''">
												<xsl:value-of select="../../ShipControl/ShipmentIdentifier[@domain = 'trackingNumber']/text()"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>Tracking Number</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</D_310>
									<xsl:for-each select="../../ShipNoticeHeader/ServiceLevel[. = $Lookup/Lookups/ServicelLevels/ServiceLevel/CXMLCode]">
										<xsl:variable name="srvlvl" select="."/>
										<xsl:variable name="slLookup" select="($Lookup/Lookups/ServicelLevels/ServiceLevel[CXMLCode = $srvlvl]/X12Code)[1]"/>
										<xsl:if test="position() &lt; 4">
											<xsl:if test="$slLookup != ''">
												<xsl:element name="{concat('D_284_',position())}">
													<xsl:value-of select="$slLookup"/>
												</xsl:element>
											</xsl:if>
										</xsl:if>
									</xsl:for-each>
								</S_TD5>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/ShippingContractNumber != ''">
							<S_TD5>
								<D_66>
									<xsl:text>ZZ</xsl:text>
								</D_66>
								<D_67>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/ShippingContractNumber"/>
								</D_67>
								<xsl:variable name="routeMethod">
									<xsl:choose>
										<xsl:when test="cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/Route/@method = 'custom'">
											<xsl:value-of select="normalize-space(cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/Route)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="normalize-space(cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/Route/@method)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'standard']/X12Code != ''">
										<D_91>
											<xsl:value-of select="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'standard']/X12Code"/>
										</D_91>
									</xsl:when>
									<xsl:when test="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'custom']/X12Code != ''">
										<D_91>
											<xsl:value-of select="$Lookup/Lookups/TransportMethods/TransportMethod[CXMLCode = $routeMethod][Type = 'custom']/X12Code"/>
										</D_91>
									</xsl:when>
								</xsl:choose>
								<xsl:if test="normalize-space(cXML/Request//ShipNoticeRequest/ShipControl/TransportInformation/ShippingInstructions/Description) != ''">
									<D_309>ZZ</D_309>
									<D_310>
										<xsl:value-of select="substring(normalize-space(cXML/Request//ShipNoticeRequest/ShipControl/TransportInformation/ShippingInstructions/Description), 1, 30)"/>
									</D_310>
								</xsl:if>
							</S_TD5>
						</xsl:if>
						<xsl:variable name="eqCode" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/EquipmentIdentificationCode"/>
						<xsl:if test="$Lookup/Lookups/Equipmentcodes/Equipmentcode[CXMLCode = $eqCode]/X12Code != '' or cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/Extrinsic[@name = 'EquipmentID'] != '' or cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/SealID != ''">
							<S_TD3>
								<xsl:if test="$Lookup/Lookups/Equipmentcodes/Equipmentcode[CXMLCode = $eqCode]/X12Code != ''">
									<D_40_1>
										<xsl:value-of select="$Lookup/Lookups/Equipmentcodes/Equipmentcode[CXMLCode = $eqCode]/X12Code"/>
									</D_40_1>
								</xsl:if>
								<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/Extrinsic[@name = 'EquipmentID'] != ''">
									<D_207>
										<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/Extrinsic[@name = 'EquipmentID']"/>
									</D_207>
								</xsl:if>
								<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/SealID != ''">
									<D_225>
										<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/SealID"/>
									</D_225>
								</xsl:if>
							</S_TD3>
						</xsl:if>
						<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipControl/CarrierIdentifier[@domain != 'DUNS' and @domain != 'SCAC' and @domain != 'IATA' and @domain != 'companyName']">
							<xsl:if test="@domain != '' and . != ''">
								<S_TD4>
									<D_152>ZZZ</D_152>
									<D_352>
										<xsl:value-of select="concat(@domain, '@', .)"/>
									</D_352>
								</S_TD4>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Hazard/Classification[@domain = 'NAHG' or @domain = 'IMDG' or @domain = 'UNDG']">
							<xsl:if test="@domain != '' and . != ''">
								<S_TD4>
									<D_208>
										<xsl:choose>
											<xsl:when test="@domain = 'NAHG'">9</xsl:when>
											<xsl:when test="@domain = 'IMDG'">I</xsl:when>
											<xsl:when test="@domain = 'UNDG'">U</xsl:when>
										</xsl:choose>
									</D_208>
									<D_209>
										<xsl:value-of select="."/>
									</D_209>
									<D_352>
										<xsl:value-of select="../Description"/>
									</D_352>
								</S_TD4>
							</xsl:if>
						</xsl:for-each>
						<!--Header Extrinsics-->
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TransportTerms/@value = 'Other'">
							<S_REF>
								<D_128>
									<xsl:text>0L</xsl:text>
								</D_128>
								<D_127>
									<xsl:text>FOB05</xsl:text>
								</D_127>
								<D_352>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TransportTerms"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Comments[@type = 'Transport'] != ''">
							<S_REF>
								<D_128>0L</D_128>
								<D_127>
									<xsl:value-of select="'TransportComments'"/>
								</D_127>
								<D_352>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Comments[@type = 'Transport']"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/ShippingInstructions/Description), 31, 111) != ''">
							<S_REF>
								<D_128>0N</D_128>
								<D_127>
									<xsl:value-of select="'ShipInstruct'"/>
								</D_127>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipControl/TransportInformation/ShippingInstructions/Description), 31, 111)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'trackingNumber']/@trackingURL != ''">
							<S_REF>
								<D_128>CN</D_128>
								<D_127>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'trackingNumber']/@trackingURL), 1, 30)"/>
								</D_127>
								<xsl:if test="cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'trackingNumber']/@trackingNumberDate">
									<D_352>
										<xsl:call-template name="adjustDTM">
											<xsl:with-param name="cXMLDate" select="cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'trackingNumber']/@trackingNumberDate"/>
										</xsl:call-template>
									</D_352>
								</xsl:if>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'billOfLading'] != ''">
							<S_REF>
								<D_128>BM</D_128>
								<D_127>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'billOfLading']), 1, 30)"/>
								</D_127>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Comments/@type = 'TermsOfDelivery'">
							<S_REF>
								<D_128>0L</D_128>
								<D_127>
									<xsl:value-of select="'TODComments'"/>
								</D_127>
								<D_352>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery']"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/SealID != ''">
							<S_REF>
								<D_128>SN</D_128>
								<D_352>
									<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfTransport/SealID"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'governmentNumber']/@identifier != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'AEC'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'governmentNumber']/@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'customerReferenceID']/@identifier != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'CR'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'customerReferenceID']/@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'ultimateCustomerReferenceID']/@identifier != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'EU'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'ultimateCustomerReferenceID']/@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'supplierReference']/@identifier != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'D2'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'supplierReference']/@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'documentName']/@identifier != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'DD'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/IdReference[@domain = 'documentName']/@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'SupplierOrderID'] != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'VN'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'SupplierOrderID']), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'InvoiceID'] != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'IN'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'InvoiceID']), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'ShippingContractNumber'] != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'CT'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'ShippingContractNumber']), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'DeliveryNoteID'] != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="'DJ'"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name = 'DeliveryNoteID']), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:if>
						<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[@name != ''][normalize-space(.) != '']">
							<S_REF>
								<D_128>ZZ</D_128>
								<D_127>
									<xsl:value-of select="substring(@name, 1, 30)"/>
								</D_127>
								<D_352>
									<xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:for-each>
						<!-- IG-32292 Comments -->
						<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Comments">
							<xsl:call-template name="mapComments"/>
						</xsl:for-each>
						<xsl:variable name="spmVal" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
						<xsl:variable name="ttVal" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TransportTerms/@value"/>
						<xsl:if test="$spmVal != ''">
							<S_FOB>
								<D_146>
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $spmVal]/X12Code != ''">
											<xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $spmVal]/X12Code"/>
										</xsl:when>
										<xsl:otherwise>DF</xsl:otherwise>
									</xsl:choose>
								</D_146>
								<xsl:choose>
									<xsl:when test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TermsOfDeliveryCode/@value = 'Other'">
										<D_309_1>ZZ</D_309_1>
										<D_352_1>
											<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TermsOfDeliveryCode"/>
										</D_352_1>
									</xsl:when>
									<xsl:otherwise>
										<D_309_1>ZN</D_309_1>
										<D_352_1>
											<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/TermsOfDeliveryCode/@value"/>
										</D_352_1>
									</xsl:otherwise>
								</xsl:choose>
								<!-- IG-34414 -->
								<xsl:if test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $ttVal]/X12Code != '' or $Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $ttVal]/CXMLCode != ''">
									<D_334>ZZ</D_334>
									<D_335>
										<xsl:choose>
											<xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $ttVal]/X12Code != ''">
												<xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $ttVal]/X12Code"/>
											</xsl:when>

											<xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $ttVal]/CXMLCode != ''">
												<xsl:value-of select="$ttVal"/>
											</xsl:when>
											<xsl:otherwise>ZZZ</xsl:otherwise>
										</xsl:choose>
									</D_335>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$spmVal = 'other'">
										<D_309_2>ZZ</D_309_2>
										<D_352_2>
											<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/ShippingPaymentMethod/text()"/>
										</D_352_2>
									</xsl:when>
									<xsl:when test="$spmVal != ''">
										<D_309_2>ZZ</D_309_2>
										<D_352_2>
											<xsl:value-of select="$spmVal"/>
										</D_352_2>
									</xsl:when>
								</xsl:choose>
							</S_FOB>
						</xsl:if>
						<xsl:if test="exists(cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery/Address)">
							<xsl:call-template name="createN1_CopyShip">
								<xsl:with-param name="isOrder" select="'true'"/>
								<xsl:with-param name="party" select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/TermsOfDelivery"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact">
							<xsl:call-template name="createContact_CopyShip">
								<xsl:with-param name="party" select="."/>
								<xsl:with-param name="isOrder" select="'true'"/>
							</xsl:call-template>
						</xsl:for-each>
					</G_HL>
					<xsl:for-each select="cXML/Request/ShipNoticeRequest/ShipNoticePortion">
						<xsl:variable name="OrderHLprecedingItemCount" select="count(preceding::ShipNoticePortion/ShipNoticeItem)"/>
						<xsl:variable name="OrderHLprecedingCompCount" select="count(preceding::ShipNoticePortion/ShipNoticeItem/ComponentConsumptionDetails)"/>
						<xsl:variable name="OrderHLprecedingPkgCount" select="count(distinct-values(preceding::ShipNoticePortion/ShipNoticeItem/Packaging/ShippingContainerSerialCode))"/>
						<xsl:variable name="orderCount" select="count(preceding::ShipNoticePortion) + 1 + 1"/>
						<xsl:variable name="ordPosition" select="$orderCount + $OrderHLprecedingItemCount + $OrderHLprecedingCompCount + $OrderHLprecedingPkgCount"/>
						<xsl:variable name="precedingPkgTareCount" select="count(distinct-values(preceding::ShipNoticePortion/ShipNoticeItem/Packaging[not(exists(ShippingContainerSerialCodeReference))]/ShippingContainerSerialCode))"/>
						<G_HL>
							<S_HL>
								<D_628>
									<xsl:value-of select="$ordPosition"/>
								</D_628>
								<D_734>
									<xsl:value-of select="'1'"/>
								</D_734>
								<D_735>
									<xsl:text>O</xsl:text>
								</D_735>
								<xsl:if test="ShipNoticeItem">
									<D_736>1</D_736>
								</xsl:if>
							</S_HL>
							<xsl:if test="OrderReference">
								<S_PRF>
									<D_324>
										<xsl:value-of select="OrderReference/@orderID"/>
									</D_324>
									<xsl:if test="OrderReference/@orderDate">
										<D_373>
											<xsl:value-of select="translate(substring-before(OrderReference/@orderDate, 'T'), '-', '')"/>
										</D_373>
									</xsl:if>
									<xsl:if test="MasterAgreementIDInfo/@agreementID != ''">
										<D_367>
											<xsl:value-of select="MasterAgreementIDInfo/@agreementID"/>
										</D_367>
									</xsl:if>
								</S_PRF>
							</xsl:if>
							<!-- IG-32292 Comments -->
							<xsl:for-each select="Comments">
								<xsl:if test="(normalize-space(./text()[1]) != '') and not(exists(@type)) and not(exists(Attachment))">
									<S_PID>
										<D_349>F</D_349>
										<D_750>GEN</D_750>
										<D_352>
											<xsl:value-of select="substring(normalize-space(./text()[1]), 1, 80)"/>
										</D_352>
										<D_819>
											<xsl:value-of select="substring(normalize-space(./@xml:lang), 1, 2)"/>
										</D_819>
									</S_PID>
								</xsl:if>
							</xsl:for-each>
							<xsl:if test="OrderReference/@orderID != ''">
								<S_REF>
									<D_128>PO</D_128>
									<D_352>
										<xsl:value-of select="substring(normalize-space(OrderReference/@orderID), 1, 80)"/>
									</D_352>
								</S_REF>
							</xsl:if>
							<xsl:if test="MasterAgreementIDInfo/@agreementID != ''">
								<S_REF>
									<D_128>AH</D_128>
									<xsl:if test="lower-case(MasterAgreementIDInfo/@agreementType) = 'scheduling_agreement'">
										<D_127>1</D_127>
									</xsl:if>
									<D_352>
										<xsl:value-of select="substring(normalize-space(MasterAgreementIDInfo/@agreementID), 1, 80)"/>
									</D_352>
								</S_REF>
							</xsl:if>
							<xsl:for-each select="Extrinsic[@name != ''][normalize-space(.) != '']">
								<S_REF>
									<D_128>ZZ</D_128>
									<D_127>
										<xsl:value-of select="substring(@name, 1, 30)"/>
									</D_127>
									<D_352>
										<xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
									</D_352>
								</S_REF>
							</xsl:for-each>
							<!-- IG-32292 Comments -->
							<xsl:for-each select="Comments">
								<xsl:call-template name="mapComments"/>
							</xsl:for-each>
							<xsl:if test="OrderReference/@orderDate">
								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">004</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of select="OrderReference/@orderDate"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="MasterAgreementIDInfo/@agreementDate">
								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">LEA</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of select="MasterAgreementIDInfo/@agreementDate"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:for-each select="Contact">
								<xsl:call-template name="createContact_CopyShip">
									<xsl:with-param name="party" select="."/>
									<xsl:with-param name="isOrder" select="'true'"/>
								</xsl:call-template>
							</xsl:for-each>
						</G_HL>
						<xsl:choose>
							<xsl:when test="$ASNType = 'SOPI' and (ShipNoticeItem/Packaging)">
								<xsl:for-each-group select="ShipNoticeItem" group-by="Packaging[not(exists(ShippingContainerSerialCodeReference))]/ShippingContainerSerialCode">
									<xsl:variable name="tareKey" select="current-grouping-key()"/>
									<xsl:variable name="tareCounter" select="position()"/>
									<xsl:variable name="precedingPkgPackCount" select="count(distinct-values(preceding::ShipNoticeItem/Packaging[exists(ShippingContainerSerialCodeReference)]/ShippingContainerSerialCode))"/>
									<xsl:variable name="precedingCompCount" select="count(preceding::ShipNoticeItem[exists(Packaging)]/ComponentConsumptionDetails)"/>
									<xsl:variable name="precedingItemCount" select="count(preceding::ShipNoticeItem[exists(Packaging)])"/>
									<xsl:variable name="tareHLPosition">
										<xsl:value-of select="$orderCount + $tareCounter + $precedingPkgPackCount + $precedingItemCount + $precedingCompCount + $precedingPkgTareCount"/>
									</xsl:variable>
									<xsl:variable name="tareParentPos" select="$ordPosition"/>
									<xsl:choose>
										<xsl:when test="..//Packaging/ShippingContainerSerialCodeReference = $tareKey">
											<xsl:call-template name="buildHL_Tare">
												<xsl:with-param name="HLPos" select="$tareHLPosition"/>
												<xsl:with-param name="HLParentPos" select="$tareParentPos"/>
												<xsl:with-param name="HLType" select="'T'"/>
												<xsl:with-param name="path" select="./Packaging[ShippingContainerSerialCode = $tareKey]"/>
											</xsl:call-template>
											<xsl:for-each-group select="current-group()" group-by="Packaging[ShippingContainerSerialCodeReference = $tareKey]/ShippingContainerSerialCode">
												<xsl:variable name="pckKey" select="current-grouping-key()"/>
												<xsl:variable name="packCounter" select="position()"/>
												<xsl:variable name="currentPrecedingCompCounter" select="count(preceding::ShipNoticeItem[Packaging/ShippingContainerSerialCodeReference = $tareKey]/ComponentConsumptionDetails)"/>
												<xsl:variable name="currentPrecedingItemCounter" select="count(preceding::ShipNoticeItem[Packaging/ShippingContainerSerialCodeReference = $tareKey])"/>
												<xsl:variable name="packHLPosition" select="$tareHLPosition + $packCounter + $currentPrecedingCompCounter + $currentPrecedingItemCounter"/>
												<xsl:variable name="pckParentPos" select="$tareHLPosition"/>
												<xsl:call-template name="buildHL_Pack">
													<xsl:with-param name="HLPos" select="$packHLPosition"/>
													<xsl:with-param name="HLParentPos" select="$pckParentPos"/>
													<xsl:with-param name="HLType" select="'P'"/>
													<xsl:with-param name="path" select="./Packaging[ShippingContainerSerialCode = $pckKey]"/>
												</xsl:call-template>
												<xsl:for-each select="current-group()">
													<xsl:variable name="lineCounter" select="position()"/>
													<xsl:variable name="lineParentPos" select="$packHLPosition"/>
													<xsl:variable name="currentPrecedingCompCounter1" select="count(preceding::ShipNoticeItem[Packaging[ShippingContainerSerialCodeReference = $tareKey]/ShippingContainerSerialCode = $pckKey]/ComponentConsumptionDetails)"/>
													<xsl:variable name="lineHLPosition" select="$packHLPosition + $lineCounter + $currentPrecedingCompCounter1"/>
													<xsl:call-template name="buildHL_Line">
														<xsl:with-param name="HLPos" select="$lineHLPosition"/>
														<xsl:with-param name="HLParentPos" select="$lineParentPos"/>
														<xsl:with-param name="HLType" select="'I'"/>
														<xsl:with-param name="HLChild">
															<xsl:choose>
																<xsl:when test="ComponentConsumptionDetails">
																	<xsl:value-of select="'1'"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="'0'"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:with-param>
													</xsl:call-template>
													<xsl:for-each select="ComponentConsumptionDetails">
														<xsl:variable name="compCounter" select="position()"/>
														<xsl:variable name="compHLPosition" select="$lineHLPosition + $compCounter"/>
														<xsl:variable name="compParentPos" select="$lineHLPosition"/>
														<xsl:call-template name="buildHL_Comp">
															<xsl:with-param name="HLPos" select="$compHLPosition"/>
															<xsl:with-param name="HLParentPos" select="$compParentPos"/>
															<xsl:with-param name="HLType" select="'F'"/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:for-each>
											</xsl:for-each-group>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="buildHL_Pack">
												<xsl:with-param name="HLPos" select="$tareHLPosition"/>
												<xsl:with-param name="HLParentPos" select="$tareParentPos"/>
												<xsl:with-param name="HLType" select="'P'"/>
												<xsl:with-param name="path" select="./Packaging[ShippingContainerSerialCode = $tareKey]"/>
											</xsl:call-template>
											<xsl:for-each select="current-group()">
												<xsl:variable name="pckKey" select="current-grouping-key()"/>
												<xsl:variable name="lineCounter" select="position()"/>
												<xsl:variable name="lineParentPos" select="$tareHLPosition"/>
												<xsl:variable name="currentPrecedingCompCounter1" select="count(preceding::ShipNoticeItem[Packaging/ShippingContainerSerialCode = $tareKey]/ComponentConsumptionDetails)"/>
												<xsl:variable name="lineHLPosition" select="$tareHLPosition + $lineCounter + $currentPrecedingCompCounter1"/>
												<xsl:call-template name="buildHL_Line">
													<xsl:with-param name="HLPos" select="$lineHLPosition"/>
													<xsl:with-param name="HLParentPos" select="$lineParentPos"/>
													<xsl:with-param name="HLType" select="'I'"/>
													<xsl:with-param name="HLChild">
														<xsl:choose>
															<xsl:when test="ComponentConsumptionDetails">
																<xsl:value-of select="'1'"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="'0'"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="key" select="$pckKey"/>
												</xsl:call-template>
												<xsl:for-each select="ComponentConsumptionDetails">
													<xsl:variable name="compCounter" select="position()"/>
													<xsl:variable name="compHLPosition" select="$lineHLPosition + $compCounter"/>
													<xsl:variable name="compParentPos" select="$lineHLPosition"/>
													<xsl:call-template name="buildHL_Comp">
														<xsl:with-param name="HLPos" select="$compHLPosition"/>
														<xsl:with-param name="HLParentPos" select="$compParentPos"/>
														<xsl:with-param name="HLType" select="'F'"/>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each-group>
								<xsl:for-each select="ShipNoticeItem[not(exists(Packaging))]">
									<xsl:sort select="Packaging" order="ascending"/>
									<xsl:variable name="precedingItemCount" select="count(preceding::ShipNoticeItem)"/>
									<xsl:variable name="precedingPkgCount" select="count(distinct-values(preceding::ShipNoticeItem/Packaging/ShippingContainerSerialCode))"/>
									<xsl:variable name="precedingCompCount" select="count(preceding::ShipNoticeItem/ComponentConsumptionDetails)"/>
									<xsl:variable name="currentCompCount" select="count(ComponentConsumptionDetails)"/>
									<xsl:variable name="currentPkgCount" select="count(Packaging)"/>
									<xsl:variable name="lineParentPos">
										<xsl:value-of select="$ordPosition"/>
									</xsl:variable>
									<xsl:variable name="linePos">
										<xsl:value-of select="$orderCount + $precedingItemCount + $precedingPkgCount + $precedingCompCount + 1"/>
									</xsl:variable>
									<xsl:call-template name="buildHL_Line">
										<xsl:with-param name="HLPos" select="$linePos"/>
										<xsl:with-param name="HLParentPos" select="$lineParentPos"/>
										<xsl:with-param name="HLType" select="'I'"/>
										<xsl:with-param name="HLChild">
											<xsl:choose>
												<xsl:when test="ComponentConsumptionDetails or Packaging">
													<xsl:value-of select="'1'"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'0'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:for-each select="ComponentConsumptionDetails">
										<xsl:variable name="compCounter" select="position()"/>
										<xsl:variable name="HLcompPos">
											<xsl:value-of select="$linePos + $compCounter"/>
										</xsl:variable>
										<xsl:call-template name="buildHL_Comp">
											<xsl:with-param name="HLPos" select="$HLcompPos"/>
											<xsl:with-param name="HLParentPos" select="$linePos"/>
											<xsl:with-param name="HLType" select="'F'"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$ASNType = 'SOIP' and (ShipNoticeItem/Packaging)">
								<xsl:for-each select="ShipNoticeItem">
									<xsl:variable name="precedingItemCount" select="count(preceding::ShipNoticeItem)"/>
									<xsl:variable name="precedingPkgTareCount" select="count(preceding::ShipNoticeItem/Packaging)"/>
									<xsl:variable name="precedingCompCount" select="count(preceding::ShipNoticeItem/ComponentConsumptionDetails)"/>
									<xsl:variable name="currentCompCount" select="count(ComponentConsumptionDetails)"/>
									<xsl:variable name="currentPkgTareCount" select="count(Packaging)"/>
									<xsl:variable name="tareParentPos">
										<xsl:value-of select="$orderCount + $precedingItemCount + $precedingPkgTareCount + $precedingCompCount + 1"/>
									</xsl:variable>
									<xsl:variable name="pckParentPos">
										<xsl:value-of select="$orderCount + $precedingItemCount + $precedingPkgTareCount + $precedingCompCount + $currentCompCount"/>
									</xsl:variable>
									<xsl:variable name="lineParentPos">
										<xsl:value-of select="$ordPosition"/>
									</xsl:variable>
									<xsl:variable name="linePos">
										<xsl:value-of select="$orderCount + $precedingItemCount + $precedingPkgTareCount + $precedingCompCount + 1"/>
									</xsl:variable>
									<xsl:call-template name="buildHL_Line">
										<xsl:with-param name="HLPos" select="$linePos"/>
										<xsl:with-param name="HLParentPos" select="$lineParentPos"/>
										<xsl:with-param name="HLType" select="'I'"/>
										<xsl:with-param name="HLChild">
											<xsl:choose>
												<xsl:when test="ComponentConsumptionDetails or Packaging">
													<xsl:value-of select="'1'"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'0'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:for-each select="ComponentConsumptionDetails">
										<xsl:variable name="compCounter" select="position()"/>
										<xsl:variable name="HLcompPos">
											<xsl:value-of select="$linePos + $compCounter"/>
										</xsl:variable>
										<xsl:call-template name="buildHL_Comp">
											<xsl:with-param name="HLPos" select="$HLcompPos"/>
											<xsl:with-param name="HLParentPos" select="$linePos"/>
											<xsl:with-param name="HLType" select="'F'"/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="Packaging">
										<xsl:sort select="ShippingContainerSerialCodeReference" order="ascending"/>
										<xsl:variable name="pkgCounter" select="position()"/>
										<xsl:variable name="currentShipSerialCode" select="ShippingContainerSerialCode"/>
										<xsl:variable name="HLTare_PckPos" select="$orderCount + $precedingItemCount + $precedingPkgTareCount + $precedingCompCount + $currentCompCount + $pkgCounter + 1"/>
										<xsl:choose>
											<xsl:when test="not(exists(ShippingContainerSerialCodeReference)) and ../Packaging/ShippingContainerSerialCodeReference = $currentShipSerialCode">
												<xsl:call-template name="buildHL_Tare">
													<xsl:with-param name="HLPos">
														<xsl:value-of select="$HLTare_PckPos"/>
													</xsl:with-param>
													<xsl:with-param name="HLParentPos">
														<xsl:value-of select="$linePos"/>
													</xsl:with-param>
													<xsl:with-param name="HLType">
														<xsl:value-of select="'T'"/>
													</xsl:with-param>
													<xsl:with-param name="path" select="."/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="not(exists(ShippingContainerSerialCodeReference)) and not(../Packaging/ShippingContainerSerialCodeReference = $currentShipSerialCode)">
												<xsl:call-template name="buildHL_Pack">
													<xsl:with-param name="HLPos" select="$HLTare_PckPos"/>
													<xsl:with-param name="HLParentPos" select="$linePos"/>
													<xsl:with-param name="HLType" select="'P'"/>
													<xsl:with-param name="HLChild" select="'0'"/>
													<xsl:with-param name="path" select="."/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="buildHL_Pack">
													<xsl:with-param name="HLPos" select="$HLTare_PckPos"/>
													<xsl:with-param name="HLParentPos" select="$pckParentPos + $pkgCounter"/>
													<xsl:with-param name="HLType" select="'P'"/>
													<xsl:with-param name="HLChild" select="'0'"/>
													<xsl:with-param name="path" select="."/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="ShipNoticeItem">
									<xsl:variable name="precedingItemCount" select="count(preceding::ShipNoticeItem)"/>
									<xsl:variable name="precedingPkgCount" select="count(preceding::ShipNoticeItem/Packaging)"/>
									<xsl:variable name="precedingCompCount" select="count(preceding::ShipNoticeItem/ComponentConsumptionDetails)"/>
									<xsl:variable name="currentCompCount" select="count(ComponentConsumptionDetails)"/>
									<xsl:variable name="currentPkgCount" select="count(Packaging)"/>
									<xsl:variable name="lineParentPos">
										<xsl:value-of select="$ordPosition"/>
									</xsl:variable>
									<xsl:variable name="linePos">
										<xsl:value-of select="$orderCount + $precedingItemCount + $precedingPkgCount + $precedingCompCount + 1"/>
									</xsl:variable>
									<xsl:call-template name="buildHL_Line">
										<xsl:with-param name="HLPos" select="$linePos"/>
										<xsl:with-param name="HLParentPos" select="$lineParentPos"/>
										<xsl:with-param name="HLType" select="'I'"/>
										<xsl:with-param name="HLChild">
											<xsl:choose>
												<xsl:when test="ComponentConsumptionDetails or Packaging">
													<xsl:value-of select="'1'"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'0'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:for-each select="ComponentConsumptionDetails">
										<xsl:variable name="compCounter" select="position()"/>
										<xsl:variable name="HLcompPos">
											<xsl:value-of select="$linePos + $compCounter"/>
										</xsl:variable>
										<xsl:call-template name="buildHL_Comp">
											<xsl:with-param name="HLPos" select="$HLcompPos"/>
											<xsl:with-param name="HLParentPos" select="$linePos"/>
											<xsl:with-param name="HLType" select="'F'"/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="Packaging">
										<xsl:variable name="pkgCounter" select="position()"/>
										<xsl:variable name="HLPckPos" select="$orderCount + $precedingItemCount + $precedingPkgCount + $precedingCompCount + $currentCompCount + $pkgCounter + 1"/>
										<xsl:call-template name="buildHL_Pack">
											<xsl:with-param name="HLPos" select="$HLPckPos"/>
											<xsl:with-param name="HLParentPos" select="$linePos"/>
											<xsl:with-param name="HLType" select="'P'"/>
											<xsl:with-param name="HLChild" select="'0'"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<S_CTT>
						<D_354>
							<xsl:value-of select="count(cXML/Request/ShipNoticeRequest/ShipNoticePortion)"/>
						</D_354>
					</S_CTT>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_856>
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
	<xsl:template name="buildHL_Tare">
		<xsl:param name="HLPos"/>
		<xsl:param name="HLParentPos"/>
		<xsl:param name="HLType"/>
		<xsl:param name="path"/>
		<G_HL>
			<S_HL>
				<D_628>
					<xsl:value-of select="$HLPos"/>
				</D_628>
				<D_734>
					<xsl:value-of select="$HLParentPos"/>
				</D_734>
				<D_735>
					<xsl:value-of select="$HLType"/>
				</D_735>
				<D_736>
					<xsl:text>1</xsl:text>
				</D_736>
			</S_HL>
			<S_PO4>
				<xsl:variable name="packCodeID" select="$path/PackageTypeCodeIdentifierCode"/>
				<xsl:variable name="packCode" select="$path/PackagingCode"/>
				<D_103>
					<xsl:choose>
						<xsl:when test="$Lookup/Lookups/PackagingCodes/PackagingCode[lower-case(CXMLCode) = $packCode]/X12Code != ''">
							<xsl:value-of select="$Lookup/Lookups/PackagingCodes/PackagingCode[CXMLCode = $packCode]/X12Code"/>
						</xsl:when>
						<xsl:when test="$Lookup/Lookups/PackagingCodes/PackagingCode[X12Code = $packCodeID]/CXMLCode != ''">
							<xsl:value-of select="$packCodeID"/>
						</xsl:when>
					</xsl:choose>
				</D_103>
				<xsl:if test="$path/Dimension[@type = 'weight']/@quantity">
					<D_384>
						<xsl:value-of select="$path/Dimension[@type = 'weight']/@quantity"/>
					</D_384>
					<D_355_2>
						<xsl:variable name="uom" select="normalize-space($path/Dimension[@type = 'weight']/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_2>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'volume']/@quantity">
					<D_385>
						<xsl:value-of select="$path/Dimension[@type = 'volume']/@quantity"/>
					</D_385>
					<D_355_3>
						<xsl:variable name="uom" select="normalize-space($path/Dimension[@type = 'volume']/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_3>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'length']/@quantity">
					<D_82>
						<xsl:value-of select="$path/Dimension[@type = 'length']/@quantity"/>
					</D_82>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'width']/@quantity">
					<D_189>
						<xsl:value-of select="$path/Dimension[@type = 'width']/@quantity"/>
					</D_189>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'height']/@quantity">
					<D_65>
						<xsl:value-of select="$path/Dimension[@type = 'height']/@quantity"/>
					</D_65>
					<D_355_4>
						<xsl:variable name="uom" select="normalize-space($path/Dimension[@type = 'height']/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_4>
				</xsl:if>
			</S_PO4>
			<xsl:if test="$path/ShippingContainerSerialCode != ''">
				<S_MAN>
					<D_88_1>GM</D_88_1>
					<D_87_1>
						<xsl:value-of select="$path/ShippingContainerSerialCode"/>
					</D_87_1>
				</S_MAN>
			</xsl:if>
			<xsl:if test="$path/PackageID/PackageTrackingID != ''">
				<S_MAN>
					<D_88_1>CA</D_88_1>
					<D_87_1>
						<xsl:value-of select="$path/PackageID/PackageTrackingID"/>
					</D_87_1>
				</S_MAN>
			</xsl:if>
			<xsl:if test="$path/PackageID/GlobalIndividualAssetID != ''">
				<S_MAN>
					<D_88_1>ZZ</D_88_1>
					<D_87_1>
						<xsl:value-of select="'GIAI'"/>
					</D_87_1>
					<D_87_2>
						<xsl:value-of select="$path/PackageID/GlobalIndividualAssetID"/>
					</D_87_2>
				</S_MAN>
			</xsl:if>
		</G_HL>
	</xsl:template>
	<xsl:template name="buildHL_Pack">
		<xsl:param name="HLPos"/>
		<xsl:param name="HLParentPos"/>
		<xsl:param name="HLType"/>
		<xsl:param name="HLChild"/>
		<xsl:param name="path"/>

		<G_HL>
			<S_HL>
				<D_628>
					<xsl:value-of select="$HLPos"/>
				</D_628>
				<D_734>
					<xsl:value-of select="$HLParentPos"/>
				</D_734>
				<D_735>
					<xsl:value-of select="$HLType"/>
				</D_735>
				<D_736>
					<xsl:choose>
						<xsl:when test="$HLChild">
							<xsl:value-of select="$HLChild"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>1</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</D_736>
			</S_HL>
			<S_PO4>
				<xsl:if test="$path/DispatchQuantity/@quantity != ''">
					<D_356>
						<xsl:text>1</xsl:text>
					</D_356>
				</xsl:if>
				<xsl:if test="$path/DispatchQuantity/@quantity != ''">
					<D_357>
						<xsl:value-of select="$path/DispatchQuantity/@quantity"/>
					</D_357>
				</xsl:if>
				<xsl:if test="$path/DispatchQuantity/UnitOfMeasure">
					<D_355_1>
						<xsl:variable name="uom" select="normalize-space($path/DispatchQuantity/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_1>
				</xsl:if>
				<xsl:variable name="packCodeID" select="$path/PackageTypeCodeIdentifierCode"/>
				<xsl:variable name="packCode" select="$path/PackagingCode"/>
				<D_103>
					<xsl:choose>
						<xsl:when test="$Lookup/Lookups/PackagingCodes/PackagingCode[CXMLCode = $packCode]/X12Code != ''">
							<xsl:value-of select="$Lookup/Lookups/PackagingCodes/PackagingCode[CXMLCode = $packCode]/X12Code"/>
						</xsl:when>
						<xsl:when test="$Lookup/Lookups/PackagingCodes/PackagingCode[X12Code = $packCodeID]/CXMLCode != ''">
							<xsl:value-of select="$packCodeID"/>
						</xsl:when>
					</xsl:choose>
				</D_103>
				<xsl:if test="$path/Dimension[@type = 'weight']/@quantity">
					<D_384>
						<xsl:value-of select="$path/Dimension[@type = 'weight']/@quantity"/>
					</D_384>
					<D_355_2>
						<xsl:variable name="uom" select="normalize-space($path/Dimension[@type = 'weight']/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_2>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'volume']/@quantity">
					<D_385>
						<xsl:value-of select="$path/Dimension[@type = 'volume']/@quantity"/>
					</D_385>
					<D_355_3>
						<xsl:variable name="uom" select="normalize-space($path/Dimension[@type = 'volume']/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_3>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'length']/@quantity">
					<D_82>
						<xsl:value-of select="$path/Dimension[@type = 'length']/@quantity"/>
					</D_82>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'width']/@quantity">
					<D_189>
						<xsl:value-of select="$path/Dimension[@type = 'width']/@quantity"/>
					</D_189>
				</xsl:if>
				<xsl:if test="$path/Dimension[@type = 'height']/@quantity">
					<D_65>
						<xsl:value-of select="$path/Dimension[@type = 'height']/@quantity"/>
					</D_65>
					<D_355_4>
						<xsl:variable name="uom" select="normalize-space($path/Dimension[@type = 'height']/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_4>
				</xsl:if>
			</S_PO4>
			<xsl:if test="$path/ShippingContainerSerialCode != ''">
				<S_MAN>
					<D_88_1>GM</D_88_1>
					<D_87_1>
						<xsl:value-of select="$path/ShippingContainerSerialCode"/>
					</D_87_1>
				</S_MAN>
			</xsl:if>
			<xsl:if test="$path/PackageID/PackageTrackingID != ''">
				<S_MAN>
					<D_88_1>CA</D_88_1>
					<D_87_1>
						<xsl:value-of select="$path/PackageID/PackageTrackingID"/>
					</D_87_1>
				</S_MAN>
			</xsl:if>
			<xsl:if test="$path/PackageID/GlobalIndividualAssetID != ''">
				<S_MAN>
					<D_88_1>ZZ</D_88_1>
					<D_87_1>
						<xsl:value-of select="'GIAI'"/>
					</D_87_1>
					<D_87_2>
						<xsl:value-of select="$path/PackageID/GlobalIndividualAssetID"/>
					</D_87_2>
				</S_MAN>
			</xsl:if>
		</G_HL>
	</xsl:template>
	<xsl:template name="buildHL_Comp">
		<xsl:param name="HLPos"/>
		<xsl:param name="HLParentPos"/>
		<xsl:param name="HLType"/>
		<G_HL>
			<S_HL>
				<D_628>
					<xsl:value-of select="$HLPos"/>
				</D_628>
				<D_734>
					<xsl:value-of select="$HLParentPos"/>
				</D_734>
				<D_735>
					<xsl:value-of select="$HLType"/>
				</D_735>
				<D_736>
					<xsl:text>0</xsl:text>
				</D_736>
			</S_HL>
			<S_LIN>
				<D_350>
					<xsl:value-of select="@lineNumber"/>
				</D_350>
				<xsl:call-template name="createItemPartsCopy">
					<xsl:with-param name="itemDetail" select="."/>
					<xsl:with-param name="itemID" select="Product"/>
				</xsl:call-template>
			</S_LIN>
			<S_SN1>
				<D_382>
					<xsl:value-of select="./@quantity"/>
				</D_382>
				<D_355_1>
					<xsl:variable name="uom" select="normalize-space(./UnitOfMeasure)"/>
					<xsl:choose>
						<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
							<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
						</xsl:when>
						<xsl:otherwise>ZZ</xsl:otherwise>
					</xsl:choose>
				</D_355_1>
			</S_SN1>
			<xsl:for-each select="./AssetInfo">
				<xsl:call-template name="AssetInfo">
					<xsl:with-param name="tagNo" select="@tagNumber"/>
					<xsl:with-param name="serialNo" select="@serialNumber"/>
				</xsl:call-template>
			</xsl:for-each>
		</G_HL>
	</xsl:template>
	<xsl:template name="buildHL_Line">
		<xsl:param name="HLPos"/>
		<xsl:param name="HLParentPos"/>
		<xsl:param name="HLType"/>
		<xsl:param name="HLChild"/>
		<xsl:param name="key"/>
		<G_HL>
			<S_HL>
				<D_628>
					<xsl:value-of select="$HLPos"/>
				</D_628>
				<D_734>
					<xsl:value-of select="$HLParentPos"/>
				</D_734>
				<D_735>
					<xsl:value-of select="$HLType"/>
				</D_735>
				<D_736>
					<xsl:value-of select="$HLChild"/>
				</D_736>
			</S_HL>
			<S_LIN>
				<D_350>
					<xsl:value-of select="@shipNoticeLineNumber"/>
				</D_350>
				<xsl:call-template name="createItemPartsCopy">
					<xsl:with-param name="itemDetail" select="."/>
					<xsl:with-param name="itemID" select="ItemID"/>
					<xsl:with-param name="lineRef" select="@lineNumber"/>
				</xsl:call-template>
			</S_LIN>
			<S_SN1>
				<D_350>
					<xsl:value-of select="@lineNumber"/>
				</D_350>
				<D_382>
					<xsl:choose>
						<xsl:when test="$ASNType = 'SOPI' and Packaging[ShippingContainerSerialCode = $key]/DispatchQuantity/@quantity != '' and Packaging/ShippingContainerSerialCode != ''">
							<xsl:value-of select="Packaging[ShippingContainerSerialCode = $key]/DispatchQuantity/@quantity"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@quantity"/>
						</xsl:otherwise>
					</xsl:choose>
				</D_382>
				<D_355_1>
					<xsl:choose>
						<xsl:when test="$ASNType = 'SOPI' and Packaging[ShippingContainerSerialCode = $key]/DispatchQuantity/UnitOfMeasure != '' and Packaging/ShippingContainerSerialCode != ''">
							<xsl:variable name="uom" select="normalize-space(Packaging[ShippingContainerSerialCode = $key]/DispatchQuantity/UnitOfMeasure)"/>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
									<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="uom" select="normalize-space(UnitOfMeasure)"/>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
									<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</D_355_1>
				<xsl:if test="OrderedQuantity/@quantity != ''">
					<D_330>
						<xsl:value-of select="OrderedQuantity/@quantity"/>
					</D_330>
					<D_355_2>
						<xsl:variable name="uom" select="normalize-space(OrderedQuantity/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_2>
				</xsl:if>
				<xsl:if test="Extrinsic[@name = 'DiscrepancyNatureIdentificationCode']">
					<D_668>
						<xsl:value-of select="Extrinsic[@name = 'DiscrepancyNatureIdentificationCode']"/>
					</D_668>
				</xsl:if>
			</S_SN1>
			<xsl:if test="ShipNoticeItemDetail/UnitPrice/Money != ''">
				<S_SLN>
					<D_350_1>
						<xsl:value-of select="@lineNumber"/>
					</D_350_1>
					<D_662_1>
						<xsl:value-of select="'O'"/>
					</D_662_1>
					<D_212>
						<xsl:call-template name="formatAmount">
							<xsl:with-param name="amount" select="ShipNoticeItemDetail/UnitPrice/Money"/>
						</xsl:call-template>
					</D_212>

				</S_SLN>
			</xsl:if>
			<xsl:for-each select="Packaging[not(exists(ShippingContainerSerialCode))]">
				<S_PO4>
					<D_356>
						<xsl:choose>
							<xsl:when test="DispatchQuantity/@quantity != ''">
								<xsl:value-of select="'1'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>0</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</D_356>
					<xsl:if test="DispatchQuantity/@quantity != ''">
						<D_357>
							<xsl:value-of select="DispatchQuantity/@quantity"/>
						</D_357>
					</xsl:if>
					<D_355_1>
						<xsl:variable name="uom" select="normalize-space(DispatchQuantity/UnitOfMeasure)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_1>
					<xsl:variable name="packCodeID" select="PackageTypeCodeIdentifierCode"/>
					<xsl:variable name="packCode" select="PackagingCode"/>
					<xsl:if test="$packCode != '' or $packCodeID != ''">
						<D_103>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/PackagingCodes/PackagingCode[CXMLCode = $packCode]/X12Code != ''">
									<xsl:value-of select="$Lookup/Lookups/PackagingCodes/PackagingCode[CXMLCode = $packCode]/X12Code"/>
								</xsl:when>
								<xsl:when test="$Lookup/Lookups/PackagingCodes/PackagingCode[X12Code = $packCodeID]/CXMLCode != ''">
									<xsl:value-of select="$packCodeID"/>
								</xsl:when>
							</xsl:choose>
						</D_103>
					</xsl:if>
					<xsl:if test="Dimension[@type = 'weight']/@quantity">
						<D_384>
							<xsl:value-of select="Dimension[@type = 'weight']/@quantity"/>
						</D_384>
						<D_355_2>
							<xsl:variable name="uom" select="normalize-space(Dimension[@type = 'weight']/UnitOfMeasure)"/>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
									<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</D_355_2>
					</xsl:if>
					<xsl:if test="Dimension[@type = 'volume']/@quantity">
						<D_385>
							<xsl:value-of select="Dimension[@type = 'volume']/@quantity"/>
						</D_385>
						<D_355_3>
							<xsl:variable name="uom" select="normalize-space(Dimension[@type = 'volume']/UnitOfMeasure)"/>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
									<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</D_355_3>
					</xsl:if>
					<xsl:if test="Dimension[@type = 'length']/@quantity">
						<D_82>
							<xsl:value-of select="Dimension[@type = 'length']/@quantity"/>
						</D_82>
					</xsl:if>
					<xsl:if test="Dimension[@type = 'width']/@quantity">
						<D_189>
							<xsl:value-of select="Dimension[@type = 'width']/@quantity"/>
						</D_189>
					</xsl:if>
					<xsl:if test="Dimension[@type = 'height']/@quantity">
						<D_65>
							<xsl:value-of select="Dimension[@type = 'height']/@quantity"/>
						</D_65>
						<D_355_4>
							<xsl:variable name="uom" select="normalize-space(Dimension[@type = 'height']/UnitOfMeasure)"/>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
									<xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code)"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</D_355_4>
					</xsl:if>
				</S_PO4>
			</xsl:for-each>
			<xsl:if test="ShipNoticeItemDetail/Description/ShortName != ''">
				<S_PID>
					<D_349>F</D_349>
					<D_750>GEN</D_750>
					<D_352>
						<xsl:value-of select="substring(normalize-space(ShipNoticeItemDetail/Description/ShortName), 1, 80)"/>
					</D_352>
					<D_819>
						<xsl:choose>
							<xsl:when test="string-length(normalize-space(ShipNoticeItemDetail/Description/@xml:lang)) &gt; 1">
								<xsl:value-of select="upper-case(substring(normalize-space(ShipNoticeItemDetail/Description/@xml:lang), 1, 2))"/>
							</xsl:when>
							<xsl:otherwise>EN</xsl:otherwise>
						</xsl:choose>
					</D_819>
				</S_PID>
			</xsl:if>
			<xsl:if test="normalize-space(ShipNoticeItemDetail/Description) != ''">
				<S_PID>
					<D_349>F</D_349>
					<D_352>
						<xsl:value-of select="substring(normalize-space(ShipNoticeItemDetail/Description), 1, 80)"/>
					</D_352>
					<D_819>
						<xsl:choose>
							<xsl:when test="string-length(normalize-space(ShipNoticeItemDetail/Description/@xml:lang)) &gt; 1">
								<xsl:value-of select="upper-case(substring(normalize-space(ShipNoticeItemDetail/Description/@xml:lang), 1, 2))"/>
							</xsl:when>
							<xsl:otherwise>EN</xsl:otherwise>
						</xsl:choose>
					</D_819>
				</S_PID>
			</xsl:if>
			<xsl:for-each select="ShipNoticeItemDetail/Dimension">
				<xsl:if test="(position() &lt; 41)">
					<xsl:call-template name="createMEA_FromDimension_CopyShip">
						<xsl:with-param name="dimension" select="."/>
						<xsl:with-param name="meaQual" select="'PD'"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="Hazard/Classification[@domain = 'NAHG' or @domain = 'IMDG' or @domain = 'UNDG']">
				<xsl:if test="@domain != '' and . != ''">
					<S_TD4>
						<D_208>
							<xsl:choose>
								<xsl:when test="@domain = 'NAHG'">9</xsl:when>
								<xsl:when test="@domain = 'IMDG'">I</xsl:when>
								<xsl:when test="@domain = 'UNDG'">U</xsl:when>
							</xsl:choose>
						</D_208>
						<D_209>
							<xsl:value-of select="."/>
						</D_209>
						<D_352>
							<xsl:value-of select="../Description"/>
						</D_352>
					</S_TD4>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="@parentLineNumber">
				<S_REF>
					<D_128>FL</D_128>
					<D_127>
						<xsl:value-of select="@parentLineNumber"/>
					</D_127>
					<D_352>
						<xsl:value-of select="@itemType"/>
					</D_352>
					<xsl:if test="@compositeItemType != '' and lower-case(@itemType) = 'composite'">
						<C_C040>
							<D_128>FL</D_128>
							<D_127>
								<xsl:value-of select="@compositeItemType"/>
							</D_127>
						</C_C040>
					</xsl:if>
				</S_REF>
			</xsl:if>
			<xsl:if test="normalize-space(ShipNoticeItemIndustry/ShipNoticeItemRetail/PromotionDealID) != ''">
				<S_REF>
					<D_128>PD</D_128>
					<D_352>
						<xsl:value-of select="substring(normalize-space(ShipNoticeItemIndustry/ShipNoticeItemRetail/PromotionDealID), 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:if test="Batch/@productionDate != ''">
				<S_REF>
					<D_128>BT</D_128>
					<D_127>
						<xsl:value-of select="'productionDate'"/>
					</D_127>
					<D_352>
						<xsl:call-template name="adjustDTM">
							<xsl:with-param name="cXMLDate" select="substring(Batch/@productionDate, 1, 80)"/>
						</xsl:call-template>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:if test="Batch/@expirationDate != ''">
				<S_REF>
					<D_128>BT</D_128>
					<D_127>
						<xsl:value-of select="'expirationDate'"/>
					</D_127>
					<D_352>
						<xsl:call-template name="adjustDTM">
							<xsl:with-param name="cXMLDate" select="substring(Batch/@expirationDate, 1, 80)"/>
						</xsl:call-template>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:if test="Batch/@inspectionDate != ''">
				<S_REF>
					<D_128>BT</D_128>
					<D_127>
						<xsl:value-of select="'inspectionDate'"/>
					</D_127>
					<D_352>
						<xsl:call-template name="adjustDTM">
							<xsl:with-param name="cXMLDate" select="substring(Batch/@inspectionDate, 1, 80)"/>
						</xsl:call-template>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:if test="Batch/@shelfLife != ''">
				<S_REF>
					<D_128>BT</D_128>
					<D_127>
						<xsl:value-of select="'shelfLife'"/>
					</D_127>
					<D_352>
						<xsl:value-of select="substring(Batch/@shelfLife, 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:if test="Batch/@batchQuantity != ''">
				<S_REF>
					<D_128>BT</D_128>
					<D_127>
						<xsl:value-of select="'batchQuantity'"/>
					</D_127>
					<D_352>
						<xsl:value-of select="substring(Batch/@batchQuantity, 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:if test="Batch/@originCountryCode != ''">
				<S_REF>
					<D_128>BT</D_128>
					<D_127>
						<xsl:value-of select="'originCountryCode'"/>
					</D_127>
					<D_352>
						<xsl:value-of select="substring(Batch/@originCountryCode, 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:for-each select="Extrinsic[@name != ''][normalize-space(.) != '']">
				<S_REF>
					<D_128>ZZ</D_128>
					<D_127>
						<xsl:value-of select="substring(@name, 1, 30)"/>
					</D_127>
					<D_352>
						<xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:for-each>
			<!-- IG-32292 -->
			<xsl:for-each select="Comments">
				<xsl:call-template name="mapComments"/>
			</xsl:for-each>
			<xsl:for-each select="AssetInfo">
				<xsl:call-template name="AssetInfo">
					<xsl:with-param name="tagNo" select="@tagNumber"/>
					<xsl:with-param name="serialNo" select="@serialNumber"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:if test="ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date">
				<xsl:call-template name="createDTM">
					<xsl:with-param name="D374_Qual">036</xsl:with-param>
					<xsl:with-param name="cXMLDate">
						<xsl:value-of select="ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="ShipNoticeItemIndustry/ShipNoticeItemRetail/BestBeforeDate/@date">
				<xsl:call-template name="createDTM">
					<xsl:with-param name="D374_Qual">511</xsl:with-param>
					<xsl:with-param name="cXMLDate">
						<xsl:value-of select="ShipNoticeItemIndustry/ShipNoticeItemRetail/BestBeforeDate/@date"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="ShipNoticeItemDetail/UnitPrice/Money/@currency != ''">
				<S_CUR>
					<D_98_1>BY</D_98_1>
					<D_100_1>
						<xsl:value-of select="ShipNoticeItemDetail/UnitPrice/Money/@currency"/>
					</D_100_1>
				</S_CUR>
			</xsl:if>
		</G_HL>
	</xsl:template>
	<xsl:template name="createItemPartsCopy">
		<xsl:param name="itemID"/>
		<xsl:param name="itemDetail"/>
		<xsl:param name="description"/>
		<xsl:param name="lineRef"/>
		<xsl:variable name="partsList">
			<PartsList>
				<xsl:if test="normalize-space($lineRef) != ''">
					<Part>
						<Qualifier>PL</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($lineRef), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($itemID/SupplierPartID) != ''">
					<Part>
						<Qualifier>VP</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemID/SupplierPartID), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($itemID/BuyerPartID) != ''">
					<Part>
						<Qualifier>BP</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemID/BuyerPartID), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($itemID/SupplierPartAuxiliaryID) != ''">
					<Part>
						<Qualifier>VS</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemID/SupplierPartAuxiliaryID), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="$itemDetail">
					<xsl:if test="normalize-space($itemDetail/ShipNoticeItemDetail/ManufacturerPartID) != ''">
						<Part>
							<Qualifier>MG</Qualifier>
							<Value>
								<xsl:value-of select="substring(normalize-space($itemDetail/ShipNoticeItemDetail/ManufacturerPartID), 1, 48)"/>
							</Value>
						</Part>
					</xsl:if>
					<xsl:if test="normalize-space($itemDetail/ShipNoticeItemDetail/ManufacturerName) != ''">
						<Part>
							<Qualifier>MF</Qualifier>
							<Value>
								<xsl:value-of select="substring(normalize-space($itemDetail/ShipNoticeItemDetail/ManufacturerName), 1, 48)"/>
							</Value>
						</Part>
					</xsl:if>
					<xsl:if test="normalize-space($itemDetail/ShipNoticeItemDetail/Classification[@domain = 'UNSPSC']) != ''">
						<Part>
							<Qualifier>C3</Qualifier>
							<Value>
								<xsl:value-of select="substring(normalize-space($itemDetail/ShipNoticeItemDetail/Classification[@domain = 'UNSPSC']), 1, 48)"/>
							</Value>
						</Part>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="normalize-space($itemDetail/ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != ''">
							<Part>
								<Qualifier>EN</Qualifier>
								<Value>
									<xsl:value-of select="substring(normalize-space($itemDetail/ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID), 1, 48)"/>
								</Value>
							</Part>
						</xsl:when>
						<xsl:when test="normalize-space($itemDetail/IdReference[@domain = 'EAN-13']/@identifier) != ''">
							<Part>
								<Qualifier>EN</Qualifier>
								<Value>
									<xsl:value-of select="substring(normalize-space($itemDetail/IdReference[@domain = 'EAN-13']/@identifier), 1, 48)"/>
								</Value>
							</Part>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="normalize-space($itemDetail/Batch/SupplierBatchID) != ''">
							<Part>
								<Qualifier>B8</Qualifier>
								<Value>
									<xsl:value-of select="substring(normalize-space($itemDetail/Batch/SupplierBatchID), 1, 48)"/>
								</Value>
							</Part>
						</xsl:when>
						<xsl:when test="normalize-space($itemDetail/SupplierBatchID) != ''">
							<Part>
								<Qualifier>B8</Qualifier>
								<Value>
									<xsl:value-of select="substring(normalize-space($itemDetail/SupplierBatchID), 1, 48)"/>
								</Value>
							</Part>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="normalize-space($itemDetail/Batch/BuyerBatchID) != ''">
							<Part>
								<Qualifier>LT</Qualifier>
								<Value>
									<xsl:value-of select="substring(normalize-space($itemDetail/Batch/BuyerBatchID), 1, 48)"/>
								</Value>
							</Part>
						</xsl:when>
						<xsl:when test="normalize-space($itemDetail/BuyerBatchID) != ''">
							<Part>
								<Qualifier>LT</Qualifier>
								<Value>
									<xsl:value-of select="substring(normalize-space($itemDetail/BuyerBatchID), 1, 48)"/>
								</Value>
							</Part>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="normalize-space($itemID/IdReference[@domain = 'custSKU']/@identifier) != ''">
					<Part>
						<Qualifier>SK</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemID/IdReference[@domain = 'custSKU']/@identifier), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($itemDetail/Extrinsic[normalize-space(@name) = 'SubLineItemReference']) != ''">
					<Part>
						<Qualifier>A7</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemDetail/Extrinsic[normalize-space(@name) = 'SubLineItemReference']), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($itemDetail/Extrinsic[normalize-space(@name) = 'HarmonizedSystemID']) != ''">
					<Part>
						<Qualifier>UL</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemDetail/Extrinsic[normalize-space(@name) = 'HarmonizedSystemID']), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($itemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier) != ''">
					<Part>
						<Qualifier>UP</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($description) != ''">
					<Part>
						<Qualifier>PD</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($description), 1, 48)"/>
						</Value>
					</Part>
				</xsl:if>
			</PartsList>
		</xsl:variable>
		<xsl:for-each select="$partsList/PartsList/Part">
			<xsl:choose>
				<xsl:when test="position() = 1">
					<xsl:element name="D_235_1">
						<xsl:value-of select="./Qualifier"/>
					</xsl:element>
					<xsl:element name="D_234_1">
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
	</xsl:template>
	<xsl:template name="AssetInfo">
		<xsl:param name="serialNo"/>
		<xsl:param name="tagNo"/>
		<S_MAN>
			<D_88_1>L</D_88_1>
			<D_87_1>
				<xsl:choose>
					<xsl:when test="$tagNo">
						<xsl:text>AT</xsl:text>
					</xsl:when>
					<xsl:when test="$serialNo">
						<xsl:text>SN</xsl:text>
					</xsl:when>
				</xsl:choose>
			</D_87_1>
			<D_87_2>
				<xsl:choose>
					<xsl:when test="$tagNo">
						<xsl:value-of select="$tagNo"/>
					</xsl:when>
					<xsl:when test="$serialNo">
						<xsl:value-of select="$serialNo"/>
					</xsl:when>
				</xsl:choose>
			</D_87_2>
			<xsl:if test="$serialNo != '' and $tagNo != ''">
				<D_88_2>L</D_88_2>
				<D_87_3>
					<xsl:choose>
						<xsl:when test="$serialNo">
							<xsl:text>SN</xsl:text>
						</xsl:when>
						<xsl:when test="$tagNo">
							<xsl:text>AT</xsl:text>
						</xsl:when>
					</xsl:choose>
				</D_87_3>
				<D_87_4>
					<xsl:choose>
						<xsl:when test="$serialNo">
							<xsl:value-of select="$serialNo"/>
						</xsl:when>
						<xsl:when test="$tagNo">
							<xsl:value-of select="$tagNo"/>
						</xsl:when>
					</xsl:choose>
				</D_87_4>
			</xsl:if>
		</S_MAN>
	</xsl:template>
	<xsl:template name="createShipCommonDTM">
		<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate != ''">
			<xsl:call-template name="createDTM">
				<xsl:with-param name="D374_Qual">111</xsl:with-param>
				<xsl:with-param name="cXMLDate">
					<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@noticeDate"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentDate != ''">
			<xsl:call-template name="createDTM">
				<xsl:with-param name="D374_Qual">011</xsl:with-param>
				<xsl:with-param name="cXMLDate">
					<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentDate"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate != ''">
			<xsl:call-template name="createDTM">
				<xsl:with-param name="D374_Qual">017</xsl:with-param>
				<xsl:with-param name="cXMLDate">
					<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[lower-case(@name) = 'pickupdate'] != ''">
			<xsl:call-template name="createDTM">
				<xsl:with-param name="D374_Qual">118</xsl:with-param>
				<xsl:with-param name="cXMLDate">
					<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Extrinsic[lower-case(@name) = 'pickupdate']"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@requestedDeliveryDate != ''">
			<xsl:call-template name="createDTM">
				<xsl:with-param name="D374_Qual">002</xsl:with-param>
				<xsl:with-param name="cXMLDate">
					<xsl:value-of select="cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@requestedDeliveryDate"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="createN1_CopyShip">
		<xsl:param name="party"/>
		<xsl:param name="mapFOB"/>
		<xsl:param name="isOrder"/>
		<xsl:variable name="role">
			<xsl:choose>
				<xsl:when test="name($party) = 'BillTo'">BT</xsl:when>
				<xsl:when test="name($party) = 'ShipTo'">ST</xsl:when>
				<xsl:when test="name($party) = 'TermsOfDelivery'">DA</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<G_N1>
			<S_N1>
				<D_98_1>
					<xsl:value-of select="$role"/>
				</D_98_1>
				<D_93>
					<xsl:choose>
						<xsl:when test="$party/Address/Name != ''">
							<xsl:value-of select="substring($party/Address/Name, 1, 60)"/>
						</xsl:when>
						<xsl:otherwise>Not Available</xsl:otherwise>
					</xsl:choose>
				</D_93>
				<xsl:variable name="addrDomain" select="$party/Address/@addressIDDomain"/>
				<!-- CG -->
				<xsl:if test="string-length($party/Address/@addressID) &gt; 1">
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
						<xsl:value-of select="substring($party/Address/@addressID, 1, 80)"/>
					</D_67>
				</xsl:if>
			</S_N1>
			<xsl:call-template name="createN2N3N4_FromAddress_CopyShip">
				<xsl:with-param name="address" select="$party/Address/PostalAddress"/>
			</xsl:call-template>
			<xsl:for-each select="$party/IdReference">
				<xsl:variable name="domain" select="./@domain"/>
				<xsl:if test="normalize-space(./@identifier) != ''">
					<xsl:choose>
						<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:when>
						<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code != ''">
							<S_REF>
								<D_128>
									<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code"/>
								</D_128>
								<D_352>
									<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:when>
						<xsl:otherwise>
							<S_REF>
								<D_128>ZZ</D_128>
								<D_127>
									<xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
								</D_127>
								<D_352>
									<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
								</D_352>
							</S_REF>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="$role = 'BT' and $party/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID'] != ''">
				<S_REF>
					<D_128>
						<xsl:text>VX</xsl:text>
					</D_128>
					<D_352>
						<xsl:value-of select="substring(normalize-space($party/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID']), 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:if test="$role = 'SU' and $party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID'] != ''">
				<S_REF>
					<D_128>
						<xsl:text>VX</xsl:text>
					</D_128>
					<D_352>
						<xsl:value-of select="substring(normalize-space($party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']), 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<!-- IG-1958 -->
			<!--xsl:if test="exists($party/ancestor::OrderRequestHeader) and ($party/Address/PostalAddress/@name!='')"-->
			<xsl:if test="$isOrder = 'true' and normalize-space($party/Address/PostalAddress/@name) != ''">
				<S_REF>
					<D_128>
						<xsl:text>ME</xsl:text>
					</D_128>
					<D_352>
						<xsl:value-of select="substring(normalize-space($party/Address/PostalAddress/@name), 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:call-template name="createCom_CopyShip">
				<xsl:with-param name="party" select="$party"/>
			</xsl:call-template>
			<xsl:if test="name($party) = 'ShipTo'">
				<xsl:choose>
					<xsl:when test="$mapFOB = 'true'">
						<!-- TermsOfDelivery -->
						<xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value != ''">
							<xsl:variable name="TOD" select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
							<S_FOB>
								<D_146>
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code != ''">
											<xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code"/>
										</xsl:when>
										<xsl:otherwise>DF</xsl:otherwise>
									</xsl:choose>
								</D_146>
								<xsl:if test="exists(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms)">
									<xsl:variable name="TTVal" select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value"/>
									<D_334>01</D_334>
									<D_335>
										<xsl:choose>
											<xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code != ''">
												<xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code"/>
											</xsl:when>
											<xsl:otherwise>ZZZ</xsl:otherwise>
										</xsl:choose>
									</D_335>
								</xsl:if>
							</S_FOB>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="$party/TransportInformation">
							<xsl:if test="position() &lt; 13">
								<xsl:if test="ShippingContractNumber != '' or Route/@method != ''">
									<S_TD5>
										<D_133>Z</D_133>
										<D_66>ZZ</D_66>
										<xsl:if test="ShippingContractNumber != ''">
											<D_67>
												<xsl:value-of select="ShippingContractNumber"/>
											</D_67>
										</xsl:if>
										<xsl:if test="Route/@method != ''">
											<D_91>
												<xsl:choose>
													<xsl:when test="Route/@method = 'air'">A</xsl:when>
													<xsl:when test="Route/@method = 'motor'">J</xsl:when>
													<xsl:when test="Route/@method = 'rail'">R</xsl:when>
													<xsl:when test="Route/@method = 'ship'">S</xsl:when>
												</xsl:choose>
											</D_91>
										</xsl:if>
										<xsl:if test="normalize-space(ShippingInstructions/Description) != ''">
											<D_387>
												<xsl:value-of select="substring(normalize-space(ShippingInstructions/Description), 1, 35)"/>
											</D_387>
										</xsl:if>
									</S_TD5>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="$party/CarrierIdentifier">
							<xsl:if test="position() &lt; 6">
								<S_TD4>
									<D_152>ZZZ</D_152>
									<D_352>
										<xsl:value-of select="concat(., '@domain', ./@domain)"/>
									</D_352>
								</S_TD4>
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</G_N1>
	</xsl:template>
	<xsl:template name="createContact_CopyShip">
		<xsl:param name="party"/>
		<xsl:param name="sprole"/>
		<xsl:param name="isOrder"/>
		<xsl:variable name="role">
			<xsl:choose>
				<xsl:when test="$sprole = 'yes' and $party/@role = 'locationTo'">ST</xsl:when>
				<xsl:when test="$sprole = 'yes' and $party/@role = 'locationFrom'">SU</xsl:when>
				<xsl:when test="$sprole = 'yes' and $party/@role = 'BuyerPlannerCode'">MI</xsl:when>
				<xsl:when test="$sprole = 'QN' and $party/@role = 'buyerParty'">BY</xsl:when>
				<xsl:when test="$sprole = 'QN' and $party/@role = 'sellerParty'">SU</xsl:when>
				<xsl:when test="$sprole = 'QN' and $party/@role = 'senderParty'">FR</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code != ''">
							<xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code"/>
						</xsl:when>
						<xsl:otherwise>ZZ</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<G_N1>
			<S_N1>
				<D_98_1>
					<xsl:value-of select="$role"/>
				</D_98_1>
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
			<!-- DeliverTO logic changed -->
			<xsl:variable name="delTo">
				<DeliverToList>
					<xsl:for-each select="$party/PostalAddress/DeliverTo">
						<xsl:if test="normalize-space(.) != ''">
							<DeliverToItem>
								<xsl:value-of select="substring(normalize-space(.), 0, 60)"/>
							</DeliverToItem>
						</xsl:if>
					</xsl:for-each>
				</DeliverToList>
			</xsl:variable>
			<xsl:variable name="delToCount" select="count($delTo/DeliverToList/DeliverToItem)"/>
			<xsl:choose>
				<xsl:when test="$delToCount = 1">
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount = 2">
					<S_N2>
						<D_93_1>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93_1>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount = 3">
					<S_N2>
						<D_93_1>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93_1>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
					<S_N2>
						<D_93_1>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
						</D_93_1>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount &gt; 3">
					<S_N2>
						<D_93_1>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93_1>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
					<S_N2>
						<D_93_1>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
						</D_93_1>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[4]"/>
						</D_93_2>
					</S_N2>
				</xsl:when>
			</xsl:choose>
			<!-- Street logic changed -->
			<xsl:variable name="street">
				<StreetList>
					<xsl:for-each select="$party/PostalAddress/Street">
						<xsl:if test="normalize-space(.) != ''">
							<StreetItem>
								<xsl:value-of select="substring(normalize-space(.), 0, 55)"/>
							</StreetItem>
						</xsl:if>
					</xsl:for-each>
				</StreetList>
			</xsl:variable>
			<xsl:variable name="streetCount" select="count($street/StreetList/StreetItem)"/>
			<xsl:choose>
				<xsl:when test="$streetCount = 1">
					<S_N3>
						<D_166_1>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166_1>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount = 2">
					<S_N3>
						<D_166_1>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166_1>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount = 3">
					<S_N3>
						<D_166_1>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166_1>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
					<S_N3>
						<D_166_1>
							<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
						</D_166_1>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount &gt; 3">
					<S_N3>
						<D_166_1>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166_1>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
					<S_N3>
						<D_166_1>
							<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
						</D_166_1>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[4]"/>
						</D_166_2>
					</S_N3>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="normalize-space($party/PostalAddress/City) != '' or normalize-space($party/PostalAddress/State) != '' or normalize-space($party/PostalAddress/PostalCode) != '' or normalize-space($party/PostalAddress/Country/@isoCountryCode) != ''">
				<S_N4>
					<xsl:if test="string-length(normalize-space($party/PostalAddress/City)) &gt; 1">
						<D_19>
							<xsl:value-of select="substring(normalize-space($party/PostalAddress/City), 1, 30)"/>
						</D_19>
					</xsl:if>
					<xsl:variable name="uscaStateCode">
						<xsl:if test="($party/PostalAddress/Country/@isoCountryCode = 'US' or $party/PostalAddress/Country/@isoCountryCode = 'CA') and normalize-space($party/PostalAddress/State) != ''">
							<xsl:variable name="stCode" select="normalize-space($party/PostalAddress/State)"/>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode != ''">
									<xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode"/>
								</xsl:when>
								<xsl:when test="string-length($stCode) = 2">
									<xsl:value-of select="upper-case($stCode)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="$uscaStateCode != ''">
						<D_156>
							<xsl:value-of select="$uscaStateCode"/>
						</D_156>
					</xsl:if>
					<xsl:if test="string-length(normalize-space($party/PostalAddress/PostalCode)) &gt; 2">
						<D_116>
							<xsl:value-of select="substring(normalize-space($party/PostalAddress/PostalCode), 1, 15)"/>
						</D_116>
					</xsl:if>
					<xsl:if test="$party/PostalAddress/Country/@isoCountryCode != ''">
						<D_26>
							<xsl:value-of select="$party/PostalAddress/Country/@isoCountryCode"/>
						</D_26>
					</xsl:if>
					<xsl:if test="$uscaStateCode = '' and normalize-space($party/PostalAddress/State) != ''">
						<D_309>SP</D_309>
						<D_310>
							<xsl:value-of select="normalize-space($party/PostalAddress/State)"/>
						</D_310>
					</xsl:if>
				</S_N4>
			</xsl:if>
			<xsl:for-each select="$party/IdReference">
				<xsl:variable name="domain" select="./@domain"/>
				<xsl:choose>
					<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code != ''">
						<S_REF>
							<D_128>
								<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code"/>
							</D_128>
							<D_352>
								<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
							</D_352>
						</S_REF>
					</xsl:when>
					<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code != ''">
						<S_REF>
							<D_128>
								<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code"/>
							</D_128>
							<D_352>
								<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
							</D_352>
						</S_REF>
					</xsl:when>
					<xsl:otherwise>
						<S_REF>
							<D_128>ZZ</D_128>
							<D_127>
								<xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
							</D_127>
							<D_352>
								<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
							</D_352>
						</S_REF>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<!-- IG-1958 -->
			<xsl:if test="$isOrder = 'true' and normalize-space($party/PostalAddress/@name) != ''">
				<S_REF>
					<D_128>
						<xsl:text>ME</xsl:text>
					</D_128>
					<D_352>
						<xsl:value-of select="substring(normalize-space($party/PostalAddress/@name), 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<!-- IG-1960 -->
			<xsl:if test="$role = 'SU' and $party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID'] != ''">
				<S_REF>
					<D_128>
						<xsl:text>VX</xsl:text>
					</D_128>
					<D_352>
						<xsl:value-of select="substring(normalize-space($party/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']), 1, 80)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:call-template name="createCom_CopyShip">
				<xsl:with-param name="party" select="$party"/>
			</xsl:call-template>
		</G_N1>
	</xsl:template>
	<xsl:template match="Email">
		<xsl:if test=". != ''">
			<Con>
				<xsl:attribute name="type">EM</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template match="URL">
		<xsl:if test=". != ''">
			<Con>
				<xsl:attribute name="type">UR</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="substring(normalize-space(.), 1, 80)"/>
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Fax">
		<xsl:if test=". != ''">
			<Con>
				<xsl:attribute name="type">FX</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
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
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Phone">
		<xsl:if test=". != ''">
			<Con>
				<xsl:attribute name="type">TE</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
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
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template name="createCom_CopyShip">
		<xsl:param name="party"/>
		<xsl:variable name="contactType">
			<xsl:value-of select="name($party)"/>
		</xsl:variable>
		<xsl:variable name="contactList">
			<xsl:apply-templates select="$party//Email"/>
			<xsl:apply-templates select="$party//Phone"/>
			<xsl:apply-templates select="$party//Fax"/>
			<xsl:apply-templates select="$party//URL"/>
		</xsl:variable>
		<xsl:for-each-group select="$contactList/Con" group-by="./@name">
			<xsl:sort select="@name"/>
			<xsl:variable name="PER02" select="current-grouping-key()"/>
			<xsl:for-each-group select="current-group()" group-by="(position() - 1) idiv 3">
				<xsl:element name="S_PER">
					<D_366>
						<xsl:choose>
							<xsl:when test="$contactType = 'BillTo'">AP</xsl:when>
							<xsl:when test="$contactType = 'ShipTo'">RE</xsl:when>
							<xsl:otherwise>CN</xsl:otherwise>
						</xsl:choose>
					</D_366>
					<D_93>
						<xsl:value-of select="$PER02"/>
					</D_93>
					<xsl:for-each select="current-group()">
						<xsl:choose>
							<xsl:when test="(position() mod 4) = 1">
								<xsl:element name="D_365_1">
									<xsl:value-of select="./@type"/>
								</xsl:element>
								<xsl:element name="D_364_1">
									<xsl:value-of select="."/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="{concat('D_365_', position() mod 4)}">
									<xsl:value-of select="./@type"/>
								</xsl:element>
								<xsl:element name="{concat('D_364_', position() mod 4)}">
									<xsl:value-of select="."/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template name="createN2N3N4_FromAddress_CopyShip">
		<xsl:param name="address"/>
		<xsl:variable name="delTo">
			<DeliverToList>
				<xsl:for-each select="$address/DeliverTo">
					<xsl:if test="normalize-space(.) != ''">
						<DeliverToItem>
							<xsl:value-of select="substring(normalize-space(.), 0, 60)"/>
						</DeliverToItem>
					</xsl:if>
				</xsl:for-each>
			</DeliverToList>
		</xsl:variable>
		<xsl:variable name="delToCount" select="count($delTo/DeliverToList/DeliverToItem)"/>
		<xsl:choose>
			<xsl:when test="$delToCount = 1">
				<S_N2>
					<D_93_1>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
					</D_93_1>
				</S_N2>
			</xsl:when>
			<xsl:when test="$delToCount = 2">
				<S_N2>
					<D_93_1>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
					</D_93_1>
					<D_93_2>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
					</D_93_2>
				</S_N2>
			</xsl:when>
			<xsl:when test="$delToCount = 3">
				<S_N2>
					<D_93_1>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
					</D_93_1>
					<D_93_2>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
					</D_93_2>
				</S_N2>
				<S_N2>
					<D_93_1>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
					</D_93_1>
				</S_N2>
			</xsl:when>
			<xsl:when test="$delToCount &gt; 3">
				<S_N2>
					<D_93_1>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
					</D_93_1>
					<D_93_2>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
					</D_93_2>
				</S_N2>
				<S_N2>
					<D_93_1>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
					</D_93_1>
					<D_93_2>
						<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[4]"/>
					</D_93_2>
				</S_N2>
			</xsl:when>
		</xsl:choose>
		<!-- Street logic changed -->
		<xsl:variable name="street">
			<StreetList>
				<xsl:for-each select="$address/Street">
					<xsl:if test="normalize-space(.) != ''">
						<StreetItem>
							<xsl:value-of select="substring(normalize-space(.), 0, 55)"/>
						</StreetItem>
					</xsl:if>
				</xsl:for-each>
			</StreetList>
		</xsl:variable>
		<xsl:variable name="streetCount" select="count($street/StreetList/StreetItem)"/>
		<xsl:choose>
			<xsl:when test="$streetCount = 1">
				<S_N3>
					<D_166_1>
						<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
					</D_166_1>
				</S_N3>
			</xsl:when>
			<xsl:when test="$streetCount = 2">
				<S_N3>
					<D_166_1>
						<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
					</D_166_1>
					<D_166_2>
						<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
					</D_166_2>
				</S_N3>
			</xsl:when>
			<xsl:when test="$streetCount = 3">
				<S_N3>
					<D_166_1>
						<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
					</D_166_1>
					<D_166_2>
						<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
					</D_166_2>
				</S_N3>
				<S_N3>
					<D_166_1>
						<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
					</D_166_1>
				</S_N3>
			</xsl:when>
			<xsl:when test="$streetCount &gt; 3">
				<S_N3>
					<D_166_1>
						<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
					</D_166_1>
					<D_166_2>
						<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
					</D_166_2>
				</S_N3>
				<S_N3>
					<D_166_1>
						<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
					</D_166_1>
					<D_166_2>
						<xsl:value-of select="$street/StreetList/StreetItem[4]"/>
					</D_166_2>
				</S_N3>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="normalize-space($address/City) != '' or normalize-space($address/State) != '' or normalize-space($address/PostalCode) != '' or $address/Country/@isoCountryCode != ''">
			<S_N4>
				<xsl:if test="string-length(normalize-space($address/City)) &gt; 1">
					<D_19>
						<xsl:value-of select="substring(normalize-space($address/City), 1, 30)"/>
					</D_19>
				</xsl:if>
				<!--xsl:if test="$address/State != ''">					<xsl:variable name="stateCode" select="$address/State"/>					<D_156>						<xsl:choose>							<xsl:when test="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode != ''">								<xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode"/>							</xsl:when>							<xsl:when test="string-length($stateCode) = 2">								<xsl:value-of select="upper-case($stateCode)"/>							</xsl:when>							<xsl:otherwise>ZZ</xsl:otherwise>						</xsl:choose>					</D_156>				</xsl:if-->
				<xsl:variable name="uscaStateCode">
					<xsl:if test="($address/Country/@isoCountryCode = 'US' or $address/Country/@isoCountryCode = 'CA') and normalize-space($address/State) != ''">
						<xsl:variable name="stCode" select="normalize-space($address/State)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode != ''">
								<xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode"/>
							</xsl:when>
							<xsl:when test="string-length($stCode) = 2">
								<xsl:value-of select="upper-case($stCode)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="$uscaStateCode != ''">
					<D_156>
						<xsl:value-of select="$uscaStateCode"/>
					</D_156>
				</xsl:if>
				<xsl:if test="string-length(normalize-space($address/PostalCode)) &gt; 2">
					<D_116>
						<xsl:value-of select="substring(normalize-space($address/PostalCode), 1, 15)"/>
					</D_116>
				</xsl:if>
				<xsl:if test="$address/Country/@isoCountryCode != ''">
					<D_26>
						<xsl:value-of select="$address/Country/@isoCountryCode"/>
					</D_26>
				</xsl:if>
				<xsl:if test="$uscaStateCode = '' and normalize-space($address/State) != ''">
					<D_309>SP</D_309>
					<D_310>
						<xsl:value-of select="normalize-space($address/State)"/>
					</D_310>
				</xsl:if>
			</S_N4>
		</xsl:if>
	</xsl:template>
	<xsl:template name="createMEA_FromDimension_CopyShip">
		<xsl:param name="dimension"/>
		<xsl:param name="meaQual"/>
		<xsl:variable name="dType" select="$dimension/@type"/>
		<xsl:if test="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dType]/X12Code != ''">
			<S_MEA>
				<xsl:variable name="uom" select="$dimension/UnitOfMeasure"/>
				<D_737>
					<xsl:value-of select="$meaQual"/>
				</D_737>
				<D_738>
					<xsl:value-of select="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dType]/X12Code"/>
				</D_738>
				<D_739>
					<xsl:call-template name="formatQty">
						<xsl:with-param name="qty" select="$dimension/@quantity"/>
					</xsl:call-template>
					<!--xsl:value-of select="format-number(@quantity,'0.##')"/-->
				</D_739>
				<C_C001>
					<D_355_1>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
								<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
							</xsl:when>
							<xsl:otherwise>ZZ</xsl:otherwise>
						</xsl:choose>
					</D_355_1>
				</C_C001>
			</S_MEA>
		</xsl:if>
	</xsl:template>
	<xsl:template name="adjustDTM">
		<xsl:param name="cXMLDate"/>
		<xsl:variable name="date" select="replace(substring($cXMLDate, 0, 11), '-', '')"/>
		<xsl:variable name="time" select="replace(substring($cXMLDate, 12, 8), ':', '')"/>
		<xsl:variable name="timeZone" select="replace(replace(substring($cXMLDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
		<xsl:variable name="timeZoneX12">
			<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
		</xsl:variable>
		<xsl:value-of select="concat($date, $time, $timeZoneX12)"/>
	</xsl:template>
	<xsl:template name="REFLoop">
		<xsl:param name="Desc"/>
		<xsl:param name="StrLen"/>
		<xsl:param name="Pos"/>
		<xsl:param name="CurrentEndPos"/>
		<xsl:param name="UniqueId"/>
		<xsl:param name="cLang"/>
		<xsl:param name="cType"/>
		<xsl:variable name="Length" select="$Pos + 80"/>

		<S_REF>
			<D_128>L1</D_128>
			<D_127>
				<xsl:value-of select="$UniqueId"/>
			</D_127>
			<D_352>
				<xsl:value-of select="substring($Desc, $Pos, 80)"/>
			</D_352>
			<C_C040>
				<D_128_1>L1</D_128_1>
				<D_127_1>
					<xsl:choose>
						<xsl:when test="$cLang != ''">
							<xsl:value-of select="$cLang"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'EN'"/>
						</xsl:otherwise>
					</xsl:choose>
				</D_127_1>
				<xsl:if test="$cType != ''">
					<D_128_2>0L</D_128_2>
					<D_127_2>
						<xsl:value-of select="substring($cType, 1, 30)"/>
					</D_127_2>
				</xsl:if>
				<xsl:if test="string-length($cType) > 30">
					<D_128_3>0L</D_128_3>
					<D_127_3>
						<xsl:value-of select="substring($cType, 31, 30)"/>
					</D_127_3>
				</xsl:if>
			</C_C040>
		</S_REF>
		<xsl:if test="$Length &lt; $StrLen">
			<xsl:call-template name="REFLoop">
				<xsl:with-param name="Desc" select="$Desc"/>
				<xsl:with-param name="Pos" select="$Length"/>
				<xsl:with-param name="StrLen" select="$StrLen"/>
				<xsl:with-param name="CurrentEndPos" select="$Pos"/>
				<xsl:with-param name="UniqueId" select="$UniqueId"/>
				<xsl:with-param name="cLang" select="$cLang"/>
				<xsl:with-param name="cType" select="$cType"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="mapComments">
		<xsl:if test="exists(@type) or exists(Attachment) or (string-length(./text()[1]) > 80)">
			<xsl:variable name="uniqueIdentifier" select="position()"/>
			<xsl:variable name="comments" select="normalize-space(./text()[1])"/>
			<xsl:variable name="StrLen" select="string-length($comments)"/>

			<xsl:if test="$comments != ''">
				<xsl:call-template name="REFLoop">
					<xsl:with-param name="Pos" select="1"/>
					<xsl:with-param name="CurrentEndPos" select="1"/>
					<xsl:with-param name="Desc" select="$comments"/>
					<xsl:with-param name="StrLen" select="$StrLen"/>
					<xsl:with-param name="UniqueId" select="$uniqueIdentifier"/>
					<xsl:with-param name="cType" select="@type"/>
					<xsl:with-param name="cLang" select="@xml:lang"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:for-each select="Attachment">
				<xsl:variable name="attURL" select="normalize-space(./URL)"/>
				<xsl:if test="$attURL != ''">
					<S_REF>
						<D_128>URL</D_128>
						<D_127>
							<xsl:value-of select="$uniqueIdentifier"/>
						</D_127>
						<D_352>
							<xsl:value-of select="substring($attURL, 1, 80)"/>
						</D_352>
						<xsl:if test="(string-length($attURL) > 80) or ./URL/@name">
							<xsl:variable name="listC040">
								<xsl:if test="normalize-space(./URL/@name)">
									<C040>
										<D128>0L</D128>
										<D127>
											<xsl:value-of select="substring(normalize-space(./URL/@name), 1, 30)"/>
										</D127>
									</C040>
								</xsl:if>
								<xsl:if test="string-length($attURL) > 80">
									<C040>
										<D128>URL</D128>
										<D127>
											<xsl:value-of select="substring(normalize-space($attURL), 81, 30)"/>
										</D127>
									</C040>
								</xsl:if>
								<xsl:if test="string-length($attURL) > 110">
									<C040>
										<D128>URL</D128>
										<D127>
											<xsl:value-of select="substring(normalize-space($attURL), 111, 30)"/>
										</D127>
									</C040>
								</xsl:if>
								<xsl:if test="string-length($attURL) > 140">
									<C040>
										<D128>URL</D128>
										<D127>
											<xsl:value-of select="substring(normalize-space($attURL), 141, 30)"/>
										</D127>
									</C040>
								</xsl:if>
							</xsl:variable>
							<C_C040>
								<xsl:for-each select="$listC040/C040">
									<xsl:element name="{concat('D_128', '_', position())}">
										<xsl:value-of select="D128"/>
									</xsl:element>
									<xsl:element name="{concat('D_127', '_',  position())}">
										<xsl:value-of select="D127"/>
									</xsl:element>
								</xsl:for-each>
							</C_C040>
						</xsl:if>
					</S_REF>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
