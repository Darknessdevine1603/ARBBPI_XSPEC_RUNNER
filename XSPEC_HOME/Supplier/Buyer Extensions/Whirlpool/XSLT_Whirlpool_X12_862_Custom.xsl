<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//M_862/S_BSS">
      <xsl:element name="S_BSS">
         <xsl:copy-of select="D_353"/>
         <xsl:copy-of select="D_127"/>
         <xsl:copy-of select="D_373"/>
         <xsl:choose>
            <xsl:when test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) != ''">
               <D_675>
                  <xsl:value-of select="substring(normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']), 1, 2)"/>
               </D_675>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_675"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="normalize-space((//OrderRequest/ItemOut/ItemDetail/Extrinsic[@name = 'startDate'])[1]) != ''">
               <xsl:element name="D_373_2">
                  <xsl:value-of select="substring(replace(normalize-space((//OrderRequest/ItemOut/ItemDetail/Extrinsic[@name = 'startDate'])[1]), '-', ''), 1, 8)"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_373_2"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="normalize-space((//OrderRequest/ItemOut/ItemDetail/Extrinsic[@name = 'expirationDate'])[1]) != ''">
               <xsl:element name="D_373_3">
                  <xsl:value-of select="substring(replace(normalize-space((//OrderRequest/ItemOut/ItemDetail/Extrinsic[@name = 'expirationDate'])[1]), '-', ''), 1, 8)"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_373_3"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="D_328"/>
         <xsl:copy-of select="D_127_2"/>  
         <xsl:choose>
            <xsl:when test="normalize-space((//OrderRequest/ItemOut/ItemDetail/Extrinsic[@name = 'originalPurchaseOrder'])[1])!=''">
               <D_367>
                  <xsl:value-of select="normalize-space((//OrderRequest/ItemOut/ItemDetail/Extrinsic[@name = 'originalPurchaseOrder'])[1])"/>
               </D_367>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_367"/>
            </xsl:otherwise>
         </xsl:choose>         
         <xsl:copy-of select="D_324"/>
         <xsl:copy-of select="D_676"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="S_LIN">
      <xsl:param name="lineNumber"/>
      <xsl:variable name="tCount" select="count(node()[starts-with(name(), 'D_235')])"/>
      <xsl:element name="S_LIN">
         <xsl:copy-of select="node()"/>
         <xsl:choose>
            <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryDate']) != ''">
               <xsl:element name="{concat('D_235_',($tCount+1))}">EC</xsl:element>
               <xsl:element name="{concat('D_234_',($tCount+1))}">
                  <xsl:value-of select="replace(substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryDate']), 1, 10), '-', '')"/>
               </xsl:element>
            </xsl:when>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//M_862/G_N1">
      <xsl:variable name="partyCount" select="        count(./preceding-sibling::G_N1[S_N1/D_98 != 'ST' and        S_N1/D_98 != 'BT' and S_N1/D_98 != 'DA']) + 1"/>
      <xsl:variable name="isLastN1" select="count(./following-sibling::G_N1)"/>
      <xsl:choose>
         <xsl:when test="S_N1/D_98 = 'ZZ' and //OrderRequest/OrderRequestHeader/Contact[$partyCount]/@role = 'FreightManager1'">
            <G_N1>
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">SP</xsl:element>
                  <xsl:apply-templates select="(S_N1/node() | @*)[name(.) != 'D_98']"/>
               </xsl:element>
               <xsl:copy-of select="S_N1/following-sibling::*"/>
            </G_N1>
         </xsl:when>
         <xsl:when test="S_N1/D_98 = 'ZZ' and //OrderRequest/OrderRequestHeader/Contact[$partyCount]/@role = 'ThirdPartyLogisticsProvider'">
            <G_N1>
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">YE</xsl:element>
                  <xsl:apply-templates select="(S_N1/node() | @*)[name(.) != 'D_98']"/>
               </xsl:element>
               <xsl:copy-of select="S_N1/following-sibling::*"/>
            </G_N1>
         </xsl:when>
         <xsl:when test="S_N1/D_98 = 'ZZ' and //OrderRequest/OrderRequestHeader/Contact[$partyCount]/@role = 'FreightManager2'">
            <G_N1>
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">98</xsl:element>
                  <xsl:apply-templates select="(S_N1/node() | @*)[name(.) != 'D_98']"/>
               </xsl:element>
               <xsl:copy-of select="S_N1/following-sibling::*"/>
            </G_N1>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$isLastN1 = 0">
         <xsl:if test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'scheduleRefNo']) != ''">
            <xsl:element name="G_N1">
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">04</xsl:element>
                  <xsl:element name="D_93">ASN Qty netted from schedule</xsl:element>
               </xsl:element>
               <xsl:element name="S_REF">
                  <xsl:element name="D_128">L1</xsl:element>
                  <xsl:element name="D_127">ASN Qty netted from schedule</xsl:element>
                  <xsl:element name="D_352">
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'scheduleRefNo']), 1, 80)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space(//OrderRequest/OrderRequestHeader/Comments) != ''">
            <xsl:element name="G_N1">
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">HL</xsl:element>
                  <xsl:element name="D_93">lettersOrNotes</xsl:element>
               </xsl:element>
               <xsl:variable name="comments" select="normalize-space(//OrderRequest/OrderRequestHeader/Comments)"/>
               <xsl:call-template name="REFLoop">
                  <xsl:with-param name="inText" select="$comments"/>
                  <xsl:with-param name="CurrentEndPos" select="80"/>
                  <xsl:with-param name="Pos" select="1"/>
                  <xsl:with-param name="StrLen" select="string-length($comments)"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//M_862/G_LIN">
      <xsl:variable name="lineNumber" select="S_LIN/D_350"/>
      <xsl:element name="G_LIN">
         <xsl:apply-templates select="S_LIN">
            <xsl:with-param name="lineNumber" select="$lineNumber"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="S_UIT"/>
         <xsl:apply-templates select="S_PKG"/>
         <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/Comments) != ''">
            <xsl:variable name="comments" select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/Comments)"/>
            <xsl:call-template name="PKGLoop">
               <xsl:with-param name="inText" select="$comments"/>
               <xsl:with-param name="CurrentEndPos" select="80"/>
               <xsl:with-param name="Pos" select="1"/>
               <xsl:with-param name="StrLen" select="string-length($comments)"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:apply-templates select="S_PO4"/>
         <xsl:apply-templates select="S_PRS"/>
         <xsl:apply-templates select="S_QTY"/>
         <!-- IG-28396 -->
         <xsl:call-template name="RebuildREF">
            <xsl:with-param name="lineNumber" select="$lineNumber"></xsl:with-param>
         </xsl:call-template>
         <xsl:apply-templates select="S_PER"/>
         <xsl:apply-templates select="S_SDP"/>
         <xsl:apply-templates select="G_FST">
            <xsl:with-param name="lineNumber" select="$lineNumber"/>
         </xsl:apply-templates>
         <xsl:apply-templates select="G_SHP">
            <xsl:with-param name="lineNumber" select="$lineNumber"/>
         </xsl:apply-templates>
         <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'buyerDueShipQuantity']) != ''">
            <xsl:element name="G_SHP">
               <xsl:element name="S_SHP">
                  <xsl:element name="D_673">BA</xsl:element>
                  <xsl:element name="D_380">
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'buyerDueShipQuantity']), 1, 15)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'carrierShipmentID']) != ''">
            <xsl:element name="G_SHP">
               <xsl:element name="S_SHP">
                  <xsl:element name="D_673">12</xsl:element>
                  <xsl:element name="D_380">
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'carrierShipmentID']), 1, 15)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'combinedShipment']) != ''">
            <xsl:element name="G_SHP">
               <xsl:element name="S_SHP">
                  <xsl:element name="D_673">37</xsl:element>
                  <xsl:element name="D_380">
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'combinedShipment']), 1, 15)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryRegion']) != ''">
            <xsl:element name="G_SHP">
               <xsl:element name="S_SHP">
                  <xsl:element name="D_673">QF</xsl:element>
                  <xsl:element name="D_380">
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryRegion']), 1, 15)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'termsOfDeliveryCode']) != ''">
            <xsl:element name="G_SHP">
               <xsl:element name="S_SHP">
                  <xsl:element name="D_673">QR</xsl:element>
                  <xsl:element name="D_380">
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'termsOfDeliveryCode']), 1, 15)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'poShipmentNumber']) != ''">
            <xsl:element name="G_SHP">
               <xsl:element name="S_SHP">
                  <xsl:element name="D_673">60</xsl:element>
                  <xsl:element name="D_380">
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'poShipmentNumber']), 1, 15)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) = 'SH'">
               <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'agentsShipmentNo']) != '' and normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate']) != '' and normalize-space(//OrderRequest/OrderRequestHeader/@orderDate) != ''">
                  <xsl:element name="G_SHP">
                     <xsl:element name="S_SHP">
                        <xsl:element name="D_673">02</xsl:element>
                        <xsl:element name="D_380">
                           <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'agentsShipmentNo']), 1, 15)"/>
                        </xsl:element>
                        <xsl:element name="D_374">011</xsl:element>
                        <xsl:element name="D_373">
                           <xsl:value-of select="substring(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'], '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')) != ''">
                           <xsl:element name="D_337">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:element name="D_373_2">
                           <xsl:value-of select="substring(normalize-space(replace(//OrderRequest/OrderRequestHeader/@orderDate, '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//OrderRequest/OrderRequestHeader/@orderDate, ':', '')), 'T')) != ''">
                           <xsl:element name="D_337_2">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//OrderRequest/OrderRequestHeader/@orderDate, ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'endDate']) != '' and normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'carrierAssignedShipperNo']) != ''">
                  <xsl:element name="G_SHP">
                     <xsl:element name="S_SHP">
                        <xsl:element name="D_673">01</xsl:element>
                        <xsl:element name="D_380">
                           <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'carrierAssignedShipperNo']), 1, 15)"/>
                        </xsl:element>
                        <xsl:element name="D_374">011</xsl:element>
                        <xsl:element name="D_373">
                           <xsl:value-of select="substring(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'endDate'], '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'endDate'], ':', '')), 'T')) != ''">
                           <xsl:element name="D_337">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'endDate'], ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                     <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'consolidationShipmentNumber']) != ''">
                        <xsl:element name="S_REF">
                           <xsl:element name="D_128">PK</xsl:element>
                           <xsl:element name="D_127">
                              <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'consolidationShipmentNumber']), 1, 30)"/>
                           </xsl:element>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:if>
            </xsl:when>
            <xsl:when test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) = 'DL'">
               <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ReleaseInfo/@cumulativeReceivedQuantity) != '' and normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate']) != '' and normalize-space(//OrderRequest/OrderRequestHeader/@orderDate) != ''">
                  <xsl:element name="G_SHP">
                     <xsl:element name="S_SHP">
                        <xsl:element name="D_673">02</xsl:element>
                        <xsl:element name="D_380">
                           <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]//ReleaseInfo/@cumulativeReceivedQuantity), 1, 15)"/>
                        </xsl:element>
                        <xsl:element name="D_374">050</xsl:element>
                        <xsl:element name="D_373">
                           <xsl:value-of select="substring(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'], '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')) != ''">
                           <xsl:element name="D_337">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:element name="D_373_2">
                           <xsl:value-of select="substring(normalize-space(replace(//OrderRequest/OrderRequestHeader/@orderDate, '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//OrderRequest/OrderRequestHeader/@orderDate, ':', '')), 'T')) != ''">
                           <xsl:element name="D_337_2">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//OrderRequest/OrderRequestHeader/@orderDate, ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'T_C_Date_Stamp']) != '' and normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryNoteNumber']) != ''">
                  <xsl:element name="G_SHP">
                     <xsl:element name="S_SHP">
                        <xsl:element name="D_673">01</xsl:element>
                        <xsl:element name="D_380">
                           <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'deliveryNoteNumber']), 1, 15)"/>
                        </xsl:element>
                        <xsl:element name="D_374">002</xsl:element>
                        <xsl:element name="D_373">
                           <xsl:value-of select="substring(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'T_C_Date_Stamp'], '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'T_C_Date_Stamp'], ':', '')), 'T')) != ''">
                           <xsl:element name="D_337">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'T_C_Date_Stamp'], ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                     <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'packingListNo']) != ''">
                        <xsl:element name="S_REF">
                           <xsl:element name="D_128">PK</xsl:element>
                           <xsl:element name="D_127">
                              <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'packingListNo']), 1, 30)"/>
                           </xsl:element>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:if>
            </xsl:when>
         </xsl:choose>
         <xsl:apply-templates select="S_TD1"/>
         <xsl:apply-templates select="S_TD3"/>
         <xsl:apply-templates select="S_TD5"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="G_SHP">
      <xsl:param name="lineNumber"/>
      <xsl:choose>
         <xsl:when test="S_SHP/D_673 = '87'"> </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="G_FST">
      <xsl:param name="lineNumber"/>
      <xsl:variable name="FSTPosition" select="count(preceding-sibling::G_FST) + 1"/>
      <xsl:choose>
         <xsl:when test="normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) = 'SH' or normalize-space(//OrderRequest/OrderRequestHeader/Extrinsic[@name = 'transactionCategoryOrType']) = 'DL'">
            <xsl:element name="G_FST">
               <xsl:element name="S_FST">
                  <xsl:copy-of select="./S_FST/D_380"/>
                  <!-- FST02 -->
                  <xsl:choose>
                     <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/Extrinsic[@name = 'deliveryQuoteNo']) = 'Z'">
                        <D_680>A</D_680>
                     </xsl:when>
                     <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/ScheduleLineReleaseInfo/@commitmentCode) = 'firm'">
                        <D_680>C</D_680>
                     </xsl:when>
                     <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/ScheduleLineReleaseInfo/@commitmentCode) = 'tradeoff'">
                        <D_680>Z</D_680>
                     </xsl:when>
                     <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/ScheduleLineReleaseInfo/@commitmentCode) = 'forecast'">
                        <D_680>D</D_680>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="./S_FST/D_680"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                     <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/Extrinsic[@name = 'deliveryQuoteNo']) != ''">
                        <D_681>
                           <xsl:value-of select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/Extrinsic[@name = 'deliveryQuoteNo'])"/>
                        </D_681>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="./S_FST/D_681"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- FST04 -->
                  <xsl:choose>
                     <xsl:when test="replace(substring(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/@requestedShipmentDate, 1, 10), '-', '')">
                        <D_373>
                           <xsl:value-of select="replace(substring(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/@requestedShipmentDate, 1, 10), '-', '')"/>
                        </D_373>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="./S_FST/D_373"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:copy-of select="./S_FST/D_373_2"/>
                  <xsl:copy-of select="./S_FST/D_374"/>
                  <xsl:copy-of select="./S_FST/D_337"/>
                  <xsl:copy-of select="./S_FST/D_128"/>
                  <xsl:copy-of select="./S_FST/D_127"/>
                  <xsl:copy-of select="./S_FST/D_783"/>
               </xsl:element>
               <!-- FST/DTM -->
               <xsl:choose>
                  <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/@requestedShipmentDate)">
                     <xsl:call-template name="createDTM">
                        <xsl:with-param name="D374_Qual">010</xsl:with-param>
                        <xsl:with-param name="cXMLDate">
                           <xsl:value-of select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/@requestedShipmentDate)"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/@requestedDeliveryDate) != ''">
                     <xsl:call-template name="createDTM">
                        <xsl:with-param name="D374_Qual">002</xsl:with-param>
                        <xsl:with-param name="cXMLDate">
                           <xsl:value-of select="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ScheduleLine[$FSTPosition]/@requestedDeliveryDate)"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:copy-of select="S_DTM"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:copy-of select="S_SDQ"/>
               <xsl:copy-of select="G_JIT"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="createDTM">
      <xsl:param name="D374_Qual"/>
      <xsl:param name="cXMLDate"/>
      <S_DTM>
         <D_374>
            <xsl:value-of select="$D374_Qual"/>
         </D_374>
         <D_373>
            <xsl:value-of select="replace(substring($cXMLDate, 0, 11), '-', '')"/>
         </D_373>
         <xsl:if test="replace(substring($cXMLDate, 12, 8), ':', '') != ''">
            <D_337>
               <xsl:value-of select="replace(substring($cXMLDate, 12, 8), ':', '')"/>
            </D_337>
         </xsl:if>
         <xsl:variable name="timeZone" select="replace(replace(substring($cXMLDate, 20, 6), '\+', 'P'), '\-', 'M')"/>
         <xsl:if test="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone]/X12Code != ''">
            <D_623>
               <xsl:value-of select="$Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timeZone][1]/X12Code"/>
            </D_623>
         </xsl:if>
      </S_DTM>
   </xsl:template>
   <xsl:template name="PKGLoop">
      <xsl:param name="inText"/>
      <xsl:param name="StrLen"/>
      <xsl:param name="Pos"/>
      <xsl:param name="CurrentEndPos"/>
      <xsl:variable name="Length" select="$Pos + 80"/>
      <xsl:element name="S_PKG">
         <xsl:element name="D_349">F</xsl:element>
         <xsl:element name="D_559">ZZ</xsl:element>
         <xsl:element name="D_754">Comment</xsl:element>
         <xsl:element name="D_352">
            <xsl:value-of select="substring(normalize-space($inText), $Pos, 80)"/>
         </xsl:element>
      </xsl:element>
      <xsl:if test="$Length &lt; $StrLen">
         <xsl:call-template name="PKGLoop">
            <xsl:with-param name="Pos" select="$Length"/>
            <xsl:with-param name="inText" select="$inText"/>
            <xsl:with-param name="StrLen" select="$StrLen"/>
            <xsl:with-param name="CurrentEndPos" select="$Pos"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="REFLoop">
      <xsl:param name="inText"/>
      <xsl:param name="StrLen"/>
      <xsl:param name="Pos"/>
      <xsl:param name="CurrentEndPos"/>
      <xsl:variable name="Length" select="$Pos + 80"/>
      <xsl:element name="S_REF">
         <xsl:element name="D_128">L1</xsl:element>
         <xsl:element name="D_127">lettersOrNotes</xsl:element>
         <xsl:element name="D_352">
            <xsl:value-of select="substring(normalize-space($inText), $Pos, 80)"/>
         </xsl:element>
      </xsl:element>
      <xsl:if test="$Length &lt; $StrLen">
         <xsl:call-template name="REFLoop">
            <xsl:with-param name="Pos" select="$Length"/>
            <xsl:with-param name="inText" select="$inText"/>
            <xsl:with-param name="StrLen" select="$StrLen"/>
            <xsl:with-param name="CurrentEndPos" select="$Pos"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <!-- IG-28396 -->
   <xsl:template name="RebuildREF">
      <xsl:param name="lineNumber"></xsl:param>
      <xsl:variable name="REFList">
         <REFList>
            <xsl:for-each select="S_REF[D_128!='ZZ']">
               <xsl:copy-of select="."/>
            </xsl:for-each> 
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'revisionID']) != ''">
               <S_REF>
                  <D_128>SZ</D_128>
                  <D_127>
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'revisionID']), 1, 30)"/>
                  </D_127>
               </S_REF>
            </xsl:if>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'binLocationNo']) != ''">
               <S_REF>
                  <D_128>BO</D_128>
                  <D_127>
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'binLocationNo']), 1, 30)"/>
                  </D_127>
               </S_REF>
            </xsl:if>
            <xsl:if test="normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'originalPurchaseOrder']) != ''">
               <S_REF>
                  <D_128>ZZ</D_128>
                  <D_127>originalPurchaseOrder</D_127>
                  <D_352>
                     <xsl:value-of select="substring(normalize-space(//OrderRequest/ItemOut[@lineNumber = $lineNumber]/ItemDetail/Extrinsic[@name = 'originalPurchaseOrder']), 1, 80)"/>
                  </D_352>
               </S_REF>
            </xsl:if>
         </REFList>
      </xsl:variable>
      <xsl:for-each select="$REFList/REFList/child::*[position() &lt;13]">
         <xsl:copy-of select="."/>
      </xsl:for-each>
   </xsl:template>
   <!-- Extension Ends -->
   <xsl:template match="//Combined">
      <xsl:apply-templates select="@* | node()"/>
   </xsl:template>
   <xsl:template match="//target">
      <xsl:apply-templates select="@* | node()"/>
   </xsl:template>
   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>
