<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="anSenderDefaultTimeZone"/>

   <xsl:template match="/">
      <xsl:variable name="BODID" select="concat(NotifyProductionOrder/ApplicationArea/BODID, '')"/>
      <xsl:variable name="CreationDateTime" select="concat(NotifyProductionOrder/ApplicationArea/CreationDateTime, '')"/>
      <cXML>
         <xsl:attribute name="timestamp">
            <xsl:value-of select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"/>
         </xsl:attribute>
         <xsl:attribute name="payloadID">
            <xsl:value-of select="$anPayloadID"/>
         </xsl:attribute>
         <Header>
            <From>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anSupplierANID"/>
                  </Identity>
               </Credential>
            </From>
            <To>
               <Credential domain="NetworkID">
                  <Identity>
                     <xsl:value-of select="$anBuyerANID"/>
                  </Identity>
               </Credential>
            </To>
            <Sender>
               <Credential domain="NetworkId">
                  <Identity>
                     <xsl:value-of select="$anProviderANID"/>
                  </Identity>
               </Credential>
               <UserAgent>
                  <xsl:value-of select="'Ariba Supplier'"/>
               </UserAgent>
            </Sender>
         </Header>
         <Message>
            <xsl:choose>
               <xsl:when test="$anEnvName = 'PROD'">
                  <xsl:attribute name="deploymentMode">production</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="deploymentMode">test</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>

            <ProductReplenishmentMessage>
               <ProductReplenishmentHeader>
                  <xsl:attribute name="messageID">
                     <xsl:value-of select="/NotifyProductionOrder/DataArea/ProductionOrder[1]/ProductionOrderHeader/DocumentID/ID"/>
                  </xsl:attribute>
                  <xsl:attribute name="creationDate">
                     <xsl:value-of select="/NotifyProductionOrder/DataArea/ProductionOrder[1]/ProductionOrderHeader/DocumentDateTime"/>
                  </xsl:attribute>
               </ProductReplenishmentHeader>
               <xsl:for-each select="/NotifyProductionOrder/DataArea/ProductionOrder[1]/ProductionOrderLine">
                  <ProductReplenishmentDetails>
                     <ItemID>
                        <SupplierPartID>
                           <xsl:value-of select="ManufacturingItem/ItemID[@agencyRole = 'VendorPartNumber']/ID"/>
                        </SupplierPartID>
                        <BuyerPartID>
                           <xsl:value-of select="ManufacturingItem/ItemID[@agencyRole = 'MSPartNumber']/ID"/>
                        </BuyerPartID>
                     </ItemID>
                     <xsl:for-each select="DocumentReference">
                        <ReplenishmentTimeSeries>
                           <xsl:variable name="replenishType" select="lower-case(@type)"/>
                           <xsl:choose>
                              <xsl:when test="$replenishType = 'manufacturingorder'">
                                 <xsl:attribute name="type">
                                    <xsl:value-of select="'manufacturingOrder'"/>
                                 </xsl:attribute>
                              </xsl:when>
                              <xsl:when test="$replenishType = 'purchaseorder'">
                                 <xsl:attribute name="type">
                                    <xsl:value-of select="'purchaseOrder'"/>
                                 </xsl:attribute>
                              </xsl:when>
                           </xsl:choose>
                           <TimeSeriesDetails>
                              <Period>
                                 <xsl:attribute name="startDate">
                                    <xsl:value-of select="EffectiveTimePeriod/StartDateTime"/>
                                 </xsl:attribute>
                                 <xsl:attribute name="endDate">
                                    <xsl:value-of select="EffectiveTimePeriod/EndDateTime"/>
                                 </xsl:attribute>
                              </Period>
                              <TimeSeriesQuantity>
                                 <xsl:attribute name="quantity">
                                    <xsl:value-of select="./UserArea/Quantity"/>
                                 </xsl:attribute>
                                 <UnitOfMeasure>
                                    <xsl:value-of select="./UserArea/Status[Code/@name='UOM']/Code"/>
                                 </UnitOfMeasure>
                              </TimeSeriesQuantity>
                              <xsl:if test="DocumentID/ID">
                                 <IdReference>
                                    <xsl:attribute name="domain">
                                       <xsl:choose>
                                          <xsl:when test="$replenishType = 'manufacturingorder'">
                                             <xsl:attribute name="type">
                                                <xsl:value-of select="'MoDocument'"/>
                                             </xsl:attribute>
                                          </xsl:when>
                                          <xsl:when test="$replenishType = 'purchaseorder'">
                                             <xsl:attribute name="type">
                                                <xsl:value-of select="'PoDocument'"/>
                                             </xsl:attribute>
                                          </xsl:when>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:attribute name="identifier">
                                       <xsl:value-of select="DocumentID/ID"/>
                                    </xsl:attribute>
                                 </IdReference>
                              </xsl:if>
                           </TimeSeriesDetails>
                        </ReplenishmentTimeSeries>
                     </xsl:for-each>
                  </ProductReplenishmentDetails>
               </xsl:for-each>
            </ProductReplenishmentMessage>
         </Message>
      </cXML>
   </xsl:template>
</xsl:stylesheet>
