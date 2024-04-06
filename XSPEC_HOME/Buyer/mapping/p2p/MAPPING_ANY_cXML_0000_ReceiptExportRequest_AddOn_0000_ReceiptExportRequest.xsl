<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0"
    xpath-default-namespace="urn:Ariba:Buyer:vsap" xmlns:n0="urn:sap-com:document:sap:rfc:functions">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
<!--       <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>                                    <!-\-IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output-\->-->
    <xsl:template match="ReceiptExportRequest">   
        <xsl:variable name="v_assetDataDetails" select="Receipt_ReceiptAssetDataDetails_Item/item/ReceiptItems/item"/>
        <!--Begin of CI-1014 - GRBASEDINVOICE-->
        <xsl:variable name="v_gr_no_revref">
        <xsl:if test="Receipt_ReceiptHeaderDetails_Item/item/IsReturnReceipt = 'true'">
            <xsl:value-of  select="Receipt_ReceiptHeaderDetails_Item/item/ReferenceReceipt/ERPReceiptNumber"/> 
        </xsl:if>
        </xsl:variable>
        <!--End of CI-1014 - GRBASEDINVOICE-->
        <n0:ARBCIG_GOODS_RECEIPT_CREATE>
            <GR_CODE>
                <GM_CODE>
                    <xsl:value-of select="'01'"/>
                </GM_CODE>
            </GR_CODE>
            <GR_HEADER>
                <xsl:for-each select="Receipt_ReceiptHeaderDetails_Item/item">
                    <ERP_ORDER_ID>
                        <xsl:value-of select="ERPPONumber"/>
                    </ERP_ORDER_ID>
                    <MVMNT_TYPE>
                        <xsl:value-of select="'101'"/>
                    </MVMNT_TYPE>
                    <ARIBA_GRNO>
                        <xsl:value-of select="UniqueName"/>
                    </ARIBA_GRNO>
                    <PSTNG_DATE>
                        <xsl:value-of
                            select="concat(concat(concat(substring(ApprovedDateString, 1, 4), '-'), substring(ApprovedDateString, 5, 2), '-'), substring(ApprovedDateString, 7, 2))"
                        />
                    </PSTNG_DATE>
                    <DOC_DATE>
                        <xsl:choose>
                            <xsl:when
                                test="string-length(normalize-space(RecentReceiveDateInRequesterTimeZone)) &gt; 0">
                                <xsl:value-of
                                    select="concat(concat(concat(substring(RecentReceiveDateInRequesterTimeZone, 1, 4), '-'), substring(RecentReceiveDateInRequesterTimeZone, 5, 2), '-'), substring(RecentReceiveDateInRequesterTimeZone, 7, 2))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat(concat(concat(substring(CreateDateString, 1, 4), '-'), substring(CreateDateString, 5, 2), '-'), substring(CreateDateString, 7, 2))"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </DOC_DATE>
                    <!--Begin of CI-1014 - GRBASEDINVOICE-->
                    <!-- Maping Free text ASNReference to REF_DOC_NO -->
                    <xsl:if test="string-length(normalize-space(ASNReference)) > 0">
                        <REF_DOC_NO>
                            <xsl:value-of select="substring(ASNReference, 1 , 16)"/>
                         </REF_DOC_NO>   
                       </xsl:if>
                    <!--End of CI-1014 - GRBASEDINVOICE-->
                    <HEADER_TXT>
                        <xsl:value-of select="concat('Ariba-', UniqueName)"/>
                    </HEADER_TXT>
                </xsl:for-each>
            </GR_HEADER>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
            <GR_ITEMS>
                <xsl:for-each
                    select="Receipt_ReceiptLineDetails_Item/item/ReceiptItems/item[(LineItem/ReceivingType != '3' and NumberAccepted != 0) or (LineItem/ReceivingType = '3' and AmountAccepted/Amount != 0)]">
                    <item>
                        <xsl:variable name="v_NumberInCollection" select="NumberInCollection"/>
                        <LINE_NO>
                            <xsl:value-of select="NumberInCollection"/>
                        </LINE_NO>
                        <ARIBA_ITEM_NO>
                            <xsl:choose>
                                <xsl:when
                                    test="string-length(normalize-space(LineItem/NumberInCollection)) &gt; 0">
                                    <xsl:value-of select="LineItem/NumberInCollection"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="NumberInCollection"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ARIBA_ITEM_NO>
                        <ARIBA_GR_NO>
                            <xsl:value-of select="ReceiptId"/>
                        </ARIBA_GR_NO>
                        <MOVE_TYPE>
                            <xsl:variable name="v_accept">
                                <xsl:choose>
                                    <xsl:when test="LineItem/ReceivingType = '3'">
                                        <xsl:if test="AmountAccepted/Amount &gt; '0'">
                                            <xsl:value-of select="'X'"/>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="NumberAccepted &gt; '0'">
                                            <xsl:value-of select="'X'"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$v_accept = 'X'">
                                    <xsl:value-of select="'101'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'102'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </MOVE_TYPE>
                        <ENTRY_QNT>
                            <xsl:choose>
                                <xsl:when test="LineItem/ReceivingType = '3'">
                                    <xsl:value-of
                                        select="format-number(AmountAccepted/Amount, '0.000')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="format-number(NumberAccepted, '0.000')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ENTRY_QNT>
                        <ENTRY_UOM>
                            <xsl:value-of select="UnitOfMeasure/UniqueName"/>
                        </ENTRY_UOM>
                        <PO_NUMBER>
                            <xsl:value-of select="ERPPONumber"/>
                        </PO_NUMBER>
                        <PO_ITEM>
                            <xsl:value-of select="ERPPOLineNumber"/>
                        </PO_ITEM>
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <xsl:variable name="v_assetItem" select="$v_assetDataDetails/LineItem/NumberInCollection[text()=$v_NumberInCollection]/../.."/>
                        <xsl:apply-templates select="$v_assetItem/AssetData/AssetData/item/Asset"/>   
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <MVT_IND>B</MVT_IND>
                        <!--Begin of CI-1014 - GRBASEDINVOICE-->
                        <!-- Maping Free text ASNReference to REF_DOC_NO -->
                        <xsl:if test="string-length(normalize-space($v_gr_no_revref)) > 0">
                            <GR_NUMBER>
                               <xsl:value-of select="$v_gr_no_revref"/>
                            </GR_NUMBER>
                        </xsl:if>
                        <!--End of CI-1014 - GRBASEDINVOICE-->
                    </item>
                </xsl:for-each>
            </GR_ITEMS>
            <GR_SERIALNUMBER>
                <xsl:for-each
                    select="$v_assetDataDetails">
                    <xsl:variable name="v_line" select="LineItem/NumberInCollection"/>
                    <xsl:for-each select="AssetData/AssetData/item"> 
                         <item>
                             <MATDOC_ITM>
                                 <xsl:value-of select="$v_line"/>
                             </MATDOC_ITM>
                             <SERIALNO>
                                 <xsl:value-of select="SerialNumber"/>
                             </SERIALNO>
                         </item>
                    </xsl:for-each>
                </xsl:for-each>
            </GR_SERIALNUMBER>
        </n0:ARBCIG_GOODS_RECEIPT_CREATE>
    </xsl:template>
    <xsl:template match="UniqueName">
        <ASSET_NO>
            <xsl:value-of select="text()"/>
        </ASSET_NO>
    </xsl:template>
    <xsl:template match="SubNumber">
        <SUB_NUMBER>
            <xsl:value-of select="text()"/>
        </SUB_NUMBER>
    </xsl:template>
</xsl:stylesheet>
