<?xml version="1.0" encoding="UTF-8"?>  
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0" xmlns:urn="urn:Ariba:Buyer:vsap">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="urn:ExternalReqForApprovalImportRequest">
        <xsl:variable name="v_CCode">
            <xsl:value-of
                select="urn:ExternalReqForApprovalInput_Item/urn:item/urn:HeaderExtrinsics/Extrinsics/Extrinsic[@name = 'CompanyCode']"
            />
        </xsl:variable>
        <xsl:variable name="v_NeedBy">
            <xsl:value-of
                select="urn:ExternalReqForApprovalInput_Item/urn:item/urn:ExternalReqLineItems/urn:item[1]/urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'NeedBy']"
            />
        </xsl:variable>
        <xsl:variable name="v_ShipTo">
            <xsl:value-of
                select="urn:ExternalReqForApprovalInput_Item/urn:item/urn:ExternalReqLineItems/urn:item[1]/urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'ShipTo']"
            />
        </xsl:variable>
        <urn:RequisitionImportAsyncPullRequest>
            <urn:Requisition_RequisitionImportPull_Item>
                <xsl:for-each select="urn:ExternalReqForApprovalInput_Item/urn:item">
                    <urn:item>
                        <urn:CompanyCode>
                            <urn:UniqueName>
                                <xsl:value-of select="$v_CCode"/>
                            </urn:UniqueName>
                        </urn:CompanyCode>
                        <urn:DefaultLineItem>
                            <urn:DeliverTo>
                                <xsl:value-of select="$v_ShipTo"/>
                            </urn:DeliverTo>
                            <xsl:if test="string-length(normalize-space($v_NeedBy)) > 0">
                                <urn:NeedBy>
                                    <xsl:value-of select="concat($v_NeedBy, 'T', '12:00:00+00:00')"
                                    />
                                </urn:NeedBy>
                            </xsl:if>
                        </urn:DefaultLineItem>
                        <urn:ImportedHeaderCommentStaging>
                            <xsl:value-of select="urn:HeaderComments"/>
                        </urn:ImportedHeaderCommentStaging>
                        <urn:ImportedHeaderExternalCommentStaging>true</urn:ImportedHeaderExternalCommentStaging>
                        <urn:IsServiceRequisition>true</urn:IsServiceRequisition>
                        <urn:LineItems>
                            <xsl:for-each select="urn:ExternalReqLineItems/urn:item[urn:UpdateAction ne 'DELETE']"> <!-- IG-34357 FG Update scenario -->
                                <xsl:variable name="v_Amount" select="urn:UnitPrice * urn:Quantity"/>
                                <urn:item>
                                    <urn:AllowUsersToEditUnitPrice>false</urn:AllowUsersToEditUnitPrice>
                                    <urn:BillingAddress>
                                        <urn:UniqueName>
                                            <xsl:value-of
                                                select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'BillingAddress']"
                                            />
                                        </urn:UniqueName>
                                    </urn:BillingAddress>
                                    <urn:CommodityCode>
                                        <urn:UniqueName>
                                            <xsl:value-of select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'MaterialGroup']"/> <!-- IG-39298 :Commodity Code Enhancement -->
                                        </urn:UniqueName>
                                    </urn:CommodityCode>
                                    <urn:ContractIdStaging>
                                        <xsl:value-of
                                            select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'MasterAgreement']"
                                        />
                                    </urn:ContractIdStaging>
                                    <urn:Description>
                                        <!-- IG-39298 :Commodity Code Enhancement -->
                                        <xsl:if test="string-length(normalize-space(urn:CommodityCodeUniqueName)) > 0">
                                          <urn:CommonCommodityCode>
                                              <urn:Domain>unspsc</urn:Domain>
                                              <urn:UniqueName><xsl:value-of select="urn:CommodityCodeUniqueName"/></urn:UniqueName>
                                          </urn:CommonCommodityCode>
                                       </xsl:if>
                                        <!-- IG-39298 :Commodity Code Enhancement -->
                                        <urn:Description>
                                            <xsl:value-of select="urn:ItemDescription"/>
                                        </urn:Description>
                                        <urn:Price>
                                            <urn:Amount>
                                                <xsl:value-of select="$v_Amount"/>
                                            </urn:Amount>
                                            <urn:Currency>
                                                <urn:UniqueName>
                                                  <xsl:value-of select="urn:Currency"/>
                                                </urn:UniqueName>
                                            </urn:Currency>
                                        </urn:Price>
                                        <urn:UnitOfMeasure>
                                            <urn:UniqueName>
                                                <xsl:value-of select="urn:UnitOfMeasure"/>
                                            </urn:UniqueName>
                                        </urn:UnitOfMeasure>
                                    </urn:Description>
                                    <urn:ImportServiceDetailsStaging>
                                        <urn:ExpectedAmount>
                                            <urn:Amount>
                                                <xsl:value-of select="$v_Amount"/>
                                            </urn:Amount>
                                            <urn:Currency>
                                                <urn:UniqueName>
                                                  <xsl:value-of select="urn:Currency"/>
                                                </urn:UniqueName>
                                            </urn:Currency>
                                        </urn:ExpectedAmount>
                                        <urn:MaxAmount>
                                            <urn:Amount>
                                                <xsl:value-of select="$v_Amount"/>
                                            </urn:Amount>
                                            <urn:Currency>
                                                <urn:UniqueName>
                                                  <xsl:value-of select="urn:Currency"/>
                                                </urn:UniqueName>
                                            </urn:Currency>
                                        </urn:MaxAmount>
                                        <urn:NonSESBasedInvoice>false</urn:NonSESBasedInvoice>
                                        <urn:RequiresServiceEntry>true</urn:RequiresServiceEntry>
                                        <xsl:if
                                            test="string-length(normalize-space(urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'ServiceEndDate'])) > 0">
                                            <urn:ServiceEndDate>
                                                <xsl:value-of
                                                  select="concat(urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'ServiceEndDate'], 'T', '12:00:00+00:00')"
                                                />
                                            </urn:ServiceEndDate>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'ServiceStartDate'])) > 0">
                                            <urn:ServiceStartDate>
                                                <xsl:value-of
                                                  select="concat(urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'ServiceStartDate'], 'T', '12:00:00+00:00')"/>

                                            </urn:ServiceStartDate>
                                        </xsl:if>
                                    </urn:ImportServiceDetailsStaging>
                                    <urn:ImportedAccountCategoryStaging>
                                        <urn:UniqueName>
                                            <xsl:value-of
                                                select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory']"
                                            />
                                        </urn:UniqueName>
                                    </urn:ImportedAccountCategoryStaging>
                                    <urn:ImportedAccountingsStaging>
                                        <urn:SplitAccountings>
                                            <xsl:for-each
                                                select="urn:SplitAccounting/SplitAccountings/SplitAccounting">
                                                <urn:item>
                                                  <urn:Account>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="../../../urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory']"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:Account>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="../../../urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory'] = 'K'">

                                                  <urn:CostCenter>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'CompanyCode']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'CostCenter']/@value"/>
                                                  </urn:UniqueName>
                                                  </urn:CostCenter>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="../../../urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory'] = 'N'">

                                                  <urn:ActivityNumber>
                                                  <urn:Network>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'CompanyCode']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'Network']/@value"/>
                                                  </urn:UniqueName>
                                                  </urn:Network>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'ActivityNumber']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:ActivityNumber>

                                                  </xsl:when>
                                                  <xsl:when
                                                  test="../../../urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory'] = 'A'">
                                                  <urn:Asset>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'CompanyCode']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:SubNumber>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'SubNumber']/@value"/>
                                                  </urn:SubNumber>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'Asset']/@value"/>
                                                  </urn:UniqueName>
                                                  </urn:Asset>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="../../../urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory'] = 'F'">
                                                  <urn:InternalOrder>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'InternalOrder']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:InternalOrder>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="../../../urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory'] = 'P'">
                                                  <urn:WBSElement>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'WBSElement']/@value"/>
                                                  </urn:UniqueName>
                                                  </urn:WBSElement>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  <urn:GeneralLedger>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'CompanyCode']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'GeneralLedger']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:GeneralLedger>
                                                  <xsl:if
                                                  test="../../../urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'AccountCategory'] = 'N'">
                                                  <urn:Network>
                                                  <urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'CompanyCode']/@value"
                                                  />
                                                  </urn:UniqueName>
                                                  </urn:CompanyCode>
                                                  <urn:UniqueName>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'Network']/@value"/>
                                                  </urn:UniqueName>
                                                  </urn:Network>
                                                  </xsl:if>
                                                  <urn:NumberInCollection>
                                                  <xsl:value-of
                                                  select="Accounting[@name = 'SAPSerialNumber']/@value"
                                                  />
                                                  </urn:NumberInCollection>
                                                  <xsl:if
                                                  test="string-length(normalize-space(@Percentage)) > 0">
                                                  <urn:Percentage>
                                                  <xsl:value-of select="@Percentage"/>
                                                  </urn:Percentage>
                                                  </xsl:if>
                                                </urn:item>
                                            </xsl:for-each>
                                        </urn:SplitAccountings>
                                        <urn:Type>
                                            <urn:UniqueName>
                                                <xsl:value-of select="'_Percentage'"/>
                                            </urn:UniqueName>
                                        </urn:Type>
                                    </urn:ImportedAccountingsStaging>
                                    <urn:ImportedDeliverToStaging>
                                        <xsl:value-of
                                            select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'ShipTo']"
                                        />
                                    </urn:ImportedDeliverToStaging>
                                    <xsl:if
                                        test="string-length(normalize-space(urn:DiscountAmount)) > 0">
                                        <urn:ImportedDiscountAmountStaging>
                                            <xsl:value-of select="urn:DiscountAmount * -1"/>
                                        </urn:ImportedDiscountAmountStaging>
                                    </xsl:if>
                                    <urn:ImportedItemCategoryStaging>
                                        <urn:UniqueName>D</urn:UniqueName>
                                    </urn:ImportedItemCategoryStaging>
                                    <urn:ImportedLineCommentStaging>
                                        <xsl:value-of select="urn:ItemComments"/>
                                    </urn:ImportedLineCommentStaging>
                                    <urn:ImportedLineExternalCommentStaging>true</urn:ImportedLineExternalCommentStaging>
                                    <xsl:if
                                        test="string-length(normalize-space(urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'NeedBy'])) > 0">
                                        <urn:ImportedNeedByStaging>
                                            <xsl:value-of
                                                select="concat(urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'NeedBy'], 'T', '12:00:00+00:00')"
                                            />
                                        </urn:ImportedNeedByStaging>
                                    </xsl:if>
                                    <urn:NumberInCollection>
                                        <xsl:value-of select="urn:ExternalLineNumber"/>
                                    </urn:NumberInCollection>
                                    <urn:Operation>
                                        <xsl:choose>
                                            <xsl:when test="upper-case(urn:UpdateAction) = 'NEW'">
                                                <xsl:value-of select="'New'"/>
                                            </xsl:when>
                                            <xsl:when test="upper-case(urn:UpdateAction) = 'UPDATE'">
                                                <xsl:value-of select="'Update'"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </urn:Operation>
                                    <urn:OriginatingSystemLineNumber>
                                        <xsl:value-of select="urn:ExternalLineNumber"/>
                                    </urn:OriginatingSystemLineNumber>
                                    <urn:ParentLineNumber>0</urn:ParentLineNumber>
                                    <urn:PurchaseGroup>
                                        <urn:UniqueName>
                                            <xsl:value-of
                                                select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'PurchaseGroup']"
                                            />
                                        </urn:UniqueName>
                                    </urn:PurchaseGroup>
                                    <urn:PurchaseOrg>
                                        <urn:UniqueName>
                                            <xsl:value-of
                                                select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'PurchaseOrg']"
                                            />
                                        </urn:UniqueName>
                                    </urn:PurchaseOrg>
                                    <urn:Quantity>
                                        <xsl:value-of select="urn:Quantity"/>
                                    </urn:Quantity>
                                    <urn:ShipTo>
                                        <urn:UniqueName>
                                            <xsl:value-of
                                                select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'ShipTo']"
                                            />
                                        </urn:UniqueName>
                                    </urn:ShipTo>
                                    <urn:Supplier>
                                        <urn:UniqueName>
                                            <xsl:value-of
                                                select="urn:LineExtrinsics/Extrinsics/Extrinsic[@name = 'VendorId']"
                                            />
                                        </urn:UniqueName>
                                    </urn:Supplier>
                                </urn:item>
                            </xsl:for-each>
                        </urn:LineItems>
                        
                        <urn:Name>
                            <xsl:value-of select="urn:Name"/>
                        </urn:Name>
                        <urn:Operation>
                            <xsl:choose>
                                <xsl:when test="upper-case(urn:Operation) = 'NEW'">
                                    <xsl:value-of select="'New'"/>
                                </xsl:when>
                                <xsl:when test="upper-case(urn:Operation) = 'UPDATE'">
                                    <xsl:value-of select="'Update'"/>
                                </xsl:when>
                            </xsl:choose>
                        </urn:Operation>
                        <urn:OriginatingSystem>
                            <xsl:value-of select="'FieldGlass'"/>
                        </urn:OriginatingSystem>
                        <urn:OriginatingSystemReferenceID>
                            <xsl:value-of select="urn:ExternalReqId"/>
                        </urn:OriginatingSystemReferenceID>
                        <urn:Preparer>
                            <urn:PasswordAdapter>
                                <xsl:value-of select="'PasswordAdapter1'"/>
                            </urn:PasswordAdapter>
                            <urn:UniqueName>
                                <xsl:value-of select="urn:PreparerUniqueName"/>
                            </urn:UniqueName>
                        </urn:Preparer>
                        <urn:Requester>
                            <urn:PasswordAdapter>
                                <xsl:value-of select="'PasswordAdapter1'"/>
                            </urn:PasswordAdapter>
                            <urn:UniqueName>
                                <xsl:value-of select="urn:RequesterUniqueName"/>
                            </urn:UniqueName>
                        </urn:Requester>
                        <urn:UniqueName/>
                    </urn:item>
                </xsl:for-each>
            </urn:Requisition_RequisitionImportPull_Item>
        </urn:RequisitionImportAsyncPullRequest>
    </xsl:template>
</xsl:stylesheet>
