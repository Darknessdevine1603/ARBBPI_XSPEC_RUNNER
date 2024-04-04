<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://publications.europa.eu/resource/schema/ted/R2.0.9/reception"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
<!--            <xsl:include href="../../../common/FORMAT_cXML_0000_eTendering_0000.xsl"/>-->
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
            <xsl:call-template name="sender">
                <xsl:with-param name="p_path" select="sender"/>
            </xsl:call-template>
            <FORM_SECTION>
                <F03_2014>
                    <xsl:attribute name="LG">
                        <xsl:value-of select="'EN'"/>
                    </xsl:attribute>
                    <xsl:attribute name="CATEGORY">
                        <xsl:value-of select="'ORIGINAL'"/>
                    </xsl:attribute>
                    <xsl:attribute name="FORM">
                        <xsl:value-of select="'F03'"/>
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
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_TYPE']/value)) > 0">
                            <CA_TYPE>
                                <xsl:attribute name="VALUE">
                                    <xsl:value-of
                                        select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_TYPE']/value"
                                    />
                                </xsl:attribute>
                            </CA_TYPE>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_TYPE_OTHER']/value)) > 0">
                            <CA_TYPE_OTHER>
                                <xsl:attribute name="VALUE">
                                    <xsl:value-of
                                        select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_TYPE_OTHER']/value"
                                    />
                                </xsl:attribute>
                            </CA_TYPE_OTHER>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_ACTIVITY']/value)) > 0">
                            <CA_ACTIVITY>
                                <xsl:attribute name="VALUE">
                                    <xsl:value-of
                                        select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_ACTIVITY']/value"
                                    />
                                </xsl:attribute>
                            </CA_ACTIVITY>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_ACTIVITY_OTHER']/value)) > 0">
                            <CA_ACTIVITY_OTHER>
                                <xsl:attribute name="VALUE">
                                    <xsl:value-of
                                        select="section[externalId = 'CONTRACTING_BODY']/section/field[externalId = 'CA_ACTIVITY_OTHER']/value"
                                    />
                                </xsl:attribute>
                            </CA_ACTIVITY_OTHER>
                        </xsl:if>
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
                    <xsl:if
                        test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/section[externalId = 'VAL_TOTAL']/field[externalId = 'AMOUNT']/value)) > 0">
                        <VAL_TOTAL>
                            <xsl:attribute name="CURRENCY">
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/section[externalId = 'VAL_TOTAL']/field[externalId = 'CURRENCY']/value"
                                />
                            </xsl:attribute>
                            <xsl:value-of
                                select="section[externalId = 'OBJECT_CONTRACT']/section/section[externalId = 'VAL_TOTAL']/field[externalId = 'AMOUNT']/value"
                            />
                        </VAL_TOTAL>
                    </xsl:if>
                    <xsl:if
                        test="string-length(normalize-space(section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'VAL_RANGE_TOTAL']/value)) > 0">
                        <VAL_RANGE_TOTAL>
                            <xsl:attribute name="CURRENCY">
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'VAL_RANGE_TOTAL']/value/field[externalId = 'CURRENCY']/value"
                                />
                            </xsl:attribute>
                            <LOW>
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/section[externalId = 'VAL_RANGE_TOTAL']/field[externalId = 'LOW']/value"
                                />
                            </LOW>
                            <HIGH>
                                <xsl:value-of
                                    select="section[externalId = 'OBJECT_CONTRACT']/section/field[externalId = 'VAL_RANGE_TOTAL']/value/field[externalId = 'HIGH']/value"
                                />
                            </HIGH>
                        </VAL_RANGE_TOTAL>
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
                                            string-length(normalize-space(section[externalId = 'AC']/section[externalId = 'AC_PRICE']/field[externalId = 'AC_WEIGHTING']/value)) > 0">
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
                                                string-length(normalize-space(section[externalId = 'AC']/field[externalId = 'AC_PROCUREMENT_DOC']/value)) > 0">
                                            <AC_PROCUREMENT_DOC/>
                                             
                                        </xsl:if>
                                    </AC>
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
                    </OBJECT_CONTRACT>
                    <PROCEDURE>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'PT_OPEN']/value)) > 0">
                            <PT_OPEN/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'PT_RESTRICTED']/value)) > 0">
                            <PT_RESTRICTED/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'PT_COMPETITIVE_NEGOTIATION']/value)) > 0">
                            <PT_COMPETITIVE_NEGOTIATION/>
                        </xsl:if>
                        <xsl:if
                            test="exists(section[externalId = 'PROCEDURE']/section/field[externalId = 'ACCELERATED_PROC']/value)">
                            <ACCELERATED_PROC>
                                <xsl:call-template name="text_line">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'PROCEDURE']/section/field[externalId = 'ACCELERATED_PROC']"/>
                                </xsl:call-template>
                            </ACCELERATED_PROC>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'PT_COMPETITIVE_DIALOGUE']/value)) > 0">
                            <PT_COMPETITIVE_DIALOGUE/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'PT_INNOVATION_PARTNERSHIP']/value)) > 0">
                            <PT_INNOVATION_PARTNERSHIP/>
                        </xsl:if>
