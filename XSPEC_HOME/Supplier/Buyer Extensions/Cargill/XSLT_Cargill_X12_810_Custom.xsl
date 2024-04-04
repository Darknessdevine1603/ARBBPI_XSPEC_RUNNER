<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role='from']">
      <Contact>
         <xsl:copy-of select="@*|node()[name()!='Extrinsic']"/>
         <xsl:if test="../IdReference[@domain='gstTaxID']">
            <xsl:element name="IdReference">
               <xsl:attribute name="domain">
                  <xsl:text>gstID</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="identifier">
                  <xsl:value-of select="../IdReference[@domain='gstTaxID']/@identifier"/>
               </xsl:attribute>
            </xsl:element>
         </xsl:if>
         <xsl:if test="../IdReference[@domain='provincialTaxID']">
            <xsl:element name="IdReference">
               <xsl:attribute name="domain">
                  <xsl:text>qstID</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="identifier">
                  <xsl:value-of select="../IdReference[@domain='provincialTaxID']/@identifier"/>
               </xsl:attribute>
            </xsl:element>
         </xsl:if>
         <xsl:copy-of select="Extrinsic"/>
      </Contact>
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
