<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

    <xsl:param name="anMPLID" select="'input from flow'"/>
    <xsl:param name="anCorrelationID"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:param name="anDocNumber"/>
    <xsl:param name="anDocType"/>
    <xsl:param name="anDocReferenceID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anSenderDefaultTimeZone"/>
    <xsl:param name="anPayloadID"></xsl:param>

    <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>

    <xsl:template match="*">
        <xsl:variable name="date" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
        <xsl:variable name="time" select="format-time(current-time(), '[H01]:[m01]:[s01][Z]')"/>
        <cXML>
            <xsl:attribute name="timestamp">
                <xsl:value-of select="concat($date, 'T', $time)"/>
            </xsl:attribute>
            <xsl:attribute name="payloadID">
                <xsl:value-of select="$anPayloadID"/>
            </xsl:attribute>
            <Header>
                <From>
                    <Credential domain="NetworkID">
                        <Identity>
                            <xsl:value-of select="$anSupplierANID"/>
                        </Identity>
                    </Credential>
                </From>
                <To>
                    <Credential domain="NetworkID">
                        <Identity>
                            <xsl:value-of select="$anBuyerANID"/>
                        </Identity>
                    </Credential>
                </To>
                <Sender>
                    <Credential domain="NetworkID">
                        <Identity>
                            <xsl:value-of select="$anProviderANID"/>
                        </Identity>
                    </Credential>
                    <UserAgent>Ariba Supplier</UserAgent>
                </Sender>
            </Header>
            <Request>
                <xsl:choose>
                    <xsl:when test="$anEnvName = 'PROD'">
                        <xsl:attribute name="deploymentMode">production</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="deploymentMode">test</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:variable name="statusResponse">
                    <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_110 = 'TA'">200</xsl:when>
                        <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_641 = 'C20'">200</xsl:when>
                        <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_641 = 'REJ'">400</xsl:when>
                        <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_641 = 'P01'">503</xsl:when>
                        <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_110 = 'TR'">400</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <StatusUpdateRequest>
                    <Status>
                        <xsl:attribute name="text">
                            <xsl:choose>
                                <xsl:when test="$statusResponse = '200'">accepted</xsl:when>
                                <xsl:when test="normalize-space(FunctionalGroup/M_824/G_OTI/G_TED/S_TED/D_3) != ''">
                                    <xsl:value-of select="normalize-space(FunctionalGroup/M_824/G_OTI/G_TED/S_TED/D_3)"/>
                                </xsl:when>
                                <xsl:otherwise>rejected</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="code">
                            <xsl:value-of select="$statusResponse"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$statusResponse = '200'">accepted</xsl:when>
                            <xsl:when test="normalize-space(FunctionalGroup/M_824/G_OTI/G_TED/S_TED/D_3) != ''">
                                <xsl:value-of select="normalize-space(FunctionalGroup/M_824/G_OTI/G_TED/S_TED/D_3)"/>
                            </xsl:when>
                            <xsl:otherwise>rejected</xsl:otherwise>
                        </xsl:choose>
                    </Status>
                    <DocumentStatus>
                        <xsl:attribute name="type">
                            <xsl:choose>
                                <xsl:when test="$statusResponse = '200'">accepted</xsl:when>
                                <xsl:otherwise>rejected</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <DocumentInfo>
                            <xsl:attribute name="documentID">
                                <xsl:choose>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_REF[D_128 = 'TN'][D_127 = 'DocumentID']/D_352 != ''">
                                        <xsl:value-of select="FunctionalGroup/M_824/G_OTI/S_REF[D_128 = 'TN'][D_127 = 'DocumentID']/D_352"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="FunctionalGroup/M_824/S_BGN/D_127"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="documentType">
                                <xsl:choose>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '810'">InvoiceDetailRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '820'">PaymentRemittanceRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '830'">ProductActivityMessage</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '846'">ProductReplenishment</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '850'">OrderRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '860'">OrderRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '862'">OrderRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '855'">ConfirmationRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '861'">ReceiptRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '866'">ComponentConsumptionRequest</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_143 = '856'">ShipNoticeDocument</xsl:when>
                                    <xsl:otherwise>Unknown</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="FunctionalGroup/M_824/G_OTI/S_DTM[D_374 = '102']/D_373 != ''">
                                <xsl:attribute name="documentDate">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of select="FunctionalGroup/M_824/G_OTI/S_DTM[D_374 = '102']/D_373"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of select="FunctionalGroup/M_824/G_OTI/S_DTM[D_374 = '102']/D_337"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of select="FunctionalGroup/M_824/G_OTI/S_DTM[D_374 = '102']/D_623"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:if>
                        </DocumentInfo>
                        <xsl:for-each-group select="//S_NTE[D_363 != '']" group-by="D_363">
                            <xsl:variable name="comType" select="current-grouping-key()"/>
                            <xsl:element name="Comments">
                                <xsl:for-each select="current-group()">
                                    <xsl:value-of select="D_352"/>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each select="//S_NTE[not(exists(D_363))]">
                            <xsl:element name="Comments">
                                <xsl:value-of select="D_352"/>
                            </xsl:element>
                        </xsl:for-each>
                    </DocumentStatus>
                    <!-- 
                    <IntegrationStatus>
                        <xsl:attribute name="documentStatus">
                            <xsl:choose>
                                <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_110 = 'TA'">
                                    <xsl:text>customerConfirmed</xsl:text>
                                </xsl:when>
                                <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_110 = 'TR'">
                                    <xsl:text>customerFailed</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <IntegrationMessage>
                            <xsl:attribute name="isSuccessful">
                                <xsl:choose>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_110 = 'TA'">
                                        <xsl:text>no</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="FunctionalGroup/M_824/G_OTI/S_OTI/D_110 = 'TR'">
                                        <xsl:text>yes</xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:text>824</xsl:text>
                            </xsl:attribute>
                        </IntegrationMessage>
                    </IntegrationStatus>       
            -->
                </StatusUpdateRequest>
            </Request>
        </cXML>
    </xsl:template>

    <!-- Convert to Ariba Date -->
    <xsl:template name="convertToAribaDate">
        <xsl:param name="Date"/>
        <xsl:param name="Time"/>
        <xsl:param name="TimeCode"/>
        <xsl:variable name="timeZone">
            <xsl:choose>
                <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
                    <xsl:value-of select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"/>
                </xsl:when>
                <xsl:when test="$anSenderDefaultTimeZone != ''">
                    <xsl:value-of select="$anSenderDefaultTimeZone"/>
                </xsl:when>
                <xsl:otherwise>+00:00</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="temDate">
            <xsl:value-of select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"/>
        </xsl:variable>
        <xsl:variable name="tempTime">
            <xsl:choose>
                <xsl:when test="$Time != '' and string-length($Time) = 6">
                    <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"/>
                </xsl:when>
                <xsl:when test="$Time != '' and string-length($Time) = 4">
                    <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
                </xsl:when>
                <xsl:otherwise>T12:00:00</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
    </xsl:template>
</xsl:stylesheet>
