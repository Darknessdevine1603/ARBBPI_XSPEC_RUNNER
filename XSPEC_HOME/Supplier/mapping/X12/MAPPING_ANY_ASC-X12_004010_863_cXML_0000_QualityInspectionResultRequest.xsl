<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:004010" exclude-result-prefixes="#all"
  version="2.0" xmlns:p1="urn:sap.com:ica:typesystem:116:asc_x12:004010">
  <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

  <xsl:param name="anSupplierANID"/>
  <xsl:param name="anBuyerANID"/>
  <xsl:param name="anProviderANID"/>
  <xsl:param name="anPayloadID"/>
  <xsl:param name="anSharedSecrete"/>
  <xsl:param name="anEnvName"/>
  <xsl:param name="cXMLAttachments"/>
  <xsl:param name="attachSeparator" select="'\|'"/>

  <!-- For local testing -->
  <!--<xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>
  <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>-->
  <!-- PD references -->
  <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>


  <xsl:template match="*">
    <xsl:element name="cXML">
      <xsl:attribute name="payloadID">
        <xsl:value-of select="$anPayloadID"/>
      </xsl:attribute>
      <xsl:attribute name="timestamp">
        <xsl:call-template name="convertToAribaDate">
          <xsl:with-param name="Date">
            <xsl:value-of select="substring(replace(string(current-dateTime()), '-', ''), 1, 8)"/>
          </xsl:with-param>
          <xsl:with-param name="Time">
            <xsl:value-of
              select="substring(replace(replace(string(current-dateTime()), '-', ''), ':', ''), 10, 6)"
            />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:call-template name="createcXMLHeader"/>


      <xsl:element name="Request">
        <xsl:choose>
          <xsl:when test="$anEnvName = 'PROD'">
            <xsl:attribute name="deploymentMode">production</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="deploymentMode">test</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>


        <xsl:element name="QualityInspectionResultRequest">
          <xsl:element name="QualityInspectionResultRequestHeader">
            <xsl:attribute name="resultID">
              <xsl:value-of select="FunctionalGroup/M_863/S_BTR[D_353 = '00']/D_127"/>
            </xsl:attribute>

            <xsl:attribute name="resultDate">
              <xsl:call-template name="convertToAribaDate">
                <xsl:with-param name="Date" select="FunctionalGroup/M_863/S_BTR[D_353 = '00']/D_373"/>
                <xsl:with-param name="Time" select="FunctionalGroup/M_863/S_BTR[D_353 = '00']/D_337"
                />
              </xsl:call-template>
            </xsl:attribute>

            <xsl:if test="FunctionalGroup/M_863/S_NTE[D_363 = 'AAA']/D_352 != ''">
              <xsl:attribute name="createdBy">
                <xsl:value-of select="FunctionalGroup/M_863/S_NTE[D_363 = 'AAA']/D_352"/>
              </xsl:attribute>
            </xsl:if>

            <xsl:element name="QualityInspectionRequestReference">
              <xsl:if test="FunctionalGroup/M_863/S_REF[D_128 = 'IP']/D_127 != ''">
                <xsl:attribute name="inspectionID">
                  <xsl:value-of select="FunctionalGroup/M_863/S_REF[D_128 = 'IP']/D_127"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="FunctionalGroup/M_863/S_DTM[D_374 = '517']/D_373 != ''">
                <xsl:attribute name="inspectionDate">
                  <xsl:call-template name="convertToAribaDate">
                    <xsl:with-param name="Date">
                      <xsl:value-of select="FunctionalGroup/M_863/S_DTM[D_374 = '517']/D_373"/>
                    </xsl:with-param>
                    <xsl:with-param name="Time">
                      <xsl:value-of select="FunctionalGroup/M_863/S_DTM[D_374 = '517']/D_337"/>
                    </xsl:with-param>
                    <xsl:with-param name="TimeCode">
                      <xsl:value-of select="FunctionalGroup/M_863/S_DTM[D_374 = '517']/D_623"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:attribute>
              </xsl:if>
              <!-- IG-30768 - Remove DocumentReference mapping -->
            </xsl:element>


            <xsl:choose>
              <xsl:when
                test="not(exists(FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_REF[D_128 = 'BT']/C_C040[D_128 = 'BT']))">
                <xsl:element name="Batch">
                  <BuyerBatchID>
                    <xsl:value-of
                      select="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_REF[D_128 = 'BT']/D_352"
                    />
                  </BuyerBatchID>
                  <SupplierBatchID>
                    <xsl:value-of
                      select="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_REF[D_128 = 'BT']/D_127"
                    />
                  </SupplierBatchID>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each-group
                  select="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_REF[D_128 = 'BT'][C_C040[D_128 = 'BT']][C_C040[D_128_2 = 'LT']]"
                  group-by="C_C040/D_127">
                  <xsl:for-each-group select="current-group()" group-by="C_C040/D_127">
                    <xsl:element name="Batch">
                      <xsl:for-each select="current-group()">
                        <xsl:if test="D_127 = 'expirationDate'">
                          <xsl:attribute name="expirationDate">
                            <xsl:call-template name="cXMLDate">
                              <xsl:with-param name="Date">
                                <xsl:value-of select="D_352"/>
                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="D_127 = 'inspectionDate'">
                          <xsl:attribute name="inspectionDate">
                            <xsl:call-template name="cXMLDate">
                              <xsl:with-param name="Date">
                                <xsl:value-of select="D_352"/>
                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="D_127 = 'shelfLife'">
                          <xsl:attribute name="shelfLife">
                            <xsl:value-of select="D_352"/>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="D_127 = 'originCountryCode'">
                          <xsl:attribute name="originCountryCode">
                            <xsl:value-of select="D_352"/>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="D_127 = 'batchQuantity'">
                          <xsl:attribute name="batchQuantity">
                            <xsl:value-of select="D_352"/>
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="D_127 = 'productionDate'">
                          <xsl:attribute name="productionDate">
                            <xsl:call-template name="cXMLDate">
                              <xsl:with-param name="Date">
                                <xsl:value-of select="D_352"/>
                              </xsl:with-param>
                            </xsl:call-template>
                          </xsl:attribute>
                        </xsl:if>
                      </xsl:for-each>
                      <BuyerBatchID>
                        <xsl:value-of select="C_C040[D_128_2 = 'LT']/D_127_2"/>
                      </BuyerBatchID>
                      <SupplierBatchID>
                        <xsl:value-of select="C_C040[D_128 = 'BT']/D_127"/>
                      </SupplierBatchID>
                    </xsl:element>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="FunctionalGroup/M_863/S_NTE[D_363 = 'TST']/D_352 != ''">
              <xsl:element name="Comments">
                <xsl:value-of select="FunctionalGroup/M_863/S_NTE[D_363 = 'TST']/D_352"/>
              </xsl:element>
            </xsl:if>
            <xsl:if
              test="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_QTY[D_673 = '38']/D_380 != ''">
              <xsl:element name="QualityInspectionQuantity">
                <xsl:attribute name="quantity">
                  <xsl:value-of
                    select="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_QTY[D_673 = '38']/D_380"
                  />
                </xsl:attribute>

                <xsl:element name="UnitOfMeasure">
                  <xsl:variable name="uom"
                    select="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_QTY[D_673 = '38']/C_C001/D_355"/>
                  <xsl:choose>
                    <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                      <xsl:value-of
                        select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$uom"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>

              </xsl:element>
            </xsl:if>

            <xsl:if
              test="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_REF[D_128 = 'SE']/D_127 != ''">
              <xsl:element name="AssetInfo">
                <xsl:attribute name="serialNumber">
                  <xsl:value-of
                    select="FunctionalGroup/M_863/G_LIN[S_LIN/D_235 = 'VP']/S_REF[D_128 = 'SE']/D_127"
                  />
                </xsl:attribute>
              </xsl:element>
            </xsl:if>
          </xsl:element>

          <xsl:element name="QualityInspectionResultRequestDetail">
            <xsl:for-each select="FunctionalGroup/M_863/G_LIN">
              <xsl:for-each select="G_CID">
                <xsl:element name="QualityInspectionValuation">
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018 != ''">
                    <xsl:attribute name="valuationID">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="characteristicID">
                    <xsl:value-of select="S_CID[D_559 = 'ZZ']/D_751"/>
                  </xsl:attribute>
                  <xsl:attribute name="operationNumber">
                    <xsl:value-of select="S_CID[D_559 = 'ZZ']/D_352"/>
                  </xsl:attribute>
                  <xsl:if test="S_REF[D_128 = '88']/D_127 != ''">
                    <xsl:attribute name="workCenter">
                      <xsl:value-of select="S_REF[D_128 = '88']/D_127"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649 != ''">
                    <xsl:attribute name="meanValue">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018_2 != ''">
                    <xsl:attribute name="aboveTolerance">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018_2"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649_2 != ''">
                    <xsl:attribute name="belowTolerance">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649_2"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[C_C001/D_355 = 'ZZ']/D_942 != ''">
                    <xsl:attribute name="inspectedQuantity">
                      <xsl:value-of select="S_PSD[C_C001/D_355 = 'ZZ']/D_942"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018_3 != ''">
                    <xsl:attribute name="nonConformance">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018_3"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018_4 != ''">
                    <xsl:attribute name="deviation">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_1018_4"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649_4 != ''">
                    <xsl:attribute name="variance">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649_4"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649_3 != ''">
                    <xsl:attribute name="numberOfDefects">
                      <xsl:value-of select="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649_3"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="S_PSD[D_942 = '0']/C_C001[D_355 = 'ZZ']/D_649_5 = '1'">
                    <xsl:attribute name="isAdHoc">
                      <xsl:value-of select="'yes'"/>
                    </xsl:attribute>
                  </xsl:if>
                  <!-- QualitySampleResult -->

                  <xsl:for-each-group select="G_STA" group-by="S_STA/D_739">
                    <xsl:element name="QualitySampleResult">
                      <xsl:if test="S_STA[D_950 = 'ZZ']/C_C001[D_355 = 'ZZ']/D_1018 != ''">
                        <xsl:attribute name="sampleID">
                          <xsl:value-of select="S_STA[D_950 = 'ZZ']/C_C001[D_355 = 'ZZ']/D_1018"/>
                        </xsl:attribute>
                      </xsl:if>

                      <xsl:if test="S_STA[D_950 = 'ZZ']/C_C001[D_355 = 'ZZ']/D_649 != ''">
                        <xsl:attribute name="physicalSampleNumber">
                          <xsl:value-of select="S_STA[D_950 = 'ZZ']/C_C001[D_355 = 'ZZ']/D_649"/>
                        </xsl:attribute>
                      </xsl:if>

                      <xsl:if test="./S_REF[D_128 = '0N']/D_127 != ''">
                        <xsl:attribute name="unitValue">
                          <xsl:value-of select="./S_REF[D_128 = '0N']/D_127"/>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test="./S_REF[D_128 = 'ADE']/D_127 != ''">
                        <PropertyValue>
                          <xsl:for-each select="current-group()">
                            <xsl:for-each select="./S_REF[D_128 = 'ADE']">
                              <xsl:if test="D_127 != '' and D_352 != ''">
                                <Characteristic>
                                  <xsl:attribute name="domain">
                                    <xsl:value-of select="D_127"/>
                                  </xsl:attribute>
                                  <xsl:attribute name="value">
                                    <xsl:value-of select="D_352"/>
                                  </xsl:attribute>
                                  <xsl:if test="C_C040[D_128 = 'ADE']/D_127 != ''">
                                    <xsl:attribute name="code">
                                      <xsl:value-of select="C_C040[D_128 = 'ADE']/D_127"/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </Characteristic>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:for-each>
                        </PropertyValue>
                      </xsl:if>
                    </xsl:element>
                  </xsl:for-each-group>

                  <xsl:for-each-group select="G_TMD" group-by="S_TMD/D_751">
                    <xsl:element name="ValueGroup">

                      <xsl:if test="./S_REF[D_128 = 'ADE']/D_127 != ''">
                        <PropertyValue>
                          <xsl:for-each select="current-group()">
                            <xsl:for-each select="./S_REF[D_128 = 'ADE']">
                              <xsl:if test="D_127 != '' and D_352 != ''">
                                <Characteristic>
                                  <xsl:attribute name="domain">
                                    <xsl:value-of select="D_127"/>
                                  </xsl:attribute>
                                  <xsl:attribute name="value">
                                    <xsl:value-of select="D_352"/>
                                  </xsl:attribute>
                                  <xsl:if test="C_C040[D_128 = 'ADE']/D_127 != ''">
                                    <xsl:attribute name="code">
                                      <xsl:value-of select="C_C040[D_128 = 'ADE']/D_127"/>
                                    </xsl:attribute>
                                  </xsl:if>
                                </Characteristic>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:for-each>
                        </PropertyValue>
                      </xsl:if>
                    </xsl:element>
                  </xsl:for-each-group>
                  <xsl:if test="S_NTE[D_363 = 'TRS']/D_352 != ''">
                    <xsl:element name="Description">
                      <xsl:attribute name="xml:lang">
                        <xsl:text>en</xsl:text>
                      </xsl:attribute>
                      <xsl:element name="ShortName">
                        <xsl:value-of select="normalize-space(S_NTE[D_363_1 = 'ADD']/D_352_1)"/>
                      </xsl:element>
                      <xsl:value-of select="normalize-space(S_NTE[D_363 = 'TRS']/D_352)"/>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="cXMLDate">
    <xsl:param name="Date"/>
    <xsl:value-of
      select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2), 'T', substring($Date, 9, 2), ':', substring($Date, 11, 2), ':', substring($Date, 13, 2), '+00:00')"
    />
  </xsl:template>
</xsl:stylesheet>
