<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">

   <xsl:template name="createItemParts">
      <!-- this applies to PO/CO where not only supplier / buyer partID are considered, but also manufacturer partID -->
      <xsl:param name="SupplierPartID"/>
      <xsl:param name="SupplierPartAuxiliaryID"/>
      <xsl:param name="BuyerPartID"/>
      <xsl:param name="ManufacturerPartID"/>
      <xsl:param name="IdReference"/>
      <xsl:param name="Classification"/>
      <xsl:param name="IdReference-UPCUniversalProductCode"/>
      <xsl:param name="IdReference-europeanWasteCatalogID"/>
      <xsl:variable name="partsList">
         <PartsList>
            
            <xsl:if test="normalize-space($SupplierPartID) != ''">
               <Part>
                  <Qualifier>VN</Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($SupplierPartID), 1, 35)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="normalize-space($Classification) != ''">
               <Part>
                  <Qualifier>CC</Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($Classification), 1, 35)"/>
                  </Value>
               </Part>
            </xsl:if><xsl:if test="normalize-space($IdReference-UPCUniversalProductCode) != ''">
               <Part>
                  <Qualifier>UP</Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($IdReference-UPCUniversalProductCode), 1, 35)"/>
                  </Value>
               </Part>
            </xsl:if><xsl:if test="normalize-space($IdReference-europeanWasteCatalogID) != ''">
               <Part>
                  <Qualifier>ZZZ</Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($IdReference-europeanWasteCatalogID), 1, 35)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="normalize-space($BuyerPartID) != ''">
               <Part>
                  <Qualifier>BP</Qualifier>
                  <Value>
                     <xsl:value-of select="substring(normalize-space($BuyerPartID), 1, 35)"/>
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if test="normalize-space($SupplierPartAuxiliaryID) != ''">
               <Part>
                  <Qualifier>VS</Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($SupplierPartAuxiliaryID), 1, 35)"
                     />
                  </Value>
               </Part>
            </xsl:if>
            
            <xsl:if test="normalize-space($ManufacturerPartID) != ''">
               <Part>
                  <Qualifier>MF</Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($ManufacturerPartID), 1, 35)"
                     />
                  </Value>
               </Part>
            </xsl:if>
            <xsl:if
               test="normalize-space($IdReference)">
               <Part>
                  <Qualifier>EN</Qualifier>
                  <Value>
                     <xsl:value-of
                        select="substring(normalize-space($IdReference), 1, 35)"
                     />
                  </Value>
               </Part>
            </xsl:if>
         </PartsList>
      </xsl:variable>
      <xsl:for-each select="$partsList/PartsList/Part">
         
         <xsl:choose>
            <xsl:when test="position() = 1">					
               <C_C212>					
                  <xsl:element name="D_7140">
                     <xsl:value-of select="./Value"/>
                  </xsl:element>
                  <xsl:element name="D_7143">
                     <xsl:value-of select="./Qualifier"/>
                  </xsl:element>						
               </C_C212>
               <!--<xsl:element name="D_235">
						<xsl:value-of select="./Qualifier"/>
					</xsl:element>
					<xsl:element name="D_234">
						<xsl:value-of select="./Value"/>
					</xsl:element>-->
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="{concat('C_C212', '_', position())}">
                  <xsl:element name="D_7140">
                     <xsl:value-of select="./Value"/>
                  </xsl:element>
                  <xsl:element name="D_7143">
                     <xsl:value-of select="./Qualifier"/>
                  </xsl:element>	
               </xsl:element>
               <!--<xsl:element name="{concat('D_235', '_', position())}">
						<xsl:value-of select="./Qualifier"/>
					</xsl:element>
					<xsl:element name="{concat('D_234', '_', position())}">
						<xsl:value-of select="./Value"/>
					</xsl:element>-->
            </xsl:otherwise>
         </xsl:choose>
         
      </xsl:for-each>
      <!--xsl:if test="normalize-space($itemID/SupplierPartID)!=''">			<D_235>VP</D_235>			<D_234>				<xsl:value-of select="substring(normalize-space($itemID/SupplierPartID),1,48)"/>			</D_234>		</xsl:if>		<xsl:if test="normalize-space($itemID/BuyerPartID)!=''">			<D_235_2>BP</D_235_2>			<D_234_2>				<xsl:value-of select="substring(normalize-space($itemID/BuyerPartID),1,48)"/>			</D_234_2>		</xsl:if>		<xsl:if test="normalize-space($itemID/SupplierPartAuxiliaryID)!=''">			<D_235_3>VS</D_235_3>			<D_234_3>				<xsl:value-of select="substring(normalize-space($itemID/SupplierPartAuxiliaryID),1,48)"/>			</D_234_3>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/ManufacturerPartID)!=''">			<D_235_4>MG</D_235_4>			<D_234_4>				<xsl:value-of select="substring(normalize-space($itemDetail/ManufacturerPartID),1,48)"/>			</D_234_4>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/ManufacturerName)!=''">			<D_235_5>MF</D_235_5>			<D_234_5>				<xsl:value-of select="substring(normalize-space($itemDetail/ManufacturerName),1,48)"/>			</D_234_5>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/Classification)!=''">			<D_235_6>C3</D_235_6>			<D_234_6>				<xsl:value-of select="substring(normalize-space($itemDetail/Classification[1]),1,48)"/>			</D_234_6>		</xsl:if>		<xsl:if test="normalize-space($itemDetail/ItemDetailIndustry/ItemDetailRetail/EANID)!=''">			<D_235_7>EN</D_235_7>			<D_234_7>				<xsl:value-of select="substring(normalize-space($itemDetail/ItemDetailIndustry/ItemDetailRetail/EANID),1,48)"/>			</D_234_7>		</xsl:if>		<xsl:if test="normalize-space($itemID/IdReference[@domain='custSKU']/@identifier)!=''">			<D_235_8>SK</D_235_8>			<D_234_8>				<xsl:value-of select="substring(normalize-space($itemID/IdReference[@domain='custSKU']/@identifier),1,48)"/>			</D_234_8>		</xsl:if-->
   </xsl:template>

   <xsl:template name="createMOA">
      <xsl:param name="grpNum"/>
      <xsl:param name="qual"/>
      <xsl:param name="money"/>
      <xsl:param name="createAlternate"/>
      <xsl:param name="hideAmt"/>
      <xsl:choose>
         <xsl:when test="$grpNum">
            <xsl:element name="{$grpNum}">
               <S_MOA>
                  <C_C516>
                     <D_5025>
                        <xsl:value-of select="normalize-space($qual)"/>
                     </D_5025>
                     <D_5004>
                        <xsl:choose>
                           <xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="formatDecimal">
                                 <xsl:with-param name="amount" select="$money/Money"/>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
                     </D_5004>
                     <xsl:if test="normalize-space($money/Money/@currency) != ''">
                        <D_6345>
                           <xsl:value-of select="normalize-space($money/Money/@currency)"/>
                        </D_6345>
                        <D_6343>9</D_6343>
                     </xsl:if>
                  </C_C516>
               </S_MOA>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <S_MOA>
               <C_C516>
                  <D_5025>
                     <xsl:value-of select="normalize-space($qual)"/>
                  </D_5025>
                  <D_5004>
                     <xsl:choose>
                        <xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
                        <xsl:otherwise>
                           <xsl:call-template name="formatDecimal">
                              <xsl:with-param name="amount" select="$money/Money"/>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </D_5004>
                  <xsl:if test="normalize-space($money/Money/@currency) != ''">
                     <D_6345>
                        <xsl:value-of select="normalize-space($money/Money/@currency)"/>
                     </D_6345>
                     <D_6343>9</D_6343>
                  </xsl:if>
               </C_C516>
            </S_MOA>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$createAlternate = 'yes' and normalize-space($money/Money/@alternateAmount) != '' and not(empty($money/Money/@alternateAmount))">
         <xsl:choose>
            <xsl:when test="$grpNum">
               <xsl:element name="{$grpNum}">
                  <S_MOA>
                     <C_C516>
                        <D_5025>
                           <xsl:value-of select="normalize-space($qual)"/>
                        </D_5025>
                        <D_5004>
                           <xsl:choose>
                              <xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
                              <xsl:otherwise>
                                 <xsl:call-template name="formatDecimal">
                                    <xsl:with-param name="amount" select="$money/Money/@alternateAmount"/>
                                 </xsl:call-template>
                              </xsl:otherwise>
                           </xsl:choose>
                        </D_5004>
                        <xsl:if test="normalize-space($money/Money/@alternateCurrency) != ''">
                           <D_6345>
                              <xsl:value-of select="normalize-space($money/Money/@alternateCurrency)"/>
                           </D_6345>
                           <D_6343>7</D_6343>
                        </xsl:if>
                     </C_C516>
                  </S_MOA>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <S_MOA>
                  <C_C516>
                     <D_5025>
                        <xsl:value-of select="normalize-space($qual)"/>
                     </D_5025>
                     <D_5004>
                        <xsl:choose>
                           <xsl:when test="$hideAmt = 'yes'">0.00</xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="formatDecimal">
                                 <xsl:with-param name="amount" select="$money/Money/@alternateAmount"/>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
                     </D_5004>
                     <xsl:if test="normalize-space($money/Money/@alternateCurrency) != ''">
                        <D_6345>
                           <xsl:value-of select="normalize-space($money/Money/@alternateCurrency)"/>
                        </D_6345>
                        <D_6343>7</D_6343>
                     </xsl:if>
                  </C_C516>
               </S_MOA>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   <xsl:template name="mapPayloadID">
      <xsl:param name="payloadID"/>
      <xsl:param name="payloadQUAL"/>
      <xsl:if test="string-length($payloadID) &gt; 0">
         <G_SG1>
            <S_RFF>
               <C_C506>
                  <D_1153>
                     <xsl:value-of select="$payloadQUAL"/>
                  </D_1153>
                  <D_1154>
                     <xsl:value-of select="substring($payloadID, 1, 35)"/>
                  </D_1154>
                  <xsl:if test="substring($payloadID, 36) != ''">
                     <D_4000>
                        <xsl:value-of select="substring($payloadID, 36, 35)"/>
                     </D_4000>
                  </xsl:if>
               </C_C506>
            </S_RFF>
         </G_SG1>
      </xsl:if>
      <xsl:if test="substring($payloadID, 71) != ''">
         <xsl:call-template name="mapPayloadID">
            <xsl:with-param name="payloadID" select="normalize-space(substring($payloadID, 71))"/>
            <xsl:with-param name="payloadQUAL" select="$payloadQUAL"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="IMDLoop">
      <xsl:param name="IMDQual"/>
      <xsl:param name="IMDData"/>
      <xsl:param name="langCode"/>
      <xsl:if test="string-length($IMDData) &gt; 0">
         <S_IMD>
            <D_7077>
               <xsl:value-of select="$IMDQual"/>
            </D_7077>
            <C_C273>
               <D_7008>
                  <xsl:value-of select="substring($IMDData, 1, 35)"/>
               </D_7008>
               <xsl:if test="normalize-space(substring($IMDData, 36)) != ''">
                  <D_7008_2>
                     <xsl:value-of select="normalize-space(substring($IMDData, 36, 35))"/>
                  </D_7008_2>
               </xsl:if>
               <D_3453>
                  <xsl:choose>
                     <xsl:when test="$langCode != ''">
                        <xsl:value-of select="upper-case(substring($langCode, 1, 2))"/>
                     </xsl:when>
                     <xsl:otherwise>EN</xsl:otherwise>
                  </xsl:choose>
               </D_3453>
            </C_C273>
         </S_IMD>
      </xsl:if>
      <xsl:if test="substring($IMDData, 71) != ''">
         <xsl:call-template name="IMDLoop">
            <xsl:with-param name="IMDData" select="normalize-space(substring($IMDData, 71))"/>
            <xsl:with-param name="IMDQual" select="$IMDQual"/>
            <xsl:with-param name="langCode" select="$langCode"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template name="FTXLoop">
      <xsl:param name="FTXQual"/>
      <xsl:param name="FTXData"/>
      <xsl:param name="domain"/>
      <xsl:param name="langCode"/>
      <xsl:if test="string-length($FTXData) &gt; 0">
         <xsl:variable name="C108">
            <C_C108>
               <xsl:if test="substring($FTXData, 1, 70) != ''">
                  <xsl:variable name="temp">
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="substring($FTXData, 1, 70)"/>
                     </xsl:call-template>
                  </xsl:variable>
                  <D_4440>
                     <xsl:choose>
                        <xsl:when test="$domain != ''">
                           <xsl:value-of select="$domain"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$temp"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </D_4440>
                  <xsl:variable name="pendingFTX">
                     <xsl:choose>
                        <xsl:when test="$domain != ''">
                           <xsl:value-of select="$FTXData"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="substring($FTXData, string-length($temp) + 1)"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="string-length($pendingFTX) &gt; 0">
                     <xsl:variable name="temp">
                        <xsl:call-template name="rTrim">
                           <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                        </xsl:call-template>
                     </xsl:variable>
                     <D_4440_2>
                        <xsl:value-of select="$temp"/>
                     </D_4440_2>
                     <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                     <xsl:if test="string-length($pendingFTX) &gt; 0">
                        <xsl:variable name="temp">
                           <xsl:call-template name="rTrim">
                              <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                           </xsl:call-template>
                        </xsl:variable>
                        <D_4440_3>
                           <xsl:value-of select="$temp"/>
                        </D_4440_3>
                        <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                        <xsl:if test="string-length($pendingFTX) &gt; 0">
                           <xsl:variable name="temp">
                              <xsl:call-template name="rTrim">
                                 <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                              </xsl:call-template>
                           </xsl:variable>
                           <D_4440_4>
                              <xsl:value-of select="$temp"/>
                           </D_4440_4>
                           <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                           <xsl:if test="string-length($pendingFTX) &gt; 0">
                              <xsl:variable name="temp">
                                 <xsl:call-template name="rTrim">
                                    <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                                 </xsl:call-template>
                              </xsl:variable>
                              <D_4440_5>
                                 <xsl:value-of select="$temp"/>
                              </D_4440_5>
                           </xsl:if>
                        </xsl:if>
                     </xsl:if>
                  </xsl:if>
               </xsl:if>
            </C_C108>
         </xsl:variable>
         <S_FTX>
            <D_4451>
               <xsl:value-of select="$FTXQual"/>
            </D_4451>
            <xsl:copy-of select="$C108"/>
            <D_3453>
               <xsl:choose>
                  <xsl:when test="$langCode != ''">
                     <xsl:value-of select="upper-case(substring($langCode, 1, 2))"/>
                  </xsl:when>
                  <xsl:otherwise>EN</xsl:otherwise>
               </xsl:choose>
            </D_3453>
         </S_FTX>
         <xsl:variable name="ftxLen" select="string-length($C108//D_4440) + string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>
         <xsl:if test="substring($FTXData, $ftxLen + 1) != ''">
            <xsl:call-template name="FTXLoop">
               <xsl:with-param name="FTXData">
                  <xsl:value-of select="substring($FTXData, $ftxLen + 1)"/>
               </xsl:with-param>
               <xsl:with-param name="FTXQual" select="$FTXQual"/>
               <xsl:with-param name="langCode" select="$langCode"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   <xsl:template name="FTXExtrinsic">
      <xsl:param name="FTXName"/>
      <xsl:param name="FTXData"/>
      <xsl:if test="string-length($FTXData) &gt; 0">
         <xsl:variable name="C108">
            <C_C108>
               <D_4440>
                  <xsl:value-of select="substring(normalize-space($FTXName), 1, 70)"/>
               </D_4440>
               <xsl:if test="substring($FTXData, 1, 60) != ''">
                  <xsl:variable name="temp">
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="substring($FTXData, 1, 70)"/>
                     </xsl:call-template>
                  </xsl:variable>
                  <D_4440_2>
                     <xsl:value-of select="$temp"/>
                  </D_4440_2>
                  <xsl:variable name="pendingFTX" select="substring($FTXData, string-length($temp) + 1)"/>
                  <xsl:if test="string-length($pendingFTX) &gt; 0">
                     <xsl:variable name="temp">
                        <xsl:call-template name="rTrim">
                           <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                        </xsl:call-template>
                     </xsl:variable>
                     <D_4440_3>
                        <xsl:value-of select="$temp"/>
                     </D_4440_3>
                     <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                     <xsl:if test="string-length($pendingFTX) &gt; 0">
                        <xsl:variable name="temp">
                           <xsl:call-template name="rTrim">
                              <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                           </xsl:call-template>
                        </xsl:variable>
                        <D_4440_4>
                           <xsl:value-of select="$temp"/>
                        </D_4440_4>
                        <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                        <xsl:if test="string-length($pendingFTX) &gt; 0">
                           <xsl:variable name="temp">
                              <xsl:call-template name="rTrim">
                                 <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                              </xsl:call-template>
                           </xsl:variable>
                           <D_4440_5>
                              <xsl:value-of select="$temp"/>
                           </D_4440_5>
                        </xsl:if>
                     </xsl:if>
                  </xsl:if>
               </xsl:if>
            </C_C108>
         </xsl:variable>
         <S_FTX>
            <D_4451>ZZZ</D_4451>
            <xsl:copy-of select="$C108"/>
         </S_FTX>
         <xsl:variable name="ftxLen" select="string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>
         <xsl:if test="substring($FTXData, $ftxLen + 1) != ''">
            <xsl:call-template name="FTXExtrinsic">
               <xsl:with-param name="FTXName" select="$FTXName"/>
               <xsl:with-param name="FTXData">
                  <xsl:value-of select="substring($FTXData, $ftxLen + 1)"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   <xsl:template name="FTXLoopNoLang">
      <xsl:param name="FTXQual"/>
      <xsl:param name="FTXData"/>
      <xsl:param name="FTXsubQual"/>
      <xsl:if test="string-length($FTXData) &gt; 0">
         <xsl:variable name="C108">
            <C_C108>
               <xsl:if test="substring($FTXData, 1, 70) != ''">
                  <xsl:variable name="temp">
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="substring($FTXData, 1, 70)"/>
                     </xsl:call-template>
                  </xsl:variable>
                  <D_4440>
                     <xsl:value-of select="$temp"/>
                  </D_4440>
                  <xsl:variable name="pendingFTX">
                     <xsl:value-of select="substring($FTXData, string-length($temp) + 1)"/>
                  </xsl:variable>
                  <xsl:if test="string-length($pendingFTX) &gt; 0">
                     <xsl:variable name="temp">
                        <xsl:call-template name="rTrim">
                           <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                        </xsl:call-template>
                     </xsl:variable>
                     <D_4440_2>
                        <xsl:value-of select="$temp"/>
                     </D_4440_2>
                     <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                     <xsl:if test="string-length($pendingFTX) &gt; 0">
                        <xsl:variable name="temp">
                           <xsl:call-template name="rTrim">
                              <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                           </xsl:call-template>
                        </xsl:variable>
                        <D_4440_3>
                           <xsl:value-of select="$temp"/>
                        </D_4440_3>
                        <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                        <xsl:if test="string-length($pendingFTX) &gt; 0">
                           <xsl:variable name="temp">
                              <xsl:call-template name="rTrim">
                                 <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                              </xsl:call-template>
                           </xsl:variable>
                           <D_4440_4>
                              <xsl:value-of select="$temp"/>
                           </D_4440_4>
                           <xsl:variable name="pendingFTX" select="substring($pendingFTX, string-length($temp) + 1)"/>
                           <xsl:if test="string-length($pendingFTX) &gt; 0">
                              <xsl:variable name="temp">
                                 <xsl:call-template name="rTrim">
                                    <xsl:with-param name="inData" select="substring($pendingFTX, 1, 70)"/>
                                 </xsl:call-template>
                              </xsl:variable>
                              <D_4440_5>
                                 <xsl:value-of select="$temp"/>
                              </D_4440_5>
                           </xsl:if>
                        </xsl:if>
                     </xsl:if>
                  </xsl:if>
               </xsl:if>
            </C_C108>
         </xsl:variable>
         <S_FTX>
            <D_4451>
               <xsl:value-of select="$FTXQual"/>
            </D_4451>
            <xsl:if test="$FTXsubQual != ''">
               <C_C107>
                  <D_4441>
                     <xsl:value-of select="$FTXsubQual"/>
                  </D_4441>
               </C_C107>
            </xsl:if>
            <xsl:copy-of select="$C108"/>
         </S_FTX>
         <xsl:variable name="ftxLen" select="string-length($C108//D_4440) + string-length($C108//D_4440_2) + string-length($C108//D_4440_3) + string-length($C108//D_4440_4) + string-length($C108//D_4440_5)"/>
         <xsl:if test="substring($FTXData, $ftxLen + 1) != ''">
            <xsl:call-template name="FTXLoopNoLang">
               <xsl:with-param name="FTXData" select="substring($FTXData, $ftxLen + 1)"/>
               <xsl:with-param name="FTXQual" select="$FTXQual"/>
               <xsl:with-param name="FTXsubQual" select="$FTXsubQual"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   <xsl:template name="rTrim">
      <xsl:param name="inData"/>
      <xsl:choose>
         <xsl:when test="ends-with($inData, ' ')">
            <xsl:call-template name="rTrim">
               <xsl:with-param name="inData" select="substring($inData, 1, string-length($inData) - 1)"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$inData"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="createNAD">
      <xsl:param name="Address"/>
      <xsl:param name="role"/>
      <xsl:param name="isPOUpdate"/>
      <xsl:param name="doctype"></xsl:param>
      <S_NAD>
         <D_3035>
            <xsl:choose>
               <xsl:when test="$role = 'locationTo'">ST</xsl:when>
               <xsl:when test="$role = 'locationFrom'">SU</xsl:when>
               <xsl:when test="$role = 'BuyerPlannerCode'">MI</xsl:when>
               <xsl:otherwise>
                  <xsl:choose>
                     <xsl:when
                        test="$Lookup/Lookups/Roles/Role[CXMLCode = $role]/EDIFACTCode != ''">
                        <xsl:value-of
                           select="($Lookup/Lookups/Roles/Role[CXMLCode = $role]/EDIFACTCode)[1]"
                        />
                     </xsl:when>
                     <xsl:otherwise>ZZZ</xsl:otherwise>
                  </xsl:choose>
               </xsl:otherwise>
            </xsl:choose>
         </D_3035>         
         <xsl:if test="normalize-space($Address/@addressID) != ''">
            <C_C082>
               <D_3039>
                  <xsl:value-of select="substring(normalize-space($Address/@addressID), 1, 35)"/>
               </D_3039>
               <xsl:variable name="addrDomain" select="normalize-space($Address/@addressIDDomain)"/>
               <xsl:if test="$addrDomain != ''">
                  <xsl:choose>
                     <xsl:when test="$Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/EDIFACTCode != ''">
                        <D_3055>
                           <xsl:value-of select="($Lookup/Lookups/AddrDomains/AddrDomain[CXMLCode = $addrDomain]/EDIFACTCode)[1]"/>
                        </D_3055>
                     </xsl:when>
                     <xsl:when test="$role = 'billTo' and $Address/@addressID != ''">
                        <D_3055>91</D_3055>
                     </xsl:when>
                     <xsl:when test="$role = 'shipTo' and $Address/@addressID != ''">
                        <D_3055>92</D_3055>
                     </xsl:when>
                     <xsl:otherwise>
                        <D_3055>92</D_3055>
                     </xsl:otherwise>
                     <!--added this form deflfor-->
                  </xsl:choose>
               </xsl:if>
            </C_C082>
         </xsl:if>
         <xsl:variable name="Name" select="normalize-space($Address/Name)"/>
         <xsl:if test="$Name != ''">
            <C_C058>
               <D_3124>
                  <xsl:call-template name="rTrim">
                     <xsl:with-param name="inData" select="normalize-space(substring($Name, 1, 35))"/>
                  </xsl:call-template>
               </D_3124>
               <xsl:if test="normalize-space(substring($Name, 36, 35)) != ''">
                  <D_3124_2>
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="normalize-space(substring($Name, 36, 35))"/>
                     </xsl:call-template>
                  </D_3124_2>
               </xsl:if>
               <xsl:if test="normalize-space(substring($Name, 71, 35)) != ''">
                  <D_3124_3>
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="normalize-space(substring($Name, 71, 35))"/>
                     </xsl:call-template>
                  </D_3124_3>
               </xsl:if>
               <xsl:if test="normalize-space(substring($Name, 106, 35)) != ''">
                  <D_3124_4>
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="normalize-space(substring($Name, 106, 35))"/>
                     </xsl:call-template>
                  </D_3124_4>
               </xsl:if>
               <xsl:if test="normalize-space(substring($Name, 141, 35)) != ''">
                  <D_3124_5>
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="normalize-space(substring($Name, 141, 35))"/>
                     </xsl:call-template>
                  </D_3124_5>
               </xsl:if>
            </C_C058>
         </xsl:if>
         <xsl:if test="normalize-space($Address/PostalAddress/DeliverTo[normalize-space(text())!=''][1])">
            <C_C080>
               <xsl:for-each select="$Address/PostalAddress/DeliverTo[normalize-space(text())!=''][5 &gt;= position()]">
                  <xsl:variable name="segPosDel">
                     <xsl:choose>
                        <xsl:when test="position() = 1"/>
                        <xsl:otherwise>
                           <xsl:value-of select="concat('_', position())"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:element name="{concat('D_3036', $segPosDel)}">
                     <xsl:call-template name="rTrim">
                        <xsl:with-param name="inData" select="normalize-space(substring(normalize-space(.), 1, 35))"/>
                     </xsl:call-template>
                  </xsl:element>
               </xsl:for-each>
            </C_C080>
         </xsl:if>
         <xsl:if test="$Address/PostalAddress">
            <xsl:if test="normalize-space($Address/PostalAddress/Street[1]) != ''">
               <C_C059>
                  <xsl:for-each select="$Address/PostalAddress/Street[4 &gt;= position()]">
                     <xsl:variable name="segPosAdd">
                        <xsl:choose>
                           <xsl:when test="position() = 1"/>
                           <xsl:otherwise>
                              <xsl:value-of select="concat('_', position())"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:element name="{concat('D_3042', $segPosAdd)}">
                        <xsl:value-of select="normalize-space(substring(normalize-space(.), 1, 35))"/>
                     </xsl:element>
                  </xsl:for-each>
               </C_C059>
            </xsl:if>
            <xsl:if test="normalize-space($Address/PostalAddress/City) != ''">
               <D_3164>
                  <xsl:value-of select="substring(normalize-space($Address/PostalAddress/City), 1, 35)"/>
               </D_3164>
            </xsl:if>
            <xsl:if test="normalize-space($Address/PostalAddress/State) != ''">
               <D_3229>
                  <xsl:value-of select="substring(normalize-space($Address/PostalAddress/State), 1, 9)"/>
               </D_3229>
            </xsl:if>
            <xsl:if test="normalize-space($Address/PostalAddress/PostalCode) != ''">
               <D_3251>
                  <xsl:value-of select="substring(normalize-space($Address/PostalAddress/PostalCode), 1, 9)"/>
               </D_3251>
            </xsl:if>
            <xsl:if test="normalize-space($Address/PostalAddress/Country/@isoCountryCode) != ''">
               <D_3207>
                  <xsl:value-of select="substring(normalize-space($Address/PostalAddress/Country/@isoCountryCode), 1, 3)"/>
               </D_3207>
            </xsl:if>
         </xsl:if>
      </S_NAD>
      <xsl:if test="$doctype != 'deljit' and $doctype != 'delfor'">
         <xsl:if test="$role = 'shipTo'">
            <xsl:for-each select="$Address/following-sibling::IdReference">
               <xsl:variable name="IdRefDomain" select="@domain"/>
               <xsl:variable name="IdRefVal" select="@identifier"/>
               <xsl:variable name="IdRefLookupValue" select="$Lookup/Lookups/LOC_IdReference/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode"/>
               <xsl:if test="$IdRefLookupValue!='' and $IdRefVal!=''">
                     <S_LOC>
                        <D_3227>
                           <xsl:value-of select="$IdRefLookupValue"/>
                        </D_3227>
                        <C_C517>
                           <D_3225>
                              <xsl:value-of select="$IdRefVal"/>
                           </D_3225>
                        </C_C517>                              
                     </S_LOC>
               </xsl:if>
            </xsl:for-each>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$isPOUpdate = 'true'">
               <xsl:for-each select="$Address/IdReference">
                  
                  <xsl:variable name="IdRefDomain" select="@domain"/>
                  <xsl:variable name="IdRefVal" select="@identifier"/>
                     <xsl:choose>
                        <xsl:when test="normalize-space(@identifier) != '' and @domain = 'PartyAdditionalID'">
                           <G_SG4>
                              <S_RFF>
                                 <C_C506>
                                    <D_1153>IT</D_1153>
                                    <D_1154>
                                       <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID']/@identifier), 1, 35)"/>
                                    </D_1154>
                                    <xsl:if test="normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier) != ''">
                                       <D_4000>
                                          <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier), 1, 35)"/>
                                       </D_4000>
                                    </xsl:if>
                                 </C_C506>
                              </S_RFF>
                           </G_SG4>
                        </xsl:when>
                        
                  <xsl:when test="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode!='' and $IdRefVal!=''">
                     <G_SG4>
                        <S_RFF>
                           <C_C506>
                              <D_1153><xsl:value-of select="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode"/></D_1153>
                              <D_1154>
                                 <xsl:value-of select="substring(normalize-space($IdRefVal), 1, 35)"/>
                              </D_1154>
                              
                           </C_C506>
                        </S_RFF>
                     </G_SG4>
                     
                  </xsl:when>
                  
                     </xsl:choose>
               </xsl:for-each>
               <xsl:for-each select="$Address/following-sibling::IdReference">
                  
                  <xsl:variable name="IdRefDomain" select="@domain"/>
                  <xsl:variable name="IdRefVal" select="@identifier"/>
                  <xsl:choose>
                     <xsl:when test="normalize-space(@identifier) != '' and @domain = 'PartyAdditionalID'">
                        <G_SG4>
                           <S_RFF>
                              <C_C506>
                                 <D_1153>IT</D_1153>
                                 <D_1154>
                                    <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID']/@identifier), 1, 35)"/>
                                 </D_1154>
                                 <xsl:if test="normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier) != ''">
                                    <D_4000>
                                       <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier), 1, 35)"/>
                                    </D_4000>
                                 </xsl:if>
                              </C_C506>
                           </S_RFF>
                        </G_SG4>
                     </xsl:when>
                     
                     <xsl:when test="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode!='' and $IdRefVal!=''">
                        <G_SG4>
                           <S_RFF>
                              <C_C506>
                                 <D_1153><xsl:value-of select="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode"/></D_1153>
                                 <D_1154>
                                    <xsl:value-of select="substring(normalize-space($IdRefVal), 1, 35)"/>
                                 </D_1154>
                                 
                              </C_C506>
                           </S_RFF>
                        </G_SG4>
                        
                     </xsl:when>
                     
                  </xsl:choose>
               </xsl:for-each>
               
               <xsl:if test="normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID']) != '' and $Lookup/Lookups/Roles/Role[CXMLCode = $role]/EDIFACTCode = 'BT'">
                  <G_SG4>
                     <S_RFF>
                        <C_C506>
                           <D_1153>VA</D_1153>
                           <D_1154>
                              <xsl:value-of select="substring(normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID']), 1, 35)"/>
                           </D_1154>
                        </C_C506>
                     </S_RFF>
                  </G_SG4>
               </xsl:if>
               <!-- IG-2067 - Ashish Arya - Added code for the supplierVatID -->
               <xsl:if test="normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']) != '' and $Lookup/Lookups/Roles/Role[CXMLCode = $role]/EDIFACTCode = 'SU'">
                  <G_SG4>
                     <S_RFF>
                        <C_C506>
                           <D_1153>VA</D_1153>
                           <D_1154>
                              <xsl:value-of select="substring(normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']), 1, 35)"/>
                           </D_1154>
                        </C_C506>
                     </S_RFF>
                  </G_SG4>
               </xsl:if>
            
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="$Address/IdReference">
                  
                  <xsl:variable name="IdRefDomain" select="@domain"/>
                  <xsl:variable name="IdRefVal" select="@identifier"/>
                  
               <xsl:choose>
                  <xsl:when test="normalize-space(@identifier) != '' and @domain = 'PartyAdditionalID'">
                     <G_SG3>
                        <S_RFF>
                           <C_C506>
                              <D_1153>IT</D_1153>
                              <D_1154>
                                 <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID']/@identifier), 1, 35)"/>
                              </D_1154>
                              <xsl:if test="normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier) != ''">
                                 <D_4000>
                                    <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier), 1, 35)"/>
                                 </D_4000>
                              </xsl:if>
                           </C_C506>
                        </S_RFF>
                     </G_SG3>
                  </xsl:when>
                  
                  <xsl:when test="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode!='' and $IdRefVal!=''">
                     <G_SG3>
                        <S_RFF>
                           <C_C506>
                              <D_1153><xsl:value-of select="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode"/></D_1153>
                              <D_1154>
                                 <xsl:value-of select="substring(normalize-space($IdRefVal), 1, 35)"/>
                              </D_1154>
                              
                           </C_C506>
                        </S_RFF>
                     </G_SG3>
                     
                  </xsl:when>
                  
               </xsl:choose>
               </xsl:for-each>
               <xsl:for-each select="$Address/following-sibling::IdReference">
                  
                  <xsl:variable name="IdRefDomain" select="@domain"/>
                  <xsl:variable name="IdRefVal" select="@identifier"/>
                  
                  <xsl:choose>
                     <xsl:when test="normalize-space(@identifier) != '' and @domain = 'PartyAdditionalID'">
                        <G_SG3>
                           <S_RFF>
                              <C_C506>
                                 <D_1153>IT</D_1153>
                                 <D_1154>
                                    <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID']/@identifier), 1, 35)"/>
                                 </D_1154>
                                 <xsl:if test="normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier) != ''">
                                    <D_4000>
                                       <xsl:value-of select="substring(normalize-space(../../$Address/IdReference[@domain = 'PartyAdditionalID2']/@identifier), 1, 35)"/>
                                    </D_4000>
                                 </xsl:if>
                              </C_C506>
                           </S_RFF>
                        </G_SG3>
                     </xsl:when>
                     
                     <xsl:when test="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode!='' and $IdRefVal!=''">
                        <G_SG3>
                           <S_RFF>
                              <C_C506>
                                 <D_1153><xsl:value-of select="$Lookup/Lookups/IdReferenceDomains/IdReferenceDomain[CXMLCode = $IdRefDomain]/EDIFACTCode"/></D_1153>
                                 <D_1154>
                                    <xsl:value-of select="substring(normalize-space($IdRefVal), 1, 35)"/>
                                 </D_1154>
                                 
                              </C_C506>
                           </S_RFF>
                        </G_SG3>
                        
                     </xsl:when>
                     
                  </xsl:choose>
               </xsl:for-each>
               
               <xsl:if test="normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID']) != '' and $Lookup/Lookups/Roles/Role[CXMLCode = $role]/EDIFACTCode = 'BT'">
                  <G_SG3>
                     <S_RFF>
                        <C_C506>
                           <D_1153>VA</D_1153>
                           <D_1154>
                              <xsl:value-of select="substring(normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'buyerVatID']), 1, 35)"/>
                           </D_1154>
                        </C_C506>
                     </S_RFF>
                  </G_SG3>
               </xsl:if>
               <!-- IG-2067 - Ashish Arya - Added code for the supplierVatID -->
               <xsl:if test="normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']) != '' and $Lookup/Lookups/Roles/Role[CXMLCode = $role]/EDIFACTCode = 'SU'">
                  <G_SG3>
                     <S_RFF>
                        <C_C506>
                           <D_1153>VA</D_1153>
                           <D_1154>
                              <xsl:value-of select="substring(normalize-space($Address/ancestor::OrderRequestHeader/Extrinsic[@name = 'supplierVatID']), 1, 35)"/>
                           </D_1154>
                        </C_C506>
                     </S_RFF>
                  </G_SG3>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   <xsl:template name="formatDate">
      <!-- convert Ariba cXML date to EDI Format -->
      <xsl:param name="DocDate"/>
      <xsl:choose>
         <xsl:when test="$DocDate">
            <xsl:variable name="date">
               <xsl:choose>
                  <xsl:when test="contains($DocDate, 'T')">
                     <xsl:value-of select="replace(substring-before($DocDate, 'T'), '-', '')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="replace(substring($DocDate, 1, 10), '-', '')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="time">
               <xsl:value-of select="substring-after($DocDate, 'T')"/>
            </xsl:variable>
            <xsl:variable name="timezone">
               <xsl:if test="$time != ''">
                  <xsl:choose>
                     <xsl:when test="contains($time, '-')">
                        <xsl:value-of select="concat('-', substring-after($time, '-'))"/>
                     </xsl:when>
                     <xsl:when test="contains($time, '+')">
                        <xsl:value-of select="concat('+', substring-after($time, '+'))"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="time">
               <xsl:if test="$time != ''">
                  <xsl:choose>
                     <xsl:when test="contains($time, '-')">
                        <xsl:value-of select="replace(substring-before($time, '-'), ':', '')"/>
                     </xsl:when>
                     <xsl:when test="contains($time, '+')">
                        <xsl:value-of select="replace(substring-before($time, '+'), ':', '')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="replace($time, ':', '')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="SS">
               <xsl:if test="string-length($time) = 6">
                  <xsl:value-of select="substring($time, 5)"/>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="HH">
               <xsl:value-of select="substring($time, 3, 2)"/>
            </xsl:variable>
            <xsl:variable name="TZone" select="concat($Lookup/Lookups/TimeZones/TimeZone[CXMLCode = $timezone][1]/EDIFACTCode, '')"/>
            <D_2380>
               <xsl:value-of select="concat($date, $time, $TZone)"/>
            </D_2380>
            <D_2379>
               <xsl:choose>
                  <xsl:when test="$SS != '' and $TZone != ''">304</xsl:when>
                  <!--CCYYMMDDHHMMSSZZZ-->
                  <xsl:when test="$SS = '' and $TZone != ''">303</xsl:when>
                  <!--CCYYMMDDHHMMZZZ-->
                  <xsl:when test="$SS != '' and $HH != ''">204</xsl:when>
                  <!--CCYYMMDDHHMMSS-->
                  <xsl:when test="$SS = '' and $HH != ''">203</xsl:when>
                  <!--CCYYMMDDHHMM-->
                  <xsl:otherwise>102</xsl:otherwise>
                  <!--CCYYMMDD-->
               </xsl:choose>
            </D_2379>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="ShippingMark" mode="D_7102">
      <xsl:variable name="segPosShipMark">
         <xsl:choose>
            <xsl:when test="position() = 1"/>
            <xsl:otherwise>
               <xsl:value-of select="concat('_', (position() mod 11))"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:element name="{concat('D_7102', $segPosShipMark)}">
         <xsl:value-of select="."/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="ShippingMark" mode="SG32">
      <G_SG32>
         <S_PCI>
            <D_4233>30</D_4233>
            <C_C210>
               <xsl:apply-templates select=". | following-sibling::ShippingMark[position() &lt; 10]" mode="D_7102"/>
            </C_C210>
         </S_PCI>
      </G_SG32>
   </xsl:template>
   <xsl:template match="ShippingMark" mode="SG34">
      <G_SG34>
         <S_PCI>
            <D_4233>30</D_4233>
            <C_C210>
               <xsl:apply-templates select=". | following-sibling::ShippingMark[position() &lt; 10]" mode="D_7102"/>
            </C_C210>
         </S_PCI>
      </G_SG34>
   </xsl:template>
   <xsl:template match="Accounting" mode="ele">
      <D_7160>
         <xsl:variable name="Aseg">
            <xsl:apply-templates select="AccountingSegment" mode="data"/>
         </xsl:variable>
         <xsl:value-of select="substring($Aseg, 2, 35)"/>
      </D_7160>
   </xsl:template>
   <xsl:template match="AccountingSegment" mode="data">
      <xsl:value-of select="concat('-', ./@id)"/>
   </xsl:template>
   <xsl:template match="Email">
      <xsl:if test=". != ''">
         <Con>
            <xsl:attribute name="type">EM</xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="."/>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template match="URL">
      <xsl:param name="isRemittence"/>
      <xsl:param name="isJITorFOR" required="no"/>
      <xsl:if test=". != ''">
         <Con>
            <xsl:attribute name="type">
               <xsl:choose>
                  <xsl:when test="$isRemittence = 'true' or $isJITorFOR">
                     <xsl:text>CA</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>AH</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="."/>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template match="Fax">
      <xsl:if test="TelephoneNumber/CountryCode != '' or TelephoneNumber/AreaOrCityCode != '' or TelephoneNumber/Number != ''">
         <Con>
            <xsl:attribute name="type">FX</xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:variable name="Number">
               <xsl:value-of select="concat(normalize-space(TelephoneNumber/CountryCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/AreaOrCityCode)))), normalize-space(TelephoneNumber/AreaOrCityCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/Number)))), normalize-space(TelephoneNumber/Number), substring('X', 1, number(string-length(normalize-space(TelephoneNumber/Extension)))), normalize-space(TelephoneNumber/Extension))"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="starts-with($Number, '-')">
                  <xsl:value-of select="substring($Number, 2)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$Number"/>
               </xsl:otherwise>
            </xsl:choose>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template match="Phone">
      <xsl:if test="TelephoneNumber/CountryCode != '' or TelephoneNumber/AreaOrCityCode != '' or TelephoneNumber/Number != ''">
         <Con>
            <xsl:attribute name="type">TE</xsl:attribute>
            <xsl:attribute name="name">
               <xsl:choose>
                  <xsl:when test="./@name != ''">
                     <xsl:value-of select="./@name"/>
                  </xsl:when>
                  <xsl:otherwise>default</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:variable name="Number">
               <xsl:value-of select="concat(normalize-space(TelephoneNumber/CountryCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/AreaOrCityCode)))), normalize-space(TelephoneNumber/AreaOrCityCode), substring('-', 1, number(string-length(normalize-space(TelephoneNumber/Number)))), normalize-space(TelephoneNumber/Number), substring('X', 1, number(string-length(normalize-space(TelephoneNumber/Extension)))), normalize-space(TelephoneNumber/Extension))"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="starts-with($Number, '-')">
                  <xsl:value-of select="substring($Number, 2)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$Number"/>
               </xsl:otherwise>
            </xsl:choose>
         </Con>
      </xsl:if>
   </xsl:template>
   <xsl:template name="CTACOMLoop">
      <xsl:param name="contact"/>
      <xsl:param name="contactType"/>
      <xsl:param name="ContactDepartmentID"/>
      <xsl:param name="ContactPerson"/>
      <xsl:param name="level"/>
      <xsl:param name="isPOUpdate"/>
      <xsl:param name="isJITorFOR"/>
      <xsl:param name="isJITUnloading"/>
      <xsl:param name="isRemittence"/>
      <xsl:param name="isIFTMIN"/>
      <xsl:param name="CTACode" required="no"/>
      <xsl:variable name="contactList">
         <xsl:apply-templates select="$contact/Email"/>
         <xsl:apply-templates select="$contact/Phone"/>
         <xsl:apply-templates select="$contact/Fax"/>
         <xsl:apply-templates select="$contact/URL">
            <xsl:with-param name="isRemittence" select="$isRemittence"/>
            <xsl:with-param name="isJITorFOR" select="$isJITorFOR"></xsl:with-param>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:for-each-group select="$contactList/Con" group-by="./@name">
         <xsl:sort select="@name"/>
         <xsl:variable name="cta01" select="current-grouping-key()"/>
         <xsl:for-each-group select="current-group()" group-ending-with="*[position() mod 5 = 0]">
            <xsl:variable name="eleName">
               <xsl:choose>
                  <xsl:when test="$isPOUpdate = 'true'">
                     <xsl:choose>
                        <xsl:when test="$level = 'detail'">G_SG40</xsl:when>
                        <xsl:otherwise>G_SG6</xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:when test="$isJITorFOR = 'true'">
                     <xsl:choose>
                        <xsl:when test="$level = 'detail'">G_SG6</xsl:when>
                        <xsl:otherwise>G_SG3</xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:when test="$isJITUnloading = 'true'">
                     <xsl:choose>
                        <xsl:when test="$level = 'detail'">G_SG10</xsl:when>
                        <xsl:otherwise>G_SG3</xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:when test="$isRemittence = 'true'">G_SG2</xsl:when>
                  <xsl:when test="$isIFTMIN = 'true'">G_SG12</xsl:when>
                  <xsl:otherwise>
                     <xsl:choose>
                        <xsl:when test="$level = 'detail'">G_SG38</xsl:when>
                        <xsl:otherwise>G_SG5</xsl:otherwise>
                     </xsl:choose>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:element name="{$eleName}">
               <S_CTA>
                  <D_3139>
                     <xsl:choose>
                        <xsl:when test="$CTACode != ''"><xsl:value-of select="$CTACode"/></xsl:when>
                        <xsl:when test="$isRemittence = 'true'">ZZZ</xsl:when>
                        <xsl:when test="$contactType = 'BillTo'">AP</xsl:when>
                        <xsl:when test="$contactType = 'ShipTo'">GR</xsl:when>
                        <xsl:when test="$contactType = 'TermsOfDelivery'">DL</xsl:when>
                        <xsl:when test="$Lookup/Lookups/AccountCodes/AccountCode[CXMLCode = $contactType]/EDIFACTCode != ''">
                           <xsl:value-of select="$Lookup/Lookups/AccountCodes/AccountCode[CXMLCode = $contactType]/EDIFACTCode"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <xsl:when test="$isJITorFOR = 'true'">IC</xsl:when>
                              <xsl:when test="$isJITUnloading = 'true'">SD</xsl:when>
                              <xsl:otherwise>OC</xsl:otherwise>
                           </xsl:choose>
                        </xsl:otherwise>
                     </xsl:choose>
                  </D_3139>
                  <C_C056>
                     <D_3413>
                        <xsl:choose>
                           <xsl:when test="$ContactDepartmentID != ''">
                              <xsl:value-of select="$ContactDepartmentID"/>
                           </xsl:when>
                           <xsl:otherwise>Not Avaiable</xsl:otherwise>
                        </xsl:choose>
                     </D_3413>
                     <D_3412>
                        <xsl:choose>
                           <xsl:when test="$ContactPerson != ''">
                              <xsl:value-of select="$ContactPerson"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$cta01"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </D_3412>
                  </C_C056>
               </S_CTA>
               <xsl:for-each select="current-group()">
                  <S_COM>
                     <C_C076>
                        <D_3148>
                           <xsl:value-of select="."/>
                        </D_3148>
                        <D_3155>
                           <xsl:value-of select="./@type"/>
                        </D_3155>
                     </C_C076>
                  </S_COM>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each-group>
      </xsl:for-each-group>
   </xsl:template>
   <xsl:template name="formatDate1">
      <xsl:param name="DocDate"/>
      <xsl:choose>
         <xsl:when test="$DocDate">
            <xsl:variable name="Year" select="substring($DocDate, 0, 5)"/>
            <xsl:variable name="Month" select="substring($DocDate, 6, 2)"/>
            <xsl:variable name="Day" select="substring($DocDate, 9, 2)"/>
            <xsl:value-of select="concat($Year, $Month, $Day)"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="formatDate2">
      <xsl:param name="DocDate"/>
      <xsl:choose>
         <xsl:when test="$DocDate">
            <xsl:variable name="Year" select="substring($DocDate, 0, 5)"/>
            <xsl:variable name="Month" select="substring($DocDate, 6, 2)"/>
            <xsl:variable name="Day" select="substring($DocDate, 9, 2)"/>
            <xsl:value-of select="concat($Year, '-', $Month, '-', $Day)"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="formatDecimal">
      <xsl:param name="amount"/>
      <xsl:variable name="tempAmount" select="replace(normalize-space($amount), ',', '')"/>
      <xsl:choose>
         <xsl:when test="$tempAmount castable as xs:decimal">
            <xsl:value-of select="xs:decimal($tempAmount)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="normalize-space($tempAmount)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
