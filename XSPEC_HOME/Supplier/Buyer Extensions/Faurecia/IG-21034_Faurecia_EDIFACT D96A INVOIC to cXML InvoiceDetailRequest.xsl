<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   
   
    <xsl:template match="//source"/>
    <!-- Extension Start  -->
   
    <xsl:template
        match="//InvoiceDetailRequest/InvoiceDetailRequestHeader">
        <InvoiceDetailRequestHeader>
            <xsl:copy-of select="@*|node()[name()!='Extrinsic']"/>
            <xsl:if
                test="/Combined/source//M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154 != ''">
                <xsl:element name="IdReference">
                    <xsl:attribute name="identifier">
                        <xsl:value-of
                            select="/Combined/source//M_INVOIC/G_SG1/S_RFF/C_C506[D_1153 = 'VN']/D_1154"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="domain">
                        <xsl:text>supplierReference</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:copy-of select="Extrinsic"/>
        </InvoiceDetailRequestHeader>
    </xsl:template>
    <xsl:template
        match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/InvoiceDetailServiceItemReference">
        <InvoiceDetailServiceItemReference>
            <xsl:variable name="v_linenumber" select="../@invoiceLineNumber"/>
            <xsl:copy-of select="@*|node()[name()!='ItemID' and name()!='Description']"/>
            <xsl:if test="/Combined/source//M_INVOIC/G_SG25[S_LIN[C_C212/D_7143 = 'MP']/D_1082 = $v_linenumber]/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']">
                <xsl:element name="Classification">
                    <xsl:attribute name="domain">
                        <xsl:choose>
                            <xsl:when
                                test="/Combined/source//M_INVOIC/G_SG25[S_LIN/D_1082 = $v_linenumber]/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']/D_7008_1 != ''">
                                <xsl:value-of
                                    select="/Combined/source//M_INVOIC/G_SG25[S_LIN/D_1082 = $v_linenumber]/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']/D_7008_1"/>
                            </xsl:when>
                            <xsl:otherwise>NotAvailable</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="/Combined/source//M_INVOIC/G_SG25[S_LIN/D_1082 = $v_linenumber]/S_IMD[D_7077 = 'B']/C_C273[D_7009 = 'ACA']/D_7008_2"/>
                </xsl:element>
            </xsl:if>
            <xsl:copy-of select="ItemID, Description"/>
        </InvoiceDetailServiceItemReference>
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
