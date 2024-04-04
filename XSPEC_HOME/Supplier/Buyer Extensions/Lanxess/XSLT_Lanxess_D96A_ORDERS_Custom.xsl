<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

	<xsl:template match="//source"/>
	<!-- Extension Start  -->

	<!-- Header Extensions -->
	<xsl:template match="//M_ORDERS/S_FTX[D_4451 = 'ZZZ'][C_C108/D_4440 = 'purchaseConditions']">
		<xsl:choose>
			<xsl:when test="normalize-space(//OrderRequestHeader/Extrinsic/URL/@name) != ''">
				<S_FTX>
					<D_4451>ZZZ</D_4451>
					<C_C108>
						<D_4440>purchaseConditions</D_4440>
						<D_4440_2>URL name</D_4440_2>
						<D_4440_3>
							<xsl:value-of select="normalize-space(substring(normalize-space(//OrderRequestHeader/Extrinsic/URL/@name), 1, 70))"/>
						</D_4440_3>
						<D_4440_4>
							<xsl:value-of select="C_C108/D_4440_2"/>
						</D_4440_4>
						<xsl:if test="C_C108/D_4440_3">
							<D_4440_5>
								<xsl:value-of select="C_C108/D_4440_3"/>
							</D_4440_5>
						</xsl:if>
					</C_C108>
				</S_FTX>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="//M_ORDERS/S_FTX[C_C108/D_4440 != 'purchaseConditions'][last()]">
		<xsl:copy-of select="."/>
		<xsl:for-each select="//OrderRequestHeader/PaymentTerm/Extrinsic[@name = 'PaymentTermDescription']">
			<xsl:variable name="paymentterm" select="normalize-space(.)"/>
			<S_FTX>
				<D_4451>ZZZ</D_4451>
				<C_C108>
					<D_4440>PaymentTermDescription</D_4440>
					<D_4440_2>
						<xsl:value-of select="normalize-space(substring($paymentterm, 1, 70))"/>
					</D_4440_2>
					<xsl:if test="normalize-space(substring($paymentterm, 71, 70)) != ''">
						<D_4440_3>
							<xsl:value-of select="normalize-space(substring($paymentterm, 71, 70))"/>
						</D_4440_3>
					</xsl:if>
					<xsl:if test="normalize-space(substring($paymentterm, 141, 70)) != ''">
						<D_4440_4>
							<xsl:value-of select="normalize-space(substring($paymentterm, 141, 70))"/>
						</D_4440_4>
					</xsl:if>
					<xsl:if test="normalize-space(substring($paymentterm, 211, 70)) != ''">
						<D_4440_5>
							<xsl:value-of select="normalize-space(substring($paymentterm, 211, 70))"/>
						</D_4440_5>
					</xsl:if>
				</C_C108>
			</S_FTX>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="//M_ORDERS/G_SG2[S_NAD/D_3035 = 'BT']">
		<xsl:element name="G_SG2">
			<xsl:copy-of select="S_NAD"/>
			<xsl:copy-of select="S_LOC"/>
			<xsl:copy-of select="S_FII"/>
			<xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'buyerVatID']) != ''">
				<G_SG3>
					<S_RFF>
						<C_C506>
							<D_1153>VA</D_1153>
							<D_1154>
								<xsl:value-of select="normalize-space(substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'buyerVatID']), 1, 35))"/>
							</D_1154>
						</C_C506>
					</S_RFF>
				</G_SG3>
			</xsl:if>
			<xsl:copy-of select="G_SG3"/>
			<xsl:copy-of select="G_SG4"/>
			<xsl:copy-of select="G_SG5"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//M_ORDERS/G_SG2[last()]">
		<!--  Added index to avoid duplicates -->
		<xsl:copy-of select="."/>
		<xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'deliveryReference']) != '' and normalize-space(//OrderRequestHeader/Extrinsic[@name = 'clientNumber']) != ''">
			<G_SG2>
				<S_NAD>
					<D_3035>PD</D_3035>
				</S_NAD>
				<G_SG5>
					<S_CTA>
						<D_3139>PD</D_3139>
						<C_C056>
							<D_3412>
								<xsl:value-of select="normalize-space(substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'deliveryReference']), 1, 35))"/>
							</D_3412>
						</C_C056>
					</S_CTA>
					<S_COM>
						<C_C076>
							<D_3148>
								<xsl:value-of select="normalize-space(substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'clientNumber']), 1, 35))"/>
							</D_3148>
							<D_3155>TE</D_3155>
						</C_C076>
					</S_COM>
				</G_SG5>
			</G_SG2>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//M_ORDERS/G_SG9[last()]">
		<xsl:copy-of select="."/>
		<xsl:call-template name="createSG11"/>
	</xsl:template>
	<xsl:template match="//M_ORDERS/G_SG8[not(exists(../G_SG9))][last()]">
		<xsl:copy-of select="."/>
		<xsl:call-template name="createSG11"/>
	</xsl:template>
	<xsl:template match="//M_ORDERS/G_SG7[not(exists(../G_SG8))][last()]">
		<xsl:copy-of select="."/>
		<xsl:call-template name="createSG11"/>
	</xsl:template>

	<!-- Line Item Extensions -->
	<xsl:template match="//G_SG25/G_SG35[last()]">
		<!--  Added index to avoid duplicates -->
		<xsl:copy-of select="."/>
		<xsl:variable name="suppPartID" select="../S_LIN/C_C212[D_7143 = 'VN']/D_7140"/>
		<xsl:variable name="itemDet" select="//ItemOut[ItemID/SupplierPartID = $suppPartID]/ItemDetail"/>
		<xsl:if test="normalize-space($itemDet/Extrinsic[@name = 'receiverID']) != ''">
			<G_SG35>
				<S_NAD>
					<D_3035>UC</D_3035>
					<C_C082>
						<D_3039>
							<xsl:value-of select="normalize-space(substring(normalize-space($itemDet/Extrinsic[@name = 'receiverID']), 1, 35))"/>
						</D_3039>
					</C_C082>
					<xsl:variable name="Name" select="normalize-space($itemDet/Extrinsic[@name = 'DeliveryAddress'])"/>
					<xsl:if test="$Name != ''">
						<C_C058>
							<D_3124>
								<xsl:value-of select="normalize-space(substring($Name, 1, 35))"/>
							</D_3124>
							<xsl:if test="normalize-space(substring($Name, 36, 35)) != ''">
								<D_3124_2>
									<xsl:value-of select="normalize-space(substring($Name, 36, 35))"/>
								</D_3124_2>
							</xsl:if>
							<xsl:if test="normalize-space(substring($Name, 71, 35)) != ''">
								<D_3124_3>
									<xsl:value-of select="normalize-space(substring($Name, 71, 35))"/>
								</D_3124_3>
							</xsl:if>
							<xsl:if test="normalize-space(substring($Name, 106, 35)) != ''">
								<D_3124_4>
									<xsl:value-of select="normalize-space(substring($Name, 106, 35))"/>
								</D_3124_4>
							</xsl:if>
							<xsl:if test="normalize-space(substring($Name, 141, 35)) != ''">
								<D_3124_5>
									<xsl:value-of select="normalize-space(substring($Name, 141, 35))"/>
								</D_3124_5>
							</xsl:if>
						</C_C058>
					</xsl:if>
				</S_NAD>
				<xsl:if test="normalize-space($itemDet/Extrinsic[@name = 'customerReferenceNo']) != '' or normalize-space($itemDet/Extrinsic[@name = 'locationWithinEquipment']) != ''">
					<G_SG38>
						<S_CTA>
							<D_3139>IC</D_3139>
						</S_CTA>
						<xsl:if test="normalize-space($itemDet/Extrinsic[@name = 'customerReferenceNo']) != ''">
							<S_COM>
								<C_C076>
									<D_3148>
										<xsl:value-of select="normalize-space(substring(normalize-space($itemDet/Extrinsic[@name = 'customerReferenceNo']), 1, 35))"/>
									</D_3148>
									<D_3155>TE</D_3155>
								</C_C076>
							</S_COM>
						</xsl:if>
						<xsl:if test="normalize-space($itemDet/Extrinsic[@name = 'locationWithinEquipment']) != ''">
							<S_COM>
								<C_C076>
									<D_3148>
										<xsl:value-of select="normalize-space(substring(normalize-space($itemDet/Extrinsic[@name = 'locationWithinEquipment']), 1, 35))"/>
									</D_3148>
									<D_3155>EM</D_3155>
								</C_C076>
							</S_COM>
						</xsl:if>
					</G_SG38>
				</xsl:if>
			</G_SG35>
		</xsl:if>
	</xsl:template>

	<!-- Common Template -->

	<xsl:template name="createSG11">
		<xsl:if test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTerm']) != '' and normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTermDesc']) != ''">
			<xsl:variable name="TTCode" select="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTerm'])"/>
			<xsl:variable name="desc" select="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'incoTermDesc'])"/>
			<G_SG11>
				<S_TOD>
					<C_C100>
						<D_4053>
							<xsl:value-of select="normalize-space(substring($TTCode, 1, 3))"/>
						</D_4053>
						<D_4052>
							<xsl:value-of select="normalize-space(substring($desc, 1, 70))"/>
						</D_4052>
					</C_C100>
				</S_TOD>
			</G_SG11>
		</xsl:if>
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
