<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 10">
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
                  <xsl:when test=". eq 6">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6"/>
                  </xsl:when>
                  <xsl:when test=". eq 7">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7"/>
                  </xsl:when>
                  <xsl:when test=". eq 8">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8"/>
                  </xsl:when>
                  <xsl:when test=". eq 9">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9"/>
                  </xsl:when>
                  <xsl:when test=". eq 10">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10"/>
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
      <xsl:message>Invoice Request - Invoice with Goods receipt</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Invoice with Goods receipt</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_B_GR_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d62e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_B_GR_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d62e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d62e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d62e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d62e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d62e0"/>
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
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
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
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Invoice with Goods receipt</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e11-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/INV_B_GR_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e11"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e11-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e11, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Invoice with Goods receipt</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e11"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Invoice Lean Service</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Invoice Lean Service</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_4500040220_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d78e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_4500040220_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d78e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d78e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d78e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d78e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d78e0"/>
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
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
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
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Invoice Lean Service</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e21-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/INV_4500040220_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e21"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e21-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e21, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Invoice Lean Service</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e21"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Header+Item text (Multi Material/Service with/without language code)</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Header+Item text (Multi Material/Service with/without language code)</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'-08:00'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'12345'"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_header_item_text_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d94e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_header_item_text_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d94e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d94e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d94e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d94e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d94e0"/>
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
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
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
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Header+Item text (Multi Material/Service with/without language code)</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e32-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/INV_header_item_text_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e32"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e32-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e32, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Header+Item text (Multi Material/Service with/without language code)</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e32"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Header text without language code</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Header text without language code</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/Invoice_header_text_wo_lang_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d110e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/Invoice_header_text_wo_lang_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d110e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d110e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d110e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d110e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d110e0"/>
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
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
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
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Header text without language code</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e43-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/Invoice_header_text_wo_lang_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e43"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e43-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e43, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Header text without language code</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e43"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Pricing elements</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Pricing elements</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/Invoice_pricing_elements_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d126e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/Invoice_pricing_elements_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d126e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d126e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d126e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d126e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d126e0"/>
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
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
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
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Pricing elements</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e53-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/Invoice_pricing_elements_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e53"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e53-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e53, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Pricing elements</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e53"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Multiple IBD</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Multiple IBD</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable name="Q{}anSourceDocumentType" select="()"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_3232_multiple_IBD_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d142e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_3232_multiple_IBD_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d142e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d142e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d142e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d142e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d142e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Multiple IBD</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e63-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/INV_3232_multiple_IBD_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e63"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e63-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e63, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Multiple IBD</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e63"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Credit Memo</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Credit Memo</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'12345'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/CreditMemo_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d158e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/CreditMemo_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d158e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d158e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d158e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d158e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d158e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Credit Memo</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e74-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/CreditMemo_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e74"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e74-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e74, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Credit Memo</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e74"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Service Tax</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Service Tax</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'12345'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_Service_Tax_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d174e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_Service_Tax_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d174e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d174e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d174e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d174e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d174e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Service Tax</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e85-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/INV_Service_Tax_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e85"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e85-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e85, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Service Tax</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e85"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - SoldTo</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - SoldTo</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'12345'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_SoldTo_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d190e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_SoldTo_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d190e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d190e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d190e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d190e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d190e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - SoldTo</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e96-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/INV_SoldTo_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e96"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e96-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e96, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - SoldTo</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e96"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Invoice Request - Cancellation of Supplier Invoice</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario10</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Cancellation of Supplier Invoice</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'InvoiceDetailRequest'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'12345'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCrossRefFlag"
                       select="'YES'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_Cancel_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d206e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/InvoiceRequest/INV_Cancel_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d206e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d206e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d206e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_InvoiceDetailRequest_S4HANA_0000_invoicerequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anCrossRefFlag')" select="$Q{}anCrossRefFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d206e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d206e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:message>Invoice Request - Cancellation of Supplier Invoice</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e107-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/InvoiceRequest/INV_Cancel_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e107"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e107-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e107, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario10-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Invoice Request - Cancellation of Supplier Invoice</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e107"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
