<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="anAlternativeSender"/>
	<xsl:param name="anAlternativeReceiver"/>
	<xsl:param name="anDate"/>
	<xsl:param name="anTime"/>
	<xsl:param name="anICNValue"/>
	<xsl:param name="anCorrelationID"/>
	<xsl:param name="anEnvName"/>

	<xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_GUSI_2.1.xml')"/>
	<xsl:include href="FORMAT_cXML_0000_GUSI_2.1.xsl"/>

	<!--xsl:variable name="lookups" select="document('cXML_GUSI_lookup.xml')"/>
	<xsl:include href="Format_cXML_to_GUSI.xsl"/-->

	<xsl:template match="//ReceiptRequest">
		<sh:StandardBusinessDocument xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:deliver="urn:ean.ucc:deliver:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:call-template name="createGUSIHeader">
				<xsl:with-param name="version" select="'2.1'"/>
				<xsl:with-param name="type" select="'ReceivingAdvice'"/>
				<xsl:with-param name="hdrversion" select="'2.2'"/>
				<xsl:with-param name="time" select="substring(/cXML/@timestamp,1,19)"/>
			</xsl:call-template>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="$anCorrelationID"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<xsl:call-template name="createContentOwner">
						</xsl:call-template>
					</contentOwner>
				</entityIdentification>
				<eanucc:transaction>
					<entityIdentification>
						<uniqueCreatorIdentification>
							<xsl:value-of select="$anCorrelationID"/>
						</uniqueCreatorIdentification>
						<contentOwner>
							<xsl:call-template name="createContentOwner">
							</xsl:call-template>
						</contentOwner>
					</entityIdentification>
					<command>
						<eanucc:documentCommand>
							<documentCommandHeader type="ADD">
								<entityIdentification>
									<uniqueCreatorIdentification>
										<xsl:value-of select="$anCorrelationID"/>
									</uniqueCreatorIdentification>
									<contentOwner>
										<xsl:call-template name="createContentOwner">
										</xsl:call-template>
									</contentOwner>
								</entityIdentification>
							</documentCommandHeader>
							<documentCommandOperand>
								<xsl:element name="deliver:receivingAdvice">
									<xsl:attribute name="creationDateTime">
										<xsl:call-template name="formatDate">
											<xsl:with-param name="cxmlDate" select="normalize-space(ReceiptRequestHeader/@receiptDate)"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="documentStatus">
										<xsl:choose>
											<xsl:when test="normalize-space(ReceiptRequestHeader/@operation)='new'">ORIGINAL</xsl:when>
											<xsl:when test="normalize-space(ReceiptRequestHeader/@operation)='update'">REPLACE</xsl:when>
											<xsl:otherwise>ORIGINAL</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<reportingCode>CONFIRMATION</reportingCode>

									<receivingAdviceIdentification>
										<uniqueCreatorIdentification>
											<xsl:value-of select="ReceiptRequestHeader/@receiptID"/>
										</uniqueCreatorIdentification>
										<contentOwner>
											<xsl:call-template name="createContentOwner">
											</xsl:call-template>
										</contentOwner>
									</receivingAdviceIdentification>
									<xsl:if test="normalize-space(ReceiptRequestHeader/Extrinsic[@name='shipToID'])!=''">
										<shipTo>
											<xsl:call-template name="createContentOwner">
												<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(ReceiptRequestHeader/Extrinsic[@name='shipToID'])"/>
											</xsl:call-template>
										</shipTo>
									</xsl:if>
									<xsl:if test="normalize-space(ReceiptRequestHeader/Extrinsic[@name='vendorIDNo'])!=''">

										<shipper>

											<xsl:call-template name="createContentOwner">
												<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(ReceiptRequestHeader/Extrinsic[@name='vendorIDNo'])"/>
											</xsl:call-template>
										</shipper>
									</xsl:if>
									<xsl:if test="normalize-space(ReceiptRequestHeader/Extrinsic[@name='shipToID'])!=''">
										<receiver>
											<xsl:call-template name="createContentOwner">
												<xsl:with-param name="additionalPartyIdentificationValue" select="normalize-space(ReceiptRequestHeader/Extrinsic[@name='shipToID'])"/>
											</xsl:call-template>
										</receiver>
									</xsl:if>
									<xsl:for-each select="ReceiptOrder/ReceiptItem">
										<receivingAdviceItemContainmentLineItem>
											<xsl:attribute name="number">
												<xsl:value-of select="@receiptLineNumber"/>
											</xsl:attribute>
											<xsl:if test="ReceiptItemReference/ItemID/BuyerPartID!=''">
												<containedItemIdentification>
													<gtin>00000000000000</gtin>
													<additionalTradeItemIdentification>
														<additionalTradeItemIdentificationValue>
															<xsl:value-of select="ReceiptItemReference/ItemID/BuyerPartID"/>
														</additionalTradeItemIdentificationValue>
														<additionalTradeItemIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalTradeItemIdentificationType>
													</additionalTradeItemIdentification>
												</containedItemIdentification>
											</xsl:if>
											<deliveryNote>
												<xsl:attribute name="number">
													<xsl:value-of select="ReceiptItemReference/ShipNoticeLineItemReference/@shipNoticeLineNumber"/>
												</xsl:attribute>
												<reference>
													<referenceDateTime>

														<xsl:call-template name="formatDate">
															<xsl:with-param name="cxmlDate" select="ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeDate"/>
														</xsl:call-template>
													</referenceDateTime>
													<referenceIdentification>
														<xsl:value-of select="ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeID"/>
													</referenceIdentification>
												</reference>
											</deliveryNote>
											<purchaseOrder>
												<documentLineReference>
													<xsl:attribute name="number">
														<xsl:value-of select="ReceiptItemReference/@lineNumber"/>
													</xsl:attribute>
													<documentReference>
														<uniqueCreatorIdentification>
															<xsl:value-of select="../ReceiptOrderInfo/OrderReference/@orderID"/>
														</uniqueCreatorIdentification>
