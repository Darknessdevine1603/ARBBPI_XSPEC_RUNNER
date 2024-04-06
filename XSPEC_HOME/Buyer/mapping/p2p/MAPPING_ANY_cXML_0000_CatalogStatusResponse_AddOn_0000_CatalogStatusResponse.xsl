<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" 
    xpath-default-namespace="urn:Ariba:Buyer:vsap" xmlns:n0="http://sap.com/xi/ARBCIG1">                      
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                          
    <xsl:template match="CatalogStatusResponse">
        <n0:BuyerCatalogStatusResponseMsg>
            <xsl:for-each select="Item">
                <Item>
                    <SystemID>
                        <xsl:value-of select="normalize-space(../@systemId)"/>
                    </SystemID>
                    <RealmID>
                        <xsl:value-of select="normalize-space(../@realmId)"/>
                    </RealmID>
                    <DocumentType>
                        <xsl:value-of select="normalize-space(DocumentType)"/>
                    </DocumentType>
                    <SubscriptionName>
                        <xsl:value-of select="normalize-space(SubscriptionName)"/>
                    </SubscriptionName>
                    <LoadMode>
                        <xsl:value-of select="normalize-space(LoadMode)"/>
                    </LoadMode>
                    <BatchID>
                        <xsl:value-of select="normalize-space(BatchID)"/>
                    </BatchID>
                    <FileID>
                        <xsl:value-of select="normalize-space(FileID)"/>
                    </FileID>
                    <FileName>
                        <xsl:value-of select="normalize-space(FileName)"/>
                    </FileName>
                    <UploadStatus>
                        <xsl:value-of select="normalize-space(UploadStatus)"/>
                    </UploadStatus>
                    <UploadComments>
                        <xsl:value-of select="normalize-space(UploadComments)"/>
                    </UploadComments>
                </Item>
            </xsl:for-each>        
        </n0:BuyerCatalogStatusResponseMsg>
    </xsl:template>
</xsl:stylesheet>
