<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="urn:Ariba:Buyer:vsap" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">               <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                       <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
  <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
<!--    <xsl:include href="../../../../BUYER_CONTENT/common/FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anSenderID1"/>
  <xsl:param name="anSourceDocumentType"/>
  <xsl:param name="anAddOnCIVersion"/>
  <xsl:param name="attachSeparator" select="'\|'"/>
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
      <xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
    </xsl:call-template>
  </xsl:variable>
  <!--    Check CIG Addon Version is 06 or more than that-->
  <xsl:variable name="v_supportsp06onwards">
    <xsl:call-template name="Check_SupportVersion">
      <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
      <xsl:with-param name="p_suppversion" select="'06'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="v_supportsp10onwards">
    <xsl:call-template name="Check_SupportVersion">
      <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
      <xsl:with-param name="p_suppversion" select="'10'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- IG-20811 Limit split not working - standard BAPI issue-->
  <xsl:variable name="v_supportsp11onwards">
    <xsl:call-template name="Check_SupportVersion">
      <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
      <xsl:with-param name="p_suppversion" select="'11'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- CI-1014 GRBasedInvoice-->
  <xsl:variable name="v_supportsp15onwards">
    <xsl:call-template name="Check_SupportVersion">
      <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
      <xsl:with-param name="p_suppversion" select="'15'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- IG-20811 Limit split not working - standard BAPI issue-->
  <!--Assign Frame work order default Item category-->
  <xsl:variable name="v_frameWorkOrd" select="'B'"/>
  <xsl:template match="/">
    <xsl:variable name="v_purLineDetail"
      select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item"/>
    <xsl:variable name="v_purLineDelItem"
      select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdDelItems_Item/item/DeletedERPLineItems/item"/>
    <n0:ARBCIG_BAPI_PO_CHANGE>
      <xsl:variable name="v_delete" select='"X"'/>
      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
      <xsl:variable name="v_attachment"
        select="/PurchaseOrderChangeExportRequest/ERPOrder_PurchOrdAttachmentDetails_Item/item/ExportedAttachments/item"/>
      <xsl:if test="$v_attachment">
        <ATTACHMENT>
          <xsl:for-each select="$v_attachment">
            <item>
              <FILE_NAME>
                <xsl:value-of select="Attachment/Filename"/>
              </FILE_NAME>
              <xsl:if
                test="string-length(normalize-space(Attachment/ReferencedBy/item/LineItem/NumberInCollection)) > 0">
                <LINE_NUMBER>
                  <xsl:value-of select="Attachment/ReferencedBy/item/LineItem/NumberInCollection"/>
                </LINE_NUMBER>
              </xsl:if>
              <CONTENT_ID>
                <xsl:value-of select="MaskedFileName"/>
              </CONTENT_ID>
              <CONTENT_TYPE>
                <xsl:value-of select="Attachment/Attachment/ContentType"/>
              </CONTENT_TYPE>
            </item>
          </xsl:for-each>
        </ATTACHMENT>
      </xsl:if>
      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
      <PARTITION>
        <xsl:value-of select="/PurchaseOrderChangeExportRequest/@partition"/>
      </PARTITION>
      <PO_HEADER>
        <PO_NUMBER>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/ERPPONumber"
          />
        </PO_NUMBER>
        <VENDOR>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/Supplier/UniqueName"
          />
        </VENDOR>
        <PMNTTRMS>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/PaymentTerms/UniqueName"
          />
        </PMNTTRMS>
        <PURCH_ORG>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/PurchaseOrg/UniqueName"
          />
        </PURCH_ORG>
        <PUR_GROUP>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/PurchaseGroup/UniqueName"
          />
        </PUR_GROUP>
        <CURRENCY>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/Currency/UniqueName"
          />
        </CURRENCY>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <VPER_START>
          <xsl:variable name="v_validityStartDate" select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/ValidityStartDate"/>
          <xsl:if test="string-length(normalize-space($v_validityStartDate)) > 0">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($v_validityStartDate)) > 8">
                <xsl:value-of select="substring($v_validityStartDate, 1, 10)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(substring($v_validityStartDate, 1, 4), '-', substring($v_validityStartDate, 5, 2), '-', substring($v_validityStartDate, 7, 2))"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!--<xsl:value-of
            select="substring(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/ValidityStartDate, 1, 10)"
          />-->
        </VPER_START>
        <VPER_END>
          <xsl:variable name="v_validityEndDate" select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/ValidityEndDate"/>
          <xsl:if test="string-length(normalize-space($v_validityEndDate)) > 0">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($v_validityEndDate)) > 8">
                <xsl:value-of select="substring($v_validityEndDate, 1, 10)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(substring($v_validityEndDate, 1, 4), '-', substring($v_validityEndDate, 5, 2), '-', substring($v_validityEndDate, 7, 2))"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!--<xsl:value-of
            select="substring(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/ValidityEndDate, 1, 10)"
          />-->
        </VPER_END>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <OUR_REF>
          <xsl:choose>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:when
              test="string-length(normalize-space(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/UniqueName)) > 12">
              <xsl:value-of
                select="substring(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/UniqueName, 1, 12)"
              />
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/UniqueName"
              />
            </xsl:otherwise>
          </xsl:choose>
        </OUR_REF>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <ARIBAORDERID>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/UniqueName"
          />
        </ARIBAORDERID>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <VERSION>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/VersionNumber"
          />
        </VERSION>
        <ORDERTYPE>
          <xsl:value-of
            select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/OrderMethodCategory"
          />
        </ORDERTYPE>
      </PO_HEADER>
      <!--IG-15421-->
      <!--Re-ordering the sequence-->
      <VARIANT>
        <xsl:value-of select="/PurchaseOrderChangeExportRequest/@variant"/>
      </VARIANT>
      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
      <POCOND>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <xsl:for-each
          select="$v_purLineDetail[string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0]">
          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
          <xsl:variable name="v_NumOnPOString">
            <xsl:value-of select="NumberOnPOString"/>
          </xsl:variable>
          <xsl:variable name="v_sapLineItem">
            <xsl:value-of select="SAPPOLineNumber"/>
          </xsl:variable>
          <xsl:for-each
            select="$v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_NumOnPOString]">
            <xsl:variable name="v_chargeLine" select="NumberOnPOString"/>
            <xsl:if
              test="(((LineType/Category = 4.0) or (LineType/Category = 8.0) or (LineType/Category = 16.0) or (LineType/Category = 32.0)))">
              
              <xsl:variable name="v_NumPoString" select="NumberOnPOString"/>
              <xsl:if
                test="format-number($v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_chargeLine]/LineType/Category, '0.0') != '2.0'">
                <xsl:variable name="v_pline" select="ParentLineNumber"/>
                <item>
                  <ITM_NUMBER>
                    <xsl:value-of select="$v_sapLineItem"/>
                  </ITM_NUMBER>
                  <COND_TYPE>
                    <xsl:call-template name="ReadLookUpTable_In">
                      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
                      <xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
                      <xsl:with-param name="p_docType" select="$anSourceDocumentType"/>
                      <xsl:with-param name="p_input" select="LineType/UniqueName"/>
                      <xsl:with-param name="p_lookupName" select="'ProcurementConditionType'"/>
                      <xsl:with-param name="p_productType" select="'AribaProcurement'"/>
                    </xsl:call-template>
                  </COND_TYPE>
                  <COND_VALUE>
                    <xsl:value-of select="format-number(Description/Price/Amount, '00.000000000')"/>
                  </COND_VALUE>
                  <xsl:choose>
                    <xsl:when test="ChangedState = 4.0">
                      <CHANGE_ID>
                        <xsl:value-of select='"I"'/>
                      </CHANGE_ID>
                    </xsl:when>
                    <xsl:otherwise>
                      <CHANGE_ID>
                        <xsl:value-of select='"U"'/>
                      </CHANGE_ID>
                    </xsl:otherwise>
                  </xsl:choose>
                  <ARIBA_ITEM_NO>
                    <xsl:value-of
                      select="number(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[number(NumberOnPOString) = $v_pline]/NumberOnPOString)"
                    />
                  </ARIBA_ITEM_NO>
                </item>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <xsl:for-each
          select="$v_purLineDetail[string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0]">
          <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
          <xsl:variable name="v_NumOnPOString">
            <xsl:value-of select="number(NumberOnPOString)"/>
          </xsl:variable>
          <xsl:variable name="v_NumOnPOString1">
            <xsl:value-of select="NumberOnPOString"/>
          </xsl:variable>
          <xsl:variable name="v_sapItemNum">
            <xsl:value-of select="SAPPOLineNumber"/>
          </xsl:variable>
          <xsl:for-each select="$v_purLineDelItem[ParentLineNumber = $v_NumOnPOString]">
            <xsl:variable name="v_chargeLine" select="NumberOnPOString"/>
            <xsl:if
              test="(((LineType/Category = 4.0) or (LineType/Category = 8.0) or (LineType/Category = 16.0) or (LineType/Category = 32.0)))">
              <xsl:if
                test="format-number($v_purLineDelItem[format-number(ParentLineNumber, '00000') = $v_chargeLine]/LineType/Category, '0.0') != '2.0'">
                <item>
                  <ITM_NUMBER>
                    <xsl:value-of select="$v_sapItemNum"/>
                  </ITM_NUMBER>
                  <COND_TYPE>
                    <xsl:call-template name="ReadLookUpTable_In">
                      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
                      <xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
                      <xsl:with-param name="p_docType" select="$anSourceDocumentType"/>
                      <xsl:with-param name="p_input" select="LineType/UniqueName"/>
                      <xsl:with-param name="p_lookupName" select="'ProcurementConditionType'"/>
                      <xsl:with-param name="p_productType" select="'AribaProcurement'"/>
                    </xsl:call-template>
                  </COND_TYPE>
                  <CHANGE_ID>D</CHANGE_ID>
                  <ARIBA_ITEM_NO>
                    <xsl:value-of select="$v_NumOnPOString1"/>
                  </ARIBA_ITEM_NO>
                </item>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </POCOND>
      <POCONTRACTLIMITS>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">                     
          <xsl:if 
            test="(not(LineType) or LineType/Category = 1) and (string-length(normalize-space(ServiceDetails)) > 0 and (string-length(normalize-space(MasterAgreement/Name)) = 10) and string(number(MasterAgreement/Name)) != 'NaN') and string-length(normalize-space(ServiceDetails/ContractLimit/Amount)) > 0"> <!-- IG-26075/IG-8224 --> <!-- CI-2450 -->                      
            <xsl:if test="ChangedState = 1 or ChangedState = 2"> 
              <!--Line Updation -->
              <item>
                <PCKG_NO>
                  <xsl:value-of select="substring(PackageInfo, 1, 10)"/>
                </PCKG_NO>
                <xsl:if test="(string-length(normalize-space(MasterAgreement/Name))) > 0">
                  <CON_NUMBER>
                    <xsl:value-of select="MasterAgreement/Name"/>
                  </CON_NUMBER>
                  <CON_ITEM>
                    <xsl:value-of select="OutlineRootNumber"/>
                  </CON_ITEM>
                </xsl:if>
                <xsl:if
                  test="(string-length(normalize-space(ServiceDetails/ContractLimit/Amount))) > 0">
                  <LIMIT>
                    <xsl:value-of
                      select="format-number(ServiceDetails/ContractLimit/Amount, '#.000')"/>
                  </LIMIT>
                </xsl:if>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
              </item>
            </xsl:if>
            <xsl:if test="ChangedState = 4">
              <!--Line Insertion -->
              <xsl:variable name="v_count" select="position()"/>
              <item>
                <PCKG_NO>
                  <xsl:value-of select="$v_count"/>
                </PCKG_NO>
                <xsl:if test="(string-length(normalize-space(MasterAgreement/Name))) > 0">
                  <CON_NUMBER>
                    <xsl:value-of select="MasterAgreement/Name"/>
                  </CON_NUMBER>
                  <CON_ITEM>
                    <xsl:value-of select="OutlineRootNumber"/>
                  </CON_ITEM>
                </xsl:if>
                <xsl:if
                  test="(string-length(normalize-space(ServiceDetails/ContractLimit/Amount))) > 0">
                  <LIMIT>
                    <xsl:value-of
                      select="format-number(ServiceDetails/ContractLimit/Amount, '#.000')"/>
                  </LIMIT>
                </xsl:if>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
              </item>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </POCONTRACTLIMITS>
      <POLIMITS>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <!--IG-27129: Added LineType/Category condition to populate POLIMITS in case of ARIBA Contract exist -->            
          <xsl:if
            test="(not(LineType) or LineType/Category = 1) and ((ServiceDetails/RequiresServiceEntry eq 'true' and ParentLineNumber = 0) or ((not(ServiceDetails/RequiresServiceEntry) or ServiceDetails/RequiresServiceEntry = 'false') and ItemCategory/UniqueName = 'B'))">
            <xsl:if test="ChangedState = 1 or ChangedState = 2">
              <!--Line Updation -->
              <item>
                <PCKG_NO>
                  <xsl:value-of select="substring(PackageInfo, 1, 10)"/>
                </PCKG_NO>
                <xsl:if test="ServiceDetails/MaxAmount/Amount">
                  <LIMIT>
                    <xsl:value-of select="format-number(ServiceDetails/MaxAmount/Amount, '#.000')"/>
                  </LIMIT>
                </xsl:if>
                <xsl:if test="ServiceDetails/ExpectedAmount/Amount">
                  <EXP_VALUE>
                    <xsl:value-of
                      select="format-number(ServiceDetails/ExpectedAmount/Amount, '#.000')"/>
                  </EXP_VALUE>
                </xsl:if>
                <xsl:choose>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when test="string-length(normalize-space(ServiceDetails/OtherLimit/Amount)) > 0">
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <FREE_LIMIT>
                      <xsl:value-of
                        select="format-number(ServiceDetails/OtherLimit/Amount, '#.000')"/>
                    </FREE_LIMIT>
                  </xsl:when>
                  <xsl:otherwise>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <FREE_LIMIT>
                        <xsl:value-of
                          select="format-number(ServiceDetails/MaxAmount/Amount, '#.000')"/>
                      </FREE_LIMIT>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
                <LINETYPECATEGORY>
                  <xsl:value-of select="LineType/Category"/>
                </LINETYPECATEGORY>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <LINE_TYPE>
                  <xsl:value-of select="LineType/UniqueName"/>
                </LINE_TYPE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <SAPPOITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </SAPPOITEM>
              </item>
            </xsl:if>
            <xsl:if test="ChangedState = 4">
              <!--Line Insertion -->
              <xsl:variable name="v_count" select="position()"/>
              <item>
                <PCKG_NO>
                  <xsl:value-of select="$v_count"/>
                </PCKG_NO>
                <xsl:if test="ServiceDetails/MaxAmount/Amount">
                  <LIMIT>
                    <xsl:value-of select="format-number(ServiceDetails/MaxAmount/Amount, '#.000')"/>
                  </LIMIT>
                </xsl:if>
                <xsl:if test="ServiceDetails/ExpectedAmount/Amount">
                  <EXP_VALUE>
                    <xsl:value-of
                      select="format-number(ServiceDetails/ExpectedAmount/Amount, '#.000')"/>
                  </EXP_VALUE>
                </xsl:if>
                <xsl:choose>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when test="string-length(normalize-space(ServiceDetails/OtherLimit/Amount)) > 0">
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <FREE_LIMIT>
                      <xsl:value-of
                        select="format-number(ServiceDetails/OtherLimit/Amount, '#.000')"/>
                    </FREE_LIMIT>
                  </xsl:when>
                  <xsl:otherwise>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <FREE_LIMIT>
                        <xsl:value-of
                          select="format-number(ServiceDetails/MaxAmount/Amount, '#.000')"/>
                      </FREE_LIMIT>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
                <LINETYPECATEGORY>
                  <xsl:value-of select="LineType/Category"/>
                </LINETYPECATEGORY>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <LINE_TYPE>
                  <xsl:value-of select="LineType/UniqueName"/>
                </LINE_TYPE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <SAPPOITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </SAPPOITEM>
              </item>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </POLIMITS>
      <POSCHEDULE>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <xsl:if test="not(LineType) and ParentLineNumber = 0">
            <item>
              <PO_ITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </PO_ITEM>
              <SCHED_LINE>
                <xsl:value-of select='"0001"'/>
              </SCHED_LINE>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(NeedByDateString)) > 0">
                  <DELIVERY_DATE>
                    <!--    IG-26364: Date Format Sent for DELIVERY_DATE field for PO change     -->
                    <xsl:value-of select="NeedByDateString"/>
                    <!--    IG-26364  Date Format Sent for DELIVERY_DATE field for PO change     -->
                  </DELIVERY_DATE>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(SAPNeedByDate)) > 0">
                    <DELIVERY_DATE>
                      <!--    IG-26364: Date Format Sent for DELIVERY_DATE field for PO change     -->
                      <xsl:value-of select="SAPNeedByDate"/>
                      <!--    IG-26364: Date Format Sent for DELIVERY_DATE field for PO change     -->
                    </DELIVERY_DATE>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
              <ARIBA_ITEM_NO>
                <xsl:value-of select="number(NumberOnPOString)"/>
              </ARIBA_ITEM_NO>
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            </item>
          </xsl:if>
          <xsl:if
            test="((LineType/Category = 4.0) or ((LineType/Category = 8.0) or (LineType/Category = 16.0))) and (TaxCode/UniqueName and (ChangedState = 4.0 or ChangedState = 2.0))">
            <item>
              <PO_ITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </PO_ITEM>
              <SCHED_LINE>
                <xsl:value-of select='"0001"'/>
              </SCHED_LINE>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(NeedByDateString)) > 0">
                  <DELIVERY_DATE>
                    <!--    IG-26364  Date Format Sent for DELIVERY_DATE field for PO change     -->
                    <xsl:value-of select="NeedByDateString"/>
                    <!--    IG-26364  Date Format Sent for DELIVERY_DATE field for PO change     -->
                  </DELIVERY_DATE>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(SAPNeedByDate)) > 0">
                    <DELIVERY_DATE>
                      <!--    IG-26364: Date Format Sent for DELIVERY_DATE field for PO change     -->
                      <xsl:value-of select="SAPNeedByDate"/>
                      <!--    IG-26364: Date Format Sent for DELIVERY_DATE field for PO change     --> 
                    </DELIVERY_DATE>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
              <ARIBA_ITEM_NO>
                <xsl:value-of select="number(NumberOnPOString)"/>
              </ARIBA_ITEM_NO>
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            </item>
          </xsl:if>
        </xsl:for-each>
      </POSCHEDULE>
      <POSERVICES>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <xsl:sort select="ItemOnReq" order="ascending"/>
          <xsl:if
            test="(not(LineType) or LineType/Category = 1) and ((ServiceDetails/RequiresServiceEntry eq 'true' and ParentLineNumber = 0) or (ServiceDetails/RequiresServiceEntry eq 'false' and ParentLineNumber = 0))">
            <xsl:if test="ChangedState = 1 or ChangedState = 2">
              <!--Line Updation -->
              <item>
                <xsl:choose>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when test="string-length(normalize-space(PackageInfo)) > 10">
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <PCKG_NO>
                      <xsl:value-of select="substring(PackageInfo, 1, 10)"/>
                    </PCKG_NO>
                  </xsl:when>
                  <xsl:otherwise>
                    <PCKG_NO>
                      <xsl:value-of select="position()"/>
                    </PCKG_NO>
                  </xsl:otherwise>
                </xsl:choose>
                <LINE_NO/>
                <EXT_LINE/>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <OUTL_IND>X</OUTL_IND>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <!--We do not need SubPack numbers for Framework Orders-->
                <xsl:if test="not(ItemCategory/UniqueName = $v_frameWorkOrd)">
                  <xsl:choose>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:when test="string-length(normalize-space(PackageInfo)) > 10">
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <SUBPCKG_NO>
                        <xsl:value-of select="substring(PackageInfo, 11)"/>
                      </SUBPCKG_NO>
                    </xsl:when>
                    <xsl:otherwise>
                      <SUBPCKG_NO>
                        <xsl:value-of select="position() + 1"/>
                      </SUBPCKG_NO>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
                <QUANTITY>
                  <xsl:value-of select="format-number(Quantity, '0.000')"/>     <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                </QUANTITY>
                <BASE_UOM>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </BASE_UOM>
                <UOM_ISO>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </UOM_ISO>
                <xsl:if test="Description/PriceBasisQuantity">
                  <PRICE_UNIT>
                    <xsl:value-of select="format-number(Description/PriceBasisQuantity, '#')"/>
                  </PRICE_UNIT>
                </xsl:if>
