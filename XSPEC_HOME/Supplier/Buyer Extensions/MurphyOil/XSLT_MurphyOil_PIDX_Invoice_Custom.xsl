<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator">
      <xsl:element name="InvoiceDetailLineIndicator">
         <xsl:choose>
            <xsl:when test="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem/pidx:Tax/pidx:TaxTypeCode = 'WellServiceTax'">
               <xsl:attribute name="isTaxInLine">yes</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="@isTaxInLine"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="@isAccountingInLine, @isSpecialHandlingInLine, @isShippingInLine, @isDiscountInLine, @isPriceAdjustmentInLine"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceItemModifications">
      <xsl:choose>
         <xsl:when test="Modification[(ModificationDetail/@name != 'Charge') and (ModificationDetail/Description != 'WellServiceTax')]">
            <xsl:element name="InvoiceItemModifications">
               <xsl:copy-of select="Modification[(ModificationDetail/@name != 'Charge') and (ModificationDetail/Description != 'WellServiceTax')]"/>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/InvoiceItemModifications">
      <xsl:choose>
         <xsl:when test="Modification[(ModificationDetail/@name != 'Charge') and (ModificationDetail/Description != 'WellServiceTax')]">
            <xsl:element name="InvoiceItemModifications">
               <xsl:copy-of select="Modification[(ModificationDetail/@name != 'Charge') and (ModificationDetail/Description != 'WellServiceTax')]"/>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications">
      <xsl:choose>
         <xsl:when test="Modification[(ModificationDetail/@name != 'Charge') and (ModificationDetail/Description != 'WellServiceTax')]">
            <xsl:element name="InvoiceHeaderModifications">
               <xsl:copy-of select="Modification[(ModificationDetail/@name != 'Charge') and (ModificationDetail/Description != 'WellServiceTax')]"/>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
      <xsl:variable name="linenum" select="@invoiceLineNumber"/>
      <xsl:element name="InvoiceDetailItem">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates select="UnitOfMeasure"/>
         <xsl:apply-templates select="UnitPrice"/>
         <xsl:apply-templates select="PriceBasisQuantity"/>
         <xsl:apply-templates select="InvoiceDetailItemReference"/>
         <xsl:apply-templates select="ReceiptLineItemReference"/>
         <xsl:apply-templates select="ShipNoticeLineItemReference"/>
         <xsl:apply-templates select="ServiceEntryItemReference"/>
         <xsl:apply-templates select="ServiceEntryItemIDInfo"/>
         <xsl:apply-templates select="ProductMovementItemIDInfo"/>
         <xsl:apply-templates select="SubtotalAmount"/>
         <xsl:choose>
            <xsl:when test="not(exists(Tax))">
               <xsl:if test="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax/pidx:TaxTypeCode = 'WellServiceTax'">
                  <xsl:element name="Tax">
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:CurrencyCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:MonetaryAmount"/>
                     </Money>
                     <Description>
                        <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                        <xsl:value-of select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxTypeCode"/>
                     </Description>
                     <xsl:for-each select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax">
                        <xsl:if test="pidx:TaxTypeCode = 'WellServiceTax'">
                           <xsl:element name="TaxDetail">
                              <xsl:call-template name="TaxDetail"> </xsl:call-template>
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:if>
               <xsl:apply-templates select="UnitPrice/following-sibling::*[not(self::PriceBasisQuantity) and not(self::InvoiceDetailItemReference) and not(self::ReceiptLineItemReference) and not(self::ShipNoticeLineItemReference) and not(self::ServiceEntryItemReference) and not(self::ServiceEntryItemIDInfo) and not(self::ProductMovementItemIDInfo) and not(self::SubtotalAmount)]"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="Tax">
                  <xsl:copy-of select="Tax/Money"/>
                  <xsl:copy-of select="Tax/TaxAdjustmentAmount"/>
                  <xsl:copy-of select="Tax/Description"/>
                  <xsl:copy-of select="Tax/TaxDetail"/>
                  <xsl:for-each select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax">
                     <xsl:if test="pidx:TaxTypeCode = 'WellServiceTax'">
                        <xsl:element name="TaxDetail">
                           <xsl:call-template name="TaxDetail"> </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:copy-of select="Tax/Distribution"/>
                  <xsl:copy-of select="Tax/Extrinsic"/>
               </xsl:element>
               <xsl:apply-templates select="UnitPrice/following-sibling::*[not(self::PriceBasisQuantity) and not(self::InvoiceDetailItemReference) and not(self::ReceiptLineItemReference) and not(self::ShipNoticeLineItemReference) and not(self::ServiceEntryItemReference) and not(self::ServiceEntryItemIDInfo) and not(self::ProductMovementItemIDInfo) and not(self::SubtotalAmount) and not(self::Tax)]"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem">
      <xsl:variable name="linenum" select="@invoiceLineNumber"/>
      <xsl:element name="InvoiceDetailServiceItem">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates select="InvoiceDetailServiceItemReference"/>
         <xsl:apply-templates select="ServiceEntryItemReference"/>
         <xsl:apply-templates select="ServiceEntryItemIDInfo"/>
         <xsl:apply-templates select="SubtotalAmount"/>
         <xsl:apply-templates select="Period"/>
         <xsl:apply-templates select="UnitRate"/>
         <xsl:apply-templates select="UnitOfMeasure"/>
         <xsl:apply-templates select="UnitPrice"/>
         <xsl:apply-templates select="PriceBasisQuantity"/>
         <xsl:choose>
            <xsl:when test="not(exists(Tax))">
               <xsl:if test="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax/pidx:TaxTypeCode = 'WellServiceTax'">
                  <xsl:element name="Tax">
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:CurrencyCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:MonetaryAmount"/>
                     </Money>
                     <Description>
                        <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                        <xsl:value-of select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxTypeCode"/>
                     </Description>
                     <xsl:for-each select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax">
                        <xsl:if test="pidx:TaxTypeCode = 'WellServiceTax'">
                           <xsl:element name="TaxDetail">
                              <xsl:call-template name="TaxDetail"> </xsl:call-template>
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:if>
               <xsl:apply-templates select="SubtotalAmount/following-sibling::*[not(self::Period) and not(self::UnitRate) and not(self::UnitOfMeasure) and not(self::UnitPrice) and not(self::PriceBasisQuantity)]"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="Tax">
                  <xsl:copy-of select="Tax/Money"/>
                  <xsl:copy-of select="Tax/TaxAdjustmentAmount"/>
                  <xsl:copy-of select="Tax/Description"/>
                  <xsl:copy-of select="Tax/TaxDetail"/>
                  <xsl:for-each select="//pidx:Invoice/pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:Tax">
                     <xsl:if test="pidx:TaxTypeCode = 'WellServiceTax'">
                        <xsl:element name="TaxDetail">
                           <xsl:call-template name="TaxDetail"> </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:copy-of select="Tax/Distribution"/>
                  <xsl:copy-of select="Tax/Extrinsic"/>
               </xsl:element>
               <xsl:apply-templates select="SubtotalAmount/following-sibling::*[not(self::Period) and not(self::UnitRate) and not(self::UnitOfMeasure) and not(self::UnitPrice) and not(self::PriceBasisQuantity) and not(self::Tax)]"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailHeaderOrder/InvoiceDetailOrderSummary">
      <xsl:element name="InvoiceDetailOrderSummary">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates select="SubtotalAmount"/>
         <xsl:apply-templates select="Period"/>
         <xsl:choose>
            <xsl:when test="not(exists(Tax)) or Tax/Money = '0.00'">
               <xsl:if test="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax/pidx:TaxTypeCode = 'WellServiceTax'">
                  <xsl:element name="Tax">
                     <Money>
                        <xsl:attribute name="currency">
                           <xsl:value-of select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:CurrencyCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:MonetaryAmount"/>
                     </Money>
                     <Description>
                        <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                        <xsl:value-of select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxTypeCode"/>
                     </Description>
                     <xsl:for-each select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax">
                        <xsl:if test="pidx:TaxTypeCode = 'WellServiceTax'">
                           <xsl:element name="TaxDetail">
                              <xsl:call-template name="TaxDetail"> </xsl:call-template>
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:if>
               <xsl:apply-templates select="SubtotalAmount/following-sibling::*[not(self::Period)]"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="Tax">
                  <xsl:copy-of select="Tax/Money"/>
                  <xsl:copy-of select="Tax/TaxAdjustmentAmount"/>
                  <xsl:copy-of select="Tax/Description"/>
                  <xsl:copy-of select="Tax/TaxDetail"/>
                  <xsl:for-each select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax">
                     <xsl:if test="pidx:TaxTypeCode = 'WellServiceTax'">
                        <xsl:element name="TaxDetail">
                           <xsl:call-template name="TaxDetail"> </xsl:call-template>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:copy-of select="Tax/Distribution"/>
                  <xsl:copy-of select="Tax/Extrinsic"/>
               </xsl:element>
               <xsl:apply-templates select="SubtotalAmount/following-sibling::*[not(self::Period) and not(self::Tax)]"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/Tax">
      <xsl:element name="Tax">
         <xsl:choose>
            <xsl:when test="Money = '0.00'">
               <Money>
                  <xsl:attribute name="currency">
                     <xsl:choose>
                        <xsl:when test="normalize-space(//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:CurrencyCode) != ''">
                           <xsl:value-of select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:CurrencyCode"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="Money/@currency"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="normalize-space(//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:MonetaryAmount) != ''">
                        <xsl:value-of select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax[1][pidx:TaxTypeCode = 'WellServiceTax']/pidx:TaxAmount/pidx:MonetaryAmount"/>
                     </xsl:when>
                     <xsl:otherwise>0.00</xsl:otherwise>
                  </xsl:choose>
               </Money>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="Money"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="TaxAdjustmentAmount"/>
         <xsl:copy-of select="Description"/>
         <xsl:copy-of select="TaxDetail"/>
         <xsl:for-each select="//pidx:Invoice/pidx:InvoiceSummary/pidx:Tax">
            <xsl:if test="pidx:TaxTypeCode = 'WellServiceTax'">
               <xsl:element name="TaxDetail">
                  <xsl:call-template name="TaxDetail"> </xsl:call-template>
               </xsl:element>
            </xsl:if>
         </xsl:for-each>
         <xsl:copy-of select="Distribution"/>
         <xsl:copy-of select="Extrinsic"/>
      </xsl:element>
   </xsl:template>
   <xsl:template name="TaxDetail">
      <xsl:param name="line"/>
      <xsl:param name="item"/>
      <xsl:attribute name="category">sales</xsl:attribute>
      <xsl:attribute name="percentageRate">
         <xsl:value-of select="pidx:TaxRate"/>
      </xsl:attribute>
      <xsl:if test="pidx:TaxExemptCode = 'Exempt'">
         <xsl:attribute name="exemptDetail">
            <xsl:text>exempt</xsl:text>
         </xsl:attribute>
      </xsl:if>
      <xsl:if test="normalize-space(pidx:TaxBasisAmount/pidx:MonetaryAmount) != ''">
         <TaxableAmount>
            <Money>
               <xsl:attribute name="currency">
                  <xsl:value-of select="pidx:TaxBasisAmount/pidx:CurrencyCode"/>
               </xsl:attribute>
               <xsl:value-of select="pidx:TaxBasisAmount/pidx:MonetaryAmount"/>
            </Money>
         </TaxableAmount>
      </xsl:if>
      <TaxAmount>
         <Money>
            <xsl:attribute name="currency">
               <xsl:value-of select="pidx:TaxAmount/pidx:CurrencyCode"/>
            </xsl:attribute>
            <xsl:value-of select="pidx:TaxAmount/pidx:MonetaryAmount"/>
         </Money>
      </TaxAmount>
      <Description>
         <xsl:attribute name="xml:lang">en-US</xsl:attribute>
         <xsl:value-of select="pidx:TaxTypeCode"/>
      </Description>
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
