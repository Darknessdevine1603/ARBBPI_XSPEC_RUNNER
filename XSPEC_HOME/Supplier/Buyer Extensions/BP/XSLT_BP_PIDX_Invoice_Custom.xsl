<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="normalize-space(/Combined/source/pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer']) != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">internalVendorNo</xsl:attribute>
            <xsl:value-of select="normalize-space(/Combined/source/pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Seller']/pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'])"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="normalize-space(//pidx:Invoice/pidx:InvoiceProperties/pidx:RateOfExchangeDetail/pidx:ExchangeRate) != ''">
         <Extrinsic>
            <xsl:attribute name="name">taxExchangeRate</xsl:attribute>
            <xsl:value-of select="normalize-space(//pidx:Invoice/pidx:InvoiceProperties/pidx:RateOfExchangeDetail/pidx:ExchangeRate)"/>
         </Extrinsic>
      </xsl:if>
      <xsl:if test="normalize-space(//pidx:Invoice/pidx:InvoiceProperties/pidx:RateOfExchangeDetail/pidx:TargetCurrency/pidx:CurrencyCode) != ''">
         <Extrinsic>
            <xsl:attribute name="name">taxExchangeRateTargetCurrency</xsl:attribute>
            <xsl:value-of select="normalize-space(//pidx:Invoice/pidx:InvoiceProperties/pidx:RateOfExchangeDetail/pidx:TargetCurrency/pidx:CurrencyCode)"/>
         </Extrinsic>
      </xsl:if>
   </xsl:template>

   <!-- Extrinsics transactionCategoryOrType and transactionReferenceNo only applies to service items -->
   <xsl:template match="//InvoiceDetailServiceItem/child::*[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="normalize-space(../Distribution/Accounting/AccountingSegment[lower-case(normalize-space(Name)) = 'costcenter']/@id) != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">transactionCategoryOrType</xsl:attribute>
            <xsl:value-of select="'CO'"/>
         </xsl:element>
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">transactionReferenceNo</xsl:attribute>
            <xsl:value-of select="normalize-space(../Distribution/Accounting/AccountingSegment[lower-case(normalize-space(Name)) = 'costcenter']/@id)"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="normalize-space(../InvoiceDetailServiceItemReference/Classification[@domain = 'UNSPSC']) != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">classCode</xsl:attribute>
            <xsl:value-of select="normalize-space(../InvoiceDetailServiceItemReference/Classification[@domain = 'UNSPSC'])"/>
         </xsl:element>
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">classificationCode</xsl:attribute>
            <xsl:value-of select="normalize-space(../InvoiceDetailServiceItemReference/Classification[@domain = 'UNSPSC'])"/>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//InvoiceDetailItem/child::*[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="normalize-space(../InvoiceDetailItemReference/Classification[@domain = 'UNSPSC']) != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">classificationCode</xsl:attribute>
            <xsl:value-of select="normalize-space(../InvoiceDetailItemReference/Classification[@domain = 'UNSPSC'])"/>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <!--Goods Invoice-->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/ItemID/SupplierPartAuxiliaryID">
      <xsl:variable name="linenum" select="../../../@invoiceLineNumber"/>
      <xsl:variable name="SuppPartIDExt" select="normalize-space(.)"/>
      <xsl:variable name="ParamA" select="normalize-space(/Combined/source/pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][translate(lower-case(pidx:Description), ' ', '') = 'parama']/pidx:ReferenceNumber)"/>
      <xsl:variable name="ParamB" select="normalize-space(/Combined/source/pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][translate(lower-case(pidx:Description), ' ', '') = 'paramb']/pidx:ReferenceNumber)"/>
      <xsl:call-template name="SupplierPartExtension">
         <xsl:with-param name="ParamB" select="$ParamB"/>
         <xsl:with-param name="ParamA" select="$ParamA"/>
         <xsl:with-param name="SuppPartIDExt" select="$SuppPartIDExt"/>
      </xsl:call-template>
   </xsl:template>
   <!--Service Invoice-->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/InvoiceDetailServiceItemReference/ItemID/SupplierPartAuxiliaryID">
      <xsl:variable name="linenum" select="../../../@invoiceLineNumber"/>
      <xsl:variable name="SuppPartIDExt" select="normalize-space(.)"/>
      <xsl:variable name="ParamA" select="normalize-space(/Combined/source/pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][translate(lower-case(pidx:Description), ' ', '') = 'parama']/pidx:ReferenceNumber)"/>
      <xsl:variable name="ParamB" select="normalize-space(/Combined/source/pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][translate(lower-case(pidx:Description), ' ', '') = 'paramb']/pidx:ReferenceNumber)"/>
      <xsl:call-template name="SupplierPartExtension">
         <xsl:with-param name="ParamB" select="$ParamB"/>
         <xsl:with-param name="ParamA" select="$ParamA"/>
         <xsl:with-param name="SuppPartIDExt" select="$SuppPartIDExt"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="SupplierPartExtension">
      <xsl:param name="SuppPartIDExt"/>
      <xsl:param name="ParamA"/>
      <xsl:param name="ParamB"/>
      <xsl:choose>
         <xsl:when test="$SuppPartIDExt != '' and $ParamA != '' and $ParamB != ''">
            <SupplierPartAuxiliaryID>
               <xsl:value-of select="concat($SuppPartIDExt, '|', $ParamA, '|', $ParamB)"/>
            </SupplierPartAuxiliaryID>
         </xsl:when>
         <xsl:when test="$SuppPartIDExt != '' and $ParamA != ''">
            <SupplierPartAuxiliaryID>
               <xsl:value-of select="concat($SuppPartIDExt, '|', $ParamA)"/>
            </SupplierPartAuxiliaryID>
         </xsl:when>
         <xsl:when test="$SuppPartIDExt != '' and $ParamB != ''">
            <SupplierPartAuxiliaryID>
               <xsl:value-of select="concat($SuppPartIDExt, '|', $ParamB)"/>
            </SupplierPartAuxiliaryID>
         </xsl:when>
         <xsl:when test="$SuppPartIDExt != ''">
            <SupplierPartAuxiliaryID>
               <xsl:value-of select="$SuppPartIDExt"/>
            </SupplierPartAuxiliaryID>
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
