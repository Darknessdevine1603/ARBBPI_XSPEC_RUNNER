<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:param name="anISASender"/>
  <xsl:param name="anISASenderQual"/>
  <xsl:param name="anISAReceiver"/>
  <xsl:param name="anISAReceiverQual"/>
  <xsl:param name="anDate"/>
  <xsl:param name="anTime"/>
  <xsl:param name="anICNValue"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="anSenderGroupID"/>
  <xsl:param name="anReceiverGroupID"/>
  <xsl:param name="anGLNFlip"/>
  <xsl:param name="exchange"/>
  <!-- For local testing -->
  <!--<xsl:variable name="Lookup" select="document('LOOKUP_EANCOM_D01BEAN010.xml')"/> 
  <xsl:include href="FORMAT_cXML_0000_EANCOM_D01BEAN010.xsl"/>-->
  <!-- PD references -->
 <xsl:include href="FORMAT_cXML_0000_EANCOM_D01BEAN010.xsl"/>
  <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_EANCOM_D01BEAN011.xml')"/>
  <xsl:template match="/">
    <xsl:variable name="dateNow" select="current-dateTime()"/>
    <ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact">
      <S_UNA>:+.? '</S_UNA>
      <S_UNB>
        <C_S001>
          <D_0001>UNOC</D_0001>
          <D_0002>3</D_0002>
        </C_S001>
        <xsl:choose>
          <xsl:when test="lower-case($anGLNFlip) = 'true'">
            <C_S002>
              <D_0004>
                <xsl:value-of select="$anSenderGroupID"/>
              </D_0004>
              <D_0007>
                <xsl:value-of select="$anISASenderQual"/>
              </D_0007>
              <!--D_0008>								<xsl:value-of select="$anSenderGroupID"/>							</D_0008-->
            </C_S002>
          </xsl:when>
          <xsl:otherwise>
            <C_S002>
              <D_0004>
                <xsl:value-of select="$anISASender"/>
              </D_0004>
              <D_0007>
                <xsl:value-of select="$anISASenderQual"/>
              </D_0007>
              <D_0008>
                <xsl:value-of select="$anSenderGroupID"/>
              </D_0008>
            </C_S002>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="lower-case($anGLNFlip) = 'true'">
            <C_S003>
              <D_0010>
                <xsl:value-of select="$anISAReceiver"/>
              </D_0010>
              <D_0007>
                <xsl:value-of select="$anISAReceiverQual"/>
              </D_0007>
              <!--D_0014>								<xsl:value-of select="$anReceiverGroupID"/>							</D_0014-->
            </C_S003>
          </xsl:when>
          <xsl:otherwise>
            <C_S003>
              <D_0010>
                <xsl:value-of select="$anISAReceiver"/>
              </D_0010>
              <D_0007>
                <xsl:value-of select="$anISAReceiverQual"/>
              </D_0007>
              <D_0014>
                <xsl:value-of select="$anReceiverGroupID"/>
              </D_0014>
            </C_S003>
          </xsl:otherwise>
        </xsl:choose>
        <C_S004>
          <D_0017>
            <xsl:value-of select="format-dateTime($dateNow, '[Y01][M01][D01]')"/>
          </D_0017>
          <D_0019>
            <xsl:value-of select="format-dateTime($dateNow, '[H01][M01]')"/>
          </D_0019>
        </C_S004>
        <D_0020>
          <xsl:value-of select="$anICNValue"/>
        </D_0020>
        <!-- IG-6333 changes -->
        <D_0026/>
        <D_0031>1</D_0031>
        <xsl:if test="upper-case($anEnvName) = 'TEST'">
          <D_0035>1</D_0035>
        </xsl:if>
      </S_UNB>
      <M_ORDCHG>
        <S_UNH>
          <D_0062>0001</D_0062>
          <C_S009>
            <D_0065>ORDCHG</D_0065>
            <D_0052>D</D_0052>
            <D_0054>01B</D_0054>
            <D_0051>UN</D_0051>
            <D_0057>EAN007</D_0057>
            <!-- should be EAN007 as per schema -->
          </C_S009>
        </S_UNH>
        <S_BGM>
          <C_C002>
            <D_1001>
              <xsl:choose>
                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'change'">230</xsl:when>
                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">230</xsl:when>
                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">230</xsl:when>
              </xsl:choose>
            </D_1001>
            <D_1000>
              <xsl:choose>
                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'change'"
                  >Purchase Order Change Request</xsl:when>
                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'"
                  >Purchase Order Change Request</xsl:when>
                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'"
                  >Purchase Order Change Request</xsl:when>
              </xsl:choose>
            </D_1000>
          </C_C002>
          <C_C106>
            <D_1004>
              <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderID"/>
            </D_1004>
            <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion != ''">
              <D_1056>
                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion"/>
              </D_1056>
            </xsl:if>
          </C_C106>
          <D_1225>
            <xsl:choose>
              <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">5</xsl:when>
              <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">3</xsl:when>
            </xsl:choose>
          </D_1225>
        </S_BGM>
        <!-- <xsl:call-template name="mapCommonOrderHeaderElements"/>-->
        <xsl:call-template name="mapCommonOrderHeaderElements">
          <xsl:with-param name="isChangeOrder">true</xsl:with-param>
        </xsl:call-template>
        <!-- Bill To -->
        <xsl:if
          test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/@addressID) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/Name) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/PostalAddress/Street) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/Email) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/Phone/TelephoneNumber/Number) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/Fax/TelephoneNumber/Number) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address/URL) != ''">
          <G_SG3>
            <xsl:call-template name="createNAD">
              <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo"/>
              <xsl:with-param name="role" select="'billTo'"/>
              <xsl:with-param name="refGrupNum" select="'G_SG4'"/>
            </xsl:call-template>
            <xsl:call-template name="CTACOMLoop">
              <xsl:with-param name="contact" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address"/>
              <xsl:with-param name="contactType" select="'BillTo'"/>
              <xsl:with-param name="isPOUpdate" select="'true'"/>
            </xsl:call-template>
          </G_SG3>
        </xsl:if>
        <!-- Ship To -->
        <xsl:if
          test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Name) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/Street) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Email) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Phone/TelephoneNumber/Number) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Fax/TelephoneNumber/Number) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/URL) != ''">
          <G_SG3>
            <xsl:call-template name="createNAD">
              <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"/>
              <xsl:with-param name="role" select="'shipTo'"/>
              <xsl:with-param name="refGrupNum" select="'G_SG4'"/>
            </xsl:call-template>
            <xsl:call-template name="CTACOMLoop">
              <xsl:with-param name="contact" select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
              <xsl:with-param name="contactType" select="'ShipTo'"/>
              <xsl:with-param name="isPOUpdate" select="'true'"/>
            </xsl:call-template>
          </G_SG3>
        </xsl:if>
        <!-- TermsOfDelivery -->
        <xsl:if
          test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/@addressID) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/Name) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/PostalAddress/Street) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/Email) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/Phone/TelephoneNumber/Number) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/Fax/TelephoneNumber/Number) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/URL) != ''">
          <G_SG3>
            <xsl:call-template name="createNAD">
              <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address"/>
              <xsl:with-param name="role" select="'deliveryParty'"/>
              <xsl:with-param name="refGrupNum" select="'G_SG4'"/>
            </xsl:call-template>
            <xsl:call-template name="CTACOMLoop">
              <xsl:with-param name="contact" select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address"/>
              <xsl:with-param name="contactType" select="'TermsOfDelivery'"/>
              <xsl:with-param name="isPOUpdate" select="'true'"/>
            </xsl:call-template>
          </G_SG3>
        </xsl:if>
        <!-- Contact -->
        <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Contact">
          <xsl:if
            test="normalize-space(@addressID) != '' or normalize-space(Name) != '' or normalize-space(PostalAddress/Street) != '' or normalize-space(Email) != '' or normalize-space(Phone/TelephoneNumber/Number) != '' or normalize-space(Fax/TelephoneNumber/Number) != '' or normalize-space(URL) != ''">
            <G_SG3>
              <xsl:call-template name="createNAD">
                <xsl:with-param name="party" select="."/>
                <xsl:with-param name="role" select="@role"/>
                <xsl:with-param name="refGrupNum" select="'G_SG4'"/>
              </xsl:call-template>
              <xsl:call-template name="CTACOMLoop">
                <xsl:with-param name="contact" select="."/>
                <xsl:with-param name="isPOUpdate" select="'true'"/>
                <xsl:with-param name="contactType" select="@role"/>
              </xsl:call-template>
            </G_SG3>
          </xsl:if>
        </xsl:for-each>
        <!-- OrderRequestHeader/Tax/TaxDetail -->
        <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail">
          <G_SG7>
            <xsl:call-template name="createTaxElement"/>
          </G_SG7>
          <xsl:if test="normalize-space(TaxableAmount/Money) != ''">
            <G_SG7>
              <xsl:call-template name="createTaxElement">
                <xsl:with-param name="buildTaxableAmtMOA" select="'true'"/>
              </xsl:call-template>
            </G_SG7>
          </xsl:if>
        </xsl:for-each>
        <!-- Total/@currency -->
        <G_SG8>
          <S_CUX>
            <C_C504>
              <D_6347>2</D_6347>
              <D_6345>
                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
              </D_6345>
              <D_6343>9</D_6343>
            </C_C504>
            <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency != ''">
              <C_C504_2>
                <D_6347>3</D_6347>
                <D_6345>
                  <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency"/>
                </D_6345>
                <D_6343>11</D_6343>
              </C_C504_2>
            </xsl:if>
          </S_CUX>
        </G_SG8>
        <!-- PaymentTerm Loop -->
        <!-- start from here -->
        <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm">
          <G_SG9>
            <S_PAT>
              <D_4279>
                <xsl:choose>
                  <xsl:when test="exists(Discount)">22</xsl:when>
                  <xsl:otherwise>20</xsl:otherwise>
                </xsl:choose>
              </D_4279>
              <C_C112>
                <D_2475>5</D_2475>
                <D_2009>3</D_2009>
                <D_2151>D</D_2151>
                <xsl:if test="@payInNumberOfDays">
                  <D_2152>
                    <xsl:value-of select="@payInNumberOfDays"/>
                  </D_2152>
                </xsl:if>
              </C_C112>
            </S_PAT>
            <S_PCD>
              <C_C501>
                <D_5245>
                  <xsl:choose>
                    <xsl:when test="exists(Discount)">12</xsl:when>
                    <xsl:otherwise>15</xsl:otherwise>
                  </xsl:choose>
                </D_5245>
                <D_5482>
                  <xsl:choose>
                    <xsl:when test="Discount/DiscountPercent/@percent != ''">
                      <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                  </xsl:choose>
                </D_5482>
                <D_5249>13</D_5249>
              </C_C501>
            </S_PCD>
            <xsl:if test="Discount/DiscountAmount/Money != ''">
              <xsl:call-template name="createMOA">
                <xsl:with-param name="grpNum" select="'G_SG10'"/>
                <xsl:with-param name="qual" select="'21'"/>
                <xsl:with-param name="money" select="Discount/DiscountAmount"/>
                <!--<xsl:with-param name="hideAmt" select="$hideAmtHdr"/>-->
              </xsl:call-template>
            </xsl:if>
          </G_SG9>
        </xsl:for-each>
        <!-- ShipTo - TransportationInformation -->
        <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation">
          <xsl:variable name="route" select="normalize-space(Route/@method)"/>
          <xsl:if test="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $route]/EANCOMCode != ''">
            <G_SG11>
              <S_TDT>
                <D_8051>20</D_8051>
                <C_C220>
                  <D_8067>
                    <xsl:value-of
                      select="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $route]/EANCOMCode"/>
                  </D_8067>
                  <D_8066>
                    <xsl:value-of select="substring(normalize-space($route), 1, 17)"/>
                  </D_8066>
                </C_C220>
                <xsl:if test="normalize-space(Route/@means) != ''">
                  <C_C228>
                    <D_8178>
                      <xsl:value-of select="Route/@means"/>
                    </D_8178>
                  </C_C228>
                </xsl:if>
                <xsl:if test="normalize-space(../CarrierIdentifier/@domain) != '' or normalize-space(../CarrierIdentifier) != ''">
                  <C_C040>
                    <xsl:if test="normalize-space(../CarrierIdentifier/@domain) != ''">
                      <D_3127>
                        <xsl:value-of select="substring(normalize-space(../CarrierIdentifier/@domain), 1, 17)"/>
                      </D_3127>
                    </xsl:if>
                    <xsl:if test="normalize-space(../CarrierIdentifier) != ''">
                      <D_3128>
                        <xsl:value-of select="substring(normalize-space(../CarrierIdentifier), 1, 35)"/>
                      </D_3128>
                    </xsl:if>
                  </C_C040>
                </xsl:if>
                <xsl:if test="normalize-space(ShippingContractNumber) != ''">
                  <C_C401>
                    <D_8457>ZZZ</D_8457>
                    <D_8459>ZZZ</D_8459>
                    <D_7130>
                      <xsl:value-of select="substring(normalize-space(ShippingContractNumber), 1, 17)"/>
                    </D_7130>
                  </C_C401>
                </xsl:if>
              </S_TDT>
            </G_SG11>
          </xsl:if>
        </xsl:for-each>
        <!-- TermsOfDelivery -->
        <xsl:if
          test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode/@value) != ''">
          <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery">
            <xsl:variable name="TODCode" select="normalize-space(TermsOfDeliveryCode/@value)"/>
            <xsl:variable name="SPMCode" select="normalize-space(ShippingPaymentMethod/@value)"/>
            <xsl:variable name="TTCode" select="normalize-space(TransportTerms/@value)"/>
            <xsl:if
              test="($TODCode != '' and $TODCode != 'Other') or ($SPMCode != '' and $SPMCode != 'Other') or ($TTCode != '' and $TTCode != 'Other')">
              <G_SG13>
                <S_TOD>
                  <xsl:choose>
                    <xsl:when
                      test="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EANCOMCode != ''">
                      <D_4055>
                        <xsl:value-of
                          select="$Lookup/Lookups/TermsOfDeliveryCodes/TermsOfDeliveryCode[CXMLCode = $TODCode]/EANCOMCode"/>
                      </D_4055>
                    </xsl:when>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when
                      test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EANCOMCode != ''">
                      <D_4215>
                        <xsl:value-of
                          select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMCode]/EANCOMCode"/>
                      </D_4215>
                    </xsl:when>
                    <xsl:otherwise>
                      <D_4215>ZZZ</D_4215>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if
                    test="$TTCode != '' or normalize-space(Comments[@type = 'TermsOfDelivery']) != '' or normalize-space(Comments[@type = 'Transport']) != ''">
                    <C_C100>
                      <xsl:choose>
                        <xsl:when test="$TTCode != ''">
                          <D_4053>
                            <xsl:value-of select="$TTCode"/>
                          </D_4053>
                        </xsl:when>
                        <xsl:otherwise>
                          <D_4053>ZZZ</D_4053>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="normalize-space(Comments[@type = 'TermsOfDelivery']) != ''">
                        <D_4052>
                          <xsl:value-of select="substring(normalize-space(Comments[@type = 'TermsOfDelivery']), 1, 70)"/>
                        </D_4052>
                      </xsl:if>
                      <xsl:if
                        test="normalize-space(Comments[@type = 'Transport']) != '' and normalize-space(Comments[@type = 'TermsOfDelivery']) != ''">
                        <D_4052_2>
                          <xsl:value-of select="substring(normalize-space(Comments[@type = 'Transport']), 1, 70)"/>
                        </D_4052_2>
                      </xsl:if>
                      <xsl:if
                        test="normalize-space(Comments[@type = 'Transport']) != '' and (normalize-space(Comments[@type = 'TermsOfDelivery']) = '' or not(Comments[@type = 'TermsOfDelivery']))">
                        <D_4052>
                          <xsl:value-of select="substring(normalize-space(Comments[@type = 'Transport']), 1, 70)"/>
                        </D_4052>
                      </xsl:if>
                    </C_C100>
                  </xsl:if>
                </S_TOD>
              </G_SG13>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
        <!-- Shipping -->
        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain) != ''">
          <G_SG20>
            <S_ALC>
              <D_5463>C</D_5463>
              <C_C552>
                <D_1230>
                  <xsl:value-of
                    select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain), 1, 35)"
                  />
                </D_1230>
              </C_C552>
              <C_C214>
                <D_7161>FC</D_7161>
                <xsl:choose>
                  <xsl:when test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description) != ''">
                    <D_7160>
                      <xsl:value-of
                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description), 1, 35)"
                      />
                    </D_7160>
                  </xsl:when>
                  <!--<xsl:when test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/ShortName)!=''">                                        <D_7160>                                            <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/ShortName),1,35)"/>                                        </D_7160>                                    </xsl:when>                                    <xsl:otherwise>                                        <D_7160>Default Shipping</D_7160>                                    </xsl:otherwise>-->
                </xsl:choose>
                <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId) != ''">
                  <D_7160_2>
                    <xsl:value-of
                      select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId), 1, 35)"
                    />
                  </D_7160_2>
                </xsl:if>
              </C_C214>
            </S_ALC>
            <xsl:call-template name="createMOA">
              <xsl:with-param name="grpNum" select="'G_SG23'"/>
              <xsl:with-param name="qual" select="'23'"/>
              <xsl:with-param name="money" select="cXML/Request/OrderRequest/OrderRequestHeader/Shipping"/>
              <xsl:with-param name="createAlternate" select="'yes'"/>
              <!--<xsl:with-param name="hideAmt" select="$hideAmtHdr"/>-->
            </xsl:call-template>
          </G_SG20>
        </xsl:if>
        <!-- OrderRequestHeader><Total><Modifications><Modification -->
        <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Modifications/Modification">
          <xsl:if test="normalize-space(ModificationDetail/@name) != ''">
            <G_SG20>
              <xsl:call-template name="mapALCFromModification">
                <xsl:with-param name="deductionGrpNum" select="'G_SG22'"/>
                <xsl:with-param name="moneyGrpNum" select="'G_SG23'"/>
              </xsl:call-template>
            </G_SG20>
          </xsl:if>
        </xsl:for-each>
        <!-- Item Out -->
        <xsl:for-each select="/cXML/Request/OrderRequest/ItemOut">
          <G_SG27>
            <S_LIN>
              <D_1082>
                <xsl:choose>
                  <xsl:when test="normalize-space(@lineNumber) != ''">
                    <xsl:value-of select="substring(format-number(@lineNumber, '#'), 1, 6)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="position()"/>
                  </xsl:otherwise>
                </xsl:choose>
              </D_1082>
              <xsl:choose>
                <xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != ''">
                  <C_C212>
                    <D_7140>
                      <xsl:value-of
                        select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID), 1, 35)"/>
                    </D_7140>
                    <D_7143>SRV</D_7143>
                  </C_C212>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier) != ''">
                    <C_C212>
                      <D_7140>
                        <xsl:value-of select="normalize-space(ItemID/IdReference[@domain = 'EAN-13']/@identifier)"/>
                      </D_7140>
                      <D_7143>SRV</D_7143>
                    </C_C212>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="normalize-space(@parentLineNumber)">
                <C_C829>
                  <D_5495>1</D_5495>
                  <D_1082>
                    <xsl:value-of select="substring(format-number(@parentLineNumber, '#'), 1, 6)"/>
                  </D_1082>
                </C_C829>
              </xsl:if>
            </S_LIN>
            <!-- ItemIDs -->
            <xsl:call-template name="createItemParts">
              <xsl:with-param name="itemID" select="ItemID"/>
              <xsl:with-param name="itemDetail" select="ItemDetail"/>
              <xsl:with-param name="ItemOutIndustry" select="ItemOutIndustry"/>
            </xsl:call-template>
            <xsl:call-template name="mapCommonOrderItemElements">
              <xsl:with-param name="isChangeOrder">true</xsl:with-param>
            </xsl:call-template>
            
            <!--IG-15216-added new segment FTX+DEL for isDeliveryCompleted-->
            <xsl:if test="normalize-space(@isDeliveryCompleted) = 'yes'">
              <S_FTX>
                <D_4451>
                  <xsl:value-of select="'DEL'"/>
                </D_4451>
                <C_C108>
                  <D_4440>
                    <xsl:value-of select="'isDeliveryCompleted'"/>
                  </D_4440>
                  <D_4440_2>
                    <xsl:value-of select="'yes'"/>
                  </D_4440_2>
                </C_C108>
              </S_FTX>
            </xsl:if>
            <!-- PriceBasisQuantity -->
            <xsl:if test="BlanketItemDetail/UnitPrice/Money != '' or ItemDetail/UnitPrice/Money != ''">
              <G_SG32>
                <S_PRI>
                  <C_C509>
                    <D_5125>AAA</D_5125>
                    <xsl:choose>
                      <xsl:when test="BlanketItemDetail/UnitPrice/Money != ''">
                        <D_5118>
                          <xsl:call-template name="formatAmount">
                            <xsl:with-param name="amount" select="normalize-space(BlanketItemDetail/UnitPrice/Money)"/>
                          </xsl:call-template>
                        </D_5118>
                      </xsl:when>
                      <xsl:otherwise>
                        <D_5118>
                          <xsl:call-template name="formatAmount">
                            <xsl:with-param name="amount" select="normalize-space(ItemDetail/UnitPrice/Money)"/>
                          </xsl:call-template>
                        </D_5118>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="BlanketItemDetail/PriceBasisQuantity or ItemDetail/PriceBasisQuantity">
                      <xsl:choose>
                        <xsl:when test="BlanketItemDetail/PriceBasisQuantity/@quantity != ''">
                          <D_5284>
                            <xsl:call-template name="formatQty">
                              <xsl:with-param name="qty" select="normalize-space(BlanketItemDetail/PriceBasisQuantity/@quantity)"
                              />
                            </xsl:call-template>
                          </D_5284>
                        </xsl:when>
                        <xsl:otherwise>
                          <D_5284>
                            <xsl:call-template name="formatQty">
                              <xsl:with-param name="qty" select="normalize-space(ItemDetail/PriceBasisQuantity/@quantity)"/>
                            </xsl:call-template>
                          </D_5284>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:variable name="BPBQuom" select="normalize-space(BlanketItemDetail/PriceBasisQuantity/UnitOfMeasure)"/>
                      <xsl:variable name="IPBQuom" select="normalize-space(ItemDetail/PriceBasisQuantity/UnitOfMeasure)"/>
                      <xsl:if test="$BPBQuom != ''">
                        <xsl:choose>
                          <xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $BPBQuom]/EANCOMCode != ''">
                            <D_6411>
                              <xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $BPBQuom]/EANCOMCode"
                              />
                            </D_6411>
                          </xsl:when>
                          <xsl:otherwise>
                            <D_6411>
                              <xsl:value-of select="$BPBQuom"/>
                            </D_6411>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                      <xsl:if test="$IPBQuom != ''">
                        <xsl:choose>
                          <xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $IPBQuom]/EANCOMCode != ''">
                            <D_6411>
                              <xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $IPBQuom]/EANCOMCode"
                              />
                            </D_6411>
                          </xsl:when>
                          <xsl:otherwise>
                            <D_6411>
                              <xsl:value-of select="$IPBQuom"/>
                            </D_6411>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:if>
                    </xsl:if>
                  </C_C509>
                </S_PRI>
              </G_SG32>
            </xsl:if>
            <xsl:if test="ItemDetail/Extrinsic/@name = 'informationPrice'">
              <G_SG32>
                <S_PRI>
                  <C_C509>
                    <D_5125>AAE</D_5125>
                    <xsl:value-of select="substring(normalize-space(ItemDetail/Extrinsic[@name = 'informationPrice']), 1, 15)"/>
                  </C_C509>
                </S_PRI>
              </G_SG32>
            </xsl:if>
            <!-- itemType and compositeItemType-->
            <xsl:if test="normalize-space(@itemType) != ''">
              <G_SG33>
                <S_RFF>
                  <C_C506>
                    <D_1153>FI</D_1153>
                    <D_1154>
                      <xsl:value-of select="normalize-space(@itemType)"/>
                    </D_1154>
                    <xsl:if test="normalize-space(@compositeItemType) != ''">
                      <D_4000>
                        <xsl:value-of select="normalize-space(@compositeItemType)"/>
                      </D_4000>
                    </xsl:if>
                  </C_C506>
                </S_RFF>
              </G_SG33>
            </xsl:if>
            <!--return Authorization Number-->
            <xsl:if test="normalize-space(@returnAuthorizationNumber) != ''">
              <G_SG33>
                <S_RFF>
                  <C_C506>
                    <D_1153>ALQ</D_1153>
                    <D_1154>
                      <xsl:value-of select="normalize-space(@returnAuthorizationNumber)"/>
                    </D_1154>
                  </C_C506>
                </S_RFF>
              </G_SG33>
            </xsl:if>
            <!-- Master Agreement ID -->
            <xsl:if test="normalize-space(MasterAgreementIDInfo/@agreementID) != ''">
              <G_SG33>
                <S_RFF>
                  <C_C506>
                    <D_1153>CT</D_1153>
                    <D_1154>
                      <xsl:value-of select="substring(normalize-space(MasterAgreementIDInfo/@agreementID), 1, 35)"/>
                    </D_1154>
                    <xsl:if test="MasterAgreementIDInfo/@agreementType = 'scheduling_agreement'">
                      <D_1153>1</D_1153>
                    </xsl:if>
                  </C_C506>
                </S_RFF>
                <xsl:if test="MasterAgreementIDInfo/@agreementDate != ''">
                  <S_DTM>
                    <C_C507>
                      <D_2005>171</D_2005>
                      <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate" select="MasterAgreementIDInfo/@agreementDate"/>
                      </xsl:call-template>
                    </C_C507>
                  </S_DTM>
                </xsl:if>
              </G_SG33>
            </xsl:if>
            <!-- PromotionDealID -->
            <xsl:if test="normalize-space(ItemOutIndustry/ItemOutRetail/PromotionDealID) != ''">
              <G_SG33>
                <S_RFF>
                  <C_C506>
                    <D_1153>PD</D_1153>
                    <D_1154>
                      <xsl:value-of select="substring(normalize-space(ItemOutIndustry/ItemOutRetail/PromotionDealID), 1, 35)"/>
                    </D_1154>
                  </C_C506>
                </S_RFF>
              </G_SG33>
            </xsl:if>
            <!-- ItemOut > Packaging -->
            <xsl:for-each select="Packaging">
              <G_SG34>
                <S_PAC>
                  <D_7224>1</D_7224>
                  <xsl:if test="normalize-space(PackagingLevelCode) != ''">
                    <C_C531>
                      <xsl:choose>
                        <xsl:when test="PackagingLevelCode = 'inner'">
                          <D_7075>1</D_7075>
                        </xsl:when>
                        <xsl:when test="PackagingLevelCode = 'outer'">
                          <D_7075>3</D_7075>
                        </xsl:when>
                        <xsl:when test="PackagingLevelCode = 'intermediate'">
                          <D_7075>2</D_7075>
                        </xsl:when>
                      </xsl:choose>
                    </C_C531>
                  </xsl:if>
                  <xsl:if
                    test="normalize-space(PackageTypeCodeIdentifierCode) != '' or normalize-space(ShippingContainerSerialCodeReference) != ''">
                    <C_C202>
                      <xsl:if test="normalize-space(PackageTypeCodeIdentifierCode) != ''">
                        <D_7065>
                          <xsl:value-of select="substring(normalize-space(PackageTypeCodeIdentifierCode), 1, 35)"/>
                        </D_7065>
                      </xsl:if>
                      <xsl:if test="normalize-space(ShippingContainerSerialCodeReference) != ''">
                        <D_7064>
                          <xsl:value-of select="substring(normalize-space(ShippingContainerSerialCodeReference), 1, 35)"/>
                        </D_7064>
                      </xsl:if>
                    </C_C202>
                  </xsl:if>
                </S_PAC>
                <!-- CG 07252017 : Fix on missing group -->
                <xsl:variable name="shipContainer" select="normalize-space(ShippingContainerSerialCode)"/>
                <xsl:for-each select="ShippingMark[position() &lt; 6]">
                  <xsl:if test="normalize-space(.) != ''">
                    <G_SG36>
                      <S_PCI>
                        <D_4233>16</D_4233>
                        <C_C210>
                          <D_7102>
                            <xsl:value-of select="substring(normalize-space(.), 1, 35)"/>
                          </D_7102>
                        </C_C210>
                      </S_PCI>
                      <xsl:if test="$shipContainer != ''">
                        <S_GIN>
                          <D_7405>BJ</D_7405>
                          <C_C208>
                            <D_7402>
                              <xsl:value-of select="substring($shipContainer, 1, 35)"/>
                            </D_7402>
                          </C_C208>
                        </S_GIN>
                      </xsl:if>
                    </G_SG36>
                  </xsl:if>
                </xsl:for-each>
              </G_SG34>
            </xsl:for-each>
            <!-- Item tax -->
            <xsl:for-each select="Tax/TaxDetail">
              <G_SG38>
                <xsl:call-template name="createTaxElement"/>
              </G_SG38>
              <xsl:if test="normalize-space(TaxableAmount/Money) != ''">
                <G_SG38>
                  <xsl:call-template name="createTaxElement">
                    <xsl:with-param name="buildTaxableAmtMOA" select="'true'"/>
                  </xsl:call-template>
                </G_SG38>
              </xsl:if>
            </xsl:for-each>
            <!-- Manufacturer Name -->
            <xsl:if test="normalize-space(ItemDetail/ManufacturerName) != ''">
              <G_SG39>
                <S_NAD>
                  <D_3035>MF</D_3035>
                  <xsl:variable name="manufName" select="normalize-space(ItemDetail/ManufacturerName)"/>
                  <C_C080>
                    <D_3036>
                      <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="substring($manufName, 1, 35)"/>
                      </xsl:call-template>
                    </D_3036>
                    <xsl:if test="substring($manufName, 36, 35) != ''">
                      <D_3036_2>
                        <xsl:call-template name="rTrim">
                          <xsl:with-param name="inData" select="substring($manufName, 36, 35)"/>
                        </xsl:call-template>
                      </D_3036_2>
                    </xsl:if>
                    <xsl:if test="substring($manufName, 71, 35) != ''">
                      <D_3036_3>
                        <xsl:call-template name="rTrim">
                          <xsl:with-param name="inData" select="substring($manufName, 71, 35)"/>
                        </xsl:call-template>
                      </D_3036_3>
                    </xsl:if>
                    <xsl:if test="substring($manufName, 106, 35) != ''">
                      <D_3036_4>
                        <xsl:call-template name="rTrim">
                          <xsl:with-param name="inData" select="substring($manufName, 106, 35)"/>
                        </xsl:call-template>
                      </D_3036_4>
                    </xsl:if>
                    <xsl:if test="substring($manufName, 141, 35) != ''">
                      <D_3036_5>
                        <xsl:call-template name="rTrim">
                          <xsl:with-param name="inData" select="substring($manufName, 141, 35)"/>
                        </xsl:call-template>
                      </D_3036_5>
                    </xsl:if>
                  </C_C080>
                </S_NAD>
              </G_SG39>
            </xsl:if>
            <!-- ItemOut Supplier ID -->
            <xsl:if test="normalize-space(SupplierID) != '' and SupplierID/@domain = 'EANID'">
              <G_SG39>
                <S_NAD>
                  <D_3035>SU</D_3035>
                  <C_C082>
                    <D_3039>
                      <xsl:value-of select="substring(normalize-space(SupplierID), 1, 35)"/>
                    </D_3039>
                    <D_3055>9</D_3055>
                  </C_C082>
                </S_NAD>
              </G_SG39>
            </xsl:if>
            <!-- Item Terms Of Delivery -->
            <xsl:if
              test="normalize-space(TermsOfDelivery/Address/@addressID) != '' or normalize-space(TermsOfDelivery/Address/Name) != '' or normalize-space(TermsOfDelivery/Address/PostalAddress/Street) != '' or normalize-space(TermsOfDelivery/Address/Email) != '' or normalize-space(TermsOfDelivery/Address/Phone/TelephoneNumber/Number) != '' or normalize-space(TermsOfDelivery/Address/Fax/TelephoneNumber/Number) != '' or normalize-space(TermsOfDelivery/Address/URL) != ''">
              <G_SG39>
                <xsl:call-template name="createNAD">
                  <xsl:with-param name="party" select="TermsOfDelivery/Address"/>
                  <xsl:with-param name="role" select="'deliveryParty'"/>
                  <xsl:with-param name="refGrupNum" select="'G_SG40'"/>
                </xsl:call-template>
                <!-- <xsl:call-template name="CTACOMLoop">                            <xsl:with-param name="contact" select="TermsOfDelivery/Address"/>                            <xsl:with-param name="contactType" select="'TermsOfDelivery'"/>                            <xsl:with-param name="level" select="'detail'"/>                        </xsl:call-template>-->
              </G_SG39>
            </xsl:if>
            <!-- Item ShipTo -->
            <xsl:if
              test="normalize-space(ShipTo/Address/@addressID) != '' or normalize-space(ShipTo/Address/Name) != '' or normalize-space(ShipTo/Address/PostalAddress/Street) != '' or normalize-space(ShipTo/Address/Email) != '' or normalize-space(ShipTo/Address/Phone/TelephoneNumber/Number) != '' or normalize-space(ShipTo/Address/Fax/TelephoneNumber/Number) != '' or normalize-space(ShipTo/Address/URL) != ''">
              <G_SG39>
                <xsl:call-template name="createNAD">
                  <xsl:with-param name="party" select="ShipTo"/>
                  <xsl:with-param name="role" select="'shipTo'"/>
                  <xsl:with-param name="refGrupNum" select="'G_SG40'"/>
                </xsl:call-template>
                <xsl:call-template name="CTACOMLoop">
                  <xsl:with-param name="contact" select="ShipTo/Address"/>
                  <xsl:with-param name="contactType" select="'ShipTo'"/>
                  <xsl:with-param name="level" select="'detail'"/>
                </xsl:call-template>
              </G_SG39>
            </xsl:if>
            <!-- Contacts -->
            <xsl:for-each select="Contact[@role != 'supplierCorporate']">
              <xsl:if test="@role != ''">
                <xsl:if
                  test="normalize-space(@addressID) != '' or normalize-space(Name) != '' or normalize-space(PostalAddress/Street) != '' or normalize-space(Email) != '' or normalize-space(Phone/TelephoneNumber/Number) != '' or normalize-space(Fax/TelephoneNumber/Number) != '' or normalize-space(URL) != ''">
                  <G_SG39>
                    <xsl:call-template name="createNAD">
                      <xsl:with-param name="party" select="."/>
                      <xsl:with-param name="role" select="@role"/>
                      <xsl:with-param name="refGrupNum" select="'G_SG40'"/>
                    </xsl:call-template>
                    <xsl:call-template name="CTACOMLoop">
                      <xsl:with-param name="contact" select="."/>
                      <xsl:with-param name="contactType" select="@role"/>
                      <xsl:with-param name="ContactPerson"
                        select="normalize-space(IdReference[@domain = 'ContactPerson']/@identifier)"/>
                      <xsl:with-param name="level" select="'detail'"/>
                    </xsl:call-template>
                  </G_SG39>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
            <!-- Shipping -->
            <xsl:if test="normalize-space(Shipping/Money) != ''">
              <G_SG43>
                <S_ALC>
                  <D_5463>C</D_5463>
                  <xsl:if test="normalize-space(Shipping/@trackingDomain) != ''">
                    <C_C552>
                      <D_1230>
                        <xsl:value-of select="substring(normalize-space(Shipping/@trackingDomain), 1, 35)"/>
                      </D_1230>
                    </C_C552>
                  </xsl:if>
                  <C_C214>
                    <D_7161>FC</D_7161>
                    <xsl:choose>
                      <xsl:when test="normalize-space(Shipping/Description/ShortName/text()) != ''">
                        <D_7160>
                          <xsl:value-of select="substring(normalize-space(Shipping/Description/ShortName/text()), 1, 35)"/>
                        </D_7160>
                      </xsl:when>
                      <xsl:when test="Shipping/Description">
                        <D_7160>
                          <xsl:value-of select="substring(normalize-space(Shipping/Description), 1, 35)"/>
                        </D_7160>
                      </xsl:when>
                    </xsl:choose>
                    <xsl:if test="normalize-space(Shipping/@trackingId)">
                      <D_7160_2>
                        <xsl:value-of select="substring(normalize-space(Shipping/@trackingId), 1, 35)"/>
                      </D_7160_2>
                    </xsl:if>
                  </C_C214>
                </S_ALC>
                <xsl:call-template name="createMOA">
                  <xsl:with-param name="grpNum" select="'G_SG46'"/>
                  <xsl:with-param name="qual" select="'23'"/>
                  <xsl:with-param name="money" select="Shipping"/>
                  <xsl:with-param name="createAlternate" select="'yes'"/>
                </xsl:call-template>
              </G_SG43>
            </xsl:if>
            <!-- UnitPrice > Modifications -->
            <xsl:for-each select="ItemDetail/UnitPrice/Modifications/Modification[ModificationDetail/@name != '']">
              <G_SG43>
                <xsl:call-template name="mapALCFromModification">
                  <xsl:with-param name="deductionGrpNum" select="'G_SG45'"/>
                  <xsl:with-param name="moneyGrpNum" select="'G_SG46'"/>
                </xsl:call-template>
              </G_SG43>
            </xsl:for-each>
            <!-- ShipTo transportation -->
            <xsl:for-each select="ShipTo/TransportInformation">
              <xsl:if test="normalize-space(Route/@method) != ''">
                <G_SG49>
                  <S_TDT>
                    <D_8051>20</D_8051>
                    <C_C220>
                      <xsl:variable name="routeMethod" select="normalize-space(Route/@method)"/>
                      <xsl:choose>
                        <xsl:when
                          test="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $routeMethod]/EANCOMCode != ''">
                          <D_8067>
                            <xsl:value-of
                              select="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $routeMethod]/EANCOMCode"
                            />
                          </D_8067>
                        </xsl:when>
                      </xsl:choose>
                      <D_8066>
                        <xsl:value-of select="substring(normalize-space(Route/@method), 1, 17)"/>
                      </D_8066>
                    </C_C220>
                    <xsl:if test="normalize-space(Route/@means) != ''">
                      <C_C228>
                        <D_8178>
                          <xsl:value-of select="Route/@means"/>
                        </D_8178>
                      </C_C228>
                    </xsl:if>
                    <xsl:if test="normalize-space(../CarrierIdentifier) != ''">
                      <C_C040>
                        <D_3127>
                          <xsl:value-of select="substring(normalize-space(../CarrierIdentifier/@domain), 1, 17)"/>
                        </D_3127>
                        <D_3128>
                          <xsl:value-of select="substring(normalize-space(../CarrierIdentifier), 1, 35)"/>
                        </D_3128>
                      </C_C040>
                    </xsl:if>
                    <xsl:if test="normalize-space(ShippingContractNumber) != ''">
                      <C_C401>
                        <D_8457>ZZZ</D_8457>
                        <D_8459>ZZZ</D_8459>
                        <D_7130>
                          <xsl:value-of select="substring(normalize-space(ShippingContractNumber), 1, 17)"/>
                        </D_7130>
                      </C_C401>
                    </xsl:if>
                  </S_TDT>
                </G_SG49>
              </xsl:if>
            </xsl:for-each>
          </G_SG27>
        </xsl:for-each>
        <!--- Summary -->
        <S_UNS>
          <D_0081>S</D_0081>
        </S_UNS>
        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Total/Money) != ''">
          <xsl:call-template name="createMOA">
            <xsl:with-param name="qual" select="'128'"/>
            <xsl:with-param name="money" select="cXML/Request/OrderRequest/OrderRequestHeader/Total"/>
            <xsl:with-param name="createAlternate" select="'yes'"/>
          </xsl:call-template>
        </xsl:if>
        <!-- <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Total/Money)!=''">                    <xsl:call-template name="createMOA">                        <xsl:with-param name="qual" select="'128'"></xsl:with-param>                        <xsl:with-param name="money" select="cXML/Request/OrderRequest/OrderRequestHeader/Total"/>                                            </xsl:call-template>-->
        <!--</xsl:if>-->
        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Tax/Money) != ''">
          <xsl:call-template name="createMOA">
            <xsl:with-param name="qual" select="'124'"/>
            <xsl:with-param name="money" select="cXML/Request/OrderRequest/OrderRequestHeader/Tax"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic/@name = 'totalAmountInclTax'">
          <S_MOA>
            <C_C516>
              <D_5025>86</D_5025>
              <D_5004>
                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'totalAmountInclTax']"/>
              </D_5004>
            </C_C516>
          </S_MOA>
        </xsl:if>
        <S_CNT>
          <C_C270>
            <D_6069>2</D_6069>
            <D_6066>
              <xsl:value-of select="count(cXML/Request/OrderRequest/ItemOut)"/>
            </D_6066>
          </C_C270>
        </S_CNT>
        <S_UNT>
          <D_0074>#segCount#</D_0074>
          <D_0062>0001</D_0062>
        </S_UNT>
      </M_ORDCHG>
      <S_UNZ>
        <D_0036>1</D_0036>
        <D_0020>
          <xsl:value-of select="$anICNValue"/>
        </D_0020>
      </S_UNZ>
    </ns0:Interchange>
  </xsl:template>
</xsl:stylesheet>
