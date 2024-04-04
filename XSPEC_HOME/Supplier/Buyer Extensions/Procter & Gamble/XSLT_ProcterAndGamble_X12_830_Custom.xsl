<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>

   <!-- For local testing -->
   <!--xsl:variable name="Lookup" select="document('../../lookups/X12/LOOKUP_ASC-X12_004010.xml')"/-->
   <!-- PD references -->
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>

   <xsl:template match="//source"/>
   <!-- Extension Start  -->

   <xsl:template match="//ProductReplenishmentHeader">
      <ProductReplenishmentHeader>
         <xsl:copy-of select="./@*[name() != 'creationDate']"/>
         <xsl:attribute name="creationDate">
            <xsl:choose>
               <xsl:when test="//M_830/S_DTM[D_374 = '999']">
                  <xsl:call-template name="convertToAribaDate">
                     <xsl:with-param name="Date">
                        <xsl:value-of select="//M_830/S_DTM[D_374 = '999']/D_373"/>
                     </xsl:with-param>
                     <xsl:with-param name="Time">
                        <xsl:value-of select="//M_830/S_DTM[D_374 = '999']/D_337"/>
                     </xsl:with-param>
                     <xsl:with-param name="TimeCode">
                        <xsl:value-of select="//M_830/S_DTM[D_374 = '999']/D_623"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="./@creationDate"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:copy-of select="./child::*"/>
      </ProductReplenishmentHeader>
   </xsl:template>


   <xsl:template match="//ProductReplenishmentDetails/ReplenishmentTimeSeries/TimeSeriesDetails/Period">
      <xsl:variable name="posTimeSeries" select="count(../preceding-sibling::*) + 1"/>
      <xsl:variable name="posItem" select="count(../../../preceding-sibling::*)"/>

      <xsl:choose>
         <xsl:when test="//M_830/G_LIN[$posItem]/G_FST[$posTimeSeries]/S_FST/D_337 != ''">
            <Period>
               <xsl:attribute name="endDate">
                  <xsl:call-template name="convertToAribaDate">
                     <xsl:with-param name="Date" select="//M_830/G_LIN[$posItem]/G_FST[$posTimeSeries]/S_FST/D_373_2"/>
                     <xsl:with-param name="Time" select="//M_830/G_LIN[$posItem]/G_FST[$posTimeSeries]/S_FST/D_337"/>
                     <xsl:with-param name="TimeCode" select="//M_830/S_DTM[D_374 = '999']/D_623"/>
                  </xsl:call-template>
               </xsl:attribute>
               <xsl:attribute name="startDate">
                  <xsl:call-template name="convertToAribaDate">
                     <xsl:with-param name="Date" select="//M_830/G_LIN[$posItem]/G_FST[$posTimeSeries]/S_FST//D_373"/>
                     <xsl:with-param name="Time" select="//M_830/G_LIN[$posItem]/G_FST[$posTimeSeries]/S_FST/D_337"/>
                     <xsl:with-param name="TimeCode" select="//M_830/S_DTM[D_374 = '999']/D_623"/>
                  </xsl:call-template>
               </xsl:attribute>
            </Period>
         </xsl:when>
         <xsl:otherwise><xsl:copy-of select="."></xsl:copy-of></xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//ProductReplenishmentDetails/Contact[1]">
      <xsl:variable name="posItem" select="count(../preceding-sibling::ProductReplenishmentDetails) + 1"/>
      <xsl:if test="//M_830/G_LIN[$posItem]/S_REF[D_128 = '72']">
         <ReferenceDocumentInfo>
            <DocumentInfo>
               <xsl:attribute name="documentID">
                  <xsl:value-of select="//M_830/G_LIN[$posItem]/S_REF/D_352"/>
               </xsl:attribute>
               <xsl:attribute name="documentType">SchedulingAgreement</xsl:attribute>
               <xsl:if test="//M_830/G_LIN[$posItem]/S_DTM[D_374 = '830']">
                  <xsl:attribute name="documentDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="Date" select="//M_830/G_LIN[$posItem]/S_DTM[D_374 = '830']/D_373"/>
                        <xsl:with-param name="Time" select="//M_830/G_LIN[$posItem]/S_DTM[D_374 = '830']/D_337"/>
                        <xsl:with-param name="TimeCode" select="//M_830/G_LIN[$posItem]/S_DTM[D_374 = '830']/D_623"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </xsl:if>
            </DocumentInfo> 
         </ReferenceDocumentInfo>
      </xsl:if>
      <xsl:copy-of select="."/>      
   </xsl:template>
   
   <xsl:template name="convertToAribaDate">
      <xsl:param name="Date"/>
      <xsl:param name="Time"/>
      <xsl:param name="TimeCode"/>
      <xsl:variable name="timeZone">
         <xsl:choose>
            <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
               <xsl:value-of select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"/>
            </xsl:when>
            <xsl:otherwise>+00:00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="temDate">
         <xsl:value-of select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"/>
      </xsl:variable>
      <xsl:variable name="tempTime">
         <xsl:choose>
            <xsl:when test="$Time != '' and string-length($Time) = 6">
               <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"/>
            </xsl:when>
            <xsl:when test="$Time != '' and string-length($Time) = 4">
               <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
            </xsl:when>
            <xsl:otherwise>T12:00:00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
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
