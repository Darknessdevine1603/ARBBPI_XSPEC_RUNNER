<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/Procurement"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="n0:SupplierQuotationS4RequestAsync">
        <n0:CentralSupplierQuotationS4Request>
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
            <CentralSupplierQuotationS4>
                <SupplierQuotationExternalId>
                    <xsl:value-of select="SupplierQuotationS4/SupplierQuotationExternalId"/>
                </SupplierQuotationExternalId>
                <RequestForQuotationId>
                    <xsl:value-of select="SupplierQuotationS4/RequestForQuotationId"/>
                </RequestForQuotationId>
                <SupplierQuotationExternalStatus>
                    <xsl:value-of select="SupplierQuotationS4/SupplierQuotationExternalStatus"/>
                </SupplierQuotationExternalStatus>
                <Supplier>
                    <xsl:value-of select="SupplierQuotationS4/Supplier"/>
                </Supplier>
                <Language>
                    <xsl:value-of select="SupplierQuotationS4/Language"/>
                </Language>
                <SupplierQuotationSubmissionDate>
                    <xsl:value-of select="SupplierQuotationS4/SupplierQuotationSubmissionDate"/>
                </SupplierQuotationSubmissionDate>
                <BindingPeriodEndDate>
                    <xsl:value-of select="SupplierQuotationS4/BindingPeriodEndDate"/>
                </BindingPeriodEndDate>
                <FollowOnDocumentCategory>
                    <xsl:value-of select="SupplierQuotationS4/FollowOnDocumentCategory"/>
                </FollowOnDocumentCategory>
                <FollowOnDocumentType>
                    <xsl:value-of select="SupplierQuotationS4/FollowOnDocumentType"/>
                </FollowOnDocumentType>
                <xsl:for-each select="SupplierQuotationS4/TextCollection">
                    <TextCollection>
                        <ContentText>
                            <xsl:attribute name="languageCode">
                                <xsl:value-of select="ContentText/@languageCode"/>
                            </xsl:attribute>
                            <xsl:value-of select="ContentText"/>
                        </ContentText>
                        <TypeCode>
                            <xsl:value-of select="TypeCode"/>
                        </TypeCode>
                        <MimeType>
                            <xsl:value-of select="MimeType"/>
                        </MimeType>
                    </TextCollection>
                </xsl:for-each>
                <xsl:for-each select="SupplierQuotationS4/SupplierQuotationItem">
                    <SupplierQuotationItem>
                        <SupplierQuotationExternalItemID>
                            <xsl:value-of select="SupplierQuotationExternalItemID"/>
                        </SupplierQuotationExternalItemID>
                        <RequestForQuotationItemID>
                            <xsl:value-of select="RequestForQuotationItemID"/>
                        </RequestForQuotationItemID>
                        <OfferedQuantity>
                            <xsl:attribute name="unitCode">
                                <xsl:value-of select="OfferedQuantity/@unitCode"/>
                            </xsl:attribute>
                            <xsl:value-of select="OfferedQuantity"/>
                        </OfferedQuantity>
                        <SupplierMaterialNumber>
                            <xsl:value-of select="SupplierMaterialNumber"/>
                        </SupplierMaterialNumber>
                        <Manufacturer>
                            <xsl:value-of select="Manufacturer"/>
                        </Manufacturer>
                        <ManufacturerPartNmbr>
                            <xsl:value-of select="ManufacturerPartNmbr"/>
                        </ManufacturerPartNmbr>
                        <xsl:for-each select="PricingElements">
                            <PricingElements>
                                <ConditionType>
                                    <xsl:value-of select="ConditionType"/>
                                </ConditionType>
                                <ConditionTypeName>
                                    <xsl:value-of select="ConditionTypeName"/>
                                </ConditionTypeName>
                                <ConditionRateValue>
                                    <xsl:value-of select="ConditionRateValue"/>
                                </ConditionRateValue>
                                <ConditionCurrency>
                                    <xsl:value-of select="ConditionCurrency"/>
                                </ConditionCurrency>
                                <xsl:if test="ConditionQuantity">
                                    <ConditionQuantity>
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of select="ConditionQuantity/@unitCode"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="ConditionQuantity"/>
                                    </ConditionQuantity>
                                </xsl:if>
                            </PricingElements>
                        </xsl:for-each>
                        <xsl:for-each select="TextCollection">
                            <TextCollection>
                                <ContentText>
                                    <xsl:attribute name="languageCode">
                                        <xsl:value-of select="ContentText/@languageCode"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="ContentText"/>
                                </ContentText>
                                <TypeCode>
                                    <xsl:value-of select="TypeCode"/>
                                </TypeCode>
                                <MimeType>
                                    <xsl:value-of select="MimeType"/>
                                </MimeType>
                            </TextCollection>
                        </xsl:for-each>
                        <xsl:for-each select="Attachment">
                            <Attachment>
                                <xsl:attribute name="FileName">
                                    <xsl:value-of select="@FileName"/>
                                </xsl:attribute>
                                <xsl:attribute name="FileSize">
                                    <xsl:value-of select="@FileSize"/>
                                </xsl:attribute>
                                <xsl:attribute name="MimeType">
                                    <xsl:value-of select="@MimeType"/>
                                </xsl:attribute>
                                <xop:Include>
                                    <xsl:attribute name="href">
                                        <xsl:value-of
                                            select="."/>
                                    </xsl:attribute>
                                    <xsl:value-of select="namespace-uri(xop)"/>
                                </xop:Include>
                            </Attachment>
                        </xsl:for-each>
                    </SupplierQuotationItem>
                </xsl:for-each>
            </CentralSupplierQuotationS4>
        </n0:CentralSupplierQuotationS4Request>
    </xsl:template>
    <!--   Below code is added because platform will add Combined/AttachmentList to the
    after mapping file. To remove this content below code is used.-->
    <xsl:template match="//Combined/AttachmentList"></xsl:template>
</xsl:stylesheet>
