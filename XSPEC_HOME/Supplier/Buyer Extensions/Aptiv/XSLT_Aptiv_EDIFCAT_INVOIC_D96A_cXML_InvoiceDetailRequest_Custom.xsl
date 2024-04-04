<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[last()]">
		<xsl:copy-of select="."/>
		<xsl:if
			test="//M_INVOIC/G_SG2/G_SG3/S_RFF/C_C506[D_1153 = 'PY']/D_1154 != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name" select="'accountNumber'"/>
				<xsl:value-of select="//M_INVOIC/G_SG2/G_SG3/S_RFF/C_C506[D_1153 = 'PY']/D_1154"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template
		match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/Extrinsic[last()]">
		<xsl:variable name="itemNumber" select="../@invoiceLineNumber"/>
		<xsl:copy-of select="."/>
		<xsl:if
			test="normalize-space(//M_INVOIC/G_SG25/S_LIN[D_1082 = $itemNumber]/C_C829[D_5495 = '1']/D_1082) != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name" select="'parentPOLineNumber'"/>
				<xsl:value-of
					select="//M_INVOIC/G_SG25/S_LIN[D_1082 = $itemNumber]/C_C829[D_5495 = '1']/D_1082"
				/>
			</xsl:element>
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
