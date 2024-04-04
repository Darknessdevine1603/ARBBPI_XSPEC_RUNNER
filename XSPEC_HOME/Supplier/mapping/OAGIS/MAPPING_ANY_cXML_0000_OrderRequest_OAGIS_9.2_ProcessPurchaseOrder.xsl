<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    <!-- Local testing-->
    <!--xsl:include href="Format_CXML_OAGIS_common.xsl"/>
    <xsl:variable name="Lookups" select="document('Lookups_OAGIS.xml')"/-->
    <!-- PD Entries-->
    <xsl:include href="FORMAT_cXML_0000_OAGIS_9.2.xsl"/>
    <xsl:variable name="Lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_OAGIS_9.2.xml')"/>
    
    <xsl:param name="anAlternativeSender"/>
    <xsl:param name="anAlternativeReceiver"/>
    <xsl:param name="releaseID" select="'9.2'"/>
    <xsl:param name="anCRFlag"/>
    <xsl:template match="/">
        <xsl:variable name="currentdatetime" select="current-dateTime()"/>
        <xsl:variable name="isChange" select="cXML/Request/OrderRequest/OrderRequestHeader/@type"/>
        <ProcessPurchaseOrder>
            <xsl:attribute name="releaseID">
                <xsl:value-of select="$releaseID"/>
            </xsl:attribute>
            <ApplicationArea>
                <Sender>
                    <LogicalID>
                        <xsl:value-of select="$anAlternativeSender"/>
                    </LogicalID>
                    <ComponentID>
                        <xsl:choose>
                            <xsl:when test="($isChange = 'update' or $isChange = 'delete') and $anCRFlag = 'Yes'">
                                <xsl:text>CopyUpdatePO</xsl:text>
                            </xsl:when>
                            <xsl:when test="$isChange = 'update' or $isChange = 'delete'">
                                <xsl:text>UpdatePO</xsl:text>
                            </xsl:when>
                            <xsl:when test="$anCRFlag = 'Yes'">
                                <xsl:text>CopyPO</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>PO</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </ComponentID>
                    <TaskID>
                        <xsl:choose>
                            <xsl:when test="($isChange = 'update' or $isChange = 'delete') and cXML/Header/To/UserAgent = 'Copy'">
                                <xsl:text>CopyChangePurchaseOrder</xsl:text>
                            </xsl:when>
                            <xsl:when test="$isChange = 'update' or $isChange = 'delete'">
                                <xsl:text>ChangePurchaseOrder</xsl:text>
                            </xsl:when>
                            <xsl:when test="cXML/Header/To/UserAgent = 'Copy'">
                                <xsl:text>CopyPurchaseOrder</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>PurchaseOrder</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </TaskID>
                    <ReferenceID>MS</ReferenceID>
                </Sender>
                <CreationDateTime>
                    <xsl:value-of select="cXML/@timestamp"/>
                </CreationDateTime>
                <BODID>
                    <xsl:value-of select="cXML/@payloadID"/>
                </BODID>
                <UserArea>
                    <DUNSID schemeID="ReceiverKey">
                        <xsl:value-of select="$anAlternativeReceiver"/>
                    </DUNSID>
                </UserArea>
            </ApplicationArea>
            <DataArea>
                <Process>
                    <ActionCriteria>
                        <xsl:choose>
                            <xsl:when test="$isChange = 'update'">
                                <ActionExpression actionCode="Add">Change</ActionExpression>
                            </xsl:when>
                            <xsl:when test="$isChange = 'delete'">
                                <ActionExpression actionCode="Add">Delete</ActionExpression>
                            </xsl:when>
                            <xsl:otherwise>
                                <ActionExpression actionCode="Add">Create</ActionExpression>
                            </xsl:otherwise>
                        </xsl:choose>
                        <ChangeStatus>
                            <Code name="OrderVersion">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion"/>
                            </Code>
                            <Description type="Priority">Normal</Description>
                        </ChangeStatus>
                    </ActionCriteria>
                </Process>
                <PurchaseOrder>
                    <PurchaseOrderHeader>
                        <DocumentReference>
                            <DocumentID agencyRole="Purchase Order">
                                <ID>
                                    <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderID"/>
                                </ID>
                            </DocumentID>
                            <Description type="Action">Request</Description>
                            <Status>
                                <Code name="DateType">PODate</Code>
                                <EffectiveDateTime>
                                    <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderDate"/>
                                </EffectiveDateTime>
                            </Status>
                            <LineNumber schemeName="DocumentLineNumber">NA</LineNumber>
                            <OperationReference>
                                <Status>
                                    <Code name="OrderType">
                                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType']"/>
                                    </Code>
                                </Status>
                                <Status>
                                    <Code name="Class">
                                        <xsl:choose>
                                            <xsl:when
                                                test="cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID != ''"
                                                >DR</xsl:when>
                                            <xsl:when
                                                test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'Z4XA' or cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'X4XB' or cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'Z4XT'"
                                                >CN</xsl:when>
                                            <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'Z4UB'">RL</xsl:when>
                                            <xsl:otherwise>SS</xsl:otherwise>
                                        </xsl:choose>
                                    </Code>
                                    <!--Internal Document type code. Should we do a lookup?-->
                                </Status>
                                <Status>
                                    <Code name="CountryOfOrigin"/>
                                </Status>
                            </OperationReference>
                            <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Comments/text() != ''">
                                <Item>
                                    <Specification type="HeaderText">
                                        <UserArea>
                                            <Status>
                                                <Code name="TextTypeCode">HeaderComments</Code>
                                                <Description type="TextDetail">
                                                    <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Comments/text()"/>
                                                </Description>
                                            </Status>
                                        </UserArea>
                                    </Specification>
                                </Item>
                            </xsl:if>
                        </DocumentReference>
                        <Party role="SAPVendor">
                            <xsl:call-template name="CreateParty">
                                <xsl:with-param name="PartyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']"/>
                                <xsl:with-param name="IDInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/@addressID"/>
                            </xsl:call-template>
                        </Party>
                        <CustomerParty>
                            <xsl:call-template name="CreateParty">
                                <xsl:with-param name="PartyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'soldTo']"/>
                                <xsl:with-param name="IDInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'soldTo']/@addressID"/>
                            </xsl:call-template>
                        </CustomerParty>
                        <SupplierParty>
                            <xsl:call-template name="CreateParty">
                                <xsl:with-param name="PartyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']"/>
                                <xsl:with-param name="IDInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/@addressID"/>
                            </xsl:call-template>
                        </SupplierParty>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo and cXML/Request/OrderRequest/OrderRequestHeader/ShipTo != ''">
                            <ShipToParty>
                                <xsl:call-template name="CreateParty">
                                    <xsl:with-param name="PartyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
                                    <xsl:with-param name="IDInfo"
                                        select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address[@addressIDDomain = 'buyerLocationID' or @addressIDDomain = 'customerLocationID' or @addressIDDomain = 'vendorLocationID']/@addressID"
                                    />
                                </xsl:call-template>
                                <UserArea>
                                    <Status>
                                        <Code name="TransportationZone">
                                            <xsl:value-of
                                                select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/IdReference[@domain = 'transportationZone']/@identifier"/>
                                        </Code>
                                    </Status>
                                    <Status>
                                        <Code name="cRADCRSDIndicator">
                                            <xsl:value-of
                                                select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/IdReference[@domain = 'cRADCRSDIndicator']/@identifier"/>
                                        </Code>
                                    </Status>
                                </UserArea>
                            </ShipToParty>
                        </xsl:if>
                        <BillToParty>
                            <xsl:call-template name="CreateParty">
                                <xsl:with-param name="PartyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address"/>
                                <xsl:with-param name="IDInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/@addressID"/>
                            </xsl:call-template>
                        </BillToParty>
                        <CarrierParty>
                            <xsl:call-template name="CreateParty">
                                <xsl:with-param name="PartyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'cargoDelivery']"/>
                                <xsl:with-param name="IDInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'cargoDelivery']/@addressID"/>
                            </xsl:call-template>
                        </CarrierParty>
                        <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm">
                            <PaymentTerm>
                                <Term>
                                    <ID>
                                        <xsl:value-of select="@payInNumberOfDays"/>
                                    </ID>
                                    <DiscountPercent>
                                        <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                                    </DiscountPercent>
                                </Term>
                            </PaymentTerm>
                        </xsl:for-each>
                        <Payment>
                            <Amount>
                                <xsl:attribute name="currencyID">
                                    <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money"/>
                            </Amount>
                            <UserArea>
                                <Type name="PriceType">POTotal</Type>
                            </UserArea>
                        </Payment>
                        <OrderDateTime>
                            <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderDate"/>
                        </OrderDateTime>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'purchasingAgent']">
                            <BuyerParty>
                                <xsl:call-template name="CreateParty">
                                    <xsl:with-param name="PartyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'purchasingAgent']"/>
                                    <xsl:with-param name="IDInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role = 'supplierCorporate']/@addressID"/>
                                </xsl:call-template>
                            </BuyerParty>
                        </xsl:if>
                        <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo">
                            <SalesOrderReference>
                                <DocumentID>
                                    <xsl:attribute name="agencyRole">
                                        <xsl:value-of select="DocumentInfo/@documentType"/>
                                    </xsl:attribute>
                                    <ID>
                                        <xsl:value-of select="DocumentInfo/@documentID"/>
                                    </ID>
                                </DocumentID>
                                <Description type="OrderType">
                                    <xsl:value-of select="Extrinsic[@name = 'customerOrderNo']"/>
                                </Description>
                                <xsl:if test="Extrinsic[@name = 'deliveryNoteNumber'] != ''">
                                    <Status>
                                        <Description type="DeliveryCompletionIndicator">
                                            <xsl:value-of select="Extrinsic[@name = 'deliveryNoteNumber']"/>
                                        </Description>
                                    </Status>
                                </xsl:if>
                                <xsl:if test="Extrinsic[@name = 'taxRegistrationNumber'] != ''">
                                    <Status>
                                        <Description type="CustomerVATID">
                                            <xsl:value-of select="Extrinsic[@name = 'taxRegistrationNumber']"/>
                                        </Description>
                                    </Status>
                                </xsl:if>
                                <xsl:if test="Extrinsic[@name = 'customerReferenceNo'] != ''">
                                    <Status>
                                        <Description type="OrderCombinationFlag">
                                            <xsl:value-of select="Extrinsic[@name = 'customerReferenceNo']"/>
                                        </Description>
                                    </Status>
                                </xsl:if>
                                <xsl:if test="Extrinsic[@name = 'incoTerm'] != '' or Extrinsic[@name = 'incoTermDesc'] != ''">
                                    <UserArea>
                                        <IncotermsCode>
                                            <xsl:value-of select="Extrinsic[@name = 'incoTerm']"/>
                                        </IncotermsCode>
                                        <Description type="IncoTermsDescription">
                                            <xsl:value-of select="Extrinsic[@name = 'incoTermDesc']"/>
                                        </Description>
                                    </UserArea>
                                </xsl:if>
                            </SalesOrderReference>
                        </xsl:for-each>
                    </PurchaseOrderHeader>
                    <xsl:for-each select="cXML/Request/OrderRequest/ItemOut">
                        <PurchaseOrderLine>
                            <xsl:call-template name="createlineitemPO">
                                <xsl:with-param name="item" select="."/>
                            </xsl:call-template>
                        </PurchaseOrderLine>
                    </xsl:for-each>
                </PurchaseOrder>
            </DataArea>
        </ProcessPurchaseOrder>
    </xsl:template>
</xsl:stylesheet>
