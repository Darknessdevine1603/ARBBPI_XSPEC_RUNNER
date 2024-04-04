<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
  <!-- For local testing -->
  <!--xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/-->
  <!-- for dynamic, reading from Partner Directory -->
  <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
  <xsl:template match="//source"/>
  <!-- Extension Start  -->
  <xsl:template
    match="/Combined/target/cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Batch">
    <xsl:choose>
      <xsl:when test="../ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date != ''">
        <xsl:element name="Batch">
          <xsl:copy-of select="./@*[name() != 'expirationDate']"/>
          <xsl:attribute name="expirationDate">
            <xsl:value-of select="../ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date"/>
          </xsl:attribute>
          <xsl:copy-of select="./child::*"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template
    match="/Combined/target/cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem[not(exists(Batch))]/AssetInfo[1]">
    <xsl:variable name="lineNum" select="../@shipNoticeLineNumber"/>
    <xsl:choose>
      <xsl:when
        test="../ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date != '' or //M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $lineNum][S_LIN/child::*[text() = 'SN' and starts-with(name(), 'D_235')]]/S_REF[D_128 = 'BT'][D_127 = 'productionDate']/D_352 != ''">
        <xsl:element name="Batch">
          <xsl:if test="../ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date != ''">
            <xsl:attribute name="expirationDate">
              <xsl:value-of select="../ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date"
              />
            </xsl:attribute>
          </xsl:if>
          <xsl:if
            test="
              //M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $lineNum][S_LIN/child::*[text() =
              'SN' and starts-with(name(), 'D_235')]]/S_REF[D_128 = 'BT'][D_127 = 'productionDate']/D_352 != ''">
            <xsl:variable name="productionDate"
              select="
                //M_856/G_HL[S_HL/D_735 = 'I'][S_LIN/D_350 = $lineNum][S_LIN/child::*[text() =
                'SN' and starts-with(name(), 'D_235')]]/S_REF[D_128 = 'BT'][D_127 = 'productionDate']/D_352"/>
            <xsl:attribute name="productionDate">
              <xsl:call-template name="convertToAribaDate">
                <xsl:with-param name="Date">
                  <xsl:value-of select="substring($productionDate, 1, 8)"/>
                </xsl:with-param>
                <xsl:with-param name="Time">
                  <xsl:value-of select="substring($productionDate, 9, 6)"/>
                </xsl:with-param>
                <xsl:with-param name="TimeCode">
                  <xsl:value-of select="substring($productionDate, 15)"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
          </xsl:if>
        </xsl:element>
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="convertToAribaDate">
    <xsl:param name="Date"/>
    <xsl:param name="Time"/>
    <xsl:param name="TimeCode"/>
    <xsl:variable name="timeZone">
      <xsl:choose>
        <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
          <xsl:value-of
            select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
          />
        </xsl:when>
        <xsl:otherwise>+00:00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="temDate">
      <xsl:value-of
        select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
      />
    </xsl:variable>
    <xsl:variable name="tempTime">
      <xsl:choose>
        <xsl:when test="$Time != '' and string-length($Time) = 6">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
          />
        </xsl:when>
        <xsl:when test="$Time != '' and string-length($Time) = 4">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
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
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.<metaInformation>	<scenarios>		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\XMLs\09222017_Combined856_Stryker.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth=""		          profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"		          customvalidator="">			<advancedProp name="sInitialMode" value=""/>			<advancedProp name="bXsltOneIsOkay" value="true"/>			<advancedProp name="bSchemaAware" value="true"/>			<advancedProp name="bXml11" value="false"/>			<advancedProp name="iValidation" value="0"/>			<advancedProp name="bExtensions" value="true"/>			<advancedProp name="iWhitespace" value="0"/>			<advancedProp name="sInitialTemplate" value=""/>			<advancedProp name="bTinyTree" value="true"/>			<advancedProp name="bWarnings" value="true"/>			<advancedProp name="bUseDTD" value="false"/>			<advancedProp name="iErrorHandling" value="fatal"/>		</scenario>	</scenarios>	<MapperMetaTag>		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>		<MapperBlockPosition></MapperBlockPosition>		<TemplateContext></TemplateContext>		<MapperFilter side="source"></MapperFilter>	</MapperMetaTag></metaInformation>-->
