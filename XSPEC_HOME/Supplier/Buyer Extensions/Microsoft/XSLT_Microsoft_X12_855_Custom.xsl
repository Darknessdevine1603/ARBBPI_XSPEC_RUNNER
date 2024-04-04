<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	
	<xsl:template match="//source"/>
	
	<!-- Extension Start  -->
	<xsl:template match="/Combined/target/cXML/Request/ConfirmationRequest/ConfirmationHeader/@noticeDate">
		<xsl:attribute name="noticeDate">
			<xsl:call-template name="changeDateTime">
				<xsl:with-param name="originalDate" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="/Combined/target/cXML/Request/ConfirmationRequest/ConfirmationItem/ConfirmationStatus/@deliveryDate">
		<xsl:attribute name="deliveryDate">
			<xsl:call-template name="changeDateTime">
				<xsl:with-param name="originalDate" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="/Combined/target/cXML/Request/ConfirmationRequest/ConfirmationItem/ConfirmationStatus/@shipmentDate">
		<xsl:attribute name="shipmentDate">
			<xsl:call-template name="changeDateTime">
				<xsl:with-param name="originalDate" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="changeDateTime">
		<xsl:param name="originalDate"/>
		<xsl:choose>
			<xsl:when test="ends-with($originalDate,'T00:00:00+00:00')">
				<xsl:value-of select="concat(substring-before($originalDate, 'T'), 'T12:00:00+00:00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$originalDate"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Extension Ends -->
	
	<xsl:template match="//Combined">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="//target">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>