<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   
   <xsl:template match="//source"/>
   <!-- Extension Start  -->	
   
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isTaxInLine">		
      	
   </xsl:template>
   
   
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/Tax">		
     
   </xsl:template>
   
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/Tax">		
      		
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
