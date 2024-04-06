<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/Procurement"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="n0:CQTNConfirmationS4Request">
        <n0:QTNConfirmationS4Request>
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
                <Origin>CS</Origin>
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
            <QTNConfirmation>
                <SupplierQuotationExternalId>
                    <xsl:value-of select="CQTNConfirmation/CentralSupplierQuotationExternalId"/>
                </SupplierQuotationExternalId>
                <SupplierQuotation>
                    <xsl:value-of select="CQTNConfirmation/CentralSupplierQuotation"/>
                </SupplierQuotation>
                <LogMessage>
                    <LogMessageCode>
                        <xsl:value-of select="CQTNConfirmation/LogMessage/LogMessageCode"/>
                    </LogMessageCode>
                    <LogMessageClass>
                        <xsl:value-of select="CQTNConfirmation/LogMessage/LogMessageClass"/>
                    </LogMessageClass>
                    <LogMessageSeverityCode>
                        <xsl:value-of select="CQTNConfirmation/LogMessage/LogMessageSeverityCode"/>
                    </LogMessageSeverityCode>
                    <LogMessageText>
                        <xsl:value-of select="CQTNConfirmation/LogMessage/LogMessageText"/>
                    </LogMessageText>
                </LogMessage>
            </QTNConfirmation>
        </n0:QTNConfirmationS4Request>
    </xsl:template>
</xsl:stylesheet>
