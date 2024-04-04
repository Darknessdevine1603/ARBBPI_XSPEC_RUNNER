<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
    <xsl:template match="//source"/>
    <!-- Extension Start -->
    <!-- IG-38187 Add additional LOC+14 under NAD+ST -->
    <xsl:template match="M_ORDERS/G_SG2[S_NAD/D_3035 = 'ST']">
        <G_SG2>
            <xsl:apply-templates select="S_NAD"/>
            <xsl:apply-templates select="S_LOC"/>
            <xsl:if test="//OrderRequest/OrderRequestHeader/ShipTo/IdReference[@domain = 'PhysicalAddressID']/@identifier">
                <S_LOC>
                    <D_3227>14</D_3227>
                    <C_C517>
                        <D_3225>
                            <xsl:value-of select="//OrderRequest/OrderRequestHeader/ShipTo/IdReference[@domain = 'PhysicalAddressID']/@identifier"/>
                        </D_3225>
                    </C_C517>
                </S_LOC>
            </xsl:if>
            <xsl:apply-templates select="S_FII, G_SG3, G_SG4, G_SG5"/>
        </G_SG2>
    </xsl:template>
    <!-- IG-38187 -->
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
