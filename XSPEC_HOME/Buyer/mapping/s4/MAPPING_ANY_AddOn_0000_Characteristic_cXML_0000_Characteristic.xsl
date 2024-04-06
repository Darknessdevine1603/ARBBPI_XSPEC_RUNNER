<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="ch"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>    
    <xsl:template match="ARBCIGR_CHRMAS/IDOC">
        <Characteristic>
            <MessageHeader>
                <!-- TODO -->
                <MessageID>
                    <xsl:value-of select="EDI_DC40/DOCNUM"/>
                </MessageID>
                <CreationDateTime>
                    <xsl:call-template name="BuildTimestamp">
                        <xsl:with-param name="p_date" select="EDI_DC40/CREDAT"/>
                        <xsl:with-param name="p_time" select="EDI_DC40/CRETIM"/>
                    </xsl:call-template>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/SNDPRN"/>
                </SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/RCVPRN"/>
                </RecipientBusinessSystemID>
                <ExternalID>
                    <xsl:value-of select="E1ARBCIG_MSG_HDR/EXTERNAL_SID"/>
                </ExternalID>      
            </MessageHeader>
            <ID>
                <xsl:value-of select="E1CABNM/ATNAM"/>
            </ID>
            <Status>
                <xsl:value-of select="E1CABNM/ATMST"/>
            </Status>
            <Format>
                <DataType>
                    <xsl:value-of select="E1CABNM/ATFOR"/>
                </DataType>
                <Length>
                    <xsl:value-of select="E1CABNM/ANZST"/>
                </Length>
                <xsl:if test="exists(E1CABNM/ATFOR) and E1CABNM/ATFOR != 'CHAR'">
                    <NoOfDecimalPlaces>
                        <xsl:value-of select="E1CABNM/ANZDZ"/>
                    </NoOfDecimalPlaces>
                </xsl:if>
                <xsl:if test="E1CABNM/MSEHI">
                    <UnitOfMeasure>
                        <xsl:value-of select="E1CABNM/MSEHI"/>
                    </UnitOfMeasure>
                </xsl:if>
                <xsl:if test="exists(E1CABNM/ATKLE)">
                    <CaseSensitive>
                        <xsl:choose>
                            <xsl:when test="E1CABNM/ATKLE = 'X'">
                                <xsl:value-of select="'true'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'false'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </CaseSensitive>
                </xsl:if>
            </Format>
            <ValueAssignment>
                <xsl:attribute name="SingleValue">
                    <xsl:choose>
                        <xsl:when test="exists(E1CABNM/ATEIN) and E1CABNM/ATEIN = 'X'">
                            <xsl:value-of select="'true'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'false'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="Restrictable">
                    <xsl:choose>
                        <xsl:when test="exists(E1CABNM/ATGLA) and E1CABNM/ATGLA = 'X'">
                            <xsl:value-of select="'true'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'false'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="NegativeAllowed">
                    <xsl:choose>
                        <xsl:when test="exists(E1CABNM/ATVOR) and E1CABNM/ATVOR = 'X'">
                            <xsl:value-of select="'true'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'false'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="IntervalAllowed">
                    <xsl:choose>
                        <xsl:when test="exists(E1CABNM/ATINT) and E1CABNM/ATINT = 'X'">
                            <xsl:value-of select="'true'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'false'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="EntryRequired">
                    <xsl:choose>
                        <xsl:when test="exists(E1CABNM/ATERF) and E1CABNM/ATERF = 'X'">
                            <xsl:value-of select="'true'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'false'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </ValueAssignment>
            <Descriptions>
                <xsl:for-each select="E1CABNM/E1CABTM">
                    <Description>
                        <xsl:attribute name="languageCode" select="SPRAS_ISO"/>
                        <xsl:value-of select="ATBEZ"/>
                    </Description>
                </xsl:for-each>
            </Descriptions>
            <Values>
                <xsl:for-each select="E1CABNM/E1CAWNM">
                    <PossibleValue>
                        <xsl:choose>
                            <xsl:when test="exists(ATSTD) and ATSTD = 'X'">
                                <xsl:attribute name="Default">
                                    <xsl:value-of select="'true'"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="Default">
                                    <xsl:value-of select="'false'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="exists(ATWRT_LONG)">
                                <Value>
                                    <xsl:value-of select="ATWRT_LONG"/>
                                </Value>
                            </xsl:when>
                            <xsl:when test="exists(ATWRT)">
                                <Value>
                                    <xsl:value-of select="ATWRT"/>
                                </Value>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:for-each select="E1CAWTM">
                            <Description>
                                <xsl:attribute name="languageCode" select="SPRAS_ISO"/>
                                <xsl:value-of select="ATWTB"/>
                            </Description>
                        </xsl:for-each>
                        <xsl:if test="not(exists(ATWRT) or exists(ATWRT_LONG))">
                            <FloatingPointFrom>
                                <xsl:call-template name="RemoveScientificNotation">
                                    <xsl:with-param name="p_input" select="ATFLV"/>
                                    <xsl:with-param name="p_dataType" select="//E1CABNM/ATFOR"/>                                    
                                    <xsl:with-param name="p_dec" select="//E1CABNM/ANZDZ"/>
                                </xsl:call-template>
                            </FloatingPointFrom>
                            <xsl:if test="ATFLB > 0">
                                <FloatingPointTo>
                                    <xsl:call-template name="RemoveScientificNotation">
                                        <xsl:with-param name="p_input" select="ATFLB"/>
                                        <xsl:with-param name="p_dataType" select="//E1CABNM/ATFOR"/>                                        
                                        <xsl:with-param name="p_dec" select="//E1CABNM/ANZDZ"/>
                                    </xsl:call-template>
                                </FloatingPointTo>
                            </xsl:if>
                        </xsl:if>
                    </PossibleValue>
                </xsl:for-each>
            </Values>
        </Characteristic>
    </xsl:template>    
</xsl:stylesheet>
