<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->

	<xsl:template
		match="//InvoiceDetailRequestHeader/InvoicePartner[IdReference/@domain = 'gstTaxID']/Contact">
		<Contact>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="./child::*[name() != 'Extrinsic']"/>

			<xsl:if test="../IdReference[@domain = 'gstTaxID']">
				<IdReference>
					<xsl:copy-of select="../IdReference[@domain = 'gstTaxID']/@identifier"/>
					<xsl:attribute name="domain">gstID</xsl:attribute>
				</IdReference>
			</xsl:if>

			<xsl:copy-of select="Extrinsic"/>
		</Contact>

	</xsl:template>

	<xsl:template
		match="//InvoiceDetailRequestHeader/InvoicePartner/IdReference[@domain = 'gstTaxID']"> </xsl:template>

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
