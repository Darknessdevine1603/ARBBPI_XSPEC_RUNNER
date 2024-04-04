<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  <!--xsl:variable name="Lookup" select="document('cXML_EDILookups_EANCOM.xml')"/-->
  <!-- PD references -->
  <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_EANCOM_D01BEAN011:Binary')"/>
  <xsl:template match="//source"/>
  <!-- Extension Start  -->
   <xsl:template match="//M_ORDERS/G_SG2[S_NAD/D_3035 = 'BY']">
      <xsl:element name="G_SG2">
         <xsl:copy-of select="S_NAD"/>
         <xsl:copy-of select="S_LOC"/>
         <xsl:copy-of select="S_FII"/>
         <xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'buyerVatID']) != ''">
            <G_SG3>
               <S_RFF>
                  <C_C506>
                     <D_1153>AMT</D_1153>
                     <D_1154>
                        <xsl:value-of select="normalize-space(substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'buyerVatID']), 1, 35))"/>
                     </D_1154>
                  </C_C506>
               </S_RFF>
            </G_SG3>
         </xsl:if>
         <xsl:copy-of select="G_SG3"/>
         <xsl:copy-of select="G_SG4"/>
         <xsl:copy-of select="G_SG5"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//M_ORDERS/G_SG2[S_NAD/D_3035 = 'SU']">
      <xsl:element name="G_SG2">
         <xsl:copy-of select="S_NAD"/>
         <xsl:copy-of select="S_LOC"/>
         <xsl:copy-of select="S_FII"/>
         <xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'supplierVatID']) != ''">
            <G_SG3>
               <S_RFF>
                  <C_C506>
                     <D_1153>AMT</D_1153>
                     <D_1154>
                        <xsl:value-of select="normalize-space(substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'supplierVatID']), 1, 35))"/>
                     </D_1154>
                  </C_C506>
               </S_RFF>
            </G_SG3>
         </xsl:if>
         <xsl:copy-of select="G_SG3"/>
         <xsl:copy-of select="G_SG4"/>
         <xsl:copy-of select="G_SG5"/>
      </xsl:element>
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
