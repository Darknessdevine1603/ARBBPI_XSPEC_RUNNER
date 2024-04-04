<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>	
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="G_N1[S_N1/D_98 = 'ST']">
		<xsl:choose>
			<xsl:when
				test="//cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/Extrinsic[@name = 'c/o'] != ''">
				<G_N1>
					<xsl:copy-of select="S_N1"/>
					<S_N2>
						<D_93>
							<xsl:value-of
								select="//cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/Extrinsic[@name = 'c/o']"
							/>
						</D_93>
						<xsl:copy-of select="D_93_2"/>
					</S_N2>
					<xsl:copy-of select="S_N3, S_N4, S_REF, S_PER, S_FOB"/>
				</G_N1>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
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
