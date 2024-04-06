<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:n0="http://sap.com/xi/ARBCIG1"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPTimeZone"/>
    <!--<xsl:include href="../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>-->
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="Combined">
        <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
        <xsl:variable name="v_sysId">
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
                <xsl:with-param name="p_erpsysid" select="$v_sysId"/>
                <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
            </xsl:call-template>
        </xsl:variable>
        <!--Get the Language code-->
        <xsl:variable name="v_lang">
            <xsl:choose>
                <xsl:when test="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/Comments/@xml:lang != ''">
                    <xsl:value-of
                        select="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/Comments/@xml:lang"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="FillDefaultLang">
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--          CI-1782 :Get the Deviation Language code        -->
        <xsl:variable name="v_deviationLang">
            <xsl:choose>
                <xsl:when
                    test="string-length(normalize-space(Payload/cXML/Request/ApprovalRequest/AcceptanceItem[DeviationReason/Comments/@xml:lang[normalize-space()]][1]/DeviationReason/Comments/@xml:lang)) > 0">
                    <xsl:value-of
                        select="Payload/cXML/Request/ApprovalRequest/AcceptanceItem[DeviationReason/Comments/@xml:lang[normalize-space()]][1]/DeviationReason/Comments/@xml:lang"
                    />
                </xsl:when>  
                <xsl:otherwise>
                    <xsl:call-template name="FillDefaultLang">
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="v_dateTime" select="Payload/cXML/@timestamp"/>
        <n0:OrdConfAppReqMsg>
            <!--MessageHeader node-->
            <MessageHeader>
                <CreationDateTime>
                    <xsl:value-of select="$v_dateTime"/>
                </CreationDateTime>
                <AribaNetworkPayloadID>
