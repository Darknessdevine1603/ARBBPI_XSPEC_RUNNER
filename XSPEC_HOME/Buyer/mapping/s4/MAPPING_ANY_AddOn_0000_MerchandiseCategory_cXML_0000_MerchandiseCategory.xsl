<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="mc"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="ARBCIGR_WMERCAT/IDOC">
        <MerchandiseCategory xmlns:ns="mc">
            <xsl:choose>
                <!--                wwskz = 1 Merchandise Category (FALSE)-->
                <xsl:when test="(E1MC_HDR/E1ARBCIGR_REFM/WWSKZ = '1')">
                    <xsl:attribute name="MCH">
                        <xsl:value-of select="'false'"/>
                    </xsl:attribute>
                </xsl:when>
                <!--                wwskz = 0 Merchandise Hierarchy (TRUE)-->
                <xsl:when test="(E1MC_HDR/E1ARBCIGR_REFM/WWSKZ = '0')">
                    <xsl:attribute name="MCH">
                        <xsl:value-of select="'true'"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <ns:MessageHeader>
                <ns:MessageID>
                    <xsl:value-of select="EDI_DC40/DOCNUM"/>
                </ns:MessageID>
                <ns:CreationDateTime>
                    <xsl:call-template name="BuildTimestamp">
                        <xsl:with-param name="p_date" select="EDI_DC40/CREDAT"/>
                        <xsl:with-param name="p_time" select="EDI_DC40/CRETIM"/>
                    </xsl:call-template>
                </ns:CreationDateTime>
                <ns:SenderBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/SNDPRN"/>
                </ns:SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/RCVPRN"/>
                </RecipientBusinessSystemID>
                <ExternalID>
                    <xsl:value-of select="E1ARBCIG_MSG_HDR/EXTERNAL_SID"/>
                </ExternalID> 
            </ns:MessageHeader>
            <ns:ID>
                <xsl:value-of select="E1MC_HDR/MERCH_CATEG"/>
            </ns:ID>
            <xsl:if test="exists(E1MC_HDR/E1ARBCIGR_REFM/REF_MATERIAL)">
                <ns:ReferenceArticle>
                    <xsl:value-of select="E1MC_HDR/E1ARBCIGR_REFM/REF_MATERIAL"/>
                </ns:ReferenceArticle>
            </xsl:if>
            <xsl:for-each select="E1MC_HDR">
                <xsl:for-each select="E1MC_TEXT">
                    <ns:Description>
                        <xsl:attribute name="languageCode" select="LANGU_ISO"/>
                        <xsl:value-of select="MC_DESCR_LONG"/>
                    </ns:Description>
                </xsl:for-each>
                <xsl:for-each select="E1MC_CABNM">
                    <ns:Characteristic>
                        <ns:CharacteristicId>
                            <xsl:value-of select="CHARACT_NAME"/>
                        </ns:CharacteristicId>
                        <ns:RelevancyIndicator>
                            <xsl:value-of select="E1ARBCIGR_KSMLM"/>
                        </ns:RelevancyIndicator>
                        <xsl:if test="exists(E1MC_CAWNM)">
                            <ns:Values>
                                <xsl:for-each select="E1MC_CAWNM">
                                    <ns:PossibleValue>
                                        <xsl:if test="(../CHARACT_DTYPE = 'CHAR')">
                                            <ns:Value>
                                                <xsl:value-of select="CHAR_VALUE"/>
                                            </ns:Value>
                                            <xsl:for-each select="E1CAWTM">
                                                <ns:Description>
                                                  <xsl:attribute name="languageCode"
                                                  select="SPRAS_ISO"/>
                                                  <xsl:value-of select="ATWTB"/>
                                                </ns:Description>
                                            </xsl:for-each>
                                        </xsl:if>
                                        <xsl:if test="not(../CHARACT_DTYPE = 'CHAR')">
                                            <ns:FloatingPointFrom>
                                                <xsl:call-template name="RemoveScientificNotation">
                                                     <xsl:with-param name="p_input" select="FLT_VALUE_FROM"/>
                                                    <xsl:with-param name="p_dataType" select="../CHARACT_DTYPE"/>
                                                    <xsl:with-param name="p_dec" select="../NB_DEC"/>
                                                </xsl:call-template>
                                            </ns:FloatingPointFrom>
                                            <xsl:if test="ATFLB > 0">
                                                <ns:FloatingPointTo>
                                                  <xsl:call-template name="RemoveScientificNotation">
                                                        <xsl:with-param name="p_input" select="FLT_VALUE_TO"/>
                                                      <xsl:with-param name="p_dataType" select="../CHARACT_DTYPE"/>
                                                      <xsl:with-param name="p_dec" select="../NB_DEC"/>
                                                  </xsl:call-template>
                                                </ns:FloatingPointTo>
                                            </xsl:if>
                                        </xsl:if>
                                    </ns:PossibleValue>
                                </xsl:for-each>
                            </ns:Values>
                        </xsl:if>
                    </ns:Characteristic>
                </xsl:for-each>
                <xsl:for-each select="E1MC_CP">
                    <ns:CharacteristicProfile>
                        <ns:CharacteristicProfileId>
                            <xsl:value-of select="CHARACT_PROFILE"/>
                        </ns:CharacteristicProfileId>
                    </ns:CharacteristicProfile>
                </xsl:for-each>
                <xsl:if test="exists(E1ARBCIGR_HIER)">
                    <ns:MerchandisingHierarchy>
                        <xsl:for-each select="E1ARBCIGR_HIER">
                            <ns:Category>
                                <xsl:attribute name="name">
                                    <xsl:value-of select="NAME"/>
                                </xsl:attribute>
                                <xsl:attribute name="parent">
                                    <xsl:value-of select="PARENT"/>
                                </xsl:attribute>
                            </ns:Category>
                        </xsl:for-each>
                    </ns:MerchandisingHierarchy>
                </xsl:if>
            </xsl:for-each>
        </MerchandiseCategory>
    </xsl:template>
</xsl:stylesheet>
