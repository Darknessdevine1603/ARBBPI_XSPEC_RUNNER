<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	
	<!-- IG-31940 start -->
	<!-- change role -->
	<xsl:template match="InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']">
		<Contact>
			<xsl:attribute name="role">
				<xsl:value-of select="'receivingBank'"/>
			</xsl:attribute>
			<xsl:copy-of select="@*[name() != 'role']"/>
			<xsl:apply-templates select="node()"/>
		</Contact>
		<!-- add bankRoutingID  -->
		<xsl:if test="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'SO']/G_SG3/S_RFF/C_C506[D_1153 = 'RT']/D_1154 != ''">
			<IdReference>
				<xsl:attribute name="identifier">
					<xsl:value-of select="//M_INVOIC/G_SG2[S_NAD/D_3035 = 'SO']/G_SG3/S_RFF/C_C506[D_1153 = 'RT']/D_1154"/>
				</xsl:attribute>
				<xsl:attribute name="domain">
					<xsl:value-of select="'bankRoutingID'"/>
				</xsl:attribute>
			</IdReference>
		</xsl:if>
	</xsl:template>
	<!-- drop IdReference under soldTo -->
	<xsl:template match="InvoicePartner[Contact[@role = 'soldTo']]/IdReference[@domain = 'bankRoutingID'] ">
	</xsl:template>
	<!-- IG-31940 end -->
	
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
