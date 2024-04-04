<?xml version="1.0" encoding="UTF-8"?>  
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n1="urn:sap-com:document:sap:rfc:functions"
    xmlns:tns="urn:sap-com:document:sap:soap:functions:mc-style"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0"
    xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:urn="urn:Ariba:Buyer:vsap">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>  <!-- IG-36877 : XSLT Quality Improvement -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
<!--    <xsl:include href="../../../../BUYER_CONTENT/common/FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
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
        <!--        <xsl:value-of select="'ParameterCrossReference.xml'"/>-->
    </xsl:variable>
    <xsl:template match="n0:ERPRequisitionRequest">
        <urn:RequisitionImportAsyncPullRequest>
            <urn:Requisition_RequisitionImportPull_Item>
                <xsl:for-each select="RequisitionDetails">
                    <urn:item>
                        <urn:CompanyCode>
                            <urn:UniqueName>
                                <xsl:value-of select="CompanyCode"/>
                            </urn:UniqueName>
                        </urn:CompanyCode>
                        <urn:DefaultLineItem>
                            <urn:DeliverTo>
                                <xsl:value-of select="DeliverTo"/>
                            </urn:DeliverTo>
                            <urn:NeedBy>
                                <xsl:value-of select="ItemDetails[1]/NeedByDate"/>
                            </urn:NeedBy>
                        </urn:DefaultLineItem>
                        <urn:ERPRequisitionID>
                            <xsl:value-of select="DocumentID"/>
                        </urn:ERPRequisitionID>
                        <urn:ImportedHeaderCommentStaging>
                            <xsl:call-template name="CommentsFillProxyOut">
                                <xsl:with-param name="p_aribaComment" select="AribaComment"/>
                                <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                <xsl:with-param name="p_pd" select="$v_pd"/>
                            </xsl:call-template>
                        </urn:ImportedHeaderCommentStaging>
                        <urn:LineItems>
                            <xsl:for-each select="ItemDetails">
                                <urn:item>
                                    <urn:BuyerPartNumber>
                                        <xsl:value-of select="Material"/>
                                    </urn:BuyerPartNumber>
                                    <urn:CommodityCode>
                                        <urn:UniqueName>
                                            <xsl:value-of select="MaterialGrp"/>
                                        </urn:UniqueName>
                                    </urn:CommodityCode>
                                    <xsl:if
                                        test="string-length(normalize-space(ContractLimit/ContractId)) > 0">  <!-- IG-36877 : XSLT Quality Improvement -->
                                        <urn:ContractIdStaging>
                                            <xsl:value-of select="ContractLimit/ContractId"/>
                                        </urn:ContractIdStaging>
                                    </xsl:if>
                                    <urn:Description>
                                        <urn:Description>
                                            <xsl:value-of select="ShortText"/>
                                        </urn:Description>
                                        <xsl:if test="string-length(normalize-space(ManPartNumber)) > 0">     <!-- IG-36877 : XSLT Quality Improvement -->
                                            <urn:ManPartNumber>
                                                <xsl:value-of select="ManPartNumber"/>
                                            </urn:ManPartNumber>
                                        </xsl:if>
                                        <urn:Price>
                                            <urn:Amount>
                                                <xsl:value-of select="Amount/Amount"/>
                                            </urn:Amount>
                                            <urn:Currency>
                                                <urn:UniqueName>
                                                  <xsl:value-of select="Amount/Amount/@currencyCode"
                                                  />
                                                </urn:UniqueName>
                                            </urn:Currency>
                                        </urn:Price>
                                        <!--IG-33122 Price Unit addition ERP initiated Purchase Requisitions-->
                                        <!--IG-35009 ERP initiated Requisition PriceBasisQuantity Validation for SP14 and below-->
                                        <xsl:if test="string-length(normalize-space(PriceUnit)) > 0">
                                            <urn:PriceBasisQuantity>
                                                <xsl:value-of select="normalize-space(PriceUnit)"/>
                                            </urn:PriceBasisQuantity>
                                        </xsl:if>    
                                        <!--IG-35009 ERP initiated Requisition PriceBasisQuantity Validation for SP14 and below-->
                                        <!--IG-33122 Price Unit addition ERP initiated Purchase Requisitions-->
                                        <xsl:if test="string-length(normalize-space(SupplierPartAuxiliaryID)) > 0"> <!-- IG-36877 : XSLT Quality Improvement -->
                                            <urn:SupplierPartAuxiliaryID>
                                                <xsl:value-of select="SupplierPartAuxiliaryID"/>
                                            </urn:SupplierPartAuxiliaryID>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(VendorMaterial)) > 0"> <!-- IG-36877 : XSLT Quality Improvement -->
                                            <urn:SupplierPartNumber>
                                                <xsl:value-of select="VendorMaterial"/>
                                            </urn:SupplierPartNumber>
                                        </xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="IsServiceChild = 'true'">
                                                <xsl:if test="Amount/BaseQuantity/@unitCode">
                                                  <urn:UnitOfMeasure>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Amount/BaseQuantity/@unitCode"/>
                                                  </urn:UniqueName>
                                                  </urn:UnitOfMeasure>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="Quantity/@unitCode">
                                                  <urn:UnitOfMeasure>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="Quantity/@unitCode"/>
                                                  </urn:UniqueName>
                                                  </urn:UnitOfMeasure>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </urn:Description>
                                    <urn:ERPLineItemNumber>
                                        <xsl:value-of select="ERPLineItemNumber"/>
                                    </urn:ERPLineItemNumber>
                                    <xsl:if test="ItemCategory = 9">
                                        <urn:ImportServiceDetailsStaging>
                                            <xsl:if test="ContractLimit/Amount">
                                                <urn:ContractLimit>
                                                  <urn:Amount>
                                                  <xsl:value-of select="ContractLimit/Amount"/>
                                                  </urn:Amount>
                                                  <urn:Currency>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="ContractLimit/Amount/@currencyCode"/>
                                                  </urn:UniqueName>
                                                  </urn:Currency>
                                                </urn:ContractLimit>
                                            </xsl:if>
                                                
                                            <xsl:if test="OverallLimit/ExpectedAmount">
                                                <urn:ExpectedAmount>
                                                  <urn:Amount>
                                                  <xsl:value-of select="OverallLimit/ExpectedAmount"
                                                  />
                                                  </urn:Amount>
                                                  <urn:Currency>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="Amount/Amount/@currencyCode"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:Currency>
                                                </urn:ExpectedAmount>
                                            </xsl:if>

                                            <xsl:if test="OverallLimit/Amount">
                                                <urn:MaxAmount>
                                                  <urn:Amount>
                                                  <xsl:value-of select="OverallLimit/Amount"/>
                                                  </urn:Amount>
                                                  <urn:Currency>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="Amount/Amount/@currencyCode"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:Currency>
                                                </urn:MaxAmount>
                                            </xsl:if>
                                            <!-- IG-36877 : XSLT Quality Improvement -->
                                            <xsl:if test="OtherLimit/Amount">   
                                                <urn:OtherLimit>
                                                    <urn:Amount>
                                                        <xsl:value-of select="OtherLimit/Amount"/>
                                                    </urn:Amount>
                                                    <urn:Currency>
                                                        <urn:UniqueName>
                                                            <xsl:value-of
                                                                select="OtherLimit/Amount/@currencyCode"/>
                                                        </urn:UniqueName>
                                                    </urn:Currency>
                                                </urn:OtherLimit>
                                            </xsl:if>
                                            <!-- IG-36877 : XSLT Quality Improvement -->
                                            <urn:RequiresServiceEntry>
                                                <xsl:value-of select="'true'"/>
                                            </urn:RequiresServiceEntry>
                                        </urn:ImportServiceDetailsStaging>
                                    </xsl:if>
                                    <urn:ImportedAccountCategoryStaging>
                                        <urn:UniqueName>
                                            <xsl:value-of select="AcctAssCat"/>
                                        </urn:UniqueName>
                                    </urn:ImportedAccountCategoryStaging>
                                    <xsl:if
                                        test="AcctDetails/AcctLines/AccountingCodingBlockAssignment">
                                        <urn:ImportedAccountingsStaging>
                                            <urn:SplitAccountings>
                                                <xsl:for-each
                                                  select="AcctDetails/AcctLines/AccountingCodingBlockAssignment">
                                                  <urn:item>
                                                  <urn:Account>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="../../../AcctAssCat"/>
                                                  </urn:UniqueName>
                                                  </urn:Account>
                                                  <xsl:choose>
                                                  <xsl:when test="../../../AcctAssCat = 'K'">
                                                  <urn:CostCenter>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="../../../../CompanyCode"/>
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="CostCentreID"/>
                                                  </urn:UniqueName>
                                                  </urn:CostCenter>
                                                  </xsl:when>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                                  <xsl:when test="../../../AcctAssCat = 'N'">
                                                  <xsl:if test="string-length(normalize-space(NetworkID)) > 0">    
                                                  <urn:ActivityNumber>
                                                  <urn:Network>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="../../../../CompanyCode"/>
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
                                                  </xsl:when>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->                                                 
                                                  <xsl:when test="../../../AcctAssCat = 'A'">
                                                  <urn:Asset>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="../../../../CompanyCode"/>
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
                                                  </xsl:when>
                                                  <xsl:when test="../../../AcctAssCat = 'F'">
                                                  <xsl:if
                                                  test="
                                                                        ((exists(InternalOrderID) and InternalOrderID) or
                                                                        (exists(MaintenanceOrderReference/ID) and MaintenanceOrderReference/ID))">
                                                  <urn:InternalOrder>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="InternalOrderID || MaintenanceOrderReference/ID"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:InternalOrder>
                                                  </xsl:if>
                                                  <xsl:if test="MaintenanceOrderReference/ID != ''">
                                                  <urn:IsWorkOrder>
                                                  <xsl:value-of select="'true'"/>
                                                  </urn:IsWorkOrder>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:when test="../../../AcctAssCat = 'P'">
                                                  <urn:WBSElement>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="ProjectReference/ProjectID"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:WBSElement>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  <xsl:if
                                                  test="string-length(normalize-space(GeneralLedgerAccountReference/ID)) > 0">
                                                  <urn:GeneralLedger>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="../../../../CompanyCode"/>
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="GeneralLedgerAccountReference/ID"/>
                                                  </urn:UniqueName>
                                                  </urn:GeneralLedger>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                                  <xsl:if test="(../../../AcctAssCat = 'N') and (string-length(normalize-space(NetworkID)) > 0)"> 
                                                  <urn:Network>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="../../../../CompanyCode"/>
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>  
                                                  <xsl:value-of select="NetworkID"/>    
                                                  </urn:UniqueName>
                                                  </urn:Network>                                              
                                                  </xsl:if>
                                                  <!--IG-28021: Mapping Network and Activity for Account assignment -->                                                        
                                                  </xsl:if>
                                                  <urn:NumberInCollection>
                                                  <xsl:value-of select="SerialNumber"/>
                                                  </urn:NumberInCollection>
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
                                                  <urn:custom>
                                                      <xsl:if test="string-length(normalize-space(BudgetPeriod)) > 0">  <!-- IG-36877 : XSLT Quality Improvement -->
                                                  <urn:CustomBudgetPeriod>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="BudgetPeriod"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomBudgetPeriod>
                                                  </xsl:if>
                                                      <xsl:if test="string-length(normalize-space(CommitItem)) > 0"> <!-- IG-36877 : XSLT Quality Improvement -->
                                                  <urn:CustomCommitmentItem>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="CommitItem"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomCommitmentItem>
                                                  </xsl:if>
                                                      <xsl:if test="string-length(normalize-space(EarmFundDoc)) > 0">    <!-- IG-36877 : XSLT Quality Improvement -->
                                                  <urn:CustomEarmarkedFundsDocument>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="EarmFundDoc"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomEarmarkedFundsDocument>
                                                  </xsl:if>
                                                      <xsl:if test="string-length(normalize-space(EarmFundItem)) >0"> <!-- IG-36877 : XSLT Quality Improvement -->
                                                  <urn:CustomEarmarkedFundsLineItem>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="EarmFundItem"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomEarmarkedFundsLineItem>
                                                  </xsl:if>
                                                  <xsl:if
                                                      test="string-length(normalize-space(FundsManagementFunctionalAreaID)) > 0">   <!-- IG-36877 : XSLT Quality Improvement -->
                                                  <urn:CustomFunctionalArea>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="FundsManagementFunctionalAreaID"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomFunctionalArea>
                                                  </xsl:if>
                                                  <xsl:if
                                                      test="string-length(normalize-space(FundsManagementFundID)) > 0">   <!-- IG-36877 : XSLT Quality Improvement -->
                                                  <urn:CustomFund>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="FundsManagementFundID"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomFund>
                                                  </xsl:if>
                                                  <xsl:if
                                                      test="string-length(normalize-space(FundsManagementCentreID)) > 0">  <!-- IG-36877 : XSLT Quality Improvement -->
                                                  <urn:CustomFundsCenter>
                                                  <urn:UniqueName>
                                                  <xsl:value-of select="FundsManagementCentreID"/>
                                                  </urn:UniqueName>
                                                  </urn:CustomFundsCenter>
                                                  </xsl:if>
                                                      <xsl:if test="string-length(normalize-space(GrantID)) > 0">    <!-- IG-36877 : XSLT Quality Improvement -->
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
                                            <xsl:if
                                                test="string-length(normalize-space(DistrbInd))> 0 ">  <!-- IG-36877 : XSLT Quality Improvement -->
                                                <urn:Type>
                                                  <urn:UniqueName>
                                                  <xsl:choose>
                                                  <xsl:when test="DistrbInd = '1'">
                                                  <xsl:value-of select="'_Quantity'"/>
                                                  </xsl:when>
                                                  <xsl:when test="DistrbInd = '2'">
                                                  <xsl:value-of select="'_Percentage'"/>
                                                  </xsl:when>
                                                  <xsl:when test="DistrbInd = '3'">
                                                  <xsl:value-of select="'_Amount'"/>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </urn:UniqueName>
                                                </urn:Type>
                                            </xsl:if>
                                        </urn:ImportedAccountingsStaging>
                                    </xsl:if>
                                    <urn:ImportedDeliverToStaging>
                                        <xsl:value-of select="Preparer"/>
                                    </urn:ImportedDeliverToStaging>
                                    <!--IG-25540 re-order-->
                                    <xsl:if test="ItemCategory != 0">
                                        <urn:ImportedItemCategoryStaging>
                                            <urn:UniqueName>
                                                <xsl:choose>
                                                    <xsl:when test="ItemCategory = 9">
                                                        <xsl:value-of select="'D'"/>
                                                    </xsl:when>
                                                    <xsl:when test="ItemCategory = 1">
                                                        <xsl:value-of select="'B'"/>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </urn:UniqueName>
                                        </urn:ImportedItemCategoryStaging>
                                    </xsl:if>
                                    <urn:ImportedLineCommentStaging>
                                        <xsl:call-template name="CommentsFillProxyOut">
                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                            <xsl:with-param name="p_doctype"
                                                select="$anTargetDocumentType"/>
                                            <xsl:with-param name="p_aribaComment"
                                                select="AribaComment"/>
                                            <xsl:with-param name="IsServiceChild"
                                                select="IsServiceChild"/>
                                            <xsl:with-param name="p_itemNumber" select="ItemID"/>
                                        </xsl:call-template>
                                    </urn:ImportedLineCommentStaging>
                                    <urn:ImportedNeedByStaging>
                                        <xsl:value-of select="NeedByDate"/>
                                    </urn:ImportedNeedByStaging>
                                    <xsl:if test="IsServiceChild">
                                        <urn:IsServiceChild>
                                            <xsl:value-of select="IsServiceChild"/>
                                        </urn:IsServiceChild>
                                    </xsl:if>
                                    <urn:NumberInCollection>
                                        <xsl:value-of select="normalize-space(AribaItemID)"/>
                                    </urn:NumberInCollection>
                                    <urn:OriginatingSystemLineNumber>
                                        <xsl:value-of select="ItemID"/>
                                    </urn:OriginatingSystemLineNumber>
                                    <!--IG-25540 re-order-->
                                    <xsl:if test="string-length(ContractLimit/ContractId) > 0">
                                        <urn:OutlineRootNumber>
                                            <xsl:value-of select="ContractLimit/ContractItem"/>
                                        </urn:OutlineRootNumber>
                                    </xsl:if>
                                    <urn:ParentLineNumber>
                                        <xsl:value-of select="ParentLineNumber"/>
                                    </urn:ParentLineNumber>
                                    <urn:PurchaseGroup>
                                        <urn:UniqueName>
                                            <xsl:value-of select="PurchGrp"/>
                                        </urn:UniqueName>
                                    </urn:PurchaseGroup>
                                    <urn:PurchaseOrg>
                                        <urn:UniqueName>
                                            <xsl:value-of select="PurchOrg"/>
                                        </urn:UniqueName>
                                    </urn:PurchaseOrg>
                                    <xsl:choose>
                                        <xsl:when test="IsServiceChild = 'true'">
                                            <xsl:if test="Amount/BaseQuantity">
                                                <urn:Quantity>
                                                  <xsl:value-of select="Amount/BaseQuantity"/>
                                                </urn:Quantity>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="Quantity">
                                                <urn:Quantity>
                                                  <xsl:value-of select="Quantity"/>
                                                </urn:Quantity>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <urn:SAPPlant>
                                        <urn:UniqueName>
                                            <xsl:value-of select="Plant"/>
                                        </urn:UniqueName>
                                    </urn:SAPPlant>
                                    <urn:ShipTo>
                                        <urn:UniqueName>
                                            <xsl:value-of select="Plant"/>
                                        </urn:UniqueName>
                                    </urn:ShipTo>
                                    <xsl:if test="Supplier">
                                        <urn:Supplier>
                                            <urn:UniqueName>
                                                <xsl:value-of select="Supplier"/>
                                            </urn:UniqueName>
                                        </urn:Supplier>
                                        <urn:SupplierLocation>
                                            <urn:ContactID>
                                                <xsl:value-of select="SupplierLocation/ContactID"/>
                                            </urn:ContactID>
                                            <urn:UniqueName>
                                                <xsl:value-of select="SupplierLocation/Id"/>
                                            </urn:UniqueName>
                                        </urn:SupplierLocation>
                                    </xsl:if>
                                </urn:item>
                            </xsl:for-each>
                        </urn:LineItems>
                        <urn:Name>
                            <xsl:value-of select="DocumentID"/>
                        </urn:Name>
                        <urn:Operation>
                            <xsl:choose>
                                <xsl:when test="Operation = 01">
                                    <xsl:value-of select="'New'"/>
                                </xsl:when>
                                <xsl:when test="Operation = 02">
                                    <xsl:value-of select="'Update'"/>
                                </xsl:when>
                                <xsl:when test="Operation = 03">
                                    <xsl:value-of select="'Cancel'"/>
                                </xsl:when>
                            </xsl:choose>
                        </urn:Operation>
                        <urn:OriginatingSystem>
                            <xsl:value-of select="../MessageHeader/SenderBusinessSystemID"/>
                        </urn:OriginatingSystem>
                        <urn:OriginatingSystemReferenceID>
                            <xsl:value-of select="DocumentID"/>
                        </urn:OriginatingSystemReferenceID>
                        <xsl:if test="ItemDetails[1]/Preparer">
                            <urn:Preparer>
                                <urn:PasswordAdapter>
                                    <xsl:value-of select="'PasswordAdapter1'"/>
                                </urn:PasswordAdapter>
                                <urn:UniqueName>
                                    <xsl:value-of select="ItemDetails[1]/Preparer"/>
                                </urn:UniqueName>
                            </urn:Preparer>
                        </xsl:if>
                        <xsl:if test="ItemDetails[1]/Requester">
                            <urn:Requester>
                                <urn:PasswordAdapter>
                                    <xsl:value-of select="'PasswordAdapter1'"/>
                                </urn:PasswordAdapter>
                                <urn:UniqueName>
                                    <xsl:value-of select="ItemDetails[1]/Requester"/>
                                </urn:UniqueName>
                            </urn:Requester>
                        </xsl:if>
                        <urn:SAPPlant>
                            <urn:UniqueName>
                                <xsl:value-of select="ItemDetails[1]/Plant"/>
                            </urn:UniqueName>
                        </urn:SAPPlant>
                        <urn:UniqueName/>
                        <xsl:if test="ItemDetails[1]/MRPControl">
                            <urn:IsMRPRunPR>
                                <xsl:value-of select="'true'"/>
                            </urn:IsMRPRunPR>
                        </xsl:if>
                    </urn:item>
                </xsl:for-each>
            </urn:Requisition_RequisitionImportPull_Item>
        </urn:RequisitionImportAsyncPullRequest>
    </xsl:template>
</xsl:stylesheet>
