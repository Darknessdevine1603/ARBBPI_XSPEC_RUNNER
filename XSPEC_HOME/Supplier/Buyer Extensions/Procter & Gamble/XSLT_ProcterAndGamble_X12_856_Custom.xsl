<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="/Combined/target/cXML/Request/ShipNoticeRequest/ShipNoticeHeader">
		<xsl:choose>
			<xsl:when test="//M_856/G_HL[S_HL/D_628 = '1' and S_HL/D_735 = 'S' and S_HL/D_736 = '1']/S_REF[D_128 = '47']/D_352 != ''">
				<ShipNoticeHeader>
					<xsl:copy-of select="./@*"/>
					<xsl:copy-of select="ServiceLevel"/>
					<xsl:copy-of select="Contact"/>
					<xsl:copy-of select="Hazard"/>
					<xsl:copy-of select="Comments"/>
					<xsl:copy-of select="TermsOfDelivery"/>
					<xsl:copy-of select="TermsOfTransport"/>
					<xsl:copy-of select="Packaging"/>
					<xsl:copy-of select="Extrinsic"/>
					<Extrinsic>
						<xsl:attribute name="name">
							<xsl:text>plateNo</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="/Combined/source//M_856/G_HL[S_HL/D_628 = '1' and S_HL/D_735 = 'S' and S_HL/D_736 = '1']/S_REF[D_128 = '47']/D_352"/>
					</Extrinsic>
					<xsl:copy-of select="IdReference"/>
				</ShipNoticeHeader>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
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
