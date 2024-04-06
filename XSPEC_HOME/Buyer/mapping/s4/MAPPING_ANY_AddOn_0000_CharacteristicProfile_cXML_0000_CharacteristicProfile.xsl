<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="cp"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>    
    <xsl:template match="ARBCIGR_CLSMAS/IDOC">
        <CharacteristicProfile>
            <MessageHeader>
                <MessageID><xsl:value-of select="EDI_DC40/DOCNUM"/></MessageID>
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
            <Class>
                <ClassType>
                    <xsl:value-of select="E1KLAHM/KLART"/>
                </ClassType>
                <ID>
                    <xsl:value-of select="E1KLAHM/CLASS"/>
                </ID>                
                <Status>
                    <xsl:value-of select="E1KLAHM/STATU"/>
                </Status>
                <xsl:for-each select="E1KLAHM/E1KSMLM">
                    <Characteristic>
                        <CharacteristicId>
                            <xsl:value-of select="ATNAM"/>
                        </CharacteristicId>
                        <xsl:choose>
                            <xsl:when test="exists(RELEV)">
                                <RelevancyIndicator>
                                    <xsl:value-of select="RELEV"/>
                                </RelevancyIndicator>
                            </xsl:when>
                            <xsl:otherwise>
                                <RelevancyIndicator>
                                    <xsl:value-of select="'2'"/>
                                </RelevancyIndicator>
                            </xsl:otherwise>
                        </xsl:choose>
                    </Characteristic>
                </xsl:for-each>
                <Descriptions>
                    <xsl:for-each select="E1KLAHM/E1SWORM[KLPOS='01']">
                    <Description>
                        <xsl:attribute name="languageCode" select="SPRAS_ISO"/>
                        <xsl:value-of select="KSCHL"/>
                    </Description>
                    </xsl:for-each>
                </Descriptions>
            </Class>
        </CharacteristicProfile>
    </xsl:template>   
</xsl:stylesheet>
