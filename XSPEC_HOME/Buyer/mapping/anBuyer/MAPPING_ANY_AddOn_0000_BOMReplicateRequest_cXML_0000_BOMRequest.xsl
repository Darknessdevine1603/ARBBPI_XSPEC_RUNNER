<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://ariba.com/s4/dms/schema/bom" xmlns:hci="http://sap.com/it/"
    xmlns:xop="http://www.w3.org/2004/08/xop/include" xmlns:n1="http://sap.com/xi/PP/Global2"
    exclude-result-prefixes="#all" xpath-default-namespace="http://ariba.com/s4/dms/schema/bom"
    version="2.0">

    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_AddOn_0000_cXML_0000.xsl"/>   
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anSenderID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anProviderANID"/>

    <xsl:variable name="v_header" select="BOMReplicateRequest/MessageHeader"/>
    <xsl:variable name="v_bheader" select="BOMReplicateRequest/BOM/BOMHeader"/>
    <xsl:variable name="v_ddata" select="BOMReplicateRequest/BOM/DeletedData"/>
    <xsl:variable name="v_dbom" select="BOMReplicateRequest/BOM/DeletedData/DeletedBOM"/>


    <xsl:template match="BOMReplicateRequest">
        <root>
            <bomRequest>

                <!-- Request Info -->
                <requestInfo>

                    <!-- Payload ID -->
                    <!-- IG-35569, added normalize-space to UUID -->
                    <payloadID>
                        <xsl:value-of select="normalize-space($v_header/UUID)"/>
                    </payloadID>

                    <!-- Get Current date and format it-->
                    <creationDateTime>
                        <xsl:variable name="v_curdate">
                            <xsl:value-of select="current-dateTime()"/>
                        </xsl:variable>
                        <xsl:value-of select="format-dateTime($v_curdate, '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][Z]')"/>
                    </creationDateTime>

                    <!-- Multiple Parties -->
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
                        <xsl:if test="upper-case($anIsMultiERP) = 'TRUE'">
                            <systemID>
                                <xsl:value-of select="$anERPSystemID"/>
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
                <!-- BOM Request Header -->
                <bomRequestHeader>

                    <fullLoad>
                        <xsl:choose>
                            <xsl:when test="upper-case($v_header/FullLoad) = 'TRUE'">
                                <xsl:value-of select="'X'"/>
                            </xsl:when>
                        </xsl:choose>
                    </fullLoad>
                </bomRequestHeader>
                <!-- Multiple Boms possible as per JSON Schema, However supporting only one BOM/Message as per proxy design-->
                <boms>
                    
                    <!-- BOM Header-->
                    <xsl:if test="string-length(normalize-space($v_bheader)) > 0">
                        <bomHeader>
                            
                            <material>
                                <xsl:value-of select="$v_bheader/Material"/>
                            </material>
                            <category>
                                <xsl:value-of select="$v_bheader/BOMCategory"/>
                            </category>
                            <bomNo>
                                <xsl:value-of select="$v_bheader/BOMNo"/>
                            </bomNo>
                            <alternativeBOM>
                                <xsl:value-of select="$v_bheader/AlternativeBOM"/>
                            </alternativeBOM>
                            <usage>
                                <xsl:value-of select="$v_bheader/Usage"/>
                            </usage>

                            <validFromDate>

                                <xsl:variable name="v_vfrbh_date">
                                    <xsl:value-of
                                        select='translate(substring($v_bheader/ValidFromDate, 1, 10), "-", "")'
                                    />
                                </xsl:variable>

                                <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="$v_vfrbh_date"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>

                            </validFromDate>

                            <validToDate>

                                <xsl:variable name="v_vtobh_date">
                                    <xsl:value-of
                                        select='translate(substring($v_bheader/ValidToDate, 1, 10), "-", "")'
                                    />
                                </xsl:variable>

                                <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="$v_vtobh_date"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>

                            </validToDate>

                            <status>
                                <xsl:value-of select="$v_bheader/BOMStatus"/>
                            </status>


                            <baseQuantity>
                                <quantity>
                                    <xsl:value-of select="$v_bheader/BaseQuantity"/>
                                </quantity>
                                <unitOfMeasure> <!-- IG-35569, spelling mistake of unitofmeasure -->
                                    <xsl:call-template name="UOMTemplate_Out">
                                        <xsl:with-param name="p_UOMinput"
                                            select="$v_bheader/BaseQuantity/@unitCode"/>
                                        <xsl:with-param name="p_anERPSystemID"
                                            select="$anERPSystemID"/>
                                        <xsl:with-param name="p_anSupplierANID"
                                            select="$anSupplierANID"/>
                                    </xsl:call-template>
                                </unitOfMeasure>
                            </baseQuantity>

                            <xsl:if test="string-length(normalize-space($v_bheader/BOMGroup)) > 0">
                                <bomGroup>
                                    <xsl:value-of select="$v_bheader/BOMGroup"/>
                                </bomGroup>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space($v_bheader/BOMText)) > 0">
                                <bomText>
                                    <xsl:value-of select="$v_bheader/BOMText"/>
                                </bomText>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space($v_bheader/AlternativeBOMText)) > 0">
                                <alternativeBOMText>
                                    <xsl:value-of select="$v_bheader/AlternativeBOMText"/>
                                </alternativeBOMText>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space($v_bheader/BOMDeletionFlag)) > 0">
                                <deletionFlag>
                                    <xsl:value-of select="$v_bheader/BOMDeletionFlag"/>
                                </deletionFlag>
                            </xsl:if>


                            <creationDate>

                                <xsl:variable name="v_crbh_date">
                                    <xsl:value-of
                                        select='translate(substring($v_bheader/CreationDate, 1, 10), "-", "")'
                                    />
                                </xsl:variable>

                                <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="$v_crbh_date"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>

                            </creationDate>


                            <xsl:if test="string-length(normalize-space($v_bheader/ChangeDate)) > 0">
                                <changeDate>

                                    <xsl:variable name="v_chbh_date">
                                        <xsl:value-of
                                            select='translate(substring($v_bheader/ChangeDate, 1, 10), "-", "")'
                                        />
                                    </xsl:variable>

                                    <xsl:call-template name="ANDateTime">
                                        <xsl:with-param name="p_date" select="$v_chbh_date"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>


                                </changeDate>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space($v_bheader/ChangeNo)) > 0">
                                <changeNumber>
                                    <xsl:value-of select="$v_bheader/ChangeNo"/>
                                </changeNumber>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space($v_bheader/ChangeNumberTo)) > 0">
                                <changeNumberTo>
                                    <xsl:value-of select="$v_bheader/ChangeNumberTo"/>
                                </changeNumberTo>
                            </xsl:if>


                            <xsl:if
                                test="string-length(normalize-space($v_bheader/TechnicalType)) > 0">
                                <technicalType>
                                    <xsl:value-of select="$v_bheader/TechnicalType"/>
                                </technicalType>
                            </xsl:if>
                        </bomHeader>
                    </xsl:if>

                    <!-- Multiple Plants -->
                    <xsl:for-each select="BOM/BOMPlant">                  
                        <xsl:if test="string-length(normalize-space(Plant)) > 0">
                            <plants>
                                <plantId>
                                    <xsl:value-of select="Plant"/>
                                </plantId>
                            </plants>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- Multiple Bom Components -->
                    <xsl:for-each select="BOM/BOMComponent">
                        <bomComponents>

                            <material>
                                <xsl:value-of select="Material"/>
                            </material>

                            <itemCategory>
                                <xsl:value-of select="ItemCategory"/>
                            </itemCategory>


                            <xsl:if test="string-length(normalize-space(ItemGroup)) > 0">
                                <itemGroup>
                                    <xsl:value-of select="ItemGroup"/>
                                </itemGroup>
                            </xsl:if>
                            
                            <itemNumber>
                                <xsl:value-of select="ItemNumber"/>
                            </itemNumber>

                            <itemNodeNumber>
                                <xsl:value-of select="ItemNodeNumber"/>
                            </itemNodeNumber>

                            <xsl:if test="string-length(normalize-space(InternalCounter)) > 0">
                                <internalCounter>
                                    <xsl:value-of select="InternalCounter"/>
                                </internalCounter>
                            </xsl:if>
                            
                            <xsl:if test="string-length(normalize-space(PMAssemblyIndicator)) > 0">
                                <pmAssemblyIndicator>
                                    <xsl:value-of select="PMAssemblyIndicator"/>
                                </pmAssemblyIndicator>
                            </xsl:if>
                            
                            <validFromDate>

                                <xsl:variable name="v_vfrbc_date">
                                    <xsl:value-of
                                        select='translate(substring(ValidFromDate, 1, 10), "-", "")'
                                    />
                                </xsl:variable>

                                <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="$v_vfrbc_date"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>

                            </validFromDate>

                            <validToDate>

                                <xsl:variable name="v_vtobc_date">
                                    <xsl:value-of
                                        select='translate(substring(ValidToDate, 1, 10), "-", "")'/>
                                </xsl:variable>

                                <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="$v_vtobc_date"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>

                            </validToDate>

                            <xsl:if test="string-length(normalize-space(ItemText1)) > 0">
                                <itemText1>
                                    <xsl:value-of select="ItemText1"/>
                                </itemText1>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(ItemText2)) > 0">
                                <itemText2>
                                    <xsl:value-of select="ItemText2"/>
                                </itemText2>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(SortString)) > 0">
                                <sortString>
                                    <xsl:value-of select="SortString"/>
                                </sortString>
                            </xsl:if>

                            <xsl:if
                                test="string-length(normalize-space(MaterialProvisionIndicator)) > 0">
                                <materialProvisionIndicator>
                                    <xsl:value-of select="MaterialProvisionIndicator"/>
                                </materialProvisionIndicator>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(Priority)) > 0">
                                <priority>
                                    <xsl:value-of select="Priority"/>
                                </priority>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(Strategy)) > 0">
                                <strategy>
                                    <xsl:value-of select="Strategy"/>
                                </strategy>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(UsageProbability)) > 0">
                                <usageProbability>
                                    <xsl:value-of select="UsageProbability"/>
                                </usageProbability>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(ReferenceDesignator)) > 0">
                                <referenceDesignator>
                                    <xsl:value-of select="ReferenceDesignator"/>
                                </referenceDesignator>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(FixedQty)) > 0">
                                <fixedQuantityIndicator>
                                    <xsl:value-of select="FixedQty"/>
                                </fixedQuantityIndicator>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(BOMRecursiveIndicator)) > 0">
                                <recursiveIndicator>
                                    <xsl:value-of select="BOMRecursiveIndicator"/>
                                </recursiveIndicator>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(DeletionIndicator)) > 0">
                                <deletionIndicator>
                                    <xsl:value-of select="DeletionIndicator"/>
                                </deletionIndicator>
                            </xsl:if>


                            <creationDate>

                                <xsl:variable name="v_vcrbc_date">
                                    <xsl:value-of
                                        select='translate(substring(CreationDate, 1, 10), "-", "")'
                                    />
                                </xsl:variable>

                                <xsl:call-template name="ANDateTime">
                                    <xsl:with-param name="p_date" select="$v_vcrbc_date"/>
                                    <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                </xsl:call-template>

                            </creationDate>



                            <xsl:if test="string-length(normalize-space(ChangeDate)) > 0">
                                <changeDate>

                                    <xsl:variable name="v_vchbc_date">
                                        <xsl:value-of
                                            select='translate(substring(ChangeDate, 1, 10), "-", "")'
                                        />
                                    </xsl:variable>

                                    <xsl:call-template name="ANDateTime">
                                        <xsl:with-param name="p_date" select="$v_vchbc_date"/>
                                        <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                    </xsl:call-template>

                                </changeDate>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(ChangeNumber)) > 0">
                                <changeNumber>
                                    <xsl:value-of select="ChangeNumber"/>
                                </changeNumber>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(ChangeNumberTo)) > 0">
                                <changeNumberTo>
                                    <xsl:value-of select="ChangeNumberTo"/>
                                </changeNumberTo>
                            </xsl:if>

                            <xsl:if test="string-length(normalize-space(RequiredComponent)) > 0">
                                <requiredComponentIndicator>
                                    <xsl:value-of select="RequiredComponent"/>
                                </requiredComponentIndicator>
                            </xsl:if>

                            <price>
                                <baseQuantity>
                                    <quantity>
                                        <xsl:value-of select="Price/BaseQuantity"/>
                                    </quantity>
                                    <unitOfMeasure>
                                        <xsl:call-template name="UOMTemplate_Out">
                                            <xsl:with-param name="p_UOMinput"
                                                select="Price/BaseQuantity/@unitCode"/>
                                            <xsl:with-param name="p_anERPSystemID"
                                                select="$anERPSystemID"/>
                                            <xsl:with-param name="p_anSupplierANID"
                                                select="$anSupplierANID"/>
                                        </xsl:call-template>
                                    </unitOfMeasure>
                                </baseQuantity>
                            </price>
                        </bomComponents>
                    </xsl:for-each>
                    <!-- Deleted Data-->
                    <xsl:if test="string-length(normalize-space($v_ddata)) > 0">
                        <deletedData>
                            <xsl:if test="string-length(normalize-space($v_dbom)) > 0">
                                <!-- Deleted BOM -->
                                <deletedBOM>
                                    <material>
                                        <xsl:value-of select="$v_dbom/Material"/>
                                    </material>

                                    <bomNo>
                                        <xsl:value-of select="$v_dbom/BOMNo"/>
                                    </bomNo>
                                    <alternativeBOM>
                                        <xsl:value-of select="$v_dbom/AlternativeBOM"/>
                                    </alternativeBOM>

                                    <usage>
                                        <xsl:value-of select="$v_dbom/Usage"/>
                                    </usage>

                                    <xsl:if
                                        test="string-length(normalize-space($v_dbom/ValidFromDate)) > 0">

                                        <validFromDate>
                                            <xsl:variable name="v_vfrdb_date">
                                                <xsl:value-of
                                                  select='translate(substring($v_dbom/ValidFromDate, 1, 10), "-", "")'
                                                />
                                            </xsl:variable>

                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date" select="$v_vfrdb_date"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>

                                        </validFromDate>

                                    </xsl:if>

                                    <xsl:if
                                        test="string-length(normalize-space($v_dbom/ValidToDate)) > 0">

                                        <validToDate>

                                            <xsl:variable name="v_vtodb_date">
                                                <xsl:value-of
                                                  select='translate(substring($v_dbom/ValidToDate, 1, 10), "-", "")'
                                                />
                                            </xsl:variable>

                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date" select="$v_vtodb_date"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>

                                        </validToDate>
                                    </xsl:if>

                                </deletedBOM>
                            </xsl:if>

                            <!-- Deleted Plants -->

                            <xsl:for-each select="BOM/DeletedData/DeletedPlant">
                                <xsl:if test="string-length(normalize-space(Plant)) > 0">
                                    <deletedPlants>
                                        <plantId>
                                            <xsl:value-of select="Plant"/>
                                        </plantId>
                                    </deletedPlants>
                                </xsl:if>
                            </xsl:for-each>

                            <!-- Deleted BOM Components -->
                            <xsl:for-each select="BOM/DeletedData/DeletedBOMComponent">
                                <deletedComponents>
                                    
                                    <xsl:if test="string-length(normalize-space(Material)) > 0">
                                        <material>
                                            <xsl:value-of select="Material"/>
                                        </material>
                                    </xsl:if>
                                    
                                    <itemNodeNumber>
                                        <xsl:value-of select="ItemNodeNumber"/>
                                    </itemNodeNumber>

                                    <xsl:if test="string-length(normalize-space(ValidFromDate)) > 0">
                                        <validFromDate>

                                            <xsl:variable name="v_vfrdc_date">
                                                <xsl:value-of
                                                  select='translate(substring(ValidFromDate, 1, 10), "-", "")'
                                                />
                                            </xsl:variable>

                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date" select="$v_vfrdc_date"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>

                                        </validFromDate>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(ValidToDate)) > 0">
                                        <validToDate>

                                            <xsl:variable name="v_vtodc_date">
                                                <xsl:value-of
                                                  select='translate(substring(ValidToDate, 1, 10), "-", "")'
                                                />
                                            </xsl:variable>

                                            <xsl:call-template name="ANDateTime">
                                                <xsl:with-param name="p_date" select="$v_vtodc_date"/>
                                                <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                            </xsl:call-template>

                                        </validToDate>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(ChangeNo)) > 0">
                                        <changeNumber>
                                            <xsl:value-of select="ChangeNo"/>
                                        </changeNumber>
                                    </xsl:if>
                                </deletedComponents>

                            </xsl:for-each>

                        </deletedData>

                    </xsl:if>

                </boms>

            </bomRequest>
        </root>
    </xsl:template>
</xsl:stylesheet>
