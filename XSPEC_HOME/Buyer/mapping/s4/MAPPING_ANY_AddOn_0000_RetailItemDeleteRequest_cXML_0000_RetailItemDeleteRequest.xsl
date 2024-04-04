<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="deleteItem"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    exclude-result-prefixes="#all" xmlns:n0="http://sap.com/xi/ARBCIGR">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="n0:MasterDataDeleteRequest">
        <MasterDataDelete>
            <xsl:for-each select="MessageHeader">
                <MessageHeader>
                    <MessageID>
                        <xsl:value-of select="UUID"/>
                    </MessageID>
                    <CreationDateTime>
                        <xsl:value-of select="current-dateTime()"/>
                    </CreationDateTime>
                    <SenderBusinessSystemID>
                        <xsl:value-of select="SenderBusinessSystemID"/>
                    </SenderBusinessSystemID>
                    <RecipientBusinessSystemID>
                        <xsl:value-of select="RecipientBusinessSystemID"/>
                    </RecipientBusinessSystemID>
                    <ExternalID>
                        <xsl:value-of select="RecipientBusinessSystemID"/>
                    </ExternalID>
                </MessageHeader>
            </xsl:for-each>
            <xsl:for-each select="Item">
                <Item>
                    <ObjectType>
                        <xsl:value-of select="Type"/>
                    </ObjectType>
                    <ObjectID>
                        <xsl:value-of select="ID"/>
                    </ObjectID>
                </Item>
            </xsl:for-each>
        </MasterDataDelete>
    </xsl:template>
</xsl:stylesheet>