<!--                IG-32531 Fixed decimal values from .000 to .0000-->
                <GR_PRICE>
                  <xsl:value-of select="format-number(Description/Price/Amount, '#.0000')"/>    <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                </GR_PRICE>
                <!--<SHORT_TEXT>
                  <xsl:value-of select="substring(Description/Description, 1, 40)"/>
                </SHORT_TEXT>-->
                <!-- IG-33614 Adding the material group -->
                <MATL_GROUP>
                  <xsl:value-of select="CommodityCode/UniqueName"/>
                </MATL_GROUP>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
                <LINETYPECATEGORY>
                  <xsl:value-of select="LineType/Category"/>
                </LINETYPECATEGORY>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <LINE_TYPE>
                  <xsl:value-of select="LineType/UniqueName"/>
                </LINE_TYPE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <SAPPOITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </SAPPOITEM>
              </item>
            </xsl:if>
            <xsl:if test="ChangedState = 4">
              <!--Line Updation -->
              <item>
                <PCKG_NO>
                  <xsl:value-of select="position()"/>
                </PCKG_NO>
                <LINE_NO>
                  <xsl:value-of select="'1'"/>
                </LINE_NO>
                <EXT_LINE/>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <OUTL_IND>
                  <xsl:value-of select="'X'"/>
                </OUTL_IND>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <!--We do not need SubPack numbers for Framework Orders-->
                <xsl:if test="not(ItemCategory/UniqueName = $v_frameWorkOrd)">
                  <SUBPCKG_NO>
                    <xsl:value-of select="position() + 1"/>
                  </SUBPCKG_NO>
                </xsl:if>
                <QUANTITY>
                  <xsl:value-of select="format-number(Quantity, '0.000')"/>      <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                </QUANTITY>
                <BASE_UOM>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </BASE_UOM>
                <UOM_ISO>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </UOM_ISO>
                <xsl:if test="Description/PriceBasisQuantity">
                  <PRICE_UNIT>
                    <xsl:value-of select="format-number(Description/PriceBasisQuantity, '#')"/>
                  </PRICE_UNIT>
                </xsl:if>
