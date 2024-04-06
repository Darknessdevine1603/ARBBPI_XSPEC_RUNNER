<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <xsl:param name="anIsMultiERP"/>
  <xsl:param name="anERPTimeZone"/>
  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anSourceDocumentType"/>
  <xsl:param name="anTargetDocumentType"/>
  <xsl:param name="anAddOnCIVersion"/>
  <xsl:variable name="v_generalLedger" select="'GeneralLedger'"/>
  <xsl:variable name="v_costCenter" select="'CostCenter'"/>
  <xsl:variable name="v_internalOrder" select="'InternalOrder'"/>
  <xsl:variable name="v_empty" select="''"/>
  <xsl:variable name="v_wbsElement" select="'WBSElement'"/>
  <xsl:variable name="v_asset" select="'Asset'"/>
  <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--  <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
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
  <!-- IG-16312 Begin -->
  <!--   Get the parameter to map the manufacturer name instead of manufacturer id-->
  <xsl:variable name="v_sendmanufacturername">
    <xsl:call-template name="SendManufacturerName"> 
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_pd" select="$v_pd"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- IG-16312 End -->  
  <!-- Root Node changed to DELINS  -->
  <xsl:template match="ARBCIG_DELINS/IDOC">
    <xsl:variable name="v_vendor" select="E1EDK09/E1EDKA1[PARVW = 'LF']"/>
    <xsl:variable name="v_ship" select="E1EDK09/E1EDKA1[PARVW = 'WE']"/>
    <xsl:variable name="v_bill" select="E1EDK09/E1EDKA1[PARVW = 'AG']"/>
    <xsl:variable name="v_k09" select="E1EDK09"/>
    <xsl:variable name="v_p10" select="E1EDK09/E1EDP10"/>
    <xsl:variable name="v_sarHeader" select="E1EDK09/E1ARBCIG_SARHEADER"/>
    <xsl:variable name="v_sarHeader_det" select="E1EDK09/E1ARBCIG_SARHEADER/E1ARBCIG_SARHEADER_DET"/>  <!-- CI-2477 -->    
    <xsl:variable name="v_sarPmntTerms" select="E1EDK09/E1ARBCIG_E1EDK18"/>     
    <xsl:variable name="v_attach" select="E1EDK09/E1ARBCIG_ATTACH_HDR_DET"/>
    <xsl:variable name="v_comments" select="E1EDK09/E1ARBCIG_COMMENT"/>
    <xsl:variable name="v_sloc_level" select="E1EDK09/E1ARBCIG_SARHEADER/SLOC_LEVEL"/>
    <!--    Check CIG Addon Version is 08 or more than that-->
    <xsl:variable name="v_supportsp08onwards">
      <xsl:call-template name="Check_SupportVersion">
        <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
        <xsl:with-param name="p_suppversion" select="'08'"/>
      </xsl:call-template>
    </xsl:variable>     
    <xsl:variable name="var_lgort_header" select="string-join(E1EDK09/E1EDP10/KLGOR)"/>
    <!-- cXML Header -->
    <Combined>
      <Payload>
        <cXML>
          <xsl:choose>
            <xsl:when test="string-length(normalize-space($v_k09/E1ARBCIG_VERSION/PAYLOAD_ID)) > 0">   
              <xsl:attribute name="payloadID">
                <xsl:value-of select="$v_k09/E1ARBCIG_VERSION/PAYLOAD_ID"></xsl:value-of>      
              </xsl:attribute>
            </xsl:when>
              <xsl:otherwise>
          <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
          </xsl:attribute>
          </xsl:otherwise>
          </xsl:choose> 
          <xsl:choose>
            <xsl:when test="string-length(normalize-space($v_k09/E1ARBCIG_VERSION/TIMESTAMP)) > 0">
              <xsl:attribute name="timestamp">
                <xsl:value-of select="$v_k09/E1ARBCIG_VERSION/TIMESTAMP"></xsl:value-of>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
            <xsl:attribute name="timestamp">
              <xsl:variable name="curDate">
                <xsl:value-of select="current-dateTime()"/>
              </xsl:variable>
              <xsl:value-of select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"/>
            </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>            
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
              <xsl:if test="$v_vendor">
                <Correspondent>
                  <Contact>
                    <xsl:attribute name="role">
                      <xsl:value-of select="'correspondent'"/>
                    </xsl:attribute>
                    <Name>
                      <xsl:call-template name="FillLangOut">
                        <xsl:with-param name="p_spras_iso" select="$v_vendor/SPRAS_ISO"/>
                        <xsl:with-param name="p_spras" select="$v_vendor/SPRAS"/>
                        <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                      </xsl:call-template>
                      <xsl:value-of select="$v_vendor/NAME1"/>
                    </Name>
                    <PostalAddress>
                      <Street>
                        <xsl:value-of select="$v_vendor/STRAS"/>
                      </Street>
                      <City>
                        <xsl:value-of select="$v_vendor/ORT01"/>
                      </City>
                      <Country>
                        <xsl:attribute name="isoCountryCode">
                          <xsl:value-of select="$v_vendor/LAND1"/>
                        </xsl:attribute>
                        <xsl:value-of select="$v_vendor/LAND1"/>
                      </Country>
                    </PostalAddress>
                    <Email>
                      <xsl:value-of select="$v_sarHeader/EMAIL"/>
                    </Email>
                    <xsl:if test="string-length(normalize-space($v_sarHeader/FAX)) > 0">
                      <Fax>
                        <xsl:attribute name="name">
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_sarHeader/FAX)) > 0">
                              <xsl:value-of select="'routing'"/>
                            </xsl:when>
                            <xsl:otherwise/>
                          </xsl:choose>
                        </xsl:attribute>
                        <xsl:call-template name="TeleNumber">
                          <xsl:with-param name="p_land1" select="$v_sarHeader/COUNTRY"/>                           <!-- CI-1984 -->  
                          <xsl:with-param name="p_telf" select="$v_sarHeader/FAX"/>
                          <xsl:with-param name="p_telfto" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO"/>       <!-- CI-1984 -->                       
                          <xsl:with-param name="p_tland1" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>     <!-- CI-1984 -->                         
                          <xsl:with-param name="p_telfext" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELFEXT"/>      <!-- IG-30549 -->  
                        </xsl:call-template>
                      </Fax>
                    </xsl:if>
                  </Contact>
                </Correspondent>
              </xsl:if>
            </To>
            <Sender>
              <Credential>
                <xsl:attribute name="domain">
                  <xsl:value-of select="'NetworkID'"/>
                </xsl:attribute>
                <Identity>
                  <xsl:value-of select="$anProviderANID"/>
                </Identity>
              </Credential>
              <UserAgent>
                <xsl:value-of select="'Ariba Supplier'"/>
              </UserAgent>
            </Sender>
            <xsl:if test="E1EDK09/E1EDKA1/E1ARBCIG_PARTNER_INFO[COPY_SUPPL = 'X']">
              <Path>
                <xsl:for-each-group select="E1EDK09/E1EDKA1/E1ARBCIG_PARTNER_INFO[COPY_SUPPL = 'X']" group-by="../PARTN">                     
                  <Node>
                    <xsl:attribute name="type">
                      <xsl:value-of select="'copy'"/>
                    </xsl:attribute>
                    <Credential>
                      <xsl:attribute name="domain">
                        <xsl:value-of select="'VendorID'"/>
                      </xsl:attribute>
                      <Identity>
                        <xsl:value-of select="../PARTN"/>
                      </Identity>
                    </Credential>
                  </Node>                     
                </xsl:for-each-group>
              </Path>
            </xsl:if>
            <xsl:if test="E1EDK09/E1EDKA1/E1ARBCIG_PARTNER_INFO[COPY_SUPPL = 'X']">
              <OriginalDocument>
                <xsl:attribute name="payloadID"/>
              </OriginalDocument>
            </xsl:if>
          </Header>
          <Request>
            <xsl:choose>
              <xsl:when test="$anEnvName = 'PROD'">
                <xsl:attribute name="deploymentMode">
                  <xsl:value-of select="'production'"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="deploymentMode">
                  <xsl:value-of select="'test'"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <OrderRequest>
              <!--ScheduleAgreement Header -->
              <OrderRequestHeader>
                <xsl:attribute name="orderID">                  
                  <xsl:choose>
                    <xsl:when test="$v_sarHeader/NO_RELEASE='X'">
                      <xsl:value-of select="$v_k09/VTRNR"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="$v_sarHeader/HEADER_OUTPUT = 'X' and $v_p10[1]/SCREL = 03">
                          <xsl:value-of select="concat($v_k09/VTRNR, 'FOR')"/>
                        </xsl:when>
                        <xsl:when test="$v_sarHeader/HEADER_OUTPUT = 'X' and $v_p10[1]/SCREL = 02">
                          <xsl:value-of select="concat($v_k09/VTRNR, 'JIT')"/>
                        </xsl:when>
                        <xsl:when test="not($v_sarHeader/HEADER_OUTPUT) and $v_p10[1]/SCREL = 03">
                          <xsl:value-of select="concat($v_k09/VTRNR, $v_p10[1]/POSEX, 'FOR')"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="concat($v_k09/VTRNR, $v_p10[1]/POSEX, 'JIT')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="orderDate">
                  <xsl:choose>
                    <xsl:when test="string-length(normalize-space($v_k09/BSTDK)) > 0">
                      <xsl:call-template name="ANDateTime">
                        <xsl:with-param name="p_date" select="$v_k09/BSTDK"/>
                        <xsl:with-param name="p_time" select="$v_empty"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="ANDateTime">
                        <xsl:with-param name="p_date" select="$v_p10[1]/BSTDK"/>
                        <xsl:with-param name="p_time" select="$v_empty"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$v_sarHeader/NO_RELEASE='X'">
                    <xsl:attribute name="orderType">
                      <xsl:value-of select="'regular'"/>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="orderType">
                      <xsl:value-of select="'release'"/>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>               
                <xsl:attribute name="type">
                  <!-- IG-30433 -->
                  <xsl:choose>                 
                    <xsl:when test="string-length(normalize-space(E1EDK09/E1ARBCIG_VERSION/VERSION)) > 0">
                      <xsl:choose>
                        <xsl:when test="E1EDK09/E1ARBCIG_VERSION/VERSION > 1">
                          <xsl:value-of select="'update'"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="'new'"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="string-length(normalize-space(E1EDK09/ABNRD)) > 0">
                          <xsl:value-of select="'update'"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="'new'"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-- IG-30433 -->
                </xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="string-length(normalize-space($v_k09/E1ARBCIG_VERSION/VERSION)) > 0">
                        <xsl:attribute name="orderVersion">
                          <xsl:value-of select="$v_k09/E1ARBCIG_VERSION/VERSION"></xsl:value-of>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="orderVersion">
                          <xsl:value-of select="$v_k09/LABNK"></xsl:value-of>
                        </xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>                      
                <xsl:attribute name="agreementID">
                  <xsl:value-of select="$v_k09/VTRNR"/>
                </xsl:attribute>
                <xsl:attribute name="effectiveDate">
                  <xsl:call-template name="ANDateTime">
                  <xsl:with-param name="p_date" select="$v_sarHeader/VALIDITY_START_DATE"/>
                  <xsl:with-param name="p_time" select="$v_empty"/>
                  <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="expirationDate">
                  <xsl:call-template name="ANDateTime">
                  <xsl:with-param name="p_date" select="$v_sarHeader/VALIDITY_END_DATE"/>
                  <xsl:with-param name="p_time" select="$v_empty"/>
                  <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                  </xsl:call-template>
                </xsl:attribute>
                <Total>
                  <Money>
                    <xsl:attribute name="currency">
                      <xsl:value-of select="$v_sarHeader/CURRENCY"/>
                    </xsl:attribute>
                    <xsl:value-of select="format-number($v_sarHeader/MONEY, '0.00')"/>
                  </Money>
                </Total>
                <!-- To support storage location feature at header level and handling regression as well -->
                <xsl:if test="($v_ship  and not(exists(E1EDK09/E1ARBCIG_SARHEADER/SLOC_LEVEL))) or ($v_ship and $v_sloc_level = 'H')">
                  <ShipTo>
                    <Address>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$v_ship/LAND1"/>
                      </xsl:attribute>
                      <xsl:attribute name="addressID">
                        <xsl:value-of select="$v_ship/PARTN"/>
                      </xsl:attribute>
                      <xsl:attribute name="addressIDDomain">
                        <xsl:value-of select="'buyerLocationID'"/>
                      </xsl:attribute>
                      <Name>
                        <xsl:call-template name="FillLangOut">
                          <xsl:with-param name="p_spras_iso" select="$v_ship/SPRAS_ISO"/>
                          <xsl:with-param name="p_spras" select="$v_ship/SPRAS"/>
                          <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                        </xsl:call-template>
                        <xsl:value-of select="$v_ship/NAME1"/>
                      </Name>
                      <PostalAddress>
                        <!-- Start of IG-31640 Update Region description -->
                        <xsl:variable name="v_region">
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) > 0">
                              <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$v_ship/REGIO"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <!-- End of IG-31640 Update Region description -->                        
                        <xsl:call-template name="PostalAddress">
                          <xsl:with-param name="p_deliver" select="$v_ship/ABLAD"/>
                          <xsl:with-param name="p_street" select="$v_ship/STRAS"/>
                          <xsl:with-param name="p_city" select="$v_ship/ORT01"/>
                          <xsl:with-param name="p_municipality" select="$v_ship/ORT02"/>
                          <!-- Start of IG-31640 Update Region description -->
                          <!--<xsl:with-param name="p_region" select="$v_ship/REGIO"/>-->
                          <xsl:with-param name="p_region" select="$v_region"/>
                          <!-- End of IG-31640 Update Region description -->                          
                          <xsl:with-param name="p_postalCode" select="$v_ship/PSTLZ"/>
                          <xsl:with-param name="p_isoal" select="$v_ship/ISOAL"/>
                          <xsl:with-param name="p_land1" select="$v_ship/LAND1"/>
                        </xsl:call-template>
                      </PostalAddress>
                      <Email>
                        <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/SMTP_ADDR"/>
                      </Email>
                      <xsl:if test="string-length(normalize-space($v_ship/TELF1)) > 0">
                        <Phone>
                          <xsl:call-template name="TelephoneNumber">
                            <xsl:with-param name="p_isoal" select="$v_ship/ISOAL"/>
                            <xsl:with-param name="p_land1" select="$v_ship/LAND1"/>
                            <xsl:with-param name="p_telf1" select="$v_ship/TELF1"/>
                            <xsl:with-param name="p_telf1Cond" select="$v_ship"/>
                            <xsl:with-param name="p_telextn" select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEXT"/>
                            <!-- CI-1984 -->
                            <xsl:with-param name="p_teland1" select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                            <xsl:with-param name="p_telefto" select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/>                            
                            <!-- CI-1984 -->
                          </xsl:call-template>
                        </Phone>
                      </xsl:if>
                      <xsl:if test="string-length(normalize-space($v_ship/TELFX)) > 0">
                        <Fax>
                          <xsl:call-template name="TelephoneNumber">
                            <xsl:with-param name="p_isoal" select="$v_ship/ISOAL"/>
                            <xsl:with-param name="p_land1" select="$v_ship/LAND1"/>
                            <xsl:with-param name="p_telf1" select="$v_ship/TELFX"/>
                            <xsl:with-param name="p_telf1Cond" select="$v_ship"/>
                            <xsl:with-param name="p_telextn" select="$v_ship/E1ARBCIG_PARTNER_INFO/TELFEXT"/>
                            <!-- CI-1984 -->
                            <xsl:with-param name="p_teland1" select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                            <xsl:with-param name="p_telefto" select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/>                            
                            <!-- CI-1984 -->
                          </xsl:call-template>
                        </Fax>
                      </xsl:if>
                    </Address>
                    <IdReference>
                      <xsl:attribute name="identifier" select="$v_ship/LIFNR"/>
                      <xsl:attribute name="domain" select="'buyerLocationIDDomain'"/>
                    </IdReference>
                    <xsl:if test="$var_lgort_header">
                      <IdReference>
                        <xsl:attribute name="identifier">
                          <xsl:value-of select="substring($var_lgort_header,1,4)"/>
                        </xsl:attribute>
                        <xsl:attribute name="domain">
                          <xsl:value-of select="'storageLocationID'"/>
                        </xsl:attribute>
                      </IdReference>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_p10[1]/E1ARBCIG_SARDETAIL/MRP_AREA)) > 0">
                      <IdReference>
                        <xsl:attribute name="identifier"
                          select="$v_p10[1]/E1ARBCIG_SARDETAIL/MRP_AREA"/>
                        <xsl:attribute name="domain" select="'MRPArea'"/>
                      </IdReference>
                    </xsl:if>                    
                  </ShipTo>
                </xsl:if>
                <xsl:if test="$v_bill">
                  <BillTo>
                    <Address>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$v_sarHeader/COMPANY_COUNTRY"/>
                      </xsl:attribute>
                      <xsl:attribute name="addressID">
                        <xsl:value-of select="$v_sarHeader/BUYER_ACCOUNT_NUMBER"/>                        
                      </xsl:attribute>
                      <xsl:attribute name="addressIDDomain">
                        <xsl:value-of select="'supplierID'"/>
                      </xsl:attribute>
                      <Name>
                        <xsl:call-template name="FillLangOut">
                          <xsl:with-param name="p_spras_iso" select="$v_sarHeader/COMPANY_LANGISO"/>
                          <xsl:with-param name="p_spras" select="$v_sarHeader/COMPANY_LANG"/>
                          <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                        </xsl:call-template>
                        <xsl:value-of select="$v_sarHeader/COMPANY_NAME"/>
                      </Name>
                      <PostalAddress>
                        <!-- Start of IG-32295 Update Region description -->
                        <xsl:variable name="v_bill_region">
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_bill/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) > 0">
                              <xsl:value-of select="$v_bill/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$v_sarHeader/COMPANY_STATE"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <!-- End of IG-32295 Update Region description -->                        
                        <xsl:call-template name="PostalAddress">
                          <xsl:with-param name="p_deliver" select="$v_bill/ABLAD"/>
                          <xsl:with-param name="p_street" select="$v_sarHeader/COMPANY_STREET"/>
                          <xsl:with-param name="p_city" select="$v_sarHeader/COMPANY_CITY"/>
                          <xsl:with-param name="p_municipality" select="$v_empty"/>
                          <!-- Start of IG-32295 Update Region description -->
                          <!--<xsl:with-param name="p_region" select="$v_sarHeader/COMPANY_STATE"/>-->
                          <xsl:with-param name="p_region" select="$v_bill_region"/>
                          <!-- End of IG-32295 Update Region description -->
                          <xsl:with-param name="p_postalCode" select="$v_sarHeader/COMPANY_POSTAL"/>
                          <xsl:with-param name="p_isoal" select="$v_sarHeader/COMPANY_COUNTRY"/>
                          <xsl:with-param name="p_land1" select="$v_empty"/>
                        </xsl:call-template>
                      </PostalAddress>
                      <Email>
                        <xsl:value-of select="$v_sarHeader/COMPANY_EMAIL"/>
                      </Email>
                      <Fax>
                        <!--                        IG-30957-->
                        <xsl:variable name="v_billtofaxnr">
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space($v_bill/E1ARBCIG_PARTNER_INFO/TELFX)) > 0">      
                              <xsl:value-of select="$v_bill/E1ARBCIG_PARTNER_INFO/TELFX"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$v_sarHeader/COMPANY_FAX"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="TeleNumber">
                          <xsl:with-param name="p_land1" select="$v_sarHeader/COMPANY_COUNTRY"/>                     <!-- CI-1984 -->
                          <xsl:with-param name="p_telf" select="$v_billtofaxnr"/>                                    <!-- IG-30549 -->
                          <xsl:with-param name="p_telfto" select="$v_sarHeader/E1ARBCIG_SARHEADER_DET/TELEFTO"/>     <!-- CI-1984 --> 
                          <xsl:with-param name="p_tland1" select="$v_sarHeader/E1ARBCIG_SARHEADER_DET/TEL_LAND1"/>   <!-- CI-1984 -->   
                          <xsl:with-param name="p_telfext" select="$v_bill/E1ARBCIG_PARTNER_INFO/TELFEXT"/>          <!-- IG-30549 -->
                        </xsl:call-template>
                      </Fax>
                    </Address>
                    <xsl:if test="$v_bill/PARTN">
                      <IdReference>
                        <xsl:attribute name="identifier" select="$v_bill/PARTN"/>
                        <xsl:attribute name="domain" select="'supplierID'"/>
                      </IdReference>
                    </xsl:if>
                  </BillTo>
                </xsl:if>
 <!--                CI-1681_SAR Enhancements for soldTo details                --> 
                <BusinessPartner>
                  <xsl:attribute name="type">
                    <xsl:value-of select="'organization'"/>
                  </xsl:attribute>
                  <xsl:attribute name="role">
                    <xsl:value-of select="'soldTo'"/>
                  </xsl:attribute>
                  <Address>
                    <xsl:if test="string-length(normalize-space($v_sarHeader/COMPANY_COUNTRY)) > 0">
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$v_sarHeader/COMPANY_COUNTRY"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space($v_sarHeader/EKORG)) > 0">
                      <xsl:attribute name="addressID">
                        <xsl:value-of select="$v_sarHeader/EKORG"/>                        
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="addressIDDomain">
                      <xsl:value-of select="'buyerAccountID'"/>
                    </xsl:attribute>                    
                    <Name>
                      <xsl:call-template name="FillLangOut">
                        <xsl:with-param name="p_spras_iso" select="$v_sarHeader/COMPANY_LANGISO"/>
                        <xsl:with-param name="p_spras" select="$v_sarHeader/COMPANY_LANG"/>
                        <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                      </xsl:call-template>
                      <xsl:value-of select="$v_sarHeader/COMPANY_NAME"/>
                    </Name>                    
                    <PostalAddress>
                      <!-- Start of IG-32295 Update Region description -->
                      <xsl:variable name="v_SoldTo_region">
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space($v_bill/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) > 0">
                            <xsl:value-of select="$v_bill/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$v_sarHeader/COMPANY_STATE"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <!-- End of IG-32295 Update Region description -->                       
                      <xsl:call-template name="PostalAddress">
                        <xsl:with-param name="p_deliver" select="$v_bill/ABLAD"/>
                        <xsl:with-param name="p_street" select="$v_sarHeader/COMPANY_STREET"/>
                        <xsl:with-param name="p_city" select="$v_sarHeader/COMPANY_CITY"/>
                        <xsl:with-param name="p_municipality" select="$v_empty"/>
                        <!-- Start of IG-32295 Update Region description -->
                        <!--<xsl:with-param name="p_region" select="$v_sarHeader/COMPANY_STATE"/>-->
                        <xsl:with-param name="p_region" select="$v_SoldTo_region"/>
                        <!-- End of IG-32295 Update Region description -->
                        <xsl:with-param name="p_postalCode" select="$v_sarHeader/COMPANY_POSTAL"/>
                        <xsl:with-param name="p_isoal" select="$v_sarHeader/COMPANY_COUNTRY"/>
                        <xsl:with-param name="p_land1" select="$v_empty"/>
                      </xsl:call-template>
                    </PostalAddress>
                    <Email>
                      <xsl:value-of select="$v_sarHeader/COMPANY_EMAIL"/>
                    </Email>
                    <Fax>
                      <!--                        IG-30957-->
                      <xsl:variable name="v_bpfaxnr">
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space($v_bill/E1ARBCIG_PARTNER_INFO/TELFX)) > 0">      
                            <xsl:value-of select="$v_bill/E1ARBCIG_PARTNER_INFO/TELFX"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$v_sarHeader/COMPANY_FAX"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>                      
                      <xsl:call-template name="TeleNumber">
                        <xsl:with-param name="p_land1" select="$v_sarHeader/COMPANY_COUNTRY"/>                     <!-- CI-1984 --> 
                        <xsl:with-param name="p_telf" select="$v_bpfaxnr"/>                                        <!-- IG-30549 -->
                        <xsl:with-param name="p_telfto" select="$v_sarHeader/E1ARBCIG_SARHEADER_DET/TELEFTO"/>     <!-- CI-1984 --> 
                        <xsl:with-param name="p_tland1" select="$v_sarHeader/E1ARBCIG_SARHEADER_DET/TEL_LAND1"/>   <!-- CI-1984 -->                         
                        <xsl:with-param name="p_telfext" select="$v_bill/E1ARBCIG_PARTNER_INFO/TELFEXT"/>          <!-- IG-30549 -->
                      </xsl:call-template> 
                    </Fax>
                  </Address>
                  <xsl:if test="string-length(normalize-space($v_sarHeader/EKORG)) > 0">
                    <IdReference>
                      <xsl:attribute name="identifier" select="$v_sarHeader/EKORG"/>
                      <xsl:attribute name="domain" select="'buyerAccountID'"/>
                    </IdReference>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space($v_bill/E1ARBCIG_PARTNER_INFO/EIKTO)) > 0">
                    <IdReference>
                      <xsl:attribute name="identifier" select="$v_bill/E1ARBCIG_PARTNER_INFO/EIKTO"/>
                      <xsl:attribute name="domain" select="'supplierID'"/>
                    </IdReference>
                  </xsl:if>
                </BusinessPartner>
                
                <!-- Begin of CI-2477 -->
                <!-- Addition of Company code Info -->
                <xsl:if test="string-length(normalize-space($v_sarHeader/BUYER_ACCOUNT_NUMBER)) > 0">  
                  <LegalEntity>
                    <IdReference>
                      <xsl:attribute name="identifier" select="$v_sarHeader/BUYER_ACCOUNT_NUMBER"/>
                      <xsl:attribute name="domain" select="'CompanyCode'"/>
                      <xsl:if test="string-length(normalize-space($v_sarHeader/COMPANY_NAME)) > 0">
                        <Description>
                          <xsl:attribute name="xml:lang">
                            <xsl:call-template name="FillDefaultLang">
                              <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                              <xsl:with-param name="p_pd" select="$v_pd"/>
                            </xsl:call-template>
                          </xsl:attribute>
                          <xsl:value-of select="$v_sarHeader/COMPANY_NAME"/>
                        </Description>
                      </xsl:if>
                    </IdReference>
                  </LegalEntity>                                                     
                </xsl:if>
                
                <!-- Addition of Purchasing Organization info -->
                <xsl:if test="string-length(normalize-space($v_sarHeader/EKORG)) > 0">  
                  <OrganizationalUnit>
                    <IdReference>
                      <xsl:attribute name="identifier" select="$v_sarHeader/EKORG"/>
                      <xsl:attribute name="domain" select="'PurchasingOrganization'"/>
                      <xsl:if test="string-length(normalize-space($v_sarHeader_det/EKORG_NAME)) > 0">
                        <Description>
                          <xsl:attribute name="xml:lang">
                            <xsl:call-template name="FillDefaultLang">
                              <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                              <xsl:with-param name="p_pd" select="$v_pd"/>
                            </xsl:call-template>
                          </xsl:attribute>
                            <xsl:value-of select="$v_sarHeader_det/EKORG_NAME"/>                        
                        </Description>
                      </xsl:if> 
                    </IdReference>
                  </OrganizationalUnit>
                </xsl:if>
                
                <!-- Addition of Purchasing Group info -->
                <xsl:if test="string-length(normalize-space($v_sarHeader/EKGRP)) > 0">  
                  <OrganizationalUnit>
                    <IdReference>
                      <xsl:attribute name="identifier" select="$v_sarHeader/EKGRP"/>
                      <xsl:attribute name="domain" select="'PurchasingGroup'"/>
                      <xsl:if test="string-length(normalize-space($v_sarHeader_det/EKGRP_NAME)) > 0">
                        <Description>
                          <xsl:attribute name="xml:lang">
                            <xsl:call-template name="FillDefaultLang">
                              <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                              <xsl:with-param name="p_pd" select="$v_pd"/>
                            </xsl:call-template>
                          </xsl:attribute>
                            <xsl:value-of select="$v_sarHeader_det/EKGRP_NAME"/>                      
                        </Description>
                      </xsl:if>
                    </IdReference>
                  </OrganizationalUnit>
                </xsl:if>                
                <!-- End of CI-2477 -->
                
 <!-- Begin of Payment Term details -->                 
                <xsl:if test="string-length(normalize-space($v_sarHeader/ZTERM)) > 0">                                
                  <xsl:for-each select="$v_sarPmntTerms">
                    <PaymentTerm>
                      <xsl:attribute name="payInNumberOfDays">
                        <xsl:value-of select="TAGE"/>
                      </xsl:attribute> 
                      <xsl:if test="string-length(normalize-space(PRZNT)) > 0">
                        <Discount>
                          <DiscountPercent>
                            <xsl:attribute name="percent">
                              <xsl:value-of select="PRZNT"/> 
                            </xsl:attribute>    
                          </DiscountPercent>
                        </Discount>  
                      </xsl:if>  
                    </PaymentTerm> 
                  </xsl:for-each>                                                         
                </xsl:if>
