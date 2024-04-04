<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


    <xsl:template match="//source"/>
    <!-- Extension Start  -->
    <xsl:template
        match="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification/ModificationDetail">
        <ModificationDetail>
        <xsl:apply-templates select="@*"/>
        <xsl:attribute name="code">

            <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:apply-templates select="@* | node()"/>
        </ModificationDetail>
    </xsl:template>

    <xsl:template
        match="//InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailSummaryLineItemModifications/Modification/ModificationDetail">
        <ModificationDetail>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="code">
                
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </ModificationDetail> 
        
       
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
