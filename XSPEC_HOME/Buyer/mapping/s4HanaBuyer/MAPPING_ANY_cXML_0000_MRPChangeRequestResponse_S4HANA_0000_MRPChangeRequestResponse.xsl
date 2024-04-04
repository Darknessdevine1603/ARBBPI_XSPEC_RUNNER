<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:n0="http://sap.com/xi/SAPGlobal20/Global"
    xmlns:hci="http://sap.com/it/"
    xmlns:xop="http://www.w3.org/2004/08/xop/include"
    xmlns:n1="http://sap.com/xi/APPL/Global2"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
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
    <xsl:template match="root">
        <n0:MRPChangeRequestResponse>
            <MessageHeader>
                <ID>
                    <xsl:value-of
                        select="substring(substring-before(changeRequestResponse/requestInfo/payloadID,'@'), 1,35)"
                    />
                </ID>
                <CreationDateTime>
                    <xsl:value-of select="changeRequestResponse/requestInfo/creationDateTime"/>
                </CreationDateTime>
                <SenderBusinessSystemID>
                    <xsl:value-of select="changeRequestResponse/requestInfo/parties[type = 'ToParty']/systemID"/>
                </SenderBusinessSystemID>
            </MessageHeader>
                 <xsl:variable name="v_po">
                     <xsl:value-of select="changeRequestResponse/changeRequestResponseDocuments/documentReference/documentNumber"/>
                </xsl:variable>
            <xsl:for-each select="changeRequestResponse/changeRequestResponseDocuments/itemReferences">
                <xsl:variable name="v_po_item">
                    <xsl:value-of select="lineNumber"/>
                </xsl:variable>                   
                <xsl:variable name="v_plant">
                    <xsl:value-of select="plantID"/>
                </xsl:variable>    
                <xsl:variable name="v_part">
                    <xsl:value-of select="partID"/>
                </xsl:variable> 
                <xsl:for-each-group select="scheduleLineReferences" group-by="changeRequestUUID">
                    <MRPChangeRequestResponse>
                        <ChangeRequestUUID>
                            <xsl:value-of select="changeRequestUUID"/>
                        </ChangeRequestUUID>
                        <MRPElement>
                            <xsl:value-of select="$v_po"/>
                        </MRPElement>
                        <MRPElementItem>
                            <xsl:value-of select="$v_po_item"/>
                        </MRPElementItem>
                        <MRPPlant>
                            <xsl:value-of select="$v_plant"/>
                        </MRPPlant>
                        <Material>
                            <xsl:value-of select="$v_part"/>
                        </Material>
                        <ChangeRequestSupplierResponse>
                            <xsl:variable name="v_status">
                                <xsl:value-of select="status"/>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="status = 'alternateProposal'">
                                    <xsl:value-of select="'03'"/>
                                </xsl:when>
                                <xsl:when test="status = 'approve'">
                                    <xsl:value-of select="'01'"/>
                                </xsl:when>
                                <xsl:when test="status = 'reject'">
                                    <xsl:value-of select="'02'"/>
                                </xsl:when>
                            </xsl:choose>
                        </ChangeRequestSupplierResponse>
                        <xsl:if test="string-length(comments) > 0">                    
                            <ChangeRequestNote>
                                <xsl:value-of select="comments"/>
                            </ChangeRequestNote>
                        </xsl:if>
                        <xsl:if test="(//root/changeRequestResponse/requestInfo/parties[type = 'FromParty']/translate(domain,'VENDORID','vendorid')) = 'vendorid'">   <!-- IG-31370 -->
                            <Supplier>
                                <xsl:value-of select="//root/changeRequestResponse/requestInfo/parties[type = 'FromParty']/identity"/>
                            </Supplier>
                        </xsl:if>
                        <SupplierPlant>
                            <!-- Not available -->
                        </SupplierPlant>
                        <xsl:for-each select="current-group()">
                        <ChangeRequestResponseScheduleLine>
                            <MRPElementScheduleLine>
                                <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(changeReqRespLineNumber)) > 0 and changeReqRespLineNumber != 1">
                                        <xsl:value-of select="'0000'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="scheduleLineNumber"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </MRPElementScheduleLine>
                            <xsl:if test="string-length(requestedChangeQuantity) > 0">
                                <ProposedDeliveryQuantity>
                                    <xsl:attribute name="n1:unitCode" select="requestedChangeQuantity/unitOfMeasure"/>
                                    <xsl:value-of select="requestedChangeQuantity/quantity"/>
                                </ProposedDeliveryQuantity>
                            </xsl:if>   
                            <xsl:if test="string-length(deliveryDate/requestedChangeDeliveryDate) > 0">
                                <ProposedDeliveryDate>
                                    <xsl:value-of select="substring(deliveryDate/requestedChangeDeliveryDate,0,11)"/>                            
                                </ProposedDeliveryDate>
                                <ProposedDeliveryDateTime>
                                    <xsl:value-of select="deliveryDate/requestedChangeDeliveryDate"/>
                                </ProposedDeliveryDateTime>
                            </xsl:if>  
                        </ChangeRequestResponseScheduleLine>
                        </xsl:for-each>
                        <xsl:if test="string-length(cost/price) > 0">                    
                            <ChangeRequestCostOfChange>
                                <xsl:attribute name="currencyCode" select="cost/currency"/>    
                                <xsl:value-of select="cost/price"/>                        
                            </ChangeRequestCostOfChange>
                        </xsl:if>
                        <xsl:if test="string-length(rejectionReasonCode) > 0">                    
                            <ChangeRequestRejectionCode>
                                <xsl:value-of select="rejectionReasonCode"/>
                            </ChangeRequestRejectionCode>
                        </xsl:if>
                    </MRPChangeRequestResponse>
                </xsl:for-each-group>
            </xsl:for-each>
        </n0:MRPChangeRequestResponse>
        
    </xsl:template>
</xsl:stylesheet>
