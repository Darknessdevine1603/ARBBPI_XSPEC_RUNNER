<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:n0="http://sap.com/xi/ARBCIG1" exclude-result-prefixes="#all"
    version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone" />
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:variable name="v_Date" select="n0:ProductActivityMessage/Header/CreationDate"/>
    <xsl:variable name="v_Time" select="n0:ProductActivityMessage/Header/EnterTime"/>
    <xsl:variable name="v_messageId" select="n0:ProductActivityMessage/Header/MessageID"/>
    <xsl:variable name="v_processType" select="n0:ProductActivityMessage/Header/ProcessType"/>
    <xsl:variable name="v_plant_timezone" select="n0:ProductActivityMessage/Header/TimeZone"/>
    <xsl:variable name="v_date">
        <xsl:if test="string-length(normalize-space($v_Date)) > 0">
            <xsl:call-template name="ANDateTime">
                <xsl:with-param name="p_date"
                    select="replace(substring($v_Date,1,10),'-','')"/>
                <xsl:with-param name="p_time"
                    select="replace(substring($v_Time,1,8),':','')"/>
                <xsl:with-param name="p_timezone"
                    select="$anERPTimeZone"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>       
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <!--    Default language-->
    <xsl:variable name="v_lang">
        <xsl:call-template name="FillDefaultLang">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <!--  IG-30341 Begin-->
    <xsl:variable name="v_defaultSupplierPartID">
        <xsl:call-template name="defaultSupplierPartID">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_pd" select="$v_pd"/>
        </xsl:call-template>
    </xsl:variable>
    <!--  IG-30341 End --> 
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>
    <xsl:template match="n0:ProductActivityMessage">
        <Combined>
            <Payload>
                <cXML>
                    <xsl:attribute name="payloadID"> 
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space($v_messageId)) > 0">
                                    <xsl:choose>
                                        <xsl:when test="$v_processType = 'SMI'">
                                            <xsl:value-of select="$v_messageId"/>
                                        </xsl:when>
                                        <xsl:when test="$v_processType = 'Forecast'">
                                            <xsl:value-of select="$v_messageId"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$anPayloadID"/>    
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$anPayloadID"/>  
                                </xsl:otherwise>
                            </xsl:choose>
                    </xsl:attribute>                                                                    
                    <xsl:attribute name="timestamp">
                        <xsl:variable name="curDate">
                            <xsl:value-of select="current-dateTime()"/>
                        </xsl:variable>
                        <xsl:value-of select="concat(substring(string(current-date()), 1, 10), 'T', substring(string(current-time()), 1, 8), $anERPTimeZone)" />   <!-- IG-32248 -->
                    </xsl:attribute>
                    <Header>
                        <From>
                            <xsl:call-template name="MultiERPTemplateOut">
                                <xsl:with-param name="p_anIsMultiERP" select="$anIsMultiERP"/>
                                <xsl:with-param name="p_anERPSystemID" select="$anERPSystemID"/>
                            </xsl:call-template>
                            <Credential domain="NetworkID">
                                <Identity>
                                    <xsl:value-of select="$anSupplierANID"/>
                                </Identity>
                            </Credential>
                            <!--End Point Fix for CIG-->
                            <Credential>
                                <xsl:attribute name="domain">
                                    <xsl:value-of select="'EndPointID'"/>
                                </xsl:attribute>
                                <Identity>CIG</Identity>
                            </Credential> 
                        </From>
                        <To>
                            <Credential domain="VendorID">
                                <Identity>
                                    <xsl:value-of select="Header/VendorID"/>
                                </Identity>
                            </Credential>
                        </To>
                        <Sender>
                            <Credential domain="NetworkID">
                                <Identity>
                                    <xsl:value-of select="$anProviderANID"/>
                                </Identity>
                            </Credential>
                            <UserAgent>
                                <xsl:value-of select="'Ariba Supplier'"/>
                            </UserAgent>
                        </Sender>
                    </Header>
                    <Message>
                        <xsl:choose>
                            <xsl:when test="$anEnvName = 'PROD'">
                                <xsl:attribute name="deploymentMode">
                                    <xsl:value-of select="'production'"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="deploymentMode">
                                    <xsl:value-of select="'test'"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <ProductActivityMessage>
                            <ProductActivityHeader>
                                <xsl:attribute name="messageID">
                                    <xsl:value-of select="Header/MessageID"/>
                                </xsl:attribute>
                                <xsl:attribute name="creationDate">
                                    <xsl:value-of select="$v_date"/>
                                </xsl:attribute>
                                <xsl:if test="Header/ProcessType">
                                    <xsl:attribute name="processType">
