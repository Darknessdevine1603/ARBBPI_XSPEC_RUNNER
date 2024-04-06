<?xml version="1.0" encoding="UTF-8"?>  
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes" />
    <xsl:param name="exchange"/>
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anSharedSecrete"/>
    <xsl:param name="ancxmlversion"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anContentID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>    
  <!--    <xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:variable name="v_consignmentInv" select="normalize-space(ARBCIG_GSVERF/IDOC/E1EDK01/FKTYP)"/>
    <xsl:variable name="v_action" select="normalize-space(ARBCIG_GSVERF/IDOC/E1EDK01/ACTION)"/> 
    <xsl:variable name="v_subsequent_debit" select="normalize-space(ARBCIG_GSVERF/IDOC/E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/SUBSEQUENT_DEBIT)"/>        
    <xsl:variable name="v_defaultLang_pd">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_defaultLang">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($v_defaultLang_pd)) > 0">
                <xsl:value-of select="normalize-space($v_defaultLang_pd)"/>
            </xsl:when>
             <xsl:otherwise>
                 <xsl:value-of select="'en'"/>    
             </xsl:otherwise>       
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="v_ers">
        <xsl:value-of select="normalize-space(ARBCIG_GSVERF/IDOC/E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/ERS)"/>
    </xsl:variable>
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--    IG-26224 Send SpecialHandlingAmount Tag -->
    <xsl:variable name="v_SpecialHandlingAmount">
        <xsl:call-template name="SpecialHandlingAmount">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:template match="ARBCIG_GSVERF/IDOC">  
        <xsl:variable name="v_attach" select="E1EDK01/E1ARBCIG_ATTACH_HDR_DET"/>
        <xsl:variable name="v_vendorId">
            <xsl:value-of select="E1EDKA1[PARVW = 'LF']/PARTN"/>
        </xsl:variable>
        <xsl:variable name="v_curDate">
            <xsl:value-of select="current-dateTime()"/>
        </xsl:variable>
        <xsl:variable name="v_timestamp">
            <xsl:value-of
                select="concat(substring($v_curDate, 1, 19), substring($v_curDate, 24, 29))"/>
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
                        <xsl:value-of select="concat($anPayloadID, $v_timestamp)"/>
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
                                    <xsl:value-of select="'EndPointID'"/></xsl:attribute>
                                <Identity>CIG</Identity>
                            </Credential> 

                            <Correspondent>
                                <Contact role="correspondent">
                                    <Name>
                                        <xsl:attribute name="xml:lang">
                                           <xsl:choose>
                                               <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                   <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                               </xsl:when>
                                               <xsl:otherwise>
                                                   <xsl:value-of select="$v_defaultLang"/>  
                                               </xsl:otherwise>
                                           </xsl:choose>
                                        </xsl:attribute>                                        
                                        <xsl:value-of select="E1EDKA1[PARVW = 'LF']/NAME1"/>
                                    </Name>
                                    <Email name="routing">
                                        <xsl:value-of
                                            select="E1EDKA1[PARVW = 'LF']/E1ARBCIG_CONTACT_INFO/SMTP_ADDR"
                                        />
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
                                <!-- <SharedSecret>
                            <xsl:value-of select="$anSharedSecrete"/>  
                        </SharedSecret> -->
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
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/XBLNR)) > 0">
                                        <xsl:attribute name="invoiceID">
                                            <xsl:value-of select="E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/XBLNR"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="invoiceID">
                                            <xsl:value-of select="E1EDK01/BELNR"/>
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:attribute name="purpose">
                                    <xsl:choose>
                                        <xsl:when test="$v_action = '001'"
                                            >lineLevelCreditMemo</xsl:when>
                                        <xsl:when test="$v_subsequent_debit = 'X'"
                                            >lineLevelDebitMemo</xsl:when>                                        
                                        <xsl:when test="$v_action = '000'">standard</xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="E1EDK01/ACTION"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="operation">
                                    <xsl:value-of select="'new'"/>
                                </xsl:attribute>
                                <xsl:attribute name="invoiceDate">
                                    <xsl:call-template name="ANDateTime">
                                        <xsl:with-param name="p_date"
                                            select="E1EDK03[IDDAT = '016']/DATUM"/>
                                        <xsl:with-param name="p_time"
                                            select="E1EDK03[IDDAT = '016']/UZEIT"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="invoiceOrigin">
                                    <xsl:choose>
                                        <xsl:when test="$v_consignmentInv">
                                            
                                                <xsl:value-of select="'buyer'"/>
                                            
                                        </xsl:when>
                                        <xsl:otherwise>
                                            
                                                <xsl:value-of select="'supplier'"/>
                                            
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:if test="string-length($v_ers) > 0">
                                    <xsl:attribute name="isERS">
                                        <xsl:value-of select="'yes'"/>
                                    </xsl:attribute>
                                </xsl:if>                        
				<InvoiceDetailHeaderIndicator/>    
                                <InvoiceDetailLineIndicator>
                                    <xsl:if test="E1EDP01/E1EDP04">
                                        <xsl:attribute name="isTaxInLine">
                                            
                                                <xsl:value-of select="'yes'"/>
                                            
                                        </xsl:attribute>	
                                    </xsl:if>
                                    <xsl:if
                                        test="E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/SHNDLG_LINE = 'Yes'">
                                        <xsl:attribute name="isSpecialHandlingInLine">
                                            
                                                <xsl:value-of select="'Yes'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="($v_subsequent_debit) = 'X'">                                    
                                        <xsl:attribute name="isPriceAdjustmentInLine">
                                           
                                                <xsl:value-of select="'yes'"/>
                                            
                                        </xsl:attribute>	
                                    </xsl:if>                                    
                                </InvoiceDetailLineIndicator>
                                <InvoicePartner>
                                    <xsl:for-each select="E1EDKA1[PARVW = 'AG']">
                                        <Contact>
                                            <xsl:attribute name="role">
                                                <xsl:value-of select="'billTo'"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="addressID">
                                                <xsl:value-of select="PARTN"/>
                                            </xsl:attribute>
                                            <Name>
                                                <xsl:attribute name="xml:lang">
                                                    <xsl:choose>
                                                        <!-- Defect Fix IG-32198 Remove E1EDKA1[PARVW = 'AG']/ -->
                                                        <xsl:when test="string-length(normalize-space(SPRAS_ISO)) > 0">  
                                                            <xsl:value-of select="SPRAS_ISO"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$v_defaultLang"/>  
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>                                                       
                                                <xsl:value-of select="NAME1"/>
                                            </Name>
                                            <PostalAddress>
                                                <Street>
                                                  <xsl:value-of select="STRAS"/>
                                                </Street>
                                                <City>
                                                  <xsl:value-of select="ORT01"/>
                                                </City>
                                                <State>
                                                  <xsl:value-of select="E1ARBCIG_CONTACT_INFO/REGION"
                                                  />
                                                </State>
                                                <PostalCode>
                                                  <xsl:value-of select="PSTLZ"/>
                                                </PostalCode>
                                                <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="LAND1"/>
                                                </Country>
                                            </PostalAddress>
                                            <xsl:if test="E1ARBCIG_CONTACT_INFO/TEL_NUMBER">
                                                <Phone>
                                                  <TelephoneNumber>
                                                  <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  </CountryCode>
                                                  <AreaOrCityCode/>
                                                  <Number>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/TEL_NUMBER"/>
                                                  </Number>
                                                  <xsl:if test="E1ARBCIG_CONTACT_INFO/TEL_EXTENS">
                                                  <Extension>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/TEL_EXTENS"/>
                                                  </Extension>
                                                  </xsl:if>
                                                  </TelephoneNumber>
                                                </Phone>
                                            </xsl:if>
                                            <xsl:if test="E1ARBCIG_CONTACT_INFO/FAX_NUMBER">
                                                <Fax>
                                                  <TelephoneNumber>
                                                  <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  </CountryCode>
                                                  <AreaOrCityCode/>
                                                  <Number>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/FAX_NUMBER"/>
                                                  </Number>
                                                  <xsl:if test="E1ARBCIG_CONTACT_INFO/FAX_EXTENS">
                                                  <Extension>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/FAX_EXTENS"/>
                                                  </Extension>
                                                  </xsl:if>
                                                  </TelephoneNumber>
                                                </Fax>
                                            </xsl:if>
                                        </Contact>
                                    </xsl:for-each>
                                </InvoicePartner>
                                <xsl:for-each select="E1EDKA1[PARVW = 'WE']">
                                    <InvoicePartner>
                                        <Contact role="shipTo">
                                            <xsl:attribute name="addressID">
                                                <xsl:value-of select="PARTN"/>
                                            </xsl:attribute>
                                            <Name>
                                                <xsl:attribute name="xml:lang">
                                                    <xsl:choose>
                                                        <!-- Defect Fix IG-32198 Remove E1EDKA1[PARVW = 'WE']/ -->
                                                        <xsl:when test="string-length(normalize-space(SPRAS_ISO)) > 0">  
                                                            <xsl:value-of select="SPRAS_ISO"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$v_defaultLang"/>  
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>                                                      
                                                <xsl:value-of select="NAME1"/>
                                            </Name>
                                            <PostalAddress>
                                                <Street>
                                                  <xsl:value-of select="STRAS"/>
                                                </Street>
                                                <City>
                                                  <xsl:value-of select="ORT01"/>
                                                </City>
                                                <State>
                                                  <xsl:value-of select="E1ARBCIG_CONTACT_INFO/REGION"
                                                  />
                                                </State>
                                                <PostalCode>
                                                  <xsl:value-of select="PSTLZ"/>
                                                </PostalCode>
                                                <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="LAND1"/>
                                                </Country>
                                            </PostalAddress>
                                            <xsl:if test="E1ARBCIG_CONTACT_INFO/TEL_NUMBER">
                                                <Phone>
                                                  <TelephoneNumber>
                                                  <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  </CountryCode>
                                                  <AreaOrCityCode/>
                                                  <Number>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/TEL_NUMBER"/>
                                                  </Number>
                                                  <xsl:if test="E1ARBCIG_CONTACT_INFO/TEL_EXTENS">
                                                  <Extension>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/TEL_EXTENS"/>
                                                  </Extension>
                                                  </xsl:if>
                                                  </TelephoneNumber>
                                                </Phone>
                                            </xsl:if>
                                            <xsl:if test="E1ARBCIG_CONTACT_INFO/FAX_NUMBER">
                                                <Fax>
                                                  <TelephoneNumber>
                                                  <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  </CountryCode>
                                                  <AreaOrCityCode/>
                                                  <Number>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/FAX_NUMBER"/>
                                                  </Number>
                                                  <xsl:if test="E1ARBCIG_CONTACT_INFO/FAX_EXTENS">
                                                  <Extension>
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/FAX_EXTENS"/>
                                                  </Extension>
                                                  </xsl:if>
                                                  </TelephoneNumber>
                                                </Fax>
                                            </xsl:if>
                                        </Contact>
                                    </InvoicePartner>
                                </xsl:for-each>

                                <xsl:if test="E1EDKA1[PARVW = 'LF'] and $v_consignmentInv">
                                    <InvoicePartner>
                                        <xsl:for-each select="E1EDKA1[PARVW = 'LF']">
                                            <Contact role="remitTo">
                                                <xsl:attribute name="addressID">
                                                  <xsl:value-of select="PARTN"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="addressIDDomain">
                                                    <xsl:value-of select="'billToID'"/>
                                                </xsl:attribute>
                                                <Name>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(SPRAS_ISO)) > 0">  
                                                                <xsl:value-of select="SPRAS_ISO"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$v_defaultLang"/>  
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:attribute>                                                                                                            
                                                  <xsl:value-of select="NAME1"/>
                                                </Name>
                                                <PostalAddress>
                                                  <Street>
                                                  <xsl:value-of select="STRAS"/>
                                                  </Street>
                                                  <City>
                                                  <xsl:value-of select="ORT01"/>
                                                  </City>
                                                  <State>
                                                  <xsl:value-of select="E1ARBCIG_CONTACT_INFO/REGION"
                                                  />
                                                  </State>
                                                  <PostalCode>
                                                  <xsl:value-of select="PSTLZ"/>
                                                  </PostalCode>
                                                  <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="LAND1"/>
                                                  </Country>
                                                </PostalAddress>
                                                <Email name="default">
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/SMTP_ADDR"/>
                                                </Email>
                                            </Contact>
                                        </xsl:for-each>
                                    </InvoicePartner>
                                    <InvoicePartner>
                                        <xsl:for-each select="E1EDKA1[PARVW = 'LF']">
                                            <Contact role="from">
                                                <xsl:attribute name="addressID">
                                                  <xsl:value-of select="PARTN"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="addressIDDomain">
                                                    <xsl:value-of select="'billToID'"/>
                                                </xsl:attribute>
                                                <Name>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space(SPRAS_ISO)) > 0">  
                                                            <xsl:value-of select="SPRAS_ISO"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$v_defaultLang"/>  
                                                        </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:attribute>                                                    
                                                  <xsl:value-of select="NAME1"/>
                                                </Name>
                                                <PostalAddress>
                                                  <Street>
                                                  <xsl:value-of select="STRAS"/>
                                                  </Street>
                                                  <City>
                                                  <xsl:value-of select="ORT01"/>
                                                  </City>
                                                  <State>
                                                  <xsl:value-of select="E1ARBCIG_CONTACT_INFO/REGION"
                                                  />
                                                  </State>
                                                  <PostalCode>
                                                  <xsl:value-of select="PSTLZ"/>
                                                  </PostalCode>
                                                  <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="LAND1"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="LAND1"/>
                                                  </Country>
                                                </PostalAddress>
                                                <Email name="default">
                                                  <xsl:value-of
                                                  select="E1ARBCIG_CONTACT_INFO/SMTP_ADDR"/>
                                                </Email>
                                            </Contact>
                                        </xsl:for-each>
                                    </InvoicePartner>
                                </xsl:if>
                                <xsl:for-each select="E1EDK18">
                                    <PaymentTerm>
                                        <xsl:attribute name="payInNumberOfDays">
                                            <xsl:value-of select="TAGE"/>
                                        </xsl:attribute>
                                        <xsl:if test="PRZNT">
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
                                <!--                                CI-1857 Payment due date-->     
                                <xsl:if test="string-length(normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/PAYMENT_DUE_DATE)) > 0">                                
                                    <PaymentInformation>
                                        <xsl:attribute name = "paymentNetDueDate">
                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date"
                                                    select="E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/PAYMENT_DUE_DATE"/>
                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                            </xsl:call-template>                                        
                                        </xsl:attribute>
                                    </PaymentInformation>   
                                </xsl:if> 
                                <!--  Outbound Comments Fill/Attachments Fill  -->
                                <xsl:if test="E1EDK01/E1ARBCIG_COMMENT or $v_attach!=''">
                                <Comments>
                                    <xsl:attribute name="xml:lang">
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(E1EDK01/E1ARBCIG_COMMENT/TDSPRAS_ISO)) > 0">  
                                                <xsl:value-of select="E1EDK01/E1ARBCIG_COMMENT/TDSPRAS_ISO"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$v_defaultLang"/>  
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:attribute name="type">
                                        <xsl:value-of select="E1EDK01/E1ARBCIG_COMMENT/TDDESC"/>
                                    </xsl:attribute>
                                    <xsl:call-template name="CommentsFillIDOCOutSplitLine">
                                        <xsl:with-param name="p_aribaComment" select="E1EDK01/E1ARBCIG_COMMENT/E1ARBCIG_LINES"/>
                                        <xsl:with-param name="p_pd" select="$v_pd"/>
                                    </xsl:call-template>     
                                    <xsl:call-template name="addContenIdIDOC">
                                        <xsl:with-param name="eachAtt" select="$v_attach"/>
                                    </xsl:call-template>
                                </Comments>
                                </xsl:if>
                                <!-- IG-23032 Uniform Invice ID Begin -->                                
                                <!--<xsl:if test="$v_consignmentInv"> -->                                   
                                <Extrinsic name="origionalInvoiceNo">
                                    <xsl:choose>
                                        <xsl:when  test="string-length(normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/ORIGINALINVOICEID)) > 0">
                                            <xsl:value-of
                                                select="E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/ORIGINALINVOICEID"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="E1EDK01/BELNR"/>
                                        </xsl:otherwise>
                                    </xsl:choose>                                
                                </Extrinsic>
                                    <!-- IG-23032 Uniform Invice ID End -->                                    
                                    <Extrinsic name="buyerInvoiceID">
                                        <!-- IG-23032 Uniform Invice ID Begin -->
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/BUYERINVOICEID)) > 0">
                                                <xsl:value-of
                                                    select="E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/BUYERINVOICEID"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                    select="E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/XBLNR"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- IG-23032 Uniform Invice ID End -->
                                    </Extrinsic>
                                <xsl:if test="$v_consignmentInv">
                                    <Extrinsic name="CompanyCode">
                                        <xsl:value-of select="E1EDKA1[PARVW = 'AG']/PARTN"/>
                                    </Extrinsic>
                                </xsl:if>
                                <Extrinsic name="fiscalYear">
                                    <xsl:choose>
                                        <xsl:when test="E1EDK03/IDDAT = '025'">                                        
                                            <xsl:value-of
                                                select="substring(E1EDK03[IDDAT = '025']/DATUM, 1, 4)"/>                                       
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="substring(E1EDK03[IDDAT = '016']/DATUM, 1, 4)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Extrinsic>                                
                                    <xsl:if test="exists(E1EDK01/EIGENUINR) and 
                                        string-length(normalize-space(E1EDK01/EIGENUINR)) > 0">
                                        <Extrinsic name="supplierVatID">                                    
                                            <xsl:value-of select="E1EDK01/EIGENUINR"/>                                                                       
                                        </Extrinsic>                                        
                                    </xsl:if>
 <!--                                CI-1681 Buyer Vat id-->                                    
                                <xsl:if test="string-length(normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/KUNDEUINR)) > 0"> 
                                    <Extrinsic name="buyerVatID">                                    
                                        <xsl:value-of select="E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/KUNDEUINR"/>                                                                       
                                    </Extrinsic>                                        
                                </xsl:if>                                
                                    <Extrinsic name="invoiceSourceDocument">
                                        <xsl:value-of select="'PurchaseOrder'"/>
                                    </Extrinsic> 
                                    <Extrinsic name="invoiceSubmissionMethod">
                                        <xsl:value-of select="'Online'"/>
                                    </Extrinsic>                                    
                            </InvoiceDetailRequestHeader>
                            <xsl:for-each-group select="E1EDP01[not(PSTYP = '9')]"
                                group-by="E1EDP02[(QUALF = '001') or ($v_consignmentInv and (QUALF = '010') and (not(string-length($v_ers) > 0)))]/BELNR">  <!-- IG-18077: Added $ers check to avoid duplicate <InvoiceDetail> node -->
                                <InvoiceDetailOrder>
                                    <InvoiceDetailOrderInfo>
                                        <xsl:for-each select="E1EDP02">
                                            <xsl:if test="(QUALF = '001') or ($v_consignmentInv and (QUALF = '010') and                                               
                                                (not(string-length($v_ers) > 0)))">
                                                <xsl:choose>
                                                    <xsl:when test="../E1ARBCIG_GSVERFITEM/BSTYP = 'L'">
                                                        <MasterAgreementIDInfo>                                                    
                                                            <xsl:attribute name="agreementID">
                                                                <xsl:value-of select="BELNR"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="agreementDate">
                                                                <xsl:value-of
                                                                    select="concat(../E1ARBCIG_GSVERFITEM/ORDER_DATE, $anERPTimeZone)"
                                                                /> 
                                                            </xsl:attribute>
                                                            <xsl:attribute name="agreementType">
                                                                <xsl:value-of select="'scheduling_agreement'"/>
                                                            </xsl:attribute>    
                                                        </MasterAgreementIDInfo>                                                 
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <OrderIDInfo>
                                                            <xsl:attribute name="orderID">
                                                                <xsl:value-of select="BELNR"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="orderDate">
                                                                <xsl:value-of
                                                                    select="concat(../E1ARBCIG_GSVERFITEM/ORDER_DATE, $anERPTimeZone)"
                                                                />
                                                            </xsl:attribute>
                                                        </OrderIDInfo>   
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </InvoiceDetailOrderInfo>
                                    <xsl:for-each select="current-group()">
                                        <xsl:if
                                            test="(E1EDP02/QUALF = '001') or ($v_consignmentInv and (E1EDP02/QUALF = '010') and (not(string-length($v_ers) > 0)))">  <!-- IG-18077: Added $ers check to avoid duplicate <InvoiceDetail> node -->
                                            <InvoiceDetailItem>
                                                <xsl:attribute name="invoiceLineNumber">
                                                  <xsl:value-of select="POSEX"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="quantity">
                                                  <xsl:call-template name="lineLevelCreditMemoChk">
                                                  <xsl:with-param name="input" select="MENGE"/>
                                                  </xsl:call-template>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <!--UOM conversion-->
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput" select="MENEE"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                </UnitOfMeasure>
                                                <UnitPrice>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                  <xsl:call-template name="lineLevelCreditMemoChk">
                                                  <xsl:with-param name="input"
                                                  select="normalize-space(E1ARBCIG_GSVERFITEM/PRICE)"/>
                                                  </xsl:call-template>
                                                  </Money>
                                                </UnitPrice>
                                                <xsl:if
                                                  test="not($v_consignmentInv) and not(E1ARBCIG_GSVERFITEM/BPUMZ = '') and not(E1ARBCIG_GSVERFITEM/BPUMN = '')">
                                                  <PriceBasisQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:value-of select="PEINH"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="conversionFactor">
                                                  <xsl:value-of
                                                  select="E1ARBCIG_GSVERFITEM/BPUMZ div E1ARBCIG_GSVERFITEM/BPUMN"
                                                  />
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <!--UOM conversion-->
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput" select="PMENE"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                  </PriceBasisQuantity>
                                                </xsl:if>
                                                <InvoiceDetailItemReference>
                                                  <xsl:attribute name="lineNumber">
                                                      <xsl:if test="not($v_consignmentInv) or (string-length($v_ers) > 0)">                                                
                                                          <xsl:value-of
                                                              select="E1EDP02[QUALF = '001']/ZEILE"/>                                                  
                                                      </xsl:if>
                                                  </xsl:attribute>
                                                  <xsl:if test="E1EDP19/QUALF = '002'">
                                                  <xsl:variable name="v_idtnr">
                                                  <!--If S4Hana then check for IDTNR_LONG-->
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="E1EDP19[QUALF = '002']/IDTNR_LONG != ''">
                                                  <xsl:value-of
                                                  select="E1EDP19[QUALF = '002']/IDTNR_LONG"/>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="E1EDP19[QUALF = '002']/IDTNR != ''">
                                                  <xsl:value-of
                                                  select="E1EDP19[QUALF = '002']/IDTNR"/>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </xsl:variable>
                                                  <ItemID>
                                                  <SupplierPartID>
                                                  <xsl:value-of select="$v_idtnr"/>
                                                  </SupplierPartID>
                                                      <xsl:if test="$v_consignmentInv and (not(string-length($v_ers) > 0))"> <!-- IG-18077: Added $ers check to avoid duplicate <InvoiceDetail> node -->
                                                  <BuyerPartID>
                                                  <xsl:value-of
                                                  select="E1EDP19[QUALF = '002']/MFRPN"/>
                                                  </BuyerPartID>
                                                  </xsl:if>
                                                  </ItemID>
                                                  </xsl:if>
                                                  <Description>
                                                      <xsl:attribute name="xml:lang">
                                                          <xsl:choose>
                                                              <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                                  <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:value-of select="$v_defaultLang"/>  
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:attribute>
                                                      <xsl:choose>
                                                          <xsl:when test="$v_consignmentInv and (not(string-length($v_ers) > 0))">  <!-- IG-18077: Added $ers check to avoid duplicate <InvoiceDetail> node -->
                                                              <xsl:value-of
                                                                  select="concat('Settlement for material document ', E1EDP02[QUALF = '010']/BELNR, ', ', E1EDP02[QUALF = '010']/ZEILE)"/>
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of
                                                                  select="concat('Settlement for purchasing document ', E1EDP02[QUALF = '001']/BELNR, ', ', E1EDP02[QUALF = '001']/ZEILE)"/>
                                                          </xsl:otherwise>
                                                      </xsl:choose>                                                  
                                                  </Description>
                                                </InvoiceDetailItemReference>
                                                <SubtotalAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                  <xsl:call-template name="lineLevelCreditMemoChk">
                                                      <xsl:with-param name="input" select="normalize-space(NETWR)"/>
                                                  </xsl:call-template>
                                                  </Money>
                                                </SubtotalAmount>
                                                <xsl:if test="(string-length(normalize-space(E1EDP02[QUALF = '012']/BELNR))> 0)">                                             
                                                    <ShipNoticeIDInfo>
                                                        <xsl:attribute name="shipNoticeID">
                                                            <xsl:value-of select="E1EDP02[QUALF = '012']/BELNR"/>   
                                                        </xsl:attribute>
                                                    </ShipNoticeIDInfo>
                                                </xsl:if>						    
                                                <GrossAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                  <xsl:call-template name="lineLevelCreditMemoChk">
                                                      <xsl:with-param name="input" select="normalize-space(NETWR)"/>
                                                  </xsl:call-template>
                                                  </Money>
                                                </GrossAmount>
                                                <NetAmount>
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                  <xsl:call-template name="lineLevelCreditMemoChk">
                                                      <xsl:with-param name="input" select="normalize-space(NETWR)"/>
                                                  </xsl:call-template>
                                                  </Money>
                                                </NetAmount>
                                                <!--IG-42581 start -->            
                                                <Tax>
                                                    <Money>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="CURCY"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="sum(./E1EDP04/MSATZ)"/>
                                                    </Money>
                                                    <Description>
                                                        <xsl:attribute name="xml:lang">
                                                            <xsl:choose>
                                                                <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                                    <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="$v_defaultLang"/>  
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:attribute>
                                                    </Description>
                                                    <xsl:variable name="v_currency" select="CURCY"/>
                                                    <xsl:variable name="v_netwr" select="NETWR"/>
                                                    <xsl:for-each select="E1EDP04">
                                                        <xsl:if test="exists(MSATZ)">
                                                            <TaxDetail>
                                                                <xsl:attribute name="category">
                                                                    <xsl:value-of select="KTEXT"/>
                                                                </xsl:attribute>
                                                                <xsl:if test="MSATZ">
                                                                    <xsl:attribute name="percentageRate">
                                                                        <xsl:value-of select="MSATZ"/>
                                                                    </xsl:attribute>
                                                                </xsl:if>
                                                                <TaxableAmount>
                                                                    <Money>
                                                                        <xsl:attribute name="currency">
                                                                            <xsl:value-of select="$v_currency"/>
                                                                        </xsl:attribute>
                                                                        <xsl:value-of select="$v_netwr"/>
                                                                    </Money>
                                                                </TaxableAmount>
                                                                <TaxAmount>
                                                                    <Money>
                                                                        <xsl:attribute name="currency">
                                                                            <xsl:value-of select="$v_currency"/>
                                                                        </xsl:attribute>
                                                                        <xsl:call-template name="lineLevelCreditMemoChk">
                                                                            <xsl:with-param name="input" select="normalize-space(MWSBT)"/>
                                                                        </xsl:call-template>
                                                                    </Money>
                                                                </TaxAmount>
                                                                <Description>
                                                                    <xsl:attribute name="xml:lang">
                                                                        <xsl:choose>
                                                                            <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                                                <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:value-of select="$v_defaultLang"/>  
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="KTEXT"/> 
                                                                </Description>
                                                            </TaxDetail>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </Tax>
                                                <!--IG-42581 end --> 
                                                <!--  Outbound Comments Fill -->
                                                <xsl:if test="//E1EDK01/E1ARBCIG_COMMENT">
                                                    <xsl:variable name="v_posex" select="POSEX"/> 
                                                    <xsl:variable name="v_itemc" select="//E1EDK01/E1ARBCIG_COMMENT/ITEMNUMBER"/> 
                                                    <xsl:if test="$v_posex = $v_itemc">
                                                        <Comments>
                                                            <!-- No Logic for ItemLevel Need to implement if necessary -->
                                                            <xsl:call-template name="CommentsFillIDOCOutSplitLine">
                                                                <xsl:with-param name="p_aribaComment" select="E1EDK01/E1ARBCIG_COMMENT"/>
                                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                            </xsl:call-template>
                                                        </Comments>    
                                                    </xsl:if>
                                                </xsl:if>                                               
                                            </InvoiceDetailItem>
                                        </xsl:if>
                                    </xsl:for-each>
                                </InvoiceDetailOrder>
                            </xsl:for-each-group>
