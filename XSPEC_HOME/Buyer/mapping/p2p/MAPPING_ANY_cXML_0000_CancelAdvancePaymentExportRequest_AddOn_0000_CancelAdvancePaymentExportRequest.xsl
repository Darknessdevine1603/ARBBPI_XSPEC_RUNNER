<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ns0="urn:Ariba:Buyer:vsap"
    xmlns:n0="urn:sap-com:document:sap:rfc:functions" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="/ns0:CancelAdvancePaymentExportRequest">
        <n0:ARBCIG_ADV_PAYMENT_REV_POST>
            <ARIBA_HDR>
                <ARIBA_ID>
                    <xsl:value-of
                        select="ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:UniqueName"
                    />
                </ARIBA_ID>
            </ARIBA_HDR>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
            <BUS_ACT>
                <xsl:value-of select="'RFST'"/>
            </BUS_ACT>
            <xsl:variable name="v_postingDate" select="ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item[1]/ns0:item[1]/ns0:ERPPostingDate"/>
            <!--Below logic is to consume date if it is in the following format : Example "2018-11-22T18:30:00Z"-->
            <xsl:if test="string-length($v_postingDate) > 8">
            <!--Below POSTINGDATE would be for UTC Format-->
            <POSTINGDATE>
                <xsl:value-of select="concat(substring($v_postingDate,1,4),substring($v_postingDate,6,2),substring($v_postingDate,9,2)
                    ,substring($v_postingDate,12,2),substring($v_postingDate,15,2),substring($v_postingDate,18,2))"/>
            </POSTINGDATE>
            </xsl:if>
            <REVERSAL>
                <OBJ_TYPE>
                    <xsl:value-of select="'BKPFF'"/>
                </OBJ_TYPE>
                <OBJ_KEY>
                    <xsl:value-of
                        select="
                            concat(ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:ERPRequestID,
                            ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:PurchaseOrder/ns0:CompanyCode/ns0:UniqueName,
                            ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:FiscalYear)"
                    />
                </OBJ_KEY>
                <OBJ_KEY_R>
                    <xsl:value-of
                        select="
                            concat(ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:ERPRequestID,
                            ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:PurchaseOrder/ns0:CompanyCode/ns0:UniqueName,
                            ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:FiscalYear)"
                    />
                </OBJ_KEY_R>
                <!--Below Posting Date would be in Normal Format-->
                <!--Example format 'yyyyMMDD'-->
                    <xsl:if
                        test="
                            (ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:ERPPostingDate != ' '
                            and string-length(ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:ERPPostingDate) = 8 )">
                        <PSTNG_DATE>
                        <xsl:value-of
                            select="
                                concat(substring(ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:ERPPostingDate, 1, 4), '-',
                                substring(ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:ERPPostingDate, 5, 2), '-',
                                substring(ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:ERPPostingDate, 7, 2))"
                        />
                        </PSTNG_DATE>
                    </xsl:if>
                <COMP_CODE>
                    <xsl:value-of
                        select="ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:PurchaseOrder/ns0:CompanyCode/ns0:UniqueName"
                    />
                </COMP_CODE>
                <REASON_REV>
                    <xsl:value-of
                        select="ns0:AdvancePayment_CancelAdvancePaymentExportWS_Item/ns0:item/ns0:CancelReason/ns0:ReasonCode"
                    />
                </REASON_REV>
            </REVERSAL>
        </n0:ARBCIG_ADV_PAYMENT_REV_POST>
    </xsl:template>
</xsl:stylesheet>
