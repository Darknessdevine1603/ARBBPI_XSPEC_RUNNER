<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:template name="createMOA">
		<xsl:param name="grpNum"/>
		<xsl:param name="qual"/>
		<xsl:param name="money"/>
		<xsl:param name="createAlternate"/>
		<xsl:param name="hideAmt"/>
		<xsl:choose>
			<xsl:when test="$grpNum">
				<xsl:element name="{$grpNum}">
					<S_MOA>
						<C_C516>
							<D_5025>
								<xsl:value-of select="normalize-space($qual)"/>
							</D_5025>
							<D_5004>
								<xsl:choose>
									<xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="formatAmount">
											<xsl:with-param name="amount" select="normalize-space(replace(normalize-space($money/Money), ',', ''))"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</D_5004>
							<xsl:if test="exists(/cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency) and normalize-space($money/Money/@currency) != ''">
								<D_6345>
									<xsl:value-of select="normalize-space($money/Money/@currency)"/>
								</D_6345>
								<D_6343>9</D_6343>
							</xsl:if>
						</C_C516>
					</S_MOA>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<S_MOA>
					<C_C516>
						<D_5025>
							<xsl:value-of select="normalize-space($qual)"/>
						</D_5025>
						<D_5004>
							<xsl:choose>
								<xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="formatAmount">
										<xsl:with-param name="amount" select="normalize-space(replace(normalize-space($money/Money), ',', ''))"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</D_5004>
						<xsl:if test="exists(/cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency) and normalize-space($money/Money/@currency) != ''">
							<D_6345>
								<xsl:value-of select="normalize-space($money/Money/@currency)"/>
							</D_6345>
							<D_6343>9</D_6343>
						</xsl:if>
					</C_C516>
				</S_MOA>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$createAlternate = 'yes' and normalize-space($money/Money/@alternateAmount) != '' and not(empty($money/Money/@alternateAmount))">
			<xsl:choose>
				<xsl:when test="$grpNum">
					<xsl:element name="{$grpNum}">
						<S_MOA>
							<C_C516>
								<D_5025>
									<xsl:value-of select="normalize-space($qual)"/>
								</D_5025>
								<D_5004>
									<xsl:choose>
										<xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="formatAmount">
												<xsl:with-param name="amount" select="normalize-space(replace(normalize-space($money/Money/@alternateAmount), ',', ''))"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</D_5004>
								<xsl:if test="normalize-space($money/Money/@alternateCurrency) != ''">
									<D_6345>
										<xsl:value-of select="normalize-space($money/Money/@alternateCurrency)"/>
									</D_6345>
									<D_6343>11</D_6343>
								</xsl:if>
							</C_C516>
						</S_MOA>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<S_MOA>
						<C_C516>
							<D_5025>
								<xsl:value-of select="normalize-space($qual)"/>
							</D_5025>
							<D_5004>
								<xsl:choose>
									<xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="formatAmount">
											<xsl:with-param name="amount" select="normalize-space(replace(normalize-space($money/Money/@alternateAmount), ',', ''))"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</D_5004>
							<xsl:if test="normalize-space($money/Money/@alternateCurrency) != ''">
								<D_6345>
									<xsl:value-of select="normalize-space($money/Money/@alternateCurrency)"/>
								</D_6345>
								<D_6343>11</D_6343>
							</xsl:if>
						</C_C516>
					</S_MOA>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="mapPayloadID">
		<xsl:param name="payloadID"/>
		<xsl:param name="payloadQUAL"/>
		<xsl:if test="string-length($payloadID) &gt; 0">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>
							<xsl:value-of select="$payloadQUAL"/>
						</D_1153>
						<D_1154>
							<xsl:value-of select="substring($payloadID, 1, 35)"/>
						</D_1154>
						<xsl:if test="substring($payloadID, 36) != ''">
							<D_4000>
								<xsl:value-of select="substring($payloadID, 36, 35)"/>
							</D_4000>
						</xsl:if>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<xsl:if test="substring($payloadID, 71) != ''">
			<xsl:call-template name="mapPayloadID">
				<xsl:with-param name="payloadID" select="normalize-space(substring($payloadID, 71))"/>
				<xsl:with-param name="payloadQUAL" select="$payloadQUAL"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="IMDLoop">
		<xsl:param name="IMDQual"/>
		<xsl:param name="IMDData"/>
		<xsl:param name="langCode"/>
		<xsl:if test="string-length($IMDData) &gt; 0">
			<S_IMD>
				<D_7077>
					<xsl:value-of select="$IMDQual"/>
				</D_7077>
				<C_C273>
					<D_7008>
						<xsl:value-of select="substring($IMDData, 1, 35)"/>
					</D_7008>
					<xsl:if test="normalize-space(substring($IMDData, 36)) != ''">
						<D_7008_2>
							<xsl:value-of select="normalize-space(substring($IMDData, 36, 35))"/>
						</D_7008_2>
					</xsl:if>
					<D_3453>
						<xsl:choose>
							<xsl:when test="$langCode != ''">
								<xsl:value-of select="upper-case(substring($langCode, 1, 2))"/>
							</xsl:when>
							<xsl:otherwise>EN</xsl:otherwise>
						</xsl:choose>
					</D_3453>
				</C_C273>
			</S_IMD>
		</xsl:if>
		<xsl:if test="substring($IMDData, 71) != ''">
			<xsl:call-template name="IMDLoop">
				<xsl:with-param name="IMDData" select="normalize-space(substring($IMDData, 71))"/>
				<xsl:with-param name="IMDQual" select="$IMDQual"/>
				<xsl:with-param name="langCode" select="$langCode"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FTXLoop">
		<xsl:param name="FTXQual"/>
		<xsl:param name="FTXData"/>
		<xsl:param name="domain"/>
		<xsl:param name="langCode"/>
		<xsl:variable name="lang" select="substring($langCode, 1, 2)"/>
		<xsl:if test="string-length($FTXData) &gt; 0">
			<xsl:variable name="C108">
				<C_C108>
					<xsl:if test="substring($FTXData, 1, 70) != ''">
						<xsl:variable name="temp">
							<xsl:call-template name="rTrim">
								<xsl:with-param name="inData" select="substring($FTXData, 1, 70)"/>
							</xsl:call-template>
						</xsl:variable>
						<D_4440>
							<xsl:choose>
								<xsl:when test="$domain != ''">
									<xsl:value-of select="$domain"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$temp"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_4440>
						<xsl:variable name="pendingFTX">
							<xsl:choose>
								<xsl:when test="$domain != ''">
									<xsl:value-of select="$FTXData"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring($FTXData, string-length($temp) + 1)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="string-length($pendingFTX) &gt; 0">
							<xsl:variable name="temp">
								<xsl:call-template name="rTrim">
									<xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
								</xsl:call-template>
							</xsl:variable>
							<D_4440_2>
								<xsl:value-of select="$temp"/>
							</D_4440_2>
							<xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
							<xsl:if test="string-length($pendingFTX) &gt; 0">
								<xsl:variable name="temp">
									<xsl:call-template name="rTrim">
										<xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
									</xsl:call-template>
								</xsl:variable>
								<D_4440_3>
									<xsl:value-of select="$temp"/>
								</D_4440_3>
								<xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
								<xsl:if test="string-length($pendingFTX) &gt; 0">
									<xsl:variable name="temp">
										<xsl:call-template name="rTrim">
											<xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
										</xsl:call-template>
									</xsl:variable>
									<D_4440_4>
										<xsl:value-of select="$temp"/>
									</D_4440_4>
									<xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
									<xsl:if test="string-length($pendingFTX) &gt; 0">
										<xsl:variable name="temp">
											<xsl:call-template name="rTrim">
												<xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
											</xsl:call-template>
										</xsl:variable>
										<D_4440_5>
											<xsl:value-of select="$temp"/>
										</D_4440_5>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</C_C108>
			</xsl:variable>
			<S_FTX>
				<D_4451>
					<xsl:value-of select="$FTXQual"/>
				</D_4451>
				<xsl:copy-of select="$C108"/>
				<xsl:choose>
					<xsl:when test="$langCode = 'no'"/>
					<xsl:when test="string-length(substring($langCode, 1, 2)) = 2">
						<D_3453>
							<xsl:value-of select="upper-case(substring($langCode, 1, 2))"/>
						</D_3453>
					</xsl:when>
					<xsl:otherwise>
						<D_3453>EN</D_3453>
					</xsl:otherwise>
				</xsl:choose>
			</S_FTX>
			<xsl:variable name="ftxLen"
				select="string-length($C108//D_4440) + string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>
			<xsl:if test="substring($FTXData, $ftxLen + 1) != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData">
						<xsl:value-of select="substring($FTXData, $ftxLen + 1)"/>
					</xsl:with-param>
					<xsl:with-param name="FTXQual" select="$FTXQual"/>
					<xsl:with-param name="langCode" select="$langCode"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FTXExtrinsic">
		<xsl:param name="FTXName"/>
		<xsl:param name="FTXData"/>
		<xsl:if test="string-length($FTXData) &gt; 0">
			<xsl:variable name="C108">
				<C_C108>
					<D_4440>
						<xsl:value-of select="substring(normalize-space($FTXName), 1, 70)"/>
					</D_4440>
					<xsl:if test="substring($FTXData, 1, 70) != ''">
						<xsl:variable name="temp">
							<xsl:call-template name="rTrim">
								<xsl:with-param name="inData" select="substring($FTXData, 1, 70)"/>
							</xsl:call-template>
						</xsl:variable>
						<D_4440_2>
							<xsl:value-of select="$temp"/>
						</D_4440_2>
						<xsl:variable name="pendingFTX" select="substring($FTXData, string-length($temp) + 1)"/>
						<xsl:if test="string-length($pendingFTX) &gt; 0">
							<xsl:variable name="temp">
								<xsl:call-template name="rTrim">
									<xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
								</xsl:call-template>
							</xsl:variable>
							<D_4440_3>
								<xsl:value-of select="$temp"/>
							</D_4440_3>
							<xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
							<xsl:if test="string-length($pendingFTX) &gt; 0">
								<xsl:variable name="temp">
									<xsl:call-template name="rTrim">
										<xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
									</xsl:call-template>
								</xsl:variable>
								<D_4440_4>
									<xsl:value-of select="$temp"/>
								</D_4440_4>
								<xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
								<xsl:if test="string-length($pendingFTX) &gt; 0">
									<xsl:variable name="temp">
										<xsl:call-template name="rTrim">
											<xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
										</xsl:call-template>
									</xsl:variable>
									<D_4440_5>
										<xsl:value-of select="$temp"/>
									</D_4440_5>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</C_C108>
			</xsl:variable>
			<S_FTX>
				<D_4451>ZZZ</D_4451>
				<xsl:copy-of select="$C108"/>
			</S_FTX>
			<xsl:variable name="ftxLen"
				select="string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>
			<xsl:if test="substring($FTXData, $ftxLen + 1) != ''">
				<xsl:call-template name="FTXExtrinsic">
					<xsl:with-param name="FTXName" select="$FTXName"/>
					<xsl:with-param name="FTXData">
						<xsl:value-of select="substring($FTXData, $ftxLen + 1)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="rTrim">
		<xsl:param name="inData"/>
		<xsl:choose>
			<xsl:when test="ends-with($inData, ' ')">
				<xsl:call-template name="rTrim">
					<xsl:with-param name="inData" select="substring($inData, 1, string-length($inData) - 1)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inData"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createNAD">
		<xsl:param name="party"/>
		<xsl:param name="role"/>
		<xsl:param name="refGrupNum"/>
		<xsl:choose>
			<xsl:when test="name($party) = 'Contact' or $role = 'deliveryParty'">
				<xsl:call-template name="mapS_NAD">
					<xsl:with-param name="Address" select="$party"/>
					<xsl:with-param name="role" select="$role"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mapS_NAD">
					<xsl:with-param name="Address" select="$party/Address"/>
					<xsl:with-param name="role" select="$role"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$role != 'deliveryParty'">
			<xsl:for-each select="$party/IdReference">
				<xsl:if test="normalize-space(@identifier) != ''">
					<xsl:variable name="refDomain" select="normalize-space(@domain)"/>
					<xsl:variable name="refLookup" select="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $refDomain]/EANCOMCode"/>
					<xsl:if test="$refLookup != ''">
						<xsl:element name="{$refGrupNum}">
							<S_RFF>
								<C_C506>
									<D_1153>
										<xsl:value-of select="$refLookup"/>
									</D_1153>
									<D_1154>
										<xsl:value-of select="substring(normalize-space(@identifier), 1, 35)"/>
									</D_1154>
								</C_C506>
							</S_RFF>
						</xsl:element>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="mapS_NAD">
		<xsl:param name="Address"/>
		<xsl:param name="role"/>
		<S_NAD>
			<D_3035>
				<xsl:choose>
					<xsl:when test="$role = 'billTo' and not(exists($Address/ancestor::OrderRequestHeader/Contact[lower-case(@role) = 'buyer']))">BY</xsl:when>
					<xsl:when test="$role = 'billTo'">IV</xsl:when>
					<xsl:when test="$role = 'shipTo'">ST</xsl:when>
					<xsl:when test="$role = 'deliveryParty'">DP</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="normalize-space($Address/@role) != ''">
								<xsl:variable name="crole" select="normalize-space($Address/@role)"/>
								<xsl:choose>
									<xsl:when test="$Lookup/Lookups/Roles/Role[CXMLCode = $crole][1]/EANCOMCode != ''">
										<xsl:value-of select="$Lookup/Lookups/Roles/Role[CXMLCode = $crole][1]/EANCOMCode"/>
									</xsl:when>
									<xsl:otherwise>ZZZ</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>ZZZ</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</D_3035>
			<xsl:variable name="addrDomain" select="normalize-space($Address/@addressIDDomain)"/>
			<xsl:choose>
				<!--For non-Contact roles-->
				<xsl:when test="$Address/following-sibling::IdReference[@domain = 'ILN'][@identifier != '']">
					<C_C082>
						<D_3039>
							<xsl:value-of select="substring(normalize-space($Address/following-sibling::IdReference[@domain = 'ILN']/@identifier), 1, 35)"/>
						</D_3039>
						<D_3055>
							<xsl:value-of select="'9'"/>
						</D_3055>
					</C_C082>
				</xsl:when>
				<!--for Contact roles-->
				<xsl:when test="$Address/IdReference[@domain = 'ILN'][@identifier != '']">
					<C_C082>
						<D_3039>
							<xsl:value-of select="substring(normalize-space($Address/IdReference[@domain = 'ILN']/@identifier), 1, 35)"/>
						</D_3039>
						<D_3055>
							<xsl:value-of select="'9'"/>
						</D_3055>
					</C_C082>
				</xsl:when>
				<xsl:when test="normalize-space($Address/@addressID) != ''">
					<C_C082>
						<D_3039>
							<xsl:value-of select="substring(normalize-space($Address/@addressID), 1, 35)"/>
						</D_3039>
						<D_3055>
							<xsl:value-of select="'9'"/>
						</D_3055>
					</C_C082>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="normalize-space($Address/PostalAddress/DeliverTo[1]) != ''">
				<C_C058>
					<xsl:for-each select="$Address/PostalAddress/DeliverTo[5 &gt;= position()]">
						<xsl:variable name="segPosDel">
							<xsl:choose>
								<xsl:when test="position() = 1"> </xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('_', position())"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="{concat('D_3124', $segPosDel)}">
							<xsl:call-template name="rTrim">
								<xsl:with-param name="inData" select="normalize-space(substring(normalize-space(.), 1, 35))"/>
							</xsl:call-template>
						</xsl:element>
					</xsl:for-each>
				</C_C058>
			</xsl:if>
			<xsl:variable name="Name" select="normalize-space($Address/Name)"/>
			<xsl:if test="$Name != ''">
				<C_C080>
					<D_3036>
						<xsl:call-template name="rTrim">
							<xsl:with-param name="inData" select="normalize-space(substring($Name, 1, 35))"/>
						</xsl:call-template>
					</D_3036>
					<xsl:if test="normalize-space(substring($Name, 36, 35)) != ''">
						<D_3036_2>
							<xsl:call-template name="rTrim">
								<xsl:with-param name="inData" select="normalize-space(substring($Name, 36, 35))"/>
							</xsl:call-template>
						</D_3036_2>
					</xsl:if>
					<xsl:if test="normalize-space(substring($Name, 71, 35)) != ''">
						<D_3036_3>
							<xsl:call-template name="rTrim">
								<xsl:with-param name="inData" select="normalize-space(substring($Name, 71, 35))"/>
							</xsl:call-template>
						</D_3036_3>
					</xsl:if>
					<xsl:if test="normalize-space(substring($Name, 106, 35)) != ''">
						<D_3036_4>
							<xsl:call-template name="rTrim">
								<xsl:with-param name="inData" select="normalize-space(substring($Name, 106, 35))"/>
							</xsl:call-template>
						</D_3036_4>
					</xsl:if>
					<xsl:if test="normalize-space(substring($Name, 141, 35)) != ''">
						<D_3036_5>
							<xsl:call-template name="rTrim">
								<xsl:with-param name="inData" select="normalize-space(substring($Name, 141, 35))"/>
							</xsl:call-template>
						</D_3036_5>
					</xsl:if>
				</C_C080>
			</xsl:if>
			<xsl:if test="normalize-space($Address/PostalAddress/Street[1]) != ''">
				<C_C059>
					<xsl:for-each select="$Address/PostalAddress/Street[4 &gt;= position()]">
						<xsl:variable name="segPosAdd">
							<xsl:choose>
								<xsl:when test="position() = 1"> </xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('_', position())"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="{concat('D_3042', $segPosAdd)}">
							<xsl:value-of select="normalize-space(substring(normalize-space(.), 1, 35))"/>
						</xsl:element>
					</xsl:for-each>
				</C_C059>
			</xsl:if>
			<xsl:if test="normalize-space($Address/PostalAddress/City) != ''">
				<D_3164>
					<xsl:value-of select="substring(normalize-space($Address/PostalAddress/City), 1, 35)"/>
				</D_3164>
			</xsl:if>
			<xsl:if test="normalize-space($Address/PostalAddress/State) != ''">
				<C_C819>
					<D_3229>
						<xsl:value-of select="substring(normalize-space($Address/PostalAddress/State), 1, 9)"/>
					</D_3229>
				</C_C819>
			</xsl:if>
			<xsl:if test="normalize-space($Address/PostalAddress/PostalCode) != ''">
				<D_3251>
					<xsl:value-of select="substring(normalize-space($Address/PostalAddress/PostalCode), 1, 9)"/>
				</D_3251>
			</xsl:if>
			<xsl:if test="normalize-space($Address/PostalAddress/Country/@isoCountryCode) != ''">
				<D_3207>
					<xsl:value-of select="substring(normalize-space($Address/PostalAddress/Country/@isoCountryCode), 1, 3)"/>
				</D_3207>
			</xsl:if>
		</S_NAD>
	</xsl:template>
	<xsl:template name="formatDate">
		<!-- convert Ariba cXML date to EDI Format -->
		<xsl:param name="DocDate"/>
		<xsl:choose>
			<xsl:when test="$DocDate">
				<xsl:variable name="date">
					<xsl:choose>
						<xsl:when test="contains($DocDate, 'T')">
							<xsl:value-of select="replace(substring-before($DocDate, 'T'), '-', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="replace(substring($DocDate, 1, 10), '-', '')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="time">
					<xsl:value-of select="substring-after($DocDate, 'T')"/>
				</xsl:variable>
				<xsl:variable name="timezone">
					<xsl:if test="$time != ''">
						<xsl:choose>
							<xsl:when test="contains($time, '-')">
								<xsl:value-of select="concat('-', substring-after($time, '-'))"/>
							</xsl:when>
							<xsl:when test="contains($time, '+')">
								<xsl:value-of select="concat('+', substring-after($time, '+'))"/>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="time">
					<xsl:if test="$time != ''">
						<xsl:choose>
							<xsl:when test="contains($time, '-')">
								<xsl:value-of select="replace(substring-before($time, '-'), ':', '')"/>
							</xsl:when>
							<xsl:when test="contains($time, '+')">
								<xsl:value-of select="replace(substring-before($time, '+'), ':', '')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="replace($time, ':', '')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="SS">
					<xsl:if test="string-length($time) = 6">
						<xsl:value-of select="substring($time, 5)"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="HH">
					<xsl:value-of select="substring($time, 3, 2)"/>
				</xsl:variable>
				<xsl:variable name="TZone" select="concat($Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timezone][1]/EANCOMCode, '')"/>
				<D_2380>
					<xsl:value-of select="concat($date, $time)"/>
				</D_2380>
				<D_2379>
					<xsl:choose>
						<!--xsl:when test="$SS!='' and $TZone!=''">304</xsl:when>						<xsl:when test="$SS='' and $TZone!=''">303</xsl:when-->
						<xsl:when test="$SS != '' and $HH != ''">204</xsl:when>
						<!--CCYYMMDDHHMMSS-->
						<xsl:when test="$SS = '' and $HH != ''">203</xsl:when>
						<!--CCYYMMDDHHMM-->
						<xsl:otherwise>102</xsl:otherwise>
						<!--CCYYMMDD-->
					</xsl:choose>
				</D_2379>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ShippingMark" mode="D_7102">
		<xsl:variable name="segPosShipMark">
			<xsl:choose>
				<xsl:when test="position() = 1"> </xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('_', (position() mod 11))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{concat('D_7102', $segPosShipMark)}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="ShippingMark" mode="SG32">
		<G_SG32>
			<S_PCI>
				<D_4233>30</D_4233>
				<C_C210>
					<xsl:apply-templates select=". | following-sibling::ShippingMark[position() &lt; 10]" mode="D_7102"/>
				</C_C210>
			</S_PCI>
		</G_SG32>
	</xsl:template>
	<xsl:template match="ShippingMark" mode="SG34">
		<G_SG34>
			<S_PCI>
				<D_4233>30</D_4233>
				<C_C210>
					<xsl:apply-templates select=". | following-sibling::ShippingMark[position() &lt; 10]" mode="D_7102"/>
				</C_C210>
			</S_PCI>
		</G_SG34>
	</xsl:template>
	<xsl:template match="Accounting" mode="ele">
		<D_7160>
			<xsl:variable name="Aseg">
				<xsl:apply-templates select="AccountingSegment" mode="data"/>
			</xsl:variable>
			<xsl:value-of select="substring($Aseg, 2, 35)"/>
		</D_7160>
	</xsl:template>
	<xsl:template match="AccountingSegment" mode="data">
		<xsl:value-of select="concat('-', ./@id)"/>
	</xsl:template>
	<xsl:template match="Email">
		<xsl:if test=". != ''">
			<Con>
				<xsl:attribute name="type">EM</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="."/>
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template match="URL">
		<xsl:param name="isRemittence"/>
		<xsl:if test=". != ''">
			<Con>
				<xsl:attribute name="type">
					<xsl:text>WWW</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="."/>
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Fax">
		<xsl:if test="TelephoneNumber/CountryCode != '' or TelephoneNumber/AreaOrCityCode != '' or TelephoneNumber/Number != ''">
			<Con>
				<xsl:attribute name="type">FX</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="Number">
					<xsl:value-of
						select="concat(normalize-space(TelephoneNumber/CountryCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/AreaOrCityCode)))), normalize-space(TelephoneNumber/AreaOrCityCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/Number)))), normalize-space(TelephoneNumber/Number), substring('X', 1, number(string-length(normalize-space(TelephoneNumber/Extension)))), normalize-space(TelephoneNumber/Extension))"
					/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="starts-with($Number, '-')">
						<xsl:value-of select="substring($Number, 2)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$Number"/>
					</xsl:otherwise>
				</xsl:choose>
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Phone">
		<xsl:if test="TelephoneNumber/Number != ''">
			<Con>
				<xsl:attribute name="type">TE</xsl:attribute>
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="./@name != ''">
							<xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>default</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:variable name="Number">
					<xsl:value-of
						select="concat(normalize-space(TelephoneNumber/CountryCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/AreaOrCityCode)))), normalize-space(TelephoneNumber/AreaOrCityCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/Number)))), normalize-space(TelephoneNumber/Number), substring('X', 1, number(string-length(normalize-space(TelephoneNumber/Extension)))), normalize-space(TelephoneNumber/Extension))"
					/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="starts-with($Number, '-')">
						<xsl:value-of select="substring($Number, 2)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$Number"/>
					</xsl:otherwise>
				</xsl:choose>
			</Con>
		</xsl:if>
	</xsl:template>
	<xsl:template name="CTACOMLoop">
		<xsl:param name="contact"/>
		<xsl:param name="contactType"/>
		<xsl:param name="ContactDepartmentID"/>
		<xsl:param name="ContactPerson"/>
		<xsl:param name="level"/>
		<xsl:param name="isPOUpdate"/>
		<xsl:param name="isJITorFOR"/>
		<xsl:param name="isRemittence"/>
		<xsl:param name="isIFTMIN"/>
		<xsl:variable name="contactList">
			<xsl:apply-templates select="$contact/Email"/>
			<xsl:apply-templates select="$contact/Phone"/>
			<xsl:apply-templates select="$contact/Fax"/>
			<xsl:apply-templates select="$contact/URL">
				<xsl:with-param name="isRemittence" select="$isRemittence"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:for-each-group select="$contactList/Con" group-by="./@name">
			<xsl:sort select="@name"/>
			<xsl:variable name="cta01" select="current-grouping-key()"/>
			<xsl:for-each-group select="current-group()" group-ending-with="*[position() mod 5 = 0]">
				<xsl:variable name="eleName">
					<xsl:choose>
						<xsl:when test="$isPOUpdate = 'true'">
							<xsl:choose>
								<xsl:when test="$level = 'detail'">G_SG40</xsl:when>
								<xsl:otherwise>G_SG6</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$isJITorFOR = 'true'">
							<xsl:choose>
								<xsl:when test="$level = 'detail'">G_SG26</xsl:when>
								<xsl:otherwise>G_SG3</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$isRemittence = 'true'">G_SG2</xsl:when>
						<xsl:when test="$isIFTMIN = 'true'">G_SG12</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$level = 'detail'">G_SG42</xsl:when>
								<xsl:otherwise>G_SG5</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="{$eleName}">
					<S_CTA>
						<D_3139>
							<xsl:choose>
								<xsl:when test="lower-case($contactType) = 'buyer'">
									<xsl:text>PD</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>IC</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</D_3139>
						<C_C056>
							<!--<D_3413>								<xsl:choose>									<xsl:when test="$ContactDepartmentID!=''">										<xsl:value-of select="$ContactDepartmentID"/>									</xsl:when>									<xsl:otherwise>Not Avaiable</xsl:otherwise>								</xsl:choose>							</D_3413>-->
							<D_3412>
								<xsl:choose>
									<xsl:when test="$ContactPerson != ''">
										<xsl:value-of select="$ContactPerson"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$cta01"/>
									</xsl:otherwise>
								</xsl:choose>
							</D_3412>
						</C_C056>
					</S_CTA>
					<xsl:for-each select="current-group()">
						<S_COM>
							<C_C076>
								<D_3148>
									<xsl:value-of select="."/>
								</D_3148>
								<D_3155>
									<xsl:value-of select="./@type"/>
								</D_3155>
							</C_C076>
						</S_COM>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template name="formatDate1">
		<xsl:param name="DocDate"/>
		<xsl:choose>
			<xsl:when test="$DocDate">
				<xsl:variable name="Year" select="substring($DocDate, 0, 5)"/>
				<xsl:variable name="Month" select="substring($DocDate, 6, 2)"/>
				<xsl:variable name="Day" select="substring($DocDate, 9, 2)"/>
				<xsl:value-of select="concat($Year, $Month, $Day)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="formatDate2">
		<xsl:param name="DocDate"/>
		<xsl:choose>
			<xsl:when test="$DocDate">
				<xsl:variable name="Year" select="substring($DocDate, 0, 5)"/>
				<xsl:variable name="Month" select="substring($DocDate, 6, 2)"/>
				<xsl:variable name="Day" select="substring($DocDate, 9, 2)"/>
				<xsl:value-of select="concat($Year, '-', $Month, '-', $Day)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createItemParts">
		<!-- this applies to PO/CO where not only supplier / buyer partID are considered, but also manufacturer partID -->
		<xsl:param name="itemID"/>
		<xsl:param name="itemDetail"/>
		<xsl:param name="ItemOutIndustry"/>
		<!--<xsl:param name="description"/>		<xsl:param name="lineRef"/>-->
		<xsl:variable name="partsList">
			<PartsList>
				<!--<!-\-<xsl:if test="normalize-space($lineRef)!=''">					<Part>						<Qualifier>PL</Qualifier>						<Value>							<xsl:value-of select="substring(normalize-space($lineRef),1,48)"/>						</Value>					</Part>				</xsl:if>-\->				<xsl:if test="normalize-space($itemID/SupplierPartID)!=''">					<Part>						<Qualifier>VP</Qualifier>						<Value>							<xsl:value-of select="substring(normalize-space($itemID/SupplierPartID),1,48)"/>						</Value>					</Part>				</xsl:if>-->
				<xsl:if test="normalize-space($itemID/SupplierPartAuxiliaryID) != ''">
					<Part>
						<Qualifier>5</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemID/SupplierPartAuxiliaryID), 1, 35)"/>
						</Value>
						<valueCode>SA</valueCode>
					</Part>
				</xsl:if>
				<xsl:if test="normalize-space($itemID/BuyerPartID) != ''">
					<Part>
						<Qualifier>5</Qualifier>
						<Value>
							<xsl:value-of select="substring(normalize-space($itemID/BuyerPartID), 1, 35)"/>
						</Value>
						<valueCode>IN</valueCode>
					</Part>
				</xsl:if>
				<xsl:if test="$itemDetail">
					<xsl:if test="normalize-space($itemDetail/ManufacturerPartID) != ''">
						<Part>
							<Qualifier>5</Qualifier>
							<Value>
								<xsl:value-of select="substring(normalize-space($itemDetail/ManufacturerPartID), 1, 48)"/>
							</Value>
							<valueCode>MF</valueCode>
						</Part>
					</xsl:if>
					<xsl:if test="normalize-space($itemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
						<Part>
							<Qualifier>1</Qualifier>
							<Value>
								<xsl:value-of select="substring(normalize-space($itemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
							</Value>
							<valueCode>EWC</valueCode>
						</Part>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$ItemOutIndustry">
					<xsl:if test="normalize-space($ItemOutIndustry/ItemOutRetail/PromotionVariantID) != ''">
						<Part>
							<Qualifier>1</Qualifier>
							<Value>
								<xsl:value-of select="substring(normalize-space($ItemOutIndustry/ItemOutRetail/PromotionVariantID), 1, 35)"/>
							</Value>
							<valueCode>PV</valueCode>
						</Part>
					</xsl:if>
				</xsl:if>
			</PartsList>
		</xsl:variable>
		<xsl:if test="count($partsList/PartsList/Part[Qualifier = '1']) &gt; 0">
			<S_PIA>
				<D_4347>
					<xsl:value-of select="'1'"/>
				</D_4347>
				<xsl:for-each select="$partsList/PartsList/Part[Qualifier = '1']">
					<xsl:choose>
						<xsl:when test="position() = 1">
							<C_C212>
								<D_7140>
									<xsl:value-of select="./Value"/>
								</D_7140>
								<D_7143>
									<xsl:value-of select="./valueCode"/>
								</D_7143>
							</C_C212>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="{concat('C_C212', '_', position())}">
								<D_7140>
									<xsl:value-of select="./Value"/>
								</D_7140>
								<D_7143>
									<xsl:value-of select="./valueCode"/>
								</D_7143>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</S_PIA>
		</xsl:if>
		<xsl:if test="count($partsList/PartsList/Part[Qualifier = '5']) &gt; 0">
			<S_PIA>
				<D_4347>
					<xsl:value-of select="'5'"/>
				</D_4347>
				<xsl:for-each select="$partsList/PartsList/Part[Qualifier = '5']">
					<xsl:choose>
						<xsl:when test="position() = 1">
							<C_C212>
								<D_7140>
									<xsl:value-of select="./Value"/>
								</D_7140>
								<D_7143>
									<xsl:value-of select="./valueCode"/>
								</D_7143>
							</C_C212>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="{concat('C_C212', '_', position())}">
								<D_7140>
									<xsl:value-of select="./Value"/>
								</D_7140>
								<D_7143>
									<xsl:value-of select="./valueCode"/>
								</D_7143>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</S_PIA>
		</xsl:if>
	</xsl:template>
	<xsl:template name="createTaxElement">
		<xsl:param name="buildTaxableAmtMOA"/>
		<S_TAX>
			<D_5283>
				<xsl:choose>
					<xsl:when test="@purpose = 'duty'">5</xsl:when>
					<xsl:otherwise>7</xsl:otherwise>
					<!--xsl:when test="@purpose='tax'">7</xsl:when 0728201 ACTION : this needs to be updated in spec-->
				</xsl:choose>
			</D_5283>
			<C_C241>
				<D_5153>
					<xsl:choose>
						<xsl:when test="lower-case(@category) = 'vat'">VAT</xsl:when>
						<xsl:when test="lower-case(@category) = 'gst'">GST</xsl:when>
						<xsl:otherwise>OTH</xsl:otherwise>
					</xsl:choose>
				</D_5153>
				<xsl:if test="TaxLocation != ''">
					<D_5152>
						<xsl:value-of select="substring(normalize-space(TaxLocation), 1, 35)"/>
					</D_5152>
				</xsl:if>
			</C_C241>
			<xsl:if test="normalize-space(@isTriangularTransaction) = 'true'">
				<C_C533>
					<D_5289>TT</D_5289>
				</C_C533>
			</xsl:if>
			<xsl:if test="normalize-space(@percentageRate) != ''">
				<C_C243>
					<xsl:if test="normalize-space(@percentageRate) != ''">
						<D_5278>
							<xsl:value-of select="normalize-space(@percentageRate)"/>
						</D_5278>
					</xsl:if>
				</C_C243>
			</xsl:if>
			<xsl:if test="normalize-space(@exemptDetail) != ''">
				<D_5305>
					<xsl:choose>
						<xsl:when test="Extrinsic[@name = 'exemptType'] = 'Mixed'">A</xsl:when>
						<xsl:when test="lower-case(normalize-space(@exemptDetail)) = 'exempt'">E</xsl:when>
						<xsl:when test="Extrinsic[@name = 'exemptType'] = 'Standard'">S</xsl:when>
						<xsl:when test="lower-case(normalize-space(@exemptDetail)) = 'zerorated'">Z</xsl:when>
					</xsl:choose>
				</D_5305>
			</xsl:if>
			<xsl:variable name="taxDesc">
				<xsl:for-each select="Description/text()">
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="normalize-space($taxDesc) != ''">
				<D_3446>
					<xsl:value-of select="substring($taxDesc, 1, 20)"/>
				</D_3446>
			</xsl:if>
		</S_TAX>
		<xsl:choose>
			<xsl:when test="$buildTaxableAmtMOA = 'true'">
				<xsl:call-template name="createMOA">
					<xsl:with-param name="qual" select="'125'"/>
					<xsl:with-param name="money" select="TaxableAmount"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="createMOA">
					<xsl:with-param name="qual" select="'124'"/>
					<xsl:with-param name="money" select="TaxAmount"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="mapCommonOrderHeaderElements">
		<xsl:param name="isChangeOrder"/>
		<!-- Order Date -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>137</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- PickUpDate -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>200</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- expirationDate -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>36</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- requestedDeliveryDate -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>2</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- startDate -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>64</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- endDate -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>63</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- IG-19030 -->
		<xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Comments">
			<xsl:variable name="varComments" select="normalize-space(.)"/>
			<xsl:variable name="iteration">
				<xsl:value-of select="position()"/>
			</xsl:variable>
			<xsl:choose>
				<!-- always first Comment to PUR -->
				<xsl:when test="$varComments != '' and $iteration eq '1'">
					<xsl:call-template name="FTXLoop">
						<xsl:with-param name="FTXData" select="$varComments"/>
						<xsl:with-param name="FTXQual" select="'PUR'"/>
						<xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
					</xsl:call-template>
				</xsl:when>
				<!-- After 1st comment,following  comments should go to AAI. and If '@type' is null pass space value. to create first D_4440-->
				<xsl:when test="$varComments != '' and $iteration gt '1'">
					<xsl:variable name="ACBtype">
						<xsl:choose>
							<xsl:when test="@type = '' or not(exists(@type))">
								<xsl:text>  </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space(@type)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="FTXLoop">
						<xsl:with-param name="FTXData" select="$varComments"/>
						<xsl:with-param name="domain" select="$ACBtype"/>
						<xsl:with-param name="FTXQual" select="'AAI'"/>
						<xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<!--  Shipping Instruction Description -->
		<xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation">
			<xsl:variable name="SIDesc" select="normalize-space(ShippingInstructions/Description)"/>
			<xsl:if test="$SIDesc != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$SIDesc"/>
					<xsl:with-param name="FTXQual" select="'TRA'"/>
					<xsl:with-param name="langCode" select="normalize-space(ShippingInstructions/Description/@xml:lang)"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<!--  Tax Description -->
		<xsl:variable name="TaxDesc" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Tax/Description)"/>
		<xsl:if test="$TaxDesc != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$TaxDesc"/>
				<xsl:with-param name="FTXQual" select="'TXD'"/>
				<xsl:with-param name="langCode" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Tax/Description/@xml:lang)"/>
			</xsl:call-template>
		</xsl:if>
		<!--  TermsOfDeliveryCode -->
		<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode/@value = 'Other'">
			<xsl:variable name="DeliCode" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TermsOfDeliveryCode)"/>
			<xsl:if test="$DeliCode != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$DeliCode"/>
					<xsl:with-param name="FTXQual" select="'DEL'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--  ShippingPaymentMethod -->
		<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value = 'Other'">
			<xsl:variable name="Spaymeth" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod)"/>
			<xsl:if test="$Spaymeth != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$Spaymeth"/>
					<xsl:with-param name="FTXQual" select="'PMT'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--  TransportTerms -->
		<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value = 'Other'">
			<xsl:variable name="TransTerms" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms)"/>
			<xsl:if test="$TransTerms != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$TransTerms"/>
					<xsl:with-param name="FTXQual" select="'DIN'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--  OrderRequestHeaderIndustry - Priority -->
		<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@level != ''">
			<S_FTX>
				<D_4451>PRI</D_4451>
				<C_C108>
					<D_4440>
						<xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@level"/>
					</D_4440>
					<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@sequence) != ''">
						<D_4440_2>
							<xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/@sequence"/>
						</D_4440_2>
					</xsl:if>
					<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/Description) != ''">
						<D_4440_3>
							<xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/Priority/Description"/>
						</D_4440_3>
					</xsl:if>
				</C_C108>
			</S_FTX>
		</xsl:if>
		<!-- ControlKeys -->
		<xsl:variable name="OCInstruction" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/@value)"/>
		<xsl:if test="$OCInstruction != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$OCInstruction"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'OCValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- OCLowerTimeTolerance -->
		<xsl:variable name="OCLowerTimeTolerance"
			select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit)"/>
		<xsl:if test="$OCLowerTimeTolerance != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$OCLowerTimeTolerance"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'OCLowerTimeToleranceInDays'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- OCUpperTimeTolerance -->
		<xsl:variable name="OCUpperTimeTolerance"
			select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit)"/>
		<xsl:if test="$OCUpperTimeTolerance != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$OCUpperTimeTolerance"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'OCUpperTimeToleranceInDays'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- ASNInstruction -->
		<xsl:variable name="ASNInstruction" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/ASNInstruction/@value)"/>
		<xsl:if test="$ASNInstruction != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$ASNInstruction"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'ASNValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- InvoiceInstruction -->
		<xsl:variable name="INVValue" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/InvoiceInstruction/@value)"/>
		<xsl:if test="$INVValue != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$INVValue"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'INVValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- SESInstruction -->
		<xsl:variable name="SESInstruction" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys/SESInstruction/@value)"/>
		<xsl:if test="$SESInstruction != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$SESInstruction"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'SESValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- agreementID -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>CT</D_1153>
						<D_1154>
							<xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID), 1, 35)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<!-- parentAgreementID -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>BO</D_1153>
						<D_1154>
							<xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID), 1, 35)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<!-- CustomerReferenceID -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>CR</D_1153>
						<D_1154>
							<xsl:value-of
								select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier), 1, 35)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<!-- UltimateCustomerReferenceID -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'UltimateCustomerReferenceID']/@identifier) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>UC</D_1153>
						<D_1154>
							<xsl:value-of
								select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'UltimateCustomerReferenceID']/@identifier), 1, 35)"
							/>
						</D_1154>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<!-- AdditionalReferenceID -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'AdditionalReferenceID']/@identifier) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>ACD</D_1153>
						<D_1154>
							<xsl:value-of
								select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'AdditionalReferenceID']/@identifier), 1, 35)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<!-- AribaNetworkID -->
		<xsl:if test="normalize-space(cXML/Header/From/Credential[lower-case(@domain) = 'aribanetworkid']/Identity) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>IT</D_1153>
						<D_1154>
							<xsl:value-of select="substring(normalize-space(cXML/Header/From/Credential[@domain = 'AribaNetworkID']/Identity), 1, 35)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<!-- ActionAuthID -->
		<xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'ActionAuthorizationNumber']/@identifier) != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>AKO</D_1153>
						<D_1154>
							<xsl:value-of
								select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/IdReference[@domain = 'ActionAuthorizationNumber']/@identifier), 1, 35)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
			</G_SG1>
		</xsl:if>
		<!-- Supplier OrderID and orderDate -->
		<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID != ''">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>VN</D_1153>
						<D_1154>
							<xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID), 1, 70)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
				<xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderDate != ''">
					<S_DTM>
						<C_C507>
							<D_2005>171</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderDate"/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>
			</G_SG1>
		</xsl:if>
		<!-- Map Header Tax Detail date -->
		<xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail[@isTriangularTransaction = 'yes' and (@taxPointDate != '' or @paymentDate != '')]">
			<G_SG1>
				<S_RFF>
					<C_C506>
						<D_1153>VA</D_1153>
						<D_1154>
							<xsl:value-of select="substring(normalize-space(Description), 1, 70)"/>
						</D_1154>
					</C_C506>
				</S_RFF>
				<xsl:if test="@taxPointDate != ''">
					<S_DTM>
						<C_C507>
							<D_2005>131</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="@taxPointDate"/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>
				<xsl:if test="@paymentDate != ''">
					<S_DTM>
						<C_C507>
							<D_2005>140</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate" select="@paymentDate"/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>
			</G_SG1>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="mapALCFromModification">
		<xsl:param name="deductionGrpNum"/>
		<xsl:param name="moneyGrpNum"/>
		<S_ALC>
			<D_5463>
				<xsl:choose>
					<xsl:when test="AdditionalDeduction">A</xsl:when>
					<xsl:when test="AdditionalCost">C</xsl:when>
				</xsl:choose>
			</D_5463>
			<xsl:if test="normalize-space(Description/ShortName) != ''">
				<C_C552>
					<D_1230>
						<xsl:value-of select="substring(normalize-space(Description/ShortName), 1, 35)"/>
					</D_1230>
				</C_C552>
			</xsl:if>
			<C_C214>
				<D_7161>
					<xsl:choose>
						<xsl:when test="ModificationDetail/@name = 'Adjustment'">AJ</xsl:when>
						<xsl:when test="ModificationDetail/@name = 'Handling'">HD</xsl:when>
					</xsl:choose>
				</D_7161>
				<xsl:variable name="modDesc" select="normalize-space(ModificationDetail/Description)"/>
				<xsl:if test="$modDesc != ''">
					<D_7160>
						<xsl:value-of select="normalize-space(substring($modDesc, 1, 35))"/>
					</D_7160>
				</xsl:if>
				<xsl:if test="normalize-space(substring($modDesc, 36)) != ''">
					<D_7160_2>
						<xsl:value-of select="normalize-space(substring($modDesc, 36, 35))"/>
					</D_7160_2>
				</xsl:if>
			</C_C214>
		</S_ALC>
		<xsl:if test="normalize-space(ModificationDetail/@startDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>194</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(ModificationDetail/@startDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<xsl:if test="normalize-space(ModificationDetail/@endDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>206</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(ModificationDetail/@endDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<xsl:if test="normalize-space(AdditionalDeduction/DeductionPercent/@percent) != '' or normalize-space(AdditionalCost/Percentage/@percent) != ''">
			<xsl:element name="{$deductionGrpNum}">
				<S_PCD>
					<C_C501>
						<D_5245>3</D_5245>
						<D_5482>
							<xsl:choose>
								<xsl:when test="normalize-space(AdditionalDeduction/DeductionPercent/@percent) != ''">
									<xsl:value-of select="substring(normalize-space(AdditionalDeduction/DeductionPercent/@percent), 1, 10)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring(normalize-space(AdditionalCost/Percentage/@percent), 1, 10)"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_5482>
						<D_5249>13</D_5249>
					</C_C501>
				</S_PCD>
			</xsl:element>
		</xsl:if>
		<xsl:if test="normalize-space(OriginalPrice/Money) != ''">
			<xsl:call-template name="createMOA">
				<xsl:with-param name="grpNum" select="$moneyGrpNum"/>
				<xsl:with-param name="qual" select="'98'"/>
				<xsl:with-param name="money" select="OriginalPrice"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if
			test="normalize-space(AdditionalCost/Money) != '' or normalize-space(AdditionalDeduction/DeductionAmount/Money) != '' or normalize-space(AdditionalDeduction/DeductedPrice/Money) != ''">
			<xsl:call-template name="createMOA">
				<xsl:with-param name="grpNum" select="$moneyGrpNum"/>
				<xsl:with-param name="qual">
					<xsl:choose>
						<xsl:when test="normalize-space(AdditionalCost/Money) != ''">8</xsl:when>
						<xsl:when test="normalize-space(AdditionalDeduction/DeductedPrice/Money) != ''">296</xsl:when>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="money">
					<xsl:choose>
						<xsl:when test="AdditionalCost/Money != ''">
							<xsl:copy-of select="AdditionalCost/Money"/>
						</xsl:when>
						<xsl:when test="AdditionalDeduction/DeductionAmount/Money != ''">
							<xsl:copy-of select="AdditionalDeduction/DeductionAmount/Money"/>
						</xsl:when>
						<xsl:when test="AdditionalDeduction/DeductedPrice/Money != ''">
							<xsl:copy-of select="AdditionalDeduction/DeductedPrice/Money"/>
						</xsl:when>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="mapCommonOrderItemElements">
		<xsl:param name="isChangeOrder"/>
		<!-- Description shortName -->
		<xsl:if test="normalize-space(BlanketItemDetail/Description/ShortName/text()) != '' or normalize-space(ItemDetail/Description/ShortName/text()) != ''">
			<xsl:variable name="shortName">
				<xsl:choose>
					<xsl:when test="normalize-space(BlanketItemDetail/Description/ShortName/text()) != ''">
						<xsl:value-of select="normalize-space(BlanketItemDetail/Description/ShortName/text())"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(ItemDetail/Description/ShortName/text())"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="langCode">
				<xsl:choose>
					<xsl:when test="normalize-space(BlanketItemDetail/Description/@xml:lang) != ''">
						<xsl:value-of select="normalize-space(BlanketItemDetail/Description/@xml:lang)"/>
					</xsl:when>
					<xsl:when test="normalize-space(ItemDetail/Description/@xml:lang) != ''">
						<xsl:value-of select="normalize-space(ItemDetail/Description/@xml:lang)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$shortName != ''">
				<xsl:call-template name="IMDLoop">
					<xsl:with-param name="IMDQual" select="'E'"/>
					<xsl:with-param name="IMDData" select="$shortName"/>
					<xsl:with-param name="langCode" select="$langCode"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- Description -->
		<xsl:if test="normalize-space(BlanketItemDetail/Description/text()[1]) or normalize-space(ItemDetail/Description/text()[1])">
			<xsl:variable name="descText">
				<xsl:choose>
					<xsl:when test="normalize-space(BlanketItemDetail/Description/text()[1]) != ''">
						<xsl:value-of select="normalize-space(BlanketItemDetail/Description/text()[1])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(ItemDetail/Description/text()[1])"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="langCode">
				<xsl:choose>
					<xsl:when test="normalize-space(BlanketItemDetail/Description/@xml:lang) != ''">
						<xsl:value-of select="normalize-space(BlanketItemDetail/Description/@xml:lang)"/>
					</xsl:when>
					<xsl:when test="normalize-space(ItemDetail/Description/@xml:lang) != ''">
						<xsl:value-of select="normalize-space(ItemDetail/Description/@xml:lang)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$descText != ''">
				<xsl:call-template name="IMDLoop">
					<xsl:with-param name="IMDQual" select="'F'"/>
					<xsl:with-param name="IMDData" select="$descText"/>
					<xsl:with-param name="langCode" select="$langCode"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- Characteristic -->
		<xsl:for-each select="ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic">
			<xsl:variable name="charDomain" select="normalize-space(@domain)"/>
			<xsl:if test="$Lookup/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[CXMLCode = $charDomain]/EANCOMCode != ''">
				<!-- CG 07252017 fixed wrong element -->
				<S_IMD>
					<D_7077>B</D_7077>
					<xsl:if test="normalize-space(@value) != ''">
						<C_C273>
							<D_7008>
								<xsl:value-of select="substring(normalize-space(@value), 1, 256)"/>
							</D_7008>
						</C_C273>
					</xsl:if>
				</S_IMD>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="Extrinsic[@name = 'itemIndicator'] != ''">
			<xsl:variable name="itemIndCode" select="normalize-space(Extrinsic[@name = 'itemIndicator'])"/>
			<xsl:variable name="itemIndCodeLookup" select="$Lookup/Lookups/IndicatorCodes/IndicatorCode[CXMLCode = $itemIndCode]/EANCOMCode"/>
			<xsl:if test="$itemIndCodeLookup != ''">
				<S_IMD>
					<D_7077>C</D_7077>
					<C_C273>
						<D_7009>
							<xsl:value-of select="$itemIndCodeLookup"/>
						</D_7009>
						<D_3055>
							<xsl:value-of select="'9'"/>
						</D_3055>
					</C_C273>
				</S_IMD>
			</xsl:if>
		</xsl:if>
		<!-- Dimension -->
		<xsl:for-each select="ItemDetail/Dimension">
			<S_MEA>
				<D_6311>PD</D_6311>
				<C_C502>
					<D_6313>
						<xsl:variable name="dimType" select="normalize-space(@type)"/>
						<xsl:choose>
							<xsl:when test="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dimType]/EANCOMCode != ''">
								<xsl:value-of select="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dimType]/EANCOMCode"/>
							</xsl:when>
							<xsl:otherwise>ZZZ</xsl:otherwise>
						</xsl:choose>
					</D_6313>
				</C_C502>
				<xsl:if test="normalize-space(UnitOfMeasure) != ''">
					<xsl:variable name="uom" select="normalize-space(UnitOfMeasure)"/>
					<C_C174>
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $uom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $uom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$uom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
						<xsl:if test="normalize-space(@quantity) != ''">
							<D_6314>
								<xsl:call-template name="formatQty">
									<xsl:with-param name="qty" select="normalize-space(@quantity)"/>
								</xsl:call-template>
							</D_6314>
						</xsl:if>
					</C_C174>
				</xsl:if>
			</S_MEA>
		</xsl:for-each>
		<!-- ItemOut @quantity -->
		<xsl:if test="normalize-space(@quantity) != ''">
			<S_QTY>
				<xsl:variable name="Buom" select="normalize-space(BlanketItemDetail/UnitOfMeasure)"/>
				<xsl:variable name="Iuom" select="normalize-space(ItemDetail/UnitOfMeasure)"/>
				<C_C186>
					<D_6063>21</D_6063>
					<D_6060>
						<xsl:call-template name="formatQty">
							<xsl:with-param name="qty" select="normalize-space(@quantity)"/>
						</xsl:call-template>
					</D_6060>
					<xsl:if test="$Buom != ''">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $Buom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $Buom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$Buom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
					<xsl:if
						test="$Iuom != '' and not(exists(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)) and not(exists(ItemID/IdReference[@domain = 'EAN-13']/@identifier))">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $Iuom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $Iuom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$Iuom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
				</C_C186>
			</S_QTY>
		</xsl:if>
		<!-- Blanket Extrinsic -->
		<xsl:if test="normalize-space(BlanketItemDetail/Extrinsic[@name = 'freeGoodsQuantity']) != ''">
			<S_QTY>
				<xsl:variable name="fuom" select="normalize-space(BlanketItemDetail/Extrinsic[@name = 'freeGoodsQuantityUOM'])"/>
				<C_C186>
					<D_6063>192</D_6063>
					<D_6060>
						<xsl:value-of select="normalize-space(BlanketItemDetail/Extrinsic[@name = 'freeGoodsQuantity'])"/>
					</D_6060>
					<xsl:if test="$fuom != ''">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$fuom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
				</C_C186>
			</S_QTY>
		</xsl:if>
		<xsl:if test="normalize-space(BlanketItemDetail/Extrinsic[@name = 'quantityPerPack']) != ''">
			<S_QTY>
				<xsl:variable name="fuom" select="normalize-space(BlanketItemDetail/Extrinsic[@name = 'quantityPerPackUOM'])"/>
				<C_C186>
					<D_6063>52</D_6063>
					<D_6060>
						<xsl:value-of select="normalize-space(BlanketItemDetail/Extrinsic[@name = 'quantityPerPack'])"/>
					</D_6060>
					<xsl:if test="$fuom != ''">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$fuom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
				</C_C186>
			</S_QTY>
		</xsl:if>
		<xsl:if test="normalize-space(BlanketItemDetail/Extrinsic[@name = 'consumerUnitQuantity']) != ''">
			<S_QTY>
				<xsl:variable name="fuom" select="normalize-space(BlanketItemDetail/Extrinsic[@name = 'consumerUnitQuantityUOM'])"/>
				<C_C186>
					<D_6063>59</D_6063>
					<D_6060>
						<xsl:value-of select="normalize-space(BlanketItemDetail/Extrinsic[@name = 'consumerUnitQuantity'])"/>
					</D_6060>
					<xsl:if test="$fuom != ''">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$fuom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
				</C_C186>
			</S_QTY>
		</xsl:if>
		<!-- ItemDetail Extrinsic -->
		<xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'freeGoodsQuantity']) != ''">
			<S_QTY>
				<xsl:variable name="fuom" select="normalize-space(ItemDetail/Extrinsic[@name = 'freeGoodsQuantityUOM'])"/>
				<C_C186>
					<D_6063>192</D_6063>
					<D_6060>
						<xsl:value-of select="normalize-space(ItemDetail/Extrinsic[@name = 'freeGoodsQuantity'])"/>
					</D_6060>
					<xsl:if test="$fuom != ''">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$fuom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
				</C_C186>
			</S_QTY>
		</xsl:if>
		<xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'quantityPerPack']) != ''">
			<S_QTY>
				<xsl:variable name="fuom" select="normalize-space(ItemDetail/Extrinsic[@name = 'quantityPerPackUOM'])"/>
				<C_C186>
					<D_6063>52</D_6063>
					<D_6060>
						<xsl:value-of select="normalize-space(ItemDetail/Extrinsic[@name = 'quantityPerPack'])"/>
					</D_6060>
					<xsl:if test="$fuom != ''">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$fuom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
				</C_C186>
			</S_QTY>
		</xsl:if>
		<xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'consumerUnitQuantity']) != ''">
			<S_QTY>
				<xsl:variable name="fuom" select="normalize-space(ItemDetail/Extrinsic[@name = 'consumerUnitQuantityUOM'])"/>
				<C_C186>
					<D_6063>59</D_6063>
					<D_6060>
						<xsl:value-of select="normalize-space(ItemDetail/Extrinsic[@name = 'consumerUnitQuantity'])"/>
					</D_6060>
					<xsl:if test="$fuom != ''">
						<D_6411>
							<xsl:choose>
								<xsl:when test="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode != ''">
									<xsl:value-of select="$Lookup/Lookups/UnitOfMeasures/UnitOfMeasure[CXMLCode = $fuom]/EANCOMCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$fuom"/>
								</xsl:otherwise>
							</xsl:choose>
						</D_6411>
					</xsl:if>
				</C_C186>
			</S_QTY>
		</xsl:if>
		<!-- requestedDeliveryDate -->
		<xsl:if test="normalize-space(@requestedDeliveryDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>2</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(@requestedDeliveryDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- requestedShipmentDate -->
		<xsl:if test="normalize-space(@requestedShipmentDate) != ''">
			<S_DTM>
				<C_C507>
					<D_2005>10</D_2005>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="DocDate" select="normalize-space(@requestedShipmentDate)"/>
					</xsl:call-template>
				</C_C507>
			</S_DTM>
		</xsl:if>
		<!-- ItemOut Tax -->
		<xsl:variable name="TaxOccurences" select="count(Tax/TaxDetail)"/>
		<xsl:if test="$TaxOccurences &gt; 1">
			<xsl:for-each select="Tax">
				<xsl:call-template name="createMOA">
					<xsl:with-param name="qual" select="'176'"/>
					<xsl:with-param name="money" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<!-- IG-19030 -->		
		<xsl:for-each select="Comments">
			<xsl:variable name="varComments" select="normalize-space(.)"/>
			<xsl:variable name="iteration">
				<xsl:value-of select="position()"/>
			</xsl:variable>
			<xsl:choose>
				<!-- always first Comment to PUR -->
				<xsl:when test="$varComments != '' and $iteration eq '1'">
					<xsl:call-template name="FTXLoop">
						<xsl:with-param name="FTXData" select="$varComments"/>
						<xsl:with-param name="FTXQual" select="'PUR'"/>
						<xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
					</xsl:call-template>
				</xsl:when>
				<!-- After 1st comment,following  comments should go to AAI. and If '@type' is null pass space value. to create first D_4440-->
				<xsl:when test="$varComments != '' and $iteration gt '1'">
					<xsl:variable name="ACBtype">
						<xsl:choose>
							<xsl:when test="@type = '' or not(exists(@type))">
								<xsl:text>  </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space(@type)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="FTXLoop">
						<xsl:with-param name="FTXData" select="$varComments"/>
						<xsl:with-param name="domain" select="$ACBtype"/>
						<xsl:with-param name="FTXQual" select="'AAI'"/>
						<xsl:with-param name="langCode" select="normalize-space(@xml:lang)"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		<!--  Shipping Instruction Description -->
		<xsl:for-each select="ShipTo/TransportInformation">
			<xsl:variable name="SIDesc" select="normalize-space(ShippingInstructions/Description)"/>
			<xsl:if test="$SIDesc != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$SIDesc"/>
					<xsl:with-param name="FTXQual" select="'TRA'"/>
					<xsl:with-param name="langCode" select="normalize-space(ShippingInstructions/Description/@xml:lang)"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<!--  Tax Description -->
		<xsl:variable name="TaxDesc" select="normalize-space(Tax/Description)"/>
		<xsl:if test="$TaxDesc != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$TaxDesc"/>
				<xsl:with-param name="FTXQual" select="'TXD'"/>
				<xsl:with-param name="langCode" select="normalize-space(Tax/Description/@xml:lang)"/>
			</xsl:call-template>
		</xsl:if>
		<!-- TermsOfDeliveryCode -->
		<xsl:if test="TermsOfDelivery/TermsOfDeliveryCode/@value = 'Other'">
			<xsl:variable name="TODCode" select="normalize-space(TermsOfDelivery/TermsOfDeliveryCode)"/>
			<xsl:if test="$TODCode != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$TODCode"/>
					<xsl:with-param name="FTXQual" select="'DEL'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- ShippingPaymentMethod -->
		<xsl:if test="TermsOfDelivery/ShippingPaymentMethod/@value = 'Other'">
			<xsl:variable name="SPMethod" select="normalize-space(TermsOfDelivery/ShippingPaymentMethod)"/>
			<xsl:if test="$SPMethod != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$SPMethod"/>
					<xsl:with-param name="FTXQual" select="'PMT'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- TransportTerms -->
		<xsl:if test="TermsOfDelivery/TransportTerms/@value = 'Other'">
			<xsl:variable name="SPMethod" select="normalize-space(TermsOfDelivery/TransportTerms)"/>
			<xsl:if test="$SPMethod != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$SPMethod"/>
					<xsl:with-param name="FTXQual" select="'DIN'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- ControlKeys -->
		<xsl:variable name="OCInstruction" select="normalize-space(ControlKeys/OCInstruction/@value)"/>
		<xsl:if test="$OCInstruction != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$OCInstruction"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'OCValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- OCLowerTimeTolerance -->
		<xsl:variable name="OCLowerTimeTolerance" select="normalize-space(ControlKeys/OCInstruction/Lower/Tolerances/TimeTolerance[@type = 'days']/@limit)"/>
		<xsl:if test="$OCLowerTimeTolerance != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$OCLowerTimeTolerance"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'OCLowerTimeToleranceInDays'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- OCUpperTimeTolerance -->
		<xsl:variable name="OCUpperTimeTolerance" select="normalize-space(ControlKeys/OCInstruction/Upper/Tolerances/TimeTolerance[@type = 'days']/@limit)"/>
		<xsl:if test="$OCUpperTimeTolerance != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$OCUpperTimeTolerance"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'OCUpperTimeToleranceInDays'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- ASNInstruction -->
		<xsl:variable name="ASNInstruction" select="normalize-space(ControlKeys/ASNInstruction/@value)"/>
		<xsl:if test="$ASNInstruction != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$ASNInstruction"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'ASNValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- InvoiceInstruction -->
		<xsl:variable name="INVValue" select="normalize-space(ControlKeys/InvoiceInstruction/@value)"/>
		<xsl:if test="$INVValue != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$INVValue"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'INVValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- SESInstruction -->
		<xsl:variable name="SESInstruction" select="normalize-space(ControlKeys/SESInstruction/@value)"/>
		<xsl:if test="$SESInstruction != ''">
			<xsl:call-template name="FTXLoop">
				<xsl:with-param name="FTXData" select="$SESInstruction"/>
				<xsl:with-param name="FTXQual" select="'SIN'"/>
				<xsl:with-param name="domain" select="'SESValue'"/>
				<xsl:with-param name="langCode" select="'no'"/>
			</xsl:call-template>
		</xsl:if>
		<!-- ORI Return item -->
		<xsl:if test="normalize-space(@isReturn) = 'yes'">
			<xsl:variable name="ReturnItem" select="normalize-space(@isReturn)"/>
			<xsl:if test="$ReturnItem != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$ReturnItem"/>
					<xsl:with-param name="FTXQual" select="'ORI'"/>
					<xsl:with-param name="domain" select="'Return Item'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- ORI DeliveryCompleted -->
		<xsl:if test="$isChangeOrder = 'true' and normalize-space(@isDeliveryCompleted) = 'yes'">
			<xsl:variable name="Deliverycompleted" select="normalize-space(@isDeliveryCompleted)"/>
			<xsl:if test="$Deliverycompleted != ''">
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="$Deliverycompleted"/>
					<xsl:with-param name="FTXQual" select="'ORI'"/>
					<xsl:with-param name="domain" select="'Delivery is completed'"/>
					<xsl:with-param name="langCode" select="'no'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--  ItemOutIndustry/QualityInfo  -->
		<!--<xsl:if test="ItemOutIndustry/QualityInfo/@requiresQualityProcess!='yes' and  exists(ItemOutIndustry/QualityInfo[IdReference])">-->
		<xsl:if
			test="ItemOutIndustry/QualityInfo[not(exists(@requiresQualityProcess))] and ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType' or @domain = 'controlCode']">
			<xsl:variable name="IDreflist">
				<IDreflist>
					<xsl:if test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/@identifier) != ''">
						<IDref>
							<value>
								<xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/@identifier)"/>
							</value>
						</IDref>
					</xsl:if>
					<xsl:if test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/Description) != ''">
						<IDref>
							<value>
								<xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'certificateType']/Description)"/>
							</value>
						</IDref>
					</xsl:if>
					<xsl:if test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/@identifier) != ''">
						<IDref>
							<value>
								<xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/@identifier)"/>
							</value>
						</IDref>
					</xsl:if>
					<xsl:if test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/Description) != ''">
						<IDref>
							<value>
								<xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain = 'controlCode']/Description)"/>
							</value>
						</IDref>
					</xsl:if>
				</IDreflist>
			</xsl:variable>
			<xsl:value-of select="$IDreflist"/>
			<S_FTX>
				<D_4451>QQD</D_4451>
				<C_C108>
					<D_4440>no</D_4440>
					<xsl:for-each select="$IDreflist/IDreflist/IDref">
						<xsl:element name="{concat('D_4440', '_', position()+1)}">
							<xsl:value-of select="value"/>
						</xsl:element>
					</xsl:for-each>
				</C_C108>
			</S_FTX>
		</xsl:if>
	</xsl:template>
	<xsl:template name="formatAmount">
		<xsl:param name="amount"/>
		<xsl:variable name="tempAmount" select="replace($amount, ',', '')"/>
		<xsl:choose>
			<xsl:when test="$tempAmount castable as xs:decimal">
				<xsl:value-of select="xs:decimal($tempAmount)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$tempAmount"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="formatQty">
		<xsl:param name="qty"/>
		<xsl:variable name="tempQty" select="replace($qty, ',', '')"/>
		<xsl:choose>
			<xsl:when test="$tempQty castable as xs:decimal">
				<xsl:value-of select="xs:decimal($tempQty)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$tempQty"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
