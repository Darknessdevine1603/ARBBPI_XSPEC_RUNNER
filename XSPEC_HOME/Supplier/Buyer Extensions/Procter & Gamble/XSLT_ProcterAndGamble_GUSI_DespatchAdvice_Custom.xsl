<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//cXML/Request/ShipNoticeRequest/ShipNoticeHeader/child::*[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="//deliveryAndTransportInformation/licensePlate != ''">
			<Extrinsic>
				<xsl:attribute name="name">
					<xsl:text>plateNo</xsl:text>
				</xsl:attribute>
				<xsl:value-of select="//deliveryAndTransportInformation/licensePlate"/>
			</Extrinsic>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//cXML/Request/ShipNoticeRequest/ShipNoticePortion">
		<xsl:element name="ShipNoticePortion">
			<xsl:copy-of select="OrderReference"/>
			<xsl:element name="MasterAgreementIDInfo">
				<xsl:attribute name="agreementID">
					<xsl:value-of select="OrderReference/@orderID"/>
				</xsl:attribute>
				<xsl:attribute name="agreementType">scheduling_agreement</xsl:attribute>
			</xsl:element>
			<xsl:copy-of select="ShipNoticeItem"/>
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
