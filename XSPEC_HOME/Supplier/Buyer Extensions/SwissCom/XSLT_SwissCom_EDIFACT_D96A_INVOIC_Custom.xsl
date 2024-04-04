<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:param name="anSenderDefaultTimeZone"/>
   <xsl:template match="//source"/>
   <xsl:strip-space elements="*"/>
   <!-- Extension Start  -->

   <xsl:template match="/Combined/target/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification/ModificationDetail[Description != '']/@name">
      <xsl:attribute name="name">
         <xsl:value-of select="../Description"/>
      </xsl:attribute>
      <xsl:attribute name="code">
         <xsl:value-of select="../Description"/>
      </xsl:attribute>
   </xsl:template>
   
   <xsl:template match="/Combined/target/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification/ModificationDetail[Description != '']/@code">
   </xsl:template>
   
   <xsl:template match="/Combined/target/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification/ModificationDetail/Description/@xml:lang">
      <xsl:attribute name="xml:lang">
         <xsl:value-of select="'en-US'"/>
      </xsl:attribute>
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
