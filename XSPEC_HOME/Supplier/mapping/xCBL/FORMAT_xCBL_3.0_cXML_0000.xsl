<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.api.org/pidXML/v1.0" version="1.0" exclude-result-prefixes="pidx">

	
	<xsl:template name="formatDate">
		<xsl:param name="input"/>
		<xsl:variable name="formattedDate">
			<xsl:choose>
				<xsl:when test="string-length(substring-after($input,'T'))=8">
					<xsl:value-of select="concat(substring($input,1,4),'-',substring($input,5,2),'-',substring($input,7,2),'T',substring-after($input,'T'),'-00:00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(substring($input,1,4),'-',substring($input,5,2),'-',substring($input,7,2),'T',substring-after($input,'T'))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$formattedDate"/>
	</xsl:template>

	<xsl:template name="formatMoney">
		<xsl:param name="value"/>
		<xsl:param name="currency"/>
		<Money>
			<xsl:choose>
				<xsl:when test="$currency">
					<xsl:attribute name="currency">
						<xsl:choose>
							<xsl:when test="$currency/CurrencyCoded='Other'">
								<xsl:value-of select="$currency/CurrencyCodedOther"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$currency/CurrencyCoded"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="currency"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$value and $value!=''">
					<xsl:value-of select="format-number($value,'#0.00##')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>0.00</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</Money>
	</xsl:template>
	<xsl:template name="CreateHeaderParty">
		<xsl:param name="PartyInfo"/>
		<xsl:param name="addressid"/>

		<xsl:call-template name="partyInfo">
			<xsl:with-param name="PartyInfo" select="$PartyInfo"/>
			<xsl:with-param name="addressid" select="$addressid"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="CreateDetailParty">
		<xsl:param name="PartyInfo"/>
		<xsl:param name="addressid"/>

		<xsl:call-template name="partyInfo">
			<xsl:with-param name="PartyInfo" select="$PartyInfo"/>
			<xsl:with-param name="addressid" select="$addressid"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="CreateContact">
		<xsl:param name="PartyInfo"/>
		<xsl:param name="addressid"/>

		<xsl:param name="isNFe"/>

		<xsl:if test="name($PartyInfo)!='PayerParty'">
			<xsl:call-template name="contactPartyInfo">
				<xsl:with-param name="PartyInfo" select="$PartyInfo"/>
				<xsl:with-param name="isNFe" select="$isNFe"/>
			</xsl:call-template>
			<xsl:if test="name($PartyInfo)!='BuyerParty' or /Invoice">
				<xsl:variable name="ccode">
					<xsl:choose>
						<xsl:when test="$PartyInfo/Party/NameAddress/Country/CountryCoded = 'Other'">
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCodedOther"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCoded"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="MultiPhoneFaxEmail">
					<xsl:with-param name="ListOfContact" select="$PartyInfo/Party/OrderContact/Contact"/>

					<xsl:with-param name="isoCountryCode" select="$ccode"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:if test="name($PartyInfo)='PayerParty'">
			<xsl:variable name="ccode">
				<xsl:choose>
					<xsl:when test="$PartyInfo/Party/NameAddress/Country/CountryCoded = 'Other'">
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCodedOther"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCoded"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="contactPayerPartyInfo">
				<xsl:with-param name="PartyInfo" select="$PartyInfo"/>
				<xsl:with-param name="isNFe" select="$isNFe"/>
			</xsl:call-template>
			<xsl:call-template name="MultiPhoneFaxEmail">
				<xsl:with-param name="ListOfContact" select="$PartyInfo/Party/OrderContact/Contact"/>

				<xsl:with-param name="isoCountryCode" select="$ccode"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="partyInfo">
		<xsl:param name="PartyInfo"/>
		<xsl:param name="addressid"/>
		<Address>
			<xsl:if test="$PartyInfo/Party/NameAddress/Country/CountryCoded!=''">
				<xsl:attribute name="isoCountryCode">
					<xsl:choose>
						<xsl:when test="$PartyInfo/Party/NameAddress/Country/CountryCoded = 'Other'">
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCodedOther"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCoded"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$addressid">
				<xsl:attribute name="addressID">
					<xsl:value-of select="$addressid"/>
				</xsl:attribute>
			</xsl:if>
			<Name>
				<xsl:attribute name="xml:lang">
					<xsl:choose>
						<xsl:when test="$PartyInfo/Party/CorrespondenceLanguage/Language/LanguageCoded != '' and $PartyInfo/Party/CorrespondenceLanguage/Language/LanguageCoded != 'Other'">
							<xsl:value-of select="$PartyInfo/Party/CorrespondenceLanguage/Language/LanguageCoded"/>
						</xsl:when>
						<xsl:otherwise>en</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="$PartyInfo/Party/NameAddress/Name1"/>
			</Name>
			<PostalAddress>
				<xsl:choose>
					<xsl:when test="$PartyInfo/Party/NameAddress/Department!=''">
						<DeliverTo>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Department"/>
						</DeliverTo>
					</xsl:when>
					<xsl:when test="$PartyInfo/Party/OrderContact/Contact/ContactName and $PartyInfo/Party/OrderContact/Contact/ContactName!=''">
						<DeliverTo>
							<xsl:value-of select="$PartyInfo/Party/OrderContact/Contact/ContactName"/>
						</DeliverTo>
					</xsl:when>
				</xsl:choose>

				<Street>
					<xsl:value-of select="$PartyInfo/Party/NameAddress/Street"/>
				</Street>
				<xsl:if test="$PartyInfo/Party/NameAddress/Name2">
					<Street>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Name2"/>
					</Street>
				</xsl:if>
				<xsl:if test="$PartyInfo/Party/NameAddress/Name3!=''">
					<Street>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Name3"/>
					</Street>
				</xsl:if>

				<xsl:if test="$PartyInfo/Party/NameAddress/StreetSupplement1!=''">
					<Street>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/StreetSupplement1"/>
					</Street>
				</xsl:if>
				<City>
					<xsl:value-of select="$PartyInfo/Party/NameAddress/City"/>
				</City>
				<xsl:choose>
					<xsl:when test="$PartyInfo/Party/NameAddress/Region/RegionCoded!='Other'">
						<State>
							<xsl:value-of select="substring($PartyInfo/Party/NameAddress/Region/RegionCoded,3)"/>
						</State>
					</xsl:when>
					<xsl:when test="$PartyInfo/Party/NameAddress/Region/RegionCoded='Other'">
						<State>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Region/RegionCodedOther"/>
						</State>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$PartyInfo/Party/NameAddress/PostalCode!=''">
					<PostalCode>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/PostalCode"/>
					</PostalCode>
				</xsl:if>
				<Country>
					<xsl:attribute name="isoCountryCode">
						<xsl:choose>
							<xsl:when test="$PartyInfo/Party/NameAddress/Country/CountryCoded = 'Other'">
								<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCodedOther"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCoded"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</Country>
			</PostalAddress>
			<xsl:variable name="ccode">
				<xsl:choose>
					<xsl:when test="$PartyInfo/Party/NameAddress/Country/CountryCoded = 'Other'">
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCodedOther"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCoded"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$PartyInfo/Party/OrderContact/Contact">
					<xsl:call-template name="MultiPhoneFaxEmail">
						<xsl:with-param name="ListOfContact" select="$PartyInfo/Party/OrderContact/Contact"/>

						<xsl:with-param name="isoCountryCode" select="$ccode"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$PartyInfo/Party/ReceivingContact/Contact">
					<xsl:call-template name="MultiPhoneFaxEmail">
						<xsl:with-param name="ListOfContact" select="$PartyInfo/Party/ReceivingContact/Contact"/>

						<xsl:with-param name="isoCountryCode" select="$ccode"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</Address>
	</xsl:template>

	<xsl:template name="contactPartyInfo">
		<xsl:param name="PartyInfo"/>
		<xsl:param name="isNFe"/>


		<Name>
			<xsl:attribute name="xml:lang">
				<xsl:choose>
					<xsl:when test="$PartyInfo/Party/CorrespondenceLanguage/Language/LanguageCoded != ''">
						<xsl:value-of select="$PartyInfo/Party/CorrespondenceLanguage/Language/LanguageCoded"/>
					</xsl:when>
					<xsl:otherwise>en</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="$PartyInfo/Party/NameAddress/Name1"/>
		</Name>
		<PostalAddress>
			<xsl:if test="$PartyInfo/Party/NameAddress/Identifier[Agency/AgencyCoded='AssignedByBuyerOrBuyersAgent']/Ident">
				<xsl:attribute name="name">
					<xsl:value-of select="$PartyInfo/Party/NameAddress/Identifier[Agency/AgencyCoded='AssignedByBuyerOrBuyersAgent']/Ident"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$isNFe">
					<DeliverTo>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Name1"/>
					</DeliverTo>
				</xsl:when>

				<xsl:when test="$PartyInfo/Party/OrderContact/Contact/ContactName and $PartyInfo/Party/OrderContact/Contact/ContactName!=''">
					<DeliverTo>
						<xsl:value-of select="$PartyInfo/Party/OrderContact/Contact/ContactName"/>
					</DeliverTo>
				</xsl:when>
			</xsl:choose>
			<Street>
				<xsl:value-of select="$PartyInfo/Party/NameAddress/Street"/>
			</Street>
			<xsl:if test="not($isNFe)">
				<xsl:if test="$PartyInfo/Party/NameAddress/Name2">
					<Street>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Name2"/>
					</Street>
				</xsl:if>
				<xsl:if test="$PartyInfo/Party/NameAddress/Name3!=''">
					<Street>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Name3"/>
					</Street>
				</xsl:if>

				<xsl:if test="$PartyInfo/Party/NameAddress/StreetSupplement1!=''">
					<Street>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/StreetSupplement1"/>
					</Street>
				</xsl:if>
			</xsl:if>
			<City>
				<xsl:value-of select="$PartyInfo/Party/NameAddress/City"/>
			</City>
			<xsl:choose>
				<xsl:when test="$PartyInfo/Party/NameAddress/Region/RegionCoded!='Other'">
					<State>
						<xsl:value-of select="substring($PartyInfo/Party/NameAddress/Region/RegionCoded,3)"/>
					</State>
				</xsl:when>
				<xsl:when test="$PartyInfo/Party/NameAddress/Region/RegionCoded='Other'">
					<State>
						<xsl:value-of select="$PartyInfo/Party/NameAddress/Region/RegionCodedOther"/>
					</State>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="$PartyInfo/Party/NameAddress/PostalCode!=''">
				<PostalCode>
					<xsl:value-of select="$PartyInfo/Party/NameAddress/PostalCode"/>
				</PostalCode>
			</xsl:if>
			<Country>
				<xsl:attribute name="isoCountryCode">
					<xsl:choose>
						<xsl:when test="$PartyInfo/Party/NameAddress/Country/CountryCoded = 'Other'">
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCodedOther"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCoded"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</Country>
			<xsl:if test="$PartyInfo/Party/NameAddress/POBox">
				<Extrinsic name="POBox">
					<xsl:value-of select="$PartyInfo/Party/NameAddress/POBox"/>
				</Extrinsic>
			</xsl:if>
		</PostalAddress>
	</xsl:template>
	<xsl:template name="contactPayerPartyInfo">
		<xsl:param name="PartyInfo"/>
		<xsl:param name="isNFe"/>
		<Name>
			<xsl:attribute name="xml:lang">
				<xsl:choose>
					<xsl:when test="$PartyInfo/CorrespondenceLanguage/Language/LanguageCoded != ''">
						<xsl:value-of select="$PartyInfo/CorrespondenceLanguage/Language/LanguageCoded"/>
					</xsl:when>
					<xsl:otherwise>en</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="$PartyInfo/NameAddress/Name1"/>
		</Name>
		<xsl:if test="$PartyInfo/Party/NameAddress/Street!='' or $PartyInfo/Party/NameAddress/StreetSupplement1!='' or $PartyInfo/Party/NameAddress/City!='' or $PartyInfo/Party/NameAddress/PostalCode!=''">
			<PostalAddress>
				<xsl:choose>
					<xsl:when test="$isNFe">
						<DeliverTo>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Name1"/>
						</DeliverTo>
					</xsl:when>

					<xsl:when test="$PartyInfo/Party/OrderContact/Contact/ContactName and $PartyInfo/Party/OrderContact/Contact/ContactName!=''">
						<DeliverTo>
							<xsl:value-of select="$PartyInfo/Party/OrderContact/Contact/ContactName"/>
						</DeliverTo>
					</xsl:when>
				</xsl:choose>
				<Street>
					<xsl:value-of select="$PartyInfo/Party/NameAddress/Street"/>
				</Street>
				<xsl:if test="not($isNFe)">
					<xsl:if test="$PartyInfo/Party/NameAddress/Name2">
						<Street>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Name2"/>
						</Street>
					</xsl:if>
					<xsl:if test="$PartyInfo/Party/NameAddress/Name3!=''">
						<Street>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Name3"/>
						</Street>
					</xsl:if>

					<xsl:if test="$PartyInfo/Party/NameAddress/StreetSupplement1!=''">
						<Street>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/StreetSupplement1"/>
						</Street>
					</xsl:if>
				</xsl:if>
				<City>
					<xsl:value-of select="$PartyInfo/NameAddress/City"/>
				</City>
				<xsl:choose>
					<xsl:when test="$PartyInfo/Party/NameAddress/Region/RegionCoded!='Other'">
						<State>
							<xsl:value-of select="substring($PartyInfo/Party/NameAddress/Region/RegionCoded,3)"/>
						</State>
					</xsl:when>
					<xsl:when test="$PartyInfo/Party/NameAddress/Region/RegionCoded='Other'">
						<State>
							<xsl:value-of select="$PartyInfo/Party/NameAddress/Region/RegionCodedOther"/>
						</State>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$PartyInfo/NameAddress/PostalCode!=''">
					<PostalCode>
						<xsl:value-of select="$PartyInfo/NameAddress/PostalCode"/>
					</PostalCode>
				</xsl:if>
				<Country>
					<xsl:attribute name="isoCountryCode">
						<xsl:choose>
							<xsl:when test="$PartyInfo/Party/NameAddress/Country/CountryCoded = 'Other'">
								<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCodedOther"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$PartyInfo/Party/NameAddress/Country/CountryCoded"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</Country>
			</PostalAddress>
		</xsl:if>
	</xsl:template>

	<xsl:template name="PhoneFaxEmail">
		<xsl:param name="contactName"/>
		<xsl:param name="phone"/>
		<xsl:param name="fax"/>
		<xsl:param name="email"/>
		<xsl:param name="countrycode"/>
		<xsl:if test="$email and $email!=''">
			<Email name="{$email}">
				<xsl:value-of select="$email"/>
			</Email>
		</xsl:if>
		<xsl:if test="$phone and $phone!=''">
			<Phone name="work">
				<TelephoneNumber>
					<CountryCode>
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$countrycode"/>
						</xsl:attribute>
					</CountryCode>
					<AreaOrCityCode/>
					<Number>
						<xsl:value-of select="$phone"/>
					</Number>
					<Extension/>
				</TelephoneNumber>
			</Phone>
		</xsl:if>
		<xsl:if test="$fax and $fax!=''">
			<Fax name="work">
				<TelephoneNumber>
					<CountryCode>
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$countrycode"/>
						</xsl:attribute>
					</CountryCode>
					<AreaOrCityCode/>
					<Number>
						<xsl:value-of select="$fax"/>
					</Number>
					<Extension/>
				</TelephoneNumber>
			</Fax>
		</xsl:if>
	</xsl:template>

	<xsl:template name="MultiPhoneFaxEmail">
		<xsl:param name="ListOfContact"/>
		<xsl:param name="isoCountryCode"/>

		<xsl:for-each select="$ListOfContact/ListOfContactNumber/ContactNumber[ContactNumberTypeCoded='EmailAddress']/ContactNumberValue">
			<Email name="{.}">
				<xsl:value-of select="."/>
			</Email>
		</xsl:for-each>
		<xsl:for-each select="$ListOfContact/ListOfContactNumber/ContactNumber[ContactNumberTypeCoded='TelephoneNumber']/ContactNumberValue">
			<Phone name="work">
				<TelephoneNumber>
					<CountryCode>
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$isoCountryCode"/>
						</xsl:attribute>
					</CountryCode>
					<AreaOrCityCode/>
					<Number>
						<xsl:value-of select="."/>
					</Number>
					<Extension/>
				</TelephoneNumber>
			</Phone>
		</xsl:for-each>
		<xsl:for-each select="$ListOfContact/ListOfContactNumber/ContactNumber[ContactNumberTypeCoded='FaxNumber']/ContactNumberValue">
			<Fax name="work">
				<TelephoneNumber>
					<CountryCode>
						<xsl:attribute name="isoCountryCode">
							<xsl:value-of select="$isoCountryCode"/>
						</xsl:attribute>
					</CountryCode>
					<AreaOrCityCode/>
					<Number>
						<xsl:value-of select="."/>
					</Number>
					<Extension/>
				</TelephoneNumber>
			</Fax>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="createItemOut">
		<!-- POCO ItemDetail -->
		<xsl:param name="item"/>
		<xsl:param name="currency"/>
		<xsl:param name="itemType"/>
		<xsl:param name="parentLine"/>
		<xsl:param name="orderType"/>
		<xsl:param name="upperAlpha"/>
		<xsl:param name="lowerAlpha"/>
		<xsl:param name="isConsignment"/>
		<xsl:param name="contractnum"/>

		<xsl:attribute name="quantity">
			<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/QuantityValue"/>
		</xsl:attribute>
		<xsl:attribute name="lineNumber">
			<xsl:value-of select="$item/BaseItemDetail/LineItemNum/BuyerLineItemNum"/>
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="count($item/DeliveryDetail/ListOfScheduleLine/ScheduleLine)=1 and $item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded/Date[DateQualifierCoded='EndDateTime']!=''">
				<xsl:attribute name="requestedDeliveryDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded/Date[DateQualifierCoded='EndDateTime']!=''"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="count($item/DeliveryDetail/ListOfScheduleLine/ScheduleLine)=1 and $item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate!=''">
				<xsl:attribute name="requestedDeliveryDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:when>
		</xsl:choose>

		<xsl:if test="string-length($parentLine) &gt; 0">
			<xsl:attribute name="parentLineNumber">
				<xsl:value-of select="$parentLine"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length($itemType) &gt; 2">
			<xsl:attribute name="itemType">
				<xsl:value-of select="$itemType"/>
			</xsl:attribute>
		</xsl:if>
		<!-- 09/08/2015 add condition to check is not a blanket order before adding "requiresServiceEntry" attribute-->
		<xsl:if test="$orderType!='BlanketOrder' and $orderType!='BlanketPurchaseAgreement'">
			<xsl:if test="$itemType!='item' and ($item/BaseItemDetail/ItemIdentifiers/ListOfItemCharacteristic/ItemCharacteristic/ItemCharacteristicCoded= 'Services'    or contains(translate($item/BaseItemDetail/LineItemType/LineItemTypeCoded,$upperAlpha,$lowerAlpha),'service')    or contains(translate($item/BaseItemDetail/LineItemType/LineItemTypeCodedOther,$upperAlpha,$lowerAlpha),'service'))">
				<!-- 09/08/2015 add condition if spend limit is sent before adding "requiresServiceEntry" attribute-->
				<xsl:choose>
					<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther='Spend_Limit']">
						<xsl:attribute name="requiresServiceEntry">
							<xsl:text>yes</xsl:text>
						</xsl:attribute>
					</xsl:when>
					<!-- BP specific -->
					<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded = 'LS'">
						<xsl:attribute name="requiresServiceEntry">
							<xsl:text>yes</xsl:text>
						</xsl:attribute>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/ListOfItemCharacteristic/ItemCharacteristic/ItemCharacteristicCodedOther='Consignment' or $isConsignment='true'">
			<xsl:attribute name="itemCategory">
				<xsl:text>consignment</xsl:text>
			</xsl:attribute>
		</xsl:if>
		<ItemID>
			<SupplierPartID>
				<xsl:choose>
					<xsl:when test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID">
						<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID"/>
					</xsl:when>
					<xsl:when test="($item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther='Spend_Limit']) or ($item/BaseItemDetail/ItemIdentifiers/ListOfItemCharacteristic/ItemCharacteristic/ItemCharacteristicCoded= 'Services' or contains(translate($item/BaseItemDetail/LineItemType/LineItemTypeCoded,$upperAlpha,$lowerAlpha),'service') or contains(translate($item/BaseItemDetail/LineItemType/LineItemTypeCodedOther,$upperAlpha,$lowerAlpha),'service'))">
						<xsl:value-of select="''"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'Not Available'"/>
					</xsl:otherwise>
				</xsl:choose>
			</SupplierPartID>
			<!--xsl:variable name="paramName" select="-->
			<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt!='' or $item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param A' or ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier!='' or $item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param B' or ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier!=''">
				<SupplierPartAuxiliaryID>
					<xsl:choose>
						<xsl:when test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt!='' and $item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param A' or ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier!='' and $item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param B' or ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier!=''">
							<xsl:value-of select="concat($item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt,'|',$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param A' or ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier,'|',$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param B' or ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier)"/>
						</xsl:when>
						<xsl:when test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt!='' and $item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param A' or ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier!='' and not($item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param B' or ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier!='')">
							<xsl:value-of select="concat($item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt,'|',$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param A' or ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier)"/>
						</xsl:when>
						<xsl:when test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt!='' and $item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param B' or ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier!='' and not($item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param A' or ProductIdentifierQualifierCodedOther = 'ParamA']/ProductIdentifier!='')">
							<xsl:value-of select="concat($item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt,'|',$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[normalize-space(ProductIdentifierQualifierCodedOther) = 'Param B' or ProductIdentifierQualifierCodedOther = 'ParamB']/ProductIdentifier)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt"/>
						</xsl:otherwise>
					</xsl:choose>
				</SupplierPartAuxiliaryID>
			</xsl:if>
			<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID!=''">
				<BuyerPartID>
					<xsl:choose>
						<xsl:when test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartIDExt!=''">
							<xsl:value-of select="concat($item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID,'-',$item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartIDExt)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID"/>
						</xsl:otherwise>
					</xsl:choose>
				</BuyerPartID>
			</xsl:if>
		</ItemID>
		<xsl:choose>
			<xsl:when test="($orderType='BlanketOrder' or $orderType='BlanketPurchaseAgreement') or     ($itemType!='item' and ($item/BaseItemDetail/ItemIdentifiers/ListOfItemCharacteristic/ItemCharacteristic/ItemCharacteristicCoded= 'Services' or contains(translate($item/BaseItemDetail/LineItemType/LineItemTypeCoded,$upperAlpha,$lowerAlpha),'service') or contains(translate($item/BaseItemDetail/LineItemType/LineItemTypeCodedOther,$upperAlpha,$lowerAlpha),'service')) and ($item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther='Spend_Limit'] or $item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded = 'LS'))">
				<BlanketItemDetail>
					<Description>
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="//Language/LanguageCoded"/>
						</xsl:attribute>
						<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/ItemDescription"/>
						<!--xsl:if test="$item/BaseItemDetail/ItemIdentifiers/CommodityCode/Identifier[Agency/AgencyCoded='UN']/Ident!=''">
							<ShortName>
								<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/CommodityCode/Identifier[Agency/AgencyCoded='UN']/Ident"/>
							</ShortName>
						</xsl:if-->
					</Description>

					<MaxAmount>
						<xsl:choose>
							<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCodedOther='Spend_Limit']">
								<xsl:call-template name="formatMoney">
									<xsl:with-param name="currency" select="$currency"/>
									<xsl:with-param name="value"
									                select="format-number(sum(($item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded ='Other'][ReferenceTypeCodedOther ='Spend_Limit']/PrimaryReference/Reference/RefNum|$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount)[number(.) = number(.)]),'#0.00##')"/>
								</xsl:call-template>
							</xsl:when>
							<!-- BP specific -->
							<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded = 'LS'">
								<xsl:call-template name="formatMoney">
									<xsl:with-param name="currency" select="$currency"/>
									<xsl:with-param name="value" select="format-number($item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount,'#0.00##')"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</MaxAmount>

					<UnitPrice>
						<xsl:call-template name="formatMoney">
							<xsl:with-param name="currency" select="$currency"/>
							<xsl:with-param name="value" select="$item/PricingDetail/ListOfPrice/Price/UnitPrice/UnitPriceValue"/>
						</xsl:call-template>
						<xsl:if test="$item/PricingDetail/ItemAllowancesOrCharges and ($item/PricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[BasisCoded='MonetaryAmount' or BasisCoded!='Percent'])">
							<Modifications>
								<xsl:for-each select="$item/PricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge">
									<xsl:if test="BasisCoded='MonetaryAmount' or BasisCoded='Percent'">
										<Modification>
											<OriginalPrice>
												<xsl:call-template name="formatMoney">
													<xsl:with-param name="currency" select="$currency"/>
													<xsl:with-param name="value" select="$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount"/>
												</xsl:call-template>
											</OriginalPrice>
											<xsl:choose>
												<xsl:when test="IndicatorCoded='Allowance'">
													<AdditionalDeduction>
														<xsl:if test="BasisCoded='MonetaryAmount'">
															<DeductionAmount>
																<xsl:call-template name="formatMoney">
																	<xsl:with-param name="currency" select="$currency"/>
																	<xsl:with-param name="value" select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
																</xsl:call-template>
															</DeductionAmount>
														</xsl:if>
														<xsl:if test="BasisCoded='Percent'">
															<DeductionPercent>
																<xsl:attribute name="percent">
																	<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/Percent"/>
																</xsl:attribute>
															</DeductionPercent>
														</xsl:if>
													</AdditionalDeduction>
												</xsl:when>
												<xsl:otherwise>
													<AdditionalCost>
														<xsl:if test="BasisCoded='MonetaryAmount'">
															<xsl:call-template name="formatMoney">
																<xsl:with-param name="currency" select="$currency"/>
																<xsl:with-param name="value" select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
															</xsl:call-template>
														</xsl:if>
														<xsl:if test="BasisCoded='Percent'">
															<Percentage>
																<xsl:attribute name="percent">
																	<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/Percent"/>
																</xsl:attribute>
															</Percentage>
														</xsl:if>
													</AdditionalCost>
												</xsl:otherwise>
											</xsl:choose>
											<ModificationDetail>
												<xsl:attribute name="name">
													<xsl:choose>
														<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded='Other'">
															<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:attribute name="startDate">
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="ValidityDates/StartDate"/>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:attribute name="endDate">
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="ValidityDates/EndDate"/>
													</xsl:call-template>
												</xsl:attribute>
												<Description>
													<xsl:attribute name="xml:lang">
														<xsl:value-of select="//Language/LanguageCoded"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="IndicatorCoded='Charges'">
															<xsl:choose>
																<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText!=''">
																</xsl:when>
																<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded='Other'">
																	<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText"/>
														</xsl:otherwise>
													</xsl:choose>
												</Description>
											</ModificationDetail>
										</Modification>
									</xsl:if>
								</xsl:for-each>
							</Modifications>
						</xsl:if>
					</UnitPrice>
					<UnitOfMeasure>
						<xsl:choose>
							<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded!='Other'">
								<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
							</xsl:otherwise>
						</xsl:choose>
					</UnitOfMeasure>
					<xsl:if test="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity">
						<PriceBasisQuantity>
							<xsl:attribute name="quantity">
								<xsl:choose>
									<xsl:when test="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/QuantityRange/MaximumValue!=''">
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/QuantityRange/MaximumValue"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/QuantityValue"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="conversionFactor">
								<xsl:choose>
									<xsl:when test="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/Multiplier!=''">
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/Multiplier"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<UnitOfMeasure>
								<xsl:choose>
									<xsl:when test="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/UnitOfMeasurement/UOMCoded!='Other'">
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
									</xsl:otherwise>
								</xsl:choose>
							</UnitOfMeasure>
							<xsl:if test="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/PriceMultiplierCodedOther!=''">
								<Description>
									<xsl:attribute name="xml:lang">
										<xsl:value-of select="//Language/LanguageCoded"/>
									</xsl:attribute>
									<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/PriceMultiplierCodedOther"/>
								</Description>
							</xsl:if>
						</PriceBasisQuantity>
					</xsl:if>
					<Classification domain="unspsc">
						<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/CommodityCode/Identifier/Ident"/>
					</Classification>
					<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCoded='BuyersInternalProductGroupCode']/ProductIdentifier!=''">
						<Classification domain="BuyersInternalProductGroupCode">
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCoded='BuyersInternalProductGroupCode']/ProductIdentifier"/>
						</Classification>
					</xsl:if>
					<xsl:if test="$item/BaseItemDetail/LineItemNum/SellerLineItemNum!=''">
						<Extrinsic name="SellerLineItemNum">
							<xsl:value-of select="$item/BaseItemDetail/LineItemNum/SellerLineItemNum"/>
						</Extrinsic>
					</xsl:if>
					<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID!=''">
						<Extrinsic name="customersPartNo">
							<xsl:choose>
								<xsl:when test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt!=''">
									<xsl:value-of select="concat($item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID,'-',$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID"/>
								</xsl:otherwise>
							</xsl:choose>
						</Extrinsic>
					</xsl:if>
					<!--xsl:if test="$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount">
						<Extrinsic name="TotalAmount">
							<xsl:value-of select="$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount"/>
						</Extrinsic>
					</xsl:if-->
					<xsl:if test="$item/DeliveryDetail/SimplePackageNote!=''">
						<Extrinsic name="SimplePackageNote">
							<xsl:value-of select="$item/DeliveryDetail/SimplePackageNote"/>
						</Extrinsic>
					</xsl:if>
					<xsl:if test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='BuyersContractNumber' or $item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='RequestforQuotationReference' or $item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='ContractNumber'">
						<xsl:choose>
							<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='BuyersContractNumber'">
								<Extrinsic name="buyersContractNo">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
								<Extrinsic name="contractItem">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
							</xsl:when>
							<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='RequestforQuotationReference'">
								<Extrinsic name="requestForQuotationRef">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
							</xsl:when>
							<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='ContractNumber'">
								<Extrinsic name="contractNumber">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
					<!--xsl:for-each select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine">
						<xsl:variable name="schUOM">
							<xsl:choose>
								<xsl:when test="Quantity/UnitOfMeasurement/UOMCoded!='Other'">
									<xsl:value-of select="Quantity/UnitOfMeasurement/UOMCoded"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="Quantity/UnitOfMeasurement/UOMCodedOther"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="schDate" select="concat(substring(RequestedDeliveryDate,7,2),'/',substring(RequestedDeliveryDate,5,2),'/',substring(RequestedDeliveryDate,1,4))"/>
						<Extrinsic>
							<xsl:attribute name="name">
								<xsl:value-of select="concat('scheduleRefNo',ScheduleLineID)"/>
							</xsl:attribute>
							<xsl:value-of select="concat(Quantity/QuantityValue,' ',$schUOM,' on ',$schDate)"/>
						</Extrinsic>
					</xsl:for-each-->
					<xsl:for-each select="$item/ListOfStructuredNote/StructuredNote">
						<Extrinsic>
							<xsl:attribute name="name">
								<xsl:value-of select="NoteID"/>
							</xsl:attribute>
							<xsl:value-of select="GeneralNote"/>
						</Extrinsic>
					</xsl:for-each>
					<xsl:if test="$item/PricingDetail/ListOfPrice/Price/UnitPrice/UnitOfMeasurement/UOMCoded = 'LS'">
						<Extrinsic name="isFixed">
						</Extrinsic>
					</xsl:if>
				</BlanketItemDetail>
			</xsl:when>
			<xsl:otherwise>
				<ItemDetail>
					<UnitPrice>
						<xsl:call-template name="formatMoney">
							<xsl:with-param name="currency" select="$currency"/>
							<xsl:with-param name="value" select="$item/PricingDetail/ListOfPrice/Price/UnitPrice/UnitPriceValue"/>
						</xsl:call-template>
						<xsl:if test="$item/PricingDetail/ItemAllowancesOrCharges and ($item/PricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge[BasisCoded='MonetaryAmount' or BasisCoded='Percent'])">
							<Modifications>
								<xsl:for-each select="$item/PricingDetail/ItemAllowancesOrCharges/ListOfAllowOrCharge/AllowOrCharge">
									<xsl:if test="BasisCoded='MonetaryAmount' or BasisCoded='Percent'">
										<Modification>
											<OriginalPrice>
												<xsl:call-template name="formatMoney">
													<xsl:with-param name="currency" select="$currency"/>
													<xsl:with-param name="value" select="$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount"/>
												</xsl:call-template>
											</OriginalPrice>
											<xsl:choose>
												<xsl:when test="IndicatorCoded='Allowance'">
													<AdditionalDeduction>
														<xsl:if test="BasisCoded='MonetaryAmount'">
															<DeductionAmount>
																<xsl:call-template name="formatMoney">
																	<xsl:with-param name="currency" select="$currency"/>
																	<xsl:with-param name="value" select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
																</xsl:call-template>
															</DeductionAmount>
														</xsl:if>
														<xsl:if test="BasisCoded='Percent'">
															<DeductionPercent>
																<xsl:attribute name="percent">
																	<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent"/>
																</xsl:attribute>
															</DeductionPercent>
														</xsl:if>
													</AdditionalDeduction>
												</xsl:when>
												<xsl:otherwise>
													<AdditionalCost>
														<xsl:if test="BasisCoded='MonetaryAmount'">
															<xsl:call-template name="formatMoney">
																<xsl:with-param name="currency" select="$currency"/>
																<xsl:with-param name="value" select="TypeOfAllowanceOrCharge/MonetaryValue/MonetaryAmount"/>
															</xsl:call-template>
														</xsl:if>
														<xsl:if test="BasisCoded='Percent'">
															<Percentage>
																<xsl:attribute name="percent">
																	<xsl:value-of select="TypeOfAllowanceOrCharge/PercentageAllowanceOrCharge/PercentQualifier/Percent"/>
																</xsl:attribute>
															</Percentage>
														</xsl:if>
													</AdditionalCost>
												</xsl:otherwise>
											</xsl:choose>
											<ModificationDetail>
												<xsl:attribute name="name">
													<xsl:choose>
														<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded='Other'">
															<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:attribute name="startDate">
													<xsl:if test="ValidityDates/StartDate!=''">
														<xsl:call-template name="formatDate">
															<xsl:with-param name="input" select="ValidityDates/StartDate"/>
														</xsl:call-template>
													</xsl:if>
												</xsl:attribute>
												<xsl:attribute name="endDate">
													<xsl:if test="ValidityDates/EndDate!=''">
														<xsl:call-template name="formatDate">
															<xsl:with-param name="input" select="ValidityDates/EndDate"/>
														</xsl:call-template>
													</xsl:if>
												</xsl:attribute>
												<Description>
													<xsl:attribute name="xml:lang">
														<xsl:value-of select="//Language/LanguageCoded"/>
													</xsl:attribute>
													<xsl:choose>
														<xsl:when test="IndicatorCoded='Charges'">
															<xsl:choose>
																<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText!=''">
																</xsl:when>
																<xsl:when test="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded='Other'">
																	<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCodedOther"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ServiceCoded"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="AllowanceOrChargeDescription/AllowOrChgDesc/ListOfDescription/Description/DescriptionText"/>
														</xsl:otherwise>
													</xsl:choose>
												</Description>
											</ModificationDetail>
										</Modification>
									</xsl:if>
								</xsl:for-each>
							</Modifications>
						</xsl:if>
					</UnitPrice>
					<!--Description>
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="//Language/LanguageCoded"/>
						</xsl:attribute>
						<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/ItemDescription"/>
					</Description-->

					<Description>
						<xsl:attribute name="xml:lang">
							<xsl:value-of select="//Language/LanguageCoded"/>
						</xsl:attribute>
						<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/ItemDescription"/>
						<!--xsl:if test="$item/BaseItemDetail/ItemIdentifiers/CommodityCode/Identifier[Agency/AgencyCoded='UN']/Ident!=''">
							<ShortName>
								<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/CommodityCode/Identifier[Agency/AgencyCoded='UN']/Ident"/>
							</ShortName>
						</xsl:if-->
					</Description>


					<UnitOfMeasure>
						<xsl:choose>
							<xsl:when test="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded!='Other'">
								<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$item/BaseItemDetail/TotalQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
							</xsl:otherwise>
						</xsl:choose>
					</UnitOfMeasure>
					<xsl:if test="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity">
						<PriceBasisQuantity>
							<xsl:attribute name="quantity">
								<xsl:choose>
									<xsl:when test="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/QuantityRange/MaximumValue!=''">
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/QuantityRange/MaximumValue"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/QuantityValue"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="conversionFactor">
								<xsl:choose>
									<xsl:when test="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/Multiplier!=''">
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/Multiplier"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<UnitOfMeasure>
								<xsl:choose>
									<xsl:when test="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/UnitOfMeasurement/UOMCoded!='Other'">
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/UnitOfMeasurement/UOMCoded"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceBasisQuantity/Quantity/UnitOfMeasurement/UOMCodedOther"/>
									</xsl:otherwise>
								</xsl:choose>
							</UnitOfMeasure>
							<xsl:if test="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/PriceMultiplierCodedOther!=''">
								<Description>
									<xsl:attribute name="xml:lang">
										<xsl:value-of select="//Language/LanguageCoded"/>
									</xsl:attribute>
									<xsl:value-of select="$item/PricingDetail/ListOfPrice/Price/PriceMultiplier/PriceMultiplierCodedOther"/>
								</Description>
							</xsl:if>
						</PriceBasisQuantity>
					</xsl:if>
					<!--End changes - CC-12463-->
					<Classification domain="unspsc">
						<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/CommodityCode/Identifier/Ident"/>
					</Classification>
					<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCoded='BuyersInternalProductGroupCode']/ProductIdentifier!=''">
						<Classification domain="BuyersInternalProductGroupCode">
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/OtherItemIdentifiers/ListOfProductIdentifierCoded/ProductIdentifierCoded[ProductIdentifierQualifierCoded='BuyersInternalProductGroupCode']/ProductIdentifier"/>
						</Classification>
					</xsl:if>
					<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/ManufacturerPartNumber/PartID!=''">
						<ManufacturerPartID>
							<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/ManufacturerPartNumber/PartID"/>
						</ManufacturerPartID>
					</xsl:if>
					<xsl:if test="$item/BaseItemDetail/LineItemNum/SellerLineItemNum!=''">
						<Extrinsic name="SellerLineItemNum">
							<xsl:value-of select="$item/BaseItemDetail/LineItemNum/SellerLineItemNum"/>
						</Extrinsic>
					</xsl:if>
					<xsl:if test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID!=''">
						<Extrinsic name="customersPartNo">
							<xsl:choose>
								<xsl:when test="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt!=''">
									<xsl:value-of select="concat($item/BaseItemDetail/ItemIdentifiers/PartNumbers/BuyerPartNumber/PartNum/PartID,'-',$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartIDExt)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$item/BaseItemDetail/ItemIdentifiers/PartNumbers/SellerPartNumber/PartNum/PartID"/>
								</xsl:otherwise>
							</xsl:choose>
						</Extrinsic>
					</xsl:if>
					<!--xsl:if test="$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount">
						<Extrinsic name="TotalAmount">
							<xsl:value-of select="$item/PricingDetail/TotalValue/MonetaryValue/MonetaryAmount"/>
						</Extrinsic>
					</xsl:if-->
					<xsl:if test="$item/DeliveryDetail/SimplePackageNote!=''">
						<Extrinsic name="SimplePackageNote">
							<xsl:value-of select="$item/DeliveryDetail/SimplePackageNote"/>
						</Extrinsic>
					</xsl:if>
					<xsl:if test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='BuyersContractNumber' or $item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='RequestforQuotationReference' or $item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='ContractNumber'">
						<xsl:choose>
							<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='BuyersContractNumber'">
								<Extrinsic name="buyersContractNo">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
								<Extrinsic name="contractItem">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
							</xsl:when>
							<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='RequestforQuotationReference'">
								<Extrinsic name="requestForQuotationRef">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
							</xsl:when>
							<xsl:when test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded/ReferenceTypeCoded='ContractNumber'">
								<Extrinsic name="contractNumber">
									<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='BuyersContractNumber']/PrimaryReference/Reference/RefNum"/>
								</Extrinsic>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
					<!--xsl:for-each select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine">
						<xsl:variable name="schUOM">
							<xsl:choose>
								<xsl:when test="Quantity/UnitOfMeasurement/UOMCoded!='Other'">
									<xsl:value-of select="Quantity/UnitOfMeasurement/UOMCoded"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="Quantity/UnitOfMeasurement/UOMCodedOther"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="schDate" select="concat(substring(RequestedDeliveryDate,7,2),'/',substring(RequestedDeliveryDate,5,2),'/',substring(RequestedDeliveryDate,1,4))"/>
						<Extrinsic>
							<xsl:attribute name="name">
								<xsl:value-of select="concat('scheduleRefNo',ScheduleLineID)"/>
							</xsl:attribute>
							<xsl:value-of select="concat(Quantity/QuantityValue,' ',$schUOM,' on ',$schDate)"/>
						</Extrinsic>
					</xsl:for-each-->
					<xsl:for-each select="$item/ListOfStructuredNote/StructuredNote">
						<Extrinsic>
							<xsl:attribute name="name">
								<xsl:value-of select="NoteID"/>
							</xsl:attribute>
							<xsl:value-of select="GeneralNote"/>
						</Extrinsic>
					</xsl:for-each>
					<xsl:if test="$item/PricingDetail/ListOfPrice/Price/UnitPrice/UnitOfMeasurement/UOMCoded = 'LS'">
						<Extrinsic name="isFixed">
						</Extrinsic>
					</xsl:if>
				</ItemDetail>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$item/BaseItemDetail/FinalRecipient">
			<ShipTo>
				<xsl:call-template name="CreateDetailParty">
					<xsl:with-param name="PartyInfo" select="$item/BaseItemDetail/FinalRecipient"/>
					<xsl:with-param name="addressid" select="$item/BaseItemDetail/FinalRecipient/Party/PartyID/Identifier/Ident"/>
				</xsl:call-template>
			</ShipTo>
		</xsl:if>
		<xsl:if test="$item/PricingDetail/Tax">
			<Tax>
				<xsl:call-template name="formatMoney">
					<xsl:with-param name="currency" select="$currency"/>
					<xsl:with-param name="value" select="sum($item//TaxAmount)"/>
				</xsl:call-template>
				<Description>
					<xsl:attribute name="xml:lang">
						<xsl:value-of select="//Language/LanguageCoded"/>
					</xsl:attribute>
					<xsl:value-of select="'Tax'"/>
				</Description>
				<xsl:for-each select="$item/PricingDetail/Tax">
					<TaxDetail>
						<xsl:attribute name="category">
							<xsl:choose>
								<xsl:when test="TaxTypeCoded='Other'">
									<xsl:if test="TaxTypeCodedOther/Identifier/Ident='' or TaxTypeCodedOther/Identifier/Ident='NULL'">
										<xsl:value-of select="'Sales'"/>
									</xsl:if>
									<xsl:if test="TaxTypeCodedOther/Identifier/Ident!=''">
										<xsl:value-of select="TaxTypeCodedOther/Identifier/Ident"/>
									</xsl:if>
								</xsl:when>
								<xsl:when test="TaxTypeCoded='OtherTaxes'">
									<xsl:value-of select="'Sales'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="TaxTypeCoded"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="TaxPercent!=''">
							<xsl:attribute name="percentageRate">
								<xsl:value-of select="TaxPercent"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="TaxableAmount">
							<TaxableAmount>
								<xsl:call-template name="formatMoney">
									<xsl:with-param name="currency" select="$currency"/>
									<xsl:with-param name="value" select="TaxableAmount"/>
								</xsl:call-template>
							</TaxableAmount>
						</xsl:if>
						<xsl:if test="TaxAmount">
							<TaxAmount>
								<xsl:call-template name="formatMoney">
									<xsl:with-param name="currency" select="$currency"/>
									<xsl:with-param name="value" select="TaxAmount"/>
								</xsl:call-template>
							</TaxAmount>
						</xsl:if>
						<xsl:if test="TaxLocation/Location/LocationIdentifier/LocID/Identifier/Ident!=''">
							<TaxLocation>
								<xsl:attribute name="xml:lang">
									<xsl:value-of select="//Language/LanguageCoded"/>
								</xsl:attribute>
								<xsl:value-of select="TaxLocation/Location/LocationIdentifier/LocID/Identifier/Ident"/>
							</TaxLocation>
						</xsl:if>
					</TaxDetail>
				</xsl:for-each>
			</Tax>
		</xsl:if>
		<xsl:if test="contains(translate($item/BaseItemDetail/LineItemType/LineItemTypeCodedOther,'SERVICE','service'),'service') or $item/BaseItemDetail/ItemIdentifiers/ListOfItemCharacteristic/ItemCharacteristic[1]/ItemCharacteristicCoded='Services'">
			<SpendDetail>
				<!--Extrinsic name="GenericServiceCategory">
					<Extrinsic name="ItemType">
						<xsl:choose>
							<xsl:when test="$item/BaseItemDetail/LineItemType/LineItemTypeCodedOther='UnplannedServiceItem'">UnplannedService</xsl:when>
							<xsl:otherwise>Service</xsl:otherwise>
						</xsl:choose>
					</Extrinsic>
				</Extrinsic-->
				<xsl:if test="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate and $item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded='EndDateTime']/Date">
					<Extrinsic name="ServicePeriod">
						<Period>
							<xsl:attribute name="startDate">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/RequestedDeliveryDate"/>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="endDate">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="input" select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine/ListOfOtherDeliveryDate/ListOfDateCoded/DateCoded[DateQualifier/DateQualifierCoded='EndDateTime']/Date"/>
								</xsl:call-template>
							</xsl:attribute>
						</Period>
					</Extrinsic>
				</xsl:if>
			</SpendDetail>
		</xsl:if>
		<xsl:if test="$item/DeliveryDetail/TermsOfDelivery">
			<TermsOfDelivery>
				<TermsOfDeliveryCode>
					<xsl:attribute name="value">
						<xsl:choose>
							<xsl:when test="$item/DeliveryDetail/TermsOfDelivery/TermsOfDeliveryFunctionCoded='Other'">
								<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/TermsOfDeliveryFunctionCodedOther"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/TermsOfDeliveryFunctionCoded"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</TermsOfDeliveryCode>
				<ShippingPaymentMethod>
					<xsl:attribute name="value">
						<xsl:choose>
							<xsl:when test="$item/DeliveryDetail/TermsOfDelivery/ShipmentMethodOfPaymentCoded='Other'">
								<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/ShipmentMethodOfPaymentCodedOther"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/ShipmentMethodOfPaymentCoded"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</ShippingPaymentMethod>
				<TransportTerms>
					<xsl:attribute name="value">
						<xsl:choose>
							<xsl:when test="$item/DeliveryDetail/TermsOfDelivery/TransportTermsCoded='Other'">
								<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/TransportTermsCodedOther"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/TransportTermsCoded"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</TransportTerms>
				<xsl:if test="$item/DeliveryDetail/TermsOfDelivery/TermsOfDeliveryDescription!=''">
					<Comments type="TermsOfDelivery">
						<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/TermsOfDeliveryDescription"/>
					</Comments>
				</xsl:if>
				<xsl:if test="$item/DeliveryDetail/TermsOfDelivery/TransportDescription!=''">
					<Comments type="Transport">
						<xsl:value-of select="$item/DeliveryDetail/TermsOfDelivery/TransportDescription"/>
					</Comments>
				</xsl:if>
			</TermsOfDelivery>
		</xsl:if>
		<xsl:if test="$item/LineItemNote!='' or $item/LineItemAttachments/ListOfAttachment/Attachment">
			<Comments>
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="//Language/LanguageCoded"/>
				</xsl:attribute>
				<xsl:value-of select="$item/LineItemNote"/>
				<xsl:for-each select="$item/LineItemAttachments/ListOfAttachment/Attachment">
					<Attachment>
						<URL>
							<xsl:attribute name="name">
								<xsl:value-of select="Filename"/>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="starts-with(AttachmentLocation,'cid:')">
									<xsl:value-of select="AttachmentLocation"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('cid:',AttachmentLocation)"/>
								</xsl:otherwise>
							</xsl:choose>
						</URL>
					</Attachment>
				</xsl:for-each>
			</Comments>
		</xsl:if>
		<xsl:if test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='Other'][ReferenceTypeCodedOther='QuantityTolerancePercentage']/PrimaryReference/Reference/RefNum!='' or $item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='Other'][ReferenceTypeCodedOther='UnitPriceTolerancePercentage']/PrimaryReference/Reference/RefNum!=''">
			<Tolerances>
				<xsl:if test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='Other'][ReferenceTypeCodedOther='QuantityTolerancePercentage']/PrimaryReference/Reference/RefNum!=''">
					<QuantityTolerance>
						<Percentage>
							<xsl:attribute name="percent">
								<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='Other'][ReferenceTypeCodedOther='QuadremInternalCode']/PrimaryReference/Reference/RefNum"/>
							</xsl:attribute>
						</Percentage>
					</QuantityTolerance>
				</xsl:if>
				<xsl:if test="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='Other'][ReferenceTypeCodedOther='UnitPriceTolerancePercentage']/PrimaryReference/Reference/RefNum">
					<PriceTolerance>
						<Percentage>
							<xsl:attribute name="percent">
								<xsl:value-of select="$item/BaseItemDetail/ListOfItemReferences/ListOfReferenceCoded/ReferenceCoded[ReferenceTypeCoded='Other'][ReferenceTypeCodedOther='UnitPriceTolerancePercentage']/PrimaryReference/Reference/RefNum"/>
							</xsl:attribute>
						</Percentage>
					</PriceTolerance>
				</xsl:if>
			</Tolerances>
		</xsl:if>
		<xsl:for-each select="$item/DeliveryDetail/ListOfScheduleLine/ScheduleLine">
			<ScheduleLine>
				<xsl:attribute name="quantity">
					<xsl:value-of select="Quantity/QuantityValue"/>
				</xsl:attribute>
				<xsl:attribute name="lineNumber">
					<xsl:value-of select="ScheduleLineID"/>
				</xsl:attribute>
				<xsl:attribute name="requestedDeliveryDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="input" select="RequestedDeliveryDate"/>
					</xsl:call-template>
				</xsl:attribute>

				<UnitOfMeasure>
					<xsl:choose>
						<xsl:when test="Quantity/UnitOfMeasurement/UOMCoded!='Other'">
							<xsl:value-of select="Quantity/UnitOfMeasurement/UOMCoded"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="Quantity/UnitOfMeasurement/UOMCodedOther"/>
						</xsl:otherwise>
					</xsl:choose>
				</UnitOfMeasure>
			</ScheduleLine>
		</xsl:for-each>
		<xsl:if test="$contractnum!=''">
			<MasterAgreementIDInfo>
				<xsl:attribute name="agreementID">
					<xsl:value-of select="$contractnum"/>
				</xsl:attribute>
			</MasterAgreementIDInfo>
		</xsl:if>
	</xsl:template>

	<xsl:template name="CreditCheck">
		<xsl:param name="value"/>
		<xsl:param name="iscredit"/>
		<xsl:choose>
			<xsl:when test="contains($iscredit,'credit') and $value!=''">
				<xsl:choose>
					<xsl:when test="contains($value,'-')">
						<xsl:value-of select="format-number($value,'#0.00##')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(concat('-',$value),'#0.00##')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>