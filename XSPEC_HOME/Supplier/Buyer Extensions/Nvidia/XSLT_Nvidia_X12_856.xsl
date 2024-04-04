<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem">
      <xsl:choose>
         <xsl:when test="/Combined//FunctionalGroup/M_856/S_BSN/D_1005 = '0001'">
            <xsl:element name="ShipNoticeItem">
               <xsl:variable name="linenum" select="@shipNoticeLineNumber"/>
               <xsl:variable name="lineRef" select="//M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $linenum]/S_HL/D_734"/>
               <xsl:if test="$lineRef">
                  <xsl:if test="//M_856/G_HL[S_HL/D_628 = $lineRef][S_HL/D_735 = 'P']">
                     <xsl:variable name="parentLineRef" select="//M_856/G_HL[S_HL/D_628 = $lineRef][S_HL/D_735 = 'P']/S_HL/D_734"/>
                     <xsl:variable name="parentPack" select="//M_856/G_HL[S_HL/D_628 = $lineRef][S_HL/D_735 = 'P']/S_PO4/D_356"/>
                     <xsl:variable name="parentSize" select="//M_856/G_HL[S_HL/D_628 = $lineRef][S_HL/D_735 = 'P']/S_PO4/D_357"/>
                     <xsl:variable name="packDispatchQty" select="$parentPack*$parentSize"/>
                     <xsl:choose>
                        <xsl:when test="//M_856/G_HL[S_HL/D_628 = $parentLineRef][S_HL/D_735 = 'T']">
                           <xsl:variable name="grandParentLineRef" select="//M_856/G_HL[S_HL/D_628 = $parentLineRef][S_HL/D_735 = 'T']/S_HL/D_734"/>
                           <xsl:variable name="grdparentPack" select="//M_856/G_HL[S_HL/D_628 = $parentLineRef][S_HL/D_735 = 'T']/S_PO4/D_356"/>
                           <xsl:variable name="grdparentSize" select="//M_856/G_HL[S_HL/D_628 = $parentLineRef][S_HL/D_735 = 'T']/S_PO4/D_357"/>
                           <xsl:variable name="grdpackDispatchQty" select="$grdparentPack*$grdparentSize"/>
                           <xsl:variable name="grdpackDispatchUOM" select="UnitOfMeasure"/>
                           <xsl:apply-templates select="@* | node()">
                              <xsl:with-param name="linenum" select="$linenum"/>
                              <xsl:with-param name="grdpackDispatchQty" select="$grdpackDispatchQty"/>
                              <xsl:with-param name="grdpackDispatchUOM" select="$grdpackDispatchUOM"/>
                              <xsl:with-param name="packDispatchQty" select="$packDispatchQty"/>
                           </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:apply-templates select="@* | node()">
                              <xsl:with-param name="linenum" select="$linenum"/>
                              <xsl:with-param name="packDispatchQty" select="$packDispatchQty"/>
                           </xsl:apply-templates>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </xsl:if>
            </xsl:element>

         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="Packaging[PackagingLevelCode != '0001' or not(exists(PackagingLevelCode))][./parent::ShipNoticeItem]">
      <xsl:param name="packDispatchQty"/>
      <xsl:element name="Packaging">
         <xsl:copy-of select="DispatchQuantity/preceding-sibling::*"/>
         <xsl:element name="DispatchQuantity">
            <xsl:attribute name="quantity">
               <xsl:value-of select="$packDispatchQty"/>
            </xsl:attribute>
            <xsl:element name="UnitOfMeasure">
               <xsl:value-of select="DispatchQuantity/UnitOfMeasure"/>
            </xsl:element>
         </xsl:element>

      </xsl:element>
   </xsl:template>

   <xsl:template match="Packaging[PackagingLevelCode = '0001'][./parent::ShipNoticeItem]">
      <xsl:param name="grdpackDispatchQty"/>
      <xsl:param name="grdpackDispatchUOM"/>
      <xsl:element name="Packaging">
         <xsl:copy-of select="./child::*[name()!='FreeGoodsQuantity' or name()!='QuantityVarianceNote' or name()!='BestBeforeDate' or name()!='Extrinsic']"/>
         <xsl:element name="DispatchQuantity">
            <xsl:attribute name="quantity">
               <xsl:value-of select="$grdpackDispatchQty"/>
            </xsl:attribute>
            <xsl:element name="UnitOfMeasure">
               <xsl:value-of select="$grdpackDispatchUOM"/>
            </xsl:element>
         </xsl:element>
         <xsl:copy-of select="./child::*[name()='FreeGoodsQuantity' or name()='QuantityVarianceNote' or name()='BestBeforeDate' or name()='Extrinsic']"/>

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
