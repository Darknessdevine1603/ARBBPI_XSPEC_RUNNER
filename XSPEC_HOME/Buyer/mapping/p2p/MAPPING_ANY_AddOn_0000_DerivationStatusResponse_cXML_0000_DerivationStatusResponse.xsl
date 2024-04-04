<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="urn:sap-com:document:sap:rfc:functions" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="urn:sap-com:document:sap:soap:functions:mc-style">
    <xsl:param name="p2pTarget"/>
    <xsl:param name="p2pTimezone"/>
    <xsl:template match="n0:ARBCIG_DERIVATION.Response">
        <xsl:choose>
            <xsl:when test="SOURCE = 'RequisitionDeriveAccountingExportRequest'">
                <RequisitionDeriveAccountingExportReply>
                    <xsl:call-template name="RequisitionDerive"/>
                </RequisitionDeriveAccountingExportReply>
            </xsl:when>
            <xsl:when test="SOURCE = 'InvoiceReconciliationDeriveAccountingExportRequest'">
                <InvoiceReconciliationDeriveAccountingExportReply>
                    <xsl:call-template name="InvoiceReconciliationDerive"/>
                </InvoiceReconciliationDeriveAccountingExportReply>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="RequisitionDerive">
        <xsl:attribute name="partition">
            <xsl:value-of select="PARTITION"/>
        </xsl:attribute>
        <xsl:attribute name="variant">
            <xsl:value-of select="VARIANT"/>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="not(RETURN/item)">
                <Requisition_RequisitionRealTimeBudgetResponseImport_Item>
                    <item>
                        <LineItems>
                            <xsl:for-each select="RESPONSE_IMPORT_ITEM/item">
                                <item>
                                    <Accountings>
                                        <SplitAccountings>
                                            <xsl:variable name="bp">
                                                <xsl:value-of select="ARIBA_BUDGET_PERIOD"/>
                                            </xsl:variable>
                                            <!--                Apply GenerateResItem UDF for BudgetCheck-->
                                            <xsl:for-each select="ITEM/item">
                                                <item>
                                                  <NumberInCollection>
                                                  <xsl:value-of select="ARIBA_SERIAL_NO"/>
                                                  </NumberInCollection>
                                                  <custom>
                                                  <CustomBudgetPeriod>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'BudgetPeriod'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="$bp"/>
                                                  </UniqueName>
                                                  <xsl:value-of select="$bp"/>
                                                  </CustomBudgetPeriod>
                                                  <CustomCommitmentItem>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'CommitmentItem'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="CMMT_ITEM_LONG"/>
                                                  </UniqueName>
                                                  </CustomCommitmentItem>
                                                  <CustomEarmarkedFundsDocument>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'EarmarkedFundsDocument'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUNDS_RES"/>
                                                  </UniqueName>
                                                  </CustomEarmarkedFundsDocument>
                                                  <CustomEarmarkedFundsLineItem>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'EarmarkedFundsItem'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:choose>
                                                  <xsl:when test="string-length(FUNDS_RES) eq 0">
                                                  <xsl:value-of select="RES_ITEM"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="concat(FUNDS_RES, ':', RES_ITEM)"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </UniqueName>
                                                  </CustomEarmarkedFundsLineItem>
                                                  <CustomFMArea>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'FMArea'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FM_AREA"/>
                                                  </UniqueName>
                                                  </CustomFMArea>
                                                  <CustomFunctionalArea>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'FunctionalArea'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUNC_AREA_LONG"/>
                                                  </UniqueName>
                                                  </CustomFunctionalArea>
                                                  <CustomFund>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'Fund'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUND"/>
                                                  </UniqueName>
                                                  </CustomFund>
                                                  <CustomFundsCenter>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'FundsCenter'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUNDS_CTR"/>
                                                  </UniqueName>
                                                  </CustomFundsCenter>
                                                  <CustomGrant>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'Grant'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="GRANT_NBR"/>
                                                  </UniqueName>
                                                  </CustomGrant>
                                                  </custom>
                                                </item>
                                            </xsl:for-each>
                                        </SplitAccountings>
                                    </Accountings>
                                    <ERPLineItemNumber/>
                                    <NumberInCollection>
                                        <xsl:value-of select="ARIBA_ITEM"/>
                                    </NumberInCollection>
                                </item>
                            </xsl:for-each>
                        </LineItems>
                        <RealTimeBudgetResponse>
                            <Approvable>
                                <UniqueName>
                                    <xsl:value-of select="ARIBA_DOC_NO"/>
                                </UniqueName>
                            </Approvable>
                            <UniqueName>
                                <xsl:value-of select="ARIBA_DOC_NO"/>
                            </UniqueName>
                        </RealTimeBudgetResponse>
                        <UniqueName>
                            <xsl:value-of select="ARIBA_DOC_NO"/>
                        </UniqueName>
                    </item>
                </Requisition_RequisitionRealTimeBudgetResponseImport_Item>
            </xsl:when>
            <xsl:otherwise>
                <AccountingError_SplitAccountingErrorImport_Item>
                    <xsl:for-each select="RETURN/item">
                        <Item>
                            <Date>
                                <xsl:variable name="v_date" select="string(current-dateTime())"/>
                                <xsl:value-of
                                    select="concat(substring($v_date, 1, 10), 'T', substring($v_date, 12, 8), $p2pTimezone)"
                                />
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
                                <xsl:value-of select="'SAP'"/>
                            </ErrorSAPField>
                            <ErrorSAPId>
                                <xsl:value-of select="ID"/>
                            </ErrorSAPId>
                            <ErrorSAPModule>
                                <xsl:value-of select="'SAP'"/>
                            </ErrorSAPModule>
                            <ErrorSAPScreen>
                                <xsl:value-of select="'SAP'"/>
                            </ErrorSAPScreen>
                            <ErrorSystem>
                                <xsl:value-of select="SYSTEM"/>
                            </ErrorSystem>
                            <Id>
                                <xsl:value-of select="../../ARIBA_DOC_NO"/>
                            </Id>
                            <LineNumber>
                                <xsl:value-of select="format-number(ARIBA_ITEM, '#')"/>
                            </LineNumber>
                            <SplitAccNumber>
                                <xsl:value-of select="ARIBA_SERIAL_NO"/>
                            </SplitAccNumber>
                            <Type>
                                <xsl:value-of select="TYPE"/>
                            </Type>
                        </Item>
                    </xsl:for-each>
                </AccountingError_SplitAccountingErrorImport_Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="InvoiceReconciliationDerive">
        <xsl:attribute name="partition">
            <xsl:value-of select="PARTITION"/>
        </xsl:attribute>
        <xsl:attribute name="variant">
            <xsl:value-of select="VARIANT"/>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="not(RETURN/item)">
                <InvoiceReconciliation_IRRealTimeBudgetResponseImport_Item>
                    <item>
                        <LineItems>
                            <xsl:for-each select="RESPONSE_IMPORT_ITEM/item">
                                <item>
                                    <Accountings>
                                        <SplitAccountings>
                                            <xsl:for-each select="ITEM/item">
                                                <item>
                                                  <xsl:variable name="bp">
                                                  <xsl:value-of select="ARIBA_BUDGET_PERIOD"/>
                                                  </xsl:variable>
                                                  <NumberInCollection>
                                                  <xsl:value-of select="ARIBA_SERIAL_NO"/>
                                                  </NumberInCollection>
                                                  <custom>
                                                  <CustomBudgetPeriod>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'BudgetPeriod'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="$bp"/>
                                                  </UniqueName>
                                                  <xsl:value-of select="$bp"/>
                                                  </CustomBudgetPeriod>
                                                  <CustomCommitmentItem>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'CommitmentItem'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="CMMT_ITEM_LONG"/>
                                                  </UniqueName>
                                                  </CustomCommitmentItem>
                                                  <CustomEarmarkedFundsDocument>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'EarmarkedFundsDocument'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUNDS_RES"/>
                                                  </UniqueName>
                                                  </CustomEarmarkedFundsDocument>
                                                  <CustomEarmarkedFundsLineItem>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'EarmarkedFundsItem'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:choose>
                                                  <xsl:when test="string-length(FUNDS_RES) eq 0">
                                                  <xsl:value-of select="RES_ITEM"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="concat(FUNDS_RES, ':', RES_ITEM)"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </UniqueName>
                                                  </CustomEarmarkedFundsLineItem>
                                                  <CustomFMArea>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'FMArea'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FM_AREA"/>
                                                  </UniqueName>
                                                  </CustomFMArea>
                                                  <CustomFunctionalArea>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'FunctionalArea'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUNC_AREA_LONG"/>
                                                  </UniqueName>
                                                  </CustomFunctionalArea>
                                                  <CustomFund>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'Fund'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUND"/>
                                                  </UniqueName>
                                                  </CustomFund>
                                                  <CustomFundsCenter>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'FundsCenter'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="FUNDS_CTR"/>
                                                  </UniqueName>
                                                  </CustomFundsCenter>
                                                  <CustomGrant>
                                                  <xsl:attribute name="name">
                                                      <xsl:value-of select="'Grant'"/>
                                                  </xsl:attribute>
                                                  <UniqueName>
                                                  <xsl:value-of select="GRANT_NBR"/>
                                                  </UniqueName>
                                                  </CustomGrant>
                                                  </custom>
                                                </item>
                                            </xsl:for-each>
                                        </SplitAccountings>
                                    </Accountings>
                                    <ERPLineItemNumber/>
                                    <NumberInCollection>
                                        <xsl:value-of select="ARIBA_ITEM"/>
                                    </NumberInCollection>
                                </item>
                            </xsl:for-each>
                        </LineItems>
                        <RealTimeBudgetResponse>
                            <Approvable>
                                <UniqueName>
                                    <xsl:value-of select="ARIBA_DOC_NO"/>
                                </UniqueName>
                            </Approvable>
                            <UniqueName>
                                <xsl:value-of select="ARIBA_DOC_NO"/>
                            </UniqueName>
                        </RealTimeBudgetResponse>
                        <UniqueName>
                            <xsl:value-of select="ARIBA_DOC_NO"/>
                        </UniqueName>
                    </item>
                </InvoiceReconciliation_IRRealTimeBudgetResponseImport_Item>
            </xsl:when>
            <xsl:otherwise>
                <AccountingError_SplitAccountingErrorImport_Item>
                    <xsl:for-each select="RETURN/item">
                        <Item>
                            <Date>
                                <xsl:variable name="v_date" select="string(current-dateTime())"/>
                                <xsl:value-of
                                    select="concat(substring($v_date, 1, 10), 'T', substring($v_date, 12, 8), $p2pTimezone)"
                                />
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
                                <xsl:value-of select="'SAP'"/>
                            </ErrorSAPField>
                            <ErrorSAPId>
                                <xsl:value-of select="ID"/>
                            </ErrorSAPId>
                            <ErrorSAPModule>
                                <xsl:value-of select="'SAP'"/>
                            </ErrorSAPModule>
                            <ErrorSAPScreen>
                                <xsl:value-of select="'SAP'"/>
                            </ErrorSAPScreen>
                            <ErrorSystem>
                                <xsl:value-of select="SYSTEM"/>
                            </ErrorSystem>
                            <Id>
                                <xsl:value-of select="../../ARIBA_DOC_NO"/>
                            </Id>
                            <LineNumber>
                                <xsl:value-of select="format-number(ARIBA_ITEM, '#')"/>
                            </LineNumber>
                            <SplitAccNumber>
                                <xsl:value-of select="ARIBA_SERIAL_NO"/>
                            </SplitAccNumber>
                            <Type>
                                <xsl:value-of select="TYPE"/>
                            </Type>
                        </Item>
                    </xsl:for-each>
                </AccountingError_SplitAccountingErrorImport_Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
