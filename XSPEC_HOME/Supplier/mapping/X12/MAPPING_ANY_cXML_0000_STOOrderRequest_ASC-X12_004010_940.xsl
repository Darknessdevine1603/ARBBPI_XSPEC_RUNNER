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
	<!-- xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
		<xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/-->
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
					<D_479>PO</D_479>
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
				<M_940>
					<S_ST>
						<D_143>940</D_143>
						<D_329>0001</D_329>
					</S_ST>
					<S_W05>
						<xsl:element name="D_473">
							<xsl:choose>
								<xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'new'">N</xsl:when>
								<xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">D</xsl:when>
								<xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">R</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<D_285>
							<xsl:value-of select="substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderID, 1, 22)"/>
						</D_285>
					</S_W05>
					<!-- BillTo -->
					<xsl:call-template name="createN1_0100">
						<xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo"/>
						<xsl:with-param name="isOrder" select="'true'"/>
					</xsl:call-template>
					<!-- ShipTo -->
					<xsl:if test="exists(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo)">
						<xsl:call-template name="createN1_0100">
							<xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"/>
						</xsl:call-template>
					</xsl:if>
					<!-- SF Address -->
					<xsl:if test="exists(cXML/Request/OrderRequest/OrderRequestHeader/BusinessPartner[@role = 'shipFrom']/Address)">
						<xsl:call-template name="createN1_0100">
							<xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/BusinessPartner[@role = 'shipFrom']"/>
							<xsl:with-param name="spRole" select="'SF'"/>
							<xsl:with-param name="isOrder" select="'true'"/>
						</xsl:call-template>
					</xsl:if>
					<!-- SF Address -->
					<xsl:if test="exists(cXML/Request/OrderRequest/OrderRequestHeader/BusinessPartner[@role = 'soldTo']/Address)">
						<xsl:call-template name="createN1_0100">
							<xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/BusinessPartner[@role = 'shipFrom']"/>
							<xsl:with-param name="spRole" select="'SO'"/>
							<xsl:with-param name="isOrder" select="'true'"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="exists(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address)">
						<xsl:call-template name="createN1_0100">
							<xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery"/>
						</xsl:call-template>
					</xsl:if>
					<!-- Contacts -->
					<xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Contact">
						<xsl:call-template name="createContact_0100">
							<xsl:with-param name="party" select="."/>
							<xsl:with-param name="isOrder" select="'true'"/>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:if test="cXML/Header/From/Credential[@domain = 'SystemID']/Identity != ''">
						<S_N9>
							<D_128>06</D_128>
							<D_127>
								<xsl:value-of select="cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
							</D_127>
						</S_N9>
					</xsl:if>
					<!-- Details -->
					<xsl:for-each select="cXML/Request/OrderRequest/ItemOut">
						<xsl:variable name="uom">
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
						<xsl:variable name="unitPrice">
							<xsl:choose>
								<xsl:when test="ItemDetail/Extrinsic[@name = 'hideUnitPrice']">0.00</xsl:when>
								<xsl:when test="/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideUnitPrice']">0.00</xsl:when>
								<xsl:when test="ItemDetail/UnitPrice/Money != ''">
									<xsl:call-template name="formatAmount">
										<xsl:with-param name="amount" select="ItemDetail/UnitPrice/Money"/>
									</xsl:call-template>
									<!--xsl:value-of select="replace(ItemDetail/UnitPrice/Money,',','')"/-->
								</xsl:when>
								<xsl:when test="BlanketItemDetail/UnitPrice/Money != ''">
									<xsl:call-template name="formatAmount">
										<xsl:with-param name="amount" select="BlanketItemDetail/UnitPrice/Money"/>
									</xsl:call-template>
									<!--xsl:value-of select="replace(BlanketItemDetail/UnitPrice/Money,',','')"/-->
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="curr">
							<xsl:choose>
								<xsl:when test="ItemDetail/UnitPrice/Money/@currency">
									<xsl:value-of select="ItemDetail/UnitPrice/Money/@currency"/>
								</xsl:when>
								<xsl:when test="BlanketItemDetail/UnitPrice/Money/@currency">
									<xsl:value-of select="BlanketItemDetail/UnitPrice/Money/@currency"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="altCurr">
							<xsl:choose>
								<xsl:when test="ItemDetail/UnitPrice/Money/@alternateCurrency">
									<xsl:value-of select="ItemDetail/UnitPrice/Money/@alternateCurrency"/>
								</xsl:when>
								<xsl:when test="BlanketItemDetail/UnitPrice/Money/@alternateCurrency">
									<xsl:value-of select="BlanketItemDetail/UnitPrice/Money/@alternateCurrency"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<G_0300>
							<S_LX>
								<D_554>
									<xsl:value-of select="@lineNumber"/>
								</D_554>
							</S_LX>
							<G_0310>
								<S_W01>
									<D_330>
										<xsl:call-template name="formatQty">
											<xsl:with-param name="qty" select="./@quantity"/>
										</xsl:call-template>
										<!--xsl:value-of select="./@quantity"/-->
									</D_330>
									<D_355>
										<xsl:choose>
											<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
												<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
											</xsl:when>
											<xsl:otherwise>ZZ</xsl:otherwise>
										</xsl:choose>
									</D_355>
									<xsl:if test="ItemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier">
										<D_554>
											<xsl:value-of select="ItemID/IdReference[@domain = 'UPCConsumerPackageCode']/@identifier"/>
										</D_554>
									</xsl:if>
									<xsl:call-template name="createItemParts">
										<xsl:with-param name="itemID" select="ItemID"/>
										<xsl:with-param name="itemDetail" select="ItemDetail"/>
									</xsl:call-template>
								</S_W01>
								<S_QTY>
									<D_673>DY</D_673>
									<D_380>
										<xsl:call-template name="formatQty">
											<xsl:with-param name="qty" select="./@quantity"/>
										</xsl:call-template>
									</D_380>
								</S_QTY>
								<S_LS>
									<D_447>LX</D_447>
								</S_LS>
								<xsl:for-each select="ScheduleLine">
									<G_0330>
										<S_LX>
											<D_554>
												<xsl:value-of select="@lineNumber"/>
											</D_554>
										</S_LX>
									</G_0330>
									<S_LE>
										<D_447>LX</D_447>
									</S_LE>
								</xsl:for-each>
							</G_0310>
						</G_0300>
					</xsl:for-each>
					<!-- Summary -->
					<S_SE>
						<D_96>
							<xsl:text>#segCount#</xsl:text>
						</D_96>
						<D_329>0001</D_329>
					</S_SE>
				</M_940>
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
	<xsl:template name="createN1_LineShipTo">
		<xsl:param name="party"/>
		<xsl:param name="mapFOB"/>
		<xsl:variable name="role">
			<xsl:choose>
				<xsl:when test="name($party) = 'BillTo'">BT</xsl:when>
				<xsl:when test="name($party) = 'ShipTo'">ST</xsl:when>
				<xsl:when test="name($party) = 'TermsOfDelivery'">DA</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<G_N1>
			<S_N1>
				<D_98>
					<xsl:value-of select="$role"/>
				</D_98>
				<D_93>
					<xsl:choose>
						<xsl:when test="$party/Address/Name != ''">
							<xsl:value-of select="substring($party/Address/Name, 1, 60)"/>
						</xsl:when>
						<xsl:otherwise>Not Available</xsl:otherwise>
					</xsl:choose>
				</D_93>
				<xsl:variable name="addrDomain" select="$party/Address/@addressIDDomain"/>
				<!-- CG -->
				<xsl:if test="string-length($party/Address/@addressID) &gt; 1">
					<D_66>
						<xsl:choose>
							<xsl:when test="$addrDomain = ''">92</xsl:when>
							<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code != ''">
								<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code"/>
							</xsl:when>
							<xsl:otherwise>92</xsl:otherwise>
						</xsl:choose>
					</D_66>
					<D_67>
						<xsl:value-of select="substring($party/Address/@addressID, 1, 80)"/>
					</D_67>
				</xsl:if>
			</S_N1>
			<xsl:call-template name="createN2N3N4_FromAddress">
				<xsl:with-param name="address" select="$party/Address/PostalAddress"/>
			</xsl:call-template>
			<xsl:call-template name="createCom">
				<xsl:with-param name="party" select="$party"/>
			</xsl:call-template>
			<xsl:if test="name($party) = 'ShipTo'">
				<xsl:choose>
					<xsl:when test="$mapFOB = 'true'">
						<!-- TermsOfDelivery -->
						<xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value != ''">
							<xsl:variable name="TOD" select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
							<S_FOB>
								<D_146>
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code != ''">
											<xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code"/>
										</xsl:when>
										<xsl:otherwise>DF</xsl:otherwise>
									</xsl:choose>
								</D_146>
								<xsl:if test="exists(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms)">
									<xsl:variable name="TTVal" select="normalize-space(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value)"/>
									<D_334>01</D_334>
									<D_335>
										<xsl:choose>
											<xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code != ''">
												<xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code"/>
											</xsl:when>
											<!-- IG-31554 -->
											<xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $TTVal]/X12Code != ''">
												<xsl:value-of select="$TTVal"/>
											</xsl:when>
											<xsl:otherwise>ZZZ</xsl:otherwise>
										</xsl:choose>
									</D_335>
								</xsl:if>
							</S_FOB>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="$party/TransportInformation">
							<xsl:if test="position() &lt; 13">
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
													<xsl:when test="Route/@method = 'air'">A</xsl:when>
													<xsl:when test="Route/@method = 'motor'">J</xsl:when>
													<xsl:when test="Route/@method = 'rail'">R</xsl:when>
													<xsl:when test="Route/@method = 'ship'">S</xsl:when>
												</xsl:choose>
											</D_91>
										</xsl:if>
										<!-- CG: IG-1388 matching AN Legacy and MSFT IG -->
										<xsl:if test="normalize-space(ShippingInstructions/Description) != ''">
											<D_309>ZZ</D_309>
											<D_310>
												<xsl:value-of select="substring(normalize-space(ShippingInstructions/Description), 1, 30)"/>
											</D_310>
										</xsl:if>
									</S_TD5>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="$party/CarrierIdentifier">
							<xsl:if test="position() &lt; 6">
								<S_TD4>
									<D_152>ZZZ</D_152>
									<D_352>
										<xsl:value-of select="concat(., '@domain', ./@domain)"/>
									</D_352>
								</S_TD4>
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</G_N1>
	</xsl:template>
	<xsl:template name="HashTotal">
		<xsl:variable name="HashValue">
			<value>
				<xsl:for-each select="cXML/Request/OrderRequest/ItemOut/@quantity">
					<xsl:if test="normalize-space(.) != ''">
						<itemQty>
							<xsl:call-template name="formatQty">
								<xsl:with-param name="qty" select="."/>
							</xsl:call-template>
						</itemQty>
					</xsl:if>
				</xsl:for-each>
			</value>
		</xsl:variable>
		<xsl:variable name="summaryHashQty" select="
				string(sum(for $i in $HashValue/value/itemQty
				return
					xs:decimal($i)))"/>
		<xsl:choose>
			<xsl:when test="string-length($summaryHashQty) &gt; 10">
				<xsl:value-of select="substring($summaryHashQty, 1, 10)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="formatQty">
					<xsl:with-param name="qty" select="$summaryHashQty"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createN1_0100">
		<xsl:param name="party"/>
		<xsl:param name="mapFOB"/>
		<xsl:param name="spRole"/>
		<xsl:param name="isOrder"/>
		<xsl:variable name="role">
			<xsl:choose>
				<xsl:when test="name($party) = 'BillTo'">BT</xsl:when>
				<xsl:when test="name($party) = 'ShipTo'">ST</xsl:when>
				<xsl:when test="name($party) = 'TermsOfDelivery'">DA</xsl:when>
				<xsl:when test="$spRole != ''">
					<xsl:value-of select="$spRole"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<G_0100>
			<S_N1>
				<D_98>
					<xsl:value-of select="$role"/>
				</D_98>
				<D_93>
					<xsl:choose>
						<xsl:when test="$party/Address/Name != ''">
							<xsl:value-of select="substring($party/Address/Name, 1, 60)"/>
						</xsl:when>
						<xsl:otherwise>Not Available</xsl:otherwise>
					</xsl:choose>
				</D_93>
				<xsl:variable name="addrDomain" select="$party/Address/@addressIDDomain"/>
				<!-- CG -->
				<xsl:if test="string-length($party/Address/@addressID) &gt; 1">
					<D_66>
						<xsl:choose>
							<xsl:when test="$addrDomain = ''">92</xsl:when>
							<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code != ''">
								<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code"/>
							</xsl:when>
							<xsl:otherwise>92</xsl:otherwise>
						</xsl:choose>
					</D_66>
					<D_67>
						<xsl:value-of select="substring($party/Address/@addressID, 1, 80)"/>
					</D_67>
				</xsl:if>
			</S_N1>
			<xsl:call-template name="createN2N3N4_FromAddress">
				<xsl:with-param name="address" select="$party/Address/PostalAddress"/>
			</xsl:call-template>
			<xsl:call-template name="createCom">
				<xsl:with-param name="party" select="$party"/>
			</xsl:call-template>
			<xsl:if test="name($party) = 'ShipTo'">
				<xsl:choose>
					<xsl:when test="$mapFOB = 'true'">
						<!-- TermsOfDelivery -->
						<xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value != ''">
							<xsl:variable name="TOD" select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
							<S_FOB>
								<D_146>
									<xsl:choose>
										<xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code != ''">
											<xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code"/>
										</xsl:when>
										<xsl:otherwise>DF</xsl:otherwise>
									</xsl:choose>
								</D_146>
								<xsl:if test="exists(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms)">
									<xsl:variable name="TTVal" select="normalize-space(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value)"/>
									<D_334>01</D_334>
									<D_335>
										<xsl:choose>
											<xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code != ''">
												<xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code"/>
											</xsl:when>
											<!-- IG-31554 -->
											<xsl:when test="$isOrder = 'true' and ($Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $TTVal]/X12Code != '')">
												<xsl:value-of select="$TTVal"/>
											</xsl:when>
											<xsl:otherwise>ZZZ</xsl:otherwise>
										</xsl:choose>
									</D_335>
								</xsl:if>
							</S_FOB>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="$party/TransportInformation">
							<xsl:if test="position() &lt; 13">
								<xsl:if test="ShippingContractNumber != '' or Route/@method != ''">
									<S_TD5>
										<D_133>Z</D_133>
										<D_66>ZZ</D_66>
										<xsl:if test="ShippingContractNumber != ''">
											<D_67>
												<xsl:value-of select="ShippingContractNumber"/>
											</D_67>
										</xsl:if>
										<xsl:if test="Route/@method != ''">
											<D_91>
												<xsl:choose>
													<xsl:when test="Route/@method = 'air'">A</xsl:when>
													<xsl:when test="Route/@method = 'motor'">J</xsl:when>
													<xsl:when test="Route/@method = 'rail'">R</xsl:when>
													<xsl:when test="Route/@method = 'ship'">S</xsl:when>
												</xsl:choose>
											</D_91>
										</xsl:if>
										<xsl:if test="normalize-space(ShippingInstructions/Description) != ''">
											<D_387>
												<xsl:value-of select="substring(normalize-space(ShippingInstructions/Description), 1, 35)"/>
											</D_387>
										</xsl:if>
									</S_TD5>
								</xsl:if>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="$party/CarrierIdentifier">
							<xsl:if test="position() &lt; 6">
								<S_TD4>
									<D_152>ZZZ</D_152>
									<D_352>
										<xsl:value-of select="concat(., '@domain', ./@domain)"/>
									</D_352>
								</S_TD4>
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</G_0100>
	</xsl:template>
	<xsl:template name="createContact_0100">
		<xsl:param name="party"/>
		<xsl:param name="sprole"/>
		<xsl:param name="isOrder"/>
		<xsl:variable name="role">
			<xsl:choose>
				<xsl:when test="$sprole = 'yes' and $party/@role = 'locationTo'">ST</xsl:when>
				<xsl:when test="$sprole = 'yes' and $party/@role = 'locationFrom'">SU</xsl:when>
				<xsl:when test="$sprole = 'yes' and $party/@role = 'BuyerPlannerCode'">MI</xsl:when>
				<xsl:when test="$sprole = 'QN' and $party/@role = 'buyerParty'">BY</xsl:when>
				<xsl:when test="$sprole = 'QN' and $party/@role = 'sellerParty'">SU</xsl:when>
				<xsl:when test="$sprole = 'QN' and $party/@role = 'senderParty'">FR</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code != ''">
							<xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $party/@role]/X12Code"/>
						</xsl:when>
						<xsl:otherwise>ZZ</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<G_0100>
			<S_N1>
				<D_98>
					<xsl:value-of select="$role"/>
				</D_98>
				<D_93>
					<xsl:choose>
						<xsl:when test="$party/Name != ''">
							<xsl:value-of select="substring(normalize-space($party/Name), 1, 60)"/>
						</xsl:when>
						<xsl:otherwise>Not Available</xsl:otherwise>
					</xsl:choose>
				</D_93>
				<xsl:variable name="addrDomain" select="$party/@addressIDDomain"/>
				<!-- CG -->
				<xsl:if test="string-length($party/@addressID) &gt; 1">
					<D_66>
						<xsl:choose>
							<xsl:when test="$addrDomain = ''">92</xsl:when>
							<xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code != ''">
								<xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code"/>
							</xsl:when>
							<xsl:otherwise>92</xsl:otherwise>
						</xsl:choose>
					</D_66>
					<D_67>
						<xsl:value-of select="substring(normalize-space($party/@addressID), 1, 80)"/>
					</D_67>
				</xsl:if>
			</S_N1>
			<!-- DeliverTO logic changed -->
			<xsl:variable name="delTo">
				<DeliverToList>
					<xsl:for-each select="$party/PostalAddress/DeliverTo">
						<xsl:if test="normalize-space(.) != ''">
							<DeliverToItem>
								<xsl:value-of select="substring(normalize-space(.), 0, 60)"/>
							</DeliverToItem>
						</xsl:if>
					</xsl:for-each>
				</DeliverToList>
			</xsl:variable>
			<xsl:variable name="delToCount" select="count($delTo/DeliverToList/DeliverToItem)"/>
			<xsl:choose>
				<xsl:when test="$delToCount = 1">
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount = 2">
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount = 3">
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
						</D_93>
					</S_N2>
				</xsl:when>
				<xsl:when test="$delToCount &gt; 3">
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[1]"/>
						</D_93>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[2]"/>
						</D_93_2>
					</S_N2>
					<S_N2>
						<D_93>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[3]"/>
						</D_93>
						<D_93_2>
							<xsl:value-of select="$delTo/DeliverToList/DeliverToItem[4]"/>
						</D_93_2>
					</S_N2>
				</xsl:when>
			</xsl:choose>
			<!-- Street logic changed -->
			<xsl:variable name="street">
				<StreetList>
					<xsl:for-each select="$party/PostalAddress/Street">
						<xsl:if test="normalize-space(.) != ''">
							<StreetItem>
								<xsl:value-of select="substring(normalize-space(.), 0, 55)"/>
							</StreetItem>
						</xsl:if>
					</xsl:for-each>
				</StreetList>
			</xsl:variable>
			<xsl:variable name="streetCount" select="count($street/StreetList/StreetItem)"/>
			<xsl:choose>
				<xsl:when test="$streetCount = 1">
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount = 2">
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount = 3">
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
						</D_166>
					</S_N3>
				</xsl:when>
				<xsl:when test="$streetCount &gt; 3">
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[1]"/>
						</D_166>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[2]"/>
						</D_166_2>
					</S_N3>
					<S_N3>
						<D_166>
							<xsl:value-of select="$street/StreetList/StreetItem[3]"/>
						</D_166>
						<D_166_2>
							<xsl:value-of select="$street/StreetList/StreetItem[4]"/>
						</D_166_2>
					</S_N3>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="normalize-space($party/PostalAddress/City) != '' or normalize-space($party/PostalAddress/State) != '' or normalize-space($party/PostalAddress/PostalCode) != '' or normalize-space($party/PostalAddress/Country/@isoCountryCode) != ''">
				<S_N4>
					<xsl:if test="string-length(normalize-space($party/PostalAddress/City)) &gt; 1">
						<D_19>
							<xsl:value-of select="substring(normalize-space($party/PostalAddress/City), 1, 30)"/>
						</D_19>
					</xsl:if>
					<xsl:variable name="uscaStateCode">
						<xsl:if test="($party/PostalAddress/Country/@isoCountryCode = 'US' or $party/PostalAddress/Country/@isoCountryCode = 'CA') and normalize-space($party/PostalAddress/State) != ''">
							<xsl:variable name="stCode" select="normalize-space($party/PostalAddress/State)"/>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode != ''">
									<xsl:value-of select="$Lookup/Lookups/States/State[stateName = $stCode]/stateCode"/>
								</xsl:when>
								<xsl:when test="string-length($stCode) = 2">
									<xsl:value-of select="upper-case($stCode)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="$uscaStateCode != ''">
						<D_156>
							<xsl:value-of select="$uscaStateCode"/>
						</D_156>
					</xsl:if>
					<xsl:if test="string-length(normalize-space($party/PostalAddress/PostalCode)) &gt; 2">
						<D_116>
							<xsl:value-of select="substring(normalize-space($party/PostalAddress/PostalCode), 1, 15)"/>
						</D_116>
					</xsl:if>
					<xsl:if test="$party/PostalAddress/Country/@isoCountryCode != ''">
						<D_26>
							<xsl:value-of select="$party/PostalAddress/Country/@isoCountryCode"/>
						</D_26>
					</xsl:if>
					<xsl:if test="$uscaStateCode = '' and normalize-space($party/PostalAddress/State) != ''">
						<D_309>SP</D_309>
						<D_310>
							<xsl:value-of select="normalize-space($party/PostalAddress/State)"/>
						</D_310>
					</xsl:if>
				</S_N4>
			</xsl:if>
			<xsl:call-template name="createCom">
				<xsl:with-param name="party" select="$party"/>
			</xsl:call-template>
		</G_0100>
	</xsl:template>

</xsl:stylesheet>
