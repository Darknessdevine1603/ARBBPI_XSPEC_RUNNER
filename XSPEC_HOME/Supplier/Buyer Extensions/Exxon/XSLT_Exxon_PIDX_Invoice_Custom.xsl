<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/Comments">
		<xsl:copy-of select="."/>
		<xsl:if test="../InvoiceDetailServiceItemReference/ItemID/BuyerPartID != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">customersPartNo</xsl:attribute>
				<xsl:value-of select="../InvoiceDetailServiceItemReference/ItemID/BuyerPartID"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/Comments">
		<xsl:copy-of select="."/>
		<xsl:if test="../InvoiceDetailItemReference/ItemID/BuyerPartID != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">customersPartNo</xsl:attribute>
				<xsl:value-of select="../InvoiceDetailItemReference/ItemID/BuyerPartID"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/Combined/target/cXML/Header/To/Credential[1]">
		<xsl:copy-of select="."/>
		<xsl:variable name="systemID">
			<xsl:choose>
				<xsl:when test="/Combined/source/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(translate(pidx:Description, ' ', '')) = 'billtopurchasergroup']/pidx:ReferenceNumber != ''">
					<xsl:value-of select="/Combined/source/pidx:Invoice/pidx:InvoiceProperties/pidx:ReferenceInformation[lower-case(translate(pidx:Description, ' ', '')) = 'billtopurchasergroup']/pidx:ReferenceNumber"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$systemID != ''">
			<Credential domain="SYSTEMID">
				<Identity>
					<xsl:value-of select="$systemID"/>
				</Identity>
			</Credential>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications">
		<xsl:choose>
			<xsl:when test="exists(Modification[ModificationDetail/@name = 'Freight'])">
				<ShippingAmount>
					<xsl:copy-of select="Modification[ModificationDetail/@name = 'Freight'][1]/AdditionalCost/Money"/>
				</ShippingAmount>
				<xsl:if test="count(//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name != 'Freight']) &gt; 0">
					<InvoiceHeaderModifications>
						<xsl:copy-of select="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name != 'Freight']"/>
					</InvoiceHeaderModifications>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createMoney">
		<xsl:param name="curr"/>
		<xsl:param name="money"/>
		<xsl:variable name="HCur" select="/Combined/source/pidx:Invoice/pidx:InvoiceProperties/pidx:PrimaryCurrency/pidx:CurrencyCode"/>
		<xsl:variable name="moneyVal">
			<xsl:choose>
				<xsl:when test="string($money) != ''">
					<xsl:value-of select="$money"/>
				</xsl:when>
				<xsl:otherwise>0.00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currency">
			<xsl:choose>
				<xsl:when test="$curr != ''">
					<xsl:value-of select="$curr"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$HCur"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="Money">
			<xsl:attribute name="currency">
				<xsl:value-of select="$currency"/>
			</xsl:attribute>
			<xsl:value-of select="$moneyVal"/>
		</xsl:element>
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
