<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:856:004010" exclude-result-prefixes="#all"
    version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anSharedSecrete"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="cXMLAttachments"/>
    <xsl:param name="attachSeparator" select="'\|'"/>

    <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>
    <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
    <!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
   <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>-->
    
    <!-- CG: IG-16765 - 1500 Extrinsics -->
    <xsl:variable name="mappingLookup">
        <xsl:call-template name="getLookupValues">
            <xsl:with-param name="cXMLDocType" select="'ShipNoticeRequest'"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="useExtrinsicsLookup">
        <xsl:choose>
            <xsl:when test="$mappingLookup/MappingLookup/EnableStandardExtrinsics != ''">
                <xsl:value-of select="lower-case($mappingLookup/MappingLookup/EnableStandardExtrinsics)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'no'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="todValues"
        select="tokenize('PriceCondition,DespatchCondition,PriceandDespatchCondition,CollectedByCustomer,TransportCondition,DeliveryCondition', ',')"/>
    <xsl:variable name="spmValues"
        select="tokenize('Account,CashOnDeliveryServiceChargePaidByConsignee,CashOnDeliveryServiceChargePaidByConsignor,InformationCopy-NoPaymentDue,InsuranceCostsPaidByConsignee,InsuranceCostsPaidByConsignor,NotSpecified,PayableElsewhere', ',')"/>
    <xsl:template match="ns0:*">
        <xsl:variable name="StructureType">
            <xsl:choose>
                <xsl:when test="FunctionalGroup/M_856/S_BSN/D_1005 = '0001'">
                    <xsl:text>SOTPI</xsl:text>
                </xsl:when>
                <xsl:when test="FunctionalGroup/M_856/S_BSN/D_1005 = '0002'">
                    <xsl:text>SOITP</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="cXML">
            <xsl:attribute name="payloadID">
                <xsl:value-of select="$anPayloadID"/>
            </xsl:attribute>
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
            <xsl:element name="Header">
                <xsl:element name="From">
                    <xsl:element name="Credential">
                        <xsl:attribute name="domain">NetworkID</xsl:attribute>
                        <xsl:element name="Identity">
                            <xsl:value-of select="$anSupplierANID"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="To">
                    <xsl:element name="Credential">
                        <xsl:attribute name="domain">NetworkID</xsl:attribute>
                        <xsl:element name="Identity">
                            <xsl:value-of select="$anBuyerANID"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Sender">
                    <xsl:element name="Credential">
                        <xsl:attribute name="domain">NetworkID</xsl:attribute>
                        <xsl:element name="Identity">
                            <xsl:value-of select="$anProviderANID"/>
                        </xsl:element>
                        <xsl:element name="SharedSecret">
                            <xsl:value-of select="$anSharedSecrete"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="UserAgent">
                        <xsl:value-of select="'Ariba Supplier'"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="Request">
                <xsl:choose>
                    <xsl:when test="$anEnvName = 'PROD'">
                        <xsl:attribute name="deploymentMode">production</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="deploymentMode">test</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:element name="ShipNoticeRequest">
                    <!-- ShipNoticeHeader -->
                    <xsl:element name="ShipNoticeHeader">
                        <xsl:attribute name="shipmentID">
                            <xsl:choose>
                                <xsl:when test="FunctionalGroup/M_856/S_BSN/D_353 = '03'">
                                    <xsl:value-of
                                        select="concat(normalize-space(FunctionalGroup/M_856/S_BSN/D_396), '_1')"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="normalize-space(FunctionalGroup/M_856/S_BSN/D_396)"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <!-- operation -->
                        <xsl:if test="FunctionalGroup/M_856/S_BSN/D_353 != ''">
                            <xsl:attribute name="operation">
                                <xsl:choose>
                                    <xsl:when test="FunctionalGroup/M_856/S_BSN/D_353 = '03'"
                                        >delete</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_856/S_BSN/D_353 = '05'"
                                        >update</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_856/S_BSN/D_353 = '00'"
                                        >new</xsl:when>
                                    <xsl:otherwise>new</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="noticeDate">
                            <xsl:choose>
                                <xsl:when
                                    test="FunctionalGroup/M_856/S_DTM[D_374 = '111']/D_373 != ''">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '111']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '111']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '111']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when
                                    test="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '111']/D_373 != ''">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '111']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '111']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '111']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of select="FunctionalGroup/M_856/S_BSN/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of select="FunctionalGroup/M_856/S_BSN/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">GM</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <!-- shipmentDate -->
                        <xsl:choose>
                            <xsl:when test="FunctionalGroup/M_856/S_DTM[D_374 = '011']/D_373 != ''">
                                <xsl:attribute name="shipmentDate">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '011']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '011']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '011']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when
                                test="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '011']/D_373 != ''">
                                <xsl:attribute name="shipmentDate">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '011']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '011']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '011']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <!-- deliveryDate -->
                        <xsl:choose>
                            <xsl:when test="FunctionalGroup/M_856/S_DTM[D_374 = '017']/D_373 != ''">
                                <xsl:attribute name="deliveryDate">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '017']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '017']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '017']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when
                                test="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '017']/D_373 != ''">
                                <xsl:attribute name="deliveryDate">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '017']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '017']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '017']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <!-- requestedDeliveryDate -->
                        <xsl:choose>
                            <xsl:when test="FunctionalGroup/M_856/S_DTM[D_374 = '002']/D_373 != ''">
                                <xsl:attribute name="requestedDeliveryDate">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '002']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '002']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/S_DTM[D_374 = '002']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when
                                test="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '002']/D_373 != ''">
                                <xsl:attribute name="requestedDeliveryDate">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '002']/D_373"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '002']/D_337"
                                            />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of
                                                select="FunctionalGroup/M_856/G_HL[S_HL/D_735 = 'S']/S_DTM[D_374 = '002']/D_623"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <!-- shipmentType -->
                        <xsl:if test="FunctionalGroup/M_856/S_BSN/D_640 != ''">
                            <xsl:attribute name="shipmentType">
                                <xsl:choose>
                                    <xsl:when test="FunctionalGroup/M_856/S_BSN/D_640 = '09'"
                                        >actual</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_856/S_BSN/D_640 = 'PL'"
                                        >planned</xsl:when>
                                    <xsl:otherwise>planned</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        <!-- fulfillmentType -->
                        <xsl:if test="FunctionalGroup/M_856/S_BSN/D_641 != ''">
                            <xsl:attribute name="fulfillmentType">
                                <xsl:choose>
                                    <xsl:when test="FunctionalGroup/M_856/S_BSN/D_641 = 'C20'"
                                        >complete</xsl:when>
                                    <xsl:when test="FunctionalGroup/M_856/S_BSN/D_641 = 'B44'"
                                        >partial</xsl:when>
                                    <xsl:otherwise>complete</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        <!-- *******************     Shipment Level ******************************* -->
                        <xsl:for-each
                            select="FunctionalGroup/M_856/G_HL[S_HL/D_628 = '1' and S_HL/D_735 = 'S' and S_HL/D_736 = '1'][1]">
                            <!-- serviceLevel -->
                            <xsl:for-each select="S_TD5[D_284_1 != '']">
                                <xsl:variable name="serLvl" select="D_284_1"/>
                                <xsl:variable name="serviceLevel">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/ServicelLevels/ServiceLevel[X12Code = $serLvl]/CXMLCode"
                                    />
                                </xsl:variable>
                                <xsl:if test="$serviceLevel != ''">
                                    <xsl:element name="ServiceLevel">
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                                        <xsl:value-of select="normalize-space($serviceLevel)"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- serviceLevel -->
                            <xsl:for-each select="S_TD5[D_284_2 != '']">
                                <xsl:variable name="serLvl" select="D_284_2"/>
                                <xsl:variable name="serviceLevel">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/ServicelLevels/ServiceLevel[X12Code = $serLvl]/CXMLCode"
                                    />
                                </xsl:variable>
                                <xsl:if test="$serviceLevel != ''">
                                    <xsl:element name="ServiceLevel">
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                                        <xsl:value-of select="normalize-space($serviceLevel)"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- serviceLevel -->
                            <xsl:for-each select="S_TD5[D_284_3 != '']">
                                <xsl:variable name="serLvl" select="D_284_3"/>
                                <xsl:variable name="serviceLevel">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/ServicelLevels/ServiceLevel[X12Code = $serLvl]/CXMLCode"
                                    />
                                </xsl:variable>
                                <xsl:if test="$serviceLevel != ''">
                                    <xsl:element name="ServiceLevel">
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                                        <xsl:value-of select="normalize-space($serviceLevel)"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- payloadID -->
                            <xsl:if test="../S_BSN/D_353 = '03' or ../S_BSN/D_353 = '05'">
                                <xsl:element name="DocumentReference">
                                    <xsl:attribute name="payloadID"/>
                                </xsl:element>
                            </xsl:if>
                            <!-- Contact -->
                            <xsl:for-each select="G_N1[S_N1/D_98_1 != 'DA']">
                                <xsl:call-template name="createContact">
                                    <xsl:with-param name="contact" select="."/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <!-- 12512 -->
                            <!-- LegalEntity -->
                            <xsl:for-each select="S_PER[(D_366 = 'ZZ' and D_443 = 'CompanyCode' and D_93 !='') or (D_366 = 'ZZ' and D_443 = 'PurchasingOrg' and D_93 !='') or (D_366 = 'ZZ' and D_443 = 'PurchasingGroup' and D_93 !='')][1]">
                                <xsl:element name="LegalEntity">
                                    <xsl:element name="IdReference">
                                    <xsl:attribute name="identifier">
                                        <xsl:value-of select="D_93"/>
                                    </xsl:attribute>
                                        <xsl:attribute name="domain">
                                            <xsl:value-of select="D_443"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                            
                            <!-- Hazard-->
                            <!-- IG-4892 -->
                            <!-- IG-5501 -->
                            <xsl:for-each
                                select="S_TD4[not(exists(D_152))][D_208 = 'I' or D_208 = 'U' or D_208 = '9'][D_209 != '']">
                                <xsl:element name="Hazard">
                                    <xsl:if test="D_352 != ''">
                                        <xsl:element name="Description">
                                            <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                                            <xsl:value-of select="D_352"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="Classification">
                                        <xsl:attribute name="domain">
                                            <xsl:choose>
                                                <xsl:when test="D_208 = '9'">NAHG</xsl:when>
                                                <xsl:when test="D_208 = 'I'">IMDG</xsl:when>
                                                <xsl:when test="D_208 = 'U'">UNDG</xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="D_209"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- Comments -->
                            <xsl:for-each
                                select="S_PID[D_349 = 'F' and D_750 = 'GEN' and D_352 != '']">
                                <xsl:element name="Comments">
                                    <xsl:attribute name="xml:lang">
                                        <xsl:choose>
                                            <xsl:when test="D_819 != ''">
                                                <xsl:value-of select="D_819"/>
                                            </xsl:when>
                                            <xsl:otherwise>EN</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="D_352"/>
                                    <xsl:if test="$cXMLAttachments != ''">
                                        <xsl:variable name="tokenizedAttachments"
                                            select="tokenize($cXMLAttachments, $attachSeparator)"/>
                                        <xsl:for-each select="$tokenizedAttachments">
                                            <xsl:if test="normalize-space(.) != ''">
                                                <Attachment>
                                                  <URL>
                                                  <xsl:value-of select="."/>
                                                  </URL>
                                                </Attachment>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- TermsOfDelivery -->
                            <xsl:if test="S_FOB/D_146 != '' and S_FOB/D_309_1 != ''">
                                <xsl:variable name="TODCode">
                                    <xsl:value-of select="S_FOB/D_352_1"/>
                                </xsl:variable>
                                <xsl:variable name="SPMCode">
                                    <xsl:value-of select="S_FOB/D_146"/>
                                </xsl:variable>
                                <xsl:variable name="SPMVal">
                                    <xsl:value-of select="S_FOB/D_352_2"/>
                                </xsl:variable>
                                <xsl:variable name="TTCode">
                                    <xsl:value-of select="S_FOB/D_335"/>
                                </xsl:variable>
                                <xsl:element name="TermsOfDelivery">
                                    <xsl:element name="TermsOfDeliveryCode">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="S_FOB/D_309_1 = 'ZZ'"
                                                  >Other</xsl:when>
                                                <xsl:when
                                                  test="S_FOB/D_309_1 = 'ZN' and normalize-space($TODCode) != '' and $TODCode = $todValues">
                                                  <xsl:value-of select="$TODCode"/>
                                                </xsl:when>
                                                <xsl:otherwise>Other</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when
                                                test="S_FOB/D_309_1 = 'ZZ' and normalize-space($TODCode) != ''">
                                                <xsl:value-of select="$TODCode"/>
                                            </xsl:when>
                                            <xsl:when
                                                test="S_FOB/D_309_1 = 'ZN' and normalize-space($TODCode) != '' and not($TODCode = $todValues)">
                                                <xsl:value-of select="$TODCode"/>
                                            </xsl:when>
                                            <xsl:when test="S_FOB/D_309_1 = 'ZZ'">
                                                <xsl:text>Other</xsl:text>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="ShippingPaymentMethod">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="S_FOB/D_309_2 = 'ZZ' and normalize-space($Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMVal]/CXMLCode) != ''">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="$SPMVal = 'DefinedByBuyerAndSeller'"
                                                  >Other</xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="$SPMVal"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:when>
                                                <xsl:when
                                                  test="S_FOB/D_309_2 = 'ZZ' and $SPMVal = $spmValues">
                                                  <xsl:value-of select="$SPMVal"/>
                                                </xsl:when>
                                                <xsl:when
                                                  test="$SPMVal = '' and normalize-space($Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[X12Code = $SPMCode]/CXMLCode) != ''">
                                                  <xsl:value-of
                                                  select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[X12Code = $SPMCode]/CXMLCode"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:text>Other</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="$SPMVal = 'DefinedByBuyerAndSeller'"
                                                >Other</xsl:when>
                                            <xsl:when
                                                test="S_FOB/D_309_2 = 'ZZ' and normalize-space($Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $SPMVal]/CXMLCode) = '' and not($SPMVal = $spmValues)">
                                                <xsl:value-of select="$SPMVal"/>
                                            </xsl:when>
                                            <xsl:when test="$SPMVal = 'Other'">Other</xsl:when>
                                        </xsl:choose>
                                    </xsl:element>
                                    <xsl:if test="S_FOB/D_334 = 'ZZ'">
                                        <xsl:element name="TransportTerms">
                                            <xsl:attribute name="value">
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="normalize-space($Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $TTCode]/CXMLCode) != ''">
                                                  <xsl:value-of
                                                  select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $TTCode]/CXMLCode"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>Other</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <xsl:if
                                                test="$TTCode = 'ZZZ' and S_REF[D_128 = '0L' and D_127 = 'FOB05']/D_352 != ''">
                                                <xsl:value-of
                                                  select="S_REF[D_128 = '0L' and D_127 = 'FOB05']/D_352"
                                                />
                                            </xsl:if>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:for-each select="G_N1[S_N1/D_98_1 = 'DA']">
                                        <xsl:call-template name="createAddress">
                                            <xsl:with-param name="contact" select="."/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <xsl:if
                                        test="S_REF[D_128 = '0L' and D_127 = 'TODComments']/D_352 != ''">
                                        <xsl:element name="Comments">
                                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                                            <xsl:attribute name="type"
                                                >TermsOfDelivery</xsl:attribute>
                                            <xsl:value-of
                                                select="normalize-space(S_REF[D_128 = '0L' and D_127 = 'TODComments']/D_352)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if
                                        test="S_REF[D_128 = '0L' and D_127 = 'TransportComments']/D_352 != ''">
                                        <xsl:element name="Comments">
                                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                                            <xsl:attribute name="type">Transport</xsl:attribute>
                                            <xsl:value-of
                                                select="normalize-space(S_REF[D_128 = '0L' and D_127 = 'TransportComments']/D_352)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                            <xsl:for-each select="S_TD3[D_40_1 != '' or D_207 != '' or D_206 != '' or D_225 != '']">
                                <xsl:element name="TermsOfTransport">
                                    <xsl:if test="D_225 != ''">
                                        <xsl:element name="SealID">
                                            <xsl:value-of select="D_225"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:variable name="eqCode" select="D_40_1"/>
                                    <xsl:variable name="eqID" select="concat(D_206, D_207)"/>
                                    <xsl:choose>
                                        <xsl:when test="(not(exists(D_207)) or D_207 = '') and $Lookup/Lookups/Equipmentcodes/Equipmentcode[X12Code = $eqCode]/CXMLCode != ''">
                                            <xsl:element name="EquipmentIdentificationCode">
                                                <xsl:value-of
                                                    select="$Lookup/Lookups/Equipmentcodes/Equipmentcode[X12Code = $eqCode]/CXMLCode"
                                                />
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="D_207 != ''">
                                            <xsl:element name="EquipmentIdentificationCode">
                                                <xsl:value-of select="$eqID"/>
                                            </xsl:element>
                                            <xsl:element name="Extrinsic">
                                                <xsl:attribute name="name">EquipmentID</xsl:attribute>
                                                <xsl:value-of select="$eqID"/>
                                            </xsl:element>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- Header Level Packaging -->
                            <xsl:if test="/">
                                
                            </xsl:if>
                            <!-- 12512 -->
                            <xsl:if
                                test="exists(S_TD1[D_187 = 'G' and D_81 != '' and D_355_1 != '']) or exists(S_TD1[D_187 = 'N' and D_81 != '' and D_355_1 != '']) or exists(S_TD1[D_183 != '' and D_355_2 != ''])  or exists(S_MEA[D_738 != 'G' and D_738 != 'VWT' and D_738 != 'WT' and D_739 != ''])">
                                <xsl:element name="Packaging">
                                    <!-- MEA -->
                                    <xsl:for-each select="S_MEA[D_738 != 'G' and D_738 != 'VWT' and D_738 != 'WT' and D_737 = 'PD' and D_739 != '']">
                                        <xsl:variable name="meaType" select="D_738"/>                                        
                                        <xsl:variable name="uom" select="C_C001/D_355_1"/>                                        
                                        <xsl:element name="Dimension">
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="D_739"/>
                                            </xsl:attribute>
                                            <xsl:if test="$Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $meaType]/CXMLCode != ''">
                                                <xsl:attribute name="type"><xsl:value-of select="normalize-space($Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $meaType]/CXMLCode)"/></xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                                <xsl:element name="UnitOfMeasure">
                                                    <xsl:value-of
                                                        select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode)"
                                                    />
                                                </xsl:element>
                                            </xsl:if>                                            
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each
                                        select="S_TD1[D_187 = 'G' and D_81 != '' and D_355_1 != '']">
                                        <xsl:variable name="uom" select="D_355_1"/>
                                        <xsl:element name="Dimension">
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="D_81"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="type">grossWeight</xsl:attribute>
                                            <xsl:element name="UnitOfMeasure">
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                                        <xsl:value-of
                                                            select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode)"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>ZZ</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each
                                        select="S_TD1[D_187 = 'N' and D_81 != '' and D_355_1 != '']">
                                        <xsl:variable name="uom" select="D_355_1"/>
                                        <xsl:element name="Dimension">
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="D_81"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="type">weight</xsl:attribute>
                                            <xsl:element name="UnitOfMeasure">
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                                        <xsl:value-of
                                                            select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode)"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>ZZ</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <!--IG7578-->
                                    <xsl:for-each select="S_TD1[D_183 != '' and D_355_2 != '']">
                                        <xsl:variable name="uom" select="D_355_2"/>
                                        <xsl:element name="Dimension">
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="D_183"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="type">grossVolume</xsl:attribute>
                                            <xsl:element name="UnitOfMeasure">
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                                        <xsl:value-of
                                                            select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode)"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>ZZ</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                    
                                </xsl:element>
                            </xsl:if>
                            
                            <!--Header total Packaging-->
                            <xsl:choose>
                                <xsl:when
                                    test="S_TD1[D_80 != ''] and count(S_TD1[D_80 != '']) &gt; 1">
                                    <xsl:for-each select="S_TD1[D_80 != '']">
                                        <xsl:if test="position() = 1">
                                            <xsl:element name="Extrinsic">
                                                <xsl:attribute name="name"
                                                  >totalOfPackagesLevel0001</xsl:attribute>
                                                <xsl:value-of select="D_80"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="position() = 2">
                                            <xsl:element name="Extrinsic">
                                                <xsl:attribute name="name"
                                                  >totalOfPackagesLevel0002</xsl:attribute>
                                                <xsl:value-of select="D_80"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="S_TD1[D_80 != ''] and count(S_TD1[D_80 != '']) = 1">
                                    <xsl:element name="Extrinsic">
                                        <xsl:attribute name="name">totalOfPackages</xsl:attribute>
                                        <xsl:value-of select="S_TD1/D_80"/>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                            <!-- PickUpDate -->
                            <xsl:choose>
                                <xsl:when test="S_DTM[D_374 = '118']/D_373 != ''">
                                    <xsl:element name="Extrinsic">
                                        <xsl:attribute name="name">PickUpDate</xsl:attribute>
                                        <xsl:call-template name="convertToAribaDate">
                                            <xsl:with-param name="Date">
                                                <xsl:value-of select="S_DTM[D_374 = '118']/D_373"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="Time">
                                                <xsl:value-of select="S_DTM[D_374 = '118']/D_337"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="TimeCode">
                                                <xsl:value-of select="S_DTM[D_374 = '118']/D_623"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="../S_DTM[D_374 = '118']/D_373 != ''">
                                    <xsl:element name="Extrinsic">
                                        <xsl:attribute name="name">PickUpDate</xsl:attribute>
                                        <xsl:call-template name="convertToAribaDate">
                                            <xsl:with-param name="Date">
                                                <xsl:value-of select="../S_DTM[D_374 = '118']/D_373"
                                                />
                                            </xsl:with-param>
                                            <xsl:with-param name="Time">
                                                <xsl:value-of select="../S_DTM[D_374 = '118']/D_337"
                                                />
                                            </xsl:with-param>
                                            <xsl:with-param name="TimeCode">
                                                <xsl:value-of select="../S_DTM[D_374 = '118']/D_623"
                                                />
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="S_REF[D_128 = 'CT']/D_352 != ''">
                                <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name"
                                        >ShippingContractNumber</xsl:attribute>
                                    <xsl:value-of select="S_REF[D_128 = 'CT']/D_352"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="S_REF[D_128 = 'DJ']/D_352 != ''">
                                <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">DeliveryNoteID</xsl:attribute>
                                    <xsl:value-of select="S_REF[D_128 = 'DJ']/D_352"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="S_REF[D_128 = 'IN']/D_352 != ''">
                                <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">InvoiceID</xsl:attribute>
                                    <xsl:value-of select="S_REF[D_128 = 'IN']/D_352"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="S_REF[D_128 = 'VN']/D_352 != ''">
                                <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">SupplierOrderID</xsl:attribute>
                                    <xsl:value-of select="S_REF[D_128 = 'VN']/D_352"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:for-each select="S_REF[D_128 = 'ZZ'][D_352 != '']">
                                <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="normalize-space(D_127)"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="normalize-space(D_352)"/>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- CG: IG-16765 - 1500 Extrinsics -->
                            <xsl:if test="$useExtrinsicsLookup = 'yes'">
                                <xsl:for-each select="S_REF[D_128 != 'ZZ']">
                                    <xsl:variable name="refQualVal" select="D_128"/>
                                    <xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/ShipHeaderEx))][1]/CXMLCode"/>
                                    <xsl:if test="$extNameL != ''">
                                        <xsl:element name="Extrinsic">
                                            <xsl:attribute name="name">
                                                <xsl:value-of select="$extNameL"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="concat(D_127,D_352)"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:for-each
                                select="S_REF[(D_128 = 'AEC' or D_128 = 'D2' or D_128 = 'DD' or D_128 = 'CR' or D_128 = 'EU') and D_352 != '']">
                                <xsl:element name="IdReference">
                                    <xsl:attribute name="domain">
                                        <xsl:choose>
                                            <xsl:when test="D_128 = 'AEC'"
                                                >governmentNumber</xsl:when>
                                            <xsl:when test="D_128 = 'D2'"
                                                >supplierReference</xsl:when>
                                            <xsl:when test="D_128 = 'DD'">documentName</xsl:when>
                                            <xsl:when test="D_128 = 'CR'"
                                                >customerReferenceID</xsl:when>
                                            <xsl:when test="D_128 = 'EU'"
                                                >ultimateCustomerReferenceID</xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:attribute name="identifier">
                                        <xsl:value-of select="normalize-space(D_352)"/>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- IG-12512 -->                           
                            <xsl:for-each
                                select="S_REF[(D_127 != 'FOB05' and D_127 != 'TODComments' and D_127 != 'TransportComments' and D_127!='') and D_352!='' and D_128 = '0L']">
                                <xsl:element name="ReferenceDocumentInfo">
                                    <xsl:element name="DocumentInfo">
                                        <xsl:attribute name="documentID"> 
                                            <xsl:value-of select="D_127"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="documentType">
                                            <xsl:value-of select="D_352"/>
                                        </xsl:attribute>
                                        <xsl:if test=" normalize-space(C_C040/D_127_1)!='' and normalize-space(C_C040/D_128)!='0L'">
                                        <xsl:attribute name="documentDate">
                                             <xsl:call-template name="convertToAribaDate">
                                                <xsl:with-param name="Date">
                                                    <xsl:value-of select="substring(C_C040/D_127_1,1,8)"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="Time">
                                                    <xsl:value-of select="substring(C_C040/D_127_1,9,6)"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="TimeCode">
                                                    <xsl:value-of select="substring(C_C040/D_127_1,15,2)"/>                                                    
                                                </xsl:with-param>                                                 
                                            </xsl:call-template>                                            
                                        </xsl:attribute>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:element>                                
                            </xsl:for-each>                           
                        </xsl:for-each>
                    </xsl:element>
                    <!-- ShipControl -->
                    <xsl:for-each
                        select="FunctionalGroup/M_856/G_HL[S_HL/D_628 = '1' and S_HL/D_735 = 'S' and S_HL/D_736 = '1'][1]">
                        <xsl:if test="exists(S_TD5[D_66 = 'ZZ' or (D_66 != '' and D_66 != 'ZZ')])">
                            <xsl:element name="ShipControl">
                                <xsl:for-each select="S_TD5">
                                    <xsl:element name="CarrierIdentifier">
                                        <xsl:attribute name="domain">
                                            <xsl:choose>
                                                <xsl:when test="./D_66 = '1'">DUNS</xsl:when>
                                                <xsl:when test="./D_66 = '2'">SCAC</xsl:when>
                                                <xsl:when test="./D_66 = '4'">IATA</xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="./D_67"/>
                                    </xsl:element>
                                    <xsl:if test="./D_387 != ''">
                                        <xsl:element name="CarrierIdentifier">
                                            <xsl:attribute name="domain">companyName</xsl:attribute>
                                            <xsl:value-of select="./D_387"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each
                                    select="S_TD4[D_152 = 'ZZZ' and D_352 != '' and contains(D_352, '@')]">
                                    <xsl:element name="CarrierIdentifier">
                                        <xsl:attribute name="domain">
                                            <xsl:value-of select="substring-before(D_352, '@')"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="substring-after(D_352, '@')"/>
                                    </xsl:element>
                                </xsl:for-each>
                                <!-- IG-5454 -->
                                <xsl:choose>
                                    <xsl:when
                                        test="((S_TD5[D_66 != 'ZZ' and D_309 = 'ZZ']/D_310 != '') or (S_REF[D_128 = 'BM']/D_127 != '' and (S_TD5[D_66 != 'ZZ']/D_387 != '' or S_TD5[D_66 = '1' or D_66 = '2' or D_66 = '4']/D_67 != '')))">
                                        <xsl:variable name="trackingURL"
                                            select="S_REF[D_128 = 'CN']/D_127"/>
                                        <xsl:variable name="trackingDate"
                                            select="S_REF[D_128 = 'CN']/D_352"/>
                                        <xsl:for-each select="S_TD5[D_66 != 'ZZ' and D_309 = 'ZZ']">
                                            <xsl:element name="ShipmentIdentifier">
                                                <xsl:if
                                                  test="$trackingURL != '' or $trackingDate != ''">
                                                  <xsl:attribute name="domain">
                                                  <xsl:value-of select="'trackingNumber'"/>
                                                  </xsl:attribute>
                                                  <xsl:if test="$trackingURL != ''">
                                                  <xsl:attribute name="trackingURL">
                                                  <xsl:value-of select="$trackingURL"/>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:if test="$trackingDate != ''">
                                                  <xsl:attribute name="trackingNumberDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date">
                                                  <xsl:value-of
                                                  select="substring($trackingDate, 1, 8)"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="Time">
                                                  <xsl:value-of
                                                  select="substring($trackingDate, 9, 6)"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="TimeCode">
                                                  <xsl:value-of
                                                  select="substring($trackingDate, 15)"/>
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                </xsl:if>
                                                <xsl:value-of select="./D_310"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                        <xsl:if
                                            test="S_REF[D_128 = 'BM']/D_127 != '' and (S_TD5[D_66 != 'ZZ']/D_387 != '' or S_TD5[D_66 = '1' or D_66 = '2' or D_66 = '4']/D_67 != '')">
                                            <xsl:element name="ShipmentIdentifier">
                                                <xsl:attribute name="domain"
                                                  >billOfLading</xsl:attribute>
                                                <xsl:value-of select="S_REF[D_128 = 'BM']/D_127"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="ShipmentIdentifier"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="exists(S_TD5[D_66 = 'ZZ'])">
                                        <xsl:for-each select="S_TD5[D_66 = 'ZZ']">
                                            <xsl:element name="TransportInformation">
                                                <xsl:element name="Route">
                                                  <xsl:variable name="method" select="D_91"/>
                                                  <xsl:attribute name="method">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'standard']/CXMLCode != ''">
                                                  <xsl:value-of
                                                  select="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'standard']/CXMLCode"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>custom</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:if
                                                  test="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'custom']/CXMLCode != ''">
                                                  <xsl:value-of
                                                  select="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'custom']/CXMLCode"
                                                  />
                                                  </xsl:if>
                                                </xsl:element>
                                                <xsl:element name="ShippingContractNumber">
                                                  <xsl:value-of select="D_67"/>
                                                </xsl:element>
                                                <xsl:element name="ShippingInstructions">
                                                  <xsl:element name="Description">
                                                  <xsl:attribute name="xml:lang">en</xsl:attribute>
                                                  <xsl:value-of select="normalize-space(D_310)"/>
                                                  <xsl:for-each
                                                  select="../S_REF[D_128 = '0N' and D_127 = 'ShipInstruct']">
                                                  <xsl:value-of select="normalize-space(D_352)"/>
                                                  </xsl:for-each>
                                                  </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="exists(S_TD5[D_66 != 'ZZ'])">
                                        <xsl:for-each select="S_TD5[D_66 != 'ZZ']">
                                            <xsl:element name="Route">
                                                <xsl:variable name="method" select="D_91"/>
                                                <xsl:attribute name="method">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'standard']/CXMLCode != ''">
                                                  <xsl:value-of
                                                  select="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'standard']/CXMLCode"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>custom</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:if
                                                  test="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'custom']/CXMLCode != ''">
                                                  <xsl:value-of
                                                  select="$Lookup/Lookups/TransportMethods/TransportMethod[X12Code = $method][Type = 'custom']/CXMLCode"
                                                  />
                                                </xsl:if>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- ShipNoticePortion -->
                    <xsl:for-each
                        select="FunctionalGroup/M_856/G_HL[S_HL/D_734 = '1' and S_HL/D_735 = 'O']">
                        <xsl:variable name="HLOrdLoopID" select="S_HL/D_628"/>
                        <xsl:variable name="CURHL_O" select="S_CUR/D_100_1"/>
                        <xsl:variable name="CURHL_S"
                            select="../G_HL[S_HL/D_628 = '1' and S_HL/D_735 = 'S' and S_HL/D_736 = '1']/S_CUR/D_100_1"/>
                        <xsl:element name="ShipNoticePortion">
                            <xsl:element name="OrderReference">
                                <xsl:attribute name="orderID">
                                    <xsl:choose>
                                        <xsl:when test="S_REF[D_128 = 'PO']/D_127 != ''">
                                            <xsl:value-of select="S_REF[D_128 = 'PO']/D_127"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="S_PRF/D_324"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:variable name="chkOrderDate">
                                    <xsl:choose>
                                        <xsl:when test="S_DTM[D_374 = '004']/D_373 != ''">
                                            <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date">
                                                  <xsl:value-of select="S_DTM[D_374 = '004']/D_373"
                                                  />
                                                </xsl:with-param>
                                                <xsl:with-param name="Time">
                                                  <xsl:value-of select="S_DTM[D_374 = '004']/D_337"
                                                  />
                                                </xsl:with-param>
                                                <xsl:with-param name="TimeCode">
                                                  <xsl:value-of select="S_DTM[D_374 = '004']/D_623"
                                                  />
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:when test="S_PRF/D_373 != ''">
                                            <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date">
                                                  <xsl:value-of select="S_PRF/D_373"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:if test="$chkOrderDate != ''">
                                    <xsl:attribute name="orderDate">
                                        <xsl:value-of select="$chkOrderDate"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:element name="DocumentReference">
                                    <xsl:attribute name="payloadID"/>
                                </xsl:element>
                            </xsl:element>
                            <!--IG-3424 - Update to standards - Going to support CT in order to be abckward compatible-->
                            <xsl:if
                                test="S_REF[D_128 = 'AH']/D_352 != '' or S_REF[D_128 = 'CT']/D_352 != '' or S_PRF/D_367 != ''">
                                <xsl:element name="MasterAgreementIDInfo">
                                    <xsl:attribute name="agreementID">
                                        <xsl:choose>
                                            <xsl:when test="S_REF[D_128 = 'AH']/D_352 != ''">
                                                <xsl:value-of select="S_REF[D_128 = 'AH']/D_352"/>
                                            </xsl:when>
                                            <!--IG-3242- Update to standards. Continue support for backward Compatibility-->
                                            <xsl:when test="S_REF[D_128 = 'CT']/D_352 != ''">
                                                <xsl:value-of select="S_REF[D_128 = 'CT']/D_352"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="S_PRF/D_367"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:if test="S_DTM[D_374 = 'LEA']/D_373 != ''">
                                        <xsl:attribute name="agreementDate">
                                            <xsl:call-template name="convertToAribaDate">
                                                <xsl:with-param name="Date">
                                                  <xsl:value-of select="S_DTM[D_374 = 'LEA']/D_373"
                                                  />
                                                </xsl:with-param>
                                                <xsl:with-param name="Time">
                                                  <xsl:value-of select="S_DTM[D_374 = 'LEA']/D_337"
                                                  />
                                                </xsl:with-param>
                                                <xsl:with-param name="TimeCode">
                                                  <xsl:value-of select="S_DTM[D_374 = 'LEA']/D_623"
                                                  />
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="S_REF[D_128 = 'AH' or D_128 = 'CT']/D_127 = '1'">
                                        <xsl:attribute name="agreementType"
                                            >scheduling_agreement</xsl:attribute>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                            <!-- Contact -->
                            <xsl:for-each select="G_N1[S_N1/D_98_1 != 'DA']">
                                <xsl:call-template name="createContact">
                                    <xsl:with-param name="contact" select="."/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <!-- Comments -->
                            <xsl:for-each
                                select="S_PID[D_349 = 'F' and D_750 = 'GEN' and D_352 != '']">
                                <xsl:element name="Comments">
                                    <xsl:attribute name="xml:lang">
                                        <xsl:choose>
                                            <xsl:when test="D_819 != ''">
                                                <xsl:value-of select="D_819"/>
                                            </xsl:when>
                                            <xsl:otherwise>EN</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="D_352"/>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- Extrinsics -->
                            <xsl:for-each select="S_REF[D_128 = 'ZZ']">
                                <xsl:element name="Extrinsic">
                                    <xsl:attribute name="name">
                                        <xsl:value-of select="D_127"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="D_352"/>
                                </xsl:element>
                            </xsl:for-each>
                            <!-- CG: IG-16765 - 1500 Extrinsics -->
                            <xsl:if test="$useExtrinsicsLookup = 'yes'">
                                <xsl:for-each select="S_REF[D_128 != 'ZZ']">
                                    <xsl:variable name="refQualVal" select="D_128"/>
                                    <xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/ShipPortionEx))][1]/CXMLCode"/>
                                    <xsl:if test="$extNameL != ''">
                                        <xsl:element name="Extrinsic">
                                            <xsl:attribute name="name">
                                                <xsl:value-of select="$extNameL"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="concat(D_127,D_352)"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:for-each
                                select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $HLOrdLoopID]">
                                <xsl:choose>
                                    <xsl:when test="$StructureType = 'SOTPI'">
                                        <xsl:choose>
                                            <xsl:when test="S_HL/D_735 = 'P'">
                                                <xsl:variable name="HLPackLoopID"
                                                  select="S_HL/D_628"/>
                                                <xsl:for-each
                                                  select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $HLPackLoopID]">
                                                  <xsl:variable name="HLItemLoopID"
                                                  select="S_HL/D_628"/>
                                                  <xsl:call-template name="createShipNoticeLine">
                                                  <xsl:with-param name="HLItemLoopID"
                                                  select="$HLItemLoopID"/>
                                                  <xsl:with-param name="HLPackLoopID"
                                                  select="$HLPackLoopID"/>
                                                  <xsl:with-param name="StructureType"
                                                  select="$StructureType"/>
                                                  <xsl:with-param name="CURHL_O" select="$CURHL_O"/>
                                                  <xsl:with-param name="CURHL_S" select="$CURHL_S"/>
                                                  </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="S_HL/D_735 = 'T'">
                                                <xsl:variable name="HLTareLoopID"
                                                  select="S_HL/D_628"/>
                                                <xsl:for-each
                                                  select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $HLTareLoopID]">
                                                  <xsl:variable name="HLPackLoopID"
                                                  select="S_HL/D_628"/>
                                                  <xsl:for-each
                                                  select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $HLPackLoopID]">
                                                  <xsl:variable name="HLItemLoopID"
                                                  select="S_HL/D_628"/>
                                                  <xsl:call-template name="createShipNoticeLine">
                                                  <xsl:with-param name="HLItemLoopID"
                                                  select="$HLItemLoopID"/>
                                                  <xsl:with-param name="CURHL_O" select="$CURHL_O"/>
                                                  <xsl:with-param name="CURHL_S" select="$CURHL_S"/>
                                                  <xsl:with-param name="HLTareLoopID"
                                                  select="$HLTareLoopID"/>
                                                  <xsl:with-param name="HLPackLoopID"
                                                  select="$HLPackLoopID"/>
                                                  <xsl:with-param name="StructureType"
                                                  select="$StructureType"/>
                                                  </xsl:call-template>
                                                  </xsl:for-each>
                                                </xsl:for-each>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="$StructureType = 'SOITP'">
                                        <xsl:if test="S_HL/D_735 = 'I'">
                                            <xsl:if test="S_HL/D_736 = '0' or S_HL/D_736 = '1'">
                                                <xsl:variable name="HLItemLoopID"
                                                  select="S_HL/D_628"/>
                                                <xsl:call-template name="createShipNoticeLine">
                                                  <xsl:with-param name="HLItemLoopID"
                                                  select="$HLItemLoopID"/>
                                                  <xsl:with-param name="StructureType"
                                                  select="$StructureType"/>
                                                  <xsl:with-param name="CURHL_O" select="$CURHL_O"/>
                                                  <xsl:with-param name="CURHL_S" select="$CURHL_S"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="S_HL/D_735 = 'I'">
                                                <xsl:if test="S_HL/D_736 = '0' or S_HL/D_736 = '1'">
                                                  <xsl:variable name="HLItemLoopID"
                                                  select="S_HL/D_628"/>
                                                  <xsl:call-template name="createShipNoticeLine">
                                                  <xsl:with-param name="HLItemLoopID"
                                                  select="$HLItemLoopID"/>
                                                  <xsl:with-param name="CURHL_O" select="$CURHL_O"/>
                                                  <xsl:with-param name="CURHL_S" select="$CURHL_S"/>
                                                  </xsl:call-template>
                                                </xsl:if>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <!-- 12512 -->
                            <xsl:for-each
                                select="S_REF[D_128 = '0L' and D_127!='' and D_352!='']">
                                <xsl:element name="ReferenceDocumentInfo">
                                    <xsl:element name="DocumentInfo">
                                        <xsl:attribute name="documentID"> 
                                            <xsl:value-of select="D_127"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="documentType">
                                            <xsl:value-of select="D_352"/>
                                        </xsl:attribute>
                                        <xsl:if test=" normalize-space(C_C040/D_127_1)!='' and normalize-space(C_C040/D_128)!='0L'">
                                            <xsl:attribute name="documentDate">
                                                <xsl:call-template name="convertToAribaDate">
                                                    <xsl:with-param name="Date">
                                                        <xsl:value-of select="substring(C_C040/D_127_1,1,8)"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name="Time">
                                                        <xsl:value-of select="substring(C_C040/D_127_1,9,6)"/>
                                                    </xsl:with-param>
                                                    <xsl:with-param name="TimeCode">
                                                        <xsl:value-of select="substring(C_C040/D_127_1,15,2)"/>                                                    
                                                    </xsl:with-param>                                                 
                                                </xsl:call-template>                                            
                                            </xsl:attribute>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:element>                                
                            </xsl:for-each>                            
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
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
                                select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"
                            />
                        </xsl:attribute>
                    </element>
                </xsl:if>
            </xsl:for-each>
        </lin>
    </xsl:template>
    <xsl:template match="S_PER">
        <xsl:variable name="PER02">
            <xsl:choose>
                <xsl:when test="D_93 != ''">
                    <xsl:value-of select="D_93"/>
                </xsl:when>
                <xsl:otherwise>default</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="D_365_1 = 'EM'">
                <Con>
                    <xsl:attribute name="type">Email</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_1)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_1 = 'UR'">
                <Con>
                    <xsl:attribute name="type">URL</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_1)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_1 = 'TE'">
                <Con>
                    <xsl:attribute name="type">Phone</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, '(')">
                                <xsl:value-of select="substring-before(D_364_1, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, '-')">
                                <xsl:value-of select="substring-before(D_364_1, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364_1, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_1, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_1 = 'FX'">
                <Con>
                    <xsl:attribute name="type">Fax</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, '(')">
                                <xsl:value-of select="substring-before(D_364_1, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, '-')">
                                <xsl:value-of select="substring-before(D_364_1, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364_1, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_1, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="D_365_2 = 'EM'">
                <Con>
                    <xsl:attribute name="type">Email</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_2)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_2 = 'UR'">
                <Con>
                    <xsl:attribute name="type">URL</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_2)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_2 = 'TE'">
                <Con>
                    <xsl:attribute name="type">Phone</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, '(')">
                                <xsl:value-of select="substring-before(D_364_2, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, '-')">
                                <xsl:value-of select="substring-before(D_364_2, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
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
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_2, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_2 = 'FX'">
                <Con>
                    <xsl:attribute name="type">Fax</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, '(')">
                                <xsl:value-of select="substring-before(D_364_2, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, '-')">
                                <xsl:value-of select="substring-before(D_364_2, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
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
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_2, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="D_365_3 = 'EM'">
                <Con>
                    <xsl:attribute name="type">Email</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_3)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_3 = 'UR'">
                <Con>
                    <xsl:attribute name="type">URL</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_3)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_3 = 'TE'">
                <Con>
                    <xsl:attribute name="type">Phone</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, '(')">
                                <xsl:value-of select="substring-before(D_364_3, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, '-')">
                                <xsl:value-of select="substring-before(D_364_3, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
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
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_3, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_3 = 'FX'">
                <Con>
                    <xsl:attribute name="type">Fax</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, '(')">
                                <xsl:value-of select="substring-before(D_364_3, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, '-')">
                                <xsl:value-of select="substring-before(D_364_3, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
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
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_3, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="createAddress">
        <xsl:param name="contact"/>
        <xsl:element name="Address">
            <xsl:if test="$contact/S_N1/D_66 != '' or $contact/S_N1/D_67 != ''">
                <xsl:variable name="addrDomain">
                    <xsl:value-of select="$contact/S_N1/D_66"/>
                </xsl:variable>
                <xsl:variable name="addressID">
                    <xsl:value-of select="$contact/S_N1/D_67"/>
                </xsl:variable>
                <xsl:if test="$addressID != ''">
                    <xsl:attribute name="addressID">
                        <xsl:value-of select="$addressID"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
                    <xsl:if
                        test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode != ''">
                        <xsl:attribute name="addressIDDomain">
                            <xsl:value-of
                                select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"
                            />
                        </xsl:attribute>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:element name="Name">
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:value-of select="$contact/S_N1/D_93"/>
            </xsl:element>
            <!-- PostalAddress -->
            <xsl:if
                test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
                <xsl:element name="PostalAddress">
                    <xsl:if test="$contact/S_REF[D_128 = 'ME']/D_352 != ''">
                        <xsl:attribute name="name">
                            <xsl:value-of select="$contact/S_REF[D_128 = 'ME']/D_352"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:for-each select="$contact/S_N2">
                        <xsl:element name="DeliverTo">
                            <xsl:value-of select="D_93_1"/>
                        </xsl:element>
                        <xsl:if test="D_93_2 != ''">
                            <xsl:element name="DeliverTo">
                                <xsl:value-of select="D_93_2"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$contact/S_N3">
                        <xsl:element name="Street">
                            <xsl:value-of select="D_166_1"/>
                        </xsl:element>
                        <xsl:if test="D_166_2 != ''">
                            <xsl:element name="Street">
                                <xsl:value-of select="D_166_2"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:element name="City">
                        <xsl:value-of select="$contact/S_N4/D_19"/>
                    </xsl:element>
                    <xsl:variable name="stateCode">
                        <xsl:choose>
                            <xsl:when
                                test="$contact/S_N4/D_310 != '' and not(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA'))">
                                <xsl:value-of select="$contact/S_N4/D_310"/>
                            </xsl:when>
                            <xsl:when test="$contact/S_N4/D_156 != ''">
                                <xsl:value-of select="$contact/S_N4/D_156"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$stateCode != ''">
                        <xsl:element name="State">
                            <xsl:value-of select="$stateCode"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$contact/S_N4/D_116 != ''">
                        <xsl:element name="PostalCode">
                            <xsl:value-of select="$contact/S_N4/D_116"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:variable name="isoCountryCode">
                        <xsl:value-of select="$contact/S_N4/D_26"/>
                    </xsl:variable>
                    <xsl:element name="Country">
                        <xsl:attribute name="isoCountryCode">
                            <xsl:value-of select="$isoCountryCode"/>
                        </xsl:attribute>
                        <xsl:value-of
                            select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
                        />
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:variable name="contactList">
                <xsl:apply-templates select="$contact/S_PER"/>
            </xsl:variable>
            <xsl:for-each select="$contactList/Con[@type = 'Email'][1]">
                <xsl:element name="Email">
                    <xsl:attribute name="name">
                        <xsl:value-of select="./@name"/>
                    </xsl:attribute>
                    <xsl:value-of select="./@value"/>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'Phone'][1]">
                <xsl:sort select="@name"/>
                <xsl:variable name="cCode" select="@cCode"/>
                <xsl:element name="Phone">
                    <xsl:attribute name="name">
                        <xsl:value-of select="./@name"/>
                    </xsl:attribute>
                    <xsl:element name="TelephoneNumber">
                        <xsl:element name="CountryCode">
                            <xsl:attribute name="isoCountryCode">
                                <xsl:choose>
                                    <xsl:when
                                        test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                        <xsl:value-of
                                            select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>US</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:value-of select="replace(@cCode, '\+', '')"/>
                        </xsl:element>
                        <xsl:element name="AreaOrCityCode">
                            <xsl:value-of select="@aCode"/>
                        </xsl:element>
                        <xsl:element name="Number">
                            <xsl:value-of select="@num"/>
                        </xsl:element>
                        <xsl:if test="@ext != ''">
                            <xsl:element name="Extension">
                                <xsl:value-of select="@ext"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'Fax'][1]">
                <xsl:sort select="@name"/>
                <xsl:variable name="cCode" select="@cCode"/>
                <xsl:element name="Fax">
                    <xsl:attribute name="name">
                        <xsl:value-of select="./@name"/>
                    </xsl:attribute>
                    <xsl:element name="TelephoneNumber">
                        <xsl:element name="CountryCode">
                            <xsl:attribute name="isoCountryCode">
                                <xsl:choose>
                                    <xsl:when
                                        test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                        <xsl:value-of
                                            select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>US</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:value-of select="replace(@cCode, '\+', '')"/>
                        </xsl:element>
                        <xsl:element name="AreaOrCityCode">
                            <xsl:value-of select="@aCode"/>
                        </xsl:element>
                        <xsl:element name="Number">
                            <xsl:value-of select="@num"/>
                        </xsl:element>
                        <xsl:if test="@ext != ''">
                            <xsl:element name="Extension">
                                <xsl:value-of select="@ext"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'URL'][1]">
                <xsl:sort select="@name"/>
                <xsl:element name="URL">
                    <xsl:attribute name="name">
                        <xsl:value-of select="./@name"/>
                    </xsl:attribute>
                    <xsl:value-of select="./@value"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="createContact">
        <xsl:param name="contact"/>
        <xsl:variable name="role">
            <xsl:value-of select="$contact/S_N1/D_98_1"/>
        </xsl:variable>
        <xsl:if test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
            <xsl:element name="Contact">
                <xsl:attribute name="role">
                    <xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode"/>
                </xsl:attribute>
                <xsl:if test="$contact/S_N1/D_66 != '' or $contact/S_N1/D_67 != ''">
                    <xsl:variable name="addrDomain">
                        <xsl:value-of select="$contact/S_N1/D_66"/>
                    </xsl:variable>
                    <xsl:variable name="addressID">
                        <xsl:value-of select="$contact/S_N1/D_67"/>
                    </xsl:variable>
                    <xsl:if test="$addressID != ''">
                        <xsl:attribute name="addressID">
                            <xsl:value-of select="$addressID"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
                        <xsl:if
                            test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode != ''">
                            <xsl:attribute name="addressIDDomain">
                                <xsl:value-of
                                    select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"
                                />
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
                <xsl:element name="Name">
                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                    <xsl:value-of select="$contact/S_N1/D_93"/>
                </xsl:element>
                <!-- PostalAddress -->
                <xsl:if
                    test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
                    <xsl:element name="PostalAddress">
                        <xsl:if test="$contact/S_REF[D_128 = 'ME']/D_352 != ''">
                            <xsl:attribute name="name">
                                <xsl:value-of select="$contact/S_REF[D_128 = 'ME']/D_352"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="$contact/S_N2">
                            <xsl:element name="DeliverTo">
                                <xsl:value-of select="D_93_1"/>
                            </xsl:element>
                            <xsl:if test="D_93_2 != ''">
                                <xsl:element name="DeliverTo">
                                    <xsl:value-of select="D_93_2"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="$contact/S_N3">
                            <xsl:element name="Street">
                                <xsl:value-of select="D_166_1"/>
                            </xsl:element>
                            <xsl:if test="D_166_2 != ''">
                                <xsl:element name="Street">
                                    <xsl:value-of select="D_166_2"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:element name="City">
                            <xsl:value-of select="$contact/S_N4/D_19"/>
                        </xsl:element>
                        <xsl:variable name="stateCode">
                            <xsl:choose>
                                <xsl:when
                                    test="$contact/S_N4/D_310 != '' and not(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA'))">
                                    <xsl:value-of select="$contact/S_N4/D_310"/>
                                </xsl:when>
                                <xsl:when test="$contact/S_N4/D_156 != ''">
                                    <xsl:value-of select="$contact/S_N4/D_156"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$stateCode != ''">
                            <xsl:element name="State">
                                <xsl:value-of select="$stateCode"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$contact/S_N4/D_116 != ''">
                            <xsl:element name="PostalCode">
                                <xsl:value-of select="$contact/S_N4/D_116"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:variable name="isoCountryCode">
                            <xsl:value-of select="$contact/S_N4/D_26"/>
                        </xsl:variable>
                        <xsl:element name="Country">
                            <xsl:attribute name="isoCountryCode">
                                <xsl:value-of select="$isoCountryCode"/>
                            </xsl:attribute>
                            <xsl:value-of
                                select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
                            />
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:variable name="contactList">
                    <xsl:apply-templates select="$contact/S_PER"/>
                </xsl:variable>
                <xsl:for-each select="$contactList/Con[@type = 'Email']">
                    <xsl:sort select="@name"/>
                    <xsl:element name="Email">
                        <xsl:attribute name="name">
                            <xsl:value-of select="./@name"/>
                        </xsl:attribute>
                        <xsl:value-of select="./@value"/>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="$contactList/Con[@type = 'Phone']">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="cCode" select="@cCode"/>
                    <xsl:element name="Phone">
                        <xsl:attribute name="name">
                            <xsl:value-of select="./@name"/>
                        </xsl:attribute>
                        <xsl:element name="TelephoneNumber">
                            <xsl:element name="CountryCode">
                                <xsl:attribute name="isoCountryCode">
                                    <xsl:choose>
                                        <xsl:when
                                            test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>US</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="replace(@cCode, '\+', '')"/>
                            </xsl:element>
                            <xsl:element name="AreaOrCityCode">
                                <xsl:value-of select="@aCode"/>
                            </xsl:element>
                            <xsl:element name="Number">
                                <xsl:value-of select="@num"/>
                            </xsl:element>
                            <xsl:if test="@ext != ''">
                                <xsl:element name="Extension">
                                    <xsl:value-of select="@ext"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="$contactList/Con[@type = 'Fax']">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="cCode" select="@cCode"/>
                    <xsl:element name="Fax">
                        <xsl:attribute name="name">
                            <xsl:value-of select="./@name"/>
                        </xsl:attribute>
                        <xsl:element name="TelephoneNumber">
                            <xsl:element name="CountryCode">
                                <xsl:attribute name="isoCountryCode">
                                    <xsl:choose>
                                        <xsl:when
                                            test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>US</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="replace(@cCode, '\+', '')"/>
                            </xsl:element>
                            <xsl:element name="AreaOrCityCode">
                                <xsl:value-of select="@aCode"/>
                            </xsl:element>
                            <xsl:element name="Number">
                                <xsl:value-of select="@num"/>
                            </xsl:element>
                            <xsl:if test="@ext != ''">
                                <xsl:element name="Extension">
                                    <xsl:value-of select="@ext"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="$contactList/Con[@type = 'URL']">
                    <xsl:sort select="@name"/>
                    <xsl:element name="URL">
                        <xsl:attribute name="name">
                            <xsl:value-of select="./@name"/>
                        </xsl:attribute>
                        <xsl:value-of select="./@value"/>
                    </xsl:element>
                </xsl:for-each>
                <!-- IG-39005 add ID reference start   -->
                <xsl:for-each select="S_REF">
                    <xsl:choose>
                        <xsl:when test="$role = 'RI' and D_128 = 'BAA'">
                            <xsl:element name="IdReference">
                                <xsl:attribute name="identifier">
                                    <xsl:value-of select="D_352"/>
                                </xsl:attribute>
                                <xsl:attribute name="domain">
                                    <xsl:text>SupplierTaxID</xsl:text>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="IDRefDomain" select="D_128"/>
                            <xsl:choose>
                                <xsl:when test="$IDRefDomain = 'ZZ' and D_127 != '' and D_352 != ''">
                                    <xsl:element name="IdReference">
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="D_352"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="domain">
                                            <xsl:value-of select="D_127"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
                                    <xsl:element name="IdReference">
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="D_352"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="domain">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
                                    <xsl:element name="IdReference">
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="D_352"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="domain">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"
                                            />
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- IG-39005 add ID reference end   -->                
            </xsl:element>
        </xsl:if>
    </xsl:template>    
    <xsl:template name="convertToAribaDatePORef">
        <xsl:param name="Date"/>
        <xsl:param name="Time"/>
        <xsl:param name="TimeCode"/>
        <xsl:variable name="timeZone">
            <xsl:choose>
                <xsl:when
                    test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
                    <xsl:value-of
                        select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
                    />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="tempDate">
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
                        select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$tempTime = ''">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($tempDate, $tempTime, $timeZone)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="createShipNoticeLine">
        <xsl:param name="HLItemLoopID"/>
        <xsl:param name="HLPackLoopID"/>
        <xsl:param name="HLTareLoopID"/>
        <xsl:param name="StructureType"/>
        <xsl:param name="CURHL_O"/>
        <xsl:param name="CURHL_S"/>
        <xsl:variable name="lin">
            <xsl:call-template name="createLIN">
                <xsl:with-param name="LIN" select="S_LIN"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:element name="ShipNoticeItem">
            <xsl:attribute name="quantity">
                <xsl:value-of select="S_SN1/D_382"/>
            </xsl:attribute>
            <xsl:attribute name="lineNumber">
                <xsl:choose>
                    <xsl:when test="S_SN1/D_350">
                        <xsl:value-of select="S_SN1/D_350"/>
                    </xsl:when>
                    <xsl:when test="$lin/lin/element[@name = 'PL']/@value != ''">
                        <xsl:value-of select="$lin/lin/element[@name = 'PL']/@value"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <!-- parentLineNumber -->
            <xsl:if test="S_REF[D_128 = 'FL']/D_127 != ''">
                <xsl:attribute name="parentLineNumber">
                    <xsl:value-of select="S_REF[D_128 = 'FL']/D_127"/>
                </xsl:attribute>
            </xsl:if>
            <!-- shipNoticeLineNumber -->
            <xsl:if test="S_LIN/D_350 != ''">
                <xsl:attribute name="shipNoticeLineNumber">
                    <xsl:value-of select="S_LIN/D_350"/>
                </xsl:attribute>
            </xsl:if>
            <!-- itemType -->
            <xsl:if test="S_REF[D_128 = 'FL']/D_352 != ''">
                <xsl:attribute name="itemType">
                    <xsl:choose>
                        <xsl:when test="S_REF[D_128 = 'FL']/D_352 = 'item'">item</xsl:when>
                        <xsl:when test="S_REF[D_128 = 'FL']/D_352 = 'composite'">composite</xsl:when>
                        <!-- 12512 -->
                        <xsl:when test="S_REF[D_128 = 'FL']/D_352 = 'lean'">lean</xsl:when>
                        <xsl:otherwise>composite</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:if
                    test="S_REF[D_128 = 'FL'][D_352 = 'composite']/C_C040[D_128_1 = 'FL']/D_127_1 = 'groupLevel' or S_REF[D_128 = 'FL'][D_352 = 'composite']/C_C040[D_128_1 = 'FL']/D_127_1 = 'itemLevel'">
                    <xsl:attribute name="compositeItemType">
                        <xsl:value-of
                            select="S_REF[D_128 = 'FL'][D_352 = 'composite']/C_C040[D_128_1 = 'FL']/D_127_1"
                        />
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <!-- ItemID -->
            <xsl:if
                test="$lin/lin/element[@name = 'VP' or @name = 'BP' or @name = 'VS' or @name = 'UP']/@value != ''">
                <xsl:element name="ItemID">
                    <xsl:element name="SupplierPartID">
                        <xsl:value-of select="$lin/lin/element[@name = 'VP']/@value"/>
                    </xsl:element>
                    <xsl:if test="$lin/lin/element[@name = 'VS']/@value != ''">
                        <xsl:element name="SupplierPartAuxiliaryID">
                            <xsl:value-of select="$lin/lin/element[@name = 'VS']/@value"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$lin/lin/element[@name = 'BP']/@value != ''">
                        <xsl:element name="BuyerPartID">
                            <xsl:value-of select="$lin/lin/element[@name = 'BP']/@value"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$lin/lin/element[@name = 'UP']/@value != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">
                                <xsl:text>UPCConsumerPackageCode</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="identifier">
                                <xsl:value-of select="$lin/lin/element[@name = 'UP']/@value"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$lin/lin/element[@name = 'EN']/@value != ''">
                        <xsl:element name="IdReference">
                            <xsl:attribute name="domain">
                                <xsl:text>EAN-13</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="identifier">
                                <xsl:value-of select="$lin/lin/element[@name = 'EN']/@value"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <!-- ShipNoticeItemDetail -->
            <xsl:if
                test="$lin/lin/element[@name = 'EN']/@value != '' or S_SLN[D_662_1 = 'O']/D_212 != '' or S_PID[D_349 = 'F'][D_750 = 'GEN']/D_352 != '' or S_SN1/D_355_2 != '' or $lin/lin/element[@name = 'MF']/@value != '' or $lin/lin/element[@name = 'MG']/@value != ''">
                <xsl:element name="ShipNoticeItemDetail">
                    <xsl:if test="S_SLN[D_662_1 = 'O']/D_212 != ''">
                        <xsl:element name="UnitPrice">
                            <xsl:element name="Money">
                                <xsl:attribute name="currency">
                                    <xsl:choose>
                                        <xsl:when test="S_CUR/D_100_1 != ''">
                                            <xsl:value-of select="S_CUR/D_100_1"/>
                                        </xsl:when>
                                        <xsl:when test="$CURHL_O != ''">
                                            <xsl:value-of select="$CURHL_O"/>
                                        </xsl:when>
                                        <xsl:when test="$CURHL_S != ''">
                                            <xsl:value-of select="$CURHL_S"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="S_SLN[D_662_1 = 'O']/D_212"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <!--IG1502 and IG3424 - Retaining second 'when' some code for backward compatibility when PID is sent with 'GEN'-->
                    <xsl:if test="S_PID[D_349 = 'F']/D_352 != ''">
                        <xsl:element name="Description">
                            <xsl:attribute name="xml:lang">
                                <xsl:choose>
                                    <xsl:when test="S_PID[D_349 = 'F']/D_819 != ''">
                                        <xsl:value-of select="(S_PID[D_349 = 'F']/D_819)[1]"/>
                                    </xsl:when>
                                    <xsl:otherwise>en</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when
                                    test="S_PID[D_349 = 'F'][D_750 = 'GEN']/D_352 != '' and S_PID[D_349 = 'F'][not(exists(D_750))]/D_352 != ''">
                                    <xsl:element name="ShortName">
                                        <xsl:value-of
                                            select="S_PID[D_349 = 'F'][D_750 = 'GEN']/D_352"/>
                                    </xsl:element>
                                    <xsl:value-of
                                        select="S_PID[D_349 = 'F'][not(exists(D_750))]/D_352"/>
                                </xsl:when>
                                <xsl:when
                                    test="S_PID[D_349 = 'F'][D_750 = 'GEN']/D_352 != '' and not(exists(S_PID[D_349 = 'F'][not(exists(D_750))]/D_352))">
                                    <xsl:element name="ShortName">
                                        <xsl:value-of
                                            select="S_PID[D_349 = 'F'][D_750 = 'GEN']/D_352"/>
                                    </xsl:element>
                                    <xsl:value-of select="S_PID[D_349 = 'F'][D_750 = 'GEN']/D_352"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="S_PID[D_349 = 'F']/D_352"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="S_SN1/D_355_2 != ''">
                        <xsl:variable name="uom" select="S_SN1/D_355_2"/>
                        <xsl:element name="UnitOfMeasure">
                            <xsl:choose>
                                <xsl:when
                                    test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                                    />
                                </xsl:when>
                                <xsl:otherwise>ZZ</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$lin/lin/element[@name = 'C3']/@value != ''">
                        <xsl:element name="Classification">
                            <xsl:attribute name="domain">
                                <xsl:value-of select="'UNSPSC'"/>
                            </xsl:attribute>
                            <xsl:value-of select="$lin/lin/element[@name = 'C3']/@value"/>
                        </xsl:element>
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

                    <xsl:for-each select="S_MEA[D_737 = 'PD']">
                        <xsl:variable name="dimensionType" select="D_738"/>
                        <xsl:if
                            test="D_739 != '' and $Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $dimensionType]/CXMLCode != ''">
                            <xsl:element name="Dimension">
                                <xsl:attribute name="type">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $dimensionType]/CXMLCode"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="D_739"/>
                                </xsl:attribute>
                                <xsl:variable name="uom" select="C_C001/D_355_1"/>
                                <xsl:element name="UnitOfMeasure">
                                    <xsl:choose>
                                        <xsl:when
                                            test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>ZZ</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    
                    <xsl:if test="$lin/lin/element[@name = 'EN']/@value != ''">
                        <xsl:element name="ItemDetailIndustry">
                            <xsl:element name="ItemDetailRetail">
                                <xsl:element name="EANID">
                                    <xsl:value-of select="$lin/lin/element[@name = 'EN']/@value"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <!-- UnitOfMeasure -->
            <xsl:if test="S_SN1/D_355_1 != ''">
                <xsl:variable name="uom" select="S_SN1/D_355_1"/>
                <xsl:element name="UnitOfMeasure">
                    <xsl:choose>
                        <xsl:when
                            test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                            <xsl:value-of
                                select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                            />
                        </xsl:when>
                        <xsl:otherwise>ZZ</xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <!-- Packaging -->
            <xsl:variable name="lineQuantity" select="S_SN1/D_382"/>
            <xsl:variable name="lineUOM" select="S_SN1/D_355_1"/>
            <xsl:choose>
                <xsl:when test="$StructureType = 'SOITP'">
                    <xsl:for-each
                        select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $HLItemLoopID and S_HL/D_735 = 'T']">
                        <xsl:variable name="TareID" select="S_HL/D_628"/>
                        <xsl:for-each
                            select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $TareID and S_HL/D_735 = 'P']">
                            <xsl:variable name="PackID" select="S_HL/D_628"/>
                            <xsl:call-template name="createPackaging">
                                <xsl:with-param name="HLTareLoopID" select="$TareID"/>
                                <xsl:with-param name="StructureType" select="$StructureType"/>
                            </xsl:call-template>
                        </xsl:for-each>
                        <xsl:call-template name="createPackaging"> </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each
                        select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $HLItemLoopID and S_HL/D_735 = 'P']">
                        <xsl:variable name="PackID" select="S_HL/D_628"/>
                        <xsl:call-template name="createPackaging">
                            <xsl:with-param name="StructureType" select="$StructureType"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$StructureType = 'SOTPI'">
                    <xsl:for-each
                        select="//FunctionalGroup/M_856/G_HL[S_HL/D_628 = $HLPackLoopID and S_HL/D_735 = 'P']">
                        <xsl:call-template name="createPackaging">
                            <xsl:with-param name="HLTareLoopID" select="$HLTareLoopID"/>
                            <xsl:with-param name="lineQuantity" select="$lineQuantity"/>
                            <xsl:with-param name="lineUOM" select="$lineUOM"/>
                            <xsl:with-param name="StructureType" select="$StructureType"/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each
                        select="//FunctionalGroup/M_856/G_HL[S_HL/D_628 = $HLTareLoopID and S_HL/D_735 = 'T']">
                        <xsl:call-template name="createPackaging"> </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="exists(S_PO4)">
                        <xsl:call-template name="createPackaging"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Hazard -->
            <!-- IG-5501 -->
            <xsl:for-each
                select="S_TD4[not(exists(D_152))][D_208 = 'I' or D_208 = 'U' or D_208 = '9'][D_209 != '']">
                <xsl:element name="Hazard">
                    <xsl:if test="D_352 != ''">
                        <xsl:element name="Description">
                            <xsl:attribute name="xml:lang">en-US</xsl:attribute>
                            <xsl:value-of select="D_352"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="Classification">
                        <xsl:attribute name="domain">
                            <xsl:choose>
                                <xsl:when test="D_208 = '9'">NAHG</xsl:when>
                                <xsl:when test="D_208 = 'I'">IMDG</xsl:when>
                                <xsl:when test="D_208 = 'U'">UNDG</xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="D_209"/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
            <!-- Batch Info -->
            <xsl:if
                test="$lin/lin/element[@name = 'B8']/@value != '' or $lin/lin/element[@name = 'LT']/@value != ''">
                <xsl:element name="Batch">
                    <xsl:if test="S_REF[D_128 = 'BT'][D_127 = 'productionDate']/D_352 != ''">
                        <xsl:attribute name="productionDate">
                            <xsl:call-template name="convertToAribaDate">
                                <xsl:with-param name="Date">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'productionDate']/D_352, 1, 8)"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="Time">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'productionDate']/D_352, 9, 6)"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="TimeCode">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'productionDate']/D_352, 15)"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_REF[D_128 = 'BT'][D_127 = 'expirationDate']/D_352 != ''">
                        <xsl:attribute name="expirationDate">
                            <xsl:call-template name="convertToAribaDate">
                                <xsl:with-param name="Date">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'expirationDate']/D_352, 1, 8)"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="Time">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'expirationDate']/D_352, 9, 6)"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="TimeCode">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'expirationDate']/D_352, 15)"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_REF[D_128 = 'BT'][D_127 = 'inspectionDate']/D_352 != ''">
                        <xsl:attribute name="inspectionDate">
                            <xsl:call-template name="convertToAribaDate">
                                <xsl:with-param name="Date">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'inspectionDate']/D_352, 1, 8)"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="Time">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'inspectionDate']/D_352, 9, 6)"
                                    />
                                </xsl:with-param>
                                <xsl:with-param name="TimeCode">
                                    <xsl:value-of
                                        select="substring(S_REF[D_128 = 'BT'][D_127 = 'inspectionDate']/D_352, 15)"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_REF[D_128 = 'BT'][D_127 = 'shelfLife']/D_352 != ''">
                        <xsl:attribute name="shelfLife">
                            <xsl:value-of select="S_REF[D_128 = 'BT'][D_127 = 'shelfLife']/D_352"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_REF[D_128 = 'BT'][D_127 = 'batchQuantity']/D_352 != ''">
                        <xsl:attribute name="batchQuantity">
                            <xsl:value-of
                                select="S_REF[D_128 = 'BT'][D_127 = 'batchQuantity']/D_352"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_REF[D_128 = 'BT'][D_127 = 'originCountryCode']/D_352 != ''">
                        <xsl:attribute name="originCountryCode">
                            <xsl:value-of
                                select="S_REF[D_128 = 'BT'][D_127 = 'originCountryCode']/D_352"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$lin/lin/element[@name = 'LT']/@value != ''">
                        <xsl:element name="BuyerBatchID">
                            <xsl:value-of select="$lin/lin/element[@name = 'LT']/@value"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="$lin/lin/element[@name = 'B8']/@value != ''">
                        <xsl:element name="SupplierBatchID">
                            <xsl:value-of select="$lin/lin/element[@name = 'B8']/@value"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <!-- SupplierBatchID -->
            <!--xsl:if test="$lin/lin/element[@name='B8']/@value!=''">											<xsl:element name="SupplierBatchID">												<xsl:value-of select="$lin/lin/element[@name='B8']/@value"/>											</xsl:element>											</xsl:if-->
            <!-- AssetInfo -->
            <xsl:if test="$lin/lin/element[@name = 'SN']/@value != ''">
                <xsl:element name="AssetInfo">
                    <xsl:attribute name="serialNumber">
                        <xsl:value-of select="$lin/lin/element[@name = 'SN']/@value"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:for-each
                select="S_MAN[D_88_1 = 'L' and (D_87_1 = 'SN' or D_87_1 = 'AT') and D_87_2 != '']">
                <xsl:element name="AssetInfo">
                    <xsl:if test="D_87_1 = 'AT'">
                        <xsl:attribute name="tagNumber">
                            <xsl:value-of select="D_87_2"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="D_87_1 = 'SN'">
                        <xsl:attribute name="serialNumber">
                            <xsl:value-of select="D_87_2"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="D_88_2 = 'L'">
                        <xsl:if test="D_87_3 = 'AT'">
                            <xsl:attribute name="tagNumber">
                                <xsl:value-of select="D_87_4"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="D_87_3 = 'SN'">
                            <xsl:attribute name="serialNumber">
                                <xsl:value-of select="D_87_4"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="S_GIR[D_7297 = '1']//D_7402[../D_7405 = 'BN'] != ''">
                        <xsl:attribute name="serialNumber">
                            <xsl:value-of select="S_GIR[D_7297 = '1']//D_7402[../D_7405 = 'BN']"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:element>
            </xsl:for-each>
            <!-- OrderedQuantity -->
            <xsl:if test="S_SN1/D_330 != '' or S_SN1/D_355_2 != ''">
                <xsl:element name="OrderedQuantity">
                    <xsl:if test="S_SN1/D_330 != ''">
                        <xsl:attribute name="quantity">
                            <xsl:value-of select="S_SN1/D_330"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_SN1/D_355_2 != ''">
                        <xsl:variable name="uom" select="S_SN1/D_355_2"/>
                        <xsl:element name="UnitOfMeasure">
                            <xsl:choose>
                                <xsl:when
                                    test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                                    />
                                </xsl:when>
                                <xsl:otherwise>ZZ</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <!-- ShipNoticeItemIndustry -->
            <xsl:if
                test="S_DTM[D_374 = '036' or D_374 = '511']/D_373 != '' or S_REF[D_128 = 'PD']/D_352 != ''">
                <xsl:element name="ShipNoticeItemIndustry">
                    <xsl:element name="ShipNoticeItemRetail">
                        <xsl:if test="S_DTM[D_374 = '511']/D_373 != ''">
                            <xsl:element name="BestBeforeDate">
                                <xsl:attribute name="date">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of select="S_DTM[D_374 = '511']/D_373"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of select="S_DTM[D_374 = '511']/D_337"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of select="S_DTM[D_374 = '511']/D_623"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="S_DTM[D_374 = '036']/D_373 != ''">
                            <xsl:element name="ExpiryDate">
                                <xsl:attribute name="date">
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of select="S_DTM[D_374 = '036']/D_373"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                            <xsl:value-of select="S_DTM[D_374 = '036']/D_337"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                            <xsl:value-of select="S_DTM[D_374 = '036']/D_623"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="S_REF[D_128 = 'PD']/D_352 != ''">
                            <xsl:element name="PromotionDealID">
                                <xsl:value-of select="S_REF[D_128 = 'PD']/D_352"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <!-- ComponentConsumptionDetails -->
            <xsl:for-each
                select="//FunctionalGroup/M_856/G_HL[S_HL/D_734 = $HLItemLoopID and S_HL/D_735 = 'F' and S_HL/D_736 = '0']">
                <xsl:if test="S_SN1/D_382 != '' and S_SN1/D_355_1 != ''">
                    <xsl:variable name="uom" select="S_SN1/D_355_1"/>
                    <xsl:variable name="componentlin">
                        <xsl:call-template name="createLIN">
                            <xsl:with-param name="LIN" select="S_LIN"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:element name="ComponentConsumptionDetails">
                        <xsl:attribute name="quantity">
                            <xsl:value-of select="S_SN1/D_382"/>
                        </xsl:attribute>
                        <xsl:if test="S_LIN/D_350 != ''">
                            <xsl:attribute name="lineNumber">
                                <xsl:value-of select="S_LIN/D_350"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:element name="Product">
                            <xsl:if test="$componentlin/lin/element[@name = 'VP']/@value != ''">
                                <xsl:element name="SupplierPartID">
                                    <xsl:value-of
                                        select="$componentlin/lin/element[@name = 'VP']/@value"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$componentlin/lin/element[@name = 'VS']/@value != ''">
                                    <xsl:element name="SupplierPartAuxiliaryID">
                                        <xsl:value-of
                                            select="$componentlin/lin/element[@name = 'VS']/@value"
                                        />
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="$componentlin/lin/element[@name = 'BP']/@value != ''">
                                    <xsl:element name="BuyerPartID">
                                        <xsl:value-of
                                            select="$componentlin/lin/element[@name = 'BP']/@value"
                                        />
                                    </xsl:element>
                                </xsl:if>                            
                        </xsl:element>
                        <xsl:element name="UnitOfMeasure">
                            <xsl:choose>
                                <xsl:when
                                    test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of
                                        select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode)"
                                    />
                                </xsl:when>
                                <xsl:otherwise>ZZ</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:if test="$componentlin/lin/element[@name = 'LT']/@value != ''">
                            <xsl:element name="BuyerBatchID">
                                <xsl:value-of
                                    select="$componentlin/lin/element[@name = 'LT']/@value"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$componentlin/lin/element[@name = 'B8']/@value != ''">
                            <xsl:element name="SupplierBatchID">
                                <xsl:value-of
                                    select="$componentlin/lin/element[@name = 'B8']/@value"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$componentlin/lin/element[@name = 'SN']/@value != ''">
                            <xsl:element name="AssetInfo">
                                <xsl:attribute name="serialNumber">
                                    <xsl:value-of
                                        select="$componentlin/lin/element[@name = 'SN']/@value"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:for-each
                            select="S_MAN[D_88_1 = 'L' and (D_87_1 = 'SN' or D_87_1 = 'AT') and D_87_2 != '']">
                            <xsl:element name="AssetInfo">
                                <xsl:if test="D_87_1 = 'AT'">
                                    <xsl:attribute name="tagNumber">
                                        <xsl:value-of select="D_87_2"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="D_87_1 = 'SN'">
                                    <xsl:attribute name="serialNumber">
                                        <xsl:value-of select="D_87_2"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="D_88_2 = 'L'">
                                    <xsl:if test="D_87_3 = 'AT'">
                                        <xsl:attribute name="tagNumber">
                                            <xsl:value-of select="D_87_4"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="D_87_3 = 'SN'">
                                        <xsl:attribute name="serialNumber">
                                            <xsl:value-of select="D_87_4"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <!-- 12512 -->
            <xsl:for-each
                select="S_REF[D_128 = '0L' and D_127!='' and D_352!='']">
                <xsl:element name="ReferenceDocumentInfo">
                    <xsl:element name="DocumentInfo">
                        <xsl:attribute name="documentID"> 
                            <xsl:value-of select="D_127"/>
                        </xsl:attribute>
                        <xsl:attribute name="documentType">
                            <xsl:value-of select="D_352"/>
                        </xsl:attribute>
                        <xsl:if test="normalize-space(C_C040/D_127_1)!='' and normalize-space(C_C040/D_128)!='0L'">
                            <xsl:attribute name="documentDate">
                                <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="Date">
                                        <xsl:value-of select="substring(C_C040/D_127_1,1,8)"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="Time">
                                        <xsl:value-of select="substring(C_C040/D_127_1,9,6)"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="TimeCode">
                                        <xsl:value-of select="substring(C_C040/D_127_1,15,2)"/>                                                    
                                    </xsl:with-param>                                                 
                                </xsl:call-template>                                            
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>                                
            </xsl:for-each>               
            <xsl:if test="$lin/lin/element[@name = 'HD']/@value != ''">
                <xsl:element name="Extrinsic">
                    <xsl:attribute name="name" select="'HarmonizedSystemID'"/>
                    <xsl:value-of select="$lin/lin/element[@name = 'HD']/@value"/>
                </xsl:element>
            </xsl:if>

            <xsl:if test="$lin/lin/element[@name = 'BP']/@value != ''">
                <xsl:element name="Extrinsic">
                    <xsl:attribute name="name" select="'customersPartNo'"/>
                    <xsl:value-of select="$lin/lin/element[@name = 'BP']/@value"/>
                </xsl:element>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$lin/lin/element[@name = 'UP']/@value != ''">
                    <xsl:element name="Extrinsic">
                        <xsl:attribute name="name" select="'customersBarCodeNumber'"/>
                        <xsl:value-of select="$lin/lin/element[@name = 'UP']/@value"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$lin/lin/element[@name = 'UPC']/@value != ''">
                    <xsl:element name="Extrinsic">
                        <xsl:attribute name="name" select="'customersBarCodeNumber'"/>
                        <xsl:value-of select="$lin/lin/element[@name = 'UPC']/@value"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
            <xsl:for-each select="S_REF[D_128 = 'ZZ']">
                <xsl:element name="Extrinsic">
                    <xsl:attribute name="name">
                        <xsl:value-of select="D_127"/>
                    </xsl:attribute>
                    <xsl:value-of select="D_352"/>
                </xsl:element>
            </xsl:for-each>
            <!-- CG: IG-16765 - 1500 Extrinsics -->
            <xsl:if test="$useExtrinsicsLookup = 'yes'">
                <xsl:for-each select="S_REF[D_128 != 'ZZ']">
                    <xsl:variable name="refQualVal" select="D_128"/>
                    <xsl:variable name="extNameL" select="$Lookup/Lookups/Extrinsics/Extrinsic[X12Code=$refQualVal][not(exists(ExcludeDocType/ShipLineEx))][1]/CXMLCode"/>
                    <xsl:if test="$extNameL != ''">
                        <xsl:element name="Extrinsic">
                            <xsl:attribute name="name">
                                <xsl:value-of select="$extNameL"/>
                            </xsl:attribute>
                            <xsl:value-of select="concat(D_127,D_352)"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="createPackaging">
        <xsl:param name="HLTareLoopID"/>
        <xsl:param name="lineQuantity"/>
        <xsl:param name="lineUOM"/>
        <xsl:param name="StructureType"/>
        <xsl:element name="Packaging">
            <xsl:if test="S_PO4/D_103 != ''">
                <xsl:variable name="packCode" select="S_PO4/D_103"/>
                <xsl:element name="PackagingCode">
                    <xsl:attribute name="xml:lang" select="'en'"/>
                    <xsl:choose>
                        <xsl:when
                            test="$Lookup/Lookups/PackagingCodes/PackagingCode[X12Code = $packCode]/CXMLCode != ''">
                            <xsl:value-of
                                select="$Lookup/Lookups/PackagingCodes/PackagingCode[X12Code = $packCode]/CXMLCode"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="S_PO4/D_103"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>
            <xsl:variable name="uomGlobal">
                <xsl:if test="S_PO4/D_355_4 != ''">
                    <xsl:variable name="uom" select="S_PO4/D_355_4"/>
                    <xsl:choose>
                        <xsl:when
                            test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                            <xsl:value-of
                                select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                            />
                        </xsl:when>
                        <xsl:otherwise>ZZ</xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:variable>
            <!-- 12512 -->  
            <xsl:if
                test="exists(S_MEA[D_738 != 'HT' and D_738 != 'LN' and D_738 != 'VOL' and D_738 != 'WD' and D_738 != 'WT' and D_737 = 'PD' and D_739 != ''])">
                <xsl:for-each select="S_MEA[D_738 != 'HT' and D_738 != 'LN' and D_738 != 'VOL' and D_738 != 'WD' and D_738 != 'WT' and D_737 = 'PD' and D_739 != '']">
                <xsl:variable name="meaType" select="D_738"/>                                        
                <xsl:variable name="uom" select="C_C001/D_355_1"/>                                        
                <xsl:element name="Dimension">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="D_739"/>
                    </xsl:attribute>
                    <xsl:if test="$Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $meaType]/CXMLCode != ''">
                        <xsl:attribute name="type"><xsl:value-of select="normalize-space($Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $meaType]/CXMLCode)"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                        <xsl:element name="UnitOfMeasure">
                            <xsl:value-of
                                select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode)"
                            />
                        </xsl:element>
                    </xsl:if>                                            
                </xsl:element>
            </xsl:for-each>
            </xsl:if>
            <xsl:if test="S_PO4/D_384 != ''">
                <xsl:element name="Dimension">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="S_PO4/D_384"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">weight</xsl:attribute>
                    <xsl:if test="S_PO4/D_355_2 != ''">
                        <xsl:variable name="uom" select="S_PO4/D_355_2"/>
                        <xsl:element name="UnitOfMeasure">
                            <xsl:choose>
                                <xsl:when
                                    test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                                    />
                                </xsl:when>
                                <xsl:otherwise>ZZ</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <xsl:if test="S_PO4/D_385 != ''">
                <xsl:element name="Dimension">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="S_PO4/D_385"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">volume</xsl:attribute>
                    <xsl:if test="S_PO4/D_355_3 != ''">
                        <xsl:variable name="uom" select="S_PO4/D_355_3"/>
                        <xsl:element name="UnitOfMeasure">
                            <xsl:choose>
                                <xsl:when
                                    test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of
                                        select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                                    />
                                </xsl:when>
                                <xsl:otherwise>ZZ</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
            <xsl:if test="S_PO4/D_82 != ''">
                <xsl:element name="Dimension">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="S_PO4/D_82"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">length</xsl:attribute>
                    <xsl:element name="UnitOfMeasure">
                        <xsl:value-of select="$uomGlobal"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="S_PO4/D_189 != ''">
                <xsl:element name="Dimension">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="S_PO4/D_189"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">width</xsl:attribute>
                    <xsl:element name="UnitOfMeasure">
                        <xsl:value-of select="$uomGlobal"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="S_PO4/D_65 != ''">
                <xsl:element name="Dimension">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="S_PO4/D_65"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">height</xsl:attribute>
                    <xsl:element name="UnitOfMeasure">
                        <xsl:value-of select="$uomGlobal"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="S_HL/D_735 = 'T' or S_HL/D_735 = 'P'">
                <xsl:choose>
                    <xsl:when test="S_HL/D_735 = 'T'">
                        <Description type="Package" xml:lang="en"/>
                        <PackagingLevelCode>0001</PackagingLevelCode>
                    </xsl:when>
                    <xsl:when test="S_HL/D_735 = 'P' and $HLTareLoopID">
                        <Description type="Material" xml:lang="en"/>
                        <PackagingLevelCode>0002</PackagingLevelCode>
                    </xsl:when>
                    <xsl:when test="S_HL/D_735 = 'P'">
                        <Description type="Material" xml:lang="en"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="S_PO4/D_103 != ''">
                    <PackageTypeCodeIdentifierCode>
                        <xsl:value-of select="S_PO4/D_103"/>
                    </PackageTypeCodeIdentifierCode>
                </xsl:if>
                <xsl:if test="S_MAN[D_88_1 = 'GM']/D_87_1 != ''">
                    <ShippingContainerSerialCode>
                        <xsl:value-of select="S_MAN[D_88_1 = 'GM']/D_87_1"/>
                    </ShippingContainerSerialCode>
                </xsl:if>
                <xsl:if
                    test="//FunctionalGroup/M_856/G_HL[S_HL/D_628 = $HLTareLoopID and S_HL/D_735 = 'T']/S_MAN[D_88_1 = 'GM']/D_87_1 != ''">
                    <ShippingContainerSerialCodeReference>
                        <xsl:value-of
                            select="//FunctionalGroup/M_856/G_HL[S_HL/D_628 = $HLTareLoopID and S_HL/D_735 = 'T']/S_MAN[D_88_1 = 'GM']/D_87_1"
                        />
                    </ShippingContainerSerialCodeReference>
                </xsl:if>
                <xsl:if
                    test="(S_MAN[D_88_1 = 'ZZ'][D_87_1 = 'GIAI']/D_87_2 != '') or (S_MAN[D_88_1 = 'CA']/D_87_1 != '')">
                    <PackageID>
                        <xsl:if test="(S_MAN[D_88_1 = 'ZZ'][D_87_1 = 'GIAI']/D_87_2 != '')">
                            <GlobalIndividualAssetID>
                                <xsl:value-of select="S_MAN[D_88_1 = 'ZZ'][D_87_1 = 'GIAI']/D_87_2"
                                />
                            </GlobalIndividualAssetID>
                        </xsl:if>
                        <xsl:if test="(S_MAN[D_88_1 = 'CA']/D_87_1 != '')">
                            <PackageTrackingID>
                                <xsl:value-of select="S_MAN[D_88_1 = 'CA']/D_87_1"/>
                            </PackageTrackingID>
                        </xsl:if>
                    </PackageID>
                </xsl:if>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="S_HL/D_735 = 'P'">
                    <xsl:element name="DispatchQuantity">
                        <xsl:attribute name="quantity">
                            <xsl:choose>
                                <xsl:when test="$StructureType = 'SOTPI'">
                                    <xsl:value-of select="$lineQuantity"/>
                                </xsl:when>
                                <!--IG7717-->
                                <xsl:when test="$StructureType = 'SOITP'">
                                    <xsl:value-of select="S_PO4/D_356 * S_PO4/D_357"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$lineUOM != '' and $StructureType = 'SOTPI'">
                                <xsl:element name="UnitOfMeasure">
                                    <xsl:choose>
                                        <xsl:when
                                            test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $lineUOM]/CXMLCode != ''">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $lineUOM][1]/CXMLCode"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>ZZ</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="S_PO4/D_355_1 != '' and $StructureType = 'SOITP'">
                                <xsl:variable name="uom" select="S_PO4/D_355_1"/>
                                <xsl:element name="UnitOfMeasure">
                                    <xsl:choose>
                                        <xsl:when
                                            test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                            <xsl:value-of
                                                select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>ZZ</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="S_HL/D_735 = 'T'"/>
                <xsl:when test="S_PO4/D_356 != '' and S_PO4/D_357 != ''">
                    <xsl:element name="DispatchQuantity">
                        <xsl:attribute name="quantity">
                            <xsl:value-of select="S_PO4/D_356 * S_PO4/D_357"/>
                        </xsl:attribute>
                        <xsl:if test="S_PO4/D_355_1 != ''">
                            <xsl:variable name="uom" select="S_PO4/D_355_1"/>
                            <xsl:element name="UnitOfMeasure">
                                <xsl:choose>
                                    <xsl:when
                                        test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                        <xsl:value-of
                                            select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>ZZ</xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="S_REF[D_128 = 'WS']/D_352 != ''">
                <xsl:element name="StoreCode">
                    <xsl:value-of select="S_REF[D_128 = 'WS']/D_352"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
