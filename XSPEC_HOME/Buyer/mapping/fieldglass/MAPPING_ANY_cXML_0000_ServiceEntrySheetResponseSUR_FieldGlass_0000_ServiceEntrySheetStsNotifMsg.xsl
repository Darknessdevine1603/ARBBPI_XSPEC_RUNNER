<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/SAPGlobal20/Global"
    xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"
    version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="no"/> 
    <xsl:template match="Combined">
        <!--Prepare the CrossRef path-->
        <n0:ServiceEntrySheetStsNotifMsg>
            <MessageHeader>
                <ID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </ID>
                <ReferenceID>
                    <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID"/>
                </ReferenceID>
            </MessageHeader>
            <ServiceEntrySheetStatusEntity>
                <ServiceEntrySheet>
                    <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/Extrinsic[lower-case(@name) = 'erp_entrysheet']"/>
                </ServiceEntrySheet>
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID))>0">
                <PurgDocExternalReference>
                    <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID"/>
                </PurgDocExternalReference>
                </xsl:if>
                <PurchaseOrder/>
                <Supplier/>
                <ApprovalStatus>
                    <xsl:choose>
                        <xsl:when test="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/@type = 'approved'">
                            <xsl:value-of select="30"/>
                        </xsl:when>
                        <xsl:when test="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/@type = 'rejected'">
                            <xsl:value-of select="40"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="20"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </ApprovalStatus>
                <xsl:if test="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/@type = 'rejected' or substring(Payload/cXML/Request/StatusUpdateRequest/Status/@code,1,1) = '4'">
                    <HasError>
                        <xsl:value-of select="'Yes'"/>
                    </HasError>
                    <LogMessage>
                        <xsl:choose>
                            <xsl:when test="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/@type = 'rejected'"> 
                                <LogMessageCode> 
                                    <xsl:value-of select="'404'"/>
                                </LogMessageCode>
                                <LogMessageText>
                                    <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/Comments"/>
                                </LogMessageText>
                            </xsl:when>
                            <xsl:otherwise>
                                <LogMessageCode>
                                <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/Status/@code"/>
                                </LogMessageCode>
                                <LogMessageText>
                                    <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/Status/@text"/>
                                </LogMessageText>
                            </xsl:otherwise>
                        </xsl:choose>
                    </LogMessage>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate))>0">
                <ExternalRevisionDateTime>
                    <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate"/>
                </ExternalRevisionDateTime>
                </xsl:if>
                <IsDeleted>
                    <xsl:choose>
                        <xsl:when test="Payload/cXML/Request/StatusUpdateRequest/DocumentStatus/@type = 'canceled'">
                            <xsl:value-of select="'true'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'false'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </IsDeleted>
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/StatusUpdateRequest/Extrinsic[lower-case(@name) = 'messagecreationdatetime']))>0">
                <MessageCreationDateTime>
                    <xsl:value-of select="Payload/cXML/Request/StatusUpdateRequest/Extrinsic[lower-case(@name) = 'messagecreationdatetime']"/>
                </MessageCreationDateTime>
                </xsl:if>
            </ServiceEntrySheetStatusEntity>
        </n0:ServiceEntrySheetStsNotifMsg>
    </xsl:template>
</xsl:stylesheet>
