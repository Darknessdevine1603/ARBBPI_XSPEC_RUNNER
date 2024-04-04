<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ns0="urn:Ariba:Buyer:vsap" xmlns:n0="urn:sap-com:document:sap:rfc:functions" 
    exclude-result-prefixes="#all" version="2.0">                                                              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
<!--    		    <xsl:include href="../../../../BUYER_CONTENT/common/FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
    <xsl:template match="/ns0:AdvancePaymentExportRequest">
        <xsl:variable name="v_header" select="ns0:AdvancePayment_AdvancePaymentExportWS_Item/ns0:item"/>
        <xsl:variable name="v_line" select="ns0:AdvancePayment_AdvancePaymentLineItemExportWS_Item/ns0:item/ns0:LineItems/ns0:item"/>
        <n0:ARBCIG_ADV_PAYMENT_POST>
            <ARIBA_HDR>
                <ARIBA_ID>
                    <xsl:value-of select="$v_header/ns0:UniqueName"/>
                </ARIBA_ID>
            </ARIBA_HDR>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
<!--                Below logic is to consume date if it is in the following format : Example "2018-11-22T18:30:00Z"-->
                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
             <xsl:variable name="v_netDueDate" select="ns0:AdvancePayment_AdvancePaymentExportWS_Item/ns0:item/ns0:NetDueDate"/>   
             <xsl:if test="exists($v_netDueDate)
                    and string-length(normalize-space($v_netDueDate)) > 0">
                    <BLINEDATE>
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_netDueDate)) > 8">
                                <xsl:call-template name="formatUTCDate">
                                    <xsl:with-param name="p_UTCDate" select = "$v_netDueDate"/>                         
                                </xsl:call-template>
                            </xsl:when>
                            <!--                            Below logic is to consume date if it is in the following format : Example "20181122"-->                            
                            <xsl:otherwise>
                                <xsl:value-of select="concat($v_netDueDate, '000000')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </BLINEDATE> 
                </xsl:if>        
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
<!--                Below logic is to consume date if it is in the following format : Example "2018-11-22T18:30:00Z"-->
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:variable name="v_createDate" select="ns0:AdvancePayment_AdvancePaymentExportWS_Item/ns0:item/ns0:CreateDate"/>    
                <xsl:if test="exists($v_createDate)
                    and string-length(normalize-space($v_createDate)) > 0">
                    <DOCDATE>
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_createDate)) > 8">
                                <xsl:call-template name="formatUTCDate">
                                    <xsl:with-param name="p_UTCDate" select = "$v_createDate"/>                         
                                </xsl:call-template>
                            </xsl:when>
