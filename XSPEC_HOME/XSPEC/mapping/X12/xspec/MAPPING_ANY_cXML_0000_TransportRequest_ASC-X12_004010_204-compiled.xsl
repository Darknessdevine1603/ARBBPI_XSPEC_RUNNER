<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 3">
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
      <xsl:message>Transport Request</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Transport Request</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISASender"
                       select="'ARIBA'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISASenderQual"
                       select="'ZZ'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISAReceiver"
                       select="'RITSUPPL9'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISAReceiverQual"
                       select="'ZZ'"/>
         <xsl:variable name="Q{}anDate" select="()"/>
         <xsl:variable name="Q{}anTime" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anICNValue"
                       select="'000107835'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderGroupID"
                       select="'RITBuyer_9'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverGroupID"
                       select="'RITSUPPL9'"/>
         <xsl:variable name="Q{}segmentCount" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anCRFlag" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/X12/TransportRequest/TransportRequest_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d55e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/X12/TransportRequest/TransportRequest_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d55e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d55e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d55e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anISASender')" select="$Q{}anISASender"/>
                        <xsl:map-entry key="QName('', 'anISASenderQual')" select="$Q{}anISASenderQual"/>
                        <xsl:map-entry key="QName('', 'anISAReceiver')" select="$Q{}anISAReceiver"/>
                        <xsl:map-entry key="QName('', 'anISAReceiverQual')" select="$Q{}anISAReceiverQual"/>
                        <xsl:map-entry key="QName('', 'anDate')" select="$Q{}anDate"/>
                        <xsl:map-entry key="QName('', 'anTime')" select="$Q{}anTime"/>
                        <xsl:map-entry key="QName('', 'anICNValue')" select="$Q{}anICNValue"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anSenderGroupID')" select="$Q{}anSenderGroupID"/>
                        <xsl:map-entry key="QName('', 'anReceiverGroupID')" select="$Q{}anReceiverGroupID"/>
                        <xsl:map-entry key="QName('', 'segmentCount')" select="$Q{}segmentCount"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anCRFlag')" select="$Q{}anCRFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d55e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d55e0"/>
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
            <xsl:with-param name="Q{}anISASender" select="$Q{}anISASender"/>
            <xsl:with-param name="Q{}anISASenderQual" select="$Q{}anISASenderQual"/>
            <xsl:with-param name="Q{}anISAReceiver" select="$Q{}anISAReceiver"/>
            <xsl:with-param name="Q{}anISAReceiverQual" select="$Q{}anISAReceiverQual"/>
            <xsl:with-param name="Q{}anDate" select="$Q{}anDate"/>
            <xsl:with-param name="Q{}anTime" select="$Q{}anTime"/>
            <xsl:with-param name="Q{}anICNValue" select="$Q{}anICNValue"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anSenderGroupID" select="$Q{}anSenderGroupID"/>
            <xsl:with-param name="Q{}anReceiverGroupID" select="$Q{}anReceiverGroupID"/>
            <xsl:with-param name="Q{}segmentCount" select="$Q{}segmentCount"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anCRFlag" select="$Q{}anCRFlag"/>
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
      <xsl:param name="Q{}anISASender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISASenderQual" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISAReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISAReceiverQual" as="item()*" required="yes"/>
      <xsl:param name="Q{}anDate" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTime" as="item()*" required="yes"/>
      <xsl:param name="Q{}anICNValue" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}segmentCount" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Transport Request</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d53e19-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/X12/TransportRequest/TransportRequest_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d53e19"
                    select="$Q{urn:x-xspec:compile:impl}expect-d53e19-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d53e19, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Transport Request</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d53e19"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Transport Request</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Transport Request</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISASender"
                       select="'ARIBA'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISASenderQual"
                       select="'ZZ'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISAReceiver"
                       select="'RITSUPPL9'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISAReceiverQual"
                       select="'ZZ'"/>
         <xsl:variable name="Q{}anDate" select="()"/>
         <xsl:variable name="Q{}anTime" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anICNValue"
                       select="'000107835'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{}anSenderGroupID" select="()"/>
         <xsl:variable name="Q{}anReceiverGroupID" select="()"/>
         <xsl:variable name="Q{}segmentCount" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anCRFlag" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/X12/TransportRequest/TransportRequestIncoterms_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d71e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/X12/TransportRequest/TransportRequestIncoterms_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d71e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d71e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d71e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anISASender')" select="$Q{}anISASender"/>
                        <xsl:map-entry key="QName('', 'anISASenderQual')" select="$Q{}anISASenderQual"/>
                        <xsl:map-entry key="QName('', 'anISAReceiver')" select="$Q{}anISAReceiver"/>
                        <xsl:map-entry key="QName('', 'anISAReceiverQual')" select="$Q{}anISAReceiverQual"/>
                        <xsl:map-entry key="QName('', 'anDate')" select="$Q{}anDate"/>
                        <xsl:map-entry key="QName('', 'anTime')" select="$Q{}anTime"/>
                        <xsl:map-entry key="QName('', 'anICNValue')" select="$Q{}anICNValue"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anSenderGroupID')" select="$Q{}anSenderGroupID"/>
                        <xsl:map-entry key="QName('', 'anReceiverGroupID')" select="$Q{}anReceiverGroupID"/>
                        <xsl:map-entry key="QName('', 'segmentCount')" select="$Q{}segmentCount"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anCRFlag')" select="$Q{}anCRFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d71e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d71e0"/>
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
            <xsl:with-param name="Q{}anISASender" select="$Q{}anISASender"/>
            <xsl:with-param name="Q{}anISASenderQual" select="$Q{}anISASenderQual"/>
            <xsl:with-param name="Q{}anISAReceiver" select="$Q{}anISAReceiver"/>
            <xsl:with-param name="Q{}anISAReceiverQual" select="$Q{}anISAReceiverQual"/>
            <xsl:with-param name="Q{}anDate" select="$Q{}anDate"/>
            <xsl:with-param name="Q{}anTime" select="$Q{}anTime"/>
            <xsl:with-param name="Q{}anICNValue" select="$Q{}anICNValue"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anSenderGroupID" select="$Q{}anSenderGroupID"/>
            <xsl:with-param name="Q{}anReceiverGroupID" select="$Q{}anReceiverGroupID"/>
            <xsl:with-param name="Q{}segmentCount" select="$Q{}segmentCount"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anCRFlag" select="$Q{}anCRFlag"/>
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
      <xsl:param name="Q{}anISASender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISASenderQual" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISAReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISAReceiverQual" as="item()*" required="yes"/>
      <xsl:param name="Q{}anDate" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTime" as="item()*" required="yes"/>
      <xsl:param name="Q{}anICNValue" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}segmentCount" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Transport Request</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d53e37-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/X12/TransportRequest/TransportRequestIncoterms_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d53e37"
                    select="$Q{urn:x-xspec:compile:impl}expect-d53e37-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d53e37, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Transport Request</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d53e37"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Transport Request Delete</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Transport Request Delete</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISASender"
                       select="'ARIBA'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISASenderQual"
                       select="'ZZ'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISAReceiver"
                       select="'RITSUPPL9'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anISAReceiverQual"
                       select="'ZZ'"/>
         <xsl:variable name="Q{}anDate" select="()"/>
         <xsl:variable name="Q{}anTime" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anICNValue"
                       select="'000107835'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{}anSenderGroupID" select="()"/>
         <xsl:variable name="Q{}anReceiverGroupID" select="()"/>
         <xsl:variable name="Q{}segmentCount" select="()"/>
         <xsl:variable name="Q{}exchange" select="()"/>
         <xsl:variable name="Q{}anCRFlag" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/X12/TransportRequest/TransportRequestDelete_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d87e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/X12/TransportRequest/TransportRequestDelete_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d87e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d87e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d87e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/X12/MAPPING_ANY_cXML_0000_TransportRequest_ASC-X12_004010_204.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anISASender')" select="$Q{}anISASender"/>
                        <xsl:map-entry key="QName('', 'anISASenderQual')" select="$Q{}anISASenderQual"/>
                        <xsl:map-entry key="QName('', 'anISAReceiver')" select="$Q{}anISAReceiver"/>
                        <xsl:map-entry key="QName('', 'anISAReceiverQual')" select="$Q{}anISAReceiverQual"/>
                        <xsl:map-entry key="QName('', 'anDate')" select="$Q{}anDate"/>
                        <xsl:map-entry key="QName('', 'anTime')" select="$Q{}anTime"/>
                        <xsl:map-entry key="QName('', 'anICNValue')" select="$Q{}anICNValue"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anSenderGroupID')" select="$Q{}anSenderGroupID"/>
                        <xsl:map-entry key="QName('', 'anReceiverGroupID')" select="$Q{}anReceiverGroupID"/>
                        <xsl:map-entry key="QName('', 'segmentCount')" select="$Q{}segmentCount"/>
                        <xsl:map-entry key="QName('', 'exchange')" select="$Q{}exchange"/>
                        <xsl:map-entry key="QName('', 'anCRFlag')" select="$Q{}anCRFlag"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d87e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d87e0"/>
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
            <xsl:with-param name="Q{}anISASender" select="$Q{}anISASender"/>
            <xsl:with-param name="Q{}anISASenderQual" select="$Q{}anISASenderQual"/>
            <xsl:with-param name="Q{}anISAReceiver" select="$Q{}anISAReceiver"/>
            <xsl:with-param name="Q{}anISAReceiverQual" select="$Q{}anISAReceiverQual"/>
            <xsl:with-param name="Q{}anDate" select="$Q{}anDate"/>
            <xsl:with-param name="Q{}anTime" select="$Q{}anTime"/>
            <xsl:with-param name="Q{}anICNValue" select="$Q{}anICNValue"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anSenderGroupID" select="$Q{}anSenderGroupID"/>
            <xsl:with-param name="Q{}anReceiverGroupID" select="$Q{}anReceiverGroupID"/>
            <xsl:with-param name="Q{}segmentCount" select="$Q{}segmentCount"/>
            <xsl:with-param name="Q{}exchange" select="$Q{}exchange"/>
            <xsl:with-param name="Q{}anCRFlag" select="$Q{}anCRFlag"/>
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
      <xsl:param name="Q{}anISASender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISASenderQual" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISAReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}anISAReceiverQual" as="item()*" required="yes"/>
      <xsl:param name="Q{}anDate" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTime" as="item()*" required="yes"/>
      <xsl:param name="Q{}anICNValue" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}segmentCount" as="item()*" required="yes"/>
      <xsl:param name="Q{}exchange" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Transport Request Delete</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d53e55-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/X12/TransportRequest/TransportRequestDelete_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d53e55"
                    select="$Q{urn:x-xspec:compile:impl}expect-d53e55-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d53e55, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Transport Request Delete</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d53e55"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
