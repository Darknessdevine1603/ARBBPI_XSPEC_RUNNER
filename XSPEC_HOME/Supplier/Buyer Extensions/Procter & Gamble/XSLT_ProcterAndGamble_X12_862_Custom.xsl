<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>

	<xsl:template match="//source"/>

	<!-- Extension Start  -->

	<xsl:template match="//M_862/G_N1[last()]">
		<xsl:copy-of select="."/>
		<xsl:if test="normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'Supplying Vendor/Manufacturer']) != ''">
			<G_N1>
				<S_N1>
					<D_98>SE</D_98>
					<D_66>92</D_66>
					<D_67>
						<xsl:value-of select="substring(normalize-space(//cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'Supplying Vendor/Manufacturer']), 0, 80)"/>
					</D_67>
				</S_N1>
			</G_N1>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//M_862/G_LIN">
		<xsl:variable name="lineNum" select="S_LIN/D_350"/>

		<xsl:variable name="extrinsicMRP" select="normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'MRP Controller'])"/>

		<xsl:variable name="extrinsicSchDep">
			<ListOfDates>
				<xsl:for-each select="/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[ends-with(@name, 'Departure from source')]">
					<ScheduleLineDepartureDate>
						<ScheduleLineNumber>
							<xsl:value-of select="normalize-space(substring-before(substring-after(normalize-space(@name), 'Schedule Line '), ' ETS'))"/>
						</ScheduleLineNumber>
						<DepartureDate>
							<xsl:value-of select="normalize-space(./text())"/>
						</DepartureDate>
					</ScheduleLineDepartureDate>
				</xsl:for-each>
			</ListOfDates>
		</xsl:variable>

		<xsl:variable name="extrinsicSchArr">
			<ListOfDates>
				<xsl:for-each select="/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[ends-with(@name, 'estimated arrival at port')]">
					<ScheduleLineArrivalDate>
						<ScheduleLineNumber>
							<xsl:value-of select="normalize-space(substring-before(substring-after(normalize-space(@name), 'Schedule Line '), ' ETA'))"/>
						</ScheduleLineNumber>
						<ArrivalDate>
							<xsl:value-of select="normalize-space(./text())"/>
						</ArrivalDate>
					</ScheduleLineArrivalDate>
				</xsl:for-each>
			</ListOfDates>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$extrinsicMRP != '' or (count($extrinsicSchDep/ListOfDates/ScheduleLineDepartureDate) &gt; 0) or (count($extrinsicSchArr/ListOfDates/ScheduleLineArrivalDate) &gt; 0)">
				<G_LIN>
					<xsl:copy-of select="S_QTY/preceding-sibling::*"/>
					<xsl:copy-of select="S_QTY"/>
					<xsl:copy-of select="S_REF"/>

					<!-- Extrinsic 1 -->
					<xsl:choose>
						<xsl:when test="$extrinsicMRP != ''">
							<S_PER>
								<D_366>SC</D_366>
								<D_93>
									<xsl:value-of select="substring(normalize-space(/Combined/source/cXML/Request/OrderRequest/ItemOut[@lineNumber = $lineNum]/ItemDetail/Extrinsic[@name = 'MRP Controller']), 1, 60)"/>
								</D_93>
							</S_PER>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="S_PER"/>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:copy-of select="S_SDP"/>

					<xsl:choose>
						<xsl:when test="count($extrinsicSchDep/ListOfDates/ScheduleLineDepartureDate) &gt; 0 or count($extrinsicSchArr/ListOfDates/ScheduleLineArrivalDate) &gt; 0">
							<xsl:for-each select="G_FST">
								<xsl:variable name="schLineNum">
									<xsl:choose>
										<xsl:when test="starts-with(S_FST/D_127, '0') or string-length(S_FST/D_127) &gt; 4">
											<xsl:value-of select="S_FST/D_127"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(S_FST/D_127, '0000')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$extrinsicSchDep/ListOfDates/ScheduleLineDepartureDate[ScheduleLineNumber = $schLineNum] or $extrinsicSchArr/ListOfDates/ScheduleLineArrivalDate[ScheduleLineNumber = $schLineNum]">
										<G_FST>
											<xsl:copy-of select="S_FST"/>
											<xsl:if test="$extrinsicSchDep/ListOfDates/ScheduleLineDepartureDate[ScheduleLineNumber = $schLineNum]/DepartureDate != ''">
												<S_DTM>
													<D_374>011</D_374>
													<D_373>
														<xsl:value-of select="replace(substring($extrinsicSchDep/ListOfDates/ScheduleLineDepartureDate[ScheduleLineNumber = $schLineNum]/DepartureDate, 1, 10), '-', '')"/>
													</D_373>
												</S_DTM>
											</xsl:if>
											<xsl:if test="$extrinsicSchArr/ListOfDates/ScheduleLineArrivalDate[ScheduleLineNumber = $schLineNum]/ArrivalDate != ''">
												<S_DTM>
													<D_374>017</D_374>
													<D_373>
														<xsl:value-of select="replace(substring($extrinsicSchArr/ListOfDates/ScheduleLineArrivalDate[ScheduleLineNumber = $schLineNum]/ArrivalDate, 1, 10), '-', '')"/>
													</D_373>
												</S_DTM>
											</xsl:if>
											<xsl:copy-of select="S_DTM[D_374 != '011' and D_374 != '017']"/>
											<xsl:copy-of select="S_DTM[last()]/following-sibling::*"/>
										</G_FST>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="G_FST"/>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:copy-of select="G_SHP"/>
					<xsl:copy-of select="S_TD1"/>
					<xsl:copy-of select="S_TD3"/>
					<xsl:copy-of select="S_TD5"/>
				</G_LIN>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
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
