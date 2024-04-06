<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n1="http://sap.com/xi/SAPGlobal20/Global"
    xmlns:hci="http://sap.com/it/"
    xmlns:xop="http://www.w3.org/2004/08/xop/include"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
<!--            <xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anSenderID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anEnvName"/>
    <xsl:variable name="v_header" select="/n1:MRPChangeRequestConfirmation/MessageHeader"/>
    <xsl:variable name="v_vendorID" select="/n1:MRPChangeRequestConfirmation/MRPChangeRequestConfirmation[1]/Supplier"/>
    <xsl:template match="n1:MRPChangeRequestConfirmation">
        <root>
            <changeRequestConfirmation>
                <requestInfo>
                    <payloadID>
                        <xsl:value-of select="$v_header/ID"/>
                    </payloadID>
                    <creationDateTime>
                        <xsl:value-of select = "concat(substring($v_header/CreationDateTime,0,20), '+00:00')"/>
                    </creationDateTime>
                    <parties>
                        <type>FromParty</type>
                        <domain>NetworkID</domain>
                        <identity>
                            <xsl:value-of select="$anSenderID"/>
                        </identity>
                        <!--                        IG-33042-->
                        <xsl:if test="upper-case($anIsMultiERP) = 'TRUE'">
                        <systemID>
                            <xsl:value-of select="$v_header/SenderBusinessSystemID"/>
                        </systemID>   
                        </xsl:if>
                        <endpointID>
                            <xsl:value-of select="'CIG'"/>
                        </endpointID>
                    </parties>
                    <parties>
                        <type>ToParty</type>
                        <domain>VendorID</domain>
                        <identity>
                            <xsl:value-of select="$v_vendorID"/>
                        </identity>
                    </parties>
                    <parties>
                        <type>SenderParty</type>
                        <domain>NetworkID</domain>
                        <identity>
                            <xsl:value-of select="$anProviderANID"/>
                        </identity>
                    </parties>
                </requestInfo>
                <xsl:for-each-group select="MRPChangeRequestConfirmation" group-by="MRPElement">
                    <changeRequestConfirmationDocuments>
                        <companyCode>
                            <xsl:value-of select="CompanyCode"/>
                        </companyCode>
                        <vendorID>
                            <xsl:value-of select="$v_vendorID"/>
                        </vendorID>
                        <documentReference>
                            <!--   CI-2112 Timezone changes                         -->
                            <documentDate>
                                <xsl:choose>
                                    <xsl:when test="string-length(MRPElementCreationDateTime) > 0">
                                        <xsl:value-of select="MRPElementCreationDateTime"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="string-length(MRPElementCreationDate) > 0">
                                            <xsl:call-template name="ANDateTime_S4HANA_V1">
                                                <!-- IG-31370 -->
                                                <xsl:with-param name="p_date"
                                                    select="MRPElementCreationDate"/>
                                                <xsl:with-param name="p_time" select="''"/>
                                                <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </documentDate>
                            <documentNumber>
                                <xsl:value-of select="MRPElement"/>
                            </documentNumber>
                        </documentReference>
                        <xsl:for-each-group select="current-group ()"
                            group-by="MRPElementItem">
                            <itemReferences>
                                <lineNumber>
                                    <xsl:value-of select="MRPElementItem"/>
                                </lineNumber>
                                <plantID>
                                    <xsl:value-of select="MRPPlant"/>
                                </plantID>
                                <xsl:if test="string-length(MRPController) > 0">
                                    <mrpController>
                                        <xsl:value-of select="MRPController"/>
                                    </mrpController>
                                </xsl:if>
                                <xsl:for-each-group select="current-group ()"
                                    group-by="MRPElementScheduleLine">
                                    <scheduleLineReferences>
                                        <scheduleLineNumber>
                                            <xsl:value-of select="MRPElementScheduleLine"/>
                                        </scheduleLineNumber>
                                        <decision>
                                            <xsl:choose>
                                                <xsl:when test="MRPChangeRequestStatus = '02'">
                                                    <xsl:value-of select="'accept'"/>
                                                </xsl:when>
                                                <xsl:when test="MRPChangeRequestStatus = '03'">
                                                    <xsl:value-of select="'reject'"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </decision>
                                        <changeRequestUUID>
                                            <xsl:value-of select="ChangeRequestUUID"/>
                                        </changeRequestUUID>
                                        <xsl:if test="string-length(normalize-space(ChangeRequestNote)) > 0">
                                            <comments>
                                                <xsl:value-of select="ChangeRequestNote"/>
                                            </comments>
                                        </xsl:if>
                                    </scheduleLineReferences>
                                </xsl:for-each-group>
                            </itemReferences>
                        </xsl:for-each-group>
                    </changeRequestConfirmationDocuments>
                </xsl:for-each-group>
            </changeRequestConfirmation>
        </root>
    </xsl:template>
</xsl:stylesheet>
