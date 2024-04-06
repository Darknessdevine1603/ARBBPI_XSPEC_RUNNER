<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:ns2="http://sap.com/xi/APPL/SE/Global"
  xmlns:p1="http://sap.com/xi/ARBCIG1" xmlns:n0="http://sap.com/xi/ARBCIG1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="http://sap.com/xi/SAPGlobal20/Global"
  exclude-result-prefixes="#all">
  <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <xsl:param name="anTargetDocumentType"/>
  <xsl:variable name="v_empty" select='""'/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anERPTimeZone"/>
  <xsl:param name="anIsMultiERP"/>
  <xsl:param name="anSharedSecrete"/>
  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anEnvName"/>
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
      <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="v_defaultLang">
    <xsl:call-template name="FillDefaultLang">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_pd" select="$v_pd"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:template match="n0:DsptchdDelivNotifMsg">
    <xsl:variable name="v_shipTo" select="'shipTo'"/>
    <xsl:variable name="v_shipFrom" select="'shipFrom'"/>
    <xsl:variable name="v_volume" select="'volume'"/>
    <xsl:variable name="v_weight" select="'weight'"/>
    <xsl:variable name="v_grossWeight" select="'grossWeight'"/>
    <xsl:variable name="v_shipFromLocAddress" select="Delivery/ShipFromLocation/Address"/>
    <xsl:variable name="v_shipToLocAddress" select="Delivery/ShipToLocation/Address"/>
    <Combined>
      <Payload>
        <!-- cXML Header -->
        <cXML>
          <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
          </xsl:attribute>
          <xsl:attribute name="timestamp">
            <xsl:variable name="v_curDate">
              <xsl:value-of select="current-dateTime()"/>
            </xsl:variable>
            <xsl:value-of select="concat(substring($v_curDate, 1, 19), substring($v_curDate, 24, 29))"/>
          </xsl:attribute>
          <Header>
            <From>
              <xsl:call-template name="MultiERPTemplateOut">
                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
              </xsl:call-template>
              <Credential domain="NetworkID">
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
              <Credential>
                <xsl:attribute name="domain">
                  <xsl:value-of select="'VendorID'"/>
                </xsl:attribute>
                <Identity>
                  <xsl:value-of select="Delivery/VendorParty/InternalID"/>
                </Identity>
              </Credential>
            </To>
            <Sender>
              <Credential domain="NetworkID">
                <Identity>
                  <xsl:value-of select="$anProviderANID"/>
                </Identity>
                <SharedSecret>
                  <xsl:value-of select="$anSharedSecrete"/>
                </SharedSecret>
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
            <ShipNoticeRequest>
              <!-- ShipNotice Header -->
              <ShipNoticeHeader>
                <xsl:attribute name="shipmentID">
                  <xsl:value-of select="Delivery/ID"/>
                </xsl:attribute>
                <!-- CI-1841 Support Operation update & delete -->
                <xsl:attribute name="operation">
                <xsl:choose>
                  <xsl:when test="Delivery/@actionCode = '02'">
                    <xsl:value-of select="'update'"/>
                  </xsl:when>
                  <xsl:when test="Delivery/@actionCode = '03'">
                    <xsl:value-of select="'delete'"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="'new'"/>
                  </xsl:otherwise>
                </xsl:choose>
                </xsl:attribute>
                <!-- Template ANDateTimezone -->
                <xsl:attribute name="noticeDate">           
                  <xsl:call-template name="ANDateTime">
                    <xsl:with-param name="p_date">
                      <xsl:value-of select="translate((substring-before(Delivery/CreationDateTime, 'T')), '-', '')"/>
                    </xsl:with-param>
                    <xsl:with-param name="p_time">
                      <xsl:value-of select="translate((substring-after(Delivery/CreationDateTime, 'T')), ':', '')"/>
                    </xsl:with-param>
                    <xsl:with-param name="p_timezone">
                      <xsl:value-of select="$anERPTimeZone"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:attribute>
                <!-- AN DateTime Template -->
                <!-- Template ANDateTimezone -->
                <xsl:if test="string-length(normalize-space(Delivery/IssueDateTime)) > 0">
                  <xsl:attribute name="shipmentDate">
                    <xsl:call-template name="ANDateTime">
                      <xsl:with-param name="p_date">
                        <xsl:value-of select="translate((substring-before(Delivery/IssueDateTime, 'T')), '-', '')"/>
                      </xsl:with-param>
                      <xsl:with-param name="p_time">
                        <xsl:value-of select="translate((substring-after(Delivery/IssueDateTime, 'T')), ':', '')"/>
                      </xsl:with-param>
                      <xsl:with-param name="p_timezone">
                        <xsl:value-of select="$anERPTimeZone"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <!-- Template ANDateTimezone -->
                <xsl:if test="string-length(normalize-space(Delivery/ArrivalDateTime)) > 0">
                  <xsl:attribute name="deliveryDate">
                    <xsl:call-template name="ANDateTime">
                      <xsl:with-param name="p_date">
                        <xsl:value-of select="translate((substring-before(Delivery/ArrivalDateTime, 'T')), '-', '')"/>
                      </xsl:with-param>
                      <xsl:with-param name="p_time">
                        <xsl:value-of select="translate((substring-after(Delivery/ArrivalDateTime, 'T')), ':', '')"/>
                      </xsl:with-param>
                      <xsl:with-param name="p_timezone">
                        <xsl:value-of select="$anERPTimeZone"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="shipmentType">
                  <xsl:value-of select="Delivery/ShipmentType"/>
                </xsl:attribute>
                <xsl:if test="string-length(normalize-space(Delivery/@reason)) > 0">
                  <xsl:attribute name="reason">
                    <xsl:value-of select="Delivery/@reason"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(Delivery/Servicedelprio)) > 0">                 
                <ServiceLevel>
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="Delivery/Servicedelprio/@languageCode"/>
                </xsl:attribute>
                  <xsl:value-of select="Delivery/Servicedelprio"/>
                </ServiceLevel>   
                     </xsl:if>
                <!-- Template Contact Ship From Loc Address-->
                <xsl:call-template name="Contact">
                  <xsl:with-param name="p_ship" select="$v_shipFrom"/>
                  <xsl:with-param name="p_correspondenceLanguageCode"
                    select="$v_shipFromLocAddress/Communication/CorrespondenceLanguageCode"/>
                  <xsl:with-param name="p_organisationFormattedName"
                    select="$v_shipFromLocAddress/OrganisationFormattedName"/>
                  <xsl:with-param name="p_streetName"
                    select="$v_shipFromLocAddress/PhysicalAddress/StreetName"/>
                  <xsl:with-param name="p_cityName"
                    select="$v_shipFromLocAddress/PhysicalAddress/CityName"/>
                  <xsl:with-param name="p_state"
                    select="$v_shipFromLocAddress/PhysicalAddress/RegionName"/>
                  <xsl:with-param name="p_streetPostalCode"
                    select="$v_shipFromLocAddress/PhysicalAddress/StreetPostalCode"/>
                  <xsl:with-param name="p_countryCode"
                    select="$v_shipFromLocAddress/PhysicalAddress/CountryCode"/>
                  <xsl:with-param name="p_countryName"
                    select="$v_shipFromLocAddress/PhysicalAddress/CountryName"/>
                  <xsl:with-param name="p_isocountryCode"
                    select="$v_shipFromLocAddress/Communication/Telephone/Number/AreaID"/>
                  <xsl:with-param name="p_email" select="$v_empty"/>
                  <xsl:with-param name="p_telf"
                    select="$v_shipFromLocAddress/Communication/Telephone/Number/SubscriberID"/>
                  <xsl:with-param name="p_faxisocountryCode"
                    select="$v_shipFromLocAddress/Communication/Facsimile/Number/AreaID"/>
                  <xsl:with-param name="p_telfx"
                    select="$v_shipFromLocAddress/Communication/Facsimile/Number/SubscriberID"/>
                </xsl:call-template>
                <!-- Template Contact Ship To Loc Address-->
                <xsl:call-template name="Contact">
                  <xsl:with-param name="p_ship" select="$v_shipTo"/>
                  <xsl:with-param name="p_correspondenceLanguageCode"
                    select="$v_shipToLocAddress/Communication/CorrespondenceLanguageCode"/>
                  <xsl:with-param name="p_organisationFormattedName"
                    select="$v_shipToLocAddress/OrganisationFormattedName"/>
                  <xsl:with-param name="p_streetName"
                    select="$v_shipToLocAddress/PhysicalAddress/StreetName"/>
                  <xsl:with-param name="p_cityName"
                    select="$v_shipToLocAddress/PhysicalAddress/CityName"/>
                  <xsl:with-param name="p_state"
                    select="$v_shipToLocAddress/PhysicalAddress/RegionName"/>
                  <xsl:with-param name="p_streetPostalCode"
                    select="$v_shipToLocAddress/PhysicalAddress/StreetPostalCode"/>
                  <xsl:with-param name="p_countryCode"
                    select="$v_shipToLocAddress/PhysicalAddress/CountryCode"/>
                  <xsl:with-param name="p_countryName"
                    select="$v_shipToLocAddress/PhysicalAddress/CountryName"/>
                  <xsl:with-param name="p_isocountryCode"
                    select="$v_shipToLocAddress/Communication/Telephone/Number/AreaID"/>
                  <xsl:with-param name="p_email"
                    select="$v_shipToLocAddress/Communication/Email/URI"/>
                  <xsl:with-param name="p_telf"
                    select="$v_shipToLocAddress/Communication/Telephone/Number/SubscriberID"/>
                  <xsl:with-param name="p_faxisocountryCode"
                    select="$v_shipToLocAddress/Communication/Facsimile/Number/AreaID"/>
                  <xsl:with-param name="p_telfx"
                    select="$v_shipToLocAddress/Communication/Facsimile/Number/SubscriberID"/>
                </xsl:call-template>
                <!-- Addition of Legal Entity (Comapny Code info) -->
                <xsl:if test="string-length(normalize-space(Delivery/BuyerParty/InternalID)) > 0">
                  <LegalEntity>
                    <IdReference>
                      <xsl:attribute name="identifier" select="Delivery/BuyerParty/InternalID"/>
                      <xsl:attribute name="domain" select="'CompanyCode'"/>
                      <xsl:if test="string-length(normalize-space(Delivery/BuyerParty/InternalID/@schemeID)) > 0">
                        <Description>
                          <xsl:attribute name="xml:lang">
                            <xsl:value-of select="$v_defaultLang"/>
                          </xsl:attribute>                        
                          <xsl:value-of select="Delivery/BuyerParty/InternalID/@schemeID"/>
                        </Description>
                      </xsl:if>
                    </IdReference>
                  </LegalEntity>
                </xsl:if>
                <xsl:for-each-group select="/n0:DsptchdDelivNotifMsg/AribaComment/Item[not(ItemNumber)]" group-by="TextDesc">
                  <xsl:for-each select="current-group()">
                    <Comments>
                      <xsl:call-template name="MapMultiple_Text_Comments_Proxy_To_cXML">
                        <xsl:with-param name="p_aribaComment" select="."/>
                        <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                        <xsl:with-param name="p_trans" select="'DDN'"/>
                      </xsl:call-template>
                      <xsl:call-template name="addContenId">
                        <xsl:with-param name="eachAtt" select="/n0:DsptchdDelivNotifMsg/Attachment/Item"/>
                      </xsl:call-template>
                    </Comments>
                  </xsl:for-each>
                </xsl:for-each-group>
                <TermsOfDelivery>
                <TermsOfDeliveryCode>
                <xsl:attribute name="value">
                  <xsl:value-of select="'TransportCondition'"/>
                </xsl:attribute>
                </TermsOfDeliveryCode>
                <ShippingPaymentMethod>
                  <xsl:attribute name="value">
                    <xsl:value-of select="'Other'"/>
                  </xsl:attribute>
                    <xsl:value-of select="'-'"/>                
                </ShippingPaymentMethod>
                </TermsOfDelivery>                
              </ShipNoticeHeader>
              <ShipControl>
                <CarrierIdentifier>
                  <xsl:attribute name="domain">
                    <xsl:value-of select="'companyName'"/>
                  </xsl:attribute>
                  <xsl:value-of select="Delivery/CarrierParty/Address/OrganisationFormattedName"/>      <!-- IG-18182 --> 
                </CarrierIdentifier>
                <ShipmentIdentifier>
                  <xsl:value-of select="Delivery/CarrierParty/ProductRecipientID"/>                     <!-- IG-18182 -->
                </ShipmentIdentifier>
              </ShipControl>
              <!-- Looping Item-->
              <xsl:for-each select="Delivery/Item">
                <ShipNoticePortion>
                  <OrderReference>
                    <xsl:attribute name="orderID">
                      <xsl:value-of select="PurchaseOrderReference/ID"/>
                    </xsl:attribute>
                    <DocumentReference>
                      <xsl:attribute name="payloadID"/>
                    </DocumentReference>
                  </OrderReference>
                  <xsl:variable name="v_ItemID" select="ID"/>
                  <xsl:for-each-group select="/n0:DsptchdDelivNotifMsg/AribaComment/Item[ItemNumber = $v_ItemID]" group-by="ItemNumber">
                    <xsl:for-each select="current-group()">
                      <Comments>
                        <xsl:call-template name="MapMultiple_Text_Comments_Proxy_To_cXML">
                          <xsl:with-param name="p_aribaComment"
                            select="."/>
                          <xsl:with-param name="p_itemNumber" select="/n0:DsptchdDelivNotifMsg/Delivery/Item/ID"/>
                          <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                          <xsl:with-param name="p_pd" select="$v_pd"/>
                          <xsl:with-param name="p_trans" select="'DDN'"/>
                        </xsl:call-template>  
                        <xsl:call-template name="addContenId">
                          <xsl:with-param name="eachAtt"
                            select="/n0:DsptchdDelivNotifMsg/Attachment/Item"/>
                          <xsl:with-param name="lineNumber" select="/n0:DsptchdDelivNotifMsg/Delivery/Item/ID"/>
                        </xsl:call-template>
                      </Comments>
                    </xsl:for-each>
                  </xsl:for-each-group>
                  <ShipNoticeItem>
                    <xsl:attribute name="quantity">
                      <xsl:value-of select="Quantity"/>
                    </xsl:attribute>
                    <xsl:attribute name="lineNumber">
                      <xsl:value-of select="PurchaseOrderReference/ItemID"/>
                    </xsl:attribute>
                    <xsl:attribute name="shipNoticeLineNumber">
                      <xsl:value-of select="ID"/>
                    </xsl:attribute>
                    <!-- CI-1584 map StockTransferType and Outboundtype for STO Orders  -->
                    <xsl:if test="string-length(normalize-space(StockTransferType))>0 ">
                      <xsl:attribute name="stockTransferType">
                        <xsl:value-of select="StockTransferType"/>
                      </xsl:attribute>
                      <xsl:attribute name="outboundType">
                        <xsl:value-of select="'stockTransport'"/>
                      </xsl:attribute>
                    </xsl:if>
                    <ItemID>
                      <SupplierPartID>
                        <xsl:value-of select="Product/InternalID"/>
                      </SupplierPartID>
                      <BuyerPartID>
                        <xsl:value-of select="Product/BuyerID"/>
                      </BuyerPartID>                      
                      <xsl:if test="string-length(normalize-space(Product/StandardID[1])) > 0">
                        <IdReference>
                          <xsl:attribute name="identifier">
                            <xsl:value-of select="Product/StandardID[1]"/>
                          </xsl:attribute>
                          <xsl:attribute name="domain">
                            <xsl:value-of select="'EAN-13'"/>   
                          </xsl:attribute>
                        </IdReference>  
                      </xsl:if>                                      
                    </ItemID>
                    <ShipNoticeItemDetail>
                      <Description>
                        <xsl:attribute name="xml:lang">
                          <xsl:value-of select="$v_defaultLang"/>
                        </xsl:attribute>
                        <xsl:value-of select="Product/Note"/>
                      </Description>
                      <!-- Template Dimension for GrossWeightMeasure-->
                      <xsl:call-template name="Dimension">
                        <xsl:with-param name="p_quantity" select="GrossWeightMeasure"/>
                        <xsl:with-param name="p_type" select="$v_grossWeight"/>
                        <!-- PD entries to be taken for UnitOfMeasure -->
                        <xsl:with-param name="p_unitOfMeasure" select="GrossWeightMeasure/@unitCode"/>
                        <xsl:with-param name="p_dimension" select="GrossWeightMeasure"/>
                      </xsl:call-template>
                      <!-- Template Dimension for NetWeightMeasure-->
                      <xsl:call-template name="Dimension">
                        <xsl:with-param name="p_quantity" select="NetWeightMeasure"/>
                        <xsl:with-param name="p_type" select="$v_weight"/>
                        <!-- PD entries to be taken for UnitOfMeasure -->
                        <xsl:with-param name="p_unitOfMeasure" select="NetWeightMeasure/@unitCode"/>
                        <xsl:with-param name="p_dimension" select="NetWeightMeasure"/>
                      </xsl:call-template>
                      <!-- Template Dimension for VolumeMeasure-->
                      <xsl:call-template name="Dimension">
                        <xsl:with-param name="p_quantity" select="VolumeMeasure"/>
                        <xsl:with-param name="p_type" select="$v_volume"/>
                        <!-- PD entries to be taken for UnitOfMeasure -->
                        <xsl:with-param name="p_unitOfMeasure" select="VolumeMeasure/@unitCode"/>
                        <xsl:with-param name="p_dimension" select="VolumeMeasure"/>
                      </xsl:call-template>
                      <xsl:if test="string-length(normalize-space(Product/StandardID[1])) > 0">
                      <ItemDetailIndustry>
                        <ItemDetailRetail>
                          <EANID>
                            <xsl:value-of select="Product/StandardID[1]"/>
                          </EANID>                     
                        </ItemDetailRetail>
                      </ItemDetailIndustry>
                      </xsl:if>
                    </ShipNoticeItemDetail>
                    <!-- PD entries to be taken for UnitOfMeasure -->
                    <UnitOfMeasure>
                      <xsl:call-template name="UOMTemplate_Out">
                        <xsl:with-param name="p_UOMinput" select="Quantity/@unitCode"/>
                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                        <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                      </xsl:call-template>
                    </UnitOfMeasure>
                    <Batch>
                      <!-- Begin of Changes IG-29617 -->
                      <xsl:if test="string-length(normalize-space(Batch/InternalID)) > 0"> 
                        <BuyerBatchID>
                          <xsl:value-of select="Batch/InternalID"/>
                        </BuyerBatchID>
                      </xsl:if>
                      <!-- End of Changes IG-29617 -->
                      <SupplierBatchID>     
                        <!-- Begin of Changes IG-29617 -->
                        <!-- Mapping VendorId to Supplierbatch and InternalID is BuyerBatch -->
                        <xsl:value-of select="Batch/VendorID"/>  
                        <!-- End of Changes IG-29617 -->
                      </SupplierBatchID>             
                    </Batch>
                    <xsl:for-each select="SerialNumber/SerialID">                      
                      <AssetInfo>
                        <xsl:attribute name="tagNumber"></xsl:attribute>
                        <xsl:attribute name="serialNumber">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                      </AssetInfo>
                    </xsl:for-each>
                    <!-- Checking for BestBeforeDate only becasue same field is filled for bith the Fields from Backend[ABAP] -->
                    <xsl:if test="string-length(normalize-space(../../Delivery/BestBeforeDate)) > 0">                    
                <ShipNoticeItemIndustry>
                  <ShipNoticeItemRetail>
                    <BestBeforeDate> 
                      <xsl:attribute name="date">
                        <xsl:value-of select="../../Delivery/BestBeforeDate"/>
                      </xsl:attribute>
                    </BestBeforeDate>
                    <ExpiryDate> 
                      <xsl:attribute name="date">
                        <xsl:value-of select="../../Delivery/ExpiryDate"/>     
                      </xsl:attribute>
                    </ExpiryDate>
                  </ShipNoticeItemRetail>
                </ShipNoticeItemIndustry>  
              </xsl:if>
                  </ShipNoticeItem>
                </ShipNoticePortion>
              </xsl:for-each>
            </ShipNoticeRequest>
          </Request>
        </cXML>
      </Payload>
      <!--                Attachment Code-->
      <xsl:call-template name="OutBoundAttach"/>
    </Combined>
  </xsl:template>
  <!-- Dimension Template -->
  <xsl:template name="Dimension">
    <xsl:param name="p_quantity"/>
    <xsl:param name="p_type"/>
    <xsl:param name="p_unitOfMeasure"/>
    <xsl:param name="p_dimension"/>
    <xsl:if test="string-length(normalize-space($p_quantity)) > 0">
      <Dimension>
        <xsl:attribute name="quantity">
          <xsl:value-of select="$p_quantity"/>
        </xsl:attribute>
        <xsl:attribute name="type">
          <xsl:value-of select="$p_type"/>
        </xsl:attribute>
        <UnitOfMeasure>
          <xsl:call-template name="UOMTemplate_Out">
            <xsl:with-param name="p_UOMinput" select="$p_unitOfMeasure"/>
            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
            <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
          </xsl:call-template>
        </UnitOfMeasure>
      </Dimension>
    </xsl:if>
  </xsl:template>
  <!-- Contact Template -->
  <xsl:template name="Contact">
    <xsl:param name="p_ship"/>
    <xsl:param name="p_correspondenceLanguageCode"/>
    <xsl:param name="p_organisationFormattedName"/>
    <xsl:param name="p_streetName"/>
    <xsl:param name="p_cityName"/>
    <xsl:param name="p_state"/>
    <xsl:param name="p_streetPostalCode"/>
    <xsl:param name="p_countryCode"/>
    <xsl:param name="p_countryName"/>
    <xsl:param name="p_isocountryCode"/>
    <xsl:param name="p_email"/>
    <xsl:param name="p_telf"/>
    <xsl:param name="p_faxisocountryCode"/>
    <xsl:param name="p_telfx"/>
    <Contact>
      <xsl:attribute name="role">
        <xsl:value-of select="$p_ship"/>
      </xsl:attribute>
      <Name>
        <!-- PD Entries to be taken for lang -->
        <xsl:call-template name="FillLangOut">
          <xsl:with-param name="p_spras_iso" select="$p_correspondenceLanguageCode"/>
          <xsl:with-param name="p_lang" select="$v_defaultLang"/>
        </xsl:call-template>
        <xsl:value-of select="$p_organisationFormattedName"/>
      </Name>
      <PostalAddress>
        <Street>
          <xsl:value-of select="$p_streetName"/>
        </Street>
        <City>
          <xsl:value-of select="$p_cityName"/>
        </City>
        <State>
          <xsl:value-of select="$p_state"/>
        </State>
        <PostalCode>
          <xsl:value-of select="$p_streetPostalCode"/>
        </PostalCode>
        <Country>
          <xsl:attribute name="isoCountryCode">
            <xsl:value-of select="$p_countryCode"/>
          </xsl:attribute>
          <xsl:value-of select="$p_countryName"/>
        </Country>
      </PostalAddress>
      <xsl:if test="string-length(normalize-space($p_email)) > 0">
        <Email>
          <xsl:value-of select="$p_email"/>
        </Email>
      </xsl:if>
      <Phone>
        <TelephoneNumber>
          <CountryCode>
            <xsl:attribute name="isoCountryCode">
              <xsl:value-of select="$p_isocountryCode"/>
            </xsl:attribute>
            <xsl:value-of select="$p_isocountryCode"/>
          </CountryCode>
          <AreaOrCityCode>
            <xsl:value-of select="$v_empty"/>
          </AreaOrCityCode>
          <Number>
            <xsl:value-of select="$p_telf"/>
          </Number>
        </TelephoneNumber>
      </Phone>
      <Fax>
        <TelephoneNumber>
          <CountryCode>
            <xsl:attribute name="isoCountryCode">
              <xsl:value-of select="$p_faxisocountryCode"/>
            </xsl:attribute>
            <xsl:value-of select="$p_faxisocountryCode"/>
          </CountryCode>
          <AreaOrCityCode>
            <xsl:value-of select="$v_empty"/>
          </AreaOrCityCode>
          <Number>
            <xsl:value-of select="$p_telfx"/>
          </Number>
        </TelephoneNumber>
      </Fax>
    </Contact>
  </xsl:template>
</xsl:stylesheet>
