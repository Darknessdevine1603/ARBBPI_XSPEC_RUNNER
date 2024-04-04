<?xml version="1.0" encoding="utf-8"?>
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
	<xsl:param name="exchange"/>

	<!-- For local testing -->
	<!--<xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>

	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>RT</D_479>
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
				<M_863>
					<S_ST>
						<D_143>863</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BTR>
						<D_353>
							<xsl:choose>
								<xsl:when
									test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/@operation = 'new'">
									<xsl:text>00</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>05</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</D_353>
						<D_373>
							<xsl:value-of
								select="replace(substring-before(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/@requestDate, 'T'), '-', '')"
							/>
						</D_373>
						<D_337>
							<xsl:value-of
								select="replace(substring(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/@requestDate, 12, 8), ':', '')"
							/>
						</D_337>
						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/@requestID != ''">
							<D_127>
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/@requestID"
								/>
							</D_127>
						</xsl:if>
					</S_BTR>
					<xsl:if
						test="normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/@createdBy) != ''">
						<S_NTE>
							<D_363>AAA</D_363>
							<D_352>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/@createdBy), 1, 80)"
								/>
							</D_352>
						</S_NTE>
					</xsl:if>
					<xsl:if
						test="normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Comments) != ''">
						<S_NTE>
							<D_363>RPT</D_363>
							<D_352>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Comments), 1, 80)"
								/>
							</D_352>
						</S_NTE>
					</xsl:if>

					<xsl:if
						test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentID != ''">
						<S_REF>
							<xsl:choose>
								<xsl:when
									test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentType = 'PurchaseOrder'">
									<D_128>PO</D_128>
								</xsl:when>
								<xsl:otherwise>
									<D_128>MA</D_128>
								</xsl:otherwise>
							</xsl:choose>

							<D_127>
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentID"
								/>
							</D_127>
							<C_C040>
								<D_128>LI</D_128>
								<D_127>
									<xsl:value-of
										select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ReferenceDocumentInfo/@lineNumber"
									/>
								</D_127>
							</C_C040>
						</S_REF>
					</xsl:if>

					<xsl:if
						test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ReferenceDocumentInfo/DocumentInfo[@documentType = 'PurchaseOrder']/@documentDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">004</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ReferenceDocumentInfo/DocumentInfo[@documentType = 'PurchaseOrder']/@documentDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<xsl:if
						test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Period/@startDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">157</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Period/@startDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:if
						test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Period/@endDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">158</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Period/@endDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:if
						test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/IdReference[@domain = 'inspectionType']/@identifier != ''">
						<S_TMD>
							<!--<D_750>
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/IdReference[@domain = 'inspectionType']/@identifier"
								/>
							</D_750>-->
							<xsl:if
								test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/IdReference[@domain = 'inspectionType']/Description != ''">
								<D_352>
									<xsl:value-of
										select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/IdReference[@domain = 'inspectionType']/Description"
									/>
								</D_352>
							</xsl:if>
							<D_127>
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/IdReference[@domain = 'inspectionType']/@identifier"
								/>
							</D_127>
						</S_TMD>
					</xsl:if>
					<xsl:if
						test="exists(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ShipTo)">
						<xsl:call-template name="create_QIR_N1">
							<xsl:with-param name="party"
								select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ShipTo"
							/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if
						test="exists(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/BillTo)">
						<xsl:call-template name="create_QIR_N1">
							<xsl:with-param name="party"
								select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/BillTo"
							/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each
						select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Contact">
						<xsl:call-template name="createContact_QIR">
							<xsl:with-param name="party" select="."/>
							<xsl:with-param name="sprole" select="'QN'"/>
						</xsl:call-template>
					</xsl:for-each>

					<G_LIN>
						<S_LIN>
							<D_235>VP</D_235>
							<D_234>
								<xsl:value-of
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/SupplierPartID"
								/>
							</D_234>
							<xsl:choose>
								<xsl:when
									test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/BuyerPartID != ''">
									<D_235_2>BP</D_235_2>
									<D_234_2>
										<xsl:value-of
											select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/BuyerPartID"
										/>
									</D_234_2>
									<xsl:if
										test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID != ''">
										<D_235_3>VS</D_235_3>
										<D_234_3>
											<xsl:value-of
												select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID"
											/>
										</D_234_3>
									</xsl:if>
								</xsl:when>
								<xsl:when
									test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID != ''">
									<D_235_2>VS</D_235_2>
									<D_234_2>
										<xsl:value-of
											select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID"
										/>
									</D_234_2>
								</xsl:when>
							</xsl:choose>
						</S_LIN>
						<xsl:if
							test="normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description) != ''">
							<S_PID>
								<D_349>F</D_349>
								<D_352>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description), 1, 80)"
									/>
								</D_352>
								<xsl:if
									test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description/@xml:lang != ''">
									<D_819>
										<xsl:value-of
											select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description/@xml:lang"
										/>
									</D_819>
								</xsl:if>
							</S_PID>
						</xsl:if>
						<xsl:if
							test="normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description/ShortName) != ''">
							<S_PID>
								<D_349>F</D_349>
								<D_750>GEN</D_750>
								<D_352>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description/ShortName), 1, 80)"
									/>
								</D_352>
								<xsl:if
									test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description/@xml:lang != ''">
									<D_819>
										<xsl:value-of
											select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/Description/@xml:lang"
										/>
									</D_819>
								</xsl:if>
							</S_PID>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/@quantity != ''">
							<S_QTY>
								<D_673>38</D_673>
								<D_380>
									<xsl:call-template name="formatQty">
										<xsl:with-param name="qty"
											select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/@quantity"
										/>
									</xsl:call-template>

								</D_380>
								<xsl:variable name="uom"
									select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/UnitOfMeasure"/>
								<xsl:if
									test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code != ''">

									<C_C001>
										<D_355>
											<xsl:value-of
												select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code"
											/>
										</D_355>
									</C_C001>
								</xsl:if>
							</S_QTY>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/SupplierBatchID != '' and cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/BuyerBatchID != ''">
							<S_REF>
								<D_128>BT</D_128>
								<D_127>
									<xsl:value-of
										select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/SupplierBatchID"
									/>
								</D_127>
								<D_352>
									<xsl:value-of
										select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/BuyerBatchID"
									/>
								</D_352>
							</S_REF>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@productionDate != ''">
							<xsl:call-template name="REFSupplierBuyerBatchID">
								<xsl:with-param name="D_127">productionDate</xsl:with-param>
								<xsl:with-param name="D_352">
									<xsl:value-of
										select="replace(replace(replace(substring-before(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@productionDate, '+'), ':', ''), 'T', ''), '-', '')"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@expirationDate != ''">
							<xsl:call-template name="REFSupplierBuyerBatchID">
								<xsl:with-param name="D_127">expirationDate</xsl:with-param>
								<xsl:with-param name="D_352">
									<xsl:value-of
										select="replace(replace(replace(substring-before(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@expirationDate, '+'), ':', ''), 'T', ''), '-', '')"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@inspectionDate != ''">
							<xsl:call-template name="REFSupplierBuyerBatchID">
								<xsl:with-param name="D_127">inspectionDate</xsl:with-param>
								<xsl:with-param name="D_352">
									<xsl:value-of
										select="replace(replace(replace(substring-before(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@inspectionDate, '+'), ':', ''), 'T', ''), '-', '')"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@shelfLife != ''">
							<xsl:call-template name="REFSupplierBuyerBatchID">
								<xsl:with-param name="D_127">shelfLife</xsl:with-param>
								<xsl:with-param name="D_352">
									<xsl:value-of
										select="replace(replace(replace(substring-before(cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@shelfLife, '+'), ':', ''), 'T', ''), '-', '')"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@originCountryCode != ''">
							<xsl:call-template name="REFSupplierBuyerBatchID">
								<xsl:with-param name="D_127">originCountryCode</xsl:with-param>
								<xsl:with-param name="D_352">
									<xsl:value-of
										select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@originCountryCode"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@batchQuantity != ''">
							<xsl:call-template name="REFSupplierBuyerBatchID">
								<xsl:with-param name="D_127">batchQuantity</xsl:with-param>
								<xsl:with-param name="D_352">
									<xsl:value-of
										select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/@batchQuantity"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:for-each
							select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/ItemInfo/ItemID/IdReference">
							<xsl:if test="@identifier != ''">
								<S_REF>
									<D_128>IX</D_128>
									<D_127>
										<xsl:value-of select="@identifier"/>
									</D_127>
									<D_352>
										<xsl:value-of select="substring(Description, 1, 80)"/>
									</D_352>
									<xsl:if test="@domain != ''">
										<C_C040>
											<D_128>IX</D_128>
											<D_127>
												<xsl:value-of select="@domain"/>
											</D_127>
										</C_C040>
									</xsl:if>
								</S_REF>
							</xsl:if>
						</xsl:for-each>
						<xsl:if
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/QualityInfo/@requiresQualityProcess = 'yes'">

							<xsl:for-each
								select="/cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/QualityInfo/IdReference">
								<S_REF>
									<D_128>H6</D_128>
									<D_127>
										<xsl:value-of select="@identifier"/>
									</D_127>
									<D_352>
										<xsl:value-of select="substring(Description, 1, 80)"/>
									</D_352>
									<xsl:if test="@domain != ''">
										<C_C040>
											<D_128>H6</D_128>
											<D_127>
												<xsl:value-of select="@domain"/>
											</D_127>
										</C_C040>
									</xsl:if>
								</S_REF>
							</xsl:for-each>
						</xsl:if>

						<xsl:for-each
							select="/cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/QualityInfo/CertificateInfo">
							<xsl:if test="@isRequired = 'yes'">
								<S_REF>
									<D_128>Y9</D_128>
									<D_127>
										<xsl:value-of select="IdReference/@identifier"/>
									</D_127>
								</S_REF>
							</xsl:if>
						</xsl:for-each>

						<xsl:for-each
							select="/cXML/Request/QualityInspectionRequest/QualityInspectionRequestDetail/QualityInspectionCharacteristic">
							<G_CID>
								<S_CID>
									<D_559>ZZ</D_559>
									<xsl:if test="@characteristicID != ''">
										<D_751>
											<xsl:value-of
												select="substring(@characteristicID, 1, 12)"/>
										</D_751>
									</xsl:if>
									<xsl:if test="@operationNumber != ''">
										<D_352>
											<xsl:value-of
												select="substring(@operationNumber, 1, 30)"/>
										</D_352>
									</xsl:if>
								</S_CID>
								<xsl:if test="SampleDefinition/@sampleSize != ''">
									<S_PSD>
										<D_942>
											<xsl:value-of select="SampleDefinition/@sampleSize"/>
										</D_942>
										<C_C001>
											<D_355>ZZ</D_355>
										</C_C001>
										<xsl:if test="SampleDefinition/@sampleType != ''">
											<D_352>
												<xsl:value-of select="SampleDefinition/@sampleType"
												/>
											</D_352>
										</xsl:if>
									</S_PSD>
								</xsl:if>
								<xsl:if test="@isLocked != '' or @characteristicType != ''">
									<S_PSD>
										<D_942>0</D_942>
										<C_C001>
											<D_355>ZZ</D_355>
											<xsl:if test="@isLocked = 'yes'">
												<D_1018>1</D_1018>
											</xsl:if>

											<D_649>
												<xsl:choose>
												<xsl:when test="@characteristicType = 'required'"
												>1</xsl:when>
												<xsl:when test="@characteristicType = 'optional'"
												>2</xsl:when>
												<xsl:when
												test="@characteristicType = 'afterAccept'"
												>3</xsl:when>
												<xsl:when
												test="@characteristicType = 'afterRejection'"
												>4</xsl:when>
												</xsl:choose>

											</D_649>

											<xsl:if test="@isQuantitative = 'yes'">
												<D_1018_2>1</D_1018_2>
											</xsl:if>
											<xsl:if test="@recordingType != ''">
												<D_649_2>
												<xsl:choose>
												<xsl:when test="@recordingType = 'singleResult'"
												>1</xsl:when>
												<xsl:when
												test="@recordingType = 'summarizedRecording'"
												>2</xsl:when>
												<xsl:when
												test="@recordingType = 'noCharacteristicRecording'"
												>3</xsl:when>
												<xsl:when
												test="@recordingType = 'classedRecording'"
												>4</xsl:when>
												</xsl:choose>

												</D_649_2>
											</xsl:if>
										</C_C001>

										<D_352>
											<xsl:value-of
												select="'QualityInspectionCharacteristicInformation'"
											/>
										</D_352>

									</S_PSD>
								</xsl:if>
								<xsl:if test="@workCenter != ''">
									<S_REF>
										<D_128>88</D_128>
										<D_127>
											<xsl:value-of select="@workCenter"/>
										</D_127>
									</S_REF>
								</xsl:if>

								<xsl:if test="@inspectionPoint != ''">
									<S_REF>
										<D_128>QI</D_128>
										<D_127>
											<xsl:value-of select="@inspectionPoint"/>
										</D_127>
									</S_REF>
								</xsl:if>
								<xsl:for-each select="IdReference">
									<S_REF>
										<D_128>0L</D_128>
										<xsl:if test="@identifier != ''">
											<D_127>
												<xsl:value-of select="@identifier"/>
											</D_127>
										</xsl:if>
										<xsl:if test="Description != ''">
											<D_352>
												<xsl:value-of
												select="substring(normalize-space(Description), 1, 30)"
												/>
											</D_352>
										</xsl:if>
										<xsl:if test="@domain != ''">
											<C_C040>
												<D_128>0L</D_128>
												<D_127>
												<xsl:value-of select="@domain"/>
												</D_127>
											</C_C040>
										</xsl:if>
									</S_REF>
								</xsl:for-each>
								<xsl:if test="Description != ''">
									<S_NTE>
										<D_363>TRS</D_363>
										<D_352>
											<xsl:value-of
												select="substring(normalize-space(Description), 1, 30)"
											/>
										</D_352>
									</S_NTE>
								</xsl:if>
								<xsl:if test="Description/ShortName != ''">
									<S_NTE>
										<D_363>ADD</D_363>
										<D_352>
											<xsl:value-of
												select="substring(Description/ShortName, 1, 30)"/>
										</D_352>
									</S_NTE>
								</xsl:if>
								<xsl:if test="Comments != ''">
									<S_NTE>
										<D_363>RPT</D_363>
										<D_352>
											<xsl:value-of select="substring(Comments, 1, 30)"/>
										</D_352>
									</S_NTE>
								</xsl:if>
								<xsl:if test="ExpectedResult/@targetValue != ''">
									<G_STA>
										<S_STA>
											<D_950>ZZ</D_950>
											<D_739>1</D_739>
											<C_C001>
												<D_355>ZZ</D_355>
												<D_1018>
												<xsl:value-of
												select="format-number(ExpectedResult/@targetValue, '#')"
												/>
												</D_1018>
											</C_C001>
										</S_STA>
									</G_STA>
								</xsl:if>

								<xsl:if test="ExpectedResult/@valuePrecision != ''">
									<G_STA>
										<S_STA>
											<D_950>ZZ</D_950>
											<D_739>2</D_739>
											<C_C001>
												<D_355>ZZ</D_355>
												<D_1018>
												<xsl:value-of
												select="format-number(ExpectedResult/@valuePrecision, '#')"
												/>
												</D_1018>
											</C_C001>
										</S_STA>
									</G_STA>
								</xsl:if>

								<xsl:if test="ExpectedResult/@qualitativeValue != ''">
									<G_STA>
										<S_STA>
											<D_950>ZZ</D_950>
											<D_739>3</D_739>
											<C_C001>
												<D_355>ON</D_355>
												<D_1018>
												<xsl:value-of
												select="ExpectedResult/@qualitativeValue"/>
												</D_1018>
											</C_C001>
										</S_STA>
									</G_STA>
								</xsl:if>

								<xsl:if
									test="ExpectedResult/MinimumLimit/ComparatorInfo/@comparatorValue != ''">
									<G_STA>
										<S_STA>
											<D_950>32</D_950>
											<D_739>
												<xsl:value-of
												select="ExpectedResult/MinimumLimit/ComparatorInfo/@comparatorValue"
												/>
											</D_739>
											<xsl:if
												test="ExpectedResult/MinimumLimit/ComparatorInfo/@comparatorType != ''">
												<D_935>
												<xsl:choose>
												<xsl:when
												test="ExpectedResult/MinimumLimit/ComparatorInfo/@comparatorType = 'greater'"
												>06</xsl:when>
												<xsl:when
												test="ExpectedResult/MinimumLimit/ComparatorInfo/@comparatorType = 'less'"
												>07</xsl:when>
												<xsl:when
												test="ExpectedResult/MinimumLimit/ComparatorInfo/@comparatorType = 'greaterOrEqual'"
												>05</xsl:when>
												<xsl:when
												test="ExpectedResult/MinimumLimit/ComparatorInfo/@comparatorType = 'lessOrEqual'"
												>08</xsl:when>
												</xsl:choose>
												</D_935>
											</xsl:if>

										</S_STA>
									</G_STA>
								</xsl:if>

								<xsl:if
									test="ExpectedResult/MaximumLimit/ComparatorInfo/@comparatorValue != ''">
									<G_STA>
										<S_STA>
											<D_950>33</D_950>
											<D_739>
												<xsl:value-of
												select="ExpectedResult/MaximumLimit/ComparatorInfo/@comparatorValue"
												/>
											</D_739>
											<xsl:if
												test="ExpectedResult/MaximumLimit/ComparatorInfo/@comparatorType != ''">
												<D_935>
												<xsl:choose>
												<xsl:when
												test="ExpectedResult/MaximumLimit/ComparatorInfo/@comparatorType = 'greater'"
												>06</xsl:when>
												<xsl:when
												test="ExpectedResult/MaximumLimit/ComparatorInfo/@comparatorType = 'less'"
												>07</xsl:when>
												<xsl:when
												test="ExpectedResult/MaximumLimit/ComparatorInfo/@comparatorType = 'greaterOrEqual'"
												>05</xsl:when>
												<xsl:when
												test="ExpectedResult/MaximumLimit/ComparatorInfo/@comparatorType = 'lessOrEqual'"
												>08</xsl:when>
												</xsl:choose>
												</D_935>
											</xsl:if>

										</S_STA>
									</G_STA>
								</xsl:if>

								<xsl:for-each-group
									select="ExpectedResult/PropertyValue/Characteristic"
									group-by="(position() - 1) idiv 10">
									<G_STA>
										<S_STA>
											<D_950>zz</D_950>
											<D_739>9</D_739>
										</S_STA>
										<xsl:for-each select="current-group()">
											<S_REF>
												<D_128>ADE</D_128>
												<D_127>
												<xsl:value-of select="@domain"/>
												</D_127>
												<D_352>
												<xsl:value-of select="@value"/>
												</D_352>
												<C_C040>
												<D_128>ADE</D_128>
												<D_127>
												<xsl:value-of select="@code"/>
												</D_127>
												</C_C040>
											</S_REF>
										</xsl:for-each>
									</G_STA>
								</xsl:for-each-group>
								<xsl:if test="exists(AllowedValues)">

									<xsl:for-each-group
										select="AllowedValues/PropertyValue/Characteristic"
										group-by="(position() - 1) idiv 10">
										<G_TMD>
											<S_TMD>
												<D_559>ZZ</D_559>
												<D_751>
												<xsl:choose>
												<xsl:when test="../../@type = 'numeric'"
												>1</xsl:when>
												<xsl:when test="../../@type = 'decision'"
												>2</xsl:when>
												<xsl:when test="../../@type = 'choice'"
												>3</xsl:when>
												<xsl:otherwise>ZZ</xsl:otherwise>
												</xsl:choose>
												</D_751>
											</S_TMD>
												<xsl:for-each select="current-group()">
												<S_REF>
												<D_128>ADE</D_128>
												<D_127>
												<xsl:value-of select="@domain"/>
												</D_127>
												<D_352>
												<xsl:value-of select="@value"/>
												</D_352>
												<C_C040>
												<D_128>ADE</D_128>
												<D_127>
												<xsl:value-of select="@code"/>
												</D_127>
												</C_C040>
												</S_REF>
												</xsl:for-each>
											
										</G_TMD>
									</xsl:for-each-group>
								</xsl:if>
							</G_CID>
						</xsl:for-each>



					</G_LIN>


					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_863>

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

	<xsl:template name="REFSupplierBuyerBatchID">
		<xsl:param name="D_127"/>
		<xsl:param name="D_352"/>
		<S_REF>
			<D_128>BT</D_128>
			<D_127>
				<xsl:value-of select="$D_127"/>
			</D_127>
			<D_352>
				<xsl:value-of select="$D_352"/>
			</D_352>
			<C_C040>
				<D_128>
					<xsl:choose>
						<xsl:when
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/SupplierBatchID != ''"
							>BT</xsl:when>
						<xsl:otherwise>LT</xsl:otherwise>
					</xsl:choose>
				</D_128>
				<D_127>
					<xsl:choose>
						<xsl:when
							test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/SupplierBatchID != ''">
							<xsl:value-of
								select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/SupplierBatchID"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/BuyerBatchID"
							/>
						</xsl:otherwise>
					</xsl:choose>
				</D_127>
				<xsl:if
					test="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/SupplierBatchID != '' and cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/BuyerBatchID != ''">
					<D_128_2>LT</D_128_2>
					<D_127_2>
						<xsl:value-of
							select="cXML/Request/QualityInspectionRequest/QualityInspectionRequestHeader/Batch/BuyerBatchID"
						/>
					</D_127_2>
				</xsl:if>
			</C_C040>
		</S_REF>
	</xsl:template>

	<xsl:template name="create_QIR_N1">
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
				<D_98>
					<xsl:value-of select="$role"/>
				</D_98>
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
			<xsl:call-template name="createN2N3N4_FromAddress">
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
			<xsl:call-template name="createCom_QIR">
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
	<xsl:template name="createCom_QIR">
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
				<xsl:element name="G_PER">
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
								<xsl:element name="D_365">
									<xsl:value-of select="./@type"/>
								</xsl:element>
								<xsl:element name="D_364">
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
				</xsl:element>
			</xsl:for-each-group>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template name="createContact_QIR">
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
				<D_98>
					<xsl:value-of select="$role"/>
				</D_98>
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
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount = 3">
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
						</D_93>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount &gt; 3">
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
						</D_93>
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
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount = 2">
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount = 3">
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
						</D_166>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount &gt; 3">
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
						</D_166>
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
			<xsl:call-template name="createCom_QIR">
				<xsl:with-param name="party" select="$party"/>
			</xsl:call-template>
		</G_N1>
	</xsl:template>





</xsl:stylesheet>
