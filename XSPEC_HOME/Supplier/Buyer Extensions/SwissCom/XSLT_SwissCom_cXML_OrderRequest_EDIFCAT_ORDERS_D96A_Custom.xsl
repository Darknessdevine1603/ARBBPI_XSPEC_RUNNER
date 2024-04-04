<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:variable name="Lookup" select="document('cXML_EDILookups_D96A.xml')"/>
	<!--<xsl:include href="Format_CXML_D96A_common.xsl"/>-->

	<xsl:include href="pd:HCIOWNERPID:FORMAT_cXML_0000_UN-EDIFACT_D96A:Binary"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->

	<xsl:template match="//M_ORDERS/G_SG25">

		<xsl:variable name="lineNum">
			<xsl:value-of select="S_LIN/D_1082"/>
		</xsl:variable>

		<G_SG25>
			<xsl:copy-of select="S_LIN, S_PIA, S_IMD, S_MEA, S_QTY, S_PCD, S_ALI, S_DTM"/>

			<xsl:if
				test="//OrderRequest/ItemOut[@lineNumber = $lineNum]/SpendDetail[Extrinsic/@name = 'ServicePeriod']">

				<xsl:if
					test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate) != ''">
					<S_DTM>
						<C_C507>
							<D_2005>194</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate"
									select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@startDate)"
								/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>

				<xsl:if
					test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate) != ''">
					<S_DTM>
						<C_C507>
							<D_2005>206</D_2005>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="DocDate"
									select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/SpendDetail/Extrinsic[@name = 'ServicePeriod']/Period/@endDate)"
								/>
							</xsl:call-template>
						</C_C507>
					</S_DTM>
				</xsl:if>

			</xsl:if>

			<xsl:copy-of select="S_MOA"/>
			<xsl:if
				test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']) != ''">

				<xsl:if
					test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money) != ''">

					<S_MOA>
						<C_C516>
							<D_5025>200</D_5025>
							<D_5004>
								<xsl:value-of
									select="normalize-space(replace(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money), ',', ''))"
								/>
							</D_5004>
							<xsl:if
								test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNum]/BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money/@currency) != ''">
								<D_6345>
									<xsl:value-of
										select="//OrderRequest/ItemOut[@lineNumber = $lineNum]/BlanketItemDetail/Extrinsic[@name = 'ExpectedUnplanned']/Money/@currency"
									/>
								</D_6345>

							</xsl:if>
						</C_C516>
					</S_MOA>
				</xsl:if>
			</xsl:if>
			<xsl:copy-of
				select="S_GIN, S_GIR, S_QVR, S_DOC, S_PAI, S_FTX, G_SG26, G_SG27, G_SG28, G_SG29, G_SG30, G_SG33, G_SG34, G_SG35, G_SG39, G_SG45, G_SG47, G_SG48, G_SG49, G_SG51, G_SG52"
			/>
		</G_SG25>
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
