<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSenderDefaultTimeZone"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>
	<xsl:template match="/">
		<xsl:variable name="BODID" select="concat(NotifyInventoryConsumption/ApplicationArea/BODID, '')"/>
		<xsl:variable name="documentid" select="concat(NotifyInventoryConsumption/ApplicationArea/BODID, '')"/>
		<xsl:variable name="CreationDateTime" select="concat(NotifyInventoryConsumption/ApplicationArea/CreationDateTime, '')"/>
		<xsl:variable name="messageType">
			<xsl:choose>
				<xsl:when test="translate(NotifyInventoryConsumption/ApplicationArea/Sender/ComponentID, $upperAlpha, $lowerAlpha) = 'consumption'">
					<xsl:text>Consumption</xsl:text>
				</xsl:when>
				<xsl:when test="translate(NotifyInventoryConsumption/ApplicationArea/Sender/ComponentID, $upperAlpha, $lowerAlpha) = 'manufacturing'">
					<xsl:text>Manufacturing</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(NotifyInventoryConsumption/ApplicationArea/Sender/ComponentID, '')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cXML>
			<xsl:attribute name="timestamp">
				<xsl:value-of select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)" />
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
					<xsl:when test="$anEnvName = 'PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<ComponentConsumptionRequest>
					<ComponentConsumptionHeader>
						<xsl:attribute name="consumptionID">
							<xsl:value-of select="$BODID"/>
						</xsl:attribute>
						<xsl:attribute name="creationDate">
							<xsl:value-of select="$CreationDateTime"/>
						</xsl:attribute>
						<xsl:attribute name="operation">
							<xsl:text>new</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="referenceDocumentID">
							<xsl:value-of select="NotifyInventoryConsumption/ApplicationArea/UserArea/ReferenceID" />
						</xsl:attribute>
						<Extrinsic name="Message Type">
							<xsl:value-of select="$messageType"/>
						</Extrinsic>
					</ComponentConsumptionHeader>
					<xsl:for-each select="NotifyInventoryConsumption/DataArea/InventoryConsumption">
						<ComponentConsumptionPortion>
							<OrderReference>
								<xsl:attribute name="orderID">
									<xsl:value-of select="InventoryConsumptionHeader/DocumentID/ID" />
								</xsl:attribute>
								<DocumentReference>
									<xsl:attribute name="payloadID">
										<xsl:value-of select="InventoryConsumptionHeader/DocumentReference/ID" />
									</xsl:attribute>
								</DocumentReference>
							</OrderReference>
							<xsl:for-each select="InventoryConsumptionLine">
								<ComponentConsumptionItem>
									<xsl:attribute name="poLineNumber">
										<xsl:value-of select="LineNumber"/>
									</xsl:attribute>
									<xsl:if test="ShipUnitQuantity">
										<xsl:attribute name="quantity">
											<xsl:value-of select="ShipUnitQuantity"/>
										</xsl:attribute>
									</xsl:if>
									<ItemID>
										<SupplierPartID>
											<xsl:value-of select="Item/ItemID[@agencyRole = 'VendorPartNumber']/ID" />
										</SupplierPartID>
										<BuyerPartID>
											<xsl:value-of select="Item/ItemID[@agencyRole = 'MSPartNumber']/ID" />
										</BuyerPartID>
									</ItemID>
									<xsl:for-each select="DocumentReference">
										<ComponentConsumptionDetails>
											<xsl:if test="Status/Code[@name = 'consumptionLineNumber'] != ''">
												<xsl:attribute name="lineNumber">
													<xsl:value-of select="Status/Code[@name = 'consumptionLineNumber']" />
												</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="quantity">
												<xsl:value-of select="UserArea/Quantity"/>
											</xsl:attribute>
											<Product>
												<SupplierPartID>
													<xsl:value-of select="ItemIDs/ItemID[@agencyRole = 'VendorPartNumber']/ID" />
												</SupplierPartID>
												<BuyerPartID>
													<xsl:value-of select="ItemIDs/ItemID[@agencyRole = 'MSPartNumber']/ID" />
												</BuyerPartID>
												<xsl:if test="Status/Code[@name = 'PartType'] != ''">
													<IdReference>
														<xsl:attribute name="domain">PartType</xsl:attribute>
														<xsl:attribute name="identifier">
															<xsl:value-of select="Status/Code[@name = 'PartType']"/>
														</xsl:attribute>
													</IdReference>
												</xsl:if>
												<xsl:if test="Status/Description[@type = 'AssemblyPartID'] != ''">
													<IdReference>
														<xsl:attribute name="domain">AssemblyPartID</xsl:attribute>
														<xsl:attribute name="identifier">
															<xsl:value-of select="Status/Description[@type = 'AssemblyPartID']" />
														</xsl:attribute>
													</IdReference>
												</xsl:if>
											</Product>
											<UnitOfMeasure>
												<xsl:choose>
													<xsl:when test="UserArea/UnitCode!=''">
														<xsl:value-of select="UserArea/UnitCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="UserArea/Quantity/@unitCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</UnitOfMeasure>
											<xsl:if test="ItemIDs/ItemID[@agencyRole = 'BuyerBatchPartNumber']/ID != ''">
												<BuyerBatchID>
													<xsl:value-of select="ItemIDs/ItemID[@agencyRole = 'BuyerBatchPartNumber']/ID" />
												</BuyerBatchID>
											</xsl:if>
											<xsl:if test="$messageType != 'Consumption'">
												<ReferenceDocumentInfo>
													<xsl:attribute name="status">
														<xsl:value-of select="translate(Status/Code[@name = 'status'], $upperAlpha, $lowerAlpha)" />
													</xsl:attribute>
													<DocumentInfo>
														<xsl:attribute name="documentID">
															<xsl:value-of select="DocumentID/ID"/>
														</xsl:attribute>
														<xsl:attribute name="documentType">
															<xsl:text>productionOrder</xsl:text>
														</xsl:attribute>
														<xsl:if test="DocumentDateTime != ''">
															<xsl:attribute name="documentDate">
																<xsl:value-of select="DocumentDateTime"/>
															</xsl:attribute>
														</xsl:if>
													</DocumentInfo>
													<DateInfo>
														<xsl:attribute name="type">productionStartDate</xsl:attribute>
														<xsl:attribute name="date">
															<xsl:value-of select="Status[Code = 'productionStartDate']/EffectiveDateTime" />
														</xsl:attribute>
													</DateInfo>
													<DateInfo>
														<xsl:attribute name="type">productionFinishDate</xsl:attribute>
														<xsl:attribute name="date">
															<xsl:value-of select="Status[Code = 'productionFinishDate']/EffectiveDateTime" />
														</xsl:attribute>
													</DateInfo>
												</ReferenceDocumentInfo>
											</xsl:if>
										</ComponentConsumptionDetails>
									</xsl:for-each>
									<xsl:if test="$messageType != 'Consumption'">
										<Extrinsic name="ProductionOrder">
											<xsl:value-of select="UserArea/Status/Code[@name = 'ProductionOrder']" />
										</Extrinsic>
										<Extrinsic name="ProductionOrderStatusDate">
											<xsl:value-of select="UserArea/Status[Code = 'ProductionOrderStatusDate']/EffectiveDateTime" />
										</Extrinsic>
										<Extrinsic name="productDescription">
											<xsl:value-of select="Item/Description"/>
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
</xsl:stylesheet>
