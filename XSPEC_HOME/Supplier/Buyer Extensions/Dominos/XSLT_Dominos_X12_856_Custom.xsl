<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>

   <!-- Extension Start  -->

   <xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[not(exists(PackagingLevelCode))]">
      <Packaging>
         <xsl:apply-templates select="PackagingCode"/>
         <xsl:apply-templates select="Dimension"/>
         <xsl:apply-templates select="Description"/>
         <xsl:choose>
            <!-- If Dimension exists, then considering 'Dimension' as mandatory element to get the following-sibling -->
            <xsl:when test="exists(Dimension)">
               <!-- For PackagingLevelCode -->
               <PackagingLevelCode>1</PackagingLevelCode>
               <xsl:apply-templates select="Dimension[last()]/following-sibling::*[not(self::Description)]"/>
            </xsl:when>
            <!-- If Dimension not exists, then considering 'PackagingCode' as mandatory element to get the following-sibling -->
            <xsl:otherwise>
               <!-- For PackagingLevelCode -->
               <PackagingLevelCode>1</PackagingLevelCode>
               <xsl:apply-templates select="PackagingCode/following-sibling::*[not(self::Description)]"/>
            </xsl:otherwise>
         </xsl:choose>
      </Packaging>
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
