<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"                                                                       
    version="2.0" xmlns:ns0="urn:Ariba:Buyer:vsap" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xmlns:prx="urn:sap.com:proxy:NWC:/1SAI/TXS64C2D49B5B68986CABB0:700:2010/02/19">                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="/ns0:AggregatedRequisitionRevertBudgetAsyncExportRequest" >
        <n0:ARBCIG_BATCH_PURREQ_DELETE>
            <ARIBA_REQ_NO>
                <xsl:value-of select="ns0:Requisition_AggregatedRequisitionRevertBudgetAsyncExportDetails_Item/ns0:item/ns0:UniqueName"/>
            </ARIBA_REQ_NO>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
            <PRITEM>
                <xsl:for-each select="ns0:Requisition_AggregatedRequisitionRevertBudgetAsyncExportDetails_Item/ns0:item/ns0:LineItems/ns0:item">
                    <item>
                        <PREQ_NO>
                            <xsl:value-of select="ns0:AggregationWrapper/ns0:Requisition/ns0:ERPRequisitionID"/>
                        </PREQ_NO>
                        <PREQ_ITEM>
                            <xsl:value-of select="ns0:AggregationWrapper/ns0:ReqLineItem/ns0:ERPLineItemNumber"/>
                        </PREQ_ITEM>
                        <ARIBA_ITEM>
                            <xsl:value-of select="ns0:NumberInCollection"/>
                        </ARIBA_ITEM>
                    </item>
                </xsl:for-each>
            </PRITEM>
        </n0:ARBCIG_BATCH_PURREQ_DELETE>
    </xsl:template>
</xsl:stylesheet>
