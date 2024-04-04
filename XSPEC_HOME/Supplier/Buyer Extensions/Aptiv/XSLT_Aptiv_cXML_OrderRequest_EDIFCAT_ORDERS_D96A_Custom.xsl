<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->

	<xsl:template match="//M_ORDERS/S_FTX[last()]">
		<xsl:copy-of select="."/>
		<xsl:if
			test="normalize-space(//OrderRequest/OrderRequestHeader/PaymentTerm/Extrinsic[@name = 'Payment Terms ID']) != ''">
			<S_FTX>
				<D_4451>ZZZ</D_4451>
				<C_C108>
					<D_4440>Payment Terms ID</D_4440>
					<D_4440_2>
						<xsl:value-of
							select="normalize-space(//OrderRequest/OrderRequestHeader/PaymentTerm/Extrinsic[@name = 'Payment Terms ID'])"
						/>
					</D_4440_2>
				</C_C108>
			</S_FTX>
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
