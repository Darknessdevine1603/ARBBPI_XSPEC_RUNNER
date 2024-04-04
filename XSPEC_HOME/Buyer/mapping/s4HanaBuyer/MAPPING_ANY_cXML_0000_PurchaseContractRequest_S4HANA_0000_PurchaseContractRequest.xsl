<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/Procurement"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPName"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <!--Local Testing-->
<!--<xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
    <!--Prepare the CrossRef path-->
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:template match="urn:WSPurchaseContractRequestExportOutputBean_Item"
        xmlns:urn="urn:Ariba:Sourcing:vsap">
        <xsl:variable name="message_path" select="urn:item/urn:MessageHeader"/>
        <xsl:variable name="contract_header"
            select="urn:item/urn:ContractRequest/urn:ContractRequestHeader"/>
        <xsl:variable name="contract_item"
            select="urn:item/urn:ContractRequest/urn:ContractRequestLineItems/urn:item"/>
        <n0:PurchaseContractRequest>
            <MessageHeader>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="$message_path/urn:BusinessSystemID"/>
                </RecipientBusinessSystemID>
                <ID>
                    <xsl:value-of select="translate($message_path/urn:PayloadID, '-', '')"/>
                </ID>
                <CreationDateTime>
                    <xsl:value-of select="$contract_header/urn:CreateDate"/>
                </CreationDateTime>
