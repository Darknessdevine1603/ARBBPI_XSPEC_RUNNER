<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
    <xsl:template match="//source"/>
    <!-- Extension Start  -->
    <!-- Header Extrinsic -->
    <xsl:template match="//M_ORDCHG/G_SG3[S_NAD/D_3035 = 'ST']">
        <G_SG3>
            <xsl:copy-of select="S_NAD, S_LOC, S_FII, G_SG4, G_SG5, G_SG6"/>
            <xsl:if
                test="//OrderRequestHeader/ShipTo/Address/PostalAddress/Extrinsic[@name = 'Requestor']">
                <G_SG6>
                    <S_CTA>
                        <D_3139>PD</D_3139>
                        <C_C056>
                            <D_3412>
                                <xsl:value-of
                                    select="substring(normalize-space(//OrderRequestHeader/ShipTo/Address/PostalAddress/Extrinsic[@name = 'Requestor']), 1, 35)"
                                />
                            </D_3412>
                        </C_C056>
                    </S_CTA>
                </G_SG6>
            </xsl:if>
        </G_SG3>
    </xsl:template>

    <xsl:template match="//M_ORDCHG/G_SG26/S_FTX[last()]">

        <xsl:variable name="lineNum">
            <xsl:value-of select="../S_LIN/D_1082"/>
        </xsl:variable>
        <xsl:copy-of select="."/>
        <xsl:if
            test="//OrderRequest/ItemOut[substring(format-number(@lineNumber, '#'), 1, 6) = $lineNum]/ItemID/IdReference/@domain = 'CrossDoc'">
            <S_FTX>
                <D_4451>ABR</D_4451>
                <C_C108>
                    <D_4440>
                        <xsl:value-of
                            select="substring(normalize-space(//OrderRequest/ItemOut[substring(format-number(@lineNumber, '#'), 1, 6) = $lineNum]/ItemID/IdReference[@domain = 'CrossDoc']/@identifier), 1, 70)"
                        />
                    </D_4440>

                </C_C108>
            </S_FTX>
        </xsl:if>

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
