<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://publications.europa.eu/resource/schema/ted/R2.0.9/reception"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:n2021="http://publications.europa.eu/resource/schema/ted/2021/nuts"
    exclude-result-prefixes="xs" version="2.0">
    <!-- Template for version check-->
    <xsl:template name="Check_SupportVersion">
        <!--        Changes done on 1/11/2022 for IG-36173 for TED schema version updates -->
        <xsl:attribute name="VERSION">
            <xsl:value-of select="'R2.0.9.S05'"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="contract_address">
        <xsl:param name="p_path"/>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'OFFICIALNAME']/value)) > 0">
            <OFFICIALNAME>
                <xsl:value-of select="$p_path/field[externalId = 'OFFICIALNAME']/value"/>
            </OFFICIALNAME>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'NATIONALID']/value)) > 0">
            <NATIONALID>
                <xsl:value-of select="$p_path/field[externalId = 'NATIONALID']/value"/>
            </NATIONALID>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'ADDRESS']/value)) > 0">
            <ADDRESS>
                <xsl:value-of select="$p_path/field[externalId = 'ADDRESS']/value"/>
            </ADDRESS>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($p_path/field[externalId = 'TOWN']/value)) > 0">
            <TOWN>
                <xsl:value-of select="$p_path/field[externalId = 'TOWN']/value"/>
            </TOWN>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'POSTAL_CODE']/value)) > 0">
            <POSTAL_CODE>
                <xsl:value-of select="$p_path/field[externalId = 'POSTAL_CODE']/value"/>
            </POSTAL_CODE>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'COUNTRY']/value)) > 0">
            <COUNTRY>
                <xsl:attribute name="VALUE">
                    <xsl:value-of select="$p_path/field[externalId = 'COUNTRY']/value"/>
                </xsl:attribute>
            </COUNTRY>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'CONTACT_POINT']/value)) > 0">
            <CONTACT_POINT>
                <xsl:value-of select="$p_path/field[externalId = 'CONTACT_POINT']/value"/>
            </CONTACT_POINT>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($p_path/field[externalId = 'PHONE']/value)) > 0">
            <PHONE>
                <xsl:value-of select="$p_path/field[externalId = 'PHONE']/value"/>
            </PHONE>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'E_MAIL']/value)) > 0">
            <E_MAIL>
                <xsl:value-of select="$p_path/field[externalId = 'E_MAIL']/value"/>
            </E_MAIL>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($p_path/field[externalId = 'FAX']/value)) > 0">
            <FAX>
                <xsl:value-of select="$p_path/field[externalId = 'FAX']/value"/>
            </FAX>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'n2021:NUTS']/value)) > 0">
            <n2021:NUTS>
                <xsl:attribute name="CODE">
                    <xsl:value-of select="$p_path/field[externalId = 'n2021:NUTS']/value"/>
                </xsl:attribute>
            </n2021:NUTS>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'URL_GENERAL']/value)) > 0">
            <URL_GENERAL>
                <xsl:value-of select="$p_path/field[externalId = 'URL_GENERAL']/value"/>
            </URL_GENERAL>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'URL_BUYER']/value)) > 0">
            <URL_BUYER>
                <xsl:value-of select="$p_path/field[externalId = 'URL_BUYER']/value"/>
            </URL_BUYER>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="comp_address">
        <xsl:param name="p_path"/>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'OFFICIALNAME']/value)) > 0">
            <OFFICIALNAME>
                <xsl:value-of select="$p_path/field[externalId = 'OFFICIALNAME']/value"/>
            </OFFICIALNAME>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'ADDRESS']/value)) > 0">
            <ADDRESS>
                <xsl:value-of select="$p_path/field[externalId = 'ADDRESS']/value"/>
            </ADDRESS>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($p_path/field[externalId = 'TOWN']/value)) > 0">
            <TOWN>
                <xsl:value-of select="$p_path/field[externalId = 'TOWN']/value"/>
            </TOWN>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'POSTAL_CODE']/value)) > 0">
            <POSTAL_CODE>
                <xsl:value-of select="$p_path/field[externalId = 'POSTAL_CODE']/value"/>
            </POSTAL_CODE>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'COUNTRY']/value)) > 0">
            <COUNTRY>
                <xsl:attribute name="VALUE">
                    <xsl:value-of select="$p_path/field[externalId = 'COUNTRY']/value"/>
                </xsl:attribute>
            </COUNTRY>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($p_path/field[externalId = 'PHONE']/value)) > 0">
            <PHONE>
                <xsl:value-of select="$p_path/field[externalId = 'PHONE']/value"/>
            </PHONE>
        </xsl:if>
        <xsl:if
            test="string-length(normalize-space($p_path/field[externalId = 'E_MAIL']/value)) > 0">
            <E_MAIL>
                <xsl:value-of select="$p_path/field[externalId = 'E_MAIL']/value"/>
            </E_MAIL>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($p_path/field[externalId = 'FAX']/value)) > 0">
            <FAX>
                <xsl:value-of select="$p_path/field[externalId = 'FAX']/value"/>
            </FAX>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($p_path/field[externalId = 'URL']/value)) > 0">
            <URL>
                <xsl:value-of select="$p_path/field[externalId = 'URL']/value"/>
            </URL>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="CPV">
        <xsl:param name="p_path"/>
        <CPV_CODE>
            <xsl:attribute name="CODE">
                <xsl:value-of select="$p_path/field[externalId = 'CPV_CODE']/value"/>
            </xsl:attribute>
        </CPV_CODE>
        <xsl:for-each select="$p_path/field[externalId = 'CPV_SUPPLEMENTARY_CODE']/value">
            <CPV_SUPPLEMENTARY_CODE>
                <xsl:attribute name="CODE">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </CPV_SUPPLEMENTARY_CODE>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="text_line">
        <xsl:param name="p_path"/>
