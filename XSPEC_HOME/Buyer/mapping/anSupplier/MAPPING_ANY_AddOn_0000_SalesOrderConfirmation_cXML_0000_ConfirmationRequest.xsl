<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:n0="http://sap.com/xi/ARBCIS" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anSenderID"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anAllDetailOCFlag"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:variable name="supplierANID">
        <xsl:value-of select="/n0:ConfirmationRequest/MessageHeader/AribaNetworkID/SupplierAribaNetworkID"/>
    </xsl:variable>
    <xsl:variable name="buyerANID">
        <xsl:value-of select="/n0:ConfirmationRequest/MessageHeader/AribaNetworkID/BuyerAribaNetworkID"/>
    </xsl:variable>
    <xsl:variable name="mapAllDetail">
        <xsl:if test="string-length($anAllDetailOCFlag) > 0">
            <xsl:value-of select="'X'"/>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="v_currDT">
        <xsl:value-of select="current-dateTime()"/>
    </xsl:variable>
    <xsl:template match="n0:ConfirmationRequest">
        <Combined>
            <Payload>           
                <cXML>
                    <xsl:attribute name="payloadID">
                        <xsl:value-of select="MessageHeader/ID"/>
                    </xsl:attribute>
                    <xsl:attribute name="timestamp">
                        <xsl:value-of select="MessageHeader/CreationDateTime"/>
                    </xsl:attribute>
                    <Header>
                        <From>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$supplierANID"/>
                                </Identity>
                            </Credential>
                        </From>
                        <To>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$buyerANID"/>
                                </Identity>
                            </Credential>
                        </To>
                        <Sender>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
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
                        <xsl:attribute name="deploymentMode">
                            <xsl:choose>
                                <xsl:when test="MessageHeader/TestDataIndicator = 'true'">
                                    <xsl:value-of select="'test'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'production'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <ConfirmationRequest>
                            <ConfirmationHeader>
                                <xsl:attribute name="version">
                                    <xsl:value-of select="ConfirmationRequest/ConfirmationHeader/version"/>
                                </xsl:attribute>
                                <xsl:attribute name="confirmID">
                                    <xsl:value-of select="ConfirmationRequest/ConfirmationHeader/ConfirmID"/>
                                </xsl:attribute>
                                <xsl:attribute name="operation">
                                    <xsl:choose>
                                        <xsl:when test="ConfirmationRequest/ConfirmationHeader/Operation = '01'">
                                            <xsl:value-of select="'new'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'update'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="type">
                                    <xsl:choose>
                                        <xsl:when test="$mapAllDetail = 'X'">
                                            <xsl:value-of select="'allDetail'"/>
                                        </xsl:when>
                                        <xsl:when test="ConfirmationRequest/ConfirmationHeader/Type = 'reject'">
                                            <xsl:value-of select="ConfirmationRequest/ConfirmationHeader/Type"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'detail'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="noticeDate">
                                    <xsl:call-template name="Convert_UTC_cXML_Supplier">
                                        <xsl:with-param name="p_utcTime"
                                            select="ConfirmationRequest/ConfirmationHeader/NoticeDate"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:if
                                    test="string-length(ConfirmationRequest/ConfirmationHeader/DocumentReference) > 0">
                                    <DocumentReference>
                                        <xsl:attribute name="payloadID">
                                            <xsl:value-of
                                                select="ConfirmationRequest/ConfirmationHeader/DocumentReference"/>
                                        </xsl:attribute>
                                    </DocumentReference>
                                </xsl:if>
                                <xsl:for-each select="ConfirmationRequest/ConfirmationHeader/Comments">
                                    <xsl:for-each select="Comment">
                                        <Comments>
                                            <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="@languageCode"/>
                                            </xsl:attribute>
                                            <xsl:if test="string-length(../cXMLElementType) > 0">
                                                <xsl:attribute name="type">
                                                    <xsl:value-of select="../cXMLElementType"/>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="."/>
                                            <xsl:call-template name="addContenId">
                                                <xsl:with-param name="eachAtt"
                                                    select="../../../../Attachment/Item"/>
                                            </xsl:call-template>
                                        </Comments>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </ConfirmationHeader>
                            <OrderReference>
                                <xsl:attribute name="orderID">
                                    <xsl:value-of
                                        select="ConfirmationRequest/ConfirmationHeader/OrderReference/@orderID"/>
                                </xsl:attribute>
                                <DocumentReference>
                                    <xsl:attribute name="payloadID">
                                        <xsl:value-of
                                            select="ConfirmationRequest/ConfirmationHeader/OrderReference/@payloadID"/>
                                    </xsl:attribute>
                                </DocumentReference>
                            </OrderReference>
                            <xsl:if
                                test="
                                ((ConfirmationRequest/ConfirmationHeader/Type!= 'reject')
                                    or (string-length($mapAllDetail) > 0)
                                    )">
                                <!--From Add-On for item rejection , we expect one schedule line only to be populated 
                                            with rejection reason and total quantity from item mentioned on the schedule line-->
                                <xsl:for-each select="ConfirmationRequest/Item">
                                    <ConfirmationItem>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="Quantity"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="lineNumber">
                                            <xsl:value-of select="lineNumber"/>
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="Quantity/@unitCode"/>
                                        </UnitOfMeasure>
                                        <xsl:for-each select="ScheduleLine[quantity != '0.0']">
                                            <ConfirmationStatus>
                                                <xsl:attribute name="quantity">
                                                    <xsl:value-of select="quantity"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                    <xsl:when test="type != 'detail'">
                                                        <xsl:attribute name="type">
                                                            <xsl:value-of select="type"/>
                                                        </xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:when
                                                        test="
                                                            type = 'detail'
                                                            and $mapAllDetail = 'X'">
                                                        <xsl:attribute name="type">
                                                            <xsl:value-of select="'allDetail'"/>
                                                        </xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:attribute name="type">
                                                            <xsl:value-of select="'detail'"/>
                                                        </xsl:attribute>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:if test="string-length(deliveryDate) > 0">
                                                    <xsl:attribute name="deliveryDate">
                                                        <xsl:call-template name="Convert_UTC_cXML_Supplier">
                                                            <xsl:with-param name="p_utcTime" select="deliveryDate"/>
                                                        </xsl:call-template>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <xsl:if test="string-length(shipmentDate) > 0">
                                                    <xsl:attribute name="shipmentDate">
                                                        <xsl:call-template name="Convert_UTC_cXML_Supplier">
                                                            <xsl:with-param name="p_utcTime" select="shipmentDate"/>
                                                        </xsl:call-template>
                                                    </xsl:attribute>
                                                </xsl:if>
                                                <UnitOfMeasure>
                                                    <xsl:value-of select="quantity/@unitCode"/>
                                                </UnitOfMeasure>
                                                <xsl:if
                                                    test="
                                                        $mapAllDetail = 'X'
                                                        or (type != 'accept'
                                                        and type != 'reject')">
                                                    <ItemIn>
                                                        <xsl:attribute name="lineNumber">
                                                            <xsl:value-of select="../lineNumber"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="quantity">
                                                            <xsl:value-of select="quantity"/>
                                                        </xsl:attribute>
                                                        <ItemID>
                                                            <SupplierPartID>
                                                            <xsl:value-of select="../Product/SellerID"/>
                                                            </SupplierPartID>
                                                            <!-- IG-34318 -->
                                                            <!-- Removing Hard coded value for BuyerPartId -->
                                                            <BuyerPartID>
                                                                <xsl:if test="string-length(../Product/BuyerID) > 0">
                                                                    <xsl:value-of select="../Product/BuyerID"/>
                                                                </xsl:if>
                                                            </BuyerPartID>
                                                            <!-- IG-34318 -->
                                                        </ItemID>
                                                        <ItemDetail>
                                                            <UnitPrice>
                                                            <Money>
                                                            <xsl:attribute name="currency">
                                                            <xsl:value-of select="unitPrice/@currencyCode"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="unitPrice"/>
                                                            </Money>
                                                            </UnitPrice>
                                                            <Description>
                                                            <xsl:attribute name="xml:lang">
                                                            <xsl:value-of select="../Description/@languageCode"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="../Description"/>
                                                            </Description>
                                                            <UnitOfMeasure>
                                                            <xsl:value-of select="quantity/@unitCode"/>
                                                            </UnitOfMeasure>
                                                            <PriceBasisQuantity>
                                                            <xsl:attribute name="conversionFactor">
                                                            <xsl:value-of
                                                            select="../PriceBasisQuantity/conversionFactor"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="quantity">
                                                            <xsl:value-of select="../PriceBasisQuantity/BaseQuantity"/>
                                                            </xsl:attribute>
                                                            <UnitOfMeasure>
                                                            <xsl:value-of
                                                            select="../PriceBasisQuantity/BaseQuantity/@unitCode"/>
                                                            </UnitOfMeasure>
                                                            </PriceBasisQuantity>
                                                            <Classification domain="NotAvailable">
                                                                <xsl:value-of select="'001'"/>
                                                            </Classification>
                                                        </ItemDetail>
                                                    </ItemIn>
                                                </xsl:if>
                                                <xsl:variable name="v_elementType">
                                                    <xsl:value-of select="../cXMLElementType"/>
                                                </xsl:variable>
                                                <xsl:variable name="v_comment">
                                                    <xsl:value-of select="../Comments/Comment"/>
                                                </xsl:variable>
                                                <xsl:variable name="v_langCode">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(../Comments[1]/Comment[1]/@languageCode) > 0">
                                                            <xsl:value-of select="../Comments[1]/Comment[1]/@languageCode"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'en'"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>                                                    
                                                </xsl:variable>
                                                <xsl:variable name="v_RejReasonComment">
                                                <xsl:if test="exists(../RejCode) and string-length(../RejCode) > 0">                                                    
                                                    <xsl:choose>                                                        
                                                        <xsl:when test="string-length(../RejReason) > 0">
                                                            <xsl:if
                                                            test="exists(../RejReason) and string-length(../RejReason) > 0">                                                              
                                                                    <xsl:value-of select="../RejReason"/>                                                                
                                                            </xsl:if>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'Rejected'"/>  
                                                        </xsl:otherwise>
                                                    </xsl:choose>                                                    
                                                </xsl:if>
                                                </xsl:variable>
                                                <xsl:if test="string-length($v_comment) > 0
                                                            or string-length($v_RejReasonComment) > 0">
                                                <Comments>
                                                    <xsl:attribute name="xml:lang" select="$v_langCode"/>
                                                    <xsl:if test="string-length($v_elementType) > 0">
                                                        <xsl:attribute name="type" select="$v_elementType"/>
                                                    </xsl:if>                                                    
                                                    <xsl:choose>
                                                        <xsl:when test="string-length($v_RejReasonComment) > 0">
                                                            <xsl:value-of select="normalize-space(concat('Rejection Reason : ',$v_RejReasonComment,'. ', $v_comment))"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:variable name="v_comment">
                                                                <xsl:value-of select="../Comments/Comment/text()"/>
                                                            </xsl:variable>
                                                            <xsl:value-of select="concat(@type,':',$v_comment)"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>                                                    
                                                </Comments>
                                                </xsl:if>
                                            </ConfirmationStatus>
                                        </xsl:for-each>
                                    </ConfirmationItem>
                                </xsl:for-each>
                            </xsl:if>
                        </ConfirmationRequest>
                    </Request>
                </cXML>
                </Payload>
        <xsl:if test="Attachment/Item != ''">
            <xsl:call-template name="OutBoundAttach"/>
        </xsl:if>
        </Combined>
    </xsl:template>
</xsl:stylesheet>
