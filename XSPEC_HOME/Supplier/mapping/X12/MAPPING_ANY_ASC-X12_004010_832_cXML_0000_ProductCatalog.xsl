<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hci="http://sap.com/it/" xmlns:pidx="http://www.pidx.org/schemas/v1.61">

	<xsl:param name="exchange"/>
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

	<!--
		Developer: Rama
		Date: 04/12/2017
		Description: To transform EDI832 to Product Catalog.
	-->
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="cxmlversion"/>
	<xsl:param name="anContentID"/>
	<xsl:param name="notifyEmail"/>

	<xsl:variable name="lookups" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_X12_4010.xml')"/>
	<!--<xsl:variable name="lookups" select="document('LOOKUP_ASC-X12_004010.xml')"/>-->

	<xsl:template match="*">

		<xsl:variable name="timestamp">
			<xsl:call-template name="convertToAribaDate">
				<xsl:with-param name="dateTime">
					<xsl:value-of select="replace(replace(string(current-dateTime()),'-',''),':','')"/>
				</xsl:with-param>
				<xsl:with-param name="dateTimeFormat">
					<xsl:value-of select="304"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="operationType">
			<xsl:choose>
				<xsl:when test="FunctionalGroup/M_832/S_BCT/D_353='05'">update</xsl:when>
				<xsl:when test="FunctionalGroup/M_832/S_BCT/D_353='03'">delete</xsl:when>
				<xsl:otherwise>new</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currency">
			<xsl:choose>
				<xsl:when test="normalize-space(FunctionalGroup/M_832/S_CUR/D_100)!=''">
					<xsl:value-of select="FunctionalGroup/M_832/S_CUR/D_100"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>USD</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="catalogName" select="FunctionalGroup/M_832/S_BCT/D_352"/>
		<xsl:variable name="GS_STControl" select="FunctionalGroup/M_832/S_ST/D_329"/>
		<xsl:variable name="cifContentID" select="concat('cid:',$anContentID)"/>

		<!-- Commodities -->
		
		<!-- start IG-38889 commodityCodes and not passed to cXMLEvelopeRequest-->
		<!--<xsl:variable name="commodityCodes">
			<xsl:for-each select="FunctionalGroup/M_832/G_LIN/S_LIN[D_235_8='U3']/D_234_8[not(.=preceding&#58;&#58;D_234_8)]">
				<xsl:if test="../../S_LIN/D_235_8='U3'">	
					<xsl:variable name="cmcode" select="../../S_LIN[D_235_6='U3']/D_234_8"/>
					<xsl:value-of select="concat('&lt;CommodityCode&gt;',substring($cmcode,1,2),'&lt;/CommodityCode&gt;')"/>		
				</xsl:if>
			</xsl:for-each>			
		</xsl:variable>

		<xsl:variable name="commodities">
			<xsl:if test="$commodityCodes != ''">
				<xsl:value-of select="concat('&lt;Commodities&gt;',$commodityCodes,'&lt;/Commodities&gt;')"/>
			</xsl:if>					
		</xsl:variable> -->		
