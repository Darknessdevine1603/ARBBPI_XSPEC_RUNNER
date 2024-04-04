<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	
	<xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/child::*[last()]">
		
		<xsl:variable name="linenum">			
			<xsl:value-of select="../@lineNumber"/>					
		</xsl:variable>		
		<xsl:variable name="shipNoticeLineNumber">
			<xsl:value-of select="../@shipNoticeLineNumber"/>
		</xsl:variable>		
		<xsl:copy-of select="."/>		
		<xsl:if test="//M_DESADV/G_SG10/G_SG15[S_LIN/C_C212/D_7140 = $linenum and S_LIN/D_1082 = $shipNoticeLineNumber]/S_ALI/D_3239 !=''">
			<xsl:element name="Extrinsic">				
				<xsl:attribute name="name">manufacturerCountryCode</xsl:attribute>
				<xsl:value-of select="//M_DESADV/G_SG10/G_SG15[S_LIN/C_C212/D_7140 = $linenum and S_LIN/D_1082 = $shipNoticeLineNumber]/S_ALI/D_3239"/>				
			</xsl:element>
		</xsl:if>		
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
