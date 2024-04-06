<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xpath-default-namespace="urn:Ariba:Buyer:vsap"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
  exclude-result-prefixes="#all">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                         <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
  <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
<!--  <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anSenderID1"/>
  <xsl:param name="anSourceDocumentType"/>
  <xsl:param name="attachSeparator" select="'\|'"/>
  <xsl:param name="anAddOnCIVersion"/>  <!-- IG-32939:Inventory Reservation -->
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
      <xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- IG-32939:Inventory Reservation -->
  <xsl:variable name="v_supportSP17onwards">
    <xsl:call-template name="Check_SupportVersion">
      <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
      <xsl:with-param name="p_suppversion" select="'17'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- IG-32939:Inventory Reservation -->
  <xsl:template match="ReservationAsyncExportRequest">
    <xsl:variable name="v_resHeader" select="Reservation_ReservationHeaderDetails_Item/item"/>
    <xsl:variable name="v_resLineDetail"
      select="Reservation_ReservationLineDetails_Item/item/LineItems/item"/>
    <xsl:variable name="v_glAcc"
      select="$v_resHeader/Accounting/SplitAccountings/item/GeneralLedger/UniqueName"/>
    <xsl:variable name="v_attachment"
      select="Reservation_ReservationAttachmentDetails_Item/item/ExportedAttachments/item"/>
    <xsl:variable name="v_lineComment" 
      select="Reservation_ReservationCommentDetails_Item/item"/>     <!--IG-32939:Inventory Reservation -->
    <n0:ARBCIG_STK_RESERVATION>
      <!-- Reservation Header level Details Mapping -->
      <xsl:if test="$v_resHeader">
        <HEADER>
          <item>
            <RES_DATE>
              <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
              <xsl:variable name="v_doc_date" select="$v_resHeader/ReservationDate"/>
              <xsl:if test="string-length(normalize-space($v_doc_date)) > 0">
                <xsl:choose>
                  <xsl:when test="contains($v_doc_date,'-')">
                    <xsl:value-of select="substring($v_doc_date, 1, 10)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="concat(substring($v_doc_date, 1, 4), '-', substring($v_doc_date, 5, 2), '-', substring($v_doc_date, 7, 2))"
                    />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->  
            </RES_DATE>
            <!--IG-32939:Inventory Reservation -->
            <xsl:if test="$v_supportSP17onwards = 'true'">
              <CREATED_BY>
                <xsl:value-of select="substring($v_resHeader/Requester/UniqueName, 1, 12)"/>
              </CREATED_BY>
            </xsl:if>
            <!--IG-32939:Inventory Reservation -->
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <!-- String length check for all acct grp-->
            <xsl:variable name="v_acctDetail">
              <xsl:choose>
                <xsl:when
                  test="string-length(normalize-space($v_resHeader/Accounting/SplitAccountings/item/Asset/UniqueName)) > 0"
                  >
                  <xsl:value-of select="'ASSET_NO'"/>
                </xsl:when>                                                                                              
                                                                                                  <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
                <xsl:when
                  test="string-length(normalize-space($v_resHeader/Accounting/SplitAccountings/item/InternalOrder/UniqueName)) > 0"
                  >
                  <xsl:value-of select="'ORDERID'"/>
                </xsl:when>                                                                                       <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->           
                <xsl:when
                  test="string-length(normalize-space($v_resHeader/Accounting/SplitAccountings/item/WBSElement/UniqueName)) > 0"
                  >
                  <xsl:value-of select="'WBS_ELEMENT'"/>
                </xsl:when>                                                                                   <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->                                                                         
                <!-- IG-38672 Internal Order Account type on Reservation -->
                <xsl:when
                  test="string-length(normalize-space($v_resHeader/Accounting/SplitAccountings/item/CostCenter/UniqueName)) > 0"
                  >
                  <xsl:value-of select="'COSTCENTER'"/>                                                       <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->  
                </xsl:when> 
              </xsl:choose>
            </xsl:variable>            
            <MOVE_TYPE>
              <xsl:call-template name="FillMovType">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_acctDetail" select="$v_acctDetail"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
              </xsl:call-template>
            </MOVE_TYPE>  
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <COSTCENTER>
              <xsl:value-of
                select="$v_resHeader/Accounting/SplitAccountings/item/CostCenter/UniqueName"/>
            </COSTCENTER>
            <ASSET_NO>
              <xsl:value-of select="$v_resHeader/Accounting/SplitAccountings/item/Asset/UniqueName"
              />
            </ASSET_NO>
            <SUB_NUMBER>
              <xsl:value-of select="$v_resHeader/Accounting/SplitAccountings/item/Asset/SubNumber"/>
            </SUB_NUMBER>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->            
            <ORDERID>
              <xsl:value-of
                select="$v_resHeader/Accounting/SplitAccountings/item/InternalOrder/UniqueName"/>
            </ORDERID>
            <WBS_ELEMENT>
              <xsl:value-of
                select="$v_resHeader/Accounting/SplitAccountings/item/WBSElement/UniqueName"/>
            </WBS_ELEMENT>   
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->            
          </item>
        </HEADER>
      </xsl:if>
      <!-- Reservation item level Details Mapping -->
      <ITEM>
        <xsl:for-each select="$v_resLineDetail">
          <item>
            <!--IG-32939:Inventory Reservation -->
            <xsl:variable name="v_lineNo">
              <xsl:value-of select="NumberInCollection"/>
            </xsl:variable>
            <!--IG-32939:Inventory Reservation -->      
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->                                                                                       
            <ARIBA_ITEM>
              <xsl:value-of select="NumberInCollection"/>
            </ARIBA_ITEM>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <STATUS_IND>
              <xsl:value-of select="Action"/>
            </STATUS_IND>
            <MATERIAL_LONG>
              <xsl:value-of select="MaterialNumber"/>
            </MATERIAL_LONG>
            <MATERIAL>
              <xsl:value-of select="MaterialNumber"/>
            </MATERIAL>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output --> 
            <PLANT>    
              <xsl:value-of select="SAPPlant/UniqueName"/>
            </PLANT>
            <STGE_LOC>
              <xsl:value-of select="StorageLocation/UniqueName"/>
            </STGE_LOC>
            <ENTRY_QNT>
              <xsl:value-of select="format-number(Quantity, '0.000')"/>
            </ENTRY_QNT>
            <ENTRY_UOM>
              <xsl:value-of select="UnitOfMeasure/UniqueName"/>
            </ENTRY_UOM>
            <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <!-- IG-32939:Inventory Reservation -->
            <xsl:if test="$v_supportSP17onwards = 'true'">
              <!-- IG-38645 :MultiLine Comment is failing with exception in CIG  -->
              <xsl:variable name="v_Comment">
                <xsl:value-of select="$v_lineComment/Comments/item[ LineItem/NumberInCollection = $v_lineNo ]/Text"/>  
              </xsl:variable>
              <ITEM_TEXT>
                <xsl:value-of select="substring($v_Comment,1,50)"/>                
              </ITEM_TEXT>
              <!-- IG-38645 :MultiLine Comment is failing with exception in CIG  -->
              <GR_RCPT>
                <xsl:value-of select="substring(DeliverTo,1,12)"/>
              </GR_RCPT>
              <UNLOAD_PT>
                <xsl:value-of select="substring(ShipTo/UniqueName,1,25)"/>
              </UNLOAD_PT>
            </xsl:if>
            <!-- IG-32939:Inventory Reservation -->
            <GL_ACCOUNT>
              <xsl:value-of select="$v_glAcc"/>
            </GL_ACCOUNT>
            <MOVEMENT>
              <xsl:value-of select="'X'"/>
            </MOVEMENT>
          </item>
        </xsl:for-each>
      </ITEM>
      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
      <ARIBA_DOC_NO>
        <xsl:value-of select="$v_resHeader/UniqueName"/>
      </ARIBA_DOC_NO>
      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
      <xsl:if test="$v_attachment">
        <ATTACHMENT>
          <xsl:for-each select="$v_attachment">
            <item>
              <FILE_NAME>
                <xsl:value-of select="Attachment/Filename"/>
              </FILE_NAME>
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
        <xsl:value-of select="@partition"/>
      </PARTITION>
      <VARIANT>
        <xsl:value-of select="@variant"/>
      </VARIANT>
      <!--IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    </n0:ARBCIG_STK_RESERVATION>
  </xsl:template>
</xsl:stylesheet>
