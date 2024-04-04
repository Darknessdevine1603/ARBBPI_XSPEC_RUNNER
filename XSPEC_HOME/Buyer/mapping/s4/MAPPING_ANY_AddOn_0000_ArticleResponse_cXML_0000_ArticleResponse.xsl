<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="artRes"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="#all"
    version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
        <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>    
    <xsl:template match="ARBCIGR_ALEAUD/IDOC">
        <ArticleResponse>
            <MessageHeader>
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
            <xsl:for-each select="E1ADHDR">
                <xsl:for-each select="E1STATE">
                    <Article>
                        <MessageType>
                            <xsl:value-of select="STATYP"/>
                        </MessageType>
                        <SourcingArticleID>
                            <xsl:variable name="v_ext" select="E1PRTOB/E1ARBCIGR_HDR/VARIANT_EXTERNAL"/>
                            <xsl:choose>
                                <xsl:when test="exists($v_ext)">
                                    <xsl:value-of select="$v_ext"/>
                                </xsl:when>   
                                <xsl:otherwise>
                            <xsl:value-of select="E1PRTOB/E1ARBCIGR_HDR/LOT_ID"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </SourcingArticleID>
                        <SAPArticleID>
                            <!--Depending on the ERP system, a material can be 40char or 18char. Map the 40Char if it exists otherwise 18Char field-->
                            <xsl:variable name="v_long" select="E1PRTOB/E1ARBCIGR_HDR/VARIANT_LONG"/>
                            <xsl:variable name="v_var" select="E1PRTOB/E1ARBCIGR_HDR/VARIANT"/>
                            <xsl:variable name="v_mlong" select="E1PRTOB/E1ARBCIGR_HDR/MATNR_LONG"/>
                            <xsl:choose>                          
                             <xsl:when test="exists($v_long)">
                                    <xsl:value-of select="$v_long"/>
                                </xsl:when>                                
                                <xsl:when test="exists($v_var)">
                                    <xsl:value-of select="$v_var"/>
                                </xsl:when>
                                <xsl:when test="exists($v_mlong)">
                                    <xsl:value-of select="$v_mlong"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="E1PRTOB/E1ARBCIGR_HDR/MATNR"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </SAPArticleID>
                        <Message>
                            <!-- Concatenate each msg with a ';' -->
                            <xsl:for-each select="E1PRTOB/E1ARBCIGR_MSG">
                                <xsl:value-of select="concat(MSGTXT, ';')"/>
                            </xsl:for-each>
                        </Message>
                    </Article>
                </xsl:for-each>
            </xsl:for-each>
        </ArticleResponse>
    </xsl:template>
</xsl:stylesheet>
