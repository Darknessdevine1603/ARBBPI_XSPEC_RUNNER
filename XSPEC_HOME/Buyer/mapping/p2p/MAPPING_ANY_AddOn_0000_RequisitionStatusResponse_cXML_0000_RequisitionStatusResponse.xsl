<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xmlns:tns="urn:sap-com:document:sap:soap:functions:mc-style"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="2.0">
    <!--    Common XSLT for BudgetCheckResponse and PR response-->
    <xsl:param name="p2pTarget"/>
    <xsl:param name="p2pTimezone"/>
    <xsl:variable name="v_Revert" select="'RequisitionRevertBudgetToEarlierVersionExportRequest'"/>
    <xsl:template match="n0:ARBCIG_PURREQ.Response">
        <xsl:choose>
            <xsl:when test="SOURCE = 'RequisitionRealTimeBudgetExportRequest'">
                <RequisitionRealTimeBudgetExportReply>
                    <xsl:call-template name="Requisition"/>
                </RequisitionRealTimeBudgetExportReply>
            </xsl:when>
            <xsl:when test="SOURCE = 'RequisitionBudgetCheckExportRequest'">
                <RequisitionBudgetCheckExportReply>
                    <xsl:call-template name="Requisition"/>
                </RequisitionBudgetCheckExportReply>
            </xsl:when>
            <xsl:when test="SOURCE = 'RequisitionRevertBudgetToEarlierVersionExportRequest'">
                <RequisitionRevertBudgetToEarlierVersionExportReply>
                    <xsl:call-template name="Requisition"/>
                </RequisitionRevertBudgetToEarlierVersionExportReply>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Requisition">        
        <xsl:attribute name="partition">
            <xsl:value-of select="PARTITION"/>
        </xsl:attribute>
        <xsl:attribute name="variant">
            <xsl:value-of select="VARIANT"/>
        </xsl:attribute>
        <xsl:variable name="v_err_flag">
            <xsl:if test="RETURN/item/TYPE = 'E' or RETURN/item/TYPE = 'A'">
                <xsl:value-of select="'X'"/>
            </xsl:if>
        </xsl:variable>
        <!--            Check if error exist-->
        <xsl:choose>
            <xsl:when test="$v_err_flag != 'X'">
                <Requisition_RequisitionRealTimeBudgetResponseImport_Item>
                    <item>
                        <ERPRequisitionID>
                            <xsl:value-of select="PRHEADERRES/PREQ_NO"/>
                        </ERPRequisitionID>
                        <LineItems>
                            <!--                Apply GenerateResItem UDF for BudgetCheck-->
                            <xsl:for-each select="PRITEM/item">
                                <xsl:variable name="v_item" select="ARIBA_ITEM"/>
                                <item>
                                    <Accountings>
                                        <SplitAccountings>
                                            <xsl:variable name="bp">
                                                <xsl:value-of select="BUDGET_PERIOD"/>
                                            </xsl:variable>
                                            <!--                Apply GenerateResItem UDF for BudgetCheck-->
                                            <xsl:for-each
                                                select="/n0:ARBCIG_PURREQ.Response/PRACCOUNT/item[ARIBA_ITEM = $v_item]">
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
                                                            <xsl:value-of select="CMMT_ITEM_LONG"/>
                                                        </CustomCommitmentItem>
                                                        <CustomEarmarkedFundsDocument>
                                                            <xsl:attribute name="name">
                                                                <xsl:value-of select="'EarmarkedFundsDocument'"/>
                                                            </xsl:attribute>
                                                            <UniqueName>
                                                                <xsl:value-of select="FUNDS_RES"/>
                                                            </UniqueName>
                                                            <xsl:value-of select="FUNDS_RES"/>
                                                        </CustomEarmarkedFundsDocument>
                                                        <CustomEarmarkedFundsLineItem>
                                                            <xsl:attribute name="name">
                                                                <xsl:value-of select="'EarmarkedFundsItem'"/>
                                                            </xsl:attribute>
                                                            <UniqueName>
                                                                <xsl:choose>
                                                                    <!-- <IG-32371 : correction of condition &lt; TO = >-->
                                                                    <xsl:when test="string-length(normalize-space(RES_DOC)) = 0">
                                                                    <!-- </IG-32371 : correction of condition &lt; TO = >-->     
                                                                        <xsl:value-of select="RES_ITEM"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <!-- <IG-32371 : correction of typo Error RES_ITEm to RES_ITEM >-->
                                                                        <xsl:value-of
                                                                            select="concat(RES_DOC, ':', RES_ITEM)"/>
                                                                        <!--</IG-32371 : correction of typo Error RES_ITEm to RES_ITEM>-->
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </UniqueName>
                                                            <xsl:value-of select="RES_ITEM"/>
                                                        </CustomEarmarkedFundsLineItem>
                                                        <CustomFMArea>
                                                            <xsl:attribute name="name">
                                                                <xsl:value-of select="'FMArea'"/>
                                                            </xsl:attribute>
                                                            <UniqueName>
                                                                <xsl:value-of select="FM_AREA"/>
                                                            </UniqueName>
                                                            <xsl:value-of select="FM_AREA"/>
                                                        </CustomFMArea>
                                                        <CustomFunctionalArea>
                                                            <xsl:attribute name="name">
                                                                <xsl:value-of select="'FunctionalArea'"/>
                                                            </xsl:attribute>
                                                            <UniqueName>
                                                                <xsl:value-of select="FUNC_AREA_LONG"/>
                                                            </UniqueName>
                                                            <xsl:value-of select="FUNC_AREA_LONG"/>
                                                        </CustomFunctionalArea>
                                                        <CustomFund>
                                                            <xsl:attribute name="name">
                                                                <xsl:value-of select="'Fund'"/>
                                                            </xsl:attribute>
                                                            <UniqueName>
                                                                <xsl:value-of select="FUND"/>
                                                            </UniqueName>
                                                            <xsl:value-of select="FUND"/>
                                                        </CustomFund>
                                                        <CustomFundsCenter>
                                                            <xsl:attribute name="name">
                                                                <xsl:value-of select="'FundsCenter'"/>
                                                            </xsl:attribute>
                                                            <UniqueName>
                                                                <xsl:value-of select="FUNDS_CTR"/>
                                                            </UniqueName>
                                                            <xsl:value-of select="FUNDS_CTR"/>
                                                        </CustomFundsCenter>
                                                        <CustomGrant>
                                                            <xsl:attribute name="name">
                                                                <xsl:value-of select="'Grant'"/>
                                                            </xsl:attribute>
                                                            <UniqueName>
                                                                <xsl:value-of select="GRANT_NBR"/>
                                                            </UniqueName>
                                                            <xsl:value-of select="GRANT_NBR"/>
                                                        </CustomGrant>
                                                    </custom>
                                                </item>
                                            </xsl:for-each>
                                        </SplitAccountings>
                                    </Accountings>
                                    <ERPLineItemNumber>                                        
                                        <xsl:if test="/n0:ARBCIG_PURREQ.Response/SOURCE != 'RequisitionBudgetCheckExportRequest'"> 
                                            <xsl:value-of select="PREQ_ITEM"/>
                                        </xsl:if>
                                    </ERPLineItemNumber>
                                    <NumberInCollection>
                                        <xsl:value-of select="ARIBA_ITEM"/>
                                    </NumberInCollection>
                                    <OriginatingSystemLineNumber>
                                        <xsl:value-of select="OSLN"/>
                                    </OriginatingSystemLineNumber>
                                </item>
                            </xsl:for-each>
                        </LineItems>
                        <RealTimeBudgetResponse>
                            <Approvable>
                                <UniqueName>
                                    <xsl:choose>
                                        <xsl:when test="SOURCE = $v_Revert">
                                            <xsl:value-of select="ARIBA_REQ_NV"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="ARIBA_REQ_NO"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </UniqueName>
                            </Approvable>
                            <xsl:if test="RETURN">
                                <LogMessages>
                                    <item>
                                        <Message>
                                            <xsl:value-of select="RETURN/item/MESSAGE"/>
                                        </Message>
                                        <Type>
                                            <xsl:value-of select="RETURN/item/Type"/>
                                        </Type>
                                    </item>
                                </LogMessages>
                            </xsl:if>
                            <!--Date in the format YYYYMMDDHHMMSS-->
                            <UniqueName>
                                <xsl:choose>                                 
                                    <xsl:when test="string-length(ARIBA_REQ_TS) &gt; 0"><!-- IG-18070 -->                                        
                                        <xsl:value-of select="ARIBA_REQ_TS"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][H01][m01][s01][f01]')"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </UniqueName>
                        </RealTimeBudgetResponse>
                        <UniqueName>
                            <xsl:choose>
                                <xsl:when test="SOURCE = $v_Revert">
                                    <xsl:value-of select="ARIBA_REQ_NV"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ARIBA_REQ_NO"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </UniqueName>
                    </item>
                </Requisition_RequisitionRealTimeBudgetResponseImport_Item>
            </xsl:when>
            <xsl:otherwise>
                <RequisitionError_RequisitionErrorImport_Item>
                    <xsl:for-each select="RETURN/item[TYPE = 'E' or TYPE = 'A']">
                        <item>
                            <Date>
                                <xsl:value-of select="current-dateTime()"/>
                            </Date>
                            <ErrorClient>
                                <xsl:value-of select="SYSTEM"/>
                            </ErrorClient>
                            <ErrorMessage>
                                <xsl:choose>
                                    <xsl:when test="ID = 'BP' and TYPE = 'E'">
                                        <xsl:value-of select="concat(MESSAGE, ' by ', MESSAGE_V4)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="MESSAGE"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ErrorMessage>
                            <ErrorNumber>
                                <xsl:value-of select="NUMBER"/>
                            </ErrorNumber>
                            <ErrorSAPField>
                                <xsl:value-of select="'SAP'"/>
                            </ErrorSAPField>
                            <ErrorSAPId>
                                <xsl:value-of select="'SAP'"/>
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
                                <xsl:choose>
                                    <xsl:when test="SOURCE = $v_Revert">
                                        <xsl:value-of select="../../ARIBA_REQ_NV"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="../../ARIBA_REQ_NO"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </Id>
                            <NumInSet>
                                <xsl:value-of select="position()"/>
                            </NumInSet>
                            <Type>
                                <xsl:value-of select="TYPE"/>
                            </Type>
                        </item>
                    </xsl:for-each>
                </RequisitionError_RequisitionErrorImport_Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
