<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ns0="urn:sap.com:ica:typesystem:116:asc_x12:004010" exclude-result-prefixes="#all"
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

    <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>
    <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
    <!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
    <xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>-->

    <xsl:variable name="todValues"
        select="tokenize('PriceCondition,DespatchCondition,PriceandDespatchCondition,CollectedByCustomer,TransportCondition,DeliveryCondition', ',')"/>
    <xsl:variable name="spmValues"
        select="tokenize('Account,CashOnDeliveryServiceChargePaidByConsignee,CashOnDeliveryServiceChargePaidByConsignor,InformationCopy-NoPaymentDue,InsuranceCostsPaidByConsignee,InsuranceCostsPaidByConsignor,NotSpecified,PayableElsewhere', ',')"/>
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
                        <xsl:value-of select="substring(replace(replace(string(current-dateTime()), '-', ''), ':', ''), 10, 6)"/>
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
                    
                    <xsl:if test="FunctionalGroup/M_945/S_N9[D_128 = '06']/D_127!=''">                    
                    <xsl:element name="Credential">
                        <xsl:attribute name="domain">SystemID</xsl:attribute>
                        <xsl:element name="Identity">
                            <xsl:value-of select="FunctionalGroup/M_945/S_N9[D_128 = '06']/D_127"/>
                        </xsl:element>
                    </xsl:element>
                    </xsl:if>
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
                            <xsl:value-of select="FunctionalGroup/M_945/S_W06/D_145"/>
                        </xsl:attribute>
                        <!-- operation -->
                        <xsl:attribute name="operation">
                            <xsl:choose>
                                <xsl:when test="FunctionalGroup/M_945/S_W06/D_306 = '3'">delete</xsl:when>
                                <xsl:when test="FunctionalGroup/M_856/S_BSN/D_306 = '2'">update</xsl:when>
                                <xsl:when test="FunctionalGroup/M_856/S_BSN/D_306 = '17'">new</xsl:when>
                                <xsl:otherwise>new</xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>                        
                        <xsl:attribute name="activityStepType">stockShippingAdvice</xsl:attribute>
                        <xsl:attribute name="noticeDate">
                            <xsl:choose>
                                <xsl:when test="FunctionalGroup/M_945/S_G62[D_432 = '85']">
                                    <xsl:attribute name="shipmentDate">
                                        <xsl:call-template name="convertToAribaDate">
                                            <xsl:with-param name="Date">
                                                <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '85']/D_373"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="Time">
                                                <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '85']/D_337"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="TimeCode">
                                                <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '85']/D_623"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                            <xsl:value-of select="FunctionalGroup/M_945/S_W06/D_373"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <!-- shipmentDate -->
                        <xsl:if test="FunctionalGroup/M_945/S_G62[D_432 = '11']">
                            <xsl:attribute name="shipmentDate">
                                <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="Date">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '11']/D_373"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="Time">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '11']/D_337"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="TimeCode">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '11']/D_623"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <!-- deliveryDate -->
                        <xsl:if test="FunctionalGroup/M_945/S_G62[D_432 = '02'] != ''">
                            <xsl:attribute name="deliveryDate">
                                <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="Date">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '02']/D_373"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="Time">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '02']/D_337"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="TimeCode">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_G62[D_432 = '02']/D_623"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <!-- Contact -->
                        <xsl:for-each select="FunctionalGroup/M_945/G_0100">
                            <xsl:call-template name="createContact">
                                <xsl:with-param name="contact" select="."/>
                            </xsl:call-template>
                        </xsl:for-each>
                        <!-- TOD -->
                        <xsl:variable name="shippingPayment"
                            select="FunctionalGroup/M_945/S_W27[D_91 = 'ZZ']/D_146"/>
                        <xsl:if
                            test="(FunctionalGroup/M_945/S_N9[D_128 = '0L']/D_369 != '') or ($Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[X12Code = $shippingPayment]/CXMLCode != '')">
                            <TermsOfDelivery>
                                <TermsOfDeliveryCode value="Other"/>
                                <xsl:if
                                    test="($Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[X12Code = $shippingPayment]/CXMLCode != '')">
                                    <ShippingPaymentMethod>
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[X12Code = $shippingPayment]/CXMLCode"/>
                                        </xsl:attribute>
                                    </ShippingPaymentMethod>
                                </xsl:if>
                                <xsl:if test="FunctionalGroup/M_945/S_N9[D_128 = '0L']/D_369 != ''">
                                    <Comments type="Transport">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_N9[D_128 = '0L']/D_369"/>
                                    </Comments>
                                </xsl:if>
                            </TermsOfDelivery>
                        </xsl:if>
                        <!-- Extrinsics -->
                        <xsl:if test="FunctionalGroup/M_945/S_W10/D_406">
                            <Extrinsic name="totalOfPackages">
                                <xsl:value-of select="FunctionalGroup/M_945/S_W10/D_406"/>
                            </Extrinsic>
                        </xsl:if>
                        <xsl:for-each select="FunctionalGroup/M_945/S_N9[D_128 = 'ZZ'][D_127 != '']">
                            <Extrinsic>
                                <xsl:attribute name="name">
                                    <xsl:value-of select="D_127"/>
                                </xsl:attribute>
                                <xsl:value-of select="D_369"/>
                            </Extrinsic>
                        </xsl:for-each>
                    </xsl:element>
                    <!-- ShipNoticePortion -->
                    <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_945/S_N9[D_128 = 'PO']">
                            <xsl:element name="ShipNoticePortion">
                                <xsl:element name="OrderReference">
                                    <xsl:attribute name="orderID">
                                        <xsl:value-of select="FunctionalGroup/M_945/S_N9[D_128 = 'PO']/D_369"/>
                                    </xsl:attribute>
                                    <xsl:variable name="chkOrderDate">
                                        <xsl:if test="FunctionalGroup/M_945/S_N9[D_128 = 'PO']/D_373 != ''">
                                            <xsl:call-template name="convertToAribaDatePORef">
                                                <xsl:with-param name="Date">
                                                  <xsl:value-of select="FunctionalGroup/M_945/S_N9[D_128 = 'PO']/D_373"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="Time">
                                                  <xsl:value-of select="FunctionalGroup/M_945/S_N9[D_128 = 'PO']/D_337"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="TimeCode">
                                                  <xsl:value-of select="FunctionalGroup/M_945/S_N9[D_128 = 'PO']/D_623"/>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
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
                                <xsl:for-each select="FunctionalGroup/M_945/G_0300/G_0310">
                                    <xsl:call-template name="createShipNoticeLine">
                                   </xsl:call-template>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each-group select="FunctionalGroup/M_945/G_0300/G_0310"
                                group-by="S_N9[D_128 = 'PO']/D_369">
                                <xsl:element name="ShipNoticePortion">
                                    <xsl:element name="OrderReference">
                                        <xsl:attribute name="orderID">
                                            <xsl:value-of select="current-grouping-key()"/>
                                        </xsl:attribute>
                                        <xsl:variable name="chkOrderDate">
                                            <xsl:if test="./S_N9[D_128 = 'PO']/D_373 != ''">
                                                <xsl:call-template name="convertToAribaDatePORef">
                                                  <xsl:with-param name="Date">
                                                  <xsl:value-of select="./S_N9[D_128 = 'PO']/D_373"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="Time">
                                                  <xsl:value-of select="./S_N9[D_128 = 'PO']/D_337"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="TimeCode">
                                                  <xsl:value-of select="./S_N9[D_128 = 'PO']/D_623"/>
                                                  </xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:if>
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
                                    <xsl:for-each select="current-group()">
                                        <xsl:call-template name="createShipNoticeLine">
                                   </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each-group>
                        </xsl:otherwise>
                    </xsl:choose>
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
                            <xsl:value-of select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"/>
                        </xsl:attribute>
                    </element>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="$LIN/D_438 != ''">
                <element>
                    <xsl:attribute name="name">
                        <xsl:value-of select="'UP'"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$LIN/D_438"/>
                    </xsl:attribute>
                </element>
            </xsl:if>
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
            <xsl:when test="D_365 = 'EM'">
                <Con>
                    <xsl:attribute name="type">Email</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365 = 'UR'">
                <Con>
                    <xsl:attribute name="type">URL</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365 = 'TE'">
                <Con>
                    <xsl:attribute name="type">Phone</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364, '(')">
                                <xsl:value-of select="substring-before(D_364, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, '-')">
                                <xsl:value-of select="substring-before(D_364, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364, 'x')">
                                <xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, 'X')">
                                <xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365 = 'FX'">
                <Con>
                    <xsl:attribute name="type">Fax</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364, '(')">
                                <xsl:value-of select="substring-before(D_364, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, '-')">
                                <xsl:value-of select="substring-before(D_364, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364, 'x')">
                                <xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, 'X')">
                                <xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364, 'x')"/>
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
                        <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, 'x')">
                                <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, 'X')">
                                <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
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
                        <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, 'x')">
                                <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, 'X')">
                                <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
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
                        <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, 'x')">
                                <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, 'X')">
                                <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
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
                        <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, 'x')">
                                <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, 'X')">
                                <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
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
                            <xsl:value-of select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"/>
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
                            <xsl:when test="$contact/S_N4/D_310 != '' and not(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA'))">
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
                        <xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
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
                                    <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                        <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
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
                                    <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                        <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
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
            <xsl:value-of select="$contact/S_N1/D_98"/>
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
                                <xsl:value-of select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"/>
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
                                <xsl:when test="$contact/S_N4/D_310 != '' and not(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA'))">
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
                            <xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
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
                                        <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                            <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
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
                                        <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                            <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
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
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="convertToAribaDatePORef">
        <xsl:param name="Date"/>
        <xsl:param name="Time"/>
        <xsl:param name="TimeCode"/>
        <xsl:variable name="timeZone">
            <xsl:choose>
                <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
                    <xsl:value-of select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="tempDate">
            <xsl:value-of select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"/>
        </xsl:variable>
        <xsl:variable name="tempTime">
            <xsl:choose>
                <xsl:when test="$Time != '' and string-length($Time) = 6">
                    <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"/>
                </xsl:when>
                <xsl:when test="$Time != '' and string-length($Time) = 4">
                    <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2))"/>
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
        <xsl:variable name="lin">
            <xsl:call-template name="createLIN">
                <xsl:with-param name="LIN" select="S_W12"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="qty" select="./S_W12/D_382"/>
        <xsl:element name="ShipNoticeItem">
            <xsl:attribute name="quantity">
                <xsl:value-of select="$qty"/>
            </xsl:attribute>
            <xsl:attribute name="lineNumber">
                <xsl:value-of select="./S_N9[D_128 = 'LI']/D_127"/>
            </xsl:attribute>
            <xsl:attribute name="shipNoticeLineNumber">
                <xsl:value-of select="position()"/>
            </xsl:attribute>
            <xsl:if test="./S_N9[D_128 = '8X']">
                <xsl:if test="./S_N9[D_128 = '8X']/D_127 != ''">
                    <xsl:attribute name="outboundType" select="./S_N9[D_128 = '8X']/D_127"/>
                </xsl:if>
                <xsl:if test="./S_N9[D_128 = '8X']/D_369 != ''">
                    <xsl:attribute name="stockTransferType" select="./S_N9[D_128 = '8X']/D_369"/>
                </xsl:if>
            </xsl:if>
            <!-- ItemID -->
            <xsl:if
                test="$lin/lin/element[@name = 'VP' or @name = 'BP' or @name = 'EN']/@value != ''">
                <xsl:element name="ItemID">
                    <xsl:element name="SupplierPartID">
                        <xsl:value-of select="$lin/lin/element[@name = 'VP']/@value"/>
                    </xsl:element>
                    <xsl:if test="$lin/lin/element[@name = 'BP']/@value != ''">
                        <xsl:element name="BuyerPartID">
                            <xsl:value-of select="$lin/lin/element[@name = 'BP']/@value"/>
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
                </xsl:element>
            </xsl:if>
            <!-- ShipNoticeItemDetail -->
            <xsl:if
                test="$lin/lin/element[@name = 'EN']/@value != '' or S_G69/D_369 != '' or S_MEA[D_737 = 'PD'] ">
                <xsl:element name="ShipNoticeItemDetail">
                    <xsl:if test="S_G69/D_369 != ''">
                        <xsl:element name="Description">
                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                            <xsl:value-of select="S_G69/D_369"/>
                        </xsl:element>
                    </xsl:if>

                    <xsl:for-each select="S_MEA[D_737 = 'PD']">
                        <xsl:variable name="dimensionType" select="D_738"/>
                        <xsl:if test="D_739 != '' and $Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $dimensionType]/CXMLCode != ''">
                            <xsl:element name="Dimension">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="$Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $dimensionType]/CXMLCode"/>
                                </xsl:attribute>
                                <xsl:attribute name="quantity">
                                    <xsl:value-of select="D_739"/>
                                </xsl:attribute>
                                <xsl:variable name="uom" select="C_C001/D_355"/>
                                <xsl:element name="UnitOfMeasure">
                                    <xsl:choose>
                                        <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                            <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
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
            <xsl:if test="S_W12/D_355 != ''">
                <xsl:variable name="uom" select="S_W12/D_355"/>
                <xsl:element name="UnitOfMeasure">
                    <xsl:choose>
                        <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
                                </xsl:when>
                        <xsl:otherwise>ZZ</xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:if>

             <xsl:variable name="lineQuantity" select="$qty"/>
            <xsl:if test="../S_N9[D_128 = '97']/D_127 != '' or exists(../S_PAL)">
                <Packaging>
                    <xsl:if test="../S_N9[D_128 = '97']/D_127 != ''">
                        <PackagingCode xml:lang="en">
                            <xsl:value-of select="../S_N9[D_128 = '97']/D_127"/>
                        </PackagingCode>
                    </xsl:if>
                    <xsl:if test="../S_PAL">
                        <xsl:if test="../S_PAL/D_395 != ''">
                            <Dimension type="unitNetWeight">
                                <xsl:attribute name="quantity" select="../S_PAL/D_395"/>
                                <UnitOfMeasure>
                                    <xsl:value-of select="../S_PAL/D_355"/>
                                </UnitOfMeasure>
                            </Dimension>
                        </xsl:if>
                        <xsl:if test="../S_PAL/D_82 != ''">
                            <Dimension type="length">
                                <xsl:attribute name="quantity" select="../S_PAL/D_82"/>
                                <UnitOfMeasure>
                                    <xsl:value-of select="../S_PAL/D_355_2"/>
                                </UnitOfMeasure>
                            </Dimension>
                        </xsl:if>
                        <xsl:if test="../S_PAL/D_189 != ''">
                            <Dimension type="width">
                                <xsl:attribute name="quantity" select="../S_PAL/D_189"/>
                                <UnitOfMeasure>
                                    <xsl:value-of select="../S_PAL/D_355_2"/>
                                </UnitOfMeasure>
                            </Dimension>
                        </xsl:if>
                        <xsl:if test="../S_PAL/D_65 != ''">
                            <Dimension type="height">
                                <xsl:attribute name="quantity" select="../S_PAL/D_65"/>
                                <UnitOfMeasure>
                                    <xsl:value-of select="../S_PAL/D_355_2"/>
                                </UnitOfMeasure>
                            </Dimension>
                        </xsl:if>
                        <xsl:if test="../S_PAL/D_384 != ''">
                            <Dimension type="grossWeight">
                                <xsl:attribute name="quantity" select="../S_PAL/D_384"/>
                                <UnitOfMeasure>
                                    <xsl:value-of select="../S_PAL/D_355_3"/>
                                </UnitOfMeasure>
                            </Dimension>
                        </xsl:if>
                        <xsl:if test="../S_PAL/D_385 != ''">
                            <Dimension type="volume">
                                <xsl:attribute name="quantity" select="../S_PAL/D_385"/>
                                <UnitOfMeasure>
                                    <xsl:value-of select="../S_PAL/D_355_4"/>
                                </UnitOfMeasure>
                            </Dimension>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="../S_N9[D_128 = '97']/D_369 != ''">
                        <PackageTypeCodeIdentifierCode>
                            <xsl:value-of select="../S_N9[D_128 = '97']/D_369"/>
                        </PackageTypeCodeIdentifierCode>
                    </xsl:if>
                    <xsl:if test="../S_MAN[D_88 = 'GM']/D_87 != ''">
                        <ShippingContainerSerialCode>
                            <xsl:value-of select="../S_MAN[D_88 = 'GM']/D_87"/>
                        </ShippingContainerSerialCode>
                    </xsl:if>
                    <xsl:if test="../S_MAN[D_88 = 'CA']/D_87 != '' or ../S_MAN[D_87 = 'GIAI']/D_87_2 != ''">
                        <PackageID>
                            <xsl:if test="../S_MAN[D_88 = 'CA']/D_87 != ''">
                                <GlobalIndividualAssetID>
                                    <xsl:value-of select="../S_MAN[D_88 = 'CA']/D_87"/>
                                </GlobalIndividualAssetID>
                            </xsl:if>
                            <xsl:if test="../S_MAN[D_87 = 'GIAI']/D_87_2 != ''">
                                <PackageTrackingID>
                                    <xsl:value-of select="../S_MAN[D_87 = 'GIAI']/D_87_2"/>
                                </PackageTrackingID>
                            </xsl:if>
                        </PackageID>
                    </xsl:if>
                    <DispatchQuantity>
                        <xsl:attribute name="quantity" select="$qty"/>
                    </DispatchQuantity>
                </Packaging>
            </xsl:if>
            <!-- Batch Info -->
            <xsl:for-each select="G_0312">
                <xsl:element name="Batch">
                    <xsl:if test="S_G62[D_432 = 'BL']">
                        <xsl:attribute name="productionDate">
                            <xsl:call-template name="convertToAribaDate">
                                <xsl:with-param name="Date">
                                    <xsl:value-of select="S_G62[D_432 = 'BL']/D_373"/>
                                </xsl:with-param>
                                <xsl:with-param name="Time">
                                    <xsl:value-of select="S_G62[D_432 = 'BL']/D_337"/>
                                </xsl:with-param>
                                <xsl:with-param name="TimeCode">
                                    <xsl:value-of select="S_G62[D_432 = 'BL']/D_623"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_G62[D_432 = '36']">
                        <xsl:attribute name="expirationDate">
                            <xsl:call-template name="convertToAribaDate">
                                <xsl:with-param name="Date">
                                    <xsl:value-of select="S_G62[D_432 = '36']/D_373"/>
                                </xsl:with-param>
                                <xsl:with-param name="Time">
                                    <xsl:value-of select="S_G62[D_432 = '36']/D_337"/>
                                </xsl:with-param>
                                <xsl:with-param name="TimeCode">
                                    <xsl:value-of select="S_G62[D_432 = '36']/D_623"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_G62[D_432 = 'BI']">
                        <xsl:attribute name="inspectionDate">
                            <xsl:call-template name="convertToAribaDate">
                                <xsl:with-param name="Date">
                                    <xsl:value-of select="S_G62[D_432 = 'BI']/D_373"/>
                                </xsl:with-param>
                                <xsl:with-param name="Time">
                                    <xsl:value-of select="S_G62[D_432 = 'BI']/D_337"/>
                                </xsl:with-param>
                                <xsl:with-param name="TimeCode">
                                    <xsl:value-of select="S_G62[D_432 = 'BI']/D_623"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_N9[D_128 = 'BT'][D_127 = 'shelfLife']/D_369 != ''">
                        <xsl:attribute name="shelfLife">
                            <xsl:value-of select="S_N9[D_128 = 'BT'][D_127 = 'shelfLife']/D_369"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_N9[D_128 = 'BT'][D_127 = 'batchQuantity']/D_369 != ''">
                        <xsl:attribute name="batchQuantity">
                            <xsl:value-of select="S_N9[D_128 = 'BT'][D_127 = 'batchQuantity']/D_369"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_N9[D_128 = 'BT'][D_127 = 'originCountryCode']/D_369 != ''">
                        <xsl:attribute name="originCountryCode">
                            <xsl:value-of select="S_N9[D_128 = 'BT'][D_127 = 'originCountryCode']/D_369"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="S_N9[D_128 = 'BT'][D_127 = 'originCountryCode']/D_352 != ''">
                        <xsl:attribute name="originCountryCode">
                            <xsl:value-of select="S_REF[D_128 = 'BT'][D_127 = 'originCountryCode']/D_352"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:for-each select="S_N9[D_128 = 'BT'][D_127 != 'originCountryCode' and D_127 != 'batchQuantity' and D_127 != 'shelfLife'][1] ">
                        <xsl:if test="D_369 != ''">
                            <xsl:element name="BuyerBatchID">
                                <xsl:value-of select="D_369"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="D_127 != ''">
                            <xsl:element name="SupplierBatchID">
                                <xsl:value-of select="D_127"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
            <!-- OrderedQuantity -->
            <xsl:if test="./S_W12/D_330 != ''">
                <xsl:element name="OrderedQuantity">
                    <xsl:attribute name="quantity">
                        <xsl:value-of select="./S_W12/D_330"/>
                    </xsl:attribute>
                    <xsl:if test="S_W12/D_355 != ''">
                        <xsl:variable name="uom" select="S_W12/D_355"/>
                        <xsl:element name="UnitOfMeasure">
                            <xsl:choose>
                                <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
                                </xsl:when>
                                <xsl:otherwise>ZZ</xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>
           <xsl:for-each select="S_N9[D_128 = 'ZZ']">
                <xsl:element name="Extrinsic">
                    <xsl:attribute name="name">
                        <xsl:value-of select="D_127"/>
                    </xsl:attribute>
                    <xsl:value-of select="D_369"/>
                </xsl:element>
            </xsl:for-each>
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
                        <xsl:when test="$Lookup/Lookups/PackagingCodes/PackagingCode[X12Code = $packCode]/CXMLCode != ''">
                            <xsl:value-of select="$Lookup/Lookups/PackagingCodes/PackagingCode[X12Code = $packCode]/CXMLCode"/>
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
                        <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                            <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
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
                            <xsl:attribute name="type">
                                <xsl:value-of select="normalize-space($Lookup/Lookups/MeasureCodes/MeasureCode[X12Code = $meaType]/CXMLCode)"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                            <xsl:element name="UnitOfMeasure">
                                <xsl:value-of select="normalize-space($Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode)"/>
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
                                <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
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
                                <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
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
                        <xsl:value-of select="//FunctionalGroup/M_856/G_HL[S_HL/D_628 = $HLTareLoopID and S_HL/D_735 = 'T']/S_MAN[D_88_1 = 'GM']/D_87_1"/>
                    </ShippingContainerSerialCodeReference>
                </xsl:if>
                <xsl:if
                    test="(S_MAN[D_88_1 = 'ZZ'][D_87_1 = 'GIAI']/D_87_2 != '') or (S_MAN[D_88_1 = 'CA']/D_87_1 != '')">
                    <PackageID>
                        <xsl:if test="(S_MAN[D_88_1 = 'ZZ'][D_87_1 = 'GIAI']/D_87_2 != '')">
                            <GlobalIndividualAssetID>
                                <xsl:value-of select="S_MAN[D_88_1 = 'ZZ'][D_87_1 = 'GIAI']/D_87_2"/>
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
                                        <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $lineUOM]/CXMLCode != ''">
                                            <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $lineUOM][1]/CXMLCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>ZZ</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="S_PO4/D_355_1 != '' and $StructureType = 'SOITP'">
                                <xsl:variable name="uom" select="S_PO4/D_355_1"/>
                                <xsl:element name="UnitOfMeasure">
                                    <xsl:choose>
                                        <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                            <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
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
                                    <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom]/CXMLCode != ''">
                                        <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code = $uom][1]/CXMLCode"/>
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
