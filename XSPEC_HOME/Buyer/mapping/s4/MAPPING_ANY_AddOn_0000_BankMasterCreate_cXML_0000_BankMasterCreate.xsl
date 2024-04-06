<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:urn="http://sap.com/xi/SAPGlobal20/Global"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<!--        <xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="ARBCIG_BANK_CREATE/IDOC">
        
        <urn:BankMasterDataRequest>
              <urn:BankMasterDataUploadInputBean_Item>
<!--            <MessageHeader>
                <MessageID>
                    <xsl:value-of select="EDI_DC40/DOCNUM"/>
                </MessageID>
                <CreationDateTime>
                    <xsl:call-template name="BuildTimestamp">
                        <xsl:with-param name="p_date" select="EDI_DC40/CREDAT"/>
                        <xsl:with-param name="p_time" select="EDI_DC40/CRETIM"/>
                    </xsl:call-template>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/SNDPRN"/>
                </SenderBusinessSystemID>
                <RecipientBusinessSystemID>
                    <xsl:value-of select="EDI_DC40/RCVPRN"/>
                </RecipientBusinessSystemID>
            </MessageHeader>
            -->
            
<!--            <MasterBankDataRequestMessage>-->
                <urn:item>
                    <urn:_bankMasterDetail>
                <xsl:for-each select="E1BANK_CREATE">
                    
                <urn:item>
                        
                        <urn:CountryKey>
                            <xsl:value-of select="BANK_CTRY"/>
                        </urn:CountryKey>
                        <urn:Id>
                            <xsl:value-of select="BANK_KEY"/>
                        </urn:Id>
                        <urn:RecordCreatedDate>
                            <xsl:call-template name="BuildTimestamp">
                                <xsl:with-param name="p_date" select="//EDI_DC40/CREDAT"/>
                                <xsl:with-param name="p_time" select="//EDI_DC40/CRETIM"/>
                            </xsl:call-template>
                        </urn:RecordCreatedDate>
                        <urn:CreatorName>
                            <xsl:value-of select="E1BP1011_DETAIL/CREATOR"/>
                        </urn:CreatorName>
                        <urn:Name>
                            <xsl:value-of select="E1BP1011_ADDRESS/BANK_NAME"/>
                        </urn:Name>
                        <urn:Province>
                            <xsl:value-of select="E1BP1011_ADDRESS/REGION"/>
                        </urn:Province>
                        <urn:HouseStreetAddress>
                            <xsl:value-of select="E1BP1011_ADDRESS/STREET"/>
                        </urn:HouseStreetAddress>
                        <urn:City>
                            <xsl:value-of select="E1BP1011_ADDRESS/CITY"/>
                        </urn:City>
                        <urn:SWIFTCode>
                            <xsl:value-of select="E1BP1011_ADDRESS/SWIFT_CODE"/>
                        </urn:SWIFTCode>
                        <urn:Group>
                            <xsl:value-of select="E1BP1011_ADDRESS/BANK_GROUP"/>
                        </urn:Group>
                        <xsl:if test="E1BP1011_ADDRESS/POBK_CURAC = 'X'">
                            <urn:CurrentAccount>
                                <xsl:value-of select="'true'"/>
                            </urn:CurrentAccount>
                        </xsl:if>
                        <xsl:if test="E1BP1011_DETAIL/BANK_DELETE = 'X'">
                            <urn:DeletionIndicator>
                                <xsl:value-of select="'true'"/>
                            </urn:DeletionIndicator>
                        </xsl:if>
                        <urn:Number>
                            <xsl:value-of select="E1BP1011_ADDRESS/BANK_NO"/>
                        </urn:Number>
                        <urn:AddressNumber>
                            <xsl:value-of select="E1BP1011_ADDRESS/ADDR_NO"/>
                        </urn:AddressNumber>
                        <urn:Branch>
                            <xsl:value-of select="E1BP1011_ADDRESS/BANK_BRANCH"/>
                        </urn:Branch>
                </urn:item>
                    
                </xsl:for-each>
            </urn:_bankMasterDetail>
                </urn:item>
                
            <!--</MasterBankDataRequestMessage>-->
               </urn:BankMasterDataUploadInputBean_Item>
        </urn:BankMasterDataRequest>
    </xsl:template>
</xsl:stylesheet>
