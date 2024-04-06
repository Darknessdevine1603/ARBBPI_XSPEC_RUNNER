<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
  exclude-result-prefixes="#all" version="2.0">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
  <!-- Parameters defined for MultiERP and Timezone. Set to constant values for testing-->
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anIsMultiERP"/>
  <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>  
<!--  <xsl:include href="..\..\..\common\FORMAT_AddOn_0000_cXML_0000.xsl"/>    -->
  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anERPSystemID"/>
  <xsl:param name="anERPTimeZone"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="anTargetDocumentType"/>
  <!--PD path  -->
  <xsl:variable name="v_pd">
    <xsl:call-template name="PrepareCrossref">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
      <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
    </xsl:call-template>
  </xsl:variable>
  <!--    Default language-->
  <xsl:variable name="v_lang">
    <xsl:call-template name="FillDefaultLang">
      <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
      <xsl:with-param name="p_pd" select="$v_pd"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:template match="n0:RequisitionDetailsRequest">
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
            <xsl:value-of
              select="concat(substring(string(current-date()), 1, 10), 'T', substring(string(current-time()), 1, 8), $anERPTimeZone)"
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
          <xsl:for-each select="/n0:RequisitionDetailsRequest/Header">
            <Request>
              <xsl:choose>
                <xsl:when test="$anEnvName = 'PROD'">
                  <xsl:attribute name="deploymentMode">
                    <xsl:value-of select="'production'"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="deploymentMode">
                    <xsl:value-of select="'test'"/></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <PurchaseRequisitionRequest>
                <PurchaseRequisition>
                  <PurchaseRequisitionHeader>
                    <xsl:attribute name="requisitionID">
                      <xsl:value-of select="DocumentID"/>
                    </xsl:attribute>
                    <xsl:if test="DocumentDate != ''">
                      <xsl:attribute name="requisitionDate">
                        <xsl:value-of
                          select="concat(DocumentDate, 'T', substring(string(current-time()), 1, 8), $anERPTimeZone)"
                        />
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="type">
                      <xsl:value-of select="DocumentType"/>
                    </xsl:attribute>
                    <Contact>
                      <xsl:attribute name="role">
                        <xsl:value-of select="'preparer'"/>
                      </xsl:attribute>
                      <xsl:attribute name="addressID">
                        <xsl:value-of select="ItemDetails[1]/CreatedBy"/>
                      </xsl:attribute>
                      <Name>
                        <xsl:attribute name="xml:lang">
                          <xsl:value-of select="$v_lang"/>
                        </xsl:attribute>
                        <xsl:value-of select="ItemDetails[1]/CreatedBy"/>
                      </Name>
                      <PostalAddress>
                        <xsl:attribute name="name">
                          <xsl:value-of select="ItemDetails[1]/CreatedByName"/>
                        </xsl:attribute>
                        <Street>
                          <xsl:value-of select="ItemDetails[1]/CreatedByStreet"/>
                        </Street>
                        <City>
                          <xsl:value-of select="ItemDetails[1]/CreatedByCity"/>
                        </City>
                        <State>
                          <xsl:value-of select="ItemDetails[1]/CreatedByState"/>
                        </State>
                        <PostalCode>
                          <xsl:value-of select="ItemDetails[1]/CreatedByPcode"/>
                        </PostalCode>
                        <Country>
                          <xsl:attribute name="isoCountryCode">
                            <xsl:value-of select="ItemDetails[1]/CreatedByIsoCountry"/>
                          </xsl:attribute>
                          <xsl:value-of select="ItemDetails[1]/CreatedByCountry"/>
                        </Country>
                      </PostalAddress>
                      <Email>
                        <xsl:value-of select="ItemDetails[1]/CreatedByEmail"/>
                      </Email>
                    </Contact>
                    <xsl:if test="ItemDetails[1]/PreqName">
                      <Contact>
                        <xsl:attribute name="role">
                          <xsl:value-of select="'requester'"/>
                        </xsl:attribute>
                        <xsl:attribute name="addressID">
                          <xsl:value-of select="ItemDetails[1]/PreqName"/>
                        </xsl:attribute>
                        <Name>
                          <xsl:attribute name="xml:lang">
                            <xsl:value-of select="$v_lang"/>
                          </xsl:attribute>
                          <xsl:value-of select="ItemDetails[1]/PreqName"/>
                        </Name>
                        <PostalAddress>
                          <xsl:attribute name="name">
                            <xsl:value-of select="ItemDetails[1]/RequesterName"/>
                          </xsl:attribute>
                          <Street>
                            <xsl:value-of select="ItemDetails[1]/RequesterStreet"/>
                          </Street>
                          <City>
                            <xsl:value-of select="ItemDetails[1]/RequesterCity"/>
                          </City>
                          <State>
                            <xsl:value-of select="ItemDetails[1]/RequesterState"/>
                          </State>
                          <PostalCode>
                            <xsl:value-of select="ItemDetails[1]/RequesterPcode"/>
                          </PostalCode>
                          <Country>
                            <xsl:attribute name="isoCountryCode">
                              <xsl:value-of select="ItemDetails[1]/RequesterIsoCountry"/>
                            </xsl:attribute>
                            <xsl:value-of select="ItemDetails[1]/RequesterCountry"/>
                          </Country>
                        </PostalAddress>
                        <Email>
                          <xsl:value-of select="ItemDetails[1]/RequesterEmail"/>
                        </Email>
                      </Contact>
                    </xsl:if>
                    <xsl:if test="/n0:RequisitionDetailsRequest/AribaComment/Item[not(ItemNumber)] | /n0:RequisitionDetailsRequest/Attachments/Item[not(LineNumber)]">                    
                      <Comments>
                        <xsl:call-template name="MapMultiple_Text_Comments_Proxy_To_cXML">
                          <xsl:with-param name="p_aribaComment"
                            select="/n0:RequisitionDetailsRequest/AribaComment"/>
                          <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                          <xsl:with-param name="p_pd" select="$v_pd"/>
                          <xsl:with-param name="p_trans" select="'PurchaseRequisitionRequest'"/>
                        </xsl:call-template>  
                        <xsl:call-template name="addContenId">
                          <xsl:with-param name="eachAtt" select="/n0:RequisitionDetailsRequest/Attachments/Item"/>                             
                        </xsl:call-template>
                      </Comments>
                    </xsl:if>
                    <Extrinsic name="Source System Request ID">                      
                      <xsl:value-of select="DocumentID"/>
                    </Extrinsic>
                    <Extrinsic name="Source System">SAP</Extrinsic>
                  </PurchaseRequisitionHeader>
                  <xsl:for-each select="ItemDetails">
                    <ItemIn>
                      <xsl:attribute name="quantity">
                        <xsl:value-of select="Quantity"/>
                      </xsl:attribute>
                      <xsl:attribute name="lineNumber">
                        <xsl:value-of select="ItemID"/>
                      </xsl:attribute>
                      <ItemID>
                        <SupplierPartID>
                          <xsl:value-of select="VendorMaterial"/>
                        </SupplierPartID>
                      </ItemID>
                      <ItemDetail>
                        <UnitPrice>
                          <Money>
                            <xsl:attribute name="currency">
                              <xsl:value-of select="Currency"/>
                            </xsl:attribute>
                            <xsl:value-of select="(CAmtBapi div PriceUnit)"/>
                          </Money>
                        </UnitPrice>
                        <Description>
                          <!-- Language conversion to be taken from pd -->
                          <xsl:call-template name="FillLangOut">
                            <xsl:with-param name="p_spras" select="Lang"/>
                            <xsl:with-param name="p_lang" select="$v_lang"/>
                          </xsl:call-template>
                          <xsl:value-of select="ShortText"/>
                        </Description>
                        <!-- UOM conversion to be taken from pd -->
                        <UnitOfMeasure>
                          <xsl:call-template name="UOMTemplate_Out">
                            <xsl:with-param name="p_UOMinput" select="Unit"/>
                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                            <xsl:with-param name="p_anSupplierANID" select="$anSupplierANID"/>
                          </xsl:call-template>
                        </UnitOfMeasure>
                        <Classification>
                          <xsl:attribute name="domain">
                            <xsl:value-of select="'UNSPSC'"/>
                          </xsl:attribute>
                          <xsl:value-of select="MaterialGrp"/>
                        </Classification>
                        <xsl:if test="DelivDate != ''">
                          <LeadTime>
                            <xsl:value-of
                              select="concat(DelivDate, 'T', substring(string(current-time()), 1, 8), $anERPTimeZone)"
                            />
                          </LeadTime>
                        </xsl:if>
                        <xsl:if test="AcctAssCat">
                          <Extrinsic>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'AccountCategory'"/>
                            </xsl:attribute>
                            <xsl:value-of select="AcctAssCat"/>
                          </Extrinsic>
                        </xsl:if>
                        <xsl:if test="ItemCat">
                          <Extrinsic>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'ItemCategory'"/>
                            </xsl:attribute>
                            <xsl:if test="ItemCat = '0'">
                              <xsl:value-of select="'M'"/>
                            </xsl:if>
                            <xsl:if test="ItemCat = 'D'">
                              <xsl:value-of select="'S'"/>
                            </xsl:if>
                          </Extrinsic>
                        </xsl:if>
                        <xsl:if test="Material">
                          <Extrinsic>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'BuyerPartNumber'"/>
                            </xsl:attribute>
                            <xsl:value-of select="Material"/>
                          </Extrinsic>
                        </xsl:if>
                        <xsl:if test="Plant">
                          <Extrinsic>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'Facility'"/>
                            </xsl:attribute>
                            <xsl:value-of select="Plant"/>
                          </Extrinsic>
                        </xsl:if>
                        <xsl:if test="PurchOrg">
                          <Extrinsic>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'PurchaseOrg'"/>
                            </xsl:attribute>
                            <xsl:value-of select="PurchOrg"/>
                          </Extrinsic>
                        </xsl:if>
                        <xsl:if test="PreqName">
                          <Extrinsic>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'DeliverTo'"/>
                            </xsl:attribute>
                            <xsl:value-of select="PreqName"/>
                          </Extrinsic>
                        </xsl:if>
                        <Extrinsic>
                          <xsl:attribute name="name">
                            <xsl:value-of select="'OriginatingSystemLineNumber'"/>
                          </xsl:attribute>
                          <xsl:value-of select="ItemID"/>
                        </Extrinsic>
                        <!--                        Required extrinsic field  Need By Date in Purchase requisition Request  -->
                        <xsl:if test="DelivDate != ''">
                          <Extrinsic>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'Need-by Date'"/>
                            </xsl:attribute>
                            <xsl:value-of select="concat(DelivDate, 'T', substring(string(current-time()), 1, 8), $anERPTimeZone)"/>
                          </Extrinsic>
                        </xsl:if>                       
                      </ItemDetail>
                      <SupplierList>
                        <Supplier>
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space(FixedVendor)) > 0">
                              <Name>
                                <xsl:call-template name="FillLangOut">
                                  <xsl:with-param name="p_spras" select="Lang"/>
                                  <xsl:with-param name="p_lang" select="$v_lang"/>
                                </xsl:call-template>
                                <xsl:value-of select="FixedVendor"/>
                              </Name>
                            </xsl:when>
                            <xsl:otherwise>
                              <Name>
                                <xsl:call-template name="FillLangOut">
                                  <xsl:with-param name="p_spras" select="Lang"/>
                                  <xsl:with-param name="p_lang" select="$v_lang"/>
                                </xsl:call-template>
                                <xsl:value-of select="DESVendor"/>
                              </Name>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space(FixedVendor)) > 0">
                              <SupplierID>
                                <xsl:attribute name="domain">
                                  <xsl:value-of select="'privateID'"/>
                                </xsl:attribute>
                                <xsl:value-of select="FixedVendor"/>
                              </SupplierID>
                            </xsl:when>
                            <xsl:otherwise>
                              <SupplierID>
                                <xsl:attribute name="domain">
                                  <xsl:value-of select="'privateID'"/>
                                </xsl:attribute>
                                <xsl:value-of select="DESVendor"/>
                              </SupplierID>
                            </xsl:otherwise>
                          </xsl:choose>
                          <SupplierLocation>
                            <Address>
                              <xsl:choose>
                                <xsl:when test="string-length(normalize-space(FixedVendor)) > 0">
                                  <xsl:attribute name="addressID">
                                    <xsl:value-of select="FixedVendor"/>
                                  </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="addressID">
                                    <xsl:value-of select="DESVendor"/>
                                  </xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:choose>
                                <xsl:when test="string-length(normalize-space(FixedVendor)) > 0">
                                  <Name>
                                    <xsl:call-template name="FillLangOut">
                                      <xsl:with-param name="p_spras" select="Lang"/>
                                      <xsl:with-param name="p_lang" select="$v_lang"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="FixedVendor"/>
                                  </Name>
                                </xsl:when>
                                <xsl:otherwise>
                                  <Name>
                                    <xsl:call-template name="FillLangOut">
                                      <xsl:with-param name="p_spras" select="Lang"/>
                                      <xsl:with-param name="p_lang" select="$v_lang"/>
                                    </xsl:call-template>
                                    <xsl:value-of select="DESVendor"/>
                                  </Name>
                                </xsl:otherwise>
                              </xsl:choose>
                            </Address>
                            <OrderMethods>
                              <OrderMethod>
                                <OrderTarget>
                                  <OtherOrderTarget>
                                    <xsl:attribute name="name"/>
                                  </OtherOrderTarget>
                                </OrderTarget>
                              </OrderMethod>
                            </OrderMethods>
                          </SupplierLocation>
                        </Supplier>
                      </SupplierList>
                      <ShipTo>
                        <Address>
                          <xsl:attribute name="addressID">
                            <xsl:value-of select="Plant"/>
                          </xsl:attribute>
                          <Name>
                            <!-- Lang conversion to be taken from pd -->
                            <xsl:call-template name="FillLangOut">
                              <xsl:with-param name="p_spras" select="PlantLang"/>
                              <xsl:with-param name="p_lang" select="$v_lang"/>
                            </xsl:call-template>
                            <xsl:value-of select="PlantName"/>
                          </Name>
                          <PostalAddress>
                            <Street>
                              <xsl:value-of select="PlantStreet"/>
                            </Street>
                            <City>
                              <xsl:value-of select="PlantCity"/>
                            </City>
                            <State>
                              <xsl:value-of select="PlantState"/>
                            </State>
                            <PostalCode>
                              <xsl:value-of select="PlantPcode"/>
                            </PostalCode>
                            <Country>
                              <xsl:attribute name="isoCountryCode">
                                <xsl:value-of select="PlantIsocountry"/>
                              </xsl:attribute>
                              <xsl:value-of select="PlantCountry"/>
                            </Country>
                          </PostalAddress>
                          <Email>
                            <xsl:attribute name="name">
                              <xsl:value-of select="PlantEmail"/>
                            </xsl:attribute>
                          </Email>
                          <xsl:if test="PlantPhone != ''">
                            <Phone>
                              <TelephoneNumber>
                                <CountryCode>
                                  <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="PhoneCountryCode"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="PhoneCountryCode"/>
                                </CountryCode>
                                <AreaOrCityCode>
                                  <xsl:value-of select="PlantAreaCode"/>
                                </AreaOrCityCode>
                                <Number>
                                  <xsl:value-of select="PlantPhone"/>
                                </Number>
                              </TelephoneNumber>
                            </Phone>
                          </xsl:if>
                          <xsl:if test="PlantFax != ''">
                            <Fax>
                              <TelephoneNumber>
                                <CountryCode>
                                  <xsl:attribute name="isoCountryCode">
                                    <xsl:value-of select="FaxCountryCode"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="FaxCountryCode"/>
                                </CountryCode>
                                <AreaOrCityCode>
                                  <xsl:value-of select="PlantAreaCode"/>
                                </AreaOrCityCode>
                                <Number>
                                  <xsl:value-of select="PlantFax"/>
                                </Number>
                              </TelephoneNumber>
                            </Fax>
                          </xsl:if>
                        </Address>
                      </ShipTo>
                      <xsl:for-each select="AcctLineItems">
                        <Distribution>
                          <Accounting>
                            <xsl:attribute name="name">
                              <xsl:value-of select="'Distribution Charge'"/>
                            </xsl:attribute>
                            <xsl:if test="GLAccount">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="GLAccount"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'GeneralLedger'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>
                            <xsl:if test="CostCenter">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="CostCenter"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'CostCenter'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>
                            <xsl:if test="OrderNumber">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="OrderNumber"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'InternalOrder'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>
                            <xsl:if test="WBSElem">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="WBSElem"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'WBSElement'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>
                            <xsl:if test="AssetNumber">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="AssetNumber"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'Asset'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>
                            <!-- CI-1946 Support A/c Category Network & Activity -->
                            <xsl:if test="NetworkID">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="NetworkID"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'Network'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if> 
                            <xsl:if test="ActivityNumber">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="ActivityNumber"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ActivityNumber'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>                             
                            <!-- End of CI-1946 -->
                            <xsl:if test="DistrPerc">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="DistrPerc"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'Percentage'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>
                            <xsl:if test="SubNumber">
                              <AccountingSegment>
                                <xsl:attribute name="id">
                                  <xsl:value-of select="SubNumber"/>
                                </xsl:attribute>
                                <Name>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'SubNumber'"/>
                                </Name>
                                <Description>
                                  <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="$v_lang"/>
                                  </xsl:attribute>
                                  <xsl:value-of select="'ID'"/>
                                </Description>
                              </AccountingSegment>
                            </xsl:if>
                          </Accounting>
                          <Charge>
                            <Money>
                              <xsl:attribute name="currency">
                                <xsl:value-of select="Currency"/>
                              </xsl:attribute>
                              <xsl:value-of select="Amount"/>
                            </Money>
                          </Charge>
                        </Distribution>
                      </xsl:for-each>
                      <xsl:if test="/n0:RequisitionDetailsRequest/AribaComment | /n0:RequisitionDetailsRequest/Attachments/Item[LineNumber = ItemID]" >
                        <Comments>
                          <xsl:call-template name="MapMultiple_Text_Comments_Proxy_To_cXML">
                            <xsl:with-param name="p_aribaComment"
                              select="/n0:RequisitionDetailsRequest/AribaComment"/>
                            <xsl:with-param name="p_itemNumber" select="ItemID"/>                                  
                            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
                            <xsl:with-param name="p_pd" select="$v_pd"/>
                            <xsl:with-param name="p_trans" select="'PurchaseRequisitionRequest'"/>
                          </xsl:call-template>  
                          <xsl:call-template name="addContenId">
                            <xsl:with-param name="eachAtt" select="/n0:RequisitionDetailsRequest/Attachments/Item"/>                            
                            <xsl:with-param name="lineNumber" select="ItemID"/>
                          </xsl:call-template>
                        </Comments>
                        </xsl:if>
                    </ItemIn>
                  </xsl:for-each>
                </PurchaseRequisition>
              </PurchaseRequisitionRequest>
            </Request>
          </xsl:for-each>
        </cXML>
      </Payload>
      <xsl:call-template name="OutBoundAttach"/>
    </Combined>
  </xsl:template>
</xsl:stylesheet>
