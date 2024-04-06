<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--        <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anAddOnCIVersion"/>
    <xsl:variable name="v_SP8">
        <xsl:call-template name="Check_SupportVersion">            
            <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>            
            <xsl:with-param name="p_suppversion" select="'08'"/>            
        </xsl:call-template>
    </xsl:variable>
    <!--IG-25933-->
    <!-- Flag for Add on version GE SP12 -->
    <xsl:variable name="v_SP12_onwards">
        <xsl:call-template name="Check_SupportVersion">            
            <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>            
            <xsl:with-param name="p_suppversion" select="'12'"/>            
        </xsl:call-template>
    </xsl:variable>
    <!--IG-25933-->
    <!--Start of IG-32998 -->
    <!-- Flag for Add on version GE SP15 -->
    <xsl:variable name="v_SP15_onwards">
        <xsl:call-template name="Check_SupportVersion">            
            <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>            
            <xsl:with-param name="p_suppversion" select="'15'"/>            
        </xsl:call-template>
    </xsl:variable>
    <!-- End of IG-32998 -->    
    <xsl:template match="Combined">
        <!--   <Get the System Id -->
        <xsl:variable name="v_sysid">
            <xsl:call-template name="MultiErpSysIdIN">
                <xsl:with-param name="p_ansysid"
                    select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
                <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Prepare the CrossRef path-->
        <xsl:variable name="v_pd">
            <xsl:call-template name="PrepareCrossref">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
                <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Get the Language code-->
        <xsl:variable name="v_lang">
            <xsl:choose>
                <xsl:when
                    test="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Comments[@type = 'CommentsToBuyer']/@xml:lang != ''">
                    <xsl:value-of
                        select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Comments[@type = 'CommentsToBuyer']/@xml:lang"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="FillDefaultLang">
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="v_dateTime" select="Payload/cXML/@timestamp"/>
        <n0:DsptchdDelivNotifMsg>
            <MessageHeader>
                <CreationDateTime>
                    <xsl:value-of select="$v_dateTime"/>
                </CreationDateTime>
                <AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of select="$anReceiverID"/>
                </AribaNetworkID>
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="$v_sysid"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <Delivery>
                <xsl:choose>
                    <xsl:when
                        test='Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation = "new"'>
                        <xsl:attribute name="actionCode">
                            <xsl:value-of select="'01'"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when
                        test='Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation = "update"'>
                        <xsl:attribute name="actionCode">
                            <xsl:value-of select="'02'"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="actionCode">
                            <xsl:value-of select="'03'"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <ID>
                    <!--IG-25933-->
                    <!--Check if Add on version GT SP12 and delete operation,only then truncate last 2 char or -->
                    <!-- If not GT SP12, check if ID length GT 35 and delete op,then only truncate last 2 char -->
                    <!-- check if ID length GT 35 then only truncate last 2 char as per ERP ID max length 35 and while ASN cancel '_1' removal-->
                    <xsl:variable name="v_Idlength"
                        select="string-length(Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID)"/>  
                    <xsl:choose>
                        <xsl:when test="(($v_SP12_onwards = 'true')
                            or ($v_SP12_onwards != 'true' and  $v_Idlength > 35.0 )) and (Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@operation = 'delete')">
                            <xsl:value-of
                                select="substring(Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID,1,$v_Idlength - 2)"
                            />                          
                        </xsl:when>
                        <xsl:otherwise> 
                            <xsl:value-of
                                select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentID"/>                                  
                        </xsl:otherwise>                                     
                    </xsl:choose>    
                    <!--IG-25933--> 
                </ID>
                <!-- CI-1841 Shipment Type -->
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentType)) > 0">
                <ShipmentType>
                    <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@shipmentType"/>
                </ShipmentType>
                </xsl:if>
                <!-- Arrival date and time/ PO ID / itemid are mandatiory fields -->
                <xsl:variable name="v_erpdatetime">
                    <xsl:call-template name="ERPDateTime">
                        <xsl:with-param name="p_date"
                            select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/@deliveryDate"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                    </xsl:call-template>
                </xsl:variable>
                <CreationDateTime>
                    <xsl:value-of select="$v_erpdatetime"/>
                </CreationDateTime>
                <ArrivalDateTime>
                    <xsl:value-of select="$v_erpdatetime"/>
                </ArrivalDateTime>
                <xsl:if
                    test="string-length(Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']/@quantity) > 0">
                    <GrossWeightMeasure>
                        <xsl:attribute name="unitCode">
                            <xsl:call-template name="UOMTemplate_In">
                                <xsl:with-param name="p_UOMinput"
                                    select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']/UnitOfMeasure"/>
                                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of
                            select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossWeight']/@quantity"
                        />
                    </GrossWeightMeasure>
                </xsl:if>
                <xsl:if
                    test="string-length(Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossVolume']/@quantity) > 0">
                    <VolumeMeasure>
                        <xsl:attribute name="unitCode">
                            <xsl:call-template name="UOMTemplate_In">
                                <xsl:with-param name="p_UOMinput"
                                    select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossVolume']/UnitOfMeasure"/>
                                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of
                            select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Packaging/Dimension[@type = 'grossVolume']/@quantity"
                        />
                    </VolumeMeasure>
                </xsl:if>
                <!--Populate Vendor Party , Internal ID to handle SUR Response. Otherwise , CIG fails the SUR since Vendor ID will be blank-->
                <VendorParty>
                    <InternalID>
                        <xsl:choose>
                            <xsl:when
                                test="exists(Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity)">
                                <xsl:value-of
                                    select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="Payload/cXML/Header/From/Credential[@domain = 'PrivateID']/Identity"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </InternalID>
                </VendorParty>
                <CarrierParty>
                    <InternalID>
                        <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipControl/CarrierIdentifier/@domain"/> 
                    </InternalID>
                    <CarrierID>
                        <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipControl/CarrierIdentifier"/> 
                    </CarrierID>
                    <ProductRecipientID>
                        <!-- Added trackingNumber condition to fix IG-20071. As per cXML DTD either 'billofLading' or 'trackingNumber' can be used to identify shipment identifier  -->                        
                        <!--IG-25055-->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(Payload/cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'billOfLading'])) > 0">
                                <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'billOfLading']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipControl/ShipmentIdentifier[@domain = 'trackingNumber']"/>
                            </xsl:otherwise>
                        </xsl:choose> 
                    </ProductRecipientID>
                </CarrierParty>
                <ShipFromLocation>
                    <xsl:if test="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[1][@role = 'shipFrom']">
                        <Name>
                            <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/Name"/> 
                       </Name>
                        <Address>
                            <PhysicalAddress>
                                <CountryCode>
                                    <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role ='shipFrom']/PostalAddress/Country/@isoCountryCode"/>
                                </CountryCode>
                                <RegionCode>
                                    <xsl:choose>
                                        <xsl:when
                                            test="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/PostalAddress/State/@isoStateCode">
                                            <xsl:value-of
                                                select="substring-after(Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/PostalAddress/State/@isoStateCode, '-')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- IG-35653 - Selecting 1st 3 characters of State code, to be aligned with REGIO field in ERP -->
                                            <xsl:value-of
                                                select="normalize-space(substring(Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/PostalAddress/State, 1, 3))"/>
                                        </xsl:otherwise>
                                    </xsl:choose>                                    
                                </RegionCode>
                                <POBoxPostalCode>
                                    <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/PostalAddress/PostalCode"/>
                                </POBoxPostalCode>
                                <CityName>
                                    <xsl:value-of select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/PostalAddress/City"/>
                                </CityName>
                                <StreetName>
                                    <!-- IG-23779 -->
                                    <xsl:variable name="v_street">
                                        <xsl:for-each select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Contact[@role = 'shipFrom']/PostalAddress/Street">
                                            <xsl:value-of select="."/>
                                        </xsl:for-each>
                                    </xsl:variable>
                                    <xsl:value-of select="substring($v_street,1,40)"/>
                                    <!-- IG-23779 -->   
                                </StreetName>
                            </PhysicalAddress>
                        </Address>
                    </xsl:if>   
                </ShipFromLocation>
                <xsl:for-each
                    select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem">
                    <!--This order id has to be repeated in side Shipmentnoticeitem -->
                    <xsl:variable name="v_orderid">
                        <xsl:value-of select="../OrderReference/@orderID"/>
                    </xsl:variable>
                    <xsl:variable name="v_sa">
                        <xsl:value-of
                            select="substring($v_orderid, string-length($v_orderid) - 2, 4)"/>
                    </xsl:variable>
                    <Item>
                        <ID>
                            <xsl:value-of select="@shipNoticeLineNumber"/>
                        </ID>                        
                        <xsl:if
                            test="string-length(ShipNoticeItemDetail[1]/Dimension[@type = 'grossWeight']/@quantity) > 0">
                            <GrossWeightMeasure>
                                <xsl:attribute name="unitCode">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="ShipNoticeItemDetail[1]/Dimension[@type = 'grossWeight']/UnitofMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:value-of
                                    select="ShipNoticeItemDetail[1]/Dimension[@type = 'grossWeight']/@quantity"
                                />
                            </GrossWeightMeasure>
                        </xsl:if>
                        <xsl:if
                            test="string-length(ShipNoticeItemDetail[1]/Dimension[@type = 'Weight']/@quantity) > 0">
                            <NetWeightMeasure>
                                <xsl:attribute name="unitCode">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="ShipNoticeItemDetail[1]/Dimension[@type = 'Weight']/UnitofMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:value-of
                                    select="ShipNoticeItemDetail[1]/Dimension[@type = 'netWeight']/@quantity"
                                />
                            </NetWeightMeasure>
                        </xsl:if>
                        <xsl:if
                            test="string-length(ShipNoticeItemDetail[1]/Dimension[@type = 'grossVolume']/@quantity) > 0">
                            <VolumeMeasure>
                                <xsl:attribute name="unitCode">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="ShipNoticeItemDetail[1]/Dimension[@type = 'grossVolume']/UnitofMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:value-of
                                    select="ShipNoticeItemDetail[1]/Dimension[@type = 'grossVolume']/@quantity"
                                />
                            </VolumeMeasure>
                        </xsl:if>
                        <Quantity>
                            <xsl:attribute name="unitCode">
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput" select="UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:value-of select="@quantity"/>
                        </Quantity>
                        <xsl:if test="string-length(normalize-space(@stockTransferType)) > 0">
                        <StockTransferType>
                            <xsl:value-of select="@stockTransferType"/>
                        </StockTransferType>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@outboundType)) > 0">
                        <OutboundType>
                            <xsl:value-of select="@outboundType"/>
                        </OutboundType>
                        </xsl:if>
                        <xsl:for-each select="AssetInfo">
                            <xsl:variable name="v_sid">
                                <xsl:value-of select="@serialNumber"/>
                            </xsl:variable>
                            <xsl:if test="$v_sid != ''">
                                <SerialNumber>
                                    <SerialID>
                                        <xsl:value-of select="substring($v_sid,1,30)"/> <!-- IG-42656 restricted to map proxy field length to avoid de-serialization error -->
                                    </SerialID>
                                </SerialNumber>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:choose>
                            <xsl:when test="$v_sa = 'FOR' or $v_sa = 'JIT'">
                                <SchedulingAgreementReference>
                                    <ID>
                                        <xsl:value-of select="$v_orderid"/>
                                    </ID>
                                    <ItemID>
                                        <xsl:value-of select="@lineNumber"/>
                                    </ItemID>
                                </SchedulingAgreementReference>
                            </xsl:when>
                            <xsl:otherwise>
                                <PurchaseOrderReference>
                                    <ID>
                                        <xsl:value-of select="$v_orderid"/>
                                    </ID>
                                    <ItemID>
                                        <xsl:value-of select="@lineNumber"/>
                                    </ItemID>
                                </PurchaseOrderReference>
                            </xsl:otherwise>
                        </xsl:choose>
                        <Product>
                            <xsl:if
                                test="string-length(ItemID/BuyerPartID) > 0">
                                <InternalID>
                                    <xsl:value-of select="ItemID/BuyerPartID"/>
                                </InternalID>
                                <ProductRecipientID>
                                    <xsl:value-of select="ItemID/BuyerPartID"/>
                                </ProductRecipientID>
                            </xsl:if>
                            <!-- Begin of IG-32998 Update StandardID <-> EAN ID mapping -->
                            <!-- For SP15 and above mapp EANID if lesser than 19 characters else for lower SP's mapp if lesser then 15 characters-->
                            <xsl:choose>
                                <xsl:when test="$v_SP15_onwards = 'true'">
                                    <xsl:if
                                        test="(string-length(ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) > 0) and (string-length(ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) lt 19)">
                                        <StandardID>
                                            <!--schemeAgencyID is a REQUIRED attribute according to the proxy WSDL, hence it has to be part of the StandardID element--> 
                                            <xsl:attribute name="schemeAgencyID"/>
                                            <xsl:value-of
                                                select="ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID"
                                            />
                                        </StandardID>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if
                                        test="(string-length(ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) > 0)  and (string-length(ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) lt 15)">
                                        <StandardID>
                                            <!--schemeAgencyID is a REQUIRED attribute according to the proxy WSDL, hence it has to be part of the StandardID element--> 
                                            <xsl:attribute name="schemeAgencyID"/>
                                            <xsl:value-of
                                                select="ShipNoticeItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID"
                                            />
                                        </StandardID>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- End of IG-32998 Update StandardID <-> EAN ID mapping -->
                            <VendorID>
                                <xsl:value-of select="ItemID/SupplierPartID"/>
                            </VendorID>
                            <xsl:if
                                test="string-length(ShipNoticeItemDetail/ManufacturerPartID) > 0">
                                <ManufacturerPartID>
                                    <xsl:value-of select="ShipNoticeItemDetail/ManufacturerPartID"/>
                                </ManufacturerPartID>
                            </xsl:if>
                        </Product>
                        <xsl:if test="string-length(Batch/SupplierBatchID) > 0">
                            <Batch>
                                <InternalID>
                                    <xsl:value-of select="Batch/SupplierBatchID"/>
                                </InternalID>
                                <ProductRecipientID>
                                    <xsl:value-of select="Batch/BuyerBatchID"/>  
                                </ProductRecipientID>                                
                                    <xsl:variable name="v_mdate">
                                        <!-- IG-27471 -->
                                        <xsl:choose>
                                            <xsl:when test="string-length(Batch/@productionDate)>10">
                                                <xsl:call-template name="ERPDateTime">
                                                    <xsl:with-param name="p_date" select="Batch/@productionDate"/>
                                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="Batch/@productionDate"/>
                                            </xsl:otherwise>                                        
                                        </xsl:choose>
                                        <!-- IG-27471 -->
                                    </xsl:variable>
                                <ManufacturingDate>
                                    <xsl:value-of select="substring($v_mdate, 1, 10)"/>
                                </ManufacturingDate>
