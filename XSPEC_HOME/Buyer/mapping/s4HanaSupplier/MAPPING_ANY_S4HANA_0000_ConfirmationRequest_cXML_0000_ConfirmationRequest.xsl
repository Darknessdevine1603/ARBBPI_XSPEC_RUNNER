<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="http://sap.com/xi/EDI" xmlns:xop="http://www.w3.org/2004/08/xop/include" xmlns:hci="http://sap.com/it/" version="2.0" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes"  omit-xml-declaration="yes" />
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
<!--<xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl" />-->
    <xsl:param name="anTargetDocumentType" />
    <xsl:param name="anEnvName" />
    <xsl:param name="anERPSystemID" />
    <xsl:param name="anSenderDefaultTimeZone"/>
    <xsl:param name="anSenderID" />
    <xsl:param name="anReceiverID" />
    <xsl:param name="anPayloadID" />
    <xsl:param name="anProviderANID"/>
    <xsl:param name="exchange"/>
    <xsl:variable name="v_currDT">
        <xsl:value-of select="current-dateTime()" />
    </xsl:variable>
    <xsl:variable name="v_cigDT">
        <xsl:value-of select="concat(substring-before($v_currDT, 'T'), 'T', substring(substring-after($v_currDT, 'T'), 1, 8))" />
    </xsl:variable>
    <xsl:variable name="v_cigTS">
        <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="$v_cigDT" />
            <xsl:with-param name="p_timezone" select="$anSenderDefaultTimeZone" />
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_erpDT">
        <xsl:call-template name="ERPDateTime">
            <xsl:with-param name="p_date" select="/n0:OrderConfRequest/MessageHeader/CreationDateTime" />
            <xsl:with-param name="p_timezone" select="$anSenderDefaultTimeZone" />
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_lang">
        <xsl:choose>
            <xsl:when test="string-length(/n0:OrderConfRequest/OrderConfirmation/Party[@PartyType = 'SoldTo']/Address/CorrespondenceLanguage) &gt; 0">
                <xsl:value-of select="/n0:OrderConfRequest/OrderConfirmation/Party[@PartyType = 'SoldTo']/Address/CorrespondenceLanguage" />
            </xsl:when>
            <xsl:when test="string-length(/n0:OrderConfRequest/OrderConfirmation/Party[@PartyType = 'BillTo']/Address/CorrespondenceLanguage) &gt; 0">
                <xsl:value-of select="/n0:OrderConfRequest/OrderConfirmation/Party[@PartyType = 'BillTo']/Address/CorrespondenceLanguage" />
            </xsl:when>
            <xsl:when test="string-length(/n0:OrderConfRequest/OrderConfirmation/Party[@PartyType = 'ShipTo']/Address/CorrespondenceLanguage) &gt; 0">
                <xsl:value-of select="/n0:OrderConfRequest/OrderConfirmation/Party[@PartyType = 'ShipTo']/Address/CorrespondenceLanguage" />
            </xsl:when>
            <xsl:otherwise>EN</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="n0:OrderConfRequest">
        <cXML>
            <xsl:attribute name="payloadID">
                <xsl:value-of select="$anPayloadID" />
            </xsl:attribute>
            <xsl:attribute name="timestamp">
                <xsl:value-of select="$v_cigTS" />
            </xsl:attribute>
            <Header>
                <From>
                    <Credential>
                        <xsl:attribute name="domain">NetworkID</xsl:attribute>
                        <Identity>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(OrderConfirmation/SupplierSystemID)) > 0">
                                    <xsl:value-of select="OrderConfirmation/SupplierSystemID"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$anSenderID" />
                                </xsl:otherwise>
                            </xsl:choose>                          
                        </Identity>
                    </Credential>
                </From>
                <To>
                    <Credential>
                        <xsl:attribute name="domain">NetworkID</xsl:attribute>
                        <Identity>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(OrderConfirmation/BuyerSystemID)) > 0">
                                    <xsl:value-of select="OrderConfirmation/BuyerSystemID"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$anReceiverID" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </Identity>
                    </Credential>
                </To>
                <Sender>
                    <Credential>
                        <xsl:attribute name="domain">NetworkID</xsl:attribute>
                        <Identity>
                            <xsl:value-of select="'AN01000000087'" />
                        </Identity>
                    </Credential>
                    <UserAgent>Ariba_Supplier</UserAgent>
                </Sender>
            </Header>
            <Request>
                <xsl:attribute name="deploymentMode">
                    <xsl:choose>
                        <xsl:when test="($anEnvName = 'PROD')">production</xsl:when>
                        <xsl:otherwise>test</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <ConfirmationRequest>
                    <ConfirmationHeader>
                        <xsl:attribute name="confirmID">
                            <xsl:value-of select="/n0:OrderConfRequest/OrderConfirmation/SalesOrderID" />
                        </xsl:attribute>
                        <xsl:variable name="v_actionCode">
                            <xsl:value-of select="translate(/n0:OrderConfRequest/OrderConfirmation/ActionCode, ' ','')"
                            />
                        </xsl:variable>
                        <xsl:attribute name="operation">
                            <xsl:choose>
                                <xsl:when test="$v_actionCode = '01' or $v_actionCode = ''">new</xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$v_actionCode = '02'">update</xsl:when>
                                        <xsl:otherwise></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="type">
                            <xsl:value-of select="'allDetail'" />
                        </xsl:attribute>
                        <xsl:attribute name="noticeDate">
                            <xsl:value-of select="$v_erpDT" />
                        </xsl:attribute>
                        <Comments>
                            <xsl:call-template name="OutboundS4Attachment">
                                <xsl:with-param name="HeaderAttachment"
                                    select="OrderConfirmation/Attachment"/>
                            </xsl:call-template>
                        </Comments>
                        <!--  CI-2773 4A1 - Comments on Order Confirmation Header and Line Item -->
                        <xsl:for-each select="/n0:OrderConfRequest/OrderConfirmation/Text">
                            <xsl:if test="@Type = 'SupplierComments'">
                                <Comments>
                                    <xsl:attribute name="xml:lang">
                                        <xsl:value-of select="TextElementLanguage"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="type">
                                        <xsl:value-of select="@Type"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="TextElementText"/>
                                </Comments>
                            </xsl:if>
                        </xsl:for-each>
                        <!--  CI-2773 -->
