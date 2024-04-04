<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                exclude-result-prefixes="#all">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
   <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--   <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
   <xsl:param name="anIsMultiERP"/>
   <xsl:param name="anERPTimeZone"/>      
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anERPSystemID"/>
   <xsl:param name="anTargetDocumentType"/>
   <xsl:param name="anSourceDocumentType"/>   
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anEnvName"/> 
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

   <!--IG-16312 Begin -->
   <!--   Get the parameter to map the manufacturer name instead of manufacturer id-->
   <xsl:variable name="v_sendmanufacturername">
      <xsl:call-template name="SendManufacturerName">
         <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
         <xsl:with-param name="p_pd" select="$v_pd"/>
      </xsl:call-template>
   </xsl:variable>
   <!--IG-16312 End --> 
   <!--  Begin of IG-30341 -->
   <!--  Get the supplier part id from Parameters in CIG -->
   <xsl:variable name="v_defaultSupplierPartID">
      <xsl:call-template name="defaultSupplierPartID">
         <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
         <xsl:with-param name="p_pd" select="$v_pd"/>
      </xsl:call-template>
   </xsl:variable>
   <!--  End of IG-30341  -->
   <xsl:template match="ARBCIG_ORDERS/IDOC">
      <xsl:variable name="v_vendor" select="E1EDKA1[PARVW = 'LF']"/>
      <xsl:variable name="v_ship" select="E1EDKA1[PARVW = 'WE']"/>
      <xsl:variable name="v_bill" select="E1EDKA1[PARVW = 'AG']"/>
      <xsl:variable name="v_uzeit_sc" select="E1EDK03[IDDAT='012']/UZEIT"/>
      <xsl:variable name="v_parvw"
                    select="E1EDKA1/E1ARBCIG_PARTNER_INFO/COPY_SUPPL"/>
      <xsl:variable name="v_deliverTo"
                    select="E1EDKA1/E1ARBCIG_PARTNER_INFO/DELIVER_TO"/>
      <xsl:variable name="v_k03" select="E1EDK03[IDDAT = '012']"/>
      <xsl:variable name="v_empty" select="''"/>
      <xsl:variable name="v_id" select="'ID'"/>
      <xsl:variable name="v_attach" select="E1EDK01/E1ARBCIG_ATTACH_HDR_DET"/>
      <xsl:variable name="v_ver" select="normalize-space(E1EDK01/E1ARBCIG_HDR/VERSION)"/>
      <xsl:variable name="v_version" select="normalize-space(E1EDK01/E1ARBCIG_VERSION/VERSION)"/> 
      <xsl:variable name="v_acc" select="normalize-space(E1EDK01/E1ARBCIG_HDR/ACC_CNTL)"/>
      <xsl:variable name="v_ipo" select="normalize-space(E1EDK01/E1ARBCIG_HDR/IPO_CNTL)"/>      
      <xsl:variable name="v_doctype" select="E1EDK01/BSART"/>
      <xsl:variable name="v_ernam" select="E1EDK01/E1ARBCIG_HDR/ERNAM"/>
      <xsl:variable name="v_desc" select="E1EDK01/E1ARBCIG_HDR/BATXT"/>
      <xsl:variable name="v_sloc_level" select="E1EDK01/E1ARBCIG_HDR/SLOC_LEVEL"/>
      <!-- IG-38941 Concatinating Special Characters($@#%!_) and substring before it to support scenario like few item without storage location -->
      <!-- and rest have same storage location(SLOC_LEVEL = 'H') and may have string length less than 4 -->
      <!-- Example Item 1 and 4 LGORT is empty and Item 2 and 3 having LGORT as 'CD' -->
      <!-- Even this logic will works for special char storage location like 'ABC$' or '$@#%' which tested via UT -->
      <xsl:variable name="v_lgort_header_temp">
         <xsl:for-each select="E1EDP01">
            <xsl:if test="string-length(LGORT)>0">
               <xsl:value-of select="concat(LGORT,'$@#%!_')"/>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="v_lgort_header" select="substring-before($v_lgort_header_temp,'$@#%!_')"/>
      <!-- IG-38941 -->
      <xsl:variable name="v_business_partner" select="E1EDKA1[PARVW = 'LF']/E1ARBCIG_PLANT_INFO"/>     <!-- CI-1761 To map business partner detail-->
      <Combined>
         <Payload>
            <cXML>
               <xsl:choose>
                  <xsl:when test="string-length(normalize-space(E1EDK01/E1ARBCIG_VERSION/PAYLOAD_ID)) > 0">   
                     <xsl:attribute name="payloadID">
                        <xsl:value-of select="E1EDK01/E1ARBCIG_VERSION/PAYLOAD_ID"></xsl:value-of>      
                     </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:attribute name="payloadID">
                        <xsl:value-of select="$anPayloadID"/>
                     </xsl:attribute>
                  </xsl:otherwise>
               </xsl:choose>                
               <xsl:choose>
                  <xsl:when test="string-length(normalize-space(E1EDK01/E1ARBCIG_VERSION/TIMESTAMP)) > 0">
                     <xsl:attribute name="timestamp">
                        <xsl:value-of select="E1EDK01/E1ARBCIG_VERSION/TIMESTAMP"></xsl:value-of>
                     </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:attribute name="timestamp">
                        <xsl:variable name="v_curdate">
                           <xsl:value-of select="current-dateTime()"/>
                        </xsl:variable>
                        <xsl:value-of select="concat(substring($v_curdate, 1, 19), substring($v_curdate, 24, 29))"/>
                     </xsl:attribute>
                  </xsl:otherwise>
               </xsl:choose>                
               <Header>
                  <From>
                     <xsl:call-template name="MultiERPTemplateOut">
                        <xsl:with-param name="p_anIsMultiERP"
                                        select="$anIsMultiERP"/>
                        <xsl:with-param name="p_anERPSystemID"
                                        select="$anERPSystemID"/>
                     </xsl:call-template>
                     <Credential>
                        <xsl:attribute name="domain">
                           <xsl:value-of select="'NetworkID'"/></xsl:attribute>
                        <Identity>
                           <xsl:value-of select="$anSupplierANID"/>
                        </Identity>
                     </Credential>
                     <!--End Point Fix for CIG-->
                     <Credential>
                        <xsl:attribute name="domain">
                           <xsl:value-of select="'EndPointID'"/>
                        </xsl:attribute>
                        <Identity>CIG</Identity>
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
                                    <xsl:with-param name="p_spras_iso"
                                                    select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS_ISO"/>
                                    <xsl:with-param name="p_spras"
                                                    select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS"/>
                                    <xsl:with-param name="p_lang"
                                       select="$v_defaultLang"/>
                                 </xsl:call-template>
                                 <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/NAME1"/>
                              </Name>
                              <PostalAddress>
                                 <Street>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/STRAS"/>
                                 </Street>
                                 <City>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/ORT01"/>
                                 </City>
                                 <Country>
                                    <xsl:attribute name="isoCountryCode">
                                       <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/LAND1"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/LANDX50"/>
                                 </Country>
                              </PostalAddress>
                              <!-- Defect fix IG-32258, remove if clause -->
                              <Email>
                                 <xsl:choose>
                                    <xsl:when test="($v_vendor/E1ARBCIG_PARTNER_INFO/SMTP_ADDR != '')">
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'routing'"/>
                                       </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="$v_empty"/>
                                       </xsl:attribute>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/SMTP_ADDR"/>
                              </Email>
                                 
                              <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELFX))>0">
                                 <Fax>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/SMTP_ADDR))=0">
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'routing'"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="$v_empty"/>
                                          </xsl:attribute>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <!-- CI-1984 -->                                          
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                   <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                                </xsl:when>                                        
                                                <xsl:otherwise>
                                                   <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/LAND1"/>
                                                </xsl:otherwise>
                                             </xsl:choose>   
                                          </xsl:attribute>
                                          <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                             <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO"/> 
                                          </xsl:if>
                                          <!-- CI-1984 -->  
                                       </CountryCode>
                                       <AreaOrCityCode>
                                          <xsl:value-of select="$v_empty"/>
                                       </AreaOrCityCode>
                                       <Number>
                                          <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELFX"/>
                                       </Number>
                                       <!-- IG-30548 --> 
                                       <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELFEXT)) > 0">
                                          <Extension>
                                             <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELFEXT"/>
                                          </Extension>
                                       </xsl:if>  
                                       <!-- IG-30548 --> 
                                    </TelephoneNumber>
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
                  <xsl:if test="E1EDKA1/E1ARBCIG_PARTNER_INFO[COPY_SUPPL = 'X']">
                  <Path>
                     <xsl:for-each-group select="E1EDKA1/E1ARBCIG_PARTNER_INFO[COPY_SUPPL = 'X']" group-by="../PARTN">                     
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
                  <xsl:if test="E1EDKA1/E1ARBCIG_PARTNER_INFO[COPY_SUPPL = 'X']">
                     <OriginalDocument>
                        <xsl:attribute name="payloadID"/>
                     </OriginalDocument>
                  </xsl:if>
               </Header>
               <Request>
                  <xsl:choose>
                     <xsl:when test="$anEnvName='PROD'">
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
                     <OrderRequestHeader>
                        <xsl:attribute name="orderID">
                           <xsl:value-of select="E1EDK01/BELNR"/>
                        </xsl:attribute>
                        <xsl:attribute name="orderDate">
                           <xsl:variable name="v_uzeit_orddate">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space($v_k03/UZEIT))>0">
                                    <xsl:value-of select="$v_k03/UZEIT"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="'120000'"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:choose>
                              <xsl:when test="(string-length($v_k03/DATUM) > 0)">
                                 <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date"
                                                    select="$v_k03/DATUM"/>
                                    <xsl:with-param name="p_time"
                                       select="$v_uzeit_orddate"/>
                                    <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                 </xsl:call-template>
                              </xsl:when>                              
                           </xsl:choose>
                        </xsl:attribute>
<!--                    Variable v_version holds version information from ERP table 'ARBCIG_ANPO_VERS',pass this to orderversion if this exist -->
                        <xsl:choose>
                           <xsl:when test="string-length($v_version) > 0">
                              <xsl:attribute name="orderVersion">
                                 <xsl:value-of select="$v_version"></xsl:value-of>
                              </xsl:attribute>
                           </xsl:when>       
                           <xsl:otherwise>
 <!--                    Variable v_ver holds version information from PO if version management is active in ERP' -->                              
                              <xsl:if test="$v_ver != ''">
                                 <xsl:attribute name="orderVersion">
                                    <xsl:value-of select="$v_ver"/>
                                 </xsl:attribute>
                              </xsl:if>
                           </xsl:otherwise>
                        </xsl:choose>
                        <!--IG-36467- PO Improvements-->                        
                        <xsl:variable name="v_blanket">
                           <xsl:choose>
                              <xsl:when test="(E1EDP01[PSTYP !='1']/PSTYP[normalize-space()][1]) or string-length((E1EDP01/PSTYP[normalize-space()])[1]) = 0">
                                 <xsl:value-of select="0"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="1"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                           <xsl:when test="$v_blanket = 1">
                        <!--IG-36467- PO Improvements-->
                              <xsl:attribute name="orderType">
                                 
                                    <xsl:value-of select="'blanket'"/>
                                 
                              </xsl:attribute>
                           </xsl:when>
                           <!-- Map ordertype as "stockTransport" for STO Orders -->         
                           <xsl:when test="string-length(normalize-space(E1EDK01/E1ARBCIG_HDR/STO_TYPE))>0">
                              <xsl:attribute name="orderType">
                                 
                                    <xsl:value-of select="'stockTransport'"/>
                                 
                              </xsl:attribute>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:attribute name="orderType">
                                
                                    <xsl:value-of select="'regular'"/>
                                 
                              </xsl:attribute>
                           </xsl:otherwise>
                        </xsl:choose>
                        <xsl:variable name="v_action">
                           <xsl:value-of select="E1EDK01/ACTION"/>
                        </xsl:variable>
                        <xsl:if test="$v_action = '01'">
                           <xsl:attribute name="type">
                              <xsl:value-of select="'new'"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$v_action = '02'">
                           <xsl:attribute name="type">
                              <xsl:value-of select="'update'"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$v_action = '03'">
                           <xsl:attribute name="type">
                              <xsl:value-of select="'delete'"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="E1EDK03[IDDAT = '019']">
                           <xsl:attribute name="effectiveDate">
                              <xsl:variable name="v_uzeit_effdate">
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1EDK03[IDDAT = '019']/UZEIT))>0">
                                       <xsl:value-of select="E1EDK03[IDDAT = '019']/UZEIT"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="'120000'"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:variable>
                              <xsl:call-template name="ANDateTime">
                                 <xsl:with-param name="p_date"
                                                 select="E1EDK03[IDDAT = '019']/DATUM"/>
                                 <xsl:with-param name="p_time"
                                                 select="$v_uzeit_effdate"/>
                                 <xsl:with-param name="p_timezone"
                                                 select="$anERPTimeZone"/>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="E1EDK03[IDDAT = '020']">
                           <xsl:attribute name="expirationDate">
                              <xsl:variable name="v_uzeit_expdate">
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1EDK03[IDDAT = '020']/UZEIT))>0">
                                       <xsl:value-of select="E1EDK03[IDDAT = '020']/UZEIT"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="'120000'"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:variable>
                              <xsl:call-template name="ANDateTime">
                                 <xsl:with-param name="p_date"
                                                 select="E1EDK03[IDDAT = '020']/DATUM"/>
                                 <xsl:with-param name="p_time"
                                                 select="$v_uzeit_expdate"/>
                                 <xsl:with-param name="p_timezone"
                                                 select="$anERPTimeZone"/>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="E1EDK02[QUALF = '005']">
                           <xsl:attribute name="agreementID">
                              <xsl:value-of select="E1EDK02[QUALF = '005']/BELNR"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="E1EDK03[IDDAT = '040']">
                           <xsl:variable name="v_uzeit">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(E1EDK03[IDDAT = '040']/UZEIT))>0">
                                    <xsl:value-of select="E1EDK03[IDDAT = '040']/UZEIT"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="'000000'"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <xsl:attribute name="pickUpDate">
                              <xsl:if test="(string-length(E1EDK03[IDDAT = '040']/DATUM) > 0)">
                                 <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date"
                                                    select="E1EDK03[IDDAT = '040']/DATUM"/>
                                    <xsl:with-param name="p_time"
                                                    select="$v_uzeit"/>
                                    <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                 </xsl:call-template>
                              </xsl:if>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:variable name="v_uzeit_hdr">
                           <xsl:choose>
                              <xsl:when test="string-length(normalize-space(E1EDK03[IDDAT = '002']/UZEIT))>0">
                                 <xsl:value-of select="E1EDK03[IDDAT = '002']/UZEIT"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="'120000'"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="E1EDK03[IDDAT = '002']">
                           <xsl:attribute name="requestedDeliveryDate">
                              <xsl:if test="(string-length(E1EDK03[IDDAT = '002']/DATUM) > 0)">
                                 <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date"
                                                    select="E1EDK03[IDDAT = '002']/DATUM"/>
                                    <xsl:with-param name="p_time"
                                       select="$v_uzeit_hdr"/>
                                    <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                 </xsl:call-template>
                              </xsl:if>
                           </xsl:attribute>
                        </xsl:if>
                        <!-- CI-1761 STO Outbound -->
                        <xsl:if test="string-length(normalize-space(E1EDK01/E1ARBCIG_HDR/STO_OUTBOUND))>0">
                           <xsl:attribute name="isSTOOutbound">
                              <xsl:value-of select="'yes'"/>
                           </xsl:attribute>
                        </xsl:if>  
                        <!-- CI-1761 -->
                        <xsl:variable name="v_sum">
                           <xsl:for-each select="E1EDP01">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(VPREI))>0">
                                    <value>
                                       <xsl:choose>
                                          <xsl:when test="ACTION = '093'">
                                             <xsl:variable name="v_net_value_93">
                                                <xsl:value-of select="(-1) * (((((VPREI) div (PEINH)) * (BPUMZ)) div (BPUMN)) * (MENGE))"/>
                                             </xsl:variable>
                                             <xsl:value-of select="format-number(round(100 * $v_net_value_93) div 100, '0.00')"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:variable name="v_net_value">
                                                <xsl:value-of select="(((((VPREI) div (PEINH)) * (BPUMZ)) div (BPUMN)) * (MENGE))"/>
                                             </xsl:variable>
                                             <xsl:value-of select="format-number(round(100 * $v_net_value) div 100, '0.00')"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </value>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="'0.00'"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:for-each>
                        </xsl:variable>
                        <Total>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="E1EDK01/CURCY"/>
                              </xsl:attribute>
                              <xsl:variable name="v_money">
                                 <xsl:value-of select="sum($v_sum/value)"/>
                              </xsl:variable>
                              <xsl:value-of select="format-number(round(100 * $v_money) div 100, '0.00')"/>
                           </Money>
                        </Total>
                        <!-- To support storage location feature at header level and handling regression as well -->
                        <xsl:if test="($v_ship and not(exists(E1EDK01/E1ARBCIG_HDR/SLOC_LEVEL))) or ($v_ship and $v_sloc_level = 'H')">
                           <ShipTo>                              
                              <Address>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                       <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="$v_ship/ISOAL"/>
                                       </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="$v_ship/LAND1"/>
                                       </xsl:attribute>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:attribute name="addressID">
                                    <xsl:value-of select="$v_ship/LIFNR"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="'buyerLocationID'"/>
                                 </xsl:attribute>
                                 <Name>
                                    <xsl:call-template name="FillLangOut">
                                       <xsl:with-param name="p_spras_iso"
                                          select="$v_ship/SPRAS_ISO"/>
                                       <xsl:with-param name="p_spras"
                                          select="$v_ship/SPRAS"/>
                                       <xsl:with-param name="p_lang"
                                          select="$v_defaultLang"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="$v_ship/NAME1"/>
                                 </Name>  
                                 <PostalAddress> 
                                    <!--IG-24608-To align with BSAO we need map attribute @name under OrderRequestHeader/ShipTo/Address/PostalAddress with value as ‘default’.-->
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'default'"/>
                                      </xsl:attribute>
                                    <!--IG-24608-->
                                    <xsl:for-each select="E1EDKA1/E1ARBCIG_PARTNER_INFO[DELIVER_TO = 'X']">                                     
                                       <xsl:if test="string-length(normalize-space(NAME_CO)) > 0">
                                          <DeliverTo>
                                             <xsl:value-of select="NAME_CO"/>
                                          </DeliverTo>
                                       </xsl:if>
                                       <xsl:if
                                          test="string-length(normalize-space(BUILDING)) > 0 or string-length(normalize-space(FLOOR)) > 0 or string-length(normalize-space(ROOMNUMBER)) > 0">
                                          <DeliverTo>
                                             <xsl:value-of select="normalize-space(replace(concat(BUILDING, ',', FLOOR, ',', ROOMNUMBER), '^,+', ''))"/>
                                          </DeliverTo>
                                       </xsl:if>
                                    </xsl:for-each>
                                    <Street>
                                       <xsl:value-of select="$v_ship/STRAS"/>
                                    </Street>
                                    <City>
                                       <xsl:value-of select="$v_ship/ORT01"/>
                                    </City>
                                    <xsl:if test="$v_ship">
                                       <Municipality>
                                          <xsl:value-of select="$v_ship/ORT02"/>
                                       </Municipality>
                                    </xsl:if>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) >0 or string-length(normalize-space($v_ship/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION)) > 0">
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) >0">
                                                <State>
                                                   <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                                                </State>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <State>
                                                   <xsl:value-of select="$v_ship/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION"/>
                                                </State>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space($v_ship/REGIO)) >0">
                                                <State>
                                                   <xsl:value-of select="$v_ship/REGIO"/>
                                                </State>
                                             </xsl:when>                                            
                                          </xsl:choose>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <PostalCode>
                                       <xsl:value-of select="$v_ship/PSTLZ"/>
                                    </PostalCode>
                                    <Country>
                                       <xsl:choose>
                                          <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                             <xsl:attribute name="isoCountryCode">
                                                <xsl:value-of select="$v_ship/ISOAL"/>
                                             </xsl:attribute>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_ship/LAND1))>0">
                                                   <xsl:attribute name="isoCountryCode">
                                                      <xsl:value-of select="$v_ship/LAND1"/>
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
                                 <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/SMTP_ADDR)) > 0">
                                    <Email>                                       
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'default'"/>
                                       </xsl:attribute>
                                       <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/SPRAS_ISO)) > 0">
                                          <xsl:attribute name="preferredLang">
                                             <xsl:value-of select="lower-case($v_ship/E1ARBCIG_PARTNER_INFO/SPRAS_ISO)"/>
                                          </xsl:attribute>
                                       </xsl:if>
                                       <xsl:value-of select="lower-case($v_ship/E1ARBCIG_PARTNER_INFO/SMTP_ADDR)"/>
                                    </Email>
                                 </xsl:if>
                                 <xsl:if test="$v_ship/TELF1">
                                    <Phone>
                                       <TelephoneNumber>
                                          <CountryCode>
                                             <xsl:choose>
                                                <!-- CI-1984 -->  
                                                <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                   <xsl:attribute name="isoCountryCode">
                                                      <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                                   </xsl:attribute>                                                   
                                                </xsl:when>  
                                                <!-- CI-1984 --> 
                                                <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                                   <xsl:attribute name="isoCountryCode">
                                                      <xsl:value-of select="$v_ship/ISOAL"/>
                                                   </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:choose>
                                                      <xsl:when test="string-length(normalize-space($v_ship/LAND1))>0">
                                                         <xsl:attribute name="isoCountryCode">
                                                            <xsl:value-of select="$v_ship/LAND1"/>
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
                                             <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                                <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/>               
                                             </xsl:if>
                                             <!-- CI-1984 --> 
                                          </CountryCode>
                                          <AreaOrCityCode/>
                                          <xsl:if test="$v_ship">
                                             <Number>
                                                <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELF1"/>
                                             </Number>
                                             <xsl:if
                                                test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELEXT)) > 0">
                                                <Extension>
                                                   <xsl:value-of
                                                      select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEXT"/>
                                                </Extension>
                                             </xsl:if>
                                          </xsl:if>
                                       </TelephoneNumber>
                                    </Phone>
                                 </xsl:if>
                                 <xsl:if test="$v_ship/TELFX">
                                    <Fax>
                                       <TelephoneNumber>
                                          <CountryCode>
                                             <xsl:choose>
                                                <!-- CI-1984 -->  
                                                <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                   <xsl:attribute name="isoCountryCode">
                                                      <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                                   </xsl:attribute>                                                   
                                                </xsl:when>  
                                                <!-- CI-1984 --> 
                                                <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                                   <xsl:attribute name="isoCountryCode">
                                                      <xsl:value-of select="$v_ship/ISOAL"/>
                                                   </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:choose>
                                                      <xsl:when test="string-length(normalize-space($v_ship/LAND1))>0">
                                                         <xsl:attribute name="isoCountryCode">
                                                            <xsl:value-of select="$v_ship/LAND1"/>
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
                                             <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                                <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/>               
                                             </xsl:if>
                                             <!-- CI-1984 -->
                                          </CountryCode>
                                          <AreaOrCityCode/>
                                          <xsl:if test="$v_ship/TELFX">
                                             <Number>
                                                <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELFX"/>
                                             </Number>
                                             <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELFEXT)) > 0">
                                                <Extension>
                                                   <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELFEXT"/>
                                                </Extension>
                                             </xsl:if>
                                          </xsl:if>
                                       </TelephoneNumber>
                                    </Fax>
                                 </xsl:if>
                              </Address>
                              <IdReference>                                 
                                 <xsl:attribute name="identifier" select="$v_ship/LIFNR"/>                                
                                 <xsl:attribute name="domain">
                                    <xsl:value-of select="'buyerLocationID'"/>
                                 </xsl:attribute> <!-- IG-18863: removed single quotes around buyerLocationID -->
                              </IdReference>
                              <xsl:if test="$v_lgort_header">
                                 <IdReference>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="substring($v_lgort_header,1,4)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'storageLocationID'"/>
                                    </xsl:attribute>
                                 </IdReference>
                              </xsl:if>
                           </ShipTo>
                        </xsl:if>                         
                        <xsl:if test="E1EDK14[QUALF = '011']">
                           <BillTo>                              
                              <Address>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/EIKTO))>0">                       
                                       <xsl:attribute name="addressID">
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/EIKTO"/>
                                       </xsl:attribute>
                                       <xsl:attribute name="addressIDDomain">
                                          <xsl:value-of select="'supplierID'"/>
                                       </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:attribute name="addressID">
                                          <xsl:value-of
                                             select="E1EDK14[QUALF = '011']/ORGID"/>
                                       </xsl:attribute>
                                    </xsl:otherwise>
                                 </xsl:choose>                                  
                                 <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY))>0">
                                    <xsl:attribute name="isoCountryCode">
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:choose>
                                    <xsl:when
                                       test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/NAME1)) > 0">
                                       <Name>
                                          <xsl:call-template name="FillLangOut">
                                             <xsl:with-param name="p_spras_iso"
                                                select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/LANGU_ISO"/>
                                             <xsl:with-param name="p_spras"
                                                select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/LANGU"/>
                                             <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                                          </xsl:call-template>
                                          <xsl:value-of
                                             select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/NAME1"
                                          />
                                       </Name>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <Name>
                                          <xsl:attribute name="xml:lang">
                                             <xsl:call-template name="FillLangOut">
                                                <xsl:with-param name="p_spras_iso"
                                                   select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/LANGU_ISO"/>
                                                <xsl:with-param name="p_spras"
                                                   select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/LANGU"/>
                                                <xsl:with-param name="p_lang"
                                                   select="$v_defaultLang"/>
                                             </xsl:call-template>  
                                          </xsl:attribute>
                                          <!--IG-23706-->
                                          <xsl:value-of
                                             select="'default'"/>
                                          <!--IG-23706-->
                                    </Name>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <PostalAddress>                                    
                                    <Street>
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/STREET"/>
                                    </Street>
                                    <City>
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/CITY1"/>
                                    </City>
                                    <Municipality>
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/CITY2"/>
                                    </Municipality>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/REGION_DESCRIPTION)) > 0">
                                          <State>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/REGION_DESCRIPTION"/>
                                          </State>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <State>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/REGION"/>
                                          </State>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <PostalCode>
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/POST_CODE1"/>
                                    </PostalCode>
                                    <Country>
                                       <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                       </xsl:attribute>
                                    </Country>
                                 </PostalAddress>
                                 <Phone>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <!-- CI-1984 -->                                          
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1))>0">
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1"/>
                                                </xsl:when>                                        
                                                <xsl:otherwise>
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                                </xsl:otherwise>
                                             </xsl:choose> 
                                             <!-- CI-1984 --> 
                                          </xsl:attribute>
                                          <!--*IG-28383{         include International Dialing Code for Telephone/Fax                             -->                                          
                                          <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO))>0">                                          
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO"/>
                                          </xsl:if>
