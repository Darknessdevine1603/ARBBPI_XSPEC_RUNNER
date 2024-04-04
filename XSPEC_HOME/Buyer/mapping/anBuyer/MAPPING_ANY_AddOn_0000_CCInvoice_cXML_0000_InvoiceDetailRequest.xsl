<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/"
   exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes" />
   <xsl:param name="exchange"/>
   <xsl:param name="anSharedSecrete"/>
   <xsl:param name="ancxmlversion"/>
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="anContentID"/>
   <xsl:param name="anERPTimeZone"/>
   <xsl:param name="anERPSystemID"/>
   <xsl:param name="anIsMultiERP"/>
   <xsl:param name="anTargetDocumentType"/>
<!--      <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
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
   <xsl:template match="ARBCIG_FIDCC2/IDOC">
      <xsl:variable name="v_attach" select="E1FIKPF/E1ARBCIG_ATTACH_HDR_DET"/>      
      <xsl:variable name="v_vendorId">
         <xsl:value-of select="E1FIKPF/E1FISEG/E1FINBU/LIFNR"/>
      </xsl:variable>
      <xsl:variable name="v_curDate">
         <xsl:value-of select="current-dateTime()"/>
      </xsl:variable>
      <xsl:variable name="v_timestamp">
         <xsl:value-of select="concat(substring($v_curDate, 1, 19), substring($v_curDate, 24, 29))"/>
      </xsl:variable>
      <xsl:variable name="cXMLEnvelopeHeader">
         <xsl:choose>
            <xsl:when test="upper-case($anIsMultiERP) = 'TRUE'">
               <xsl:value-of
                  select="concat('&lt;cXML payloadID=&quot;', $anPayloadID, '&quot; timestamp=&quot;', $v_timestamp, '&quot; version=&quot;', $ancxmlversion, '&quot; xml:lang=&quot;en-US&quot;&gt; &lt;Header&gt;&lt;From&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anSupplierANID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;Credential domain=&quot;SystemID&quot;&gt;&lt;Identity&gt;', $anERPSystemID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/From&gt;&lt;To&gt;&lt;Credential domain=&quot;VendorID&quot;&gt;&lt;Identity&gt;', $v_vendorId, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/To&gt;&lt;Sender&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anProviderANID, '&lt;/Identity&gt;&lt;SharedSecret&gt;', $anSharedSecrete, '&lt;/SharedSecret&gt;&lt;/Credential&gt;&lt;UserAgent&gt;Ariba SN Buyer Adapter&lt;/UserAgent&gt;&lt;/Sender&gt;&lt;/Header&gt;')"
               />
            </xsl:when>
            <xsl:otherwise>
         <xsl:value-of
            select="concat('&lt;cXML payloadID=&quot;', $anPayloadID, '&quot; timestamp=&quot;', $v_timestamp, '&quot; version=&quot;', $ancxmlversion, '&quot; xml:lang=&quot;en-US&quot;&gt; &lt;Header&gt;&lt;From&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anSupplierANID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/From&gt;&lt;To&gt;&lt;Credential domain=&quot;VendorID&quot;&gt;&lt;Identity&gt;', $v_vendorId, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/To&gt;&lt;Sender&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anProviderANID, '&lt;/Identity&gt;&lt;SharedSecret&gt;', $anSharedSecrete, '&lt;/SharedSecret&gt;&lt;/Credential&gt;&lt;UserAgent&gt;Ariba SN Buyer Adapter&lt;/UserAgent&gt;&lt;/Sender&gt;&lt;/Header&gt;')"
         />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="cXMLEnvelopeRequest">
         <xsl:value-of
            select="concat('&lt;Request&gt; &lt;CopyRequest&gt; &lt;cXMLAttachment&gt; &lt;Attachment&gt;&lt;URL&gt;', 'cid:', $anContentID, '&lt;/URL&gt; &lt;/Attachment&gt; &lt;/cXMLAttachment&gt; &lt;/CopyRequest&gt; &lt;/Request&gt; &lt;/cXML&gt;')"
         />
      </xsl:variable>
      <xsl:variable name="cXMLEnvelope">
         <xsl:value-of select="concat($cXMLEnvelopeHeader, ' ', $cXMLEnvelopeRequest)"/>
      </xsl:variable>
      
      
      
         <Combined>
            <Payload>
               <cXML>
               <xsl:attribute name="payloadID">
                  <!-- Begin of IG-30211 -->
                  <xsl:choose>
                     <xsl:when test="string-length(E1FIKPF/E1ARBCIG_FIDCCHEADER/PAYLOADID) > 0">
                        <!-- IG 23032 Uniform Invoice ID -->                  
                        <xsl:value-of select="concat(E1FIKPF/E1ARBCIG_FIDCCHEADER/PAYLOADID, $v_timestamp)"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="concat($anPayloadID,$v_timestamp)"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- End of IG-30211 -->
               </xsl:attribute>
               <xsl:attribute name="timestamp">
                  <xsl:value-of select="$v_timestamp"/>
               </xsl:attribute>
               <Header>
                  <From>
                     <Credential domain="VendorID">
                        <Identity>
                           <xsl:value-of select="$v_vendorId"/>
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
                     <Correspondent>
                        <Contact role="correspondent">
                           <Name>
                              <xsl:attribute name="xml:lang">
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS)) > 0">
                                       <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>                              
                              <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/VENDOR_NAME"/>
                           </Name>
                           <Email name="routing">
                              <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/VENDOR_EMAIL"/>
                           </Email>
                        </Contact>
                     </Correspondent>
                  </From>
                  <To>
                     <!-- Multi ERP check-->
                     <xsl:call-template name="MultiERPTemplateOut">
                        <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                        <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                     </xsl:call-template>
                     <Credential domain="NetworkID">
                        <Identity>
                           <xsl:value-of select="$anSupplierANID"/>
                        </Identity>
                     </Credential>
                  </To>
                  <Sender>
                     <Credential domain="NetworkID">
                        <Identity>
                           <xsl:value-of select="$anSupplierANID"/>
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
                           <xsl:value-of select="'production'"/>
                        </xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:attribute name="deploymentMode">
                           <xsl:value-of select="'test'"/>
                        </xsl:attribute>
                     </xsl:otherwise>
                  </xsl:choose>
                  <InvoiceDetailRequest>
                     <InvoiceDetailRequestHeader>
                        <xsl:attribute name="invoiceID">
                           <!-- IG 23032 Uniform Invoice ID Begin -->
                           <xsl:choose>
                              <xsl:when test="E1FIKPF/E1ARBCIG_FIDCCHEADER/CXMLINVOICEID">
                                 <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CXMLINVOICEID"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:choose>
                                    <xsl:when test="E1FIKPF/E1ARBCIG_FIDCCHEADER/XBLNR = 'YES' and E1FIKPF/XBLNR ">
                                       <xsl:value-of select="E1FIKPF/XBLNR"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="E1FIKPF/BELNR"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:otherwise>
                           </xsl:choose> 
                           <!-- IG 23032 Uniform Invoice ID End -->
                        </xsl:attribute>
                        <xsl:attribute name="purpose">
                           <xsl:choose>
                              <xsl:when
                                 test="E1FIKPF/E1FISEG[1]/KOART = 'K' and E1FIKPF/E1FISEG[1]/SHKZG = 'H'"
                                 >
                                 <xsl:value-of select="'standard'"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="'creditMemo'"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="operation">
                           <xsl:value-of select="'new'"/>
                        </xsl:attribute>
                        <xsl:attribute name="invoiceDate">
                           <xsl:call-template name="ANDateTime">
                              <xsl:with-param name="p_date" select="E1FIKPF/BLDAT"/>
                              <xsl:with-param name="p_time" select="E1FIKPF/E1ARBCIG_FIDCCHEADER/INVOICE_TIME"/>
                              <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                           </xsl:call-template>
                        </xsl:attribute>
                        <!-- Changing the invoice Origin IG-20506 -->
                        <xsl:attribute name="invoiceOrigin">
                           <xsl:value-of select="'supplier'"/>
                        </xsl:attribute>
                        <InvoiceDetailHeaderIndicator/>
                        <InvoiceDetailLineIndicator/>
                        <InvoicePartner>
                           <Contact role="billTo">
                              <xsl:attribute name="addressID">
                                 <xsl:value-of select="E1FIKPF/BUKRS"/>
                              </xsl:attribute>
                              <xsl:attribute name="addressIDDomain" select="'billTo'"/>
                              <Name>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS)) > 0">
                                          <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <xsl:choose>
                                    <!-- IG-16810 Fix-->
                                    <xsl:when test="E1FIKPF/E1ARBCIG_FIDCCHEADER/COMPANY_NAME">
                                       <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/COMPANY_NAME"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/VENDOR_NAME"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- IG-16810 Fix-->
                              </Name>
                              <PostalAddress>
                                 <Street>
                                    <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CSTREET"/>
                                 </Street>
                                 <City>
                                    <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CCITY"/>
                                 </City>
                                 <State>
                                    <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CREGION"/>
                                 </State>
                                 <PostalCode>
                                    <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CPOSTAL_CODE"
                                    />
                                 </PostalCode>
                                 <Country>
                                    <xsl:attribute name="isoCountryCode">
                                       <xsl:value-of
                                          select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CCOUNTRYISO"/>
                                    </xsl:attribute>
                                 </Country>
                              </PostalAddress>
                              <Email>
                                 <xsl:attribute name="name" select="'default'"/>
                                 <!-- IG-16810 Fix-->
                                 <xsl:choose>
                                    <xsl:when test="E1FIKPF/E1ARBCIG_FIDCCHEADER/COMPANY_EMAIL">
                                       <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/COMPANY_EMAIL"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/VENDOR_EMAIL"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                                 <!-- IG-16810 Fix-->
                              </Email>
                              <xsl:if test="E1FIKPF/E1ARBCIG_FIDCCHEADER/CTEL_NUMBER">
                                 <Phone>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <xsl:value-of
                                                select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CCOUNTRYISO"/>
                                          </xsl:attribute>
                                       </CountryCode>
                                       <AreaOrCityCode/>
                                       <Number>
                                          <xsl:value-of
                                             select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CTEL_NUMBER"/>
                                       </Number>
                                       <Extension>
                                          <xsl:value-of
                                             select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CTEL_EXTENS"/>
                                       </Extension>
                                    </TelephoneNumber>
                                 </Phone>
                              </xsl:if>
                              <xsl:if test="E1FIKPF/E1ARBCIG_FIDCCHEADER/CFAX_NUMBER">
                                 <Fax>
                                    <TelephoneNumber>
                                       <CountryCode>
                                          <xsl:attribute name="isoCountryCode">
                                             <xsl:value-of
                                                select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CCOUNTRYISO"/>
                                          </xsl:attribute>
                                       </CountryCode>
                                       <AreaOrCityCode/>
                                       <Number>
                                          <xsl:value-of
                                             select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CFAX_NUMBER"/>
                                       </Number>
                                       <Extension>
                                          <xsl:value-of
                                             select="E1FIKPF/E1ARBCIG_FIDCCHEADER/CFAX_EXTENS"/>
                                       </Extension>
                                    </TelephoneNumber>
                                 </Fax>
                              </xsl:if>
                           </Contact>
                        </InvoicePartner>
                        <xsl:if test="not(E1FIKPF/E1FISEG/E1FINBU/ZBD1T = '0')">
                           <PaymentTerm>
                              <xsl:if test="E1FIKPF/E1FISEG/KOART = 'K'">
                                 <xsl:attribute name="payInNumberOfDays">
                                    <xsl:value-of select="E1FIKPF/E1FISEG/E1FINBU/ZBD1T"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <Discount>
                                 <DiscountPercent>
                                    <xsl:attribute name="percent">
                                       <xsl:value-of select="E1FIKPF/E1FISEG/E1FINBU/ZBD1P"/>
                                    </xsl:attribute>
                                 </DiscountPercent>
                              </Discount>
                           </PaymentTerm>
                        </xsl:if>
                        <xsl:if test="not(E1FIKPF/E1FISEG/E1FINBU/ZBD2T = '0')">
                           <PaymentTerm>
                              <xsl:if test="E1FIKPF/E1FISEG/KOART = 'K'">
                                 <xsl:attribute name="payInNumberOfDays">
                                    <xsl:value-of select="E1FIKPF/E1FISEG/E1FINBU/ZBD2T"/>
                                 </xsl:attribute>
                              </xsl:if>
                              <Discount>
                                 <DiscountPercent>
                                    <xsl:attribute name="percent">
                                       <xsl:value-of select="E1FIKPF/E1FISEG/E1FINBU/ZBD2P"/>
                                    </xsl:attribute>
                                 </DiscountPercent>
                              </Discount>
                           </PaymentTerm>
                        </xsl:if>
                        <xsl:if test="not(E1FIKPF/E1FISEG/E1FINBU/ZBD3T = '0')">
                           <PaymentTerm>
                              <xsl:if test="E1FIKPF/E1FISEG/KOART = 'K'">
                                 <xsl:attribute name="payInNumberOfDays">
                                    <xsl:value-of select="E1FIKPF/E1FISEG/E1FINBU/ZBD3T"/>
                                 </xsl:attribute>
                              </xsl:if>
                           </PaymentTerm>
                        </xsl:if>
                        <!--                                CI-1857 Payment due date-->     
                        <xsl:if test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/PAYMENT_DUE_DATE)) > 0">                                
                           <PaymentInformation>
                              <xsl:attribute name = "paymentNetDueDate">
                                 <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date"
                                       select="E1FIKPF/E1ARBCIG_FIDCCHEADER/PAYMENT_DUE_DATE"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                 </xsl:call-template>                                        
                              </xsl:attribute>
                           </PaymentInformation>   
                        </xsl:if> 
                        <xsl:if test="string-length(normalize-space(E1FIKPF/BKTXT)) > 0 or $v_attach!=''">
                        <Comments>
                           <xsl:attribute name="xml:lang">
                              <xsl:choose>
                                 <xsl:when test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS)) > 0">
                                    <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$v_defaultLang"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:value-of select="E1FIKPF/BKTXT"/>
                           <xsl:if test="$v_attach != ''">
                              <xsl:call-template name="addContenIdIDOC">
                                 <xsl:with-param name="eachAtt" select="$v_attach"/>
                              </xsl:call-template>
                           </xsl:if>                           
                        </Comments>
                        </xsl:if>
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'originalInvoiceNo'"/>
                           </xsl:attribute>
                           <xsl:value-of select="E1FIKPF/XBLNR"/>
                        </Extrinsic>
                        <Extrinsic name="fiscalYear">
                           <xsl:value-of select="E1FIKPF/GJAHR"/>
                        </Extrinsic>                         
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'buyerInvoiceID'"/>
                           </xsl:attribute>
                           <xsl:value-of select="E1FIKPF/BELNR"/>
                        </Extrinsic>
                        <Extrinsic>
                           <xsl:attribute name="name">
                              <xsl:value-of select="'CompanyCode'"/>
                           </xsl:attribute>
                           <xsl:value-of select="E1FIKPF/BUKRS"/>
                        </Extrinsic>
                        <xsl:variable name="is_poref">
                           <!-- Begin of IG-37113 -->
                           <xsl:if test="E1FIKPF/E1FISEG/E1ARBCIG_FIDCCITEM[BSTYP = 'F'][1]">
                              <xsl:value-of select="'X'"/>
                           </xsl:if>
                           <!-- End of IG-37113 -->
                        </xsl:variable>
                        <xsl:choose>
                           <xsl:when test="$is_poref = 'X'">
                              <Extrinsic>
                                 <xsl:attribute name="name" select="'invoiceSourceDocument'"/>
                                 <xsl:value-of select="'PurchaseOrder'"/>
                              </Extrinsic>
                           </xsl:when>
                           <xsl:otherwise>
                              <Extrinsic>
                                 <xsl:attribute name="name" select="'invoiceSourceDocument'"/>
                                 <xsl:value-of select="'NoOrderInformation'"/>
                              </Extrinsic>
                           </xsl:otherwise>
                        </xsl:choose>
