<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="DeltaStockRequest">
        <n0:StockCheckRequest>
            <xsl:attribute name="TransactionId">
                <xsl:value-of select="@transactionId"/>
            </xsl:attribute>
            <xsl:if test="@batchNo != ''">
                <xsl:attribute name="BatchNumber">
                    <xsl:value-of select="@batchNo"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@realmId != ''">
                <xsl:attribute name="RealmName">
                    <xsl:value-of select="@realmId"/>
                </xsl:attribute>
            </xsl:if>
        </n0:StockCheckRequest>
    </xsl:template>
</xsl:stylesheet>
