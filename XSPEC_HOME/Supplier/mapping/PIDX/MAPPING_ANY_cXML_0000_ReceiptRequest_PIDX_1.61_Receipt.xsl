<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pidx="http://www.pidx.org/schemas/v1.61" xmlns="http://www.w3.org/2001/XMLSchema"
	version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes"/>
	<xsl:variable name="cXMLPIDXLookupList"
		select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_PIDX_1.61.xml')"/>
	<!--<xsl:variable name="cXMLPIDXLookupList" select="document('cXML_PIDX1.61_Lookups.xml')"/>-->

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
		<xsl:element name="pidx:Receipt">

			<xsl:attribute name="pidx:version">1.61</xsl:attribute>

			<xsl:element name="pidx:ReceiptProperties">

				<xsl:element name="pidx:ReceiptDate">
					<xsl:value-of
						select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate"/>
				</xsl:element>
				<xsl:element name="pidx:PurchaseOrderReferenceInformation">
					<xsl:element name="pidx:OrderNumber">
						<xsl:value-of
							select="cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptOrderInfo/OrderReference/@orderID"
						/>
					</xsl:element>
					<xsl:if
						test="cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptOrderInfo/OrderReference/@orderDate != ''">
						<xsl:element name="pidx:OrderDate">
							<xsl:value-of
								select="cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptOrderInfo/OrderReference/@orderDate"
							/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<xsl:element name="pidx:ReferenceNumber">
					<xsl:value-of
						select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptID"/>
				</xsl:element>
				<xsl:if
					test="cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeID != ''">
					<xsl:element name="pidx:DocumentReference">
						<xsl:attribute name="referenceType">
							<xsl:text>DeliveryNote</xsl:text>
						</xsl:attribute>

						<xsl:element name="pidx:DocumentIdentifier">
							<xsl:value-of
								select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeID"
							/>
						</xsl:element>
						<xsl:if
							test="cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeDate != ''">
							<xsl:element name="pidx:DocumentDate">
								<xsl:value-of
									select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeDate"
								/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
				<xsl:for-each select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic">
					<xsl:variable name="refName" select="@name"/>
					<xsl:if test="$refName != ''">
						<xsl:element name="pidx:DocumentReference">
							<xsl:attribute name="referenceType">
								<xsl:text>Other</xsl:text>
							</xsl:attribute>

							<xsl:element name="pidx:DocumentIdentifier">
								<xsl:value-of select="$refName"/>
							</xsl:element>
							<xsl:element name="pidx:ReferenceInformation">
								<xsl:attribute name="referenceInformationIndicator">
									<xsl:text>Other</xsl:text>
								</xsl:attribute>
								<xsl:element name="pidx:Description">
									<xsl:value-of select="."/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="cXML/Request/ReceiptRequest/ReceiptRequestHeader/Comments != ''">
					<xsl:element name="pidx:Comment">
						<xsl:value-of
							select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/Comments"/>
					</xsl:element>
				</xsl:if>
			</xsl:element>
			<xsl:element name="pidx:ReceiptDetails">

				<xsl:for-each select="cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptItem">
					<xsl:element name="pidx:ReceiptLineItems">
						<xsl:element name="pidx:LineItemNumber">
							<xsl:value-of select="@receiptLineNumber"/>
						</xsl:element>
						<xsl:element name="pidx:DocumentReference">
							<xsl:attribute name="referenceType">LineItemNumber</xsl:attribute>
							<xsl:element name="pidx:DocumentIdentifier">
								<xsl:value-of select="ReceiptItemReference/@lineNumber"/>
							</xsl:element>
						</xsl:element>
						<xsl:element name="pidx:DocumentReference">
							<xsl:attribute name="referenceType">PurchaseOrderNumber</xsl:attribute>
							<xsl:element name="pidx:DocumentIdentifier">
								<xsl:value-of select="../ReceiptOrderInfo/OrderReference/@orderID"/>
							</xsl:element>
							<xsl:if test="../@closeForReceiving = 'yes'">
								<xsl:element name="pidx:ReferenceInformation">
									<xsl:attribute name="referenceInformationIndicator"
										>Other</xsl:attribute>
									<xsl:element name="pidx:Description">
										<xsl:value-of select="'closeForReceiving'"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:if test="../ReceiptOrderInfo/OrderReference/@orderDate != ''">
								<xsl:element name="pidx:DocumentDate">
									<xsl:value-of
										select="../ReceiptOrderInfo/OrderReference/@orderDate"/>
								</xsl:element>
							</xsl:if>
						</xsl:element>
						<xsl:if
							test="../ReceiptOrderInfo/MasterAgreementReference/@agreementID != ''">
							<xsl:element name="pidx:DocumentReference">
								<xsl:attribute name="referenceType">ContractNumber</xsl:attribute>
								<xsl:element name="pidx:DocumentIdentifier">
									<xsl:value-of
										select="../ReceiptOrderInfo/MasterAgreementReference/@agreementID"
									/>
								</xsl:element>
								<xsl:if test="../@closeForReceiving = 'yes'">
									<xsl:element name="pidx:ReferenceInformation">
										<xsl:attribute name="referenceInformationIndicator"
											>Other</xsl:attribute>
										<xsl:element name="pidx:Description">
											<xsl:value-of select="'closeForReceiving'"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
								<xsl:if
									test="../ReceiptOrderInfo/MasterAgreementReference/@agreementDate != ''">
									<xsl:element name="pidx:DocumentDate">
										<xsl:value-of
											select="../ReceiptOrderInfo/MasterAgreementReference/@agreementDate"
										/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:if test="ReceiptItemReference/ShipNoticeReference/@shipNoticeID != ''">
							<xsl:element name="pidx:DocumentReference">
								<xsl:attribute name="referenceType">DeliveryNote</xsl:attribute>
								<xsl:element name="pidx:DocumentIdentifier">
									<xsl:value-of
										select="ReceiptItemReference/ShipNoticeReference/@shipNoticeID"
									/>
								</xsl:element>
								<xsl:if
									test="ReceiptItemReference/ShipNoticeReference/@shipNoticeDate != ''">
									<xsl:element name="pidx:DocumentDate">
										<xsl:value-of
											select="ReceiptItemReference/ShipNoticeReference/@shipNoticeDate"
										/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:if test="Batch/SupplierBatchID != ''">
							<xsl:element name="pidx:DocumentReference">
								<xsl:attribute name="referenceType">Other</xsl:attribute>
								<xsl:element name="pidx:DocumentIdentifier">
									<xsl:value-of select="Batch/SupplierBatchID"/>
								</xsl:element>
								<xsl:element name="pidx:ReferenceInformation">
									<xsl:attribute name="referenceInformationIndicator"
										>BatchNumber</xsl:attribute>
									<xsl:element name="pidx:Description">
										<xsl:value-of select="'SupplierBatchID'"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>

						<xsl:for-each select="Extrinsic">
							<xsl:variable name="refName" select="@name"/>
							<xsl:if test="$refName != ''">
								<xsl:element name="pidx:DocumentReference">
									<xsl:attribute name="referenceType">
										<xsl:text>Other</xsl:text>
									</xsl:attribute>

									<xsl:element name="pidx:DocumentIdentifier">
										<xsl:value-of select="$refName"/>
									</xsl:element>
									<xsl:element name="pidx:ReferenceInformation">
										<xsl:attribute name="referenceInformationIndicator">
											<xsl:text>Other</xsl:text>
										</xsl:attribute>
										<xsl:element name="pidx:Description">
											<xsl:value-of select="."/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="DeliveryAddress/Address">

							<xsl:call-template name="createParty">
								<xsl:with-param name="partyInfo" select="."/>
								<xsl:with-param name="partyRole" select="'ShipToParty'"/>
							</xsl:call-template>
						</xsl:for-each>

						<xsl:if test="normalize-space(@quantity) != ''">
							<xsl:element name="pidx:CustomerSpecificInformation">
								<xsl:attribute name="informationType"
									>ReceivedQuantity</xsl:attribute>
								<xsl:value-of select="@quantity"/>
							</xsl:element>
						</xsl:if>

						<xsl:if test="normalize-space(UnitRate/UnitOfMeasure) != ''">
							<xsl:element name="pidx:CustomerSpecificInformation">
								<xsl:attribute name="informationType"
									>UnitOfMeasurement</xsl:attribute>
								<!--<xsl:value-of select="UnitRate/UnitOfMeasure"/>-->
								<xsl:call-template name="UOMCodeConversion">
									<xsl:with-param name="UOMCode" select="UnitRate/UnitOfMeasure"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:if>

						<xsl:if
							test="normalize-space(ReceiptItemReference/ItemID/SupplierPartID) != ''">
							<xsl:element name="pidx:CustomerSpecificInformation">
								<xsl:attribute name="informationType">SupplierPartID</xsl:attribute>
								<xsl:value-of select="ReceiptItemReference/ItemID/SupplierPartID"/>
							</xsl:element>
						</xsl:if>

						<xsl:if test="Comments != ''">
							<xsl:element name="pidx:Comment">
								<xsl:value-of select="Comments"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:for-each>
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

				<xsl:element name="pidx:PartnerIdentifier">
					<xsl:attribute name="partnerIdentifierIndicator">AssignedByBuyer</xsl:attribute>
					<xsl:value-of select="@addressID"/>
				</xsl:element>
				<xsl:choose>
					<xsl:when
						test="$partyRole = 'SoldTo' or $partyRole = 'ShipToParty' or $partyRole = 'BillTo'">

						<xsl:if
							test="normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity) != ''">
							<xsl:element name="pidx:PartnerIdentifier">
								<xsl:attribute name="partnerIdentifierIndicator"
									>DUNSNumber</xsl:attribute>
								<xsl:value-of
									select="substring(normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity), 1, 9)"
								/>
							</xsl:element>
							<xsl:if
								test="substring(normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity), 10) != ''">
								<xsl:element name="pidx:PartnerIdentifier">
									<xsl:attribute name="partnerIdentifierIndicator"
										>DUNS+4Number</xsl:attribute>
									<xsl:value-of
										select="normalize-space(/cXML/Header/From/Credential[@domain = 'DUNS']/Identity)"
									/>
								</xsl:element>
							</xsl:if>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$partyRole = 'Seller'">
						<xsl:if
							test="normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity) != ''">
							<xsl:element name="pidx:PartnerIdentifier">
								<xsl:attribute name="partnerIdentifierIndicator"
									>DUNSNumber</xsl:attribute>
								<xsl:value-of
									select="substring(normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity), 1, 9)"
								/>
							</xsl:element>
							<xsl:if
								test="substring(normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity), 10) != ''">
								<xsl:element name="pidx:PartnerIdentifier">
									<xsl:attribute name="partnerIdentifierIndicator"
										>DUNS+4Number</xsl:attribute>
									<xsl:value-of
										select="normalize-space(/cXML/Header/To/Credential[@domain = 'DUNS']/Identity)"
									/>
								</xsl:element>
							</xsl:if>
						</xsl:if>
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
								<xsl:value-of
									select="$partyInfo/PostalAddress/Country/@isoCountryCode"/>
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
							<xsl:variable name="areaCode"
								select="normalize-space($partyInfo/Phone/TelephoneNumber/AreaOrCityCode)"/>

							<xsl:variable name="countryCode"
								select="normalize-space($partyInfo/Phone/TelephoneNumber/CountryCode)"/>


							<xsl:element name="pidx:Telephone">
								<xsl:attribute name="telephoneIndicator">
									<xsl:text>Voice</xsl:text>
								</xsl:attribute>
								<xsl:element name="pidx:PhoneNumber">
									<xsl:value-of select="$partyInfo/Phone/TelephoneNumber/Number"/>
								</xsl:element>
								<xsl:element name="pidx:PhoneNumberExtension">
									<xsl:value-of
										select="$partyInfo/Phone/TelephoneNumber/Extension"/>
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
							<xsl:variable name="areaCode"
								select="normalize-space($partyInfo/Fax/TelephoneNumber/AreaOrCityCode)"/>

							<xsl:variable name="countryCode"
								select="normalize-space($partyInfo/Fax/TelephoneNumber/CountryCode)"/>


							<xsl:element name="pidx:Telephone">
								<xsl:attribute name="telephoneIndicator">
									<xsl:text>Fax</xsl:text>
								</xsl:attribute>
								<xsl:element name="pidx:PhoneNumber">
									<xsl:value-of select="$partyInfo/Fax/TelephoneNumber/Number"/>
								</xsl:element>
								<xsl:element name="pidx:PhoneNumberExtension">
									<xsl:value-of select="$partyInfo/Fax/TelephoneNumber/Extension"
									/>
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
				<xsl:if test="$partyInfo/URL">
					<xsl:element name="pidx:URL">
						<xsl:value-of select="$partyInfo/URL"/>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template name="UOMCodeConversion">
		<xsl:param name="UOMCode"/>
		<xsl:choose>
			<xsl:when
				test="lower-case($anANSILookupFlag) = 'true' and $cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[CXMLCode = $UOMCode]/PIDXCode != ''">
				<xsl:value-of
					select="$cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[CXMLCode = $UOMCode]/PIDXCode"
				/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$UOMCode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
