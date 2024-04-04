<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:n0="http://sap.com/xi/ARBCIS">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anErrorCode"/>
    <xsl:param name="anErrorDescription"/>
    <xsl:param name="anAlternateSenderID"/>
    <xsl:param name="anDateTime"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPDocumentType"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anDocNumber"/>
    <xsl:param name="erpDocNumber"/>
    <xsl:template match="/">
        <n0:DocumentStatusUpdateRequest>
            <xsl:variable name="dateNow" select="/EventMessage/EventMessageHeader/anDateTime"/>
            <xsl:choose>
                <xsl:when test="string-length($erpDocNumber) = 0">
                    <StatusUpdate>
                        <ERPDocumentNo>
                            <xsl:value-of select="EventMessage/EventMessageHeader/SAP_ApplicationID"
                            />
                        </ERPDocumentNo>
                        <DocumentNo/>
                        <DocumentType>
                            <xsl:choose>
                                <xsl:when
                                    test="EventMessage/EventMessageHeader/anSourceDocumentType = 'InvoiceDetailRequest'"
                                    >
                                    <xsl:value-of select="'InvoiceRequest'"/>
                                </xsl:when>
                                <xsl:when
                                    test="EventMessage/EventMessageHeader/anSourceDocumentType = 'ConfirmationRequest'"
                                    >
                                    <xsl:value-of select="'SalesOrderConfirmation'"/>
                                </xsl:when>
                                <xsl:when
                                    test="EventMessage/EventMessageHeader/anSourceDocumentType = 'ShipNoticeRequest'"
                                    >
                                    <xsl:value-of select="'OutboundDelivery'"/>
                                </xsl:when>
                            </xsl:choose>
                        </DocumentType>
                        <LogicalSystem>
                            <xsl:value-of select="EventMessage/EventMessageHeader/anSystemID"/>
                        </LogicalSystem>
                        <Vendor>
                            <xsl:value-of select="EventMessage/EventMessageHeader/SAP_Receiver"/>
                        </Vendor>
                        <Date>
                            <xsl:value-of
                                select="substring(EventMessage/EventMessageHeader/anDateTime, 1, 10)"
                            />
                        </Date>
                        <Time>
                            <xsl:value-of
                                select="substring(EventMessage/EventMessageHeader/anDateTime, 12, 8)"
                            />
                        </Time>
                        <Status>
                            <xsl:choose>
                                <xsl:when
                                    test="EventMessage/EventMessageHeader/anErrorCode = '200' or EventMessage/EventMessageHeader/anErrorCode = '201' or EventMessage/EventMessageHeader/anErrorCode = '202'"
                                    >
                                    <xsl:value-of select="'ACCEPTED'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'REJECTED'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </Status>
                        <TimeZone>
                            <xsl:value-of
                                select="substring(EventMessage/EventMessageHeader/anDateTime, 21, 7)"
                            />
                        </TimeZone>
                        <Comment>
                            <Comment>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="'en'"/>
                                </xsl:attribute>
                                <xsl:value-of
                                    select="EventMessage/EventMessageHeader/anErrorDescription"/>
                            </Comment>
                        </Comment>
                        <AribaExtension/>
                    </StatusUpdate>
                </xsl:when>
                <xsl:otherwise>
                    <ERPDocumentNo>
                        <xsl:value-of select="$erpDocNumber"/>
                    </ERPDocumentNo>
                    <DocumentNo/>
                    <DocumentType>
                        <xsl:choose>
                            <xsl:when test="$anSourceDocumentType = 'InvoiceDetailRequest'">
                                <xsl:value-of select="'InvoiceRequest'"/>
                            </xsl:when>
                            <xsl:when test="$anSourceDocumentType = 'ConfirmationRequest'">
                                <xsl:value-of select="'SalesOrderConfirmation'"/>
                            </xsl:when>
                            <xsl:when test="$anSourceDocumentType = 'ShipNoticeRequest'">
                                <xsl:value-of select="'OutboundDelivery'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$anERPDocumentType"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </DocumentType>
                    <LogicalSystem>
                        <xsl:value-of select="$anERPSystemID"/>
                    </LogicalSystem>
                    <!--Optional:-->
                    <Vendor>
                        <xsl:value-of select="$anAlternateSenderID"/>
                    </Vendor>
                    <Date>
                        <xsl:choose>
                            <xsl:when test="$anDateTime != ''">
                                <xsl:value-of select="substring($anDateTime, 1, 10)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="format-dateTime($dateNow, '[Y01]-[M01]-[D01]')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </Date>
                    <Time>
                        <xsl:choose>
                            <xsl:when test="$anDateTime != ''">
                                <xsl:value-of select="substring($anDateTime, 12, 8)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="format-dateTime($dateNow, '[H01]:[M01]:[s01]')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </Time>
                    <Status>
                        <xsl:choose>
                            <xsl:when
                                test="$anErrorCode = '200' or $anErrorCode = '201' or $anErrorCode = '202'"
                                >
                                <xsl:value-of select="'ACCEPTED'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'REJECTED'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </Status>
                    <TimeZone>
                        <xsl:value-of select="substring($anDateTime, 21, 7)"/>
                    </TimeZone>
                    <!--Optional:-->
                    <Comment>
                        <!--1 or more repetitions:-->
                        <Comment>
                            <xsl:attribute name="languageCode">
                                <xsl:value-of select="'en'"/>
                            </xsl:attribute>
                            <xsl:value-of select="$anErrorDescription"/>
                        </Comment>
                    </Comment>
                    <AribaExtension/>
                </xsl:otherwise>
            </xsl:choose>
        </n0:DocumentStatusUpdateRequest>
    </xsl:template>
</xsl:stylesheet>
