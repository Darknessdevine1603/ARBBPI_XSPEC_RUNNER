<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/i320581/Documents/XSPEC/src/common/runtime-utils.xsl"/>
   <xsl:global-context-item use="absent"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:attribute>
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
      <xsl:message>Quote Message Purchase Order</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrder.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d62e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrder.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d62e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d62e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d62e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e39-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrder.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e39"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e39-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e39, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e39"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Service Items</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Service Items</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderService.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d78e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderService.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d78e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d78e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d78e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Service Items</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e77-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrderService.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e77"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e77-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e77, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Service Items</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e77"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario3"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Service Types</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Service Types</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderServiceTypes.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d94e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderServiceTypes.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d94e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d94e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d94e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Service Types</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e115-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrderServiceTypes.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e115"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e115-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e115, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario3-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Service Types</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e115"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario4"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Limits</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Limits</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderLimit.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d110e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderLimit.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d110e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d110e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d110e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Limits</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e153-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrderLimit.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e153"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e153-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e153, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario4-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Limits</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e153"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario5"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Comments and Attachments</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Comments and Attachments</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderCommentAttachment.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d126e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderCommentAttachment.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d126e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d126e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d126e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Comments and Attachments</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e191-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrderCommentAttachment.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e191"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e191-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e191, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario5-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Comments and Attachments</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e191"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario6"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Production Facility</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Production Facility</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderProdFacility.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d142e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderProdFacility.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d142e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d142e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d142e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Production Facility</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e229-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrderProdFacility.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e229"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e229-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e229, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario6-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Production Facility</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e229"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario7"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Spot Quote</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Spot Quote</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderSpotQuote.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d158e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderSpotQuote.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d158e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d158e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d158e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Spot Quote</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e267-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrderSpotQuote.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e267"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e267-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e267, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario7-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Spot Quote</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e267"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario8"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Requisition Reference</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Requisition Reference</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderRequisition.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d174e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrderRequisition.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d174e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d174e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d174e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Requisition Reference</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e305-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrderRequisition.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e305"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e305-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e305, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario8-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Requisition Reference</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e305"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario9"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order Requisition with ServiceChildren</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Requisition with ServiceChildren</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrder_RequisitionServiceChildren.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d190e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrder_RequisitionServiceChildren.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d190e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d190e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d190e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order Requisition with ServiceChildren</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e343-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrder_RequisitionServiceChildren.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e343"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e343-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e343, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario9-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order Requisition with ServiceChildren</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e343"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario10"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Quote Message Purchase Order OneTimeVendor</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario10</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order OneTimeVendor</xsl:text>
         </xsl:element>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AccAssCat"
                       select="'AccountAssignmentCat'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalMoney"
                       select="'AdditionalMoney'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}AdditionalPercent"
                       select="'AdditionalPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPSystemID"
                       select="'Q8JCLNT002'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anERPTimeZone"
                       select="'+05:30'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anReceiverID"
                       select="'AN02004204493-T'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}anSourceDocumentType"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Asset"
                       select="'Asset'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}CostCenter"
                       select="'CostCenter'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionAmount"
                       select="'DeductionAmount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DeductionPercent"
                       select="'DeductionPercent'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}DefaultPlant"
                       select="'DefaultPlant'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}Document_type"
                       select="'QuoteMessageOrder'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}FollowUpDocument"
                       select="'DocType'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GLAccount"
                       select="'GLAccount'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}GrossPrice"
                       select="'GrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}HeaderTextID"
                       select="'HeaderTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatMaterial"
                       select="'ItemCatMaterial'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ItemCatService"
                       select="'ItemCatService'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}LineTextID"
                       select="'LineTextID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OneTimeVendor"
                       select="'OneTimeVendor'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}OrderID"
                       select="'Order'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}ServiceGrossPrice"
                       select="'ServiceGrossPrice'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SpotQuoteID"
                       select="'SpotQuoteID'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}SubNumber"
                       select="'SubNumber'"/>
         <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                       name="Q{}WBSElement"
                       select="'WBSElement'"/>
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
               <xsl:attribute name="href" namespace="">file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrder_OneTimeVendor.xml</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d206e0-doc"
                       as="document-node()"
                       select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/base/inbound/s4/QMPO/QuoteMessageOrder_OneTimeVendor.xml')"/>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d206e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d206e0-doc ! ( . )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       select="$Q{urn:x-xspec:compile:impl}context-d206e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable name="Q{urn:x-xspec:compile:impl}transform-options"
                          as="map(Q{http://www.w3.org/2001/XMLSchema}string, item()*)">
               <xsl:map>
                  <xsl:map-entry key="'delivery-format'" select="'raw'"/>
                  <xsl:map-entry key="'stylesheet-location'">file:/Users/i320581/Documents/XSPEC_HOME/Buyer/mapping/s4/MAPPING_ANY_cXML_0000_QuoteMessageOrder_AddOn_0000_QuoteMessageOrder.xsl</xsl:map-entry>
                  <xsl:map-entry key="'stylesheet-params'">
                     <xsl:map>
                        <xsl:map-entry key="QName('', 'AccAssCat')" select="$Q{}AccAssCat"/>
                        <xsl:map-entry key="QName('', 'AdditionalMoney')" select="$Q{}AdditionalMoney"/>
                        <xsl:map-entry key="QName('', 'AdditionalPercent')" select="$Q{}AdditionalPercent"/>
                        <xsl:map-entry key="QName('', 'anERPSystemID')" select="$Q{}anERPSystemID"/>
                        <xsl:map-entry key="QName('', 'anERPTimeZone')" select="$Q{}anERPTimeZone"/>
                        <xsl:map-entry key="QName('', 'anReceiverID')" select="$Q{}anReceiverID"/>
                        <xsl:map-entry key="QName('', 'anSourceDocumentType')"
                                       select="$Q{}anSourceDocumentType"/>
                        <xsl:map-entry key="QName('', 'Asset')" select="$Q{}Asset"/>
                        <xsl:map-entry key="QName('', 'CostCenter')" select="$Q{}CostCenter"/>
                        <xsl:map-entry key="QName('', 'DeductionAmount')" select="$Q{}DeductionAmount"/>
                        <xsl:map-entry key="QName('', 'DeductionPercent')" select="$Q{}DeductionPercent"/>
                        <xsl:map-entry key="QName('', 'DefaultPlant')" select="$Q{}DefaultPlant"/>
                        <xsl:map-entry key="QName('', 'Document_type')" select="$Q{}Document_type"/>
                        <xsl:map-entry key="QName('', 'FollowUpDocument')" select="$Q{}FollowUpDocument"/>
                        <xsl:map-entry key="QName('', 'GLAccount')" select="$Q{}GLAccount"/>
                        <xsl:map-entry key="QName('', 'GrossPrice')" select="$Q{}GrossPrice"/>
                        <xsl:map-entry key="QName('', 'HeaderTextID')" select="$Q{}HeaderTextID"/>
                        <xsl:map-entry key="QName('', 'ItemCatMaterial')" select="$Q{}ItemCatMaterial"/>
                        <xsl:map-entry key="QName('', 'ItemCatService')" select="$Q{}ItemCatService"/>
                        <xsl:map-entry key="QName('', 'LineTextID')" select="$Q{}LineTextID"/>
                        <xsl:map-entry key="QName('', 'OneTimeVendor')" select="$Q{}OneTimeVendor"/>
                        <xsl:map-entry key="QName('', 'OrderID')" select="$Q{}OrderID"/>
                        <xsl:map-entry key="QName('', 'ServiceGrossPrice')" select="$Q{}ServiceGrossPrice"/>
                        <xsl:map-entry key="QName('', 'SpotQuoteID')" select="$Q{}SpotQuoteID"/>
                        <xsl:map-entry key="QName('', 'SubNumber')" select="$Q{}SubNumber"/>
                        <xsl:map-entry key="QName('', 'WBSElement')" select="$Q{}WBSElement"/>
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
            <xsl:with-param name="Q{}AccAssCat" select="$Q{}AccAssCat"/>
            <xsl:with-param name="Q{}AdditionalMoney" select="$Q{}AdditionalMoney"/>
            <xsl:with-param name="Q{}AdditionalPercent" select="$Q{}AdditionalPercent"/>
            <xsl:with-param name="Q{}anERPSystemID" select="$Q{}anERPSystemID"/>
            <xsl:with-param name="Q{}anERPTimeZone" select="$Q{}anERPTimeZone"/>
            <xsl:with-param name="Q{}anReceiverID" select="$Q{}anReceiverID"/>
            <xsl:with-param name="Q{}anSourceDocumentType" select="$Q{}anSourceDocumentType"/>
            <xsl:with-param name="Q{}Asset" select="$Q{}Asset"/>
            <xsl:with-param name="Q{}CostCenter" select="$Q{}CostCenter"/>
            <xsl:with-param name="Q{}DeductionAmount" select="$Q{}DeductionAmount"/>
            <xsl:with-param name="Q{}DeductionPercent" select="$Q{}DeductionPercent"/>
            <xsl:with-param name="Q{}DefaultPlant" select="$Q{}DefaultPlant"/>
            <xsl:with-param name="Q{}Document_type" select="$Q{}Document_type"/>
            <xsl:with-param name="Q{}FollowUpDocument" select="$Q{}FollowUpDocument"/>
            <xsl:with-param name="Q{}GLAccount" select="$Q{}GLAccount"/>
            <xsl:with-param name="Q{}GrossPrice" select="$Q{}GrossPrice"/>
            <xsl:with-param name="Q{}HeaderTextID" select="$Q{}HeaderTextID"/>
            <xsl:with-param name="Q{}ItemCatMaterial" select="$Q{}ItemCatMaterial"/>
            <xsl:with-param name="Q{}ItemCatService" select="$Q{}ItemCatService"/>
            <xsl:with-param name="Q{}LineTextID" select="$Q{}LineTextID"/>
            <xsl:with-param name="Q{}OneTimeVendor" select="$Q{}OneTimeVendor"/>
            <xsl:with-param name="Q{}OrderID" select="$Q{}OrderID"/>
            <xsl:with-param name="Q{}ServiceGrossPrice" select="$Q{}ServiceGrossPrice"/>
            <xsl:with-param name="Q{}SpotQuoteID" select="$Q{}SpotQuoteID"/>
            <xsl:with-param name="Q{}SubNumber" select="$Q{}SubNumber"/>
            <xsl:with-param name="Q{}WBSElement" select="$Q{}WBSElement"/>
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
      <xsl:param name="Q{}AccAssCat" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalMoney" as="item()*" required="yes"/>
      <xsl:param name="Q{}AdditionalPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPSystemID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anERPTimeZone" as="item()*" required="yes"/>
      <xsl:param name="Q{}anReceiverID" as="item()*" required="yes"/>
      <xsl:param name="Q{}anSourceDocumentType" as="item()*" required="yes"/>
      <xsl:param name="Q{}Asset" as="item()*" required="yes"/>
      <xsl:param name="Q{}CostCenter" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionAmount" as="item()*" required="yes"/>
      <xsl:param name="Q{}DeductionPercent" as="item()*" required="yes"/>
      <xsl:param name="Q{}DefaultPlant" as="item()*" required="yes"/>
      <xsl:param name="Q{}Document_type" as="item()*" required="yes"/>
      <xsl:param name="Q{}FollowUpDocument" as="item()*" required="yes"/>
      <xsl:param name="Q{}GLAccount" as="item()*" required="yes"/>
      <xsl:param name="Q{}GrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}HeaderTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatMaterial" as="item()*" required="yes"/>
      <xsl:param name="Q{}ItemCatService" as="item()*" required="yes"/>
      <xsl:param name="Q{}LineTextID" as="item()*" required="yes"/>
      <xsl:param name="Q{}OneTimeVendor" as="item()*" required="yes"/>
      <xsl:param name="Q{}OrderID" as="item()*" required="yes"/>
      <xsl:param name="Q{}ServiceGrossPrice" as="item()*" required="yes"/>
      <xsl:param name="Q{}SpotQuoteID" as="item()*" required="yes"/>
      <xsl:param name="Q{}SubNumber" as="item()*" required="yes"/>
      <xsl:param name="Q{}WBSElement" as="item()*" required="yes"/>
      <xsl:param name="Q{}anCrossRefFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLookUpFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anUOMFlag" as="item()*" required="yes"/>
      <xsl:param name="Q{}anLocalTesting" as="item()*" required="yes"/>
      <xsl:message>Quote Message Purchase Order - One Time Vendor</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d60e381-doc"
                    as="document-node()"
                    select="doc('file:/Users/i320581/Documents/XSPEC_HOME/XSPEC/payloads/target/inbound/s4/QMPO/QuoteMessageOrder_OneTimeVendor.dat')"/>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    name="Q{urn:x-xspec:compile:impl}expect-d60e381"
                    select="$Q{urn:x-xspec:compile:impl}expect-d60e381-doc ! ( element() )"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d60e381, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario10-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Quote Message Purchase Order - One Time Vendor</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d60e381"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
