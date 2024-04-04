<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61"
    xmlns="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:variable name="cXMLPIDXLookupList" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_PIDX_1.61.xml')"/>
    <xsl:include href="FORMAT_cXML_0000_PIDX_1.61.xsl"/>
    <!--xsl:variable name="cXMLPIDXLookupList" select="document('../../lookups/PIDX/LOOKUP_PIDX_1.61.xml')"/>
    <xsl:include href="FORMAT_cXML_0000_PIDX_1.61.xsl"/-->
    <xsl:param name="anAlternativeSender"/>
    <!-- Sender DUNS4 -->
    <xsl:param name="anAlternativeReceiver"/>
    <!-- Receiver DUNS4 -->
    <xsl:param name="anSenderGroupID"/>
    <!-- Sender DUNS -->
    <xsl:param name="anReceiverGroupID"/>
    <!-- Receiver DUNS -->
    <xsl:param name="anANSILookupFlag"/>
    <xsl:template match="/">
        <xsl:element name="pidx:OrderCreate">
            <xsl:attribute name="pidx:transactionPurposeIndicator">Original</xsl:attribute>
            <xsl:attribute name="pidx:version">1.61</xsl:attribute>
            <xsl:element name="pidx:OrderCreateProperties">
                <xsl:element name="pidx:PurchaseOrderNumber">
                    <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderID"/>
                </xsl:element>
                <xsl:element name="pidx:PurchaseOrderIssuedDate">
                    <xsl:value-of select="substring-before(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 'T')"/>
                </xsl:element>
                <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Contact">
                    <xsl:variable name="Crole" select="@role"/>
                    <xsl:variable name="getPartyrole">
                        <xsl:choose>
                            <xsl:when test="$cXMLPIDXLookupList/Lookups/Roles/Role[CXMLCode = $Crole]/PIDXCode != ''">
                                <xsl:value-of select="$cXMLPIDXLookupList/Lookups/Roles/Role[CXMLCode = $Crole]/PIDXCode"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Not Found</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="createParty">
                        <xsl:with-param name="partyInfo" select="."/>
                        <xsl:with-param name="partyRole" select="$getPartyrole"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address">
                    <xsl:call-template name="createParty">
                        <xsl:with-param name="partyInfo" select="."/>
                        <xsl:with-param name="partyRole" select="'ShipToParty'"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address">
                    <xsl:call-template name="createParty">
                        <xsl:with-param name="partyInfo" select="."/>
                        <xsl:with-param name="partyRole" select="'BillTo'"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:if test="not(exists(cXML/Request/OrderRequest/OrderRequestHeader/Contact[lower-case(@role)='soldto']))">
                    <xsl:call-template name="createParty">
                        <xsl:with-param name="partyInfo" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address"/>
                        <xsl:with-param name="partyRole" select="'SoldTo'"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:element name="pidx:PurchaseOrderTypeCode">
                    <xsl:choose>
                        <xsl:when
                            test="cXML/Request/OrderRequest/ItemOut/SpendDetail or cXML/Request/OrderRequest/ItemOut/@itemType = 'composite'">
                            <xsl:text>SupplyOrServiceOrder</xsl:text>
                        </xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@orderType = 'release'">
                            <xsl:text>ReleaseOrDeliveryOrder</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Other</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion != ''">
                    <xsl:element name="pidx:ReleaseNumber">
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="pidx:PrimaryCurrency">
                    <xsl:element name="pidx:CurrencyCode">
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="pidx:SecondCurrency">
                    <xsl:element name="pidx:CurrencyCode">
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternatecurrency"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="pidx:LanguageCode">
                    <xsl:choose>
                        <xsl:when test="cXML/@xml:lang != ''">
                            <xsl:value-of select="cXML/@xml:lang"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>en</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate != ''">
                    <xsl:element name="pidx:ServiceDateTime">
                        <xsl:attribute name="dateTypeIndicator">ServicePeriodStart</xsl:attribute>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate != ''">
                    <xsl:element name="pidx:ServiceDateTime">
                        <xsl:attribute name="dateTypeIndicator">ServicePeriodEnd</xsl:attribute>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate != ''">
                    <xsl:element name="pidx:ServiceDateTime">
                        <xsl:attribute name="dateTypeIndicator">RequestedForDelivery</xsl:attribute>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate"/>
                    </xsl:element>
                </xsl:if>
                <xsl:variable name="ShipType"
                    select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
                <xsl:variable name="ShipPayType"
                    select="$cXMLPIDXLookupList/Lookups/ShipmentMethodOfPaymentTypes/ShipmentMethodOfPaymentType[CXMLCode = $ShipType]/PIDXCode"/>
                <xsl:if test="$ShipPayType != ''">
                    <xsl:element name="pidx:TransportInformation">
                        <xsl:element name="pidx:ShipmentMethodOfPayment">
                            <xsl:value-of select="$ShipPayType"/>
                        </xsl:element>
                        <xsl:variable name="TransportType"
                            select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value"/>
                        <xsl:variable name="TransportTypeLookup"
                            select="$cXMLPIDXLookupList/Lookups/TransportMethodTypes/TransportMethodType[CXMLCode = $TransportType]/PIDXCode"/>
                        <xsl:choose>
                            <xsl:when test="$TransportTypeLookup != ''">
                                <xsl:element name="pidx:TransportMethodCode">
                                    <xsl:value-of select="$TransportTypeLookup"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="pidx:TransportMethodCode">
                                    <xsl:text>Other</xsl:text>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address">
                            <xsl:element name="pidx:Location">
                                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/@addressIDDomain != ''">
                                    <xsl:attribute name="locationIndicator">
                                        <xsl:value-of
                                            select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/@addressIDDomain"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:element name="pidx:LocationIdentifier">
                                    <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/@addressID"/>
                                </xsl:element>
                                <xsl:element name="pidx:LocationName">
                                    <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/Name"/>
                                </xsl:element>
                                <xsl:element name="pidx:AddressInformation">
                                    <xsl:element name="pidx:StreetName">
                                        <xsl:value-of
                                            select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/PostalAddress/Street"
                                        />
                                    </xsl:element>
                                    <xsl:element name="pidx:CityName">
                                        <xsl:value-of
                                            select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/PostalAddress/City"
                                        />
                                    </xsl:element>
                                    <xsl:element name="pidx:StateProvince">
                                        <xsl:value-of
                                            select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/PostalAddress/State"
                                        />
                                    </xsl:element>
                                    <xsl:element name="pidx:PostalCode">
                                        <xsl:value-of
                                            select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/PostalAddress/PostalCode"/>
                                    </xsl:element>
                                    <xsl:element name="pidx:PostalCountry">
                                        <xsl:element name="pidx:CountryCode">
                                            <xsl:value-of
                                                select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address/PostalAddress/Country/@isoCountryCode"
                                            />
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="pidx:ShipmentTermsCode">
                            <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode/@value"/>
                        </xsl:element>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value != ''">
                            <xsl:element name="pidx:ServiceLevelCode">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport'] != ''">
                            <xsl:element name="pidx:TransportName">
                                <xsl:value-of
                                    select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport']"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm">
                    <xsl:element name="pidx:PaymentTerms">
                        <xsl:element name="pidx:PaymentTermsBasisDateCode">
                            <xsl:text>InvoiceDate</xsl:text>
                        </xsl:element>
                        <xsl:element name="pidx:TermsNetDays">
                            <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[1]/@payInNumberOfDays"/>
                        </xsl:element>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue']">
                            <xsl:element name="pidx:DaysDue">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'DiscountDaysDue'][1]"
                                />
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[1]/DiscountPercent/@percent != ''">
                            <xsl:element name="pidx:PercentDiscount">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[1]/DiscountPercent/@percent"
                                />
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[1]/DiscountAmount/Money != ''">
                            <xsl:element name="pidx:DiscountAmount">
                                <xsl:element name="pidx:MonetaryAmount">
                                    <xsl:call-template name="formatAmount">
                                        <xsl:with-param name="amount"
                                            select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[1]/DiscountAmount/Money"/>
                                    </xsl:call-template>
                                    <!--<xsl:value-of                                        select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm[1]/DiscountAmount/Money"                                    />-->
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/@value != ''">
                    <xsl:element name="pidx:SpecialInstructions">
                        <xsl:attribute name="instructionIndicator">
                            <xsl:text>Other</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="definitionOfOther">
                            <xsl:text>OCValue</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/@value"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if
                    test="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit != ''">
                    <xsl:element name="pidx:SpecialInstructions">
                        <xsl:attribute name="instructionIndicator">
                            <xsl:text>Tolerances</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="definitionOfOther">
                            <xsl:text>OCLowerTimeToleranceInDays</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of
                            select="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit"
                        />
                    </xsl:element>
                </xsl:if>
                <xsl:if
                    test="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit != ''">
                    <xsl:element name="pidx:SpecialInstructions">
                        <xsl:attribute name="instructionIndicator">
                            <xsl:text>Tolerances</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="definitionOfOther">
                            <xsl:text>OCUpperTimeToleranceInDays</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of
                            select="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit"
                        />
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/ASNInstruction/@value != ''">
                    <xsl:element name="pidx:SpecialInstructions">
                        <xsl:attribute name="instructionIndicator">
                            <xsl:text>Other</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="definitionOfOther">
                            <xsl:text>ASNValue</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/ASNInstruction/@value"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/InvoiceInstruction/@value != ''">
                    <xsl:element name="pidx:SpecialInstructions">
                        <xsl:attribute name="instructionIndicator">
                            <xsl:text>Other</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="definitionOfOther">
                            <xsl:text>INVValue</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/InvoiceInstruction/@value"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/SESInstruction/@value != ''">
                    <xsl:element name="pidx:SpecialInstructions">
                        <xsl:attribute name="instructionIndicator">
                            <xsl:text>Other</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="definitionOfOther">
                            <xsl:text>SESValue</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/SESInstruction/@value"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@agreementID != ''">
                    <xsl:element name="pidx:ReferenceInformation">
                        <xsl:attribute name="referenceInformationIndicator">
                            <xsl:text>ContractNumber</xsl:text>
                        </xsl:attribute>
                        <xsl:element name="pidx:ReferenceNumber">
                            <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@agreementID"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID != ''">
                    <xsl:element name="pidx:ReferenceInformation">
                        <xsl:attribute name="referenceInformationIndicator">
                            <xsl:text>CustomerAccountingReference</xsl:text>
                        </xsl:attribute>
                        <xsl:element name="pidx:ReferenceNumber">
                            <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic">
                    <xsl:variable name="refName" select="@name"/>
                    <xsl:if test="$refName != ''">
                        <xsl:element name="pidx:ReferenceInformation">
                            <xsl:attribute name="referenceInformationIndicator">
                                <!--xsl:value-of select="$refName"/-->
                                <xsl:text>Other</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="pidx:ReferenceNumber">
                                <xsl:call-template name="breakText">
                                    <xsl:with-param name="text">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:element>
                            <xsl:element name="pidx:Description">
                                <xsl:value-of select="$refName"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Comments/Attachment">
                    <xsl:element name="pidx:Attachment">
                        <xsl:element name="pidx:AttachmentPurposeCode">
                            <xsl:text>Other</xsl:text>
                        </xsl:element>
                        <xsl:element name="pidx:FileName">
                            <xsl:value-of select="URL/@name"/>
                        </xsl:element>
                        <xsl:element name="pidx:AttachmentLocation">
                            <xsl:value-of select="URL"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <!-- IG-19114 IG-19445 to support multi comments-->
                <xsl:for-each select="(cXML/Request/OrderRequest/OrderRequestHeader/Comments/text()[normalize-space(.) != ''])[1]">
                    <xsl:element name="pidx:Comment">                        
                        <xsl:call-template name="breakText">
                            <xsl:with-param name="text">
                                <xsl:value-of select="normalize-space(.)"/>                                
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:element>                    
                </xsl:for-each>
                <!-- IG-19114 IG-19445 to support multi comments-->
               </xsl:element>
            <xsl:element name="pidx:OrderCreateDetails">
                <xsl:variable name="isParentChild">
                    <xsl:value-of select="count(cXML/Request/OrderRequest/ItemOut/@itemType = 'composite')"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$isParentChild &gt; 0">
                        <xsl:for-each select="cXML/Request/OrderRequest/ItemOut[not(@parentLineNumber != '')]">
                            <xsl:choose>
                                <xsl:when test="@itemType = 'composite'">
                                    <xsl:element name="pidx:OrderCreateLineItem">
                                        <xsl:call-template name="createlineitems">
                                            <xsl:with-param name="item" select="."/>
                                            <xsl:with-param name="createSubLine" select="'true'"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="pidx:OrderCreateLineItem">
                                        <xsl:call-template name="createlineitems">
                                            <xsl:with-param name="item" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="cXML/Request/OrderRequest/ItemOut">
                            <xsl:element name="pidx:OrderCreateLineItem">
                                <xsl:call-template name="createlineitems">
                                    <xsl:with-param name="item" select="."/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:element name="pidx:OrderCreateSummary">
                <xsl:element name="pidx:TotalLineItems">
                    <xsl:value-of select="count(cXML/Request/OrderRequest/ItemOut[not(@parentLineNumber)])"/>
                </xsl:element>
                <xsl:element name="pidx:TotalAmount">
                    <xsl:element name="pidx:MonetaryAmount">
                        <xsl:call-template name="formatAmount">
                            <xsl:with-param name="amount" select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money"/>
                        </xsl:call-template>
                        <!--<xsl:value-of                            select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money"/>-->
                    </xsl:element>
                    <xsl:element name="pidx:CurrencyCode">
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="createParty">
        <xsl:param name="partyInfo"/>
        <xsl:param name="partyRole"/>
        <xsl:if test="$partyRole != 'Not Found'">
            <xsl:element name="pidx:PartnerInformation">
                <xsl:attribute name="partnerRoleIndicator">
                    <xsl:value-of select="$partyRole"/>
                </xsl:attribute>
                <!-- IG-2872 -->
                <xsl:element name="pidx:PartnerIdentifier">
                    <xsl:attribute name="partnerIdentifierIndicator">
                        <xsl:choose>
                            <xsl:when test="normalize-space(@addressIDDomain) = 'assignedBySeller'">AssignedBySeller</xsl:when>
                            <xsl:when test="normalize-space(@addressIDDomain) = 'duns4'">DUNS+4Number</xsl:when>
                            <xsl:when test="normalize-space(@addressIDDomain) = 'duns'">DUNSNumber</xsl:when>
                            <xsl:otherwise>AssignedByBuyer</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="@addressID"/>
                </xsl:element>
                <xsl:choose>
                    <xsl:when test="$partyRole = 'SoldTo' or $partyRole = 'ShipToParty' or $partyRole = 'BillTo'">
                        <xsl:if test="normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity) != ''">
                            <xsl:element name="pidx:PartnerIdentifier">
                                <xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
                                <xsl:value-of
                                    select="substring(normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity), 1, 9)"/>
                            </xsl:element>
                            <xsl:if test="substring(normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity), 10) != ''">
                                <xsl:element name="pidx:PartnerIdentifier">
                                    <xsl:attribute name="partnerIdentifierIndicator">DUNS+4Number</xsl:attribute>
                                    <xsl:value-of select="normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity)"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$partyRole = 'Seller'">
                        <xsl:if test="normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity) != ''">
                            <xsl:element name="pidx:PartnerIdentifier">
                                <xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
                                <xsl:value-of
                                    select="substring(normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity), 1, 9)"/>
                            </xsl:element>
                            <xsl:if test="substring(normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity), 10) != ''">
                                <xsl:element name="pidx:PartnerIdentifier">
                                    <xsl:attribute name="partnerIdentifierIndicator">DUNS+4Number</xsl:attribute>
                                    <xsl:value-of select="normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity)"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="$partyInfo/IdReference">
                    <xsl:for-each select="$partyInfo/IdReference">
                        <xsl:element name="pidx:PartnerIdentifier">
                            <!-- IG-2872 -->
                            <xsl:attribute name="partnerIdentifierIndicator">
                                <xsl:choose>
                                    <xsl:when test="normalize-space(@domain) = 'assignedByBuyer'">AssignedByBuyer</xsl:when>
                                    <xsl:when test="normalize-space(@domain) = 'assignedBySeller'">AssignedBySeller</xsl:when>
                                    <xsl:when test="normalize-space(@domain) = 'duns4'">DUNS+4Number</xsl:when>
                                    <xsl:when test="normalize-space(@domain) = 'duns'">DUNSNumber</xsl:when>
                                    <xsl:otherwise>Other</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="definitionOfOther">
                                <xsl:value-of select="@domain"/>
                            </xsl:attribute>
                            <xsl:value-of select="@identifier"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="../IdReference">
                    <xsl:for-each select="../IdReference">
                        <xsl:element name="pidx:PartnerIdentifier">
                            <xsl:attribute name="partnerIdentifierIndicator">
                                <xsl:text>Other</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="definitionOfOther">
                                <xsl:value-of select="@domain"/>
                            </xsl:attribute>
                            <xsl:value-of select="@identifier"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
                <xsl:element name="pidx:PartnerName">
                    <xsl:value-of select="$partyInfo/Name"/>
                </xsl:element>
                <xsl:if test="$partyInfo/PostalAddress">
                    <xsl:element name="pidx:AddressInformation">
                        <xsl:element name="pidx:StreetName">
                            <xsl:value-of select="$partyInfo/PostalAddress/Street"/>
                        </xsl:element>
                        <xsl:element name="pidx:CityName">
                            <xsl:value-of select="$partyInfo/PostalAddress/City"/>
                        </xsl:element>
                        <xsl:element name="pidx:StateProvince">
                            <xsl:value-of select="$partyInfo/PostalAddress/State"/>
                        </xsl:element>
                        <xsl:element name="pidx:PostalCode">
                            <xsl:value-of select="$partyInfo/PostalAddress/PostalCode"/>
                        </xsl:element>
                        <xsl:element name="pidx:PostalCountry">
                            <xsl:element name="pidx:CountryCode">
                                <xsl:value-of select="$partyInfo/PostalAddress/Country/@isoCountryCode"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:if
                    test="$partyInfo/PostalAddress/DeliverTo != '' or $partyInfo/Email != '' or $partyInfo/Phone/TelephoneNumber/Number != '' or $partyInfo/Fax/TelephoneNumber/Number != ''">
                    <xsl:element name="pidx:ContactInformation">
                        <xsl:attribute name="contactInformationIndicator">
                            <xsl:text>OrderContact</xsl:text>
                        </xsl:attribute>
                        <xsl:if test="$partyInfo/PostalAddress/DeliverTo != ''">
                            <xsl:element name="pidx:ContactName">
                                <xsl:value-of select="$partyInfo/PostalAddress/DeliverTo"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$partyInfo/Phone/TelephoneNumber/Number != ''">
                            <xsl:variable name="areaCode" select="normalize-space($partyInfo/Phone/TelephoneNumber/AreaOrCityCode)"/>
                            <xsl:variable name="countryCode" select="normalize-space($partyInfo/Phone/TelephoneNumber/CountryCode)"/>
                            <xsl:element name="pidx:Telephone">
                                <xsl:attribute name="telephoneIndicator">
                                    <xsl:text>Voice</xsl:text>
                                </xsl:attribute>
                                <xsl:element name="pidx:PhoneNumber">
                                    <xsl:value-of select="$partyInfo/Phone/TelephoneNumber/Number"/>
                                </xsl:element>
                                <xsl:element name="pidx:PhoneNumberExtension">
                                    <xsl:value-of select="$partyInfo/Phone/TelephoneNumber/Extension"/>
                                </xsl:element>
                                <xsl:element name="pidx:TelecomCountryCode">
                                    <xsl:value-of select="$countryCode"/>
                                </xsl:element>
                                <xsl:element name="pidx:TelecomAreaCode">
                                    <xsl:value-of select="$areaCode"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$partyInfo/Fax/TelephoneNumber/Number != ''">
                            <xsl:variable name="areaCode" select="normalize-space($partyInfo/Fax/TelephoneNumber/AreaOrCityCode)"/>
                            <xsl:variable name="countryCode" select="normalize-space($partyInfo/Fax/TelephoneNumber/CountryCode)"/>
                            <xsl:element name="pidx:Telephone">
                                <xsl:attribute name="telephoneIndicator">
                                    <xsl:text>Fax</xsl:text>
                                </xsl:attribute>
                                <xsl:element name="pidx:PhoneNumber">
                                    <xsl:value-of select="$partyInfo/Fax/TelephoneNumber/Number"/>
                                </xsl:element>
                                <xsl:element name="pidx:PhoneNumberExtension">
                                    <xsl:value-of select="$partyInfo/Fax/TelephoneNumber/Extension"/>
                                </xsl:element>
                                <xsl:element name="pidx:TelecomCountryCode">
                                    <xsl:value-of select="$countryCode"/>
                                </xsl:element>
                                <xsl:element name="pidx:TelecomAreaCode">
                                    <xsl:value-of select="$areaCode"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$partyInfo/Email != ''">
                            <xsl:element name="pidx:EmailAddress">
                                <xsl:value-of select="$partyInfo/Email"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="createlineitems">
        <xsl:param name="item"/>
        <xsl:param name="createSubLine"/>
        <xsl:param name="isSubLine"/>
        <xsl:choose>
            <xsl:when test="$isSubLine = 'true'">
                <xsl:element name="pidx:SubLineItemNumber">
                    <xsl:value-of select="$item/@lineNumber"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="pidx:LineItemNumber">
                    <xsl:value-of select="$item/@lineNumber"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="pidx:LineItemInformation">
            <xsl:if test="$item/ItemID/SupplierPartID != ''">
                <xsl:element name="pidx:LineItemIdentifier">
                    <xsl:attribute name="identifierIndicator">AssignedBySeller</xsl:attribute>
                    <xsl:value-of select="$item/ItemID/SupplierPartID"/>
                </xsl:element>
            </xsl:if>
            <!-- IG-2944 -->
            <xsl:if test="$item/ItemID/SupplierPartAuxiliaryID != ''">
                <xsl:element name="pidx:LineItemIdentifier">
                    <xsl:attribute name="identifierIndicator">CatalogueNumber</xsl:attribute>
                    <xsl:value-of select="$item/ItemID/SupplierPartAuxiliaryID"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="$item/ItemID/BuyerPartID != ''">
                <xsl:element name="pidx:LineItemIdentifier">
                    <xsl:attribute name="identifierIndicator">AssignedByBuyer</xsl:attribute>
                    <xsl:value-of select="$item/ItemID/BuyerPartID"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="$item//ManufacturerPartID != ''">
                <xsl:element name="pidx:LineItemIdentifier">
                    <xsl:attribute name="identifierIndicator">AssignedByManufacturer</xsl:attribute>
                    <xsl:value-of select="$item/ItemDetail/ManufacturerPartID"/>
                </xsl:element>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$item/BlanketItemDetail/Description">
                    <xsl:element name="pidx:LineItemName">
                        <xsl:value-of select="$item/BlanketItemDetail/Description"/>
                    </xsl:element>
                    <xsl:element name="pidx:LineItemDescription">
                        <xsl:value-of select="$item/BlanketItemDetail/Description"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$item/ItemDetail/Description">
                        <xsl:element name="pidx:LineItemName">
                            <xsl:value-of select="$item/ItemDetail/Description"/>
                        </xsl:element>
                        <xsl:element name="pidx:LineItemDescription">
                            <xsl:value-of select="$item/ItemDetail/Description"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="pidx:OrderQuantity">
            <xsl:element name="pidx:Quantity">
                <xsl:value-of select="$item/@quantity"/>
            </xsl:element>
            <xsl:variable name="uom">
                <xsl:choose>
                    <xsl:when test="$item/BlanketItemDetail/UnitOfMeasure">
                        <xsl:value-of select="$item/BlanketItemDetail/UnitOfMeasure"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$item/ItemDetail/UnitOfMeasure"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="UOMCodeConversion">
                <xsl:with-param name="UOMCode" select="$uom"/>
            </xsl:call-template>
        </xsl:element>
        <!--updated classification xpath-->
        <xsl:choose>
            <xsl:when test="$item/ItemDetail/Classification[@domain = 'UNSPSC'] != ''">
                <xsl:element name="pidx:CommodityCode">
                    <xsl:attribute name="agencyIndicator">UNSPSC</xsl:attribute>
                    <xsl:value-of select="$item/ItemDetail/Classification[@domain = 'UNSPSC']"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$item/BlanketItemDetail/Classification[@domain = 'UNSPSC'] != ''">
                <xsl:element name="pidx:CommodityCode">
                    <xsl:attribute name="agencyIndicator">UNSPSC</xsl:attribute>
                    <xsl:value-of select="$item/BlanketItemDetail/Classification[@domain = 'UNSPSC']"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="commodityType">
            <xsl:choose>
                <xsl:when test="$item/SpendDetail">
                    <xsl:text>Services</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Goods</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="pidx:CommodityCode">
            <xsl:attribute name="agencyIndicator">AssignedByBuyer</xsl:attribute>
            <xsl:value-of select="$commodityType"/>
        </xsl:element>
        <!-- IG-26030 Map non UNSPSC classification -->
        <xsl:for-each select="$item/ItemDetail/Classification[@domain != 'UNSPSC'] | $item/BlanketItemDetail/Classification[@domain != 'UNSPSC']">
            <xsl:element name="pidx:CommodityCode">
                <xsl:attribute name="agencyIndicator">
                    <xsl:value-of select="./@domain"/>
                </xsl:attribute>
                <xsl:value-of select="./text()"/>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$item/Contact">
            <xsl:variable name="Crole" select="@role"/>
            <xsl:variable name="getPartyrole">
                <xsl:choose>
                    <xsl:when test="$cXMLPIDXLookupList/Lookups/Roles/Role[CXMLCode = $Crole]/PIDXCode != ''">
                        <xsl:value-of select="$cXMLPIDXLookupList/Lookups/Roles/Role[CXMLCode = $Crole]/PIDXCode"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Not Found</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="createParty">
                <xsl:with-param name="partyInfo" select="."/>
                <xsl:with-param name="partyRole" select="$getPartyrole"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$item/ShipTo/Address">
            <xsl:call-template name="createParty">
                <xsl:with-param name="partyInfo" select="."/>
                <xsl:with-param name="partyRole" select="'ShipToParty'"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:if test="$item/ShipTo/Address/@addressID != ''">
            <xsl:element name="pidx:JobLocationInformation">
                <xsl:element name="pidx:WellInformation">
                    <xsl:element name="pidx:WellIdentifier">
                        <xsl:attribute name="wellIdentifierIndicator">Other</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="pidx:WellName">
                        <xsl:value-of select="$item/ItemID/IdReference[@domain = 'WellName']/@identifier"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$item/BlanketItemDetail/UnitPrice/Money != ''">
                <xsl:element name="pidx:Pricing">
                    <xsl:element name="pidx:UnitPrice">
                        <xsl:element name="pidx:MonetaryAmount">
                            <xsl:call-template name="formatAmount">
                                <xsl:with-param name="amount" select="$item/BlanketItemDetail/UnitPrice/Money"/>
                            </xsl:call-template>
                            <!--<xsl:value-of select="$item/BlanketItemDetail/UnitPrice/Money"/>-->
                        </xsl:element>
                        <xsl:call-template name="UOMCodeConversion">
                            <xsl:with-param name="UOMCode" select="$item/BlanketItemDetail/UnitOfMeasure"/>
                        </xsl:call-template>
                        <xsl:element name="pidx:CurrencyCode">
                            <xsl:value-of select="$item/BlanketItemDetail/UnitPrice/Money/@currency"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:if test="$item/BlanketItemDetail/PriceBasisQuantity">
                        <xsl:element name="pidx:PriceBasis">
                            <xsl:element name="pidx:Measurement">
                                <xsl:value-of select="$item/BlanketItemDetail/PriceBasisQuantity/@quantity"/>
                            </xsl:element>
                            <xsl:call-template name="UOMCodeConversion">
                                <xsl:with-param name="UOMCode" select="$item/BlanketItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$item/ItemDetail/UnitPrice/Money != ''">
                    <xsl:element name="pidx:Pricing">
                        <xsl:element name="pidx:UnitPrice">
                            <xsl:element name="pidx:MonetaryAmount">
                                <xsl:call-template name="formatAmount">
                                    <xsl:with-param name="amount" select="$item/ItemDetail/UnitPrice/Money"/>
                                </xsl:call-template>
                                <!--<xsl:value-of select="$item/ItemDetail/UnitPrice/Money"/>-->
                            </xsl:element>
                            <xsl:call-template name="UOMCodeConversion">
                                <xsl:with-param name="UOMCode" select="$item/ItemDetail/UnitOfMeasure"/>
                            </xsl:call-template>
                            <xsl:element name="pidx:CurrencyCode">
                                <xsl:value-of select="$item/ItemDetail/UnitPrice/Money/@currency"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:if test="$item/ItemDetail/PriceBasisQuantity">
                            <xsl:element name="pidx:PriceBasis">
                                <xsl:element name="pidx:Measurement">
                                    <xsl:value-of select="$item/ItemDetail/PriceBasisQuantity/@quantity"/>
                                </xsl:element>
                                <xsl:call-template name="UOMCodeConversion">
                                    <xsl:with-param name="UOMCode" select="$item/ItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="$item/ItemDetail/UnitPrice/Modifications/Modification">
            <xsl:call-template name="AllowanceOrCharge">
                <xsl:with-param name="AlloworCharge" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$item/BlanketItemDetail/UnitPrice/Modifications">
            <xsl:call-template name="AllowanceOrCharge">
                <xsl:with-param name="AlloworCharge" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$item/Tax/TaxDetail">
            <xsl:variable name="taxtype" select="@category"/>
            <xsl:element name="pidx:Tax">
                <xsl:element name="pidx:TaxTypeCode">
                    <xsl:choose>
                        <xsl:when test="$cXMLPIDXLookupList/Lookups/TaxTypes/TaxType[CXMLCode = $taxtype]/PIDXCode != ''">
                            <xsl:value-of select="$cXMLPIDXLookupList/Lookups/TaxTypes/TaxType[CXMLCode = $taxtype]/PIDXCode"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Other</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <!-- IG - 2872 -->
                <xsl:if test="normalize-space(@exemptDetail) != ''">
                    <xsl:element name="pidx:TaxExemptCode">
                        <xsl:choose>
                            <xsl:when test="normalize-space(@exemptDetail) = 'exempt'">Exempt</xsl:when>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="pidx:TaxLocation">
                    <xsl:element name="pidx:LocationDescription">
                        <xsl:value-of select="TaxLocation"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="pidx:TaxRate">
                    <xsl:choose>
                        <xsl:when test="@percentageRate">
                            <xsl:value-of select="@percentageRate"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0.00</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="pidx:TaxBasisAmount">
                    <xsl:element name="pidx:MonetaryAmount">
                        <xsl:call-template name="formatAmount">
                            <xsl:with-param name="amount" select="TaxableAmount/Money"/>
                        </xsl:call-template>
                        <!--<xsl:value-of select="TaxableAmount/Money"/>-->
                    </xsl:element>
                </xsl:element>
                <xsl:element name="pidx:TaxAmount">
                    <xsl:element name="pidx:MonetaryAmount">
                        <xsl:call-template name="formatAmount">
                            <xsl:with-param name="amount" select="TaxAmount/Money"/>
                        </xsl:call-template>
                        <!--<xsl:value-of select="TaxAmount/Money"/>-->
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="$item/@requestedDeliveryDate != ''">
                <xsl:element name="pidx:ServiceDateTime">
                    <xsl:attribute name="dateTypeIndicator">RequestedForDelivery</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length($item/@requestedDeliveryDate) = 10">
                            <xsl:value-of select="concat($item/@requestedDeliveryDate, 'T00:00:00')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$item/@requestedDeliveryDate"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$item/ScheduleLine/@requestedDeliveryDate != ''">
                <xsl:element name="pidx:ServiceDateTime">
                    <xsl:attribute name="dateTypeIndicator">RequestedForDelivery</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="string-length($item/ScheduleLine/@requestedDeliveryDate) = 10">
                            <xsl:value-of select="concat($item/ScheduleLine/@requestedDeliveryDate, 'T00:00:00')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$item/ScheduleLine/@requestedDeliveryDate"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="ShipType" select="$item/TermsOfDelivery/ShippingPaymentMethod/@value"/>
        <xsl:variable name="ShipPayType"
            select="$cXMLPIDXLookupList/Lookups/ShipmentMethodOfPaymentTypes/ShipmentMethodOfPaymentType[CXMLCode = $ShipType]/PIDXCode"/>
        <xsl:if test="$ShipPayType != ''">
            <xsl:element name="pidx:TransportInformation">
                <xsl:element name="pidx:ShipmentMethodOfPayment">
                    <xsl:value-of select="$ShipPayType"/>
                </xsl:element>
                <xsl:variable name="TransportType" select="$item/TermsOfDelivery/TransportTerms/@value"/>
                <xsl:variable name="TransportTypeLookup"
                    select="$cXMLPIDXLookupList/Lookups/TransportMethodTypes/TransportMethodType[CXMLCode = $TransportType]/PIDXCode"/>
                <xsl:choose>
                    <xsl:when test="$TransportTypeLookup != ''">
                        <xsl:element name="pidx:TransportMethodCode">
                            <xsl:value-of select="$TransportTypeLookup"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="pidx:TransportMethodCode">
                            <xsl:text>Other</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$item/TermsOfDelivery/Address">
                    <xsl:element name="pidx:Location">
                        <xsl:if test="$item/TermsOfDelivery/Address/@addressIDDomain != ''">
                            <xsl:attribute name="locationIndicator">
                                <xsl:value-of select="$item/TermsOfDelivery/Address/@addressIDDomain"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:element name="pidx:LocationIdentifier">
                            <xsl:value-of select="$item/TermsOfDelivery/Address/@addressID"/>
                        </xsl:element>
                        <xsl:element name="pidx:LocationName">
                            <xsl:value-of select="$item/TermsOfDelivery/Address/Name"/>
                        </xsl:element>
                        <xsl:element name="pidx:AddressInformation">
                            <xsl:element name="pidx:StreetName">
                                <xsl:value-of select="$item/TermsOfDelivery/Address/PostalAddress/Street"/>
                            </xsl:element>
                            <xsl:element name="pidx:CityName">
                                <xsl:value-of select="$item/TermsOfDelivery/Address/PostalAddress/City"/>
                            </xsl:element>
                            <xsl:element name="pidx:StateProvince">
                                <xsl:value-of select="$item/TermsOfDelivery/Address/PostalAddress/State"/>
                            </xsl:element>
                            <xsl:element name="pidx:PostalCode">
                                <xsl:value-of select="$item/TermsOfDelivery/PostalAddress/PostalCode"/>
                            </xsl:element>
                            <xsl:element name="pidx:PostalCountry">
                                <xsl:element name="pidx:CountryCode">
                                    <xsl:value-of select="$item/TermsOfDelivery/Address/PostalAddress/Country/@isoCountryCode"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="pidx:ShipmentTermsCode">
                    <xsl:value-of select="$item/TermsOfDelivery/TermsOfDeliveryCode/@value"/>
                </xsl:element>
                <xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value != ''">
                    <xsl:element name="pidx:ServiceLevelCode">
                        <xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value"/>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport'] != ''">
                    <xsl:element name="pidx:TransportName">
                        <xsl:value-of select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport']"/>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$item/ShipTo/TransportInformation/ShippingInstructions/Description != ''">
            <xsl:element name="pidx:SpecialInstructions">
                <xsl:attribute name="instructionIndicator">ShipperInstructions</xsl:attribute>
                <xsl:value-of select="$item/ShipTo/TransportInformation/ShippingInstructions/Description"/>
            </xsl:element>
        </xsl:if>
        <!-- IG-26030 Map Instructions -->
        <xsl:call-template name="MapInstructions">
            <xsl:with-param name="keys" select="ControlKeys"/>          
        </xsl:call-template>
        <!-- CG: 04/25/2017 -->
        <xsl:if test="$item/Batch/SupplierBatchID">
            <xsl:element name="pidx:ReferenceInformation">
                <xsl:attribute name="referenceInformationIndicator">BatchNumber</xsl:attribute>
                <xsl:element name="pidx:ReferenceNumber">
                    <xsl:value-of select="$item/Batch/SupplierBatchID"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'AFENumber']">
            <xsl:element name="pidx:ReferenceInformation">
                <xsl:attribute name="referenceInformationIndicator">AFENumber</xsl:attribute>
                <xsl:element name="pidx:ReferenceNumber">
                    <xsl:value-of select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'AFENumber']/@id"/>
                </xsl:element>
                <xsl:element name="pidx:Description">
                    <xsl:value-of select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'AFENumber']/Description"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'CostCenter']">
            <xsl:element name="pidx:ReferenceInformation">
                <xsl:attribute name="referenceInformationIndicator">CostCenter</xsl:attribute>
                <xsl:element name="pidx:ReferenceNumber">
                    <xsl:value-of select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'CostCenter']/@id"/>
                </xsl:element>
                <xsl:element name="pidx:Description">
                    <xsl:value-of select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'CostCenter']/Description"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'GeneralLedger']">
                <xsl:element name="pidx:ReferenceInformation">
                    <xsl:attribute name="referenceInformationIndicator">OperatorGeneralLedgerCode</xsl:attribute>
                    <xsl:element name="pidx:ReferenceNumber">
                        <xsl:value-of select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'GeneralLedger']/@id"/>
                    </xsl:element>
                    <xsl:element name="pidx:Description">
                        <xsl:value-of select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'GeneralLedger']/Description"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'OperatorGeneralLedgerCode']">
                <xsl:element name="pidx:ReferenceInformation">
                    <xsl:attribute name="referenceInformationIndicator">
                        <xsl:text>OperatorGeneralLedgerCode</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="pidx:ReferenceNumber">
                        <xsl:value-of select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'OperatorGeneralLedgerCode']/@id"/>
                    </xsl:element>
                    <xsl:element name="pidx:Description">
                        <xsl:value-of
                            select="$item/Distribution[1]/Accounting/AccountingSegment[Name = 'OperatorGeneralLedgerCode']/Description"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
        <xsl:for-each select="$item/ItemDetail/Extrinsic">
            <xsl:variable name="refName" select="@name"/>
            <xsl:if test="$refName != ''">
                <xsl:element name="pidx:ReferenceInformation">
                    <xsl:attribute name="referenceInformationIndicator">
                        <xsl:choose>
                            <xsl:when test="$refName = 'contractNo'">
                                <xsl:text>ContractNumber</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Other</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:element name="pidx:ReferenceNumber">
                        <xsl:call-template name="breakText">
                            <xsl:with-param name="text">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="pidx:Description">
                        <xsl:value-of select="$refName"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$item/BlanketItemDetail/Extrinsic">
            <xsl:variable name="refName" select="@name"/>
            <xsl:if test="$refName != ''">
                <xsl:element name="pidx:ReferenceInformation">
                    <xsl:attribute name="referenceInformationIndicator">
                        <xsl:choose>
                            <xsl:when test="$refName = 'contractNo'">
                                <xsl:text>ContractNumber</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Other</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:element name="pidx:ReferenceNumber">
                        <xsl:call-template name="breakText">
                            <xsl:with-param name="text">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="pidx:Description">
                        <xsl:value-of select="$refName"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <!-- IG - 4454 -->
        <xsl:if
            test="not(exists($item/BlanketItemDetail/Extrinsic[@name = 'contractNo'])) and normalize-space($item/MasterAgreementReference/@agreementID) != ''">
            <xsl:element name="pidx:ReferenceInformation">
                <xsl:attribute name="referenceInformationIndicator">
                    <xsl:text>ContractNumber</xsl:text>
                </xsl:attribute>
                <xsl:element name="pidx:ReferenceNumber">
                    <xsl:value-of select="$item/MasterAgreementReference/@agreementID"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <!-- IG-19114 IG-19445 to support multi comments-->
        <xsl:for-each select="($item/Comments/text()[normalize-space(.) != ''])[1]">
            <xsl:element name="pidx:Comment">                        
                <xsl:call-template name="breakText">
                    <xsl:with-param name="text">
                        <xsl:value-of select="normalize-space(.)"/>                                
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:element>                    
        </xsl:for-each>
        <xsl:if test="$createSubLine = 'true'">
            <xsl:variable name="parentLine" select="$item/@lineNumber"/>
            <xsl:for-each select="/cXML/Request/OrderRequest/ItemOut[@parentLineNumber = $parentLine]">
                <xsl:element name="pidx:OrderCreateSubLineItem">
                    <xsl:call-template name="createlineitems">
                        <xsl:with-param name="item" select="."/>
                        <xsl:with-param name="isSubLine" select="'true'"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="AllowanceOrCharge">
        <xsl:param name="AlloworCharge"/>
        <xsl:element name="pidx:AllowanceOrCharge">
            <xsl:choose>
                <xsl:when test="exists($AlloworCharge/AdditionalDeduction)">
                    <xsl:attribute name="allowanceOrChargeIndicator">
                        <xsl:text>Allowance</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="exists($AlloworCharge/AdditionalCost)">
                    <xsl:attribute name="allowanceOrChargeIndicator">
                        <xsl:text>Charge</xsl:text>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!-- IG-2872 -->
            <xsl:choose>
                <xsl:when test="$AlloworCharge/AdditionalDeduction/DeductionAmount/Money != ''">
                    <xsl:element name="pidx:AllowanceOrChargeTotalAmount">
                        <xsl:element name="pidx:MonetaryAmount">
                            <xsl:call-template name="formatAmount">
                                <xsl:with-param name="amount" select="$AlloworCharge/AdditionalDeduction/DeductionAmount/Money"/>
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:element name="pidx:CurrencyCode">
                            <xsl:value-of select="$AlloworCharge/AdditionalDeduction/DeductionAmount/Money/@currency"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$AlloworCharge/AdditionalCost/Money != ''">
                    <xsl:element name="pidx:AllowanceOrChargeTotalAmount">
                        <xsl:element name="pidx:MonetaryAmount">
                            <xsl:call-template name="formatAmount">
                                <xsl:with-param name="amount" select="$AlloworCharge/AdditionalCost/Money"/>
                            </xsl:call-template>
                            <!--<xsl:value-of select="$AlloworCharge/AdditionalCost/Money"/>-->
                        </xsl:element>
                        <xsl:element name="pidx:CurrencyCode">
                            <xsl:value-of select="$AlloworCharge/AdditionalCost/Money/@currency"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$AlloworCharge/AdditionalDeduction/DeductionPercent/@percent != ''">
                    <xsl:element name="pidx:AllowanceOrChargePercent">
                        <xsl:value-of select="$AlloworCharge/AdditionalDeduction/DeductionPercent/@percent"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="$AlloworCharge/AdditionalCost/Percentage/@percent != ''">
                    <xsl:element name="pidx:AllowanceOrChargePercent">
                        <xsl:value-of select="$AlloworCharge/AdditionalCost/Percentage/@percent"/>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="$AlloworCharge/ModificationDetail/@name != ''">
                <xsl:element name="pidx:AllowanceOrChargeNumber">
                    <xsl:value-of select="$AlloworCharge/ModificationDetail/@name"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="pidx:AllowanceOrChargeDescription">
                <xsl:value-of select="$AlloworCharge/ModificationDetail/Description"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="UOMCodeConversion">
        <xsl:param name="UOMCode"/>
        <xsl:choose>
            <xsl:when
                test="lower-case($anANSILookupFlag) = 'true' and $cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[CXMLCode = $UOMCode]/PIDXCode != ''">
                <xsl:element name="pidx:UnitOfMeasureCode">
                    <xsl:value-of select="$cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[CXMLCode = $UOMCode]/PIDXCode"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="pidx:UnitOfMeasureCode">
                    <xsl:value-of select="$UOMCode"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
