<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anSenderID"/>
	<xsl:param name="anReceiverID"/>

	<!--<xsl:include href="pd:HCIOWNERPID:FORMAT_cXML_0000_BIS_3.0:Binary"/>-->

	<xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_BIS_3.0:Binary')"/>

	<!--<xsl:variable name="Lookup" select="document('LOOKUP_BIS_3.0.xml')"/>-->


	<xsl:template match="/">
		<ubl:Invoice xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">

			<xsl:element name="cbc:CustomizationID">
				<xsl:value-of select="'urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_2.1'"/>
			</xsl:element>
			<!--<xsl:element name="cbc:ProfileID"><xsl:value-of select="'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0'"/></xsl:element>-->
			<xsl:element name="cbc:ID">
				<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceID"/>
			</xsl:element>
			<xsl:element name="cbc:IssueDate">
				<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate, 'T')"/>
			</xsl:element>
			<!--<xsl:element name="cbc:IssueTime"><xsl:value-of select="substring-after(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate, 'T')"/> </xsl:element>-->
			<xsl:variable name="invType">
				<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose"/>
			</xsl:variable>
			<xsl:element name="cbc:InvoiceTypeCode">
				<xsl:choose>
					<xsl:when test="$invType = 'standard'">380</xsl:when>
					<xsl:when test="$invType = 'lineLevelCreditMemo'">381</xsl:when>
					<xsl:when test="$invType = 'lineLevelDebitMemo'">383</xsl:when>
				</xsl:choose>
			</xsl:element>
			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/text() != ''">
				<xsl:element name="cbc:Note">
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/text()[1]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/@taxPointDate != ''">
				<xsl:element name="cbc:TaxPointDate">
					<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/@taxPointDate, 'T')"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="cbc:DocumentCurrencyCode">
				<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/DueAmount/Money/@currency"/>
			</xsl:element>
			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@alternateCurrency != ''">
				<xsl:element name="cbc:TaxCurrencyCode">
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@alternateCurrency"/>
				</xsl:element>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerLeitwegID'] != ''">
					<xsl:element name="cbc:BuyerReference">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerLeitwegID']"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="/cXML/Header/To/Credential[@domain = 'SystemID']/Identity != ''">
					<xsl:element name="cbc:BuyerReference">
						<xsl:value-of select="/cXML/Header/To/Credential[@domain = 'SystemID']/Identity"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Period/@startDate != '' or /cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Period/@endDate != ''">
				<xsl:element name="cac:InvoicePeriod">
					<xsl:element name="cbc:StartDate">
						<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Period/@startDate, 'T')"/>
					</xsl:element>
					<xsl:element name="cbc:EndDate">
						<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Period/@endDate, 'T')"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/OrderReference/@orderID != ''">
				<xsl:element name="cac:OrderReference">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/OrderReference/@orderID"/>
					</xsl:element>
					<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderID != ''">
						<xsl:element name="cbc:SalesOrderID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderID"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceID != ''">
				<xsl:element name="cac:BillingReference">
					<xsl:element name="cac:InvoiceDocumentReference">
						<xsl:element name="cbc:ID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceID"/>
						</xsl:element>
						<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceDate != ''">
							<xsl:element name="cbc:IssueDate">
								<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceDate, 'T')"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/ShipNoticeIDInfo/@shipNoticeID != ''">
				<xsl:element name="cac:DespatchDocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/ShipNoticeIDInfo/@shipNoticeID"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailReceiptInfo/ReceiptReference/@receiptID != ''">
				<xsl:element name="cac:ReceiptDocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailReceiptInfo/ReceiptReference/@receiptID"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID != ''">
				<xsl:element name="cac:ContractDocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<!-- IG-37223 -->
			<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'Attachments']/Extrinsic[@name = 'Attachment']">
				<xsl:if test="Extrinsic[@name ='id']!=''">
				<xsl:element name="cac:AdditionalDocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:value-of select="Extrinsic[@name ='id']"/>					
					</xsl:element>					
					<xsl:element name="cac:Attachment">
						<xsl:element name="cbc:EmbeddedDocumentBinaryObject">
							<xsl:attribute name="mimeCode">
								<xsl:value-of select="Extrinsic[@name ='contentType']"/>
							</xsl:attribute>
							<xsl:attribute name="filename">
								<xsl:value-of select="Extrinsic[@name ='fileName']"/>
							</xsl:attribute>
							<xsl:value-of select="Extrinsic[@name ='content']"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				</xsl:if>
			</xsl:for-each>
			
			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role='shipFrom']/PostalAddress/Country/@isoCountryCode!=''">
			<xsl:element name="cac:AdditionalDocumentReference">
				<xsl:element name="cbc:ID">
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role='shipFrom']/PostalAddress/Country/@isoCountryCode"/>
				</xsl:element>				
				<xsl:element name="cbc:DocumentDescription">ShipFromCountryCode</xsl:element>
			</xsl:element>
			</xsl:if>
			<!-- IG-35677 
				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'DeliveryNoteNumber'] != ''">
		<xsl:element name="cac:AdditionalDocumentReference">
			<xsl:element name="cbc:ID">
				<xsl:attribute name="schemeID">DQ</xsl:attribute>
				<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'DeliveryNoteNumber']"/>
			</xsl:element>
			<xsl:element name="cbc:DocumentTypeCode">130</xsl:element>
		</xsl:element>
	</xsl:if>

	<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/PaymentProposalIDInfo/@paymentProposalID != ''">
		<xsl:element name="cac:AdditionalDocumentReference">
			<xsl:element name="cbc:ID">
				<xsl:attribute name="schemeID">AGA</xsl:attribute>
				<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/PaymentProposalIDInfo/@paymentProposalID"/>
			</xsl:element>
			<xsl:element name="cbc:DocumentTypeCode">130</xsl:element>
		</xsl:element>
	</xsl:if>

	<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'ultimateCustomerReferenceID'] != ''">
		<xsl:element name="cac:AdditionalDocumentReference">
			<xsl:element name="cbc:ID">
				<xsl:attribute name="schemeID">UC</xsl:attribute>
				<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'ultimateCustomerReferenceID']"/>
			</xsl:element>
			<xsl:element name="cbc:DocumentTypeCode">130</xsl:element>
		</xsl:element>
	</xsl:if>

	<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/ShipNoticeIDInfo/IdReference[@domain = 'packListID']/@identifier != ''">
		<xsl:element name="cac:AdditionalDocumentReference">
			<xsl:element name="cbc:ID">
				<xsl:attribute name="schemeID">PK</xsl:attribute>
				<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/ShipNoticeIDInfo/IdReference[@domain = 'packListID']/@identifier"/>
			</xsl:element>
			<xsl:element name="cbc:DocumentTypeCode">130</xsl:element>
		</xsl:element>
	</xsl:if>
	<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic">
		<xsl:if test="@name != 'ultimateCustomerReferenceID' and @name != 'DeliveryNoteNumber'">
			<xsl:element name="cac:AdditionalDocumentReference">
				<xsl:element name="cbc:ID">
					<xsl:attribute name="schemeID">ZZZ</xsl:attribute>
					<xsl:value-of select="."/>
				</xsl:element>
				<xsl:element name="cbc:DocumentTypeCode">130</xsl:element>
				<xsl:element name="cbc:DocumentDescription">
					<xsl:value-of select="@name"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:for-each>

	<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/IdReference">
		<xsl:element name="cac:AdditionalDocumentReference">
			<xsl:element name="cbc:ID">
				<xsl:attribute name="schemeID">
					<xsl:value-of select="@domain"/>
				</xsl:attribute>
				<xsl:value-of select="@identifier"/>
			</xsl:element>
			<xsl:element name="cbc:DocumentTypeCode">130</xsl:element>
		</xsl:element>
	</xsl:for-each-->

			<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner">
				<xsl:variable name="urole" select="Contact/@role"/>
				<xsl:choose>
					<xsl:when test="$urole = 'from'">
						<xsl:variable name="vatIDTemp">
							<xsl:choose>
								<xsl:when test="Contact/IdReference[@domain = 'vatID']/@identifier != ''">
									<xsl:value-of select="Contact/IdReference[@domain = 'vatID']/@identifier"/>
								</xsl:when>
								<!-- IG-35677 -->
								<xsl:when test="IdReference[@domain = 'vatID']/@identifier != ''">
									<xsl:value-of select="IdReference[@domain = 'vatID']/@identifier"/>
								</xsl:when>
								<xsl:when test="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'supplierVatID'] != ''">
									<xsl:value-of select="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'supplierVatID']"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="INVcreateParty">
							<xsl:with-param name="partyinfo" select="."/>
							<xsl:with-param name="crole" select="$urole"/>
							<xsl:with-param name="partyName" select="'cac:AccountingSupplierParty'"/>
							<xsl:with-param name="vatID" select="$vatIDTemp"/>
							<!-- IG-35677 -->
							<xsl:with-param name="endPoint" select="'9930'"/>
							<xsl:with-param name="endPointID" select="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'supplierVatID']"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$urole = 'soldTo'">
						<xsl:variable name="vatIDTemp">
							<xsl:choose>
								<xsl:when test="Contact/IdReference[@domain = 'vatID']/@identifier != ''">
									<xsl:value-of select="Contact/IdReference[@domain = 'vatID']/@identifier"/>
								</xsl:when>
								<!-- IG-35677 -->
								<xsl:when test="IdReference[@domain = 'vatID']/@identifier != ''">
									<xsl:value-of select="IdReference[@domain = 'vatID']/@identifier"/>
								</xsl:when>
								<xsl:when test="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerVatID'] != ''">
									<xsl:value-of select="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerVatID']"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="tEndPointID">
							<xsl:choose>
								<xsl:when test="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerLeitwegID'] != ''">
									<xsl:value-of select="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerLeitwegID']"/>
								</xsl:when>
								<xsl:when test="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerVatID'] != ''">
									<xsl:value-of select="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerVatID']"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="tEndPoint">
							<xsl:choose>
								<xsl:when test="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerLeitwegID'] != ''">
									<xsl:value-of select="'0204'"/>
								</xsl:when>
								<xsl:when test="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'buyerVatID'] != ''">
									<xsl:value-of select="'9930'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="INVcreateParty">
							<xsl:with-param name="partyinfo" select="."/>
							<xsl:with-param name="crole" select="$urole"/>
							<xsl:with-param name="partyName" select="'cac:AccountingCustomerParty'"/>
							<xsl:with-param name="vatID" select="$vatIDTemp"/>
							<!-- IG-35677 -->
							<xsl:with-param name="endPoint" select="$tEndPoint"/>
							<xsl:with-param name="endPointID" select="$tEndPointID"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$urole = 'payee'">
						<xsl:element name="cac:PayeeParty">
							<xsl:for-each select="./Contact/IdReference | ./IdReference">
								<xsl:variable name="idRefCode">
									<xsl:variable name="code" select="./@domain"/>
									<xsl:value-of select="$Lookup/Lookups/ICDCodes/ICDCode[cXMLCode = $code]/UBLCode"/>
								</xsl:variable>
								<xsl:if test="$idRefCode != ''">
									<xsl:element name="cac:PartyIdentification">
										<xsl:element name="cbc:ID">
											<xsl:attribute name="schemeID" select="$idRefCode"/>
											<xsl:value-of select="normalize-space(@identifier)"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:for-each>
							<xsl:if test="normalize-space(Contact/Name) != ''">
								<xsl:element name="cac:PartyName">
									<xsl:element name="cbc:Name">
										<xsl:value-of select="normalize-space(Contact/Name)"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:variable name="tLegalEntity">
								<xsl:choose>
									<xsl:when test="normalize-space(./Contact/IdReference[@domain = 'companyRegistrationNumber']/@identifier) != ''">
										<xsl:value-of select="normalize-space(Contact/IdReference[@domain = 'companyRegistrationNumber']/@identifier)"/>
									</xsl:when>
									<xsl:when test="normalize-space(./IdReference[@domain = 'companyRegistrationNumber']/@identifier) != ''">
										<xsl:value-of select="normalize-space(./IdReference[@domain = 'companyRegistrationNumber']/@identifier)"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="$tLegalEntity != ''">
								<xsl:element name="cac:PartyLegalEntity">
									<xsl:element name="cbc:CompanyID">
										<xsl:value-of select="$tLegalEntity"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$urole = 'taxRepresentative'">
						<xsl:element name="cac:TaxRepresentativeParty">
							<xsl:if test="normalize-space(Contact/Name) != ''">
								<xsl:element name="cac:PartyName">
									<xsl:element name="cbc:Name">
										<xsl:value-of select="normalize-space(Contact/Name)"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:element name="cac:PostalAddress">
								<xsl:call-template name="createAddress">
									<xsl:with-param name="partyName" select="'TaxRepresentativeParty'"/>
									<xsl:with-param name="partyContact" select="./Contact"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:variable name="vatID">
								<xsl:choose>
									<xsl:when test="Contact/IdReference[@domain = 'vatID']/@identifier != ''">
										<xsl:value-of select="Contact/IdReference[@domain = 'vatID']/@identifier"/>
									</xsl:when>
									<xsl:when test="IdReference[@domain = 'vatID']/@identifier != ''">
										<xsl:value-of select="IdReference[@domain = 'vatID']/@identifier"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="$vatID != ''">
								<xsl:element name="cac:PartyTaxScheme">
									<xsl:element name="cbc:CompanyID">
										<xsl:value-of select="$vatID"/>
									</xsl:element>
									<xsl:element name="cac:TaxScheme">
										<xsl:element name="cbc:ID">
											<xsl:value-of select="'VAT'"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']">
				<xsl:element name="cac:Delivery">
					<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'deliveryDate'] != ''">
						<xsl:element name="cbc:ActualDeliveryDate">
							<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'deliveryDate'], 'T')"/>
						</xsl:element>
					</xsl:if>
					<xsl:variable name="idRefCode">
						<xsl:variable name="code" select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']/@addressIDDomain"/>
						<xsl:value-of select="$Lookup/Lookups/ICDCodes/ICDCode[cXMLCode = $code]/UBLCode"/>
					</xsl:variable>
					<xsl:element name="cac:DeliveryLocation">
						<!-- IG-35677 -->
						<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']/@addressID != '' and $idRefCode!=''">
							<xsl:element name="cbc:ID">
								<xsl:attribute name="schemeID" select="$idRefCode"/>
								<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']/@addressID"/>
							</xsl:element>
						</xsl:if>
						<xsl:element name="cac:Address">
							<xsl:call-template name="createAddress">
								<xsl:with-param name="partyName" select="'Delivery'"/>
								<xsl:with-param name="partyContact" select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']"/>
							</xsl:call-template>
						</xsl:element>
					</xsl:element>

					<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']/Name != ''">
						<xsl:element name="cac:DeliveryParty">
							<xsl:element name="cac:PartyName">
								<xsl:element name="cbc:Name">
									<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']/Name)"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'paymentMethod'] != ''">
				<xsl:variable name="paymentMCode">
					<xsl:variable name="payMeansCode">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'paymentMethod']"/>
					</xsl:variable>
					<xsl:variable name="ibanCode">
						<xsl:choose>
							<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier != ''">
								<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier"/>
							</xsl:when>
							<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier != ''">
								<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="accountCode">
						<xsl:choose>
							<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier != ''">
								<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier"/>
							</xsl:when>
							<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier != ''">
								<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$payMeansCode = 'cash'">10</xsl:when>
						<xsl:when test="$payMeansCode = 'check'">20</xsl:when>
						<xsl:when test="$payMeansCode = 'draft'">21</xsl:when>
						<xsl:when test="$payMeansCode = 'wire' and $ibanCode != ''">58</xsl:when>
						<xsl:when test="$payMeansCode = 'wire' and $accountCode != ''">30</xsl:when>
						<xsl:when test="$payMeansCode = 'promissoryNote'">60</xsl:when>
						<xsl:when test="$payMeansCode = 'creditorOnTheDebitor'">70</xsl:when>
						<xsl:when test="$payMeansCode = 'other'">ZZZ</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$paymentMCode != ''">
					<xsl:element name="cac:PaymentMeans">
						<xsl:element name="cbc:PaymentMeansCode">
							<xsl:value-of select="$paymentMCode"/>
						</xsl:element>
						<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'paymentReference'] != ''">
							<xsl:element name="cbc:PaymentID">
								<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'paymentReference']"/>
							</xsl:element>
						</xsl:if>

						<xsl:variable name="pfacID">
							<xsl:choose>
								<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier) != ''">
									<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier)"/>
								</xsl:when>
								<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier) != ''">
									<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'ibanID']/@identifier)"/>
								</xsl:when>
								<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier) != ''">
									<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier)"/>
								</xsl:when>
								<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier) != ''">
									<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'accountID']/@identifier)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:if test="($paymentMCode = '30' or $paymentMCode = '58') and $pfacID != ''">
							<xsl:element name="cac:PayeeFinancialAccount">
								<xsl:element name="cbc:ID">
									<xsl:value-of select="$pfacID"/>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'accountName']/@identifier != ''">
										<xsl:element name="cbc:Name">
											<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'accountName']/@identifier"/>
										</xsl:element>
									</xsl:when>
									<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'accountName']/@identifier != ''">
										<xsl:element name="cbc:Name">
											<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'accountName']/@identifier"/>
										</xsl:element>
									</xsl:when>
									<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/Name != ''">
										<xsl:element name="cbc:Name">
											<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/Name"/>
										</xsl:element>
									</xsl:when>
								</xsl:choose>

								<xsl:variable name="fibID">
									<xsl:choose>
										<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'swiftID']/@identifier) != ''">
											<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'swiftID']/@identifier)"/>
										</xsl:when>
										<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'swiftID']/@identifier) != ''">
											<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'swiftID']/@identifier)"/>
										</xsl:when>
										<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier) != ''">
											<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'wireReceivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier)"/>
										</xsl:when>
										<xsl:when test="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier) != ''">
											<xsl:value-of select="normalize-space(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'wireReceivingBank']/IdReference[@domain = 'bankRoutingID']/@identifier)"/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>

								<xsl:if test="$fibID != ''">
									<xsl:element name="cac:FinancialInstitutionBranch">
										<xsl:element name="cbc:ID">
											<xsl:value-of select="$fibID"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
			</xsl:if>

			
			<xsl:variable name="paymentTermsList">
				<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/PaymentTerm">
					<xsl:variable name="sign">
						<xsl:choose>
							<xsl:when test="normalize-space(Discount/DiscountPercent/@percent)= ''">
								<xsl:value-of select="'#SKONTO'"/>
							</xsl:when>
							<xsl:when test="not(exists(Discount/DiscountPercent/@percent))">
								<xsl:value-of select="'#SKONTO'"/>
							</xsl:when>
							<xsl:when test="Discount/DiscountPercent/@percent &gt;= 0">
								<xsl:value-of select="'#SKONTO'"/>
							</xsl:when>							
							<xsl:when test="Discount/DiscountPercent/@percent &lt; 0">
								<xsl:value-of select="'#VERZUG'"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="days">
						<xsl:if test="@payInNumberOfDays != ''">
							<xsl:value-of select="concat('#TAGE=', @payInNumberOfDays)"/>
						</xsl:if>
					</xsl:variable>
					
					<xsl:variable name="percent">
						<xsl:choose>
							<xsl:when test="normalize-space(Discount/DiscountPercent/@percent)= ''">								
								<xsl:value-of select="concat('#PROZENT=', '0.00', '#')"/>
							</xsl:when>
							<xsl:when test="not(exists(Discount/DiscountPercent/@percent))">
								<xsl:value-of select="concat('#PROZENT=', '0.00', '#')"/>
							</xsl:when>
							
							<xsl:when test="Discount/DiscountPercent/@percent &gt;= 0">
								<xsl:value-of select="concat('#PROZENT=', format-number(abs(number(Discount/DiscountPercent/@percent)), '0.00'), '#')"/>
							</xsl:when>
							
							<xsl:when test="Discount/DiscountPercent/@percent &lt; 0">
								<xsl:value-of select="concat('#PROZENT=', format-number(abs(number(Discount/DiscountPercent/@percent)), '0.00'), '#')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>					
					
					<xsl:choose>
						<xsl:when test="$percent!=''">
							<xsl:value-of select="concat($sign, $days, $percent, '&#xa;')"/>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:value-of select="concat($sign, $days, '&#xa;')"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:for-each>
			</xsl:variable>
						
			<xsl:variable name="InvoiceDetailPaymentTermList">				
				<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailPaymentTerm">
					<xsl:variable name="sign">
						<xsl:choose>
							<xsl:when test="normalize-space(@percentageRate)= ''">
								<xsl:value-of select="'#SKONTO'"/>
							</xsl:when>
							<xsl:when test="not(exists(@percentageRate))">
								<xsl:value-of select="'#SKONTO'"/>
							</xsl:when>
							<xsl:when test="@percentageRate &gt;= 0">
								<xsl:value-of select="'#SKONTO'"/>
							</xsl:when>
							<xsl:when test="@percentageRate &lt; 0">
								<xsl:value-of select="'#VERZUG'"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="days">
						<xsl:if test="@payInNumberOfDays != ''">
							<xsl:value-of select="concat('#TAGE=', @payInNumberOfDays)"/>
						</xsl:if>
					</xsl:variable>
					
					<xsl:variable name="percent">
						<xsl:choose>
							<xsl:when test="normalize-space(@percentageRate)= ''">
								<xsl:value-of select="concat('#PROZENT=', '0.00', '#')"/>
							</xsl:when>
							<xsl:when test="not(exists(@percentageRate))">
								<xsl:value-of select="concat('#PROZENT=', '0.00', '#')"/>
							</xsl:when>
							
							<xsl:when test="@percentageRate &gt;= 0">
								<xsl:value-of select="concat('#PROZENT=', format-number(abs(number(@percentageRate)), '0.00'), '#')"/>
							</xsl:when>
							
							<xsl:when test="Discount/DiscountPercent/@percent &lt; 0">
								<xsl:value-of select="concat('#PROZENT=', format-number(abs(number(@percentageRate)), '0.00'), '#')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="$percent!=''">
							<xsl:value-of select="concat($sign, $days, $percent, '&#xa;')"/>
						</xsl:when>
						<xsl:otherwise>							
							<xsl:value-of select="concat($sign, $days, '&#xa;')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="paymentTermsText">
				<xsl:choose>
					<xsl:when test="$paymentTermsList != ''">
						<xsl:value-of select="$paymentTermsList"/>
					</xsl:when>
					<xsl:when test="$InvoiceDetailPaymentTermList != ''">
						<xsl:value-of select="$InvoiceDetailPaymentTermList"/>
					</xsl:when>
					<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'discountInformation'] != ''">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'discountInformation']"/>
					</xsl:when>
					<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'netTermInformation'] != ''">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'netTermInformation']"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$paymentTermsText != ''">
				<xsl:element name="cac:PaymentTerms">
					<xsl:element name="cbc:Note">
						<xsl:value-of select="$paymentTermsText"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money != ''">
				<xsl:element name="cac:AllowanceCharge">
					<xsl:element name="cbc:ChargeIndicator">false</xsl:element>
					<xsl:element name="cbc:AllowanceChargeReasonCode">95</xsl:element>
					<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/@percentageRate != ''">
						<xsl:element name="cbc:MultiplierFactorNumeric">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/@percentageRate"/>
						</xsl:element>
					</xsl:if>
					<xsl:element name="cbc:Amount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money"/>
					</xsl:element>
					<xsl:element name="cac:TaxCategory">
						<xsl:element name="cbc:ID">
							<xsl:value-of select="'S'"/>
						</xsl:element>
						<xsl:element name="cac:TaxScheme">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="'VAT'"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money != ''">
				<xsl:element name="cac:AllowanceCharge">
					<xsl:element name="cbc:ChargeIndicator">true</xsl:element>
					<xsl:element name="cbc:AllowanceChargeReasonCode">SAA</xsl:element>
					<xsl:element name="cbc:Amount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money"/>
					</xsl:element>
					<xsl:element name="cac:TaxCategory">
						<xsl:element name="cbc:ID">
							<xsl:value-of select="'S'"/>
						</xsl:element>
						<xsl:element name="cac:TaxScheme">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="'VAT'"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money != ''">
				<xsl:element name="cac:AllowanceCharge">
					<xsl:element name="cbc:ChargeIndicator">true</xsl:element>
					<xsl:element name="cbc:AllowanceChargeReasonCode">SH</xsl:element>
					<xsl:element name="cbc:Amount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money"/>
					</xsl:element>
					<xsl:element name="cac:TaxCategory">
						<xsl:element name="cbc:ID">
							<xsl:value-of select="'S'"/>
						</xsl:element>
						<xsl:element name="cac:TaxScheme">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="'VAT'"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name != 'RoundingAmount']">
				<xsl:call-template name="mapModification">
					<xsl:with-param name="level" select="'header'"/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:element name="cac:TaxTotal">
				<xsl:element name="cbc:TaxAmount">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@currency"/>
					</xsl:attribute>
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money"/>
				</xsl:element>

				<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail">
					<xsl:if test="TaxableAmount/Money != ''">
						<xsl:element name="cac:TaxSubtotal">
							<xsl:element name="cbc:TaxableAmount">
								<xsl:attribute name="currencyID">
									<xsl:value-of select="TaxableAmount/Money/@currency"/>
								</xsl:attribute>
								<xsl:value-of select="TaxableAmount/Money"/>
							</xsl:element>
							<xsl:element name="cbc:TaxAmount">
								<xsl:attribute name="currencyID">
									<xsl:value-of select="TaxAmount/Money/@currency"/>
								</xsl:attribute>
								<xsl:value-of select="TaxAmount/Money"/>
							</xsl:element>
							<xsl:call-template name="mapTaxCategory"/>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@alternateAmount != ''">
				<!-- create only if currency and alt currency is different -->
				<xsl:variable name="altcurr">
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@alternateCurrency"></xsl:value-of>
				</xsl:variable>
				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@currency!=$altcurr">
				<xsl:element name="cac:TaxTotal">
					<xsl:element name="cbc:TaxAmount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@alternateCurrency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@alternateAmount"/>
					</xsl:element>
				</xsl:element>
				</xsl:if>
			</xsl:if>

			<xsl:element name="cac:LegalMonetaryTotal">
				<xsl:element name="cbc:LineExtensionAmount">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money/@currency"/>
					</xsl:attribute>
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money"/>
				</xsl:element>

				<xsl:element name="cbc:TaxExclusiveAmount">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalAmountWithoutTax/Money/@currency"/>
					</xsl:attribute>
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalAmountWithoutTax/Money"/>
				</xsl:element>

				<xsl:element name="cbc:TaxInclusiveAmount">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/NetAmount/Money/@currency"/>
					</xsl:attribute>
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/NetAmount/Money"/>
				</xsl:element>

				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalAllowances/Money != ''">
					<xsl:element name="cbc:AllowanceTotalAmount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalAllowances/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalAllowances/Money"/>
					</xsl:element>
				</xsl:if>

				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalCharges/Money != ''">
					<xsl:element name="cbc:ChargeTotalAmount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalCharges/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/TotalCharges/Money"/>
					</xsl:element>
				</xsl:if>

				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/DepositAmount/Money != ''">
					<xsl:element name="cbc:PrepaidAmount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/DepositAmount/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/DepositAmount/Money"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'RoundingAmount']/AdditionalCost/Money != ''">
					<xsl:element name="cbc:PayableRoundingAmount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'RoundingAmount']/AdditionalCost/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceHeaderModifications/Modification[ModificationDetail/@name = 'RoundingAmount']/AdditionalCost/Money"/>
					</xsl:element>
				</xsl:if>

				<xsl:element name="cbc:PayableAmount">
					<xsl:attribute name="currencyID">
						<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/DueAmount/Money/@currency"/>
					</xsl:attribute>
					<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/DueAmount/Money"/>
				</xsl:element>

			</xsl:element>
			<!-- InvoiceDetailItem -->
			<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
				<xsl:call-template name="INVLine">

					<xsl:with-param name="invLineInfo" select="."/>
					<xsl:with-param name="invLineItemName" select="'InvoiceDetailItem'"/>
				</xsl:call-template>

			</xsl:for-each>
			<!-- InvoiceDetailServiceItem -->
			<xsl:for-each select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem">
				<xsl:call-template name="INVLine">

					<xsl:with-param name="invLineInfo" select="."/>
					<xsl:with-param name="invLineItemName" select="'InvoiceDetailServiceItem'"/>
				</xsl:call-template>

			</xsl:for-each>
		</ubl:Invoice>
	</xsl:template>

	<xsl:template name="INVcreateParty" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
		<xsl:param name="partyinfo"/>
		<xsl:param name="crole"/>
		<xsl:param name="partyName"/>
		<xsl:param name="vatID"/>
		<xsl:param name="endPoint"/>
		<xsl:param name="endPointID"/>

		<xsl:element name="{$partyName}">
			<xsl:element name="cac:Party">
				<xsl:element name="cbc:EndpointID">
					<xsl:attribute name="schemeID" select="$endPoint"/>
					<xsl:value-of select="$endPointID"/>
				</xsl:element>

				<xsl:if test="$partyName = 'cac:AccountingSupplierParty'">
					<xsl:choose>
						<xsl:when test="$partyinfo/Contact/IdReference[@domain = 'creditorRefID']">
							<xsl:element name="cac:PartyIdentification">
								<xsl:element name="cbc:ID">
									<xsl:attribute name="schemeID" select="'SEPA'"/>
									<xsl:value-of select="normalize-space($partyinfo/Contact/IdReference[@domain = 'creditorRefID']/@identifier)"/>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="$partyinfo/IdReference[@domain = 'creditorRefID']">
							<xsl:element name="cac:PartyIdentification">
								<xsl:element name="cbc:ID">
									<xsl:attribute name="schemeID" select="'SEPA'"/>
									<xsl:value-of select="normalize-space($partyinfo/IdReference[@domain = 'creditorRefID']/@identifier)"/>
								</xsl:element>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				
				<xsl:if test="$partyName = 'cac:AccountingSupplierParty' and /cXML/Header/From/Credential[@domain = 'VendorID']/Identity!=''">					
					<xsl:element name="cac:PartyIdentification">
						<xsl:element name="cbc:ID">							
							<xsl:value-of select="normalize-space(/cXML/Header/From/Credential[@domain = 'VendorID']/Identity)"/>
											
						</xsl:element>
					</xsl:element>
				</xsl:if>
				
				<xsl:variable name="addrID">
					<xsl:variable name="code" select="$partyinfo/Contact/@addressIDDomain"/>
					<xsl:value-of select="$Lookup/Lookups/ICDCodes/ICDCode[cXMLCode = $code]/UBLCode"/>
				</xsl:variable>

				<xsl:if test="$addrID != ''">
					<xsl:element name="cac:PartyIdentification">
						<xsl:element name="cbc:ID">
							<xsl:attribute name="schemeID" select="$addrID"/>
							<xsl:value-of select="normalize-space($partyinfo/Contact/@addressID)"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="$partyName = 'cac:AccountingSupplierParty'">
					<xsl:for-each select="$partyinfo/Contact/IdReference[@domain != 'creditorRefID'] | $partyinfo/IdReference[@domain != 'creditorRefID']">
						<xsl:variable name="idRefCode">
							<xsl:variable name="code" select="./@domain"/>
							<xsl:value-of select="$Lookup/Lookups/ICDCodes/ICDCode[cXMLCode = $code]/UBLCode"/>
						</xsl:variable>
						<xsl:if test="$idRefCode != ''">
							<xsl:element name="cac:PartyIdentification">
								<xsl:element name="cbc:ID">
									<xsl:attribute name="schemeID" select="$idRefCode"/>
									<xsl:value-of select="normalize-space(@identifier)"/>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>

				<xsl:if test="normalize-space($partyinfo/Contact/Name) != '' or (/cXML/Header/From/Correspondent/Contact/Name != '' and $partyName = 'cac:AccountingSupplierParty')">
					<xsl:element name="cac:PartyName">
						<xsl:element name="cbc:Name">
							<xsl:choose>
								<xsl:when test="$partyinfo/Contact/Name != ''">
									<xsl:value-of select="normalize-space($partyinfo/Contact/Name)"/>
								</xsl:when>

								<xsl:when test="/cXML/Header/From/Correspondent/Contact/Name != '' and $partyName = 'cac:AccountingSupplierParty'">
									<xsl:value-of select="/cXML/Header/From/Correspondent/Contact/Name"/>
								</xsl:when>
							</xsl:choose>

						</xsl:element>
					</xsl:element>
				</xsl:if>

				<xsl:element name="cac:PostalAddress">
					<xsl:call-template name="createAddress">
						<xsl:with-param name="partyContact" select="$partyinfo/Contact"/>
						<xsl:with-param name="partyName" select="$partyName"/>
					</xsl:call-template>
				</xsl:element>

				<xsl:if test="$vatID != ''">
					<xsl:element name="cac:PartyTaxScheme">
						<xsl:element name="cbc:CompanyID">
							<xsl:value-of select="$vatID"/>
						</xsl:element>
						<xsl:element name="cac:TaxScheme">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="'VAT'"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>

				<xsl:if test="$partyName = 'cac:AccountingSupplierParty'">
					<!-- IG-35677 -->
					<xsl:variable name="partyTaxID">
						<xsl:choose>
							<xsl:when test="$partyinfo/Contact/IdReference[lower-case(@domain) = 'suppliertaxid']/@identifier != ''">
								<xsl:value-of select="normalize-space($partyinfo/Contact/IdReference[lower-case(@domain) = 'suppliertaxid']/@identifier)"/>
							</xsl:when>
							<xsl:when test="$partyinfo/IdReference[lower-case(@domain) = 'suppliertaxid']/@identifier != ''">
								<xsl:value-of select="normalize-space($partyinfo/IdReference[lower-case(@domain) = 'suppliertaxid']/@identifier)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$partyTaxID != ''">
						<xsl:element name="cac:PartyTaxScheme">
							<xsl:element name="cbc:CompanyID">
								<xsl:value-of select="$partyTaxID"/>
							</xsl:element>
							<xsl:element name="cac:TaxScheme">
								<xsl:element name="cbc:ID">
									<xsl:value-of select="'TAX'"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:if>

				<xsl:if test="$partyinfo/Contact/Name != ''">
					<xsl:element name="cac:PartyLegalEntity">
						<xsl:element name="cbc:RegistrationName">
							<xsl:value-of select="$partyinfo/Contact/Name"/>
						</xsl:element>
						<xsl:if test="$partyName = 'cac:AccountingSupplierParty'">
							<xsl:if test="normalize-space(//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'supplierCommercialIdentifier']) != ''">
								<xsl:element name="cbc:CompanyID">
									<xsl:value-of select="normalize-space(//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'supplierCommercialIdentifier'])"/>
								</xsl:element>
							</xsl:if>

							<xsl:if test="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[lower-case(@name) = 'legalstatus'] != ''">
								<xsl:element name="cbc:CompanyLegalForm">
									<xsl:value-of select="//cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[lower-case(@name) = 'legalstatus']"/>
								</xsl:element>
							</xsl:if>
						</xsl:if>
					</xsl:element>
				</xsl:if>
				<!-- IG-35677 -->
				<xsl:if test="normalize-space($partyinfo/Contact/IdReference[lower-case(@domain) = 'contactperson']/@identifier) != '' or normalize-space($partyinfo/IdReference[lower-case(@domain) = 'contactperson']/@identifier) != '' or normalize-space($partyinfo/Contact/Name) != ''">
					<xsl:element name="cac:Contact">

						<xsl:element name="cbc:Name">
							<xsl:choose>
								<xsl:when test="$partyinfo/Contact/IdReference[lower-case(@domain) = 'contactperson']/@identifier != ''">
									<xsl:value-of select="$partyinfo/Contact/IdReference[lower-case(@domain) = 'contactperson']/@identifier"/>
								</xsl:when>
								<xsl:when test="$partyinfo/IdReference[lower-case(@domain) = 'contactperson']/@identifier != ''">
									<xsl:value-of select="$partyinfo/IdReference[lower-case(@domain) = 'contactperson']/@identifier"/>
								</xsl:when>
								<xsl:when test="$partyinfo/Contact/Name != ''">
									<xsl:value-of select="$partyinfo/Contact/Name"/>
								</xsl:when>
							</xsl:choose>
						</xsl:element>

						<xsl:choose>
							<xsl:when test="$partyinfo/Contact/Phone[1]/TelephoneNumber/Number != ''">
								<xsl:element name="cbc:Telephone">
									<xsl:value-of select="normalize-space($partyinfo/Contact/Phone[1]/TelephoneNumber/Number)"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="/cXML/Header/From/Correspondent/Contact/Phone[@name = 'work']/TelephoneNumber != '' and $partyName = 'cac:AccountingSupplierParty'">
								<xsl:element name="cbc:Telephone">
									<xsl:value-of select="/cXML/Header/From/Correspondent/Contact/Phone[@name = 'work']/TelephoneNumber"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$partyName = 'cac:AccountingSupplierParty'">
								<xsl:element name="cbc:Telephone">
									<xsl:text>NotAvailable</xsl:text>
								</xsl:element>
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<xsl:when test="normalize-space($partyinfo/Contact/Email) != ''">
								<xsl:element name="cbc:ElectronicMail">
									<xsl:value-of select="normalize-space($partyinfo/Contact/Email)"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$partyName = 'cac:AccountingSupplierParty'">
								<xsl:element name="cbc:ElectronicMail">
									<xsl:text>NotAvailable</xsl:text>
								</xsl:element>
							</xsl:when>
						</xsl:choose>

					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>

	</xsl:template>

	<xsl:template name="createAddress" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
		<xsl:param name="partyContact"/>
		<xsl:param name="partyName"/>

		<xsl:if test="normalize-space($partyContact/PostalAddress/Street[1]) != '' or (//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[1] != '' and $partyName = 'cac:AccountingSupplierParty')">
			<xsl:element name="cbc:StreetName">
				<xsl:choose>
					<xsl:when test="$partyContact/PostalAddress/Street[1] != ''">
						<xsl:value-of select="normalize-space($partyContact/PostalAddress/Street[1])"/>
					</xsl:when>
					<xsl:when test="//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[1] != '' and $partyName = 'cac:AccountingSupplierParty'">
						<xsl:value-of select="//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[1]"/>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
		<xsl:if test="normalize-space($partyContact/PostalAddress/Street[2]) != '' or (//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[2] != '' and $partyName = 'cac:AccountingSupplierParty')">
			<xsl:element name="cbc:AdditionalStreetName">
				<xsl:choose>
					<xsl:when test="$partyContact/PostalAddress/Street[2] != ''">
						<xsl:value-of select="normalize-space($partyContact/PostalAddress/Street[2])"/>
					</xsl:when>
					<xsl:when test="//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[2] != '' and $partyName = 'cac:AccountingSupplierParty'">
						<xsl:value-of select="//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[2]"/>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:if>

		<xsl:if test="normalize-space($partyContact/PostalAddress/City) != '' or (//cXML/Header/From/Correspondent/Contact/PostalAddress/City != '' and $partyName = 'cac:AccountingSupplierParty')">
			<xsl:element name="cbc:CityName">
				<xsl:choose>
					<xsl:when test="$partyContact/PostalAddress/City != ''">
						<xsl:value-of select="normalize-space($partyContact/PostalAddress/City)"/>
					</xsl:when>
					<xsl:when test="//cXML/Header/From/Correspondent/Contact/PostalAddress/City != '' and $partyName = 'cac:AccountingSupplierParty'">
						<xsl:value-of select="//cXML/Header/From/Correspondent/Contact/PostalAddress/City"/>
					</xsl:when>
				</xsl:choose>

			</xsl:element>
		</xsl:if>

		<xsl:if test="normalize-space($partyContact/PostalAddress/PostalCode) != '' or (//cXML/Header/From/Correspondent/Contact/PostalAddress/PostalCode != '' and $partyName = 'cac:AccountingSupplierParty')">
			<xsl:element name="cbc:PostalZone">
				<xsl:choose>
					<xsl:when test="$partyContact/PostalAddress/PostalCode != ''">
						<xsl:value-of select="normalize-space($partyContact/PostalAddress/PostalCode)"/>
					</xsl:when>
					<xsl:when test="//cXML/Header/From/Correspondent/Contact/PostalAddress/PostalCode != '' and $partyName = 'cac:AccountingSupplierParty'">
						<xsl:value-of select="//cXML/Header/From/Correspondent/Contact/PostalAddress/PostalCode"/>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:if>

		<xsl:if test="normalize-space($partyContact/PostalAddress/State) != '' or (//cXML/Header/From/Correspondent/Contact/PostalAddress/State != '' and $partyName = 'cac:AccountingSupplierParty')">
			<xsl:element name="cbc:CountrySubentity">
				<xsl:choose>
					<xsl:when test="$partyContact/PostalAddress/State != ''">
						<xsl:value-of select="normalize-space($partyContact/PostalAddress/State)"/>
					</xsl:when>
					<xsl:when test="//cXML/Header/From/Correspondent/Contact/PostalAddress/State != '' and $partyName = 'cac:AccountingSupplierParty'">
						<xsl:value-of select="//cXML/Header/From/Correspondent/Contact/PostalAddress/State"/>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:if>

		<xsl:if test="normalize-space($partyContact/PostalAddress/Street[3]) != '' or (//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[3] != '' and $partyName = 'cac:AccountingSupplierParty')">
			<xsl:element name="cac:AddressLine">
				<xsl:element name="cbc:Line">
					<xsl:choose>
						<xsl:when test="$partyContact/PostalAddress/Street[3] != ''">
							<xsl:value-of select="normalize-space($partyContact/PostalAddress/Street[3])"/>
						</xsl:when>
						<xsl:when test="//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[3] != '' and $partyName = 'cac:AccountingSupplierParty'">
							<xsl:value-of select="//cXML/Header/From/Correspondent/Contact/PostalAddress/Street[3]"/>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:if>

		<xsl:element name="cac:Country">
			<xsl:element name="cbc:IdentificationCode">
				<xsl:choose>
					<xsl:when test="$partyContact/PostalAddress/Country/@isoCountryCode != ''">
						<xsl:value-of select="normalize-space($partyContact/PostalAddress/Country/@isoCountryCode)"/>
					</xsl:when>
					<xsl:when test="//cXML/Header/From/Correspondent/Contact/PostalAddress/Country/@isoCountryCode != '' and $partyName = 'cac:AccountingSupplierParty'">
						<xsl:value-of select="//cXML/Header/From/Correspondent/Contact/PostalAddress/Country/@isoCountryCode"/>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:element>

	</xsl:template>

	<xsl:template name="INVcreateshipTo" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
		<xsl:param name="partyinfo"/>
		<xsl:param name="crole"/>
		<xsl:param name="partyName"/>

		<xsl:if test="$partyName != ''">
			<xsl:element name="{$partyName}">
				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'deliveryDate'] != ''">
					<xsl:element name="cbc:ActualDeliveryDate">
						<xsl:value-of select="substring-before(/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name = 'deliveryDate'], 'T')"/>
					</xsl:element>
				</xsl:if>

				<xsl:element name="cac:DeliveryLocation">
					<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact/IdReference[@domain = 'EANID']/@identifier != ''">
						<xsl:element name="cbc:ID">
							<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact/IdReference[@domain = 'EANID']/@identifier"/>
						</xsl:element>
					</xsl:if>
					<xsl:element name="cac:Address">
						<xsl:if test="normalize-space($partyinfo/Contact/PostalAddress/Street[1]) != ''">
							<xsl:element name="cbc:StreetName">
								<xsl:value-of select="normalize-space($partyinfo/Contact/PostalAddress/Street[1])"/>
							</xsl:element>
						</xsl:if>

						<xsl:if test="normalize-space($partyinfo/Contact/PostalAddress/City) != ''">
							<xsl:element name="cbc:CityName">
								<xsl:value-of select="normalize-space($partyinfo/Contact/PostalAddress/City)"/>
							</xsl:element>
						</xsl:if>

						<xsl:if test="normalize-space($partyinfo/Contact/PostalAddress/PostalCode) != ''">
							<xsl:element name="cbc:PostalZone">
								<xsl:value-of select="normalize-space($partyinfo/Contact/PostalAddress/PostalCode)"/>
							</xsl:element>
						</xsl:if>

						<xsl:if test="normalize-space($partyinfo/Contact/PostalAddress/State) != ''">
							<xsl:element name="cbc:CountrySubentity">
								<xsl:value-of select="normalize-space($partyinfo/Contact/PostalAddress/State)"/>
							</xsl:element>
						</xsl:if>


						<xsl:element name="cac:Country">
							<xsl:element name="cbc:IdentificationCode">
								<xsl:value-of select="normalize-space($partyinfo/Contact/PostalAddress/Country/@isoCountryCode)"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>



				<xsl:element name="cac:PartyTaxScheme">
					<xsl:element name="cbc:CompanyID">
						<xsl:value-of select="normalize-space($partyinfo/Contact/IdReference[lower-case(@domain) = 'vatid']/@identifier)"/>
					</xsl:element>
					<xsl:element name="cac:TaxScheme">
						<xsl:element name="cbc:ID">
							<xsl:value-of select="'VAT'"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>

		</xsl:if>
	</xsl:template>

	<xsl:template name="INVLine" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
		<xsl:param name="invLineInfo"/>
		<xsl:param name="invLineItemName"/>

		<cac:InvoiceLine>
			<xsl:element name="cbc:ID">
				<xsl:value-of select="@invoiceLineNumber"/>
			</xsl:element>

			<xsl:if test="Comments != ''">
				<xsl:element name="cbc:Note">
					<xsl:value-of select="Comments"/>
				</xsl:element>
			</xsl:if>

			<xsl:element name="cbc:InvoicedQuantity">
				<xsl:variable name="ucode">
					<xsl:value-of select="UnitOfMeasure"/>
				</xsl:variable>
				<xsl:attribute name="unitCode">
					<xsl:value-of select="$ucode"/>
				</xsl:attribute>
				<xsl:value-of select="@quantity"/>
			</xsl:element>

			<xsl:element name="cbc:LineExtensionAmount">
				<xsl:attribute name="currencyID">
					<xsl:value-of select="SubtotalAmount/Money/@currency"/>
				</xsl:attribute>
				<xsl:value-of select="SubtotalAmount/Money"/>
			</xsl:element>

			<xsl:if test="$invLineItemName = 'InvoiceDetailServiceItem'">
				<xsl:if test="Period/@startDate != ''">
					<xsl:element name="cac:InvoicePeriod">
						<xsl:element name="cbc:StartDate">
							<xsl:value-of select="substring-before(Period/@startDate, 'T')"/>
						</xsl:element>
						<xsl:element name="cbc:EndDate">
							<xsl:value-of select="substring-before(Period/@endDate, 'T')"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:if>

			<xsl:if test="InvoiceDetailItemReference/@lineNumber != '' and $invLineItemName = 'InvoiceDetailItem'">
				<xsl:element name="cac:OrderLineReference">
					<xsl:element name="cbc:LineID">
						<xsl:value-of select="InvoiceDetailItemReference/@lineNumber"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="InvoiceDetailServiceItemReference/@lineNumber != '' and $invLineItemName = 'InvoiceDetailServiceItem'">
				<xsl:element name="cac:OrderLineReference">
					<xsl:element name="cbc:LineID">
						<xsl:value-of select="InvoiceDetailServiceItemReference/@lineNumber"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ShipNoticeIDInfo/IdReference[@domain = 'deliveryNoteID']/@identifier != '' and $invLineItemName = 'InvoiceDetailItem'">
				<xsl:element name="cac:DocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">DQ</xsl:attribute>
						<xsl:value-of select="ShipNoticeIDInfo/IdReference[@domain = 'deliveryNoteID']/@identifier"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="ShipNoticeIDInfo/IdReference[@domain = 'ReceivingAdviceID']/@identifier != '' and $invLineItemName = 'InvoiceDetailItem'">
				<xsl:element name="cac:DocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">ALO</xsl:attribute>
						<xsl:value-of select="ShipNoticeIDInfo/IdReference[@domain = 'ReceivingAdviceID']/@identifier"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="(ShipNoticeIDInfo/@shipNoticeID != '' or /cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailShipNoticeInfo/ShipNoticeReference/@shipNoticeID != '') and $invLineItemName = 'InvoiceDetailItem'">
				<xsl:element name="cac:DocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">MA</xsl:attribute>
						<xsl:choose>
							<xsl:when test="ShipNoticeIDInfo/@shipNoticeID != ''">
								<xsl:value-of select="ShipNoticeIDInfo/@shipNoticeID"/>
							</xsl:when>
							<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailShipNoticeInfo/ShipNoticeReference/@shipNoticeID != ''">
								<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailShipNoticeInfo/ShipNoticeReference/@shipNoticeID"/>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="ServiceEntryItemReference/@serviceLineNumber != ''">
				<xsl:element name="cac:DocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">ACE</xsl:attribute>
						<xsl:value-of select="ServiceEntryItemReference/@serviceLineNumber"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="ServiceEntryItemReference/@serviceEntryID != ''">
				<xsl:element name="cac:DocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">AGT</xsl:attribute>
						<xsl:value-of select="ServiceEntryItemReference/@serviceEntryID"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ServiceEntryItemReference/@serviceEntryDate != ''">
				<xsl:element name="cac:DocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">ACD</xsl:attribute>
						<xsl:value-of select="ServiceEntryItemReference/@serviceEntryDate"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="InvoiceDetailItemReference/SupplierBatchID != '' and $invLineItemName = 'InvoiceDetailItem'">
				<xsl:element name="cac:DocumentReference">
					<xsl:element name="cbc:ID">
						<xsl:attribute name="schemeID">BT</xsl:attribute>
						<xsl:value-of select="InvoiceDetailItemReference/SupplierBatchID"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isDiscountInLine = 'yes' and InvoiceDetailDiscount/Money != ''">
				<xsl:element name="cac:AllowanceCharge">
					<xsl:element name="cbc:ChargeIndicator">false</xsl:element>
					<xsl:element name="cbc:AllowanceChargeReasonCode">95</xsl:element>
					<xsl:if test="InvoiceDetailDiscount/@percentageRate != ''">
						<xsl:element name="cbc:MultiplierFactorNumeric">
							<xsl:value-of select="InvoiceDetailDiscount/@percentageRate"/>
						</xsl:element>
					</xsl:if>

					<xsl:element name="cbc:Amount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="InvoiceDetailDiscount/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="InvoiceDetailDiscount/Money"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="$invLineItemName = 'InvoiceDetailItem'">
				<xsl:if test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isSpecialHandlingInLine = 'yes' and InvoiceDetailLineSpecialHandling/Money != ''">
					<xsl:element name="cac:AllowanceCharge">
						<xsl:element name="cbc:ChargeIndicator">true</xsl:element>
						<xsl:element name="cbc:AllowanceChargeReasonCode">SH</xsl:element>

						<xsl:element name="cbc:Amount">
							<xsl:attribute name="currencyID">
								<xsl:value-of select="InvoiceDetailLineSpecialHandling/Money/@currency"/>
							</xsl:attribute>
							<xsl:value-of select="InvoiceDetailLineSpecialHandling/Money"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:if>

			<xsl:for-each select="InvoiceItemModifications/Modification">
				<xsl:call-template name="mapModification"/>
			</xsl:for-each>

			<xsl:if test="$invLineItemName = 'InvoiceDetailItem'">
				<xsl:element name="cac:Item">
					<xsl:if test="InvoiceDetailItemReference/Description != ''">
						<xsl:element name="cbc:Description">
							<xsl:value-of select="InvoiceDetailItemReference/Description"/>
						</xsl:element>
					</xsl:if>

					<xsl:element name="cbc:Name">
						<xsl:value-of select="InvoiceDetailItemReference/Description"/>
					</xsl:element>

					<xsl:if test="InvoiceDetailItemReference/ItemID/BuyerPartID != ''">
						<xsl:element name="cac:BuyersItemIdentification">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="InvoiceDetailItemReference/ItemID/BuyerPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/ItemID/SupplierPartID != ''">
						<xsl:element name="cac:SellersItemIdentification">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="InvoiceDetailItemReference/ItemID/SupplierPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/Country/@isoCountryCode != ''">
						<xsl:element name="cac:OriginCountry">
							<xsl:element name="cbc:IdentificationCode">
								<xsl:value-of select="InvoiceDetailItemReference/Country/@isoCountryCode"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>

					<xsl:if test="InvoiceDetailItemReference/ItemID/BuyerPartID != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">BP</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/ItemID/BuyerPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">EN</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/SerialNumber != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">SN</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/SerialNumber"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">UP</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/ItemID/IdReference[@domain = 'UPCUniversalProductCode']/@identifier"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/ItemID/SupplierPartID != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">VN</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/ItemID/SupplierPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/ItemID/SupplierPartAuxiliaryID != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">VS</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/ItemID/SupplierPartAuxiliaryID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">VS</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/ItemID/IdReference[@domain = 'europeanWasteCatalogID']/@identifier"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailItemReference/Classification[@domain = 'UNSPSC'] != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">TST</xsl:attribute>
								<xsl:value-of select="InvoiceDetailItemReference/Classification[@domain = 'UNSPSC']"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:element name="cac:ClassifiedTaxCategory">
						<xsl:element name="cbc:ID">
							<xsl:choose>
								<xsl:when test="Tax/TaxDetail[1]/TaxExemption/@exemptCode != ''">
									<xsl:value-of select="Tax/TaxDetail[1]/TaxExemption/@exemptCode"/>
								</xsl:when>
								<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/TaxExemption/@exemptCode != ''">
									<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/TaxExemption/@exemptCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'S'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:choose>
							<xsl:when test="Tax/TaxDetail[1]/@percentageRate != ''">
								<xsl:element name="cbc:Percent">
									<xsl:value-of select="Tax/TaxDetail[1]/@percentageRate"/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/@percentageRate!=''">
								<xsl:element name="cbc:Percent">
									<xsl:value-of select="/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/@percentageRate"/>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
						
						<xsl:element name="cac:TaxScheme">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="'VAT'"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="$invLineItemName = 'InvoiceDetailServiceItem'">
				<xsl:element name="cac:Item">
					<xsl:element name="cbc:Description">
						<xsl:value-of select="InvoiceDetailServiceItemReference/Description"/>
					</xsl:element>

					<xsl:element name="cbc:Name">
						<xsl:value-of select="InvoiceDetailServiceItemReference/Description"/>
					</xsl:element>
					<xsl:if test="InvoiceDetailServiceItemReference/ItemID/BuyerPartID != ''">
						<xsl:element name="cac:BuyersItemIdentification">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="InvoiceDetailServiceItemReference/ItemID/BuyerPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailServiceItemReference/ItemID/SupplierPartID != ''">
						<xsl:element name="cac:SellersItemIdentification">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="InvoiceDetailServiceItemReference/ItemID/SupplierPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailServiceItemReference/ItemID/BuyerPartID != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">BP</xsl:attribute>
								<xsl:value-of select="InvoiceDetailServiceItemReference/ItemID/BuyerPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailServiceItemReference/ItemID/SupplierPartID != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">VN</xsl:attribute>
								<xsl:value-of select="InvoiceDetailServiceItemReference/ItemID/SupplierPartID"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="InvoiceDetailServiceItemReference/Classification[@domain = 'UNSPSC'] != ''">
						<xsl:element name="cac:CommodityClassification">
							<xsl:element name="cbc:ItemClassificationCode">
								<xsl:attribute name="listID">TST</xsl:attribute>
								<xsl:value-of select="InvoiceDetailServiceItemReference/Classification[@domain = 'UNSPSC']"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:element name="cac:ClassifiedTaxCategory">
						<xsl:element name="cbc:ID">
							<xsl:choose>
								<xsl:when test="Tax/TaxDetail[1]/TaxExemption/@exemptCode != ''">
									<xsl:value-of select="Tax/TaxDetail[1]/TaxExemption/@exemptCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'S'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:if test="Tax/TaxDetail[1]/@percentageRate != ''">
							<xsl:element name="cbc:Percent">
								<xsl:value-of select="Tax/TaxDetail[1]/@percentageRate"/>
							</xsl:element>
						</xsl:if>
						<xsl:element name="cac:TaxScheme">
							<xsl:element name="cbc:ID">
								<xsl:value-of select="'VAT'"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>

			<xsl:if test="UnitPrice/Money != ''">
				<xsl:element name="cac:Price">
					<xsl:element name="cbc:PriceAmount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="UnitPrice/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="UnitPrice/Money"/>
					</xsl:element>

					<xsl:if test="PriceBasisQuantity/@quantity != ''">
						<xsl:element name="cbc:BaseQuantity">
							<xsl:variable name="ucode">
								<xsl:value-of select="PriceBasisQuantity/UnitOfMeasure"/>
							</xsl:variable>
							<xsl:attribute name="unitCode">
								<xsl:value-of select="$ucode"/>
							</xsl:attribute>
							<xsl:value-of select="PriceBasisQuantity/@quantity"/>
						</xsl:element>
					</xsl:if>

					<xsl:for-each select="UnitPrice/Modifications/Modification">
						<xsl:choose>
							<xsl:when test="exists(AdditionalDeduction)">
								<xsl:element name="cac:AllowanceCharge">
									<xsl:element name="cbc:ChargeIndicator">false</xsl:element>
									<xsl:element name="cbc:Amount">
										<xsl:attribute name="currencyID">
											<xsl:value-of select="AdditionalDeduction/DeductionAmount/Money/@currency"/>
										</xsl:attribute>
										<xsl:value-of select="AdditionalDeduction/DeductionAmount/Money"/>
									</xsl:element>
									<xsl:if test="OriginalPrice/Money != ''">
										<xsl:element name="cbc:BaseAmount">
											<xsl:attribute name="currencyID">
												<xsl:value-of select="OriginalPrice/Money/@currency"/>
											</xsl:attribute>
											<xsl:value-of select="OriginalPrice/Money"/>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</cac:InvoiceLine>
	</xsl:template>

	<xsl:template name="mapModification" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
		<xsl:param name="level"/>
		<xsl:choose>
			<xsl:when test="exists(AdditionalDeduction)">
				<xsl:element name="cac:AllowanceCharge">
					<xsl:element name="cbc:ChargeIndicator">false</xsl:element>
					<xsl:variable name="ReasonCode">
						<xsl:variable name="code" select="ModificationDetail/@name"/>
						<xsl:value-of select="$Lookup/Lookups/AllowanceCodes/AllowanceCode[cXMLCode = $code]/UBLCode"/>
					</xsl:variable>
					<xsl:if test="$ReasonCode != ''">
						<xsl:element name="cbc:AllowanceChargeReasonCode">
							<xsl:value-of select="$ReasonCode"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="ModificationDetail/@name != ''">
						<xsl:element name="cbc:AllowanceChargeReason">
							<xsl:value-of select="ModificationDetail/@name"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="AdditionalDeduction/DeductionPercent/@percent != ''">
						<xsl:element name="cbc:MultiplierFactorNumeric">
							<xsl:value-of select="AdditionalDeduction/DeductionPercent/@percent"/>
						</xsl:element>
					</xsl:if>
					<xsl:element name="cbc:Amount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="AdditionalDeduction/DeductionAmount/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="AdditionalDeduction/DeductionAmount/Money"/>
					</xsl:element>
					<xsl:if test="OriginalPrice/Money != ''">
						<xsl:element name="cbc:BaseAmount">
							<xsl:attribute name="currencyID">
								<xsl:value-of select="OriginalPrice/Money/@currency"/>
							</xsl:attribute>
							<xsl:value-of select="OriginalPrice/Money"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$level = 'header'">
						<xsl:element name="cac:TaxCategory">
							<xsl:element name="cbc:ID">
								<xsl:choose>
									<xsl:when test="Tax/TaxDetail[1]/TaxExemption/@exemptCode != ''">
										<xsl:value-of select="Tax/TaxDetail[1]/TaxExemption/@exemptCode"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'S'"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:if test="Tax/TaxDetail[1]/@percentageRate != ''">
								<xsl:element name="cbc:Percent">
									<xsl:value-of select="Tax/TaxDetail[1]/@percentageRate"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="cac:TaxScheme">
								<xsl:element name="cbc:ID">
									<xsl:value-of select="'VAT'"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			<xsl:when test="exists(AdditionalCost)">
				<xsl:element name="cac:AllowanceCharge">
					<xsl:element name="cbc:ChargeIndicator">true</xsl:element>
					<xsl:variable name="ReasonCode">
						<xsl:variable name="code" select="ModificationDetail/@name"/>
						<xsl:value-of select="$Lookup/Lookups/ChargeCodes/ChargeCode[cXMLCode = $code]/UBLCode"/>
					</xsl:variable>
					<xsl:if test="$ReasonCode != ''">
						<xsl:element name="cbc:AllowanceChargeReasonCode">
							<xsl:value-of select="$ReasonCode"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="ModificationDetail/@name != ''">
						<xsl:element name="cbc:AllowanceChargeReason">
							<xsl:value-of select="ModificationDetail/@name"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="AdditionalCost/DeductionPercent/@percent != ''">
						<xsl:element name="cbc:MultiplierFactorNumeric">
							<xsl:value-of select="AdditionalCost/Percentage/@percent"/>
						</xsl:element>
					</xsl:if>
					<xsl:element name="cbc:Amount">
						<xsl:attribute name="currencyID">
							<xsl:value-of select="AdditionalCost/Money/@currency"/>
						</xsl:attribute>
						<xsl:value-of select="AdditionalCost/Money"/>
					</xsl:element>
					<xsl:if test="OriginalPrice/Money != ''">
						<xsl:element name="cbc:BaseAmount">
							<xsl:attribute name="currencyID">
								<xsl:value-of select="OriginalPrice/Money/@currency"/>
							</xsl:attribute>
							<xsl:value-of select="OriginalPrice/Money"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$level = 'header'">
						<xsl:element name="cac:TaxCategory">
							<xsl:element name="cbc:ID">
								<xsl:choose>
									<xsl:when test="Tax/TaxDetail[1]/TaxExemption/@exemptCode != ''">
										<xsl:value-of select="Tax/TaxDetail[1]/TaxExemption/@exemptCode"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'S'"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:if test="Tax/TaxDetail[1]/@percentageRate != ''">
								<xsl:element name="cbc:Percent">
									<xsl:value-of select="Tax/TaxDetail[1]/@percentageRate"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="cac:TaxScheme">
								<xsl:element name="cbc:ID">
									<xsl:value-of select="'VAT'"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="mapTaxCategory" xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
		<xsl:variable name="taxCatID">
			<xsl:choose>
				<xsl:when test="TaxExemption/@exemptCode != ''">
					<xsl:value-of select="TaxExemption/@exemptCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'S'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="cac:TaxCategory">
			<xsl:element name="cbc:ID">
				<xsl:value-of select="$taxCatID"/>
			</xsl:element>
			<xsl:if test="@percentageRate != ''">
				<xsl:element name="cbc:Percent">
					<xsl:value-of select="@percentageRate"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$taxCatID != 'S' and $taxCatID != 'Z'">
				<xsl:variable name="codeT" select="TaxExemption/@exemptCode"/>
				<xsl:variable name="codeTLookup" select="$Lookup/Lookups/TaxExemptionReasonCodes/TaxExemptionReasonCode[cXMLCode = $codeT]/UBLCode"/>
				<xsl:if test="$codeTLookup != ''">
					<xsl:element name="cbc:TaxExemptionReasonCode">
						<xsl:value-of select="$codeTLookup"/>
					</xsl:element>
				</xsl:if>
				<xsl:element name="cbc:TaxExemptionReason">
					<xsl:value-of select="TaxExemption/ExemptReason"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="cac:TaxScheme">
				<xsl:element name="cbc:ID">
					<xsl:value-of select="'VAT'"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
