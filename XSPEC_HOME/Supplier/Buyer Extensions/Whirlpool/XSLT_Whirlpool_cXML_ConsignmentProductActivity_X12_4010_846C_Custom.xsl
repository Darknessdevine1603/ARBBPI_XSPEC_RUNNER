<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output indent="yes" exclude-result-prefixes="#all" method="xml" omit-xml-declaration="yes"/>
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
   <!-- For local testing -->
   <!--xsl:variable name="Lookup" select="document('cXML_EDILookups_X12.xml')"/>   <xsl:include href="Format_CXML_ASC-X12_common.xsl"/-->
   <!-- PD references -->
   <xsl:include href="pd:HCIOWNERPID:FORMAT_cXML_0000_ASC-X12_004010:Binary"/>
   <xsl:variable name="Lookup" select="document('pd:HCIOWNERPID:LOOKUP_ASC-X12_004010:Binary')"/>
   <xsl:template match="//source"/>
   <!-- Extension Start  -->
   <!-- Header Extrinsic -->
   <xsl:template match="//M_846/S_REF[last()]">
      <xsl:copy-of select="."/>
      <xsl:call-template name="createHeaderREF"/>
   </xsl:template>
   <xsl:template match="//M_846/S_DTM[not(exists(../S_REF))][last()]">
      <xsl:copy-of select="."/>
      <xsl:call-template name="createHeaderREF"/>
   </xsl:template>
   <xsl:template match="//M_846/S_CUR[not(exists(../S_REF)) and not(exists(../S_DTM))][last()]">
      <xsl:copy-of select="."/>
      <xsl:call-template name="createHeaderREF"/>
   </xsl:template>
   <xsl:template match="//M_846/S_BIA[not(exists(../S_REF)) and not(exists(../S_DTM)) and not(exists(../S_CUR))][last()]">
      <xsl:copy-of select="."/>
      <xsl:call-template name="createHeaderREF"/>
   </xsl:template>
   <xsl:template match="//M_846/G_LIN[G_QTY[S_QTY/D_673='V3']]">
      <!--buyer part+/- ConsignTrack ID makes a LIN unique-->
      <xsl:variable name="buyerPart" select="S_LIN/child::*[text() = 'BP' and starts-with(name(), 'D_235')]/following-sibling::*[1][starts-with(name(), 'D_234')]"/>
      <xsl:variable name="consignTrackID" select="G_QTY[S_QTY/D_673='V3']/G_REF/S_REF[D_128='2I']/D_127"/>
      <!--get the last LIN for the current Buyer Part-->
      <xsl:variable name="BuyerPartlinPosition" select="count(following-sibling::G_LIN[S_LIN/child::*=$buyerPart])"/>
      <!--get the current LIN position-->
      <xsl:variable name="linPosition" select="count(preceding-sibling::G_LIN)+1"/>
      <xsl:element name="G_LIN">
         <xsl:copy-of select="S_LIN, S_PID, S_MEA, S_PKG, S_DTM, S_CTP, S_CUR, S_SAC"/>
         
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'batchNo']) != ''">
            <S_REF>
               <D_128>BT</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'batchNo'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'vessel']) != ''">
            <S_REF>
               <D_128>LS</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'vessel'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'supplementNo']) != ''">
            <S_REF>
               <D_128>CI</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'supplementNo'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'orderNo']) != ''">
            <S_REF>
               <D_128>OQ</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'orderNo'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'purchaseOrderLineItemIDBuyer']) != ''">
            <S_REF>
               <D_128>BV</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'version']) != ''">
            <S_REF>
               <D_128>D2</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'version'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:copy-of select="S_PER, S_SDQ, S_MAN, S_UIT, S_CS, S_DD, S_G53, S_PCT, S_LDT, G_LM, G_SLN"/>
         <xsl:choose>
            <!--ConsgInv and ConsgMove present-->
            <xsl:when test="G_QTY[S_QTY/D_673 = 'V3'] and G_QTY[S_QTY/D_673 = '33']">
               <xsl:apply-templates select="G_QTY[S_QTY/D_673 = '33']" mode="replaceQual"/>
               <xsl:for-each select="G_QTY[S_QTY/D_673 = 'V3']">
                  <xsl:apply-templates select="." mode="buildRef">
                     <xsl:with-param name="conMove" select="//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/ConsignmentMovement[ProductMovementItemIDInfo/IdReference[@domain = 'consignmentTrackingID']/@identifier=$consignTrackID]"/>
                     <xsl:with-param name="position" select="position()"/>
                  </xsl:apply-templates>
               </xsl:for-each>
            </xsl:when>
            <!--Only ConsgMove present, no ConsgInv-->
            <xsl:when test="not(G_QTY[S_QTY/D_673 = '33']) and G_QTY[S_QTY/D_673 = 'V3']">
               <xsl:variable name="UOM" select="(G_QTY/S_QTY/C_C001/D_355)[1]"/>
               <xsl:element name="G_QTY">
                  <xsl:element name="S_QTY">
                     <xsl:element name="D_673">17</xsl:element>
                     <xsl:element name="D_380">0</xsl:element>
                     <xsl:element name="C_C001">
                        <xsl:element name="D_355">
                           <xsl:value-of select="$UOM"/>
                        </xsl:element>
                        <xsl:element name="D_1018">2</xsl:element>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
               <xsl:for-each select="G_QTY[S_QTY/D_673 = 'V3']">
                  <xsl:apply-templates select="." mode="buildRef">
                     <xsl:with-param name="conMove" select="//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/ConsignmentMovement[ProductMovementItemIDInfo/IdReference[@domain = 'consignmentTrackingID']/@identifier=$consignTrackID]"/>
                     <xsl:with-param name="position" select="position()"/>
                  </xsl:apply-templates>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>
         <xsl:choose>
            <!--Map all PTSeries for the current ConsignmentID from ConsgMove-->
            <xsl:when test="exists(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/PlanningTimeSeries[@type = 'custom'][@customType = 'Consignment101']) and //ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/PlanningTimeSeries[@type = 'custom'][@customType = 'Consignment101'][TimeSeriesDetails/TimeSeriesQuantity/@quantity != '']/TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier=$consignTrackID">
               <xsl:for-each select="//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/PlanningTimeSeries[@type = 'custom'][@customType = 'Consignment101'][TimeSeriesDetails/TimeSeriesQuantity/@quantity != ''][TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier=$consignTrackID]">
                  <xsl:element name="G_QTY">
                     <xsl:element name="S_QTY">
                        <xsl:element name="D_673">87</xsl:element>
                        <xsl:element name="D_380">
                           <xsl:call-template name="formatQty">
                              <xsl:with-param name="qty" select="TimeSeriesDetails/TimeSeriesQuantity/@quantity"/>
                           </xsl:call-template>
                        </xsl:element>
                        <xsl:variable name="uomcode" select="TimeSeriesDetails/TimeSeriesQuantity/UnitOfMeasure"/>
                        <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
                           <xsl:element name="C_C001">
                              <xsl:element name="D_355">
                                 <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
                              </xsl:element>
                              <xsl:element name="D_1018">3</xsl:element>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                     <xsl:if test="TimeSeriesDetails/Period/@startDate != ''">
                        <xsl:call-template name="createDTM">
                           <xsl:with-param name="D374_Qual">050</xsl:with-param>
                           <xsl:with-param name="cXMLDate">
                              <xsl:value-of select="TimeSeriesDetails/Period/@startDate"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="(TimeSeriesDetails/IdReference/@domain = ('shipNotice', 'consignmentTrackingID', 'supplierReference')) or (TimeSeriesDetails/Extrinsic/@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode'))">
                        <xsl:element name="S_LS">
                           <xsl:element name="D_447">REF</xsl:element>
                        </xsl:element>
                        <xsl:for-each select="TimeSeriesDetails/IdReference[@domain = ('shipNotice','consignmentTrackingID', 'supplierReference')][normalize-space(@identifier)!='']">
                           <xsl:element name="G_REF">
                              <xsl:element name="S_REF">
                                 <xsl:element name="D_128">
                                    <xsl:choose>
                                       <xsl:when test="@domain = 'shipNotice'">PK</xsl:when>
                                       <xsl:when test="@domain = 'consignmentTrackingID'">CR</xsl:when>
                                       <xsl:when test="@domain = 'supplierReference'">D2</xsl:when>
                                    </xsl:choose>
                                 </xsl:element>
                                 <xsl:element name="D_127">
                                    <xsl:value-of select="normalize-space(@identifier)"/>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:element>
                        </xsl:for-each>
                        <xsl:for-each select="TimeSeriesDetails/Extrinsic[@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode')][normalize-space(.) != '']">
                           <xsl:element name="G_REF">
                              <xsl:element name="S_REF">
                                 <xsl:element name="D_128">
                                    <xsl:choose>
                                       <xsl:when test="@name = 'orderNo'">PO</xsl:when>
                                       <xsl:when test="@name = 'consignmentClassificationCode'">CK</xsl:when>
                                       <xsl:when test="@name = 'backoutProcedureCode'">E6</xsl:when>
                                    </xsl:choose>
                                 </xsl:element>
                                 <xsl:element name="D_127">
                                    <xsl:choose>
                                       <xsl:when test="@name = 'orderNo' and exists(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])">
                                          <xsl:value-of select="concat(normalize-space(.), '-', normalize-space(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer']))"/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:value-of select="normalize-space(.)"/>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:element>
                        </xsl:for-each>
                        <xsl:element name="S_LE">
                           <xsl:element name="D_447">REF</xsl:element>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="G_QTY">
                  <xsl:variable name="UOM" select="(G_QTY/S_QTY/C_C001/D_355)[1]"/>
                  <xsl:element name="S_QTY">
                     <xsl:element name="D_673">87</xsl:element>
                     <xsl:element name="D_380">0</xsl:element>
                     <xsl:element name="C_C001">
                        <xsl:element name="D_355">
                           <xsl:value-of select="$UOM"/>
                        </xsl:element>
                        <xsl:element name="D_1018">3</xsl:element>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="G_N1"/>
      </xsl:element>
      <!--when no more LINs for this Buyer Part, map the unlinked PTSeries-->
      <xsl:if test="$BuyerPartlinPosition=0">
         <!--Unlinked PTSeries sent with ConsgMove-->
         <xsl:for-each-group select="//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/PlanningTimeSeries[@type = 'custom'][@customType = 'Consignment101']" group-by="(TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier)">
            <xsl:variable name="PlanningConsignmentID" select="TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier"/>
            <xsl:if test="not(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/ConsignmentMovement/ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier=$PlanningConsignmentID)">
               <xsl:element name="G_LIN">
                  <xsl:copy-of select="//M_846/G_LIN[$linPosition]/S_LIN, //M_846/G_LIN[$linPosition]/S_PID, //M_846/G_LIN[$linPosition]/S_MEA, //M_846/G_LIN[$linPosition]/S_PKG, //M_846/G_LIN[$linPosition]/S_DTM, //M_846/G_LIN[$linPosition]/S_CTP, //M_846/G_LIN[$linPosition]/S_CUR, //M_846/G_LIN[$linPosition]/S_SAC"/>
                  <xsl:copy-of select="//M_846/G_LIN[$linPosition]/S_REF[D_128 != '2I']"/>
                  <xsl:choose>
                     <xsl:when test="//M_846/G_LIN[$linPosition]/G_QTY[S_QTY/D_673 = '33']">
                        <xsl:apply-templates select="//M_846/G_LIN[$linPosition]/G_QTY[S_QTY/D_673 = '33']" mode="replaceQual"/>

                     </xsl:when>
                     <xsl:when test="not(//M_846/G_LIN[$linPosition]/G_QTY[S_QTY/D_673 = '33'])">
                        <xsl:variable name="UOM" select="(//M_846/G_LIN[$linPosition]/G_QTY/S_QTY/C_C001/D_355)[1]"/>
                        <xsl:element name="G_QTY">
                           <xsl:element name="S_QTY">
                              <xsl:element name="D_673">17</xsl:element>
                              <xsl:element name="D_380">0</xsl:element>
                              <xsl:element name="C_C001">
                                 <xsl:element name="D_355">
                                    <xsl:value-of select="$UOM"/>
                                 </xsl:element>
                                 <xsl:element name="D_1018">2</xsl:element>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>

                     </xsl:when>
                  </xsl:choose>
                  <xsl:element name="G_QTY">
                     <xsl:variable name="UOM" select="(//M_846/G_LIN[$linPosition]/G_QTY/S_QTY/C_C001/D_355)[1]"/>

                     <xsl:element name="S_QTY">
                        <xsl:element name="D_673">V3</xsl:element>
                        <xsl:element name="D_380">0</xsl:element>
                        <xsl:element name="C_C001">
                           <xsl:element name="D_355">
                              <xsl:value-of select="$UOM"/>
                           </xsl:element>
                           <xsl:element name="D_1018">3</xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:element>
                  <xsl:for-each select="current-group()">
                     <xsl:element name="G_QTY">
                        <xsl:element name="S_QTY">
                           <xsl:element name="D_673">87</xsl:element>
                           <xsl:element name="D_380">
                              <xsl:call-template name="formatQty">
                                 <xsl:with-param name="qty" select="TimeSeriesDetails/TimeSeriesQuantity/@quantity"/>
                              </xsl:call-template>
                           </xsl:element>
                           <xsl:variable name="uomcode" select="TimeSeriesDetails/TimeSeriesQuantity/UnitOfMeasure"/>
                           <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
                              <xsl:element name="C_C001">
                                 <xsl:element name="D_355">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
                                 </xsl:element>
                                 <xsl:element name="D_1018">3</xsl:element>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                        <xsl:if test="TimeSeriesDetails/Period/@startDate != ''">
                           <xsl:call-template name="createDTM">
                              <xsl:with-param name="D374_Qual">050</xsl:with-param>
                              <xsl:with-param name="cXMLDate">
                                 <xsl:value-of select="TimeSeriesDetails/Period/@startDate"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="(TimeSeriesDetails/IdReference/@domain = ('shipNotice', 'consignmentTrackingID', 'supplierReference')) or (TimeSeriesDetails/Extrinsic/@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode'))">
                           <xsl:element name="S_LS">
                              <xsl:element name="D_447">REF</xsl:element>
                           </xsl:element>
                           <xsl:for-each select="TimeSeriesDetails/IdReference[@domain = ('shipNotice', 'consignmentTrackingID', 'supplierReference')][normalize-space(@identifier)!='']">
                              <xsl:element name="G_REF">
                                 <xsl:element name="S_REF">
                                    <xsl:element name="D_128">
                                       <xsl:choose>
                                          <xsl:when test="@domain = 'shipNotice'">PK</xsl:when>
                                          <xsl:when test="@domain = 'consignmentTrackingID'">CR</xsl:when>
                                          <xsl:when test="@domain = 'supplierReference'">D2</xsl:when>
                                       </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="D_127">
                                       <xsl:value-of select="@identifier"/>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:for-each>
                           <xsl:for-each select="TimeSeriesDetails/Extrinsic[@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode')][normalize-space(.) != '']">
                              <xsl:element name="G_REF">
                                 <xsl:element name="S_REF">
                                    <xsl:element name="D_128">
                                       <xsl:choose>
                                          <xsl:when test="@name = 'orderNo'">PO</xsl:when>
                                          <xsl:when test="@name = 'consignmentClassificationCode'">CK</xsl:when>
                                          <xsl:when test="@name = 'backoutProcedureCode'">E6</xsl:when>
                                       </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="D_127">
                                       <xsl:choose>
                                          <xsl:when test="@name = 'orderNo' and exists(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])">
                                             <xsl:value-of select="concat(normalize-space(.), '-', normalize-space(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer']))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="normalize-space(.)"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:for-each>
                           <xsl:element name="S_LE">
                              <xsl:element name="D_447">REF</xsl:element>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:for-each>
                  <xsl:copy-of select="//M_846/G_LIN[$linPosition]/G_N1 "/>
               </xsl:element>
            </xsl:if>
         </xsl:for-each-group>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//M_846/G_LIN[G_QTY[S_QTY/D_673='33']][not(exists(G_QTY[S_QTY/D_673='V3']))]">
      <!--buyer part+/- ConsignTrack ID makes a LIN unique-->
      <xsl:variable name="buyerPart" select="S_LIN/child::*[text() = 'BP' and starts-with(name(), 'D_235')]/following-sibling::*[1][starts-with(name(), 'D_234')]"/>
      <!--get the last LIN for the current Buyer Part-->
      <xsl:variable name="BuyerPartlinPosition" select="count(following-sibling::G_LIN[S_LIN/child::*=$buyerPart])"/>
      <!--get the current LIN position-->
      <xsl:variable name="linPosition" select="count(preceding-sibling::G_LIN)+1"/>
      <xsl:variable name="PTSeries" select="(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/PlanningTimeSeries[@type='custom'][@customType='Consignment101']/TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier)[1]"/>
      <xsl:element name="G_LIN">
         <xsl:copy-of select="S_LIN, S_PID, S_MEA, S_PKG, S_DTM, S_CTP, S_CUR, S_SAC, S_REF"/>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'batchNo']) != ''">
            <S_REF>
               <D_128>BT</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'batchNo'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'vessel']) != ''">
            <S_REF>
               <D_128>LS</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'vessel'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'supplementNo']) != ''">
            <S_REF>
               <D_128>CI</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'supplementNo'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'orderNo']) != ''">
            <S_REF>
               <D_128>OQ</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'orderNo'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'purchaseOrderLineItemIDBuyer']) != ''">
            <S_REF>
               <D_128>BV</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:if test="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'version']) != ''">
            <S_REF>
               <D_128>D2</D_128>
               <D_127>
                  <xsl:value-of select="normalize-space(//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/Extrinsic[@name = 'version'])"/>
               </D_127>
            </S_REF>
         </xsl:if>
         <xsl:copy-of select="S_PER, S_SDQ, S_MAN, S_UIT, S_CS, S_DD, S_G53, S_PCT, S_LDT, G_LM, G_SLN"/>
         <!-- Only ConsgInv present , no ConsgMove-->
         <xsl:if test="not(G_QTY[S_QTY/D_673 = 'V3']) and G_QTY[S_QTY/D_673 = '33']">
            <xsl:variable name="UOM" select="(G_QTY/S_QTY/C_C001/D_355)[1]"/>
            <xsl:apply-templates select="G_QTY[S_QTY/D_673 = '33']" mode="replaceQual"/>
            <xsl:element name="G_QTY">
               <xsl:element name="S_QTY">
                  <xsl:element name="D_673">V3</xsl:element>
                  <xsl:element name="D_380">0</xsl:element>
                  <xsl:element name="C_C001">
                     <xsl:element name="D_355">
                        <xsl:value-of select="$UOM"/>
                     </xsl:element>
                     <xsl:element name="D_1018">3</xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$PTSeries">
               <xsl:for-each-group select="//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/PlanningTimeSeries[@type = 'custom'][@customType = 'Consignment101'][not(./following-sibling::*[self::ConsignmentMovement]) and not(./preceding-sibling::*[self::ConsignmentMovement])]" group-by="(TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier)">
                  <xsl:if test="current-grouping-key()=$PTSeries">
                     <xsl:for-each select="current-group()">
                        <xsl:element name="G_QTY">
                           <xsl:element name="S_QTY">
                              <xsl:element name="D_673">87</xsl:element>
                              <xsl:element name="D_380">
                                 <xsl:call-template name="formatQty">
                                    <xsl:with-param name="qty" select="TimeSeriesDetails/TimeSeriesQuantity/@quantity"/>
                                 </xsl:call-template>
                              </xsl:element>
                              <xsl:variable name="uomcode" select="TimeSeriesDetails/TimeSeriesQuantity/UnitOfMeasure"/>
                              <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
                                 <xsl:element name="C_C001">
                                    <xsl:element name="D_355">
                                       <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
                                    </xsl:element>
                                    <xsl:element name="D_1018">3</xsl:element>
                                 </xsl:element>
                              </xsl:if>
                           </xsl:element>
                           <xsl:if test="TimeSeriesDetails/Period/@startDate != ''">
                              <xsl:call-template name="createDTM">
                                 <xsl:with-param name="D374_Qual">050</xsl:with-param>
                                 <xsl:with-param name="cXMLDate">
                                    <xsl:value-of select="TimeSeriesDetails/Period/@startDate"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:if>
                           <xsl:if test="(TimeSeriesDetails/IdReference/@domain = ('shipNotice', 'consignmentTrackingID', 'supplierReference')) or (TimeSeriesDetails/Extrinsic/@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode'))">
                              <xsl:element name="S_LS">
                                 <xsl:element name="D_447">REF</xsl:element>
                              </xsl:element>
                              <xsl:for-each select="TimeSeriesDetails/IdReference[@domain = ('shipNotice', 'consignmentTrackingID', 'supplierReference')][normalize-space(@identifier)!='']">
                                 <xsl:element name="G_REF">
                                    <xsl:element name="S_REF">
                                       <xsl:element name="D_128">
                                          <xsl:choose>
                                             <xsl:when test="@domain = 'shipNotice'">PK</xsl:when>
                                             <xsl:when test="@domain = 'consignmentTrackingID'">CR</xsl:when>
                                             <xsl:when test="@domain = 'supplierReference'">D2</xsl:when>
                                          </xsl:choose>
                                       </xsl:element>
                                       <xsl:element name="D_127">
                                          <xsl:value-of select="normalize-space(@identifier)"/>
                                       </xsl:element>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:for-each>
                              <xsl:for-each select="TimeSeriesDetails/Extrinsic[@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode')][normalize-space(.) != '']">
                                 <xsl:element name="G_REF">
                                    <xsl:element name="S_REF">
                                       <xsl:element name="D_128">
                                          <xsl:choose>
                                             <xsl:when test="@name = 'orderNo'">PO</xsl:when>
                                             <xsl:when test="@name = 'consignmentClassificationCode'">CK</xsl:when>
                                             <xsl:when test="@name = 'backoutProcedureCode'">E6</xsl:when>
                                          </xsl:choose>
                                       </xsl:element>
                                       <xsl:element name="D_127">
                                          <xsl:choose>
                                             <xsl:when test="@name = 'orderNo' and exists(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])">
                                                <xsl:value-of select="concat(., '-', ../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])"/>
                                             </xsl:when>
                                             <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                             </xsl:otherwise>
                                          </xsl:choose>
                                       </xsl:element>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:for-each>
                              <xsl:element name="S_LE">
                                 <xsl:element name="D_447">REF</xsl:element>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:if>
               </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="G_QTY">
                  <xsl:variable name="UOM" select="(G_QTY/S_QTY/C_C001/D_355)[1]"/>
                  <xsl:element name="S_QTY">
                     <xsl:element name="D_673">87</xsl:element>
                     <xsl:element name="D_380">0</xsl:element>
                     <xsl:element name="C_C001">
                        <xsl:element name="D_355">
                           <xsl:value-of select="$UOM"/>
                        </xsl:element>
                        <xsl:element name="D_1018">3</xsl:element>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:copy-of select="G_N1"/>
      </xsl:element>
      <!--when no more LINs for this Buyer Part, map the unlinked PTSeries-->
      <xsl:if test="$BuyerPartlinPosition=0">
         <!--Unlinked PTSeries sent with ConsgInv and no ConsgMove-->
         <xsl:for-each-group select="//ProductActivityMessage/ProductActivityDetails[ItemID/BuyerPartID=$buyerPart]/PlanningTimeSeries[@type = 'custom'][@customType = 'Consignment101'][not(./following-sibling::*[self::ConsignmentMovement]) and not(./preceding-sibling::*[self::ConsignmentMovement])]" group-by="(TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier)">
            <xsl:if test="current-grouping-key()!=$PTSeries">
               <xsl:element name="G_LIN">
                  <xsl:copy-of select="//M_846/G_LIN[$linPosition]/S_LIN, //M_846/G_LIN[$linPosition]/S_PID, //M_846/G_LIN[$linPosition]/S_MEA, //M_846/G_LIN[$linPosition]/S_PKG, //M_846/G_LIN[$linPosition]/S_DTM, //M_846/G_LIN[$linPosition]/S_CTP, //M_846/G_LIN[$linPosition]/S_CUR, //M_846/G_LIN[$linPosition]/S_SAC"/>
                  <xsl:copy-of select="//M_846/G_LIN[$linPosition]/S_REF"/>
                  <xsl:if test="not(//M_846/G_LIN[$linPosition]/G_QTY[S_QTY/D_673 = 'V3']) and //M_846/G_LIN[$linPosition]/G_QTY[S_QTY/D_673 = '33']">
                     <xsl:apply-templates select="//M_846/G_LIN[$linPosition]/G_QTY[S_QTY/D_673 = '33']" mode="replaceQual"/>
                     <xsl:variable name="UOM" select="(//M_846/G_LIN[$linPosition]/G_QTY/S_QTY/C_C001/D_355)[1]"/>
                     <xsl:element name="G_QTY">
                        <xsl:element name="S_QTY">
                           <xsl:element name="D_673">V3</xsl:element>
                           <xsl:element name="D_380">0</xsl:element>
                           <xsl:element name="C_C001">
                              <xsl:element name="D_355">
                                 <xsl:value-of select="$UOM"/>
                              </xsl:element>
                              <xsl:element name="D_1018">3</xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
                  <xsl:for-each select="current-group()">
                     <xsl:element name="G_QTY">
                        <xsl:element name="S_QTY">
                           <xsl:element name="D_673">87</xsl:element>
                           <xsl:element name="D_380">
                              <xsl:call-template name="formatQty">
                                 <xsl:with-param name="qty" select="TimeSeriesDetails/TimeSeriesQuantity/@quantity"/>
                              </xsl:call-template>
                           </xsl:element>
                           <xsl:variable name="uomcode" select="TimeSeriesDetails/TimeSeriesQuantity/UnitOfMeasure"/>
                           <xsl:if test="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code != ''">
                              <xsl:element name="C_C001">
                                 <xsl:element name="D_355">
                                    <xsl:value-of select="$Lookup/Lookups/UOMCodes/UOMCode[CXMLCode = $uomcode]/X12Code"/>
                                 </xsl:element>
                                 <xsl:element name="D_1018">3</xsl:element>
                              </xsl:element>
                           </xsl:if>
                        </xsl:element>
                        <xsl:if test="TimeSeriesDetails/Period/@startDate != ''">
                           <xsl:call-template name="createDTM">
                              <xsl:with-param name="D374_Qual">050</xsl:with-param>
                              <xsl:with-param name="cXMLDate">
                                 <xsl:value-of select="TimeSeriesDetails/Period/@startDate"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="(TimeSeriesDetails/IdReference/@domain = ('shipNotice', 'consignmentTrackingID', 'supplierReference')) or (TimeSeriesDetails/Extrinsic/@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode'))">
                           <xsl:element name="S_LS">
                              <xsl:element name="D_447">REF</xsl:element>
                           </xsl:element>
                           <xsl:for-each select="TimeSeriesDetails/IdReference[@domain = ('shipNotice', 'consignmentTrackingID', 'supplierReference')][normalize-space(@identifier)!='']">
                              <xsl:element name="G_REF">
                                 <xsl:element name="S_REF">
                                    <xsl:element name="D_128">
                                       <xsl:choose>
                                          <xsl:when test="@domain = 'shipNotice'">PK</xsl:when>
                                          <xsl:when test="@domain = 'consignmentTrackingID'">CR</xsl:when>
                                          <xsl:when test="@domain = 'supplierReference'">D2</xsl:when>
                                       </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="D_127">
                                       <xsl:value-of select="@identifier"/>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:for-each>
                           <xsl:for-each select="TimeSeriesDetails/Extrinsic[@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode')][normalize-space(.) != '']">
                              <xsl:element name="G_REF">
                                 <xsl:element name="S_REF">
                                    <xsl:element name="D_128">
                                       <xsl:choose>
                                          <xsl:when test="@name = 'orderNo'">PO</xsl:when>
                                          <xsl:when test="@name = 'consignmentClassificationCode'">CK</xsl:when>
                                          <xsl:when test="@name = 'backoutProcedureCode'">E6</xsl:when>
                                       </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="D_127">
                                       <xsl:choose>
                                          <xsl:when test="@name = 'orderNo' and exists(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])">
                                             <xsl:value-of select="concat(normalize-space(.), '-', normalize-space(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer']))"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:value-of select="normalize-space(.)"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:for-each>
                           <xsl:element name="S_LE">
                              <xsl:element name="D_447">REF</xsl:element>
                           </xsl:element>
                        </xsl:if>
                     </xsl:element>
                  </xsl:for-each>
                  <xsl:copy-of select="//M_846/G_LIN[$linPosition]/G_N1 "/>
               </xsl:element>
            </xsl:if>
         </xsl:for-each-group>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//M_846/S_CTT">
      <S_CTT>
         <xsl:variable name="PT_ConsignInvCount" select="count(distinct-values(//ProductActivityMessage/ProductActivityDetails[exists(ConsignmentInventory)]/PlanningTimeSeries[@type='custom'][@customType='Consignment101'][not(./following-sibling::*[self::ConsignmentMovement]) and not(./preceding-sibling::*[self::ConsignmentMovement])]/TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier))"/>
         <xsl:variable name="ConsignInvCount" select="count(//ProductActivityMessage/ProductActivityDetails[not(exists(PlanningTimeSeries))][not(exists(ConsignmentMovement))]/ConsignmentInventory)"/>
         <xsl:variable name="ConsignMvCount" select="count(distinct-values(//ProductActivityMessage/ProductActivityDetails/ConsignmentMovement/ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier))"/>
         <xsl:variable name="PT_ConsignMvCount" select="count(distinct-values((//ProductActivityMessage/ProductActivityDetails[exists(ConsignmentMovement)]/PlanningTimeSeries[@type='custom'][@customType='Consignment101'][not(TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier=(./following-sibling::ConsignmentMovement/ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier|./preceding-sibling::ConsignmentMovement/ProductMovementItemIDInfo/IdReference[@domain='consignmentTrackingID']/@identifier))]/TimeSeriesDetails/IdReference[@domain='consignmentTrackingID']/@identifier)))"/>

         <xsl:element name="D_354">
            <xsl:value-of select="$ConsignMvCount+$PT_ConsignMvCount+$ConsignInvCount+$PT_ConsignInvCount"/>
         </xsl:element>

      </S_CTT>
   </xsl:template>
   <!-- Header Template -->
   <xsl:template name="createHeaderREF">
      <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'packingListNo']) != ''">
         <S_REF>
            <D_128>PK</D_128>
            <D_127>
               <xsl:value-of select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'packingListNo'])"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'sirenNo']) != ''">
         <S_REF>
            <D_128>VR</D_128>
            <D_127>
               <xsl:value-of select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'sirenNo'])"/>
            </D_127>
         </S_REF>
      </xsl:if>
      <xsl:if test="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'siteSpecificProceduresTermsConds']) != ''">
         <S_REF>
            <D_128>ZA</D_128>
            <D_127>
               <xsl:value-of select="normalize-space(//ProductActivityMessage/Extrinsic[@name = 'siteSpecificProceduresTermsConds'])"/>
            </D_127>
         </S_REF>
      </xsl:if>
   </xsl:template>
   <xsl:template match="G_QTY" mode="buildRef">
      <xsl:param name="conMove"/>
      <xsl:param name="position"/>
      <xsl:element name="G_QTY">
         <xsl:copy-of select="S_QTY, S_UIT, S_MEA, S_LDT, S_DTM, G_SCH, G_LM, S_LS, G_REF[S_REF/D_128!='2I']"/>
         <xsl:if test="normalize-space(($conMove[$position]/ProductMovementItemIDInfo/IdReference[@domain = 'consignmentTrackingID']/@identifier)[1]) != ''">
            <xsl:element name="G_REF">
               <xsl:element name="S_REF">
                  <xsl:element name="D_128">CR</xsl:element>
                  <xsl:element name="D_127">
                     <xsl:value-of select="normalize-space(($conMove[$position]/ProductMovementItemIDInfo/IdReference[@domain = 'consignmentTrackingID']/@identifier)[1])"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space($conMove[$position]/ProductMovementItemIDInfo/IdReference[@domain = 'supplierReference']/@identifier) != ''">
            <xsl:element name="G_REF">
               <xsl:element name="S_REF">
                  <xsl:element name="D_128">D2</xsl:element>
                  <xsl:element name="D_127">
                     <xsl:value-of select="normalize-space($conMove[$position]/ProductMovementItemIDInfo/IdReference[@domain = 'supplierReference']/@identifier)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:if test="normalize-space($conMove[$position]/ReferenceDocumentInfo/DocumentInfo[@documentType = 'ShipNotice']/@documentID)!= ''">
            <xsl:element name="G_REF">
               <xsl:element name="S_REF">
                  <xsl:element name="D_128">PK</xsl:element>
                  <xsl:element name="D_127">
                     <xsl:value-of select="normalize-space($conMove[$position]/ReferenceDocumentInfo/DocumentInfo[@documentType = 'ShipNotice']/@documentID)"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:for-each select="$conMove[$position]/Extrinsic[@name = ('orderNo', 'consignmentClassificationCode', 'backoutProcedureCode')][normalize-space(.) != '']">
            <xsl:element name="G_REF">
               <xsl:element name="S_REF">
                  <xsl:element name="D_128">
                     <xsl:choose>
                        <xsl:when test="@name = 'orderNo'">PO</xsl:when>
                        <xsl:when test="@name = 'consignmentClassificationCode'">CK</xsl:when>
                        <xsl:when test="@name = 'backoutProcedureCode'">E6</xsl:when>
                     </xsl:choose>
                  </xsl:element>
                  <xsl:element name="D_127">
                     <xsl:choose>
                        <xsl:when test="@name = 'orderNo' and exists(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer'])">
                           <xsl:value-of select="concat(normalize-space(.), '-', normalize-space(../Extrinsic[@name = 'purchaseOrderLineItemIDBuyer']))"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="normalize-space(.)"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:for-each>
         <xsl:copy-of select="S_LE"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="S_REF" mode="replaceQual">
      <S_REF>
         <D_128>CR</D_128>
         <D_127>
            <xsl:value-of select="D_127"/>
         </D_127>
      </S_REF>
   </xsl:template>
   <xsl:template match="G_QTY" mode="replaceQual">
      <xsl:element name="G_QTY">
         <xsl:element name="S_QTY">
            <xsl:element name="D_673">17</xsl:element>
            <xsl:apply-templates select="S_QTY/*[not(self::D_673)]"/>
         </xsl:element>
         <xsl:apply-templates select="*[not(self::S_QTY)]"/>
      </xsl:element>
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