<!--                                          *}IG-28383                                          -->
                                       </CountryCode>
                                       <AreaOrCityCode/>
                                       <Number>
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_NUMBER"/>
                                       </Number>
                                       <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_EXTENS)) > 0">
                                          <Extension>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_EXTENS"/>
                                          </Extension>
                                       </xsl:if>
                                    </TelephoneNumber>
                                 </Phone>
                                 <Fax>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <!-- CI-1984 -->                                          
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1))>0">
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1"/>
                                                </xsl:when>                                        
                                                <xsl:otherwise>
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                                </xsl:otherwise>
                                             </xsl:choose> 
                                          </xsl:attribute>
                                          <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO))>0">                                          
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO"/>
                                          </xsl:if>
                                          <!-- CI-1984 --> 
                                       </CountryCode>
                                       <AreaOrCityCode/>
                                       <Number>
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/FAX_NUMBER"/>
                                       </Number>
                                       <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/FAX_EXTENS)) > 0">
                                          <Extension>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/FAX_EXTENS"/>
                                          </Extension>
                                       </xsl:if>
                                    </TelephoneNumber>
                                 </Fax>
                              </Address>
                              <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/EIKTO))>0">
                                 <IdReference>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/EIKTO"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'supplierID'"/>
                                    </xsl:attribute>
                                 </IdReference>
                              </xsl:if>
                              <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/ORGID))>0">
                                 <IdReference>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/ORGID"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'buyerID'"/>
                                    </xsl:attribute>
                                 </IdReference>
                              </xsl:if>  
                           </BillTo>
                           <!-- CI-1681 - To support soldto details               -->
                           <BusinessPartner>
                              <xsl:attribute name="type">
                                 <xsl:value-of select="'organization'"/>
                              </xsl:attribute>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="'soldTo'"/>
                              </xsl:attribute>
                              <Address>
				 <!-- Begin IG-32914 E1EDK14[QUALF = 011] is replaced with E1EDK14[QUALF = '011'] End-->     
                                 <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/COUNTRY))>0">
                                    <xsl:attribute name="isoCountryCode">
				 <!-- Begin IG-32914 E1EDK14[QUALF = 011] is replaced with E1EDK14[QUALF = '011'] End-->	    
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                    </xsl:attribute>
                                 </xsl:if>
                                 <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/PAORG)) > 0">
                                    <xsl:attribute name="addressID">
                                       <xsl:value-of select="E1EDKA1[PARVW = 'AG']/PAORG"/>
                                    </xsl:attribute>
                                 </xsl:if>                                
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="'buyerAccountID'"/>
                                 </xsl:attribute>
                                 <xsl:choose>
                                    <xsl:when
                                       test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/NAME1)) > 0">
                                       <Name>
                                          <xsl:call-template name="FillLangOut">
                                             <xsl:with-param name="p_spras_iso"
                                                select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/LANGU_ISO"/>
                                             <xsl:with-param name="p_spras"
                                                select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/LANGU"/>
                                             <xsl:with-param name="p_lang" select="$v_defaultLang"/>
                                          </xsl:call-template>
                                          <xsl:value-of
                                             select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/NAME1"
                                          />
                                       </Name>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <Name>
                                          <xsl:attribute name="xml:lang">
                                             <xsl:call-template name="FillLangOut">
                                                <xsl:with-param name="p_spras_iso"
                                                   select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/LANGU_ISO"/>
                                                <xsl:with-param name="p_spras"
                                                   select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/LANGU"/>
                                                <xsl:with-param name="p_lang"
                                                   select="$v_defaultLang"/>
                                             </xsl:call-template>  
                                          </xsl:attribute>                                         
                                          <xsl:value-of
                                             select="'default'"/>                                        
                                       </Name>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <PostalAddress>                                    
                                    <Street>
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/STREET"/>
                                    </Street>
                                    <City>
                                       <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/CITY1"/>
                                    </City>
                                    <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/CITY2)) > 0">				      
                                       <Municipality>
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/CITY2"/>
                                       </Municipality>
                                    </xsl:if>	 
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/REGION_DESCRIPTION)) > 0">
                                          <State>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/REGION_DESCRIPTION"/>
                                          </State>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <State>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/REGION"/>
                                          </State>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/POST_CODE1)) > 0">				      
                                       <PostalCode>
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/POST_CODE1"/>
                                       </PostalCode>
                                    </xsl:if>	 
                                    <Country>
                                       <xsl:attribute name="isoCountryCode">
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                       </xsl:attribute>
                                    </Country>
                                 </PostalAddress>
                                 <Phone>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <!-- CI-1984 -->                                          
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1))>0">
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1"/>
                                                </xsl:when>                                        
                                                <xsl:otherwise>
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                                </xsl:otherwise>
                                             </xsl:choose> 
                                          </xsl:attribute>
                                          <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO))>0">
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO"/> 
                                          </xsl:if>
                                          <!-- CI-1984 --> 
                                       </CountryCode>
                                       <AreaOrCityCode/>
                                       <Number>
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_NUMBER"/>
                                       </Number>
                                       <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/TEL_EXTENS)) > 0">
                                          <Extension>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_EXTENS"/>
                                          </Extension>
                                       </xsl:if>
                                    </TelephoneNumber>
                                 </Phone>
                                 <Fax>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <!-- CI-1984 -->                                          
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1))>0">
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TEL_LAND1"/>
                                                </xsl:when>                                        
                                                <xsl:otherwise>
                                                   <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/COUNTRY"/>
                                                </xsl:otherwise>
                                             </xsl:choose> 
                                          </xsl:attribute>
                                          <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO))>0">
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/TELEFTO"/> 
                                          </xsl:if>
                                          <!-- CI-1984 --> 
                                       </CountryCode>
                                       <AreaOrCityCode/>
                                       <Number>
                                          <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/FAX_NUMBER"/>
                                       </Number>
                                       <xsl:if test="string-length(normalize-space(E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO[1]/FAX_EXTENS)) > 0">
                                          <Extension>
                                             <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/FAX_EXTENS"/>
                                          </Extension>
                                       </xsl:if>
                                    </TelephoneNumber>
                                 </Fax>
                              </Address>
                              <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/EIKTO))>0">
                                 <IdReference>
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'supplierID'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/EIKTO"/>
                                    </xsl:attribute>                                    
                                 </IdReference>
                              </xsl:if>
                              <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/PAORG))>0">
                                 <IdReference>
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'buyerAccountID'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="E1EDKA1[PARVW = 'AG']/PAORG"/>
                                    </xsl:attribute>                                    
                                 </IdReference>
                              </xsl:if>                             
                           </BusinessPartner>                           
                           <!-- CI-1761 Supplying Plant Info -->
                           <xsl:if test="$v_business_partner">
                              <BusinessPartner>
                                 <xsl:attribute name="type">
                                    <xsl:value-of select="'organization'"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="role">
                                    <xsl:value-of select="'shipFrom'"/>
                                 </xsl:attribute>
                                 <Address>
                                    <xsl:attribute name="isoCountryCode">
                                       <xsl:value-of select="$v_business_partner/LAND1"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="addressID">
                                       <xsl:value-of select="$v_business_partner/WERKS"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="addressIDDomain">
                                       <xsl:value-of select="'ShipFromAddressID'"/>
                                    </xsl:attribute>
                                    <Name>
                                       <xsl:attribute name="xml:lang">
                                          <xsl:call-template name="FillLangOut">
                                             <xsl:with-param name="p_spras_iso"
                                                select="$v_business_partner/SPRAS_ISO"/>
                                             <xsl:with-param name="p_spras"
                                                select="$v_business_partner/SPRAS"/>
                                             <xsl:with-param name="p_lang"
                                                select="$v_defaultLang"/>
                                          </xsl:call-template>  
                                       </xsl:attribute>
                                       <xsl:value-of select="$v_business_partner/NAME1"/>
                                    </Name>
                                    <PostalAddress>
                                       <Street>
                                          <xsl:value-of select="$v_business_partner/STRAS"/>
                                       </Street>
                                       <City>
                                          <xsl:value-of select="$v_business_partner/ORT01"/>
                                       </City>
                                       <PostalCode>
                                          <xsl:value-of select="$v_business_partner/PSTLZ"/>
                                       </PostalCode>
                                       <Country>
                                          <xsl:attribute name="isoCountryCode">
                                             <xsl:value-of select="$v_business_partner/LAND1"/>
                                          </xsl:attribute>
                                       </Country>
                                    </PostalAddress>
                                 </Address>
                              </BusinessPartner>
                           </xsl:if>
                           <!-- CI-1761 -->
                           <!-- Addition of Legal Entity (Comapny Code info) -->
                           <LegalEntity>
                              <IdReference>
                                 <xsl:attribute name="identifier"
                                    select="E1EDK14[QUALF = '011']/ORGID"/>
                                 <xsl:attribute name="domain" select="'CompanyCode'"/>
                                 <Description>
				 	<xsl:attribute name="xml:lang">
									   <xsl:call-template name="FillDefaultLang">
											<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
											<xsl:with-param name="p_pd" select="$v_pd"/>
										</xsl:call-template>
                                        </xsl:attribute>
                                    <xsl:value-of
                                       select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/NAME1"/>
                                 </Description>
                              </IdReference>
                           </LegalEntity>                                                     
                        </xsl:if>
                        <!-- Addition of Purchasing Organization info -->
                        <xsl:if test="E1EDK14[QUALF = '014']">
                           <OrganizationalUnit>
                              <IdReference>
                                 <xsl:attribute name="identifier"
                                    select="E1EDK14[QUALF = '014']/ORGID"/>
                                 <xsl:attribute name="domain" select="'PurchasingOrganization'"/>
                                 <Description>
				 	<xsl:attribute name="xml:lang">
									   <xsl:call-template name="FillDefaultLang">
											<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
											<xsl:with-param name="p_pd" select="$v_pd"/>
										</xsl:call-template>
                                        </xsl:attribute>
                                    <xsl:value-of
                                       select="E1EDK14[QUALF = '014']/E1ARBCIG_COMPANY_INFO/NAME1"/>
                                 </Description>
                              </IdReference>
                           </OrganizationalUnit>
                        </xsl:if>
                        <!-- Addition of Purchasing Group info -->
                        <xsl:if test="E1EDK14[QUALF = '009']">
                           <OrganizationalUnit>
                              <IdReference>
                                 <xsl:attribute name="identifier"
                                    select="E1EDK14[QUALF = '009']/ORGID"/>
                                 <xsl:attribute name="domain" select="'PurchasingGroup'"/>
                                 <Description>
				       <xsl:attribute name="xml:lang">
									   <xsl:call-template name="FillDefaultLang">
											<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
											<xsl:with-param name="p_pd" select="$v_pd"/>
										</xsl:call-template>
                                        </xsl:attribute>
                                    <xsl:value-of
                                       select="E1EDK14[QUALF = '009']/E1ARBCIG_COMPANY_INFO/NAME1"/>
                                 </Description>
                              </IdReference>
                           </OrganizationalUnit>
                        </xsl:if>                        
                        <xsl:if test="((E1EDK36/EXDATBI) and (E1EDK36/CCNUM))">
                           <Payment>
                              <PCard>
                                 <xsl:attribute name="number">
                                    <xsl:value-of select="E1EDK36/CCNUM"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="expiration">
                                    <xsl:value-of select="E1EDK36/EXDATBI"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="name">
                                    <xsl:value-of select="E1EDK36/CCNAME"/>
                                 </xsl:attribute>
                              </PCard>
                           </Payment>
                        </xsl:if>
                        <xsl:if
                           test="(E1EDKT1/TDOBJECT = 'ZTERM') and (not(E1EDKT1/TDOBNAME) or (E1EDKT1/TDOBNAME = ''))">
                           <xsl:for-each select="E1EDK18">
                              <PaymentTerm>
                                 <xsl:attribute name="payInNumberOfDays">
                                    <xsl:value-of select="TAGE"/>
                                 </xsl:attribute>
                                 <xsl:choose>
                                    <xsl:when test="PRZNT and (PRZNT > 0)">
                                       <Discount>
                                          <DiscountPercent>
                                             <xsl:attribute name="percent">
                                                <xsl:value-of select="PRZNT"/>
                                             </xsl:attribute>
                                          </DiscountPercent>
                                       </Discount>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <Discount>
                                          <DiscountPercent>
                                             <xsl:attribute name="percent">
                                                <xsl:value-of select="'0.000'"/>
                                             </xsl:attribute>
                                          </DiscountPercent>
                                       </Discount>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </PaymentTerm>
                           </xsl:for-each>
                        </xsl:if>                        
                        <xsl:if test="$v_vendor">
                           <Contact>
                              <xsl:attribute name="role">
                                 <xsl:value-of select="'supplierCorporate'"/>
                              </xsl:attribute>
                              <xsl:if test="$v_vendor">
                                 <xsl:attribute name="addressID">
                                    <xsl:value-of select="$v_vendor/PARTN"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="addressIDDomain">
                                    <xsl:value-of select="'buyerID'"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/NAME1)) > 0">
                              <Name>
                                 <xsl:call-template name="FillLangOut">
                                    <xsl:with-param name="p_spras_iso"
                                                    select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS_ISO"/>
                                    <xsl:with-param name="p_spras"
                                                    select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS"/>
                                    <xsl:with-param name="p_lang"
                                                    select="$v_defaultLang"/>
                                 </xsl:call-template>
                                 <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/NAME1"/>                                
                              </Name>
                              </xsl:if>
                              <PostalAddress>
                                 <Street>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/STRAS"/>
                                 </Street>
                                 <City>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/ORT01"/>
                                 </City>
                                 <Municipality>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/ORT02"/>
                                 </Municipality>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) > 0">
                                       <State>
                                          <xsl:value-of select="E1EDKA1[PARVW = 'LF']/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                                       </State>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <State>
                                          <xsl:value-of select="E1EDKA1[PARVW = 'LF']/E1ARBCIG_PARTNER_INFO/REGIO"/>
                                       </State>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <PostalCode>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/PSTLZ"/>
                                 </PostalCode>
                                 <Country>
                                    <xsl:attribute name="isoCountryCode">
                                       <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/LAND1"/>
                                    </xsl:attribute>
                                 </Country>
                              </PostalAddress>
                              <Email>
                                 <xsl:attribute name="name">
                                    <xsl:value-of select="'default'"/>
                                 </xsl:attribute>
                                 <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/SMTP_ADDR"/>
                              </Email>
                              <!-- IG-19998 Start -->    
                              <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELF1))>0">
                              <Phone>
                                 <TelephoneNumber>
                                    <CountryCode>
                                       <xsl:attribute name="isoCountryCode">
                                          <!-- CI-1984 -->                                          
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                             </xsl:when>                                        
                                             <xsl:otherwise>
                                                <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/LAND1"/>
                                             </xsl:otherwise>
                                          </xsl:choose>   
                                       </xsl:attribute> 
                                       <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                          <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO"/> 
                                       </xsl:if>                                       
                                       <!-- CI-1984 -->   
                                    </CountryCode>
                                    <AreaOrCityCode/>                                                                                                                                                                                                  
                                    <Number>
                                       <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELF1"/>
                                     </Number>
                                    <!-- IG-30548 --> 
                                    <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEXT)) > 0">
                                       <Extension>
                                          <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEXT"/>
                                       </Extension>
                                    </xsl:if>  
                                    <!-- IG-30548 --> 
                                 </TelephoneNumber>
                              </Phone>                                                           
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELF2))>0">
                           <Phone>
                              <TelephoneNumber>
                                 <CountryCode>
                                    <xsl:attribute name="isoCountryCode">
                                       <!-- CI-1984 -->                                          
                                       <xsl:choose>
                                          <xsl:when test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND2))>0">
                                             <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND2"/>
                                          </xsl:when>                                        
                                          <xsl:otherwise>
                                             <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/LAND1"/>
                                          </xsl:otherwise>
                                       </xsl:choose>   
                                    </xsl:attribute>
                                    <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO2))>0">
                                       <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO2"/> 
                                    </xsl:if>  
                                    <!-- CI-1984 -->  
                                 </CountryCode>
                                 <AreaOrCityCode/>                                 
                                 <Number>
                                    <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELF2"/>
                                 </Number>
                                 <!-- IG-30548 --> 
                                 <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEXT2)) > 0">
                                    <Extension>
                                       <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEXT2"/>
                                    </Extension>
                                 </xsl:if>  
                                 <!-- IG-30548 --> 
                              </TelephoneNumber>
                           </Phone>                                                         
                        </xsl:if>
                        <!-- IG-19212 End -->  
                              <Fax>
                                 <TelephoneNumber>
                                    <CountryCode>
                                       <xsl:attribute name="isoCountryCode">
                                          <!-- CI-1984 -->                                          
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                             </xsl:when>                                        
                                             <xsl:otherwise>
                                                <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/LAND1"/>
                                             </xsl:otherwise>
                                          </xsl:choose>   
                                       </xsl:attribute>
                                       <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                          <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO"/> 
                                       </xsl:if>  
                                       <!-- CI-1984 -->  
                                    </CountryCode>
                                    <AreaOrCityCode/>
                                    <Number>
                                       <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELFX"/>
                                    </Number>
                                    <!-- IG-30548 --> 
                                    <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELFEXT)) > 0">
                                       <Extension>
                                          <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELFEXT"/>
                                       </Extension>
                                    </xsl:if>  
                                    <!-- IG-30548 --> 
                                 </TelephoneNumber>
                              </Fax> 
                              <xsl:if test="string-length(normalize-space($v_vendor/ILNNR)) > 0">
                                 <IdReference>
                                    <xsl:attribute name="identifier" select="$v_vendor/ILNNR"/>                                 
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'ILN'"/>
                                    </xsl:attribute>
                                 </IdReference>
                              </xsl:if>                              
                              <xsl:if test="string-length(normalize-space($v_vendor/PARTN)) > 0">
                                 <IdReference>
                                    <xsl:attribute name="identifier" select="$v_vendor/PARTN"/>
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'buyerID'"/>
                                    </xsl:attribute>
                                 </IdReference>
                              </xsl:if>
                           </Contact>
                           <xsl:if test="string-length(normalize-space($v_vendor/BNAME)) > 0">
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
                                 <xsl:if test="string-length(normalize-space($v_vendor/TELF1)) > 0">
                                 <Phone>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <!-- CI-1984 -->                                          
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                   <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                                </xsl:when>                                        
                                                <xsl:otherwise>
                                                   <xsl:value-of select="$v_empty"/>
                                                </xsl:otherwise>
                                             </xsl:choose>   
                                          </xsl:attribute>
                                          <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                             <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEFTO"/> 
                                          </xsl:if>   
                                          <!-- CI-1984 --> 
                                       </CountryCode>
                                       <AreaOrCityCode/>
                                       <Number>
                                        <xsl:value-of select="$v_vendor/TELF1"/>
                                       </Number>
                                       <!-- IG-30548 --> 
                                       <xsl:if test="string-length(normalize-space($v_vendor/E1ARBCIG_PARTNER_INFO/TELEXT)) > 0">
                                          <Extension>
                                             <xsl:value-of select="$v_vendor/E1ARBCIG_PARTNER_INFO/TELEXT"/>
                                          </Extension>
                                       </xsl:if>  
                                       <!-- IG-30548 --> 
                                    </TelephoneNumber>
                                 </Phone>
                                 </xsl:if>
                              </Contact>
                           </xsl:if>                           
                        </xsl:if>
                        <xsl:variable name="v_comm_hdr">
                           <xsl:for-each select="E1EDKT1">
                              <xsl:if test="normalize-space(TDOBJECT)='' or TDOBJECT!='ZTERM'">
                                 <xsl:value-of select="'1'"/>
                              </xsl:if>
                           </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="v_att">
                           <xsl:for-each select="$v_attach">
                              <xsl:if test="string-length(normalize-space(LINENUMBER))=0">
                                 <xsl:value-of select="'1'"/> 
                              </xsl:if>
                           </xsl:for-each>                   
                        </xsl:variable>
                        <xsl:if test="string-length(normalize-space($v_att))>0 or string-length(normalize-space($v_comm_hdr))>0">                      
                         <!--  IG-24207 Begin-->
                           <!--<Comments>
                           <xsl:call-template name="CommentsFillIdocOutPO">
                              <xsl:with-param name="p_aribaComment"
                                              select="E1EDKT1"/>
                              <xsl:with-param name="p_doctype"
                                              select="$anTargetDocumentType"/>
                              <xsl:with-param name="p_pd" select="$v_pd"/>
                           </xsl:call-template>
                           <xsl:call-template name="addContenIdIDOC">
                              <xsl:with-param name="eachAtt" select="$v_attach"/>
                           </xsl:call-template>
                        </Comments>-->
                           <!--  IG-16312 Begin-->
                           <!--  Multiple Comments will now be created as supported in cXML 45 and above -->
                           <xsl:call-template name="MapMultiple_Text_Comments_IDOC_To_cXML">
                              <xsl:with-param name="p_aribaComment" select="E1EDKT1"/>
                              <xsl:with-param name="p_targetdoctype" select="$anTargetDocumentType"/>
                              <xsl:with-param name="p_sourcedoctype" select="$anSourceDocumentType"/>   
                              <xsl:with-param name="p_pd" select="$v_pd"/>
                              <xsl:with-param name="p_attach" select="$v_attach"/>
                              <xsl:with-param name="p_onlyattachnocomments" select="$v_att"/>
                           </xsl:call-template>
                           <!--  IG-16312 End-->
                           <!--  IG-24207 End-->
                        </xsl:if>
                        <xsl:if test="(string-length(normalize-space($v_vendor/IHREZ))>0 and $v_vendor/IHREZ != 'ARIBA_P2P')">
                          <SupplierOrderInfo>
                            <xsl:attribute name="orderID">
                               <xsl:value-of select="$v_vendor/IHREZ"/>
                            </xsl:attribute>                              
                          </SupplierOrderInfo>
                        </xsl:if>                       
                        <xsl:if test="(E1EDK17) and (E1EDK17[QUALF = '001'])">
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
                                    <xsl:value-of select="E1EDK17[QUALF = '001']/LKOND"/>
                                 </xsl:attribute>
                                 <!-- IG-26124:Incoterm description is not available in SCC PO -->
                                 <xsl:value-of select="E1EDK17/E1ARBCIG_INCOTERM/BEZEI"/>
                                 <!-- IG-26124:Incoterm description is not available in SCC PO -->  
                              </TransportTerms>
                              <xsl:if test="E1EDK17[QUALF = '001']">
                                 <Address>
                                    <Name>
                                       <xsl:call-template name="FillLangOut">
                                          <xsl:with-param name="p_spras_iso"
                                                          select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS_ISO"/>
                                          <xsl:with-param name="p_spras"
                                                          select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS"/>
                                          <xsl:with-param name="p_lang"
                                                          select="$v_defaultLang"/>
                                       </xsl:call-template>
                                       <xsl:value-of select="E1EDK17[QUALF = '001']/LKTEXT"/>
                                    </Name>
                                 </Address>
                              </xsl:if>
                           </TermsOfDelivery>                           
                        </xsl:if>
                        <OrderRequestHeaderIndustry>
                           <xsl:if test="(string-length(normalize-space($v_vendor/IHREZ)) > 0 and $v_vendor/IHREZ != 'ARIBA_P2P')">
                              <ReferenceDocumentInfo>
                                 <DocumentInfo>
                                    <xsl:attribute name="documentID">
                                       <xsl:value-of select="$v_vendor/IHREZ"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="documentType" select="'ReplenishmentOrder'"/>
                                 </DocumentInfo>
                              </ReferenceDocumentInfo>
                           </xsl:if>
                           <ExternalDocumentType>
                              <xsl:attribute name="documentType">
                                 <xsl:value-of select="$v_doctype"/>
                              </xsl:attribute>
                              <xsl:if test="string-length(normalize-space($v_desc)) > 0">
                                 <Description>
                                    <xsl:attribute name = "xml:lang">
                                       <xsl:call-template name="FillDefaultLang">
                                          <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                          <xsl:with-param name="p_pd" select="$v_pd"/>
                                       </xsl:call-template>                                  
                                    </xsl:attribute>
                                    <xsl:value-of select="$v_desc"/>
                                 </Description>
                              </xsl:if>
                           </ExternalDocumentType>
                        </OrderRequestHeaderIndustry>
                        <xsl:if test="string-length($v_ipo) = 0">                         
                        <xsl:if test="$v_bill">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'CompanyCode'"/>
                              </xsl:attribute>
                              <xsl:value-of select="E1EDK14[QUALF = '011']/E1ARBCIG_COMPANY_INFO/BUKRS"/>
                           </Extrinsic>
                        </xsl:if>                       
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'PurchaseGroup'"/>
                           </xsl:attribute>
                           <xsl:value-of select="E1EDK14[QUALF = '009']/ ORGID"/>
                        </Extrinsic>                    
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'PurchaseOrganization'"/>
                           </xsl:attribute>
                           <xsl:value-of select="E1EDK14[QUALF = '014']/ ORGID"/>
                        </Extrinsic> 
                           <Extrinsic> 
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'Requester'"/>
                              </xsl:attribute>
                              <xsl:value-of select="$v_ernam"/>
                           </Extrinsic>                           
                        </xsl:if>
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'Ariba.invoicingAllowed'"/>
                           </xsl:attribute>Yes</Extrinsic>
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'Ariba.availableAmount'"/>
                           </xsl:attribute>
                           <xsl:value-of select="E1EDS01/SUMME"/>
                        </Extrinsic>
                        <xsl:if test="($v_vendor/IHREZ = 'ARIBA_P2P')">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'AribaOrderID'"/>
                              </xsl:attribute>
                              <xsl:value-of select="$v_bill/IHREZ"/>
                           </Extrinsic>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(E1EDK01/KUNDEUINR)) > 0">
                        <Extrinsic>
                           <xsl:attribute name="name">buyerVatID</xsl:attribute>
                           <xsl:value-of select="E1EDK01/KUNDEUINR"/>
                        </Extrinsic>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(E1EDK01/EIGENUINR)) > 0">
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'supplierVatID'"/>
                           </xsl:attribute>
                           <xsl:value-of select="E1EDK01/EIGENUINR"/>
                        </Extrinsic>
                        </xsl:if>
                        <xsl:if test="$v_vendor">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'partyAdditionalID'"/></xsl:attribute>
                              <xsl:value-of select="$v_vendor/PARTN"/>
                           </Extrinsic>
                        </xsl:if>
                        <xsl:if test="E1EDK02[QUALF = '030']">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'customerReferenceID'"/>
                              </xsl:attribute>
                              <xsl:value-of select="E1EDK02[QUALF = '030']/BELNR"/>
                           </Extrinsic>
                        </xsl:if>
                        <xsl:if test="E1EDK02[QUALF = '017']">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'additionalReferenceID'"/>
                              </xsl:attribute>
                              <xsl:value-of select="E1EDK02[QUALF = '017']/BELNR"/>
                           </Extrinsic>
                        </xsl:if>
                        <xsl:if test="E1EDK02[QUALF = '017']">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'ultimateCustomerReferenceID'"/>
                              </xsl:attribute>
                              <xsl:value-of select="E1EDK02[QUALF = '018']/BELNR"/>
                           </Extrinsic>
                        </xsl:if>
                        <xsl:if test="E1EDKT1[TDOBJECT = 'ZTERM']">
                           <Extrinsic>
                              <xsl:attribute name="name">
                                 <xsl:value-of select="'AribaNetwork.PaymentTermsExplanation'"/>
                              </xsl:attribute>
                              <xsl:value-of select="E1EDKT1[TDOBJECT = 'ZTERM']/E1EDKT2/TDLINE"/>
                           </Extrinsic>
                        </xsl:if>
                      </OrderRequestHeader>
                     <xsl:for-each select="E1EDP01">
                        <xsl:variable name="v_item_sloc">
                           <xsl:value-of select="LGORT"/>
                        </xsl:variable>
                        <ItemOut>
                           <xsl:attribute name="quantity">
                              <xsl:value-of select="format-number(MENGE,'0.000')"/>
                           </xsl:attribute>
                           <xsl:attribute name="lineNumber">
                              <xsl:value-of select="POSEX"/>
                           </xsl:attribute>
                           <xsl:if test="E1EDP02[QUALF = '005']">
                              <xsl:attribute name="agreementItemNumber">
                                 <xsl:value-of select="E1EDP02[QUALF = '005']/ZEILE"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:attribute name="requestedDeliveryDate">
                              <xsl:variable name="v_minDate">
                                 <xsl:for-each select="E1EDP20/EDATU">
                                    <xsl:sort select="EDATU" data-type="text"
                                              order="ascending"/>
                                    <xsl:if test="position() = 1">
                                       <xsl:value-of select="."/>
                                    </xsl:if>
                                 </xsl:for-each>
                              </xsl:variable>
                              <xsl:variable name="v_minTime">
                                 <xsl:for-each select="E1EDP20[EDATU = $v_minDate]/EZEIT">
                                    <xsl:sort select="EZEIT" data-type="text" order="ascending"/>
                                    <xsl:if test="position() = 1">
                                       <xsl:value-of select="."/>
                                    </xsl:if>
                                 </xsl:for-each>
                              </xsl:variable>                              
                              <xsl:variable name="v_time">
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space($v_minTime))>0 and ($v_minTime) != '000000'"> 
                                       <xsl:value-of select="$v_minTime"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="'120000'"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:variable>
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(E1ARBCIG_PO_ITEMS_INFO/PLANT_TIMEZONE)) > 0">
                                    <xsl:call-template name="ANDateTime">
                                       <xsl:with-param name="p_date"
                                          select="$v_minDate"/>
                                       <xsl:with-param name="p_time"
                                          select="$v_time"/>
                                       <xsl:with-param name="p_timezone"
                                          select="E1ARBCIG_PO_ITEMS_INFO/PLANT_TIMEZONE"/>                                       
                                    </xsl:call-template>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:call-template name="ANDateTime">
                                       <xsl:with-param name="p_date"
                                          select="$v_minDate"/>
                                       <xsl:with-param name="p_time"
                                          select="$v_time"/>
                                       <xsl:with-param name="p_timezone"
                                          select="$anERPTimeZone"/>
                                    </xsl:call-template>                                    
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <!--  IG-24207 Begin-->
                           <!--  IG-16312 Begin-->
                           <!--  Kanban , Unlimited Delivery, Item Change Indicator-->
                           <!--  Reverting the change for Kanban , Unlimited Delivery, Item Change Indicator -->
                           <xsl:if test="E1EDP02[QUALF = '085']">
                              <xsl:attribute name="isKanban">
                                 <xsl:value-of select="'yes'"/>
                              </xsl:attribute>
                           </xsl:if>                           
                           <!--  IG-20131 Begin-->
                           <!--  Use String length to check if value exists -->
                           <xsl:if test="string-length(E1ARBCIG_PO_ITEMS_INFO/UEBTK) > 0">
                              <xsl:attribute name="unlimitedDelivery">
                                 <xsl:value-of select="'yes'"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="string-length(E1ARBCIG_PO_ITEMS_INFO/CHANGE_IND) > 0">
                              <xsl:attribute name="isItemChanged">
                                 <xsl:value-of select="'yes'"/>
                              </xsl:attribute>
                           </xsl:if>
                           <!--  IG-20131 End-->
                           <!--  IG-16312 End -->
                           <!--  IG-24207 End-->
                           <xsl:if test="E1EDC01">
                              <xsl:choose>
                                 <xsl:when test="count(E1EDC01/POSEX) > 1">
                                    <xsl:attribute name="itemType">
                                       <xsl:value-of select="'composite'"/>
                                    </xsl:attribute>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:attribute name="itemType">
                                       <xsl:value-of select="'item'"/>
                                    </xsl:attribute>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:if>
                           <!-- Map requiresServiceEntry only for service line and either GR based IV or Service based IV is enabled-->
                           <xsl:if test="PSTYP = '9' and (E1ARBCIG_ACC_INFO/WEBRE = 'X' or E1ARBCIG_ACC_INFO/LEBRE = 'X' )">
                              <xsl:attribute name="requiresServiceEntry">
                                 <xsl:value-of select="'yes'"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:choose>
                              <xsl:when test="PSTYP = '3'">
                                 <xsl:attribute name="itemCategory">
                                    <xsl:value-of select="'subcontract'"/>
                                 </xsl:attribute>
                              </xsl:when>
                              <xsl:when test="PSTYP = '2'">
                                 <xsl:attribute name="itemCategory">
                                    <xsl:value-of select="'consignment'"/>
                                 </xsl:attribute>
                              </xsl:when>
                              <!-- Map itemcategory as "stockTransfer" for STO Orders and "inter" or "intra" for stockTransferType-->
                              <xsl:when test="string-length(normalize-space(../E1EDK01/E1ARBCIG_HDR/STO_TYPE))>0">
                                 <xsl:attribute name="itemCategory">stockTransfer</xsl:attribute>
                                 <xsl:attribute name="stockTransferType">
                                    <xsl:value-of select="../E1EDK01/E1ARBCIG_HDR/STO_TYPE"/>
                                 </xsl:attribute>
                              </xsl:when>
                           </xsl:choose>
                           <!-- Mapping Item category as service for service line item   -->
                           <xsl:if test="PSTYP = '9'">
                              <xsl:attribute name="itemClassification">
                                 <xsl:value-of select="'service'"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="ACTION = '093'">
                              <xsl:attribute name="isReturn">
                                 <xsl:value-of select="'yes'"/></xsl:attribute>
                           </xsl:if>
                           <xsl:for-each select="E1ARBCIG_PO_ITEMS_INFO[ELIKZ = 'X']">
                              <xsl:attribute name="isDeliveryCompleted">
                                 <xsl:value-of select="'yes'"/>
                              </xsl:attribute>
                           </xsl:for-each>
                           <!-- CI-1761  STO Order Combination & STO Delivery Mapping-->
                           <xsl:if test="string-length(normalize-space(../E1EDK01/E1ARBCIG_HDR/STO_TYPE))>0"> <!--IG-26293-->
                           <xsl:if test="E1ARBCIG_PO_ITEMS_INFO[KZAZU = 'X']">
                              <xsl:attribute name="stoOrderCombination">
                                 <xsl:value-of select="'yes'"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="string-length(normalize-space(E1ARBCIG_PO_ITEMS_INFO/KZTLF))=0">
                              <xsl:attribute name="stoDelivery">
                                 <xsl:value-of select="'partial'"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:if test="E1ARBCIG_PO_ITEMS_INFO[EGLKZ = 'X']">                                 <!-- CI-1841 Final Delivery Indicator -->
                              <xsl:attribute name="stoFinalDelivery">
                                 <xsl:value-of select="'yes'"/>
                              </xsl:attribute>
                           </xsl:if>
                           </xsl:if>  
                           <!-- CI-1761 -->
                           <ItemID>
                              <xsl:choose>
                                 <!-- S4HANA check for IDTNR and IDTNR_LONG -->
                                 <xsl:when test="(E1EDP19[QUALF = '002']) and (string-length(normalize-space(E1EDP19[QUALF = '002']/IDTNR_LONG)))>0">
                                    <SupplierPartID>
                                       <xsl:value-of select="E1EDP19[QUALF = '002']/IDTNR_LONG"/>
                                    </SupplierPartID>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:choose>
                                       <xsl:when test="(E1EDP19[QUALF = '002']) and (string-length(normalize-space(E1EDP19[QUALF = '002']/IDTNR)))>0">
                                          <SupplierPartID>
                                             <xsl:value-of select="E1EDP19[QUALF = '002']/IDTNR"/>
                                          </SupplierPartID>
                                       </xsl:when>
                                       <xsl:otherwise>
                                                <SupplierPartID>
                                                   <!-- Begin of IG-30341-->   
                                                   <!-- Supplier part ID will be fetched from CIG if maintained else blank will be populated -->
                                                   <xsl:value-of select="$v_defaultSupplierPartID"/>   
                                                   <!--  End of IG-30341--> 
                                                </SupplierPartID>                                             
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <xsl:if test="(E1EDP19[QUALF = '001'])">
                                 <xsl:choose>
                                    <!-- S4HANA check for IDTNR and IDTNR_LONG -->
                                    <xsl:when test="string-length(normalize-space(E1EDP19[QUALF = '001']/IDTNR_LONG))>0">
                                       <BuyerPartID>
                                          <xsl:value-of select="E1EDP19[QUALF = '001']/IDTNR_LONG"/>
                                       </BuyerPartID>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <BuyerPartID>
                                          <xsl:value-of select="E1EDP19[QUALF = '001']/IDTNR"/>
                                       </BuyerPartID>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:if>
                              <xsl:if test="E1EDP19[QUALF = '003']">                                 
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1EDP19[QUALF = '003']/IDTNR_LONG)) > 0">
                                       <IdReference>
                                        <xsl:attribute name="identifier" select="E1EDP19[QUALF = '003']/IDTNR_LONG"/>
                                        <xsl:attribute name="domain" select="'EAN-13'"/>
                                       </IdReference>   
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <IdReference>
                                        <xsl:attribute name="identifier" select="E1EDP19[QUALF = '003']/IDTNR"/>
                                        <xsl:attribute name="domain" select="'EAN-13'"/>
                                       </IdReference> 
                                    </xsl:otherwise>
                                 </xsl:choose>                                 
                              </xsl:if>
                           </ItemID>
                           <xsl:if test="(PSTYP != '1')  and (PSTYP != '9')">
                              <ItemDetail>
                                 <UnitPrice>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(VPREI))>0">
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="VPREI"/>
                                          </Money>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_empty"/>
                                          </Money>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </UnitPrice>
                                 <xsl:if test="E1EDP19[QUALF = '001']">
                                    <Description>
                                       <xsl:call-template name="FillLangOut">
                                          <xsl:with-param name="p_spras_iso"
                                                          select="$v_empty"/>
                                          <xsl:with-param name="p_spras"
                                                          select="$v_bill/SPRAS"/>
                                          <xsl:with-param name="p_lang"
                                                          select="$v_defaultLang"/>
                                       </xsl:call-template>
									   <xsl:attribute name="xml:lang">
									   <xsl:call-template name="FillDefaultLang">
											<xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
											<xsl:with-param name="p_pd" select="$v_pd"/>
										</xsl:call-template>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1EDP19[QUALF = '001']/KTEXT"/>
                                    </Description>
                                 </xsl:if>
                                 <UnitOfMeasure>
                                    <xsl:call-template name="UOMTemplate_Out">
                                       <xsl:with-param name="p_UOMinput"
                                                       select="MENEE"/>
                                       <xsl:with-param name="p_anERPSystemID"
                                                       select="$anERPSystemID"/>
                                       <xsl:with-param name="p_anSupplierANID"
                                                       select="$anSupplierANID"/>
                                    </xsl:call-template>
                                 </UnitOfMeasure>
                                 <!-- IG-35335 -->
                                 <!--Check Condition to generate PriceBasisQuantity Tag -->
                                 <xsl:if test="(string-length(normalize-space(PEINH))> 0 ) and (format-number(PEINH,'0.000') != '0.000') ">
                                    <PriceBasisQuantity>
                                       <xsl:attribute name="quantity">
                                          <xsl:value-of select="PEINH"/>
                                       </xsl:attribute>
                                       <xsl:attribute name="conversionFactor">
                                          <xsl:value-of select="BPUMZ div BPUMN"/>
                                       </xsl:attribute>
                                       <UnitOfMeasure>
                                          <xsl:call-template name="UOMTemplate_Out">
                                             <xsl:with-param name="p_UOMinput"
                                                             select="PMENE"/>
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
                                       <xsl:value-of select="'ERPCommodityCode'"/></xsl:attribute>
                                    <xsl:value-of select="MATKL"/>
                                 </Classification>
                                 <!--  IG-20131 Begin-->
                                 <!--  Use String length to check if value exists -->
                                 <xsl:if test="string-length(E1ARBCIG_PO_ITEMS_INFO/WGBEZ) > 0">
                                    <Classification>
                                       <xsl:attribute name="domain">
                                          <xsl:value-of select="'ERPCommodityCodeDescription'"/></xsl:attribute>
                                       <xsl:value-of select="E1ARBCIG_PO_ITEMS_INFO/WGBEZ"/>
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
                                 <xsl:if test="E1EDP19[QUALF = '004']">
                                    <ManufacturerPartID>
                                       <xsl:value-of select="E1EDP19[QUALF = '004']/MFRPN"/>
                                    </ManufacturerPartID>
                                 </xsl:if>
                                 <xsl:if test="E1EDP19[QUALF = '004']">
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
                                             <xsl:value-of select="E1ARBCIG_PO_ITEMS_INFO/MFRNAME"/>
                                          </xsl:when>
                                          <!--  IG-20131 End-->                                         
                                          <xsl:otherwise>
                                             <xsl:value-of select="E1EDP19[QUALF = '004']/MFRNR"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                       <!--  IG-16312 End-->
                                    </ManufacturerName>
                                 </xsl:if>                                 
                                 <xsl:if test="E1EDP19[QUALF = '003']">
                                    <ItemDetailIndustry>
                                       <!-- S4HANA check for IDTNR and IDTNR_LONG -->
                                       <ItemDetailRetail>
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space(E1EDP19[QUALF = '003']/IDTNR_LONG))>0">
                                                <EANID>
                                                   <xsl:value-of select="E1EDP19[QUALF = '003']/IDTNR_LONG"/>
                                                </EANID>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <EANID>
                                                   <xsl:value-of select="E1EDP19[QUALF = '003']/IDTNR"/>
                                                </EANID>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </ItemDetailRetail>
                                    </ItemDetailIndustry>
                                 </xsl:if>
                                 <xsl:if test="string-length(normalize-space(E1ARBCIG_PO_ITEMS_INFO/WEBAZ))>0">
                                    <PlannedAcceptanceDays>
                                       <xsl:value-of select="E1ARBCIG_PO_ITEMS_INFO/WEBAZ"/>
                                    </PlannedAcceptanceDays>
                                 </xsl:if>
                                 <xsl:if test="E1ARBCIG_ACC_INFO[1]/KNTTP">
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'AccountCategory'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1ARBCIG_ACC_INFO[1]/KNTTP"/>
                                    </Extrinsic>
                                 </xsl:if>
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'ReceivingType'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                       <xsl:when test="E1ARBCIG_PO_ITEMS_INFO/WEBRE='X'">
                                          <xsl:value-of select="$v_empty"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="'4'"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </Extrinsic>
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'extLineNumber'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="POSEX"/>
                                 </Extrinsic>
                                 
                                 <!-- CI-1761 For STO Orders do not Map hideUnitPrice and hideAmount -->
                                 <xsl:if test="not(exists(../E1EDK01/E1ARBCIG_HDR/STO_TYPE))">
                                 <!-- Defect Fix IG-9895 Start --> 
                                 <xsl:if test="E1ARBCIG_ACC_INFO and not(E1ARBCIG_ACC_INFO/PRSDR='X')">
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'hideUnitPrice'"/></xsl:attribute>
                                    </Extrinsic>
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'hideAmount'"/>
                                       </xsl:attribute>
                                    </Extrinsic>
                                 </xsl:if> 
                                 </xsl:if>
                                 <!-- Defect Fix IG-9895 End -->                                  
                              </ItemDetail>
                           </xsl:if>
                           <xsl:if test="(PSTYP = '1') or (PSTYP = '9')">
                              <BlanketItemDetail>
                                 <xsl:if test="E1EDP19[QUALF = '001']">
                                    <Description>
                                       <xsl:attribute name="xml:lang">
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1EDP19[QUALF = '001']/KTEXT"/>
                                    </Description>
                                 </xsl:if>
                                 <xsl:if test="not(E1ARBCIG_ACC_INFO[1]/SUMNOLIM = 'X')"> <!-- Defect Fix CI-10681-->  <!-- IG-25155 Corrected to SUMNOLIM FROM SUMNOLIMIT-->
                                 <MaxAmount>
                                    <xsl:choose>
                                       <xsl:when test="VPREI">
                                          <xsl:choose>
                                             <xsl:when test="(E1ARBCIG_ACC_INFO[1]/SUMLIMIT)!=''">
                                                <Money>
                                                   <xsl:attribute name="currency">
                                                      <xsl:value-of select="../E1EDK01/CURCY"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="format-number(E1ARBCIG_ACC_INFO[1]/SUMLIMIT,'0.00')"/>
                                                </Money>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <Money>
                                                   <xsl:attribute name="currency">
                                                      <xsl:value-of select="../E1EDK01/CURCY"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="VPREI"/>
                                                </Money>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_empty"/>
                                          </Money>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </MaxAmount>                                    
                                 </xsl:if><!-- Defect Fix CI-10681--> 
                                 <xsl:if test="(E1ARBCIG_CONTRACT_INFO[1]/LIMIT) > 0"> 
                                    <MaxContractAmount>
                                       <xsl:choose>
                                          <xsl:when test="VPREI">
                                             <xsl:choose>
                                                <xsl:when test="(E1ARBCIG_CONTRACT_INFO[1]/LIMIT)> 0 ">
                                                   <Money>
                                                      <xsl:attribute name="currency">
                                                         <xsl:value-of select="../E1EDK01/CURCY"/>
                                                      </xsl:attribute>
                                                      <xsl:value-of select="format-number(E1ARBCIG_CONTRACT_INFO[1]/LIMIT,'0.00')"/>
                                                   </Money>
                                                </xsl:when>
                                             </xsl:choose>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                   <xsl:value-of select="../E1EDK01/CURCY"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="$v_empty"/>
                                             </Money>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </MaxContractAmount>
                                 </xsl:if>
                                 <xsl:if test="(E1ARBCIG_CONTRACT_INFO[1]/RESTLIMIT) > 0"> 
                                    <MaxAdhocAmount>
                                       <xsl:choose>
                                          <xsl:when test="VPREI">
                                             <xsl:choose>
                                                <xsl:when test="(E1ARBCIG_CONTRACT_INFO[1]/RESTLIMIT) > 0 ">
                                                   <Money>
                                                      <xsl:attribute name="currency">
                                                         <xsl:value-of select="../E1EDK01/CURCY"/>
                                                      </xsl:attribute>
                                                      <xsl:value-of select="format-number(E1ARBCIG_CONTRACT_INFO[1]/RESTLIMIT,'0.00')"/>
                                                   </Money>
                                                </xsl:when>
                                               <!-- <xsl:otherwise>
                                                   <Money>
                                                      <xsl:attribute name="currency">
                                                         <xsl:value-of select="../E1EDK01/CURCY"/>
                                                      </xsl:attribute>
                                                      <xsl:value-of select="VPREI"/>
                                                   </Money>
                                                </xsl:otherwise>-->
                                             </xsl:choose>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                   <xsl:value-of select="../E1EDK01/CURCY"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="$v_empty"/>
                                             </Money>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </MaxAdhocAmount>
                                 </xsl:if>
                                 <MaxQuantity>
                                    <xsl:value-of
                                       select="(format-number(MENGE, '0.000'))"/>
                                 </MaxQuantity>
                                 <MinQuantity>
                                    <xsl:value-of
                                       select="(format-number(MENGE, '0.000'))"/>
                                 </MinQuantity>
                                 <UnitPrice>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(VPREI))>0">
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="VPREI"/>
                                          </Money>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_empty"/>
                                          </Money>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </UnitPrice>
                                 <UnitOfMeasure>
                                    <xsl:call-template name="UOMTemplate_Out">
                                       <xsl:with-param name="p_UOMinput"
                                                       select="MENEE"/>
                                       <xsl:with-param name="p_anERPSystemID"
                                                       select="$anERPSystemID"/>
                                       <xsl:with-param name="p_anSupplierANID"
                                                       select="$anSupplierANID"/>
                                    </xsl:call-template>
                                 </UnitOfMeasure>
                                 <xsl:if test="(format-number(PEINH,'0.000') !='0.000')">
                                    <PriceBasisQuantity>
                                       <xsl:attribute name="quantity">
                                          <xsl:value-of select="PEINH"/>
                                       </xsl:attribute>
                                       <xsl:attribute name="conversionFactor">
                                          <xsl:value-of select="BPUMZ div BPUMN"/>
                                       </xsl:attribute>
                                       <UnitOfMeasure>
                                          <xsl:call-template name="UOMTemplate_Out">
                                             <xsl:with-param name="p_UOMinput"
                                                             select="PMENE"/>
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
                                    <xsl:value-of select="MATKL"/>
                                 </Classification>
                                 <!--  IG-20131 Begin-->
                                 <!--  Use String length to check if value exists -->
                                 <xsl:if test="string-length(E1ARBCIG_PO_ITEMS_INFO/WGBEZ) > 0">
                                    <Classification>
                                       <xsl:attribute name="domain">
                                          <xsl:value-of select="'ERPCommodityCodeDescription'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1ARBCIG_PO_ITEMS_INFO/WGBEZ"/>
                                    </Classification>
                                 </xsl:if>
                                 <!--  IG-20131 End-->                                 
                                 <!--  IG-16312 End-->
                                 <xsl:if test="E1ARBCIG_ACC_INFO[1]/KNTTP">
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'AccountCategory'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1ARBCIG_ACC_INFO[1]/KNTTP"/>
                                    </Extrinsic>
                                 </xsl:if>
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'ReceivingType'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                       <xsl:when test="E1ARBCIG_PO_ITEMS_INFO/WEBRE='X'">
                                          <xsl:value-of select="$v_empty"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="'4'"/></xsl:otherwise>
                                    </xsl:choose>
                                 </Extrinsic>
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'extLineNumber'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="POSEX"/>
                                 </Extrinsic>
                                 <xsl:if test="(string-length(E1ARBCIG_ACC_INFO[1]/SUMNOLIM)=0) and (string-length(E1ARBCIG_ACC_INFO[1]/SUMLIMIT ) > 0)">
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'MaximumUnplanned'"/>
                                       </xsl:attribute>
                                       <Money>
                                          <xsl:attribute name="currency">
                                             <xsl:value-of select="../E1EDK01/CURCY"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="E1ARBCIG_ACC_INFO[1]/SUMLIMIT"/>
                                       </Money>
                                    </Extrinsic>
                                 </xsl:if>
                                 <xsl:if test="(string-length(normalize-space(E1ARBCIG_ACC_INFO[1]/COMMITMENT)) > 0)">
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'ExpectedUnplanned'"/>
                                       </xsl:attribute>
                                       <Money>
                                          <xsl:attribute name="currency">
                                             <xsl:value-of select="../E1EDK01/CURCY"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="E1ARBCIG_ACC_INFO[1]/COMMITMENT"/>
                                       </Money>
                                    </Extrinsic>
                                 </xsl:if>
                              </BlanketItemDetail>
                           </xsl:if>
                           <xsl:if test="E1EDPA1[PARVW = 'WE']">
                              <ShipTo>                                 
                                 <Address>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/ISOAL))>0">
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
                                       <xsl:value-of select="E1EDPA1[PARVW = 'WE']/LIFNR"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="addressIDDomain">
                                       <xsl:value-of select="'buyerLocationID'"/>
                                    </xsl:attribute>
                                    <Name>
                                       <xsl:call-template name="FillLangOut">
                                          <xsl:with-param name="p_spras_iso"
                                                          select="E1EDPA1[PARVW = 'WE']/SPRAS_ISO"/>
                                          <xsl:with-param name="p_spras"
                                                          select="E1EDPA1[PARVW = 'WE']/SPRAS"/>
                                          <xsl:with-param name="p_lang"
                                                          select="$v_defaultLang"/>
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
                                          <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION)) >0 ">
                                             <!-- Defect fix IG-32258, remove header shipto clause -->
                                             <!--or string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) > 0 ">-->
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION)) >0">
                                                   <State>
                                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION"/>
                                                   </State>
                                                </xsl:when>
                                                <!-- Defect fix IG-32258, remove header shipto clause -->
                                                <!--<xsl:otherwise>
                                                   <State>
                                                      <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                                                   </State>
                                                </xsl:otherwise>-->
                                             </xsl:choose>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/REGIO)) >0">
                                                   <State>
                                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/REGIO"/>
                                                   </State>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <State/>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                       <PostalCode>
                                          <xsl:value-of select="E1EDPA1[PARVW = 'WE']/PSTLZ"/>
                                       </PostalCode>
                                       <Country>
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/ISOAL))>0">
                                                <xsl:attribute name="isoCountryCode">
                                                   <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ISOAL"/>
                                                </xsl:attribute>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:choose>
                                                   <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/LAND1))>0">
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
                                    <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SMTP_ADDR)) > 0">
                                       <Email>
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'default'"/>
                                          </xsl:attribute>
                                          <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SPRAS_ISO)) > 0">
                                             <xsl:attribute name="preferredLang" select="lower-case(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SPRAS_ISO)"/>                                         
                                          </xsl:if>
                                          <xsl:value-of select="lower-case(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/SMTP_ADDR)"/>
                                       </Email>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/TELF1))>0">
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
                                                <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO))>0">
                                                   <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO"/> 
                                                </xsl:if>
                                                <!-- CI-1984 --> 
                                             </CountryCode>
                                             <AreaOrCityCode/>
                                             <xsl:if test="E1EDPA1[PARVW = 'WE']">
                                                <Number>
                                                   <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELF1"/>
                                                </Number>                                             
                                                <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEXT)) > 0">
                                                <Extension>
                                                   <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEXT"/>
                                                </Extension>
                                             </xsl:if>
                                             </xsl:if>
                                          </TelephoneNumber>
                                       </Phone>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/TELFX))>0">
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
                                                   <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/ISOAL))>0">
                                                      <xsl:attribute name="isoCountryCode">
                                                         <xsl:value-of select="E1EDPA1[PARVW = 'WE']/ISOAL"/>
                                                      </xsl:attribute>
                                                   </xsl:when>
                                                   <xsl:otherwise>
                                                      <xsl:choose>
                                                         <xsl:when test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/LAND1))>0">
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
                                                <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO))>0">
                                                   <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO"/> 
                                                </xsl:if>
                                                <!-- CI-1984 --> 
                                             </CountryCode>
                                             <AreaOrCityCode/>
                                             <xsl:if test="E1EDPA1[PARVW = 'WE']">
                                                <Number>
                                                   <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFX"/>
                                                </Number>
                                                <xsl:if test="string-length(normalize-space(E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFEXT)) > 0">
                                                   <Extension>
                                                      <xsl:value-of select="E1EDPA1[PARVW = 'WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFEXT"/>
                                                   </Extension>
                                                </xsl:if>
                                             </xsl:if>
                                          </TelephoneNumber>
                                       </Fax>
                                    </xsl:if>
                                 </Address>
                                 <IdReference>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="E1EDPA1[PARVW = 'WE']/LIFNR"/>
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
                           <xsl:if test="$v_sloc_level = 'L' and not(E1EDPA1[PARVW='WE'])">
                              <ShipTo>                              
                                 <Address>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                          <xsl:attribute name="isoCountryCode">
                                             <xsl:value-of select="$v_ship/ISOAL"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:attribute name="isoCountryCode">
                                             <xsl:value-of select="$v_ship/LAND1"/>
                                          </xsl:attribute>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:attribute name="addressID">
                                       <xsl:value-of select="$v_ship/LIFNR"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="addressIDDomain">
                                       <xsl:value-of select="'buyerLocationID'"/>
                                    </xsl:attribute>
                                    <Name>
                                       <xsl:call-template name="FillLangOut">
                                          <xsl:with-param name="p_spras_iso"
                                             select="$v_ship/SPRAS_ISO"/>
                                          <xsl:with-param name="p_spras"
                                             select="$v_ship/SPRAS"/>
                                          <xsl:with-param name="p_lang"
                                             select="$v_defaultLang"/>
                                       </xsl:call-template>
                                       <xsl:value-of select="$v_ship/NAME1"/>
                                    </Name>  
                                    <PostalAddress>
                                       <!-- Defect fix IG-32258, take the correct xpath -->
                                       <xsl:for-each select="../E1EDKA1/E1ARBCIG_PARTNER_INFO[DELIVER_TO = 'X']">                                       
                                          <xsl:if test="string-length(normalize-space(NAME_CO)) > 0">
                                             <DeliverTo>
                                                <xsl:value-of select="NAME_CO"/>
                                             </DeliverTo>
                                          </xsl:if>
                                          <xsl:if
                                             test="string-length(normalize-space(BUILDING)) > 0 or string-length(normalize-space(FLOOR)) > 0 or string-length(normalize-space(ROOMNUMBER)) > 0">
                                             <DeliverTo>
                                                <xsl:value-of select="normalize-space(replace(concat(BUILDING, ',', FLOOR, ',', ROOMNUMBER), '^,+', ''))"/>
                                             </DeliverTo>
                                          </xsl:if>
                                       </xsl:for-each>
                                       <Street>
                                          <xsl:value-of select="$v_ship/STRAS"/>
                                       </Street>
                                       <City>
                                          <xsl:value-of select="$v_ship/ORT01"/>
                                       </City>
                                       <xsl:if test="$v_ship">
                                          <Municipality>
                                             <xsl:value-of select="$v_ship/ORT02"/>
                                          </Municipality>
                                       </xsl:if>
                                       <xsl:choose>
                                          <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) >0 or string-length(normalize-space($v_ship/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION)) > 0">
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) >0">
                                                   <State>
                                                      <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                                                   </State>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <State>
                                                      <xsl:value-of select="$v_ship/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION"/>
                                                   </State>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_ship/REGIO)) >0">
                                                   <State>
                                                      <xsl:value-of select="$v_ship/REGIO"/>
                                                   </State>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <State/>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                       <PostalCode>
                                          <xsl:value-of select="$v_ship/PSTLZ"/>
                                       </PostalCode>
                                       <Country>
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                                <xsl:attribute name="isoCountryCode">
                                                   <xsl:value-of select="$v_ship/ISOAL"/>
                                                </xsl:attribute>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:choose>
                                                   <xsl:when test="string-length(normalize-space($v_ship/LAND1))>0">
                                                      <xsl:attribute name="isoCountryCode">
                                                         <xsl:value-of select="$v_ship/LAND1"/>
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
                                       <xsl:if test="string-length(normalize-space(NAME_CO)) > 0 or string-length(normalize-space(BUILDING)) > 0 or string-length(normalize-space(FLOOR)) > 0 or string-length(normalize-space(ROOMNUMBER)) > 0">
                                          <Name>                                        
                                             <xsl:attribute name="xml:lang">
                                                <xsl:call-template name="FillLangOut">
                                                   <xsl:with-param name="p_spras_iso"
                                                      select="LANGU_ISO"/>
                                                   <xsl:with-param name="p_spras"
                                                      select="LANGU"/>
                                                   <xsl:with-param name="p_lang"
                                                      select="$v_defaultLang"/>
                                                </xsl:call-template>  
                                             </xsl:attribute>                                          
                                             <xsl:value-of select="'default'"/>
                                          </Name>      
                                       </xsl:if>                                                               
                                    </PostalAddress>
                                    <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/SMTP_ADDR)) > 0">
                                       <Email>                                       
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'default'"/>
                                          </xsl:attribute>
                                          <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/SPRAS_ISO)) > 0">
                                             <xsl:attribute name="preferredLang">
                                                <xsl:value-of select="lower-case($v_ship/E1ARBCIG_PARTNER_INFO/SPRAS_ISO)"/>
                                             </xsl:attribute>
                                          </xsl:if>
                                          <xsl:value-of select="lower-case($v_ship/E1ARBCIG_PARTNER_INFO/SMTP_ADDR)"/>
                                       </Email>
                                    </xsl:if>
                                    <xsl:if test="$v_ship/TELF1">
                                       <Phone>
                                          <TelephoneNumber>
                                             <CountryCode>
                                                <xsl:choose>
                                                   <!-- CI-1984 --> 
                                                   <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                      <xsl:attribute name="isoCountryCode">
                                                        <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                                      </xsl:attribute>
                                                   </xsl:when>
                                                   <!-- CI-1984 -->
                                                   <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                                      <xsl:attribute name="isoCountryCode">
                                                         <xsl:value-of select="$v_ship/ISOAL"/>
                                                      </xsl:attribute>
                                                   </xsl:when>
                                                   <xsl:otherwise>
                                                      <xsl:choose>
                                                         <xsl:when test="string-length(normalize-space($v_ship/LAND1))>0">
                                                            <xsl:attribute name="isoCountryCode">
                                                               <xsl:value-of select="$v_ship/LAND1"/>
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
                                                <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                                   <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/> 
                                                </xsl:if>
                                                <!-- CI-1984 -->
                                             </CountryCode>
                                             <AreaOrCityCode/>
                                             <xsl:if test="$v_ship">
                                                <Number>
                                                   <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELF1"/>
                                                </Number>
                                                <xsl:if
                                                   test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELEXT)) > 0">
                                                   <Extension>
                                                      <xsl:value-of
                                                         select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEXT"/>
                                                   </Extension>
                                                </xsl:if>
                                             </xsl:if>
                                          </TelephoneNumber>
                                       </Phone>
                                    </xsl:if>
                                    <xsl:if test="$v_ship/TELFX">
                                       <Fax>
                                          <TelephoneNumber>
                                             <CountryCode>
                                                <xsl:choose>
                                                   <!-- CI-1984 --> 
                                                   <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1))>0">
                                                      <xsl:attribute name="isoCountryCode">
                                                        <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TEL_LAND1"/>
                                                      </xsl:attribute>
                                                   </xsl:when>
                                                   <!-- CI-1984 -->
                                                   <xsl:when test="string-length(normalize-space($v_ship/ISOAL))>0">
                                                      <xsl:attribute name="isoCountryCode">
                                                         <xsl:value-of select="$v_ship/ISOAL"/>
                                                      </xsl:attribute>
                                                   </xsl:when>
                                                   <xsl:otherwise>
                                                      <xsl:choose>
                                                         <xsl:when test="string-length(normalize-space($v_ship/LAND1))>0">
                                                            <xsl:attribute name="isoCountryCode">
                                                               <xsl:value-of select="$v_ship/LAND1"/>
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
                                                <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO))>0">
                                                   <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELEFTO"/> 
                                                </xsl:if>
                                                <!-- CI-1984 -->
                                             </CountryCode>
                                             <AreaOrCityCode/>
                                             <xsl:if test="$v_ship/TELFX">
                                                <Number>
                                                   <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELFX"/>
                                                </Number>
                                                <xsl:if test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/TELFEXT)) > 0">
                                                   <Extension>
                                                      <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/TELFEXT"/>
                                                   </Extension>
                                                </xsl:if>
                                             </xsl:if>
                                          </TelephoneNumber>
                                       </Fax>
                                    </xsl:if>
                                 </Address>
                                 <IdReference>                                 
                                    <xsl:attribute name="identifier" select="$v_ship/LIFNR"/>                                
                                    <xsl:attribute name="domain">
                                       <xsl:value-of select="'buyerLocationID'"/>
                                    </xsl:attribute> <!-- IG-18863: removed single quotes around buyerLocationID -->
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
                           <!--IG-30965 : Consider only those E1EDP04 segments that has a value in MWSBT-->
                           <!--IG-35393 : Removing format-number-->
                           <xsl:if test="(E1EDP04/MWSKZ) and (E1EDP04[string-length(normalize-space(MWSBT)) > 0])">
                              <Tax>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="../E1EDK01/CURCY"/>
                                    </xsl:attribute>
                                    <!--<xsl:value-of select="sum(E1EDP04/MWSBT)"/>-->
                                    <!--IG-30965 : For more than 4 values of MESBT, the SUM operator rsults a long decimal value. Hence above statement is now formatted as below below -->
                                    <xsl:variable name="v_sum">
                                       <xsl:variable name="v_temp_sum" select="sum(E1EDP04[string-length(normalize-space(MWSBT)) > 0]/MWSBT)"/>
                                             <!-- IG-41595 -->
                                             <xsl:value-of select="format-number($v_temp_sum, '0.00')"/>
                                             <!-- IG-41595 -->
                                    </xsl:variable>
                                    <!--IG-30965 : Format function does not remove the '-' sign if the value is '-0.00'. To avoid any unexpected behaviour, '-0.00' is translated to '0.00'-->
                                    <xsl:choose>
                                       <xsl:when test="$v_sum = '-0.00'">0.00</xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="$v_sum"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </Money>
                                 <Description>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:attribute>
                                 </Description>
                                 <xsl:for-each select="E1EDP04">
                                    <TaxDetail>
                                       <xsl:attribute name="category">
                                          <xsl:value-of select="MWSKZ"/>
                                       </xsl:attribute>
                                       <xsl:attribute name="percentageRate">
                                          <xsl:value-of select="MSATZ"/>
                                       </xsl:attribute>
                                       <TaxAmount>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="MWSBT"/>           <!-- IG-34699 -->
                                          </Money>
                                       </TaxAmount>
                                    </TaxDetail>
                                 </xsl:for-each>
                              </Tax>
                           </xsl:if>      
                           <!-- IG-35393 -->
                           <xsl:if test="PSTYP = '9'">
                              <SpendDetail>
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'GenericServiceCategory'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$v_empty"/>
                                 </Extrinsic>                                 
                              </SpendDetail>
                           </xsl:if>
                           <xsl:variable name="v_dist">
                              <xsl:value-of select="POSEX"/>
                           </xsl:variable>
                           <xsl:for-each select="E1ARBCIG_ACC_INFO[(EBELP=$v_dist) and string-length(normalize-space(SAKTO)) > 0 and string-length($v_acc) = 0]">
                              <Distribution>
                                 <Accounting>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'DistributionCharge'"/>
                                    </xsl:attribute>
                                    <xsl:if test="(string-length(normalize-space(SAKTO)) > 0)">
                                       <AccountingSegment>
                                          <xsl:attribute name="id">
                                             <xsl:value-of select="SAKTO"/>
                                          </xsl:attribute>
                                          <Name>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="'GeneralLedger'"/>
                                          </Name>
                                          <Description>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_id"/>
                                          </Description>
                                       </AccountingSegment>
                                    </xsl:if>
                                    <xsl:if test="(string-length(normalize-space(KOSTL)) > 0)">
                                       <AccountingSegment>
                                          <xsl:attribute name="id">
                                             <xsl:value-of select="KOSTL"/>
                                          </xsl:attribute>
                                          <Name>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="'CostCenter'"/>
                                          </Name>
                                          <Description>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_id"/>
                                          </Description>
                                       </AccountingSegment>
                                    </xsl:if>
                                    <xsl:if test="(string-length(AUFNR) > 0)">
                                       <AccountingSegment>
                                          <xsl:attribute name="id">
                                             <xsl:value-of select="AUFNR"/>
                                          </xsl:attribute>
                                          <Name>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:choose>                                                
                                                <!-- CI-1420 Work Order Integration -->
                                                <xsl:when test="WOIND = 'X'">
                                                   <xsl:value-of select="'WorkOrder'"/>
                                                </xsl:when>
                                                <xsl:otherwise>      
                                                   <xsl:value-of select="'InternalOrder'"/>
                                                </xsl:otherwise>   
                                             </xsl:choose>
                                          </Name>
                                          <Description>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_id"/>
                                          </Description>
                                       </AccountingSegment>
                                    </xsl:if>
                                    <xsl:if test="(string-length(normalize-space(PS_PSP_PNR)) > 0)">
                                       <AccountingSegment>
                                          <xsl:attribute name="id">
                                             <xsl:value-of select="PS_PSP_PNR"/>
                                          </xsl:attribute>
                                          <Name>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="'WBSElement'"/>
                                          </Name>
                                          <Description>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_id"/>
                                          </Description>
                                       </AccountingSegment>
                                    </xsl:if>
                                    <xsl:if test="(string-length(ANLN1) > 0)">
                                       <AccountingSegment>
                                          <xsl:attribute name="id">
                                             <xsl:value-of select="ANLN1"/>
                                          </xsl:attribute>
                                          <Name>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="'Asset'"/>
                                          </Name>
                                          <Description>
                                             <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="$v_id"/>
                                          </Description>
                                       </AccountingSegment>
                                    </xsl:if>
                                    <AccountingSegment>
                                       <xsl:choose>
                                          <xsl:when test="string-length(normalize-space(DISTR_PERC))=0">
                                             <xsl:attribute name="id">
                                                <xsl:value-of select="'0.00'"/>
                                             </xsl:attribute>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:attribute name="id">
                                                <xsl:value-of select="format-number(DISTR_PERC,'0.00')"/>
                                             </xsl:attribute>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                       <Name>
                                          <xsl:attribute name="xml:lang">
                                             <xsl:value-of select="$v_defaultLang"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="DISTRIB"/>
                                       </Name>
                                       <Description>
                                          <xsl:attribute name="xml:lang">
                                             <xsl:value-of select="$v_defaultLang"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="DISTRIB"/>
                                       </Description>
                                    </AccountingSegment>
                                 </Accounting>
                                 <Charge>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(../VPREI))>0">
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(MENGE)) > 0">
                                                   <xsl:value-of select="format-number(MENGE * (((../BPUMZ * ((../VPREI) div (../PEINH))) div (../BPUMN))),'0.00')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:value-of select="'0.00'"/>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </Money>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="../../E1EDK01/CURCY"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="'0.00'"/>
                                          </Money>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </Charge>
                              </Distribution>
                              
                           </xsl:for-each>
                           <xsl:if test="string-length(normalize-space(E1ARBCIG_PO_ITEMS_INFO/MRP_NAME)) > 0">
                              <Contact>
                                 <xsl:attribute name="role">
                                    <xsl:value-of select="'BuyerPlannerCode'"/></xsl:attribute>
                                 <Name>
                                    <xsl:call-template name="FillLangOut">
                                       <xsl:with-param name="p_spras_iso"
                                          select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS_ISO"/>
                                       <xsl:with-param name="p_spras"
                                          select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS"/>
                                       <xsl:with-param name="p_lang"
                                          select="$v_defaultLang"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="E1ARBCIG_PO_ITEMS_INFO/MRP_NAME"/>
                                 </Name>
                                    <IdReference>
                                       <xsl:attribute name="identifier">
                                          <xsl:value-of select="E1ARBCIG_PO_ITEMS_INFO/MRP_CNTL"/> 
                                       </xsl:attribute>
                                       <xsl:attribute name="domain">
                                          <xsl:value-of select="'BuyerPlannerCode'"/> 
                                       </xsl:attribute>    
                                       <Description>
                                          <xsl:call-template name="FillLangOut">
                                             <xsl:with-param name="p_spras_iso"
                                                select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS_ISO"/>
                                             <xsl:with-param name="p_spras"
                                                select="$v_vendor/E1ARBCIG_PARTNER_INFO/SPRAS"/>
                                             <xsl:with-param name="p_lang"
                                                select="$v_defaultLang"/>
                                          </xsl:call-template>
                                          <xsl:value-of select="E1ARBCIG_PO_ITEMS_INFO/MRP_NAME"/> 
                                       </Description>
                                    </IdReference>
                              </Contact>
                           </xsl:if>                           
                           <xsl:if test="(E1EDP17 and E1EDP17[QUALF = '001'])">
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
                                       <xsl:value-of select="E1EDP17[QUALF = '001']/LKOND"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="E1ARBCIG_ACC_INFO[1]/BEZEI"/>
                                 </TransportTerms>
                                 <xsl:if test="string-length(normalize-space(E1EDP17[QUALF = '001']/LKTEXT))>0">
                                    <Address>
                                       <Name>
                                          <xsl:attribute name="xml:lang">
                                             <xsl:value-of select="$v_defaultLang"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="E1EDP17[QUALF = '001']/LKTEXT"/>
                                       </Name>
                                    </Address>
                                 </xsl:if>
                              </TermsOfDelivery>
                           </xsl:if>
                           <xsl:variable name="v_att_line">
                              <xsl:for-each select="$v_attach[LINENUMBER!='']">                                 
                                 <xsl:value-of select="'1'"/>                                 
                              </xsl:for-each>   
                           </xsl:variable>
                           <xsl:if test="string-length(normalize-space($v_att_line)) > 0 or (E1EDPT1)">			   
                              <!--  IG-24207 Begin-->
                              <!--<Comments>
                              <xsl:call-template name="CommentsFillIdocOutPO">
                                 <xsl:with-param name="p_aribaComment"
                                                 select="E1EDPT1"/>
                                 <xsl:with-param name="p_itemNumber"
                                                 select="POSEX"/>
                                 <xsl:with-param name="p_doctype"
                                                 select="$anTargetDocumentType"/>
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
                                 <xsl:with-param name="p_aribaComment" select="E1EDPT1"/>
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
                           <xsl:variable name="v_uom">
                              <xsl:value-of select="MENEE"/>
                           </xsl:variable>
                          <xsl:if test="exists(E1ARBCIG_PURCH_CSC)">
                           <ControlKeys>
                              <xsl:if test="not(../../E1EDK01/ACTION = '03')">
                                 <OCInstruction>
                                    <xsl:choose>
                                       <xsl:when test="E1ARBCIG_PURCH_CSC[1]/CONF_CTRL='A'">
                                          <xsl:attribute name="value">
                                             <xsl:value-of select="'allowed'"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="E1ARBCIG_PURCH_CSC[1]/CONF_CTRL='R'">
                                          <xsl:attribute name="value">
                                             <xsl:value-of select="'requiredBeforeASN'"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="E1ARBCIG_PURCH_CSC[1]/CONF_CTRL='N'">
                                          <xsl:attribute name="value">
                                             <xsl:value-of select="'notAllowed'"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:attribute name="value">
                                             <xsl:value-of select="'notAllowed'"/>
                                          </xsl:attribute>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <Lower>
                                       <Tolerances>
                                          <xsl:if test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_LOW))>0">
                                             <QuantityTolerance>
                                                <Percentage>
                                                   <xsl:attribute name="percent">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_LOW"/>
                                                   </xsl:attribute>
                                                </Percentage>
                                             </QuantityTolerance>
                                          </xsl:if>
                                          <xsl:if test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/PRICE_LIMIT_LOW))>0">
                                             <PriceTolerance>
                                                <Percentage>
                                                   <xsl:attribute name="percent">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/PRICE_LIMIT_LOW"/>
                                                   </xsl:attribute>
                                                </Percentage>                                                                                             
                                             </PriceTolerance>
                                          </xsl:if>
                                          <xsl:if test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_LOW)) >0">
                                             <TimeTolerance>
                                                <xsl:attribute name="limit">
                                                   <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_LOW"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="type">
                                                   <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT"/>
                                                </xsl:attribute>
                                             </TimeTolerance>
                                          </xsl:if>   
                                        <!--  <xsl:choose>
                                             <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_LOW))>0">
                                                <TimeTolerance>
                                                   <xsl:attribute name="limit">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_LOW"/>
                                                   </xsl:attribute>
                                                   <xsl:attribute name="type">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT"/>
                                                   </xsl:attribute>
                                                </TimeTolerance>                                                   
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <TimeTolerance>
                                                   <xsl:attribute name="limit">
                                                      <xsl:value-of select="000"/>
                                                   </xsl:attribute>
                                                   <xsl:choose>
                                                      <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT))>0">
                                                         <xsl:attribute name="type">
                                                            <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT"/>
                                                         </xsl:attribute>
                                                      </xsl:when>
                                                      <xsl:otherwise>
                                                         <xsl:attribute name="type">days</xsl:attribute>
                                                      </xsl:otherwise>
                                                   </xsl:choose>   
                                                </TimeTolerance>                                                       
                                             </xsl:otherwise>
                                          </xsl:choose>               -->                          
                                       </Tolerances>
                                    </Lower>
                                   
                                       <Upper>
                                          <Tolerances>
                                             <xsl:if test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_UP))>0">
                                                <QuantityTolerance>
                                                   <Percentage>
                                                      <xsl:attribute name="percent">
                                                         <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_UP"/>
                                                      </xsl:attribute>
                                                   </Percentage>
                                                </QuantityTolerance>
                                             </xsl:if>
                                             <xsl:if test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/PRICE_LIMIT_HIGH))>0">
                                                <PriceTolerance>
                                                   <Percentage>
                                                      <xsl:attribute name="percent">
                                                         <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/PRICE_LIMIT_HIGH"/>
                                                      </xsl:attribute>
                                                   </Percentage>
                                                </PriceTolerance>
                                             </xsl:if>
