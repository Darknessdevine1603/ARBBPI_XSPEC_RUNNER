<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output indent="yes" omit-xml-declaration="yes"/>
    <!-- For local testing -->
    <!--<xsl:variable name="Lookup" select="document('LOOKUP_UN-EDIFACT_D96A.xml')"/>
    <xsl:include href="FORMAT_cXML_0000_UN-EDIFACT_D96A.xsl"/>-->
    <xsl:include href="FORMAT_cXML_0000_UN-EDIFACT_D96A.xsl"/>
    <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_UN-EDIFACT_D96A.xml')"/>
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
    <xsl:template match="/">
        <xsl:variable name="dateNow" select="current-dateTime()"/>
        <ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:6:un-edifact:delfor:d.96a">
            <S_UNA>:+.? '</S_UNA>
            <S_UNB>
                <C_S001>
                    <D_0001>UNOC</D_0001>
                    <D_0002>3</D_0002>
                </C_S001>
                <C_S002>
                    <D_0004>
                        <xsl:value-of select="$anISASender"/>
                    </D_0004>
                    <D_0007>
                        <xsl:value-of select="$anISASenderQual"/>
                    </D_0007>
                    <D_0008>
                        <xsl:value-of select="$anSenderGroupID"/>
                    </D_0008>
                </C_S002>
                <C_S003>
                    <D_0010>
                        <xsl:value-of select="$anISAReceiver"/>
                    </D_0010>
                    <D_0007>
                        <xsl:value-of select="$anISAReceiverQual"/>
                    </D_0007>
                    <D_0014>
                        <xsl:value-of select="$anReceiverGroupID"/>
                    </D_0014>
                </C_S003>
                <C_S004>
                    <D_0017>
                        <xsl:value-of select="format-dateTime($dateNow, '[Y01][M01][D01]')"/>
                    </D_0017>
                    <D_0019>
                        <xsl:value-of select="format-dateTime($dateNow, '[H01][M01]')"/>
                    </D_0019>
                </C_S004>
                <D_0020>
                    <xsl:value-of select="$anICNValue"/>
                </D_0020>
                <D_0026>DELFOR</D_0026>
                <xsl:if test="upper-case($anEnvName) = 'TEST'">
                    <D_0035>1</D_0035>
                </xsl:if>
            </S_UNB>
            <xsl:element name="M_DELFOR">
                <S_UNH>
                    <D_0062>0001</D_0062>
                    <C_S009>
                        <D_0065>DELFOR</D_0065>
                        <D_0052>D</D_0052>
                        <D_0054>96A</D_0054>
                        <D_0051>UN</D_0051>
                    </C_S009>
                </S_UNH>
                <S_BGM>
                    <C_C002>
                        <D_1001>241</D_1001>
                        <D_1000>Delivery Forecast</D_1000>
                    </C_C002>
                    <xsl:if
                        test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID) != ''">
                        <D_1004>
                            <xsl:value-of
                                select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 35)"
                            />
                        </D_1004>
                    </xsl:if>
                    <D_1225>25</D_1225>
                    <D_4343>AB</D_4343>
                </S_BGM>
                <!-- Order Date -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate) != ''">
                    <S_DTM>
                        <C_C507>
                            <D_2005>4</D_2005>
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate"
                                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate)"
                                />
                            </xsl:call-template>
                        </C_C507>
                    </S_DTM>
                </xsl:if>
                <!-- effectiveDate -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate) != ''">
                    <S_DTM>
                        <C_C507>
                            <D_2005>7</D_2005>
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate"
                                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate)"
                                />
                            </xsl:call-template>
                        </C_C507>
                    </S_DTM>
                </xsl:if>
                <!-- expirationDate -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate) != ''">
                    <S_DTM>
                        <C_C507>
                            <D_2005>36</D_2005>
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate"
                                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate)"
                                />
                            </xsl:call-template>
                        </C_C507>
                    </S_DTM>
                </xsl:if>
                <!-- pickUpDate -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate) != ''">
                    <S_DTM>
                        <C_C507>
                            <D_2005>200</D_2005>
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate"
                                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@pickUpDate)"
                                />
                            </xsl:call-template>
                        </C_C507>
                    </S_DTM>
                </xsl:if>
                <!-- requestedDeliveryDate -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate) != ''">
                    <S_DTM>
                        <C_C507>
                            <D_2005>2</D_2005>
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate"
                                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requestedDeliveryDate)"
                                />
                            </xsl:call-template>
                        </C_C507>
                    </S_DTM>
                </xsl:if>
                <!-- DeliveryPeriod Start Date-->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate) != ''">
                    <S_DTM>
                        <C_C507>
                            <D_2005>64</D_2005>
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate"
                                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@startDate)"
                                />
                            </xsl:call-template>
                        </C_C507>
                    </S_DTM>
                </xsl:if>
                <!-- DeliveryPeriod End Date-->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate) != ''">
                    <S_DTM>
                        <C_C507>
                            <D_2005>63</D_2005>
                            <xsl:call-template name="formatDate">
                                <xsl:with-param name="DocDate"
                                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/DeliveryPeriod/Period/@endDate)"
                                />
                            </xsl:call-template>
                        </C_C507>
                    </S_DTM>
                </xsl:if>
                <!-- requisitionID -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>AGI</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@requisitionID), 1, 35)"
                                    />
                                </D_1154>
                            </C_C506>
                        </S_RFF>
                    </G_SG1>
                </xsl:if>
                <!-- releaseRequired -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@releaseRequired) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>RE</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@releaseRequired), 1, 35)"
                                    />
                                </D_1154>
                            </C_C506>
                        </S_RFF>
                    </G_SG1>
                </xsl:if>
                <!-- agreementID -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>CT</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@agreementID), 1, 35)"
                                    />
                                </D_1154>
                            </C_C506>
                        </S_RFF>
                    </G_SG1>
                </xsl:if>
                <!-- payloadID -->
                <xsl:if test="normalize-space(cXML/@payloadID) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>IL</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/@payloadID), 1, 35)"
                                    />
                                </D_1154>
                                <xsl:if test="substring(cXML/@payloadID, 36, 35) != ''">
                                    <D_4000>
                                        <xsl:value-of
                                            select="substring(normalize-space(cXML/@payloadID), 36, 35)"
                                        />
                                    </D_4000>
                                </xsl:if>
                            </C_C506>
                        </S_RFF>
                    </G_SG1>
                </xsl:if>
                <!-- parentAgreementID -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>BC</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@parentAgreementID), 1, 35)"
                                    />
                                </D_1154>
                            </C_C506>
                        </S_RFF>
                    </G_SG1>
                </xsl:if>
                <!-- Pcard -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@number) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>AIU</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@number), 1, 35)"
                                    />
                                </D_1154>
                            </C_C506>
                        </S_RFF>
                        <!-- Payment Pay card Expiration Date -->
                        <xsl:if
                            test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@expiration) != ''">
                            <S_DTM>
                                <C_C507>
                                    <D_2005>36</D_2005>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="DocDate"
                                            select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@expiration)"
                                        />
                                    </xsl:call-template>
                                </C_C507>
                            </S_DTM>
                        </xsl:if>
                    </G_SG1>
                </xsl:if>
                <!-- OrderID and orderDate -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>ON</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 35)"
                                    />
                                </D_1154>
                                <xsl:if
                                    test="cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion != ''">
                                    <D_4000>
                                        <xsl:value-of
                                            select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderVersion), 1, 35)"
                                        />
                                    </D_4000>
                                </xsl:if>
                            </C_C506>
                        </S_RFF>
                        <xsl:if
                            test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate) != ''">
                            <S_DTM>
                                <C_C507>
                                    <D_2005>4</D_2005>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="DocDate"
                                            select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate)"
                                        />
                                    </xsl:call-template>
                                </C_C507>
                            </S_DTM>
                        </xsl:if>
                    </G_SG1>
                </xsl:if>
                <!-- Supplier OrderID and orderDate -->
                <xsl:if
                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>VN</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderID), 1, 35)"
                                    />
                                </D_1154>
                            </C_C506>
                        </S_RFF>
                        <xsl:if
                            test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderDate) != ''">
                            <S_DTM>
                                <C_C507>
                                    <D_2005>4</D_2005>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="DocDate"
                                            select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/SupplierOrderInfo/@orderDate)"
                                        />
                                    </xsl:call-template>
                                </C_C507>
                            </S_DTM>
                        </xsl:if>
                    </G_SG1>
                </xsl:if>
                <!-- AribaNetworkID -->
                <xsl:if
                    test="normalize-space(cXML/Header/From/Credential[@domain = 'AribaNetworkID']/Identity) != ''">
                    <G_SG1>
                        <S_RFF>
                            <C_C506>
                                <D_1153>IT</D_1153>
                                <D_1154>
                                    <xsl:value-of
                                        select="substring(normalize-space(cXML/Header/From/Credential[@domain = 'AribaNetworkID']/Identity), 1, 35)"
                                    />
                                </D_1154>
                            </C_C506>
                        </S_RFF>
                    </G_SG1>
                </xsl:if>
                <!-- Bill To -->
                <G_SG2>
                    <xsl:call-template name="createNAD">
                        <xsl:with-param name="Address"
                            select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address"/>
                        <xsl:with-param name="role" select="'billTo'"/>
                    </xsl:call-template>
                    <xsl:call-template name="CTACOMLoop">
                        <xsl:with-param name="contact"
                            select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo/Address"/>
                        <xsl:with-param name="contactType" select="'BillTo'"/>
                        <xsl:with-param name="isJITorFOR" select="'true'"/>
                    </xsl:call-template>
                </G_SG2>
                <!-- Ship To -->
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo">
                    <G_SG2>
                        <xsl:call-template name="createNAD">
                            <xsl:with-param name="Address"
                                select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
                            <xsl:with-param name="role" select="'shipTo'"/>
                        </xsl:call-template>
                        <xsl:call-template name="CTACOMLoop">
                            <xsl:with-param name="contact"
                                select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
                            <xsl:with-param name="contactType" select="'ShipTo'"/>
                            <xsl:with-param name="isJITorFOR" select="'true'"/>
                        </xsl:call-template>
                    </G_SG2>
                </xsl:if>
                <!-- TermsOfDelivery -->
                <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address">
                    <G_SG2>
                        <xsl:call-template name="createNAD">
                            <xsl:with-param name="Address"
                                select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address"/>
                            <xsl:with-param name="role" select="'deliveryParty'"/>
                        </xsl:call-template>
                        <xsl:call-template name="CTACOMLoop">
                            <xsl:with-param name="contact"
                                select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address"/>
                            <xsl:with-param name="contactType" select="'TermsOfDelivery'"/>
                            <xsl:with-param name="isJITorFOR" select="'true'"/>
                        </xsl:call-template>
                    </G_SG2>
                </xsl:if>
                <!-- Contact -->
                <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Contact">
                    <G_SG2>
                        <xsl:call-template name="createNAD">
                            <xsl:with-param name="Address" select="."/>
                            <xsl:with-param name="role" select="@role"/>
                        </xsl:call-template>
                        <xsl:call-template name="CTACOMLoop">
                            <xsl:with-param name="contact" select="."/>
                            <xsl:with-param name="contactType" select="@role"/>
                            <xsl:with-param name="ContactDepartmentID"
                                select="IdReference[@domain = 'ContactDepartmentID']/@identifier"/>
                            <xsl:with-param name="ContactPerson"
                                select="IdReference[@domain = 'ContactPerson']/@identifier"/>
                            <xsl:with-param name="isJITorFOR" select="'true'"/>
                        </xsl:call-template>
                    </G_SG2>
                </xsl:for-each>
               
                <!-- IG-16755 Change 1 - Map contacts from item, only if 1 item present-->
                <xsl:if test="count(cXML/Request/OrderRequest/ItemOut) = 1">
                    <xsl:for-each select="cXML/Request/OrderRequest/ItemOut/Contact">
                        <xsl:if test="not(exists(cXML/Request/OrderRequest/OrderRequestHeader/Contact[@role=./@role]))">
                        <G_SG2>
                            <xsl:call-template name="createNAD">
                                <xsl:with-param name="Address" select="."/>
                                <xsl:with-param name="role" select="@role"/>
                            </xsl:call-template>
                            <xsl:call-template name="CTACOMLoop">
                                <xsl:with-param name="contact" select="."/>
                                <xsl:with-param name="contactType" select="@role"/>
                                <xsl:with-param name="ContactDepartmentID"
                                    select="IdReference[@domain = 'ContactDepartmentID']/@identifier"/>
                                <xsl:with-param name="ContactPerson"
                                    select="IdReference[@domain = 'ContactPerson']/@identifier"/>
                                <xsl:with-param name="isJITorFOR" select="'true'"/>
                            </xsl:call-template>
                        </G_SG2>  
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <!-- IG-16755 Change 2 - Map TOD from item, only if 1 item present-->
                <xsl:if test="count(cXML/Request/OrderRequest/ItemOut) = 1 and not(exists(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery))">
                    <xsl:if test="cXML/Request/OrderRequest/ItemOut/TermsOfDelivery">
                        <G_SG2>
                            <xsl:call-template name="createNAD">
                                <xsl:with-param name="Address"
                                    select="cXML/Request/OrderRequest/ItemOut/TermsOfDelivery/Address"/>
                                <xsl:with-param name="role" select="'deliveryParty'"/>
                            </xsl:call-template>
                            <xsl:call-template name="CTACOMLoop">
                                <xsl:with-param name="contact"
                                    select="cXML/Request/OrderRequest/ItemOut/TermsOfDelivery/Address"/>
                                <xsl:with-param name="contactType" select="'TermsOfDelivery'"/>
                                <xsl:with-param name="isJITorFOR" select="'true'"/>
                            </xsl:call-template>
                        </G_SG2>
                    </xsl:if>
                </xsl:if>
                
                <S_UNS>
                    <D_0081>D</D_0081>
                </S_UNS>
                
                <!-- IG-16755 Change 3 - Map item details group per ShipTo -->
                <xsl:for-each-group select="cXML/Request/OrderRequest/ItemOut" group-by="ShipTo/Address/@addressID">
                    <G_SG4>
                        <xsl:call-template name="createNAD">
                            <xsl:with-param name="Address" select="ShipTo/Address"/>
                            <xsl:with-param name="role" select="'shipTo'"/>
                        </xsl:call-template>
                        <xsl:call-template name="CTACOMLoop">
                            <xsl:with-param name="contact" select="ShipTo/Address"/>
                            <xsl:with-param name="contactType" select="'ShipTo'"/>
                            <xsl:with-param name="level" select="'detail'"/>
                            <xsl:with-param name="isJITorFOR" select="'true'"/>
                        </xsl:call-template>
                        <xsl:if
                            test="normalize-space(ShipTo/TransportInformation/Route/@method) != ''">
                            <G_SG7>
                                <S_TDT>
                                    <D_8051>20</D_8051>
                                    <C_C220>
                                        <xsl:variable name="routeMethod"
                                            select="normalize-space(ShipTo/TransportInformation/Route/@method)"/>
                                        <xsl:choose>
                                            <xsl:when
                                                test="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $routeMethod]/EDIFACTCode != ''">
                                                <D_8067>
                                                    <xsl:value-of
                                                        select="$Lookup/Lookups/TransportInformations/TransportInformation[CXMLCode = $routeMethod]/EDIFACTCode"
                                                    />
                                                </D_8067>
                                            </xsl:when>
                                        </xsl:choose>
                                        <D_8066>
                                            <xsl:value-of
                                                select="substring(normalize-space(ShipTo/TransportInformation/Route/@method), 1, 17)"
                                            />
                                        </D_8066>
                                    </C_C220>
                                    <xsl:if
                                        test="normalize-space(ShipTo/TransportInformation/Route/@means) != ''">
                                        <C_C228>
                                            <D_8178>
                                                <xsl:value-of
                                                    select="substring(normalize-space(ShipTo/TransportInformation/Route/@means), 1, 17)"
                                                />
                                            </D_8178>
                                        </C_C228>
                                    </xsl:if>
                                    <xsl:if
                                        test="normalize-space(ShipTo/CarrierIdentifier) != ''">
                                        <C_C040>
                                            <D_3127>
                                                <xsl:value-of
                                                    select="substring(normalize-space(ShipTo/CarrierIdentifier/@domain), 1, 17)"
                                                />
                                            </D_3127>
                                            <D_3128>
                                                <xsl:value-of
                                                    select="substring(normalize-space(ShipTo/CarrierIdentifier), 1, 35)"
                                                />
                                            </D_3128>
                                        </C_C040>
                                    </xsl:if>
                                    <xsl:if
                                        test="normalize-space(ShipTo/TransportInformation/ShippingContractNumber) != ''">
                                        <C_C401>
                                            <D_8457>ZZZ</D_8457>
                                            <D_8459>ZZZ</D_8459>
                                            <D_7130>
                                                <xsl:value-of
                                                    select="substring(normalize-space(ShipTo/TransportInformation/ShippingContractNumber), 1, 17)"
                                                />
                                            </D_7130>
                                        </C_C401>
                                    </xsl:if>
                                </S_TDT>
                            </G_SG7>
                        </xsl:if>
                        
                        <xsl:for-each select="current-group()">
                            <xsl:call-template name="mapItems"/>    
                        </xsl:for-each>
                    </G_SG4>
               </xsl:for-each-group>
                
                <xsl:for-each select="cXML/Request/OrderRequest/ItemOut[not(exists(ShipTo/Address/@addressID))]">
                    <G_SG4>
                        <xsl:call-template name="createNAD">
                            <xsl:with-param name="Address"
                                select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
                            <xsl:with-param name="role" select="'shipTo'"/>
                        </xsl:call-template>
                        <xsl:call-template name="CTACOMLoop">
                            <xsl:with-param name="contact"
                                select="/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address"/>
                            <xsl:with-param name="contactType" select="'ShipTo'"/>
                            <xsl:with-param name="isJITorFOR" select="'true'"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="mapItems"/>
                    </G_SG4>
                </xsl:for-each>
                <!--- Summary -->
                <S_UNS>
                    <D_0081>S</D_0081>
                </S_UNS>
                <xsl:if test="cXML/Request/OrderRequest/ItemOut != ''">
                    <S_CNT>
                        <C_C270>
                            <D_6069>2</D_6069>
                            <D_6066>
                                <xsl:value-of select="count(cXML/Request/OrderRequest/ItemOut)"/>
                            </D_6066>
                        </C_C270>
                    </S_CNT>
                </xsl:if>
                <!-- Comments -->
                <xsl:variable name="Comments"
                    select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Comments)"/>
                <xsl:if test="normalize-space($Comments) != ''">
                    <S_FTX>
                        <D_4451>AAI</D_4451>
                        <xsl:if test="normalize-space($Comments) != ''">
                            <C_C108>
                                <xsl:if test="substring($Comments, 1, 70) != ''">
                                    <D_4440>
                                        <xsl:value-of select="substring($Comments, 1, 70)"/>
                                    </D_4440>
                                </xsl:if>
                                <xsl:if test="substring($Comments, 71, 70) != ''">
                                    <D_4440_2>
                                        <xsl:value-of select="substring($Comments, 71, 70)"/>
                                    </D_4440_2>
                                </xsl:if>
                                <xsl:if test="substring($Comments, 141, 70) != ''">
                                    <D_4440_3>
                                        <xsl:value-of select="substring($Comments, 141, 70)"/>
                                    </D_4440_3>
                                </xsl:if>
                                <xsl:if test="substring($Comments, 211, 70) != ''">
                                    <D_4440_4>
                                        <xsl:value-of select="substring($Comments, 211, 70)"/>
                                    </D_4440_4>
                                </xsl:if>
                                <xsl:if test="substring($Comments, 281, 70) != ''">
                                    <D_4440_5>
                                        <xsl:value-of select="substring($Comments, 281, 70)"/>
                                    </D_4440_5>
                                </xsl:if>
                            </C_C108>
                        </xsl:if>
                        <D_3453>
                            <xsl:choose>
                                <xsl:when
                                    test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Comments/@xml:lang) != ''">
                                    <xsl:value-of
                                        select="upper-case(substring(cXML/Request/OrderRequest/OrderRequestHeader/Comments/@xml:lang, 1, 2))"
                                    />
                                </xsl:when>
                                <xsl:otherwise>EN</xsl:otherwise>
                            </xsl:choose>
                        </D_3453>
                    </S_FTX>
                </xsl:if>
                <S_UNT>
                    <D_0074>#segCount#</D_0074>
                    <D_0062>0001</D_0062>
                </S_UNT>
            </xsl:element>
            <S_UNZ>
                <D_0036>1</D_0036>
                <D_0020>
                    <xsl:value-of select="$anICNValue"/>
                </D_0020>
            </S_UNZ>
        </ns0:Interchange>
    </xsl:template>
    
    <xsl:template name="mapItems">
        <G_SG8>
            <S_LIN>
                <D_1082>
                    <xsl:choose>
                        <xsl:when test="@lineNumber">
                            <xsl:value-of select="substring(format-number(@lineNumber, '#'), 1, 6)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="position()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </D_1082>
                <xsl:if test="normalize-space(ItemID/SupplierPartID) != ''">
                    <C_C212>
                        <D_7140>
                            <xsl:value-of select="substring(normalize-space(ItemID/SupplierPartID), 1, 35)"/>
                        </D_7140>
                        <D_7143>VN</D_7143>
                    </C_C212>
                </xsl:if>
                <xsl:if test="normalize-space(@parentLineNumber) != ''">
                    <C_C829>
                        <D_5495>1</D_5495>
                        <D_1082>
                            <xsl:value-of select="substring(format-number(@parentLineNumber, '#'), 1, 6)"/>
                        </D_1082>
                    </C_C829>
                </xsl:if>
            </S_LIN>
            <!-- ItemIDs -->
            <xsl:if test="normalize-space(ItemID/SupplierPartAuxiliaryID) != '' or normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != '' or normalize-space(ItemDetail/IdReference[@domain = 'EAN-13']/@identifier) != '' or normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                <S_PIA>
                    <D_4347>1</D_4347>
                    <xsl:choose>
                        <xsl:when test="normalize-space(ItemID/SupplierPartAuxiliaryID) != ''">
                            <C_C212>
                                <D_7140>
                                    <xsl:value-of select="substring(normalize-space(ItemID/SupplierPartAuxiliaryID), 1, 35)"/>
                                </D_7140>
                                <D_7143>VS</D_7143>
                                <D_1131>57</D_1131>
                                <D_3055>91</D_3055>
                            </C_C212>
                            <xsl:choose>
                                <xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != ''">
                                    <C_C212_2>
                                        <D_7140>
                                            <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID), 1, 35)"/>
                                        </D_7140>
                                        <D_7143>EN</D_7143>
                                        <D_1131>57</D_1131>
                                        <D_3055>9</D_3055>
                                    </C_C212_2>
                                    <xsl:if test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                        <C_C212_3>
                                            <D_7140>
                                                <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
                                            </D_7140>
                                            <D_7143>ZZZ</D_7143>
                                            <D_1131>57</D_1131>
                                            <D_3055>9</D_3055>
                                        </C_C212_3>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="normalize-space(ItemDetail/IdReference[@domain = 'EAN-13']/@identifier) != ''">
                                    <C_C212_2>
                                        <D_7140>
                                            <xsl:value-of select="substring(normalize-space(ItemDetail/IdReference[@domain = 'EAN-13']/@identifier), 1, 35)"/>
                                        </D_7140>
                                        <D_7143>EN</D_7143>
                                        <D_1131>57</D_1131>
                                        <D_3055>9</D_3055>
                                    </C_C212_2>
                                    <xsl:if test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                        <C_C212_3>
                                            <D_7140>
                                                <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
                                            </D_7140>
                                            <D_7143>ZZZ</D_7143>
                                            <D_1131>57</D_1131>
                                            <D_3055>9</D_3055>
                                        </C_C212_3>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                    <C_C212_2>
                                        <D_7140>
                                            <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
                                        </D_7140>
                                        <D_7143>ZZZ</D_7143>
                                        <D_1131>57</D_1131>
                                        <D_3055>9</D_3055>
                                    </C_C212_2>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != '' or normalize-space(ItemDetail/IdReference[@domain = 'EAN-13']/@identifier) != ''">
                            <xsl:choose>
                                <xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID) != ''">
                                    <C_C212>
                                        <D_7140>
                                            <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EANID), 1, 35)"/>
                                        </D_7140>
                                        <D_7143>EN</D_7143>
                                        <D_1131>57</D_1131>
                                        <D_3055>9</D_3055>
                                    </C_C212>
                                    <xsl:if test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                        <C_C212_2>
                                            <D_7140>
                                                <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
                                            </D_7140>
                                            <D_7143>ZZZ</D_7143>
                                            <D_1131>57</D_1131>
                                            <D_3055>9</D_3055>
                                        </C_C212_2>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="normalize-space(ItemDetail/IdReference[@domain = 'EAN-13']/@identifier) != ''">
                                    <C_C212>
                                        <D_7140>
                                            <xsl:value-of select="substring(normalize-space(ItemDetail/IdReference[@domain = 'EAN-13']/@identifier), 1, 35)"/>
                                        </D_7140>
                                        <D_7143>EN</D_7143>
                                        <D_1131>57</D_1131>
                                        <D_3055>9</D_3055>
                                    </C_C212>
                                    <xsl:if test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                        <C_C212_2>
                                            <D_7140>
                                                <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
                                            </D_7140>
                                            <D_7143>ZZZ</D_7143>
                                            <D_1131>57</D_1131>
                                            <D_3055>9</D_3055>
                                        </C_C212_2>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                                    <C_C212_2>
                                        <D_7140>
                                            <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
                                        </D_7140>
                                        <D_7143>ZZZ</D_7143>
                                        <D_1131>57</D_1131>
                                        <D_3055>9</D_3055>
                                    </C_C212_2>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID) != ''">
                            <C_C212>
                                <D_7140>
                                    <xsl:value-of select="substring(normalize-space(ItemDetail/ItemDetailIndustry/ItemDetailRetail/EuropeanWasteCatalogID), 1, 35)"/>
                                </D_7140>
                                <D_7143>ZZZ</D_7143>
                                <D_1131>57</D_1131>
                                <D_3055>9</D_3055>
                            </C_C212>
                        </xsl:when>
                    </xsl:choose>
                </S_PIA>
            </xsl:if>
            <xsl:if test="normalize-space(ItemID/BuyerPartID) != '' or normalize-space(ItemDetail/ManufacturerPartID) != ''">
                <S_PIA>
                    <D_4347>5</D_4347>
                    <xsl:choose>
                        <xsl:when test="normalize-space(ItemID/BuyerPartID) != ''">
                            <C_C212>
                                <D_7140>
                                    <xsl:value-of select="substring(normalize-space(ItemID/BuyerPartID), 1, 35)"/>
                                </D_7140>
                                <D_7143>BP</D_7143>
                                <D_1131>57</D_1131>
                                <D_3055>92</D_3055>
                            </C_C212>
                            <xsl:if test="normalize-space(ItemDetail/ManufacturerPartID) != ''">
                                <C_C212_2>
                                    <D_7140>
                                        <xsl:value-of select="substring(normalize-space(ItemDetail/ManufacturerPartID), 1, 35)"/>
                                    </D_7140>
                                    <D_7143>MF</D_7143>
                                    <D_1131>57</D_1131>
                                    <D_3055>90</D_3055>
                                </C_C212_2>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="normalize-space(ItemDetail/ManufacturerPartID) != ''">
                            <C_C212>
                                <D_7140>
                                    <xsl:value-of select="substring(normalize-space(ItemDetail/ManufacturerPartID), 1, 35)"/>
                                </D_7140>
                                <D_7143>MF</D_7143>
                                <D_1131>57</D_1131>
                                <D_3055>90</D_3055>
                            </C_C212>
                        </xsl:when>
                    </xsl:choose>
                </S_PIA>
            </xsl:if>
            <!-- Description shortName -->
            <xsl:if test="normalize-space(BlanketItemDetail/Description/ShortName) != '' or normalize-space(ItemDetail/Description/ShortName) != ''">
                <xsl:variable name="shortName">
                    <xsl:choose>
                        <xsl:when test="normalize-space(BlanketItemDetail/Description/ShortName) != ''">
                            <xsl:value-of select="normalize-space(BlanketItemDetail/Description/ShortName)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(ItemDetail/Description/ShortName)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$shortName != ''">
                    <S_IMD>
                        <D_7077>E</D_7077>
                        <C_C273>
                            <D_7008>
                                <xsl:value-of select="substring($shortName, 1, 35)"/>
                            </D_7008>
                            <xsl:if test="substring($shortName, 36) != ''">
                                <D_7008_2>
                                    <xsl:value-of select="substring(normalize-space($shortName), 36, 35)"/>
                                </D_7008_2>
                            </xsl:if>
                        </C_C273>
                    </S_IMD>
                </xsl:if>
            </xsl:if>
            <!-- Description -->
            <xsl:if test="normalize-space(BlanketItemDetail/Description) != '' or normalize-space(ItemDetail/Description) != ''">
                <xsl:variable name="descText">
                    <xsl:choose>
                        <xsl:when test="normalize-space(BlanketItemDetail/Description) != ''">
                            <xsl:value-of select="normalize-space(BlanketItemDetail/Description)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(ItemDetail/Description)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$descText != ''">
                    <S_IMD>
                        <D_7077>F</D_7077>
                        <xsl:if test="$descText != '' or normalize-space(BlanketItemDetail/Description) != '' or normalize-space(ItemDetail/Description) != ''">
                            <C_C273>
                                <xsl:if test="$descText != ''">
                                    <D_7008>
                                        <xsl:value-of select="substring($descText, 1, 35)"/>
                                    </D_7008>
                                </xsl:if>
                                <xsl:if test="substring($descText, 36) != ''">
                                    <D_7008_2>
                                        <xsl:value-of select="substring($descText, 36, 35)"/>
                                    </D_7008_2>
                                </xsl:if>
                                <D_3453>
                                    <xsl:choose>
                                        <xsl:when test="normalize-space(BlanketItemDetail/Description/@xml:lang) != ''">
                                            <xsl:value-of select="upper-case(substring(BlanketItemDetail/Description/@xml:lang, 1, 2))"/>
                                        </xsl:when>
                                        <xsl:when test="normalize-space(ItemDetail/Description/@xml:lang) != ''">
                                            <xsl:value-of select="upper-case(substring(ItemDetail/Description/@xml:lang, 1, 2))"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </D_3453>
                            </C_C273>
                        </xsl:if>
                    </S_IMD>
                </xsl:if>
            </xsl:if>
            <!-- Characteristic -->
            <xsl:for-each select="ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic">
                <xsl:variable name="charDomain" select="normalize-space(@domain)"/>
                <xsl:choose>
                    <xsl:when test="$Lookup/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[CXMLCode = $charDomain]/EDIFACTCode != '' and position() &lt; 8">
                        <S_IMD>
                            <D_7077>B</D_7077>
                            <D_7081>
                                <xsl:value-of select="$Lookup/Lookups/ItemCharacteristicCodes/ItemCharacteristicCode[CXMLCode = $charDomain]/EDIFACTCode"/>
                            </D_7081>
                            <xsl:if test="normalize-space(@value) != ''">
                                <C_C273>
                                    <D_7009>
                                        <xsl:value-of select="substring(normalize-space(@value), 1, 17)"/>
                                    </D_7009>
                                </C_C273>
                            </xsl:if>
                        </S_IMD>
                    </xsl:when>
                    <xsl:when test="position() &lt; 8">
                        <S_IMD>
                            <D_7077>B</D_7077>
                            <C_C273>
                                <D_7009>Mutually defined</D_7009>
                                <xsl:if test="normalize-space($charDomain) != ''">
                                    <D_7008>
                                        <xsl:value-of select="$charDomain"/>
                                    </D_7008>
                                </xsl:if>
                                <xsl:if test="normalize-space(@value) != ''">
                                    <D_7008_2>
                                        <xsl:value-of select="@value"/>
                                    </D_7008_2>
                                </xsl:if>
                            </C_C273>
                        </S_IMD>
                    </xsl:when>
        
                </xsl:choose>
            </xsl:for-each>
            <!-- Dimension -->
            <xsl:for-each select="ItemDetail/Dimension">
                <xsl:if test="position() &lt; 6">
                    <S_MEA>
                        <D_6311>AAE</D_6311>
                        <xsl:if test="normalize-space(@type) != ''">
                            <C_C502>
                                <D_6313>
                                    <xsl:variable name="dimType" select="normalize-space(@type)"/>
                                    <xsl:choose>
                                        <xsl:when test="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dimType]/EDIFACTCode != ''">
                                            <xsl:value-of select="$Lookup/Lookups/MeasureCodes/MeasureCode[CXMLCode = $dimType]/EDIFACTCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>ZZZ</xsl:otherwise>
                                    </xsl:choose>
                                </D_6313>
                            </C_C502>
                        </xsl:if>
                        <xsl:if test="normalize-space(@quantity) != ''">
                            <C_C174>
                                <D_6411>
                                    <xsl:choose>
                                        <xsl:when test="normalize-space(UnitOfMeasure) != ''">
                                            <xsl:value-of select="substring(normalize-space(UnitOfMeasure), 1, 3)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>LB</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </D_6411>
                                <D_6314>
                                    <xsl:value-of select="format-number(@quantity, '0.##')"/>
                                </D_6314>
                            </C_C174>
                        </xsl:if>
                    </S_MEA>
                </xsl:if>
            </xsl:for-each>
            <!--IG-27381 added new segment GIR for Serialnumbers- logic to group serial numbers within multiple 5-element GIR segment -->
            <xsl:variable name="GIRlimitcount" select="'100'"/> <!--only 100 GIR segments can be formed in DELFOR-->
            <xsl:for-each-group select="ItemOutIndustry/SerialNumberInfo/SerialNumber[number($GIRlimitcount) >= ((position() - 1) idiv 5)+1]" group-by="(position() - 1) idiv 5">
               <S_GIR>
                    <D_7297>1</D_7297>
                    <xsl:for-each select="current-group()">
                        <xsl:choose>
                            <xsl:when test="position() = 1">
                                <C_C206>
                                    <D_7402>
                                        <xsl:value-of select="substring(.,1,35)"/>
                                    </D_7402>
                                    <D_7405>BN</D_7405>
                                </C_C206>
                            </xsl:when>
                            <xsl:when test="position() &lt;= 5">
                                <xsl:element name="{concat('C_C206', '_', position())}">
                                    <D_7402>
                                        <xsl:value-of select="substring(.,1,35)"/>
                                    </D_7402>
                                    <D_7405>BN</D_7405> 
                                </xsl:element>                            
                            </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
               </S_GIR>
            </xsl:for-each-group>
                    <!-- requestedDeliveryDate -->
            <xsl:if test="normalize-space(@requestedDeliveryDate) != ''">
                <S_DTM>
                    <C_C507>
                        <D_2005>2</D_2005>
                        <xsl:call-template name="formatDate">
                            <xsl:with-param name="DocDate" select="normalize-space(@requestedDeliveryDate)"/>
                        </xsl:call-template>
                    </C_C507>
                </S_DTM>
            </xsl:if>
            <!-- requestedShipmentDate -->
            <xsl:if test="normalize-space(@requestedShipmentDate) != ''">
                <S_DTM>
                    <C_C507>
                        <D_2005>10</D_2005>
                        <xsl:call-template name="formatDate">
                            <xsl:with-param name="DocDate" select="normalize-space(@requestedShipmentDate)"/>
                        </xsl:call-template>
                    </C_C507>
                </S_DTM>
            </xsl:if>
            <!-- Comments -->
            <xsl:variable name="ItemComments" select="normalize-space(Comments)"/>
            <xsl:if test="$ItemComments != ''">
                <S_FTX>
                    <D_4451>AAI</D_4451>
                    <C_C108>
                        <D_4440>
                            <xsl:value-of select="substring($ItemComments, 1, 70)"/>
                        </D_4440>
                        <xsl:if test="substring($ItemComments, 71, 70) != ''">
                            <D_4440_2>
                                <xsl:value-of select="substring($ItemComments, 71, 70)"/>
                            </D_4440_2>
                        </xsl:if>
                        <xsl:if test="substring($ItemComments, 141, 70) != ''">
                            <D_4440_3>
                                <xsl:value-of select="substring($ItemComments, 141, 70)"/>
                            </D_4440_3>
                        </xsl:if>
                        <xsl:if test="substring($ItemComments, 211, 70) != ''">
                            <D_4440_4>
                                <xsl:value-of select="substring($ItemComments, 211, 70)"/>
                            </D_4440_4>
                        </xsl:if>
                        <xsl:if test="substring($ItemComments, 281, 70) != ''">
                            <D_4440_5>
                                <xsl:value-of select="substring($ItemComments, 281, 70)"/>
                            </D_4440_5>
                        </xsl:if>
                    </C_C108>
                    <xsl:if test="Comments/@xml:lang != ''">
                        <D_3453>
                            <xsl:value-of select="upper-case(substring(Comments/@xml:lang, 1, 2))"/>
                        </D_3453>
                    </xsl:if>
                </S_FTX>
            </xsl:if>
            <xsl:variable name="ftxCount">
                <xsl:choose>
                    <xsl:when test="$ItemComments != ''">4</xsl:when>
                    <xsl:otherwise>5</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="rInfoExt1" select="count(ReleaseInfo/Extrinsic[normalize-space(.) != ''])"/>
            <xsl:variable name="rInfoExt">
                <xsl:choose>
                    <xsl:when test="$ftxCount - $rInfoExt1 &gt; 0">
                        <xsl:value-of select="$rInfoExt1"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="extCount">
                <xsl:value-of select="$ftxCount - $rInfoExt"/>
            </xsl:variable>
            <xsl:for-each select="ReleaseInfo/Extrinsic[$rInfoExt >= position()]">
                <xsl:if test="normalize-space(./@name) != ''">
                    <S_FTX>
                        <D_4451>ZZZ</D_4451>
                        <xsl:variable name="Extr" select="normalize-space(.)"/>
                        <C_C108>
                            <D_4440>
                                <xsl:value-of select="substring(normalize-space(./@name), 1, 70)"/>
                            </D_4440>
                            <xsl:if test="substring($Extr, 1, 70) != ''">
                                <D_4440_2>
                                    <xsl:value-of select="substring($Extr, 1, 70)"/>
                                </D_4440_2>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 71, 70) != ''">
                                <D_4440_3>
                                    <xsl:value-of select="substring($Extr, 71, 70)"/>
                                </D_4440_3>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 141, 70) != ''">
                                <D_4440_4>
                                    <xsl:value-of select="substring($Extr, 141, 70)"/>
                                </D_4440_4>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 211, 70) != ''">
                                <D_4440_5>
                                    <xsl:value-of select="substring($Extr, 211, 70)"/>
                                </D_4440_5>
                            </xsl:if>
                        </C_C108>
                    </S_FTX>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="ItemDetail/Extrinsic[@name != 'hideUnitPrice' and @name != 'hideAmount'][$extCount >= position()]">
                <xsl:if test="normalize-space(./@name) != ''">
                    <S_FTX>
                        <D_4451>ZZZ</D_4451>
                        <xsl:variable name="Extr" select="normalize-space(.)"/>
                        <C_C108>
                            <D_4440>
                                <xsl:value-of select="substring(normalize-space(./@name), 1, 70)"/>
                            </D_4440>
                            <xsl:if test="substring($Extr, 1, 70) != ''">
                                <D_4440_2>
                                    <xsl:value-of select="substring($Extr, 1, 70)"/>
                                </D_4440_2>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 71, 70) != ''">
                                <D_4440_3>
                                    <xsl:value-of select="substring($Extr, 71, 70)"/>
                                </D_4440_3>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 141, 70) != ''">
                                <D_4440_4>
                                    <xsl:value-of select="substring($Extr, 141, 70)"/>
                                </D_4440_4>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 211, 70) != ''">
                                <D_4440_5>
                                    <xsl:value-of select="substring($Extr, 211, 70)"/>
                                </D_4440_5>
                            </xsl:if>
                        </C_C108>
                    </S_FTX>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="BlanketItemDetail/Extrinsic[@name != 'hideUnitPrice' and @name != 'hideAmount'][$extCount >= position()]">
                <xsl:if test="normalize-space(./@name) != ''">
                    <S_FTX>
                        <D_4451>ZZZ</D_4451>
                        <xsl:variable name="Extr" select="normalize-space(.)"/>
                        <C_C108>
                            <D_4440>
                                <xsl:value-of select="substring(normalize-space(./@name), 1, 70)"/>
                            </D_4440>
                            <xsl:if test="substring($Extr, 1, 70) != ''">
                                <D_4440_2>
                                    <xsl:value-of select="substring($Extr, 1, 70)"/>
                                </D_4440_2>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 71, 70) != ''">
                                <D_4440_3>
                                    <xsl:value-of select="substring($Extr, 71, 70)"/>
                                </D_4440_3>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 141, 70) != ''">
                                <D_4440_4>
                                    <xsl:value-of select="substring($Extr, 141, 70)"/>
                                </D_4440_4>
                            </xsl:if>
                            <xsl:if test="substring($Extr, 211, 70) != ''">
                                <D_4440_5>
                                    <xsl:value-of select="substring($Extr, 211, 70)"/>
                                </D_4440_5>
                            </xsl:if>
                        </C_C108>
                    </S_FTX>
                </xsl:if>
            </xsl:for-each>
            <!-- requisitionID -->
            <xsl:if test="normalize-space(@requisitionID) != ''">
                <G_SG10>
                    <S_RFF>
                        <C_C506>
                            <D_1153>AGI</D_1153>
                            <D_1154>
                                <xsl:value-of select="substring(normalize-space(@requisitionID), 1, 35)"/>
                            </D_1154>
                        </C_C506>
                    </S_RFF>
                </G_SG10>
            </xsl:if>
            <!-- itemType and compositeItemType-->
            <xsl:if test="normalize-space(@itemType) != ''">
                <G_SG10>
                    <S_RFF>
                        <C_C506>
                            <D_1153>FI</D_1153>
                            <D_1154>
                                <xsl:value-of select="substring(normalize-space(@itemType), 1, 35)"/>
                            </D_1154>
                            <xsl:if test="normalize-space(@compositeItemType) != ''">
                                <D_4000>
                                    <xsl:value-of select="substring(normalize-space(@compositeItemType), 1, 35)"/>
                                </D_4000>
                            </xsl:if>
                        </C_C506>
                    </S_RFF>
                </G_SG10>
            </xsl:if>
            <!-- Master Agreement ID -->
            <xsl:if test="normalize-space(MasterAgreementIDInfo/@agreementID) != ''">
                <G_SG10>
                    <S_RFF>
                        <C_C506>
                            <D_1153>CT</D_1153>
                            <D_1154>
                                <xsl:value-of select="substring(normalize-space(MasterAgreementIDInfo/@agreementID), 1, 35)"/>
                            </D_1154>
                            <xsl:if test="normalize-space(lower-case(MasterAgreementIDInfo/@agreementType)) = 'scheduling_agreement'">
                                <D_1156>1</D_1156>
                            </xsl:if>
                        </C_C506>
                    </S_RFF>
                    <xsl:if test="normalize-space(MasterAgreementIDInfo/@agreementDate) != ''">
                        <S_DTM>
                            <C_C507>
                                <D_2005>126</D_2005>
                                <xsl:call-template name="formatDate">
                                    <xsl:with-param name="DocDate" select="normalize-space(MasterAgreementIDInfo/@agreementDate)"/>
                                </xsl:call-template>
                            </C_C507>
                        </S_DTM>
                    </xsl:if>
                </G_SG10>
            </xsl:if>
            <!-- Manufacturer name -->
            <xsl:if test="normalize-space(ItemDetail/ManufacturerName) != ''">
                <G_SG10>
                    <S_RFF>
                        <C_C506>
                            <D_1153>MF</D_1153>
                            <D_1154>
                                <xsl:value-of select="substring(normalize-space(ItemDetail/ManufacturerName), 1, 35)"/>
                            </D_1154>
                        </C_C506>
                    </S_RFF>
                </G_SG10>
            </xsl:if>
            <!-- SupplierID -->
            <xsl:if test="normalize-space(SupplierID) != ''">
                <G_SG10>
                    <S_RFF>
                        <C_C506>
                            <D_1153>VR</D_1153>
                            <D_1154>
                                <xsl:value-of select="normalize-space(SupplierID)"/>
                            </D_1154>
                        </C_C506>
                    </S_RFF>
                </G_SG10>
            </xsl:if>
            <!-- ItemOut > ScheduleLine -->
            <xsl:for-each select="ScheduleLine">
                <xsl:if test="normalize-space(@quantity) != ''">
                    <G_SG12>
                        <S_QTY>
                            <C_C186>
                                <D_6063>187</D_6063>
                                <D_6060>
                                    <xsl:value-of select="format-number(@quantity, '0.##')"/>
                                </D_6060>
                                <xsl:if test="normalize-space(UnitOfMeasure) != ''">
                                    <D_6411>
                                        <xsl:value-of select="substring(UnitOfMeasure, 1, 3)"/>
                                    </D_6411>
                                </xsl:if>
                            </C_C186>
                        </S_QTY>
                        <xsl:if test="normalize-space(ScheduleLineReleaseInfo/@commitmentCode) != ''">
                            <S_SCC>
                                <D_4017>
                                    <xsl:choose>
                                        <xsl:when test="normalize-space(lower-case(ScheduleLineReleaseInfo/@commitmentCode)) = 'firm'">1</xsl:when>
                                        <xsl:when test="normalize-space(lower-case(ScheduleLineReleaseInfo/@commitmentCode)) = 'tradeoff'">3</xsl:when>
                                        <xsl:when test="normalize-space(lower-case(ScheduleLineReleaseInfo/@commitmentCode)) = 'forecast'">4</xsl:when>
                                        <xsl:otherwise>1</xsl:otherwise>
                                    </xsl:choose>
                                </D_4017>
                            </S_SCC>
                        </xsl:if>
                        <xsl:variable name="rdDate">
                            <xsl:call-template name="formatDate1">
                                <xsl:with-param name="DocDate" select="normalize-space(@requestedDeliveryDate)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="rdDate1">
                            <xsl:call-template name="formatDate2">
                                <xsl:with-param name="DocDate" select="normalize-space(@requestedDeliveryDate)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="dWindow">
                            <xsl:choose>
                                <xsl:when test="@deliveryWindow">
                                    <xsl:value-of select="normalize-space(@deliveryWindow)"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="testDate" as="xs:date">
                            <xsl:value-of select="xs:date($rdDate1)"/>
                        </xsl:variable>
                        <xsl:variable name="endDate">
                            <xsl:value-of select="$testDate + xs:dayTimeDuration(concat('P', $dWindow, 'D'))"/>
                        </xsl:variable>
                        <xsl:if test="$rdDate != ''">
                            <S_DTM>
                                <C_C507>
                                    <D_2005>2</D_2005>
                                    <D_2380>
                                        <xsl:value-of select="$rdDate"/>-<xsl:value-of select="replace($endDate, '-', '')"/></D_2380>
                                    <D_2379>718</D_2379>
                                </C_C507>
                            </S_DTM>
                        </xsl:if>
                        <xsl:if test="normalize-space(@requestedShipmentDate) != ''">
                            <S_DTM>
                                <C_C507>
                                    <D_2005>10</D_2005>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="DocDate" select="normalize-space(@requestedShipmentDate)"/>
                                    </xsl:call-template>
                                </C_C507>
                            </S_DTM>
                        </xsl:if>
                    </G_SG12>
                </xsl:if>
                <xsl:if test="normalize-space(ScheduleLineReleaseInfo/@cumulativeScheduledQuantity) != ''">
                    <G_SG12>
                        <S_QTY>
                            <C_C186>
                                <D_6063>3</D_6063>
                                <D_6060>
                                    <xsl:value-of select="format-number(ScheduleLineReleaseInfo/@cumulativeScheduledQuantity, '0.##')"/>
                                </D_6060>
                                <xsl:if test="normalize-space(ScheduleLineReleaseInfo/UnitOfMeasure) != ''">
                                    <D_6411>
                                        <xsl:value-of select="substring(normalize-space(ScheduleLineReleaseInfo/UnitOfMeasure), 1, 3)"/>
                                    </D_6411>
                                </xsl:if>
                            </C_C186>
                        </S_QTY>
                    </G_SG12>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="normalize-space(@quantity) != ''">
                <G_SG12>
                    <S_QTY>
                        <C_C186>
                            <D_6063>21</D_6063>
                            <D_6060>
                                <xsl:call-template name="formatDecimal">
                                    <xsl:with-param name="amount" select="@quantity"/>
                                </xsl:call-template>
                            </D_6060>
                            <xsl:if test="normalize-space(ItemDetail/UnitOfMeasure) != ''">
                                <D_6411>
                                    <xsl:value-of select="substring(ItemDetail/UnitOfMeasure, 1, 3)"/>
                                </D_6411>
                            </xsl:if>
                        </C_C186>
                    </S_QTY>
                </G_SG12>
            </xsl:if>
            <!--ReleaseInfo Qty-->
            <xsl:if test="normalize-space(ReleaseInfo/@cumulativeReceivedQuantity) != ''">
                <G_SG12>
                    <S_QTY>
                        <C_C186>
                            <D_6063>70</D_6063>
                            <D_6060>
                                <xsl:call-template name="formatDecimal">
                                    <xsl:with-param name="amount" select="ReleaseInfo/@cumulativeReceivedQuantity"/>
                                </xsl:call-template>
                            </D_6060>
                            <xsl:if test="normalize-space(ReleaseInfo/UnitOfMeasure) != ''">
                                <D_6411>
                                    <xsl:value-of select="substring(ReleaseInfo/UnitOfMeasure, 1, 3)"/>
                                </D_6411>
                            </xsl:if>
                        </C_C186>
                    </S_QTY>
                </G_SG12>
            </xsl:if>
            <!--ReleaseInfo-ShipNoticeReleaseInfo-@receivedQuantity Qty-->
            <xsl:if test="normalize-space(ReleaseInfo/ShipNoticeReleaseInfo/@receivedQuantity) != ''">
                <G_SG12>
                    <S_QTY>
                        <C_C186>
                            <D_6063>48</D_6063>
                            <D_6060>
                                <xsl:call-template name="formatDecimal">
                                    <xsl:with-param name="amount" select="ReleaseInfo/ShipNoticeReleaseInfo/@receivedQuantity"/>
                                </xsl:call-template>
                            </D_6060>
                            <xsl:if test="normalize-space(ReleaseInfo/ShipNoticeReleaseInfo/UnitOfMeasure) != ''">
                                <D_6411>
                                    <xsl:value-of select="substring(ReleaseInfo/ShipNoticeReleaseInfo/UnitOfMeasure, 1, 3)"/>
                                </D_6411>
                            </xsl:if>
                        </C_C186>
                    </S_QTY>
                    <xsl:if test=" normalize-space(ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/@shipNoticeDate) != ''">
                        <S_DTM>
                            <C_C507>
                                <D_2005>111</D_2005>
                                <xsl:call-template name="formatDate">
                                    <xsl:with-param name="DocDate" select="normalize-space(ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/@shipNoticeDate)"/>
                                </xsl:call-template>
                            </C_C507>
                        </S_DTM>
                    </xsl:if>
                    <xsl:if test=" normalize-space(ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/@shipNoticeID) != ''">
                        <G_SG13>
                            <S_RFF>
                                <C_C506>
                                    <D_1153>MA</D_1153>
                                    <D_1154>
                                        <xsl:value-of select="substring(normalize-space(ReleaseInfo/ShipNoticeReleaseInfo/ShipNoticeIDInfo/@shipNoticeID), 1, 35)"/>
                                    </D_1154>
                                </C_C506>
                            </S_RFF>
                        </G_SG13>
                    </xsl:if>
                </G_SG12>
            </xsl:if>
        </G_SG8>
    </xsl:template>
 
</xsl:stylesheet>
