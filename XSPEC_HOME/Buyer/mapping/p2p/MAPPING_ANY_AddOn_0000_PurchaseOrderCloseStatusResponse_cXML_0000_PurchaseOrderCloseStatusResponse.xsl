<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xmlns:prx="urn:sap.com:proxy:NWC:/1SAI/TXS5702B25F6DD7952A79BA:700:2010/02/19"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">                                                                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:param name="p2pTimezone"/>
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
<!--    <xsl:include href="../../../../BUYER_CONTENT/common/FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
    <xsl:template match="n0:ARBCIG_BAPI_PO_CLOSE.Response">        
        <PurchaseOrderCloseStatusExportReply>
            <partition>
                <xsl:value-of select="PARTITION"/>
            </partition>
            <variant>
                <xsl:value-of select="VARIANT"/>
            </variant>
            <xsl:variable name="v_err_flag">
                <xsl:if test="RETURN/item/TYPE = 'E' or RETURN/item/TYPE = 'A'">
                    <xsl:value-of select="'X'"/>
                </xsl:if>
            </xsl:variable>
            <!--            Check if error exist-->
            <xsl:choose>
                <xsl:when test="$v_err_flag != 'X'">
                    <ERPOrder_ClosePurchaseOrderNumberImport_Item>
                        <item>
                            <LineItems>
                                <xsl:for-each select="POITEM/item">
                                    <item>
                                        <NumberInCollection>
                                            <xsl:value-of select="ARIBA_ITEM_NO"/>
                                        </NumberInCollection>
                                    </item>
                                </xsl:for-each>
                            </LineItems>
                            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
<!--                            This field is not used by neither P2P nor ERP, even PURCHSEORDER_EX field doesn't exist in ERP -->
                            <!--<OrderId>
                                <xsl:value-of
                                    select="/n0:ARBCIG_BAPI_PO_CLOSE.Response/PURCHASEORDER_EX"/>
                            </OrderId>-->
                            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                            <UniqueName>
                                <xsl:value-of select="/n0:ARBCIG_BAPI_PO_CLOSE.Response/ARIBA_POID"/>
                            </UniqueName>
                        </item>
                    </ERPOrder_ClosePurchaseOrderNumberImport_Item>
                </xsl:when>
                <xsl:otherwise>
                    <PurchaseOrderError_ClosePurchOrdErrorImport_Item>
                        <xsl:for-each select="RETURN/item[TYPE = 'E' or TYPE = 'A']">
                            <item>
                                <Date>
                                    <xsl:value-of select="current-dateTime()"/>
                                </Date>
                                <ErrorClient>
                                    <xsl:value-of select="SYSTEM"/>
                                </ErrorClient>
                                <ErrorMessage>
                                    <xsl:value-of select="MESSAGE"/>
                                </ErrorMessage>
                                <ErrorNumber>
                                    <xsl:value-of select="NUMBER"/>
                                </ErrorNumber>
                                <ErrorSAPField>
                                    <xsl:value-of select="FIELD"/>
                                </ErrorSAPField>
                                <ErrorSAPId>
                                    <xsl:value-of select="ID"/>
                                </ErrorSAPId>
                                <ErrorSAPModule>
                                    <xsl:value-of select="'ARBCIG_BAPI_PO_CLOSE'"/>
                                </ErrorSAPModule>
                                <ErrorSAPScreen>
                                    <xsl:value-of select="'ARBCIG_BAPI_PO_CLOSE'"/>
                                </ErrorSAPScreen>
                                <Id>
                                    <xsl:value-of select="/n0:ARBCIG_BAPI_PO_CLOSE.Response/ARIBA_POID"/>
                                </Id>
                                <NumInSet>
                                    <xsl:value-of select="position()"/>
                                </NumInSet>
                                <Type>
                                    <xsl:value-of select="TYPE"/>
                                </Type>
                            </item>
                        </xsl:for-each>
                    </PurchaseOrderError_ClosePurchOrdErrorImport_Item>
                </xsl:otherwise>
            </xsl:choose>
        </PurchaseOrderCloseStatusExportReply>
    </xsl:template>
</xsl:stylesheet>
