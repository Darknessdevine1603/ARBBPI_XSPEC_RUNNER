<?xml version="1.0" encoding="UTF-8"?>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:n0="urn:sap-com:document:sap:rfc:functions"
            xmlns:urn="urn:Ariba:Buyer:vsap"
            exclude-result-prefixes="#all" version="2.0">
            <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/><!-- IG-36972 : XSLT Quality Improvement --> 
    <xsl:template match="n0:ARBCIG_REMIT_EXPORT">
        <urn:RemittanceImportAsyncRequest>
            <xsl:attribute name="partition">
                <xsl:value-of select="PARTITION"/>
            </xsl:attribute>
            <xsl:attribute name="variant">
                <xsl:value-of select="VARIANT"/>
            </xsl:attribute>
            <urn:PaymentTransaction_PaymentTransactionWSPull_Item>
              <xsl:for-each select="REMHEADER/item">    
                <urn:item>
                    <urn:BuyerBankInfo>
                        <urn:BankAccountID>
                            <xsl:value-of select="PAYERBANKACCNO"/>
                        </urn:BankAccountID>
                        <urn:BankID>
                            <xsl:value-of select="PAYERBANKNO"/>
                        </urn:BankID>
                        <urn:BankName>
                            <xsl:value-of select="PAYERBANKNAME"/>
                        </urn:BankName>
                    </urn:BuyerBankInfo>
                    <urn:ClearedDate>
                        <xsl:value-of select="BUYERCLEAREDDATE"/>
                    </urn:ClearedDate>
                    <urn:CompanyCode>
                        <urn:UniqueName>
                            <xsl:value-of select="COMP_CODE"/>
                        </urn:UniqueName>
                    </urn:CompanyCode>
                    <urn:CreatedDate>
                        <xsl:value-of select="BUYERCREATEDDATE"/>
                    </urn:CreatedDate>
                    <urn:ExternalProcessedState>
                        <xsl:choose>
                            <xsl:when test="STAT!=''">
                                <xsl:value-of select="STAT"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'00'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </urn:ExternalProcessedState>
                    <urn:LookupID>
                        <xsl:value-of select="LOOKUPID"/>
                    </urn:LookupID>
                    <urn:PaidAmounts>
                        <urn:GrossAmount>
                            <urn:Currency>
                                <urn:UniqueName>
                                    <xsl:value-of select="CURRENCY"/>
                                </urn:UniqueName>
                            </urn:Currency>
                        </urn:GrossAmount>
                        <urn:NetAmount>
                            <urn:Amount>
                                <!--IG-28465: Format the negatve sign(if any)-->
                                <xsl:call-template name="amountCal">
                                    <!--IG-27980: remove extra spaces (if any)-->
                                    <xsl:with-param name="p_amount" select="translate(string(NETAMOUNT),' ','')"/>
                                </xsl:call-template> 
                            </urn:Amount>
                            <urn:Currency>
                                <urn:UniqueName>
                                    <xsl:value-of select="CURRENCY"/>
                                </urn:UniqueName>
                            </urn:Currency>
                        </urn:NetAmount>
                    </urn:PaidAmounts>
                    <urn:PaymentDate>
                        <xsl:value-of select="BUYERPAYMENTDATE"/>
                    </urn:PaymentDate>
                    <urn:PaymentDocumentNumber>
                        <xsl:value-of select="PAYDOC"/>
                    </urn:PaymentDocumentNumber>
                    <urn:PaymentMethodType>
                        <urn:UniqueName>
                            <xsl:value-of select="PAYMENTMETHOD"/>
                        </urn:UniqueName>
                    </urn:PaymentMethodType>
                    <urn:PaymentNumber>
                        <xsl:variable name="v_checkno" select="CHECKNO"/>
                     <xsl:choose>
                         <xsl:when test="not($v_checkno)">
                          <xsl:value-of select="PAYDOC"/>
                         </xsl:when>
                         <xsl:otherwise>
                          <xsl:value-of select="CHECKNO"/>
                         </xsl:otherwise>
                     </xsl:choose>
                    </urn:PaymentNumber>
                    <urn:SupplierBankInfo>
                     <!--   <urn:AccountName>              
                        </urn:AccountName>-->
                        <urn:BankAccountID>
                            <xsl:value-of select="PAYEEBANKACCNO"/>
                        </urn:BankAccountID>
                        <urn:BankID>
                            <xsl:value-of select="PAYEEBANKNO"/>
                        </urn:BankID>
                        <urn:BankName>
                            <xsl:value-of select="PAYEEBANKNAME"/> 
                        </urn:BankName>
                      <!--  <urn:BranchName>           
                        </urn:BranchName>
                        <urn:IBanID>       
                        </urn:IBanID>-->
                    </urn:SupplierBankInfo>
                    <urn:SupplierLocation>
                        <urn:ContactID>
                            <xsl:value-of select="VENDOR"/>
                        </urn:ContactID>
                        <urn:UniqueName>
                            <xsl:value-of select="VENDOR"/>
                        </urn:UniqueName>
                    </urn:SupplierLocation>
                    <urn:SupplierRemitToAddress>
                        <urn:Name>
                            <xsl:value-of select="NAME1"/>
                        </urn:Name>
                        <urn:PostalAddress>
                            <urn:City>
                                <xsl:value-of select="CITY"/> 
                            </urn:City>
                            <urn:Country>
                                <urn:UniqueName>
                                    <xsl:value-of select="COUNTRY"/> 
                                </urn:UniqueName>  
                            </urn:Country>
                            <urn:Lines>
                                <xsl:value-of select="STREET"/> 
                            </urn:Lines>
                            <urn:PostalCode>
                                <xsl:value-of select="POSTALCODE"/>  
                            </urn:PostalCode>
                            <urn:State>
                                <xsl:value-of select="STATE"/>  
                            </urn:State>
                        </urn:PostalAddress>
                    </urn:SupplierRemitToAddress>
                    <urn:TransactionType>
                        <xsl:value-of select="'1'"/>
                    </urn:TransactionType>
                </urn:item>              
              </xsl:for-each>
            </urn:PaymentTransaction_PaymentTransactionWSPull_Item>
            <urn:PaymentTransaction_PaymentTransactionWSDetails_Item>
                <xsl:for-each select="REMITEMS/item">
                    <urn:item>
                        <urn:LineItems>
                            <urn:item>
                                <urn:ExternalPayableReferenceNumber>
                                    <xsl:value-of select="DOC_NO"/>
                                </urn:ExternalPayableReferenceNumber>
                                <urn:ExternalSecondaryPayableReferenceNumber>
                                    <xsl:value-of select="PONUMBER"/>
                                </urn:ExternalSecondaryPayableReferenceNumber>
                                <urn:NumberInCollection>
                                    <xsl:value-of select="ITEM_NO"/>
                                </urn:NumberInCollection>
                                <urn:PaidAmounts>
                                    <urn:DiscountAmount>
                                        <urn:Amount>  
                                            <xsl:call-template name="amountCal">
                                                <!--IG-27980: remove extra spaces (if any)-->
                                                <xsl:with-param name="p_amount" select="translate(string(CASHDISCOUNT),' ','')"/>
                                            </xsl:call-template>
                                        </urn:Amount>
                                        <urn:Currency>
                                            <urn:UniqueName>
                                                <xsl:value-of select="CURRENCY"/>
                                            </urn:UniqueName>
                                        </urn:Currency>
                                    </urn:DiscountAmount>
                                    <urn:GrossAmount>
                                        <urn:Amount>
                                            <xsl:call-template name="amountCal">
                                                <!--IG-27980: remove extra spaces (if any)-->
                                                <xsl:with-param name="p_amount" select="translate(string(GROSSAMOUNT),' ','')"/>
                                            </xsl:call-template>
                                        </urn:Amount>
                                        <urn:Currency>
                                            <urn:UniqueName>
                                                <xsl:value-of select="CURRENCY"/>
                                            </urn:UniqueName>
                                        </urn:Currency>
                                    </urn:GrossAmount>
                                    <urn:NetAmount>
                                        <urn:Amount>
                                            <xsl:call-template name="amountCal">
                                                <!--IG-27980: remove extra spaces (if any)-->
                                                <xsl:with-param name="p_amount" select="translate(string(NETAMOUNT),' ','')"/>
                                            </xsl:call-template>
                                        </urn:Amount>
                                        <urn:Currency>
                                            <urn:UniqueName>
                                                <xsl:value-of select="CURRENCY"/>
                                            </urn:UniqueName>
                                        </urn:Currency>
                                    </urn:NetAmount>
                                </urn:PaidAmounts>
                                <urn:PayableDate>
                                    <xsl:value-of select="BUYERITEMPAYABLEDATE"/>
                                </urn:PayableDate>
                                <urn:PayableReferenceNumber>
                                    <xsl:value-of select="ITEMTEXT"/>
                                </urn:PayableReferenceNumber>
                                <urn:PayableType>
                                    <xsl:value-of select="'1'"/>
                                </urn:PayableType>
                                <urn:SecondaryPayableReferenceNumber>
                                    <xsl:value-of select="PONUMBER"/>
                                </urn:SecondaryPayableReferenceNumber>
                                <urn:SecondaryPayableType>
                                    <xsl:value-of select="'2'"/>
                                </urn:SecondaryPayableType>
                                <urn:SupplierPayableReferenceNumber>
                                    <xsl:value-of select="REFDOC"/>
                                </urn:SupplierPayableReferenceNumber>
                            </urn:item>
                        </urn:LineItems>
                        <urn:LookupID>   
                            <xsl:value-of select="LOOKUPID"/> 
                        </urn:LookupID>
                    </urn:item>
                </xsl:for-each>
            </urn:PaymentTransaction_PaymentTransactionWSDetails_Item>
        </urn:RemittanceImportAsyncRequest>
    </xsl:template>
        <xsl:template name="amountCal">
            <xsl:param name="p_amount"></xsl:param>
            <xsl:choose>
                <xsl:when test="contains($p_amount, '-')">
                    <xsl:variable name="v_index" select="substring-before($p_amount,'-')"/>
                    <xsl:choose>
                        <xsl:when test="$v_index != ''">
                            <xsl:value-of select="concat('-', $v_index)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$p_amount"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$p_amount"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:template>
</xsl:stylesheet>
