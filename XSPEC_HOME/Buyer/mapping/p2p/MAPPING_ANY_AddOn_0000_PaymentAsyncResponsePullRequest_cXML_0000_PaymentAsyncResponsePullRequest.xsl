<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    xmlns:urn="urn:Ariba:Buyer:vsap" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="n0:ERPRespToAribaBuyerMsg">
        <urn:PaymentAsyncResponsePullRequest>
            <xsl:attribute name="partition" select="Header/Partition"/>
            <xsl:attribute name="variant" select="Header/Variant"/>
            <xsl:choose>
                <xsl:when test="LogMessage">
                    <urn:PayablePushError_PaymentErrorImport_Item>
                        <xsl:for-each select="LogMessage">
                            <urn:item>
                                <urn:Id>
                                    <xsl:value-of select="../AribaDocumentID"/>
                                </urn:Id>
                                <urn:NumInSet>
                                    <xsl:value-of select="position()"/>
                                </urn:NumInSet>
                                <urn:Type>
                                    <xsl:value-of select="MessageType"/>
                                </urn:Type>
                                <urn:Date>
                                    <xsl:value-of select="current-dateTime()"/>
                                </urn:Date>
                                <urn:ErrorMessage>
                                    <xsl:value-of select="MessageText"/>
                                </urn:ErrorMessage>
                                <urn:ErrorNumber>
                                    <xsl:call-template name="setValue">
                                        <xsl:with-param name="value" select="MessageNumber"/>
                                    </xsl:call-template>
                                </urn:ErrorNumber>
                                <urn:ErrorSAPField>
                                    <xsl:call-template name="setValue">
                                        <xsl:with-param name="value" select="ParameterField"/>
                                    </xsl:call-template>
                                </urn:ErrorSAPField>
                                <urn:ErrorSAPId>
                                    <xsl:call-template name="setValue">
                                        <xsl:with-param name="value" select="MessageClass"/>
                                    </xsl:call-template>
                                </urn:ErrorSAPId>
                            </urn:item>
                        </xsl:for-each>
                    </urn:PayablePushError_PaymentErrorImport_Item>
                </xsl:when>
                <xsl:when test="MultiHeader">
                    <xsl:variable name="v_items" select="Item"/>
                    <xsl:element name="urn:{MultiHeader[1]/@name}">                        
                        <xsl:for-each select="MultiHeader">
                            <xsl:variable name="v_headerKey" select="HeaderSpecificFields/@objectKey"/>                        
                            <urn:item>
                                <xsl:for-each select="HeaderSpecificFields">
                                    <xsl:variable name="v_fn" select="@fieldName"/>
                                    <xsl:if test="$v_fn">
                                        <xsl:element name="urn:{$v_fn}">
                                            <xsl:value-of select="@fieldValue"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="$v_items">
                                    
                                    <xsl:element name="urn:{../Item[1]/@name}">
                                        <xsl:for-each select="$v_items[ItemSpecificFields/@objectKey=$v_headerKey]">                                              
                                            <urn:item>
                                                <xsl:for-each select="ItemSpecificFields">
                                                    <xsl:variable name="v_fieldName" select="@fieldName"/>
                                                    <xsl:if test="$v_fieldName">
                                                        <xsl:element name="urn:{$v_fieldName}">
                                                            <xsl:value-of select="@fieldValue"/>
                                                        </xsl:element>
                                                    </xsl:if>
                                                </xsl:for-each>                                            
                                            </urn:item>   
                                            
                                        </xsl:for-each>
                                    </xsl:element>
                                    
                                </xsl:if>
                            </urn:item>                            
                        </xsl:for-each>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <urn:Payment_PaymentNumberImport_Item>
                        <urn:item>
                            <xsl:variable name="v_uniqueName" select="Header/AribaDocumentID"/>
                            <xsl:if test="$v_uniqueName">
                                <urn:UniqueName>
                                    <xsl:value-of select="$v_uniqueName"/>
                                </urn:UniqueName>
                            </xsl:if>
                                <urn:ERPPayableNumber>
                                    <xsl:value-of select="Header/SAPDocumentID"/>
                                </urn:ERPPayableNumber>
                            <xsl:variable name="v_version" select="Header/Version"/>
                            <xsl:if test="$v_version">
                                <urn:ERPPOVersionNumber>
                                    <xsl:value-of select="$v_version"/>
                                </urn:ERPPOVersionNumber>
                            </xsl:if>
                            <xsl:variable name="v_fiscal" select="Header/FiscalYear"/>
                            <xsl:if test="$v_fiscal">
                                <urn:FiscalYear>
                                    <xsl:value-of select="$v_fiscal"/>
                                </urn:FiscalYear>
                            </xsl:if>
                            <xsl:for-each select="Header/HeaderSpecificFields">
                                <xsl:variable name="v_on" select="@objectName"/>
                                <xsl:variable name="v_fn" select="@fieldName"/>
                                <xsl:choose>
                                    <xsl:when test="exists($v_on)">
                                        <xsl:element name="urn:{$v_on}">
                                            <xsl:if test="$v_fn">
                                                <xsl:element name="urn:{$v_fn}">
                                                    <xsl:value-of select="@fieldValue"/>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$v_fn">
                                            <xsl:element name="urn:{$v_fn}">
                                                <xsl:value-of select="@fieldValue"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:if test="Item">
                                        <xsl:for-each select="Item">
                                            <urn:item>
                                                <xsl:if test="AribaItemID">
                                                    <urn:NumberInCollection>
                                                        <xsl:value-of select="AribaItemID"/>
                                                    </urn:NumberInCollection>    
                                                </xsl:if>
                                                <xsl:variable name="v_pack" select="PackageInfo"/>
                                                <xsl:if test="$v_pack">
                                                    <urn:PackageInfo>
                                                        <xsl:value-of select="$v_pack"/>
                                                    </urn:PackageInfo>
                                                </xsl:if>
                                                <xsl:variable name="v_srvMap" select="ServiceMapKey"/>
                                                <xsl:if test="$v_srvMap">
                                                    <urn:ServiceMapKey>
                                                        <xsl:value-of select="ServiceMapKey"/>
                                                    </urn:ServiceMapKey>
                                                </xsl:if>
                                                <xsl:for-each select="ItemSpecificFields">
                                                    <xsl:variable name="v_fieldName" select="@fieldName"/>
                                                    <xsl:if test="$v_fieldName">
                                                        <xsl:element name="urn:{$v_fieldName}">
                                                            <xsl:value-of select="@fieldValue"/>
                                                        </xsl:element>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </urn:item>
                                        </xsl:for-each>
                                </xsl:if>
                        </urn:item>
                    </urn:Payment_PaymentNumberImport_Item>
                </xsl:otherwise>
            </xsl:choose>
        </urn:PaymentAsyncResponsePullRequest>
    </xsl:template>
    <xsl:template name="setValue">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="string-length($value) = 0">
                <xsl:value-of select="'Addon'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>                         
