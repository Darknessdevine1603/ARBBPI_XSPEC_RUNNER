<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->	
	<xsl:template match="//ShipNoticeRequest/ShipNoticeHeader/Extrinsic[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="//M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CO']">
			<Extrinsic name="BuyerOrderNumber">
				<xsl:value-of select="//M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CO']/D_1154"/>
			</Extrinsic>						
		</xsl:if>
		<xsl:if test="//M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AEU']">
			<Extrinsic name="SupSONumber">
				<xsl:value-of select="//M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'AEU']/D_1154"/>
			</Extrinsic>						
		</xsl:if>
		<xsl:if test="//M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CR']">
			<Extrinsic name="CusPONumber">
				<xsl:value-of select="//M_DESADV/G_SG1/S_RFF/C_C506[D_1153 = 'CR']/D_1154"/>
			</Extrinsic>						
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