<contentOwner>
														<xsl:call-template name="createContentOwner">
														</xsl:call-template></contentOwner>
													</documentReference>
												</documentLineReference>
											</purchaseOrder>
											<xsl:if test="Batch/SupplierBatchID!='' or Batch/BuyerBatchID!=''">
												<extendedAttributes>
													<xsl:if test="Batch/SupplierBatchID!=''">
														<batchNumber>
															<xsl:value-of select="Batch/SupplierBatchID"/>
														</batchNumber>
													</xsl:if>
													<xsl:if test="Batch/BuyerBatchID!=''">
														<lotNumber>
															<xsl:value-of select="Batch/BuyerBatchID"/>
														</lotNumber>
													</xsl:if>
												</extendedAttributes>
											</xsl:if>
											<quantityAccepted>
												<value>
													<xsl:value-of select=".[@type='received']/@quantity"/>
												</value>
												<unitOfMeasure>
													<measurementUnitCodeValue>
														<xsl:value-of select="UnitRate/UnitOfMeasure"/>
													</measurementUnitCodeValue>
												</unitOfMeasure>
											</quantityAccepted>
											<quantityReceived>
												<value>
													<xsl:value-of select=".[@type='received']/@quantity"/>
												</value>
												<unitOfMeasure>
													<measurementUnitCodeValue>
														<xsl:value-of select="UnitRate/UnitOfMeasure"/>
													</measurementUnitCodeValue>
												</unitOfMeasure>
											</quantityReceived>
										</receivingAdviceItemContainmentLineItem>
									</xsl:for-each>
									<receiptInformation>
										<receivingDateTime>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="cxmlDate" select="ReceiptRequestHeader/@receiptDate"/>
											</xsl:call-template>
										</receivingDateTime>
									</receiptInformation>
									<billOfLadingNumber>
										<referenceDateTime>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="cxmlDate" select="(ReceiptOrder/ReceiptItem/ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeDate)[1]"/>
											</xsl:call-template>
										</referenceDateTime>
										<referenceIdentification>
											<xsl:value-of select="(ReceiptOrder/ReceiptItem/ReceiptItemReference/ShipNoticeIDInfo/@shipNoticeID)[1]"/>
										</referenceIdentification>
									</billOfLadingNumber>
								</xsl:element>
							</documentCommandOperand>
						</eanucc:documentCommand>
					</command>
				</eanucc:transaction>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>
	<xsl:template match="cXML/Header"/>
</xsl:stylesheet>
