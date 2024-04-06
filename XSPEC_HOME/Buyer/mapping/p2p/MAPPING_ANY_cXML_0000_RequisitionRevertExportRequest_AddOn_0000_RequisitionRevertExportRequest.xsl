<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xpath-default-namespace="urn:Ariba:Buyer:vsap"
    xmlns:prx="urn:sap.com:proxy:NWC:/1SAI/TXS5702B25F6DD7952A79BA:700:2010/02/19"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">                                                                                                           <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                                                         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                                                                   <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <!--    <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->                                                                          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="RequisitionRealTimeRevertBudgetExportRequest">
        <n0:ARBCIG_PURREQ_DELETE>
            <ARIBA_REQ_NO>
                <xsl:value-of select="Requisition_BudgetReqExportWithdrawDenyDetails_Item/item/UniqueName"/>
            </ARIBA_REQ_NO>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
            <PRHEADER>
                <PREQ_NO>
                    <xsl:value-of select="Requisition_BudgetReqExportWithdrawDenyDetails_Item/item/ERPRequisitionID"/>
                </PREQ_NO>
            </PRHEADER>
            <PRITEM>
                <xsl:for-each
                    select="Requisition_BudgetReqExportWithdrawDenyDetails_Item/item/LineItems/item[string-length(normalize-space(ERPLineItemNumber)) > 0 ]">           <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <item>
                        <PREQ_ITEM>
                            <xsl:value-of select="ERPLineItemNumber"/>
                        </PREQ_ITEM>
                        <DELETE_IND>
                            <xsl:value-of select="'X'"/>
                        </DELETE_IND>
                    </item>
                </xsl:for-each>
            </PRITEM>
        </n0:ARBCIG_PURREQ_DELETE>
    </xsl:template>
</xsl:stylesheet>
