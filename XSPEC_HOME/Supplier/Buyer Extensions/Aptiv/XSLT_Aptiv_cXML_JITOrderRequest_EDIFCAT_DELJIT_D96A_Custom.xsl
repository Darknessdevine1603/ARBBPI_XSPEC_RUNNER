<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->

	<xsl:template match="//M_DELJIT/G_SG1[last()]">
		<xsl:copy-of select="."/>
		<xsl:if
			test="normalize-space(//OrderRequest/OrderRequestHeader/PaymentTerm/Extrinsic[@name = 'Payment Terms ID']) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>ZZZ</D_1153>
						<D_1154>Payment Terms ID</D_1154>
						<D_4000>
							<xsl:value-of
								select="normalize-space(//OrderRequestHeader/PaymentTerm/Extrinsic[@name = 'Payment Terms ID'])"
							/>
						</D_4000>
					</C_C506>
				</S_RFF>
			</G_SG1>
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
