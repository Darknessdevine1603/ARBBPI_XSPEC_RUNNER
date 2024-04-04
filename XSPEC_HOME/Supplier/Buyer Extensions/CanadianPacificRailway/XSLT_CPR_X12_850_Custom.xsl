<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

   <xsl:template match="//source"/>

   <!-- Extension Start  -->
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>      
   
   <xsl:template match="//M_850/S_DTM[last()]">
      <xsl:copy-of select="."/>      
         <xsl:for-each select="(//OrderRequest/ItemOut[SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate!=''])[1]">
            
            <!-- Start Date -->
               <xsl:call-template name="createDTM">
                  <xsl:with-param name="D374_Qual">150</xsl:with-param>
                  <xsl:with-param name="cXMLDate">
                     <xsl:value-of select="SpendDetail/Extrinsic/Period/@startDate"/>
                  </xsl:with-param>
               </xsl:call-template>            
            
            <!-- End Date -->
               <xsl:call-template name="createDTM">
                  <xsl:with-param name="D374_Qual">151</xsl:with-param>
                  <xsl:with-param name="cXMLDate">
                     <xsl:value-of select="SpendDetail/Extrinsic/Period/@endDate"/>
                  </xsl:with-param>
               </xsl:call-template>  
         </xsl:for-each>      
   </xsl:template>

   
   <xsl:template name="createDTM">
      <xsl:param name="D374_Qual"/>
      <xsl:param name="cXMLDate"/>
      <S_DTM>
         <D_374>
            <xsl:value-of select="$D374_Qual"/>
         </D_374>
         <D_373>
            <xsl:value-of select="replace(substring($cXMLDate, 0, 11), '-', '')"/>
         </D_373>
         <xsl:if test="replace(substring($cXMLDate, 12, 8), ':', '') != ''">
            <D_337>
               <xsl:value-of select="replace(substring($cXMLDate, 12, 8), ':', '')"/>
            </D_337>
         </xsl:if>
         <xsl:variable name="timeZone" select="replace(replace(substring($cXMLDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
         <xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
            <D_623>
               <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
            </D_623>
         </xsl:if>
      </S_DTM>
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