<!--                                Check ADDOn SP Version-->
                                <xsl:if test="string-length($v_SP8) > 0">
                                    <ManufacturingTime>
                                        <xsl:value-of select="substring($v_mdate, 12, 8)"/>
                                    </ManufacturingTime>   
                                </xsl:if>                                
                                    <xsl:variable name="v_edate">
                                        <xsl:choose>
                                            <xsl:when test="ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date != ''">
                                                <xsl:value-of select="ShipNoticeItemIndustry/ShipNoticeItemRetail/ExpiryDate/@date"/>
                                            </xsl:when>
                                            <xsl:when test="ShipNoticeItemIndustry/ShipNoticeItemRetail/BestBeforeDate/@date != ''">
                                                <xsl:value-of select="ShipNoticeItemIndustry/ShipNoticeItemRetail/BestBeforeDate/@date"/>
                                            </xsl:when> 
                                            <xsl:otherwise>
                                                <xsl:value-of select="Batch/@expirationDate"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>   
                                    <xsl:variable name="v_bdate">
                                        <!-- IG-27471 -->
                                        <xsl:choose>
                                            <xsl:when test="$v_edate != Batch/@expirationDate or ($v_edate = Batch/@expirationDate and string-length(Batch/@expirationDate)>10)">                                                                                           
                                                <xsl:call-template name="ERPDateTime">
                                                    <xsl:with-param name="p_date" select="$v_edate"/>
                                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="Batch/@expirationDate"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- IG-27471 -->
                                    </xsl:variable>
                                <BestBeforeDate>
                                    <xsl:value-of select="substring($v_bdate, 1, 10)"/>
                                </BestBeforeDate>
