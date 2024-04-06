<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="Combined">
        <!-- Multi ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
        <xsl:variable name="v_sysId">
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
                <xsl:with-param name="p_erpsysid" select="$v_sysId"/>
                <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Fetch Default Language -->
        <xsl:variable name="v_defaultLang">
            <xsl:call-template name="FillDefaultLang">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Declare Namespace holders-->
        <xsl:variable name="v_Header"
            select="Payload/cXML/Request/QualityInspectionResultRequest/QualityInspectionResultRequestHeader"/>
        <xsl:variable name="v_dateTime" select="Payload/cXML/@timestamp"/>
        <!--Begin Quality Inspection Result processing-->
        <n0:QualityInspectionResult>
            <!--MessageHeader node-->
            <MessageHeader>
                <CreationDateTime>
                    <xsl:value-of select="$v_dateTime"/>
                </CreationDateTime>
                <AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of select="$anReceiverID"/>
                </AribaNetworkID>                
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="$v_sysId"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <!--QualityInspectionResultHeader-->
            <QualityInspectionResultHeader>
                <InspectionLotID>
                    <xsl:value-of select="$v_Header/QualityInspectionRequestReference/@inspectionID"
                    />
                </InspectionLotID>
                <InspectionLotDate>
                    <xsl:variable name="v_InsLotDat">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date"
                                select="$v_Header/QualityInspectionRequestReference/@inspectionDate"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                    <xsl:value-of select="translate(substring($v_InsLotDat, 1, 10), '-', '')"/>
                </InspectionLotDate>
                <InspectionResultID>
                    <xsl:value-of select="$v_Header/@resultID"/>
                </InspectionResultID>
                <InspectionResultDate>
                    <!--Convert format for ERP!-->
                    <xsl:variable name="v_InsResDate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="$v_Header/@resultDate"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                    <xsl:value-of select="translate(substring($v_InsResDate, 1, 10), '-', '')"/>
                </InspectionResultDate>
                <xsl:if test="string-length(normalize-space($v_Header/@createdBy)) > 0">
                    <CreatedBy>
                        <xsl:value-of select="substring($v_Header/@createdBy,1,35)"/>
                    </CreatedBy>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($v_Header/QualityInspectionQuantity/@quantity)) > 0">
                    <InspectionQuantity>
                        <xsl:attribute name="unitCode"
                            select="$v_Header/QualityInspectionQuantity/UnitOfMeasure"/>
                        <xsl:value-of select="$v_Header/QualityInspectionQuantity/@quantity"/>
                    </InspectionQuantity>
                </xsl:if>
                <!-- IG-28022 - Digital Signature as Attachment-->
                <xsl:for-each select="$v_Header/Comments">
                    <xsl:if test="Attachment/URL[@name = 'link']">
                        <ElectronicSignature>
                            <URL>
                                <xsl:value-of select="Attachment/URL[@name = 'link']/node()"/>
                            </URL>
                            <URLDescription>
                                <xsl:value-of select="@type"/>
                            </URLDescription>
                        </ElectronicSignature>
                    </xsl:if>
                </xsl:for-each>
                <!--Fill Batch details-->
                <xsl:for-each select="$v_Header/Batch">
                    <BatchDetails>
                        <xsl:if test="string-length(normalize-space(BuyerBatchID)) > 0">
                            <BatchID>
                                <xsl:value-of select="BuyerBatchID"/>
                            </BatchID>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(SupplierBatchID)) > 0">
                            <VendorBatchID>
                                <xsl:value-of select="SupplierBatchID"/>
                            </VendorBatchID>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@expirationDate)) > 0">
                            <BatchExpirationDate>
                                <!--Convert format for ERP!-->
                                <xsl:variable name="v_BatchExpDate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="@expirationDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of
                                    select="translate(substring($v_BatchExpDate, 1, 10), '-', '')"/>
                            </BatchExpirationDate>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@productionDate)) > 0">
                            <BatchProductionDate>
                                <!--Convert format for ERP!-->
                                <xsl:variable name="v_BatchProdDate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="@productionDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of
                                    select="translate(substring($v_BatchProdDate, 1, 10), '-', '')"
                                />
                            </BatchProductionDate>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@inspectionDate)) > 0">
                            <BatchInspectionDate>
                                <!--Convert format for ERP!-->
                                <xsl:variable name="v_BatchInsDate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="@inspectionDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of
                                    select="translate(substring($v_BatchInsDate, 1, 10), '-', '')"/>
                            </BatchInspectionDate>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@originCountryCode)) > 0">
                            <BatchOriginCountry>
                                <xsl:value-of select="@originCountryCode"/>
                            </BatchOriginCountry>
                        </xsl:if>
                    </BatchDetails>
                </xsl:for-each>
            </QualityInspectionResultHeader>
            <!--Quality Inspection result details node-->
            <xsl:if
                test="Payload/cXML/Request/QualityInspectionResultRequest/QualityInspectionResultRequestDetail">
                <xsl:for-each
                    select="Payload/cXML/Request/QualityInspectionResultRequest/QualityInspectionResultRequestDetail/QualityInspectionValuation">
                    <QualityInspectionResultDetails>
                        <OperationNumber>
                            <xsl:value-of select="@operationNumber"/>
                        </OperationNumber>
                        <InspectionCharacteristicID>
                            <xsl:value-of select="@characteristicID"/>
                        </InspectionCharacteristicID>
                        <!--End of mandatory parameters from AN , Below parameters are optional as per AN-->
                        <xsl:if test="string-length(normalize-space(@nonConformance)) > 0">
                            <NonConformance>
                                <xsl:value-of select="@nonConformance"/>
                            </NonConformance>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@meanValue)) > 0">
                            <MeanValue>
                                <xsl:value-of select="@meanValue"/>
                            </MeanValue>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@numberOfDefects)) > 0">
                            <NoOfDefects>
                                <xsl:value-of select="@numberOfDefects"/>
                            </NoOfDefects>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@aboveTolerance)) > 0">
                            <AboveTolerance>
                                <xsl:value-of select="@aboveTolerance"/>
                            </AboveTolerance>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@belowTolerance)) > 0">
                            <BelowTolerance>
                                <xsl:value-of select="@belowTolerance"/>
                            </BelowTolerance>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@variance)) > 0">
                            <Variance>
                                <xsl:value-of select="@variance"/>
                            </Variance>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@inspectedQuantity)) > 0">
                            <InspectedQuantity>
                                <xsl:value-of select="@inspectedQuantity"/>
                            </InspectedQuantity>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@isAdHoc)) > 0">
                            <IsAdhoc>
                                <xsl:value-of select="@isAdHoc"/>
                            </IsAdhoc>
                        </xsl:if>
                        <xsl:for-each select="QualitySampleResult">
                            <QualitySampleResult>
                                <SampleID>
                                    <xsl:value-of select="@sampleID"/>
                                </SampleID>
                                <UnitValue>
                                    <xsl:value-of select="@unitValue"/>
                                </UnitValue>
                                <xsl:if test="string-length(normalize-space(@physicalSampleNumber)) > 0">
                                    <PhysicalSampleNumber>
                                        <xsl:value-of select="@physicalSampleNumber"/>
                                    </PhysicalSampleNumber>
                                </xsl:if>
                            </QualitySampleResult>
                        </xsl:for-each>
                        <Description>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(Description/@xml:lang)) > 0">
                                    <xsl:attribute name="languageCode"
                                        select="Description/@xml:lang"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="languageCode" select="$v_defaultLang"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!--Considering Main description tag only and not ShortName under Description-->
                            <xsl:value-of select="Description"/>
                        </Description>
                        <xsl:for-each select="ValueGroup">
                            <xsl:for-each select="PropertyValue">
                                <xsl:for-each select="Characteristic">
                                    <CodeList>
                                        <CodeGroup>
                                            <xsl:value-of select="@domain"/>
                                        </CodeGroup>
                                        <CodeText>
                                            <xsl:value-of select="@value"/>
                                        </CodeText>
                                        <xsl:if test="string-length(normalize-space(@code)) > 0">
                                            <Code>
                                                <xsl:value-of select="@code"/>
                                            </Code>
                                        </xsl:if>
                                    </CodeList>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </QualityInspectionResultDetails>
                </xsl:for-each>
            </xsl:if>
            <Comments>
                <xsl:variable name="v_commentsLang">
                    <xsl:choose>
                        <xsl:when test="string-length(normalize-space($v_Header/Comments/@xml:lang)) > 0">
                            <xsl:value-of select="$v_Header/Comments/@xml:lang"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$v_defaultLang"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="CommentsFillProxyIn">
                    <xsl:with-param name="p_comments" select="$v_Header/Comments"/>
                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                    <xsl:with-param name="p_lang" select="$v_commentsLang"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                </xsl:call-template>
            </Comments>
            <!--Map attachments , Call template to handle this-->
            <xsl:call-template name="InboundAttachs"/>
        </n0:QualityInspectionResult>
    </xsl:template>
</xsl:stylesheet>
