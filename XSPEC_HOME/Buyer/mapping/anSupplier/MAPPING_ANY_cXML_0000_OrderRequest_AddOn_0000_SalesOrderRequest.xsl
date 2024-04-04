<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIS"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:variable name="v_actionCode"/>
    <xsl:param name="anAlternativeSender"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:variable name="v_FromNetworkID">
        <xsl:choose>
            <xsl:when
                test="string-length(normalize-space(Combined/Payload/cXML/Header/From/Credential[@domain = 'NetworkId']/Identity)) > 0">
                <xsl:value-of
                    select="Combined/Payload/cXML/Header/From/Credential[@domain = 'NetworkId']/Identity"
                />
            </xsl:when>
            <xsl:when
                test="string-length(normalize-space(Combined/Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity)) > 0">
                <xsl:value-of
                    select="Combined/Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity"
                />
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="v_ToNetworkID">
        <xsl:choose>
            <xsl:when
                test="string-length(normalize-space(Combined/Payload/cXML/Header/To/Credential[@domain = 'NetworkId']/Identity)) > 0">
                <xsl:value-of
                    select="Combined/Payload/cXML/Header/To/Credential[@domain = 'NetworkId']/Identity"
                />
            </xsl:when>
            <xsl:when
                test="string-length(normalize-space(Combined/Payload/cXML/Header/To/Credential[@domain = 'NetworkID']/Identity)) > 0">
                <xsl:value-of
                    select="Combined/Payload/cXML/Header/To/Credential[@domain = 'NetworkID']/Identity"
                />
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="v_CRTDateTime">
        <xsl:choose>
            <xsl:when test="ends-with(Combined/Payload/cXML/@timestamp, 'Z')">
                <xsl:value-of
                    select="concat(substring(Combined/Payload/cXML/@timestamp, 1, 19), 'Z')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat(substring(Combined/Payload/cXML/@timestamp, 1, 19), 'Z')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="Combined">
        <n0:SalesOrderRequest>
            <MessageHeader>
                <AribaPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaPayloadID>
                <AribaNetworkID>
                    <BuyerAribaNetworkID>
                        <xsl:value-of select="$v_FromNetworkID"/>
                    </BuyerAribaNetworkID>
                    <SupplierAribaNetworkID>
                        <xsl:value-of select="$v_ToNetworkID"/>
                    </SupplierAribaNetworkID>
                </AribaNetworkID>
                <CreationDateTime>
                    <xsl:value-of select="$v_CRTDateTime"/>
                </CreationDateTime>
            </MessageHeader>
            <SalesOrder>
                <!-- Operation type -->
                <xsl:variable name="v_actionCode">
                    <xsl:choose>
                        <xsl:when
                            test='Payload/cXML/Request/OrderRequest/OrderRequestHeader/@type = "new"'>
                            <xsl:value-of select="'01'"/>
                        </xsl:when>
                        <xsl:when
                            test='Payload/cXML/Request/OrderRequest/OrderRequestHeader/@type = "update"'>
                            <xsl:value-of select="'02'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'03'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="actionCode">
                    <xsl:value-of select="$v_actionCode"/>
                </xsl:attribute>
                <!-- Purchase order no -->
                <ID>
                    <xsl:value-of select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderID,1,35)"/>
                </ID>
                <!-- PO Order date -->
                <BuyerPostingDateTime>
                    <xsl:attribute name="timeZoneCode">
                        <xsl:value-of
                            select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 20, 25)"
                        />
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length(normalize-space($anERPTimeZone)) > 0">
                            <xsl:variable name="v_DateTime">
                                <xsl:value-of
                                    select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 1, 25)"
                                />
                            </xsl:variable>
                            <xsl:variable name="v_erpdatetime">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date" select="$v_DateTime"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="$v_erpdatetime"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="concat(substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 1, 19), 'Z')"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </BuyerPostingDateTime>
                <!-- Buyer ID -->
                <BuyerParty>
                    <InternalID>
                        <xsl:value-of select="substring($anAlternativeSender,1,32)"/>
                    </InternalID>
                </BuyerParty>
                <!-- Supplier ID -->
                <xsl:if
                    test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'partyAdditionalID'])) > 0">
                    <SellerParty>
                        <InternalID>
                            <xsl:value-of
                                select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'partyAdditionalID'],1,32)"
                            />
                        </InternalID>
                    </SellerParty>
                </xsl:if>
                <!--  PO Order Type -->
                <BuyerOrderType>
                    <xsl:value-of
                        select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderType,1,35)"/>
                </BuyerOrderType>
                <!--  PO Document Type -->
                <BuyerDocumentType>
                    <xsl:value-of
                        select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType/@documentType,1,5)"
                    />
                </BuyerDocumentType>
                <!-- ShipTo -->
                <xsl:if test="exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo)">
                    <ProductRecipientParty>
                        <InternalID>
                            <xsl:attribute name="schemeID">
                                <xsl:value-of select="'WE'"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID)) > 0">
                                    <xsl:value-of select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID,1,32)"/>
                                </xsl:when>
                                <xsl:when test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/IdReference[@domain = 'buyerLocationID']/@identifier)) > 0">
                                    <xsl:value-of select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/IdReference[@domain='buyerLocationID']/@identifier,1,32)"/>
                                </xsl:when>
                            </xsl:choose>
                        </InternalID>
                        <xsl:call-template name="FillPartyAddress">
                            <xsl:with-param name="v_path"
                                select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"
                            />
                        </xsl:call-template>
                    </ProductRecipientParty>
                </xsl:if>
                <!-- BillTo -->
                <xsl:if test="exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo)">
                    <BillToParty>
                        <InternalID>
                            <xsl:attribute name="schemeID">
                                <xsl:value-of select="'RE'"/>
                            </xsl:attribute>
                            <xsl:value-of
                                select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/@addressID,1,32)"
                            />
                        </InternalID>
                        <xsl:call-template name="FillPartyAddress">
                            <xsl:with-param name="v_path"
                                select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo"
                            />
                        </xsl:call-template>
                    </BillToParty>
                </xsl:if>
                   <!-- CI-1607- Payment terms -->
                <!--Populate the CashDiscountTerms only if payment term exist-->
                <xsl:if test="exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[1])  
                    or exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[2]) 
                    or exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[3])" >
                    <CashDiscountTerms>
                        <xsl:for-each
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm">
                            <!--Populate the MaximumCashDiscount only if payment term is having discount percentage or payin days -->
                            <xsl:if
                                test="
                                position() = 1
                                and string-length(normalize-space(Discount/DiscountPercent/@percent)) > 0">
                                <MaximumCashDiscount>
                                    <Percent>
                                        <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                                    </Percent>
                                    <DaysValue>
                                        <xsl:value-of select="@payInNumberOfDays"/>
                                    </DaysValue>
                                </MaximumCashDiscount>
                            </xsl:if>
                            <!--Populate the NormalCashDiscount only if payment term is having discount percentage or payin days -->
                            <xsl:if
                                test="
                                position() = 2
                                and string-length(normalize-space(Discount/DiscountPercent/@percent)) > 0">
                                <NormalCashDiscount>
                                    <Percent>
                                        <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                                    </Percent>
                                    <DaysValue>
                                        <xsl:value-of select="@payInNumberOfDays"/>
                                    </DaysValue>
                                </NormalCashDiscount>
                            </xsl:if>
                            <!--Populate the FullPaymentDueDaysValue only if payment term is having not having discount percentage  -->
                            <xsl:if
                                test="
                                    not(string-length(normalize-space(Discount/DiscountPercent/@percent)) > 0)
                                    or string-length(normalize-space(Discount/DiscountPercent/@percent)) = 0
                                    or string-length(normalize-space(.[Discount/DiscountPercent[@percent = '0.000']]/@payInNumberOfDays)) > 0">
                                <FullPaymentDueDaysValue>
                                    <xsl:value-of select="@payInNumberOfDays"/>
                                </FullPaymentDueDaysValue>
                            </xsl:if>
                        </xsl:for-each>
                    </CashDiscountTerms>
                </xsl:if>                            
                <!-- Price -->
                <Price>
                    <NetAmount>
                        <xsl:attribute name="currencyCode">
                            <xsl:value-of
                                select="substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency,1,3)"
                            />
                        </xsl:attribute>
                        <!-- Begin of IG-35839 XSLT code quality improvement -->
                        <xsl:call-template name="ParseNumber">
                            <xsl:with-param name="p_str"
                                select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/Total/Money"
                            />
                        </xsl:call-template>
                        <!-- End of IG-35839 XSLT code quality improvement -->
                    </NetAmount>
                </Price>
                <!-- Item data -->
                <xsl:for-each select="Payload/cXML/Request/OrderRequest/ItemOut">
                    <Item>
                        <ActionCode>
                            <xsl:value-of select="$v_actionCode"/>
                        </ActionCode>
                        <Product>
                            <xsl:if test="exists(ItemID/SupplierPartID)">
                                <!-- Do not populate if it is Non Catalog item -->
                                <xsl:if test="ItemID/SupplierPartID != 'Non Catalog Item'"> 
                                    <SellerID>
                                        <xsl:value-of select="substring(ItemID/SupplierPartID,1,60)"/>
                                    </SellerID>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(ItemID/BuyerPartID)) > 0">
                                <BuyerID>
                                    <xsl:value-of select="substring(ItemID/BuyerPartID,1,60)"/>
                                </BuyerID>
                            </xsl:if>
                            <PackageQuantity>
                                <xsl:attribute name="unitCode">
                                    <xsl:value-of select="substring(ItemDetail/UnitOfMeasure,1,3)"/>
                                </xsl:attribute>
                                <!-- Begin of IG-35839 XSLT code quality improvement -->
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str" select="@quantity"/>
                                </xsl:call-template>
                                <!-- End of IG-35839 XSLT code quality improvement -->
                            </PackageQuantity>
                        </Product>
                        <Price>
                            <NetAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="substring(ItemDetail/UnitPrice/Money/@currency,1,3)"/>
                                </xsl:attribute>
                                <!-- Begin of IG-35839 XSLT code quality improvement -->
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str"
                                        select="ItemDetail/UnitPrice/Money"
                                    />
                                </xsl:call-template>
                                <!-- End of IG-35839 XSLT code quality improvement -->
                            </NetAmount>
                            <!-- Price Basis Quantity -->
                            <xsl:if
                                test="string-length(normalize-space(ItemDetail/PriceBasisQuantity/@quantity)) > 0">
                                <NetUnitPrice>
                                    <Amount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of
                                                select="substring(ItemDetail/UnitPrice/Money/@currency,1,3)"/>
                                        </xsl:attribute>
                                        <!-- Begin of IG-35839 XSLT code quality improvement -->
                                        <xsl:call-template name="ParseNumber">
                                            <xsl:with-param name="p_str" select="ItemDetail/UnitPrice/Money"/>
                                        </xsl:call-template>
                                        <!-- End of IG-35839 XSLT code quality improvement -->
                                    </Amount>
                                    <BaseQuantity>
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="substring(ItemDetail/PriceBasisQuantity/UnitOfMeasure,1,3)"
                                            />
                                        </xsl:attribute>
                                        <!-- Begin of IG-35839 XSLT code quality improvement -->
                                        <xsl:call-template name="ParseNumber">
                                            <xsl:with-param name="p_str" select="ItemDetail/PriceBasisQuantity/@quantity"/>
                                        </xsl:call-template>
                                        <!-- End of IG-35839 XSLT code quality improvement -->
                                    </BaseQuantity>
                                </NetUnitPrice>
                            </xsl:if>
                        </Price>
                        <!-- ShipTo -->
                        <xsl:if test="exists(ShipTo)">
                            <ProductRecipientParty>
                                <InternalID>
                                    <xsl:attribute name="schemeID">
                                        <xsl:value-of select="'WE'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(ShipTo/Address/@addressID)) > 0">
                                            <xsl:value-of select="substring(ShipTo/Address/@addressID,1,32)"/>
                                        </xsl:when>
                                        <xsl:when test="string-length(normalize-space(ShipTo/IdReference[@domain = 'buyerLocationID']/@identifier)) > 0">
                                            <xsl:value-of select="substring(ShipTo/IdReference[@domain='buyerLocationID']/@identifier,1,32)"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </InternalID>
                                <xsl:call-template name="FillPartyAddress">
                                    <xsl:with-param name="v_path" select="ShipTo"/>
                                </xsl:call-template>
                            </ProductRecipientParty>
                        </xsl:if>
                        <OriginPurchaseOrderReference>
                            <ID>
                                <xsl:value-of select="substring(../OrderRequestHeader/@orderID,1,35)"/>
                            </ID>
                            <ItemID>
                                <xsl:value-of select="substring(@lineNumber,1,10)"/>
                            </ItemID>
                        </OriginPurchaseOrderReference>
                        <!-- Start of IG-29689 Add PO Item description --> 
                        <Description>
                            <xsl:attribute name="languageCode">
                                <xsl:value-of select="substring(ItemDetail/Description/@xml:lang,1,9)"/>
                            </xsl:attribute>
                            <xsl:value-of select="ItemDetail/Description"/>
                        </Description>
                        <!-- End of IG-29689 Add PO Item description -->                                            
                        <xsl:for-each select="ScheduleLine">
                            <ScheduleLine>
                                <ID>
                                    <xsl:value-of select="substring(@lineNumber,1,4)"/>
                                </ID>
                                <DeliveryPeriod>
                                    <StartDateTime>
                                        <xsl:attribute name="timeZoneCode">
                                            <xsl:value-of
                                                select="substring(@requestedDeliveryDate, 20, 25)"/>
                                        </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space($anERPTimeZone)) > 0">
                                                <xsl:variable name="v_DateTime">
                                                  <xsl:value-of
                                                  select="substring(@requestedDeliveryDate, 1, 25)"
                                                  />
                                                </xsl:variable>
                                                <xsl:variable name="v_erpdatetime">
                                                  <xsl:call-template name="ERPDateTime">
                                                  <xsl:with-param name="p_date" select="$v_DateTime"/>
                                                  <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                                  </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:value-of select="$v_erpdatetime"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="concat(substring(@requestedDeliveryDate, 1, 19), 'Z')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </StartDateTime>
                                </DeliveryPeriod>
                                <Quantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:value-of select="substring(UnitOfMeasure,1,3)"/>
                                    </xsl:attribute>
                                    <!-- Begin of IG-35839 XSLT code quality improvement -->
                                    <xsl:call-template name="ParseNumber">
                                        <xsl:with-param name="p_str" select="@quantity"/>
                                    </xsl:call-template>
                                    <!-- End of IG-35839 XSLT code quality improvement -->
                                </Quantity>
                            </ScheduleLine>
                        </xsl:for-each>
                    </Item>
                </xsl:for-each>
            </SalesOrder>
            <xsl:if test="AttachmentList/Attachment">
                <xsl:call-template name="InboundMultiAttProxy_Common">
                    <xsl:with-param name="headerAtt"
                        select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/Comments/Attachment/URL"/>
                    <xsl:with-param name="lineReference" select="
                            Combined/Payload/cXML/Request/OrderRequest/ItemOut/@LineNumber
                            | Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/Comments/Attachment/URL"
                    />
                </xsl:call-template>
            </xsl:if>
            <!--        Header text           -->
            <xsl:for-each
                select="/Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/Comments">
                <AribaComment>
                    <ItemNumber>
                        <xsl:value-of select='""'/>
                    </ItemNumber>
                    <cXMLElementType>
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(Comments/@type)) > 0">
                                <xsl:value-of
                                    select="/Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/Comments/@type"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'SalesHeader'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </cXMLElementType>
                    <Comment>
                        <xsl:attribute name="languageCode">
                            <xsl:value-of select="substring(@xml:lang,1,9)"/>
                        </xsl:attribute>
                        <xsl:variable name="v_comment">
                            <xsl:value-of select="./text()"/>
                        </xsl:variable>
                        <xsl:value-of select="concat(@type,':',normalize-space($v_comment))"/>
                    </Comment>
                </AribaComment>
            </xsl:for-each>
            <!--         Item text             -->
            <xsl:for-each select="/Combined/Payload/cXML/Request/OrderRequest/ItemOut/Comments">
                <AribaComment>
                    <ItemNumber>
                        <xsl:value-of select="substring(../@lineNumber,1,10)"/>
                    </ItemNumber>
                    <cXMLElementType>
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(Comments/@type)) > 0">
                                <xsl:value-of select="Comments/@type"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'SalesItem'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </cXMLElementType>
                    <Comment>
                        <xsl:attribute name="languageCode">
                            <xsl:value-of select="substring(@xml:lang,1,9)"/>
                        </xsl:attribute>
                        <xsl:variable name="v_comment">
                            <xsl:value-of select="./text()"/>
                        </xsl:variable>
                        <xsl:value-of select="concat(@type,':',normalize-space($v_comment))"/>
                    </Comment>
                </AribaComment>
            </xsl:for-each>
            
        </n0:SalesOrderRequest>
    </xsl:template>
    
    <!-- Templates definition starts from here-->
    <xsl:template name="FillPartyAddress">
        <xsl:param name="v_path"/>
        <Address>
            <xsl:if test="string-length(normalize-space($v_path/Address/Name)) > 0">
                <OrganisationFormOfAddress>
                    <Name>
                        <xsl:attribute name="languageCode">
                            <xsl:value-of select="substring($v_path/Address/Name/@xml:lang,1,9)"/>
                        </xsl:attribute>
                        <xsl:value-of select="substring($v_path/Address/Name,1,40)"/>
                    </Name>
                </OrganisationFormOfAddress>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($v_path/Address/PostalAddress)) > 0">
                <PhysicalAddress>
                    <xsl:if test="string-length(normalize-space($v_path/Address/PostalAddress/DeliverTo[1])) > 0">
                        <CareOfName>
                            <xsl:value-of select="substring($v_path/Address/PostalAddress/DeliverTo[1],1,40)"/>
                        </CareOfName>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_path/Address/PostalAddress/State)) > 0">
                        <RegionName>
                            <xsl:value-of select="substring($v_path/Address/PostalAddress/State,1,40)"/>
                        </RegionName>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_path/Address/PostalAddress/Street[1])) > 0">
                        <xsl:variable name="v_street">
                            <xsl:copy-of select="$v_path/Address/PostalAddress/Street"></xsl:copy-of>
                        </xsl:variable> 
                        <StreetName>
                            <xsl:value-of select="substring($v_street,1,60)"/>
                        </StreetName>                        
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_path/Address/PostalAddress/City)) > 0">
                        <CityName>
                            <xsl:value-of select="substring($v_path/Address/PostalAddress/City,1,40)"/>
                        </CityName>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_path/Address/PostalAddress/PostalCode)) > 0">
                        <POBoxPostalCode>
                            <xsl:value-of select="substring($v_path/Address/PostalAddress/PostalCode,1,10)"/>
                        </POBoxPostalCode>
                    </xsl:if>
                    <xsl:if
                        test="string-length(normalize-space($v_path/Address/PostalAddress/Country/@isoCountryCode)) > 0">
                        <CountryCode>
                            <xsl:value-of
                                select="substring($v_path/Address/PostalAddress/Country/@isoCountryCode,1,3)"/>
                        </CountryCode>
                    </xsl:if>
                </PhysicalAddress>
            </xsl:if>
            <!-- Start of IG-29145 : Update communication -->
            <xsl:if test="string-length(normalize-space($v_path/Address)) > 0">
                <!-- End of IG-29145 : Update communication -->
                <Communication>
                    <xsl:if test="string-length(normalize-space($v_path/Address/Phone/TelephoneNumber)) > 0">
                        <Telephone>
                            <Number>
                                <xsl:if
                                    test="string-length(normalize-space($v_path/Address/Phone/TelephoneNumber/CountryCode)) > 0">
                                    <CountryCode>
                                        <xsl:value-of
                                            select="substring($v_path/Address/Phone/TelephoneNumber/CountryCode,1,3)"
                                        />
                                    </CountryCode>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(normalize-space($v_path/Address/Phone/TelephoneNumber/AreaOrCityCode))) > 0">
                                    <AreaID>
                                        <xsl:value-of
                                            select="substring($v_path/Address/Phone/TelephoneNumber/AreaOrCityCode,1,10)"
                                        />
                                    </AreaID>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space($v_path/Address/Phone/TelephoneNumber/Number)) > 0">
                                    <SubscriberID>
                                        <xsl:value-of
                                            select="substring($v_path/Address/Phone/TelephoneNumber/Number,1,30)"/>
                                    </SubscriberID>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space($v_path/Address/Phone/TelephoneNumber/Extension)) > 0">
                                    <ExtensionID>
                                        <xsl:value-of
                                            select="substring($v_path/Address/Phone/TelephoneNumber/Extension,1,10)"
                                        />
                                    </ExtensionID>
                                </xsl:if>
                            </Number>
                        </Telephone>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_path/Address/Fax)) > 0">
                        <Facsimile>
                            <xsl:if test="string-length(normalize-space($v_path/Address/Fax/TelephoneNumber)) > 0">
                                <Number>
                                    <xsl:if
                                        test="string-length(normalize-space($v_path/Address/Fax/TelephoneNumber/CountryCode)) > 0">
                                        <CountryCode>
                                            <xsl:value-of
                                                select="substring($v_path/Address/Fax/TelephoneNumber/CountryCode,1,3)"
                                            />
                                        </CountryCode>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space($v_path/Address/Fax/TelephoneNumber/AreaOrCityCode)) > 0">
                                        <AreaID>
                                            <xsl:value-of
                                                select="substring($v_path/Address/Fax/TelephoneNumber/AreaOrCityCode,1,10)"
                                            />
                                        </AreaID>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space($v_path/Address/Fax/TelephoneNumber/Number)) > 0">
                                        <SubscriberID>
                                            <xsl:value-of
                                                select="substring($v_path/Address/Fax/TelephoneNumber/Number,1,30)"
                                            />
                                        </SubscriberID>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space($v_path/Address/Fax/TelephoneNumber/Extension)) > 0">
                                        <ExtensionID>
                                            <xsl:value-of
                                                select="substring($v_path/Address/Fax/TelephoneNumber/Extension,1,10)"
                                            />
                                        </ExtensionID>
                                    </xsl:if>
                                </Number>
                            </xsl:if>
                        </Facsimile>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_path/Address/Email)) > 0">
                        <Email>
                            <URIDescription>
                                <xsl:attribute name="languageCode">
                                    <xsl:value-of select="substring($v_path/Address/Email/@preferredLang,1,9)"/>
                                </xsl:attribute>
                                <xsl:value-of select="$v_path/Address/Email"/>
                            </URIDescription>
                        </Email>
                    </xsl:if>
                </Communication>
            </xsl:if>
        </Address>
    </xsl:template>
    <!-- Begin of IG-35839 XSLT code quality improvement -->
    <!--User Define Templates for ParseNumber-->
    <xsl:template name="ParseNumber">
        <xsl:param name="p_str"/>
        <xsl:if test="string-length(normalize-space($p_str)) > 0">
            <xsl:value-of select="translate(translate(translate(translate($p_str, ',', ''), 'USD', ''), '$', ''), '-', '')"/>
        </xsl:if>
    </xsl:template>
    <!-- End of IG-35839 XSLT code quality improvement -->
</xsl:stylesheet>
