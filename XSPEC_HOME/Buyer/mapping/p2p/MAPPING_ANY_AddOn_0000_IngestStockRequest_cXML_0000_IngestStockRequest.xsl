<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    xmlns:urn="urn:Ariba:Buyer:vsap" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                       <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="n0:IngestStockRequest">
        <IngestStock>
            <xsl:attribute name="transactionId">
                <xsl:value-of select="IngestStock/@TransactionId"/>
            </xsl:attribute>
            <xsl:attribute name="batchNumber">
                <xsl:value-of select="IngestStock/@BatchNumber"/>
            </xsl:attribute>
            <xsl:attribute name="lastBatch">
                <xsl:value-of select="IngestStock/@LastBatch"/>
            </xsl:attribute>
            <xsl:for-each select="IngestStock/StockInfo">
                <stockInfos>
                    <matnr>
                        <xsl:value-of select="MaterialNumber"/>
                    </matnr>
                    <plant>
                        <xsl:value-of select="Plant"/>
                    </plant>
                    <lgort>
                        <xsl:value-of select="StorageLocation"/>
                    </lgort>
                    <labst>
                        <xsl:value-of select="UnrestrictedStock"/>
                    </labst>
                </stockInfos>
            </xsl:for-each>
        </IngestStock>
    </xsl:template>
</xsl:stylesheet>