<!--                                CI-1681 Buyer Vat id-->                                    
                        <xsl:if test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/KUNDEUINR)) > 0"> 
                           <Extrinsic name="buyerVatID">                                    
                              <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/KUNDEUINR"/>                                                                       
                           </Extrinsic>                                        
                        </xsl:if>                           
                     </InvoiceDetailRequestHeader>                     
                     <xsl:variable name="v_belnr" select="E1FIKPF/BELNR"/> <!-- New -->
                     <xsl:variable name="v_bseg">
                        <xsl:for-each select="E1FIKPF/E1FISEG">
                           <E1FISEG>
                              <xsl:copy-of select="./child::node()"/>
                              <xsl:if test="string-length(EBELN) = 0">
                                 <EBELN/>
                              </xsl:if>
                           </E1FISEG>                              
                        </xsl:for-each>
                     </xsl:variable>
                     <!--IG-42581 start -->
                     <xsl:variable name="v_bset">
                        <xsl:for-each select="E1FIKPF/E1FISET">
                           <E1FISET>
                              <xsl:copy-of select="./child::node()"/>
                              <xsl:if test="string-length(EBELN) = 0">
                                 <EBELN/>
                              </xsl:if>
                           </E1FISET>                              
                        </xsl:for-each>
                     </xsl:variable>   
                     <!--IG-42581 end -->
                <xsl:for-each-group
                   select="$v_bseg/E1FISEG[not(KOART = 'K') and not(BUZID = 'T')]"
                   group-by="EBELN" >   
                     <InvoiceDetailOrder>
                        <InvoiceDetailOrderInfo>
                           <xsl:if test="string-length(normalize-space(EBELN)) > 0">
                              <xsl:if test="E1ARBCIG_FIDCCITEM/BSTYP = 'L'">
                                 <MasterAgreementIDInfo>
                                    <xsl:attribute name="agreementID">
                                       <xsl:value-of select="EBELN"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="agreementType"
                                       select="'scheduling_agreement'"/>
                                 </MasterAgreementIDInfo>
                              </xsl:if>
                              <xsl:if test="E1ARBCIG_FIDCCITEM/BSTYP = 'F'">
                                 <OrderIDInfo>
                                    <xsl:attribute name="orderID">
                                       <xsl:value-of select="EBELN"/>
                                    </xsl:attribute>
                                 </OrderIDInfo>
                              </xsl:if>
                           </xsl:if>
                           <SupplierOrderInfo>
                              <xsl:attribute name="orderID">
                                 <xsl:value-of select="$v_belnr"/>
                              </xsl:attribute>
                           </SupplierOrderInfo>
                        </InvoiceDetailOrderInfo>
                        <xsl:for-each select="current-group()">
                           <!--IG-42581 start -->
                           <xsl:variable name="v_txgrp" select="TXGRP"/>   
                           <!--IG-42581 end -->
                           <InvoiceDetailItem>
                              <xsl:attribute name="invoiceLineNumber">
                                 <xsl:value-of select="(BUZEI) - 1"/>
                              </xsl:attribute>
                              <xsl:attribute name="quantity">
                                 <xsl:value-of select="MENGE"/>
                              </xsl:attribute>
                              <UnitOfMeasure>
                                 <xsl:call-template name="UOMTemplate_Out">
                                    <xsl:with-param name="p_UOMinput" select="MEINS"/>
                                    <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"
                                    />
                                 </xsl:call-template>
                              </UnitOfMeasure>
                              <UnitPrice>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="PSWSL"/>
                                    </xsl:attribute>
                                    <xsl:call-template name="FormatPrice">
                                       <xsl:with-param name="input" select="E1ARBCIG_FIDCCITEM/PRICE"
                                       />
                                    </xsl:call-template>
                                 </Money>
                              </UnitPrice>
                              <InvoiceDetailItemReference>
                                 <xsl:attribute name="lineNumber">
                                    <xsl:value-of select="(BUZEI) - 1"/>
                                 </xsl:attribute>
                                 <!--If S4Hana then check for MATNR_LONG-->
                                 <xsl:variable name="v_matnr">
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(MATNR_LONG)) > 0">
                                          <xsl:value-of select="MATNR_LONG"/>
                                       </xsl:when>
                                       <xsl:when test="string-length(normalize-space(MATNR)) > 0">
                                          <xsl:value-of select="MATNR"/>
                                       </xsl:when>
                                    </xsl:choose>
                                 </xsl:variable>
                                 <ItemID>
                                    <SupplierPartID/>
                                    <xsl:if test="$v_matnr">
                                       <BuyerPartID>
                                          <xsl:value-of select="$v_matnr"/>
                                       </BuyerPartID>
                                    </xsl:if>
                                 </ItemID>
                                 <xsl:if test="SGTXT">
                                    <Description>
                                       <xsl:attribute name="xml:lang">
                                          <xsl:choose>
                                             <xsl:when test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS)) > 0">
                                                <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS"/>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:value-of select="$v_defaultLang"/>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:attribute>                                       
                                       <xsl:value-of select="SGTXT"/>
                                    </Description>
                                 </xsl:if>
                              </InvoiceDetailItemReference>
                              <SubtotalAmount>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="PSWSL"/>
                                    </xsl:attribute>
                                    <xsl:call-template name="FormatPrice">
                                       <xsl:with-param name="input" select="E1ARBCIG_FIDCCITEM/TXBHW"
                                       />
                                    </xsl:call-template>
                                 </Money>
                              </SubtotalAmount>
                              <GrossAmount>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="PSWSL"/>
                                    </xsl:attribute>
                                    <xsl:call-template name="FormatPrice">
                                       <xsl:with-param name="input" select="E1ARBCIG_FIDCCITEM/TXBHW"
                                       />
                                    </xsl:call-template>
                                 </Money>
                              </GrossAmount>
                              <!--IG-42581 start -->
                              <Tax>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="PSWSL"/>
                                    </xsl:attribute>
                                    <xsl:variable name="price">
                                       <xsl:for-each select="$v_bset/E1FISET[TXGRP = $v_txgrp]/FWSTE">
                                          <sum>
                                             <xsl:call-template name="FormatPrice">
                                                <xsl:with-param name="input" select="."/>
                                             </xsl:call-template>
                                          </sum>
                                       </xsl:for-each>
                                    </xsl:variable>
                                    <xsl:value-of select="format-number(sum($price/sum/number()), '0.00')"/>
                                 </Money>
                                 <Description>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:choose>
                                          <xsl:when test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS)) > 0">
                                             <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="$v_defaultLang"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="'TotalTax'"/> 
                                 </Description>
                                 <xsl:for-each select="$v_bset/E1FISET[TXGRP = $v_txgrp]">
                                    <TaxDetail>
                                       <xsl:attribute name="category">
                                          <xsl:value-of select="RESERVE"/>
                                       </xsl:attribute>
                                       <xsl:attribute name="percentageRate">
                                          <xsl:variable name="Percent">
                                             <xsl:call-template name="FormatPrice">
                                                <xsl:with-param name="input" select="KBETR"/>
                                             </xsl:call-template>
                                          </xsl:variable>
                                          <xsl:value-of select="$Percent div 10"/>
                                       </xsl:attribute>
                                       <TaxableAmount>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="$v_bseg[KOART = 'K']/PSWSL"/>
                                             </xsl:attribute>
                                             <xsl:call-template name="FormatPrice">
                                                <xsl:with-param name="input" select="FWBAS"/>
                                             </xsl:call-template>
                                          </Money>
                                       </TaxableAmount>
                                       <TaxAmount>
                                          <Money>
                                             <xsl:attribute name="currency">
                                                <xsl:value-of select="$v_bseg[KOART = 'K']/PSWSL"/>
                                             </xsl:attribute>
                                             <xsl:call-template name="FormatPrice">
                                                <xsl:with-param name="input" select="FWSTE"/>
                                             </xsl:call-template>
                                          </Money>
                                       </TaxAmount>
                                    </TaxDetail>
                                 </xsl:for-each>
                              </Tax>
                              <!--IG-42581 end -->
                              <NetAmount>
                                 <Money>
                                    <xsl:attribute name="currency">
                                       <xsl:value-of select="PSWSL"/>
                                    </xsl:attribute>
                                    <xsl:call-template name="FormatPrice">
                                       <xsl:with-param name="input" select="E1ARBCIG_FIDCCITEM/TXBHW"
                                       />
                                    </xsl:call-template>
                                 </Money>
                              </NetAmount>
                              <Comments>
                                 <xsl:attribute name="xml:lang">
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS)) > 0">
                                          <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="$v_defaultLang"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>                                       
                                 <xsl:value-of select="SGTXT"/>
                              </Comments>
                           </InvoiceDetailItem>                         
                        </xsl:for-each>
                     </InvoiceDetailOrder>
                </xsl:for-each-group>
                     <InvoiceDetailSummary>
                        <SubtotalAmount>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="E1FIKPF/E1FISEG[KOART = 'K']/PSWSL"/>
                              </xsl:attribute>
                              <xsl:variable name="price">
                                 <xsl:for-each select="E1FIKPF/E1FISEG/E1ARBCIG_FIDCCITEM[TXBHW]">
                                    <sum>
                                       <xsl:call-template name="FormatPrice">
                                          <xsl:with-param name="input" select="TXBHW"/>
                                       </xsl:call-template>
                                    </sum>
                                 </xsl:for-each>
                              </xsl:variable>
                              <xsl:value-of select="format-number(sum($price/sum), '0.00')"/>
                           </Money>
                        </SubtotalAmount>
                        <Tax>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="E1FIKPF/E1FISEG[KOART = 'K']/PSWSL"/>
                              </xsl:attribute>
                              <xsl:variable name="price">
                                 <xsl:for-each select="E1FIKPF/E1FISET[FWSTE]">
                                    <sum>
                                       <xsl:call-template name="FormatPrice">
                                          <xsl:with-param name="input" select="FWSTE"/>
                                       </xsl:call-template>
                                    </sum>
                                 </xsl:for-each>
                              </xsl:variable>
                              <xsl:value-of select="format-number(sum($price/sum), '0.00')"/>
                           </Money>
                           <Description>
                              <xsl:attribute name="xml:lang">
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS)) > 0">
                                       <xsl:value-of select="E1FIKPF/E1ARBCIG_FIDCCHEADER/SPRAS"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="$v_defaultLang"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                              <xsl:value-of select="'TotalTax'"/> 
                           </Description>
                           <xsl:for-each select="E1FIKPF/E1FISET">
                              <TaxDetail>
                                 <xsl:attribute name="category">
                                    <xsl:value-of select="RESERVE"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="percentageRate">
                                    <xsl:variable name="Percent">
                                       <xsl:call-template name="FormatPrice">
                                          <xsl:with-param name="input" select="KBETR"/>
                                       </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="$Percent div 10"/>
                                 </xsl:attribute>
                                 <TaxableAmount>
                                    <Money>
                                       <xsl:attribute name="currency">
                                          <xsl:value-of select="../E1FISEG[KOART = 'K']/PSWSL"/>
                                       </xsl:attribute>
                                       <xsl:call-template name="FormatPrice">
                                          <xsl:with-param name="input" select="FWBAS"/>
                                       </xsl:call-template>
                                    </Money>
                                 </TaxableAmount>
                                 <TaxAmount>
                                    <Money>
                                       <xsl:attribute name="currency">
                                          <xsl:value-of select="../E1FISEG[KOART = 'K']/PSWSL"/>
                                       </xsl:attribute>
                                       <xsl:call-template name="FormatPrice">
                                          <xsl:with-param name="input" select="FWSTE"/>
                                       </xsl:call-template>
                                    </Money>
                                 </TaxAmount>
                              </TaxDetail>
                           </xsl:for-each>
                        </Tax>
                        <GrossAmount>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="E1FIKPF/E1FISEG[KOART = 'K']/PSWSL"/>
                              </xsl:attribute>
                              <xsl:choose>
                                 <xsl:when
                                    test="E1FIKPF/E1FISEG[1]/KOART = 'K' and E1FIKPF/E1FISEG[1]/SHKZG = 'H'">
                                    <xsl:value-of select="E1FIKPF/E1FISEG[1]/WRBTR"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:call-template name="FormatPrice">
                                       <xsl:with-param name="input" select="concat('-', E1FIKPF/E1FISEG[1]/WRBTR[1])"/>
                                    </xsl:call-template>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </Money>
                        </GrossAmount>
                        <xsl:if test="string-length(normalize-space(E1FIKPF/E1FISEG[BUZEI = '001']/PSWSL)) > 0 and string-length(normalize-space(E1FIKPF/E1FISEG[BUZEI = '001']/E1FINBU/WSKTO)) > 0">
                        <InvoiceDetailDiscount>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="E1FIKPF/E1FISEG[BUZEI = '001']/PSWSL"/>
                              </xsl:attribute>
                              <xsl:value-of select="E1FIKPF/E1FISEG[BUZEI = '001']/E1FINBU/WSKTO"
                              />
                           </Money>
                        </InvoiceDetailDiscount>
                        </xsl:if>
                        <NetAmount>
                           <Money>
                              <xsl:attribute name="currency">
                                 <xsl:value-of select="E1FIKPF/E1FISEG[KOART = 'K']/PSWSL"/>
                              </xsl:attribute>
                              <xsl:variable name="price">
                                 <xsl:for-each select="E1FIKPF/E1FISEG/E1ARBCIG_FIDCCITEM[TXBHW]">
                                    <sum>
                                       <xsl:call-template name="FormatPrice">
                                          <xsl:with-param name="input" select="TXBHW"/>
                                       </xsl:call-template>
                                    </sum>
                                 </xsl:for-each>
                              </xsl:variable>
                              <xsl:value-of select="format-number(sum($price/sum), '0.00')"/>
                           </Money>
                        </NetAmount>
                     </InvoiceDetailSummary>
                  </InvoiceDetailRequest>
               </Request>
               </cXML>
            </Payload>
            <xsl:if test="$v_attach != ''">
               <xsl:call-template name="OutBoundAttachIDOC">
                  <xsl:with-param name="eachAtt" select="$v_attach"/>
               </xsl:call-template>
            </xsl:if>
         </Combined>      
   </xsl:template>
   <xsl:template name="FormatPrice">
      <xsl:param name="input"/>
      <xsl:variable name="price" select="normalize-space($input)"/>
      <xsl:choose>
         <xsl:when test="(substring($price, string-length($price), 1)) = '-'">
            <xsl:value-of select="concat('-', substring($price, 1, string-length($price) - 1))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$price"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
