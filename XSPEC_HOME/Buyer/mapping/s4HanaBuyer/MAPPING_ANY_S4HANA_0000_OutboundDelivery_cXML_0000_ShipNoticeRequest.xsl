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
                            <xsl:with-param name="p_path" select="."/>
                        </xsl:call-template>
                        <xsl:attribute name="shipmentType">
                            <xsl:value-of select="'actual'"/>
                        </xsl:attribute>
                        <ServiceLevel>
                            <xsl:attribute name="xml:lang"
                                select="Delivery/Party[@PartyType = 'LF']/Address/CorrespondenceLanguage"
                            />
                        </ServiceLevel>
                        <!-- LF = shipFrom                    -->
                        <Contact>
                            <xsl:attribute name="role">shipFrom</xsl:attribute>
                            <xsl:variable name="v_empty" select="''"/>
                            <Name>
                                <xsl:attribute name="xml:lang">
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(Delivery/ShippingPointAddress/CorrespondenceLanguage))">
                                            <xsl:value-of select="Delivery/ShippingPointAddress/CorrespondenceLanguage"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$v_empty"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="Delivery/ShippingPointAddress/AddressAdditionalName"/>
                            </Name>
                            <xsl:if test="Delivery/ShippingPointAddress">
                                <PostalAddress>
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="Delivery/ShippingPointAddress/AddressName"/>
                                    </xsl:attribute>
                                    <Street>
                                        <xsl:choose>
                                            <xsl:when
                                                test="string-length(normalize-space(Delivery/ShippingPointAddress/StreetAddressName)) > 0">
                                                <xsl:value-of select="Delivery/ShippingPointAddress/StreetAddressName"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when test="Delivery/ShippingPointAddress/Country = 'DE'">
                                                        <xsl:value-of
                                                            select="concat(Delivery/ShippingPointAddress/StreetName, ' ', Delivery/ShippingPointAddress/HouseNumber)"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of
                                                            select="concat(Delivery/ShippingPointAddress/HouseNumber, ' ', Delivery/ShippingPointAddress/StreetName)"
                                                        />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </Street>
                                    <City>
                                        <xsl:value-of select="Delivery/ShippingPointAddress/CityName"/>
                                    </City>
                                    <xsl:if test="string-length(normalize-space(Delivery/ShippingPointAddress/Region)) > 0">
                                        <State>
                                            <xsl:value-of select="Delivery/ShippingPointAddress/Region"/>
                                        </State>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(Delivery/ShippingPointAddress/PostalCode)) > 0">
                                        <PostalCode>
                                            <xsl:value-of select="Delivery/ShippingPointAddress/PostalCode"/>
                                        </PostalCode>
                                    </xsl:if>
                                    <Country>
                                        <xsl:attribute name="isoCountryCode">
                                            <xsl:value-of select="Delivery/ShippingPointAddress/Country"/>
                                        </xsl:attribute>
                                    </Country>
                                </PostalAddress>
                            </xsl:if>
                        </Contact>
                        <!-- WE = shipTo                    -->
                        <xsl:if test="Delivery/Party[@PartyType = 'WE']">
                            <Contact>
                                <xsl:attribute name="role">shipTo</xsl:attribute>
                                <xsl:attribute name="addressID">
                                    <xsl:value-of
                                        select="Delivery/Party[@PartyType = 'WE']/BuyerPartyID"/>
                                </xsl:attribute>
                                <xsl:call-template name="FillContactAddress">
                                    <xsl:with-param name="p_path"
                                        select="Delivery/Party[@PartyType = 'WE']"/>
                                </xsl:call-template>
                            </Contact>
                        </xsl:if>
                        <xsl:for-each select="Delivery/Text">
                        <Comments>
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="TextElementLanguage"/>
                            </xsl:attribute>
                            <xsl:value-of select="TextElementText"/>
                        </Comments>
                        </xsl:for-each>
                        <TermsOfDelivery>
                            <TermsOfDeliveryCode>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'TransportCondition'"/>
                                </xsl:attribute>
                            </TermsOfDeliveryCode>
                            <ShippingPaymentMethod>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="'other'"/>
                                </xsl:attribute>
                                <xsl:value-of select="'_'"/>
                            </ShippingPaymentMethod>
                        </TermsOfDelivery>
                    </ShipNoticeHeader>
                    <ShipControl>
                        <CarrierIdentifier>
                            <xsl:attribute name="domain">companyName</xsl:attribute>
                            <xsl:value-of select="Delivery/Party[@PartyType = 'SP']//BuyerPartyID"/>
                        </CarrierIdentifier>
                        <ShipmentIdentifier>
                            <xsl:value-of select="Delivery/BillOfLading"/>
                        </ShipmentIdentifier>
                    </ShipControl>
                    <ShipNoticePortion>
                        <OrderReference>
                            <xsl:attribute name="orderID">
                                <xsl:value-of
                                    select="Delivery/DeliveryItem[1]/ReferenceSDDocument[1]"/>
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
                                        select="replace(ReferenceSDDocumentItem, '^0+', '')"/>
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
                                    <IdReference>
                                        <xsl:attribute name="domain">
                                            <xsl:value-of select="'EAN13'"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="''"/>
                                        </xsl:attribute>
                                    </IdReference>
                                </ItemID>
                                <ShipNoticeItemDetail>
                                    <xsl:call-template name="ASNItemDetail">
                                        <xsl:with-param name="p_path"
                                            select="/n0:DeliveryRequest/Delivery/DeliveryItem"/>
                                    </xsl:call-template>
                                    <Dimension>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="ItemGrossWeight"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'grossWeight'"/>
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="ItemGrossWeight/@unitCode"/>
                                        </UnitOfMeasure>
                                    </Dimension>
                                    <Dimension>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="ItemNetWeight"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'weight'"/>
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="ItemNetWeight/@unitCode"/>
                                        </UnitOfMeasure>
                                    </Dimension>
                                    <Dimension>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="ItemVolume"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'volume'"/>
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="ItemVolume/@unitCode"/>
                                        </UnitOfMeasure>
                                    </Dimension>
                                    <ItemDetailIndustry>
                                        <ItemDetailRetail>
                                            <EANID>
                                                <xsl:value-of
                                                  select="Material/GlobalTradeItemNumber"/>
                                            </EANID>
                                        </ItemDetailRetail>
                                    </ItemDetailIndustry>
                                </ShipNoticeItemDetail>
                                <UnitOfMeasure>
                                    <xsl:value-of select="ActualDeliveredQtyInBaseUnit/@unitCode"/>
                                </UnitOfMeasure>
                                <xsl:if test="string-length(normalize-space(Batch))>0">
                                <Batch>
                                    <xsl:if test="string-length(normalize-space(Batch/ManufactureDate))>0">
                                        <xsl:attribute name="productionDate">
                                            <xsl:value-of select="Batch/ManufactureDate"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(Batch/ShelfLifeExpirationDate))>0">
                                        <xsl:attribute name="expirationDate">
                                            <xsl:value-of select="Batch/ShelfLifeExpirationDate"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(Batch/Batch))>0">
                                        <BuyerBatchID>
                                            <xsl:value-of select="Batch/Batch"/>
                                        </BuyerBatchID>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(Batch/BatchBySupplier))>0">
                                        <SupplierBatchID>
                                            <xsl:value-of select="Batch/BatchBySupplier"/>
                                        </SupplierBatchID>
                                    </xsl:if>
                                </Batch>
                                </xsl:if>
                                <ShipNoticeItemIndustry>
                                    <ShipNoticeItemRetail>
                                        <BestBeforeDate>
                                            <xsl:attribute name="date">
                                                <xsl:value-of select="Batch/ManufactureDate"/>
                                            </xsl:attribute>
                                        </BestBeforeDate>
                                        <ExpiryDate>
                                            <xsl:attribute name="date">
                                                <xsl:value-of select="Batch/ExpiryDate"/>
                                            </xsl:attribute>
                                        </ExpiryDate>
                                    </ShipNoticeItemRetail>
                                </ShipNoticeItemIndustry>
                                <xsl:for-each select="Text">
                                    <Comments>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="TextElementLanguage"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="TextElementText"/>
                                    </Comments>
                                </xsl:for-each>
                            </ShipNoticeItem>
                        </xsl:for-each>
                    </ShipNoticePortion>
                </ShipNoticeRequest>
            </Request>
        </cXML>
    </xsl:template>
</xsl:stylesheet>
