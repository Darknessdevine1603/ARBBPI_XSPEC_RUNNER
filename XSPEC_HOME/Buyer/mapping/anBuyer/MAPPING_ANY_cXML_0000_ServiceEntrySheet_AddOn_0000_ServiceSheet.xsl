<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="#all">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- parameter -->
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anAddOnCIVersion"/>
    <!--<xsl:include href="FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
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
    <!--Fetch TextIDs fro Header and Line comments-->
    <xsl:variable name="v_htextid">
        <xsl:value-of
            select="$v_pd/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/HeaderTextID"
        />
    </xsl:variable>
    <xsl:variable name="v_ltextid">
        <xsl:value-of
            select="$v_pd/ParameterCrossReference/ListOfItems/Item[DocumentType = $anSourceDocumentType]/LineTextID"
        />
    </xsl:variable>
    <!--  To inform that the input is from AN-->
    <xsl:variable name="v_AribaAsn" select="'ARIBA_ASN'"/>    
    <!--    Get CIG Addon Version-->
    <xsl:variable name="v_supportsp07onwards">
        <xsl:call-template name="Check_SupportVersion">
            <xsl:with-param name="p_sysversion" select="$anAddOnCIVersion"/>
            <xsl:with-param name="p_suppversion" select="'07'"/>
        </xsl:call-template>
    </xsl:variable>
    <!-- Main template -->
    <xsl:template match="Combined">
        <n0:ServiceEntrySheetRequest>
            <xsl:variable name="v_erpdate">
                <xsl:call-template name="ERPDateTime">
                    <xsl:with-param name="p_date"
                        select="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/@serviceEntryDate"/>
                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                </xsl:call-template>
            </xsl:variable>
            <MessageHeader>
                <CreationDateTime>
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
            <ServiceAcknowledgement>
                <xsl:if
                    test="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/@operation = 'delete'">
                    <ActionCode>
                        <xsl:value-of select="'03'"/>
                    </ActionCode>
                </xsl:if>
                <xsl:if
                    test="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/@isFinal = 'yes'">
                    <FinalIndicator>
                        <xsl:value-of select="'true'"/>
                    </FinalIndicator>
                </xsl:if>
                <ID>
                    <xsl:value-of select="$v_AribaAsn"/>
                </ID>
                <SellerID>
                    <xsl:value-of
                        select='substring(Payload/cXML/Header/From/Credential[@domain = "VendorID"]/Identity, 1, 35)'/>
                </SellerID>
                <!-- Requires input from PD to include Timezone-->
                <CreationDateTime>
                    <xsl:value-of select="translate(substring($v_erpdate, 1, 10), '-', '')"/>
                </CreationDateTime>
                <Description>
                    <xsl:value-of
                        select="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/@serviceEntryID"
                    />
                </Description>
                <TextCollection>
                    <xsl:variable name="v_comments">
                        <xsl:call-template name="removeChild">
                            <xsl:with-param name="p_comment" select="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/Comments"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="CommentSplit">
                        <xsl:with-param name="p_str" select="$v_comments"/>
                        <xsl:with-param name="p_strlen" select="132.0"/>
                        <xsl:with-param name="p_textId" select="$v_htextid"/>
                    </xsl:call-template>
                </TextCollection>
                <!-- Loop over the cXML item and map item fields -->
                <xsl:for-each
                    select="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryOrder/ServiceEntryItem">
                    <Item>
                        <!-- use itemID i.e., lineNumber as a variable since it is later used multiple times -->
                        <xsl:variable name="serviceLineNumber" select="@serviceLineNumber"/>
                        <xsl:variable name="itemId" select="ItemReference/@lineNumber"/>
                        <xsl:variable name="itemIdLength"
                            select="string-length(ItemReference/@lineNumber)"/>
                        <!-- treated as Planned line if length is more than 5 -->
                        <xsl:if test="$itemIdLength > 5.0">
                            <ID>
                                <!-- substring starting from (length-4) -->
                                <xsl:value-of select="substring($itemId, $itemIdLength - 4.0)"/>
                            </ID>
                        </xsl:if>
						<!--There are 2 new fields from AN & P2P need to be mapped for SES inbound, 
                            there is no such fields exists in SES Inbound proxy/ ES so we are mapping 
                            this two fields in existing structure -->
                        <!--FromPO field map to  FinalIndicator--> 
                        <xsl:if test="Extrinsic/@name = 'isLineFromPO'">
                            <FinalIndicator>
                                <xsl:choose>
                                    <xsl:when test="Extrinsic[@name = 'isLineFromPO'] = 'yes'">
                                        <xsl:value-of select="'true'"/>
                                    </xsl:when>
                                    <xsl:when test="Extrinsic[@name = 'isLineFromPO'] = 'no'">
                                        <xsl:value-of select="'false'"/>
                                    </xsl:when>
                                </xsl:choose>
                            </FinalIndicator>
                        </xsl:if>
						<!--AdHoc field map to  FinalIndicator-->
                        <ByBidderProvidedIndicator>
                            <xsl:choose>
                                <xsl:when test="@isAdHoc = 'yes'">
                                    <xsl:value-of select="'true'"/>
                                </xsl:when>
                                <xsl:when test="@isAdHoc = 'no'">
                                    <xsl:value-of select="'false'"/>
                                </xsl:when>
                            </xsl:choose>
                        </ByBidderProvidedIndicator>
                        <Distrib>
                            <xsl:for-each select="Distribution[position()=1]">
                                <xsl:choose>
                                    <xsl:when test="string-length(Accounting/AccountingSegment[normalize-space(Name) = 'Quantity']/@id) > 0">
                                        <xsl:value-of select="'1'"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(Accounting/AccountingSegment[normalize-space(Name) = 'Amount']/@id) > 0">
                                        <xsl:value-of select="'3'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="''"/>
                                    </xsl:otherwise>
                                </xsl:choose>         
                            </xsl:for-each>
                        </Distrib>
                        <!-- Requires input from PD -->
                        <DeliveryPeriod>
                            <StartDateTime>
                                <xsl:variable name="v_erpStartdate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date"
                                            select="../../ServiceEntryRequestHeader/Period/@startDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:value-of
                                    select="translate(substring($v_erpStartdate, 1, 10), '-', '')"/>
                            </StartDateTime>
                            <EndDateTime>
                                <xsl:variable name="v_erpEnddate">
                                    <xsl:call-template name="ERPDateTime">
                                        <xsl:with-param name="p_date"
                                            select="../../ServiceEntryRequestHeader/Period/@endDate"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:value-of
                                    select="translate(substring($v_erpEnddate, 1, 10), '-', '')"/>
                            </EndDateTime>
                        </DeliveryPeriod>
                        <!--            UOM variable-->
                        <xsl:variable name="v_uom">
                            <xsl:choose>
                                <xsl:when test="UnitOfMeasure">
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput" select="UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="UOMTemplate_In">
                                        <xsl:with-param name="p_UOMinput"
                                            select="UnitRate/UnitOfMeasure"/>
                                        <xsl:with-param name="p_anERPSystemID" select="$v_sysid"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anReceiverID"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <Quantity>
                            <xsl:attribute name="unitCode">
                                <xsl:value-of select="$v_uom"/>
                            </xsl:attribute>
                            <xsl:value-of select="@quantity"/>
                        </Quantity>
                        <!-- Requires input from PD -->
                        <Price>
                            <Amount>
                                <xsl:choose>
                                    <xsl:when test="UnitPrice">
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="UnitPrice/Money/@currency"/>
                                        </xsl:attribute>
                                        <!-- IG-25040 : Removed the ',' seperator in the amounts-->
                                        <xsl:value-of select="format-number(number(translate(UnitPrice/Money, ',', '')), '#0.00')"/> 
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="currencyCode">
                                            <xsl:value-of select="UnitRate/Money/@currency"/>
                                        </xsl:attribute>
                                        <!-- IG-25040 : Removed the ',' seperator in the amounts-->
                                        <xsl:value-of select="format-number(number(translate(UnitRate/Money, ',', '')), '#0.00')"/> 
                                    </xsl:otherwise>
                                </xsl:choose>
                            </Amount>
                            <BaseQuantity>
                                <xsl:attribute name="unitCode">
                                    <xsl:value-of select="$v_uom"/>
                                </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="$v_supportsp07onwards = 'true'">
                                        <xsl:choose>
                                            <xsl:when test="string-length(normalize-space(UnitRate/PriceBasisQuantity/@quantity)) > 0">
                                                <xsl:value-of select="UnitRate/PriceBasisQuantity/@quantity"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'0'"/>
                                            </xsl:otherwise>
                                        </xsl:choose> 
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'1'"/>
                                    </xsl:otherwise>
                                </xsl:choose>                               
                            </BaseQuantity>
                        </Price>
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(ItemReference/Description)) > 0">
                                <Description>
                                    <xsl:value-of select="ItemReference/Description"/>
                                </Description>
                            </xsl:when>
                            <xsl:otherwise>
                                <Description>
                                    <xsl:value-of select="'Ad-hoc Item'"/>
                                </Description>
                            </xsl:otherwise>
                        </xsl:choose>
                        <HierarchyRelationship>
                            <ParentItemID>
                                <xsl:value-of select="$serviceLineNumber"/>
                            </ParentItemID>
                        </HierarchyRelationship>
                        <!-- CI-2134 Support Buyer/Supplier Part ID -->
                        <xsl:if test="string-length(normalize-space(ItemReference/ItemID/BuyerPartID)) or string-length(normalize-space(ItemReference/ItemID/SupplierPartID)) > 0">
                            <Product>
                                <xsl:if test="string-length(normalize-space(ItemReference/ItemID/BuyerPartID)) > 0">
                                    <BuyerID>
                                        <xsl:value-of select="substring(ItemReference/ItemID/BuyerPartID, 1, 60)"/>
                                    </BuyerID>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(ItemReference/ItemID/SupplierPartID)) > 0">
                                    <SellerID>
                                        <xsl:value-of select="substring(ItemReference/ItemID/SupplierPartID, 1, 60)"/>
                                    </SellerID>
                                </xsl:if>
                            </Product>
                        </xsl:if>
                        <!-- CI-2134 -->
                        <PurchasingContractReference>
                            <xsl:choose>
                                <xsl:when test="$itemIdLength = 10.0">
                                    <ID>
                                        <xsl:value-of
                                            select="concat('5', substring($itemId, 2.0, $itemIdLength))"
                                        />
                                    </ID>
									<!--Contract is Mapped to ItemId field-->
                                    <ItemID>
                                        <xsl:value-of select="MasterAgreementIDInfo/@agreementID"/>
                                    </ItemID>
                                </xsl:when>
                                <xsl:otherwise>
                                    <ID>
                                        <xsl:value-of select="$itemId"/>
                                    </ID>
									<!--Contract is Mapped to ItemId field-->
                                    <ItemID>
                                        <xsl:value-of select="MasterAgreementIDInfo/@agreementID"/>
                                    </ItemID>
                                </xsl:otherwise>
                            </xsl:choose>
                        </PurchasingContractReference>
                        <PurchaseOrderReference>
                            <ID>
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(../ServiceEntryOrderInfo/OrderReference/@orderID)) > 0 ">
                                        <xsl:value-of
                                            select="../ServiceEntryOrderInfo/OrderReference/@orderID"/>  
                                    </xsl:when>
                                    <xsl:when test="string-length(normalize-space(../ServiceEntryOrderInfo/OrderIDInfo/@orderID)) > 0">
                                        <xsl:value-of select="../ServiceEntryOrderInfo/OrderIDInfo/@orderID"/>
                                    </xsl:when>
                                </xsl:choose>                                
                            </ID>
                            <ItemID>                             
                            <xsl:choose>                                                      
                                <!--Check for Extrinsic Field - for info on parentPOLineNumber first-->
                                <xsl:when test="string-length(normalize-space(Extrinsic[@name='parentPOLineNumber'])) > 0">                                    
                                        <xsl:value-of select="Extrinsic[@name='parentPOLineNumber']"/>                                    
                                </xsl:when>
                                <!-- converting it to be compatible to ERP itemID length -->                                
                                <xsl:when test="$itemIdLength &lt;= 5.0">                                    
                                        <xsl:value-of select="$itemId"/>                                    
                                </xsl:when>
                                <xsl:otherwise>                                    
                                        <xsl:value-of
                                            select="substring($itemId, $itemIdLength - 4.0)"/>                                    
                                </xsl:otherwise>
                            </xsl:choose>
                            </ItemID>
                        </PurchaseOrderReference>
                        <AccountAssignment>
                            <!-- Loop over cXML Distribution and map the Account assignment fields -->
                            <xsl:for-each select="Distribution">
                                <AccountingCodingBlockAssignment>
                                    <OrdinalNumberValue>
                                        <xsl:value-of select="$serviceLineNumber"/>
                                    </OrdinalNumberValue>
                                    <CostCentreID>
                                        <xsl:value-of
                                            select="substring(Accounting/AccountingSegment[normalize-space(Name) = ('CostCenter', 'Cost Center')]/@id, 1, 20)"
                                        />
                                    </CostCentreID>
                                    <ProjectReference>
                                        <ProjectID>
                                            <xsl:value-of
                                                select='Accounting/AccountingSegment[normalize-space(Name) = "WBSElement"]/@id'
                                            />
                                        </ProjectID>
                                    </ProjectReference>
                                    <InternalOrderID>
                                        <xsl:value-of
                                            select='Accounting/AccountingSegment[normalize-space(Name) = "InternalOrder"]/@id'
                                        />
                                    </InternalOrderID>
                                    <GeneralLedgerAccountReference>
                                        <ID>
                                            <xsl:value-of
                                                select='Accounting/AccountingSegment[normalize-space(Name) = ("GeneralLedger","GL Account")]/@id'
                                            />
                                        </ID>
                                    </GeneralLedgerAccountReference>
                                    <FixedAssetReference>
                                        <MasterFixedAssetID>
                                            <xsl:value-of
                                                select='Accounting/AccountingSegment[normalize-space(Name) = "Asset"]/@id'
                                            />
                                        </MasterFixedAssetID>
                                    </FixedAssetReference>
                                </AccountingCodingBlockAssignment>
                            </xsl:for-each>
                        </AccountAssignment>
                        <AccountAssignmentValues>
                            <xsl:for-each select="Distribution">
                                <xsl:if
                                    test="string-length(Accounting/AccountingSegment[normalize-space(Name) = 'Percentage']/@id) > 0">
                                    <AccAssValues>
                                        <Percentage>
                                            <xsl:value-of
                                                select='Accounting/AccountingSegment[normalize-space(Name) = "Percentage"]/@id'
                                            />
                                        </Percentage>
                                    </AccAssValues>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(Accounting/AccountingSegment[normalize-space(Name) = 'Quantity']/@id) > 0">
                                    <AccAssValues>
                                        <Quantity>
                                            <xsl:value-of
                                                select='Accounting/AccountingSegment[normalize-space(Name) = "Quantity"]/@id'
                                            />
                                        </Quantity>
                                    </AccAssValues>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(Accounting/AccountingSegment[normalize-space(Name) = 'Amount']/@id) > 0">
                                    <AccAssValues>
                                        <Amount>
                                            <xsl:attribute name="currencyCode">
                                                <xsl:value-of select="Charge/Money/@currency"/>
                                            </xsl:attribute>
                                            <!-- IG-25040 : Removed the ',' seperator in the amounts-->                                            
                                            <xsl:value-of select="format-number(number(translate(Charge/Money, ',', '')), '#0.00')"/>
                                        </Amount>
                                    </AccAssValues>
                                </xsl:if>
                            </xsl:for-each>
                        </AccountAssignmentValues>
                        <ServicePerformerParty>
                            <BuyerID>
                                <xsl:value-of
                                    select="substring(../../ServiceEntryRequestHeader/PartnerContact/Contact[@role = 'requester']/Name, 1, 60)"
                                />
                            </BuyerID>
                            <xsl:choose>
                                <xsl:when
                                    test="../../ServiceEntryRequestHeader/PartnerContact/Contact/@role = 'fieldEngineer'">
                                    <SellerID>
                                        <xsl:value-of
                                            select="substring(../../ServiceEntryRequestHeader/PartnerContact/Contact[@role = 'fieldEngineer']/Name, 1, 60)"
                                        />
                                    </SellerID>
                                </xsl:when>
                                <xsl:otherwise>
                                    <SellerID>
                                        <xsl:value-of
                                            select="substring(../../ServiceEntryRequestHeader/PartnerContact/Contact[@role = 'fieldContractor']/Name, 1, 60)"
                                        />
                                    </SellerID>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ServicePerformerParty>
                        <xsl:variable name="v_comments">
                            <xsl:call-template name="removeChild">
                                <xsl:with-param name="p_comment" select="Comments"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <TextCollection>
                            <xsl:call-template name="CommentSplit">
                                <xsl:with-param name="p_str" select="$v_comments"/>
                                <xsl:with-param name="p_strlen" select="132.0"/>
                                <xsl:with-param name="p_textId" select="$v_ltextid"/>
                            </xsl:call-template>
                        </TextCollection>
                    </Item>
                </xsl:for-each>
            </ServiceAcknowledgement>
            <xsl:if
                test="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader[@operation = 'delete']/Comments">
                <AribaComment>
                    <xsl:variable name="v_commentsLang">
                        <xsl:choose>
                            <xsl:when
                                test="string-length(normalize-space(Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/Comments/@xml:lang)) > 0">
                                <xsl:value-of
                                    select="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/Comments/@xml:lang"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$v_lang"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="CommentsFillProxyIn">
                        <xsl:with-param name="p_comments"
                            select="Payload/cXML/Request/ServiceEntryRequest/ServiceEntryRequestHeader/Comments"/>
                        <xsl:with-param name="p_lang" select="$v_commentsLang"/>
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </AribaComment>
            </xsl:if>
            <xsl:if test="AttachmentList">
                <xsl:call-template name="InboundAttach">
                    <xsl:with-param name="lineReference"
                        select="
                            Payload/cXML/Request/ServiceEntryRequest/ServiceEntryOrder/ServiceEntryItem/@serviceLineNumber
                            | Payload/cXML/Request/ServiceEntryRequest/ServiceEntryOrder/ServiceEntryItem/Comments/Attachment/URL"
                    />
                </xsl:call-template>
            </xsl:if>
        </n0:ServiceEntrySheetRequest>
    </xsl:template>
    <xsl:template name="CommentSplit">
        <xsl:param name="p_str"/>
        <xsl:param name="p_strlen"/>
        <xsl:param name="p_textId"/>
        <xsl:param name="p_tdformat"/>
        <xsl:variable name="v_str1" select="substring($p_str, 1, $p_strlen)"/>
        <xsl:variable name="v_str2" select="substring($p_str, $p_strlen + 1)"/>
        <xsl:if test="$v_str1">
            <Text>
                <TypeCode>
                    <xsl:value-of select="$p_textId"/>
                </TypeCode>
                <ContentText>
                    <xsl:value-of select="$v_str1"/>
                </ContentText>
            </Text>
        </xsl:if>
        <xsl:if test="$v_str2">
            <xsl:call-template name="CommentSplit">
                <xsl:with-param name="p_str" select="$v_str2"/>
                <xsl:with-param name="p_strlen" select="$p_strlen"/>
                <xsl:with-param name="p_textId" select="$p_textId"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
