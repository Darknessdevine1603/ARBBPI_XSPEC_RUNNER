<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all"  
    xmlns:ns0="urn:Ariba:Buyer:vsap" xmlns:n0="http://sap.com/xi/ARBCIG1">                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                           <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                     <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <!--   <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->                             <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:template match="ns0:RequisitionAsyncImportPullStatusRequest">
        <n0:BuyerStatusUpdateRequest>
            <MessageHeader>
                <partition>
                    <xsl:value-of select="@partition"/>                   
                </partition>
                <variant>
                    <xsl:value-of select="@variant"/>                   
                </variant>
            </MessageHeader>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <DocumentType>
                <xsl:value-of select="'ERPRequisitionRequest'"/>
            </DocumentType>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:for-each
                select="ns0:RequisitionAsyncImportPullStatus_RequisitionAsyncImportPullResponse_Item/ns0:item">
                <DocumentDetails>
                    <AribaDocumentID>
                        <xsl:value-of select="ns0:Requisition/ns0:UniqueName"/>
                    </AribaDocumentID>
                    <ERPDocumentID>
                        <xsl:value-of select="ns0:EntityReferenceID"/>
                    </ERPDocumentID>
                    <xsl:choose>
                        <xsl:when test="ns0:Errors">
                            <Status>
                                <xsl:value-of select="'REJECTED'"/>
                            </Status>                            
                            <Message>
                                <xsl:for-each select="ns0:Errors/ns0:item">
                                    <Comment>
                                        <xsl:value-of select="concat(ns0:ErrorMessage,ns0:ErrorNumber)"/>
                                    </Comment> 
                                </xsl:for-each>                                
                            </Message>
                        </xsl:when>
                        <xsl:otherwise>
                            <Status>
                                <xsl:value-of select="'ACCEPTED'"/>
                            </Status>
                            <Message>
                                <Comment>
                                    <xsl:value-of select="ns0:Requisition/ns0:StatusString"/>
                                </Comment>
                            </Message>
                        </xsl:otherwise>
                    </xsl:choose>
                </DocumentDetails>
            </xsl:for-each>
        </n0:BuyerStatusUpdateRequest>
    </xsl:template>
</xsl:stylesheet>
