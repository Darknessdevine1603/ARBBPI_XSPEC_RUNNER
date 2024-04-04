<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

   <xsl:template match="//source"/>

   <!-- Extension Start  -->

   <xsl:template match="//M_861/G_RCD/S_LIN/child::*[starts-with(name(), 'D_235')]">
      <xsl:choose>
         <xsl:when test=". = 'VP'">
            <xsl:element name="{name()}">
               <xsl:value-of select="'VA'"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test=". = 'BP'">
            <xsl:element name="{name()}">
               <xsl:value-of select="'IN'"/>
            </xsl:element>
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
