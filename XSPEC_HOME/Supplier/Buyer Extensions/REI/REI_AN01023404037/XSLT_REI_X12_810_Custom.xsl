<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pidx="http://www.pidx.org/schemas/v1.61" exclude-result-prefixes="pidx">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
		<InvoiceDetailItem>
			<xsl:variable name="lineNum" select="@invoiceLineNumber"/>
			<xsl:apply-templates select="@* | node()">
				<xsl:with-param name="lineNum" select="$lineNum"/>
			</xsl:apply-templates>
			<xsl:if test="//M_810/G_IT1/S_IT1[D_350 = $lineNum]/D_639 != ''">
				<Extrinsic>
					<xsl:attribute name="name">priceType</xsl:attribute>
					<xsl:value-of select="//M_810/G_IT1/S_IT1[D_350 = $lineNum]/D_639"/>
				</Extrinsic>
			</xsl:if>
		</InvoiceDetailItem>
	</xsl:template>
	<xsl:template match="//InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[last()]">
		<xsl:copy-of select="."/>
		<InvoicePartner>
			<Contact>
				<xsl:attribute name="addressID">
					<xsl:value-of select="//M_810/S_REF[D_128 = 'IA']/D_127"/>
				</xsl:attribute>
				<xsl:attribute name="role">billFrom</xsl:attribute>
				<Name xml:lang="en-US"/>
			</Contact>
		</InvoicePartner>
	</xsl:template>
	<xsl:template match="InvoiceDetailItemReference">
		<xsl:param name="lineNum"/>
		<InvoiceDetailItemReference>
			<xsl:copy-of select="@*"/>
		   <ItemID>
		      <xsl:choose>
		         <xsl:when test="//M_810/G_IT1/S_REF[D_128='FJ']/D_127=$lineNum">
		            <SupplierPartID>
		               <xsl:value-of select="//M_810/G_IT1[S_REF[D_128='FJ'][D_127= $lineNum]]/S_IT1/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'VA']][1]"/>
		            </SupplierPartID>
		            <xsl:copy-of select="ItemID/SupplierPartAuxiliaryID"></xsl:copy-of>
		            <xsl:if test="//M_810/G_IT1[S_REF[D_128='FJ'][D_127= $lineNum]]/S_IT1/child::*[starts-with(name(), D_235) and text() = 'IN']">
		               <BuyerPartID>
		                  <xsl:value-of select="//M_810/G_IT1[S_REF[D_128='FJ'][D_127= $lineNum]]/S_IT1/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'IN']][1]"/>
		               </BuyerPartID>
		            </xsl:if>
		            <xsl:if test="//M_810/G_IT1[S_REF[D_128='FJ'][D_127= $lineNum]]/S_IT1/child::*[starts-with(name(), D_235) and text() = 'UP']">
		               <IdReference>
		                  <xsl:attribute name="domain">
		                     <xsl:text>UPCConsumerPackageCode</xsl:text>
		                  </xsl:attribute>
		                  <xsl:attribute name="identifier">
		                     <xsl:value-of select="//M_810/G_IT1[S_REF[D_128='FJ'][D_127= $lineNum]]/S_IT1/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'UP']][1]"/>
		                  </xsl:attribute>
		               </IdReference>
		            </xsl:if>
		         </xsl:when>
		         <xsl:otherwise>
		            <SupplierPartID>
		               <xsl:value-of select="//M_810/G_IT1/S_IT1[D_350 = $lineNum]/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'VA']][1]"/>
		            </SupplierPartID>
		            <xsl:copy-of select="ItemID/SupplierPartAuxiliaryID"></xsl:copy-of>
		            <xsl:if test="//M_810/G_IT1/S_IT1[D_350 = $lineNum]/child::*[starts-with(name(), D_235) and text() = 'IN']">
		               <BuyerPartID>
		                  <xsl:value-of select="//M_810/G_IT1/S_IT1[D_350 = $lineNum]/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'IN']][1]"/>
		               </BuyerPartID>
		            </xsl:if>
		            <xsl:if test="//M_810/G_IT1/S_IT1[D_350 = $lineNum]/child::*[starts-with(name(), D_235) and text() = 'UP']">
		               <IdReference>
		                  <xsl:attribute name="domain">
		                     <xsl:text>UPCConsumerPackageCode</xsl:text>
		                  </xsl:attribute>
		                  <xsl:attribute name="identifier">
		                     <xsl:value-of select="//M_810/G_IT1/S_IT1[D_350 = $lineNum]/child::*[starts-with(name(), D_234) and preceding-sibling::*[text() = 'UP']][1]"/>
		                  </xsl:attribute>
		               </IdReference>
		            </xsl:if>
		         </xsl:otherwise>
		      </xsl:choose>
		   </ItemID>
			<xsl:apply-templates select="*[not(self::ItemID)]"/>
		</InvoiceDetailItemReference>
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
