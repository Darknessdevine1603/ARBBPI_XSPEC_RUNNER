<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 4">
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
      <xsl:message>Scenario 1 for ServiceEntrySheet</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 1 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}id"
                       select="'x'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ServiceEntrySheetRequest'"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+01:30'"/>
         <xsl:variable name="Q{}UOMinput" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable name="Q{}anCorrelationID" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_1_pre.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d56e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_1_pre.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d56e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d56e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d56e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'id')" select="$Q{}id"/>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'UOMinput')" select="$Q{}UOMinput"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anCorrelationID')" select="$Q{}anCorrelationID"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d56e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d56e0"/>
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
            <xsl:with-param name="Q{}id" select="$Q{}id"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}UOMinput" select="$Q{}UOMinput"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCorrelationID" select="$Q{}anCorrelationID"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
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
      <xsl:param name="Q{}id" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}UOMinput" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCorrelationID" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:message>Scenario 1 for ServiceEntrySheet</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e15-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_1_out.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e15"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e15-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e15, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 1 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e15"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario 2 for ServiceEntrySheet</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 2 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ServiceEntrySheetRequest'"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+01:30'"/>
         <xsl:variable name="Q{}UOMinput" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable name="Q{}anCorrelationID" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_2_pre.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d72e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_2_pre.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d72e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d72e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d72e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'UOMinput')" select="$Q{}UOMinput"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anCorrelationID')" select="$Q{}anCorrelationID"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d72e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d72e0"/>
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
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}UOMinput" select="$Q{}UOMinput"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCorrelationID" select="$Q{}anCorrelationID"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
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
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}UOMinput" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCorrelationID" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:message>Scenario 2 for ServiceEntrySheet</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e29-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_2_out.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e29"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e29-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e29, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 2 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e29"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario 3 for ServiceEntrySheet</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 3 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ServiceEntrySheetRequest'"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+01:30'"/>
         <xsl:variable name="Q{}UOMinput" select="()"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable name="Q{}anCorrelationID" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_3_pre.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d88e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_3_pre.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d88e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d88e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d88e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'UOMinput')" select="$Q{}UOMinput"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anCorrelationID')" select="$Q{}anCorrelationID"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d88e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d88e0"/>
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
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}UOMinput" select="$Q{}UOMinput"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCorrelationID" select="$Q{}anCorrelationID"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
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
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}UOMinput" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCorrelationID" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:message>Scenario 3 for ServiceEntrySheet</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e43-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_3_out.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e43"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e43-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e43, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 3 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e43"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario 4 for ServiceEntrySheet</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 4 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anLocalTesting"
                       select="'YES'"/>
         <xsl:variable name="Q{}anReceiverID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ServiceEntrySheetRequest'"/>
         <xsl:variable name="Q{}anERPSystemID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+01:30'"/>
         <xsl:variable name="Q{}UOMinput" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}cXMLAttachments"
                       select="'YES'"/>
         <xsl:variable name="Q{}anCorrelationID" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_4_Mixed.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d104e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_4_Mixed.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d104e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d104e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d104e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4HanaBuyer/MAPPING_ANY_cXML_0000_ServiceEntrySheet_S4HANA_0000_ServiceEntrySheetRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anLocalTesting')" select="$Q{}anLocalTesting"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'UOMinput')" select="$Q{}UOMinput"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anCorrelationID')" select="$Q{}anCorrelationID"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d104e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d104e0"/>
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
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}UOMinput" select="$Q{}UOMinput"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anCorrelationID" select="$Q{}anCorrelationID"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
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
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}UOMinput" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCorrelationID" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:message>Scenario 4 for ServiceEntrySheet</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e57-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4HanaBuyer/ServiceEntrySheetRequest/Scenario_4_Mixed.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e57"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e57-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e57, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario 4 for ServiceEntrySheet</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e57"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>