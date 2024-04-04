<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template
		match="/Combined/target/cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem">
		<ShipNoticeItem>
			<xsl:variable name="lineNum" select="@shipNoticeLineNumber"/>
			<xsl:copy-of select="@*"/>
			<ItemID>
				<SupplierPartID>
					<xsl:value-of
						select="//M_856/G_HL[S_HL/D_735 = 'I']/S_LIN[D_350 = $lineNum]/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'VA']][1]"
					/>
				</SupplierPartID>
				<xsl:if
					test="//M_856/G_HL[S_HL/D_735 = 'I']/S_LIN[D_350 = $lineNum]/child::*[starts-with(name(), D_235) and text() = 'IN']">
					<BuyerPartID>
						<xsl:value-of
							select="//M_856/G_HL[S_HL/D_735 = 'I']/S_LIN[D_350 = $lineNum]/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'IN']][1]"
						/>
					</BuyerPartID>
				</xsl:if>
				<xsl:if
					test="//M_856/G_HL[S_HL/D_735 = 'I']/S_LIN[D_350 = $lineNum]/child::*[starts-with(name(), D_235) and text() = 'UP']">
					<IdReference>
						<xsl:attribute name="domain">
							<xsl:text>UPCConsumerPackageCode</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="identifier">
							<xsl:value-of
								select="//M_856/G_HL[S_HL/D_735 = 'I']/S_LIN[D_350 = $lineNum]/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'UP']][1]"
							/>
						</xsl:attribute>
					</IdReference>
				</xsl:if>
			</ItemID>
			<xsl:apply-templates select="*[not(self::ItemID)]"/>
		</ShipNoticeItem>
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
