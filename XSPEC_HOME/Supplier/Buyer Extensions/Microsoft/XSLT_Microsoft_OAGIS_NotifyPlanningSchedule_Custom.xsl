<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml"/>
   <xsl:strip-space elements="*"/>
   <!-- Extension Start  -->
   <xsl:template match="//source"/>
   <xsl:template match="/Combined/target/NotifyPlanningSchedule/DataArea/PlanningSchedule/PlanningScheduleLine">
      <PlanningScheduleLine>
         <xsl:variable name="lineNum" select="LineNumber"/>
         <xsl:copy-of select="child::*[not(self::ScheduleException) and not(self::UserArea)]"/>
         <xsl:for-each select="/Combined/source/cXML/Message/ProductActivityMessage/ProductActivityDetails">
            <xsl:if test="position() = $lineNum">
               <xsl:for-each select="PlanningTimeSeries[lower-case(@type) = 'custom'][lower-case(@customType) = 'buildpriority']/TimeSeriesDetails">
                  <PlanningScheduleDetail>
                     <PriorityCode name="buildPriority">
                        <xsl:value-of select="format-number(number(normalize-space(TimeSeriesQuantity/@quantity)), '0')"/>
                     </PriorityCode>
                     <EffectiveTimePeriod>
                        <StartDateTime>
                           <xsl:value-of select="Period/@startDate"/>
                        </StartDateTime>
                        <EndDateTime>
                           <xsl:value-of select="Period/@endDate"/>
                        </EndDateTime>
                     </EffectiveTimePeriod>
                  </PlanningScheduleDetail>
               </xsl:for-each>
            </xsl:if>
         </xsl:for-each>
         <xsl:copy-of select="ScheduleException"/>
         <xsl:copy-of select="UserArea"/>
      </PlanningScheduleLine>
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