<!--                        Begin of Changes IG-38474 - Added structure for PT_AWARD_CONTRACT_WITHOUT_CALL in section 4 for F03 and F06-->
                        <xsl:if
                            test="(section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL'])">                            
                            <PT_AWARD_CONTRACT_WITHOUT_CALL>
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE'])) > 0">                      
                                    <D_ACCORDANCE_ARTICLE>
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[externalId = ('D_PROC_OPEN' , 'D_PROC_RESTRICTED')]">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                      
                                                    <xsl:element name = "{$var_fieldname}"/>                                                    
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[ externalId = 'D_MANUF_FOR_RESEARCH']">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                                                    
                                                   <xsl:element name = "{$var_fieldname}"> 
                                                        <xsl:attribute name="CTYPE">
                                                            <xsl:value-of
                                                                select="value"/>
                                                        </xsl:attribute> 
                                                    </xsl:element>
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[externalId = ('D_TECHNICAL' , 'D_ARTISTIC' , 'D_PROTECT_RIGHTS')]">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                            
                                            <xsl:element name = "{$var_fieldname}"/>                                            
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[externalId = 'D_EXTREME_URGENCY' ]">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                            
                                            <xsl:element name = "{$var_fieldname}"/>                                            
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[externalId = 'D_ADD_DELIVERIES_ORDERED']">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                            
                                            <xsl:element name = "{$var_fieldname}"/>                                            
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[ externalId = 'D_REPETITION_EXISTING']">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                                                    
                                            <xsl:element name = "{$var_fieldname}"> 
                                                <xsl:attribute name="CTYPE">
                                                    <xsl:value-of
                                                        select="value"/>
                                                </xsl:attribute> 
                                            </xsl:element>
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[ externalId = 'D_CONTRACT_AWARDED_DESIGN_CONTEST']">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                                                     
                                            <xsl:element name = "{$var_fieldname}"> 
                                                <xsl:attribute name="CTYPE">
                                                    <xsl:value-of
                                                        select="value"/>
                                                </xsl:attribute> 
                                            </xsl:element>
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[ externalId = 'D_COMMODITY_MARKET']">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                                                    
                                            <xsl:element name = "{$var_fieldname}"> 
                                                <xsl:attribute name="CTYPE">
                                                    <xsl:value-of
                                                        select="value"/>
                                                </xsl:attribute> 
                                            </xsl:element>
                                        </xsl:for-each>  
                                        <xsl:for-each select = "section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/section[externalId = 'D_ACCORDANCE_ARTICLE']/field[ externalId = ('D_FROM_WINDING_PROVIDER' , 'D_FROM_LIQUIDATOR_CREDITOR' )]">
                                            <xsl:variable name="var_fieldname" select = "externalId"/>                                                                  
                                            <xsl:element name = "{$var_fieldname}"> 
                                                <xsl:attribute name="CTYPE">
                                                    <xsl:value-of
                                                        select="value"/>
                                                </xsl:attribute> 
                                            </xsl:element>
                                        </xsl:for-each>                                          
                                    </D_ACCORDANCE_ARTICLE>                                    
                                </xsl:if>   
                                <xsl:if
                                    test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/field[externalId = 'D_OUTSIDE_SCOPE']/value)) > 0">
                                    <D_OUTSIDE_SCOPE/>
                                </xsl:if>                               
                                <xsl:if
                                    test="exists(section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/field[externalId = 'D_JUSTIFICATION']/value)">
                                    <D_JUSTIFICATION>
                                <xsl:call-template name="text_line">
                                    <xsl:with-param name="p_path"
                                        select="section[externalId = 'PROCEDURE']/section/section[externalId = 'PT_AWARD_CONTRACT_WITHOUT_CALL']/section/field[externalId = 'D_JUSTIFICATION']"/>
                                </xsl:call-template>
                                    </D_JUSTIFICATION>
                                </xsl:if> 
                            </PT_AWARD_CONTRACT_WITHOUT_CALL>
                        </xsl:if>
