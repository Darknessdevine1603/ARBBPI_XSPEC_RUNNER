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
	<!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
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
					<D_479>NC</D_479>
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
				<M_842>
					<S_ST>
						<D_143>842</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BNR>
						<D_353>
							<xsl:choose>
								<xsl:when
									test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@operation = 'new'">
									<xsl:text>00</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>05</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</D_353>
						<D_127>
							<xsl:value-of
								select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@requestID"
							/>
						</D_127>
						<D_373>
							<xsl:value-of
								select="replace(substring-before(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@requestDate, 'T'), '-', '')"
							/>
						</D_373>
						<D_337>
							<xsl:value-of
								select="replace(substring(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@requestDate, 12, 8), ':', '')"
							/>
						</D_337>
					</S_BNR>
					<xsl:if
						test="normalize-space(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@externalRequestID) != ''">
						<S_REF>
							<D_128>NJ</D_128>
							<D_127>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@externalRequestID), 1, 30)"
								/>
							</D_127>
						</S_REF>
					</xsl:if>
					<xsl:if
						test="normalize-space(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@requestVersion) != ''">
						<S_REF>
							<D_128>V0</D_128>
							<D_127>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@requestVersion), 1, 30)"
								/>
							</D_127>
						</S_REF>
					</xsl:if>

					<xsl:if
						test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@status">
						<S_REF>
							<D_128>ACC</D_128>
							<D_352>
								<xsl:value-of
									select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@status"
								/>
							</D_352>
						</S_REF>
					</xsl:if>
					<!--xsl:if test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/DocumentReference/@payloadID">
						<S_REF>
							<D_128>QR</D_128>
							<D_352>
								<xsl:value-of select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/DocumentReference/@payloadID"/>
							</D_352>
						</S_REF>
					</xsl:if-->

					<xsl:if
						test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Priority">
						<S_REF>
							<D_128>PH</D_128>
							<D_127>
								<xsl:value-of
									select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Priority/@level"
								/>
							</D_127>
							<D_352>
								<xsl:value-of
									select="substring(normalize-space(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Priority/Description), 1, 80)"
								/>
							</D_352>
						</S_REF>
					</xsl:if>

					<xsl:if
						test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentID != ''">

						<S_REF>
							<xsl:choose>
								<xsl:when
									test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentType = 'PurchaseOrder'">
									<D_128>PO</D_128>
								</xsl:when>
								<xsl:otherwise>
									<D_128>MA</D_128>
								</xsl:otherwise>
							</xsl:choose>


							<D_127>
								<xsl:value-of
									select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentID"
								/>
							</D_127>
							<C_C040>
								<D_128>LI</D_128>
								<D_127>
									<xsl:value-of
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReferenceDocumentInfo/@lineNumber"
									/>
								</D_127>
							</C_C040>
						</S_REF>

						<xsl:variable name="DTMqual">
							<xsl:choose>
								<xsl:when
									test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentType = 'PurchaseOrder'">
									<xsl:text>004</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>111</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">
								<xsl:value-of select="$DTMqual"/>
							</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReferenceDocumentInfo/DocumentInfo/@documentDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>



					<xsl:if
						test="exists(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ShipTo)">
						<xsl:call-template name="createN1">
							<xsl:with-param name="party"
								select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ShipTo"
							/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if
						test="exists(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/BillTo)">
						<xsl:call-template name="createN1">
							<xsl:with-param name="party"
								select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/BillTo"
							/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each
						select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Contact">
						<xsl:call-template name="createContact">
							<xsl:with-param name="party" select="."/>
							<xsl:with-param name="sprole" select="'QN'"/>
						</xsl:call-template>
					</xsl:for-each>

					<G_HL>
						<S_HL>
							<D_628>1</D_628>
							<D_735>RP</D_735>
							<D_736>
								<xsl:choose>
									<xsl:when
										test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestItem">
										<xsl:text>1</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>0</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</D_736>
						</S_HL>
						<S_LIN>

							<D_235>VP</D_235>
							<D_234>
								<xsl:value-of
									select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/ItemID/SupplierPartID"
								/>
							</D_234>
							<xsl:choose>
								<xsl:when
									test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/ItemID/BuyerPartID != ''">
									<D_235_2>BP</D_235_2>
									<D_234_2>
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/ItemID/BuyerPartID"
										/>
									</D_234_2>
									<xsl:if
										test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID != ''">
										<D_235_3>VS</D_235_3>
										<D_234_3>
											<xsl:value-of
												select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID"
											/>
										</D_234_3>
									</xsl:if>
								</xsl:when>
								<xsl:when
									test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID != ''">
									<D_235_2>VS</D_235_2>
									<D_234_2>
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/ItemID/SupplierPartAuxiliaryID"
										/>
									</D_234_2>
								</xsl:when>
							</xsl:choose>
						</S_LIN>
						<xsl:if
							test="normalize-space(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/Description) != ''">
							<S_PID>
								<D_349>F</D_349>
								<D_352>
									<xsl:value-of
										select="substring(normalize-space(cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/Description), 1, 80)"
									/>
								</D_352>
								<xsl:if
									test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/Description/@xml:lang != ''">
									<D_819>
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/Description/@xml:lang"
										/>
									</D_819>
								</xsl:if>
							</S_PID>
						</xsl:if>


						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/@productionDate">

							<xsl:call-template name="createDTM">
								<xsl:with-param name="D374_Qual">405</xsl:with-param>
								<xsl:with-param name="cXMLDate">
									<xsl:value-of
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/@productionDate"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/@expirationDate">


							<xsl:call-template name="createDTM">
								<xsl:with-param name="D374_Qual">036</xsl:with-param>
								<xsl:with-param name="cXMLDate">
									<xsl:value-of
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/@expirationDate"
									/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/SupplierBatchID != ''">
							<S_REF>
								<D_128>BT</D_128>
								<D_127>
									<xsl:value-of
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/SupplierBatchID"
									/>
								</D_127>
							</S_REF>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/BuyerBatchID != ''">
							<S_REF>
								<D_128>LT</D_128>
								<D_127>
									<xsl:value-of
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/Batch/BuyerBatchID"
									/>
								</D_127>
							</S_REF>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@serialNumber != ''">
							<S_REF>
								<D_128>SE</D_128>
								<D_127>
									<xsl:value-of
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@serialNumber"
									/>
								</D_127>
							</S_REF>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@returnAuthorizationNumber != ''">
							<S_REF>
								<D_128>RZ</D_128>
								<D_127>
									<xsl:value-of
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@returnAuthorizationNumber"
									/>
								</D_127>
							</S_REF>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@itemCategory = 'subcontract'">
							<S_REF>
								<D_128>8X</D_128>
								<D_352>subcontract</D_352>
							</S_REF>
						</xsl:if>

						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/@quantity != ''">
							<S_QTY>
								<D_673>38</D_673>
								<D_380>
									<xsl:call-template name="formatQty">
										<xsl:with-param name="qty"
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/@quantity"
										/>
									</xsl:call-template>

								</D_380>
								<xsl:variable name="uom"
									select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ItemInfo/UnitOfMeasure"/>
								<xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code != ''">

									<C_C001>
										<D_355>
											<xsl:value-of
												select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code"/>
										</D_355>
									</C_C001>
								</xsl:if>
							</S_QTY>
						</xsl:if>
						<xsl:if
							test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@minimumRequiredTasks">
							<G_SPS>
								<S_SPS>
									<D_609>
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@minimumRequiredTasks"
										/>
									</D_609>
									<xsl:if
										test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@minimumRequiredActivities">
										<D_609_2>
											<xsl:value-of
												select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@minimumRequiredActivities"
											/>
										</D_609_2>
									</xsl:if>
								</S_SPS>
							</G_SPS>
						</xsl:if>


						<G_NCD>
							<S_NCD>
								<D_936>52</D_936>
								<D_350>1</D_350>
							</S_NCD>
							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@discoveryDate">

								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">516</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@discoveryDate"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>

							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@returnDate">

								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">324</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/@returnDate"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/RequestedProcessingPeriod/Period/@startDate">


								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">RSD</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/RequestedProcessingPeriod/Period/@startDate"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>

							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/RequestedProcessingPeriod/Period/@endDate">

								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">RFD</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/RequestedProcessingPeriod/Period/@endDate"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/MalfunctionPeriod/Period/@startDate">

								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">193</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/MalfunctionPeriod/Period/@startDate"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/MalfunctionPeriod/Period/@endDate">

								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">194</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of
											select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/MalfunctionPeriod/Period/@endDate"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:for-each
								select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/QNCode">
								<xsl:call-template name="REF-QNCode">
									<xsl:with-param name="QNCode" select="."/>
								</xsl:call-template>
							</xsl:for-each>
							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ComplainQuantity">

								<S_QTY>
									<D_673>86</D_673>
									<D_380>
										<xsl:call-template name="formatQty">
											<xsl:with-param name="qty"
												select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ComplainQuantity/@quantity"
											/>
										</xsl:call-template>

									</D_380>
									<xsl:variable name="uom"
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ComplainQuantity/UnitOfMeasure"/>
									<xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code != ''">

										<C_C001>
											<D_355>
												<xsl:value-of
													select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code"/>
											</D_355>
										</C_C001>
									</xsl:if>
								</S_QTY>
							</xsl:if>

							<xsl:if
								test="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReturnQuantity">
								<S_QTY>
									<D_673>76</D_673>
									<D_380>
										<xsl:call-template name="formatQty">
											<xsl:with-param name="qty"
												select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReturnQuantity/@quantity"
											/>
										</xsl:call-template>

									</D_380>
									<xsl:variable name="uom"
										select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/ReturnQuantity/UnitOfMeasure"/>
									<xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code != ''">
										<C_C001>
											<D_355>
												<xsl:value-of
													select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom][1]/X12Code"/>
											</D_355>
										</C_C001>
									</xsl:if>
								</S_QTY>
							</xsl:if>

							<xsl:for-each
								select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/QNNotes">



								<G_N1>
									<S_N1>
										<D_98>QQ</D_98>
									</S_N1>
									<S_REF>
										<D_128>JD</D_128>
										<D_127>
											<xsl:value-of select="substring(normalize-space(@user), 1, 30)"/>
										</D_127>
										<D_352>
											<xsl:value-of select="translate(substring(@createDate, 1, 19), '-T:', '')"/>
										</D_352>
									</S_REF>
									<xsl:for-each select="QNCode">
										<xsl:call-template name="REF-QNCode">
											<xsl:with-param name="QNCode" select="."/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:choose>
										<xsl:when test="normalize-space(Description/ShortName) != ''">
											<S_REF>
												<D_128>L1</D_128>
												<D_352>
													<xsl:value-of
														select="substring(normalize-space(Description/ShortName), 1, 80)"/>
												</D_352>
											</S_REF>
										</xsl:when>
										<xsl:when test="normalize-space(Description) != ''">
											<S_REF>
												<D_128>L1</D_128>
												<D_352>
													<xsl:value-of select="substring(normalize-space(Description), 1, 80)"/>
												</D_352>
											</S_REF>
										</xsl:when>
									</xsl:choose>

									<xsl:if test="normalize-space(Attachment/URL) != ''">
										<S_REF>
											<D_128>E9</D_128>
											<D_352>
												<xsl:value-of select="substring(normalize-space(Attachment/URL), 1, 80)"/>
											</D_352>
										</S_REF>
									</xsl:if>
								</G_N1>
							</xsl:for-each>
							<xsl:for-each
								select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/QualityNotificationTask">
								<xsl:call-template name="BuildNCA">
									<xsl:with-param name="domain" select="'task'"/>
									<xsl:with-param name="QNDetails" select="."/>
								</xsl:call-template>
							</xsl:for-each>

							<xsl:for-each
								select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestHeader/QualityNotificationActivity">
								<xsl:call-template name="BuildNCA">
									<xsl:with-param name="domain" select="'activity'"/>
									<xsl:with-param name="QNDetails" select="."/>
								</xsl:call-template>
							</xsl:for-each>
						</G_NCD>
					</G_HL>
					<xsl:for-each
						select="cXML/Request/QualityNotificationRequest/QualityNotificationRequestItem">
						<xsl:variable name="curHLParentPos" select="position() + 1"/>
						<xsl:variable name="totalHLParent" select="count(..//QualityNotificationRequestItem)"/>
						<G_HL>
							<S_HL>
								<D_628>
									<xsl:value-of select="$curHLParentPos"/>
								</D_628>
								<D_734>1</D_734>
								<D_735>I</D_735>
								<D_736>
									<xsl:choose>
										<xsl:when test="AdditionalQNInfo">
											<xsl:text>1</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>0</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</D_736>
							</S_HL>
							<xsl:if test="@minimumRequiredTasks != ''">
								<G_SPS>
									<S_SPS>
										<D_609>
											<xsl:value-of select="@minimumRequiredTasks"/>
										</D_609>
										<xsl:if test="@minimumRequiredActivities != ''">
											<D_609_1>
												<xsl:value-of select="@minimumRequiredActivities"/>
											</D_609_1>
										</xsl:if>
										<xsl:if test="@minimumRequiredCauses != ''">
											<D_609_2>
												<xsl:value-of select="@minimumRequiredCauses"/>
											</D_609_2>
										</xsl:if>
									</S_SPS>
								</G_SPS>
							</xsl:if>
							<xsl:if test="@defectId != ''">
								<G_NCD>

									<S_NCD>
										<D_936>52</D_936>
										<D_350>
											<xsl:value-of select="@defectId"/>
										</D_350>
									</S_NCD>

									<xsl:if test="normalize-space(Description/ShortName) != ''">
										<S_NTE>
											<D_363>NCD</D_363>
											<D_352>
												<xsl:value-of
													select="substring(normalize-space(Description/ShortName), 1, 80)"/>
											</D_352>
										</S_NTE>
									</xsl:if>
									<xsl:if test="Period/@startDate">

										<xsl:call-template name="createDTM">
											<xsl:with-param name="D374_Qual">193</xsl:with-param>
											<xsl:with-param name="cXMLDate">
												<xsl:value-of select="Period/@startDate"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="Period/@endDate">

										<xsl:call-template name="createDTM">
											<xsl:with-param name="D374_Qual">194</xsl:with-param>
											<xsl:with-param name="cXMLDate">
												<xsl:value-of select="Period/@endDate"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="@completedDate">

										<xsl:call-template name="createDTM">
											<xsl:with-param name="D374_Qual">198</xsl:with-param>
											<xsl:with-param name="cXMLDate">
												<xsl:value-of select="@completedDate"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="@isCompleted = 'yes'">

										<S_REF>
											<D_128>ACC</D_128>
											<D_352>complete</D_352>
										</S_REF>
									</xsl:if>
									<xsl:for-each select="QNCode">
										<xsl:call-template name="REF-QNCode">
											<xsl:with-param name="QNCode" select="."/>
										</xsl:call-template>
									</xsl:for-each>

									<xsl:if test="@defectCount != ''">
										<S_QTY>
											<D_673>TO</D_673>
											<D_380>
												<xsl:value-of select="@defectCount"/>
											</D_380>
										</S_QTY>
									</xsl:if>
									<xsl:for-each select="OwnerInfo[@role = 'customer' or @role = 'supplier']">
										<G_N1>
											<S_N1>
												<D_98>
													<xsl:choose>
														<xsl:when test="@role = 'customer'">
															<xsl:text>BY</xsl:text>
														</xsl:when>
														<xsl:when test="@role = 'supplier'">
															<xsl:text>SU</xsl:text>
														</xsl:when>
													</xsl:choose>
												</D_98>
												<D_66>92</D_66>
												<D_67>
													<xsl:value-of select="@owner"/>
												</D_67>
											</S_N1>
										</G_N1>
									</xsl:for-each>
									<xsl:for-each select="QualityNotificationTask">
										<xsl:call-template name="BuildNCA">
											<xsl:with-param name="domain" select="'task'"/>
											<xsl:with-param name="QNDetails" select="."/>
										</xsl:call-template>
									</xsl:for-each>

									<xsl:for-each select="QualityNotificationActivity">
										<xsl:call-template name="BuildNCA">
											<xsl:with-param name="domain" select="'activity'"/>
											<xsl:with-param name="QNDetails" select="."/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="QualityNotificationCause">
										<xsl:call-template name="BuildNCA">
											<xsl:with-param name="domain" select="'cause'"/>
											<xsl:with-param name="QNDetails" select="."/>
										</xsl:call-template>
									</xsl:for-each>
								</G_NCD>
							</xsl:if>
						</G_HL>
						<xsl:for-each select="AdditionalQNInfo">
							<xsl:variable name="curHLChildPos" select="position() + 1"/>

							<G_HL>
								<S_HL>
									<D_628>
										<xsl:value-of select="$curHLChildPos + $totalHLParent"/>
									</D_628>
									<D_734>
										<xsl:value-of select="$curHLParentPos"/>
									</D_734>
									<D_735>F</D_735>
									<D_736>0</D_736>
								</S_HL>
								<S_LIN>
									<D_350>
										<xsl:value-of select="@lineNumber"/>
									</D_350>
									<D_235>VP</D_235>
									<D_234>
										<xsl:value-of select="ItemID/SupplierPartID"/>
									</D_234>
									<xsl:choose>
										<xsl:when test="ItemID/BuyerPartID != ''">
											<D_235_2>BP</D_235_2>
											<D_234_2>
												<xsl:value-of select="ItemID/BuyerPartID"/>
											</D_234_2>
											<xsl:if test="ItemID/SupplierPartAuxiliaryID != ''">
												<D_235_3>VS</D_235_3>
												<D_234_3>
													<xsl:value-of select="ItemID/SupplierPartAuxiliaryID"/>
												</D_234_3>
											</xsl:if>
										</xsl:when>
										<xsl:when test="ItemID/SupplierPartAuxiliaryID != ''">
											<D_235_2>VS</D_235_2>
											<D_234_2>
												<xsl:value-of select="ItemID/SupplierPartAuxiliaryID"/>
											</D_234_2>
										</xsl:when>
									</xsl:choose>
								</S_LIN>
								<xsl:if test="Batch/@productionDate">

									<xsl:call-template name="createDTM">
										<xsl:with-param name="D374_Qual">405</xsl:with-param>
										<xsl:with-param name="cXMLDate">
											<xsl:value-of select="Batch/@productionDate"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="Batch/@expirationDate">

									<xsl:call-template name="createDTM">
										<xsl:with-param name="D374_Qual">036</xsl:with-param>
										<xsl:with-param name="cXMLDate">
											<xsl:value-of select="Batch/@expirationDate"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="Batch/SupplierBatchID != ''">
									<S_REF>
										<D_128>BT</D_128>
										<D_127>
											<xsl:value-of select="Batch/SupplierBatchID"/>
										</D_127>
									</S_REF>
								</xsl:if>
								<xsl:if test="Batch/BuyerBatchID != ''">
									<S_REF>
										<D_128>LT</D_128>
										<D_127>
											<xsl:value-of select="Batch/BuyerBatchID"/>
										</D_127>
									</S_REF>
								</xsl:if>
								<xsl:if test="ItemID/IdReference[@domain = 'buyerLocationID']">
									<xsl:variable name="domain">
										<xsl:value-of select="ItemID/IdReference[@domain = 'buyerLocationID']/@domain"/>
									</xsl:variable>
									<xsl:variable name="identifier">
										<xsl:value-of select="ItemID/IdReference[@domain = 'buyerLocationID']/@identifier"/>
									</xsl:variable>
									<xsl:variable name="Descr">
										<xsl:value-of select="ItemID/IdReference[@domain = 'buyerLocationID']/Description"/>
									</xsl:variable>
									<xsl:if
										test="normalize-space($identifier) != '' and $Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain][1]/X12Code != ''">
										<S_REF>
											<D_128>
												<xsl:value-of
													select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain][1]/X12Code"
												/>
											</D_128>
											<D_127>
												<xsl:value-of select="substring(normalize-space($identifier), 1, 30)"/>
											</D_127>
											<xsl:if test="$Descr != ''">												
												<D_352>
													<xsl:value-of select="substring(normalize-space($Descr), 1, 80)"/>
												</D_352>
											</xsl:if>
										</S_REF>
									</xsl:if>
								</xsl:if>
								<xsl:if test="ItemID/IdReference[@domain = 'supplierLocationID']">
									<xsl:variable name="domain">
										<xsl:value-of select="ItemID/IdReference[@domain = 'supplierLocationID']/@domain"/>
									</xsl:variable>
									<xsl:variable name="identifier">
										<xsl:value-of select="ItemID/IdReference[@domain = 'supplierLocationID']/@identifier"/>
									</xsl:variable>
									<xsl:variable name="Descr">
										<xsl:value-of select="ItemID/IdReference[@domain = 'supplierLocationID']/Description"/>
									</xsl:variable>									
									<xsl:if
										test="normalize-space($identifier) != '' and $Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain][1]/X12Code != ''">
										<S_REF>
											<D_128>
												<xsl:value-of
													select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain][1]/X12Code"
												/>
											</D_128>
											<D_127>
												<xsl:value-of select="substring(normalize-space($identifier), 1, 30)"/>
											</D_127>
											<xsl:if test="$Descr != ''">												
												<D_352>
													<xsl:value-of select="substring(normalize-space($Descr), 1, 80)"/>
												</D_352>
											</xsl:if>
										</S_REF>
									</xsl:if>
								</xsl:if>
								<xsl:if test="ItemID/IdReference[@domain = 'storageLocation']">
									<xsl:variable name="domain">
										<xsl:value-of select="ItemID/IdReference[@domain = 'storageLocation']/@domain"/>
									</xsl:variable>
									<xsl:variable name="identifier">
										<xsl:value-of select="ItemID/IdReference[@domain = 'storageLocation']/@identifier"/>
									</xsl:variable>
									<xsl:variable name="Descr">
										<xsl:value-of select="ItemID/IdReference[@domain = 'storageLocation']/Description"/>
									</xsl:variable>
									<xsl:if
										test="normalize-space($identifier) != '' and $Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain][1]/X12Code != ''">
										<S_REF>
											<D_128>
												<xsl:value-of
													select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain][1]/X12Code"
												/>
											</D_128>
											<D_127>
												<xsl:value-of select="substring(normalize-space($identifier), 1, 30)"/>
											</D_127>
											<xsl:if test="$Descr != ''">												
												<D_352>
													<xsl:value-of select="substring(normalize-space($Descr), 1, 80)"/>
												</D_352>
											</xsl:if>
										</S_REF>
									</xsl:if>
								</xsl:if>								
							</G_HL>
						</xsl:for-each>
					</xsl:for-each>

					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_842>
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
	<xsl:template name="BuildNCA">
		<xsl:param name="domain"/>
		<xsl:param name="QNDetails"/>

		<G_NCA>
			<S_NCA>
				<D_350>
					<xsl:choose>
						<xsl:when test="$QNDetails/@taskId">
							<xsl:value-of select="$QNDetails/@taskId"/>
						</xsl:when>
						<xsl:when test="$QNDetails/@activityId">
							<xsl:value-of select="$QNDetails/@activityId"/>
						</xsl:when>
						<xsl:when test="$QNDetails/@causeId">
							<xsl:value-of select="$QNDetails/@causeId"/>
						</xsl:when>
					</xsl:choose>
				</D_350>
				<D_352>
					<xsl:value-of select="$domain"/>
				</D_352>
			</S_NCA>
			<xsl:if
				test="normalize-space($QNDetails/Description/ShortName) != '' or normalize-space($QNDetails/Description) != ''">
				<S_NTE>
					<D_363>
						<xsl:choose>
							<xsl:when test="$domain = 'task'">
								<xsl:text>TES</xsl:text>
							</xsl:when>
							<xsl:when test="$domain = 'activity'">
								<xsl:text>REG</xsl:text>
							</xsl:when>
							<xsl:when test="$domain = 'cause'">
								<xsl:text>DEP</xsl:text>
							</xsl:when>
						</xsl:choose>
					</D_363>
					<D_352>
						<xsl:choose>
							<xsl:when test="normalize-space($QNDetails/Description/ShortName) != ''">
								<xsl:value-of
									select="substring(normalize-space($QNDetails/Description/ShortName), 1, 80)"/>
							</xsl:when>
							<xsl:when test="normalize-space($QNDetails/Description) != ''">
								<xsl:value-of select="substring(normalize-space($QNDetails/Description), 1, 80)"/>
							</xsl:when>
						</xsl:choose>

					</D_352>
				</S_NTE>
			</xsl:if>
			<xsl:if test="$QNDetails/Period/@startDate">

				<xsl:call-template name="createDTM">
					<xsl:with-param name="D374_Qual">193</xsl:with-param>
					<xsl:with-param name="cXMLDate">
						<xsl:value-of select="$QNDetails/Period/@startDate"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$QNDetails/Period/@endDate">

				<xsl:call-template name="createDTM">
					<xsl:with-param name="D374_Qual">194</xsl:with-param>
					<xsl:with-param name="cXMLDate">
						<xsl:value-of select="$QNDetails/Period/@endDate"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$QNDetails/@completedDate">

				<xsl:call-template name="createDTM">
					<xsl:with-param name="D374_Qual">198</xsl:with-param>
					<xsl:with-param name="cXMLDate">
						<xsl:value-of select="$QNDetails/@completedDate"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$QNDetails/@status">
					<S_REF>
						<D_128>ACC</D_128>
						<D_352>
							<xsl:value-of select="$QNDetails/@status"/>
						</D_352>
					</S_REF>
				</xsl:when>
				<xsl:when test="$QNDetails/@isCompleted = 'yes'">
					<S_REF>
						<D_128>ACC</D_128>
						<D_352>
							<xsl:value-of select="'complete'"/>
						</D_352>
					</S_REF>
				</xsl:when>
			</xsl:choose>
			<xsl:for-each select="$QNDetails/QNCode">
				<xsl:call-template name="REF-QNCode">
					<xsl:with-param name="QNCode" select="."/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:if test="normalize-space($QNDetails/@processorName) != ''">

				<G_N1>
					<S_N1>
						<D_98>QD</D_98>
						<D_93>
							<xsl:value-of select="substring(normalize-space($QNDetails/@processorName), 1, 60)"/>
						</D_93>
						<xsl:if test="normalize-space($QNDetails/@processorId) != ''">
							<D_66>92</D_66>
							<D_67>
								<xsl:value-of select="normalize-space($QNDetails/@processorId)"/>
							</D_67>
						</xsl:if>
						<xsl:if
							test="normalize-space($QNDetails/@processorType) != '' and (normalize-space($QNDetails/@processorType) = 'customer' or normalize-space($QNDetails/@processorType) = 'supplier' or normalize-space($QNDetails/@processorType) = 'customerUser')">

							<D_98_2>
								<xsl:choose>
									<xsl:when test="normalize-space($QNDetails/@processorType) = 'customer'">
										<xsl:text>BY</xsl:text>
									</xsl:when>
									<xsl:when test="normalize-space($QNDetails/@processorType) = 'supplier'">
										<xsl:text>SU</xsl:text>
									</xsl:when>
									<xsl:when test="normalize-space($QNDetails/@processorType) = 'customerUser'">
										<xsl:text>EN</xsl:text>
									</xsl:when>
								</xsl:choose>
							</D_98_2>
						</xsl:if>
					</S_N1>
				</G_N1>
			</xsl:if>
			<xsl:if test="normalize-space($QNDetails/@completedBy) != ''">

				<G_N1>
					<S_N1>
						<D_98>K9</D_98>
						<D_66>92</D_66>
						<D_67>
							<xsl:value-of select="substring(normalize-space($QNDetails/@completedBy), 1, 80)"/>
						</D_67>
					</S_N1>
				</G_N1>
			</xsl:if>
			<xsl:for-each select="$QNDetails/OwnerInfo[@role = 'customer' or @role = 'supplier']">
				<G_N1>
					<S_N1>
						<D_98>
							<xsl:choose>
								<xsl:when test="@role = 'customer'">
									<xsl:text>BY</xsl:text>
								</xsl:when>
								<xsl:when test="@role = 'supplier'">
									<xsl:text>SU</xsl:text>
								</xsl:when>
							</xsl:choose>
						</D_98>
						<D_66>92</D_66>
						<D_67>
							<xsl:value-of select="substring(normalize-space(@owner), 1, 80)"/>
						</D_67>
					</S_N1>
				</G_N1>
			</xsl:for-each>
		</G_NCA>
	</xsl:template>
	<xsl:template name="REF-QNCode">
		<xsl:param name="QNCode"/>

		<S_REF>
			<D_128>BZ</D_128>
			<D_127>
				<xsl:value-of select="$QNCode/@code"/>
			</D_127>
			<xsl:if test="normalize-space($QNCode/@codeDescription) != ''">
				<D_352>
					<xsl:value-of select="substring(normalize-space($QNCode/@codeDescription), 1, 80)"/>
				</D_352>
			</xsl:if>
			<C_C040>
				<D_128>H6</D_128>
				<D_127>
					<xsl:value-of select="substring(normalize-space($QNCode/@domain), 1, 30)"/>
				</D_127>
				<xsl:if test="normalize-space($QNCode/@codeGroup) != ''">
					<D_128_2>6P</D_128_2>
					<D_127_2>
						<xsl:value-of select="substring(normalize-space($QNCode/@codeGroup), 1, 30)"/>
					</D_127_2>
				</xsl:if>
				<xsl:if test="normalize-space($QNCode/@codeGroupDescription) != ''">
					<D_128_3>6P</D_128_3>
					<D_127_3>
						<xsl:value-of select="substring(normalize-space($QNCode/@codeGroupDescription), 1, 30)"
						/>
					</D_127_3>
				</xsl:if>
			</C_C040>
		</S_REF>
	</xsl:template>
</xsl:stylesheet>
