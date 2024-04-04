<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->	
		
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isTaxInLine">		
			<xsl:choose>
				<xsl:when test="//FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'BT']/S_N4/D_26 = 'US'">					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>		
	</xsl:template>
	
	
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/Tax">		
			<xsl:choose>							
				<xsl:when test="//FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'BT']/S_N4/D_26 = 'US'">	
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/Tax">		
			<xsl:choose>
				<xsl:when test="//FunctionalGroup/M_810/G_N1[S_N1/D_98_1 = 'BT']/S_N4/D_26 = 'US'">					
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
