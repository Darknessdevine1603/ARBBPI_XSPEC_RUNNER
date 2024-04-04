<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="//source"/>
	<!-- Extension Start  -->
	<xsl:template match="S_OTI">
		<xsl:variable name="sCode" select="normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/Status/@code)"/>
		<xsl:variable name="type"
			select="normalize-space(lower-case(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/@type))"/>
		<S_OTI>

			<D_110>
				<xsl:choose>
					<xsl:when test="$sCode = '200' and $type = 'declined'">IR</xsl:when>
					<xsl:when test="$sCode = '202' and $type = 'accepted'">IA</xsl:when>
					<xsl:when test="$sCode = '211' and $type = 'accepted'">IC</xsl:when>
					<xsl:when test="$sCode = '206' and $type = 'acceptedwithchanges'">IC</xsl:when>
					<xsl:when test="$sCode = '206' and $type = 'declined'">IC</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="D_110"/>
					</xsl:otherwise>
				</xsl:choose>
			</D_110>
			<D_128>SI</D_128>
			<xsl:copy-of select="D_127"/>
			<xsl:copy-of select="D_127/following-sibling::*"/>
		</S_OTI>
		<xsl:if
			test="
				normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type = 'PO']/Comments) != ''
				and /Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type = 'PM']">
			<S_REF>
				<D_128>PO</D_128>

				<D_352>
					<xsl:value-of
						select="normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type = 'PO']/Comments)"
					/>
				</D_352>
			</S_REF>
		</xsl:if>
		<xsl:if
			test="normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type = 'PM']/Comments) != ''">
			<S_REF>
				<D_128>PM</D_128>

				<D_352>
					<xsl:value-of
						select="normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type = 'PM']/Comments)"
					/>
				</D_352>
			</S_REF>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//FunctionalGroup/M_824/G_OTI">


		<xsl:if
			test="
				normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
				'FR']/Comments[1]) != ''">
			<G_N1>
				<S_N1>
					<D_98>
						<xsl:value-of select="'FR'"/>
					</D_98>
					<D_93>
						<xsl:value-of
							select="
								normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type
								= 'FR']/Comments[1])"
						/>
					</D_93>
					<xsl:if
						test="
							normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
							'FR']/Comments[2]) != ''">
						<D_66>92</D_66>
						<D_67>
							<xsl:value-of
								select="
									normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
									'FR']/Comments[2])"
							/>
						</D_67>
					</xsl:if>
				</S_N1>
			</G_N1>

		</xsl:if>
		<xsl:if
			test="
				normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
				'SU']/Comments[1]) != ''">
			<G_N1>
				<S_N1>
					<D_98>
						<xsl:value-of select="'SU'"/>
					</D_98>
					<D_93>
						<xsl:value-of
							select="
								normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type
								= 'SU']/Comments[1])"
						/>
					</D_93>
					<xsl:if
						test="
							normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
							'SU']/Comments[2]) != ''">
						<D_66>92</D_66>
						<D_67>
							<xsl:value-of
								select="
									normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
									'SU']/Comments[2])"
							/>
						</D_67>
					</xsl:if>
				</S_N1>
			</G_N1>
		</xsl:if>
		<xsl:if
			test="normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type = 'WH']/Comments[1]) != ''">
			<G_N1>
				<S_N1>
					<D_98>
						<xsl:value-of select="'YE'"/>
					</D_98>
					<D_93>
						<xsl:value-of
							select="
								normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type
								= 'WH']/Comments[1])"
						/>
					</D_93>
					<xsl:if
						test="
							normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
							'WH']/Comments[2]) != ''">
						<D_66>92</D_66>
						<D_67>
							<xsl:value-of
								select="
									normalize-space(/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type =
									'WH']/Comments[2])"
							/>
						</D_67>
					</xsl:if>
				</S_N1>
			</G_N1>

		</xsl:if>
		<G_OTI>
			<xsl:apply-templates select="S_OTI"/>
			<xsl:copy-of select="S_OTI/following-sibling::*"/>

			<xsl:for-each select="/Combined/source/cXML/Request/StatusUpdateRequest/DocumentStatus/ItemStatus[@type = 'TED']">
				<xsl:if test="string-join((Comments)[. != ''], ' ') != '' or ReferenceDocumentInfo/@lineNumber">

					<xsl:variable name="comments" select="string-join((Comments)[. != ''], ' ')"/>
					<xsl:variable name="StrLen" select="string-length(normalize-space($comments))"/>
					<xsl:call-template name="TEDLoop">
						<xsl:with-param name="Desc" select="normalize-space($comments)"/>
						<xsl:with-param name="StrLen" select="$StrLen"/>
						<xsl:with-param name="Pos" select="1"/>
						<xsl:with-param name="CurrentEndPos" select="1"/>
						<xsl:with-param name="LineNum" select="ReferenceDocumentInfo/@lineNumber"/>
					</xsl:call-template>


				</xsl:if>

			</xsl:for-each>

		</G_OTI>




	</xsl:template>
	<xsl:template name="TEDLoop">
		<xsl:param name="Desc"/>
		<xsl:param name="StrLen"/>
		<xsl:param name="Pos"/>
		<xsl:param name="CurrentEndPos"/>
		<xsl:param name="LineNum"/>
		<xsl:variable name="Length" select="$Pos + 60"/>

		<G_TED>
			<S_TED>
				<D_647>ZZZ</D_647>
				<xsl:if test="$Desc != ''">
					<D_3>
						<xsl:value-of select="substring($Desc, $Pos, 60)"/>
					</D_3>
				</xsl:if>
			</S_TED>
			<xsl:if test="$LineNum != ''">
				<S_NTE>
					<D_363>
						<xsl:text>LIN</xsl:text>
					</D_363>
					<D_352>
						<xsl:value-of select="$LineNum"/>
					</D_352>
				</S_NTE>
			</xsl:if>
		</G_TED>
		<xsl:if test="$Length &lt; $StrLen">
			<xsl:call-template name="TEDLoop">
				<xsl:with-param name="Pos" select="$Length"/>
				<xsl:with-param name="Desc" select="$Desc"/>
				<xsl:with-param name="StrLen" select="$StrLen"/>
				<xsl:with-param name="CurrentEndPos" select="$Pos"/>
				<xsl:with-param name="LineNum" select="$LineNum"/>
			</xsl:call-template>
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
