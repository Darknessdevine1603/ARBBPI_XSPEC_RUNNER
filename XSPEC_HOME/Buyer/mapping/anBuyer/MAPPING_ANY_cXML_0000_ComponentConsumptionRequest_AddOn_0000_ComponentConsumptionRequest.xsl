<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
    <xsl:variable name="v_date">
        <xsl:value-of select="current-date()"/>
    </xsl:variable>
    <!-- parameter -->
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/> 
    <xsl:param name="anSourceDocumentType"/> 
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <!--<xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <!--    System ID incase of MultiERP-->
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="/Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--PD path    -->
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
    
    <!--    Main template-->
    <xsl:template match="Combined">
        <xsl:variable name="v_path" select="Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionHeader"/>
        <n0:ComponentConsumption>
            <MessageHeader>
                <CreationDateTime>                    
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="$v_path/@creationDate"/>
                            <xsl:with-param name="p_timezone"  select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>         
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->                     
                    <xsl:value-of select="$v_erpdate"/>                    
                </CreationDateTime>
                <AribaNetworkPayloadID>
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of select="$anReceiverID"/>
                </AribaNetworkID>                
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="$v_sysid"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <ComponentConsumptionHeader>                
                <ConsumptionID>
                    <xsl:value-of select="$v_path/@consumptionID"/>
                </ConsumptionID>
                <ReferenceDocumentID>
                    <xsl:value-of select="$v_path/@referenceDocumentID"/>
                </ReferenceDocumentID>
                <!---Need to convert as per ERP format YYYY-MM-DD -->
                <CreationDate>
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="$v_path/@creationDate"/>
                            <xsl:with-param name="p_timezone"  select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>         
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->                     
                    <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"/> 
                </CreationDate>
                <LastChangeDate>                    
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="$v_path/@lastChangeDate"/>
                            <xsl:with-param name="p_timezone"  select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>         
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->                     
                    <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"/>  
                </LastChangeDate>
                <LanguageCode>
                    <xsl:value-of select="$v_path/Comments/@xml:lang"/>
                </LanguageCode>
            </ComponentConsumptionHeader>
            <xsl:for-each select="Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionPortion">
                <xsl:variable name="v_orderID">
                    <xsl:value-of select="OrderReference/@orderID"/>
                </xsl:variable>
                <xsl:variable name="v_orderDate">
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="OrderReference/@orderDate"/>
                            <xsl:with-param name="p_timezone"  select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>         
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->                     
                    <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"/>                    
                </xsl:variable>
                <xsl:for-each select="ComponentConsumptionItem">
                    <xsl:variable name="lineNum">
                        <xsl:value-of select="@poLineNumber"/>
                    </xsl:variable>
                    <xsl:variable name="itemQuant">
                        <xsl:value-of select="@quantity"/>
                    </xsl:variable>
                    <xsl:variable name="itemsupppartid">
                        <xsl:value-of select="ItemID/SupplierPartID"/>
                    </xsl:variable>
                    <xsl:variable name="itembuypartid">
                        <xsl:value-of select="ItemID/BuyerPartID"/>
                    </xsl:variable>
                    <xsl:variable name="itemsupplierbatchid">
                        <xsl:value-of select="Batch/SupplierBatchID"/>
                    </xsl:variable>                    
                    <xsl:for-each select="ComponentConsumptionDetails">
                        <ComponentConsumptionItem>
