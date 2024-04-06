<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
    xpath-default-namespace="urn:Ariba:Buyer:vsap"
    xmlns:prx="urn:sap.com:proxy:NWC:/1SAI/TXS5702B25F6DD7952A79BA:700:2010/02/19"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">                                                                                          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                                        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
<!--        <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
    <!--    Test for BudgetCheck with following parameter -->
    <!--****************************************************************************-->
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSenderID1"/>
    <xsl:param name="anXsltDoctype"/>
    
    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    <!--    Doctype will be fetched from PD , to fulfill current testing , it has been hardcoded-->
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
        </xsl:call-template>
        <!--        <xsl:value-of select="'ParameterCrossreference.xml'"/>-->
    </xsl:variable>
    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    
    <!--    Check if the Tax should be computed for CompanyCode from respective Input XML-->
    <xsl:variable name="v_checkTaxAllowed">
        <xsl:call-template name="ReadLookUpTable_In">
            <xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
            <xsl:with-param name="p_docType" select="'RequisitionExportRequest'"/>
            <xsl:with-param name="p_productType" select="'AribaProcurement'"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_input"
                select="//Requisition_BudgetReqExportHeaderDetails_Item/item/CompanyCode/UniqueName"/>
            <xsl:with-param name="p_lookupName" select="'TaxOnCompanyCode'"/>
        </xsl:call-template>
    </xsl:variable>
    <!--IG-20990 Begin. Support AdhocShipTo-->
    <xsl:variable name="v_adhocShipTo"
        select="//Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/ShipTo/UniqueName"/>
    <!--IG-20990 end-->
    <!--    ****************************************************************************-->
    <xsl:variable name="v_budchk" select="'RequisitionBudgetCheckExportRequest'"/>    
    <xsl:template
        match="RequisitionRealTimeBudgetExportRequest">
        <xsl:variable name="reqLineDetail"
            select="Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item"/>
        <xsl:variable name="reqAccDetail"
            select="Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item"/>
        <n0:ARBCIG_PURREQ>
            <ARIBA_REQ_NO>
                <xsl:value-of select="Requisition_BudgetReqExportHeaderDetails_Item/item/UniqueName"
                />
            </ARIBA_REQ_NO>
            <ARIBA_REQ_NV>
                <xsl:value-of
                    select="Requisition_BudgetReqExportHeaderDetails_Item/item/NextVersionApprovable/UniqueName"
                />
            </ARIBA_REQ_NV>
            <PARTITION>
                <xsl:value-of select="@partition"/>
            </PARTITION>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <SOURCE>
                <xsl:value-of select="$anSourceDocumentType"/>
            </SOURCE>    
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <VARIANT>
                <xsl:value-of select="@variant"/>
            </VARIANT>
            <COMPANYCODE>
                <xsl:value-of
                    select="Requisition_BudgetReqExportHeaderDetails_Item/item/CompanyCode/UniqueName"
                />
            </COMPANYCODE>
            <xsl:choose>
                <!--If there is no ERPRequisition, then this document is being called for the first time, Hence will be treated as Create-->
                <xsl:when
                    test="string-length(normalize-space(Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) = 0">                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:choose>
                        <xsl:when
                            test="count(Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item) > 0">
                            <MODE>
                                <xsl:value-of select="'C'"/>
                            </MODE>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <!--If ERPRequisitionID exists but it is a DUMMY PR, then call it as Create-->
                        <xsl:when
                            test="matches(Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID, 'D')">
                            <xsl:if
                                test="count(Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item) > 0">
                                <MODE>
                                    <xsl:value-of select="'C'"/>
                                </MODE>
                            </xsl:if>
                        </xsl:when>
                        <!--If ERPRequisitionID exists and it was not a Dummy PR, then treat it as a request to Change-->
                        <xsl:otherwise>
                            <MODE>
                                <xsl:value-of select="'U'"/>
                            </MODE>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <!--            Logic for PRAddressDelivery in case of AdHocShipToAddress-->
            <PRADDRDELIVERY>
                <xsl:for-each
                    select="
                        Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false')
                        and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '') and (ParentLineNumber = 0)]">
                    <!--Truncating the data according to ERP proxy's ABAP field length-->
                    <xsl:if test="HasAdhocShipToAddress = 'true'">
                        <item>
                            <xsl:if
                                test="string-length(normalize-space(//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) > 0">         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <PREQ_NO>
                                    <xsl:value-of
                                        select="//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID"
                                    />
                                </PREQ_NO>
                            </xsl:if>
                            <PREQ_ITEM>
                                <xsl:choose>
                                    <xsl:when
                                        test="string-length(normalize-space(//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) > 1">         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <xsl:value-of select="ERPLineItemNumber"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="NumberInCollection"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </PREQ_ITEM>
                            <CITY>
                                <xsl:value-of select="substring(ShipTo/PostalAddress/City, 1, 40)"/>
                            </CITY>
                            <POSTL_COD1>
                                <xsl:value-of
                                    select="substring(ShipTo/PostalAddress/PostalCode, 1, 10)"/>
                            </POSTL_COD1>
                            <STREET>
                                <xsl:value-of select="substring(ShipTo/PostalAddress/Lines, 1, 60)"
                                />
                            </STREET>
                            <COUNTRY>
                                <xsl:value-of
                                    select="substring(ShipTo/PostalAddress/Country/UniqueName, 1, 3)"
                                />
                            </COUNTRY>
                            <REGION>
                                <xsl:value-of select="substring(ShipTo/PostalAddress/State, 1, 3)"/>
                            </REGION>
                        </item>
                    </xsl:if>
                </xsl:for-each>
            </PRADDRDELIVERY>
            <!--IG-18417 --> 
            <PRADDRDELIVERY1>
                <xsl:for-each
                    select="
                    Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false')
                    and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '') and (ParentLineNumber = 0)]">
                    <!--Truncating the data according to ERP proxy's ABAP field length-->
                    <xsl:if test="HasAdhocShipToAddress = 'true'">
                        <item>
                            <xsl:if
                                test="string-length(normalize-space(//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) > 0">             <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <PREQ_NO>
                                    <xsl:value-of
                                        select="//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID"
                                    />
                                </PREQ_NO>
                            </xsl:if>
                            <PREQ_ITEM>
                                <xsl:choose>
                                    <xsl:when
                                        test="string-length(normalize-space(//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) > 1">           <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <xsl:value-of select="ERPLineItemNumber"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="NumberInCollection"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </PREQ_ITEM>
                            <CITY>
                                <xsl:value-of select="substring(ShipTo/PostalAddress/City, 1, 40)"/>
                            </CITY>
                            <POSTL_COD1>
                                <xsl:value-of
                                    select="substring(ShipTo/PostalAddress/PostalCode, 1, 10)"/>
                            </POSTL_COD1>
                            <STREET>
                                <xsl:value-of select="substring(ShipTo/PostalAddress/Lines, 1, 60)"
                                />
                            </STREET>
                            <COUNTRY>
                                <xsl:value-of
                                    select="substring(ShipTo/PostalAddress/Country/UniqueName, 1, 3)"
                                />
                            </COUNTRY>
                            <REGION>
                                <xsl:value-of select="substring(ShipTo/PostalAddress/State, 1, 3)"/>
                            </REGION>
                            <ARIBA_ITEM>
                                <xsl:value-of select="NumberInCollection"/>
                            </ARIBA_ITEM>
                        </item>
                    </xsl:if>
                </xsl:for-each>
            </PRADDRDELIVERY1>
            <!--IG-18417 --> 
            <PRHEADERREQ>
                <PREQ_NO>
                    <xsl:value-of
                        select="Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID"
                    />
                </PREQ_NO>
                <PR_TYPE>
                    <!--Fetch from PD, the PR's ERP document type. 'NB' will be default if no value is mainatned-->
                    <!--For ERP Docment type 'FO' check if ItemCategory/UniqueName='B'-->
                    <xsl:variable name="v_itemCategoryFlag">
                        <xsl:if
                            test="(Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item/ItemCategory/UniqueName = 'B')">
                            <xsl:value-of select="'YES'"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:call-template name="FillDocType">
                        <xsl:with-param name="p_doctype" select="'RequisitionExportRequest'"/>
                        <xsl:with-param name="p_ordCategory" select="'PR'"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                        <xsl:with-param name="p_itemCategory" select="$v_itemCategoryFlag"/>
                        <!--param FO flag yes/no-->
                    </xsl:call-template>
                </PR_TYPE>
            </PRHEADERREQ>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <PRHEADERTEXT>
                <item>
                    <TEXT_ID>
                        <xsl:value-of select="'B01'"/>
                    </TEXT_ID>
                    <TEXT_LINE>
                        <xsl:value-of select="'Ariba Requisition Number : '"/>
                        <xsl:value-of
                        select="//Requisition_BudgetReqExportHeaderDetails_Item/item/UniqueName"
                    /></TEXT_LINE>
                </item>
            </PRHEADERTEXT>
            <!--            Include for Limits too-->
            <SERVICEACCOUNT>
                <xsl:for-each
                    select="Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item">
                    <xsl:variable name="v_pos" select="position()"/>
                    <xsl:variable name="v_nic"
                        select="Accountings/SplitAccountings/item/LineItem/NumberInCollection"/>
                    <!-- IG-27546 If we have unknown account assignment i.e type 'U', then we don't populate any accounting data -->
                    <xsl:if
                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_nic]/AccountCategory/UniqueName != 'U'">
                    <xsl:variable name="v_mLineNic">
                        <xsl:if
                            test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[((HoldForAggregation = 'false' or HoldForAggregation = '') and (NumberInCollection = $v_nic) and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = ''))]">
                            <xsl:value-of
                                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[((HoldForAggregation = 'false' or HoldForAggregation = '') and (NumberInCollection = $v_nic) and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = ''))]/ParentLineNumber"
                            />
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="v_checkSrv">
                        <xsl:if
                            test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[((HoldForAggregation = 'false' or HoldForAggregation = '') and (NumberInCollection = $v_mLineNic) and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '') and (ServiceDetails/RequiresServiceEntry = 'true'))]">
                            <xsl:value-of select="'X'"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:if
                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[((HoldForAggregation = 'false' or HoldForAggregation = '') and (NumberInCollection = $v_nic) and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '') and ((ServiceDetails/RequiresServiceEntry = 'true' and (exists(ServiceDetails/MaxAmount) or exists(ServiceDetails/ExpectedAmount))) or (ItemCategory/UniqueName = 'B')))]">
                        <!-- for FO doctype also needs to generate SERVICEACCOUNT -->
                        <xsl:for-each
                            select="Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]">
                            <!--limits-->
                            <item>
                                <SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/> <!-- IG-24796 Delete splits for unplanned lines -->
                                </SERIAL_NO>
                                <SERIAL_NO_ITEM>
                                    <xsl:value-of select="NumberInCollection"/>
                                </SERIAL_NO_ITEM>
                                <QUANTITY>
                                    <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                </QUANTITY>
                                <PERCENT>
                                    <xsl:choose>
                                        <xsl:when test="AdjustedPercentageForSplits > 0">
                                            <xsl:value-of
                                                select="concat(substring-before(AdjustedPercentageForSplits, '.'), '.', substring(substring-after(AdjustedPercentageForSplits, '.'), 1, 1))"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="format-number(Percentage, '0.0')"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </PERCENT>
                                <NET_VALUE>
                                    <xsl:variable name="v_lineNic"
                                        select="LineItem/NumberInCollection"/>
                                    <xsl:variable name="v_nic" select="NumberInCollection"/>
                                    <xsl:variable name="v_Charge4">
                                        <xsl:call-template name="findAccChargeAmt">
                                            <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                            <xsl:with-param name="p_nic" select="$v_nic"/>
                                            <xsl:with-param name="p_chargeType" select="'4'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="v_Charge8">
                                        <xsl:call-template name="findAccChargeAmt">
                                            <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                            <xsl:with-param name="p_nic" select="$v_nic"/>
                                            <xsl:with-param name="p_chargeType" select="'8'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="v_Charge16">
                                        <xsl:call-template name="findAccChargeAmt">
                                            <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                            <xsl:with-param name="p_nic" select="$v_nic"/>
                                            <xsl:with-param name="p_chargeType" select="'16'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <!--ChargeAmount-->
                                    <xsl:variable name="v_charge_amt">
                                        <!-- <xsl:value-of select="$v_Charge4 + $v_Charge8 + $v_Charge16"
                                        />-->
                                        <xsl:value-of
                                            select="sum(($v_Charge4 | $v_Charge8 | $v_Charge16)[number(.) = .])"
                                        />
                                    </xsl:variable>
                                    <!--Tax without Charge-->
                                    <xsl:variable name="v_tax_amt">
                                        <xsl:choose>
                                            <xsl:when test="$v_checkTaxAllowed = 'TRUE'">
                                                <xsl:if
                                                    test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and TaxDetail/IsDeductible = 'false']">
                                                    <!-- IG-37134 : Amount formatting based on currency -->
                                                    <xsl:variable name="v_Curr">  <!-- This is to store the currency value -->
                                                        <xsl:value-of select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and (TaxDetail/IsDeductible = 'false')]/Amount/Currency/UniqueName"/>
                                                    </xsl:variable>
                                                    <xsl:choose>
                                                        <xsl:when test="$v_Curr = 'JPY'">
                                                            <xsl:call-template name="formatAmount">
                                                                <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and (TaxDetail/IsDeductible = 'false')]/Description/Price/Amount"/>
                                                            </xsl:call-template>
                                                        </xsl:when>
                                                        <xsl:when test="$v_Curr = 'VND'">
                                                            <xsl:call-template name="formatAmount">
                                                                <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and (TaxDetail/IsDeductible = 'false')]/Description/Price/Amount"/>
                                                            </xsl:call-template>
                                                        </xsl:when>
                                                        <xsl:when test="$v_Curr = 'KRW'">
                                                            <xsl:call-template name="formatAmount">
                                                                <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and (TaxDetail/IsDeductible = 'false')]/Description/Price/Amount"/>
                                                            </xsl:call-template>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of
                                                                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and (TaxDetail/IsDeductible = 'false')]/Description/Price/Amount"
                                                            />
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(0, '0.00')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Discount-->
                                    <xsl:variable name="v_disc_amt">
                                        <xsl:choose>
                                            <xsl:when
                                                test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 32]">
                                                <!-- IG-37134 : Amount formatting based on currency -->
                                                <xsl:variable name="v_Curr">  <!-- This is to store the currency value -->
                                                    <xsl:value-of select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 32]/Amount/Currency/UniqueName"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="$v_Curr = 'JPY'">
                                                        <xsl:call-template name="formatAmount">
                                                            <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 32]/Description/Price/Amount"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test="$v_Curr = 'VND'">
                                                        <xsl:call-template name="formatAmount">
                                                            <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 32]/Description/Price/Amount"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test="$v_Curr = 'KRW'">
                                                        <xsl:call-template name="formatAmount">
                                                            <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 32]/Description/Price/Amount"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of
                                                            select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 32]/Description/Price/Amount"
                                                        />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(0, '0.00')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="v_cur_amt">
                                        <!-- IG-37134 : Amount formatting based on currency -->
                                        <xsl:variable name="v_Curr">  <!-- This is to store the currency value -->
                                            <xsl:value-of select="AdjustedCostInCurrencyPrecision/Currency/UniqueName"/>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$v_Curr = 'JPY'">
                                                <xsl:call-template name="formatAmount">
                                                    <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:when test="$v_Curr = 'VND'">
                                                <xsl:call-template name="formatAmount">
                                                    <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:when test="$v_Curr = 'KRW'">
                                                <xsl:call-template name="formatAmount">
                                                    <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="AdjustedCostInCurrencyPrecision/Amount"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:call-template name="findSum">
                                        <xsl:with-param name="p_param1" select="$v_charge_amt"/>
                                        <xsl:with-param name="p_param2" select="$v_tax_amt"/>
                                        <xsl:with-param name="p_param3" select="$v_cur_amt"/>
                                        <xsl:with-param name="p_param4" select="$v_disc_amt"/>
                                    </xsl:call-template>
                                </NET_VALUE>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="LineItem/NumberInCollection"/>
                                </ARIBA_ITEM>
                                <ARIBA_SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_SERIAL_NO>
                                <ARIBA_PARENTLN>
                                    <xsl:value-of select="$v_mLineNic"/>
                                </ARIBA_PARENTLN>
                            </item>
                        </xsl:for-each>
                    </xsl:if>
                    <!--service lines-->
                    <xsl:if test="$v_checkSrv = 'X'">
                        <xsl:for-each select="Accountings/SplitAccountings/item">
                            <xsl:variable name="v_splitPos" select="position()"/>
                            <xsl:variable name="v_nic" select="LineItem/NumberInCollection"/>
                            <item>
                                <SRV_LINE>
                                    <xsl:if
                                        test="string-length(normalize-space(//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_nic]/ERPLineItemNumber)) &gt; 1">                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->                     
                                        <xsl:value-of
                                            select="format-number(number(//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_nic]/ERPLineItemNumber), '0000000000')"
                                        />
                                    </xsl:if>
                                </SRV_LINE>
                                <SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/>
                                </SERIAL_NO>
                                <SERIAL_NO_ITEM>
                                    <xsl:value-of select="NumberInCollection"/>
                                </SERIAL_NO_ITEM>
                                <xsl:if test="Quantity">            
                                    <QUANTITY>
                                        <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                    </QUANTITY>
                                </xsl:if>
                                <PERCENT>
                                    <xsl:choose>
                                        <xsl:when test="AdjustedPercentageForSplits > 0">
                                            <xsl:value-of
                                                select="concat(substring-before(AdjustedPercentageForSplits, '.'), '.', substring(substring-after(AdjustedPercentageForSplits, '.'), 1, 1))"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="format-number(Percentage, '000.0')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </PERCENT>
                                <NET_VALUE>
                                    <!-- IG-28311 : added 'when' &'other' conditions to avoid the NaN error   -->
                                    <!-- IG-37134 : Amount formatting based on currency -->
                                    <xsl:variable name="v_Curr">  <!-- This is to store the currency value -->
                                        <xsl:value-of select="AdjustedCostInCurrencyPrecision/Currency/UniqueName"/>
                                    </xsl:variable>
                                    <!-- IG-37134 : Amount formatting based on currency -->
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(AdjustedCostInCurrencyPrecision/Amount)) > 0">
                                            <!-- IG-37134 : Amount formatting based on currency -->
                                            <xsl:choose>
                                                <xsl:when test="$v_Curr = 'JPY'">
                                                    <xsl:call-template name="formatAmount">
                                                        <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                                                    </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$v_Curr = 'VND'">
                                                    <xsl:call-template name="formatAmount">
                                                        <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                                                    </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$v_Curr = 'KRW'">
                                                    <xsl:call-template name="formatAmount">
                                                        <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                                                    </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="format-number(AdjustedCostInCurrencyPrecision/Amount, '0.00')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="string-length(normalize-space(Amount/Amount)) > 0">
                                                <!-- IG-37134 : Amount formatting based on currency -->
                                                <xsl:choose>
                                                    <xsl:when test="$v_Curr = 'JPY'">
                                                        <xsl:call-template name="formatAmount">
                                                            <xsl:with-param name="p_amount" select="Amount/Amount"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test="$v_Curr = 'VND'">
                                                        <xsl:call-template name="formatAmount">
                                                            <xsl:with-param name="p_amount" select="Amount/Amount"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test="$v_Curr = 'KRW'">
                                                        <xsl:call-template name="formatAmount">
                                                            <xsl:with-param name="p_amount" select="Amount/Amount"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="format-number(Amount/Amount, '0.00')"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:if>                                           
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </NET_VALUE>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="LineItem/NumberInCollection"/>
                                </ARIBA_ITEM>
                                <ARIBA_SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_SERIAL_NO>
                                <ARIBA_PARENTLN>
                                    <xsl:value-of select="$v_mLineNic"/>
                                </ARIBA_PARENTLN>
                            </item>
                        </xsl:for-each>
                    </xsl:if>
                  </xsl:if>   
                </xsl:for-each>
            </SERVICEACCOUNT> 
            <SERVICECONTRACTLIMITS>
                <xsl:for-each
                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[HoldForAggregation = '' or HoldForAggregation = 'false' and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '')]">                                       
                    <xsl:if test="string-length(normalize-space(ServiceDetails)) > 0 and string-length(normalize-space(MasterAgreement/Name)) = 10 and string(number(MasterAgreement/Name)) != 'NaN' and string-length(normalize-space(ServiceDetails/ContractLimit/Amount)) > 0"> <!--IG-26075--><!--IG-8224-Service Contract Reference--> <!-- IG-36260: XSLT improvements as per guidelines -->
                        <item>
                            <xsl:if
                                test="string-length(normalize-space(//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) > 0">    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <DOC_ITEM>
                                    <xsl:value-of select="ERPLineItemNumber"/>
                                </DOC_ITEM>
                            </xsl:if>
                            <xsl:if test="(string-length(normalize-space(MasterAgreement/Name)) > 0)">                                               <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <CONTRACT>
                                    <xsl:value-of select="MasterAgreement/Name"/>
                                </CONTRACT>
                                <CONTRACT_ITEM>
                                    <xsl:value-of select="OutlineRootNumber"/>
                                </CONTRACT_ITEM>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(ServiceDetails/ContractLimit/Amount)) > 0">                                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <LIMIT>
                                    <xsl:value-of
                                        select="format-number(ServiceDetails/ContractLimit/Amount, '0.00')"
                                    />
                                </LIMIT>
                            </xsl:if>
                            <ARIBA_ITEM>
                                <xsl:value-of select="NumberInCollection"/>
                            </ARIBA_ITEM>
                            <ARIBA_PARENTLN>
                                <xsl:value-of select="ParentLineNumber"/>
                            </ARIBA_PARENTLN>
                        </item>
                    </xsl:if>
                </xsl:for-each>
            </SERVICECONTRACTLIMITS>
            <SERVICELIMIT>
                <xsl:for-each
                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[HoldForAggregation = '' or HoldForAggregation = 'false' and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '')]">
                    <xsl:variable name="v_posn" select="position()"/>
                    <xsl:variable name="v_nic" select="NumberInCollection"/>
                    <xsl:if test="ServiceDetails">
                        <item>
                            <xsl:if
                                test="string-length(normalize-space(//Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) lt 1">     <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <DOC_ITEM>
                                    <xsl:value-of select="ERPLineItemNumber"/>
                                </DOC_ITEM>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">                          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <OVERALL_LIMIT>
                                    <xsl:value-of
                                        select="format-number(ServiceDetails/MaxAmount/Amount, '0.00')"
                                    />
                                </OVERALL_LIMIT>
                            </xsl:if>
                            <!--  IG-33139 Service PR with discount and currency other than MYR is incorrectly pushing discount amount as expected amount    -->                
                            <xsl:if test="(ServiceDetails/ExpectedAmount/Amount) > 0">                     <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->                       
                                <EXP_VALUE>
                                    <xsl:variable name="v_nic" select="NumberInCollection"/>
                                    <xsl:variable name="v_amount">
                                        <xsl:choose>
                                            <xsl:when
                                                test="(ParentLineNumber = 0) and string-length(normalize-space(Description/ConversionFactor)) > 0">            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                                <xsl:variable name="v_basis_quan">
                                                  <xsl:choose>
                                                      <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                                  <xsl:value-of
                                                  select="Description/PriceBasisQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'1'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:variable>
                                                <xsl:variable name="v_amt_conv">
                                                  <xsl:value-of
                                                        select="ServiceDetails/ExpectedAmount/Amount * Description/ConversionFactor"
                                                    />
                                                </xsl:variable>
                                                <xsl:value-of
                                                    select="($v_amt_conv div $v_basis_quan) * Quantity"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                    select="ServiceDetails/ExpectedAmount/Amount * Quantity"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Charge without TAX-->
                                    <xsl:variable name="v_charge_amt">
                                        <xsl:variable name="v_charge4">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'4'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_charge8">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'8'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_charge16">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'16'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--<xsl:value-of select="$v_charge4 + $v_charge8 + $v_charge16"
                                        />-->
                                        <xsl:value-of
                                            select="sum(($v_charge4 | $v_charge8 | $v_charge16)[number(.) = .])"
                                        />
                                    </xsl:variable>
                                    <!--TAX-->
                                    <xsl:variable name="v_tax_amt">
                                        <xsl:choose>
                                            <xsl:when
                                                test="$v_checkTaxAllowed = 'TRUE' and //Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]">
                                                <xsl:variable name="v_taxLine">
                                                  <xsl:value-of
                                                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]/NumberInCollection"
                                                    />
                                                </xsl:variable>
                                                <xsl:value-of
                                                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_taxLine)]/Description/Price/Amount"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(0, '0.00')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Discount-->
                                    <xsl:variable name="v_discount">
                                        <xsl:variable name="v_discLine">
                                            <xsl:if
                                                test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]">
                                                <xsl:value-of
                                                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]/NumberInCollection"
                                                />
                                            </xsl:if>
                                        </xsl:variable>
                                        <xsl:value-of
                                            select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_discLine)]/Description/Price/Amount"
                                        />
                                    </xsl:variable>
                                    <xsl:variable name="v_sum">
                                        <xsl:call-template name="findSum">
                                            <xsl:with-param name="p_param1" select="$v_amount"/>
                                            <xsl:with-param name="p_param2" select="$v_charge_amt"/>
                                            <xsl:with-param name="p_param3" select="$v_tax_amt"/>
                                            <xsl:with-param name="p_param4" select="$v_discount"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(Description/ConversionFactor)) > 0">            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <xsl:value-of select="$v_sum"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="format-number(($v_sum div Quantity), '0.00')"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </EXP_VALUE>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(ServiceDetails/OtherLimit/Amount)) > 0">                     <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <OTHER_LIMIT>
                                    <xsl:value-of
                                        select="format-number(ServiceDetails/OtherLimit/Amount, '0.00')"
                                    />
                                </OTHER_LIMIT>
                            </xsl:if>
                            <xsl:if
                                test="count(../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item[$v_posn]/Accountings/SplitAccountings/item) > 1">
                                <DISTRIB>
                                    <xsl:call-template name="fixedValues">
                                        <xsl:with-param name="p2pInput"
                                            select="../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item[$v_posn]/Accountings/SplitAccountings/item[1]/Type/UniqueName"
                                        />
                                    </xsl:call-template>
                                </DISTRIB>
                            </xsl:if>
                            <ARIBA_ITEM>
                                <xsl:value-of select="NumberInCollection"/>
                            </ARIBA_ITEM>
                            <ARIBA_PARENTLN>
                                <xsl:value-of select="NumberInCollection"/>
                            </ARIBA_PARENTLN>
                        </item>
                    </xsl:if>
                </xsl:for-each>
            </SERVICELIMIT>
            <SERVICELINES>
                <xsl:for-each
                    select="Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[HoldForAggregation = '' or HoldForAggregation = 'false']">
                    <xsl:variable name="v_pos" select="position()"/>
                    <xsl:if
                        test="ParentLineNumber > 0 and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '')">
                        <xsl:variable name="v_parent" select="ParentLineNumber"/>
                        <item>
                            <DOC_ITEM>
                                <xsl:if
                                    test="string-length(normalize-space(//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_parent]/ERPLineItemNumber)) &gt; 1">                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <xsl:value-of
                                        select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_parent]/ERPLineItemNumber"
                                    />
                                </xsl:if>
                            </DOC_ITEM>
                            <SRV_LINE>
                                <xsl:if test="string-length(normalize-space(ERPLineItemNumber)) &gt; 1">                                                             <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <xsl:value-of
                                        select="format-number(number(ERPLineItemNumber), '0000000000')"
                                    />
                                </xsl:if>
                            </SRV_LINE>
                            <SHORT_TEXT>
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(Description/Description)) > 40">       <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <!--Begin of IG-21063: Short_text 40 chars -->
                                        <xsl:value-of
                                            select="substring(normalize-space(Description/Description), 1, 40)"/>
                                        <!-- End of IG-21063 -->
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(Description/Description)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </SHORT_TEXT>
                            <xsl:if test="Quantity">
                                <QUANTITY>
                                    <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                </QUANTITY>
                            </xsl:if>
                            <UOM>
                                <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                            </UOM>
                            <GROSS_PRICE>
                                <xsl:value-of
                                    select="format-number(Description/Price/Amount, '0.00')"/>
                            </GROSS_PRICE>
                            <CURRENCY>
                                <xsl:value-of select="Amount/Currency/UniqueName"/>
                            </CURRENCY>
                            <PRICE_UNIT>
                                <xsl:value-of select="'1'"/>
                            </PRICE_UNIT>
                            <xsl:if
                                test="count(../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item[$v_pos]/Accountings/SplitAccountings/item) > 1">
                                <DIST_IND_ACC>
                                    <xsl:call-template name="fixedValues">
                                        <xsl:with-param name="p2pInput"
                                            select="../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item[$v_pos]/Accountings/SplitAccountings/item[1]/Type/UniqueName"
                                        />
                                    </xsl:call-template>
                                </DIST_IND_ACC>
                            </xsl:if>
                            <MATL_GROUP>
                                <xsl:value-of select="CommodityCode/UniqueName"/>
                            </MATL_GROUP>
                            <NET_PRICE>
                                <xsl:value-of
                                    select="format-number((Description/Price/Amount * Quantity), '0.00')"
                                />
                            </NET_PRICE>
                            <EXTERNAL_ITEM_ID>
                                <xsl:value-of select="NumberInCollection"/>
                            </EXTERNAL_ITEM_ID>
                            <ARIBA_ITEM>
                                <xsl:value-of select="NumberInCollection"/>
                            </ARIBA_ITEM>
                            <ARIBA_PARENTLN>
                                <xsl:value-of select="ParentLineNumber"/>
                            </ARIBA_PARENTLN>
                        </item>
                    </xsl:if>
                </xsl:for-each>
            </SERVICELINES>            
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:if test="$anSourceDocumentType = $v_budchk">
                <TESTRUN>
                    <xsl:value-of select="'X'"/>
                </TESTRUN>
            </xsl:if>
            <PRACCOUNT>
                <xsl:for-each
                    select="Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item">
                    <xsl:variable name="v_pos" select="position()"/>
                    <xsl:variable name="v_numInCollection"
                        select="Accountings/SplitAccountings/item/LineItem/NumberInCollection"/>
                    <!-- IG-27546 If we have unknown account assignment i.e type 'U', then we don't populate any accounting data -->
                    <xsl:if
                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_numInCollection]/AccountCategory/UniqueName != 'U'">
                    <xsl:for-each select="Accountings/SplitAccountings/item">
                        <!--Check if this line has a Srvline line as parent-->
                        <xsl:variable name="v_pnic" select="LineItem/NumberInCollection"/>
                        <xsl:variable name="v_pLine"
                            select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_pnic]/ParentLineNumber"/>
                        <xsl:variable name="v_check_srv">
                            <xsl:choose>
                                <xsl:when
                                    test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_pLine and exists(ServiceDetails)]/ServiceDetails/RequiresServiceEntry"
                                    >
                                    <xsl:value-of select="'true'"/>
                                </xsl:when>
                                <xsl:when
                                    test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_pnic and exists(ServiceDetails)]/ServiceDetails/RequiresServiceEntry"
                                    >
                                    <xsl:value-of select="'true'"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <!--Check if parent item has max amount/expected amount-->
                        <xsl:variable name="v_check_limit">
                            <xsl:if test="$v_check_srv = 'true'">
                                <xsl:choose>
                                    <xsl:when
                                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_pnic and exists(ServiceDetails)]/ServiceDetails/MaxAmount"
                                        >
                                        <xsl:value-of select="'true'"/>
                                    </xsl:when>
                                    <xsl:when
                                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_pnic and exists(ServiceDetails)]/ServiceDetails/ExpectedAmount"
                                        >
                                        <xsl:value-of select="'true'"/>
                                    </xsl:when>
                                    <xsl:when test="$v_pLine > 0">
                                        <xsl:value-of select="'true'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'false'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:variable>
                        <!--Generate Account information for Only Mainline items-->
                        <xsl:if
                            test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[$v_pos]/((HoldForAggregation = 'false' or HoldForAggregation = '') and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '')) and string-length(normalize-space($v_check_srv)) = 0"> <!-- IG-36260: XSLT improvements as per guidelines -->
                            <item>
                                <xsl:variable name="acct_line">
                                    <xsl:value-of select="LineItem/NumberInCollection"/>
                                </xsl:variable>

                                <xsl:variable name="acct_numColl">
                                    <xsl:value-of select="NumberInCollection"/>
                                </xsl:variable>

                                <xsl:variable name="line">
                                    <xsl:value-of
                                        select="$reqLineDetail[LineType/Category = 32 and (ParentLineNumber = $acct_line)]/NumberInCollection"
                                    />
                                </xsl:variable>

                                <xsl:variable name="discount">
                                    <xsl:value-of
                                        select="$reqAccDetail[LineItem/NumberInCollection = $line and NumberInCollection = $acct_numColl]/AdjustedCostInCurrencyPrecision/Amount"
                                    />
                                </xsl:variable>

                                <SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/>
                                </SERIAL_NO>
                                <xsl:if test="Quantity">
                                    <QUANTITY>
                                        <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                    </QUANTITY>
                                </xsl:if>
                                <DISTR_PERC>
                                    <xsl:variable name="v_percentage">
                                        <!--Logic for CI-11565-->
                                        <xsl:choose>
                                            <xsl:when test="AdjustedPercentageForSplits != 0">
                                                <xsl:value-of
                                                  select="replace(AdjustedPercentageForSplits, '-', '')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="replace(Percentage, '-', '')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <!--End of Logic for CI-11565-->
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="$v_percentage >= 100">
                                            <xsl:value-of select="'0.0'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- <xsl:if test="Percentage">-->
                                            <xsl:value-of
                                                select="format-number($v_percentage, '000.0')"/>
                                            <!--</xsl:if>-->
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </DISTR_PERC>
                                <NET_VALUE>
                                    <xsl:variable name="v_lineNic"
                                        select="LineItem/NumberInCollection"/>
                                    <xsl:variable name="v_nic" select="NumberInCollection"/>
                                    <xsl:variable name="v_Charge4">
                                        <xsl:call-template name="findAccChargeAmt">
                                            <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                            <xsl:with-param name="p_nic" select="$v_nic"/>
                                            <xsl:with-param name="p_chargeType" select="'4'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="v_Charge8">
                                        <xsl:call-template name="findAccChargeAmt">
                                            <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                            <xsl:with-param name="p_nic" select="$v_nic"/>
                                            <xsl:with-param name="p_chargeType" select="'8'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="v_Charge16">
                                        <xsl:call-template name="findAccChargeAmt">
                                            <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                            <xsl:with-param name="p_nic" select="$v_nic"/>
                                            <xsl:with-param name="p_chargeType" select="'16'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="v_charge_amt">
                                        <!-- <xsl:value-of select="$v_Charge4 + $v_Charge8 + $v_Charge16"
                                        />-->
                                        <xsl:value-of
                                            select="sum(($v_Charge4 | $v_Charge8 | $v_Charge16)[number(.) = .])"
                                        />
                                    </xsl:variable>
                                    <!--Tax without Charge-->
                                    <xsl:variable name="v_tax_amt">
                                        <xsl:choose>
                                            <xsl:when test="$v_checkTaxAllowed = 'TRUE'">
                                                <!-- IG-35153 : Error when PR is created in P2P with tax and split accounting by amount -->
                                                <xsl:choose>
                                                    <!-- If the Distribution type is by amount, get the value of splitted tax from Requisition Accounting details -->
                                                    <xsl:when test="Type/UniqueName = '_Amount'">
                                                        <xsl:if test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_lineNic) and LineType/Category = 2 and TaxDetail/IsDeductible = 'false']">
                                                            <xsl:variable name="v_split_nic">
                                                                <xsl:value-of select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_lineNic) and LineType/Category = 2 and (TaxDetail/IsDeductible = 'false')]/NumberInCollection"/>
                                                            </xsl:variable>
                                                            <xsl:choose>
                                                                <xsl:when test="string-length(normalize-space(//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_split_nic and NumberInCollection = $v_nic]/AdjustedCostInCurrencyPrecision/Amount)) > 0">
                                                                    <xsl:value-of select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_split_nic and NumberInCollection = $v_nic]/AdjustedCostInCurrencyPrecision/Amount"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_split_nic and NumberInCollection = $v_nic]/Amount/Amount"/>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <!-- If the Distribution type is NOT by amount -->
                                                    <xsl:otherwise>
                                                        <xsl:if test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and TaxDetail/IsDeductible = 'false']">
                                                            <xsl:value-of select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType/Category = 2 and (TaxDetail/IsDeductible = 'false')]/Description/Price/Amount"/>
                                                        </xsl:if>                                                        
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <!-- IG-35153 : Error when PR is created in P2P with tax and split accounting by amount -->
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(0, '0.00')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Discount-->
                                    <xsl:variable name="v_disc_amt">
                                        <xsl:value-of select="$discount"/>
                                    </xsl:variable>
                                    <xsl:variable name="v_cur_amt">
                                        <xsl:value-of
                                            select="AdjustedCostInCurrencyPrecision/Amount"/>
                                    </xsl:variable>
                                    <xsl:call-template name="findSum">
                                        <xsl:with-param name="p_param1" select="$v_charge_amt"/>
                                        <xsl:with-param name="p_param2" select="$v_tax_amt"/>
                                        <xsl:with-param name="p_param3" select="$v_cur_amt"/>
                                        <xsl:with-param name="p_param4" select="$v_disc_amt"/>
                                    </xsl:call-template>
                                </NET_VALUE>
                                <GL_ACCOUNT>
                                    <xsl:value-of select="GeneralLedger/UniqueName"/>
                                </GL_ACCOUNT>
                                <COSTCENTER>
                                    <xsl:value-of select="CostCenter/UniqueName"/>
                                </COSTCENTER>
                                <ASSET_NO>
                                    <xsl:value-of select="Asset/UniqueName"/>
                                </ASSET_NO>
                                <SUB_NUMBER>
                                    <xsl:value-of select="Asset/SubNumber"/>
                                </SUB_NUMBER>
                                <ORDERID>
                                    <xsl:value-of select="InternalOrder/UniqueName"/>
                                </ORDERID>
                                <WBS_ELEMENT>
                                    <xsl:value-of select="WBSElement/UniqueName"/>
                                </WBS_ELEMENT>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <xsl:if test="string-length(normalize-space(Network/UniqueName)) > 0">
                                <NETWORK>
                                    <xsl:value-of select="Network/UniqueName"/>
                                </NETWORK>
                                </xsl:if>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <FUNDS_CTR>
                                    <xsl:value-of select="custom/CustomFundsCenter/UniqueName"/>
                                </FUNDS_CTR>
                                <FUND>
                                    <xsl:value-of select="custom/CustomFund"/>
                                </FUND>
                                <RES_DOC>
                                    <xsl:value-of
                                        select="custom/CustomEarmarkedFundsDocument/UniqueName"/>
                                </RES_DOC>
                                <RES_ITEM>
                                    <xsl:value-of
                                        select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 12)"
                                    />
                                </RES_ITEM>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <xsl:if test="string-length(normalize-space(ActivityNumber/UniqueName)) > 0">
                                <ACTIVITY>
                                    <xsl:value-of select="ActivityNumber/UniqueName"/>
                                </ACTIVITY>
                                </xsl:if>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <GRANT_NBR>
                                    <xsl:value-of select="custom/CustomGrant/UniqueName"/>
                                </GRANT_NBR>
                                <CMMT_ITEM_LONG>
                                    <xsl:value-of select="custom/CustomCommitmentItem/UniqueName"/>
                                </CMMT_ITEM_LONG>
                                <FUNC_AREA_LONG>
                                    <xsl:value-of select="custom/CustomFunctionalArea/UniqueName"/>
                                </FUNC_AREA_LONG>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="LineItem/NumberInCollection"/>
                                </ARIBA_ITEM>
                                <ARIBA_PREQ_ITEM>
                                    <xsl:value-of select="LineItem/NumberInCollection"/>
                                </ARIBA_PREQ_ITEM>
                                <ARIBA_SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_SERIAL_NO>
                                <!-- IG-24673: BudgetPeriod Mapping-->
                                <ARBCIG_BUDGET_PERIOD>
                                    <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
                                </ARBCIG_BUDGET_PERIOD>
                            </item>
                        </xsl:if>
                        <!--*********************************************************************************************************************************-->
                        <!--Generate Account information for Only Service items-->
                        <xsl:if
                            test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[$v_pos]/((HoldForAggregation = 'false' or HoldForAggregation = '') and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '')) and string-length(normalize-space($v_check_srv)) > 0 and $v_check_limit = 'true'"> <!-- IG-36260: XSLT improvements as per guidelines -->
                            <xsl:variable name="v_glAcc" select="GeneralLedger/UniqueName"/>
                            <xsl:variable name="v_cc" select="CostCenter/UniqueName"/>
                            <xsl:variable name="v_io" select="InternalOrder/UniqueName"/>
                            <xsl:variable name="v_wbs" select="WBSElement/UniqueName"/>
                            <item>
                                <SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/>
                                </SERIAL_NO>
                                <GL_ACCOUNT>
                                    <xsl:value-of select="GeneralLedger/UniqueName"/>
                                </GL_ACCOUNT>
                                <COSTCENTER>
                                    <xsl:value-of select="CostCenter/UniqueName"/>
                                </COSTCENTER>
                                <ASSET_NO>
                                    <xsl:value-of select="Asset/UniqueName"/>
                                </ASSET_NO>
                                <SUB_NUMBER>
                                    <xsl:value-of select="Asset/SubNumber"/>
                                </SUB_NUMBER>
                                <ORDERID>
                                    <xsl:value-of select="InternalOrder/UniqueName"/>
                                </ORDERID>
                                <WBS_ELEMENT>
                                    <xsl:value-of select="WBSElement/UniqueName"/>
                                </WBS_ELEMENT>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <xsl:if test="string-length(normalize-space(Network/UniqueName)) > 0">
                                <NETWORK>
                                    <xsl:value-of select="Network/UniqueName"/>
                                </NETWORK>
                                </xsl:if>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <FUNDS_CTR>
                                    <xsl:value-of select="custom/CustomFundsCenter/UniqueName"/>
                                </FUNDS_CTR>
                                <FUND>
                                    <xsl:value-of select="custom/CustomFund"/>
                                </FUND>
                                <RES_DOC>
                                    <xsl:value-of
                                        select="custom/CustomEarmarkedFundsDocument/UniqueName"/>
                                </RES_DOC>
                                <RES_ITEM>
                                    <xsl:value-of
                                        select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 12)"
                                    />
                                </RES_ITEM>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <xsl:if test="string-length(normalize-space(ActivityNumber/UniqueName)) > 0">
                                <ACTIVITY>
                                    <xsl:value-of select="ActivityNumber/UniqueName"/>
                                </ACTIVITY>
                                </xsl:if>
                                <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                <GRANT_NBR>
                                    <xsl:value-of select="custom/CustomGrant/UniqueName"/>
                                </GRANT_NBR>
                                <CMMT_ITEM_LONG>
                                    <xsl:value-of select="custom/CustomCommitmentItem/UniqueName"/>
                                </CMMT_ITEM_LONG>
                                <FUNC_AREA_LONG>
                                    <xsl:value-of select="custom/CustomFunctionalArea/UniqueName"/>
                                </FUNC_AREA_LONG>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="LineItem/NumberInCollection"/>
                                </ARIBA_ITEM>
                                <ARIBA_PREQ_ITEM>
                                    <xsl:choose>
                                        <xsl:when test="$v_pLine > 0">
                                            <xsl:variable name="v_acc_p"
                                                select="LineItem/NumberInCollection"/>
                                            <xsl:value-of
                                                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[NumberInCollection = $v_acc_p]/ParentLineNumber"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="LineItem/NumberInCollection"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </ARIBA_PREQ_ITEM>
                                <ARIBA_SERIAL_NO>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_SERIAL_NO>
                                <!-- IG-24673: BudgetPeriod Mapping-->
                                <ARBCIG_BUDGET_PERIOD>
                                    <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
                                </ARBCIG_BUDGET_PERIOD>
                            </item>
                        </xsl:if>
                        <!--*********************************************************************************************************************************-->
                        <!--Generate Account information for Charges-with-tax on Mainline items-->
                        <xsl:if
                            test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[$v_pos]/((HoldForAggregation = 'false' or HoldForAggregation = '') and (LineType/Category = '4' or LineType/Category = '8' or LineType/Category = '16'))">
                            <xsl:variable name="v_prntNum"
                                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[$v_pos][((HoldForAggregation = 'false' or HoldForAggregation = '') and (LineType/Category = '4' or LineType/Category = '8' or LineType/Category = '16'))]/NumberInCollection"/>
                            <xsl:if
                                test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (LineType/Category = '2')]/ParentLineNumber = $v_prntNum">
                                <item>
                                    <SERIAL_NO>
                                        <xsl:value-of select="NumberInCollection"/>
                                    </SERIAL_NO>
                                    <xsl:if test="Quantity">
                                        <QUANTITY>
                                            <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                        </QUANTITY>
                                    </xsl:if>
                                    <DISTR_PERC>
                                        <xsl:variable name="v_percentage">
                                            <xsl:value-of select="replace(Percentage, '-', '')"/>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$v_percentage >= 100">
                                                <xsl:value-of select="'0.0'"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="Percentage">
                                                  <xsl:value-of
                                                  select="format-number(Percentage, '000.0')"/>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </DISTR_PERC>
                                    <NET_VALUE>
                                        <xsl:variable name="v_lineNic"
                                            select="LineItem/NumberInCollection"/>
                                        <xsl:variable name="v_nic" select="NumberInCollection"/>
                                        <xsl:variable name="v_Charge4">
                                            <xsl:call-template name="findAccChargeAmt">
                                                <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'4'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_Charge8">
                                            <xsl:call-template name="findAccChargeAmt">
                                                <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'8'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_Charge16">
                                            <xsl:call-template name="findAccChargeAmt">
                                                <xsl:with-param name="p_lineNic" select="$v_lineNic"/>
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'16'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_charge_amt">
                                            <!--<xsl:value-of
                                                select="$v_Charge4 + $v_Charge8 + $v_Charge16"/>-->
                                            <xsl:value-of
                                                select="sum(($v_Charge4 | $v_Charge8 | $v_Charge16)[number(.) = .])"
                                            />
                                        </xsl:variable>
                                        <!--Tax without Charge-->
                                        <xsl:variable name="v_tax_amt">
                                            <xsl:choose>
                                                <xsl:when test="$v_checkTaxAllowed = 'TRUE'">
                                                  <xsl:variable name="v_lineNo">
                                                  <xsl:if
                                                  test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_lineNic) and LineType/Category = '2' and TaxDetail/IsDeductible = 'false']">
                                                  <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_lineNic) and LineType/Category = '2' and TaxDetail/IsDeductible = 'false']/NumberInCollection"
                                                  />
                                                  </xsl:if>
                                                  </xsl:variable>
                                                  <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_lineNo and NumberInCollection = $v_nic]/AdjustedCostInCurrencyPrecision/Amount"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="format-number(0, '0.00')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <!--Discount-->
                                        <xsl:variable name="v_disc_amt">
                                            <xsl:variable name="v_lineNo">
                                                <xsl:if
                                                  test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_lineNic) and LineType/Category = '32']">
                                                  <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_lineNic) and LineType/Category = ('32')]/NumberInCollection"
                                                  />
                                                </xsl:if>
                                            </xsl:variable>
                                            <xsl:value-of
                                                select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_lineNo and NumberInCollection = $v_nic]/AdjustedCostInCurrencyPrecision/Amount"
                                            />
                                        </xsl:variable>
                                        <xsl:variable name="v_cur_amt">
                                            <xsl:value-of
                                                select="AdjustedCostInCurrencyPrecision/Amount"/>
                                        </xsl:variable>
                                        <xsl:call-template name="findSum">
                                            <xsl:with-param name="p_param1" select="$v_charge_amt"/>
                                            <xsl:with-param name="p_param2" select="$v_tax_amt"/>
                                            <xsl:with-param name="p_param3" select="$v_cur_amt"/>
                                            <xsl:with-param name="p_param4" select="$v_disc_amt"/>
                                        </xsl:call-template>
                                    </NET_VALUE>
                                    <GL_ACCOUNT>
                                        <xsl:value-of select="GeneralLedger/UniqueName"/>
                                    </GL_ACCOUNT>
                                    <COSTCENTER>
                                        <xsl:value-of select="CostCenter/UniqueName"/>
                                    </COSTCENTER>
                                    <ASSET_NO>
                                        <xsl:value-of select="Asset/UniqueName"/>
                                    </ASSET_NO>
                                    <SUB_NUMBER>
                                        <xsl:value-of select="Asset/SubNumber"/>
                                    </SUB_NUMBER>
                                    <ORDERID>
                                        <xsl:value-of select="InternalOrder/UniqueName"/>
                                    </ORDERID>
                                    <WBS_ELEMENT>
                                        <xsl:value-of select="WBSElement/UniqueName"/>
                                    </WBS_ELEMENT>
                                    <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                    <xsl:if test="string-length(normalize-space(Network/UniqueName)) > 0">
                                    <NETWORK>
                                        <xsl:value-of select="Network/UniqueName"/>
                                    </NETWORK>
                                    </xsl:if>
                                    <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                    <FUNDS_CTR>
                                        <xsl:value-of select="custom/CustomFundsCenter/UniqueName"/>
                                    </FUNDS_CTR>
                                    <FUND>
                                        <xsl:value-of select="custom/CustomFund"/>
                                    </FUND>
                                    <RES_DOC>
                                        <xsl:value-of
                                            select="custom/CustomEarmarkedFundsDocument/UniqueName"
                                        />
                                    </RES_DOC>
                                    <RES_ITEM>
                                        <xsl:value-of
                                            select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 12)"
                                        />
                                    </RES_ITEM>
                                    <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                    <xsl:if test="string-length(normalize-space(ActivityNumber/UniqueName)) > 0">
                                    <ACTIVITY>
                                        <xsl:value-of select="ActivityNumber/UniqueName"/>
                                    </ACTIVITY>
                                    </xsl:if>
                                    <!--IG-28021: Mapping Network and Activity for Account assignment -->
                                    <GRANT_NBR>
                                        <xsl:value-of select="custom/CustomGrant/UniqueName"/>
                                    </GRANT_NBR>
                                    <CMMT_ITEM_LONG>
                                        <xsl:value-of
                                            select="custom/CustomCommitmentItem/UniqueName"/>
                                    </CMMT_ITEM_LONG>
                                    <FUNC_AREA_LONG>
                                        <xsl:value-of
                                            select="custom/CustomFunctionalArea/UniqueName"/>
                                    </FUNC_AREA_LONG>
                                    <ARIBA_ITEM>
                                        <xsl:value-of select="LineItem/NumberInCollection"/>
                                    </ARIBA_ITEM>
                                    <ARIBA_PREQ_ITEM>
                                        <xsl:value-of select="LineItem/NumberInCollection"/>
                                    </ARIBA_PREQ_ITEM>
                                    <ARIBA_SERIAL_NO>
                                        <xsl:value-of select="NumberInCollection"/>
                                    </ARIBA_SERIAL_NO>
                                    <!-- IG-24673: BudgetPeriod Mapping-->
                                    <ARBCIG_BUDGET_PERIOD>
                                        <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
                                    </ARBCIG_BUDGET_PERIOD>
                                </item>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
            </PRACCOUNT>
            <PRITEM>
                <xsl:choose>
                    <xsl:when
                        test="exists(Requisition_BudgetReqExportHeaderDetails_Item/item/ERPHeldLinesNotToBeDeleted) and Requisition_BudgetReqExportHeaderDetails_Item/item/ERPHeldLinesNotToBeDeleted = 'true'">
                        <xsl:for-each
                            select="Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(not(exists(LineType/Category)) or LineType/Category = '1' or LineType/Category = '') and (ParentLineNumber = 0)]">
                            <item>
                                <xsl:variable name="v_nic" select="NumberInCollection"/>
                                <PREQ_ITEM>
                                    <xsl:if
                                        test="string-length(normalize-space(Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) lt 1">          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <xsl:value-of select="ERPLineItemNumber"/>
                                    </xsl:if>
                                </PREQ_ITEM>
                                <PUR_GROUP> 
                                    <xsl:value-of select="PurchaseGroup/UniqueName"/>
                                </PUR_GROUP>
                                <PREQ_NAME>
                                    <xsl:choose>
                                        <xsl:when
                                            test="string-length(normalize-space(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName)) gt 12">  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <xsl:value-of
                                                select="substring(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName, 0, 13)"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </PREQ_NAME>
                                <SHORT_TEXT>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(Description/Description)) > 40">                                                        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <!--Begin of IG-21063: Short_text 40 chars -->
                                            <xsl:value-of
                                                select="substring(normalize-space(Description/Description), 1, 40)"/>
                                            <!-- End of IG-21063 -->
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(Description/Description)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </SHORT_TEXT>
                                <MATERIAL>
                                    <xsl:value-of select="Description/ItemNumber"/>
                                </MATERIAL>
                                <PLANT>
                                    <xsl:variable name="v_plant">
                                        <xsl:choose>
                                            <xsl:when
                                                test="
                                                    HasAdhocShipToAddress = 'true' and
                                                    string-length(normalize-space($v_adhocShipTo)) > 0"> <!--IG-20990 --> <!-- IG-36260: XSLT improvements as per guidelines -->
                                                <xsl:value-of
                                                    select="$v_adhocShipTo"/> <!--IG-20990 -->
                                            </xsl:when>
                                            <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">               <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                                <xsl:value-of select="SAPPlant/UniqueName"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="ShipTo/UniqueName"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:value-of select="substring($v_plant, 1, 4)"/>
                                </PLANT>
                                <MATL_GROUP>
                                    <xsl:value-of select="CommodityCode/UniqueName"/>
                                </MATL_GROUP>
                                <xsl:if test="Quantity">
                                    <QUANTITY>
                                        <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                    </QUANTITY>
                                </xsl:if>
                                <UNIT>
                                    <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                                </UNIT>
                                <PREQ_DATE>
                                    <xsl:call-template name="erpDate"/>
                                </PREQ_DATE>
                                <xsl:choose>
                                    <xsl:when test="NeedBy">
                                        <DELIV_DATE>
                                            <xsl:call-template name="erpDate">
                                                <xsl:with-param name="p2pDate" select="NeedBy"/>
                                            </xsl:call-template>
                                        </DELIV_DATE>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <DELIV_DATE>
                                            <xsl:call-template name="erpDate"/>
                                        </DELIV_DATE>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <PREQ_PRICE>
                                    <xsl:variable name="v_nic" select="NumberInCollection"/>
                                    <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                    <xsl:variable name="v_quantity">
                                        <xsl:choose>
                                            <xsl:when
                                                test="string-length(normalize-space(Quantity)) > 0">
                                                <xsl:value-of select="Quantity"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'1'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="v_amount">
                                        <xsl:choose>
                                            <xsl:when
                                                test="(ParentLineNumber = 0) and string-length(normalize-space(Description/ConversionFactor)) > 0">
                                                <!--Begin of IG-16774: If the user has entered the Unit Conversion in P2P UI then multiply price * conv. factor. 
                                                    Otherwise, map the price as it is. Before this fix we were sending wrongly the total calculated price to ERP based on the formula  ( Amount * Conversion factor /PBQ ) * Quantity -->
                                                <xsl:value-of
                                                  select="Description/Price/Amount * Description/ConversionFactor"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="Description/Price/Amount"/>
                                                <!-- End of IG-16774 -->
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Charge without TAX-->
                                    <xsl:variable name="v_charge_amt">
                                        <xsl:variable name="v_charge4">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'4'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_charge8">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'8'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_charge16">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'16'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--                                <xsl:value-of select="$v_charge4 + $v_charge8 + $v_charge16"/>-->
                                        <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                        <xsl:value-of
                                            select="sum(($v_charge4 | $v_charge8 | $v_charge16)[number(.) = .]) div $v_quantity"
                                        />
                                    </xsl:variable>
                                    <!--TAX-->
                                    <xsl:variable name="v_tax_amt">
                                        <xsl:choose>
                                            <xsl:when
                                                test="$v_checkTaxAllowed = 'TRUE' and //Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]">
                                                <xsl:variable name="v_taxLine">
                                                  <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]/NumberInCollection"
                                                  />
                                                </xsl:variable>
                                                <xsl:variable name="v_taxAmount">
                                                  <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]/NumberInCollection"
                                                  />
                                                </xsl:variable>
                                                <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                                <xsl:value-of
                                                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_taxLine)]/Description/Price/Amount div $v_quantity"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(0, '0.00')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Discount-->
                                    <xsl:variable name="v_discount">
                                        <xsl:variable name="v_discLine">
                                            <xsl:if
                                                test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]">
                                                <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]/NumberInCollection"
                                                />
                                            </xsl:if>
                                        </xsl:variable>
                                        <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                        <xsl:value-of
                                            select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_discLine)]/Description/Price/Amount div $v_quantity"
                                        />
                                    </xsl:variable>
                                    <xsl:variable name="v_sum">
                                        <xsl:call-template name="findSum">
                                            <xsl:with-param name="p_param1" select="$v_amount"/>
                                            <xsl:with-param name="p_param2" select="$v_charge_amt"/>
                                            <xsl:with-param name="p_param3" select="$v_tax_amt"/>
                                            <xsl:with-param name="p_param4" select="$v_discount"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <!-- Begin of IG-16774: Refined logic to send Amount value instead of Total valuation price-->
                                    <xsl:value-of select="$v_sum"/>
                                    <!-- End of IG-16774 -->
                                </PREQ_PRICE>
                                <!--  Price Basis Quantity   -->
                                <PRICE_UNIT>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">                                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <xsl:value-of
                                                select="format-number(Description/PriceBasisQuantity, '0')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'1'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </PRICE_UNIT>
                                <!--Map D when RequiresServiceEntry is true, Map B when RequiresServiceEntry is false and ItemCategory/UniqueName is B else blank -->
                                <xsl:choose>
                                    <xsl:when test="ServiceDetails/RequiresServiceEntry = 'true'">
                                        <ITEM_CAT>
                                            <xsl:value-of select="'D'"/>
                                        </ITEM_CAT>
                                    </xsl:when>
                                    <xsl:when
                                        test="(ServiceDetails/RequiresServiceEntry = 'false' and ItemCategory/UniqueName = 'B')">
                                        <ITEM_CAT>
                                            <xsl:value-of select="'B'"/>
                                        </ITEM_CAT>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <ITEM_CAT/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <ACCTASSCAT>
                                    <xsl:value-of select="AccountCategory/UniqueName"/>
                                </ACCTASSCAT>
                                <xsl:if
                                    test="count(../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]) > 1">
                                    <DISTRIB>
                                        <xsl:call-template name="fixedValues">
                                            <xsl:with-param name="p2pInput"
                                                select="../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]/Type/UniqueName"
                                            />
                                        </xsl:call-template>
                                    </DISTRIB>
                                    <PART_INV>
                                        <xsl:value-of select="'2'"/>
                                    </PART_INV>
                                </xsl:if>
                                <GR_IND>
                                    <!--                      For Simple Service - GR_IND should not be mapped-->
                                    <xsl:if
                                        test="(ParentLineNumber = 0 and (not(ServiceDetails/NonSESBasedInvoice) or ServiceDetails/NonSESBasedInvoice != 'true'))"
                                        >
                                        <xsl:value-of select="'X'"/>
                                    </xsl:if>
                                </GR_IND>
                                <xsl:if test="not(Supplier/UniqueName = '[Unspecified]')">
                                    <DES_VENDOR>
                                        <xsl:value-of select="Supplier/UniqueName"/>
                                    </DES_VENDOR>
                                </xsl:if>
                                <PURCH_ORG>
                                    <xsl:value-of select="PurchaseOrg/UniqueName"/>
                                </PURCH_ORG>
                                <xsl:if test="ServiceDetails/RequiresServiceEntry = 'true' 
                                    and string-length(normalize-space(MasterAgreement/Name)) > 0 
                                    and string-length(normalize-space(MasterAgreement/Name)) = 10 
                                    and string(number(MasterAgreement/Name)) != 'NaN' ">                                  <!-- <IG-8224:-Contract Reference>   -->                                 
                                    <AGREEMENT>
                                        <xsl:value-of select="MasterAgreement/Name"/>
                                    </AGREEMENT>
                                    <AGMT_ITEM>                                    
                                        <xsl:value-of select="OutlineRootNumber"/>
                                    </AGMT_ITEM>
                                </xsl:if>   
                                <CURRENCY>
                                    <xsl:value-of select="Amount/Currency/UniqueName"/>
                                </CURRENCY>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_ITEM>
                                <xsl:if test="LineType/Category">
                                    <ARIBA_LINETYPE>
                                        <xsl:value-of select="LineType/Category"/>
                                    </ARIBA_LINETYPE>
                                </xsl:if>
                                <ARIBA_PARENTLN>
                                    <xsl:value-of select="ParentLineNumber"/>
                                </ARIBA_PARENTLN>
                                <TAX_DEDUCTIBLE>
                                    <xsl:value-of select="TaxDetail/IsDeductible"/>
                                </TAX_DEDUCTIBLE>
                                <xsl:if test="ServiceDetails">
                                    <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <MAXAMOUNT>
                                            <xsl:value-of
                                                select="format-number(ServiceDetails/MaxAmount/Amount, '0.00')"
                                            />
                                        </MAXAMOUNT>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Amount)) > 0">         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <EXPECTEDAMOUNT>
                                            <xsl:value-of
                                                select="format-number(ServiceDetails/ExpectedAmount/Amount, '0.00')"
                                            />
                                        </EXPECTEDAMOUNT>
                                    </xsl:if>
                                    <MAXAMOUNT_CURRENCY>
                                        <xsl:value-of
                                            select="ServiceDetails/MaxAmount/Currency/UniqueName"/>
                                    </MAXAMOUNT_CURRENCY>
                                    <!--when Item Category 'B'-->
                                    <REQUIRESSERVICEENTRY>
                                        <xsl:if
                                            test="((ServiceDetails/RequiresServiceEntry = 'true') or (ServiceDetails/RequiresServiceEntry = 'false' and ItemCategory/UniqueName = 'B'))"
                                            >
                                            <xsl:value-of select="'X'"/>
                                        </xsl:if>
                                    </REQUIRESSERVICEENTRY>
                                    <EXPECTD_CURRENCY>
                                        <xsl:value-of
                                            select="ServiceDetails/ExpectedAmount/Currency/UniqueName"
                                        />
                                    </EXPECTD_CURRENCY>
                                </xsl:if>
                                <MATERIAL_LNG>
                                    <xsl:value-of select="Description/ItemNumber"/>
                                </MATERIAL_LNG>
                                <xsl:if test="HoldForAggregation = 'true'">
                                    <HELD_LINE_IND>
                                        <xsl:value-of select="'X'"/>
                                    </HELD_LINE_IND>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(OriginatingSystemLineNumber)) > 0">                                                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->     
                                    <OSLN>
                                        <xsl:value-of select="OriginatingSystemLineNumber"/>
                                    </OSLN>
                                </xsl:if>
                            </item>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each
                            select="Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and ((not(exists(LineType/Category))) or LineType/Category = '1' or LineType/Category = '') and (ParentLineNumber = 0)]">
                            <item>
                                <xsl:variable name="v_nic" select="NumberInCollection"/>
                                <PREQ_ITEM>
                                    <xsl:if
                                        test="string-length(normalize-space(Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) lt 1">        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <xsl:value-of select="ERPLineItemNumber"/>
                                    </xsl:if>
                                </PREQ_ITEM>
                                <PUR_GROUP>
                                    <xsl:value-of select="PurchaseGroup/UniqueName"/>
                                </PUR_GROUP>
                                <PREQ_NAME>
                                    <xsl:choose>
                                        <xsl:when
                                            test="string-length(normalize-space(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName)) gt 12">    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->      
                                            <xsl:value-of
                                                select="substring(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName, 0, 13)"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </PREQ_NAME>
                                <SHORT_TEXT>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(Description/Description)) > 40">                              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <!--Begin of IG-21063: Short_text 40 chars -->
                                            <xsl:value-of
                                                select="substring(normalize-space(Description/Description), 1, 40)"/>
                                            <!-- End of IG-21063 -->
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(Description/Description)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </SHORT_TEXT>
                                <MATERIAL>
                                    <xsl:value-of select="Description/ItemNumber"/>
                                </MATERIAL>
                                <PLANT>
                                    <xsl:variable name="v_plant">
                                        <xsl:choose>
                                            <xsl:when
                                                test="
                                                    HasAdhocShipToAddress = 'true' and
                                                    string-length(normalize-space($v_adhocShipTo)) > 0"> <!--IG-20990 --> <!-- IG-36260: XSLT improvements as per guidelines -->
                                                <xsl:value-of
                                                    select="$v_adhocShipTo"/> <!--IG-20990 -->
                                            </xsl:when>
                                            <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">                                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                                <xsl:value-of select="SAPPlant/UniqueName"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="ShipTo/UniqueName"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:value-of select="substring($v_plant, 1, 4)"/>
                                </PLANT>
                                <MATL_GROUP>
                                    <xsl:value-of select="CommodityCode/UniqueName"/>
                                </MATL_GROUP>
                                <xsl:if test="Quantity">
                                    <QUANTITY>
                                        <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                    </QUANTITY>
                                </xsl:if>
                                <UNIT>
                                    <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                                </UNIT>
                                <PREQ_DATE>
                                    <xsl:call-template name="erpDate"/>
                                </PREQ_DATE>
                                <xsl:choose>
                                    <xsl:when test="NeedBy">
                                        <DELIV_DATE>
                                            <xsl:call-template name="erpDate">
                                                <xsl:with-param name="p2pDate" select="NeedBy"/>
                                            </xsl:call-template>
                                        </DELIV_DATE>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <DELIV_DATE>
                                            <xsl:call-template name="erpDate"/>
                                        </DELIV_DATE>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <PREQ_PRICE>
                                    <xsl:variable name="v_nic" select="NumberInCollection"/>
                                    <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                    <xsl:variable name="v_quantity">
                                        <xsl:choose>
                                            <xsl:when
                                                test="string-length(normalize-space(Quantity)) > 0">
                                                <xsl:value-of select="Quantity"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'1'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="v_amount">
                                        <xsl:choose>
                                            <xsl:when
                                                test="(ParentLineNumber = 0) and string-length(normalize-space(Description/ConversionFactor)) > 0">                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                                <!--Begin of IG-16774: If the user has entered the Unit Conversion in P2P UI then multiply price * conv. factor. 
                                                    Otherwise, map the price as it is. Before this fix we were sending wrongly the total calculated price to ERP based on the formula  ( Amount * Conversion factor /PBQ ) * Quantity -->
                                                <xsl:value-of
                                                  select="Description/Price/Amount * Description/ConversionFactor"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="Description/Price/Amount"/>
                                            </xsl:otherwise>
                                            <!-- End of IG-16774 -->
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Charge without TAX-->
                                    <xsl:variable name="v_charge_amt">
                                        <xsl:variable name="v_charge4">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'4'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_charge8">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'8'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_charge16">
                                            <xsl:call-template name="findChargeAmt">
                                                <xsl:with-param name="p_nic" select="$v_nic"/>
                                                <xsl:with-param name="p_chargeType" select="'16'"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--                                <xsl:value-of select="$v_charge4 + $v_charge8 + $v_charge16"/>-->
                                        <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                        <xsl:value-of
                                            select="sum(($v_charge4 | $v_charge8 | $v_charge16)[number(.) = .]) div $v_quantity"
                                        />                                        
                                    </xsl:variable>
                                    <!--TAX-->
                                    <xsl:variable name="v_tax_amt">
                                        <xsl:choose>
                                            <xsl:when
                                                test="$v_checkTaxAllowed = 'TRUE' and //Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]">
                                                <xsl:variable name="v_taxLine">
                                                  <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]/NumberInCollection"
                                                  />
                                                </xsl:variable>
                                                <xsl:variable name="v_taxAmount">
                                                  <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]/NumberInCollection"
                                                  />
                                                </xsl:variable>
                                                <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                                <xsl:value-of
                                                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_taxLine)]/Description/Price/Amount div $v_quantity"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(0, '0.00')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <!--Discount-->
                                    <xsl:variable name="v_discount">
                                        <xsl:variable name="v_discLine">
                                            <xsl:if
                                                test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]">
                                                <xsl:value-of
                                                  select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]/NumberInCollection"
                                                />
                                            </xsl:if>
                                        </xsl:variable>
                                        <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                        <xsl:value-of
                                            select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_discLine)]/Description/Price/Amount div $v_quantity"
                                        />
                                    </xsl:variable>
                                    <xsl:variable name="v_sum">
                                        <xsl:call-template name="findSum">
                                            <xsl:with-param name="p_param1" select="$v_amount"/>
                                            <xsl:with-param name="p_param2" select="$v_charge_amt"/>
                                            <xsl:with-param name="p_param3" select="$v_tax_amt"/>
                                            <xsl:with-param name="p_param4" select="$v_discount"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <!-- Begin of IG-16774: Refined logic to send Amount value instead of Total valuation price-->
                                    <xsl:value-of select="$v_sum"/>
                                    <!-- End of IG-16774 -->
                                </PREQ_PRICE>
                                <!--  Price Basis Quantity   -->
                                <PRICE_UNIT>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">                           <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <xsl:value-of
                                                select="format-number(Description/PriceBasisQuantity, '0')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'1'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </PRICE_UNIT>
                                <!--Map D when RequiresServiceEntry is true, Map B when RequiresServiceEntry is false and ItemCategory/UniqueName is B else blank -->
                                <xsl:choose>
                                    <xsl:when test="ServiceDetails/RequiresServiceEntry = 'true'">
                                        <ITEM_CAT>
                                            <xsl:value-of select="'D'"/>
                                        </ITEM_CAT>
                                    </xsl:when>
                                    <xsl:when
                                        test="(ServiceDetails/RequiresServiceEntry = 'false' and ItemCategory/UniqueName = 'B')">
                                        <ITEM_CAT>
                                            <xsl:value-of select="'B'"/>
                                        </ITEM_CAT>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <ITEM_CAT/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <ACCTASSCAT>
                                    <xsl:value-of select="AccountCategory/UniqueName"/>
                                </ACCTASSCAT>
                                <xsl:if
                                    test="count(../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]) > 1">
                                    <DISTRIB>
                                        <xsl:call-template name="fixedValues">
                                            <xsl:with-param name="p2pInput"
                                                select="../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]/Type/UniqueName"
                                            />
                                        </xsl:call-template>
                                    </DISTRIB>
                                    <PART_INV>
                                        
                                            <xsl:value-of select="'2'"/>
                                        
                                    </PART_INV>
                                </xsl:if>
                                <GR_IND>
                                    <!--                      For Simple Service - GR_IND should not be mapped-->
                                    <xsl:if
                                        test="(ParentLineNumber = 0 and (not(ServiceDetails/NonSESBasedInvoice) or ServiceDetails/NonSESBasedInvoice != 'true'))"
                                        >
                                        <xsl:value-of select="'X'"/>
                                    </xsl:if>
                                </GR_IND>
                                <xsl:if test="not(Supplier/UniqueName = '[Unspecified]')">
                                    <DES_VENDOR>
                                        <xsl:value-of select="Supplier/UniqueName"/>
                                    </DES_VENDOR>
                                </xsl:if>
                                <PURCH_ORG>
                                    <xsl:value-of select="PurchaseOrg/UniqueName"/>
                                </PURCH_ORG>
                                <xsl:if test="ServiceDetails/RequiresServiceEntry = 'true' 
                                    and string-length(normalize-space(MasterAgreement/Name)) > 0 
                                    and string-length(normalize-space(MasterAgreement/Name)) = 10 
                                    and string(number(MasterAgreement/Name)) != 'NaN' ">                                  <!-- <IG-8224:-Contract Reference>   -->                                 
                                    <AGREEMENT>
                                        <xsl:value-of select="MasterAgreement/Name"/>
                                    </AGREEMENT>
                                    <AGMT_ITEM>                                    
                                        <xsl:value-of select="OutlineRootNumber"/>
                                    </AGMT_ITEM>
                                </xsl:if>   
                                <CURRENCY>
                                    <xsl:value-of select="Amount/Currency/UniqueName"/>
                                </CURRENCY>
                                <ARIBA_ITEM>
                                    <xsl:value-of select="NumberInCollection"/>
                                </ARIBA_ITEM>
                                <xsl:if test="LineType/Category">
                                    <ARIBA_LINETYPE>
                                        <xsl:value-of select="LineType/Category"/>
                                    </ARIBA_LINETYPE>
                                </xsl:if>
                                <ARIBA_PARENTLN>
                                    <xsl:value-of select="ParentLineNumber"/>
                                </ARIBA_PARENTLN>
                                <TAX_DEDUCTIBLE>
                                    <xsl:value-of select="TaxDetail/IsDeductible"/>
                                </TAX_DEDUCTIBLE>
                                <xsl:if test="ServiceDetails">
                                    <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <MAXAMOUNT>
                                            <xsl:value-of
                                                select="format-number(ServiceDetails/MaxAmount/Amount, '0.00')"
                                            />
                                        </MAXAMOUNT>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Amount)) > 0">                 <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <EXPECTEDAMOUNT>
                                            <xsl:value-of
                                                select="format-number(ServiceDetails/ExpectedAmount/Amount, '0.00')"
                                            />
                                        </EXPECTEDAMOUNT>
                                    </xsl:if>
                                    <MAXAMOUNT_CURRENCY>
                                        <xsl:value-of
                                            select="ServiceDetails/MaxAmount/Currency/UniqueName"/>
                                    </MAXAMOUNT_CURRENCY>
                                    <!--when Item Category 'B'-->
                                    <REQUIRESSERVICEENTRY>
                                        <xsl:if
                                            test="((ServiceDetails/RequiresServiceEntry = 'true') or (ServiceDetails/RequiresServiceEntry = 'false' and ItemCategory/UniqueName = 'B'))"
                                            >
                                            <xsl:value-of select="'X'"/>
                                        </xsl:if>
                                    </REQUIRESSERVICEENTRY>
                                    <EXPECTD_CURRENCY>
                                        <xsl:value-of
                                            select="ServiceDetails/ExpectedAmount/Currency/UniqueName"
                                        />
                                    </EXPECTD_CURRENCY>
                                </xsl:if>
                                <MATERIAL_LNG>
                                    <xsl:value-of select="Description/ItemNumber"/>
                                </MATERIAL_LNG>
                                <xsl:if test="string-length(normalize-space(OriginatingSystemLineNumber)) > 0">                                             <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <OSLN>
                                        <xsl:value-of select="OriginatingSystemLineNumber"/>
                                    </OSLN>
                                </xsl:if>
                            </item>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                <!--Charges-->
                <xsl:for-each
                    select="Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (LineType/Category = '4' or LineType/Category = '8' or LineType/Category = '16')]">
                    <xsl:if
                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (LineType/Category = '2')]/ParentLineNumber = NumberInCollection">
                        <item>
                            <xsl:variable name="v_nic" select="NumberInCollection"/>
                            <PREQ_ITEM>
                                <xsl:if
                                    test="string-length(normalize-space(Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) lt 1">        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <xsl:value-of select="ERPLineItemNumber"/>
                                </xsl:if>
                            </PREQ_ITEM>
                            <PUR_GROUP>
                                <xsl:value-of select="PurchaseGroup/UniqueName"/>
                            </PUR_GROUP>
                            <PREQ_NAME>
                                <xsl:choose>
                                    <xsl:when
                                        test="string-length(normalize-space(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName)) gt 12">    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <xsl:value-of
                                            select="substring(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName, 0, 13)"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </PREQ_NAME>
                            <SHORT_TEXT>
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(Description/Description)) > 40">                          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <!--Begin of IG-21063: Short_text 40 chars -->
                                        <xsl:value-of
                                            select="substring(normalize-space(Description/Description), 1, 40)"/>
                                        <!-- End of IG-21063 -->
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(Description/Description)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </SHORT_TEXT>
                            <MATERIAL>
                                <xsl:value-of select="Description/ItemNumber"/>
                            </MATERIAL>
                            <PLANT>
                                <xsl:variable name="v_plant">
                                    <xsl:choose>
                                        <xsl:when
                                            test="
                                                HasAdhocShipToAddress = 'true' and
                                                string-length(normalize-space($v_adhocShipTo)) > 0"> <!--IG-20990 --> <!-- IG-36260: XSLT improvements as per guidelines -->
                                            <xsl:value-of
                                                select="$v_adhocShipTo"/> <!--IG-20990 -->
                                        </xsl:when>
                                        <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">                                           <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                            <xsl:value-of select="SAPPlant/UniqueName"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="ShipTo/UniqueName"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:value-of select="substring($v_plant, 1, 4)"/>
                            </PLANT>
                            <MATL_GROUP>
                                <xsl:value-of select="CommodityCode/UniqueName"/>
                            </MATL_GROUP>
                            <xsl:if test="Quantity">
                                <QUANTITY>
                                    <xsl:value-of select="format-number(Quantity, '0.000')"/>
                                </QUANTITY>
                            </xsl:if>
                            <UNIT>
                                <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                            </UNIT>
                            <PREQ_DATE>
                                <xsl:call-template name="erpDate"/>
                            </PREQ_DATE>
                            <xsl:choose>
                                <xsl:when test="NeedBy">
                                    <DELIV_DATE>
                                        <xsl:call-template name="erpDate">
                                            <xsl:with-param name="p2pDate" select="NeedBy"/>
                                        </xsl:call-template>
                                    </DELIV_DATE>
                                </xsl:when>
                                <xsl:otherwise>
                                    <DELIV_DATE>
                                        <xsl:call-template name="erpDate"/>
                                    </DELIV_DATE>
                                </xsl:otherwise>
                            </xsl:choose>
                            <PREQ_PRICE>
                                <xsl:variable name="v_num">
                                    <xsl:value-of select="NumberInCollection"/>
                                </xsl:variable>
                                <xsl:variable name="v_child_price">
                                    <xsl:choose>
                                        <xsl:when
                                            test="$v_checkTaxAllowed = 'TRUE' and //Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and LineType/Category = '2' and ParentLineNumber = $v_num]/TaxDetail/IsDeductible = 'false'">
                                            <xsl:value-of
                                                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and LineType/Category = '2' and ParentLineNumber = $v_num and TaxDetail/IsDeductible = 'false']/Description/Price/Amount"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="format-number(0, '0.00')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:value-of
                                    select="format-number((Description/Price/Amount + $v_child_price), '0.00')"
                                />
                            </PREQ_PRICE>
                            <ACCTASSCAT>
                                <xsl:value-of select="AccountCategory/UniqueName"/>
                            </ACCTASSCAT>
                            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                            <xsl:if
                                test="count(../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]) > 1">
                                <DISTRIB>
                                    <xsl:call-template name="fixedValues">
                                        <xsl:with-param name="p2pInput"
                                            select="../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]/Type/UniqueName"
                                        />
                                    </xsl:call-template>
                                </DISTRIB>
                            </xsl:if>    
                            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                            <xsl:if test="not(Supplier/UniqueName = '[Unspecified]')">
                                <DES_VENDOR>
                                    <xsl:value-of select="Supplier/UniqueName"/>
                                </DES_VENDOR>
                            </xsl:if>
                            <PURCH_ORG>
                                <xsl:value-of select="PurchaseOrg/UniqueName"/>
                            </PURCH_ORG>
                            <CURRENCY>
                                <xsl:value-of select="Amount/Currency/UniqueName"/>
                            </CURRENCY>
                            <ARIBA_ITEM>
                                <xsl:value-of select="NumberInCollection"/>
                            </ARIBA_ITEM>
                            <xsl:if test="LineType/Category">
                                <ARIBA_LINETYPE>
                                    <xsl:value-of select="LineType/Category"/>
                                </ARIBA_LINETYPE>
                            </xsl:if>
                            <ARIBA_PARENTLN>
                                <xsl:value-of select="ParentLineNumber"/>
                            </ARIBA_PARENTLN>
                            <TAX_DEDUCTIBLE>
                                <xsl:value-of select="TaxDetail/IsDeductible"/>
                            </TAX_DEDUCTIBLE>
                            <xsl:if test="ServiceDetails">
                                <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">                   <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->        
                                    <MAXAMOUNT>
                                        <xsl:value-of
                                            select="format-number(ServiceDetails/MaxAmount/Amount, '0.00')"
                                        />
                                    </MAXAMOUNT>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Amount)) > 0">              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <EXPECTEDAMOUNT>
                                        <xsl:value-of
                                            select="format-number(ServiceDetails/ExpectedAmount/Amount, '0.00')"
                                        />
                                    </EXPECTEDAMOUNT>
                                </xsl:if>
                                <MAXAMOUNT_CURRENCY>
                                    <xsl:value-of
                                        select="ServiceDetails/MaxAmount/Currency/UniqueName"/>
                                </MAXAMOUNT_CURRENCY>
                                <REQUIRESSERVICEENTRY>
                                    <xsl:if test="ServiceDetails/RequiresServiceEntry = 'true'"
                                        >
                                        <xsl:value-of select="'X'"/>
                                    </xsl:if>
                                </REQUIRESSERVICEENTRY>
                                <EXPECTD_CURRENCY>
                                    <xsl:value-of
                                        select="ServiceDetails/ExpectedAmount/Currency/UniqueName"/>
                                </EXPECTD_CURRENCY>
                            </xsl:if>
                            <MATERIAL_LNG>
                                <xsl:value-of select="Description/ItemNumber"/>
                            </MATERIAL_LNG>
                            <xsl:if test="string-length(normalize-space(OriginatingSystemLineNumber)) > 0">                                                     <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <OSLN>
                                    <xsl:value-of select="OriginatingSystemLineNumber"/>
                                </OSLN>
                            </xsl:if>
                        </item>
                    </xsl:if>
                </xsl:for-each>

                <!-- Held lines -->
                <xsl:for-each
                    select="Requisition_BudgetReqExportReqHeldLineDetails_Item/item/HeldLineItems/item">
                    <item>
                        <xsl:variable name="v_nic" select="NumberInCollection"/>
                        <PREQ_ITEM>
                            <xsl:if
                                test="string-length(normalize-space(Requisition_BudgetReqExportHeaderDetails_Item/item/ERPRequisitionID)) lt 1">                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <xsl:value-of select="ERPLineItemNumber"/>
                            </xsl:if>
                        </PREQ_ITEM>
                        <PUR_GROUP>
                            <xsl:value-of select="PurchaseGroup/UniqueName"/>
                        </PUR_GROUP>
                        <PREQ_NAME>
                            <xsl:choose>
                                <xsl:when
                                    test="string-length(normalize-space(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName)) gt 12">           <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <xsl:value-of
                                        select="substring(../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName, 0, 13)"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="../../../../Requisition_BudgetReqExportHeaderDetails_Item/item/Requester/UniqueName"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </PREQ_NAME>
                        <SHORT_TEXT>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(Description/Description)) > 40">                              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                    <!--Begin of IG-21063: Short_text 40 chars -->
                                    <xsl:value-of select="substring(normalize-space(Description/Description), 1, 40)"
                                    />
                                    <!-- End of IG-21063 -->
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(Description/Description)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </SHORT_TEXT>
                        <MATERIAL>
                            <xsl:value-of select="Description/ItemNumber"/>
                        </MATERIAL>
                        <PLANT>
                            <xsl:variable name="v_plant">
                                <xsl:choose>
                                    <xsl:when
                                        test="
                                            HasAdhocShipToAddress = 'true' and
                                            string-length(normalize-space($v_adhocShipTo)) > 0"> <!--IG-20990 --> <!-- IG-36260: XSLT improvements as per guidelines -->
                                        <xsl:value-of
                                            select="$v_adhocShipTo"/> <!--IG-20990 -->
                                    </xsl:when>
                                    <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">                         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                        <xsl:value-of select="SAPPlant/UniqueName"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="ShipTo/UniqueName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="substring($v_plant, 1, 4)"/>
                        </PLANT>
                        <MATL_GROUP>
                            <xsl:value-of select="CommodityCode/UniqueName"/>
                        </MATL_GROUP>
                        <xsl:if test="Quantity">
                            <QUANTITY>
                                <xsl:value-of select="format-number(Quantity, '0.000')"/>
                            </QUANTITY>
                        </xsl:if>
                        <UNIT>
                            <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                        </UNIT>
                        <PREQ_DATE>
                            <xsl:call-template name="erpDate"/>
                        </PREQ_DATE>
                        <xsl:choose>
                            <xsl:when test="NeedBy">
                                <DELIV_DATE>
                                    <xsl:call-template name="erpDate">
                                        <xsl:with-param name="p2pDate" select="NeedBy"/>
                                    </xsl:call-template>
                                </DELIV_DATE>
                            </xsl:when>
                            <xsl:otherwise>
                                <DELIV_DATE>
                                    <xsl:call-template name="erpDate"/>
                                </DELIV_DATE>
                            </xsl:otherwise>
                        </xsl:choose>
                        <PREQ_PRICE>
                            <xsl:variable name="v_nic" select="NumberInCollection"/>
                            <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                            <xsl:variable name="v_quantity">
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(Quantity)) > 0">
                                        <xsl:value-of select="Quantity"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'1'"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="v_amount">
                                <xsl:choose>
                                    <xsl:when
                                        test="(ParentLineNumber = 0) and string-length(normalize-space(Description/ConversionFactor)) > 0">               <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->                  
                                        <!--Begin of IG-16774: If the user has entered the Unit Conversion in P2P UI then multiply price * conv. factor. 
                                                    Otherwise, map the price as it is. Before this fix we were sending wrongly the total calculated price to ERP based on the formula  ( Amount * Conversion factor /PBQ ) * Quantity -->
                                        <xsl:value-of
                                            select="Description/Price/Amount * Description/ConversionFactor"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-number(Description/Price/Amount,'0.00')"/> <!-- IG-36260: XSLT improvements as per guidelines -->
                                    </xsl:otherwise>
                                    <!-- End of IG-16774 -->
                                </xsl:choose>
                            </xsl:variable>
                            <!--Charge without TAX-->
                            <xsl:variable name="v_charge_amt">
                                <xsl:variable name="v_charge4">
                                    <xsl:call-template name="findChargeAmt">
                                        <xsl:with-param name="p_nic" select="$v_nic"/>
                                        <xsl:with-param name="p_chargeType" select="'4'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="v_charge8">
                                    <xsl:call-template name="findChargeAmt">
                                        <xsl:with-param name="p_nic" select="$v_nic"/>
                                        <xsl:with-param name="p_chargeType" select="'8'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="v_charge16">
                                    <xsl:call-template name="findChargeAmt">
                                        <xsl:with-param name="p_nic" select="$v_nic"/>
                                        <xsl:with-param name="p_chargeType" select="'16'"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <!--                                <xsl:value-of select="$v_charge4 + $v_charge8 + $v_charge16"/>-->
                                <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                <xsl:value-of
                                    select="sum(($v_charge4 | $v_charge8 | $v_charge16)[number(.) = .]) div $v_quantity"
                                />                                
                            </xsl:variable>
                            <!--TAX-->
                            <xsl:variable name="v_tax_amt">
                                <xsl:choose>
                                    <xsl:when
                                        test="$v_checkTaxAllowed = 'TRUE' and //Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]">
                                        <xsl:variable name="v_taxLine">
                                            <xsl:value-of
                                                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]/NumberInCollection"
                                            />
                                        </xsl:variable>
                                        <xsl:variable name="v_taxAmount">
                                            <xsl:value-of
                                                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '2'] and TaxDetail[IsDeductible = 'false']]/NumberInCollection"
                                            />
                                        </xsl:variable>
                                        <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                        <xsl:value-of
                                            select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_taxLine)]/Description/Price/Amount div $v_quantity"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-number(0, '0.00')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!--Discount-->
                            <xsl:variable name="v_discount">
                                <xsl:variable name="v_discLine">
                                    <xsl:if
                                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]">
                                        <xsl:value-of
                                            select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_nic) and LineType[Category = '32']]/NumberInCollection"
                                        />
                                    </xsl:if>
                                </xsl:variable>
                                <!--IG-25094 : Calculate the Charge, Tax and Discount per Quanity-->
                                <xsl:value-of
                                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_discLine)]/Description/Price/Amount div $v_quantity"
                                />
                            </xsl:variable>
                            <xsl:variable name="v_sum">
                                <xsl:call-template name="findSum">
                                    <xsl:with-param name="p_param1" select="$v_amount"/>
                                    <xsl:with-param name="p_param2" select="$v_charge_amt"/>
                                    <xsl:with-param name="p_param3" select="$v_tax_amt"/>
                                    <xsl:with-param name="p_param4" select="$v_discount"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <!-- Begin of IG-16774: Refined logic to send Amount value instead of Total valuation price-->
                            <xsl:value-of select="$v_sum"/>
                            <!-- End of IG-16774 -->
                        </PREQ_PRICE>
                        <!--  Price Basis Quantity   -->
                        <PRICE_UNIT>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->                      
                                    <xsl:value-of
                                        select="format-number(Description/PriceBasisQuantity, '0')"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'1'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </PRICE_UNIT>
                        <!--Map D when RequiresServiceEntry is true, Map B when RequiresServiceEntry is false and ItemCategory/UniqueName is B else blank -->
                        <xsl:choose>
                            <xsl:when test="ServiceDetails/RequiresServiceEntry = 'true'">
                                <ITEM_CAT>
                                    <xsl:value-of select="'D'"/>
                                </ITEM_CAT>
                            </xsl:when>
                            <xsl:when
                                test="(ServiceDetails/RequiresServiceEntry = 'false' and ItemCategory/UniqueName = 'B')">
                                <ITEM_CAT>
                                    <xsl:value-of select="'B'"/>
                                </ITEM_CAT>
                            </xsl:when>
                            <xsl:otherwise>
                                <ITEM_CAT/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <ACCTASSCAT>
                            <xsl:value-of select="AccountCategory/UniqueName"/>
                        </ACCTASSCAT>
                        <xsl:if
                            test="count(../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]) > 1">
                            <DISTRIB>
                                <xsl:call-template name="fixedValues">
                                    <xsl:with-param name="p2pInput"
                                        select="../../../../Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_nic]/Type/UniqueName"
                                    />
                                </xsl:call-template>
                            </DISTRIB>
                            <PART_INV>
                                
                                    <xsl:value-of select="'2'"/>
                                
                            </PART_INV>
                        </xsl:if>
                        <GR_IND>
                            <!--                      For Simple Service - GR_IND should not be mapped-->
                            <xsl:if
                                test="(ParentLineNumber = 0 and (not(ServiceDetails/NonSESBasedInvoice) or ServiceDetails/NonSESBasedInvoice != 'true'))"
                                >
                                <xsl:value-of select="'X'"/>
                            </xsl:if>
                        </GR_IND>
                        <xsl:if test="not(Supplier/UniqueName = '[Unspecified]')">
                            <DES_VENDOR>
                                <xsl:value-of select="Supplier/UniqueName"/>
                            </DES_VENDOR>
                        </xsl:if>
                        <PURCH_ORG>
                            <xsl:value-of select="PurchaseOrg/UniqueName"/>
                        </PURCH_ORG>
                        <xsl:if test="ServiceDetails/RequiresServiceEntry = 'true' 
                                   and string-length(normalize-space(MasterAgreement/Name)) > 0 
                                   and string-length(normalize-space(MasterAgreement/Name)) = 10 
                                   and string(number(MasterAgreement/Name)) != 'NaN' ">                                  <!-- <IG-8224:-Contract Reference>   -->                                 
                                   <AGREEMENT>
                                       <xsl:value-of select="MasterAgreement/Name"/>
                                   </AGREEMENT>
                                   <AGMT_ITEM>                                    
                                       <xsl:value-of select="OutlineRootNumber"/>
                                   </AGMT_ITEM>
                               </xsl:if>    
                        <CURRENCY>
                            <xsl:value-of select="Amount/Currency/UniqueName"/>
                        </CURRENCY>
                        <ARIBA_ITEM>
                            <xsl:value-of select="NumberInCollection"/>
                        </ARIBA_ITEM>
                        <xsl:if test="LineType/Category">
                            <ARIBA_LINETYPE>
                                <xsl:value-of select="LineType/Category"/>
                            </ARIBA_LINETYPE>
                        </xsl:if>
                        <ARIBA_PARENTLN>
                            <xsl:value-of select="ParentLineNumber"/>
                        </ARIBA_PARENTLN>
                        <TAX_DEDUCTIBLE>
                            <xsl:value-of select="TaxDetail/IsDeductible"/>
                        </TAX_DEDUCTIBLE>
                        <xsl:if test="ServiceDetails">
                            <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">                         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <MAXAMOUNT>
                                    <xsl:value-of
                                        select="format-number(ServiceDetails/MaxAmount/Amount, '0.00')"
                                    />
                                </MAXAMOUNT>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Amount)) > 0">                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                                <EXPECTEDAMOUNT>
                                    <xsl:value-of
                                        select="format-number(ServiceDetails/ExpectedAmount/Amount, '0.00')"
                                    />
                                </EXPECTEDAMOUNT>
                            </xsl:if>
                            <MAXAMOUNT_CURRENCY>
                                <xsl:value-of select="ServiceDetails/MaxAmount/Currency/UniqueName"
                                />
                            </MAXAMOUNT_CURRENCY>
                            <!--when Item Category 'B'-->
                            <REQUIRESSERVICEENTRY>
                                <xsl:if
                                    test="((ServiceDetails/RequiresServiceEntry = 'true') or (ServiceDetails/RequiresServiceEntry = 'false' and ItemCategory/UniqueName = 'B'))"
                                    >
                                    <xsl:value-of select="'X'"/>
                                </xsl:if>
                            </REQUIRESSERVICEENTRY>
                            <EXPECTD_CURRENCY>
                                <xsl:value-of
                                    select="ServiceDetails/ExpectedAmount/Currency/UniqueName"/>
                            </EXPECTD_CURRENCY>
                        </xsl:if>
                        <MATERIAL_LNG>
                            <xsl:value-of select="Description/ItemNumber"/>
                        </MATERIAL_LNG>
                        <HELD_LINE_IND>
                            <xsl:value-of select="'X'"/>
                        </HELD_LINE_IND>
                        <xsl:if test="string-length(normalize-space(OriginatingSystemLineNumber)) > 0">                                              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                            <OSLN>
                                <xsl:value-of select="OriginatingSystemLineNumber"/>
                            </OSLN>
                        </xsl:if>
                    </item>
                </xsl:for-each>
            </PRITEM>
        </n0:ARBCIG_PURREQ>
    </xsl:template>
    <xsl:template name="erpDate">
        <xsl:param name="p2pDate"/>
        <xsl:choose>
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:when test="string-length(normalize-space($p2pDate)) > 0">                                                              
                <xsl:choose>
                    <xsl:when test="contains($p2pDate,'-')">
                        <xsl:value-of select="substring($p2pDate, 1, 10)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="concat(substring($p2pDate, 1, 4), '-', substring($p2pDate, 5, 2), '-', substring($p2pDate, 7, 2))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="fixedValues">
        <xsl:param name="p2pInput"/>
        <xsl:choose>
            <xsl:when test="$p2pInput = '_Quantity'">
                <xsl:value-of select="'1'"/>
            </xsl:when>
            <xsl:when test="$p2pInput = '_Percentage'">
                <xsl:value-of select="'2'"/>
            </xsl:when>
            <xsl:when test="$p2pInput = '_Amount'">
                <xsl:value-of select="'3'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="findChargeAmt">
        <xsl:param name="p_nic"/>
        <xsl:param name="p_chargeType"/>
        <xsl:variable name="v_amt">
            <xsl:variable name="v_chargeCheck">
                <xsl:if
                    test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $p_nic) and LineType[Category = $p_chargeType]]">
                    <xsl:value-of
                        select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $p_nic) and LineType[Category = $p_chargeType]]/NumberInCollection"
                    />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="v_chargeLine">
                <xsl:choose>
                    <xsl:when
                        test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $v_chargeCheck)]"/>
                    <xsl:otherwise>
                        <xsl:value-of select="$v_chargeCheck"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of
                select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (NumberInCollection = $v_chargeLine)]/Description/Price/Amount"
            />
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($v_amt)) > 0"> <!-- IG-36260: XSLT improvements as per guidelines -->
                <xsl:value-of select="format-number($v_amt, '0.000')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'0'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="findAccChargeAmt">
        <xsl:param name="p_nic"/>
        <xsl:param name="p_lineNic"/>
        <xsl:param name="p_chargeType"/>
        <xsl:variable name="v_childNic">
            <xsl:if
                test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $p_lineNic) and LineType[Category = $p_chargeType]]">
                <xsl:variable name="v_charge"
                    select="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and (ParentLineNumber = $p_lineNic) and LineType[Category = $p_chargeType]]/NumberInCollection"/>
                <!--Check if tax does not exists-->
                <xsl:for-each select="$v_charge">
                    <xsl:variable name="v_c" select="."/>
                    <xsl:choose>
                        <xsl:when
                            test="//Requisition_BudgetReqExportReqLineDetails_Item/item/LineItems/item[(HoldForAggregation = '' or HoldForAggregation = 'false') and ParentLineNumber = $v_c and LineType/Category = '2']"> </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="v_amt">
            <!-- IG-37134 : Amount formatting based on currency -->
            <xsl:variable name="v_Curr">  <!-- This is to store the currency value -->
                <xsl:value-of select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_childNic and NumberInCollection = $p_nic]/AdjustedCostInCurrencyPrecision/Currency/UniqueName"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$v_Curr = 'JPY'">
                    <xsl:call-template name="formatAmount">
                        <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_childNic and NumberInCollection = $p_nic]/AdjustedCostInCurrencyPrecision/Amount"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$v_Curr = 'KRW'">
                    <xsl:call-template name="formatAmount">
                        <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_childNic and NumberInCollection = $p_nic]/AdjustedCostInCurrencyPrecision/Amount"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$v_Curr = 'VND'">
                    <xsl:call-template name="formatAmount">
                        <xsl:with-param name="p_amount" select="//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_childNic and NumberInCollection = $p_nic]/AdjustedCostInCurrencyPrecision/Amount"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="format-number(//Requisition_BudgetReqExportReqAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item[LineItem/NumberInCollection = $v_childNic and NumberInCollection = $p_nic]/AdjustedCostInCurrencyPrecision/Amount, '0.00')"
                    />                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$v_amt > 0">
                <xsl:value-of select="format-number($v_amt, '0.000')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'0'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="findSum">
        <xsl:param name="p_param1"/>
        <xsl:param name="p_param2"/>
        <xsl:param name="p_param3"/>
        <xsl:param name="p_param4"/>
        <xsl:variable name="v_param1">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(string($p_param1))) = 0"> <!-- IG-36260: XSLT improvements as per guidelines -->
                    <xsl:value-of select="format-number(0, '0.00')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="format-number($p_param1, '0.00')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="v_param2">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(string($p_param2))) = 0"> <!-- IG-36260: XSLT improvements as per guidelines -->
                    <xsl:value-of select="format-number(0, '0.00')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="format-number($p_param2, '0.00')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="v_param3">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(string($p_param3))) = 0"> <!-- IG-36260: XSLT improvements as per guidelines -->
                    <xsl:value-of select="format-number(0, '0.00')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="format-number($p_param3, '0.00')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="v_param4">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(string($p_param4))) = 0"> <!-- IG-36260: XSLT improvements as per guidelines -->
                    <xsl:value-of select="format-number(0, '0.00')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="format-number($p_param4, '0.00')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of
            select="format-number(($v_param1 + $v_param2 + $v_param3 + $v_param4), '0.00')"/>
    </xsl:template>
</xsl:stylesheet>
