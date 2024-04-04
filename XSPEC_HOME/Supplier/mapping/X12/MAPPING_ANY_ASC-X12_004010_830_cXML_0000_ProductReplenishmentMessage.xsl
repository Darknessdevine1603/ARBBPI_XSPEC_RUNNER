<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:830:004010" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="output"/>
	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<!--<xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>-->
	<xsl:template match="*">
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:call-template name="convertToAribaDate">
					<xsl:with-param name="Date">
						<xsl:value-of select="substring(replace(string(current-dateTime()), '-', ''), 1, 8)"/>
					</xsl:with-param>
					<xsl:with-param name="Time">
						<xsl:value-of select="substring(replace(replace(string(current-dateTime()), '-', ''), ':', ''), 10, 6)"/>
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
					
					<!--IG-29930-->
					<xsl:if test="FunctionalGroup/M_830/S_REF[D_128 = 'VR']/D_127">
						<Credential domain="VendorID">
							<Identity>
								<xsl:value-of select="FunctionalGroup/M_830/S_REF[D_128 = 'VR']/D_127"/>
							</Identity>
						</Credential>
					</xsl:if>
				</From>
				<To>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anBuyerANID"/>
						</Identity>
					</Credential>
					
					<!-- IG-29930 -->
					<xsl:if test="FunctionalGroup/M_830/S_REF[D_128 = '06']/D_127">
						<Credential domain="SystemID">
							<Identity>
								<xsl:value-of select="FunctionalGroup/M_830/S_REF[D_128 = '06']/D_127"/>
							</Identity>
						</Credential>
					</xsl:if>
					<xsl:if test="FunctionalGroup/M_830/S_REF[D_128 = '44']/D_127">
						<Credential domain="EndPointID">
							<Identity>
								<xsl:value-of select="FunctionalGroup/M_830/S_REF[D_128 = '44']/D_127"/>
							</Identity>
						</Credential>
					</xsl:if>
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
					<xsl:when test="$anEnvName = 'PROD'">
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
								<xsl:with-param name="Date" select="FunctionalGroup/M_830/S_BFR/D_373_3"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:attribute name="messageID">
							<xsl:value-of select="FunctionalGroup/M_830/S_BFR/D_127"/>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="(FunctionalGroup/M_830/G_LIN/G_FST/S_FST[D_680 = 'C' and D_128 = 'REC' and D_127 = 'plannedReceipt'])[1]">
								<xsl:attribute name="processType">SMI</xsl:attribute>
							</xsl:when>
							<xsl:when test="(FunctionalGroup/M_830/G_LIN/G_FST/S_FST[D_680 = 'C' and D_128 = 'REC' and D_127 = 'projectedStock'])[1]">
								<xsl:attribute name="processType">SMI</xsl:attribute>
							</xsl:when>
							<xsl:when test="FunctionalGroup/M_830/S_REF[D_128 = 'PHC']">
								<xsl:attribute name="processType">
									<xsl:value-of select="FunctionalGroup/M_830/S_REF[D_128 = 'PHC']/D_127"/>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</ProductReplenishmentHeader>
					<xsl:for-each select="FunctionalGroup/M_830/G_LIN">
						<xsl:variable name="lin">
							<xsl:call-template name="createLIN">
								<xsl:with-param name="LIN" select="S_LIN"/>
							</xsl:call-template>
						</xsl:variable>
						<ProductReplenishmentDetails>
							<ItemID>
									<SupplierPartID>
										<xsl:value-of select="$lin/lin/element[@name = 'VP']/@value"/>
									</SupplierPartID>
								<xsl:if test="$lin/lin/element[@name = 'VS']/@value != ''">
									<SupplierPartAuxiliaryID>
										<xsl:value-of select="$lin/lin/element[@name = 'VS']/@value"/>
									</SupplierPartAuxiliaryID>
								</xsl:if>
								<xsl:if test="$lin/lin/element[@name = 'BP']/@value != ''">
									<BuyerPartID>
										<xsl:value-of select="$lin/lin/element[@name = 'BP']/@value"/>
									</BuyerPartID>
								</xsl:if>
							</ItemID>
							<xsl:if test="S_PID/D_349 = 'F'">
								<Description>
									<xsl:attribute name="xml:lang">
										<xsl:value-of select="S_PID/D_819"/>
									</xsl:attribute>
									<xsl:value-of select="S_PID/D_352"/>
								</Description>
							</xsl:if>
							<xsl:for-each select="S_PID[D_349 = 'S'][D_751 = 'Property']">
								<xsl:if test="D_352 != '' or D_822 != ''"></xsl:if>
								<Characteristic>
									<xsl:if test="D_352 != ''">
										<xsl:attribute name="value">
											<xsl:value-of select="D_352"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="D_822 != ''">
										<xsl:attribute name="domain">
											<xsl:value-of select="D_822"/>
										</xsl:attribute>
									</xsl:if>
								</Characteristic>
							</xsl:for-each>
							<xsl:for-each select="G_N1">
								<xsl:call-template name="createContact">
									<xsl:with-param name="contact" select="."/>
								</xsl:call-template>
							</xsl:for-each>
							<xsl:variable name="listQTY">
								<xsl:for-each select="S_QTY[C_C001/D_1018 = '1' or C_C001/D_1018 = '2' or not(exists(C_C001/D_1018))]">
									<xsl:choose>
										<xsl:when test="D_673 = '3Y'">
											<Qty>
												<xsl:attribute name="type">SubcontractingStockInTransferQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">1</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '33'">
											<Qty>
												<xsl:attribute name="type">UnrestrictedUseQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">2</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = 'QH'">
											<Qty>
												<xsl:attribute name="type">BlockedQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">3</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = 'XT'">
											<Qty>
												<xsl:attribute name="type">QualityInspectionQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">4</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '77'">
											<Qty>
												<xsl:attribute name="type">StockInTransferQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">5</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '69'">
											<Qty>
												<xsl:attribute name="type">IncrementQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">6</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '72'">
											<Qty>
												<xsl:attribute name="type">RequiredMinimumQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">7</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '73'">
											<Qty>
												<xsl:attribute name="type">RequiredMaximumQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">8</xsl:attribute>
											</Qty>
										</xsl:when>

										<xsl:when test="D_673 = 'XU' and C_C001/D_1018 = '1'">
											<Qty>
												<xsl:attribute name="type">PromotionQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">9</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = 'XU' and C_C001/D_1018 = '2'">
											<Qty>
												<xsl:attribute name="type">QualityInspectionQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="C_C001/D_1018"/>
												</xsl:attribute>
												<xsl:attribute name="pos">10</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '17'">
											<Qty>
												<xsl:attribute name="type">StockOnHandQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="1"/>
												</xsl:attribute>
												<xsl:attribute name="pos">11</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '37'">
											<Qty>
												<xsl:attribute name="type">WorkInProcessQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="1"/>
												</xsl:attribute>
												<xsl:attribute name="pos">12</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = 'IQ'">
											<Qty>
												<xsl:attribute name="type">IntransitQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="1"/>
												</xsl:attribute>
												<xsl:attribute name="pos">13</xsl:attribute>
											</Qty>
										</xsl:when>
										<xsl:when test="D_673 = '1N'">
											<Qty>
												<xsl:attribute name="type">ScrapQuantity</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="D_380"/>
												</xsl:attribute>
												<xsl:attribute name="uom">
													<xsl:value-of select="C_C001/D_355"/>
												</xsl:attribute>
												<xsl:attribute name="parent">
													<xsl:value-of select="1"/>
												</xsl:attribute>
												<xsl:attribute name="pos">14</xsl:attribute>
											</Qty>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</xsl:variable>
							<xsl:if test="(S_MEA[D_737 = 'TI']/D_738 = 'MI' or S_MEA[D_737 = 'TI']/D_738 = 'MX') or count($listQTY/Qty[@parent = '1']) &gt; 0">
								<Inventory>
									<xsl:for-each select="$listQTY/Qty[@parent = '1']">
										<xsl:sort select="@pos" data-type="number"/>
										<xsl:element name="{@type}">
											<xsl:attribute name="quantity">
												<xsl:value-of select="@value"/>
											</xsl:attribute>
											<xsl:element name="UnitOfMeasure">
												<xsl:choose>
													<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = @uom]/CXMLCode != ''">
														<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = @uom][1]/CXMLCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="@uom"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:element>
										</xsl:element>
									</xsl:for-each>

									<!-- OrderQuantity -->
									<xsl:choose>
										<xsl:when test="S_QTY[D_673 = '57'] or S_QTY[D_673 = '70']">
											<xsl:element name="OrderQuantity">
												<xsl:if test="S_QTY[D_673 = '57']/D_380 != ''">
													<xsl:attribute name="minimum">
														<xsl:value-of select="S_QTY[D_673 = '57']/D_380"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:if test="S_QTY[D_673 = '70']/D_380 != ''">
													<xsl:attribute name="maximum">
														<xsl:value-of select="S_QTY[D_673 = '70']/D_380"/>
													</xsl:attribute>
												</xsl:if>
												<xsl:variable name="uom">
													<xsl:choose>
														<xsl:when test="normalize-space(S_QTY[D_673 = '57']/C_C001/D_355) != ''">
															<xsl:value-of select="S_QTY[D_673 = '57']/C_C001/D_355"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="S_QTY[D_673 = '70']/C_C001/D_355"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:if test="$uom != ''">
													<xsl:element name="UnitOfMeasure">
														<xsl:choose>
															<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
																<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$uom"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:when>

									</xsl:choose>
									<!-- End of OrderQuantity -->
									<xsl:if test="(S_MEA[D_737 = 'TI']/D_738 = 'MI' or S_MEA[D_737 = 'TI']/D_738 = 'MX')">
										<DaysOfSupply>
											<xsl:if test="S_MEA[D_737 = 'TI' and D_738 = 'MI']">
												<xsl:attribute name="minimum">
													<xsl:value-of select="S_MEA[D_737 = 'TI' and D_738 = 'MI']/D_739"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if test="S_MEA[D_737 = 'TI' and D_738 = 'MX']">
												<xsl:attribute name="maximum">
													<xsl:value-of select="S_MEA[D_737 = 'TI' and D_738 = 'MX']/D_739"/>
												</xsl:attribute>
											</xsl:if>
										</DaysOfSupply>
									</xsl:if>
								</Inventory>
							</xsl:if>
							<xsl:if test="count($listQTY/Qty[@parent = '2']) &gt; 0">
								<ConsignmentInventory>
									<xsl:for-each select="$listQTY/Qty[@parent = '2']">
										<xsl:sort select="@pos" data-type="number"/>
										<xsl:element name="{@type}">
											<xsl:attribute name="quantity">
												<xsl:value-of select="@value"/>
											</xsl:attribute>
											<xsl:element name="UnitOfMeasure">
												<xsl:choose>
													<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = @uom]/CXMLCode != ''">
														<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = @uom][1]/CXMLCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="@uom"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:element>
										</xsl:element>
									</xsl:for-each>
									<!--<xsl:if
                                        test="(S_MEA[D_737 = 'TI']/D_738 = 'MI' or S_MEA[D_737 = 'TI']/D_738 = 'MX')">
                                        <DaysOfSupply>
                                            <xsl:if test="S_MEA[D_737 = 'TI' and D_738 = 'MI']">
                                                <xsl:attribute name="minimum">
                                                  <xsl:value-of
                                                  select="S_MEA[D_737 = 'TI' and D_738 = 'MI']/D_739"
                                                  />
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="S_MEA[D_737 = 'TI' and D_738 = 'MX']">
                                                <xsl:attribute name="maximum">
                                                  <xsl:value-of
                                                  select="S_MEA[D_737 = 'TI' and D_738 = 'MX']/D_739"
                                                  />
                                                </xsl:attribute>
                                            </xsl:if>
                                        </DaysOfSupply>
                                    </xsl:if>-->
								</ConsignmentInventory>
							</xsl:if>
							<ReplenishmentTimeSeries>
								<xsl:choose>
									<xsl:when test="G_FST[1]/S_FST/D_680 = 'C'">
										<xsl:attribute name="type">
											<xsl:value-of select="'forecastConfirmation'"/>
										</xsl:attribute>
									</xsl:when>
									<xsl:when test="G_FST[1]/S_FST/D_680 = 'D' and G_FST[1]/S_FST/D_127 != ''">
										<xsl:attribute name="type">
											<xsl:value-of select="G_FST[1]/S_FST/D_127"/>
										</xsl:attribute>
									</xsl:when>
									<xsl:when test="G_FST[1]/S_FST/D_680 = 'D'">
										<xsl:attribute name="type">
											<xsl:value-of select="'supplierForecast'"/>
										</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<xsl:for-each select="G_FST">
									<TimeSeriesDetails>
										<Period>
											<xsl:attribute name="endDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="Date" select="S_FST/D_373_2"/>
												</xsl:call-template>
											</xsl:attribute>
											<xsl:attribute name="startDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="Date" select="S_FST/D_373"/>
												</xsl:call-template>
											</xsl:attribute>
										</Period>
										<TimeSeriesQuantity>
											<xsl:attribute name="quantity">
												<xsl:value-of select="S_FST/D_380"/>
											</xsl:attribute>
											<UnitOfMeasure>
												<xsl:value-of select="../S_UIT/C_C001/D_355"/>
											</UnitOfMeasure>
										</TimeSeriesQuantity>
									</TimeSeriesDetails>
								</xsl:for-each>
							</ReplenishmentTimeSeries>
						</ProductReplenishmentDetails>
					</xsl:for-each>
				</ProductReplenishmentMessage>
			</Message>
		</cXML>
	</xsl:template>
	<xsl:template name="createLIN">
		<xsl:param name="LIN"/>
		<lin>
			<xsl:for-each select="$LIN/*[starts-with(name(), 'D_23')]">
				<xsl:if test="starts-with(name(), 'D_235')">
					<element>
						<xsl:attribute name="name">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"/>
						</xsl:attribute>
					</element>
				</xsl:if>
			</xsl:for-each>
		</lin>
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
			<xsl:when test="D_365 = 'EM'">
				<Con>
					<xsl:attribute name="type">Email</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365 = 'UR'">
				<Con>
					<xsl:attribute name="type">URL</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="normalize-space(D_364)"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365 = 'TE'">
				<Con>
					<xsl:attribute name="type">Phone</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364, '(')">
								<xsl:value-of select="substring-before(D_364, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364, '-')">
								<xsl:value-of select="substring-before(D_364, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364, 'x')"/>
					</xsl:attribute>
				</Con>
			</xsl:when>
			<xsl:when test="D_365 = 'FX'">
				<Con>
					<xsl:attribute name="type">Fax</xsl:attribute>
					<xsl:attribute name="name">
						<xsl:value-of select="$PER02"/>
					</xsl:attribute>
					<xsl:attribute name="cCode">
						<xsl:choose>
							<xsl:when test="contains(D_364, '(')">
								<xsl:value-of select="substring-before(D_364, '(')"/>
							</xsl:when>
							<xsl:when test="contains(D_364, '-')">
								<xsl:value-of select="substring-before(D_364, '-')"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="aCode">
						<xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after(D_364, '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="ext">
						<xsl:value-of select="substring-after(D_364, 'x')"/>
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
						<xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
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
						<xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_2, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_2, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
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
						<xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
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
						<xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
					</xsl:attribute>
					<xsl:attribute name="num">
						<xsl:choose>
							<xsl:when test="contains(D_364_3, 'x')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
							</xsl:when>
							<xsl:when test="contains(D_364_3, 'X')">
								<xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
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
			<xsl:value-of select="$contact/S_N1/D_98"/>
		</xsl:variable>
		<xsl:variable name="getPartyrole">
			<xsl:choose>
				<xsl:when test="$role = 'ST'">locationTo</xsl:when>
				<xsl:when test="$role = 'SU'">locationFrom</xsl:when>
				<xsl:when test="$role = 'Z4'">inventoryOwner</xsl:when>
				<xsl:when test="$role = 'MI'">BuyerPlannerCode</xsl:when>
				<xsl:when test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
					<xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$getPartyrole != ''">
			<xsl:element name="Contact">
				<xsl:attribute name="role">
					<xsl:value-of select="$getPartyrole"/>
				</xsl:attribute>
				<xsl:if test="$contact/S_N1/D_67 != ''">
					<xsl:attribute name="addressID">
						<xsl:value-of select="$contact/S_N1/D_67"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="addrDomain">
					<xsl:choose>
						<xsl:when test="$contact/S_N1/D_66 = '1'">DUNS</xsl:when>
						<xsl:when test="$contact/S_N1/D_66 = '2'">SCAC</xsl:when>
						<xsl:when test="$contact/S_N1/D_66 = '4'">IATA</xsl:when>
						<xsl:when test="$contact/S_N1/D_66 = '29'">buyerLocationID</xsl:when>
						<xsl:when test="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $contact/S_N1/D_66]/CXMLCode) != ''">
							<xsl:value-of select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $contact/S_N1/D_66]/CXMLCode)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$addrDomain != ''">
					<xsl:attribute name="addressIDDomain">
						<xsl:value-of select="$addrDomain"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:element name="Name">
					<xsl:attribute name="xml:lang">en</xsl:attribute>
					<xsl:value-of select="$contact/S_N1/D_93"/>
				</xsl:element>
				<!-- PostalAddress -->
				<xsl:if test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
					<xsl:element name="PostalAddress">
						<xsl:for-each select="$contact/S_N2">
							<xsl:element name="DeliverTo">
								<xsl:value-of select="D_93"/>
							</xsl:element>
							<xsl:if test="D_93_2 != ''">
								<xsl:element name="DeliverTo">
									<xsl:value-of select="D_93_2"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="$contact/S_N3">
							<xsl:element name="Street">
								<xsl:value-of select="D_166"/>
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
							<!--xsl:value-of select="$contact/S_N4/D_156"/-->
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
								<xsl:if test="$contact/S_N4/D_156 != ''">
									<xsl:attribute name="isoStateCode">
										<xsl:value-of select="$sCode"/>
									</xsl:attribute>
								</xsl:if>
								<!--xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCode]/stateName"/-->
								<xsl:choose>
									<xsl:when test="(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA') and $Lookup/Lookups/States/State[stateCode = $sCode]/stateName != '')">
										<xsl:value-of select="$Lookup/Lookups/States/State[stateCode = $sCode]/stateName"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$sCode"/>
									</xsl:otherwise>
								</xsl:choose>
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
							<xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
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
										<xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
											<xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
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
										<xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
											<xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
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
								<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="D_352"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:when>
								<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
									<xsl:element name="IdReference">
										<xsl:attribute name="identifier">
											<xsl:value-of select="D_352"/>
										</xsl:attribute>
										<xsl:attribute name="domain">
											<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"/>
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
					<xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $countryCode]/countryCode"/>
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
		<xsl:param name="Date"/>
		<xsl:param name="Time"/>
		<xsl:param name="TimeCode"/>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
					<xsl:value-of select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"/>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="temDate">
			<xsl:value-of select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"/>
		</xsl:variable>
		<xsl:variable name="tempTime">
			<xsl:choose>
				<xsl:when test="$Time != '' and string-length($Time) = 6">
					<xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"/>
				</xsl:when>
				<xsl:when test="$Time != '' and string-length($Time) = 4">
					<xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
				</xsl:when>
				<xsl:otherwise>T12:00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
	</xsl:template>
</xsl:stylesheet>
