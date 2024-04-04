<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 2">
               <xsl:choose>
                  <xsl:when test=". eq 1">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"/>
                  </xsl:when>
                  <xsl:when test=". eq 2">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"/>
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
      <xsl:message>Component Consumption Request</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Component Consumption Request</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}output" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02003013907-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02003013906-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}param-d52e10-doc" as="document-node()">
            <xsl:document>
               <xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text>
            </xsl:document>
         </xsl:variable>
         <xsl:variable name="Q{}upperAlpha"
                       select="$Q{urn:x-xspec:compile:impl}param-d52e10-doc ! ( node() )"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}param-d52e12-doc" as="document-node()">
            <xsl:document>
               <xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text>
            </xsl:document>
         </xsl:variable>
         <xsl:variable name="Q{}lowerAlpha"
                       select="$Q{urn:x-xspec:compile:impl}param-d52e12-doc ! ( node() )"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable name="Q{}anSenderDefaultTimeZone" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}attachSeparator"
                       select="'\|'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/OAGIS/ComponentConsumption/ComponentConsumptionRequest_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d54e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/OAGIS/ComponentConsumption/ComponentConsumptionRequest_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d54e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d54e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d54e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'output')" select="$Q{}output"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'upperAlpha')" select="$Q{}upperAlpha"/>
                        <xsl:map-entry key="QName('', 'lowerAlpha')" select="$Q{}lowerAlpha"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anSenderDefaultTimeZone')"
                                       select="$Q{}anSenderDefaultTimeZone"/>
                        <xsl:map-entry key="QName('', 'attachSeparator')" select="$Q{}attachSeparator"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d54e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d54e0"/>
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
            <xsl:with-param name="Q{}output" select="$Q{}output"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}upperAlpha" select="$Q{}upperAlpha"/>
            <xsl:with-param name="Q{}lowerAlpha" select="$Q{}lowerAlpha"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anSenderDefaultTimeZone" select="$Q{}anSenderDefaultTimeZone"/>
            <xsl:with-param name="Q{}attachSeparator" select="$Q{}attachSeparator"/>
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
      <xsl:param name="Q{}output" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}upperAlpha" as="item()*" required="yes"/>
      <xsl:param name="Q{}lowerAlpha" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}attachSeparator" as="item()*" required="yes"/>
      <xsl:message>Component Consumption Request</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e19-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/OAGIS/ComponentConsumption/ComponentConsumptionRequest_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d52e19"
                    select="$Q{urn:x-xspec:compile:impl}expect-d52e19-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d52e19, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Component Consumption Request</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e19"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Component Consumption Request</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Component Consumption Request</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}output" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02003013907-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02003013906-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}param-d52e28-doc" as="document-node()">
            <xsl:document>
               <xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text>
            </xsl:document>
         </xsl:variable>
         <xsl:variable name="Q{}upperAlpha"
                       select="$Q{urn:x-xspec:compile:impl}param-d52e28-doc ! ( node() )"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}param-d52e30-doc" as="document-node()">
            <xsl:document>
               <xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text>
            </xsl:document>
         </xsl:variable>
         <xsl:variable name="Q{}lowerAlpha"
                       select="$Q{urn:x-xspec:compile:impl}param-d52e30-doc ! ( node() )"/>
         <xsl:variable name="Q{}cXMLAttachments" select="()"/>
         <xsl:variable name="Q{}anSenderDefaultTimeZone" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}attachSeparator"
                       select="'\|'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/OAGIS/ComponentConsumption/ComponentConsumptionRequestBatch_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d70e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/OAGIS/ComponentConsumption/ComponentConsumptionRequestBatch_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d70e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d70e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d70e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_NotifyInventoryConsumption_cXML_0000_ComponentConsumptionRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'output')" select="$Q{}output"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'upperAlpha')" select="$Q{}upperAlpha"/>
                        <xsl:map-entry key="QName('', 'lowerAlpha')" select="$Q{}lowerAlpha"/>
                        <xsl:map-entry key="QName('', 'cXMLAttachments')" select="$Q{}cXMLAttachments"/>
                        <xsl:map-entry key="QName('', 'anSenderDefaultTimeZone')"
                                       select="$Q{}anSenderDefaultTimeZone"/>
                        <xsl:map-entry key="QName('', 'attachSeparator')" select="$Q{}attachSeparator"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d70e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d70e0"/>
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
            <xsl:with-param name="Q{}output" select="$Q{}output"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}upperAlpha" select="$Q{}upperAlpha"/>
            <xsl:with-param name="Q{}lowerAlpha" select="$Q{}lowerAlpha"/>
            <xsl:with-param name="Q{}cXMLAttachments" select="$Q{}cXMLAttachments"/>
            <xsl:with-param name="Q{}anSenderDefaultTimeZone" select="$Q{}anSenderDefaultTimeZone"/>
            <xsl:with-param name="Q{}attachSeparator" select="$Q{}attachSeparator"/>
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
      <xsl:param name="Q{}output" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}upperAlpha" as="item()*" required="yes"/>
      <xsl:param name="Q{}lowerAlpha" as="item()*" required="yes"/>
      <xsl:param name="Q{}cXMLAttachments" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSenderDefaultTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}attachSeparator" as="item()*" required="yes"/>
      <xsl:message>Component Consumption Request</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e37-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/OAGIS/ComponentConsumption/ComponentConsumptionRequestBatch_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d52e37"
                    select="$Q{urn:x-xspec:compile:impl}expect-d52e37-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d52e37, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Component Consumption Request</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e37"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
