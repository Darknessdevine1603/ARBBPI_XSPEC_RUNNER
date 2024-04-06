<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:urn="urn:Ariba:Buyer:vsap" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!--A map that holds response success sub-element name for a transaction type -->
    <xsl:variable name="v_iDMap">
        <entry key="PurchaseOrderAsyncImportPullRequest">
            <xsl:value-of select="'Requisition_PurchOrdNumberImport_Item'"/>
        </entry>
        <entry key="ReservationDeleteAsyncImportPullRequest">
            <xsl:value-of select="'Reservation_ReservationSuccessImport_Item'"/>
        </entry>
        <entry key="ReservationAsyncImportPullRequest">
            <xsl:value-of select="'Reservation_ReservationSuccessImport_Item'"/>
        </entry>
        <entry key="PurchaseOrderChangeAsyncResponsePullRequest">
            <xsl:value-of select="'ERPOrder_ChangePurchOrdNumberPull_Item'"/>
        </entry>
        <entry key="PurchaseOrderCancelAsyncResponsePullRequest">
            <xsl:value-of select="'ERPOrder_CancelPurchOrdNumberPull_Item'"/>
        </entry>
        <entry key="ReceiptAsyncImportPullRequest">
            <xsl:value-of select="'Receipt_ReceiptNumberImport_Item'"/>
        </entry>
        <entry key="ServiceSheetAsyncResponsePullRequest">
            <xsl:value-of select="'ServiceSheet_ServiceSheetIDImport_Item'"/>
        </entry>
        <entry key="ServiceSheetImportPullRequest">
            <xsl:value-of select="'ServiceSheet_ServiceSheetStatusImport_Item'"/>
        </entry>
        <entry key="AdvancePaymentAsyncImportPullRequest">
            <xsl:value-of select="'AdvancePayment_AdvancePaymentIDImport_Item'"/>
        </entry>
        <entry key="CancelAdvancePaymentAsyncImportRequest">
            <xsl:value-of select="'AdvancePayment_CancelAdvancePaymentIDImport_Item'"/>
        </entry>
        <entry key="PurchaseOrderERPHeaderStatusAsyncImportRequest">
            <xsl:value-of select="'ERPOrder_PurchOrdHeaderStatusPull_Item'"/>
        </entry>
        <entry key="PaymentAsyncResponsePullRequest">
            <xsl:value-of select="'Payment_PaymentNumberImport_Item'"/>
        </entry>
<!--        CI-2221-->
        <entry key="PaymentAsyncResponsePull_v2Request">
            <xsl:value-of select="'Payment_PaymentNumberImport_Item'"/>
        </entry>
<!--        CI-2221-->
        <entry key="ServiceSheetStatusAsyncResponsePullRequest">
            <xsl:value-of select="'ServiceSheet_ServiceSheetIDImport_Item'"/>
        </entry>
        <entry key="AggregatedRequisitionRevertBudgetAsyncImportPullRequest">
            <xsl:value-of select="'Requisition_AggregatedRequisitionRevertBudgetAsyncImportSuccess_Item'"/>
        </entry>
        <entry key="InvoiceReconciliationStatusPullRequest">
            <xsl:value-of select="'IRStatusChangeInput_Item'"/>
        </entry>
    </xsl:variable>
    <!--A map that holds response error sub-element name for a transaction type -->
    <xsl:variable name="v_errorMap">
        <entry key="PurchaseOrderAsyncImportPullRequest">
            <xsl:value-of select="'PurchaseOrderError_PurchOrdErrorImport_Item'"/>
        </entry>
        <entry key="ReservationAsyncImportPullRequest">
            <xsl:value-of select="'ReservationError_ReservationErrorImport_Item'"/>
        </entry>
        <entry key="ReservationDeleteAsyncImportPullRequest">
            <xsl:value-of select="'ReservationError_ReservationErrorImport_Item'"/>
        </entry>
        <entry key="PurchaseOrderChangeAsyncResponsePullRequest">
            <xsl:value-of select="'PurchaseOrderError_PurchOrdErrorImport_Item'"/>
        </entry>
        <entry key="PurchaseOrderCancelAsyncResponsePullRequest">
            <xsl:value-of select="'PurchaseOrderError_PurchOrdErrorImport_Item'"/>
        </entry>
        <entry key="ReceiptAsyncImportPullRequest">
            <xsl:value-of select="'ReceiptError_ReceiptErrorImport_Item'"/>
        </entry>
        <entry key="ServiceSheetAsyncResponsePullRequest">
            <xsl:value-of select="'ServiceSheetError_ServiceSheetErrorImport_Item'"/>
        </entry>
        <entry key="AdvancePaymentAsyncImportPullRequest">
            <xsl:value-of select="'AdvancePaymentError_AdvancePaymentErrorImport_Item'"/>
        </entry>
        <entry key="CancelAdvancePaymentAsyncImportRequest">
            <xsl:value-of select="'AdvancePaymentError_AdvancePaymentCancelErrorImport_Item'"/>
        </entry>
        <entry key="PaymentAsyncResponsePullRequest">
            <xsl:value-of select="'PayablePushError_PaymentErrorImport_Item'"/>
        </entry>
