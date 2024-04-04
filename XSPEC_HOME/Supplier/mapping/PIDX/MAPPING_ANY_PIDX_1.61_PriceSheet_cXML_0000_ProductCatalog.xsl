<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hci="http://sap.com/it/" xmlns:pidx="http://www.pidx.org/schemas/v1.61">

	<xsl:param name="exchange"/>
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

	<!--
		Developer: Kishore
		Date: 08/04/2020
		Description: To transform PIDX PriceSheet to Product Catalog.
	-->
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anMaskANID" select="'_CIGSDRID_'"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="cxmlversion"/>
	<xsl:param name="anContentID"/>
	<xsl:param name="notifyEmail"/>
	<xsl:param name="anSenderDefaultTimeZone"/>

	<xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_PIDX_1.61.xml')"/>

	<xsl:template match="/">
		<xsl:variable name="timestamp">
			<xsl:value-of
				select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"
			/>
		</xsl:variable>
		<xsl:variable name="operationType">
			<xsl:choose>
				<xsl:when test="/pidx:PriceSheet/@pidx:transactionPurposeIndicator = 'Original'">new</xsl:when>
				<xsl:when test="/pidx:PriceSheet/@pidx:transactionPurposeIndicator = 'Replace'">update</xsl:when>
				<xsl:when test="/pidx:PriceSheet/@pidx:transactionPurposeIndicator = 'Delete'">delete</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="payloadID">
			<xsl:value-of select="concat($anPayloadID, $anMaskANID, $anBuyerANID)"/>
		</xsl:variable>

		<xsl:variable name="catalogName" select="concat(/pidx:PriceSheet/pidx:PriceSheetInformation/pidx:PriceSheetName,'.cif')"/>
		<xsl:variable name="cifContentID" select="concat('cid:', $anPayloadID)"/>

		<!-- Document Standard -->
		<xsl:variable name="cXMLEnvelopeHeader">
			<xsl:value-of
				select="concat('&lt;cXML payloadID=&quot;', $payloadID, '&quot; timestamp=&quot;', $timestamp, '&quot; version=&quot;', $cxmlversion, '&quot; xml:lang=&quot;en-US&quot;&gt; &lt;Header&gt;&lt;From&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anSupplierANID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/From&gt;&lt;To&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anBuyerANID, '&lt;/Identity&gt;&lt;/Credential&gt;&lt;/To&gt;&lt;Sender&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;', $anProviderANID, '&lt;/Identity&gt;&lt;SharedSecret&gt;&lt;/SharedSecret&gt;&lt;/Credential&gt;&lt;UserAgent&gt;Ariba SN Buyer Adapter&lt;/UserAgent&gt;&lt;/Sender&gt;&lt;/Header&gt;')"
			/>
		</xsl:variable>
		<xsl:variable name="cXMLEnvelopeRequest">
			<xsl:value-of
				select="concat('&lt;Request&gt; &lt;CatalogUploadRequest operation=&quot;', $operationType, '&quot;&gt; &lt;CatalogName xml:lang=&quot;en&quot;&gt;', $catalogName, '&lt;/CatalogName&gt; &lt;Description xml:lang=&quot;en&quot;&gt; Catalog version 3.0 &lt;/Description&gt; &lt;Attachment&gt;&lt;URL&gt;', $cifContentID, '&lt;/URL&gt;&lt;/Attachment&gt;')"
			/>
		</xsl:variable>
		<!-- AutoPublish -->
		<xsl:variable name="autoPublishFlag">
			<xsl:choose>
				<xsl:when test="/pidx:PriceSheet/@pidx:transactionPurposeIndicator = 'Replace'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="autoPublish"
			select="concat('&lt;AutoPublish enabled=&quot;', $autoPublishFlag, '&quot;&gt;&lt;/AutoPublish&gt;&lt;Notification&gt;&lt;Email&gt;', $notifyEmail, '&lt;/Email&gt;&lt;URLPost enabled=&quot;true&quot;/&gt;&lt;/Notification&gt;&lt;/CatalogUploadRequest&gt;&lt;/Request&gt;&lt;/cXML&gt;')"/>
		<xsl:variable name="cXMLEnvelope">
			<xsl:value-of
				select="concat($cXMLEnvelopeHeader, ' ', $cXMLEnvelopeRequest, ' ', $autoPublish)"/>
		</xsl:variable>		
		
		
		
		

		<!-- Create catalog CIF file -->
		<xsl:variable name="newLine" select="'&#xA;'"/>
		<xsl:value-of select="concat('CIF_I_V3.0', $newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('CHARSET:UTF-8', $newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('LOADMODE:F', $newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('CODEFORMAT:UNSPSC', $newLine)"/>
		<xsl:text/>
		<xsl:value-of
			select="concat('CURRENCY:', normalize-space(/pidx:PriceSheet/pidx:PriceSheetInformation/pidx:PrimaryCurrency), $newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('SUPPLIERID_DOMAIN:NETWORKID', $newLine)"/>
		<xsl:text/>
		<xsl:value-of
			select="concat('ITEMCOUNT:', count(/pidx:PriceSheet/pidx:PriceSheetDetails/pidx:PriceSheetLineItem/pidx:LineItemNumber), $newLine)"/>
		<xsl:text/>
		<xsl:value-of
			select="concat('TIMESTAMP:', substring($timestamp, 1, 10), ' ', substring($timestamp, 12, 8), $newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('UNUOM:TRUE', $newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('COMMENTS:Price Catalog', $newLine)"/>
		<xsl:text/>
		<xsl:value-of
			select="concat('FIELDNAMES:Supplier ID,Supplier Part ID,Manufacturer Part ID,Item Description,SPSC Code,Unit Price,Unit of Measure,Lead Time,Manufacturer Name,Supplier URL,Manufacturer URL,Market Price,Classification Codes,PriceUnitQuantity,MinimumQuantity,Supplier Part Auxiliary ID,Language,Currency,Expiration Date,Effective Date,IsPartial,Delete,Image,Punchout Enabled,DCID,Region,ThirdLineDescription,ThirdLinePresent,PricingRuleName,Brand,PackSize,PackQuantity,CatchWeight,AverageWeightInPounds,GTIN,UPC,PricingRules,NewReplacementItem', $newLine)"/>
		<!--<xsl:value-of
			select="concat('FIELDNAMES:Supplier ID,Supplier Part ID,Manufacturer Part ID,Item Description,SPSC Code,Unit Price,Unit of Measure,Manufacturer Name,Market Price,PriceUnitQuantity,MinimumQuantity,Supplier Part Auxiliary ID,Currency,Expiration Date,Effective Date,Delete,Image', $newLine)"/>-->
		<xsl:text/>
		<xsl:value-of select="concat('DATA', $newLine)"/>
		<xsl:text/>
		
		<xsl:for-each select="/pidx:PriceSheet/pidx:PriceSheetDetails/pidx:PriceSheetLineItem">
			<!--Supplier ID-->
			<xsl:value-of select="concat($anSupplierANID, ',')"/>
			<xsl:text/>
			<!--Supplier Part#-->
			<xsl:value-of select="concat(pidx:PartNumber,',')"/>			
			<!--MFG Part#-->	
			<xsl:value-of select="concat(pidx:ReferencePartNumber[@referencePartNumber = 'ManufacturerPartNumber'],',')"/>			
			<!--Item Description-->
			<xsl:value-of select="concat(pidx:ShortDescription,',')"/>			
			<!--SPSC code-->
			<xsl:value-of select="concat(pidx:ClassCode,',')"/>			
			<!-- unit Price -->
			<xsl:value-of select="concat(pidx:ContractPricing/pidx:ContractPrice/pidx:MonetaryAmount,',')"/>	
			<!--UOM code-->
			<xsl:value-of select="concat(pidx:UnitOfMeasureCode, ',')"/>			
			<!--Lead time (no code)-->
			<xsl:text>,</xsl:text>
			<!--MFG name-->
			<xsl:value-of select="concat(pidx:ManufacturerName,',')"/>	
			<!-- Supplier URL -->
			<xsl:text>,</xsl:text>
			<!-- Manufacturer URL -->
			<xsl:text>,</xsl:text>
			<!--MarketPrice -->
			<xsl:value-of select="concat(pidx:ListPrice/pidx:MonetaryAmount,',')"/>
			<!--Classification code-->
			<xsl:text>,</xsl:text>
			<!-- PriceUnitQuantity -->
			<xsl:value-of select="concat(pidx:PriceUnit,',')"/>
			<!-- MinimumQuantity -->
			<xsl:value-of select="concat(pidx:MinimumQuantity/pidx:Quantity,',')"/>
			<!-- Supplier Part Auxiliary ID -->
			<xsl:value-of select="concat(pidx:PartNumberExtension,',')"/>
			<!--Language-->
			<xsl:text>,</xsl:text>
			<!-- Currency -->
			<xsl:value-of select="concat(pidx:ContractPricing/pidx:ContractPrice/pidx:CurrencyCode,',')"/>
			<!-- Expiration Date -->
			<xsl:call-template name="formatDate">				
				<xsl:with-param name="DocDate"
					select="pidx:ContractPricing/pidx:EffectiveDates/pidx:ToDate"/>
			</xsl:call-template>
			<!-- Effective Date -->
			<xsl:call-template name="formatDate">				
				<xsl:with-param name="DocDate"
					select="pidx:ContractPricing/pidx:EffectiveDates/pidx:FromDate"/>
			</xsl:call-template>
			<!--isPartial-->
			<xsl:text>,</xsl:text>			
			<!-- Delete -->
			<xsl:choose>
				<xsl:when test="pidx:LineItemRequestedAction = 'Delete'">
					<xsl:text>TRUE,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>FALSE,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Image -->
			<xsl:choose>
				<xsl:when test="(pidx:Pictures/pidx:PictureFile/pidx:FileURL)[1]!=''">
					<xsl:value-of select="concat((pidx:Pictures/pidx:PictureFile/pidx:FileURL)[1],',')"/>
				</xsl:when>				
				<xsl:otherwise>
					<xsl:value-of select="concat((pidx:Pictures/pidx:PictureFile/pidx:FileName)[1],',')"/>
				</xsl:otherwise>
			</xsl:choose>	
			<!-- Punchout Enabled -->
			<xsl:text>,</xsl:text>
			<!-- DCID -->
			<xsl:text>,</xsl:text>
			<!-- Region -->
			<xsl:text>,</xsl:text>
			<!-- ThirdLineDescription -->
			<xsl:text>,</xsl:text>
			<!-- ThirdLinePresent -->
			<xsl:text>,</xsl:text>
			<!-- PricingRuleName -->
			<xsl:text>,</xsl:text>
			<!-- Brand -->
			<xsl:text>,</xsl:text>
			<!-- PackSize -->
			<xsl:text>,</xsl:text>
			
			<!-- PackQuantity -->
			<xsl:text>,</xsl:text>
			<!-- CatchWeight -->
			<xsl:text>,</xsl:text>
			<!-- AverageWeightInPounds -->
			<xsl:text>,</xsl:text>
			<!-- GTIN -->
			<xsl:text>,</xsl:text>
			<!-- UPC -->
			<xsl:text>,</xsl:text>
			
			<!-- PricingRules -->
			<xsl:text>,</xsl:text>		
			
			<xsl:value-of select="$newLine"/>
		</xsl:for-each>

		<xsl:text>ENDOFDATA</xsl:text>
	</xsl:template>

	<!-- functions -->
	<xsl:template name="formatDate">
		<xsl:param name="DocDate"/>
		<xsl:choose>
			<xsl:when test="$DocDate">
				<xsl:variable name="Time1" select="substring($DocDate, 11)"/>
				<xsl:variable name="Time">
					<xsl:choose>
						<xsl:when test="string-length($Time1) &gt; 0">
							<xsl:variable name="timezone"
								select="concat(substring-after($Time1, '+'), substring-after($Time1, '-'))"/>
							<xsl:choose>
								<xsl:when test="string-length($timezone) &gt; 0">
									<xsl:value-of select="''"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$anSenderDefaultTimeZone"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('T00:00:00', $anSenderDefaultTimeZone)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="concat($DocDate, $Time,',')"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	

	
</xsl:stylesheet>