<!-- END IG-38889 -->
		
		<!-- Document Standard -->
		<xsl:variable name="cXMLEnvelopeHeader">
			<xsl:value-of select="concat('&lt;cXML payloadID=&quot;',$anPayloadID,'&quot; timestamp=&quot;',$timestamp,'&quot; version=&quot;',$cxmlversion,'&quot; xml:lang=&quot;en-US&quot;&gt; &lt;Header&gt;&lt;From&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;',$anSupplierANID,'&lt;/Identity&gt;&lt;/Credential&gt;&lt;/From&gt;&lt;To&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;',$anBuyerANID,'&lt;/Identity&gt;&lt;/Credential&gt;&lt;/To&gt;&lt;Sender&gt;&lt;Credential domain=&quot;NetworkID&quot;&gt;&lt;Identity&gt;',$anProviderANID,'&lt;/Identity&gt;&lt;SharedSecret&gt;&lt;/SharedSecret&gt;&lt;/Credential&gt;&lt;UserAgent&gt;Ariba SN Buyer Adapter&lt;/UserAgent&gt;&lt;/Sender&gt;&lt;/Header&gt;')"/>
		</xsl:variable>
		<xsl:variable name="cXMLEnvelopeRequest">
			<xsl:value-of select="concat('&lt;Request&gt; &lt;CatalogUploadRequest operation=&quot;',$operationType,'&quot;&gt; &lt;CatalogName xml:lang=&quot;en&quot;&gt;',$catalogName,'&lt;/CatalogName&gt; &lt;Description xml:lang=&quot;en&quot;&gt; Catalog version 3.0 &lt;/Description&gt; &lt;Attachment&gt;&lt;URL&gt;',$cifContentID,'&lt;/URL&gt;&lt;/Attachment&gt;')"/>
		</xsl:variable>
		<!-- AutoPublish -->
		<xsl:variable name="autoPublishFlag">
			<xsl:choose>
				<xsl:when test="FunctionalGroup/M_832/S_BCT/D_353='05'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="autoPublish"
		              select="concat('&lt;AutoPublish enabled=&quot;',$autoPublishFlag,'&quot;&gt;&lt;/AutoPublish&gt;&lt;Notification&gt;&lt;Email&gt;',$notifyEmail,'&lt;/Email&gt;&lt;URLPost enabled=&quot;true&quot;/&gt;&lt;/Notification&gt;&lt;/CatalogUploadRequest&gt;&lt;/Request&gt;&lt;/cXML&gt;')"/>
		<xsl:variable name="cXMLEnvelope">
			<xsl:value-of select="concat($cXMLEnvelopeHeader,' ',$cXMLEnvelopeRequest,' ',$autoPublish)"/>
		</xsl:variable>
		
				
		
		
		
		<!--<xsl:value-of select="concat($exchange, 'cXMLEnvelope:', $cXMLEnvelope)"/>
		<xsl:value-of select="concat($exchange, 'anAttachmentName:', $catalogName)"/>
		<xsl:value-of select="concat($exchange, 'isANAttachment:', 'YES')"/>-->