<!-- End of Payment Term details -->                
                <xsl:if test="$v_vendor">
                  <Contact>
                    <xsl:attribute name="role">
                      <xsl:value-of select="'supplierCorporate'"/>
                    </xsl:attribute>
                    <xsl:attribute name="addressID">
                      <xsl:value-of select="$v_vendor/PARTN"/>
                    </xsl:attribute>
                    <xsl:attribute name="addressIDDomain">
                      <xsl:value-of select="'buyerID'"/>
                    </xsl:attribute>
                    <Name>                      
                      <xsl:call-template name="FillLangOut">
                        <xsl:with-param name="p_spras_iso" select="$v_vendor/SPRAS_ISO"/>
                        <xsl:with-param name="p_spras" select="$v_vendor/SPRAS"/>
                        <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                      </xsl:call-template>
                        <xsl:value-of select="$v_vendor/NAME1"/>                       
                    </Name>
                    <PostalAddress>
                      <!-- Start of IG-32295 Update Region description -->
                      <xsl:variable name="v_vendor_region">
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) > 0">
                            <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$v_sarHeader/STATE"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <!-- End of IG-32295 Update Region description -->                      
                      <xsl:call-template name="PostalAddress">
                        <xsl:with-param name="p_deliver" select="$v_empty"/>
                        <xsl:with-param name="p_street" select="$v_sarHeader/STREET"/>
                        <xsl:with-param name="p_city" select="$v_sarHeader/CITY"/>
                        <xsl:with-param name="p_municipality" select="$v_sarHeader/MUNICIPALITY"/>
                        <!-- Start of IG-32295 Update Region description -->
                        <!--<xsl:with-param name="p_region" select="$v_sarHeader/STATE"/>-->
                        <xsl:with-param name="p_region" select="$v_vendor_region"/>
                        <!-- End of IG-32295 Update Region description -->                        
                        <xsl:with-param name="p_postalCode" select="$v_sarHeader/POSTAL_CODE"/>
                        <xsl:with-param name="p_isoal" select="$v_sarHeader/COUNTRY"/>
                        <xsl:with-param name="p_land1" select="$v_empty"/>
                      </xsl:call-template>
                    </PostalAddress>
                    <Email>
                      <xsl:value-of select="$v_sarHeader/EMAIL"/>
                    </Email>
                    <Phone>
                      <xsl:call-template name="TeleNumber">
                        <xsl:with-param name="p_land1" select="$v_sarHeader/COUNTRY"/>                            <!-- CI-1984 -->
                        <xsl:with-param name="p_telf" select="$v_sarHeader/PHONE"/>
                        <xsl:with-param name="p_telfto" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO"/>        <!-- CI-1984 --> 
                        <xsl:with-param name="p_tland1" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>      <!-- CI-1984 -->  
                      </xsl:call-template>
                    </Phone>
                    <Fax>
                      <xsl:attribute name="name">
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space($v_sarHeader/FAX)) > 0">routing</xsl:when>
                          <xsl:otherwise/>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:call-template name="TeleNumber">
                        <xsl:with-param name="p_land1" select="$v_sarHeader/COUNTRY"/>                         <!-- CI-1984 -->
                        <xsl:with-param name="p_telf" select="$v_sarHeader/FAX"/>
                        <xsl:with-param name="p_telfto" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO"/>     <!-- CI-1984 --> 
                        <xsl:with-param name="p_tland1" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>   <!-- CI-1984 -->                          
                        <xsl:with-param name="p_telfext" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELFEXT"/>    <!-- IG-30549 -->   
                      </xsl:call-template>
                    </Fax>
                    <IdReference>
                      <xsl:attribute name="domain">
                        <xsl:value-of select="'buyerID'"/>
                      </xsl:attribute>
                      <xsl:attribute name ="identifier">
                        <xsl:value-of select="$v_vendor/PARTN"/>
                      </xsl:attribute>
                    </IdReference>
                    <IdReference>
                      <xsl:attribute name="domain">
                        <xsl:value-of select="'ILN'"/>
                      </xsl:attribute>
                      <xsl:attribute name ="identifier">
                        <xsl:value-of select="$v_vendor/ILNNR"/>
                      </xsl:attribute>
                    </IdReference>
                  </Contact>
                </xsl:if>
                <xsl:if test="$v_vendor and string-length(normalize-space($v_vendor/BNAME)) > 0">
                  <Contact>
                    <xsl:attribute name="role">
                      <xsl:value-of select="'sales'"/>
                    </xsl:attribute>
                    <Name>
                      <xsl:call-template name="FillLangOut">
                        <xsl:with-param name="p_spras_iso" select="$v_vendor/SPRAS_ISO"/>
                        <xsl:with-param name="p_spras" select="$v_vendor/SPRAS"/>
                        <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                      </xsl:call-template>
                      <xsl:value-of select="$v_vendor/BNAME"/>
                    </Name>                                        
                    <Phone>
                      <xsl:call-template name="TeleNumber">
                        <xsl:with-param name="p_land1" select="$v_sarHeader/COUNTRY"/>
                        <xsl:with-param name="p_telf" select="$v_sarHeader/TELF1"/>
                        <xsl:with-param name="p_telfto" select="$v_sarHeader/E1ARBCIG_SARHEADER_DET/TELEFTO"/>     <!-- CI-1984 --> 
                        <xsl:with-param name="p_tland1" select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>       <!-- CI-1984 -->  
                      </xsl:call-template>
                    </Phone>                   
                  </Contact>
                </xsl:if>
                <xsl:variable name="v_att">
                  <xsl:for-each select="$v_attach">
                    <xsl:if test=" normalize-space(LINENUMBER)=''">
                    <xsl:value-of select="'1'"/> 
                    </xsl:if>
                  </xsl:for-each>                   
                </xsl:variable>
                <xsl:variable name="v_comm_hdr">
                  <xsl:for-each select="$v_comments">
                    <xsl:if test=" normalize-space(ITEMNUMBER)=''">
                    <xsl:value-of select="'1'"/>
                    </xsl:if>
                  </xsl:for-each>   
                </xsl:variable>
               <xsl:if test="string-length(normalize-space($v_att))>0 or string-length(normalize-space($v_comm_hdr))>0">
                 <!--  IG-24207 Begin-->
                 <!--<Comments>
                   <xsl:call-template name="CommentsFillIdocOut">
                     <xsl:with-param name="p_aribaComment" select="E1EDK09/E1ARBCIG_COMMENT"/>
                     <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                     <xsl:with-param name="p_pd" select="$v_pd"/>
                   </xsl:call-template>
                   <xsl:call-template name="addContenIdIDOC">
                     <xsl:with-param name="eachAtt" select="$v_attach"/>
                   </xsl:call-template>
                 </Comments>-->
                 <!--  IG-16312 Begin-->
                 <!--  Multiple Comments will now be created as supported in cXML 45 and above --> 
                 <xsl:call-template name="MapMultiple_Text_Comments_IDOC_To_cXML">
                   <xsl:with-param name="p_aribaComment" select="E1EDK09/E1ARBCIG_COMMENT"/>
                   <xsl:with-param name="p_targetdoctype" select="$anTargetDocumentType"/>
                   <xsl:with-param name="p_sourcedoctype" select="$anSourceDocumentType"/>   
                   <xsl:with-param name="p_pd" select="$v_pd"/>
                   <xsl:with-param name="p_attach" select="$v_attach"/>
                   <xsl:with-param name="p_onlyattachnocomments" select="$v_att"/>
                 </xsl:call-template>
                 <!--  IG-16312 End-->
                 <!--  IG-24207 End-->                 
                </xsl:if>
                <!-- Begin of CI-2477 --> 
                <!-- Pass supplier reference document number -->
                <xsl:if test="(string-length(normalize-space($v_vendor/IHREZ))>0)">
                  <SupplierOrderInfo>
                    <xsl:attribute name="orderID">
                      <xsl:value-of select="$v_vendor/IHREZ"/>
                    </xsl:attribute>                              
                  </SupplierOrderInfo>
                </xsl:if> 
                <!-- End of CI-2477 -->                
                <xsl:if test="$v_sarHeader/INCOTERMS">                         
                  <TermsOfDelivery>
                    <TermsOfDeliveryCode>
                      <xsl:attribute name="value">
                        <xsl:value-of select="'TransportCondition'"/>
                      </xsl:attribute>
                    </TermsOfDeliveryCode>
                    <ShippingPaymentMethod>
                      <xsl:attribute name="value">
                        <xsl:value-of select="'Other'"/>
                      </xsl:attribute>
                    </ShippingPaymentMethod>
                    <TransportTerms>
                      <xsl:attribute name="value">
                        <xsl:value-of select="$v_sarHeader/INCOTERMS"/>
                      </xsl:attribute>
                    </TransportTerms>
                    <Address>
                      <Name>
                        <xsl:call-template name="FillLangOut">
                          <xsl:with-param name="p_spras_iso" select="$v_sarHeader/COMPANY_LANGISO"/>
                          <xsl:with-param name="p_spras" select="$v_sarHeader/COMPANY_LANG"/>
                          <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                        </xsl:call-template>
                        <!-- Begin of CI-2477 -->
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space($v_sarHeader_det/INCO2)) > 0"> 
                            <xsl:value-of select="$v_sarHeader_det/INCO2"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$v_sarHeader/INCOTERMS"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <!-- End of CI-2477 -->
                      </Name>
                    </Address>
                  </TermsOfDelivery>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($v_sarHeader/IPO_CNTL)) = 0">                 
                <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'CompanyCode'"/>
                  </xsl:attribute>
                  <!-- IG-30909 Begin-->
                  <xsl:choose>
                    <xsl:when test="string-length(normalize-space($v_sarHeader/BUYER_ACCOUNT_NUMBER)) > 0">
                      <xsl:value-of select="$v_sarHeader/BUYER_ACCOUNT_NUMBER"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="string-length(normalize-space($v_bill/PAORG)) > 0">
                          <xsl:value-of select="$v_bill/PAORG"/>
                        </xsl:when>
                      </xsl:choose>                         
                    </xsl:otherwise>
                  </xsl:choose> 
                  <!-- IG-30909 End-->
                </Extrinsic>  
                  <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'PurchaseGroup'"/>
                  </xsl:attribute>
                  <xsl:value-of select="$v_sarHeader/EKGRP"/>
                  </Extrinsic>
                <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'PurchaseOrganization'"/>
                  </xsl:attribute>
                  <xsl:value-of select="$v_sarHeader/EKORG"/>
                </Extrinsic>     
                <Extrinsic> 
                  <xsl:attribute name="name">
                    <xsl:value-of select="'Requester'"/>
                  </xsl:attribute>
                  <xsl:value-of select="$v_sarHeader/ERNAM"/>
                </Extrinsic>   
                </xsl:if>
                <Extrinsic><xsl:attribute name="name">
                  <xsl:value-of select="'Ariba.invoicingAllowed'"/>
                </xsl:attribute>
                  <xsl:value-of select="'Yes'"/>
                </Extrinsic>
                <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'partyAdditionalID'"/>
                  </xsl:attribute>
                  <xsl:if test="$v_bill">
                    <xsl:value-of select="$v_bill/PARTN"/>
                  </xsl:if>
                </Extrinsic>
                <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'IncoTerms'"/>
                  </xsl:attribute>
                  <xsl:value-of select="$v_sarHeader/INCOTERMS"/>
                </Extrinsic>
