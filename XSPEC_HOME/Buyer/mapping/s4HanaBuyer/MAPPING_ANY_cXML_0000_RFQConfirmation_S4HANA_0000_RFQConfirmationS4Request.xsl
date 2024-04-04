<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/Procurement"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <!--    <xsl:variable name="v_messageheader" select="/n0:RFQConfirmationS4Request/MessageHeader"/>-->
    <xsl:template match="n0:RFQConfirmationS4Request">
        <n0:RFQConfirmationS4Request>
            <MessageHeader>
                <ID>
                    <xsl:value-of select="MessageHeader/ID"/>
                </ID>
                <UUID>
                    <xsl:value-of select="MessageHeader/UUID"/>
                </UUID>
                <ReferenceID>
                    <xsl:value-of select="MessageHeader/ReferenceID"/>
                </ReferenceID>
                <ReferenceUUID>
                    <xsl:value-of select="MessageHeader/ReferenceUUID"/>
                </ReferenceUUID>
                <CreationDateTime>
                    <xsl:value-of select="MessageHeader/CreationDateTime"/>
                </CreationDateTime>
                
                    <TestDataIndicator>
                        <xsl:value-of select="MessageHeader/TestDataIndicator"/>
                    </TestDataIndicator>
                
                
                    <ReconciliationIndicator>
                        <xsl:value-of select="MessageHeader/ReconciliationIndicator"/>
                    </ReconciliationIndicator>
                
                <SenderBusinessSystemID>
                    <xsl:value-of select="MessageHeader/SenderBusinessSystemID"/>
                </SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="MessageHeader/RecipientBusinessSystemID"/>
                </RecipientBusinessSystemID>
            </MessageHeader>
            <RFQConfirmation>
                <RequestForQuotationID>
                    <xsl:value-of select="RFQConfirmation/RequestForQuotationID"/>
                </RequestForQuotationID>
                <ExternalDocumentType>
                    <xsl:value-of select="RFQConfirmation/ExternalDocumentType"/>
                </ExternalDocumentType>
                <ExternalDocumentID>
                    <xsl:value-of select="RFQConfirmation/ExternalDocumentID"/>
                </ExternalDocumentID>
                <ExternalSystemID>
                    <xsl:value-of select="RFQConfirmation/ExternalSystemID"/>
                </ExternalSystemID>
                <LogMessage>
                    <LogMessageCode>
                        <xsl:value-of select="RFQConfirmation/LogMessage/LogMessageCode"/>
                    </LogMessageCode>
                    <LogMessageClass>
                        <xsl:value-of select="RFQConfirmation/LogMessage/LogMessageClass"/>
                    </LogMessageClass>
                    <LogMessageSeverityCode>
                        <xsl:value-of select="RFQConfirmation/LogMessage/LogMessageSeverityCode"/>
                    </LogMessageSeverityCode>
                    <LogMessageText>
                        <xsl:value-of select="RFQConfirmation/LogMessage/LogMessageText"/>
                    </LogMessageText>
                </LogMessage>
            </RFQConfirmation>
        </n0:RFQConfirmationS4Request>
    </xsl:template>
</xsl:stylesheet>
