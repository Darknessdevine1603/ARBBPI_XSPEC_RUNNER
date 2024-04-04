<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   
   
   <xsl:template match="//M_850/G_PO1">
      <xsl:variable name="lineNum" select="S_PO1/D_350"/>
      
         <xsl:choose>
            <xsl:when test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.ID'] != '' or //cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Name'] != ''">   
               <G_PO1>
               <xsl:copy-of select="@*|node()[name()!='G_N1' and name()!='G_SLN' and name()!='G_AMT' and name()!='G_LM']"/>         
               <G_N1>
                  <S_N1>
                     <D_98>ST</D_98>
                     <xsl:if
                        test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Name'] != ''">
                        <D_93>
                           <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Name']"/>
                        </D_93>
                     </xsl:if>
                     <D_66>92</D_66>
                     <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.ID'] != ''">
                        <D_67>
                           <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.ID']"/>
                        </D_67>
                     </xsl:if>
                  </S_N1>
               
               <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Street'] != ''">
               <S_N3>
                  <D_166>
                     <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Street']"/>
                  </D_166>
               </S_N3>
               </xsl:if>  
               <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Line2'] != ''">
                  <S_N3>
                     <D_166>
                        <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Line2']"/>
                     </D_166>
                     <D_166_2>
                        <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Line3']"/>
                     </D_166_2>
                  </S_N3>
               </xsl:if>
               <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.City'] != '' or //cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.State'] != ''">
               <S_N4>
                  <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.City'] != ''">
                  <D_19>
                     <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.City']"/>
                  </D_19>
                  </xsl:if>
                  <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.State'] != ''">
                  <D_156>
                     <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.State']"/>
                  </D_156>
                  </xsl:if>
                  <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Postal Code'] != ''">
                     <D_116>
                        <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Postal Code']"/>
                     </D_116>
                  </xsl:if>
                  <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Country'] != ''">
                  <D_26>
                     <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.Country']"/>
                  </D_26>
                  </xsl:if>
                  
               </S_N4>
               </xsl:if>
                  
                  <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.TEL_NUMBER'] != ''">
                  <S_PER>
                     <D_366>RE</D_366>
                     <D_365>TE</D_365>
                     <D_364>
                        <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.TEL_NUMBER']"/>
                     </D_364>
                  </S_PER>
                  </xsl:if>
                  
                  <xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.FAX_NUMBER'] != ''">
                     <S_PER>
                        <D_366>RE</D_366>
                        <D_365>FX</D_365>
                        <D_364>
                           <xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'Ship To.FAX_NUMBER']"/>
                        </D_364>
                     </S_PER>
                  </xsl:if>
               </G_N1>
               <xsl:copy-of select="G_SLN,G_AMT,G_LM"/>
               </G_PO1>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="."></xsl:copy-of>
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
