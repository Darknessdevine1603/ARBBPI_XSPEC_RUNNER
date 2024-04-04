<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//cXML/Header/To/Credential[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="//M_830/S_REF[D_128 = '44']/D_127 != ''">
         <xsl:element name="Credential">
            <xsl:attribute name="domain">EndPointID</xsl:attribute>
            <xsl:element name="Identity">
               <xsl:value-of select="//M_830/S_REF[D_128 = '44']/D_127"/>
            </xsl:element>
         </xsl:element>
      </xsl:if>
      <xsl:if test="//M_830/S_REF[D_128 = '06']/D_127 != ''">
         <xsl:element name="Credential">
            <xsl:attribute name="domain">SystemID</xsl:attribute>
            <xsl:element name="Identity">
               <xsl:value-of select="//M_830/S_REF[D_128 = '06']/D_127"/>
            </xsl:element>
         </xsl:element>
      </xsl:if>
   </xsl:template>

   <xsl:template match="//cXML/Header/From/Credential[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="//M_830/S_REF[D_128 = 'VR']/D_127 != ''">
         <xsl:element name="Credential">
            <xsl:attribute name="domain">VendorID</xsl:attribute>
            <xsl:element name="Identity">
               <xsl:value-of select="//M_830/S_REF[D_128 = 'VR']/D_127"/>
            </xsl:element>
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
