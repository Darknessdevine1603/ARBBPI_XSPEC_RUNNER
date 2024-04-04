<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <!--   <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="QueryStockRequest">
        <n0:StockCheckRequest>
            <xsl:attribute name="TransactionId">
                <xsl:value-of select="@transactionId"/>
            </xsl:attribute>
            <xsl:if test="string-length(normalize-space(@realmId)) > 0">               <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:attribute name="RealmName">
                    <xsl:value-of select="@realmId"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="/QueryStockRequest/keys">
                <StockKeys>
                    <MaterialNumber>
                        <xsl:value-of select="matnr"/>
                    </MaterialNumber>
                    <Plant>
                        <xsl:value-of select="plant"/>
                    </Plant>
                    <StorageLocation>
                        <xsl:value-of select="lgort"/>
                    </StorageLocation>
                </StockKeys>
            </xsl:for-each>
        </n0:StockCheckRequest>
    </xsl:template>
</xsl:stylesheet>
