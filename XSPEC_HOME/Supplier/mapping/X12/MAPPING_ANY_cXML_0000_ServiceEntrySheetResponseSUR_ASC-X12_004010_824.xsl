<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anMPLID" select="'input from flow'"/>
	<xsl:param name="anCorrelationID"/>
	<xsl:param name="anDocReferenceID"/>
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
	<!-- xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
		<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_X12_4010.xml')"/>
	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:824:004010">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>AG</D_479>
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
				<M_824>
					<S_ST>
						<D_143>824</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BGN>
						<D_353>00</D_353>
						<D_127>
							<xsl:value-of select="concat('CN', $anICNValue)"/>
						</D_127>
						<D_373>
							<xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
						</D_373>
						<D_337>
							<xsl:value-of select="format-dateTime($dateNow, '[H01][m01][s01]')"/>
						</D_337>
					</S_BGN>
					<!-- 08202018 CG : keep variable to use on validations -->
					<xsl:variable name="responseType">
						<xsl:choose>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/DocumentStatus/@type)) = 'approved'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/DocumentStatus/@type)) = 'accepted'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/DocumentStatus/@type)) = 'processing'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/DocumentStatus/@type)) = 'rejected'">TR</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/DocumentStatus/@type)) = 'declined'">TR</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/DocumentStatus/@type)) = 'canceled'">TR</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'approved'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'accepted'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'paid'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'paying'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'reconciled'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'processing'">TA</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'cancelled'">TR</xsl:when>
							<xsl:when test="normalize-space(lower-case(cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)) = 'rejected'">TR</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<G_OTI>
						<S_OTI>
							<D_110>
								<xsl:value-of select="$responseType"/>
							</D_110>
							<D_128>
								<xsl:choose>
									<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType = 'ServiceEntryRequest'">ACE</xsl:when>
									<xsl:otherwise>TN</xsl:otherwise>
								</xsl:choose>
							</D_128>
							<D_127>
								<xsl:choose>
									<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID) != ''">
										<xsl:value-of select="substring(normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID), 1, 30)"/>
									</xsl:when>
									<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID) != ''">
										<xsl:value-of select="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID)"/>
									</xsl:when>
									<!-- 08202018 CG: if not doc number, transaction should fail xsl:otherwise>Unknown</xsl:otherwise-->
								</xsl:choose>
							</D_127>
							<xsl:choose>
								<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType) = 'ShipNoticeDocument'">
									<D_143>856</D_143>
								</xsl:when>
								<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType) = 'InvoiceDetailRequest'">
									<D_143>810</D_143>
								</xsl:when>
								<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType) = 'ConfirmationStatusUpdate'">
									<D_143>855</D_143>
								</xsl:when>
								<xsl:when test="cXML/Request/StatusUpdateRequest/InvoiceStatus">
									<D_143>810</D_143>
								</xsl:when>
							</xsl:choose>
							<!-- IG-7865 -->
							<D_306>2</D_306>
							<!-- Need to cross check this -->
							<xsl:choose>
								<xsl:when test="$responseType = 'TA'">
									<D_641>C20</D_641>
								</xsl:when>
								<xsl:when test="$responseType = 'TR'">
									<D_641>REJ</D_641>
								</xsl:when>
								<xsl:when test="matches(normalize-space(cXML/Request/StatusUpdateRequest/Status/@code), '[5][0-9][0-9]')">
									<D_641>P01</D_641>
								</xsl:when>
								<xsl:otherwise>
									<D_641>RUN</D_641>
								</xsl:otherwise>
							</xsl:choose>
						</S_OTI>
						<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID) != '' or normalize-space(cXML/Request//StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID) != ''">
							<S_REF>
								<D_128>TN</D_128>
								<D_127>DocumentID</D_127>
								<D_352>
									<xsl:choose>
										<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID)">
											<xsl:value-of select="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID)"/>
										</xsl:when>
										<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID)">
											<xsl:value-of select="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID)"/>
										</xsl:when>
									</xsl:choose>
								</D_352>
							</S_REF>
						</xsl:if>
						<!--IG-7602 -->
						<xsl:if test="normalize-space(/cXML/Request/StatusUpdateRequest/DocumentStatus/@type) != '' or normalize-space(/cXML/Request/StatusUpdateRequest/InvoiceStatus/@type) != ''">
							<S_REF>
								<D_128>ACC</D_128>
								<D_127>
									<xsl:choose>
										<xsl:when test="normalize-space(/cXML/Request/StatusUpdateRequest/DocumentStatus/@type) != ''">
											<xsl:value-of select="normalize-space(/cXML/Request/StatusUpdateRequest/DocumentStatus/@type)"/>
										</xsl:when>
										<xsl:when test="normalize-space(/cXML/Request/StatusUpdateRequest/InvoiceStatus/@type) != ''">
											<xsl:value-of select="normalize-space(/cXML/Request/StatusUpdateRequest/InvoiceStatus/@type)"/>
										</xsl:when>
									</xsl:choose>
								</D_127>
								<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/Status) != ''">
									<D_352>
										<xsl:value-of select="normalize-space(cXML/Request/StatusUpdateRequest/Status)"/>
									</D_352>
								</xsl:if>
							</S_REF>
						</xsl:if>

						<xsl:if test="$responseType = 'TA' and normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/Comments) != ''">
							<xsl:call-template name="createREF">
								<xsl:with-param name="qual" select="'L1'"/>
								<xsl:with-param name="ref03" select="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/Comments)"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="$responseType = 'TA' and normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/Comments) != ''">
							<xsl:call-template name="createREF">
								<xsl:with-param name="qual" select="'L1'"/>
								<xsl:with-param name="ref03" select="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/Comments)"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate) != ''">
							<S_DTM>
								<D_374>102</D_374>
								<xsl:call-template name="convertAribaDate">
									<xsl:with-param name="dateTime" select="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate)"/>
									<xsl:with-param name="useTZ" select="'true'"/>
								</xsl:call-template>
							</S_DTM>
						</xsl:if>
						<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceDate) != ''">
							<S_DTM>
								<D_374>102</D_374>
								<xsl:call-template name="convertAribaDate">
									<xsl:with-param name="dateTime" select="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceDate)"/>
									<xsl:with-param name="useTZ" select="'true'"/>
								</xsl:call-template>
							</S_DTM>
						</xsl:if>
						<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/@paymentNetDueDate) != ''">
							<S_DTM>
								<D_374>814</D_374>
								<xsl:call-template name="convertAribaDate">
									<xsl:with-param name="dateTime" select="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/@paymentNetDueDate)"/>
									<xsl:with-param name="useTZ" select="'true'"/>
								</xsl:call-template>
							</S_DTM>
						</xsl:if>
						<xsl:if test="$responseType != 'TA'">
							<G_TED>
								<S_TED>
									<D_647>ZZZ</D_647>
									<xsl:choose>
										<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/Status/@text) != ''">
											<D_3>
												<xsl:value-of select="substring(normalize-space(cXML/Request/StatusUpdateRequest/Status/@text), 1, 60)"/>
											</D_3>
										</xsl:when>
										<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/Status/text()) != ''">
											<D_3>
												<xsl:value-of select="substring(normalize-space(cXML/Request/StatusUpdateRequest/Status/text()), 1, 60)"/>
											</D_3>
										</xsl:when>
									</xsl:choose>
								</S_TED>
								<xsl:for-each select="cXML/Request/StatusUpdateRequest//Comments">
									<xsl:if test="normalize-space(.) != '' and $responseType = 'TR'">
										<xsl:variable name="comments" select="normalize-space(.)"/>

										<xsl:variable name="StrLen" select="string-length($comments)"/>
										<xsl:call-template name="NTELoop">
											<xsl:with-param name="Desc" select="$comments"/>
											<xsl:with-param name="StrLen" select="$StrLen"/>
											<xsl:with-param name="Pos" select="1"/>
											<xsl:with-param name="CurrentEndPos" select="1"/>
										</xsl:call-template>

									</xsl:if>
								</xsl:for-each>

							</G_TED>
						</xsl:if>
					</G_OTI>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_824>
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

	<xsl:template name="convertAribaDate">
		<xsl:param name="dateTime"/>
		<xsl:param name="useTZ"/>
		<D_373>
			<xsl:value-of select="replace(substring($dateTime, 0, 11), '-', '')"/>
		</D_373>
		<xsl:if test="replace(substring($dateTime, 12, 8), ':', '') != ''">
			<D_337>
				<xsl:value-of select="replace(substring($dateTime, 12, 8), ':', '')"/>
			</D_337>
		</xsl:if>
		<xsl:if test="$useTZ = 'true'">
			<xsl:variable name="timeZone" select="replace(replace(substring($dateTime, 20, 6), '\+', 'P'), '\-', 'M')"/>
			<xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
				<D_623>
					<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
				</D_623>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/cXML/Header"/>

	<xsl:template name="NTELoop">
		<xsl:param name="Desc"/>
		<xsl:param name="StrLen"/>
		<xsl:param name="Pos"/>
		<xsl:param name="CurrentEndPos"/>
		<xsl:variable name="Length" select="$Pos + 79"/>

		<S_NTE>
			<D_363>
				<xsl:text>ERN</xsl:text>
			</D_363>
			<D_352>
				<xsl:value-of select="substring(normalize-space($Desc), $Pos, 79)"/>
			</D_352>
		</S_NTE>
		<xsl:if test="$Length &lt; $StrLen">
			<xsl:call-template name="NTELoop">
				<xsl:with-param name="Pos" select="$Length"/>
				<xsl:with-param name="Desc" select="$Desc"/>
				<xsl:with-param name="StrLen" select="$StrLen"/>
				<xsl:with-param name="CurrentEndPos" select="$Pos"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
