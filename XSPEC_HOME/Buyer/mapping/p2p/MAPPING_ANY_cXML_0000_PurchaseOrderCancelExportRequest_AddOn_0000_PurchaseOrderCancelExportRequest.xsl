<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xpath-default-namespace="urn:Ariba:Buyer:vsap"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:n0="urn:sap-com:document:sap:rfc:functions" exclude-result-prefixes="#all">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>         <!--IG-18112:Modified indent option to "no" as per XSLT guidelines-->
  <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>   <!--IG-18112:Added common templates include as per XSLT guidelines-->
  <!--     <xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>         -->  <!--IG-18112:Added line for local testing-->
   <xsl:template match="PurchaseOrderCancelExportRequest">
    <xsl:variable name="v_purHeader" select="ERPOrder_CancelPurchOrdHeader_Item/item"/>    
    <n0:ARBCIG_BAPI_PO_CANCEL>
      <PARTITION>
        <xsl:value-of select="@partition"/>
      </PARTITION>
      <PO_HEADER>
        <PO_NUMBER>
          <xsl:value-of select="$v_purHeader/ERPPONumber"/>
        </PO_NUMBER>
        <ARIBAORDERID>
          <xsl:value-of select="$v_purHeader/UniqueName"/>
        </ARIBAORDERID>
        <VERSION>
          <xsl:value-of select="$v_purHeader/VersionNumber"/>
        </VERSION>
      </PO_HEADER>      
      <VARIANT>
        <xsl:value-of select="@variant"/>
      </VARIANT>
      <PO_ITEMS>
        <xsl:for-each select="$v_purHeader/LineItems/item">
          <xsl:if
            test="(not(Parent) or ((exists(SAPPOLineNumber)) and (exists(Parent)) and ((LineType/Category = '4') or (LineType/Category = '8') or (LineType/Category = '16'))))">       
          <item>
            <PO_ITEM>
              <xsl:value-of select="SAPPOLineNumber"/>
            </PO_ITEM>   
            <DELETE_IND>
              <xsl:value-of select="'L'"/>
            </DELETE_IND>
            <REQ_ID>
              <xsl:value-of select="$v_purHeader/ERPRequisitionID"/>
            </REQ_ID>
          </item>  
          </xsl:if>             
        </xsl:for-each> 
      </PO_ITEMS>      
    </n0:ARBCIG_BAPI_PO_CANCEL>
  </xsl:template>
</xsl:stylesheet>
