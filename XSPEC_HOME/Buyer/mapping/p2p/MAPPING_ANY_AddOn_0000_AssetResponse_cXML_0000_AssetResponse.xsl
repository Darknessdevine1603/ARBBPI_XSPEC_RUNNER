<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xmlns:urn="urn:Ariba:Buyer:vsap"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" omit-xml-declaration="yes"/> 
    <!--    Common XSLT for Asset  response-->
    <xsl:param name="p2pTarget"/>
    <xsl:param name="p2pTimezone"/>
    <xsl:template match="n0:ARBCIG_ASSET_RESPONSE">
        <urn:AssetRequisitionAsyncImportPullRequest>
            <xsl:if test="exists(BAPI1022_1/item)">
                <urn:Requisition_ProcessReqExtAssetDataResponseImport_Item>
                    <urn:item>
                        <urn:LineItems>
                            <xsl:for-each select="BAPI1022_1/item">
                                <urn:item>
                                    <urn:Accountings>
                                        <urn:SplitAccountings>
                                            <urn:item>
                                                <urn:Asset>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="COMP_CODE"/>
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:SubNumber>
                                                  <xsl:value-of select="ASSETSUBNO"/>
                                                  </urn:SubNumber>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="ASSETMAINO"/>
                                                  </urn:UniqueName>
                                                </urn:Asset>
                                                <urn:NumberInCollection>
                                                  <xsl:value-of select="ARIBA_SERIAL_NO"/>
                                                </urn:NumberInCollection>

                                            </urn:item>

                                        </urn:SplitAccountings>
                                    </urn:Accountings>
                                    <urn:NumberInCollection>
                                        <xsl:value-of select="ARIBA_ITEM"/>
                                    </urn:NumberInCollection>
                                </urn:item>
                            </xsl:for-each>
                        </urn:LineItems>
                        <urn:UniqueName>
                            <xsl:value-of select="ARIBA_REQ_NO"/>
                        </urn:UniqueName>
                    </urn:item>
                </urn:Requisition_ProcessReqExtAssetDataResponseImport_Item>
            </xsl:if>


            <xsl:if test="exists(RETURN/item)">

                <urn:ValidationError_ValidateErrorImport_Item>
                    <urn:item>
                        <urn:Date>
                            <xsl:value-of select="current-dateTime()"/>
                        </urn:Date>
                        <urn:ErrorDetails>
                            <xsl:for-each select="RETURN/item">
                                <urn:item>
                                    <urn:ErrorCategory>
                                        <xsl:value-of select="1"/>
                                    </urn:ErrorCategory>
                                    <urn:ErrorCode>
                                        <xsl:value-of select="NUMBER"/>
                                    </urn:ErrorCode>
                                    <urn:ErrorMessage>
                                        <xsl:value-of select="MESSAGE"/>
                                    </urn:ErrorMessage>
                                    <urn:ErrorType>
                                        <xsl:value-of select="0"/>
                                    </urn:ErrorType>
                                    <urn:LineNumber>
                                        <xsl:value-of select="ARIBA_ITEM"/>
                                    </urn:LineNumber>
                                    <xsl:if test="ARIBA_SERIAL_NO">
                                        <urn:SplitNumber>
                                            <xsl:value-of select="number(ARIBA_SERIAL_NO)"/>
                                        </urn:SplitNumber>
                                    </xsl:if>
                                </urn:item>
                            </xsl:for-each>
                        </urn:ErrorDetails>
                        <urn:Id>
                            <xsl:value-of select="ARIBA_REQ_NO"/>
                        </urn:Id>
                    </urn:item>
                </urn:ValidationError_ValidateErrorImport_Item>
            </xsl:if>
        </urn:AssetRequisitionAsyncImportPullRequest>
    </xsl:template>
</xsl:stylesheet>
