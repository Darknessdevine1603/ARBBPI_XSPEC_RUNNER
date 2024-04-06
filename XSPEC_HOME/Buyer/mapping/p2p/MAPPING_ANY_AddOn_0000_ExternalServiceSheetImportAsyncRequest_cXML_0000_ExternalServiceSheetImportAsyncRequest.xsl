<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n1="urn:sap-com:document:sap:rfc:functions"
    xmlns:tns="urn:sap-com:document:sap:soap:functions:mc-style"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0"
    xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:urn="urn:Ariba:Buyer:vsap">
    <!-- CI-2450 : XSLT Quality Improvement -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
    <!--<xsl:include href="../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
    <xsl:param name="p2pTarget"/>
    <xsl:param name="p2pTimezone"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSenderID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSenderID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_compcode">
        <xsl:value-of
            select="/n0:ERPServiceEntrySheetRequest/ServiceAcknowledgement/BillToParty/InternalID"/>
    </xsl:variable>
    <xsl:template match="n0:ERPServiceEntrySheetRequest">
        <urn:ExternalServiceSheetImportAsyncRequest>
            <xsl:attribute name="partition">
                <xsl:value-of select="MessageHeader/@partition"/>
            </xsl:attribute>
            <xsl:attribute name="variant">
                <xsl:value-of select="MessageHeader/@variant"/>
            </xsl:attribute>
            <urn:ServiceSheet_ServiceSheetImportWS_Item>
                <xsl:for-each select="ServiceAcknowledgement">
                    <urn:item>
                        <!-- CI-2450 : XSLT Quality Improvement -->
                        <xsl:if test="string-length(normalize-space(Requester)) > 0">
                            <urn:Contacts>
                                <urn:item>
                                    <urn:Name>
                                        <xsl:value-of select="Requester"/>
                                    </urn:Name>
                                </urn:item>
                            </urn:Contacts>
                        </xsl:if>
                        <urn:FieldContractor>
                            <urn:Name>
                                <xsl:value-of select="Requester"/>
                            </urn:Name>
                        </urn:FieldContractor>
                        <xsl:if test="FieldEngineer">
                            <urn:FieldEngineer>
                                <urn:Name>
                                    <xsl:value-of select="FieldEngineer"/>
                                </urn:Name>
                            </urn:FieldEngineer>
                        </xsl:if>
                        <urn:ImportedCommentStaging>
                            <xsl:call-template name="CommentsFillProxyOut">
                                <xsl:with-param name="p_aribaComment" select="../AribaComment"/>
                                <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                <xsl:with-param name="p_pd" select="$v_pd"/>
                            </xsl:call-template>
                        </urn:ImportedCommentStaging>
                        <!--  <xsl:if test="Item[1]/PurchasingContractReference/ID">
                            <urn:MasterAgreement>
                                <urn:UniqueName>
                                    <xsl:value-of select="Item[1]/PurchasingContractReference/ID"/>
                                </urn:UniqueName>
                            </urn:MasterAgreement>
                        </xsl:if>-->
                        <xsl:if test="Item[1]/PurchaseOrderReference/ID">
                            <urn:Order>
                                <urn:OrderID>
                                    <xsl:value-of select="Item[1]/PurchaseOrderReference/ID"/>
                                </urn:OrderID>
                            </urn:Order>
                        </xsl:if>
                        <urn:POLineNumber>
                            <xsl:value-of select="Item[1]/PurchaseOrderReference/ItemID"/>
                        </urn:POLineNumber>
                        <xsl:if test="ValidityPeriod/EndDate">
                            <urn:PeriodEndDate>
                                <xsl:value-of select="ValidityPeriod/EndDate"/>
                            </urn:PeriodEndDate>
                        </xsl:if>
                        <xsl:if test="ValidityPeriod/StartDate">
                            <urn:PeriodStartDate>
                                <xsl:value-of select="ValidityPeriod/StartDate"/>
                            </urn:PeriodStartDate>
                        </xsl:if>
                        <urn:ReceiptItems>
                            <xsl:for-each select="Item">
                                <xsl:variable name="v_dist">
                                    <xsl:value-of select="Distrib"/>
                                </xsl:variable>
                                <urn:item>
                                    <urn:AccountCategory>
                                        <urn:UniqueName>
                                            <xsl:value-of
                                                select="/n0:ERPServiceEntrySheetRequest/ServiceAcknowledgement/Accasscat"
                                            />
                                        </urn:UniqueName>
                                    </urn:AccountCategory>
                                    <xsl:choose>
                                        <xsl:when test="ProcessingTypeCode eq 'U'">
                                            <urn:Adhoc>
                                                <xsl:value-of select="'true'"/>
                                            </urn:Adhoc>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <urn:Adhoc>
                                                <xsl:value-of select="'false'"/>
                                            </urn:Adhoc>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <urn:ExternalSubtotalAmount>
                                        <urn:Amount>
                                            <xsl:value-of select="Price/Amount"/>
                                        </urn:Amount>
                                        <urn:Currency>
                                            <xsl:value-of select="Price/Amount/@currencyCode"/>
                                        </urn:Currency>
                                    </urn:ExternalSubtotalAmount>
                                    <xsl:choose>
                                        <xsl:when test="ProcessingTypeCode eq 'P'">
                                            <urn:FromPO>
                                                <xsl:value-of select="'true'"/>
                                            </urn:FromPO>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <urn:FromPO>
                                                <xsl:value-of select="'false'"/>
                                            </urn:FromPO>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <urn:ImportedAccountingsStaging>
                                        <urn:SplitAccountings>
                                            <xsl:for-each
                                                select="AccountAssignment/AccountingCodingBlockAssignment">
                                                <urn:item>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                                  <xsl:if test="string-length(normalize-space(NetworkID)) > 0">
                                                  <urn:ActivityNumber>
                                                  <urn:Network>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="$v_compcode"/>    
                                                  </urn:UniqueName> 
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="NetworkID"/>    
                                                  </urn:UniqueName>    
                                                  </urn:Network>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="ActivityNumber"/>
                                                  </urn:UniqueName>    
                                                  </urn:ActivityNumber>
                                                  </xsl:if>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->  
                                                  <xsl:if test="Amount">
                                                  <urn:Amount>
                                                  <urn:Amount>
                                                  <xsl:value-of select="Amount"/>
                                                  </urn:Amount>
                                                  </urn:Amount>
                                                  </xsl:if>
                                                  <xsl:if test="FixedAssetReference">
                                                  <urn:Asset>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="$v_compcode"/>
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:SubNumber>
                                                  <xsl:value-of
                                                  select="FixedAssetReference/FixedAssetID"/>
                                                  </urn:SubNumber>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="FixedAssetReference/MasterFixedAssetID"/>
                                                  </urn:UniqueName>
                                                  </urn:Asset>
                                                  </xsl:if>
                                                  <xsl:if test="CostCentreID">
                                                  <urn:CostCenter>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="$v_compcode"/>
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="CostCentreID"/>
                                                  </urn:UniqueName>
                                                  </urn:CostCenter>
                                                  </xsl:if>
                                                  <xsl:if test="GeneralLedgerAccountReference/ID">
                                                  <urn:GeneralLedger>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="$v_compcode"/>
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="GeneralLedgerAccountReference/ID"/>
                                                  </urn:UniqueName>
                                                  </urn:GeneralLedger>
                                                  </xsl:if>
                                                  <xsl:if test="InternalOrderID">
                                                  <urn:InternalOrder>
                                                      <!-- IG-24909-->
                                                      <!-- Added UniqueName mapping as per P2P WSDL-->
                                                      <urn:UniqueName>
                                                          <xsl:value-of select="InternalOrderID"/>
                                                      </urn:UniqueName>
                                                      <!-- IG-24909-->
                                                  </urn:InternalOrder>
                                                  </xsl:if>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                                  <xsl:if test="string-length(normalize-space(NetworkID)) > 0">
                                                  <urn:Network>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="$v_compcode"/>
                                                  </urn:UniqueName>    
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="NetworkID"/>
                                                  </urn:UniqueName>    
                                                  </urn:Network>
                                                  </xsl:if>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->                                                      
                                                  <xsl:choose>
                                                  <xsl:when test="Percent">
                                                  <urn:Percentage>
                                                  <xsl:value-of select="Percent"/>
                                                  </urn:Percentage>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <urn:Percentage>
                                                  <xsl:value-of select="'100'"/>
                                                  </urn:Percentage>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <urn:Quantity>
                                                  <xsl:value-of select="Quantity"/>
                                                  </urn:Quantity>
                                                  <urn:SAPSerialNumber>
                                                  <xsl:value-of select="SerialNumber"/>
                                                  </urn:SAPSerialNumber>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if
                                                  test="string-length(normalize-space($v_dist)) > 0">
                                                  <urn:Type>
                                                  <urn:UniqueName>
                                                  <xsl:choose>
                                                  <xsl:when test="$v_dist = '1'">
                                                  <xsl:value-of select="'_Quantity'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_dist = '2'">
                                                  <xsl:value-of select="'_Percentage'"/>
                                                  </xsl:when>
                                                  <xsl:when test="$v_dist = '3'">
                                                  <xsl:value-of select="'_Amount'"/>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </urn:UniqueName>
                                                  </urn:Type>
                                                  </xsl:if>
                                                  <xsl:if test="ProjectReference/ProjectID">
                                                  <urn:WBSElement>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="ProjectReference/ProjectID"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:WBSElement>
                                                  </xsl:if>
                                                  <urn:custom>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if test="string-length(normalize-space(BudgetPeriod)) > 0">
                                                  <urn:CustomBudgetPeriod>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="BudgetPeriod"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomBudgetPeriod>
                                                  </xsl:if>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if test="string-length(normalize-space(CommitItem)) > 0">
                                                  <urn:CustomCommitmentItem>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="CommitItem"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomCommitmentItem>
                                                  </xsl:if>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if test="string-length(normalize-space(EarmFundDoc)) > 0">
                                                  <urn:CustomEarmarkedFundsDocument>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="EarmFundDoc"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomEarmarkedFundsDocument>
                                                  </xsl:if>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if test="string-length(normalize-space(EarmFundItem)) > 0">
                                                  <urn:CustomEarmarkedFundsLineItem>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="EarmFundItem"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomEarmarkedFundsLineItem>
                                                  </xsl:if>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if
                                                  test="string-length(normalize-space(FundsManagementFunctionalAreaID)) > 0">
                                                  <urn:CustomFunctionalArea>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="FundsManagementFunctionalAreaID"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomFunctionalArea>
                                                  </xsl:if>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if
                                                  test="string-length(normalize-space(FundsManagementFundID)) > 0">
                                                  <urn:CustomFund>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="FundsManagementFundID"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomFund>
                                                  </xsl:if>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if
                                                  test="string-length(normalize-space(FundsManagementCentreID)) > 0">
                                                  <urn:CustomFundsCenter>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="FundsManagementCentreID"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomFundsCenter>
                                                  </xsl:if>
                                                  <!-- CI-2450 : XSLT Quality Improvement -->
                                                  <xsl:if test="string-length(normalize-space(GrantID)) > 0">
                                                  <urn:CustomGrant>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="GrantID"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomGrant>
                                                  </xsl:if>
                                                  </urn:custom>
                                                </urn:item>
                                            </xsl:for-each>
                                        </urn:SplitAccountings>
                                    </urn:ImportedAccountingsStaging>
                                    <xsl:if test="PurchasingContractReference/ID">
                                        <urn:MasterAgreement>
                                            <urn:UniqueName>
                                                <xsl:value-of
                                                  select="PurchasingContractReference/ID"/>
                                            </urn:UniqueName>
                                        </urn:MasterAgreement>
                                    </xsl:if>
                                    <urn:POLineNumber>
                                        <xsl:value-of select="PurchaseOrderReference/ItemSrvID"/>
                                    </urn:POLineNumber>
                                    <urn:ProductDescription>
                                        <urn:CommonCommodityCode>
                                            <urn:UniqueName>
                                                <xsl:value-of select="MaterialGroup"/>
                                            </urn:UniqueName>
                                        </urn:CommonCommodityCode>
                                        <urn:Description>
                                            <xsl:value-of select="Description"/>
                                        </urn:Description>
                                        <urn:Price>
                                            <urn:Amount>
                                                <xsl:value-of select="UnitPrice"/>
                                            </urn:Amount>
                                            <urn:Currency>
                                                <urn:UniqueName>
                                                  <xsl:value-of select="UnitPrice/@currencyCode"/>
                                                </urn:UniqueName>
                                            </urn:Currency>
                                        </urn:Price>
                                        <urn:SupplierPartNumber>
                                            <xsl:value-of select="Product/SellerID"/>
                                        </urn:SupplierPartNumber>
                                        <urn:UnitOfMeasure>
                                            <urn:UniqueName>
                                                <xsl:value-of select="Quantity/@unitCode"/>
                                            </urn:UniqueName>
                                        </urn:UnitOfMeasure>
                                    </urn:ProductDescription>
                                    <urn:ServiceLineNumber>
                                        <xsl:value-of select="ServiceLineNo"/>
                                    </urn:ServiceLineNumber>
                                    <urn:ServicedQuantity>
                                        <xsl:value-of select="Quantity"/>
                                    </urn:ServicedQuantity>
                                </urn:item>
                            </xsl:for-each>
                        </urn:ReceiptItems>
                        <urn:RequesterPartnerContact>
                            <urn:Name>
                                <xsl:value-of select="BillToParty[1]/Address/PersonName/BirthName"/>
                            </urn:Name>
                        </urn:RequesterPartnerContact>
                        <urn:ServiceDescription>
                            <xsl:value-of select="Description"/>
                        </urn:ServiceDescription>
                        <urn:ServiceEntryDate>
                            <xsl:value-of select="CreationDateTime"/>
                        </urn:ServiceEntryDate>
                        <urn:ServiceEntryID>
                            <xsl:value-of select="AribaDocumentID"/>
                        </urn:ServiceEntryID>
                        <urn:SubtotalAmount>
                            <urn:Amount>
                                <xsl:value-of select="TotalAmount"/>
                            </urn:Amount>
                            <urn:Currency>
                                <xsl:value-of select="TotalAmount/@currencyCode"/>
                            </urn:Currency>
                        </urn:SubtotalAmount>
                        <urn:Supplier>
                            <urn:UniqueName>
                                <xsl:value-of select="VendorParty/InternalID"/>
                            </urn:UniqueName>
                        </urn:Supplier>
                        <urn:SupplierLocation>
                            <urn:ContactID>
                                <xsl:value-of select="SupplierLocation/ID"/>
                            </urn:ContactID>
                            <urn:UniqueName>
                                <xsl:value-of select="SupplierLocation/ID"/>
                            </urn:UniqueName>
                        </urn:SupplierLocation>
                    </urn:item>
                </xsl:for-each>
            </urn:ServiceSheet_ServiceSheetImportWS_Item>
        </urn:ExternalServiceSheetImportAsyncRequest>
    </xsl:template>
</xsl:stylesheet>
