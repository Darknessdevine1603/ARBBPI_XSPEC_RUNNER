<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>

	<!-- For local testing -->
	<!-- xsl:variable name="Lookup" select="document('cXML_EDILookups_D96A.xml')"/>
	<xsl:include href="Format_CXML_D96A_common.xsl"/-->
	<!-- for dynamic, reading from Partner Directory -->

	<xsl:include href="FORMAT_cXML_0000_UN-EDIFACT_D96A.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>

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

	<xsl:template match="/cXML">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:recadv:d.96a">
			<S_UNA>:+.? '</S_UNA>
			<S_UNB>
				<C_S001>
					<D_0001>UNOC</D_0001>
					<D_0002>3</D_0002>
				</C_S001>
				<C_S002>
					<D_0004>
						<xsl:value-of select="$anISASender"/>
					</D_0004>
					<D_0007>
						<xsl:value-of select="$anISASenderQual"/>
					</D_0007>
					<D_0008>
						<xsl:value-of select="$anSenderGroupID"/>
					</D_0008>
				</C_S002>
				<C_S003>
					<D_0010>
						<xsl:value-of select="$anISAReceiver"/>
					</D_0010>
					<D_0007>
						<xsl:value-of select="$anISAReceiverQual"/>
					</D_0007>
					<D_0014>
						<xsl:value-of select="$anReceiverGroupID"/>
					</D_0014>
				</C_S003>
				<C_S004>
					<D_0017>
						<xsl:value-of select="format-dateTime($dateNow, '[Y01][M01][D01]')"/>
					</D_0017>
					<D_0019>
						<xsl:value-of select="format-dateTime($dateNow, '[H01][M01]')"/>
					</D_0019>
				</C_S004>
				<D_0020>
					<xsl:value-of select="$anICNValue"/>
				</D_0020>
				<D_0026>ORDERS</D_0026>
				<xsl:if test="upper-case($anEnvName) = 'TEST'">
					<D_0035>1</D_0035>
				</xsl:if>
			</S_UNB>
			<M_RECADV>
				<S_UNH>
					<D_0062>0001</D_0062>
					<C_S009>
						<D_0065>RECADV</D_0065>
						<D_0052>D</D_0052>
						<D_0054>96A</D_0054>
						<D_0051>UN</D_0051>
					</C_S009>
				</S_UNH>
				<S_BGM>
					<C_C002>
						<D_1001>632</D_1001>
					</C_C002>
					<D_1004>
						<xsl:value-of select="Request/ReceiptRequest/ReceiptRequestHeader/@receiptID"/>
					</D_1004>
					<D_1225>
						<xsl:choose>
							<xsl:when test="Request/ReceiptRequest/ReceiptRequestHeader/@operation = 'delete'">3</xsl:when>
							<xsl:when test="Request/ReceiptRequest/ReceiptRequestHeader/@operation = 'update'">5</xsl:when>
							<xsl:when test="Request/ReceiptRequest/ReceiptRequestHeader/@operation = 'new'">9</xsl:when>
							<xsl:otherwise>9</xsl:otherwise>
						</xsl:choose>
					</D_1225>
					<D_4343>AB</D_4343>
				</S_BGM>
				<!-- Receipt Date -->
				<xsl:if test="normalize-space(Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate) != ''">
					<S_DTM>
						<C_C507>
							<D_2005>50</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="normalize-space(Request/ReceiptRequest/ReceiptRequestHeader/@receiptDate)"/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>
				<!-- ShipNoticeIDInfo-->
				<xsl:if test="normalize-space(Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeID) != ''">
					<G_SG1>
						<S_RFF>
							<C_C506>
								<D_1153>DQ</D_1153>
								<D_1154>
									<xsl:value-of select="normalize-space(Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeID)"/>
								</D_1154>
							</C_C506>
						</S_RFF>
						<xsl:if test="normalize-space(Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeDate) != ''">
							<S_DTM>
								<C_C507>
									<D_2005>124</D_2005>
									<xsl:call-template name="formatDate">
										<xsl:with-param name="DocDate" select="normalize-space(Request/ReceiptRequest/ReceiptRequestHeader/ShipNoticeIDInfo/@shipNoticeDate)"/>
									</xsl:call-template>
								</C_C507>
							</S_DTM>
						</xsl:if>
					</G_SG1>
				</xsl:if>
				<!-- Extrinsic -->
				<xsl:for-each select="Request/ReceiptRequest/ReceiptRequestHeader/Extrinsic[9 &gt;= position()]">
					<G_SG1>
						<S_RFF>
							<C_C506>
								<D_1153>ZZZ</D_1153>
								<D_1154>
									<xsl:value-of select="substring(normalize-space(@name), 1, 35)"/>
								</D_1154>
								<D_4000>
									<xsl:value-of select="substring(normalize-space(.), 1, 35)"/>
								</D_4000>
							</C_C506>
						</S_RFF>
					</G_SG1>
				</xsl:for-each>
				<G_SG4>
					<S_NAD>
						<D_3035>XX</D_3035>
						<C_C058>
							<D_3124>UNSUPPORTED</D_3124>
						</C_C058>
					</S_NAD>
				</G_SG4>
				<G_SG16>
					<S_CPS>
						<D_7164>1</D_7164>
					</S_CPS>
					<xsl:for-each select="Request/ReceiptRequest/ReceiptOrder">
						<xsl:variable name="orderId">
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
						<xsl:variable name="agreementID">
							<xsl:choose>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementID) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementReference/@agreementID)"/>
								</xsl:when>
								<xsl:when test="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementID) != ''">
									<xsl:value-of select="normalize-space(ReceiptOrderInfo/MasterAgreementIDInfo/@agreementID)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="agreementDate">
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
						<xsl:variable name="closeForReceiving" select="normalize-space(@closeForReceiving)"/>
						<xsl:for-each select="ReceiptItem">
							<G_SG22>
								<S_LIN>
									<D_1082>
										<xsl:value-of select="normalize-space(@receiptLineNumber)"/>
									</D_1082>
									<C_C212>
										<D_7140>
											<xsl:value-of select="normalize-space(ReceiptItemReference/@lineNumber)"/>
										</D_7140>
										<D_7143>PL</D_7143>
									</C_C212>
									<xsl:if test="normalize-space(@parentReceiptLineNumber) != ''">
										<C_C829>
											<D_5495>1</D_5495>
											<D_1082>
												<xsl:value-of select="normalize-space(@parentReceiptLineNumber)"/>
											</D_1082>
										</C_C829>
									</xsl:if>
								</S_LIN>
								<xsl:if test="normalize-space(ReceiptItemReference/ItemID/SupplierPartID) != '' or normalize-space(ReceiptItemReference/ItemID/BuyerPartID) != '' or normalize-space(ReceiptItemReference/ManufacturerPartID) != ''">
									<S_PIA>
										<D_4347>5</D_4347>
										<xsl:choose>
											<xsl:when test="normalize-space(ReceiptItemReference/ItemID/SupplierPartID) != ''">
												<C_C212>
													<D_7140>
														<xsl:value-of select="substring(normalize-space(ReceiptItemReference/ItemID/SupplierPartID), 1, 35)"/>
													</D_7140>
													<D_7143>VN</D_7143>
													<D_1131>57</D_1131>
													<D_3055>91</D_3055>
												</C_C212>
												<xsl:choose>
													<xsl:when test="normalize-space(ReceiptItemReference/BuyerPartID) != '' and normalize-space(ReceiptItemReference/ManufacturerPartID) != ''">
														<C_C212_2>
															<D_7140>
																<xsl:value-of select="substring(normalize-space(ReceiptItemReference/BuyerPartID), 1, 35)"/>
															</D_7140>
															<D_7143>BP</D_7143>
															<D_1131>57</D_1131>
															<D_3055>92</D_3055>
														</C_C212_2>
														<C_C212_3>
															<D_7140>
																<xsl:value-of select="substring(normalize-space(ReceiptItemReference/ManufacturerPartID), 1, 35)"/>
															</D_7140>
															<D_7143>MF</D_7143>
															<D_1131>57</D_1131>
															<D_3055>90</D_3055>
														</C_C212_3>
													</xsl:when>
													<xsl:when test="normalize-space(ReceiptItemReference/BuyerPartID) != ''">
														<C_C212_2>
															<D_7140>
																<xsl:value-of select="substring(normalize-space(ReceiptItemReference/BuyerPartID), 1, 35)"/>
															</D_7140>
															<D_7143>BP</D_7143>
															<D_1131>57</D_1131>
															<D_3055>92</D_3055>
														</C_C212_2>
													</xsl:when>
													<xsl:when test="normalize-space(ReceiptItemReference/ManufacturerPartID) != ''">
														<C_C212_2>
															<D_7140>
																<xsl:value-of select="substring(normalize-space(ReceiptItemReference/ManufacturerPartID), 1, 35)"/>
															</D_7140>
															<D_7143>MF</D_7143>
															<D_1131>57</D_1131>
															<D_3055>90</D_3055>
														</C_C212_2>
													</xsl:when>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="normalize-space(ReceiptItemReference/ItemID/BuyerPartID) != ''">
												<C_C212>
													<D_7140>
														<xsl:value-of select="substring(normalize-space(ReceiptItemReference/ItemID/BuyerPartID), 1, 35)"/>
													</D_7140>
													<D_7143>BP</D_7143>
													<D_1131>57</D_1131>
													<D_3055>92</D_3055>
												</C_C212>
												<xsl:if test="normalize-space(ReceiptItemReference/ManufacturerPartID) != ''">
													<C_C212_2>
														<D_7140>
															<xsl:value-of select="substring(normalize-space(ReceiptItemReference/ManufacturerPartID), 1, 35)"/>
														</D_7140>
														<D_7143>MF</D_7143>
														<D_1131>57</D_1131>
														<D_3055>90</D_3055>
													</C_C212_2>
												</xsl:if>
											</xsl:when>
											<xsl:when test="normalize-space(ReceiptItemReference/ManufacturerPartID) != ''">
												<C_C212>
													<D_7140>
														<xsl:value-of select="substring(normalize-space(ReceiptItemReference/ManufacturerPartID), 1, 35)"/>
													</D_7140>
													<D_7143>MF</D_7143>
													<D_1131>57</D_1131>
													<D_3055>90</D_3055>
												</C_C212>
											</xsl:when>
										</xsl:choose>
									</S_PIA>
								</xsl:if>
								<xsl:if test="normalize-space(ReceiptItemReference/ItemID/SupplierPartAuxiliaryID) != '' or normalize-space(Batch/SupplierBatchID) != ''">
									<S_PIA>
										<D_4347>1</D_4347>
										<xsl:choose>
											<xsl:when test="normalize-space(ReceiptItemReference/ItemID/SupplierPartAuxiliaryID) != ''">
												<C_C212>
													<D_7140>
														<xsl:value-of select="substring(normalize-space(ReceiptItemReference/ItemID/SupplierPartAuxiliaryID), 1, 35)"/>
													</D_7140>
													<D_7143>VS</D_7143>
													<D_1131>67</D_1131>
													<D_3055>91</D_3055>
												</C_C212>
												<xsl:if test="normalize-space(Batch/SupplierBatchID) != ''">
													<C_C212_2>
														<D_7140>
															<xsl:value-of select="substring(normalize-space(Batch/SupplierBatchID), 1, 35)"/>
														</D_7140>
														<D_7143>NB</D_7143>
														<D_1131>57</D_1131>
														<D_3055>91</D_3055>
													</C_C212_2>
												</xsl:if>
											</xsl:when>
											<xsl:when test="normalize-space(Batch/SupplierBatchID) != ''">
												<C_C212>
													<D_7140>
														<xsl:value-of select="substring(normalize-space(Batch/SupplierBatchID), 1, 35)"/>
													</D_7140>
													<D_7143>NB</D_7143>
													<D_1131>57</D_1131>
													<D_3055>91</D_3055>
												</C_C212>
											</xsl:when>
										</xsl:choose>
									</S_PIA>
								</xsl:if>
								<!-- Description -->
								<xsl:if test="normalize-space(ReceiptItemReference/Description) != ''">
									<xsl:variable name="descText" select="normalize-space(ReceiptItemReference/Description)"/>
									<xsl:variable name="langCode" select="normalize-space(ReceiptItemReference/Description/@xml:lang)"/>
									<xsl:if test="$descText != ''">
										<xsl:call-template name="IMDLoop">
											<xsl:with-param name="IMDQual" select="'F'"/>
											<xsl:with-param name="IMDData" select="$descText"/>
											<xsl:with-param name="langCode" select="$langCode"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<!-- Description shortName -->
								<xsl:if test="normalize-space(ReceiptItemReference/Description/ShortName) != ''">
									<xsl:variable name="shortName" select="normalize-space(ReceiptItemReference/Description/ShortName)"/>
									<xsl:variable name="langCode" select="normalize-space(ReceiptItemReference/Description/@xml:lang)"/>
									<xsl:if test="$shortName != ''">
										<xsl:call-template name="IMDLoop">
											<xsl:with-param name="IMDQual" select="'E'"/>
											<xsl:with-param name="IMDData" select="$shortName"/>
											<xsl:with-param name="langCode" select="$langCode"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<S_QTY>
									<C_C186>
										<D_6063>
											<xsl:choose>
												<xsl:when test="normalize-space(@type) = 'returned'">195</xsl:when>
												<xsl:otherwise>48</xsl:otherwise>
											</xsl:choose>
										</D_6063>
										<D_6060>
											<!--<xsl:value-of select="normalize-space(@quantity)"/>-->
											<xsl:call-template name="formatDecimal">
												<xsl:with-param name="amount" select="normalize-space(@quantity)"/>
											</xsl:call-template>
										</D_6060>
										<D_6411>
											<xsl:value-of select="normalize-space(UnitRate/UnitOfMeasure)"/>
										</D_6411>
									</C_C186>
								</S_QTY>
								<xsl:if test="$orderId != ''">
									<G_SG28>
										<S_RFF>
											<C_C506>
												<D_1153>ON</D_1153>
												<D_1154>
													<xsl:value-of select="$orderId"/>
												</D_1154>
												<xsl:if test="$closeForReceiving != ''">
													<D_1156>
														<xsl:value-of select="$closeForReceiving"/>
													</D_1156>
												</xsl:if>
											</C_C506>
										</S_RFF>
										<xsl:if test="$orderDate != ''">
											<S_DTM>
												<C_C507>
													<D_2005>4</D_2005>
													<xsl:call-template name="formatDate">
														<xsl:with-param name="DocDate" select="$orderDate"/>
													</xsl:call-template>
												</C_C507>
											</S_DTM>
										</xsl:if>
									</G_SG28>
								</xsl:if>
								<xsl:if test="$agreementID != ''">
									<G_SG28>
										<S_RFF>
											<C_C506>
												<D_1153>CT</D_1153>
												<D_1154>
													<xsl:value-of select="$agreementID"/>
												</D_1154>
												<xsl:if test="$closeForReceiving != ''">
													<D_1156>
														<xsl:value-of select="$closeForReceiving"/>
													</D_1156>
												</xsl:if>
												<xsl:if test="$agreementType != ''">
													<D_4000>
														<xsl:value-of select="$agreementType"/>
													</D_4000>
												</xsl:if>
											</C_C506>
										</S_RFF>
										<xsl:if test="$agreementDate != ''">
											<S_DTM>
												<C_C507>
													<D_2005>126</D_2005>
													<xsl:call-template name="formatDate">
														<xsl:with-param name="DocDate" select="$agreementDate"/>
													</xsl:call-template>
												</C_C507>
											</S_DTM>
										</xsl:if>
									</G_SG28>
								</xsl:if>
								<xsl:variable name="shipNoticeID">
									<xsl:choose>
										<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeReference/@shipNoticeID) != ''">
											<xsl:value-of select="normalize-space(ReceiptItemReference/ShipNoticeReference/@shipNoticeID)"/>
										</xsl:when>
										<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeID) != ''">
											<xsl:value-of select="normalize-space(ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeID)"/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="shipNoticeDate">
									<xsl:choose>
										<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeReference/@shipNoticeDate) != ''">
											<xsl:value-of select="normalize-space(ReceiptItemReference/ShipNoticeReference/@shipNoticeDate)"/>
										</xsl:when>
										<xsl:when test="normalize-space(ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeDate) != ''">
											<xsl:value-of select="normalize-space(ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeDate)"/>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="$shipNoticeID != ''">
									<G_SG28>
										<S_RFF>
											<C_C506>
												<D_1153>DQ</D_1153>
												<D_1154>
													<xsl:value-of select="$shipNoticeID"/>
												</D_1154>
											</C_C506>
										</S_RFF>
										<xsl:if test="$shipNoticeDate != ''">
											<S_DTM>
												<C_C507>
													<D_2005>124</D_2005>
													<xsl:call-template name="formatDate">
														<xsl:with-param name="DocDate" select="$shipNoticeDate"/>
													</xsl:call-template>
												</C_C507>
											</S_DTM>
										</xsl:if>
									</G_SG28>
								</xsl:if>
								<xsl:variable name="extCount" select="10 - count($orderId[. != '']) - count($agreementID[. != '']) - count($shipNoticeID[. != ''])"/>
								<xsl:for-each select="Extrinsic[$extCount &gt;= position()]">
									<G_SG28>
										<S_RFF>
											<C_C506>
												<D_1153>ZZZ</D_1153>
												<D_1154>
													<xsl:value-of select="substring(normalize-space(@name), 1, 35)"/>
												</D_1154>
												<D_4000>
													<xsl:value-of select="substring(normalize-space(.), 1, 35)"/>
												</D_4000>
											</C_C506>
										</S_RFF>
									</G_SG28>
								</xsl:for-each>
							</G_SG22>
						</xsl:for-each>
					</xsl:for-each>
				</G_SG16>
				<S_CNT>
					<C_C270>
						<D_6069>2</D_6069>
						<D_6066>
							<xsl:value-of select="count(//ReceiptItem)"/>
						</D_6066>
					</C_C270>
				</S_CNT>
				<S_UNT>
					<D_0074>#segCount#</D_0074>
					<D_0062>0001</D_0062>
				</S_UNT>
			</M_RECADV>
			<S_UNZ>
				<D_0036>1</D_0036>
				<D_0020>
					<xsl:value-of select="$anICNValue"/>
				</D_0020>
			</S_UNZ>
		</ns0:Interchange>
	</xsl:template>
</xsl:stylesheet>
