<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output indent="yes" omit-xml-declaration="yes"/>
	<!-- For local testing -->
	<!-- xsl:variable name="Lookup" select="document('../../lookups/EDIFACT_D96A/LOOKUP_UN-EDIFACT_D96A.xml')"/>
		<xsl:include href="FORMAT_cXML_0000_UN-EDIFACT_D96A.xsl"/-->
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
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:delfor:d.96a">
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
				<D_0026>DELFOR</D_0026>
				<xsl:if test="upper-case($anEnvName) = 'TEST'">
					<D_0035>1</D_0035>
				</xsl:if>
			</S_UNB>
			<xsl:element name="M_DELFOR">
				<S_UNH>
					<D_0062>0001</D_0062>
					<C_S009>
						<D_0065>DELFOR</D_0065>
						<D_0052>D</D_0052>
						<D_0054>96A</D_0054>
						<D_0051>UN</D_0051>
					</C_S009>
				</S_UNH>
				<S_BGM>
					<C_C002>
						<D_1001>241</D_1001>
						<!-- <D_1000>Planning Forecast</D_1000>-->
					</C_C002>
					<D_1004>
						<xsl:value-of select="normalize-space(substring(cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID, 1, 35))"/>
					</D_1004>

					<D_1225>9</D_1225>
				</S_BGM>
				<!-- creation Date -->
				<xsl:if test="normalize-space(cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate) != ''">
					<S_DTM>
						<C_C507>
							<D_2005>137</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="normalize-space(cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate)"/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>

				<xsl:if test="normalize-space(cXML/Header/From/Credential[@domain = 'SystemID']/Identity) != ''">
					<G_SG1>
						<S_RFF>
							<C_C506>
								<D_1153>MS</D_1153>
								<D_1154>
									<xsl:value-of select="substring(normalize-space(cXML/Header/From/Credential[@domain = 'SystemID']/Identity), 1, 35)"/>
								</D_1154>
							</C_C506>
						</S_RFF>
					</G_SG1>
				</xsl:if>

				<!-- IG-16869 Change 1 - Map contacts from item, only if 1 item present-->
				<xsl:if test="count(cXML/Message/ProductActivityMessage/ProductActivityDetails) = 1">
					<xsl:for-each select="cXML/Message/ProductActivityMessage/ProductActivityDetails/Contact[@role != 'locationTo']">
						<G_SG2>
							<xsl:call-template name="createNAD">
								<xsl:with-param name="Address" select="."/>
								<xsl:with-param name="role" select="@role"/>
								<xsl:with-param name="doctype" select="'delfor'"/>
							</xsl:call-template>
							<xsl:choose>
								<xsl:when test="@role = 'BuyerPlannerCode'">
									<xsl:if test="IdReference/@domain = 'BuyerPlannerCode'">
										<xsl:call-template name="CTACOMLoop">
											<xsl:with-param name="contact" select="."/>
											<xsl:with-param name="contactType" select="@role"/>
											<xsl:with-param name="isJITorFOR" select="'true'"/>
											<xsl:with-param name="CTACode" select="'PD'"/>
											<xsl:with-param name="ContactDepartmentID">
												<xsl:value-of select="IdReference[@domain = 'BuyerPlannerCode']/@identifier"/>
											</xsl:with-param>
											<xsl:with-param name="ContactPerson">
												<xsl:value-of select="IdReference[@domain = 'BuyerPlannerCode']/Description"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="CTACOMLoop">
										<xsl:with-param name="contact" select="."/>
										<xsl:with-param name="contactType" select="@role"/>
										<xsl:with-param name="isJITorFOR" select="'true'"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</G_SG2>
					</xsl:for-each>
				</xsl:if>

				<S_UNS>
					<D_0081>D</D_0081>
				</S_UNS>

				<!-- ProductActivityDetails -->
				<!-- IG-IG-16869 Change 2 - Group ProductActivityDetails by Contact[locationTo] -->
				<xsl:for-each-group select="cXML/Message/ProductActivityMessage/ProductActivityDetails" group-by="Contact[@role = 'locationTo']/@addressID">
					<G_SG4>
						<xsl:call-template name="createNAD">
							<xsl:with-param name="Address" select="Contact[@role = 'locationTo']"/>
							<xsl:with-param name="role" select="'locationTo'"/>
							<xsl:with-param name="doctype" select="'delfor'"/>
						</xsl:call-template>
						<xsl:if test="Contact[@role = 'locationTo']/IdReference/@domain = 'locationTo'">
							<S_LOC>
								<D_3227>7</D_3227>
								<C_C517>
									<D_3225>
										<xsl:value-of select="Contact[@role = 'locationTo']/IdReference/@identifier"/>
									</D_3225>
								</C_C517>
							</S_LOC>
						</xsl:if>
						<xsl:call-template name="CTACOMLoop">
							<xsl:with-param name="contact" select="Contact[@role = 'locationTo']"/>
							<xsl:with-param name="contactType" select="'locationTo'"/>
							<xsl:with-param name="isJITorFOR" select="'true'"/>
							<xsl:with-param name="level" select="'detail'"/>
						</xsl:call-template>
						<xsl:for-each select="current-group()">
							<G_SG8>
								<S_LIN>
									<xsl:choose>
										<xsl:when test="normalize-space(ItemID/SupplierPartID) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="SupplierPartID" select="ItemID/SupplierPartID"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="IdReference" select="ItemID/IdReference[@domain = 'EAN-13']/@identifier"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="normalize-space(ItemID/BuyerPartID) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="BuyerPartID" select="ItemID/BuyerPartID"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="normalize-space(ManufacturerPartID) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="ManufacturerPartID" select="ManufacturerPartID"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="normalize-space(ItemID/SupplierPartAuxiliaryID) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="SupplierPartAuxiliaryID" select="ItemID/SupplierPartAuxiliaryID"/>
											</xsl:call-template>
										</xsl:when>

										<xsl:when test="normalize-space(ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="IdReference-UPCUniversalProductCode" select="ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="normalize-space(ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="IdReference-europeanWasteCatalogID" select="ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="normalize-space(Classification[@domain = 'UNSPSC']) != ''">
											<xsl:call-template name="createItemParts">
												<xsl:with-param name="Classification" select="Classification[@domain = 'UNSPSC']"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</S_LIN>

								<xsl:if test="normalize-space(ItemID/BuyerPartID) != '' or normalize-space(ManufacturerPartID) != '' or normalize-space(ItemID/SupplierPartAuxiliaryID) != ''">
									<S_PIA>
										<D_4347>5</D_4347>
										<xsl:choose>
											<xsl:when test="normalize-space(ItemID/BuyerPartID) != ''">
												<xsl:call-template name="createItemParts">
													<xsl:with-param name="BuyerPartID" select="ItemID/BuyerPartID"/>
													<xsl:with-param name="ManufacturerPartID" select="normalize-space(ManufacturerPartID)"/>
													<xsl:with-param name="SupplierPartAuxiliaryID" select="ItemID/SupplierPartAuxiliaryID"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="normalize-space(ManufacturerPartID) != ''">
												<xsl:call-template name="createItemParts">
													<xsl:with-param name="ManufacturerPartID" select="ManufacturerPartID"/>
													<xsl:with-param name="SupplierPartAuxiliaryID" select="ItemID/SupplierPartAuxiliaryID"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="normalize-space(ItemID/SupplierPartAuxiliaryID) != ''">
												<xsl:call-template name="createItemParts">
													<xsl:with-param name="SupplierPartAuxiliaryID" select="ItemID/SupplierPartAuxiliaryID"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</S_PIA>
								</xsl:if>

								<xsl:if test="normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier) != '' or normalize-space(Classification[@domain = 'UNSPSC']) != '' or normalize-space(ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier) != '' or normalize-space(ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier) != ''">
									<S_PIA>
										<D_4347>1</D_4347>
										<xsl:choose>
											<xsl:when test="normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier) != ''">
												<xsl:call-template name="createItemParts">
													<xsl:with-param name="IdReference" select="ItemID/IdReference[@domain = 'EAN-13']/@identifier"/>
													<xsl:with-param name="Classification" select="Classification[@domain = 'UNSPSC']"/>
													<xsl:with-param name="IdReference-UPCUniversalProductCode" select="ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier"/>
													<xsl:with-param name="IdReference-europeanWasteCatalogID" select="ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="normalize-space(Classification[@domain = 'UNSPSC']) != ''">
												<xsl:call-template name="createItemParts">
													<xsl:with-param name="Classification" select="Classification[@domain = 'UNSPSC']"/>
													<xsl:with-param name="IdReference-UPCUniversalProductCode" select="ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier"/>
													<xsl:with-param name="IdReference-europeanWasteCatalogID" select="ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="normalize-space(ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier) != ''">
												<xsl:call-template name="createItemParts">
													<xsl:with-param name="IdReference-UPCUniversalProductCode" select="ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier"/>
													<xsl:with-param name="IdReference-europeanWasteCatalogID" select="ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="normalize-space(ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier) != ''">
												<xsl:call-template name="createItemParts">
													<xsl:with-param name="IdReference-europeanWasteCatalogID" select="ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</S_PIA>
								</xsl:if>
								<!-- Description -->
								<xsl:if test="normalize-space(Description) != ''">
									<xsl:variable name="descText">
										<xsl:value-of select="normalize-space(Description)"/>
									</xsl:variable>
									<xsl:variable name="langCode" select="Description/@xml:lang"/>
									<xsl:if test="$descText != ''">
										<xsl:call-template name="IMDLoop">
											<xsl:with-param name="IMDQual" select="'F'"/>
											<xsl:with-param name="IMDData" select="$descText"/>
											<xsl:with-param name="langCode" select="$langCode"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>

								<!-- Description shortName -->
								<xsl:if test="normalize-space(Description/ShortName) != ''">
									<xsl:variable name="shortName" select="Description/ShortName"/>
									<xsl:variable name="langCode" select="Description/@xml:lang"/>
									<xsl:if test="$shortName != ''">
										<xsl:call-template name="IMDLoop">
											<xsl:with-param name="IMDQual" select="'E'"/>
											<xsl:with-param name="IMDData" select="$shortName"/>
											<xsl:with-param name="langCode" select="$langCode"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<!-- Characteristic -->
								<xsl:variable name="charDomain" select="normalize-space(Characteristic/@domain)"/>
								<xsl:if test="$Lookup/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[CXMLCode = $charDomain]/EDIFACTCode != '' and position() &lt; 98">
									<S_IMD>
										<D_7077>B</D_7077>
										<D_7081>
											<xsl:value-of select="$Lookup/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[CXMLCode = $charDomain]/EDIFACTCode"/>
										</D_7081>
										<xsl:if test="normalize-space(Characteristic/@value) != ''">
											<C_C273>
												<D_7009>
													<xsl:value-of select="Characteristic/@value"/>
												</D_7009>
											</C_C273>
										</xsl:if>
									</S_IMD>
								</xsl:if>


								<!-- Acceptance days -->
								<xsl:if test="normalize-space(PlannedAcceptanceDays) != ''">
									<S_DTM>
										<C_C507>
											<D_2005>143</D_2005>
											<D_2380>
												<xsl:value-of select="normalize-space(PlannedAcceptanceDays)"/>
											</D_2380>
											<D_2379>804</D_2379>
										</C_C507>
									</S_DTM>
								</xsl:if>
								<!-- Lead Time -->
								<xsl:if test="normalize-space(LeadTime) != ''">
									<S_DTM>
										<C_C507>
											<D_2005>169</D_2005>
											<D_2380>
												<xsl:value-of select="normalize-space(LeadTime)"/>
											</D_2380>
											<D_2379>804</D_2379>
										</C_C507>
									</S_DTM>
								</xsl:if>

								<!-- Status -->
								<xsl:if test="normalize-space(@status) != ''">
									<G_SG10>
										<S_RFF>
											<C_C506>
												<D_1153>AGW</D_1153>
												<D_1154>
													<xsl:value-of select="substring(normalize-space(@status), 1, 35)"/>
												</D_1154>
											</C_C506>
										</S_RFF>
									</G_SG10>
								</xsl:if>

								<!-- TimeSeries -->
								<xsl:for-each select="TimeSeries/Forecast">
									<xsl:if test="normalize-space(ForecastQuantity/@quantity) != ''">
										<G_SG12>
											<S_QTY>
												<C_C186>
													<D_6063>1</D_6063>
													<D_6060>
														<xsl:value-of select="format-number(ForecastQuantity/@quantity, '0.##')"/>
													</D_6060>
													<xsl:if test="normalize-space(ForecastQuantity/UnitOfMeasure) != ''">
														<D_6411>
															<xsl:value-of select="substring(ForecastQuantity/UnitOfMeasure, 1, 3)"/>
														</D_6411>
													</xsl:if>
												</C_C186>
											</S_QTY>
											<S_SCC>
												<D_4017>4</D_4017>
											</S_SCC>

											<!-- start Date -->

											<xsl:if test="normalize-space(Period/@startDate) != ''">
												<S_DTM>
													<C_C507>
														<D_2005>64</D_2005>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="normalize-space(Period/@startDate)"/>
														</xsl:call-template>
													</C_C507>
												</S_DTM>
											</xsl:if>
											<!-- end Date -->
											<xsl:if test="normalize-space(Period/@endDate) != ''">
												<S_DTM>
													<C_C507>
														<D_2005>63</D_2005>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="normalize-space(Period/@endDate)"/>
														</xsl:call-template>
													</C_C507>
												</S_DTM>
											</xsl:if>

											<xsl:if test="../@type = 'demand' or ../@type = 'orderForecast'">
												<G_SG13>
													<S_RFF>
														<C_C506>
															<D_1153>AEH</D_1153>
															<D_1154>
																<xsl:value-of select="../@type"/>
															</D_1154>
														</C_C506>
													</S_RFF>
												</G_SG13>
											</xsl:if>

										</G_SG12>
									</xsl:if>
								</xsl:for-each>

								<!-- PlanningTimeSeries -->
								<xsl:for-each select="PlanningTimeSeries/TimeSeriesDetails">
									<xsl:if test="normalize-space(TimeSeriesQuantity/@quantity) != ''">
										<G_SG12>
											<S_QTY>
												<C_C186>
													<D_6063>1</D_6063>
													<D_6060>
														<xsl:value-of select="format-number(TimeSeriesQuantity/@quantity, '0.##')"/>
													</D_6060>
													<xsl:if test="normalize-space(TimeSeriesQuantity/UnitOfMeasure) != ''">
														<D_6411>
															<xsl:value-of select="substring(TimeSeriesQuantity/UnitOfMeasure, 1, 3)"/>
														</D_6411>
													</xsl:if>
												</C_C186>
											</S_QTY>
											<S_SCC>
												<D_4017>12</D_4017>
											</S_SCC>

											<!-- start Date -->

											<xsl:if test="normalize-space(Period/@startDate) != ''">
												<S_DTM>
													<C_C507>
														<D_2005>64</D_2005>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="normalize-space(Period/@startDate)"/>
														</xsl:call-template>
													</C_C507>
												</S_DTM>
											</xsl:if>
											<!-- end Date -->
											<xsl:if test="normalize-space(Period/@endDate) != ''">
												<S_DTM>
													<C_C507>
														<D_2005>63</D_2005>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="normalize-space(Period/@endDate)"/>
														</xsl:call-template>
													</C_C507>
												</S_DTM>
											</xsl:if>

											<xsl:if test="../@type != ''">
												<G_SG13>
													<S_RFF>
														<C_C506>
															<D_1153>AEH</D_1153>
															<D_1154>
																<xsl:choose>
																	<xsl:when test="../@type != 'custom'">
																		<xsl:value-of select="../@customType"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="../@type"/>
																	</xsl:otherwise>
																</xsl:choose>
															</D_1154>
														</C_C506>
													</S_RFF>
												</G_SG13>
											</xsl:if>

										</G_SG12>
									</xsl:if>
								</xsl:for-each>

								<!-- InventoryTimeSeries -->
								<xsl:for-each select="InventoryTimeSeries/TimeSeriesDetails">
									<xsl:if test="normalize-space(TimeSeriesQuantity/@quantity) != ''">
										<G_SG12>
											<S_QTY>
												<C_C186>
													<D_6063>1</D_6063>
													<D_6060>
														<xsl:value-of select="format-number(TimeSeriesQuantity/@quantity, '0.##')"/>
													</D_6060>
													<xsl:if test="normalize-space(TimeSeriesQuantity/UnitOfMeasure) != ''">
														<D_6411>
															<xsl:value-of select="substring(TimeSeriesQuantity/UnitOfMeasure, 1, 3)"/>
														</D_6411>
													</xsl:if>
												</C_C186>
											</S_QTY>
											<S_SCC>
												<D_4017>17</D_4017>
											</S_SCC>

											<!-- start Date -->

											<xsl:if test="normalize-space(Period/@startDate) != ''">
												<S_DTM>
													<C_C507>
														<D_2005>64</D_2005>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="normalize-space(Period/@startDate)"/>
														</xsl:call-template>
													</C_C507>
												</S_DTM>
											</xsl:if>
											<!-- end Date -->
											<xsl:if test="normalize-space(Period/@endDate) != ''">
												<S_DTM>
													<C_C507>
														<D_2005>63</D_2005>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="DocDate" select="normalize-space(Period/@endDate)"/>
														</xsl:call-template>
													</C_C507>
												</S_DTM>
											</xsl:if>

											<xsl:if test="../@type = 'grossdemand' or ../@type = 'netdemand'">
												<G_SG13>
													<S_RFF>
														<C_C506>
															<D_1153>AEH</D_1153>
															<D_1154>
																<xsl:value-of select="../@type"/>
															</D_1154>
														</C_C506>
													</S_RFF>
												</G_SG13>
											</xsl:if>

										</G_SG12>
									</xsl:if>
								</xsl:for-each>
							</G_SG8>
						</xsl:for-each>
					</G_SG4>
				</xsl:for-each-group>
				<!--- Summary -->
				<S_UNS>
					<D_0081>S</D_0081>
				</S_UNS>
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
