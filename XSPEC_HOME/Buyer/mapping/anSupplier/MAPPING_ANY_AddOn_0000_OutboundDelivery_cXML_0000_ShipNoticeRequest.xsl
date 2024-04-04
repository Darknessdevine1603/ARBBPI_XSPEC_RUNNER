<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIS"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anProviderANID"/>
    <xsl:variable name="supplierANID">
        <xsl:value-of
            select="/n0:DespatchedDeliveryNotification/MessageHeader/AribaNetworkID/SupplierAribaNetworkID"
        />
    </xsl:variable>
    <xsl:variable name="buyerANID">
        <xsl:value-of
            select="/n0:DespatchedDeliveryNotification/MessageHeader/AribaNetworkID/BuyerAribaNetworkID"
        />
    </xsl:variable>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
        <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="n0:DespatchedDeliveryNotification">
        <xsl:variable name="v_curDate">
            <xsl:value-of select="current-dateTime()"/>
        </xsl:variable>
    <Combined>
      <Payload> 
        <cXML>
            <xsl:attribute name="timestamp">
                <xsl:value-of select="MessageHeader/CreationDateTime"/>
            </xsl:attribute>
            <xsl:attribute name="payloadID">
                <xsl:value-of select="MessageHeader/ID"/>
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
                        <xsl:when test="($anEnvName = 'PROD')">
                            <xsl:value-of select="'production'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'test'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <ShipNoticeRequest>
                    <ShipNoticeHeader>
                        <xsl:attribute name="deliveryDate">
                            <xsl:call-template name="Convert_UTC_cXML_Supplier">
                                <xsl:with-param name="p_utcTime"
                                    select="OutboundDelivery/ArrivalDateTime"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="shipmentDate">
                            <xsl:call-template name="Convert_UTC_cXML_Supplier">
                                <xsl:with-param name="p_utcTime"
                                    select="OutboundDelivery/IssueDateTime"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="noticeDate">
                            <xsl:call-template name="Convert_UTC_cXML_Supplier">
                                <xsl:with-param name="p_utcTime"
                                    select="OutboundDelivery/CreationDateTime"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="operation">
                            <xsl:value-of select="'new'"/>
                        </xsl:attribute>
                        <xsl:attribute name="shipmentType">
                            <xsl:value-of select="'actual'"/>
                        </xsl:attribute>
                        <xsl:attribute name="shipmentID">
                            <xsl:value-of select="OutboundDelivery/ID"/>
                        </xsl:attribute>
                        <ServiceLevel>
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="''"/>
                            </xsl:attribute>
                            <xsl:value-of select="OutboundDelivery/DeliveryPriority"/>
                        </ServiceLevel>
                        <Contact>
                            <xsl:attribute name="role">
                                <xsl:value-of select="'shipFrom'"/>
                            </xsl:attribute>
                            <xsl:call-template name="PartnerAddr">
                                <xsl:with-param name="v_path"
                                    select="OutboundDelivery/ShipFromLocation/Address"/>
                            </xsl:call-template>
                        </Contact>
                        <Contact>
                            <xsl:attribute name="role">
                                <xsl:value-of select="'shipTo'"/>
                            </xsl:attribute>
                            <xsl:call-template name="PartnerAddr">
                                <xsl:with-param name="v_path"
                                    select="OutboundDelivery/ShipToLocation/Address"/>
                            </xsl:call-template>
                        </Contact>
                        <Contact>
                            <xsl:attribute name="role">
                                <xsl:value-of select="'soldTo'"/>
                            </xsl:attribute>
                            <xsl:call-template name="PartnerAddr">
                                <xsl:with-param name="v_path"
                                    select="OutboundDelivery/BuyerParty/Address"/>
                            </xsl:call-template>
                        </Contact>
                        <xsl:for-each select="OutboundDelivery/Comments">
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
                                </Comments>
                            </xsl:for-each>
                        </xsl:for-each>
                    </ShipNoticeHeader>
                    <ShipControl>
                        <CarrierIdentifier>
                            <xsl:attribute name="domain">
                                <xsl:value-of select="'companyName'"/>
                            </xsl:attribute>
                            <xsl:value-of
                                select="OutboundDelivery/ProductRecipientParty/Address/OrganisationFormattedName"
                            />
                        </CarrierIdentifier>
                        <ShipmentIdentifier>
                            <xsl:value-of
                                select="OutboundDelivery/ProductRecipientParty/ProductRecipientID"/>
                        </ShipmentIdentifier>
                    </ShipControl>
                    <ShipNoticePortion>
                        <OrderReference>
                            <xsl:attribute name="orderID">
                                <xsl:value-of
                                    select="OutboundDelivery/Item[1]/PurchaseOrderReference/ID"/>
                            </xsl:attribute>
                            <DocumentReference>
                                <xsl:attribute name="payloadID">
                                    <xsl:value-of
                                        select="replace(OutboundDelivery/Item[1]/PurchaseOrderReference/payloadID, ' ', '')"
                                    />
                                </xsl:attribute>
                            </DocumentReference>
                        </OrderReference>
                        <xsl:for-each select="OutboundDelivery/Item">
                            <ShipNoticeItem>
                                <xsl:attribute name="shipNoticeLineNumber">
                                    <xsl:value-of select="replace(ID, '^0+', '')"/>
                                </xsl:attribute>
                                <xsl:attribute name="lineNumber">
                                    <xsl:value-of
                                        select="replace(PurchaseOrderReference/ItemID, '^0+', '')"/>
                                </xsl:attribute>
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="Quantity"/>
                                </xsl:attribute>
                                <ItemID>
                                    <SupplierPartID>
                                        <xsl:value-of select="Product/BuyerID"/>
                                    </SupplierPartID>
                                    <BuyerPartID>
                                        <xsl:value-of select="Product/InternalID"/>
                                    </BuyerPartID>
                                    <IdReference>
                                        <xsl:attribute name="domain">
                                            <xsl:value-of select="'EAN-13'"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="Product/StandardID"/>
                                        </xsl:attribute>
                                    </IdReference>
                                </ItemID>
                                <ShipNoticeItemDetail>
                                    <Description>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="Product/Note/@languageCode"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="Product/Note"/>
                                    </Description>
                                    <Dimension>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="GrossWeightMeasure"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'grossWeight'"/>
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="GrossWeightMeasure/@unitCode"/>
                                        </UnitOfMeasure>
                                    </Dimension>
                                    <Dimension>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="NetWeightMeasure"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'weight'"/>
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="NetWeightMeasure/@unitCode"/>
                                        </UnitOfMeasure>
                                    </Dimension>
                                    <Dimension>
                                        <xsl:attribute name="quantity">
                                            <xsl:value-of select="VolumeMeasure"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="'volume'"/>
                                        </xsl:attribute>
                                        <UnitOfMeasure>
                                            <xsl:value-of select="VolumeMeasure/@unitCode"/>
                                        </UnitOfMeasure>
                                    </Dimension>
                                </ShipNoticeItemDetail>
                                <UnitOfMeasure>
                                    <xsl:value-of select="Quantity/@unitCode"/>
                                </UnitOfMeasure>
                                <Batch>
                                    <SupplierBatchID>
                                        <xsl:value-of select="Batch/InternalID"/>
                                    </SupplierBatchID>
                                </Batch>
                                <ShipNoticeItemIndustry>
                                    <ShipNoticeItemRetail>
                                        <BestBeforeDate>
                                            <xsl:attribute name="date">
                                                <xsl:value-of select="Batch/BestBeforeDate"/>
                                            </xsl:attribute>
                                        </BestBeforeDate>
                                        <ExpiryDate>
                                            <xsl:attribute name="date">
                                                <xsl:value-of select="Batch/BestBeforeDate"/>
                                            </xsl:attribute>
                                        </ExpiryDate>
                                    </ShipNoticeItemRetail>
                                </ShipNoticeItemIndustry>
                                <xsl:for-each select="Comments">
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
                                        </Comments>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </ShipNoticeItem>
                        </xsl:for-each>
                    </ShipNoticePortion>
                </ShipNoticeRequest>
            </Request>
        </cXML>
      </Payload>
    </Combined>
    </xsl:template>
		<!-- Map PartnerAddresses that contain set of tags such as Name , PostalAddress , Email,Phone  -->
		<!-- Make sure we call this template inside the <Contact> tag for building cXML. -->
		<!-- input  v_path	       	: Pass the xPath that holds the PhysicalAddress and Communication tags.-->		             
		<!-- output                	: cXML message with Contact Tags, can have following subtags filled 	
									: Contact/Name/@xml:lang
									: Contact/Name
									: Contact/PostalAddress
									: Contact/PostalAddress/Street
									: Contact/PostalAddress/City
									: Contact/PostalAddress/State
									: Contact/PostalAddress/PostalCode
									: Contact/PostalAddress/Country
									: Contact/Email
									: Contact/Phone/TelephoneNumber/CountryCode/@isoCountryCode
									: Contact/Phone/TelephoneNumber/CountryCode
									: Contact/Phone/TelephoneNumber/AreaOrCityCode
									: Contact/Phone/TelephoneNumber/Number
									: Contact/Fax/TelephoneNumber/CountryCode/@isoCountryCode
									: Contact/Fax/TelephoneNumber/CountryCode
									: Contact/Fax/TelephoneNumber/AreaOrCityCode
									: Contact/Fax/TelephoneNumber/Number -->					
    <xsl:template name="PartnerAddr">
        <xsl:param name="v_path"/>
        <Name>
            <xsl:attribute name="xml:lang">
                <xsl:value-of
                    select="replace($v_path/Communication/CorrespondenceLanguageCode, ' ', '')"/>
            </xsl:attribute>
            <xsl:value-of select="$v_path/OrganisationFormattedName"/>
        </Name>
        <PostalAddress>
            <xsl:if test="string-length($v_path/PhysicalAddress/StreetName) > 0">
                <Street>
                    <xsl:value-of select="$v_path/PhysicalAddress/StreetName"/>
                </Street>
            </xsl:if>
                <City>
                    <xsl:value-of select="$v_path/PhysicalAddress/CityName"/>
                </City>
            <xsl:if test="string-length($v_path/PhysicalAddress/RegionName) > 0">
                <State>
                    <xsl:value-of select="$v_path/PhysicalAddress/RegionName"/>
                </State>
            </xsl:if>
            <xsl:if test="string-length($v_path/PhysicalAddress/StreetPostalCode) > 0">
                <PostalCode>
                    <xsl:value-of select="$v_path/PhysicalAddress/StreetPostalCode"/>
                </PostalCode>
            </xsl:if>
            <xsl:if test="string-length($v_path/PhysicalAddress/CountryCode) > 0">
                <Country>
                    <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$v_path/PhysicalAddress/CountryCode"/>
                    </xsl:attribute>
                    <xsl:value-of select="$v_path/PhysicalAddress/CountryName"/>
                </Country>
            </xsl:if>
        </PostalAddress>
        <xsl:if test="string-length($v_path/Communication/Email/URI) > 0">
            <Email>
                <xsl:value-of select="$v_path/Communication/Email/URI"/>
            </Email>
        </xsl:if>
        <xsl:if test="string-length($v_path/Communication/Telephone) > 0">
            <Phone>
                <TelephoneNumber>
                    <xsl:if test="string-length($v_path/Communication/Telephone/Number/AreaID) > 0">
                        <CountryCode>
                            <xsl:attribute name="isoCountryCode">
                                <xsl:value-of select="$v_path/Communication/Telephone/Number/AreaID"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="$v_path/Communication/Telephone/Number/AreaID"/>
                        </CountryCode>
                    </xsl:if>
                    <AreaOrCityCode/>
                    <xsl:if
                        test="string-length($v_path/Communication/Telephone/Number/SubscriberID) > 0">
                        <Number>
                            <xsl:value-of
                                select="$v_path/Communication/Telephone/Number/SubscriberID"/>
                        </Number>
                    </xsl:if>
                </TelephoneNumber>
            </Phone>
        </xsl:if>
        <xsl:if test="string-length($v_path/Communication/Facsimile) > 0">
            <Fax>
                <TelephoneNumber>
                    <xsl:if test="string-length($v_path/Communication/Facsimile/Number/AreaID) > 0">
                        <CountryCode>
                            <xsl:attribute name="isoCountryCode">
                                <xsl:value-of select="$v_path/Communication/Facsimile/Number/AreaID"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="$v_path/Communication/Facsimile/Number/AreaID"/>
                        </CountryCode>
                    </xsl:if>
                    <AreaOrCityCode/>
                    <xsl:if test="string-length($v_path/Communication/Facsimile/Number/AreaID) > 0">
                        <Number>
                            <xsl:value-of
                                select="$v_path/Communication/Facsimile/Number/SubscriberID"/>
                        </Number>
                    </xsl:if>
                </TelephoneNumber>
            </Fax>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
