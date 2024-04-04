<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	
	<xsl:template match="G_LIN[1]">
		<S_REF>
			<D_128>43</D_128>
			<xsl:if test="//cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID != ''">
				<D_352>
					<xsl:value-of select="substring(//cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID,1,80)"/>
					
				</D_352>
			</xsl:if>
		</S_REF>
		<G_LIN>
			<xsl:apply-templates select="@* | node()"/>
		</G_LIN>
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
