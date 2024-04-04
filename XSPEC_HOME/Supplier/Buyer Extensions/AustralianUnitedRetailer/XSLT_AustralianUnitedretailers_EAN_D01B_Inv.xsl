<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[last()][@name!='supplierVatID' and @name!='buyerVatID' ]">
      <xsl:copy-of select="."/>
      <xsl:choose>
         <xsl:when test="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'SU']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name" select="'supplierVatID'"/>
               <xsl:value-of select="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'SU']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name" select="'supplierVatID'"/>
               <xsl:value-of select="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'FR']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154"/>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'BY']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name" select="'buyerVatID'"/>
               <xsl:value-of select="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'BY']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'IV']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name" select="'buyerVatID'"/>
               <xsl:value-of select="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'IV']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154"/>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'supplierCorporate']">
      <xsl:choose>
         <xsl:when test="not(//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'from'])">
            <xsl:element name="Contact">
               <xsl:copy-of select="./@*[name() != 'role']"/>
               <xsl:attribute name="role">
                  <xsl:text>from</xsl:text>
               </xsl:attribute>
               <xsl:copy-of select="./child::*"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='supplierVatID']"/>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='buyerVatID']"/>
   
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