<!--                            Below logic is to consume date if it is in the following format : Example "20181122"-->
                            <xsl:otherwise>
                                <xsl:value-of select="concat($v_createDate, '000000')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </DOCDATE>
                </xsl:if>     
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <DOCUMENTHEADER>
                <OBJ_TYPE>
                    <xsl:value-of select="'BKPFF'"/>
                </OBJ_TYPE>
                <BUS_ACT>
                    <xsl:value-of select="'RFST'"/>
                </BUS_ACT>
                <HEADER_TXT>
                    <xsl:value-of select="$v_header/ns0:Name"/>
                </HEADER_TXT>
                <COMP_CODE>
                    <xsl:value-of select="$v_header/ns0:PurchaseOrder/ns0:CompanyCode/ns0:UniqueName"/>
                </COMP_CODE>
                <!--Below logic is to consume date , if supplied by P2P in the following format yyyyMMdd-->
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:if test="string-length(normalize-space($v_header/ns0:CreateDate)) > 0">
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->    
                    <DOC_DATE>
                        <xsl:choose>
                            <xsl:when test="contains($v_header/ns0:CreateDate, '-')">
                                <xsl:value-of select="substring($v_header/ns0:CreateDate, 1, 10)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="formatDate">
                                    <xsl:with-param name="p_date" select="$v_header/ns0:CreateDate"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                     </DOC_DATE>
                 </xsl:if>
                <DOC_TYPE>
                    <xsl:value-of select="$v_header/ns0:DocumentType/ns0:UniqueName"/>
                </DOC_TYPE>
            </DOCUMENTHEADER>
            <ACCOUNTPAYABLE>
                <xsl:for-each select="$v_line">
                    <item>
                        <ITEMNO_ACC>
                            <xsl:value-of select="ns0:NumberInCollection"/>
                        </ITEMNO_ACC>
                        <VENDOR_NO>
                            <xsl:value-of select="$v_header/ns0:Supplier/ns0:UniqueName"/>
                        </VENDOR_NO>
                        <COMP_CODE>
                            <xsl:value-of select="$v_header/ns0:PurchaseOrder/ns0:CompanyCode/ns0:UniqueName"/>
                        </COMP_CODE>
                        <!--Below logic is to consume date , if supplied by P2P in the following format yyyyMMdd-->
                        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <xsl:if test="string-length(normalize-space($v_header/ns0:NetDueDate)) > 0 ">
                            <BLINE_DATE>
                                <xsl:choose>
                                    <xsl:when test="contains($v_header/ns0:NetDueDate, '-')">
                                        <xsl:value-of select="substring($v_header/ns0:NetDueDate, 1, 10)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="formatDate">
                                            <xsl:with-param name="p_date" select="$v_header/ns0:NetDueDate"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </BLINE_DATE>
                            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        </xsl:if>
                        <PYMT_METH>
                            <xsl:value-of select="$v_header/ns0:PaymentMethodType/ns0:UniqueName"/>
                        </PYMT_METH>
                        <SP_GL_IND>
                            <xsl:value-of select="'F'"/>
                        </SP_GL_IND>
                    </item>
                </xsl:for-each>
            </ACCOUNTPAYABLE>
            <CURRENCYAMOUNT>
                <xsl:for-each select="$v_line">
                    <item>
                        <ITEMNO_ACC>
                            <xsl:value-of select="ns0:NumberInCollection"/>
                        </ITEMNO_ACC>
                        <CURRENCY>
                            <xsl:value-of select="$v_header/ns0:Amount/ns0:Currency/ns0:UniqueName"/>
                        </CURRENCY>
                        <AMT_DOCCUR>
                            <xsl:value-of select="format-number((ns0:Amount/ns0:Amount),'#.0000')"/>
                        </AMT_DOCCUR>
                    </item>
                </xsl:for-each>
            </CURRENCYAMOUNT>
            <EXTENSION2>
                <xsl:for-each select="$v_line">
                    <item>
                        <STRUCTURE>
                            <xsl:value-of select="'PO_DETAIL'"/>
                        </STRUCTURE>
                        <VALUEPART1>
                            <xsl:value-of select="ns0:NumberInCollection"/>
                        </VALUEPART1>
                        <VALUEPART2>
                            <xsl:value-of select="$v_header/ns0:PurchaseOrder/ns0:OrderID"/>
                        </VALUEPART2>
                        <VALUEPART3>
                            <xsl:value-of select="ns0:OrderLineItem/ns0:SAPPOLineNumber"/>
                        </VALUEPART3>
                    </item>
                    <item>
                        <STRUCTURE>
                            <xsl:value-of select="'TRG_GL_IND'"/>
                        </STRUCTURE>
                        <VALUEPART1>
                            <xsl:value-of select="ns0:NumberInCollection"/>
                        </VALUEPART1>
                        <VALUEPART2>
                            <xsl:value-of select="$v_header/ns0:GLIndicator/ns0:UniqueName"/>
                        </VALUEPART2>
                    </item>
                </xsl:for-each>
            </EXTENSION2>
        </n0:ARBCIG_ADV_PAYMENT_POST>
    </xsl:template>
    <xsl:template name="formatDate">
        <xsl:param name="p_date"/>
        <xsl:value-of select="concat(substring($p_date, 1, 4), '-', substring($p_date, 5, 2), '-', substring($p_date, 7, 2))"/>
    </xsl:template>
</xsl:stylesheet>
