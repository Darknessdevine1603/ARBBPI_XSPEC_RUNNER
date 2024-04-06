<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/SAPGlobal20/Global"
    xmlns:hci="http://sap.com/it/"
    xmlns:xop="http://www.w3.org/2004/08/xop/include"
    xmlns:n1="http://sap.com/xi/PP/Global2"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:include href="../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl"/>
    <!--        <xsl:include href="FORMAT_S4HANA_0000_cXML_0000.xsl"/>-->
    <xsl:param name="anIsMultiERP"/>
    <xsl:param name="anERPTimeZone"/>
    <xsl:param name="anSupplierANID"/>
    <xsl:param name="anSenderID"/>
    <xsl:param name="anERPSystemID"/>
    <xsl:param name="anTargetDocumentType"/>
    <xsl:param name="anSourceDocumentType"/>
    <xsl:param name="anProviderANID"/>
    <xsl:param name="anPayloadID"/>
    <xsl:param name="anEnvName"/>
    <xsl:param name="anAddOnCIVersion"/>
    <xsl:variable name="v_pd">
        <xsl:call-template name="PrepareCrossref">
            <xsl:with-param name="p_doctype" select="$anTargetDocumentType"/>
            <xsl:with-param name="p_erpsysid" select="$anERPSystemID"/>
            <xsl:with-param name="p_ansupplierid" select="$anSupplierANID"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="v_header" select="/n0:MRPChangeRequest/MessageHeader"/>
    <xsl:variable name="v_vendorID" select="/n0:MRPChangeRequest/MRPChangeRequestOut[1]/Supplier"/>
    <xsl:template match="n0:MRPChangeRequest">
        <root>
            <changeRequest>
                <requestInfo>
                    <payloadID>
                        <xsl:value-of select="$v_header/ID"/>
                    </payloadID>
                    <creationDateTime>
                        <xsl:value-of select = "concat(substring($v_header/CreationDateTime,0,20), '+00:00')"/>
                    </creationDateTime>
                    <parties>
                        <type>FromParty</type>
                        <domain>NetworkID</domain>
                        <identity>
                            <xsl:value-of select="$anSenderID"/>
                        </identity>
<!--                        IG-33042-->
                            <xsl:if test="upper-case($anIsMultiERP) = 'TRUE'">
                                <systemID>
                                <xsl:value-of select="$v_header/SenderBusinessSystemID"/>
                                </systemID>
                            </xsl:if>                        
                        <endpointID>
                            <xsl:value-of select="'CIG'"/>
                        </endpointID>
                    </parties>
                    <parties>
                        <type>ToParty</type>
                        <domain>VendorID</domain>
                        <identity>
                            <xsl:value-of select="$v_vendorID"/>
                        </identity>
                    </parties>
                    <parties>
                        <type>SenderParty</type>
                        <domain>NetworkID</domain>
                        <identity>
                            <xsl:value-of select="$anProviderANID"/>
                        </identity>
                    </parties>
                </requestInfo>
                <xsl:for-each-group select="MRPChangeRequestOut" group-by="MRPElement">
                    <changeRequestDocuments>
                        <companyCode>
                            <xsl:value-of select="CompanyCode"/>
                        </companyCode>
                        <vendorID>
                            <xsl:value-of select="$v_vendorID"/>
                        </vendorID>                         
                        <documentReference>