<!--                                Check AddOn SP Version-->
                                <xsl:if test="string-length($v_SP8) > 0">
                                <BestBeforeTime>
                                    <xsl:value-of select="substring($v_bdate, 12, 8)"/>
                                </BestBeforeTime>
                                </xsl:if>
                            </Batch>
                        </xsl:if>
                        <xsl:for-each select="ComponentConsumptionDetails">
                            <SubcontractingComponent>
                                <Quantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput" select="UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:value-of select="@quantity"/>
                                </Quantity>
                                <Product>
                                    <BuyerID>
                                        <xsl:value-of select="Product/BuyerPartID"/>
                                    </BuyerID>
                                    <xsl:if test="string-length(Product/SupplierPartID) > 0">
                                        <VendorID>
                                            <xsl:value-of select="Product/SupplierPartID"/>
                                        </VendorID>
                                    </xsl:if>
                                </Product>
                                <xsl:if
                                    test="(string-length(BuyerBatchID) > 0) or (string-length(SupplierBatchID) > 0)">
                                    <Batch>
                                        <BuyerID>
                                            <xsl:value-of select="BuyerBatchID"/>
                                        </BuyerID>
                                        <VendorID>
                                            <xsl:value-of select="SupplierBatchID"/>
                                        </VendorID>
                                    </Batch>
                                </xsl:if>

                            </SubcontractingComponent>
                        </xsl:for-each>
                    </Item>
                </xsl:for-each>
