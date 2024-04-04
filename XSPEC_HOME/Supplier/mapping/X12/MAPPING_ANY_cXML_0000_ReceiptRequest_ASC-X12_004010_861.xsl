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
	<!--	<xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>	
		<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>RC</D_479>
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
				<M_861>
					<S_ST>
						<D_143>861</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BRA>
						<xsl:if test="normalize-space(cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptID) != ''">
							<D_127>
								<xsl:value-of select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptID"/>
							</D_127>
						</xsl:if>
						<D_373>
							<xsl:value-of select="replace(substring(cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate, 0, 11), '-', '')"/>
						</D_373>
						<xsl:variable name="operation" select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/@operation"/>
						<D_353>
							<xsl:choose>
								<xsl:when test="$operation = 'new'">
									<xsl:text>00</xsl:text>
								</xsl:when>
								<xsl:when test="$operation = 'delete'">
									<xsl:text>03</xsl:text>
								</xsl:when>
								<xsl:when test="$operation = 'update'">
									<xsl:text>05</xsl:text>
								</xsl:when>
							</xsl:choose>
						</D_353>
						<D_962>2</D_962>
						<xsl:variable name="timeStamp" select="substring-after(cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate, 'T')"/>
						<xsl:variable name="time">
							<xsl:if test="$timeStamp != ''">
								<xsl:choose>
									<xsl:when test="contains($timeStamp, '-')">
										<xsl:value-of select="replace(substring-before($timeStamp, '-'), ':', '')"/>
									</xsl:when>
									<xsl:when test="contains($timeStamp, '+')">
										<xsl:value-of select="replace(substring-before($timeStamp, '+'), ':', '')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="replace($timeStamp, ':', '')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<xsl:if test="$time != ''">
							<D_337>
								<xsl:value-of select="$time"/>
							</D_337>
						</xsl:if>
						<D_306>AC</D_306>
					</S_BRA>
					<!-- CUR -->
					<xsl:if test="normalize-space(cXML/Request/ReceiptRequest/Total/Money/@currency) != ''">
						<S_CUR>
							<D_98>BY</D_98>
							<D_100>
								<xsl:value-of select="cXML/Request/ReceiptRequest/Total/Money/@currency"/>
							</D_100>
						</S_CUR>
					</xsl:if>
					<xsl:if test="normalize-space(cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeID) != ''">
						<S_REF>
							<D_128>MA</D_128>
							<D_127>
								<xsl:value-of select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeID"/>
							</D_127>
						</S_REF>
					</xsl:if>
					<xsl:variable name="comm">
						<xsl:choose>
							<xsl:when test="normalize-space(cXML/Request/ReceiptRequest/ReceiptRequestHeader/Comments) != ''">
								<xsl:value-of select="normalize-space(cXML/Request/ReceiptRequest/ReceiptRequestHeader/Comments)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="langCode">
						<xsl:choose>
							<xsl:when test="string-length(normalize-space(cXML/Request/ReceiptRequest/ReceiptRequestHeader/Comments/@xml:lang)) &gt; 1">
								<xsl:value-of select="upper-case(substring(normalize-space(cXML/Request/ReceiptRequest/ReceiptRequestHeader/Comments/@xml:lang), 1, 2))"/>
							</xsl:when>
							<xsl:otherwise>EN</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="StrLen" select="string-length($comm)"/>
					<xsl:if test="$StrLen &gt; 0">
						<xsl:call-template name="REFloop">
							<xsl:with-param name="comm" select="$comm"/>
							<xsl:with-param name="langCode" select="$langCode"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic">
						<xsl:if test="normalize-space(@name) != ''">
							<S_REF>
								<D_128>ZZ</D_128>
								<D_127>
									<xsl:value-of select="normalize-space(substring(@name, 1, 30))"/>
								</D_127>
								<D_352>
									<xsl:value-of select="normalize-space(substring(./text(), 1, 80))"/>
								</D_352>
							</S_REF>
						</xsl:if>
					</xsl:for-each>
					<!-- shipNoticeDate -->
					<xsl:if test="cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">111</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeDate"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<!-- receiptDate -->
					<xsl:if test="cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">050</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of select="cXML/Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<!-- Line Item Details -->
					<xsl:for-each select="cXML/Request/ReceiptRequest/ReceiptOrder">
						<xsl:variable name="Actioncode">
							<xsl:choose>
								<xsl:when test="normalize-space(@closeForReceiving) = 'yes'">
									<xsl:value-of select="'CL'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="orderID">
							<xsl:choose>
								<xsl:when test="normalize-space(ReceiptOrderInfo/OrderReference/@orderID) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/OrderReference/@orderID)"/>
								</xsl:when>
								<xsl:when test="normalize-space(ReceiptOrderInfo/OrderIDInfo/@orderID) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/OrderIDInfo/@orderID)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="orderDate">
							<xsl:choose>
								<xsl:when test="normalize-space(ReceiptOrderInfo/OrderReference/@orderDate) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/OrderReference/@orderDate)"/>
								</xsl:when>
								<xsl:when test="normalize-space(ReceiptOrderInfo/OrderIDInfo/@orderDate) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/OrderIDInfo/@orderDate)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="MAgreementID">
							<xsl:choose>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementID) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementID)"/>
								</xsl:when>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementID) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementID)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="MAgreementDate">
							<xsl:choose>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementDate) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementDate)"/>
								</xsl:when>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementDate) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementDate)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="agreementType">
							<xsl:choose>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementType) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementType)"/>
								</xsl:when>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementType) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementType)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:for-each select="ReceiptItem">
							<G_RCD>
								<S_RCD>
									<xsl:if test="@receiptLineNumber != ''">
										<D_350>
											<xsl:value-of select="@receiptLineNumber"/>
										</D_350>
									</xsl:if>
									<xsl:if test="@type = 'received'">
										<D_663>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty" select="normalize-space(@quantity)"/>
											</xsl:call-template>
										</D_663>
										<C_C001>
											<xsl:variable name="uom" select="UnitRate/UnitOfMeasure"/>
											<D_355>
												<xsl:choose>
													<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
														<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
													</xsl:when>
													<xsl:otherwise>ZZ</xsl:otherwise>
												</xsl:choose>
											</D_355>
										</C_C001>
										<xsl:if test="@type = 'returned'">
											<D_664>
												<xsl:call-template name="formatQty">
													<xsl:with-param name="qty" select="normalize-space(@quantity)"/>
												</xsl:call-template>
											</D_664>
											<C_C001>
												<xsl:variable name="uom" select="UnitRate/UnitOfMeasure"/>
												<D_355>
													<xsl:choose>
														<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
															<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
														</xsl:when>
														<xsl:otherwise>ZZ</xsl:otherwise>
													</xsl:choose>
												</D_355>
											</C_C001>
										</xsl:if>
									</xsl:if>
								</S_RCD>
								<S_LIN>
									<xsl:if test="@receiptLineNumber != ''">
										<D_350>
											<xsl:value-of select="@receiptLineNumber"/>
										</D_350>
									</xsl:if>
									<xsl:call-template name="createItemParts">
										<xsl:with-param name="itemID" select="ReceiptItemReference/ItemID"/>
										<xsl:with-param name="itemDetail" select="ReceiptItemReference"/>
										<xsl:with-param name="lineRef" select="ReceiptItemReference/@lineNumber"/>
										<xsl:with-param name="isReceiptRequest" select="'yes'"/>
									</xsl:call-template>
								</S_LIN>
								<!-- ShortName -->
								<xsl:variable name="desc">
									<xsl:choose>
										<xsl:when test="normalize-space(ReceiptItemReference/Description/ShortName) != ''">
											<xsl:value-of select="normalize-space(ReceiptItemReference/Description/ShortName)"/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="langCode">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space(ReceiptItemReference/Description/@xml:lang)) &gt; 1">
											<xsl:value-of select="upper-case(substring(normalize-space(ReceiptItemReference/Description/@xml:lang), 1, 2))"/>
										</xsl:when>
										<xsl:otherwise>EN</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="StrLen" select="string-length($desc)"/>
								<xsl:if test="$StrLen &gt; 0">
									<xsl:call-template name="PIDloop">
										<xsl:with-param name="Desc" select="$desc"/>
										<xsl:with-param name="langCode" select="$langCode"/>
										<xsl:with-param name="isShipIns" select="'yes'"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Description -->
								<xsl:variable name="desc">
									<xsl:choose>
										<xsl:when test="normalize-space(ReceiptItemReference/Description) != ''">
											<xsl:value-of select="normalize-space(ReceiptItemReference/Description)"/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="langCode">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space(ReceiptItemReference/Description/@xml:lang)) &gt; 1">
											<xsl:value-of select="upper-case(substring(normalize-space(ReceiptItemReference/Description/@xml:lang), 1, 2))"/>
										</xsl:when>
										<xsl:otherwise>EN</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="StrLen" select="string-length($desc)"/>
								<xsl:if test="$StrLen &gt; 0">
									<xsl:call-template name="PIDloop">
										<xsl:with-param name="Desc" select="$desc"/>
										<xsl:with-param name="langCode" select="$langCode"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Order ID -->
								<xsl:if test="normalize-space($orderID) != ''">
									<S_REF>
										<D_128>PO</D_128>
										<D_127>
											<xsl:value-of select="$orderID"/>
										</D_127>
										<D_352>
											<xsl:value-of select="$Actioncode"/>
										</D_352>
									</S_REF>
								</xsl:if>
								<!-- Action code -->
								<xsl:if test="normalize-space($MAgreementID) != ''">
									<S_REF>
										<D_128>AH</D_128>
										<xsl:if test="normalize-space($MAgreementID) != ''">
											<D_127>
												<xsl:value-of select="$MAgreementID"/>
											</D_127>
										</xsl:if>
										<D_352>
											<xsl:value-of select="$Actioncode"/>
										</D_352>
									</S_REF>
								</xsl:if>
								<xsl:choose>
								<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeReference/@shipNoticeID) != ''">
									<S_REF>
										<D_128>MA</D_128>
										<D_127>
											<xsl:value-of select="normalize-space(ReceiptItemReference/ShipNoticeReference/@shipNoticeID)"/>
										</D_127>
									</S_REF>
								</xsl:when>
									<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeID) != ''">
										<S_REF>
											<D_128>MA</D_128>
											<D_127>
												<xsl:value-of select="normalize-space(ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeID)"/>
											</D_127>
										</S_REF>
									</xsl:when>
								</xsl:choose>
								<xsl:variable name="comm">
									<xsl:choose>
										<xsl:when test="normalize-space(Comments) != ''">
											<xsl:value-of select="normalize-space(Comments)"/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="langCode">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space(Comments/@xml:lang)) &gt; 1">
											<xsl:value-of select="upper-case(substring(normalize-space(Comments/@xml:lang), 1, 2))"/>
										</xsl:when>
										<xsl:otherwise>EN</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="StrLen" select="string-length($comm)"/>
								<xsl:if test="$StrLen &gt; 0">
									<xsl:call-template name="REFloop">
										<xsl:with-param name="comm" select="$comm"/>
										<xsl:with-param name="langCode" select="$langCode"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:for-each select="Extrinsic">
									<xsl:if test="normalize-space(@name) != ''">
										<S_REF>
											<D_128>ZZ</D_128>
											<D_127>
												<xsl:value-of select="normalize-space(substring(@name, 1, 30))"/>
											</D_127>
											<D_352>
												<xsl:value-of select="normalize-space(substring(./text(), 1, 80))"/>
											</D_352>
										</S_REF>
									</xsl:if>
								</xsl:for-each>
								<!-- orderDate -->
								<xsl:if test="$orderDate != ''">
									<xsl:call-template name="createDTM">
										<xsl:with-param name="D374_Qual">004</xsl:with-param>
										<xsl:with-param name="cXMLDate">
											<xsl:value-of select="$orderDate"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- Master Agreement Date -->
								<xsl:if test="$MAgreementDate != ''">
									<xsl:call-template name="createDTM">
										<xsl:with-param name="D374_Qual">LEA</xsl:with-param>
										<xsl:with-param name="cXMLDate">
											<xsl:value-of select="$MAgreementDate"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- shipNoticeDate -->
								<xsl:choose>
									<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeReference/@shipNoticeDate) != ''">
										<xsl:call-template name="createDTM">
											<xsl:with-param name="D374_Qual">111</xsl:with-param>
											<xsl:with-param name="cXMLDate">
												<xsl:value-of select="ReceiptItemReference/ShipNoticeReference/@shipNoticeDate"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeDate) != ''">
										<xsl:call-template name="createDTM">
											<xsl:with-param name="D374_Qual">111</xsl:with-param>
											<xsl:with-param name="cXMLDate">
												<xsl:value-of select="ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeDate"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
								<xsl:if test="normalize-space(DeliveryAddress/Address/Name) != ''">
								<G_N1>
									<S_N1>
										<D_98>DA</D_98>
										
											<D_93>
												<xsl:value-of select="normalize-space(DeliveryAddress/Address/Name)"/>
											</D_93>
										
										<xsl:variable name="addDomian" select="DeliveryAddress/Address/@addressIDDomain"/>
										<D_66>
											<xsl:choose>
												<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addDomian]/X12Code != ''">
													<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addDomian]/X12Code"/>
												</xsl:when>
												<xsl:otherwise>92</xsl:otherwise>
											</xsl:choose>
										</D_66>
										<D_67>
											<xsl:value-of select="DeliveryAddress/Address/@addressID"/>
										</D_67>
									</S_N1>
									<xsl:call-template name="createN2N3N4_FromAddress">
										<xsl:with-param name="address" select="DeliveryAddress/Address/PostalAddress"/>
									</xsl:call-template>
									<xsl:call-template name="createCom">
										<xsl:with-param name="party" select="DeliveryAddress"/>
									</xsl:call-template>
								</G_N1>
								</xsl:if>
							</G_RCD>
						</xsl:for-each>
					</xsl:for-each>
					<S_CTT>
						<D_354>
							<xsl:value-of select="count(cXML/Request/ReceiptRequest/ReceiptOrder/ReceiptItem)"/>
						</D_354>
					</S_CTT>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_861>
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
	<xsl:template name="REFloop">
		<xsl:param name="comm"/>
		<xsl:param name="langCode"/>
		<xsl:variable name="xmlLang">
			<xsl:choose>
				<xsl:when test="string-length(normalize-space($langCode)) &gt; 1">
					<xsl:value-of select="upper-case(substring(normalize-space($langCode), 1, 2))"/>
				</xsl:when>
				<xsl:otherwise>EN</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<S_REF>
			<D_128>L1</D_128>
			<D_127>
				<xsl:value-of select="$xmlLang"/>
			</D_127>
			<D_352>
				<xsl:value-of select="substring($comm, 1, 80)"/>
			</D_352>
		</S_REF>
		<xsl:if test="string-length($comm) &gt; 80">
			<xsl:call-template name="REFloop">
				<xsl:with-param name="comm" select="substring($comm, 81)"/>
				<xsl:with-param name="langCode" select="$xmlLang"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--	<xsl:template match="/cXML/Header"/>-->
</xsl:stylesheet>