<!--                    Supplier Payload Id -->
                    <xsl:value-of select="Payload/cXML/@payloadID"/>
                </AribaNetworkPayloadID>
                <AribaNetworkID>
                    <xsl:value-of select="$anReceiverID"/>
                </AribaNetworkID>
                <RecipientParty>
                    <InternalID>
                        <xsl:value-of select="$v_sysId"/>
                    </InternalID>
                </RecipientParty>
            </MessageHeader>
            <!--OrderConfirmationApproval node-->
            <OrderConfirmationApproval>
                <ID>
                    <xsl:choose>
                    <!--Check for case of SA/SAR - OrderId value would appear as [10DIGITORDER][5DIGITITEMNO][FOR/JIT]- Example-[550000161900010JIT]-->
                        <xsl:when test="string-length(Payload/cXML/Request/ConfirmationRequest/OrderReference/@orderID) > 10">
                            <xsl:value-of select="substring(Payload/cXML/Request/ConfirmationRequest/OrderReference/@orderID,1,10)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="Payload/cXML/Request/ConfirmationRequest/OrderReference/@orderID"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </ID>
                <ConfirmationID>
                    <xsl:value-of select="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/@confirmID"/>
                </ConfirmationID>
                <PurchOrdDate>
                   <xsl:call-template name="ERPDateTime">
                        <xsl:with-param name="p_date"
                            select="Payload/cXML/Request/ConfirmationRequest/OrderReference/@orderDate"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                    </xsl:call-template>
                </PurchOrdDate>
                <BuyerPostingDate>
                   <xsl:call-template name="ERPDateTime">
                        <xsl:with-param name="p_date"
                            select="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/@noticeDate"/>
                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                    </xsl:call-template>
                </BuyerPostingDate>
                <!--Populate Vendor Party , Internal ID to handle SUR Response. Otherwise , CIG fails the SUR since Vendor ID will be blank-->
                <VendorParty>
                    <InternalID>
                        <xsl:choose>
                            <xsl:when test="exists(Payload/cXML/Header/From/Credential [@domain = 'VendorID']/Identity)">
                                <xsl:value-of select="Payload/cXML/Header/From/Credential [@domain = 'VendorID']/Identity"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="Payload/cXML/Header/From/Credential [@domain = 'PrivateID']/Identity"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </InternalID>
                </VendorParty>
                <!--Fill Item details-->
                <!--                            Map Acceptance status-->
                <xsl:for-each select="Payload/cXML/Request/ApprovalRequest/AcceptanceItem">
                    <xsl:variable name="v_item" select="@lineNumber"/>
                    <xsl:variable name="v_actionCode">
                        <xsl:choose>
                            <xsl:when test="@acceptanceStatus = 'approved'">
                                <xsl:value-of select="'01'"/>
                            </xsl:when>
                            <xsl:when test="@acceptanceStatus = 'approvedAndUpdatePO'">
                                <xsl:value-of select="'02'"/>
                            </xsl:when>
                            <xsl:when test="@acceptanceStatus = 'rejected'">
                                <xsl:value-of select="'03'"/>
                            </xsl:when>
                            <!--    CI-1782 : Added '04' status for awaitingApproval     -->
                            <xsl:when test="@acceptanceStatus = 'awaitingApproval'">
                                <xsl:value-of select="'04'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'05'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="exists(AcceptanceItemDetail)">
                            <Item>
                                <xsl:if test="string-length(normalize-space(@lineNumber))>0">
                                <ID>
                                    <!-- Begin of IG-43046 -->
                                    <!-- Pass line item number without zeros as ERP expects without zeros, in case of integrated suppliers B2B mappings add zeros to line items. -->
                                    <!--<xsl:value-of select="substring(@lineNumber,1,10)"/>-->
                                    <xsl:value-of select="substring(format-number(@lineNumber,'#'),1,10)"/>
                                    <!-- End of IG-43046 -->
                                </ID>
                                </xsl:if>
                                <ActionCode>
                                    <xsl:value-of select="$v_actionCode"/>
                                </ActionCode>
                                <xsl:variable name="v_acceptanceStatus">
                                    <xsl:choose>
                                        <xsl:when
                                            test="../../ApprovalRequest/AcceptanceItem/AcceptanceItemDetail/@approvedAction = 'update'"
                                            >
                                            <xsl:value-of select="'001'"/>
                                        </xsl:when>
                                        <xsl:when
                                            test="../../ApprovalRequest/AcceptanceItem/AcceptanceItemDetail/@approvedAction = 'replace'"
                                            >
                                            <xsl:value-of select="'002'"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:for-each select="DeviationReason">
                                    <xsl:if test="@value = 'priceDeviation'">
                                        <PriceDeviation>1</PriceDeviation>
                                        <UnitPrice>
                                            <Amount>
                                                <xsl:attribute name="currencyCode">

                                                  <xsl:value-of
                                                  select="../AcceptanceItemDetail/UnitPrice/Money/@currency"
                                                  />
                                                </xsl:attribute>
                                                  <xsl:value-of
                                                  select="../AcceptanceItemDetail/UnitPrice/Money"/>
                                            </Amount>
                                            <!-- Begin of IG-21059 Add  Base Quantity tag -->
                                            <xsl:for-each select="../../../ConfirmationRequest/ConfirmationItem">
                                                <xsl:if test="number(@lineNumber) = number($v_item)">       <!-- Ig-32856 -->
                                                    <xsl:if
                                                        test="
                                                        string-length(normalize-space(ConfirmationStatus[1]/ItemIn/ItemDetail/PriceBasisQuantity/@quantity)) > 0">
                                                        <BaseQuantity>
                                                            <xsl:attribute name="unitCode">
                                                                <xsl:value-of
                                                                    select="ConfirmationStatus[1]/ItemIn/ItemDetail/PriceBasisQuantity/UnitOfMeasure"
                                                                />
                                                            </xsl:attribute>
                                                            <xsl:value-of select="format-number(ConfirmationStatus[1]/ItemIn/ItemDetail/PriceBasisQuantity/@quantity, '0.000')"/>
                                                        </BaseQuantity>
                                                    </xsl:if>
                                                </xsl:if>
                                            </xsl:for-each>   
                                            <!-- End of IG-21059 Add  Base Quantity tag -->                                            
                                        </UnitPrice>
                                    </xsl:if>                                      
                                </xsl:for-each>
                                <!-- CI-1782 added Quantity & Date Deviation Reason & comments -->                                 
                                <xsl:for-each select="DeviationReason"> 
                                    <Deviations>
                                        <xsl:if test="string-length(normalize-space(@value)) > 0">
                                            <DeviationReason>
                                                <xsl:value-of select="@value"/>
                                            </DeviationReason>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(Comments)) > 0">
                                            <Comments>
                                                <xsl:attribute name="languageCode">
                                                    <xsl:value-of select="$v_deviationLang"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="Comments"/>
                                            </Comments>
                                        </xsl:if>
                                    </Deviations>                                     
                                </xsl:for-each>  
                                <!--        CI_1782 : Map the Supplier Part ID         -->                               
                                <!--        Multiple occurances of SupplierPart ID from Source ->  single occurance in Target     -->
                                <xsl:if
                                    test="string-length(normalize-space(../../ConfirmationRequest/ConfirmationItem[number(@lineNumber) = number($v_item)]/ConfirmationStatus[ItemIn/ItemID/SupplierPartID[normalize-space()]][1]/ItemIn/ItemID/SupplierPartID)) > 0">          <!-- Ig-32856 -->
                                    <SupplierPartID>
                                        <xsl:value-of
                                            select="substring(../../ConfirmationRequest/ConfirmationItem[number(@lineNumber) = number($v_item)]/ConfirmationStatus[ItemIn/ItemID/SupplierPartID[normalize-space()]][1]/ItemIn/ItemID/SupplierPartID,1,60)"
                                        />          <!-- Ig-32856 -->
                                    </SupplierPartID>
                                </xsl:if>
                                <ItemDetailApprovedAction>
                                    <xsl:value-of select="$v_acceptanceStatus"/>
                                </ItemDetailApprovedAction>
                                <xsl:for-each select="AcceptanceItemDetail/AcceptanceScheduleDetail">
                                    <ScheduleLine>
                                        <ID>
                                            <xsl:choose>
                                                <xsl:when test="exists(@lineNumber)">
                                                    <xsl:value-of select="substring(@lineNumber,1,10)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'0'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </ID>
                                        <ConfirmationStatus>
                                            <xsl:for-each select="../../../../ConfirmationRequest/ConfirmationItem">
                                                <xsl:if test="number(@lineNumber) = number($v_item)">                   <!-- Ig-32856 -->
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test="ConfirmationStatus/@type = 'accept'
                                                            or ConfirmationStatus/@type = 'allDetail'
                                                            or ConfirmationStatus/@type = 'backordered'">
                                                            <xsl:value-of select="'002'"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="'003'"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </ConfirmationStatus>
                                        <SchdLineApprovedAction>
                                            <xsl:choose>
                                                <xsl:when test="@approvedAction = 'update'"
                                                  >
                                                    <xsl:value-of select="'001'"/>
                                                </xsl:when>
                                                <xsl:when test="@approvedAction = 'new'"
                                                  >
                                                    <xsl:value-of select="'002'"/>
                                                </xsl:when>
                                                <xsl:when test="@approvedAction = 'delete'"
                                                  >
                                                    <xsl:value-of select="'003'"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="'004'"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </SchdLineApprovedAction>
                                        <Quantity>
                                            <xsl:value-of select="format-number(@quantity, '0.000')"
                                            />
                                        </Quantity>
                                        <!--Fill Delivery date-->
                                        <StartDate>
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date" select="@deliveryDate"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </StartDate>
                                    </ScheduleLine>
                                </xsl:for-each>
                                <!--</xsl:for-each>-->
                                <!--    CI_1782 : Map the Item AN Auto Generates Comments      -->                                 
                                <!--    Call Template to fill Item Comments     -->
                                <!--    IG-32900 :  added check condition to avoid population of empty comments tag>-->
                                <!--    IG-37992 :  Populate Item text>-->
                                <xsl:variable name="v_item_text">
                                    <xsl:for-each select="../../ConfirmationRequest/ConfirmationItem[number(@lineNumber) = number($v_item)]/ConfirmationStatus">
                                        <xsl:if test="string-length(normalize-space(Comments)) > 0" >
                                            <xsl:value-of select="'X'"/>    
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:if test="string-length(normalize-space(Comments)) > 0 or string-length(normalize-space($v_item_text)) > 0">
                                    <Comments>
                                        <xsl:call-template name="AutoCommentsFill">
                                            <xsl:with-param name="p_comments" select="Comments"/>
                                            <xsl:with-param name="p_lang" select="$v_lang"/>
                                            <xsl:with-param name="p_itemNumber" select="@lineNumber"/>
                                        </xsl:call-template>
                                        <!--    IG-37992 :  Populate Item text>-->                                     
                                        <xsl:for-each select="../../ConfirmationRequest/ConfirmationItem[number(@lineNumber) = number($v_item)]/ConfirmationStatus">
                                            <xsl:call-template name="CommentsFillProxyIn">
                                                <xsl:with-param name="p_comments" select="Comments"/>
                                                <xsl:with-param name="p_lang" select="$v_lang"/>
                                                <xsl:with-param name="p_itemNumber" select="ItemIn/@lineNumber"/>
                                                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                                                <xsl:with-param name="p_pd" select="$v_pd"/>
                                            </xsl:call-template>                                                           
                                        </xsl:for-each>
                                    </Comments>
                                </xsl:if> 
                            </Item>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- CI-1782 added Quantity & Date Deviation Reason & comments --> 
                            <xsl:variable name="v_deviationReason">
                                <xsl:copy-of select="DeviationReason"/>
                            </xsl:variable>
                            <!--    For AN Auto generated commentnts    -->
                            <xsl:variable name="v_autoComments">
                                <xsl:value-of select="Comments"/>
                            </xsl:variable>
                            <xsl:for-each select="../../ConfirmationRequest/ConfirmationItem">
                        <xsl:if test="number(@lineNumber) = number($v_item)">            <!-- Ig-32856 -->
                    <Item>
                        <ID>
                            <!-- Begin of IG-43046 -->
                            <!-- Pass line item numbers without zeros as ERP expects without zeros, in case of integrated suppliers B2B mappings add zeros to line items. -->
                            <!--<xsl:value-of select="@lineNumber"/>-->
                            <xsl:value-of select="substring(format-number(@lineNumber,'#'),1,10)"/>
                            <!-- End of IG-43046 -->
                        </ID>
                        <ActionCode>
                            <xsl:value-of select="$v_actionCode"/>
                        </ActionCode>
                        <UnitPrice>
                           <Amount>
                               <xsl:attribute name="currencyCode">
                                   <xsl:value-of
                                       select="ConfirmationStatus[1]/ItemIn/ItemDetail/UnitPrice/Money/@currency"/>
                               </xsl:attribute>
                               <xsl:value-of select="ConfirmationStatus[1]/ItemIn/ItemDetail/UnitPrice/Money"/>
                           </Amount>
                           <!-- Begin of IG-21059 Add  Base Quantity tag -->
                           <xsl:if test="string-length(normalize-space(ConfirmationStatus[1]/ItemIn/ItemDetail/PriceBasisQuantity/@quantity)) > 0">
                               <BaseQuantity>
                                   <xsl:attribute name="unitCode">
                                       <xsl:value-of
                                           select="ConfirmationStatus[1]/ItemIn/ItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                                   </xsl:attribute>
                                   <xsl:value-of select="format-number(ConfirmationStatus[1]/ItemIn/ItemDetail/PriceBasisQuantity/@quantity, '0.000')"/>
                               </BaseQuantity>
                           </xsl:if>   
                           <!-- End of IG-21059 Add  Base Quantity tag -->                            
                       </UnitPrice>
                        <!-- CI-1782 added Quantity & Date Deviation Reason & comments --> 
                        <xsl:for-each select="$v_deviationReason/DeviationReason">
                            <Deviations>
                                <xsl:if test="string-length(normalize-space(@value)) > 0">
                                    <DeviationReason>
                                        <xsl:value-of select="@value"/>
                                    </DeviationReason>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(Comments)) > 0">
                                    <Comments>
                                        <xsl:attribute name="languageCode">
                                            <xsl:value-of select="$v_deviationLang"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="Comments"/>
                                    </Comments>
                                </xsl:if>
                            </Deviations>
                        </xsl:for-each>  
                        <!--        CI_1782 : Map the Supplier Part ID         -->                               
                        <!--        Multiple occurances of SupplierPart ID from Source ->  single occurance in Target     -->
                        <xsl:if
                            test="string-length(normalize-space(ConfirmationStatus[ItemIn/ItemID/SupplierPartID[normalize-space()]][1]/ItemIn/ItemID/SupplierPartID)) > 0">
                            <SupplierPartID>
                                <xsl:value-of
                                    select="ConfirmationStatus[ItemIn/ItemID/SupplierPartID[normalize-space()]][1]/ItemIn/ItemID/SupplierPartID"
                                />
                            </SupplierPartID>
                        </xsl:if>                       
                       <xsl:for-each select="ConfirmationStatus">
                            <ScheduleLine>
                                <ID>
                                    <xsl:value-of select="position()"/>
                                </ID>
                                <ConfirmationStatus>
                                    <xsl:choose>
                                        <xsl:when test="@type = 'accept' or
                                            @type = 'allDetail' or @type = 'backordered'">
                                            <xsl:value-of select="'002'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'003'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </ConfirmationStatus>
                                <Quantity>
                                    <xsl:attribute name="unitCode">
                                        <xsl:value-of select="UnitOfMeasure"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="format-number(@quantity, '0.000')"/>
                                </Quantity>
                                <!--Fill Delivery date-->
                                <StartDate>
                                    <xsl:call-template name="ERPDateTime">
                                    <xsl:with-param name="p_date" select="@deliveryDate"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>
                                </StartDate>
                             </ScheduleLine>
                        </xsl:for-each>
                        <!--Call Template to fill Item Comments-->
                        <Comments>
                            <xsl:for-each select="ConfirmationStatus">
                            <xsl:call-template name="CommentsFillProxyIn">
                                <xsl:with-param name="p_comments" select="Comments"/>
                                <xsl:with-param name="p_lang" select="$v_lang"/>
                                <xsl:with-param name="p_itemNumber" select="ItemIn/@lineNumber"/>
                                <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                                <xsl:with-param name="p_pd" select="$v_pd"/>
                            </xsl:call-template>
                            </xsl:for-each>
                            <!--        CI_1782 : Map the Item AN Auto Generates Comments         -->   
                            <xsl:if test="string-length(normalize-space($v_autoComments)) > 0">                                
                                <xsl:call-template name="AutoCommentsFill">
                                    <xsl:with-param name="p_comments" select="$v_autoComments"/>
                                    <xsl:with-param name="p_lang" select="$v_lang"/>
                                    <xsl:with-param name="p_itemNumber" select="ItemIn/@lineNumber"/>
                                </xsl:call-template>  
                            </xsl:if>  
                        </Comments>
                    </Item>
                   </xsl:if>
                </xsl:for-each>
                </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- CI-2204 order ID Mapping -->
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/ConfirmationRequest/OrderReference[1]/@orderID))> 0">
                    <OrderID>
                        <xsl:value-of select="Payload/cXML/Request/ConfirmationRequest/OrderReference[1]/@orderID"/>
                    </OrderID>
                </xsl:if>
            </OrderConfirmationApproval>
            <!--            Comments-->
            <!--Call Template to fill Comments-->
            <HeaderComments>
                <xsl:call-template name="CommentsFillProxyIn">
                    <xsl:with-param name="p_comments" select="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/Comments"/>
                    <xsl:with-param name="p_lang" select="$v_lang"/>
                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                </xsl:call-template>
                <!--        CI_1782 : Map the Header AN Auto Generates Comments         -->      
                <xsl:if test="string-length(normalize-space(Payload/cXML/Request/ApprovalRequest/ApprovalRequestHeader/Comments)) > 0">
                    <xsl:call-template name="AutoCommentsFill">
                        <xsl:with-param name="p_comments" select="Payload/cXML/Request/ApprovalRequest/ApprovalRequestHeader/Comments"/>
                        <xsl:with-param name="p_lang" select="$v_lang"/>
                    </xsl:call-template>   
                </xsl:if>
            </HeaderComments>
            <!--          IG-32433 Added Item level attachments Mappings           -->
            <xsl:variable name="v_final">
                <xsl:for-each-group select="Payload/cXML/Request/ConfirmationRequest/ConfirmationItem/ConfirmationStatus/Comments/Attachment" group-by="URL">
                    
                    <xsl:for-each select="current-group()">
                        <xsl:if test="position() = 1">
                            <lineNumber>  
                                <xsl:value-of select="../../../@lineNumber"/>                                   
                            </lineNumber>
                            <URL>
                                <xsl:value-of select="URL"/>
                            </URL>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each-group>
            </xsl:variable>  
            <xsl:if test="AttachmentList/Attachment">
                <xsl:call-template name="InboundMultiAttProxy_Common">              
                    <xsl:with-param name="headerAtt"
                        select="Payload/cXML/Request/ConfirmationRequest/ConfirmationHeader/Comments/Attachment/URL"/>
                    <xsl:with-param name="lineReference"
                        select="
                        $v_final/lineNumber
                        | $v_final/URL  "/>                  
                </xsl:call-template>
            </xsl:if> 
        </n0:OrdConfAppReqMsg>
    </xsl:template>
    <!--    CI_1782 : Map the AN Auto Generates Comments     -->       
    <!--    Template for AN Auto Generates Comments Filling   -->
    <xsl:template name="AutoCommentsFill">
        <xsl:param name="p_comments"/>
        <xsl:param name="p_lang"/>
        <xsl:param name="p_itemNumber"/>
        <Item>
            <TextID>
                <xsl:value-of select="'AN00'"/>
            </TextID>
            <TextLang>
                <xsl:value-of select="$p_lang"/>
            </TextLang>
            <xsl:if test="$p_itemNumber != ''">
                <ItemNumber>
                    <xsl:value-of select="$p_itemNumber"/>
                </ItemNumber>
            </xsl:if>
            <xsl:call-template name="CommentSplitProxy">
                <xsl:with-param name="p_str" select="$p_comments"/>
                <xsl:with-param name="p_strlen" select="132.0"/>
            </xsl:call-template>
        </Item>
    </xsl:template>   
</xsl:stylesheet>