<!--                IG-32531 Fixed decimal values from .000 to .0000-->
                <GR_PRICE>
                  <xsl:value-of select="format-number(Description/Price/Amount, '#.0000')"/>    <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                </GR_PRICE>
                <!-- <SHORT_TEXT>
                    <xsl:value-of select="substring(Description/Description, 1, 40)"/>
                </SHORT_TEXT>-->
                <!-- IG-33614 Adding the material group -->
                <MATL_GROUP>
                  <xsl:value-of select="CommodityCode/UniqueName"/>
                </MATL_GROUP>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
                <LINETYPECATEGORY>
                  <xsl:value-of select="LineType/Category"/>
                </LINETYPECATEGORY>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <LINE_TYPE>
                  <xsl:value-of select="LineType/UniqueName"/>
                </LINE_TYPE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <SAPPOITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </SAPPOITEM>
              </item>
            </xsl:if>
          </xsl:if>
          <xsl:if test="(not(LineType) or LineType/Category = 1) and ParentLineNumber != 0">
            <xsl:if test="ChangedState = 1 or ChangedState = 2">
              <!--Line Updation -->
              <item>
                <PCKG_NO>
                  <xsl:value-of select="substring(PackageInfo, 11)"/>
                </PCKG_NO>
                <LINE_NO/>
                <EXT_LINE>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </EXT_LINE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <!-- IG-30817: Substring Supplier Part Number -->
                <xsl:if test="string-length(normalize-space(Description/SupplierPartNumber)) > 0">
                <EXT_SERV>
                  <xsl:value-of select="substring(Description/SupplierPartNumber, 1, 18)"/>
                </EXT_SERV>
                </xsl:if>
                <!-- IG-30817: Substring Supplier Part Number -->
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. --> 
                <QUANTITY>
                  <xsl:value-of select="format-number(Quantity, '0.000')"/>
                </QUANTITY>
                <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
                <BASE_UOM>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </BASE_UOM>
                <UOM_ISO>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </UOM_ISO>
                <xsl:if test="Description/PriceBasisQuantity">
                  <PRICE_UNIT>
                    <xsl:value-of select="format-number(Description/PriceBasisQuantity, '#')"/>
                  </PRICE_UNIT>
                </xsl:if>
                <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->  
<!--                IG-32531 Fixed decimal values from .000 to .0000-->
                <GR_PRICE>
                  <xsl:value-of select="format-number(Description/Price/Amount, '#.0000')"/>
                </GR_PRICE>                 
                <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->
                <SHORT_TEXT>
                  <xsl:value-of select="substring(Description/Description, 1, 40)"/>
                </SHORT_TEXT>
                <DISTRIB>
                  <xsl:value-of select="SAPDistributionFlag"/>
                </DISTRIB>
                <!-- IG-33614 Adding the material group -->
                <MATL_GROUP>
                  <xsl:value-of select="CommodityCode/UniqueName"/>
                </MATL_GROUP>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
                <LINETYPECATEGORY>
                  <xsl:value-of select="LineType/Category"/>
                </LINETYPECATEGORY>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <LINE_TYPE>
                  <xsl:value-of select="LineType/UniqueName"/>
                </LINE_TYPE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <SAPPOITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </SAPPOITEM>
              </item>
            </xsl:if>
            <xsl:if test="ChangedState = 4">
              <!--Line Updation -->
              <xsl:variable name="v_parent" select="ParentLineNumber"/>
              <item>
                <xsl:choose>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when
                    test="string-length(normalize-space(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[number(NumberOnPOString) = $v_parent]/PackageInfo)) > 10">
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <PCKG_NO>
                      <xsl:value-of
                        select="substring(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[number(NumberOnPOString) = $v_parent]/PackageInfo, 11)"
                      />
                    </PCKG_NO>
                  </xsl:when>
                  <xsl:otherwise>
                    <PCKG_NO>
                      <xsl:value-of select="ParentLineNumber + 1"/>
                    </PCKG_NO>
                  </xsl:otherwise>
                </xsl:choose>
                <LINE_NO>
                  <xsl:value-of select="NumberOnPOString"/>
                </LINE_NO>
                <EXT_LINE>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </EXT_LINE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <!-- IG-30817: Substring Supplier Part Number -->
                <xsl:if test="string-length(normalize-space(Description/SupplierPartNumber)) > 0">
                <EXT_SERV>
                  <xsl:value-of select="substring(Description/SupplierPartNumber, 1, 18)"/>
                </EXT_SERV>
                </xsl:if>
                <!-- IG-30817: Substring Supplier Part Number -->
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
                <QUANTITY>
                  <xsl:value-of select="format-number(Quantity, '0.000')"/>
                </QUANTITY>
                <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
                <BASE_UOM>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </BASE_UOM>
                <UOM_ISO>
                  <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                </UOM_ISO>
                <xsl:if test="Description/PriceBasisQuantity">
                  <PRICE_UNIT>
                    <xsl:value-of select="format-number(Description/PriceBasisQuantity, '#')"/>
                  </PRICE_UNIT>
                </xsl:if>   
                <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