<!--        CI-2221-->
        <entry key="PaymentAsyncResponsePull_v2Request">
            <xsl:value-of select="'PayablePushError_PaymentErrorImport_Item'"/>
        </entry>
<!--        CI-2221-->
        <entry key="ServiceSheetStatusAsyncResponsePullRequest">
            <xsl:value-of select="'ServiceSheetError_ServiceSheetErrorImport_Item'"/>
        </entry>
        <entry key="AggregatedRequisitionRevertBudgetAsyncImportPullRequest">
            <xsl:value-of select="'RequisitionError_RequisitionErrorImport_Item'"/>
        </entry>
    </xsl:variable>
    <!-- A map that holds the ERP document number's element name for a transaction type -->
    <xsl:variable name="v_docNoMap">
        <entry key="ReceiptAsyncImportPullRequest">
            <xsl:value-of select="'ERPReceiptNumber'"/>
        </entry>
        <entry key="ServiceSheetAsyncResponsePullRequest">
            <xsl:value-of select="'ERPServiceSheetID'"/>
        </entry>
        <entry key="AdvancePaymentAsyncImportPullRequest">
            <xsl:value-of select="'ERPRequestID'"/>
        </entry>
        <entry key="CancelAdvancePaymentAsyncImportRequest">
            <xsl:value-of select="'ERPRequestID'"/>
        </entry>
        <entry key="PaymentAsyncResponsePullRequest">
            <xsl:value-of select="'ERPPayableNumber'"/>
        </entry>
<!--        CI-2221-->
        <entry key="PaymentAsyncResponsePull_v2Request">
            <xsl:value-of select="'ERPPayableNumber'"/>
        </entry>
<!--        CI-2221-->
    </xsl:variable>
    <!-- A map that holds the ERP document item number's element name for a transaction type -->
    <xsl:variable name="v_itemMap">
        <entry key="PurchaseOrderAsyncImportPullRequest">
            <xsl:value-of select="'SAPPOLineNumber'"/>
        </entry>
        <entry key="PurchaseOrderChangeAsyncResponsePullRequest">
            <xsl:value-of select="'SAPPOLineNumber'"/>
        </entry> 
        <entry key="ReceiptAsyncImportPullRequest">
            <xsl:value-of select="'ERPReceiptLineNumber'"/>
        </entry>   
        <entry key="ReqLineNumber">
            <xsl:value-of select="'AribaItemID'"/>
        </entry>
    </xsl:variable>
    <xsl:variable name="v_statusMap">
        <entry key="ServiceSheetImportPullRequest">
            <xsl:value-of select="'Status'"/>
        </entry>
        <entry key="PurchaseOrderERPHeaderStatusAsyncImportRequest">
            <xsl:value-of select="'ERPAllowCancel'"/>
        </entry>
    </xsl:variable>
    <xsl:variable name="v_lineItemMap">
        <entry key="PurchaseOrderAsyncImportPullRequest">
            <xsl:value-of select="'LineItems'"/>
        </entry>
        <entry key="PurchaseOrderChangeAsyncResponsePullRequest">
            <xsl:value-of select="'LineItems'"/>
        </entry>
        <entry key="ReceiptAsyncImportPullRequest">
            <xsl:value-of select="'ReceiptItems'"/>
        </entry>
        <entry key="ReservationDeleteAsyncImportPullRequest">
            <xsl:value-of select="'LineItems'"/>
        </entry>
        <entry key="ReservationAsyncImportPullRequest">
            <xsl:value-of select="'LineItems'"/>
        </entry>
    </xsl:variable>
    <!-- The above maps needs to be changed when any new transaction is supported -->
    <xsl:template match="n0:ERPRespToAribaBuyerMsg">
        <!-- Below variables are local variables-->
        <xsl:variable name="v_transType" select="TransactionType"/>
        <xsl:variable name="v_docNo" select="$v_docNoMap/entry[@key=$v_transType]"/>
        <xsl:variable name="v_itemNo" select="$v_itemMap/entry[@key=$v_transType]"/>
        <xsl:variable name="v_status" select="$v_statusMap/entry[@key=$v_transType]"/>
        <xsl:variable name="v_lineItem" select="$v_lineItemMap/entry[@key=$v_transType]|Item[1]/@name"/>
        <!-- Local variables end -->
        <xsl:element name="urn:{$v_transType}">
            <xsl:attribute name="partition" select="Header/Partition"/>
            <xsl:attribute name="variant" select="Header/Variant"/>
            <xsl:choose>
                <xsl:when test="LogMessage">
                    <xsl:element name="urn:{$v_errorMap/entry[@key=$v_transType]}">
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
                                <!--IG-32704-->
