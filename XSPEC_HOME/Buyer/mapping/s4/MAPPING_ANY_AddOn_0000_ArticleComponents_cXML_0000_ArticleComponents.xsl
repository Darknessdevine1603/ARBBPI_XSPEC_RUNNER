<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="art"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <!--      <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/> -->
   <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/> 
    <xsl:variable name="v_Article">
        <xsl:choose>
            <xsl:when
                test="exists(ARBCIGR_BOMMAT/IDOC/E1STZUM/E1MASTM/MATNR_LONG)">
                <xsl:value-of select="ARBCIGR_BOMMAT/IDOC/E1STZUM/E1MASTM/MATNR_LONG"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ARBCIGR_BOMMAT/IDOC/E1STZUM/E1MASTM/MATNR"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="ARBCIGR_BOMMAT/IDOC">
        <ArticleMaster>            
            <xsl:attribute name="RequestType">
                <xsl:value-of select="'BOM'"/>                
            </xsl:attribute>
            <!-- Message details of Article Master -->
            <xsl:apply-templates select="EDI_DC40"/>
            <Article>
                <BasicData>
                    <xsl:apply-templates select="E1STZUM/E1MASTM"/>         
                </BasicData>
                <xsl:apply-templates select="E1STZUM/E1STPOM[MENGE_C > 0]"/>
            </Article>
        </ArticleMaster>
    </xsl:template>

    <!--Message details-->
    <xsl:template match="EDI_DC40">
        <MessageHeader>
            <MessageID>
                <xsl:value-of select="DOCNUM"/>
            </MessageID>
            <CreationDateTime>
                <xsl:call-template name="BuildTimestamp">
                    <xsl:with-param name="p_date" select="CREDAT"/>
                    <xsl:with-param name="p_time" select="CRETIM"/>
                </xsl:call-template>
            </CreationDateTime>
            <SenderBusinessSystemID>
                <xsl:value-of select="SNDPRN"/>
            </SenderBusinessSystemID>
            <RecipientBusinessSystemID>
                <xsl:value-of select="RCVPRN"/>
            </RecipientBusinessSystemID>             
        <ExternalID>
                <xsl:value-of select="../E1ARBCIG_MSG_HDR/EXTERNAL_SID"/>
            </ExternalID>
        </MessageHeader>
    </xsl:template>   
    <!--    Article number-->
    <xsl:template match="E1STZUM/E1MASTM">
        <ID>
            <xsl:value-of select="$v_Article"/>
        </ID>
    </xsl:template>
    <!--Components-->
    <xsl:template match="E1STZUM/E1STPOM">
        <xsl:variable name="v_ComponentID">
            <xsl:choose>
                <xsl:when test="exists(E1STPOM1/IDNRK_LONG)">
                    <xsl:value-of select="E1STPOM1/IDNRK_LONG"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="IDNRK"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    <Component>
            <ID>
                <xsl:value-of select="$v_ComponentID"/>
            </ID>
            <Quantity>
                <xsl:attribute name="unitOfMeasure">
                    <xsl:value-of select="MEINS"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(MENGE_C)"/>
            </Quantity>
        </Component>
    </xsl:template>
</xsl:stylesheet>
