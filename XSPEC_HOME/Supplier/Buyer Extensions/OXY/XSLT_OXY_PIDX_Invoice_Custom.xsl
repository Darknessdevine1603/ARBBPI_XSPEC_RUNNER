<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   
   <xsl:template match="//source"/>
   <!-- Extension Start  -->

   <xsl:variable name="docLang">
      <xsl:choose>
         <xsl:when test="pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode">
            <xsl:value-of select="pidx:Invoice/pidx:InvoiceProperties/pidx:LanguageCode"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'en'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>

   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[last()]">
      <xsl:copy-of select="."/>
      <xsl:if
         test="//pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:ContactInformation/@contactInformationIndicator = 'OfficeRepresentative'">
         <InvoicePartner>
            <Contact role="requester">
               <Name>
                  <xsl:attribute name="xml:lang">
                     <xsl:value-of select="$docLang"/>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="normalize-space(//pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:ContactInformation[@contactInformationIndicator = 'OfficeRepresentative']/pidx:ContactName)!=''">
                        <xsl:value-of
                           select="//pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:ContactInformation[@contactInformationIndicator = 'OfficeRepresentative']/pidx:ContactName"
                        />
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of
                           select="//pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:ContactInformation[@contactInformationIndicator = 'OfficeRepresentative']/pidx:EmailAddress"
                        />
                     </xsl:otherwise>
                  </xsl:choose>                  
               </Name>
               <Email>
                  <xsl:value-of
                     select="//pidx:Invoice/pidx:InvoiceProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'SoldTo']/pidx:ContactInformation[@contactInformationIndicator = 'OfficeRepresentative']/pidx:EmailAddress"
                  />
               </Email>
            </Contact>
         </InvoicePartner>
      </xsl:if>
   </xsl:template>
   <xsl:template
      match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/child::*[last()]">
      <xsl:variable name="linenum" select="../@invoiceLineNumber"/>
      <xsl:copy-of select="."/>
      <xsl:call-template name="buildLineExtrinsics">
         <xsl:with-param name="linenum" select="$linenum"/>
      </xsl:call-template>
   </xsl:template>
   
   <xsl:template match="//UnitOfMeasure">
      <xsl:variable name="currentUOM" select="./text()"/>
      <UnitOfMeasure>
         <xsl:choose>
            <xsl:when test="$currentUOM = 'BR'">
               <xsl:value-of select="'BBL'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'BLL'">
               <xsl:value-of select="'BBL'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'HV'">
               <xsl:value-of select="'CWT'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'JA'">
               <xsl:value-of select="'JOB'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'E51'">
               <xsl:value-of select="'JOB'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'LB'">
               <xsl:value-of select="'LB'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'LBR'">
               <xsl:value-of select="'LB'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'TN'">
               <xsl:value-of select="'TON'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'STN'">
               <xsl:value-of select="'TON'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'CN'">
               <xsl:value-of select="'CAN'"/>
            </xsl:when>
            <xsl:when test="$currentUOM = 'CA'">
               <xsl:value-of select="'CAN'"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$currentUOM"/>
            </xsl:otherwise>
         </xsl:choose>
      </UnitOfMeasure>
   </xsl:template>

   <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications">
      <xsl:choose>
         <xsl:when test="exists(Modification[ModificationDetail/@name = 'Freight'])">
            <xsl:if test="Modification[ModificationDetail/@name = 'Freight']">
               <ShippingAmount>
                  <xsl:copy-of
                     select="Modification[ModificationDetail/@name = 'Freight'][1]/AdditionalCost/Money"
                  />
               </ShippingAmount>
            </xsl:if>
            <xsl:choose>
               <xsl:when
                  test="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/(not(@name = 'Freight'))]">
                  <InvoiceHeaderModifications>
                     <xsl:copy-of
                        select="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/(not(@name = 'Freight'))]"
                     />
                  </InvoiceHeaderModifications>
               </xsl:when>
               <xsl:otherwise> </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
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
