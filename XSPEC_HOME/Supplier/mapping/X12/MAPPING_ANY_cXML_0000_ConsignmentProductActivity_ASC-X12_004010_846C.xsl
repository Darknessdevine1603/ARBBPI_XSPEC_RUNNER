<?xml version="1.0"?>
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
   <xsl:param name="segmentCount"/>
   <xsl:param name="exchange"/>
   <!-- For local testing -->
   <!--xsl:variable name="Lookup" select="document('LOOKUP_ASC-X12_004010.xml')"/>
   <xsl:include href="Format_CXML_ASC-X12_common.xsl"/-->
   <!-- PD references -->
   <xsl:include href="FORMAT_cXML_0000_ASC-X12_004010.xsl"/>
   <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
   <xsl:template match="/">
      <xsl:variable name="dateNow" select="current-dateTime()"/>

      <ns0:Interchange xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:846:004010">
         <xsl:call-template name="createISA">
            <xsl:with-param name="dateNow" select="$dateNow"/>
         </xsl:call-template>
         <FunctionalGroup>
            <S_GS>
               <D_479>IB</D_479>
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
                  <xsl:value-of select="format-dateTime($dateNow, '[H01][m01]')"/>
               </D_337>
               <D_28>
                  <xsl:value-of select="$anICNValue"/>
               </D_28>
               <D_455>X</D_455>
               <D_480>004010</D_480>
            </S_GS>
            <M_846>
               <S_ST>
                  <D_143>846</D_143>
                  <D_329>0001</D_329>
               </S_ST>
               <S_BIA>
                  <D_353>00</D_353>
                  <D_755>CO</D_755>
                  <xsl:if test="cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID != ''">
                     <D_127>
                        <xsl:value-of select="substring(cXML/Message/ProductActivityMessage/ProductActivityHeader/@messageID, 1, 30)"/>
                     </D_127>
                  </xsl:if>
                  <D_373>
                     <xsl:value-of select="replace(substring-before(cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate, 'T'), '-', '')"/>
                  </D_373>
                  <D_337>
                     <xsl:value-of select="substring(replace(substring-after(cXML/Message/ProductActivityMessage/ProductActivityHeader/@creationDate, 'T'), ':', ''), 1, 6)"/>
                  </D_337>
                  <D_306>AC</D_306>
               </S_BIA>
               <xsl:for-each select="cXML/Message/ProductActivityMessage/ProductActivityDetails">
                  <xsl:for-each select="ConsignmentInventory[not(./following-sibling::*[self::ConsignmentMovement]) and not(./preceding-sibling::*[self::ConsignmentMovement])]">
                     <xsl:call-template name="buildNewLIN">
                        <xsl:with-param name="line" select="../."/>
                        <xsl:with-param name="type" select="'inventory'"></xsl:with-param>
                     </xsl:call-template>
                     
                  </xsl:for-each>
                  
                  <xsl:for-each-group select="ConsignmentMovement" group-by="(ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier,generate-id())[1]">
                     <xsl:call-template name="buildNewLIN">
                        <xsl:with-param name="line" select="../."/>
                        <xsl:with-param name="type" select="'movement'"></xsl:with-param>
                     </xsl:call-template>

                  </xsl:for-each-group>
                 
                 
               </xsl:for-each>
               <S_CTT>
                  <D_354>
                     <xsl:value-of select="count(distinct-values(cXML/Message/ProductActivityMessage/ProductActivityDetails/ConsignmentMovement/ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier))+count(cXML/Message/ProductActivityMessage/ProductActivityDetails/ConsignmentMovement[not(exists(ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier))])+count(cXML/Message/ProductActivityMessage/ProductActivityDetails/ConsignmentInventory[not(./following-sibling::*[self::ConsignmentMovement]) and not(./preceding-sibling::*[self::ConsignmentMovement])])"/>
                  </D_354>
               </S_CTT>
               <S_SE>
                  <D_96>
                     <xsl:text>#segCount#</xsl:text>
                  </D_96>
                  <D_329>0001</D_329>
               </S_SE>
            </M_846>
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

   <xsl:template name="buildNewLIN">
      <xsl:param name="line"/>
      <xsl:param name="type"/>
      <G_LIN>
         <xsl:if test="normalize-space($line/ItemID/SupplierPartID) != '' or normalize-space($line/ItemID/BuyerPartID) != '' or $line/ItemID/SupplierPartAuxiliaryID != ''">
            <S_LIN>
               <xsl:call-template name="createItemParts">
                  <xsl:with-param name="itemID" select="$line/ItemID"/>
               </xsl:call-template>
            </S_LIN>
         </xsl:if>
         <xsl:if test="normalize-space($line/Description) != ''">
            <S_PID>
               <D_349>F</D_349>
               <D_352>
                  <xsl:value-of select="substring(normalize-space($line/Description), 1, 80)"/>
               </D_352>
               <D_819>
                  <xsl:variable name="lang" select="string-length(normalize-space($line/Description/@xml:lang))"/>
                  <xsl:choose>
                     <xsl:when test="$lang &gt; 1">
                        <xsl:value-of select="upper-case(substring($line/Description/@xml:lang, 1, 2))"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>EN</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </D_819>
            </S_PID>
         </xsl:if>
         <xsl:if test="normalize-space($line/Batch/SupplierBatchID) != ''">
            <S_REF>
               <D_128>BT</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space($line/Batch/SupplierBatchID)"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space($line/Batch/BuyerBatchID) != ''">
            <S_REF>
               <D_128>LT</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space($line/Batch/BuyerBatchID)"/>
               </D_127>
            </S_REF>
         </xsl:if>


         <!-- IG-6197 -->
         <xsl:if test="normalize-space($line/ConsignmentInventory/UnrestrictedUseQuantity/@quantity) != ''">
            <G_QTY>
               <S_QTY>
                  <D_673>33</D_673>
                  <D_380>
                     <xsl:call-template name="formatQty">
                        <xsl:with-param name="qty" select="$line/ConsignmentInventory/UnrestrictedUseQuantity/@quantity"/>
                     </xsl:call-template>
                  </D_380>
                  <xsl:variable name="uomcode">
                     <xsl:choose>
                        <xsl:when test="$line/ConsignmentInventory/UnrestrictedUseQuantity/UnitOfMeasure != ''">
                           <xsl:value-of select="$line/ConsignmentInventory/UnrestrictedUseQuantity/UnitOfMeasure"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>ZZ</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <C_C001>
                     <D_355>
                        <xsl:choose>
                           <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
                              <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
                           </xsl:when>
                           <xsl:otherwise>ZZ</xsl:otherwise>
                        </xsl:choose>
                     </D_355>
                     <D_1018>2</D_1018>
                  </C_C001>
               </S_QTY>
            </G_QTY>
         </xsl:if>
         <xsl:if test="$type='movement'">
         <xsl:for-each select="current-group()">
            <G_QTY>
               <S_QTY>
                  <D_673>V3</D_673>
                  <D_380>
                     <xsl:call-template name="formatQty">
                        <xsl:with-param name="qty" select="MovementQuantity/@quantity"/>
                     </xsl:call-template>

                  </D_380>
                  <xsl:variable name="uomcode">
                     <xsl:choose>
                        <xsl:when test="MovementQuantity/UnitOfMeasure != ''">
                           <xsl:value-of select="MovementQuantity/UnitOfMeasure"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>ZZ</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <C_C001>
                     <D_355>
                        <xsl:choose>
                           <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
                              <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
                           </xsl:when>
                           <xsl:otherwise>ZZ</xsl:otherwise>
                        </xsl:choose>
                     </D_355>
                     <D_1018>3</D_1018>
                  </C_C001>
               </S_QTY>
               <xsl:if test="normalize-space(UnitPrice/Money) != ''">
                  <S_UIT>
                     <xsl:variable name="uomcode1">
                        <xsl:choose>
                           <xsl:when test="MovementQuantity/UnitOfMeasure != ''">
                              <xsl:value-of select="MovementQuantity/UnitOfMeasure"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:text>ZZ</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <C_C001>
                        <D_355>
                           <xsl:choose>
                              <xsl:when test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode1]/X12Code != ''">
                                 <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode1]/X12Code"/>
                              </xsl:when>
                              <xsl:otherwise>ZZ</xsl:otherwise>
                           </xsl:choose>
                        </D_355>
                     </C_C001>
                     <xsl:if test="$uomcode1 != ''">
                        <D_212>
                           <xsl:call-template name="formatAmount">
                              <xsl:with-param name="amount" select="normalize-space(UnitPrice/Money)"/>
                           </xsl:call-template>
                        </D_212>
                     </xsl:if>
                  </S_UIT>
               </xsl:if>
               <!-- @movementDate -->
               <xsl:call-template name="createDTM">
                  <xsl:with-param name="D374_Qual">514</xsl:with-param>
                  <xsl:with-param name="cXMLDate">
                     <xsl:value-of select="ProductMovementItemIDInfo/@movementDate"/>
                  </xsl:with-param>
               </xsl:call-template>
               <!-- Loop header-->
               <S_LS>
                  <D_447>REF</D_447>
               </S_LS>
               <!-- @movementID and Line-->
               <G_REF>
                  <S_REF>
                     <D_128>IX</D_128>
                     <D_127>
                        <xsl:value-of select="ProductMovementItemIDInfo/@movementID"/>
                     </D_127>
                     <xsl:if test="normalize-space(ProductMovementItemIDInfo/@movementLineNumber) != ''">
                        <C_C040>
                           <D_128>LI</D_128>
                           <D_127>
                              <xsl:value-of select="ProductMovementItemIDInfo/@movementLineNumber"/>
                           </D_127>
                        </C_C040>
                     </xsl:if>
                  </S_REF>
               </G_REF>
               <!-- InvoiceItemIDInfo-->
               <xsl:if test="normalize-space(InvoiceItemIDInfo/@invoiceID) != ''">
                  <G_REF>
                     <S_REF>
                        <D_128>IV</D_128>
                        <D_127>
                           <xsl:value-of select="InvoiceItemIDInfo/@invoiceID"/>
                        </D_127>
                        <xsl:if test="normalize-space(InvoiceItemIDInfo/@invoiceLineNumber) != ''">
                           <C_C040>
                              <D_128>LI</D_128>
                              <D_127>
                                 <xsl:value-of select="normalize-space(InvoiceItemIDInfo/@invoiceLineNumber)"/>
                              </D_127>
                           </C_C040>
                        </xsl:if>
                     </S_REF>
                     <xsl:if test="normalize-space(InvoiceItemIDInfo/@invoiceDate) != ''">
                        <xsl:call-template name="createDTM">
                           <xsl:with-param name="D374_Qual">003</xsl:with-param>
                           <xsl:with-param name="cXMLDate">
                              <xsl:value-of select="InvoiceItemIDInfo/@invoiceDate"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                  </G_REF>
               </xsl:if>
               
               <xsl:if test="normalize-space(ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier) != ''">
                  <G_REF>
                     <S_REF>
                     <D_128>2I</D_128>
                     <D_127>
                        <xsl:value-of select="normalize-space(ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier)"/>
                     </D_127>
                  </S_REF>
                 </G_REF>
               </xsl:if>

                <!-- Loop end-->
               <S_LE>
                  <D_447>REF</D_447>
               </S_LE>
            </G_QTY>
         </xsl:for-each>
         </xsl:if>
         <!-- Contact -->
         <xsl:for-each select="$line/Contact">
            <xsl:call-template name="createContact">
               <xsl:with-param name="party" select="."/>
               <xsl:with-param name="sprole" select="'yes'"/>
            </xsl:call-template>
         </xsl:for-each>
      </G_LIN>
   </xsl:template>
   
</xsl:stylesheet>
