<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xsl</xsl:attribute>
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
      <xsl:message>Acknowledge PurchaseOrder</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Acknowledge PurchaseOrder</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'ACK'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEventType"
                       select="'ACK'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anErrorCode"
                       select="'201'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anErrorDescription"
                       select="'Accepted'"/>
         <xsl:variable name="Q{}anErrorXPath" select="()"/>
         <xsl:variable name="Q{}anCorrelationID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anDocReferenceID"
                       select="'AribaCIG_MS_INV_210930154610'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anMessageID"
                       select="'AribaCIG_MS_INV_210930154610'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternateReceiverID"
                       select="'658731930'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternateSenderID"
                       select="'081466849'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anDateTime"
                       select="'2021-09-30T07:47:08+00:00'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIflowName"
                       select="'com_sap_an_in_outbound'"/>
         <xsl:variable name="Q{}anICNValue" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/StatusUpdateRequest/StatusUpdateRequestAck_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d54e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/StatusUpdateRequest/StatusUpdateRequestAck_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d54e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d54e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d54e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anEventType')" select="$Q{}anEventType"/>
                        <xsl:map-entry key="QName('', 'anErrorCode')" select="$Q{}anErrorCode"/>
                        <xsl:map-entry key="QName('', 'anErrorDescription')" select="$Q{}anErrorDescription"/>
                        <xsl:map-entry key="QName('', 'anErrorXPath')" select="$Q{}anErrorXPath"/>
                        <xsl:map-entry key="QName('', 'anCorrelationID')" select="$Q{}anCorrelationID"/>
                        <xsl:map-entry key="QName('', 'anDocReferenceID')" select="$Q{}anDocReferenceID"/>
                        <xsl:map-entry key="QName('', 'anMessageID')" select="$Q{}anMessageID"/>
                        <xsl:map-entry key="QName('', 'anAlternateReceiverID')"
                                       select="$Q{}anAlternateReceiverID"/>
                        <xsl:map-entry key="QName('', 'anAlternateSenderID')" select="$Q{}anAlternateSenderID"/>
                        <xsl:map-entry key="QName('', 'anDateTime')" select="$Q{}anDateTime"/>
                        <xsl:map-entry key="QName('', 'anIflowName')" select="$Q{}anIflowName"/>
                        <xsl:map-entry key="QName('', 'anICNValue')" select="$Q{}anICNValue"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anEventType" select="$Q{}anEventType"/>
            <xsl:with-param name="Q{}anErrorCode" select="$Q{}anErrorCode"/>
            <xsl:with-param name="Q{}anErrorDescription" select="$Q{}anErrorDescription"/>
            <xsl:with-param name="Q{}anErrorXPath" select="$Q{}anErrorXPath"/>
            <xsl:with-param name="Q{}anCorrelationID" select="$Q{}anCorrelationID"/>
            <xsl:with-param name="Q{}anDocReferenceID" select="$Q{}anDocReferenceID"/>
            <xsl:with-param name="Q{}anMessageID" select="$Q{}anMessageID"/>
            <xsl:with-param name="Q{}anAlternateReceiverID" select="$Q{}anAlternateReceiverID"/>
            <xsl:with-param name="Q{}anAlternateSenderID" select="$Q{}anAlternateSenderID"/>
            <xsl:with-param name="Q{}anDateTime" select="$Q{}anDateTime"/>
            <xsl:with-param name="Q{}anIflowName" select="$Q{}anIflowName"/>
            <xsl:with-param name="Q{}anICNValue" select="$Q{}anICNValue"/>
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
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
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEventType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anErrorCode" as="item()*" required="yes"/>
      <xsl:param name="Q{}anErrorDescription" as="item()*" required="yes"/>
      <xsl:param name="Q{}anErrorXPath" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCorrelationID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anDocReferenceID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anMessageID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternateReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternateSenderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anDateTime" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIflowName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anICNValue" as="item()*" required="yes"/>
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:message>Acknowledge PurchaseOrder</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e20-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/StatusUpdateRequest/StatusUpdateRequestAck_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d52e20"
                    select="$Q{urn:x-xspec:compile:impl}expect-d52e20-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d52e20, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Acknowledge PurchaseOrder</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e20"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Acknowledge Purchase Order Error</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Acknowledge Purchase Order Error</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEnvName"
                       select="'ACK'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anEventType"
                       select="'ACK'"/>
         <xsl:variable name="Q{}anErrorCode" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anErrorDescription"
                       select="'Accepted'"/>
         <xsl:variable name="Q{}anErrorXPath" select="()"/>
         <xsl:variable name="Q{}anCorrelationID" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anDocReferenceID"
                       select="'AribaCIG_MS_INV_210930154610'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anMessageID"
                       select="'AribaCIG_MS_INV_210930154610'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternateReceiverID"
                       select="'658731930'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anAlternateSenderID"
                       select="'081466849'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anDateTime"
                       select="'2021-09-30T07:47:08+00:00'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anIflowName"
                       select="'com_sap_an_in_outbound'"/>
         <xsl:variable name="Q{}anICNValue" select="()"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}releaseID"
                       select="'9.2'"/>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/StatusUpdateRequest/StatusUpdateRequestAck_BM.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d70e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/OAGIS/StatusUpdateRequest/StatusUpdateRequestAck_BM.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d70e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d70e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d70e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Supplier/mapping/OAGIS/MAPPING_ANY_OAGIS_9.2_ConfirmBOD.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'anEnvName')" select="$Q{}anEnvName"/>
                        <xsl:map-entry key="QName('', 'anEventType')" select="$Q{}anEventType"/>
                        <xsl:map-entry key="QName('', 'anErrorCode')" select="$Q{}anErrorCode"/>
                        <xsl:map-entry key="QName('', 'anErrorDescription')" select="$Q{}anErrorDescription"/>
                        <xsl:map-entry key="QName('', 'anErrorXPath')" select="$Q{}anErrorXPath"/>
                        <xsl:map-entry key="QName('', 'anCorrelationID')" select="$Q{}anCorrelationID"/>
                        <xsl:map-entry key="QName('', 'anDocReferenceID')" select="$Q{}anDocReferenceID"/>
                        <xsl:map-entry key="QName('', 'anMessageID')" select="$Q{}anMessageID"/>
                        <xsl:map-entry key="QName('', 'anAlternateReceiverID')"
                                       select="$Q{}anAlternateReceiverID"/>
                        <xsl:map-entry key="QName('', 'anAlternateSenderID')" select="$Q{}anAlternateSenderID"/>
                        <xsl:map-entry key="QName('', 'anDateTime')" select="$Q{}anDateTime"/>
                        <xsl:map-entry key="QName('', 'anIflowName')" select="$Q{}anIflowName"/>
                        <xsl:map-entry key="QName('', 'anICNValue')" select="$Q{}anICNValue"/>
                        <xsl:map-entry key="QName('', 'releaseID')" select="$Q{}releaseID"/>
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
            <xsl:with-param name="Q{}anEnvName" select="$Q{}anEnvName"/>
            <xsl:with-param name="Q{}anEventType" select="$Q{}anEventType"/>
            <xsl:with-param name="Q{}anErrorCode" select="$Q{}anErrorCode"/>
            <xsl:with-param name="Q{}anErrorDescription" select="$Q{}anErrorDescription"/>
            <xsl:with-param name="Q{}anErrorXPath" select="$Q{}anErrorXPath"/>
            <xsl:with-param name="Q{}anCorrelationID" select="$Q{}anCorrelationID"/>
            <xsl:with-param name="Q{}anDocReferenceID" select="$Q{}anDocReferenceID"/>
            <xsl:with-param name="Q{}anMessageID" select="$Q{}anMessageID"/>
            <xsl:with-param name="Q{}anAlternateReceiverID" select="$Q{}anAlternateReceiverID"/>
            <xsl:with-param name="Q{}anAlternateSenderID" select="$Q{}anAlternateSenderID"/>
            <xsl:with-param name="Q{}anDateTime" select="$Q{}anDateTime"/>
            <xsl:with-param name="Q{}anIflowName" select="$Q{}anIflowName"/>
            <xsl:with-param name="Q{}anICNValue" select="$Q{}anICNValue"/>
            <xsl:with-param name="Q{}releaseID" select="$Q{}releaseID"/>
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
      <xsl:param name="Q{}anEnvName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anEventType" as="item()*" required="yes"/>
      <xsl:param name="Q{}anErrorCode" as="item()*" required="yes"/>
      <xsl:param name="Q{}anErrorDescription" as="item()*" required="yes"/>
      <xsl:param name="Q{}anErrorXPath" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCorrelationID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anDocReferenceID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anMessageID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternateReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anAlternateSenderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anDateTime" as="item()*" required="yes"/>
      <xsl:param name="Q{}anIflowName" as="item()*" required="yes"/>
      <xsl:param name="Q{}anICNValue" as="item()*" required="yes"/>
      <xsl:param name="Q{}releaseID" as="item()*" required="yes"/>
      <xsl:message>Acknowledge Purchase Order Error</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e39-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/OAGIS/StatusUpdateRequest/StatusUpdateRequestAckError_AM.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d52e39"
                    select="$Q{urn:x-xspec:compile:impl}expect-d52e39-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d52e39, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Acknowledge Purchase Order Error</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e39"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
