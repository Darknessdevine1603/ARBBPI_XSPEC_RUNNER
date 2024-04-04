<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
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
	<!-- For local testing -->
	<!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>	
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:846:004010">
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
				<M_846>
					<S_ST>
						<D_143>846</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BIA>
						<D_353>00</D_353>
						<D_755>SI</D_755>
						<xsl:if test="cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID != ''">
							<D_127>
								<xsl:value-of select="substring(cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID, 1, 30)"/>
							</D_127>
						</xsl:if>
						<D_373>
							<xsl:value-of select="replace(substring-before(cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate, 'T'), '-', '')"/>
						</D_373>
						<D_337>
							<xsl:value-of select="substring(replace(substring-after(cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate, 'T'), ':', ''), 1, 6)"/>
						</D_337>
						<D_306>AC</D_306>
					</S_BIA>
					<xsl:for-each select="cXML/Message/ProductActivityMessage/ProductActivityDetails">
						<G_LIN>
							<xsl:if test="normalize-space(ItemID/SupplierPartID) != '' or normalize-space(ItemID/BuyerPartID) != '' or ItemID/SupplierPartAuxiliaryID != ''">
								<S_LIN>
									<xsl:call-template name="createItemParts">
										<xsl:with-param name="itemID" select="ItemID"/>
										<xsl:with-param name="itemDetail" select="."/>
										<xsl:with-param name="isSMI" select="'yes'"/>
									</xsl:call-template>
								</S_LIN>
							</xsl:if>
							<xsl:if test="normalize-space(Description) != ''">
								<S_PID>
									<D_349>F</D_349>
									<D_352>
										<xsl:value-of select="substring(normalize-space(Description), 1, 80)"/>
									</D_352>
									<D_819>
										<xsl:variable name="lang" select="string-length(normalize-space(Description/@xml:lang))"/>
										<xsl:choose>
											<xsl:when test="$lang &gt; 1">
												<xsl:value-of select="upper-case(substring(Description/@xml:lang, 1, 2))"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>EN</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</D_819>
								</S_PID>
							</xsl:if>
							<xsl:for-each select="Classification">
								<xsl:variable name="domain">
									<xsl:choose>
										<xsl:when test="@domain = 'MaterialGroup'">MatGroup</xsl:when>
										<xsl:when test="@domain = 'LineOfBusiness'">LOB</xsl:when>
										<xsl:when test="@domain = 'ProductFamily'">ProdFamily</xsl:when>
										<xsl:when test="@domain = 'ProductSubFamily'">ProdSubFamily</xsl:when>
										<xsl:when test="@domain = 'InternalProgramCode'">IntProgramCode</xsl:when>
										<xsl:when test="@domain = 'ExternalProgramCode'">ExtProgramCode</xsl:when>
										<xsl:when test="@domain = 'PartCategory'">PartCategory</xsl:when>
										<xsl:when test="@domain = 'PartType'">PartType</xsl:when>
										<xsl:when test="@domain = 'UNSPSC'">SPSC</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="$domain != ''">
									<S_PID>
										<D_349>S</D_349>
										<D_750>MAC</D_750>
										<D_559>
											<xsl:choose>
												<xsl:when test="@domain = 'UNSPSC'">UN</xsl:when>
												<xsl:otherwise>AS</xsl:otherwise>
											</xsl:choose>
										</D_559>
										<xsl:if test="@code != ''">
											<D_751>
												<xsl:value-of select="@code"/>
											</D_751>
										</xsl:if>
										<xsl:if test=". != ''">
											<D_352>
												<xsl:value-of select="."/>
											</D_352>
										</xsl:if>

										<D_822>
											<xsl:value-of select="$domain"/>
										</D_822>
									</S_PID>
								</xsl:if>
							</xsl:for-each>
							<xsl:if test="SerialNumberInfo/@requiresSerialNumber = 'yes'">
								<S_PID>
									<D_349>S</D_349>
									<D_750>09</D_750>
									<D_559>ZZ</D_559>
									<D_751>isSNRequired</D_751>
									<xsl:if test="SerialNumberInfo/@type != ''">
										<D_822>
											<xsl:value-of select="SerialNumberInfo/@type"/>
										</D_822>
									</xsl:if>
									<D_1073>Y</D_1073>
								</S_PID>
							</xsl:if>
							<xsl:for-each select="SerialNumberInfo/SerialNumber">
								<S_PID>
									<D_349>S</D_349>
									<D_750>09</D_750>
									<D_559>ZZ</D_559>
									<D_751>serialNumber</D_751>
									<D_352>
										<xsl:value-of select="."/>
									</D_352>
								</S_PID>
							</xsl:for-each>
							<xsl:if test="Inventory/DaysOfSupply/@minimum != ''">
								<S_MEA>
									<D_737>TI</D_737>
									<D_738>MI</D_738>
									<D_739>
										<xsl:value-of select="Inventory/DaysOfSupply/@minimum"/>
									</D_739>
									<C_C001>
										<D_355>DW</D_355>
									</C_C001>
								</S_MEA>
							</xsl:if>
							<xsl:if test="Inventory/DaysOfSupply/@maximum != ''">
								<S_MEA>
									<D_737>TI</D_737>
									<D_738>MX</D_738>
									<D_739>
										<xsl:value-of select="Inventory/DaysOfSupply/@maximum"/>
									</D_739>
									<C_C001>
										<D_355>DW</D_355>
									</C_C001>
								</S_MEA>
							</xsl:if>
							<xsl:if test="@status != ''">
								<S_REF>
									<D_128>ACC</D_128>
									<D_127>
										<xsl:value-of select="@status"/>
									</D_127>
								</S_REF>
							</xsl:if>
							<xsl:for-each select="Batch">
								<!-- BuyerBatchID and SupplierBatchID-->
								<xsl:variable name="batch_Position">
									<xsl:value-of select="position()"/>
								</xsl:variable>
								<xsl:if test="BuyerBatchID != '' or SupplierBatchID != ''">
									<xsl:call-template name="batch_REF">
										<xsl:with-param name="D_128" select="'BT'"/>
										<xsl:with-param name="D_127" select="SupplierBatchID"/>
										<xsl:with-param name="D_352" select="BuyerBatchID"/>
										<xsl:with-param name="C040_D_128" select="'0L'"/>
										<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position)"/>
										<xsl:with-param name="Pos_Domain" select="1"/>
										<xsl:with-param name="Pos_identifier" select="1"/>
									</xsl:call-template>
								</xsl:if>
								<!--@productionDate -->
								<xsl:if test="@productionDate != ''">
									<xsl:variable name="date">
										<xsl:variable name="Before-T">
											<xsl:value-of select="replace(substring-before(@productionDate, 'T'), '-', '')"/>
										</xsl:variable>
										<xsl:variable name="After-T">
											<xsl:value-of select="replace(substring-after(@productionDate, 'T'), ':', '')"/>
										</xsl:variable>
										<xsl:value-of select="concat($Before-T, $After-T)"/>
									</xsl:variable>
									<xsl:call-template name="batch_REF">
										<xsl:with-param name="D_128" select="'BT'"/>
										<xsl:with-param name="D_127" select="'productionDate'"/>
										<xsl:with-param name="D_352" select="$date"/>
										<xsl:with-param name="C040_D_128" select="'0L'"/>
										<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position)"/>
										<xsl:with-param name="Pos_Domain" select="1"/>
										<xsl:with-param name="Pos_identifier" select="1"/>
									</xsl:call-template>
								</xsl:if>
								<!-- @expirationDate -->
								<xsl:if test="@expirationDate != ''">
									<xsl:variable name="date">
										<xsl:variable name="Before-T">
											<xsl:value-of select="replace(substring-before(@expirationDate, 'T'), '-', '')"/>
										</xsl:variable>
										<xsl:variable name="After-T">
											<xsl:value-of select="replace(substring-after(@expirationDate, 'T'), ':', '')"/>
										</xsl:variable>
										<xsl:value-of select="concat($Before-T, $After-T)"/>
									</xsl:variable>
									<xsl:call-template name="batch_REF">
										<xsl:with-param name="D_128" select="'BT'"/>
										<xsl:with-param name="D_127" select="'expirationDate'"/>
										<xsl:with-param name="D_352" select="$date"/>
										<xsl:with-param name="C040_D_128" select="'0L'"/>
										<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position)"/>
										<xsl:with-param name="Pos_Domain" select="1"/>
										<xsl:with-param name="Pos_identifier" select="1"/>
									</xsl:call-template>
								</xsl:if>
								<!-- @inspectionDate -->
								<xsl:if test="@inspectionDate != ''">
									<xsl:variable name="date">
										<xsl:variable name="Before-T">
											<xsl:value-of select="replace(substring-before(@inspectionDate, 'T'), '-', '')"/>
										</xsl:variable>
										<xsl:variable name="After-T">
											<xsl:value-of select="replace(substring-after(@inspectionDate, 'T'), ':', '')"/>
										</xsl:variable>
										<xsl:value-of select="concat($Before-T, $After-T)"/>
									</xsl:variable>
									<xsl:call-template name="batch_REF">
										<xsl:with-param name="D_128" select="'BT'"/>
										<xsl:with-param name="D_127" select="'inspectionDate'"/>
										<xsl:with-param name="D_352" select="$date"/>
										<xsl:with-param name="C040_D_128" select="'0L'"/>
										<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position)"/>
										<xsl:with-param name="Pos_Domain" select="1"/>
										<xsl:with-param name="Pos_identifier" select="1"/>
									</xsl:call-template>
								</xsl:if>
								<!--ReferenceDocumentInfo -->
								<xsl:for-each select="../ReferenceDocumentInfo">
									<xsl:if test="normalize-space(DocumentInfo/@documentDate) != '' or normalize-space(DocumentInfo/@documentID) != ''">
										<xsl:variable name="date">
											<xsl:variable name="Before-T">
												<xsl:value-of select="replace(substring-before(DocumentInfo/@documentDate, 'T'), '-', '')"/>
											</xsl:variable>
											<xsl:variable name="After-T">
												<xsl:value-of select="replace(substring-after(DocumentInfo/@documentDate, 'T'), ':', '')"/>
											</xsl:variable>
											<xsl:value-of select="concat($Before-T, $After-T)"/>
										</xsl:variable>
										<xsl:call-template name="batch_REF">
											<xsl:with-param name="D_128" select="'0L'"/>
											<xsl:with-param name="D_127" select="DocumentInfo/@documentType"/>
											<xsl:with-param name="D_352" select="DocumentInfo/@documentID"/>
											<xsl:with-param name="C040_D_128" select="'0L'"/>
											<xsl:with-param name="C040_D_127" select="$date"/>
											<xsl:with-param name="Pos_Domain" select="1"/>
											<xsl:with-param name="Pos_identifier" select="1"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
								<!-- @shelfLife -->
								<xsl:if test="@shelfLife != ''">
									<xsl:variable name="date">
										<xsl:variable name="Before-T">
											<xsl:value-of select="replace(substring-before(@shelfLife, 'T'), '-', '')"/>
										</xsl:variable>
										<xsl:variable name="After-T">
											<xsl:value-of select="replace(substring-after(@shelfLife, 'T'), ':', '')"/>
										</xsl:variable>
										<xsl:value-of select="concat($Before-T, $After-T)"/>
									</xsl:variable>
									<xsl:call-template name="batch_REF">
										<xsl:with-param name="D_128" select="'BT'"/>
										<xsl:with-param name="D_127" select="'shelfLife'"/>
										<xsl:with-param name="D_352" select="$date"/>
										<xsl:with-param name="C040_D_128" select="'0L'"/>
										<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position)"/>
										<xsl:with-param name="Pos_Domain" select="1"/>
										<xsl:with-param name="Pos_identifier" select="1"/>
									</xsl:call-template>
								</xsl:if>
								<!-- @originCountryCode -->
								<xsl:if test="@originCountryCode != ''">
									<xsl:call-template name="batch_REF">
										<xsl:with-param name="D_128" select="'BT'"/>
										<xsl:with-param name="D_127" select="'originCountryCode'"/>
										<xsl:with-param name="D_352" select="@originCountryCode"/>
										<xsl:with-param name="C040_D_128" select="'0L'"/>
										<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position)"/>
										<xsl:with-param name="Pos_Domain" select="1"/>
										<xsl:with-param name="Pos_identifier" select="1"/>
									</xsl:call-template>
								</xsl:if>
								<!-- @batchQuantity -->
								<xsl:if test="@batchQuantity != ''">
									<xsl:call-template name="batch_REF">
										<xsl:with-param name="D_128" select="'BT'"/>
										<xsl:with-param name="D_127" select="'batchQuantity'"/>
										<xsl:with-param name="D_352" select="@batchQuantity"/>
										<xsl:with-param name="C040_D_128" select="'0L'"/>
										<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position)"/>
										<xsl:with-param name="Pos_Domain" select="1"/>
										<xsl:with-param name="Pos_identifier" select="1"/>
									</xsl:call-template>
								</xsl:if>
								<!-- PropertyValuation -->
								<xsl:for-each select="PropertyValuation">
									<xsl:variable name="Pro_Valuation_Position">
										<xsl:value-of select="position()"/>
									</xsl:variable>
									<xsl:for-each select="PropertyReference/IdReference">
										<xsl:variable name="IdReference_Position">
											<xsl:value-of select="position()"/>
										</xsl:variable>
										<xsl:if test="@identifier != '' and @domain != ''">
											<xsl:call-template name="batch_REF">
												<xsl:with-param name="D_128" select="'ADB'"/>
												<xsl:with-param name="D_127" select="@domain"/>
												<xsl:with-param name="D_352" select="@identifier"/>
												<xsl:with-param name="C040_D_128" select="'0L'"/>
												<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position, '-', 'B', $Pro_Valuation_Position, '-', 'Z', $IdReference_Position)"/>
												<xsl:with-param name="Pos_Domain" select="1"/>
												<xsl:with-param name="Pos_identifier" select="1"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each>
									<!-- ValueGroup -->
									<xsl:for-each select="ValueGroup">
										<xsl:variable name="ValueGroup_Position">
											<xsl:value-of select="position()"/>
										</xsl:variable>
										<xsl:variable name="ValueGroup_IdReference_Position">
											<xsl:value-of select="'1'"/>
										</xsl:variable>
										<xsl:variable name="parentID">
											<xsl:value-of select="normalize-space(ParentID)"/>
										</xsl:variable>

										<xsl:if test="IdReference/@identifier != '' and IdReference/@domain != ''">
											<xsl:call-template name="batch_REF">
												<xsl:with-param name="D_128" select="'ADC'"/>
												<xsl:with-param name="D_127" select="IdReference/@domain"/>
												<xsl:with-param name="D_352" select="IdReference/@identifier"/>
												<xsl:with-param name="C040_D_128" select="'0L'"/>
												<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position, '-', 'B', $Pro_Valuation_Position, '-', 'C', $ValueGroup_Position, '-', 'Z', $ValueGroup_IdReference_Position)"/>
												<xsl:with-param name="C040_D_128_2" select="'ADE'"/>
												<xsl:with-param name="C040_D_127_2" select="$parentID"/>
												<xsl:with-param name="Pos_Domain" select="1"/>
												<xsl:with-param name="Pos_identifier" select="1"/>
											</xsl:call-template>
										</xsl:if>
										<!-- PropertyValue -->
										<xsl:for-each select="PropertyValue">
											<xsl:variable name="ValueGroup_PropertyValue_Position">
												<xsl:value-of select="position()"/>
											</xsl:variable>
											<xsl:variable name="propertyValue_Name">
												<xsl:value-of select="@name"/>
											</xsl:variable>
											<xsl:for-each select="Characteristic">
												<xsl:variable name="ValueGroup_PropertyValue_Characteristic_Position">
													<xsl:value-of select="position()"/>
												</xsl:variable>

												<xsl:if test="@value != '' and @domain != ''">
													<xsl:call-template name="batch_REF">
														<xsl:with-param name="D_128" select="'ADD'"/>
														<xsl:with-param name="D_127" select="@domain"/>
														<xsl:with-param name="D_352" select="@value"/>
														<xsl:with-param name="C040_D_128" select="'0L'"/>
														<xsl:with-param name="C040_D_127" select="concat('A', $batch_Position, '-', 'B', $Pro_Valuation_Position, '-', 'C', $ValueGroup_Position, '-', 'D', $ValueGroup_PropertyValue_Position, '-', 'Z', $ValueGroup_PropertyValue_Characteristic_Position)"/>
														<xsl:with-param name="C040_D_128_2" select="'ADE'"/>
														<xsl:with-param name="C040_D_127_2" select="$parentID"/>
														<xsl:with-param name="C040_D_128_3" select="'S3'"/>
														<xsl:with-param name="C040_D_127_3" select="$propertyValue_Name"/>
														<xsl:with-param name="Pos_Domain" select="1"/>
														<xsl:with-param name="Pos_identifier" select="1"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each>
										</xsl:for-each>
									</xsl:for-each>

								</xsl:for-each>


							</xsl:for-each>

							<xsl:if test="UnitOfMeasure != ''">
								<S_UIT>
									<xsl:variable name="uomcode">
										<xsl:value-of select="UnitOfMeasure"/>
									</xsl:variable>
									<C_C001>
										<D_355>
											<xsl:choose>
												<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
													<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
												</xsl:when>
												<xsl:otherwise>ZZ</xsl:otherwise>
											</xsl:choose>
										</D_355>
									</C_C001>
								</S_UIT>
							</xsl:if>

							<xsl:if test="normalize-space(LeadTime) != ''">
								<S_LDT>
									<D_345>AF</D_345>
									<D_380>
										<xsl:value-of select="normalize-space(LeadTime)"/>
									</D_380>
									<D_344>DA</D_344>
								</S_LDT>
							</xsl:if>
							<xsl:for-each select="Inventory/child::*">
								<xsl:apply-templates select=".">
									<xsl:with-param name="type" select="'inventory'"/>
								</xsl:apply-templates>
							</xsl:for-each>
							<xsl:for-each select="ConsignmentInventory/child::*">
								<xsl:apply-templates select=".">
									<xsl:with-param name="type" select="'consignmentinventory'"/>
								</xsl:apply-templates>
							</xsl:for-each>
							<xsl:for-each select="Contact">
								<xsl:call-template name="createContact">
									<xsl:with-param name="party" select="."/>
									<xsl:with-param name="sprole" select="'yes'"/>
								</xsl:call-template>
							</xsl:for-each>
						</G_LIN>
					</xsl:for-each>
					<S_CTT>
						<D_354>
							<xsl:value-of select="count(/cXML/Message/ProductActivityMessage/ProductActivityDetails)"/>
						</D_354>
					</S_CTT>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_846>
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
	<xsl:template match="SubcontractingStockInTransferQuantity | UnrestrictedUseQuantity | BlockedQuantity | QualityInspectionQuantity | StockInTransferQuantity | IncrementQuantity | RequiredMinimumQuantity | RequiredMaximumQuantity">
		<xsl:param name="type"/>
		<xsl:variable name="QtyCode" select="name()"/>
		<xsl:if test="$Lookup/Lookups/QuantityCodes/QuantityCode[CXMLCode = $QtyCode]/X12Code != ''">
			<G_QTY>
				<S_QTY>
					<D_673>
						<xsl:value-of select="$Lookup/Lookups/QuantityCodes/QuantityCode[CXMLCode = $QtyCode]/X12Code"/>
					</D_673>
					<D_380>
						<xsl:call-template name="formatQty">
							<xsl:with-param name="qty" select="@quantity"/>
						</xsl:call-template>
					</D_380>
					<xsl:variable name="uomcode">
						<xsl:choose>
							<xsl:when test="UnitOfMeasure != ''">
								<xsl:value-of select="UnitOfMeasure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ZZ</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<C_C001>
						<D_355>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
									<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</D_355>
						<D_1018>
							<xsl:choose>
								<xsl:when test="$type = 'inventory'">
									<xsl:text>1</xsl:text>
								</xsl:when>
								<xsl:when test="$type = 'consignmentinventory'">
									<xsl:text>2</xsl:text>
								</xsl:when>
							</xsl:choose>
						</D_1018>
					</C_C001>
				</S_QTY>
			</G_QTY>
		</xsl:if>
	</xsl:template>

	<xsl:template name="batch_REF">
		<xsl:param name="D_128"/>
		<xsl:param name="D_127"/>
		<xsl:param name="D_352"/>
		<xsl:param name="C040_D_128"/>
		<xsl:param name="C040_D_127"/>
		<xsl:param name="Position"/>
		<xsl:param name="C040_D_128_2"/>
		<xsl:param name="C040_D_127_2"/>
		<xsl:param name="C040_D_128_3"/>
		<xsl:param name="C040_D_127_3"/>


		<xsl:param name="Pos_Domain"/>
		<xsl:param name="Pos_identifier"/>
		<xsl:variable name="Length_Domain" select="$Pos_Domain + 30"/>
		<xsl:variable name="Length_identifier" select="$Pos_identifier + 80"/>
		<xsl:variable name="StrLen_Domain" select="string-length($D_127)"/>
		<xsl:variable name="StrLen_identifier" select="string-length($D_352)"/>

		<S_REF>
			<D_128>
				<xsl:value-of select="$D_128"/>
			</D_128>
			<xsl:if test="normalize-space($D_127) != ''">
				<D_127>
					<!--<xsl:value-of select="normalize-space($D_127)"/>-->
					<xsl:value-of select="substring(normalize-space($D_127), $Pos_Domain, 30)"/>
				</D_127>
			</xsl:if>
			<xsl:if test="normalize-space($D_352) != ''">
				<D_352>
					<!--<xsl:value-of select="normalize-space($D_352)"/>-->
					<xsl:value-of select="substring(normalize-space($D_352), $Pos_identifier, 80)"/>
				</D_352>
			</xsl:if>
			<C_C040>
				<D_128>
					<xsl:value-of select="$C040_D_128"/>
				</D_128>
				<xsl:if test="$C040_D_127 != ''">
					<D_127>
						<xsl:value-of select="$C040_D_127"/>
					</D_127>
				</xsl:if>

				<xsl:if test="$C040_D_127_2 != ''">
					<D_128_2>
						<xsl:value-of select="$C040_D_128_2"/>
					</D_128_2>
					<D_127_2>
						<xsl:value-of select="$C040_D_127_2"/>
					</D_127_2>
				</xsl:if>
				<xsl:if test="$C040_D_127_3 != ''">
					<D_128_3>
						<xsl:value-of select="$C040_D_128_3"/>
					</D_128_3>
					<D_127_3>
						<xsl:value-of select="$C040_D_127_3"/>
					</D_127_3>
				</xsl:if>
			</C_C040>
		</S_REF>

		<xsl:if test="$Length_Domain &lt; $StrLen_Domain or $Length_identifier &lt; $StrLen_identifier">

			<xsl:call-template name="batch_REF">
				<xsl:with-param name="D_128" select="$D_128"/>
				<xsl:with-param name="D_127" select="$D_127"/>
				<xsl:with-param name="D_352" select="$D_352"/>
				<xsl:with-param name="C040_D_128" select="$C040_D_128"/>
				<xsl:with-param name="C040_D_127" select="$C040_D_127"/>
				<xsl:with-param name="C040_D_128_2" select="$C040_D_128_2"/>
				<xsl:with-param name="C040_D_127_2" select="$C040_D_127_2"/>
				<xsl:with-param name="C040_D_128_3" select="$C040_D_128_3"/>
				<xsl:with-param name="C040_D_127_3" select="$C040_D_127_3"/>
				<xsl:with-param name="Pos_Domain" select="$Length_Domain"/>
				<xsl:with-param name="Pos_identifier" select="$Length_identifier"/>

			</xsl:call-template>
		</xsl:if>


	</xsl:template>



</xsl:stylesheet>