<!--Logic for service Detail item-->
                            <xsl:for-each-group select="E1EDP01[PSTYP = '9']"
                                group-by="E1EDP02[QUALF = '001']/BELNR">
                                <InvoiceDetailOrder>
                                    <InvoiceDetailOrderInfo>
                                        <xsl:for-each select="E1EDP02">
                                            <xsl:if test="QUALF = '001'">
                                            <OrderIDInfo>
                                                <xsl:attribute name="orderID">
                                                    <xsl:value-of select="BELNR"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="orderDate">
                                                    <xsl:value-of select="concat(../E1ARBCIG_GSVERFITEM/ORDER_DATE, $anERPTimeZone)"/>
                                                </xsl:attribute>
                                            </OrderIDInfo>   
                                            </xsl:if>
                                        </xsl:for-each>                              
                                    </InvoiceDetailOrderInfo>
                                    <xsl:for-each select="current-group()">
                                        <InvoiceDetailServiceItem>
                                            <xsl:attribute name="invoiceLineNumber">
                                                <xsl:value-of select="POSEX"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="quantity">  
                                                <xsl:value-of select="E1ARBCIG_GSVERFITEM/MENGE"/>                                  
                                            </xsl:attribute>
                                            <InvoiceDetailServiceItemReference>
                                                <xsl:attribute name="lineNumber">
                                                    <xsl:variable name="v_srvmapkey">
                                                        <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/SRVMAPKEY"/>
                                                    </xsl:variable>
                                                        <xsl:choose>
                                                            <xsl:when test="(string-length($v_srvmapkey) = 10) and (substring($v_srvmapkey,1,1)='5')">
                                                                <xsl:value-of select="concat(1,substring($v_srvmapkey,2))"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$v_srvmapkey"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:if test="string-length(normalize-space(E1ARBCIG_SERVICE_ITEM/EXTSRVNO)) > 0">
                                                    <ItemID>
                                                        <xsl:if test="(string-length(normalize-space(E1ARBCIG_SERVICE_ITEM/EXTSRVNO)) > 0)">
                                                            <SupplierPartID>
                                                                <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/EXTSRVNO"/>
                                                            </SupplierPartID>
                                                        </xsl:if>
                                                        <xsl:if test="(string-length(normalize-space(E1ARBCIG_SERVICE_ITEM/SRVPOS)) > 0)">
                                                            <BuyerPartID>
                                                                <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/SRVPOS"/>
                                                            </BuyerPartID>
                                                        </xsl:if>
                                                    </ItemID> 
                                                </xsl:if>
                                                <Description>
                                                    <xsl:attribute name="xml:lang">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                            <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$v_defaultLang"/>  
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/KTEXT"/>
                                                </Description>						    
                                            </InvoiceDetailServiceItemReference>                                                                              
                                        <ServiceEntryItemIDInfo>
                                            <xsl:attribute name="serviceLineNumber">
                                                <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/LFPOS"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="serviceEntryID">
                                                <xsl:value-of select="E1EDP02[QUALF = '010']/BELNR"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="serviceEntryDate">
                                                <xsl:value-of select="E1ARBCIG_GSVERFITEM/ORDER_DATE"/>
                                            </xsl:attribute>                                         
                                        </ServiceEntryItemIDInfo>
                                        <SubtotalAmount>
                                            <Money>
                                                <xsl:attribute name="currency">
                                                    <xsl:value-of select="CURCY"/>
                                                </xsl:attribute>
                                                <xsl:call-template name="lineLevelCreditMemoChk">
                                                    <xsl:with-param name="input" select="normalize-space(NETWR)"/>
                                                </xsl:call-template>
                                            </Money>
                                        </SubtotalAmount>
                                        <UnitOfMeasure>
                                            <!--UOM conversion-->
                                            <xsl:call-template name="UOMTemplate_Out">
                                                <xsl:with-param name="p_UOMinput" select="E1ARBCIG_GSVERFITEM/MENEE"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anSupplierANID"/>
                                            </xsl:call-template>                                            
                                        </UnitOfMeasure>
                                        <UnitPrice>                                           
                                            <Money>
                                                <xsl:attribute name="currency">
                                                    <xsl:value-of select="CURCY"/>
                                                </xsl:attribute>
                                                <xsl:call-template name="lineLevelCreditMemoChk">
                                                    <xsl:with-param name="input" select="normalize-space(E1ARBCIG_GSVERFITEM/PRICE)"/>
                                                </xsl:call-template>
                                            </Money>                                            
                                        </UnitPrice>
                                        <xsl:if test="not($v_consignmentInv)">
                                            <PriceBasisQuantity>
                                                <xsl:attribute name="quantity">
                                                    <xsl:value-of select="E1ARBCIG_GSVERFITEM/PEINH"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="conversionFactor">
                                                    <xsl:value-of select="E1ARBCIG_GSVERFITEM/BPUMZ div E1ARBCIG_GSVERFITEM/BPUMN"/>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                    <!--UOM conversion-->
                                                    <xsl:call-template name="UOMTemplate_Out">
                                                        <xsl:with-param name="p_UOMinput" select="E1ARBCIG_GSVERFITEM/MENEE"/>
                                                        <xsl:with-param name="p_anERPSystemID"
                                                            select="$anERPSystemID"/>
                                                        <xsl:with-param name="p_anSupplierANID"
                                                            select="$anSupplierANID"/>
                                                    </xsl:call-template>                                                
                                                </UnitOfMeasure>
                                            </PriceBasisQuantity>                                            
                                        </xsl:if>
                                            <GrossAmount>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="CURCY"/>
                                                    </xsl:attribute>
                                                    <xsl:call-template name="lineLevelCreditMemoChk">
                                                        <xsl:with-param name="input" select="normalize-space(NETWR)"/>
                                                    </xsl:call-template>
                                                </Money>
                                            </GrossAmount>
                                            <NetAmount>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="CURCY"/>
                                                    </xsl:attribute>
                                                    <xsl:call-template name="lineLevelCreditMemoChk">
                                                        <xsl:with-param name="input" select="normalize-space(NETWR)"/>
                                                    </xsl:call-template>
                                                </Money>                                                
                                            </NetAmount>
                                            <!--IG-42581 start -->            
                                            <Tax>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="CURCY"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="sum(./E1EDP04/MSATZ)"/>
                                                </Money>
                                                <Description>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                                <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$v_defaultLang"/>  
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:attribute>
                                                </Description>
                                                <xsl:variable name="v_currency" select="CURCY"/>
                                                <xsl:variable name="v_netwr" select="NETWR"/>
                                                <xsl:for-each select="E1EDP04">
                                                    <xsl:if test="exists(MSATZ)">
                                                        <TaxDetail>
                                                            <xsl:attribute name="category">
                                                                <xsl:value-of select="KTEXT"/>
                                                            </xsl:attribute>
                                                            <xsl:if test="MSATZ">
                                                                <xsl:attribute name="percentageRate">
                                                                    <xsl:value-of select="MSATZ"/>
                                                                </xsl:attribute>
                                                            </xsl:if>
                                                            <TaxableAmount>
                                                                <Money>
                                                                    <xsl:attribute name="currency">
                                                                        <xsl:value-of select="$v_currency"/>
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="$v_netwr"/>
                                                                </Money>
                                                            </TaxableAmount>
                                                            <TaxAmount>
                                                                <Money>
                                                                    <xsl:attribute name="currency">
                                                                        <xsl:value-of select="$v_currency"/>
                                                                    </xsl:attribute>
                                                                    <xsl:call-template name="lineLevelCreditMemoChk">
                                                                        <xsl:with-param name="input" select="normalize-space(MWSBT)"/>
                                                                    </xsl:call-template>
                                                                </Money>
                                                            </TaxAmount>
                                                            <Description>
                                                                <xsl:attribute name="xml:lang">
                                                                    <xsl:choose>
                                                                        <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                                            <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:value-of select="$v_defaultLang"/>  
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:value-of select="KTEXT"/> 
                                                            </Description>
                                                        </TaxDetail>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </Tax>
                                            <!--IG-42581 end -->
                                            <Extrinsic name="punchinItemFromCatalog">
                                                    <xsl:value-of select="'no'"/>                                                                                               
                                            </Extrinsic>
                                            <xsl:if test="exists(E1ARBCIG_SERVICE_ITEM/ZEILE)
                                                and string-length(normalize-space(E1ARBCIG_SERVICE_ITEM/ZEILE)) > 0">
                                                <Extrinsic name="parentPOLineNumber">
                                                        <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/ZEILE"/>                                                    
                                                </Extrinsic>                                                
                                            </xsl:if>
                                            <xsl:if test="exists(E1ARBCIG_SERVICE_ITEM/EXTROW)
                                                and string-length(normalize-space(E1ARBCIG_SERVICE_ITEM/EXTROW)) > 0">
                                                <Extrinsic name="extLineNumber">
                                                        <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/EXTROW"/>                                                    
                                                </Extrinsic>                                                
                                            </xsl:if>
                                            <xsl:if test="exists(E1ARBCIG_SERVICE_ITEM/EXTGROUP)
                                                and string-length(normalize-space(E1ARBCIG_SERVICE_ITEM/EXTGROUP)) > 0">
                                                <Extrinsic name="parentExtLineNumber">
                                                        <xsl:value-of select="E1ARBCIG_SERVICE_ITEM/EXTGROUP"/>                                                    
                                                </Extrinsic>                                                  
                                            </xsl:if> 
                                            <xsl:if test="//E1EDK01/E1ARBCIG_COMMENT">
                                                <xsl:variable name="v_posex" select="POSEX"/> 
                                                <xsl:variable name="v_itemc" select="//E1EDK01/E1ARBCIG_COMMENT/ITEMNUMBER"/> 
                                                <xsl:if test="$v_posex = $v_itemc">
                                                    <Comments>
                                                        <!-- No Logic for ItemLevel Need to implement if necessary -->
                                                        <xsl:call-template name="CommentsFillIDOCOutSplitLine">
                                                            <xsl:with-param name="p_aribaComment" select="E1EDK01/E1ARBCIG_COMMENT"/>
                                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                                        </xsl:call-template>
                                                    </Comments>   
                                                </xsl:if>
                                            </xsl:if>                                           
                                        </InvoiceDetailServiceItem>
                                    </xsl:for-each>
                                </InvoiceDetailOrder> 
                            </xsl:for-each-group>                    
                            <xsl:if test="E1EDP01/ACTION = 'ARB'">
                                <InvoiceDetailOrder>
                                    <InvoiceDetailOrderInfo>
                                        <OrderIDInfo>
                                            <xsl:attribute name="orderID"/>
                                        </OrderIDInfo>
                                    </InvoiceDetailOrderInfo>
                                    <xsl:for-each select="E1EDP01[ACTION = 'ARB']">
                                        <InvoiceDetailItem>
                                            <xsl:attribute name="invoiceLineNumber">
                                                <xsl:value-of select="POSEX"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="MENGE"/>
                                            </xsl:attribute>
                                            <UnitOfMeasure>
                                                <!--UOM conversion-->
                                                <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput" select="MENEE"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                </xsl:call-template>
                                            </UnitOfMeasure>
                                            <UnitPrice>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                    <xsl:value-of select="normalize-space(PREIS)"/>
                                                </Money>
                                            </UnitPrice>
                                            <InvoiceDetailItemReference>
                                                <xsl:attribute name="lineNumber">
                                                  <xsl:value-of select="POSEX"/>
                                                </xsl:attribute>
                                                <!--If S4Hana then check for MATNR_LONG-->
                                                <xsl:variable name="v_matnr">
                                                  <xsl:choose>
                                                  <xsl:when test="MATNR_LONG != ''">
                                                  <xsl:value-of select="MATNR_LONG"/>
                                                  </xsl:when>
                                                  <xsl:when test="MATNR != ''">
                                                  <xsl:value-of select="MATNR"/>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:variable>
                                                <xsl:if test="$v_matnr != ''">
                                                  <ItemID>
                                                  <SupplierPartID>
                                                  <BuyerPartID>
                                                  <xsl:value-of select="$v_matnr"/>
                                                  </BuyerPartID>
                                                  </SupplierPartID>
                                                  </ItemID>
                                                </xsl:if>
                                            </InvoiceDetailItemReference>
                                            <SubtotalAmount>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                    <xsl:value-of select="normalize-space(NETWR)"/>
                                                </Money>
                                            </SubtotalAmount>
                                            <GrossAmount>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                    <xsl:value-of select="normalize-space(NETWR)"/>
                                                </Money>
                                            </GrossAmount>
                                            <NetAmount>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="CURCY"/>
                                                  </xsl:attribute>
                                                    <xsl:value-of select="normalize-space(NETWR)"/>
                                                </Money>
                                            </NetAmount>
                                            <!--IG-42581 start -->            
                                            <Tax>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="CURCY"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="sum(./E1EDP04/MSATZ)"/>
                                                </Money>
                                                <Description>
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                                <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$v_defaultLang"/>  
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:attribute>
                                                </Description>
                                                <xsl:variable name="v_currency" select="CURCY"/>
                                                <xsl:variable name="v_netwr" select="NETWR"/>
                                                <xsl:for-each select="E1EDP04">
                                                    <xsl:if test="exists(MSATZ)">
                                                        <TaxDetail>
                                                            <xsl:attribute name="category">
                                                                <xsl:value-of select="KTEXT"/>
                                                            </xsl:attribute>
                                                            <xsl:if test="MSATZ">
                                                                <xsl:attribute name="percentageRate">
                                                                    <xsl:value-of select="MSATZ"/>
                                                                </xsl:attribute>
                                                            </xsl:if>
                                                            <TaxableAmount>
                                                                <Money>
                                                                    <xsl:attribute name="currency">
                                                                        <xsl:value-of select="$v_currency"/>
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="$v_netwr"/>
                                                                </Money>
                                                            </TaxableAmount>
                                                            <TaxAmount>
                                                                <Money>
                                                                    <xsl:attribute name="currency">
                                                                        <xsl:value-of select="$v_currency"/>
                                                                    </xsl:attribute>
                                                                    <xsl:call-template name="lineLevelCreditMemoChk">
                                                                        <xsl:with-param name="input" select="normalize-space(MWSBT)"/>
                                                                    </xsl:call-template>
                                                                </Money>
                                                            </TaxAmount>
                                                            <Description>
                                                                <xsl:attribute name="xml:lang">
                                                                    <xsl:choose>
                                                                        <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                                            <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:value-of select="$v_defaultLang"/>  
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:value-of select="KTEXT"/> 
                                                            </Description>
                                                        </TaxDetail>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </Tax>
                                            <!--IG-42581 end -->
                                        </InvoiceDetailItem>
                                    </xsl:for-each>
                                </InvoiceDetailOrder>
                            </xsl:if>
                            <InvoiceDetailSummary>
                                <SubtotalAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="E1EDS01[SUMID = '002']/WAERQ"/>
                                        </xsl:attribute>
                                        <xsl:call-template name="lineLevelCreditMemoChk">
                                            <xsl:with-param name="input"
                                                select="normalize-space(E1EDS01[SUMID = '002']/SUMME)"/>
                                        </xsl:call-template>
                                    </Money>
                                </SubtotalAmount>
                                <Tax>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="E1EDS01[SUMID = '005']/WAERQ"/>
                                        </xsl:attribute>
                                        <xsl:call-template name="lineLevelCreditMemoChk">
                                            <xsl:with-param name="input"
                                                select="normalize-space(E1EDS01[SUMID = '005']/SUMME)"/>
                                        </xsl:call-template>
                                    </Money>
                                    <Description>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                    <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$v_defaultLang"/>  
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </Description>
                                    <xsl:variable name="v_currency" select="E1EDS01[2]/WAERQ"/>
                                    <xsl:for-each select="E1EDK01/E1ARBCIG_E1EDK04">
                                        
                                        <TaxDetail>
                                            <xsl:attribute name="category">
                                                <xsl:value-of select="KTEXT"/>
                                            </xsl:attribute>
                                            <xsl:if test="MSATZ">
                                                <xsl:attribute name="percentageRate">
                                                  <xsl:value-of select="MSATZ"/>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <TaxableAmount>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="$v_currency"/>
                                                  </xsl:attribute>
                                                  <xsl:call-template name="lineLevelCreditMemoChk">
                                                      <xsl:with-param name="input" select="normalize-space(FWBAS)"/>
                                                  </xsl:call-template>
                                                </Money>
                                            </TaxableAmount>
                                            <TaxAmount>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="$v_currency"/>
                                                  </xsl:attribute>
                                                  <xsl:call-template name="lineLevelCreditMemoChk">
                                                      <xsl:with-param name="input" select="normalize-space(MWSBT)"/>
                                                  </xsl:call-template>
                                                </Money>
                                            </TaxAmount>
                                            <Description>
                                                <xsl:attribute name="xml:lang">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'LF']/SPRAS_ISO)) > 0">  
                                                            <xsl:value-of select="E1EDKA1[PARVW = 'LF']/SPRAS_ISO"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="$v_defaultLang"/>  
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:variable name="v_mwskz" select="MWSKZ"/> <!-- IG-41272 -->
                                                <xsl:value-of select="(../../E1EDP01/E1EDP04[MWSKZ = $v_mwskz]/KTEXT)[1]"/> <!-- IG-41272 -->
                                            </Description>
                                        </TaxDetail>
                                    </xsl:for-each>
                                </Tax>
                                <xsl:if test="not(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/BEZNK = '0.00')">                                 
                                    <!--    IG-26224 check PD entry for SpecialHandlingAmount -->                                    
                                    <xsl:choose>
                                        <!--    IG-26224 Fill SpecialHandlingAmount Tag if PD entry is maintained -->  
                                        <xsl:when test="string-length($v_SpecialHandlingAmount) > 0">
                                            <SpecialHandlingAmount>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="E1EDK01/CURCY"/>
                                                    </xsl:attribute>
                                                    <xsl:call-template name="lineLevelCreditMemoChk">
                                                        <xsl:with-param name="input"
                                                            select="normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/BEZNK)"/>
                                                    </xsl:call-template>
                                                </Money>
                                            </SpecialHandlingAmount>    
                                        </xsl:when>
                                        <!--    IG-26224 Fill ShippingAmount Tag if PD entry NOT is maintained --> 
                                        <xsl:otherwise>
                                            <ShippingAmount>
                                                <Money>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="E1EDK01/CURCY"/>
                                                    </xsl:attribute>
                                                    <xsl:call-template name="lineLevelCreditMemoChk">
                                                        <xsl:with-param name="input"
                                                            select="normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/BEZNK)"/>
                                                    </xsl:call-template>
                                                </Money>
                                            </ShippingAmount>   
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>                                
                                <GrossAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="E1EDS01[SUMID = '003']/WAERQ"/>
                                        </xsl:attribute>
                                        <xsl:call-template name="lineLevelCreditMemoChk">
                                            <xsl:with-param name="input"
                                                select="normalize-space(E1EDS01[SUMID = '003']/SUMME)"/>
                                        </xsl:call-template>
                                    </Money>
                                </GrossAmount>
                                <xsl:if test="(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/WSKTO > '0')">                                
                                    <InvoiceDetailDiscount>
                                        <Money>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of select="E1EDK01/CURCY"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="normalize-space(E1EDK01/E1ARBCIG_GSVERFHEADER_INFO/WSKTO)"/>                                        
                                        </Money>
                                    </InvoiceDetailDiscount>
                                </xsl:if>                                  
                                <NetAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="E1EDS01[SUMID = '002']/WAERQ"/>
                                        </xsl:attribute>
                                        <xsl:call-template name="lineLevelCreditMemoChk">
                                            <xsl:with-param name="input"
                                                select="normalize-space(E1EDS01[SUMID = '002']/SUMME)"/>
                                        </xsl:call-template>
                                    </Money>
                                </NetAmount>
                                <DueAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="E1EDS01[SUMID = '003']/WAERQ"/>
                                        </xsl:attribute>
                                        <xsl:call-template name="lineLevelCreditMemoChk">
                                            <xsl:with-param name="input"
                                                select="normalize-space(E1EDS01[SUMID = '003']/SUMME)"/>
                                        </xsl:call-template>
                                    </Money>
                                </DueAmount>
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

    <xsl:template name="lineLevelCreditMemoChk">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($input)) = 0">
                <xsl:value-of select="$input"/>
            </xsl:when>
            <xsl:when test="$v_action = '001' and number($input) > 0">
                <xsl:value-of select="concat('-', normalize-space($input))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
