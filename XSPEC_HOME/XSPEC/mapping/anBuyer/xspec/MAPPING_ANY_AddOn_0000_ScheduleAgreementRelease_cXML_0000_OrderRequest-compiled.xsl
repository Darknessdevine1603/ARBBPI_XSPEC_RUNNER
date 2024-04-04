<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 14">
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
                  <xsl:when test=". eq 11">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11"/>
                  </xsl:when>
                  <xsl:when test=". eq 12">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario12"/>
                  </xsl:when>
                  <xsl:when test=". eq 13">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario13"/>
                  </xsl:when>
                  <xsl:when test=". eq 14">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario14"/>
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
      <xsl:message>Scheduling Agreement</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement</xsl:text>
         </xsl:element>
         <xsl:variable name="Q{}anIsMultiERP" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d66e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d66e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d66e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d66e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d66e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d66e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e19-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e19"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e19-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e19, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e19"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement Multi Line</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Multi Line</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementMultiLine.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d82e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementMultiLine.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d82e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d82e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d82e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d82e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d82e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement Multi Line</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e37-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreementMultiLine.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e37"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e37-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e37, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Multi Line</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e37"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement Comments and Attachments</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Comments and Attachments</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementCommentsAttachments.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d98e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementCommentsAttachments.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d98e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d98e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d98e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d98e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d98e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement Comments and Attachments</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e55-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreementCommentsAttachments.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e55"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e55-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e55, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Comments and Attachments</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e55"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement Account Distribution</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Account Distribution</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementwithDistribution.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d114e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementwithDistribution.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d114e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d114e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d114e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d114e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d114e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement Account Distribution</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e73-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreementwithDistribution.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e73"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e73-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e73, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Account Distribution</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e73"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement SCC</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement SCC</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementSCC.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d130e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementSCC.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d130e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d130e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d130e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d130e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d130e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement SCC</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e91-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreementSCC.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e91"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e91-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e91, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement SCC</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e91"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement Consignment</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Consignment</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementConsignment.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d146e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementConsignment.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d146e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d146e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d146e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d146e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d146e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement Consignment</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e109-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreementConsignment.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e109"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e109-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e109, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Consignment</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e109"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement Sub Contracting</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Sub Contracting</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementSubContract.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d162e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreementSubContract.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d162e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d162e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d162e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d162e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d162e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement Sub Contracting</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e127-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreementSubContract.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e127"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e127-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e127, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Sub Contracting</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e127"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement 3rd Party</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement 3rd Party</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement3rdParty.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d178e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement3rdParty.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d178e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d178e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d178e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d178e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d178e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement 3rd Party</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e145-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement3rdParty.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e145"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e145-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e145, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement 3rd Party</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e145"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement Header Fields_PurOrgName_PurGrpName_INCO2</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Header Fields_PurOrgName_PurGrpName_INCO2</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'PROD'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_HeaderFields_PurOrgName_PurGrpName_INCO2.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d194e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_HeaderFields_PurOrgName_PurGrpName_INCO2.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d194e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d194e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d194e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d194e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d194e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement Header Fields_PurOrgName_PurGrpName_INCO2</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e164-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement_HeaderFields_PurOrgName_PurGrpName_INCO2.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e164"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e164-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e164, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement Header Fields_PurOrgName_PurGrpName_INCO2</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e164"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement with empty lines</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario10</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with empty lines</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_Empty_Lines.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d210e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_Empty_Lines.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d210e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d210e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d210e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d210e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d210e0"/>
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
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
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
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement with empty lines</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e184-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement_Empty_Lines.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e184"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e184-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e184, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario10-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with empty lines</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e184"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement with multilines for each QM Scenario</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario11</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with multilines for each QM Scenario</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_multilines_QMScenario.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d226e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_multilines_QMScenario.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d226e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d226e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d226e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d226e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d226e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario11-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement with multilines for each QM Scenario</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e202-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement_multilines_QMScenario.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e202"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e202-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e202, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario11-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with multilines for each QM Scenario</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e202"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario12"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement with QM Scenario without batch management</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario12</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with QM Scenario without batch management</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_with_QMScenario_wo_Batch.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d242e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_with_QMScenario_wo_Batch.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d242e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d242e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d242e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d242e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d242e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario12-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario12-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement with QM Scenario without batch management</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e220-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement_with_QMScenario_wo_Batch.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e220"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e220-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e220, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario12-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with QM Scenario without batch management</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e220"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario13"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scheduling Agreement with Received quantity</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario13</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with Received quantity</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'14'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_with_Received_quantity.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d258e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_with_Received_quantity.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d258e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d258e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d258e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d258e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d258e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario13-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario13-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Scheduling Agreement with Received Quantity</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e238-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement_with_Received_quantity.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e238"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e238-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e238, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario13-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scheduling Agreement with Received Quantity</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e238"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario14"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>IG-41412 Scheduling Agreement with MultiLineComments</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario14</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>IG-41412 Scheduling Agreement with MultiLineComments</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'TRUE'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02005543705-T'"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QKDCLNT521'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'ScheduleAgreementRelease'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'OrderRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAddOnCIVersion"
                       select="'18'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_MultiLineComments.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d274e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/anBuyer/SAR/SchedulingAgreement_MultiLineComments.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d274e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d274e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d274e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/anBuyer/MAPPING_ANY_AddOn_0000_ScheduleAgreementRelease_cXML_0000_OrderRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anAddOnCIVersion')" select="$Q{}anAddOnCIVersion"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d274e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d274e0"/>
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
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario14-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="Q{}anIsMultiERP" select="$Q{}anIsMultiERP"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anSupplierANID" select="$Q{}anSupplierANID"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anAddOnCIVersion" select="$Q{}anAddOnCIVersion"/>
            <xsl:with-param name="Q{}anCrossRefFlag" select="$Q{}anCrossRefFlag"/>
            <xsl:with-param name="Q{}anLookUpFlag" select="$Q{}anLookUpFlag"/>
            <xsl:with-param name="Q{}anUOMFlag" select="$Q{}anUOMFlag"/>
            <xsl:with-param name="Q{}anLocalTesting" select="$Q{}anLocalTesting"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario14-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{}anIsMultiERP" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSupplierANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAddOnCIVersion" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>IG-41412 Scheduling Agreement with MultiLineComments</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d64e256-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/anBuyer/SAR/SchedulingAgreement_MultiLineComments.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d64e256"
                    select="$Q{urn:x-xspec:compile:impl}expect-d64e256-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d64e256, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario14-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>IG-41412 Scheduling Agreement with MultiLineComments</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d64e256"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
