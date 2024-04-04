<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
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
         <ARBCIGR_ARTMAS>
                    <IDOC>
                        <xsl:attribute name="BEGIN">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <!-- Control details of Article Master -->
                        <EDI_DC40>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <IDOCTYP>
                                <xsl:value-of select="'ARBCIGR_ARTMAS'"/>
                            </IDOCTYP>
                            <MESTYP>
                                <xsl:value-of select="'ARTMAS'"/>
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
                        <!-- Basic details of Article Master -->
                        <E1BPE1MATHEAD>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="string-length($v_Materia) > 18">
                                    <MATERIAL_LONG>
                                        <xsl:value-of select="$v_Materia"/>
                                    </MATERIAL_LONG>
                                </xsl:when>
                                <xsl:otherwise>
                                    <MATERIAL>
                                        <xsl:value-of select="$v_Materia"/>
                                    </MATERIAL>
                                </xsl:otherwise>
                            </xsl:choose>
                            <MATERIAL_EXTERNAL>
                                <xsl:value-of select="$v_MateriaExt"/>
                            </MATERIAL_EXTERNAL>
                            <MATL_TYPE>
                                <xsl:value-of select="Article/BasicData/MaterialType"/>
                            </MATL_TYPE>
                            <MATL_GROUP>
                                <xsl:value-of select="Article/BasicData/MaterialGroup"/>
                            </MATL_GROUP>
                            <MATL_CAT>
                                <xsl:value-of select="Article/BasicData/MaterialCategory"/>
                            </MATL_CAT>
                            <BASIC_VIEW>
                                <xsl:value-of select="'X'"/>
                            </BASIC_VIEW>
                            <LOGDC_VIEW>
                                <xsl:value-of select="'X'"/>
                            </LOGDC_VIEW>
                            <FUNCTION>
                                <xsl:value-of select="'005'"/>
                            </FUNCTION>
                        </E1BPE1MATHEAD>
                        <!--- single article Characteristic data Begin-->
                        <xsl:if test="Article/BasicData/MaterialCategory = '00'">
                        <xsl:for-each select="Article/Characteristic">
                            <E1BPE1AUSPRT>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                                 <CHAR_NAME>
                                    <xsl:value-of select="CharacteristicId"/>
                                </CHAR_NAME>
                                <CHAR_VALUE>
                                    <xsl:value-of select="Values/PossibleValue/Value"/>
                                </CHAR_VALUE>
                                <CHAR_VALUE_LONG>
                                    <xsl:value-of select="Values/PossibleValue/Value"/>
                                </CHAR_VALUE_LONG>
                                <CHAR_VAL_CHAR>
                                    <xsl:value-of select="Values/PossibleValue/Value"/>
                                </CHAR_VAL_CHAR>
                                <FUNCTION>
                                    <xsl:value-of select="'005'"/>
                                </FUNCTION>
                            </E1BPE1AUSPRT>
                        </xsl:for-each>
                            <xsl:for-each select="Article/Characteristic">
                            <E1BPE1AUSPRTX>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                               <CHAR_NAME>
                                    <xsl:value-of select="CharacteristicId"/>
                                </CHAR_NAME>
                                <CHAR_VALUE>
                                    <xsl:value-of select="'X'"/>
                                </CHAR_VALUE>
                                <FUNCTION>
                                    <xsl:value-of select="'005'"/>
                                </FUNCTION>
                            </E1BPE1AUSPRTX>
                        </xsl:for-each>
                        </xsl:if>    

                        <!--- Variant Data &   Characteristic data -->
                        <xsl:for-each select="Article/Variants/Variant">
                            <E1BPE1VARKEY>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <VARIANT/>
                                <VARIANT_LONG/>
                                <VARIANT_EXTERNAL>
                                    <xsl:value-of select="VariantID"/>
                                </VARIANT_EXTERNAL>
                                <FUNCTION>
                                    <xsl:value-of select="'005'"/>
                                </FUNCTION>
                            </E1BPE1VARKEY>
                        </xsl:for-each>
                        <xsl:for-each select="Article/Variants/Variant">
                            <xsl:for-each select="Characteristic">
                                <E1BPE1AUSPRT>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_Materia) > 18">
                                            <MATERIAL_LONG>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <MATERIAL>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                     <CHAR_NAME>
                                        <xsl:value-of select="CharacteristicId"/>
                                    </CHAR_NAME>
                                    <CHAR_VALUE>
                                        <xsl:value-of select="Values/PossibleValue/Value"/>
                                    </CHAR_VALUE>
                                    <CHAR_VALUE_LONG>
                                        <xsl:value-of select="Values/PossibleValue/Value"/>
                                    </CHAR_VALUE_LONG>
                                    <CHAR_VAL_CHAR>
                                        <xsl:value-of select="Values/PossibleValue/Value"/>
                                    </CHAR_VAL_CHAR>
                                    <FUNCTION>
                                        <xsl:value-of select="'005'"/>
                                    </FUNCTION>
                                </E1BPE1AUSPRT>
                                <E1BPE1AUSPRT>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_Materia) > 18">
                                            <MATERIAL_LONG>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <MATERIAL>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <CHAR_NAME>
                                        <xsl:value-of select="CharacteristicId"/>
                                    </CHAR_NAME>
                                    <CHAR_VALUE>
                                        <xsl:value-of select="Values/PossibleValue/Value"/>
                                    </CHAR_VALUE>
                                     <CHAR_VALUE_LONG>
                                        <xsl:value-of select="Values/PossibleValue/Value"/>
                                    </CHAR_VALUE_LONG>
                                    <CHAR_VAL_CHAR>
                                        <xsl:value-of select="Values/PossibleValue/Value"/>
                                    </CHAR_VAL_CHAR>
                                    <FUNCTION>
                                        <xsl:value-of select="'005'"/>
                                    </FUNCTION>
                                </E1BPE1AUSPRT>
                            </xsl:for-each>                                
                        </xsl:for-each>
                        <xsl:for-each select="Article/Variants/Variant">
                            <xsl:for-each select="Characteristic">
                                <E1BPE1AUSPRTX>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_Materia) > 18">
                                            <MATERIAL_LONG>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <MATERIAL>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                     <CHAR_NAME>
                                        <xsl:value-of select="CharacteristicId"/>
                                    </CHAR_NAME>
                                    <CHAR_VALUE>
                                        <xsl:value-of select="'X'"/>
                                    </CHAR_VALUE>
                                    <FUNCTION>
                                        <xsl:value-of select="'005'"/>
                                    </FUNCTION>
                                </E1BPE1AUSPRTX>
                                <E1BPE1AUSPRTX>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_Materia) > 18">
                                            <MATERIAL_LONG>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <MATERIAL>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <CHAR_NAME>
                                        <xsl:value-of select="CharacteristicId"/>
                                    </CHAR_NAME>
                                    <CHAR_VALUE>
                                        <xsl:value-of select="'X'"/>
                                    </CHAR_VALUE>
                                    <FUNCTION>
                                        <xsl:value-of select="'005'"/>
                                    </FUNCTION>
                                </E1BPE1AUSPRTX>
                            </xsl:for-each>                           
                        </xsl:for-each>
                        <!-- Material Data at Client level  details of Article Master -->
                        <E1BPE1MARART>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="string-length($v_Materia) > 18">
                                    <MATERIAL_LONG>
                                        <xsl:value-of select="$v_Materia"/>
                                    </MATERIAL_LONG>
                                </xsl:when>
                                <xsl:otherwise>
                                    <MATERIAL>
                                        <xsl:value-of select="$v_Materia"/>
                                    </MATERIAL>
                                </xsl:otherwise>
                            </xsl:choose>
                            <MATERIAL_EXTERNAL>
                                <xsl:value-of select="$v_MateriaExt"/>
                            </MATERIAL_EXTERNAL>
                            <OLD_MAT_NO>
                                <xsl:value-of select="$v_LotID"/>
                            </OLD_MAT_NO>
                            <BASE_UOM_ISO>
                                <xsl:value-of select="Article/BasicData/BaseUnitOfMeasure"/>
                            </BASE_UOM_ISO>
                            <xsl:if test="exists(Article/BasicData/OrderingUnit)">
                                <PO_UNIT>
                                    <xsl:value-of select="Article/BasicData/OrderingUnit"/>
                                </PO_UNIT>
                            </xsl:if>
                            <FUNCTION>
                                <xsl:value-of select="'005'"/>
                            </FUNCTION>
                        </E1BPE1MARART>
                        <E1BPE1MARARTX>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="string-length($v_Materia) > 18">
                                    <MATERIAL_LONG>
                                        <xsl:value-of select="$v_Materia"/>
                                    </MATERIAL_LONG>
                                </xsl:when>
                                <xsl:otherwise>
                                    <MATERIAL>
                                        <xsl:value-of select="$v_Materia"/>
                                    </MATERIAL>
                                </xsl:otherwise>
                            </xsl:choose>
                            <MATERIAL_EXTERNAL>
                                <xsl:value-of select="$v_MateriaExt"/>
                            </MATERIAL_EXTERNAL>
                            <OLD_MAT_NO>
                                <xsl:value-of select="'X'"/>
                            </OLD_MAT_NO>
                            <BASE_UOM_ISO>
                                <xsl:value-of select="'X'"/>
                            </BASE_UOM_ISO>
                            <PO_UNIT>
                                <xsl:value-of select="'X'"/>
                            </PO_UNIT>
                            <FUNCTION>
                                <xsl:value-of select="'005'"/>
                            </FUNCTION>
                        </E1BPE1MARARTX>
                        <!-- Additinal details of Article Master -->
                        <xsl:for-each select="Article/Description">
                            <E1BPE1MAKTRT>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <MATERIAL_EXTERNAL>
                                    <xsl:value-of select="$v_MateriaExt"/>
                                </MATERIAL_EXTERNAL>
                                <MATL_DESC>
                                    <xsl:value-of select="."/>
                                </MATL_DESC>
                                <LANGU_ISO>
                                    <xsl:value-of select="@languageCode"/>
                                </LANGU_ISO>
                            </E1BPE1MAKTRT>
                        </xsl:for-each>
                        <!-- Site / Plant details of Article Master -->         
                        <xsl:for-each select="Article/Site">
                            <E1BPE1MARCRT>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <MATERIAL_EXTERNAL>
                                    <xsl:value-of select="$v_MateriaExt"/>
                                </MATERIAL_EXTERNAL>
                                <PLANT>
                                    <xsl:value-of select="SiteId"/>
                                </PLANT>
                                <FUNCTION>
                                    <xsl:value-of select="'005'"/>
                                </FUNCTION>
                            </E1BPE1MARCRT>
                        </xsl:for-each>          
                        <!-- Site X values, Need to Maintain sequence  -->
                       <xsl:for-each select="Article/Site">
                            <E1BPE1MARCRTX>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <MATERIAL_EXTERNAL>
                                    <xsl:value-of select="$v_MateriaExt"/>
                                </MATERIAL_EXTERNAL>
                                <PLANT>
                                    <xsl:value-of select="SiteId"/>
                                </PLANT>
                                <FUNCTION>
                                    <xsl:value-of select="'005'"/>
                                </FUNCTION>
                            </E1BPE1MARCRTX>
                        </xsl:for-each>                          
                             <!--For site extension of Variant                            -->
                        <xsl:for-each select="Article/Variants/Variant">
                            <xsl:for-each select="Site">
                                <E1BPE1MARCRT>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_Materia) > 18">
                                            <MATERIAL_LONG>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <MATERIAL>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <MATERIAL_EXTERNAL>
                                        <xsl:value-of select="$v_MateriaExt"/>
                                    </MATERIAL_EXTERNAL>
                                    <PLANT>
                                        <xsl:value-of select="SiteId"/>
                                    </PLANT>
                                    <FUNCTION>
                                        <xsl:value-of select="'005'"/>
                                    </FUNCTION>
                                </E1BPE1MARCRT>     
                            </xsl:for-each>
                        </xsl:for-each>
                                <!-- Site X values, Need to Maintain sequence  -->
                        <xsl:for-each select="Article/Variants/Variant">
                            <xsl:for-each select="Site">
                                <E1BPE1MARCRTX>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_Materia) > 18">
                                            <MATERIAL_LONG>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <MATERIAL>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <MATERIAL_EXTERNAL>
                                        <xsl:value-of select="$v_MateriaExt"/>
                                    </MATERIAL_EXTERNAL>
                                    <PLANT>
                                        <xsl:value-of select="SiteId"/>
                                    </PLANT>
                                    <FUNCTION>
                                        <xsl:value-of select="'005'"/>
                                    </FUNCTION>
                                </E1BPE1MARCRTX>
                            </xsl:for-each>
                        </xsl:for-each>
                         <!-- Unit Of Measure details of Article Master -->
                        <xsl:for-each select="Article/UnitOfMeasure">
                            <E1BPE1MARMRT>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <MATERIAL_EXTERNAL>
                                    <xsl:value-of select="$v_MateriaExt"/>
                                </MATERIAL_EXTERNAL>
                                <ALT_UNIT_ISO>
                                    <xsl:value-of select="AlternateUnitOfMeasure"/>
                                </ALT_UNIT_ISO>
                                <NUMERATOR>
                                    <xsl:value-of select="Numerator"/>
                                </NUMERATOR>
                                <DENOMINATR>
                                    <xsl:value-of select="Denominator"/>
                                </DENOMINATR>
                                <EAN_UPC>
                                    <xsl:value-of select="EAN"/>
                                </EAN_UPC>
                                <EAN_CAT>
                                    <xsl:value-of select="$v_EANCategory"/>
                                </EAN_CAT>
                                <FUNCTION>
                                    <xsl:value-of select="'005'"/>
                                </FUNCTION>
                            </E1BPE1MARMRT>
                        </xsl:for-each>
                        <!-- Unit Of Measure X values, Need to Maintain sequence  -->
                        <xsl:for-each select="Article/UnitOfMeasure">
                            <E1BPE1MARMRTX>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="string-length($v_Materia) > 18">
                                        <MATERIAL_LONG>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATERIAL>
                                            <xsl:value-of select="$v_Materia"/>
                                        </MATERIAL>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <MATERIAL_EXTERNAL>
                                    <xsl:value-of select="$v_MateriaExt"/>
                                </MATERIAL_EXTERNAL>
                                <ALT_UNIT_ISO>
                                    <xsl:value-of select="AlternateUnitOfMeasure"/>
                                </ALT_UNIT_ISO>
                                <NUMERATOR>
                                    <xsl:value-of select="'X'"/>
                                </NUMERATOR>
                                <DENOMINATR>
                                    <xsl:value-of select="'X'"/>
                                </DENOMINATR>
                                <EAN_UPC>
                                    <xsl:value-of select="'X'"/>
                                </EAN_UPC>
                                <EAN_CAT>
                                    <xsl:value-of select="'X'"/>
                                </EAN_CAT>
                                <FUNCTION>
                                    <xsl:value-of select="'005'"/>
                                </FUNCTION>
                            </E1BPE1MARMRTX>
                        </xsl:for-each>
                        <!-- International Article Numbers (EANs)  details of Article Master -->
                        <xsl:for-each select="Article/UnitOfMeasure">
                            <xsl:if test="$v_EANCategory != ''">
                                <E1BPE1MEANRT>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_Materia) > 18">
                                            <MATERIAL_LONG>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <MATERIAL>
                                                <xsl:value-of select="$v_Materia"/>
                                            </MATERIAL>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <MATERIAL_EXTERNAL>
                                        <xsl:value-of select="$v_MateriaExt"/>
                                    </MATERIAL_EXTERNAL>
                                    <UNIT_ISO>
                                        <xsl:value-of select="AlternateUnitOfMeasure"/>
                                    </UNIT_ISO>
                                    <EAN_UPC>
                                        <xsl:value-of select="EAN"/>
                                    </EAN_UPC>
                                    <EAN_CAT>
                                        <xsl:value-of select="$v_EANCategory"/>
                                    </EAN_CAT>
                                    <FUNCTION>
                                        <xsl:value-of select="'005'"/>
                                    </FUNCTION>
                                </E1BPE1MEANRT>
                            </xsl:if>
                        </xsl:for-each>
                    </IDOC>
                </ARBCIGR_ARTMAS>        
    </xsl:template>

</xsl:stylesheet>
