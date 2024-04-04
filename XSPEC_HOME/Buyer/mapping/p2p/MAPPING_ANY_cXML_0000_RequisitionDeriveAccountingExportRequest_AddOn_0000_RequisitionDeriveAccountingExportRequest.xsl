<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="urn:Ariba:Buyer:vsap" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">                                                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                                                            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <!--    <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->                                                                   <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="/">
        <n0:ARBCIG_DERIVATION>
            <!--Start of Defect fix IG-36374-->
            <xsl:variable name="v_date">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(/RequisitionDeriveAccountingExportRequest/Requisition_BudgetReqExportHeaderDetails_Item/item/custom/CustomDate[@name = 'FMPostingDate'])) > 0">
                        <xsl:value-of select="/RequisitionDeriveAccountingExportRequest/Requisition_BudgetReqExportHeaderDetails_Item/item/custom/CustomDate[@name = 'FMPostingDate']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="/RequisitionDeriveAccountingExportRequest/Requisition_BudgetReqExportHeaderDetails_Item/item/custom/CustomDate[1]"/>
                    </xsl:otherwise>
                </xsl:choose>    
            </xsl:variable>
            <!--End of Defect fix IG-36374-->
            <ARIBA_DOC_NO>
                <xsl:value-of select="/RequisitionDeriveAccountingExportRequest/Requisition_BudgetReqExportHeaderDetails_Item/item/UniqueName"/>
            </ARIBA_DOC_NO>
            <PARTITION>
                <xsl:value-of select="/RequisitionDeriveAccountingExportRequest/@partition"/>
            </PARTITION>
            <SOURCE>
                <xsl:value-of select="'RequisitionDeriveAccountingExportRequest'"/>
            </SOURCE>
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <VARIANT>
                <xsl:value-of select="/RequisitionDeriveAccountingExportRequest/@variant"/>
            </VARIANT>
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <CHECK_CODINGBLOCK>
                <xsl:for-each
                    select="/RequisitionDeriveAccountingExportRequest/Requisition_FMDeriveReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item">
                    <item>
                        <ARIBA_ITEM>
                            <xsl:value-of select="LineItem/NumberInCollection"/>
                        </ARIBA_ITEM>
                        <ARIBA_SERIAL_NO>
                            <xsl:value-of select="NumberInCollection"/>
                        </ARIBA_SERIAL_NO>
                        <PSTNG_DATE>
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->    
                        <xsl:if test="string-length(normalize-space($v_date)) > 0">
                            <xsl:choose>
                                <xsl:when test="contains($v_date,'-')">
                                    <xsl:value-of select="substring($v_date, 1, 10)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat(substring($v_date, 1, 4), '-', substring($v_date, 5, 2), '-', substring($v_date, 7, 2))"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output --> 
                        </PSTNG_DATE> 
                        <COMP_CODE>
                            <xsl:value-of select="../../../../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/CompanyCode/UniqueName"/> 
                        </COMP_CODE>
                        <GL_ACCOUNT>
                            <xsl:value-of select="GeneralLedger/UniqueName"/>
                        </GL_ACCOUNT>
                        <COSTCENTER>
                            <xsl:value-of select="CostCenter/UniqueName"/>
                        </COSTCENTER>
                        <ORDERID>
                            <xsl:value-of select="InternalOrder/UniqueName"/>
                        </ORDERID>
                        <WBS_ELEMENT>
                            <xsl:value-of select="WBSElement/UniqueName"/>
                        </WBS_ELEMENT>
                        <ASSETMAINNO>
                            <xsl:value-of select="Asset/UniqueName"/>
                        </ASSETMAINNO>
                        <ASSETSUBNO>
                            <xsl:value-of select="Asset/SubNumber"/>
                        </ASSETSUBNO>
                        <FM_AREA>
                            <xsl:value-of select="custom/CustomFMArea/UniqueName"/>
                        </FM_AREA>
                        <FUNDS_CTR>
                            <xsl:value-of select="custom/CustomFundsCenter/UniqueName"/>
                        </FUNDS_CTR>
                        <FUND>
                            <xsl:value-of select="custom/CustomFund/UniqueName"/>
                        </FUND>
                        <FUNDS_RES>
                            <xsl:value-of select="custom/CustomEarmarkedFundsDocument/UniqueName"/>
                        </FUNDS_RES>
                        <RES_ITEM>
                            <xsl:value-of select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName,12)"/>
                        </RES_ITEM>
                        <FUNC_AREA_LONG>
                            <xsl:value-of select="custom/CustomFunctionalArea/UniqueName"/>
                        </FUNC_AREA_LONG>
                        <GRANT_NBR>
                            <xsl:value-of select="custom/CustomGrant/UniqueName"/>
                        </GRANT_NBR>
                        <CMMT_ITEM_LONG>
                            <xsl:value-of select="custom/CustomCommitmentItem/UniqueName"/>
                        </CMMT_ITEM_LONG>
                        <ARIBA_BUDGET_PERIOD>
                            <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
                        </ARIBA_BUDGET_PERIOD>
                    </item>
                </xsl:for-each>
            </CHECK_CODINGBLOCK>
            <ACCOUNT_ASSIGNMENT_TYPES/>
            <RETURN/>
        </n0:ARBCIG_DERIVATION>
    </xsl:template>
</xsl:stylesheet>