<!--   CI-2112 Timezone changes                         -->
                            <documentDate>
                                  <xsl:choose>
                                      <xsl:when test="string-length(MRPElementCreationDateTime) > 0"> 
                                          <xsl:value-of select="MRPElementCreationDateTime"/>
                                      </xsl:when>
                                      <xsl:otherwise>
                                          <xsl:if test="string-length(MRPElementCreationDate) > 0">
                                          <xsl:call-template name="ANDateTime_S4HANA_V1">
                                              <!-- IG-31370 -->
                                              <xsl:with-param name="p_date"
                                                  select="MRPElementCreationDate"/>
                                              <xsl:with-param name="p_time" select="''"/>
                                              <xsl:with-param name="p_timezone"
                                                  select="$anERPTimeZone"/>
                                          </xsl:call-template>
                                          </xsl:if>
                                      </xsl:otherwise>
                                  </xsl:choose>                                
                            </documentDate>
                            <documentNumber>
                                <xsl:value-of select="MRPElement"/>
                            </documentNumber>                           
                        </documentReference>
                        <xsl:for-each-group select="current-group ()"
                            group-by="MRPElementItem">
                        <itemReferences>
                            <lineNumber>
                                <xsl:value-of select="MRPElementItem"/>
                            </lineNumber>
                            <partID>
                                <xsl:value-of select="Material"/>
                            </partID>
                            <plantID>
                                <xsl:value-of select="MRPPlant"/>
                            </plantID>
                            <xsl:if test="string-length(MRPController) > 0">                            
                                <mrpController>
                                    <xsl:value-of select="MRPController"/>                              
                                </mrpController>
                            </xsl:if>
                            <xsl:if test="string-length(SupplierMaterialNumber) > 0">                             
                                <vendorPartID>
                                    <xsl:value-of select="SupplierMaterialNumber"/> 
                                </vendorPartID>
                            </xsl:if>
                            <xsl:for-each-group select="current-group ()"
                                group-by="MRPElementScheduleLine">
                            <scheduleLineReferences>
                                <scheduleLineNumber>
                                    <xsl:value-of select="MRPElementScheduleLine"/>
                                </scheduleLineNumber>
                                <changeRequestUUID>
                                    <xsl:value-of select="ChangeRequestUUID"/>
                                </changeRequestUUID>
                                <xsl:if test="string-length(MRPChangeRequestPriorityCode) > 0">                                 
                                    <priority>
                                        <xsl:value-of select="MRPChangeRequestPriorityCode"/>
                                    </priority>
                                </xsl:if>
                                    <originalQuantity>
                                        <quantity>
                                            <xsl:value-of select="OriginalTotalQuantityInOrderUnit"/>
                                        </quantity>
                                            <unitOfMeasure>
                                                <xsl:value-of select="OriginalTotalQuantityInOrderUnit/@n1:unitCode"/>
                                            </unitOfMeasure>
                                    </originalQuantity>
                                    <requestedChangeQuantity>
                                        <quantity>
                                            <xsl:value-of select="RequestedTotalQuantityInOrderUnit"/>
                                        </quantity>
                                        <unitOfMeasure>
                                            <xsl:value-of select="RequestedTotalQuantityInOrderUnit/@n1:unitCode"/>
                                        </unitOfMeasure>
                                    </requestedChangeQuantity>
                                <deliveryDate>
                                    <originalDeliveryDate>
  <!--   CI-2112 Timezone changes                         -->
                                        <xsl:choose>
                                            <xsl:when test="string-length(OriginalDeliveryDateTime) > 0">
                                                <xsl:value-of select="OriginalDeliveryDateTime"/> 
                                            </xsl:when>
                                       <xsl:otherwise>
                                        <xsl:if test="string-length(OriginalDeliveryDate) > 0">
                                            <xsl:call-template name="ANDateTime_S4HANA_V1">                  <!-- IG-31370 -->
                                                <xsl:with-param name="p_date" select="OriginalDeliveryDate"/>
                                                <xsl:with-param name="p_time" select="''"/>
                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                       </xsl:otherwise>
                                        </xsl:choose>
                                    </originalDeliveryDate>
                                    <requestedChangeDeliveryDate>
      <!--   CI-2112 Timezone changes                         -->
                                        <xsl:choose>
                                            <xsl:when test="string-length(RequestedDeliveryDateTime) > 0">
                                                <xsl:value-of select="RequestedDeliveryDateTime"/> 
                                            </xsl:when>
                                            <xsl:otherwise>
                                        <xsl:if test="string-length(RequestedDeliveryDate) > 0">
                                            <xsl:call-template name="ANDateTime_S4HANA_V1">                   <!-- IG-31370 -->
                                                <xsl:with-param name="p_date" select="RequestedDeliveryDate"/>
                                                <xsl:with-param name="p_time" select="''"/>
                                                <xsl:with-param name="p_timezone" select="$anERPTimeZone"/>
                                            </xsl:call-template> 
                                        </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </requestedChangeDeliveryDate>
                                </deliveryDate>
                                <xsl:if test="string-length(MRPChangeRequestReasonCode) > 0">                                
                                    <reasonCode>
                                        <xsl:value-of select="MRPChangeRequestReasonCode"/>
                                    </reasonCode>
                                </xsl:if>
                                <comments>
                                    <xsl:value-of select="ChangeRequestNote"/>
                                </comments>
                            </scheduleLineReferences>
                            </xsl:for-each-group>
                        </itemReferences>
                        </xsl:for-each-group>
                    </changeRequestDocuments>
                </xsl:for-each-group>           
            </changeRequest>
        </root>
    </xsl:template>
</xsl:stylesheet>
