<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl</xsl:attribute>
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
      <xsl:message>S4 MM Invoice Request 1</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>S4 MM Invoice Request 1</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}ancxmlversion" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{}anContentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'OLAS1'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'no'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLookUpFlag"
                       select="'no'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anUOMFlag"
                       select="'no'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoice1.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d57e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoice1.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d57e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d57e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d57e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'ancxmlversion')" select="$Q{}ancxmlversion"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anContentID')" select="$Q{}anContentID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
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
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}ancxmlversion" select="$Q{}ancxmlversion"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anContentID" select="$Q{}anContentID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}ancxmlversion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anContentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>S4 MM Invoice Request 1</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e21-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/MMInvoice/MMInvoice1.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e21"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e21-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e21, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>S4 MM Invoice Request 1</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e21"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Multiple Line Items</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Multiple Line Items</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}ancxmlversion" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable name="Q{}anContentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'OLAS1'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'FALSE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceDetailRequest'"/>
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
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d73e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d73e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d73e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d73e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'ancxmlversion')" select="$Q{}ancxmlversion"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anContentID')" select="$Q{}anContentID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
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
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}ancxmlversion" select="$Q{}ancxmlversion"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anContentID" select="$Q{}anContentID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}ancxmlversion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anContentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Multiple Line Items</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e41-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/MMInvoice/MM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e41"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e41-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e41, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Multiple Line Items</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e41"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>ERP MM Multiple Taxes</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ERP MM Multiple Taxes</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}ancxmlversion" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable name="Q{}anContentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'OLAS1'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'FALSE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceDetailRequest'"/>
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
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoiceMultipleTaxes.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d89e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoiceMultipleTaxes.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d89e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d89e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d89e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'ancxmlversion')" select="$Q{}ancxmlversion"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anContentID')" select="$Q{}anContentID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
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
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}ancxmlversion" select="$Q{}ancxmlversion"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anContentID" select="$Q{}anContentID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}ancxmlversion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anContentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>ERP MM Multiple Taxes</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e61-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/MMInvoice/MMInvoiceMultipleTaxes.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e61"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e61-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e61, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ERP MM Multiple Taxes</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e61"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>ERP MM Invoice Request for Service Items</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ERP MM Invoice Request for Service Items</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}ancxmlversion" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004404205-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable name="Q{}anContentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'OLAS1'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'FALSE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'NO'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLookUpFlag"
                       select="'NO'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anUOMFlag"
                       select="'NO'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoiceServiceItem.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d105e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoiceServiceItem.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d105e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d105e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d105e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'ancxmlversion')" select="$Q{}ancxmlversion"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anContentID')" select="$Q{}anContentID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
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
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}ancxmlversion" select="$Q{}ancxmlversion"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anContentID" select="$Q{}anContentID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}ancxmlversion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anContentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>ERP MM Invoice Request for Service Items</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e81-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/MMInvoice/MMInvoiceServiceItem.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e81"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e81-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e81, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ERP MM Invoice Request for Service Items</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e81"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>ERP MM Invoice Request for Service Items 2</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ERP MM Invoice Request for Service Items 2</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}ancxmlversion" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004404205-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable name="Q{}anContentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'OLAS1'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'InvoiceDetailRequest'"/>
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
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoiceServiceItem2.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d121e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4HanaBuyer/MMInvoice/MMInvoiceServiceItem2.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d121e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d121e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d121e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_S4HANA_0000_MMInvoice_cXML_0000_InvoiceDetailRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'ancxmlversion')" select="$Q{}ancxmlversion"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anContentID')" select="$Q{}anContentID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
                        <xsl:map-entry key="QName('', 'anLookUpFlag')" select="$Q{}anLookUpFlag"/>
                        <xsl:map-entry key="QName('', 'anUOMFlag')" select="$Q{}anUOMFlag"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
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
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}ancxmlversion" select="$Q{}ancxmlversion"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anContentID" select="$Q{}anContentID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}ancxmlversion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anContentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>ERP MM Invoice Request for Service Items 2</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d55e101-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4HanaBuyer/MMInvoice/MMInvoiceServiceItem2.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d55e101"
                    select="$Q{urn:x-xspec:compile:impl}expect-d55e101-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d55e101, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ERP MM Invoice Request for Service Items 2</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d55e101"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
