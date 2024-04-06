<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- parameter -->
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSourceDocumentType"/>
<!--                <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--PD path    -->
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
            <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--Get the Language code-->
    <xsl:variable name="v_lang">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_GRBasedIV">
        <xsl:value-of
            select="$v_pd/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/GRBasedIV"
        />
    </xsl:variable>
    <!-- Main template -->
    <xsl:template match="Combined">
        <n0:ReplenishmentOrderRequest>
            <xsl:variable name="v_erpdate">
                <xsl:call-template name="ERPDateTime">
                    <xsl:with-param name="p_date"
                        select="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/@noticeDate"/>
                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                </xsl:call-template>
            </xsl:variable>
            <MessageHeader>
                <ReferenceID>
                    <xsl:value-of
                        select="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/@salesOrderID"
                    />
                </ReferenceID>
                <CreationDateTime>
                    <xsl:value-of select="$v_erpdate"/>
                </CreationDateTime>
                <AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of
                        select="Payload/cXML/Header/To/Credential[@domain = 'NetworkID']/Identity"/>
                </AribaNetworkID>
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="$v_sysid"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <PurchaseOrder>
                <xsl:attribute name="actionCode">
                    <xsl:choose>
                        <xsl:when
                            test="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/@operation = 'new'">
                            <xsl:value-of select="'1'"/>
                        </xsl:when>
                        <xsl:when
                            test="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/@operation = 'cancel'">
                            <xsl:value-of select="'3'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="itemListCompleteTransmissionIndicator">
                    <xsl:value-of select="'false'"/>
                </xsl:attribute>
                <VendorParty>
                    <VendorID>
                        <xsl:value-of
                            select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                        />
                    </VendorID>
                </VendorParty>
                <xsl:for-each select="Payload/cXML/Request/SalesOrderRequest/ItemIn">
                    <Item>
                        <xsl:attribute name="actionCode">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <xsl:attribute name="ScheduleLineListCompleteTransmissionIndicator">
                            <xsl:value-of select="'false'"/>
                        </xsl:attribute>
                        <ID>
                            <xsl:value-of select="position()"/>
                        </ID>
                        <TypeCode>
                            <xsl:value-of select="@itemType"/>
                        </TypeCode>
                        <DeliveryBasedInvoiceVerificationIndicator>
                            <xsl:value-of select="$v_GRBasedIV"/>
                        </DeliveryBasedInvoiceVerificationIndicator>
                        <!--            UOM variable-->
                        <xsl:variable name="v_uom">
                            <xsl:if test="string-length(ItemDetail/UnitOfMeasure) > 0">
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput"
                                        select="ItemDetail/UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
                                    <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <Quantity>
                            <xsl:attribute name="unitCode">
                                <xsl:value-of select="$v_uom"/>
                            </xsl:attribute>
                            <xsl:value-of select="@quantity"/>
                        </Quantity>
                        <xsl:if test="string-length(ItemID/BuyerPartID) > 0">
                            <Product>
                                <BuyerID>
                                    <xsl:value-of select="ItemID/BuyerPartID"/>
                                </BuyerID>
                            </Product>
                        </xsl:if>
                        <xsl:if test="string-length(ItemDetail/UnitPrice/Money) > 0">
                            <Price>
                                <NetUnitPrice>
                                    <Amount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of
                                                select="ItemDetail/UnitPrice/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="ItemDetail/UnitPrice/Money"/>
                                    </Amount>
                                    <BaseQuantity>
                                        <xsl:value-of select="'0'"/>
                                    </BaseQuantity>
                                </NetUnitPrice>
                            </Price>
                        </xsl:if>
                        <xsl:if test="Contact/@role = 'locationTo'">
                            <ReceivingPlantID>
                                <xsl:value-of
                                    select="Contact/IdReference[@domain = 'buyerLocationID']/@identifier"
                                />
                            </ReceivingPlantID>
                        </xsl:if>
                        <DeliveryDate>
                            <xsl:attribute name="timeZoneCode"> </xsl:attribute>
                            <xsl:variable name="v_deliverydate">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date"
                                        select="DateInfo[@type = 'requestedDeliveryDate']/@date"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="$v_deliverydate"/>
                        </DeliveryDate>
                        <Description>
                            <xsl:attribute name="languageCode">
                                <xsl:value-of select="$v_lang"/>
                            </xsl:attribute>
                            <xsl:value-of select="ItemDetail/Description"/>
                        </Description>
                        <xsl:for-each select="DateInfo[@type = 'requestedDeliveryDate']/@date">
                            <ScheduleLine>
                                <ID>
                                    <xsl:value-of select="position()"/>
                                </ID>
                                <DeliveryPeriod>
                                    <StartDateTime>
                                        <xsl:attribute name="timeZoneCode"> </xsl:attribute>
                                        <xsl:variable name="v_deliverydate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date" select="."/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:value-of select="$v_deliverydate"/>
                                    </StartDateTime>
                                </DeliveryPeriod>
                                <!--            UOM variable-->
                                <xsl:variable name="v_uom1">
                                    <xsl:if
                                        test="string-length(../../ScheduleLine/UnitOfMeasure) > 0">
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput"
                                                select="../../ScheduleLine/UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:variable>
                                <xsl:if test="string-length(../../ScheduleLine/@quantity) > 0">
                                    <Quantity>
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of select="$v_uom1"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="../../ScheduleLine/@quantity"/>
                                    </Quantity>
                                </xsl:if>
                            </ScheduleLine>
                        </xsl:for-each>
                        <xsl:if test="Comments != ''">
                            <Comments>
                                <xsl:variable name="v_commentsLang">
                                    <xsl:choose>
                                        <xsl:when test="Comments/@xml:lang != ''">
                                            <xsl:value-of select="Comments/@xml:lang"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$v_lang"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="v_item_id">
                                    <xsl:value-of select="position()"/>
                                </xsl:variable>
                                <xsl:call-template name="CommentsFillProxyIn">
                                    <xsl:with-param name="p_comments" select="Comments"/>
                                    <xsl:with-param name="p_lang" select="$v_commentsLang"/>
                                    <xsl:with-param name="p_itemNumber" select="$v_item_id"/>
                                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                </xsl:call-template>
                            </Comments>
                        </xsl:if>
                    </Item>
                </xsl:for-each>
            </PurchaseOrder>
            <!--        Attachment Handling-->
            <xsl:call-template name="InboundAttachs">
                <xsl:with-param name="lineReference"
                    select="
                        Payload/cXML/Request/SalesOrderRequest/ItemIn/@lineNumber
                        | Payload/cXML/Request/SalesOrderRequest/ItemIn/Comments/Attachment/URL"
                />
            </xsl:call-template>
            <!--       Comments Handling-->
            <xsl:if test="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/Comments">
                <HeaderComments>
                    <xsl:variable name="v_commentsLang">
                        <xsl:choose>
                            <xsl:when
                                test="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/Comments/@xml:lang != ''">
                                <xsl:value-of
                                    select="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/Comments/@xml:lang"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$v_lang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="CommentsFillProxyIn">
                        <xsl:with-param name="p_comments"
                            select="Payload/cXML/Request/SalesOrderRequest/SalesOrderHeader/Comments"/>
                        <xsl:with-param name="p_lang" select="$v_commentsLang"/>
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </HeaderComments>
            </xsl:if>
        </n0:ReplenishmentOrderRequest>
    </xsl:template>
</xsl:stylesheet>
