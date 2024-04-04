<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>	
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->
	
	<xsl:template match="//M_ORDERS/S_FTX[D_4451 = 'AAI'][1]">
		<xsl:choose>
			<xsl:when test="//OrderRequestHeader/Comments[1]/@type != ''">
				<xsl:variable name="ACBtype">
					<xsl:value-of select="normalize-space(//OrderRequestHeader/Comments[1]/@type)"/>
				</xsl:variable>
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="normalize-space(//OrderRequestHeader/Comments[1])"/>
					<xsl:with-param name="domain" select="$ACBtype"/>
					<xsl:with-param name="FTXQual" select="'ACB'"/>
					<xsl:with-param name="langCode" select="normalize-space(//OrderRequestHeader/Comments[1]/@xml:lang)"/>
				</xsl:call-template>				
			</xsl:when>
			<xsl:otherwise>				
				<xsl:copy-of select="."></xsl:copy-of>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="//M_ORDERS/S_FTX[D_4451 = 'AAI'][2]">
		<xsl:choose>
			<xsl:when test="//OrderRequestHeader/Comments[1]/@type != ''">
			</xsl:when>
			<xsl:otherwise>				
				<xsl:copy-of select="."></xsl:copy-of>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="//M_ORDERS/G_SG25/S_FTX[D_4451 = 'AAI'][1]">
		<xsl:variable name="lineNum" select="count(../preceding-sibling::G_SG25) + 1"/>
		<xsl:choose>
			<xsl:when test="//OrderRequest/ItemOut[$lineNum]/Comments[1]/@type != ''">
				<xsl:variable name="ACBtype">
					<xsl:value-of select="normalize-space(//OrderRequest/ItemOut[$lineNum]/Comments[1]/@type)"/>
				</xsl:variable>
				<xsl:call-template name="FTXLoop">
					<xsl:with-param name="FTXData" select="normalize-space(//OrderRequest/ItemOut[$lineNum]/Comments[1])"/>
					<xsl:with-param name="domain" select="$ACBtype"/>
					<xsl:with-param name="FTXQual" select="'ACB'"/>
					<xsl:with-param name="langCode" select="normalize-space(//OrderRequest/ItemOut[$lineNum]/Comments[1]/@xml:lang)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."></xsl:copy-of>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="//M_ORDERS/G_SG25/S_FTX[D_4451 = 'AAI'][2]">
		<xsl:variable name="lineNum" select="count(../preceding-sibling::G_SG25) + 1"/>
		<xsl:choose>
			<xsl:when test="//OrderRequest/ItemOut[$lineNum]/Comments[1]/@type != ''">
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."></xsl:copy-of>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="G_SG2[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="not(exists(//G_SG2[S_NAD/D_3035='SU'])) and normalize-space(//OrderRequestHeader/Extrinsic[@name='partyAdditionalID'])!=''">
			<G_SG2>
				<S_NAD>
					<D_3035>SU</D_3035>
				</S_NAD>
				<G_SG3>
					<S_RFF>
						<C_C506>
							<D_1153>ACD</D_1153>
							<D_1154><xsl:value-of select="substring(normalize-space(//OrderRequestHeader/Extrinsic[@name='partyAdditionalID']),1,35)"/></D_1154>
						</C_C506>
					</S_RFF>
				</G_SG3>
			</G_SG2>
		</xsl:if>
	</xsl:template>

	<xsl:template name="FTXLoop">
		<xsl:param name="FTXQual"/>
		<xsl:param name="FTXData"/>
		<xsl:param name="domain"/>
		<xsl:param name="langCode"/>
		<xsl:if test="string-length($FTXData) &gt; 0">
			<xsl:variable name="C108">
				<C_C108>
					<xsl:if test="substring($FTXData, 1, 70) != ''">
						<D_4440>
							<xsl:value-of select="$domain"/>
						</D_4440>
						<xsl:variable name="pendingFTX">
							<xsl:value-of select="$FTXData"/>
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
				<D_3453>
					<xsl:choose>
						<xsl:when test="$langCode != ''">
							<xsl:value-of select="upper-case(substring($langCode, 1, 2))"/>
						</xsl:when>
						<xsl:otherwise>EN</xsl:otherwise>
					</xsl:choose>
				</D_3453>
			</S_FTX>
			<xsl:variable name="ftxLen" select="string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>
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
