<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	
	<xsl:template match="//M_850/S_REF[last()]">
		<!--  Added index to avoid duplicates -->
		<xsl:copy-of select="."/>
		<xsl:if test="/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name='CompanyCode']!=''">
			<xsl:element name="S_REF">
				<xsl:element name="D_128">YD</xsl:element>
				<xsl:element name="D_127">
					<xsl:value-of select="/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name='CompanyCode']"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:if test="/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name='deliveryReference']!=''">
			<xsl:variable name="spmVal" select="/Combined/source/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name='deliveryReference']"/>
			<xsl:choose>
				<xsl:when test="$spmVal='COLLECTCC'">
					<xsl:element name="S_FOB">
						<xsl:element name="D_146">
							<xsl:value-of select="'CC'"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$spmVal='PREPAIDPP'">
					<xsl:element name="S_FOB">
						<xsl:element name="D_146">
							<xsl:value-of select="'PP'"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
   <xsl:template match="//M_850/S_DTM[D_374='177']">
      <S_DTM>
         <D_374>
            <xsl:value-of select="'001'"/>
         </D_374>
         <xsl:copy-of select="D_374/following-sibling::*"></xsl:copy-of>
      </S_DTM>
   </xsl:template>
	<xsl:template match="//M_850/G_N9[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="//OrderRequest/OrderRequestHeader/Extrinsic[@name='requestedDeliveryDate']!=''">
			<G_N9>
				<S_N9>
					<D_128>ZZ</D_128>				
					<D_369>requestedDeliveryDate</D_369>				
				</S_N9>
				<S_MSG>
					<D_933>
						<xsl:value-of select="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name='requestedDeliveryDate'])"/>
					</D_933>
				</S_MSG>			
			</G_N9>
		</xsl:if>
		<xsl:if test="//OrderRequest/OrderRequestHeader/Extrinsic[@name='ShipDate']!=''">
			<G_N9>
				<S_N9>
					<D_128>ZZ</D_128>				
					<D_369>ShipDate</D_369>				
				</S_N9>
				<S_MSG>
					<D_933>
						<xsl:value-of select="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name='ShipDate'])"/>
					</D_933>
				</S_MSG>			
			</G_N9>
		</xsl:if>
		<xsl:if test="//OrderRequest/OrderRequestHeader/Extrinsic[@name='CancelDate']!=''">
			<G_N9>
				<S_N9>
					<D_128>ZZ</D_128>				
					<D_369>CancelDate</D_369>				
				</S_N9>
				<S_MSG>
					<D_933>
						<xsl:value-of select="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name='CancelDate'])"/>
					</D_933>
				</S_MSG>			
			</G_N9>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//M_850/G_PO1/S_PO1">
		<xsl:variable name="lineNum" select="D_350"/>
		<xsl:choose>
			<xsl:when test="/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemDetail/Extrinsic[@name='customsBarCodeNumber']!='' or /Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemDetail/Extrinsic[@name='customersPartNo']!=''">
				<S_PO1>
					<xsl:variable name="barCodeNum" select="/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemDetail/Extrinsic[@name='customsBarCodeNumber']"/>
					<xsl:variable name="eanCode">
						<xsl:choose>
							<xsl:when test="string-length($barCodeNum)=12">
								<xsl:value-of select="'UP'"/>
							</xsl:when>
							<xsl:when test="string-length($barCodeNum)=13">
								<xsl:value-of select="'EN'"/>
							</xsl:when>
							<xsl:when test="string-length($barCodeNum)=14">
								<xsl:value-of select="'UK'"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="AddItemPart">
						<xsl:with-param name="PO1Segment" select="."/>
						<xsl:with-param name="newPartQual" select="$eanCode"/>
						<xsl:with-param name="newPartValue" select="/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemDetail/Extrinsic[@name='customsBarCodeNumber']"/>
						<xsl:with-param name="newPartQual2" select="'BP'"/>
						<xsl:with-param name="newPartValue2" select="/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemDetail/Extrinsic[@name='customersPartNo']"/>
					</xsl:call-template>
				</S_PO1>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="//M_850/G_PO1/S_REF[D_128='ZZ' and lower-case(D_127)='customerspartno']">
		<xsl:element name="S_REF">
			<xsl:element name="D_128">L9</xsl:element>
			<xsl:element name="D_127">
				<xsl:value-of select="D_352"/>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	<xsl:template match="//M_850/G_PO1/S_REF[D_128='ZZ' and lower-case(D_127)='customsbarcodenumber']">
		<xsl:element name="S_REF">
			<xsl:element name="D_128">09</xsl:element>
			<xsl:element name="D_127">
				<xsl:value-of select="D_352"/>
			</xsl:element>
		</xsl:element>
		
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
	<xsl:template name="AddItemPart">
		<!-- this applies to PO/CO where not only supplier / buyer partID are considered, but also manufacturer partID -->
		<xsl:param name="newPartQual"/>
		<xsl:param name="newPartValue"/>
		<xsl:param name="newPartQual2"/>
		<xsl:param name="newPartValue2"/>
		<xsl:param name="PO1Segment"/>
		<xsl:variable name="countParts" select="count($PO1Segment/*[starts-with(name(), 'D_235')])"/>
		<xsl:variable name="newPosition" select="concat('_', string($countParts+1))"/>
		<xsl:variable name="newPosition2" select="concat('_', string($countParts+2))"/>
		<xsl:variable name="lastElementName" select="concat('D_234_', $countParts)"/>
		<xsl:choose>
			<xsl:when test="$countParts!=0">
				<xsl:for-each select="$PO1Segment/*[name()!=$lastElementName]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
				<xsl:copy-of select="$PO1Segment/*[name()=$lastElementName]"/>
				<xsl:choose>
					<xsl:when test="$newPartValue!='' and $newPartQual!=''">
						<xsl:element name="{concat('D_235', $newPosition)}">
							<xsl:value-of select="$newPartQual"/>
						</xsl:element>
						<xsl:element name="{concat('D_234', $newPosition)}">
							<xsl:value-of select="$newPartValue"/>
						</xsl:element>
						<xsl:if test="$newPartValue2!=''">
							<xsl:element name="{concat('D_235', $newPosition2)}">
								<xsl:value-of select="$newPartQual2"/>
							</xsl:element>
							<xsl:element name="{concat('D_234', $newPosition2)}">
								<xsl:value-of select="$newPartValue2"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$newPartValue2!=''">
						<xsl:element name="{concat('D_235', $newPosition)}">
							<xsl:value-of select="$newPartQual2"/>
						</xsl:element>
						<xsl:element name="{concat('D_234', $newPosition)}">
							<xsl:value-of select="$newPartValue2"/>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$newPartValue!=''">
						<xsl:element name="D_235">
							<xsl:value-of select="$newPartQual"/>
						</xsl:element>
						<xsl:element name="D_234">
							<xsl:value-of select="$newPartValue"/>
						</xsl:element>
						<xsl:if test="$newPartValue2!=''">
							<xsl:element name="D_235_2">
								<xsl:value-of select="$newPartQual2"/>
							</xsl:element>
							<xsl:element name="D_234_2">
								<xsl:value-of select="$newPartValue2"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$newPartValue2!=''">
						<xsl:element name="D_235">
							<xsl:value-of select="$newPartQual2"/>
						</xsl:element>
						<xsl:element name="D_234">
							<xsl:value-of select="$newPartValue2"/>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.<metaInformation>	<scenarios>		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\XMLs\CombinedDoc.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength=""		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"		          customvalidator="">			<advancedProp name="sInitialMode" value=""/>			<advancedProp name="bXsltOneIsOkay" value="true"/>			<advancedProp name="bSchemaAware" value="true"/>			<advancedProp name="bXml11" value="false"/>			<advancedProp name="iValidation" value="0"/>			<advancedProp name="bExtensions" value="true"/>			<advancedProp name="iWhitespace" value="0"/>			<advancedProp name="sInitialTemplate" value=""/>			<advancedProp name="bTinyTree" value="true"/>			<advancedProp name="bWarnings" value="true"/>			<advancedProp name="bUseDTD" value="false"/>			<advancedProp name="iErrorHandling" value="fatal"/>		</scenario>	</scenarios>	<MapperMetaTag>		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>		<MapperBlockPosition></MapperBlockPosition>		<TemplateContext></TemplateContext>		<MapperFilter side="source"></MapperFilter>	</MapperMetaTag></metaInformation>-->
