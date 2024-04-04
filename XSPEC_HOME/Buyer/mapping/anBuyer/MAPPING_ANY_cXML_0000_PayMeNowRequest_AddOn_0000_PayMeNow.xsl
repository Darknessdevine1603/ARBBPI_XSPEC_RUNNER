<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anAddOnCIVersion"/>
<!--    <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="Combined">
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
        <!--Get the Language code-->
        <xsl:variable name="v_lang">
            <xsl:choose>
                <xsl:when
                    test="Payload/cXML/Request/PaymentProposalRequest/Comments/@xml:lang != ''">
                    <xsl:value-of
                        select="Payload/cXML/Request/PaymentProposalRequest/Comments/@xml:lang"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="FillDefaultLang">
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
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
        <xsl:variable name="pm" select="Payload/cXML/Request/PaymentProposalRequest"/>
        <xsl:variable name="ppl" select="string-length($pm/@paymentProposalID)"/> 
        <!--    Check CIG Addon Version-->
        <xsl:variable name="v_addOnCIversion">
            <xsl:value-of select="substring($anAddOnCIVersion, 9, 10)"/>
        </xsl:variable>
        <xsl:if test="$pm/@paymentProposalID">
            <!-- Main template -->
            <ARBCIG_FIDCCH>
                <IDOC BEGIN="1">
                    <EDI_DC40 SEGMENT="1">
                        <IDOCTYP>
                            <xsl:value-of select="'ARBCIG_FIDCCH'"/>
                        </IDOCTYP>
                        <MESTYP>
                            <xsl:value-of select="'FIDCCH'"/>
                        </MESTYP>
                        <SNDPOR>
                            <xsl:value-of select="$v_port"/>
                        </SNDPOR>
                        <xsl:choose>
                            <xsl:when test="$v_LsEnabled != ''">
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
                                        select="Header/To/Credential[@domain = 'VendorID']/Identity"
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
                                        select="Header/To/Credential[@domain = 'VendorID']/Identity"
                                    />
                                </RCVPRN>
                            </xsl:otherwise>
                        </xsl:choose>
                        <RCVPOR>
                            <xsl:value-of select="$v_port"/>
                        </RCVPOR>
                    </EDI_DC40>
                    <E1FIREF SEGMENT="1">
                        <AWSYS>
                            <xsl:value-of select="$v_sysid"/>
                        </AWSYS>
                        <!--To Accomodate Business Suite Addon Payment proposal IDs                        -->
                        <xsl:choose>
                            <xsl:when test="$ppl > 21">
                                <BUKRS>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 18, 4)"/>
                                </BUKRS>
                                <BELNR>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 1, 10)"/>
                                </BELNR>
                                <OBZEI>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 15, 3)"/>
                                </OBZEI>
                                <BUKRS_SND>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 18, 4)"/>
                                </BUKRS_SND>
                                <GJAHR>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 11, 4)"/>
                                </GJAHR>
                            </xsl:when>
                            <xsl:otherwise>
                                <BUKRS>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 1, 4)"/>
                                </BUKRS>
                                <BELNR>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 4, 10)"/>
                                </BELNR>
                                <OBZEI>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 18, 3)"/>
                                </OBZEI>
                                <BUKRS_SND>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 1, 4)"/>
                                </BUKRS_SND>
                                <GJAHR>
                                    <xsl:value-of select="substring($pm/@paymentProposalID, 15, 4)"/>
                                </GJAHR> 
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$pm/Comments/text()">
                            <E1ARBCIG_COMMENT SEGMENT="1">
                                <!--Call Template to fill Comments-->
                                <xsl:call-template name="CommentsFillIdocIn">
                                    <xsl:with-param name="p_comments" select="$pm/Comments"/>
                                    <xsl:with-param name="p_lang" select="$v_lang"/>
                                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                                    <xsl:with-param name="p_pd" select="$v_pd"/>
                                </xsl:call-template>
                            </E1ARBCIG_COMMENT>
                        </xsl:if>
                        <xsl:if test="AttachmentList">
                            <!--Call Template to fill Attachments-->
                            <xsl:call-template name="InboundAttachIDOC"/>
                        </xsl:if>
                        <E1ARBCIG_ADDITIONAL_DATA SEGMENT="1">
                            <ANPAYLOAD_ID>
                                <xsl:value-of select="Payload/cXML/@payloadID"/>
                            </ANPAYLOAD_ID>
                            <ARIBANETWORKID>
                                <xsl:value-of select="$anReceiverID"/>
                            </ARIBANETWORKID>
                            <ERPSYSTEMID>
                                <xsl:value-of select="$v_sysid"/>
                            </ERPSYSTEMID>
                        </E1ARBCIG_ADDITIONAL_DATA>
                        <E1FICHD SEGMENT="1">
                            <TABNAME>
                                <xsl:value-of select="'BSEG'"/>
                            </TABNAME>
                            <FDNAME>
                                <xsl:value-of select="'ZBD1T'"/>
                            </FDNAME>
                            <NEWVAL>
                                <xsl:choose>
                                    <!--If Payment date contains the 'Z' means timezone conversion is not required -->
                                    <xsl:when test="contains($pm/@paymentDate, 'Z')">
                                        <xsl:value-of
                                            select="concat(substring($pm/@paymentDate, 1, 4), substring($pm/@paymentDate, 6, 2), substring($pm/@paymentDate, 9, 2))"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="v_erpdate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                  select="$pm/@paymentDate"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--Convert the final date into SAP format is 'YYYYMMDD'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 1, 10), '-', '')"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </NEWVAL>
                        </E1FICHD>
                        <!--Below Segments should not fill 'Maturity Date change' interface-->
                        <xsl:if
                            test="lower-case($pm/PaymentMethod/Description/ShortName) != 'aribascf'">
                            <E1FICHD SEGMENT="1">
                                <TABNAME>
                                    <xsl:value-of select="'BSEG'"/>
                                </TABNAME>
                                <FDNAME>
                                    <xsl:value-of select="'ZBD1P'"/>
                                </FDNAME>
                                <NEWVAL>
                                    <xsl:choose>
                                        <xsl:when test="string-length(normalize-space($pm/DiscountPercent/@percent))>0">
                                            <!-- Direct mapping introduced as a part of CI-2089 -->
                                            <xsl:value-of select="$pm/DiscountPercent/@percent"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!--Calling below template to remove the $ and USD and convert into 2 Decimal-->
                                            <xsl:variable name="v_disamt">
                                                <xsl:call-template name="calc">
                                                    <xsl:with-param name="p_amount"
                                                        select="$pm/DiscountAmount/Money"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:variable name="v_disbsi">
                                                <xsl:call-template name="calc">
                                                    <xsl:with-param name="p_amount"
                                                        select="$pm/DiscountBasis/Money"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:if test="$v_disbsi != 0">
                                                <xsl:value-of select="(($v_disamt div $v_disbsi) * 100)"/>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </NEWVAL>
                            </E1FICHD>
                            <E1FICHD SEGMENT="1">
                                <TABNAME>
                                    <xsl:value-of select="'BKPF'"/>
                                </TABNAME>
                                <FDNAME>
                                    <xsl:value-of select="'XREF1_HD'"/>
                                </FDNAME>
                                <NEWVAL>
                                    <xsl:value-of select="'ARIBA_PMN'"/>
                                </NEWVAL>
                            </E1FICHD>
                            <E1FICHD SEGMENT="1">
                                <TABNAME>
                                    <xsl:value-of select="'BSEG'"/>
                                </TABNAME>
                                <FDNAME>
                                    <xsl:value-of select="'WSKTO'"/>
                                </FDNAME>
                                <NEWVAL>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$pm/TaxAdjustment/TaxAdjustmentDetail/upper-case(@category) = 'PST'">
                                            <xsl:variable name="taxsum">
                                                <xsl:value-of
                                                    select="sum($pm/TaxAdjustment/TaxAdjustmentDetail[upper-case(@category) = 'PST']/Money)"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="v_disamt">
                                                <!--Calling below template to remove the $ and USD and convert into 2 Decimal-->
                                                <xsl:call-template name="calc">
                                                    <xsl:with-param name="p_amount"
                                                        select="$pm/DiscountAmount/Money"/>
                                                </xsl:call-template>
                                            </xsl:variable>
                                            <xsl:value-of
                                                select="format-number(($taxsum + $v_disamt), '0.00')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="$v_addOnCIversion &gt;= '11'">
                                                <xsl:variable name="v_disamt">
                                                    <!--Calling below template to remove the $ and USD and convert into 2 Decimal-->
                                                    <xsl:call-template name="calc">
                                                        <xsl:with-param name="p_amount"
                                                            select="$pm/DiscountAmount/Money"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:value-of
                                                    select="format-number(($v_disamt), '0.00')"/>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </NEWVAL>
                            </E1FICHD>
                        </xsl:if>
                    </E1FIREF>
                </IDOC>
            </ARBCIG_FIDCCH>
        </xsl:if>
    </xsl:template>
    <!--Convert the amount into 2 decimal by truncating the USD & $-->
    <xsl:template name="calc">
        <xsl:param name="p_amount"/>
        <xsl:variable name="v_amount">
            <xsl:value-of select="translate(translate($p_amount, '$', ''), 'USD', '')"/>
        </xsl:variable>
        <xsl:value-of select="format-number($v_amount, '#.00')"/>
    </xsl:template>
</xsl:stylesheet>
