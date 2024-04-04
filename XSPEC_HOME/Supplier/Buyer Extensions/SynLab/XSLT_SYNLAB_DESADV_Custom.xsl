<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template
		match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem[ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date != ''] | //ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem[SupplierBatchID != '']">
		<ShipNoticeItem>
			<xsl:copy-of select="./@*"/>
			<xsl:apply-templates select="ItemID"/>
			<xsl:apply-templates select="ShipNoticeItemDetail"/>
			<xsl:apply-templates select="UnitOfMeasure"/>
			<xsl:apply-templates select="Packaging"/>
			<xsl:apply-templates select="Hazard"/>
			<Batch>
				<xsl:if test="ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date != ''">
					<xsl:attribute name="expirationDate">
						<xsl:value-of
							select="ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date"/>
					</xsl:attribute>	
					<xsl:copy-of select="Batch/@*[name() != 'expirationDate']"/>
					<!--<xsl:copy-of select="Batch/@productionDate,Batch/@inspectionDate,Batch/@batchQuantity"></xsl:copy-of>-->
				</xsl:if>
				<xsl:if test="SupplierBatchID != ''">
					<SupplierBatchID>
						<xsl:value-of select="SupplierBatchID"/>
					</SupplierBatchID>
				</xsl:if>
			</Batch>
			<xsl:apply-templates
				select="UnitOfMeasure/following-sibling::*[not(self::Packaging) and not(self::Hazard) and not(self::Batch) and not(self::SupplierBatchID)]"
			/>
		</ShipNoticeItem>
	</xsl:template>

	<!--<xsl:template
		match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/SupplierBatchID"> </xsl:template>-->

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
