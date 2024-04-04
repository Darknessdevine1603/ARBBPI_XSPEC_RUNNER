<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>

	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailShipNoticeInfo"/>	
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role='from']/IdReference[@domain='gstID']"/>
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role='soldTo']/IdReference[@domain='gstID']"/>	
	<!-- Extension Ends -->
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[last()]">
		<xsl:copy-of select="."/>
		<xsl:if
			test="//InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money/@alternateAmount != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">subtotalAlternateAmount</xsl:attribute>
				<xsl:value-of
					select="//InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money/@alternateAmount"
				/>
			</xsl:element>
		</xsl:if>
		<xsl:if
			test="//InvoiceDetailRequest/InvoiceDetailSummary/DueAmount/Money/@alternateAmount != ''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">dueAlternateAmount</xsl:attribute>
				<xsl:value-of
					select="//InvoiceDetailRequest/InvoiceDetailSummary/DueAmount/Money/@alternateAmount"
				/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="//InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate!=''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">taxPointDateHeader</xsl:attribute>
				<xsl:value-of
					select="//InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate"
				/>
			</xsl:element>
		</xsl:if>
		<xsl:if
			test="//InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/TaxAmount/Money/@alternateAmount!=''">
			<xsl:element name="Extrinsic">
				<xsl:attribute name="name">taxAlternateAmount</xsl:attribute>
				<xsl:value-of
					select="//InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/TaxAmount/Money/@alternateAmount"
				/>
			</xsl:element>
		</xsl:if>

	</xsl:template>
	
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailSummary/Tax[not(exists(TaxDetail/TaxableAmount))]">
		<xsl:variable name="headerAltCurr">
			<xsl:if
				test="//FunctionalGroup/M_810/S_CUR/D_98_2 = 'BY' or //FunctionalGroup/M_810/S_CUR/D_98_2 = 'SE'">
				<xsl:value-of select="//FunctionalGroup/M_810/S_CUR/D_100_2"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="isCreditMemo">
			<xsl:choose>
				<xsl:when test="//InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = 'lineLevelCreditMemo'">yes</xsl:when>
				<xsl:when test="//InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = 'creditMemo'">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="mainCurr" select="./Money/@currency"/>
		<Tax>
			<xsl:copy-of select="./TaxDetail[1]/preceding-sibling::*"/>
			<xsl:choose>
				<!-- CG: IG-23185 -->
				<xsl:when test="$headerAltCurr = ''">
					<xsl:for-each select="//FunctionalGroup/M_810/G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI">
						<xsl:call-template name="mapTaxDetail">
							<xsl:with-param name="mainCurrency" select="$mainCurr"/>
							<xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
							<xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
							<xsl:with-param name="tpDTM" select="//FunctionalGroup/M_810/S_DTM[D_374 = '983']"/>
							<xsl:with-param name="pdDTM" select="//FunctionalGroup/M_810/S_DTM[D_374 = '814']"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each-group
						select="//FunctionalGroup/M_810/G_SAC[S_SAC/D_248 = 'C'][S_SAC/D_1300 = 'H850']/S_TXI"
						group-by="D_963">
						<xsl:choose>
							<xsl:when test="count(current-group()) &gt; 1">
								<xsl:for-each select="current-group()[position() mod 2 = 1]">
									<xsl:variable name="tc" select="D_963"/>
									<xsl:variable name="altAmount" select="following-sibling::S_TXI[D_963 = $tc][1]/D_782"/>
									<xsl:call-template name="mapTaxDetail">
										<xsl:with-param name="mainCurrency" select="$mainCurr"/>
										<xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
										<xsl:with-param name="alternateAmount" select="$altAmount"/>
										<xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
										<xsl:with-param name="tpDTM" select="//FunctionalGroup/M_810/S_DTM[D_374 = '983']"/>
										<xsl:with-param name="pdDTM" select="//FunctionalGroup/M_810/S_DTM[D_374 = '814']"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="mapTaxDetail">
									<xsl:with-param name="mainCurrency" select="$mainCurr"/>
									<xsl:with-param name="alternateCurrency" select="$headerAltCurr"/>
									<xsl:with-param name="creditMemoFlag" select="$isCreditMemo"/>
									<xsl:with-param name="tpDTM" select="//FunctionalGroup/M_810/S_DTM[D_374 = '983']"/>
									<xsl:with-param name="pdDTM" select="//FunctionalGroup/M_810/S_DTM[D_374 = '814']"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each-group>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:copy-of select="./TaxDetail[last()]/following-sibling::*"/>
		</Tax>
	</xsl:template>
	
	<xsl:template name="mapTaxDetail">
		<xsl:param name="mainCurrency"/>
		<xsl:param name="alternateCurrency"/>
		<xsl:param name="creditMemoFlag"/>
		<xsl:param name="alternateAmount" required="no"/>
		<xsl:param name="ignoreTPDate" required="no"></xsl:param>
		<xsl:param name="tpDTM" required="no"/>
		<xsl:param name="pdDTM" required="no"/>
		
		<xsl:variable name="taxCategory">
			<xsl:choose>
				<xsl:when test="D_963 = 'PG' or D_963 = 'PS' or D_963 = 'ST'">
					<xsl:choose>
						<xsl:when test="contains(D_956, '.qc.ca')">
							<xsl:text>qst</xsl:text>
						</xsl:when>
						<xsl:when test="contains(D_956, '.ns.ca') or contains(D_956, '.nf.ca') or contains(D_956, '.nb.ca') or contains(D_956, '.on.ca')">
							<xsl:text>hst</xsl:text>
						</xsl:when>
						<xsl:when test="contains(D_956, '.ca')">
							<xsl:text>pst</xsl:text>
						</xsl:when>
						<xsl:when test="D_963 = 'PG' or D_963 = 'PS'">
							<xsl:text>other</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>sales</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="D_963 = 'VA'">
					<xsl:text>vat</xsl:text>
				</xsl:when>
				<xsl:when test="D_963 = 'CG' or D_963 = 'CV' or D_963 = 'GS'">
					<xsl:text>gst</xsl:text>
				</xsl:when>
				<xsl:when test="D_963 = 'LT' or D_963 = 'LS'">
					<xsl:text>sales</xsl:text>
				</xsl:when>
				<xsl:when test="D_963 = 'ZC' or D_963 = 'UT' or D_963 = 'TT' or D_963 = 'SE' or D_963 = 'FD'">
					<xsl:text>usage</xsl:text>
				</xsl:when>
				<xsl:when test="D_963 = 'FI'">
					<xsl:text>withholdingTax</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>other</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="TaxDetail">
			<xsl:attribute name="purpose">
				<xsl:text>tax</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="category">
				<xsl:value-of select="$taxCategory"/>
			</xsl:attribute>
			<xsl:if test="$taxCategory = 'withholdingTax'">
				<xsl:attribute name="isWithholdingTax">
					<xsl:text>yes</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="D_954 != ''">
				<xsl:attribute name="percentageRate">
					<xsl:value-of select="D_954"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$taxCategory = 'vat' and $ignoreTPDate != 'true'">
				<xsl:variable name="tpDate" select="$tpDTM/D_373"/>
				<xsl:variable name="tpTime" select="$tpDTM/D_337"/>
				<xsl:variable name="tpTimeCode" select="$tpDTM/D_623"/>
				<xsl:variable name="pdDate" select="$pdDTM/D_373"/>
				<xsl:variable name="pdTime" select="$pdDTM/D_337"/>
				<xsl:variable name="pdTimeCode" select="$pdDTM/D_623"/>
				
				<xsl:choose>
					<xsl:when test="$tpDate != ''">
						<xsl:attribute name="taxPointDate">
							<xsl:call-template name="convertToAribaDate">
								<xsl:with-param name="Date" select="$tpDate"/>
								<xsl:with-param name="Time" select="$tpTime"/>
								<xsl:with-param name="TimeCode" select="$tpTimeCode"/>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="string-length(D_350) = 16 or string-length(D_350) &lt; 16">
						<xsl:variable name="dt" select="concat(substring(D_350, 1, 4), '-', substring(D_350, 5, 2), '-', substring(D_350, 7, 2), 'T', substring(D_350, 9, 2), ':', substring(D_350, 11, 2), ':', substring(D_350, 13, 2))"/>
						<xsl:variable name="dt1" select="concat(substring(D_350, 1, 4), '-', substring(D_350, 5, 2), '-', substring(D_350, 7, 2))"/>
						<xsl:choose>
							<xsl:when test="$dt castable as xs:dateTime">
								<xsl:attribute name="taxPointDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="Date" select="substring(D_350, 1, 8)"/>
										<xsl:with-param name="Time" select="substring(D_350, 9, 6)"/>
										<xsl:with-param name="TimeCode" select="substring(D_350, 14, 2)"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="$dt1 castable as xs:date">
								<xsl:attribute name="taxPointDate">
									<xsl:call-template name="convertToAribaDate">
										<xsl:with-param name="Date" select="substring(D_350, 1, 8)"/>
										<xsl:with-param name="Time" select="substring(D_350, 9, 6)"/>
										<xsl:with-param name="TimeCode" select="substring(D_350, 14, 2)"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					
				</xsl:choose>
				<xsl:if test="$pdDate != ''">
					<xsl:attribute name="paymentDate">
						<xsl:call-template name="convertToAribaDate">
							<xsl:with-param name="Date" select="$pdDate"/>
							<xsl:with-param name="Time" select="$pdTime"/>
							<xsl:with-param name="TimeCode" select="$pdTimeCode"/>
						</xsl:call-template>
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="D_441 = '0'">
					<xsl:attribute name="exemptDetail">
						<xsl:text>zeroRated</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="D_441 = '2'">
					<xsl:attribute name="exemptDetail">
						<xsl:text>exempt</xsl:text>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<!-- TaxableAmount -->
			<xsl:if test="D_325 != ''">
				<xsl:element name="TaxableAmount">
					<xsl:call-template name="createMoney">
						<xsl:with-param name="Curr" select="$mainCurrency"/>
						<xsl:with-param name="AltCurr" select="$alternateCurrency"/>
						<xsl:with-param name="isCreditMemo" select="$creditMemoFlag"/>
						<xsl:with-param name="money" select="D_325"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			<xsl:element name="TaxAmount">
				<xsl:call-template name="createMoney">
					<xsl:with-param name="Curr" select="$mainCurrency"/>
					<xsl:with-param name="AltCurr" select="$alternateCurrency"/>
					<xsl:with-param name="altAmt" select="$alternateAmount"/>
					<xsl:with-param name="isCreditMemo" select="$creditMemoFlag"/>
					<xsl:with-param name="money" select="D_782"/>
				</xsl:call-template>
			</xsl:element>
			<!-- TaxLocation -->
			<xsl:if test="D_955 = 'VD' and D_956 != ''">
				<xsl:element name="TaxLocation">
					<xsl:attribute name="xml:lang">en</xsl:attribute>
					<xsl:value-of select="D_956"/>
				</xsl:element>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="D_441 = '0' and $taxCategory = 'vat'">
					<xsl:element name="Description">
						<xsl:attribute name="xml:lang">en</xsl:attribute>
						<xsl:value-of select="'Zero rated tax'"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="D_441 = '0' and not(exists(D_350))">
					<xsl:element name="Description">
						<xsl:attribute name="xml:lang">en</xsl:attribute>
						<xsl:value-of select="'Zero rated tax'"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="D_350 != ''">
					<xsl:element name="Description">
						<xsl:attribute name="xml:lang">en</xsl:attribute>
						<xsl:value-of select="D_350"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="convertToAribaDate">
		<xsl:param name="Date"/>
		<xsl:param name="Time"/>
		<xsl:param name="TimeCode"/>
		<xsl:variable name="timeZone">
			<xsl:choose>
				<xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
					<xsl:value-of
						select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"
					/>
				</xsl:when>
				<xsl:otherwise>+00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="temDate">
			<xsl:value-of
				select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"
			/>
		</xsl:variable>
		<xsl:variable name="tempTime">
			<xsl:choose>
				<xsl:when test="$Time != '' and string-length($Time) = 6">
					<xsl:value-of
						select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"
					/>
				</xsl:when>
				<xsl:when test="$Time != '' and string-length($Time) = 4">
					<xsl:value-of
						select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
				</xsl:when>
				<xsl:otherwise>T12:00:00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
	</xsl:template>
	
	<xsl:template name="createMoney">
		<xsl:param name="Curr"/>
		<xsl:param name="AltCurr"/>
		<xsl:param name="isCreditMemo"/>
		<xsl:param name="money"/>
		<xsl:param name="altAmt"/>
		<xsl:param name="isLineNegPriceAdjustment"/>
		<xsl:variable name="mainMoney">
			<xsl:choose>
				<xsl:when test="string($money) != ''">
					<xsl:value-of select="$money"/>
				</xsl:when>
				<xsl:otherwise>0.00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="Money">
			<xsl:attribute name="currency">
				<xsl:value-of select="$Curr"/>
			</xsl:attribute>
			<xsl:if test="$AltCurr != '' and $altAmt != ''">
				<xsl:attribute name="alternateCurrency">
					<xsl:value-of select="$AltCurr"/>
				</xsl:attribute>
				<xsl:attribute name="alternateAmount">
					<xsl:choose>
						<xsl:when test="$isCreditMemo = 'yes'">
							<xsl:value-of select="concat('-', replace(string($altAmt), '-', ''))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$altAmt"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$isLineNegPriceAdjustment = 'yes'">
					<xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
				</xsl:when>
				<xsl:when test="$isLineNegPriceAdjustment = 'no'">
					<xsl:value-of select="$mainMoney"/>
				</xsl:when>
				<xsl:when test="$isCreditMemo = 'yes'">
					<xsl:value-of select="concat('-', replace(string($mainMoney), '-', ''))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$mainMoney"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	
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
