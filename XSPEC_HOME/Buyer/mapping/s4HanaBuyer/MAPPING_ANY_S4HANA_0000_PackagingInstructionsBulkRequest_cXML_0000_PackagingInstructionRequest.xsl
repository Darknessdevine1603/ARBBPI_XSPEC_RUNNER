<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="http://sap.com/xi/SBN"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" exclude-result-prefixes="#all" version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
            <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
<!--    <xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <xsl:param name="anSenderID"/>
    <xsl:param name="anProviderANID"/>

    <xsl:template match="n0:PackagingInstructionsBulkRequest">
        <root>
            <packagingInstructionRequest>
                <requestInfo>
                    <payloadID>
                        <xsl:value-of select="MessageHeader/ID"/>
                    </payloadID>
                    <creationDateTime>
                        <xsl:value-of
                            select="concat(substring(MessageHeader/CreationDateTime, 0, 20), '+00:00')"
                        />
                    </creationDateTime>
                    <parties>
                        <type>
                            <xsl:value-of select="'FromParty'"/>
                        </type>
                        <domain>
                            <xsl:value-of select="'NetworkID'"/>
                        </domain>
                        <identity>
                            <xsl:value-of select="$anSenderID"/>
                        </identity>
                        <xsl:if
                            test="string-length(normalize-space(MessageHeader/SenderBusinessSystemID)) > 0">
                            <systemID>
                                <xsl:value-of select="MessageHeader/SenderBusinessSystemID"/>
                            </systemID>
                        </xsl:if>
                    </parties>
                    <parties>
                        <type>
                            <xsl:value-of select="'ToParty'"/>
                        </type>
                        <domain>
                            <xsl:value-of select="'NetworkID'"/>
                        </domain>
                        <identity>
                            <xsl:value-of select="$anSenderID"/>
                        </identity>
                    </parties>
                    <parties>
                        <type>
                            <xsl:value-of select="'SenderParty'"/>
                        </type>
                        <domain>
                            <xsl:value-of select="'NetworkID'"/>
                        </domain>
                        <identity>
                            <xsl:value-of select="$anProviderANID"/>
                        </identity>
                    </parties>
                </requestInfo>
                <xsl:for-each select="PackagingInstructions">
                    <!--variable to validate conditional mandatory fields-->
                    <xsl:variable name="v_isauxiliary">
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(IsAuxiliary)) > 0">
                                <xsl:value-of select="IsAuxiliary"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'false'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <packagingDetails>
                        <!-- Conditional Mandatory Field, If isauxiliary = 'false' then packagingSpecificationId is Mandatory -->
                        <xsl:if test="string-length(normalize-space(PackagingSpecificationID)) > 0 or $v_isauxiliary = 'false'">
                            <packagingSpecificationId>
                                <xsl:value-of select="PackagingSpecificationID"/>
                            </packagingSpecificationId>
                        </xsl:if>
                        <packagingMaterial>
                            <xsl:value-of select="PackagingMaterial"/>
                        </packagingMaterial>
                        <packagingMaterialDescription>
                            <xsl:value-of select="PackagingMaterialDescription"/>
                        </packagingMaterialDescription>
                        <!-- Conditional Mandatory Field, If isauxiliary = 'false' then Quantity is Mandatory -->
                        <xsl:if test="string-length(normalize-space(Quantity)) > 0 or $v_isauxiliary = 'false'">
                            <quantity>
                                <xsl:value-of select="Quantity"/>
                            </quantity>
                        </xsl:if>
                        <uom>
                            <xsl:value-of select="Quantity/@unitCode"/>
                        </uom>
                        <!-- Conditional Mandatory Field, If isauxiliary = 'false' then level is Mandatory -->
                        <xsl:if test="string-length(normalize-space(PackagingLevel)) > 0 or $v_isauxiliary = 'false'">
                            <level>
                                <xsl:value-of select="PackagingLevel"/>
                            </level>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(TargetQty)) > 0">
                            <targetQty>
                                <xsl:value-of select="TargetQty"/>
                            </targetQty>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(MinimumQty)) > 0">
                            <minimumQty>
                                <xsl:value-of select="MinimumQty"/>
                            </minimumQty>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(Length)) > 0 or string-length(normalize-space(Length/@unitCode)) > 0">
                            <length>
                                <xsl:if test="string-length(normalize-space(Length)) > 0">
                                    <quantity>
                                        <xsl:value-of select="Length"/>
                                    </quantity>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(Length/@unitCode)) > 0">
                                    <unitOfMeasure>
                                        <xsl:value-of select="Length/@unitCode"/>
                                    </unitOfMeasure>
                                </xsl:if>
                            </length>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(Height)) > 0 or string-length(normalize-space(Height/@unitCode)) > 0">
                            <height>
                                <xsl:if test="string-length(normalize-space(Height)) > 0">
                                    <quantity>
                                        <xsl:value-of select="Height"/>
                                    </quantity>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(Height/@unitCode)) > 0">
                                    <unitOfMeasure>
                                        <xsl:value-of select="Height/@unitCode"/>
                                    </unitOfMeasure>
                                </xsl:if>
                            </height>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(Width)) > 0 or string-length(normalize-space(Width/@unitCode)) > 0">
                            <width>
                                <xsl:if test="string-length(normalize-space(Width)) > 0">
                                    <quantity>
                                        <xsl:value-of select="Width"/>
                                    </quantity>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(Width/@unitCode)) > 0">
                                    <unitOfMeasure>
                                        <xsl:value-of select="Width/@unitCode"/>
                                    </unitOfMeasure>
                                </xsl:if>
                            </width>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(Volume)) > 0 or string-length(normalize-space(Volume/@unitCode)) > 0">
                            <volume>
                                <xsl:if test="string-length(normalize-space(Volume)) > 0">
                                    <quantity>
                                        <xsl:value-of select="Volume"/>
                                    </quantity>
                                </xsl:if>
                                <xsl:if test="string-length(normalize-space(Volume/@unitCode)) > 0">
                                    <unitOfMeasure>
                                        <xsl:value-of select="Volume/@unitCode"/>
                                    </unitOfMeasure>
                                </xsl:if>
                            </volume>
                        </xsl:if>
                        <!-- Conditional Mandatory Field, If isauxiliary = 'false' then Net Weight is Mandatory -->
                        <xsl:if test="string-length(normalize-space(NetWeight)) > 0 or $v_isauxiliary = 'false'">
                            <netWeight>
                                <xsl:value-of select="NetWeight"/>
                            </netWeight>
                        </xsl:if>
                        <!-- Conditional Mandatory Field, If isauxiliary = 'false' then Gross Weight is Mandatory -->
                        <xsl:if
                            test="string-length(normalize-space(GrossWeight)) > 0 or string-length(normalize-space(GrossWeight/@unitCode)) > 0  or $v_isauxiliary = 'false'">
                            <grossWeight>
                                <xsl:if test="string-length(normalize-space(GrossWeight)) > 0">
                                    <quantity>
                                        <xsl:value-of select="GrossWeight"/>
                                    </quantity>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(GrossWeight/@unitCode)) > 0">
                                    <unitOfMeasure>
                                        <xsl:value-of select="GrossWeight/@unitCode"/>
                                    </unitOfMeasure>
                                </xsl:if>
                            </grossWeight>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(TotalVolume)) > 0 or string-length(normalize-space(TotalVolume/@unitCode)) > 0">
                            <totalVolume>
                                <xsl:if test="string-length(normalize-space(TotalVolume)) > 0">
                                    <quantity>
                                        <xsl:value-of select="TotalVolume"/>
                                    </quantity>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(TotalVolume/@unitCode)) > 0">
                                    <unitOfMeasure>
                                        <xsl:value-of select="TotalVolume/@unitCode"/>
                                    </unitOfMeasure>
                                </xsl:if>
                            </totalVolume>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(ParentPackagingMaterial)) > 0">
                            <parentPackagingMaterial>
                                <xsl:value-of select="ParentPackagingMaterial"/>
                            </parentPackagingMaterial>
                        </xsl:if>
                        <needsToBeShown>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(NeedsToBeShown)) > 0">
                                    <xsl:value-of select="NeedsToBeShown"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'false'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </needsToBeShown>
                        <allowMixed>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(AllowMixed)) > 0">
                                    <xsl:value-of select="AllowMixed"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'false'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </allowMixed>
                        <isAuxiliary>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(IsAuxiliary)) > 0">
                                    <xsl:value-of select="IsAuxiliary"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'false'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </isAuxiliary>
                        <isPrintable>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(IsPrintable)) > 0">
                                    <xsl:value-of select="IsPrintable"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'false'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </isPrintable>
                        <isDefault>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(IsDefault)) > 0">
                                    <xsl:value-of select="IsDefault"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'false'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </isDefault>
                        <xsl:if test="string-length(normalize-space(UpdatedOn)) > 0">
                            <updatedOn>
                                <xsl:value-of select="concat(substring(UpdatedOn, 0, 20), '+00:00')"
                                />
                            </updatedOn>
                        </xsl:if>
                        <xsl:if
                            test="string-length(normalize-space(Material)) > 0 or string-length(normalize-space(MaterialDescription)) > 0">
                            <shippingItem>
                                <xsl:if test="string-length(normalize-space(Material)) > 0">
                                    <buyerPartId>
                                        <xsl:value-of select="Material"/>
                                    </buyerPartId>
                                </xsl:if>
                                <xsl:if
                                    test="string-length(normalize-space(MaterialDescription)) > 0">
                                    <materialDescription>
                                        <xsl:value-of select="MaterialDescription"/>
                                    </materialDescription>
                                </xsl:if>
                            </shippingItem>
                        </xsl:if>
                    </packagingDetails>
                </xsl:for-each>
                <xsl:for-each select="PackagingInstructionsAssignments">
                    <assignments>
                        <packagingSpecificationId>
                            <xsl:value-of select="PackagingSpecificationID"/>
                        </packagingSpecificationId>
                        <xsl:if test="string-length(normalize-space(PlantID)) > 0">
                            <plantID>
                                <xsl:value-of select="PlantID"/>
                            </plantID>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(VendorID)) > 0">
                            <vendorID>
                                <xsl:value-of select="VendorID"/>
                            </vendorID>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(ValidFrom)) > 0">
                            <validFrom>
                                <xsl:value-of select="ValidFrom"/>
                            </validFrom>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(ValidTo)) > 0">
                            <validTo>
                                <xsl:value-of select="ValidTo"/>
                            </validTo>
                        </xsl:if>
                    </assignments>
                </xsl:for-each>
            </packagingInstructionRequest>
        </root>
    </xsl:template>
</xsl:stylesheet>
