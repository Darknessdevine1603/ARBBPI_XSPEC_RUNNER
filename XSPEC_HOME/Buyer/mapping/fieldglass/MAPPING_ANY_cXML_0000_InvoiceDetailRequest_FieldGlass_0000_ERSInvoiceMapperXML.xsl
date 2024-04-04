<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <!--  CI-2260   please keep indent = yes; FG can't consume single line messages-->
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
    <xsl:template match="Combined">
        <xsl:variable name="v_requestHeader">
            <xsl:copy-of
                select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailRequestHeader"/>
        </xsl:variable>
<!--    CI-1938 Release 2205: Delete mapping for InvoiceNetAmount, delete mappings for all Adjustments, because FG is going to create own invoices.     -->
        <ERSInvoiceMapperXML>
            <HeaderData/>
            <InvoiceData>
                <xsl:for-each-group
                    select="Payload/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailServiceItem[string-length(normalize-space(ServiceEntryItemReference/@serviceEntryID)) > 0]"
                    group-by="ServiceEntryItemReference/@serviceEntryID">
                    <InvoiceDetail>
                        <ObjectRef>
                            <xsl:value-of select="ServiceEntryItemReference/@serviceEntryID"/>
                        </ObjectRef>
                        <xsl:if
                            test="string-length(normalize-space(../InvoiceDetailOrderInfo/OrderReference/@orderID)) > 0">
                            <ExternalObjectRef>
                                <xsl:value-of
                                    select="../InvoiceDetailOrderInfo/OrderReference/@orderID"/>
                            </ExternalObjectRef>
                        </xsl:if>
                        <ServiceEntryRef>
                            <xsl:value-of select="ServiceEntryItemReference/@serviceEntryID"/>
                        </ServiceEntryRef>
                        <Adjustments/>
                        <Status>
                            <xsl:value-of select="'APPROVED'"/>
                        </Status>
                        <CustomFields>
                            <CustomField>
                                <Name>
                                    <xsl:value-of select="'Invoice ID'"/>
                                </Name>
                                <Value>
                                    <xsl:value-of
                                        select="$v_requestHeader/InvoiceDetailRequestHeader/@invoiceID"
                                    />
                                </Value>
                            </CustomField>
                            <CustomField>
                                <Name>
                                    <xsl:value-of select="'Invoice Date'"/>
                                </Name>
                                <Value>
                                    <xsl:value-of
                                        select="$v_requestHeader/InvoiceDetailRequestHeader/@invoiceDate"
                                    />
                                </Value>
                            </CustomField>
                        </CustomFields>
                    </InvoiceDetail>
                </xsl:for-each-group>
            </InvoiceData>
        </ERSInvoiceMapperXML>
    </xsl:template>
</xsl:stylesheet>
