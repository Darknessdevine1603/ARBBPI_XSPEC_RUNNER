<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="#all" xmlns:n0="http://sap.com/xi/ARBCIG1">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
        <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <!--Parameters-->
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:param name="anERPName"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anSharedSecrete"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="cXMLAttachments"/>
    <xsl:param name="attachSeparator" select="'\|'"/>
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_DefaultLang">
<!--Fill language ISO Code from Material Description Field. Fill from default only if this is empty-->
<!--This was discussed that Material description will always have an ISO value coded.-->
        <xsl:choose>
            <xsl:when test="string-length(//n0:QualityInspectionDecisionMsg/QualityInspectionDecisionDetail/UsageDecisionDescription/@languageCode) > 0">
                
                <xsl:value-of select="//n0:QualityInspectionDecisionMsg/QualityInspectionDecisionDetail/UsageDecisionDescription/@languageCode"/>   
            </xsl:when>
            <xsl:otherwise>
<!--Just in case we do not get a value ,then call FilldefaultLang-->
                <xsl:call-template name="FillDefaultLang">
                    <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                </xsl:call-template>             
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="n0:QualityInspectionDecisionMsg">
        <Combined>
            <Payload>
                <cXML>
                    <xsl:attribute name="payloadID" select="$anPayloadID"/>
                    <xsl:attribute name="timestamp" select="current-dateTime()"/>
                    <Header>
                        <From>
                            <xsl:call-template name="MultiERPTemplateOut">
                                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
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
                                    <xsl:value-of select="QualityInspectionDecisionDetail/VendorID"/>
                                </Identity>
                            </Credential>
                        </To>
                        <Sender>
                            <Credential domain="NetworkID">
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$anProviderANID"/>
                                </Identity>
                            </Credential>
                            <UserAgent>CIG</UserAgent>
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
                        <QualityInspectionDecisionRequest>
                            <QualityInspectionDecisionDetail>
                                <xsl:attribute name="decisionID" select="QualityInspectionDecisionDetail/ObjectNo"/>  
                                <xsl:variable name="v_InsDate">
                                    <!--Extract date from InspectionLotDate field that has both Date and time from ERP  -->
                                    <xsl:value-of
                                        select="substring(QualityInspectionDecisionDetail/UserDecisionDateTime, 1, 8)"/>                                    
                                </xsl:variable>
                                <xsl:variable name="v_InsTime">
                                        <!--Extract Time from InspectionLotDate field that has both Date and time from ERP  -->
                                        <xsl:value-of
                                            select="substring(QualityInspectionDecisionDetail/UserDecisionDateTime, 10, 6)"/>
                                </xsl:variable>  
                                <xsl:attribute name="decisionDate">
                                    <!--Convert to AN Readable format-->
                                    <xsl:call-template name="ANDateTime">
                                        <xsl:with-param name="p_date" select="$v_InsDate"/>
                                        <xsl:with-param name="p_time" select="$v_InsTime"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:if test="QualityInspectionDecisionDetail/CodeValuation = 'A'">
                                    <xsl:attribute name="status">
                                        <xsl:value-of select="'accepted'"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="QualityInspectionDecisionDetail/CodeValuation = 'R'">
                                    <xsl:attribute name="status">
                                        <xsl:value-of select="'rejected'"/>
                                    </xsl:attribute> 
                                </xsl:if>
                                <xsl:attribute name="createdBy" select="QualityInspectionDecisionDetail/ChangedByUser"/>
                                <xsl:attribute name="qualityScore" select="normalize-space(QualityInspectionDecisionDetail/QualityScore)"/>
                                <QualityInspectionRequestReference>
                                    <xsl:attribute name="inspectionID" select="QualityInspectionDecisionDetail/InspectionLotId"/>
                                    <xsl:variable name="v_InsDate">
                                        <!--Extract date from InspectionLotDate field that has both Date and time from ERP  -->
                                        <xsl:value-of
                                            select="substring(QualityInspectionDecisionDetail/InspectionDate, 1, 8)"
                                        />
                                    </xsl:variable>
                                    <xsl:variable name="v_InsTime">
                                        <!--Extract Time from InspectionLotDate field that has both Date and time from ERP  -->
                                        <xsl:value-of
                                            select="substring(QualityInspectionDecisionDetail/InspectionDate, 10, 6)"
                                        />
                                    </xsl:variable>
                                    <xsl:attribute name="inspectionDate">
                                        <!--Convert to AN Readable format-->
                                        <xsl:call-template name="ANDateTime">
                                            <xsl:with-param name="p_date" select="$v_InsDate"/>
                                            <xsl:with-param name="p_time" select="$v_InsTime"/>
                                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </QualityInspectionRequestReference>
                                <QualityInspectionLotStock>
                                    <UnrestrictedUseQuantity>
                                        <xsl:attribute name="quantity" select="QualityInspectionDecisionDetail/QuantityAvailable"/>
                                        <UnitOfMeasure>
                                            <!--Unit Code has to be converted to AN format using template UOMTemplate_OUT instead of direct mapping-->
                                            <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput"
                                                    select="QualityInspectionDecisionDetail/QuantityAvailable/@unitCode"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anSupplierANID"/>
                                            </xsl:call-template>
                                        </UnitOfMeasure>
                                    </UnrestrictedUseQuantity>
                                    <ScrapQuantity>
                                        <xsl:attribute name="quantity" select="QualityInspectionDecisionDetail/QuantityScrap"/>
                                        <UnitOfMeasure>
                                            <!--Unit Code has to be converted to AN format using template UOMTemplate_OUT instead of direct mapping-->
                                            <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput"
                                                    select="QualityInspectionDecisionDetail/QuantityScrap/@unitCode"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anSupplierANID"/>
                                            </xsl:call-template>
                                        </UnitOfMeasure>
                                    </ScrapQuantity>
                                    <SampleUsageQuantity>
                                        <xsl:attribute name="quantity" select="QualityInspectionDecisionDetail/QuantitySample"/>
                                        <UnitOfMeasure>
                                            <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput"
                                                    select="QualityInspectionDecisionDetail/QuantitySample/@unitCode"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anSupplierANID"/>
                                            </xsl:call-template>
                                        </UnitOfMeasure>
                                    </SampleUsageQuantity>
                                    <BlockedQuantity>
                                        <xsl:attribute name="quantity" select="QualityInspectionDecisionDetail/QuantityBlocked"/>
                                        <UnitOfMeasure>
                                            <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput"
                                                    select="QualityInspectionDecisionDetail/QuantityBlocked/@unitCode"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anSupplierANID"/>
                                            </xsl:call-template>
                                        </UnitOfMeasure>
                                    </BlockedQuantity>
                                    <NewMaterialQuantity>
                                        <xsl:attribute name="quantity" select="QualityInspectionDecisionDetail/QuantityNewMaterial"/>
                                            <UnitOfMeasure>
                                                <xsl:call-template name="UOMTemplate_Out">
                                                    <xsl:with-param name="p_UOMinput"
                                                        select="QualityInspectionDecisionDetail/QuantityNewMaterial/@unitCode"/>
                                                    <xsl:with-param name="p_anERPSystemID"
                                                        select="$anERPSystemID"/>
                                                    <xsl:with-param name="p_anSupplierANID"
                                                        select="$anSupplierANID"/>
                                                </xsl:call-template>    
                                            </UnitOfMeasure>
                                    </NewMaterialQuantity>
                                    <ReserveQuantity>
                                        <xsl:attribute name="quantity" select="QualityInspectionDecisionDetail/QuantityReserve"/>
                                        <UnitOfMeasure>
                                            <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput"
                                                    select="QualityInspectionDecisionDetail/QuantityReserve/@unitCode"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anSupplierANID"/>
                                            </xsl:call-template>     
                                        </UnitOfMeasure>
                                    </ReserveQuantity>
                                    <ReturnQuantity>
                                        <xsl:attribute name="quantity" select="QualityInspectionDecisionDetail/QuantityReturnedToVendor"/>
                                        <UnitOfMeasure>
                                            <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput"
                                                    select="QualityInspectionDecisionDetail/QuantityReturnedToVendor/@unitCode"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anSupplierANID"/>
                                            </xsl:call-template>    
                                        </UnitOfMeasure>
                                    </ReturnQuantity>
                                </QualityInspectionLotStock>
                                <Description>
                                    <xsl:attribute name="xml:lang"
                                        select="$v_DefaultLang"/>
                                    <xsl:value-of select="QualityInspectionDecisionDetail/UsageDecisionDescription"/>
                                    <ShortName>
                                        <xsl:value-of select="QualityInspectionDecisionDetail/UsageDecisionDescription"/>
                                    </ShortName>
                                </Description> 
                              </QualityInspectionDecisionDetail>
                        </QualityInspectionDecisionRequest>
                    </Request>
                </cXML>
            </Payload>
        </Combined>
    </xsl:template>
</xsl:stylesheet>
