<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anERPName"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anAddOnCIVersion"/>
<!--    <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="Combined">
<!--If Multi ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
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
<!--Get the IsLogicalSystemEnabled details-->
    <xsl:variable name="v_LsEnabled">
        <!--Call Template for IsLogicalSystemEnabled-->
        <xsl:call-template name="LogicalSystemEnabled">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
<!--Check if the Taxes are given at Line Level-->
    <xsl:variable name="v_isTaxInLine" select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isTaxInLine"/>
<!--Check if the Invoice is FI or Consignment-->
    <xsl:variable name="v_isConsWithdrawalInvoice">
        <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/ProductMovementItemIDInfo)">
            <xsl:value-of select="'yes'"/>
        </xsl:if>
    </xsl:variable>
<!--Check if the Discount is given in Line-->
    <xsl:variable name="v_isDiscountInLine" select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isDiscountInLine"/>
<!--Default Language is read from the cross reference parameter-->
    <xsl:variable name="v_default_lang">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
<!--If Cross refernce is not maintained default the language to english-->
    <xsl:variable name="v_default_lang">
        <xsl:if test="string-length($v_default_lang) = 0">
            <xsl:value-of select="'en'"/>
        </xsl:if>
    </xsl:variable>
    <xsl:variable name="v_htextId">
        <xsl:value-of select="$v_pd/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/HeaderTextID"/>
    </xsl:variable>
    <xsl:variable name="v_contact_path" select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact"/>
    <xsl:variable name="v_vendor_id" select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"/>
        <n0:InvoiceERPRequest>
            <!--Map Message Header Details-->
            <MessageHeader>
                <ID>
                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceID"/>
                </ID>
                <AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of select="Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity"/>
                </AribaNetworkID>
                <!--Convert the Invoice Date into ERP System TimeZone relevant date-->
                <CreationDateTime>
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date"
                                select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="$v_erpdate"/>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="Payload/cXML/Header/From/Credential[@domain = 'NetworkID']/Identity"/>
                </SenderBusinessSystemID>
                <!--If Logical System is enabled, pass the logical system or pass the vendor details-->
                <RecipientBusinessSystemID>
                    <xsl:value-of select="$v_sysid"/>
                </RecipientBusinessSystemID>
            </MessageHeader>
            <!--Map Invoice Details-->
            <Invoice>
                <xsl:attribute name="actionCode">
                    <!--Hardcode to 1 since we only support creation-->
                    <xsl:value-of select="'01'"/>
                </xsl:attribute>
                <!--Limitation ;- This InvoiceID should not be more than 35 characters-->
                <ID>
                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceID"/>
                </ID>
                <CompanyID>
                    <xsl:if test="exists($v_contact_path[@role = 'billTo']/@addressID)">
                        <xsl:value-of select="$v_contact_path[@role = 'billTo']/@addressID"/>
                    </xsl:if>
                </CompanyID>
                <TypeCode>
                    <!--Use this to identify FI/Cons.With. Invoice-->
                    <xsl:choose>
                        <xsl:when test="string-length($v_isConsWithdrawalInvoice) > 0">
                            <xsl:value-of select="'CONS'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'FI'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </TypeCode>
                <ProcessingTypeCode>
                    <!--*Consume as it is and raise exceptions in ABAP - trigger reject Sur for anyother processing type 
                        apart from LineLevelCreditMemo , CreditMemo and standard.-->
                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose"/>
                </ProcessingTypeCode>
                <IssueDate>
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date"
                                select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="substring($v_erpdate,0,11)"/>
                </IssueDate>
                <xsl:variable name="v_masterAgreement" 
                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/MasterAgreementIDInfo/@agreementID"/>
                <xsl:variable name="v_orderId"
                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/OrderIDInfo/@orderID"/>
                <xsl:variable name="v_supplierOrder"
                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderID"/>
                <!--Map Order/Reference Details-->
                <xsl:if test="string-length($v_masterAgreement) > 0 or string-length($v_orderId) > 0 or string-length($v_supplierOrder) > 0">
                    <OrderInfo>
                        <xsl:if test="string-length($v_masterAgreement) > 0">
                            <CustomerOrder>
                                <xsl:value-of select="$v_masterAgreement"/>
                            </CustomerOrder>
                        </xsl:if>   
                        <xsl:if test="string-length($v_supplierOrder) > 0">
                            <SalesOrder>
                                <xsl:value-of select="$v_supplierOrder"/>
                            </SalesOrder>
                        </xsl:if> 
                        <xsl:if test="string-length($v_orderId) > 0">
                            <ContractNumber>
                                <xsl:value-of select="$v_orderId"/>
                            </ContractNumber>
                        </xsl:if> 
                    </OrderInfo>                    
                </xsl:if>
                <PartnerType>
                    <xsl:choose>
                        <xsl:when test="$v_LsEnabled = 'X'">
                            <xsl:value-of select="'LS'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'LI'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </PartnerType>
                <!--Map IsInformationOnly Parameter-->
                <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@isInformationOnly)">
                    <IsInformationOnly>
                        <xsl:value-of select="'true'"/>
                    </IsInformationOnly>
                </xsl:if>
                <!--Map the BillTo Details-->
                <xsl:for-each select="$v_contact_path[@role = 'billTo']">
                    <BillToParty>                        
                        <xsl:call-template name="MapPartyDetails">
                            <xsl:with-param name="p_contactDetails" select="$v_contact_path[@role = 'billTo']"/>
                        </xsl:call-template>
                    </BillToParty>
                </xsl:for-each>                
                <!--Map BillFrom Details-->
                <xsl:for-each select="$v_contact_path[@role = 'billFrom']">
                    <BillFromParty>
                        <xsl:call-template name="MapPartyDetails">
                            <xsl:with-param name="p_contactDetails" select="$v_contact_path[@role = 'billFrom']"/>
                        </xsl:call-template>
                        <VendorID>
                            <xsl:value-of select="$v_vendor_id"/>
                        </VendorID>
                    </BillFromParty>
                </xsl:for-each>                
                <!--Map RemitTo Details-->
                <xsl:for-each select="$v_contact_path[@role = 'remitTo']">
                    <RemitToParty>
                        <xsl:call-template name="MapPartyDetails">
                            <xsl:with-param name="p_contactDetails" select="$v_contact_path[@role = 'remitTo']"/>
                        </xsl:call-template>
                    </RemitToParty>
                </xsl:for-each>                
                <!--Map soldTo Details-->
                <xsl:for-each select="$v_contact_path[@role = 'soldTo']">
                    <SoldToParty>
                        <xsl:call-template name="MapPartyDetails">
                            <xsl:with-param name="p_contactDetails" select="$v_contact_path[@role = 'soldTo']"/>
                        </xsl:call-template>
                    </SoldToParty>
                </xsl:for-each>
                <!--Map Item Details-->
                <xsl:for-each select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
                    <xsl:variable name="v_linenumber" select="@invoiceLineNumber"/>
                    <Item>
                        <ID>
                            <xsl:value-of select="@invoiceLineNumber"/>                            
                        </ID>
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
                        <!--Hardcode to 'material' for Material Lines-->
                        <LineType>
                            <xsl:value-of select="'material'"/>
                        </LineType>
                        <!--Map Material-->
                        <xsl:if test="exists(InvoiceDetailItemReference/ItemID/BuyerPartID) or 
                            exists(InvoiceDetailItemReference/ItemID/SupplierPartID)">
                            <Product>
                                <xsl:if test="exists(InvoiceDetailItemReference/ItemID/BuyerPartID)">
                                    <InternalID>
                                        <xsl:value-of select="InvoiceDetailItemReference/ItemID/BuyerPartID"/>    
                                    </InternalID>
                                </xsl:if>
                                <xsl:if test="exists(InvoiceDetailItemReference/ItemID/SupplierPartID)">
                                    <SupplierPartID>
                                        <xsl:value-of select="InvoiceDetailItemReference/ItemID/SupplierPartID"/>    
                                    </SupplierPartID>
                                </xsl:if>
                            </Product>
                        </xsl:if>                         
                        <!--Populate this only for FI Invoice as it is not consumed in Cons.with Invoice-->
                        <xsl:if test="string-length($v_isConsWithdrawalInvoice) = 0">
                            <!--Populate Gross Amount, Net Amount, Net Unit Price, Discount-->                        
                            <PriceCalculation>
                                <!--Populate Item level Gross Amount-->
                                <xsl:if test="exists(GrossAmount)">
                                    <GrossAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="GrossAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="GrossAmount/Money"/>
                                    </GrossAmount>
                                </xsl:if>
                                <!--Populate Item level Net Amount-->
                                <xsl:if test="exists(NetAmount)">
                                    <NetAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="NetAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="NetAmount/Money"/>
                                    </NetAmount>
                                </xsl:if>
                                <!--Populate Item level Net Unit Price-->
                                <xsl:if test="exists(UnitPrice/Money)">
                                    <NetUnitPrice>
                                        <Amount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of select="UnitPrice/Money/@currency"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="UnitPrice/Money"/>
                                        </Amount>
                                    </NetUnitPrice>
                                </xsl:if>                         
                                <xsl:if test="exists(InvoiceDetailDiscount/Money)">
                                    <!--Populate Item Level Discount-->
                                    <DiscountPrice>
                                        <Amount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of select="InvoiceDetailDiscount/Money/@currency"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="InvoiceDetailDiscount/Money"/>
                                        </Amount>
                                    </DiscountPrice>
                                </xsl:if>
                            </PriceCalculation>
                        </xsl:if>
                        <!--Populate Item Tax Details-->
                        <xsl:if test="exists(Tax/TaxDetail)">
                        <TaxCalculation>
                        <xsl:for-each select="Tax/TaxDetail">
                                <ProductTaxDetails>
                                    <TaxTypeCode>
                                        <xsl:call-template name="TaxTypeMap">
                                            <xsl:with-param name="p_taxcat" select="@category"/>
                                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anReceiverID" select="$anReceiverID"/>
                                            <xsl:with-param name="p_anSourceDocumentType" select="$anSourceDocumentType"/>
                                        </xsl:call-template>
                                    </TaxTypeCode>
                                    <TaxBaseAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="TaxableAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="TaxableAmount/Money"/>
                                    </TaxBaseAmount>
                                    <xsl:if test="exists(@percentageRate)">
                                        <TaxPercent>
                                            <xsl:value-of select="@percentageRate"/>
                                        </TaxPercent>
                                    </xsl:if>
                                    <TaxAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="TaxAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="TaxAmount/Money"/>
                                    </TaxAmount>
                                </ProductTaxDetails>                            
                        </xsl:for-each>  
                        </TaxCalculation>
                        </xsl:if>
                        <!--Populate this only for Cons.with Invoice as it is not consumed in FI Invoice-->
                        <xsl:if test="string-length($v_isConsWithdrawalInvoice) > 0">
                            <ProductMovementItemIDInfo>
                                <ID>
                                    <xsl:value-of select="ProductMovementItemIDInfo/@movementLineNumber"/>
                                </ID>
                                <CompanyCode>
                                    <xsl:value-of select="substring(ProductMovementItemIDInfo/@movementID, 1, 4)"/>
                                </CompanyCode>
                                <MaterialDocument>
                                    <xsl:value-of select="substring(ProductMovementItemIDInfo/@movementID, 5, 10)"/>
                                </MaterialDocument>
                                <Year>
                                    <xsl:value-of select="substring(ProductMovementItemIDInfo/@movementID, 15, 4)"/>
                                </Year>
                                <MaterialDate>
                                    <xsl:value-of select="substring(ProductMovementItemIDInfo/@movementDate, 1, 10)"/>
                                </MaterialDate>
                            </ProductMovementItemIDInfo>
                        </xsl:if>    
                        <!--Populate this only for FI Invoice as it is not consumed in Cons.with Invoice-->
                        <xsl:if test="string-length($v_isConsWithdrawalInvoice) = 0">
                        <xsl:if test="exists(Distribution)">
                            <AccountingCodingBlockDistribution>
                                <xsl:for-each select="Distribution">
                                    <AccountingCodingBlockAssignment>
                                        <OrdinalNumberValue>
                                            <!--Map item number seperately , it will carry invoiceLineNumber as it is-->
                                            <xsl:value-of select="concat(position(), $v_linenumber)"/>
                                        </OrdinalNumberValue>
                                        <LineNumber>
                                            <xsl:value-of select="$v_linenumber"/>
                                        </LineNumber>
                                        <Amount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of select="Charge/Money/@currency"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="Charge/Money"/>
                                        </Amount>
                                        <xsl:for-each select="Accounting/AccountingSegment[Description != 'Description']">
                                            <xsl:choose>
                                                <xsl:when test="Name = 'Percentage'">
                                                    <Percentage>
                                                        <xsl:value-of select="@id"/>
                                                    </Percentage>                                                
                                                </xsl:when>
                                                <xsl:when test="Name = 'GeneralLedger' or Name = 'G/L Account'">
                                                    <GLAccount>
                                                        <xsl:value-of select="@id"/>
                                                    </GLAccount>
                                                </xsl:when>
                                                <xsl:when test="Name = 'WBSElement'">
                                                    <WBSElement>
                                                        <xsl:value-of select="@id"/>
                                                    </WBSElement>
                                                </xsl:when>
                                                <xsl:when test="Name = 'CostCenter' or Name = 'Cost Center'">
                                                    <CostCentreID>
                                                        <xsl:value-of select="@id"/>
                                                    </CostCentreID>
                                                </xsl:when>
                                                <xsl:when test="Name = 'Asset'">
                                                    <AssetID>
                                                        <xsl:value-of select="@id"/>
                                                    </AssetID>
                                                </xsl:when>
                                                <xsl:when test="Name = 'InternalOrder'">
                                                    <InternalOrderID>
                                                        <xsl:value-of select="@id"/>
                                                    </InternalOrderID>
                                                </xsl:when>
                                                <xsl:when test="Name = 'SubAsset'">
                                                    <SubAsset>
                                                        <xsl:value-of select="@id"/>
                                                    </SubAsset>
                                                </xsl:when>
                                            </xsl:choose>                                        
                                        </xsl:for-each>
                                    </AccountingCodingBlockAssignment>
                                </xsl:for-each>
                            </AccountingCodingBlockDistribution>
                        </xsl:if>
                        </xsl:if>
                    </Item>
                </xsl:for-each>
                <xsl:for-each select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem">
                   <xsl:variable name="v_linenumber" select="@invoiceLineNumber"/>
                    <Item>
                        <ID>
                            <xsl:value-of select="@invoiceLineNumber"/>                            
                        </ID>
                        <Quantity>
                            <xsl:attribute name="unitCode">
                                <xsl:choose>
                                    <xsl:when test="exists(UnitOfMeasure) and string-length(UnitOfMeasure) > 0">
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput" select="UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <!--In case of Labor services, UOM comes under UnitRate-->
                                    <xsl:when test="exists(UnitRate/UnitOfMeasure) and string-length(UnitRate/UnitOfMeasure) > 0">
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput" select="UnitRate/UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:value-of select="@quantity"/>
                        </Quantity>
                        <!--In case of service items hardcode this to 'service'-->
                        <LineType>
                            <xsl:choose>
                                <xsl:when test="InvoiceDetailServiceItemReference/@lineNumber = 0">
                                    <xsl:value-of select="'charges'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'service'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </LineType>                        
                        <xsl:if test="exists(InvoiceDetailServiceItemReference/ItemID/BuyerPartID) or 
                            exists(InvoiceDetailServiceItemReference/ItemID/SupplierPartID)">
                            <Product>
                                <xsl:if test="exists(InvoiceDetailServiceItemReference/ItemID/BuyerPartID)">
                                    <InternalID>
                                        <xsl:value-of select="InvoiceDetailServiceItemReference/ItemID/BuyerPartID"/>    
                                    </InternalID>
                                </xsl:if>
                                <xsl:if test="exists(InvoiceDetailServiceItemReference/ItemID/SupplierPartID)">
                                    <SupplierPartID>
                                        <xsl:value-of select="InvoiceDetailServiceItemReference/ItemID/SupplierPartID"/>    
                                    </SupplierPartID>
                                </xsl:if>
                            </Product>
                        </xsl:if> 
                        <!--Populate Gross Amount, Net Amount, Net Unit Price, Discount  
                        Populate this only for FI Invoice as it is not consumed in Cons.with Invoice-->
                        <xsl:if test="string-length($v_isConsWithdrawalInvoice) = 0">
                        <PriceCalculation>
                        <!--Populate Item level Gross Amount-->
                                <xsl:if test="exists(GrossAmount)">
                                    <GrossAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="GrossAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="GrossAmount/Money"/>
                                    </GrossAmount>
                                </xsl:if>
                                <!--Populate Item level Net Amount-->
                                <xsl:if test="exists(NetAmount)">
                                    <NetAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="NetAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="NetAmount/Money"/>
                                    </NetAmount>
                                </xsl:if>
                                <!--Populate Item level Net Unit Price-->
                                <xsl:choose>
                                    <xsl:when test="exists(UnitPrice/Money)">
                                        <NetUnitPrice>
                                            <Amount>
                                                <xsl:attribute name="currencyCode">
                                                    <xsl:value-of select="UnitPrice/Money/@currency"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="UnitPrice/Money"/>
                                            </Amount>
                                        </NetUnitPrice>
                                    </xsl:when>  
                                    <xsl:otherwise>
                                        <xsl:if test="exists(UnitRate/Money)">
                                            <NetUnitPrice>
                                                <Amount>
                                                    <xsl:attribute name="currencyCode">
                                                        <xsl:value-of select="UnitRate/Money/@currency"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="UnitRate/Money"/>
                                                </Amount>
                                            </NetUnitPrice>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="exists(InvoiceDetailDiscount/Money)">
                                    <!--Populate Item Level Discount-->
                                    <DiscountPrice>
                                        <Amount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of select="InvoiceDetailDiscount/Money/@currency"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="InvoiceDetailDiscount/Money"/>
                                        </Amount>
                                    </DiscountPrice>
                                </xsl:if>
                        </PriceCalculation>
                        </xsl:if>
                        <!--Populate the tax details only for FI Invoice as it is not consumed in Cons.with Invoice-->
                        <xsl:if test="exists(Tax/TaxDetail)">
                        <TaxCalculation>
                            <xsl:for-each select="Tax/TaxDetail">
                                <ProductTaxDetails>
                                    <xsl:if test="exists(@purpose) and string-length(@purpose) > 0">                           
                                        <Purpose>
                                            <xsl:value-of select="@purpose"/>
                                        </Purpose>
                                    </xsl:if> 
                                    <TaxTypeCode>
                                        <xsl:call-template name="TaxTypeMap">
                                            <xsl:with-param name="p_taxcat" select="@category"/>
                                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anReceiverID" select="$anReceiverID"/>
                                            <xsl:with-param name="p_anSourceDocumentType" select="$anSourceDocumentType"/>
                                        </xsl:call-template>
                                    </TaxTypeCode>
                                    <TaxBaseAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="TaxableAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="TaxableAmount/Money"/>
                                    </TaxBaseAmount>
                                    <xsl:if test="exists(@percentageRate)">
                                        <TaxPercent>
                                            <xsl:value-of select="@percentageRate"/>
                                        </TaxPercent>
                                    </xsl:if>
                                    <TaxAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="TaxAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="TaxAmount/Money"/>
                                    </TaxAmount>
                                </ProductTaxDetails>                                 
                            </xsl:for-each>  
                        </TaxCalculation>
                        </xsl:if>
                        <!--Populate this only for FI Invoice as it is not consumed in Cons.with Invoice-->
                        <xsl:if test="string-length($v_isConsWithdrawalInvoice) = 0">
                            <xsl:if test="exists(Distribution)">
                                <AccountingCodingBlockDistribution>
                                    <xsl:for-each select="Distribution">
                                        <AccountingCodingBlockAssignment>
                                            <OrdinalNumberValue>
                                                <!--Map item number seperately , it will carry invoiceLineNumber as it is-->
                                                <xsl:value-of select="concat(position(), $v_linenumber)"/>
                                            </OrdinalNumberValue>
                                            <LineNumber>
                                                <xsl:value-of select="$v_linenumber"/>
                                            </LineNumber>
                                            <Amount>
                                                <xsl:attribute name="currencyCode">
                                                    <xsl:value-of select="Charge/Money/@currency"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="Charge/Money"/>
                                            </Amount>
                                            <xsl:for-each select="Accounting/AccountingSegment[Description != 'Description']">
                                                <xsl:choose>
                                                    <xsl:when test="Name = 'Percentage'">
                                                        <Percentage>
                                                            <xsl:value-of select="@id"/>
                                                        </Percentage>                                                
                                                    </xsl:when>
                                                    <xsl:when test="Name = 'GeneralLedger' or Name = 'G/L Account'">
                                                        <GLAccount>
                                                            <xsl:value-of select="@id"/>
                                                        </GLAccount>
                                                    </xsl:when>
                                                    <xsl:when test="Name = 'WBSElement'">
                                                        <WBSElement>
                                                            <xsl:value-of select="@id"/>
                                                        </WBSElement>
                                                    </xsl:when>
                                                    <xsl:when test="Name = 'CostCenter' or Name = 'Cost Center'">
                                                        <CostCentreID>
                                                            <xsl:value-of select="@id"/>
                                                        </CostCentreID>
                                                    </xsl:when>
                                                    <xsl:when test="Name = 'Asset'">
                                                        <AssetID>
                                                            <xsl:value-of select="@id"/>
                                                        </AssetID>
                                                    </xsl:when>
                                                    <xsl:when test="Name = 'InternalOrder'">
                                                        <InternalOrderID>
                                                            <xsl:value-of select="@id"/>
                                                        </InternalOrderID>
                                                    </xsl:when>
                                                    <xsl:when test="Name = 'SubAsset'">
                                                        <SubAsset>
                                                            <xsl:value-of select="@id"/>
                                                        </SubAsset>
                                                    </xsl:when>
                                                </xsl:choose>                                        
                                            </xsl:for-each>
                                        </AccountingCodingBlockAssignment>
                                    </xsl:for-each>
                                </AccountingCodingBlockDistribution>
                            </xsl:if>
                       </xsl:if>
                        <xsl:if test="string-length(UnitRate/TermReference/@term) > 0 ">
                            <LaborDetails>
                                <StartDate>
                                    <xsl:variable name="v_erpdate">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date"
                                                select="Period/@startDate"/>
                                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="substring($v_erpdate,0,11)"/>
                                </StartDate>
                                <EndDate>
                                    <xsl:variable name="v_erpdate">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date"
                                                select="Period/@endDate"/>
                                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="substring($v_erpdate,0,11)"/>
                                </EndDate>
                                <UnitRate>
                                    <Money>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="UnitRate/Money/@currency"/>  
                                        </xsl:attribute>
                                        <xsl:value-of select="UnitRate/Money"/> 
                                    </Money>
                                    <UnitOfMeasure>
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput" select="UnitRate/UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </UnitOfMeasure>
                                    <TermReference>
                                        <Term>
                                            <xsl:value-of select="UnitRate/TermReference/@term"/>
                                        </Term>
                                        <TermName>
                                            <xsl:value-of select="UnitRate/TermReference/@termName"/>
                                        </TermName>
                                    </TermReference>
                                </UnitRate>
                                <TimeCardID>
                                    <xsl:value-of select="InvoiceLaborDetail/InvoiceTimeCardDetail/TimeCardIDInfo/@timeCardID"/>
                                </TimeCardID>
                                <Contractor>
                                    <Name>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="InvoiceLaborDetail/Contractor/Contact/Name/@xml:lang"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="InvoiceLaborDetail/Contractor/Contact/Name"/>
                                    </Name>
                                </Contractor>
                                <ContractIdentifier>
                                    <xsl:attribute name="Domain">
                                        <xsl:value-of select="InvoiceLaborDetail/Contractor/ContractorIdentifier/@domain"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="InvoiceLaborDetail/Contractor/ContractorIdentifier"/>
                                </ContractIdentifier>
                                <JobDescription>
                                    <xsl:attribute name="languageCode">
                                        <xsl:value-of select="InvoiceLaborDetail/JobDescription/Description/@xml:lang"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="InvoiceLaborDetail/JobDescription/Description"/>
                                </JobDescription>  
                                <Supervisor>
                                    <xsl:value-of select="InvoiceLaborDetail/Supervisor/Contact/Name"/>
                                </Supervisor>
                                <Address>
                                    <PhysicalAddress>
                                        <StreetName>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Street[1]"/>
                                        </StreetName>
                                        <StreetPrefixName>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Street[2]"/>
                                        </StreetPrefixName>
                                        <StreetSuffixName>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Street[3]"/>
                                        </StreetSuffixName>                                
                                        <CityName>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/City"/>
                                        </CityName>
                                        <RegionCode>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/State/@isoStateCode"/>
                                        </RegionCode>
                                        <RegionName>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/State"/>
                                        </RegionName>                                
                                        <CompanyPostalCode>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/PostalCode"/>
                                        </CompanyPostalCode>
                                        <CountryCode>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Country/@isoCountryCode"/>
                                        </CountryCode>
                                        <CountryName>
                                            <xsl:value-of select="InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Country"/>
                                        </CountryName>
                                    </PhysicalAddress>
                                </Address>
                            </LaborDetails>
                        </xsl:if>
                    </Item>
                </xsl:for-each>           
                <!--Map Invoice Header Tax details-->
                <xsl:if test="string-length($v_isTaxInLine) = 0 and
                    exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail)">
                <TaxCalculation>
                <xsl:for-each select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail">
                        <ProductTaxDetails>
                            <xsl:if test="exists(@category) and string-length(@category) > 0">                           
                                <TaxTypeCode>
                                    <xsl:call-template name="TaxTypeMap">
                                        <xsl:with-param name="p_taxcat" select="@category"/>
                                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anReceiverID" select="$anReceiverID"/>
                                        <xsl:with-param name="p_anSourceDocumentType" select="$anSourceDocumentType"/>
                                    </xsl:call-template>
                                </TaxTypeCode>
                            </xsl:if> 
                            <xsl:if test="exists(TaxableAmount/Money)">
                                <TaxBaseAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="TaxableAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="TaxableAmount/Money"/>
                                </TaxBaseAmount>
                            </xsl:if> 
                            <xsl:if test="exists(@percentageRate)">
                                <TaxPercent>
                                    <xsl:value-of select="@percentageRate"/>
                                </TaxPercent>
                            </xsl:if>
                            <xsl:if test="exists(TaxAmount/Money)">
                                <TaxAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="TaxAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="TaxAmount/Money"/>
                                </TaxAmount>
                            </xsl:if>
                        </ProductTaxDetails>                    
                </xsl:for-each>
                </TaxCalculation>
                </xsl:if>
                <!--Populate this only for FI Invoice as it is not consumed in Cons.with Invoice-->
                <xsl:if test="string-length($v_isConsWithdrawalInvoice) = 0">
                <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary)">
                    <PriceCalculation>
                        <!--Populate Gross Amount-->
                        <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/GrossAmount)">
                            <GrossAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/GrossAmount/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/GrossAmount/Money"/>
                            </GrossAmount>
                        </xsl:if>
                        <!--PopulateNet Amount-->
                        <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/NetAmount)">
                            <NetAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/NetAmount/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/NetAmount/Money"/>
                            </NetAmount>
                        </xsl:if>
                        <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax)">
                            <TaxAmount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money"/>
                            </TaxAmount>
                        </xsl:if>
                        <xsl:if test="string-length($v_isDiscountInLine) = 0">
                        <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money)">
                            <!--Populate Header Level Discount-->
                            <DiscountPrice>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money/@currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money"/>                             
                            </DiscountPrice>
                        </xsl:if>
                        </xsl:if>
                    </PriceCalculation>
                </xsl:if>
                </xsl:if>
                <xsl:if test="string-length($v_isConsWithdrawalInvoice) = 0">
                    <!--Check if the Shipping Costs and Special Handling Costs are coming as service Items-->
                    <xsl:variable name="v_isShipService" 
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/Extrinsic[@name = 'IsShippingServiceItem']"/>
                    <xsl:variable name="v_isSpclService" 
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/Extrinsic[@name = 'IsSpecialHandlingServiceItem']"/>
                    <!--If the Unplanned Costs are coming as service items, no need to populate them in Unplanned section-->
                    <xsl:if test="string-length($v_isShipService) = 0 or string-length($v_isSpclService) = 0">
                        <xsl:for-each select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail">
                            <!--Check for ShippingTax and specialHandlingTax in the ABAP logic-->
                            <UnplannedDeliveryCostsDets>
                                <xsl:if test="exists(@purpose) and string-length(@purpose) > 0">                           
                                    <Purpose>
                                        <xsl:value-of select="@purpose"/>
                                    </Purpose>
                                </xsl:if> 
                                <xsl:if test="exists(@category) and string-length(@category) > 0">
                                    <TaxTypeCode>
                                        <xsl:call-template name="TaxTypeMap">
                                            <xsl:with-param name="p_taxcat" select="@category"/>
                                        </xsl:call-template>
                                    </TaxTypeCode>
                                </xsl:if>
                                <xsl:if test="exists(@percentageRate)">
                                    <TaxPercent>
                                        <xsl:value-of select="@percentageRate"/>
                                    </TaxPercent>
                                </xsl:if>
                                <xsl:if test="exists(TaxableAmount/Money)">
                                    <TaxBaseAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="TaxableAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="TaxableAmount/Money"/>
                                    </TaxBaseAmount>
                                </xsl:if>
                                <xsl:if test="exists(TaxAmount/Money)">
                                    <TaxAmount>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="TaxAmount/Money/@currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="TaxAmount/Money"/>
                                    </TaxAmount>
                                </xsl:if>
                            </UnplannedDeliveryCostsDets>                    
                        </xsl:for-each>
                        <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money) and
                            string-length($v_isSpclService) = 0">
                            <UnplannedDeliveryCostsDets>
                                <Purpose>
                                    <xsl:value-of select="'specialHandlingAmount'"/>
                                </Purpose>
                                <TaxBaseAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money"/>
                                </TaxBaseAmount>
                            </UnplannedDeliveryCostsDets>
                        </xsl:if>                
                        <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money) and
                            string-length($v_isShipService) = 0">
                            <UnplannedDeliveryCostsDets>
                                <Purpose>
                                    <xsl:value-of select="'shippingAmount'"/>
                                </Purpose>
                                <TaxBaseAmount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money/@currency"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money"/>
                                </TaxBaseAmount>
                            </UnplannedDeliveryCostsDets>
                        </xsl:if>                
                    </xsl:if>
                </xsl:if>
            </Invoice>
            <!--Fill in the Header Comments-->
            <xsl:if test="string-length(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments) > 0 ">
                <Comments>
                    <xsl:call-template name="CommentsFillProxyIn">
                        <xsl:with-param name="p_comments"
                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments"/>
                        <xsl:with-param name="p_lang" select="$v_default_lang"/>
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </Comments>
            </xsl:if>
            <!--Fill in the Header Attachments. IG-35372-If a Buyer rule setting related to AN generated Invoice PDF is enabled, then we will get the attachment information in Extrinsic, so we need to accomodate that in FIInvoice mapping to form the attachment content.-->
            <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/Attachment) or exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'invoicePDF']/Attachment)">
                <xsl:call-template name="InboundAttach"/>                   
            </xsl:if>
        </n0:InvoiceERPRequest>
    </xsl:template>
</xsl:stylesheet>
