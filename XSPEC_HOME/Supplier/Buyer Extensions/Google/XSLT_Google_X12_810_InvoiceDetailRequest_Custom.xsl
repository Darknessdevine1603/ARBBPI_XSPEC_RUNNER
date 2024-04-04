<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
    <xsl:template match="//source"/>
    <!-- Extension Start -->
    <!-- IG-40271 Populate "State" only when S_N4/D156 is null, S_N4/D26 is "US" or "CA", S_N4/D310 not empty -->
       <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
    <!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>-->
    <xsl:template match="InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact/PostalAddress[not(exists(State))]">
        <PostalAddress>
            <xsl:apply-templates select="Street, City"/>
            <xsl:variable name="v_role" select="./../../Contact/@role"/>
            <xsl:if test="$Lookup/Lookups/Roles/Role[CXMLCode = $v_role]/X12Code">
                <xsl:variable name="v_X12Role">
                    <xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $v_role]/X12Code"/>
                </xsl:variable>
                <xsl:if test="$v_X12Role != ''">
                    <xsl:variable name="v_path" select="//M_810/G_N1[S_N1/D_98_1 = $v_X12Role]"/>
                    <xsl:variable name="v_sCode">
                        <xsl:choose>
                            <xsl:when test="($v_path/S_N4[not(exists(D_156))] or $v_path/S_N4/D_156 = '') and ($v_path/S_N4/D_26 = 'US' or $v_path/S_N4/D_26 = 'CA') and $v_path/S_N4/D_310 != ''">
                                <xsl:value-of select="$v_path/S_N4/D_310"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$v_sCode != ''">
                        <State>
                            <xsl:value-of select="$v_sCode"/>
                        </State>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="PostalCode, Country"/>
        </PostalAddress>
    </xsl:template>
    <xsl:template
        match="InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact/PostalAddress/State">
        <xsl:variable name="v_role" select="./../../../Contact/@role"/>
            <xsl:if test="$Lookup/Lookups/Roles/Role[CXMLCode = $v_role]/X12Code">
                <xsl:variable name="v_X12Role">
                    <xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $v_role]/X12Code"/>
                </xsl:variable>
                <xsl:if test="$v_X12Role != ''">
                    <xsl:variable name="v_path" select="//M_810/G_N1[S_N1/D_98_1 = $v_X12Role]"/>
                    
                        <xsl:variable name="v_sCode">
                            <xsl:choose>
                                <xsl:when test="($v_path/S_N4[not(exists(D_156))] or $v_path/S_N4/D_156 = '') and ($v_path/S_N4/D_26 = 'US' or $v_path/S_N4/D_26 = 'CA') and $v_path/S_N4/D_310 != ''">
                                    <xsl:value-of select="$v_path/S_N4/D_310"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$v_sCode != ''">
                            <State>
                                <xsl:value-of select="$v_sCode"/>
                            </State>
                        </xsl:when>
                        <xsl:otherwise>
                            <State>
                                <xsl:value-of select="."/>
                            </State>
                            
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>        
    </xsl:template>
    <!-- IG-40271 -->
    <!-- Extension Ends -->
    <xsl:template match="//Combined">
        <xsl:apply-templates select="@* | node()"/>
    </xsl:template>
    <xsl:template match="//target">
        <xsl:apply-templates select="@* | node()"/>
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
