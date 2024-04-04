<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anBuyerANID"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="anSenderDefaultTimeZone"/>
  <!-- For local testing -->  
  <!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>-->
  <!-- PD references -->
  <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
  <xsl:template match="*">
    <xsl:variable name="productRepType">
      <xsl:choose>
        <xsl:when test="FunctionalGroup/M_846/S_BIA/D_755 = 'SI'">
          <xsl:value-of select="'inventory'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'mo-po'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <cXML>      
      <xsl:attribute name="timestamp">
        <xsl:call-template name="convertToAribaDate">
          <xsl:with-param name="Date">
            <xsl:value-of
              select="substring(replace(string(current-dateTime()), '-', ''), 1, 8)"/>
          </xsl:with-param>
          <xsl:with-param name="Time">
            <xsl:value-of
              select="substring(replace(replace(string(current-dateTime()), '-', ''), ':', ''), 10, 6)"
            />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="payloadID">
        <xsl:value-of select="$anPayloadID"/>
      </xsl:attribute>
      <Header>
        <From>
          <Credential domain="NetworkID">
            <Identity>
              <xsl:value-of select="$anSupplierANID"/>
            </Identity>
          </Credential>
          <xsl:if test="FunctionalGroup/M_846/S_REF[D_128 = 'VR']/D_127">
            <Credential domain="VendorID">
              <Identity>
                <xsl:value-of select="FunctionalGroup/M_846/S_REF[D_128 = 'VR']/D_127"/>
              </Identity>
            </Credential>
          </xsl:if>
        </From>
        <To>
          <Credential domain="NetworkID">
            <Identity>
              <xsl:value-of select="$anBuyerANID"/>
            </Identity>
          </Credential>
          <!-- IG-27256 -->
          <xsl:if test="FunctionalGroup/M_846/S_REF[D_128 = '06']/D_127">
            <Credential domain="SystemID">
              <Identity>
                <xsl:value-of select="FunctionalGroup/M_846/S_REF[D_128 = '06']/D_127"/>
              </Identity>
            </Credential>
          </xsl:if>
          <xsl:if test="FunctionalGroup/M_846/S_REF[D_128 = '44']/D_127">
            <Credential domain="EndPointID">
              <Identity>
                <xsl:value-of select="FunctionalGroup/M_846/S_REF[D_128 = '44']/D_127"/>
              </Identity>
            </Credential>
          </xsl:if>
        </To>
        <Sender>
          <Credential domain="NetworkId">
            <Identity>
              <xsl:value-of select="$anProviderANID"/>
            </Identity>
          </Credential>
          <UserAgent>
            <xsl:value-of select="'Ariba Supplier'"/>
          </UserAgent>
        </Sender>
      </Header>
      <Message>
        <xsl:choose>
          <xsl:when test="upper-case($anEnvName) = 'PROD'">
            <xsl:attribute name="deploymentMode">production</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="deploymentMode">test</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <ProductReplenishmentMessage>
          <ProductReplenishmentHeader>
            <xsl:attribute name="creationDate">
              <xsl:call-template name="FormatDate">
                <xsl:with-param name="date" select="FunctionalGroup/M_846/S_BIA/D_373"/>
                <xsl:with-param name="time" select="FunctionalGroup/M_846/S_BIA/D_337"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="messageID">
              <xsl:value-of select="FunctionalGroup/M_846/S_BIA/D_127"/>
            </xsl:attribute>
            <xsl:if test="FunctionalGroup/M_846/S_REF[D_128 = 'PHC']/D_127 != ''">
              <xsl:attribute name="processType">
                <xsl:value-of select="FunctionalGroup/M_846/S_REF[D_128 = 'PHC']/D_127"/>
              </xsl:attribute>
            </xsl:if>
          </ProductReplenishmentHeader>
          <xsl:for-each select="FunctionalGroup/M_846/G_LIN">
            <xsl:variable name="lin">
              <xsl:call-template name="createLIN">
                <xsl:with-param name="LIN" select="S_LIN"/>
              </xsl:call-template>
            </xsl:variable>
            <ProductReplenishmentDetails>
              <ItemID>
                <SupplierPartID>
                  <xsl:value-of select="$lin/lin/element[@name = 'VP']/@value"/>
                </SupplierPartID>
                <xsl:if test="$lin/lin/element[@name = 'VS']/@value != ''">
                  <SupplierPartAuxiliaryID>
                    <xsl:value-of select="$lin/lin/element[@name = 'VS']/@value"/>
                  </SupplierPartAuxiliaryID>
                </xsl:if>
                <xsl:if test="$lin/lin/element[@name = 'BP']/@value != ''">
                  <BuyerPartID>
                    <xsl:value-of select="$lin/lin/element[@name = 'BP']/@value"/>
                  </BuyerPartID>
                </xsl:if>
              </ItemID>
              <xsl:if test="S_PID[D_349 = 'F']/D_352 != ''">
                <!-- IG-38986 only one language     start -->
                <xsl:variable name="v_lang">
                  <xsl:value-of select="S_PID[D_349 = 'F'][1]/D_819"/>
                </xsl:variable>
                <Description>
                  <xsl:choose>
                    <xsl:when test="S_PID[D_349 = 'F']/D_819 != ''">
                      <xsl:attribute name="xml:lang">
                        <xsl:value-of select="$v_lang"/>
                      </xsl:attribute>
                      <!-- IG-38986 only one language     end -->
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="xml:lang">
                        <xsl:value-of select="'en'"/>
                      </xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="S_PID[D_349 = 'F']/D_352"/>
                </Description>
              </xsl:if>
              <!-- IG-27244 -->
              <xsl:if test="S_LDT[D_345='AF'][D_344='DA']/D_380 != ''">
                <LeadTime>
                  <xsl:value-of select="S_LDT[D_345='AF'][D_344='DA']/D_380"/>
                </LeadTime>
              </xsl:if>
              <xsl:if test="$lin/lin/element[@name = 'MG']/@value != ''">
                <ManufacturerPartID>
                  <xsl:value-of select="$lin/lin/element[@name = 'MG']/@value"/>
                </ManufacturerPartID>
              </xsl:if>
              <xsl:if test="$lin/lin/element[@name = 'MF']/@value != ''">
                <ManufacturerName>
                  <xsl:value-of select="$lin/lin/element[@name = 'MF']/@value"/>
                </ManufacturerName>
              </xsl:if>
              <!-- IG-26466 -->
              <xsl:for-each select="S_PID[D_349='S'][D_751='Property']">
                <xsl:if test="D_822!='' and D_352!=''">
                  <Characteristic>
                    <xsl:attribute name="domain">
                      <xsl:value-of select="D_822"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="D_352"/>
                    </xsl:attribute>
                  </Characteristic>
                </xsl:if>
              </xsl:for-each>
              <!-- IG-34407 -->
              <xsl:for-each select="S_REF[D_128 = 'PRT']">
                <xsl:if test="D_127!='' and D_352!=''">
                <Characteristic>
                  <xsl:attribute name="domain">   
                    <xsl:value-of select="D_127"/>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="D_352"/>                    
                  </xsl:attribute>
                </Characteristic>
                </xsl:if>
              </xsl:for-each>
            	<!-- IG-31226-->
            	<xsl:if test="exists(S_REF[D_128 = 'BT'])">
            		<Batch>
            			<xsl:for-each select="S_REF[D_128 = 'BT']">
            				<xsl:choose>
            					<xsl:when test="D_127 = 'productionDate'">
            						<xsl:attribute name="productionDate">
            							<xsl:call-template name="FormatDate">
            								<xsl:with-param name="date" select="substring(D_352, 1, 8)"/>
            								<xsl:with-param name="time" select="substring(D_352, 9, 4)"/>
            								<xsl:with-param name="tzone" select="substring(D_352, 14, 2)"/>
            							</xsl:call-template>
            						</xsl:attribute>
            					</xsl:when>
            					<xsl:when test="D_127 = 'expirationDate'">
            						<xsl:attribute name="expirationDate">
            							<xsl:call-template name="FormatDate">
            								<xsl:with-param name="date" select="substring(D_352, 1, 8)"/>
            								<xsl:with-param name="time" select="substring(D_352, 9, 4)"/>
            								<xsl:with-param name="tzone" select="substring(D_352, 14, 2)"/>
            							</xsl:call-template>
            						</xsl:attribute>
            					</xsl:when>
            					<xsl:when test="D_127 = 'inspectionDate'">
            						<xsl:attribute name="inspectionDate">
            							<xsl:call-template name="FormatDate">
            								<xsl:with-param name="date" select="substring(D_352, 1, 8)"/>
            								<xsl:with-param name="time" select="substring(D_352, 9, 4)"/>
            								<xsl:with-param name="tzone" select="substring(D_352, 14, 2)"/>
            							</xsl:call-template>
            						</xsl:attribute>
            					</xsl:when>
            					<xsl:when test="D_127 = 'shelfLife'">
            						<xsl:attribute name="shelfLife" select="D_352"/>
            					</xsl:when>
            				</xsl:choose>
            			</xsl:for-each>
            			<xsl:for-each select="S_REF[D_128 = 'BT'][D_127 != 'productionDate' and D_127 != 'expirationDate' and D_127 != 'inspectionDate'  and D_127 != 'shelfLife'][1]">
            				<xsl:if test="D_352 != ''">
            					<BuyerBatchID>
            						<xsl:value-of select="D_352"/>
            					</BuyerBatchID>
            				</xsl:if>
            				<xsl:if test="D_127 != ''">
            					<SupplierBatchID>
            						<xsl:value-of select="D_127"/>
            					</SupplierBatchID>
            				</xsl:if>
            			</xsl:for-each>
            		</Batch>
            	</xsl:if>
              <xsl:if test="$productRepType = 'inventory'">
                <xsl:for-each select="G_N1">
                  <xsl:call-template name="createParty">
                    <xsl:with-param name="partyInfo" select="."/>
                    <xsl:with-param name="storageLoc" select="$lin/lin/element[@name = 'DV']/@value"
                    />
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="$productRepType = 'mo-po'">
                <xsl:for-each select="G_N1">
                  <xsl:call-template name="createParty">
                    <xsl:with-param name="partyInfo" select="."/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="$productRepType = 'inventory'">
                <xsl:variable name="lin03" select="$lin/lin/element[@name = 'C3']/@value"/>
                <!-- IG-27044 -->
                <xsl:call-template name="mapRepDetailsInfo">
                  <xsl:with-param name="rd_QTY" select="G_QTY"></xsl:with-param>
                  <xsl:with-param name="rd_lin03" select="$lin03"></xsl:with-param>
                  <xsl:with-param name="rd_type" select="$productRepType"></xsl:with-param>
                </xsl:call-template>                
                <xsl:if test="S_DTM/D_374 = '184'">
                  <Extrinsic name="InventoryDate">
                    <xsl:call-template name="FormatDate">
                      <xsl:with-param name="date" select="S_DTM[D_374 = '184']/D_373"/>
                      <xsl:with-param name="time" select="S_DTM[D_374 = '184']/D_337"/>
                      <xsl:with-param name="tzone" select="S_DTM[D_374 = '184']/D_623"/>
                    </xsl:call-template>
                  </Extrinsic>
                </xsl:if>
              </xsl:if>
              <xsl:if test="$productRepType = 'mo-po'">
                <xsl:variable name="mopoType">
                  <xsl:choose>
                    <xsl:when test="S_REF/D_128 = 'MH'">
                      <xsl:value-of select="'manufacturingOrder'"/>
                    </xsl:when>
                    <xsl:when test="S_REF/D_128 = 'PO'">
                      <xsl:value-of select="'purchaseOrder'"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <!-- IG-27044 -->
                <xsl:call-template name="mapRepDetailsInfo">
                  <xsl:with-param name="rd_QTY" select="G_QTY"></xsl:with-param>
                  <xsl:with-param name="rd_type" select="$productRepType"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="G_QTY[S_QTY/D_673 = '99']">
                  <!-- TimesSeriesQuantity -->
                  <ReplenishmentTimeSeries>
                    <xsl:attribute name="type">
                      <xsl:value-of select="$mopoType"/>
                    </xsl:attribute>
                    <TimeSeriesDetails>
                      <Period>
                        <xsl:attribute name="startDate">
                          <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="S_DTM[D_374 = '196']/D_373"/>
                            <xsl:with-param name="time" select="S_DTM[D_374 = '196']/D_337"/>
                            <xsl:with-param name="tzone" select="S_DTM[D_374 = '196']/D_623"/>
                          </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="endDate">
                          <xsl:call-template name="FormatDate">
                            <xsl:with-param name="date" select="S_DTM[D_374 = '197']/D_373"/>
                            <xsl:with-param name="time" select="S_DTM[D_374 = '197']/D_337"/>
                            <xsl:with-param name="tzone" select="S_DTM[D_374 = '197']/D_623"/>
                          </xsl:call-template>
                        </xsl:attribute>
                      </Period>
                      <TimeSeriesQuantity>
                        <xsl:attribute name="quantity">
                          <xsl:value-of select="S_QTY/D_380"/>
                        </xsl:attribute>
                        <UnitOfMeasure>
                          <xsl:variable name="uomcode" select="S_QTY/C_C001/D_355"/>
                          <xsl:value-of
                            select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uomcode]/CXMLCode"
                          />
                        </UnitOfMeasure>
                      </TimeSeriesQuantity>
                    </TimeSeriesDetails>
                  </ReplenishmentTimeSeries>
                </xsl:for-each>
                <xsl:for-each select="G_QTY[S_QTY/D_673 = 'NT']">
                  <ReplenishmentTimeSeries>
                    <xsl:attribute name="type">
                      <xsl:value-of select="$mopoType"/>
                    </xsl:attribute>
                    <xsl:for-each select="G_REF">
                      <TimeSeriesDetails>
                        <Period>
                          <xsl:attribute name="startDate">
                            <xsl:call-template name="FormatDate">
                              <xsl:with-param name="date" select="S_DTM[D_374 = '196']/D_373"/>
                              <xsl:with-param name="time" select="S_DTM[D_374 = '196']/D_337"/>
                              <xsl:with-param name="tzone" select="S_DTM[D_374 = '196']/D_623"/>
                            </xsl:call-template>
                          </xsl:attribute>
                          <xsl:attribute name="endDate">
                            <xsl:call-template name="FormatDate">
                              <xsl:with-param name="date" select="S_DTM[D_374 = '197']/D_373"/>
                              <xsl:with-param name="time" select="S_DTM[D_374 = '197']/D_337"/>
                              <xsl:with-param name="tzone" select="S_DTM[D_374 = '197']/D_623"/>
                            </xsl:call-template>
                          </xsl:attribute>
                        </Period>
                        <xsl:if
                          test="S_REF[D_128 = 'MH' or D_128 = 'PO']/C_C040[D_128 = 'RPT']/D_127 != ''">
                          <TimeSeriesValue>
                            <xsl:attribute name="value">
                              <xsl:value-of
                                select="S_REF[D_128 = 'MH' or D_128 = 'PO']/C_C040[D_128 = 'RPT']/D_127"
                              />
                            </xsl:attribute>
                          </TimeSeriesValue>
                        </xsl:if>
                        <xsl:if test="S_REF[D_128 = 'MH' or D_128 = 'PO']/D_127 != ''">
                          <IdReference>
                            <xsl:attribute name="domain">
                              <xsl:choose>
                                <xsl:when test="S_REF/D_128 = 'MH'">
                                  <xsl:value-of select="'MoDocument'"/>
                                </xsl:when>
                                <xsl:when test="S_REF/D_128 = 'PO'">
                                  <xsl:value-of select="'PoDocument'"/>
                                </xsl:when>
                              </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="identifier">
                              <xsl:value-of select="S_REF[D_128 = 'MH' or D_128 = 'PO']/D_127"/>
                            </xsl:attribute>
                          </IdReference>
                        </xsl:if>
                      </TimeSeriesDetails>
                    </xsl:for-each>
                  </ReplenishmentTimeSeries>
                </xsl:for-each>
              </xsl:if>
            </ProductReplenishmentDetails>
          </xsl:for-each>
        </ProductReplenishmentMessage>
      </Message>
    </cXML>
  </xsl:template>
  <xsl:template name="FormatDate">
    <xsl:param name="date"/>
    <xsl:param name="time"/>
    <xsl:param name="tzone"/>
    <xsl:variable name="Date" select="$date"/>
    <xsl:variable name="Time" select="$time"/>
    <xsl:variable name="TimeCode" select="$tzone"/>
    <xsl:variable name="timeZone">
      <xsl:choose>
        <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
          <xsl:value-of
            select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
          />
        </xsl:when>
        <xsl:when test="$anSenderDefaultTimeZone != ''">
          <xsl:value-of select="$anSenderDefaultTimeZone"/>
        </xsl:when>
        <xsl:otherwise>+00:00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="temDate">
      <xsl:value-of
        select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
      />
    </xsl:variable>
    <xsl:variable name="tempTime">
      <xsl:choose>
        <xsl:when test="$Time != '' and string-length($Time) = 6">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
          />
        </xsl:when>
        <xsl:when test="$Time != '' and string-length($Time) = 4">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
        </xsl:when>
        <xsl:otherwise>T12:00:00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
  </xsl:template>
  <xsl:template name="createParty">
    <xsl:param name="partyInfo"/>
    <xsl:param name="storageLoc"/>
    <!--<xsl:variable name="Crole" select="S_N1/D_98"/>-->
    <xsl:variable name="getPartyrole">
      <xsl:choose>
        <xsl:when test="S_N1/D_98 = 'Z4'">
          <xsl:value-of select="'inventoryOwner'"/>
        </xsl:when>
        <xsl:when test="S_N1/D_98 = 'LC'">
          <xsl:value-of select="'locationTo'"/>
        </xsl:when>
        <xsl:when test="S_N1/D_98 = 'SU'">
          <xsl:value-of select="'locationFrom'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="isoCode">
      <xsl:if test="S_N4/D_26 != ''">
        <xsl:value-of select="S_N4/D_26"/>
      </xsl:if>
    </xsl:variable>
    <xsl:if
      test="$getPartyrole = 'inventoryOwner' or $getPartyrole = 'locationTo' or $getPartyrole = 'locationFrom'">
      <Contact>
        <xsl:attribute name="role">
          <xsl:value-of select="$getPartyrole"/>
        </xsl:attribute>
        <xsl:if test="S_N1/D_67 != ''">
          <xsl:attribute name="addressID">
            <xsl:value-of select="S_N1/D_67"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="S_N1/D_66 != ''">
          <xsl:attribute name="addressIDDomain">
            <xsl:value-of select="normalize-space(S_N1/D_66)"/>
          </xsl:attribute>
        </xsl:if>
        <Name>
          <xsl:attribute name="xml:lang">
            <xsl:value-of select="'en'"/>
          </xsl:attribute>
          <xsl:value-of select="S_N1/D_93"/>
        </Name>
        <xsl:if test="S_N3/D_166 != ''">
          <PostalAddress>
            <!--DeliveryTo-->
            <xsl:for-each select="S_N2">
              <DeliverTo>
                <xsl:value-of select="concat(D_93, D_93_2)"/>
              </DeliverTo>
            </xsl:for-each>
            <xsl:if test="S_N3/D_166 != ''">
              <xsl:for-each select="S_N3">
                <xsl:if test="D_166">
                  <Street>
                    <xsl:value-of select="D_166"/>
                  </Street>
                </xsl:if>
                <xsl:if test="D_166_1">
                  <Street>
                    <xsl:value-of select="D_166_1"/>
                  </Street>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="S_N4/D_19 != ''">
              <City>
                <xsl:value-of select="S_N4/D_19"/>
              </City>
            </xsl:if>
            <xsl:if test="S_N4/D_156 != ''">
              <State>
                <xsl:value-of select="normalize-space(S_N4/D_156)"/>
              </State>
            </xsl:if>
            <xsl:if test="S_N4/D_116 != ''">
              <PostalCode>
                <xsl:value-of select="normalize-space(S_N4/D_116)"/>
              </PostalCode>
            </xsl:if>
            <xsl:if test="$isoCode != ''">
              <Country>
                <xsl:attribute name="isoCountryCode">
                  <xsl:value-of select="normalize-space(S_N4/D_26)"/>
                </xsl:attribute>
              </Country>
            </xsl:if>
          </PostalAddress>
        </xsl:if>
        <xsl:for-each select="S_PER">
          <xsl:if test="D_366 = 'CN'">
            <xsl:choose>
              <xsl:when test="D_365 = 'EM' and D_364 != ''">
                <Email>
                  <xsl:attribute name="name">
                    <xsl:value-of select="normalize-space(D_93)"/>
                  </xsl:attribute>
                  <xsl:value-of select="D_364"/>
                </Email>
              </xsl:when>
              <xsl:when test="D_365_2 = 'EM' and D_364_2 != ''">
                <Email>
                  <xsl:attribute name="name">
                    <xsl:value-of select="normalize-space(D_93)"/>
                  </xsl:attribute>
                  <xsl:value-of select="D_364_2"/>
                </Email>
              </xsl:when>
              <xsl:when test="D_365_3 = 'EM' and D_364_3">
                <Email>
                  <xsl:attribute name="name">
                    <xsl:value-of select="normalize-space(D_93)"/>
                  </xsl:attribute>
                  <xsl:value-of select="S_PER/D_364_3"/>
                </Email>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="S_PER">
          <xsl:if test="D_366 = 'CN'">
            <xsl:choose>
              <xsl:when test="D_365 = 'TE' and D_364 != ''">
                <Phone>
                  <xsl:attribute name="name">
                    <xsl:value-of select="D_93"/>
                  </xsl:attribute>
                  <TelephoneNumber>
                    <CountryCode>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCode"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="contains(D_364, '(')">
                          <xsl:value-of select="substring-before(D_364, '(')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364, '-')">
                          <xsl:value-of select="substring-before(D_364, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                      </xsl:choose>
                    </CountryCode>
                    <AreaOrCityCode>
                      <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
                    </AreaOrCityCode>
                    <Number>
                      <xsl:choose>
                        <xsl:when test="contains(D_364, 'x')">
                          <xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"
                          />
                        </xsl:when>
                        <xsl:when test="contains(D_364, 'X')">
                          <xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(D_364, '-')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </Number>
                    <Extension>
                      <xsl:value-of select="substring-after(D_364, 'x')"/>
                    </Extension>
                  </TelephoneNumber>
                </Phone>
              </xsl:when>
              <xsl:when test="D_365_2 = 'TE' and D_364_2 != ''">
                <Phone>
                  <xsl:attribute name="name">
                    <xsl:value-of select="D_93"/>
                  </xsl:attribute>
                  <TelephoneNumber>
                    <CountryCode>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCode"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_2, '(')">
                          <xsl:value-of select="substring-before(D_364_2, '(')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_2, '-')">
                          <xsl:value-of select="substring-before(D_364_2, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                      </xsl:choose>
                    </CountryCode>
                    <AreaOrCityCode>
                      <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
                    </AreaOrCityCode>
                    <Number>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_2, 'x')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_2, 'X')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(D_364_2, '-')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </Number>
                    <Extension>
                      <xsl:value-of select="substring-after(D_364_2, 'x')"/>
                    </Extension>
                  </TelephoneNumber>
                </Phone>
              </xsl:when>
              <xsl:when test="D_365_3 = 'TE' and D_364_3 != ''">
                <Phone>
                  <xsl:attribute name="name">
                    <xsl:value-of select="D_93"/>
                  </xsl:attribute>
                  <TelephoneNumber>
                    <CountryCode>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCode"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_3, '(')">
                          <xsl:value-of select="substring-after(D_364_3, '(')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_3, '-')">
                          <xsl:value-of select="substring-before(D_364_3, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                      </xsl:choose>
                    </CountryCode>
                    <AreaOrCityCode>
                      <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
                    </AreaOrCityCode>
                    <Number>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_3, 'x')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_3, 'X')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(D_364_3, '-')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </Number>
                    <Extension>
                      <xsl:value-of select="substring-after(D_364_3, 'x')"/>
                    </Extension>
                  </TelephoneNumber>
                </Phone>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="S_PER">
          <xsl:if test="D_366 = 'CN'">
            <xsl:choose>
              <xsl:when test="D_365 = 'FX' and D_364 != ''">
                <Fax>
                  <xsl:attribute name="name">work</xsl:attribute>
                  <TelephoneNumber>
                    <CountryCode>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCode"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="contains(D_364, '(')">
                          <xsl:value-of select="substring-before(D_364, '(')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364, '-')">
                          <xsl:value-of select="substring-before(D_364, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                      </xsl:choose>
                    </CountryCode>
                    <AreaOrCityCode>
                      <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
                    </AreaOrCityCode>
                    <Number>
                      <xsl:choose>
                        <xsl:when test="contains(D_364, 'x')">
                          <xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"
                          />
                        </xsl:when>
                        <xsl:when test="contains(D_364, 'X')">
                          <xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"
                          />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(D_364, '-')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </Number>
                    <Extension>
                      <xsl:value-of select="substring-after(D_364, 'x')"/>
                    </Extension>
                  </TelephoneNumber>
                </Fax>
              </xsl:when>
              <xsl:when test="D_365_2 = 'FX' and D_364_2 != ''">
                <Fax>
                  <xsl:attribute name="name">work</xsl:attribute>
                  <TeleFaxNumber>
                    <CountryCode>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCode"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_2, '(')">
                          <xsl:value-of select="substring-before(D_364_2, '(')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_2, '-')">
                          <xsl:value-of select="substring-before(D_364_2, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                      </xsl:choose>
                    </CountryCode>
                    <AreaOrCityCode>
                      <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
                    </AreaOrCityCode>
                    <Number>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_2, 'x')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_2, 'X')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(D_364_2, '-')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </Number>
                    <Extension>
                      <xsl:value-of select="substring-after(D_364_2, 'x')"/>
                    </Extension>
                  </TeleFaxNumber>
                </Fax>
              </xsl:when>
              <xsl:when test="D_365_3 = 'FX' and D_364_3">
                <Fax>
                  <xsl:attribute name="name">work</xsl:attribute>
                  <TeleFaxNumber>
                    <CountryCode>
                      <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCode"/>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_3, '(')">
                          <xsl:value-of select="substring-before(D_364_3, '(')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_3, '-')">
                          <xsl:value-of select="substring-before(D_364_3, '-')"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                      </xsl:choose>
                    </CountryCode>
                    <AreaOrCityCode>
                      <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
                    </AreaOrCityCode>
                    <Number>
                      <xsl:choose>
                        <xsl:when test="contains(D_364_3, 'x')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
                        </xsl:when>
                        <xsl:when test="contains(D_364_3, 'X')">
                          <xsl:value-of
                            select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="substring-after(D_364_3, '-')"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </Number>
                    <Extension>
                      <xsl:value-of select="substring-after(D_364_3, 'x')"/>
                    </Extension>
                  </TeleFaxNumber>
                </Fax>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="S_PER">
          <xsl:if test="D_366 = 'CN'">
            <xsl:choose>
              <xsl:when test="D_365 = 'UR' and D_364 != ''">
                <URL>
                  <xsl:attribute name="name">
                    <xsl:value-of select="normalize-space(D_93)"/>
                  </xsl:attribute>
                  <xsl:value-of select="D_364"/>
                </URL>
              </xsl:when>
              <xsl:when test="D_365_2 = 'UR' and D_364_2 != ''">
                <URL>
                  <xsl:attribute name="name">
                    <xsl:value-of select="normalize-space(D_93)"/>
                  </xsl:attribute>
                  <xsl:value-of select="D_364_2"/>
                </URL>
              </xsl:when>
              <xsl:when test="D_365_3 = 'UR' and D_364_3">
                <URL>
                  <xsl:attribute name="name">
                    <xsl:value-of select="normalize-space(D_93)"/>
                  </xsl:attribute>
                  <xsl:value-of select="S_PER/D_364_3"/>
                </URL>
              </xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
        <xsl:if test="S_N1/D_98 = 'LC' and S_REF/D_128 = 'IR'">
          <IdReference>
            <xsl:attribute name="domain">buyerLocationID</xsl:attribute>
            <xsl:attribute name="identifier">
              <xsl:value-of select="S_REF/D_352"/>
            </xsl:attribute>
          </IdReference>
        </xsl:if>
        <!-- IG-34407 -->
        <xsl:if test="S_REF[D_128 = '1M']/D_352!='' and $getPartyrole = 'locationFrom'">
          <IdReference>
            <xsl:attribute name="domain">supplierLocationID</xsl:attribute>
            <xsl:attribute name="identifier">
              <xsl:value-of select="S_REF[D_128 = '1M']/D_352"/>
            </xsl:attribute>
          </IdReference>
        </xsl:if>
        <xsl:if test="S_N1/D_98 = 'Z4' and S_REF/D_128 = 'IA'">
          <IdReference>
            <xsl:attribute name="domain">inventoryOwnerID</xsl:attribute>
            <xsl:attribute name="identifier">
              <xsl:value-of select="S_REF/D_352"/>
            </xsl:attribute>
          </IdReference>
        </xsl:if>
        <xsl:if test="S_N1/D_98 = 'LC'">
          <xsl:if test="$storageLoc != ''">
            <Extrinsic name="materialStorageLocation">
              <xsl:value-of select="$storageLoc"/>
            </Extrinsic>
          </xsl:if>
        </xsl:if>
      </Contact>
    </xsl:if>
  </xsl:template>
  <xsl:template name="createLIN">
    <xsl:param name="LIN"/>
    <lin>
      <xsl:for-each select="$LIN/*[starts-with(name(), 'D_23')]">
        <xsl:if test="starts-with(name(), 'D_235')">
          <element>
            <xsl:attribute name="name">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of
                select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"/>
            </xsl:attribute>
          </element>
        </xsl:if>
      </xsl:for-each>
    </lin>
  </xsl:template>
  
  <xsl:template name="convertToAribaDate">
    <xsl:param name="Date"/>
    <xsl:param name="Time"/>
    <xsl:param name="TimeCode"/>
    <xsl:variable name="timeZone">
      <xsl:choose>
        <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
          <xsl:value-of
            select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
          />
        </xsl:when>
        <xsl:otherwise>+00:00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="temDate">
      <xsl:value-of
        select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
      />
    </xsl:variable>
    <xsl:variable name="tempTime">
      <xsl:choose>
        <xsl:when test="$Time != '' and string-length($Time) = 6">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
          />
        </xsl:when>
        <xsl:when test="$Time != '' and string-length($Time) = 4">
          <xsl:value-of
            select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
        </xsl:when>
        <xsl:otherwise>T12:00:00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
  </xsl:template>
  <!-- IG-27044 -->
  <xsl:template name="createInventoryQty">
    <xsl:param name="QTY"/>
    <xsl:param name="lin03"/>    
    <InventoryQtys>
      <xsl:if test="$lin03">
        <xsl:for-each select="$QTY[S_QTY/D_673 = '38']">
          <Qty>
            <Name>
              <xsl:choose>
                <xsl:when test="$lin03 = 'CC' or $lin03 = 'CD'">UnrestrictedUseQuantity</xsl:when>
                <xsl:when test="$lin03 = 'CI' or $lin03 = 'CJ'">BlockedQuantity</xsl:when>
                <xsl:when test="$lin03 = 'CF' or $lin03 = 'CG'">QualityInspectionQuantity</xsl:when>
                <xsl:when test="$lin03 = 'CA' or $lin03 = 'CS' or $lin03 = 'CN'">StockInTransferQuantity</xsl:when>
              </xsl:choose>
            </Name>
            <Value>
              <xsl:value-of select="S_QTY/D_380"/>
            </Value>
            <UnitOfMeasure>
              <xsl:value-of select="S_QTY/C_C001/D_355"/>
            </UnitOfMeasure>
            <InvType>Inventory</InvType>
            <Order>
              <xsl:choose>
                <xsl:when test="$lin03 = 'CC' or $lin03 = 'CD'">2</xsl:when>
                <xsl:when test="$lin03 = 'CI' or $lin03 = 'CJ'">3</xsl:when>
                <xsl:when test="$lin03 = 'CF' or $lin03 = 'CG'">4</xsl:when>
                <xsl:when test="$lin03 = 'CA' or $lin03 = 'CS' or $lin03 = 'CN'">6</xsl:when>
              </xsl:choose>
            </Order>
          </Qty>
      </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="$QTY[S_QTY/D_673 != '38' and S_QTY/D_673 != '70' and S_QTY/D_673 != '7K']">
        <Qty>
          <Name>
            <xsl:choose>
              <xsl:when test="S_QTY/D_673 = '3Y'">SubcontractingStockInTransferQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '33'">UnrestrictedUseQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'QH'">BlockedQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'XT'">QualityInspectionQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'XU'">PromotionQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '77'">StockInTransferQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '69'">IncrementQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '72'">RequiredMinimumQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '73'">RequiredMaximumQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '17'">StockOnHandQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '37'">WorkInProcessQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'IQ'">IntransitQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '1N'">ScrapQuantity</xsl:when>
              <xsl:when test="S_QTY/D_673 = '57'">OrderQuantity</xsl:when> 
            </xsl:choose>
          </Name>
          <Value>
            <xsl:value-of select="S_QTY/D_380"/>
          </Value>
          <xsl:if test="S_QTY/D_673 = '57'">
            <Value2>
              <xsl:value-of select="../G_QTY[S_QTY/D_673 = '70']/S_QTY/D_380"/>
            </Value2>
          </xsl:if>
          <UnitOfMeasure>
            <xsl:value-of select="S_QTY/C_C001/D_355"/>
          </UnitOfMeasure>
          <InvType>
            <xsl:choose>
              <xsl:when test="S_QTY/C_C001/D_1018 = '1'">Inventory</xsl:when>
              <xsl:when test="S_QTY/C_C001/D_1018 = '2'">ConsignmentInventory</xsl:when>
            </xsl:choose>
          </InvType>
          <Order>
            <xsl:choose>
              <xsl:when test="S_QTY/D_673 = '3Y'">1</xsl:when>
              <xsl:when test="S_QTY/D_673 = '33'">2</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'QH'">3</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'XT'">4</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'XU'">5</xsl:when>
              <xsl:when test="S_QTY/D_673 = '77'">6</xsl:when>
              <xsl:when test="S_QTY/D_673 = '69'">7</xsl:when>
              <xsl:when test="S_QTY/D_673 = '72'">8</xsl:when>
              <xsl:when test="S_QTY/D_673 = '73'">9</xsl:when>
              <xsl:when test="S_QTY/D_673 = '17'">10</xsl:when>
              <xsl:when test="S_QTY/D_673 = '37'">11</xsl:when>
              <xsl:when test="S_QTY/D_673 = 'IQ'">12</xsl:when>
              <xsl:when test="S_QTY/D_673 = '1N'">13</xsl:when>
              <xsl:when test="S_QTY/D_673 = '57'">14</xsl:when> 
            </xsl:choose>
          </Order>
        </Qty>
      </xsl:for-each>
    </InventoryQtys>
  </xsl:template>
  
  <xsl:template name="mapRepDetailsInfo">
    <xsl:param name="rd_QTY"/>
    <xsl:param name="rd_lin03"/>
    <xsl:param name="rd_type"/>
    
    <xsl:variable name="qties">
      <xsl:call-template name="createInventoryQty">
        <xsl:with-param name="QTY" select="$rd_QTY"></xsl:with-param>
        <xsl:with-param name="lin03" select="$rd_lin03"></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <!-- Map Inventory Quantities -->
    <xsl:if test="count($qties/InventoryQtys/Qty[InvType='Inventory']) > 0">
      <Inventory>
        <xsl:for-each-group select="$qties/InventoryQtys/Qty[InvType='Inventory']" group-by="Order">
          <xsl:sort select="number(Order)"></xsl:sort>
          <xsl:choose>
            <xsl:when test="Name='OrderQuantity'">
              <OrderQuantity>
                <xsl:if test="Value!=''">
                  <xsl:attribute name="minimum">
                    <xsl:value-of select="Value"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="Value2!=''">
                  <xsl:attribute name="maximum">
                    <xsl:value-of select="Value2"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="UnitOfMeasure"></xsl:copy-of>
              </OrderQuantity>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="{Name}">
                <xsl:attribute name="quantity">
                  <xsl:value-of select="Value"/>
                </xsl:attribute>
                <xsl:copy-of select="UnitOfMeasure"></xsl:copy-of>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each-group>
        <xsl:if test="$rd_type = 'inventory' and ((S_MEA[D_737='TI'][D_738='MI']/D_739!='') or (S_MEA[D_737='TI'][D_738='MX']/D_739!=''))">
          <DaysOfSupply>
            <xsl:if test="(S_MEA[D_737='TI'][D_738='MI']/D_739!='')">
              <xsl:attribute name="minimum">
                <xsl:value-of select="S_MEA[D_737='TI'][D_738='MI']/D_739"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="(S_MEA[D_737='TI'][D_738='MX']/D_739!='')">
              <xsl:attribute name="minimum">
                <xsl:value-of select="S_MEA[D_737='TI'][D_738='MX']/D_739"/>
              </xsl:attribute>
            </xsl:if>
          </DaysOfSupply>
        </xsl:if>
      </Inventory>
    </xsl:if>
    <!-- Map ConsignmentInventory Quantities -->
    <xsl:if test="count($qties/InventoryQtys/Qty[InvType='ConsignmentInventory']) > 0">
      <ConsignmentInventory>
        <xsl:for-each-group select="$qties/InventoryQtys/Qty[InvType='ConsignmentInventory']" group-by="Order">
          <xsl:sort select="number(Order)"></xsl:sort>
          <xsl:choose>
            <xsl:when test="Name='OrderQuantity'">
              <OrderQuantity>
                <xsl:if test="Value!=''">
                  <xsl:attribute name="minimum">
                    <xsl:value-of select="Value"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="Value2!=''">
                  <xsl:attribute name="maximum">
                    <xsl:value-of select="Value2"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:copy-of select="UnitOfMeasure"></xsl:copy-of>
              </OrderQuantity>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="{Name}">
                <xsl:attribute name="quantity">
                  <xsl:value-of select="Value"/>
                </xsl:attribute>
                <xsl:copy-of select="UnitOfMeasure"></xsl:copy-of>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each-group>
      </ConsignmentInventory>
    </xsl:if>
    <!-- Map ReplenishmentTimeSeries Quantities -->
    <xsl:for-each-group select="G_QTY[S_QTY/D_673 = '7K']" group-by="concat(G_REF[S_REF/D_128='8X']/S_REF/D_127, G_REF[S_REF/D_128='8X']/S_REF/D_352)">
      <ReplenishmentTimeSeries>
        <xsl:attribute name="type">
          <xsl:value-of select="G_REF[S_REF/D_128='8X']/S_REF/D_127"/>
        </xsl:attribute>
        <xsl:if test="G_REF[S_REF/D_128='8X']/S_REF/D_127 = 'custom'">
          <xsl:attribute name="customType">
            <xsl:value-of select="G_REF[S_REF/D_128='8X']/S_REF/D_352"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:for-each select="current-group()/S_QTY">
          <TimeSeriesDetails>
            <Period>
              <xsl:attribute name="startDate">
                <xsl:call-template name="FormatDate">
                  <xsl:with-param name="date" select="../S_DTM[D_374 = '196']/D_373"/>
                  <xsl:with-param name="time" select="../S_DTM[D_374 = '196']/D_337"/>
                  <xsl:with-param name="tzone" select="../S_DTM[D_374 = '196']/D_623"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="endDate">
                <xsl:call-template name="FormatDate">
                  <xsl:with-param name="date" select="../S_DTM[D_374 = '197']/D_373"/>
                  <xsl:with-param name="time" select="../S_DTM[D_374 = '197']/D_337"/>
                  <xsl:with-param name="tzone" select="../S_DTM[D_374 = '197']/D_623"/>
                </xsl:call-template>
              </xsl:attribute>
            </Period>
            <TimeSeriesQuantity>
              <xsl:attribute name="quantity">
                <xsl:value-of select="D_380"/>
              </xsl:attribute>
              <UnitOfMeasure>
                <xsl:value-of select="C_C001/D_355"/>
              </UnitOfMeasure>
            </TimeSeriesQuantity>
            
            <!--IG-35154-to accomodate multiple G_REF/S_REF information into multiple IdReference tags-->
           <xsl:for-each select="../G_REF[S_REF/D_128='0L']">
           	<xsl:if test="S_REF/D_127 != '' and S_REF/D_352 != ''">
	              <IdReference>
	                <xsl:attribute name="identifier">
	                  <xsl:value-of select="S_REF/D_127"/>
	                </xsl:attribute>
	                <xsl:attribute name="domain">
	                  <xsl:value-of select="S_REF/D_352"/>
	                </xsl:attribute>
	              </IdReference>
           	</xsl:if>
            </xsl:for-each>
          </TimeSeriesDetails>
        </xsl:for-each>
      </ReplenishmentTimeSeries>
    </xsl:for-each-group>
  </xsl:template>
</xsl:stylesheet>
