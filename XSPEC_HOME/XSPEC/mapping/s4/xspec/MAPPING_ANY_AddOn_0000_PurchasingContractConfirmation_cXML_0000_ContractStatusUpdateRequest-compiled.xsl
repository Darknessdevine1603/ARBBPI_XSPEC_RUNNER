<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 9">
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
      <xsl:message>Scenario for PurchasingContractConfirmation</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for PurchasingContractConfirmation</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/PurchasingContractConfirmation_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d61e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/PurchasingContractConfirmation_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d61e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d61e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d61e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d61e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d61e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>PurchasingContractConfirmation</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e16-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/PurchasingContractConfirmation_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e16"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e16-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e16, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>PurchasingContractConfirmation</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e16"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for PurchasingContractERPConfirmation ItemStatus</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for PurchasingContractERPConfirmation ItemStatus</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ItemStatus_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d77e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ItemStatus_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d77e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d77e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d77e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d77e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d77e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>PurchasingContractERPConfirmation ItemStatus</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e31-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/ItemStatus_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e31"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e31-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e31, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>PurchasingContractERPConfirmation ItemStatus</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e31"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for Services_Confirmation</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for Services_Confirmation</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/Services_Confirmation_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d93e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/Services_Confirmation_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d93e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d93e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d93e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d93e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d93e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>Services_Confirmation</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e46-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/Services_Confirmation_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e46"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e46-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e46, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Services_Confirmation</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e46"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for PurchasingContractConfirmationNoStatusCode</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for PurchasingContractConfirmationNoStatusCode</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/PurchasingContractConfirmationNoStatusCode_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d109e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/PurchasingContractConfirmationNoStatusCode_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d109e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d109e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d109e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d109e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d109e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>PurchasingContractConfirmationNoStatusCode</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e61-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/PurchasingContractConfirmationNoStatusCode_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e61"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e61-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e61, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>PurchasingContractConfirmationNoStatusCode</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e61"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for ConfirmationActionCode02</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for ConfirmationActionCode02</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d125e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d125e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d125e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d125e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d125e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d125e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>ConfirmationActionCode02</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e76-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e76"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e76-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e76, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ConfirmationActionCode02</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e76"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for ConfirmationActionCode01</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for ConfirmationActionCode01</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode01_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d141e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode01_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d141e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d141e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d141e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d141e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d141e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>ConfirmationActionCode01</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e91-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode01_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e91"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e91-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e91, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ConfirmationActionCode01</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e91"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for ConfirmationActionCode03</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for ConfirmationActionCode03</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode03_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d157e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode03_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d157e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d157e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d157e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d157e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d157e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>ConfirmationActionCode03</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e106-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/ConfirmationActionCode03_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e106"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e106-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e106, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ConfirmationActionCode03</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e106"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for ItemStatusChanged</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for ItemStatusChanged</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ItemStatusChanged_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d173e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ItemStatusChanged_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d173e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d173e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d173e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d173e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d173e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>ItemStatusChanged</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e121-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/ItemStatusChanged_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e121"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e121-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e121, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ItemStatusChanged</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e121"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for ItemStatusDeleted</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for ItemStatusDeleted</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIsMultiERP"
                       select="'Yes'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSupplierANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anBuyerANID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPName"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'QODCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anTargetDocumentType"
                       select="'ContractStatusUpdateRequest'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anProviderANID"
                       select="'AN01000000087'"/>
         <xsl:variable name="Q{}anPayloadID" select="()"/>
         <xsl:variable name="Q{}anSharedSecrete" select="()"/>
         <xsl:variable name="Q{}anEnvName" select="()"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ItemStatusDeleted_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d189e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/outbound/s4/PurchasingContractConfirmation/ItemStatusDeleted_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d189e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d189e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d189e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_AddOn_0000_PurchasingContractConfirmation_cXML_0000_ContractStatusUpdateRequest.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anIsMultiERP')" select="$Q{}anIsMultiERP"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anSupplierANID')" select="$Q{}anSupplierANID"/>
                        <xsl:map-entry key="QName('', 'anBuyerANID')" select="$Q{}anBuyerANID"/>
                        <xsl:map-entry key="QName('', 'anERPName')" select="$Q{}anERPName"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anTargetDocumentType')"
                                       select="$Q{}anTargetDocumentType"/>
                        <xsl:map-entry key="QName('', 'anProviderANID')" select="$Q{}anProviderANID"/>
                        <xsl:map-entry key="QName('', 'anPayloadID')" select="$Q{}anPayloadID"/>
                        <xsl:map-entry key="QName('', 'anSharedSecrete')" select="$Q{}anSharedSecrete"/>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
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
                  <xsl:map-entry key="if ($Q{urn:x-xspec:compile:impl}context-d189e0 instance of node()) then 'source-node' else 'initial-match-selection'"
                                 select="$Q{urn:x-xspec:compile:impl}context-d189e0"/>
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
            <xsl:with-param name="Q{}anBuyerANID" select="$Q{}anBuyerANID"/>
            <xsl:with-param name="Q{}anERPName" select="$Q{}anERPName"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anTargetDocumentType" select="$Q{}anTargetDocumentType"/>
            <xsl:with-param name="Q{}anProviderANID" select="$Q{}anProviderANID"/>
            <xsl:with-param name="Q{}anPayloadID" select="$Q{}anPayloadID"/>
            <xsl:with-param name="Q{}anSharedSecrete" select="$Q{}anSharedSecrete"/>
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
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
      <xsl:param name="Q{}anBuyerANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anTargetDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anProviderANID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anPayloadID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSharedSecrete" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:message>ItemStatusDeleted</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d59e136-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/outbound/s4/PurchasingContractConfirmation/ItemStatusDeleted_AM.xml')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d59e136"
                    select="$Q{urn:x-xspec:compile:impl}expect-d59e136-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d59e136, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>ItemStatusDeleted</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d59e136"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
