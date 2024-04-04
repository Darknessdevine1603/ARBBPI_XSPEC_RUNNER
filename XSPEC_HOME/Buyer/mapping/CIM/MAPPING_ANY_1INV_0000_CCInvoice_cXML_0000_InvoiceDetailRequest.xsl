                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="deploymentMode">
                                    <xsl:value-of select="'test'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- /cXML/Request/InvoiceDetailRequest -->
                        <xsl:element name="InvoiceDetailRequest">
                            <!-- /cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader -->
                            <xsl:element name="InvoiceDetailRequestHeader">
                                <xsl:attribute name="invoiceID">
                                    <xsl:value-of select="/root/data/supplierInvoiceId"/>
                                </xsl:attribute>
                                <xsl:attribute name="purpose">
                                    <xsl:value-of select="$v_invType"/>
                                </xsl:attribute>
                                <xsl:attribute name="operation">
                                    <xsl:value-of select="'new'"/>
                                </xsl:attribute>
                                <xsl:attribute name="invoiceDate">
                                    <xsl:value-of select="concat(substring(/root/data/documentDate, 0, 11), 'T00:00:00-00:00')"/>
                                </xsl:attribute>
                                <xsl:element name="InvoiceDetailHeaderIndicator">
                                    <xsl:attribute name="isHeaderInvoice">
                                        <xsl:value-of select="'yes'"/>
                                    </xsl:attribute>
                                </xsl:element>
                                <!-- short emptytag because its mandatory -->
                                <xsl:element name="InvoiceDetailLineIndicator"/>
                                <!-- find youngest NetDueDate -->
                                <xsl:variable name="v_netDueDate">
                                    <xsl:for-each select="/root/data/paymentInfos/netDueDate">
                                        <xsl:sort select="." data-type="text"/>
                                        <xsl:value-of select="concat(substring(., 0, 11), 'T00:00:00-00:00')"/>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:element name="PaymentInformation">
                                    <xsl:attribute name="paymentNetDueDate">
                                        <xsl:value-of select="substring($v_netDueDate, string-length($v_netDueDate) - 24)"/>
                                    </xsl:attribute>
                                </xsl:element>
                                <!-- Extrinsic originalInvoiceNo -->
                                <xsl:if test="/root/data/supplierInvoiceId != ''">
                                    <Extrinsic name="originalInvoiceNo">
                                        <xsl:value-of select="/root/data/supplierInvoiceId"/>
                                    </Extrinsic>
                                </xsl:if>
                            </xsl:element>
                            <!-- /cXML/Request/InvoiceDetailRequest/InvoiceDetailHeaderOrder -->
                            <xsl:element name="InvoiceDetailHeaderOrder">
                                <!-- /cXML/Request/InvoiceDetailRequest/InvoiceDetailHeaderOrder/InvoiceDetailOrderInfo -->
                                <xsl:element name="InvoiceDetailOrderInfo">
                                    <!-- short tag because its mandatory -->
                                    <xsl:element name="MasterAgreementReference">
                                        <xsl:element name="DocumentReference">
                                            <xsl:attribute name="payloadID"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <!-- referenced PO Number -->
                                    <xsl:if test="/root/data/lineItems[1]/poPosting[1]/purchasingDocumentNumber[1] != ''">
                                        <xsl:element name="OrderIDInfo">
                                            <xsl:attribute name="orderID">
                                                <xsl:value-of select="/root/data/lineItems[1]/poPosting[1]/purchasingDocumentNumber[1]"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                                <!-- /cXML/Request/InvoiceDetailRequest/InvoiceDetailHeaderOrder/InvoiceDetailOrderSummary -->
                                <xsl:element name="InvoiceDetailOrderSummary">
                                    <xsl:attribute name="invoiceLineNumber">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:attribute>
                                    <!-- SubtotalAmount -->
                                    <xsl:call-template name="SubTotalAmount"/>
                                    <!-- GrossAmount -->
                                    <!-- GrossAmount only map is not empty (optional) purpose = "C" or "4" change sign -->
                                    <xsl:if test="$v_amount_gross != ''">
                                        <xsl:element name="GrossAmount">
                                            <xsl:element name="Money">
                                                <xsl:attribute name="currency">
                                                    <xsl:value-of select="/root/data/currency"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                    <xsl:when test="/root/data/purpose = 'C' or /root/data/purpose = '4'">
                                                        <xsl:value-of select="format-number(($v_amount_gross * -1), '0.000000')"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="format-number(($v_amount_gross), '0.000000')"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:if>
                                    <!-- NetAmount -->
                                    <xsl:call-template name="NetAmount"/>
                                </xsl:element>
                            </xsl:element>
                            <!-- /cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary -->
                            <xsl:element name="InvoiceDetailSummary">
                                <!-- SubtotalAmount mandatory -->
                                <xsl:call-template name="SubTotalAmount"/>
                                <!-- Tax pre check section -->
                                <!-- ckeck if currency in tax section equal -->
                                <xsl:variable name="v_cur">
                                    <xsl:for-each select="/root/data/taxes">
                                        <xsl:if test="$v_firstCur != currency">
                                            <xsl:value-of select="'notEqual'"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <!-- sum tax amount -->
                                <xsl:variable name="v_tax_amount">
                                    <xsl:choose>
                                        <xsl:when test="$v_cur = 'notEqual'">
                                            <value>
                                                <xsl:value-of select="'0'"/>
                                            </value>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="/root/data/taxes[amount != '']">
                                                <value>
                                                    <xsl:variable name="v_amount_t">
                                                        <xsl:value-of select="replace(amount, ',', '')"/>
                                                    </xsl:variable>
                                                    <xsl:value-of select="$v_amount_t"/>
                                                </value>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <!-- Tax mandatory -->
                                <xsl:element name="Tax">
                                    <xsl:element name="Money">
                                        <xsl:attribute name="currency">
                                            <xsl:choose>
                                                <xsl:when test="$v_cur != 'notEqual'">
                                                    <xsl:value-of select="$v_firstCur"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="''"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="$v_tax_amount != ''">
                                                <xsl:value-of
                                                    select="format-number(sum($v_tax_amount/value), '0.000000')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'0.000000'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="Description">
                                        <!-- Language konstant 'en-US' -->
                                        <xsl:attribute name="xml:lang">
                                            <xsl:value-of select="'en-US'"/>
                                        </xsl:attribute>
                                        <!-- Description is empty -->
                                        <xsl:value-of select="''"/>
                                    </xsl:element>
                                </xsl:element>
                                <!-- NetAmount -->
                                <xsl:call-template name="NetAmount"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </Payload>
        </Combined>
    </xsl:template>
    <!-- global templates -->
    <!-- determine total "SubTotalAmount" -->
    <xsl:template name="SubTotalAmount">
        <!-- if same currency exist then sumup data.lineItems[n].glPostings[n].amount based on debitCreditCode. 
         Incase of different currencies then map data grossAmount.
         Show negative sign for amount in case data.purpose = 'C' or '4'
         for invoice sumup should be done as S - H and for 'C' or '4' it should be H - S
    -->
        <xsl:variable name="v_amount">
            <xsl:choose>
                <xsl:when test="/root/data/lineItems/glPostings[currency != $v_curHead] or /root/data/lineItems/glPostings = ''">
                    <xsl:choose>
                        <xsl:when test="/root/data/purpose = 'C' or /root/data/purpose = '4'">
                            <value>
                                <xsl:value-of select="$v_amount_gross * -1"/>
                            </value>
                        </xsl:when>
                        <xsl:otherwise>
                            <value>
                                <xsl:value-of select="$v_amount_gross"/>
                            </value>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="/root/data/purpose = 'C' or /root/data/purpose = '4'">
                            <xsl:for-each select="/root/data/lineItems/glPostings">
                                <xsl:choose>
                                    <xsl:when test="debitCreditCode = 'H'">
                                        <value>
                                            <xsl:variable name="v_amount_h">
                                                <xsl:value-of select="replace(amount, ',', '')"/>
                                            </xsl:variable>
                                            <xsl:value-of select="($v_amount_h * -1)"/>
                                        </value>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <value>
                                            <xsl:variable name="v_amount_s">
                                                <xsl:value-of select="replace(amount, ',', '')"/>
                                            </xsl:variable>
                                            <xsl:value-of select="$v_amount_s"/>
                                        </value>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="/root/data/lineItems/glPostings">
                                <xsl:choose>
                                    <xsl:when test="debitCreditCode = 'H'">
                                        <value>
                                            <xsl:variable name="v_amount_h">
                                                <xsl:value-of select="replace(amount, ',', '')"/>
                                            </xsl:variable>
                                            <xsl:value-of select="$v_amount_h"/>
                                        </value>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <value>
                                            <xsl:variable name="v_amount_s">
                                                <xsl:value-of select="replace(amount, ',', '')"/>
                                            </xsl:variable>
                                            <xsl:value-of select="($v_amount_s * -1)"/>
                                        </value>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- SubtotalAmount -->
        <xsl:element name="SubtotalAmount">
            <xsl:element name="Money">
                <xsl:attribute name="currency">
                    <xsl:value-of select="/root/data/currency"/>
                </xsl:attribute>
                <xsl:value-of select="format-number(sum($v_amount/value), '0.000000')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- dete
