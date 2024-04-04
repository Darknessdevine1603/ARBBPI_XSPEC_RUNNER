<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <!-- For local testing -->
   <!--xsl:variable name="Lookup" select="document('cXML_EDILookups_D96A.xml')"/>	<xsl:include href="Format_CXML_D96A_common.xsl"/-->
   <xsl:include href="pd:HCIOWNERPID:FORMAT_cXML_0000_UN-EDIFACT_D96A:Binary"/>
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_UN-EDIFACT_D96A:Binary')"/>
   <xsl:template match="//source"/>
   <xsl:template match="//M_ORDERS/S_FTX[D_4451 = 'ZZZ' and C_C108/D_4440 = 'incoTermDesc']">
      <xsl:choose>
         <xsl:when test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'incoTermDesc']/URL) != ''">
            <S_FTX>
               <D_4451>ZZZ</D_4451>
               <C_C108>
                  <D_4440>incoTermDesc</D_4440>
                  <D_4440_2>
                     <xsl:value-of select="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'incoTermDesc']/URL)"/>
                  </D_4440_2>
               </C_C108>
            </S_FTX>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="//M_ORDERS/G_SG2[last()]">
      <xsl:copy-of select="."/>
      <xsl:if test="/Combined/source/cXML/Header/To/Correspondent/Contact">
         <G_SG2>
            <xsl:call-template name="createNAD">
               <xsl:with-param name="Address" select="/Combined/source/cXML/Header/To/Correspondent/Contact"/>
               <xsl:with-param name="role" select="/Combined/source/cXML/Header/To/Correspondent/Contact/@role"/>
            </xsl:call-template>
            <xsl:call-template name="CTACOMLoop">
               <xsl:with-param name="contact" select="/Combined/source/cXML/Header/To/Correspondent/Contact"/>
               <xsl:with-param name="contactType" select="/Combined/source/cXML/Header/To/Correspondent/Contact/@role"/>
               <xsl:with-param name="ContactDepartmentID" select="/Combined/source/cXML/Header/To/Correspondent/Contact/IdReference[@domain = 'ContactDepartmentID']/@identifier"/>
               <xsl:with-param name="ContactPerson" select="/Combined/source/cXML/Header/To/Correspondent/Contact/IdReference[@domain = 'ContactPerson']/@identifier"/>
            </xsl:call-template>
         </G_SG2>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//M_ORDERS/G_SG25">
      <G_SG25>
         <xsl:variable name="pos1" select="S_LIN/D_1082"/>
         <xsl:apply-templates select="S_LIN"/>
         <xsl:if test="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/Extrinsic[@name = 'customersPartNo']) != '' or normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ManufacturerPartID) != ''">
            <S_PIA>
               <D_4347>5</D_4347>
               <xsl:choose>
                  <xsl:when test="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/Extrinsic[@name = 'customersPartNo']) != ''">
                     <C_C212>
                        <D_7140>
                           <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/Extrinsic[@name = 'customersPartNo']), 1, 35)"/>
                        </D_7140>
                        <D_7143>BP</D_7143>
                        <D_1131>57</D_1131>
                        <D_3055>92</D_3055>
                     </C_C212>
                     <xsl:if test="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ManufacturerPartID) != ''">
                        <C_C212_2>
                           <D_7140>
                              <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ManufacturerPartID), 1, 35)"/>
                           </D_7140>
                           <D_7143>MF</D_7143>
                           <D_1131>57</D_1131>
                           <D_3055>90</D_3055>
                        </C_C212_2>
                     </xsl:if>
                  </xsl:when>
                  <xsl:when test="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ManufacturerPartID) != ''">
                     <C_C212>
                        <D_7140>
                           <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ManufacturerPartID), 1, 35)"/>
                        </D_7140>
                        <D_7143>MF</D_7143>
                        <D_1131>57</D_1131>
                        <D_3055>90</D_3055>
                     </C_C212>
                  </xsl:when>
               </xsl:choose>
            </S_PIA>
         </xsl:if>
         <xsl:apply-templates select="S_PIA"/>
         <xsl:apply-templates select="S_IMD | S_MEA | S_QTY | S_PCD | S_ALI | S_DTM | S_MOA | S_GIN | S_GIR | S_QVR | S_DOC | S_PAI | S_FTX"/>
         <xsl:for-each select="/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[99 &gt;= position()]">
            <xsl:variable name="charDomain" select="normalize-space(@domain)"/>
            <xsl:call-template name="FTXLoopCustom">
               <xsl:with-param name="FTXData" select="@value"/>
               <xsl:with-param name="FTXQual" select="'AAA'"/>
               <xsl:with-param name="domain" select="@domain"/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:apply-templates select="G_SG26 | G_SG27 | G_SG28 | G_SG29 | G_SG30 | G_SG33 | G_SG34 | G_SG35 | G_SG39 | G_SG45 | G_SG47 | G_SG48 | G_SG49 | G_SG51 | G_SG52"/>
      </G_SG25>
   </xsl:template>
   <xsl:template match="//M_ORDERS/G_SG11">
      <G_SG11>
         <S_TOD>
            <xsl:copy-of select="S_TOD/D_4055"/>
            <xsl:copy-of select="S_TOD/D_4215"/>
            <C_C100>
               <D_4053>
                  <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'incoTerm']), 1, 3)"/>
               </D_4053>
               <xsl:copy-of select="S_TOD/C_C100/D_1131"/>
               <xsl:copy-of select="S_TOD/C_C100/D_3055"/>
               <xsl:copy-of select="S_TOD/C_C100/D_4052"/>
               <xsl:copy-of select="S_TOD/C_C100/D_4052_2"/>
            </C_C100>
         </S_TOD>
         <xsl:copy-of select="S_LOC"/>
      </G_SG11>
   </xsl:template>
   <xsl:template match="S_PIA">
      <xsl:choose>
         <xsl:when test="D_4347 = '5'"/>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="S_IMD">
      <xsl:choose>
         <xsl:when test="D_7077 = 'B'"/>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="FTXLoopCustom">
      <xsl:param name="FTXQual"/>
      <xsl:param name="FTXData"/>
      <xsl:param name="domain"/>
      <xsl:param name="langCode"/>
      <xsl:if test="string-length($FTXData) &gt; 0">
         <xsl:variable name="C108">
            <C_C108>
               <xsl:if test="substring($FTXData, 1, 70) != ''">
                  <xsl:variable name="temp">
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="substring($FTXData, 1, 70)"/>
                     </xsl:call-template>
                  </xsl:variable>
                  <D_4440>
                     <xsl:choose>
                        <xsl:when test="$domain != ''">
                           <xsl:value-of select="$domain"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$temp"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </D_4440>
                  <xsl:variable name="pendingFTX">
                     <xsl:choose>
                        <xsl:when test="$domain != ''">
                           <xsl:value-of select="$FTXData"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="substring($FTXData, string-length($temp) + 1)"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="string-length($pendingFTX) &gt; 0">
                     <xsl:variable name="temp">
                        <xsl:call-template name="rTrim">
                           <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                        </xsl:call-template>
                     </xsl:variable>
                     <D_4440_2>
                        <xsl:value-of select="$temp"/>
                     </D_4440_2>
                     <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                     <xsl:if test="string-length($pendingFTX) &gt; 0">
                        <xsl:variable name="temp">
                           <xsl:call-template name="rTrim">
                              <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                           </xsl:call-template>
                        </xsl:variable>
                        <D_4440_3>
                           <xsl:value-of select="$temp"/>
                        </D_4440_3>
                        <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                        <xsl:if test="string-length($pendingFTX) &gt; 0">
                           <xsl:variable name="temp">
                              <xsl:call-template name="rTrim">
                                 <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                              </xsl:call-template>
                           </xsl:variable>
                           <D_4440_4>
                              <xsl:value-of select="$temp"/>
                           </D_4440_4>
                           <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                           <xsl:if test="string-length($pendingFTX) &gt; 0">
                              <xsl:variable name="temp">
                                 <xsl:call-template name="rTrim">
                                    <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                                 </xsl:call-template>
                              </xsl:variable>
                              <D_4440_5>
                                 <xsl:value-of select="$temp"/>
                              </D_4440_5>
                           </xsl:if>
                        </xsl:if>
                     </xsl:if>
                  </xsl:if>
               </xsl:if>
            </C_C108>
         </xsl:variable>
         <S_FTX>
            <D_4451>
               <xsl:value-of select="$FTXQual"/>
            </D_4451>
            <xsl:copy-of select="$C108"/>
         </S_FTX>
         <xsl:variable name="ftxLen" select="string-length($C108//D_4440) + string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>
         <xsl:if test="substring($FTXData, $ftxLen + 1) != ''">
            <xsl:call-template name="FTXLoopCustom">
               <xsl:with-param name="FTXData">
                  <xsl:value-of select="substring($FTXData, $ftxLen + 1)"/>
               </xsl:with-param>
               <xsl:with-param name="FTXQual" select="$FTXQual"/>
               <xsl:with-param name="langCode" select="$langCode"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:if>
   </xsl:template>
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
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.<metaInformation>	<scenarios>		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\Samples\combined\cXMLPO_EDIFACTPO_withCharaterictic.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0"		          profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no"		          validator="internal" customvalidator="">			<advancedProp name="sInitialMode" value=""/>			<advancedProp name="bXsltOneIsOkay" value="true"/>			<advancedProp name="bSchemaAware" value="true"/>			<advancedProp name="bXml11" value="false"/>			<advancedProp name="iValidation" value="0"/>			<advancedProp name="bExtensions" value="true"/>			<advancedProp name="iWhitespace" value="0"/>			<advancedProp name="sInitialTemplate" value=""/>			<advancedProp name="bTinyTree" value="true"/>			<advancedProp name="bWarnings" value="true"/>			<advancedProp name="bUseDTD" value="false"/>			<advancedProp name="iErrorHandling" value="fatal"/>		</scenario>	</scenarios>	<MapperMetaTag>		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>		<MapperBlockPosition></MapperBlockPosition>		<TemplateContext></TemplateContext>		<MapperFilter side="source"></MapperFilter>	</MapperMetaTag></metaInformation>-->
