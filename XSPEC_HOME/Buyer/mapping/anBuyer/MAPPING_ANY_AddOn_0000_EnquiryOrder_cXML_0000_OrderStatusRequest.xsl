<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <xsl:param name="anIsMultiERP"/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anERPTimeZone"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anTargetDocumentType" select="'OrderRequest'"/>
<!--  <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>  -->
  <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
      <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="v_defaultLang">
    <xsl:call-template name="FillDefaultLang">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_pd" select="$v_pd"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:template match="ARBCIG_ORDENQ/IDOC">
    <xsl:variable name="v_vendor" select="E1EDKA1[PARVW = 'LF']"/>
    <xsl:variable name="v_iddat" select="E1EDK03[IDDAT = 011]"/>
    <xsl:variable name="v_arbaOrdENQHeader" select="E1EDK01/E1ARBCIG_ORDENQHEADER"/>
    <xsl:variable name="v_attach" select="E1EDK01/E1ARBCIG_ATTACH_HDR_DET"/>
    <Combined>
      <Payload>
        <cXML>
          <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
          </xsl:attribute>
          <xsl:attribute name="timestamp">
            <xsl:variable name="curDate">
              <xsl:value-of select="current-dateTime()"/>
            </xsl:variable>
            <xsl:value-of select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"/>
          </xsl:attribute>
          <!-- Header -->
          <Header>
            <From>
              <xsl:call-template name="MultiERPTemplateOut">
                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
              </xsl:call-template>
              <Credential>
                <xsl:attribute name="domain">
                  <xsl:value-of select="'NetworkID'"/>                  
                </xsl:attribute>
                <Identity>
                  <xsl:value-of select="$anSupplierANID"/>
                </Identity>
              </Credential>
              <!--End Point Fix for CIG-->
              <Credential>
                <xsl:attribute name="domain">
                  <xsl:value-of select="'EndPointID'"/>
                </xsl:attribute>
                <Identity>
                  <xsl:value-of select="'CIG'"/>
                </Identity>
              </Credential> 
            </From>
            <To>
              <Credential>
                <xsl:attribute name="domain">
                  <xsl:value-of select="'VendorID'"/>
                </xsl:attribute>
                <xsl:if test="$v_vendor">
                  <Identity>
                    <xsl:value-of select="$v_vendor/PARTN"/>
                  </Identity>
                </xsl:if>
              </Credential>
            </To>
            <Sender>
              <Credential domain="NetworkID">
                <Identity>
                  <xsl:value-of select="$anProviderANID"/>
                </Identity>
              </Credential>
              <UserAgent>
                <xsl:value-of select="'Ariba Supplier'"/>
              </UserAgent>
            </Sender>
          </Header>
          <Request>
            <xsl:choose>
              <xsl:when test="$anEnvName = 'PROD'">
                <xsl:attribute name="deploymentMode">
                  <xsl:value-of select="'production'"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="deploymentMode">
                  <xsl:value-of select="'test'"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <OrderStatusRequest>
              <!-- OrderStatusRequest Header -->
              <OrderStatusRequestHeader>
                <xsl:attribute name="orderStatusRequestID">
                  <xsl:value-of select="E1EDK02[QUALF = 001]/BELNR"/>
                </xsl:attribute>
                <xsl:attribute name="orderStatusRequestDate">
                  <xsl:choose>
                    <xsl:when test="(string-length(normalize-space($v_iddat/DATUM)) > 0)">
                      <xsl:call-template name="ANDateTime">
                        <xsl:with-param name="p_date" select="$v_iddat/DATUM"/>
                        <xsl:with-param name="p_time" select="$v_iddat/UZEIT"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:variable name="v_tm">
                        <xsl:value-of select="current-dateTime()"/>
                      </xsl:variable>
                      <xsl:value-of select="concat(substring($v_tm, 1, 19), $anERPTimeZone)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <OrderIDInfo>
                  <xsl:attribute name="orderID">
                    <xsl:value-of select="E1EDK02[QUALF = 001]/BELNR"/>
                  </xsl:attribute>
                </OrderIDInfo>
                <xsl:if test="$v_vendor">
                  <Contact>
                    <xsl:attribute name="role">                      
                        <xsl:value-of select="'supplierCorporate'"/>
                    </xsl:attribute>
                    <Name>
                      <xsl:choose>
                        <xsl:when test="string-length(normalize-space($v_vendor/BNAME)) = 0">
                          <xsl:call-template name="FillLangOut">
                            <xsl:with-param name="p_spras_iso" select="$v_vendor/SPRAS_ISO"/>
                            <xsl:with-param name="p_spras" select="$v_vendor/SPRAS"/>
                            <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                          </xsl:call-template>
                          <xsl:value-of select="$v_vendor/NAME1"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="FillLangOut">
                            <xsl:with-param name="p_spras_iso" select="$v_vendor/SPRAS_ISO"/>
                            <xsl:with-param name="p_spras" select="$v_vendor/SPRAS"/>
                            <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                          </xsl:call-template>
                          <xsl:value-of select="$v_vendor/BNAME"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </Name>
                    <PostalAddress>
                      <Street>
                        <xsl:value-of select="$v_arbaOrdENQHeader/STREET"/>
                      </Street>
                      <City>
                        <xsl:value-of select="$v_arbaOrdENQHeader/CITY"/>
                      </City>
                      <Municipality>
                        <xsl:value-of select="$v_arbaOrdENQHeader/MUNICIPALITY"/>
                      </Municipality>
                      <State>
                        <xsl:value-of select="$v_arbaOrdENQHeader/STATE"/>
                      </State>
                      <PostalCode>
                        <xsl:value-of select="$v_arbaOrdENQHeader/POSTALCODE"/>
                      </PostalCode>
                      <Country>
                        <xsl:attribute name="isoCountryCode">
                          <xsl:value-of select="$v_arbaOrdENQHeader/COUNTRY"/>
                        </xsl:attribute>
                      </Country>
                    </PostalAddress>
                    <Email>
                      <xsl:value-of select="$v_arbaOrdENQHeader/EMAIL"/>
                    </Email>
                    <Phone>
                      <TelephoneNumber>
                        <CountryCode>
                          <xsl:attribute name="isoCountryCode">
                            <xsl:value-of select="$v_arbaOrdENQHeader/COUNTRY"/>
                          </xsl:attribute>
                        </CountryCode>
                        <AreaOrCityCode/>
                        <Number>
                          <xsl:value-of select="$v_arbaOrdENQHeader/PHONE"/>
                        </Number>
                      </TelephoneNumber>
                    </Phone>
                    <Fax>
                      <xsl:attribute name="name">
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space($v_arbaOrdENQHeader/FAX)) > 0">
                            <xsl:value-of select="'routing'"/>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:attribute>
                      <TelephoneNumber>
                        <CountryCode>
                          <xsl:attribute name="isoCountryCode">
                            <xsl:value-of select="$v_arbaOrdENQHeader/COUNTRY"/>
                          </xsl:attribute>
                        </CountryCode>
                        <AreaOrCityCode/>
                        <Number>
                          <xsl:value-of select="$v_arbaOrdENQHeader/FAX"/>
                        </Number>
                      </TelephoneNumber>
                    </Fax>
                  </Contact>
                </xsl:if>                
                <xsl:variable name="v_att">
                  <xsl:for-each select="$v_attach">
                    <xsl:if test=" normalize-space(LINENUMBER)=''">
                      <xsl:value-of select="'1'"/> 
                    </xsl:if>
                  </xsl:for-each>                   
                </xsl:variable>                 
                <xsl:if test="string-length(normalize-space($v_att))>0">		
                  <Comments>
                    <xsl:call-template name="addContenIdIDOC">
                      <xsl:with-param name="eachAtt" select="$v_attach"/>
                    </xsl:call-template>
                  </Comments>
                </xsl:if>
                <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'AribaNetwork.LegacyDocument'"/>
                  </xsl:attribute>
                  <xsl:value-of select="'true'"/>
                </Extrinsic>
              </OrderStatusRequestHeader>
              <!-- OrderStatusRequest Item -->
              <xsl:for-each select="E1EDP01">
                <xsl:if test="E1ARBCIG_ORDENQDETAIL[MAHNZ != 0]">
                  <OrderStatusRequestItem>
                    <ItemReference>
                      <xsl:attribute name="lineNumber">
                        <xsl:value-of select="POSEX"/>
                      </xsl:attribute>
                      <ItemID>
                        <SupplierPartID>
                          <!-- S4HANA check for IDTNR and IDTNR_LONG -->
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space(E1EDP19[QUALF = 002]/IDTNR_LONG)) > 0">
                              <xsl:value-of select="E1EDP19[QUALF = 002]/IDTNR_LONG"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:choose>
                                <xsl:when test="string-length(normalize-space(E1EDP19[QUALF = 002]/IDTNR)) > 0">
                                  <xsl:value-of select="E1EDP19[QUALF = 002]/IDTNR"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="'Non Catalog Item'"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:otherwise>
                          </xsl:choose>
                        </SupplierPartID>
                        <!-- S4HANA check for IDTNR and IDTNR_LONG -->
                        <xsl:if test="E1EDP19[QUALF = 001]">
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space(E1EDP19[QUALF = 001]/IDTNR_LONG)) > 0">
                              <BuyerPartID>
                                <xsl:value-of select="E1EDP19[QUALF = 001]/IDTNR_LONG"/>
                              </BuyerPartID>
                            </xsl:when>
                            <xsl:otherwise>
                              <BuyerPartID>
                                <xsl:value-of select="E1EDP19[QUALF = 001]/IDTNR"/>
                              </BuyerPartID>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                      </ItemID>
                      <Description>
                        <xsl:call-template name="FillLangOut">
                          <xsl:with-param name="p_spras_iso" select="//E1EDKA1[PARVW = 'AG']/SPRAS_ISO"/>
                          <xsl:with-param name="p_spras" select="//E1EDKA1[PARVW = 'AG']/SPRAS"/>
                          <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                        </xsl:call-template>
                        <xsl:if test="E1EDP19[QUALF = 001]">
                          <xsl:value-of select="E1EDP19[QUALF = 001]/KTEXT"/>
                        </xsl:if>
                      </Description>
                    </ItemReference>
                    <xsl:variable name="v_att_line">
                      <xsl:for-each select="$v_attach[LINENUMBER!='']">                    
                        <xsl:value-of select="'1'"/>                    
                      </xsl:for-each>   
                    </xsl:variable>            
                    <xsl:if test="string-length(normalize-space($v_att_line)) > 0 or E1ARBCIG_ORDENQCOMMENTS[TDLINE!='']">
                      <Comments>
                        <xsl:attribute name="xml:lang">
                          <xsl:value-of select="$v_defaultLang"/>
                        </xsl:attribute>
                        <xsl:call-template name="CommentsFillIDOCOutSplitLine">
                          <xsl:with-param name="p_aribaComment" select="E1ARBCIG_ORDENQCOMMENTS"/>
                          <xsl:with-param name="p_pd" select="$v_pd"/>
                        </xsl:call-template>
                        <xsl:call-template name="addContenIdIDOC">
                          <xsl:with-param name="eachAtt" select="$v_attach"/>
                          <xsl:with-param name="lineNumber" select="POSEX"/>
                        </xsl:call-template>
                      </Comments>
                    </xsl:if>
                  </OrderStatusRequestItem>
                </xsl:if>
              </xsl:for-each>
            </OrderStatusRequest>
          </Request>
        </cXML>
      </Payload>
      <xsl:call-template name="OutBoundAttachIDOC">
        <xsl:with-param name="eachAtt" select="$v_attach"/>
      </xsl:call-template>
    </Combined>
  </xsl:template>
</xsl:stylesheet>