mine total "NetAmount" -->
    <xsl:template name="NetAmount">
        <!-- sum all discount amounts -->
        <xsl:variable name="v_net_amount">
            <xsl:for-each select="/root/data/paymentInfos">
                <!-- check if manual Cash Discount is empty 17.03.2023 -->
                <xsl:if test="manualCashDiscount != ''">
                    <xsl:choose>
                        <xsl:when test="/root/data/purpose = 'C' or /root/data/purpose = '4'">
                            <value>
                                <xsl:variable name="v_amount_CDM">
                                    <xsl:value-of select="replace(manualCashDiscount, ',', '')"/>
                                </xsl:variable>
                                <xsl:value-of select="($v_amount_CDM * -1)"/>
                            </value>
                        </xsl:when>
                        <xsl:otherwise>
                            <value>
                                <xsl:variable name="v_amount_CDP">
                                    <xsl:value-of select="replace(manualCashDiscount, ',', '')"/>
                                </xsl:variable>
                                <xsl:value-of select="$v_amount_CDP"/>
                            </value>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <!-- NetAmount = GrossAmount - DiscountAmount map NetAmount only if GrossAmount not empty -->
        <xsl:if test="$v_amount_gross != ''">
            <xsl:element name="NetAmount">
                <xsl:element name="Money">
                    <xsl:attribute name="currency">
                        <xsl:value-of select="/root/data/currency"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="/root/data/purpose = 'C' or /root/data/purpose = '4'">
                            <xsl:choose>
                                <xsl:when test="$v_net_amount/value != ''">
                                    <xsl:value-of
                                        select="format-number(($v_amount_gross * -1) - sum($v_net_amount/value), '0.000000')">
                                    </xsl:value-of>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="format-number(($v_amount_gross * -1), '0.000000')">
                                    </xsl:value-of>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$v_net_amount/value != ''">
                                    <xsl:value-of
                                        select="format-number($v_amount_gross - sum($v_net_amount/value), '0.000000')">
                                    </xsl:value-of>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="format-number(($v_amount_gross), '0.000000')">
                                    </xsl:value-of>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