<!--SortKey population -->
                            <SortKey>
                                <xsl:value-of select="concat(concat($itembuypartid,$lineNum), $itemsupplierbatchid)"/>
                            </SortKey>
                            <orderID>
                                <xsl:value-of select="$v_orderID"/>
                            </orderID>
                            <xsl:if test="not($v_orderDate = '')">
                                <orderDate>
                                    <xsl:value-of select="$v_orderDate"/>
                                </orderDate>
                            </xsl:if>
                            <poLineItem>
                                <xsl:value-of select="$lineNum"/>
                            </poLineItem>
                            <xsl:if test="string-length($itemQuant) > 0">
                                <itemQuantity>
                                    <xsl:value-of select="$itemQuant"/>
                                </itemQuantity>
                            </xsl:if>
                            <ItemSupplierPartID>
                                <xsl:value-of select="$itemsupppartid"/>
                            </ItemSupplierPartID>
                            <ItemBuyerpartID>
                                <xsl:value-of select="$itembuypartid"/>
                            </ItemBuyerpartID>
                            <ComponentLineNumber>
                                <xsl:value-of select="@lineNumber"/>
                            </ComponentLineNumber>
                            <ComponentQuantity>
                                <xsl:value-of select="@quantity"/>
                            </ComponentQuantity>
                            <ProductbuyerPartID>
                                <xsl:value-of select="Product/BuyerPartID"/>
                            </ProductbuyerPartID>
                            <ComponentUOM>
                                <xsl:call-template name="UOMTemplate_In">
                                    <xsl:with-param name="p_UOMinput" select="UnitOfMeasure"/>
                                    <xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
                                    <xsl:with-param name="p_anSupplierANID" select="$anReceiverID"/>
                                </xsl:call-template>
                            </ComponentUOM>
                            <ComponentBuyerBatchID>
                                <xsl:value-of select="BuyerBatchID"/>
                            </ComponentBuyerBatchID>
                            <ComponentSupplierBatchID>
                                <xsl:value-of select="SupplierBatchID"/>
                            </ComponentSupplierBatchID>
<!--Sub-contracter Batch Id-->
                            <SubConBatchID>
                                <xsl:value-of select="$itemsupplierbatchid"/>
                            </SubConBatchID>
