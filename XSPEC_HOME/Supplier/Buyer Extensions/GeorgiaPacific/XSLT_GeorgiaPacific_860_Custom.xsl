<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	
   <xsl:template match="//M_860/G_POC/S_POC">
		<xsl:variable name="lineNum" select="D_350"/>
		<xsl:choose>
		   <xsl:when test="not(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemID/BuyerPartID)!='') and /Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemDetail/Extrinsic[@name='customerPartNumber']!=''">
		      <S_POC>					
               <xsl:call-template name="AddItemPart">
						<xsl:with-param name="PO1Segment" select="."/>
						<xsl:with-param name="newPartQual" select="'BP'"/>
                  <xsl:with-param name="newPartValue" select="(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber=$lineNum]/ItemDetail/Extrinsic[@name='customerPartNumber'])[1]"/>
					</xsl:call-template>
		      </S_POC>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
   <!-- Extension Ends -->
	<xsl:template match="//Combined">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="//target">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="AddItemPart">
		<xsl:param name="newPartQual"/>
		<xsl:param name="newPartValue"/>
		<xsl:param name="PO1Segment"/>
		<xsl:variable name="countParts" select="count($PO1Segment/*[starts-with(name(), 'D_235')])"/>
		<xsl:variable name="newPosition" select="concat('_', string($countParts+1))"/>
		<xsl:variable name="lastElementName" select="concat('D_234_', $countParts)"/>
		<xsl:choose>
			<xsl:when test="$countParts!=0">
				<xsl:for-each select="$PO1Segment/*[name()!=$lastElementName]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
				<xsl:copy-of select="$PO1Segment/*[name()=$lastElementName]"/>
				<xsl:if test="$newPartValue!='' and $newPartQual!=''">
						<xsl:element name="{concat('D_235', $newPosition)}">
							<xsl:value-of select="$newPartQual"/>
						</xsl:element>
						<xsl:element name="{concat('D_234', $newPosition)}">
							<xsl:value-of select="$newPartValue"/>
						</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$newPartValue!=''">
						<xsl:element name="D_235">
							<xsl:value-of select="$newPartQual"/>
						</xsl:element>
						<xsl:element name="D_234">
							<xsl:value-of select="$newPartValue"/>
						</xsl:element>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>