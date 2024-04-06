<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anProviderANID" select="'ANOO1'"/>
    <xsl:param name="anSharedSecrete"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:decimal-format name="remit" decimal-separator="."/>
    <xsl:param name="anEnvName"/>
<!--        <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
<!--        <xsl:value-of select="document('ParameterCrossreference.xml')"/>-->
    </xsl:variable>
    <xsl:variable name="v_attach" select="ARBCIG_REMADV/IDOC/E1IDKU1/E1ARBCIG_ATTACH_HDR_DET"/>
    <!--IG-24048 CIG AddOn upgrade Date-->
    <xsl:variable name="v_upgradeDate">
        <xsl:variable name="v_crossrefparamLookup" select="document($v_pd)"/>
        <xsl:value-of
            select="$v_crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anTargetDocumentType]/CIGAddOnUpgradeDate"
        />
    </xsl:variable>
    <!--Get the Language code-->
    <xsl:template match="ARBCIG_REMADV/IDOC">
        <Combined>
            <Payload>
                <cXML>
                    <xsl:attribute name="payloadID">
                        <xsl:value-of select="E1IDKU1/E1ARBCIG_REMADV_HDR/PAYLOAD_ID"/>
                    </xsl:attribute>
                    <xsl:attribute name="timestamp">
                        <xsl:variable name="v_curDate">
                            <xsl:value-of select="current-dateTime()"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat(substring($v_curDate, 1, 19), substring($v_curDate, 24, 29))"
                        />
                    </xsl:attribute>
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
                                <Identity>CIG</Identity>
                            </Credential> 
                        </From>
                        <To>
                            <Credential domain="VendorID">
                                <Identity>
                                    <xsl:value-of select="E1EDKA1[PARVW = 'BE']/PARTN"/>
                                </Identity>
                            </Credential>
                            <Correspondent>
                                <Contact role="correspondent">
                                    <Name>
                                        <xsl:attribute name="xml:lang">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/LAISO)) > 0">
                                                  <xsl:value-of
                                                  select="E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/LAISO"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:call-template name="FillDefaultLang">
                                                        <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                                        <xsl:with-param name="p_pd" select="$v_pd"/>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of
                                            select="E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/NAME1"
                                        />
                                    </Name>
                                    <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/SMTP_ADDR))>0">
                                    <Email name="routing">
                                        <xsl:value-of
                                            select="E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/SMTP_ADDR"
                                        />
                                    </Email>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/TELFX))>0">
                                        <Fax name="">
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode"
                                                  > </xsl:attribute>
                                                </CountryCode>
                                                <AreaOrCityCode/>
                                                <Number>
                                                  <xsl:value-of
                                                  select="E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/TELFX"
                                                  />
                                                </Number>
                                            </TelephoneNumber>
                                        </Fax>
                                    </xsl:if>
                                </Contact>
                            </Correspondent>
                        </To>
                        <Sender>
                            <Credential domain="NetworkId">
                                <Identity>
                                    <xsl:value-of select="$anProviderANID"/>
                                </Identity>
                                <SharedSecret>
                                    <xsl:value-of select="$anSharedSecrete"/>
                                </SharedSecret>
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
                        <PaymentRemittanceRequest>
                            <PaymentRemittanceRequestHeader>
                                <xsl:attribute name="paymentRemittanceID">
                                    <xsl:choose>
                                        <xsl:when test="E1IDKU3/PAIRZAWE = 'C'">
                                            <xsl:value-of
                                                select="concat('C.', E1EDK03[IDDAT = '017']/DATUM, '.', E1IDKU1/BGMREF)"
                                            />
                                        </xsl:when>
                                        <xsl:when test="not(E1IDKU3/PAIRZAWE = 'C')">
                                            <xsl:value-of
                                                select="concat('Z.', E1EDK03[IDDAT = '017']/DATUM, '.', E1IDKU1/BGMREF)"
                                            />
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:attribute name="paymentDate">
<!--                 In xslt refactoring, we have taken decision that we will use local template FormatDateTime instead of AnDateTime.-->
                                    <xsl:call-template name="FormatDateTime">
                                        <xsl:with-param name="p_date"
                                            select="E1EDK03[IDDAT = '017']/DATUM"/>
                                        <xsl:with-param name="p_time"
                                            select="E1EDK03[IDDAT = '011']/UZEIT"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="paymentReferenceNumber">
                                    <xsl:value-of select="E1IDKU1/BGMREF"/>
                                </xsl:attribute>
                                <PaymentMethod>
                                    <xsl:attribute name="type">
                                        <xsl:choose>
                                            <xsl:when test="E1IDKU3/PAIRZAWE = 'A'">
                                                <xsl:value-of select="'ach'"/>
                                            </xsl:when>
                                            <xsl:when test="E1IDKU3/PAIRZAWE = 'U'">
                                                <xsl:value-of select="'ach'"/>
                                            </xsl:when>
                                            <xsl:when test="E1IDKU3/PAIRZAWE = 'T'">
                                                <xsl:value-of select="'ach'"/>
                                            </xsl:when>
                                            <xsl:when test="E1IDKU3/PAIRZAWE = 'Z'">
                                                <xsl:value-of select="'wire'"/>
                                            </xsl:when>
                                            <xsl:when test="E1IDKU3/PAIRZAWE = 'C'">
                                                <xsl:value-of select="'check'"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'other'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <!--  A table to convert SAP Orbian Payment Method to Ariba Network Orbian Payment Method should be maintained in Partner Directory -->
                                    <xsl:if test="EDI_DC40/MESTYP = 'REMADV'">
                                        <Description>
                                            <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/LAISO)) > 0">
                                                        <xsl:value-of
                                                            select="E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/LAISO"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:call-template name="FillDefaultLang">
                                                            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                                        </xsl:call-template>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <ShortName>
                                                <xsl:choose>
                                                  <xsl:when test="E1IDKU3/PAIRZAWE = 'OrbianPaymentMethod'">
                                                      <xsl:value-of select="'OrbianPaymentMethodDescription'"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'unknown'"/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </ShortName>
                                        </Description>
                                    </xsl:if>
                                    <!--********************************************************************************************************************************-->
                                </PaymentMethod>
                                <PaymentPartner>
                                    <Contact>
                                        <xsl:attribute name="role">
                                            <xsl:if test="E1EDKA1/PARVW = 'AG'">
                                                <xsl:value-of select="'payer'"/>
                                            </xsl:if>
                                        </xsl:attribute>
                                        <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/EIKTO)) > 0">
                                        <xsl:attribute name="addressID">
                                            <xsl:if test="E1EDKA1/PARVW = 'AG'" >
                                                <xsl:value-of select="E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/EIKTO"/>
                                            </xsl:if>
                                        </xsl:attribute>                                        
                                        <xsl:attribute name="addressIDDomain">
                                            <xsl:if test="E1EDKA1/PARVW = 'AG'">
                                                <xsl:value-of select="'payeeID'"/>
                                            </xsl:if>
                                        </xsl:attribute>
                                        </xsl:if>
                                        <Name>
                                            <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/LAISO)) > 0">
                                                        <xsl:value-of
                                                            select="E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/LAISO"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:call-template name="FillDefaultLang">
                                                            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                                        </xsl:call-template>
                                                    </xsl:otherwise>
                                                </xsl:choose>                              
                                            </xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/BUTXT)) > 0">
                                                    <xsl:value-of select="E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/BUTXT"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="E1EDKA1[PARVW = 'AG']/NAME1"/>    
                                                </xsl:otherwise>                                              
                                            </xsl:choose>
                                        </Name>
                                        <xsl:if
                                            test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/ORT01))>0 and string-length(normalize-space(E1EDKA1[PARVW = 'AG']/STRAS))>0 and string-length(normalize-space(E1EDKA1[PARVW = 'AG']/ISOAL))>0">
                                            <PostalAddress>
                                                <xsl:attribute name="name">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/NAME1)) > 0">
                                                            <xsl:value-of select="E1EDKA1[PARVW = 'AG']/NAME1"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'default'"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <Street>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/STRAS"
                                                  />
                                                </Street>
                                                <City>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/ORT01"
                                                  />
                                                </City>
                                                <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/REGIO))>0">
                                                <State>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/REGIO"
                                                  />
                                                </State>
                                                 </xsl:if>
                                                <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/PSTLZ))>0">
                                                <PostalCode>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/PSTLZ"
                                                  />
                                                </PostalCode>
                                                </xsl:if>
                                                <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/ISOAL"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/ISOAL"
                                                  />
                                                </Country>
                                            </PostalAddress>
                                        </xsl:if>
                                        <Phone>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                      <xsl:choose>
                                                          <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/LAND1)) > 0">
                                                              <xsl:value-of select="E1EDKA1[PARVW = 'AG']/LAND1"
                                                              />  
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of select="E1EDKA1[PARVW = 'AG']/ISOAL"
                                                              />
                                                          </xsl:otherwise>
                                                      </xsl:choose>
                                                  </xsl:attribute>
                                                </CountryCode>
                                                <AreaOrCityCode/>
                                                <Number>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/TELF1"
                                                  />
                                                </Number>
                                                <Extension>
                                                  <xsl:call-template name='substring-after-last'>
                                                  <xsl:with-param name='p_input' select="E1EDKA1[PARVW = 'AG']/TELF1"/>
                                                  <xsl:with-param name='p_substr' select="'-'"/>    
                                                  </xsl:call-template>   
                                                </Extension>
                                            </TelephoneNumber>
                                        </Phone>
                                        <Fax>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                      <xsl:choose>
                                                          <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/LAND1)) > 0">
                                                              <xsl:value-of select="E1EDKA1[PARVW = 'AG']/LAND1"
                                                              />
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of select="E1EDKA1[PARVW = 'AG']/ISOAL"
                                                              />
                                                          </xsl:otherwise>
                                                      </xsl:choose>
                                                  </xsl:attribute>
                                                </CountryCode>
                                                <AreaOrCityCode/>
                                                <Number>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'AG']/TELFX"
                                                  />
                                                </Number>
                                                <Extension>
                                                  <xsl:call-template name='substring-after-last'>
                                                  <xsl:with-param name='p_input' select="E1EDKA1[PARVW = 'AG']/TELFX"/>
                                                  <xsl:with-param name='p_substr' select="'-'"/>    
                                                  </xsl:call-template>
                                                </Extension>
                                            </TelephoneNumber>
                                        </Fax>
                                    </Contact>
                                    <xsl:if test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BA']/FIIKONTO))>0">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/FIIKONTO"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">
                                                <xsl:value-of select="'bankAccountID'"/>
                                            </xsl:attribute>
                                        </IdReference>
                                    </xsl:if>
                                </PaymentPartner>
                                <PaymentPartner>
                                    <Contact>
                                        <xsl:attribute name="role">
                                            <xsl:if test="E1EDKA1/PARVW = 'BE'">
                                                <xsl:value-of select="'payee'"/>
                                            </xsl:if>
                                        </xsl:attribute>
                                        <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/GPA1R)) > 0">
                                        <xsl:attribute name="addressID">
                                            <xsl:if test="E1EDKA1/PARVW = 'BE'" >
                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/GPA1R"/>
                                            </xsl:if>
                                        </xsl:attribute>                                        
                                        <xsl:attribute name="addressIDDomain">
                                            <xsl:if test="E1EDKA1/PARVW = 'BE'">
                                                <xsl:value-of select="'payerID'"/>
                                            </xsl:if>
                                        </xsl:attribute>
                                        </xsl:if>
                                        <Name>
                                            <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/LAISO)) > 0">
                                                        <xsl:value-of
                                                            select="E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/LAISO"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:call-template name="FillDefaultLang">
                                                            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                                        </xsl:call-template>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <xsl:value-of select="E1EDKA1[PARVW = 'BE']/NAME1"/>
                                        </Name>
                                        <PostalAddress>
                                            <Street>
                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/STRAS"/>
                                            </Street>
                                            <City>
                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/ORT01"/>
                                            </City>
                                            <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/REGIO))>0">
                                            <State>
                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/REGIO"/>
                                            </State>
                                            </xsl:if>
                                            <xsl:if test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/PSTLZ))>0">
                                            <PostalCode>
                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/PSTLZ"/>
                                            </PostalCode>
                                            </xsl:if>
                                            <Country>
                                                <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'BE']/ISOAL"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/ISOAL"/>
                                            </Country>
                                        </PostalAddress>
                                        <Phone>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                    <xsl:attribute name="isoCountryCode">
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/LAND1)) > 0">
                                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/LAND1"
                                                                />
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="E1EDKA1[PARVW = 'BE']/ISOAL"
                                                                />
                                                            </xsl:otherwise>
                                                        </xsl:choose> 
                                                  </xsl:attribute>
                                                </CountryCode>
                                                <AreaOrCityCode/>
                                                <Number>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'BE']/TELF1"
                                                  />
                                                </Number>
                                                <Extension>
                                                  <xsl:call-template name='substring-after-last'>
                                                  <xsl:with-param name='p_input' select="E1EDKA1[PARVW = 'BE']/TELF1"/>
                                                  <xsl:with-param name='p_substr' select="'-'"/>    
                                                  </xsl:call-template> 
                                                </Extension>
                                            </TelephoneNumber>
                                        </Phone>
                                        <Fax>
                                            <TelephoneNumber>
                                                <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                      <xsl:choose>
                                                          <xsl:when test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/LAND1)) > 0">
                                                              <xsl:value-of select="E1EDKA1[PARVW = 'BE']/LAND1"
                                                              />
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of select="E1EDKA1[PARVW = 'BE']/ISOAL"
                                                              />
                                                          </xsl:otherwise>
                                                      </xsl:choose> 
                                                  </xsl:attribute>
                                                </CountryCode>
                                                <AreaOrCityCode/>
                                                <Number>
                                                  <xsl:value-of select="E1EDKA1[PARVW = 'BE']/TELFX"
                                                  />
                                                </Number>
                                                <Extension>
                                                  <xsl:call-template name='substring-after-last'>
                                                  <xsl:with-param name='p_input' select="E1EDKA1[PARVW = 'BE']/TELFX"/>
                                                  <xsl:with-param name='p_substr' select="'-'"/>    
                                                  </xsl:call-template>  
                                                </Extension>
                                            </TelephoneNumber>
                                        </Fax>
                                    </Contact>
                                    <xsl:if test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BB']/FIIKONTO))>0">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/FIIKONTO"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">
                                                <xsl:value-of select="'bankAccountID'"/>
                                            </xsl:attribute>
                                        </IdReference>
                                    </xsl:if>
                                </PaymentPartner>
                                <PaymentPartner>
                                    <Contact>
                                        <xsl:attribute name="role">
                                            <xsl:if test="E1IDB02/FIIQUALI = 'BA'">
                                                <xsl:value-of select="'originatingBank'"/>
                                            </xsl:if>
                                        </xsl:attribute>
                                        <Name>
                                            <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="string-length(normalize-space(E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/LAISO)) > 0">
                                                        <xsl:value-of
                                                            select="E1EDKA1[PARVW = 'AG']/E1ARBCIG_PARTNER_INFO/LAISO"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:call-template name="FillDefaultLang">
                                                            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                                            <xsl:with-param name="p_pd" select="$v_pd"/>
                                                        </xsl:call-template>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                
                                            </xsl:attribute>
                                            <xsl:value-of select="E1IDB02[FIIQUALI = 'BA']/FIIBKNAM"
                                            />
                                        </Name>
                                        <xsl:if
                                            test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BA']/FIIBKENN))>0 and string-length(normalize-space(E1IDB02[FIIQUALI = 'BA']/FIIBLAND))>0 and string-length(normalize-space(E1IDB02[FIIQUALI = 'BA']/FIIBKORT))>0">
                                            <PostalAddress>
                                                <Street>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/E1ARBCIG_BANK_INFO/STREET"
                                                  />
                                                </Street>
                                                <City>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/FIIBKORT"/>
                                                </City>
                                                <xsl:if test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BA']/E1ARBCIG_BANK_INFO/STATE))>0">
                                                <State>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/E1ARBCIG_BANK_INFO/STATE"
                                                  />
                                                </State>
                                                 </xsl:if>
                                                <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/FIIBLAND"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/FIIBLAND"/>
                                                </Country>
                                            </PostalAddress>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BA']/COMNUMM1))>0">
                                            <Phone>
                                                <TelephoneNumber>
                                                  <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/FIIBLAND"/>
                                                  </xsl:attribute>
                                                  </CountryCode>
                                                  <AreaOrCityCode/>
                                                  <Number>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/COMNUMM1"/>
                                                  </Number>
                                                </TelephoneNumber>
                                            </Phone>
                                        </xsl:if>
                                    </Contact>
                                    <xsl:if test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BA']/FIIBKENN))>0">
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BA']/FIIBKENN"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">
                                                <xsl:value-of select="'bankRoutingID'"/>
                                            </xsl:attribute>                                            
                                        </IdReference>
                                    </xsl:if>
                                </PaymentPartner>
                                <xsl:if test="not(E1IDKU3/PAIRZAWE = 'C')">
                                    <PaymentPartner>
                                        <Contact>
                                            <xsl:attribute name="role">
                                                <xsl:if test="E1IDB02/FIIQUALI = 'BB'">
                                                    <xsl:value-of select="'receivingBank'"/>
                                                </xsl:if>
                                            </xsl:attribute>
                                            <Name>
                                                <xsl:attribute name="xml:lang">
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test="string-length(normalize-space(E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/LAISO)) > 0">
                                                            <xsl:value-of
                                                                select="E1EDKA1[PARVW = 'BE']/E1ARBCIG_PARTNER_INFO/LAISO"
                                                            />
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:call-template name="FillDefaultLang">
                                                                <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                                            </xsl:call-template>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/FIIBKNAM"/>
                                            </Name>
                                            <xsl:if
                                                test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BB']/FIIBKENN))>0 and string-length(normalize-space(E1IDB02[FIIQUALI = 'BB']/FIIBLAND))>0 and string-length(normalize-space(E1IDB02[FIIQUALI = 'BB']/FIIBKORT))>0">
                                                <PostalAddress>
                                                  <Street>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/E1ARBCIG_BANK_INFO/STREET"
                                                  />
                                                  </Street>
                                                  <City>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/FIIBKORT"/>
                                                  </City>
                                                  <State>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/E1ARBCIG_BANK_INFO/STATE"
                                                  />
                                                  </State>
                                                  <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/FIIBLAND"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/FIIBLAND"/>
                                                  </Country>
                                                </PostalAddress>
                                            </xsl:if>
                                            <Phone>
                                                <TelephoneNumber>
                                                  <CountryCode>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/FIIBLAND"/>
                                                  </xsl:attribute>
                                                  </CountryCode>
                                                  <AreaOrCityCode/>
                                                  <Number>
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/COMNUMM1"/>
                                                  </Number>
                                                </TelephoneNumber>
                                            </Phone>
                                        </Contact>
                                        <xsl:if test="string-length(normalize-space(E1IDB02[FIIQUALI = 'BB']/FIIBKENN))>0">
                                            <IdReference>
                                                <xsl:attribute name="identifier">
                                                  <xsl:value-of
                                                  select="E1IDB02[FIIQUALI = 'BB']/FIIBKENN"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="domain">
                                                    <xsl:value-of select="'bankRoutingID'"/>
                                                </xsl:attribute>                                                
                                            </IdReference>
                                        </xsl:if>
                                    </PaymentPartner>
                                </xsl:if>

                                <xsl:if test="string-length(normalize-space(E1IDKU1/E1ARBCIG_COMMENT[1]))>0 or $v_attach!=''">
                                <Comments>
                                    <xsl:call-template name="CommentsFillIdocOut">
                                        <xsl:with-param name="p_aribaComment"
                                            select="E1IDKU1/E1ARBCIG_COMMENT"/>
                                        <xsl:with-param name="p_doctype"
                                            select="$anTargetDocumentType"/>
                                        <xsl:with-param name="p_pd" select="$v_pd"/>
                                        <xsl:with-param name="p_trans" select="'PaymentRemittance'"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="addContenIdIDOC">
                                        <xsl:with-param name="eachAtt" select="$v_attach"/>
                                    </xsl:call-template>
                                </Comments>
                                </xsl:if>
                            </PaymentRemittanceRequestHeader>
                            <PaymentRemittanceSummary>
                                <NetAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="E1IDLU5[MOAQUAL = '002']/CUXWAERZ"
                                            />
                                        </xsl:attribute>
                                        <xsl:call-template name="FormatAmount">
                                            <xsl:with-param name="p_input"
                                                select="E1IDLU5[MOAQUAL = '002']/MOABETR"/>
                                        </xsl:call-template>
                                    </Money>
                                </NetAmount>
                                <GrossAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of
                                                select="E1IDLU5[MOAQUAL = '002']/CUXWAERZ"/>
                                        </xsl:attribute>
                                        <xsl:variable name="v_amt1">
                                            <xsl:call-template name="FormatAmount">
                                                <xsl:with-param name="p_input"
                                                  select="E1IDLU5[MOAQUAL = '002']/MOABETR"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_amt2">
                                            <xsl:call-template name="FormatAmount">
                                                <xsl:with-param name="p_input"
                                                  select="E1IDLU5[MOAQUAL = '003']/MOABETR"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:value-of
                                            select="format-number($v_amt1 + $v_amt2, '0.00', 'remit')"/>
                                    </Money>
                                </GrossAmount>
                                <DiscountAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="E1IDLU5[MOAQUAL = '003']/CUXWAERZ"
                                            />
                                        </xsl:attribute>
                                        <xsl:call-template name="FormatAmount">
                                            <xsl:with-param name="p_input"
                                                select="E1IDLU5[MOAQUAL = '003']/MOABETR"/>
                                        </xsl:call-template>
                                    </Money>
                                </DiscountAmount>
                                <xsl:if test="string-length(normalize-space(E1IDLU5[MOAQUAL = '031']/MOABETR)) > 0">
                                    <AdjustmentAmount>
                                        <Money>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of select="E1IDLU5[MOAQUAL = '031']/CUXWAERZ"/>
                                            </xsl:attribute> 
                                            <!-- Begin of IG-18558 Add amount -->
                                            <xsl:call-template name="FormatAmount">
                                                <xsl:with-param name="p_input"
                                                    select="E1IDLU5[MOAQUAL = '031']/MOABETR"/>
                                            </xsl:call-template> 
                                            <!-- End of IG-18558 -->                                            
                                        </Money>
                                        <Modifications>
                                            <Modification>
                                                <AdditionalDeduction>       
                                                    <xsl:attribute name="type">
                                                        <xsl:value-of select="'withholdingTax'"/>
                                                    </xsl:attribute>
                                                    <DeductionAmount>
                                                    <Money>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="E1IDLU5[MOAQUAL = '031']/CUXWAERZ"/>
                                                        </xsl:attribute>
                                                        <xsl:call-template name="FormatAmount">
                                                            <xsl:with-param name="p_input"
                                                             select="E1IDLU5[MOAQUAL = '031']/MOABETR"/>
                                                        </xsl:call-template>
                                                    </Money>
                                                    </DeductionAmount>
                                                </AdditionalDeduction>
                                            </Modification>
                                        </Modifications>
                                    </AdjustmentAmount>
                                </xsl:if>
                            </PaymentRemittanceSummary>
                            <xsl:for-each select="E1IDPU1">
                                <RemittanceDetail>
                                    <xsl:attribute name="lineNumber">
                                        <xsl:value-of select="position()"/>
                                    </xsl:attribute>
                                    <PayableInfo>
                                        <PayableInvoiceInfo>
                                            <InvoiceIDInfo>
                                                <xsl:variable name="v_date"
                                                    select="E1EDP03[IDDAT = '016']/DATUM"/>
                                                <xsl:variable name="v_formattedDate">
                                                    <xsl:value-of
                                                        select="xs:date(concat(substring($v_date, 1, 4), '-', substring($v_date, 5, 2), '-', substring($v_date, 7, 2)))"
                                                        xmlns:xs="http://www.w3.org/2001/XMLSchema"/>
                                                </xsl:variable>
                                                <xsl:attribute name="invoiceID">
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test="((string-length(normalize-space($v_upgradeDate)) > 0) and $v_formattedDate &lt;= xs:date($v_upgradeDate)) and (string-length(normalize-space(E1ARBCIG_PROPOSAL_INFO/XBLNR)) > 0)"
                                                            xmlns:xs="http://www.w3.org/2001/XMLSchema">
                                                            <xsl:value-of
                                                                select="E1ARBCIG_PROPOSAL_INFO/XBLNR"/>
                                                        </xsl:when>
                                                        <xsl:when test="string-length(normalize-space(DOCNUMMR))>0">
                                                            <xsl:value-of select="DOCNUMMR"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of
                                                                select="E1EDP02[QUALF = '010']/BELNR"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <!--IG-23813. Populate invoiceDate only when DOCDATUM exists-->
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="string-length(normalize-space(DOCDATUM)) > 0">
                                                        <xsl:attribute name="invoiceDate">