<!--                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UP))>0">
                                                   <TimeTolerance>
                                                      <xsl:attribute name="limit">
                                                         <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UP"/>
                                                      </xsl:attribute>
                                                      <xsl:attribute name="type">
                                                         <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT"/>
                                                      </xsl:attribute>
                                                   </TimeTolerance>                                                   
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <TimeTolerance>
                                                      <xsl:attribute name="limit">
                                                         <xsl:value-of select="000"/>
                                                      </xsl:attribute>
                                                      <xsl:choose>
                                                         <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT))>0">
                                                            <xsl:attribute name="type">
                                                               <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT"/>
                                                            </xsl:attribute>
                                                         </xsl:when>
                                                         <xsl:otherwise>
                                                            <xsl:attribute name="type">days</xsl:attribute>
                                                         </xsl:otherwise>
                                                      </xsl:choose>   
                                                   </TimeTolerance>                                                       
                                                </xsl:otherwise>
                                             </xsl:choose> -->                                            
                                             <xsl:if test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UP))>0">
                                                <TimeTolerance>
                                                   <xsl:attribute name="limit">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UP"/>
                                                   </xsl:attribute>
                                                   <xsl:attribute name="type">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/TIME_LIMIT_UNIT"/>
                                                   </xsl:attribute>
                                                </TimeTolerance>
                                             </xsl:if>                                          
                                          </Tolerances>
                                       </Upper>
                                 </OCInstruction>
                                 <ASNInstruction>
                                    <xsl:choose>
                                       <xsl:when test="E1ARBCIG_PURCH_CSC[1]/ASN_CTRL ='A'">
                                          <xsl:attribute name="value">
                                             <xsl:value-of select="'allowed'"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="E1ARBCIG_PURCH_CSC[1]/ASN_CTRL ='N'">
                                          <xsl:attribute name="value">
                                             <xsl:value-of select="'notAllowed'"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:attribute name="value">
                                             <xsl:value-of select="'notAllowed'"/>
                                          </xsl:attribute>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    <Lower>
                                       <Tolerances>
                                          <xsl:if
                                             test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_LOW)) > 0">
                                             <QuantityTolerance>
                                                <Percentage>
                                                   <xsl:attribute name="percent">
                                                      <xsl:value-of
                                                         select="E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_LOW"/>
                                                   </xsl:attribute>
                                                </Percentage>
                                             </QuantityTolerance>
                                          </xsl:if>
                                          <xsl:if
                                             test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_LOW)) > 0">
                                             <TimeTolerance>
                                                <xsl:attribute name="limit">
                                                   <xsl:value-of
                                                      select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_LOW"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="type">
                                                   <xsl:value-of
                                                      select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT"/>
                                                </xsl:attribute>
                                             </TimeTolerance>
                                          </xsl:if>
                                      <!--    <xsl:choose>
                                             <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_LOW))>0">
                                                <TimeTolerance>
                                                   <xsl:attribute name="limit">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_LOW"/>
                                                   </xsl:attribute>
                                                   <xsl:attribute name="type">
                                                      <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT"/>
                                                   </xsl:attribute>
                                                </TimeTolerance>                                                   
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <TimeTolerance>
                                                   <xsl:attribute name="limit">
                                                      <xsl:value-of select="000"/>
                                                   </xsl:attribute>
                                                   <xsl:choose>
                                                      <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT))>0">
                                                         <xsl:attribute name="type">
                                                            <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT"/>
                                                         </xsl:attribute>
                                                      </xsl:when>
                                                      <xsl:otherwise>
                                                         <xsl:attribute name="type">days</xsl:attribute>
                                                      </xsl:otherwise>
                                                   </xsl:choose>   
                                                </TimeTolerance>                                                       
                                             </xsl:otherwise>
                                          </xsl:choose>     -->
                                       </Tolerances>
                                    </Lower>
                                   
                                       <Upper>
                                          <Tolerances>
                                             <xsl:if
                                                test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_UP)) > 0">
                                                <QuantityTolerance>
                                                   <Percentage>
                                                      <xsl:attribute name="percent">
                                                         <xsl:value-of
                                                            select="E1ARBCIG_PURCH_CSC[1]/QUAN_LIMIT_UP"/>
                                                      </xsl:attribute>
                                                   </Percentage>
                                                </QuantityTolerance>
                                             </xsl:if>
                                             <xsl:if
                                                test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UP)) > 0">
                                                <TimeTolerance>
                                                   <xsl:attribute name="limit">
                                                      <xsl:value-of
                                                         select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UP"/>
                                                   </xsl:attribute>
                                                   <xsl:attribute name="type">
                                                      <xsl:value-of
                                                         select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT"/>
                                                   </xsl:attribute>
                                                </TimeTolerance>
                                             </xsl:if>
