<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:004010" exclude-result-prefixes="#all" version="2.0"
                xmlns:p1="urn:sap.com:ica:typesystem:116:asc_x12:004010">
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
	<!--xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>
	<xsl:include href="Format_ASC-X12_CXML_common.xsl"/-->
	<!-- PD references -->
	<xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>


	<xsl:template match="*">
		<xsl:element name="cXML">
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<xsl:attribute name="timestamp">
				<xsl:call-template name="convertToAribaDate">
					<xsl:with-param name="Date">
						<xsl:value-of select="substring(replace(string(current-dateTime()),'-',''),1,8)"/>
					</xsl:with-param>
					<xsl:with-param name="Time">
						<xsl:value-of select="substring(replace(replace(string(current-dateTime()),'-',''),':',''),10,6)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>

			<xsl:call-template name="createcXMLHeader"/>


			<xsl:element name="Request">
				<xsl:choose>
					<xsl:when test="$anEnvName='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>


				<xsl:element name="QualityNotificationRequest">
					<xsl:element name="QualityNotificationRequestHeader">
						<xsl:attribute name="requestID">
							<xsl:value-of select="FunctionalGroup/M_842/S_BNR/D_127"/>
						</xsl:attribute>
						<xsl:if test="FunctionalGroup/M_842/S_REF[D_128='NJ']/D_127!=''">
							<xsl:attribute name="externalRequestID">
								<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='NJ']/D_127"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="requestDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="Date" select="FunctionalGroup/M_842/S_BNR/D_373"/>
								<xsl:with-param name="Time" select="FunctionalGroup/M_842/S_BNR/D_337"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:if test="FunctionalGroup/M_842/S_REF[D_128='V0']/D_127!=''">
							<xsl:attribute name="requestVersion">
								<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='V0']/D_127"/>
							</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="operation">
							<xsl:choose>
								<xsl:when test="FunctionalGroup/M_842/S_BNR/D_353 = '05'">
									<xsl:text>update</xsl:text>
								</xsl:when>
								<xsl:when test="FunctionalGroup/M_842/S_BNR/D_353 = '00'">
									<xsl:text>new</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="status">
							<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='ACC']/D_352"/>
						</xsl:attribute>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM/D_374='516'">
							<xsl:attribute name="discoveryDate">
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '516']/D_373"/>
									<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '516']/D_337"/>
									<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '516']/D_623"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>

						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM/D_374='324'">
							<xsl:attribute name="returnDate">
								<xsl:call-template name="convertToAribaDate">
									<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '324']/D_373"/>
									<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '324']/D_337"/>
									<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '324']/D_623"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='SN']/D_127!=''">
							<xsl:attribute name="serialNumber">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='SN']/D_127"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_SPS/S_SPS/D_609!=''">
							<xsl:attribute name="minimumRequiredTasks">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_SPS/S_SPS/D_609"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_SPS/S_SPS/D_609_2!=''">
							<xsl:attribute name="minimumRequiredActivities">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_SPS/S_SPS/D_609_2"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='RZ']/D_127!=''">
							<xsl:attribute name="returnAuthorizationNumber">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='RZ']/D_127"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='8X']/D_127!=''">
							<xsl:attribute name="itemCategory">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='8X']/D_127"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:for-each select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_REF[D_128='BZ']">
							<xsl:if test="D_127!='' and C_C040[D_128='H6']/D_127!=''">
								<xsl:call-template name="QNCode">
									<xsl:with-param name="QNCode_REF" select="."/>
								</xsl:call-template>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="FunctionalGroup/M_842/G_N1[S_N1/D_98='ST']">
							<ShipTo>
								<xsl:call-template name="createContact">
									<xsl:with-param name="contact" select="."/>
									<xsl:with-param name="buildAddressElement" select="'true'"/>
								</xsl:call-template>
							</ShipTo>
						</xsl:for-each>
						<xsl:for-each select="FunctionalGroup/M_842/G_N1[S_N1/D_98='BT']">
							<BillTo>
								<xsl:call-template name="createContact">
									<xsl:with-param name="contact" select="."/>
									<xsl:with-param name="buildAddressElement" select="'true'"/>
								</xsl:call-template>
							</BillTo>
						</xsl:for-each>
						<xsl:for-each select="FunctionalGroup/M_842/G_N1[S_N1/D_98!='ST' and S_N1/D_98!='BT']">
							<xsl:call-template name="createContact">
								<xsl:with-param name="contact" select="."/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1/S_N1/D_98='QQ'">
							<xsl:element name="QNNotes">
								<xsl:attribute name="user">
									<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1/S_REF[D_128='JD']/D_127"/>
								</xsl:attribute>
								<xsl:attribute name="createDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="Date" select="substring(FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1/S_REF[D_128='JD']/D_352,1,8)"/>
										<xsl:with-param name="Time" select="substring(FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1/S_REF[D_128='JD']/D_352,8)"/>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:for-each select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1[S_N1/D_98='QQ']/S_REF[D_128='BZ']">
									<xsl:if test="D_127!='' and C_C040[D_128='H6']/D_127!=''">
										<xsl:call-template name="QNCode">
											<xsl:with-param name="QNCode_REF" select="."/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
								<xsl:element name="Description">
									<xsl:attribute name="xml:lang">
										<xsl:text>en-US</xsl:text>
									</xsl:attribute>
									<xsl:element name="ShortName">
										<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1/S_REF[D_128='L1']/D_352"/>
									</xsl:element>
								</xsl:element>
								<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1/S_REF[D_128='E9']/D_352!=''">
									<xsl:element name="Attachment">
										<xsl:element name="URL">
											<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_N1/S_REF[D_128='E9']/D_352"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:element name="Priority">
							<xsl:attribute name="level">
								<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='PH']/D_127"/>
							</xsl:attribute>
							<xsl:element name="Description">
								<xsl:attribute name="xml:lang">
									<xsl:text>en-US</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='PH']/D_352"/>
							</xsl:element>
						</xsl:element>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM/D_374='RSD' and FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM/D_374='RFD'">
							<xsl:element name="RequestedProcessingPeriod">
								<xsl:element name="Period">
									<xsl:attribute name="startDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = 'RSD']/D_373"/>
											<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = 'RSD']/D_337"/>
											<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = 'RSD']/D_623"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="endDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = 'RFD']/D_373"/>
											<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = 'RFD']/D_337"/>
											<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = 'RFD']/D_623"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM/D_374='193' and FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM/D_374='194'">

							<xsl:element name="MalfunctionPeriod">
								<xsl:element name="Period">
									<xsl:attribute name="startDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '193']/D_373"/>
											<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '193']/D_337"/>
											<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '193']/D_623"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="endDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '194']/D_373"/>
											<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '194']/D_337"/>
											<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_DTM[D_374 = '194']/D_623"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						<xsl:if test="FunctionalGroup/M_842/S_REF[D_128='QR']/D_127!=''">
							<xsl:element name="DocumentReference">
								<xsl:attribute name="payloadID">
									<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='QR']/D_127"/>
								</xsl:attribute>
							</xsl:element>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="FunctionalGroup/M_842/S_REF[D_128='PO']/D_127!='' and FunctionalGroup/M_842/S_DTM/D_374 = '004'">
								<xsl:element name="ReferenceDocumentInfo">
									<xsl:attribute name="lineNumber">
										<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='PO']/C_C040/D_127"/>
									</xsl:attribute>
									<xsl:element name="DocumentInfo">
										<xsl:attribute name="documentID">
											<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='PO']/D_127"/>
										</xsl:attribute>
										<xsl:attribute name="documentType">
											<xsl:text>PurchaseOrder</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="documentDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date" select="FunctionalGroup/M_842/S_DTM[D_374 = '004']/D_373"/>
												<xsl:with-param name="Time" select="FunctionalGroup/M_842/S_DTM[D_374 = '004']/D_337"/>
												<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/S_DTM[D_374 = '004']/D_623"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:when>
							<xsl:when test="FunctionalGroup/M_842/S_REF[D_128='MA']/D_127!='' and FunctionalGroup/M_842/S_DTM/D_374 = '111'">
								<xsl:element name="ReferenceDocumentInfo">
									<xsl:attribute name="lineNumber">
										<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='MA']/C_C040/D_127"/>
									</xsl:attribute>
									<xsl:element name="DocumentInfo">
										<xsl:attribute name="documentID">
											<xsl:value-of select="FunctionalGroup/M_842/S_REF[D_128='MA']/D_127"/>
										</xsl:attribute>
										<xsl:attribute name="documentType">
											<xsl:text>ShipNoticeRequest</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="documentDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date" select="FunctionalGroup/M_842/S_DTM[D_374 = '111']/D_373"/>
												<xsl:with-param name="Time" select="FunctionalGroup/M_842/S_DTM[D_374 = '111']/D_337"/>
												<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/S_DTM[D_374 = '111']/D_623"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
						<xsl:element name="ItemInfo">
							<xsl:attribute name="quantity">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_QTY[D_673='38']/D_380"/>
							</xsl:attribute>
							<xsl:element name="ItemID">
								<xsl:element name="SupplierPartID">
									<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235='VP']/D_234"/>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_2='VS']/D_234_2!=''">
										<xsl:element name="SupplierPartAuxiliaryID">
											<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_2='VS']/D_234_2"/>
										</xsl:element>
									</xsl:when>
									<xsl:when test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_3='VS']/D_234_3!=''">
										<xsl:element name="SupplierPartAuxiliaryID">
											<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_3='VS']/D_234_3"/>
										</xsl:element>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_2='BP']/D_234_2!=''">
										<xsl:element name="BuyerPartID">
											<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_2='BP']/D_234_2"/>
										</xsl:element>
									</xsl:when>
									<xsl:when test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_3='BP']/D_234_3!=''">
										<xsl:element name="BuyerPartID">
											<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_LIN[D_235_3='BP']/D_234_3"/>
										</xsl:element>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
							<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_PID[D_349='F']/D_352!=''">
								<xsl:element name="Description">
									<xsl:attribute name="xml:lang">
										<xsl:text>en-US</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_PID[D_349='F']/D_352"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="UnitOfMeasure">
								<xsl:variable name="uom" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_QTY[D_673='38']/C_C001/D_355"/>
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom]/CXMLCode!=''">
										<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom][1]/CXMLCode"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$uom"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:element>
						<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='BT']/D_127!='' or FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='LT']/D_127!=''">
							<xsl:element name="Batch">
								<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM/D_374='405'">
									<xsl:attribute name="productionDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM[D_374 = '405']/D_373"/>
											<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM[D_374 = '405']/D_337"/>
											<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM[D_374 = '405']/D_623"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM/D_374='036'">
									<xsl:attribute name="expirationDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="Date" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM[D_374 = '036']/D_373"/>
											<xsl:with-param name="Time" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM[D_374 = '036']/D_337"/>
											<xsl:with-param name="TimeCode" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_DTM[D_374 = '036']/D_623"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='LT']/D_127!=''">
									<xsl:element name="BuyerBatchID">
										<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='LT']/D_127"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='BT']/D_127!=''">
									<xsl:element name="SupplierBatchID">
										<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/S_REF[D_128='BT']/D_127"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:element name="ComplainQuantity">
							<xsl:attribute name="quantity">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_QTY[D_673='86']/D_380"/>
							</xsl:attribute>
							<xsl:element name="UnitOfMeasure">
								<xsl:variable name="uom" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_QTY[D_673='86']/C_C001/D_355"/>
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom]/CXMLCode!=''">
										<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom][1]/CXMLCode"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$uom"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:element>
						<xsl:element name="ReturnQuantity">
							<xsl:attribute name="quantity">
								<xsl:value-of select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_QTY[D_673='76']/D_380"/>
							</xsl:attribute>
							<xsl:element name="UnitOfMeasure">
								<xsl:variable name="uom" select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/S_QTY[D_673='76']/C_C001/D_355"/>
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom]/CXMLCode!=''">
										<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom][1]/CXMLCode"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$uom"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:element>


						<xsl:for-each select="FunctionalGroup/M_842/G_HL[S_HL/D_735='RP']/G_NCD/G_NCA[S_NCA/D_352='task' or S_NCA/D_352='activity']">
							<xsl:if test="S_NCA/D_350!=''">
								<xsl:apply-templates select="."/>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
					<xsl:for-each select="FunctionalGroup/M_842/G_HL[S_HL/D_735='I']">
						<xsl:if test="G_NCD/S_NCD/D_350!=''">
							<xsl:element name="QualityNotificationRequestItem">
								<xsl:attribute name="defectId">
									<xsl:value-of select="G_NCD/S_NCD/D_350"/>
								</xsl:attribute>
								<xsl:attribute name="defectCount">
									<xsl:value-of select="G_NCD/S_QTY[D_673='TO']/D_380"/>
								</xsl:attribute>
								<xsl:if test="G_SPS/S_SPS/D_609">
									<xsl:attribute name="minimumRequiredTasks">
										<xsl:value-of select="G_SPS/S_SPS/D_609"/>
									</xsl:attribute>
									<xsl:if test="G_SPS/S_SPS/D_609_2!=''">
										<xsl:attribute name="minimumRequiredActivities">
											<xsl:value-of select="G_SPS/S_SPS/D_609_2"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="G_SPS/S_SPS/D_609_3!=''">

										<xsl:attribute name="minimumRequiredCauses">
											<xsl:value-of select="G_SPS/S_SPS/D_609_3"/>
										</xsl:attribute>
									</xsl:if>
								</xsl:if>
								<xsl:if test="G_NCD/S_DTM/D_374='198'">
									<xsl:attribute name="completedDate">
										<xsl:call-template name="convertToAribaDate">
											<xsl:with-param name="Date" select="G_NCD/S_DTM[D_374 = '198']/D_373"/>
											<xsl:with-param name="Time" select="G_NCD/S_DTM[D_374 = '198']/D_337"/>
											<xsl:with-param name="TimeCode" select="G_NCD/S_DTM[D_374 = '198']/D_623"/>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="G_NCD/S_REF[D_128='ACC']/D_352='complete'">
									<xsl:attribute name="isCompleted">
										<xsl:value-of select="'yes'"/>
									</xsl:attribute>
								</xsl:if>
							  <xsl:for-each select="G_NCD/S_REF[D_128='BZ']"> <!--IG-28171 to refer G_NCD/S_REF path-->
									<xsl:if test="D_127!='' and C_C040[D_128='H6']/D_127!=''">
										<xsl:call-template name="QNCode">
											<xsl:with-param name="QNCode_REF" select="."/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test="G_NCD/G_N1/S_N1/D_98='BY'">
									<xsl:element name="OwnerInfo">
										<xsl:attribute name="owner">
											<xsl:value-of select="G_NCD/G_N1/S_N1/D_67"/>
										</xsl:attribute>
										<xsl:attribute name="role">
											<xsl:text>customer</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="G_NCD/G_N1/S_N1/D_98='SU'">
									<xsl:element name="OwnerInfo">
										<xsl:attribute name="owner">
											<xsl:value-of select="G_NCD/G_N1/S_N1/D_67"/>
										</xsl:attribute>
										<xsl:attribute name="role">
											<xsl:text>supplier</xsl:text>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:element name="Description">
									<xsl:attribute name="xml:lang">
										<xsl:text>en-US</xsl:text>
									</xsl:attribute>
									<xsl:element name="ShortName">
										<xsl:value-of select="G_NCD/S_NTE/D_352"/>
									</xsl:element>
								</xsl:element>
								<xsl:if test="G_NCD/S_DTM/D_374='193' and G_NCD/S_DTM/D_374='194'">

									<xsl:element name="Period">
										<xsl:attribute name="startDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date" select="G_NCD/S_DTM[D_374 = '193']/D_373"/>
												<xsl:with-param name="Time" select="G_NCD/S_DTM[D_374 = '193']/D_337"/>
												<xsl:with-param name="TimeCode" select="G_NCD/S_DTM[D_374 = '193']/D_623"/>
											</xsl:call-template>
										</xsl:attribute>
										<xsl:attribute name="endDate">
											<xsl:call-template name="convertToAribaDate">
												<xsl:with-param name="Date" select="G_NCD/S_DTM[D_374 = '194']/D_373"/>
												<xsl:with-param name="Time" select="G_NCD/S_DTM[D_374 = '194']/D_337"/>
												<xsl:with-param name="TimeCode" select="G_NCD/S_DTM[D_374 = '194']/D_623"/>
											</xsl:call-template>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:if test="S_HL/D_736='1'">
									<xsl:variable name="curLineNum" select="S_HL/D_628"></xsl:variable>
									<xsl:for-each select="../G_HL[S_HL/D_735='F'][S_HL/D_734=$curLineNum]">
										<xsl:element name="AdditionalQNInfo">

											<xsl:attribute name="lineNumber">
												<xsl:value-of select="S_LIN/D_350"/>
											</xsl:attribute>

											<xsl:element name="ItemID">
												<xsl:element name="SupplierPartID">
													<xsl:value-of select="S_LIN[D_235='VP']/D_234"/>
												</xsl:element>
												<xsl:choose>
													<xsl:when test="S_LIN[D_235_2='VS']/D_234_2!=''">
														<xsl:element name="SupplierPartAuxiliaryID">
															<xsl:value-of select="S_LIN[D_235_2='VS']/D_234_2"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="S_LIN[D_235_3='VS']/D_234_3!=''">
														<xsl:element name="SupplierPartAuxiliaryID">
															<xsl:value-of select="S_LIN[D_235_3='VS']/D_234_3"/>
														</xsl:element>
													</xsl:when>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="S_LIN[D_235_2='BP']/D_234_2!=''">
														<xsl:element name="BuyerPartID">
															<xsl:value-of select="S_LIN[D_235_2='BP']/D_234_2"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="S_LIN[D_235_3='BP']/D_234_3!=''">
														<xsl:element name="BuyerPartID">
															<xsl:value-of select="S_LIN[D_235_3='BP']/D_234_3"/>
														</xsl:element>
													</xsl:when>
												</xsl:choose>
												<xsl:if test="S_REF[D_128='LU']/D_352!=''">
													<xsl:element name="IdReference">
														<xsl:attribute name="identifier">
															<xsl:value-of select="S_REF[D_128='LU']/D_352"/>
														</xsl:attribute>
														<xsl:attribute name="domain">
															<xsl:text>buyerLocationID</xsl:text>
														</xsl:attribute>
													</xsl:element>
												</xsl:if>
												<xsl:if test="S_REF[D_128='4C']/D_352!=''">
													<xsl:element name="IdReference">
														<xsl:attribute name="identifier">
															<xsl:value-of select="S_REF[D_128='4C']/D_352"/>
														</xsl:attribute>
														<xsl:attribute name="domain">
															<xsl:text>storageLocation</xsl:text>
														</xsl:attribute>
													</xsl:element>
												</xsl:if>
												<xsl:if test="S_REF[D_128='4L']/D_352!=''">
													<xsl:element name="IdReference">
														<xsl:attribute name="identifier">
															<xsl:value-of select="S_REF[D_128='4L']/D_352"/>
														</xsl:attribute>
														<xsl:attribute name="domain">
															<xsl:text>supplierLocationID</xsl:text>
														</xsl:attribute>
													</xsl:element>
												</xsl:if>
											</xsl:element>
											<xsl:if test="S_REF[D_128='BT']/D_127!='' or S_REF[D_128='LT']/D_127!=''">
												<xsl:element name="Batch">
													<xsl:if test="S_DTM/D_374='405'">
														<xsl:attribute name="productionDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="Date" select="S_DTM[D_374 = '405']/D_373"/>
																<xsl:with-param name="Time" select="S_DTM[D_374 = '405']/D_337"/>
																<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '405']/D_623"/>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="S_DTM/D_374='036'">
														<xsl:attribute name="expirationDate">
															<xsl:call-template name="convertToAribaDate">
																<xsl:with-param name="Date" select="S_DTM[D_374 = '036']/D_373"/>
																<xsl:with-param name="Time" select="S_DTM[D_374 = '036']/D_337"/>
																<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '036']/D_623"/>
															</xsl:call-template>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="S_REF[D_128='LT']/D_127!=''">
														<xsl:element name="BuyerBatchID">
															<xsl:value-of select="S_REF[D_128='LT']/D_127"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="S_REF[D_128='BT']/D_127!=''">
														<xsl:element name="SupplierBatchID">
															<xsl:value-of select="S_REF[D_128='BT']/D_127"/>
														</xsl:element>
													</xsl:if>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:for-each>
								</xsl:if>
								<xsl:for-each select="G_NCD/G_NCA[S_NCA/D_352='task' or S_NCA/D_352='activity' or S_NCA/D_352='cause']">

									<xsl:if test="S_NCA/D_350!=''">
										<xsl:apply-templates select="."/>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="QNCode">
		<xsl:param name="QNCode_REF"/>
		<xsl:element name="QNCode">
			<xsl:attribute name="domain">
				<xsl:value-of select="C_C040[D_128='H6']/D_127"/>
			</xsl:attribute>
			<xsl:if test="C_C040[D_128_2='6P']/D_127_2">
				<xsl:attribute name="codeGroup">
					<xsl:value-of select="C_C040[D_128_2='6P']/D_127_2"/>
				</xsl:attribute>

				<xsl:attribute name="codeGroupDescription">
					<xsl:value-of select="C_C040[D_128_3='6P']/D_127_3"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="code">
				<xsl:value-of select="D_127"/>
			</xsl:attribute>
			<xsl:attribute name="codeDescription">
				<xsl:value-of select="D_352"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template match="G_NCA">

		<xsl:variable name="QualNotfEle">
			<xsl:choose>
				<xsl:when test="S_NCA/D_352='task'">
					<xsl:text>QualityNotificationTask</xsl:text>
				</xsl:when>
				<xsl:when test="S_NCA/D_352='activity'">
					<xsl:text>QualityNotificationActivity</xsl:text>
				</xsl:when>
				<xsl:when test="S_NCA/D_352='cause'">
					<xsl:text>QualityNotificationCause</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$QualNotfEle}">
			<xsl:choose>
				<xsl:when test="S_NCA/D_352='task'">
					<xsl:attribute name="taskId">
						<xsl:value-of select="S_NCA[D_352='task']/D_350"/>
					</xsl:attribute>
					<xsl:attribute name="status">
						<xsl:value-of select="S_REF[D_128='ACC']/D_352"/>
					</xsl:attribute>
					<xsl:if test="G_N1/S_N1/D_98='K9' and G_N1/S_N1/D_66='92'">
						<xsl:attribute name="completedBy">
							<xsl:value-of select="G_N1/S_N1[D_98='K9']/D_67"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="S_DTM/D_374='198'">
						<xsl:attribute name="completedDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="Date" select="S_DTM[D_374 = '198']/D_373"/>
								<xsl:with-param name="Time" select="S_DTM[D_374 = '198']/D_337"/>
								<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '198']/D_623"/>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="G_N1/S_N1[D_98='QD']/D_93!=''">
						<xsl:attribute name="processorId">
							<xsl:value-of select="G_N1/S_N1[D_98='QD']/D_93"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="G_N1/S_N1[D_98='QD']/D_67">
						<xsl:attribute name="processorName">
							<xsl:value-of select="G_N1/S_N1[D_98='QD']/D_67"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="G_N1/S_N1[D_98='QD']/D_98">
						<xsl:choose>
							<xsl:when test="G_N1/S_N1[D_98='QD']/D_98='BY'">
								<xsl:attribute name="processorName">
									<xsl:text>customer</xsl:text>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="G_N1/S_N1[D_98='QD']/D_98='SU'">
								<xsl:attribute name="processorName">
									<xsl:text>supplier</xsl:text>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="G_N1/S_N1[D_98='QD']/D_98='EN'">
								<xsl:attribute name="processorName">
									<xsl:text>customerUser</xsl:text>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:when>
				<xsl:when test="S_NCA/D_352='activity'">
					<xsl:attribute name="activityId">
						<xsl:value-of select="S_NCA[D_352='activity']/D_350"/>
					</xsl:attribute>
					<xsl:if test="S_REF[D_128='ACC']/D_352='complete'">
						<xsl:attribute name="isCompleted">
							<xsl:value-of select="'yes'"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:when>
				<xsl:when test="S_NCA/D_352='cause'">
					<xsl:attribute name="causeId">
						<xsl:value-of select="S_NCA[D_352='cause']/D_350"/>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>

			<xsl:for-each select="S_REF[D_128='BZ']">
				<xsl:if test="D_127!='' and C_C040[D_128='H6']/D_127!=''">

					<xsl:call-template name="QNCode">
						<xsl:with-param name="QNCode_REF" select="."/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="G_N1/S_N1/D_98='BY'">
				<xsl:element name="OwnerInfo">
					<xsl:attribute name="owner">
						<xsl:value-of select="G_N1/S_N1[D_98='BY']/D_67"/>
					</xsl:attribute>
					<xsl:attribute name="role">
						<xsl:text>customer</xsl:text>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="G_N1/S_N1/D_98='SU'">
				<xsl:element name="OwnerInfo">
					<xsl:attribute name="owner">
						<xsl:value-of select="G_N1/S_N1[D_98='SU']/D_67"/>
					</xsl:attribute>
					<xsl:attribute name="role">
						<xsl:text>supplier</xsl:text>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:element name="Description">
				<xsl:attribute name="xml:lang">
					<xsl:text>en-US</xsl:text>
				</xsl:attribute>
				<xsl:element name="ShortName">
					<xsl:value-of select="S_NTE/D_352"/>
				</xsl:element>
			</xsl:element>
			<xsl:if test="S_DTM/D_374='193' and S_DTM/D_374='194'">

				<xsl:element name="Period">
					<xsl:attribute name="startDate">
						<xsl:call-template name="convertToAribaDate">
							<xsl:with-param name="Date" select="S_DTM[D_374 = '193']/D_373"/>
							<xsl:with-param name="Time" select="S_DTM[D_374 = '193']/D_337"/>
							<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '193']/D_623"/>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="endDate">
						<xsl:call-template name="convertToAribaDate">
							<xsl:with-param name="Date" select="S_DTM[D_374 = '194']/D_373"/>
							<xsl:with-param name="Time" select="S_DTM[D_374 = '194']/D_337"/>
							<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '194']/D_623"/>
						</xsl:call-template>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:element>
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
      <xsl:when test="D_365_1 = 'EM'">
        <Con>
          <xsl:attribute name="type">Email</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_1)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_1 = 'UR'">
        <Con>
          <xsl:attribute name="type">URL</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_1)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_1 = 'TE'">
        <Con>
          <xsl:attribute name="type">Phone</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, '(')">
                <xsl:value-of select="substring-before(D_364_1, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, '-')">
                <xsl:value-of select="substring-before(D_364_1, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_1, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_1, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_1 = 'FX'">
        <Con>
          <xsl:attribute name="type">Fax</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, '(')">
                <xsl:value-of select="substring-before(D_364_1, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, '-')">
                <xsl:value-of select="substring-before(D_364_1, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_1, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_1, 'x')"/>
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
  <xsl:template match="S_G61">
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
              <xsl:when test="contains(D_364, '-')">
                <xsl:value-of select="substring-after(D_364, '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="D_364"/>
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
    <xsl:param name="altAddressID"/>
    <xsl:param name="sprole"/>
    <xsl:param name="buildAddressElement"/>
    <xsl:variable name="rootContact">
      <xsl:choose>
        <xsl:when test="$buildAddressElement = 'true'">
          <xsl:text>Address</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Contact</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="role">
      <xsl:value-of select="$contact/S_N1/D_98"/>
    </xsl:variable>
    <xsl:if test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
      <xsl:element name="{$rootContact}">
        <xsl:if test="not($buildAddressElement)">
          <xsl:attribute name="role">
            <xsl:choose>
              <xsl:when test="$sprole = 'QN' and $role = 'BY'">buyerParty</xsl:when>
              <xsl:when test="$sprole = 'QN' and $role = 'SU'">sellerparty</xsl:when>
              <xsl:when test="$sprole = 'QN' and $role = 'FR'">senderparty</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <xsl:variable name="addrDomain" select="$contact/S_N1/D_66"/>
        <xsl:variable name="addrDomainCode"
          select="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode"/>
        <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
          <xsl:if test="$addrDomainCode != ''">
            <xsl:attribute name="addressIDDomain">
              <xsl:value-of select="$addrDomainCode"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$altAddressID != '' and $addrDomainCode = 'SCAC'">
            <xsl:attribute name="addressID">
              <xsl:value-of select="$altAddressID"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="$contact/S_N1/D_67 != ''">
            <xsl:attribute name="addressID">
              <xsl:value-of select="$contact/S_N1/D_67"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <xsl:element name="Name">
          <xsl:attribute name="xml:lang">en</xsl:attribute>
          <xsl:value-of select="$contact/S_N1/D_93"/>
        </xsl:element>
        <!-- PostalAddress -->
        <xsl:if
          test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
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
                <xsl:when
                  test="$contact/S_N4/D_310 != '' and not($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA')">
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
                  <xsl:when
                    test="(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA') and $Lookup/Lookups/States/State[stateCode = $sCode]/stateName != '')">
                    <xsl:value-of
                      select="$Lookup/Lookups/States/State[stateCode = $sCode]/stateName"/>
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
              <xsl:value-of
                select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
              />
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:variable name="contactList">
          <xsl:apply-templates select="$contact/S_PER"/>
          <xsl:apply-templates select="$contact/S_G61"/>
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
                    <xsl:when
                      test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                      <xsl:value-of
                        select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                      />
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
                    <xsl:when
                      test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                      <xsl:value-of
                        select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                      />
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
                <xsl:when
                  test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
                  <xsl:element name="IdReference">
                    <xsl:attribute name="identifier">
                      <xsl:value-of select="D_352"/>
                    </xsl:attribute>
                    <xsl:attribute name="domain">
                      <xsl:value-of
                        select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"
                      />
                    </xsl:attribute>
                  </xsl:element>
                </xsl:when>
                <xsl:when
                  test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
                  <xsl:element name="IdReference">
                    <xsl:attribute name="identifier">
                      <xsl:value-of select="D_352"/>
                    </xsl:attribute>
                    <xsl:attribute name="domain">
                      <xsl:value-of
                        select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"
                      />
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
</xsl:stylesheet>
