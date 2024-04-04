<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:004010" exclude-result-prefixes="#all" version="2.0">
	<xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<!--
		Description: map to transform X12 214 to cXML Transport.
		Date: 05/10/2017
		Created: Cinthia Guzman.
		Version: 1.0
	-->
	<xsl:param name="anSupplierANID"/>
	<xsl:param name="anBuyerANID"/>
	<xsl:param name="anProviderANID"/>
	<xsl:param name="anPayloadID"/>
	<xsl:param name="anSharedSecrete"/>
	<xsl:param name="anEnvName"/>
	<xsl:param name="cXMLAttachments"/>
	<xsl:param name="attachSeparator" select="'\|'"/>

	<!-- For local testing -->
	<!--xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>
	<xsl:include href="Format_ASC-X12_CXML_common.xsl"/-->
	<!-- PD references -->
	<xsl:include href="FORMAT_ASC-X12_004010_cXML_0000.xsl"/>
	<xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>

	<xsl:variable name="incoterms" select="tokenize('cfr,cif,cip,cpt,daf,ddp,ddu,deq,des,exw,fas,fca,fob',',')"/>

	<xsl:template match="ns0:*">
		<cXML>
			<xsl:attribute name="payloadID">
				<xsl:value-of select="$anPayloadID"/>
			</xsl:attribute>
			<xsl:attribute name="timestamp">
				<xsl:call-template name="convertToAribaDate">
					<xsl:with-param name="Date">
						<xsl:value-of select="substring(replace(string(current-dateTime()),'-',''),1,8)"/>
					</xsl:with-param>
					<xsl:with-param name="Time">
						<xsl:value-of select="substring(replace(replace(string(current-dateTime()),'-',''),':',''),10,6)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>

			<xsl:call-template name="createcXMLHeader"/>

			<Request>
				<xsl:choose>
					<xsl:when test="$anEnvName='PROD'">
						<xsl:attribute name="deploymentMode">production</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="deploymentMode">test</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<TransportConfirmation>
					<TransportConfirmationHeader>
						<xsl:if test="normalize-space(FunctionalGroup/M_214/S_B10/D_127)!=''">
							<xsl:attribute name="confirmationID">
								<xsl:value-of select="normalize-space(FunctionalGroup/M_214/S_B10/D_127)"/>
							</xsl:attribute>
						</xsl:if>
						<TransportPartner>
							<xsl:attribute name="role">carrier</xsl:attribute>
							<xsl:for-each select="FunctionalGroup/M_214/G_0100">
								<xsl:call-template name="createContact">
									<xsl:with-param name="contact" select="."/>
									<xsl:with-param name="altAddressID" select="normalize-space(../S_B10/D_140)"/>
								</xsl:call-template>
							</xsl:for-each>
						</TransportPartner>
					</TransportConfirmationHeader>
					<TransportReference>
						<xsl:if test="normalize-space(FunctionalGroup/M_214/S_B10/D_145)!=''">
							<xsl:attribute name="requestID">
								<xsl:value-of select="FunctionalGroup/M_214/S_B10/D_145"/>
							</xsl:attribute>
						</xsl:if>
						<DocumentReference>
							<xsl:attribute name="payloadID"/>
						</DocumentReference>
					</TransportReference>
					<xsl:for-each select="FunctionalGroup/M_214/G_0200">
						<xsl:variable name="code">
							<xsl:value-of select="(G_0205/S_AT7/D_1650)[1]"/>
						</xsl:variable>
						<xsl:variable name="consignmentStatus">
							<xsl:value-of select="$Lookup/Lookups/ConsignmentStatusCodes/ConsignmentStatusCode[X12Code=$code]/CXMLCode"/>
						</xsl:variable>
						<ConsignmentConfirmation>
							<xsl:attribute name="consignmentID">
								<xsl:value-of select="S_L11[D_128='CI']/D_127"/>
							</xsl:attribute>
							<xsl:attribute name="consignmentStatus">
								<xsl:value-of select="$consignmentStatus"/>
							</xsl:attribute>
							<xsl:if test="G_0205/S_AT7/D_1650 = 'A3'">
								<xsl:attribute name="rejectionReason">
									<xsl:value-of select="$Lookup/Lookups/ConsignmentStatusCodes/ConsignmentStatusCode[X12Code=G_0205/S_AT7/D_1651]/CXMLCode"/>
								</xsl:attribute>
							</xsl:if>
							<ConsignmentConfirmationHeader>
								<xsl:if test="(S_AT8/D_80)[1]!=''">
									<xsl:attribute name="numberOfPackages">
										<xsl:value-of select="(S_AT8/D_80)[1]"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="S_L11[D_128='UN']">
									<Hazard>
										<xsl:for-each select="S_L11[D_128='UN']">
											<xsl:choose>
												<xsl:when test="D_127='Hazard Description'">
													<Description>
														<xsl:attribute name="xml:lang">
															<xsl:value-of select="'en'"/>
														</xsl:attribute>
														<xsl:value-of select="S_L11[D_128='UN' and D_127='Hazard Description']"/>
													</Description>
												</xsl:when>
												<xsl:otherwise>
													<Classification>
														<xsl:attribute name="domain">
															<xsl:value-of select="D_127"/>
														</xsl:attribute>
														<xsl:value-of select="D_352"/>
													</Classification>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</Hazard>
								</xsl:if>
								<xsl:for-each select="S_AT8">
									<xsl:variable name="wCode">
										<xsl:value-of select="D_187"/>
									</xsl:variable>
									<xsl:variable name="weightCode" select="$Lookup/Lookups/ConsignmentPackageDimensionCodes/ConsignmentPackageDimensionCode[X12Code=$wCode]/CXMLCode"/>
									<xsl:if test="$weightCode!=''">
										<Dimension>
											<xsl:attribute name="quantity">
												<xsl:value-of select="D_81"/>
											</xsl:attribute>
											<xsl:attribute name="type">
												<xsl:value-of select="$weightCode"/>
											</xsl:attribute>
											<xsl:variable name="uomCode" select="D_188"/>
											<UnitOfMeasure>
												<xsl:variable name="lookupResult" select="$Lookup/Lookups/WeightUnitCodes/WeightUnitCode[X12Code=$uomCode]/CXMLCode"/>
												<xsl:choose>
													<xsl:when test="$lookupResult!=''">
														<xsl:value-of select="$lookupResult"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$uomCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</UnitOfMeasure>
										</Dimension>
										<xsl:if test="D_183">
											<Dimension>
												<xsl:attribute name="quantity">
													<xsl:value-of select="D_183"/>
												</xsl:attribute>
												<xsl:attribute name="type">volume</xsl:attribute>
												<xsl:variable name="uomCode" select="D_184"/>
												<UnitOfMeasure>
													<xsl:variable name="lookupResult" select="$Lookup/Lookups/VolumeUnitCodes/VolumeUnitCode[X12Code=$uomCode]/CXMLCode"/>
													<xsl:choose>
														<xsl:when test="$lookupResult!=''">
															<xsl:value-of select="$lookupResult"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$uomCode"/>
														</xsl:otherwise>
													</xsl:choose>
												</UnitOfMeasure>
											</Dimension>
										</xsl:if>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="S_L11[D_128!='UN' and D_128!='CI' and D_128!='CN']">
									<xsl:variable name="rCode" select="D_128"/>
									<xsl:variable name="refCode" select="$Lookup/Lookups/ConsigmentReferenceCodes/ConsigmentReferenceCode[X12Code=$rCode]/CXMLCode"/>
									<xsl:if test="$refCode!=''">
										<ReferenceDocumentInfo>
											<DocumentInfo>
												<xsl:attribute name="documentID">
													<xsl:value-of select="D_127"/>
												</xsl:attribute>
												<xsl:attribute name="documentType">
													<xsl:value-of select="$refCode"/>
												</xsl:attribute>
											</DocumentInfo>
										</ReferenceDocumentInfo>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test="S_L11[D_128='CN']">
									<ShipmentIdentifier>
										<xsl:if test="S_L11[D_128='2I']/D_352!=''">
											<xsl:attribute name="trackingURL">
												<xsl:value-of select="S_L11[D_128='2I']/D_352"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="S_L11[D_128='CN']/D_127!=''">
											<xsl:attribute name="domain">
												<xsl:value-of select="S_L11[D_128='CN']/D_127"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="S_L11[D_128='2I']!=''">
											<xsl:attribute name="trackingNumberDate">
												<xsl:call-template name="convertToAribaDate">
													<xsl:with-param name="Date">
														<xsl:value-of select="substring(S_L11[D_128='2I']/D_127,1,8)"/>
													</xsl:with-param>
													<xsl:with-param name="Time">
														<xsl:value-of select="substring(S_L11[D_128='2I']/D_127,9,6)"/>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
										</xsl:if>
									</ShipmentIdentifier>
								</xsl:if>
								<xsl:if test="($consignmentStatus = 'accepted' or $consignmentStatus='collected')">
									<xsl:if test="G_0205/S_AT7[D_1651='AM']/D_373">
										<xsl:variable name="dateType">
											<xsl:choose>
												<xsl:when test="$consignmentStatus='accepted'">
													<xsl:value-of select="'expectedPickUpDate'"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="'actualPickUpDate'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<OriginConfirmation>
											<DateInfo>
												<xsl:attribute name="type">
													<xsl:value-of select="$dateType"/>
												</xsl:attribute>
												<xsl:attribute name="date">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="Date" select="G_0205/S_AT7[D_1651='AM']/D_373"/>
														<xsl:with-param name="Time" select="G_0205/S_AT7[D_1651='AM']/D_337"/>
														<xsl:with-param name="TimeCode" select="G_0205/S_AT7[D_1651='AM']/D_623"/>
													</xsl:call-template>
												</xsl:attribute>
											</DateInfo>
										</OriginConfirmation>
									</xsl:if>
									<xsl:if test="G_0205/S_AT7[D_1651='AG']/D_373">
										<xsl:variable name="dateType">
											<xsl:value-of select="'expectedDeliveryDate'"/>
										</xsl:variable>
										<DestinationConfirmation>
											<DateInfo>
												<xsl:attribute name="type">
													<xsl:value-of select="$dateType"/>
												</xsl:attribute>
												<xsl:attribute name="date">
													<xsl:call-template name="convertToAribaDate">
														<xsl:with-param name="Date" select="G_0205/S_AT7[D_1651='AG']/D_373"/>
														<xsl:with-param name="Time" select="G_0205/S_AT7[D_1651='AG']/D_337"/>
														<xsl:with-param name="TimeCode" select="G_0205/S_AT7[D_1651='AG']/D_623"/>
													</xsl:call-template>
												</xsl:attribute>
											</DateInfo>
										</DestinationConfirmation>
									</xsl:if>
								</xsl:if>
								<xsl:for-each select="S_K1">
									<Comments>
										<xsl:attribute name="xml:lang">
											<xsl:value-of select="'en'"/>
										</xsl:attribute>
										<xsl:attribute name="type">
											<xsl:value-of select="'reason'"/>
										</xsl:attribute>
										<xsl:value-of select="normalize-space(concat(D_61, ' ', D_61_2))"/>
									</Comments>
								</xsl:for-each>
							</ConsignmentConfirmationHeader>
						</ConsignmentConfirmation>
					</xsl:for-each>
				</TransportConfirmation>
			</Request>
		</cXML>
	</xsl:template>
	<xsl:template match="S_PER">
    <xsl:variable name="PER02">
      <xsl:choose>
        <xsl:when test="D_93 != ''">
          <xsl:value-of select="D_93"/>
        </xsl:when>
        <xsl:otherwise>default</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="D_365_1 = 'EM'">
        <Con>
          <xsl:attribute name="type">Email</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_1)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_1 = 'UR'">
        <Con>
          <xsl:attribute name="type">URL</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_1)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_1 = 'TE'">
        <Con>
          <xsl:attribute name="type">Phone</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, '(')">
                <xsl:value-of select="substring-before(D_364_1, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, '-')">
                <xsl:value-of select="substring-before(D_364_1, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_1, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_1, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_1 = 'FX'">
        <Con>
          <xsl:attribute name="type">Fax</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, '(')">
                <xsl:value-of select="substring-before(D_364_1, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, '-')">
                <xsl:value-of select="substring-before(D_364_1, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_1, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_1, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_1, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_1, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="D_365_2 = 'EM'">
        <Con>
          <xsl:attribute name="type">Email</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_2)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_2 = 'UR'">
        <Con>
          <xsl:attribute name="type">URL</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_2)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_2 = 'TE'">
        <Con>
          <xsl:attribute name="type">Phone</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, '(')">
                <xsl:value-of select="substring-before(D_364_2, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, '-')">
                <xsl:value-of select="substring-before(D_364_2, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_2, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_2, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_2 = 'FX'">
        <Con>
          <xsl:attribute name="type">Fax</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, '(')">
                <xsl:value-of select="substring-before(D_364_2, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, '-')">
                <xsl:value-of select="substring-before(D_364_2, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_2, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_2, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="D_365_3 = 'EM'">
        <Con>
          <xsl:attribute name="type">Email</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_3)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_3 = 'UR'">
        <Con>
          <xsl:attribute name="type">URL</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_3)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_3 = 'TE'">
        <Con>
          <xsl:attribute name="type">Phone</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, '(')">
                <xsl:value-of select="substring-before(D_364_3, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, '-')">
                <xsl:value-of select="substring-before(D_364_3, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_3, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_3, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_3 = 'FX'">
        <Con>
          <xsl:attribute name="type">Fax</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, '(')">
                <xsl:value-of select="substring-before(D_364_3, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, '-')">
                <xsl:value-of select="substring-before(D_364_3, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_3, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_3, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="S_G61">
    <xsl:variable name="PER02">
      <xsl:choose>
        <xsl:when test="D_93 != ''">
          <xsl:value-of select="D_93"/>
        </xsl:when>
        <xsl:otherwise>default</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="D_365 = 'EM'">
        <Con>
          <xsl:attribute name="type">Email</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365 = 'UR'">
        <Con>
          <xsl:attribute name="type">URL</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365 = 'TE'">
        <Con>
          <xsl:attribute name="type">Phone</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364, '(')">
                <xsl:value-of select="substring-before(D_364, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364, '-')">
                <xsl:value-of select="substring-before(D_364, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364, '-')">
                <xsl:value-of select="substring-after(D_364, '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="D_364"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365 = 'FX'">
        <Con>
          <xsl:attribute name="type">Fax</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364, '(')">
                <xsl:value-of select="substring-before(D_364, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364, '-')">
                <xsl:value-of select="substring-before(D_364, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="D_365_2 = 'EM'">
        <Con>
          <xsl:attribute name="type">Email</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_2)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_2 = 'UR'">
        <Con>
          <xsl:attribute name="type">URL</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_2)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_2 = 'TE'">
        <Con>
          <xsl:attribute name="type">Phone</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, '(')">
                <xsl:value-of select="substring-before(D_364_2, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, '-')">
                <xsl:value-of select="substring-before(D_364_2, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_2, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_2, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_2 = 'FX'">
        <Con>
          <xsl:attribute name="type">Fax</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, '(')">
                <xsl:value-of select="substring-before(D_364_2, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, '-')">
                <xsl:value-of select="substring-before(D_364_2, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_2, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_2, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_2, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_2, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="D_365_3 = 'EM'">
        <Con>
          <xsl:attribute name="type">Email</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_3)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_3 = 'UR'">
        <Con>
          <xsl:attribute name="type">URL</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space(D_364_3)"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_3 = 'TE'">
        <Con>
          <xsl:attribute name="type">Phone</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, '(')">
                <xsl:value-of select="substring-before(D_364_3, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, '-')">
                <xsl:value-of select="substring-before(D_364_3, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_3, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_3, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
      <xsl:when test="D_365_3 = 'FX'">
        <Con>
          <xsl:attribute name="type">Fax</xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$PER02"/>
          </xsl:attribute>
          <xsl:attribute name="cCode">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, '(')">
                <xsl:value-of select="substring-before(D_364_3, '(')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, '-')">
                <xsl:value-of select="substring-before(D_364_3, '-')"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="aCode">
            <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"/>
          </xsl:attribute>
          <xsl:attribute name="num">
            <xsl:choose>
              <xsl:when test="contains(D_364_3, 'x')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
              </xsl:when>
              <xsl:when test="contains(D_364_3, 'X')">
                <xsl:value-of select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-after(D_364_3, '-')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ext">
            <xsl:value-of select="substring-after(D_364_3, 'x')"/>
          </xsl:attribute>
        </Con>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="createContact">
    <xsl:param name="contact"/>
    <xsl:param name="altAddressID"/>
    <xsl:param name="sprole"/>
    <xsl:param name="buildAddressElement"/>
    <xsl:variable name="rootContact">
      <xsl:choose>
        <xsl:when test="$buildAddressElement = 'true'">
          <xsl:text>Address</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Contact</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="role">
      <xsl:value-of select="$contact/S_N1/D_98"/>
    </xsl:variable>
    <xsl:if test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
      <xsl:element name="{$rootContact}">
        <xsl:if test="not($buildAddressElement)">
          <xsl:attribute name="role">
            <xsl:choose>
              <xsl:when test="$sprole = 'QN' and $role = 'BY'">buyerParty</xsl:when>
              <xsl:when test="$sprole = 'QN' and $role = 'SU'">sellerparty</xsl:when>
              <xsl:when test="$sprole = 'QN' and $role = 'FR'">senderparty</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
        <xsl:variable name="addrDomain" select="$contact/S_N1/D_66"/>
        <xsl:variable name="addrDomainCode"
          select="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode"/>
        <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
          <xsl:if test="$addrDomainCode != ''">
            <xsl:attribute name="addressIDDomain">
              <xsl:value-of select="$addrDomainCode"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$altAddressID != '' and $addrDomainCode = 'SCAC'">
            <xsl:attribute name="addressID">
              <xsl:value-of select="$altAddressID"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="$contact/S_N1/D_67 != ''">
            <xsl:attribute name="addressID">
              <xsl:value-of select="$contact/S_N1/D_67"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <xsl:element name="Name">
          <xsl:attribute name="xml:lang">en</xsl:attribute>
          <xsl:value-of select="$contact/S_N1/D_93"/>
        </xsl:element>
        <!-- PostalAddress -->
        <xsl:if
          test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
          <xsl:element name="PostalAddress">
            <xsl:for-each select="$contact/S_N2">
              <xsl:element name="DeliverTo">
                <xsl:value-of select="D_93"/>
              </xsl:element>
              <xsl:if test="D_93_2 != ''">
                <xsl:element name="DeliverTo">
                  <xsl:value-of select="D_93_2"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$contact/S_N3">
              <xsl:element name="Street">
                <xsl:value-of select="D_166"/>
              </xsl:element>
              <xsl:if test="D_166_2 != ''">
                <xsl:element name="Street">
                  <xsl:value-of select="D_166_2"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
            <xsl:if test="$contact/S_N4"/>
            <xsl:element name="City">
              <!-- <xsl:attribute name="cityCode"/> -->
              <xsl:value-of select="$contact/S_N4/D_19"/>
            </xsl:element>
            <xsl:variable name="sCode">
              <!--xsl:value-of select="$contact/S_N4/D_156"/-->
              <xsl:choose>
                <xsl:when
                  test="$contact/S_N4/D_310 != '' and not($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA')">
                  <xsl:value-of select="$contact/S_N4/D_310"/>
                </xsl:when>
                <xsl:when test="$contact/S_N4/D_156 != ''">
                  <xsl:value-of select="$contact/S_N4/D_156"/>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:if test="$sCode != ''">
              <xsl:element name="State">
                <xsl:if test="$contact/S_N4/D_156 != ''">
                  <xsl:attribute name="isoStateCode">
                    <xsl:value-of select="$sCode"/>
                  </xsl:attribute>
                </xsl:if>
                <!--xsl:value-of select="$lookups/Lookups/States/State[stateCode = $stateCode]/stateName"/-->
                <xsl:choose>
                  <xsl:when
                    test="(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA') and $Lookup/Lookups/States/State[stateCode = $sCode]/stateName != '')">
                    <xsl:value-of
                      select="$Lookup/Lookups/States/State[stateCode = $sCode]/stateName"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$sCode"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$contact/S_N4/D_116 != ''">
              <xsl:element name="PostalCode">
                <xsl:value-of select="$contact/S_N4/D_116"/>
              </xsl:element>
            </xsl:if>
            <xsl:variable name="isoCountryCode">
              <xsl:value-of select="$contact/S_N4/D_26"/>
            </xsl:variable>
            <xsl:element name="Country">
              <xsl:attribute name="isoCountryCode">
                <xsl:value-of select="$isoCountryCode"/>
              </xsl:attribute>
              <xsl:value-of
                select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"
              />
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:variable name="contactList">
          <xsl:apply-templates select="$contact/S_PER"/>
          <xsl:apply-templates select="$contact/S_G61"/>
        </xsl:variable>
        <xsl:for-each select="$contactList/Con[@type = 'Email']">
          <xsl:sort select="@name"/>
          <xsl:element name="Email">
            <xsl:attribute name="name">
              <xsl:value-of select="./@name"/>
            </xsl:attribute>
            <xsl:value-of select="./@value"/>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$contactList/Con[@type = 'Phone']">
          <xsl:sort select="@name"/>
          <xsl:variable name="cCode" select="@cCode"/>
          <xsl:element name="Phone">
            <xsl:attribute name="name">
              <xsl:value-of select="./@name"/>
            </xsl:attribute>
            <xsl:element name="TelephoneNumber">
              <xsl:element name="CountryCode">
                <xsl:attribute name="isoCountryCode">
                  <xsl:choose>
                    <xsl:when
                      test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                      <xsl:value-of
                        select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                      />
                    </xsl:when>
                    <xsl:otherwise>US</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="replace(@cCode, '\+', '')"/>
              </xsl:element>
              <xsl:element name="AreaOrCityCode">
                <xsl:value-of select="@aCode"/>
              </xsl:element>
              <xsl:element name="Number">
                <xsl:value-of select="@num"/>
              </xsl:element>
              <xsl:if test="@ext != ''">
                <xsl:element name="Extension">
                  <xsl:value-of select="@ext"/>
                </xsl:element>
              </xsl:if>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$contactList/Con[@type = 'Fax']">
          <xsl:sort select="@name"/>
          <xsl:variable name="cCode" select="@cCode"/>
          <xsl:element name="Fax">
            <xsl:attribute name="name">
              <xsl:value-of select="./@name"/>
            </xsl:attribute>
            <xsl:element name="TelephoneNumber">
              <xsl:element name="CountryCode">
                <xsl:attribute name="isoCountryCode">
                  <xsl:choose>
                    <xsl:when
                      test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                      <xsl:value-of
                        select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"
                      />
                    </xsl:when>
                    <xsl:otherwise>US</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="replace(@cCode, '\+', '')"/>
              </xsl:element>
              <xsl:element name="AreaOrCityCode">
                <xsl:value-of select="@aCode"/>
              </xsl:element>
              <xsl:element name="Number">
                <xsl:value-of select="@num"/>
              </xsl:element>
              <xsl:if test="@ext != ''">
                <xsl:element name="Extension">
                  <xsl:value-of select="@ext"/>
                </xsl:element>
              </xsl:if>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$contactList/Con[@type = 'URL']">
          <xsl:sort select="@name"/>
          <xsl:element name="URL">
            <xsl:attribute name="name">
              <xsl:value-of select="./@name"/>
            </xsl:attribute>
            <xsl:value-of select="./@value"/>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="S_REF">
          <xsl:choose>
            <xsl:when test="$role = 'RI' and D_128 = 'BAA'">
              <xsl:element name="IdReference">
                <xsl:attribute name="identifier">
                  <xsl:value-of select="D_352"/>
                </xsl:attribute>
                <xsl:attribute name="domain">
                  <xsl:text>SupplierTaxID</xsl:text>
                </xsl:attribute>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="IDRefDomain" select="D_128"/>
              <xsl:choose>
                <xsl:when test="$IDRefDomain = 'ZZ' and D_127 != '' and D_352 != ''">
                  <xsl:element name="IdReference">
                    <xsl:attribute name="identifier">
                      <xsl:value-of select="D_352"/>
                    </xsl:attribute>
                    <xsl:attribute name="domain">
                      <xsl:value-of select="D_127"/>
                    </xsl:attribute>
                  </xsl:element>
                </xsl:when>
                <xsl:when
                  test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode != ''">
                  <xsl:element name="IdReference">
                    <xsl:attribute name="identifier">
                      <xsl:value-of select="D_352"/>
                    </xsl:attribute>
                    <xsl:attribute name="domain">
                      <xsl:value-of
                        select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = $role]/CXMLCode"
                      />
                    </xsl:attribute>
                  </xsl:element>
                </xsl:when>
                <xsl:when
                  test="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode != ''">
                  <xsl:element name="IdReference">
                    <xsl:attribute name="identifier">
                      <xsl:value-of select="D_352"/>
                    </xsl:attribute>
                    <xsl:attribute name="domain">
                      <xsl:value-of
                        select="$Lookup/Lookups/IDReferences/IDReference[X12Code = $IDRefDomain and Role = 'ANY']/CXMLCode"
                      />
                    </xsl:attribute>
                  </xsl:element>
                </xsl:when>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:element>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
