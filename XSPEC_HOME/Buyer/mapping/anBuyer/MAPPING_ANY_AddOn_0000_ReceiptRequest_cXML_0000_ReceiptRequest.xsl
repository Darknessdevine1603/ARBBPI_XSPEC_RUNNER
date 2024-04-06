<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anSupplierANID" />
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:variable name="v_pd">
               <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_lang">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:template match="n0:ReceiptDetailRequest">
        <Combined>
            <Payload>
                <cXML>
                    <xsl:attribute name="payloadID">
                        <xsl:value-of select="$anPayloadID"/>
                    </xsl:attribute>
                    <xsl:attribute name="timestamp">
                        <xsl:variable name="curDate">
                            <xsl:value-of select="current-dateTime()"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat(substring(string(current-date()), 1, 10), 'T', substring(string(current-time()), 1, 8), $anERPTimeZone)"/>
                    </xsl:attribute>
                    <Header>
                        <From>
                            <xsl:call-template name="MultiERPTemplateOut">
                                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                            </xsl:call-template>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$anSupplierANID"/>
                                </Identity>
                            </Credential>
                            <!--End Point Fix for CIG-->
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'EndPointID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="'CIG'"/>
                                </Identity>
                            </Credential> 
                        </From>
                        <To>
                            <Credential domain="VendorID">
                                <Identity>
                                    <xsl:value-of select="Header/VENDOR_STATUS"/>
                                </Identity>
                            </Credential>
                        </To>
                        <Sender>
                            <Credential domain="NetworkID">
                                <Identity>
                                    <xsl:value-of select="$anProviderANID"/>
                                </Identity>
                            </Credential>
                            <UserAgent>
                                <xsl:value-of select="'Ariba Supplier'"/>
                            </UserAgent>
                        </Sender>
                    </Header>
                    <Request>
                        <xsl:choose>
                            <xsl:when test="$anEnvName = 'PROD'">
                                <xsl:attribute name="deploymentMode">
                                    <xsl:value-of select="'production'"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="deploymentMode">
                                    <xsl:value-of select="'test'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <ReceiptRequest>
                            <ReceiptRequestHeader>
                                <xsl:attribute name="receiptID">
                                    <xsl:value-of select="Header/MAT_DOC"/>
                                </xsl:attribute>
                                <xsl:if test="string-length(normalize-space(Header/DOC_DATE)) > 0">
                                    <xsl:variable name="v_receiptDate">
                                        <xsl:value-of select='translate(substring(Header/DOC_DATE, 1, 10), "-","")'/>
                                    </xsl:variable>
                                    <xsl:variable name="v_receiptTime">
                                        <xsl:value-of select='translate(substring(Header/ENTRY_TIME, 1, 8), ":","")'/>
                                    </xsl:variable>
                                    <xsl:attribute name="receiptDate">
                                        <xsl:call-template name="ANDateTime">
                                            <xsl:with-param name="p_date" select="$v_receiptDate"/>
                                            <xsl:with-param name="p_time" select="$v_receiptTime"/>
                                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:attribute name="operation">
                                    <xsl:value-of select="'new'"/>
                                </xsl:attribute>
                                <xsl:if test="Header/HEADER_TXT">
                                    <Comments>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(Header/LANGUAGE)) > 0">
                                                    <xsl:value-of select="Header/LANGUAGE"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$v_lang"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="Header/HEADER_TXT"/>                                        
                                    </Comments>
                                </xsl:if>
                                <!-- IG-34221 -->
                                <!-- Map Extrinsic in Reverse GR case -->
                                <xsl:if test="((string-length(normalize-space(Item[1]/REF_DOC)) > 0 ) and (contains(Item[1]/ENTRY_QNT,'-')))">
                                    <Extrinsic name="AribaNetwork.ReceiptId">
                                            <xsl:value-of select="Item[1]/REF_DOC"/>            
                                    </Extrinsic>
                                    <Extrinsic name="AribaNetwork.ReceiptDate">
                                            <xsl:if test="string-length(normalize-space(Header/DOC_DATE)) > 0">
                                                <xsl:variable name="v_receiptDate">
                                                    <xsl:value-of select='translate(substring(Header/DOC_DATE, 1, 10), "-","")'/>
                                                </xsl:variable>
                                                <xsl:variable name="v_receiptTime">
                                                    <xsl:value-of select='translate(substring(Header/ENTRY_TIME, 1, 8), ":","")'/>
                                                </xsl:variable>
                                                <xsl:call-template name="ANDateTime">
                                                    <xsl:with-param name="p_date" select="$v_receiptDate"/>
                                                    <xsl:with-param name="p_time" select="$v_receiptTime"/>
                                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:if>   
                                    </Extrinsic>                                
                                </xsl:if>
                                <!-- IG-34221 -->
                            </ReceiptRequestHeader>
                            <xsl:variable name="shipNoticeID">
                                <xsl:value-of select="Header/SHIPNOTICE_ID"/>
                            </xsl:variable>
                            <xsl:variable name="V_REF_DOC_NO">
                                <xsl:value-of select="Header/REF_DOC_NO"/>
                            </xsl:variable>
                            <xsl:variable name="V_DOC_DATE">
                                <xsl:value-of select="Header/DOC_DATE"/>
                            </xsl:variable> 
                            <!-- CI-2476 -->
                            <xsl:for-each-group select="Item" group-by="concat(PO_NUMBER,SAR_REFERENCE)">  
                                <!-- CI-2476 -->
                                <ReceiptOrder>
                                    <xsl:if test="CLOSE_RECEIVE_PO = 'X'">
                                        <xsl:attribute name="closeForReceiving">
                                            <xsl:value-of select="'yes'"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <ReceiptOrderInfo>
                                        <xsl:choose>
                                            <xsl:when test="REF_DOC_TYPE = 'PO'">                                                
                                                <OrderIDInfo>
                                                    <xsl:attribute name="orderID">
                                                        <xsl:value-of select="PO_NUMBER"/>
                                                    </xsl:attribute>
                                                    <xsl:if test="string-length(normalize-space(ORDER_DATE)) > 0">
                                                        <xsl:variable name="v_orderDate">
                                                            <xsl:value-of select='translate(substring(ORDER_DATE, 1, 10), "-","")'/>
                                                        </xsl:variable>                                        
                                                        <xsl:attribute name="orderDate">
                                                            <xsl:call-template name="ANDateTime">
                                                                <xsl:with-param name="p_date" select="$v_orderDate"/>
                                                                <xsl:with-param name="p_time" select="'120000'"/>
                                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                                            </xsl:call-template>
                                                        </xsl:attribute>
                                                    </xsl:if>                                                   
                                                    <!--IG-17994-->
                                                    <xsl:if test="string-length(normalize-space(REF_DOC)) > 0">
                                                        <IdReference>
                                                            <xsl:attribute name="identifier">
                                                                <xsl:value-of select="REF_DOC"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="domain">
                                                                <xsl:value-of select="'AribaOrderID'"/>
                                                            </xsl:attribute>
                                                        </IdReference>
                                                      </xsl:if>
                                                </OrderIDInfo>
                                            </xsl:when>
                                            <xsl:when test="REF_DOC_TYPE = 'SAR'">
                                                <MasterAgreementIDInfo>
                                                    <xsl:attribute name="agreementID">
                                                        <xsl:value-of select="PO_NUMBER"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="agreementType">
                                                        <xsl:value-of select="'scheduling_agreement'"/>
                                                    </xsl:attribute>
                                                    <xsl:for-each select="current-group()">
                                                        <xsl:if test="string-length(normalize-space(REF_DOC)) > 0">
                                                        <IdReference>
                                                            <xsl:attribute name="identifier">
                                                                <xsl:value-of select="REF_DOC"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="domain"
                                                                ></xsl:attribute>
                                                        </IdReference>
                                                      </xsl:if>
                                                    </xsl:for-each>
                                                </MasterAgreementIDInfo>   
                                            </xsl:when>
                                        </xsl:choose>
                                    </ReceiptOrderInfo>
                                    <xsl:for-each select="current-group()">
                                        <ReceiptItem>
                                            <xsl:variable name="v_qty">
                                                <xsl:value-of
                                                    select="substring-before(normalize-space(ENTRY_QNT), '-')"/>
                                            </xsl:variable>
                                            <xsl:attribute name="receiptLineNumber">
                                                <xsl:value-of select="MATDOC_ITM"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="quantity">
                                                <xsl:choose>
                                                    <xsl:when test="string-length($v_qty) > 0">
                                                        <xsl:value-of select="concat('-', $v_qty)"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="normalize-space(ENTRY_QNT)"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <xsl:attribute name="type">
                                                <xsl:value-of select="TYPE"/>
                                            </xsl:attribute>
                                            <xsl:if test="NO_MORE_GR = 'X'">
                                                <xsl:attribute name="completedIndicator">
                                                    <xsl:value-of select="'yes'"/>
                                                </xsl:attribute>
                                            </xsl:if>                                            
                                            <ReceiptItemReference>
                                                <xsl:attribute name="lineNumber">
                                                    <xsl:value-of select="PO_ITEM"/>
                                                </xsl:attribute>
                                                <ItemID>
                                                    <SupplierPartID>
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(VENDOR_MATERIAL)) > 0">
                                                                <xsl:value-of select="VENDOR_MATERIAL"/>        
                                                            </xsl:when>                                                        
                                                         </xsl:choose>
                                                      </SupplierPartID>
                                                    <BuyerPartID>
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(MATERIAL_LONG)) > 0">
                                                                <xsl:value-of select="MATERIAL_LONG"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="MATERIAL"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </BuyerPartID>                                                    
                                                </ItemID>
                                                    <Description>
                                                        <xsl:attribute name="xml:lang">
                                                            <xsl:value-of select="$v_lang"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="MATERIAL_TEXT"/>
                                                    </Description>
                                                <ShipNoticeIDInfo>
                                                    <xsl:attribute name="shipNoticeID">
                                                        <xsl:value-of select="$shipNoticeID"/>
                                                    </xsl:attribute>
                                                    <xsl:if test="string-length(normalize-space(SHIP_DATE)) > 0">
                                                        <xsl:variable name="v_shipDate">
                                                            <xsl:value-of select='translate(substring(SHIP_DATE, 1, 10), "-","")'/>
                                                        </xsl:variable>                                        
                                                        <xsl:attribute name="shipNoticeDate">
                                                            <xsl:call-template name="ANDateTime">
                                                                <xsl:with-param name="p_date" select="$v_shipDate"/>
                                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                                            </xsl:call-template>
                                                        </xsl:attribute>
                                                    </xsl:if>                                                         
                                                    <IdReference>
                                                        <xsl:attribute name="identifier">
                                                            <xsl:value-of select="$V_REF_DOC_NO"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="domain">
                                                            <xsl:value-of select="'deliveryNoteId'"/>
                                                        </xsl:attribute>
                                                    </IdReference>
                                                    <IdReference>
                                                        <xsl:if test="string-length(normalize-space($V_DOC_DATE)) > 0">
                                                            <xsl:variable name="v_deliveryNoteDate">
                                                                <xsl:value-of select='translate(substring($V_DOC_DATE, 1, 10), "-","")'/>
                                                            </xsl:variable>                                        
                                                            <xsl:attribute name="identifier">
                                                                <xsl:call-template name="ANDateTime">
                                                                    <xsl:with-param name="p_date" select="$v_deliveryNoteDate"/>
                                                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="domain">
                                                                <xsl:value-of select="'deliveryNoteDate'"/>
                                                            </xsl:attribute>
                                                        </xsl:if>
                                                    </IdReference>
                                                </ShipNoticeIDInfo>
                                                <!-- Begin of IG-20754 : Add Shipment line item reference if ASN is created  -->
                                                <xsl:if test="string-length(normalize-space(REF_DOC_IT)) > 0">
                                                    <xsl:variable name="V_REF_DOC_IT">
                                                        <xsl:value-of select="REF_DOC_IT"/>
                                                    </xsl:variable>
                                                    <xsl:if test="$V_REF_DOC_IT > 0">
                                                        <ShipNoticeLineItemReference>
                                                            <xsl:attribute name="shipNoticeLineNumber">
                                                                <xsl:value-of select="$V_REF_DOC_IT"/>
                                                            </xsl:attribute>
                                                        </ShipNoticeLineItemReference>
                                                    </xsl:if>
                                                </xsl:if>
                                                <!-- End of IG-20754 : Add Shipment line item reference -->                                                
                                            </ReceiptItemReference>
                                            <UnitRate>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="CURRENCY_ISO"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="PRICE"/>
                                                </Money>
                                                <UnitOfMeasure>
                                                    <xsl:call-template name="UOMTemplate_Out">
                                                        <xsl:with-param name="p_UOMinput"
                                                            select="ENTRY_UOM_ISO"/>
                                                        <xsl:with-param name="p_anERPSystemID"
                                                            select="$anERPSystemID"/>
                                                        <xsl:with-param name="p_anSupplierANID"
                                                            select="$anSupplierANID"/>
                                                    </xsl:call-template>
                                                </UnitOfMeasure>
                                            </UnitRate>
                                            <ReceivedAmount>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="CURRENCY_ISO"/>
                                                    </xsl:attribute>
                                                    <xsl:variable name="v_amt">                                                    
                                                        <xsl:choose>
                                                            <xsl:when test="string-length($v_qty) > 0">
                                                                <xsl:value-of select="concat('-', PRICE * $v_qty)"
                                                                />
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="PRICE * ENTRY_QNT"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:variable> 
                                                    <xsl:value-of select="format-number(round(100 * $v_amt) div 100, '0.00')"/>      <!-- IG-24141 '#.00' is replaced with '0.00' to support amount with 0 -->                                      
                                                </Money>
                                            </ReceivedAmount>
                                            <!-- Serial no changes -->
                                            <xsl:for-each select="SERIAL_NUMBER">
                                                <xsl:variable name="v_serialID">
                                                    <xsl:value-of select="SERIAL_ID"/>
                                                </xsl:variable>
                                                <xsl:if test="string-length(normalize-space($v_serialID)) > 0">  
                                                    <AssetInfo>
                                                        <xsl:attribute name="location"></xsl:attribute>
                                                        <xsl:attribute name="serialNumber">
                                                            <xsl:value-of select="$v_serialID"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="tagNumber"></xsl:attribute>
                                                    </AssetInfo>
                                                </xsl:if>
                                            </xsl:for-each>   
                                            <xsl:if test="ITEM_TEXT" >
                                                <Comments>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:choose>
                                                            <xsl:when
                                                                test="string-length(normalize-space(/n0:ReceiptDetailRequest/Header/LANGUAGE)) > 0">
                                                                <xsl:value-of
                                                                    select="/n0:ReceiptDetailRequest/Header/LANGUAGE"
                                                                />
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$v_lang"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="ITEM_TEXT"/>                                                    
                                                </Comments>
                                            </xsl:if>
                                        </ReceiptItem>
                                    </xsl:for-each>
                                </ReceiptOrder>
                            </xsl:for-each-group>
                            <Total>
                                <Money>
                                    <xsl:attribute name="currency">
                                        <xsl:value-of select="Item[1]/CURRENCY_ISO"/> <!-- IG-24141 -->
                                    </xsl:attribute>
                                    <xsl:value-of select="Header/AMOUNT"/>
                                </Money>
                            </Total>
                        </ReceiptRequest>
                    </Request>
                </cXML>
            </Payload>            
        </Combined>
    </xsl:template>
</xsl:stylesheet>
