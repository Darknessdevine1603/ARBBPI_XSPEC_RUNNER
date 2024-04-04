<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://publications.europa.eu/resource/schema/ted/R2.0.9/reception"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<!--    <xsl:include href="../../../common/FORMAT_cXML_0000_eTendering_0000.xsl"/>-->
<!--    <xsl:include href="FORMAT_cXML_0000_eTendering_0000.xsl"/>-->
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
            <xsl:call-template name="Check_SupportVersion">
            </xsl:call-template>
            <!--    Get Addon Version-->
            <xsl:call-template name="Check_SupportVersion"> </xsl:call-template>
            <xsl:call-template name="sender">
                <xsl:with-param name="p_path" select="sender"/>
            </xsl:call-template>
            <FORM_SECTION>
                <F04_2014>
                    <xsl:attribute name="LG">
                        <xsl:value-of select="'EN'"/>
                    </xsl:attribute>
                    <xsl:attribute name="CATEGORY">
                        <xsl:value-of select="'ORIGINAL'"/>
                    </xsl:attribute>
                    <xsl:attribute name="FORM">
                        <xsl:value-of select="'F04'"/>
                    </xsl:attribute>
                    <xsl:if
                        test="string-length(normalize-space(section/field[externalId = 'LEGAL_BASIS']/value)) > 0">
                        <LEGAL_BASIS>
                            <xsl:attribute name="VALUE">
                                <xsl:value-of
                                    select="section/field[externalId = 'LEGAL_BASIS']/value"
                                />
                            </xsl:attribute>
                        </LEGAL_BASIS>
                    </xsl:if>
                    <NOTICE>
                        <xsl:attribute name="TYPE">
                            <xsl:value-of
                                select="section/field[externalId = 'TYPE']/value"
                            />
                        </xsl:attribute>
                    </NOTICE>
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
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'JOINT_PROCUREMENT_INVOLVED']/value)) > 0">
                            <JOINT_PROCUREMENT_INVOLVED/>
                        </xsl:if>
                        <xsl:if
                            test="exists(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'PROCUREMENT_LAW']/value)">
                            <PROCUREMENT_LAW>
                                <xsl:call-template name="text_line">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'PROCUREMENT_LAW']"
                                    />
                                </xsl:call-template>
                            </PROCUREMENT_LAW>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CENTRAL_PURCHASING']/value)) > 0">
                            <CENTRAL_PURCHASING/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'DOCUMENT_FULL']/value)) > 0">
                            <DOCUMENT_FULL/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'URL_DOCUMENT']/value)) > 0">
                            <URL_DOCUMENT>
                                <xsl:value-of
                                    select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'URL_DOCUMENT']/value"
                                />
                            </URL_DOCUMENT>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'ADDRESS_FURTHER_INFO_IDEM']/value)) > 0">
                            <ADDRESS_FURTHER_INFO_IDEM/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/section[externalId = 'ADDRESS_FURTHER_INFO'])) > 0">
                            <ADDRESS_FURTHER_INFO>
                                <xsl:call-template name="contract_address">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'CONTRACTING_BODY']/section/section[externalId = 'ADDRESS_FURTHER_INFO']"
                                    />
                                </xsl:call-template>
                            </ADDRESS_FURTHER_INFO>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'URL_PARTICIPATION']/value)) > 0">
                            <URL_PARTICIPATION>
                                <xsl:value-of
                                    select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'URL_PARTICIPATION']/value"
                                />
                            </URL_PARTICIPATION>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'ADDRESS_PARTICIPATION_IDEM']/value)) > 0">
                            <ADDRESS_PARTICIPATION_IDEM/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/section[externalId = 'ADDRESS_PARTICIPATION'])) > 0">
                            <ADDRESS_PARTICIPATION>
                                <xsl:call-template name="contract_address">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'CONTRACTING_BODY']/section/section[externalId = 'ADDRESS_PARTICIPATION']"
                                    />
                                </xsl:call-template>
                            </ADDRESS_PARTICIPATION>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'URL_TOOL']/value)) > 0">
                            <URL_TOOL>
                                <xsl:value-of
                                    select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'URL_TOOL']/value"
                                />
                            </URL_TOOL>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CE_ACTIVITY']/value)) > 0">
                            <CE_ACTIVITY>
                                <xsl:attribute name="VALUE">
                                    <xsl:value-of
                                        select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CE_ACTIVITY']/value"
                                    />
                                </xsl:attribute>
                            </CE_ACTIVITY>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CE_ACTIVITY_OTHER']/value)) > 0">
                            <CE_ACTIVITY_OTHER>
                                <xsl:value-of
                                    select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CE_ACTIVITY_OTHER']/value"
                                />
                            </CE_ACTIVITY_OTHER>
                        </xsl:if>
                        
                    </CONTRACTING_BODY>
    <OBJECT_CONTRACT>
                        <xsl:attribute name="ITEM">
                            
                            <xsl:value-of select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/field[externalId = 'ITEM']/value"/>
                         </xsl:attribute>
                        <TITLE>
                            <xsl:call-template name="text_line">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/field[externalId = 'TITLE']"
                                />
                            </xsl:call-template>
                        </TITLE>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/field[externalId = 'REFERENCE_NUMBER']/value)) > 0">
                            <REFERENCE_NUMBER>
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/field[externalId = 'REFERENCE_NUMBER']/value"
                                />
                            </REFERENCE_NUMBER>
                        </xsl:if>
                        <CPV_MAIN>
                            <xsl:call-template name="CPV">
                                <!--IG-37471 Begin-->
                                <!--<xsl:with-param name="p_path"
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/section[externalId = 'CPV_MAIN']/section"
                                />-->
                                <!--Removed the extra section in XPath-->
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/section[externalId = 'CPV_MAIN']"
                                />
                                <!--IG-37471 End-->
                            </xsl:call-template>
                        </CPV_MAIN>
                        <TYPE_CONTRACT>
                            <xsl:attribute name="CTYPE">
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/field[externalId = 'TYPE_CONTRACT']/value"
                                />
                            </xsl:attribute>
                        </TYPE_CONTRACT>
                        <SHORT_DESCR>
                            <xsl:call-template name="text_line">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/field[externalId = 'SHORT_DESCR']"
                                />
                            </xsl:call-template>
                        </SHORT_DESCR>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/section[externalId = 'VAL_ESTIMATED_TOTAL']/field[externalId = 'AMOUNT']/value)) > 0">
                            <VAL_ESTIMATED_TOTAL>
                                <xsl:attribute name="CURRENCY">
                                    <xsl:value-of
                                        select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/section[externalId = 'VAL_ESTIMATED_TOTAL']/field[externalId = 'CURRENCY']/value"
                                    />
                                </xsl:attribute>
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = '']/section[externalId = 'VAL_ESTIMATED_TOTAL']/field[externalId = 'AMOUNT']/value"
                                />
                            </VAL_ESTIMATED_TOTAL>
                        </xsl:if>
                        <xsl:if test="
                            string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_DIVISION']/value)) > 0">
                            <LOT_DIVISION>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_ALL']/value)) > 0">
                                    <LOT_ALL/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_MAX_NUMBER']/value)) > 0">
                                    <LOT_MAX_NUMBER>
                                        
                                        <xsl:value-of
                                            select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_MAX_NUMBER']/value"
                                        />
                                    </LOT_MAX_NUMBER>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_ONE_ONLY']/value)) > 0">
                                    <LOT_ONE_ONLY/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_MAX_ONE_TENDERER']/value)) > 0">
                                    <LOT_MAX_ONE_TENDERER>
                                        <xsl:value-of
                                            select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_MAX_ONE_TENDERER']/value"
                                        />
                                    </LOT_MAX_ONE_TENDERER>
                                </xsl:if>
                                <xsl:if
                                    test="exists(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_COMBINING_CONTRACT_RIGHT']/value)">
                                    <LOT_COMBINING_CONTRACT_RIGHT>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'LOT_COMBINING_CONTRACT_RIGHT']"
                                            />
                                        </xsl:call-template>
                                    </LOT_COMBINING_CONTRACT_RIGHT>
                                </xsl:if>
                            </LOT_DIVISION>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'NO_LOT_DIVISION']/value)) > 0">
                            <NO_LOT_DIVISION/>
                            <OBJECT_DESCR>
                                <xsl:attribute name="ITEM">
                                    <xsl:value-of select="1"/>
                                </xsl:attribute>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'TITLE']/value)) > 0">
                                    <TITLE>
                                        <xsl:value-of
                                            select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'TITLE']/value"
                                        />
                                    </TITLE>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'LOT_NO']/value)) > 0">
                                    <LOT_NO>
                                        <xsl:value-of
                                            select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'LOT_NO']/value"
                                        />
                                    </LOT_NO>
                                </xsl:if>
                                <xsl:for-each
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'CPV_ADDITIONAL']/section">
                                    <CPV_ADDITIONAL>
                                        <xsl:call-template name="CPV">
                                            <xsl:with-param name="p_path" select="."/>
                                        </xsl:call-template>
                                    </CPV_ADDITIONAL>
                                </xsl:for-each>
                                <xsl:for-each
                                    select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'n2021:NUTS']/value">
                                    <n2021:NUTS>
                                        <xsl:attribute name="CODE">
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                    </n2021:NUTS>
                                </xsl:for-each>
                                <xsl:if
                                    test="exists(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'MAIN_SITE']/value)">
                                    <MAIN_SITE>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'MAIN_SITE']"
                                            />
                                        </xsl:call-template>
                                    </MAIN_SITE>
                                </xsl:if>
                                <SHORT_DESCR>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'SHORT_DESCR']"
                                        />
                                    </xsl:call-template>
                                </SHORT_DESCR>
                                <xsl:if test="
                                    string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC'])) > 0">
                                    <AC>
                                        <xsl:for-each
                                            select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC']/section[externalId = 'AC_QUALITY']/section">
                                            <AC_QUALITY>
                                                <AC_CRITERION>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_CRITERION']/value"
                                                    />
                                                </AC_CRITERION>
                                                <AC_WEIGHTING>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_WEIGHTING']/value"
                                                    />
                                                </AC_WEIGHTING>
                                            </AC_QUALITY>
                                        </xsl:for-each>
                                        <xsl:for-each
                                            select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC']/section[externalId = 'AC_COST']/section">
                                            <AC_COST>
                                                <AC_CRITERION>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_CRITERION']/value"
                                                    />
                                                </AC_CRITERION>
                                                <AC_WEIGHTING>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_WEIGHTING']/value"
                                                    />
                                                </AC_WEIGHTING>
                                            </AC_COST>
                                        </xsl:for-each>
                                        <xsl:if test="
                                            string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC']/section[externalId = 'AC_PRICE']/field[externalId = 'AC_WEIGHTING']/value)) > 0">
                                            <AC_PRICE>
                                                <AC_WEIGHTING>
                                                    <xsl:value-of
                                                        select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC']/section[externalId = 'AC_PRICE']/field[externalId = 'AC_WEIGHTING']/value"
                                                    />
                                                </AC_WEIGHTING>
                                            </AC_PRICE>
                                        </xsl:if>
                                        <!--                                        For simmple structure of AC_PRICE with value "Yes "IG-37327-->
                                        <!--IG-41549 : Incorrect XPath has been fixed-->
                                        <xsl:if test="
                                            string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC']/field[externalId = 'AC_PRICE']/value)) > 0">
                                            <AC_PRICE/>
                                            
                                        </xsl:if>
                                        <xsl:if test="
                                            string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC']/field[externalId = 'AC_PROCUREMENT_DOC']/value)) > 0">
                                            <AC_PROCUREMENT_DOC/>
                                            
                                        </xsl:if>
                                    </AC>
                                </xsl:if>
                                
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'OPTIONS']/value)) > 0">
                                    <OPTIONS/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'NO_OPTIONS']/value)) > 0">
                                    <NO_OPTIONS/>
                                </xsl:if>
                                <xsl:if
                                    test="exists(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'OPTIONS_DESCR']/value)">
                                    <OPTIONS_DESCR>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'OPTIONS_DESCR']"
                                            />
                                        </xsl:call-template>
                                    </OPTIONS_DESCR>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'ECATALOGUE_REQUIRED']/value)) > 0">
                                    <ECATALOGUE_REQUIRED/>
                                </xsl:if>
                                <xsl:if
                                    test="exists(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'EU_PROGR_RELATED']/value)">
                                    <EU_PROGR_RELATED>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'EU_PROGR_RELATED']"
                                            />
                                        </xsl:call-template>
                                    </EU_PROGR_RELATED>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'NO_EU_PROGR_RELATED']/value)) > 0">
                                    <NO_EU_PROGR_RELATED/>
                                </xsl:if>
                                <xsl:if
                                    test="exists(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'INFO_ADD']/value)">
                                    <INFO_ADD>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/field[externalId = 'INFO_ADD']"
                                            />
                                        </xsl:call-template>
                                    </INFO_ADD>
                                </xsl:if>
                            </OBJECT_DESCR>
                        </xsl:if>

                        <xsl:for-each
                            select="section[externalId = 'LOTS']/section[externalId = 'LOT']">
                            <OBJECT_DESCR>
                                <xsl:attribute name="ITEM">
                                    <xsl:value-of select="field[externalId = 'LOT_NO']/value"/>
                                </xsl:attribute>
                                <xsl:if
                                    test="exists(field[externalId = 'TITLE']/value)">
                                    <TITLE>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="field[externalId = 'TITLE']"/>
                                        </xsl:call-template>
                                    </TITLE>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'LOT_NO']/value)) > 0">
                                    <LOT_NO>
                                        <xsl:value-of select="field[externalId = 'LOT_NO']/value"/>
                                    </LOT_NO>
                                </xsl:if>
                                <xsl:for-each
                                    select="section[externalId = 'CPV_ADDITIONAL']/section">
                                    <CPV_ADDITIONAL>
                                        <xsl:call-template name="CPV">
                                            <xsl:with-param name="p_path" select="."/>
                                        </xsl:call-template>
                                    </CPV_ADDITIONAL>
                                </xsl:for-each>
                                <xsl:for-each select="field[externalId = 'n2021:NUTS']/value">
                                    <n2021:NUTS>
                                        <xsl:attribute name="CODE">
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                    </n2021:NUTS>
                                </xsl:for-each>
                                <xsl:if
                                    test="exists(field[externalId = 'MAIN_SITE']/value)">
                                    <MAIN_SITE>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="field[externalId = 'MAIN_SITE']"/>
                                        </xsl:call-template>
                                    </MAIN_SITE>
                                </xsl:if>
                                <SHORT_DESCR>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="field[externalId = 'SHORT_DESCR']"/>
                                    </xsl:call-template>
                                </SHORT_DESCR>
                                <xsl:if test="
                                    string-length(normalize-space(section[externalId = 'AC'])) > 0">
                                    <AC>
                                        <xsl:for-each
                                            select="section[externalId = 'AC']/section[externalId = 'AC_QUALITY']/section">
                                            <AC_QUALITY>
                                                <AC_CRITERION>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_CRITERION']/value"
                                                    />
                                                </AC_CRITERION>
                                                <AC_WEIGHTING>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_WEIGHTING']/value"
                                                    />
                                                </AC_WEIGHTING>
                                            </AC_QUALITY>
                                        </xsl:for-each>
                                        <xsl:for-each
                                            select="section[externalId = 'AC']/section[externalId = 'AC_COST']/section">
                                            <AC_COST>
                                                <AC_CRITERION>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_CRITERION']/value"
                                                    />
                                                </AC_CRITERION>
                                                <AC_WEIGHTING>
                                                    <xsl:value-of
                                                        select="field[externalId = 'AC_WEIGHTING']/value"
                                                    />
                                                </AC_WEIGHTING>
                                            </AC_COST>
                                        </xsl:for-each>
                                        <xsl:if test="
                                            string-length(normalize-space(section[externalId = 'AC']/section[externalId = 'AC_PRICE']/field)) > 0">
                                            <AC_PRICE>
                                                <AC_WEIGHTING>
                                                    <xsl:value-of
                                                        select="section[externalId = 'AC']/section[externalId = 'AC_PRICE']/field[externalId = 'AC_WEIGHTING']/value"
                                                    />
                                                </AC_WEIGHTING>
                                            </AC_PRICE>
                                        </xsl:if>
                                        <!--                                        For simmple structure of AC_PRICE with value "Yes "IG-37327-->
                                        <xsl:if test="
                                            string-length(normalize-space(section[externalId = 'AC']/field[externalId = 'AC_PRICE']/value)) > 0">
                                            <AC_PRICE/>
                                            
                                        </xsl:if>
                                        <xsl:if test="
                                            string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section[externalId = 'OBJECT_DESCR']/section[externalId = 'AC']/field[externalId = 'AC_PROCUREMENT_DOC']/value)) > 0">
                                            <AC_PROCUREMENT_DOC/>
                                            
                                        </xsl:if>
                                    </AC>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'VAL_OBJECT'])) > 0">
                                    <VAL_OBJECT>
                                        <xsl:attribute name="CURRENCY">
                                            <xsl:value-of
                                                select="section[externalId = 'VAL_OBJECT']/field[externalId = 'CURRENCY']/value"
                                            />
                                        </xsl:attribute>
                                        <xsl:value-of
                                            select="section[externalId = 'VAL_OBJECT']/field[externalId = 'AMOUNT']/value"
                                        />
                                    </VAL_OBJECT>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'DURATION']/value)) > 0">
                                    <DURATION>
                                        <xsl:attribute name="TYPE">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="string-length(normalize-space(field[externalId = 'MONTH']/value)) > 0">
                                                    <xsl:value-of select="'MONTH'"/>
                                                </xsl:when>
                                                <xsl:when
                                                    test="string-length(normalize-space(field[externalId = 'DAY']/value)) > 0">
                                                    <xsl:value-of select="'DAY'"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="field[externalId = 'DURATION']/value"
                                        />
                                    </DURATION>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'DATE_START']/value)) > 0">
                                    <DATE_START>
                                        <xsl:value-of
                                            select="field[externalId = 'DATE_START']/value"/>
                                    </DATE_START>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'DATE_END']/value)) > 0">
                                    <DATE_END>
                                        <xsl:value-of select="field[externalId = 'DATE_END']/value"
                                        />
                                    </DATE_END>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'RENEWAL']/value)) > 0">
                                    <RENEWAL/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'NO_RENEWAL']/value)) > 0">
                                    <NO_RENEWAL/>
                                </xsl:if>
                                <xsl:if
                                    test="exists(field[externalId = 'RENEWAL_DESCR']/value)">
                                    <RENEWAL_DESCR>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="field[externalId = 'RENEWAL_DESCR']"/>
                                        </xsl:call-template>
                                    </RENEWAL_DESCR>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'ACCEPTED_VARIANTS']/value)) > 0">
                                    <ACCEPTED_VARIANTS/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'NO_ACCEPTED_VARIANTS']/value)) > 0">
                                    <NO_ACCEPTED_VARIANTS/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'OPTIONS']/value)) > 0">
                                    <OPTIONS/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'NO_OPTIONS']/value)) > 0">
                                    <NO_OPTIONS/>
                                </xsl:if>
                                <xsl:if
                                    test="exists(field[externalId = 'OPTIONS_DESCR']/value)">
                                    <OPTIONS_DESCR>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="field[externalId = 'OPTIONS_DESCR']"/>
                                        </xsl:call-template>
                                    </OPTIONS_DESCR>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'ECATALOGUE_REQUIRED']/value)) > 0">
                                    <ECATALOGUE_REQUIRED/>
                                </xsl:if>
                                <xsl:if
                                    test="exists(field[externalId = 'EU_PROGR_RELATED']/value)">
                                    <EU_PROGR_RELATED>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="field[externalId = 'EU_PROGR_RELATED']"/>
                                        </xsl:call-template>
                                    </EU_PROGR_RELATED>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(field[externalId = 'NO_EU_PROGR_RELATED']/value)) > 0">
                                    <NO_EU_PROGR_RELATED/>
                                </xsl:if>
                                <xsl:if
                                    test="exists(field[externalId = 'INFO_ADD']/value)">
                                    <INFO_ADD>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="field[externalId = 'INFO_ADD']"/>
                                        </xsl:call-template>
                                    </INFO_ADD>
                                </xsl:if>
                            </OBJECT_DESCR>
                        </xsl:for-each>
                          <xsl:if
                              test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'DATE_PUBLICATION_NOTICE']/value)) > 0">
                              <DATE_PUBLICATION_NOTICE>
                                  <xsl:value-of
                                      select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'DATE_PUBLICATION_NOTICE']/value"
                                  />
                              </DATE_PUBLICATION_NOTICE>
                          </xsl:if>
                    </OBJECT_CONTRACT>                  
                    <!--IG-41551: Replaced string-length check by exist()-->
                    <xsl:if
                        test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'SUITABILITY']/value)">
                        <LEFTI>
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'SUITABILITY']/value)">
                                <SUITABILITY>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'SUITABILITY']"
                                        />
                                    </xsl:call-template>
                                </SUITABILITY>
                            </xsl:if>
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'ECONOMIC_FINANCIAL_INFO']/value)">
                                <ECONOMIC_FINANCIAL_INFO>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'ECONOMIC_FINANCIAL_INFO']"
                                        />
                                    </xsl:call-template>
                                </ECONOMIC_FINANCIAL_INFO>
                            </xsl:if>
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'ECONOMIC_FINANCIAL_MIN_LEVEL']/value)">
                                <ECONOMIC_FINANCIAL_MIN_LEVEL>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'ECONOMIC_FINANCIAL_MIN_LEVEL']"
                                        />
                                    </xsl:call-template>
                                </ECONOMIC_FINANCIAL_MIN_LEVEL>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(section[externalId = 'LEFTI']/section/field[externalId = 'TECHNICAL_CRITERIA_DOC']/value)) > 0">
                                <TECHNICAL_CRITERIA_DOC/>
                            </xsl:if> 
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'TECHNICAL_PROFESSIONAL_INFO']/value)">
                                <TECHNICAL_PROFESSIONAL_INFO>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'TECHNICAL_PROFESSIONAL_INFO']"
                                        />
                                    </xsl:call-template>
                                </TECHNICAL_PROFESSIONAL_INFO>
                            </xsl:if>
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'TECHNICAL_PROFESSIONAL_MIN_LEVEL']/value)">
                                <TECHNICAL_PROFESSIONAL_MIN_LEVEL>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'TECHNICAL_PROFESSIONAL_MIN_LEVEL']"
                                        />
                                    </xsl:call-template>
                                </TECHNICAL_PROFESSIONAL_MIN_LEVEL>
                            </xsl:if>
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'RULES_CRITERIA']/value)">
                            <RULES_CRITERIA>
                                <xsl:call-template name="text_line">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'LEFTI']/section/field[externalId = 'RULES_CRITERIA']"
                                    />
                                </xsl:call-template>
                            </RULES_CRITERIA>
                            </xsl:if>   
                            <xsl:if
                                test="string-length(normalize-space(section[externalId = 'LEFTI']/section/field[externalId = 'RESTRICTED_SHELTERED_WORKSHOP']/value)) > 0">
                                <RESTRICTED_SHELTERED_WORKSHOP/>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(section[externalId = 'LEFTI']/section/field[externalId = 'RESTRICTED_SHELTERED_PROGRAM']/value)) > 0">
                                <RESTRICTED_SHELTERED_PROGRAM/>
                            </xsl:if>
                            <xsl:if
                                test="section[externalId = 'LEFTI']/section/field[externalId = 'PARTICULAR_PROFESSION']/value">
                                <PARTICULAR_PROFESSION>
                                    <xsl:attribute name="CTYPE">
                                        <xsl:value-of
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'PARTICULAR_PROFESSION']/value"
                                        />
                                    </xsl:attribute>
                                </PARTICULAR_PROFESSION>
                            </xsl:if>
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'PERFORMANCE_CONDITIONS']/value)">
                                <PERFORMANCE_CONDITIONS>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'PERFORMANCE_CONDITIONS']"
                                        />
                                    </xsl:call-template>
                                </PERFORMANCE_CONDITIONS>
                            </xsl:if>
                            <xsl:if
                                test="exists(section[externalId = 'LEFTI']/section/field[externalId = 'REFERENCE_TO_LAW']/value)">
                                <REFERENCE_TO_LAW>
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section[externalId = 'LEFTI']/section/field[externalId = 'REFERENCE_TO_LAW']"
                                        />
                                    </xsl:call-template>
                                </REFERENCE_TO_LAW>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(section[externalId = 'LEFTI']/section/field[externalId = 'PERFORMANCE_STAFF_QUALIFICATION']/value)) > 0">
                                <PERFORMANCE_STAFF_QUALIFICATION/>
                            </xsl:if>   
                        </LEFTI>
                    </xsl:if>
                    <PROCEDURE>
                       
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'PT_RESTRICTED']/value)) > 0">
                            <PT_RESTRICTED/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'PT_NEGOTIATED_WITH_PRIOR_CALL']/value)) > 0">
                            <PT_NEGOTIATED_WITH_PRIOR_CALL/>
                        </xsl:if>
                     
                        <xsl:if
                            test="
                            string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'FRAMEWORK']/value)) > 0 ">
                            <FRAMEWORK>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'SINGLE_OPERATOR']/value)) > 0">
                                    <SINGLE_OPERATOR/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'SEVERAL_OPERATORS']/value)) > 0">
                                    <SEVERAL_OPERATORS/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'NB_PARTICIPANTS']/value)) > 0">
                                    <NB_PARTICIPANTS>
                                        <xsl:value-of
                                            select="section[externalId = 'PROCEDURE']/section/field[externalId = 'NB_PARTICIPANTS']/value"
                                        />
                                    </NB_PARTICIPANTS>
                                </xsl:if>
                                <xsl:if
                                    test="exists(section[externalId = 'PROCEDURE']/section/field[externalId = 'JUSTIFICATION']/value)">
                                    <JUSTIFICATION>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="section[externalId = 'PROCEDURE']/section/field[externalId = 'JUSTIFICATION']"
                                            />
                                        </xsl:call-template>
                                    </JUSTIFICATION>
                                </xsl:if>
                            </FRAMEWORK>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'DPS']/value)) > 0">
                            <DPS/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'DPS_ADDITIONAL_PURCHASERS']/value)) > 0">
                            <DPS_ADDITIONAL_PURCHASERS/>
                        </xsl:if>
                      
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'EAUCTION_USED']/value)) > 0">
                            <EAUCTION_USED/>
                        </xsl:if>
                        <xsl:if
                            test="exists(section[externalId = 'PROCEDURE']/section/field[externalId = 'INFO_ADD_EAUCTION']/value)">
                            <INFO_ADD_EAUCTION>
                                <xsl:call-template name="text_line">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'PROCEDURE']/section/field[externalId = 'INFO_ADD_EAUCTION']"
                                    />
                                </xsl:call-template>
                            </INFO_ADD_EAUCTION>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'CONTRACT_COVERED_GPA']/value)) > 0">
                            <CONTRACT_COVERED_GPA/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'NO_CONTRACT_COVERED_GPA']/value)) > 0">
                            <NO_CONTRACT_COVERED_GPA/>
                        </xsl:if>
                       
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'DATE_RECEIPT_TENDERS']/value)) > 0">
                            <DATE_RECEIPT_TENDERS>
                                <xsl:value-of
                                    select="section[externalId = 'PROCEDURE']/section/field[externalId = 'DATE_RECEIPT_TENDERS']/value"
                                />
                            </DATE_RECEIPT_TENDERS>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'TIME_RECEIPT_TENDERS']/value)) > 0">
                            <TIME_RECEIPT_TENDERS>
                                <xsl:value-of
                                    select="section[externalId = 'PROCEDURE']/section/field[externalId = 'TIME_RECEIPT_TENDERS']/value"
                                />
                            </TIME_RECEIPT_TENDERS>
                        </xsl:if>
                              
                       <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'LANGUAGES']/value)) > 0">
                            <LANGUAGES>
                                <LANGUAGE>
                                    <xsl:attribute name="VALUE">
                                        <xsl:value-of
                                            select="section[externalId = 'PROCEDURE']/section/field[externalId = 'LANGUAGES']/value"
                                        />
                                    </xsl:attribute>
                                </LANGUAGE>
                            </LANGUAGES>
                        </xsl:if>    
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'DATE_AWARD_SCHEDULED']/value)) > 0">
                            <DATE_AWARD_SCHEDULED>
                                <xsl:value-of
                                    select="section[externalId = 'PROCEDURE']/section/field[externalId = 'DATE_AWARD_SCHEDULED']/value"
                                />
                            </DATE_AWARD_SCHEDULED>
                        </xsl:if>
                    </PROCEDURE>
                    <COMPLEMENTARY_INFO>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'EORDERING']/value)) > 0">
                            <EORDERING/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'EINVOICING']/value)) > 0">
                            <EINVOICING/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'EPAYMENT']/value)) > 0">
                            <EPAYMENT/>
                        </xsl:if>
                        <xsl:if
                            test="exists(section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'INFO_ADD']/value)">
                            <INFO_ADD>
                                <xsl:call-template name="text_line">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'INFO_ADD']"
                                    />
                                </xsl:call-template>
                            </INFO_ADD>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_REVIEW_BODY'])) > 0">
                        <ADDRESS_REVIEW_BODY>
                            <xsl:call-template name="comp_address">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_REVIEW_BODY']"
                                />
                            </xsl:call-template>
                        </ADDRESS_REVIEW_BODY>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_MEDIATION_BODY'])) > 0">
                            <ADDRESS_MEDIATION_BODY>
                                <xsl:call-template name="comp_address">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_MEDIATION_BODY']"
                                    />
                                </xsl:call-template>
                            </ADDRESS_MEDIATION_BODY>
                        </xsl:if>
                        <xsl:if
                            test="exists(section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'REVIEW_PROCEDURE']/value)">
                            <REVIEW_PROCEDURE>
                                <xsl:call-template name="text_line">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'REVIEW_PROCEDURE']"
                                    />
                                </xsl:call-template>
                            </REVIEW_PROCEDURE>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_REVIEW_INFO'])) > 0">
                            <ADDRESS_REVIEW_INFO>
                                <xsl:call-template name="comp_address">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_REVIEW_INFO']"
                                    />
                                </xsl:call-template>
                            </ADDRESS_REVIEW_INFO>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'DATE_DISPATCH_NOTICE']/value)) > 0">
                            <DATE_DISPATCH_NOTICE>
                                <xsl:value-of
                                    select="section[externalId = 'COMPLEMENTARY_INFO']/section/field[externalId = 'DATE_DISPATCH_NOTICE']/value"
                                />
                            </DATE_DISPATCH_NOTICE>
                        </xsl:if>
                    </COMPLEMENTARY_INFO>
                </F04_2014>
            </FORM_SECTION>
        </TED_ESENDERS>
    </xsl:template>
</xsl:stylesheet>                   
            
