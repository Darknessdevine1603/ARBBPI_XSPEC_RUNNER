<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:hci="http://sap.com/it/" exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <xsl:param name="anISASender"/>
   <xsl:param name="anISASenderQual"/>
   <xsl:param name="anISAReceiver"/>
   <xsl:param name="anISAReceiverQual"/>
   <xsl:param name="anDate"/>
   <xsl:param name="anTime"/>
   <xsl:param name="anICNValue"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="anSenderGroupID"/>
   <xsl:param name="anReceiverGroupID"/>
   <xsl:param name="exchange"/>
   <xsl:variable name="orderMainType" select="'Order'"/>
   <!-- For local testing -->
   <!--xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>   
   <xsl:include href="FORMAT_cXML_0000_ASC-X12_004010_Parity.xsl"/-->
   <!-- PD references -->
   <xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
   <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
   <!-- CG: IG-16765 - 1500 Extrinsics -->
   <xsl:variable name="mappingLookup">
      <xsl:call-template name="getLookupValues">
         <xsl:with-param name="cXMLDocType" select="'OrderRequest'"/>
      </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="useExtrinsicsLookup">
      <xsl:choose>
         <xsl:when test="$mappingLookup/MappingLookup/EnableStandardExtrinsics != ''">
            <xsl:value-of select="lower-case($mappingLookup/MappingLookup/EnableStandardExtrinsics)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'no'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   
   <xsl:template match="/">
      <xsl:variable name="dateNow" select="current-dateTime()"/>
      <ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12">
         <xsl:call-template name="createISA">
            <xsl:with-param name="dateNow" select="$dateNow"/>
         </xsl:call-template>
         <FunctionalGroup>
            <S_GS>
               <D_479>PC</D_479>
               <D_142>
                  <xsl:choose>
                     <xsl:when test="$anSenderGroupID != ''">
                        <xsl:value-of select="$anSenderGroupID"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>ARIBA</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </D_142>
               <D_124>
                  <xsl:choose>
                     <xsl:when test="$anReceiverGroupID != ''">
                        <xsl:value-of select="$anReceiverGroupID"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>ARIBA</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </D_124>
               <D_373>
                  <xsl:value-of select="format-dateTime($dateNow, '[Y0001][M01][D01]')"/>
               </D_373>
               <D_337>
                  <xsl:value-of select="format-dateTime($dateNow, '[H01][m01][s01]')"/>
               </D_337>
               <D_28>
                  <xsl:value-of select="$anICNValue"/>
               </D_28>
               <D_455>X</D_455>
               <D_480>004010</D_480>
            </S_GS>
            <M_860>
               <S_ST>
                  <D_143>860</D_143>
                  <D_329>0001</D_329>
               </S_ST>
               <S_BCH>
                  <xsl:element name="D_353">
                     <xsl:choose>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">05</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">03</xsl:when>
                        <xsl:otherwise>03</xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
                  <xsl:element name="D_92">
                     <xsl:choose>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'dropship'">DS</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'orderType'] = 'rushorder'">RO</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@orderType = 'blanket'">BK</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@orderType = 'release'">RL</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'new'">NE</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">KN</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete' and cXML/Request/OrderRequest/OrderRequestHeader/@isInternalVersion = 'yes'">IN</xsl:when>
                        <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">KN</xsl:when>
                     </xsl:choose>
                  </xsl:element>
                  <D_324>
                     <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@orderID), 1, 22)"/>
                  </D_324>
                  <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@releaseRequired) != ''">
                     <D_328>
                        <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/@releaseRequired), 1, 30)"/>
                     </D_328>
                  </xsl:if>
                  <D_373>
                     <xsl:value-of select="replace(substring(cXML/Request/OrderRequest/OrderRequestHeader/@orderDate, 0, 11), '-', '')"/>
                  </D_373>
               </S_BCH>
               <S_CUR>
                  <D_98>BY</D_98>
                  <D_100>
                     <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@currency"/>
                  </D_100>
                  <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateAmount != ''">
                     <D_280>
                        <xsl:call-template name="formatAmount">
                           <xsl:with-param name="amount" select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateAmount"/>
                        </xsl:call-template>
                        <!--xsl:value-of select="format-number(number(replace(cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateAmount,',','')),'0000')"/-->
                     </D_280>
                  </xsl:if>
                  <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency != ''">
                     <D_98_2>SE</D_98_2>
                     <D_100_2>
                        <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@alternateCurrency"/>
                     </D_100_2>
                  </xsl:if>
               </S_CUR>
              <xsl:call-template name="createOrderCommonREF">
                  <!-- CG : IG-16765 1500 Extrinsics -->
                  <xsl:with-param name="doExtrinsicsLookup" select="$useExtrinsicsLookup"/>
               </xsl:call-template>
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/LegalEntity/IdReference[@domain='CompanyCode']/@identifier) != ''">
                  <S_PER>
                     <D_366>ZZ</D_366>
                     <D_93>
                        <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/LegalEntity/IdReference[@domain='CompanyCode']/@identifier), 1, 30)"/>
                     </D_93>
                     <D_443>
                        <xsl:value-of select="'CompanyCode'"/>
                     </D_443>
                  </S_PER>
               </xsl:if>
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain='PurchasingOrganization']/@identifier) != ''">
                  <S_PER>
                     <D_366>ZZ</D_366>
                     <D_93>
                        <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain='PurchasingOrganization']/@identifier), 1, 30)"/>
                     </D_93>
                     <D_443>
                        <xsl:value-of select="'PurchasingOrg'"/>
                     </D_443>
                  </S_PER>
               </xsl:if>
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain='PurchasingGroup']/@identifier) != ''">
                  <S_PER>
                     <D_366>ZZ</D_366>
                     <D_93>
                        <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrganizationalUnit/IdReference[@domain='PurchasingGroup']/@identifier), 1, 30)"/>
                     </D_93>
                     <D_443>
                        <xsl:value-of select="'PurchasingGroup'"/>
                     </D_443>
                  </S_PER>
               </xsl:if>
               <!-- Terms Of Delivery -->
               <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery">
                  <xsl:call-template name="createFOB_FromTermsOfDelivery">
                     <xsl:with-param name="termOfDelivery" select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- shipComplete -->
               <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/@shipComplete = 'yes'">
                  <S_CSH>
                     <D_563>SC</D_563>
                  </S_CSH>
               </xsl:if>
               <!-- Shipping -->
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money) != ''">
                  <G_SAC>
                     <S_SAC>
                        <D_248>C</D_248>
                        <D_1300>G830</D_1300>
                        <D_610>
                           <xsl:call-template name="formatAmount">
                              <xsl:with-param name="amount" select="cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money"/>
                              <xsl:with-param name="formatDecimals" select="'N2'"/>
                           </xsl:call-template>
                           <!--xsl:value-of select="replace(format-number(number(replace(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money,',','')),'0.00'),'\.','')"/-->
                        </D_610>
                        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain) != '' or normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId) != ''">
                           <D_127>
                              <xsl:value-of select="substring(concat(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingDomain, ':', cXML/Request/OrderRequest/OrderRequestHeader/Shipping/@trackingId), 1, 30)"/>
                           </D_127>
                        </xsl:if>
                        <D_352>
                           <xsl:choose>
                              <xsl:when test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/ShortName) != ''">
                                 <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/ShortName), 1, 80)"/>
                              </xsl:when>
                              <xsl:when test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description) != ''">
                                 <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description), 1, 80)"/>
                              </xsl:when>
                              <xsl:otherwise>No Description Provided</xsl:otherwise>
                           </xsl:choose>
                        </D_352>
                        <D_819>
                           <xsl:choose>
                              <xsl:when test="string-length(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/@xml:lang)) &gt; 1">
                                 <xsl:value-of select="upper-case(substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Description/@xml:lang), 1, 2))"/>
                              </xsl:when>
                              <xsl:otherwise>EN</xsl:otherwise>
                           </xsl:choose>
                        </D_819>
                     </S_SAC>
                     <S_CUR>
                        <D_98>BY</D_98>
                        <D_100>
                           <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money/@currency"/>
                        </D_100>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money/@alternateAmount != ''">
                           <D_280>
                              <xsl:call-template name="formatAmount">
                                 <xsl:with-param name="amount" select="cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money/@alternateAmount"/>
                              </xsl:call-template>
                              <!--xsl:value-of select="format-number(number(replace(cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money/@alternateAmount,',','')),'0000')"/-->
                           </D_280>
                        </xsl:if>
                        <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money/@alternateCurrency != ''">
                           <D_98_2>SE</D_98_2>
                           <D_100_2>
                              <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Shipping/Money/@alternateCurrency"/>
                           </D_100_2>
                        </xsl:if>
                     </S_CUR>
                  </G_SAC>
               </xsl:if>
               <!-- Modifications-->
               <xsl:for-each select="./cXML/Request/OrderRequest/OrderRequestHeader/Total/Modifications/Modification">
                  <xsl:call-template name="createSAC_FromModifications">
                     <xsl:with-param name="modification" select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- PaymentTerm -->
               <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/PaymentTerm">
                  <xsl:call-template name="createITD_FromPaymentTerms">
                     <xsl:with-param name="paymentTerm" select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:call-template name="createOrderCommonDTM"/>
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description) != ''">
                  <xsl:call-template name="shippingInstructions">
                     <xsl:with-param name="instructions" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description)"/>
                     <xsl:with-param name="langCode" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/TransportInformation/ShippingInstructions/Description/@xml:lang)"/>
                  </xsl:call-template>
               </xsl:if>
               <!-- Header Taxes -->
               <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Tax/Money != ''">
                  <S_TXI>
                     <D_963>TX</D_963>
                     <D_782>
                        <xsl:call-template name="formatAmount">
                           <xsl:with-param name="amount" select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/Money"/>
                        </xsl:call-template>
                        <!--xsl:value-of select="format-number(number(replace(cXML/Request/OrderRequest/OrderRequestHeader/Tax/Money,',','')),'0.00')"/-->
                     </D_782>
                  </S_TXI>
               </xsl:if>
               <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Tax/TaxDetail">
                  <xsl:call-template name="createTXI_FromTaxDetail">
                     <xsl:with-param name="taxDetail" select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- Payment / PCard -->
               <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@number != ''">
                  <G_N9>
                     <S_N9>
                        <D_128>PSM</D_128>
                        <D_127>
                           <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@number"/>
                        </D_127>
                        <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@name) != ''">
                           <D_369>
                              <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@name), 1, 45)"/>
                           </D_369>
                        </xsl:if>
                     </S_N9>
                     <S_DTM>
                        <D_374>036</D_374>
                        <D_1250>UN</D_1250>
                        <D_1251>
                           <xsl:value-of select="cXML/Request/OrderRequest/OrderRequestHeader/Payment/PCard/@expiration"/>
                        </D_1251>
                     </S_DTM>
                  </G_N9>
               </xsl:if>
               <!-- Comments -->
               <!-- CG -->
            	<xsl:for-each select="/cXML/Request/OrderRequest/OrderRequestHeader/Comments">
            		<xsl:if test="normalize-space(.) != ''">
	            		<G_N9>
	            			<S_N9>
	            				<D_128>L1</D_128>
	            				<D_127>
	            					<xsl:choose>
	            						<xsl:when test="string-length(normalize-space(@xml:lang)) &gt; 1">
	            							<xsl:value-of select="upper-case(substring(normalize-space(@xml:lang), 1, 2))"/>
	            						</xsl:when>
	            						<xsl:otherwise>EN</xsl:otherwise>
	            					</xsl:choose>
	            				</D_127>
	            				<D_369>Comments</D_369>
	            				<xsl:if test="normalize-space(@type) != ''">
	            					<C_C040>
	            						<D_128>L1</D_128>
	            						<D_127><xsl:value-of select="substring(normalize-space(@type), 1, 30)"/></D_127>
	            					</C_C040>
	            				</xsl:if>
	            			</S_N9>                        
	            			<xsl:variable name="comments" select="normalize-space(.)"/>
	            			<xsl:variable name="StrLen" select="string-length($comments)"/>
	            			<xsl:call-template name="MSGLoop">
	            				<xsl:with-param name="Desc" select="$comments"/>
	            				<xsl:with-param name="StrLen" select="$StrLen"/>
	            				<xsl:with-param name="Pos" select="1"/>
	            				<xsl:with-param name="CurrentEndPos" select="1"/>
	            			</xsl:call-template>
	            		</G_N9>
            		</xsl:if>
            	</xsl:for-each>
               <!--attachments-->
               <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Comments[1]/Attachment[normalize-space(URL) != '']">
                  <G_N9>
                     <S_N9>
                        <D_128>URL</D_128>
                        <D_127>URL</D_127>
                        <xsl:if test="normalize-space(@name) != ''">
                           <D_369>
                              <xsl:value-of select="normalize-space(@name)"/>
                           </D_369>
                        </xsl:if>
                     </S_N9>
                     <xsl:variable name="comments" select="normalize-space(URL)"/>
                     <xsl:variable name="StrLen" select="string-length($comments)"/>
                     <xsl:call-template name="MSGLoop">
                        <xsl:with-param name="Desc" select="$comments"/>
                        <xsl:with-param name="StrLen" select="$StrLen"/>
                        <xsl:with-param name="Pos" select="1"/>
                        <xsl:with-param name="CurrentEndPos" select="1"/>
                     </xsl:call-template>
                  </G_N9>
               </xsl:for-each>
               <!-- TransportComments -->
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport']) != ''">
                  <G_N9>
                     <S_N9>
                        <D_128>0L</D_128>
                        <D_127>
                           <xsl:choose>
                              <xsl:when test="string-length(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport']/@xml:lang)) &gt; 1">
                                 <xsl:value-of select="upper-case(substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport']/@xml:lang), 1, 2))"/>
                              </xsl:when>
                              <xsl:otherwise>EN</xsl:otherwise>
                           </xsl:choose>
                        </D_127>
                        <D_369>TransportComments</D_369>
                     </S_N9>
                     <xsl:variable name="commentsTxt" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'Transport'])"/>
                     <xsl:variable name="StrLen" select="string-length($commentsTxt)"/>
                     <xsl:if test="$commentsTxt != ''">
                        <xsl:call-template name="MSGLoop">
                           <xsl:with-param name="Desc" select="$commentsTxt"/>
                           <xsl:with-param name="StrLen" select="$StrLen"/>
                           <xsl:with-param name="Pos" select="1"/>
                           <xsl:with-param name="CurrentEndPos" select="1"/>
                        </xsl:call-template>
                     </xsl:if>
                  </G_N9>
               </xsl:if>
               <!-- TODComments -->
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery']) != ''">
                  <G_N9>
                     <S_N9>
                        <D_128>0L</D_128>
                        <D_127>
                           <xsl:choose>
                              <xsl:when test="string-length(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery']/@xml:lang)) &gt; 1">
                                 <xsl:value-of select="upper-case(substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery']/@xml:lang), 1, 2))"/>
                              </xsl:when>
                              <xsl:otherwise>EN</xsl:otherwise>
                           </xsl:choose>
                        </D_127>
                        <D_369>TODComments</D_369>
                     </S_N9>
                     <xsl:variable name="commentsTxt" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Comments[@type = 'TermsOfDelivery'])"/>
                     <xsl:variable name="StrLen" select="string-length($commentsTxt)"/>
                     <xsl:if test="$commentsTxt != ''">
                        <xsl:call-template name="MSGLoop">
                           <xsl:with-param name="Desc" select="$commentsTxt"/>
                           <xsl:with-param name="StrLen" select="$StrLen"/>
                           <xsl:with-param name="Pos" select="1"/>
                           <xsl:with-param name="CurrentEndPos" select="1"/>
                        </xsl:call-template>
                     </xsl:if>
                  </G_N9>
               </xsl:if>
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'term']) != ''">
                  <G_N9>
                     <S_N9>
                        <D_128>U2</D_128>
                        <D_369>Terms</D_369>
                     </S_N9>
                     <xsl:variable name="termTxt" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'term'])"/>
                     <xsl:variable name="StrLen" select="string-length($termTxt)"/>
                     <xsl:if test="$termTxt != ''">
                        <xsl:call-template name="MSGLoop">
                           <xsl:with-param name="Desc" select="$termTxt"/>
                           <xsl:with-param name="StrLen" select="$StrLen"/>
                           <xsl:with-param name="Pos" select="1"/>
                           <xsl:with-param name="CurrentEndPos" select="1"/>
                        </xsl:call-template>
                     </xsl:if>
                  </G_N9>
               </xsl:if>
               <!-- 06292020 CG: IG-20382 -->
               <xsl:call-template name="MapControlKeys">
                  <xsl:with-param name="keys" select="cXML/Request/OrderRequest/OrderRequestHeader/ControlKeys"/>
               </xsl:call-template>
               <!-- IG-2352 -->
               <xsl:if test="cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType">
                  <G_N9>
                     <S_N9>
                        <D_128>43</D_128>
                        <D_127>External Document Reference</D_127>
                        <D_369>
                           <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType/@documentType), 1, 45)"/>
                        </D_369>
                     </S_N9>
                     <xsl:variable name="comments" select="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/OrderRequestHeaderIndustry/ExternalDocumentType/Description)"/>
                     <xsl:variable name="StrLen" select="string-length($comments)"/>
                     <xsl:call-template name="MSGLoop">
                        <xsl:with-param name="Desc" select="$comments"/>
                        <xsl:with-param name="StrLen" select="$StrLen"/>
                        <xsl:with-param name="Pos" select="1"/>
                        <xsl:with-param name="CurrentEndPos" select="1"/>
                     </xsl:call-template>
                  </G_N9>
               </xsl:if>
               <!-- 10042018 CG: Mapping of all remaining extrinsics added to template and update to use properties that can be dynamically updated            - Whenever adding an extrinsic mapped to an standard field, we should update lookup -->
               <xsl:variable name="standardExtrinsicsN9" select="tokenize($Lookup/Lookups/Properties/OrderHeaderStandardExtrinsics, ',')"/>
               <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[not(@name = $standardExtrinsicsN9)]">
                  <xsl:if test="normalize-space(.) != ''">
                     <G_N9>
                        <S_N9>
                           <D_128>ZZ</D_128>
                           <D_369>
                              <xsl:value-of select="substring(normalize-space(@name), 1, 45)"/>
                           </D_369>
                        </S_N9>
                        <xsl:variable name="comments" select="normalize-space(.)"/>
                        <xsl:variable name="StrLen" select="string-length($comments)"/>
                        <xsl:call-template name="MSGLoop">
                           <xsl:with-param name="Desc" select="$comments"/>
                           <xsl:with-param name="StrLen" select="$StrLen"/>
                           <xsl:with-param name="Pos" select="1"/>
                           <xsl:with-param name="CurrentEndPos" select="1"/>
                        </xsl:call-template>
                     </G_N9>
                  </xsl:if>
               </xsl:for-each>
               <!-- ShipTo -->
               <xsl:if test="exists(cXML/Request/OrderRequest/OrderRequestHeader/ShipTo)">
                  <xsl:call-template name="createN1_LineShipTo">
                     <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/ShipTo"/>
                  </xsl:call-template>
               </xsl:if>
               <!-- BillTo -->
               <xsl:call-template name="createN1">
                  <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/BillTo"/>
                  <xsl:with-param name="isOrder" select="'true'"/>
               </xsl:call-template>
               <!-- Terms Of Delivery Address -->
               <xsl:if test="exists(cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/Address)">
                  <xsl:call-template name="createN1">
                     <xsl:with-param name="party" select="cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery"/>
                     <xsl:with-param name="isOrder" select="'true'"/>
                  </xsl:call-template>
               </xsl:if>
               <!-- Contacts -->
               <xsl:for-each select="cXML/Request/OrderRequest/OrderRequestHeader/Contact">
                  <xsl:call-template name="createContact">
                     <xsl:with-param name="party" select="."/>
                     <xsl:with-param name="isOrder" select="'true'"/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- CG -->
               <xsl:if test="normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'buyerInfo']) != ''">
                  <G_N1>
                     <S_N1>
                        <D_98>BY</D_98>
                        <D_93>
                           <xsl:value-of select="substring(normalize-space(cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'buyerInfo']), 1, 60)"/>
                        </D_93>
                        <!-- len 60 -->
                     </S_N1>
                  </G_N1>
               </xsl:if>
               <!-- Details -->
               <xsl:for-each select="cXML/Request/OrderRequest/ItemOut">
                  <xsl:variable name="uom">
                     <xsl:choose>
                        <xsl:when test="ItemDetail/UnitOfMeasure != ''">
                           <xsl:value-of select="ItemDetail/UnitOfMeasure"/>
                        </xsl:when>
                        <xsl:when test="BlanketItemDetail/UnitOfMeasure != ''">
                           <xsl:value-of select="BlanketItemDetail/UnitOfMeasure"/>
                        </xsl:when>
                        <xsl:otherwise>ZZ</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="unitPrice">
                     <xsl:choose>
                        <xsl:when test="ItemDetail/Extrinsic[@name = 'hideUnitPrice']">0.00</xsl:when>
                        <xsl:when test="/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideUnitPrice']">0.00</xsl:when>
                        <xsl:when test="ItemDetail/UnitPrice/Money != ''">
                           <xsl:call-template name="formatAmount">
                              <xsl:with-param name="amount" select="ItemDetail/UnitPrice/Money"/>
                           </xsl:call-template>
                           <!--xsl:value-of select="format-number(number(replace(ItemDetail/UnitPrice/Money,',','')),'0.00')"/-->
                        </xsl:when>
                        <xsl:when test="BlanketItemDetail/UnitPrice/Money != ''">
                           <xsl:call-template name="formatAmount">
                              <xsl:with-param name="amount" select="BlanketItemDetail/UnitPrice/Money"/>
                           </xsl:call-template>
                           <!--xsl:value-of select="format-number(number(replace(BlanketItemDetail/UnitPrice/Money,',','')),'0.00')"/-->
                        </xsl:when>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="curr">
                     <xsl:choose>
                        <xsl:when test="ItemDetail/UnitPrice/Money/@currency">
                           <xsl:value-of select="ItemDetail/UnitPrice/Money/@currency"/>
                        </xsl:when>
                        <xsl:when test="BlanketItemDetail/UnitPrice/Money/@currency">
                           <xsl:value-of select="BlanketItemDetail/UnitPrice/Money/@currency"/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="altCurr">
                     <xsl:choose>
                        <xsl:when test="ItemDetail/UnitPrice/Money/@alternateCurrency">
                           <xsl:value-of select="ItemDetail/UnitPrice/Money/@alternateCurrency"/>
                        </xsl:when>
                        <xsl:when test="BlanketItemDetail/UnitPrice/Money/@alternateCurrency">
                           <xsl:value-of select="BlanketItemDetail/UnitPrice/Money/@alternateCurrency"/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:variable>
                  <G_POC>
                     <S_POC>
                        <D_350>
                           <xsl:choose>
                              <xsl:when test="normalize-space(./@lineNumber) != ''">
                                 <xsl:value-of select="./@lineNumber"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="position()"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </D_350>
                        <D_670>
                           <xsl:choose>
                              <xsl:when test="/cXML/Request/OrderRequest/OrderRequestHeader/@type = 'update'">RZ</xsl:when>
                              <xsl:when test="/cXML/Request/OrderRequest/OrderRequestHeader/@type = 'delete'">CF</xsl:when>
                              <xsl:otherwise>RZ</xsl:otherwise>
                           </xsl:choose>
                        </D_670>
                        <D_330>
                           <xsl:call-template name="formatQty">
                              <xsl:with-param name="qty" select="./@quantity"/>
                           </xsl:call-template>
                           <!--xsl:value-of select="format-number(./@quantity,'0.##')"/-->
                        </D_330>
                        <D_671>
                           <xsl:call-template name="formatQty">
                              <xsl:with-param name="qty" select="./@quantity"/>
                           </xsl:call-template>
                           <!--xsl:value-of select="format-number(./@quantity,'0.##')"/-->
                        </D_671>
                        <C_C001>
                           <D_355>
                              <xsl:choose>
                                 <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
                                 </xsl:when>
                                 <xsl:otherwise>ZZ</xsl:otherwise>
                              </xsl:choose>
                           </D_355>
                        </C_C001>
                        <xsl:if test="$unitPrice != ''">
                           <D_212>
                              <xsl:value-of select="$unitPrice"/>
                           </D_212>
                        </xsl:if>
                        <xsl:call-template name="createItemParts">
                           <xsl:with-param name="itemID" select="ItemID"/>
                           <xsl:with-param name="itemDetail" select="ItemDetail"/>
                        </xsl:call-template>
                     </S_POC>
                     <!-- CG : added 1/4/2017 -->
                     <xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'purchaseDescription']) != '' or normalize-space(ItemDetail/Extrinsic[@name = 'merchandiseTypeCode']) != ''">
                        <S_LIN>
                           <D_350>
                              <xsl:choose>
                                 <xsl:when test="normalize-space(./@lineNumber) != ''">
                                    <xsl:value-of select="./@lineNumber"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="position()"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </D_350>
                           <xsl:choose>
                              <xsl:when test="normalize-space(ItemDetail/Extrinsic[@name = 'purchaseDescription']) != ''">
                                 <D_235>SZ</D_235>
                                 <D_234>
                                    <xsl:value-of select="substring(normalize-space(ItemDetail/Extrinsic[@name = 'purchaseDescription']), 1, 48)"/>
                                 </D_234>
                                 <xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'merchandiseTypeCode']) != ''">
                                    <D_235_2>CL</D_235_2>
                                    <D_234_2>
                                       <xsl:value-of select="substring(normalize-space(ItemDetail/Extrinsic[@name = 'merchandiseTypeCode']), 1, 48)"/>
                                    </D_234_2>
                                 </xsl:if>
                              </xsl:when>
                              <xsl:when test="normalize-space(ItemDetail/Extrinsic[@name = 'merchandiseTypeCode']) != ''">
                                 <D_235>CL</D_235>
                                 <D_234>
                                    <xsl:value-of select="substring(normalize-space(ItemDetail/Extrinsic[@name = 'merchandiseTypeCode']), 1, 48)"/>
                                 </D_234>
                              </xsl:when>
                           </xsl:choose>
                        </S_LIN>
                     </xsl:if>
                     <!-- currency -->
                     <xsl:if test="$curr != ''">
                        <S_CUR>
                           <D_98>BY</D_98>
                           <D_100>
                              <xsl:value-of select="$curr"/>
                           </D_100>
                           <xsl:if test="$altCurr != ''">
                              <D_98_2>ZZ</D_98_2>
                              <D_100_2>
                                 <xsl:value-of select="$altCurr"/>
                              </D_100_2>
                           </xsl:if>
                        </S_CUR>
                     </xsl:if>
                     <!-- BlanketItemDetail -->
                     <xsl:if test="exists(BlanketItemDetail)">
                        <xsl:variable name="uom" select="BlanketItemDetail/UnitOfMeasure"/>
                        <S_PO3>
                           <D_371>ZZ</D_371>
                           <D_639>ST</D_639>
                           <D_380>
                              <xsl:call-template name="formatQty">
                                 <xsl:with-param name="qty" select="./@quantity"/>
                              </xsl:call-template>
                              <!--xsl:value-of select="format-number(./@quantity,'0.##')"/-->
                           </D_380>
                           <D_355>
                              <xsl:choose>
                                 <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
                                 </xsl:when>
                                 <xsl:otherwise>ZZ</xsl:otherwise>
                              </xsl:choose>
                           </D_355>
                        </S_PO3>
                     </xsl:if>
                     <!-- PriceBasisQuantity -->
                     <xsl:if test="ItemDetail/PriceBasisQuantity/@quantity != '' or BlanketItemDetail/PriceBasisQuantity/@quantity != ''">
                        <S_CTP>
                           <D_687>
                              <xsl:choose>
                                 <xsl:when test="ItemDetail/PriceBasisQuantity/@quantity != ''">WS</xsl:when>
                                 <xsl:when test="BlanketItemDetail/PriceBasisQuantity/@quantity != ''">PY</xsl:when>
                              </xsl:choose>
                           </D_687>
                           <D_380>
                              <xsl:choose>
                                 <xsl:when test="ItemDetail/PriceBasisQuantity/@quantity != ''">
                                    <xsl:call-template name="formatQty">
                                       <xsl:with-param name="qty" select="ItemDetail/PriceBasisQuantity/@quantity"/>
                                    </xsl:call-template>
                                    <!--xsl:value-of select="format-number(ItemDetail/PriceBasisQuantity/@quantity,'0.##')"/-->
                                 </xsl:when>
                                 <xsl:when test="BlanketItemDetail/PriceBasisQuantity/@quantity != ''">
                                    <xsl:call-template name="formatQty">
                                       <xsl:with-param name="qty" select="BlanketItemDetail/PriceBasisQuantity/@quantity"/>
                                    </xsl:call-template>
                                    <!--xsl:value-of select="format-number(BlanketItemDetail/PriceBasisQuantity/@quantity,'0.##')"/-->
                                 </xsl:when>
                              </xsl:choose>
                           </D_380>
                           <xsl:variable name="pbqUom">
                              <xsl:choose>
                                 <xsl:when test="ItemDetail/PriceBasisQuantity/UnitOfMeasure">
                                    <xsl:value-of select="ItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                                 </xsl:when>
                                 <xsl:when test="BlanketItemDetail/PriceBasisQuantity/UnitOfMeasure">
                                    <xsl:value-of select="BlanketItemDetail/PriceBasisQuantity/UnitOfMeasure"/>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:variable>
                           <C_C001>
                              <D_355>
                                 <xsl:choose>
                                    <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $pbqUom]/X12Code != ''">
                                       <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $pbqUom]/X12Code"/>
                                    </xsl:when>
                                    <xsl:otherwise>ZZ</xsl:otherwise>
                                 </xsl:choose>
                              </D_355>
                           </C_C001>
                           <D_648>CSD</D_648>
                           <xsl:variable name="convFactor">
                              <xsl:choose>
                                 <xsl:when test="ItemDetail/PriceBasisQuantity/@conversionFactor">
                                    <xsl:value-of select="ItemDetail/PriceBasisQuantity/@conversionFactor"/>
                                 </xsl:when>
                                 <xsl:when test="BlanketItemDetail/PriceBasisQuantity/@conversionFactor">
                                    <xsl:value-of select="BlanketItemDetail/PriceBasisQuantity/@conversionFactor"/>
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:variable>
                           <D_649>
                              <xsl:choose>
                                 <xsl:when test="contains($convFactor, '.')">
                                    <xsl:value-of select="substring($convFactor, 1, 10)"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="$convFactor"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </D_649>
                        </S_CTP>
                     </xsl:if>
                     <!-- BlanketItemDetail elements -->
                     <!-- MaxAmount -->
                     <xsl:if test="BlanketItemDetail/MaxAmount/Money != ''">
                        <S_CTP>
                           <D_687>TR</D_687>
                           <D_236>MAX</D_236>
                           <D_212>
                              <xsl:call-template name="formatAmount">
                                 <xsl:with-param name="amount" select="BlanketItemDetail/MaxAmount/Money"/>
                              </xsl:call-template>
                              <!--xsl:value-of select="format-number(number(replace(BlanketItemDetail/MaxAmount/Money,',','')),'0.00')"/-->
                           </D_212>
                        </S_CTP>
                     </xsl:if>
                     <!-- MinAmount -->
                     <xsl:if test="BlanketItemDetail/MinAmount/Money != ''">
                        <S_CTP>
                           <D_687>TR</D_687>
                           <D_236>MIN</D_236>
                           <D_212>
                              <xsl:call-template name="formatAmount">
                                 <xsl:with-param name="amount" select="BlanketItemDetail/MinAmount/Money"/>
                              </xsl:call-template>
                              <!--xsl:value-of select="format-number(number(replace(BlanketItemDetail/MinAmount/Money,',','')),'0.00')"/-->
                           </D_212>
                        </S_CTP>
                     </xsl:if>
                     <!-- BlanketItemDetail Unit Price -->
                     <xsl:if test="BlanketItemDetail/UnitPrice/Money != ''">
                        <S_CTP>
                           <D_687>TR</D_687>
                           <D_236>UCP</D_236>
                           <D_212>
                              <xsl:choose>
                                 <xsl:when test="BlanketItemDetail/Extrinsic[@name = 'hideUnitPrice']">0</xsl:when>
                                 <xsl:when test="/cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideUnitPrice']">0</xsl:when>
                                 <xsl:otherwise>
                                    <xsl:call-template name="formatAmount">
                                       <xsl:with-param name="amount" select="BlanketItemDetail/UnitPrice/Money"/>
                                    </xsl:call-template>
                                    <!--xsl:value-of select="format-number(number(replace(BlanketItemDetail/UnitPrice/Money,',','')),'0.00')"/-->
                                 </xsl:otherwise>
                              </xsl:choose>
                           </D_212>
                        </S_CTP>
                     </xsl:if>
                     <xsl:for-each select="ItemDetail/Dimension">
                        <xsl:if test="(position() &lt; 41)">
                           <xsl:call-template name="createMEA_FromDimension">
                              <xsl:with-param name="dimension" select="."/>
                              <xsl:with-param name="meaQual" select="'PD'"/>
                           </xsl:call-template>
                        </xsl:if>
                     </xsl:for-each>
                     <!-- Packaging Dimension -->
                     <xsl:for-each select="Packaging">
                        <xsl:for-each select="Dimension">
                           <xsl:call-template name="createMEA_FromDimension">
                              <xsl:with-param name="dimension" select="."/>
                              <xsl:with-param name="meaQual" select="'PK'"/>
                           </xsl:call-template>
                        </xsl:for-each>
                     </xsl:for-each>
                     <xsl:if test="lower-case(normalize-space(@itemClassification)) = 'material' or lower-case(normalize-space(@itemClassification)) = 'service'">
                        <G_PID>
                           <S_PID>
                              <D_349>F</D_349>
                              <D_750>12</D_750>
                              <D_352>
                                 <xsl:value-of select="normalize-space(@itemClassification)"/>
                              </D_352>
                           </S_PID>
                        </G_PID>
                     </xsl:if>
                     <xsl:if test="normalize-space(ItemDetail/ItemDetailIndustry/@isConfigurableMaterial) = 'yes'">
                        <G_PID>
                           <S_PID>
                              <D_349>F</D_349>
                              <D_750>21</D_750>
                              <D_352>
                                 <xsl:value-of select="'Configurable Material'"/>
                              </D_352>
                           </S_PID>
                        </G_PID>
                     </xsl:if>
                     <!-- ShortName -->
                     <xsl:choose>
                        <xsl:when test="normalize-space(ItemDetail/Description/ShortName) != ''">
                           <G_PID>
                              <S_PID>
                                 <D_349>F</D_349>
                                 <D_750>GEN</D_750>
                                 <D_352>
                                    <xsl:value-of select="substring(normalize-space(ItemDetail/Description/ShortName), 1, 80)"/>
                                 </D_352>
                                 <D_819>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(ItemDetail/Description/@xml:lang)) &gt; 1">
                                          <xsl:value-of select="upper-case(substring(normalize-space(ItemDetail/Description/@xml:lang), 1, 2))"/>
                                       </xsl:when>
                                       <xsl:otherwise>EN</xsl:otherwise>
                                    </xsl:choose>
                                 </D_819>
                              </S_PID>
                           </G_PID>
                        </xsl:when>
                        <xsl:when test="normalize-space(BlanketItemDetail/Description/ShortName) != ''">
                           <G_PID>
                              <S_PID>
                                 <D_349>F</D_349>
                                 <D_750>GEN</D_750>
                                 <D_352>
                                    <xsl:value-of select="substring(normalize-space(BlanketItemDetail/Description/ShortName), 1, 80)"/>
                                 </D_352>
                                 <D_819>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(BlanketItemDetail/Description/@xml:lang)) &gt; 1">
                                          <xsl:value-of select="upper-case(substring(normalize-space(BlanketItemDetail/Description/@xml:lang), 1, 2))"/>
                                       </xsl:when>
                                       <xsl:otherwise>EN</xsl:otherwise>
                                    </xsl:choose>
                                 </D_819>
                              </S_PID>
                           </G_PID>
                        </xsl:when>
                     </xsl:choose>
                     <!-- Description -->
                     <xsl:variable name="desc">
                        <xsl:choose>
                           <xsl:when test="normalize-space(ItemDetail/Description) != ''">
                              <xsl:value-of select="normalize-space(ItemDetail/Description)"/>
                           </xsl:when>
                           <xsl:when test="normalize-space(BlanketItemDetail/Description) != ''">
                              <xsl:value-of select="normalize-space(BlanketItemDetail/Description)"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="langCode">
                        <xsl:choose>
                           <xsl:when test="string-length(normalize-space(ItemDetail/Description/@xml:lang)) &gt; 1">
                              <xsl:value-of select="upper-case(substring(normalize-space(ItemDetail/Description/@xml:lang), 1, 2))"/>
                           </xsl:when>
                           <xsl:when test="string-length(normalize-space(BlanketItemDetail/Description/@xml:lang)) &gt; 1">
                              <xsl:value-of select="upper-case(substring(normalize-space(BlanketItemDetail/Description/@xml:lang), 1, 2))"/>
                           </xsl:when>
                           <xsl:otherwise>EN</xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="StrLen" select="string-length($desc)"/>
                     <xsl:if test="$StrLen &gt; 0">
                        <xsl:call-template name="PIDloop">
                           <xsl:with-param name="Desc" select="$desc"/>
                           <xsl:with-param name="langCode" select="$langCode"/>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- ItemDetail Classification -->
                     <xsl:for-each select="ItemDetail/Classification">
                        <!-- CG -->
                        <xsl:if test="normalize-space(.) != ''">
                           <G_PID>
                              <S_PID>
                                 <D_349>S</D_349>
                                 <D_750>MAC</D_750>
                                 <D_559>
                                    <xsl:choose>
                                       <xsl:when test="./@domain = 'UNSPSC'">UN</xsl:when>
                                       <xsl:otherwise>AS</xsl:otherwise>
                                    </xsl:choose>
                                 </D_559>
                                 <D_751>
                                    <xsl:choose>
                                       <xsl:when test="normalize-space(.) != ''">
                                          <xsl:value-of select="substring(normalize-space(.), 1, 12)"/>
                                       </xsl:when>
                                       <xsl:otherwise>Not Provided</xsl:otherwise>
                                    </xsl:choose>
                                 </D_751>
                                 <xsl:if test="normalize-space(./@domain)!=''">
                                    <D_822>
                                       <xsl:choose>
                                          <xsl:when test="./@domain = 'UNSPSC'">SPSC</xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="substring(normalize-space(./@domain), 1, 15)"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </D_822>
                                 </xsl:if>
                              </S_PID>
                           </G_PID>
                        </xsl:if>
                     </xsl:for-each>
                     <!-- BlanketItemDetail Classification -->
                     <xsl:for-each select="BlanketItemDetail/Classification">
                        <xsl:if test="normalize-space(.) != ''">
                           <G_PID>
                              <S_PID>
                                 <D_349>S</D_349>
                                 <D_750>MAC</D_750>
                                 <D_559>
                                    <xsl:choose>
                                       <xsl:when test="./@domain = 'UNSPSC'">UN</xsl:when>
                                       <xsl:otherwise>AS</xsl:otherwise>
                                    </xsl:choose>
                                 </D_559>
                                 <D_751>
                                    <xsl:choose>
                                       <xsl:when test="normalize-space(.) != ''">
                                          <xsl:value-of select="substring(normalize-space(.), 1, 12)"/>
                                       </xsl:when>
                                       <xsl:otherwise>Not Provided</xsl:otherwise>
                                    </xsl:choose>
                                 </D_751>
                                 <xsl:if test="normalize-space(./@domain)!=''">
                                    <D_822>
                                       <xsl:choose>
                                          <xsl:when test="./@domain = 'UNSPSC'">SPSC</xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="substring(normalize-space(./@domain), 1, 15)"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </D_822>
                                 </xsl:if>
                              </S_PID>
                           </G_PID>
                        </xsl:if>
                     </xsl:for-each>
                     <!-- ShippingInstructions -->
                     <xsl:if test="string-length(normalize-space(./ShipTo/TransportInformation/ShippingInstructions/Description)) &gt; 0">
                        <xsl:call-template name="PIDloop">
                           <xsl:with-param name="Desc" select="normalize-space(./ShipTo/TransportInformation/ShippingInstructions/Description)"/>
                           <xsl:with-param name="langCode" select="./ShipTo/TransportInformation/ShippingInstructions/Description/@xml:lang"/>
                           <xsl:with-param name="isShipIns" select="'yes'"/>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- Packaging -->
                     <xsl:for-each select="Packaging">
                        <xsl:call-template name="createPKG_FromPackaging">
                           <xsl:with-param name="packaging" select="."/>
                           <xsl:with-param name="noGroup" select="'true'"/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- itemChanged and reason for change -->
                     <xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'isItemChanged']) != ''">
                        <S_REF>
                           <D_128>T8</D_128>
                           <D_127>
                              <xsl:value-of select="substring(normalize-space(ItemDetail/Extrinsic[@name = 'isItemChanged']), 1, 30)"/>
                           </D_127>
                           <xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'reasonForChange']) != ''">
                              <D_352>
                                 <xsl:value-of select="substring(normalize-space(ItemDetail/Extrinsic[@name = 'reasonForChange']), 1, 80)"/>
                              </D_352>
                           </xsl:if>
                        </S_REF>
                     </xsl:if>
                     <!-- requisitionID -->
                     <xsl:if test="normalize-space(@requisitionID) != ''">
                        <xsl:call-template name="createREF">
                           <xsl:with-param name="qual" select="'RQ'"/>
                           <xsl:with-param name="ref02" select="normalize-space(@requisitionID)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- SupplierID -->
                     <xsl:if test="normalize-space(SupplierID) != ''">
                        <S_REF>
                           <D_128>ZA</D_128>
                           <D_127>
                              <xsl:value-of select="substring(normalize-space(SupplierID), 1, 30)"/>
                           </D_127>
                           <D_352>
                              <xsl:value-of select="substring(normalize-space(SupplierID/@domain), 1, 80)"/>
                           </D_352>
                        </S_REF>
                     </xsl:if>
                     <!-- parentLineNumber and itemType-->
                     <xsl:if test="@parentLineNumber != '' or @itemType != ''">
                        <S_REF>
                           <D_128>FL</D_128>
                           <xsl:if test="@parentLineNumber != ''">
                              <D_127>
                                 <xsl:value-of select="@parentLineNumber"/>
                              </D_127>
                           </xsl:if>
                           <xsl:if test="@itemType">
                              <D_352>
                                 <xsl:value-of select="@itemType"/>
                              </D_352>
                           </xsl:if>
                        </S_REF>
                     </xsl:if>
                     <!-- Custom TransportTerms -->
                     <xsl:if test="TermsOfDelivery/TransportTerms/@value = 'Other' and normalize-space(TermsOfDelivery/TransportTerms) != ''">
                        <S_REF>
                           <D_128>0L</D_128>
                           <D_127>FOB05</D_127>
                           <D_352>
                              <xsl:value-of select="substring(normalize-space(TermsOfDelivery/TransportTerms), 1, 80)"/>
                           </D_352>
                        </S_REF>
                     </xsl:if>
                     <!-- Shipping -->
                     <xsl:if test="normalize-space(Shipping/@trackingDomain) != '' or normalize-space(Shipping/@trackingId) != ''">
                        <S_REF>
                           <D_128>2I</D_128>
                           <D_127>
                              <xsl:value-of select="substring(normalize-space(Shipping/@trackingDomain), 1, 30)"/>
                           </D_127>
                           <D_352>
                              <xsl:value-of select="substring(normalize-space(Shipping/@trackingId), 1, 80)"/>
                           </D_352>
                        </S_REF>
                     </xsl:if>
                     <!-- SupplierBatchID -->
                     <xsl:if test="normalize-space(Batch/SupplierBatchID) != ''">
                        <S_REF>
                           <D_128>BT</D_128>
                           <D_127>
                              <xsl:value-of select="substring(normalize-space(Batch/SupplierBatchID), 1, 30)"/>
                           </D_127>
                        </S_REF>
                     </xsl:if>
                     <!-- BuyerBatchID -->
                     <xsl:if test="normalize-space(Batch/BuyerBatchID) != ''">
                        <S_REF>
                           <D_128>LT</D_128>
                           <D_127>
                              <xsl:value-of select="substring(normalize-space(Batch/BuyerBatchID), 1, 30)"/>
                           </D_127>
                        </S_REF>
                     </xsl:if>
                     <xsl:if test="normalize-space(@returnAuthorizationNumber) != ''">
                        <S_REF>
                           <D_128>QJ</D_128>
                           <D_127>
                              <xsl:value-of select="substring(normalize-space(@returnAuthorizationNumber), 1, 30)"/>
                           </D_127>
                        </S_REF>
                     </xsl:if>
                     <xsl:if test="normalize-space(@itemCategory) != ''">
                        <S_REF>
                           <D_128>KQ</D_128>
                           <D_127>
                              <xsl:value-of select="substring(normalize-space(@itemCategory), 1, 30)"/>
                           </D_127>
                        </S_REF>
                     </xsl:if>
                     <!-- MasterAgreementIDInfo / @agreementID -->
                     <xsl:if test="normalize-space(MasterAgreementIDInfo/@agreementID) != ''">
                        <xsl:call-template name="createREF">
                           <xsl:with-param name="qual" select="'AH'"/>
                           <xsl:with-param name="ref03" select="MasterAgreementIDInfo/@agreementID"/>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- ItemDetail/Extrinsic -->
                     <xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'engineeringSpecificationNo']) != ''">
                        <xsl:call-template name="createREF">
                           <xsl:with-param name="qual" select="'S1'"/>
                           <xsl:with-param name="ref03" select="normalize-space(ItemDetail/Extrinsic[@name = 'engineeringSpecificationNo'])"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="normalize-space(ItemDetail/Extrinsic[@name = 'customerOrderNo']) != ''">
                        <xsl:call-template name="createREF">
                           <xsl:with-param name="qual" select="'CO'"/>
                           <xsl:with-param name="ref03" select="normalize-space(ItemDetail/Extrinsic[@name = 'customerOrderNo'])"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="normalize-space(ItemDetail/PlannedAcceptanceDays) != ''">
                        <xsl:call-template name="createREF">
                           <xsl:with-param name="qual" select="'IP'"/>
                           <xsl:with-param name="ref02" select="'Inspection Days'"/>
                           <xsl:with-param name="ref03" select="normalize-space(ItemDetail/PlannedAcceptanceDays)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:for-each select="ItemOutIndustry/SerialNumberInfo/SerialNumber">
                        <xsl:if test="normalize-space(.) != ''">
                           <xsl:call-template name="createREF">
                              <xsl:with-param name="qual" select="'SE'"/>
                              <xsl:with-param name="ref02" select="normalize-space(.)"/>
                           </xsl:call-template>
                        </xsl:if>
                     </xsl:for-each>
                     <xsl:if test="normalize-space(ItemOutIndustry/@planningType) != ''">
                        <xsl:call-template name="createREF">
                           <xsl:with-param name="qual" select="'18'"/>
                           <xsl:with-param name="ref02" select="'Planning Type'"/>
                           <xsl:with-param name="ref03" select="normalize-space(ItemOutIndustry/@planningType)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="normalize-space(@agreementItemNumber) != ''">
                        <xsl:call-template name="createREF">
                           <xsl:with-param name="qual" select="'CT'"/>
                           <xsl:with-param name="ref02" select="normalize-space(@agreementItemNumber)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:for-each select="ItemDetail/Extrinsic[@name != 'customerOrderNo' and @name != 'engineeringSpecificationNo' and @name != '']">
                        <xsl:call-template name="mapItemPOCOExtrinsics">
                           <xsl:with-param name="doExtrinsicsLookup" select="$useExtrinsicsLookup"></xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- BlanketItemDetail/Extrinsic -->
                     <xsl:for-each select="BlanketItemDetail/Extrinsic">
                        <xsl:call-template name="mapItemPOCOExtrinsics">
                           <xsl:with-param name="doExtrinsicsLookup" select="$useExtrinsicsLookup"></xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- Shipping -->
                     <xsl:if test="exists(Shipping) and normalize-space(Shipping/Money) != ''">
                        <G_SAC>
                           <S_SAC>
                              <D_248>C</D_248>
                              <D_1300>G830</D_1300>
                              <D_610>
                                 <xsl:call-template name="formatAmount">
                                    <xsl:with-param name="amount" select="Shipping/Money"/>
                                    <xsl:with-param name="formatDecimals" select="'N2'"/>
                                 </xsl:call-template>
                                 <!--xsl:value-of select="replace(format-number(number(replace(Shipping/Money,',','')),'#.00'),'\.','')"/-->
                              </D_610>
                              <xsl:if test="normalize-space(Shipping/@tracking) != ''">
                                 <D_127>
                                    <xsl:value-of select="substring(normalize-space(Shipping/@tracking), 1, 30)"/>
                                 </D_127>
                              </xsl:if>
                              <xsl:if test="normalize-space(Shipping/Description/ShortName) != '' or normalize-space(Shipping/Description) != ''">
                                 <D_352>
                                    <xsl:choose>
                                       <xsl:when test="Shipping/Description/ShortName != ''">
                                          <xsl:value-of select="substring(normalize-space(Shipping/Description/ShortName), 1, 80)"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="substring(normalize-space(Shipping/Description), 1, 80)"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </D_352>
                                 <D_819>
                                    <xsl:choose>
                                       <xsl:when test="string-length(normalize-space(Shipping/Description/@xml:lang)) &gt; 1">
                                          <xsl:value-of select="upper-case(substring(normalize-space(Shipping/Description/@xml:lang), 1, 2))"/>
                                       </xsl:when>
                                       <xsl:otherwise>EN</xsl:otherwise>
                                    </xsl:choose>
                                 </D_819>
                              </xsl:if>
                           </S_SAC>
                           <S_CUR>
                              <D_98>BY</D_98>
                              <D_100>
                                 <xsl:value-of select="Shipping/Money/@currency"/>
                              </D_100>
                              <xsl:if test="Shipping/Money/@alternateAmount != ''">
                                 <D_280>
                                    <xsl:call-template name="formatAmount">
                                       <xsl:with-param name="amount" select="Shipping/Money/@alternateAmount"/>
                                    </xsl:call-template>
                                    <!--xsl:value-of select="format-number(number(replace(Shipping/Money/@alternateAmount,',','')),'0000')"/-->
                                 </D_280>
                              </xsl:if>
                              <xsl:if test="Shipping/Money/@alternateCurrency">
                                 <D_98_2>SE</D_98_2>
                                 <D_100_2>
                                    <xsl:value-of select="Shipping/Money/@alternateCurrency"/>
                                 </D_100_2>
                              </xsl:if>
                           </S_CUR>
                        </G_SAC>
                     </xsl:if>
                     <!-- Modifications-->
                     <xsl:for-each select="./ItemDetail/UnitPrice/Modifications/Modification">
                        <xsl:call-template name="createSAC_FromModifications">
                           <xsl:with-param name="modification" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- Modifications-->
                     <xsl:for-each select="./BlanketItemDetail/UnitPrice/Modifications/Modification">
                        <xsl:call-template name="createSAC_FromModifications">
                           <xsl:with-param name="modification" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- Distribution -->
                     <xsl:for-each select="Distribution">
                        <xsl:call-template name="createSAC_FromDistribution">
                           <xsl:with-param name="distribution" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- TermsOfDelivery -->
                     <xsl:if test="TermsOfDelivery/ShippingPaymentMethod/@value != ''">
                        <xsl:variable name="TOD" select="TermsOfDelivery/ShippingPaymentMethod/@value"/>
                        <S_FOB>
                           <D_146>
                              <xsl:choose>
                                 <xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code != ''">
                                    <xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code"/>
                                 </xsl:when>
                                 <xsl:otherwise>DF</xsl:otherwise>
                              </xsl:choose>
                           </D_146>
                           <D_309>
                              <xsl:choose>
                                 <xsl:when test="lower-case(TermsOfDelivery/TermsOfDeliveryCode/@value) = 'other'">ZZ</xsl:when>
                                 <xsl:otherwise>OF</xsl:otherwise>
                              </xsl:choose>
                           </D_309>
                           <D_352>
                              <xsl:choose>
                                 <xsl:when test="lower-case(TermsOfDelivery/TermsOfDeliveryCode/@value) = 'other'">
                                    <xsl:value-of select="TermsOfDelivery/TermsOfDeliveryCode"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="TermsOfDelivery/TermsOfDeliveryCode/@value"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </D_352>
                           <xsl:if test="exists(TermsOfDelivery/TransportTerms)">
                              <xsl:variable name="TTVal" select="normalize-space(TermsOfDelivery/TransportTerms/@value)"/>
                              <D_334>01</D_334>
                              <D_335>
                                 <xsl:choose>
                                    <xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code != ''">
                                       <xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code"/>
                                    </xsl:when>
                                    <!-- IG-31554 -->
                                    <xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $TTVal]/X12Code != ''">
                                       <xsl:value-of select="$TTVal"/>
                                    </xsl:when>
                                    <xsl:otherwise>ZZZ</xsl:otherwise>
                                 </xsl:choose>
                              </D_335>
                           </xsl:if>
                           <D_309_2>ZZ</D_309_2>
                           <D_352_2>
                              <xsl:choose>
                                 <xsl:when test="lower-case(TermsOfDelivery/ShippingPaymentMethod/@value) = 'other'">
                                    <xsl:value-of select="TermsOfDelivery/ShippingPaymentMethod"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:value-of select="TermsOfDelivery/ShippingPaymentMethod/@value"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </D_352_2>
                        </S_FOB>
                     </xsl:if>
                     <!-- 06292020 CG: IG-18119 -->
                     <xsl:for-each select="ItemOutIndustry/PackagingDistribution">
                        <xsl:call-template name="mapPackageDistribution">
                           <xsl:with-param name="pckgDist" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- requestedDeliveryDate -->
                     <xsl:if test="@requestedDeliveryDate != ''">
                        <xsl:call-template name="createDTM">
                           <xsl:with-param name="D374_Qual">002</xsl:with-param>
                           <xsl:with-param name="cXMLDate">
                              <xsl:value-of select="@requestedDeliveryDate"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- requestedShipmentDate -->
                     <xsl:if test="@requestedShipmentDate != ''">
                        <xsl:call-template name="createDTM">
                           <xsl:with-param name="D374_Qual">010</xsl:with-param>
                           <xsl:with-param name="cXMLDate">
                              <xsl:value-of select="@requestedShipmentDate"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- agreementDate -->
                     <xsl:if test="MasterAgreementIDInfo/@agreementDate != ''">
                        <xsl:call-template name="createDTM">
                           <xsl:with-param name="D374_Qual">LEA</xsl:with-param>
                           <xsl:with-param name="cXMLDate">
                              <xsl:value-of select="MasterAgreementIDInfo/@agreementDate"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- CG: IG-20471 - Add SpendDetail start/end dates -->
                     <xsl:if test="SpendDetail/Extrinsic[@name='ServicePeriod']/Period/@startDate != ''">
                        <xsl:call-template name="createDTM">
                           <xsl:with-param name="D374_Qual">150</xsl:with-param>
                           <xsl:with-param name="cXMLDate">
                              <xsl:value-of select="SpendDetail/Extrinsic[@name='ServicePeriod']/Period/@startDate"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="SpendDetail/Extrinsic[@name='ServicePeriod']/Period/@endDate != ''">
                        <xsl:call-template name="createDTM">
                           <xsl:with-param name="D374_Qual">151</xsl:with-param>
                           <xsl:with-param name="cXMLDate">
                              <xsl:value-of select="SpendDetail/Extrinsic[@name='ServicePeriod']/Period/@endDate"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- Tax -->
                     <xsl:if test="Tax/Money != ''">
                        <S_TXI>
                           <D_963>TX</D_963>
                           <D_782>
                              <xsl:call-template name="formatAmount">
                                 <xsl:with-param name="amount" select="Tax/Money"/>
                              </xsl:call-template>
                              <!--xsl:value-of select="format-number(number(replace(Tax/Money,',','')),'0.00')"/-->
                           </D_782>
                        </S_TXI>
                     </xsl:if>
                     <!-- TaxDetail -->
                     <xsl:for-each select="Tax/TaxDetail">
                        <xsl:call-template name="createTXI_FromTaxDetail">
                           <xsl:with-param name="taxDetail" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- MinQuantity -->
                     <xsl:if test="BlanketItemDetail/MinQuantity != ''">
                        <G_QTY>
                           <S_QTY>
                              <D_673>7E</D_673>
                              <D_380>
                                 <xsl:call-template name="formatQty">
                                    <xsl:with-param name="qty" select="BlanketItemDetail/MinQuantity"/>
                                 </xsl:call-template>
                                 <!--xsl:value-of select="BlanketItemDetail/MinQuantity"/-->
                              </D_380>
                           </S_QTY>
                        </G_QTY>
                     </xsl:if>
                     <!-- MaxQuantity -->
                     <xsl:if test="BlanketItemDetail/MaxQuantity">
                        <G_QTY>
                           <S_QTY>
                              <D_673>7D</D_673>
                              <D_380>
                                 <xsl:call-template name="formatQty">
                                    <xsl:with-param name="qty" select="BlanketItemDetail/MaxQuantity"/>
                                 </xsl:call-template>
                                 <!--xsl:value-of select="BlanketItemDetail/MaxQuantity"/-->
                              </D_380>
                           </S_QTY>
                        </G_QTY>
                     </xsl:if>
                     <!-- ScheduleLine -->
                     <xsl:for-each select="ScheduleLine">
                        <xsl:call-template name="createSCH_FromScheduleLine">
                           <xsl:with-param name="scheduleLine" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- IG-2073 -->
                     <xsl:if test="./@isDeliveryCompleted = 'yes'">
                        <G_N9>
                           <S_N9>
                              <D_128>ACC</D_128>
                              <D_127>delivery complete</D_127>
                              <D_369>
                                 <xsl:value-of select="'yes'"/>
                              </D_369>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <!-- ItemDetail URL -->
                     <xsl:if test="ItemDetail/URL != ''">
                        <G_N9>
                           <S_N9>
                              <D_128>URL</D_128>
                              <D_127>URL</D_127>
                              <D_369>
                                 <xsl:value-of select="ItemDetail/URL/@name"/>
                              </D_369>
                           </S_N9>
                           <S_MSG>
                              <D_933>
                                 <xsl:value-of select="ItemDetail/URL"/>
                              </D_933>
                           </S_MSG>
                        </G_N9>
                     </xsl:if>
                     <!-- Comments -->
                  	<xsl:for-each select="Comments">
                  		<xsl:if test="normalize-space(.) != ''">
                  			<G_N9>
                  				<S_N9>
                  					<D_128>L1</D_128>
                  					<D_127>
                  						<xsl:choose>
                  							<xsl:when test="string-length(normalize-space(@xml:lang)) &gt; 1">
                  								<xsl:value-of select="upper-case(substring(normalize-space(@xml:lang), 1, 2))"/>
                  							</xsl:when>
                  							<xsl:otherwise>EN</xsl:otherwise>
                  						</xsl:choose>
                  					</D_127>
                  					<D_369>Comments</D_369>
                  					<xsl:if test="normalize-space(@type) != ''">
                  						<C_C040>
                  							<D_128>L1</D_128>
                  							<D_127><xsl:value-of select="substring(normalize-space(@type), 1, 30)"/></D_127>
                  						</C_C040>
                  					</xsl:if>
                  				</S_N9>
                  				<xsl:variable name="comments" select="normalize-space(.)"/>
                  				<xsl:variable name="StrLen" select="string-length($comments)"/>
                  				<xsl:call-template name="MSGLoop">
                  					<xsl:with-param name="Desc" select="$comments"/>
                  					<xsl:with-param name="StrLen" select="$StrLen"/>
                  					<xsl:with-param name="Pos" select="1"/>
                  					<xsl:with-param name="CurrentEndPos" select="1"/>
                  				</xsl:call-template>
                  			</G_N9>
                  		</xsl:if>
                  	</xsl:for-each>
                     <!--IG-3412-->
                     <xsl:for-each select="ItemDetail/Extrinsic[@name != 'customerOrderNo' and @name != 'engineeringSpecificationNo']">
                        <xsl:if test="normalize-space(.) != ''">
                           <G_N9>
                              <S_N9>
                                 <D_128>ZZ</D_128>
                                 <D_369>
                                    <xsl:value-of select="substring(normalize-space(@name), 1, 45)"/>
                                 </D_369>
                              </S_N9>
                              <xsl:variable name="comments" select="normalize-space(.)"/>
                              <xsl:variable name="StrLen" select="string-length($comments)"/>
                              <xsl:call-template name="MSGLoop">
                                 <xsl:with-param name="Desc" select="$comments"/>
                                 <xsl:with-param name="StrLen" select="$StrLen"/>
                                 <xsl:with-param name="Pos" select="1"/>
                                 <xsl:with-param name="CurrentEndPos" select="1"/>
                              </xsl:call-template>
                           </G_N9>
                        </xsl:if>
                     </xsl:for-each>
                     <!-- BlanketItemDetail/Extrinsic -->
                     <xsl:for-each select="BlanketItemDetail/Extrinsic">
                        <xsl:if test="normalize-space(.) != ''">
                           <G_N9>
                              <S_N9>
                                 <D_128>ZZ</D_128>
                                 <D_369>
                                    <xsl:value-of select="substring(normalize-space(@name), 1, 45)"/>
                                 </D_369>
                              </S_N9>
                              <xsl:variable name="comments" select="normalize-space(.)"/>
                              <xsl:variable name="StrLen" select="string-length($comments)"/>
                              <xsl:call-template name="MSGLoop">
                                 <xsl:with-param name="Desc" select="$comments"/>
                                 <xsl:with-param name="StrLen" select="$StrLen"/>
                                 <xsl:with-param name="Pos" select="1"/>
                                 <xsl:with-param name="CurrentEndPos" select="1"/>
                              </xsl:call-template>
                           </G_N9>
                        </xsl:if>
                     </xsl:for-each>
                     <!-- TransportComments -->
                     <xsl:if test="normalize-space(TermsOfDelivery/Comments[@type = 'Transport']) != ''">
                        <G_N9>
                           <S_N9>
                              <D_128>0L</D_128>
                              <D_127>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(TermsOfDelivery/Comments[@type = 'Transport']/@xml:lang)) &gt; 1">
                                       <xsl:value-of select="upper-case(substring(normalize-space(TermsOfDelivery/Comments[@type = 'Transport']/@xml:lang), 1, 2))"/>
                                    </xsl:when>
                                    <xsl:otherwise>EN</xsl:otherwise>
                                 </xsl:choose>
                              </D_127>
                              <D_369>TransportComments</D_369>
                           </S_N9>
                           <xsl:variable name="commentsTxt" select="normalize-space(TermsOfDelivery/Comments[@type = 'Transport'])"/>
                           <xsl:variable name="StrLen" select="string-length($commentsTxt)"/>
                           <xsl:if test="$commentsTxt != ''">
                              <xsl:call-template name="MSGLoop">
                                 <xsl:with-param name="Desc" select="$commentsTxt"/>
                                 <xsl:with-param name="StrLen" select="$StrLen"/>
                                 <xsl:with-param name="Pos" select="1"/>
                                 <xsl:with-param name="CurrentEndPos" select="1"/>
                              </xsl:call-template>
                           </xsl:if>
                        </G_N9>
                     </xsl:if>
                     <!-- TODComments -->
                     <xsl:if test="normalize-space(TermsOfDelivery/Comments[@type = 'TermsOfDelivery']) != ''">
                        <G_N9>
                           <S_N9>
                              <D_128>0L</D_128>
                              <D_127>
                                 <xsl:choose>
                                    <xsl:when test="string-length(normalize-space(TermsOfDelivery/Comments[@type = 'TermsOfDelivery']/@xml:lang)) &gt; 1">
                                       <xsl:value-of select="upper-case(substring(normalize-space(TermsOfDelivery/Comments[@type = 'TermsOfDelivery']/@xml:lang), 1, 2))"/>
                                    </xsl:when>
                                    <xsl:otherwise>EN</xsl:otherwise>
                                 </xsl:choose>
                              </D_127>
                              <D_369>TODComments</D_369>
                           </S_N9>
                           <xsl:variable name="commentsTxt" select="normalize-space(TermsOfDelivery/Comments[@type = 'TermsOfDelivery'])"/>
                           <xsl:variable name="StrLen" select="string-length($commentsTxt)"/>
                           <xsl:if test="$commentsTxt != ''">
                              <xsl:call-template name="MSGLoop">
                                 <xsl:with-param name="Desc" select="$commentsTxt"/>
                                 <xsl:with-param name="StrLen" select="$StrLen"/>
                                 <xsl:with-param name="Pos" select="1"/>
                                 <xsl:with-param name="CurrentEndPos" select="1"/>
                              </xsl:call-template>
                           </xsl:if>
                        </G_N9>
                     </xsl:if>
                     <!-- IG-4981 SerialNumber Info -->
                     <!-- IG-39367 expand condition by @requiresSerialNumber start -->
                     <xsl:if test="normalize-space(ItemOutIndustry/SerialNumberInfo/@type) != '' or normalize-space(ItemOutIndustry/SerialNumberInfo/@requiresSerialNumber) != ''">
                        <G_N9>
                           <S_N9>
                              <D_128>SE</D_128>
                              <xsl:if test="normalize-space(ItemOutIndustry/SerialNumberInfo/@type) != ''">
                                 <D_127>
                                    <xsl:value-of select="normalize-space(ItemOutIndustry/SerialNumberInfo/@type)"/>
                                 </D_127>
                              </xsl:if>
                              <xsl:if test="normalize-space(ItemOutIndustry/SerialNumberInfo/@requiresSerialNumber) != ''">
                                 <D_369>
                                    <xsl:value-of select="normalize-space(ItemOutIndustry/SerialNumberInfo/@requiresSerialNumber)"/>
                                 </D_369>
                              </xsl:if>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <!-- IG-39367 expand condition by @requiresSerialNumber end -->
                     <!-- IG-2352 @isReturn -->
                     <xsl:if test="normalize-space(@isReturn) != ''">
                        <G_N9>
                           <S_N9>
                              <D_128>ACC</D_128>
                              <D_127>return item</D_127>
                              <D_369>yes</D_369>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <xsl:if test="normalize-space(@requiresServiceEntry) = 'yes'">
                        <G_N9>
                           <S_N9>
                              <D_128>ACE</D_128>
                              <D_127>requiresServiceEntry</D_127>
                              <D_369>yes</D_369>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <xsl:if test="normalize-space(ItemOutIndustry/BatchInfo/@requiresBatch) = 'yes'">
                        <G_N9>
                           <S_N9>
                              <D_128>BT</D_128>
                              <D_127>requiresBatch</D_127>
                              <D_369>yes</D_369>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <xsl:if test="normalize-space(ItemOutIndustry/@isHUMandatory) = 'yes'">
                        <G_N9>
                           <S_N9>
                              <D_128>LS</D_128>
                              <D_127>isHUMandatory</D_127>
                              <D_369>yes</D_369>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <xsl:if test="normalize-space(ItemOutIndustry/@requiresRealTimeConsumption) = 'yes'">
                        <G_N9>
                           <S_N9>
                              <D_128>SU</D_128>
                              <D_127>requiresRealTimeConsumption</D_127>
                              <D_369>yes</D_369>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <!-- 06292020 CG: IG-20382 -->
                     <xsl:call-template name="MapControlKeys">
                        <xsl:with-param name="keys" select="ControlKeys"/>
                        <xsl:with-param name="level" select="'detail'"/>
                     </xsl:call-template>
                     <xsl:for-each select="ItemDetail/ItemDetailIndustry/ItemDetailRetail/Characteristic[normalize-space(@value) != '']">
                        <G_N9>
                           <S_N9>
                              <D_128>PRT</D_128>
                              <D_369>
                                 <xsl:value-of select="substring(normalize-space(@domain), 1, 45)"/>
                              </D_369>
                           </S_N9>
                           <xsl:variable name="commentsTxt" select="normalize-space(@value)"/>
                           <xsl:variable name="StrLen" select="string-length($commentsTxt)"/>
                           <xsl:if test="$commentsTxt != ''">
                              <xsl:call-template name="MSGLoop">
                                 <xsl:with-param name="Desc" select="$commentsTxt"/>
                                 <xsl:with-param name="StrLen" select="$StrLen"/>
                                 <xsl:with-param name="Pos" select="1"/>
                                 <xsl:with-param name="CurrentEndPos" select="1"/>
                              </xsl:call-template>
                           </xsl:if>
                        </G_N9>
                     </xsl:for-each>
                     <xsl:for-each select="ItemOutIndustry/ReferenceDocumentInfo[DocumentInfo/@documentID!='' and DocumentInfo/@documentType!='']">
                        <G_N9>
                           <S_N9>
                              <D_128>0L</D_128>
                              <D_127>
                                 <xsl:value-of select="substring(normalize-space(DocumentInfo/@documentID), 1, 30)"/>
                              </D_127>
                              <D_369>
                                 <xsl:value-of select="substring(normalize-space(DocumentInfo/@documentType), 1, 45)"/>
                              </D_369>
                              <xsl:if test="DocumentInfo/@documentDate != ''">
                                 <xsl:variable name="tzone" select="replace(replace(substring(DocumentInfo/@documentDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                                 <xsl:variable name="time" select="translate(substring(DocumentInfo/@documentDate, 12, 8), ':', '')"/>
                                 <xsl:variable name="getX12TZone">
                                    <xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone]/X12Code != ''">
                                       <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $tzone][1]/X12Code"/>
                                    </xsl:if>
                                 </xsl:variable>
                                 <xsl:if test="$getX12TZone != '' and $time != ''">
                                    <D_373>
                                       <xsl:value-of select="translate(substring-before(DocumentInfo/@documentDate, 'T'), '-', '')"/>
                                    </D_373>
                                    <D_337>
                                       <xsl:value-of select="$time"/>
                                    </D_337>
                                    <D_623>
                                       <xsl:value-of select="$getX12TZone"/>
                                    </D_623>
                                 </xsl:if>
                              </xsl:if>
                              <xsl:if test="normalize-space(@lineNumber)!=''">
                                 <C_C040>
                                    <D_128>LI</D_128>
                                    <D_127>
                                       <xsl:value-of select="normalize-space(@lineNumber)"/>
                                    </D_127>
                                    <xsl:if test="normalize-space(@scheduleLineNumber)!=''">
                                       <D_128_2>72</D_128_2>
                                       <D_127_2>
                                          <xsl:value-of select="normalize-space(@scheduleLineNumber)"/>
                                       </D_127_2>
                                    </xsl:if>
                                 </C_C040>
                              </xsl:if>
                           </S_N9>
                        </G_N9>
                     </xsl:for-each>
                     <xsl:if test="ItemOutIndustry/QualityInfo/@requiresQualityProcess and ItemOutIndustry/QualityInfo/IdReference[@domain='controlCode']/@identifier">
                        <G_N9>
                           <S_N9>
                              <D_128>H6</D_128>
                              <D_127>
                                 <xsl:value-of select="substring(normalize-space(ItemOutIndustry/QualityInfo/@requiresQualityProcess), 1, 30)"/>
                              </D_127>
                              <xsl:if test="ItemOutIndustry/QualityInfo/IdReference[@domain='controlCode']/@identifier">
                                 <D_369>
                                    <xsl:value-of select="'Control code'"/>
                                 </D_369>
                                 <C_C040>
                                    <D_128>H6</D_128>
                                    <D_127>
                                       <xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain='controlCode']/@identifier)"/>
                                    </D_127>
                                 </C_C040>
                              </xsl:if>
                           </S_N9>
                           <xsl:if test="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain='controlCode']/Description)!=''">
                              <S_MSG>
                                 <D_933>
                                    <xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/IdReference[@domain='controlCode']/Description)"/>
                                 </D_933>
                              </S_MSG>
                           </xsl:if>
                        </G_N9>
                     </xsl:if>
                     <xsl:if test="ItemOutIndustry/QualityInfo/@requiresQualityProcess and ItemOutIndustry/QualityInfo/CertificateInfo/IdReference[@domain='certificateType']/@identifier">
                        <G_N9>
                           <S_N9>
                              <D_128>H6</D_128>
                              <D_127>
                                 <xsl:value-of select="substring(normalize-space(ItemOutIndustry/QualityInfo/@requiresQualityProcess), 1, 30)"/>
                              </D_127>
                              <xsl:if test="ItemOutIndustry/QualityInfo/CertificateInfo/IdReference[@domain='certificateType']/@identifier">
                                 <D_369>
                                    <xsl:value-of select="'Certificate type'"/>
                                 </D_369>
                                 <C_C040>
                                    <D_128>H6</D_128>
                                    <D_127>
                                       <xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/CertificateInfo/IdReference[@domain='certificateType']/@identifier)"/>
                                    </D_127>
                                 </C_C040>
                              </xsl:if>
                           </S_N9>
                           <xsl:if test="normalize-space(ItemOutIndustry/QualityInfo/CertificateInfo/IdReference[@domain='certificateType']/Description)!=''">
                              <S_MSG>
                                 <D_933>
                                    <xsl:value-of select="normalize-space(ItemOutIndustry/QualityInfo/CertificateInfo/IdReference[@domain='certificateType']/Description)"/>
                                 </D_933>
                              </S_MSG>
                           </xsl:if>
                        </G_N9>
                     </xsl:if>
                     <xsl:if test="ItemOutIndustry/QualityInfo/@requiresQualityProcess and not(exists(ItemOutIndustry/QualityInfo/CertificateInfo/IdReference[@domain='certificateType']/@identifier)) and not(exists(ItemOutIndustry/QualityInfo/CertificateInfo/IdReference[@domain='controlCode']/@identifier))">
                        <G_N9>
                           <S_N9>
                              <D_128>H6</D_128>
                              <D_127>
                                 <xsl:value-of select="substring(normalize-space(ItemOutIndustry/QualityInfo/@requiresQualityProcess), 1, 30)"/>
                              </D_127>
                           </S_N9>
                        </G_N9>
                     </xsl:if>
                     <!-- ShipTo -->
                     <xsl:if test="exists(ShipTo)">
                        <xsl:call-template name="createN1_LineShipTo">
                           <xsl:with-param name="party" select="ShipTo"/>
                        </xsl:call-template>
                     </xsl:if>
                     <!-- Delivery Party -->
                     <xsl:if test="exists(TermsOfDelivery/Address)">
                        <xsl:call-template name="createN1">
                           <xsl:with-param name="party" select="TermsOfDelivery"/>
                           <xsl:with-param name="isOrder" select="'true'"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:for-each select="Contact">
                        <xsl:call-template name="createContact">
                           <xsl:with-param name="party" select="."/>
                           <xsl:with-param name="isOrder" select="'true'"/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <!-- SubcontractingComponent -->
                     <xsl:for-each select="ScheduleLine">
                        <xsl:for-each select="SubcontractingComponent[normalize-space(ComponentID) != '']">
                           <xsl:variable name="uom" select="UnitOfMeasure"/>
                           <G_SLN>
                              <S_SLN>
                                 <D_350>
                                    <xsl:value-of select="substring(normalize-space(ComponentID), 1, 20)"/>
                                 </D_350>
                                 <D_350_2>
                                    <xsl:value-of select="substring(normalize-space(../@lineNumber), 1, 20)"/>
                                 </D_350_2>
                                 <D_662>O</D_662>
                                 <D_380>
                                    <xsl:call-template name="formatQty">
                                       <xsl:with-param name="qty" select="@quantity"/>
                                    </xsl:call-template>
                                    <!--xsl:value-of select="format-number(@quantity,'0.##')"/-->
                                 </D_380>
                                 <C_C001>
                                    <D_355>
                                       <xsl:choose>
                                          <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code != ''">
                                             <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uom]/X12Code"/>
                                          </xsl:when>
                                          <xsl:otherwise>ZZ</xsl:otherwise>
                                       </xsl:choose>
                                    </D_355>
                                 </C_C001>
                                 <xsl:call-template name="createItemParts">
                                    <xsl:with-param name="itemID" select="Product"/>
                                 </xsl:call-template>
                              </S_SLN>
                              <xsl:if test="normalize-space(Description) != ''">
                                 <S_MSG>
                                    <D_933>
                                       <xsl:value-of select="substring(normalize-space(Description), 1, 264)"/>
                                    </D_933>
                                 </S_MSG>
                              </xsl:if>
                              <xsl:if test="@requirementDate != ''">
                                 <S_DTM>
                                    <D_374>002</D_374>
                                    <D_373>
                                       <xsl:value-of select="replace(substring(@requirementDate, 0, 11), '-', '')"/>
                                    </D_373>
                                    <D_337>
                                       <xsl:value-of select="replace(substring(@requirementDate, 12, 8), ':', '')"/>
                                    </D_337>
                                    <xsl:variable name="timeZone" select="replace(replace(substring(@requirementDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
                                    <xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
                                       <D_623>
                                          <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
                                       </D_623>
                                    </xsl:if>
                                 </S_DTM>
                              </xsl:if>
                              <xsl:if test="normalize-space(@materialProvisionIndicator)!=''">
                                 <G_N9>
                                    <S_N9>
                                       <D_128>SU</D_128>
                                       <D_127>
                                          <xsl:value-of select="'materialProvisionIndicator'"/>
                                       </D_127>
                                       <D_369>
                                          <xsl:value-of select="@materialProvisionIndicator"/>
                                       </D_369>
                                    </S_N9>
                                 </G_N9>
                              </xsl:if>
                              <xsl:if test="normalize-space(Batch/SupplierBatchID)!=''">
                                 <G_N9>
                                    <S_N9>
                                       <D_128>BT</D_128>
                                       <D_369>
                                          <xsl:value-of select="normalize-space(Batch/SupplierBatchID)"/>
                                       </D_369>
                                    </S_N9>
                                 </G_N9>
                              </xsl:if>
                              <xsl:if test="normalize-space(Batch/BuyerBatchID)!=''">
                                 <G_N9>
                                    <S_N9>
                                       <D_128>LT</D_128>
                                       <D_369>
                                          <xsl:value-of select="normalize-space(Batch/BuyerBatchID)"/>
                                       </D_369>
                                    </S_N9>
                                 </G_N9>
                              </xsl:if>
                              <!-- IG-26194 -->
                              <xsl:for-each select="Product/IdReference">
                                 <xsl:if test="normalize-space(@identifier)!='' and @domain = 'storageLocation'">
                                    <G_N9>
                                       <S_N9>
                                          <D_128>4C</D_128>
                                          <D_369>
                                             <xsl:value-of select="normalize-space(@identifier)"/>
                                          </D_369>
                                       </S_N9>
                                    </G_N9>
                                 </xsl:if>
                              </xsl:for-each>
                           </G_SLN>
                        </xsl:for-each>
                     </xsl:for-each>
                  </G_POC>
               </xsl:for-each>
               <!-- Summary -->
               <G_CTT>
                  <S_CTT>
                     <D_354>
                        <xsl:value-of select="count(cXML/Request/OrderRequest/ItemOut)"/>
                     </D_354>
                     <D_347>
                        <xsl:call-template name="HashTotal"/>
                     </D_347>
                  </S_CTT>
                  <S_AMT>
                     <D_522>TT</D_522>
                     <D_782>
                        <xsl:choose>
                           <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideAmount']">0.00</xsl:when>
                           <xsl:when test="cXML/Request/OrderRequest/OrderRequestHeader/Extrinsic[@name = 'hideUnitPrice']">0.00</xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="formatAmount">
                                 <xsl:with-param name="amount" select="cXML/Request/OrderRequest/OrderRequestHeader/Total/Money"/>
                              </xsl:call-template>
                              <!--xsl:value-of select="format-number(number(replace(cXML/Request/OrderRequest/OrderRequestHeader/Total/Money,',','')),'0.00')"/-->
                           </xsl:otherwise>
                        </xsl:choose>
                     </D_782>
                  </S_AMT>
               </G_CTT>
               <S_SE>
                  <D_96>
                     <xsl:text>#segCount#</xsl:text>
                  </D_96>
                  <D_329>0001</D_329>
               </S_SE>
            </M_860>
            <S_GE>
               <D_97>1</D_97>
               <D_28>
                  <xsl:value-of select="$anICNValue"/>
               </D_28>
            </S_GE>
         </FunctionalGroup>
         <S_IEA>
            <D_I16>1</D_I16>
            <D_I12>
               <xsl:value-of select="$anICNValue"/>
            </D_I12>
         </S_IEA>
      </ns0:Interchange>
   </xsl:template>
   <xsl:template name="createN1_LineShipTo">
      <xsl:param name="party"/>
      <xsl:param name="mapFOB"/>
      <xsl:variable name="role">
         <xsl:choose>
            <xsl:when test="name($party) = 'BillTo'">BT</xsl:when>
            <xsl:when test="name($party) = 'ShipTo'">ST</xsl:when>
            <xsl:when test="name($party) = 'TermsOfDelivery'">DA</xsl:when>
         </xsl:choose>
      </xsl:variable>
      <G_N1>
         <S_N1>
            <D_98>
               <xsl:value-of select="$role"/>
            </D_98>
            <D_93>
               <xsl:choose>
                  <xsl:when test="$party/Address/Name != ''">
                     <xsl:value-of select="substring($party/Address/Name, 1, 60)"/>
                  </xsl:when>
                  <xsl:otherwise>Not Available</xsl:otherwise>
               </xsl:choose>
            </D_93>
            <xsl:variable name="addrDomain" select="$party/Address/@addressIDDomain"/>
            <!-- CG -->
            <xsl:if test="string-length($party/Address/@addressID) &gt; 1">
               <D_66>
                  <xsl:choose>
                     <xsl:when test="$addrDomain = ''">92</xsl:when>
                     <xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code != ''">
                        <xsl:value-of select="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/X12Code"/>
                     </xsl:when>
                     <xsl:otherwise>92</xsl:otherwise>
                  </xsl:choose>
               </D_66>
               <D_67>
                  <xsl:value-of select="substring($party/Address/@addressID, 1, 80)"/>
               </D_67>
            </xsl:if>
         </S_N1>
         <xsl:call-template name="createN2N3N4_FromAddress">
            <xsl:with-param name="address" select="$party/Address/PostalAddress"/>
         </xsl:call-template>
         <xsl:for-each select="$party/IdReference">
            <xsl:variable name="domain" select="./@domain"/>
            <xsl:if test="normalize-space(./@identifier) != ''">
               <xsl:choose>
                  <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code != ''">
                     <S_REF>
                        <D_128>
                           <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = $role]/X12Code"/>
                        </D_128>
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                        </D_352>
                     </S_REF>
                  </xsl:when>
                  <xsl:when test="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code != ''">
                     <S_REF>
                        <D_128>
                           <xsl:value-of select="$Lookup/Lookups/IDReferences/IDReference[CXMLCode = $domain and Role = 'ANY']/X12Code"/>
                        </D_128>
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                        </D_352>
                     </S_REF>
                  </xsl:when>
                  <xsl:otherwise>
                     <S_REF>
                        <D_128>ZZ</D_128>
                        <D_127>
                           <xsl:value-of select="substring(normalize-space(./@domain), 1, 30)"/>
                        </D_127>
                        <D_352>
                           <xsl:value-of select="substring(normalize-space(./@identifier), 1, 80)"/>
                        </D_352>
                     </S_REF>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </xsl:for-each>
         <!-- IG-1958 -->
         <xsl:if test="normalize-space($party/Address/PostalAddress/@name) != ''">
            <S_REF>
               <D_128>
                  <xsl:text>ME</xsl:text>
               </D_128>
               <D_352>
                  <xsl:value-of select="substring(normalize-space($party/Address/PostalAddress/@name), 1, 80)"/>
               </D_352>
            </S_REF>
         </xsl:if>
         <xsl:call-template name="createCom">
            <xsl:with-param name="party" select="$party"/>
         </xsl:call-template>
         <xsl:if test="name($party) = 'ShipTo'">
            <xsl:choose>
               <xsl:when test="$mapFOB = 'true'">
                  <!-- TermsOfDelivery -->
                  <xsl:if test="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value != ''">
                     <xsl:variable name="TOD" select="/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/ShippingPaymentMethod/@value"/>
                     <S_FOB>
                        <D_146>
                           <xsl:choose>
                              <xsl:when test="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code != ''">
                                 <xsl:value-of select="$Lookup/Lookups/ShippingPaymentMethods/ShippingPaymentMethod[CXMLCode = $TOD]/X12Code"/>
                              </xsl:when>
                              <xsl:otherwise>DF</xsl:otherwise>
                           </xsl:choose>
                        </D_146>
                        <xsl:if test="exists(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms)">
                           <xsl:variable name="TTVal" select="normalize-space(/cXML/Request/OrderRequest/OrderRequestHeader/TermsOfDelivery/TransportTerms/@value)"/>
                           <D_334>01</D_334>
                           <D_335>
                              <xsl:choose>
                                 <xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code != ''">
                                    <xsl:value-of select="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[CXMLCode = $TTVal]/X12Code"/>
                                 </xsl:when>
                                 <!-- IG-31554 -->
                                 <xsl:when test="$Lookup/Lookups/TransportTermsCodes/TransportTermsCode[X12Code = $TTVal]/X12Code != ''">
                                    <xsl:value-of select="$TTVal"/>
                                 </xsl:when>
                                 <xsl:otherwise>ZZZ</xsl:otherwise>
                              </xsl:choose>
                           </D_335>
                        </xsl:if>
                     </S_FOB>
                  </xsl:if>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each select="$party/TransportInformation">
                     <xsl:if test="position() &lt; 13">
                        <xsl:if test="ShippingContractNumber != '' or Route/@method != ''">
                           <S_TD5>
                              <D_133>Z</D_133>
                              <xsl:if test="ShippingContractNumber != ''">
                                 <D_66>ZZ</D_66>
                                 <D_67>
                                    <xsl:value-of select="ShippingContractNumber"/>
                                 </D_67>
                              </xsl:if>
                              <xsl:if test="Route/@method != ''">
                                 <D_91>
                                    <xsl:choose>
                                       <xsl:when test="Route/@method = 'air'">A</xsl:when>
                                       <xsl:when test="Route/@method = 'motor'">J</xsl:when>
                                       <xsl:when test="Route/@method = 'rail'">R</xsl:when>
                                       <xsl:when test="Route/@method = 'ship'">S</xsl:when>
                                    </xsl:choose>
                                 </D_91>
                              </xsl:if>
                              <!-- CG: IG-1388 matching AN Legacy and MSFT IG -->
                              <xsl:if test="normalize-space(ShippingInstructions/Description) != ''">
                                 <D_309>ZZ</D_309>
                                 <D_310>
                                    <xsl:value-of select="substring(normalize-space(ShippingInstructions/Description), 1, 30)"/>
                                 </D_310>
                              </xsl:if>
                           </S_TD5>
                        </xsl:if>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="$party/CarrierIdentifier">
                     <xsl:if test="position() &lt; 6">
                        <S_TD4>
                           <D_152>ZZZ</D_152>
                           <D_352>
                              <xsl:value-of select="concat(., '@domain', ./@domain)"/>
                           </D_352>
                        </S_TD4>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
      </G_N1>
   </xsl:template>
   <xsl:template name="HashTotal">
      <xsl:variable name="HashValue">
         <value>
            <xsl:for-each select="cXML/Request/OrderRequest/ItemOut/@quantity">
               <xsl:if test="normalize-space(.) != ''">
                  <itemQty>
                     <xsl:call-template name="formatQty">
                        <xsl:with-param name="qty" select="."/>
                     </xsl:call-template>
                  </itemQty>
               </xsl:if>
            </xsl:for-each>
         </value>
      </xsl:variable>
      <xsl:variable name="summaryHashQty" select="         string(sum(for $i in $HashValue/value/itemQty         return         xs:decimal($i)))"/>
      <xsl:choose>
         <xsl:when test="string-length($summaryHashQty) &gt; 10">
            <xsl:value-of select="substring($summaryHashQty, 1, 10)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="formatQty">
               <xsl:with-param name="qty" select="$summaryHashQty"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
