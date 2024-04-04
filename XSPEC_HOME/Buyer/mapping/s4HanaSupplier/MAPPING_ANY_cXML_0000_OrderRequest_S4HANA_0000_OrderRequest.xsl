<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:n0="http://sap.com/xi/EDI"  xmlns:xop="http://www.w3.org/2004/08/xop/include" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
<!--<xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anAlternativeSender"/>
    <xsl:param name="cXMLAttachments"/>
    <xsl:template match="Combined">
        <xsl:variable name="v_lang">
            <xsl:choose>
                <xsl:when test="string-length(Payload/cXML/Request/OrderRequest/ItemOut[1]/ItemDetail[1]/Description/@xml:lang) > 0">
                    <xsl:value-of select="Payload/cXML/Request/OrderRequest/ItemOut[1]/ItemDetail[1]/Description/@xml:lang"/>
                </xsl:when>              
                    <xsl:when test="string-length(Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/Name/@xml:lang) > 0">
                        <xsl:value-of select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/Name/@xml:lang"/>
                    </xsl:when>                   
                <xsl:otherwise>
                <xsl:value-of select="'EN'"/>
                </xsl:otherwise>
            </xsl:choose>                     
        </xsl:variable>
        <n0:OrderRequest>
            <MessageHeader>
                <ID>
                    <xsl:value-of select="substring(Payload/cXML/@payloadID, 1, 35)"/>
                </ID>
                <!-- Defect:23539 For the Hybrid Scenario, cXML datetimeStamp will have an issue during update scenario, so mapping this to current datetimestamp-->
                <CreationDateTime>
                    <xsl:value-of select="current-dateTime()"/>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="'ARIBA_NETWORK'"/>
                </SenderBusinessSystemID>
                <!--This is mandatory and needed all the time-->
                <xsl:if test="not(starts-with($anAlternativeSender , 'AN'))">
                <SenderParty>
                    <InternalID>
                        <xsl:value-of select="$anAlternativeSender"/>
                    </InternalID>
                </SenderParty>
                </xsl:if>
            </MessageHeader>
            <Order>
                <!--CI-1880 add Buyer and Supplier System ID-->
                <xsl:if test="string-length(normalize-space(Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity)) > 0">
                    <BuyerSystemID>
                        <xsl:value-of select="Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity"/>
                    </BuyerSystemID>                    
                </xsl:if>
                <!-- Begin of CI-2921 XSLT Enhancement-->
                <!-- Repalce 'NetworkId' with 'NetworkID' -->
                <xsl:if test="string-length(normalize-space(Payload/cXML/Header/To/Credential[@domain = 'NetworkID']/Identity)) > 0">
                    <SupplierSystemID>
                        <xsl:value-of select="Payload/cXML/Header/To/Credential[@domain = 'NetworkID']/Identity"/>
                    </SupplierSystemID>                    
                </xsl:if> 
                <!-- End of CI-2921 XSLT Enhancement-->
                <!--    CI-1880     -->
                <PurchaseOrderID>
                    <xsl:value-of select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderID"/>
                </PurchaseOrderID>
                <!--CompanyCode-->
                <xsl:if
                    test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier)) > 0">
                    <CompanyCode>
                        <xsl:value-of
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/@identifier"
                        />
                    </CompanyCode>
                </xsl:if>
                <xsl:if
                    test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/Description)) > 0">
                    <CompanyCodeName>
                        <xsl:value-of
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/LegalEntity/IdReference[@domain = 'CompanyCode']/Description"
                        />
                    </CompanyCodeName>
                </xsl:if>
                <!--PurchasingOrganization-->
                <xsl:if
                    test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier)) > 0">
                    <PurchasingOrganization>
                        <xsl:value-of
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/@identifier"
                        />
                    </PurchasingOrganization>
                </xsl:if>
                <xsl:if
                    test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/Description)) > 0">
                    <PurchasingOrganizationName>
                        <xsl:value-of
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingOrganization']/Description"
                        />
                    </PurchasingOrganizationName>
                </xsl:if>
                <!--PurchasingGroup-->
                <xsl:if
                    test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier)) > 0">
                    <PurchasingGroup>
                        <xsl:value-of
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/@identifier"
                        />
                    </PurchasingGroup>
                </xsl:if>
                <xsl:if
                    test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/Description)) > 0">
                    <PurchasingGroupName>
                        <xsl:value-of
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain = 'PurchasingGroup']/Description"
                        />
                    </PurchasingGroupName>
                </xsl:if>
                <PurchaseOrderCreationDate>
                    <xsl:value-of
                        select="
                            concat(substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 1, 4),
                            '-', substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 6, 2),
                            '-', substring(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 9, 2))"
                    />
                </PurchaseOrderCreationDate>
                <TransactionCurrency>
                    <xsl:value-of select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
                </TransactionCurrency>
                <!-- Begin of CI-2921 XSLT Enhancement-->
                <!-- Create Buyer VAT Registration number if 'buyerVatID' exists -->
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'buyerVatID'])) > 0">
                    <BuyerVATRegistration>
                        <xsl:value-of select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'buyerVatID']"/>
                    </BuyerVATRegistration>                    
                </xsl:if> 
                <!-- End of CI-2921 XSLT Enhancement-->
                <!-- CI-1730 Buyer external reference -->                
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'OurReference']/@identifier)) > 0">
                    <BuyrCorrOwnReference>                        
                        <xsl:value-of select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'OurReference']/@identifier"/>
                    </BuyrCorrOwnReference>
                </xsl:if>
                <!-- /CI-1730 -->                
                <!-- CI-1730 Buyer own reference -->                
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID)) > 0">
                    <BuyrCorrExternalReference>
                        <xsl:value-of select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID"/>
                    </BuyrCorrExternalReference>
                </xsl:if>
                <!-- /CI-1730 -->
                <xsl:if test="exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo)
                    and string-length(Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID) > 0">
                    <!--                Party Function Data                    -->
                    <Party>
                        <xsl:attribute name="PartyType">
                            <xsl:value-of select="'ShipTo'"/>
                        </xsl:attribute>
                        <xsl:call-template name="FillParty">
                            <xsl:with-param name="p_path"
                                select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"/>
                        </xsl:call-template>
                    </Party>
                </xsl:if>
                <!--                Billto would not work as confirmed by S4C EDI Team-->
                <xsl:if test="exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo)
                    and string-length(Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/@addressID) > 0">
                    <Party>
                        <xsl:attribute name="PartyType">
                            <xsl:value-of select="'BillTo'"/>
                        </xsl:attribute>
                        <xsl:call-template name="FillParty">
                            <xsl:with-param name="p_path"
                                select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/BillTo"/>
                        </xsl:call-template>
                    </Party>
                </xsl:if>
                <!--Fill SoldTo                    -->
                <Party>
                    <xsl:attribute name="PartyType">
                        <xsl:value-of select="'SoldTo'"/>
                    </xsl:attribute>                   
                    <xsl:call-template name="FillParty">
                        <xsl:with-param name="p_path" select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/BusinessPartner[@role = 'soldTo']"/>
                        <xsl:with-param name="p_anAlternativeSender" select="$anAlternativeSender"/>
                    </xsl:call-template>                        
                </Party>
                <!-- Begin of CI-2921 XSLT Enhancement-->
                <!-- Add new Party node for party type 'Payer' from role 'payer'  -->
                <xsl:if test="exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'payer'])">
                    <Party>
                        <xsl:attribute name="PartyType">
                            <xsl:value-of select="'Payer'"/>
                        </xsl:attribute>                   
                        <xsl:call-template name="FillParty">
                            <xsl:with-param name="p_path" select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'payer']"/>
                        </xsl:call-template>                        
                    </Party>
                </xsl:if>
                <!-- Repalce Party node for Supplier to role 'supplierCorporate'  -->
                <xsl:if test="exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate'])">
                    <Party>
                        <xsl:attribute name="PartyType">
                            <xsl:value-of select="'Supplier'"/>
                        </xsl:attribute>                   
                        <xsl:call-template name="FillParty">
                            <xsl:with-param name="p_path" select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']"/>
                        </xsl:call-template>                        
                    </Party>
                </xsl:if>
                <!-- End of CI-2921 XSLT Enhancement-->                               
                <xsl:if
                    test="
                        exists(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate)
                        and string-length(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate) > 0">
                    <RequestedDeliveryDate>
                        <xsl:value-of
                            select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate"/>
                    </RequestedDeliveryDate>
                </xsl:if>
                <!-- Begin of CI-2921 XSLT Enhancement-->
                <!-- Create Node CompleteDeliveryIsDefined as 'true' if @shipComplete is 'yes' at header -->
                <xsl:if test="(Payload/cXML/Request/OrderRequest/OrderRequestHeader/@shipComplete) = 'yes'">
                    <CompleteDeliveryIsDefined>
                        <xsl:value-of select="'true'"/>
                    </CompleteDeliveryIsDefined>
                </xsl:if>
                <!-- End of CI-2921 XSLT Enhancement-->
                <xsl:if test="string-length(Payload/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery) > 0">
                    <HeaderIncoterms>
                        <IncotermsClassification>
                            <xsl:value-of
                                select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value"
                            />
                        </IncotermsClassification>
                        <IncotermsLocation1>
                            <xsl:value-of
                                select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/Name"/>
                        </IncotermsLocation1>
                    </HeaderIncoterms>                   
                </xsl:if>
                <PaymentTerms>
                    <!-- Start IG-24714 and IG-23933 having different percent formats in hybrid scenarios -->
                    <xsl:for-each select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[Discount/DiscountPercent/@percent > 0]">
                        <xsl:variable name="v_Counter" select="position()"/>
                        <xsl:choose>
                            <xsl:when test="$v_Counter = 1">
                                <CashDiscount1Percent>
                                    <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                                </CashDiscount1Percent>
                                <CashDiscount1Days>
                                    <xsl:value-of select="@payInNumberOfDays"/>
                                </CashDiscount1Days>
                            </xsl:when>
                            <xsl:when test="$v_Counter = 2">
                                <CashDiscount2Percent>
                                    <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                                </CashDiscount2Percent>
                                <CashDiscount2Days>
                                    <xsl:value-of select="@payInNumberOfDays"/>
                                </CashDiscount2Days>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:variable name="v_NetDays">
                        <xsl:value-of select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[not(Discount/DiscountPercent/@percent) or 
                            (Discount/DiscountPercent/@percent) = '0' or (Discount/DiscountPercent/@percent) = '0.000']/@payInNumberOfDays"/>       
                    </xsl:variable>
                    <!-- End IG-24714 and IG-23933 -->
                    <xsl:if test="string-length($v_NetDays) > 0">
                        <NetPaymentDays>
                            <xsl:value-of select="$v_NetDays"/>
                        </NetPaymentDays>                           
                    </xsl:if>                 
                </PaymentTerms>
                <!--  CI-2099 Multiple Header Text -->
                <xsl:for-each select="Payload/cXML/Request/OrderRequest/OrderRequestHeader/Comments">
                    <xsl:if test="string-length(normalize-space(.)) > 0">
                        <Text>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(@type)) > 0">
                                    <xsl:attribute name="Type">
                                        <xsl:value-of select="@type"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <!-- Start of IG-36387 Add SalesNote when text type is blank-->
                                <xsl:otherwise>
                                    <xsl:attribute name="Type">
                                        <xsl:value-of select="'SalesNote'"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- End of IG-36387 Add SalesNote when text type is blank-->
                            <TextElementLanguage>
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(@xml:lang)) > 0">
                                        <xsl:value-of select="@xml:lang"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$v_lang"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </TextElementLanguage>
                            <TextElementText>
                                <xsl:value-of select="."/>
                            </TextElementText>
                        </Text>
                    </xsl:if>
                </xsl:for-each>
                <!--  /CI-2099  -->
                <xsl:for-each select="Payload/cXML/Request/OrderRequest/ItemOut">
                    <OrderItem>
                        <xsl:if test="../OrderRequestHeader/@type = 'delete'">
                            <ActionCode>03</ActionCode>
                        </xsl:if>                
                        <PurchaseOrderItemID>
                            <xsl:value-of select="@lineNumber"/>
                        </PurchaseOrderItemID>
                        <!-- Begin of CI-2643 Hierarchy Line Item fields -->
                        <!-- BlanketItemDetail will be populated when for item set else ItemDetails will be populated in cXML -->
                        <xsl:if test="string-length(normalize-space(ItemDetail/Extrinsic[@name='hierarchyLineNumber'])) > 0 or string-length(normalize-space(BlanketItemDetail/Extrinsic[@name='hierarchyLineNumber'])) > 0"> 
                            <PurgConfigurableItemNumber>                              
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(ItemDetail/Extrinsic[@name='hierarchyLineNumber'])) > 0">
                                        <xsl:value-of select="substring(ItemDetail/Extrinsic[@name='hierarchyLineNumber'],1,40)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="string-length(normalize-space(BlanketItemDetail/Extrinsic[@name='hierarchyLineNumber'])) > 0">
                                            <xsl:value-of select="substring(BlanketItemDetail/Extrinsic[@name='hierarchyLineNumber'],1,40)"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </PurgConfigurableItemNumber>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(@parentLineNumber)) > 0"> 
                            <PurchasingParentItem>        
                                <xsl:value-of select="substring(@parentLineNumber,1,5)"/>
                            </PurchasingParentItem>
                        </xsl:if>
                        <PurchasingIsItemSet>
                            <xsl:if test="string-length(normalize-space(@itemType)) > 0"> 
                                <xsl:choose>
                                    <xsl:when test="@itemType = 'composite'">
                                        <xsl:value-of select="'true'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- @parentLineNumber will be populated in case of hierarchies but not item set-->
                                        <xsl:if test="string-length(normalize-space(@parentLineNumber)) > 0">
                                            <xsl:value-of select="'false'"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </PurchasingIsItemSet>
                        <xsl:if test="string-length(normalize-space(ItemDetail/Extrinsic[@name='extLineNumber'])) > 0 or string-length(normalize-space(BlanketItemDetail/Extrinsic[@name='extLineNumber'])) > 0"> 
                            <PurgExternalSortNumber>
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(BlanketItemDetail/Extrinsic[@name='extLineNumber'])) > 0">
                                        <xsl:value-of select="substring(BlanketItemDetail/Extrinsic[@name='extLineNumber'],1,5)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="string-length(normalize-space(ItemDetail/Extrinsic[@name='extLineNumber'])) > 0">
                                            <xsl:value-of select="substring(ItemDetail/Extrinsic[@name='extLineNumber'],1,5)"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </PurgExternalSortNumber>
                        </xsl:if>
                        <!-- End of CI-2643 Hierarchy Line Item fields -->                        
                        <!-- Begin of CI-2921 XSLT Enhancement-->
                        <!-- Create OrderItemText node if item description exists -->
                        <xsl:if test="string-length(normalize-space(ItemDetail/Description)) > 0"> 
                            <OrderItemText>
                                <xsl:value-of select="substring(ItemDetail/Description,1,80)"/>
                            </OrderItemText>
                        </xsl:if>
                        <!-- End of CI-2921 XSLT Enhancement-->
                        <RequestedQuantity>
                            <!-- Begin of CI-2921 XSLT Enhancement-->
                            <!-- Create attribute unitCode is UOM exists -->
                            <xsl:if test="string-length(normalize-space(ItemDetail/UnitOfMeasure)) > 0">
                                <xsl:attribute name="unitCode">
                                    <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                                </xsl:attribute>
                            </xsl:if>
                            <!-- End of CI-2921 XSLT Enhancement-->
                            <xsl:value-of select="@quantity"/>
                        </RequestedQuantity>
                        <Product>
                            <!-- Begin of CI-2921 XSLT Enhancement-->
                            <!-- create new node GlobalTradeItemNumber if EANID exists or EAN-13 identifier exists at line item level -->
                            <xsl:if test="string-length(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)) > 0 or string-length(normalize-space(IdReference[@domain = 'EAN-13']/@identifier)) > 0">
                                <GlobalTradeItemNumber>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)) > 0">
                                            <xsl:value-of select="ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="IdReference[@domain = 'EAN-13']/@identifier"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </GlobalTradeItemNumber>
                            </xsl:if>
                            <!-- End of CI-2921 XSLT Enhancement-->
                            <BuyerProductID>
                                <xsl:value-of select="upper-case(ItemID/BuyerPartID)"/>
                            </BuyerProductID>
                            <!--Default value mapped on 42K when there is no SupplierProdID is Non-Catalog-Item-->
                            <!--We know this is an invalid Material and hence dont map , since this when mapped-->
                            <!--takes precedence over BuyerProductID and results in error-->
                            <xsl:if test="ItemID/SupplierPartID != 'Non-Catalog-Item'">
                                <SupplierProductID>
                                    <xsl:value-of select="ItemID/SupplierPartID"/>
                                </SupplierProductID>
                            </xsl:if>
                        </Product>
                        <xsl:if test="string-length(ItemDetail/PriceBasisQuantity/@quantity) > 0">
                            <ExpectedNetPrice>
                                <Amount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="ItemDetail/UnitPrice/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="ItemDetail/UnitPrice/Money"/>
                                </Amount>
                                <xsl:if test="string-length(ItemDetail/PriceBasisQuantity/@quantity) > 0">
                                    <BaseQuantity>
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of select="ItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="ItemDetail/PriceBasisQuantity/@quantity"/>
                                    </BaseQuantity>
                                </xsl:if>
                            </ExpectedNetPrice>
                        </xsl:if>  
                        <xsl:if test="string-length(ShipTo/Address/@addressID) > 0">                   
                            <!--                Party Function Data                    -->
                            <Party>
                                <xsl:attribute name="PartyType">
                                    <xsl:value-of select="'ShipTo'"/>
                                </xsl:attribute>
                                <xsl:call-template name="FillParty">
                                    <xsl:with-param name="p_path"
                                        select="ShipTo"/>
                                </xsl:call-template>
                            </Party>
                        </xsl:if>                        
                        <!-- Begin of CI-2921 XSLT Enhancement-->
                        <!-- Create ItemIncoterms -->
                        <ItemIncoterms>
                            <IncotermsClassification>
                                <xsl:value-of select="TermsOfDelivery/TransportTerms/@value"/>
                            </IncotermsClassification>
                            <IncotermsLocation1>
                                <xsl:value-of select="TermsOfDelivery/Address/Name"/>
                            </IncotermsLocation1>
                        </ItemIncoterms>
                        <!-- End of CI-2921 XSLT Enhancement-->
                        <!--  CI-2099 Multiple Line Item Text -->
                        <xsl:for-each select="Comments">
                            <xsl:if test="string-length(normalize-space(.)) > 0">
                                <Text>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(@type)) > 0">
                                            <xsl:attribute name="Type">
                                                <xsl:value-of select="@type"/>
                                            </xsl:attribute>
                                        </xsl:when>
                                        <!-- Start of IG-36387 Add MaterialText when text type is blank-->  
                                        <xsl:otherwise>
                                            <xsl:attribute name="Type">
                                                <xsl:value-of select="'MaterialText'"/>
                                            </xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <!-- End of IG-36387 Add MaterialText when text type is blank-->   
                                    <TextElementLanguage>
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(@xml:lang)) > 0">
                                                <xsl:value-of select="@xml:lang"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$v_lang"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </TextElementLanguage>
                                    <TextElementText>
                                        <xsl:value-of select="."/>
                                    </TextElementText>
                                </Text>
                            </xsl:if>
                        </xsl:for-each>
                        <!--  /CI-2099  -->
                        <xsl:for-each select="ScheduleLine">
                            <ScheduleLine>
                                <RequestedDeliveryDate>
                                    <xsl:value-of select="substring(@requestedDeliveryDate, 1, 10)"/>
                                </RequestedDeliveryDate>
                                <xsl:if test="string-length(substring(@requestedDeliveryDate, 12, 8)) > 0">
                                    <RequestedDeliveryTime>
                                        <xsl:value-of select="substring(@requestedDeliveryDate, 12, 8)"/>
                                    </RequestedDeliveryTime>
                                </xsl:if>
                                <ScheduleLineOrderQuantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:value-of select="UnitOfMeasure"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@quantity"/>
                                </ScheduleLineOrderQuantity>
                            </ScheduleLine>
                        </xsl:for-each>
                    </OrderItem>
                </xsl:for-each>         
                <!--               Attachments Processing for 2008 release.
                   Only Header Level Attachments -->
                <xsl:if test="string-length($cXMLAttachments) > 0">
                    <xsl:variable name = "HeaderAttachmentList" select="$cXMLAttachments"/>
                    <xsl:call-template name="InboundS4Attachment">
                        <xsl:with-param name="AttachmentList">
                            <xsl:value-of select="$HeaderAttachmentList"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </Order>
        </n0:OrderRequest>
    </xsl:template>
</xsl:stylesheet>
