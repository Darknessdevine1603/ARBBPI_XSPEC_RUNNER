<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="http://sap.com/xi/ARBCIS"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:param name="anEnvName"/>
    <xsl:template match="n0:DocumentStatusUpdateRequest">
     <Combined>
       <Payload>  
        <cXML>
            <xsl:attribute name="payloadID">
                <xsl:value-of select="MessageHeader/AribaPayloadID"/>
            </xsl:attribute>
            <xsl:attribute name="timestamp">
                <xsl:variable name="curDate">
                    <xsl:value-of select="MessageHeader/CreationDateTime"/>
                </xsl:variable>
                <xsl:value-of
                    select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"/>
            </xsl:attribute>
            <Header>
                <From>
                    <Credential>
                        <xsl:attribute name="domain">
                            <xsl:value-of select="'NetworkID'"/>
                        </xsl:attribute>
                        <Identity>
                            <xsl:value-of select="MessageHeader/AribaNetworkID/SupplierAribaNetworkID"
                            />
                        </Identity>
                    </Credential>
                </From>
                <To>
                    <Credential>
                        <xsl:attribute name="domain">
                            <xsl:value-of select="'NetworkID'"/>
                        </xsl:attribute>
                        <Identity>
                            <xsl:value-of
                                select="MessageHeader/AribaNetworkID/BuyerAribaNetworkID"/>
                        </Identity>
                    </Credential>
                </To>
                <Sender>
                    <Credential domain="NetworkID">
                        <Identity>
                            <xsl:value-of select="$anProviderANID"/>
                        </Identity>
                    </Credential>
                    <UserAgent>
                        <xsl:value-of select="'Ariba Supplier'"/>
                    </UserAgent>
                </Sender>
            </Header>
            <Request>
                <xsl:choose>
                    <xsl:when test="$anEnvName = 'PROD'">
                        <xsl:attribute name="deploymentMode">
                            <xsl:value-of select="'production'"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="deploymentMode">
                            <xsl:value-of select="'test'"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <StatusUpdateRequest>
                    <DocumentReference>
                        <xsl:attribute name="payloadID">
                            <xsl:value-of select="MessageHeader/AribaPayloadID"/>
                        </xsl:attribute>
                    </DocumentReference>
                    <Status>
                        <xsl:attribute name="code">
                            <xsl:choose>
                                <xsl:when test="StatusUpdate/Status = 'REJECTED'">
                                    <xsl:value-of select="'423'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'200'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="text">
                            <xsl:for-each select="StatusUpdate/Comment/Comment">
                                <xsl:value-of select="normalize-space(concat(., .))"/>
                            </xsl:for-each>
                        </xsl:attribute>
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="'EN'"/>
                        </xsl:attribute>
                    </Status>
                    <IntegrationStatus>
                        <xsl:attribute name="documentStatus">
                            <xsl:choose>
                                <xsl:when test="StatusUpdate/Status = 'REJECTED'">
                                    <xsl:value-of select="'deliveryFailed'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'deliverySuccessful'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <IntegrationMessage>
                            <xsl:attribute name="isSuccessful">
                                <xsl:choose>
                                    <xsl:when test="StatusUpdate/Status = 'REJECTED'">
                                        <xsl:value-of select="'no'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'yes'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:value-of select="'CIG'"/>
                            </xsl:attribute>
                        </IntegrationMessage>
                    </IntegrationStatus>
                </StatusUpdateRequest>
            </Request>
        </cXML>
       </Payload>
     </Combined>
    </xsl:template>
</xsl:stylesheet>
