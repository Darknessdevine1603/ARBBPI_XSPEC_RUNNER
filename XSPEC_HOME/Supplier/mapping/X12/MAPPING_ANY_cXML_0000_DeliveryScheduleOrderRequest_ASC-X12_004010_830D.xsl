<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/"
	exclude-result-prefixes="#all" version="2.0">
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
	<xsl:param name="segmentCount"/>
	<xsl:param name="exchange"/>
	<xsl:param name="anCRFlag"/>
	<!-- For local testing -->
	<!--<xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>-->
	<!-- PD references -->
	<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
	<xsl:template match="/">
		<xsl:variable name="dateNow" select="current-dateTime()"/>
		<ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:830:004010">
			<xsl:call-template name="createISA">
				<xsl:with-param name="dateNow" select="$dateNow"/>
			</xsl:call-template>
			<FunctionalGroup>
				<S_GS>
					<D_479>PS</D_479>
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
						<xsl:value-of select="format-dateTime($dateNow, '[H01][m01]')"/>
					</D_337>
					<D_28>
						<xsl:value-of select="$anICNValue"/>
					</D_28>
					<D_455>X</D_455>
					<D_480>004010</D_480>
				</S_GS>
				<M_830>
					<S_ST>
						<D_143>830</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_BFR>
						<D_353>
							<xsl:choose>
								<xsl:when
									test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'new'"
									>00</xsl:when>
								<xsl:when
									test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'"
									>05</xsl:when>
								<xsl:when
									test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'"
									>03</xsl:when>
								<xsl:otherwise>00</xsl:otherwise>
							</xsl:choose>
						</D_353>
						<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@orderID != ''">
							<D_127>
								<xsl:value-of
									select="substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderID, 0, 29)"
								/>
							</D_127>
						</xsl:if>

						<D_675>DL</D_675>
						<D_676>A</D_676>
						<D_373>
							<xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
						</D_373>
						<D_373_3>
							<xsl:value-of
								select="replace(substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 0, 11), '-', '')"
							/>
						</D_373_3>
						<xsl:if
							test="cXML/Request/OrderRequest/OrderRequestHeader/@agreementID != ''">
							<D_367>
								<xsl:value-of
									select="substring(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID, 0, 29)"
								/>
							</D_367>
						</xsl:if>
						<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@orderID != ''">
							<D_324>
								<xsl:value-of
									select="substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderID, 0, 21)"
								/>
							</D_324>
						</xsl:if>
					</S_BFR>
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID != ''">
						<S_REF>
							<D_128>RQ</D_128>
							<D_127>
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID"
								/>
							</D_127>
						</S_REF>
					</xsl:if>

					<xsl:if
						test="cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID != ''">
						<S_REF>
							<D_128>BC</D_128>
							<D_127>
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID"
								/>
							</D_127>
						</S_REF>
					</xsl:if>
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion != ''">
						<S_REF>
							<D_128>PP</D_128>
							<D_127>
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion"
								/>
							</D_127>
						</S_REF>
					</xsl:if>
					<xsl:if
						test="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID != ''">
						<S_REF>
							<D_128>VN</D_128>
							<D_127>
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID"
								/>
							</D_127>
						</S_REF>
					</xsl:if>
					<!-- expirationDate -->
					<xsl:if
						test="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">036</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<!-- orderDate -->
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@orderDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">004</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@orderDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<!-- effectiveDate -->
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">007</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<!-- pickUpDate -->
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">118</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<!-- requestedDeliveryDate -->
					<xsl:if
						test="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">002</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<!-- DeliveryPeriod/Period/ @startDate -->
					<xsl:if
						test="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">070</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<!-- DeliveryPeriod/Period/ @endDate -->
					<xsl:if
						test="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate != ''">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="D374_Qual">073</xsl:with-param>
							<xsl:with-param name="cXMLDate">
								<xsl:value-of
									select="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate"
								/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<!-- Bill To -->
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/BillTo">
						<xsl:call-template name="createN1">
							<xsl:with-param name="party"
								select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo"/>
						</xsl:call-template>
					</xsl:if>

					<!-- ShipTo -->
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo">
						<xsl:call-template name="createN1">
							<xsl:with-param name="party"
								select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"/>
							<xsl:with-param name="mapFOB" select="'true'"/>
						</xsl:call-template>
					</xsl:if>

					<!-- TermsOfDelivery -->
					<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery">
						<xsl:call-template name="createN1">
							<xsl:with-param name="party"
								select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery"/>
						</xsl:call-template>
					</xsl:if>

					<!-- Contacts -->
					<xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Contact">
						<xsl:call-template name="createContact">
							<xsl:with-param name="party" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Line Level -->
					<xsl:for-each select="cXML/Request/OrderRequest/ItemOut">
						<G_LIN>
							<S_LIN>
								<D_350>
									<xsl:value-of select="@lineNumber"/>
								</D_350>
								<xsl:call-template name="createItemParts">
									<xsl:with-param name="itemID" select="ItemID"/>
									<xsl:with-param name="itemDetail" select="ItemDetail"/>
								</xsl:call-template>
							</S_LIN>
							<xsl:variable name="uomcode">
								<xsl:choose>
									<xsl:when test="ItemDetail/UnitOfMeasure != ''">
										<xsl:value-of select="ItemDetail/UnitOfMeasure"/>
									</xsl:when>
									<xsl:when test="BlanketItemDetail/UnitOfMeasure != ''">
										<xsl:value-of select="BlanketItemDetail/UnitOfMeasure"/>
									</xsl:when>
									<xsl:otherwise>ZZ</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!-- UOM -->
							<S_UIT>
								<C_C001>
									<D_355>
										<xsl:choose>
											<xsl:when
												test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
												<xsl:value-of
												select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode][1]/X12Code"
												/>
											</xsl:when>
											<xsl:otherwise>ZZ</xsl:otherwise>
										</xsl:choose>
									</D_355>
								</C_C001>
							</S_UIT>

							<!-- requestedDeliveryDate -->
							<xsl:if test="@requestedDeliveryDate != ''">
								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">002</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of select="@requestedDeliveryDate"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<!-- requestedShipmentDate -->
							<xsl:if test="@requestedShipmentDate != ''">
								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">010</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of select="@requestedShipmentDate"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<!-- agreementDate -->
							<xsl:if test="MasterAgreementIDInfo/@agreementDate != ''">
								<xsl:call-template name="createDTM">
									<xsl:with-param name="D374_Qual">LEA</xsl:with-param>
									<xsl:with-param name="cXMLDate">
										<xsl:value-of select="MasterAgreementIDInfo/@agreementDate"
										/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>

							<!-- ShortName -->
							<!-- IG-15512 - Fix mapping to remove G_PID -->
							<xsl:choose>
								<xsl:when
									test="normalize-space(ItemDetail/Description/ShortName) != ''">
										<S_PID>
											<D_349>F</D_349>
											<D_750>GEN</D_750>
											<D_352>
												<xsl:value-of
												select="substring(normalize-space(ItemDetail/Description/ShortName), 1, 80)"
												/>
											</D_352>
											<D_819>
												<xsl:choose>
												<xsl:when
												test="string-length(normalize-space(ItemDetail/Description/@xml:lang)) &gt; 1">
												<xsl:value-of
												select="upper-case(substring(normalize-space(ItemDetail/Description/@xml:lang), 1, 2))"
												/>
												</xsl:when>
												<xsl:otherwise>EN</xsl:otherwise>
												</xsl:choose>
											</D_819>
										</S_PID>
								</xsl:when>
								<xsl:when
									test="normalize-space(BlanketItemDetail/Description/ShortName) != ''">
										<S_PID>
											<D_349>F</D_349>
											<D_750>GEN</D_750>
											<D_352>
												<xsl:value-of
												select="substring(normalize-space(BlanketItemDetail/Description/ShortName), 1, 80)"
												/>
											</D_352>
											<D_819>
												<xsl:choose>
												<xsl:when
												test="string-length(normalize-space(BlanketItemDetail/Description/@xml:lang)) &gt; 1">
												<xsl:value-of
												select="upper-case(substring(normalize-space(BlanketItemDetail/Description/@xml:lang), 1, 2))"
												/>
												</xsl:when>
												<xsl:otherwise>EN</xsl:otherwise>
												</xsl:choose>
											</D_819>
										</S_PID>
								</xsl:when>
							</xsl:choose>
							<!-- Description -->
							<xsl:variable name="desc">
								<xsl:choose>
									<xsl:when test="ItemDetail/Description/text() != ''">
										<xsl:value-of
											select="ItemDetail/Description/text()"/>
									</xsl:when>
									<xsl:when
										test="BlanketItemDetail/Description/text() != ''">
										<xsl:value-of
											select="BlanketItemDetail/Description/text()"
										/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="langCode">
								<xsl:choose>
									<xsl:when
										test="string-length(normalize-space(ItemDetail/Description/@xml:lang)) &gt; 1">
										<xsl:value-of
											select="upper-case(substring(normalize-space(ItemDetail/Description/@xml:lang), 1, 2))"
										/>
									</xsl:when>
									<xsl:when
										test="string-length(normalize-space(BlanketItemDetail/Description/@xml:lang)) &gt; 1">
										<xsl:value-of
											select="upper-case(substring(normalize-space(BlanketItemDetail/Description/@xml:lang), 1, 2))"
										/>
									</xsl:when>
									<xsl:otherwise>EN</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="StrLen" select="string-length( normalize-space($desc))"/>
							<xsl:if test="$StrLen &gt; 0">
								<!--<xsl:call-template name="PIDloop">
									<xsl:with-param name="Desc" select="$desc"/>
									<xsl:with-param name="langCode" select="$langCode"/>
								</xsl:call-template>-->
								<xsl:call-template name="PIDloops">
									<xsl:with-param name="Desc" select="$desc"/>
									<xsl:with-param name="langCode" select="$langCode"/>
								</xsl:call-template>
							</xsl:if>

							<xsl:if
								test="normalize-space(ItemDetail/ItemDetailIndustry/@isConfigurableMaterial) = 'yes'">
								
									<S_PID>
										<D_349>F</D_349>
										<D_750>21</D_750>
										<D_352>
											<xsl:value-of select="'Configurable Material'"/>
										</D_352>
									</S_PID>
								
							</xsl:if>
							<!-- createMEA -->
							<xsl:for-each select="ItemDetail/Dimension">
								<xsl:if test="(position() &lt; 41)">
									<xsl:call-template name="createMEA_FromDimension">
										<xsl:with-param name="dimension" select="."/>
										<xsl:with-param name="meaQual" select="'PD'"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>

							<!-- MasterAgreementIDInfo / @agreementID -->
							<xsl:if test="normalize-space(MasterAgreementIDInfo/@agreementID) != ''">
								<xsl:call-template name="createREF">
									<xsl:with-param name="qual" select="'AH'"/>
									<xsl:with-param name="ref02"
										select="MasterAgreementIDInfo/@agreementID"/>
								</xsl:call-template>
							</xsl:if>

							<!-- @requisitionID -->
							<xsl:if test="@requisitionID != ''">
								<S_REF>
									<D_128>RQ</D_128>
									<D_127>
										<xsl:value-of select="@requisitionID"/>
									</D_127>
								</S_REF>
							</xsl:if>

							<!-- parentLineNumber and itemType-->
							<xsl:if test="@parentLineNumber != '' or @itemType != ''">
								<S_REF>
									<D_128>FL</D_128>
									<xsl:if test="@parentLineNumber != ''">
										<D_127>
											<xsl:value-of select="@parentLineNumber"/>
										</D_127>
									</xsl:if>
									<xsl:if test="@itemType">
										<D_352>
											<xsl:value-of select="@itemType"/>
										</D_352>
									</xsl:if>
								</S_REF>
							</xsl:if>

							<!-- TermsOfDelivery -->
							<xsl:if test="TermsOfDelivery/ShippingPaymentMethod/@value != ''">
								<xsl:variable name="TOD"
									select="TermsOfDelivery/ShippingPaymentMethod/@value"/>
								<S_FOB>
									<D_146>
										<xsl:choose>
											<xsl:when
												test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code != ''">
												<xsl:value-of
												select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code"
												/>
											</xsl:when>
											<xsl:otherwise>DF</xsl:otherwise>
										</xsl:choose>
									</D_146>
									<D_309>
										<xsl:choose>
											<xsl:when
												test="lower-case(TermsOfDelivery/TermsOfDeliveryCode/@value) = 'other'"
												>ZZ</xsl:when>
											<xsl:otherwise>OF</xsl:otherwise>
										</xsl:choose>
									</D_309>
									<D_352>
										<xsl:choose>
											<xsl:when
												test="lower-case(TermsOfDelivery/TermsOfDeliveryCode/@value) = 'other'">
												<xsl:value-of
												select="TermsOfDelivery/TermsOfDeliveryCode"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="TermsOfDelivery/TermsOfDeliveryCode/@value"
												/>
											</xsl:otherwise>
										</xsl:choose>
									</D_352>
									<xsl:if test="exists(TermsOfDelivery/TransportTerms)">
										<xsl:variable name="TTVal"
											select="TermsOfDelivery/TransportTerms/@value"/>
										<D_334>01</D_334>
										<D_335>
											<xsl:choose>
												<xsl:when
												test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code != ''">
												<xsl:value-of
												select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code"
												/>
												</xsl:when>
												<xsl:otherwise>ZZZ</xsl:otherwise>
											</xsl:choose>
										</D_335>
									</xsl:if>
									<xsl:if test="TermsOfDelivery/ShippingPaymentMethod!=''">
									<D_309_2>ZZ</D_309_2>
									<D_352_2>
										<xsl:value-of select="TermsOfDelivery/ShippingPaymentMethod"
										/>
									</D_352_2>
									</xsl:if>
								</S_FOB>
							</xsl:if>
							<!-- ReleaseInfo @cumulativeReceivedQuantity -->
							<xsl:if test="ReleaseInfo/@cumulativeReceivedQuantity != ''">
								<G_QTY>
									<S_QTY>
										<D_673>02</D_673>
										<D_380>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty"
												select="ReleaseInfo/@cumulativeReceivedQuantity"/>
											</xsl:call-template>
										</D_380>
										<xsl:if test="ReleaseInfo/UnitOfMeasure != ''">
											<C_C001>
												<D_355>
												<xsl:value-of select="ReleaseInfo/UnitOfMeasure"/>
												</D_355>
											</C_C001>
										</xsl:if>
									</S_QTY>
								</G_QTY>
							</xsl:if>
							<!-- ItemOut @quantity -->
							<xsl:if test="@quantity != ''">
								<G_QTY>
									<S_QTY>
										<D_673>63</D_673>
										<D_380>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty" select="@quantity"/>
											</xsl:call-template>
										</D_380>
									</S_QTY>
								</G_QTY>
							</xsl:if>
							<!-- ShipTo/TransportInformation -->
							<xsl:for-each select="ShipTo/TransportInformation">
								<xsl:if test="ShippingContractNumber != '' or Route/@method != ''">
									<S_TD5>
										<D_133>Z</D_133>
										<xsl:if test="ShippingContractNumber != ''">
											<D_66>ZZ</D_66>
											<D_67>
												<xsl:value-of select="ShippingContractNumber"/>
											</D_67>
										</xsl:if>
										<xsl:if test="Route/@method != ''">
											<D_91>
												<xsl:choose>
												<xsl:when test="Route/@method = 'air'"
												>A</xsl:when>
												<xsl:when test="Route/@method = 'motor'"
												>J</xsl:when>
												<xsl:when test="Route/@method = 'rail'"
												>R</xsl:when>
												<xsl:when test="Route/@method = 'ship'"
												>S</xsl:when>
												</xsl:choose>
											</D_91>
										</xsl:if>
									</S_TD5>
								</xsl:if>
							</xsl:for-each>

							<!-- ShipTo/CarrierIdentifier -->
							<xsl:for-each select="ShipTo/CarrierIdentifier">
								<xsl:if test="@domain != ''">
									<S_TD5>
										<D_133>Z</D_133>
										<xsl:if test="@domain != ''">
											<D_66>
												<xsl:choose>
												<xsl:when test="@domain = 'DUNS'">1</xsl:when>
												<xsl:when test="@domain = 'SCAC'">2</xsl:when>
												<xsl:when test="@domain = 'IATA'">4</xsl:when>
												</xsl:choose>
											</D_66>
											<!-- Need to check on this -->
											<D_67>
												<xsl:value-of select="."/>
											</D_67>
										</xsl:if>

									</S_TD5>
								</xsl:if>
							</xsl:for-each>

							<!-- ShipTo -->
							<xsl:if test="ShipTo">
								<xsl:call-template name="createN1">
									<xsl:with-param name="party" select="ShipTo"/>
									<xsl:with-param name="mapFOB" select="'true'"/>
								</xsl:call-template>
							</xsl:if>

							<!-- TermsOfDelivery -->
							<xsl:if test="TermsOfDelivery">
								<xsl:call-template name="createN1">
									<xsl:with-param name="party" select="TermsOfDelivery"/>
								</xsl:call-template>
							</xsl:if>
							<!-- Contact -->
							<xsl:for-each select="Contact">
								<xsl:call-template name="createContact">
									<xsl:with-param name="party" select="."/>
									<xsl:with-param name="sprole" select="'yes'"/>
								</xsl:call-template>
							</xsl:for-each>

							<xsl:for-each select="ScheduleLine">
								<G_FST>
									<S_FST>
										<D_380>
											<xsl:call-template name="formatQty">
												<xsl:with-param name="qty" select="@quantity"/>
											</xsl:call-template>
										</D_380>
										<D_680>
											<xsl:choose>
												<xsl:when test="ScheduleLineReleaseInfo/@commitmentCode = 'firm'">C</xsl:when>
												<xsl:when test="ScheduleLineReleaseInfo/@commitmentCode = 'forecast'">D</xsl:when>
												<!-- IG-39131 cXML 'tradeoff' to X12 'B' -->
												<xsl:when test="ScheduleLineReleaseInfo/@commitmentCode = 'tradeoff'">B</xsl:when>
											</xsl:choose>
										</D_680>
										<D_681>
											<xsl:value-of select="'D'"/>
										</D_681>

										<D_373>
											<xsl:value-of
												select="translate(substring-before(@requestedDeliveryDate, 'T'), '-', '')"
											/>
										</D_373>

										<xsl:if test="@deliveryWindow != ''">
											<D_373_2>
												<xsl:variable name="deliverywindow">
												<xsl:value-of
												select="concat('P', @deliveryWindow, 'D')"/>
												</xsl:variable>
												<xsl:variable name="RDDDatePlusDW">
												<xsl:value-of
												select="concat(replace(string(xs:date(substring(@requestedDeliveryDate, 0, 11)) + xs:dayTimeDuration($deliverywindow)), '-', ''), (replace(substring(@requestedDeliveryDate, 12, 8), ':', '')))"
												/>
												</xsl:variable>
												<xsl:value-of
												select="substring($RDDDatePlusDW, 0, 9)"/>
											</D_373_2>
										</xsl:if>
									</S_FST>

									<S_QTY>
										<D_673>02</D_673>
										<xsl:if
											test="ScheduleLineReleaseInfo/@cumulativeScheduledQuantity != ''">
											<D_380>
												<xsl:call-template name="formatQty">
												<xsl:with-param name="qty"
												select="ScheduleLineReleaseInfo/@cumulativeScheduledQuantity"
												/>
												</xsl:call-template>
											</D_380>
										</xsl:if>
										<xsl:if test="ScheduleLineReleaseInfo/UnitOfMeasure != ''">
											<C_C001>
												<D_355>
												<xsl:value-of
												select="ScheduleLineReleaseInfo/UnitOfMeasure"/>
												</D_355>
											</C_C001>
										</xsl:if>
									</S_QTY>
								</G_FST>
							</xsl:for-each>

						</G_LIN>
					</xsl:for-each>
					<S_CTT>
						<D_354>
							<xsl:value-of select="count(/cXML/Request/OrderRequest/ItemOut)"/>
						</D_354>
					</S_CTT>
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_830>
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
	<!-- IG-15512 - New template added -->
	<xsl:template name="PIDloops">
		<xsl:param name="Desc"/>
		<xsl:param name="langCode"/>
		<xsl:param name="isShipIns"/>
		<xsl:variable name="xmlLang">
			<xsl:choose>
				<xsl:when test="string-length(normalize-space($langCode)) &gt; 1">
					<xsl:value-of select="upper-case(substring(normalize-space($langCode), 1, 2))"/>
				</xsl:when>
				<xsl:otherwise>EN</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		
			<S_PID>
				<D_349>F</D_349>
				<xsl:if test="$isShipIns = 'yes'">
					<D_750>93</D_750>
				</xsl:if>
				<D_352>
					<xsl:value-of select="substring($Desc, 1, 80)"/>
				</D_352>
				<D_819>
					<xsl:value-of select="$xmlLang"/>
				</D_819>
			</S_PID>		
		<xsl:if test="string-length($Desc) &gt; 80">
			<xsl:call-template name="PIDloops">
				<xsl:with-param name="Desc" select="substring($Desc, 81)"/>
				<xsl:with-param name="langCode" select="$xmlLang"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
