<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>	
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->

   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/Classification[@domain = 'UNSPSC']">		              
      <Classification>
         <xsl:attribute name="domain">custom</xsl:attribute>
         <xsl:choose>
            <xsl:when test="@code!=''"><xsl:value-of select="@code"/></xsl:when>
            <xsl:when test=".!=''"><xsl:value-of select="."/></xsl:when>		     
         </xsl:choose>
         <xsl:copy-of select="@*[name()!='domain' and name()!='code']"></xsl:copy-of>
      </Classification>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/InvoiceDetailServiceItemReference/Classification[@domain = 'UNSPSC']">		              
      <Classification>
         <xsl:attribute name="domain">custom</xsl:attribute>
         <xsl:choose>
            <xsl:when test="@code!=''"><xsl:value-of select="@code"/></xsl:when>	
            <xsl:when test=".!=''"><xsl:value-of select="."/></xsl:when>	     
         </xsl:choose>
         <xsl:copy-of select="@*[name()!='domain' and name()!='code']"></xsl:copy-of>
      </Classification>
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