<!--                        End of Changes IG-38474-->
                        <xsl:if
                            test="
                            string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'FRAMEWORK']/value)) > 0">
                            <FRAMEWORK/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'DPS']/value)) > 0">
                            <DPS/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'EAUCTION_USED']/value)) > 0">
                            <EAUCTION_USED/>
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
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'NOTICE_NUMBER_OJ']/value)) > 0">
                            <NOTICE_NUMBER_OJ>
                                <xsl:value-of
                                    select="section[externalId = 'PROCEDURE']/section/field[externalId = 'NOTICE_NUMBER_OJ']/value"
                                />
                            </NOTICE_NUMBER_OJ>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'TERMINATION_DPS']/value)) > 0">
                            <TERMINATION_DPS/>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'PROCEDURE']/section/field[externalId = 'TERMINATION_PIN']/value)) > 0">
                            <TERMINATION_PIN/>
                        </xsl:if>
                    </PROCEDURE>
                    <xsl:for-each select="section[externalId = 'AWARD_CONTRACT']/section[externalId = 'AWARD_CONTRACT']">
                        <AWARD_CONTRACT>
                            <xsl:attribute name="ITEM">
                                <xsl:value-of select="section/field[externalId = 'ITEM']/value"/>
                            </xsl:attribute>
                            <xsl:if
                                test="string-length(normalize-space(section/field[externalId = 'CONTRACT_NO']/value)) > 0">
                                <CONTRACT_NO>
                                    <xsl:value-of
                                        select="section/field[externalId = 'CONTRACT_NO']/value"/>
                                </CONTRACT_NO>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(section/field[externalId = 'LOT_NO']/value)) > 0">
                                <LOT_NO>
                                    <xsl:value-of
                                        select="section/field[externalId = 'LOT_NO']/value"/>
                                </LOT_NO>
                            </xsl:if>
                            <xsl:if
                                test="exists(section/field[externalId = 'TITLE']/value)">
                                <TITLE>                                
                                    <xsl:call-template name="text_line">
                                        <xsl:with-param name="p_path"
                                            select="section/field[externalId ='TITLE']"/>
                                    </xsl:call-template>
                                </TITLE>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(section/field[externalId = 'NO_AWARDED_CONTRACT']/value)) > 0">
                                <NO_AWARDED_CONTRACT>
                                       <xsl:if
                                        test="string-length(normalize-space(section/field[externalId = 'PROCUREMENT_UNSUCCESSFUL']/value)) > 0">
                                    <PROCUREMENT_UNSUCCESSFUL/>
                                    </xsl:if>
                                </NO_AWARDED_CONTRACT>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(section/field[externalId = 'AWARDED_CONTRACT']/value)) > 0">
                            <AWARDED_CONTRACT>
                                <xsl:if
                                    test="string-length(normalize-space(section/field[externalId = 'DATE_CONCLUSION_CONTRACT']/value)) > 0">
                                    <DATE_CONCLUSION_CONTRACT>
                                        <xsl:value-of
                                            select="section/field[externalId = 'DATE_CONCLUSION_CONTRACT']/value"
                                        />
                                    </DATE_CONCLUSION_CONTRACT>
                                </xsl:if>
                                <TENDERS>
                                    <NB_TENDERS_RECEIVED>
                                        <xsl:value-of
                                            select="section/field[externalId = 'NB_TENDERS_RECEIVED']/value"
                                        />
                                    </NB_TENDERS_RECEIVED>
                                    <xsl:if
                                        test="string-length(normalize-space(section/field[externalId = 'NB_TENDERS_RECEIVED_SME']/value)) > 0">
                                        <NB_TENDERS_RECEIVED_SME>
                                            <xsl:value-of
                                                select="section/field[externalId = 'NB_TENDERS_RECEIVED_SME']/value"
                                            />
                                        </NB_TENDERS_RECEIVED_SME>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(section/field[externalId = 'NB_TENDERS_RECEIVED_OTHER_EU']/value)) > 0">
                                        <NB_TENDERS_RECEIVED_OTHER_EU>
                                            <xsl:value-of
                                                select="section/field[externalId = 'NB_TENDERS_RECEIVED_OTHER_EU']/value"
                                            />
                                        </NB_TENDERS_RECEIVED_OTHER_EU>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(section/field[externalId = 'NB_TENDERS_RECEIVED_NON_EU']/value)) > 0">
                                        <NB_TENDERS_RECEIVED_NON_EU>
                                            <xsl:value-of
                                                select="section/field[externalId = 'NB_TENDERS_RECEIVED_NON_EU']/value"
                                            />
                                        </NB_TENDERS_RECEIVED_NON_EU>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(section/field[externalId = 'NB_TENDERS_RECEIVED_EMEANS']/value)) > 0">
                                        <NB_TENDERS_RECEIVED_EMEANS>
                                            <xsl:value-of
                                                select="section/field[externalId = 'NB_TENDERS_RECEIVED_EMEANS']/value"
                                            />
                                        </NB_TENDERS_RECEIVED_EMEANS>
                                    </xsl:if>
                                </TENDERS>
                                <CONTRACTORS>
                                    <xsl:if
                                        test="string-length(normalize-space(section/field[externalId = 'AWARDED_TO_GROUP']/value)) > 0">
                                        <AWARDED_TO_GROUP/>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(section/field[externalId = 'NO_AWARDED_TO_GROUP']/value)) > 0">
                                        <NO_AWARDED_TO_GROUP/>
                                    </xsl:if>
                                    <xsl:for-each
                                        select="section[externalId = 'ADDRESS_CONTRACTOR']">
                                        <CONTRACTOR>
                                            <ADDRESS_CONTRACTOR>
                                                  <xsl:call-template name="contract_address">
                                                        <xsl:with-param name="p_path" select="."/>
                                                    </xsl:call-template>
                                                
                                            </ADDRESS_CONTRACTOR>
                                            <xsl:if
                                                test="string-length(normalize-space(field[externalId = 'NO_SME']/value)) > 0">
                                                <NO_SME/>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(field[externalId = 'SME']/value)) > 0">
                                                <SME/>
                                            </xsl:if>
                                        </CONTRACTOR>
                                    </xsl:for-each>
                                </CONTRACTORS>
                                <xsl:if
                                    test="
                                        string-length(normalize-space(section/section[externalId = 'VAL_ESTIMATED_TOTAL']/field[externalId = 'AMOUNT']/value)) > 0 or
                                        string-length(normalize-space(section/section[externalId = 'VAL_TOTAL']/field[externalId = 'AMOUNT']/value)) > 0 or
                                        string-length(normalize-space(section/section[externalId = 'VAL_RANGE_TOTAL']/section[externalId = 'LOW']/field[externalId = 'CURRENCY']/value)) > 0">
                                    <VALUES>
                                        <xsl:if
                                            test="string-length(normalize-space(section/section[externalId = 'VAL_ESTIMATED_TOTAL']/field[externalId = 'AMOUNT']/value)) > 0">
                                            <VAL_ESTIMATED_TOTAL>
                                                <xsl:attribute name="CURRENCY">
                                                  <xsl:value-of
                                                      select="section/section[externalId = 'VAL_ESTIMATED_TOTAL']/field[externalId ='CURRENCY']/value"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                    select="section/section[externalId = 'VAL_ESTIMATED_TOTAL']/field[externalId = 'AMOUNT']/value"
                                                />
                                            </VAL_ESTIMATED_TOTAL>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(section/section[externalId = 'VAL_TOTAL']/field[externalId = 'AMOUNT']/value)) > 0">
                                            <VAL_TOTAL>
                                                <xsl:attribute name="CURRENCY">
                                                  <xsl:value-of
                                                      select="section/section[externalId = 'VAL_TOTAL']/field[externalId = 'CURRENCY']/value"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                    select="section/section[externalId = 'VAL_TOTAL']/field[externalId = 'AMOUNT']/value"
                                                />
                                            </VAL_TOTAL>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(section/section[externalId = 'VAL_RANGE_TOTAL']/section[externalId = 'LOW']/field[externalId = 'CURRENCY']/value)) > 0">
                                            <VAL_RANGE_TOTAL>
                                                <xsl:attribute name="CURRENCY">
                                                  <xsl:value-of
                                                      select="section/section[externalId = 'VAL_RANGE_TOTAL']/section[externalId = 'LOW']/field[externalId = 'CURRENCY']/value"
                                                  />
                                                </xsl:attribute>
                                                <LOW>
                                                    <xsl:value-of
                                                        select="section/section[externalId = 'VAL_RANGE_TOTAL']/section[externalId = 'LOW']/field[externalId = 'AMOUNT']/value"
                                                   
                                                    />
                                                </LOW>
                                                <HIGH>
                                                    <xsl:value-of
                                                        select="section/section[externalId = 'VAL_RANGE_TOTAL']/section[externalId = 'HIGH']/field[externalId = 'AMOUNT']/value"
                                                    />
                                                </HIGH>
                                            </VAL_RANGE_TOTAL>
                                        </xsl:if>
                                    </VALUES>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section/field[externalId = 'LIKELY_SUBCONTRACTED']/value)) > 0">
                                    <LIKELY_SUBCONTRACTED/>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section/section[externalId = 'VAL_SUBCONTRACTING']/field[externalId = 'AMOUNT']/value)) > 0">
                                    <VAL_SUBCONTRACTING>
                                        <xsl:attribute name="CURRENCY">
                                            <xsl:value-of
                                                select="section/section[externalId = 'VAL_SUBCONTRACTING']/field[externalId = 'CURRENCY']/value"
                                            />
                                        </xsl:attribute>
                                        <xsl:value-of
                                            select="section/section[externalId = 'VAL_SUBCONTRACTING']/field[externalId = 'AMOUNT']/value"
                                        />
                                    </VAL_SUBCONTRACTING>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(section/field[externalId = 'PCT_SUBCONTRACTING']/value)) > 0">
                                    <PCT_SUBCONTRACTING>
                                        <xsl:value-of
                                            select="section/field[externalId = 'PCT_SUBCONTRACTING']/value"
                                        />
                                    </PCT_SUBCONTRACTING>
                                </xsl:if>
                                <xsl:if
                                    test="exists(section/field[externalId = 'INFO_ADD_SUBCONTRACTING']/value)">
                                    <INFO_ADD_SUBCONTRACTING>
                                        <xsl:call-template name="text_line">
                                            <xsl:with-param name="p_path"
                                                select="section/field[externalId = 'INFO_ADD_SUBCONTRACTING']"/>
                                        </xsl:call-template>
                                    </INFO_ADD_SUBCONTRACTING>
                                </xsl:if>
                            </AWARDED_CONTRACT>
                            </xsl:if>
                        </AWARD_CONTRACT>
                    </xsl:for-each>
                    <COMPLEMENTARY_INFO>
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
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_REVIEW_BODY']/field[externalId = 'OFFICIALNAME']/value)) > 0">
                        <ADDRESS_REVIEW_BODY>
                            <xsl:call-template name="comp_address">
                                <xsl:with-param name="p_path"
                                    select="section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_REVIEW_BODY']"
                                />
                            </xsl:call-template>
                        </ADDRESS_REVIEW_BODY>
                        </xsl:if>  
                        <xsl:if
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section/section[externalId = 'ADDRESS_MEDIATION_BODY']/field[externalId = 'OFFICIALNAME']/value)) > 0">
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
                            test="string-length(normalize-space(section[externalId = 'COMPLEMENTARY_INFO']/section[externalId = 'ADDRESS_REVIEW_INFO']/field[externalId = 'OFFICIALNAME']/value)) > 0">
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
                    
                </F03_2014>
            </FORM_SECTION>
        </TED_ESENDERS>
    </xsl:template>
</xsl:stylesheet>
