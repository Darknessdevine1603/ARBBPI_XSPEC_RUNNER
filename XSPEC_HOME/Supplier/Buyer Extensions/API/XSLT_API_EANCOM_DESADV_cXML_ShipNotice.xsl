<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->

   <xsl:template match="//ShipNoticeItem/Packaging">
      <xsl:variable name="lineNumber" select="../@shipNoticeLineNumber"/>
      <xsl:variable name="CPSGrp" select="//G_SG10[G_SG17/S_LIN/D_1082 = $lineNumber]/G_SG11"/>
      <xsl:variable name="serialCode" select="ShippingContainerSerialCode"/>
      <xsl:variable name="serialCodes">
         <xsl:for-each select="$CPSGrp/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
            <xsl:variable name="startSerial" select="D_7402"/>
            <xsl:variable name="endSerial">
               <xsl:choose>
                  <xsl:when test="D_7402_2 != ''">
                     <xsl:value-of select="D_7402_2"/>
                  </xsl:when>
                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="generateSerialCodes">
               <xsl:with-param name="startSerial" select="$startSerial"/>
               <xsl:with-param name="endSerial" select="$endSerial"/>
            </xsl:call-template>
         </xsl:for-each>
      </xsl:variable>
      <xsl:element name="Packaging">
         <xsl:apply-templates select="node() | @*"/>
         <xsl:call-template name="recurseCPS">
            <xsl:with-param name="serialCode" select="$serialCode"/>
            <xsl:with-param name="serialCodes" select="$serialCodes"/>
            <xsl:with-param name="CPSGrp" select="$CPSGrp"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>

   <!-- IG-5463 start -->
   <xsl:template match="//ShipNoticePortion/ShipNoticeItem/Packaging/ShippingContainerSerialCode">
      <xsl:copy-of select="."/>
      <xsl:copy-of select="../ShippingContainerSerialCodeReference"/>
      <xsl:element name="PackageID">
         <xsl:element name="GlobalIndividualAssetID">
            <xsl:value-of select="."/>
         </xsl:element>
      </xsl:element>
   </xsl:template>

   <xsl:template match="//ShipNoticePortion/ShipNoticeItem/Packaging[exists(ShippingContainerSerialCode)]/ShippingContainerSerialCodeReference"/>
   
   <!-- IG-5463 end -->

   <xsl:template name="recurseCPS">
      <xsl:param name="serialCode"/>
      <xsl:param name="serialCodes"/>
      <xsl:param name="CPSGrp"/>
      <xsl:choose>
         <xsl:when test="$serialCodes/Serial = $serialCode">
            <xsl:call-template name="createExtrinsic">
               <xsl:with-param name="CPSGrp" select="$CPSGrp"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="CPSGrp" select="//G_SG10[S_CPS/D_7164 = $CPSGrp/../S_CPS/D_7166]/G_SG11"/>
            <xsl:variable name="serialCodes">
               <xsl:for-each select="$CPSGrp/G_SG13/G_SG15/S_GIN[D_7405 = 'BJ' or D_7405 = 'AW']/node()[starts-with(name(), 'C_C208')]">
                  <xsl:variable name="startSerial" select="D_7402"/>
                  <xsl:variable name="endSerial">
                     <xsl:choose>
                        <xsl:when test="D_7402_2 != ''">
                           <xsl:value-of select="D_7402_2"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:call-template name="generateSerialCodes">
                     <xsl:with-param name="startSerial" select="$startSerial"/>
                     <xsl:with-param name="endSerial" select="$endSerial"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:variable>
            <xsl:if test="$CPSGrp">
               <xsl:call-template name="recurseCPS">
                  <xsl:with-param name="serialCode" select="$serialCode"/>
                  <xsl:with-param name="serialCodes" select="$serialCodes"/>
                  <xsl:with-param name="CPSGrp" select="$CPSGrp"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="createExtrinsic">
      <xsl:param name="CPSGrp"/>
      <xsl:if test="$CPSGrp/S_MEA[D_6311 = 'CT'][C_C502/D_6313 = 'AAJ']/C_C174[D_6411 = 'NAR']/D_6314 != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">unitsPerPallet</xsl:attribute>
            <xsl:value-of select="$CPSGrp/S_MEA[D_6311 = 'CT'][C_C502/D_6313 = 'AAJ']/C_C174[D_6411 = 'NAR']/D_6314"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$CPSGrp/S_MEA[D_6311 = 'CT'][C_C502/D_6313 = 'ULY']/C_C174[D_6411 = 'NAR']/D_6314 != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">unitsPerLayer</xsl:attribute>
            <xsl:value-of select="$CPSGrp/S_MEA[D_6311 = 'CT'][C_C502/D_6313 = 'ULY']/C_C174[D_6411 = 'NAR']/D_6314"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$CPSGrp/S_MEA[D_6311 = 'CT'][C_C502/D_6313 = 'LAY']/C_C174[D_6411 = 'NAR']/D_6314 != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">layersPerPallet</xsl:attribute>
            <xsl:value-of select="$CPSGrp/S_MEA[D_6311 = 'CT'][C_C502/D_6313 = 'LAY']/C_C174[D_6411 = 'NAR']/D_6314"/>
         </xsl:element>
      </xsl:if>
      <xsl:if test="$CPSGrp/G_SG13/S_DTM/C_C507[D_2005 = '36'][D_2379 = '102']/D_2380 != ''">
         <xsl:element name="Extrinsic">
            <xsl:attribute name="name">packageIdReferenceExpiryDate</xsl:attribute>
            <xsl:value-of select="$CPSGrp/G_SG13/S_DTM/C_C507[D_2005 = '36'][D_2379 = '102']/D_2380"/>
         </xsl:element>
      </xsl:if>
   </xsl:template>

   <xsl:template name="generateSerialCodes">
      <xsl:param name="endSerial" as="xs:integer" select="1"/>
      <xsl:param name="startSerial" as="xs:integer"/>
      <Serial>
         <xsl:value-of select="$startSerial"/>
      </Serial>
      <xsl:if test="$endSerial and $endSerial > $startSerial">
         <xsl:call-template name="generateSerialCodes">
            <xsl:with-param name="endSerial" select="$endSerial"/>
            <xsl:with-param name="startSerial" select="$startSerial + 1"/>
         </xsl:call-template>
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
