<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   
   <xsl:template match="//source"/>
   
   <!-- Extension Start  -->
   <xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Extrinsic[last()]">
      <xsl:copy-of select="."/>
      <xsl:variable name="lineNum" select="../@lineNumber"/>		
      
      <xsl:if test="/Combined/source//M_856/G_HL[S_SN1/D_350=$lineNum]/S_TD1[1]/D_103!=''">
         <xsl:variable name="TD1" select="normalize-space(/Combined/source//M_856/G_HL[S_SN1/D_350=$lineNum]/S_TD1[1]/D_103)"/>
         <xsl:variable name="TD2" select="normalize-space(/Combined/source//M_856/G_HL[S_SN1/D_350=$lineNum]/S_TD1[1]/D_80)"/>
         <xsl:variable name="TD5" select="normalize-space(/Combined/source//M_856/G_HL[S_SN1/D_350=$lineNum]/S_TD1[1]/D_79)"/>
         <xsl:variable name="TD8" select="normalize-space(/Combined/source//M_856/G_HL[S_SN1/D_350=$lineNum]/S_TD1[1]/D_355_1)"/>
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">packagingUnitIdentification</xsl:attribute>
            <xsl:value-of select="concat($TD1, '|', $TD5, '|', $TD2, '|', $TD8)"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="/Combined/source//M_856/G_HL[S_HL/D_735 = 'I'][S_SN1/D_350=$lineNum]/S_REF[D_128='L9']/D_127!=''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">customersPartNo</xsl:attribute>
            <xsl:value-of select="/Combined/source//M_856/G_HL[S_HL/D_735 = 'I'][S_SN1/D_350=$lineNum]/S_REF[D_128='L9']/D_127"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="/Combined/source//M_856/G_HL[S_HL/D_735 = 'I'][S_SN1/D_350=$lineNum]/S_REF[D_128='09']/D_127!=''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">customsBarCodeNumber</xsl:attribute>
            <xsl:value-of select="/Combined/source//M_856/G_HL[S_HL/D_735 = 'I'][S_SN1/D_350=$lineNum]/S_REF[D_128='09']/D_127"/>
         </xsl:element>
      </xsl:if>
         
      
   </xsl:template>
   
   <!-- Extension Ends -->
   
   <xsl:template match="//Combined">
      <xsl:apply-templates select="@*|node()"/>
   </xsl:template>
   <xsl:template match="//target">
      <xsl:apply-templates select="@*|node()"/>
   </xsl:template>
   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>