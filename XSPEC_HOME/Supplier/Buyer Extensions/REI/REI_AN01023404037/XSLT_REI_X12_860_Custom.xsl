<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

   <!-- 10042018 CG: REI Extension Created -->
   <!--   <xsl:include href="pd:HCIOWNERPID:FORMAT_cXML_0000_ASC-X12_004010:Binary"/>-->
   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   <xsl:template match="//M_860/S_BCH">
      <S_BCH>
         <xsl:copy-of select="D_353"/>
         <D_92>
            <xsl:choose>
               <xsl:when test="//cXML/Request/OrderRequest/ItemOut[@isReturn = 'yes']">RR</xsl:when>
               <xsl:when
                  test="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType[@documentType = 'Blanket Order']"
                  >BK</xsl:when>
               <xsl:when
                  test="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType[@documentType = 'Release Order']"
                  >RL</xsl:when>
               <xsl:otherwise>SA</xsl:otherwise>
            </xsl:choose>
         </D_92>
         <xsl:choose>
            <xsl:when
               test="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType[@documentType = 'Release Order']">
               <xsl:choose>
                  <xsl:when
                     test="//cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID != ''">
                     <D_324>
                        <xsl:value-of
                           select="//cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID"
                        />
                     </D_324>
                     <D_328>
                        <xsl:value-of
                           select="//cXML/Request/OrderRequest/OrderRequestHeader/@orderID"/>
                     </D_328>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:copy-of select="D_324, D_328"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_324, D_328"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="D_324/following-sibling::*[not(self::D_328)]"/>
      </S_BCH>
   </xsl:template>
   <xsl:template match="//M_860/S_DTM[D_374 = '007']/D_374">
      <D_374>037</D_374>
   </xsl:template>
   <xsl:template match="//M_860/S_DTM[D_374 = '036']/D_374">
      <D_374>038</D_374>
   </xsl:template>
   <xsl:template match="//M_860/S_FOB/D_309">
      <xsl:choose>
         <xsl:when
            test="//cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'Location']">
            <D_309>
               <xsl:value-of
                  select="//cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'Location']"
               />
            </D_309>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="//M_860/S_FOB/D_309"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <xsl:template match="//M_860/S_BCH/child::*[last()]">
      <xsl:copy-of select="."/>
      <D_373>
         <xsl:value-of select="replace(substring(//cXML/@timestamp, 0, 11), '-', '')"/>
      </D_373>
   </xsl:template>

   <xsl:template match="//M_860/G_POC/S_REF[last()]">
      <xsl:variable name="lineNum" select="../S_POC/D_350"/>
      <xsl:copy-of select="."/>
      <xsl:if
         test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'priceQuoteNo']) != ''">
         <S_REF>
            <D_128>PR</D_128>
            <D_127>
               <xsl:value-of
                  select="substring(normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'priceQuoteNo']), 1, 30)"
               />
            </D_127>
         </S_REF>
      </xsl:if>
   </xsl:template>

   <xsl:template match="//M_860/G_POC/S_POC/D_671">
      <xsl:variable name="lineNum" select="../D_350"/>
      <D_671>
         <xsl:choose>
            <xsl:when
               test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[@domain = 'Open Quantity']/@value != ''">

               <xsl:call-template name="formatQty">
                  <xsl:with-param name="qty"
                     select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[@domain = 'Open Quantity']/@value"
                  />
               </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="."/>
            </xsl:otherwise>
         </xsl:choose>
      </D_671>
   </xsl:template>

   <xsl:template match="//M_860/S_REF[last()]">
      <xsl:copy-of select="."/>
      <xsl:if
         test="//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/@addressID != ''">
         <S_REF>
            <D_128>IA</D_128>
            <D_127>
               <xsl:value-of
                  select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/@addressID), 1, 30)"
               />
            </D_127>
         </S_REF>
      </xsl:if>
      <xsl:choose>
         <xsl:when
            test="//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Name != ''">
            <S_PER>
               <D_366>BD</D_366>
               <D_93>
                  <xsl:value-of
                     select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Name), 1, 30)"
                  />
               </D_93>
            </S_PER>
         </xsl:when>
         <xsl:when
            test="//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Phone[1]/@name != ''">
            <S_PER>
               <D_366>BD</D_366>
               <D_93>
                  <xsl:value-of
                     select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Phone[1]/@name), 1, 30)"
                  />
               </D_93>
            </S_PER>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//M_860/S_FOB/child::*[last()]">
      <xsl:choose>
         <xsl:when
            test="normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery'][1]) != ''">
            <xsl:choose>
               <xsl:when test="name(.) = 'D_352_3'">
                  <D_352_3>
                     <xsl:value-of
                        select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery'][1]), 1, 80)"
                     />
                  </D_352_3>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="."/>
                  <D_352_3>
                     <xsl:value-of
                        select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery'][1]), 1, 80)"
                     />
                  </D_352_3>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//M_860/G_SAC/S_SAC[D_248 = 'A'][exists(D_378)]">
      <S_SAC>
         <xsl:copy-of select="D_378/preceding-sibling::*"/>
         <D_378>4</D_378>
         <xsl:copy-of select="D_378/following-sibling::* intersect D_352/preceding-sibling::*"/>
         <D_331>15</D_331>
         <xsl:copy-of select="D_352 | D_819"/>
      </S_SAC>
   </xsl:template>

   <xsl:template match="//M_860/G_SAC/S_SAC[D_248 = 'A'][exists(D_610)]">
      <S_SAC>
         <xsl:copy-of select="D_610/preceding-sibling::* | D_610"/>
         <D_331>15</D_331>
         <xsl:copy-of select="D_610/following-sibling::*"/>
      </S_SAC>
   </xsl:template>

   <xsl:template match="//M_860/G_SAC/S_SAC[D_248 = 'C']/D_352">
      <D_331>15</D_331>
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="//M_860/S_DTM[D_374 = '070']/D_374">
      <D_374>037</D_374>
   </xsl:template>

   <xsl:template match="//M_860/S_DTM[D_374 = '073']/D_374">
      <D_374>038</D_374>
   </xsl:template>

   <xsl:template match="//M_860[not(exists(S_PID))]/S_DTM[last()]">
      <S_DTM>
         <xsl:apply-templates select="./node()"/>
      </S_DTM>
      <S_TD5>
         <D_387>REI Vendor Guide</D_387>
      </S_TD5>
   </xsl:template>

   <xsl:template match="//M_860/S_PID">
      <S_PID>
         <xsl:apply-templates select="./node()"/>
      </S_PID>
      <S_TD5>
         <D_387>REI Vendor Guide</D_387>
      </S_TD5>
   </xsl:template>

   <xsl:template match="//M_860/G_N9[last()]">
      <xsl:copy-of select="."/>
      <G_N9>
         <S_N9>
            <D_128>PO</D_128>
            <D_127>
               <xsl:value-of
                  select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 30)"
               />
            </D_127>
         </S_N9>
      </G_N9>
   </xsl:template>


   <xsl:template match="//M_860/G_POC/S_POC/child::*[starts-with(name(), 'D_235')]">
      <xsl:choose>
         <xsl:when test=". = 'VP'">
            <xsl:element name="{name()}">
               <xsl:value-of select="'VA'"/>
            </xsl:element>
         </xsl:when>
         <xsl:when test=". = 'BP'">
            <xsl:element name="{name()}">
               <xsl:value-of select="'IN'"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//M_860/G_POC/G_PID/S_PID[D_349 = 'F'][not(exists(D_750))]/D_349">
      <xsl:copy-of select="."/>
      <D_750>08</D_750>
   </xsl:template>

   <xsl:template name="formatQty">
      <xsl:param name="qty"/>
      <xsl:variable name="tempQty" select="replace($qty, ',', '')"/>
      <xsl:if test="$tempQty castable as xs:decimal">
         <xsl:value-of select="xs:decimal($tempQty)"/>
      </xsl:if>
      <!--xsl:value-of select="replace($qty, ',', '')"/-->
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
