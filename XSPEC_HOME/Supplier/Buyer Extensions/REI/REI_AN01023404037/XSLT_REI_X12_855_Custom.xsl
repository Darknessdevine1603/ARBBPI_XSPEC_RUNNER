<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->

	<xsl:template match="ConfirmationRequest/ConfirmationItem/ConfirmationStatus">
		<xsl:variable name="LineConfirm">
			<xsl:value-of select="../@lineNumber"/>
		</xsl:variable>
		<xsl:variable name="ack">
			<xsl:call-template name="createACK">
				<xsl:with-param name="ACK"
					select="//M_855/G_PO1[S_PO1/D_350 = $LineConfirm]/G_ACK/S_ACK"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when
				test="exists(ItemIn) and ($ack/ack/element[@name = 'VA'] or $ack/ack/element[@name = 'IN'])">
				<ConfirmationStatus>
					<xsl:copy-of select="./@*"/>
					<xsl:apply-templates select="UnitOfMeasure"/>
					<ItemIn>
						<xsl:copy-of select="ItemIn/@*"/>
						<ItemID>
							<SupplierPartID>
								<xsl:value-of select="$ack/ack/element[@name = 'VA']/@value"/>
							</SupplierPartID>
							<xsl:copy-of select="ItemIn/ItemID/SupplierPartAuxiliaryID"/>
							<xsl:if test="$ack/ack/element[@name = 'IN']/@value != ''">
								<BuyerPartID>
									<xsl:value-of select="$ack/ack/element[@name = 'IN']/@value"/>
								</BuyerPartID>
							</xsl:if>
							<xsl:copy-of select="ItemIn/ItemID/IdReference"/>
						</ItemID>
						<xsl:copy-of select="ItemIn/ItemID/following-sibling::*"/>
					</ItemIn>
					<xsl:apply-templates
						select="UnitOfMeasure/following-sibling::*[not(self::ItemIn)]"/>
				</ConfirmationStatus>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<xsl:template name="createACK">
		<xsl:param name="ACK"/>
		<ack>
			<xsl:for-each select="$ACK/*[starts-with(name(), 'D_23')]">
				<xsl:if test="starts-with(name(), 'D_235')">
					<element>
						<xsl:attribute name="name">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of
								select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"
							/>
						</xsl:attribute>
					</element>
				</xsl:if>
			</xsl:for-each>
		</ack>
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
