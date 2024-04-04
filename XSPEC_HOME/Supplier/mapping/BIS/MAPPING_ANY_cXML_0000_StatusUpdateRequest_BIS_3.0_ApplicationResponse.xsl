<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/"
   exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   
   <xsl:param name="anSenderID"/>
   <xsl:param name="anReceiverID"/>
   
   <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_BIS_3.0.xml')"/>
   
   
   <!--<xsl:variable name="Lookup" select="document('LOOKUP_BIS_3.0.xml')"/>-->
   
   
   <xsl:template match="/">
      <xsl:element name="sh:StandardBusinessDocument" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2">
         <xsl:element name="sh:StandardBusinessDocumentHeader">
            <xsl:element name="sh:HeaderVersion">
               <xsl:value-of select="'1.0'"/>
            </xsl:element>
            <xsl:element name="sh:Sender">
               <xsl:element name="sh:Identifier">
                  <xsl:attribute name="Authority">
                     <xsl:value-of select="'iso6523-actorid-upis'"/>
                  </xsl:attribute>
                  <xsl:value-of select="$anSenderID"/>
               </xsl:element>
            </xsl:element>
            <xsl:element name="sh:Receiver">
               <xsl:element name="sh:Identifier">
                  <xsl:attribute name="sh:Authority">
                     <xsl:value-of select="'iso6523-actorid-upis'"/>
                  </xsl:attribute>
                  <xsl:value-of select="$anReceiverID"/>
               </xsl:element>
            </xsl:element>
            <xsl:element name="sh:DocumentIdentification">
               <xsl:element name="sh:Standard">
                  <xsl:value-of
                     select="'urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2'"
                  />
               </xsl:element>
               <xsl:element name="sh:TypeVersion">
                  <xsl:value-of select="'2.1'"/>
               </xsl:element>
               <xsl:element name="sh:InstanceIdentifier">
                  <!--Can use payloadid-->
                  <xsl:variable name="uuidsequence" select="cXML/@payloadID"/>
                  <xsl:value-of select="$uuidsequence"/>
               </xsl:element>
               <xsl:element name="sh:Type">
                  <xsl:value-of select="'ApplicationResponse'"/>
               </xsl:element>
               <xsl:element name="sh:CreationDateAndTime">
                  <xsl:value-of select="cXML/@timestamp"/>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         
         
         <ubl:ApplicationResponse
            xmlns="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"
            xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
            xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
            
            <xsl:element name="cbc:CustomizationID">
               <xsl:value-of select="'urn:fdc:peppol.eu:poacc:trns:invoice_response:3'"/>
            </xsl:element>
            <xsl:element name="cbc:ProfileID">
               <xsl:value-of select="'urn:fdc:peppol.eu:poacc:bis:invoice_response:3'"/>
            </xsl:element>
            <xsl:element name="cbc:ID">
               <xsl:value-of
                  select="/cXML/Request/StatusUpdateRequest/DocumentReference/@payloadID"/>
            </xsl:element>
            <xsl:element name="cbc:IssueDate">
               <xsl:value-of select="substring-before(cXML/@timestamp, 'T')"/>
            </xsl:element>
            <xsl:element name="cbc:IssueTime">
               <xsl:value-of select="substring-after(cXML/@timestamp, 'T')"/>
            </xsl:element>
            
            <xsl:element name="cbc:Note">
               <xsl:value-of
                  select="concat(/cXML/Request/StatusUpdateRequest/Status/@code, ' - ', /cXML/Request/StatusUpdateRequest/Status/@text, ' - ', /cXML/Request/StatusUpdateRequest/Status)"
               />
            </xsl:element>
            <xsl:element name="cac:SenderParty">
               <xsl:element name="EndpointID">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="substring-before($anSenderID, ':')"/>
                  </xsl:attribute>
                  <xsl:value-of select="substring-after($anSenderID, ':')"/>
               </xsl:element>
               <xsl:element name="cac:PartyLegalEntity">
                  <xsl:element name="cbc:RegistrationName">
                     <xsl:value-of select="$anSenderID"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
            <xsl:element name="cac:ReceiverParty">
               <xsl:element name="EndpointID">
                  <xsl:attribute name="schemeID">
                     <xsl:value-of select="substring-before($anReceiverID, ':')"/>
                  </xsl:attribute>
                  <xsl:value-of select="substring-after($anReceiverID, ':')"/>
               </xsl:element>
               <xsl:if
                  test="/cXML/Header/To/Correspondent/Contact[@role = 'correspondent']/Name != ''">
                  <xsl:element name="cac:PartyLegalEntity">
                     <xsl:element name="cbc:RegistrationName">
                        <xsl:value-of
                           select="/cXML/Header/To/Correspondent/Contact[@role = 'correspondent']/Name"
                        />
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
            </xsl:element>
            <xsl:variable name="type">
               <xsl:choose>
                  <xsl:when test="/cXML/Request/StatusUpdateRequest/InvoiceStatus/@type != ''">
                     <xsl:value-of select="/cXML/Request/StatusUpdateRequest/InvoiceStatus/@type"
                     />
                  </xsl:when>
                  <xsl:when test="/cXML/Request/StatusUpdateRequest/DocumentStatus/@type != ''">
                     <xsl:value-of
                        select="/cXML/Request/StatusUpdateRequest/DocumentStatus/@type"/>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            
            
            
            <xsl:element name="cac:DocumentResponse">
               <xsl:element name="cac:Response">
                  <xsl:element name="cbc:ResponseCode">
                     <xsl:choose>
                        <xsl:when test="$type = 'processing'">IP</xsl:when>
                        <xsl:when test="$type = 'canceled'">RE</xsl:when>
                        <xsl:when test="$type = 'reconciled'">CA</xsl:when>
                        <xsl:when test="$type = 'rejected'">RE</xsl:when>
                        <xsl:when test="$type = 'paying'">AB</xsl:when>
                        <xsl:when test="$type = 'paid'">PD</xsl:when>
                        <xsl:when test="$type = 'approved'">AP</xsl:when>
                     </xsl:choose>
                  </xsl:element>
                  <xsl:if test="/cXML/Request/StatusUpdateRequest/InvoiceStatus/Comments != ''">
                     <xsl:for-each
                        select="/cXML/Request/StatusUpdateRequest/InvoiceStatus/Comments">
                        <xsl:variable name="commentType" select="@type"/>
                        <xsl:if test="$commentType = 'Action' or $commentType = 'Reason'">
                           <xsl:element name="cac:Status">
                              <xsl:element name="cbc:StatusReasonCode">
                                 <xsl:attribute name="listID">
                                    <xsl:choose>
                                       <xsl:when test="$commentType = 'Action'"
                                          >OPActionCode</xsl:when>
                                       <xsl:when test="$commentType = 'Reason'"
                                          >OPReasonCode</xsl:when>
                                    </xsl:choose>
                                 </xsl:attribute>
                                 <xsl:variable name="comment">
                                    <xsl:value-of select="."/>
                                 </xsl:variable>
                                 <xsl:choose>
                                    <xsl:when
                                       test="$Lookup/Lookups/StatusReasonCodes/StatusReasonCode[CXMLCode = $comment]/UBL != ''">
                                       <xsl:value-of
                                          select="$Lookup/Lookups/StatusReasonCodes/StatusReasonCode[CXMLCode = $comment]/UBL"
                                       />
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:element>
                              <xsl:element name="cbc:StatusReason">
                                 <xsl:value-of select="."/>
                              </xsl:element>
                              
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:if>
                  
                  <xsl:if test="/cXML/Request/StatusUpdateRequest/DocumentStatus/Comments != ''">
                     <xsl:for-each
                        select="/cXML/Request/StatusUpdateRequest/DocumentStatus/Comments">
                        <xsl:variable name="commentType" select="@type"/>
                        <xsl:if test="$commentType = 'Action' or $commentType = 'Reason'">
                           <xsl:element name="cac:Status">
                              <xsl:element name="cbc:StatusReasonCode">
                                 <xsl:attribute name="listID">
                                    <xsl:choose>
                                       <xsl:when test="$commentType = 'Action'"
                                          >OPActionCode</xsl:when>
                                       <xsl:when test="$commentType = 'Reason'"
                                          >OPReasonCode</xsl:when>
                                    </xsl:choose>                                            
                                 </xsl:attribute>
                                 <xsl:variable name="comment">
                                    <xsl:value-of select="."/>
                                 </xsl:variable>
                                 <xsl:choose>
                                    <xsl:when
                                       test="$Lookup/Lookups/StatusReasonCodes/StatusReasonCode[CXMLCode = $comment]/UBL != ''">
                                       <xsl:value-of
                                          select="$Lookup/Lookups/StatusReasonCodes/StatusReasonCode[CXMLCode = $comment]/UBL"
                                       />
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:element>
                              <xsl:element name="cbc:StatusReason">
                                 <xsl:value-of select="."/>
                              </xsl:element>
                              
                              
                           </xsl:element>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:if>
               </xsl:element>
            </xsl:element>
            
            <xsl:variable name="ID">
               <xsl:choose>
                  <xsl:when
                     test="/cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID != ''">
                     <xsl:value-of
                        select="/cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceID"
                     />
                  </xsl:when>
                  <xsl:when
                     test="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID != ''">
                     <xsl:value-of
                        select="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentID"
                     />
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="Date">
               <xsl:choose>
                  <xsl:when
                     test="/cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceDate != ''">
                     <xsl:value-of
                        select="/cXML/Request/StatusUpdateRequest/InvoiceStatus/InvoiceIDInfo/@invoiceDate"
                     />
                  </xsl:when>
                  <xsl:when
                     test="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate != ''">
                     <xsl:value-of
                        select="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentDate"
                     />
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="DocTypeCode">
               <xsl:choose>
                  <xsl:when
                     test="/cXML/Request/StatusUpdateRequest/InvoiceStatus != ''">380</xsl:when>
                  <xsl:when
                     test="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType != ''">
                     <xsl:choose>
                        <xsl:when test="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType = 'ShipNoticeDocument'">351</xsl:when>
                        <xsl:when test="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType = 'InvoiceDetailRequest'">380</xsl:when>
                        <xsl:when test="/cXML/Request/StatusUpdateRequest/DocumentStatus/DocumentInfo/@documentType = 'ConfirmationStatusUpdate'">231</xsl:when>
                     </xsl:choose>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            
            <xsl:element name="cac:DocumentReference">
               <xsl:element name="cbc:ID">
                  <xsl:value-of select="$ID"/>
               </xsl:element>
               <xsl:if test="$Date != ''">
                  <xsl:element name="cbc:IssueDate">
                     <xsl:value-of select="substring-before($Date, 'T')"/>
                  </xsl:element>
               </xsl:if>
               <xsl:element name="cbc:DocumentTypeCode">
                  <xsl:value-of select="$DocTypeCode"/>
               </xsl:element>
               
            </xsl:element>
         </ubl:ApplicationResponse>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
