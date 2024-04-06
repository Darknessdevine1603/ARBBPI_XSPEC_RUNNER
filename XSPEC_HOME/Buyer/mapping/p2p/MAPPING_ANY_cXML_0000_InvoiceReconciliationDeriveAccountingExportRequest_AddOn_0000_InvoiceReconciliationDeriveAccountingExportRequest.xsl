<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="urn:Ariba:Buyer:vsap" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <n0:ARBCIG_DERIVATION>
            <xsl:variable name="v_date"
                select="/InvoiceReconciliationDeriveAccountingExportRequest/InvoiceReconciliation_BudgetIRExportHeaderDetails_Item/item/custom/CustomDate[@name='FMPostingDate']"/>
            <ARIBA_DOC_NO>
                <xsl:value-of
                    select="/InvoiceReconciliationDeriveAccountingExportRequest/InvoiceReconciliation_BudgetIRExportHeaderDetails_Item/item/UniqueName"
                />
            </ARIBA_DOC_NO>
            <PARTITION>
                <xsl:value-of
                    select="/InvoiceReconciliationDeriveAccountingExportRequest/@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="/InvoiceReconciliationDeriveAccountingExportRequest/@variant"
                />
            </VARIANT>
            <SOURCE>
                <xsl:value-of select="'InvoiceReconciliationDeriveAccountingExportRequest'"/>
            </SOURCE>
            <CHECK_CODINGBLOCK>
                <xsl:for-each
                    select="/InvoiceReconciliationDeriveAccountingExportRequest/InvoiceReconciliation_BudgetIRExportAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item">
                    <item>
                        <ARIBA_ITEM>
                            <xsl:value-of select="LineItem/NumberInCollection"/>
                        </ARIBA_ITEM>
                        <ARIBA_SERIAL_NO>
                            <xsl:value-of select="NumberInCollection"/>
                        </ARIBA_SERIAL_NO>
                        <PSTNG_DATE>
                            <xsl:value-of select="substring($v_date, 1, 10)"/>
                        </PSTNG_DATE>
                        <!-- Have update-->
                        <COMP_CODE>
                            <xsl:value-of
                                select="../../../../../../../InvoiceReconciliation_BudgetIRExportHeaderDetails_Item/item/CompanyCode[1]/UniqueName[1]"
                            />
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
                            <xsl:value-of
                                select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 12)"
                            />
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
