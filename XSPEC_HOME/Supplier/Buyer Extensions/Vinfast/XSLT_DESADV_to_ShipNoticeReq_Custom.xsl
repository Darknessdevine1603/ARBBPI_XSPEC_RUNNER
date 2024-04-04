<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <!--xsl:variable name="lookups" select="document('../../EDIFACT_D96A/LOOKUP_UN-EDIFACT_D96A.xml')"/-->
   <xsl:variable name="lookups" select="document('pd:HCIOWNERPID:LOOKUP_UN-EDIFACT_D96A:Binary')"/>
   
   
   
   <xsl:template match="//source"/>
   <xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem">
      <xsl:element name="ShipNoticeItem">
         <xsl:copy-of select="@*"/>
         <xsl:variable name="maxPack">
            <xsl:choose>
               <xsl:when test="./Packaging/PackagingLevelCode">
                  <xsl:value-of select="max(./Packaging/*[starts-with(local-name(), 'PackagingLevelCode')]/xs:integer(.))+1"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="'1'"/>
               </xsl:otherwise>
            </xsl:choose>
            
         </xsl:variable> 
         <xsl:apply-templates>
            <xsl:with-param name="pLevels" select="$maxPack"/>
         </xsl:apply-templates>
      </xsl:element>
   </xsl:template>
   <xsl:template match="OrderedQuantity"></xsl:template>
   <xsl:template match="Packaging">
      <xsl:param name="pLevels"/>
      <xsl:element name="Packaging">
         <xsl:copy-of select="@*"/>
         <xsl:variable name="pckCode" select="PackagingCode"/>
         <xsl:variable name="pckCodeID" select="PackageTypeCodeIdentifierCode"/>
         <xsl:apply-templates select="ShippingContainerSerialCode/preceding-sibling::*">
            <xsl:with-param name="pLevels" select="$pLevels"/>
            <xsl:with-param name="pckCode" select="$pckCode"/>
            <xsl:with-param name="pckCodeID" select="$pckCodeID"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="ShippingContainerSerialCode|ShippingContainerSerialCodeReference|PackageID|ShippingMark"></xsl:apply-templates>
         <xsl:copy-of select="../OrderedQuantity"></xsl:copy-of>
         <xsl:apply-templates select="DispatchQuantity|FreeGoodsQuantity|QuantityVarianceNote|BestBeforeDate|Extrinsic"></xsl:apply-templates>
         
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="PackagingCode">
      <xsl:param name="pckCode"/>
      <xsl:element name="PackagingCode">
         <xsl:copy-of select="@*"/>     
         <xsl:choose>
            <xsl:when test="lower-case($pckCode)='pallet'"/>
            <xsl:when test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[CXMLCode = $pckCode]/EDIFACTCode!=''"><xsl:value-of select="upper-case($pckCode)"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$pckCode"/></xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="PackagingLevelCode">
      <xsl:param name="pLevels"/>
      <xsl:param name="pckCodeID"/>
      <xsl:param name="pckCode"/>
      <xsl:variable name="currentPLevel" select="xs:integer(.)"/>
      <xsl:element name="PackagingLevelCode">
         <xsl:value-of select="$pLevels - $currentPLevel"/>
      </xsl:element>
      <xsl:element name="PackageTypeCodeIdentifierCode">
         <xsl:choose>
            <xsl:when test="upper-case($lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $pckCodeID]/CXMLCode)!=''">
               <xsl:value-of select="upper-case($lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $pckCodeID]/CXMLCode)"/>
            </xsl:when>
            <xsl:when test="lower-case($pckCode)='pallet'"><xsl:text>PALLET</xsl:text></xsl:when>
         </xsl:choose>
         
      </xsl:element>
   </xsl:template>
   <xsl:template match="PackageTypeCodeIdentifierCode">
      <xsl:param name="pckCodeID"/>
      <xsl:choose>
         <xsl:when test="../PackagingLevelCode"></xsl:when>
         <xsl:otherwise>
            <xsl:element name="PackagingLevelCode">
               <xsl:value-of select="'1'"/>
            </xsl:element>
            <xsl:element name="PackageTypeCodeIdentifierCode">
               <xsl:value-of select="upper-case($lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $pckCodeID]/CXMLCode)"/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="Description">
      <xsl:param name="pckCodeID"/>
      <xsl:param name="pckCode"/>
      <xsl:element name="Description">
         <xsl:copy-of select="@*"></xsl:copy-of>
         <xsl:choose>
            <xsl:when test="upper-case($lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $pckCodeID]/CXMLCode)!=''">
               <xsl:value-of select="upper-case($lookups/Lookups/PackageTypeCodes/PackageTypeCode[EDIFACTCode = $pckCodeID]/CXMLCode)"/>
            </xsl:when>
            <xsl:when test="$lookups/Lookups/PackageTypeCodes/PackageTypeCode[CXMLCode = $pckCode]/EDIFACTCode!=''">
               <xsl:value-of select="upper-case($pckCode)"/>
            </xsl:when>
         </xsl:choose>
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