<!--Send the Fileanme to Platform, since MIME header from S4 doesn't send content/filename in the header.     
                Format sent to platform.    
                cid:cidValue1#filename1|cid:cidvalid2#filename2-->
                        <xsl:variable name="ancXMLAttachments">
                            <xsl:for-each select="OrderConfirmation/Attachment">
                                <xsl:value-of
                                    select="concat(string-join((*[namespace-uri() = 'http://www.w3.org/2004/08/xop/include' and local-name() = 'Include']/@href, @FileName,@MimeType), ';'), '#')"/>
                            </xsl:for-each>
                        </xsl:variable> 
                     
                      <xsl:if test="$ancXMLAttachments">
                          <!-- This is to make XSPEC assume that $ancXMLAttachments has some value -->
                      </xsl:if>          
<!--<an><xsl:value-of select="$ancXMLAttachments"/></an>-->
                    </ConfirmationHeader>
                    <OrderReference>
                        <xsl:attribute name="orderID">
                            <xsl:value-of select="/n0:OrderConfRequest/OrderConfirmation/PurchaseOrderID" />
                        </xsl:attribute>
                        <DocumentReference>
                            <xsl:attribute name="payloadID" />
                        </DocumentReference>
                    </OrderReference>
                    <xsl:for-each select="/n0:OrderConfRequest/OrderConfirmation/Item">
                        <ConfirmationItem>
                            <xsl:attribute name="lineNumber">
                                <xsl:value-of select="replace(PurchaseOrderItemID, '^0+', '')" />
                            </xsl:attribute>
                            <xsl:attribute name="quantity">
                                <xsl:value-of select="RequestedQuantity" />
                            </xsl:attribute>
                            <UnitOfMeasure>
                                <xsl:value-of select="RequestedQuantity/@unitCode" />
                            </UnitOfMeasure>
                            <xsl:choose>
                                <xsl:when test="exists(SalesDocumentRjcnReason)">
                                    <ConfirmationStatus>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="RequestedQuantity" />
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'reject'" />
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="RequestedQuantity/@unitCode" />
                                        </UnitOfMeasure>
                                        <ItemIn>
                                            <xsl:attribute name="lineNumber">
                                                <xsl:value-of select="replace(PurchaseOrderItemID, '^0+', '')" />
                                            </xsl:attribute>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="RequestedQuantity" />
                                            </xsl:attribute>
                                            <ItemID>
                                                <SupplierPartID>
                                                    <xsl:value-of select="Product/SupplierProductID" />
                                                </SupplierPartID>
                                                <!-- IG-34318 -->
                                                <!-- Removing Hard coded value for BuyerPartId -->
                                                <BuyerPartID>
                                                    <xsl:if test="string-length(Product/BuyerProductID) &gt; 0">
                                                            <xsl:value-of select="Product/BuyerProductID" />
                                                    </xsl:if>
                                                </BuyerPartID>
                                                <!-- IG-34318 -->
                                            </ItemID>
                                            <ItemDetail>
                                                <UnitPrice>
                                                    <Money>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="NetPrice/Amount/@currencyCode" />
                                                        </xsl:attribute>
                                                        <xsl:value-of select="NetPrice/Amount" />
                                                    </Money>
                                                </UnitPrice>
                                                <Description>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:value-of select="upper-case($v_lang)" />
                                                    </xsl:attribute>
                                                    <xsl:value-of select="OrderItemText" />
                                                </Description>
                                                <UnitOfMeasure>
                                                    <xsl:value-of select="RequestedQuantity/@unitCode" />
                                                </UnitOfMeasure>
                                                <PriceBasisQuantity>
                                                    <xsl:attribute name="conversionFactor">
                                                        <xsl:value-of select="'1'" />
                                                    </xsl:attribute>
                                                    <xsl:attribute name="quantity">
                                                        <xsl:value-of select="NetPrice/BaseQuantity" />
                                                    </xsl:attribute>
                                                    <UnitOfMeasure>
                                                        <xsl:value-of select="NetPrice/BaseQuantity/@unitCode" />
                                                    </UnitOfMeasure>
                                                </PriceBasisQuantity>
                                                <Classification domain="NotAvailable" />
                                            </ItemDetail>
                                        </ItemIn>
                                        <Comments>
                                            <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="upper-case($v_lang)" />
                                            </xsl:attribute>
                                            <xsl:value-of select="concat(SalesDocumentRjcnReason, '_' , SalesDocumentRjcnReasonName)" />
                                        </Comments>
                                        <!--  CI-2773 4A1 - Comments on Order Confirmation Header and Line Item -->
                                        <xsl:for-each select="Text">
                                            <xsl:if test="@Type = 'SupplierComments'">
                                                <Comments>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:value-of select="TextElementLanguage"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="type">
                                                        <xsl:value-of select="@Type"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="TextElementText"/>
                                                </Comments>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <!--  CI-2773  --> 
                                    </ConfirmationStatus>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="ScheduleLine[ConfirmedOrderQuantityByMaterialAvailableCheck != 0]">
                                        <ConfirmationStatus>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="ConfirmedOrderQuantityByMaterialAvailableCheck" />
                                            </xsl:attribute>
                                            <xsl:attribute name="type">
                                                <xsl:value-of select="'allDetail'" />
                                            </xsl:attribute>
                                            <xsl:attribute name="deliveryDate">
                                                <xsl:value-of select="concat(ConfirmedDeliveryDate, 'T00:00:00', $anSenderDefaultTimeZone)" />
                                            </xsl:attribute>
                                            <UnitOfMeasure>
                                                <xsl:value-of select="ConfirmedOrderQuantityByMaterialAvailableCheck/@unitCode" />
                                            </UnitOfMeasure>
                                            <ItemIn>
                                                <xsl:attribute name="lineNumber">
                                                    <xsl:value-of select="replace(../PurchaseOrderItemID, '^0+', '')" />
                                                </xsl:attribute>
                                                <xsl:attribute name="quantity">
                                                    <xsl:value-of select="ConfirmedOrderQuantityByMaterialAvailableCheck" />
                                                </xsl:attribute>
                                                <ItemID>
                                                    <SupplierPartID>
                                                        <xsl:value-of select="../Product/SupplierProductID" />
                                                    </SupplierPartID>
                                                    <!-- IG-34318 -->
                                                    <!-- Removing Hard coded value for BuyerPartId -->
                                                    <BuyerPartID>
                                                        <xsl:if test="string-length(../Product/BuyerProductID) &gt; 0">
                                                            <xsl:value-of select="../Product/BuyerProductID" />
                                                        </xsl:if>
                                                    </BuyerPartID>
                                                    <!-- IG-34318 -->
                                                </ItemID>
                                                <ItemDetail>
                                                    <UnitPrice>
                                                        <Money>
                                                            <xsl:attribute name="currency">
                                                                <xsl:value-of select="../NetPrice/Amount/@currencyCode" />
                                                            </xsl:attribute>
                                                            <xsl:value-of select="../NetPrice/Amount" />
                                                        </Money>
                                                    </UnitPrice>
                                                    <Description>
                                                        <xsl:attribute name="xml:lang">
                                                            <xsl:value-of select="upper-case($v_lang)" />
                                                        </xsl:attribute>
                                                        <xsl:value-of select="../OrderItemText" />
                                                    </Description>
                                                    <UnitOfMeasure>
                                                        <xsl:value-of select="../RequestedQuantity/@unitCode" />
                                                    </UnitOfMeasure>
                                                    <PriceBasisQuantity>
                                                        <xsl:attribute name="conversionFactor">
                                                            <xsl:value-of select="'1'" />
                                                        </xsl:attribute>
                                                        <xsl:attribute name="quantity">
                                                            <xsl:value-of select="../NetPrice/BaseQuantity" />
                                                        </xsl:attribute>
                                                        <UnitOfMeasure>
                                                            <xsl:value-of select="../NetPrice/BaseQuantity/@unitCode" />
                                                        </UnitOfMeasure>
                                                    </PriceBasisQuantity>
                                                    <Classification domain="NotAvailable" />
                                                </ItemDetail>
                                            </ItemIn>
                                            <!--  CI-2773 4A1 - Comments on Order Confirmation Header and Line Item -->
                                            <xsl:for-each select="../Text">
                                                <xsl:if test="@Type = 'SupplierComments'">
                                                    <Comments>
                                                        <xsl:attribute name="xml:lang">
                                                            <xsl:value-of select="TextElementLanguage"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="type">
                                                            <xsl:value-of select="@Type"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="TextElementText"/>
                                                    </Comments>
                                                </xsl:if>
                                            </xsl:for-each>
                                            <!--  CI-2773 -->
                                        </ConfirmationStatus>
                                    </xsl:for-each>
                                    <xsl:if test="(RequestedQuantity - (sum(ScheduleLine/ConfirmedOrderQuantityByMaterialAvailableCheck)) &gt; 0)">
                                        <ConfirmationStatus>
                                            <xsl:attribute name="type">
                                                <xsl:value-of select="'unknown'" />
                                            </xsl:attribute>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="RequestedQuantity - (sum(ScheduleLine/ConfirmedOrderQuantityByMaterialAvailableCheck))" />
                                            </xsl:attribute>
                                            <UnitOfMeasure>
                                                <xsl:value-of select="RequestedQuantity/@unitCode" />
                                            </UnitOfMeasure>
                                        </ConfirmationStatus>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ConfirmationItem>
                    </xsl:for-each>
                </ConfirmationRequest>
            </Request>
        </cXML>
    </xsl:template>
</xsl:stylesheet>
