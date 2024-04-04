<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="/Combined/source//M_810/G_SAC/S_SAC[D_248='C'][D_1300='H090']/D_352!=''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">
               <xsl:value-of select="'Misc'"/>
            </xsl:attribute>
            <xsl:value-of select="/Combined/source//M_810/G_SAC/S_SAC[D_248='C'][D_1300='H090']/D_352"/>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/child::*[last()]">
      <xsl:copy-of select="."/>
      <xsl:variable name="lineNum" select="../@invoiceLineNumber"/>

      <xsl:if test="..//ItemID/BuyerPartID!=''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">
               <xsl:value-of select="'customerPartNumber'"/>
            </xsl:attribute>
            <xsl:value-of select="..//ItemID/BuyerPartID"/>
         </xsl:element>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='VT']/D_127!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="'motorVehicleIDNo'"/>
               </xsl:attribute>
               <xsl:value-of select="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='VT']/D_127"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='VT']/D_127!=''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">
               <xsl:value-of select="'motorVehicleIDNo'"/>
            </xsl:attribute>
            <xsl:value-of select="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='VT']/D_127"/>
         </xsl:element>
      </xsl:when>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='BM']/D_127!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="'billOfLadingNo'"/>
               </xsl:attribute>
               <xsl:value-of select="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='BM']/D_127"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='BM']/D_127!=''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">
               <xsl:value-of select="'billOfLadingNo'"/>
            </xsl:attribute>
            <xsl:value-of select="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='BM']/D_127"/>
         </xsl:element>
      </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/child::*[last()]">
      <xsl:copy-of select="."/>
      <xsl:variable name="lineNum" select="../@invoiceLineNumber"/>

      <xsl:if test="..//ItemID/BuyerPartID!=''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">
               <xsl:value-of select="'customerPartNumber'"/>
            </xsl:attribute>
            <xsl:value-of select="..//ItemID/BuyerPartID"/>
         </xsl:element>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='VT']/D_127!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="'motorVehicleIDNo'"/>
               </xsl:attribute>
               <xsl:value-of select="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='VT']/D_127"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='VT']/D_127!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="'motorVehicleIDNo'"/>
               </xsl:attribute>
               <xsl:value-of select="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='VT']/D_127"/>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='BM']/D_127!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="'billOfLadingNo'"/>
               </xsl:attribute>
               <xsl:value-of select="/Combined/source//M_810/G_IT1[S_REF[D_128='FJ']/D_127=$lineNum]/S_REF[D_128='BM']/D_127"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='BM']/D_127!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">
                  <xsl:value-of select="'billOfLadingNo'"/>
               </xsl:attribute>
               <xsl:value-of select="/Combined/source//M_810/G_IT1[S_IT1/D_350=$lineNum]/S_REF[D_128='BM']/D_127"/>
            </xsl:element>
         </xsl:when>
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
