<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="anERPName"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/> 
    <xsl:param name="anAddOnCIVersion"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
    <xsl:variable name="v_flag"/>
    <xsl:variable name="v_erpversion"/>
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
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
    <!--Get the Language code-->
    <xsl:variable name="v_lang">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <!-- start IG-23905 segment E1EDK18 needs baseline payment date for successful Idoc posting--> 
    <xsl:variable name="v_sendpaymentterms">
        <xsl:call-template name="SendPaymentTerms">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <!-- end IG-23905 -->
    <xsl:variable name="v_comment_lang">
        <xsl:choose>
            <xsl:when
                test="string-length(normalize-space(Combined/Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/@xml:lang)) > 0">
                <xsl:value-of
                    select="Combined/Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/@xml:lang"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$v_lang"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
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
    <!--    Check CIG Addon Version-->
    <xsl:variable name="v_addOnCIversion">
        <xsl:value-of select="substring($anAddOnCIVersion, 9, 10)"/>
    </xsl:variable>    
    <!-- IG-33868 Mapping negative Quantity Based on CIG AllowNegativeQuantity Parameter -->
    <xsl:variable name="v_NegativeQuantity">
        <xsl:call-template name="NegativeQuantity">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
       <xsl:template match="Combined">
        <xsl:variable name="v_poflag"
            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo[OrderReference[string-length(normalize-space(@orderID)) > 0] or MasterAgreementReference[string-length(normalize-space(@agreementID)) > 0] or OrderIDInfo[string-length(normalize-space(@orderID)) > 0] or MasterAgreementIDInfo[string-length(normalize-space(@agreementID)) > 0]]">        
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
          <ARBCIG_INVOIC>
                <!--Root Element has to be change-->
                <IDOC>
                    <xsl:attribute name="BEGIN">
                        <xsl:value-of select="'1'"/>
                    </xsl:attribute>
                    <EDI_DC40>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <IDOCTYP>
                            <xsl:value-of select="'ARBCIG_INVOIC'"/>
                        </IDOCTYP>
                        <MESTYP>
                            <xsl:value-of select="'INVOIC'"/>
                        </MESTYP>
                        <SNDPOR>
                            <xsl:value-of select="$v_port"/>
                        </SNDPOR>
                        <xsl:choose>
                            <xsl:when test="$v_LsEnabled = 'X'">
                                <SNDPRT>
                                    <xsl:value-of select="'LS'"/>
                                </SNDPRT>
                                <SNDPFC>
                                    <xsl:value-of select="'LS'"/>
                                </SNDPFC>
                                <SNDPRN>
                                    <xsl:value-of select="$v_sysid"/>
                                </SNDPRN>
                                <RCVPRT>
                                    <xsl:value-of select="'LS'"/>
                                </RCVPRT>
                                <RCVPFC>
                                    <xsl:value-of select="'LS'"/>
                                </RCVPFC>
                                <RCVPRN>
                                    <xsl:value-of select="$v_sysid"/>
                                </RCVPRN>
                            </xsl:when>
                            <xsl:otherwise>
                                <SNDPRT>
                                    <xsl:value-of select="'LI'"/>
                                </SNDPRT>
                                <SNDPFC>
                                    <xsl:value-of select="'LI'"/>
                                </SNDPFC>
                                <SNDPRN>
                                    <xsl:value-of
                                        select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                                    />
                                </SNDPRN>
                                <RCVPRT>
                                    <xsl:value-of select="'LI'"/>
                                </RCVPRT>
                                <RCVPFC>
                                    <xsl:value-of select="'LI'"/>
                                </RCVPFC>
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
                    <!--Header Level Mapping-->
                    <E1EDK01>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <CURCY>
                            <xsl:value-of
                                select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money/@currency"
                            />
                        </CURCY>
                        <!-- Single For each should be used -->
                        <xsl:for-each
                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic/@name">
                            <!-- IG-23840-->
                            <xsl:if test='lower-case(.) = "buyervatid"'>
                            <!-- IG-23840-->     
                                <KUNDEUINR>
                                    <xsl:value-of select=".."/>
                                </KUNDEUINR>
                            </xsl:if>
                            <!-- IG-23840-->
                            <xsl:if test='lower-case(.) = "suppliervatid"'>
                             <!-- IG-23840-->    
                                <EIGENUINR>
                                    <xsl:value-of select=".."/>
                                </EIGENUINR>
                            </xsl:if>
                        </xsl:for-each>
                        <!--Determining Invoice or Credit Memo-->
                        <xsl:choose>
                            <!-- Also Determine Subsequent Credit / Subsequent Debit document types-->
                            <xsl:when
                                test='Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isPriceAdjustmentInLine = "yes"'>
                                <xsl:choose>
                                    <xsl:when
                                        test='Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = "lineLevelDebitMemo"'>
                                        <BSART>
                                            <xsl:value-of select="'SUBD'"/>
                                        </BSART>
                                    </xsl:when>
                                    <xsl:when
                                        test='Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = "lineLevelCreditMemo"'>
                                        <BSART>
                                            <xsl:value-of select="'SUBC'"/>
                                        </BSART>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:when>
                            <!--Continue with existing logic-->
                            <xsl:when
                                test='Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = "standard"'>
                                <BSART>
                                    <xsl:value-of select="'INVO'"/>
                                </BSART>
                            </xsl:when>
                            <xsl:otherwise>
                                <BSART>
                                    <xsl:value-of select="'CRME'"/>
                                </BSART>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if
                            test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/text()">
                            <E1ARBCIG_COMMENT>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <!--Call Template to fill Comments-->
                                <xsl:call-template name="CommentsFillIdocIn">
                                    <xsl:with-param name="p_comments"
                                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments"/>
                                    <xsl:with-param name="p_lang" select="$v_comment_lang"/>
                                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                </xsl:call-template>
                            </E1ARBCIG_COMMENT>
                        </xsl:if>
                        <!-- Change the template for multiple IDOC attachments IG-18568 -->
                        <xsl:call-template name="InboundMultiAttIdoc_Common">
                            <xsl:with-param name="headerAtt"
                                select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments/Attachment/URL"/>
                            <xsl:with-param name="lineReference"
                                select="
                                (Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/@invoiceLineNumber
                                | Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/Comments/Attachment/URL)
                                |(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/@invoiceLineNumber
                                | Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem/Comments/Attachment/URL)"
                            />
                        </xsl:call-template>
                        <E1ARBCIG_ADDITIONAL_DATA>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <ANPAYLOAD_ID>
                                <xsl:value-of select="substring(Payload/cXML/@payloadID, 1, 255)"/>
                            </ANPAYLOAD_ID>
                            <ARIBANETWORKID>
                                <xsl:value-of select="substring($anReceiverID, 1, 30)"/>
                            </ARIBANETWORKID>
                            <ERPSYSTEMID>
                                <xsl:value-of select="substring($v_sysid, 1, 10)"/>
                            </ERPSYSTEMID>
                            <xsl:if test="$v_addOnCIversion &gt;= '08'">
                              <xsl:if test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@isHeaderInvoice = 'yes'">
                                 <HEADER_FLAG>
                                     <xsl:value-of select="'X'"/>
                                 </HEADER_FLAG>
                              </xsl:if>
                              <xsl:if test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@isInformationOnly = 'yes'">
                                <INFO_FLAG>
                                    <xsl:value-of select="'X'"/>
                                </INFO_FLAG> 
                              </xsl:if>
                            </xsl:if>
                        </E1ARBCIG_ADDITIONAL_DATA>
                        <xsl:if test="$v_addOnCIversion &gt;= '09'">                        
                            <xsl:if test="exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount) or 
                                exists(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount)">                         
                                <E1ARBCIG_UNPLAN_DELIV>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>                                    
                                    <xsl:if test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@purpose ='shippingTax' or 
                                        Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount">
                                        <SHIPPING_MWSKZ>
                                            <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='shippingTax']/@category, 1, 7)"/>
                                        </SHIPPING_MWSKZ> 
                                        <SHIPPING_MSATZ>
                                            <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='shippingTax']/@percentageRate, 1, 17)"/>                                    
                                        </SHIPPING_MSATZ>
                                        <SHIPPING_MWSBT>
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='shippingTax']/TaxAmount/Money)) > 0">
                                                    <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='shippingTax']/TaxAmount/Money, 1, 18)"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(normalize-space(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money)) > 0">
                                                    <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money, 1, 18)"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </SHIPPING_MWSBT>  
                                    </xsl:if>
                                        <xsl:if test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@purpose ='specialHandlingTax'or Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount">                        
                                            <SPECIAL_HANDLING_MWSKZ>
                                                <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='specialHandlingTax']/@category, 1, 7)"/>
                                            </SPECIAL_HANDLING_MWSKZ> 
                                            <SPECIAL_HANDLING_MSATZ>
                                                <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='specialHandlingTax']/@percentageRate, 1, 17)"/>                                    
                                            </SPECIAL_HANDLING_MSATZ>
                                            <SPECIAL_HANDLING_MWSBT>
                                                <xsl:choose>
                                                    <xsl:when test="string-length(normalize-space(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='specialHandlingTax']/TaxAmount/Money)) > 0">
                                                        <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[@purpose ='specialHandlingTax']/TaxAmount/Money, 1, 18)"/>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(normalize-space(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money)) > 0">
                                                        <xsl:value-of select="substring(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money, 1, 18)"/>
                                                    </xsl:when>
                                                </xsl:choose> 
                                            </SPECIAL_HANDLING_MWSBT>    
                                        </xsl:if> 
                                </E1ARBCIG_UNPLAN_DELIV>
                            </xsl:if>  
                        </xsl:if>                       
                    </E1EDK01>
                    <!--                    Details of Remit to-->
                        <xsl:for-each
                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'remitTo']">
                         <E1EDKA1>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <PARVW>
                                <xsl:value-of select="'RS'"/>
                            </PARVW>
                            <PARTN>
                                <xsl:value-of select="substring(@addressID, 1, 17)"/>
                            </PARTN>
                            <NAME1>
                                <xsl:value-of select="substring(Name, 1, 35)"/>
                            </NAME1>
                            <NAME2>
                                <xsl:value-of select="substring(PostalAddress/@name, 1, 35)"/>
                            </NAME2>
                            <!--If the lenght of the Street is greater than 35 or more substring(0,35) and Pass the remaining to <STRS2>-->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(PostalAddress/Street[1])) > 35">
                                    <STRAS>
                                        <xsl:value-of
                                            select="substring(PostalAddress/Street[1], 0, 35)"/>
                                        <!--0 to 35-->
                                    </STRAS>
                                    <STRS2>
                                        <xsl:value-of
                                            select="substring(PostalAddress/Street[1], 35, 34)"/>
                                    </STRS2>
                                </xsl:when>
                                <xsl:otherwise>
                                    <STRAS>
                                        <xsl:value-of select="substring(PostalAddress/Street[1], 0, 35)"/>
                                        <!--o to 35-->
                                    </STRAS>
                                    <STRS2/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!--end-->
                            <ORT01>
                                <xsl:value-of select="substring(PostalAddress/City, 1, 35)"/>
                            </ORT01>
                            <COUNC>
                                <xsl:value-of select="substring(PostalAddress/State, 1, 9)"/>
                            </COUNC>
                            <PSTLZ>
                                <xsl:value-of select="substring(PostalAddress/PostalCode, 1, 9)"/>
                            </PSTLZ>
                            <LAND1>
                                <xsl:value-of select="substring(PostalAddress/Country/@isoCountryCode, 1, 3)"/>
                            </LAND1>
                            <!--Concate Country Code, Area or City Code and Number-->
                             <!--IG-31067: Pick the values from first occurance.-->
                            <TELF1>
                                <xsl:value-of
                                    select="concat(Phone[1]/TelephoneNumber[1]/CountryCode, Phone[1]/TelephoneNumber[1]/AreaOrCityCode, Phone[1]/TelephoneNumber[1]/Number)"
                                />
                            </TELF1>
                            <TELF2>
                                <xsl:value-of select="' '"/>
                            </TELF2>
                             <!--IG-31067: Pick the values from first occurance.-->
                            <TELFX>
                                <xsl:value-of
                                    select="concat(Fax[1]/TelephoneNumber[1]/CountryCode, Fax[1]/TelephoneNumber[1]/AreaOrCityCode, Fax[1]/TelephoneNumber[1]/Number)"
                                />
                            </TELFX>
                            <SPRAS_ISO>
                                <xsl:value-of select="substring(Name/@xml:lang, 1, 2)"/>
                            </SPRAS_ISO>
                            </E1EDKA1> 
                        </xsl:for-each>
                    <!-- Company Code Data billTo-->
                    <!--Test should be done for pass only PARVW "RE"-->                                          
                        <xsl:for-each
                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'billTo']">
                         <E1EDKA1>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <PARVW>
                                <xsl:value-of select="'RE'"/>
                            </PARVW>
                            <PARTN>
                                <xsl:value-of select="substring(@addressID, 1, 17)"/>
                            </PARTN>
                            <NAME1>
                                <xsl:value-of select="substring(Name, 1, 35)"/>
                            </NAME1>
                            <NAME2>
                                <xsl:value-of select="substring(PostalAddress/@name, 1, 35)"/>
                            </NAME2>
                            <!--If the lenght of the Street is greater than 35 or more substring(0,35) and Pass the remaining to <STRS2>-->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(PostalAddress/Street[1])) > 35">
                                    <STRAS>
                                        <xsl:value-of
                                            select="substring(PostalAddress/Street[1], 0, 35)"/>
                                        <!--0 to 35-->
                                    </STRAS>
                                    <STRS2>
                                        <xsl:value-of
                                            select="substring(PostalAddress/Street[1], 35, 34)"/>
                                    </STRS2>
                                </xsl:when>
                                <xsl:otherwise>
                                    <STRAS>
                                        <xsl:value-of select="PostalAddress/Street[1]"/>
                                        <!--o to 35-->
                                    </STRAS>
                                    <STRS2/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!--end-->
                             <ORT01>
                                 <xsl:value-of select="substring(PostalAddress/City, 1, 35)"/>
                             </ORT01>
                             <COUNC>
                                 <xsl:value-of select="substring(PostalAddress/State, 1,9)"/>
                             </COUNC>
                             <PSTLZ>
                                 <xsl:value-of select="substring(PostalAddress/PostalCode, 1, 9)"/>
                             </PSTLZ>
                             <LAND1>
                                 <xsl:value-of select="substring(PostalAddress/Country/@isoCountryCode, 1, 3)"/>
                             </LAND1>
                             <!--Concate Country Code, Area or City Code and Number-->
                             <!--IG-31067: Pick the values from first occurance.-->
                             <TELF1>
                                 <xsl:value-of
                                     select="concat(Phone[1]/TelephoneNumber[1]/CountryCode, Phone[1]/TelephoneNumber[1]/AreaOrCityCode, Phone[1]/TelephoneNumber[1]/Number)"
                                 />
                             </TELF1>
                             <TELF2>
                                 <xsl:value-of select="' '"/>
                             </TELF2>
                             <!--IG-31067: Pick the values from first occurance.-->
                             <TELFX>
                                 <xsl:value-of
                                     select="concat(Fax[1]/TelephoneNumber[1]/CountryCode, Fax[1]/TelephoneNumber[1]/AreaOrCityCode, Fax[1]/TelephoneNumber[1]/Number)"
                                 />
                             </TELFX>
                             <SPRAS_ISO>
                                 <xsl:value-of select="substring(Name/@xml:lang, 1, 2)"/>
                             </SPRAS_ISO>
                         </E1EDKA1>
                        </xsl:for-each>                    
                    <!-- Vendor Data-->
                    <E1EDKA1>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <PARVW>
                            <xsl:value-of select="'LF'"/>
                        </PARVW>
                        <PARTN>
                            <xsl:value-of
                                select="Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                            />
                        </PARTN>
                    </E1EDKA1>
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader">
                        <E1EDK02>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <QUALF>
                                <xsl:value-of select="'009'"/>
                            </QUALF>
                            <BELNR>
                                <xsl:value-of select="@invoiceID"/>
                            </BELNR>
                            <!-- Convert the AN date into ERP -->
                                <xsl:variable name="v_erpdate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="@invoiceDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                            <DATUM>
                                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 1, 10), '-', '')"/>
                                </DATUM>
                            <UZEIT>
                                    <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 12, 8), ':', '')"/>
                                </UZEIT>
                        </E1EDK02>
                    </xsl:for-each>
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/MasterAgreementReference">
                        <xsl:if test="string-length(normalize-space(@agreementID)) > 0">
                            <!--Have revisit wrt SAP PI-->
                            <E1EDK02>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <QUALF>
                                    <xsl:value-of select="'072'"/>
                                </QUALF>
                                <BELNR>
                                    <xsl:value-of select="@agreementID"/>
                                </BELNR>
                                <!-- Convert the AN date into ERP -->
                                <xsl:variable name="v_erpdate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="@agreementDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <DATUM>
                                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 1, 10), '-', '')"/>
                                </DATUM>
                                <UZEIT>
                                    <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 12, 8), ':', '')"/>
                                </UZEIT>
                            </E1EDK02>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/ShipNoticeIDInfo/@shipNoticeID">
                        <xsl:if test='string-length(.) > 0'>
                            <E1EDK02>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <QUALF>
                                    <xsl:value-of select="'012'"/>
                                </QUALF>
                                <BELNR>
                                    <xsl:value-of select="."/>
                                </BELNR>
                                <!-- Convert the AN date into ERP -->
                                <xsl:variable name="v_erpdate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="../@shipNoticeDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <DATUM>
                                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 1, 10), '-', '')"/>
                                </DATUM>
                                <UZEIT>
                                    <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 12, 8), ':', '')"/>
                                </UZEIT>
                            </E1EDK02>
                        </xsl:if>
                    </xsl:for-each>
                    <!--                Start Support for BSAO - Mapping Reference Documents number-->
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/MasterAgreementIDInfo">
                        <xsl:if test="string-length(normalize-space(@agreementID)) > 0">
                            <E1EDK02>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <QUALF>
                                    <xsl:value-of select="'072'"/>
                                </QUALF>
                                <BELNR>
                                    <xsl:value-of select="@agreementID"/>
                                </BELNR>
                                <!-- Convert the AN date into ERP -->
                                <xsl:variable name="v_erpdate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date" select="@agreementDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <DATUM>
                                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 1, 10), '-', '')"/>
                                </DATUM>
                                <UZEIT>
                                    <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                    <xsl:value-of
                                        select="translate(substring($v_erpdate, 12, 8), ':', '')"/>
                                </UZEIT>
                            </E1EDK02>
                        </xsl:if>
                    </xsl:for-each>
                    <!--                End Support for BSAO Mapping Reference Documents number.-->
                    <E1EDK03>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <IDDAT>
                            <xsl:value-of select="'012'"/>
                        </IDDAT>
                        <!-- Time based on system ID Need Discuss with Senthil-->
                        <!-- Convert the AN date into ERP -->
                        <xsl:variable name="v_erpdate">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date"
                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <DATUM>
                            <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                            <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"
                            />
                        </DATUM>
                        <UZEIT>
                            <!--Convert the Time into SAP Time format is'HHMMSS'-->
                            <xsl:value-of select="translate(substring($v_erpdate, 12, 8), ':', '')"
                            />
                        </UZEIT>
                    </E1EDK03>
                    <!--                Start- Support for BSAO Baseline Date-->
                    <E1EDK03>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <IDDAT>
                            <xsl:value-of select="'044'"/>
                        </IDDAT>
                        <xsl:variable name="v_erpdate">
                            <xsl:call-template name="ERPDateTime">
                                <xsl:with-param name="p_date"
                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate"/>
                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <DATUM>
                            <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                            <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"
                            />
                        </DATUM>
                        <UZEIT>
                            <!--Convert the Time into SAP Time format is'HHMMSS'-->
                            <xsl:value-of select="translate(substring($v_erpdate, 12, 8), ':', '')"
                            />
                        </UZEIT>
                    </E1EDK03>
                    <!--                End Support for BSAO Baseline date-->
                    <!-- IG-23905 segment E1EDK18 needs baseline payment date for successful Idoc posting--> 
                    <xsl:if test="string-length($v_sendpaymentterms) > 0">    
                        <E1EDK03>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <IDDAT>
                                <xsl:value-of select="'024'"/>
                            </IDDAT>
                            <xsl:variable name="v_erpdate">
                                <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date"
                                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <DATUM>
                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                />
                            </DATUM>
                            <UZEIT>
                                <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                <xsl:value-of select="translate(substring($v_erpdate, 12, 8), ':', '')"
                                />
                            </UZEIT>
                        </E1EDK03>
                    </xsl:if>
                    <!-- Shipping line-->
                    <E1EDK05>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <ALCKZ>
                            <xsl:value-of select="'+'"/>
                        </ALCKZ>
                        <KSCHL>
                            <xsl:value-of select="'FRB1'"/>
                        </KSCHL>
                        <xsl:if
                            test="not(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isShippingInLine)">
                            <BETRG>
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str"
                                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money"
                                    />
                                </xsl:call-template>
                            </BETRG>
                            <KOEIN>
                                <xsl:value-of
                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money/@currency"
                                />
                            </KOEIN>
                        </xsl:if>
                    </E1EDK05>
                    <!-- Special handling Line-->
                    <E1EDK05>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <ALCKZ>
                            <xsl:value-of select="'+'"/>
                        </ALCKZ>
                        <KSCHL>
                            <xsl:value-of select="'ZB00'"/>
                        </KSCHL>
                        <xsl:if
                            test="not(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isSpecialHandlingInLine)">
                            <BETRG>
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str"
                                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money"
                                    />
                                </xsl:call-template>
                            </BETRG>
                            <KOEIN>
                                <xsl:value-of
                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money/@currency"
                                />
                            </KOEIN>
                        </xsl:if>
                    </E1EDK05>
                    <!--Discount Line-->
                    <E1EDK05>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <ALCKZ>
                            <xsl:value-of select="'-'"/>
                        </ALCKZ>
                        <KSCHL>
                            <xsl:value-of select="'RB00'"/>
                        </KSCHL>
                        <xsl:if
                            test="not(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isDiscountInLine)">
                            <BETRG>
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str"
                                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money"
                                    />
                                </xsl:call-template>
                            </BETRG>
                            <KOEIN>
                                <xsl:value-of
                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money/@currency"
                                />
                            </KOEIN>
                        </xsl:if>
                    </E1EDK05>
                    <xsl:if
                        test="not(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isTaxInLine)">
                        <xsl:for-each
                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail">
                        <E1EDK04>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <MWSKZ>
                                <xsl:call-template name="TaxTypeMap">
                                    <xsl:with-param name="p_taxcat" select="@category"/>
                                    <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                    <xsl:with-param name="p_anReceiverID" select="$anReceiverID"/>
                                    <xsl:with-param name="p_anSourceDocumentType" select="$anSourceDocumentType"/>
                                </xsl:call-template>                                
                            </MWSKZ>                         
                            <MSATZ>
                                <xsl:value-of select="@percentageRate"/>
                            </MSATZ>
                            <xsl:choose>
                                <xsl:when test="./TaxAmount/Money eq '0.00'">
                                    <MWSBT>
                                        <xsl:value-of select="./TaxAmount/Money"/>
                                    </MWSBT>
                                </xsl:when>
                                <xsl:otherwise>
                                    <MWSBT>
                                        <xsl:call-template name="ParseNumber">
                                            <xsl:with-param name="p_str" select="./TaxAmount/Money"/>
                                        </xsl:call-template>
                                    </MWSBT>
                                </xsl:otherwise>
                            </xsl:choose>                            
                        </E1EDK04>
                        </xsl:for-each>
                    </xsl:if>
                    <!-- start   Supporting Payment Terms for BSAO             -->
                    <!-- IG-23905  Adding segment = 1 and replacing the correct field label for PERC E1EDK18 -->
                    <xsl:if test="string-length($v_sendpaymentterms) > 0"> 
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/PaymentTerm">
                        <xsl:if test="position() = 1">
                            <E1EDK18>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <QUALF>
                                    <xsl:value-of select="'001'"/>
                                </QUALF>
                                <TAGE>
                                    <xsl:value-of select="@payInNumberOfDays"/>
                                </TAGE>
                                <PRZNT>
                                    <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                                </PRZNT>
                            </E1EDK18>
                        </xsl:if>
                        <xsl:if test="position() = 2">
                            <E1EDK18>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <QUALF>
                                    <xsl:value-of select="'002'"/>
                                </QUALF>
                                <TAGE>
                                    <xsl:value-of select="@payInNumberOfDays"/>
                                </TAGE>
                                <PRZNT>
                                    <xsl:value-of select="Discount/DiscountPercent/@percent"/>
                                </PRZNT>
                            </E1EDK18>
                        </xsl:if>
                        <xsl:if test="position() = 3">
                            <E1EDK18>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <QUALF>
                                    <xsl:value-of select="'003'"/>
                                </QUALF>
                                <TAGE>
                                    <xsl:value-of select="@payInNumberOfDays"/>
                                </TAGE>
                                <!--Third payment term is not net term, percentage not supported
                            <PRZNT>
                                <xsl:value-of select="Discount/DiscountPercent"/>
                            </PRZNT>-->
                            </E1EDK18>
                        </xsl:if>
                    </xsl:for-each>
                    </xsl:if>        
                    <xsl:if test="$v_addOnCIversion &gt;= '09'">                       
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner">
                    <xsl:if test="contains(Contact/@role,'Bank') ">
                    <E1EDK28>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <!-- IG-24244-->
                        <!-- BNAME modified as per idoc field name and missed field BCOUN added-->
                        <xsl:if test="string-length(normalize-space(IdReference[@domain = 'bankCountryCode']/@identifier)) > 0">
                        <BCOUN>
                            <xsl:value-of select="IdReference[@domain = 'bankCountryCode']/@identifier"/>
                        </BCOUN>
                        </xsl:if>
                        <!-- IG-24244-->  
                        <xsl:if test="string-length(normalize-space(IdReference[@domain = 'bankRoutingID']/@identifier)) > 0">
                        <BRNUM>
                            <xsl:value-of select="IdReference[@domain = 'bankRoutingID']/@identifier"/>
                        </BRNUM>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(IdReference[@domain = 'bankName']/@identifier)) > 0">                        
                        <!-- IG-24244-->
                        <BNAME>
                            <xsl:value-of select="IdReference[@domain = 'bankName']/@identifier"/>   
                        </BNAME>
                        <!-- IG-24244-->    
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(IdReference[@domain = 'accountID']/@identifier)) > 0">                         
                        <ACNUM>
                            <xsl:value-of select="IdReference[@domain = 'accountID']/@identifier"/>  
                        </ACNUM>  
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(IdReference[@domain = 'accountName']/@identifier)) > 0">                        
                        <ACNAM>
                            <xsl:value-of select="IdReference[@domain = 'accountName']/@identifier"/>  
                        </ACNAM>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(IdReference[@domain = 'branchName']/@identifier)) > 0">                           
                        <BALOC>
                            <xsl:value-of select="IdReference[@domain = 'branchName']/@identifier"/>   
                        </BALOC>  
                        </xsl:if>
                        <E1ARBCIG_E1EDK28>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <BATYP>
                                <xsl:value-of select="Contact/@role"/>
                            </BATYP>
                            <xsl:if test="string-length(normalize-space(IdReference[@domain = 'ibanID']/@identifier)) > 0">      <!-- IG-20314 : SP09 - Bank details mapping is missing for IBAN field -->                         
                            <BIBAN>
                                <xsl:value-of select="IdReference[@domain = 'ibanID']/@identifier"/>                             <!-- IG-20314 : SP09 - Bank details mapping is missing for IBAN field -->
                            </BIBAN>   
                            </xsl:if>
                        </E1ARBCIG_E1EDK28>
                    </E1EDK28>
                    </xsl:if>
                    </xsl:for-each>
                    </xsl:if>
                    <!--  End  Supporting Payment Terms for BSAO  -->
                    <E1EDKT1>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <TDID>
                            <xsl:value-of select="'007'"/>
                        </TDID>
                        <TSSPRAS>
                            <xsl:value-of select="'EN'"/>
                        </TSSPRAS>
                        <E1EDKT2>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <TDLINE>
                                <xsl:value-of select="'ARIBA_ASN'"/>
                            </TDLINE>
                        </E1EDKT2>
                    </E1EDKT1>
                    <!--                Start Support for BSAO-->
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments">
                        <E1EDKT1>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <!-- PD Entry -->
                            <xsl:choose>
                                <xsl:when
                                    test="string-length(normalize-space(document($v_pd)/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/HeaderTextID)) > 0">
                                    <TDID>
                                        <xsl:value-of
                                            select="upper-case(normalize-space(document($v_pd)/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/HeaderTextID))"
                                        />
                                    </TDID>
                                </xsl:when>
                                <xsl:otherwise>
                                    <TDID>
                                        <xsl:value-of select="'0001'"/>
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
                            <TDOBJECT> RBKP</TDOBJECT>
                                <xsl:call-template name="TextSplit">
                                <xsl:with-param name="p_str" select="."/>
                                <xsl:with-param name="p_strlen" select="70.0"/>
                            </xsl:call-template>
                        </E1EDKT1>
                    </xsl:for-each>
                    <!--attachment related functionality-->
                    <xsl:for-each select="Payload/cXML/Header/To/Correspondent/Extrinsic">
                        <E1EDKT1>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test='@name = "AttachmentURL"'>
                                    <TDID>
                                        <xsl:value-of select="'0'"/>
                                    </TDID>
                                </xsl:when>
                                <xsl:when test='@name = "InvoicePDF"'>
                                    <TDID>
                                        <xsl:value-of select="'1'"/>
                                    </TDID>
                                </xsl:when>
                                <xsl:when test='@name = "cXMLURL"'>
                                    <TDID>
                                        <xsl:value-of select="'0'"/>
                                    </TDID>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:call-template name="TextSplit">
                                <xsl:with-param name="p_str" select="."/>
                                <xsl:with-param name="p_strlen" select="70.0"/>
                            </xsl:call-template>
                        </E1EDKT1>
                    </xsl:for-each>
                    <!-- Material Based Inovice -->
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">
                        <E1EDP01>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <POSEX>
                                <xsl:value-of select="@invoiceLineNumber"/>
                            </POSEX>
                            <!-- IG-24463 Added Item category '9' for Adhoc Material type   -->                            
                            <xsl:if test="ServiceEntryItemReference/@serviceLineNumber">
                                <PSTYP>
                                    <xsl:value-of select="'9'"/>
                                </PSTYP>
                            </xsl:if>                             
                            <xsl:choose>
                                <xsl:when test="$v_poflag">
                                    <!-- Populate blank if not po based-->
                                    <MENGE>
                                        <!-- IG-33868 -->
                                        <xsl:choose>
                                            <xsl:when test="string-length($v_NegativeQuantity) > 0">
                                                <xsl:value-of
                                                    select="format-number(number(translate(@quantity, ',', '')), '#0.000')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                    select="format-number(number(translate(translate(@quantity, ',', ''), '-', '')), '#0.000')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </MENGE>
                                    <!--PD Entries for Unit of Measurement as of now mapped directly as it is-->
                                    <MENEE>
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput" select="UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </MENEE>
                                    <!--PD Entries for Unit of Measurement as of now mapped directly as it is-->
                                    <PMENE>
                                        <xsl:call-template name="UOMTemplate_In">
                                            <xsl:with-param name="p_UOMinput"
                                                select="PriceBasisQuantity/UnitOfMeasure"/>
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anReceiverID"/>
                                        </xsl:call-template>
                                    </PMENE>
                                    <PEINH>
                                        <xsl:value-of select="PriceBasisQuantity/@quantity"/>
                                    </PEINH>
                                    <NETWR>
                                        <xsl:variable name="v_price">
                                            <xsl:call-template name="ParseNumber">
                                                <xsl:with-param name="p_str" select="UnitPrice/Money"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_qty">
                                            <xsl:value-of select="format-number(number(translate(translate(@quantity, ',', ''), '-', '')), '#0.000')"/>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="SubtotalAmount/Money">
                                                <xsl:call-template name="ParseNumber">
                                                    <xsl:with-param name="p_str" select="SubtotalAmount/Money"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="string-length(normalize-space($v_price)) > 0 and string-length(normalize-space($v_qty)) > 0">
                                                <xsl:value-of select="format-number($v_price * $v_qty, '#0.00')"/>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </NETWR>
                                </xsl:when>
                                <xsl:otherwise>
                                    <MENGE/>
                                    <MENEE/>
                                    <PMENE/>
                                    <PEINH/>
                                    <NETWR/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <CURCY>
                                <xsl:value-of select="UnitPrice/Money/@currency"/>
                            </CURCY>
                            <PREIS>
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str"
                                        select="InvoiceDetailItemIndustry/InvoiceDetailItemRetail/AdditionalPrices/UnitGrossPrice/Money"
                                    />
                                </xsl:call-template>
                            </PREIS>
                            <BPUMN>
                                <xsl:value-of select="'1'"/>
                            </BPUMN>
                            <xsl:choose>
                                <xsl:when test="$v_poflag">
                                    <!--check for blank-->
                                    <BPUMZ>
                                        <xsl:value-of select="PriceBasisQuantity/@conversionFactor"
                                        />
                                    </BPUMZ>
                                </xsl:when>
                                <xsl:otherwise>
                                    <BPUMZ/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <ABGRT>
                                <xsl:value-of select="InvoiceDetailItemReference/Description"/>
                            </ABGRT>
                            <!--check with narashima and senthil whether to add extra field for s4hana-->
                            <xsl:if test="InvoiceDetailItemReference/ItemID/BuyerPartID">
                                <xsl:choose>
                                    <xsl:when test="$v_erpversion = 'True'">
                                        <MATNR_LONG>
                                            <xsl:value-of
                                                select="InvoiceDetailItemReference/ItemID/BuyerPartID"
                                            />
                                        </MATNR_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATNR>
                                            <xsl:value-of
                                                select="InvoiceDetailItemReference/ItemID/BuyerPartID"
                                            />
                                        </MATNR>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <!--Start Support for BSAO-->
                            <!-- Start of IG-18607 Replace test condition with PO check flag. segment E1ARBCIG_ACCOUNT_DATA should be there for NON-PO invoice -->
                            <xsl:if test="not($v_poflag)">
                            <!-- End of IG-18607 Replace test condition with PO check flag. segment E1ARBCIG_ACCOUNT_DATA should be there for NON-PO invoice -->                                
                                <!--End Support for BSAO-->
                                <xsl:for-each select="Distribution">
                                    <E1ARBCIG_ACCOUNT_DATA>
                                        <xsl:attribute name="SEGMENT">
                                            <xsl:value-of select="'1'"/>
                                        </xsl:attribute>
                                        <xsl:variable name="v_amt">
                                            <xsl:call-template name="ParseNumber">
                                                <xsl:with-param name="p_str" select="Charge/Money"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:variable name="v_disc">
                                            <xsl:choose>
                                                <xsl:when test="string-length(../InvoiceDetailDiscount/Money)>0">  <!--IG-20547:AN Invoices error "Not a Number" in the Structure E1EDP26 -->
                                                                                                                   <!-- IG-20726 : RIT - AN failure - Diff in AN invoices -->
                                                  <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str"
                                                  select="../InvoiceDetailDiscount/Money"/>
                                                  </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str" select='"0"'/>
                                                  </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <WRBTR>
                                            <!--Need to validate in testing-->
                                            <xsl:if test="string-length(normalize-space($v_amt)) > 0 and string-length(normalize-space($v_disc)) > 0">
                                            <xsl:value-of
                                                select='format-number($v_amt - $v_disc, "#0.00")'/>
                                            </xsl:if>
                                        </WRBTR>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "Asset"'>
                                                <ANLN1>
                                                  <xsl:value-of select="substring(@id, 1, 12)"/>
                                                </ANLN1>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "SubAsset"'>
                                                <ANLN2>
                                                    <xsl:value-of select="substring(@id, 1, 4)"/>
                                                </ANLN2>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "InternalOrder"'>
                                                <AUFNR>
                                                    <xsl:value-of select="substring(@id, 1, 12)"/>
                                                </AUFNR>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "CostCenter"'>
                                                <KOSTL>
                                                    <xsl:value-of select="substring(@id, 1, 10)"/>
                                                </KOSTL>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "WBSElement"'>
                                                <PS_PSP_PNR>
                                                    <xsl:value-of select="substring(@id, 1, 24)"/>
                                                </PS_PSP_PNR>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "GeneralLedger"'>
                                                <SAKNR>
                                                    <xsl:value-of select="substring(@id, 1, 10)"/>
                                                </SAKNR>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <WERKS>
                                            <xsl:value-of
                                                select="../../../InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role = 'shipTo']/@addressID"
                                            />
                                        </WERKS>
                                        <xsl:for-each select="../Extrinsic">
                                            <xsl:if test='@name = "TaxCode"'>
                                                <MWSKZ>
                                                  <xsl:value-of select="."/>
                                                </MWSKZ>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <BUKRS>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="../../../InvoiceDetailRequestHeader/Extrinsic[@name = 'CompanyCode']">
                                                  <xsl:value-of
                                                      select="substring(../../../InvoiceDetailRequestHeader/Extrinsic[@name = 'CompanyCode'], 1,4)"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                      select="substring(../../../InvoiceDetailRequestHeader/InvoicePartner/Contact[@role = 'billTo']/@addressID, 1,4)"
                                                  />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </BUKRS>
                                        <xsl:choose>
                                            <xsl:when test='contains(Charge/Money, "-")'>
                                                <SHKZG>
                                                    <xsl:value-of select="'H'"/>
                                                </SHKZG>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <SHKZG>
                                                    <xsl:value-of select="'S'"/>
                                                </SHKZG>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </E1ARBCIG_ACCOUNT_DATA>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="$v_poflag">
                                <E1EDP02>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'001'"/>
                                    </QUALF>
                                    <xsl:choose>
                                        <xsl:when
                                            test="../InvoiceDetailOrderInfo/OrderReference/@orderID">
                                            <BELNR>
                                                <xsl:value-of
                                                  select="../InvoiceDetailOrderInfo/OrderReference/@orderID"
                                                />
                                            </BELNR>
                                        </xsl:when>
                                        <!--Start Support for BSAO-->
                                        <xsl:when
                                            test="../InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID">
                                            <BELNR>
                                                <xsl:value-of
                                                  select="../InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID"
                                                />
                                            </BELNR>
                                            <!--End-->
                                        </xsl:when>
                                        <xsl:when
                                            test="../InvoiceDetailOrderInfo/OrderIDInfo/@orderID">
                                            <BELNR>
                                                <xsl:value-of
                                                  select="../InvoiceDetailOrderInfo/OrderIDInfo/@orderID"
                                                />
                                            </BELNR>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <BELNR>
                                                <xsl:value-of
                                                    select="../InvoiceDetailOrderInfo/MasterAgreementIDInfo/@agreementID"
                                                />
                                            </BELNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <ZEILE>
                                        <xsl:value-of
                                            select="InvoiceDetailItemReference/@lineNumber"/>
                                    </ZEILE>
                                </E1EDP02>
                            </xsl:if>
                            <!--Start Support for BSAO-->
                            <xsl:if test="ServiceEntryItemIDInfo or ServiceEntryItemReference">
                                <E1EDP02>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'016'"/>
                                    </QUALF>
                                    <!--AN Service Entry Sheeting Mapping-->
                                    <BELNR>
                                        <xsl:choose>
                                            <xsl:when test="ServiceEntryItemIDInfo">
                                                <xsl:value-of
                                                  select="ServiceEntryItemIDInfo/@serviceEntryID"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="ServiceEntryItemReference/@serviceEntryID"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </BELNR>
                                    <xsl:choose>
                                        <xsl:when test="ServiceEntryItemIDInfo">
                                            <xsl:variable name="v_len"
                                                select="string-length(normalize-space(ServiceEntryItemIDInfo/@serviceLineNumber))"/>
                                            <xsl:choose>
                                                <xsl:when test="$v_len > 5">
                                                  <ZEILE>
                                                  <xsl:value-of
                                                      select="substring(ServiceEntryItemIDInfo/@serviceLineNumber, $v_len - 5, $v_len)"/>
                                                  <!--Have to revisit-->
                                                  </ZEILE>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <ZEILE>
                                                  <xsl:value-of
                                                  select="ServiceEntryItemIDInfo/@serviceLineNumber"
                                                  />
                                                  </ZEILE>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:variable name="v_len"
                                                select="string-length(normalize-space(ServiceEntryItemReference/@serviceLineNumber))"/>
                                            <xsl:choose>
                                                <xsl:when test="$v_len > 5">
                                                  <ZEILE>
                                                  <xsl:value-of
                                                      select="substring(ServiceEntryItemReference/@serviceLineNumber, $v_len - 5, $v_len)"/>
                                                  <!--Have to revisit-->
                                                  </ZEILE>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <ZEILE>
                                                  <xsl:value-of
                                                  select="ServiceEntryItemReference/@serviceLineNumber"
                                                  />
                                                  </ZEILE>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </E1EDP02>
                            </xsl:if>
                            <!--                        End-->
                            <xsl:if test="../InvoiceDetailReceiptInfo/ReceiptReference/@receiptID">
                                <E1EDP02>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'016'"/>
                                    </QUALF>
                                    <BELNR>
                                        <xsl:value-of
                                            select="../InvoiceDetailReceiptInfo/ReceiptReference/@receiptID"
                                        />
                                    </BELNR>
                                    <ZEILE>
                                        <xsl:value-of
                                            select="ReceiptLineItemReference/@receiptLineNumber"/>
                                    </ZEILE>
                                    <DATUM>
                                        <!-- Convert the AN date into ERP -->
                                        <xsl:variable name="v_erpdate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                  select="../InvoiceDetailReceiptInfo/ReceiptReference/@receiptDate"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                        />
                                    </DATUM>
                                </E1EDP02>
                            </xsl:if>
                            <!--                        Start Support for BSAO-->
                            <xsl:if
                                test="../InvoiceDetailShipNoticeInfo/ShipNoticeReference/@shipNoticeID">
                                <E1EDP02>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'016'"/>
                                    </QUALF>
                                    <BELNR>
                                        <xsl:value-of
                                            select="../InvoiceDetailShipNoticeInfo/ShipNoticeReference/@shipNoticeID"
                                        />
                                    </BELNR>
                                    <ZEILE>
                                        <xsl:value-of
                                            select="ShipNoticeLineItemReference/@shipNoticeLineNumber"
                                        />
                                    </ZEILE>
                                    <DATUM>
                                        <!-- Convert the AN date into ERP -->
                                        <xsl:variable name="v_erpdate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                  select="../InvoiceDetailShipNoticeInfo/ShipNoticeReference/@shipNoticeDate"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                        />
                                    </DATUM>
                                </E1EDP02>
                            </xsl:if>
                            <!--                        End -->
                            <xsl:if
                                test="../../InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate and string-length(normalize-space(../../InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate)) > 0">
                                <!--Populate E1EDP03 only if order date exist and not blank-->
                                <E1EDP03>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <IDDAT>
                                        <xsl:value-of select="'029'"/>
                                    </IDDAT>
                                    <xsl:variable name="v_erpdate">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date"
                                                select="../../InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <DATUM>
                                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                        />
                                    </DATUM>
                                    <UZEIT>
                                        <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 12, 8), ':', '')"
                                        />
                                    </UZEIT>
                                </E1EDP03>
                            </xsl:if>
                            <!--Check for blank-->
                            <xsl:if
                                test="
                                    InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID
                                    and string-length(normalize-space(InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID)) > 0">
                                <E1EDP19>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'003'"/>
                                    </QUALF>
                                    <!--check for hana-->
                                    <xsl:choose>
                                        <xsl:when test="$v_erpversion = 'True'">
                                            <IDTNR_LONG>
                                                <xsl:value-of
                                                  select="InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID"
                                                />
                                            </IDTNR_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <IDTNR>
                                                <xsl:value-of
                                                  select="InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID"
                                                />
                                            </IDTNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <KTEXT>
                                        <xsl:value-of
                                            select="substring(InvoiceDetailItemReference/Description, 1, 70)"/>
                                    </KTEXT>
                                </E1EDP19>
                            </xsl:if>
                            <xsl:if
                                test="InvoiceDetailItemReference/SupplierBatchID and string-length(normalize-space(InvoiceDetailItemReference/SupplierBatchID)) > 0">
                                <E1EDP19>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'010'"/>
                                    </QUALF>
                                    <!--check for hana-->
                                    <xsl:choose>
                                        <xsl:when test="$v_erpversion = 'True'">
                                            <IDTNR_LONG>
                                                <xsl:value-of
                                                  select="InvoiceDetailItemReference/SupplierBatchID"
                                                />
                                            </IDTNR_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <IDTNR>
                                                <xsl:value-of
                                                  select="InvoiceDetailItemReference/SupplierBatchID"
                                                />
                                            </IDTNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </E1EDP19>
                            </xsl:if>
                            <!--                        Start Support for BSAO-->
                            <xsl:if
                                test="InvoiceDetailItemReference/ItemID/SupplierPartID and string-length(normalize-space(InvoiceDetailItemReference/ItemID/SupplierPartID)) > 0">
                                <E1EDP19>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'002'"/>
                                    </QUALF>
                                    <!--check for hana-->
                                    <xsl:choose>
                                        <xsl:when test="$v_erpversion = 'True'">
                                            <IDTNR_LONG>
                                                <xsl:value-of
                                                    select="InvoiceDetailItemReference/ItemID/SupplierPartID"
                                                />
                                            </IDTNR_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <IDTNR>
                                                <xsl:value-of
                                                    select="InvoiceDetailItemReference/ItemID/SupplierPartID"
                                                />
                                            </IDTNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </E1EDP19>
                            </xsl:if>
                            <!--                        End -->
                            <xsl:if test="$v_poflag">
                                <E1EDP26>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'003'"/>
                                    </QUALF>
                                    <xsl:variable name="v_unitprice">
                                        <xsl:call-template name="ParseNumber">
                                            <xsl:with-param name="p_str" select="UnitPrice/Money"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="v_pricebasisquantity">
                                        <xsl:value-of select="format-number(number(translate(translate(PriceBasisQuantity/@quantity, ',', ''), '-', '')), '#0.000')"/>
                                    </xsl:variable>
                                    <!--Revisit check udf for reference-->
                                    <xsl:variable name="v_price">
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(PriceBasisQuantity/@quantity)) > 0">
                                                <xsl:value-of select="$v_unitprice div $v_pricebasisquantity"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$v_unitprice"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- End of IG-30409 Update unit price -->
                                    </xsl:variable>
                                    <xsl:variable name="v_qty">
                                        <xsl:value-of select="format-number(number(translate(translate(@quantity, ',', ''), '-', '')), '#0.000')"/>
                                    </xsl:variable>                                    
                                    <xsl:variable name="v_amt">
                                        <xsl:choose>
                                            <xsl:when test="SubtotalAmount/Money">
                                                <xsl:call-template name="ParseNumber">
                                                    <xsl:with-param name="p_str" select="SubtotalAmount/Money"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="string-length(normalize-space($v_price)) > 0 and string-length(normalize-space($v_qty)) > 0">
                                                <xsl:value-of select="format-number($v_price * $v_qty, '#0.00')"/>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="v_disc">
                                        <xsl:choose>
                                            <xsl:when test="string-length(InvoiceDetailDiscount/Money)>0"> <!--IG-20547:AN Invoices error "Not a Number" in the Structure E1EDP26 -->
                                                                                                           <!-- IG-20726 : RIT - AN failure - Diff in AN invoices -->
                                                <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str"
                                                  select="InvoiceDetailDiscount/Money"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str" select='"0"'/>
                                                </xsl:call-template>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <BETRG>
                                        <xsl:if test="string-length(normalize-space($v_amt)) > 0 and string-length(normalize-space($v_disc)) > 0">
                                            <xsl:value-of
                                                select="format-number($v_amt - $v_disc, '#0.00')"/>
                                        </xsl:if>
                                    </BETRG>
                                </E1EDP26>
                            </xsl:if>
                            <!-- Line item level Shipping and handling charges-->
                            <xsl:variable name="v_line"
                                select="InvoiceDetailItemReference/@lineNumber"/>  
                            <!-- From SP07 version, Line Item Tax details are updated for Non PO Invoice-->
                                    <xsl:if
                                        test="../../InvoiceDetailRequestHeader/InvoiceDetailLineIndicator/@isTaxInLine">
                                        <xsl:for-each select="Tax/TaxDetail">
                                                <E1EDP04>
                                                    <xsl:attribute name="SEGMENT">
                                                        <xsl:value-of select="'1'"/>
                                                    </xsl:attribute>
                                                    <MWSKZ>
                                                        <xsl:call-template name="TaxTypeMap">
                                                            <xsl:with-param name="p_taxcat" select="@category"/>
                                                            <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                                            <xsl:with-param name="p_anReceiverID" select="$anReceiverID"/>
                                                            <xsl:with-param name="p_anSourceDocumentType" select="$anSourceDocumentType"/>
                                                        </xsl:call-template>                                
                                                    </MWSKZ>                             
                                                    <MSATZ>
                                                        <xsl:value-of select="@percentageRate"/>
                                                    </MSATZ>
                                                    <xsl:choose>
                                                        <xsl:when test="./TaxAmount/Money eq '0.00'">
                                                            <MWSBT>
                                                                <xsl:value-of select="./TaxAmount/Money"/>
                                                            </MWSBT>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <MWSBT>
                                                                <xsl:call-template name="ParseNumber">
                                                                    <xsl:with-param name="p_str" select="./TaxAmount/Money"/>
                                                                </xsl:call-template>
                                                            </MWSBT>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    <!-- Tax jurisdiction Have to be mapped in ERP -->
                                                    <TXJCD>
                                                        <xsl:value-of select="$v_line"/>
                                                    </TXJCD>
                                                </E1EDP04>
                                        </xsl:for-each>
                                    </xsl:if>
                            <!-- Shippment or Delivery Information-->
                            <xsl:if test="ShipNoticeLineItemReference">
                                <E1EDPT1>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <TDID>
                                        <xsl:value-of select="'004'"/>
                                    </TDID>
                                    <!-- PD Entries for languge code-->
                                    <TSSPRAS>$v_lang</TSSPRAS>
                                    <xsl:for-each select="ShipNoticeLineItemReference">
                                        <E1EDPT2>
                                            <xsl:attribute name="SEGMENT">
                                                <xsl:value-of select="'1'"/>
                                            </xsl:attribute>
                                            <TDLINE>
                                                <xsl:value-of
                                                  select="../../InvoiceDetailShipNoticeInfo/ShipNoticeReference/@shipNoticeID"
                                                />
                                            </TDLINE>
                                        </E1EDPT2>
                                    </xsl:for-each>
                                </E1EDPT1>
                            </xsl:if>
                                <E1EDPT1>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when
                                            test="string-length(normalize-space(document($v_pd)/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/LineTextID)) > 0">
                                            <TDID>
                                                <xsl:value-of
                                                    select="upper-case(normalize-space(document($v_pd)/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/LineTextID))"
                                                />
                                            </TDID>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <TDID>
                                                <xsl:value-of select="'SGTXT'"/>
                                            </TDID>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <TSSPRAS>
                                        <xsl:value-of select="substring(./@xml:lang, 1, 2)"/>
                                    </TSSPRAS>
                                    <TSSPRAS_ISO>
                                        <xsl:value-of select="substring(./@xml:lang, 1, 2)"/>
                                    </TSSPRAS_ISO>
                                    <xsl:call-template name="TextSplit">
                                        <!-- Start of IG-25701 Removal of normalize-space as it ignoring new line item texts.-->
                                        <!--<xsl:with-param name="p_str" select="normalize-space(Comments)"/>-->
                                        <xsl:with-param name="p_str" select="Comments"/>
                                        <!-- End of IG-25701 Removal of normalize-space as it ignoring new line item texts.-->
                                        <xsl:with-param name="p_strlen" select="70"/>
                                        <xsl:with-param name="p_level" select="'Item'"/>
                                    </xsl:call-template>
                                </E1EDPT1>                           
                        </E1EDP01>
                    </xsl:for-each>
                    <!-- Service Based Invoice-->
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem">
                        <E1EDP01>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <xsl:variable name="v_flag">
                                <xsl:for-each select="Extrinsic">
                                    <xsl:if
                                        test='((@name = "IsSpecialHandlingServiceItem" or @name = "IsShippingServiceItem") and . = "yes")'>
                                        <xsl:value-of select="'true'"/>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            <POSEX>
                                <xsl:value-of select="@invoiceLineNumber"/>
                            </POSEX>
                            <xsl:if test="$v_flag = ''">
                                <xsl:if test="ServiceEntryItemReference/@serviceLineNumber">
                                    <PSTYP>
                                        <xsl:value-of select="'9'"/>
                                    </PSTYP>
                                </xsl:if>
                                <!-- IG-30885:Junk value for quantity field -->
                                <xsl:variable name="v_menge">
                                    <!-- IG-31551 -->
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space(@quantity))>0">
                                            <xsl:value-of
                                                select="format-number(number(translate(translate(@quantity, ',', ''), '-', '')), '#0.000')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="0"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <!-- IG-31551 -->
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="(string-length(normalize-space($v_menge)) > 0 ) and $v_menge!= 0">
                                <!-- IG-30885:Junk value for quantity field -->  
                                <MENGE>
                                    <xsl:value-of select="$v_menge"/> <!-- IG-31551 -->
                                </MENGE>
                               <!-- IG-30885:Junk value for quantity field -->    
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MENGE/>
                                    </xsl:otherwise>
                                </xsl:choose>        
                                <!-- IG-30885:Junk value for quantity field -->         
                                <!--PD Entries for Unit of Measurement as of now mapped directly as it is-->
                                <xsl:choose>
                                    <xsl:when test="UnitRate/UnitOfMeasure">
                                        <MENEE>
                                            <xsl:call-template name="UOMTemplate_In">
                                                <xsl:with-param name="p_UOMinput"
                                                  select="UnitRate/UnitOfMeasure"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                  select="$anReceiverID"/>
                                            </xsl:call-template>
                                        </MENEE>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MENEE>
                                            <xsl:call-template name="UOMTemplate_In">
                                                <xsl:with-param name="p_UOMinput"
                                                  select="UnitOfMeasure"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                  select="$anReceiverID"/>
                                            </xsl:call-template>
                                        </MENEE>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!--PD Entries for Unit of Measurement as of now mapped directly as it is-->
                                <PMENE>
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="PriceBasisQuantity/UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </PMENE>
                                <PEINH>
                                    <xsl:value-of select="PriceBasisQuantity/@quantity"/>
                                </PEINH>
                                <NETWR>
                                    <xsl:call-template name="ParseNumber">
                                        <xsl:with-param name="p_str" select="UnitPrice/Money"
                                            > </xsl:with-param>
                                    </xsl:call-template>
                                </NETWR>
                            </xsl:if>
                            <CURCY>
                                <xsl:value-of select="UnitPrice/Money/@currency"/>
                            </CURCY>
                            <xsl:if test="$v_flag = ''">
                                <BPUMN>
                                    <xsl:value-of select="'1'"/>
                                </BPUMN>
                                <BPUMZ>
                                    <xsl:value-of select="PriceBasisQuantity/@conversionFactor"/>
                                </BPUMZ>
                                <!--Check in hana POC -->
                                <xsl:choose>
                                    <xsl:when test="$v_erpversion = 'True'">
                                        <MATNR_LONG>
                                            <xsl:value-of
                                                select="InvoiceDetailServiceItemReference/ItemID/BuyerPartID"
                                            />
                                        </MATNR_LONG>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <MATNR>
                                            <xsl:value-of
                                                select="InvoiceDetailServiceItemReference/ItemID/BuyerPartID"
                                            />
                                        </MATNR>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <!-- Account Assignment -->
                            <!--Have to validate in test for below condition-->
                            <xsl:if test="string-length(normalize-space($v_flag)) > 0">
                                <E1ARBCIG_ACCOUNT_DATA>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <xsl:for-each select="Distribution">
                                        <WRBTR>
                                            <xsl:call-template name="ParseNumber">
                                                <xsl:with-param name="p_str" select="Charge/Money"
                                                > </xsl:with-param>
                                            </xsl:call-template>
                                        </WRBTR>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "Asset"'>
                                                <ANLN1>
                                                    <xsl:value-of select="substring(@id, 1, 12)"/>
                                                </ANLN1>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "SubAsset"'>
                                                <ANLN2>
                                                    <xsl:value-of select="substring(@id, 1, 4)"/>
                                                </ANLN2>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "InternalOrder"'>
                                                <AUFNR>
                                                    <xsl:value-of select="substring(@id, 1, 12)"/>
                                                </AUFNR>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "CostCenter"'>
                                                <KOSTL>
                                                    <xsl:value-of select="substring(@id, 1, 10)"/>
                                                </KOSTL>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "WBSElement"'>
                                                <PS_PSP_PNR>
                                                    <xsl:value-of select="substring(@id, 1, 24)"/>
                                                </PS_PSP_PNR>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="Accounting/AccountingSegment">
                                            <xsl:if test='Name = "GeneralLedger"'>
                                                <SAKNR>
                                                    <xsl:value-of select="substring(@id, 1, 10)"/>
                                                </SAKNR>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                    <SGTXT>
                                        <xsl:value-of
                                            select="substring(InvoiceDetailServiceItemReference/Description, 1,50)"/>
                                    </SGTXT>
                                    <xsl:for-each
                                        select="../../InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact">
                                        <xsl:if test='@role = "shipTo"'>
                                            <WERKS>
                                                <xsl:value-of select="@addressID"/>
                                            </WERKS>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="../Extrinsic">
                                        <xsl:if test='@name = "TaxCode"'>
                                            <MWSKZ>
                                                <xsl:value-of select="."/>
                                            </MWSKZ>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each
                                        select="../../InvoiceDetailRequestHeader/InvoicePartner/Contact">
                                        <xsl:if test='@role = "billTo"'>
                                            <BUKRS>
                                                <xsl:value-of select="substring(@addressID, 1,4)"/>
                                            </BUKRS>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <SHKZG>
                                        <xsl:value-of select="'S'"/>
                                    </SHKZG>
                                </E1ARBCIG_ACCOUNT_DATA>
                            </xsl:if>
                            <!-- General and Labor Service Details -->
                            <!-- Service details populated from SP08 and above version SAP Note 2890461-->                            
                            <xsl:if test="$v_addOnCIversion &gt;= '08'">
                                <E1ARBCIG_NONPOSERV_DETAILS>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <STARTDATE>
                                        <xsl:value-of select="translate(substring(Period/@startDate, 1, 10), '-', '')"/>
                                    </STARTDATE>
                                    <ENDDATE>
                                        <xsl:value-of select="translate(substring(Period/@endDate, 1, 10), '-', '')"/>
                                    </ENDDATE>
                                    <RATE_CURR>
                                        <xsl:value-of select="substring(UnitRate/Money/@currency, 1, 5)"/>                                    
                                    </RATE_CURR>
                                    <RATE>
                                    <!--IG-36116-->
                                     <xsl:call-template name="ParseNumber">
                                            <xsl:with-param name="p_str" select="UnitRate/Money"/>
                                     </xsl:call-template>                                       
                                    </RATE>
                                    <UOM>
                                        <xsl:value-of select="substring(UnitRate/UnitOfMeasure, 1, 3)"/> 
                                    </UOM>
                                    <TERM>
                                        <xsl:value-of select="substring(UnitRate/TermReference/@term, 1, 3)"/> 
                                    </TERM>
                                    <TERMNAME>
                                        <xsl:value-of select="substring(UnitRate/TermReference/@termName, 1, 28)"/>
                                    </TERMNAME>
                                    <TIMESHEETNUMBER>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/InvoiceTimeCardDetail/TimeCardIDInfo/@timeCardID, 1, 30)"/>
                                    </TIMESHEETNUMBER>
                                    <SPRAS>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/Contractor/Contact/Name/@xml:lang, 1, 1)"/>
                                    </SPRAS>
                                    <CONTRACTORNAME>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/Contractor/Contact/Name, 1, 40)"/>
                                    </CONTRACTORNAME>
                                    <xsl:choose>
                                        <xsl:when test="InvoiceLaborDetail/Contractor/ContractorIdentifier/@domain = 'supplierReferenceID'">
                                            <SUPPREF_ID>
                                                <xsl:value-of select="substring(InvoiceLaborDetail/Contractor/ContractorIdentifier, 1, 40)"/>
                                            </SUPPREF_ID>
                                        </xsl:when>
                                        <xsl:when test="InvoiceLaborDetail/Contractor/ContractorIdentifier/@domain = 'buyerReferenceID'">
                                            <BUYREF_ID>
                                                <xsl:value-of select="substring(InvoiceLaborDetail/Contractor/ContractorIdentifier, 1, 40)"/>
                                            </BUYREF_ID>
                                        </xsl:when>                                    
                                    </xsl:choose>                                
                                    <JOBDESC>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/JobDescription/Description, 1, 40)"/>
                                    </JOBDESC>
                                    <SUPERVISOR>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/Supervisor/Contact/Name, 1, 40)"/>
                                    </SUPERVISOR>
                                    <STREET1>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Street[1], 1, 60)"/>
                                    </STREET1>
                                    <STREET2>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Street[2], 1, 60)"/>
                                    </STREET2>
                                    <STREET3>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Street[3], 1, 60)"/>
                                    </STREET3>                                
                                    <CITY>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/City, 1, 40)"/>
                                    </CITY>
                                    <REGION>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/State/@isoStateCode, 1, 3)"/>
                                    </REGION>
                                    <REGION_DESCRIPTION>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/State, 1, 30)"/>
                                    </REGION_DESCRIPTION>                                
                                    <POST_CODE>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/PostalCode, 1, 80)"/>
                                    </POST_CODE>
                                    <COUNTRYCODE>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Country/@isoCountryCode, 1, 3)"/>
                                    </COUNTRYCODE>
                                    <COUNTRY>
                                        <xsl:value-of select="substring(InvoiceLaborDetail/WorkLocation/Address/PostalAddress/Country, 1, 40)"/>
                                    </COUNTRY>                                                               
                                </E1ARBCIG_NONPOSERV_DETAILS>
                            </xsl:if>                            
                            <xsl:if test="$v_flag = ''">
                                <E1EDP02>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'001'"/>
                                    </QUALF>
                                    <!-- Defect fix IG-5467 start of change  -->
                                    <xsl:choose>
                                        <xsl:when
                                            test="../InvoiceDetailOrderInfo/OrderReference/@orderID">
                                            <BELNR>
                                                <xsl:value-of
                                                  select="../InvoiceDetailOrderInfo/OrderReference/@orderID"
                                                />
                                            </BELNR>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <BELNR>
                                                <xsl:value-of
                                                    select="../InvoiceDetailOrderInfo/MasterAgreementReference/@agreementID"
                                                />
                                            </BELNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <!-- Defect fix IG-5467 end of change  -->                                    
                                    <xsl:choose>
                                        <xsl:when
                                            test="string-length(normalize-space(InvoiceDetailServiceItemReference/@lineNumber)) le 5">
                                            <ZEILE>
                                                <xsl:value-of
                                                    select="InvoiceDetailServiceItemReference/@lineNumber"
                                                />
                                            </ZEILE>
                                        </xsl:when>                                         
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="ServiceEntryItemIDInfo or ServiceEntryItemReference">
                                                    <ZEILE>
                                                        <xsl:value-of
                                                            select="substring(InvoiceDetailServiceItemReference/@lineNumber, 1, string-length(normalize-space(InvoiceDetailServiceItemReference/@lineNumber)) - 5)"
                                                        />
                                                    </ZEILE>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <ZEILE>
                                                        <xsl:value-of select="Extrinsic[@name = 'parentPOLineNumber']"/>
                                                    </ZEILE>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </E1EDP02>
                                <xsl:if test="ServiceEntryItemIDInfo or ServiceEntryItemReference">
                                    <E1EDP02>
                                        <xsl:attribute name="SEGMENT">
                                            <xsl:value-of select="'1'"/>
                                        </xsl:attribute>
                                        <QUALF>
                                            <xsl:value-of select="'016'"/>
                                        </QUALF>
                                        <!--AN Service Entry Sheeting Mapping-->
                                        <BELNR>
                                            <xsl:choose>
                                                <xsl:when test="ServiceEntryItemIDInfo">
                                                  <xsl:value-of
                                                  select="ServiceEntryItemIDInfo/@serviceEntryID"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="ServiceEntryItemReference/@serviceEntryID"
                                                  />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </BELNR>
                                        <xsl:choose>
                                            <xsl:when test="ServiceEntryItemIDInfo">
                                                <xsl:variable name="v_len"
                                                    select="string-length(normalize-space(ServiceEntryItemIDInfo/@serviceLineNumber))"/>
                                                <xsl:choose>
                                                  <xsl:when test="$v_len > 5">
                                                  <ZEILE>
                                                  <xsl:value-of
                                                      select="substring(ServiceEntryItemIDInfo/@serviceLineNumber, $v_len - 5, $v_len)"
                                                  />
                                                  </ZEILE>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <ZEILE>
                                                  <xsl:value-of
                                                  select="ServiceEntryItemIDInfo/@serviceLineNumber"
                                                  />
                                                  </ZEILE>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:variable name="v_len"
                                                    select="string-length(normalize-space(ServiceEntryItemReference/@serviceLineNumber))"/>
                                                <xsl:choose>
                                                  <xsl:when test="$v_len > 5">
                                                  <ZEILE>
                                                  <xsl:value-of
                                                      select="substring(ServiceEntryItemReference/@serviceLineNumber, $v_len - 5, $v_len)"
                                                  />
                                                  </ZEILE>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <ZEILE>
                                                  <xsl:value-of
                                                  select="ServiceEntryItemReference/@serviceLineNumber"
                                                  />
                                                  </ZEILE>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </E1EDP02>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if
                                test="../../InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate and string-length(normalize-space(../../InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate)) > 0">
                                <E1EDP03>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <IDDAT>
                                        <xsl:value-of select="'029'"/>
                                    </IDDAT>
                                    <!-- Convert the AN date into ERP -->
                                    <xsl:variable name="v_erpdate">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date"
                                                select="../../InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <DATUM>
                                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                        />
                                    </DATUM>
                                    <UZEIT>
                                        <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 12, 8), ':', '')"
                                        />
                                    </UZEIT>
                                </E1EDP03>
                            </xsl:if>
                            <xsl:if test="$v_flag = ''">
                                <E1EDP26>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'003'"/>
                                    </QUALF>
                                    <xsl:variable name="v_amt">
                                        <xsl:choose>
                                            <xsl:when test="SubtotalAmount/Money">
                                                <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str"
                                                  select="SubtotalAmount/Money"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str" select='"0"'/>
                                                </xsl:call-template>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="v_disc">
                                        <xsl:choose>
                                            <xsl:when test="string-length(InvoiceDetailDiscount/Money)>0">        <!--IG-20547:AN Invoices error "Not a Number" in the Structure E1EDP26 -->
                                                                                                                  <!-- IG-20726 : RIT - AN failure - Diff in AN invoices -->
                                                <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str"
                                                  select="InvoiceDetailDiscount/Money"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str" select='"0"'/>
                                                </xsl:call-template>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when
                                            test="string-length(normalize-space($v_amt)) > 0 and string-length(normalize-space($v_disc)) > 0">
                                            <BETRG>
                                                <xsl:value-of
                                                  select="format-number(number($v_amt) - number($v_disc), '#0.00')"
                                                />
                                            </BETRG>
                                        </xsl:when>
                                        <xsl:when test="string-length(normalize-space($v_amt)) > 0">
                                            <BETRG>
                                                <xsl:value-of
                                                  select="format-number(number($v_amt), '#0.00')"/>
                                            </BETRG>
                                        </xsl:when>
                                    </xsl:choose>
                                </E1EDP26>
                            </xsl:if>
                            <!-- Line item level Shipping and handling charges-->
                            <xsl:for-each select="Tax/TaxDetail">
                                    <E1EDP04>
                                        <xsl:attribute name="SEGMENT">
                                            <xsl:value-of select="'1'"/>
                                        </xsl:attribute>
                                        <!--check for 'I0' in erp then clear the segment sdata if yes-->
                                        <MWSKZ>
                                            <xsl:call-template name="TaxTypeMap">
                                                <xsl:with-param name="p_taxcat" select="@category"/>
                                                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                                <xsl:with-param name="p_anReceiverID" select="$anReceiverID"/>
                                                <xsl:with-param name="p_anSourceDocumentType" select="$anSourceDocumentType"/>
                                            </xsl:call-template>                                
                                        </MWSKZ>  
                                        <xsl:choose>
                                            <xsl:when test="@percentageRate">
                                                <MSATZ>
                                                  <xsl:value-of select="@percentageRate"/>
                                                </MSATZ>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <MSATZ/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test="./TaxAmount/Money eq '0.00'">
                                                <MWSBT>
                                                    <xsl:value-of select="./TaxAmount/Money"/>
                                                </MWSBT>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <MWSBT>
                                                  <xsl:call-template name="ParseNumber">
                                                      <xsl:with-param name="p_str" select="./TaxAmount/Money"/>
                                                  </xsl:call-template>
                                                </MWSBT>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </E1EDP04>
                            </xsl:for-each>
                            <!-- IG-24495 below mapping is removed under Materil section and added for Service Items Comments as part of BSAO  -->
                            <E1EDPT1>
                                <xsl:attribute name="SEGMENT">
                                    <xsl:value-of select="'1'"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when
                                        test="string-length(upper-case(document($v_pd)/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/LineTextID)) > 0">
                                        <TDID>
                                            <xsl:value-of
                                                select="upper-case(document($v_pd)/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/LineTextID)"
                                            />
                                        </TDID>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <TDID>
                                            <xsl:value-of select="'SGTXT'"/>
                                        </TDID>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <TSSPRAS>
                                    <xsl:value-of select="substring(./@xml:lang, 1, 2)"/>
                                </TSSPRAS>
                                <TSSPRAS_ISO>
                                    <xsl:value-of select="substring(./@xml:lang, 1, 2)"/>
                                </TSSPRAS_ISO>
                                <xsl:call-template name="TextSplit">
                                    <!-- Start of IG-25701 Removal of normalize-space as it ignoring new line in line item texts.-->
                                    <!--<xsl:with-param name="p_str" select="normalize-space(Comments)"/>-->
                                    <xsl:with-param name="p_str" select="Comments"/>
                                    <!-- End of IG-25701 Removal of normalize-space as it ignoring new line in line item texts.-->   
                                    <xsl:with-param name="p_strlen" select="70"/>
                                    <xsl:with-param name="p_level" select="'Item'"/>
                                    <!--                                <xsl:with-param name="p_seg" select="'E1EDPT2'"/>-->
                                </xsl:call-template>
                            </E1EDPT1>                             
                        </E1EDP01>
                    </xsl:for-each>
                    <!-- Credit Memo Header Level-->
                    <xsl:if
                        test='Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose = "creditMemo"'>
                        <E1EDP01>
                            <xsl:attribute name="SEGMENT">
                                <xsl:value-of select="'1'"/>
                            </xsl:attribute>
                            <POSEX>
                                <xsl:value-of select="'1'"/>
                            </POSEX>
                            <CURCY>
                                <xsl:value-of
                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money/@currency"
                                />
                            </CURCY>
                            <PRIES>
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str"
                                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemIndustry/InvoiceDetailItemRetail/AdditionalPrices/UnitGrossPrice/Money"
                                    />
                                </xsl:call-template>
                            </PRIES>
                            <!-- Should be compatibility s4-hana check senthil and narashima(POC check)-->
                            <xsl:choose>
                                <xsl:when test="$v_erpversion = 'True'">
                                    <MATNR_LONG>
                                        <xsl:value-of
                                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/ItemID/BuyerPartID"
                                        />
                                    </MATNR_LONG>
                                </xsl:when>
                                <xsl:otherwise>
                                    <MATNR>
                                        <xsl:value-of
                                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/ItemID/BuyerPartID"
                                        />
                                    </MATNR>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- Account Assignment -->
                            <xsl:for-each
                                select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailHeaderOrder/InvoiceDetailOrderSummary/Extrinsic">
                                <xsl:if test='@name = "distribution"'>
                                    <xsl:for-each select="Distribution">
                                        <E1ARBCIG_ACCOUNT_DATA>
                                            <xsl:attribute name="SEGMENT">
                                                <xsl:value-of select="'1'"/>
                                            </xsl:attribute>
                                            <WRBTR>
                                                <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str"
                                                  select="/Combined/Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money"
                                                  />
                                                </xsl:call-template>
                                            </WRBTR>
                                            <xsl:for-each select="Accounting/AccountingSegment">
                                                <xsl:if test='Name = "Asset"'>
                                                    <ANLN1>
                                                        <xsl:value-of select="substring(@id, 1, 12)"/>
                                                    </ANLN1>
                                                </xsl:if>
                                            </xsl:for-each>
                                            <xsl:for-each select="Accounting/AccountingSegment">
                                                <xsl:if test='Name = "SubAsset"'>
                                                    <ANLN2>
                                                        <xsl:value-of select="substring(@id, 1, 4)"/>
                                                    </ANLN2>
                                                </xsl:if>
                                            </xsl:for-each>
                                            <xsl:for-each select="Accounting/AccountingSegment">
                                                <xsl:if test='Name = "InternalOrder"'>
                                                    <AUFNR>
                                                        <xsl:value-of select="substring(@id, 1, 12)"/>
                                                    </AUFNR>
                                                </xsl:if>
                                            </xsl:for-each>
                                            <xsl:for-each select="Accounting/AccountingSegment">
                                                <xsl:if test='Name = "CostCenter"'>
                                                    <KOSTL>
                                                        <xsl:value-of select="substring(@id, 1, 10)"/>
                                                    </KOSTL>
                                                </xsl:if>
                                            </xsl:for-each>
                                            <xsl:for-each select="Accounting/AccountingSegment">
                                                <xsl:if test='Name = "WBSElement"'>
                                                    <PS_PSP_PNR>
                                                        <xsl:value-of select="substring(@id, 1, 24)"/>
                                                    </PS_PSP_PNR>
                                                </xsl:if>
                                            </xsl:for-each>
                                            <xsl:for-each select="Accounting/AccountingSegment">
                                                <xsl:if test='Name = "GeneralLedger"'>
                                                    <SAKNR>
                                                        <xsl:value-of select="substring(@id, 1, 10)"/>
                                                    </SAKNR>
                                                </xsl:if>
                                            </xsl:for-each>
                                            <xsl:variable name="v_ccode">
                                                <xsl:for-each
                                                  select="/Combined/Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner/Contact">
                                                  <xsl:choose>
                                                  <xsl:when test='@role = "billTo"'>
                                                  <xsl:value-of select="@addressID"/>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                </xsl:for-each>
                                            </xsl:variable>
                                            <BUKRS>
                                                <xsl:value-of select="substring($v_ccode,1,4)"/>
                                            </BUKRS>
                                            <SHKZG>
                                                <xsl:value-of select="'H'"/>
                                            </SHKZG>
                                        </E1ARBCIG_ACCOUNT_DATA>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:if
                                test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate and string-length(normalize-space(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate)) > 0">
                                <E1EDP03>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <IDDAT>
                                        <xsl:value-of select="'029'"/>
                                    </IDDAT>
                                    <xsl:variable name="v_erpdate">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date"
                                                select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderDate"/>
                                            <xsl:with-param name="p_timezone"
                                                select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <!--Mapped time zone pd entry and translate accordingly-->
                                    <DATUM>
                                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                        />
                                    </DATUM>
                                    <UZEIT>
                                        <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 12, 8), ':', '')"
                                        />
                                    </UZEIT>
                                </E1EDP03>
                            </xsl:if>
                            <!-- check for not blank-->
                            <xsl:if
                                test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID">
                                <E1EDP19>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'003'"/>
                                    </QUALF>
                                    <!--check with senthil and Narashima-->
                                    <xsl:choose>
                                        <xsl:when test="$v_erpversion = 'True'">
                                            <IDTNR_LONG>
                                                <xsl:value-of
                                                  select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/SupplierBatchID"
                                                />
                                            </IDTNR_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <IDTNR>
                                                <xsl:value-of
                                                  select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/InvoiceDetailItemReferenceIndustry/InvoiceDetailItemReferenceRetail/EANID"
                                                />
                                            </IDTNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </E1EDP19>
                            </xsl:if>
                            <xsl:if
                                test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/SupplierBatchID and string-length(normalize-space(Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/SupplierBatchID)) > 0">
                                <E1EDP19>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'010'"/>
                                    </QUALF>
                                    <!--check with senthil and Narashima-->
                                    <xsl:choose>
                                        <xsl:when test="$v_erpversion = 'True'">
                                            <IDTNR_LONG>
                                                <xsl:value-of
                                                  select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/SupplierBatchID"
                                                />
                                            </IDTNR_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <IDTNR>
                                                <xsl:value-of
                                                  select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/SupplierBatchID"
                                                />
                                            </IDTNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </E1EDP19>
                            </xsl:if>
                            <!--                        Start Support for BSAO-->
                            <xsl:if
                                test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/ItemID/SupplierPartID">
                                <E1EDP19>
                                    <xsl:attribute name="SEGMENT">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <QUALF>
                                        <xsl:value-of select="'002'"/>
                                    </QUALF>
                                    <!--check for hana-->
                                    <xsl:choose>
                                        <xsl:when test="$v_erpversion = 'True'">
                                            <IDTNR_LONG>
                                                <xsl:value-of
                                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/ItemID/SupplierPartID"
                                                />
                                            </IDTNR_LONG>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <IDTNR>
                                                <xsl:value-of
                                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/InvoiceDetailItemReference/ItemID/SupplierPartID"
                                                />
                                            </IDTNR>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </E1EDP19>
                            </xsl:if>
                            <!--                        End -->
                            <!-- Line item level Shipping and handling charges-->
                            <xsl:variable name="v_amt">
                                <xsl:call-template name="ParseNumber">
                                    <xsl:with-param name="p_str"
                                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money"
                                    />
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="number($v_amt) > 0">
                                <E1EDP04>
                                        <xsl:attribute name="SEGMENT">
                                            <xsl:value-of select="'1'"/>
                                        </xsl:attribute>
                                        <xsl:for-each
                                            select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail">
                                            <MWSKZ>
                                                <xsl:call-template name="TaxTypeMap">
                                                    <xsl:with-param name="p_taxcat" select="@category"/>
                                                    <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                                                    <xsl:with-param name="p_anReceiverID" select="$anReceiverID"/>
                                                    <xsl:with-param name="p_anSourceDocumentType" select="$anSourceDocumentType"/>
                                                </xsl:call-template>                                
                                            </MWSKZ>  
                                        </xsl:for-each>
                                        <xsl:choose>
                                            <xsl:when
                                                test="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/TaxAmount/Money eq '0.00'">
                                                <MWSBT>
                                                  <xsl:value-of
                                                      select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/TaxAmount/Money"
                                                  />
                                                </MWSBT>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <MWSBT>
                                                  <xsl:call-template name="ParseNumber">
                                                  <xsl:with-param name="p_str"
                                                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/TaxAmount/Money"
                                                  />
                                                  </xsl:call-template>
                                                </MWSBT>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </E1EDP04>
                            </xsl:if>
                        </E1EDP01>
                    </xsl:if>
                    <!--Invoicing Summary Amount-->
                    <xsl:for-each
                        select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary">
                        <!--Invoice Detail Discount-->
                        <xsl:if test="InvoiceDetailDiscount">
                            <E1EDS01 SEGMENT="1">
                                <SUMID>
                                    <xsl:value-of select="'003'"/>
                                </SUMID>
                                <SUMME>
                                    <xsl:call-template name="ParseNumber">
                                        <xsl:with-param name="p_str"
                                            select="InvoiceDetailDiscount/Money"/>
                                    </xsl:call-template>
                                </SUMME>
                                <WAERQ>
                                    <xsl:value-of select="InvoiceDetailDiscount/Money/@currency"/>
                                </WAERQ>
                            </E1EDS01>
                        </xsl:if>
                        <!-- Invoice Totol Net Amount-->
                        <xsl:if test="NetAmount">
                            <E1EDS01 SEGMENT="1">
                                <SUMID>
                                    <xsl:value-of select="'010'"/>
                                </SUMID>
                                <SUMME>
                                    <xsl:call-template name="ParseNumber">
                                        <xsl:with-param name="p_str" select="NetAmount/Money"/>
                                    </xsl:call-template>
                                </SUMME>
                                <WAERQ>
                                    <xsl:value-of select="NetAmount/Money/@currency"/>
                                </WAERQ>
                            </E1EDS01>
                        </xsl:if>
                        <!-- Delivery/Shipping Handling Cost-->
                        <xsl:variable name="v_counter">
                            <xsl:for-each
                                select="../InvoiceDetailOrder/InvoiceDetailServiceItem/Extrinsic">
                                <xsl:if
                                    test="@name = 'IsSpecialHandlingServiceItem' or @name = 'IsShippingServiceItem'">
                                    <xsl:value-of select='"true"'/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:if
                            test="
                                (((SpecialHandlingAmount or ShippingAmount) and ((not(../InvoiceDetailOrder/InvoiceDetailServiceItem)) or
                                (../InvoiceDetailOrder/InvoiceDetailServiceItem and $v_counter = '') or (string-length(normalize-space($v_counter)) > 0 and (SpecialHandlingAmount or ShippingAmount))))
                                or (TotalAllowances and TotalAllowances/Money ne ''))">
                            <E1EDS01 SEGMENT="1">
                                <xsl:choose>
                                    <xsl:when
                                        test="((TotalAllowances and TotalAllowances/Money ne '') or $v_counter = '')">
                                        <SUMID>020</SUMID>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <SUMID/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="TotalAllowances and TotalAllowances/Money ne ''">
                                        <SUMME>
                                            <xsl:call-template name="ParseNumber">
                                                <xsl:with-param name="p_str"
                                                  select="TotalAllowances/Money"/>
                                            </xsl:call-template>
                                        </SUMME>
                                        <WAERQ>
                                            <xsl:value-of select="TotalAllowances/Money/@currency"/>
                                        </WAERQ>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="$v_counter = ''">
                                                <xsl:variable name="v_handlingcharges">
                                                    <xsl:variable name="v_handling">
                                                        <xsl:call-template name="ParseNumber">
                                                            <xsl:with-param name="p_str"
                                                                select="SpecialHandlingAmount/Money"/>
                                                        </xsl:call-template>
                                                    </xsl:variable> 
                                                    <!-- IG-20509 removed the redundancy code and improvised the code -->
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space($v_handling)) > 0">
                                                            <xsl:value-of select="$v_handling"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>0</xsl:otherwise>
                                                    </xsl:choose>                                                     
                                                </xsl:variable>
                                                <xsl:variable name="v_shippingcharge">
                                                    <xsl:variable name="v_shipping">
                                                        <xsl:call-template name="ParseNumber">
                                                            <xsl:with-param name="p_str"
                                                                select="ShippingAmount/Money"/>
                                                        </xsl:call-template>
                                                    </xsl:variable>
                                                    <!-- IG-20509 removed the redundancy code and improvised the code -->
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(normalize-space($v_shipping)) > 0">
                                                            <xsl:value-of select="$v_shipping"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>0</xsl:otherwise>
                                                    </xsl:choose>    
                                                </xsl:variable>
                                                <xsl:variable name="v_sum"
                                                    select="$v_handlingcharges + $v_shippingcharge"/>
                                                <SUMME>
                                                    <xsl:value-of
                                                        select="format-number($v_sum, '#0.00')"/>
                                                </SUMME>                                                
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="($v_handlingcharges != '' and $v_shippingcharge != '') or ($v_handlingcharges = '')">
                                                        <WAERQ>
                                                            <xsl:value-of
                                                                select="ShippingAmount/Money/@currency"/>
                                                        </WAERQ>
                                                    </xsl:when>                                                  
                                                    <xsl:otherwise>
                                                        <WAERQ>
                                                            <xsl:value-of
                                                                select="SpecialHandlingAmount/Money/@currency"/>
                                                        </WAERQ>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>                                             
                                            <xsl:otherwise>
                                                <SUMME/>
                                                <WAERQ/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </E1EDS01>
                        </xsl:if>
                        <xsl:if test="(((not(SpecialHandlingAmount) and not(ShippingAmount)) and (Tax/TaxDetail[@purpose ='specialHandlingTax'] or Tax/TaxDetail[@purpose ='shippingTax']) and ((not(../InvoiceDetailOrder/InvoiceDetailServiceItem)) or
                            (../InvoiceDetailOrder/InvoiceDetailServiceItem and $v_counter = '') or (string-length(normalize-space($v_counter)) > 0 and (not(SpecialHandlingAmount) or not(ShippingAmount)))))
                                or (TotalAllowances and TotalAllowances/Money ne ''))">
                            <E1EDS01 SEGMENT="1">
                                <xsl:choose>
                                    <xsl:when
                                        test="(TotalAllowances and TotalAllowances/Money ne '') ">
                                        <SUMID>
                                            <xsl:value-of select="'020'"/>
                                        </SUMID>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <SUMID></SUMID>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="$v_counter = ''">
                                        <xsl:variable name="v_handlingcharges">
                                            <xsl:variable name="v_handling">
                                                <xsl:call-template name="ParseNumber">
                                                    <xsl:with-param name="p_str"
                                                        select="Tax/TaxDetail[@purpose ='specialHandlingTax']/TaxableAmount/Money"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <!-- IG-20509 removed the redundancy code and improvised the code -->
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_handling)) > 0">
                                                    <xsl:value-of select="$v_handling"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="v_shippingcharge">
                                            <xsl:variable name="v_shipping">
                                                <xsl:call-template name="ParseNumber">
                                                    <xsl:with-param name="p_str"
                                                        select="Tax/TaxDetail[@purpose ='shippingTax']/TaxableAmount/Money"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <!-- IG-20509 removed the redundancy code and improvised the code -->
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space($v_shipping)) > 0">
                                                    <xsl:value-of select="$v_shipping"/>
                                                </xsl:when>
                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose> 
                                        </xsl:variable>
                                        <!-- IG-20509 removed the redundancy code and improvised the code -->                                    
                                        <xsl:variable name="v_sum"
                                            select="$v_handlingcharges + $v_shippingcharge"/>                                    
                                        <SUMME>
                                            <xsl:value-of
                                                select="format-number($v_sum, '#0.00')"/>
                                        </SUMME>                                     
                                        <xsl:choose>                                      
                                            <xsl:when
                                                test="($v_handlingcharges != '' and $v_shippingcharge != '') or ($v_handlingcharges = '')">
                                                <WAERQ>
                                                    <xsl:value-of
                                                        select="Tax/TaxDetail[@purpose ='shippingTax']/TaxableAmount/Money/@currency"/>
                                                </WAERQ> 
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <WAERQ>
                                                    <xsl:value-of
                                                        select="Tax/TaxDetail[@purpose ='specialHandlingTax']/TaxableAmount/Money/@currency"/>
                                                </WAERQ>
                                            </xsl:otherwise>
                                        </xsl:choose>                                    
                                    </xsl:when>                                      
                                </xsl:choose>
                            </E1EDS01>
                            </xsl:if>
                    </xsl:for-each>
                </IDOC>
            </ARBCIG_INVOIC>
    </xsl:template>
    <!--  User Defined Templates for text Split-->
    <xsl:template name="TextSplit">
        <xsl:param name="p_str"/>
        <xsl:param name="p_strlen"/>
        <xsl:param name="p_level"/>
        <xsl:variable name="v_str1" select="substring($p_str, 1, $p_strlen)"/>
        <xsl:variable name="v_str2" select="substring($p_str, $p_strlen + 1)"/>
        <xsl:if test="$v_str1">
            <xsl:choose>
                <xsl:when test="$p_level='Item'">
                    <E1EDPT2>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <TDLINE>
                            <xsl:value-of select="$v_str1"/>
                        </TDLINE>
                    </E1EDPT2>             
                </xsl:when>
                <xsl:otherwise>
                    <E1EDKT2>
                        <xsl:attribute name="SEGMENT">
                            <xsl:value-of select="'1'"/>
                        </xsl:attribute>
                        <TDLINE>
                            <xsl:value-of select="$v_str1"/>
                        </TDLINE>
                    </E1EDKT2>
                </xsl:otherwise>
            </xsl:choose>           
        </xsl:if>
        <xsl:if test="$v_str2">
            <xsl:call-template name="TextSplit">
                <xsl:with-param name="p_str" select="$v_str2"/>
                <xsl:with-param name="p_strlen" select="$p_strlen"/>
                <xsl:with-param name="p_level"  select="$p_level"/>                
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--User Define Templates for ParseNumber-->
    <xsl:template name="ParseNumber">
        <!--IG-20547:AN Invoices error "Not a Number" in the Structure E1EDP26 --> 
        <!-- IG-20726 : RIT - AN failure - Diff in AN invoices -->
        <xsl:param name="p_str"/>           
            <xsl:if test="string-length(normalize-space($p_str))>0">
                <xsl:value-of
                    select="format-number(number(translate(translate(translate(translate($p_str, ',', ''), 'USD', ''), '$', ''), '-', '')), '#0.00')"
                />
            </xsl:if>
        <!--IG-20547:AN Invoices error "Not a Number" in the Structure E1EDP26 -->
        <!-- IG-20726 : RIT - AN failure - Diff in AN invoices -->
    </xsl:template>
</xsl:stylesheet>
