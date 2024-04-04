<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://publications.europa.eu/resource/schema/ted/R2.0.9/reception"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <!--    <xsl:include href="FORMAT_cXML_0000_eTendering_0000.xsl"/>-->
    <!--    <xsl:include href="../../../common/FORMAT_cXML_0000_eTendering_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_cXML_0000_eTendering_0000.xsl"/>
    <xsl:param name="anEsenderLoginID"/>
    <xsl:template match="root">
        <TED_ESENDERS>
            <xsl:attribute name="xsi:schemaLocation">
                <xsl:value-of
                    select="'http://publications.europa.eu/resource/schema/ted/R2.0.9/reception TED_ESENDERS.xsd'"
                />
            </xsl:attribute>
            <!--    Get Addon Version-->
            <xsl:call-template name="Check_SupportVersion"/>
            <xsl:call-template name="sender">
                <xsl:with-param name="p_path" select="sender"/>
            </xsl:call-template>
            <FORM_SECTION>
                <F14_2014>
                    <xsl:attribute name="LG">
                        <xsl:value-of select="'EN'"/>
                    </xsl:attribute>
                    <xsl:attribute name="CATEGORY">
                        <xsl:value-of select="'ORIGINAL'"/>
                    </xsl:attribute>
                    <xsl:attribute name="FORM">
                        <xsl:value-of select="'F14'"/>
                    </xsl:attribute>
                    <xsl:if
                        test="string-length(normalize-space(section/field[externalId = 'LEGAL_BASIS']/value)) > 0">
                        <LEGAL_BASIS>
                            <xsl:attribute name="VALUE">
                                <xsl:value-of
                                    select="section/field[externalId = 'LEGAL_BASIS']/value"/>
                            </xsl:attribute>
                        </LEGAL_BASIS>
                    </xsl:if>
                    <CONTRACTING_BODY>
                        <ADDRESS_CONTRACTING_BODY>
                            <xsl:call-template name="contract_address">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'CONTRACTING_BODY']/section[externalId = 'ADDRESS_CONTRACTING_BODY']"
                                />
                            </xsl:call-template>
                        </ADDRESS_CONTRACTING_BODY>
                        <xsl:for-each
                            select="section[externalId = 'CONTRACTING_BODY']/section[externalId = 'ADDRESS_CONTRACTING_BODY_ADDITIONAL']">
                            <ADDRESS_CONTRACTING_BODY_ADDITIONAL>
                                <xsl:call-template name="contract_address">
                                    <xsl:with-param name="p_path" select="."/>
                                </xsl:call-template>
                            </ADDRESS_CONTRACTING_BODY_ADDITIONAL>
                        </xsl:for-each>
                    </CONTRACTING_BODY>
                    <OBJECT_CONTRACT>
                        <TITLE>
                            <xsl:call-template name="text_line">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'TITLE']"
                                />
                            </xsl:call-template>
                        </TITLE>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'REFERENCE_NUMBER']/value)) > 0">
                            <REFERENCE_NUMBER>
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'REFERENCE_NUMBER']/value"
                                />
                            </REFERENCE_NUMBER>
                        </xsl:if>
                        <CPV_MAIN>
                            <xsl:call-template name="CPV">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/section[externalId = 'CPV_MAIN']"
                                />
                            </xsl:call-template>
                        </CPV_MAIN>
                        <TYPE_CONTRACT>
                            <xsl:attribute name="CTYPE">
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'TYPE_CONTRACT']/value"
                                />
                            </xsl:attribute>
                        </TYPE_CONTRACT>
                        <SHORT_DESCR>
                            <xsl:call-template name="text_line">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'SHORT_DESCR']"
                                />
                            </xsl:call-template>
                        </SHORT_DESCR>
                    </OBJECT_CONTRACT>

                    <COMPLEMENTARY_INFO>
                        <xsl:variable name="v_complInfo"
                            select="section[externalId = 'COMPLEMENTARY_INFO']/section/field"/>
                        <xsl:if
                            test="string-length(normalize-space($v_complInfo[externalId = 'DATE_DISPATCH_NOTICE']/value)) > 0">
                            <DATE_DISPATCH_NOTICE>
                                <xsl:value-of
                                    select="$v_complInfo[externalId = 'DATE_DISPATCH_NOTICE']/value"
                                />
                            </DATE_DISPATCH_NOTICE>
                        </xsl:if>
                        <xsl:if
                            test="normalize-space($v_complInfo[externalId = 'ORIGINAL_TED_ESENDER']/value) = 'Yes'">
                            <ORIGINAL_TED_ESENDER PUBLICATION="NO"/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space($v_complInfo[externalId = 'ESENDER_LOGIN']/value)) > 0">
                            <ESENDER_LOGIN PUBLICATION="NO">
                                <xsl:value-of
                                    select="$v_complInfo[externalId = 'ESENDER_LOGIN']/value"/>
                            </ESENDER_LOGIN>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space($v_complInfo[externalId = 'CUSTOMER_LOGIN']/value)) > 0">
                            <CUSTOMER_LOGIN PUBLICATION="NO">
                                <xsl:value-of
                                    select="$v_complInfo[externalId = 'CUSTOMER_LOGIN']/value"/>
                            </CUSTOMER_LOGIN>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space($v_complInfo[externalId = 'NO_DOC_EXT']/value)) > 0">
                            <NO_DOC_EXT PUBLICATION="NO">
                                <xsl:value-of select="$v_complInfo[externalId = 'NO_DOC_EXT']/value"
                                />
                            </NO_DOC_EXT>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space($v_complInfo[externalId = 'NOTICE_NUMBER_OJ']/value)) > 0">
                            <NOTICE_NUMBER_OJ>
                                <xsl:value-of
                                    select="$v_complInfo[externalId = 'NOTICE_NUMBER_OJ']/value"/>
                            </NOTICE_NUMBER_OJ>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space($v_complInfo[externalId = 'DATE_DISPATCH_ORIGINAL']/value)) > 0">
                            <DATE_DISPATCH_ORIGINAL PUBLICATION="NO">
                                <xsl:value-of
                                    select="$v_complInfo[externalId = 'DATE_DISPATCH_ORIGINAL']/value"
                                />
                            </DATE_DISPATCH_ORIGINAL>
                        </xsl:if>
                    </COMPLEMENTARY_INFO>
                    <xsl:for-each select="section[externalId = 'CHANGES']">
                        <CHANGES>
                            <xsl:choose>
                                <xsl:when
                                    test="section/field[externalId = 'MODIFICATION_ORIGINAL']/value = 'Yes'">
                                    <MODIFICATION_ORIGINAL PUBLICATION="NO"/>
                                </xsl:when>
                                <xsl:when
                                    test="section/field[externalId = 'PUBLICATION_TED']/value = 'Yes'">
                                    <PUBLICATION_TED PUBLICATION="NO"/>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="section[externalId = 'CHANGE']">
                                    <xsl:for-each select="section[externalId = 'CHANGE']">
                                        <CHANGE>
                                            <WHERE>
                                                <SECTION>
                                                  <xsl:value-of
                                                  select="section[externalId = 'WHERE']/field[externalId = 'SECTION']/value"
                                                  />
                                                </SECTION>
                                                <xsl:if
                                                  test="string-length(normalize-space(section[externalId = 'WHERE']/field[externalId = 'LOT_NO']/value)) > 0">
                                                  <LOT_NO>
                                                  <xsl:value-of
                                                  select="section[externalId = 'WHERE']/field[externalId = 'LOT_NO']/value"
                                                  />
                                                  </LOT_NO>
                                                </xsl:if>
                                                <!--IG-41726 Begin : Generate LABEL only if it exist-->
                                                <xsl:if
                                                    test="exists(section[externalId = 'WHERE']/field[externalId = 'LABEL']/value)">
                                                    <LABEL>
                                                        <xsl:value-of
                                                            select="section[externalId = 'WHERE']/field[externalId = 'LABEL']/value"
                                                        />
                                                    </LABEL>
                                                </xsl:if>
                                                <!--IG-41726 End-->
                                            </WHERE>
                                            <!--Common content exist for OLD_VALUE and NEW_VALUE. 
                                                Hence a local template ChangeContent is introduced for code reusability-->
                                            <OLD_VALUE>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="exists(section[externalId = 'OLD_VALUE'])">
                                                  <xsl:call-template name="ChangeContent">
                                                  <xsl:with-param name="p_input"
                                                  select="'OLD_VALUE'"/>
                                                  </xsl:call-template>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <NOTHING/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </OLD_VALUE>
                                            <NEW_VALUE>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="exists(section[externalId = 'NEW_VALUE'])">
                                                  <xsl:call-template name="ChangeContent">
                                                  <xsl:with-param name="p_input"
                                                  select="'NEW_VALUE'"/>
                                                  </xsl:call-template>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <NOTHING/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </NEW_VALUE>
                                        </CHANGE>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="section/field[externalId = 'INFO_ADD']">
                                    <xsl:for-each select="section/field[externalId = 'INFO_ADD']">
                                        <INFO_ADD>
                                            <xsl:for-each select="value">
                                                <P>
                                                  <xsl:value-of select="."/>
                                                </P>
                                            </xsl:for-each>
                                        </INFO_ADD>
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                        </CHANGES>
                    </xsl:for-each>
                </F14_2014>
            </FORM_SECTION>
        </TED_ESENDERS>
    </xsl:template>
    <xsl:template name="ChangeContent">
        <xsl:param name="p_input"/>
        <xsl:for-each select="section[externalId = $p_input]/section">
            <xsl:choose>
                <xsl:when test="externalId = 'CPV_MAIN'">
                    <CPV_MAIN>
                        <CPV_CODE>
                            <xsl:attribute name="CODE" select="field[externalId = 'CPV_CODE']/value"
                            />
                        </CPV_CODE>
                        <xsl:for-each select="field[externalId = 'CPV_SUPPLEMENTARY_CODE']/value">
                            <CPV_SUPPLEMENTARY_CODE>
                                <xsl:attribute name="CODE" select="."/>
                            </CPV_SUPPLEMENTARY_CODE>
                        </xsl:for-each>
                    </CPV_MAIN>
                </xsl:when>
                <xsl:when test="externalId = 'CPV_ADDITIONAL'">
                    <xsl:for-each select="section">
                        <CPV_ADDITIONAL>
                            <CPV_CODE>
                                <xsl:attribute name="CODE"
                                    select="field[externalId = 'CPV_CODE']/value"/>
                            </CPV_CODE>
                            <xsl:for-each
                                select="field[externalId = 'CPV_SUPPLEMENTARY_CODE']/value">
                                <CPV_SUPPLEMENTARY_CODE>
                                    <xsl:attribute name="CODE" select="."/>
                                </CPV_SUPPLEMENTARY_CODE>
                            </xsl:for-each>
                        </CPV_ADDITIONAL>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <!--Begin of IG-40344-->
        <xsl:if test="exists(section[externalId = $p_input]/field[externalId = 'TEXT'])">
            <TEXT>
                <xsl:for-each
                    select="section[externalId = $p_input]/field[externalId = 'TEXT']/value">
                    <P>
                        <xsl:value-of select="."/>
                    </P>
                </xsl:for-each>
            </TEXT>
        </xsl:if>
        <!--End of IG-40344-->
        <xsl:for-each select="section[externalId = $p_input]/field[externalId = 'DATE']/value">
            <DATE>
                <xsl:value-of select="."/>
            </DATE>
            <xsl:if test="../../field[externalId = 'TIME']/value">
                <TIME>
                    <xsl:value-of select="../../field[externalId = 'TIME']/value"/>
                </TIME>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
