<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>

   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//ConfirmationStatus/ItemIn/ItemDetail">
      <xsl:element name="ItemDetail">
         <xsl:variable name="BuyerPart" select="../ItemID/BuyerPartID"/>
         <xsl:variable name="UPCID" select="Extrinsic[@name='UPCID']"/>
         <xsl:apply-templates select="*"/>
         <xsl:if test="$BuyerPart!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name" select="'customersPartNo'"/>
               <xsl:value-of select="$BuyerPart"/>
            </xsl:element>
         </xsl:if>
         <xsl:if test="$UPCID!=''">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name" select="'customsBarCodeNumber'"/>
               <xsl:value-of select="$UPCID"/>
            </xsl:element>
         </xsl:if>
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
