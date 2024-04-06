<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="urn:sap-com:document:sap:rfc:functions" xmlns:urn="urn:Ariba:Buyer:vsap"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                       <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="n0:ARBCIG_ADV_PAY_REMIT_EXPORT">
        <xsl:variable name="v_headerItem" select="//ADVANCE_PAYREMITTANCE/ITEM/item"/>
        <xsl:variable name="v_item" select="//ADVANCE_PAYREMITTANCE/ITEM/item/ITEM"/>
        <urn:AdvancePaymentRemittanceAsyncPullRequest>
            <xsl:attribute name="partition">
                <xsl:value-of select="PARTITION"/>
            </xsl:attribute>
            <xsl:attribute name="variant">
                <xsl:value-of select="VARIANT"/>
            </xsl:attribute>
            <urn:AdvancePaymentRemittance_AdvancePaymentRemittancePull_Item>
                <xsl:for-each select="$v_headerItem">
                    <xsl:variable name="v_aprid" select="$v_headerItem/APR_ID"/>
                    <urn:item>
                        <urn:DocID>
                            <xsl:value-of select="APR_ID"/>
                        </urn:DocID>
                        <urn:ERPRequestID>
                            <xsl:value-of select="ERPREQUESTID"/>
                        </urn:ERPRequestID>
                        <urn:LineItems>
                            <xsl:for-each select="ITEM/item[APR_ID = $v_aprid]">
                                <urn:item>
                                    <urn:Amount>
                                        <urn:Amount>
                                            <xsl:value-of select="AMOUNT"/>
                                        </urn:Amount>
                                        <urn:Currency>
                                            <urn:UniqueName>
                                                <xsl:value-of select="CURRENCY"/>
                                            </urn:UniqueName>
                                        </urn:Currency>
                                    </urn:Amount>
                                    <urn:DocID>
                                        <xsl:value-of select="APR_ID"/>
                                    </urn:DocID>
                                    <urn:ERPRequestID>
                                        <xsl:value-of select="ERPREQUESTID"/>
                                    </urn:ERPRequestID>
                                    <urn:ERPRequestLineNumber>
                                        <xsl:value-of select="VDP_ITEM"/>
                                    </urn:ERPRequestLineNumber>
                                    <urn:NumberInCollection>
                                        <xsl:value-of select="number(LINENUMBER)"/>
                                    </urn:NumberInCollection>
                                </urn:item>
                            </xsl:for-each>
                        </urn:LineItems>
                        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <urn:LookupID>
                            <xsl:value-of select="LOOKUPID"/>
                        </urn:LookupID>
                        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    </urn:item>
                </xsl:for-each>
            </urn:AdvancePaymentRemittance_AdvancePaymentRemittancePull_Item>
        </urn:AdvancePaymentRemittanceAsyncPullRequest>
    </xsl:template>
</xsl:stylesheet>