<!--Serial-Number population-->
                            <xsl:for-each select="AssetInfo">
                                <xsl:variable name="v_sid">
                                    <xsl:value-of select="@serialNumber"/>
                                </xsl:variable>
                                <xsl:if test="$v_sid != ''">
                                    <SerialNumber>
                                        <SerialID>
                                            <xsl:value-of select="$v_sid"/>
                                        </SerialID>
                                    </SerialNumber>
                                </xsl:if>
                            </xsl:for-each>
                        </ComponentConsumptionItem>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
            <!--Reference Document-->
            <xsl:for-each select="Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionPortion">
                <xsl:variable name="v_RorderID">
                    <xsl:value-of select="OrderReference/@orderID"/>
                </xsl:variable>
                <xsl:variable name="v_orderDate">
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="OrderReference/@orderDate"/>
                            <xsl:with-param name="p_timezone"  select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>         
                    <!--Convert the final date into SAP format is 'YYYYMMDD'-->                     
                    <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"/>                     
                </xsl:variable>
                <xsl:for-each select="ComponentConsumptionItem">
                    <xsl:variable name="v_RlineNum">
                        <xsl:value-of select="@poLineNumber"/>
                    </xsl:variable>
                    <xsl:variable name="v_RitemQuant">
                        <xsl:value-of select="@quantity"/>
                    </xsl:variable>
                    <xsl:variable name="v_itemsupppartid">
                        <xsl:value-of select="ItemID/SupplierPartID"/>
                    </xsl:variable>
                    <xsl:variable name="v_itembuypartid">
                        <xsl:value-of select="ItemID/BuyerPartID"/>
                    </xsl:variable>
                    <xsl:variable name="v_DocID">
                        <xsl:value-of select="Extrinsic[@name = 'ProductionOrder']"/>
                    </xsl:variable>
                    <xsl:variable name="v_prod_ord_Date">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date" select="Extrinsic[@name = 'ProductionOrderStatusDate']"/>
                            <xsl:with-param name="p_timezone"  select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:for-each select="ComponentConsumptionDetails">
                        <xsl:for-each select="ReferenceDocumentInfo">
                            <ComponentReferenceDocument>
                                <OrderID>
                                    <xsl:value-of select="$v_RorderID"/>
                                </OrderID>
                                <ItemID>
                                    <xsl:value-of select="$v_RlineNum"/>
                                </ItemID>
                                <ComponentLineNumber>
                                    <xsl:value-of select="@lineNumber"/>
                                </ComponentLineNumber>
                                <ComponentQuantity>
                                    <xsl:value-of select="$v_RitemQuant"/>
                                </ComponentQuantity>
                                <RefDocLinenumber>
                                    <xsl:value-of select="@lineNumber"/>
                                </RefDocLinenumber>
                                <xsl:if test="DocumentInfo/@documentType = 'productionOrder'">
                                    <DocumentType>PROD</DocumentType>
                                </xsl:if>
                                <DocumentID>
                                    <xsl:choose>
                                        <xsl:when test="string-length($v_DocID) > 0">
                                            <xsl:value-of select="$v_DocID"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="DocumentInfo/@documentID"/>
                                        </xsl:otherwise>
                                    </xsl:choose>                                    
                                </DocumentID>
                                <xsl:for-each select="DateInfo">                                    
                                    <xsl:variable name="v_erpdate">
                                        <xsl:call-template name="ERPDateTime">
                                            <xsl:with-param name="p_date" select="@date"/>
                                            <xsl:with-param name="p_timezone"  select="$anERPTimeZone"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="v_time">
                                        <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                        <xsl:value-of
                                            select="translate(substring($v_erpdate, 12, 8), ':', '')"/> 
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="@type = 'productionStartDate'">
                                            <productionStartDate>
                                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->                     
                                                <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"/>   
                                            </productionStartDate>
                                            <productionStartTime>
                                                <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                                <xsl:value-of select="translate(substring($v_erpdate, 12, 8), ':', '')"/> 
                                            </productionStartTime>
                                        </xsl:when>
                                        <xsl:when test="@type = 'productionFinishDate'">
                                            <productionFinishDate>
                                                <!--Convert the final date into SAP format is 'YYYYMMDD'-->      
                                                <xsl:choose>
                                                    <xsl:when test="string-length($v_prod_ord_Date) > 0">
                                                        <xsl:value-of select="translate(substring($v_prod_ord_Date, 1, 10), '-', '')"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                   
                                            </productionFinishDate>
                                            <productionFinishTime>
                                                <!--Convert the Time into SAP Time format is'HHMMSS'-->
                                                <xsl:value-of select="translate(substring($v_erpdate, 12, 8), ':', '')"/> 
                                            </productionFinishTime>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>
                            </ComponentReferenceDocument>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>            
            <AribaComment>
                <!--            Header      -->
                <xsl:variable name="v_comLang">
                    <xsl:choose>
                        <xsl:when test="/Combined/Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionHeader/Comments/@xml:lang != ''">
                            <xsl:value-of select="/Combined/Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionHeader/Comments/@xml:lang"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$v_lang"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="CommentsFillProxyIn">
                    <xsl:with-param name="p_comments" select="/Combined/Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionHeader/Comments"/>
                    <xsl:with-param name="p_lang" select="$v_comLang"/>    
                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                </xsl:call-template> 
                <!--            Line        -->
                
                <xsl:for-each select="/Combined/Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionPortion/ComponentConsumptionItem">
                    <xsl:variable name="v_comLang">
                        <xsl:choose>
                            <xsl:when test="Comments/@xml:lang != ''">
                                <xsl:value-of select="Comments/@xml:lang"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$v_lang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="CommentsFillProxyIn">
                        <xsl:with-param name="p_comments" select="Comments"/>
                        <xsl:with-param name="p_lang" select="$v_comLang"/>    
                        <xsl:with-param name="p_itemNumber" select="@poLineNumber"/>
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>  
                </xsl:for-each>
            </AribaComment>    
            <xsl:if test="AttachmentList">
                <xsl:call-template name="InboundAttach">
                    <xsl:with-param name="lineReference" select="Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionPortion/ComponentConsumptionItem/@poLineNumber
                        |Payload/cXML/Request/ComponentConsumptionRequest/ComponentConsumptionPortion/ComponentConsumptionItem/Comments/Attachment/URL"/>
                </xsl:call-template>
            </xsl:if>
        </n0:ComponentConsumption>          
    </xsl:template>
</xsl:stylesheet>