<!--                                CI-2221-->
                                <xsl:if test="not($v_transType = ('AdvancePaymentAsyncImportPullRequest','PaymentAsyncResponsePullRequest','PaymentAsyncResponsePull_v2Request','CancelAdvancePaymentAsyncImportRequest'))">
<!--                                CI-2221-->
                                <!--IG-32704-->
                                    <urn:ErrorClient>
                                        <xsl:call-template name="setValue">
                                            <xsl:with-param name="value" select="Mandt"/>
                                        </xsl:call-template>
                                    </urn:ErrorClient>
                                    <urn:ErrorSAPModule>
                                        <xsl:call-template name="setValue">
                                            <xsl:with-param name="value" select="ErrorSAPModule"/>
                                        </xsl:call-template>
                                    </urn:ErrorSAPModule>
                                    <urn:ErrorSAPScreen>
                                        <xsl:call-template name="setValue">
                                            <xsl:with-param name="value" select="ErrorSAPScreen"/>
                                        </xsl:call-template>
                                    </urn:ErrorSAPScreen>
                                    <urn:ErrorSystem>
                                        <xsl:call-template name="setValue">
                                            <xsl:with-param name="value" select="LogicalSystem"/>
                                        </xsl:call-template>
                                    </urn:ErrorSystem>
                                    <xsl:if test="string-length(AribaItemID) > 0" >
                                    <urn:ReqLineNumber>
                                        <xsl:call-template name="setValue">
                                            <xsl:with-param name="value" select="AribaItemID"/>
                                        </xsl:call-template>
                                    </urn:ReqLineNumber>
                                    </xsl:if>
                                </xsl:if>
                            </urn:item>
                        </xsl:for-each>
                    </xsl:element>
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
                    <xsl:element name="urn:{$v_iDMap/entry[@key=$v_transType]|Header/@name}">
                        <urn:item>
                            <xsl:variable name="v_uniqueName" select="Header/AribaDocumentID"/>
                            <xsl:if test="$v_uniqueName">
                                <urn:UniqueName>
                                    <xsl:value-of select="$v_uniqueName"/>
                                </urn:UniqueName>
                            </xsl:if>
                            <xsl:if test="$v_docNo">
                                <xsl:element name="urn:{$v_docNo}">
                                    <xsl:value-of select="Header/SAPDocumentID"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:variable name="v_version" select="Header/Version"/>
                            <xsl:if test="$v_version">
                                <urn:ERPPOVersionNumber>
                                    <xsl:value-of select="$v_version"/>
                                </urn:ERPPOVersionNumber>
                            </xsl:if>
                            <xsl:if test="$v_status">
                                <xsl:element name="urn:{$v_status}">
                                    <xsl:value-of select="Header/Status"/>
                                </xsl:element>
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
                                <xsl:if test="$v_lineItem">
                                    <xsl:element name="urn:{$v_lineItem}">
                                        <xsl:for-each select="Item">
                                            <urn:item>
                                                <xsl:if test="$v_transType = 'PurchaseOrderAsyncImportPullRequest'">
                                                    <xsl:variable name="v_poNumber" select="../Header/SAPDocumentID"/>
                                                    <xsl:if test="$v_poNumber">
                                                        <urn:ERPPONumber>
                                                            <xsl:value-of select="$v_poNumber"/>
                                                        </urn:ERPPONumber>
                                                    </xsl:if>
                                                </xsl:if>
                                                <xsl:if test="AribaItemID">
                                                    <urn:NumberInCollection>
                                                        <xsl:value-of select="AribaItemID"/>
                                                    </urn:NumberInCollection>    
                                                </xsl:if>
                                                <xsl:if test="$v_itemNo">
                                                    <xsl:element name="urn:{$v_itemNo}">
                                                        <xsl:value-of select="SAPItemID"/>
                                                    </xsl:element>
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
                                    </xsl:element>
                                </xsl:if>
                            </xsl:if>
                        </urn:item>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
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