<xsl:variable name="codeFormat">
	<xsl:choose>
		<xsl:when test="FunctionalGroup/M_832/S_REF[D_128='CX']/D_127!=''">			
			<xsl:value-of select="FunctionalGroup/M_832/S_REF[D_128='CX']/D_127"/>
		</xsl:when>
		<xsl:otherwise>UNSPSC</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
		<!-- Create catalog CIF file -->
		<xsl:variable name="newLine" select="'&#xA;'"/>
		<xsl:value-of select="concat('CIF_I_V3.0',$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('CHARSET:UTF-8',$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('LOADMODE:F',$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('CODEFORMAT',':',$codeFormat,$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('CURRENCY:',$currency,$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('SUPPLIERID_DOMAIN:NETWORKID',$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('ITEMCOUNT:',count(FunctionalGroup/M_832/G_LIN),$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('TIMESTAMP:',substring($timestamp,1,10),' ',substring($timestamp,12,8),$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('UNUOM:TRUE',$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('COMMENTS:',$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('FIELDNAMES:Supplier ID,Supplier Part ID,Manufacturer Part ID,Item Description,SPSC Code,Unit Price,Unit of Measure,Lead Time,Manufacturer Name,Supplier URL,Manufacturer URL,Market Price,Classification Codes,Supplier Part Auxiliary ID,Language,Currency,Expiration Date,Effective Date,IsPartial,Delete,Image,Punchout Enabled,DCID,Region,ThirdLineDescription,ThirdLinePresent,PricingRuleName,Brand,PackSize,PackQuantity,CatchWeight,AverageWeightInPounds,GTIN,UPC,PricingRules,NewReplacementItem',$newLine)"/>
		<xsl:text/>
		<xsl:value-of select="concat('DATA',$newLine)"/>
		<xsl:text/>

		<xsl:for-each select="FunctionalGroup/M_832/G_LIN">
			<xsl:value-of select="concat($anSupplierANID,',')"/>
			<xsl:text/>
			<!--Supplier ID-->
			<xsl:value-of select="concat(S_LIN[D_235='VN']/D_234,',')"/>
			<!--Supplier Part#-->
			<xsl:choose>
				<xsl:when test="contains(S_LIN[D_235_7='MG']/D_234_7,',')">
					<xsl:value-of select="concat('&quot;',S_LIN[D_235_7='MG']/D_234_7,'&quot;,')"/>
					<!--MFG Part#-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(S_LIN[D_235_7='MG']/D_234_7,',')"/>
					<!--MFG Part#-->
				</xsl:otherwise>
			</xsl:choose>
			<!--Item Description-->
			<xsl:variable name="itemDesc">
				<xsl:for-each select="S_PID[D_349='F']">
					<xsl:value-of select="D_352" disable-output-escaping="yes"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:choose>	
				<xsl:when test="contains($itemDesc,'&#161;')">
					<xsl:variable name="replacedString">
						<xsl:call-template name="string-replace">
							<xsl:with-param name="string" select="$itemDesc"/>
							<xsl:with-param name="replace" select="'&#161;'"/>
							<xsl:with-param name="with" select="'&#161;&#161;'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="concat('&quot;',$replacedString,'&quot;')" disable-output-escaping="yes"/>
				</xsl:when>				
				<xsl:when test="starts-with($itemDesc,'&quot;') and contains(substring($itemDesc,1,string-length($itemDesc)-1),'&quot;')">
					<xsl:variable name="replacedString">
						<xsl:variable name="replacedString">
						<xsl:call-template name="string-replace">
							<xsl:with-param name="string" select="substring($itemDesc,2,string-length($itemDesc)-2)"/>
							<xsl:with-param name="replace" select="'&quot;'"/>
							<xsl:with-param name="with" select="'&quot;&quot;'"/>
						</xsl:call-template>
					</xsl:variable>
					</xsl:variable>
				</xsl:when>
				<xsl:when test="starts-with($itemDesc,'&quot;')">
					<xsl:value-of select="$itemDesc" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:when test="contains($itemDesc,'&quot;')">
					<xsl:variable name="replacedString">
						<xsl:call-template name="string-replace">
							<xsl:with-param name="string" select="$itemDesc"/>
							<xsl:with-param name="replace" select="'&quot;'"/>
							<xsl:with-param name="with" select="'&quot;&quot;'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="concat('&quot;',$replacedString,'&quot;')" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:when test="contains($itemDesc,',')">
					<xsl:value-of select="concat('&quot;',$itemDesc,'&quot;')" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$itemDesc" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

			<xsl:text></xsl:text>
			<xsl:value-of select="concat(S_LIN[D_235_8='U3']/D_234_8,',')"/>
			<!--SPSC code-->
			<xsl:choose>
				<!--Unit Price-->
				<xsl:when test="G_CTP/S_CTP/D_236='STA'">
					<xsl:value-of select="concat(G_CTP/S_CTP[D_236='STA']/D_212,',')"/>
				</xsl:when>
				<xsl:when test="G_CTP/S_CTP/D_236='UCP'">
					<xsl:value-of select="concat(G_CTP/S_CTP[D_236='UCP']/D_212,',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>0,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="uom" select="G_CTP/S_CTP/C_C001/D_355"/>
			<!--UOM code-->
			<xsl:choose>
				<xsl:when test="$lookups/Lookups/UOMCodes/UOMCode[X12Code=$uom]">
					<xsl:value-of select="concat($lookups/Lookups/UOMCodes/UOMCode[X12Code=$uom]/CXMLCode,',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(G_CTP/S_CTP/C_C001/D_355,',')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="concat(S_REF[D_128='4X']/D_127,',')"/>
			<!--Lead time-->
			<xsl:choose>
				<!--MFG name-->
				<xsl:when test="contains(S_LIN[D_235_3='MF']/D_234_3,',')">
					<xsl:value-of select="concat('&quot;',S_LIN[D_235_3='MF']/D_234_3,'&quot;,')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(S_LIN[D_235_3='MF']/D_234_3,',')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--Supplier URL-->
				<xsl:when test="contains(S_REF[D_128='URL']/D_127,',')">
					<xsl:value-of select="concat('&quot;',S_REF[D_128='URL']/D_127,'&quot;,')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(S_REF[D_128='URL']/D_127,',')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--MFG URL-->
				<xsl:when test="contains(S_REF[D_128='ZZ']/D_127,',')">
					<xsl:value-of select="concat('&quot;',S_REF[D_128='ZZ']/D_127,'&quot;,')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(S_REF[D_128='ZZ']/D_127,',')"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:text>,</xsl:text>
			<!--MarketPrice must exist but null-->
			<xsl:choose>
				<xsl:when test="S_LIN/D_235_4='CN'">
					<xsl:choose>
						<xsl:when test="contains(S_LIN[D_235_4='CN']/D_234_4,',')">
							<!--Classification code-->
							<xsl:variable name="classificationCode" select="S_LIN[D_235_4='CN']/D_234_4"/>							
							<xsl:choose>
								<xsl:when test="contains($classificationCode,'{') or contains($classificationCode,'}')">
									<xsl:value-of select="concat('&quot;', $classificationCode, '&quot;,')" disable-output-escaping="yes"/>
								</xsl:when>								
								<xsl:otherwise>
									<xsl:value-of select="concat('{',$classificationCode,'}',',')" disable-output-escaping="yes"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!--Classification code-->
							<xsl:variable name="classificationCode" select="S_LIN[D_235_4='CN']/D_234_4"/>													
							<xsl:choose>
								<xsl:when test="contains($classificationCode,'{') or contains($classificationCode,'}')">
									<xsl:value-of select="concat($classificationCode,',')" disable-output-escaping="yes"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('{',$classificationCode,'}',',')" disable-output-escaping="yes"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<!-- End test existence of LIN08(CN) for mapping LIN09-->

			<xsl:choose>
				<!--Supplier Part Auxiliary ID-->
				<xsl:when test="G_CTP/S_CTP[D_236='STA']">
					<xsl:value-of select="concat(S_REF[D_128='VR']/D_127,'BROKENITEM,')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(S_REF[D_128='VR']/D_127,G_CTP/S_CTP/C_C001/D_355,',')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>en-US,</xsl:text>
			<!--Hard-code language-->
			<!--<xsl:text>USD,</xsl:text>-->
			<xsl:value-of select=" concat($currency,',')"/>
			<!--Hard-code currency-->
			<xsl:choose>
				<!--Expiration date-->
				<xsl:when test="G_CTP/S_DTM[D_374='036']">
					<xsl:value-of select="concat(substring(G_CTP/S_DTM[D_374='036']/D_373,1,4),'-',substring(G_CTP/S_DTM[D_374='036']/D_373,5,2),'-',substring(G_CTP/S_DTM[D_374='036']/D_373,7,2),',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--Effective date-->
				<xsl:when test="G_CTP/S_DTM[D_374='007']">
					<xsl:value-of select="concat(substring(G_CTP/S_DTM[D_374='007']/D_373,1,4),'-',substring(G_CTP/S_DTM[D_374='007']/D_373,5,2),'-',substring(G_CTP/S_DTM[D_374='007']/D_373,7,2),',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--isPartial-->
				<xsl:when test="G_CTP/S_CTP[D_236='OAP']">
					<xsl:text>YES,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--Delete-->
				<xsl:when test="/FunctionalGroup/M_832/S_BCT/D_353='03'">
					<xsl:text>TRUE,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>FALSE,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--Image-->
				<xsl:when test="contains(S_REF[D_128='2S']/D_127,',')">
					<xsl:value-of select="concat('&quot;',S_REF[D_128='2S']/D_127,'&quot;,')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(S_REF[D_128='2S']/D_127,',')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!--Punchout Enabled must exist but null-->
			<xsl:value-of select="concat(S_REF[D_128='VR']/D_127,',')"/>
			<!--DCID-->
			<xsl:text>,</xsl:text>
			<!--Region must exist but null-->
			<xsl:variable name="LongDesc">
				<!--Third line Description-->
				<xsl:for-each select="S_PID[D_349='X']">
					<xsl:value-of select="S_PID[D_349='X']/D_352" disable-output-escaping="yes"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains($LongDesc,',')">
					<xsl:value-of select="concat('&quot;',$LongDesc,'&quot;')" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LongDesc" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<!--Third line present-->
				<xsl:when test="S_PID[D_349='X']">
					<xsl:text>TRUE,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="concat(S_LIN[D_235_11='C3']/D_234_11,',')"/>
			<!--PricingRuleName-->
			<xsl:choose>
				<!--Brand-->
				<xsl:when test="S_LIN[D_235_2='BL']/D_234_2!='' and contains(S_LIN[D_235_2='BL']/D_234_2,',')">
					<xsl:value-of select="concat('&quot;',S_LIN[D_235_2='BL']/D_234_2,'&quot;,')" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:when test="S_LIN[D_235_2='BL']/D_234_2!=''">
					<xsl:value-of select="concat(S_LIN[D_235_2='BL']/D_234_2,',')" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>NA,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--PackSize-->
				<xsl:when test="G_G39/S_G39/D_397!=''">
					<xsl:value-of select="concat(G_G39/S_G39/D_397,',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>NA,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="concat(G_G39/S_G39/D_356,',')"/>
			<!--PackQuantity-->
			<xsl:choose>
				<!--CatchWeight-->
				<xsl:when test="G_G39/S_G39/D_387='N'">
					<xsl:text>TRUE,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="concat(S_MEA[C_C001/D_355='LB']/D_739,',')"/>
			<!--AverageWeightInPounds-->
			<xsl:choose>
				<!--GTIN-->
				<xsl:when test="S_LIN[D_235_9='ZZ']/D_234_9!=''">
					<xsl:value-of select="concat(S_LIN[D_235_9='ZZ']/D_234_9,',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>NA,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<!--UPC-->
				<xsl:when test="S_LIN[D_235_6='UA']/D_234_6!=''">
					<xsl:value-of select="concat(S_LIN[D_235_6='UA']/D_234_6,',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>NA,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="contains(S_LIN[D_235_12='C4']/D_234_12,',')">
					<xsl:value-of select="concat(concat('&quot;','(', S_LIN[D_235_12='C4']/D_234_12,')','&quot;'),',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(S_LIN[D_235_12='C4']/D_234_12,',')"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--PricingRules-->
			<xsl:if test="S_LIN[D_235_10='RR']">
				<xsl:value-of select="S_LIN[D_235_10='RR']/D_234_10"/>
				<!--PricingRules-->
			</xsl:if>
			<xsl:value-of select="$newLine"/>
			<xsl:text/>
		</xsl:for-each>


		<xsl:text>ENDOFDATA</xsl:text>
	</xsl:template>

	<!-- functions -->
	<xsl:template name="convertToAribaDate">
		<xsl:param name="dateTime"/>
		<xsl:param name="dateTimeFormat"/>
		<xsl:variable name="dtmFormat">
			<xsl:choose>
				<xsl:when test="$dateTimeFormat!=''">
					<xsl:value-of select="$dateTimeFormat"/>
				</xsl:when>
				<xsl:otherwise>102</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tempDateTime">
			<xsl:choose>
				<xsl:when test="$dtmFormat = 102">
					<xsl:value-of select="concat($dateTime, '000000')"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 203">
					<xsl:value-of select="concat($dateTime, '00')"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 204">
					<xsl:value-of select="$dateTime"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 303">
					<xsl:value-of select="concat(substring($dateTime, 0, 12), '00', substring($dateTime, 12))"/>
				</xsl:when>
				<xsl:when test="$dtmFormat = 304">
					<xsl:value-of select="$dateTime"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$dateTimeFormat = '303' or $dateTimeFormat = '304'">
					<xsl:choose>
						<xsl:when test="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode!=''">
							<xsl:value-of select="$lookups/Lookups/TimeZones/TimeZone[EDIFACTCode = substring($tempDateTime, 15)]/CXMLCode"/>
						</xsl:when>
						<xsl:otherwise>+00:00</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat(substring($tempDateTime, 0, 5), '-', substring($tempDateTime, 5, 2), '-', substring($tempDateTime, 7, 2), 'T', substring($tempDateTime, 9, 2), ':', substring($tempDateTime, 11, 2), ':', substring($tempDateTime, 13, 2), $timeZone)"/>
	</xsl:template>

	<xsl:template name="string-replace">
		<xsl:param name="string"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
			<xsl:when test="contains($string, $replace)">
				<xsl:value-of select="substring-before($string, $replace)"/>
				<xsl:value-of select="$with"/>
				<xsl:call-template name="string-replace">
					<xsl:with-param name="string" select="substring-after($string,$replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="with" select="$with"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="EDI832_xmlString_1.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml=""
		          commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->
