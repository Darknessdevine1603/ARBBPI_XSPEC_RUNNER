<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:n1="http://sap.com/xi/ARBCIG1"
    xpath-default-namespace="urn:Ariba:Buyer:vsap"
    xmlns:prx="urn:sap.com:proxy:NWC:/1SAI/TXS5702B25F6DD7952A79BA:700:2010/02/19"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">                                                                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
      <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                              
      <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
    <!--<xsl:include href="../../../../BUYER_CONTENT/common/FORMAT_Apps_0000_AddOn_0000.xsl"/>-->  
    <!-- IG-35791: Correct mapping of SupplierPartNumber in SES -->    
    <xsl:param name="anAddOnCIVersion"/>
    <xsl:variable name="v_supportsp17onwards">
        <xsl:call-template name="Check_SupportVersion">
            <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
            <xsl:with-param name="p_suppversion" select="'17'"/>
        </xsl:call-template>
    </xsl:variable>
    <!-- IG-35791: Correct mapping of SupplierPartNumber in SES -->  
    <xsl:template match="ServiceSheetExportRequest">
<!--        Service Entry Sheet Type: 1. Create, 2. Cancel or Force Reject-->
        <n1:ServiceEntrySheetRequest>
            <MessageHeader>
                <xsl:attribute name="partition">
                    <xsl:value-of select="@partition"/>
                </xsl:attribute>
                <xsl:attribute name="variant">
                    <xsl:value-of select="@variant"/>
                </xsl:attribute>
                <CreationDateTime>
                    <xsl:value-of select="current-dateTime()"/>
                </CreationDateTime>
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="'SystemID'"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <ServiceAcknowledgement>
                <ID>
                    <xsl:value-of select="'ARIBA_P2P'"/>
                </ID>
                <CreationDateTime>
                    <xsl:call-template name="erpDate">
                        <xsl:with-param name="p2pDate"
                            select="ServiceSheet_ServiceSheetHeaderExportWS_Item/item/ServiceEntryDate"
                        />
                    </xsl:call-template>
                </CreationDateTime>
                <PostingDateTime>
                    <xsl:call-template name="erpDate">
                        <xsl:with-param name="p2pDate"
                            select="ServiceSheet_ServiceSheetHeaderExportWS_Item/item/ServiceEntryDate"
                        />
                    </xsl:call-template>
                </PostingDateTime>
                <Description>
                    <xsl:value-of
                        select="ServiceSheet_ServiceSheetHeaderExportWS_Item/item/ServiceEntryID"/>
                </Description>
                <xsl:for-each
                    select="ServiceSheet_ServiceSheetLineItemExportWS_Item/item/ReceiptItems/item">
                    <xsl:variable name="v_srit" select="position()"/>
                    <Item>
                        <ID>
                            <xsl:if test="LineItem/Parent">
                                <xsl:value-of select="LineItem/SAPPOLineNumber"/>
                            </xsl:if>
                        </ID>
                        <!--There are 2 new fields from AN & P2P need to be mapped for SES inbound, 
                            there is no such fields exists in SES Inbound proxy/ ES so we are mapping 
                            this two fields in existing structure -->
                        <!--FromPO field map to  FinalIndicator-->
                        <FinalIndicator>
                            <xsl:value-of select="FromPO"/>
                        </FinalIndicator>
                        <!--AdHoc field map to  FinalIndicator-->
                        <ByBidderProvidedIndicator>
                            <xsl:value-of select="Adhoc"/>
                        </ByBidderProvidedIndicator>
                        <Distrib>
                            <xsl:for-each
                                select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetAccountingExportWS_Item/item/ReceiptItems/item[$v_srit]/Accountings/SplitAccountings/item[position() = 1]">
                                <xsl:choose>
                                    <xsl:when test="Type/UniqueName = '_Quantity'">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:when>
                                    <xsl:when test="Type/UniqueName = '_Amount'">
                                        <xsl:value-of select="'3'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="''"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </Distrib>
                        <xsl:variable name="v_curr">
                            <xsl:value-of select="ProductDescription/Price/Currency/UniqueName"/>
                        </xsl:variable>
                        <DeliveryPeriod>
                            <StartDateTime>
                                <xsl:call-template name="erpDate">
                                    <xsl:with-param name="p2pDate"
                                        select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/PeriodStartDate"
                                    />
                                </xsl:call-template>
                            </StartDateTime>
                            <EndDateTime>
                                <xsl:call-template name="erpDate">
                                    <xsl:with-param name="p2pDate"
                                        select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/PeriodEndDate"
                                    />
                                </xsl:call-template>
                            </EndDateTime>
                        </DeliveryPeriod>
                        <Quantity>
                            <xsl:attribute name="unitCode">
                                <xsl:value-of
                                    select="upper-case(ProductDescription/UnitOfMeasure/UniqueName)"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="format-number(ServicedQuantity, '0.000')"/>                                       <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        </Quantity>
                        <Price>
                            <Amount>
                                <xsl:attribute name="currencyCode">
                                    <xsl:value-of
                                        select="ProductDescription/Price/Currency/UniqueName"/>
                                </xsl:attribute>
                                <xsl:if test="ProductDescription/Price/Amount">
                                    <xsl:value-of
                                        select="format-number(ProductDescription/Price/Amount, '0.00')"
                                    />
                                </xsl:if>
                            </Amount>
                        </Price>
                        <Description>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(ProductDescription/Description)) > 0">               <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <!--IG-32145 : Removal of extra white-space dur to normalize-space function.
                                    normalize-space can be useful to determine whether a value exists or not. Hence the function is removed in returning statement.-->
                                    <!--<xsl:value-of select="substring(normalize-space(ProductDescription/Description), 1, 80)"/>-->
                                    <xsl:value-of select="substring(ProductDescription/Description, 1, 80)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'Constant'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </Description>
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <HierarchyRelationship>
                            <ParentItemID>
                                <xsl:value-of select="ServiceLineNumber"/>
                            </ParentItemID>
                        </HierarchyRelationship>   
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <Product>
                            <!-- IG-35791: Correct mapping of SupplierPartNumber in SES -->
                            <xsl:if test="string-length(normalize-space(SupplierPartNumber)) > 0 and $v_supportsp17onwards = 'true'">
                                <SellerID>
                                    <xsl:value-of select="substring(SupplierPartNumber,1,60)"/>
                                </SellerID>
                            </xsl:if>
                            <!-- IG-35791: Correct mapping of SupplierPartNumber in SES -->
                        </Product>
                        <!--Contract is Mapped to ItemId field-->
                        <!-- IG-19740-->
                        <PurchasingContractReference>
                            <ID>
                                <xsl:value-of select="OutlineRootNumber"/>
                            </ID>
                            <!--IG-26418-->
                            <!-- Map only if contract length is 10 and it is a number,this is to handle
                                P2P originated contract having description in this field-->
                            <xsl:if test="string-length(normalize-space(MasterAgreement/Name)) = 10 and 
                                string(number(MasterAgreement/Name))!= 'NaN'"> 
                            <ItemID>
                                <xsl:value-of select="MasterAgreement/Name"/>
                            </ItemID>
                            </xsl:if>
                            <!--IG-26418-->
                        </PurchasingContractReference>
                        <!-- IG-19740-->
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <PurchaseOrderReference>
                            <ID>
                                <xsl:value-of
                                    select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/PurchaseOrder/OrderID"
                                />
                            </ID>
                            <ItemID>
                                <xsl:choose>
                                    <xsl:when test="LineItem/Parent">
                                        <xsl:value-of select="LineItem/Parent/SAPPOLineNumber"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="LineItem/SAPPOLineNumber"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ItemID>
                        </PurchaseOrderReference>                        
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <xsl:if
                            test="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetAccountingExportWS_Item">
                            <xsl:variable name="v_pos" select="position()"/>
                            <AccountAssignment>
                                <xsl:for-each
                                    select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetAccountingExportWS_Item/item/ReceiptItems/item[$v_pos]/Accountings/SplitAccountings/item">
                                    <AccountingCodingBlockAssignment>
                                        <OrdinalNumberValue>
                                            <xsl:value-of select="SAPSerialNumber"/>
                                        </OrdinalNumberValue>
                                        <CostCentreID>
                                            <xsl:value-of select="CostCenter/UniqueName"/>
                                        </CostCentreID>
                                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <GeneralLedgerAccountReference>
                                            <ID>
                                                <xsl:value-of select="GeneralLedger/UniqueName"/>
                                            </ID>
                                        </GeneralLedgerAccountReference>
                                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <ProjectReference>
                                            <ProjectID>
                                                <xsl:value-of select="WBSElement/UniqueName"/>
                                            </ProjectID>
                                        </ProjectReference>
                                        <InternalOrderID>
                                            <xsl:value-of select="InternalOrder/UniqueName"/>
                                        </InternalOrderID>
                                        <FixedAssetReference>
                                            <MasterFixedAssetID>
                                                <xsl:value-of select="Asset/UniqueName"/>
                                            </MasterFixedAssetID>
                                            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <FixedAssetID>
                                                <xsl:value-of select="Asset/SubNumber"/>
                                            </FixedAssetID>
                                            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        </FixedAssetReference>
                                        <!--IG-28021: Mapping   b and Activity for Account assignment -->
                                        <xsl:if test="string-length(normalize-space(Network/UniqueName)) > 0">
                                        <NetworkID>
                                            <xsl:value-of select="Network/UniqueName"/>
                                        </NetworkID>    
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(ActivityNumber/UniqueName)) > 0">
                                        <ActivityNumber>
                                            <xsl:value-of select="ActivityNumber/UniqueName"/>
                                        </ActivityNumber>
                                        </xsl:if>     
                                        <!--IG-28021: Mapping Network and Activity for Account assignment -->                                        
                                    </AccountingCodingBlockAssignment>
                                </xsl:for-each>
                            </AccountAssignment>
                            <AccountAssignmentValues>
                                <xsl:for-each
                                    select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetAccountingExportWS_Item/item/ReceiptItems/item[$v_pos]/Accountings/SplitAccountings/item">
                                    <AccAssValues>
                                        <PackageNumber>
                                            <xsl:value-of select="'2'"/>
                                        </PackageNumber>
                                        <LineNumber>
                                            <xsl:value-of
                                                select="ServiceSheetItem/NumberInCollection"/>
                                        </LineNumber>
                                        <ServiceNumberLine>
                                            <xsl:value-of select="NumberInCollection"/>
                                        </ServiceNumberLine>
                                        <Percentage>
                                            <xsl:choose>
                                                <xsl:when test="AdjustedPercentageForSplits != 0 ">
                                                    <xsl:value-of select="format-number(AdjustedPercentageForSplits, '000.0')"/>                            <!-- IG-24744: ServiceSheetExportRequest-Percentage not converted -->
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="format-number(Percentage, '000.0')"/>                                             <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </Percentage>
                                        <SerialNumber>
                                            <xsl:value-of select="SAPSerialNumber"/>
                                        </SerialNumber>
                                        <Quantity>
                                            <xsl:value-of select="format-number(Quantity, '0.000')"/>                                                       <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        </Quantity>
                                        <Amount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of select="$v_curr"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="format-number(Amount/Amount, '0.00')"/>                                                   <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        </Amount>
                                    </AccAssValues>
                                </xsl:for-each>
                            </AccountAssignmentValues>
                        </xsl:if>
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <ServicePerformerParty>
                            <InternalID>
                                <xsl:value-of
                                    select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/UniqueName"
                                />
                            </InternalID>
                            <BuyerID>
                                <xsl:value-of
                                    select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/RequesterPartnerContact/Name"
                                />
                            </BuyerID>
                            <SellerID>
                                <xsl:choose>
                                    <xsl:when
                                        test="string-length(/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/FieldEngineer/Name) > 0">
                                        <xsl:value-of
                                            select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/FieldEngineer/Name"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="/ServiceSheetExportRequest/ServiceSheet_ServiceSheetHeaderExportWS_Item/item/FieldContractor/Name"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </SellerID>
                        </ServicePerformerParty>
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in outputs -->  
                    </Item>
                </xsl:for-each>
            </ServiceAcknowledgement>
        </n1:ServiceEntrySheetRequest>
    </xsl:template>
    <xsl:template match="ServiceSheetStatusAsyncExportRequest">
                <n1:ServiceEntrySheetRequest>
                    <MessageHeader>
                        <xsl:attribute name="partition">
                            <xsl:value-of select="@partition"/>
                        </xsl:attribute>
                        <xsl:attribute name="variant">
                            <xsl:value-of select="@variant"/>
                        </xsl:attribute>
                        <CreationDateTime>
                            <xsl:value-of select="current-dateTime()"/>
                        </CreationDateTime>
                        <RecipientParty>
                            <InternalID>
                                <xsl:value-of select="'SystemID'"/>
                            </InternalID>
                        </RecipientParty>
                    </MessageHeader>
                    <ServiceAcknowledgement>
                        <ActionCode>
                            <xsl:value-of select="'03'"/>
                        </ActionCode>
                        <ID>
                            <xsl:value-of select="'ARIBA_P2P'"/>
                        </ID>
                        <SellerID>
                            <xsl:value-of select="ServiceSheet_ServiceSheetStatusRealTimeExport_Item/item/UniqueName"/>
                        </SellerID>                       
                        <ERPEntrysheetID>
                            <xsl:value-of select="ServiceSheet_ServiceSheetStatusRealTimeExport_Item/item/ERPServiceSheetID"/>
                        </ERPEntrysheetID>
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output --> 
                        <Description>
                            <xsl:value-of select="ServiceSheet_ServiceSheetStatusRealTimeExport_Item/item/ServiceEntryID"/>
                        </Description>                        
                        <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->                         
                    </ServiceAcknowledgement>
                </n1:ServiceEntrySheetRequest>  
    </xsl:template>
    <xsl:template name="erpDate">
        <xsl:param name="p2pDate"/>
        <xsl:choose>
            <xsl:when test="$p2pDate">
                <xsl:value-of select="substring(replace(string($p2pDate), '-', ''), 1, 8)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring(replace(string(current-date()), '-', ''), 1, 8)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
