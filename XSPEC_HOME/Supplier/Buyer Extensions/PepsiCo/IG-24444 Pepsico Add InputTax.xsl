<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
    <xsl:template match="//source"/>
    <!-- IG-24444 Extension Start  -->


    <xsl:template
        match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/Tax/TaxDetail/@category">
        <xsl:variable name="v_category" select="."/>
        <xsl:attribute name="category">
            <xsl:choose>
                <xsl:when test="$v_category = 'VAT' or $v_category = 'vat'">
                    <xsl:value-of select="'inputTax'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@category">
        <xsl:variable name="v_category" select="."/>
        <xsl:attribute name="category">
            <xsl:choose>
                <xsl:when test="$v_category = 'VAT' or $v_category = 'vat'">
                    <xsl:value-of select="'inputTax'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
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
