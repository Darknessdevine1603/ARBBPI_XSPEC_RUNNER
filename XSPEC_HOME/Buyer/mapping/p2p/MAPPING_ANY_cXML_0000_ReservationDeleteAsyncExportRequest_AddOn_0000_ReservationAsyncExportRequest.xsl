<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xpath-default-namespace="urn:Ariba:Buyer:vsap"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="urn:sap-com:document:sap:rfc:functions"
  exclude-result-prefixes="#all">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>                                                                   <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
  <xsl:include href="../../../common/FORMAT_Apps_0000_AddOn_0000.xsl"/>
  <!--<xsl:include href="FORMAT_Apps_0000_AddOn_0000.xsl"/>-->
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anSenderID1"/>
  <xsl:param name="anSourceDocumentType"/>
  <xsl:param name="attachSeparator" select="'\|'"/>
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
      <xsl:with-param name="p_ansupplierid" select="$anSenderID1"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:template match="ReservationDeleteAsyncExportRequest">
    <xsl:variable name="v_resDelHeader"
      select="Reservation_ReservationDeleteHeaderDetails_Item/item"/>
    <xsl:variable name="v_resDelLineDetail"
      select="Reservation_ReservationDeleteLineDetails_Item/item/LineItems/item"/>
    <xsl:variable name="v_resNo" select="$v_resDelHeader/ErpReservationNumber"/>
    <n0:ARBCIG_STK_RESERVATION>
      <ITEM>
        <xsl:for-each select="$v_resDelLineDetail">
          <item>
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <ARIBA_ITEM>
              <xsl:value-of select="NumberInCollection"/>
            </ARIBA_ITEM>
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <RESERV_NO>
              <xsl:value-of select="$v_resNo"/>
            </RESERV_NO>
            <RES_ITEM>
              <xsl:value-of select="ErpLineNumber"/>
            </RES_ITEM>
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <STATUS_IND>
              <xsl:value-of select="Action"/>
            </STATUS_IND>            
            <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
            <DELETE_IND>
              <xsl:value-of select="'X'"/>
            </DELETE_IND>
          </item>
        </xsl:for-each>
      </ITEM>
      <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
      <!-- Reservation Header level Details Mapping -->
      <ARIBA_DOC_NO>
        <xsl:value-of select="$v_resDelHeader/UniqueName"/>
      </ARIBA_DOC_NO>
      <!-- Reservation item level Details Mapping -->      
      <PARTITION>
        <xsl:value-of select="@partition"/>
      </PARTITION>
      <VARIANT>
        <xsl:value-of select="@variant"/>
      </VARIANT>      
      <!-- IG-18112: Apps XSLT improvements & Mapping tool creates duplicate extension segments in output -->
    </n0:ARBCIG_STK_RESERVATION>
  </xsl:template>
</xsl:stylesheet>
