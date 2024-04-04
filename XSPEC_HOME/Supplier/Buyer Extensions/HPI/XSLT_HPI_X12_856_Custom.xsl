<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- For local testing -->
	<!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>-->
	<!-- for dynamic, reading from Partner Directory -->
	<xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->

	<xsl:template match="//ShipNoticeRequest/ShipNoticeHeader/Extrinsic[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="//M_856/S_DTM[D_374 = '056']/D_373 != ''">
			<xsl:element name="Extrinsic">
			<xsl:attribute name="name">portEntryDate</xsl:attribute>				
			<xsl:call-template name="convertToAribaDate">
				<xsl:with-param name="Date">
					<xsl:value-of
						select="//M_856/S_DTM[D_374 = '056']/D_373"
					/>
				</xsl:with-param>
				<xsl:with-param name="Time">
					<xsl:value-of
						select="//M_856/S_DTM[D_374 = '056']/D_337"
					/>
				</xsl:with-param>
				<xsl:with-param name="TimeCode">
					<xsl:value-of
						select="//M_856/S_DTM[D_374 = '056']/D_623"
					/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/AssetInfo">
		<xsl:variable name="snItem" select="../@shipNoticeLineNumber"/>
		<xsl:variable name="serialN" select="@serialNumber"/>
		<xsl:variable name="sourceItem" select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $snItem]/S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]"/>

		<xsl:element name="AssetInfo">
			<xsl:copy-of select="@serialNumber"/>
			<xsl:if test="$sourceItem/D_87_3 = 'COO' and $sourceItem/D_87_4 != ''">
				<xsl:attribute name="location">
					<xsl:value-of select="$sourceItem/D_87_4"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem[not(exists(AssetInfo))]">
		<xsl:variable name="snItem" select="./@shipNoticeLineNumber"/>
		<xsl:variable name="sourceItem" select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $snItem]/S_MAN[D_88_1 = 'L' and D_87_1='COO' and D_87_2!= '']"/>

		<xsl:choose>
			<xsl:when test="count($sourceItem) >= 1">
				<ShipNoticeItem>
					<xsl:copy-of select="./@*"/>
					<xsl:apply-templates select="ItemID, ShipNoticeItemDetail, UnitOfMeasure, Packaging, Hazard, Batch, SupplierBatchID"/>
					<xsl:for-each select="$sourceItem">
						<xsl:element name="AssetInfo">
							<xsl:attribute name="location">
								<xsl:value-of select="D_87_2"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
					<xsl:apply-templates select="./UnitOfMeasure/following-sibling::*[name() != 'Packaging' and name() != 'Hazard' and name() != 'Batch' and name() != 'SupplierBatchID']"/>
				</ShipNoticeItem>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="convertToAribaDate">
		<xsl:param name="Date"/>
		<xsl:param name="Time"/>
		<xsl:param name="TimeCode"/>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when
					test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
					<xsl:value-of
						select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
					/>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="temDate">
			<xsl:value-of
				select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
			/>
		</xsl:variable>
		<xsl:variable name="tempTime">
			<xsl:choose>
				<xsl:when test="$Time != '' and string-length($Time) = 6">
					<xsl:value-of
						select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
					/>
				</xsl:when>
				<xsl:when test="$Time != '' and string-length($Time) = 4">
					<xsl:value-of
						select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"
					/>
				</xsl:when>
				<xsl:otherwise>T12:00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
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