<!--        IG-37837 To accomodate multiline Texts -->
        <xsl:for-each select="$p_path/value">
            <P>
                <xsl:value-of select="."/>                
            </P>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="sender">
        <xsl:param name="p_path"/>
        <SENDER>
            <IDENTIFICATION>
                <ESENDER_LOGIN>
                    <xsl:value-of select="$p_path/identification/eSenderLogin"/>
                </ESENDER_LOGIN>
                <xsl:if
                    test="string-length(normalize-space($p_path/identification/customerLogin)) > 0">
                    <CUSTOMER_LOGIN>
                        <xsl:value-of select="$p_path/identification/customerLogin"/>
                    </CUSTOMER_LOGIN>
                </xsl:if>
                <NO_DOC_EXT>
                    <xsl:value-of select="$p_path/identification/noDocExt"/>
                </NO_DOC_EXT>
                <xsl:if
                    test="string-length(normalize-space($p_path/identification/softwareVersion)) > 0">
                    <SOFTWARE_VERSION>
                        <xsl:value-of select="$p_path/identification/softwareVersion"/>
                    </SOFTWARE_VERSION>
                </xsl:if>
            </IDENTIFICATION>
            <CONTACT>
                <ORGANISATION>
                    <xsl:value-of select="$p_path/contact/organisation"/>
                </ORGANISATION>
                <COUNTRY>
                    <xsl:attribute name="VALUE">
                        <xsl:value-of select="$p_path/contact/country"/>
                    </xsl:attribute>
                </COUNTRY>
                <xsl:if test="string-length(normalize-space($p_path/contact/phone)) > 0">
                    <PHONE>
                        <xsl:value-of select="$p_path/contact/phone"/>
                    </PHONE>
                </xsl:if>
                <E_MAIL>
                    <xsl:value-of select="$p_path/contact/email"/>
                </E_MAIL>
            </CONTACT>
        </SENDER>
    </xsl:template>
</xsl:stylesheet>