<!-- Payment term text details -->                
                <Extrinsic>
                  <xsl:attribute name="name">
                    <xsl:value-of select="'AribaNetwork.PaymentTermsExplanation'"/>
                  </xsl:attribute>
                  <xsl:value-of select="$v_sarPmntTerms/ZTERM_TXT"/>
                </Extrinsic>  
                <!--                CI-1681 -populate buyer vat id-->
                <xsl:if test="string-length(normalize-space($v_sarHeader/E1ARBCIG_SARHEADER_DET/KUNDEUINR)) > 0">
                  <Extrinsic>
                    <xsl:attribute name="name">
                      <xsl:value-of select="'buyerVatID'"/>
                    </xsl:attribute>
                    <xsl:value-of select="$v_sarHeader/E1ARBCIG_SARHEADER_DET/KUNDEUINR"/>
                  </Extrinsic>   
                </xsl:if>                  
              </OrderRequestHeader>
              <!-- ScheduleAgreement ItemOut -->
              <xsl:for-each select="E1EDK09/E1EDP10">
              <!-- IG-24620: Sorted based on posex to send schedule lines in ascending order to AN as currently they are not in order when schedule lines not released in order -->
                <xsl:sort select="POSEX"/> 
                <xsl:variable name="v_item_sloc" select="KLGOR"/>
                <ItemOut>
                  <xsl:variable name="v_quantity">
                    <xsl:choose>
                      <xsl:when test="string-length(normalize-space(AKUBM)) > 0">
                        <xsl:value-of select="AKUBM"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'0.000'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>                   
                  <xsl:attribute name="quantity">
                    <xsl:choose>
                      <xsl:when test="$v_supportsp08onwards = 'true'">  
                        <xsl:value-of select="format-number($v_quantity, '0.000')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space(AKUBM)) > 0">
                            <xsl:value-of select="format-number(AKUBM + AKUEM, '0.000')"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="'0.000'"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="lineNumber">
                    <xsl:value-of select="POSEX"/>
                  </xsl:attribute>
                  <xsl:if test="string-length(normalize-space(E1EDP16[1]/EDATUV)) > 0">
                    <xsl:attribute name="requestedDeliveryDate">
                      <xsl:variable name="v_minDate">
                        <xsl:for-each select="E1EDP16/EDATUV">
                          <xsl:sort select="EDATUV" data-type="text" order="ascending"/>
                          <xsl:if test="position() = 1">
                            <xsl:value-of select="."/>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:variable>
                      <xsl:variable name="v_minTime">
                        <xsl:for-each select="E1EDP16[EDATUV = $v_minDate]/EZEIT">
                          <xsl:sort select="EZEIT" data-type="text" order="ascending"/>
                          <xsl:if test="position() = 1">
                            <xsl:value-of select="."/>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:variable>   
                      <!--Since IDOC is sending EZEIT with only 4 characters, & AN is expecting time in 6 characters,we are conactentaing with 00                        -->			    
                      <xsl:variable name="v_time">
                        <xsl:choose>
                          <xsl:when test="string-length($v_minTime) = 4">
                            <xsl:value-of select="concat($v_minTime,'00')"/>         
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$v_minTime"/>
                          </xsl:otherwise>
                        </xsl:choose> 
                      </xsl:variable>			    
                      <xsl:choose>
                        <xsl:when test="string-length(normalize-space(E1ARBCIG_SARDETAIL/PLANT_TIMEZONE)) > 0">
                          <xsl:call-template name="ANDateTime">
                            <xsl:with-param name="p_date" select="$v_minDate"/>
                            <xsl:with-param name="p_time" select="$v_time"/>
                            <xsl:with-param name="p_timezone"
                              select="E1ARBCIG_SARDETAIL/PLANT_TIMEZONE"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="ANDateTime">
                            <xsl:with-param name="p_date" select="$v_minDate"/>                            
                            <xsl:with-param name="p_time" select="$v_time"/>   
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="itemType">
                    <xsl:value-of select="'item'"/>
                  </xsl:attribute>
                  <xsl:if test="E1ARBCIG_SARDETAIL/PSTYP != '0'">         
                  <xsl:attribute name="itemCategory">
                    <xsl:choose>
                      <xsl:when test="E1ARBCIG_SARDETAIL/PSTYP = '3'">subcontract</xsl:when>
                      <xsl:when test="E1ARBCIG_SARDETAIL/PSTYP = '2'">consignment</xsl:when>
                      <xsl:when test="E1ARBCIG_SARDETAIL/PSTYP = '5'">thirdParty</xsl:when>
                    </xsl:choose>
                  </xsl:attribute>
                  </xsl:if>
                  <!--  IG-24207 Begin-->
                  <!--  IG-16312 Begin-->
                  <!--  Kanban , Unlimited Delivery, Item Change Indicator-->
                  <!--  Reverting Change for Kanban , Unlimited Delivery, Item Change Indicator-->
                  <xsl:if test="E1ARBCIG_SARDETAIL/KANBA = 'X'">
                    <xsl:attribute name="isKanban">
                      <xsl:value-of select="'yes'"/>
                    </xsl:attribute>
                  </xsl:if>
                  <!--  IG-20131 Begin-->
                  <!--  Use string length to check if value exists -->
                  <xsl:if test="string-length(E1ARBCIG_SARDETAIL/UEBTK) > 0">
                    <xsl:attribute name="unlimitedDelivery">
                      <xsl:value-of select="'yes'"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="string-length(E1ARBCIG_SARDETAIL/CHANGE_IND) > 0">
                    <xsl:attribute name="isItemChanged">
                      <xsl:value-of select="'yes'"/>
                    </xsl:attribute>
                  </xsl:if>
                  <!--  IG-20131 End-->
                  <!--  IG-16312 End-->  
                  <!--  IG-24207 End-->
                  <ItemID>
                    <SupplierPartID>
                      <!-- Start of IG-28114 Remove 'Non Catalog Item' hard coding  -->
                      <xsl:if test="string-length(normalize-space(IDNLF)) > 0">
                        <xsl:value-of select="IDNLF"/>
                      </xsl:if>
                      <!-- End of IG-28114 Remove 'Non Catalog Item' hard coding  -->
                    </SupplierPartID>
                    <!-- S4HANA check for IDNKD and IDNKD_EXTERNAL -->
                    <xsl:choose>
                      <xsl:when test="string-length(normalize-space(IDNKD_EXTERNAL)) > 0">
                        <BuyerPartID>
                          <xsl:value-of select="IDNKD_EXTERNAL"/>
                        </BuyerPartID>
                      </xsl:when>
                      <xsl:otherwise>
                        <BuyerPartID>
                          <xsl:value-of select="IDNKD"/>
                        </BuyerPartID>
                      </xsl:otherwise>
                    </xsl:choose>
                  </ItemID>
                  <ItemDetail>
                    <UnitPrice>
                      <Money>
                        <xsl:attribute name="currency">
                          <xsl:value-of select="$v_sarHeader/CURRENCY"/>
                        </xsl:attribute>
                        <!--  examples input and output for v_money
                           input 1.9545 Output 1.95
                           input -1.9545 output -1.95
                           input 0.0000 output 0.00
                           input ' '(blank space) ouput ' '(blank space)
                            -->
                        <xsl:variable name="v_money">                         
                          <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/MONEY)) > 0">                           
                            <xsl:value-of select="format-number(E1ARBCIG_SARDETAIL/MONEY, '0.00')"/> 
                          </xsl:if>    
                        </xsl:variable>  
                        <!-- if v_money is 0.00 then put empty space, else pass value of v_money as it is -->
                        <xsl:choose>
                          <xsl:when test="$v_money = '0.00'">
                            <xsl:value-of select="$v_empty"/> 
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$v_money"/>
                          </xsl:otherwise>
                        </xsl:choose> 
                      </Money>
                    </UnitPrice>
                    <Description>
                      <xsl:call-template name="FillLangOut">
                        <xsl:with-param name="p_spras_iso" select="$v_sarHeader/COMPANY_LANGISO"/>
                        <xsl:with-param name="p_spras" select="$v_sarHeader/COMPANY_LANG"/>
                        <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                      </xsl:call-template>
                      <xsl:value-of select="ARKTX"/>
                    </Description>
                    <UnitOfMeasure>
                      <xsl:call-template name="UOMTemplate_Out">
                        <xsl:with-param name="p_UOMinput" select="VRKME"/>
                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                        <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                      </xsl:call-template>
                    </UnitOfMeasure>
                    <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/PEINH)) > 0 and (format-number(E1ARBCIG_SARDETAIL/PEINH,'0.000') !='0.000')">
                      <PriceBasisQuantity>
                        <xsl:attribute name="quantity">
                          <xsl:value-of select="E1ARBCIG_SARDETAIL/PEINH"/>
                        </xsl:attribute>
                        <xsl:attribute name="conversionFactor">
                          <xsl:value-of select="E1ARBCIG_SARDETAIL/BPUMZ div E1ARBCIG_SARDETAIL/BPUMN"/>
                        </xsl:attribute>
                        <UnitOfMeasure>
                          <xsl:call-template name="UOMTemplate_Out">
                            <xsl:with-param name="p_UOMinput"
                              select="E1ARBCIG_SARDETAIL/PMENE"/>
                            <xsl:with-param name="p_anERPSystemID"
                              select="$anERPSystemID"/>
                            <xsl:with-param name="p_anSupplierANID"
                              select="$anSupplierANID"/>
                          </xsl:call-template>
                        </UnitOfMeasure>
                      </PriceBasisQuantity>
                    </xsl:if>
                    <!--  IG-16312 Begin-->
                    <!--  Material Group will now be sent always with domain ERPCommodityCode -->
                    <!--  Material Group will now be sent always with domain NotAvailable will not be sent -->
                    <!--  Material Group description will now be always with domain ERPCommodityCodeDescription if present -->
                    <Classification>
                      <xsl:attribute name="domain">
                        <xsl:value-of select="'ERPCommodityCode'"/>
                      </xsl:attribute>
                      <xsl:value-of select="E1ARBCIG_SARDETAIL/MATKL"/>
                    </Classification>
                    <!--  IG-20131 Begin-->
                    <!--  Use String length to check if value exists -->
                    <xsl:if test="string-length(E1ARBCIG_SARDETAIL/WGBEZ) > 0">
                      <Classification>
                        <xsl:attribute name="domain">
                          <xsl:value-of select="'ERPCommodityCodeDescription'"/>
                        </xsl:attribute>
                        <xsl:value-of select="E1ARBCIG_SARDETAIL/WGBEZ"/>
                      </Classification>
                    </xsl:if>
                    <!--  IG-20131 End-->                   
                    <!--  IG-16312 End-->
                    <!--CI-1453 Map Product Hierarchy for Purchase Order & SA SAR-->
                    <xsl:for-each select="E1ARBCIG_PROD_HIER">
                      <Classification>
                        <xsl:attribute name="domain">
                          <xsl:value-of select="LEVEL"/>
                        </xsl:attribute>
                        <xsl:value-of select="HIERARCHY"/>
                      </Classification> 
                    </xsl:for-each> 
                    <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/MFRPN)) > 0">
                      <ManufacturerPartID>
                        <xsl:value-of select="E1ARBCIG_SARDETAIL/MFRPN "/>
                      </ManufacturerPartID>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/MFRNR)) > 0">
                      <ManufacturerName>
                        <xsl:attribute name="xml:lang">
                          <xsl:value-of select="$v_defaultLang"/>
                        </xsl:attribute>
                        <!--  IG-16312 Begin-->
                        <!--  send manufacturer name if Cross reference parameter is maintained-->
                        <xsl:choose>
                          <!--  IG-20131 Begin-->
                          <!--  Use String length to check if value exists -->
                          <xsl:when test="string-length($v_sendmanufacturername) > 0">
                            <xsl:value-of select="E1ARBCIG_SARDETAIL/MFRNAME"/>
                          </xsl:when>
                          <!--  IG-20131 End-->                          
                          <xsl:otherwise>
                            <xsl:value-of select="E1ARBCIG_SARDETAIL/MFRNR"/>
                          </xsl:otherwise>
                        </xsl:choose> 
                        <!--  IG-16312 End-->                        
                      </ManufacturerName>
                    </xsl:if>
                    <xsl:if test="E1ARBCIG_SARDETAIL/EAN11">
                      <ItemDetailIndustry>
                        <ItemDetailRetail>
                          <EANID>
                            <xsl:value-of select="E1ARBCIG_SARDETAIL/EAN11"/>
                          </EANID>
                        </ItemDetailRetail>
                      </ItemDetailIndustry>
                    </xsl:if>
                    <Extrinsic>
                      <xsl:attribute name="name">
                        <xsl:value-of select="'AccountCategory'"/>
                      </xsl:attribute>
                      <xsl:value-of select="E1ARBCIG_SARDETAIL/KNTTP"/>
                    </Extrinsic>
                    <Extrinsic>
                      <xsl:attribute name="name">
                        <xsl:value-of select="'ReceivingType'"/>
                      </xsl:attribute>
                      <xsl:value-of select="E1ARBCIG_SARDETAIL/WEBRE"/>
                    </Extrinsic>
                    <xsl:if test="exists(E1ARBCIG_ACCOUNT)and(not( E1ARBCIG_SARDETAIL/PRSDR ='X'))">  
                      <Extrinsic>
                        <xsl:attribute name="name">
                          <xsl:value-of select="'hideUnitPrice'"/>
                        </xsl:attribute>
                      </Extrinsic>
                      <Extrinsic>
                        <xsl:attribute name="name">
                          <xsl:value-of select="'hideAmount'"/>
                        </xsl:attribute>
                      </Extrinsic>                      
                    </xsl:if>
                    <Extrinsic>
                      <xsl:attribute name="name">
                        <xsl:value-of select="'Release Version'"/>
                      </xsl:attribute>
                      <xsl:value-of select="LABNK"/>
                    </Extrinsic>
                  </ItemDetail>
                  <xsl:if test="E1EDPA1[PARVW = 'WE']">
                    <ShipTo>
                      <Address>
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/ISOAL)) > 0">
                            <xsl:attribute name="isoCountryCode">
                              <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ISOAL"/>
                            </xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="isoCountryCode">
                              <xsl:value-of select="E1EDPA1[PARVW = 'WE']/LAND1"/>
                            </xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:attribute name="addressID">
                          <xsl:value-of select="E1EDPA1[PARVW = 'WE']/PARTN"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressIDDomain">
                          <xsl:value-of select="'buyerLocationID'"/>
                        </xsl:attribute>
                        <Name>
                          <xsl:call-template name="FillLangOut">
                            <xsl:with-param name="p_spras_iso"
                              select="E1EDPA1[PARVW = 'WE']/SPRAS_ISO"/>
                            <xsl:with-param name="p_spras" select="E1EDPA1[PARVW = 'WE']/SPRAS"/>
                            <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                          </xsl:call-template>
                          <xsl:value-of select="E1EDPA1[PARVW = 'WE']/NAME1"/>
                        </Name>
                        <PostalAddress>
                          <Street>
                            <xsl:value-of select="E1EDPA1[PARVW = 'WE']/STRAS"/>
                          </Street>
                          <City>
                            <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ORT01"/>
                          </City>
                          <xsl:if test="E1EDPA1[PARVW = 'WE']">
                            <Municipality>
                              <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ORT02"/>
                            </Municipality>
                          </xsl:if>
                          <xsl:choose>
                            <!-- Start of IG-31640 Update Region description -->
                            <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/REGION_DESCRIPTION)) > 0">
                              <State>
                                <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/REGION_DESCRIPTION"/>
                              </State>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:choose>
                                <!-- End of IG-31640 Update Region description -->                            
                            <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/REGIO)) > 0">
                              <State>
                                <xsl:value-of select="E1EDPA1[PARVW = 'WE']/REGIO"/>
                              </State>
                            </xsl:when>
                            <xsl:otherwise>
                              <State/>
                            </xsl:otherwise>
                          </xsl:choose>
                              <!-- Start of IG-31640 Update Region description -->
                            </xsl:otherwise>
                          </xsl:choose>
                          <!-- End of IG-31640 Update Region description -->                              
                          <PostalCode>
                            <xsl:value-of select="E1EDPA1[PARVW = 'WE']/PSTLZ"/>
                          </PostalCode>
                          <Country>
                            <xsl:choose>
                              <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/ISOAL)) > 0">
                                <xsl:attribute name="isoCountryCode">
                                  <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ISOAL"/>
                                </xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:choose>
                                  <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/LAND1)) > 0">
                                    <xsl:attribute name="isoCountryCode">
                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/LAND1"/>
                                    </xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="isoCountryCode">
                                      <xsl:value-of select="$v_empty"/>
                                    </xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:otherwise>
                            </xsl:choose>
                          </Country>
                        </PostalAddress>
                        <xsl:if
                          test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SMTP_ADDR)) > 0">
                          <Email>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'default'"/>
                            </xsl:attribute>
                            <xsl:if
                              test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SPRAS_ISO)) > 0">
                              <xsl:attribute name="preferredLang"
                                select="lower-case(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SPRAS_ISO)"
                              />
                            </xsl:if>
                            <xsl:value-of
                              select="lower-case(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SMTP_ADDR)"
                            />
                          </Email>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/TELF1)) > 0">
                          <Phone>
                            <TelephoneNumber>
                              <CountryCode>
                                <xsl:choose>
                                  <!-- CI-1984 -->
                                  <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1))>0">
                                    <xsl:attribute name="isoCountryCode">
                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1"/>
                                    </xsl:attribute>
                                  </xsl:when> 
                                  <!-- CI-1984 -->
                                  <xsl:when test="E1EDPA1[PARVW = 'WE']/ISOAL">
                                    <xsl:attribute name="isoCountryCode">
                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ISOAL"/>
                                    </xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:choose>
                                      <xsl:when test="E1EDPA1[PARVW = 'WE']/LAND1">
                                        <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="E1EDPA1[PARVW = 'WE']/LAND1"/>
                                        </xsl:attribute>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="$v_empty"/>
                                        </xsl:attribute>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <!-- CI-1984 -->
                                <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO)) > 0">
                                  <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO"/>
                                </xsl:if>
                                <!-- CI-1984 -->
                              </CountryCode>
                              <AreaOrCityCode/>
                              <xsl:if test="E1EDPA1[PARVW = 'WE']">
                                <Number>
                                  <xsl:value-of
                                    select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELF1"/>
                                </Number>
                                <xsl:if
                                  test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEXT)) > 0">
                                  <Extension>
                                    <xsl:value-of
                                      select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEXT"
                                    />
                                  </Extension>
                                </xsl:if>
                              </xsl:if>
                            </TelephoneNumber>
                          </Phone>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/TELFX)) > 0">
                          <Fax>
                            <TelephoneNumber>
                              <CountryCode>
                                <xsl:choose>
                                  <!-- CI-1984 -->
                                  <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1))>0">
                                    <xsl:attribute name="isoCountryCode">
                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1"/>
                                    </xsl:attribute>
                                  </xsl:when> 
                                  <!-- CI-1984 -->
                                  <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/ISOAL)) > 0">
                                    <xsl:attribute name="isoCountryCode">
                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ISOAL"/>
                                    </xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:choose>
                                      <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/LAND1)) > 0">
                                        <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="E1EDPA1[PARVW = 'WE']/LAND1"/>
                                        </xsl:attribute>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="$v_empty"/>
                                        </xsl:attribute>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <!-- CI-1984 -->
                                <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO)) > 0">
                                  <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO"/>
                                </xsl:if>
                                <!-- CI-1984 -->
                              </CountryCode>
                              <AreaOrCityCode/>
                              <xsl:if test="E1EDPA1[PARVW = 'WE']">
                                <Number>
                                  <xsl:value-of
                                    select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFX"/>
                                </Number>
                                <xsl:if
                                  test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFEXT)) > 0">
                                  <Extension>
                                    <xsl:value-of
                                      select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFEXT"
                                    />
                                  </Extension>
                                </xsl:if>
                              </xsl:if>
                            </TelephoneNumber>
                          </Fax>
                        </xsl:if>
                      </Address>
                      <IdReference>
                        <xsl:attribute name="identifier">
                          <xsl:value-of select="E1EDPA1[PARVW = 'WE']/PARTN"/>
                        </xsl:attribute>
                        <xsl:attribute name="domain">
                          <xsl:value-of select="'buyerLocationID'"/>
                        </xsl:attribute>
                      </IdReference>
                      <xsl:if test="exists($v_item_sloc)">
                        <IdReference>
                          <xsl:attribute name="identifier">
                            <xsl:value-of select="$v_item_sloc"/>
                          </xsl:attribute>
                          <xsl:attribute name="domain">
                            <xsl:value-of select="'storageLocationID'"/>
                          </xsl:attribute>
                        </IdReference>
                      </xsl:if>
                    </ShipTo>
                  </xsl:if>  
                  <!-- As part of 2020:06 feature, ship_to will be mapped item level when items are from different storage location -->   
                  <xsl:if test="not(E1EDPA1[PARVW='WE']) and $v_sloc_level = 'L'">
                    <ShipTo>
                      <Address>
                        <xsl:attribute name="isoCountryCode">
                          <xsl:value-of select="$v_ship/LAND1"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressID">
                          <xsl:value-of select="$v_ship/PARTN"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressIDDomain">
                          <xsl:value-of select="'buyerLocationID'"/>
                        </xsl:attribute>
                        <Name>
                          <xsl:call-template name="FillLangOut">
                            <xsl:with-param name="p_spras_iso" select="$v_ship/SPRAS_ISO"/>
                            <xsl:with-param name="p_spras" select="$v_ship/SPRAS"/>
                            <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                          </xsl:call-template>
                          <xsl:value-of select="$v_ship/NAME1"/>
                        </Name>
                        <PostalAddress>
                          <!-- Start of IG-31640 Update Region description -->
                          <xsl:variable name="v_region">
                            <xsl:choose>
                              <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) > 0">
                                <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$v_ship/REGIO"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:variable>
                          <!-- End of IG-31640 Update Region description -->                          
                          <xsl:call-template name="PostalAddress">
                            <xsl:with-param name="p_deliver" select="$v_ship/ABLAD"/>
                            <xsl:with-param name="p_street" select="$v_ship/STRAS"/>
                            <xsl:with-param name="p_city" select="$v_ship/ORT01"/>
                            <xsl:with-param name="p_municipality" select="$v_ship/ORT02"/>
                            <!-- Start of IG-31640 Update Region description -->
                            <!--<xsl:with-param name="p_region" select="$v_ship/REGIO"/>-->
                            <xsl:with-param name="p_region" select="$v_region"/>
                            <!-- End of IG-31640 Update Region description -->
                            <xsl:with-param name="p_postalCode" select="$v_ship/PSTLZ"/>
                            <xsl:with-param name="p_isoal" select="$v_ship/ISOAL"/>
                            <xsl:with-param name="p_land1" select="$v_ship/LAND1"/>
                          </xsl:call-template>
                        </PostalAddress>
                        <Email>
                          <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/SMTP_ADDR"/>
                        </Email>
                        <xsl:if test="string-length(normalize-space($v_ship/TELF1)) > 0">
                          <Phone>
                            <xsl:call-template name="TelephoneNumber">
                              <xsl:with-param name="p_isoal" select="$v_ship/ISOAL"/>
                              <xsl:with-param name="p_land1" select="$v_ship/LAND1"/>
                              <xsl:with-param name="p_telf1" select="$v_ship/TELF1"/>
                              <xsl:with-param name="p_telf1Cond" select="$v_ship"/>
                              <xsl:with-param name="p_telextn"
                                select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEXT"/>
                              <!-- CI-1984 -->
                              <xsl:with-param name="p_teland1" select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                              <xsl:with-param name="p_telefto" select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/>                            
                              <!-- CI-1984 -->
                            </xsl:call-template>
                          </Phone>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space($v_ship/TELFX)) > 0">
                          <Fax>
                            <xsl:call-template name="TelephoneNumber">
                              <xsl:with-param name="p_isoal" select="$v_ship/ISOAL"/>
                              <xsl:with-param name="p_land1" select="$v_ship/LAND1"/>
                              <xsl:with-param name="p_telf1" select="$v_ship/TELFX"/>
                              <xsl:with-param name="p_telf1Cond" select="$v_ship"/>
                              <xsl:with-param name="p_telextn"
                                select="$v_ship/E1ARBCIG_PARTNER_INFO/TELFEXT"/>
                              <!-- CI-1984 -->
                              <xsl:with-param name="p_teland1" select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                              <xsl:with-param name="p_telefto" select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/>                            
                              <!-- CI-1984 -->
                            </xsl:call-template>
                          </Fax>
                        </xsl:if>
                      </Address>
                      <IdReference>
                        <xsl:attribute name="identifier" select="$v_ship/LIFNR"/>
                        <xsl:attribute name="domain" select="'buyerLocationIDDomain'"/>
                      </IdReference>
                      <xsl:if test="string-length(normalize-space($v_item_sloc)) > 0">
                        <IdReference>
                          <xsl:attribute name="identifier">
                            <xsl:value-of select="$v_item_sloc"/>
                          </xsl:attribute>
                          <xsl:attribute name="domain">
                            <xsl:value-of select="'storageLocationID'"/>
                          </xsl:attribute>
                        </IdReference>
                      </xsl:if>
                      <xsl:if test="string-length(normalize-space($v_p10[1]/E1ARBCIG_SARDETAIL/MRP_AREA)) > 0">
                        <IdReference>
                          <xsl:attribute name="identifier"
                            select="$v_p10[1]/E1ARBCIG_SARDETAIL/MRP_AREA"/>
                          <xsl:attribute name="domain" select="'MRPArea'"/>
                        </IdReference>
                      </xsl:if>
                    </ShipTo>
                  </xsl:if>                 
                  <xsl:for-each select="E1ARBCIG_ACCOUNT">                  
                    <xsl:if test="string-length(normalize-space($v_sarHeader/CURRENCY)) > 0 and string-length(normalize-space($v_sarHeader/ACC_CNTL)) = 0">   <!-- IG-31540 -->
                    <Distribution>
                      <Accounting>
                        <xsl:attribute name="name">
                          <xsl:value-of select="'DistributionCharge'"/>
                        </xsl:attribute>
                        <xsl:call-template name="AccountingSegment">
                          <xsl:with-param name="p_id" select="SAKTO"/>
                          <xsl:with-param name="p_name" select="$v_generalLedger"/>
                        </xsl:call-template>
                        <xsl:call-template name="AccountingSegment">
                          <xsl:with-param name="p_id" select="KOSTL"/>
                          <xsl:with-param name="p_name" select="$v_costCenter"/>
                        </xsl:call-template>
                        <xsl:call-template name="AccountingSegment">
                          <xsl:with-param name="p_id" select="AUFNR"/>
                          <xsl:with-param name="p_name" select="$v_internalOrder"/>
                        </xsl:call-template>
                        <xsl:call-template name="AccountingSegment">
                          <xsl:with-param name="p_id" select="PS_PSP_PNR"/>
                          <xsl:with-param name="p_name" select="$v_wbsElement"/>
                        </xsl:call-template>
                        <xsl:call-template name="AccountingSegment">
                          <xsl:with-param name="p_id" select="ANLN1"/>
                          <xsl:with-param name="p_name" select="$v_asset"/>
                        </xsl:call-template>
                        <xsl:if test="string-length(normalize-space(PERCENTAGE)) > 0">
                          <AccountingSegment>
                            <xsl:attribute name="id">
                              <xsl:value-of select="format-number(PERCENTAGE, '0.00')"/>
                            </xsl:attribute>
                            <Name><xsl:attribute name="xml:lang">
                                <xsl:value-of select="$v_defaultLang"/>
                              </xsl:attribute>
                              <xsl:value-of select="'Percentage'"/>
                            </Name>
                            <Description><xsl:attribute name="xml:lang">
                                <xsl:value-of select="$v_defaultLang"/>
                              </xsl:attribute>
                              <xsl:value-of select="'Percentage'"/>
                            </Description>
                          </AccountingSegment>
                        </xsl:if>
                      </Accounting>
                      <Charge>
                        <Money>
                          <xsl:attribute name="currency">
                            <xsl:value-of select="$v_sarHeader/CURRENCY"/>
                          </xsl:attribute>
                          <xsl:value-of select="format-number(MONEY, '0.00')"/>
                        </Money>
                      </Charge>
                    </Distribution>
                        
                        </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/MRP_NAME)) > 0">
                    <Contact>
                      <xsl:attribute name="role">
                        <xsl:value-of select="'BuyerPlannerCode'"/>
                      </xsl:attribute>
                      <Name>
                        <xsl:call-template name="FillLangOut">
                          <xsl:with-param name="p_spras_iso" select="$v_vendor/SPRAS_ISO"/>
                          <xsl:with-param name="p_spras" select="$v_vendor/SPRAS"/>
                          <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                        </xsl:call-template>
                        <xsl:value-of select="E1ARBCIG_SARDETAIL/MRP_NAME"/>     <!-- CI-2477 -->
                      </Name>
                      <IdReference>
                        <xsl:attribute name="identifier">
                          <xsl:value-of select="E1ARBCIG_SARDETAIL/MRP_CNTL"/> 
                        </xsl:attribute>
                        <xsl:attribute name="domain">
                          <xsl:value-of select="'BuyerPlannerCode'"/> 
                        </xsl:attribute>    
                        <Description>
                          <xsl:call-template name="FillLangOut">
                            <xsl:with-param name="p_spras_iso" select="$v_vendor/SPRAS_ISO"/>
                            <xsl:with-param name="p_spras" select="$v_vendor/SPRAS"/>
                            <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                          </xsl:call-template>
                          <xsl:value-of select="E1ARBCIG_SARDETAIL/MRP_NAME"/> 
                        </Description>
                      </IdReference>
                    </Contact>
                  </xsl:if>                              
                  <xsl:if test="E1ARBCIG_SARDETAIL/INCO1">
                    <TermsOfDelivery>
                      <TermsOfDeliveryCode>
                        <xsl:attribute name="value">
                          <xsl:value-of select="'TransportCondition'"/>
                        </xsl:attribute>
                      </TermsOfDeliveryCode>
                      <ShippingPaymentMethod>
                        <xsl:attribute name="value">
                          <xsl:value-of select="'Other'"/>
                        </xsl:attribute>
                      </ShippingPaymentMethod>
                      <TransportTerms>
                        <xsl:attribute name="value">
                          <xsl:value-of select="E1ARBCIG_SARDETAIL/INCO1"/>
                        </xsl:attribute>
                        <xsl:value-of select="E1ARBCIG_SARDETAIL/INCO1_DESC"/>
                      </TransportTerms>
                      <xsl:if test="E1ARBCIG_SARDETAIL/INCO2">
                        <Address>
                          <Name>
                            <xsl:attribute name="xml:lang">
                              <xsl:value-of select="$v_defaultLang"/>
                            </xsl:attribute>
                            <xsl:value-of select="E1ARBCIG_SARDETAIL/INCO2"/>
                          </Name>
                        </Address>
                      </xsl:if>
                    </TermsOfDelivery> 
                  </xsl:if>
                  <xsl:variable name="v_linenumber">
                    <xsl:value-of select="POSEX"/>
                  </xsl:variable>
                  <xsl:variable name="v_att_line">
                    <xsl:for-each select="$v_attach[LINENUMBER = $v_linenumber]">                    
                      <xsl:value-of select="'1'"/>                    
                    </xsl:for-each>   
                  </xsl:variable>
                  <xsl:variable name="v_comm_line">
                    <xsl:for-each select="$v_comments[ITEMNUMBER = $v_linenumber]">          
                      <xsl:value-of select="'1'"/>                    
                    </xsl:for-each>   
                  </xsl:variable>
				  <xsl:if test="string-length(normalize-space($v_att_line))>0 or string-length(normalize-space($v_comm_line))>0">
				    <!--  IG-24207 Begin-->
				    <!--<Comments>
				      <xsl:call-template name="CommentsFillIdocOut">
				        <xsl:with-param name="p_aribaComment" select="../E1ARBCIG_COMMENT"/>
				        <xsl:with-param name="p_itemNumber" select="POSEX"/>
				        <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
				        <xsl:with-param name="p_pd" select="$v_pd"/>
				      </xsl:call-template>
				      <xsl:call-template name="addContenIdIDOC">
				        <xsl:with-param name="eachAtt" select="$v_attach"/>
				        <xsl:with-param name="lineNumber" select="POSEX"/>
				      </xsl:call-template>
				    </Comments>-->
				    <!--  IG-16312 Begin-->
				    <!--  Multiple Comments will now be created as supported in cXML 45 and above -->
				    <xsl:call-template name="MapMultiple_Text_Comments_IDOC_To_cXML">
				      <xsl:with-param name="p_aribaComment" select="../E1ARBCIG_COMMENT"/>
				      <xsl:with-param name="p_itemNumber" select="POSEX"/>
				      <xsl:with-param name="p_targetdoctype" select="$anTargetDocumentType"/>
				      <xsl:with-param name="p_sourcedoctype" select="$anSourceDocumentType"/>   
				      <xsl:with-param name="p_pd" select="$v_pd"/>
				      <xsl:with-param name="p_attach" select="$v_attach"/>
				      <xsl:with-param name="p_onlyattachnocomments" select="$v_att_line"/>
				    </xsl:call-template>	
				    <!--  IG-16312 End-->
				    <!--  IG-24207 End-->
        </xsl:if>
		 <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/UEBTO)) > 0 
		   or string-length(normalize-space(E1ARBCIG_SARDETAIL/PRTLH)) > 0">
                  <Tolerances>
		   <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/UEBTO)) > 0">	  
                     <QuantityTolerance>
                      <Percentage>
                        <xsl:attribute name="percent">
                          <xsl:value-of
                            select="E1ARBCIG_SARDETAIL/UEBTO"/>
                        </xsl:attribute>
                      </Percentage>
                     </QuantityTolerance>
	           </xsl:if>
                   <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/PRTLH)) > 0">
                     <PriceTolerance>
                      <Percentage>
                        <xsl:attribute name="percent">
                          <xsl:value-of
                            select="E1ARBCIG_SARDETAIL/PRTLH"/>
                        </xsl:attribute>
                      </Percentage>
                     </PriceTolerance>
                   </xsl:if>		  
                  </Tolerances>
                 </xsl:if>  			 
                  <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL)) > 0">
                    <ControlKeys>
                      <OCInstruction>
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="E1ARBCIG_SARCONFCTRL/CONF_CTRL = 'A'">
                              <xsl:value-of select="'allowed'"/>
                            </xsl:when>
                            <xsl:when test="E1ARBCIG_SARCONFCTRL/CONF_CTRL = 'R'">
                              <xsl:value-of select="'requiredBeforeASN'"/>
                            </xsl:when>                          
                            <xsl:otherwise>
                              <xsl:value-of select="'notAllowed'"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                       <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_LOW)) > 0
                           or string-length(normalize-space(E1ARBCIG_SARCONFCTRL/TIME_LIMIT_LOW)) > 0">                        
                        <Lower>
                          <Tolerances>
                            <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_LOW)) > 0">
                              <QuantityTolerance>
                                <Percentage>
                                  <xsl:attribute name="percent">
                                    <xsl:value-of select="E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_LOW"/>
                                  </xsl:attribute>                                
                                </Percentage>                              
                              </QuantityTolerance>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/TIME_LIMIT_LOW)) > 0">
                              <TimeTolerance>
                                <xsl:attribute name="limit">
                                  <xsl:value-of select="E1ARBCIG_SARCONFCTRL/TIME_LIMIT_LOW"/>
                                </xsl:attribute>
                                <xsl:attribute name="type">
                                  <xsl:value-of select="E1ARBCIG_SARCONFCTRL/TIME_LIMIT_UNIT"/>
                                </xsl:attribute>
                              </TimeTolerance>
                            </xsl:if>
                          </Tolerances>
                        </Lower>
                       </xsl:if>
                       <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_UP)) > 0
                          or string-length(normalize-space(E1ARBCIG_SARCONFCTRL/TIME_LIMIT_UP)) > 0">
                           <Upper>
                             <Tolerances>
                               <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_UP)) > 0">
                                 <QuantityTolerance>
                                   <Percentage>
                                     <xsl:attribute name="percent">
                                       <xsl:value-of select="E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_UP"/>
                                     </xsl:attribute>   
                                   </Percentage>                             
                                 </QuantityTolerance>
                               </xsl:if>
                               <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/TIME_LIMIT_UP)) > 0">
                                 <TimeTolerance>
                                   <xsl:attribute name="limit">
                                     <xsl:value-of select="E1ARBCIG_SARCONFCTRL/TIME_LIMIT_UP"/>
                                   </xsl:attribute>
                                   <xsl:attribute name="type">
                                     <xsl:value-of select="E1ARBCIG_SARCONFCTRL/TIME_LIMIT_UNIT"/>
                                   </xsl:attribute>
                                 </TimeTolerance>
                               </xsl:if>
                             </Tolerances>
                           </Upper>
                       </xsl:if>
                    </OCInstruction>
                    <ASNInstruction>
                      <xsl:attribute name="value">
                        <xsl:choose>
                          <xsl:when test="E1ARBCIG_SARCONFCTRL/ASN_CTRL = 'A'">
                            <xsl:value-of select="'allowed'"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="'notAllowed'"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_LOW)) > 0
                                  or string-length(normalize-space(E1ARBCIG_SARCONFCTRL/TIME_LIMIT_LOW)) > 0">
                      <Lower>
                        <Tolerances>
                          <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_LOW)) > 0">
                          <QuantityTolerance>
                            <Percentage>
                              <xsl:attribute name="percent">
                                <xsl:value-of select="E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_LOW"/>
                              </xsl:attribute>                              
                            </Percentage>                            
                          </QuantityTolerance>
                          </xsl:if>
                          <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/ASN_TIME_LIMIT_LOW)) > 0">
                          <TimeTolerance>
                            <xsl:attribute name="limit">
                              <xsl:value-of select="E1ARBCIG_SARCONFCTRL/ASN_TIME_LIMIT_LOW"/>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                              <xsl:value-of select="E1ARBCIG_SARCONFCTRL/ASN_TIME_LIMIT_UNIT"/>
                            </xsl:attribute>
                          </TimeTolerance>
                          </xsl:if>
                        </Tolerances>
                      </Lower>
                      </xsl:if>
                      <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_UP)) > 0
                                  or string-length(normalize-space(E1ARBCIG_SARCONFCTRL/ASN_TIME_LIMIT_UP)) > 0">
                          <Upper>
                            <Tolerances>
                              <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_UP)) > 0">
                                <QuantityTolerance>
                                  <Percentage>
                                    <xsl:attribute name="percent">
                                      <xsl:value-of select="E1ARBCIG_SARCONFCTRL/QUAN_LIMIT_UP"/>
                                    </xsl:attribute>                              
                                  </Percentage>                            
                                </QuantityTolerance>
                              </xsl:if>
                              <xsl:if test="string-length(normalize-space(E1ARBCIG_SARCONFCTRL/ASN_TIME_LIMIT_UP)) > 0">
                                <TimeTolerance>
                                  <xsl:attribute name="limit">
                                    <xsl:value-of select="E1ARBCIG_SARCONFCTRL/ASN_TIME_LIMIT_UP"/>
                                  </xsl:attribute>
                                  <xsl:attribute name="type">
                                    <xsl:value-of select="E1ARBCIG_SARCONFCTRL/ASN_TIME_LIMIT_UNIT"/>
                                  </xsl:attribute>   
                                </TimeTolerance>
                              </xsl:if>
                            </Tolerances>
                          </Upper>
                      </xsl:if>
                    </ASNInstruction> 
                    <InvoiceInstruction>
                      <xsl:if test="E1ARBCIG_SARDETAIL/IS_ERS ='X'">
                        <xsl:attribute name="value">
                          <xsl:value-of select="'isERS'"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test="string-length(E1ARBCIG_SARDETAIL/IS_ERS) =0">
                        <xsl:attribute name="value">
                          <xsl:value-of select="'isNotERS'"/>
                        </xsl:attribute>
                      </xsl:if>
                    </InvoiceInstruction>
                    </ControlKeys>
                  </xsl:if>
                  <xsl:for-each select="E1EDP16">
