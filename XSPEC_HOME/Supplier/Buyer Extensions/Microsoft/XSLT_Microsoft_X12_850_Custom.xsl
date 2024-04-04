<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<!--xsl:variable name="Lookup" select="document('../X12/cXML_EDILookups_X12.xsl')"/-->
	<!-- for dynamic, reading from Partner Directory -->
	<xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_X12_4010:Binary')"/>
	<xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
	<xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//M_850/S_REF[D_127 = 'CompanyCode']">
		<!-- map value directly as per MSFT -->
		<S_REF>
			<D_128>8M</D_128>
			<D_127>
				<xsl:value-of select="D_352"/>
			</D_127>
		</S_REF>
	</xsl:template>
	<xsl:template match="//M_850/S_REF[last()]">
		<xsl:copy-of select="."/>
	   <xsl:if test="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID!=''">
			<S_FOB>
				<D_146>DF</D_146>
				<D_309>SA</D_309>
				<D_352>
					<xsl:value-of select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID"/>
				</D_352>
				<xsl:variable name="IncoCode" select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'incoTerm']"/>
				<xsl:if test="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'incoTerm'] != ''">
					<D_334>01</D_334>
					<D_335>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/IncoTermsCodes/IncoTermsCode[CXMLCode = $IncoCode]/X12Code != ''">
								<xsl:value-of select="$Lookup/Lookups/IncoTermsCodes/IncoTermsCode[CXMLCode = $IncoCode]/X12Code"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'incoTerm']"/>
							</xsl:otherwise>
						</xsl:choose>
					</D_335>
				</xsl:if>
				<D_309_2>ZZ</D_309_2>
				<D_352_2>
					<xsl:variable name="IncoDesc" select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'incoTermDesc']"/>
					<xsl:variable name="IncoDesc2" select="$Lookup/Lookups/IncoTermsCodes/IncoTermsCode[CXMLCode = $IncoCode]/Description"/>
					<xsl:choose>
						<xsl:when test="$IncoDesc != ''">
							<xsl:value-of select="$IncoDesc"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$IncoDesc2"/>
						</xsl:otherwise>
					</xsl:choose>
				</D_352_2>
			</S_FOB>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//M_850/S_ITD">
		<S_ITD>
			<xsl:copy-of select="child::*"/>
			<xsl:if test="//cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm/Discount/DiscountAmount/Money">
				<D_362>
					<xsl:value-of select="//cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm/Discount/DiscountAmount/Money"/>
				</D_362>
			</xsl:if>
			<xsl:if test="not(//cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm/Discount/DiscountPercent != '') or not(//cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm/Discount/DiscountAmount != '')">
				<D_954>
					<xsl:text>0</xsl:text>
				</D_954>
			</xsl:if>
		</S_ITD>
	</xsl:template>
	<xsl:template match="//M_850/G_N1">
		<xsl:variable name="currentN1POS" select="count(./preceding-sibling::*) + 1"/>
		<xsl:variable name="firstN1POS" select="count(//M_850/G_N1[1]/preceding-sibling::*) + 1"/>
		<xsl:if test="$currentN1POS = $firstN1POS">
		   <xsl:if test="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID!='' and //cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentType!=''">
				<G_N9>
					<S_N9>
						<D_128>ZG</D_128>
						<D_127>
							<xsl:value-of select="substring((//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID)[1], 1, 30)"/>
						</D_127>
						<D_369>
							<xsl:value-of select="(//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentType)[1]"/>
						</D_369>
						<xsl:if test="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate != ''">
							<xsl:variable name="tzone" select="substring(//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate, 20)"/>
							<xsl:variable name="time" select="translate(substring(//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate, 12, 8), ':', '')"/>
							<xsl:variable name="getX12TZone">
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone]/X12Code != ''">
										<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone]/X12Code"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$tzone"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="$getX12TZone != '' and $time != ''">
								<D_373>
									<xsl:value-of select="translate(substring-before(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate, 'T'), '-', '')"/>
								</D_373>
								<D_337>
									<xsl:value-of select="$time"/>
								</D_337>
								<D_623>
									<xsl:value-of select="$getX12TZone"/>
								</D_623>
							</xsl:if>
						</xsl:if>
						<xsl:call-template name="buildN9Segment">
							<xsl:with-param name="code1" select="'DJ'"/>
							<xsl:with-param name="code2" select="'8X'"/>
							<xsl:with-param name="code3" select="'X8'"/>
							<xsl:with-param name="val1" select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'deliveryNoteNumber']"/>
							<xsl:with-param name="val2" select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'customerOrderNo']"/>
							<xsl:with-param name="val3" select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'customerReferenceNo']"/>
						</xsl:call-template>
					</S_N9>
					<xsl:for-each select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DocumentInfo/DateInfo">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="cXMLDate" select="@date"/>
							<xsl:with-param name="D374_QualDesc" select="@type"/>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each select="//cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ReferenceDocumentInfo/DateInfo[@type = 'expectedDeliveryDate']/Extrinsic">
						<xsl:if test="contains(@name, 'date')">
							<xsl:call-template name="createDTM">
								<xsl:with-param name="cXMLDate" select="."/>
								<xsl:with-param name="D374_QualDesc" select="@name"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</G_N9>
			</xsl:if>
			<!-- Fix for IG-27304 -->
			<xsl:for-each select="//cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'VasH' and @identifier!='']">
				<G_N9>
					<S_N9>
						<D_128>ZZ</D_128>
						<D_127>VAS</D_127>
						<D_369>
							<xsl:value-of select="substring(./Description, 1, 45)"/>
						</D_369>
					</S_N9>
					<S_MSG>
						<D_933>
							<xsl:value-of select="./@identifier"/>
						</D_933>
					</S_MSG>
				</G_N9>
			</xsl:for-each>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="./S_REF">
				<xsl:choose>
					<xsl:when test="S_N1/D_98 = 'BT'">
						<xsl:call-template name="rebuildN1">
							<xsl:with-param name="segment" select="."/>
							<xsl:with-param name="party" select="//cXML/Request/OrderRequest/OrderRequestHeader/BillTo"/>
							<xsl:with-param name="role" select="'BT'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="S_N1/D_98 = 'ST'">
						<xsl:call-template name="rebuildN1">
							<xsl:with-param name="segment" select="."/>
							<xsl:with-param name="party" select="//cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"/>
							<xsl:with-param name="role" select="'ST'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="S_N1/D_66 != ''">
						<xsl:call-template name="rebuildN1">
							<xsl:with-param name="segment" select="."/>
							<xsl:with-param name="party" select="//cXML/Request/OrderRequest/OrderRequestHeader/Contact[@addressID = S_N1/D_66]"/>
							<xsl:with-param name="role" select="S_N1/D_98"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="./S_PER">
				<G_N1>
					<xsl:copy-of select="./S_PER/preceding-sibling::*"/>
					<xsl:call-template name="rebuildPER">
						<xsl:with-param name="segment" select="S_PER"/>
					</xsl:call-template>
					<xsl:copy-of select="./S_PER/following-sibling::*"/>
				</G_N1>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="//M_850/G_PO1">
		<G_PO1>
			<xsl:variable name="pos1" select="S_PO1/D_350"/>
			<xsl:copy-of select="S_PO1"/>
			<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic or //cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/@planningType != ''">
				<xsl:call-template name="buildLINSeg">
					<xsl:with-param name="code1" select="'MW'"/>
					<xsl:with-param name="code2" select="'TP'"/>
					<xsl:with-param name="code3" select="'CG'"/>
					<xsl:with-param name="code4" select="'DR'"/>
					<xsl:with-param name="code5" select="'MN'"/>
					<xsl:with-param name="code6" select="'D4'"/>
					<xsl:with-param name="val1" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'productHierarchy']"/>
					<xsl:with-param name="val2" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'productDivision']"/>
					<xsl:with-param name="val3" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'productGrouping']"/>
					<xsl:with-param name="val4" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'productVersion']"/>
					<xsl:with-param name="val5" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'productModule']"/>
					<xsl:with-param name="val6" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/@planningType"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:copy-of select="S_PO1/following-sibling::* intersect S_REF[1]/preceding-sibling::*"/>
			<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[@domain = 'Serial ID']/@value != ''">
				<S_REF>
					<D_128>SE</D_128>
					<D_127>
						<xsl:value-of select="substring(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[@domain = 'Serial ID']/@value, 1, 30)"/>
					</D_127>
				</S_REF>
			</xsl:if>
			<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[@domain = 'ProductMaterial']/@value != ''">
				<S_REF>
					<D_128>SE</D_128>
					<D_127>
						<xsl:value-of select="substring(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[@domain = 'ProductMaterial']/@value, 1, 30)"/>
					</D_127>
				</S_REF>
			</xsl:if>
			<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/Extrinsic[@name = 'shippingNoteNumber']">
				<S_REF>
					<D_128>AG</D_128>
					<D_127>
						<xsl:text>shippingNoteNumber</xsl:text>
					</D_127>
					<D_352>
						<xsl:value-of select="substring(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/Extrinsic[@name = 'shippingNoteNumber']/text(), 1, 30)"/>
					</D_352>
				</S_REF>
			</xsl:if>
			<xsl:for-each select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic">
				<xsl:if test="@domain != 'Serial ID' and @domain != 'ProductMaterial'">
					<S_REF>
						<D_128>ZZ</D_128>
						<D_127>
							<xsl:value-of select="translate(@domain, $upperAlpha, $lowerAlpha)"/>
						</D_127>
						<D_352>
							<xsl:value-of select="substring(@value, 1, 30)"/>
						</D_352>
					</S_REF>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'salesCurrency'] != ''">
				<S_REF>
					<D_128>ZZ</D_128>
					<D_127>
						<xsl:text>salesCurrency</xsl:text>
					</D_127>
					<D_352>
						<xsl:value-of select="substring(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'salesCurrency'], 1, 30)"/>
					</D_352>
					<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID">
						<C_C040>
							<D_128>ZG</D_128>
							<D_127>
								<xsl:value-of select="substring((//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID)[1], 1, 30)"/>
							</D_127>
						</C_C040>
					</xsl:if>
				</S_REF>
			</xsl:if>
			<xsl:copy-of select="S_REF[1]"/>
			<xsl:copy-of select="S_REF[1]/following-sibling::* intersect S_DTM[last()]/preceding-sibling::*"/>
			<xsl:copy-of select="S_DTM[last()]"/>
			<xsl:copy-of select="G_N1/S_TD5"/>
			<xsl:copy-of select="G_N1/S_TD4"/>
			<xsl:copy-of select="S_DTM[last()]/following-sibling::* intersect G_N1[1]/preceding-sibling::*"/>
			<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo">
				<G_N9>
					<S_N9>
						<D_128>ZG</D_128>
						<D_127>
							<xsl:value-of select="substring((//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID)[1], 1, 30)"/>
						</D_127>
						<D_369>
							<xsl:value-of select="(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentType)[1]"/>
						</D_369>
						<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate != ''">
							<xsl:variable name="tzone" select="substring(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate, 20)"/>
							<xsl:variable name="time" select="translate(substring(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate, 12, 8), ':', '')"/>
							<xsl:variable name="getX12TZone">
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone]/X12Code != ''">
										<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone]/X12Code"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$tzone"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="$getX12TZone != '' and $time != ''">
								<D_373>
									<xsl:value-of select="translate(substring-before(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate, 'T'), '-', '')"/>
								</D_373>
								<D_337>
									<xsl:value-of select="$time"/>
								</D_337>
								<D_623>
									<xsl:value-of select="$getX12TZone"/>
								</D_623>
							</xsl:if>
						</xsl:if>
						<xsl:call-template name="buildN9Segment">
							<xsl:with-param name="code1" select="'DJ'"/>
							<xsl:with-param name="code2" select="'8X'"/>
							<xsl:with-param name="code3" select="'X8'"/>
							<xsl:with-param name="val1" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'deliveryNoteNumber']"/>
							<xsl:with-param name="val2" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'customerReferenceNo']"/>
							<xsl:with-param name="val3" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'customerOrderNo']"/>
						</xsl:call-template>
					</S_N9>
					<xsl:for-each select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/DateInfo">
						<xsl:call-template name="createDTM">
							<xsl:with-param name="cXMLDate" select="@date"/>
							<xsl:with-param name="D374_QualDesc" select="@type"/>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DateInfo[@type = 'expectedDeliveryDate']/Extrinsic">
						<xsl:if test="contains(@name, 'date')">
							<xsl:call-template name="createDTM">
								<xsl:with-param name="cXMLDate" select="."/>
								<xsl:with-param name="D374_QualDesc" select="@name"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'TaxRegistrationNumber'] != ''">
						<S_MSG>
							<D_933>
								<xsl:value-of select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'TaxRegistrationNumber']"/>
							</D_933>
						</S_MSG>
					</xsl:if>
				</G_N9>
				<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'launchFlag'] or //cXML/Request/OrderRequest/ItemOut/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'scheduleRefNo'] or //cXML/Request/OrderRequest/ItemOut/ItemOutIndustry/ReferenceDocumentInfo/@lineNumber">
					<xsl:for-each select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo">
						<G_N9>
							<S_N9>
								<D_128>ZG</D_128>
								<D_127>
									<xsl:value-of select="substring(DocumentInfo/@documentID, 1, 30)"/>
								</D_127>
								<D_369>
									<xsl:value-of select="DocumentInfo/@documentType"/>
								</D_369>
								<xsl:if test="DocumentInfo/@documentDate != ''">
									<xsl:variable name="tzone" select="substring(DocumentInfo/@documentDate, 20)"/>
									<xsl:variable name="time" select="translate(substring(DocumentInfo/@documentDate, 12, 8), ':', '')"/>
									<xsl:variable name="getX12TZone">
										<xsl:choose>
											<xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone]/X12Code != ''">
												<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone]/X12Code"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$tzone"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:if test="$getX12TZone != '' and $time != ''">
										<D_373>
											<xsl:value-of select="translate(substring-before(DocumentInfo/@documentDate, 'T'), '-', '')"/>
										</D_373>
										<D_337>
											<xsl:value-of select="$time"/>
										</D_337>
										<D_623>
											<xsl:value-of select="$getX12TZone"/>
										</D_623>
									</xsl:if>
								</xsl:if>
								<xsl:call-template name="buildN9Segment">
									<xsl:with-param name="code1" select="'T4'"/>
									<xsl:with-param name="code2" select="'83'"/>
									<xsl:with-param name="code3" select="'72'"/>
									<xsl:with-param name="val1" select="Extrinsic[@name = 'launchFlag']"/>
									<xsl:with-param name="val2" select="@lineNumber"/>
									<xsl:with-param name="val3" select="Extrinsic[@name = 'scheduleRefNo']"/>
								</xsl:call-template>
							</S_N9>
						</G_N9>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'tenantID']">
					<G_N9>
						<S_N9>
							<D_128>ZB</D_128>
							<D_127>
								<xsl:value-of select="substring((//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentID)[1], 1, 30)"/>
							</D_127>
							<D_369>
								<xsl:text>tenantInfo</xsl:text>
							</D_369>
							<xsl:call-template name="buildN9Segment">
								<xsl:with-param name="code1" select="'ZZ'"/>
								<xsl:with-param name="code2" select="'ZZ'"/>
								<xsl:with-param name="code3" select="'ZZ'"/>
								<xsl:with-param name="val1" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'tenantID']"/>
								<xsl:with-param name="val2" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'tenantCountry']"/>
								<xsl:with-param name="val3" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemOutIndustry/ReferenceDocumentInfo/Extrinsic[@name = 'tenantLocale']"/>
							</xsl:call-template>
						</S_N9>
					</G_N9>
				</xsl:if>
			</xsl:if>
			<!-- Fix for IG-27304 -->
			<xsl:for-each select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ItemID/IdReference[(@domain = 'VasH' or @domain = 'VasL') and @identifier!='']">
				<G_N9>
					<S_N9>
						<D_128>ZZ</D_128>
						<D_127>VAS</D_127>
						<D_369>
							<xsl:value-of select="substring(./Description, 1, 45)"/>
						</D_369>
					</S_N9>
					<S_MSG>
						<D_933>
							<xsl:value-of select="./@identifier"/>
						</D_933>
					</S_MSG>
				</G_N9>
			</xsl:for-each>
			<xsl:for-each select="G_N1">
				<xsl:choose>
					<xsl:when test="./S_REF">
						<xsl:choose>
							<xsl:when test="S_N1/D_98 = 'ST'">
								<xsl:call-template name="rebuildN1">
									<xsl:with-param name="segment" select="."/>
									<xsl:with-param name="party" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/ShipTo"/>
									<xsl:with-param name="role" select="'ST'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="S_N1/D_66 != ''">
								<xsl:call-template name="rebuildN1">
									<xsl:with-param name="segment" select="."/>
									<xsl:with-param name="party" select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $pos1]/Contact[@addressID = S_N1/D_66]"/>
									<xsl:with-param name="role" select="S_N1/D_98"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./S_PER">
						<G_N1>
							<xsl:copy-of select="./S_PER/preceding-sibling::*"/>
							<xsl:call-template name="rebuildPER">
								<xsl:with-param name="segment" select="S_PER"/>
							</xsl:call-template>
							<xsl:copy-of select="./S_PER/following-sibling::*"/>
						</G_N1>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:copy-of select="G_N1/following-sibling::* intersect G_SLN[1]/preceding-sibling::*"/>
			<xsl:for-each select="G_SLN">
				<G_SLN>
					<xsl:apply-templates select="S_SLN"/>
					<xsl:apply-templates select="S_MSG"/>
					<xsl:call-template name="SLNDTM">
						<xsl:with-param name="rebuildDTM" select="S_DTM"/>
					</xsl:call-template>
					<!-- Fix for IG-26194 - Copy N9 segments -->
					<xsl:apply-templates select="G_N9"/>
				</G_SLN>
			</xsl:for-each>
		</G_PO1>
	</xsl:template>
	<xsl:template name="rebuildN1">
		<xsl:param name="segment"/>
		<xsl:param name="party"/>
		<xsl:param name="role"/>
		<G_N1>
			<xsl:copy-of select="./S_REF[1]/preceding-sibling::*"/>
			<xsl:for-each select="$party/IdReference">
				<xsl:variable name="domain" select="./@domain"/>
				<xsl:choose>
					<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code != ''">
						<S_REF>
							<D_128>
								<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code"/>
							</D_128>
							<D_127>
								<xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
							</D_127>
							<D_352>
								<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
							</D_352>
						</S_REF>
					</xsl:when>
					<xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code != ''">
						<S_REF>
							<D_128>
								<xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code"/>
							</D_128>
							<D_127>
								<xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
							</D_127>
							<D_352>
								<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
							</D_352>
						</S_REF>
					</xsl:when>
					<xsl:otherwise>
						<S_REF>
							<D_128>ZZ</D_128>
							<D_127>
								<xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
							</D_127>
							<D_352>
								<xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
							</D_352>
						</S_REF>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:choose>
				<xsl:when test="./S_PER">
					<xsl:call-template name="rebuildPER">
						<xsl:with-param name="segment" select="./S_PER"/>
					</xsl:call-template>
					<xsl:copy-of select="./S_PER/following-sibling::*"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="./S_REF[last()]/following-sibling::*"/>
				</xsl:otherwise>
			</xsl:choose>
		</G_N1>
	</xsl:template>
	<xsl:template name="rebuildPER">
		<xsl:param name="segment"/>
		<xsl:variable name="partyName" select="$segment/../S_N1/D_93"/>
		<S_PER>
			<D_366>
				<xsl:value-of select="$segment/D_366"/>
			</D_366>
			<D_93>
				<xsl:value-of select="$partyName"/>
			</D_93>
			<xsl:copy-of select="$segment/D_93/following-sibling::*"/>
		</S_PER>
	</xsl:template>
	<xsl:template name="SLNDTM">
		<xsl:param name="rebuildDTM"/>
		<S_DTM>
			<D_374>106</D_374>
			<D_373>
				<xsl:value-of select="$rebuildDTM/D_373"/>
			</D_373>
			<D_337>
				<xsl:value-of select="$rebuildDTM/D_337"/>
			</D_337>
			<D_623>
				<xsl:value-of select="$rebuildDTM/D_623"/>
			</D_623>
		</S_DTM>
	</xsl:template>
	<xsl:template name="buildN9Segment">
		<xsl:param name="code1"/>
		<xsl:param name="code2"/>
		<xsl:param name="code3"/>
		<xsl:param name="val1"/>
		<xsl:param name="val2"/>
		<xsl:param name="val3"/>
		<xsl:choose>
			<xsl:when test="$val1 != ''">
				<C_C040>
					<D_128>
						<xsl:value-of select="$code1"/>
					</D_128>
					<D_127>
						<xsl:value-of select="substring($val1, 1, 30)"/>
					</D_127>
					<xsl:if test="$val2 != ''">
						<D_128_2>
							<xsl:value-of select="$code2"/>
						</D_128_2>
						<D_127_2>
							<xsl:value-of select="substring($val2, 1, 30)"/>
						</D_127_2>
					</xsl:if>
					<xsl:if test="$val3 != ''">
						<D_128_3>
							<xsl:value-of select="$code3"/>
						</D_128_3>
						<D_127_3>
							<xsl:value-of select="substring($val3, 1, 30)"/>
						</D_127_3>
					</xsl:if>
				</C_C040>
			</xsl:when>
			<xsl:when test="$val2 != ''">
				<C_C040>
					<D_128>
						<xsl:value-of select="$code2"/>
					</D_128>
					<D_127>
						<xsl:value-of select="substring($val2, 1, 30)"/>
					</D_127>
					<xsl:if test="$val3 != ''">
						<D_128_2>
							<xsl:value-of select="$code3"/>
						</D_128_2>
						<D_127_2>
							<xsl:value-of select="substring($val3, 1, 30)"/>
						</D_127_2>
					</xsl:if>
				</C_C040>
			</xsl:when>
			<xsl:when test="$val3 != ''">
				<C_C040>
					<D_128>
						<xsl:value-of select="$code3"/>
					</D_128>
					<D_127>
						<xsl:value-of select="substring($val3, 1, 30)"/>
					</D_127>
				</C_C040>
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="buildLINSeg">
		<xsl:param name="code1"/>
		<xsl:param name="code2"/>
		<xsl:param name="code3"/>
		<xsl:param name="code4"/>
		<xsl:param name="code5"/>
		<xsl:param name="code6"/>
		<xsl:param name="val1"/>
		<xsl:param name="val2"/>
		<xsl:param name="val3"/>
		<xsl:param name="val4"/>
		<xsl:param name="val5"/>
		<xsl:param name="val6"/>
		<xsl:choose>
			<xsl:when test="$val1 != ''">
				<S_LIN>
					<!--D_350/-->
					<D_235>
						<xsl:value-of select="$code1"/>
					</D_235>
					<D_234>
						<xsl:value-of select="$val1"/>
					</D_234>
					<xsl:if test="$val2">
						<D_235_2>
							<xsl:value-of select="$code2"/>
						</D_235_2>
						<D_234_2>
							<xsl:value-of select="$val2"/>
						</D_234_2>
					</xsl:if>
					<xsl:if test="$val3">
						<D_235_3>
							<xsl:value-of select="$code3"/>
						</D_235_3>
						<D_234_3>
							<xsl:value-of select="$val3"/>
						</D_234_3>
					</xsl:if>
					<xsl:if test="$val4">
						<D_235_4>
							<xsl:value-of select="$code4"/>
						</D_235_4>
						<D_234_4>
							<xsl:value-of select="$val4"/>
						</D_234_4>
					</xsl:if>
					<xsl:if test="$val5">
						<D_235_5>
							<xsl:value-of select="$code5"/>
						</D_235_5>
						<D_234_5>
							<xsl:value-of select="$val5"/>
						</D_234_5>
					</xsl:if>
					<xsl:if test="$val6">
						<D_235_6>
							<xsl:value-of select="$code6"/>
						</D_235_6>
						<D_234_6>
							<xsl:value-of select="$val6"/>
						</D_234_6>
					</xsl:if>
				</S_LIN>
			</xsl:when>
			<xsl:when test="$val2 != ''">
				<S_LIN>
					<!--D_350/-->
					<D_235>
						<xsl:value-of select="$code2"/>
					</D_235>
					<D_234>
						<xsl:value-of select="$val2"/>
					</D_234>
					<xsl:if test="$val3">
						<D_235_2>
							<xsl:value-of select="$code3"/>
						</D_235_2>
						<D_234_2>
							<xsl:value-of select="$val3"/>
						</D_234_2>
					</xsl:if>
					<xsl:if test="$val4">
						<D_235_3>
							<xsl:value-of select="$code4"/>
						</D_235_3>
						<D_234_3>
							<xsl:value-of select="$val4"/>
						</D_234_3>
					</xsl:if>
					<xsl:if test="$val5">
						<D_235_4>
							<xsl:value-of select="$code5"/>
						</D_235_4>
						<D_234_4>
							<xsl:value-of select="$val5"/>
						</D_234_4>
					</xsl:if>
					<xsl:if test="$val6">
						<D_235_5>
							<xsl:value-of select="$code6"/>
						</D_235_5>
						<D_234_5>
							<xsl:value-of select="$val6"/>
						</D_234_5>
					</xsl:if>
				</S_LIN>
			</xsl:when>
			<xsl:when test="$val3 != ''">
				<S_LIN>
					<!--D_350/-->
					<D_235>
						<xsl:value-of select="$code3"/>
					</D_235>
					<D_234>
						<xsl:value-of select="$val3"/>
					</D_234>
					<xsl:if test="$val4">
						<D_235_2>
							<xsl:value-of select="$code4"/>
						</D_235_2>
						<D_234_2>
							<xsl:value-of select="$val4"/>
						</D_234_2>
					</xsl:if>
					<xsl:if test="$val5">
						<D_235_3>
							<xsl:value-of select="$code5"/>
						</D_235_3>
						<D_234_3>
							<xsl:value-of select="$val5"/>
						</D_234_3>
					</xsl:if>
					<xsl:if test="$val6">
						<D_235_4>
							<xsl:value-of select="$code6"/>
						</D_235_4>
						<D_234_4>
							<xsl:value-of select="$val6"/>
						</D_234_4>
					</xsl:if>
				</S_LIN>
			</xsl:when>
			<xsl:when test="$val4 != ''">
				<S_LIN>
					<!--D_350/-->
					<D_235>
						<xsl:value-of select="$code4"/>
					</D_235>
					<D_234>
						<xsl:value-of select="$val4"/>
					</D_234>
					<xsl:if test="$val5">
						<D_235_2>
							<xsl:value-of select="$code5"/>
						</D_235_2>
						<D_234_2>
							<xsl:value-of select="$val5"/>
						</D_234_2>
					</xsl:if>
					<xsl:if test="$val6">
						<D_235_3>
							<xsl:value-of select="$code6"/>
						</D_235_3>
						<D_234_3>
							<xsl:value-of select="$val6"/>
						</D_234_3>
					</xsl:if>
				</S_LIN>
			</xsl:when>
			<xsl:when test="$val5 != ''">
				<S_LIN>
					<!--D_350/-->
					<D_235>
						<xsl:value-of select="$code5"/>
					</D_235>
					<D_234>
						<xsl:value-of select="$val5"/>
					</D_234>
					<xsl:if test="$val6">
						<D_235_2>
							<xsl:value-of select="$code6"/>
						</D_235_2>
						<D_234_2>
							<xsl:value-of select="$val6"/>
						</D_234_2>
					</xsl:if>
				</S_LIN>
			</xsl:when>
			<xsl:when test="$val6 != ''">
				<S_LIN>
					<!--D_350/-->
					<D_235>
						<xsl:value-of select="$code6"/>
					</D_235>
					<D_234>
						<xsl:value-of select="$val6"/>
					</D_234>
				</S_LIN>
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createDTM">
		<xsl:param name="D374_Qual"/>
		<xsl:param name="D374_QualDesc"/>
		<xsl:param name="cXMLDate"/>
		<S_DTM>
			<D_374>
				<xsl:choose>
					<xsl:when test="$D374_Qual != ''">
						<xsl:value-of select="$D374_Qual"/>
					</xsl:when>
					<xsl:when test="$D374_QualDesc = 'expectedShipmentDate'">
						<xsl:text>010</xsl:text>
					</xsl:when>
					<xsl:when test="$D374_QualDesc = 'productionStartDate'">
						<xsl:text>203</xsl:text>
					</xsl:when>
					<xsl:when test="$D374_QualDesc = 'productionFinishDate'">
						<xsl:text>842</xsl:text>
					</xsl:when>
					<xsl:when test="$D374_QualDesc = 'customerDeliveryDate'">
						<xsl:text>069</xsl:text>
					</xsl:when>
					<xsl:when test="$D374_QualDesc = 'calculatedDeliveryDate'">
						<xsl:text>017</xsl:text>
					</xsl:when>
				</xsl:choose>
			</D_374>
			<D_373>
				<xsl:value-of select="replace(substring($cXMLDate, 0, 11), '-', '')"/>
			</D_373>
			<xsl:if test="replace(substring($cXMLDate, 12, 8), ':', '') != ''">
				<D_337>
					<xsl:value-of select="replace(substring($cXMLDate, 12, 8), ':', '')"/>
				</D_337>
			</xsl:if>
			<xsl:variable name="timeZone" select="replace(replace(substring($cXMLDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
			<xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
				<D_623>
					<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
				</D_623>
			</xsl:if>
		</S_DTM>
	</xsl:template>
	<!-- Extension Ends -->
	<xsl:template match="//Combined">
		<xsl:apply-templates select="@* | node()"/>
	</xsl:template>
	<xsl:template match="//target">
		<xsl:apply-templates select="@* | node()"/>
	</xsl:template>
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