<!--                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UP))>0">
                                                   <TimeTolerance>
                                                      <xsl:attribute name="limit">
                                                         <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UP"/>
                                                      </xsl:attribute>
                                                      <xsl:attribute name="type">
                                                         <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT"/>
                                                      </xsl:attribute>
                                                   </TimeTolerance>                                                   
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <TimeTolerance>
                                                      <xsl:attribute name="limit">
                                                         <xsl:value-of select="000"/>
                                                      </xsl:attribute>
                                                      <xsl:choose>
                                                         <xsl:when test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT))>0">
                                                            <xsl:attribute name="type">
                                                               <xsl:value-of select="E1ARBCIG_PURCH_CSC[1]/ASN_TIME_LIMIT_UNIT"/>
                                                            </xsl:attribute>
                                                         </xsl:when>
                                                         <xsl:otherwise>
                                                            <xsl:attribute name="type">days</xsl:attribute>
                                                         </xsl:otherwise>
                                                      </xsl:choose>   
                                                   </TimeTolerance>                                                       
                                                </xsl:otherwise>
                                             </xsl:choose>-->
                                          </Tolerances>
                                       </Upper>
                                 </ASNInstruction>
                                 <InvoiceInstruction>
                                    <xsl:if test="E1ARBCIG_PURCH_CSC[1]/IS_ERS ='X'">
                                       <xsl:attribute name="value">
                                          <xsl:value-of select="'isERS'"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/IS_ERS)) =0">
                                       <xsl:attribute name="value">
                                          <xsl:value-of select="'isNotERS'"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <!-- CI-1761 InvoiceInstruction mapped as notAllowed for STO -->
                                    <xsl:if test="string-length(normalize-space(../E1EDK01/E1ARBCIG_HDR/STO_TYPE))>0">
                                       <xsl:attribute name="value">
                                          <xsl:value-of select="'notAllowed'"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <!-- CI-1761 -->
                                    <xsl:if
                                       test="E1ARBCIG_PO_ITEMS_INFO[EBELP = ../POSEX]/WEBRE = 'X'">
                                       <xsl:attribute name="verificationType">
                                          <xsl:value-of select="'goodsReceipt'"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="(E1ARBCIG_PURCH_CSC[1]/IS_ERS !='X') and (string-length(normalize-space(E1ARBCIG_PURCH_CSC[1]/IS_ERS))>0)">
                                       <xsl:attribute name="value">
                                          <xsl:value-of select="'isNotERS'"/>
                                       </xsl:attribute>
                                    </xsl:if>
                                    <xsl:for-each select="E1ARBCIG_PO_ITEMS_INFO">
                                       <xsl:if test="SCHPR ='X'">
                                          <TemporaryPrice>
                                             <xsl:attribute name="value">
                                                <xsl:value-of select="'yes'"/>
                                             </xsl:attribute>
                                          </TemporaryPrice>
                                       </xsl:if>
                                    </xsl:for-each>
                                 </InvoiceInstruction>
                                 <!-- Defect Fix CI-10681 Start --> 
                                 <xsl:if test="not(E1ARBCIG_ACC_INFO/WEBRE='X' or E1ARBCIG_ACC_INFO/LEBRE='X' or E1ARBCIG_ACC_INFO/WEPOS='X')">
                                    <SESInstruction>
                                       <xsl:attribute name="value">
                                          <xsl:value-of select="'notAllowed'"/>
                                       </xsl:attribute>
                                    </SESInstruction>
                                 </xsl:if> 
                                 <!-- Defect Fix CI-10681 End --> 
                              </xsl:if>
                           </ControlKeys>
                          </xsl:if>
                           <xsl:for-each select="E1ARBCIG_SCHED_LINE[EBELP=../POSEX]">
                              <ScheduleLine>
                                 <xsl:attribute name="quantity">
                                    <xsl:value-of select="MENGE"/>
                                 </xsl:attribute>
                                 <xsl:variable name="v_uzeit_sch">
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(UZEIT))>0 and (UZEIT) != '000000'">     
                                          <xsl:value-of select="UZEIT"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="'120000'"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:variable>
                                 <xsl:attribute name="requestedDeliveryDate">
                                    <xsl:if test="(string-length(normalize-space(EINDT)) > 0)">
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(../E1ARBCIG_PO_ITEMS_INFO/PLANT_TIMEZONE)) > 0">
                                          <xsl:call-template name="ANDateTime">
                                             <xsl:with-param name="p_date" select="EINDT"/>
                                             <xsl:with-param name="p_time" select="$v_uzeit_sch"/>
                                             <xsl:with-param name="p_timezone" select="../E1ARBCIG_PO_ITEMS_INFO/PLANT_TIMEZONE"/>
                                          </xsl:call-template>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:call-template name="ANDateTime">
                                             <xsl:with-param name="p_date"
                                                select="EINDT"/>
                                             <xsl:with-param name="p_time"
                                                select="$v_uzeit_sch"/>
                                             <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                          </xsl:call-template>                                          
                                       </xsl:otherwise>
                                    </xsl:choose>
                                    </xsl:if>
                                 </xsl:attribute>
                                 <xsl:attribute name="lineNumber">
                                    <xsl:value-of select="ETENR"/>
                                 </xsl:attribute>
                                 <xsl:variable name="v_schd">
                                    <xsl:value-of select="ETENR"/>
                                 </xsl:variable>    
                                 <xsl:choose>
                                    <xsl:when test="LPEIN = '2'"><!--Weekly-->                                       
                                       <xsl:attribute name="deliveryWindow" select="'P7D'"/>                                           
                                    </xsl:when>
                                    <xsl:when test="LPEIN = '3'"><!--Monthly-->
                                       <xsl:attribute name="deliveryWindow" select="'P1M'"/>                                                               
                                    </xsl:when>
                                    <!--<xsl:otherwise/>-->
                                 </xsl:choose>
                                 <UnitOfMeasure>
                                    <xsl:call-template name="UOMTemplate_Out">
                                       <xsl:with-param name="p_UOMinput"
                                                       select="$v_uom"/>
                                       <xsl:with-param name="p_anERPSystemID"
                                                       select="$anERPSystemID"/>
                                       <xsl:with-param name="p_anSupplierANID"
                                                       select="$anSupplierANID"/>
                                    </xsl:call-template>
                                 </UnitOfMeasure>                                 
                                 <xsl:if test="not(../../E1EDK01/ACTION = '03')">
                                    <xsl:for-each select="../E1ARBCIG_PURCH_CSC[SCHED_LINE = $v_schd]">
                                       <SubcontractingComponent>
                                          <xsl:attribute name="quantity">
                                             <xsl:choose>
                                                <xsl:when test="ENTRY_QUANTITY != ''">
                                                   <xsl:value-of select="ENTRY_QUANTITY"/>
                                                </xsl:when>
                                                <xsl:otherwise>0.0</xsl:otherwise>
                                             </xsl:choose>                                             
                                          </xsl:attribute>
                                          <xsl:variable name="v_uzeit_reqDate">
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_uzeit_sc))>0">
                                                   <xsl:value-of select="$v_uzeit_sc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:value-of select="'120000'"/>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:variable>
                                          <xsl:attribute name="requirementDate">
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(../E1ARBCIG_PO_ITEMS_INFO/PLANT_TIMEZONE)) > 0">
                                                   <xsl:call-template name="ANDateTime">
                                                      <xsl:with-param name="p_date" select="REQ_DATE"/>
                                                      <xsl:with-param name="p_time" select="$v_uzeit_reqDate"/>
                                                      <xsl:with-param name="p_timezone" select="../E1ARBCIG_PO_ITEMS_INFO/PLANT_TIMEZONE"/>
                                                   </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                   <xsl:if test="(string-length(normalize-space(REQ_DATE)) > 0)">
                                                      <xsl:call-template name="ANDateTime">
                                                         <xsl:with-param name="p_date"
                                                            select="REQ_DATE"/>
                                                         <xsl:with-param name="p_time"
                                                            select="$v_uzeit_reqDate"/>
                                                         <xsl:with-param name="p_timezone"
                                                            select="$anERPTimeZone"/>
                                                      </xsl:call-template>
                                                   </xsl:if>                                                   
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </xsl:attribute>
                                          <ComponentID>
                                             <xsl:value-of select="concat(PO_ITEM, '_', SCHED_LINE, '_', COMPONENT_NO)"/>
                                          </ComponentID>
                                          <UnitOfMeasure>
                                             <!-- Start of IG-29155 Add ISO UoM  -->
                                             <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(ENTRY_UOM_ISO)) &gt; 0">
                                                   <xsl:call-template name="UOMTemplate_Out">
                                                      <xsl:with-param name="p_UOMinput"
                                                         select="ENTRY_UOM_ISO"/>
                                                      <xsl:with-param name="p_anERPSystemID"
                                                         select="$anERPSystemID"/>
                                                      <xsl:with-param name="p_anSupplierANID"
                                                         select="$anSupplierANID"/>
                                                   </xsl:call-template>
                                                </xsl:when>
                                                <!-- End of IG-29155 Add ISO UoM  -->
                                                <xsl:otherwise>
                                                   <xsl:call-template name="UOMTemplate_Out">
                                                      <xsl:with-param name="p_UOMinput"
                                                         select="ENTRY_UOM"/>
                                                      <xsl:with-param name="p_anERPSystemID"
                                                         select="$anERPSystemID"/>
                                                      <xsl:with-param name="p_anSupplierANID"
                                                         select="$anSupplierANID"/>
                                                   </xsl:call-template>
                                                </xsl:otherwise>
                                             </xsl:choose>
                                          </UnitOfMeasure>   
                                          <Description>
                                             <xsl:call-template name="FillLangOut">
                                                <xsl:with-param name="p_spras_iso"
                                                                select="LANGU_ISO"/>
                                                <xsl:with-param name="p_spras"
                                                                select="LANGU"/>
                                                <xsl:with-param name="p_lang"
                                                                select="$v_defaultLang"/>
                                             </xsl:call-template>
                                             <xsl:value-of select="DESCRIPTION"/>
                                          </Description>
                                          <xsl:if test="MATERIAL != ''">
                                          <Product>
                                             <BuyerPartID>
                                                <xsl:value-of select="MATERIAL"/>
                                             </BuyerPartID>
                                          </Product>
                                          </xsl:if>
                                          <xsl:if test="BATCH != ''">
                                          <Batch>
                                             <BuyerBatchID>
                                                <xsl:value-of select="BATCH"/>
                                             </BuyerBatchID>
                                          </Batch>
                                          </xsl:if>
                                       </SubcontractingComponent>
                                       <xsl:choose>
                                          <xsl:when test="LPEIN = '2'"><!--Weekly-->
                                             <DeliveryWindow>P7D</DeliveryWindow>
                                          </xsl:when>
                                          <xsl:when test="LPEIN = '3'"><!--Monthly-->
                                             <DeliveryWindow>P1M</DeliveryWindow>
                                          </xsl:when>
                                          <!--<xsl:otherwise/>-->
                                       </xsl:choose>
                                    </xsl:for-each>
                                 </xsl:if>
                              </ScheduleLine>
                           </xsl:for-each>
                           <xsl:if test="(E1EDP02 and E1EDP02[QUALF = '005'])">
                              <MasterAgreementIDInfo>
                                 <xsl:attribute name="agreementID">
                                    <xsl:value-of select="E1EDP02[QUALF = '005']/BELNR"/>
                                 </xsl:attribute>
                              </MasterAgreementIDInfo>
                           </xsl:if>            
                           <!--QualityManagement-->                         
                           <!-- IG-28159 -->
                           <!-- Aviod ItemOutIndustry tag generation if QM_PROCUREMENT_FLAG or Serial number or QM_CNTRL_KEY  is empty -->
                           <!-- Because Empty ItemOutIndustry Order will cause issue when it is used as a reference in Quality Notification -->
                           <xsl:if test="E1ARBCIG_PURCH_CSC/QM_PROCUREMENT_FLAG = 'X' or E1ARBCIG_PO_ITEMS_INFO/XCHPF = 'X' or string-length(normalize-space(E1ARBCIG_PO_ITEMS_INFO[SERNO = 'X'])) > 0
                              or E1ARBCIG_PO_ITEMS_INFO/RTCONS = 'X' or E1ARBCIG_PO_ITEMS_INFO/HUFLAG = 'X' or string-length(normalize-space(E1ARBCIG_ASSET_INFO))>0
                              or string-length(normalize-space(E1ARBCIG_PO_ITEMS_INFO[XCHPF = 'X']))>0">
                               <ItemOutIndustry>
                                  <xsl:if test="E1ARBCIG_PO_ITEMS_INFO/RTCONS = 'X'">
                                     <xsl:attribute name="requiresRealTimeConsumption" select="'yes'"/>
                                  </xsl:if>
                                  <xsl:if test="E1ARBCIG_PO_ITEMS_INFO/HUFLAG = 'X'">
                                     <xsl:attribute name="isHUMandatory" select="'yes'"/>
                                  </xsl:if>
                                 <xsl:if test="exists(E1ARBCIG_PURCH_CSC/QM_PROCUREMENT_FLAG) and E1ARBCIG_PURCH_CSC/QM_PROCUREMENT_FLAG = 'X'">                              
                                    <QualityInfo>                                 
                                       <xsl:attribute name="requiresQualityProcess" select="'yes'"/>                                 
                                       <!--controlCode-->
                                       <xsl:if test="exists(E1ARBCIG_PURCH_CSC/QM_CNTRL_KEY) and not(exists(E1ARBCIG_PURCH_CSC/QM_CERT_FLAG))">
                                       <IdReference>
                                          <xsl:attribute name="identifier" select="(E1ARBCIG_PURCH_CSC/QM_CNTRL_KEY)[1]"/>                  <!--IG-28073_Quality_Certificate_text_repeats_incorrectly-->
                                          <xsl:attribute name="domain" select="'controlCode'"/>
                                       </IdReference>
                                       </xsl:if>
                                       <xsl:if test="exists(E1ARBCIG_PURCH_CSC/QM_CONTROLKEY) and not(exists(E1ARBCIG_PURCH_CSC/QM_CERT_FLAG))">
                                          <IdReference>
                                             <xsl:attribute name="identifier" select="(E1ARBCIG_PURCH_CSC/QM_CONTROLKEY)[1]"/>              <!--IG-28073_Quality_Certificate_text_repeats_incorrectly-->
                                             <xsl:attribute name="domain" select="'controlCodeDesc'"/>
                                          </IdReference>
                                       </xsl:if>
                                       <!--certificateType-->
                                       <xsl:if test="exists(E1ARBCIG_PURCH_CSC/QM_CERTIFICATE_TYPE) and exists(E1ARBCIG_PURCH_CSC/QM_CERT_FLAG)">
                                             <CertificateInfo isRequired="yes">
                                                <IdReference>
                                                   <xsl:attribute name="identifier" select="(E1ARBCIG_PURCH_CSC/QM_CERTIFICATE_TYPE)[1]"/>  <!--IG-28073_Quality_Certificate_text_repeats_incorrectly-->
                                                   <xsl:attribute name="domain" select="'certificateType'"/>
                                                </IdReference>
                                             </CertificateInfo>
                                          </xsl:if>
                                       <xsl:if test="not(exists(E1ARBCIG_PURCH_CSC/QM_CERT_FLAG)) and (exists(E1ARBCIG_PURCH_CSC/QM_CERTIFICATE_TYPE))">
                                                <IdReference>
                                                   <xsl:attribute name="identifier" select="(E1ARBCIG_PURCH_CSC/QM_CERTIFICATE_TYPE)[1]"/> <!--IG-28073_Quality_Certificate_text_repeats_incorrectly-->
                                                   <xsl:attribute name="domain" select="'certificateType'"/>
                                                </IdReference>
                                          </xsl:if>
                                    </QualityInfo>
                                 </xsl:if>
                                 <!-- Serial Info addition -->
                                 <xsl:if test="E1ARBCIG_PO_ITEMS_INFO[SERNO = 'X']">
                                    <SerialNumberInfo>
                                       <xsl:attribute name="requiresSerialNumber">
                                          <xsl:value-of select="'yes'"/>
                                       </xsl:attribute>
                                       <xsl:if test="exists(E1ARBCIG_SERNR_INFO/E1ARBCIG_SERNR)">
                                          <xsl:attribute name="type">
                                             <xsl:value-of select="'list'"/>
                                          </xsl:attribute>
                                          <xsl:for-each select="E1ARBCIG_SERNR_INFO/E1ARBCIG_SERNR">
                                             <SerialNumber>
                                                <xsl:value-of select="GERNR"/>
                                             </SerialNumber>
                                         </xsl:for-each>
                                       </xsl:if>
                                    </SerialNumberInfo>
                                 </xsl:if>
                                 <!-- Batch Info addition -->
                                 <xsl:if test="E1ARBCIG_PO_ITEMS_INFO[XCHPF = 'X']">
                                    <BatchInfo>                                 
                                       <xsl:attribute name="requiresBatch">
                                          <xsl:value-of select="'yes'"/>
                                       </xsl:attribute>                                 
                                    </BatchInfo>
                                 </xsl:if>
                                 <!-- IG-41746 -->
                                  <!-- CI-1420 Work Order Integration -->
                                  <xsl:for-each select="E1ARBCIG_ASSET_INFO">                                     
                                     <AssetInfo>
                                        <xsl:attribute name="equipmentId">                                           
                                           <xsl:value-of select="EQUNR"/>                                           
                                        </xsl:attribute>
                                     </AssetInfo>                                     
                                  </xsl:for-each>                            
                                  <!-- IG-28159 --> 
                                 <!-- IG-41746 -->
                              </ItemOutIndustry> 
                           </xsl:if>
                           <!-- IG-41746 -->
                        </ItemOut>
                     </xsl:for-each>
                     <!-- Service PO ItemOut Details -->
                     <xsl:for-each select="/ARBCIG_ORDERS/IDOC/E1EDP01/E1EDC01">
                        <xsl:if test="POSEX !='0000000000'">
                           <ItemOut>
                              <xsl:variable name="v_srvmapkey">
                                 <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/SRVMAPKEY"/>
                              </xsl:variable>
                              <xsl:variable name="v_parentlineno">
                                 <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/PARENT_LINE"/>
                              </xsl:variable>
                              <xsl:choose>
                                 <!-- If it is a Service Line  -->
                                 <xsl:when test="SGTYP='002'">
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(MENGE)) > 0">
                                          <xsl:attribute name="quantity">
                                             <xsl:value-of select="format-number(MENGE,'0.000')"/>
                                          </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:attribute name="quantity">
                                             <xsl:value-of select="'0.0'"/>
                                          </xsl:attribute>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:when>
                                 <!-- If it is a Outline Info  -->
                                 <xsl:otherwise>
                                    <xsl:attribute name="quantity">
                                       <xsl:value-of select="'1.0'"/>
                                    </xsl:attribute>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <xsl:attribute name="lineNumber">
                                 <xsl:choose>
                                    <!--IG-32446 : Check the length of SrvMapKey along with the First character value-->
                                    <xsl:when test="(string-length($v_srvmapkey) = 10) and (substring($v_srvmapkey,1,1)='5')">
                                       <xsl:value-of select="concat(1,substring($v_srvmapkey,2))"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:choose>
                                          <!--IG-35917 : Check the length of SrvMapKey along with the Fourth character value not zero-->
                                          <xsl:when test="string-length(normalize-space($v_srvmapkey)) > 5 and substring(normalize-space($v_srvmapkey), 5, 1) = '5' and substring($v_srvmapkey,1,1) = '0'
                                             and substring($v_srvmapkey,4,1) = '0' ">
                                             <xsl:value-of	select="concat(substring($v_srvmapkey,1,4),1,substring($v_srvmapkey,6))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="$v_srvmapkey"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:variable name="v_poLineCheck">
                                 <xsl:if test="exists(/ARBCIG_ORDERS/IDOC/E1EDP01[POSEX = $v_parentlineno])">
                                    <xsl:value-of select="'X'"/>
                                 </xsl:if>
                              </xsl:variable>
                              <xsl:attribute name="parentLineNumber">
                                 <xsl:choose>
                           <!--Do not convert parentLine if its a main PO Line number-->
                                    <xsl:when test="string-length(normalize-space($v_poLineCheck)) > 0">
                                       <xsl:value-of select="$v_parentlineno"/>
                                    </xsl:when>
                                    <!--IG-32446 : Check the length of SrvMapKey along with the First character value-->
                                    <xsl:when test="(string-length($v_parentlineno) = 10) and (substring($v_parentlineno, 1, 1) = '5')">
                                             <xsl:value-of
                                                select="concat(1, substring($v_parentlineno, 2))"/>                                                                                
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:choose>
                                          <!--IG-35917 : Check parent linealong with the First characterand 4th  value not to be zero-->
                                          <xsl:when test="string-length(normalize-space($v_parentlineno)) > 5 and substring(normalize-space($v_parentlineno), 5, 1) = '5' and substring($v_parentlineno, 1, 1) = '0'
                                             and substring($v_parentlineno,4,1) = '0'">
                                             <xsl:value-of	select="concat(substring($v_parentlineno,1,4),1,substring($v_parentlineno,6))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="$v_parentlineno"/> 
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <!-- If it is a Outline Info  -->
                              <xsl:choose>
                                 <xsl:when test="SGTYP='001'">
                                    <xsl:attribute name="itemType">
                                       <xsl:value-of select="'composite'"/>
                                    </xsl:attribute>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:attribute name="itemType">
                                       <xsl:value-of select="'item'"/>
                                    </xsl:attribute>
                                 </xsl:otherwise>
                              </xsl:choose>
                              <!-- If it is a Outline Info  -->
                              <xsl:if test="SGTYP='001' and (../E1ARBCIG_ACC_INFO/WEBRE = 'X' or  ../E1ARBCIG_ACC_INFO/LEBRE = 'X')">
                                 <xsl:attribute name="requiresServiceEntry">
                                    <xsl:value-of select="'yes'"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <!-- Mapping Item category as service for service line item   -->     
                              <xsl:attribute name="itemClassification">
                                 <xsl:value-of select="'service'"/>
                              </xsl:attribute>
                              <ItemID>
                                 <!-- S4HANA check for IDTNR and IDTNR_LONG -->
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1EDC19[QUALF='032']/IDTNR_LONG))>0">
                                       <SupplierPartID>
                                          <xsl:value-of select="E1EDC19[QUALF='032']/IDTNR_LONG"/>
                                       </SupplierPartID>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <SupplierPartID>
                                          <xsl:value-of select="E1EDC19[QUALF='032']/IDTNR"/>
                                       </SupplierPartID>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <xsl:if test="E1EDC19[QUALF='031']">
                                    <!-- S4HANA check for IDTNR and IDTNR_LONG -->
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(E1EDC19[QUALF='031']/IDTNR_LONG))>0">
                                          <BuyerPartID>
                                             <xsl:value-of select="E1EDC19[QUALF='031']/IDTNR_LONG"/>
                                          </BuyerPartID>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <BuyerPartID>
                                             <xsl:value-of select="E1EDC19[QUALF='031']/IDTNR"/>
                                          </BuyerPartID>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:if>
                              </ItemID>
                              <!-- If it is a Service Line  -->
                              <xsl:if test="SGTYP='002'">
                                 <ItemDetail>
                                    <UnitPrice>
                                       <xsl:choose>
                                          <xsl:when test="VPREI!=0">
                                             <Money>
                                                <xsl:attribute name="currency">
                                                   <xsl:value-of select="CURCY"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="VPREI"/>
                                             </Money>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <Money>
                                                <xsl:attribute name="currency">
                                                   <xsl:value-of select="../../E1EDK01/CURCY"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="'0.00'"/>
                                             </Money>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </UnitPrice>
                                    <Description>
                                       <xsl:call-template name="FillLangOut">
                                          <xsl:with-param name="p_spras_iso"
                                                          select="$v_bill/SPRAS_ISO"/>
                                          <xsl:with-param name="p_spras"
                                                          select="$v_bill/SPRAS"/>
                                          <xsl:with-param name="p_lang"
                                                          select="$v_defaultLang"/>
                                       </xsl:call-template>
                                       <xsl:value-of select="KTXT1"/>
                                    </Description>
                                    <UnitOfMeasure>
                                       <xsl:call-template name="UOMTemplate_Out">
                                          <xsl:with-param name="p_UOMinput"
                                                          select="MENEE"/>
                                          <xsl:with-param name="p_anERPSystemID"
                                                          select="$anERPSystemID"/>
                                          <xsl:with-param name="p_anSupplierANID"
                                                          select="$anSupplierANID"/>
                                       </xsl:call-template>
                                    </UnitOfMeasure>
                                    <!-- IG-35604 -->
                                    <!--Check Condition to generate PriceBasisQuantity Tag -->
                                    <xsl:if test="(string-length(normalize-space(PEINH))> 0 ) and (format-number(PEINH,'0.000') != '0.000') and (string-length(MENEE) > 0)">
                                       <PriceBasisQuantity>
                                          <xsl:attribute name="quantity">
                                             <xsl:value-of select="format-number(PEINH,'0.000')"/>
                                          </xsl:attribute>
                                          <xsl:attribute name="conversionFactor">1</xsl:attribute>
                                          <UnitOfMeasure>
                                             <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput"
                                                                select="MENEE"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                                select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                                select="$anSupplierANID"/>
                                             </xsl:call-template>
                                          </UnitOfMeasure>
                                       </PriceBasisQuantity>
                                    </xsl:if>
                                    <Classification>
                                       <xsl:attribute name="domain">
                                          <xsl:value-of select="'UNSPSC'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="MATKL"/>
                                    </Classification>
                                    <!--  IG-16312 Begin-->
                                    <!--  Material Group will now be sent always with domain ERPCommodityCode -->
                                    <!--  Material Group will now be sent always with domain NotAvailable will not be sent -->
                                    <!--  Material Group description will now be always with domain ERPCommodityCodeDescription if present -->
                                    <Classification>
                                       <xsl:attribute name="domain">
                                          <xsl:value-of select="'ERPCommodityCode'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="MATKL"/>
                                    </Classification>
                                    <!--  IG-20131 Begin-->
                                    <!--  Use String length to check if value exists -->
                                    <xsl:if test="string-length(E1ARBCIG_SERVICE_INFO[1]/WGBEZ) > 0">
                                       <Classification>
                                          <xsl:attribute name="domain">
                                             <xsl:value-of select="'ERPCommodityCodeDescription'"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/WGBEZ"/>
                                       </Classification>
                                    </xsl:if>
                                    <!--  IG-20131 End-->                                    
                                    <!--  IG-16312 End-->
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'AccountCategory'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/KNTTP"/>
                                    </Extrinsic>
                                    <!-- If it is a OutLine Info  -->
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'extLineNumber'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/EXTROW"/>
                                       <!-- Defect fix IG-32258, remove clause SGTYP='001' since loop is inside SGTYP='002'  -->
                                       <!--<xsl:choose>
                                          <xsl:when test="SGTYP='001'">
                                             <xsl:value-of select="EXGRP"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/EXTROW"/>
                                          </xsl:otherwise>
                                       </xsl:choose>-->
                                    </Extrinsic>
                                    <xsl:if test="E1ARBCIG_SERVICE_INFO[1]/PAUSCH='X'">
                                       <Extrinsic>
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'AmountBasedReceiving'"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="'Yes'"/>
                                       </Extrinsic>
                                    </xsl:if>
                                    <xsl:if test="E1ARBCIG_SERVICE_INFO[1]/EVENTUAL='X'">
                                       <Extrinsic>
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'ContingencyReceiving'"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="'Yes'"/>
                                       </Extrinsic>
                                    </xsl:if>
                                    <xsl:if test="E1ARBCIG_SERVICE_INFO[1]/INFORM='X'">
                                       <Extrinsic>
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'InformationReceiving'"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="'Yes'"/>
                                       </Extrinsic>
                                    </xsl:if>
                                    <xsl:if test="E1ARBCIG_SERVICE_INFO[1]/PAUSCH='X'">
                                       <Extrinsic>
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'HideAmountBasedInfo'"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="'Yes'"/>
                                       </Extrinsic>
                                    </xsl:if>
                                 </ItemDetail>
                              </xsl:if>
                              <!-- If it is a OutLine Info  -->
                              <xsl:if test="SGTYP='001'">
                                 <BlanketItemDetail>
                                    <Description>
                                       <xsl:call-template name="FillLangOut">
                                          <xsl:with-param name="p_spras_iso"
                                                          select="$v_bill/SPRAS_ISO"/>
                                          <xsl:with-param name="p_spras"
                                                          select="$v_bill/SPRAS"/>
                                          <xsl:with-param name="p_lang"
                                                          select="$v_defaultLang"/>
                                       </xsl:call-template>
                                       <xsl:value-of select="KTXT1"/>
                                    </Description>
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'AccountCategory'"/>
                                       </xsl:attribute>
                                       <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/KNTTP"/>
                                    </Extrinsic>
                                    <Extrinsic>
                                       <xsl:attribute name="name">
                                          <xsl:value-of select="'extLineNumber'"/>
                                       </xsl:attribute>
                                       <xsl:choose>
                                          <xsl:when test="SGTYP='001'">
                                             <xsl:value-of select="EXGRP"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="E1ARBCIG_SERVICE_INFO[1]/EXTROW"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </Extrinsic>
                                 </BlanketItemDetail>
                              </xsl:if>
                              <xsl:if test="../E1EDPA1[PARVW='WE']">
                                 <ShipTo>
                                    <Address>
                                       <xsl:attribute name="addressID">
                                          <xsl:value-of select="../E1EDPA1[PARVW='WE']/LIFNR"/>
                                       </xsl:attribute>
                                       <Name>
                                          <xsl:call-template name="FillLangOut">
                                             <xsl:with-param name="p_spras_iso"
                                                             select="../E1EDPA1[PARVW='WE']/SPRAS_ISO"/>
                                             <xsl:with-param name="p_spras"
                                                             select="../E1EDPA1[PARVW='WE']/SPRAS"/>
                                             <xsl:with-param name="p_lang"
                                                             select="$v_defaultLang"/>
                                          </xsl:call-template>
                                          <xsl:value-of select="../E1EDPA1[PARVW='WE']/NAME1"/>
                                       </Name>
                                       <PostalAddress>
                                          <Street>
                                             <xsl:value-of select="../E1EDPA1[PARVW='WE']/STRAS"/>
                                          </Street>
                                          <City>
                                             <xsl:value-of select="../E1EDPA1[PARVW='WE']/ORT01"/>
                                          </City>
                                          <Municipality>
                                             <xsl:value-of select="../E1EDPA1[PARVW='WE']/ORT02"/>
                                          </Municipality>
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) >0 or string-length(normalize-space(../E1EDPA1[PARVW='WE']/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION)) > 0">
                                                <xsl:choose>
                                                   <xsl:when test="string-length(normalize-space($v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION)) >0">
                                                      <State>
                                                         <xsl:value-of select="$v_ship/E1ARBCIG_PARTNER_INFO/REGION_DESCRIPTION"/>
                                                      </State>
                                                   </xsl:when>
                                                   <xsl:otherwise>
                                                      <State>
                                                         <xsl:value-of select="../E1EDPA1[PARVW='WE']/E1ARBCIG_REGION_DESC/REGION_DESCRIPTION"/>
                                                      </State>
                                                   </xsl:otherwise>
                                                </xsl:choose>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:choose>
                                                   <xsl:when test="string-length(normalize-space($v_ship/REGIO)) >0">
                                                      <State>
                                                         <xsl:value-of select="$v_ship/REGIO"/>
                                                      </State>
                                                   </xsl:when>
                                                   <xsl:otherwise>
                                                      <State/>
                                                   </xsl:otherwise>
                                                </xsl:choose>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                          <PostalCode>
                                             <xsl:value-of select="../E1EDPA1[PARVW='WE']/PSTLZ"/>
                                          </PostalCode>
                                          <Country>
                                             <xsl:attribute name="isoCountryCode">
                                                <xsl:value-of select="../E1EDPA1[PARVW='WE']/LAND1"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="../E1EDPA1[PARVW='WE']/LAND1"/>
                                          </Country>
                                       </PostalAddress>
                                       <xsl:if test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/TELF1))>0">
                                          <Phone>
                                             <TelephoneNumber>
                                                <CountryCode>
                                                   <xsl:attribute name="isoCountryCode">
                                                      <!-- CI-1984 --> 
                                                      <xsl:choose>
                                                         <xsl:when test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1))>0">
                                                            <xsl:value-of select="../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1"/>
                                                         </xsl:when>                                        
                                                         <xsl:otherwise>
                                                            <xsl:value-of select="$v_empty"/>
                                                         </xsl:otherwise>
                                                      </xsl:choose>                                                  
                                                   </xsl:attribute>
                                                   <xsl:if test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO))>0">
                                                      <xsl:value-of select="../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO"/> 
                                                   </xsl:if>
                                                   <!-- CI-1984 -->
                                                </CountryCode>
                                                <AreaOrCityCode/>
                                                <Number>
                                                   <xsl:value-of select="../E1EDPA1[PARVW='WE']/TELF1"/>
                                                </Number>
                                                <!-- IG-30548 --> 
                                                <xsl:if test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEXT)) > 0">
                                                   <Extension>
                                                      <xsl:value-of select="../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEXT"/>
                                                   </Extension>
                                                </xsl:if>  
                                                <!-- IG-30548 --> 
                                             </TelephoneNumber>
                                          </Phone>
                                       </xsl:if>
                                       <xsl:if test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/TELFX))>0">
                                          <Fax>
                                             <TelephoneNumber>
                                                <CountryCode>
                                                   <xsl:attribute name="isoCountryCode">
                                                      <!-- CI-1984 --> 
                                                      <xsl:choose>
                                                         <xsl:when test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1))>0">
                                                            <xsl:value-of select="../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TEL_LAND1"/>
                                                         </xsl:when>                                        
                                                         <xsl:otherwise>
                                                            <xsl:value-of select="$v_empty"/>
                                                         </xsl:otherwise>
                                                      </xsl:choose>
                                                   </xsl:attribute>
                                                   <xsl:if test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO))>0">
                                                      <xsl:value-of select="../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELEFTO"/> 
                                                   </xsl:if>
                                                   <!-- CI-1984 -->
                                                </CountryCode>
                                                <AreaOrCityCode/>
                                                <Number>
                                                   <xsl:value-of select="../E1EDPA1[PARVW='WE']/TELFX"/>
                                                </Number>
                                                <!-- IG-30548 --> 
                                                <xsl:if test="string-length(normalize-space(../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFEXT)) > 0">
                                                   <Extension>
                                                      <xsl:value-of select="../E1EDPA1[PARVW='WE']/E1ARBCIG_PARTNER_INFO_ITM/TELFEXT"/>
                                                   </Extension>
                                                </xsl:if>  
                                                <!-- IG-30548 -->                                                  
                                             </TelephoneNumber>                                            
                                          </Fax>
                                       </xsl:if>
                                    </Address>
                                 </ShipTo>
                              </xsl:if>
                              <SpendDetail>
                                 <Extrinsic>
                                    <xsl:attribute name="name">
                                       <xsl:value-of select="'GenericServiceCategory'"/></xsl:attribute>
                                    <xsl:value-of select="'service'"/>
                                 </Extrinsic>
                              </SpendDetail>
                              <xsl:for-each select="E1ARBCIG_SERVICE_INFO">
                                 <xsl:if test="(KNTTP!='U' and SRVMAPKEY!='') and (string-length(normalize-space(INFORM))=0) and string-length(normalize-space(NETWR))>0 and string-length($v_acc) = 0">
                                    <Distribution>
                                       <Accounting>
                                          <xsl:attribute name="name">
                                             <xsl:value-of select="'DistributionCharge'"/>
                                          </xsl:attribute>
                                          <!-- Accounting Segment for GeneralLedger -->
                                          <xsl:if test="string-length(normalize-space(SAKTO)) > 0">
                                             <AccountingSegment>
                                                <xsl:attribute name="id">
                                                   <xsl:value-of select="SAKTO"/>
                                                </xsl:attribute>
                                                <Name>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="'GeneralLedger'"/>
                                                </Name>
                                                <Description>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="$v_id"/>
                                                </Description>
                                             </AccountingSegment>
                                          </xsl:if>
                                          <!-- Accounting Segment for CostCenter -->
                                          <xsl:if test="string-length(normalize-space(KOSTL)) > 0">
                                             <AccountingSegment>
                                                <xsl:attribute name="id">
                                                   <xsl:value-of select="KOSTL"/>
                                                </xsl:attribute>
                                                <Name>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="'CostCenter'"/>
                                                </Name>
                                                <Description>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="$v_id"/>
                                                </Description>
                                             </AccountingSegment>
                                          </xsl:if>
                                          <!-- Accounting Segment for InternalOrder -->
                                          <xsl:if test="string-length(normalize-space(AUFNR)) > 0">
                                             <AccountingSegment>
                                                <xsl:attribute name="id">
                                                   <xsl:value-of select="AUFNR"/>
                                                </xsl:attribute>
                                                <Name>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:choose>                                                      
                                                      <!-- CI-1420 Work Order Integration -->   
                                                      <xsl:when test="WOIND = 'X'">
                                                         <xsl:value-of select="'WorkOrder'"/>
                                                      </xsl:when>
                                                      <xsl:otherwise>      
                                                         <xsl:value-of select="'InternalOrder'"/>
                                                      </xsl:otherwise>   
                                                   </xsl:choose>
                                                </Name>
                                                <Description>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="$v_id"/>
                                                </Description>
                                             </AccountingSegment>
                                          </xsl:if>
                                          <!-- Accounting Segment for SAP Serial Number -->
                                          <xsl:if test="(string-length(ZEKKN) > 0)">
                                             <AccountingSegment>
                                                <xsl:attribute name="id">
                                                   <xsl:value-of select="ZEKKN"/>
                                                </xsl:attribute>
                                                <Name>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="'SAPSerialNumber'"/>
                                                </Name>
                                                <Description>
                                                   <xsl:attribute name="xml:lang"> 
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="'SAP Serial Number'"/>
                                                </Description>
                                             </AccountingSegment>
                                          </xsl:if>
                                          <!-- Accounting Segment for WBSElement -->
                                          <xsl:if test="string-length(normalize-space(PS_PSP_PNR)) > 0">
                                             <AccountingSegment>
                                                <xsl:attribute name="id">
                                                   <xsl:value-of select="PS_PSP_PNR"/>
                                                </xsl:attribute>
                                                <Name>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="'WBSElement'"/>
                                                </Name>
                                                <Description>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="$v_id"/>
                                                </Description>
                                             </AccountingSegment>
                                          </xsl:if>
                                          <!-- Accounting Segment for Asset -->
                                          <xsl:if test="string-length(normalize-space(ANLN1)) > 0">
                                             <AccountingSegment>
                                                <xsl:attribute name="id">
                                                   <xsl:value-of select="ANLN1"/>
                                                </xsl:attribute>
                                                <Name>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="'Asset'"/>
                                                </Name>
                                                <Description>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="$v_id"/>
                                                </Description>
                                             </AccountingSegment>
                                          </xsl:if>
                                          <!-- Accounting Segment for Distr Perce -->
                                          <xsl:if test="string-length(normalize-space(DISTR_PERC)) > 0">
                                             <AccountingSegment>
                                                <xsl:attribute name="id">
                                                   <xsl:value-of select="DISTR_PERC"/>
                                                </xsl:attribute>
                                                <Name>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                </Name>
                                                <Description>
                                                   <xsl:attribute name="xml:lang">
                                                      <xsl:value-of select="$v_defaultLang"/>
                                                   </xsl:attribute>
                                                   <xsl:value-of select="$v_id"/>
                                                </Description>
                                             </AccountingSegment>
                                          </xsl:if>
                                       </Accounting>
                                       <Charge>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="WAERS"/>
                                             </xsl:attribute>
                                             <xsl:value-of select="NETWR"/>
                                          </Money>
                                       </Charge>
                                    </Distribution>
                                    
                                    </xsl:if>
                              </xsl:for-each>                              
                           </ItemOut>
                        </xsl:if>
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
</xsl:stylesheet>
