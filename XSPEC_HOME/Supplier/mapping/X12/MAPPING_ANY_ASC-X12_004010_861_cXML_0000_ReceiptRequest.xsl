<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns0="urn:sap.com:typesystem:b2b:116:asc-x12:004010" exclude-result-prefixes="#all">
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anSharedSecrete"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="cXMLAttachments"/>
   <xsl:param name="attachSeparator" select="'\|'"/>
   <xsl:variable name="Lookup" select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_ASC-X12_004010.xml')"/>
    <!--xsl:variable name="Lookup" select="document('../../lookups/X12/LOOKUP_ASC-X12_004010.xml')"/-->
   
   <xsl:template match="ns0:*">
      <xsl:variable name="hCurrency" select="FunctionalGroup/M_861/S_CUR[D_98 = 'BY']/D_100"/>
      <xsl:element name="cXML">
          <xsl:attribute name="payloadID">
              <xsl:value-of select="$anPayloadID"/>
          </xsl:attribute>
         <xsl:attribute name="timestamp">
            <xsl:call-template name="convertToAribaDate">
               <xsl:with-param name="Date">
                  <xsl:value-of select="substring(replace(string(current-dateTime()), '-', ''), 1, 8)"/>
               </xsl:with-param>
               <xsl:with-param name="Time">
                  <xsl:value-of select="substring(replace(replace(string(current-dateTime()), '-', ''), ':', ''), 10, 6)"/>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:attribute>
          <xsl:element name="Header">
            <xsl:element name="From">
               <xsl:element name="Credential">
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <xsl:element name="Identity">
                     <xsl:value-of select="$anSupplierANID"/>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
            <xsl:element name="To">
               <xsl:element name="Credential">
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <xsl:element name="Identity">
                     <xsl:value-of select="$anBuyerANID"/>
                  </xsl:element>
               </xsl:element>
                <!-- IG-39691 add SystemID -->
               <xsl:if test="FunctionalGroup/M_861/S_REF[D_128 = '06']/D_127 != ''">
                  <xsl:element name="Credential">
                     <xsl:attribute name="domain">SystemID</xsl:attribute>
                     <xsl:element name="Identity">
                        <xsl:value-of select="FunctionalGroup/M_861/S_REF[D_128 = '06']/D_127"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
                <!-- IG-39691 -->
            </xsl:element>
            <xsl:element name="Sender">
               <xsl:element name="Credential">
                  <xsl:attribute name="domain">NetworkID</xsl:attribute>
                  <xsl:element name="Identity">
                     <xsl:value-of select="$anProviderANID"/>
                  </xsl:element>
                  <xsl:element name="SharedSecret">
                     <xsl:value-of select="$anSharedSecrete"/>
                  </xsl:element>
               </xsl:element>
               <xsl:element name="UserAgent">
                  <xsl:value-of select="'Ariba Supplier'"/>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:element name="Request">

            <xsl:choose>
               <xsl:when test="$anEnvName = 'PROD'">
                  <xsl:attribute name="deploymentMode">production</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="deploymentMode">test</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="ReceiptRequest">
               <xsl:element name="ReceiptRequestHeader">
                  <xsl:attribute name="receiptID">
                     <xsl:value-of select="FunctionalGroup/M_861/S_BRA/D_127"/>
                  </xsl:attribute>

                   <!--IG-27386-->
                  <xsl:attribute name="receiptDate">
                     <xsl:call-template name="convertToAribaDate">
                        <xsl:with-param name="Date">
                           <xsl:choose>
                              <xsl:when
                                 test="exists(FunctionalGroup/M_861/S_DTM[D_374 = '050'])">
                                 
                                 <xsl:value-of
                                    select="FunctionalGroup/M_861/S_DTM[D_374 = '050']/D_373"
                                 />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="FunctionalGroup/M_861/S_BRA/D_373"
                                 />
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="Time">
                           <xsl:choose>
                              <xsl:when
                                 test="exists(FunctionalGroup/M_861/S_DTM[D_374 = '050'])">
                                 <xsl:value-of
                                    select="FunctionalGroup/M_861/S_DTM[D_374 = '050']/D_337"
                                 />
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="FunctionalGroup/M_861/S_BRA/D_337"
                                 />
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="TimeCode">
                           <xsl:value-of select="FunctionalGroup/M_861/S_DTM[D_374 = '050']/D_623"/>
                        </xsl:with-param>
                     </xsl:call-template>

                  </xsl:attribute>
                  <xsl:attribute name="operation">
                     <xsl:choose>
                        <xsl:when test="FunctionalGroup/M_861/S_BRA/D_353 = '00'">
                           <xsl:text>new</xsl:text>
                        </xsl:when>
                        <xsl:when test="FunctionalGroup/M_861/S_BRA/D_353 = '03'">
                           <xsl:text>delete</xsl:text>
                        </xsl:when>
                        <xsl:when test="FunctionalGroup/M_861/S_BRA/D_353 = '05'">
                           <xsl:text>update</xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:attribute>
                  <!--IG-27386-->
                  <xsl:if test="FunctionalGroup/M_861/S_REF[D_128 = 'MA']/D_127 != ''">
                     <xsl:element name="ShipNoticeIDInfo">
                        
                        <xsl:attribute name="shipNoticeID">
                           <xsl:value-of
                              select="FunctionalGroup/M_861/S_REF[D_128 = 'MA']/D_127"/>
                        </xsl:attribute>
                        <xsl:if test="FunctionalGroup/M_861/S_DTM[D_374 = '111']/D_373 != ''">
                           <xsl:attribute name="shipNoticeDate">
                              <xsl:call-template name="convertToAribaDate">
                                 <xsl:with-param name="Date">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_861/S_DTM[D_374 = '111']/D_373"
                                    />
                                 </xsl:with-param>
                                 <xsl:with-param name="Time">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_861/S_DTM[D_374 = '111']/D_337"
                                    />
                                 </xsl:with-param>
                                 <xsl:with-param name="TimeCode">
                                    <xsl:value-of
                                       select="FunctionalGroup/M_861/S_DTM[D_374 = '111']/D_623"
                                    />
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:attribute>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="FunctionalGroup/M_861/S_REF[D_128 = 'L1']/D_352 != ''">

                     <Comments>
                        <xsl:if test="FunctionalGroup/M_861/S_REF/D_127 != ''">
                        <xsl:attribute name="xml:lang">
                           <xsl:value-of select="FunctionalGroup/M_861/S_REF/D_127"/>
                        </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="FunctionalGroup/M_861/S_REF/D_352"/>
                     </Comments>
                  </xsl:if>
                  <xsl:for-each select="FunctionalGroup/M_861/S_REF[D_128 = 'ZZ']">
                     <xsl:if test="D_127 != ''">
                        <xsl:element name="Extrinsic">
                        <xsl:attribute name="name">
                           <xsl:value-of select="D_127"/>
                        </xsl:attribute>
                        <xsl:value-of select="D_352"/>
                     </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:element>

               <!--IG-27386-->
               <!--groupby start for same PO Number to be grouped-->
               <xsl:for-each-group select="FunctionalGroup/M_861/G_RCD"
                  group-by="S_REF[D_128 = 'PO']/D_127">
                  <xsl:element name="ReceiptOrder">
                      <xsl:choose>
                          <xsl:when test="S_REF[D_128 = 'PO']/D_352 = 'CL'">
                            <xsl:attribute name="closeForReceiving">
                               <xsl:text>yes</xsl:text>
                            </xsl:attribute>
                          </xsl:when>
                          <xsl:when test="//FunctionalGroup/M_861/S_BRA/D_306 = 'CL'">
                              <xsl:attribute name="closeForReceiving">
                                  <xsl:text>yes</xsl:text>
                              </xsl:attribute>
                          </xsl:when>
                      </xsl:choose>
                     <ReceiptOrderInfo>
                        <OrderReference>
                           <xsl:attribute name="orderID">
                              <xsl:value-of select="(S_REF[D_128 = 'PO']/D_127)[1]"/>
                           </xsl:attribute>
                           <xsl:if test="S_DTM[D_374 = '004']/D_373 != ''">
                              <xsl:attribute name="orderDate">
                                 <xsl:call-template name="convertToAribaDate">
                                    <xsl:with-param name="Date">
                                       <xsl:value-of select="S_DTM[D_374 = '004']/D_373"
                                       />
                                    </xsl:with-param>
                                    <xsl:with-param name="Time">
                                       <xsl:value-of select="S_DTM[D_374 = '004']/D_337"
                                       />
                                    </xsl:with-param>
                                    <xsl:with-param name="TimeCode">
                                       <xsl:value-of select="S_DTM[D_374 = '004']/D_623"
                                       />
                                    </xsl:with-param>
                                 </xsl:call-template>
                              </xsl:attribute>
                           </xsl:if>
                           <DocumentReference>
                              <xsl:attribute name="payloadID">                                
                                 <xsl:value-of select="S_REF[D_128 = 'IL']/D_352"/>
                              </xsl:attribute>
                           </DocumentReference>
                        </OrderReference>
                         <xsl:if test="(S_REF[D_128 = 'AH']/D_127)[1] != ''">
                            <MasterAgreementReference>
                               <xsl:attribute name="agreementID">
                                  <xsl:value-of select="(S_REF[D_128 = 'AH']/D_127)[1]"/>
                               </xsl:attribute>
                               <xsl:if test="S_REF[D_128 = 'AH']/C_C040[D_128 = 'AH']/D_127 = '1'">
                                  <xsl:attribute name="agreementType">
                                     <xsl:value-of select="'scheduling_agreement'"/>
                                  </xsl:attribute>
                               </xsl:if>
                               <xsl:if test="S_DTM[D_374 = 'LEA']/D_373 != ''">
                                  <xsl:attribute name="agreementDate">
                                     <xsl:call-template name="convertToAribaDate">
                                        <xsl:with-param name="Date">
                                           <xsl:value-of select="S_DTM[D_374 = 'LEA']/D_373"
                                           />
                                        </xsl:with-param>
                                        <xsl:with-param name="Time">
                                           <xsl:value-of select="S_DTM[D_374 = 'LEA']/D_337"
                                           />
                                        </xsl:with-param>
                                        <xsl:with-param name="TimeCode">
                                           <xsl:value-of select="S_DTM[D_374 = 'LEA']/D_623"
                                           />
                                        </xsl:with-param>
                                     </xsl:call-template>
                                  </xsl:attribute>
                               </xsl:if>
                               <DocumentReference>
                                  <xsl:attribute name="payloadID">
                                     <xsl:value-of select="S_REF[D_128 = 'IL']/D_352"/>
                                  </xsl:attribute>
                               </DocumentReference>
                               </MasterAgreementReference>
                         </xsl:if>
                     </ReceiptOrderInfo>
                  
                  <xsl:for-each-group select="current-group()" group-by="S_LIN/D_350">
                                <!--This is to include receipt items under same PO receipt order-->
                                <ReceiptItem>
                                    <xsl:attribute name="receiptLineNumber">
                                        <xsl:choose>
                                            <xsl:when test="S_RCD/D_350 != ''">
                                                <xsl:value-of select="S_RCD/D_350"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="S_LIN/D_350"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:attribute name="quantity">
                                        <xsl:choose>
                                            <xsl:when test="S_RCD/D_663">
                                                <xsl:value-of select="S_RCD/D_663"/>
                                            </xsl:when>
                                            <xsl:when test="S_RCD/D_664">
                                                <xsl:value-of select="S_RCD/D_664"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:choose>
                                            <xsl:when test="S_RCD/D_663 != ''">
                                               <xsl:attribute name="type">
                                                <xsl:text>received</xsl:text>
                                               </xsl:attribute>
                                            </xsl:when>
                                            <xsl:when test="S_RCD/D_664 != ''">
                                               <xsl:attribute name="type">
                                                <xsl:text>returned</xsl:text>
                                               </xsl:attribute>
                                            </xsl:when>
                                        </xsl:choose>
                                    
                                    <xsl:if
                                        test="S_REF[D_128 = 'FL']/C_C040[D_128 = 'LI']/D_127 != ''">
                                        <xsl:attribute name="parentReceiptLineNumber">
                                            <xsl:value-of
                                                select="S_REF[D_128 = 'FL']/C_C040[D_128 = 'LI']/D_127"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="S_REF[D_128 = 'FL']/D_127 != ''">
                                        <xsl:attribute name="itemType">
                                            <xsl:value-of select="S_REF[D_128 = 'FL']/D_127"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if
                                        test="S_REF[D_128 = 'FL'][D_127 = 'composite']/D_352 != ''">
                                        <xsl:attribute name="compositeItemType">
                                            <xsl:value-of
                                                select="S_REF[D_128 = 'FL'][D_127 = 'composite']/D_352"
                                            />
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="S_REF[D_128 = 'FJ']/D_127 = 'CM'">
                                        <xsl:attribute name="completedIndicator">
                                            <xsl:value-of select="'yes'"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:variable name="lin">
                                        <xsl:call-template name="createLIN">
                                            <xsl:with-param name="LIN" select="S_LIN"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                     <xsl:if
                                        test="$lin/lin/element[@name = 'PL' or @name = 'VP' or @name = 'VS' or @name = 'BP' or @name = 'MG' or @name = 'MF']/@value != '' or S_PID/D_352 or S_REF[D_128 = 'MA']/D_127 != ''">
                                        <ReceiptItemReference>
                                            <xsl:attribute name="lineNumber">
                                                <xsl:value-of
                                                  select="$lin/lin/element[@name = 'PL']/@value"/>
                                            </xsl:attribute>
                                            <xsl:if
                                                test="$lin/lin/element[@name = 'UP' or @name = 'VP' or @name = 'VS' or @name = 'BP'  or @name = 'EN']/@value != ''">
                                             <ItemID>
                                                  <SupplierPartID>
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'VP']/@value"/>
                                                  </SupplierPartID>
                                                  <xsl:if
                                                  test="$lin/lin/element[@name = 'VS']/@value != ''">
                                                  <SupplierPartAuxiliaryID>
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'VS']/@value"/>
                                                  </SupplierPartAuxiliaryID>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="$lin/lin/element[@name = 'BP']/@value != ''">
                                                  <BuyerPartID>
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'BP']/@value"/>
                                                  </BuyerPartID>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="$lin/lin/element[@name = 'UP']/@value != '' or $lin/lin/element[@name = 'EN']/@value != ''">
                                                  <IdReference>
                                                  <xsl:choose>
                                                  <xsl:when test="$lin/lin/element[@name = 'UP']">
                                                  <xsl:attribute name="identifier">
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'UP']/@value"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="domain">
                                                  <xsl:value-of select="'UPCConsumerPackageCode'"/>
                                                  </xsl:attribute>
                                                  </xsl:when>
                                                  <xsl:when test="$lin/lin/element[@name = 'EN']">
                                                  <xsl:attribute name="identifier">
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'EN']/@value"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="domain">
                                                  <xsl:value-of select="'EAN-13'"/>
                                                  </xsl:attribute>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </IdReference>
                                                  </xsl:if>
                                                </ItemID>
                                                <Description>
                                                  <xsl:attribute name="xml:lang">
                                                      <xsl:choose>
                                                          <xsl:when test="S_PID[D_349 = 'F']/D_819 != ''">
                                                            <xsl:value-of select="(S_PID[D_349 = 'F']/D_819)[1]"/>
                                                          </xsl:when>
                                                          <xsl:otherwise>en</xsl:otherwise>
                                                      </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:for-each
                                                  select="S_PID[D_349 = 'F' and D_750 = 'GEN']">
                                                  <xsl:if test="D_352 != ''">
                                                  <ShortName>
                                                  <xsl:value-of select="D_352"/>
                                                  </ShortName>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  <xsl:for-each
                                                  select="S_PID[(D_349 = 'F') and (D_750 = '' or not(D_750))]">
                                                  <xsl:if test="D_352 != ''">
                                                  <xsl:value-of select="D_352"/>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </Description>

                                                <xsl:if
                                                  test="$lin/lin/element[@name = 'MG']/@value != ''">
                                                  <ManufacturerPartID>
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'MG']/@value"/>
                                                  </ManufacturerPartID>
                                                </xsl:if>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="$lin/lin/element[@name = 'MF']/@value != ''">
                                                  <ManufacturerName>
                                                  <xsl:value-of
                                                  select="$lin/lin/element[@name = 'MF']/@value"/>
                                                  </ManufacturerName>
                                                  </xsl:when>
                                                  <xsl:when test="G_N1[S_N1/D_98_1 = 'MA']">
                                                  <ManufacturerName>
                                                  <xsl:value-of
                                                  select="concat(G_N1[S_N1/D_98 = 'MA']/D_93, G_N1[S_N1/D_98 = 'MA']/S_N2/D_93, G_N1[S_N1/D_98 = 'MA']/S_N2/D_93_2)"
                                                  />
                                                  </ManufacturerName>
                                                  </xsl:when>
                                                </xsl:choose>
                                                <xsl:if test="S_REF[D_128 = 'MA']/D_127">
                                                  <ShipNoticeIDInfo>
                                                  <xsl:if test="S_REF[D_128 = 'MA']/D_127 != ''">
                                                  <xsl:attribute name="shipNoticeID">
                                                  <xsl:value-of select="S_REF[D_128 = 'MA']/D_127"/>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:if test="S_DTM[D_374 = '111']">
                                                  <xsl:attribute name="shipNoticeDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date">
                                                  <xsl:value-of select="S_DTM[D_374 = '111']/D_373"
                                                  />
                                                  </xsl:with-param>
                                                  <xsl:with-param name="Time">
                                                  <xsl:value-of select="S_DTM[D_374 = '111']/D_337"
                                                  />
                                                  </xsl:with-param>
                                                  <xsl:with-param name="TimeCode">
                                                  <xsl:value-of select="S_DTM[D_374 = '111']/D_623"
                                                  />
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  </ShipNoticeIDInfo>

                                                </xsl:if>
                                                <xsl:if
                                                  test="S_REF[D_128 = 'MA']/C_C040[D_128 = 'LI']/D_127 != ''">
                                                  <ShipNoticeLineItemReference>
                                                  <xsl:attribute name="shipNoticeLineNumber">
                                                  <xsl:value-of
                                                  select="S_REF[D_128 = 'MA']/C_C040[D_128 = 'LI']/D_127"
                                                  />
                                                  </xsl:attribute>
                                                  </ShipNoticeLineItemReference>
                                                </xsl:if>
                                                <xsl:if
                                                  test="S_REF[D_128 = '0L']/D_127 != '' and S_REF[D_128 = '0L']/D_352 != ''">
                                                  <ReferenceDocumentInfo>
                                                  <DocumentInfo>
                                                  <xsl:attribute name="documentID">
                                                  <xsl:value-of select="S_REF[D_128 = '0L']/D_352"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="documentType">
                                                  <xsl:value-of select="S_REF[D_128 = '0L']/D_127"/>
                                                  </xsl:attribute>

                                                  <xsl:if
                                                  test="S_REF[D_128 = '0L']/C_C040[D_128 = '0L']/D_127 != ''">
                                                  <xsl:attribute name="documentDate">
                                                  <xsl:call-template name="convertToAribaDate">
                                                  <xsl:with-param name="Date">
                                                  <xsl:value-of
                                                  select="S_REF[D_128 = '0L']/C_C040[D_128 = '0L']/D_127"
                                                  />
                                                  </xsl:with-param>
                                                  </xsl:call-template>
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  </DocumentInfo>
                                                  </ReferenceDocumentInfo>
                                                </xsl:if>

                                            </xsl:if>
                                        </ReceiptItemReference>
                                    </xsl:if>
                                    <UnitRate>
                                        <Money>
                                            <xsl:attribute name="currency">
                                                <xsl:choose>
                                                  <xsl:when test="S_CUR[D_98 = 'BY']/D_100">
                                                  <xsl:value-of select="S_CUR[D_98 = 'BY']/D_100"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="$hCurrency"/>
                                                  </xsl:otherwise>
                                                </xsl:choose>

                                            </xsl:attribute>
                                            <xsl:value-of select="S_REF[D_128 = '1Z']/D_127"/>
                                        </Money>
                                        <UnitOfMeasure>
                                            <xsl:choose>
                                                <xsl:when test="S_RCD/D_663">
                                                  <xsl:value-of select="S_RCD/C_C001/D_355"/>
                                                </xsl:when>
                                                <xsl:when test="S_RCD/D_664">
                                                  <xsl:value-of select="S_RCD/C_C001_2/D_355"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </UnitOfMeasure>
                                    </UnitRate>
                                    <ReceivedAmount>
                                        <Money>
                                            <xsl:attribute name="currency">
                                                <xsl:choose>
                                                  <xsl:when test="S_CUR[D_98 = 'BY']/D_100">
                                                  <xsl:value-of select="S_CUR[D_98 = 'BY']/D_100"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="$hCurrency"/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <xsl:value-of select="S_REF[D_128 = '1Z']/D_352"/>
                                        </Money>
                                    </ReceivedAmount>

                                    <xsl:if
                                        test="S_MAN[D_88 = 'L']/D_87 = 'SN' or S_MAN[D_88_2 = 'L']/D_87_3 = 'AT' or S_MAN[D_88 = 'L']/D_87 = 'AT' or S_MAN[D_88_2 = 'L']/D_87_3 = 'SN'">
                                        <AssetInfo>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="S_MAN[D_88 = 'L']/D_87 = 'SN' and S_MAN[D_88_2 = 'L']/D_87_3 = 'AT'">
                                                  <xsl:attribute name="serialNumber">
                                                  <xsl:value-of select="S_MAN[D_88 = 'L']/D_87_2"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="tagNumber">
                                                  <xsl:value-of select="S_MAN[D_88_2 = 'L']/D_87_4"
                                                  />
                                                  </xsl:attribute>
                                                </xsl:when>
                                                <xsl:when
                                                  test="S_MAN[D_88 = 'L']/D_87 = 'AT' and S_MAN[D_88_2 = 'L']/D_87_3 = 'SN'">
                                                  <xsl:attribute name="tagNumber">
                                                  <xsl:value-of select="S_MAN[D_88 = 'L']/D_87_2"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="serialNumber">
                                                  <xsl:value-of select="S_MAN[D_88_2 = 'L']/D_87_4"
                                                  />
                                                  </xsl:attribute>
                                                </xsl:when>
                                              </xsl:choose>
                                            </AssetInfo>
                                    </xsl:if>
                                    
                                    <xsl:for-each select="G_N1[S_N1/D_98 = 'DA']">
                                        <DeliveryAddress>
                                            <xsl:call-template name="createAddress">
                                                <xsl:with-param name="contact" select="."/>
                                            </xsl:call-template>
                                        </DeliveryAddress>
                                    </xsl:for-each>
                                    <xsl:if test="S_REF[D_128 = 'L1']/D_352 != ''">
                                         <Comments>
                                            <xsl:attribute name="xml:lang">
                                                <xsl:value-of select="S_REF[D_128 = 'L1']/D_127"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="S_REF[D_128 = 'L1']/D_352"/>
                                        </Comments>
                                    </xsl:if>
                                   
                                   <xsl:if test="$lin/lin/element[@name = 'B8' or @name = 'LT']/@value != ''">
                                   <Batch>
                                       <xsl:if test="$lin/lin/element[@name = 'LT']/@value != ''">
                                        <BuyerBatchID>
                                           <xsl:value-of
                                              select="$lin/lin/element[@name = 'LT']/@value"/>
                                        </BuyerBatchID>
                                       </xsl:if>
                                       <xsl:if test="$lin/lin/element[@name = 'B8']/@value != ''">
                                        <SupplierBatchID>
                                           <xsl:value-of
                                              select="$lin/lin/element[@name = 'B8']/@value"/>
                                        </SupplierBatchID>
                                       </xsl:if>
                                   </Batch>
                                   </xsl:if>
                                    <xsl:variable name="classDomain"
                                        select="S_PID[D_349 = 'S'][D_750 = 'MAC']/D_822"/>

                                    <xsl:if
                                        test="$Lookup/Lookups/Classifications/Classification[X12Code = $classDomain]/CXMLCode != ''">
                                        <Classification>
                                            <xsl:attribute name="domain">
                                                <xsl:value-of
                                                  select="$Lookup/Lookups/Classifications/Classification[X12Code = $classDomain]/CXMLCode"
                                                />
                                            </xsl:attribute>

                                            <xsl:attribute name="code">
                                                <xsl:value-of
                                                  select="S_PID[D_349 = 'S'][D_750 = 'MAC']/D_751"/>
                                            </xsl:attribute>
                                            <xsl:value-of
                                                select="S_PID[D_349 = 'S'][D_750 = 'MAC']/D_352"/>
                                        </Classification>
                                    </xsl:if>


                                    <xsl:for-each select="S_REF[D_128 = 'ZZ']">
                                        <xsl:element name="Extrinsic">
                                            <xsl:attribute name="name">
                                                <xsl:value-of select="D_127"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="D_352"/>
                                        </xsl:element>
                                    </xsl:for-each>
                             </ReceiptItem>
                            </xsl:for-each-group>
                  </xsl:element> <!--ReceiptOrder end-->
                  
               </xsl:for-each-group>   <!--groupby end for same PO Number to be grouped-->
               
               <xsl:element name="Total">
                  <Money>
                     <xsl:attribute name="currency">
                        <xsl:value-of
                           select="FunctionalGroup/M_861/S_CUR[D_98 = 'BY']/D_100"/>
                     </xsl:attribute>
                     <xsl:value-of select="FunctionalGroup/M_861/S_REF[D_128 = '1Z']/D_127"/>
                  </Money>
               </xsl:element>
            </xsl:element>
         </xsl:element>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createLIN">
      <xsl:param name="LIN"/>
      <lin>
         <xsl:for-each select="$LIN/*[starts-with(name(), 'D_23')]">
            <xsl:if test="starts-with(name(), 'D_235')">
               <element>
                  <xsl:attribute name="name">
                     <xsl:value-of select="normalize-space(.)"/>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                     <xsl:value-of select="following-sibling::*[name() = replace(name(), 'D_235', 'D_234')][1]"/>
                  </xsl:attribute>
               </element>
            </xsl:if>
         </xsl:for-each>
      </lin>
   </xsl:template>

   <xsl:template name="createAddress">
      <xsl:param name="contact"/>
      <xsl:element name="Address">
         <xsl:if test="$contact/S_N1/D_66 != '' or $contact/S_N1/D_67 != ''">
            <xsl:variable name="addrDomain">
               <xsl:value-of select="$contact/S_N1/D_66"/>
            </xsl:variable>
            <xsl:variable name="addressID">
               <xsl:value-of select="$contact/S_N1/D_67"/>
            </xsl:variable>
            <xsl:if test="$addressID != ''">
               <xsl:attribute name="addressID">
                  <xsl:value-of select="$addressID"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
               <xsl:if test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode != ''">
                  <xsl:attribute name="addressIDDomain">
                     <xsl:value-of select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"/>
                  </xsl:attribute>
               </xsl:if>
            </xsl:if>
         </xsl:if>
         <xsl:element name="Name">
            <xsl:attribute name="xml:lang">en</xsl:attribute>
            <xsl:value-of select="$contact/S_N1/D_93"/>
         </xsl:element>
         <!-- PostalAddress -->
         <xsl:if test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
            <xsl:element name="PostalAddress">
               <xsl:for-each select="$contact/S_N2">
                  <xsl:element name="DeliverTo">
                     <xsl:value-of select="D_93"/>
                  </xsl:element>
                  <xsl:if test="D_93_2 != ''">
                     <xsl:element name="DeliverTo">
                        <xsl:value-of select="D_93_2"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$contact/S_N3">
                  <xsl:element name="Street">
                     <xsl:value-of select="D_166"/>
                  </xsl:element>
                  <xsl:if test="D_166_2 != ''">
                     <xsl:element name="Street">
                        <xsl:value-of select="D_166_2"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
               <xsl:element name="City">
                  <xsl:value-of select="$contact/S_N4/D_19"/>
               </xsl:element>
               <xsl:variable name="stateCode">
                  <xsl:choose>
                     <xsl:when test="$contact/S_N4/D_310 != '' and not(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA'))">
                        <xsl:value-of select="$contact/S_N4/D_310"/>
                     </xsl:when>
                     <xsl:when test="$contact/S_N4/D_156 != ''">
                        <xsl:value-of select="$contact/S_N4/D_156"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:variable>
               <xsl:if test="$stateCode != ''">
                  <xsl:element name="State">
                     <xsl:if test="$contact/S_N4/D_156 != ''">
                        <xsl:attribute name="isoStateCode">
                           <xsl:value-of select="$stateCode"/>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:choose>
                        <xsl:when test="(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA') and $Lookup/Lookups/States/State[stateCode = $stateCode]/stateName != '')">
                           <xsl:value-of select="$Lookup/Lookups/States/State[stateCode = $stateCode]/stateName"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$stateCode"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
               </xsl:if>
               <xsl:if test="$contact/S_N4/D_116 != ''">
                  <xsl:element name="PostalCode">
                     <xsl:value-of select="$contact/S_N4/D_116"/>
                  </xsl:element>
               </xsl:if>
               <xsl:variable name="isoCountryCode">
                  <xsl:value-of select="$contact/S_N4/D_26"/>
               </xsl:variable>
               <xsl:element name="Country">
                  <xsl:attribute name="isoCountryCode">
                     <xsl:value-of select="$isoCountryCode"/>
                  </xsl:attribute>
                  <xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
               </xsl:element>
            </xsl:element>
         </xsl:if>
         <xsl:variable name="contactList">
            <xsl:apply-templates select="$contact/S_PER"/>
         </xsl:variable>
         <xsl:for-each select="$contactList/Con[@type = 'Email'][1]">
            <xsl:element name="Email">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:value-of select="./@value"/>
            </xsl:element>
         </xsl:for-each>
         <xsl:for-each select="$contactList/Con[@type = 'Phone'][1]">
            <xsl:sort select="@name"/>
            <xsl:variable name="cCode" select="@cCode"/>
            <xsl:element name="Phone">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:element name="TelephoneNumber">
                  <xsl:element name="CountryCode">
                     <xsl:attribute name="isoCountryCode">
                        <xsl:choose>
                           <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                              <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
                           </xsl:when>
                           <xsl:otherwise>US</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:value-of select="replace(@cCode, '\+', '')"/>
                  </xsl:element>
                  <xsl:element name="AreaOrCityCode">
                     <xsl:value-of select="@aCode"/>
                  </xsl:element>
                  <xsl:element name="Number">
                     <xsl:value-of select="@num"/>
                  </xsl:element>
                  <xsl:if test="@ext != ''">
                     <xsl:element name="Extension">
                        <xsl:value-of select="@ext"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:element>
         </xsl:for-each>
         <xsl:for-each select="$contactList/Con[@type = 'Fax'][1]">
            <xsl:sort select="@name"/>
            <xsl:variable name="cCode" select="@cCode"/>
            <xsl:element name="Fax">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:element name="TelephoneNumber">
                  <xsl:element name="CountryCode">
                     <xsl:attribute name="isoCountryCode">
                        <xsl:choose>
                           <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                              <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
                           </xsl:when>
                           <xsl:otherwise>US</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:value-of select="replace(@cCode, '\+', '')"/>
                  </xsl:element>
                  <xsl:element name="AreaOrCityCode">
                     <xsl:value-of select="@aCode"/>
                  </xsl:element>
                  <xsl:element name="Number">
                     <xsl:value-of select="@num"/>
                  </xsl:element>
                  <xsl:if test="@ext != ''">
                     <xsl:element name="Extension">
                        <xsl:value-of select="@ext"/>
                     </xsl:element>
                  </xsl:if>
               </xsl:element>
            </xsl:element>
         </xsl:for-each>
         <xsl:for-each select="$contactList/Con[@type = 'URL'][1]">
            <xsl:sort select="@name"/>
            <xsl:element name="URL">
               <xsl:attribute name="name">
                  <xsl:value-of select="./@name"/>
               </xsl:attribute>
               <xsl:value-of select="./@value"/>
            </xsl:element>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="createContact">
      <xsl:param name="contact"/>
      <xsl:variable name="role">
         <xsl:value-of select="$contact/S_N1/D_98_1"/>
      </xsl:variable>
      <xsl:if test="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode != ''">
         <xsl:element name="Contact">
            <xsl:attribute name="role">
               <xsl:value-of select="$Lookup/Lookups/Roles/Role[X12Code = $role]/CXMLCode"/>
            </xsl:attribute>
            <xsl:if test="$contact/S_N1/D_66 != '' or $contact/S_N1/D_67 != ''">
               <xsl:variable name="addrDomain">
                  <xsl:value-of select="$contact/S_N1/D_66"/>
               </xsl:variable>
               <xsl:variable name="addressID">
                  <xsl:value-of select="$contact/S_N1/D_67"/>
               </xsl:variable>
               <xsl:if test="$addressID != ''">
                  <xsl:attribute name="addressID">
                     <xsl:value-of select="$addressID"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:if test="$addrDomain != '91' and $addrDomain != '92'">
                  <xsl:if test="$Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode != ''">
                     <xsl:attribute name="addressIDDomain">
                        <xsl:value-of select="normalize-space($Lookup/Lookups/AddrDomains/AddrDomain[X12Code = $addrDomain]/CXMLCode)"/>
                     </xsl:attribute>
                  </xsl:if>
               </xsl:if>
            </xsl:if>
            <xsl:element name="Name">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
               <xsl:value-of select="$contact/S_N1/D_93"/>
            </xsl:element>
            <!-- PostalAddress -->
            <xsl:if test="exists($contact/S_N3) and exists($contact/S_N4) and $contact/S_N4/D_19 != '' and $contact/S_N4/D_26 != ''">
               <xsl:element name="PostalAddress">
                  <xsl:for-each select="$contact/S_N2">
                     <xsl:element name="DeliverTo">
                        <xsl:value-of select="D_93_1"/>
                     </xsl:element>
                     <xsl:if test="D_93_2 != ''">
                        <xsl:element name="DeliverTo">
                           <xsl:value-of select="D_93_2"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="$contact/S_N3">
                     <xsl:element name="Street">
                        <xsl:value-of select="D_166_1"/>
                     </xsl:element>
                     <xsl:if test="D_166_2 != ''">
                        <xsl:element name="Street">
                           <xsl:value-of select="D_166_2"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:element name="City">
                     <xsl:value-of select="$contact/S_N4/D_19"/>
                  </xsl:element>
                  <xsl:variable name="stateCode">
                     <xsl:choose>
                        <xsl:when test="$contact/S_N4/D_310 != '' and not(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA'))">
                           <xsl:value-of select="$contact/S_N4/D_310"/>
                        </xsl:when>
                        <xsl:when test="$contact/S_N4/D_156 != ''">
                           <xsl:value-of select="$contact/S_N4/D_156"/>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="$stateCode != ''">
                     <xsl:element name="State">
                        <xsl:if test="$contact/S_N4/D_156 != ''">
                           <xsl:attribute name="isoStateCode">
                              <xsl:value-of select="$stateCode"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:choose>
                           <xsl:when test="(($contact/S_N4/D_26 = 'US' or $contact/S_N4/D_26 = 'CA') and $Lookup/Lookups/States/State[stateCode = $stateCode]/stateName != '')">
                              <xsl:value-of select="$Lookup/Lookups/States/State[stateCode = $stateCode]/stateName"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$stateCode"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="$contact/S_N4/D_116 != ''">
                     <xsl:element name="PostalCode">
                        <xsl:value-of select="$contact/S_N4/D_116"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:variable name="isoCountryCode">
                     <xsl:value-of select="$contact/S_N4/D_26"/>
                  </xsl:variable>
                  <xsl:element name="Country">
                     <xsl:attribute name="isoCountryCode">
                        <xsl:value-of select="$isoCountryCode"/>
                     </xsl:attribute>
                     <xsl:value-of select="$Lookup/Lookups/Countries/Country[countryCode = $isoCountryCode]/countryName"/>
                  </xsl:element>
               </xsl:element>
            </xsl:if>
            <xsl:variable name="contactList">
               <xsl:apply-templates select="$contact/S_PER"/>
            </xsl:variable>
            <xsl:for-each select="$contactList/Con[@type = 'Email']">
               <xsl:sort select="@name"/>
               <xsl:element name="Email">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:value-of select="./@value"/>
               </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'Phone']">
               <xsl:sort select="@name"/>
               <xsl:variable name="cCode" select="@cCode"/>
               <xsl:element name="Phone">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:element name="TelephoneNumber">
                     <xsl:element name="CountryCode">
                        <xsl:attribute name="isoCountryCode">
                           <xsl:choose>
                              <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                 <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
                              </xsl:when>
                              <xsl:otherwise>US</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="replace(@cCode, '\+', '')"/>
                     </xsl:element>
                     <xsl:element name="AreaOrCityCode">
                        <xsl:value-of select="@aCode"/>
                     </xsl:element>
                     <xsl:element name="Number">
                        <xsl:value-of select="@num"/>
                     </xsl:element>
                     <xsl:if test="@ext != ''">
                        <xsl:element name="Extension">
                           <xsl:value-of select="@ext"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'Fax']">
               <xsl:sort select="@name"/>
               <xsl:variable name="cCode" select="@cCode"/>
               <xsl:element name="Fax">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:element name="TelephoneNumber">
                     <xsl:element name="CountryCode">
                        <xsl:attribute name="isoCountryCode">
                           <xsl:choose>
                              <xsl:when test="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode != ''">
                                 <xsl:value-of select="$Lookup/Lookups/Countries/Country[phoneCode = $cCode][1]/countryCode"/>
                              </xsl:when>
                              <xsl:otherwise>US</xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="replace(@cCode, '\+', '')"/>
                     </xsl:element>
                     <xsl:element name="AreaOrCityCode">
                        <xsl:value-of select="@aCode"/>
                     </xsl:element>
                     <xsl:element name="Number">
                        <xsl:value-of select="@num"/>
                     </xsl:element>
                     <xsl:if test="@ext != ''">
                        <xsl:element name="Extension">
                           <xsl:value-of select="@ext"/>
                        </xsl:element>
                     </xsl:if>
                  </xsl:element>
               </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$contactList/Con[@type = 'URL']">
               <xsl:sort select="@name"/>
               <xsl:element name="URL">
                  <xsl:attribute name="name">
                     <xsl:value-of select="./@name"/>
                  </xsl:attribute>
                  <xsl:value-of select="./@value"/>
               </xsl:element>
            </xsl:for-each>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <xsl:template match="S_PER">
        <xsl:variable name="PER02">
            <xsl:choose>
                <xsl:when test="D_93 != ''">
                    <xsl:value-of select="D_93"/>
                </xsl:when>
                <xsl:otherwise>default</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="D_365_1 = 'EM' or D_365 = 'EM'">
                <Con>
                    <xsl:attribute name="type">Email</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:if test="D_365_1">
                        <xsl:value-of select="normalize-space(D_364_1)"/>
                        </xsl:if>
                        <xsl:if test="D_365">
                            <xsl:value-of select="normalize-space(D_364)"/>
                        </xsl:if>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_1 = 'UR' or D_365 = 'UR'">
                <Con>
                    <xsl:attribute name="type">URL</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:if test="D_365_1">
                        <xsl:value-of select="normalize-space(D_364_1)"/>
                        </xsl:if>
                        <xsl:if test="D_365">
                            <xsl:value-of select="normalize-space(D_364)"/>
                        </xsl:if>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_1 = 'TE' or D_365 = 'TE'">
                <Con>
                    <xsl:attribute name="type">Phone</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, '(')">
                                <xsl:value-of select="substring-before(D_364_1, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, '(')">
                                <xsl:value-of select="substring-before(D_364, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, '-')">
                                <xsl:value-of select="substring-before(D_364_1, '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, '-')">
                                <xsl:value-of select="substring-before(D_364, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:if test="D_364_1">
                            <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"
                        />
                        </xsl:if>
                        <xsl:if test="D_364">
                            <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"
                            />
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="D_364_1">
                                <xsl:value-of select="substring-after(D_364_1, '-')"/>
                                </xsl:if>
                                <xsl:if test="D_364">
                                    <xsl:value-of select="substring-after(D_364, '-')"/>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:if test="D_364_1">
                        <xsl:value-of select="substring-after(D_364_1, 'x')"/>
                        </xsl:if>
                        <xsl:if test="D_364">
                            <xsl:value-of select="substring-after(D_364, 'x')"/>
                        </xsl:if>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_1 = 'FX' or D_365 = 'FX'">
                <Con>
                    <xsl:attribute name="type">Fax</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, '(')">
                                <xsl:value-of select="substring-before(D_364_1, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, '(')">
                                <xsl:value-of select="substring-before(D_364, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, '-')">
                                <xsl:value-of select="substring-before(D_364_1, '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, '-')">
                                <xsl:value-of select="substring-before(D_364, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:if test="D_364_1">
                            <xsl:value-of select="substring-after(substring-before(D_364_1, ')'), '(')"
                        />
                        </xsl:if>
                        <xsl:if test="D_364">
                            <xsl:value-of select="substring-after(substring-before(D_364, ')'), '(')"
                            />
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_1, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_1, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_1, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="D_364_1">
                                    <xsl:value-of select="substring-after(D_364_1, '-')"/>
                                </xsl:if>
                                <xsl:if test="D_364">
                                    <xsl:value-of select="substring-after(D_364, '-')"/>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:if test="D_364_1">
                        <xsl:value-of select="substring-after(D_364_1, 'x')"/>
                        </xsl:if>
                        <xsl:if test="D_364">
                            <xsl:value-of select="substring-after(D_364, 'x')"/>
                        </xsl:if>
                    </xsl:attribute>
                </Con>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="D_365_2 = 'EM'">
                <Con>
                    <xsl:attribute name="type">Email</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_2)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_2 = 'UR'">
                <Con>
                    <xsl:attribute name="type">URL</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_2)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_2 = 'TE'">
                <Con>
                    <xsl:attribute name="type">Phone</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, '(')">
                                <xsl:value-of select="substring-before(D_364_2, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, '-')">
                                <xsl:value-of select="substring-before(D_364_2, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364_2, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_2, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_2 = 'FX'">
                <Con>
                    <xsl:attribute name="type">Fax</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, '(')">
                                <xsl:value-of select="substring-before(D_364_2, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, '-')">
                                <xsl:value-of select="substring-before(D_364_2, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_2, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_2, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_2, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_2, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_2, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364_2, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_2, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="D_365_3 = 'EM'">
                <Con>
                    <xsl:attribute name="type">Email</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_3)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_3 = 'UR'">
                <Con>
                    <xsl:attribute name="type">URL</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:value-of select="normalize-space(D_364_3)"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_3 = 'TE'">
                <Con>
                    <xsl:attribute name="type">Phone</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, '(')">
                                <xsl:value-of select="substring-before(D_364_3, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, '-')">
                                <xsl:value-of select="substring-before(D_364_3, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364_3, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_3, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
            <xsl:when test="D_365_3 = 'FX'">
                <Con>
                    <xsl:attribute name="type">Fax</xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$PER02"/>
                    </xsl:attribute>
                    <xsl:attribute name="cCode">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, '(')">
                                <xsl:value-of select="substring-before(D_364_3, '(')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, '-')">
                                <xsl:value-of select="substring-before(D_364_3, '-')"/>
                            </xsl:when>
                            <xsl:otherwise>1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="aCode">
                        <xsl:value-of select="substring-after(substring-before(D_364_3, ')'), '(')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="num">
                        <xsl:choose>
                            <xsl:when test="contains(D_364_3, 'x')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_3, 'x'), '-')"/>
                            </xsl:when>
                            <xsl:when test="contains(D_364_3, 'X')">
                                <xsl:value-of
                                    select="substring-after(substring-before(D_364_3, 'X'), '-')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring-after(D_364_3, '-')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="ext">
                        <xsl:value-of select="substring-after(D_364_3, 'x')"/>
                    </xsl:attribute>
                </Con>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
   <xsl:template name="convertToAribaDate">
      <xsl:param name="Date"/>
      <xsl:param name="Time"/>
      <xsl:param name="TimeCode"/>
      <xsl:variable name="timeZone">
         <xsl:choose>
            <xsl:when test="$Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode != ''">
               <xsl:value-of select="replace(replace($Lookup/Lookups/TimeZones/TimeZone[X12Code = $TimeCode]/CXMLCode, 'P', '+'), 'M', '-')"/>
            </xsl:when>
            <xsl:otherwise>+00:00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="temDate">
         <xsl:value-of select="concat(substring($Date, 1, 4), '-', substring($Date, 5, 2), '-', substring($Date, 7, 2))"/>
      </xsl:variable>
      <xsl:variable name="tempTime">
         <xsl:choose>
            <xsl:when test="$Time != '' and string-length($Time) = 6">
               <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':', substring($Time, 5, 2))"/>
            </xsl:when>
            <xsl:when test="$Time != '' and string-length($Time) = 4">
               <xsl:value-of select="concat('T', substring($Time, 1, 2), ':', substring($Time, 3, 2), ':00')"/>
            </xsl:when>
            <xsl:otherwise>T12:00:00</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="concat($temDate, $tempTime, $timeZone)"/>
   </xsl:template>

</xsl:stylesheet>
