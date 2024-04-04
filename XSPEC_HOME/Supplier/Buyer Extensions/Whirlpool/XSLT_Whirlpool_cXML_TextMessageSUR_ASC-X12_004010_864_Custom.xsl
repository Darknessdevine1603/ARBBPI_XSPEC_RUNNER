<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	
	
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->
	<xsl:template match="//M_864/S_BMG">
		<S_BMG>
			<xsl:element name="D_353">00</xsl:element>
			<xsl:copy-of select="D_352,D_640"></xsl:copy-of>			
		</S_BMG>
	</xsl:template>
	
	<xsl:template match="//M_864/G_MIT">
		<G_MIT>
			<xsl:choose>
				<xsl:when test="S_MIT/D_127 = 'PBM'">
					<S_MIT>
						<xsl:copy-of select="S_MIT/D_127"/>
						<xsl:if
							test="normalize-space(//StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType) != ''">
							<D_352>
								<xsl:value-of
									select="//StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType"
								/>
							</D_352>
						</xsl:if>
					</S_MIT>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="S_MIT"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:copy-of select="G_N1"/>
			
			<xsl:if test="//StatusUpdateRequest/DocumentStatus/ItemStatus/@type = 'SU'">
				<xsl:variable name="itemtype">SU</xsl:variable>
				<xsl:call-template name="createN1">
					<xsl:with-param name="type" select="$itemtype"/>
				</xsl:call-template>
			</xsl:if>
			
			<xsl:if test="//StatusUpdateRequest/DocumentStatus/ItemStatus/@type = 'FR'">
				<xsl:variable name="itemtype">FR</xsl:variable>
				<xsl:call-template name="createN1">
					<xsl:with-param name="type" select="$itemtype"/>
				</xsl:call-template>
			</xsl:if>
			
			<xsl:copy-of select="S_MSG"/>
			
		</G_MIT>
	</xsl:template>
	
	
	<xsl:template name="createN1">
		<xsl:param name="type"/>
		<G_N1>
			<S_N1>
				<D_98>
					<xsl:value-of select="$type"/>
				</D_98>
				<xsl:if
					test="//StatusUpdateRequest/DocumentStatus/ItemStatus[@type = $type]/Comments[1]">
					<D_93>
						<xsl:value-of
							select="//StatusUpdateRequest/DocumentStatus/ItemStatus[@type = $type]/Comments[1]"
						/>
					</D_93>
				</xsl:if>
				<xsl:if
					test="string-length(normalize-space(//StatusUpdateRequest/DocumentStatus/ItemStatus[@type = $type]/Comments[2])) &gt; 1">
					<D_66>92</D_66>
					<D_67>
						<xsl:value-of
							select="substring(normalize-space(//StatusUpdateRequest/DocumentStatus/ItemStatus[@type = $type]/Comments[2]), 1, 80)"
						/>
					</D_67>
				</xsl:if>
			</S_N1>
		</G_N1>
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
