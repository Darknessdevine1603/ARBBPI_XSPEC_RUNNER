<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <!-- 10042018 CG: REI Extension Created -->
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//M_850/S_BEG/D_92">
      <D_92>
         <xsl:value-of select="'SA'"/>
      </D_92>
   </xsl:template>

   <xsl:template match="//M_850/S_REF[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/@addressID != ''">
         <S_REF>
            <D_128>IA</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/@addressID), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Name != ''">
            <S_PER>
               <D_366>BD</D_366>
               <D_93>
                  <xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Name), 1, 30)"/>
               </D_93>
            </S_PER>
         </xsl:when>
         <xsl:when test="//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Phone[1]/@name != ''">
            <S_PER>
               <D_366>BD</D_366>
               <D_93>
                  <xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'buyerCorporate']/Phone[1]/@name), 1, 30)"/>
               </D_93>
            </S_PER>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//M_850/S_FOB/child::*[last()]">
      <xsl:choose>
         <xsl:when test="normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery'][1]) != ''">
            <xsl:choose>
               <xsl:when test="name(.) = 'D_352_3'">
                  <D_352_3>
                     <xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery'][1]), 1, 80)"/>
                  </D_352_3>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="."/>
                  <D_352_3>
                     <xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery'][1]), 1, 80)"/>
                  </D_352_3>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//M_850/G_SAC/S_SAC[D_248 = 'A'][exists(D_378)]">
      <S_SAC>
         <xsl:copy-of select="D_378/preceding-sibling::*"/>
         <D_378>4</D_378>
         <xsl:copy-of select="D_378/following-sibling::* intersect D_352/preceding-sibling::*"/>
         <D_331>15</D_331>
         <xsl:copy-of select="D_352 | D_819"/>
      </S_SAC>
   </xsl:template>

   <xsl:template match="//M_850/G_SAC/S_SAC[D_248 = 'A'][exists(D_610)]">
      <S_SAC>
         <xsl:copy-of select="D_610/preceding-sibling::* | D_610"/>
         <D_331>15</D_331>
         <xsl:copy-of select="D_610/following-sibling::*"/>
      </S_SAC>
   </xsl:template>

   <xsl:template match="//M_850/G_SAC/S_SAC[D_248 = 'C']/D_352">
      <D_331>15</D_331>
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="//M_850/S_DTM[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="//M_850/S_DTM[D_374 = '007']">
         <S_DTM>
            <D_374>037</D_374>
            <xsl:copy-of select="//M_850/S_DTM[D_374 = '007']/child::*[name()!='D_374']"/>
         </S_DTM>
      </xsl:if>
      <xsl:if test="//M_850/S_DTM[D_374 = '036']">
         <S_DTM>
            <D_374>038</D_374>
            <xsl:copy-of select="//M_850/S_DTM[D_374 = '036']/child::*[name()!='D_374']"/>
         </S_DTM>
      </xsl:if>
      <xsl:if test="not(exists(//M_850/S_PID))">
         <S_TD5>
            <D_387>REI Vendor Guide</D_387>
         </S_TD5>
      </xsl:if>
   </xsl:template>

   <xsl:template match="//M_850/S_PID">
      <S_PID>
         <xsl:apply-templates select="./node()"/>
      </S_PID>
      <S_TD5>
         <D_387>REI Vendor Guide</D_387>
      </S_TD5>
   </xsl:template>

   <xsl:template match="//M_850/G_N9[last()]">
      <xsl:copy-of select="."/>
      <G_N9>
         <S_N9>
            <D_128>PO</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 30)"/>
            </D_127>
         </S_N9>
      </G_N9>
   </xsl:template>

   <xsl:template match="//M_850/G_PO1/S_PO1/child::*[starts-with(name(), 'D_235')]">
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

   <xsl:template match="//M_850/G_PO1/G_PID/S_PID[D_349 = 'F'][not(exists(D_750))]/D_349">
      <xsl:copy-of select="."/>
      <D_750>08</D_750>
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