<!--                  Note position for schedule line number population  -->
                    <xsl:variable name="v_pos">
                      <xsl:value-of select="position()"/>
                    </xsl:variable>
                    <ScheduleLine>
                      <xsl:attribute name="quantity">
                        <xsl:value-of select="WMENG"/>
                      </xsl:attribute>
<!-- IG-40002, EZEIT is 4 characters hence attaching 00 to make it 6, Since AN accepts only 6 chars -->                      
                      <xsl:variable name="v_time_s">
                        <xsl:choose>
                          <xsl:when test="string-length(EZEIT) = 4">
                            <xsl:value-of select="concat(EZEIT,'00')"/>         
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="EZEIT"/>
                          </xsl:otherwise>
                        </xsl:choose> 
                      </xsl:variable>	
                      <xsl:attribute name="requestedDeliveryDate">
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space(../E1ARBCIG_SARDETAIL/PLANT_TIMEZONE)) > 0">
                            <xsl:call-template name="ANDateTime">
                              <xsl:with-param name="p_date" select="EDATUV"/>
                              <xsl:with-param name="p_time" select="$v_time_s"/>
                              <xsl:with-param name="p_timezone" select="../E1ARBCIG_SARDETAIL/PLANT_TIMEZONE"/>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="ANDateTime">
                              <xsl:with-param name="p_date" select="EDATUV"/>
                              <xsl:with-param name="p_time" select="$v_time_s"/>
                              <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>                            
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:attribute name="lineNumber">
                        <xsl:value-of select="../E1ARBCIG_SCHED_LINE[position() = $v_pos]/ETENR"/>
                      </xsl:attribute>
                      <UnitOfMeasure>
                        <xsl:call-template name="UOMTemplate_Out">
                          <xsl:with-param name="p_UOMinput" select="../VRKME"/>
                          <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                          <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                        </xsl:call-template>
                      </UnitOfMeasure>					 
                      <ScheduleLineReleaseInfo>
                        <xsl:attribute name="commitmentCode">
                          <xsl:choose>
                            <xsl:when
                              test="(string-length(../ABFDE) = 0) and (string-length(../ABMDE) = 0)"
                              >
                              <xsl:value-of select="'forecast'"/>
                            </xsl:when>
                            <xsl:when test="(EDATUV) &lt;= (../ABFDE)">
                              <xsl:value-of select="'firm'"/>
                            </xsl:when>
                            <xsl:when test="(EDATUV) > (../ABMDE)">
                              <xsl:value-of select="'forecast'"/>
                            </xsl:when>
                            <xsl:when test="((EDATUV) > (../ABFDE)) and string-length(../ABMDE) = 0"
                              >
                              <xsl:value-of select="'forecast'"/>
                            </xsl:when>
                            <xsl:when test="((EDATUV) &lt;= (../ABMDE)) and ((EDATUV) > (../ABFDE))"
                              >
                              <xsl:value-of select="'tradeoff'"/>
                            </xsl:when>
                            <xsl:otherwise/>
                          </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="cumulativeScheduledQuantity">
                          <xsl:value-of select="format-number(FZABR, '0.00')"/>
                        </xsl:attribute>
                        <!-- CI-2878 -->
                        <!-- As part of this feature we are sending the GR quantity against each schedule line -->
                        <xsl:if test="string-length(normalize-space(../E1ARBCIG_SCHED_LINE[position() = $v_pos]/WEMNG)) > 0">
                          <xsl:attribute name="receivedQuantity">
                            <xsl:value-of select="../E1ARBCIG_SCHED_LINE[position() = $v_pos]/WEMNG"/>
                          </xsl:attribute>
                        </xsl:if>
                        <!-- CI-2878 -->
                        <UnitOfMeasure>
                          <xsl:call-template name="UOMTemplate_Out">
                            <xsl:with-param name="p_UOMinput" select="../VRKME"/>
                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                            <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                          </xsl:call-template>
                        </UnitOfMeasure>
                      </ScheduleLineReleaseInfo>	
                      <xsl:variable name="v_count" select="position()"/>
                      <xsl:variable name="v_offset" select="../E1ARBCIG_SARDETAIL/PLANT_TIMEZONE"/>
                      <!-- Begin of IG-42318- Now we are Matching Schedule Line Number with Schedule Line instead of Count and we are reading ETENR based on position-->
                      <xsl:variable name="v_posEtenr" select="../E1ARBCIG_SCHED_LINE[position() = $v_pos]/ETENR"/>
                      <xsl:if test="string-length(normalize-space($v_posEtenr)) > 0">
                        <xsl:for-each select="../E1ARBCIG_SC_COMPONENTS[SCHED_LINE = $v_posEtenr]">
                          <!--End of IG-42318-->
                        <SubcontractingComponent>
                          <xsl:attribute name="quantity">
                            <xsl:choose>
                              <xsl:when test="string-length(normalize-space(ENTRY_QUANTITY)) > 0">
                                <xsl:value-of select="ENTRY_QUANTITY"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="'0.0'"/>
                              </xsl:otherwise>
                            </xsl:choose>                            
                          </xsl:attribute>
                          <xsl:attribute name="requirementDate">
                            <xsl:if test="(string-length(normalize-space(REQ_DATE)) > 0)">
                              <xsl:choose>
                                <xsl:when test="string-length(normalize-space($v_offset)) > 0">
                                  <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="REQ_DATE"/>
                                    <xsl:with-param name="p_time" select="$v_empty"/>
                                    <xsl:with-param name="p_timezone" select="$v_offset"/>
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="REQ_DATE"/>
                                    <xsl:with-param name="p_time" select="$v_empty"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                  </xsl:call-template>                                  
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:if>
                          </xsl:attribute>
                          <ComponentID>
                            <xsl:value-of select="concat(ITEM_NO , '_', SCHED_LINE, '_' , RES_ITEM)"/>                            
                          </ComponentID>
                          <UnitOfMeasure>
                            <xsl:call-template name="UOMTemplate_Out">
                              <xsl:with-param name="p_UOMinput" select="ENTRY_UOM"/>
                              <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                              <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                            </xsl:call-template>
                          </UnitOfMeasure>
                          <Description>
                            <xsl:call-template name="FillLangOut">
                              <xsl:with-param name="p_spras_iso" select="LANGU_ISO"/>
                              <xsl:with-param name="p_spras" select="LANGU"/>
                              <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                            </xsl:call-template>
                            <xsl:value-of select="DESCRIPTION"/>
                          </Description>
                          <xsl:if test="string-length(normalize-space(MATERIAL)) > 0">
                          <Product>
                            <BuyerPartID>
                              <xsl:value-of select="MATERIAL"/>
                            </BuyerPartID>
                          </Product>
                          </xsl:if>
                          <xsl:if test="string-length(normalize-space(BATCH)) > 0">
                          <Batch>
                            <BuyerBatchID>
                              <xsl:value-of select="BATCH"/>
                            </BuyerBatchID>
                          </Batch>
                          </xsl:if>
                        </SubcontractingComponent>
                        </xsl:for-each>
                      </xsl:if>           <!--IG-42318-->
                    </ScheduleLine>
                  </xsl:for-each>
                  <MasterAgreementReference>
                    <xsl:attribute name="agreementID">
                      <xsl:value-of select="$v_k09/VTRNR"/>
                    </xsl:attribute>
                    <xsl:if test="string-length(normalize-space(../BSTDK)) > 0">
                      <xsl:attribute name="agreementDate">
                        <xsl:call-template name="ANDateTime">
                          <xsl:with-param name="p_date" select="../BSTDK"/>
                          <xsl:with-param name="p_time" select="$v_empty"/>
                          <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="agreementType">
                      <xsl:value-of select="'scheduling_agreement'"/>
                    </xsl:attribute>
                    <DocumentReference>
                      <xsl:attribute name="payloadID">
                        <xsl:value-of select="$v_k09/VTRNR"/>
                      </xsl:attribute>
                    </DocumentReference>
                  </MasterAgreementReference>
                  <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/QM_PROCUREMENT_FLAG)) > 0 or string-length(normalize-space(E1ARBCIG_SARDETAIL/XCHPF)) > 0">
                    <ItemOutIndustry>
                      <!--CI-2510-->
                      <xsl:if test="exists(E1ARBCIG_SARDETAIL/QM_PROCUREMENT_FLAG) and E1ARBCIG_SARDETAIL/QM_PROCUREMENT_FLAG = 'X'">                              
                        <QualityInfo>                                 
                          <xsl:attribute name="requiresQualityProcess" select="'yes'"/>                                 
                          <!--controlCode-->
                          <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CNTRL_KEY))>0 and not(string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CERT_FLAG))>0)">
                            <IdReference>
                              <xsl:attribute name="identifier" select="(E1ARBCIG_SARDETAIL[1]/QM_CNTRL_KEY)"/>                  
                              <xsl:attribute name="domain" select="'controlCode'"/>
                            </IdReference>
                          </xsl:if>
                          <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CONTROLKEY))>0 and not(string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CERT_FLAG))>0)">
                            <IdReference>
                              <xsl:attribute name="identifier" select="(E1ARBCIG_SARDETAIL[1]/QM_CONTROLKEY)"/>              
                              <xsl:attribute name="domain" select="'controlCodeDesc'"/>
                            </IdReference>
                          </xsl:if>
                          <!--certificateType-->
                          <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CERTIFICATE_TYPE))>0 and string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CERT_FLAG))>0">
                            <CertificateInfo isRequired="yes">
                              <IdReference>
                                <xsl:attribute name="identifier" select="(E1ARBCIG_SARDETAIL[1]/QM_CERTIFICATE_TYPE)"/>  
                                <xsl:attribute name="domain" select="'certificateType'"/>
                              </IdReference>
                            </CertificateInfo>
                          </xsl:if>
                          <xsl:if test="not(string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CERT_FLAG))>0) and string-length(normalize-space(E1ARBCIG_SARDETAIL[1]/QM_CERTIFICATE_TYPE))>0">
                            <IdReference>
                              <xsl:attribute name="identifier" select="(E1ARBCIG_SARDETAIL[1]/QM_CERTIFICATE_TYPE)"/> 
                              <xsl:attribute name="domain" select="'certificateType'"/>
                            </IdReference>
                          </xsl:if>
                        </QualityInfo>
                      </xsl:if>
                      <!--CI-2510-->
                      <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/XCHPF)) > 0">
                        <BatchInfo>                                 
                          <xsl:attribute name="requiresBatch" select = "'yes'"/>                              
                        </BatchInfo>
                      </xsl:if>
                    </ItemOutIndustry>
                  </xsl:if>               
                  <xsl:if test="string-length(../E1ARBCIG_SARHEADER/NO_RELEASE)=0">
                  <ReleaseInfo>
                    <xsl:attribute name="releaseType">
                      <xsl:choose>
                        <xsl:when test="SCREL = 03">
                          <xsl:value-of select="'forecast'"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="'jit'"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="cumulativeReceivedQuantity">
                      <xsl:value-of select="format-number(AKUEM, '0.000')"/>
                    </xsl:attribute>
                    <xsl:if test="string-length(normalize-space(ABFDE)) > 0">
                      <xsl:attribute name="productionGoAheadEndDate">
                        <xsl:call-template name="ANDateTime">
                          <xsl:with-param name="p_date" select="ABFDE"/>
                          <xsl:with-param name="p_time" select="$v_empty"/>
                          <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="string-length(normalize-space(ABMDE)) > 0">
                      <xsl:attribute name="materialGoAheadEndDate">
                        <xsl:call-template name="ANDateTime">
                          <xsl:with-param name="p_date" select="ABMDE"/>
                          <xsl:with-param name="p_time" select="$v_empty"/>
                          <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                      </xsl:attribute>
                    </xsl:if>
                    <UnitOfMeasure>
                      <xsl:call-template name="UOMTemplate_Out">
                        <xsl:with-param name="p_UOMinput" select="VRKME"/>
                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                        <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                      </xsl:call-template>
                    </UnitOfMeasure>
                    <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/VBELN)) > 0 and string-length(normalize-space(E1ARBCIG_SARDETAIL/MENGE)) > 0">
                      <ShipNoticeReleaseInfo>
                        <xsl:attribute name="receivedQuantity">
                          <xsl:value-of select="format-number(E1ARBCIG_SARDETAIL/MENGE, '0.000')"/>
                        </xsl:attribute>
                        <ShipNoticeIDInfo>
                          <xsl:attribute name="shipNoticeID">
                            <xsl:value-of select="E1ARBCIG_SARDETAIL/VBELN"/>
                          </xsl:attribute>
                          <xsl:if test="string-length(normalize-space(E1ARBCIG_SARDETAIL/ERDAT)) > 0">
                            <xsl:attribute name="shipNoticeDate">
                              <xsl:call-template name="ANDateTime">
                                <xsl:with-param name="p_date" select="E1ARBCIG_SARDETAIL/ERDAT"/>
                                <xsl:with-param name="p_time" select="E1ARBCIG_SARDETAIL/EZEIT"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                              </xsl:call-template>
                            </xsl:attribute>
                          </xsl:if>
                        </ShipNoticeIDInfo>
                        <UnitOfMeasure>
                          <xsl:call-template name="UOMTemplate_Out">
                            <xsl:with-param name="p_UOMinput" select="VRKME"/>
                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                            <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                          </xsl:call-template>
                        </UnitOfMeasure>
                      </ShipNoticeReleaseInfo>
                    </xsl:if>
                  </ReleaseInfo>
                  </xsl:if>
                </ItemOut>
              </xsl:for-each>
            </OrderRequest>
          </Request>
        </cXML>
      </Payload>
      <xsl:call-template name="OutBoundAttachIDOC">
        <xsl:with-param name="eachAtt" select="$v_attach"/>
      </xsl:call-template>
    </Combined>
  </xsl:template>
  <!-- Accounting Segment -->
  <xsl:template name="AccountingSegment">
    <xsl:param name="p_id"/>
    <xsl:param name="p_name"/>
    <xsl:if test="(string-length(normalize-space($p_id)) > 0)">
      <AccountingSegment>
        <xsl:attribute name="id">
          <xsl:value-of select="$p_id"/>
        </xsl:attribute>
        <Name>
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="$v_defaultLang"/>
          </xsl:attribute>
          <xsl:value-of select="$p_name"/>
        </Name>
        <Description><xsl:attribute name="xml:lang">
            <xsl:value-of select="$v_defaultLang"/>
          </xsl:attribute>
          <xsl:value-of select="'ID'"/>
        </Description>
      </AccountingSegment>
    </xsl:if>
  </xsl:template>
  <!-- Postal Address Template -->
  <!-- Map Postal Address details under the different PartnerFunction tags on cXML such as ShipTo , BillTo etc. -->
  <!-- At present , this template is called only under SchedulingAgreement Transaction XSLT only. -->
  <!-- Input parameters for this template -->
  <!--	P_DELIVER 		-	Value to be mapped under <DeliverTo>
		P_STREET		-	Value to be mapped under <Street>
		P_CITY			-	Value to be mapped under <City>
		P_MUNICIPALITY	-	Value to be mapped under <Municipality>
		P_REGION		-	Value to be mapped under <State>
		P_POSTALCODE	-	Value to be mapped under <PostalCode>
		P_ISOA1			-	Value to be mapped under <CountryCode>/@isoCountryCode
		P_LAND1			-	Value to be mapped under <CountryCode/>@isoCountryCode in case P_ISOA1 is blank. 
		Ouput - Following tags are generated.
		<DeliverTo>
		<Street>
		<City>
		<Municipality>
		<State>
		<PostalCode>
		<CountryCode>/@isoCountryCode
		<CountryCode/>@isoCountryCode in case P_ISOA1 is blank -->
  <xsl:template name="PostalAddress">
    <xsl:param name="p_deliver"/>
    <xsl:param name="p_street"/>
    <xsl:param name="p_city"/>
    <xsl:param name="p_municipality"/>
    <xsl:param name="p_region"/>
    <xsl:param name="p_postalCode"/>
    <xsl:param name="p_isoal"/>
    <xsl:param name="p_land1"/>
    <xsl:if test="string-length(normalize-space($p_deliver)) > 0">
      <DeliverTo>
        <xsl:value-of select="$p_deliver"/>
      </DeliverTo>
    </xsl:if>
    <Street>
      <xsl:value-of select="$p_street"/>
    </Street>
    <City>
      <xsl:value-of select="$p_city"/>
    </City>
    <xsl:if test="string-length(normalize-space($p_municipality)) > 0">
      <Municipality>
        <xsl:value-of select="$p_municipality"/>
      </Municipality>
    </xsl:if>
    <State>
      <xsl:value-of select="$p_region"/>
    </State>
    <PostalCode>
      <xsl:value-of select="$p_postalCode"/>
    </PostalCode>
    <Country>
      <xsl:choose>
        <xsl:when test="string-length(normalize-space($p_isoal)) > 0">
          <xsl:attribute name="isoCountryCode">
            <xsl:value-of select="$p_isoal"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="string-length(normalize-space($p_land1)) > 0">
              <xsl:attribute name="isoCountryCode">
                <xsl:value-of select="$p_land1"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="isoCountryCode">
                <xsl:value-of select="$v_empty"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </Country>
  </xsl:template>
  <!-- Telephone Number Template -->
  <!-- Map Postal Address details under the different Contact tags on cXML such as Phone , Fax etc. -->
  <!-- At present , this template is called only under SchedulingAgreement Transaction XSLT only. -->
  <!-- Input parameters for this template
		P_ISOA1			-	Value to be mapped under <TelephoneNumber>/<CountryCode>/@isoCountryCode
		P_LAND1			-	Value to be mapped under <TelephoneNumber>/<CountryCode/>@isoCountryCode in case P_ISOA1 is blank. 
		P_TELF1			-	Value to be mapped under <TelephoneNumber>/<Number>.
		P_TELF1COND		-	Value that determines if P_TELEF1COND and P_TELEXTN can be mapped to <Number> and <Extension> Tags.
		P_TELEXTN		-	Value to be mapped under <TelephoneNumber>/<Extension>. 
		Ouput - Following tags are generated.
		<TelephoneNumber>/CountryCode/@isoCountryCode
		<TelephoneNumber>/CountryCode/<AreaOrCityCode>
		<TelephoneNumber>/<Number>
		<TelephoneNumber>/<Extension>	-->  
  <xsl:template name="TelephoneNumber">
    <xsl:param name="p_isoal"/>
    <xsl:param name="p_land1"/>
    <xsl:param name="p_telf1"/>
    <xsl:param name="p_telf1Cond"/>
    <xsl:param name="p_telextn"/>
    <!-- CI-1984 -->
    <xsl:param name="p_teland1"/>
    <xsl:param name="p_telefto"/>                         
    <!-- CI-1984 -->
    <TelephoneNumber>
      <CountryCode>
        <xsl:choose>
          <!-- CI-1984 -->
          <xsl:when test="string-length(normalize-space($p_teland1)) > 0">
            <xsl:attribute name="isoCountryCode">
              <xsl:value-of select="$p_teland1"/>
            </xsl:attribute>
          </xsl:when>                        
          <!-- CI-1984 -->
          <xsl:when test="string-length(normalize-space($p_isoal)) > 0">
            <xsl:attribute name="isoCountryCode">
              <xsl:value-of select="$p_isoal"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($p_land1)) > 0">
                <xsl:attribute name="isoCountryCode">
                  <xsl:value-of select="$p_land1"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="isoCountryCode">
                  <xsl:value-of select="$v_empty"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
        <!-- CI-1984 -->
        <xsl:if test="string-length(normalize-space($p_telefto))>0">
          <xsl:value-of select="$p_telefto"/>               
        </xsl:if>  
        <!-- CI-1984 -->
      </CountryCode>
      <AreaOrCityCode/>
      <xsl:if test="string-length(normalize-space($p_telf1Cond)) > 0">
        <Number>
          <xsl:value-of select="$p_telf1"/>
        </Number>
        <Extension>
          <xsl:value-of select="$p_telextn"/>
        </Extension>
      </xsl:if>
    </TelephoneNumber>
  </xsl:template>
  <!-- Tele Number Template -->
  <!-- Map Telephone details under the different  tags on cXML such as Phone , Fax etc. -->
  <!-- At present , this template is called only under SchedulingAgreement Transaction XSLT only. -->
  <!-- Input parameters for this template
		P_LAND1			-	Value to be mapped under <TelephoneNumber>/<CountryCode/>@isoCountryCode in case P_ISOA1 is blank. 
		P_TELF1			-	Value to be mapped under <TelephoneNumber>/<Number>.
		Ouput - Following tags are generated.
		<TelephoneNumber>/CountryCode/@isoCountryCode
		<TelephoneNumber>/CountryCode/<AreaOrCityCode>
		<TelephoneNumber>/<Number>	-->  
  <xsl:template name="TeleNumber">
    <xsl:param name="p_land1"/>
    <xsl:param name="p_telf"/>
    <xsl:param name="p_telfto"/>    <!-- CI-1984 --> 
    <xsl:param name="p_tland1"/>    <!-- CI-1984 -->     
    <xsl:param name="p_telfext"/>   <!-- IG-30549 -->
    <TelephoneNumber>
      <CountryCode>
        <xsl:attribute name="isoCountryCode">
          <!-- CI-1984 -->
          <xsl:choose>
            <xsl:when test="string-length(normalize-space($p_tland1)) > 0">
              <xsl:value-of select="$p_tland1"/>            
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$p_land1"/>              
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="string-length(normalize-space($p_telfto))>0">
          <xsl:value-of select="$p_telfto"/>               
        </xsl:if>  
        <!-- CI-1984 -->
      </CountryCode>
      <AreaOrCityCode>
        <xsl:value-of select="$v_empty"/>
      </AreaOrCityCode>
      <Number>
        <xsl:value-of select="$p_telf"/>
      </Number>
      <!-- Begin IG-30549 -->
      <xsl:if test="string-length(normalize-space($p_telfext))>0">
        <Extension>
          <xsl:value-of select="$p_telfext"/> 
        </Extension>
      </xsl:if>
      <!-- End IG-30549 -->
    </TelephoneNumber>
  </xsl:template>
</xsl:stylesheet>
