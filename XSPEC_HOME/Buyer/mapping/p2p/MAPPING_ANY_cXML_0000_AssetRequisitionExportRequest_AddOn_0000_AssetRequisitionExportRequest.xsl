<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="urn:Ariba:Buyer:vsap"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="urn:sap-com:document:sap:rfc:functions" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="ns1:AssetRequisitionAsyncExportRequest" xmlns:ns1="urn:Ariba:Buyer:vsap">
        
        <n0:ARBCIG_BAPI_ASSET_CREATE>
            <ARIBA_REQ_NO>
                <xsl:value-of
                    select="ns1:Requisition_ProcessAssetReqHeaderDetails_Item/ns1:item/ns1:UniqueName"
                />
            </ARIBA_REQ_NO>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
            <GENERALDATA>
                <xsl:for-each
                    select="ns1:Requisition_ProcessAssetReqAccountingDetails_Item/ns1:item/ns1:LineItems/ns1:item/ns1:Accountings/ns1:SplitAccountings/ns1:item">
                    
                    <xsl:variable name="v_itemnumber1">
                        <xsl:value-of select="LineItem/NumberInCollection"/>
                    </xsl:variable>
                    <xsl:variable name="v_splitnumber1">
                        <xsl:value-of select="NumberInCollection"/>
                    </xsl:variable>
                    <xsl:variable name="assetclass">
                        <xsl:value-of select="AssetClass/UniqueName"/>
                    </xsl:variable>
                    <xsl:variable name="assetdesc">
                        <xsl:value-of select="AssetDescription"/>
                    </xsl:variable>
                    <xsl:for-each select="../../../../../../../Requisition_ProcessAssetReqLineItemDetails_Item/item/LineItems/item">
                        <xsl:if test="LineType/Category = '1' or string-length(normalize-space(LineType/Category)) = 0"> <!-- IG-25066 --> 
                        <xsl:if test="NumberInCollection=$v_itemnumber1">
                            
                            <item>
                                <ASSETCLASS>
                                    <xsl:value-of select="$assetclass"/>
                                </ASSETCLASS>
                                <DESCRIPT>
                                    <xsl:value-of select="$assetdesc"/>
                                </DESCRIPT>
                                
                                <ARIBA_ITEM>
                                    <xsl:value-of select="$v_itemnumber1"/>
                                </ARIBA_ITEM>
                                <ARIBA_SERIAL_NO>
                                    <xsl:value-of select="$v_splitnumber1"/>
                                </ARIBA_SERIAL_NO>
                                <ASSETGROUP>
                                    <xsl:value-of select="AssetGroup"/>
                                </ASSETGROUP>
                            </item>
                        </xsl:if>
                      </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </GENERALDATA>
            
            <KEY>
                <xsl:for-each
                    select="ns1:Requisition_ProcessAssetReqAccountingDetails_Item/ns1:item/ns1:LineItems/ns1:item/ns1:Accountings/ns1:SplitAccountings/ns1:item">
                    <xsl:variable name="v_itemnumber2">
                        <xsl:value-of select="LineItem/NumberInCollection"/>
                    </xsl:variable>
                    <xsl:variable name="v_splitnumber2">
                        <xsl:value-of select="NumberInCollection"/>
                    </xsl:variable>
                    <xsl:for-each select="../../../../../../../Requisition_ProcessAssetReqLineItemDetails_Item/item/LineItems/item">
                        <xsl:if test="LineType/Category = '1' or string-length(normalize-space(LineType/Category)) = 0"> <!-- IG-25066 -->
                        <xsl:if test="NumberInCollection=$v_itemnumber2">
                            <item>
                                <COMPANYCODE>
                                    <xsl:value-of select="../../../../Requisition_ProcessAssetReqHeaderDetails_Item/item/CompanyCode/UniqueName"/>
                                </COMPANYCODE>
                                <ASSET/>
                                <SUBNUMBER>
                                    <xsl:choose>
                                        <xsl:when test="AssetLineType/Category='1'">
                                            <xsl:value-of select="'0'"/>
                                        </xsl:when>
                                        <xsl:when test="AssetLineType/Category='2'">
                                            <xsl:value-of select="$v_splitnumber2"/>
                                        </xsl:when>
                                        <xsl:when test="AssetLineType/Category='3'">
                                            <xsl:value-of select="$v_splitnumber2"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'0'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </SUBNUMBER>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_ITEM>
                                <ARIBA_SERIAL_NO>
                                    <xsl:value-of select="$v_splitnumber2"/>
                                </ARIBA_SERIAL_NO>
                            </item>
                        </xsl:if>
                    </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </KEY>
            <BAPI1022_MISC>
                <xsl:for-each
                    select="ns1:Requisition_ProcessAssetReqAccountingDetails_Item/ns1:item/ns1:LineItems/ns1:item/ns1:Accountings/ns1:SplitAccountings/ns1:item">
                    <xsl:variable name="v_itemnumber">
                        <xsl:value-of select="LineItem/NumberInCollection"/>
                    </xsl:variable>
                    <xsl:variable name="v_splitnumber">
                        <xsl:value-of select="NumberInCollection"/>
                    </xsl:variable>
                    
                    <xsl:for-each
                        select="../../../../../../../Requisition_ProcessAssetReqLineItemDetails_Item/item/LineItems/item">
                      <xsl:if test="LineType/Category = '1' or string-length(normalize-space(LineType/Category)) = 0"> <!-- IG-25066 -->
                        <xsl:if test="NumberInCollection = $v_itemnumber">
                            <item>
                                <XSUBNO>
                                    <xsl:choose>
                                        <xsl:when test="AssetLineType/Category = '1'">
                                            <xsl:value-of select="' '"/>
                                        </xsl:when>
                                        <xsl:when test="AssetLineType/Category = '2'">
                                            <xsl:value-of select="'X'"/>
                                        </xsl:when>
                                        <xsl:when test="AssetLineType/Category = '3'">
                                            <xsl:value-of select="'X'"/>
                                        </xsl:when>
                                        <xsl:otherwise> </xsl:otherwise>
                                    </xsl:choose>
                                </XSUBNO>
                               <!-- <MAXENTRIES/>-->
                                <TESTRUN/>
                                <POSTCAP/>
                                <XANLGR/>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_ITEM>
                                <ARIBA_SERIAL_NO>
                                    <xsl:value-of select="$v_splitnumber"/>
                                </ARIBA_SERIAL_NO>
                                <ASSETGROUP>
                                    <xsl:value-of select="AssetGroup"/>
                                </ASSETGROUP>
                            </item>
                        </xsl:if>
                      </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </BAPI1022_MISC>
        </n0:ARBCIG_BAPI_ASSET_CREATE>
    </xsl:template>
</xsl:stylesheet>
