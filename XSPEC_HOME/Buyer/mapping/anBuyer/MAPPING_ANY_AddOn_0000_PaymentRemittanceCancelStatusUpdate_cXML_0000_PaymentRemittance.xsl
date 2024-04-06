<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:nm="http://sap.com/xi/Ariba/Interfaces"
    xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anSharedSecrete"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:decimal-format name="remit" decimal-separator="."/>
    <xsl:param name="anEnvName"/>
    <!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
        <!--        <xsl:value-of select="document('ParameterCrossreference.xml')"/>-->
    </xsl:variable>

    <xsl:template match="n0:PaymentRemittanceCancelStatusUpdate">
        <Combined>
            <Payload>
                <cXML>
                    <xsl:attribute name="payloadID">
                        <xsl:value-of select="$anPayloadID"/>
                    </xsl:attribute>
                    <xsl:attribute name="timestamp">
                        <xsl:variable name="curDate">
                            <xsl:value-of select="current-dateTime()"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"
                        />
                    </xsl:attribute>
                    <Header>
                        <From>
                            <xsl:call-template name="MultiERPTemplateOut">
                                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                                <xsl:with-param name="p_anERPSystemID"
                                    select="$anERPSystemID"/>
                            </xsl:call-template>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$anSupplierANID"/>
                                </Identity>
                            </Credential>
                            <!--End Point Fix for CIG-->
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'EndPointID'"/>
                                </xsl:attribute>
                                <Identity>CIG</Identity>
                            </Credential>
                        </From>
                        <To>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'VendorID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="Header/VendorDetails/VendorID"/>
                                </Identity>
                            </Credential>
                        </To>
                        <Sender>
                            <Credential domain="NetworkID">
                                <Identity>
                                    <xsl:value-of select="$anProviderANID"/>
                                </Identity>
                                <SharedSecret>
                                    <xsl:value-of select="$anSharedSecrete"/>
                                </SharedSecret>
                            </Credential>
                            <UserAgent>
                                <xsl:value-of select="'Ariba Supplier'"/>
                            </UserAgent>
                        </Sender>
                    </Header>
                    <Request>
                    <PaymentRemittanceStatusUpdateRequest>
                        <DocumentReference>
                            <xsl:attribute name="payloadID"
                                select="Request/DocumentReference/@payloadID"/>
                        </DocumentReference>
                        <PaymentRemittanceStatus>
                            <xsl:attribute name="type" select="Request/PaymentRemittanceStatus/type"/>
                            <xsl:attribute name="paymentReferenceNumber"
                                select="Request/PaymentRemittanceStatus/paymentReferenceNumber"/>
                        <PaymentRemittanceStatusDetail>
                            <xsl:attribute name="code"
                                select="Request/PaymentRemittanceStatus/PaymentRemittanceStatusDetail/code"/>
                            <xsl:attribute name="description"
                                select="Request/PaymentRemittanceStatus/PaymentRemittanceStatusDetail/Description"/>
                            <xsl:attribute name="xml:lang">
                                <xsl:variable name="v_lang">
                                    <xsl:value-of select="Request/PaymentRemittanceStatus/PaymentRemittanceStatusDetail/Description/@languageCode"/>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$v_lang!=''">
                                        <xsl:value-of select="$v_lang"/>   
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="FillDefaultLang">
                                            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>                            
                            </xsl:attribute>    
                        </PaymentRemittanceStatusDetail>
                        </PaymentRemittanceStatus>   
                    </PaymentRemittanceStatusUpdateRequest>
					</Request>
                    
                </cXML>
            </Payload>
        </Combined>

    </xsl:template>
</xsl:stylesheet>
