<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
    <xsl:template match="//source"/>
    <!-- Extension Start  -->
    
    
    <xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role='from']/IdReference[@domain='SupplierTaxID']">
        <xsl:element name="IdReference">
            <xsl:attribute name="domain">gstID</xsl:attribute>
            <xsl:copy-of select="@identifier"></xsl:copy-of>
        </xsl:element>
    </xsl:template>
    
    <!-- Extension Ends  -->
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
