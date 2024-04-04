<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->	
	<xsl:template
		match="//InvoiceDetailRequestHeader/InvoicePartner[IdReference/@domain = 'gstTaxID' or IdReference/@domain = 'provincialTaxID']">
		<InvoicePartner>
			<Contact>
				<xsl:copy-of
					select="Contact/@*, Contact/Name, Contact/PostalAddress, Contact/Email, Contact/Phone, Contact/Fax, Contact/URL"/>

				<xsl:for-each select="IdReference">					
						<xsl:choose>
							<xsl:when test="@domain = 'gstTaxID'">
								<IdReference>
								<xsl:copy-of select="@identifier"/>
								<xsl:attribute name="domain">gstID</xsl:attribute>
								</IdReference>
							</xsl:when>
							<xsl:when test="@domain = 'provincialTaxID'">
								<IdReference>
								<xsl:copy-of select="@identifier"/>
								<xsl:attribute name="domain">qstID</xsl:attribute>
								</IdReference>
							</xsl:when>
						</xsl:choose>					
				</xsl:for-each>
				<xsl:copy-of select="Contact/Extrinsic"/>
			</Contact>
			<xsl:for-each select="IdReference">
				<xsl:choose>
					<xsl:when test="not(@domain = 'gstTaxID' or @domain = 'provincialTaxID')">
						<xsl:copy-of select="."/>
					</xsl:when>

				</xsl:choose>
			</xsl:for-each>
		</InvoicePartner>
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
