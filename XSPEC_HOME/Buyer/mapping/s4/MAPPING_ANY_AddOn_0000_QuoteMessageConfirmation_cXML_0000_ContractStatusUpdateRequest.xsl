<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/> -->
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:param name="anERPName"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anSharedSecrete"/>
    <xsl:param name="anEnvName"/>
    <!--	Begin of IG-37151-->
    <xsl:variable name="v_pd">
             <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_srcsystemid">
        <xsl:variable name="crossrefparamLookup" select="document($v_pd)"/>
        <!--Begin of IG-37711-->
        <!--Obtain the first Non Empty value from the list-->
        <xsl:value-of
            select="upper-case($crossrefparamLookup/ParameterCrossReference/ListOfItems/Item[DocumentType = $anTargetDocumentType]/SRCSYSTEMID[text() and not(preceding::SRCSYSTEMID/text())])"
        />
        <!--End of IG-37711-->
    </xsl:variable>
    <!--	End of IG-37151-->    
    <xsl:template match="n0:QuoteMsgConfirmation">
        <Combined>
            <Payload>
                <cXML>
                    <xsl:attribute name="payloadID">
                        <xsl:value-of select="$anPayloadID"/>
                    </xsl:attribute>
                    <xsl:attribute name="timestamp">
                        <xsl:variable name="curDate">
                            <xsl:value-of select="current-dateTime()"/>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat(substring($curDate, 1, 19), substring($curDate, 24, 29))"
                        />
                    </xsl:attribute>
                    <Header>
                        <From>
                            <xsl:call-template name="MultiERPTemplateOut">
                                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                            </xsl:call-template>
                            <!--	Begin of IG-37151-->							
                            <xsl:if	test="upper-case($anIsMultiERP) != 'TRUE' and string-length(normalize-space($v_srcsystemid)) > 0">
                                <Credential>
                                    <xsl:attribute name="domain">SystemID</xsl:attribute>
                                    <Identity>
                                        <xsl:value-of select="$anERPSystemID"/>
                                    </Identity>
                                </Credential>
                            </xsl:if>
                            <!--	End of IG-37151-->
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$anSupplierANID"/>
                                </Identity>
                            </Credential>
                            <!--End Point Fix for CIG-->
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'EndPointID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="'CIG'"/>
                                </Identity>
                            </Credential> 
                        </From>
                        <To>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$anSupplierANID"/>
                                </Identity>
                            </Credential>
                            <Credential>
                                <xsl:attribute name="domain">
                                    
                                        <xsl:value-of select="'PrivateID'"/>
                                    
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="PurchasingContract/VendorParty/InternalID"
                                    />
                                </Identity>
                            </Credential>
                        </To>
                        <Sender>
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'NetworkID'"/>
                                </xsl:attribute>
                                <Identity>
                                    <xsl:value-of select="$anProviderANID"/>
                                </Identity>
                                <SharedSecret>
                                    <xsl:value-of select="'Ariba Sourcing'"/>
                                </SharedSecret>
                            </Credential>
                            <UserAgent>
                                <xsl:value-of select="'Ariba Supplier'"/>
                            </UserAgent>
                        </Sender>
                    </Header>
                    <Request>
                        <ContractStatusUpdateRequest>
                            <Status>
                                <xsl:choose>
                                    <xsl:when test="Log/MaximumLogItemSeverityCode = 1.0">
                                        <xsl:attribute name="code">
                                            
                                                <xsl:value-of select="'200'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="Log/MaximumLogItemSeverityCode = 2.0">
                                        <xsl:attribute name="code">
                                            
                                                <xsl:value-of select="'200'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="Log/MaximumLogItemSeverityCode = 3.0">
                                        <xsl:attribute name="code">
                                            
                                                <xsl:value-of select="'500'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="code">
                                            
                                                <xsl:value-of select="'200'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:attribute name="text">
                                    <xsl:value-of select="Log/Item/Note"/>
                                </xsl:attribute>
                            </Status>
                            <ContractStatus>
                                <xsl:choose>
                                    <xsl:when test="PurchasingContract/Operation = '01'">
                                        <xsl:attribute name="type">
                                           
                                                <xsl:value-of select="'created'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="PurchasingContract/Operation = '02'">
                                        <xsl:attribute name="type">
                                            
                                                <xsl:value-of select="'updated'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="PurchasingContract/Operation = '03'">
                                        <xsl:attribute name="type">
                                            
                                                <xsl:value-of select="'deleted'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="type">
                                            
                                                <xsl:value-of select="'created'"/>
                                            
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <ContractIDInfo>
                                    <xsl:attribute name="contractID">
                                        <xsl:value-of select="PurchasingContract/AribaContractID"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="contractDate">
                                        <xsl:value-of select="PurchasingContract/CreationDate"/>
                                    </xsl:attribute>
                                    <IdReference>
                                        <xsl:attribute name="identifier">
                                            <xsl:value-of select="PurchasingContract/ID"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="domain">
                                            <xsl:choose>
                                                <xsl:when test="PurchasingContract/ProcessingTypeName = 'SAPPurchaseOrderId'">
                                                   
                                                        <xsl:value-of select="'SAPPurchaseOrderId'"/>
                                                    
                                                </xsl:when>
                                                <xsl:when test="PurchasingContract/ProcessingTypeName = 'SAPAgreementId'">
                                                    
                                                        <xsl:value-of select="'SAPAgreementId'"/>
                                                    
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    
                                                        <xsl:value-of select="'SAPAgreementId'"/>
                                                    
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </IdReference>
                                </ContractIDInfo>
                                <xsl:for-each select="PurchasingContract/Item">
                                    <ContractItemStatus>
                                        <ItemStatus>
                                            <xsl:choose>
                                                <xsl:when test="../Operation = '01'">
                                                    <xsl:attribute name="type">
                                                        
                                                            <xsl:value-of select="'created'"/>
                                                        
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:when test="../Operation = '02'">
                                                    <xsl:attribute name="type">
                                                        
                                                            <xsl:value-of select="'updated'"/>
                                                        
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:when test="../Operation = '03'">
                                                    <xsl:attribute name="type">
                                                        
                                                            <xsl:value-of select="'deleted'"/>
                                                        
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="type">
                                                        
                                                            <xsl:value-of select="'created'"/>
                                                        
                                                    </xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <ReferenceDocumentInfo>
                                                <xsl:attribute name="lineNumber">
                                                    <xsl:value-of select="AribaItemID"/>
                                                </xsl:attribute>
                                            </ReferenceDocumentInfo>
                                        </ItemStatus>
                                        <IdReference>
                                            <xsl:attribute name="identifier">
                                                <xsl:value-of select="ID"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="domain">
                                                
                                                    <xsl:value-of select="'SAPLineNumber'"/>
                                                
                                            </xsl:attribute>
                                        </IdReference>
                                    </ContractItemStatus>
                                </xsl:for-each>
                            </ContractStatus>
                            <Extrinsic name="SourcingEventId">
                                <xsl:value-of select="PurchasingContract/AribaSourcingEventID"/>
                            </Extrinsic>
                            <Extrinsic name="VendorId">
                                <xsl:value-of select="PurchasingContract/VendorParty/InternalID"/>
                            </Extrinsic>
                        </ContractStatusUpdateRequest>
                    </Request>
                </cXML>
            </Payload>
        </Combined>
    </xsl:template>
</xsl:stylesheet>
