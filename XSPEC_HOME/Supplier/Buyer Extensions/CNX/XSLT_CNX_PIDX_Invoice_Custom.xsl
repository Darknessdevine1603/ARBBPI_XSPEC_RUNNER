<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:param name="anSenderDefaultTimeZone"/>
   <xsl:param name="DefaultTimeZone" select="//Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate"/>      
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   
   
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[last()]">
      <xsl:copy-of select="."/>
      <xsl:if
         test="normalize-space(//pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'LocationNumber'][lower-case(pidx:Description) = 'location code']/pidx:ReferenceNumber) != ''">
         <Extrinsic>
            <xsl:attribute name="name">locationSpecificServicesRefNo</xsl:attribute>
            <xsl:value-of
               select="normalize-space(//pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[@referenceInformationIndicator = 'LocationNumber'][lower-case(pidx:Description) = 'location code']/pidx:ReferenceNumber)"
            />
         </Extrinsic>
      </xsl:if>
   </xsl:template>   
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
      <xsl:variable name="linenum" select="@invoiceLineNumber"/>
      <xsl:element name="InvoiceDetailItem">
         <xsl:copy-of select="./@*"/>
         
         <xsl:if test="normalize-space(@referenceDate) = ''">
            <xsl:if test="//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ServiceDateTime/@dateTypeIndicator = 'ServicePeriodStart'">
               <xsl:attribute name="referenceDate">
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodStart']"
                     />
                  </xsl:call-template>
               </xsl:attribute>
            </xsl:if>
         </xsl:if>
         
         <xsl:copy-of select="child::*"/>

         <xsl:call-template name="buildLineExtrinsics">
            <xsl:with-param name="linenum" select="$linenum"/>
         </xsl:call-template>
      </xsl:element>


   </xsl:template>

   <!--<xsl:template
      match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/child::*[last()]">
      <xsl:variable name="linenum" select="../@invoiceLineNumber"/>
      <xsl:copy-of select="."/>
      <xsl:call-template name="buildLineExtrinsics">
         <xsl:with-param name="linenum" select="$linenum"/>
      </xsl:call-template>
   </xsl:template>-->
   
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem">
      <xsl:element name="InvoiceDetailServiceItem">
         <xsl:copy-of select="@*"/>         
         <xsl:variable name="linenum" select="@invoiceLineNumber"/>
         <xsl:if test="normalize-space(@referenceDate) = ''">
            <xsl:if test="//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ServiceDateTime/@dateTypeIndicator = 'ServicePeriodStart'">
               <xsl:attribute name="referenceDate">
                  <xsl:call-template name="formatDate">
                     <xsl:with-param name="DocDate"
                        select="//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ServiceDateTime[@dateTypeIndicator = 'ServicePeriodStart']"
                     />
                  </xsl:call-template>
               </xsl:attribute>
            </xsl:if>
         </xsl:if>
         
         <xsl:copy-of select="SubtotalAmount/preceding-sibling::*"/>
         <xsl:copy-of select="SubtotalAmount"/>
         <xsl:choose>
            <xsl:when test="Period/@startDate != '' and Period/@endDate != ''">
               <xsl:copy-of select="Period"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:if test="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Period">
                  <xsl:copy-of select="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Period"/>
               </xsl:if>

            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="SubtotalAmount/following-sibling::*[not(self::Period)]"/>
         <xsl:call-template name="buildLineExtrinsics">
            <xsl:with-param name="linenum" select="$linenum"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>

   <!-- IG-16830 -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary">
      <xsl:element name="InvoiceDetailSummary">
         <xsl:apply-templates select="SubtotalAmount"/>
         <xsl:apply-templates select="Tax"/>
         <xsl:apply-templates select="SpecialHandlingAmount"/>
         <!-- ShippingAmount -->
         <xsl:choose>
            <xsl:when test="exists(InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Freight'])">
               <ShippingAmount>
                  <xsl:copy-of select="InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Freight'][1]/AdditionalCost/Money"/>
               </ShippingAmount>
            </xsl:when>
            <xsl:when test="//pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount[1]/pidx:MonetaryAmount!=''">
               <ShippingAmount>
                  <Money>
                     <xsl:attribute name="currency">
                        <xsl:choose>
                           <xsl:when test="//pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount[1]/pidx:CurrencyCode!=''">
                              <xsl:value-of select="//pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount[1]/pidx:CurrencyCode"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="pidx:Invoice/pidx:InvoiceProperties/pidx:PrimaryCurrency/pidx:CurrencyCode"/>
                           </xsl:otherwise>
                        </xsl:choose>                     
                     </xsl:attribute>
                     <xsl:value-of select="//pidx:Invoice/pidx:InvoiceSummary/pidx:ShippingAmount[1]/pidx:MonetaryAmount"/>
                  </Money>
               </ShippingAmount>
            </xsl:when>            
            <xsl:otherwise>
               <xsl:apply-templates select="ShippingAmount"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:apply-templates select="GrossAmount"/>
         <!-- InvoiceDetailDiscount -->
         <xsl:choose>
            <xsl:when test="exists(InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Discount'])">
               <InvoiceDetailDiscount>
                  <xsl:choose>
                     <xsl:when test="exists(InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Discount']/AdditionalDeduction/DeductionPercent/@percent)">
                        <xsl:attribute name="percentageRate">
                           <xsl:value-of select="InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Discount'][1]/AdditionalDeduction/DeductionPercent/@percent"/>
                        </xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Discount'][1]/AdditionalDeduction/DeductionAmount/Money"/>
                     </xsl:otherwise>
                  </xsl:choose>                  
               </InvoiceDetailDiscount>
            </xsl:when>                        
            <xsl:otherwise>
               <xsl:apply-templates select="InvoiceDetailDiscount"/>
            </xsl:otherwise>
         </xsl:choose>
         <!-- InvoiceHeaderModifications -->
         <xsl:choose>
            <xsl:when test="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/(not(@name = 'Discount') and not(@name = 'Freight'))]">               
               <InvoiceHeaderModifications>
                  <xsl:copy-of select="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/(not(@name = 'Discount') and not(@name = 'Freight'))]"/>
               </InvoiceHeaderModifications>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
         </xsl:choose>
         
         <xsl:apply-templates select="Tax/following-sibling::*[not(self::SpecialHandlingAmount) and not(self::ShippingAmount) and not(self::GrossAmount) and not(self::InvoiceDetailDiscount) and not(self::InvoiceHeaderModifications)]"/>        
         
      </xsl:element>
   </xsl:template>
  
   <xsl:template match="Name[parent::AccountingSegment]">
      <xsl:choose>
         <xsl:when test=". = 'AFENumber'">
            <xsl:element name="Name">
               <xsl:copy-of select="@*"/>
               <xsl:text>WBSElement</xsl:text>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <xsl:template match="Description[parent::AccountingSegment]">
      <xsl:param name="accType"/>
      <xsl:choose>
         <xsl:when test="$accType = 'AFENumber'">
            <xsl:element name="Description">
               <xsl:copy-of select="@*"/>
               <xsl:text>ID</xsl:text>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//Distribution/Accounting/AccountingSegment">
      <xsl:variable name="accType" select="Name"/>
      <xsl:element name="AccountingSegment">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates>
            <xsl:with-param name="accType" select="$accType"/>
         </xsl:apply-templates>
      </xsl:element>
   </xsl:template>
   <xsl:template name="buildLineExtrinsics">
      <xsl:param name="linenum"/>

      <xsl:choose>
         <xsl:when
            test="normalize-space(//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other'][lower-case(pidx:Description) = 'accountcategory']/pidx:ReferenceNumber) != ''"> </xsl:when>
         <xsl:when
            test="normalize-space(//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'AFENumber' or @referenceInformationIndicator = 'WBSElement']/pidx:ReferenceNumber) != ''">
            <Extrinsic>
               <xsl:attribute name="name">AccountCategory</xsl:attribute>
               <xsl:value-of select="'P'"/>
            </Extrinsic>
         </xsl:when>
         <xsl:when
            test="normalize-space(//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'InternalOrder' or @referenceInformationIndicator = 'WorkOrder' or @referenceInformationIndicator = 'JobNumber']/pidx:ReferenceNumber) != ''">
            <Extrinsic>
               <xsl:attribute name="name">AccountCategory</xsl:attribute>
               <xsl:value-of select="'F'"/>
            </Extrinsic>
         </xsl:when>
         <xsl:when
            test="normalize-space(//pidx:InvoiceDetails/pidx:InvoiceLineItem[pidx:LineItemNumber = $linenum]/pidx:ReferenceInformation[@referenceInformationIndicator = 'CostCenter']/pidx:ReferenceNumber) != ''">
            <Extrinsic>
               <xsl:attribute name="name">AccountCategory</xsl:attribute>
               <xsl:value-of select="'K'"/>
            </Extrinsic>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
     

   <xsl:template name="formatDate">
      <xsl:param name="DocDate"/>
      <xsl:choose>
         <xsl:when test="$DocDate">
            <xsl:variable name="Time1" select="substring($DocDate, 11)"/>
            <!-- Date from InvoiceDetailRequestHeader/@invoiceDate -->
            <xsl:variable name="cXMLTimeZone">
               <xsl:variable name="cTimeZone" select="substring($DefaultTimeZone, 11)"/>
               <xsl:variable name="cXMLTimeZone1">
               <xsl:value-of select="concat(substring-after($cTimeZone, '+'), substring-after($cTimeZone, '-'))"/>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="contains($cTimeZone, '+')">
                     <xsl:value-of select="concat('+', $cXMLTimeZone1)"/>
                  </xsl:when>
                  <xsl:when test="contains($cTimeZone, '-')">
                     <xsl:value-of select="concat('-', $cXMLTimeZone1)"/>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Time">
               <xsl:choose>
                  <xsl:when test="string-length($Time1) &gt; 0">
                     <xsl:variable name="timezone"
                        select="concat(substring-after($Time1, '+'), substring-after($Time1, '-'))"/>
                     <xsl:choose>
                        <xsl:when test="string-length($timezone) &gt; 0">
                           <xsl:value-of select="''"/>
                        </xsl:when>
                        <xsl:when test="$anSenderDefaultTimeZone!=''">
                           <xsl:value-of select="$anSenderDefaultTimeZone"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$cXMLTimeZone"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="$anSenderDefaultTimeZone!=''">
                           <xsl:value-of select="concat('T00:00:00', $anSenderDefaultTimeZone)"/>                           
                        </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="concat('T00:00:00', $cXMLTimeZone)"/>
                     </xsl:otherwise>
                     </xsl:choose>                     
                  </xsl:otherwise>
               </xsl:choose>
               
            </xsl:variable>
            <xsl:value-of select="concat($DocDate, $Time)"/>
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
