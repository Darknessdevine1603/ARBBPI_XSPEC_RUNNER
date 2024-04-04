<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->
	<xsl:template match="//M_ORDERS/S_FTX[D_4451 = 'ZZZ'][C_C108/D_4440='Terms and Condition']"/>

	<xsl:template match="//M_ORDERS/G_SG25[1]">
		<xsl:if
			test="//cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'Terms and Condition']">
			<xsl:call-template name="FTXSG24">
				<xsl:with-param name="FTXData"
					select="//cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'Terms and Condition']"
				/>
			</xsl:call-template>
		</xsl:if>
		<xsl:copy-of select="."/>
	</xsl:template>
	
		
		

	<xsl:template name="FTXSG24">
		<xsl:param name="FTXData"/>		
		<xsl:if test="string-length($FTXData) &gt; 0">
			<xsl:choose>
				<!-- if string length is more than 1750 create 5 FTX in one sg24-->
				<xsl:when test="string-length($FTXData) &gt; 1750">
					<xsl:variable name="temp">
						<xsl:call-template name="rTrim">
							<xsl:with-param name="inData" select="substring($FTXData, 1, 1750)"/>
						</xsl:call-template>
					</xsl:variable>
					<G_SG24>
						<S_RCS>
							<D_7293>3</D_7293>
						</S_RCS>
						<xsl:call-template name="FTXTerms">
							<xsl:with-param name="FTXData" select="$temp"/>
						</xsl:call-template>
					</G_SG24>
					<xsl:variable name="tempLength">
						<xsl:value-of select="string-length($temp)"/>
					</xsl:variable>
					<xsl:if test="substring($FTXData, $tempLength + 1) != ''">
						<xsl:call-template name="FTXSG24">
							<xsl:with-param name="FTXData">
								<xsl:value-of select="substring($FTXData, $tempLength + 1)"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
				<!-- if string length is less than 1750 create less than or equal to 5 FTX in one Sg24-->
				<xsl:otherwise>
					<xsl:variable name="temp">
						<xsl:value-of select="$FTXData"/>
					</xsl:variable>
					<G_SG24>
						<S_RCS>
							<D_7293>3</D_7293>
						</S_RCS>
						<xsl:call-template name="FTXTerms">
							<xsl:with-param name="FTXData" select="$temp"/>
						</xsl:call-template>
					</G_SG24>
				</xsl:otherwise>

			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template name="FTXTerms">
		<xsl:param name="FTXData"/>
		<xsl:if test="string-length($FTXData) &gt; 0">
			<xsl:choose>
				<!-- if string length is more than 350 create 5 FTX -->
				<xsl:when test="string-length($FTXData) &gt; 350">
					<xsl:variable name="temp">
						<!-- no trim -->
						<xsl:value-of select="substring($FTXData, 1, 350)"/>
					</xsl:variable>					
					<S_FTX>
						<D_4451>ABE</D_4451>
						<xsl:call-template name="FTXExtrinsic">
							<xsl:with-param name="FTXName" select="./@name"/>
							<xsl:with-param name="FTXData" select="$temp"/>
						</xsl:call-template>
					</S_FTX>

					<xsl:variable name="tempLength">
						<xsl:value-of select="string-length($temp)"/>
					</xsl:variable>
					<xsl:if test="substring($FTXData, $tempLength + 1) != ''">
						<xsl:call-template name="FTXTerms">
							<xsl:with-param name="FTXData">
								<xsl:value-of select="substring($FTXData, $tempLength + 1)"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
				<!-- if string length is less than 350 create les than 5 FTX -->
				<xsl:otherwise>
					<xsl:variable name="temp">
						<!-- no trim -->
						<xsl:value-of select="substring($FTXData, 1, 350)"/>
					</xsl:variable>
					<S_FTX>
						<D_4451>ABE</D_4451>
						<xsl:call-template name="FTXExtrinsic">
							<xsl:with-param name="FTXName" select="./@name"/>
							<xsl:with-param name="FTXData" select="$temp"/>
						</xsl:call-template>
					</S_FTX>

					<xsl:variable name="tempLength">
						<xsl:value-of select="string-length($temp)"/>
					</xsl:variable>
					<xsl:if test="substring($FTXData, $tempLength + 1) != ''">
						<xsl:call-template name="FTXTerms">
							<xsl:with-param name="FTXData">
								<xsl:value-of select="substring($FTXData, $tempLength + 1)"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>
	<xsl:template name="FTXExtrinsic">
		<xsl:param name="FTXName"/>
		<xsl:param name="FTXData"/>
		<xsl:if test="string-length($FTXData) &gt; 0">
			<xsl:variable name="C108">				
				<C_C108>
					<xsl:if test="substring($FTXData, 1, 60) != ''">
						<xsl:variable name="temp">
							<xsl:value-of select="substring($FTXData, 1, 70)"/>
						</xsl:variable>
						<D_4440>
							<xsl:value-of select="$temp"/>
						</D_4440>
						<xsl:variable name="pendingFTX"
							select="substring($FTXData, string-length($temp) + 1)"/>
						<xsl:if test="string-length($pendingFTX) &gt; 0">
							<xsl:variable name="temp">
								<xsl:value-of select="substring($pendingFTX, 1, 70)"/>
							</xsl:variable>
							<D_4440_2>
								<xsl:value-of select="$temp"/>
							</D_4440_2>
							<xsl:variable name="pendingFTX"
								select="substring($pendingFTX, string-length($temp) + 1)"/>
							<xsl:if test="string-length($pendingFTX) &gt; 0">
								<xsl:variable name="temp">
									<xsl:value-of select="substring($pendingFTX, 1, 70)"/>
								</xsl:variable>
								<D_4440_3>
									<xsl:value-of select="$temp"/>
								</D_4440_3>
								<xsl:variable name="pendingFTX"
									select="substring($pendingFTX, string-length($temp) + 1)"/>
								<xsl:if test="string-length($pendingFTX) &gt; 0">
									<xsl:variable name="temp">
										<xsl:value-of select="substring($pendingFTX, 1, 70)"/>
									</xsl:variable>
									<D_4440_4>
										<xsl:value-of select="$temp"/>
									</D_4440_4>
									<xsl:variable name="pendingFTX"
										select="substring($pendingFTX, string-length($temp) + 1)"/>
									<xsl:if test="string-length($pendingFTX) &gt; 0">
										<xsl:variable name="temp">
											<xsl:value-of select="substring($pendingFTX, 1, 70)"/>
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

			<xsl:copy-of select="$C108"/>
			<xsl:variable name="ftxLen"
				select="string-length($C108//D_4440) + string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>			
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
					<xsl:with-param name="inData"
						select="substring($inData, 1, string-length($inData) - 1)"/>
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
