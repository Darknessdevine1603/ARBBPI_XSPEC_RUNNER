<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output indent="yes" exclude-result-prefixes="xs" method="xml" omit-xml-declaration="yes"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <xsl:template match="//M_830/S_BFR">
      <xsl:element name="S_BFR">
         <xsl:copy-of select="D_353"/>
         <xsl:copy-of select="D_127"/>
         <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'releaseNo']) != ''">
            <D_328>
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/Extrinsic[@name = 'releaseNo']), 1, 30)"/>
            </D_328>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType']) != ''">
               <D_675>
                  <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType']), 1, 2)"/>
               </D_675>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_675"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="D_676"/>
         <xsl:choose>
            <xsl:when test="normalize-space((//ProductActivityMessage/ProductActivityDetails/Extrinsic[@name = 'startDate'])[1]) != ''">
               <xsl:element name="D_373">
                  <xsl:value-of select="substring(replace(normalize-space((//ProductActivityMessage/ProductActivityDetails/Extrinsic[@name = 'startDate'])[1]), '-', ''), 1, 8)"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_373"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="normalize-space((//ProductActivityMessage/ProductActivityDetails/Extrinsic[@name = 'expirationDate'])[1]) != ''">
               <xsl:element name="D_373_2">
                  <xsl:value-of select="substring(replace(normalize-space((//ProductActivityMessage/ProductActivityDetails/Extrinsic[@name = 'expirationDate'])[1]), '-', ''), 1, 8)"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_373_2"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="D_373_3"/>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'accessorialStatusCode']) != ''">
               <xsl:element name="D_373_4">
                  <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/Extrinsic[@name = 'accessorialStatusCode'], '-', '')), 1, 8)"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_373_4"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'originalPurchaseOrder'])!=''">
               <D_367>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'originalPurchaseOrder'])"/>
               </D_367>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_367"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'orderNo']) != ''">
               <D_324>
                  <xsl:value-of select="normalize-space(substring(normalize-space(//ProductActivityMessage/Extrinsic[@name = 'orderNo']), 1, 22))"/>
               </D_324>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_324"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="D_783"/>
         <xsl:copy-of select="D_306"/>
      </xsl:element>
      <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'unitsShipped']) != ''">
         <S_REF>
            <D_128>L1</D_128>
            <D_127>unitsShipped</D_127>
            <D_352>
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/Extrinsic[@name = 'unitsShipped']), 1, 80)"/>
            </D_352>
         </S_REF>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//M_830/G_LIN/S_LIN">
      <xsl:variable name="linPosition" select="count(../preceding-sibling::G_LIN) + 1"/>
      <xsl:variable name="tCount" select="count(node()[starts-with(name(), 'D_235')])"/>
      <xsl:element name="S_LIN">
         <xsl:copy-of select="node()"/>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryDate']) != '' and normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Classification[@domain = 'InternalProgramCode']) != ''">
               <xsl:element name="{concat('D_235_',($tCount+1))}">TP</xsl:element>
               <xsl:element name="{concat('D_234_',($tCount+1))}">
                  <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Classification[@domain = 'InternalProgramCode']), 1, 48)"/>
               </xsl:element>
               <xsl:element name="{concat('D_235_',($tCount+2))}">EC</xsl:element>
               <xsl:element name="{concat('D_234_',($tCount+2))}">
                  <xsl:value-of select="replace(substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryDate']), 1, 10), '-', '')"/>
               </xsl:element>
            </xsl:when>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryDate']) != ''"/>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Classification[@domain = 'InternalProgramCode']) != ''"/>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//M_830/G_LIN/S_LDT">
      <xsl:variable name="linPosition" select="count(../preceding-sibling::G_LIN) + 1"/>
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/ItemID/SupplierPartID/@revisionID) != ''">
         <S_REF>
            <D_128>SZ</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/ItemID/SupplierPartID/@revisionID), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'binLocationNo']) != ''">
         <S_REF>
            <D_128>BO</D_128>
            <D_127>
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'binLocationNo']), 1, 30)"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <xsl:copy-of select="."/>
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'combinedShipment']) != '' and normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'lossdate']) != ''">
         <xsl:element name="S_ATH">
            <xsl:element name="D_672">LM</xsl:element>
            <xsl:element name="D_373">
               <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'lossdate'], '-', '')), 1, 8)"/>
            </xsl:element>
            <xsl:element name="D_380">
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'combinedShipment']), 1, 15)"/>
            </xsl:element>
            <xsl:element name="D_380_2">
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryRegion']), 1, 15)"/>
            </xsl:element>
            <xsl:element name="D_373_2">
               <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], '-', '')), 1, 8)"/>
            </xsl:element>
         </xsl:element>
      </xsl:if>
      <!--<xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name='deliveryRegion'])!='' and normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name='lossdate'])!=''">			<xsl:element name="S_ATH">				<xsl:element name="D_672">LB</xsl:element>				<xsl:element name="D_373">					<xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name='lossdate'],'-','')),1,8)"/>				</xsl:element>				<xsl:element name="D_380">					<xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name='deliveryRegion']),1,15)"/>				</xsl:element>				<xsl:element name="D_373_2">					<xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name='lossdate'],'-','')),1,8)"/>				</xsl:element>			</xsl:element>		</xsl:if>-->
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'poShipmentNumber']) != '' and normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'hourstodate']) != '' and normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'termsOfDeliveryCode']) != ''">
         <xsl:element name="S_ATH">
            <xsl:element name="D_672">MT</xsl:element>
            <xsl:element name="D_373">
               <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'hourstodate'], '-', '')), 1, 8)"/>
            </xsl:element>
            <xsl:element name="D_380">
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'poShipmentNumber']), 1, 15)"/>
            </xsl:element>
            <xsl:element name="D_380_2">
               <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'termsOfDeliveryCode']), 1, 15)"/>
            </xsl:element>
            <xsl:element name="D_373_2">
               <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], '-', '')), 1, 8)"/>
            </xsl:element>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//M_830/G_LIN/G_N1">
      <xsl:variable name="linPosition" select="count(../preceding-sibling::G_LIN) + 1"/>
      <xsl:variable name="N1Position" select="count(preceding-sibling::G_N1) + 1"/>
      <xsl:element name="G_N1">
         <xsl:choose>
            <xsl:when test="S_N1/D_98 = 'ZZ' and //ProductActivityMessage/ProductActivityDetails[$linPosition]/Contact[$N1Position]/@role = 'SP'">
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">SP</xsl:element>
                  <xsl:apply-templates select="(S_N1/node() | @*)[name(.) != 'D_98']"/>
               </xsl:element>
            </xsl:when>
            <xsl:when test="S_N1/D_98 = 'ZZ' and //ProductActivityMessage/ProductActivityDetails[$linPosition]/Contact[$N1Position]/@role = 'SLS'">
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">YE</xsl:element>
                  <xsl:apply-templates select="(S_N1/node() | @*)[name(.) != 'D_98']"/>
               </xsl:element>
            </xsl:when>
            <xsl:when test="S_N1/D_98 = 'ZZ' and //ProductActivityMessage/ProductActivityDetails[$linPosition]/Contact[$N1Position]/@role = '98'">
               <xsl:element name="S_N1">
                  <xsl:element name="D_98">98</xsl:element>
                  <xsl:apply-templates select="(S_N1/node() | @*)[name(.) != 'D_98']"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="S_N1"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="S_N2"/>
         <xsl:copy-of select="S_N3"/>
         <xsl:copy-of select="S_N4"/>
         <xsl:copy-of select="S_REF"/>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Contact[$N1Position]/Extrinsic[@name = 'plantNo']) != ''">
            <xsl:element name="S_REF">
               <xsl:element name="D_128">PE</xsl:element>
               <xsl:element name="D_127">
                  <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Contact[$N1Position]/Extrinsic[@name = 'plantNo']), 1, 30)"/>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:copy-of select="S_PER"/>
         <xsl:copy-of select="S_FOB"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//M_830/G_LIN/G_FST/S_FST">
      <xsl:variable name="linPosition" select="count(../preceding-sibling::G_LIN) + 1"/>
      <xsl:variable name="FSTPosition" select="count(../preceding-sibling::G_FST) + 1"/>
      <xsl:element name="S_FST">
         <xsl:copy-of select="D_380"/>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/TimeSeries[1]/Forecast[$FSTPosition]/Extrinsic[@name = 'deliveryQuoteNo']) = 'Z'">
               <xsl:element name="D_680">A</xsl:element>
            </xsl:when>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/TimeSeries[1]/Forecast[$FSTPosition]/Extrinsic[@name = 'refinerID']) = 'firm'">
               <xsl:element name="D_680">C</xsl:element>
            </xsl:when>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/TimeSeries[1]/Forecast[$FSTPosition]/Extrinsic[@name = 'refinerID']) = 'tradeoff'">
               <xsl:element name="D_680">Z</xsl:element>
            </xsl:when>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/TimeSeries[1]/Forecast[$FSTPosition]/Extrinsic[@name = 'refinerID']) = 'Forecast'">
               <xsl:element name="D_680">D</xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_680"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:choose>
            <xsl:when test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/TimeSeries[1]/Forecast[$FSTPosition]/Extrinsic[@name = 'deliveryQuoteNo']) != ''">
               <xsl:element name="D_681">
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/TimeSeries[1]/Forecast[$FSTPosition]/Extrinsic[@name = 'deliveryQuoteNo'])"/>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="D_681"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="D_373"/>
         <xsl:copy-of select="D_373_2"/>
         <xsl:copy-of select="D_374"/>
         <xsl:copy-of select="D_337"/>
         <xsl:copy-of select="D_128"/>
         <xsl:copy-of select="D_127"/>
         <xsl:copy-of select="D_783"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="//M_830/G_LIN/G_FST[last()]">
      <xsl:element name="G_FST">
         <xsl:apply-templates/>
      </xsl:element>
      <xsl:variable name="linPosition" select="count(../preceding-sibling::G_LIN) + 1"/>
      <xsl:copy-of select="G_SDP"/>
      <xsl:copy-of select="G_SHP"/>
      <xsl:choose>
         <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType']) = 'SH'">
            <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'endDate']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'consolidationShipmentNumber']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'carrierAssignedShipperNo']) != ''">
               <xsl:element name="G_SHP">
                  <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'endDate']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'carrierAssignedShipperNo']) != ''">
                     <xsl:element name="S_SHP">
                        <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'carrierAssignedShipperNo']) != ''">
                           <xsl:element name="D_673">01</xsl:element>
                           <xsl:element name="D_380">
                              <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'carrierAssignedShipperNo']), 1, 15)"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'endDate']) != ''">
                           <xsl:element name="D_374">011</xsl:element>
                           <xsl:element name="D_373">
                              <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'endDate'], '-', '')), 1, 8)"/>
                           </xsl:element>
                           <xsl:if test="normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'endDate'], ':', '')), 'T')) != ''">
                              <xsl:element name="D_337">
                                 <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'endDate'], ':', '')), 'T')), 1, 6)"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'consolidationShipmentNumber']) != ''">
                     <xsl:element name="S_REF">
                        <xsl:element name="D_128">PK</xsl:element>
                        <xsl:element name="D_127">
                           <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'consolidationShipmentNumber']), 1, 30)"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:if>
            <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'agentsShipmentNo']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode']) != ''">
               <xsl:element name="G_SHP">
                  <xsl:element name="S_SHP">
                     <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'agentsShipmentNo']) != ''">
                        <xsl:element name="D_673">02</xsl:element>
                        <xsl:element name="D_380">
                           <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'agentsShipmentNo']), 1, 15)"/>
                        </xsl:element>
                     </xsl:if>
                     <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate']) != ''">
                        <xsl:element name="D_374">011</xsl:element>
                        <xsl:element name="D_373">
                           <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')) != ''">
                           <xsl:element name="D_337">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:if>
                     <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode']) != ''">
                        <xsl:element name="D_373_2">
                           <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode'], '-', '')), 1, 8)"/>
                        </xsl:element>
                        <xsl:if test="normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode'], ':', '')), 'T')) != ''">
                           <xsl:element name="D_337_2">
                              <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode'], ':', '')), 'T')), 1, 6)"/>
                           </xsl:element>
                        </xsl:if>
                     </xsl:if>
                  </xsl:element>
               </xsl:element>
            </xsl:if>
         </xsl:when>
         <xsl:when test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'transactionCategoryOrType']) = 'DL'">
            <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'T_C_Date_Stamp']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryNoteNumber']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'packingListNo']) != ''">
               <xsl:element name="G_SHP">
                  <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'T_C_Date_Stamp']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryNoteNumber']) != ''">
                     <xsl:element name="S_SHP">
                        <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryNoteNumber']) != ''">
                           <xsl:element name="D_673">01</xsl:element>
                           <xsl:element name="D_380">
                              <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryNoteNumber']), 1, 15)"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'T_C_Date_Stamp']) != ''">
                           <xsl:element name="D_374">002</xsl:element>
                           <xsl:element name="D_373">
                              <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'T_C_Date_Stamp'], '-', '')), 1, 8)"/>
                           </xsl:element>
                           <xsl:if test="normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'T_C_Date_Stamp'], ':', '')), 'T')) != ''">
                              <xsl:element name="D_337">
                                 <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'T_C_Date_Stamp'], ':', '')), 'T')), 1, 6)"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'packingListNo']) != ''">
                     <xsl:element name="S_REF">
                        <xsl:element name="D_128">PK</xsl:element>
                        <xsl:element name="D_127">
                           <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'packingListNo']), 1, 30)"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:if>
            <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'minQtyPerRelease']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode']) != ''">
               <xsl:element name="G_SHP">
                  <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate']) != '' or normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'deliveryNoteNumber']) != ''">
                     <xsl:element name="S_SHP">
                        <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'minQtyPerRelease']) != ''">
                           <xsl:element name="D_673">02</xsl:element>
                           <xsl:element name="D_380">
                              <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'minQtyPerRelease']), 1, 15)"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate']) != ''">
                           <xsl:element name="D_374">050</xsl:element>
                           <xsl:element name="D_373">
                              <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], '-', '')), 1, 8)"/>
                           </xsl:element>
                           <xsl:if test="normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')) != ''">
                              <xsl:element name="D_337">
                                 <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'touAcceptanceDate'], ':', '')), 'T')), 1, 6)"/>
                              </xsl:element>
                           </xsl:if>
                           <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode']) != ''">
                              <xsl:element name="D_373_2">
                                 <xsl:value-of select="substring(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode'], '-', '')), 1, 8)"/>
                              </xsl:element>
                           </xsl:if>
                           <xsl:if test="normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode'], ':', '')), 'T')) != ''">
                              <xsl:element name="D_337_2">
                                 <xsl:value-of select="substring(normalize-space(substring-after(normalize-space(replace(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'accessorialStatusCode'], ':', '')), 'T')), 1, 6)"/>
                              </xsl:element>
                           </xsl:if>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:if>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'carrierShipmentID']) != ''">
         <xsl:element name="G_SHP">
            <xsl:element name="S_SHP">
               <xsl:element name="D_673">12</xsl:element>
               <xsl:element name="D_380">
                  <xsl:value-of select="substring(normalize-space(//ProductActivityMessage/ProductActivityDetails[$linPosition]/Extrinsic[@name = 'carrierShipmentID']), 1, 15)"/>
               </xsl:element>
            </xsl:element>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//M_830/G_LIN/S_REF[D_128='ZZ']"/>
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
