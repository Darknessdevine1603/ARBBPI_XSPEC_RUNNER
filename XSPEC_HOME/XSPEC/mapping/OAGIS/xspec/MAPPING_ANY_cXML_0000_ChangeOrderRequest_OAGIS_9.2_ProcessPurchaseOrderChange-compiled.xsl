<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 6">
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
      <xsl:message>Order Request Multi Comments</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Multi Comments</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeSender"
                       select="'081466849T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeReceiver"
                       select="'658731930T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:variable name="Q{}anCRFlag" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequestMultiComments_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d58e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequestMultiComments_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d58e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d58e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d58e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d58e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d58e0"/>
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
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Order Request Multi Comments</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d56e9-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/OrderRequest/OrderRequestMultiComments_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d56e9"
                    select="$Q{urn:x-xspec:compile:impl}expect-d56e9-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d56e9, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Multi Comments</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d56e9"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Order Request with Attachment</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request with Attachment</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeSender"
                       select="'OAGISBuyer32'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeReceiver"
                       select="'658731930T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCRFlag"
                       select="'Yes'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT4_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d74e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT4_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d74e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d74e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d74e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d74e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d74e0"/>
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
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Order Request with Attachment</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d56e17-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/OrderRequest/OrderRequest_RIT4_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d56e17"
                    select="$Q{urn:x-xspec:compile:impl}expect-d56e17-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d56e17, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request with Attachment</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d56e17"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Order Request Delete</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Delete</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeSender"
                       select="'OAGISBuyer32'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeReceiver"
                       select="'658731930T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCRFlag"
                       select="'Yes'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT5_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d90e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT5_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d90e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d90e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d90e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d90e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d90e0"/>
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
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Order Request Delete</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d56e25-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/OrderRequest/OrderRequest_RIT5_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d56e25"
                    select="$Q{urn:x-xspec:compile:impl}expect-d56e25-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d56e25, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Delete</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d56e25"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Order Request Change Copy PO</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Change Copy PO </xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeSender"
                       select="'OAGISBuyer32'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeReceiver"
                       select="'658731930T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anCRFlag"
                       select="'Yes'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT6_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d106e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT6_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d106e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d106e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d106e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d106e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d106e0"/>
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
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
            <xsl:with-param name="Q{}anCRFlag" select="$Q{}anCRFlag"/>
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
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Order Request Change Copy PO</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d56e33-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/OrderRequest/OrderRequest_RIT6_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d56e33"
                    select="$Q{urn:x-xspec:compile:impl}expect-d56e33-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d56e33, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Change Copy PO</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d56e33"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Order Request Change PO</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Change PO</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeSender"
                       select="'OAGISBuyer32'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeReceiver"
                       select="'658731930T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:variable name="Q{}anCRFlag" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT6_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d122e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT6_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d122e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d122e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d122e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d122e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d122e0"/>
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
            <xsl:with-param name="Q{}anAlternativeSender" select="$Q{}anAlternativeSender"/>
            <xsl:with-param name="Q{}anAlternativeReceiver" select="$Q{}anAlternativeReceiver"/>
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
            <xsl:with-param name="Q{}anCRFlag" select="$Q{}anCRFlag"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Order Request Change PO</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d56e41-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/OrderRequest/OrderRequest_RIT6A_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d56e41"
                    select="$Q{urn:x-xspec:compile:impl}expect-d56e41-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d56e41, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Change PO</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d56e41"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Order Request Change</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Change</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeSender"
                       select="'OAGISBuyer32'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternativeReceiver"
                       select="'658731930T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:variable name="Q{}anCRFlag" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT7_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d138e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/OrderRequest/OrderRequest_RIT7_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d138e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d138e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d138e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_cXML_0000_ChangeOrderRequest_OAGIS_9.2_ProcessPurchaseOrderChange.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anAlternativeSender')" select="$Q{}anAlternativeSender"/>
                        <xsl:map-entry key="QName('', 'anAlternativeReceiver')"
                                       select="$Q{}anAlternativeReceiver"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d138e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d138e0"/>
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
            <xsl:with-param name="Q{}anAlternativeSender" select="$Q{}anAlternativeSender"/>
            <xsl:with-param name="Q{}anAlternativeReceiver" select="$Q{}anAlternativeReceiver"/>
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
            <xsl:with-param name="Q{}anCRFlag" select="$Q{}anCRFlag"/>
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
      <xsl:param name="Q{}anAlternativeSender" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternativeReceiver" as="item()*" required="yes"/>
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCRFlag" as="item()*" required="yes"/>
      <xsl:message>Order Request Change</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d56e49-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/OrderRequest/OrderRequest_RIT7_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d56e49"
                    select="$Q{urn:x-xspec:compile:impl}expect-d56e49-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d56e49, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Order Request Change</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d56e49"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
