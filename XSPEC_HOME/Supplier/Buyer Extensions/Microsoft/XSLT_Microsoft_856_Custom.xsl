<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
   <xsl:template match="//source"/>
   
   <!-- Extension Start  -->
   
   <!-- EF will apply only if AssetInfo is available. else no need of EF -->
   <xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/AssetInfo">      
      <xsl:variable name="serialN" select="@serialNumber"/>
      
      <xsl:element name="AssetInfo">
         <xsl:copy-of select="@*"/>         
         <!-- originatingCompanyID -->
         <xsl:if test="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_LIN[D_235_1 = 'CH']/D_234_1!=''">            
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">originatingCompanyID</xsl:attribute>
               <xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_LIN[D_235_1 = 'CH']/D_234_1"/>
            </xsl:element>
         </xsl:if>
         <!-- packagingUnitIdentification -->
         <xsl:if test="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_MAN[D_88_1 = 'GM']/D_87_1!=''">            
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">packagingUnitIdentification</xsl:attribute>
               <xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_MAN[D_88_1 = 'GM']/D_87_1"/>
            </xsl:element>
         </xsl:if>
         <!-- expirationDate -->
         <xsl:if test="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '036']/D_373!=''">            
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">expirationDate</xsl:attribute>
               <xsl:call-template name="convertToAribaDate">
                  <xsl:with-param name="Date">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '036']/D_373"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="Time">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '036']/D_337"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="TimeCode">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '036']/D_623"
                     />
                  </xsl:with-param>
               </xsl:call-template>               
            </xsl:element>
         </xsl:if>
         <!-- deliveryDate -->
         <xsl:if test="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '094']/D_373!=''">            
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">manufacturerDate</xsl:attribute>
               <xsl:call-template name="convertToAribaDate">
                  <xsl:with-param name="Date">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '094']/D_373"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="Time">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '094']/D_337"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="TimeCode">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '094']/D_623"
                     />
                  </xsl:with-param>
               </xsl:call-template>               
            </xsl:element>
         </xsl:if>
         <!-- startDate -->
         <xsl:if test="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '232']/D_373!=''">            
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">startDate</xsl:attribute>
               <xsl:call-template name="convertToAribaDate">
                  <xsl:with-param name="Date">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '232']/D_373"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="Time">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '232']/D_337"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="TimeCode">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '232']/D_623"
                     />
                  </xsl:with-param>
               </xsl:call-template>               
            </xsl:element>
         </xsl:if>
         <!-- endDate -->
         <xsl:if test="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '233']/D_373!=''">            
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name">endDate</xsl:attribute>
               <xsl:call-template name="convertToAribaDate">
                  <xsl:with-param name="Date">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '233']/D_373"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="Time">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '233']/D_337"
                     />
                  </xsl:with-param>
                  <xsl:with-param name="TimeCode">
                     <xsl:value-of
                        select="//M_856/G_HL[S_HL/D_735 = 'X'][S_MAN[D_88_1 = 'L' and D_87_1 = 'SN' and D_87_2 = $serialN]]/S_DTM[D_374 = '233']/D_623"
                     />
                  </xsl:with-param>
               </xsl:call-template>               
            </xsl:element>
         </xsl:if>
      </xsl:element>
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
      <xsl:apply-templates select="@*|node()"/>
   </xsl:template>
   <xsl:template match="//target">
      <xsl:apply-templates select="@*|node()"/>
   </xsl:template>
   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>