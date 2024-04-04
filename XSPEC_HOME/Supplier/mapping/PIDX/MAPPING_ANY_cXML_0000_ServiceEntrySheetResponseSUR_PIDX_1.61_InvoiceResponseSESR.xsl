<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pidx="http://www.pidx.org/schemas/v1.61" xmlns="http://www.w3.org/2001/XMLSchema" version="1.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anAlternativeSender"/>
	<!-- Sender DUNS4 -->
	<xsl:param name="anAlternativeReceiver"/>
	<!-- Receiver DUNS4 -->
	<xsl:param name="anSenderGroupID"/>
	<!-- Sender DUNS -->
	<xsl:param name="anReceiverGroupID"/>
	<!-- Receiver DUNS -->
	<xsl:variable name="cXMLPIDXLookupList" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_PIDX_1.61.xml')"/>
	<!--xsl:variable name="cXMLPIDXLookupList" select="document('cXML_PIDXLookups.xml')"/-->
	<xsl:template match="/">
		<xsl:element name="pidx:InvoiceResponse">
			<xsl:attribute name="pidx:transactionPurposeIndicator">Original</xsl:attribute>
			<xsl:attribute name="pidx:version">1.61</xsl:attribute>
			<xsl:element name="pidx:InvoiceResponseProperties">
				<xsl:element name="pidx:InvoiceResponseNumber">
					<xsl:choose>
						<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID)!=''">
							<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="pidx:StatusCode">
					<xsl:variable name="invStatus">
						<xsl:choose>
							<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/@type!=''">
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/@type"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/InvoiceStatus/@type"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$cXMLPIDXLookupList/Lookups/InvoiceResponseCodes/InvoiceResponseCode[CXMLCode=$invStatus]/PIDXCode!=''">
							<xsl:value-of select="$cXMLPIDXLookupList/Lookups/InvoiceResponseCodes/InvoiceResponseCode[CXMLCode=$invStatus]/PIDXCode"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Pending</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="pidx:InvoiceResponseDate">
					<xsl:choose>
						<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate!=''">
							<xsl:value-of select="substring-before(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate,'T')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(cXML/@timestamp,'T')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="pidx:PartnerInformation">
					<xsl:attribute name="partnerRoleIndicator">SoldTo</xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity)!=''">
							<xsl:element name="pidx:PartnerIdentifier">
								<xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
								<xsl:value-of select="substring(normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity),1,9)"/>
							</xsl:element>
							<xsl:if test="substring(normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity),10)!=''">
								<xsl:element name="pidx:PartnerIdentifier">
									<xsl:attribute name="partnerIdentifierIndicator">DUNS+4Number</xsl:attribute>
									<xsl:value-of select="normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity)"/>
								</xsl:element>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="pidx:PartnerIdentifier">
								<xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
								<xsl:value-of select="$anAlternativeSender"/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="pidx:PartnerInformation">
					<xsl:attribute name="partnerRoleIndicator">Seller</xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity)!=''">
							<xsl:element name="pidx:PartnerIdentifier">
								<xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
								<xsl:value-of select="substring(normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity),1,9)"/>
							</xsl:element>
							<xsl:if test="substring(normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity),10)!=''">
								<xsl:element name="pidx:PartnerIdentifier">
									<xsl:attribute name="partnerIdentifierIndicator">DUNS+4Number</xsl:attribute>
									<xsl:value-of select="normalize-space(/cXML/Header/To/Credential[@domain='DUNS']/Identity)"/>
								</xsl:element>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="pidx:PartnerIdentifier">
								<xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
								<xsl:value-of select="$anAlternativeReceiver"/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="pidx:InvoiceInformation">
					<xsl:element name="pidx:InvoiceNumber">
						<xsl:choose>
							<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID!=''">
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:if test="cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceDate or cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate">
						<xsl:element name="pidx:InvoiceDate">
							<xsl:choose>
								<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate">
									<xsl:value-of select="substring-before(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate,'T')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before(cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceDate,'T')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<xsl:element name="pidx:SpecialInstructions">
					<xsl:attribute name="instructionIndicator">Other</xsl:attribute>
					<xsl:variable name="invStatus">
						<xsl:choose>
							<xsl:when test="cXML/Request/StatusUpdateRequest/DocumentStatus/@type!=''">
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/@type"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="cXML/Request/StatusUpdateRequest/InvoiceStatus/@type"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$cXMLPIDXLookupList/Lookups/InvoiceResponseCodes/InvoiceResponseCode[CXMLCode=$invStatus]/PIDXCode!=''">
							<xsl:value-of select="$cXMLPIDXLookupList/Lookups/InvoiceResponseCodes/InvoiceResponseCode[CXMLCode=$invStatus]/PIDXCode"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Pending</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<!--xsl:value-of select="cXML/Request/StatusUpdateRequest/InvoiceStatus/@type"/-->
				</xsl:element>
				<xsl:if test="normalize-space(cXML/Header/From/Credential[@domain='SYSTEMID']/Identity)!=''">
					<xsl:element name="pidx:ReferenceInformation">
						<xsl:attribute name="referenceInformationIndicator">
							<xsl:text>Other</xsl:text>
						</xsl:attribute>
						<xsl:element name="pidx:ReferenceNumber">
							<xsl:value-of select="cXML/Header/From/Credential[@domain='SYSTEMID']/Identity"/>
						</xsl:element>
						<xsl:element name="pidx:Description">
							<xsl:text>BillToPurchaserGroup</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType)!=''">
					<xsl:element name="pidx:ReferenceInformation">
						<xsl:attribute name="referenceInformationIndicator">
							<xsl:text>Other</xsl:text>
						</xsl:attribute>
						<xsl:element name="pidx:ReferenceNumber">
							<xsl:value-of select="cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType"/>
						</xsl:element>
						<xsl:element name="pidx:Description">
							<xsl:text>SourceDocumentType</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:element name="pidx:Comment">
					<xsl:choose>
						<xsl:when test="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/Comments)">
							<xsl:value-of select="normalize-space(cXML/Request/StatusUpdateRequest/DocumentStatus/Comments)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(cXML/Request/StatusUpdateRequest/InvoiceStatus/Comments)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
			<xsl:element name="pidx:InvoiceResponseDetails">
				<xsl:element name="pidx:InvoiceResponseLineItem"/>
			</xsl:element>
			<xsl:element name="pidx:InvoiceResponseSummary"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="createParty">
		<xsl:param name="partyInfo"/>
		<xsl:param name="partyRole"/>
		<xsl:if test="$partyRole!='Not Found'">
			<xsl:element name="pidx:PartnerInformation">
				<xsl:attribute name="partnerRoleIndicator">
					<xsl:value-of select="$partyRole"/>
				</xsl:attribute>
				<xsl:element name="pidx:PartnerIdentifier">
					<xsl:attribute name="partnerIdentifierIndicator">AssignedByBuyer</xsl:attribute>
					<xsl:value-of select="@addressID"/>
				</xsl:element>
				<xsl:choose>
					<xsl:when test="$partyRole='SoldTo'">
						<xsl:element name="pidx:PartnerIdentifier">
							<xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
							<xsl:value-of select="$anSenderGroupID"/>
						</xsl:element>
						<xsl:element name="pidx:PartnerIdentifier">
							<xsl:attribute name="partnerIdentifierIndicator">DUNS+4Number</xsl:attribute>
							<xsl:value-of select="$anAlternativeSender"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$partyRole='Seller'">
						<xsl:element name="pidx:PartnerIdentifier">
							<xsl:attribute name="partnerIdentifierIndicator">DUNSNumber</xsl:attribute>
							<xsl:value-of select="$anReceiverGroupID"/>
						</xsl:element>
						<xsl:element name="pidx:PartnerIdentifier">
							<xsl:attribute name="partnerIdentifierIndicator">DUNS+4Number</xsl:attribute>
							<xsl:value-of select="$anAlternativeReceiver"/>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$partyInfo/IdReference">
					<xsl:for-each select="$partyInfo/IdReference">
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
				<xsl:if test=" $partyInfo/PostalAddress/DeliverTo!='' or $partyInfo/Email!='' or $partyInfo/Phone/TelephoneNumber/Number!='' or $partyInfo/Fax/TelephoneNumber/Number!=''">
					<xsl:element name="pidx:ContactInformation">
						<xsl:attribute name="contactInformationIndicator">
							<xsl:text>OrderContact</xsl:text>
						</xsl:attribute>
						<xsl:if test="$partyInfo/PostalAddress/DeliverTo!=''">
							<xsl:element name="pidx:ContactName">
								<xsl:value-of select="$partyInfo/PostalAddress/DeliverTo"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$partyInfo/Phone/TelephoneNumber/Number!=''">
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
						<xsl:if test="$partyInfo/Fax/TelephoneNumber/Number!=''">
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
						<xsl:if test="$partyInfo/Email!=''">
							<xsl:element name="pidx:EmailAddress">
								<xsl:value-of select="$partyInfo/Email"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
