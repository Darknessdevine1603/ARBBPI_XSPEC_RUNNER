<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/EDI"
    xmlns:hci="http://sap.com/it/" exclude-result-prefixes="xs n0 hci" version="2.0">
    <!--        <xsl:include href="FORMAT_S4HANA_0000_S4HANA_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_S4HANA_0000.xsl"/>
    <xsl:template match="/n0:DeliveryRequest">
        <cXML>
            <xsl:call-template name="ASNHeader"/>
            <Request>
                <xsl:call-template name="ASNDeployMode"/>
                <ShipNoticeRequest>
                    <ShipNoticeHeader>
                        <xsl:call-template name="ASNShipNoticeHeader">
                            <xsl:with-param name="p_path" select="/n0:DeliveryRequest"/>
                        </xsl:call-template>
                        <xsl:for-each select="Delivery/Party[@PartyType = '01']/Address">
                        <Contact>
                            <xsl:attribute name="role">shipFrom</xsl:attribute>
                            <Name>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="CorrespondenceLanguage"/>
                                </xsl:attribute>
                                <xsl:value-of select="AddressName"/>
                            </Name>
                            <PostalAddress>
                                <Street>
                                    <xsl:value-of select="StreetAddressName"/>
                                </Street>
                                <City>
                                    <xsl:value-of select="CityName"/>
                                </City>
                                <PostalCode>
                                    <xsl:value-of select="PostalCode"/>
                                </PostalCode>
                                <Country>
                                    <xsl:attribute name="isoCountryCode">
                                        <xsl:value-of select="Country"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="Country"/>
                                </Country>
                            </PostalAddress>
                        </Contact>
                        </xsl:for-each>
                        <Contact>
                            <xsl:attribute name="addressID">
                                <xsl:value-of select="Delivery/DeliveryItem[1]/Plant"/>
                            </xsl:attribute>
                            <xsl:for-each select="Delivery/Party[@PartyType = 'WE']/Address">
                            <xsl:attribute name="role">shipTo</xsl:attribute>
                            <Name>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="''"/>
                                </xsl:attribute>
                                <xsl:value-of
                                    select="AddressName"/>
                            </Name>
                            <PostalAddress>
                                <Street>
                                    <xsl:value-of select="StreetAddressName"/>
                                </Street>
                                <City>
                                    <xsl:value-of
                                        select="CityName"
                                    />
                                </City>
                                <PostalCode>
                                    <xsl:value-of
                                        select="PostalCode"
                                    />
                                </PostalCode>
                                <Country>
                                    <xsl:attribute name="isoCountryCode">
                                        <xsl:value-of select="''"/>
                                    </xsl:attribute>
                                    <xsl:value-of
                                        select="Country"/>
                                </Country>
                            </PostalAddress>
                            </xsl:for-each>
                        </Contact>
                        <!-- Begin of CI-2496 OBD attachment -->
                        <xsl:if test="exists(/n0:DeliveryRequest/Delivery/Attachment)">
                            <Comments>
                                <xsl:call-template name="OutboundS4Attachment">
                                    <xsl:with-param name="HeaderAttachment"
                                        select="/n0:DeliveryRequest/Delivery/Attachment"/>
                                </xsl:call-template>
                            </Comments> 
                        </xsl:if>                      
                        <!--Send the Fileanme to Platform, since MIME header from S4 doesn't send content/filename in the header.     Format sent to platform.
cid:cidValue1#filename1|cid:cidvalid2#filename2-->
                        <xsl:variable name="ancXMLAttachments">
                            <xsl:for-each select="/n0:DeliveryRequest/Delivery/Attachment">
                                <xsl:value-of
                                    select="concat(string-join((*[namespace-uri() = 'http://www.w3.org/2004/08/xop/include' and local-name() = 'Include']/@href, @FileName,@MimeType), ';'), '#')"/>
                            </xsl:for-each>
                        </xsl:variable> 
                        
                        <xsl:if test="$ancXMLAttachments">
                            <!-- This is to make XSPEC assume that $ancXMLAttachments has some value -->
                        </xsl:if>          
                        <!--<an><xsl:value-of select="$ancXMLAttachments"/></an>-->
                        <!-- End of CI-2496 OBD attachment -->
                    </ShipNoticeHeader>
                    <ShipNoticePortion>
                        <OrderReference>
                            <xsl:attribute name="orderID">
                                <xsl:value-of
                                    select="Delivery/DeliveryItem[1]/UnderlyingPurchaseOrder[1]"/>
                            </xsl:attribute>
                            <DocumentReference>
                                <xsl:attribute name="payloadID">
                                    <xsl:value-of select="''"/>
                                </xsl:attribute>
                            </DocumentReference>
                        </OrderReference>
                        <xsl:for-each select="Delivery/DeliveryItem">
                            <ShipNoticeItem>
                                <xsl:attribute name="shipNoticeLineNumber">
                                    <xsl:value-of select="replace(DeliveryDocumentItem, '^0+', '')"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="lineNumber">
                                    <xsl:value-of
                                        select="replace(UnderlyingPurchaseOrderItem, '^0+', '')"/>
                                </xsl:attribute>
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="ActualDeliveryQuantity"/>
                                </xsl:attribute>
                                <ItemID>
                                    <xsl:if test="exists(Material/SupplierProductID)">
                                        <SupplierPartID>
                                            <xsl:value-of select="Material/SupplierProductID"/>
                                        </SupplierPartID>
                                    </xsl:if>
                                    <xsl:if test="exists(Material/BuyerProductID)">
                                        <BuyerPartID>
                                            <xsl:value-of select="Material/BuyerProductID"/>
                                        </BuyerPartID>
                                    </xsl:if>
                                </ItemID>
                                <ShipNoticeItemDetail>
                                    <!-- <UnitPrice>                                    <Money>                                        <xsl:attribute name="currency">                                            <xsl:value-of select="''"/>                                        </xsl:attribute>                                        <xsl:value-of select="''"/>                                    </Money>                                </UnitPrice>-->
                                    <xsl:call-template name="ASNItemDetail">
                                        <xsl:with-param name="p_path"
                                            select="/n0:DeliveryRequest/Delivery/DeliveryItem"/>
                                    </xsl:call-template>
                                </ShipNoticeItemDetail>
                                <UnitOfMeasure>
                                    <xsl:value-of select="ActualDeliveredQtyInBaseUnit/@unitCode"/>
                                </UnitOfMeasure>
                                <!-- CI-2345 Batch info mapping Begin -->
                                <xsl:if test="exists(Batch)">
                                    <Batch>
                                        <xsl:if
                                            test="string-length(normalize-space(Batch/ManufactureDate)) > 0">
                                            <xsl:attribute name="productionDate">
                                                <xsl:value-of select="Batch/ManufactureDate"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(Batch/ShelfLifeExpirationDate)) > 0">
                                            <xsl:attribute name="expirationDate">
                                                <xsl:value-of select="Batch/ShelfLifeExpirationDate"
                                                />
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(Batch/Batch)) > 0">
                                            <SupplierBatchID>
                                                <xsl:value-of select="Batch/Batch"/>
                                            </SupplierBatchID>
                                        </xsl:if>
                                    </Batch>
                                </xsl:if>
                                <!-- CI-2345 Batch info mapping End -->
                            </ShipNoticeItem>
                        </xsl:for-each>
                    </ShipNoticePortion>
                </ShipNoticeRequest>
            </Request>
        </cXML>
    </xsl:template>
</xsl:stylesheet>
