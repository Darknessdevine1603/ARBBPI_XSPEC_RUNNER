<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <!-- For local testing -->
   <!--xsl:variable name="Lookup" select="document('../../lookups/X12/LOOKUP_ASC-X12_004010.xml')"/-->
   <!-- PD references -->
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
   <xsl:variable name="repTypes" select="tokenize('supplyPlan,longtermforecast,constrainedforecast,grossdemand,netdemand,capacitydemand', ',')"/>
   
   <xsl:template match="//source"/>
   
   <!-- Extension Start  -->
   
   <xsl:template match="//M_830/G_LIN/S_LDT[1]">
      <xsl:variable name="linPosition" select="count(../preceding-sibling::G_LIN) + 1"/>
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/ReferenceDocumentInfo/DocumentInfo[@documentType='SchedulingAgreement']/@documentID) != ''">
         <S_REF>
            <D_128>72</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/ReferenceDocumentInfo[DocumentInfo/@documentType='SchedulingAgreement']/@lineNumber), 1, 30)"/>
            </D_127>
            <D_352>
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/ReferenceDocumentInfo/DocumentInfo[@documentType='SchedulingAgreement']/@documentID), 1, 80)"/>
            </D_352>
         </S_REF>
      </xsl:if>
      <xsl:copy-of select="."/>
   </xsl:template>
   
   <xsl:template match="//M_830/G_LIN/S_REF[position()>11]"/>
   
   <xsl:template match="//M_830/G_LIN/G_FST/S_FST[not(D_127 = $repTypes)]">
      <xsl:variable name="D127" select="D_127"/>
      <xsl:variable name="linPosition" select="count(../../preceding-sibling::G_LIN) + 1"/>
      <xsl:variable name="FSTPositionA" select="count(../preceding-sibling::G_FST) + 1"/>
      <xsl:variable name="FSTPositionB" select="count(../preceding-sibling::G_FST[(S_FST/D_127 != $D127)])"/>
      <xsl:variable name="FSTPosition" select="$FSTPositionA - $FSTPositionB"/>
      <xsl:element name="S_FST">
         <xsl:copy-of select="D_380, D_680, D_681, D_373, D_373_2"/>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/PlanningTimeSeries[@customType = $D127]/TimeSeriesDetails[$FSTPosition]/Period/@startDate)">
               <xsl:variable name="efTime" select="//ProductActivityMessage/ProductActivityDetails[$linPosition]/PlanningTimeSeries[@customType = $D127]/TimeSeriesDetails[$FSTPosition]/Period/@startDate"/>
               <D_374>067</D_374>
               <xsl:element name="D_337">
                  <xsl:choose>
                     <xsl:when test="contains($efTime, '+')">
                        <xsl:value-of select="replace(substring-before(substring-after($efTime, 'T'), '+'), ':', '')"/>
                     </xsl:when>
                     <xsl:when test="contains($efTime, '-')">
                        <xsl:value-of select="replace(substring-before(substring-after($efTime, 'T'), '-'), ':', '')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="replace(substring-after($efTime, 'T'), ':', '')"/>
                     </xsl:otherwise>
                  </xsl:choose>                  
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_374"/>
               <xsl:copy-of select="D_337"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="D_128"/>
         <xsl:copy-of select="D_127"/>
         <xsl:copy-of select="D_783"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="//M_830/G_LIN">
      <G_LIN>
         <xsl:copy-of select="S_LIN, S_UIT"/>
         
         <xsl:variable name="linPosition" select="count(preceding-sibling::G_LIN) + 1"/>
         <xsl:if test="normalize-space((//ProductActivityMessage/ProductActivityDetails[$linPosition]/PlanningTimeSeries[@type='custom']/TimeSeriesDetails/Period)[1]/@endDate) != ''">
            <xsl:call-template name="createDTM">
               <xsl:with-param name="D374_Qual">999</xsl:with-param>
               <xsl:with-param name="cXMLDate">
                  <xsl:value-of select="(//ProductActivityMessage/ProductActivityDetails[$linPosition]/PlanningTimeSeries[@type='custom']/TimeSeriesDetails/Period)[1]/@endDate"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         
         <xsl:apply-templates select="child::*[name()!='S_LIN' and name()!='S_UIT']"></xsl:apply-templates>
      </G_LIN>
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
