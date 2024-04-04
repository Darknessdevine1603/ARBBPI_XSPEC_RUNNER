<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anISASender"/>
    <xsl:param name="anISASenderQual"/>
    <xsl:param name="anISAReceiver"/>
    <xsl:param name="anISAReceiverQual"/>
    <xsl:param name="anDate"/>
    <xsl:param name="anTime"/>
    <xsl:param name="anICNValue"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anSenderGroupID"/>
    <xsl:param name="anReceiverGroupID"/>
    <xsl:param name="exchange"/>
    <!-- For local testing -->
    <!--xsl:variable name="Lookup" select="document('../../lookups/X12/LOOKUP_ASC-X12_004010.xml')"/>
    <xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/-->
    <!-- PD references -->
    <xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
    <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
    <xsl:template match="/">
        <xsl:variable name="dateNow" select="current-dateTime()"/>
        <ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:862:004010">
            <xsl:call-template name="createISA">
                <xsl:with-param name="dateNow" select="$dateNow"/>
            </xsl:call-template>
            <FunctionalGroup>
                <S_GS>
                    <D_479>SS</D_479>
                    <D_142>
                        <xsl:choose>
                            <xsl:when test="$anSenderGroupID != ''">
                                <xsl:value-of select="$anSenderGroupID"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>ARIBA</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </D_142>
                    <D_124>
                        <xsl:choose>
                            <xsl:when test="$anReceiverGroupID != ''">
                                <xsl:value-of select="$anReceiverGroupID"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>ARIBA</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </D_124>
                    <D_373>
                        <xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
                    </D_373>
                    <D_337>
                        <xsl:value-of select="format-dateTime($dateNow, '[H01][m01][s01]')"/>
                    </D_337>
                    <D_28>
                        <xsl:value-of select="$anICNValue"/>
                    </D_28>
                    <D_455>X</D_455>
                    <D_480>004010</D_480>
                </S_GS>
                <M_862>
                    <S_ST>
                        <D_143>862</D_143>
                        <D_329>0001</D_329>
                    </S_ST>
                    <S_BSS>
                        <xsl:element name="D_353">
                            <xsl:choose>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'new'">00</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">05</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">03</xsl:when>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:element name="D_127">
                            <xsl:choose>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'dropship'">DS</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'rushorder'">RO</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@orderType = 'blanket'">BK</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@orderType = 'release'">RL</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'new'">NE</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">KN</xsl:when>
                                <xsl:when
                                    test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete' and cXML/Request/OrderRequest/OrderRequestHeader/@isInternalVersion = 'yes'"
                                    >IN</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">KN</xsl:when>
                            </xsl:choose>
                        </xsl:element>
                        <D_373>
                            <xsl:value-of select="replace(substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 1, 10), '-', '')"/>
                        </D_373>
                        <D_675>BB</D_675>
                        <D_373_2>
                            <xsl:choose>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate != ''">
                                    <xsl:value-of select="replace(substring(cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate, 1, 10), '-', '')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="replace(substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 1, 10), '-', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </D_373_2>
                        <D_373_3>
                            <xsl:choose>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate != ''">
                                    <xsl:value-of select="replace(substring(cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate, 1, 10), '-', '')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="replace(substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 1, 10), '-', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </D_373_3>
                        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion) != ''">
                            <D_328>
                                <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion), 1, 30)"/>
                            </D_328>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID) != ''">
                                <D_127_2>
                                    <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID), 1, 30)"/>
                                </D_127_2>
                            </xsl:when>
                            <xsl:when test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID) != ''">
                                <D_127_2>
                                    <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 22)"/>
                                </D_127_2>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID) != ''">
                            <D_367>
                                <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID), 1, 30)"/>
                            </D_367>
                        </xsl:if>
                        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID) != ''">
                            <D_324>
                                <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 22)"/>
                            </D_324>
                        </xsl:if>
                    </S_BSS>
                    <xsl:call-template name="createDTM">
                        <xsl:with-param name="D374_Qual">004</xsl:with-param>
                        <xsl:with-param name="cXMLDate">
                            <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@orderDate"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">007</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">036</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">118</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">002</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail/@taxPointDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">983</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail/@taxPointDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail/@paymentDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">707</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail/@paymentDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">070</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">073</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <!-- IG-1229 -->
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'revisionDate'] != ''">
                        <xsl:call-template name="createDTM">
                            <xsl:with-param name="D374_Qual">171</xsl:with-param>
                            <xsl:with-param name="cXMLDate">
                                <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'revisionDate']"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <!-- IG-1229 -->
                    <!-- ShipTo -->
                    <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo">
                        <xsl:call-template name="createN1">
                            <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"/>
                            <xsl:with-param name="mapFOB" select="'true'"/>
                            <!-- IG-1229-->
                        </xsl:call-template>
                    </xsl:if>
                    <!-- BillTo -->
                    <xsl:call-template name="createN1">
                        <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo"/>
                    </xsl:call-template>
                    <!-- Terms Of Delivery Address -->
                    <xsl:if test="exists(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address)">
                        <xsl:call-template name="createN1">
                            <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery"/>
                        </xsl:call-template>
                    </xsl:if>
                    <!-- Contacts -->
                    <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Contact">
                        <xsl:call-template name="createContact">
                            <xsl:with-param name="party" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <!-- Details -->
                    <xsl:for-each select="cXML/Request/OrderRequest/ItemOut">
                        <xsl:variable name="uom">
                            <xsl:choose>
                                <xsl:when test="ItemDetail/UnitOfMeasure != ''">
                                    <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                                </xsl:when>
                                <xsl:when test="BlanketItemDetail/UnitOfMeasure != ''">
                                    <xsl:value-of select="BlanketItemDetail/UnitOfMeasure"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="unitPrice">
                            <xsl:choose>
                                <xsl:when test="ItemDetail/Extrinsic[@name = 'hideUnitPrice']">0.00</xsl:when>
                                <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideUnitPrice']">0.00</xsl:when>
                                <xsl:when test="ItemDetail/UnitPrice/Money != ''">
                                    <xsl:value-of select="ItemDetail/UnitPrice/Money"/>
                                </xsl:when>
                                <xsl:when test="BlanketItemDetail/UnitPrice/Money != ''">
                                    <xsl:value-of select="BlanketItemDetail/UnitPrice/Money"/>
                                </xsl:when>
                                <xsl:otherwise>0.00</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <G_LIN>
                            <S_LIN>
                                <xsl:if test="./@lineNumber != ''">
                                    <D_350>
                                        <xsl:value-of select="./@lineNumber"/>
                                    </D_350>
                                </xsl:if>
                                <xsl:call-template name="createItemParts">
                                    <xsl:with-param name="itemID" select="ItemID"/>
                                    <xsl:with-param name="itemDetail" select="ItemDetail"/>
                                    <xsl:with-param name="description" select="ItemDetail/Description"/>
                                    <xsl:with-param name="itemCategory" select="./@itemCategory"/>
                                </xsl:call-template>
                                <!--D_235>VP</D_235>								<D_234>									<xsl:choose>										<xsl:when test="normalize-space(ItemID/SupplierPartID)!=''">											<xsl:value-of select="substring(normalize-space(ItemID/SupplierPartID),1,48)"/>										</xsl:when>										<xsl:otherwise>Not Available</xsl:otherwise>									</xsl:choose>								</D_234>								<xsl:if test="normalize-space(ItemID/BuyerPartID)!=''">									<D_235_2>BP</D_235_2>									<D_234_2>										<xsl:value-of select="substring(normalize-space(ItemID/BuyerPartID),1,48)"/>									</D_234_2>								</xsl:if>								<xsl:if test="normalize-space(ItemID/SupplierPartAuxiliaryID)!=''">									<D_235_3>VS</D_235_3>									<D_234_3>										<xsl:value-of select="substring(normalize-space(ItemID/SupplierPartAuxiliaryID),1,48)"/>									</D_234_3>								</xsl:if>								<xsl:if test="normalize-space(ItemDetail/ManufacturerPartID)!=''">									<D_235_4>MG</D_235_4>									<D_234_4>										<xsl:value-of select="substring(normalize-space(ItemDetail/ManufacturerPartID),1,48)"/>									</D_234_4>								</xsl:if>								<xsl:if test="normalize-space(ItemDetail/ManufacturerName)!=''">									<D_235_5>MF</D_235_5>									<D_234_5>										<xsl:value-of select="substring(normalize-space(ItemDetail/ManufacturerName),1,48)"/>									</D_234_5>								</xsl:if>								<xsl:if test="normalize-space(ItemDetail/Classification[1])!=''">									<D_235_6>C3</D_235_6>									<D_234_6>										<xsl:value-of select="substring(normalize-space(ItemDetail/Classification[1]),1,48)"/>									</D_234_6>								</xsl:if>								<xsl:if test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)!=''">									<D_235_7>EN</D_235_7>									<D_234_7>										<xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID),1,48)"/>									</D_234_7>								</xsl:if-->
                            </S_LIN>
                            <S_UIT>
                                <C_C001>
                                    <xsl:choose>
                                        <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                                            <D_355>
                                                <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
                                            </D_355>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <D_355>ZZ</D_355>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </C_C001>
                                <D_212>
                                    <xsl:value-of select="$unitPrice"/>
                                    <!--xsl:choose>										<xsl:when test="substring-before($unitPrice,'.') = '0'">											<xsl:value-of select="format-number($unitPrice,'#')"/>										</xsl:when>										<xsl:otherwise>											<xsl:value-of select="$unitPrice"/>										</xsl:otherwise>									</xsl:choose-->
                                </D_212>
                            </S_UIT>
                            <xsl:for-each select="Packaging">
                                <S_PKG>
                                    <D_349>F</D_349>
                                    <D_753>01</D_753>
                                    <D_559>ZZ</D_559>
                                    <xsl:if test="Description/@type != ''">
                                        <D_754>
                                            <xsl:value-of select="Description/@type"/>
                                        </D_754>
                                    </xsl:if>
                                    <D_352>
                                        <xsl:choose>
                                            <xsl:when test="normalize-space(Description) != ''">
                                                <xsl:value-of select="substring(normalize-space(Description), 1, 80)"/>
                                            </xsl:when>
                                            <xsl:otherwise>Packaging Description Not                                                Provided</xsl:otherwise>
                                        </xsl:choose>
                                    </D_352>
                                </S_PKG>
                            </xsl:for-each>
                            <xsl:if test="./@quantity != ''">
                                <S_QTY>
                                    <D_673>38</D_673>
                                    <D_380>
                                        <xsl:value-of select="./@quantity"/>
                                        <!--xsl:choose>											<xsl:when test="substring-before(./@quantity,'.') = '0'">												<xsl:value-of select="format-number(./@quantity,'#')"/>											</xsl:when>											<xsl:otherwise>												<xsl:value-of select="./@quantity"/>											</xsl:otherwise>										</xsl:choose-->
                                    </D_380>
                                </S_QTY>
                            </xsl:if>
                            <xsl:call-template name="CreateREFList">
                            </xsl:call-template>
                            <xsl:if test="normalize-space(./Contact[@role = 'BuyerPlannerCode']/IdReference[@domain = 'BuyerPlannerCode']/@identifier) != ''">
                                <S_PER>
                                    <D_366>SC</D_366>
                                    <D_93>
                                        <xsl:value-of
                                            select="substring(normalize-space(./Contact[@role = 'BuyerPlannerCode']/IdReference[@domain = 'BuyerPlannerCode']/@identifier), 1, 60)"
                                        />
                                    </D_93>
                                </S_PER>
                            </xsl:if>
                            <!-- IG-1229 -->
                            <xsl:for-each select="ScheduleLine">
                                <G_FST>
                                    <S_FST>
                                        <D_380>
                                            <xsl:value-of select="./@quantity"/>
                                            <!--xsl:choose>												<xsl:when test="substring-before(./@quantity,'.') = '0'">													<xsl:value-of select="format-number(./@quantity,'#')"/>												</xsl:when>												<xsl:otherwise>													<xsl:value-of select="./@quantity"/>												</xsl:otherwise>											</xsl:choose-->
                                        </D_380>
                                        <xsl:choose>
                                            <xsl:when test="ScheduleLineReleaseInfo/@commitmentCode = 'firm'">
                                                <D_680>C</D_680>
                                            </xsl:when>
                                            <xsl:when test="ScheduleLineReleaseInfo/@commitmentCode = 'tradeoff'">
                                                <D_680>B</D_680>
                                            </xsl:when>
                                            <xsl:when test="ScheduleLineReleaseInfo/@commitmentCode = 'forecast'">
                                                <D_680>D</D_680>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <D_680>Z</D_680>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <D_681>Z</D_681>
                                        <D_373>
                                            <xsl:value-of select="replace(substring(./@requestedDeliveryDate, 1, 10), '-', '')"/>
                                        </D_373>
                                        <xsl:if test="./@deliveryWindow != ''">
                                            <D_373_2>
                                                <xsl:value-of
                                                    select="replace(string(xs:date(substring(./@requestedDeliveryDate, 1, 10)) + xs:dayTimeDuration(concat('P', ./@deliveryWindow, 'D'))), '-', '')"
                                                />
                                            </D_373_2>
                                        </xsl:if>
                                        <xsl:if test="./@lineNumber != ''">
                                            <D_128>BV</D_128>
                                            <D_127>
                                                <xsl:value-of select="./@lineNumber"/>
                                            </D_127>
                                        </xsl:if>
                                    </S_FST>
                                    <xsl:if test="./@requestedDeliveryDate != ''">
                                        <xsl:call-template name="createDTM">
                                            <xsl:with-param name="D374_Qual">002</xsl:with-param>
                                            <xsl:with-param name="cXMLDate">
                                                <xsl:value-of select="./@requestedDeliveryDate"/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:if>
                                    <xsl:if test="ScheduleLineReleaseInfo">
                                        <S_SDQ>
                                            <xsl:variable name="uomSchRel" select="ScheduleLineReleaseInfo/UnitOfMeasure"/>
                                            <xsl:choose>
                                                <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomSchRel]/X12Code != ''">
                                                    <D_355>
                                                        <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomSchRel]/X12Code"/>
                                                    </D_355>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <D_355>ZZ</D_355>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:if test="ScheduleLineReleaseInfo/@cumulativeScheduledQuantity != ''">
                                                <D_67>
                                                    <xsl:text>CUMULATIVE SCHEDULED QTY</xsl:text>
                                                </D_67>
                                                <D_380>
                                                    <xsl:value-of select="ScheduleLineReleaseInfo/@cumulativeScheduledQuantity"/>
                                                </D_380>
                                            </xsl:if>
                                            <xsl:if test="ScheduleLineReleaseInfo/@receivedQuantity != ''">
                                                <D_67_2>
                                                    <xsl:text>RECEIVED QTY</xsl:text>
                                                </D_67_2>
                                                <D_380_2>
                                                    <xsl:value-of select="ScheduleLineReleaseInfo/@receivedQuantity"/>
                                                </D_380_2>
                                            </xsl:if>
                                        </S_SDQ>
                                    </xsl:if>
                                    <G_JIT>
                                        <S_JIT>
                                            <D_380>
                                                <xsl:value-of select="./@quantity"/>
                                            </D_380>
                                            <xsl:if test="replace(substring(./@requestedDeliveryDate, 12, 8), ':', '') != ''">
                                                <D_337>
                                                    <xsl:value-of select="replace(substring(./@requestedDeliveryDate, 12, 8), ':', '')"/>
                                                </D_337>
                                            </xsl:if>
                                        </S_JIT>
                                    </G_JIT>
                                </G_FST>
                            </xsl:for-each>
                            <xsl:if test="ReleaseInfo != ''">
                                <G_SHP>
                                    <S_SHP>
                                        <D_673>87</D_673>
                                        <D_380>
                                            <xsl:choose>
                                                <xsl:when test="substring-before(ReleaseInfo/@cumulativeReceivedQuantity, '.') = '0'">
                                                    <xsl:value-of select="format-number(ReleaseInfo/@cumulativeReceivedQuantity, '#')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ReleaseInfo/@cumulativeReceivedQuantity"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </D_380>
                                        <xsl:if test="ReleaseInfo/@productionGoAheadEndDate != ''">
                                            <D_374>405</D_374>
                                            <D_373>
                                                <xsl:value-of select="replace(substring(ReleaseInfo/@productionGoAheadEndDate, 1, 10), '-', '')"/>
                                            </D_373>
                                            <xsl:if test="replace(substring(ReleaseInfo/@productionGoAheadEndDate, 12, 8), ':', '') != ''">
                                                <D_337>
                                                    <xsl:value-of select="replace(substring(ReleaseInfo/@productionGoAheadEndDate, 12, 8), ':', '')"/>
                                                </D_337>
                                            </xsl:if>
                                        </xsl:if>
                                        <xsl:if test="ReleaseInfo/@materialGoAheadEndDate != ''">
                                            <D_373_2>
                                                <xsl:value-of select="replace(substring(ReleaseInfo/@materialGoAheadEndDate, 1, 10), '-', '')"/>
                                            </D_373_2>
                                            <xsl:if test="replace(substring(ReleaseInfo/@materialGoAheadEndDate, 12, 8), ':', '') != ''">
                                                <D_337_2>
                                                    <xsl:value-of select="replace(substring(ReleaseInfo/@materialGoAheadEndDate, 12, 8), ':', '')"/>
                                                </D_337_2>
                                            </xsl:if>
                                        </xsl:if>
                                    </S_SHP>
                                    <xsl:for-each select="ReleaseInfo/Extrinsic">
                                        <S_REF>
                                            <D_128>ZZ</D_128>
                                            <D_127>
                                                <xsl:value-of select="substring(normalize-space(./@name), 1, 30)"/>
                                            </D_127>
                                            <xsl:variable name="extDesc" select="normalize-space(.)"/>
                                            <xsl:choose>
                                                <xsl:when test="$extDesc != ''">
                                                    <D_352>
                                                        <xsl:value-of select="substring($extDesc, 1, 80)"/>
                                                    </D_352>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <D_352>
                                                        <xsl:value-of select="substring(normalize-space(./@name), 1, 30)"/>
                                                    </D_352>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </S_REF>
                                    </xsl:for-each>
                                </G_SHP>
                            </xsl:if>
                            <xsl:if test="ReleaseInfo/ShipNoticeReleaseInfo != ''">
                                <G_SHP>
                                    <S_SHP>
                                        <D_673>90</D_673>
                                        <D_380>
                                            <xsl:choose>
                                                <xsl:when test="substring-before(ReleaseInfo/ShipNoticeReleaseInfo/@receivedQuantity, '.') = '0'">
                                                    <xsl:value-of select="format-number(ReleaseInfo/ShipNoticeReleaseInfo/@receivedQuantity, '#')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="ReleaseInfo/ShipNoticeReleaseInfo/@receivedQuantity"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </D_380>
                                        <xsl:if test="ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/@shipNoticeDate != ''">
                                            <D_374>111</D_374>
                                            <D_373>
                                                <xsl:value-of
                                                    select="replace(substring(ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/@shipNoticeDate, 1, 10), '-', '')"
                                                />
                                            </D_373>
                                            <xsl:if
                                                test="replace(substring(ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/@shipNoticeDate, 12, 8), ':', '') != ''">
                                                <D_337>
                                                    <xsl:value-of select="replace(substring(ReleaseInfo/@productionGoAheadEndDate, 12, 8), ':', '')"/>
                                                </D_337>
                                            </xsl:if>
                                        </xsl:if>
                                    </S_SHP>
                                    <xsl:for-each select="ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/IdReference">
                                        <xsl:variable name="domain" select="normalize-space(./@domain)"/>
                                        <xsl:variable name="id" select="normalize-space(./@identifier)"/>
                                        <xsl:if test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain]/X12Code != '' and $id != ''">
                                            <S_REF>
                                                <D_128>
                                                    <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain]/X12Code"/>
                                                </D_128>
                                                <D_127>
                                                    <xsl:value-of select="substring(normalize-space($id), 1, 30)"/>
                                                </D_127>
                                                <xsl:if test="normalize-space(Description) != ''">
                                                    <D_352>
                                                        <xsl:value-of select="substring(normalize-space(Description), 1, 80)"/>
                                                    </D_352>
                                                </xsl:if>
                                            </S_REF>
                                        </xsl:if>
                                    </xsl:for-each>
                                </G_SHP>
                            </xsl:if>
                            <xsl:variable name="routeMode">
                                <xsl:choose>
                                    <xsl:when test="ShipTo/TransportInformation/Route/@method = 'air'">A</xsl:when>
                                    <xsl:when test="ShipTo/TransportInformation/Route/@method = 'motor'">J</xsl:when>
                                    <xsl:when test="ShipTo/TransportInformation/Route/@method = 'rail'">R</xsl:when>
                                    <xsl:when test="ShipTo/TransportInformation/Route/@method = 'ship'">S</xsl:when>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:if test="ShipTo/TransportInformation != '' or $routeMode != ''">
                                <S_TD5>
                                    <D_133>Z</D_133>
                                    <xsl:if test="string-length(normalize-space(ShipTo/TransportInformation/ShippingContractNumber)) &gt; 1">
                                        <D_66>ZZ</D_66>
                                        <D_67>
                                            <xsl:value-of select="substring(normalize-space(ShipTo/TransportInformation/ShippingContractNumber), 1, 80)"/>
                                        </D_67>
                                    </xsl:if>
                                    <xsl:if test="routeMode != ''">
                                        <D_91>
                                            <xsl:value-of select="$routeMode"/>
                                        </D_91>
                                    </xsl:if>
                                    <xsl:if test="normalize-space(ShipTo/TransportInformation/ShippingInstructions/Description) != ''">
                                        <D_387>
                                            <xsl:value-of
                                                select="substring(normalize-space(ShipTo/TransportInformation/ShippingInstructions/Description), 1, 35)"/>
                                        </D_387>
                                    </xsl:if>
                                </S_TD5>
                            </xsl:if>
                        </G_LIN>
                    </xsl:for-each>
                    <!-- Summary -->
                    <S_CTT>
                        <D_354>
                            <xsl:value-of select="count(cXML/Request/OrderRequest/ItemOut)"/>
                        </D_354>
                        <D_347>
                            <xsl:call-template name="HashTotal"/>
                        </D_347>
                    </S_CTT>
                    <S_SE>
                        <D_96>
                            <xsl:text>#segCount#</xsl:text>
                        </D_96>
                        <D_329>0001</D_329>
                    </S_SE>
                </M_862>
                <S_GE>
                    <D_97>1</D_97>
                    <D_28>
                        <xsl:value-of select="$anICNValue"/>
                    </D_28>
                </S_GE>
            </FunctionalGroup>
            <S_IEA>
                <D_I16>1</D_I16>
                <D_I12>
                    <xsl:value-of select="$anICNValue"/>
                </D_I12>
            </S_IEA>
        </ns0:Interchange>
    </xsl:template>
    <xsl:template name="HashTotal">
        <xsl:variable name="HashValue">
            <value>
                <xsl:for-each select="cXML/Request/OrderRequest/ItemOut/@quantity">
                    <xsl:if test="normalize-space(.) != ''">
                        <xsl:variable name="ItemQty" select="string(xs:decimal(.))"/>
                        <itemQty>
                            <xsl:value-of select="translate($ItemQty, '.', '')"/>
                        </itemQty>
                    </xsl:if>
                </xsl:for-each>
            </value>
        </xsl:variable>
        <xsl:variable name="summaryHashQty"
            select="
                string(sum(for $i in $HashValue/value/itemQty
                return
                    xs:decimal($i)))"/>
        <xsl:choose>
            <xsl:when test="string-length($summaryHashQty) &gt; 10">
                <xsl:value-of select="substring($summaryHashQty, string-length($summaryHashQty) - 9)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="formatQty">
                    <xsl:with-param name="qty" select="$summaryHashQty"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- IG-28419 -->
    <xsl:template name="CreateREFList">
        <xsl:variable name="REFList">
            <REFList>
                <!-- requisitionID -->
                <xsl:if test="normalize-space(./@requisitionID) != ''">
                    <S_REF>
                        <D_128>RQ</D_128>
                        <D_127>
                            <xsl:value-of select="substring(normalize-space(./@requisitionID), 1, 30)"/>
                        </D_127>
                    </S_REF>
                </xsl:if>
                <!-- SupplierID -->
                <xsl:if test="normalize-space(SupplierID) != ''">
                    <S_REF>
                        <D_128>ZA</D_128>
                        <D_127>
                            <xsl:value-of select="substring(normalize-space(SupplierID), 1, 30)"/>
                        </D_127>
                        <xsl:if test="normalize-space(SupplierID/@domain) != ''">
                            <D_352>
                                <xsl:value-of select="substring(normalize-space(SupplierID/@domain), 1, 80)"/>
                            </D_352>
                        </xsl:if>
                    </S_REF>
                </xsl:if>
                <!-- parentLineNumber and itemType-->
                <xsl:if test="@parentLineNumber != '' or @itemType != ''">
                <S_REF>
                    <D_128>FL</D_128>
                    <xsl:if test="@parentLineNumber != ''">
                        <D_127>
                            <xsl:value-of select="@parentLineNumber"/>
                        </D_127>
                    </xsl:if>
                    <xsl:if test="@itemType">
                        <D_352>
                            <xsl:value-of select="@itemType"/>
                        </D_352>
                    </xsl:if>
                </S_REF>
            </xsl:if>
            <xsl:if test="normalize-space(ItemOutIndustry/SerialNumberInfo/SerialNumber) != ''">
                <S_REF>
                    <D_128>SE</D_128>
                    <D_127>
                        <xsl:value-of
                            select="substring(normalize-space(ItemOutIndustry/SerialNumberInfo/SerialNumber), 1, 30)"/>
                    </D_127>
                </S_REF>
            </xsl:if>
            <!-- IG-1229 -->
            <xsl:if test="normalize-space(../OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier) != ''">
                <S_REF>
                    <D_128>S1</D_128>
                    <D_127>
                        <xsl:value-of
                            select="substring(normalize-space(../OrderRequestHeader/IdReference[@domain = 'CustomerReferenceID']/@identifier), 1, 30)"
                        />
                    </D_127>
                </S_REF>
            </xsl:if>
            <xsl:if test="normalize-space(./ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo[@documentType = 'salesOrder']/@documentID) != ''">
                <S_REF>
                    <D_128>ZG</D_128>
                    <D_127>
                        <xsl:value-of
                            select="substring(normalize-space(./ItemOutIndustry/ReferenceDocumentInfo/DocumentInfo[@documentType = 'salesOrder']/@documentID), 1, 30)"
                        />
                    </D_127>
                </S_REF>
            </xsl:if>
            <xsl:if test="normalize-space(../OrderRequestHeader/IdReference[@domain = 'supplierReference']/@identifier) != ''">
                <S_REF>
                    <D_128>D2</D_128>
                    <D_127>
                        <xsl:value-of
                            select="substring(normalize-space(../OrderRequestHeader/IdReference[@domain = 'supplierReference']/@identifier), 1, 30)"
                        />
                    </D_127>
                </S_REF>
            </xsl:if>
            <xsl:if test="normalize-space(../OrderRequestHeader/Extrinsic[@name = 'contractNo']) != ''">
                <S_REF>
                    <D_128>CT</D_128>
                    <D_127>
                        <xsl:value-of select="substring(normalize-space(../OrderRequestHeader/Extrinsic[@name = 'contractNo']), 1, 30)"/>
                    </D_127>
                </S_REF>
            </xsl:if>
            <xsl:if test="normalize-space(Batch/BuyerBatchID) != ''">
                <S_REF>
                    <D_128>LT</D_128>
                    <D_127>
                        <xsl:value-of select="substring(normalize-space(Batch/BuyerBatchID), 1, 30)"/>
                    </D_127>
                </S_REF>
            </xsl:if>
            <xsl:for-each select="ItemDetail/Extrinsic">
                <S_REF>
                    <D_128>ZZ</D_128>
                    <D_127>
                        <xsl:value-of select="substring(normalize-space(@name), 1, 30)"/>
                    </D_127>
                    <D_352>
                        <xsl:value-of select="substring(normalize-space(./text()), 1, 80)"/>
                    </D_352>
                </S_REF>
            </xsl:for-each>
                <xsl:for-each select="../OrderRequestHeader/Extrinsic[@name != 'contractNo']">
                <S_REF>
                    <D_128>ZZ</D_128>
                    <D_127>
                        <xsl:value-of select="substring(normalize-space(@name), 1, 30)"/>
                    </D_127>
                    <D_352>
                        <xsl:value-of select="substring(normalize-space(./text()), 1, 80)"/>
                    </D_352>
                </S_REF>
            </xsl:for-each>
        </REFList>
        </xsl:variable>
        <xsl:for-each select="$REFList/REFList/child::*[position() &lt;13]">
            <xsl:copy-of select="."></xsl:copy-of>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
