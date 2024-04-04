<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xpath-default-namespace="urn:Ariba:Buyer:vsap"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
  exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>  <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->   
    <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
<!--  <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
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
  <!-- CI-1014 GRBasedInvoice-->
  <xsl:variable name="v_supportsp15onwards">
    <xsl:call-template name="Check_SupportVersion">
      <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
      <xsl:with-param name="p_suppversion" select="'15'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:template match="PurchaseOrderExportRequest">
    <xsl:variable name="v_purHeader" select="ERPOrder_PurchOrdHeaderDetails_Item/item"/>
    <xsl:variable name="v_purLineDetail"
      select="ERPOrder_PurchOrdLineDetails_Item/item/LineItems/item"/>
    <xsl:variable name="v_purcomment"
      select="ERPOrder_PurchOrdCommentDetails_Item/item/ExportedComments"/>
    <xsl:variable name="v_purlinetext" select="ERPOrder_PurchOrdLineText_Item"/>
    <xsl:variable name="v_purSchdLine"
      select="ERPOrder_PurchOrdScheduleDetails_Item/item/LineItems/item"/>
    <xsl:variable name="v_purLineAddDetail"
      select="ERPOrder_PurchOrdLineAddDetails_Item/item/LineItems/item"/>
    <xsl:variable name="v_purAcctDetails"
      select="ERPOrder_PurchOrdAcctDetails_Item/item/LineItems/item/Accountings/SplitAccountings/item"/>
    <xsl:variable name="v_attachment"
      select="ERPOrder_PurchOrdAttachmentDetails_Item/item/ExportedAttachments/item"/>
    <xsl:variable name="v_true" select="'X'"/>
    <xsl:variable name="v_reqId">
      <xsl:choose>
        <xsl:when
          test="string-length(normalize-space(ERPOrder_PurchOrdHeaderDetails_Item/item/ERPRequisitionID)) > 0">
          <xsl:value-of select="ERPOrder_PurchOrdHeaderDetails_Item/item/ERPRequisitionID"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="ERPOrder_PurchOrdHeaderDetails_Item/item/OriginatingSystemReferenceID"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="v_currency">
      <xsl:value-of select="$v_purHeader/Currency/UniqueName"/>
    </xsl:variable>
    <n0:ARBCIG_BAPI_PO_CREATE1>
      <!-- <IG-37128 - XSLT Improvements , rearranging XSLT tags>--> 
      <xsl:if test="$v_attachment">
        <ATTACHMENT>
          <xsl:for-each select="$v_attachment">
            <item>
              <FILE_NAME>
                <xsl:value-of select="Attachment/Filename"/>
              </FILE_NAME>
              <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
              <xsl:if
                test="string-length(normalize-space(Attachment/ReferencedBy/item/LineItem/NumberInCollection)) > 0">
                <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
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
      <PARTITION>
        <xsl:value-of select="@partition"/>
      </PARTITION>
      <!-- Purchase Order Header Details -->
      <PO_HEADER>
        <COMP_CODE>
          <xsl:value-of select="$v_purHeader/CompanyCode/UniqueName"/>
        </COMP_CODE>
        <DOC_TYPE>
          <!--For ERP Docment type 'FO' check if ItemCategory/UniqueName='B'-->
          <xsl:variable name="v_itemCategoryFlag">
            <xsl:if test="($v_purLineDetail/ItemCategory/UniqueName = 'B')">
              <xsl:value-of select="'YES'"/>
            </xsl:if>
          </xsl:variable>
          <xsl:call-template name="FillDocType">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_ordCategory" select="$v_purHeader/OrderMethodCategory"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_itemCategory" select="$v_itemCategoryFlag"/>
            <!--param FO flag yes/no-->
          </xsl:call-template>
        </DOC_TYPE>
        <VENDOR>
          <xsl:value-of select="$v_purHeader/Supplier/UniqueName"/>
        </VENDOR>
        <PMNTTRMS>
          <xsl:value-of select="$v_purHeader/PaymentTerms/UniqueName"/>
        </PMNTTRMS>
        <PURCH_ORG>
          <xsl:value-of select="$v_purHeader/PurchaseOrg/UniqueName"/>
        </PURCH_ORG>
        <PUR_GROUP>
          <xsl:value-of select="$v_purHeader/PurchaseGroup/UniqueName"/>
        </PUR_GROUP>
        <CURRENCY>
          <xsl:value-of select="$v_currency"/>
        </CURRENCY>
        <DOC_DATE>
          <xsl:call-template name="ERPDateFormat">
            <xsl:with-param name="p_date" select="$v_purHeader/CreationDateString"/>
          </xsl:call-template>
        </DOC_DATE>
        <VPER_START>
          <xsl:value-of select="substring($v_purHeader/ValidityStartDate, 1, 10)"/>
        </VPER_START>
        <VPER_END>
          <xsl:value-of select="substring($v_purHeader/ValidityEndDate, 1, 10)"/>
        </VPER_END>
        <ARIBA_DOC_TYPE>
          <xsl:value-of select="$v_purHeader/OrderMethodCategory"/>
        </ARIBA_DOC_TYPE>
        <ERPORDERID>
          <xsl:value-of select="$v_purHeader/UniqueName"/>
        </ERPORDERID>
        <DOCDATE_USERTIMEZONE>
          <xsl:call-template name="ERPDateFormat">
            <xsl:with-param name="p_date" select="$v_purHeader/CreationDateInRequesterTimeZone"/>
          </xsl:call-template>
        </DOCDATE_USERTIMEZONE>
      </PO_HEADER>
      <VARIANT>
        <xsl:value-of select="@variant"/>
      </VARIANT>
      <!-- Checking if HasAdhocShipToAddress is true then PO_ADDRDELIVERY is sent -->
      <PO_ADDRDELIVERY>
       <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->        
        <xsl:for-each
          select="$v_purLineDetail[string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0]">
       <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
          <xsl:variable name="v_position" select="position()"/>
          <xsl:if test="HasAdhocShipToAddress = 'true'">
            <item>
              <PO_ITEM>
                <xsl:value-of select="format-number($v_position, '00000')"/>
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
                <xsl:value-of select="NumberOnPOString"/>
              </ARIBA_ITEM_NO>
            </item>
          </xsl:if>
        </xsl:for-each>
      </PO_ADDRDELIVERY>
      <!-- <IG-37128 - XSLT Improvements , rearranging XSLT tags>--> 
      <!-- Condition Map Table Logic Population -->
      <PO_COND>
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
        <xsl:for-each
          select="$v_purLineDetail[string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0]">
          <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
          <xsl:variable name="v_NumOnPOString">
            <xsl:value-of select="NumberOnPOString"/>
          </xsl:variable>
          <xsl:variable name="v_item">
            <xsl:value-of select="position()"/>
          </xsl:variable>
          <xsl:variable name="v_netprice">
            <xsl:choose>
              <xsl:when test="ReceivingType = 3">
                <xsl:value-of select="'1.00'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="Description/Price/Amount"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <!--          Only Charges-->
          <xsl:for-each
            select="$v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_NumOnPOString]">
            <xsl:variable name="v_chargeLine" select="NumberOnPOString"/>
            <xsl:variable name="v_itemonreq" select="ItemOnReq"/>
            <xsl:if
              test="((LineType/Category = 4.0) or (LineType/Category = 8.0) or (LineType/Category = 16.0) or (LineType/Category = 32.0))">
              <xsl:if
                test="format-number($v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_chargeLine]/LineType/Category, '0.0') != '2.0'">
                <item>
                  <ITM_NUMBER>
                    <xsl:value-of select="format-number($v_item, '00000')"/>
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
                  <xsl:choose>
                    <xsl:when test="LineType/Category = 32.0">
                      <COND_VALUE>
                        <xsl:value-of
                          select="$v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_NumOnPOString and LineType/Category = 32.0 and ItemOnReq = $v_itemonreq]/Description/Price/Amount"
                        />
                      </COND_VALUE>
                    </xsl:when>
                    <xsl:when test="LineType/Category = 4.0">
                      <COND_VALUE>
                        <xsl:value-of
                          select="$v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_NumOnPOString and LineType/Category = 4.0 and ItemOnReq = $v_itemonreq]/Description/Price/Amount"
                        />
                      </COND_VALUE>
                    </xsl:when>
                    <xsl:when test="LineType/Category = 8.0">
                      <COND_VALUE>
                        <xsl:value-of
                          select="$v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_NumOnPOString and LineType/Category = 8.0 and ItemOnReq = $v_itemonreq]/Description/Price/Amount"
                        />
                      </COND_VALUE>
                    </xsl:when>
                    <xsl:when test="LineType/Category = 16.0">
                      <COND_VALUE>
                        <xsl:value-of
                          select="$v_purLineDetail[format-number(ParentLineNumber, '00000') = $v_NumOnPOString and LineType/Category = 16.0 and ItemOnReq = $v_itemonreq]/Description/Price/Amount"
                        />
                      </COND_VALUE>
                    </xsl:when>
                    <xsl:otherwise>
                      <COND_VALUE>
                        <xsl:value-of select="$v_netprice"/>
                      </COND_VALUE>
                    </xsl:otherwise>
                  </xsl:choose>
                  <CURRENCY>
                    <xsl:value-of select="$v_currency"/>
                  </CURRENCY>
                  <CURRENCY_ISO>
                    <xsl:value-of select="$v_currency"/>
                  </CURRENCY_ISO>
                  <CHANGE_ID>
                    <xsl:value-of select='"I"'/>
                  </CHANGE_ID>
                  <ARIBA_ITEM_NO>
                    <xsl:value-of select="$v_NumOnPOString"/>
                  </ARIBA_ITEM_NO>
                </item>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </PO_COND>    
      <!-- <IG-37128 - XSLT Improvements , rearranging XSLT tags>--> 
      <PO_CONTRACT_LIMITS>
        <xsl:for-each select="$v_purLineDetail">           
          <xsl:if test="(string-length(ServiceDetails) > 0) and ((string-length(normalize-space(MasterAgreement/Name)) = 10) and  string(number(MasterAgreement/Name))!= 'NaN') and (ParentLineNumber = 0)
            and string-length(normalize-space(ServiceDetails/ContractLimit/Amount)) > 0">           <!--IG-26075, IG-8224 Contract Reference-->
            <xsl:variable name="v_POItemInt" select="number(NumberOnPOString)"/>
            <item>
              <PCKG_NO>
                <xsl:value-of select="$v_POItemInt"/>
              </PCKG_NO>
              <xsl:if test="(string-length(normalize-space(MasterAgreement/Name))) > 0">
                <CON_NUMBER>
                  <xsl:value-of select="MasterAgreement/Name"/>
                </CON_NUMBER>
                <CON_ITEM>
                  <xsl:value-of select="OutlineRootNumber"/>
                </CON_ITEM>
              </xsl:if>
              <xsl:if test="string-length(normalize-space(ServiceDetails/ContractLimit/Amount)) > 0">
                <LIMIT>
                  <xsl:value-of
                    select="format-number(ServiceDetails/ContractLimit/Amount, '0.0000')"/>
                </LIMIT>
              </xsl:if>
              <ARIBA_ITEM_NO>
                <xsl:value-of select="NumberOnPOString"/>
              </ARIBA_ITEM_NO>
              <PARENT_LINE_NUMBER>
                <xsl:value-of select="ParentLineNumber"/>
              </PARENT_LINE_NUMBER>
            </item>
          </xsl:if>
        </xsl:for-each>
      </PO_CONTRACT_LIMITS>      
      <!-- PO Header Text is mapped based on the below conditions -->
      <PO_HEADER_TEXT>
        <xsl:variable name="v_textid">
          <xsl:call-template name="GetTextId">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
            <xsl:with-param name="p_commenttype" select="'HeaderTextId'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="ERPOrder_PurchOrdCommentDetails_Item/item/ExportedComments/item">
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
        <xsl:for-each select="ERPOrder_PurchOrdHeaderDetails_Item/item">
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
      <!-- Material PO Items -->
      <xsl:variable name="v_aribaItemNo">
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
        <xsl:value-of
          select="count($v_purLineDetail[string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0])"
        />
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
      </xsl:variable>
      <PO_ITEMS>
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
        <xsl:for-each
          select="$v_purLineDetail[string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0]">
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
          <item>
            <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
            <xsl:variable name="v_ItemOnReq" select="ItemOnReq"/>
            <xsl:variable name="v_POItemInt" select="number(NumberOnPOString)"/>
            <xsl:variable name="v_SrvInd" select="ServiceDetails"/>  <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
            <PO_ITEM>
              <xsl:value-of select="format-number(position(), '00000')"/>
            </PO_ITEM>
            <SHORT_TEXT>
              <xsl:value-of select="substring(Description/Description, 1, 40)"/>
            </SHORT_TEXT>
            <MATERIAL>
              <xsl:value-of select="Description/ItemNumber"/>
            </MATERIAL>
            <xsl:choose>
              <xsl:when test="HasAdhocShipToAddress = 'true'">
                <PLANT>
                  <xsl:value-of select="Requisition/Requester/ShipTo/UniqueName"/>
                </PLANT>
              </xsl:when>
              <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
              <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">
              <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
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
            <!-- IG-16354 reorder -->
            <!-- IG-30817: Substring Supplier Part Number -->
            <xsl:if test="string-length(normalize-space(Description/SupplierPartNumber)) > 0">
            <VEND_MAT>
              <xsl:value-of select="substring(Description/SupplierPartNumber, 1, 35)"/>
            </VEND_MAT>
            </xsl:if>
            <!-- IG-30817: Substring Supplier Part Number -->
            <xsl:for-each select="$v_purSchdLine[NumberOnPOString = $NumOnPOString]">
              <xsl:choose>
                <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
                <xsl:when test="ReceivingType = 3 and string-length(normalize-space($v_SrvInd)) = 0">   <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
                  <QUANTITY>
                    <xsl:value-of
                      select="format-number(Quantity * Description/Price/Amount, '0.000')"/>
                  </QUANTITY>
                </xsl:when>
                <xsl:otherwise>
                  <QUANTITY>
                    <xsl:value-of select="format-number(Quantity, '0.000')"/>
                  </QUANTITY>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
            <PO_UNIT>
              <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
            </PO_UNIT>
            <ORDERPR_UN>
              <xsl:value-of select="Description/PriceBasisQuantityUOM/UniqueName"/>
            </ORDERPR_UN>
            <xsl:choose>
              <xsl:when test="ReceivingType = 3 and string-length(normalize-space($v_SrvInd)) = 0">   <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                <NET_PRICE>
                  <xsl:value-of select="'1.00'"/>
                </NET_PRICE>
              </xsl:when>
              <xsl:otherwise>
                <NET_PRICE>
                  <xsl:value-of select="format-number(Description/Price/Amount, '00.000000000')"/>
                </NET_PRICE>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">
              <PRICE_UNIT>
                <xsl:value-of select="number(Description/PriceBasisQuantity)"/>
              </PRICE_UNIT>
            </xsl:if>
            <TAX_CODE>
              <xsl:value-of select="TaxCode/UniqueName"/>
            </TAX_CODE>
            <OVER_DLV_TOL>
              <xsl:value-of
                select="$v_purLineAddDetail[NumberOnPOString = $NumOnPOString]/OverTolerance"/>
            </OVER_DLV_TOL>
            <UNDER_DLV_TOL>
              <xsl:value-of
                select="$v_purLineAddDetail[NumberOnPOString = $NumOnPOString]/UnderTolerance"/>
            </UNDER_DLV_TOL>
            <xsl:if test="(ParentLineNumber and ParentLineNumber != 0)">
              <NO_MORE_GR>
                <xsl:value-of select="$v_true"/>
              </NO_MORE_GR>
            </xsl:if>
            <!--Map D when RequiresServiceEntry is true, Map B when RequiresServiceEntry is false and ItemCategory/UniqueName is B else blank -->
            <xsl:choose>
              <xsl:when test="ServiceDetails/RequiresServiceEntry = 'true'">
                <ITEM_CAT>D</ITEM_CAT>
              </xsl:when>
              <xsl:when
                test="((not(ServiceDetails/RequiresServiceEntry) or ServiceDetails/RequiresServiceEntry = 'false') and ItemCategory/UniqueName = 'B')">
                <ITEM_CAT>B</ITEM_CAT>
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
              <!--        For Simple Service - GR_IND should not be mapped-->
              <xsl:when
                test="((string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0) and (not(ServiceDetails/NonSESBasedInvoice) or ServiceDetails/NonSESBasedInvoice != 'true'))">
                <GR_IND>
                  <xsl:value-of select="$v_true"/>
                </GR_IND>
              </xsl:when>
              <xsl:otherwise>
                <GR_IND/>
              </xsl:otherwise>
            </xsl:choose>
            <IR_IND>
              <xsl:value-of select="$v_true"/>
            </IR_IND>
            <!--Begin of CI-1014 - GRBASEDINVOICE-->
            <!-- If ERS flag is true pass X or if GRBasedInvoice is true pass X, Else Pass "F" to GR_BASEDIV Field-->
            <!-- Keep the old logic for versions less the SP15 -->
            <xsl:choose>
              <xsl:when test="$v_supportsp15onwards  = 'true'">
                <xsl:choose>                      
                  <xsl:when test="(ERSAllowed = 'true' or GRBasedInvoice = 'true')">
                    <GR_BASEDIV>
                      <xsl:value-of select="$v_true"/>
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
                    <xsl:value-of select="$v_true"/>
                  </GR_BASEDIV>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>  
            <!--End of CI-1014 - GRBASEDINVOICE-->
            <!-- <IG-8224:-Contract Reference>-->   
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
            <!-- Begin of IG-19616 reorder -->
            <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
            <xsl:if test="string-length(normalize-space(ERSAllowed)) > 0">
            <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output --> 
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
            <!-- End of IG-19616 reorder -->
            <PREQ_NO>
              <xsl:value-of select="$v_reqId"/>
            </PREQ_NO>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(ERPLineItemNumber)) > 0">
                <PREQ_ITEM>
                  <xsl:value-of select="ERPLineItemNumber"/>
                </PREQ_ITEM>
              </xsl:when>
              <xsl:otherwise>
                <PREQ_ITEM>
                  <xsl:value-of
                    select="$v_purSchdLine[NumberOnPOString = $NumOnPOString]/OriginatingSystemLineNumber"
                  />
                </PREQ_ITEM>
              </xsl:otherwise>
            </xsl:choose>
            <!--IG-31078 : Populate Requisitioner Name-->
            <xsl:if test="string-length(normalize-space(RealRequester/UniqueName)) > 0">
              <PREQ_NAME>
                <xsl:value-of select="substring(RealRequester/UniqueName,1,12)"/>
              </PREQ_NAME>
            </xsl:if>
            <PCKG_NO>
              <xsl:value-of select="$v_POItemInt"/>
            </PCKG_NO>
            <!--For a Service PO, if ERS is enabled-->
            <xsl:if test=" ERSAllowed = 'true' or (ServiceDetails/RequiresServiceEntry = 'true' and (not(ServiceDetails/NonSESBasedInvoice) or ServiceDetails/NonSESBasedInvoice != 'true')
              and $v_supportsp10onwards = 'true')">
              <SRV_BASED_IV>
                <xsl:value-of select="$v_true"/>
              </SRV_BASED_IV>
            </xsl:if>
            <CONV_UNIT>
              <xsl:value-of select="Description/ConversionFactor"/>
            </CONV_UNIT>
            <REQ_ID>
              <xsl:value-of select="RequisitionNumber"/>
            </REQ_ID>
            <ITEMONREQ>
              <xsl:value-of select="ItemOnReq"/>
            </ITEMONREQ>
            <RECEIVINGTYPE>
              <xsl:value-of select="ReceivingType"/>
            </RECEIVINGTYPE>
            <ARIBA_ITEM_NO>
              <xsl:value-of select="$NumOnPOString"/>
            </ARIBA_ITEM_NO>
            <xsl:if test="string-length(normalize-space(TaxDetail/Percent)) > 0">
              <TAX_PERCENT>
                <xsl:value-of select="format-number(TaxDetail/Percent, '00.0')"/>
              </TAX_PERCENT>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(TaxDetail/IsDeductible)) > 0">
              <IS_TAX_DEDUCTIBLE>
                <xsl:value-of select="TaxDetail/IsDeductible"/>
              </IS_TAX_DEDUCTIBLE>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount)) > 0">
              <MAXAMOUNT>
                <xsl:value-of select="format-number(ServiceDetails/MaxAmount/Amount, '0.0000')"/>
              </MAXAMOUNT>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Amount)) > 0">
              <EXPECTEDAMOUNT>
                <xsl:value-of select="format-number(ServiceDetails/ExpectedAmount/Amount, '0.0000')"
                />
              </EXPECTEDAMOUNT>
            </xsl:if>
            <xsl:if
              test="string-length(normalize-space(ServiceDetails/MaxAmount/Currency/UniqueName)) > 0">
              <MAXAMOUNT_CURRENCY>
                <xsl:value-of select="ServiceDetails/MaxAmount/Currency/UniqueName"/>
              </MAXAMOUNT_CURRENCY>
            </xsl:if>
            <!--when Item Category 'B'-->
            <xsl:if
              test="((ServiceDetails/RequiresServiceEntry) = 'true') or ((not(ServiceDetails/RequiresServiceEntry) or ServiceDetails/RequiresServiceEntry = 'false') and ItemCategory/UniqueName = 'B')">
              <REQUIRESSERVICEENTRY>
                <xsl:value-of select="'X'"/>
              </REQUIRESSERVICEENTRY>
            </xsl:if>
            <LINE_TYPE>
              <xsl:value-of select="LineType/UniqueName"/>
            </LINE_TYPE>
            <xsl:if
              test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Currency/UniqueName)) > 0">
              <EXPECTD_CURRENCY>
                <xsl:value-of select="ServiceDetails/ExpectedAmount/Currency/UniqueName"/>
              </EXPECTD_CURRENCY>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceStartDate)) > 0">
              <SERVICESTARTDATE>
                <xsl:value-of select="substring(ServiceDetails/ServiceStartDate, 1, 10)"/>
              </SERVICESTARTDATE>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(TaxDetail/PerUnit)) > 0">
              <TAX_PER_UNIT>
                <!-- IG-28902: number formating tax perunit value to decimal 4 places as per ERP requirement  -->
                <xsl:value-of select="format-number(TaxDetail/PerUnit, '0.0000')"/>
                <!-- IG-28902 -->
              </TAX_PER_UNIT>
            </xsl:if>
            <xsl:if
              test="string-length(normalize-space(TaxDetail/TaxableAmount/ApproxAmountInBaseCurrency)) > 0">
              <TAXABLEAMOUNT_IN_BASE_CURRENCY>
                <xsl:value-of
                  select="format-number(TaxDetail/TaxableAmount/ApproxAmountInBaseCurrency, '0.0000')"
                />
              </TAXABLEAMOUNT_IN_BASE_CURRENCY>
            </xsl:if>
            <xsl:if
              test="string-length(normalize-space(TaxDetail/TaxableAmount/Currency/UniqueName)) > 0">
              <TAXABLEAMOUNT_CURRENCY>
                <xsl:value-of select="TaxDetail/TaxableAmount/Currency/UniqueName"/>
              </TAXABLEAMOUNT_CURRENCY>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceEndDate)) > 0">
              <SERVICEENDDATE>
                <xsl:value-of select="substring(ServiceDetails/ServiceEndDate, 1, 10)"/>
              </SERVICEENDDATE>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(TaxDetail/TaxableAmount/Amount)) > 0">
              <TAXABLEAMOUNT_AMOUNT>
                <xsl:value-of select="format-number(TaxDetail/TaxableAmount/Amount, '0.0000')"/>
              </TAXABLEAMOUNT_AMOUNT>
            </xsl:if>
            <PARENT_LINE_NUMBER>
              <xsl:value-of select="ParentLineNumber"/>
            </PARENT_LINE_NUMBER>
            <LINETYPECATEGORY>
              <xsl:value-of select="LineType/Category"/>
            </LINETYPECATEGORY>
            <!--IG-16354 reorder-->
            <MATERIAL_LNG>
              <xsl:value-of select="Description/ItemNumber"/>
            </MATERIAL_LNG>
          </item>
        </xsl:for-each>
        <xsl:for-each select="$v_purLineDetail[ParentLineNumber = 0]">
          <xsl:variable name="v_numOnPOStr">
            <xsl:value-of select="NumberOnPOString"/>
          </xsl:variable>
          <xsl:variable name="v_poitem">
            <xsl:value-of select="position()"/>
          </xsl:variable>
          <xsl:variable name="v_itemOn">
            <xsl:value-of select="ItemOnReq"/>
          </xsl:variable>
          <xsl:for-each
            select="$v_purLineDetail[(LineType/Category = 4 or LineType/Category = 8 or LineType/Category = 16) and (format-number(ParentLineNumber, '00000') = $v_numOnPOStr)]">
            <xsl:variable name="v_desc">
              <xsl:value-of select="Description/Description"/>
            </xsl:variable>
            <xsl:variable name="v_itemOnReq">
              <xsl:value-of select="ItemOnReq"/>
            </xsl:variable>
            <xsl:variable name="v_preq_item">
              <xsl:value-of select="ERPLineItemNumber"/>
            </xsl:variable>
            <xsl:variable name="v_numberOnPOStr">
              <xsl:value-of select="NumberOnPOString"/>
            </xsl:variable>
            <xsl:variable name="v_taxcode">
              <xsl:value-of select="normalize-space(TaxCode)"/>
            </xsl:variable>
            <xsl:for-each
              select="$v_purLineDetail[(LineType/Category = 2) and (Parent/LineType/Category = 4 or Parent/LineType/Category = 8 or Parent/LineType/Category = 16)]">
              <xsl:if test="$v_numberOnPOStr = ParentLineNumber">
                <item>
                  <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
                  <xsl:variable name="v_tlcText1" select="$v_desc"/>
                  <xsl:variable name="v_tlcText2" select='" with tax on item "'/>
                  <PO_ITEM>
                    <xsl:value-of select="format-number(($v_aribaItemNo + position()), '00000')"/>
                  </PO_ITEM>
                  <SHORT_TEXT>
                    <!--<xsl:value-of
                    select="substring(concat($v_tlcText1, $v_tlcText2, $v_itemOn), 1, 40)"
                  />-->
                    <xsl:value-of
                      select="substring(concat($v_tlcText1, $v_tlcText2, $v_poitem), 1, 40)"/>
                  </SHORT_TEXT>
                  <MATERIAL>
                    <xsl:value-of select="Description/ItemNumber"/>
                  </MATERIAL>
                  <xsl:choose>
                    <xsl:when test="HasAdhocShipToAddress = 'true'">
                      <PLANT>
                        <xsl:value-of select="Requisition/Requester/ShipTo/UniqueName"/>
                      </PLANT>
                    </xsl:when>
                    <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
                    <xsl:when test="string-length(normalize-space(SAPPlant/UniqueName)) > 0">
                    <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
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
                  <xsl:for-each select="$v_purSchdLine[NumberOnPOString = $NumOnPOString]">
                    <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
                      <QUANTITY>
                        <xsl:value-of select="format-number(Quantity, '0.000')"/>
                      </QUANTITY>
                    <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
                  </xsl:for-each>
                  <PO_UNIT>
                    <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
                  </PO_UNIT>
                  <ORDERPR_UN/>
                  <!-- IG-16354 reorder -->
                  <CONV_NUM1>
                    <xsl:value-of select="'1'"/>
                  </CONV_NUM1>
                  <CONV_DEN1>
                    <xsl:value-of select="'1'"/>
                  </CONV_DEN1>
                  <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->                 
                      <NET_PRICE>
                        <xsl:value-of
                          select="format-number(sum($v_purLineDetail[NumberOnPOString = $v_numberOnPOStr]/Description/Price/Amount, Description/Price/Amount), '00.000000000')"
                        />
                      </NET_PRICE>   
                  <!-- IG-20698 P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice. -->
                  <!-- IG-16354 reorder -->
                  <PRICE_UNIT>
                    <xsl:value-of select="'1'"/>
                  </PRICE_UNIT>
                  <TAX_CODE>
                    <xsl:value-of select="($v_taxcode)"/>
                  </TAX_CODE>
                  <OVER_DLV_TOL>
                    <xsl:value-of
                      select="$v_purLineAddDetail[NumberOnPOString = $NumOnPOString]/OverTolerance"
                    />
                  </OVER_DLV_TOL>
                  <UNDER_DLV_TOL>
                    <xsl:value-of
                      select="$v_purLineAddDetail[NumberOnPOString = $NumOnPOString]/UnderTolerance"
                    />
                  </UNDER_DLV_TOL>
                  <xsl:if test="(ParentLineNumber and ParentLineNumber != 0)">
                    <NO_MORE_GR>
                      <xsl:value-of select="$v_true"/>
                    </NO_MORE_GR>
                  </xsl:if>
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
                  <GR_IND/>
                  <IR_IND>
                    <xsl:value-of select="$v_true"/>
                  </IR_IND>
                  <PREQ_NO>
                    <xsl:value-of select="$v_reqId"/>
                  </PREQ_NO>
                  <xsl:choose>
                    <xsl:when test="string-length(normalize-space($v_preq_item)) > 0">
                      <PREQ_ITEM>
                        <xsl:value-of select="$v_preq_item"/>
                      </PREQ_ITEM>
                    </xsl:when>
                    <xsl:otherwise>
                      <PREQ_ITEM>
                        <xsl:value-of
                          select="$v_purSchdLine[NumberOnPOString = $NumOnPOString]/OriginatingSystemLineNumber"
                        />
                      </PREQ_ITEM>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!--IG-31078 : Populate Requisitioner Name-->
                  <xsl:if test="string-length(normalize-space(RealRequester/UniqueName)) > 0">
                    <PREQ_NAME>
                      <xsl:value-of select="substring(RealRequester/UniqueName,1,12)"/>
                    </PREQ_NAME>
                  </xsl:if>
                  <CONV_UNIT>
                    <xsl:value-of select="Description/ConversionFactor"/>
                  </CONV_UNIT>
                  <REQ_ID>
                    <xsl:value-of select="RequisitionNumber"/>
                  </REQ_ID>
                  <ITEMONREQ>
                    <xsl:value-of select="$v_itemOnReq"/>
                  </ITEMONREQ>
                  <RECEIVINGTYPE>
                    <xsl:value-of select="ReceivingType"/>
                  </RECEIVINGTYPE>
                  <ARIBA_ITEM_NO>
                    <!--<xsl:value-of select="format-number(($v_aribaItemNo + position()), '00000')"/>-->
                    <xsl:value-of select="$v_numberOnPOStr"/>
                  </ARIBA_ITEM_NO>
                  <xsl:if test="string-length(normalize-space(TaxDetail/Percent)) > 0">
                    <TAX_PERCENT>
                      <xsl:value-of select="format-number(TaxDetail/Percent, '00.0')"/>
                    </TAX_PERCENT>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space(TaxDetail/IsDeductible)) > 0">
                    <IS_TAX_DEDUCTIBLE>
                      <xsl:value-of select="TaxDetail/IsDeductible"/>
                    </IS_TAX_DEDUCTIBLE>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount)) > 0">
                    <MAXAMOUNT>
                      <xsl:value-of
                        select="format-number(ServiceDetails/MaxAmount/Amount, '0.0000')"/>
                    </MAXAMOUNT>
                  </xsl:if>
                  <xsl:if
                    test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Amount)) > 0">
                    <EXPECTEDAMOUNT>
                      <xsl:value-of
                        select="format-number(ServiceDetails/ExpectedAmount/Amount, '0.0000')"/>
                    </EXPECTEDAMOUNT>
                  </xsl:if>
                  <xsl:if
                    test="string-length(normalize-space(ServiceDetails/MaxAmount/Currency/UniqueName)) > 0">
                    <MAXAMOUNT_CURRENCY>
                      <xsl:value-of select="ServiceDetails/MaxAmount/Currency/UniqueName"/>
                    </MAXAMOUNT_CURRENCY>
                  </xsl:if>
                  <xsl:if
                    test="string-length(normalize-space(ServiceDetails/RequiresServiceEntry)) > 0">
                    <REQUIRESSERVICEENTRY>X</REQUIRESSERVICEENTRY>
                  </xsl:if>
                  <LINE_TYPE>
                    <xsl:value-of select="LineType/UniqueName"/>
                  </LINE_TYPE>
                  <xsl:if
                    test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Currency/UniqueName)) > 0">
                    <EXPECTD_CURRENCY>
                      <xsl:value-of select="ServiceDetails/ExpectedAmount/Currency/UniqueName"/>
                    </EXPECTD_CURRENCY>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceStartDate)) > 0">
                    <SERVICESTARTDATE>
                      <xsl:value-of select="substring(ServiceDetails/ServiceStartDate, 1, 10)"/>
                    </SERVICESTARTDATE>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space(TaxDetail/PerUnit)) > 0">
                    <TAX_PER_UNIT>
                      <!-- IG-28902: number formating tax perunit value to decimal 4 places as per ERP requirement  -->
                      <xsl:value-of select="format-number(TaxDetail/PerUnit, '0.0000')"/>
                      <!-- IG-28902 -->
                    </TAX_PER_UNIT>
                  </xsl:if>
                  <xsl:if
                    test="string-length(normalize-space(TaxDetail/TaxableAmount/ApproxAmountInBaseCurrency)) > 0">
                    <TAXABLEAMOUNT_IN_BASE_CURRENCY>
                      <xsl:value-of
                        select="format-number(TaxDetail/TaxableAmount/ApproxAmountInBaseCurrency, '0.0000')"
                      />
                    </TAXABLEAMOUNT_IN_BASE_CURRENCY>
                  </xsl:if>
                  <xsl:if
                    test="string-length(normalize-space(TaxDetail/TaxableAmount/Currency/UniqueName)) > 0">
                    <TAXABLEAMOUNT_CURRENCY>
                      <xsl:value-of select="TaxDetail/TaxableAmount/Currency/UniqueName"/>
                    </TAXABLEAMOUNT_CURRENCY>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space(ServiceDetails/ServiceEndDate)) > 0">
                    <SERVICEENDDATE>
                      <xsl:value-of select="substring(ServiceDetails/ServiceEndDate, 1, 10)"/>
                    </SERVICEENDDATE>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space(TaxDetail/TaxableAmount/Amount)) > 0">
                    <TAXABLEAMOUNT_AMOUNT>
                      <xsl:value-of select="format-number(TaxDetail/TaxableAmount/Amount, '0.0000')"
                      />
                    </TAXABLEAMOUNT_AMOUNT>
                  </xsl:if>
                  <LINETYPECATEGORY>
                    <xsl:value-of select="LineType/Category"/>
                  </LINETYPECATEGORY>
                </item>
              </xsl:if>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </PO_ITEMS>
      <!-- Material PO Account Assignments -->
      <PO_ITEM_ACCOUNT_ASSIGNMENT>
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
        <xsl:for-each
          select="$v_purLineDetail[(string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0)]">
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
          <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
          <xsl:variable name="v_priceBasisQty">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">
                <xsl:value-of select="number(Description/PriceBasisQuantity)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'1'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="v_ItemOnReq">
            <xsl:value-of select="ItemOnReq"/>
          </xsl:variable>
          <xsl:variable name="v_POItemInt" select="number(NumberOnPOString)"/>
          <xsl:variable name="v_conversionFactor">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(Description/ConversionFactor)) > 0">
                <xsl:value-of select="number(Description/ConversionFactor)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'1'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="count" select="position()"/>
          <!--   IG-27546 Don't populate Accounting details if Account assignment category is Unknown 'U'-->
          <xsl:if test="AccountCategory/UniqueName != 'U'">
          <!--PO Account Assignments -->
          <xsl:for-each select="$v_purAcctDetails[(POLineNumber = $NumOnPOString)]">
            <item>
              <xsl:variable name="v_amount">
                <xsl:value-of select="number(Amount/Amount)"/>
              </xsl:variable>
              <PO_ITEM>
                <xsl:value-of select="format-number($count, '00000')"/>
              </PO_ITEM>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(SAPSerialNumber)) > 0">
                  <SERIAL_NO>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERIAL_NO>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(NumberInCollection)) > 0">
                    <SERIAL_NO>
                      <xsl:value-of select="NumberInCollection"/>
                    </SERIAL_NO>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="../../../ReceivingType = 3">
                  <QUANTITY>
                    <xsl:value-of
                      select="translate(format-number(($v_priceBasisQty * $v_amount) div ($v_conversionFactor), '0.000'), '-', '')"
                    />
                  </QUANTITY>
                </xsl:when>
                <xsl:otherwise>
                  <QUANTITY>
                    <xsl:value-of select="translate(format-number(Quantity, '0.000'), '-', '')"/>
                  </QUANTITY>
                </xsl:otherwise>
              </xsl:choose>
              <!--  Variable for split values-->
              <xsl:variable name="v_Percentage">
                <xsl:choose>
                  <xsl:when test="AdjustedPercentageForSplits != 0">
                    <xsl:value-of select="AdjustedPercentageForSplits"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="Percentage"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <!-- End of variable allocation-->
              <!--Below variable percentage is changed to v_percentage-->
              <xsl:choose>
                <xsl:when test="number(translate($v_Percentage, '-', '')) >= 100">
                  <DISTR_PERC>
                    
                      <xsl:value-of select="'0.0'"/>
                    
                  </DISTR_PERC>
                </xsl:when>
                <xsl:otherwise>
                  <DISTR_PERC>
                    <xsl:value-of select="format-number($v_Percentage, '00.0')"/>
                  </DISTR_PERC>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(AdjustedCostInCurrencyPrecision)) > 0">
                  <NET_VALUE>
                    <xsl:value-of
                      select="format-number(AdjustedCostInCurrencyPrecision/Amount, '00.000000000')"
                    />
                  </NET_VALUE>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(Amount/Amount)) > 0">
                    <NET_VALUE>
                      <xsl:value-of select="format-number(Amount/Amount, '00.000000000')"/>
                    </NET_VALUE>
                  </xsl:if>
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
                <xsl:value-of select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 12)"
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
              <ITEMONREQ>
                <xsl:value-of select="POLineNumber"/>
              </ITEMONREQ>
              <!-- IG-24673: BudgetPeriod Mapping-->
              <ARBCIG_BUDGET_PERIOD>
                <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
              </ARBCIG_BUDGET_PERIOD>
            </item>
          </xsl:for-each>
          <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
          <xsl:for-each
            select="$v_purLineDetail[string-length(normalize-space(ParentLineNumber)) > 0 and (not(LineType) or (LineType/Category = 1)) and ($v_POItemInt = ParentLineNumber)]">
          <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
            <xsl:variable name="NumOnPOString">
              <xsl:value-of select="NumberOnPOString"/>
            </xsl:variable>
            <xsl:for-each select="$v_purAcctDetails[(POLineNumber = $NumOnPOString)]">
              <item>
                <xsl:variable name="v_amount">
                  <xsl:value-of select="number(Amount/Amount)"/>
                </xsl:variable>
                <PO_ITEM>
                  <xsl:value-of select="format-number($count, '00000')"/>
                </PO_ITEM>
                <xsl:choose>
                  <xsl:when test="string-length(normalize-space(SAPSerialNumber)) > 0">
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="string-length(normalize-space(NumberInCollection)) > 0">
                      <SERIAL_NO>
                        <xsl:value-of select="NumberInCollection"/>
                      </SERIAL_NO>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="../../../ReceivingType = 3">
                    <QUANTITY>
                      <xsl:value-of
                        select="translate(format-number(($v_priceBasisQty * $v_amount) div ($v_conversionFactor), '0.000'), '-', '')"
                      />
                    </QUANTITY>
                  </xsl:when>
                  <xsl:otherwise>
                    <QUANTITY>
                      <xsl:value-of select="translate(format-number(Quantity, '0.000'), '-', '')"/>
                    </QUANTITY>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="number(translate(Percentage, '-', '')) >= 100">
                    <DISTR_PERC>
                      <xsl:value-of select="'0.0'"/>                      
                    </DISTR_PERC>
                  </xsl:when>
                  <xsl:otherwise>
                    <DISTR_PERC>
                      <xsl:value-of select="format-number(Percentage, '00.0')"/>
                    </DISTR_PERC>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when
                    test="string-length(normalize-space(AdjustedCostInCurrencyPrecision)) > 0">
                    <NET_VALUE>
                      <xsl:value-of
                        select="format-number(AdjustedCostInCurrencyPrecision/Amount, '00.000000000')"
                      />
                    </NET_VALUE>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="string-length(normalize-space(Amount/Amount)) > 0">
                      <NET_VALUE>
                        <xsl:value-of select="format-number(Amount/Amount, '00.000000000')"/>
                      </NET_VALUE>
                    </xsl:if>
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
                <RES_ITEM>
                  <xsl:value-of
                    select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 11)"/>
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
                <ITEMONREQ>
                  <xsl:value-of select="POLineNumber"/>
                </ITEMONREQ>
                <!-- IG-24673: BudgetPeriod Mapping-->
                <ARBCIG_BUDGET_PERIOD>
                  <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
                </ARBCIG_BUDGET_PERIOD>
              </item>
            </xsl:for-each>
          </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
        <!--        Tax on Charge Line-->
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
        <xsl:for-each
          select="$v_purLineDetail[(LineType/Category = 2) and string-length(normalize-space(Parent)) > 0]">
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
          <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
          <xsl:variable name="v_parentLine">
            <xsl:value-of select="ParentLineNumber"/>
          </xsl:variable>
          <xsl:variable name="v_priceBasisQty">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">
                <xsl:value-of select="number(Description/PriceBasisQuantity)"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="v_ItemOnReq">
            <xsl:value-of select="ItemOnReq"/>
          </xsl:variable>
          <xsl:variable name="v_conversionFactor">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(Description/ConversionFactor)) > 0">
                <xsl:value-of select="number(Description/ConversionFactor)"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <!--PO Account Assignments -->
          <xsl:variable name="count" select="position()"/>
          <!-- IG-27546 Don't populate Accounting details if Account assignment category is Unknown 'U'-->
          <xsl:if test="AccountCategory/UniqueName != 'U'">
          <xsl:for-each select="$v_purAcctDetails[(POLineNumber = $v_parentLine)]">
            <item>
              <xsl:variable name="v_amount">
                <xsl:value-of select="number(Amount/Amount)"/>
              </xsl:variable>
              <PO_ITEM>
                <xsl:value-of select="format-number($v_aribaItemNo + $count, '00000')"/>
              </PO_ITEM>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(SAPSerialNumber)) > 0">
                  <SERIAL_NO>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERIAL_NO>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(NumberInCollection)) > 0">
                    <SERIAL_NO>
                      <xsl:value-of select="NumberInCollection"/>
                    </SERIAL_NO>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="../../../ReceivingType = 3">
                  <QUANTITY>
                    <xsl:value-of
                      select="translate(format-number(($v_priceBasisQty * $v_amount) div ($v_conversionFactor), '0.000'), '-', '')"
                    />
                  </QUANTITY>
                </xsl:when>
                <xsl:otherwise>
                  <QUANTITY>
                    <xsl:value-of select="translate(format-number(Quantity, '0.000'), '-', '')"/>
                  </QUANTITY>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="number(translate(Percentage, '-', '')) >= 100">
                  <DISTR_PERC>
                    <xsl:value-of select="'0.0'"/>                    
                  </DISTR_PERC>
                </xsl:when>
                <xsl:otherwise>
                  <DISTR_PERC>
                    <xsl:value-of select="format-number(Percentage, '00.0')"/>
                  </DISTR_PERC>
                </xsl:otherwise>
              </xsl:choose>
              <NET_VALUE>
                <xsl:variable name="v_chargeAmt">
                  <xsl:choose>
                    <xsl:when
                      test="string-length(normalize-space(AdjustedCostInCurrencyPrecision)) > 0">
                      <xsl:value-of select="AdjustedCostInCurrencyPrecision/Amount"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="string-length(normalize-space(Amount/Amount)) > 0">
                        <xsl:value-of select="Amount/Amount"/>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="v_taxAmt">
                  <xsl:choose>
                    <xsl:when
                      test="count($v_purAcctDetails[(POLineNumber = $NumOnPOString)]/AdjustedCostInCurrencyPrecision) = 1">
                      <xsl:choose>
                        <xsl:when
                          test="string-length(normalize-space($v_purAcctDetails[(POLineNumber = $NumOnPOString)]/AdjustedCostInCurrencyPrecision)) > 0">
                          <xsl:value-of
                            select="$v_purAcctDetails[(POLineNumber = $NumOnPOString)]/AdjustedCostInCurrencyPrecision/Amount"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if
                            test="string-length(normalize-space($v_purAcctDetails[(POLineNumber = $NumOnPOString)]/Amount/Amount)) > 0">
                            <xsl:value-of
                              select="$v_purAcctDetails[(POLineNumber = $NumOnPOString)]/Amount/Amount"
                            />
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number(0, '0.00')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="format-number($v_chargeAmt + $v_taxAmt, '00.000000000')"/>
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
                <xsl:value-of select="custom/CustomFund/UniqueName"/>
              </FUND>
              <RES_DOC>
                <xsl:value-of select="custom/CustomEarmarkedFundsDocument/UniqueName"/>
              </RES_DOC>
              <RES_ITEM>
                <xsl:value-of select="substring(custom/CustomEarmarkedFundsLineItem/UniqueName, 11)"
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
              <ITEMONREQ>
                <xsl:value-of select="POLineNumber"/>
              </ITEMONREQ>
              <!-- IG-24673: BudgetPeriod Mapping-->
              <ARBCIG_BUDGET_PERIOD>
                <xsl:value-of select="custom/CustomBudgetPeriod/UniqueName"/>
              </ARBCIG_BUDGET_PERIOD>
            </item>
          </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </PO_ITEM_ACCOUNT_ASSIGNMENT>
      <!-- Material PO Item Schedules -->
      <PO_ITEM_SCHEDULES>
        <xsl:for-each select="$v_purLineDetail">
          <xsl:variable name="v_numonpostr">
            <xsl:value-of select="NumberOnPOString"/>
          </xsl:variable>
          <xsl:variable name="v_erpLineNo" select="ERPLineItemNumber"/>
          <xsl:variable name="v_SrvIndRef" select="ServiceDetails"/>                  <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
          <xsl:for-each select="$v_purSchdLine[NumberOnPOString = $v_numonpostr]">
            <item>
              <SCHED_LINE>0001</SCHED_LINE>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(NeedByDateString)) > 0">
                  <DELIVERY_DATE>
                    <xsl:value-of select="NeedByDateString"/>
                  </DELIVERY_DATE>
                </xsl:when>
                <xsl:otherwise>
                  <DELIVERY_DATE>
                    <xsl:value-of select="SAPneedbyDate"/>
                  </DELIVERY_DATE>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
                <xsl:when test="ReceivingType = 3 and string-length(normalize-space($v_SrvIndRef)) = 0">   <!-- IG-19138: Service PO quantity is the same as the net price causing PO net value  -->
                <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
                  <QUANTITY>
                    <xsl:value-of
                      select="format-number(Quantity * Description/Price/Amount, '0.000')"/>
                  </QUANTITY>
                </xsl:when>
                <xsl:otherwise>
                  <QUANTITY>
                    <xsl:value-of select="format-number(Quantity, '0.000')"/>
                  </QUANTITY>
                </xsl:otherwise>
              </xsl:choose>
              <PREQ_NO>
                <xsl:value-of select="$v_reqId"/>
              </PREQ_NO>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space($v_erpLineNo)) > 0">
                  <PREQ_ITEM>
                    <xsl:value-of select="$v_erpLineNo"/>
                  </PREQ_ITEM>
                </xsl:when>
                <xsl:otherwise>
                  <PREQ_ITEM>
                    <xsl:if test="string-length(normalize-space(OriginatingSystemLineNumber))> 0">  <!-- <IG-37128 - XSLT Improvements>-->
                      <xsl:value-of select="OriginatingSystemLineNumber"/>
                    </xsl:if>
                  </PREQ_ITEM>
                </xsl:otherwise>
              </xsl:choose>
              <ARIBA_ITEM_NO>
                <xsl:value-of select="NumberOnPOString"/>
              </ARIBA_ITEM_NO>
            </item>
          </xsl:for-each>
        </xsl:for-each>
      </PO_ITEM_SCHEDULES>
      <!-- Service PO Limit logic -->
      <!-- PO_ITEM_TEXT logic implemented for line item comments -->
      <PO_ITEM_TEXT>
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
        <xsl:for-each
          select="$v_purLineDetail[string-length(normalize-space(ParentLineNumber)) = 0 or ParentLineNumber = 0]">
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output --> 
          <xsl:variable name="v_poposition">
            <xsl:value-of select="format-number(position(), '00000')"/>
          </xsl:variable>
          <xsl:variable name="v_ponumberstring">
            <xsl:value-of select="NumberOnPOString"/>
          </xsl:variable>
          <xsl:for-each
            select="$v_purcomment/item[format-number(LineItem/NumberInCollection, '#00000') = $v_ponumberstring]">
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
                <xsl:with-param name="p_linecom" select="$v_poposition"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
                <xsl:with-param name="p_textid" select="$v_textid"/>
              </xsl:call-template>

            </xsl:if>

          </xsl:for-each>
          <xsl:for-each
            select="$v_purlinetext/item/SAPOrderInfo/item[NumberOnPOString = $v_ponumberstring]">
          <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
            <xsl:if test="(string-length(normalize-space(NumberOnPOString))) &lt;= 5">
          <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->    
              <xsl:call-template name="POTextLineSplit">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_linenum" select="$v_poposition"/>
                <xsl:with-param name="p_linestr" select="POString"/>
                <xsl:with-param name="p_linestrlen" select="132"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </PO_ITEM_TEXT>
      <!-- Comment handling for Service child lines -->
      <PO_SERVICES_TEXT>
        <xsl:for-each select="$v_purLineDetail[ParentLineNumber > 0]">
          <xsl:variable name="v_ponumberstring">
            <xsl:value-of select="NumberOnPOString"/>
          </xsl:variable>
          <xsl:for-each
            select="$v_purcomment/item[format-number(LineItem/NumberInCollection, '#00000') = $v_ponumberstring]">
            <!--    <xsl:if test="LineItem">-->
            <xsl:if test="string-length(normalize-space(LineItem/NumberInCollection)) &lt;= 5">
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
                <xsl:with-param name="p_linecom" select="$v_ponumberstring"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
                <xsl:with-param name="p_textid" select="$v_textid"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each
            select="$v_purlinetext/item/SAPOrderInfo/item[NumberOnPOString = $v_ponumberstring]">
           <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output --> 
            <xsl:if test="(string-length(normalize-space(NumberOnPOString))) &lt;= 5">
           <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->   
              <xsl:call-template name="POTextLineSplit">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_linenum" select="$v_ponumberstring"/>
                <xsl:with-param name="p_linestr" select="POString"/>
                <xsl:with-param name="p_linestrlen" select="132"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </PO_SERVICES_TEXT>
      <PO_LIMITS>
        <xsl:for-each select="$v_purLineDetail">
          <xsl:if
            test="(string-length(normalize-space(ServiceDetails)) > 0) and (ParentLineNumber = 0)">
            <xsl:variable name="v_ItemOnReq" select="ItemOnReq"/>
            <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
            <xsl:variable name="v_POItemInt" select="number(NumberOnPOString)"/>
            <item>
              <PCKG_NO>
                <xsl:value-of select="$v_POItemInt"/>
              </PCKG_NO>
              <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">
                <LIMIT>
                  <xsl:value-of select="format-number(ServiceDetails/MaxAmount/Amount, '0.0000')"/>
                </LIMIT>
              </xsl:if>
              <xsl:if
                test="string-length(normalize-space(ServiceDetails/ExpectedAmount/Amount)) > 0">
                <EXP_VALUE>
                  <xsl:value-of
                    select="format-number(ServiceDetails/ExpectedAmount/Amount, '0.0000')"/>
                </EXP_VALUE>
              </xsl:if>
              <xsl:choose>
                <xsl:when
                  test="string-length(normalize-space(ServiceDetails/OtherLimit/Amount)) > 0">
                  <FREE_LIMIT>
                    <xsl:value-of select="format-number(ServiceDetails/OtherLimit/Amount, '0.0000')"
                    />
                  </FREE_LIMIT>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(ServiceDetails/MaxAmount/Amount)) > 0">
                    <FREE_LIMIT>
                      <xsl:value-of
                        select="format-number(ServiceDetails/MaxAmount/Amount, '0.0000')"/>
                    </FREE_LIMIT>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </item>
          </xsl:if>
        </xsl:for-each>
      </PO_LIMITS>
      <!-- Service PO Parent Line Logic -->
      <PO_SERVICES>
        <xsl:for-each
          select="$v_purLineDetail[string-length(normalize-space(ServiceDetails)) > 0 and ParentLineNumber = 0]">
