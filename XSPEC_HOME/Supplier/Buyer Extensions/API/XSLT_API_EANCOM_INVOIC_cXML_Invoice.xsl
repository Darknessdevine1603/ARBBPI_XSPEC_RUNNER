<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:param name="anSenderDefaultTimeZone"/>
   <!-- For local testing -->
   <!--xsl:variable name="lookups" select="document('LOOKUP_EANCOM_D01BEAN011.xml')"/>   <xsl:include href="Format_EANCOM_D01BEAN011_CXML_common.xsl"/-->
   <!-- for dynamic, reading from Partner Directory -->
   <xsl:include href="pd:HCIOWNERPID:FORMAT_EANCOM_D01BEAN011_cXML_0000:Binary"/>
   <xsl:variable name="lookups" select="document('pd:HCIOWNERPID:LOOKUP_EANCOM_D01BEAN011:Binary')"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>
   <xsl:variable name="isCreditMemo">
      <xsl:choose>
         <xsl:when
            test="//InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = 'lineLevelCreditMemo'"
            >yes</xsl:when>
         <xsl:when test="//InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = 'creditMemo'"
            >yes</xsl:when>
         <xsl:otherwise>no</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:variable name="headerCurrency" select="//M_INVOIC/G_SG7/S_CUX/C_C504[D_6343 = '4']/D_6345"/>
   <xsl:variable name="headerCurrencyAlt"
      select="//M_INVOIC/G_SG7/S_CUX/C_C504[D_6343 = '11']/D_6345"/>
   <!-- Extension Start  -->
   <!-- Header updates -->
   <xsl:template
      match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'supplierCorporate']">
      <xsl:choose>
         <xsl:when
            test="not(//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'from'])">
            <Contact>
               <xsl:copy-of select="./@*[name() != 'role']"/>
               <xsl:attribute name="role">
                  <xsl:text>from</xsl:text>
               </xsl:attribute>
               <xsl:copy-of select="./child::*"/>
            </Contact>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template
      match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'buyer']">
      <xsl:choose>
         <xsl:when
            test="not(//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'billTo'])">
            <Contact>
               <xsl:copy-of select="./@*[name() != 'role']"/>
               <xsl:attribute name="role">
                  <xsl:text>billTo</xsl:text>
               </xsl:attribute>
               <xsl:copy-of select="./child::*"/>
            </Contact>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequestHeader/InvoiceDetailLineIndicator">
      <InvoiceDetailLineIndicator>
         <xsl:copy-of select="@*[name() != 'isTaxInLine']"/>
         <xsl:if test="//M_INVOIC/G_SG26/G_SG27/S_MOA/C_C516[D_5025 = '369']/D_5004 != ''">
            <xsl:attribute name="isTaxInLine">
               <xsl:text>yes</xsl:text>
            </xsl:attribute>
         </xsl:if>
      </InvoiceDetailLineIndicator>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'SU']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name" select="'supplierVatID'"/>
            <xsl:value-of
               select="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'SU']/G_SG3/S_RFF/C_C506[D_1153 = 'AMT']/D_1154"
            />
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <!-- Detail updates -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
      <InvoiceDetailItem>
         <xsl:variable name="itemNumber" select="@invoiceLineNumber"/>
         <xsl:copy-of select="./@*"/>
         <xsl:copy-of
            select="UnitOfMeasure, UnitPrice, PriceBasisQuantity, InvoiceDetailItemReference, ReceiptLineItemReference, ShipNoticeLineItemReference, ServiceEntryItemReference, ServiceEntryItemIDInfo, ProductMovementItemIDInfo"/>
         <xsl:choose>
            <xsl:when
               test="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '128']">
               <SubtotalAmount>
                  <xsl:call-template name="createMoney">
                     <xsl:with-param name="MOA"
                        select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '128']"/>
                     <xsl:with-param name="altMOA"
                        select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '128'][D_6343 = '11']"/>
                     <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  </xsl:call-template>
               </SubtotalAmount>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="SubtotalAmount"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when
               test="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '369']">
               <Tax>
                  <xsl:call-template name="createMoney">
                     <xsl:with-param name="MOA"
                        select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '369']"/>
                     <xsl:with-param name="altMOA"
                        select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '369'][D_6343 = '11']"/>
                     <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  </xsl:call-template>
                  <Description xml:lang="en"/>
                  <xsl:for-each select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG34">
                     <TaxDetail>
                        <xsl:attribute name="category">
                           <xsl:choose>
                              <xsl:when test="S_TAX/C_C241/D_5153 != ''">
                                 <xsl:value-of select="lower-case(S_TAX/C_C241/D_5153)"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="'gst2'"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="percentageRate">
                           <xsl:choose>
                              <xsl:when test="S_TAX/C_C243/D_5278 != ''">
                                 <xsl:value-of select="S_TAX/C_C243/D_5278"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="'10_2'"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <TaxAmount>
                           <xsl:call-template name="createMoney">
                              <xsl:with-param name="MOA"
                                 select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '369']"/>
                              <xsl:with-param name="altMOA"
                                 select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '369'][D_6343 = '11']"/>
                              <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                           </xsl:call-template>
                        </TaxAmount>
                     </TaxDetail>
                  </xsl:for-each>
               </Tax>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="Tax"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of
            select="InvoiceDetailLineSpecialHandling, InvoiceDetailLineShipping, ShipNoticeIDInfo"/>
         <xsl:choose>
            <xsl:when
               test="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '203']">
               <GrossAmount>
                  <xsl:call-template name="createMoney">
                     <xsl:with-param name="MOA"
                        select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '203']"/>
                     <xsl:with-param name="altMOA"
                        select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $itemNumber]/G_SG27/S_MOA/C_C516[D_5025 = '203'][D_6343 = '11']"/>
                     <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                  </xsl:call-template>
               </GrossAmount>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="GrossAmount"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of
            select="InvoiceDetailDiscount, InvoiceItemModifications, TotalCharges, TotalAllowances, TotalAmountWithoutTax, NetAmount, Distribution, Packaging, InvoiceDetailItemIndustry, Comments, CustomsInfo, Extrinsic"
         />
      </InvoiceDetailItem>
   </xsl:template>
   <!-- summary updates -->
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money">
      <xsl:choose>
         <xsl:when test="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '128']">
            <xsl:call-template name="createMoney">
               <xsl:with-param name="MOA" select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '128']"/>
               <xsl:with-param name="altMOA"
                  select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '128'][D_6343 = '11']"/>
               <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/Tax">
      <xsl:choose>
         <xsl:when test="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '369']">
            <Tax>
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="MOA" select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '369']"/>
                  <xsl:with-param name="altMOA"
                     select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '369'][D_6343 = '11']"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               </xsl:call-template>
               <xsl:copy-of select="Description"/>
               <xsl:if test="//M_INVOIC/G_SG26/G_SG34/S_TAX[D_5283 = '7']/C_C243/D_5278 = '0.00'">
                  <xsl:variable name="zeroPercentLineNum"
                     select="(//M_INVOIC/G_SG26[G_SG34/S_TAX[D_5283 = '7']/C_C243/D_5278 = '0.00']/S_LIN/D_1082)[1]"/>
                  <TaxDetail>
                     <xsl:attribute name="category">
                        <xsl:choose>
                           <xsl:when
                              test="(//M_INVOIC/G_SG26[S_LIN/D_1082 = $zeroPercentLineNum]/G_SG34/S_TAX/C_C241/D_5153) != ''">
                              <xsl:value-of
                                 select="lower-case(//M_INVOIC/G_SG26[S_LIN/D_1082 = $zeroPercentLineNum]/G_SG34/S_TAX/C_C241/D_5153)"
                              />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="'gst'"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:attribute name="percentageRate">
                        <xsl:value-of select="'0.00'"/>
                     </xsl:attribute>
                     <TaxAmount>
                        <Money>
                           <xsl:attribute name="currency">
                              <xsl:value-of select="$headerCurrency"/>
                           </xsl:attribute>
                           <xsl:text>0.00</xsl:text>
                        </Money>
                     </TaxAmount>
                  </TaxDetail>
               </xsl:if>
               <xsl:if
                  test="//M_INVOIC/G_SG26/G_SG34/S_TAX[D_5283 = '7']/C_C243/D_5278 != '0.00' and //M_INVOIC/G_SG26/G_SG34/S_TAX[D_5283 = '7']/C_C243/D_5278 != ''">
                  <xsl:variable name="nonzeroPercentLineNum"
                     select="(//M_INVOIC/G_SG26[G_SG34/S_TAX[D_5283 = '7']/C_C243/D_5278 != '0.00']/S_LIN/D_1082)[1]"/>
                  <TaxDetail>
                     <xsl:attribute name="category">
                        <xsl:choose>
                           <xsl:when
                              test="(//M_INVOIC/G_SG26[S_LIN/D_1082 = $nonzeroPercentLineNum]/G_SG34/S_TAX/C_C241/D_5153) != ''">
                              <xsl:value-of
                                 select="lower-case(//M_INVOIC/G_SG26[S_LIN/D_1082 = $nonzeroPercentLineNum]/G_SG34/S_TAX/C_C241/D_5153)"
                              />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="'gst'"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:attribute name="percentageRate">
                        <xsl:value-of
                           select="//M_INVOIC/G_SG26[S_LIN/D_1082 = $nonzeroPercentLineNum]/G_SG34/S_TAX/C_C243/D_5278"
                        />
                     </xsl:attribute>
                     <TaxAmount>
                        <xsl:call-template name="createMoney">
                           <xsl:with-param name="MOA"
                              select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '369']"/>
                           <xsl:with-param name="altMOA"
                              select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '369'][D_6343 = '11']"/>
                           <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
                        </xsl:call-template>
                     </TaxAmount>
                  </TaxDetail>
               </xsl:if>
            </Tax>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
         <xsl:when test="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '39']">
            <!-- need to create Gross Amount -->
            <xsl:copy-of select="../SpecialHandlingAmount, ../ShippingAmount"/>
            <GrossAmount>
               <xsl:call-template name="createMoney">
                  <xsl:with-param name="MOA" select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '39']"/>
                  <xsl:with-param name="altMOA"
                     select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '39'][D_6343 = '11']"/>
                  <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
               </xsl:call-template>
            </GrossAmount>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="../SpecialHandlingAmount, ../ShippingAmount, ../GrossAmount"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount"/>
   <xsl:template match="InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount"/>
   <xsl:template match="InvoiceDetailRequest/InvoiceDetailSummary/GrossAmount"/>
   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/NetAmount/Money">
      <xsl:choose>
         <xsl:when test="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '39']">
            <xsl:call-template name="createMoney">
               <xsl:with-param name="MOA" select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '39']"/>
               <xsl:with-param name="altMOA"
                  select="//M_INVOIC/G_SG50/S_MOA/C_C516[D_5025 = '39'][D_6343 = '11']"/>
               <xsl:with-param name="isCreditMemo" select="$isCreditMemo"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
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
