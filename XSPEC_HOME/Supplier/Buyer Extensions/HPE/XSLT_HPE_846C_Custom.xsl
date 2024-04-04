<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>


	<xsl:template match="//source"/>
	<!-- Extension Start  -->	
	<xsl:template match="S_BIA">
		<xsl:copy-of select="."/>		
		<S_REF>
			<D_128>43</D_128>
			<xsl:if test="//cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID != ''">
				<D_352>
					<xsl:value-of select="substring(//cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID,1,80)"/>
					
				</D_352>
			</xsl:if>
		</S_REF>
	</xsl:template>
	
	<xsl:template match="G_LIN">
		<G_LIN>
					<xsl:for-each select=".">
						<xsl:variable name="line">							
							<xsl:value-of select="(G_QTY/G_REF/S_REF[D_128='IX']/C_C040[D_128='LI']/D_127)[1]"/>												
						</xsl:variable>
						<xsl:apply-templates select="S_LIN"/>
						<xsl:apply-templates select="S_PID"/>						
						<xsl:if test="//ProductActivityMessage/ProductActivityDetails/ConsignmentMovement[ProductMovementItemIDInfo/@movementLineNumber = $line]/SubtotalAmount/Money">
						<S_MEA>
							<D_737>BC</D_737>
							<D_739>								
								<xsl:value-of select="//ProductActivityMessage/ProductActivityDetails/ConsignmentMovement[ProductMovementItemIDInfo/@movementLineNumber = $line]/SubtotalAmount/Money"/>								
							</D_739>
						</S_MEA>
						</xsl:if>
						<xsl:apply-templates select="S_PKG"/>
						<xsl:apply-templates select="S_DTM"/>
						<xsl:apply-templates select="S_CTP"/>
						<xsl:if test="//ProductActivityMessage/ProductActivityDetails/ConsignmentMovement[ProductMovementItemIDInfo/@movementLineNumber = $line]/SubtotalAmount/Money/@currency!=''">
						<S_CUR>
							<D_98>SE</D_98>
							<D_100>
								<xsl:value-of select="//ProductActivityMessage/ProductActivityDetails/ConsignmentMovement[ProductMovementItemIDInfo/@movementLineNumber = $line]/SubtotalAmount/Money/@currency"/>
							</D_100>
						</S_CUR>
						</xsl:if>
						<xsl:apply-templates select="S_SAC"/>						
						<xsl:apply-templates select="S_REF"/>						          
						<xsl:apply-templates select="S_PER"/>
						<xsl:apply-templates select="S_SDQ"/>
						<xsl:apply-templates select="S_MAN"/>
						<xsl:apply-templates select="S_UIT"/>
						<xsl:apply-templates select="S_CS"/>
						<xsl:apply-templates select="S_DD"/>
						<xsl:apply-templates select="S_G53"/>
						<xsl:apply-templates select="S_PCT"/>
						<xsl:apply-templates select="S_LDT"/>
						<xsl:apply-templates select="G_LM"/>
						<xsl:apply-templates select="G_SLN"/>						
						<xsl:apply-templates select="G_QTY"/>
						<xsl:apply-templates select="G_N1"/>
					</xsl:for-each>			
		</G_LIN>
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