<!-- IG-38015, for each is now replaced by for-each-group and Grouping is done by Shippingcontainerserialcode, Load is now grouped by Shippingcontainer serial code -->                
                <xsl:for-each-group
                    select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging" group-by="ShippingContainerSerialCode">
                    <!--loop split per item CI-1322 - Auxiliary packaging-->                    
<!--                        <xsl:if test="(ShippingContainerSerialCode[1] or PackageTypeCodeIdentifierCode[1] or (Dimension[1] and PackagingCode[1])) and PackagingLevelCode != 'auxiliary'">-->
                        <xsl:if test="(ShippingContainerSerialCode[1] or PackageTypeCodeIdentifierCode[1] or (Dimension[1] and PackagingCode[1])) 
                            and (string-length(normalize-space(PackagingLevelCode)) = 0 or PackagingLevelCode != 'auxiliary')">                       
                    <HandlingUnit>
                        <ID>
                            <!--                                <xsl:value-of select="PackageTypeCodeIdentifierCode"/>-->
                            <xsl:value-of select="ShippingContainerSerialCode"/>
                        </ID>
                        <HeightMeasure>
                            <xsl:attribute name="unitCode">
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput" select="Dimension[@type = 'height']/UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID"
                                        select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anSupplierANID"
                                        select="$anReceiverID"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:variable name="v_height" select="Dimension[@type = 'height']/@quantity"/>
                            <xsl:choose>
                                <xsl:when test="exists($v_height)">
                                    <xsl:value-of select="Dimension[@type = 'height']/@quantity"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'0'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </HeightMeasure>
                        <LengthMeasure>
                            <xsl:attribute name="unitCode">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput" select="Dimension[@type = 'length']/UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>                                
                            </xsl:attribute>
                            <xsl:variable name="v_length" select="Dimension[@type = 'length']/@quantity"/>
                            <xsl:choose>
                                <xsl:when test="exists($v_length)">
                                    <xsl:value-of select="Dimension[@type = 'length']/@quantity"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'0'"/>
                                </xsl:otherwise>
                            </xsl:choose> 
                        </LengthMeasure>
                        <WidthMeasure>
                            <xsl:attribute name="unitCode">
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput" select="Dimension[@type = 'width']/UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID"
                                        select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anSupplierANID"
                                        select="$anReceiverID"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:variable name="v_width" select="Dimension[@type = 'width']/@quantity"/>
                            <xsl:choose>
                                <xsl:when test="exists($v_width)">
                                    <xsl:value-of select="Dimension[@type = 'width']/@quantity"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'0'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </WidthMeasure>
                        <NetVolumeMeasure>
                            <xsl:attribute name="unitCode">
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput" select="Dimension[@type = 'volume']/UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID"
                                        select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anSupplierANID"
                                        select="$anReceiverID"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:variable name="v_volume" select="Dimension[@type = 'volume']/@quantity"/>
                            <xsl:choose>
                                <xsl:when test="exists($v_volume)">
                                    <xsl:value-of select="Dimension[@type = 'volume']/@quantity"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'0'"/>
                                </xsl:otherwise>
                            </xsl:choose>   
                        </NetVolumeMeasure>
                        <GrossWeightMeasure>
                            <xsl:attribute name="unitCode">
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput" select="Dimension[@type = 'grossWeight']/UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID"
                                        select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anSupplierANID"
                                        select="$anReceiverID"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:variable name="v_grossWeight" select="Dimension[@type = 'grossWeight']/@quantity"/>
                            <xsl:choose>
                                <xsl:when test="exists($v_grossWeight)">
                                    <xsl:value-of select="Dimension[@type = 'grossWeight']/@quantity"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'0'"/>
                                </xsl:otherwise>
                            </xsl:choose>     
                        </GrossWeightMeasure>
                        <NetWeightMeasure>
                            <xsl:attribute name="unitCode">
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput" select="Dimension[@type = 'unitNetWeight']/UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID"
                                        select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anSupplierANID"
                                        select="$anReceiverID"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:variable name="v_unitNetWeight" select="Dimension[@type = 'unitNetWeight']/@quantity"/>
                            <xsl:choose>
                                <xsl:when test="exists($v_unitNetWeight)">
                                    <xsl:value-of select="Dimension[@type = 'unitNetWeight']/@quantity"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'0'"/>
                                </xsl:otherwise>
                            </xsl:choose>   
                        </NetWeightMeasure>
                        <LoadCarrier>
                            <Product>
                                <InternalID>
                                    <xsl:value-of select="ShippingContainerSerialCode"/>
                                </InternalID>
                                <ProductRecipientID>
                                    <xsl:value-of select="PackageTypeCodeIdentifierCode"/>
                                </ProductRecipientID>
                            </Product>
                        </LoadCarrier>
                        <xsl:variable name="v_shipcode" select="ShippingContainerSerialCode"/> 
                        <xsl:for-each select="../Packaging[ShippingContainerSerialCodeReference = $v_shipcode]">                                    
                            <xsl:if
                                test="PackagingLevelCode = 'auxiliary'">
                                <!-- CI-1322 - Auxiliary packaging -->
                                <AdditionalPackaging>
                                    <Product>
                                        <InternalID>
                                            <xsl:value-of select="PackagingCode"/>
                                        </InternalID>
                                    </Product>
                                    <Quantity>
                                        <xsl:attribute name="unitCode"> 
                                            <xsl:call-template name="UOMTemplate_In">
                                                <xsl:with-param name="p_UOMinput" select="DispatchQuantity/UnitOfMeasure"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anReceiverID"/>
                                            </xsl:call-template>         
                                        </xsl:attribute>
                                        <xsl:value-of select="DispatchQuantity/@quantity"/>
                                    </Quantity>
                                </AdditionalPackaging>
                            </xsl:if>                           
                        </xsl:for-each>
   <!-- IG-39342: this is the case of Mixed HU where in different Items of different PO/ different items of same PO can be packed under same HU, hence as per
   cxml same HU would be available under different Ship Notice Portion/ShipNotice Item so we are grouping HU across whole structure at very high level of Payload
   Howver the logic for auxiliary materail is still remains same as before-->       
           <xsl:for-each-group select="//Payload/cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Packaging[ShippingContainerSerialCodeReference = $v_shipcode]" group-by="ShippingContainerSerialCode">
               <xsl:if
                                test="string-length(normalize-space(PackagingLevelCode)) = 0 or PackagingLevelCode != 'auxiliary'">
                   <LowerLevelHandlingUnit>
                       <ID>
                           <xsl:value-of select="ShippingContainerSerialCode"/>
                       </ID>
                   </LowerLevelHandlingUnit>
               </xsl:if>
          </xsl:for-each-group>   
                        <!-- change check for Lower level packaging CI-1322 - Auxiliary packaging -->
                        <!-- CI-2418 - Added additional Quantity check to ignore for EMPTY packaging material at Lower level packaging -->                        
 <!-- IG-38015, Load is now filled based on grouping by shipping container serial code -->                      
                        <xsl:for-each select="current-group()">    
                        <xsl:if test="Description/@type = 'Material'and DispatchQuantity/@quantity > 0">                            
                            <Load>
                                <Quantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput"
                                                select="DispatchQuantity/UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:value-of select="DispatchQuantity/@quantity"/>
                                </Quantity>
                                <BusinessTransactionDocumentReference>
                                    <ID>
                                        <xsl:value-of
                                            select="../../../ShipNoticeHeader/@shipmentID"/>
                                    </ID>
                                    <ItemID>
                                        <xsl:value-of select="../@shipNoticeLineNumber"/>
                                    </ItemID>
                                </BusinessTransactionDocumentReference>
                            </Load>
                        </xsl:if>  
                        </xsl:for-each> 
                    </HandlingUnit>
                  </xsl:if>                        
                </xsl:for-each-group>
            </Delivery>
            <!--            Comments-->
            <!--Call Template to fill Comments-->
            <AribaComment>
                <xsl:call-template name="CommentsFillProxyIn">
                    <xsl:with-param name="p_comments"
                        select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Comments[@type = 'CommentsToBuyer']"/>
                    <xsl:with-param name="p_lang" select="$v_lang"/>
                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                </xsl:call-template>
                <xsl:call-template name="CommentsFillProxyIn">
                    <xsl:with-param name="p_comments"
                        select="Payload/cXML/Request/ShipNoticeRequest/ShipControl/Comments[@type = 'CommentsToBuyer']"/>
                    <xsl:with-param name="p_lang" select="$v_lang"/>
                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                    <xsl:with-param name="p_shipcontrolid" select="'ShipControlTextID'"/>
                </xsl:call-template>
            </AribaComment>
            <xsl:variable name="v_final">
                <xsl:for-each-group select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticePortion/ShipNoticeItem/Comments/Attachment" group-by="URL">
                    <xsl:for-each select="current-group()">
                        <xsl:if test="position() = 1">
                            <lineNumber>
                                <!-- Start of IG-24667 Replace PO line from Ship Notice line -->    
                                <!--<xsl:value-of select="../../@lineNumber"/> -->
                                <xsl:value-of select="../../@shipNoticeLineNumber"/>
                                <!-- End of IG-24667 Replace PO line from Ship Notice line -->                                   
                            </lineNumber>
                            <URL>
                                <xsl:value-of select="URL"/>
                            </URL>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:if test="AttachmentList/Attachment">
                <xsl:call-template name="InboundMultiAttProxy_Common">              <!-- IG-17864 -->
                    <xsl:with-param name="headerAtt"
                        select="Payload/cXML/Request/ShipNoticeRequest/ShipNoticeHeader/Comments/Attachment/URL"/>
                    <xsl:with-param name="lineReference"
                        select="
                        $v_final/lineNumber
                        | $v_final/URL  "/>                  
                </xsl:call-template>
            </xsl:if>
        </n0:DsptchdDelivNotifMsg>
    </xsl:template>
</xsl:stylesheet>
