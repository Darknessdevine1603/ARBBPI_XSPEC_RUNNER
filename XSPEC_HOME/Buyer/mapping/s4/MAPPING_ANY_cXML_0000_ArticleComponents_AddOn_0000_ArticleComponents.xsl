<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
        	<xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:param name="anERPName"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <!--    <xsl:param name="v_pd" select="'ParameterCrossreference.xml'"/>-->
    <!--    <xsl:param name="anSourceDocumentType" select="'ArticleMaster'"/>-->

    <!-- Recipient System -->
    <xsl:variable name="v_sysid" select="ArticleMaster/MessageHeader/RecipientBusinessSystemID"/>
    <!--Prepare the CrossRef path-->
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
            <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_EANCategory">
        <xsl:call-template name="ArticleMaster">
            <xsl:with-param name="p_doctype" select="'ArticleMaster'"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'EANCategory'"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_BomUsage">
        <xsl:call-template name="ArticleMaster">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_attribute" select="'BomUsage'"/>
        </xsl:call-template>
    </xsl:variable>
    <!--Get the Port Details-->
    <xsl:variable name="v_port">
        <!--Call Template for Port Name-->
        <xsl:call-template name="FillPort">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_Materia" select="upper-case(ArticleMaster/Article/BasicData/ID)"/>
    <xsl:variable name="v_MateriaExt" select="$v_Materia"/>
    <xsl:variable name="v_LotID" select="upper-case(ArticleMaster/Article/BasicData/LotID)"/>
    <xsl:template match="ArticleMaster">
        <ARBCIGR_BOMMAT>
            <IDOC>
                <xsl:attribute name="BEGIN">
                    <xsl:value-of select="'1'"/>
                </xsl:attribute>
                <EDI_DC40>
                    <xsl:attribute name="SEGMENT">
                        <xsl:value-of select="'1'"/>
                    </xsl:attribute>
                    <IDOCTYP>
                        <xsl:value-of select="'ARBCIGR_BOMMAT'"/>
                    </IDOCTYP>
                    <MESTYP>
                        <xsl:value-of select="'BOMMAT'"/>
                    </MESTYP>
                    <!--Hardcode value is been pass, actually it should be PD Entries-->
                    <SNDPOR>
                        <xsl:value-of select="$v_port"/>
                    </SNDPOR>
                    <SNDPRT>
                        <xsl:value-of select="'LS'"/>
                    </SNDPRT>
                    <SNDPRN>
                        <xsl:value-of select="MessageHeader/SenderBusinessSystemID"/>
                    </SNDPRN>
                    <RCVPRT>
                        <xsl:value-of select="'LS'"/>
                    </RCVPRT>
                    <RCVPRN>
                        <xsl:value-of select="$v_sysid"/>
                    </RCVPRN>
                    <RCVPOR>
                        <xsl:value-of select="$v_port"/>
                    </RCVPOR>
                </EDI_DC40>
                <E1STZUM>
                    <xsl:attribute name="SEGMENT">
                        <xsl:value-of select="'1'"/>
                    </xsl:attribute>
                    <MSGFN>
                        <xsl:value-of select="'005'"/>
                    </MSGFN>
                    <STLTY>
                        <xsl:value-of select="'M'"/>
                    </STLTY>
                    <E1MASTM>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <MSGFN>
                            <xsl:value-of select="'005'"/>
                        </MSGFN>
                        <MATNR>
                            <xsl:value-of select="Article/BasicData/ID"/>
                        </MATNR>
                        <MATNR_EXTERNAL>
                            <xsl:value-of select="Article/BasicData/LotID"/>
                        </MATNR_EXTERNAL>
                        <STLAN>
                            <xsl:value-of select="$v_BomUsage"/>
                        </STLAN>
                    </E1MASTM>
                    <E1STKOM>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <MSGFN>
                            <xsl:value-of select="'005'"/>
                        </MSGFN>
                        <DATUV>
                            <xsl:variable name="v_doc_date" select="string(current-date())"/>
                            <xsl:value-of
                                select="concat(substring($v_doc_date, 1, 4), substring($v_doc_date, 6, 2), substring($v_doc_date, 9, 2))"
                            />
                        </DATUV>
                    </E1STKOM>
                    <xsl:for-each select="Article/Component">
                        <E1STPOM>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <MSGFN>
                                <xsl:value-of select="'005'"/>
                            </MSGFN>
                            <IDNRK>
                                <xsl:value-of select="ID"/>
                            </IDNRK>
                            <!--For Article Item Category (Bill of Material) is "L"-->
                            <POSTP>
                                <xsl:value-of select="'L'"/>
                            </POSTP>
                            <MENGE_C>
                                <xsl:value-of select="Quantity"/>
                            </MENGE_C>
                            <MEINS>
                                <xsl:value-of select="Quantity/@unitOfMeasure"/>
                            </MEINS>
                        </E1STPOM>
                    </xsl:for-each>
                </E1STZUM>
            </IDOC>
        </ARBCIGR_BOMMAT>       
    </xsl:template>

</xsl:stylesheet>
