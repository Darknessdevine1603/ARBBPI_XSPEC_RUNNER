<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//M_860/G_N1[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'clientNumber']) != ''">
			<G_N1>
				<S_N1>
					<D_98>PD</D_98>
				</S_N1>
				<S_PER>
					<D_366>CN</D_366>
					<xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'deliveryReference']) != ''">
						<D_93>
							<xsl:value-of select="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'deliveryReference'])"/>
						</D_93>
					</xsl:if>
					<D_365>TE</D_365>
					<D_364>
						<xsl:value-of select="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'clientNumber'])"/>
					</D_364>
				</S_PER>
			</G_N1>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//M_860/S_FOB[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTerm']) != ''">
			<S_FOB>
				<D_146>CC</D_146>
				<D_335>
					<xsl:value-of select="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTerm'])"/>
				</D_335>
			</S_FOB>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//M_860/S_REF[not(exists(../S_FOB))][last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTerm']) != ''">
			<S_FOB>
				<D_146>CC</D_146>
				<D_335>
					<xsl:value-of select="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTerm'])"/>
				</D_335>
			</S_FOB>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//M_860/G_POC/G_N1[last()]">
		<xsl:copy-of select="."/>
		<xsl:call-template name="buildlineN1"/>
	</xsl:template>
	<xsl:template match="//M_860/G_POC/G_N9[not(exists(../G_N1))][last()]">
		<xsl:copy-of select="."/>
		<xsl:call-template name="buildlineN1"/>
	</xsl:template>
	<xsl:template match="//M_860/G_POC/G_SCH[not(exists(../G_N1))][not(exists(../G_N9))][last()]">
		<xsl:copy-of select="."/>
	
		<xsl:call-template name="buildlineN1"/>
	</xsl:template>

	<xsl:template name="buildlineN1">
		<xsl:variable name="lineNum">
			<xsl:value-of select="../S_POC/D_350"/>
		</xsl:variable>
		<xsl:if test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'receiverID']) != ''">
			<G_N1>
				<S_N1>
					<D_98>
						<xsl:value-of select="'EN'"/>
					</D_98>
					<D_93>
						<xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'receiverID']), 1, 60)"/>
					</D_93>
				</S_N1>
				<xsl:if test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'DeliveryAddress']) != ''">
					<S_N3>
						<D_166>
							<xsl:value-of select="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'DeliveryAddress'])"/>
						</D_166>
					</S_N3>
				</xsl:if>
				<xsl:if test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'customerReferenceNo']) != '' or normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'locationWithinEquipment']) != ''">
					<S_PER>
						<D_366>CN</D_366>
						<xsl:if test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'customerReferenceNo']) != ''">
							<D_365>TE</D_365>
							<D_364>
								<xsl:value-of select="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'customerReferenceNo'])"/>
							</D_364>
						</xsl:if>
						<xsl:if test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'locationWithinEquipment']) != ''">
							<D_365_2>EM</D_365_2>
							<D_364_2>
								<xsl:value-of select="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'locationWithinEquipment'])"/>
							</D_364_2>
						</xsl:if>
					</S_PER>
				</xsl:if>
			</G_N1>
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
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.<metaInformation>	<scenarios/>	<MapperMetaTag>		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>		<MapperBlockPosition></MapperBlockPosition>		<TemplateContext></TemplateContext>		<MapperFilter side="source"></MapperFilter>	</MapperMetaTag></metaInformation>-->
