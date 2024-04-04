<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="anERPName"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anAddOnCIVersion"/>
    <!--        <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>

    <xsl:template match="Combined">
        <!--If Multi ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
        <xsl:variable name="v_sysid">
            <xsl:call-template name="MultiErpSysIdIN">
                <xsl:with-param name="p_ansysid"
                    select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
                <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Prepare the CrossRef path-->
        <xsl:variable name="v_pd">
            <xsl:call-template name="PrepareCrossref">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
                <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
            </xsl:call-template>
        </xsl:variable>
        <n0:FileAttachRequest>
            <!--Map Message Header Details-->
            <MessageHeader>
                <ID>
                    <xsl:value-of select="$anPayloadID"/>
                </ID>
                <AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of
                        select="Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity"/>
                </AribaNetworkID>
                <!--Convert the File Date into ERP System TimeZone relevant date-->
                <CreationDateTime>
                    <xsl:variable name="v_curDate">
                        <xsl:value-of select="current-dateTime()"/>
                    </xsl:variable>
                    <xsl:value-of select="$v_curDate"/>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of
                        select="Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity"/>
                </SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="$v_sysid"/>
                </RecipientBusinessSystemID>
            </MessageHeader>
            <!--Map File Attachment Details-->
            <Attachment>
                <xsl:for-each select="Payload/cXML/Request/ChargeFileRequest/ChargeFileDetails">
                    <Item>
                        <Parameter>
                            <Name>ProviderName</Name>
                            <Value>
                                <xsl:value-of select="../ChargeFileRequestHeader/ProviderName"/>
                            </Value>
                        </Parameter>
                        <parameter>
                            <Name>filename</Name>
                            <Value>
                                <xsl:value-of select="ChargeFile/@filename"/>
                            </Value>
                        </parameter>
                        <Parameter>
                            <Name>frequency</Name>
                            <Value>
                                <xsl:value-of select="ChargeFile/@frequency"/>
                            </Value>
                        </Parameter>
                        <Parameter>
                            <Name>statementDate</Name>
                            <Value>
                                <xsl:value-of select="ChargeFile/@statementDate"/>
                            </Value>
                        </Parameter>
                        <Parameter>
                            <Name>startDate</Name>
                            <Value>
                                <xsl:value-of select="ChargeFile/Period/@startDate"/>
                            </Value>
                        </Parameter>
                        <Parameter>
                            <Name>endDate</Name>
                            <Value>
                                <xsl:value-of select="ChargeFile/Period/@endDate"/>
                            </Value>
                        </Parameter>
                        <Parameter>
                            <Name>NumberOfCharges</Name>
                            <Value>
                                <xsl:value-of select="ChargeFile/NumberOfCharges"/>
                            </Value>
                        </Parameter>
                        <xsl:variable name="v_fileName" select="ChargeFile/@filename"/>
                        <xsl:variable name="eachAtt" select="../../../../../AttachmentList/Attachment[AttachmentName = $v_fileName ]"/>
                        <xsl:for-each select="$eachAtt">
                            <FileName>
                                <xsl:value-of select="AttachmentName"/>
                            </FileName>
                            <ContentId>
                                <xsl:value-of select="AttachmentID"/>
                            </ContentId>
                            <ContentType>
                                <xsl:value-of select="AttachmentType"/>
                            </ContentType>
                            <Content>
                                <xsl:value-of select="AttachmentContent"/>
                            </Content>
                        </xsl:for-each>
                    </Item>
                </xsl:for-each>
            </Attachment>
        </n0:FileAttachRequest>
    </xsl:template>
</xsl:stylesheet>