<!--                Changing this to ANID for Streamlining across all Scope items -->
                <SenderBusinessSystemID>
                    <xsl:value-of select="$message_path/urn:ANID"/>
                </SenderBusinessSystemID>
            </MessageHeader>
            <PurchaseContract>
                <xsl:attribute name="actionCode">
                    <xsl:choose>
                        <xsl:when test="$contract_header/urn:Operation = 'new'">
                            <xsl:value-of select="'01'"/>
                        </xsl:when>
                        <xsl:when test="$contract_header/urn:Operation = 'update'">
                            <xsl:value-of select="'02'"/>
                        </xsl:when>
                        <xsl:when test="$contract_header/urn:Operation = 'delete'">
                            <xsl:value-of select="'03'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <PurchaseContractID>
                    <xsl:value-of select="$contract_header/urn:RelatedID"/>
                </PurchaseContractID>
                <PurchaseContractExternalReferenceID>
                    <xsl:value-of select="$contract_header/urn:ContractID"/>
                </PurchaseContractExternalReferenceID>
                <!-- SAP Document Type using LoopUp Table -->
                <xsl:variable name="var_doc">
                    <xsl:value-of select="$contract_header/urn:DocumentCategory"/>
                </xsl:variable>
                <DocumentType>
                    <xsl:call-template name="LookupTemplate">
                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                        <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                        <xsl:with-param name="p_doctype" select="'PurchaseContractRequest'"/>
                        <xsl:with-param name="p_input" select="$var_doc"/>
                        <xsl:with-param name="p_lookupname" select="'SAPDocType'"/>
                        <xsl:with-param name="p_producttype" select="'AribaSourcing'"/>
                    </xsl:call-template>
                </DocumentType>
                <DocumentCategory>
                    <!--Cross reference to Doc Category-->
                    <xsl:variable name="var_doc_category">
                        <xsl:value-of select="$contract_header/urn:DocumentType"/>
                    </xsl:variable>
                    <xsl:if test="$var_doc_category = 'Contract'">
                        <xsl:value-of select="'K'"/>
                    </xsl:if>
                    <xsl:if test="$var_doc_category = 'Scheduling Agreement'">
                        <xsl:value-of select="'L'"/>
                    </xsl:if>
                    <xsl:if test="$var_doc_category = 'Central Contract'">
                        <xsl:value-of select="'C'"/>
                    </xsl:if>
                </DocumentCategory>
                <PurchasingOrganization>
                    <xsl:value-of select="$contract_header/urn:PurchasingOrganization"/>
                </PurchasingOrganization>
                <PurchasingGroup>
                    <xsl:value-of select="$contract_header/urn:PurchasingGroup"/>
                </PurchasingGroup>
                <CompanyCode>
                    <xsl:value-of select="$contract_header/urn:CompanyCode"/>
                </CompanyCode>
                <DocumentCurrency>
                    <xsl:value-of select="$contract_header/urn:ContractAmount/urn:CurrencyCode"/>
                </DocumentCurrency>
                <ValidityPeriod>
                    <!--Convert the date into SAP format is 'YYYYMMDD'-->
                    <StartDate>
                        <xsl:value-of select="substring($contract_header/urn:EffectiveDate, 1, 10)"
                        />
                    </StartDate>
                    <EndDate>
                        <xsl:value-of select="substring($contract_header/urn:ExpirationDate, 1, 10)"
                        />
                    </EndDate>
                </ValidityPeriod>
                <SupplierParty>
                    <!--SAP vendor ID-->
                    <Supplier>
                        <!--IG-34345 fix for supporting Alpha Numeric vendors-->
                        <xsl:choose>
                            <xsl:when test="string-length($contract_header/urn:PrivateID) > 0 and string(number($contract_header/urn:PrivateID)) = 'NaN'">
                                <xsl:value-of select="$contract_header/urn:PrivateID"/>                          
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="format-number($contract_header/urn:PrivateID, '0000000000')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </Supplier>
                </SupplierParty>
                <!-- To map User Name from Cross Reference -->
                <xsl:variable name="var_user">
                    <xsl:value-of>
                        <xsl:call-template name="ReadQuote">
                            <xsl:with-param name="p_doctype" select="'PurchaseContractRequest'"/>
                            <xsl:with-param name="p_pd" select="$v_pd"/>
                            <xsl:with-param name="p_attribute" select="'UserName'"/>
                        </xsl:call-template>
                    </xsl:value-of>
                </xsl:variable>
                <xsl:if test="$var_user != ''">
                    <CreatedByUser>
                        <xsl:value-of select="$var_user"/>
                    </CreatedByUser>
                </xsl:if>
                <!-- for value contract(type=WK) -->
                <xsl:if test="$contract_header/urn:ContractAmount/urn:Amount != ''">
                    <TargetAmount>
                        <xsl:attribute name="currencyCode">
                            <xsl:value-of
                                select="$contract_header/urn:ContractAmount/urn:CurrencyCode"/>
                        </xsl:attribute>
                        <xsl:value-of select="$contract_header/urn:ContractAmount/urn:Amount"/>
                    </TargetAmount>
                </xsl:if>
                <xsl:if test="$contract_header/urn:PaymentTerms/urn:PaymentTermId != ''">
                    <PaymentTerms>
                        <!-- Based on TermsID, further details will be fetched from S/4 HANA system -->
                        <PaymentTermsID>
                            <xsl:value-of
                                select="$contract_header/urn:PaymentTerms/urn:PaymentTermId"/>
                        </PaymentTermsID>
                    </PaymentTerms>
                </xsl:if>
                <xsl:for-each select="$contract_item">
                    <PurchaseContractItem>
                        <xsl:variable name="var_operation">
                            <xsl:choose>
                                <xsl:when test="./urn:Operation = 'new'">
                                    <xsl:value-of select="'01'"/>
                                </xsl:when>
                                <xsl:when test="./urn:Operation = 'update'">
                                    <xsl:value-of select="'02'"/>
                                </xsl:when>
                                <xsl:when test="./urn:Operation = 'delete'">
                                    <xsl:value-of select="'03'"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:attribute name="actionCode">
                            <xsl:value-of select="$var_operation"/>
                        </xsl:attribute>
                        <!-- SAP Line number will be available only for change or delete scenario. It will be blank in new scenario -->
                        <xsl:if test="./urn:Operation = 'update' or ./urn:Operation = 'delete'">
                            <PurchaseContractItemID>
                                <xsl:value-of select="./urn:ExternalLineNumber"/>
                            </PurchaseContractItemID>
                        </xsl:if>
                        <!-- ARIBA Line number will be available for create or change or delete scenario. Hence this is used as the Document Number in CIG Tracker -->
                        <PurchaseContractItemExternalRefID>
                            <xsl:value-of select="./urn:LineNumber"/>
                        </PurchaseContractItemExternalRefID>
                        <ItemCategory>
                            <xsl:variable name="var_item_category">
                                <xsl:value-of select="./urn:ItemCategory"/>
                            </xsl:variable>
                            <xsl:choose>
                                <!-- both “standard” and “service” we are mapping it to <blank>. Other item categories are not supported in S/4 HANA. -->
                                <xsl:when test="$var_item_category = 'standard'">
                                    <xsl:value-of select="''"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'limit'">
                                    <xsl:value-of select="'B'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'consignment'">
                                    <xsl:value-of select="'K'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'subcontract'">
                                    <xsl:value-of select="'L'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'materialUnknown'">
                                    <xsl:value-of select="'M'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'thirdParty'">
                                    <xsl:value-of select="'S'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'text'">
                                    <xsl:value-of select="'T'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'stockTransfer'">
                                    <xsl:value-of select="'U'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'materialGroup'">
                                    <xsl:value-of select="'W'"/>
                                </xsl:when>
                                <xsl:when test="$var_item_category = 'service'">
                                    <xsl:value-of select="''"/>
                                </xsl:when>
                            </xsl:choose>
                        </ItemCategory>
                        <ProductType>
                            <xsl:if test="./urn:ProductType = 'service'">
                                <xsl:value-of select="'2'"/>
                            </xsl:if>
                            <xsl:if test="./urn:ProductType = 'material'">
                                <xsl:value-of select="'1'"/>
                            </xsl:if>
                        </ProductType>
                        <xsl:if test="./urn:BuyerPartID != ''">
                            <Material>
                                <!-- Ariba MaterialNumber -->
                                <xsl:value-of select="./urn:BuyerPartID"/>
                            </Material>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(./urn:MaterialGroup)) > 0">
                            <MaterialGroup>
                                <xsl:value-of select="./urn:MaterialGroup"/>
                            </MaterialGroup>
                        </xsl:if>
                        <ItemDescription>
                            <xsl:value-of select="./urn:Description"/>
                        </ItemDescription>
                        <xsl:if test="./urn:SupplierPartID != ''">
                            <SupplierMaterialNumber>
                                <!-- SAP MaterialNumber -->
                                <xsl:value-of select="./urn:SupplierPartID"/>
                            </SupplierMaterialNumber>
                        </xsl:if>
                        <xsl:if test="./urn:Plant != ''">
                            <Plant>
                                <xsl:value-of select="./urn:Plant"/>
                            </Plant>
                        </xsl:if>
                        <xsl:if test="./urn:ItemCategory = 'consignment' and ./urn:ProductType = 'material' and string-length(normalize-space(./urn:CreateOrUpdatePIR)) > 0">
                            <InfoRecordIsToBeUpdated>
                                <xsl:choose>
                                    <xsl:when test="urn:CreateOrUpdatePIR = 'yes'">
                                        <xsl:value-of select="'true'"/>
                                    </xsl:when>
                                    <xsl:when test="urn:CreateOrUpdatePIR = 'no'">
                                        <xsl:value-of select="'false'"/>
                                    </xsl:when>
                                </xsl:choose>
                            </InfoRecordIsToBeUpdated>
                        </xsl:if>
                        <!--Item Hierarchy start: identifiy a parent item-->
                        <xsl:variable name="var_isOutline">
                            <xsl:if test="./urn:ItemType = 'composite'">
                                <xsl:value-of select="'true'"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:if test="$var_isOutline = 'true'">
                            <IsOutline>
                                <xsl:value-of select="'true'"/>
                            </IsOutline>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(./urn:ParentLineNumber)) > 0">
                            <PurContrParentItemExtRef>
                                <xsl:value-of select="./urn:ParentLineNumber"/>
                            </PurContrParentItemExtRef>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(./urn:SequenceNumber)) > 0">
                            <PurgDocExtRefSiblingSortNumber>
                                <xsl:value-of select="./urn:SequenceNumber"/>
                            </PurgDocExtRefSiblingSortNumber>
                        </xsl:if>
                        <!--Item Hierarchy end-->
                        <xsl:variable name="var_unitcode">
                            <xsl:value-of select="./urn:Quantity/urn:UnitOfMeasure"/>
                        </xsl:variable>
                        <xsl:variable name="var_quantity">
                            <xsl:value-of select="./urn:Quantity/urn:Value"/>
                        </xsl:variable>
                        <!-- For Quantity Contract Type MK -->
                        <xsl:if  test="$var_isOutline != 'true'">
                            <RequestedQuantity>
                                <xsl:attribute name="unitCode">
                                <xsl:value-of select="$var_unitcode"/>
                            </xsl:attribute>
                            <xsl:value-of select="$var_quantity"/>
                        </RequestedQuantity>
                            </xsl:if>
                        <!--Item Hierarchy extension: Don't populate, when it is a Parent item.-->
                        <xsl:if  test="$var_isOutline != 'true'">
                            <Price>
                                <xsl:variable name="var_unitprice_currencycode">
                                    <xsl:value-of select="./urn:UnitPrice/urn:Amount/urn:CurrencyCode"/>
                                </xsl:variable>                                
                                <Amount>
                                    <xsl:attribute name="currencyCode">
                                        <xsl:value-of select="$var_unitprice_currencycode"/> 
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="./urn:ItemCategory = 'consignment'">
                                            <xsl:value-of select="'0'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="./urn:UnitPrice/urn:Amount/urn:Amount"/>
                                        </xsl:otherwise>
                                    </xsl:choose>                                   
                                </Amount>
                            <xsl:variable name="var_unitcode_priceunit">
                                <xsl:value-of
                                    select="./urn:UnitPrice/urn:PriceUnit/urn:UnitOfMeasure"/>
                            </xsl:variable>
                            <xsl:variable name="var_priceunit_value">
                                <xsl:value-of select="./urn:UnitPrice/urn:PriceUnit/urn:Value"/>
                            </xsl:variable>
                            <!--Logic for Simple Pricing Conditions-->
                            <xsl:if test="not(exists(urn:UnitPrice/urn:PricingCondition/urn:ValidityPeriods/urn:item[urn:ConditionTypes/urn:item/urn:Name = 'PRICE']))">
                                <PricingConditions>
                                    <xsl:attribute name="actionCode">
                                        <xsl:value-of select="$var_operation"/>
                                    </xsl:attribute>
                                    <ValidityPeriod>
                                        <IntervalBoundaryTypeCode>1</IntervalBoundaryTypeCode>
                                        <StartTimePoint>
                                            <TypeCode>11</TypeCode>
                                            <Date>
                                                <xsl:value-of
                                                    select="substring($contract_header/urn:CreateDate, 1, 10)"
                                                />
                                            </Date>
                                        </StartTimePoint>
                                        <EndTimePoint>
                                            <TypeCode>11</TypeCode>
                                            <Date>9999-12-31</Date>
                                        </EndTimePoint>
                                    </ValidityPeriod>
                                    <ConditionType>
                                        <!-- LookUp to the Pricing Condition name -->
                                        <xsl:call-template name="LookupTemplate">
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anReceiverID"/>
                                            <xsl:with-param name="p_doctype"
                                                select="'PurchaseContractRequest'"/>
                                            <xsl:with-param name="p_input" select="'PRICE'"/>
                                            <xsl:with-param name="p_lookupname"
                                                select="'PricingConditions'"/>
                                            <xsl:with-param name="p_producttype"
                                                select="'AribaSourcing'"/>
                                        </xsl:call-template>
                                    </ConditionType>
                                    <Rate>
                                        <DecimalValue>
                                            <xsl:value-of select="urn:UnitPrice/urn:Amount/urn:Amount"/>     
                                        </DecimalValue>
                                        <MeasureUnitCode>
                                            <xsl:value-of select="$var_unitcode"/>
                                        </MeasureUnitCode>
                                        <CurrencyCode>
                                            <xsl:value-of
                                                select="urn:UnitPrice/urn:Amount/urn:CurrencyCode"/>
                                        </CurrencyCode>
                                    </Rate>
                                </PricingConditions>
                            </xsl:if> 
                            <xsl:for-each
                                select="./urn:UnitPrice/urn:PricingCondition/urn:ValidityPeriods/urn:item">
                                <xsl:variable name="start_date">
                                    <xsl:value-of select="./urn:FromDate"/>
                                </xsl:variable>
                                <xsl:variable name="end_date">
                                    <xsl:value-of select="./urn:ToDate"/>
                                </xsl:variable>
                                <xsl:for-each select="./urn:ConditionTypes/urn:item">
                                    <xsl:variable name="cont_type">
                                        <xsl:value-of select="./urn:Name"/>
                                    </xsl:variable>
                                    <xsl:variable name="var_condition">
                                        <!-- LookUp to the Pricing Condition name -->
                                        <xsl:call-template name="LookupTemplate">
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anReceiverID"/>
                                            <xsl:with-param name="p_doctype"
                                                select="'PurchaseContractRequest'"/>
                                            <xsl:with-param name="p_input" select="$cont_type"/>
                                            <xsl:with-param name="p_lookupname"
                                                select="'PricingConditions'"/>
                                            <xsl:with-param name="p_producttype"
                                                select="'AribaSourcing'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:if test="$var_condition != ''">
                                        <PricingConditions>
                                            <xsl:attribute name="actionCode">
                                                <xsl:value-of select="$var_operation"/>
                                            </xsl:attribute>
                                            <ValidityPeriod>
                                                <IntervalBoundaryTypeCode>1</IntervalBoundaryTypeCode>
                                                <StartTimePoint>
                                                  <TypeCode>11</TypeCode>
                                                  <Date>
                                                  <xsl:choose>
                                                  <xsl:when test="$start_date != ''">
                                                  <xsl:call-template name="S4Date">
                                                  <xsl:with-param name="p_date" select="$start_date"
                                                  />
                                                  </xsl:call-template>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring($contract_header/urn:CreateDate, 1, 10)"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </Date>
                                                </StartTimePoint>
                                                <EndTimePoint>
                                                  <TypeCode>11</TypeCode>
                                                  <Date>
                                                  <xsl:choose>
                                                  <xsl:when test="$end_date != ''">
                                                  <xsl:call-template name="S4Date">
                                                  <xsl:with-param name="p_date" select="$end_date"/>
                                                  </xsl:call-template>
                                                  </xsl:when>
                                                  <xsl:otherwise>9999-12-31</xsl:otherwise>
                                                  </xsl:choose>
                                                  </Date>
                                                </EndTimePoint>
                                            </ValidityPeriod>
                                            <ConditionType>
                                                <xsl:value-of select="$var_condition"/>
                                            </ConditionType>
                                            <xsl:variable name="var_scal_type">
                                                <xsl:value-of select="./urn:ScaleType"/>
                                            </xsl:variable>
                                            <Rate>
                                                <DecimalValue>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="(./urn:Type = 'Amount') and ($var_scal_type = '')">
                                                  <xsl:value-of
                                                  select="./urn:Value/urn:Money/urn:Amount"/>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="./urn:Type = 'Percentage' and ($var_scal_type = '')">
                                                  <xsl:value-of select="./urn:Value/urn:Percentage"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="($var_scal_type != '') and (./urn:Scales/urn:item[1]/urn:Value/urn:Money/urn:Amount != '')">
                                                  <xsl:value-of
                                                  select="./urn:Scales/urn:item[1]/urn:Value/urn:Money/urn:Amount"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="($var_scal_type != '') and (./urn:Scales/urn:item[1]/urn:Value/urn:Percentage != '')">
                                                  <xsl:value-of
                                                  select="./urn:Scales/urn:item[1]/urn:Value/urn:Percentage"
                                                  />
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </DecimalValue>
                                                <MeasureUnitCode>
                                                  <xsl:value-of select="$var_unitcode"/>
                                                </MeasureUnitCode>
                                                <CurrencyCode>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="(./urn:Type = 'Amount') and ($var_scal_type = '')">
                                                  <xsl:value-of
                                                  select="./urn:Value/urn:Money/urn:CurrencyCode"/>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="($var_scal_type != '') and (./urn:Scales/urn:item[1]/urn:Value/urn:Money/urn:CurrencyCode != '')">
                                                  <xsl:value-of
                                                  select="./urn:Scales/urn:item[1]/urn:Value/urn:Money/urn:CurrencyCode"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="(./urn:Type = 'Percentage') or (./urn:Scales/urn:item[1]/urn:Value/urn:Percentage != '')"
                                                  >%</xsl:when>
                                                  </xsl:choose>
                                                </CurrencyCode>
                                            </Rate>
                                            <xsl:for-each select="./urn:Scales/urn:item">
                                                <ScaleLine>
                                                  <xsl:attribute name="actionCode">
                                                  <xsl:value-of select="$var_operation"/>
                                                  </xsl:attribute>
                                                  <ScaleAxisStep>
                                                  <!-- Mapping 1 for Quantity scale-->
                                                  <ScaleAxisBaseCode></ScaleAxisBaseCode>
                                                  <IntervalBoundaryTypeCode>
                                                  <!-- 'A' for From scale and 'B' for To scale -->
                                                  <xsl:choose>
                                                  <xsl:when test="$var_scal_type = 'From'"
                                                  >A</xsl:when>
                                                  <xsl:when test="$var_scal_type = 'To'"
                                                  >B</xsl:when>
                                                  <xsl:otherwise/>
                                                  </xsl:choose>
                                                  </IntervalBoundaryTypeCode>
                                                  <Quantity>
                                                  <xsl:attribute name="unitCode">
                                                  <xsl:value-of select="$var_unitcode"/>
                                                  </xsl:attribute>
                                                  <xsl:if test="$var_scal_type = 'From'">
                                                  <xsl:value-of select="./urn:From"/>
                                                  </xsl:if>
                                                  <xsl:if test="$var_scal_type = 'To'">
                                                  <xsl:value-of select="./urn:To"/>
                                                  </xsl:if>
                                                  </Quantity>
                                                  </ScaleAxisStep>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="exists(urn:Value/urn:Money/urn:Amount)">
                                                  <FixedAmount>
                                                  <xsl:attribute name="currencyCode">
                                                  <xsl:value-of
                                                  select="./urn:Value/urn:Money/urn:CurrencyCode"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="./urn:Value/urn:Money/urn:Amount"/>
                                                  </FixedAmount>
                                                  </xsl:when>
                                                  <xsl:when test="exists(urn:Value/urn:Percentage)">
                                                  <Percent>
                                                  <xsl:value-of select="./urn:Value/urn:Percentage"
                                                  />
                                                  </Percent>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </ScaleLine>
                                            </xsl:for-each>
                                        </PricingConditions>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>                           
                        </Price>
                            </xsl:if>
                        <!-- Account assignment category is maintained in CrossReference,then fetch the cost center details -->
                        <!--Item Hierarchy extension: Don't populate, when it is a Parent item.-->
                        <xsl:variable name="var_category">
                            <xsl:value-of>
                                <xsl:call-template name="ReadQuote">
                                    <xsl:with-param name="p_doctype"
                                        select="'PurchaseContractRequest'"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                    <xsl:with-param name="p_attribute"
                                        select="'AccountAssignmentCat'"/>
                                </xsl:call-template>
                            </xsl:value-of>
                        </xsl:variable>
                        <xsl:if  test="$var_isOutline != 'true' and ./urn:ItemCategory != 'consignment'">
                            <!--IG-43272: To handle AccountAssignment for Service material, urn:ProductType = 'service' condition is introduced below-->
                            <xsl:if test="./urn:BuyerPartID = '' or (./urn:BuyerPartID != '' and ($var_category != 'U' or urn:ProductType = 'service'))">
                                <AccountAssignment>                               
                                <xsl:variable name="var_account">
                                    <xsl:value-of>
                                        <xsl:call-template name="ReadQuote">
                                            <xsl:with-param name="p_doctype"
                                                select="'PurchaseContractRequest'"/>
                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                            <xsl:with-param name="p_attribute" select="'GLAccount'"/>
                                        </xsl:call-template>
                                    </xsl:value-of>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="$var_category != 'U'">
                                        <AccountAssignmentCategory>
                                            <xsl:value-of select="$var_category"/>
                                        </AccountAssignmentCategory>
                                        <AccountAssignmentLine>
                                            <ActionCode>
                                                <xsl:value-of select="$var_operation"/>
                                            </ActionCode>
                                            <xsl:choose>
                                                <xsl:when test="$var_category = 'K'">
                                                    <!-- Cost Center-->
                                                    <CostCenter>
                                                        <xsl:value-of>
                                                            <xsl:call-template name="ReadQuote">
                                                                <xsl:with-param name="p_doctype"
                                                                    select="'PurchaseContractRequest'"/>
                                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                                <xsl:with-param name="p_attribute"
                                                                    select="'CostCenter'"/>
                                                            </xsl:call-template>
                                                        </xsl:value-of>
                                                    </CostCenter>
                                                    <GLAccount>
                                                        <xsl:value-of select="$var_account"/>
                                                    </GLAccount>
                                                </xsl:when>
                                                <xsl:when test="$var_category = 'F'">
                                                    <GLAccount>
                                                        <xsl:value-of select="$var_account"/>
                                                    </GLAccount>
                                                    <OrderID>
                                                        <xsl:value-of>
                                                            <xsl:call-template name="ReadQuote">
                                                                <xsl:with-param name="p_doctype"
                                                                    select="'PurchaseContractRequest'"/>
                                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                                <xsl:with-param name="p_attribute"
                                                                    select="'Order'"/>
                                                            </xsl:call-template>
                                                        </xsl:value-of>
                                                    </OrderID>
                                                </xsl:when>
                                                <xsl:when test="$var_category = 'P'">
                                                    <GLAccount>
                                                        <xsl:value-of select="$var_account"/>
                                                    </GLAccount>
                                                    <ProjectReference>
                                                        <ProjectElementID>
                                                            <xsl:value-of>
                                                                <xsl:call-template name="ReadQuote">
                                                                    <xsl:with-param name="p_doctype"
                                                                        select="'PurchaseContractRequest'"/>
                                                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                                                    <xsl:with-param name="p_attribute"
                                                                        select="'WBSElement'"/>
                                                                </xsl:call-template>
                                                            </xsl:value-of>
                                                        </ProjectElementID>
                                                    </ProjectReference>
                                                </xsl:when>
                                            </xsl:choose>
                                        </AccountAssignmentLine>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- When there is 'U' Account Assignement Category is maintained in Cross Reference -->
                                        <AccountAssignmentCategory>U</AccountAssignmentCategory>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </AccountAssignment>
                            </xsl:if>
                        </xsl:if>
                        <!-- Incoterms and Location -->
                        <xsl:if test="string-length(normalize-space(./urn:Incoterm/urn:Classification)) > 0 or string-length(normalize-space(./urn:Incoterm/urn:Location1)) > 0">
                            <Incoterms>
                                <IncotermsClassification>
                                <xsl:value-of select="./urn:Incoterm/urn:Classification"/>
                            </IncotermsClassification>
                            <IncotermsLocation1>
                                <xsl:value-of select="./urn:Incoterm/urn:Location1"/>
                            </IncotermsLocation1>
                        </Incoterms>
                            </xsl:if>
                    </PurchaseContractItem>
                </xsl:for-each>
            </PurchaseContract>
        </n0:PurchaseContractRequest>
    </xsl:template>
</xsl:stylesheet>
