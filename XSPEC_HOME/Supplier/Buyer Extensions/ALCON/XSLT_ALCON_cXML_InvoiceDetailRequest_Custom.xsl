<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->

	<xsl:template
		match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']">
		<Contact>
			<xsl:attribute name="role">receivingBank</xsl:attribute>
			<xsl:copy-of select="attribute::addressID, @addressIDDomain"/>
			<xsl:copy-of select="./child::*[name() != '']"/>
		</Contact>
		<xsl:copy-of select="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/IdReference[@domain = 'bankRoutingID']"/>			
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
