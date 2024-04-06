<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:n0="http://sap.com/xi/ARBCIG1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anReceiverID"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:variable name="v_path" select="Combined/Payload/cXML/Message/ProductReplenishmentMessage"/>
    <!-- Multy ERP is enabled then pass the System id coming from AN if Not pass Default sysID from CIG-->
    <xsl:variable name="v_sysid">
        <xsl:call-template name="MultiErpSysIdIN">
            <xsl:with-param name="p_ansysid"
                select="Combined/Payload/cXML/Header/From/Credential[@domain = 'SystemID']/Identity"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$v_sysid"/>
            <xsl:with-param name="p_ansupplierid" select="$anReceiverID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--    Default language-->
    <xsl:variable name="v_lang">
        <xsl:choose>
            <xsl:when test="$v_path/Comments/@xml:lang != ''">
                <xsl:value-of select="$v_path/Comments/@xml:lang"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="FillDefaultLang">
                    <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                    <xsl:with-param name="p_pd" select="$v_pd"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="Combined">
        <n0:ProductReplenishment>
            <MessageHeader>
                <ID>
                    <xsl:attribute name="schemeID">
                        <xsl:value-of select="$v_path/ProductReplenishmentHeader/@messageID"/>
                    </xsl:attribute>
                </ID>
                <CreationDateTime>
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date"
                                select="$v_path/ProductReplenishmentHeader/@creationDate"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
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
            <ProductReplenishmentHeader>
                <CreationDate>
                    <xsl:variable name="v_erpdate">
                        <xsl:call-template name="ERPDateTime">
                            <xsl:with-param name="p_date"
                                select="$v_path/ProductReplenishmentHeader/@creationDate"/>
                            <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <!--Convert the final date into SAP format is 'YYYY-MM-DD'-->
                    <xsl:value-of select="substring($v_erpdate, 1, 10)"/>
                </CreationDate>
                <Vendor>
                    <xsl:value-of
                        select="/Combined/Payload/cXML/Header/From/Credential[@domain = 'VendorID']/Identity"
                    />
                </Vendor>
                <ProcessType>
                    <xsl:value-of select="$v_path/ProductReplenishmentHeader/@processType"/>
                </ProcessType>
            </ProductReplenishmentHeader>
            <xsl:for-each select="$v_path/ProductReplenishmentDetails">
                <ProductReplenishmentDetails>
                    <SupplierPartID>
                        <xsl:value-of select="ItemID/SupplierPartID"/>
                    </SupplierPartID>
                    <BuyerPartID>
                        <xsl:value-of select="ItemID/BuyerPartID"/>
                    </BuyerPartID>
                    <Plant>
                        <xsl:value-of select="Contact/IdReference/@identifier"/>
                    </Plant>
                    <Status>
                        <xsl:value-of select="ReferenceDocumentInfo/@status"/>
                    </Status>
                    <DocumentType>
                        <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo/@documentType"/>
                    </DocumentType>
                    <LineNumber>
                        <xsl:value-of select="ReferenceDocumentInfo/@lineNumber"/>
                    </LineNumber>
                    <DocumentID>
                        <xsl:value-of select="ReferenceDocumentInfo/DocumentInfo/@documentID"/>
                    </DocumentID>
                     <!-- CI-1779 - Begin -->
                    <xsl:for-each select="Characteristic">
                        <Characteristic>
                            <Domain>
                                <xsl:value-of select="@domain"/>
                            </Domain>
                            <Value>
                                <xsl:value-of select="@value"/>
                            </Value>
                        </Characteristic>
                    </xsl:for-each>
                    <xsl:if test="string-length(normalize-space(Inventory)) > 0">
                        <Inventory>
                            <xsl:if
                                test="string-length(normalize-space(Inventory/SubcontractingStockInTransferQuantity/@quantity)) > 0">

                                <SubcontractingStockInTransferQuantity>

                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/SubcontractingStockInTransferQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/SubcontractingStockInTransferQuantity/UnitOfMeasure"/>

                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="Inventory/SubcontractingStockInTransferQuantity/@quantity"
                                    />
                                </SubcontractingStockInTransferQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(Inventory/UnrestrictedUseQuantity/@quantity)) > 0">
                                <UnrestrictedUseQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/UnrestrictedUseQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/UnrestrictedUseQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="Inventory/UnrestrictedUseQuantity/@quantity"/>
                                </UnrestrictedUseQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(Inventory/BlockedQuantity/@quantity)) > 0">
                                <BlockedQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/BlockedQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/BlockedQuantity/UnitOfMeasure"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="Inventory/BlockedQuantity/@quantity"/>
                                </BlockedQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(Inventory/QualityInspectionQuantity/@quantity)) > 0">
                                <QualityInspectionQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/QualityInspectionQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/QualityInspectionQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="Inventory/QualityInspectionQuantity/@quantity"/>
                                </QualityInspectionQuantity>
                            </xsl:if>


                            <xsl:if
                                test="string-length(normalize-space(Inventory/PromotionQuantity/@quantity)) > 0">
                                <PromotionQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/PromotionQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/PromotionQuantity/UnitOfMeasure"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="Inventory/PromotionQuantity/@quantity"/>
                                </PromotionQuantity>
                            </xsl:if>


                            <xsl:if
                                test="string-length(normalize-space(Inventory/StockInTransferQuantity/@quantity)) > 0">
                                <StockInTransferQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/StockInTransferQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/StockInTransferQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="Inventory/StockInTransferQuantity/@quantity"/>
                                </StockInTransferQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(Inventory/IncrementQuantity/@quantity)) > 0">
                                <IncrementQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/IncrementQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/IncrementQuantity/UnitOfMeasure"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="Inventory/IncrementQuantity/@quantity"/>
                                </IncrementQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(Inventory/RequiredMinimumQuantity/@quantity)) > 0">
                                <RequiredMinimumQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/RequiredMinimumQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/RequiredMinimumQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="Inventory/RequiredMinimumQuantity/@quantity"/>
                                </RequiredMinimumQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(Inventory/RequiredMaximumQuantity/@quantity)) > 0">
                                <RequiredMaximumQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/RequiredMaximumQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/RequiredMaximumQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>

                                    <xsl:value-of
                                        select="Inventory/RequiredMaximumQuantity/@quantity"/>
                                </RequiredMaximumQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(Inventory/StockOnHandQuantity/@quantity)) > 0">
                                <StockOnHandQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/StockOnHandQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/StockOnHandQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="Inventory/StockOnHandQuantity/@quantity"/>
                                </StockOnHandQuantity>
                            </xsl:if>


                            <xsl:if
                                test="string-length(normalize-space(Inventory/WorkInProcessQuantity/@quantity)) > 0">
                                <WorkInProcessQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/WorkInProcessQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/WorkInProcessQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>

                                    <xsl:value-of select="Inventory/WorkInProcessQuantity/@quantity"
                                    />
                                </WorkInProcessQuantity>
                            </xsl:if>



                            <xsl:if
                                test="string-length(normalize-space(Inventory/IntransitQuantity/@quantity)) > 0">
                                <IntransitQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/IntransitQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/IntransitQuantity/UnitOfMeasure"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="Inventory/IntransitQuantity/@quantity"/>
                                </IntransitQuantity>
                            </xsl:if>


                            <xsl:if
                                test="string-length(normalize-space(Inventory/ScrapQuantity/@quantity)) > 0">
                                <ScrapQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/ScrapQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/ScrapQuantity/UnitOfMeasure"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="Inventory/ScrapQuantity/@quantity"/>
                                </ScrapQuantity>
                            </xsl:if>


                            <xsl:if test="string-length(normalize-space(Inventory/OrderQuantity/@minimum)) > 0 or
                                    string-length(normalize-space(Inventory/OrderQuantity/@maximum)) > 0">
                                <OrderQuantity>
                                    
                                    
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/OrderQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="Inventory/OrderQuantity/UnitOfMeasure"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    
                                  
                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/OrderQuantity/@minimum)) > 0">
                                        <Minimum>
                                            <xsl:value-of select="Inventory/OrderQuantity/@minimum"
                                            />
                                        </Minimum>
                                    </xsl:if>

                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/OrderQuantity/@maximum)) > 0">
                                        <Maximum>
                                            <xsl:value-of select="Inventory/OrderQuantity/@maximum"
                                            />
                                        </Maximum>
                                    </xsl:if>
                                 
                                </OrderQuantity>
                            </xsl:if>


                            <xsl:if test="string-length(normalize-space(Inventory/DaysOfSupply/@minimum)) > 0 or
                                    string-length(normalize-space(Inventory/DaysOfSupply/@maximum)) > 0">

                                <DaysOfSupply>

                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/DaysOfSupply/@minimum)) > 0">
                                        <Minimum>
                                            <xsl:value-of select="Inventory/DaysOfSupply/@minimum"/>
                                        </Minimum>
                                    </xsl:if>

                                    <xsl:if
                                        test="string-length(normalize-space(Inventory/DaysOfSupply/@maximum)) > 0">
                                        <Maximum>
                                            <xsl:value-of select="Inventory/DaysOfSupply/@maximum"/>
                                        </Maximum>
                                    </xsl:if>
                                </DaysOfSupply>
                            </xsl:if>


                        </Inventory>
                    </xsl:if>

                    <xsl:if test="string-length(normalize-space(ConsignmentInventory)) > 0">
                        <ConsignmentInventory>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/SubcontractingStockInTransferQuantity/@quantity)) > 0">
                                <SubcontractingStockInTransferQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/SubcontractingStockInTransferQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/SubcontractingStockInTransferQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/SubcontractingStockInTransferQuantity/@quantity"
                                    />
                                </SubcontractingStockInTransferQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/UnrestrictedUseQuantity/@quantity)) > 0">
                                <UnrestrictedUseQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/UnrestrictedUseQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/UnrestrictedUseQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/UnrestrictedUseQuantity/@quantity"
                                    />
                                </UnrestrictedUseQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/BlockedQuantity/@quantity)) > 0">
                                <BlockedQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/BlockedQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/BlockedQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/BlockedQuantity/@quantity"/>
                                </BlockedQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/QualityInspectionQuantity/@quantity)) > 0">
                                <QualityInspectionQuantity>
                                    <!-- IG-32544 fixed typo on ConsignmentInventory-->
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/QualityInspectionQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/QualityInspectionQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/QualityInspectionQuantity/@quantity"
                                    />
                                </QualityInspectionQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/PromotionQuantity/@quantity)) > 0">
                                <PromotionQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/PromotionQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/PromotionQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/PromotionQuantity/@quantity"/>
                                </PromotionQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/StockInTransferQuantity/@quantity)) > 0">
                                <StockInTransferQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/StockInTransferQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/StockInTransferQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/StockInTransferQuantity/@quantity"
                                    />
                                </StockInTransferQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/IncrementQuantity/@quantity)) > 0">
                                <IncrementQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/IncrementQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/IncrementQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/IncrementQuantity/@quantity"/>
                                </IncrementQuantity>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/RequiredMinimumQuantity/@quantity)) > 0">
                                <RequiredMinimumQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/RequiredMinimumQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/RequiredMinimumQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/RequiredMinimumQuantity/@quantity"
                                    />
                                </RequiredMinimumQuantity>
                            </xsl:if>


                            <xsl:if
                                test="string-length(normalize-space(ConsignmentInventory/RequiredMaximumQuantity/@quantity)) > 0">
                                <RequiredMaximumQuantity>
                                    <xsl:if
                                        test="string-length(normalize-space(ConsignmentInventory/RequiredMaximumQuantity/UnitOfMeasure)) > 0">
                                        <xsl:attribute name="unitCode">
                                            <xsl:value-of
                                                select="ConsignmentInventory/RequiredMaximumQuantity/UnitOfMeasure"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of
                                        select="ConsignmentInventory/RequiredMaximumQuantity/@quantity"
                                    />
                                </RequiredMaximumQuantity>
                            </xsl:if>
                        </ConsignmentInventory>
                    </xsl:if>
                    <!-- CI-1779 - End -->
                    <xsl:for-each select="ReplenishmentTimeSeries">
                        <ReplenishmentTimeSeries>
                            <Type>
                                <xsl:value-of select="@type"/>
                            </Type>
                            <!-- CI-1779 - Begin -->
                            <xsl:if test="@type = 'custom'">
                                <CustomType>
                                    <xsl:value-of select="@customType"/>
                                </CustomType>
                            </xsl:if>
                            <!-- CI-1779 - End -->
                            <xsl:for-each select="TimeSeriesDetails">
                            <!-- IG-37862 - Populate the below tag only if Quantity is greater than 0 and if Quantity is equal to 0
                                 then should not populate the tag so that in ERP particular schedule line would get deleted -->
                              <xsl:if test="string-length(normalize-space(TimeSeriesQuantity/@quantity))>0 or normalize-space($v_path/ProductReplenishmentHeader/@processType) != 'SMI'">  
                             <!-- Remove the comma if quanity contains ','-->
                                    <xsl:variable name="v_qty">
                                        <xsl:value-of select="translate(TimeSeriesQuantity/@quantity,',', '')" />
                                    </xsl:variable>   
                                  <xsl:if test= "normalize-space($v_path/ProductReplenishmentHeader/@processType) != 'SMI' or $v_qty > 0">             <!-- IG-40346 -->                     
                                <TimeSeriesDetails>
                                    <StartDate>
                                        <xsl:variable name="v_erpdate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                    select="Period/@startDate"/>
                                                <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--Convert the final date into SAP format is 'YYYY-MM-DD'-->
                                        <xsl:value-of select="substring($v_erpdate, 1, 10)"/>
                                    </StartDate>
                                    <StartTime>
                                        <xsl:variable name="v_erpdate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                    select="Period/@startDate"/>
                                                <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:value-of select="substring($v_erpdate, 12, 8)"/>
                                    </StartTime>
                                    <EndDate>
                                        <xsl:variable name="v_erpdate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                    select="Period/@endDate"/>
                                                <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <!--Convert the final date into SAP format is 'YYYY-MM-DD'-->
                                        <xsl:value-of select="substring($v_erpdate, 1, 10)"/>
                                    </EndDate>
                                    <EndTime>
                                        <xsl:variable name="v_erpdate">
                                            <xsl:call-template name="ERPDateTime">
                                                <xsl:with-param name="p_date"
                                                    select="Period/@endDate"/>
                                                <xsl:with-param name="p_timezone"
                                                    select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        <xsl:value-of select="substring($v_erpdate, 12, 8)"/>
                                    </EndTime>
                                    <!-- IG-40346 populating the quantity tag only when there is a value for quantity as empty tag fails in ERP  -->
                                    <xsl:if
                                        test="string-length(normalize-space($v_qty)) > 0">
                                        <!-- IG-40346 --> 
                                    <Quantity>
                                        <xsl:attribute name="unitCode">
                                            <xsl:call-template name="UOMTemplate_In">
                                                <xsl:with-param name="p_UOMinput"
                                                    select="TimeSeriesQuantity/UnitOfMeasure"/>
                                                <xsl:with-param name="p_anERPSystemID"
                                                    select="$v_sysid"/>
                                                <xsl:with-param name="p_anSupplierANID"
                                                    select="$anReceiverID"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:value-of select="$v_qty"/>
                                    </Quantity>
                                    </xsl:if>
                                    <!-- CI-1779 - Begin -->
                                    <xsl:for-each select="IdReference">
                                        <IdReference>
                                            <Identifier>
                                                <xsl:value-of select="@identifier"/>
                                            </Identifier>
                                            <Domain>
                                                <xsl:value-of select="@domain"/>
                                            </Domain>
                                        </IdReference>                                       
                                    </xsl:for-each>
                                    <!-- CI-1779 - End -->
                                </TimeSeriesDetails>
                               </xsl:if> 
                              </xsl:if>                                    
                            </xsl:for-each>
                        </ReplenishmentTimeSeries>
                    </xsl:for-each>
                </ProductReplenishmentDetails>
            </xsl:for-each>
            <xsl:if test="$v_path/ProductReplenishmentDetails/Comments">
                <!--       Comments code     -->
                <AribaComment>
                    <xsl:call-template name="CommentsFillProxyIn">
                        <xsl:with-param name="p_comments"
                            select="$v_path/ProductReplenishmentDetails/Comments"/>
                        <xsl:with-param name="p_lang" select="$v_lang"/>
                        <xsl:with-param name="p_doctype" select="$anSourceDocumentType"/>
                        <xsl:with-param name="p_pd" select="$v_pd"/>
                    </xsl:call-template>
                </AribaComment>
            </xsl:if>
            <!--       Attachment code     -->
            <xsl:call-template name="InboundAttach">
                <xsl:with-param name="lineReference"
                    select="
                    $v_path/ProductReplenishmentDetails/ReferenceDocumentInfo/@lineNumber
                    | $v_path/ProductReplenishmentDetails/Comments/Attachment/URL"
                />
            </xsl:call-template>            
        </n0:ProductReplenishment>
    </xsl:template>
</xsl:stylesheet>
