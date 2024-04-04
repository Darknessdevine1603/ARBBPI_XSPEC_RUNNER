<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   <!-- 08152018 CG : Re-map of WellServiceTax Charge -->
   <xsl:template match="//InvoiceDetailOrder/InvoiceDetailServiceItem[InvoiceItemModifications/Modification/ModificationDetail/Description = 'WellServiceTax']">
      <InvoiceDetailServiceItem>
         <xsl:copy-of select="./@*"/>
         <xsl:copy-of select="child::InvoiceItemModifications/preceding-sibling::*"/>
         <xsl:if test="count(InvoiceItemModifications/Modification[ModificationDetail/Description != 'WellServiceTax']) &gt; 0">
            <InvoiceItemModifications>
               <xsl:copy-of select="InvoiceItemModifications/Modification[ModificationDetail/Description != 'WellServiceTax']"/>
            </InvoiceItemModifications>
         </xsl:if>
         <xsl:copy-of select="child::InvoiceItemModifications/following-sibling::*"/>
      </InvoiceDetailServiceItem>

      <!-- create item with WellServiceTax details -->
      <InvoiceDetailServiceItem>
         <xsl:attribute name="invoiceLineNumber">
            <xsl:value-of select="concat(number(@invoiceLineNumber), '001')"/>
         </xsl:attribute>
         <xsl:attribute name="quantity">1</xsl:attribute>
         <InvoiceDetailServiceItemReference>
            <xsl:attribute name="lineNumber">
               <xsl:value-of select="InvoiceDetailServiceItemReference/@lineNumber"/>
            </xsl:attribute>
            <ItemID>
               <SupplierPartID/>
            </ItemID>
            <Description xml:lang="en">WellServiceTax</Description>
         </InvoiceDetailServiceItemReference>
         <SubtotalAmount>
            <xsl:copy-of select="(InvoiceItemModifications/Modification[ModificationDetail/Description = 'WellServiceTax'])[1]/AdditionalCost/Money"/>
         </SubtotalAmount>
         <UnitOfMeasure>EA</UnitOfMeasure>
         <UnitPrice>
            <xsl:copy-of select="(InvoiceItemModifications/Modification[ModificationDetail/Description = 'WellServiceTax'])[1]/AdditionalCost/Money"/>
         </UnitPrice>
         <Tax>
            <Money>
               <xsl:attribute name="currency">
                  <xsl:value-of select="(InvoiceItemModifications/Modification[ModificationDetail/Description = 'WellServiceTax'])[1]/AdditionalCost/Money/@currency"/>
               </xsl:attribute>
               <xsl:value-of select="'0.0'"/>
            </Money>
            <Description xml:lang="en">WellServiceTax</Description>
            <TaxDetail>
               <xsl:attribute name="category">
                  <xsl:value-of select="'sales'"/>
               </xsl:attribute>
               <xsl:attribute name="exemptDetail">
                  <xsl:value-of select="'exempt'"/>
               </xsl:attribute>
               <xsl:attribute name="percentageRate">
                  <xsl:value-of select="'0.0'"/>
               </xsl:attribute>
               <TaxableAmount>
                  <xsl:copy-of select="(InvoiceItemModifications/Modification[ModificationDetail/Description = 'WellServiceTax'])[1]/AdditionalCost/Money"/>
               </TaxableAmount>
               <TaxAmount>
                  <Money>
                     <xsl:attribute name="currency">
                        <xsl:value-of select="(InvoiceItemModifications/Modification[ModificationDetail/Description = 'WellServiceTax'])[1]/AdditionalCost/Money/@currency"/>
                     </xsl:attribute>
                     <xsl:value-of select="'0.0'"/>
                  </Money>
               </TaxAmount>
            </TaxDetail>
         </Tax>
         <Comments xml:lang="en">WellServiceTax</Comments>
      </InvoiceDetailServiceItem>
   </xsl:template>

   <xsl:template match="//InvoiceDetailSummary[not(exists(GrossAmount))]">
      <InvoiceDetailSummary>
         <xsl:copy-of select="SubtotalAmount | Tax | ShippingAmount | SpecialHandlingAmount"/>
         <xsl:element name="GrossAmount">
            <xsl:copy-of select="NetAmount/child::*"/>
         </xsl:element>
         <xsl:copy-of select="Tax/following-sibling::*[not(self::ShippingAmount) and not(self::SpecialHandlingAmount)]"/>
      </InvoiceDetailSummary>
   </xsl:template>

   <xsl:template match="//InvoiceDetailSummary/GrossAmount">
      <xsl:element name="GrossAmount">
         <xsl:copy-of select="NetAmount/child::*"/>
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
