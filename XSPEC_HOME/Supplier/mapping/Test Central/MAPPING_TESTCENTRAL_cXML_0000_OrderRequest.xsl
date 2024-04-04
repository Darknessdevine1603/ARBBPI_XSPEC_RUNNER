<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
   <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

   <xsl:param name="anProviderID"/>
   <xsl:param name="anSenderID"/>
   <xsl:param name="anReceiverID"/>
   <xsl:param name="anDateTime"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anDocumentID"/>
   <xsl:param name="anDummyTemplate"/>

   <!--xsl:include href="Format_TestCentral_cXML.xsl"/-->
   <xsl:include href="pd:HCIOWNERPID:Format_TestCentral_CXML:Binary"/>

   <xsl:variable name="orderTotal">
      <xsl:call-template name="calculateOrderTotal"/>
   </xsl:variable>
 
   <xsl:template match="/">
      <xsl:choose>
         <xsl:when test="not(Combined/Characteristics)">
            <xsl:call-template name="ReplaceTokens"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="ReplaceCharacteristics"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="ReplaceTokens">
      <cXML>
         <xsl:call-template name="ReplaceCommonTokens">
            <xsl:with-param name="anPayloadID" select="$anPayloadID"/>
            <xsl:with-param name="anSenderANID" select="$anSenderID"/>
            <xsl:with-param name="anReceiverANID" select="$anReceiverID"/>
            <xsl:with-param name="anProviderID" select="$anProviderID"/>
         </xsl:call-template>

         <Request>
            <OrderRequest>
               <OrderRequestHeader>
                  <xsl:copy-of select="Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/@*[name() != 'orderID' and name() != 'orderDate']"/>
                  <xsl:attribute name="orderID">
                     <xsl:value-of select="$anDocumentID"/>
                  </xsl:attribute>
                  <xsl:attribute name="orderDate">
                     <xsl:value-of select="$anDateTime"/>
                  </xsl:attribute>
                  <xsl:copy-of select="Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/child::*"/>
               </OrderRequestHeader>
               <xsl:copy-of select="Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/following-sibling::*"/>
            </OrderRequest>
         </Request>
      </cXML>
   </xsl:template>

   <xsl:template name="ReplaceCharacteristics">
      <!-- OrderRequest - supported characteristics:
            UOM, supplier part id, buyer part id, order quantity, unit price
            -->
      <cXML>
         <xsl:call-template name="ReplaceCommonTokens">
            <xsl:with-param name="anPayloadID" select="$anPayloadID"/>
            <xsl:with-param name="anSenderANID" select="$anSenderID"/>
            <xsl:with-param name="anReceiverANID" select="$anReceiverID"/>
            <xsl:with-param name="anProviderID" select="$anProviderID"/>
         </xsl:call-template>         
         <Request>
            <OrderRequest>
               <xsl:choose>
                  <xsl:when test="Combined/Characteristics/Header/child::*">
                     <xsl:call-template name="ReplaceHeaderCharacteristics">
                        <xsl:with-param name="characteristicHeader" select="/Combined/Characteristics/Header"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <OrderRequestHeader>
                        <xsl:copy-of select="Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/@*[name() != 'orderID' and name() != 'orderDate']"/>
                        <xsl:attribute name="orderID">
                           <xsl:value-of select="$anDocumentID"/>
                        </xsl:attribute>
                        <xsl:attribute name="orderDate">
                           <xsl:value-of select="$anDateTime"/>
                        </xsl:attribute>
                        <Total>
                           <Money>
                              <xsl:copy-of select="Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/Total/Money/@*"/>
                              <xsl:value-of select="$orderTotal"/>
                           </Money>
                        </Total>
                        <xsl:copy-of select="Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/child::*[name()!='Total']"/>
                     </OrderRequestHeader>

                  </xsl:otherwise>
               </xsl:choose>
               <xsl:choose>
                  <!-- map lines as per characteristics -->
                  <xsl:when test="count(/Combined/Characteristics/Details/Detail) &gt; 0">
                     <xsl:for-each select="/Combined/Characteristics/Details/Detail">
                        <xsl:call-template name="ReplaceItemCharacteristics">
                           <xsl:with-param name="characteristicDetail" select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- map lines from parent payload -->
                     <xsl:for-each select="/Combined/Payload/cXML/Request/OrderRequest/ItemOut">
                        <xsl:call-template name="generateOrderItem">
                           <xsl:with-param name="baseItem" select="."/>
                           <xsl:with-param name="lineNum" select="@lineNumber"/>
                           <xsl:with-param name="itemCharacteristics" select="/Combined/Characteristics/Details/Detail"/>
                        </xsl:call-template>
                     </xsl:for-each>
                  </xsl:otherwise>
               </xsl:choose>
            </OrderRequest>
         </Request>
      </cXML>
   </xsl:template>

   <xsl:template name="ReplaceItemCharacteristics">
      <xsl:param name="characteristicDetail"/>

      <xsl:variable name="chItemNumber" select="$characteristicDetail/Record[FieldName = 'LineItemNumber']/FieldValue"/>
      <xsl:choose>
         <xsl:when test="/Combined/Payload/cXML/Request/OrderRequest/ItemOut[@lineNumber = $characteristicDetail/Record[FieldName = 'LineItemNumber']/FieldValue]">
            <xsl:call-template name="generateOrderItem">
               <xsl:with-param name="baseItem" select="/Combined/Payload/cXML/Request/OrderRequest/ItemOut[@lineNumber = $chItemNumber]"/>
               <xsl:with-param name="lineNum" select="$chItemNumber"/>
               <xsl:with-param name="itemCharacteristics" select="$characteristicDetail"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="generateOrderItem">
               <xsl:with-param name="baseItem" select="/Combined/Payload/cXML/Request/OrderRequest/ItemOut[1]"/>
               <xsl:with-param name="lineNum" select="$chItemNumber"/>
               <xsl:with-param name="itemCharacteristics" select="$characteristicDetail"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template name="generateOrderItem">
      <xsl:param name="baseItem"/>
      <xsl:param name="lineNum"/>
      <xsl:param name="itemCharacteristics"/>

      <ItemOut>
         <xsl:copy-of select="$baseItem/@*[name() != 'lineNumber' and name() != 'quantity']"/>
         <xsl:attribute name="lineNumber">
            <xsl:value-of select="$lineNum"/>
         </xsl:attribute>
         <xsl:attribute name="quantity">
            <xsl:choose>
               <xsl:when test="$itemCharacteristics/Record[FieldName = 'ItemQuantity']">
                  <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'ItemQuantity']/FieldValue"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$baseItem/@quantity"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:if test="$baseItem/@requestedDeliveryDate or $itemCharacteristics/Record[FieldName = 'RequestedDeliveryDate']">
            <xsl:attribute name="requestedDeliveryDate">
               <xsl:choose>
                  <xsl:when test="$itemCharacteristics/Record[FieldName = 'RequestedDeliveryDate']">
                     <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'RequestedDeliveryDate']/FieldValue"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$baseItem/@requestedDeliveryDate"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
         </xsl:if>
         <ItemID>
            <xsl:choose>
               <xsl:when test="$itemCharacteristics/Record[FieldName = 'SupplierPartID']/FieldValue">
                  <SupplierPartID>
                     <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'SupplierPartID']/FieldValue"/>
                  </SupplierPartID>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="$baseItem/ItemID/SupplierPartID"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="$baseItem/ItemID/SupplierPartAuxiliaryID"/>
            <xsl:choose>
               <xsl:when test="$itemCharacteristics/Record[FieldName = 'BuyerPartID']/FieldValue">
                  <BuyerPartID>
                     <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'BuyerPartID']/FieldValue"/>
                  </BuyerPartID>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="$baseItem/ItemID/BuyerPartID"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="$baseItem/ItemID/IdReference"/>
         </ItemID>

         <xsl:choose>
            <xsl:when test="$baseItem/ItemDetail">
               <xsl:copy-of select="$baseItem/ItemDetail/preceding-sibling::*[name() != 'ItemID']"/>
               <ItemDetail>
                  <xsl:apply-templates select="$baseItem/ItemDetail/child::*">
                     <xsl:with-param name="itemCharacteristics" select="$itemCharacteristics"/>
                     <xsl:with-param name="baseItem" select="$baseItem"/>
                  </xsl:apply-templates>
               </ItemDetail>
               <xsl:copy-of select="$baseItem/ItemDetail/following-sibling::*"/>
            </xsl:when>
            <xsl:when test="$baseItem/BlanketItemDetail">
               <xsl:copy-of select="$baseItem/BlanketItemDetail/preceding-sibling::*[name() != 'ItemID']"/>
               <BlanketItemDetail>
                  <xsl:apply-templates select="$baseItem/BlanketItemDetail/child::*">
                     <xsl:with-param name="itemCharacteristics" select="$itemCharacteristics"/>
                     <xsl:with-param name="baseItem" select="$baseItem"/>
                  </xsl:apply-templates>
               </BlanketItemDetail>
               <xsl:copy-of select="$baseItem/BlanketItemDetail/following-sibling::*"/>
            </xsl:when>
         </xsl:choose>
      </ItemOut>
   </xsl:template>

   <xsl:template name="ReplaceHeaderCharacteristics">
      <xsl:param name="characteristicHeader"/>
      <OrderRequestHeader>
         <xsl:copy-of select="/Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/@*[name() != 'orderID' and name() != 'orderDate' and name() != 'effectiveDate' and name() != 'expirationDate']"/>
         <xsl:attribute name="orderID">
            <xsl:value-of select="$anDocumentID"/>
         </xsl:attribute>
         <xsl:attribute name="orderDate">
            <xsl:value-of select="$anDateTime"/>
         </xsl:attribute>
         <xsl:if test="(/Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/@effectiveDate != '') or ($characteristicHeader/Record[FieldName = 'OrderEffectiveDate']/FieldValue != '')">
            <xsl:choose>
               <xsl:when test="$characteristicHeader/Record[FieldName = 'OrderEffectiveDate']/FieldValue != ''">
                  <xsl:attribute name="effectiveDate">
                     <xsl:value-of select="$characteristicHeader/Record[FieldName = 'OrderEffectiveDate']/FieldValue"/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="effectiveDate">
                     <xsl:value-of select="$anDateTime"/>
                  </xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
         <xsl:if test="(/Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/@expirationDate != '') or ($characteristicHeader/Record[FieldName = 'OrderExpirationDate']/FieldValue != '')">
            <xsl:choose>
               <xsl:when test="$characteristicHeader/Record[FieldName = 'OrderExpirationDate']/FieldValue != ''">
                  <xsl:attribute name="expirationDate">
                     <xsl:value-of select="$characteristicHeader/Record[FieldName = 'OrderExpirationDate']/FieldValue"/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="expirationDate">
                     <xsl:value-of select="$anDateTime"/>
                  </xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
         <xsl:apply-templates select="/Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/child::*">
            <xsl:with-param name="characteristicHeader" select="$characteristicHeader"/>
         </xsl:apply-templates>
      </OrderRequestHeader>

   </xsl:template>

   <xsl:template match="OrderRequestHeader/child::*">
      <xsl:param name="characteristicHeader"/>
      <xsl:choose>
         <xsl:when test="local-name()='Total'">
            <Total>
               <Money>
                  <xsl:copy-of select="./Money/@*"></xsl:copy-of>
                  <xsl:value-of select="$orderTotal"/>
               </Money>
            </Total>
         </xsl:when>
         <xsl:when test="(local-name() = 'Contact' and ./@role = 'supplierCorporate') or (local-name() = 'Contact' and ./@role = 'shipFrom')">
            <Contact>
               <xsl:choose>
                  <xsl:when test="$characteristicHeader/Record[FieldName = 'OrderHeaderSupplierAddressID']/FieldValue != '' and ./@role = 'supplierCorporate'">
                     <xsl:attribute name="addressID">
                        <xsl:value-of select="$characteristicHeader/Record[FieldName = 'OrderHeaderSupplierAddressID']/FieldValue"/>
                     </xsl:attribute>
                  </xsl:when>

                  <xsl:when test="$characteristicHeader/Record[FieldName = 'OrderHeaderShipFromAddressID']/FieldValue != '' and ./@role = 'shipFrom'">
                     <xsl:attribute name="addressID">
                        <xsl:value-of select="$characteristicHeader/Record[FieldName = 'OrderHeaderShipFromAddressID']/FieldValue"/>
                     </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:attribute name="addressID">
                        <xsl:value-of select="@addressID"/>
                     </xsl:attribute>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:copy-of select="./@*[name() != 'addressID'] | node()"/>
            </Contact>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="ItemDetail/child::* | BlanketItemDetail/child::*">
      <xsl:param name="itemCharacteristics"/>
      <xsl:param name="baseItem"/>

      <xsl:choose>
         <xsl:when test="local-name() = 'UnitPrice'">
            <xsl:choose>
               <xsl:when test="$itemCharacteristics/Record[FieldName = 'ItemUnitPrice']">
                  <UnitPrice>
                     <Money>
                        <xsl:copy-of select="./Money/@*"/>
                        <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'ItemUnitPrice']/FieldValue"/>
                     </Money>
                     <xsl:copy-of select="./Money/following-sibling::*"/>
                  </UnitPrice>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="."> </xsl:copy-of>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="local-name() = 'Description'">
            <xsl:choose>
               <xsl:when test="$itemCharacteristics/Record[FieldName = 'Item Description']/FieldValue != ''">
                  <Description xml:lang="en">
                     <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'Item Description']/FieldValue"/>
                  </Description>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="."> </xsl:copy-of>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="local-name() = 'UnitOfMeasure'">
            <xsl:choose>
               <xsl:when test="$itemCharacteristics/Record[FieldName = 'ItemUnitOfMeasure']">
                  <UnitOfMeasure>
                     <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'ItemUnitOfMeasure']/FieldValue"/>
                  </UnitOfMeasure>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="."> </xsl:copy-of>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="local-name() = 'PriceBasisQuantity'">
            <PriceBasisQuantity>
               <xsl:copy-of select="./@*"/>
               <xsl:choose>
                  <xsl:when test="$itemCharacteristics/Record[FieldName = 'OrderItemPriceBasisUOM']">
                     <UnitOfMeasure>
                        <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'OrderItemPriceBasisUOM']/FieldValue"/>
                     </UnitOfMeasure>
                  </xsl:when>
                  <xsl:otherwise>

                     <xsl:copy-of select="./UnitOfMeasure"> </xsl:copy-of>

                  </xsl:otherwise>
               </xsl:choose>
               <xsl:copy-of select="./UnitOfMeasure/following-sibling::*"/>
            </PriceBasisQuantity>
         </xsl:when>
         <xsl:when test="local-name() = 'ItemDetailIndustry'">
            <ItemDetailIndustry>
               <xsl:copy-of select="./@*"/>
               <ItemDetailRetail>
                  <xsl:choose>
                     <xsl:when test="$itemCharacteristics/Record[FieldName = 'OrderItemDetailRetailEANID']">
                        <EANID>
                           <xsl:value-of select="$itemCharacteristics/Record[FieldName = 'OrderItemDetailRetailEANID']/FieldValue"/>
                        </EANID>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="./ItemDetailRetail/EANID"> </xsl:copy-of>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:copy-of select="./ItemDetailRetail/EANID/following-sibling::*"/>

               </ItemDetailRetail>

            </ItemDetailIndustry>

         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <xsl:template name="calculateOrderTotal">
      <xsl:choose>
         <xsl:when test="count(/Combined/Characteristics/Details/Detail) = 0">
            <xsl:value-of select="/Combined/Payload/cXML/Request/OrderRequest/OrderRequestHeader/Total"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="listItemAmount">
               <Items>
                  <xsl:for-each select="/Combined/Characteristics/Details/Detail">
                     <xsl:variable name="itemNumber" select="Record[FieldName = 'LineItemNumber']/FieldValue"/>
                     <xsl:variable name="baseItem">
                        <xsl:choose>
                           <xsl:when test="/Combined/Payload/cXML/Request/OrderRequest/ItemOut[@lineNumber = $itemNumber]">
                              <xsl:copy-of select="/Combined/Payload/cXML/Request/OrderRequest/ItemOut[@lineNumber = $itemNumber]"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="/Combined/Payload/cXML/Request/OrderRequest/ItemOut[1]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:copy-of select="$baseItem"></xsl:copy-of>
                     <xsl:variable name="itemQty">
                        <xsl:choose>
                           <xsl:when test="Record[FieldName = 'ItemQuantity']/FieldValue != ''">
                              <xsl:value-of select="Record[FieldName = 'ItemQuantity']/FieldValue"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$baseItem/ItemOut/@quantity"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="itemPrice">
                        <xsl:choose>
                           <xsl:when test="Record[FieldName = 'ItemUnitPrice']/FieldValue != ''">
                              <xsl:value-of select="Record[FieldName = 'ItemUnitPrice']/FieldValue"/>
                           </xsl:when>
                           <xsl:when test="$baseItem/ItemOut/ItemDetail">
                              <xsl:value-of select="$baseItem/ItemOut/ItemDetail/UnitPrice/Money"/>
                           </xsl:when>
                           <xsl:when test="$baseItem/ItemOut/BlanketItemDetail/UnitPrice">
                              <xsl:value-of select="$baseItem/ItemOut/BlanketItemDetail/UnitPrice/Money"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="number('0.0')"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <ItemNum>
                        <xsl:value-of select="$itemNumber"/>
                     </ItemNum>
                     <ItemTotal>
                        <xsl:value-of select="$itemPrice * $itemQty"/>
                     </ItemTotal>
                  </xsl:for-each>
               </Items>
            </xsl:variable>
            <xsl:value-of select="sum($listItemAmount/Items/ItemTotal)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
