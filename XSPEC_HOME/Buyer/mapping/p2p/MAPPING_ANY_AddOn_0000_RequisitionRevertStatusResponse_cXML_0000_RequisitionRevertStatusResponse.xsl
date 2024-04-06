<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="urn:sap-com:document:sap:rfc:functions" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="urn:sap-com:document:sap:soap:functions:mc-style" exclude-result-prefixes="#all">         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:param name="p2pTimezone"/>                                                                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="n0:ARBCIG_PURREQ_DELETE.Response">
        <RequisitionRealTimeRevertBudgetExportReply>
            <xsl:attribute name="partition">
                <xsl:value-of select="PARTITION"/>
            </xsl:attribute>
            <xsl:attribute name="variant">
                <xsl:value-of select="VARIANT"/>
            </xsl:attribute>
            <!--            Set an error flag if any of the item contanis Error or Abort type-->
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
                            <RealTimeBudgetResponse>
                                <Approvable>
                                    <UniqueName>
                                        <xsl:value-of select="ARIBA_REQ_NO"/>
                                    </UniqueName>
                                </Approvable>
                                <LogMessages>
                                    <xsl:for-each select="RETURN/item[TYPE != 'E' or TYPE != 'A'][1]">
                                        <item>
                                            <Message>
                                                <xsl:value-of select="MESSAGE"/>
                                            </Message>
                                            <Type>
                                                <xsl:value-of select="TYPE"/>                                            
                                            </Type>
                                        </item>
                                    </xsl:for-each>
                                </LogMessages>
                                <UniqueName>
                                    <xsl:value-of select="ARIBA_REQ_NO"/>
                                </UniqueName>
                            </RealTimeBudgetResponse>
                            <UniqueName>
                                <xsl:value-of select="ARIBA_REQ_NO"/>
                            </UniqueName>
                        </item>
                    </Requisition_RequisitionRealTimeBudgetResponseImport_Item>
                </xsl:when>
                <xsl:otherwise>
                    <RequisitionError_RequisitionErrorImport_Item>
                        <xsl:for-each select="RETURN/item[TYPE = 'E' or TYPE = 'A']">
                            <item>
                                <Date>
                                    <xsl:variable name="v_date" select="string(current-dateTime())"/>
                                    <xsl:value-of select="concat(substring($v_date, 1, 10), 'T', substring($v_date, 12, 8), $p2pTimezone)"/>
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
                                    <xsl:value-of select="../../ARIBA_REQ_NO"/>
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
        </RequisitionRealTimeRevertBudgetExportReply>
    </xsl:template>
</xsl:stylesheet>
