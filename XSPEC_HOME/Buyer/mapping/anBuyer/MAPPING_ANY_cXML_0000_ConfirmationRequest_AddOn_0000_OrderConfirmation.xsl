<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPName"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <!--<xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:template match="Combined">
        <xsl:variable name="v_orderID">
            <xsl:choose>
                <!--Check for case of SA/SAR - OrderId value would appear as [10DIGITORDER][5DIGITITEMNO][FOR/JIT]- Example-[550000161900010JIT]-->
                <xsl:when test="string-length(Payload/cXML/Request/ConfirmationRequest/OrderReference/@orderID) > 10">
                    <xsl:value-of select="substring(Payload/cXML/Request/ConfirmationRequest/OrderReference/@orderID,1,10)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="Payload/cXML/Request/ConfirmationRequest/OrderReference/@orderID"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
        <xsl:variable name="v_sysid">
            <xsl:call-template name="MultiErpSysIdIN">
                <xsl:with-param name="p_ansysid"
                    select="Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
                <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Prepare the CrossRef path-->
        <xsl:variable name="v_pd">
            <xsl:call-template name="PrepareCrossref">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
                <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- cross reference -->
        <xsl:variable name="crossrefparamLookup" select="document($v_pd)"/>
        <!--Get the Port Details-->
        <xsl:variable name="v_port">
            <!--Call Template for Port Name-->
            <xsl:call-template name="FillPort">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Get the IsLogicalSystemEnabled details-->
        <xsl:variable name="v_LsEnabled">
            <!--Call Template for IsLogicalSystemEnabled-->
            <xsl:call-template name="LogicalSystemEnabled">
                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                <xsl:with-param name="p_pd" select="$v_pd"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="v_erpversion">
            <xsl:choose>
                <xsl:when test="$anERPName = 'S4CORE'">
                    <xsl:value-of select="'True'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'false'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <ARBCIG_ORDRSP>
            <IDOC>
                <xsl:attribute name="BEGIN">
                    <xsl:value-of select="'1'"/>
                </xsl:attribute>
                <EDI_DC40>
                    <xsl:attribute name="SEGMENT">
                        <xsl:value-of select="'1'"/>
                    </xsl:attribute>
                    <IDOCTYP>ARBCIG_ORDRSP</IDOCTYP>
                    <MESTYP>ORDRSP</MESTYP>
                    <!--Hardcode value is been pass, actually it should be PD Entries-->
                    <SNDPOR>
                        <xsl:value-of select="$v_port"/>
                    </SNDPOR>
                    <xsl:choose>
                        <xsl:when test="$v_LsEnabled != ''">
                            <SNDPRT>LS</SNDPRT>
                            <SNDPFC>LS</SNDPFC>
                            <SNDPRN>
                                <xsl:value-of select="$v_sysid"/>
                            </SNDPRN>
                            <RCVPRT>LS</RCVPRT>
                            <RCVPFC>LS</RCVPFC>
                            <RCVPRN>
                                <xsl:value-of select="$v_sysid"/>
                            </RCVPRN>
                        </xsl:when>
                        <xsl:otherwise>
                            <SNDPRT>LI</SNDPRT>
                            <SNDPFC>LI</SNDPFC>
                            <SNDPRN>
                                <xsl:value-of
                                    select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                                />
                            </SNDPRN>
                            <RCVPRT>LI</RCVPRT>
                            <RCVPFC>LI</RCVPFC>
                            <RCVPRN>
                                <xsl:value-of
                                    select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                                />
                            </RCVPRN>
                        </xsl:otherwise>
                    </xsl:choose>
                    <RCVPOR>
                        <xsl:value-of select="$v_port"/>
                    </RCVPOR>
                </EDI_DC40>
                <!-- Header Data -->
                <E1EDK01>
                    <xsl:attribute name="SEGMENT">
                        <xsl:value-of select="'1'"/>
                    </xsl:attribute>
                    <ACTION/>
                    <CURCY>
                        <xsl:choose>
                            <xsl:when test="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/Total">
                                <xsl:value-of select="substring(Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/Total/Money/@currency, 1, 3)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="substring(Payload/cXML/Request/ConfirmationRequest/ConfirmationItem[1]/ConfirmationStatus[1]/ItemIn/ItemDetail/UnitPrice/Money/@currency, 1, 3)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </CURCY>
                    <!-- Order Confirmation ID -->
                    <BELNR>
                        <xsl:value-of select="$v_orderID"/>
                    </BELNR>
                    <!-- Start of Header Level Attachment -->
                    <!-- Begin of IG-17553 for getting line level attachments & multiple attachments at both header and line item level -->
                    <xsl:call-template name="InboundMultiAttIdoc_Common">
                        <xsl:with-param name="headerAtt"
                            select="//ConfirmationHeader/Comments/Attachment/URL"/>
                        <xsl:with-param name="lineReference"                            
                            select="//ConfirmationItem/@lineNumber | //ConfirmationItem/ConfirmationStatus/Comments/Attachment/URL"/>
                    </xsl:call-template>
                    <!-- End of IG-17553 -->
                    <!-- Start of AN Payload ID for Document status update-->
                    <E1ARBCIG_ADDITIONAL_DATA>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <ANPAYLOAD_ID><xsl:value-of select="Payload/cXML/@payloadID"/></ANPAYLOAD_ID>
                        <ARIBANETWORKID>
                            <xsl:value-of select="$anReceiverID"/>
                        </ARIBANETWORKID>
                        <ERPSYSTEMID>
                            <xsl:value-of select="$v_sysid"/>
                        </ERPSYSTEMID>
                    </E1ARBCIG_ADDITIONAL_DATA>
                </E1EDK01>
                <xsl:if test="Payload/cXML/Request/ConfirmationRequest/OrderReference">
                    <E1EDK02>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <QUALF>
                            <xsl:value-of select="'001'"/>
                        </QUALF>
                        <BELNR>
                            <xsl:value-of select="$v_orderID"/>
                        </BELNR>
                    </E1EDK02>
                </xsl:if>
                <xsl:for-each select="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/Comments">
                    <E1EDKT1>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <!-- PD Entry -->
                        <xsl:choose>
                            <xsl:when test="string-length(upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/HeaderTextID))> 0">
                                <TDID>
                                    <xsl:value-of select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/HeaderTextID)"/>
                                </TDID>
                            </xsl:when>
                            <xsl:otherwise>
                                <TDID>
                                    <xsl:value-of select="'F15'"/>
                                </TDID>
                            </xsl:otherwise>
                        </xsl:choose> 
                        <!--Value map needed for TSSPRAS, PD entry needed-->
                        <xsl:variable name="v_lang" select="substring(@xml:lang, 1, 2)"/>
                        <TSSPRAS>
                            <xsl:value-of select="$v_lang"/>
                        </TSSPRAS>
                        <!--Value map needed for TSSPRAS_ISO, PD entry needed-->
                        <TSSPRAS_ISO>
                            <xsl:value-of select="$v_lang"/>
                        </TSSPRAS_ISO>
                        <TDOBJECT>
                            <xsl:value-of select="'EKKO'"/>
                        </TDOBJECT>
                        <TDOBNAME>
                            <xsl:value-of select="$v_orderID"/>
                        </TDOBNAME>
                        <xsl:call-template name="TextSplit">
                            <!-- Begin of IG-28081 -->
                            <xsl:with-param name="p_str" select="./text()[1]"/>
                            <!-- End of IG-28081 -->
                            <xsl:with-param name="p_strlen" select="70.0"/>
                            <xsl:with-param name="p_seg" select="'E1EDKT2'"/>
                        </xsl:call-template>
                    </E1EDKT1>
                </xsl:for-each>
                <!--Start of Line Item iteration -->
                <xsl:for-each select="Payload/cXML/Request/ConfirmationRequest/ConfirmationItem">
                    <xsl:variable name="v_ndate">
                        <xsl:value-of select="../ConfirmationHeader/@noticeDate"/>
                    </xsl:variable>
                    <xsl:if test="string-length(normalize-space(@parentLineNumber)) = 0">
                            <E1EDP01>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <POSEX>
                                    <xsl:value-of select="@lineNumber"/>
                                </POSEX>
                                <ACTION>
                                    <xsl:choose>
                                        <xsl:when test="ConfirmationStatus[@type = 'accept' or @type = 'detail' or 
                                            @type = 'allDetail' or @type = 'backordered']"><xsl:value-of select="'002'"/></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="'003'"/></xsl:otherwise>
                                    </xsl:choose>
                                </ACTION>
                                <xsl:variable name="v_qty">
                                    <xsl:for-each select="ConfirmationStatus">
                                        <xsl:if test="@type != 'unknown'">
                                            <qty>
                                                <xsl:value-of select="translate(@quantity, ',','')"/>   <!-- IG-42629 (Removed ',') -->
                                            </qty>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:variable name="v_qtysum">
                                    <xsl:value-of select="format-number(sum($v_qty/qty), '0.000')"/>
                                </xsl:variable>
                                <MENGE>
                                    <xsl:value-of select="$v_qtysum"/>
                                </MENGE>
                                <!-- Look up PD -->
                                    <MENEE>
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput" select="UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </MENEE>
                                <!-- Look up PD -->
                                <xsl:for-each select="ConfirmationStatus">
                                    <xsl:if test="@type != 'unknown' and @type != 'reject'">
                                        <xsl:if
                                            test="string-length(normalize-space(ItemIn/ItemDetail/PriceBasisQuantity/UnitOfMeasure)) > 0 ">
                                            <PMENE>
                                                <xsl:call-template name="UOMTemplate_In">
                                                    <xsl:with-param name="p_UOMinput" select="ItemIn/ItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                                                    <xsl:with-param name="p_anERPSystemID"
                                                        select="$anERPSystemID"/>
                                                    <xsl:with-param name="p_anSupplierANID"
                                                        select="$anReceiverID"/>
                                                </xsl:call-template>
                                            </PMENE>
                                        </xsl:if>
                                        <VPREI>
                                            <xsl:value-of select="translate(substring(ItemIn/ItemDetail/UnitPrice/Money, 1, 15),',','')"/> <!-- IG-42629 (Removed ',') -->
                                        </VPREI>
                                        <PEINH>
                                            <xsl:value-of
                                                select="translate(substring(ItemIn/ItemDetail/PriceBasisQuantity/@quantity, 1, 9),',','')"/> <!-- IG-42629 (Removed ',') -->
                                        </PEINH>
                                        <NETWR>
                                            <!-- IG-15086 -->                                            
                                            <xsl:choose>
                                                <xsl:when test="exists(ItemIn/ItemDetail/UnitPrice/Money) and string-length(normalize-space(ItemIn/ItemDetail/UnitPrice/Money)) > 0">
                                                    <!-- Start of IG-24896 : Considering price unit if exists -->
                                                    <!-- <xsl:value-of
                                                        select="format-number($v_qtysum * ItemIn/ItemDetail/UnitPrice/Money, '0.00')"
                                                    />-->
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test="exists(ItemIn/ItemDetail/PriceBasisQuantity/@quantity) and string-length(normalize-space(ItemIn/ItemDetail/PriceBasisQuantity/@quantity)) > 0">
                                                            <xsl:variable name="v_netprice">
                                                                <xsl:value-of select="translate(format-number($v_qtysum * ItemIn/ItemDetail/UnitPrice/Money, '0.00'), ',','')"/>               <!-- IG-42629 (Removed ',') -->
                                                            </xsl:variable>
                                                            <xsl:value-of select="translate(format-number($v_netprice div ItemIn/ItemDetail/PriceBasisQuantity/@quantity, '0.00'), ',','')"/>  <!-- IG-42629 (Removed ',') -->
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="translate(format-number($v_qtysum * ItemIn/ItemDetail/UnitPrice/Money, '0.00'), ',','')"/>                   <!-- IG-42629 (Removed ',') -->
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    <!-- End of IG-24896 : Considering price unit if exists -->
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0.00'"/>
                                                </xsl:otherwise>
                                            </xsl:choose> 
                                        </NETWR>
                                    </xsl:if>
                                </xsl:for-each>
                                <E1EDP02>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'001'"/>
                                    </QUALF>
                                    <BELNR>
                                        <xsl:value-of select="$v_orderID"/>
                                    </BELNR>
                                    <ZEILE>
                                        <xsl:value-of select="@lineNumber"/>
                                    </ZEILE>
                                    <DATUM>
                                        <xsl:value-of
                                            select='translate(substring($v_ndate, 0, 11), "-", "")'
                                        />
                                    </DATUM>
                                </E1EDP02>
                                <E1EDP02>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'002'"/>
                                    </QUALF>
                                    <BELNR>
                                        <xsl:value-of select="substring(../ConfirmationHeader/@confirmID, 1, 35)"/>
                                    </BELNR>
                                    <!--Time Zone added -->
                                    <xsl:variable name="v_erpdate">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date"
                                                select="$v_ndate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <DATUM>
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                        />
                                    </DATUM> 
                                    <UZEIT>
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 12, 8), ':', '')"
                                        />
                                    </UZEIT>
                                </E1EDP02>
                                <xsl:for-each select="ConfirmationStatus">
                                    <xsl:if test="@type != 'unknown' and @type != 'reject'">
                                        <E1EDP20>
                                            <xsl:attribute name="SEGMENT">
                                                <xsl:value-of select="'1'"/>
                                            </xsl:attribute>
                                            <WMENG>
                                                <xsl:value-of select="translate(substring(@quantity, 1, 15), ',','')"/>  <!-- IG-42629 (Removed ',') -->
                                            </WMENG>
                                            <xsl:choose>
                                                <xsl:when
                                                    test="string-length(normalize-space(@deliveryDate)) > 0 ">
                                                    <!--Timezone is added for delivery date-->
                                                    <xsl:variable name="v_erpdate">
                                                        <xsl:call-template name="ERPDateTime">
                                                            <xsl:with-param name="p_date"
                                                                select="@deliveryDate"/>
                                                            <xsl:with-param name="p_timezone"
                                                                select="$anERPTimeZone"/>
                                                        </xsl:call-template>
                                                    </xsl:variable>
                                                    <EDATU>
                                                        <xsl:value-of
                                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                                        />
                                                    </EDATU>  
                                                    <EZEIT>
                                                        <xsl:value-of
                                                            select="translate(substring($v_erpdate, 12, 8), ':', '')"
                                                        />
                                                    </EZEIT>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- Will have to maintain the delivery date in SAP if delivery date is not sent in cXML -->
                                                    <EDATU/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </E1EDP20>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="ConfirmationStatus[1]">
                                    <xsl:if test="@type != 'unknown'">
                                        <xsl:if test="string-length(normalize-space(ItemIn/ItemID/BuyerPartID)) > 0">
                                            <E1EDP19>
                                                <xsl:attribute name="SEGMENT">1</xsl:attribute>
                                                <QUALF>
                                                    <xsl:value-of select="'001'"/>
                                                </QUALF>
                                                <xsl:choose>
                                                    <xsl:when test="$v_erpversion = 'True'">
                                                        <IDTNR_LONG>
                                                            <xsl:value-of
                                                                select="ItemIn/ItemID/BuyerPartID"/>
                                                        </IDTNR_LONG>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <IDTNR>
                                                            <xsl:value-of
                                                                select="ItemIn/ItemID/BuyerPartID"/>
                                                        </IDTNR>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </E1EDP19>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(ItemIn/ItemID/SupplierPartID)) > 0">
                                            <E1EDP19>
                                                <xsl:attribute name="SEGMENT">
                                                    <xsl:value-of select="'1'"/>
                                                </xsl:attribute>
                                                <QUALF>
                                                    <xsl:value-of select="'002'"/>
                                                </QUALF>
                                                <xsl:choose>
                                                    <xsl:when test="$v_erpversion = 'True'">
                                                        <IDTNR_LONG>
                                                            <xsl:value-of
                                                                select="ItemIn/ItemID/SupplierPartID"/>
                                                        </IDTNR_LONG>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <IDTNR>
                                                            <xsl:value-of
                                                                select="ItemIn/ItemID/SupplierPartID"/>
                                                        </IDTNR>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </E1EDP19>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(ItemIn/ItemDetail/ManufacturerPartID)) > 0">
                                            <E1EDP19>
                                                <xsl:attribute name="SEGMENT">
                                                    <xsl:value-of select="'1'"/>
                                                </xsl:attribute>
                                                <QUALF>
                                                   
                                                        <xsl:value-of select="'004'"/>
                                                    
                                                </QUALF>
                                                <MFRPN>
                                                    <xsl:value-of
                                                        select="ItemIn/ItemDetail/ManufacturerPartID"/>
                                                </MFRPN>
                                            </E1EDP19>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="ConfirmationStatus">
                                    <xsl:if test="Comments/text()">
                                    <xsl:if test="@type != 'unknown'">
                                        <E1EDPT1>
                                            <xsl:attribute name="SEGMENT">
                                                <xsl:value-of select="'1'"/>
                                            </xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="string-length(upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/LineTextID))> 0">
                                                    <TDID>
                                                        <xsl:value-of
                                                            select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/LineTextID)"/>
                                                    </TDID>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <TDID>
                                                        <xsl:value-of select="'F04'"/>
                                                    </TDID>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <TSSPRAS>
                                                <!-- IG-41842-->
                                                <xsl:value-of
                                                  select="substring(Comments[1]/@xml:lang, 1, 2)"/>
                                            </TSSPRAS>
                                            <TSSPRAS_ISO>
                                                <!-- IG-41842-->
                                                <xsl:value-of
                                                  select="substring(Comments[1]/@xml:lang, 1, 2)"/>
                                            </TSSPRAS_ISO>
                                            <!--  IG-40065 Begin -added for each loop for comments since integrated supplier scenario, there is a possibility of sending multiple comments in same confirmation.-->                                                                                        
                                            <xsl:for-each select="Comments">                                            
                                            <xsl:call-template name="TextSplit">
                                                <xsl:with-param name="p_str" select="./text()[1]"/>
                                                <xsl:with-param name="p_strlen" select="70"/>
                                                <xsl:with-param name="p_seg" select="'E1EDPT2'"/>
                                            </xsl:call-template>
                                            </xsl:for-each>
                                        </E1EDPT1>
                                    </xsl:if>
                                    </xsl:if>   
                                </xsl:for-each>
                            </E1EDP01>
                    </xsl:if>
                </xsl:for-each>
            </IDOC>
        </ARBCIG_ORDRSP>
    </xsl:template>
    <!--  User Defined Templates for text Split-->
    <xsl:template name="TextSplit">
        <xsl:param name="p_str"/>
        <xsl:param name="p_strlen"/>
        <xsl:param name="p_seg"/>
        <xsl:variable name="v_str1" select="substring($p_str, 1, $p_strlen)"/>
        <xsl:variable name="v_str2" select="substring($p_str, $p_strlen + 1)"/>
        <xsl:if test="$v_str1">
            <xsl:if test="$p_seg != ''">
                <xsl:element name="{$p_seg}">
                    <xsl:attribute name="SEGMENT">
                        <xsl:value-of select="'1'"/>
                    </xsl:attribute>
                    <TDLINE>
                        <xsl:value-of select="$v_str1"/>
                    </TDLINE>
                    <TDFORMAT>
                        <xsl:choose>
                            <xsl:when test="string-length($v_str1) &lt; 70">=</xsl:when>
                            <xsl:otherwise>*</xsl:otherwise>
                        </xsl:choose>
                    </TDFORMAT>
                </xsl:element>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$v_str2">
            <xsl:call-template name="TextSplit">
                <xsl:with-param name="p_str" select="$v_str2"/>
                <xsl:with-param name="p_strlen" select="$p_strlen"/>
                <xsl:with-param name="p_seg" select="$p_seg"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
