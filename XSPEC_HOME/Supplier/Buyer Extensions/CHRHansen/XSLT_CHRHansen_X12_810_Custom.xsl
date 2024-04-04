<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="//source"/>
	<!-- Extension Start  -->

	<xsl:template match="/Combined/target/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/child::*[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="../../InvoiceDetailSummary[InvoiceHeaderModifications/Modification/ModificationDetail/@name = 'Shipping']/Tax[number(Money) != 0]">
			<InvoiceDetailServiceItem invoiceLineNumber="99999" quantity="1">
				<InvoiceDetailServiceItemReference lineNumber="0">
					<Classification domain="unspsc">78100000</Classification>
					<ItemID>
						<SupplierPartID>NotAvailable</SupplierPartID>
					</ItemID>
					<Description xml:lang="en">Shipping Cost</Description>
				</InvoiceDetailServiceItemReference>
				<SubtotalAmount>
					<xsl:copy-of select="../../InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Shipping']/AdditionalCost/Money"/>
				</SubtotalAmount>
				<UnitOfMeasure>EA</UnitOfMeasure>
				<UnitPrice>
					<xsl:copy-of select="../../InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Shipping']/AdditionalCost/Money"/>
				</UnitPrice>
				<Extrinsic name="IsShippingServiceItem">yes</Extrinsic>
			</InvoiceDetailServiceItem>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/Combined/target/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications[Modification/ModificationDetail/@name = 'Shipping']">
		<xsl:choose>
			<xsl:when test="Modification[(ModificationDetail/@name != 'Shipping')]">
				<xsl:element name="InvoiceHeaderModifications">
					<xsl:copy-of select="Modification[(ModificationDetail/@name != 'Shipping')]"/>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/Combined/target/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary[InvoiceHeaderModifications/Modification/ModificationDetail/@name = 'Shipping']/Tax[number(Money) = 0]">
		<xsl:copy-of select="."/>
		<xsl:copy-of select="../SpecialHandlingAmount"/>
		<xsl:if test="exists(../InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Shipping'])">
			<ShippingAmount>
				<xsl:copy-of select="../InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'Shipping'][1]/AdditionalCost/Money"/>
			</ShippingAmount>
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
