<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anISASender"/>
	<xsl:param name="anISASenderQual"/>
	<xsl:param name="anISAReceiver"/>
	<xsl:param name="anISAReceiverQual"/>
	<xsl:param name="anDate"/>
	<xsl:param name="anTime"/>
	<xsl:param name="anICNValue"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anSenderGroupID"/>
	<xsl:param name="anReceiverGroupID"/>
	<xsl:param name="exchange"/>
	<!-- For local testing -->
	<!--<xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>
    <xsl:include href="Format_CXML_ASC-X12_common.xsl"/>-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:820:004010">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>RA</D_479>
					<D_142>
						<xsl:choose>
							<xsl:when test="$anSenderGroupID != ''">
								<xsl:value-of select="$anSenderGroupID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ARIBA</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</D_142>
					<D_124>
						<xsl:choose>
							<xsl:when test="$anReceiverGroupID != ''">
								<xsl:value-of select="$anReceiverGroupID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>ARIBA</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</D_124>
					<D_373>
						<xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
					</D_373>
					<D_337>
						<xsl:value-of select="format-dateTime($dateNow, '[H01][m01][s01]')"/>
					</D_337>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
					<D_455>X</D_455>
					<D_480>004010</D_480>
				</S_GS>
				<M_820>
					<S_ST>
						<D_143>820</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BPR>
						<D_305>I</D_305>
						<xsl:choose>
							<xsl:when test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money != ''">
								<D_782>
									<xsl:call-template name="formatAmount">
										<xsl:with-param name="amount" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money"/>
									</xsl:call-template>
								</D_782>
							</xsl:when>
							<xsl:otherwise>
								<D_782>0.00</D_782>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:variable name="paymathVal" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/@type"/>
						<D_478>C</D_478>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/PaymentMethodTypes/PaymentMethodType/PaymentMethod[CXMLCode = $paymathVal]/X12Code != ''">
								<D_591>
									<xsl:value-of select="$Lookup/Lookups/PaymentMethodTypes/PaymentMethodType/PaymentMethod[CXMLCode = $paymathVal]/X12Code"/>
								</D_591>
							</xsl:when>
							<xsl:otherwise>
								<D_591>ZZZ</D_591>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:variable name="ob" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']"/>
						<xsl:variable name="orgDom">
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($ob/IdReference/@domain)][Role = 'O1'][1]/X12Code != ''">
									<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($ob/IdReference/@domain)][Role = 'O1'][1]/X12Code"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="domRef">
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($ob/IdReference/@domain)][Role = 'O1'][1]/CXMLCode != ''">
									<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($ob/IdReference/@domain)][Role = 'O1'][1]/CXMLCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[1]/@domain"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="$orgDom != '' and string-length(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = $domRef]/@identifier)) &gt; 2">
							<D_506>
								<xsl:value-of select="$orgDom"/>
							</D_506>
							<D_507>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'originatingBank']/IdReference[@domain = $domRef]/@identifier), 0, 12)"/>
							</D_507>
						</xsl:if>
						<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'bankAccountID']/@identifier != ''">
							<D_569>10</D_569>
							<D_508>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payer']/IdReference[@domain = 'bankAccountID']/@identifier), 0, 35)"/>
							</D_508>
						</xsl:if>
						<xsl:variable name="rb" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']"/>
						<xsl:variable name="orgdomRB">
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($rb/IdReference/@domain)][Role = 'RB'][1]/X12Code != ''">
									<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($rb/IdReference/@domain)][Role = 'RB'][1]/X12Code"/>
								</xsl:when>
								<xsl:otherwise>ZZ</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="domRefRB">
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($rb/IdReference/@domain)][Role = 'RB'][1]/CXMLCode != ''">
									<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = ($rb/IdReference/@domain)][Role = 'RB'][1]/CXMLCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[1]/@domain"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="$orgdomRB != '' and string-length(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = $domRefRB]/@identifier)) &gt; 2">
							<D_506_2>
								<xsl:value-of select="$orgdomRB"/>
							</D_506_2>
							<D_507_2>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'receivingBank']/IdReference[@domain = $domRefRB]/@identifier), 0, 12)"/>
							</D_507_2>
						</xsl:if>
						<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'bankAccountID']/@identifier != ''">
							<D_569_2>10</D_569_2>
							<D_508_2>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner[Contact/@role = 'payee']/IdReference[@domain = 'bankAccountID']/@identifier), 0, 35)"/>
							</D_508_2>
						</xsl:if>
						<D_373>
							<xsl:value-of select="replace(substring(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate, 1, 10), '-', '')"/>
						</D_373>
					</S_BPR>
					<xsl:variable name="paymentDesc" select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/Description)"/>
					<xsl:if test="substring($paymentDesc, 1, 80) != ''">
						<S_NTE>
							<D_363>PMT</D_363>
							<D_352>
								<xsl:value-of select="substring($paymentDesc, 1, 80)"/>
							</D_352>
						</S_NTE>
					</xsl:if>
					<xsl:if test="substring($paymentDesc, 81, 80) != ''">
						<S_NTE>
							<D_363>PMT</D_363>
							<D_352>
								<xsl:value-of select="substring($paymentDesc, 81, 80)"/>
							</D_352>
						</S_NTE>
					</xsl:if>
					<xsl:variable name="hdrcomments" select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Comments)"/>
					<xsl:if test="substring($hdrcomments, 1, 80) != ''">
						<S_NTE>
							<D_363>OTH</D_363>
							<D_352>
								<xsl:value-of select="substring($hdrcomments, 1, 80)"/>
							</D_352>
						</S_NTE>
					</xsl:if>
					<xsl:if test="substring($hdrcomments, 81, 80) != ''">
						<S_NTE>
							<D_363>OTH</D_363>
							<D_352>
								<xsl:value-of select="substring($hdrcomments, 81, 80)"/>
							</D_352>
						</S_NTE>
					</xsl:if>
					<xsl:variable name="remitID" select="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentRemittanceID)"/>
					<xsl:if test="string-length($remitID) &lt; 30">
						<S_TRN>
							<D_481>1</D_481>
							<D_127>
								<xsl:value-of select="substring($remitID, 1, 30)"/>
							</D_127>
						</S_TRN>
					</xsl:if>
					<xsl:if test="string-length($remitID) &gt; 30">
						<S_TRN>
							<D_481>1</D_481>
							<D_127>
								<xsl:value-of select="substring($remitID, 31, 30)"/>
							</D_127>
						</S_TRN>
					</xsl:if>
					<S_CUR>
						<D_98>BY</D_98>
						<D_100>
							<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@currency"/>
						</D_100>
						<xsl:if test="string-length(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateAmount) &gt; 3">
							<D_280>
								<xsl:call-template name="formatAmount">
									<xsl:with-param name="amount" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateAmount"/>
								</xsl:call-template>
							</D_280>
						</xsl:if>
						<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateCurrency">
							<D_98_2>ZZ</D_98_2>
							<D_100_2>
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceSummary/NetAmount/Money/@alternateCurrency"/>
							</D_100_2>
						</xsl:if>
					</S_CUR>
					<xsl:variable name="paymentRef" select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentMethod/@type"/>
					<xsl:if test="$Lookup/Lookups/PaymentMethodReferences/PaymentMethodReference[CXMLCode = $paymentRef]/X12Code != '' and cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentReferenceNumber != ''">
						<S_REF>
							<D_128>
								<xsl:value-of select="$Lookup//Lookups/PaymentMethodReferences/PaymentMethodReference[CXMLCode = $paymentRef]/X12Code"/>
							</D_128>
							<D_127>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentReferenceNumber), 0, 30)"/>
							</D_127>
						</S_REF>
					</xsl:if>
					<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo">
						<xsl:if test="PaymentIDInfo/@paymentRemittanceID != ''">
							<S_REF>
								<D_128>H9</D_128>
								<D_127>
									<xsl:value-of select="substring(normalize-space(PaymentIDInfo/@paymentRemittanceID), 1, 30)"/>
								</D_127>
							</S_REF>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentReference/DocumentReference/@payloadID) != ''">
						<S_REF>
							<D_128>F8</D_128>
							<D_127>payloadID</D_127>
							<D_352>
								<xsl:value-of select="substring(normalize-space(cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentReference/DocumentReference/@payloadID), 0, 80)"/>
							</D_352>
						</S_REF>
					</xsl:if>
					<!-- Extrinsics -->
					<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/Extrinsic">
						<S_REF>
							<D_128>ZZ</D_128>
							<D_127>
								<xsl:value-of select="substring(./@name, 1, 30)"/>
							</D_127>
							<xsl:variable name="extDesc" select="."/>
							<xsl:choose>
								<xsl:when test="$extDesc != ''">
									<D_352>
										<xsl:value-of select="substring($extDesc, 1, 80)"/>
									</D_352>
								</xsl:when>
								<xsl:otherwise>
									<D_352>
										<xsl:value-of select="substring(./@name, 1, 30)"/>
									</D_352>
								</xsl:otherwise>
							</xsl:choose>
						</S_REF>
					</xsl:for-each>
					<!-- cXML Timestamp -->
					<xsl:call-template name="createDTM">
						<xsl:with-param name="D374_Qual">097</xsl:with-param>
						<xsl:with-param name="cXMLDate">
							<xsl:value-of select="cXML/@timestamp"/>
						</xsl:with-param>
					</xsl:call-template>
					<!-- PaymentIDInfo Date -->
					<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentIDInfo/@paymentDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">707</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentReferenceInfo/PaymentIDInfo/@paymentDate"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<!-- PaymentDate -->
					<xsl:if test="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">949</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/@paymentDate"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<!-- Contacts -->
					<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/PaymentRemittanceRequestHeader/PaymentPartner">
						<xsl:call-template name="createN1_FromPartner">
							<xsl:with-param name="party" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!--Remittance Detail -->
					<G_ENT>
						<S_ENT>
							<D_554>1</D_554>
						</S_ENT>
						<xsl:for-each select="cXML/Request/PaymentRemittanceRequest/RemittanceDetail">
							<G_RMR>
								<!-- Lookup Required -->
								<S_RMR>
									<xsl:choose>
										<xsl:when test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID) != ''">
											<D_128>AH</D_128>
											<D_127>
												<xsl:value-of select="substring(normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID), 1, 30)"/>
											</D_127>
										</xsl:when>
										<xsl:when test="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID) != ''">
											<D_128>IV</D_128>
											<D_127>
												<xsl:value-of select="substring(normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceID), 1, 30)"/>
											</D_127>
										</xsl:when>
										<xsl:when test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID) != ''">
											<D_127>PO</D_127>
											<D_127>
												<xsl:value-of select="substring(normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID), 1, 30)"/>
											</D_127>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="NetAmount/Money != ''">
											<D_782>
												<xsl:call-template name="formatAmount">
													<xsl:with-param name="amount" select="NetAmount/Money"/>
												</xsl:call-template>
											</D_782>
										</xsl:when>
										<xsl:otherwise>
											<D_782>0.00</D_782>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="GrossAmount/Money != ''">
											<D_782_2>
												<xsl:call-template name="formatAmount">
													<xsl:with-param name="amount" select="GrossAmount/Money"/>
												</xsl:call-template>
											</D_782_2>
										</xsl:when>
										<xsl:otherwise>
											<D_782_2>0.00</D_782_2>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="DiscountAmount/Money != ''">
										<D_782_3>
											<xsl:call-template name="formatAmount">
												<xsl:with-param name="amount" select="DiscountAmount/Money"/>
											</xsl:call-template>
										</D_782_3>
									</xsl:if>
								</S_RMR>
								<xsl:variable name="linCom" select="normalize-space(Comments)"/>
								<xsl:if test="substring($linCom, 1, 80) != ''">
									<S_NTE>
										<D_363>PMT</D_363>
										<D_352>
											<xsl:value-of select="substring($linCom, 1, 80)"/>
										</D_352>
									</S_NTE>
								</xsl:if>
								<xsl:if test="substring($linCom, 81, 80) != ''">
									<S_NTE>
										<D_363>PMT</D_363>
										<D_352>
											<xsl:value-of select="substring($linCom, 81, 80)"/>
										</D_352>
									</S_NTE>
								</xsl:if>
								<xsl:if test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID) != ''">
									<S_REF>
										<D_128>AH</D_128>
										<D_127>
											<xsl:value-of select="substring(normalize-space(PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementID), 1, 30)"/>
										</D_127>
									</S_REF>
								</xsl:if>
								<xsl:if test="normalize-space(./@lineNumber) != ''">
									<S_REF>
										<D_128>FJ</D_128>
										<D_127>
											<xsl:value-of select="substring(normalize-space(./@lineNumber), 1, 30)"/>
										</D_127>
									</S_REF>
								</xsl:if>
								<xsl:if test="normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID) != ''">
									<S_REF>
										<D_128>PO</D_128>
										<D_127>
											<xsl:value-of select="substring(normalize-space(PayableInfo/PayableInvoiceInfo/PayableOrderInfo/OrderIDInfo/@orderID), 1, 30)"/>
										</D_127>
									</S_REF>
								</xsl:if>
								<xsl:if test="normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceReference/DocumentReference/@payloadID) != ''">
									<S_REF>
										<D_128>F8</D_128>
										<D_127>invoiceReference</D_127>
										<D_352>
											<xsl:value-of select="substring(normalize-space(PayableInfo/PayableInvoiceInfo/InvoiceReference/DocumentReference/@payloadID), 1, 80)"/>
										</D_352>
									</S_REF>
								</xsl:if>
								<xsl:if test="normalize-space(PayableInfo//PayableOrderInfo/OrderReference/DocumentReference/@payloadID) != ''">
									<S_REF>
										<D_128>F8</D_128>
										<D_127>orderReference</D_127>
										<D_352>
											<xsl:value-of select="substring(normalize-space(PayableInfo//PayableOrderInfo/OrderReference/DocumentReference/@payloadID), 1, 80)"/>
										</D_352>
									</S_REF>
								</xsl:if>
								<xsl:if test="normalize-space(PayableInfo//PayableMasterAgreementInfo/MasterAgreementReference/DocumentReference/@payloadID) != ''">
									<S_REF>
										<D_128>F8</D_128>
										<D_127>MasterAgreementReference</D_127>
										<D_352>
											<xsl:value-of select="substring(normalize-space(PayableInfo//PayableMasterAgreementInfo/MasterAgreementReference/DocumentReference/@payloadID), 1, 80)"/>
										</D_352>
									</S_REF>
								</xsl:if>
								<xsl:for-each select="Extrinsic[text() != '']">
									<S_REF>
										<D_128>ZZ</D_128>
										<D_127>
											<xsl:value-of select="substring(./@name, 1, 30)"/>
										</D_127>
										<xsl:variable name="extDesc" select="normalize-space(.)"/>
										<xsl:choose>
											<xsl:when test="$extDesc != ''">
												<D_352>
													<xsl:value-of select="substring($extDesc, 1, 80)"/>
												</D_352>
											</xsl:when>
											<xsl:otherwise>
												<D_352>
													<xsl:value-of select="substring(./@name, 1, 30)"/>
												</D_352>
											</xsl:otherwise>
										</xsl:choose>
									</S_REF>
								</xsl:for-each>
								<!-- Invoice Date -->
								<xsl:if test="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate != ''">
									<xsl:call-template name="createDTM">
										<xsl:with-param name="D374_Qual">003</xsl:with-param>
										<xsl:with-param name="cXMLDate">
											<xsl:value-of select="PayableInfo/PayableInvoiceInfo/InvoiceIDInfo/@invoiceDate"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- Order Date -->
								<xsl:if test="PayableInfo/PayableOrderInfo/OrderIDInfo/@orderDate != ''">
									<xsl:call-template name="createDTM">
										<xsl:with-param name="D374_Qual">004</xsl:with-param>
										<xsl:with-param name="cXMLDate">
											<xsl:value-of select="PayableInfo/PayableOrderInfo/OrderIDInfo/@orderDate"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- Aggrement Date -->
								<xsl:if test="PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate != ''">
									<xsl:call-template name="createDTM">
										<xsl:with-param name="D374_Qual">LEA</xsl:with-param>
										<xsl:with-param name="cXMLDate">
											<xsl:value-of select="PayableInfo/PayableInvoiceInfo/PayableMasterAgreementInfo/MasterAgreementIDInfo/@agreementDate"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="AdjustmentAmount/Money != ''">
									<G_ADX>
										<S_ADX>
											<D_782>
												<xsl:call-template name="formatAmount">
													<xsl:with-param name="amount" select="AdjustmentAmount/Money"/>
												</xsl:call-template>
											</D_782>
											<D_426>CS</D_426>
										</S_ADX>
										<xsl:if test="normalize-space(AdjustmentAmount/Description) != ''">
											<S_NTE>
												<D_363>CBH</D_363>
												<D_352>
													<xsl:value-of select="substring(normalize-space(AdjustmentAmount/Description), 1, 80)"/>
												</D_352>
											</S_NTE>
										</xsl:if>
									</G_ADX>
								</xsl:if>
							</G_RMR>
						</xsl:for-each>
					</G_ENT>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_820>
				<S_GE>
					<D_97>1</D_97>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
				</S_GE>
			</FunctionalGroup>
			<S_IEA>
				<D_I16>1</D_I16>
				<D_I12>
					<xsl:value-of select="$anICNValue"/>
				</D_I12>
			</S_IEA>
		</ns0:Interchange>
	</xsl:template>
</xsl:stylesheet>