<!--                IG-32531 Fixed decimal values from .000 to .0000-->
                <GR_PRICE>
                  <xsl:value-of select="format-number(Description/Price/Amount, '#.0000')"/>
                </GR_PRICE>
                <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
                <SHORT_TEXT>
                  <xsl:value-of select="substring(Description/Description, 1, 40)"/>
                </SHORT_TEXT>
                <DISTRIB>
                  <xsl:value-of select="SAPDistributionFlag"/>
                </DISTRIB>
                <!-- IG-33614 Adding the material group -->
                <MATL_GROUP>
                  <xsl:value-of select="CommodityCode/UniqueName"/>
                </MATL_GROUP>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
                <PARENT_LINE_NUMBER>
                  <xsl:value-of select="ParentLineNumber"/>
                </PARENT_LINE_NUMBER>
                <LINETYPECATEGORY>
                  <xsl:value-of select="LineType/Category"/>
                </LINETYPECATEGORY>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <LINE_TYPE>
                  <xsl:value-of select="LineType/UniqueName"/>
                </LINE_TYPE>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <SAPPOITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </SAPPOITEM>
              </item>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdDelItems_Item/item/DeletedERPLineItems/item">
          <xsl:if test="ParentLineNumber != 0 and (not(LineType) or LineType/Category = 1)">
            <item>
              <DELETE_IND>
                <xsl:value-of select="$v_delete"/>
              </DELETE_IND>
              <!--<ITEMONREQ>
                <xsl:value-of
                  select="../../../../ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item/ItemOnReq"
                />
              </ITEMONREQ>-->
              <ARIBA_ITEM_NO>
                <xsl:value-of select="number(NumberOnPOString)"/>
              </ARIBA_ITEM_NO>
              <PARENT_LINE_NUMBER>
                <xsl:value-of select="ParentLineNumber"/>
              </PARENT_LINE_NUMBER>
              <LINETYPECATEGORY>
                <xsl:value-of select="LineType/Category"/>
              </LINETYPECATEGORY>
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
              <LINE_TYPE>
                <xsl:value-of select="LineType/UniqueName"/>
              </LINE_TYPE>
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
              <SAPPOITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </SAPPOITEM>
            </item>
          </xsl:if>
        </xsl:for-each>
      </POSERVICES>
      <!-- Comment handling for service child -->
      <POSERVICESTEXT>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_PurchOrdCommentDetails_Item/item/ExportedComments/item[format-number(LineItem/NumberInCollection, '#00000') = $v_purLineDetail[ParentLineNumber > 0]/NumberOnPOString]">
          <xsl:if test="string-length(normalize-space(LineItem/NumberInCollection)) &lt;= 5">
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:variable name="v_textid">
              <xsl:call-template name="GetTextId">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
                <xsl:with-param name="p_commenttype" select="'ServiceTextID'"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="POLineCommentSplit">
              <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
              <!-- IG-41679 removed normalize-space() to retain formatting of eneterd comments in P2P UI-->              
              <xsl:with-param name="p_strcom"
                select="concat(Text, '[', Date, '-', User/UniqueName, ']')"/>
              <xsl:with-param name="p_lencom" select="132"/>
              <xsl:with-param name="p_linecom" select="LineItem/NumberInCollection"/>
              <xsl:with-param name="p_pd" select="$v_pd"/>
              <xsl:with-param name="p_textid" select="$v_textid"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineText_Item/item/SAPOrderInfo/item[NumberOnPOString = $v_purLineDetail[ParentLineNumber > 0]/NumberOnPOString]">
          <xsl:if test="(string-length(normalize-space(normalize-space(NumberOnPOString)))) &lt;= 5">
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output --> 
            <xsl:call-template name="POTextLineSplit">
              <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
              <xsl:with-param name="p_linenum" select="number(NumberOnPOString)"/>
              <xsl:with-param name="p_linestr" select="POString"/>
              <xsl:with-param name="p_linestrlen" select="132"/>
              <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </POSERVICESTEXT>
      <POSRVACCESSVALUES>
        <!-- IG-37134 : Amount formatting based on currency -->
        <xsl:variable name="v_Curr">  <!-- This is to store the currency value -->
          <xsl:value-of select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item/Currency/UniqueName"/>
        </xsl:variable>
        <!-- IG-37134 : Amount formatting based on currency -->
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <xsl:variable name="v_sappoline" select="SAPPOLineNumber"/>
<!--      IG-27546 Don't map accounting details for Unknown account assignment type PO item-->          
          <xsl:if test="AccountCategory/UniqueName != 'U'">          
          <xsl:if
            test="(not(LineType) or LineType/Category = 1) and ((ServiceDetails/RequiresServiceEntry eq 'true' and ParentLineNumber = 0) or (ServiceDetails/RequiresServiceEntry eq 'false' and ParentLineNumber = 0))">
            <xsl:variable name="v_poline" select="NumberOnPOString"/>
            <xsl:variable name="v_package" select="substring(PackageInfo, 1, 10)"/>
            <xsl:variable name="v_len" select="string-length(normalize-space(PackageInfo))"/>               <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:variable name="v_parent" select="ParentLineNumber"/>
            <xsl:variable name="v_pck" select="position()"/>
            <xsl:variable name="v_itemchgstate" select="ChangedState"/>
            <xsl:for-each
              select="../../../../ERPOrder_ChangePurchOrdAcctDet_Item/item/LineItems/item/Accountings/SplitAccountings/item">
              <xsl:if test="POLineNumber eq $v_poline">
                <xsl:if test="ChangedState = 1 or ChangedState = 2">
                  <item>
                    <xsl:choose>
                      <xsl:when test="$v_len > 10">
                        <PCKG_NO>
                          <xsl:value-of select="$v_package"/>
                        </PCKG_NO>
                      </xsl:when>
                      <xsl:otherwise>
                        <PCKG_NO>
                          <xsl:value-of select="$v_pck"/>
                        </PCKG_NO>
                      </xsl:otherwise>
                    </xsl:choose>
                    <LINE_NO/>
                    <SERNO_LINE>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERNO_LINE>
                    <PERCENTAGE>
                      <xsl:choose>
                        <xsl:when test="AdjustedPercentageForSplits != 0">
                          <xsl:value-of
                            select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                          />
                        </xsl:otherwise>
                      </xsl:choose>
                    </PERCENTAGE>
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                    <xsl:choose>
                      <xsl:when test="AdjustedCostInCurrencyPrecision">
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(AdjustedCostInCurrencyPrecision/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:when>
                      <xsl:otherwise>
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(Amount/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:otherwise>
                    </xsl:choose>
                    <ARIBA_ITEM_NO>
                      <xsl:value-of select="number(POLineNumber)"/>
                    </ARIBA_ITEM_NO>
                    <PARENT_LINE_NUMBER>
                      <xsl:value-of select="$v_parent"/>
                    </PARENT_LINE_NUMBER>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <SAPPOITEM>
                      <xsl:value-of select="$v_sappoline"/>
                    </SAPPOITEM>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  </item>
                </xsl:if>
                <xsl:if test="ChangedState = 4 and $v_itemchgstate = 2">
                  <item>
                    <PCKG_NO>
                      <xsl:value-of select="$v_pck"/>
                    </PCKG_NO>
                    <LINE_NO>
                      <xsl:value-of select="'0000000001'"/>
                    </LINE_NO>
                    <SERNO_LINE>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERNO_LINE>
                    <PERCENTAGE>
                      <xsl:choose>
                        <xsl:when test="AdjustedPercentageForSplits != 0">
                          <xsl:value-of
                            select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                          />
                        </xsl:otherwise>
                      </xsl:choose>
                    </PERCENTAGE>
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                    <xsl:choose>
                      <xsl:when test="AdjustedCostInCurrencyPrecision">
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(AdjustedCostInCurrencyPrecision/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:when>
                      <xsl:otherwise>
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(Amount/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:otherwise>
                    </xsl:choose>
                    <ARIBA_ITEM_NO>
                      <xsl:value-of select="number(POLineNumber)"/>
                    </ARIBA_ITEM_NO>
                    <PARENT_LINE_NUMBER>
                      <xsl:value-of select="$v_parent"/>
                    </PARENT_LINE_NUMBER>
                  </item>
                </xsl:if>
                <xsl:if test="ChangedState = 4 and $v_itemchgstate = 4">
                  <item>
                    <PCKG_NO>
                      <xsl:value-of select="$v_pck"/>
                    </PCKG_NO>
                    <LINE_NO>
                      <xsl:value-of select="'0000000000'"/>
                    </LINE_NO>
                    <SERNO_LINE>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERNO_LINE>
                    <PERCENTAGE>
                      <xsl:choose>
                        <xsl:when test="AdjustedPercentageForSplits != 0">
                          <xsl:value-of
                            select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                          />
                        </xsl:otherwise>
                      </xsl:choose>
                    </PERCENTAGE>
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                    <xsl:choose>
                      <xsl:when test="AdjustedCostInCurrencyPrecision">
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(AdjustedCostInCurrencyPrecision/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:when>
                      <xsl:otherwise>
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(Amount/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:otherwise>
                    </xsl:choose>
                    <ARIBA_ITEM_NO>
                      <xsl:value-of select="number(POLineNumber)"/>
                    </ARIBA_ITEM_NO>
                    <PARENT_LINE_NUMBER>
                      <xsl:value-of select="$v_parent"/>
                    </PARENT_LINE_NUMBER>
                  </item>
                  <item>
                    <PCKG_NO>
                      <xsl:value-of select="$v_pck"/>
                    </PCKG_NO>
                    <LINE_NO>
                      <xsl:value-of select="'0000000001'"/>
                    </LINE_NO>
                    <SERNO_LINE>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERNO_LINE>
                    <PERCENTAGE>
                      <xsl:choose>
                        <xsl:when test="AdjustedPercentageForSplits != 0">
                          <xsl:value-of
                            select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                          />
                        </xsl:otherwise>
                      </xsl:choose>
                    </PERCENTAGE>
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                    <xsl:choose>
                      <xsl:when test="AdjustedCostInCurrencyPrecision">
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(AdjustedCostInCurrencyPrecision/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:when>
                      <xsl:otherwise>
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(Amount/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:otherwise>
                    </xsl:choose>
                    <ARIBA_ITEM_NO>
                      <xsl:value-of select="number(POLineNumber)"/>
                    </ARIBA_ITEM_NO>
                    <PARENT_LINE_NUMBER>
                      <xsl:value-of select="$v_parent"/>
                    </PARENT_LINE_NUMBER>
                  </item>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
            <!-- IG-20811 : Limit split not working - standard BAPI issue-->
            <!--Delete split for Limit lines for serives -->
            <xsl:if test="$v_supportsp11onwards = 'true'">
            <xsl:for-each
              select="../../../../ERPOrder_ChangePurchOrdDelAcct_Item/item/LineItems/item/Accountings/DeletedSplitAccountings/item">
              <xsl:if test="POLineNumber eq $v_poline">
                <item>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:if test="string-length(normalize-space($v_package)) > 0">
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <PCKG_NO>
                        <xsl:value-of select="$v_package"/>
                      </PCKG_NO>
                    </xsl:if>
                  <LINE_NO/>
                  <SERNO_LINE>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERNO_LINE>
                  <SERIAL_NO>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERIAL_NO>
                  <ARIBA_ITEM_NO>
                    <xsl:value-of select="number(POLineNumber)"/>
                  </ARIBA_ITEM_NO>
                  <PARENT_LINE_NUMBER>
                    <xsl:value-of select="$v_parent"/>
                  </PARENT_LINE_NUMBER>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <SAPPOITEM>
                    <xsl:value-of select="$v_sappoline"/>
                  </SAPPOITEM>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                </item>
              </xsl:if>
            </xsl:for-each>
            </xsl:if>
            <!--IG-20811 : Limit split not working - standard BAPI issue -->
          </xsl:if>
          <xsl:if test="(not(LineType) or LineType/Category = 1) and ParentLineNumber != 0">
            <xsl:variable name="v_poline" select="NumberOnPOString"/>
            <xsl:variable name="v_package" select="substring(PackageInfo, 11)"/>
            <xsl:variable name="v_parent" select="ParentLineNumber"/>
            <xsl:variable name="v_distrib" select="SAPDistributionFlag"/>
            <xsl:for-each
              select="../../../../ERPOrder_ChangePurchOrdAcctDet_Item/item/LineItems/item/Accountings/SplitAccountings/item">
              <xsl:if test="POLineNumber eq $v_poline">
                <xsl:if test="ChangedState = 1 or ChangedState = 2">
                  <item>
                    <xsl:choose>
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <xsl:when test="string-length(normalize-space($v_package)) > 0">
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <PCKG_NO>
                          <xsl:value-of select="$v_package"/>
                        </PCKG_NO>
                      </xsl:when>
                      <xsl:otherwise>
                        <PCKG_NO>
                          <xsl:value-of select="$v_parent + 1"/>
                        </PCKG_NO>
                      </xsl:otherwise>
                    </xsl:choose>
                    <LINE_NO/>
                    <SERNO_LINE>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERNO_LINE>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <xsl:if test="$v_distrib != '1'">
                        <PERCENTAGE>
                          <xsl:choose>
                            <xsl:when test="AdjustedPercentageForSplits != 0">
                              <xsl:value-of
                                select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
                                select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                              />
                            </xsl:otherwise>
                          </xsl:choose>
                        </PERCENTAGE>
                      </xsl:if>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:if test="$v_distrib = '1'">
                      <QUANTITY>
                        <xsl:value-of
                          select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                        />
                      </QUANTITY>
                    </xsl:if>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <!--<xsl:choose>
                      <xsl:when test="$v_distrib = '1'">
                        <QUANTITY>
                          <xsl:value-of
                            select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                          />
                        </QUANTITY>
                      </xsl:when>
                      <xsl:otherwise>
                        <PERCENTAGE>
                          <xsl:choose>
                            <xsl:when test="AdjustedPercentageForSplits != 0">
                              <xsl:value-of
                                select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
                                select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                              />
                            </xsl:otherwise>
                          </xsl:choose>
                        </PERCENTAGE>
                      </xsl:otherwise>
                    </xsl:choose>-->
                    <xsl:choose>
                      <xsl:when test="AdjustedCostInCurrencyPrecision">
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(AdjustedCostInCurrencyPrecision/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:when>
                      <xsl:otherwise>
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(Amount/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:otherwise>
                    </xsl:choose>
                    <ARIBA_ITEM_NO>
                      <xsl:value-of select="number(POLineNumber)"/>
                    </ARIBA_ITEM_NO>
                    <PARENT_LINE_NUMBER>
                      <xsl:value-of select="$v_parent"/>
                    </PARENT_LINE_NUMBER>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <SAPPOITEM>
                      <xsl:value-of select="$v_sappoline"/>
                    </SAPPOITEM>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  </item>
                </xsl:if>
                <xsl:if test="ChangedState = 4">
                  <item>
                    <xsl:choose>
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <xsl:when
                        test="string-length(normalize-space(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[number(NumberOnPOString) = $v_parent]/PackageInfo)) > 10">
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <PCKG_NO>
                          <xsl:value-of
                            select="substring(/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[number(NumberOnPOString) = $v_parent]/PackageInfo, 11)"
                          />
                        </PCKG_NO>
                      </xsl:when>
                      <xsl:otherwise>
                        <PCKG_NO>
                          <xsl:value-of select="$v_parent + 1"/>
                        </PCKG_NO>
                      </xsl:otherwise>
                    </xsl:choose>
                    <LINE_NO>
                      <xsl:value-of select="POLineNumber"/>
                    </LINE_NO>
                    <SERNO_LINE>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERNO_LINE>
                    <xsl:if test="$v_distrib != '1'">
                      <PERCENTAGE>
                        <xsl:choose>
                          <xsl:when test="AdjustedPercentageForSplits != 0">
                            <xsl:value-of
                              select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                            />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of
                              select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                            />
                          </xsl:otherwise>
                        </xsl:choose>
                      </PERCENTAGE>
                    </xsl:if>
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:if test="$v_distrib = '1'">
                      <QUANTITY>
                        <xsl:value-of
                          select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                        />
                      </QUANTITY>
                    </xsl:if>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <!--<xsl:choose>
                      <xsl:when test="$v_distrib = '1'">
                        <QUANTITY>
                          <xsl:value-of
                            select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                          />
                        </QUANTITY>
                      </xsl:when>
                      <xsl:otherwise>
                        <PERCENTAGE>
                          <xsl:choose>
                            <xsl:when test="AdjustedPercentageForSplits != 0">
                              <xsl:value-of
                                select="format-number(number(translate(AdjustedPercentageForSplits, ',', '')), '#.0')"
                              />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of
                                select="format-number(number(translate(ERPSplitValue, ',', '')), '#.0')"
                              />
                            </xsl:otherwise>
                          </xsl:choose>
                        </PERCENTAGE>
                      </xsl:otherwise>
                    </xsl:choose>-->
                    <xsl:choose>
                      <xsl:when test="AdjustedCostInCurrencyPrecision">
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(AdjustedCostInCurrencyPrecision/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:when>
                      <xsl:otherwise>
                        <NET_VALUE>
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
                              <xsl:value-of select="format-number(Amount/Amount, '#.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:otherwise>
                    </xsl:choose>
                    <ARIBA_ITEM_NO>
                      <xsl:value-of select="number(POLineNumber)"/>
                    </ARIBA_ITEM_NO>
                    <PARENT_LINE_NUMBER>
                      <xsl:value-of select="$v_parent"/>
                    </PARENT_LINE_NUMBER>
                  </item>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
            <!-- Delete split for child lines for serives -->
            <xsl:for-each
              select="../../../../ERPOrder_ChangePurchOrdDelAcct_Item/item/LineItems/item/Accountings/DeletedSplitAccountings/item">
              <xsl:if test="POLineNumber eq $v_poline">
                <item>
                  <xsl:choose>
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:when test="string-length(normalize-space($v_package)) > 0">
                    <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <PCKG_NO>
                        <xsl:value-of select="$v_package"/>
                      </PCKG_NO>
                    </xsl:when>
                    <xsl:otherwise>
                      <PCKG_NO>
                        <xsl:value-of select="$v_parent + 1"/>
                      </PCKG_NO>
                    </xsl:otherwise>
                  </xsl:choose>
                  <LINE_NO/>
                  <SERNO_LINE>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERNO_LINE>
                  <SERIAL_NO>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERIAL_NO>
                  <ARIBA_ITEM_NO>
                    <xsl:value-of select="number(POLineNumber)"/>
                  </ARIBA_ITEM_NO>
                  <SAPPOITEM>
                    <xsl:value-of select="$v_sappoline"/>
                  </SAPPOITEM>
                  <PARENT_LINE_NUMBER>
                    <xsl:value-of select="$v_parent"/>
                  </PARENT_LINE_NUMBER>
                </item>
              </xsl:if>
            </xsl:for-each>
          </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </POSRVACCESSVALUES>
      <!-- PO_ITEM_TEXT logic implemented for line item comments -->
      <POTEXTITEM>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_PurchOrdCommentDetails_Item/item/ExportedComments/item[format-number(LineItem/NumberInCollection, '#00000') = $v_purLineDetail[ParentLineNumber = 0]/NumberOnPOString]">
          <!--    <xsl:if test="LineItem">-->
          <xsl:if test="string-length(normalize-space(LineItem/NumberInCollection)) &lt;= 5">
            <xsl:variable name="v_textid">
              <xsl:call-template name="GetTextId">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
                <xsl:with-param name="p_commenttype" select="'LineTextId'"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="POLineCommentSplit">
              <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
              <!-- IG-41679 removed normalize-space() to retain formatting of eneterd comments in P2P UI-->              
              <xsl:with-param name="p_strcom"
                select="concat(Text, '[', Date, '-', User/UniqueName, ']')"/>
              <xsl:with-param name="p_lencom" select="132"/>
              <xsl:with-param name="p_linecom" select="LineItem/NumberInCollection"/>
              <xsl:with-param name="p_pd" select="$v_pd"/>
              <xsl:with-param name="p_textid" select="$v_textid"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
        <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineText_Item/item/SAPOrderInfo/item[NumberOnPOString = $v_purLineDetail[ParentLineNumber = 0]/NumberOnPOString]">
          <xsl:if test="(string-length(normalize-space(NumberOnPOString))) &lt;= 5">
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <xsl:call-template name="POTextLineSplit">
              <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
              <xsl:with-param name="p_linenum" select="NumberOnPOString"/>
              <xsl:with-param name="p_linestr" select="POString"/>
              <xsl:with-param name="p_linestrlen" select="132"/>
              <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </POTEXTITEM>
      <!--IG-15421-->
      <PO_ACCOUNTS>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdAcctDet_Item/item/LineItems/item/Accountings/SplitAccountings/item">
          <xsl:variable name="v_poline" select="POLineNumber"/>
          <!--      IG-27546 Don't map accounting details for Unknown account assignment type PO item-->
          <xsl:if test="../../../../../../../ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[NumberOnPOString = $v_poline]/AccountCategory/UniqueName != 'U'">          
          <item>
            <PO_ITEM>
              <xsl:value-of
                select="../../../../../../../ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[NumberOnPOString = $v_poline]/SAPPOLineNumber"
              />
            </PO_ITEM>
            <!--
            <PO_ITEM>
              <xsl:value-of select="10.0 * POLineNumber"/>
            </PO_ITEM> -->
            <SERIAL_NO>
              <xsl:value-of select="SAPSerialNumber"/>
            </SERIAL_NO>
            <xsl:choose>
              <xsl:when test="(../../../ReceivingType = 3.0 and ../../../SAPDistributionFlag = '1')">
                <xsl:variable name="v_pricebase"
                  select="../../../../../../../ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[NumberOnPOString = $v_poline]/Description/PriceBasisQuantity"/>
                <xsl:variable name="v_conversion"
                  select="../../../../../../../ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[NumberOnPOString = $v_poline]/Description/ConversionFactor"/>
                <xsl:choose>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when
                    test="string-length(normalize-space($v_pricebase)) > 0 and string-length(normalize-space($v_conversion)) > 0">
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <QUANTITY>
                      <xsl:value-of
                        select="format-number(((Amount/Amount * $v_pricebase) div $v_conversion), '#.000')"
                      />
                    </QUANTITY>
                  </xsl:when>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when
                    test="string-length(normalize-space($v_pricebase)) > 0 and string-length(normalize-space($v_conversion)) le 0">
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <QUANTITY>
                      <xsl:value-of
                        select="format-number(((Amount/Amount * $v_pricebase) div 1), '#.000')"/>
                    </QUANTITY>
                  </xsl:when>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when
                    test="string-length(normalize-space($v_pricebase)) le 0 and string-length(normalize-space($v_conversion)) > 0">
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <QUANTITY>
                      <xsl:value-of
                        select="format-number(((Amount/Amount * 1) div $v_conversion), '#.000')"/>
                    </QUANTITY>
                  </xsl:when>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when
                    test="string-length(normalize-space($v_pricebase)) le 0 and string-length(normalize-space($v_conversion)) le 0">
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <QUANTITY>
                      <xsl:value-of select="format-number(((Amount/Amount * 1) div 1), '#.000')"/>
                    </QUANTITY>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="../../../SAPDistributionFlag = '1'">
                    <QUANTITY>
                      <xsl:value-of
                        select="format-number(number(translate(ERPSplitValue, ',', '')), '#.000')"/>
                    </QUANTITY>
                  </xsl:when>
                  <xsl:otherwise>
                    <DISTR_PERC>
                      <!--Consider AdjustedPercentageForSplits Field-->
                      <xsl:choose>
                        <xsl:when test="AdjustedPercentageForSplits != 0">
                          <xsl:value-of
                            select="format-number((number(translate(AdjustedPercentageForSplits, ',', '')) mod 100.0), '0.0')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of
                            select="format-number((number(translate(ERPSplitValue, ',', '')) mod 100.0), '0.0')"
                          />
                        </xsl:otherwise>
                      </xsl:choose>
                    </DISTR_PERC>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="AdjustedCostInCurrencyPrecision">
                <NET_VALUE>
                  <xsl:value-of
                    select="format-number(AdjustedCostInCurrencyPrecision/Amount, '00.000000000')"/>
                </NET_VALUE>
              </xsl:when>
              <xsl:otherwise>
                <NET_VALUE>
                  <xsl:value-of select="format-number(Amount/Amount, '00.000000000')"/>
                </NET_VALUE>
              </xsl:otherwise>
            </xsl:choose>
            <GL_ACCOUNT>
              <xsl:value-of select="GeneralLedger/UniqueName"/>
            </GL_ACCOUNT>
            <COSTCENTER>
              <xsl:value-of select="CostCenter/UniqueName"/>
            </COSTCENTER>
            <ASSET_NO>
              <xsl:value-of select="Asset/UniqueName"/>
            </ASSET_NO>
            <!-- IG_27855-development Asset Sub Number not exported in Change Order export from CIG -->
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
              <xsl:value-of select="custom/CustomFund/UniqueName"/>
            </FUND>
            <RES_DOC>
              <xsl:value-of select="custom/CustomEarmarkedFundsDocument/UniqueName"/>
            </RES_DOC>
            <!--IG-31965 : PO create with earmarked funds data Correct RES_ITEM-->
            <RES_ITEM>
              <xsl:value-of select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 12)"/>
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
            <ARIBA_BUDGET_PERIOD>
              <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
            </ARIBA_BUDGET_PERIOD>
            <CHGSTATE>
              <xsl:value-of select="ChangedState"/>
            </CHGSTATE>
            <ITEMONREQ>
              <xsl:value-of select="POLineNumber"/>
            </ITEMONREQ>
            <ARIBA_ITEM_NO>
              <xsl:value-of select="number(POLineNumber)"/>
            </ARIBA_ITEM_NO>
          </item>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdDelAcct_Item/item/LineItems/item/Accountings/DeletedSplitAccountings/item">
          <xsl:variable name="v_delpoline" select="POLineNumber"/>
          <!--      IG-27546 Don't map accounting details for Unknown account assignment type PO item-->
          <xsl:if test="../../../../../../../ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[NumberOnPOString = $v_delpoline]/AccountCategory/UniqueName != 'U'">
          <item>
            <SERIAL_NO>
              <xsl:value-of select="SAPSerialNumber"/>
            </SERIAL_NO>
            <DELETE_IND>
              <xsl:value-of select="$v_delete"/>
            </DELETE_IND>
            <ARIBA_ITEM_NO>
              <xsl:value-of select="number($v_delpoline)"/>
            </ARIBA_ITEM_NO>
          </item>
          </xsl:if>
        </xsl:for-each>
      </PO_ACCOUNTS>
      <PO_ADDRDELIVERY>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <xsl:if test="not(LineType)">
            <xsl:if test="HasAdhocShipToAddress eq 'true'">
              <item>
                <PO_ITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </PO_ITEM>
                <CITY>
                  <xsl:value-of select="ShipTo/PostalAddress/City"/>
                </CITY>
                <POSTL_COD1>
                  <xsl:value-of select="ShipTo/PostalAddress/PostalCode"/>
                </POSTL_COD1>
                <STREET>
                  <xsl:value-of select="ShipTo/PostalAddress/Lines"/>
                </STREET>
                <COUNTRY>
                  <xsl:value-of select="ShipTo/PostalAddress/Country/UniqueName"/>
                </COUNTRY>
                <REGION>
                  <xsl:value-of select="ShipTo/PostalAddress/State"/>
                </REGION>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
              </item>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <xsl:if
            test="((LineType/Category = 4.0) or ((LineType/Category = 8.0) or (LineType/Category = 16.0))) and (TaxCode/UniqueName and (ChangedState = 4.0))">
            <xsl:variable name="v_NumPoString" select="NumberOnPOString"/>
            <xsl:if
              test="//PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[ParentLineNumber = $v_NumPoString and LineType/Category != 2]">
              <item>
                <PO_ITEM>
                  <xsl:value-of select="SAPPOLineNumber"/>
                </PO_ITEM>
                <CITY>
                  <xsl:value-of select="ShipTo/PostalAddress/City"/>
                </CITY>
                <POSTL_COD1>
                  <xsl:value-of select="ShipTo/PostalAddress/PostalCode"/>
                </POSTL_COD1>
                <STREET>
                  <xsl:value-of select="ShipTo/PostalAddress/Lines"/>
                </STREET>
                <COUNTRY>
                  <xsl:value-of select="ShipTo/PostalAddress/Country/UniqueName"/>
                </COUNTRY>
                <REGION>
                  <xsl:value-of select="ShipTo/PostalAddress/State"/>
                </REGION>
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="number(NumberOnPOString)"/>
                </ARIBA_ITEM_NO>
              </item>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </PO_ADDRDELIVERY>
      <!-- PO Header Text is mapped based on the below conditions -->
      <PO_HEADER_TEXT>
        <xsl:variable name="v_textid">
          <xsl:call-template name="GetTextId">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_commenttype" select="'HeaderTextId'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_PurchOrdCommentDetails_Item/item/ExportedComments/item">
          <xsl:if test="string-length(normalize-space(LineItem/NumberInCollection)) = 0">
            
            <xsl:call-template name="HeaderCommentSplit">
              <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
              <!-- IG-41679 removed normalize-space() to retain formatting of eneterd comments in P2P UI-->              
              <xsl:with-param name="p_strcom"
                select="concat(Text, '[', Date, '-', User/UniqueName, ']')"/>
              <xsl:with-param name="p_lencom" select="132"/>
              <xsl:with-param name="p_linecom" select="LineItem/NumberInCollection"/>
              <xsl:with-param name="p_pd" select="$v_pd"/>
              <xsl:with-param name="p_textid" select="$v_textid"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdHeaderDet_Item/item">
          <!-- Template is called which will split the Comments -->
          <xsl:call-template name="POTextSplit">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="str" select="Name"/>
            <xsl:with-param name="strlen" select="132"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_textid" select="$v_textid"/>
            <xsl:with-param name="p_version" select="$v_supportsp06onwards"/>
          </xsl:call-template>
        </xsl:for-each>
      </PO_HEADER_TEXT>
      <PO_ITEMS>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <xsl:if test="(not(LineType) or LineType/Category = 1) and ParentLineNumber = 0">
            <item>
              <PO_ITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </PO_ITEM>
              <SHORT_TEXT>
                <xsl:value-of select="substring(Description/Description, 1, 40)"/>
              </SHORT_TEXT>
              <MATERIAL>
                <xsl:value-of select="ItemMasterID/BuyerPartNumber"/>
              </MATERIAL>
              <xsl:choose>
                <xsl:when test='HasAdhocShipToAddress = "true"'>
                  <PLANT>
                    <xsl:value-of select="Requisition/Requester/ShipTo/UniqueName"/>
                  </PLANT>
                </xsl:when>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->  
                  <PLANT>
                    <xsl:value-of select="SAPPlant/UniqueName"/>
                  </PLANT>
                </xsl:when>
                <xsl:otherwise>
                  <PLANT>
                    <xsl:value-of select="ShipTo/UniqueName"/>
                  </PLANT>
                </xsl:otherwise>
              </xsl:choose>
              <MATL_GROUP>
                <xsl:value-of select="CommodityCode/UniqueName"/>
              </MATL_GROUP>
              <!-- IG-30817: Substring Supplier Part Number -->
              <xsl:if test="string-length(normalize-space(Description/SupplierPartNumber)) > 0">
              <VEND_MAT>
                <xsl:value-of select="substring(Description/SupplierPartNumber, 1, 35)"/>
              </VEND_MAT>
              </xsl:if>
              <!-- IG-30817: Substring Supplier Part Number -->
              <xsl:choose>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:when test="ReceivingType = 3.0 and string-length(normalize-space(ServiceDetails)) = 0">    <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  --> 
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <QUANTITY>
                    <xsl:value-of
                      select="format-number(Description/Price/Amount * Quantity, '0.000')"/>
                  </QUANTITY>
                </xsl:when>
                <xsl:otherwise>
                  <QUANTITY>
                    <xsl:value-of select="format-number(Quantity, '0.000')"/>
                  </QUANTITY>
                </xsl:otherwise>
              </xsl:choose>
              <PO_UNIT>
                <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
              </PO_UNIT>
              <ORDERPR_UN>
                <xsl:choose>
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantityUOM/UniqueName)) > 0">
                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                    <xsl:value-of select="Description/PriceBasisQuantityUOM/UniqueName"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                  </xsl:otherwise>
                </xsl:choose>
              </ORDERPR_UN>
              <xsl:if test="not(Description/Price/Amount)">
                <CONV_NUM1>
                  <xsl:value-of select="'X'"/>
                </CONV_NUM1>
                <!-- if Netprice or Amount is initial -->
              </xsl:if>
              <xsl:choose>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:when test="ReceivingType = 3.0 and string-length(normalize-space(ServiceDetails)) = 0">    <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <NET_PRICE>
                    <xsl:value-of select="1.0"/>
                  </NET_PRICE>
                </xsl:when>
                <xsl:otherwise>
                  <NET_PRICE>
                    <xsl:value-of select="format-number(Description/Price/Amount, '00.000000000')"/>
                  </NET_PRICE>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="Description/PriceBasisQuantity">
                <PRICE_UNIT>
                  <xsl:value-of select="format-number(Description/PriceBasisQuantity, '#')"/>
                </PRICE_UNIT>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="TaxCode/UniqueName">
                  <TAX_CODE>
                    <xsl:value-of select="TaxCode/UniqueName"/>
                  </TAX_CODE>
                </xsl:when>
                <xsl:otherwise>
                  <TAX_CODE/>
                </xsl:otherwise>
              </xsl:choose>
              <OVER_DLV_TOL>
                <xsl:value-of select="OverTolerance"/>
              </OVER_DLV_TOL>
              <UNDER_DLV_TOL>
                <xsl:value-of select="UnderTolerance"/>
              </UNDER_DLV_TOL>
              <xsl:choose>
                <xsl:when
                  test="(ServiceDetails/RequiresServiceEntry = 'true' or ((not(ServiceDetails/RequiresServiceEntry) or ServiceDetails/RequiresServiceEntry = 'false') and ItemCategory/UniqueName = 'B'))">
                  <!--Map D when RequiresServiceEntry is true, Map B when RequiresServiceEntry is false and ItemCategory/UniqueName is B else blank -->
                  <xsl:choose>
                    <xsl:when test="ServiceDetails/RequiresServiceEntry = 'true'">
                      <ITEM_CAT>
                        <xsl:value-of select="'D'"/>
                      </ITEM_CAT>
                    </xsl:when>
                    <xsl:when
                      test="((not(ServiceDetails/RequiresServiceEntry) or ServiceDetails/RequiresServiceEntry = 'false') and ItemCategory/UniqueName = 'B')">
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
                  <DISTRIB>
                    <xsl:value-of select="SAPDistributionFlag"/>
                  </DISTRIB>
                  <PART_INV>
                    <xsl:value-of select="SAPPartialInvoiceFlag"/>
                  </PART_INV>
                  <xsl:choose>
                    <xsl:when
                      test="(ServiceDetails/RequiresServiceEntry = 'true' and (not(ServiceDetails/NonSESBasedInvoice) or ServiceDetails/NonSESBasedInvoice != 'true'))">
                      <GR_IND>
                        <xsl:value-of select="'X'"/>
                      </GR_IND>
                    </xsl:when>
                    <xsl:otherwise>
                      <GR_IND/>
                    </xsl:otherwise>
                  </xsl:choose>                  
                  <xsl:if test="not(Description/Price/Amount)">
                    <FREE_ITEM>
                      <xsl:value-of select="'X'"/>
                    </FREE_ITEM>
                    <!-- if Netprice or Amount is initial -->
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <ITEM_CAT/>
                  <ACCTASSCAT>
                    <xsl:value-of select="AccountCategory/UniqueName"/>
                  </ACCTASSCAT>
                  <DISTRIB>
                    <xsl:value-of select="SAPDistributionFlag"/>
                  </DISTRIB>
                  <PART_INV>
                    <xsl:value-of select="SAPPartialInvoiceFlag"/>
                  </PART_INV>
                  <GR_IND>
                    <xsl:value-of select="'X'"/>
                  </GR_IND>                  
                  <xsl:if test="not(Description/Price/Amount)">
                    <FREE_ITEM>
                      <xsl:value-of select="'X'"/>
                    </FREE_ITEM>
                    <!-- if Netprice or Amount is initial -->
                  </xsl:if>
                  <!--Begin of CI-1014 - GRBASEDINVOICE-->
                  <!-- If ERS flag is true pass X or if GRBasedInvoice is true pass X, Else Pass "F" to GR_BASEDIV Field-->
                  <!-- Keep the old logic for versions less the SP15 -->
                  <xsl:choose>
                    <xsl:when test="$v_supportsp15onwards  = 'true'">
                      <xsl:choose>                      
                        <xsl:when test="(ERSAllowed = 'true' or GRBasedInvoice = 'true')">
                          <GR_BASEDIV>
                            <xsl:value-of select="'X'"/>
                          </GR_BASEDIV>
                        </xsl:when>
                        <!--IG-32818:  Service Po with GRbasedIv fails in ERP no indicator should be passed for Service line -->
                        <xsl:when test="(GRBasedInvoice = 'false' and not(ServiceDetails/RequiresServiceEntry = 'true' or ((not(ServiceDetails/RequiresServiceEntry) or ServiceDetails/RequiresServiceEntry = 'false') and ItemCategory/UniqueName = 'B')))">
                        <!--IG-32818: Service Po with GRbasedIv fails in ERP no indicator should be passed for Service line -->   
                          <GR_BASEDIV>
                            <xsl:value-of select="'F'"/>
                          </GR_BASEDIV>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="ERSAllowed = 'true'">
                        <GR_BASEDIV>
                          <xsl:value-of select="'X'"/>
                        </GR_BASEDIV>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>  
                  <!--End of CI-1014 - GRBASEDINVOICE-->
                </xsl:otherwise>
              </xsl:choose> 
              <!-- <IG-8224:-Contract Reference>   --> 
              <xsl:if test="ServiceDetails/RequiresServiceEntry = 'true' 
                and string-length(normalize-space(MasterAgreement/Name)) > 0 
                and string-length(normalize-space(MasterAgreement/Name)) = 10 
                and string(number(MasterAgreement/Name)) != 'NaN' ">                                                                  
                <AGREEMENT>
                  <xsl:value-of select="MasterAgreement/Name"/>
                </AGREEMENT>
                <AGMT_ITEM>                                    
                  <xsl:value-of select="OutlineRootNumber"/>
                </AGMT_ITEM>
              </xsl:if>  
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
              <xsl:if test="string-length(normalize-space(ERSAllowed)) > 0">
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <ERS>
                  <xsl:choose>
                    <xsl:when test="ERSAllowed = 'true'">
                      <xsl:value-of select="'X'"/>
                    </xsl:when>
                    <xsl:when test="ERSAllowed = 'false'">
                      <xsl:value-of select="'N'"/>
                    </xsl:when>
                  </xsl:choose>
                </ERS>
              </xsl:if>
              <PREQ_NO>
                <xsl:value-of
                  select="../../../../ERPOrder_ChangePurchOrdHeaderDet_Item/item/ERPRequisitionID"/>
              </PREQ_NO>
              <PREQ_ITEM>
                <xsl:value-of select="ERPLineItemNumber"/>
              </PREQ_ITEM>
              <!--IG-31078 : Populate Requisitioner Name-->
              <xsl:if test="string-length(normalize-space(RealRequester/UniqueName)) > 0">
                <PREQ_NAME>
                  <xsl:value-of select="substring(RealRequester/UniqueName,1,12)"/>
                </PREQ_NAME>
              </xsl:if>
              <!--Item Category 'B'  -->
              <xsl:if
                test="((ServiceDetails/RequiresServiceEntry = 'true') or ((not(ServiceDetails/RequiresServiceEntry) or ServiceDetails/RequiresServiceEntry = 'false') and ItemCategory/UniqueName = 'B'))">
                <xsl:choose>
                  <xsl:when test="ChangedState = 4">
                    <PCKG_NO>
                      <xsl:value-of select="position()"/>
                    </PCKG_NO>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                      <xsl:when test="string-length(normalize-space(PackageInfo)) > 10">
                      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                        <PCKG_NO>
                          <xsl:value-of select="substring(PackageInfo, 1, 10)"/>
                        </PCKG_NO>
                      </xsl:when>
                      <xsl:otherwise>
                        <PCKG_NO>
                          <xsl:value-of select="position()"/>
                        </PCKG_NO>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
              <!--For a Service PO-->
              <xsl:if test=" ERSAllowed = 'true' or (ServiceDetails/RequiresServiceEntry = 'true' and (not(ServiceDetails/NonSESBasedInvoice) or ServiceDetails/NonSESBasedInvoice != 'true')
              and $v_supportsp10onwards = 'true')">
                <SRV_BASED_IV>X</SRV_BASED_IV>
              </xsl:if>
              <xsl:choose>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:when test="string-length(normalize-space(NeedByDateString)) > 0">
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <EEIND>
                    <!-- IG-25800 Needby & Sap Needby date transformation correction in Purchase order change -->  
                    <xsl:choose>
                      <xsl:when test="contains(NeedByDateString,'-')">
                        <xsl:value-of select="substring(NeedByDateString, 1, 10)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="concat(substring(NeedByDateString, 1, 4), '-', substring(NeedByDateString, 5, 2), '-', substring(NeedByDateString, 7, 2))"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </EEIND>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(SAPNeedByDate)) > 0">
                    <EEIND>
                      <xsl:choose>
                        <xsl:when test="contains(SAPNeedByDate,'-')">
                          <xsl:value-of select="substring(SAPNeedByDate, 1, 10)"/>
                        </xsl:when>
                        <!-- IG-25800 Needby & Sap Needby date transformation correction in Purchase order change -->
                        <xsl:otherwise>
                          <xsl:value-of select="concat(substring(SAPNeedByDate, 1, 4), '-', substring(SAPNeedByDate, 5, 2), '-', substring(SAPNeedByDate, 7, 2))"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </EEIND>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <CONV_UNIT>
                <xsl:value-of select="Description/ConversionFactor"/>
              </CONV_UNIT>              
              <xsl:if test='OriginatingSystemReferenceID = "OriginatingSystemReferenceID"'>
                <REQ_ID>
                  <xsl:value-of select="OriginatingSystemReferenceID"/>
                </REQ_ID>
              </xsl:if>
              <xsl:choose>
                <xsl:when test='OriginatingSystemReferenceID = "OriginatingSystemReferenceID"'>
                  <ITEMONREQ>
                    <xsl:value-of select="OriginatingSystemReferenceID"/>
                  </ITEMONREQ>
                </xsl:when>
                <xsl:otherwise>
                  <ITEMONREQ>
                    <xsl:value-of select="ItemOnReq"/>
                  </ITEMONREQ>
                </xsl:otherwise>
              </xsl:choose>
              <CHGSTATE>
                <xsl:value-of select="ChangedState"/>
              </CHGSTATE>
              <RECEIVINGTYPE>
                <xsl:value-of select="ReceivingType"/>
              </RECEIVINGTYPE>
              <ARIBA_ITEM_NO>
                <xsl:value-of select="number(NumberOnPOString)"/>
              </ARIBA_ITEM_NO>
              <xsl:if test="TaxDetail/Percent">
                <TAX_PERCENT>
                  <xsl:value-of select="TaxDetail/Percent"/>
                </TAX_PERCENT>
              </xsl:if>
              <IS_TAX_DEDUCTIBLE>
                <xsl:value-of select="TaxDetail/IsDeductible"/>
              </IS_TAX_DEDUCTIBLE>
              <LINE_TYPE>
                <xsl:value-of select="LineType/UniqueName"/>
              </LINE_TYPE>
              <!-- start IG-26033 PurchaseOrderChangeExportRequest doesn't include "ServiceStartDate" and "ServiceEndDate" -->  
              <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceStartDate)) > 0"> 
                <SERVICESTARTDATE>                 
                  <xsl:choose>              
                    <xsl:when test="contains(ServiceDetails/ServiceStartDate,'-')">
                      <xsl:value-of select="substring(ServiceDetails/ServiceStartDate, 1, 10)"/>
                    </xsl:when>
                    <xsl:otherwise>	  
                      <xsl:value-of select="concat(substring(ServiceDetails/ServiceStartDate, 1,4), '-',
                        substring(ServiceDetails/ServiceStartDate, 5, 2), '-',
                        substring(ServiceDetails/ServiceStartDate, 7, 2))"/>                            
                    </xsl:otherwise>	
                  </xsl:choose>	                
                </SERVICESTARTDATE>      
              </xsl:if>
              <!-- end IG-26033  -->
              <!-- IG-28902: number formating tax perunit value to decimal 4 places as per ERP requirement  -->
              <xsl:if test="string-length(normalize-space(TaxDetail/PerUnit)) > 0">
                <TAX_PER_UNIT>
                  <xsl:value-of select="format-number(TaxDetail/PerUnit, '0.0000')"/>
                  <!-- IG-28902 -->
                </TAX_PER_UNIT>
              </xsl:if>
              <!-- start IG-26033 PurchaseOrderChangeExportRequest doesn't include "ServiceStartDate" and "ServiceEndDate" -->  
              <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceEndDate)) > 0">               
                <SERVICEENDDATE>  
                  <xsl:choose>              
                    <xsl:when test="contains(ServiceDetails/ServiceEndDate,'-')">
                      <xsl:value-of select="substring(ServiceDetails/ServiceEndDate, 1, 10)"/>
                    </xsl:when>
                    <xsl:otherwise>	  
                      <xsl:value-of select="concat(substring(ServiceDetails/ServiceEndDate, 1,4), '-',
                        substring(ServiceDetails/ServiceEndDate, 5, 2), '-',
                        substring(ServiceDetails/ServiceEndDate, 7, 2))"/>                          
                    </xsl:otherwise>	
                  </xsl:choose>                   
                </SERVICEENDDATE>   
              </xsl:if>              
              <!-- end IG-26033  -->
              <xsl:if test="TaxDetail/TaxableAmount/Amount">
                <TAXABLEAMOUNT_AMOUNT>
                  <xsl:value-of select="TaxDetail/TaxableAmount/Amount"/>
                </TAXABLEAMOUNT_AMOUNT>
              </xsl:if>
              <PARENT_LINE_NUMBER>
                <xsl:value-of select="ParentLineNumber"/>
              </PARENT_LINE_NUMBER>
              <LINETYPECATEGORY>
                <xsl:value-of select="LineType/Category"/>
              </LINETYPECATEGORY>
              <SAPPOITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </SAPPOITEM>   
            </item>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdDelItems_Item/item/DeletedERPLineItems/item">
          <xsl:if
            test="((SAPPOLineNumber and ParentLineNumber = 0) or (SAPPOLineNumber and ((LineType/Category = 4.0) or (LineType/Category = 8.0) or (LineType/Category = 16.0))))">
            <item>
              <PO_ITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </PO_ITEM>
              <DELETE_IND>
                <xsl:value-of select="$v_delete"/>
              </DELETE_IND>
              <ITEMONREQ>
                <xsl:value-of select="number(NumberOnPOString)"/>
              </ITEMONREQ>
              <ARIBA_ITEM_NO>
                <xsl:value-of select="number(NumberOnPOString)"/>
              </ARIBA_ITEM_NO>
              <LINE_TYPE>
                <xsl:value-of select="LineType/UniqueName"/>
              </LINE_TYPE>
              <PARENT_LINE_NUMBER>
                <xsl:value-of select="ParentLineNumber"/>
              </PARENT_LINE_NUMBER>
              <LINETYPECATEGORY>
                <xsl:value-of select="LineType/Category"/>
              </LINETYPECATEGORY>
              <SAPPOITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </SAPPOITEM>
            </item>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each
          select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item">
          <!--IG-18356-->
          <xsl:if
            test="((LineType/Category = 4.0) or ((LineType/Category = 8.0) or (LineType/Category = 16.0))) and (TaxCode/UniqueName and (ChangedState = 4.0 or ChangedState = 2.0 or ChangedState = 1.0))">
          <!--IG-18356-->  
            <item>
              <PO_ITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </PO_ITEM>
              <xsl:variable name="v_tlctext1" select="Description/Description"/>
              <xsl:variable name="v_tlctext2" select='" with tax on item "'/>
              <xsl:variable name="v_parentline" select="ParentLineNumber"/>
              <xsl:variable name="v_tlctext3"
                select="/PurchaseOrderChangeExportRequest/ERPOrder_ChangePurchOrdLineDet_Item/item/LineItems/item[number(NumberOnPOString) = $v_parentline]/SAPPOLineNumber"/>
              <!-- Incase of New Mainling and chargeline, we have fetch the ebelp no from erp Since SAPPOLineNumber will be initial-->
              <SHORT_TEXT>
                <xsl:value-of select="concat($v_tlctext1, $v_tlctext2, $v_tlctext3)"/>
              </SHORT_TEXT>
              <MATERIAL>
                <xsl:value-of select="ItemMasterID/BuyerPartNumber"/>
              </MATERIAL>
              <xsl:choose>
                <xsl:when test='HasAdhocShipToAddress = "true"'>
                  <PLANT>
                    <xsl:value-of select="Requisition/Requester/ShipTo/UniqueName"/>
                  </PLANT>
                </xsl:when>
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">
                <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                  <PLANT>
                    <xsl:value-of select="SAPPlant/UniqueName"/>
                  </PLANT>
                </xsl:when>
                <xsl:otherwise>
                  <PLANT>
                    <xsl:value-of select="ShipTo/UniqueName"/>
                  </PLANT>
                </xsl:otherwise>
              </xsl:choose>
              <MATL_GROUP>
                <xsl:value-of select="CommodityCode/UniqueName"/>
              </MATL_GROUP>
              <xsl:choose>
                <xsl:when test="ChangedState = 4.0">
                  <QUANTITY>
                    <xsl:value-of select="'1'"/>
                  </QUANTITY>
                </xsl:when>
                <xsl:otherwise>
                  <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->  
                      <QUANTITY>
                        <xsl:value-of select="format-number(Quantity, '0.000')"/>
                      </QUANTITY>
                  <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->               
                </xsl:otherwise>               
              </xsl:choose>              
              <PO_UNIT>
                <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
              </PO_UNIT>
              <xsl:choose>
                <xsl:when test="ChangedState = 4.0">
                  <ORDERPR_UN/>
                </xsl:when>
                <xsl:otherwise>
                  <ORDERPR_UN>
                    <xsl:value-of select="Description/PriceBasisQuantityUOM/UniqueName"/>
                  </ORDERPR_UN>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="ChangedState = 4.0">                
                <CONV_NUM1>
                  <xsl:value-of select="'1'"/>
                </CONV_NUM1>
                <CONV_DEN1>
                  <xsl:value-of select="'1'"/>
                </CONV_DEN1>
              </xsl:if>
              <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->            
                  <NET_PRICE>
                    <xsl:value-of select="format-number(Description/Price/Amount, '00.000000000')"/>
                  </NET_PRICE>               
              <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->
              <xsl:if test="Description/PriceBasisQuantity">
                <xsl:choose>
                  <xsl:when test="ChangedState = 4.0">
                    <PRICE_UNIT>
                      <xsl:value-of select="'1'"/>
                    </PRICE_UNIT>
                  </xsl:when>
                  <xsl:otherwise>
                    <PRICE_UNIT>
                      <xsl:value-of select="format-number(Description/PriceBasisQuantity, '#')"/>
                    </PRICE_UNIT>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="TaxCode/UniqueName">
                  <TAX_CODE>
                    <xsl:value-of select="TaxCode/UniqueName"/>
                  </TAX_CODE>
                </xsl:when>
                <xsl:otherwise>
                  <TAX_CODE/>
                </xsl:otherwise>
              </xsl:choose>
              <OVER_DLV_TOL>
                <xsl:value-of select="OverTolerance"/>
              </OVER_DLV_TOL>
              <UNDER_DLV_TOL>
                <xsl:value-of select="UnderTolerance"/>
              </UNDER_DLV_TOL>
              <NO_MORE_GR>
                <xsl:value-of select="'X'"/>
              </NO_MORE_GR>
              <ACCTASSCAT>
                <xsl:value-of select="AccountCategory/UniqueName"/>
              </ACCTASSCAT>
              <DISTRIB>
                <xsl:value-of select="SAPDistributionFlag"/>
              </DISTRIB>
              <PART_INV>
                <xsl:value-of select="SAPPartialInvoiceFlag"/>
              </PART_INV>
              <GR_IND/>
              <PREQ_NO>
                <xsl:value-of
                  select="../../../../ERPOrder_ChangePurchOrdHeaderDet_Item/item/ERPRequisitionID"/>
              </PREQ_NO>
              <PREQ_ITEM>
                <xsl:value-of select="ERPLineItemNumber"/>
              </PREQ_ITEM>
              <!--IG-31078 : Populate Requisitioner Name-->
              <xsl:if test="string-length(normalize-space(RealRequester/UniqueName)) > 0">
                <PREQ_NAME>
                  <xsl:value-of select="substring(RealRequester/UniqueName,1,12)"/>
                </PREQ_NAME>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(NeedByDateString)) > 0">
                  <EEIND>
                    <xsl:choose>
                      <xsl:when test="contains(NeedByDateString,'-')">
                        <xsl:value-of select="substring(NeedByDateString, 1, 10)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="concat(substring(NeedByDateString, 1, 4), '-', substring(NeedByDateString, 5, 2), '-', substring(NeedByDateString, 7, 2))"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </EEIND>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(SAPNeedByDate)) > 0">
                    <EEIND>
                      <xsl:choose>
                        <xsl:when test="contains(SAPNeedByDate,'-')">
                          <xsl:value-of select="substring(SAPNeedByDate, 1, 10)"/>
                        </xsl:when>
                        <!-- IG-25800 Needby & Sap Needby date transformation correction in Purchase order change -->
                        <xsl:otherwise>
                          <xsl:value-of select="concat(substring(SAPNeedByDate, 1, 4), '-', substring(SAPNeedByDate, 5, 2), '-', substring(SAPNeedByDate, 7, 2))"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </EEIND>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <CONV_UNIT>
                <xsl:value-of select="Description/ConversionFactor"/>
              </CONV_UNIT>
              <xsl:if test='OriginatingSystemReferenceID = "OriginatingSystemReferenceID"'>
                <REQ_ID>
                  <xsl:value-of select="OriginatingSystemReferenceID"/>
                </REQ_ID>
              </xsl:if>
              <xsl:choose>
                <xsl:when test='OriginatingSystemReferenceID = "OriginatingSystemReferenceID"'>
                  <ITEMONREQ>
                    <xsl:value-of select="OriginatingSystemReferenceID"/>
                  </ITEMONREQ>
                </xsl:when>
                <xsl:otherwise>
                  <ITEMONREQ>
                    <xsl:value-of select="ItemOnReq"/>
                  </ITEMONREQ>
                </xsl:otherwise>
              </xsl:choose>
              <CHGSTATE>
                <xsl:value-of select="ChangedState"/>
              </CHGSTATE>
              <RECEIVINGTYPE>
                <xsl:value-of select="ReceivingType"/>
              </RECEIVINGTYPE>
              <ARIBA_ITEM_NO>
                <xsl:value-of select="number(NumberOnPOString)"/>
              </ARIBA_ITEM_NO>
              <xsl:if test="TaxDetail/Percent">
                <TAX_PERCENT>
                  <xsl:value-of select="TaxDetail/Percent"/>
                </TAX_PERCENT>
              </xsl:if>
              <IS_TAX_DEDUCTIBLE>
                <xsl:value-of select="TaxDetail/IsDeductible"/>
              </IS_TAX_DEDUCTIBLE>
              <LINE_TYPE>
                <xsl:value-of select="LineType/UniqueName"/>
              </LINE_TYPE>
              <!-- start IG-26033 PurchaseOrderChangeExportRequest doesn't include "ServiceStartDate" and "ServiceEndDate" -->  
              <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceStartDate)) > 0"> 
              <SERVICESTARTDATE>  
                  <xsl:choose>              
                    <xsl:when test="contains(ServiceDetails/ServiceStartDate,'-')">
                      <xsl:value-of select="substring(ServiceDetails/ServiceStartDate, 1, 10)"/>
                    </xsl:when>
                    <xsl:otherwise>	  
                      <xsl:value-of select="concat(substring(ServiceDetails/ServiceStartDate, 1,4), '-',
                        substring(ServiceDetails/ServiceStartDate, 5, 2), '-',
                        substring(ServiceDetails/ServiceStartDate, 7, 2))"/>                           
                    </xsl:otherwise>	
                  </xsl:choose>	                   
              </SERVICESTARTDATE> 
              </xsl:if>  
              <!-- end IG-26033  -->
              <!-- IG-28902: number formating tax perunit value to decimal 4 places as per ERP requirement  -->
              <xsl:if test="string-length(normalize-space(TaxDetail/PerUnit)) > 0">
                <TAX_PER_UNIT>
                  <xsl:value-of select="format-number(TaxDetail/PerUnit, '0.0000')"/>
                  <!-- IG-28902 -->
                </TAX_PER_UNIT>
              </xsl:if>
              <!-- start IG-26033 PurchaseOrderChangeExportRequest doesn't include "ServiceStartDate" and "ServiceEndDate" -->   
              <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceEndDate)) > 0"> 
                <SERVICEENDDATE>                   
                  <xsl:choose>              
                    <xsl:when test="contains(ServiceDetails/ServiceEndDate,'-')">
                      <xsl:value-of select="substring(ServiceDetails/ServiceEndDate, 1, 10)"/>
                    </xsl:when>
                    <xsl:otherwise>	  
                      <xsl:value-of select="concat(substring(ServiceDetails/ServiceEndDate, 1,4), '-',
                        substring(ServiceDetails/ServiceEndDate, 5, 2), '-',
                        substring(ServiceDetails/ServiceEndDate, 7, 2))"/>              
                    </xsl:otherwise>	
                  </xsl:choose>	                  
                </SERVICEENDDATE> 
              </xsl:if>
              <!-- end IG-26033  -->
              <xsl:if test="TaxDetail/TaxableAmount/Amount">
                <TAXABLEAMOUNT_AMOUNT>
                  <xsl:value-of select="TaxDetail/TaxableAmount/Amount"/>
                </TAXABLEAMOUNT_AMOUNT>
              </xsl:if>
              <PARENT_LINE_NUMBER>
                <xsl:value-of select="ParentLineNumber"/>
              </PARENT_LINE_NUMBER>
              <LINETYPECATEGORY>
                <xsl:value-of select="LineType/Category"/>
              </LINETYPECATEGORY>
              <SAPPOITEM>
                <xsl:value-of select="SAPPOLineNumber"/>
              </SAPPOITEM>             
              <MATERIAL_LNG>
                <xsl:value-of select="ItemMasterID/BuyerPartNumber"/>
              </MATERIAL_LNG>
            </item>
          </xsl:if>
        </xsl:for-each>
      </PO_ITEMS>
      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    </n0:ARBCIG_BAPI_PO_CHANGE>
  </xsl:template>
</xsl:stylesheet>
