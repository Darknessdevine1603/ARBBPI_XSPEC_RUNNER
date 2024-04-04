<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/"
	exclude-result-prefixes="#all" version="2.0">
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
	<xsl:param name="segmentCount"/>
	<xsl:param name="exchange"/>
   <xsl:param name="anCRFlag"/>
	<!-- For local testing -->
	<!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>-->
	
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:830:004010">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>PS</D_479>
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
						<xsl:value-of select="format-dateTime($dateNow, '[H01][m01]')"/>
					</D_337>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
					<D_455>X</D_455>
					<D_480>004010</D_480>
				</S_GS>
				<M_830>
					<S_ST>
						<D_143>830</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BFR>
						<D_353>00</D_353>
						<xsl:if
							test="cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID != ''">
							<D_127>
								<xsl:value-of
									select="substring(cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID, 1, 30)"
								/>
							</D_127>
						</xsl:if>
						<D_675>BB</D_675>
						<D_676>A</D_676>
						<D_373>
							<xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
						</D_373>
						<D_373_2>
							<xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
						</D_373_2>
						<D_373_3>
							<xsl:value-of
								select="replace(substring(cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate, 0, 11), '-', '')"
							/>
						</D_373_3>
					</S_BFR>
					<!-- IG-29025 -->
					<xsl:call-template name="CreateREFListHeader"/>
					<xsl:for-each
						select="cXML/Message/ProductActivityMessage/ProductActivityDetails">
						<G_LIN>
							<xsl:if
								test="normalize-space(ItemID/SupplierPartID) != '' or normalize-space(ItemID/BuyerPartID) != '' or ItemID/SupplierPartAuxiliaryID != ''">
								<S_LIN>
									<xsl:call-template name="createItemParts">
										<xsl:with-param name="itemID" select="ItemID"/>
									</xsl:call-template>
								</S_LIN>
							</xsl:if>
							<xsl:variable name="uomcode">
								<xsl:choose>
									<xsl:when
										test="(TimeSeries/Forecast/ForecastQuantity[@quantity != '0' and @quantity != '0.0']/UnitOfMeasure)[1] != ''">
										<xsl:value-of
											select="(TimeSeries/Forecast/ForecastQuantity[@quantity != '0' and @quantity != '0.0']/UnitOfMeasure)[1]"
										/>
									</xsl:when>
									<!-- IG-31913 -->									
									<xsl:when
										test="(PlanningTimeSeries/TimeSeriesDetails/TimeSeriesQuantity[@quantity != '0' and @quantity != '0.0']/UnitOfMeasure)[1] != ''">
										<xsl:value-of
											select="(PlanningTimeSeries/TimeSeriesDetails/TimeSeriesQuantity[@quantity != '0' and @quantity != '0.0']/UnitOfMeasure)[1]"
										/>
									</xsl:when>
									<xsl:when
										test="(InventoryTimeSeries/InventoryTimeSeriesDetails/TimeSeriesQuantity[@quantity != '0' and @quantity != '0.0']/UnitOfMeasure)[1] != ''">
										<xsl:value-of
											select="(InventoryTimeSeries/InventoryTimeSeriesDetails/TimeSeriesQuantity[@quantity != '0' and @quantity != '0.0']/UnitOfMeasure)[1]"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>ZZ</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<S_UIT>
								<C_C001>
									<D_355>
										<xsl:choose>
											<xsl:when
												test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
												<xsl:value-of
												select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode][1]/X12Code"
												/>
											</xsl:when>
											<xsl:otherwise>ZZ</xsl:otherwise>
										</xsl:choose>
									</D_355>
								</C_C001>
							</S_UIT>
							<xsl:if test="Description != ''">
								<S_PID>
									<D_349>F</D_349>
									<D_352>
										<xsl:value-of select="substring(Description, 0, 79)"/>
									</D_352>
									<D_819>
										<xsl:variable name="lang"
											select="string-length(normalize-space(Description/@xml:lang))"/>
										<xsl:choose>
											<xsl:when test="$lang &gt; 1">
												<xsl:value-of
												select="upper-case(substring(Description/@xml:lang, 1, 2))"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>EN</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</D_819>
								</S_PID>
							</xsl:if>
							<!-- IG - 7599 -->
							<xsl:for-each select="Classification">
								<xsl:variable name="domain">
									<xsl:value-of select="@domain"/>
								</xsl:variable>
								<xsl:if
									test="$Lookup/Lookups/Classifications/Classification[CXMLCode = $domain]/X12Code != ''">
									<S_PID>
										<D_349>S</D_349>
										<D_750>MAC</D_750>
										<D_559>
											<xsl:choose>
												<xsl:when test="@domain = 'UNSPSC'">UN</xsl:when>
												<xsl:otherwise>AS</xsl:otherwise>
											</xsl:choose>
										</D_559>
										<xsl:if test="normalize-space(@code) != ''">
											<D_751>
												<xsl:value-of select="substring(normalize-space(@code), 1, 12)"/>
											</D_751>
										</xsl:if>
										<D_352>
											<xsl:value-of select="."/>
										</D_352>
										<D_822>
											<xsl:value-of
												select="$Lookup/Lookups/Classifications/Classification[CXMLCode = $domain]/X12Code"
											/>
										</D_822>
									</S_PID>
								</xsl:if>
							</xsl:for-each>
							<!-- IG-26488 -->
							<xsl:for-each select="Characteristic">
								<S_PID>
									<D_349>S</D_349>
									<D_750>09</D_750>
									<D_559>ZZ</D_559>
									<D_751>Property</D_751>
									<D_352>
										<xsl:value-of select="substring(normalize-space(./@value), 1, 80)"/>
									</D_352>
									<xsl:if test="normalize-space(./@domain) != ''">
										<D_822>
											<xsl:value-of select="substring(normalize-space(./@domain), 1, 15)"/>
										</D_822>
									</xsl:if>
									</S_PID>
							</xsl:for-each>
							<!-- IG-29025 -->
							<xsl:call-template name="CreateREFListDetail"/>
							<xsl:if test="normalize-space(LeadTime) != ''">
								<S_LDT>
									<D_345>AF</D_345>
									<D_380>
										<xsl:value-of select="normalize-space(LeadTime)"/>
									</D_380>
									<D_344>DA</D_344>
								</S_LDT>
							</xsl:if>
							<xsl:if test="normalize-space(PlannedAcceptanceDays) != ''">
								<S_LDT>
									<D_345>AZ</D_345>
									<D_380>
										<xsl:value-of select="normalize-space(PlannedAcceptanceDays)"/>
									</D_380>
									<D_344>DA</D_344>
								</S_LDT>
							</xsl:if>
							<xsl:for-each select="Contact">
								<xsl:call-template name="createContact">
									<xsl:with-param name="party" select="."/>
									<xsl:with-param name="sprole" select="'yes'"/>
								</xsl:call-template>
							</xsl:for-each>
							<xsl:for-each select="TimeSeries/Forecast">
								<G_FST>
									<S_FST>
										<D_380>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty"
												select="ForecastQuantity/@quantity"/>
											</xsl:call-template>

										</D_380>
										<D_680>D</D_680>
										<D_681>
											<xsl:text>F</xsl:text>
										</D_681>
										<!-- IG-3803 start -->
										<D_373>
											<xsl:choose>
												<xsl:when test="contains(Period/@startDate, 'T')">
												<xsl:value-of
												select="translate(substring-before(Period/@startDate, 'T'), '-', '')"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="translate(substring(Period/@startDate, 1, 10), '-', '')"
												/>
												</xsl:otherwise>
											</xsl:choose>
										</D_373>
										<xsl:if test="Period/@endDate != ''">
											<D_373_2>
												<xsl:choose>
												<xsl:when test="contains(Period/@endDate, 'T')">
												<xsl:value-of
												select="translate(substring-before(Period/@endDate, 'T'), '-', '')"
												/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="translate(substring(Period/@endDate, 1, 10), '-', '')"
												/>
												</xsl:otherwise>
												</xsl:choose>
											</D_373_2>
										</xsl:if>
										<!-- IG-3803 end -->
										<xsl:if
											test="../@type = 'demand' or ../@type = 'orderForecast'">
											<D_128>13</D_128>
											<D_127>
												<xsl:value-of select="../@type"/>
											</D_127>
										</xsl:if>
									</S_FST>
								</G_FST>
							</xsl:for-each>
							<xsl:for-each select="PlanningTimeSeries/TimeSeriesDetails">
								<G_FST>
									<S_FST>
										<D_380>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty"
												select="TimeSeriesQuantity/@quantity"/>
											</xsl:call-template>

										</D_380>
										<D_680>D</D_680>
										<D_681>
											<xsl:text>F</xsl:text>
										</D_681>
										<D_373>
											<xsl:choose>
												<xsl:when test="contains(Period/@startDate, 'T')">
													<xsl:value-of
														select="translate(substring-before(Period/@startDate, 'T'), '-', '')"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of
														select="translate(substring(Period/@startDate, 1, 10), '-', '')"
													/>
												</xsl:otherwise>
											</xsl:choose>											
										</D_373>
										<xsl:if test="Period/@endDate != ''">
											<D_373_2>
												<xsl:choose>
													<xsl:when test="contains(Period/@endDate, 'T')">
														<xsl:value-of
															select="translate(substring-before(Period/@endDate, 'T'), '-', '')"
														/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of
															select="translate(substring(Period/@endDate, 1, 10), '-', '')"
														/>
													</xsl:otherwise>
												</xsl:choose>												
											</D_373_2>
										</xsl:if>
										<xsl:if test="../@type != ''">
											<D_128>18</D_128>
											<D_127>
												<xsl:choose>
												<xsl:when
												test="../@type = 'custom' and ../@customType != ''">
												<xsl:value-of select="../@customType"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="../@type"/>
												</xsl:otherwise>
												</xsl:choose>

											</D_127>
										</xsl:if>
									</S_FST>
								</G_FST>
							</xsl:for-each>
							<xsl:for-each select="InventoryTimeSeries/TimeSeriesDetails">
								<G_FST>
									<S_FST>
										<D_380>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty"
												select="TimeSeriesQuantity/@quantity"/>
											</xsl:call-template>

										</D_380>
										<D_680>D</D_680>
										<D_681>
											<xsl:text>F</xsl:text>
										</D_681>
										<D_373>
											<xsl:value-of
												select="translate(substring-before(Period/@startDate, 'T'), '-', '')"
											/>
										</D_373>
										<xsl:if test="Period/@endDate != ''">
											<D_373_2>
												<xsl:value-of
												select="translate(substring-before(Period/@endDate, 'T'), '-', '')"
												/>
											</D_373_2>
										</xsl:if>
										<xsl:if test="../@type = 'projectedStock'">
											<D_128>S6</D_128>
											<D_127>
												<xsl:value-of select="../@type"/>
											</D_127>
										</xsl:if>
									</S_FST>
								</G_FST>
							</xsl:for-each>
						</G_LIN>
					</xsl:for-each>
					<S_CTT>
						<D_354>
							<xsl:value-of
								select="count(/cXML/Message/ProductActivityMessage/ProductActivityDetails)"
							/>
						</D_354>
					</S_CTT>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_830>
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
	<!-- IG-29025 -->
	<xsl:template name="CreateREFListHeader">
		<xsl:variable name="REFList">
			<REFList>
				<xsl:if test="cXML/Header/From/Credential[@domain = 'SystemID']/Identity != ''">
					<S_REF>
						<D_128>06</D_128>
						<D_127>
							<xsl:value-of
								select="cXML/Header/From/Credential[@domain = 'SystemID']/Identity"
							/>
						</D_127>
					</S_REF>
				</xsl:if>
				<xsl:if test="$anCRFlag = 'Yes'">
					<S_REF>
						<D_128><xsl:text>J0</xsl:text></D_128>
						<D_127><xsl:text>copy</xsl:text></D_127>
					</S_REF>
				</xsl:if>
				<xsl:for-each select="cXML/Message/ProductActivityMessage/Extrinsic">
					<S_REF>
						<D_128>ZZ</D_128>
						<D_127>
							<xsl:value-of select="substring(normalize-space(@name), 1, 30)"/>
						</D_127>
						<D_352>
							<xsl:value-of select="substring(normalize-space(./text()), 1, 80)"/>
						</D_352>
					</S_REF>
				</xsl:for-each>
			</REFList>
		</xsl:variable>
		<xsl:for-each select="$REFList/REFList/child::*[position() &lt;13]">
			<xsl:copy-of select="."></xsl:copy-of>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="CreateREFListDetail">
		<xsl:variable name="REFList">
			<REFList>
				<xsl:if test="@status != ''">
					<S_REF>
						<D_128>ACC</D_128>
						<D_127>
							<xsl:value-of select="@status"/>
						</D_127>
					</S_REF>
				</xsl:if>
				<xsl:for-each select="Extrinsic">
					<S_REF>
						<D_128>ZZ</D_128>
						<D_127>
							<xsl:value-of select="substring(normalize-space(@name), 1, 30)"/>
						</D_127>
						<D_352>
							<xsl:value-of select="substring(normalize-space(./text()), 1, 80)"/>
						</D_352>
					</S_REF>
				</xsl:for-each>
			</REFList>
		</xsl:variable>
		<xsl:for-each select="$REFList/REFList/child::*[position() &lt;13]">
			<xsl:copy-of select="."></xsl:copy-of>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
