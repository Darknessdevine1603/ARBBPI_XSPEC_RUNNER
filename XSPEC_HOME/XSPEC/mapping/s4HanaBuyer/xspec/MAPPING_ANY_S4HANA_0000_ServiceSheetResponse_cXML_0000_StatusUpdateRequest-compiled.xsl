<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xspec</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}is-external"
                 as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                 select="true()"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}saxon-config"
                 as="empty-sequence()"/>
   <!-- the main template to run the suite -->
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}main"
                 as="empty-sequence()">
      <xsl:context-item use="absent"/>
      <!-- info message -->
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-version')"/>
      </xsl:message>
      <!-- set up the result document (the report) -->
      <xsl:result-document format="Q{{http://www.jenitennison.com/xslt/xspec}}xml-report-serialization-parameters">
         <xsl:element name="report" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 5">
               <xsl:choose>
                  <xsl:when test=". eq 1">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"/>
                  </xsl:when>
                  <xsl:when test=". eq 2">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"/>
                  </xsl:when>
                  <xsl:when test=". eq 3">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"/>
                  </xsl:when>
                  <xsl:when test=". eq 4">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"/>
                  </xsl:when>
                  <xsl:when test=". eq 5">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:message terminate="yes">ERROR: Unhandled scenario invocation</xsl:message>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:element>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}anERPName" select="()"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLookUpFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anUOMFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceStatusUpate'"/>
         <xsl:variable name="Q{}anSupplierANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anProviderANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderID"
                       select="'0LOI36K'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'StatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceStatusUpdate'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'+05:30'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsg_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d57e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsg_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d57e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d57e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d57e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSenderID')" select="$Q{}anSenderID"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anSenderDefaultTimeZone')"
                                       select="$Q{}anSenderDefaultTimeZone"/>
                     </xsl:map>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:choose>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of element(Q{http://saxon.sf.net/ns/configuration}configuration)"/>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of document-node(element(Q{http://saxon.sf.net/ns/configuration}configuration))"/>
                        <xsl:otherwise>
                           <xsl:message terminate="yes">ERROR: $Q{http://www.jenitennison.com/xslt/xspec}saxon-config does not appear to be a Saxon configuration</xsl:message>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:map-entry key="'cache'" select="false()"/>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')"
                                          select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d57e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d57e0"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSenderID" select="$Q{}anSenderID"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}anSenderDefaultTimeZone" select="$Q{}anSenderDefaultTimeZone"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e33-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsg_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e33"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e33-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e33, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e33"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate Cancel</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate Cancel</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}anERPName" select="()"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLookUpFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anUOMFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceStatusUpate'"/>
         <xsl:variable name="Q{}anSupplierANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anProviderANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}Document_type" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceStatusUpdate'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'+05:30'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgCancel_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d73e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgCancel_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d73e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d73e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d73e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSenderID')" select="$Q{}anSenderID"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anSenderDefaultTimeZone')"
                                       select="$Q{}anSenderDefaultTimeZone"/>
                     </xsl:map>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:choose>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of element(Q{http://saxon.sf.net/ns/configuration}configuration)"/>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of document-node(element(Q{http://saxon.sf.net/ns/configuration}configuration))"/>
                        <xsl:otherwise>
                           <xsl:message terminate="yes">ERROR: $Q{http://www.jenitennison.com/xslt/xspec}saxon-config does not appear to be a Saxon configuration</xsl:message>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:map-entry key="'cache'" select="false()"/>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')"
                                          select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d73e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d73e0"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSenderID" select="$Q{}anSenderID"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}anSenderDefaultTimeZone" select="$Q{}anSenderDefaultTimeZone"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate Cancel</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e65-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgCancel_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e65"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e65-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e65, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate Cancel</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e65"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate Process</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate Process</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}anERPName" select="()"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLookUpFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anUOMFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceStatusUpate'"/>
         <xsl:variable name="Q{}anSupplierANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anProviderANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}Document_type" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceStatusUpdate'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'+05:30'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgProcess_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d89e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgProcess_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d89e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d89e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d89e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSenderID')" select="$Q{}anSenderID"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anSenderDefaultTimeZone')"
                                       select="$Q{}anSenderDefaultTimeZone"/>
                     </xsl:map>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:choose>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of element(Q{http://saxon.sf.net/ns/configuration}configuration)"/>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of document-node(element(Q{http://saxon.sf.net/ns/configuration}configuration))"/>
                        <xsl:otherwise>
                           <xsl:message terminate="yes">ERROR: $Q{http://www.jenitennison.com/xslt/xspec}saxon-config does not appear to be a Saxon configuration</xsl:message>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:map-entry key="'cache'" select="false()"/>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')"
                                          select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d89e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d89e0"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSenderID" select="$Q{}anSenderID"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}anSenderDefaultTimeZone" select="$Q{}anSenderDefaultTimeZone"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate Process</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e97-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgProcess_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e97"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e97-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e97, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate Process</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e97"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate Approve</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate Approve</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}anERPName" select="()"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLookUpFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anUOMFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceStatusUpate'"/>
         <xsl:variable name="Q{}anSupplierANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anProviderANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}Document_type" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceStatusUpdate'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'+05:30'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgApprove_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d105e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgApprove_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d105e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d105e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d105e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSenderID')" select="$Q{}anSenderID"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anSenderDefaultTimeZone')"
                                       select="$Q{}anSenderDefaultTimeZone"/>
                     </xsl:map>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:choose>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of element(Q{http://saxon.sf.net/ns/configuration}configuration)"/>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of document-node(element(Q{http://saxon.sf.net/ns/configuration}configuration))"/>
                        <xsl:otherwise>
                           <xsl:message terminate="yes">ERROR: $Q{http://www.jenitennison.com/xslt/xspec}saxon-config does not appear to be a Saxon configuration</xsl:message>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:map-entry key="'cache'" select="false()"/>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')"
                                          select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d105e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d105e0"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSenderID" select="$Q{}anSenderID"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}anSenderDefaultTimeZone" select="$Q{}anSenderDefaultTimeZone"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate Process</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e129-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsgApprove_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e129"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e129-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e129, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate Process</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e129"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate wo ServiceEntrySheet</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate wo ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}anERPName" select="()"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLookUpFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anUOMFlag"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceStatusUpate'"/>
         <xsl:variable name="Q{}anSupplierANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anProviderANID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderID"
                       select="'0LOI36K'"/>
         <xsl:variable name="Q{}Document_type" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceStatusUpdate'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}v_lang"
                       select="'en'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsg_wo_SES_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d121e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsg_wo_SES_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d121e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d121e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d121e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_ServiceSheetResponse_cXML_0000_StatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSenderID')" select="$Q{}anSenderID"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anSenderDefaultTimeZone')"
                                       select="$Q{}anSenderDefaultTimeZone"/>
                        <xsl:map-entry key="QName('', 'v_lang')" select="$Q{}v_lang"/>
                     </xsl:map>
                  </xsl:map-entry>
                  <xsl:if test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config =&gt; exists()">
                     <xsl:choose>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of element(Q{http://saxon.sf.net/ns/configuration}configuration)"/>
                        <xsl:when test="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config instance of document-node(element(Q{http://saxon.sf.net/ns/configuration}configuration))"/>
                        <xsl:otherwise>
                           <xsl:message terminate="yes">ERROR: $Q{http://www.jenitennison.com/xslt/xspec}saxon-config does not appear to be a Saxon configuration</xsl:message>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:map-entry key="'cache'" select="false()"/>
                     <xsl:map-entry key="'vendor-options'">
                        <xsl:map>
                           <xsl:map-entry key="QName('http://saxon.sf.net/', 'configuration')"
                                          select="$Q{http://www.jenitennison.com/xslt/xspec}saxon-config"/>
                        </xsl:map>
                     </xsl:map-entry>
                  </xsl:if>
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d121e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d121e0"/>
               </xsl:map>
            </xsl:variable>
            <xsl:sequence select="transform($Q{urn:x-xspec:compile:impl}transform-options)?output"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSenderID" select="$Q{}anSenderID"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}anSenderDefaultTimeZone" select="$Q{}anSenderDefaultTimeZone"/>
            <xsl:with-param name="Q{}v_lang" select="$Q{}v_lang"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}v_lang" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e162-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/ServiceSheetResponse/ServiceEntrySheetStsNotifMsg_wo_SES_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e162"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e162-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e162, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e162"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