<!--          Begin of Changes IG-29083-->
<!--          <xsl:sort select="ItemOnReq" order="ascending"/>-->
          <xsl:sort select="number(ItemOnReq)" order="ascending"/>
<!--          End of Changes IG-29083-->
          <xsl:variable name="v_ItemOnReq" select="ItemOnReq"/>
          <xsl:variable name="v_NumOnPOStr" select="NumberOnPOString"/>
          <xsl:variable name="v_POItemInt" select="number(NumberOnPOString)"/>
          <item>
            <PCKG_NO>
              <xsl:value-of select="$v_POItemInt"/>
            </PCKG_NO>
            <LINE_NO>
              <xsl:value-of select="NumberOnPOString"/>
            </LINE_NO>
            <EXT_LINE>
              <xsl:value-of select="'0000000000'"/>
            </EXT_LINE>
            <OUTL_IND>
              
                <xsl:value-of select="'X'"/>
              
            </OUTL_IND>
            <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
            <SUBPCKG_NO>
<!--              IG-32503 - Fix done to avoid the limation of 99 service parent items-->
              <xsl:value-of select="$v_POItemInt + 999"/>
<!--              IG-32503 - Fix done to avoid the limation of 99 service parent items-->
            </SUBPCKG_NO>
            <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->            
            <EXTREFKEY>
              <xsl:value-of select="$v_ItemOnReq"/>
            </EXTREFKEY>
          </item>
          <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
          <xsl:variable name="v_priceBasisQty" select="Description/PriceBasisQuantity"/>
          <xsl:variable name="v_conversionFactor" select="Description/ConversionFactor"/>
          <xsl:for-each
            select="$v_purLineDetail[(not(LineType) or (LineType/Category = 1)) and (ParentLineNumber > 0) and ($v_POItemInt = ParentLineNumber)]">