<!--                 In xslt refactoring, we have taken decision that we will use local template FormatDateTime instead of AnDateTime.-->
                                                            <xsl:call-template name="FormatDateTime">
                                                                <xsl:with-param name="p_date" select="DOCDATUM"/>
                                                            </xsl:call-template>
                                                        </xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:when
                                                        test="string-length(normalize-space(E1EDP03[IDDAT = '016']/DATUM)) > 0">
                                                        <xsl:attribute name="invoiceDate">
<!--                 In xslt refactoring, we have taken decision that we will use local template FormatDateTime instead of AnDateTime.-->                                                           
                                                            <xsl:call-template name="FormatDateTime">
                                                                <xsl:with-param name="p_date"
                                                                    select="E1EDP03[IDDAT = '016']/DATUM"/>
                                                            </xsl:call-template>
                                                        </xsl:attribute>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </InvoiceIDInfo>
                                        </PayableInvoiceInfo>
                                    </PayableInfo>
                                    <NetAmount>
                                        <Money>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of
                                                  select="E1IDPU5[MOAQUAL = '006']/CUXWAERZ"/>
                                            </xsl:attribute>
                                            <xsl:variable name="v_amt">
                                                <xsl:call-template name="FormatAmount">
                                                  <xsl:with-param name="p_input"
                                                  select="E1IDPU5[MOAQUAL = '006']/MOABETR"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="DOCNAME = 'CRM'">
                                                  <xsl:value-of select="($v_amt * -1)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="($v_amt * 1)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </Money>
                                    </NetAmount>
                                    <GrossAmount>
                                        <xsl:choose>
                                            <xsl:when
                                                test="string-length(normalize-space(E1IDPU5[MOAQUAL = '004']/CUXWAERZ))>0 and string-length(normalize-space(E1IDPU5[MOAQUAL = '004']/MOABETR))>0">
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="E1IDPU5[MOAQUAL = '004']/CUXWAERZ"/>
                                                  </xsl:attribute>
                                                  <xsl:variable name="v_amt">
                                                  <xsl:call-template name="FormatAmount">
                                                  <xsl:with-param name="p_input"
                                                  select="E1IDPU5[MOAQUAL = '004']/MOABETR"/>
                                                  </xsl:call-template>
                                                  </xsl:variable>
                                                  <xsl:choose>
                                                  <xsl:when test="DOCNAME = 'CRM'">
                                                  <xsl:value-of select="($v_amt * -1)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="($v_amt * 1)"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </Money>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if
                                                    test="string-length(normalize-space(E1IDPU5[MOAQUAL = '016']/CUXWAERZ))>0 and string-length(normalize-space(E1IDPU5[MOAQUAL = '016']/MOABETR))>0">
                                                  <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of
                                                  select="E1IDPU5[MOAQUAL = '016']/CUXWAERZ"/>
                                                  </xsl:attribute>
                                                  <xsl:variable name="v_amt">
                                                  <xsl:call-template name="FormatAmount">
                                                  <xsl:with-param name="p_input"
                                                  select="E1IDPU5[MOAQUAL = '016']/MOABETR"/>
                                                  </xsl:call-template>
                                                  </xsl:variable>
                                                  <xsl:choose>
                                                  <xsl:when test="DOCNAME = 'CRM'">
                                                  <xsl:value-of select="($v_amt * -1)"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="($v_amt * 1)"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </Money>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </GrossAmount>
                                    <DiscountAmount>
                                        <Money>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of
                                                  select="E1IDPU5[MOAQUAL = '003']/CUXWAERZ"/>
                                            </xsl:attribute>
                                            <xsl:variable name="v_amt">
                                                <xsl:call-template name="FormatAmount">
                                                  <xsl:with-param name="p_input"
                                                  select="E1IDPU5[MOAQUAL = '003']/MOABETR"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="DOCNAME = 'CRM'">
                                                  <xsl:value-of select="($v_amt * -1)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="($v_amt * 1)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </Money>
                                    </DiscountAmount>
                                    <xsl:if test="string-length(E1IDPU5[MOAQUAL = '030']/MOABETR) > 0.00">
                                        <AdjustmentAmount>
                                        <Money>
                                          <xsl:attribute name="currency">
                                              <xsl:value-of select="E1IDPU5[MOAQUAL = '030']/CUXWAERZ"/>
                                          </xsl:attribute> 
                                            <!-- Begin of IG-18558 Add amount --> 
                                            <xsl:call-template name="FormatAmount">
                                                <xsl:with-param name="p_input"
                                                    select="E1IDPU5[MOAQUAL = '030']/MOABETR"/>
                                            </xsl:call-template>
                                            <!-- End of IG-18558 -->                                            
                                        </Money>                                            
                                        <Modifications>
                                            <Modification>
                                                <AdditionalDeduction>
                                                    <xsl:attribute name="type">
                                                        <xsl:value-of select="'withholdingTax'"/>
                                                    </xsl:attribute>
                                                    <DeductionAmount>
                                                        <Money>
                                                            <xsl:attribute name="currency">
                                                                <xsl:value-of select="E1IDPU5[MOAQUAL = '030']/CUXWAERZ"
                                                                />
                                                            </xsl:attribute>
                                                            <xsl:call-template name="FormatAmount">
                                                                <xsl:with-param name="p_input"
                                                                    select="E1IDPU5[MOAQUAL = '030']/MOABETR"/>
                                                            </xsl:call-template>
                                                        </Money>
                                                    </DeductionAmount>
                                                </AdditionalDeduction>
                                            </Modification>
                                        </Modifications>
                                        </AdjustmentAmount>
                                    </xsl:if>
                                    <Extrinsic>
                                        <xsl:attribute name="name">
                                            <xsl:value-of select="'PaymentProposalID'"/>
                                        </xsl:attribute>
                                        <xsl:value-of
                                            select="E1ARBCIG_PROPOSAL_INFO/PAYMENT_PROPOSAL_ID"/>
                                    </Extrinsic>
                                    <Extrinsic>
                                        <xsl:attribute name="name">
                                            <xsl:value-of select="'buyerInvoiceID'"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="E1EDP02[QUALF = '010']/BELNR"/>
                                    </Extrinsic>
                                    <xsl:if test="string-length(normalize-space(E1ARBCIG_PROPOSAL_INFO/XBLNR)) > 0">
                                    <Extrinsic>
                                        <xsl:attribute name="name">
                                            <xsl:value-of select="'OriginalInvoiceNo'"/>
                                        </xsl:attribute>
                                        <xsl:value-of
                                            select="E1ARBCIG_PROPOSAL_INFO/XBLNR"/>
                                    </Extrinsic>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(E1ARBCIG_PROPOSAL_INFO/BUKRS))> 0">
                                    <Extrinsic>
                                        <xsl:attribute name="name">
                                            <xsl:value-of select="'CompanyCode'"/>
                                        </xsl:attribute>
                                        <xsl:value-of
                                            select="E1ARBCIG_PROPOSAL_INFO/BUKRS"/>
                                    </Extrinsic>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(E1ARBCIG_PROPOSAL_INFO/GJAHR)) > 0">
                                    <Extrinsic>
                                        <xsl:attribute name="name">
                                            <xsl:value-of select="'fiscalYear'"/>
                                        </xsl:attribute>
                                        <xsl:value-of
                                            select="E1ARBCIG_PROPOSAL_INFO/GJAHR"/>
                                    </Extrinsic>
                                    </xsl:if>
                                </RemittanceDetail>

                            </xsl:for-each>

                        </PaymentRemittanceRequest>
                    </Request>
                </cXML>
            </Payload>
            <xsl:call-template name="OutBoundAttachIDOC">
                <xsl:with-param name="eachAtt" select="$v_attach"/>
            </xsl:call-template>
        </Combined>
    </xsl:template>
    <xsl:template name="FormatAmount">
        <xsl:param name="p_input"/>
        <xsl:variable name="v_price" select="normalize-space($p_input)"/>
        <xsl:choose>
            <xsl:when test="(substring($v_price, string-length($v_price), 1)) = '-'">
                <xsl:value-of
                    select="format-number(number(concat('-', substring($v_price, 1, string-length($v_price) - 1))), '0.00', 'remit')"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number(number($v_price), '0.00', 'remit')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="FormatDateTime">
        <xsl:param name="p_date"/>
        <xsl:param name="p_time"/>
        <xsl:param name="p_timezone"/>
        <xsl:variable name="v_convDate">
            <xsl:value-of
                select="concat(substring($p_date, 1, 4), '-', substring($p_date, 5, 2), '-', substring($p_date, 7, 2))"
            />
        </xsl:variable>
        <xsl:variable name="v_convTime">
            <xsl:value-of
                select="concat(substring($p_time, 1, 2), ':', substring($p_time, 3, 2), ':', substring($p_time, 5, 2))"
            />
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($v_convTime = '::')">
                <xsl:value-of select="concat($v_convDate, 'T', $v_convTime, $p_timezone)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$v_convDate"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="substring-after-last">
        <xsl:param name="p_input"/>
        <xsl:param name="p_substr"/>
        
        <!-- Extract the string which comes after the first occurence -->
        <xsl:variable name="v_temp" select="substring-after($p_input,$p_substr)"/>
        
        <xsl:choose>
            <!-- If it still contains the search string the recursively process -->
            <xsl:when test="$p_substr and contains($v_temp,$p_substr)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="p_input" select="$v_temp"/>
                    <xsl:with-param name="p_substr" select="$p_substr"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$v_temp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
</xsl:stylesheet>
