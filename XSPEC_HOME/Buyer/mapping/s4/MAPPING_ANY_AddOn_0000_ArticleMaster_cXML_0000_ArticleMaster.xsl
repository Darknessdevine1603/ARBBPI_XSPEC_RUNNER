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
                test="exists(ARBCIGR_ARTMAS/IDOC/E1BPE1MATHEAD/MATERIAL_LONG)">
                <xsl:value-of select="ARBCIGR_ARTMAS/IDOC/E1BPE1MATHEAD/MATERIAL_LONG"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ARBCIGR_ARTMAS/IDOC/E1BPE1MATHEAD/MATERIAL"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="ARBCIGR_ARTMAS/IDOC">
        <ArticleMaster>
            <xsl:apply-templates
                select="E1BPE1MARART[(MATERIAL = $v_Article or E1BPE1MARART1/MATERIAL_LONG = $v_Article)]/DEL_FLAG"/>
            <xsl:attribute name="RequestType">
                <xsl:value-of select="'ART'"/>                
            </xsl:attribute>
            <!-- Message details of Article Master -->
            <xsl:apply-templates select="EDI_DC40"/>
            <Article>
                <BasicData>
                    
                    <xsl:apply-templates select="E1BPE1MATHEAD"/>
                    <xsl:apply-templates select="E1BPE1MARART[MATERIAL = $v_Article or E1BPE1MARART1/MATERIAL_LONG = $v_Article]"/>
                </BasicData>
                <xsl:apply-templates select="E1BPE1MAKTRT[MATERIAL = $v_Article or MATERIAL_LONG = $v_Article]"/>
                <Variants>
                    <xsl:apply-templates select="E1BPE1VARKEY"/>
                </Variants>
                <xsl:apply-templates select="E1BPE1AUSPRT[MATERIAL = $v_Article or MATERIAL_LONG = $v_Article]"/>
                <xsl:apply-templates select="E1BPE1MARCRT[MATERIAL = $v_Article or E1BPE1MARCRT1/MATERIAL_LONG = $v_Article]"/>
                <xsl:apply-templates select="E1BPE1MARMRT[MATERIAL = $v_Article or MATERIAL_LONG = $v_Article]"/>
                <xsl:apply-templates select="E1BPE1MATHEAD/CONFIG_CLASS_NAME"/>
                <xsl:apply-templates select="E1BPE1MATHEAD/CHAR_PROF[not(exists(../CONFIG_CLASS_NAME))]"/>
                
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

    <!--Basic details-->
    <xsl:template match="E1BPE1MATHEAD">
        <ID>
            <xsl:value-of select="$v_Article"/>
        </ID>
        <MaterialType>
            <xsl:value-of select="MATL_TYPE"/>
        </MaterialType>
        <MaterialGroup>
            <xsl:value-of select="MATL_GROUP"/>
        </MaterialGroup>
        <MaterialCategory>
            <xsl:value-of select="MATL_CAT"/>
        </MaterialCategory>
        <xsl:apply-templates select="REF_MATL"/>
    </xsl:template>

    <!--    Characteristic Profile-->
    <xsl:template match="E1BPE1MATHEAD/CHAR_PROF | E1BPE1MATHEAD/CONFIG_CLASS_NAME">
        <CharacteristicProfile>
            <CharacteristicProfileId>
                <xsl:value-of select="."/>
            </CharacteristicProfileId>
        </CharacteristicProfile>
    </xsl:template>
    <!--Basic UOM details-->
    <xsl:template match="E1BPE1MARART">
        <BaseUnitOfMeasure>
            <xsl:value-of select="BASE_UOM_ISO"/>
        </BaseUnitOfMeasure>
        <xsl:apply-templates select="PO_UNIT"/>
    </xsl:template>
    <!--    Additinal details-->
    <xsl:template match="E1BPE1MAKTRT">
        <Description>
            <xsl:attribute name="languageCode">
                <xsl:value-of select="LANGU_ISO"/>
            </xsl:attribute>
            <xsl:value-of select="MATL_DESC"/>
        </Description>
    </xsl:template>
    <!--    Variants details-->
    <xsl:template match="E1BPE1VARKEY">
        <xsl:for-each select=".">
            <!--  <Variants>-->
            <xsl:variable name="v_VariantID">
                <xsl:choose>
                    <xsl:when test="exists(VARIANT_LONG)">
                        <xsl:value-of select="VARIANT_LONG"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="VARIANT"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <Variant>
                <VariantID>
                    <xsl:value-of select="$v_VariantID"/>
                </VariantID>
                <!--Material Category for variant is 02, Constant-->
                <MaterialCategory>02</MaterialCategory>
                <xsl:apply-templates select="../E1BPE1MARART[MATERIAL = $v_VariantID or E1BPE1MARART1/MATERIAL_LONG = $v_VariantID]"/>
                <xsl:apply-templates select="../E1BPE1MAKTRT[MATERIAL = $v_VariantID or MATERIAL_LONG = $v_VariantID]"/>
                <xsl:apply-templates select="../E1BPE1AUSPRT[MATERIAL = $v_VariantID or MATERIAL_LONG = $v_VariantID]"/>
                <xsl:apply-templates select="../E1BPE1MARCRT[MATERIAL = $v_VariantID or E1BPE1MARCRT1/MATERIAL_LONG = $v_VariantID]"/>
                <xsl:apply-templates select="../E1BPE1MARMRT[MATERIAL = $v_VariantID or MATERIAL_LONG = $v_VariantID]"/>
            </Variant>
            <!--</Variants>-->
        </xsl:for-each>
    </xsl:template>
    <!--    Characteristic details -->
    <xsl:template match="E1BPE1AUSPRT">
        <Characteristic>
            <CharacteristicId>
                <xsl:value-of select="CHAR_NAME"/>
            </CharacteristicId>
            <Values>
                <xsl:variable name="v_CharValue">
                    <xsl:choose>
                        <xsl:when test="exists(CHAR_VALUE_LONG)">
                            <xsl:value-of select="CHAR_VALUE_LONG"/>
                        </xsl:when>
                    <xsl:otherwise>
                            <xsl:value-of select="CHAR_VALUE"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
            <PossibleValue>
                    <xsl:call-template name="ConvertScientificNotation">
                        <xsl:with-param name="input" select="$v_CharValue"/>
                    <xsl:with-param name="input_from" select="CHAR_VAL_FLOAT_FROM"/>
                    </xsl:call-template>
                </PossibleValue>
            </Values>
        </Characteristic>
    </xsl:template>
    <!--    Site details-->
    <xsl:template match="E1BPE1MARCRT">
        <Site>
            <xsl:apply-templates select="DEL_FLAG"/>
			<xsl:apply-templates select="E1ARBCIGR_MARCRT"/>
            <SiteId>
                <xsl:value-of select="PLANT"/>
            </SiteId>
        </Site>
    </xsl:template>
    <!--    Unit Of Measure details-->
    <xsl:template match="E1BPE1MARMRT">
        <UnitOfMeasure>
            <!--Get the Article Id / Varient Id to validate UOM deletions-->
            <xsl:variable name="v_Artilce2">
                    <xsl:choose>
                        <xsl:when test="exists(MATERIAL_LONG)">
                            <xsl:value-of select="MATERIAL_LONG"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="MATERIAL"/>
                        </xsl:otherwise>
                    </xsl:choose>                
            </xsl:variable>
            <xsl:variable name="V_Alt_Unit" select="ALT_UNIT_ISO"/>
            <xsl:if test="not(exists(../E1BPE1MARMRTX[(MATERIAL = $v_Artilce2 or MATERIAL_LONG = $v_Artilce2) and ALT_UNIT_ISO = $V_Alt_Unit]))">
                <xsl:attribute name="Delete">
                    <xsl:value-of select="'true'"/>
                </xsl:attribute>
            </xsl:if>
            <AlternateUnitOfMeasure>
                <xsl:value-of select="ALT_UNIT_ISO"/>
            </AlternateUnitOfMeasure>
            <Numerator>
                <xsl:value-of select="NUMERATOR"/>
            </Numerator>
            <Denominator>
                <xsl:value-of select="DENOMINATR"/>
            </Denominator>
            <xsl:apply-templates select="EAN_UPC"/>
            <xsl:apply-templates select="EAN_CAT"/>
        </UnitOfMeasure>
    </xsl:template>

    <xsl:template match="PO_UNIT">
        <OrderingUnit>
            <xsl:value-of select="."/>
        </OrderingUnit>
    </xsl:template>
    <xsl:template match="REF_MATL">
        <RefMaterial>
            <xsl:value-of select="."/>
        </RefMaterial>
    </xsl:template>
    <xsl:template match="EAN_UPC">
        <EAN>
            <xsl:value-of select="."/>
        </EAN>
    </xsl:template>

    <xsl:template match="EAN_CAT">
        <EANCategory>
            <xsl:value-of select="."/>
        </EANCategory>
    </xsl:template>

    <!--    Deletion indicator will be constant "03"-->
    <xsl:template match="E1BPE1MARART/DEL_FLAG">
        <xsl:attribute name="ActionCode">
            <xsl:value-of select="'03'"/>
        </xsl:attribute>
    </xsl:template>

    <!--Site Deletion indicator-->
    <xsl:template match="DEL_FLAG">
        <xsl:attribute name="Delete">
            <xsl:value-of select="'true'"/>
        </xsl:attribute>
    </xsl:template>
	<!--Site Category, A - Store , B - DC-->
    <xsl:template match="E1ARBCIGR_MARCRT">
        <xsl:attribute name="SiteType">
            <xsl:value-of select="VLFKZ"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="ConvertScientificNotation">
        <xsl:param name="input"/>
        <xsl:param name="input_from"/>
        <xsl:variable name="v_type">
            <xsl:if test="matches($input_from, '^\-?[\d\.,]*[Ee][+\-]*\d*$') and number($input_from) > 0">
                <xsl:value-of select="'NonChar'"/>
                </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$v_type = 'NonChar'">
                <!-- Get value /  Floating Point From value-->
                <xsl:variable name="v_input1">
                    <xsl:choose>
                        <xsl:when test="matches($input, '\s-\s')">
                            <xsl:value-of select="substring-before($input, ' - ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$input"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!--Get value /  Floating Point to value-->
                <xsl:variable name="v_input2">
                    <xsl:if test="matches($input, '\s-\s')">
                        <xsl:value-of select="substring-after($input, ' - ')"/>
                    </xsl:if>
                </xsl:variable>
                <!--Remove the period value like Days, CURR, INR for Range values-->
                <xsl:variable name="v_input3">
                    <xsl:choose>
                        <xsl:when test="matches($v_input2, '\s')">
                            <xsl:value-of select="substring-before($v_input2, ' ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$v_input2"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="v_type">
                    <xsl:choose>
                        <xsl:when test="matches($v_input1, '^\d\d.\d\d.\d\d$')">
                            <xsl:value-of select="'TIME'"/>
                        </xsl:when>
                        <xsl:when test="matches($v_input1, '^\d\d.+\d\d.+\d\d\d\d$')">
                            <xsl:value-of select="'DATE'"/>
                        </xsl:when>
                        <xsl:when test="matches($v_input1, '^\d*[.|\d]*,*\d*\s*[A-Z|a-z]*$')">
                            <xsl:value-of select="'NUM/CURR'"/>
                        </xsl:when>                
                        <xsl:otherwise>
                            <xsl:value-of select="'CHAR'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:choose>
                    <!--Convert to Time format-->
                    <xsl:when test="$v_type = 'TIME'">
                        <FloatingPointFrom>
                            <xsl:value-of select="$v_input1"/>
                        </FloatingPointFrom>
                        <xsl:if test="string-length($v_input2) > 0">
                            <FloatingPointTo>
                                <xsl:value-of select="$v_input2"/>
                            </FloatingPointTo>
                        </xsl:if>
                    </xsl:when>
                    <!--Convert to Date format-->
                    <xsl:when test="$v_type = 'DATE'">
                        <FloatingPointFrom>
                            <xsl:value-of select="translate($v_input1, '.', '-')"/>
                        </FloatingPointFrom>
                        <xsl:if test="string-length($v_input3) > 0">
                            <FloatingPointTo>
                                <xsl:value-of select="translate($v_input3, '.', '-')"/>
                            </FloatingPointTo>
                        </xsl:if>
                    </xsl:when>
                    <!--Numaric / Curency values-->
                    <xsl:when test="$v_type = 'NUM/CURR'">
                        <xsl:variable name="v_NumCurrValue">
                            <xsl:choose>
                                <xsl:when test="matches($v_input1, '\s')">
                                    <xsl:value-of select="substring-before($v_input1, ' ')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$v_input1"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <FloatingPointFrom>
                            <xsl:value-of select="translate(translate($v_NumCurrValue, '.', ''), ',', '.')"/>
                        </FloatingPointFrom>
                        <xsl:if test="string-length($v_input3) > 0">
                            <FloatingPointTo>
                                <xsl:value-of select="translate(translate($v_input3, '.', ''), ',', '.')"/>
                            </FloatingPointTo>
                        </xsl:if>
                    </xsl:when>
                    <!--Char value-->
                    <xsl:when test="$v_type = 'CHAR'">
                        <xsl:choose>
                            <!--Numaric value without UOM-->
                            <xsl:when test="matches($input, '^\d*[.|\d]*\s-\s\d[.|\d]*')">
                                <FloatingPointFrom>
                                    <xsl:value-of select="$v_input1"/>
                                </FloatingPointFrom>
                                <xsl:if test="string-length($v_input3) > 0">
                                    <FloatingPointTo>
                                        <xsl:value-of select="$v_input3"/>
                                    </FloatingPointTo>
                                </xsl:if>
                            </xsl:when>
                            <!--Char Values-->
                            <xsl:otherwise>
                                <Value>
                                    <xsl:value-of select="$input"/>
                                </Value>
                            </xsl:otherwise>
                        </xsl:choose>                
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <Value>
                    <xsl:value-of select="$input"/>
                </Value>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:template>
</xsl:stylesheet>
