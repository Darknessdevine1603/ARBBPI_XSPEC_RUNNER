<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anBuyerANID"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anSenderDefaultTimeZone"/>
    <xsl:param name="upperAlpha">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
    <xsl:param name="lowerAlpha">abcdefghijklmnopqrstuvwxyz</xsl:param>
    <xsl:template match="/">
        <xsl:variable name="BODID" select="concat(NotifyInventoryBalance/ApplicationArea/BODID, '')"/>
        <xsl:variable name="documentid"
            select="concat(NotifyInventoryBalance/ApplicationArea/BODID, '')"/>
        <xsl:variable name="CreationDateTime"
            select="concat(NotifyInventoryBalance/ApplicationArea/CreationDateTime, '')"/>
        <cXML>
            <xsl:attribute name="timestamp">
                <xsl:value-of
                    select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"
                />
            </xsl:attribute>
            <xsl:attribute name="payloadID">
                <xsl:value-of select="$anPayloadID"/>
            </xsl:attribute>
            <Header>
                <From>
                    <Credential domain="NetworkID">
                        <Identity>
                            <xsl:value-of select="$anSupplierANID"/>
                        </Identity>
                    </Credential>
                    <!-- IG-32572 -->
                    <xsl:if test="NotifyInventoryBalance/ApplicationArea/UserArea/VendorID[@schemeID='SenderKey'] !=''">
                        <Credential domain="VendorID">
                            <Identity>
                                <xsl:value-of select="NotifyInventoryBalance/ApplicationArea/UserArea/VendorID[@schemeID='SenderKey']"/>
                            </Identity>
                        </Credential>
                    </xsl:if>
                    <xsl:if test="NotifyInventoryBalance/ApplicationArea/UserArea/PrivateID[@schemeID='SenderKey'] !=''">
                        <Credential domain="PrivateID">
                            <Identity>
                                <xsl:value-of select="NotifyInventoryBalance/ApplicationArea/UserArea/PrivateID[@schemeID='SenderKey']"/>
                            </Identity>
                        </Credential>
                    </xsl:if>
                </From>
                <To>
                    <Credential domain="NetworkID">
                        <Identity>
                            <xsl:value-of select="$anBuyerANID"/>
                        </Identity>
                    </Credential>
                </To>
                <Sender>
                    <Credential domain="NetworkId">
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
                        <xsl:attribute name="deploymentMode">production</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="deploymentMode">test</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <ProductReplenishmentMessage>
                    <ProductReplenishmentHeader>
                        <xsl:attribute name="creationDate">
                            <xsl:value-of
                                select="NotifyInventoryBalance/ApplicationArea/CreationDateTime"/>
                        </xsl:attribute>
                        <xsl:attribute name="messageID">
                            <xsl:value-of select="NotifyInventoryBalance/ApplicationArea/BODID"/>
                        </xsl:attribute>
                    </ProductReplenishmentHeader>
                    <xsl:for-each select="NotifyInventoryBalance/DataArea/InventoryBalance">
                        <xsl:variable name="inventoryCategory">
                            <xsl:value-of
                                select="concat(Item/Classification[translate(@type, $upperAlpha, $lowerAlpha) = 'inventorycategory']/Codes/Code, '')"
                            />
                        </xsl:variable>
                        <ProductReplenishmentDetails>
                            <ItemID>
                                <SupplierPartID>
                                    <xsl:value-of
                                        select="Item/ItemID[@agencyRole = 'VendorPartNumber']/ID"/>
                                </SupplierPartID>
                                <BuyerPartID>
                                    <xsl:value-of
                                        select="Item/ItemID[@agencyRole = 'MSPartNumber']/ID"/>
                                </BuyerPartID>
                            </ItemID>
                            <Description>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="Item/Description/@languageID"/>
                                </xsl:attribute>
                                <xsl:value-of select="Item/Description"/>
                            </Description>
                            <xsl:for-each select="Facility">
                                <xsl:choose>
                                    <xsl:when
                                        test="translate(IDs/ID, $upperAlpha, $lowerAlpha) = 'locationto'">
                                        <Contact>
                                            <xsl:attribute name="role">
                                                <xsl:text>locationTo</xsl:text>
                                            </xsl:attribute>
                                            <Name>
                                                <xsl:attribute name="xml:lang">
                                                  <xsl:value-of select="Name/@languageID"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="Name"/>
                                            </Name>
                                            <xsl:if test="Address/CityName">
                                                <xsl:call-template name="Address">
                                                  <xsl:with-param name="AddressInfo"
                                                  select="Address"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                            <xsl:if
                                                test="translate(UserArea/Status/Code/@name, $upperAlpha, $lowerAlpha) = 'buyerlocationid'">
                                                <IdReference>
                                                  <xsl:attribute name="domain">
                                                  <xsl:text>buyerLocationID</xsl:text>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="identifier">
                                                  <xsl:value-of select="UserArea/Status/Code"/>
                                                  </xsl:attribute>
                                                </IdReference>
                                            </xsl:if>
                                            <!-- IG-5780 -->
                                            <xsl:if
                                                test="../Item/UserArea/Status/Code/@name = 'StorageLocation'">                                                
                                                <Extrinsic>
                                                  <xsl:attribute name="name"
                                                  >materialStorageLocation</xsl:attribute>
                                                  <xsl:value-of
                                                      select="../Item/UserArea/Status[Code/@name = 'StorageLocation']/Code"
                                                  />
                                                </Extrinsic>
                                            </xsl:if>
                                            
                                        </Contact>
                                    </xsl:when>
                                    <xsl:when
                                        test="translate(IDs/ID, $upperAlpha, $lowerAlpha) = 'inventoryowner'">
                                        <Contact>
                                            <xsl:attribute name="role">
                                                <xsl:text>inventoryOwner</xsl:text>
                                            </xsl:attribute>
                                            <Name>
                                                <xsl:attribute name="xml:lang">
                                                  <xsl:value-of select="Name/@languageID"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="Name"/>
                                            </Name>
                                            <xsl:if test="Address/CityName">
                                                <xsl:call-template name="Address">
                                                  <xsl:with-param name="AddressInfo"
                                                  select="Address"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                            <xsl:if
                                                test="translate(UserArea/Status/Code/@name, $upperAlpha, $lowerAlpha) = 'inventoryownerid'">
                                                <IdReference>
                                                  <xsl:attribute name="domain">
                                                  <xsl:text>inventoryOwnerID</xsl:text>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="identifier">
                                                  <xsl:value-of select="UserArea/Status/Code"/>
                                                  </xsl:attribute>
                                                </IdReference>
                                            </xsl:if>
                                        </Contact>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:choose>
                                <xsl:when
                                    test="$inventoryCategory = 'CC' or $inventoryCategory = 'CF' or $inventoryCategory = 'CD' or $inventoryCategory = 'CG'">
                                    <Inventory>
                                        <xsl:if
                                            test="$inventoryCategory = 'CC' or $inventoryCategory = 'CD'">
                                            <UnrestrictedUseQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:value-of select="Quantity"/>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <xsl:value-of select="Quantity/@unitCode"/>
                                                </UnitOfMeasure>
                                            </UnrestrictedUseQuantity>
                                        </xsl:if>
                                        <xsl:if
                                            test="$inventoryCategory = 'CF' or $inventoryCategory = 'CG'">
                                            <QualityInspectionQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:value-of select="Quantity"/>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <xsl:value-of select="Quantity/@unitCode"/>
                                                </UnitOfMeasure>
                                            </QualityInspectionQuantity>
                                        </xsl:if>
                                    </Inventory>
                                    <xsl:if test="$inventoryCategory = 'CD'">
                                        <ConsignmentInventory>
                                            <UnrestrictedUseQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:value-of select="Quantity"/>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <xsl:value-of select="Quantity/@unitCode"/>
                                                </UnitOfMeasure>
                                            </UnrestrictedUseQuantity>
                                        </ConsignmentInventory>
                                    </xsl:if>
                                    <xsl:if test="$inventoryCategory = 'CG'">
                                        <ConsignmentInventory>
                                            <QualityInspectionQuantity>
                                                <xsl:attribute name="quantity">
                                                  <xsl:value-of select="Quantity"/>
                                                </xsl:attribute>
                                                <UnitOfMeasure>
                                                  <xsl:value-of select="Quantity/@unitCode"/>
                                                </UnitOfMeasure>
                                            </QualityInspectionQuantity>
                                        </ConsignmentInventory>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="$inventoryCategory = 'CI'">
                                    <Inventory>
                                        <BlockedQuantity>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="Quantity"/>
                                            </xsl:attribute>
                                            <UnitOfMeasure>
                                                <xsl:value-of select="Quantity/@unitCode"/>
                                            </UnitOfMeasure>
                                        </BlockedQuantity>
                                    </Inventory>
                                </xsl:when>
                                <xsl:when test="$inventoryCategory = 'CJ'">
                                    <ConsignmentInventory>
                                        <BlockedQuantity>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="Quantity"/>
                                            </xsl:attribute>
                                            <UnitOfMeasure>
                                                <xsl:value-of select="Quantity/@unitCode"/>
                                            </UnitOfMeasure>
                                        </BlockedQuantity>
                                    </ConsignmentInventory>
                                </xsl:when>
                                <xsl:when
                                    test="$inventoryCategory = 'CN' or $inventoryCategory = 'CS' or $inventoryCategory = 'CA'">
                                    <Inventory>
                                        <StockInTransferQuantity>
                                            <xsl:attribute name="quantity">
                                                <xsl:value-of select="Quantity"/>
                                            </xsl:attribute>
                                            <UnitOfMeasure>
                                                <xsl:value-of select="Quantity/@unitCode"/>
                                            </UnitOfMeasure>
                                        </StockInTransferQuantity>
                                    </Inventory>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:if test="Status/EffectiveDateTime">
                                <Extrinsic>
                                    <xsl:attribute name="name">InventoryDate</xsl:attribute>
                                    <xsl:value-of select="Status/EffectiveDateTime"/>
                                </Extrinsic>
                            </xsl:if>
                            <xsl:for-each select="UserArea/Status[Code/@name='MutuallyDefined']">
                                <xsl:if test="normalize-space(Code)!=''">
                                    <Extrinsic>
                                        <xsl:attribute name="name">
                                            <xsl:value-of select="normalize-space(Code)"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="Description"/>
                                    </Extrinsic>
                                </xsl:if>
                            </xsl:for-each>                           
                        </ProductReplenishmentDetails>
                    </xsl:for-each>
                </ProductReplenishmentMessage>
            </Message>
        </cXML>
    </xsl:template>
    <xsl:template name="Address">
        <xsl:param name="AddressInfo"/>
        <PostalAddress>
            <xsl:if test="$AddressInfo/LineOne">
                <Street>
                    <xsl:value-of select="$AddressInfo/LineOne"/>
                </Street>
            </xsl:if>
            <City>
                <xsl:value-of select="$AddressInfo/CityName"/>
            </City>
            <xsl:if test="$AddressInfo/CountrySubDivisionCode">
                <State>
                    <xsl:value-of select="$AddressInfo/CountrySubDivisionCode"/>
                </State>
            </xsl:if>
            <xsl:if test="$AddressInfo/CountryCode">
                <Country>
                    <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$AddressInfo/CountryCode"/>
                    </xsl:attribute>
                </Country>
            </xsl:if>
        </PostalAddress>
    </xsl:template>
</xsl:stylesheet>