<!--                                    As the ProcessType field is of type CHAR10, ERP will send CONS for Consignment     -->
                                        <xsl:choose>
                                            <xsl:when test="Header/ProcessType = 'CONS'">
                                                <xsl:value-of select="'Consignment'"/>
                                            </xsl:when>
                                           <!-- Begin: CI-2009 -->
                                              <xsl:when test="Header/ProcessType = 'StockInv'">
                                                  <xsl:value-of select="'StockInventory'"/>
                                            </xsl:when>
                                            <!-- End: CI-2009 -->
                                            <xsl:otherwise>
                                                <xsl:value-of select="Header/ProcessType"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </xsl:if>
                            </ProductActivityHeader>
                            <!-- IG-16477 Begin -->
                            <!-- Changes for material classification and other chages to be done only for SMI and Forecast -->
                            <xsl:variable name="v_processType_SMIFore">
                                <xsl:if test="upper-case(Header/ProcessType) = 'SMI' or upper-case(Header/ProcessType) = 'FORECAST'">
                                    <xsl:value-of select="Header/ProcessType"/>
                                </xsl:if>
                            </xsl:variable>
                            <!-- IG-16477 End -->
                            <xsl:for-each select="Header/ProductDetails">
                                <ProductActivityDetails>
                                    <ItemID>
                                        <SupplierPartID>
                                            <!-- Begin of IG-30341-->
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(ItemID/SupplierPartID)) > 0">
                                                    <xsl:value-of select="ItemID/SupplierPartID"/>  
                                                </xsl:when>
                                                <xsl:otherwise>                                                  
                                                    <xsl:value-of select="$v_defaultSupplierPartID"/>      
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <!-- End of IG-30341-->  
                                        </SupplierPartID>
                                        <BuyerPartID>
                                            <xsl:value-of select="ItemID/BuyerPartID"/>
                                        </BuyerPartID>
                                        <!-- IG-16477 Begin -->                                        
                                        <xsl:if test="ItemID/EAN_UPC_Number and $v_processType_SMIFore">
                                            <IdReference domain ='EAN'>
                                                <xsl:attribute name="identifier">
                                                    <xsl:value-of select="ItemID/EAN_UPC_Number"/>
                                                </xsl:attribute>
                                            </IdReference>
                                        </xsl:if>
                                        <!-- IG-16477 End -->
                                    </ItemID>
                                    <Description>
                                        <!-- Language conversion to be taken from pd -->
                                        <xsl:call-template name="FillLangOut">
                                            <xsl:with-param name="p_spras_iso"
                                                select="ItemID/Description/@languageCode"/>
                                            <xsl:with-param name="p_lang" select="$v_lang"/>
                                        </xsl:call-template>
                                        <xsl:value-of select="ItemID/Description"/>
                                    </Description>
                                    <xsl:for-each select="ProductHierarchy/Hierarchy">
                                        <Classification>
                                            <xsl:attribute name="domain">
                                                <xsl:value-of select="@Level"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="."/>
                                        </Classification>     
                                    </xsl:for-each>
                                    <!-- IG-16477 Begin -->
                                    <xsl:if test="$v_processType_SMIFore">
                                        <xsl:if test="ItemID/MaterialGroup">
                                            <Classification domain ='ERPCommodityCode'>
                                                <xsl:value-of select="ItemID/MaterialGroup"/>
                                            </Classification>
                                        </xsl:if>
                                        <xsl:if test="ItemID/MaterialGroupDescription">
                                            <Classification domain ='ERPCommodityCodeDescription'>
                                                <xsl:value-of select="ItemID/MaterialGroupDescription"/>
                                            </Classification>
                                        </xsl:if>    
                                    </xsl:if>                     
                                    <!-- IG-16477 End -->
                                    <xsl:if test="SerialNumber">
                                        <SerialNumberInfo>
                                            <xsl:attribute name="requiresSerialNumber" select="'yes'"/>
                                            <xsl:attribute name="type" select="'list'"/>
                                            <xsl:for-each select="SerialNumber">
                                                <SerialNumber>
                                                    <xsl:value-of select="SerialID"/>
                                                </SerialNumber>
                                            </xsl:for-each>
                                        </SerialNumberInfo>
                                    </xsl:if>
                                    <xsl:if test="ItemID/Leadtime">
                                        <LeadTime>
                                            <xsl:value-of select="ItemID/Leadtime"/>
                                        </LeadTime>
                                    </xsl:if>
                                    <xsl:if test="PlannedAcceptanceDays != ''">
                                        <PlannedAcceptanceDays>
                                            <xsl:value-of select="PlannedAcceptanceDays"/>
                                        </PlannedAcceptanceDays>
                                    </xsl:if>
                                    <!-- IG-16477 Begin -->
                                    <xsl:if test="$v_processType_SMIFore">
                                        <xsl:if test="ItemID/ManufacturerPartID">
                                            <ManufacturerPartID>
                                                <xsl:value-of select="ItemID/ManufacturerPartID"/>
                                            </ManufacturerPartID>
                                        </xsl:if>
                                        <xsl:if test="ItemID/ManufacturerName">
                                            <ManufacturerName>                                           
                                                <xsl:call-template name="FillLangOut">
                                                    <xsl:with-param name="p_spras_iso"
                                                        select="ItemID/ManufacturerName/@languageCode"/>
                                                    <xsl:with-param name="p_lang" select="$v_lang"/>
                                                </xsl:call-template>
                                                <xsl:value-of select="ItemID/ManufacturerName"/>
                                            </ManufacturerName>
                                        </xsl:if>
                                    </xsl:if>
                                    <!-- IG-16477 End -->
                                    <xsl:for-each select="ReferenceDocumentInfo">
                                        <ReferenceDocumentInfo>
                                            <xsl:attribute name="lineNumber">
                                                <xsl:value-of select="lineNumber"/>
                                            </xsl:attribute>
                                            <xsl:if test="exists(status) or status != ''">
                                            <xsl:attribute name="status">
                                                <xsl:value-of select="status"/>
                                            </xsl:attribute>
                                            </xsl:if>
                                            <DocumentInfo>
                                                <xsl:attribute name="documentID">
                                                  <xsl:value-of select="documentID"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="documentType">
                                                  <xsl:value-of select="documentType"/>
                                                </xsl:attribute>
                                            </DocumentInfo>
                                        </ReferenceDocumentInfo>
                                    </xsl:for-each>
                                    <!-- Begin of changes for CI-1779 : Custom characteristic -->
                                    <xsl:for-each select="ItemID/Characteristic">
                                        <Characteristic>
                                            <xsl:attribute name="domain">
                                                <xsl:value-of select="Domain"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="Value"/>
                                            </xsl:attribute> 
                                        </Characteristic>
                                    </xsl:for-each>
                                    <!-- End of changes for CI-1779 : Custom characteristic -->
                                    <xsl:if test="Batch">
                                    <Batch>
                                        <xsl:if test="Batch/ProductionDate != ''">
                                            <xsl:attribute name="productionDate">
                                                <xsl:value-of select="Batch/ProductionDate"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="Batch/ExpirationDate != ''">
                                            <xsl:attribute name="expirationDate">
                                                <xsl:value-of select="Batch/ExpirationDate"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:if test="Batch/InspectionDate != ''">
                                            <xsl:attribute name="inspectionDate">
                                                <xsl:value-of select="Batch/ExpirationDate"/>
                                            </xsl:attribute>
                                        </xsl:if>                                        
                                        <xsl:if test="Batch/OrigincountryCode != ''">
                                            <xsl:attribute name="originCountryCode">
                                                <xsl:value-of select="Batch/OrigincountryCode"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <BuyerBatchID>
                                            <xsl:value-of select="Batch/@BatchID"/>
                                        </BuyerBatchID>
                                        <xsl:if test="Batch/@SupplierBatchID != ''">
                                            <SupplierBatchID>
                                                <xsl:value-of select="Batch/@SupplierBatchID"/>
                                            </SupplierBatchID>
                                        </xsl:if>
                                        <PropertyValuation>
                                            <PropertyReference>
                                                <xsl:for-each select="Batch/PropertyIDRef">
                                                  <IdReference>
                                                  <xsl:attribute name="identifier">
                                                  <xsl:value-of select="Identifier"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="domain">
                                                  <xsl:value-of select="Domain"/>
                                                  </xsl:attribute>
                                                  </IdReference>
                                                </xsl:for-each>
                                            </PropertyReference>
                                        </PropertyValuation>
                                    </Batch>
                                    </xsl:if>
                                    <xsl:for-each select="Contact">
                                        <Contact>
                                            <xsl:attribute name="role">
                                                <xsl:value-of select="Role"/>
                                            </xsl:attribute>
                                            <xsl:if test="not(Role = 'BuyerPlannerCode')">
                                            <xsl:attribute name="addressID">
                                                <xsl:value-of select="AddressID"/>
                                            </xsl:attribute>
                                            </xsl:if>
                                            <Name>
                                                <!-- Language conversion to be taken from pd -->
                                                <xsl:call-template name="FillLangOut">
                                                    <xsl:with-param name="p_spras_iso"
                                                  select="Name/@languageCode"/>
                                                  <xsl:with-param name="p_lang" select="$v_lang"/>
                                                </xsl:call-template>
                                                <xsl:value-of select="Name"/>
                                            </Name>
                                            <xsl:if test="not(Role = 'BuyerPlannerCode')">
                                            <PostalAddress>
                                                <DeliverTo>
                                                  <xsl:value-of select="Deliverto"/>
                                                </DeliverTo>
                                                <Street>
                                                  <xsl:value-of select="Street"/>
                                                </Street>
                                                <City>
                                                  <xsl:if test="CityCode != ''">
                                                  <xsl:attribute name="cityCode">
                                                  <xsl:value-of select="CityCode"/>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:value-of select="City"/>
                                                </City>
                                                <State>
                                                  <xsl:attribute name="isoStateCode">
                                                  <xsl:value-of select="IsoStatecode"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="State"/>
                                                </State>
                                                <Country>
                                                  <xsl:attribute name="isoCountryCode">
                                                  <xsl:value-of select="IsoCountrycode"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="Country"/>
                                                </Country>
                                            </PostalAddress>
                                            </xsl:if>
                                            <IdReference>
                                                <xsl:attribute name="identifier">
                                                  <xsl:value-of select="PlantID"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="domain">
                                                  <xsl:value-of select="Role"/>
                                                </xsl:attribute>
                                                <Description>
                                                  <!-- Language conversion to be taken from pd -->
                                                  <xsl:call-template name="FillLangOut">
                                                      <xsl:with-param name="p_spras_iso"
                                                  select="Name/@languageCode"/>
                                                  <xsl:with-param name="p_lang" select="$v_lang"/>
                                                  </xsl:call-template>
                                                  <xsl:value-of select="Name"/>
                                                </Description>
                                            </IdReference>
                                        </Contact>
                                    </xsl:for-each>
                                    <xsl:if test="Inventory or SMIInventory or StockInventory">
                                        <Inventory>
                                            <xsl:if test="string-length(normalize-space(Inventory/Quantity)) > 0">
                                                <SubcontractingStockInTransferQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                      <xsl:when test="string-length(normalize-space(Inventory/Quantity)) > 0">
                                                  <xsl:value-of select="Inventory/Quantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="Inventory/UoM"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>

                                                </SubcontractingStockInTransferQuantity>
                                            </xsl:if>
                                            <!-- Begin : CI-2009: loop over new table stockinventory which contains Unrestricted, 
                                            transit and intrasnit CC  -->                        
                                            <xsl:if test="$v_processType = 'StockInv'">    
                                              <xsl:for-each select="StockInventory">
                                                <xsl:choose>
                                                    <xsl:when test="StockType = 'Unrestricted' and string-length(normalize-space(Quantity)) > 0"> 
                                                    <UnrestrictedUseQuantity>
                                                        <xsl:attribute name="quantity">
                                                          <xsl:value-of select="Quantity"/>                                                          
                                                        </xsl:attribute>        
                                                        <xsl:if test="string-length(normalize-space(Quantity/@unitCode)) > 0">   
                                                        <UnitOfMeasure>
                                                            <xsl:call-template name="UOMTemplate_Out">
                                                                <xsl:with-param name="p_UOMinput"
                                                                    select="Quantity/@unitCode"/>
                                                                <xsl:with-param name="p_anERPSystemID"
                                                                    select="$anERPSystemID"/>
                                                                <xsl:with-param name="p_anSupplierANID"
                                                                    select="$anSupplierANID"/>
                                                            </xsl:call-template>
                                                        </UnitOfMeasure>     
                                                        </xsl:if>
                                                    </UnrestrictedUseQuantity>                                                          
                                                    </xsl:when>
                                                    <xsl:when test="StockType = 'Intransit'and string-length(normalize-space(Quantity)) > 0">            
                                                    <IntransitQuantity>
                                                        <xsl:attribute name="quantity">
                                                            <xsl:value-of select="Quantity"/>                                                          
                                                        </xsl:attribute>    
                                                        <xsl:if test="string-length(normalize-space(Quantity/@unitCode)) > 0">   
                                                        <UnitOfMeasure>
                                                            <xsl:call-template name="UOMTemplate_Out">
                                                                <xsl:with-param name="p_UOMinput"
                                                                    select="Quantity/@unitCode"/>
                                                                <xsl:with-param name="p_anERPSystemID"
                                                                    select="$anERPSystemID"/>
                                                                <xsl:with-param name="p_anSupplierANID"
                                                                    select="$anSupplierANID"/>
                                                            </xsl:call-template>
                                                        </UnitOfMeasure>     
                                                        </xsl:if>
                                                    </IntransitQuantity>                                                           
                                                    </xsl:when> 
                                                    <xsl:when test="StockType = 'Intransitcc' and string-length(normalize-space(Quantity)) > 0">
                                                     <StockInTransferQuantity>                                                        
                                                            <xsl:attribute name="quantity">
                                                                <xsl:value-of select="Quantity"/>                                                          
                                                            </xsl:attribute>                                                        
                                                       <xsl:if test="string-length(normalize-space(Quantity/@unitCode)) > 0">  
                                                        <UnitOfMeasure>
                                                            <xsl:call-template name="UOMTemplate_Out">
                                                                <xsl:with-param name="p_UOMinput"
                                                                    select="Quantity/@unitCode"/>
                                                                <xsl:with-param name="p_anERPSystemID"
                                                                    select="$anERPSystemID"/>
                                                                <xsl:with-param name="p_anSupplierANID"
                                                                    select="$anSupplierANID"/>
                                                            </xsl:call-template>
                                                        </UnitOfMeasure>     
                                                       </xsl:if>
                                                     </StockInTransferQuantity>                                                
                                                 </xsl:when> 
                                                </xsl:choose>
                                              </xsl:for-each>
                                            </xsl:if>       
                                          <!-- End: CI-2009 -->  
                                            <xsl:if
                                                test="string-length(normalize-space(SMIInventory/UnrestrictedUseQuantity)) > 0">
                                                <UnrestrictedUseQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(SMIInventory/UnrestrictedUseQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="SMIInventory/UnrestrictedUseQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="SMIInventory/UnrestrictedUseQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                </UnrestrictedUseQuantity>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(SMIInventory/BlockedQuantity)) > 0">
                                                <BlockedQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(SMIInventory/BlockedQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="SMIInventory/BlockedQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="SMIInventory/BlockedQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                </BlockedQuantity>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(SMIInventory/QualityInspectionQuantity)) > 0">
                                                <QualityInspectionQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(SMIInventory/QualityInspectionQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="SMIInventory/QualityInspectionQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="SMIInventory/QualityInspectionQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                </QualityInspectionQuantity>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(SMIInventory/IncrementQuantity)) > 0">
                                                <IncrementQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(SMIInventory/IncrementQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="SMIInventory/IncrementQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="SMIInventory/IncrementQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                </IncrementQuantity>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(SMIInventory/RequiredMinimumQuantity)) > 0">
                                                <RequiredMinimumQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(SMIInventory/RequiredMinimumQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="SMIInventory/RequiredMinimumQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="SMIInventory/RequiredMinimumQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                </RequiredMinimumQuantity>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(SMIInventory/RequiredMaximumQuantity)) > 0">
                                                <RequiredMaximumQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(SMIInventory/RequiredMaximumQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="SMIInventory/RequiredMaximumQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="SMIInventory/RequiredMaximumQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                </RequiredMaximumQuantity>
                                            </xsl:if>
                                            <xsl:if
                                                test="/n0:ProductActivityMessage/Header/ProcessType = 'SMI'">
                                                <!-- Begin - CI-2120; check if either Mindays or Maxdays is available -->                              
                                                <xsl:if 
                                                    test="string-length(normalize-space(Inventory/MinDays)) > 0 or 
                                                          string-length(normalize-space(Inventory/MaxDays)) > 0">        
                                                    <!-- End - CI-2120; check if either Mindays or Maxdays is available -->                                                   
                                                <DaysOfSupply>
                                                    <!-- Begin - CI-2120; check if Mindays is available -->                                        
                                                    <xsl:if 
                                                        test="string-length(normalize-space(Inventory/MinDays)) > 0">  
                                                        <!-- End - CI-2120; check if Mindays is available -->                                                      
                                                    <xsl:attribute name="minimum">
                                                        <xsl:value-of select="Inventory/MinDays"/>
                                                    </xsl:attribute>
                                                    <!-- Begin - CI-2120; check if Mindays is available -->  
                                                    </xsl:if>  
                                                    <!-- End - CI-2120; check if Mindays is available -->  
                                                    <!-- Begin - CI-2120; check if Maxdays is available -->                                   
                                                    <xsl:if 
                                                        test="string-length(normalize-space(Inventory/MaxDays)) > 0"> 
                                                        <!-- End - CI-2120; check if Maxdays is available -->                                                       
                                                    <xsl:attribute name="maximum">
                                                        <xsl:value-of select="Inventory/MaxDays"/>
                                                    </xsl:attribute>
                                                        <!-- Begin - CI-2120; check if Maxdays is available -->                                         
                                                    </xsl:if>  
                                                    <!-- End - CI-2120; check if Maxdays is available -->                                                         
                                                </DaysOfSupply>
                                                <!-- Begin - CI-2120 -->          
                                                </xsl:if>     
                                                <!-- End - CI-2120 -->         
                                            </xsl:if>                                            
                                        </Inventory>
                                    </xsl:if>
                                    <xsl:if test="ConsignmentInventory">
                                        <ConsignmentInventory>
                                            <xsl:if 
                                                test="string-length(normalize-space(ConsignmentInventory/UnrestrictedUseQuantity)) > 0">
                                            <UnrestrictedUseQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(ConsignmentInventory/UnrestrictedUseQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="ConsignmentInventory/UnrestrictedUseQuantity"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="ConsignmentInventory/UnrestrictedUseQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                </UnitOfMeasure>
                                            </UnrestrictedUseQuantity>
                                            </xsl:if>
                                            <xsl:if 
                                                test="string-length(normalize-space(ConsignmentInventory/BlockedQuantity) )> 0">
                                            <BlockedQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(ConsignmentInventory/BlockedQuantity) )> 0">
                                                  <xsl:value-of
                                                  select="ConsignmentInventory/BlockedQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                    <xsl:call-template name="UOMTemplate_Out">
                                                        <xsl:with-param name="p_UOMinput"
                                                            select="ConsignmentInventory/BlockedQuantity/@unitCode"/>
                                                        <xsl:with-param name="p_anERPSystemID"
                                                            select="$anERPSystemID"/>
                                                        <xsl:with-param name="p_anSupplierANID"
                                                            select="$anSupplierANID"/>
                                                    </xsl:call-template>
                                                </UnitOfMeasure>
                                            </BlockedQuantity>
                                            </xsl:if>
                                            <xsl:if 
                                                test="string-length(normalize-space(ConsignmentInventory/QualityInspectionQuantity)) > 0">
                                            <QualityInspectionQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when
                                                      test="string-length(normalize-space(ConsignmentInventory/QualityInspectionQuantity)) > 0">
                                                  <xsl:value-of
                                                  select="ConsignmentInventory/QualityInspectionQuantity"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="ConsignmentInventory/QualityInspectionQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                </UnitOfMeasure>
                                            </QualityInspectionQuantity>
                                            </xsl:if>
                                        </ConsignmentInventory>
                                    </xsl:if>
                                    <xsl:for-each select="ForecastTimeSeries">
                                        <TimeSeries>
                                            <xsl:attribute name="type">
                                                <xsl:value-of select="Type"/>
                                            </xsl:attribute>
                                            <xsl:for-each select="Forecast">
                                                <Forecast>
                                                  <Period>
                                                  <xsl:attribute name="startDate">
                                                      <xsl:choose>
                                                          <xsl:when test="exists($v_plant_timezone)">
                                                              <xsl:value-of select="concat(StartDate,'T00:00:00',$v_plant_timezone)"/>
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of select="StartDate"/>
                                                          </xsl:otherwise>
                                                      </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="endDate">
                                                      <xsl:choose>
                                                          <xsl:when test="exists($v_plant_timezone)">
                                                              <xsl:value-of select="concat(EndDate,'T23:59:59',$v_plant_timezone)"/>
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of select="EndDate"/>
                                                          </xsl:otherwise>
                                                      </xsl:choose>   
                                                  </xsl:attribute>
                                                  </Period>
                                                  <ForecastQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when test="Quantity != ''">
                                                  <xsl:value-of select="Quantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="Quantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                  </ForecastQuantity>
                                                </Forecast>
                                            </xsl:for-each>
                                        </TimeSeries>
                                    </xsl:for-each>
                                    <xsl:for-each select="PlanningTimeSeries">
                                        <PlanningTimeSeries>
                                            <xsl:attribute name="type">
                                                <xsl:value-of select="type"/>
                                            </xsl:attribute>
                                            <!-- Begin of Changes CI-1779: Custom Key figure -->                                         
                                            <xsl:if test="type = 'custom'">
                                                <xsl:if 
                                                    test="string-length(normalize-space(customType) )> 0">    
                                                    <xsl:attribute name="customType">
                                                        <xsl:value-of select="customType"/>    
                                                    </xsl:attribute>
                                                </xsl:if>    
                                            </xsl:if>    
                                            <!-- End of Changes CI-1779: Custom Key figure -->  
                                            <xsl:for-each select="TimeSeriesDetails">
                                                <TimeSeriesDetails>
                                                  <Period>
                                                  <xsl:attribute name="startDate">
                                                      <xsl:choose>
                                                          <xsl:when test="exists($v_plant_timezone)">
                                                              <xsl:value-of select="concat(StartDate,'T00:00:00',$v_plant_timezone)"/>
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of select="StartDate"/>
                                                          </xsl:otherwise>
                                                      </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="endDate">
                                                      <xsl:choose>
                                                          <xsl:when test="exists($v_plant_timezone)">
                                                              <xsl:value-of select="concat(EndDate,'T23:59:59',$v_plant_timezone)"/>
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                              <xsl:value-of select="EndDate"/>
                                                          </xsl:otherwise>
                                                      </xsl:choose>  
                                                  </xsl:attribute>
                                                  </Period>
                                                  <TimeSeriesQuantity>
                                                  <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when test="Quantity != ''">
                                                  <xsl:value-of select="Quantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="Quantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                  </UnitOfMeasure>
                                                  </TimeSeriesQuantity>
                                                    <!-- Begin of changes for CI-1779: IdReference Mapping -->    
                                                    <xsl:for-each select="IdReference">
                                                        <IdReference>
                                                            <xsl:attribute name="identifier">
                                                                <xsl:value-of select="Identifier"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="domain">
                                                                <xsl:value-of select="Domain"/>
                                                            </xsl:attribute>                                                      
                                                        </IdReference>
                                                    </xsl:for-each>    
                                                    <!-- End of changes for CI-1779: IdReference Mapping --> 
                                                </TimeSeriesDetails>
                                            </xsl:for-each>
                                        </PlanningTimeSeries>
                                    </xsl:for-each>
                                    <xsl:for-each select="ConsignmentMovement">
                                        <ConsignmentMovement>
                                            <ProductMovementItemIDInfo>
                                                <xsl:attribute name="movementLineNumber">
                                                  <xsl:value-of select="MovementLineNumber"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="movementDate">
                                                  <xsl:value-of select="MovementDate"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="movementID">
                                                  <xsl:value-of select="MovementID"/>
                                                </xsl:attribute>
                                            </ProductMovementItemIDInfo>
                                            <xsl:if test="InvoiceID != ' '">
                                                <InvoiceItemIDInfo>
                                                  <xsl:attribute name="invoiceID">
                                                  <xsl:value-of select="InvoiceID"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="invoiceDate">
                                                  <xsl:value-of select="InvoiceDate"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="invoiceLineNumber">
                                                  <xsl:value-of select="InvoiceLineNumber"/>
                                                  </xsl:attribute>
                                                </InvoiceItemIDInfo>
                                            </xsl:if>
                                            <MovementQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:choose>
                                                  <xsl:when test="MovementQuantity != ''">
                                                  <xsl:value-of select="MovementQuantity"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:value-of select="'0.0'"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <xsl:call-template name="UOMTemplate_Out">
                                                  <xsl:with-param name="p_UOMinput"
                                                  select="MovementQuantity/@unitCode"/>
                                                  <xsl:with-param name="p_anERPSystemID"
                                                  select="$anERPSystemID"/>
                                                  <xsl:with-param name="p_anSupplierANID"
                                                  select="$anSupplierANID"/>
                                                  </xsl:call-template>
                                                </UnitOfMeasure>
                                            </MovementQuantity>
                                            <SubtotalAmount>
                                                <Money>
                                                  <xsl:attribute name="currency">
                                                  <xsl:value-of select="Money/@currencyCode"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="Money"/>
                                                </Money>
                                            </SubtotalAmount>
                                        </ConsignmentMovement>
                                    </xsl:for-each>
                                </ProductActivityDetails>
                            </xsl:for-each>
                        </ProductActivityMessage>
                    </Message>
                </cXML>
            </Payload>
        </Combined>
    </xsl:template>
</xsl:stylesheet>
