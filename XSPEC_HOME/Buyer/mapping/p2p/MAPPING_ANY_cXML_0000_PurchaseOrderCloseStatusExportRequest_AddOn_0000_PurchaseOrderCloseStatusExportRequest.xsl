<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xpath-default-namespace="urn:Ariba:Buyer:vsap"
    xmlns:prx="urn:sap.com:proxy:NWC:/1SAI/TXS5702B25F6DD7952A79BA:700:2010/02/19"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">                                                     <!--IG-18112:Added exclude results prefix all as per XSLT guidelines-->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                <!--IG-18112:Added indent option as "no" as per XSLT guidelines-->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>             <!--IG-18112:Added common templates include as per XSLT guidelines-->
    <!--   <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->                     <!--IG-18112:Added line for local testing-->
    <xsl:template match="PurchaseOrderCloseStatusExportRequest">
        <n0:ARBCIG_BAPI_PO_CLOSE>
            <ARIBA_POID>
                <xsl:value-of select="ERPOrder_ClosePurchOrdLineDetails_Item/item/UniqueName"/>
            </ARIBA_POID>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
            <PURCHASEORDER>
                <xsl:value-of select="ERPOrder_ClosePurchOrdLineDetails_Item/item/OrderID"/>
            </PURCHASEORDER>
            <POITEM>
                <xsl:for-each
                    select="ERPOrder_ClosePurchOrdLineDetails_Item/item/LineItems/item[string-length(SAPPOLineNumber) > 0 and (ParentLineNumber = 0)]">
                    <item>
                        <PO_ITEM>
                            <xsl:value-of select="SAPPOLineNumber"/>
                        </PO_ITEM>
                        <xsl:variable name="v_close">
                            <xsl:choose>
                                <xsl:when test="string-length(Closed) = 0">
                                    <xsl:value-of
                                        select="/PurchaseOrderCloseStatusExportRequest/ERPOrder_ClosePurchOrdLineDetails_Item/item/Closed"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="Closed"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <NO_MORE_GR>
                            <xsl:call-template name="fixedValue">
                                <xsl:with-param name="closedValue" select="$v_close"/>
                                <xsl:with-param name="type" select="'GR'"/>
                            </xsl:call-template>
                        </NO_MORE_GR>
                        <FINAL_INV>
                            <xsl:call-template name="fixedValue">
                                <xsl:with-param name="closedValue" select="$v_close"/>
                                <xsl:with-param name="type" select="'INV'"/>
                            </xsl:call-template>
                        </FINAL_INV>
                        <ARIBA_ITEM_NO>
                            <xsl:value-of select="NumberInCollection"/>
                        </ARIBA_ITEM_NO>
                        <PARENT_LINE_NO>
                            <xsl:value-of select="ParentLineNumber"/>
                        </PARENT_LINE_NO>
                    </item>
                </xsl:for-each>
                <!--Mapping for Handling and Charge Line, and linking the close type from parent line -->
                <!--Defect IG-11113-->
                <xsl:for-each
                    select="ERPOrder_ClosePurchOrdLineDetails_Item/item/LineItems/item[string-length(SAPPOLineNumber) > 0 and (string(LineType/Category) = ('4','8','16'))]">
                    <item>
                        <PO_ITEM>
                            <xsl:value-of select="SAPPOLineNumber"/>
                        </PO_ITEM>
                        <xsl:variable name="v_parent" select="ParentLineNumber"/>
                        <xsl:variable name="v_close">
                            <xsl:choose>
                                <xsl:when test="string-length(Closed) = 0">
                                    <xsl:value-of
                                        select="/PurchaseOrderCloseStatusExportRequest/ERPOrder_ClosePurchOrdLineDetails_Item/item/Closed"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="../item[number(NumberInCollection) = $v_parent]/Closed"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <NO_MORE_GR>
                            <xsl:call-template name="fixedValue">
                                <xsl:with-param name="closedValue" select="$v_close"/>
                                <xsl:with-param name="type" select="'GR'"/>
                            </xsl:call-template>
                        </NO_MORE_GR>
                        <FINAL_INV>
                            <xsl:call-template name="fixedValue">
                                <xsl:with-param name="closedValue" select="$v_close"/>
                                <xsl:with-param name="type" select="'INV'"/>
                            </xsl:call-template>
                        </FINAL_INV>
                        <ARIBA_ITEM_NO>
                            <xsl:value-of select="NumberInCollection"/>
                        </ARIBA_ITEM_NO>
                        <PARENT_LINE_NO>
                            <xsl:value-of select="ParentLineNumber"/>
                        </PARENT_LINE_NO>
                    </item>
                </xsl:for-each>
            </POITEM>
        </n0:ARBCIG_BAPI_PO_CLOSE>
    </xsl:template>
    <xsl:template name="fixedValue">
        <xsl:param name="closedValue"/>
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="($closedValue = 5 or $closedValue = 7)">
                <xsl:value-of select="'X'"/>
            </xsl:when>
            <xsl:when test="$type = 'GR' and $closedValue = 3">
                <xsl:value-of select="'X'"/>
            </xsl:when>
            <xsl:when test="$type = 'INV' and $closedValue = 4">
                <xsl:value-of select="'X'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
