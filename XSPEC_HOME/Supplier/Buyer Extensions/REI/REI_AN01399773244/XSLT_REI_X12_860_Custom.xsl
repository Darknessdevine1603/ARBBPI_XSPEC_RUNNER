<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

   <!-- 10042018 CG: REI Extension Created -->
   <!--   <xsl:include href="pd:HCIOWNERPID:FORMAT_cXML_0000_ASC-X12_004010:Binary"/>-->
   <xsl:template match="//source"/>

   <!-- Extension Start  -->
    <xsl:template match="//M_860/G_POC/S_REF[last()]">
      <xsl:variable name="lineNum" select="../S_POC/D_350"/>
      <xsl:copy-of select="."/>
      <xsl:if
         test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'priceQuoteNo']) != ''">
         <S_REF>
            <D_128>PR</D_128>
            <D_127>
               <xsl:value-of
                  select="substring(normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'priceQuoteNo']), 1, 30)"
               />
            </D_127>
         </S_REF>
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
