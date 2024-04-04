<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   <xsl:template match="//M_850/G_N1[last()]">
   <xsl:copy-of
            select="."/>
      <xsl:if test="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'addresseeReference' or @name = 'agencyLocationCode' or @name = 'plantNo' or @name = 'locationCity' or @name = 'deliveryRegion' or @name = 'locationNo' or @name = 'radioCode'] != ''">
         <G_N1>

            <S_N1>

               <D_98>SO</D_98>
               <D_93>
                  <xsl:value-of
                     select="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'addresseeReference']"
                  />
               </D_93>

               <D_67>
                  <xsl:value-of
                     select="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'agencyLocationCode']"
                  />
               </D_67>
            </S_N1>

            <S_N3>
               <D_166>
                  <xsl:value-of
                     select="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'plantNo']"/>
               </D_166>
            </S_N3>
            <S_N4>
               <D_19>
                  <xsl:value-of
                     select="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'locationCity']"/>
               </D_19>
               <D_156>
                  <xsl:value-of
                     select="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'deliveryRegion']"
                  />
               </D_156>
               <D_116>
                  <xsl:value-of
                     select="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'locationNo']"/>
               </D_116>
               <D_26>
                  <xsl:value-of
                     select="//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'radioCode']"/>
               </D_26>
            </S_N4>


         </G_N1>
         </xsl:if>
         
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
