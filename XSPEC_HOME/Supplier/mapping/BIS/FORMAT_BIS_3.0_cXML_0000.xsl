<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:n0="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" exclude-result-prefixes="#all"
    version="2.0">

    <xsl:template name="formatDate">
        <xsl:param name="DocDate"/>
        <xsl:variable name="timePart" select="substring($DocDate, 11)"/>
        <xsl:choose>
            <xsl:when test="contains($DocDate, 'T') and (contains($timePart, '+') or contains($timePart, '-'))">
                <xsl:value-of select="$DocDate"/>
            </xsl:when>
            <xsl:when test="contains($DocDate, 'T')">
                <xsl:value-of select="concat($DocDate, $anSenderDefaultTimeZone)"/>
            </xsl:when>
            <xsl:when test="string-length($timePart) &gt; 0">
                <xsl:variable name="datePart" select="substring($DocDate, 1, 10)"/>
                <xsl:value-of select="concat($datePart, 'T00:00:00', $timePart)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($DocDate, 'T00:00:00', $anSenderDefaultTimeZone)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="CreateContact">
        <xsl:param name="partyInfo"/>
        <xsl:param name="partyRole"/>
        <Name>
            <xsl:attribute name="xml:lang">en</xsl:attribute>
            <xsl:choose>
                <xsl:when test="$partyInfo/cac:PartyName/cbc:Name != ''">
                    <xsl:value-of select="$partyInfo/cac:PartyName/cbc:Name"/>
                </xsl:when>
                <xsl:when test="$partyInfo/cac:PartyLegalEntity/cbc:RegistrationName != ''">
                    <xsl:value-of select="$partyInfo/cac:PartyLegalEntity/cbc:RegistrationName"/>
                </xsl:when>
                <xsl:otherwise>Not Provided</xsl:otherwise>
            </xsl:choose>
        </Name>
        <PostalAddress>
            <xsl:choose>
                <xsl:when
                    test="$partyInfo/cac:PostalAddress/cbc:StreetName != '' or $partyInfo/cac:PostalAddress/cbc:AdditionalStreetName != '' or $partyInfo/cac:PostalAddress/cac:AddressLine != '' or $partyInfo/cac:PostalAddress/cac:AddressLine/cbc:Line != ''">
                    <xsl:if test="$partyInfo/cac:PostalAddress/cbc:StreetName != ''">
                        <Street>
                            <xsl:value-of select="$partyInfo/cac:PostalAddress/cbc:StreetName"/>
                        </Street>
                    </xsl:if>
                    <xsl:if test="$partyInfo/cac:PostalAddress/cbc:AdditionalStreetName != ''">
                        <Street>
                            <xsl:value-of
                                select="$partyInfo/cac:PostalAddress/cbc:AdditionalStreetName"/>
                        </Street>
                    </xsl:if>
                    <xsl:if test="$partyInfo/cac:PostalAddress/cac:AddressLine != ''">
                        <Street>
                            <xsl:value-of select="$partyInfo/cac:PostalAddress/cac:AddressLine"/>
                        </Street>
                    </xsl:if>
                    <xsl:if test="$partyInfo/cac:PostalAddress/cac:AddressLine/cbc:Line != ''">
                        <Street>
                            <xsl:value-of
                                select="$partyInfo/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
                        </Street>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <Street> </Street>
                </xsl:otherwise>
            </xsl:choose>
            <City>
                <xsl:value-of select="$partyInfo/cac:PostalAddress/cbc:CityName"/>
            </City>
            <State>
                <xsl:value-of select="$partyInfo/cac:PostalAddress/cbc:CountrySubentity"/>
            </State>
            <xsl:if test="$partyInfo/cac:PostalAddress/cbc:PostalZone != ''">
                <PostalCode>
                    <xsl:value-of select="$partyInfo/cac:PostalAddress/cbc:PostalZone"/>
                </PostalCode>
            </xsl:if>
            <Country>
                <xsl:attribute name="isoCountryCode">
                    <xsl:value-of
                        select="$partyInfo/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
                </xsl:attribute>
                <xsl:variable name="isoCountry">
                    <xsl:value-of select="$partyInfo/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
                </xsl:variable>
                <xsl:if test="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode != ''">
                    <xsl:value-of select="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode"/>
                </xsl:if>                
                
            </Country>
        </PostalAddress>
        <xsl:if test="$partyInfo/cac:Contact/cbc:ElectronicMail != ''">
            <Email>                
                <xsl:value-of select="$partyInfo/cac:Contact/cbc:ElectronicMail"/>
            </Email>
        </xsl:if>

        <xsl:if test="$partyInfo/cac:Contact/cbc:Telephone != ''">
            <Phone>                
                <TelephoneNumber>
                    <CountryCode>
                        <xsl:attribute name="isoCountryCode">
                            <xsl:value-of
                                select="$partyInfo/cac:PostalAddress/cac:Country/cbc:IdentificationCode"
                            />
                        </xsl:attribute>
                    </CountryCode>
                    <AreaOrCityCode> </AreaOrCityCode>
                    <Number>
                        <xsl:value-of select="$partyInfo/cac:Contact/cbc:Telephone"/>
                    </Number>
                    <!--<Extension/>-->
                </TelephoneNumber>
            </Phone>
        </xsl:if>
        
    </xsl:template>
    <!-- outSide Contact IdReference -->
    <xsl:template name="CreateIdReference">
        <xsl:param name="partyInfo"/>
        <xsl:param name="partyRole"/>
        
       
        <xsl:if test="$partyRole != 'correspondent'">
            <xsl:if test="$partyInfo/cac:Contact/cbc:Name != ''">
                <IdReference>
                    <xsl:attribute name="identifier">
                        <xsl:value-of select="$partyInfo/cac:Contact/cbc:Name"/>
                    </xsl:attribute>
                    <xsl:attribute name="domain">contactPerson</xsl:attribute>
                </IdReference>
            </xsl:if>
            <!-- vatID -->
            <xsl:if
                test="($partyInfo/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)[1] != ''">
                <IdReference>
                    <xsl:attribute name="identifier">
                        <xsl:value-of
                            select="($partyInfo/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)[1]"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="domain">vatID</xsl:attribute>
                </IdReference>
            </xsl:if>
            <!-- GST -->
            <xsl:if
                test="($partyInfo/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'GST']/cbc:CompanyID)[1] != ''">
                <IdReference>
                    <xsl:attribute name="identifier">
                        <xsl:value-of
                            select="($partyInfo/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'GST']/cbc:CompanyID)[1]"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="domain">gstID</xsl:attribute>
                </IdReference>
            </xsl:if>
            
            <xsl:if test="$partyInfo/cbc:EndpointID/@schemeID != '' and $partyInfo/cbc:EndpointID/@schemeID != '0204'">
                <IdReference>
                    <xsl:attribute name="identifier">
                        <xsl:value-of select="$partyInfo/cbc:EndpointID"/>
                    </xsl:attribute>
                    <xsl:attribute name="domain">
                        <xsl:choose>
                            <xsl:when test="$partyInfo/cbc:EndpointID/@schemeID = '0060'"
                                >DUNS</xsl:when>
                            <xsl:when test="$partyInfo/cbc:EndpointID/@schemeID = '0088'"
                                >EANID</xsl:when>                            
                            <xsl:otherwise>
                                <xsl:value-of select="$partyInfo/cbc:EndpointID/@schemeID"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </IdReference>
            </xsl:if>
            
            <xsl:if test="$partyRole = 'from'">
                <!-- SupplierTaxID should be only for FROM not for SoldTo or BillTo Etc.. -->
                <xsl:if
                    test="($partyInfo/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID != 'VAT' and cac:TaxScheme/cbc:ID != 'GST']/cbc:CompanyID)[1] != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="($partyInfo/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID != 'VAT' and cac:TaxScheme/cbc:ID != 'GST']/cbc:CompanyID)[1]"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">supplierTaxID</xsl:attribute>
                    </IdReference>
                </xsl:if>
                <xsl:for-each select="$partyInfo/cac:PartyIdentification">
                    <xsl:variable name="position" select="position()"/>
                    <xsl:if test="$position > 1">                        
                        <IdReference>
                            <xsl:attribute name="identifier">
                                <xsl:value-of select="cbc:ID"/>
                            </xsl:attribute>
                            
                            <xsl:attribute name="domain">
                                <xsl:choose>
                                    <xsl:when test="cbc:ID/@schemeID = '0060'">DUNS</xsl:when>
                                    <xsl:when test="cbc:ID/@schemeID = '0088'">EANID</xsl:when>
                                    <xsl:when test="cbc:ID/@schemeID = 'SEPA'">creditorRefID</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="cbc:ID/@schemeID"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </IdReference>
                    </xsl:if>
                </xsl:for-each>               
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!-- createMoney -->
    <xsl:template name="createMoney">
        <xsl:param name="curr"/>
        <xsl:param name="money"/>
        <xsl:param name="altAmt"/>
        <xsl:param name="AltCurr"/>

        <xsl:variable name="mainMoney">
            <xsl:choose>
                <xsl:when test="string($money) != ''">
                    <xsl:value-of select="$money"/>
                </xsl:when>
                <xsl:otherwise>0.00</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--<xsl:variable name="moneyVal">
            <xsl:choose>
                <xsl:when test="$isLineNegPriceAdjustment = 'yes'">
                    <xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
                </xsl:when>
                <xsl:when test="$isLineNegPriceAdjustment = 'no'">
                    <xsl:value-of select="$mainMoney"/>
                </xsl:when>
                <xsl:when test="$isCreditMemo = 'yes'">
                    <xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mainMoney"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>-->
        <xsl:variable name="currency">
            <xsl:choose>
                <xsl:when test="$curr != ''">
                    <xsl:value-of select="$curr"/>
                </xsl:when>
                <!--<xsl:otherwise>
                    <xsl:value-of select="$HCur"/>
                </xsl:otherwise>-->
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="Money">
            <xsl:attribute name="currency">
                <xsl:value-of select="$currency"/>
            </xsl:attribute>
            <xsl:if test="$AltCurr != '' and $altAmt != ''">
                <xsl:attribute name="alternateCurrency">
                    <xsl:value-of select="$AltCurr"/>
                </xsl:attribute>
                <xsl:attribute name="alternateAmount">
                    <xsl:value-of select="$altAmt"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$money castable as xs:decimal and xs:decimal($money) = 0">
                    <xsl:value-of select="replace(string($money), '-', '')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$money"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="LineItem">
        <xsl:param name="Type"/>
        <xsl:param name="invType"/>
        <xsl:param name="itemMode"/> 
        
            <xsl:attribute name="invoiceLineNumber">
                <xsl:value-of select="cbc:ID"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$Type = 'Invoice'">
                    <xsl:attribute name="quantity">
                        <xsl:choose>
                            <!-- for Line Level CreditMemo change -ve value to +ve -->
                            <xsl:when test="$invType = 'lineLevelCreditMemo'">
                                <xsl:value-of select="replace(cbc:InvoicedQuantity, '-', '')"
                                /> </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="cbc:InvoicedQuantity"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="$Type = 'CreditNote'">                    
                        <xsl:attribute name="quantity">
                            <xsl:choose>
                                <!-- for Line Level CreditMemo change -ve value to +ve -->
                                <xsl:when test="$invType = 'lineLevelCreditMemo'">
                                    <xsl:value-of select="replace(cbc:CreditedQuantity, '-', '')"
                                    /></xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="cbc:CreditedQuantity"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                </xsl:when>
            </xsl:choose>

    <xsl:if test="$itemMode = 'InvoiceDetailServiceItem'">
        <xsl:element name="InvoiceDetailServiceItemReference">               
            <xsl:attribute name="lineNumber">
                <xsl:choose>
                    <xsl:when test="cac:OrderLineReference/cbc:LineID != ''">
                        <xsl:value-of select="cac:OrderLineReference/cbc:LineID"/>
                    </xsl:when>
                    <xsl:otherwise>''</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>                
            
            <xsl:if
                test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode != ''">
                <Classification>
                    <xsl:attribute name="domain">UNSPSC</xsl:attribute>
                    <xsl:if
                        test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode/@listVersionID != ''">
                        <xsl:attribute name="code">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode/@listVersionID"
                            />
                        </xsl:attribute>
                        <xsl:value-of
                            select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode"
                        />
                    </xsl:if>
                </Classification>
            </xsl:if>
            <ItemID>
                <SupplierPartID>
                    <xsl:choose>
                        <xsl:when test="cac:Item/cac:SellersItemIdentification/cbc:ID != ''">
                            <xsl:value-of select="cac:Item/cac:SellersItemIdentification/cbc:ID"
                            />
                        </xsl:when>
                        <xsl:when
                            test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VN']/cbc:ItemClassificationCode != ''">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VN']/cbc:ItemClassificationCode"
                            />
                        </xsl:when>
                        <xsl:when
                            test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'SA']/cbc:ItemClassificationCode != ''">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'SA']/cbc:ItemClassificationCode"
                            />
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </SupplierPartID>
                <xsl:if
                    test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VS']/cbc:ItemClassificationCode != ''">
                    <SupplierPartAuxiliaryID>
                        <xsl:value-of
                            select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VS']/cbc:ItemClassificationCode"
                        />
                    </SupplierPartAuxiliaryID>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="cac:Item/cac:BuyersItemIdentification/cbc:ID != ''">
                        <BuyerPartID>
                            <xsl:value-of select="cac:Item/cac:BuyersItemIdentification/cbc:ID"
                            />
                        </BuyerPartID>
                    </xsl:when>
                    <xsl:when
                        test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'BP']/cbc:ItemClassificationCode != ''">
                        <BuyerPartID>
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'BP']/cbc:ItemClassificationCode"
                            />
                        </BuyerPartID>
                    </xsl:when>
                </xsl:choose>
                <xsl:if
                    test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'UP']/cbc:ItemClassificationCode != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'UP']/cbc:ItemClassificationCode"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">UPCUniversalProductCode</xsl:attribute>
                    </IdReference>
                </xsl:if>
                <xsl:if
                    test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TSR']/cbc:ItemClassificationCode != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TSR']/cbc:ItemClassificationCode"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">europeanWasteCatalogID</xsl:attribute>
                    </IdReference>
                </xsl:if>
            </ItemID>
            
            <xsl:if test="normalize-space(cac:Item/cbc:Description) != ''">
                <Description>
                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                    <xsl:if test="normalize-space(cac:Item/cbc:Name) != ''">
                        <ShortName>
                            <xsl:value-of select="cac:Item/cbc:Name"/>
                        </ShortName>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(cac:Item/cbc:Description)"/>
                </Description>
            </xsl:if>
        </xsl:element>
        <!-- ServiceEntryItemReference -->
        <xsl:if
            test="cac:DocumentReference[cbc:ID/@schemeID = 'ACE']/cbc:ID != ''">
            <ServiceEntryItemReference>
                <xsl:attribute name="serviceLineNumber">
                    <xsl:value-of
                        select="cac:DocumentReference[cbc:ID/@schemeID = 'ACE']/cbc:ID"
                    />
                </xsl:attribute>
                <xsl:if test="cac:DocumentReference[cbc:ID/@schemeID = 'AGT']/cbc:ID!=''">
                    <xsl:attribute name="ServiceEntryID">
                        <xsl:value-of
                            select="cac:DocumentReference[cbc:ID/@schemeID = 'AGT']/cbc:ID"
                        />
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="cac:DocumentReference[cbc:ID/@schemeID = 'ACD']/cbc:ID!=''">
                    <xsl:attribute name="ServiceEntryDate">
                        <xsl:call-template name="formatDate">
                            <xsl:with-param name="DocDate"
                                select="cac:DocumentReference[cbc:ID/@schemeID = 'ACD']/cbc:ID"/>
                        </xsl:call-template>                        
                    </xsl:attribute>
                </xsl:if>
                <DocumentReference>
                    <xsl:attribute name="payloadID"> </xsl:attribute>
                </DocumentReference>
            </ServiceEntryItemReference>
        </xsl:if>            
        <!-- SubtotalAmount -->
        <xsl:if
            test="cbc:LineExtensionAmount != '' and cbc:LineExtensionAmount/@currencyID != ''">
            <SubtotalAmount>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr" select="cbc:LineExtensionAmount/@currencyID"/>
                    <xsl:with-param name="money" select="cbc:LineExtensionAmount"/>
                </xsl:call-template>
            </SubtotalAmount>
        </xsl:if>
        <!-- Period -->
        <xsl:if test="cac:InvoicePeriod/cbc:StartDate!='' and cac:InvoicePeriod/cbc:EndDate!=''">
            <Period>
                <xsl:attribute name="startDate">
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                            select="cac:InvoicePeriod/cbc:StartDate"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="endDate">
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                            select="cac:InvoicePeriod/cbc:EndDate"/>
                    </xsl:call-template>
                </xsl:attribute>
            </Period>
        </xsl:if>
    </xsl:if>
    <!-- UnitOfMeasure -->
    <xsl:choose>
        <xsl:when test="$Type = 'Invoice'">
            <!-- UnitOfMeasure -->
            <UnitOfMeasure>
                <xsl:value-of select="cbc:InvoicedQuantity/@unitCode"/>                
            </UnitOfMeasure>
        </xsl:when>
        <xsl:when test="$Type = 'CreditNote'">            
            <!-- UnitOfMeasure -->
            <UnitOfMeasure>
                <xsl:value-of select="cbc:CreditedQuantity/@unitCode"/>                
            </UnitOfMeasure>
        </xsl:when>
    </xsl:choose>
            <!-- UnitPrice -->
    <UnitPrice>
        <xsl:call-template name="createMoney">
            <xsl:with-param name="curr" select="cac:Price/cbc:PriceAmount/@currencyID"/>
            <xsl:with-param name="money" select="cac:Price/cbc:PriceAmount"/>
        </xsl:call-template>
        <xsl:if
            test="cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator = 'false' or cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator = 'true'">
            <Modifications>
                <xsl:if test="cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator = 'false'">
                    <Modification>
                        <xsl:if
                            test="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:BaseAmount != ''">
                            <OriginalPrice>
                                <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                        select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:BaseAmount/@currencyID"/>
                                    <xsl:with-param name="money"
                                        select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:BaseAmount"
                                    />
                                </xsl:call-template>
                            </OriginalPrice>
                        </xsl:if>
                        <!-- AdditionalDeduction -->
                        <AdditionalDeduction>
                            <DeductionAmount>
                                <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                        select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:Amount/@currencyID"/>
                                    <xsl:with-param name="money"
                                        select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:Amount"
                                    />
                                </xsl:call-template>
                            </DeductionAmount>
                        </AdditionalDeduction>
                    </Modification>
                </xsl:if>
                <xsl:if test="cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator = 'true'">
                    <Modification>
                        <xsl:if
                            test="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:BaseAmount != ''">
                            <OriginalPrice>
                                <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                        select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:BaseAmount/@currencyID"/>
                                    <xsl:with-param name="money"
                                        select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:BaseAmount"
                                    />
                                </xsl:call-template>
                            </OriginalPrice>
                        </xsl:if>
                        <!-- AdditionalCost -->
                        <AdditionalCost>
                            <xsl:call-template name="createMoney">
                                <xsl:with-param name="curr"
                                    select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:Amount/@currencyID"/>
                                <xsl:with-param name="money"
                                    select="cac:Price/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:Amount"
                                />
                            </xsl:call-template>
                        </AdditionalCost>
                    </Modification>
                </xsl:if>
            </Modifications>
        </xsl:if>
    </UnitPrice>
            <!-- PriceBasisQuantity -->
            <xsl:if test="cac:Price/cbc:BaseQuantity != ''">
                 <PriceBasisQuantity>
            <xsl:attribute name="quantity">
                <xsl:value-of select="cac:Price/cbc:BaseQuantity"/>
            </xsl:attribute>
            <xsl:attribute name="conversionFactor">1</xsl:attribute>
            <xsl:variable name="length" select="string-length(cac:Price/cbc:BaseQuantity/@unitCode)"/>
            <!-- UnitOfMeasure -->
            <UnitOfMeasure>
                <xsl:value-of select="cac:Price/cbc:BaseQuantity/@unitCode"/>                        
            </UnitOfMeasure>
        </PriceBasisQuantity>
    </xsl:if>
    <xsl:if test="$itemMode='InvoiceDetailItem'">
        <InvoiceDetailItemReference>
            <xsl:attribute name="lineNumber">
                <xsl:choose>
                    <xsl:when test="cac:OrderLineReference/cbc:LineID != ''">
                        <xsl:value-of select="cac:OrderLineReference/cbc:LineID"/>
                    </xsl:when>
                    <xsl:otherwise>''</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <ItemID>
                <SupplierPartID>
                    <xsl:choose>
                        <xsl:when test="cac:Item/cac:SellersItemIdentification/cbc:ID != ''">
                            <xsl:value-of select="cac:Item/cac:SellersItemIdentification/cbc:ID"
                            />
                        </xsl:when>
                        <xsl:when
                            test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VN']/cbc:ItemClassificationCode != ''">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VN']/cbc:ItemClassificationCode"
                            />
                        </xsl:when>
                        
                        <xsl:otherwise/>
                    </xsl:choose>
                </SupplierPartID>
                <xsl:if
                    test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VS']/cbc:ItemClassificationCode != ''">
                    <SupplierPartAuxiliaryID>
                        <xsl:value-of
                            select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'VS']/cbc:ItemClassificationCode"
                        />
                    </SupplierPartAuxiliaryID>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="cac:Item/cac:BuyersItemIdentification/cbc:ID != ''">
                        <BuyerPartID>
                            <xsl:value-of select="cac:Item/cac:BuyersItemIdentification/cbc:ID"
                            />
                        </BuyerPartID>
                    </xsl:when>
                    <xsl:when
                        test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'BP']/cbc:ItemClassificationCode != ''">
                        <BuyerPartID>
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'BP']/cbc:ItemClassificationCode"
                            />
                        </BuyerPartID>
                    </xsl:when>
                </xsl:choose>
                
                
                <xsl:if
                    test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'UP']/cbc:ItemClassificationCode != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'UP']/cbc:ItemClassificationCode"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">UPCUniversalProductCode</xsl:attribute>
                    </IdReference>
                </xsl:if>
                <xsl:if
                    test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TSR']/cbc:ItemClassificationCode != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TSR']/cbc:ItemClassificationCode"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">europeanWasteCatalogID</xsl:attribute>
                    </IdReference>
                </xsl:if>
            </ItemID>
            
            <xsl:if test="normalize-space(cac:Item/cbc:Description) != ''">
                <Description>
                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                    <xsl:if test="normalize-space(cac:Item/cbc:Name) != ''">
                        <ShortName>
                            <xsl:value-of select="cac:Item/cbc:Name"/>
                        </ShortName>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(cac:Item/cbc:Description)"/>
                </Description>
            </xsl:if>
            <xsl:if
                test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode != ''">
                <Classification>
                    <xsl:attribute name="domain">UNSPSC</xsl:attribute>
                    <xsl:if
                        test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode/@listVersionID != ''">
                        <xsl:attribute name="code">
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode/@listVersionID"
                            />
                        </xsl:attribute>
                        <xsl:value-of
                            select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'TST']/cbc:ItemClassificationCode"
                        />
                    </xsl:if>
                </Classification>
            </xsl:if>
            
            
            <xsl:variable name="isoCountry">
                <xsl:value-of select="cac:Item/cac:OriginCountry/cbc:IdentificationCode"/>
            </xsl:variable>
            <xsl:if test="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode != ''">
                <Country>
                    <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$Lookup/Lookups/isoCountryCodes/isoCountryCode[UBL = $isoCountry]/CXMLCode"/>
                    </xsl:attribute>
                </Country>
                
            </xsl:if>
            
            
            <xsl:if
                test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'SN']/cbc:ItemClassificationCode != ''">
                <SerialNumber>
                    <xsl:value-of
                        select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'SN']/cbc:ItemClassificationCode"
                    />
                </SerialNumber>
            </xsl:if>
            <xsl:if test="cac:DocumentReference[cbc:ID/@schemeID = 'BT']/cbc:ID!=''">
                <xsl:attribute name="SupplierBatchID">
                    <xsl:value-of
                        select="cac:DocumentReference[cbc:ID/@schemeID = 'BT']/cbc:ID"
                    />
                </xsl:attribute>
            </xsl:if>
            <xsl:if
                test="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'EN']/cbc:ItemClassificationCode != ''">
                <InvoiceDetailItemReferenceIndustry>
                    <InvoiceDetailItemReferenceRetail>
                        <EANID>
                            <xsl:value-of
                                select="cac:Item/cac:CommodityClassification[cbc:ItemClassificationCode/@listID = 'EN']/cbc:ItemClassificationCode"
                            />
                        </EANID>
                    </InvoiceDetailItemReferenceRetail>
                </InvoiceDetailItemReferenceIndustry>
            </xsl:if>
        </InvoiceDetailItemReference>
        <!-- ServiceEntryItemReference-->
        <xsl:if
            test="cac:DocumentReference[cbc:ID/@schemeID = 'ACE' or cbc:ID/@schemeID = 'AGT' or cbc:ID/@schemeID = 'ACD']/cbc:ID != ''">
            <ServiceEntryItemReference>
                <xsl:if test="cac:DocumentReference[cbc:ID/@schemeID = 'ACE']/cbc:ID!=''">
                    <xsl:attribute name="serviceLineNumber">
                        <xsl:value-of
                            select="cac:DocumentReference[cbc:ID/@schemeID = 'ACE']/cbc:ID"
                        />
                    </xsl:attribute>
                </xsl:if>
                
                <xsl:if test="cac:DocumentReference[cbc:ID/@schemeID = 'AGT']/cbc:ID!=''">
                    <xsl:attribute name="serviceEntryID">
                        <xsl:value-of
                            select="cac:DocumentReference[cbc:ID/@schemeID = 'AGT']/cbc:ID"
                        />
                    </xsl:attribute>
                </xsl:if>
                
                <xsl:if test="cac:DocumentReference[cbc:ID/@schemeID = 'ACD']/cbc:ID!=''">
                    <xsl:attribute name="serviceEntryDate">
                        <xsl:call-template name="formatDate">
                            <xsl:with-param name="DocDate" select="cac:DocumentReference[cbc:ID/@schemeID = 'ACD']/cbc:ID"/>
                        </xsl:call-template>                            
                    </xsl:attribute>
                </xsl:if>
                <DocumentReference>
                    <xsl:attribute name="payloadID"> </xsl:attribute>
                </DocumentReference>
            </ServiceEntryItemReference>
        </xsl:if>
        <!-- SubtotalAmount -->
        <xsl:if
            test="cbc:LineExtensionAmount != '' and cbc:LineExtensionAmount/@currencyID != ''">
            <SubtotalAmount>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr" select="cbc:LineExtensionAmount/@currencyID"/>
                    <xsl:with-param name="money" select="cbc:LineExtensionAmount"/>
                </xsl:call-template>
            </SubtotalAmount>
        </xsl:if>
    </xsl:if>
              
            <!-- Tax -->
    <xsl:if test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID!=''">
        <Tax>
            <xsl:variable name="currency">
                <xsl:value-of select="../cbc:DocumentCurrencyCode"/>
            </xsl:variable>
            <Money>
                <xsl:attribute name="currency">
                    <xsl:value-of select="$currency"/>
                </xsl:attribute>
                <xsl:value-of select="' '"/>
            </Money>
            <Description>
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:value-of select="' '"/>
            </Description>
            <TaxDetail>
                <xsl:attribute name="category">
                    <xsl:value-of select="lower-case(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID)"/>
                </xsl:attribute>
                <xsl:if test="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent!=''">
                    <xsl:attribute name="percentageRate">
                        <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                    </xsl:attribute>
                </xsl:if>
                
                <TaxAmount>
                    <Money>
                        <xsl:attribute name="currency">
                            <xsl:value-of select="$currency"/>
                        </xsl:attribute>
                        <xsl:value-of select="' '"/>
                    </Money>
                </TaxAmount>
                
                <xsl:if test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID!='' and cac:Item/cac:ClassifiedTaxCategory/cbc:ID!='S'">
                    <TaxExemption>
                        <xsl:attribute name="exemptCode">
                            <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
                        </xsl:attribute>
                    </TaxExemption>
                </xsl:if>
            </TaxDetail>
        </Tax>
    </xsl:if>
    
    <xsl:if test="$itemMode='InvoiceDetailItem'">
        <!-- InvoiceDetailLineSpecialHandling -->
        <xsl:if
            test="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SH']/cbc:Amount != ''">
            <InvoiceDetailLineSpecialHandling>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SH']/cbc:Amount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SH']/cbc:Amount"
                    />
                </xsl:call-template>
                
            </InvoiceDetailLineSpecialHandling>
        </xsl:if>
        <!-- InvoiceDetailLineShipping -->
        <xsl:if
            test="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SAA']/cbc:Amount != ''">
            <InvoiceDetailLineShipping>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SAA']/cbc:Amount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SAA']/cbc:Amount"
                    />
                </xsl:call-template>
                
            </InvoiceDetailLineShipping>
        </xsl:if>
        
        <!-- ShipNoticeIDInfo -->
        <xsl:if
            test="cac:DocumentReference[cbc:ID/@schemeID = 'MA']/cbc:ID != ''">
            <ShipNoticeIDInfo>
                <xsl:attribute name="shipNoticeID">
                    <xsl:value-of
                        select="cac:DocumentReference[cbc:ID/@schemeID = 'MA']/cbc:ID"
                    />
                </xsl:attribute>
                
                <xsl:if
                    test="cac:DocumentReference[cbc:ID/@schemeID = 'DQ']/cbc:ID != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="cac:DocumentReference[cbc:ID/@schemeID = 'DQ']/cbc:ID"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">deliveryNoteID</xsl:attribute>
                    </IdReference>
                </xsl:if>
                
                <xsl:if
                    test="cac:DocumentReference[cbc:ID/@schemeID = 'ALO']/cbc:ID != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="cac:DocumentReference[cbc:ID/@schemeID = 'ALO']/cbc:ID"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">ReceivingAdviceID</xsl:attribute>
                    </IdReference>
                </xsl:if>
                <xsl:if
                    test="cac:DocumentReference[cbc:ID/@schemeID = 'PK']/cbc:ID != ''">
                    <IdReference>
                        <xsl:attribute name="identifier">
                            <xsl:value-of
                                select="cac:DocumentReference[cbc:ID/@schemeID = 'PK']/cbc:ID"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="domain">packListID</xsl:attribute>
                    </IdReference>
                </xsl:if>
            </ShipNoticeIDInfo>
        </xsl:if>
    </xsl:if>
            
            <!-- InvoiceDetailDiscount -->
            <xsl:if
                test="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:MultiplierFactorNumeric != '' and cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:Amount != ''">
                <InvoiceDetailDiscount>
                    <xsl:attribute name="percentageRate">
                        <xsl:value-of
                            select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:MultiplierFactorNumeric"
                        />
                    </xsl:attribute>
                    <xsl:call-template name="createMoney">
                        <xsl:with-param name="curr"
                            select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:Amount/@currencyID"/>
                        <xsl:with-param name="money"
                            select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:Amount"
                        />
                    </xsl:call-template>

                </InvoiceDetailDiscount>
            </xsl:if>
            <!-- InvoiceItemModifications -->
            <xsl:if
                test="cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] or cac:AllowanceCharge[cbc:ChargeIndicator = 'true']">
                <InvoiceItemModifications>
                    <xsl:for-each
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' or cbc:ChargeIndicator = 'true']">
                        <Modification>
                            <xsl:if test="cbc:BaseAmount != ''">
                                <OriginalPrice>
                                    <xsl:call-template name="createMoney">
                                        <xsl:with-param name="curr"
                                            select="cbc:BaseAmount/@currencyID"/>
                                        <xsl:with-param name="money" select="cbc:BaseAmount"/>
                                    </xsl:call-template>
                                </OriginalPrice>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="cbc:ChargeIndicator = 'false'">
                                    <AdditionalDeduction>
                                        <xsl:choose>
                                            <xsl:when test="cbc:Amount != ''">
                                                <DeductionAmount>
                                                  <xsl:call-template name="createMoney">
                                                  <xsl:with-param name="curr"
                                                  select="cbc:Amount/@currencyID"/>
                                                  <xsl:with-param name="money" select="cbc:Amount"/>
                                                  </xsl:call-template>
                                                </DeductionAmount>
                                            </xsl:when>
                                            <xsl:when test="cbc:MultiplierFactorNumeric != ''">
                                                <DeductionPercent>
                                                  <xsl:attribute name="percent">
                                                  <xsl:value-of select="cbc:MultiplierFactorNumeric"
                                                  />
                                                  </xsl:attribute>
                                                </DeductionPercent>
                                            </xsl:when>
                                        </xsl:choose>
                                    </AdditionalDeduction>
                                </xsl:when>
                                <xsl:when test="cbc:ChargeIndicator = 'true'">
                                    <AdditionalCost>
                                        <xsl:choose>
                                            <xsl:when test="cbc:Amount != ''">
                                                <xsl:call-template name="createMoney">
                                                  <xsl:with-param name="curr"
                                                  select="cbc:Amount/@currencyID"/>
                                                  <xsl:with-param name="money" select="cbc:Amount"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:when test="cbc:MultiplierFactorNumeric != ''">
                                                <Percentage>
                                                  <xsl:attribute name="percent">
                                                  <xsl:value-of select="cbc:MultiplierFactorNumeric"
                                                  />
                                                  </xsl:attribute>
                                                </Percentage>
                                            </xsl:when>
                                        </xsl:choose>
                                    </AdditionalCost>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:variable name="name">
                                <xsl:choose>
                                    <xsl:when test="cbc:ChargeIndicator = 'false'">
                                        <xsl:choose>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = '42'"
                                                >Allowance</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = '64'"
                                                >ContractAllowance</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = '88'"
                                                >Surcharge</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = '95'"
                                                >Maps Separately</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = '100'"
                                                >Discount-Special</xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="cbc:AllowanceChargeReasonCode"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="cbc:ChargeIndicator = 'true'">
                                        <xsl:choose>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'ABL'"
                                                >PackagingSurcharge</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'ADR'"
                                                >OtherServices</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'AEL'"
                                                >SmallOrderCharge</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'AJ'"
                                                >Adjustment</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'FAC'"
                                                >FreightBasedOnDollarMinimum</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'FC'"
                                                >Freight</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'HD'"
                                                >Handling</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'SAA'"
                                                >Maps separately</xsl:when>
                                            <xsl:when test="cbc:AllowanceChargeReasonCode = 'SH'"
                                                >Maps separately</xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="cbc:AllowanceChargeReasonCode"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:variable>
                            <ModificationDetail>                                
                                <xsl:attribute name="name">
                                    <xsl:value-of select="normalize-space($name)"/>
                                </xsl:attribute>                                
                            </ModificationDetail>
                        </Modification>
                    </xsl:for-each>
                </InvoiceItemModifications>
            </xsl:if>
            <!-- Comments -->
            <Comments>
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="'en'"/>
                </xsl:attribute>
                <xsl:value-of select="cbc:Note"/>
            </Comments>
            <!-- Extrinsic -->
            <xsl:for-each select="cac:Item/cac:AdditionalItemProperty">
                <xsl:element name="Extrinsic">
                    <xsl:attribute name="name">
                        <xsl:value-of select="cbc:Name"/>
                    </xsl:attribute>
                    <xsl:value-of select="cbc:Value"/>
                </xsl:element>
            </xsl:for-each>
        
    </xsl:template>

    <xsl:template name="InvoiceDetailSummary">
        <xsl:param name="Type"/>
        <xsl:param name="invType"/>
        <!-- SubtotalAmount -->
        <SubtotalAmount>
            <xsl:call-template name="createMoney">
                <xsl:with-param name="curr"
                    select="cac:LegalMonetaryTotal/cbc:LineExtensionAmount/@currencyID"/>
                <xsl:with-param name="money" select="cac:LegalMonetaryTotal/cbc:LineExtensionAmount"
                />
            </xsl:call-template>
        </SubtotalAmount>

        <!-- Tax -->
        <Tax>
            <xsl:variable name="TaxCurrencyCode">
                <xsl:value-of select="cbc:TaxCurrencyCode"/>
            </xsl:variable>
            <xsl:call-template name="createMoney">
                <xsl:with-param name="curr"
                    select="(cac:TaxTotal[cbc:TaxAmount/@currencyID != $TaxCurrencyCode])/cbc:TaxAmount/@currencyID"/>

                <xsl:with-param name="money"
                    select="(cac:TaxTotal[cbc:TaxAmount/@currencyID != $TaxCurrencyCode])/cbc:TaxAmount"/>
                <xsl:with-param name="altAmt"
                    select="(cac:TaxTotal[cbc:TaxAmount/@currencyID = $TaxCurrencyCode])/cbc:TaxAmount"/>
                <xsl:with-param name="AltCurr"
                    select="(cac:TaxTotal[cbc:TaxAmount/@currencyID = $TaxCurrencyCode])/cbc:TaxAmount/@currencyID"/>

            </xsl:call-template>
            <Description>
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:text>Total Tax</xsl:text>
            </Description>
            <!-- TaxDetail -->
            <xsl:for-each select="cac:TaxTotal[cbc:TaxAmount/@currencyID != $TaxCurrencyCode]">
                <xsl:for-each select="cac:TaxSubtotal[cbc:TaxAmount != '']">                    
                    <TaxDetail>                        
                        <xsl:if
                            test="cac:TaxCategory/cbc:ID != ''">
                            <xsl:attribute name="purpose">
                                <xsl:choose>
                                    <xsl:when
                                        test="cac:TaxCategory/cbc:ID = 'E'"
                                        >Exempt</xsl:when>
                                    <xsl:when
                                        test="cac:TaxCategory/cbc:ID = 'Z'"
                                        >ZeroRated</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="cac:TaxCategory/cbc:ID"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        
                        <xsl:attribute name="category"><xsl:value-of select="lower-case(cac:TaxCategory/cac:TaxScheme/cbc:ID)"/></xsl:attribute>
                        
                        <xsl:if
                            test="cac:TaxCategory/cbc:Percent != ''">
                            <xsl:attribute name="percentageRate">
                                <xsl:value-of
                                    select="cac:TaxCategory/cbc:Percent"
                                />
                            </xsl:attribute>
                        </xsl:if>
                        
                        <xsl:if test="../../cbc:TaxPointDate != ''">
                            <xsl:attribute name="taxPointDate">
                                <xsl:value-of select="../../cbc:TaxPointDate"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if
                            test="cbc:TaxableAmount != ''">
                            <TaxableAmount>
                                <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr"
                                        select="cbc:TaxableAmount/@currencyID"/>
                                    
                                    <xsl:with-param name="money"
                                        select="cbc:TaxableAmount"
                                    />
                                </xsl:call-template>
                            </TaxableAmount>
                        </xsl:if>
                        <TaxAmount>
                            <xsl:call-template name="createMoney">
                                <xsl:with-param name="curr"
                                    select="cbc:TaxAmount/@currencyID"/>
                                
                                <xsl:with-param name="money"
                                    select="cbc:TaxAmount"
                                />
                            </xsl:call-template>
                        </TaxAmount>
                        <xsl:if
                            test="cac:TaxCategory/cbc:ID != '' and cac:TaxCategory/cbc:ID != 'S'">
                            <TaxExemption>
                                <xsl:attribute name="exemptCode">
                                    <xsl:value-of
                                        select="cac:TaxCategory/cbc:ID"
                                    />                               
                                </xsl:attribute>
                                <ExemptReason>
                                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    <xsl:value-of
                                        select="cac:TaxCategory/cbc:TaxExemptionReason"
                                    />
                                </ExemptReason>
                            </TaxExemption>
                        </xsl:if>
                        <xsl:if
                            test="cac:TaxCategory/cbc:ID = 'S'">
                            <xsl:element name="Extrinsic">
                                <xsl:attribute name="name">exemptType</xsl:attribute>
                                <xsl:text>Standard</xsl:text>
                            </xsl:element>
                        </xsl:if>
                        
                    </TaxDetail>
                    
                </xsl:for-each>
            </xsl:for-each>
            
        </Tax>
        <!-- SpecialHandlingAmount -->
        <xsl:if
            test="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SH']">
            <SpecialHandlingAmount>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SH']/cbc:Amount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SH']/cbc:Amount"
                    />
                </xsl:call-template>
            </SpecialHandlingAmount>
        </xsl:if>

        <!-- ShippingAmount -->
        <xsl:if
            test="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SAA']">
            <ShippingAmount>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SAA']/cbc:Amount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'true' and cbc:AllowanceChargeReasonCode = 'SAA']/cbc:Amount"
                    />
                </xsl:call-template>
            </ShippingAmount>
        </xsl:if>
        <!-- GrossAmount -->
        <xsl:if test="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID!='' and cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount!=''">
        <GrossAmount>
            <xsl:call-template name="createMoney">
                <xsl:with-param name="curr"
                    select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID"/>
                <xsl:with-param name="money" select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"
                />
            </xsl:call-template>
        </GrossAmount>
        </xsl:if>
        <!-- InvoiceDetailDiscount -->
        <xsl:if
            test="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:Amount != ''">
            <InvoiceDetailDiscount>
                <xsl:if
                    test="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:MultiplierFactorNumeric != ''">
                    <xsl:attribute name="percentageRate">
                        <xsl:value-of
                            select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:MultiplierFactorNumeric"
                        />
                    </xsl:attribute>
                </xsl:if>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:Amount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' and cbc:AllowanceChargeReasonCode = '95']/cbc:Amount"
                    />
                </xsl:call-template>
            </InvoiceDetailDiscount>
        </xsl:if>
        <!-- InvoiceHeaderModifications -->
        <xsl:if
            test="cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] or cac:AllowanceCharge[cbc:ChargeIndicator = 'true']">
            <InvoiceHeaderModifications>
                <xsl:for-each
                    select="cac:AllowanceCharge[cbc:ChargeIndicator = 'false' or cbc:ChargeIndicator = 'true']">
                    <Modification>
                        <xsl:if test="cbc:BaseAmount != ''">
                            <OriginalPrice>
                                <xsl:call-template name="createMoney">
                                    <xsl:with-param name="curr" select="cbc:BaseAmount/@currencyID"/>
                                    <xsl:with-param name="money" select="cbc:BaseAmount"/>
                                </xsl:call-template>
                            </OriginalPrice>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="cbc:ChargeIndicator = 'false'">
                                <AdditionalDeduction>
                                    <xsl:choose>
                                        <xsl:when test="cbc:Amount != ''">
                                            <DeductionAmount>
                                                <xsl:call-template name="createMoney">
                                                  <xsl:with-param name="curr"
                                                  select="cbc:Amount/@currencyID"/>
                                                  <xsl:with-param name="money" select="cbc:Amount"/>
                                                </xsl:call-template>
                                            </DeductionAmount>
                                        </xsl:when>
                                        <xsl:when test="cbc:MultiplierFactorNumeric != ''">
                                            <DeductionPercent>
                                                <xsl:attribute name="percent">
                                                  <xsl:value-of select="cbc:MultiplierFactorNumeric"
                                                  />
                                                </xsl:attribute>
                                            </DeductionPercent>
                                        </xsl:when>
                                    </xsl:choose>
                                </AdditionalDeduction>
                            </xsl:when>
                            <xsl:when test="cbc:ChargeIndicator = 'true'">
                                <AdditionalCost>
                                    <xsl:choose>
                                        <xsl:when test="cbc:Amount != ''">
                                            <xsl:call-template name="createMoney">
                                                <xsl:with-param name="curr"
                                                  select="cbc:Amount/@currencyID"/>
                                                <xsl:with-param name="money" select="cbc:Amount"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:when test="cbc:MultiplierFactorNumeric != ''">
                                            <Percentage>
                                                <xsl:attribute name="percent">
                                                  <xsl:value-of select="cbc:MultiplierFactorNumeric"
                                                  />
                                                </xsl:attribute>
                                            </Percentage>
                                        </xsl:when>
                                    </xsl:choose>
                                </AdditionalCost>
                            </xsl:when>
                        </xsl:choose>
                        
                        <xsl:if test="cac:TaxCategory/cbc:ID!=''">
                        <Tax>
                            <xsl:variable name="currency">
                                <xsl:value-of select="../cbc:DocumentCurrencyCode"/>
                            </xsl:variable>
                            <Money>
                                <xsl:attribute name="currency">
                                    <xsl:value-of select="$currency"/>
                                </xsl:attribute>
                                <xsl:value-of select="' '"/>
                            </Money>
                            <Description>
                                <xsl:attribute name="xml:lang">en</xsl:attribute>
                                <xsl:value-of select="' '"/>
                            </Description>
                            <TaxDetail>
                                <xsl:attribute name="category">
                                    <xsl:value-of select="lower-case(cac:TaxCategory/cac:TaxScheme/cbc:ID)"/>
                                </xsl:attribute>
                                <xsl:if test="cac:TaxCategory/cbc:Percent!=''">
                                <xsl:attribute name="percentageRate">
                                    <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                                </xsl:attribute>
                                </xsl:if>
                                
                                <TaxAmount>
                                    <Money>
                                        <xsl:attribute name="currency">
                                            <xsl:value-of select="$currency"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="' '"/>
                                    </Money>
                                </TaxAmount>
                                <xsl:if test="cac:TaxCategory/cbc:ID!=''">
                                <TaxExemption>
                                    <xsl:attribute name="exemptCode">
                                        <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                                    </xsl:attribute>
                                </TaxExemption>
                                </xsl:if>
                            </TaxDetail>
                        </Tax>
                        </xsl:if>
                        <xsl:variable name="name">
                            <xsl:choose>
                                <xsl:when test="cbc:ChargeIndicator = 'false'">
                                    <xsl:choose>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = '42'"
                                            >Allowance</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = '64'"
                                            >ContractAllowance</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = '88'"
                                            >Surcharge</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = '95'">Maps
                                            Separately</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = '100'"
                                            >Discount-Special</xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="cbc:AllowanceChargeReasonCode"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="cbc:ChargeIndicator = 'true'">
                                    <xsl:choose>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'ABL'"
                                            >PackagingSurcharge</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'ADR'"
                                            >OtherServices</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'AEL'"
                                            >SmallOrderCharge</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'AJ'"
                                            >Adjustment</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'FAC'"
                                            >FreightBasedOnDollarMinimum</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'FC'"
                                            >Freight</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'HD'"
                                            >Handling</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'SAA'">Maps
                                            separately</xsl:when>
                                        <xsl:when test="cbc:AllowanceChargeReasonCode = 'SH'">Maps
                                            separately</xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="cbc:AllowanceChargeReasonCode"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$name != ''">
                            <ModificationDetail>
                                <xsl:attribute name="code">
                                    <xsl:value-of select="cbc:AllowanceChargeReasonCode"/>
                                </xsl:attribute>
                                <xsl:attribute name="name">
                                    <xsl:value-of select="normalize-space($name)"/>
                                </xsl:attribute>
                                <Description>
                                    <xsl:attribute name="xml:lang">en</xsl:attribute>
                                    <ShortName>
                                        <xsl:choose>
                                            <xsl:when
                                                test="normalize-space(cbc:AllowanceChargeReason) != ''">
                                                
                                                  <xsl:value-of
                                                  select="normalize-space(cbc:AllowanceChargeReason)"
                                                  />
                                                
                                            </xsl:when>
                                            <xsl:otherwise>
                                                
                                                  <xsl:value-of select="normalize-space($name)"/>
                                                
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </ShortName>
                                </Description>
                            </ModificationDetail>
                        </xsl:if>
                    </Modification>
                </xsl:for-each>

                <xsl:if test="cac:LegalMonetaryTotal/cbc:PayableRoundingAmount != ''">
                    <Modification>
                        <AdditionalCost>
                            <xsl:call-template name="createMoney">
                                <xsl:with-param name="curr"
                                    select="cac:LegalMonetaryTotal/cbc:PayableRoundingAmount/@currencyID"/>
                                <xsl:with-param name="money"
                                    select="cac:LegalMonetaryTotal/cbc:PayableRoundingAmount"/>
                            </xsl:call-template>
                        </AdditionalCost>
                        <ModificationDetail>
                            <xsl:attribute name="name">RoundingAmount</xsl:attribute>
                        </ModificationDetail>
                    </Modification>
                </xsl:if>
            </InvoiceHeaderModifications>
        </xsl:if>
        <!-- TotalCharges -->
        <xsl:if test="cac:LegalMonetaryTotal/cbc:ChargeTotalAmount != ''">
            <TotalCharges>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:LegalMonetaryTotal/cbc:ChargeTotalAmount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:LegalMonetaryTotal/cbc:ChargeTotalAmount"/>
                </xsl:call-template>
            </TotalCharges>
        </xsl:if>
        <!-- TotalAllowances -->
        <xsl:if test="cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount != ''">
            <TotalAllowances>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount"/>
                </xsl:call-template>
            </TotalAllowances>
        </xsl:if>
        <!-- TotalAmountWithoutTax -->
        <xsl:if test="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount != ''">
            <TotalAmountWithoutTax>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount/@currencyID"/>
                    <xsl:with-param name="money"
                        select="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/>
                </xsl:call-template>
            </TotalAmountWithoutTax>
        </xsl:if>
        <!-- NetAmount -->
        <NetAmount>
            <xsl:call-template name="createMoney">
                <xsl:with-param name="curr"
                    select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID"/>
                <xsl:with-param name="money" select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"
                />
            </xsl:call-template>
        </NetAmount>
        <!-- DepositAmount -->
        <xsl:if test="cac:LegalMonetaryTotal/cbc:PrepaidAmount != ''">
            <DepositAmount>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:LegalMonetaryTotal/cbc:PrepaidAmount/@currencyID"/>
                    <xsl:with-param name="money" select="cac:LegalMonetaryTotal/cbc:PrepaidAmount"/>
                </xsl:call-template>
            </DepositAmount>
        </xsl:if>
        <!-- DueAmount -->
        <xsl:if test="cac:LegalMonetaryTotal/cbc:PayableAmount != ''">
            <DueAmount>
                <xsl:call-template name="createMoney">
                    <xsl:with-param name="curr"
                        select="cac:LegalMonetaryTotal/cbc:PayableAmount/@currencyID"/>
                    <xsl:with-param name="money" select="cac:LegalMonetaryTotal/cbc:PayableAmount"/>
                </xsl:call-template>
            </DueAmount>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
