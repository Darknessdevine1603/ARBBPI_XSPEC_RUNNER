<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/Tax">
		<xsl:variable name="cXMLLine">
			<xsl:value-of select="../@invoiceLineNumber"/>			
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="exists(//FunctionalGroup/M_810/G_IT1[S_REF[D_128 = 'FJ']/D_127 = $cXMLLine]/G_SAC/S_SAC) or exists(//FunctionalGroup/M_810/G_IT1[S_REF[D_128 = 'FJ']/D_127 = $cXMLLine]/G_SAC/S_TXI)">				
			</xsl:when>			
			<xsl:otherwise>
				<xsl:copy-of select="."></xsl:copy-of>								
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/GrossAmount"/>
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/NetAmount"/>
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
