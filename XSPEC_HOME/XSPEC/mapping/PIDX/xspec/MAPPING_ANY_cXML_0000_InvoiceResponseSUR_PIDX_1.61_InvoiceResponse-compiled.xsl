<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xsl</xsl:attribute>
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
      <xsl:message>Receipt Request</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Receipt Request</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anAlternativeSender" select="()"/>
         <xsl:variable name="Q{}anAlternativeReceiver" select="()"/>
         <xsl:variable name="Q{}anSenderGroupID" select="()"/>
         <xsl:variable name="Q{}anReceiverGroupID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anOrginalDocumentID"
                       select="'anOrginalDocumentID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'-08:00'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d56e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d56e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d56e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d56e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'anSenderGroupID')" select="$Q{}anSenderGroupID"/>
                        <xsl:map-entry key="QName('', 'anReceiverGroupID')" select="$Q{}anReceiverGroupID"/>
                        <xsl:map-entry key="QName('', 'anOrginalDocumentID')" select="$Q{}anOrginalDocumentID"/>
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
            <xsl:with-param name="Q{}anAlternativeSender" select="$Q{}anAlternativeSender"/>
            <xsl:with-param name="Q{}anAlternativeReceiver" select="$Q{}anAlternativeReceiver"/>
            <xsl:with-param name="Q{}anSenderGroupID" select="$Q{}anSenderGroupID"/>
            <xsl:with-param name="Q{}anReceiverGroupID" select="$Q{}anReceiverGroupID"/>
            <xsl:with-param name="Q{}anOrginalDocumentID" select="$Q{}anOrginalDocumentID"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anOrginalDocumentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>Receipt Request</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e11-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e11"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e11-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e11, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Receipt Request</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e11"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate with multiline comments</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate with multiline comments</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anAlternativeSender" select="()"/>
         <xsl:variable name="Q{}anAlternativeReceiver" select="()"/>
         <xsl:variable name="Q{}anSenderGroupID" select="()"/>
         <xsl:variable name="Q{}anReceiverGroupID" select="()"/>
         <xsl:variable name="Q{}anOrginalDocumentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'-08:00'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT1_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d72e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT1_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d72e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d72e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d72e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'anSenderGroupID')" select="$Q{}anSenderGroupID"/>
                        <xsl:map-entry key="QName('', 'anReceiverGroupID')" select="$Q{}anReceiverGroupID"/>
                        <xsl:map-entry key="QName('', 'anOrginalDocumentID')" select="$Q{}anOrginalDocumentID"/>
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
            <xsl:with-param name="Q{}anAlternativeSender" select="$Q{}anAlternativeSender"/>
            <xsl:with-param name="Q{}anAlternativeReceiver" select="$Q{}anAlternativeReceiver"/>
            <xsl:with-param name="Q{}anSenderGroupID" select="$Q{}anSenderGroupID"/>
            <xsl:with-param name="Q{}anReceiverGroupID" select="$Q{}anReceiverGroupID"/>
            <xsl:with-param name="Q{}anOrginalDocumentID" select="$Q{}anOrginalDocumentID"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anOrginalDocumentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate with multiline comments</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e21-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT1_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e21"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e21-doc ! ( * )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e21, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate with multiline comments</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e21"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate with DocumentID value</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate with DocumentID value</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anAlternativeSender" select="()"/>
         <xsl:variable name="Q{}anAlternativeReceiver" select="()"/>
         <xsl:variable name="Q{}anSenderGroupID" select="()"/>
         <xsl:variable name="Q{}anReceiverGroupID" select="()"/>
         <xsl:variable name="Q{}anOrginalDocumentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'-08:00'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT2_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d88e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT2_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d88e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d88e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d88e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'anSenderGroupID')" select="$Q{}anSenderGroupID"/>
                        <xsl:map-entry key="QName('', 'anReceiverGroupID')" select="$Q{}anReceiverGroupID"/>
                        <xsl:map-entry key="QName('', 'anOrginalDocumentID')" select="$Q{}anOrginalDocumentID"/>
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
            <xsl:with-param name="Q{}anAlternativeSender" select="$Q{}anAlternativeSender"/>
            <xsl:with-param name="Q{}anAlternativeReceiver" select="$Q{}anAlternativeReceiver"/>
            <xsl:with-param name="Q{}anSenderGroupID" select="$Q{}anSenderGroupID"/>
            <xsl:with-param name="Q{}anReceiverGroupID" select="$Q{}anReceiverGroupID"/>
            <xsl:with-param name="Q{}anOrginalDocumentID" select="$Q{}anOrginalDocumentID"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anOrginalDocumentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate with DocumentID value</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e31-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT2_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e31"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e31-doc ! ( * )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e31, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate with DocumentID value</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e31"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>InvoiceStatusUpdate with credential domain has 'DUNS'</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate with credential domain has 'DUNS'</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anAlternativeSender" select="()"/>
         <xsl:variable name="Q{}anAlternativeReceiver" select="()"/>
         <xsl:variable name="Q{}anSenderGroupID" select="()"/>
         <xsl:variable name="Q{}anReceiverGroupID" select="()"/>
         <xsl:variable name="Q{}anOrginalDocumentID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSenderDefaultTimeZone"
                       select="'-08:00'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT3_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d104e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT3_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d104e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d104e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d104e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/PIDX/MAPPING_ANY_cXML_0000_InvoiceResponseSUR_PIDX_1.61_InvoiceResponse.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'anSenderGroupID')" select="$Q{}anSenderGroupID"/>
                        <xsl:map-entry key="QName('', 'anReceiverGroupID')" select="$Q{}anReceiverGroupID"/>
                        <xsl:map-entry key="QName('', 'anOrginalDocumentID')" select="$Q{}anOrginalDocumentID"/>
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
            <xsl:with-param name="Q{}anAlternativeSender" select="$Q{}anAlternativeSender"/>
            <xsl:with-param name="Q{}anAlternativeReceiver" select="$Q{}anAlternativeReceiver"/>
            <xsl:with-param name="Q{}anSenderGroupID" select="$Q{}anSenderGroupID"/>
            <xsl:with-param name="Q{}anReceiverGroupID" select="$Q{}anReceiverGroupID"/>
            <xsl:with-param name="Q{}anOrginalDocumentID" select="$Q{}anOrginalDocumentID"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverGroupID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anOrginalDocumentID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:message>InvoiceStatusUpdate with credential domain has 'DUNS'</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d54e41-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/PIDX/StatusUpdate/InvoiceStatusUpdate_RIT3_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d54e41"
                    select="$Q{urn:x-xspec:compile:impl}expect-d54e41-doc ! ( * )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d54e41, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>InvoiceStatusUpdate with credential domain has 'DUNS'</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d54e41"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
