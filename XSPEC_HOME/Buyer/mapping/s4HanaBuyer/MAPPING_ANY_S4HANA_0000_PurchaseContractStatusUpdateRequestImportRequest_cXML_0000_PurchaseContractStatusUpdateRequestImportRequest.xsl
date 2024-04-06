<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/Procurement" xmlns:urn="urn:Ariba:Sourcing:vsap"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--    <xsl:include href="Format_Any_Addon_Common.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
    <xsl:template match="n0:PurchaseContractUpdateNotification">
        <urn:PurchaseContractStatusUpdateRequestImportRequest>
            <urn:WSPurchaseContractStatusUpdateRequestImportInputBean_Item>
                <urn:item>
                    <urn:MessageHeader>
                        <urn:ANID/>
                        <urn:BusinessSystemID>
                            <xsl:value-of select="MessageHeader/SenderBusinessSystemID"/>
                        </urn:BusinessSystemID>
                        <urn:PayloadID>
                            <xsl:value-of select="MessageHeader/ID"/>
                        </urn:PayloadID>
                        <urn:RealmID>
                            <xsl:value-of select="MessageHeader/RecipientBusinessSystemID"/>
                        </urn:RealmID>
                    </urn:MessageHeader>
                    <urn:ContractStatusUpdateRequest>
                        <urn:ContractStatus>
                            <urn:ContractDate>
                                <xsl:value-of select="MessageHeader/CreationDateTime"/>
                            </urn:ContractDate>
                            <urn:ContractID>
                                <xsl:value-of select="ContractStatus/DocumentReferenceID"/>
                            </urn:ContractID>
                            <urn:Reference>
                                <urn:Domain>SAPAgreementId</urn:Domain>
                                <urn:Identifier>
                                    <xsl:value-of select="ContractStatus/ContractID"/>
                                </urn:Identifier>
                            </urn:Reference>
                            <urn:ExternalApprovalStatus>
                                <xsl:value-of select="ContractStatus/ApprovalStatus"/>
                            </urn:ExternalApprovalStatus>
                            <urn:Operation>update</urn:Operation>
                        </urn:ContractStatus>
                        <xsl:choose>
                            <xsl:when test="./ItemStatus != ''">
                                <urn:ContractItemStatus>
                                    <xsl:for-each select="./ItemStatus/ContractItemStatusList">
                                        <urn:item>
                                            <urn:Reference>
                                                <urn:Domain>SAPLineNumber</urn:Domain>
                                                <urn:Identifier>
                                                  <xsl:value-of select="ContractItem"/>
                                                </urn:Identifier>
                                            </urn:Reference>
                                            <urn:ReferenceDocInfoLineNumber>
                                                <xsl:value-of select="ReferenceItemID"/>
                                            </urn:ReferenceDocInfoLineNumber>
                                            <urn:Operation>update</urn:Operation>
                                        </urn:item>
                                    </xsl:for-each>
                                </urn:ContractItemStatus>
                            </xsl:when>
                            <xsl:otherwise>
                                <urn:ContractItemStatus>
                                    <urn:item>
                                        <urn:Reference>
                                            <urn:Domain/>
                                            <urn:Identifier/>
                                        </urn:Reference>
                                        <urn:ReferenceDocInfoLineNumber/>
                                        <urn:Operation/>
                                    </urn:item>
                                </urn:ContractItemStatus>
                            </xsl:otherwise>
                        </xsl:choose>
                        <urn:Status>
                            <urn:Message>
                                <xsl:for-each select="LogMessage">
                                    <xsl:choose>
                                        <xsl:when test="./SeverityCode = 'W'">[WARNINING] </xsl:when>
                                        <xsl:when test="./SeverityCode = 'E'">[ERROR]</xsl:when>
                                        <xsl:when test="./SeverityCode = 'I'"
                                            >[INFORMATION]</xsl:when>
                                        <xsl:when test="./SeverityCode = 'S'">[SUCCESS]</xsl:when>
                                    </xsl:choose>
                                    <xsl:value-of select="./Note"/>
                                </xsl:for-each>
                            </urn:Message>
                            <urn:Status>
                                <xsl:choose>
                                    <xsl:when test="count(LogMessage/SeverityCode[text() = 'E'])"
                                        >406</xsl:when>
                                    <xsl:otherwise>200</xsl:otherwise>
                                </xsl:choose>
                            </urn:Status>
                        </urn:Status>
                    </urn:ContractStatusUpdateRequest>
                </urn:item>
            </urn:WSPurchaseContractStatusUpdateRequestImportInputBean_Item>
        </urn:PurchaseContractStatusUpdateRequestImportRequest>
    </xsl:template>
</xsl:stylesheet>
