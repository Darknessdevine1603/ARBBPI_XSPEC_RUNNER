<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
  <!--xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/-->
  <!-- for dynamic, reading from Partner Directory -->
  <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_X12_4010:Binary')"/>
  <xsl:template match="//source"/>
  <xsl:template match="//M_850/S_REF[last()]">
    <xsl:copy-of select="."/>
    <xsl:if
      test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'supplierDocumentID']) != ''">
      <xsl:element name="S_REF">
        <xsl:element name="D_128">D2</xsl:element>
        <xsl:element name="D_127">
          <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'supplierDocumentID']), 1, 30)"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:if
      test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) != ''">
      <xsl:element name="S_REF">
        <xsl:element name="D_128">8X</xsl:element>
        <xsl:element name="D_127">
          <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']), 1, 30)"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <xsl:if
      test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'revisionNo']) != ''">
      <xsl:element name="S_REF">
        <xsl:element name="D_128">YB</xsl:element>
        <xsl:element name="D_127">
          <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'revisionNo']), 1, 30)"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//M_850/G_N1[1]">
    <!--xsl:if test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name='vendorTerms'])!=''">			<G_N9>				<S_N9>					<D_128>ZZ</D_128>					<D_369>vendorTerms</D_369>				</S_N9>				<S_MSG>					<D_933>						<xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name='vendorTerms']),1,264)"/>					</D_933>				</S_MSG>			</G_N9>		</xsl:if-->
    <xsl:for-each select="/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'lettersOrNotes']">
			<xsl:apply-templates select=".">
				<xsl:with-param name="value" select="@name"/>
			</xsl:apply-templates>
		</xsl:for-each>
    <xsl:if
      test="not(exists(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'from']))">
      <xsl:if
        test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'tag']) != ''">
        <G_N1>
          <S_N1>
            <D_98>FR</D_98>
            <D_93>
              <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'tag']), 1, 60)"/>
            </D_93>
          </S_N1>
          <xsl:if
            test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'agencyLocationCode']) != ''">
            <S_N3>
              <D_166>
                <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'agencyLocationCode']), 1, 55)"/>
              </D_166>
            </S_N3>
          </xsl:if>
          <xsl:variable name="tokenizedList1"
            select="tokenize(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'addresseeReference'], ',')"/>
          <xsl:variable name="tokenizedList2"
            select="tokenize(normalize-space($tokenizedList1[2]), '\s')"/>
          <xsl:variable name="count"
            select="number(count($tokenizedList1) + count($tokenizedList2))"/>
          <xsl:if test="$count = 5">
            <S_N4>
              <D_19>
                <xsl:value-of select="substring(normalize-space($tokenizedList1[1]), 1, 30)"/>
              </D_19>
              <xsl:variable name="stateCode" select="$tokenizedList2[1]"/>
              <D_156>
                <xsl:choose>
                  <xsl:when test="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode != ''">
										<xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode"/>
									</xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring(normalize-space($stateCode), 1, 2)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </D_156>
              <D_116>
                <xsl:value-of select="substring(normalize-space($tokenizedList2[2]), 1, 15)"/>
              </D_116>
              <D_26>
                <xsl:value-of select="substring(normalize-space($tokenizedList2[3]), 1, 3)"/>
              </D_26>
            </S_N4>
          </xsl:if>
        </G_N1>
      </xsl:if>
    </xsl:if>
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="//M_850/S_DTM[last()]">
    <xsl:copy-of select="."/>
    <xsl:if
      test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'shippingNoteNumber']) != ''">
      <S_PID>
        <D_349>F</D_349>
        <D_750>93</D_750>
        <D_352>
          <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'shippingNoteNumber']), 1, 80)"/>
        </D_352>
      </S_PID>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//M_850/G_N1[S_N1/D_98 = 'FR']">
    <G_N1>
      <S_N1>
        <xsl:copy-of select="//M_850/G_N1/S_N1[D_98 = 'FR']/D_93/preceding-sibling::*"/>
        <xsl:choose>
          <xsl:when test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'tag']) != ''">
						<D_93>
							<xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'tag']), 1, 60)"/>
						</D_93>
					</xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="//M_850/G_N1/S_N1[D_98 = 'FR']/D_93"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:copy-of select="//M_850/G_N1/S_N1[D_98 = 'FR']/D_93/following-sibling::*"/>
      </S_N1>
      <xsl:copy-of select="//M_850/G_N1[S_N1/D_98 = 'FR']/S_N2"/>
      <xsl:choose>
        <xsl:when test="normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'agencyLocationCode']) != ''">
					<S_N3>
						<D_166>
							<xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'agencyLocationCode']), 1, 55)"/>
						</D_166>
					</S_N3>
				</xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="//M_850/G_N1[S_N1/D_98 = 'FR']/S_N3"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="tokenizedList1"
        select="tokenize(/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'addresseeReference'], ',')"/>
      <xsl:variable name="tokenizedList2"
        select="tokenize(normalize-space($tokenizedList1[2]), '\s')"/>
      <xsl:variable name="count" select="number(count($tokenizedList1) + count($tokenizedList2))"/>
      <xsl:choose>
        <xsl:when test="$count = 5">
					<S_N4>
						<D_19>
							<xsl:value-of select="substring(normalize-space($tokenizedList1[1]), 1, 30)"/>
						</D_19>
						<xsl:variable name="stateCode" select="$tokenizedList2[1]"/>
						<D_156>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode != ''">
									<xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stateCode]/stateCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(normalize-space($stateCode), 1, 2)"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_156>
						<D_116>
							<xsl:value-of select="substring(normalize-space($tokenizedList2[2]), 1, 15)"/>
						</D_116>
						<D_26>
							<xsl:value-of select="substring(normalize-space($tokenizedList2[3]), 1, 3)"/>
						</D_26>
					</S_N4>
				</xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="//M_850/G_N1[S_N1/D_98 = 'FR']/S_N4"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="//M_850/G_N1[S_N1/D_98 = 'FR']/S_PER"/>
    </G_N1>
  </xsl:template>
  <xsl:template match="//M_850/G_PO1/S_REF[last()]">
    <xsl:copy-of select="."/>
    <xsl:variable name="pos1" select="../S_PO1/D_350"/>
    <xsl:if
      test="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/Extrinsic[@name = 'orderNo']) != ''">
      <xsl:element name="S_REF">
        <xsl:element name="D_128">ZG</xsl:element>
        <xsl:element name="D_127">
          <xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/Extrinsic[@name = 'orderNo']), 1, 30)"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="Extrinsic">
    <xsl:if test="normalize-space(.) != ''">
      <G_N9>
        <S_N9>
          <D_128>L1</D_128>
          <D_127>EN</D_127>
          <D_369>Comments</D_369>
        </S_N9>
        <S_MSG>
          <D_933>
            <xsl:value-of select="substring(normalize-space(.), 1, 264)"/>
          </D_933>
        </S_MSG>
      </G_N9>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//S_FOB[D_335='DAT' or D_335='DAP']/D_334"/>    
  <xsl:template match="//S_FOB[D_335='DAT' or D_335='DAP']/D_335"/>
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
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.<metaInformation>	<scenarios>		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="Combined-testPO2064.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength=""		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"		          customvalidator="">			<advancedProp name="sInitialMode" value=""/>			<advancedProp name="bXsltOneIsOkay" value="true"/>			<advancedProp name="bSchemaAware" value="true"/>			<advancedProp name="bXml11" value="false"/>			<advancedProp name="iValidation" value="0"/>			<advancedProp name="bExtensions" value="true"/>			<advancedProp name="iWhitespace" value="0"/>			<advancedProp name="sInitialTemplate" value=""/>			<advancedProp name="bTinyTree" value="true"/>			<advancedProp name="bWarnings" value="true"/>			<advancedProp name="bUseDTD" value="false"/>			<advancedProp name="iErrorHandling" value="fatal"/>		</scenario>	</scenarios>	<MapperMetaTag>		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>		<MapperBlockPosition></MapperBlockPosition>		<TemplateContext></TemplateContext>		<MapperFilter side="source"></MapperFilter>	</MapperMetaTag></metaInformation>-->