<!--            Begin of Changes IG-29083-->
<!--            <xsl:sort select="ItemOnReq" order="ascending"/>-->
            <xsl:sort select="number(ItemOnReq)" order="ascending"/>
<!--            End of Changes IG-29083-->
            <item>
              <PCKG_NO>
                <!--              IG-32503 - Fix done to avoid the limation of 99 service parent items-->                
                <xsl:value-of select="$v_POItemInt + 999"/>
                <!--              IG-32503 - Fix done to avoid the limation of 99 service parent items-->                
              </PCKG_NO>
              <LINE_NO>
                <xsl:value-of select="NumberOnPOString"/>
              </LINE_NO>
              <EXT_LINE>
                <xsl:value-of select="position()"/>
              </EXT_LINE>
              <xsl:variable name="NumOnPOString1" select="NumberOnPOString"/>
              <SUBPCKG_NO>0000000000</SUBPCKG_NO>
              <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
              <!-- IG-30817: Substring Supplier Part Number -->
              <xsl:if test="string-length(normalize-space(Description/SupplierPartNumber)) > 0">
              <EXT_SERV>
                <xsl:value-of select="substring(Description/SupplierPartNumber, 1, 18)"/>
              </EXT_SERV>
              </xsl:if>
              <!-- IG-30817: Substring Supplier Part Number -->
              <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->              
              <xsl:for-each select="$v_purSchdLine[NumberOnPOString = $NumOnPOString1]">
                <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->             
                    <QUANTITY>
                      <xsl:value-of select="format-number(Quantity, '0.000')"/>
                    </QUANTITY>             
                <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.--> 
              </xsl:for-each>
              <BASE_UOM>
                <xsl:value-of select="Description/UnitOfMeasure/UniqueName"/>
              </BASE_UOM>
              <xsl:if test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">
                <PRICE_UNIT>
                  <xsl:value-of select="number(Description/PriceBasisQuantity)"/>
                </PRICE_UNIT>
              </xsl:if>
              <GR_PRICE>
                <xsl:value-of select="format-number(Description/Price/Amount, '0.0000')"/>
              </GR_PRICE>
              <SHORT_TEXT>
                <xsl:value-of select="substring(Description/Description, 1, 40)"/>
              </SHORT_TEXT>
              <DISTRIB>
                <xsl:value-of select="SAPDistributionFlag"/>
              </DISTRIB>
              <MATL_GROUP>
                <xsl:value-of select="CommodityCode/UniqueName"/>
              </MATL_GROUP>
              <EXTREFKEY>
                <xsl:value-of select="ItemOnReq"/>
              </EXTREFKEY>
              <ITEMONREQ>
                <xsl:value-of select="ItemOnReq"/>
              </ITEMONREQ>
              <ARIBA_ITEM_NO>
                <xsl:value-of select="NumberOnPOString"/>
              </ARIBA_ITEM_NO>
              <PARENT_LINE_NUMBER>
                <xsl:value-of select="ParentLineNumber"/>
              </PARENT_LINE_NUMBER>
            </item>
          </xsl:for-each>
        </xsl:for-each>
      </PO_SERVICES>
      <!-- Service PO Child Line Accounting Details -->
      <PO_SRV_ACCASS_VALUES>
        <!-- Service PO Parent Line Accounting Details -->
        <xsl:for-each select="$v_purLineDetail[(ServiceDetails) and ParentLineNumber = 0]">
          <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
          <xsl:variable name="v_POItemInt" select="number(NumberOnPOString)"/>
          <xsl:variable name="v_ItemOnReq" select="ItemOnReq"/>
          <xsl:variable name="v_priceBasisQty">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">
                <xsl:value-of select="Description/PriceBasisQuantity"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'1'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="v_conversionFactor">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(Description/ConversionFactor)) > 0">
                <xsl:value-of select="Description/ConversionFactor"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'1'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="v_childParentLine">
            <xsl:value-of select="ParentLineNumber"/>
          </xsl:variable>
          <!--  IG-27546 Don't populate Accounting details if Account assignment category is Unknown 'U'-->
          <xsl:if test="AccountCategory/UniqueName != 'U'">
          <xsl:for-each select="$v_purAcctDetails[(POLineNumber = $NumOnPOString)]">
            <item>
              <xsl:variable name="v_amount">
                <xsl:value-of select="Amount/Amount"/>
              </xsl:variable>
              <PCKG_NO>
                <xsl:value-of select="$v_POItemInt"/>
              </PCKG_NO>
              <LINE_NO>
                <xsl:value-of select="'0000000000'"/>
              </LINE_NO>
              <xsl:choose>
                <xsl:when test="SAPSerialNumber">
                  <SERNO_LINE>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERNO_LINE>
                </xsl:when>
                <xsl:otherwise>
                  <SERNO_LINE>
                    <xsl:value-of select="NumberInCollection"/>
                  </SERNO_LINE>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="not(Percentage)">
                  <PERCENTAGE>
                    
                      <xsl:value-of select="'100.0'"/>
                    
                  </PERCENTAGE>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="string-length(normalize-space(AdjustedPercentageForSplits)) > 0">
                      <PERCENTAGE>
                        <xsl:value-of
                          select="concat(substring-before(AdjustedPercentageForSplits, '.'), '.', substring(substring-after(AdjustedPercentageForSplits, '.'), 1, 1))"
                        />
                      </PERCENTAGE>
                    </xsl:when>
                    <xsl:otherwise>
                      <PERCENTAGE>
                        <xsl:value-of select="format-number(Percentage, '0.0')"/>
                      </PERCENTAGE>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(SAPSerialNumber)) > 0">
                  <SERIAL_NO>
                    <xsl:value-of select="SAPSerialNumber"/>
                  </SERIAL_NO>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="string-length(normalize-space(NumberInCollection)) > 0">
                    <SERIAL_NO>
                      <xsl:value-of select="NumberInCollection"/>
                    </SERIAL_NO>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->             
              <QUANTITY>
                <xsl:value-of select="translate(format-number(Quantity, '0.000'), '-', '')"/>
              </QUANTITY>                            
              <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->
              <ARIBA_ITEM_NO>
                <xsl:value-of select="POLineNumber"/>
              </ARIBA_ITEM_NO>
            </item>
          </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
        <xsl:for-each
          select="$v_purLineDetail[(not(LineType) or (LineType/Category = 1)) and string-length(normalize-space(ServiceDetails)) > 0 and ParentLineNumber = 0]">
        <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->  
          <xsl:variable name="v_itemonreq">
            <xsl:value-of select="ItemOnReq"/>
          </xsl:variable>
          <xsl:variable name="v_POItemInt" select="number(NumberOnPOString)"/>
          <!--  IG-27546 Don't populate Accounting details if Account assignment category is Unknown 'U'-->
          <xsl:if test="AccountCategory/UniqueName != 'U'">
          <xsl:for-each
            select="$v_purLineDetail[(not(LineType) or (LineType/Category = 1)) and ParentLineNumber > 0 and ParentLineNumber = $v_POItemInt]">
            <xsl:variable name="NumOnPOString" select="NumberOnPOString"/>
            <xsl:variable name="v_priceBasisQty">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(Description/PriceBasisQuantity)) > 0">
                  <xsl:value-of select="number(Description/PriceBasisQuantity)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'1'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="v_ItemOnReq">
              <xsl:value-of select="ItemOnReq"/>
            </xsl:variable>
            <xsl:variable name="v_conversionFactor">
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(Description/ConversionFactor)) > 0">
                  <xsl:value-of select="number(Description/ConversionFactor)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'1'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="v_childParentLine">
              <xsl:value-of select="ParentLineNumber"/>
            </xsl:variable>
            <xsl:variable name="v_distrib">
              <xsl:value-of select="SAPDistributionFlag"/>
            </xsl:variable>
            <xsl:for-each select="$v_purAcctDetails[(POLineNumber = $NumOnPOString)]">
              <item>
                <xsl:variable name="v_amount">
                  <xsl:value-of select="Amount/Amount"/>
                </xsl:variable>
                <PCKG_NO>
                  <!--              IG-32503 - Fix done to avoid the limation of 99 service parent items --> 
                  <xsl:value-of select="$v_POItemInt + 999"/>
                  <!--              IG-32503 - Fix done to avoid the limation of 99 service parent items -->
                </PCKG_NO>
                <LINE_NO>
                  <xsl:value-of select="POLineNumber"/>
                </LINE_NO>
                <xsl:choose>
                  <xsl:when test="SAPSerialNumber">
                    <SERNO_LINE>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERNO_LINE>
                  </xsl:when>
                  <xsl:otherwise>
                    <SERNO_LINE>
                      <xsl:value-of select="NumberInCollection"/>
                    </SERNO_LINE>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="not(Percentage)">
                    <PERCENTAGE>
                     
                        <xsl:value-of select="'100.0'"/>
                      
                    </PERCENTAGE>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when
                        test="string-length(normalize-space(AdjustedPercentageForSplits)) > 0">
                        <PERCENTAGE>
                          <xsl:value-of
                            select="concat(substring-before(AdjustedPercentageForSplits, '.'), '.', substring(substring-after(AdjustedPercentageForSplits, '.'), 1, 1))"
                          />
                        </PERCENTAGE>
                      </xsl:when>
                      <xsl:otherwise>
                        <PERCENTAGE>
                          <xsl:value-of select="format-number(Percentage, '0.0')"/>
                        </PERCENTAGE>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="string-length(normalize-space(SAPSerialNumber)) > 0">
                    <SERIAL_NO>
                      <xsl:value-of select="SAPSerialNumber"/>
                    </SERIAL_NO>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="string-length(normalize-space(NumberInCollection)) > 0">
                      <SERIAL_NO>
                        <xsl:value-of select="NumberInCollection"/>
                      </SERIAL_NO>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
                <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->            
                    <QUANTITY>
                      <xsl:value-of select="translate(format-number(Quantity, '0.000'), '-', '')"/>
                    </QUANTITY>
                <!--IG-20698  P2P Amount base receiving type flow for Service Child lines and follow-on document until Invoice.-->
                <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->
                <xsl:if test="string-length(normalize-space($v_distrib)) > 0">
                  <xsl:if test="$v_distrib = 3">
                    <xsl:choose>
                      <xsl:when test="AdjustedCostInCurrencyPrecision/Amount > 0">
                        <NET_VALUE>
                          <!-- IG-37134 : Amount formatting based on currency -->
                          <xsl:choose>
                            <xsl:when test="$v_currency = 'JPY'">
                              <xsl:call-template name="formatAmount">
                                <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$v_currency = 'VND'">
                              <xsl:call-template name="formatAmount">
                                <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$v_currency = 'KRW'">
                              <xsl:call-template name="formatAmount">
                                <xsl:with-param name="p_amount" select="AdjustedCostInCurrencyPrecision/Amount"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="concat(substring-before(AdjustedCostInCurrencyPrecision/Amount, '.'), '.', substring(substring-after(AdjustedCostInCurrencyPrecision/Amount, '.'), 1, 2))"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:when>
                      <xsl:otherwise>
                        <NET_VALUE>
                          <!-- IG-37134 : Amount formatting based on currency -->
                          <xsl:choose>
                            <xsl:when test="$v_currency = 'JPY'">
                              <xsl:call-template name="formatAmount">
                                <xsl:with-param name="p_amount" select="$v_amount"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$v_currency = 'VND'">
                              <xsl:call-template name="formatAmount">
                                <xsl:with-param name="p_amount" select="$v_amount"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$v_currency = 'KRW'">
                              <xsl:call-template name="formatAmount">
                                <xsl:with-param name="p_amount" select="$v_amount"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number($v_amount, '0.00')"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </NET_VALUE>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:if>
                <!-- IG-18112: Apps XSLT Improvements & Mapping tool creates duplicate extension segements in output -->               
                <ARIBA_ITEM_NO>
                  <xsl:value-of select="POLineNumber"/>
                </ARIBA_ITEM_NO>
              </item>
            </xsl:for-each>
          </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </PO_SRV_ACCASS_VALUES>
    </n0:ARBCIG_BAPI_PO_CREATE1>
  </xsl:template>
</xsl:stylesheet>
