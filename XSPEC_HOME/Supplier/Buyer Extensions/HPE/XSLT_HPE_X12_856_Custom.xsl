<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//ShipNoticeRequest/ShipNoticeHeader/Extrinsic[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="//M_856/G_HL[S_HL/D_735 = 'S' and S_REF[D_128 = 'HH']/D_127 != '']">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">fiscalCode</xsl:attribute>
				<xsl:value-of select="//M_856/G_HL[S_HL/D_735 = 'S']/S_REF[D_128 = 'HH']/D_127"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//ShipNoticeRequest/ShipNoticePortion">
		<xsl:element name="ShipNoticePortion">
			<xsl:apply-templates select="OrderReference"/>
			<xsl:apply-templates select="MasterAgreementReference"/>
			<xsl:apply-templates select="MasterAgreementIDInfo"/>
			<xsl:apply-templates select="Contact"/>
			<xsl:apply-templates select="Comments"/>
			<xsl:apply-templates select="Extrinsic"/>
			<xsl:if test="//M_856/G_HL[S_HL/D_735='S']/S_REF[D_128='CO']/D_127!=''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">ultimatecustomerReferenceID</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735='S']/S_REF[D_128='CO']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="//M_856/G_HL[S_HL/D_735='S']/S_REF[D_128='ZG']/D_127!=''">
				<xsl:element name="Extrinsic">
					<xsl:attribute name="name">customerReferenceID</xsl:attribute>
					<xsl:value-of select="//M_856/G_HL[S_HL/D_735='S']/S_REF[D_128='ZG']/D_127"/>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates select="ShipNoticeItem"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Extrinsic[last()]">		
		<xsl:copy-of select="."/>		
		<xsl:variable name="lineNum" select="../@shipNoticeLineNumber"/>	
		
		<xsl:if test="//M_856/G_HL[S_LIN/D_350=$lineNum and S_HL/D_735 = 'I']/S_REF[D_128 = '2A']/D_127!=''">        
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">importLicenseNo</xsl:attribute>
				<xsl:value-of select="concat(//M_856/G_HL[S_LIN/D_350=$lineNum and S_HL/D_735 = 'I']/S_REF[D_128 = '2A']/D_127,//M_856/G_HL[S_LIN/D_350=$lineNum and S_HL/D_735 = 'I']/S_REF[D_128 = '2A']/D_352)"/>
			</xsl:element>
		</xsl:if>	
		
	</xsl:template>
	<!-- IG-38572 start -->
	<xsl:template match="//ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging/Description">
		<Description>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:value-of select="@type"/>
		</Description>
	</xsl:template>
	<!-- IG-38572 end -->
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