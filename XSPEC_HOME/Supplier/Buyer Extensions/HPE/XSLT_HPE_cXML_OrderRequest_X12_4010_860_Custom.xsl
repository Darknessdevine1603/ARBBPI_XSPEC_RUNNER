<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
	<xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
	<!--<xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>-->
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<!-- Header Extrinsic -->

	<xsl:template match="//M_860/S_REF[D_127 = 'ultimateCustomerReferenceID']">
		<xsl:if
			test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'ultimateCustomerReferenceID']) != ''">
			<S_REF>
				<D_128>CO</D_128>
				<D_127>
					<xsl:value-of
						select="substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'ultimateCustomerReferenceID']),1,30)"
					/>
				</D_127>
			</S_REF>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//M_860/S_REF[D_127 = 'customerReferenceID']">
		<xsl:if
			test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'customerReferenceID']) != ''">
			<S_REF>
				<D_128>ZG</D_128>
				<D_127>
					<xsl:value-of
						select="substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'customerReferenceID']),1,30)"
					/>
				</D_127>
			</S_REF>
		</xsl:if>
	</xsl:template>
	<xsl:template match="//M_860/S_REF[D_127 = 'additionalReferenceID']">
		<xsl:if
			test="normalize-space(//OrderRequestHeader/Extrinsic[@name = 'additionalReferenceID']) != ''">
			<S_REF>
				<D_128>GV</D_128>
				<D_127>
					<xsl:value-of
						select="substring(normalize-space(//OrderRequestHeader/Extrinsic[@name = 'additionalReferenceID']),1,30)"
					/>
				</D_127>
			</S_REF>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//M_860/S_FOB">
		<S_FOB>
			<xsl:copy-of select="D_146, D_309, D_352"/>
			<D_334>ZZ</D_334>
			<D_335>
				<xsl:value-of
					select="normalize-space(//OrderRequestHeader/TermsOfDelivery/TransportTerms/@value)"/>
			</D_335>
			<xsl:copy-of select="D_309_2, D_352_2, D_54, D_352_3"/>
		</S_FOB>
	</xsl:template>

	<xsl:template match="//M_860/G_N1[S_N1/D_98 = 'ZZ']">
		<xsl:choose>
			<xsl:when
				test="S_N1/D_67 = normalize-space(//OrderRequestHeader/Contact[@role = 'ShipVia']/@addressID)">
				<G_N1>
					<S_N1>
						<D_98>IC</D_98>
						<xsl:copy-of select="S_N1/D_98/following-sibling::*"/>
					</S_N1>
					<xsl:copy-of select="S_N1/following-sibling::*"/>
				</G_N1>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="//M_860/G_POC/S_REF[last()]">
		<xsl:variable name="linNum">
			<xsl:value-of select="../S_POC/D_350"/>
		</xsl:variable>
		<xsl:copy-of select="."/>
		<xsl:if
			test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber =
			$linNum]/ItemOutIndustry/ReferenceDocumentInfo[lower-case(DocumentInfo/@documentType)='hpe sales order']/@lineNumber) != ''">
			<S_REF>
				<D_128>ZG</D_128>
				<D_127>HPE Sales Line</D_127>
				<D_352>
					<xsl:value-of
						select="substring(normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber =
						$linNum]/ItemOutIndustry/ReferenceDocumentInfo[lower-case(DocumentInfo/@documentType) ='hpe sales order']/@lineNumber),1,80)"
					/>
				</D_352>
			</S_REF>
		</xsl:if>
		
		<xsl:for-each
			select="//cXML/Request/OrderRequest/ItemOut[@lineNumber = $linNum]/ItemOutIndustry/ReferenceDocumentInfo">
			<xsl:if
				test="
				normalize-space(DocumentInfo/@documentType) != '' and
				normalize-space(DocumentInfo/@documentID) != ''">
				<S_REF>
					<D_128>ZG</D_128>
					<D_127>
						<xsl:value-of select="substring(normalize-space(DocumentInfo/@documentType),1,30)"/>
					</D_127>
					<D_352>
						<xsl:value-of select="substring(normalize-space(DocumentInfo/@documentID),1,80)"/>
					</D_352>
					
				</S_REF>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template match="//M_860/G_POC/S_DTM[last()]">
		<xsl:variable name="linNumD">
			<xsl:value-of select="../S_POC/D_350"/>
		</xsl:variable>
		<xsl:copy-of select="."/>
		<xsl:if
			test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $linNumD]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate) != ''">
			<xsl:call-template name="createDTM">
				<xsl:with-param name="D374_Qual">AB2</xsl:with-param>
				<xsl:with-param name="cXMLDate">
					<xsl:value-of
						select="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $linNumD]/ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo/@documentDate)"
					/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<xsl:if
			test="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $linNumD]/ItemOutIndustry/ReferenceDocumentInfo/DateInfo[@type = 'confirmedDeliveryDate']/@date) != ''">
			<xsl:call-template name="createDTM">
				<xsl:with-param name="D374_Qual">055</xsl:with-param>
				<xsl:with-param name="cXMLDate">
					<xsl:value-of
						select="normalize-space(//cXML/Request/OrderRequest/ItemOut[@lineNumber = $linNumD]/ItemOutIndustry/ReferenceDocumentInfo/DateInfo[@type = 'confirmedDeliveryDate']/@date)"
					/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<xsl:template name="createDTM">
		<xsl:param name="D374_Qual"/>
		<xsl:param name="cXMLDate"/>
		<S_DTM>
			<D_374>
				<xsl:value-of select="$D374_Qual"/>
			</D_374>
			<D_373>
				<xsl:value-of select="replace(substring($cXMLDate, 0, 11), '-', '')"/>
			</D_373>
			<xsl:if test="replace(substring($cXMLDate, 12, 8), ':', '') != ''">
				<D_337>
					<xsl:value-of select="replace(substring($cXMLDate, 12, 8), ':', '')"/>
				</D_337>
			</xsl:if>
			<xsl:variable name="timeZone"
				select="replace(replace(substring($cXMLDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
			<xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
				<D_623>
					<xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"
					/>
				</D_623>
			</xsl:if>
		</S_DTM>
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
