<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBS4FND"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="EventMessage/EventMessageHeader">
        <n0:DocumentStatusUpdate>
            <MessageHeader>
                <CreationDateTime>
                    <xsl:value-of select="anDateTime"/>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="SAP_Receiver"/>
                </SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="anSystemID"/>
                </RecipientBusinessSystemID>
            </MessageHeader>
            <DocStsUpdate>
                <S4DocumentNo>
                    <xsl:value-of select="SAP_ApplicationID"/>
                </S4DocumentNo>
                <ANDocumentNo/>
                <DocumentType>
                    <xsl:value-of select="anSourceDocumentType"/>
                </DocumentType>
                <Supplier>
                    <xsl:value-of select="SAP_Sender"/>
                </Supplier>
                <Status>
                    <xsl:choose>
                        <xsl:when test="anErrorCode = '200' or anErrorCode = '201' or anErrorCode = 202">
                            <xsl:value-of select="'ACCEPTED'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'REJECTED'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </Status>
                <Comment>
                    <Comment>
                        <xsl:attribute name="languageCode" select="'EN'"/>
                        <xsl:value-of select="anErrorDescription"/>
                    </Comment>
                </Comment>
            </DocStsUpdate>
        </n0:DocumentStatusUpdate>
    </xsl:template>
</xsl:stylesheet>
