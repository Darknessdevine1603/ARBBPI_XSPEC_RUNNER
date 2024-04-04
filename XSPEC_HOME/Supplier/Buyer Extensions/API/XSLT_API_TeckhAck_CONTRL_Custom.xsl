<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <!-- 09132018 : CG - Created -->
   
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//M_CONTRL/S_UCI/D_0083">
     <xsl:choose>
        <xsl:when test="./text() = '7' and not(exists(//M_CONTRL/G_SG1))">
           <D_0083>8</D_0083>
        </xsl:when>
        <xsl:when test="./text() = '7' and ((//M_CONTRL/G_SG1/S_UCM/D_0083='7' or //M_CONTRL/G_SG1/S_UCM/D_0083='8') and not(exists(//M_CONTRL/G_SG1/G_SG2/S_UCS)))">
               <D_0083>8</D_0083>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="."/>
            </xsl:otherwise>
         </xsl:choose>
   </xsl:template>
   
   <xsl:template match="//M_CONTRL/G_SG1[not(exists(G_SG2/S_UCS)) and (S_UCM/D_0083='7' or S_UCM/D_0083='8')]"/>
   
   <xsl:template match="//M_CONTRL/S_UNT/D_0074">
      <D_0074>#segCount#</D_0074>
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
