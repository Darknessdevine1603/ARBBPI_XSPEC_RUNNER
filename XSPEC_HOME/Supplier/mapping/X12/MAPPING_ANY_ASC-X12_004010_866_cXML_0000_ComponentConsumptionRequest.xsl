<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="anSenderDefaultTimeZone"/>

	<!--xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/-->
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>

	<xsl:template match="*">
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="current-dateTime()"/>
			</xsl:attribute>
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<Header>
				<From>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anSupplierANID"/>
						</Identity>
					</Credential>
				</From>
				<To>
					<Credential domain="NetworkID">
						<Identity>
							<xsl:value-of select="$anBuyerANID"/>
						</Identity>
					</Credential>
				</To>
				<Sender>
					<Credential domain="NetworkId">
						<Identity>
							<xsl:value-of select="$anProviderANID"/>
						</Identity>
					</Credential>
					<UserAgent>
						<xsl:value-of select="'Ariba Supplier'"/>
					</UserAgent>
				</Sender>
			</Header>
			<Request>
				<xsl:choose>
					<xsl:when test="$anEnvName='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<ComponentConsumptionRequest>
					<ComponentConsumptionHeader>
						<xsl:attribute name="consumptionID">
							<xsl:value-of select="FunctionalGroup/M_866/S_BSS/D_127"/>
						</xsl:attribute>
						<xsl:if test="ST/BSS/BSS03 != ''">
							<xsl:attribute name="creationDate">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="FunctionalGroup/M_866/S_BSS/D_373"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="operation">
							<xsl:choose>
								<xsl:when test="FunctionalGroup/M_866/S_BSS/D_353='00'">
									<xsl:text>new</xsl:text>
								</xsl:when>
								<xsl:when test="FunctionalGroup/M_866/S_BSS/D_353='05'">
									<xsl:text>update</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="FunctionalGroup/M_866/S_BSS/D_127_2 != ''">
							<xsl:attribute name="referenceDocumentID">
								<xsl:value-of select="FunctionalGroup/M_866/S_BSS/D_127_2"/>
							</xsl:attribute>
						</xsl:if>
					</ComponentConsumptionHeader>
					<xsl:for-each select="FunctionalGroup/M_866/G_DTM">
						<ComponentConsumptionPortion>
							<xsl:if test="S_DTM[D_374='004']/D_373!='' or S_REF/D_128 != ''">
								<OrderReference>
									<xsl:attribute name="orderID">
										<xsl:value-of select="S_REF[D_128='PO']/D_127"/>
									</xsl:attribute>
									<xsl:if test="S_DTM[D_374='004']/D_373!=''">
										<xsl:variable name="chkOrderDate">
											<xsl:call-template name="convertToAribaDatePORef">
												<xsl:with-param name="Date" select="S_DTM[D_374 = '004']/D_373"/>
												<xsl:with-param name="Time" select="S_DTM[D_374 = '004']/D_337"/>
												<xsl:with-param name="TimeCode" select="S_DTM[D_374 = '004']/D_623"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:if test="$chkOrderDate!=''">
											<xsl:attribute name="orderDate">
												<xsl:value-of select="$chkOrderDate"/>
											</xsl:attribute>
										</xsl:if>
										<!--xsl:attribute name="orderDate">
											<xsl:call-template name="formatDate">
												<xsl:with-param name="date" select="S_DTM/D_373"/>
												<xsl:with-param name="time" select="S_DTM/D_337"/>
												<xsl:with-param name="tzone" select="S_DTM/D_623"/>
											</xsl:call-template>
										</xsl:attribute-->
									</xsl:if>
									<DocumentReference>
										<xsl:attribute name="payloadID">
											<xsl:value-of select="''"/>
										</xsl:attribute>
									</DocumentReference>
								</OrderReference>
							</xsl:if>
							<xsl:for-each select="G_LIN">
								<xsl:variable name="lin">
									<xsl:call-template name="createLIN">
										<xsl:with-param name="LIN" select="S_LIN"/>
									</xsl:call-template>
								</xsl:variable>
								<ComponentConsumptionItem>
									<xsl:if test="$lin/lin/element[@name='PL']/@value!=''">
										<xsl:attribute name="poLineNumber">
											<xsl:value-of select="$lin/lin/element[@name='PL']/@value"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="normalize-space(S_REF[D_128='RPT']/D_352)!=''">
										<xsl:attribute name="completedIndicator">
											<xsl:value-of select="normalize-space(S_REF[D_128='RPT']/D_352)"/>
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="normalize-space(S_QTY[D_673='99']/D_380)!=''">
										<xsl:attribute name="quantity">
											<xsl:value-of select="normalize-space(S_QTY[D_673='99']/D_380)"/>
										</xsl:attribute>
									</xsl:if>
									<ItemID>
										<xsl:if test="$lin/lin/element[@name='VP']/@value!=''">
											<SupplierPartID>
												<xsl:value-of select="$lin/lin/element[@name='VP']/@value"/>
											</SupplierPartID>
										</xsl:if>
										<xsl:if test="$lin/lin/element[@name='VS']/@value!=''">
											<SupplierPartAuxiliaryID>
												<xsl:value-of select="$lin/lin/element[@name='VS']/@value"/>
											</SupplierPartAuxiliaryID>
										</xsl:if>
										<xsl:if test="$lin/lin/element[@name='BP']/@value!=''">
											<BuyerPartID>
												<xsl:value-of select="$lin/lin/element[@name='BP']/@value"/>
											</BuyerPartID>
										</xsl:if>
									</ItemID>
									<xsl:if test="normalize-space(S_QTY[D_673='99']/C_C001/D_355)!=''">
										<UnitOfMeasure>
											<xsl:variable name="uom_line" select="normalize-space(S_QTY[D_673='99']/C_C001/D_355)"/>
											<xsl:choose>
												<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom_line]/CXMLCode!=''">
													<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom_line][1]/CXMLCode"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$uom_line"/>
												</xsl:otherwise>
											</xsl:choose>
										</UnitOfMeasure>
									</xsl:if>
									<xsl:if test="$lin/lin/element[@name='B8']/@value!='' or $lin/lin/element[@name='LT']/@value!=''">
										<Batch>
											<xsl:if test="$lin/lin/element[@name='LT']/@value!=''">
												<BuyerBatchID>
													<xsl:value-of select="$lin/lin/element[@name='LT']/@value"/>
												</BuyerBatchID>
											</xsl:if>
											<xsl:if test="$lin/lin/element[@name='B8']/@value!=''">
												<SupplierBatchID>
													<xsl:value-of select="$lin/lin/element[@name='B8']/@value"/>
												</SupplierBatchID>
											</xsl:if>
										</Batch>
									</xsl:if>
									<xsl:for-each select="G_SLN">
										<xsl:variable name="sublin">
											<xsl:call-template name="createLIN">
												<xsl:with-param name="LIN" select="S_SLN"/>
											</xsl:call-template>
										</xsl:variable>
										<ComponentConsumptionDetails>
											<xsl:if test="S_SLN/D_350 !=''">
												<xsl:attribute name="lineNumber">
													<xsl:value-of select="S_SLN/D_350"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="quantity">
												<xsl:value-of select="normalize-space(S_SLN/D_380)"/>
											</xsl:attribute>
											<xsl:if test="$sublin/lin/element[@name='VP']/@value!='' or $sublin/lin/element[@name='VS']/@value!='' or $sublin/lin/element[@name='BP']/@value!=''">
												<Product>
													<xsl:if test="$sublin/lin/element[@name='VP']/@value!=''">
														<SupplierPartID>
															<xsl:value-of select="$sublin/lin/element[@name='VP']/@value"/>
														</SupplierPartID>
													</xsl:if>
													<xsl:if test="$sublin/lin/element[@name='VS']/@value!=''">
														<SupplierPartAuxiliaryID>
															<xsl:value-of select="$sublin/lin/element[@name='VS']/@value"/>
														</SupplierPartAuxiliaryID>
													</xsl:if>
													<xsl:if test="$sublin/lin/element[@name='BP']/@value!=''">
														<BuyerPartID>
															<xsl:value-of select="$sublin/lin/element[@name='BP']/@value"/>
														</BuyerPartID>
													</xsl:if>
												</Product>
											</xsl:if>
											<UnitOfMeasure>
												<xsl:variable name="uom" select="S_SLN/C_C001/D_355"/>
												<xsl:choose>
													<xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom]/CXMLCode!=''">
														<xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[X12Code=$uom][1]/CXMLCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$uom"/>
													</xsl:otherwise>
												</xsl:choose>
											</UnitOfMeasure>
											<!-- IG-32674 -->
											<xsl:if test="$sublin/lin/element[@name='LT']/@value!=''">
												<BuyerBatchID>
													<xsl:value-of select="$sublin/lin/element[@name='LT']/@value"/>
												</BuyerBatchID>
											</xsl:if>
											<xsl:if test="$sublin/lin/element[@name='B8']/@value!=''">
												<SupplierBatchID>
													<xsl:value-of select="$sublin/lin/element[@name='B8']/@value"/>
												</SupplierBatchID>
											</xsl:if>
											<xsl:if test="G_PID">
												<ReferenceDocumentInfo>
													<xsl:if test="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='Status']/D_352 !=''">
														<xsl:attribute name="status">
															<xsl:value-of select="lower-case(G_PID/S_PID[D_349='F'][D_750='PR'][D_751='Status']/D_352)"/>
														</xsl:attribute>
													</xsl:if>
													<DocumentInfo>
														<xsl:if test="../../S_REF[D_128='PO']">
															<xsl:attribute name="documentType">
																<xsl:text>productionOrder</xsl:text>
															</xsl:attribute>
														</xsl:if>
														<xsl:if test="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='Date']/D_352 !=''">
															<xsl:variable name="ddate" select="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='Date']/D_352"/>
															<xsl:attribute name="documentDate">
																<xsl:call-template name="formatDate">
																	<xsl:with-param name="date" select="substring($ddate,1,8)"/>
																	<xsl:with-param name="time" select="substring($ddate,9,6)"/>
																	<xsl:with-param name="tzone" select="substring($ddate,15,3)"/>
																</xsl:call-template>
															</xsl:attribute>
														</xsl:if>
														<xsl:if test="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='ID']/D_352 !=''">
															<xsl:attribute name="documentID">
																<xsl:value-of select="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='ID']/D_352"/>
															</xsl:attribute>
														</xsl:if>
													</DocumentInfo>
													<xsl:if test="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='StartDate']/D_352 !=''">
														<DateInfo>
															<xsl:attribute name="type">productionStartDate</xsl:attribute>
															<xsl:attribute name="date">
																<xsl:variable name="ddate" select="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='StartDate']/D_352"/>
																<xsl:call-template name="formatDate">
																	<xsl:with-param name="date" select="substring($ddate,1,8)"/>
																	<xsl:with-param name="time" select="substring($ddate,9,6)"/>
																	<xsl:with-param name="tzone" select="substring($ddate,15,3)"/>
																</xsl:call-template>
															</xsl:attribute>
														</DateInfo>
													</xsl:if>
													<xsl:if test="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='FinishDate']/D_352">
														<DateInfo>
															<xsl:attribute name="type">productionFinishDate</xsl:attribute>
															<xsl:attribute name="date">
																<xsl:variable name="ddate" select="G_PID/S_PID[D_349='F'][D_750='PR'][D_751='FinishDate']/D_352"/>
																<xsl:call-template name="formatDate">
																	<xsl:with-param name="date" select="substring($ddate,1,8)"/>
																	<xsl:with-param name="time" select="substring($ddate,9,6)"/>
																	<xsl:with-param name="tzone" select="substring($ddate,15,3)"/>
																</xsl:call-template>
															</xsl:attribute>
														</DateInfo>
													</xsl:if>
													<Extrinsic name="timeZone">
														<xsl:text>UTC</xsl:text>
													</Extrinsic>
												</ReferenceDocumentInfo>
											</xsl:if>
										</ComponentConsumptionDetails>
									</xsl:for-each>
									<xsl:if test="S_REF[D_128='MH' and D_127='ProductionOrderID']">
										<Extrinsic name="ProductionOrder">
											<xsl:value-of select="S_REF[D_128='MH' and D_127='ProductionOrderID']/D_352"/>
										</Extrinsic>
									</xsl:if>
									<xsl:if test="S_REF[D_128='MH' and D_127='ProductionOrderStatusDate']">
										<Extrinsic name="ProductionOrderStatusDate">
											<xsl:variable name="ddate" select="S_REF[D_128='MH' and D_127='ProductionOrderStatusDate']/D_352"/>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="date" select="substring($ddate,1,8)"/>
												<xsl:with-param name="time" select="substring($ddate,9,6)"/>
												<xsl:with-param name="tzone" select="substring($ddate,15,3)"/>
											</xsl:call-template>
										</Extrinsic>
									</xsl:if>
									<xsl:if test="S_PID[D_349='F']/D_352">
										<Extrinsic name="productDescription">
											<xsl:value-of select="S_PID[D_349='F']/D_352"/>
										</Extrinsic>
									</xsl:if>
								</ComponentConsumptionItem>
							</xsl:for-each>
						</ComponentConsumptionPortion>
					</xsl:for-each>
				</ComponentConsumptionRequest>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:param name="time"/>
		<xsl:param name="tzone"/>

		<xsl:variable name="Date" select="$date"/>
		<xsl:variable name="Time" select="$time"/>
		<xsl:variable name="TimeCode" select="$tzone"/>

		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode!=''">
					<xsl:value-of select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode,'P','+'),'M','-')"/>
				</xsl:when>
				<xsl:when test="$anSenderDefaultTimeZone!=''">
					<xsl:value-of select="$anSenderDefaultTimeZone"/>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="temDate">
			<xsl:value-of select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"/>
		</xsl:variable>
		<xsl:variable name="tempTime">
			<xsl:choose>
				<xsl:when test="$Time!='' and string-length($Time)=6">
					<xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"/>
				</xsl:when>
				<xsl:when test="$Time!='' and string-length($Time)=4">
					<xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
				</xsl:when>
				<xsl:otherwise>T12:00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($temDate,$tempTime,$timeZone)"/>
	</xsl:template>

	<xsl:template name="createParty">
		<xsl:variable name="Crole" select="N101/code"/>
		<xsl:variable name="getPartyrole">
			<xsl:choose>
				<xsl:when test="$Lookup/Lookups/Roles/Role[X12Code=$Crole]/CXMLCode!=''">
					<xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code=$Crole]/CXMLCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<Contact>
			<xsl:attribute name="role">
				<xsl:value-of select="$getPartyrole"/>
			</xsl:attribute>
			<xsl:attribute name="addressID">
				<xsl:value-of select="N104"/>
			</xsl:attribute>
			<xsl:attribute name="addressIDDomain">
				<xsl:value-of select="normalize-space(N103)"/>
			</xsl:attribute>
			<Name>
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="$getPartyrole"/>
				</xsl:attribute>
				<xsl:value-of select="concat(N201[1],N202[1],N201[2],N202[2])"/>
			</Name>
			<PostalAddress>
				<xsl:for-each select="N3">
					<xsl:if test="N301">
						<Street>
							<xsl:value-of select="N301"/>
						</Street>
					</xsl:if>
					<xsl:if test="N302">
						<Street>
							<xsl:value-of select="N302"/>
						</Street>
					</xsl:if>
				</xsl:for-each>
				<City>
					<xsl:value-of select="N4/N401"/>
				</City>
				<State>
					<xsl:value-of select="normalize-space(N4/N402)"/>
				</State>
				<PostalCode>
					<xsl:value-of select="normalize-space(N4/N403)"/>
				</PostalCode>
				<Country>
					<xsl:attribute name="isoCountryCode">
						<xsl:value-of select="normalize-space(N4/N404)"/>
					</xsl:attribute>
				</Country>
			</PostalAddress>
			<xsl:if test="PER">
				<xsl:if test="PER/PER03='EM' and PER/PER04!=''">
					<Email name="">
						<xsl:value-of select="PER/PER04"/>
					</Email>
				</xsl:if>
				<xsl:if test="PER/PER05='TE' and PER/PER06!=''">
					<Phone>
						<xsl:attribute name="name">
							<xsl:value-of select="PER/PER02"/>
						</xsl:attribute>
						<TelephoneNumber>
							<CountryCode>
								<xsl:attribute name="isoCountryCode">
								</xsl:attribute>
							</CountryCode>
							<AreaOrCityCode/>
							<Number>
								<xsl:value-of select="PER/PER06"/>
							</Number>
							<Extension/>
						</TelephoneNumber>
					</Phone>
				</xsl:if>
				<xsl:if test="PER/PER09!=''">
					<Fax name="work">
						<TelephoneNumber>
							<CountryCode>
								<xsl:attribute name="isoCountryCode">
								</xsl:attribute>
							</CountryCode>
							<AreaOrCityCode/>
							<Number>
								<xsl:value-of select="PER/PER09"/>
							</Number>
							<Extension/>
						</TelephoneNumber>
					</Fax>
				</xsl:if>
			</xsl:if>
			<xsl:if test="REF">
				<xsl:for-each select="REF">
					<IdReference>
						<xsl:variable name="getdomainval">
							<xsl:choose>
								<xsl:when test="REF01/code='ZZ'">
									<xsl:value-of select="REF02"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="REF01/code"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="domain">
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[X12Code=$getdomainval]/CXMLCode!=''">
									<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[X12Code=$getdomainval]/CXMLCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text></xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="identifier">
							<xsl:value-of select="REF03"/>
						</xsl:attribute>
					</IdReference>
				</xsl:for-each>
			</xsl:if>
		</Contact>
	</xsl:template>
	<xsl:template name="createLIN">
		<xsl:param name="LIN"/>
		<lin>
			<xsl:for-each select="$LIN/*[starts-with(name(),'D_23')]">
				<xsl:if test="starts-with(name(),'D_235')">
					<element>
						<xsl:attribute name="name">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="following-sibling::*[name() = replace(name(),'D_235','D_234')][1]"/>
						</xsl:attribute>
					</element>
				</xsl:if>
			</xsl:for-each>
		</lin>
	</xsl:template>

	<xsl:template name="convertToAribaDatePORef">
		<xsl:param name="Date"/>
		<xsl:param name="Time"/>
		<xsl:param name="TimeCode"/>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode!=''">
					<xsl:value-of select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode,'P','+'),'M','-')"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tempDate">
			<xsl:value-of select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"/>
		</xsl:variable>
		<xsl:variable name="tempTime">
			<xsl:choose>
				<xsl:when test="$Time!='' and string-length($Time)=6">
					<xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"/>
				</xsl:when>
				<xsl:when test="$Time!='' and string-length($Time)=4">
					<xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2))"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$tempTime=''">
				<xsl:value-of select="''"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($tempDate,$tempTime,$timeZone)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
