<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:variable name="lookups" select="document('pd:HCIOWNERPID:LOOKUP_UN-EDIFACT_D96A:Binary')"/>
	<!--<xsl:variable name="lookups" select="document('cXML_EDILookups_D96A.xml')"/>-->
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/ShipNoticeIDInfo">
		<ShipNoticeIDInfo>
		<xsl:copy-of select="@*"/>
		<!-- deliveryNoteID -->
		<xsl:if test="//G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">deliveryNoteID</xsl:attribute>
				<xsl:attribute name="identifier" select="//G_SG1/S_RFF/C_C506[D_1153 = 'DQ']/D_1154"
				/>
			</xsl:element>
		</xsl:if>
		<!-- deliveryNoteDate -->
		<xsl:if
			test="//G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124' or D_2005 = '171']/D_2380 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">deliveryNoteDate</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:choose>
						<xsl:when
							test="//G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380 != ''">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="dateTime"
									select="//G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2380"/>
								<xsl:with-param name="dateTimeFormat"
									select="//G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '124']/D_2379"
								/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when
							test="//G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="dateTime"
									select="//G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
								<xsl:with-param name="dateTimeFormat"
									select="//G_SG1[S_RFF/C_C506/D_1153 = 'DQ']/S_DTM/C_C507[D_2005 = '171']/D_2379"
								/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:element>
		
		</xsl:if>
		<!-- dispatchAdviceID -->
		<xsl:if test="//G_SG1/S_RFF/C_C506[D_1153 = 'AAK']/D_1154 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">
					<xsl:text>dispatchAdviceID</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:value-of select="//G_SG1/S_RFF/C_C506[D_1153 = 'AAK']/D_1154"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- receivingAdviceID -->
		<xsl:if test="//G_SG1/S_RFF/C_C506[D_1153 = 'ALO']/D_1154 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">
					<xsl:text>receivingAdviceID</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:value-of select="//G_SG1/S_RFF/C_C506[D_1153 = 'ALO']/D_1154"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- receivingAdviceDate -->
		<xsl:if
			test="//G_SG1[S_RFF/C_C506/D_1153 = 'ALO']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">receivingAdviceDate</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime"
							select="//G_SG1[S_RFF/C_C506/D_1153 = 'ALO']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
						<xsl:with-param name="dateTimeFormat"
							select="//G_SG1[S_RFF/C_C506/D_1153 = 'ALO']/S_DTM/C_C507[D_2005 = '171']/D_2379"
						/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- transportDocumentID -->
		<xsl:if test="//G_SG1/S_RFF/C_C506[D_1153 = 'AAS']/D_1154 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">
					<xsl:text>transportDocumentID</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:value-of select="//G_SG1/S_RFF/C_C506[D_1153 = 'AAS']/D_1154"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- proofOfDeliveryIDs -->
		<xsl:if test="//G_SG1/S_RFF/C_C506[D_1153 = 'AGL']/D_1154 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">
					<xsl:text>proofOfDeliveryID</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:value-of select="//G_SG1/S_RFF/C_C506[D_1153 = 'AGL']/D_1154"/>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- receivingAdviceDate -->
		<xsl:if
			test="//G_SG1[S_RFF/C_C506/D_1153 = 'AGL']/S_DTM/C_C507[D_2005 = '171']/D_2380 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">proofOfDeliveryDate</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime"
							select="//G_SG1[S_RFF/C_C506/D_1153 = 'AGL']/S_DTM/C_C507[D_2005 = '171']/D_2380"/>
						<xsl:with-param name="dateTimeFormat"
							select="//G_SG1[S_RFF/C_C506/D_1153 = 'AGL']/S_DTM/C_C507[D_2005 = '171']/D_2379"
						/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- actualDeliveryDate -->
		<xsl:if test="//M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2380 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">actualDeliveryDate</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2380"/>
						<xsl:with-param name="dateTimeFormat"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '35']/D_2379"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- goodsPositioningDate -->
		<xsl:if test="//M_INVOIC/S_DTM/C_C507[D_2005 = '199']/D_2380 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">goodsPositioningDate</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '199']/D_2380"/>
						<xsl:with-param name="dateTimeFormat"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '199']/D_2379"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- goodsPositioningDate -->
		<xsl:if test="//M_INVOIC/S_DTM/C_C507[D_2005 = '194']/D_2380 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">goodsPositioningStartDate</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '194']/D_2380"/>
						<xsl:with-param name="dateTimeFormat"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '194']/D_2379"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<!-- goodsPositioningEndDate -->
		<xsl:if test="//M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2380 != ''">
			<xsl:element name="IdReference ">
				<xsl:attribute name="domain">goodsPositioningEndDate</xsl:attribute>
				<xsl:attribute name="identifier">
					<xsl:call-template name="convertToAribaDate">
						<xsl:with-param name="dateTime"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2380"/>
						<xsl:with-param name="dateTimeFormat"
							select="//M_INVOIC/S_DTM/C_C507[D_2005 = '206']/D_2379"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		</ShipNoticeIDInfo>
	</xsl:template>

	<xsl:template name="convertToAribaDate">
		<xsl:param name="dateTime"/>
		<xsl:param name="dateTimeFormat"/>
		<xsl:variable name="dtmFormat">
			<xsl:choose>
				<xsl:when test="$dateTimeFormat != ''">
					<xsl:value-of select="$dateTimeFormat"/>
				</xsl:when>
				<xsl:otherwise>102</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tempDateTime">
			<xsl:choose>
				<xsl:when test="$dtmFormat = 102">
					<xsl:value-of select="concat($dateTime, '120000')"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 203">
					<xsl:value-of select="concat($dateTime, '00')"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 204">
					<xsl:value-of select="$dateTime"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 303">
					<xsl:value-of
						select="concat(substring($dateTime, 0, 12), '00', substring($dateTime, 12))"
					/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 304">
					<xsl:value-of select="$dateTime"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$dateTimeFormat = '303' or $dateTimeFormat = '304'">
					<xsl:choose>
						<xsl:when
							test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode != ''">
							<xsl:value-of
								select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode"
							/>
						</xsl:when>
						<xsl:otherwise>+00:00</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of
			select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"
		/>
	</xsl:template>

	


	<!-- Extension Ends -->
	<xsl:template match="//Combined">
		<xsl:apply-templates select="@* | node()"/>
	</xsl:template>
	<xsl:template match="//target">
		<xsl:apply-templates select="@* | node()"/>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
