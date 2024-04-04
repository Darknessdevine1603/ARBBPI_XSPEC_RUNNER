<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pidx="http://www.pidx.org/schemas/v1.61"
   exclude-result-prefixes="#all" version="2.0">
   <xsl:param name="anSupplierANID"/>
   <xsl:param name="anBuyerANID"/>
   <xsl:param name="anProviderANID"/>
   <xsl:param name="anPayloadID"/>
   <xsl:param name="anEnvName"/>
   <xsl:param name="cXMLAttachments"/>
   <xsl:param name="attachSeparator" select="'\|'"/>
   <xsl:param name="anMaskANID" select="'_CIGSDRID_'"/>
   <xsl:param name="anSenderDefaultTimeZone"/>
   <xsl:param name="anANSILookupFlag"/>
   <xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:strip-space elements="*"/><xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <!-- For local testing -->
   <!-- <xsl:variable name="cXMLPIDXLookupList" select="document('cXML_PIDXLookups.xml')"/>    <xsl:include href="Format_PIDX_161_common.xsl"/>     -->
   <!-- for dynamic, reading from Partner Directory -->
   <xsl:variable name="cXMLPIDXLookupList"
      select="document('/Users/i320581/Documents/XSPEC_HOME/XSPEC/common/Supplier/LOOKUP_PIDX_1.61.xml')"/>
   <xsl:include href="FORMAT_PIDX_1.61_cXML_0000.xsl"/>
   <xsl:variable name="docLang">
      <xsl:choose>
         <xsl:when
            test="normalize-space(pidx:AdvancedShipNotice/pidx:AdvancedShipNoticeProperties/pidx:LanguageCode) != ''">
            <xsl:value-of
               select="normalize-space(pidx:AdvancedShipNotice/pidx:AdvancedShipNoticeProperties/pidx:LanguageCode)"
            />
         </xsl:when>
         <xsl:otherwise>en</xsl:otherwise>
      </xsl:choose>
   </xsl:variable>
   <xsl:template match="/pidx:AdvancedShipNotice">
      <cXML>
         <xsl:attribute name="timestamp">
            <xsl:value-of
               select="concat(substring(string(current-dateTime()), 1, 19), $anSenderDefaultTimeZone)"
            />
         </xsl:attribute>
         <xsl:attribute name="payloadID">
            <xsl:value-of select="concat($anPayloadID, $anMaskANID, $anBuyerANID)"/>
         </xsl:attribute>
         <xsl:attribute name="xml:lang" select="$docLang"/>
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
         <Request>
            <xsl:choose>
               <xsl:when test="$anEnvName = 'PROD'">
                  <xsl:attribute name="deploymentMode">production</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="deploymentMode">test</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
            <ShipNoticeRequest>
               <ShipNoticeHeader>
                  <xsl:attribute name="shipmentID">
                     <xsl:value-of
                        select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:ShipmentIdentifier)"
                     />
                  </xsl:attribute>
                  <xsl:attribute name="noticeDate">
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:ShipDate)"
                        />
                     </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="shipmentDate">
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:ShipDate)"
                        />
                     </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="shipmentType">
                     <xsl:value-of
                        select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:CustomerSpecificInformation[@informationType = 'ShipmentType'])"
                     />
                  </xsl:attribute>
                  <xsl:attribute name="fulfillmentType">
                     <xsl:value-of
                        select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:CustomerSpecificInformation[@informationType = 'FulfillmentType'])"
                     />
                  </xsl:attribute>
                  <xsl:attribute name="deliveryDate">
                     <xsl:call-template name="formatDate">
                        <xsl:with-param name="DocDate"
                           select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:ScheduleDateTime)"
                        />
                     </xsl:call-template>
                  </xsl:attribute>
                  <xsl:for-each
                     select="pidx:AdvancedShipNoticeProperties/pidx:PartnerInformation[@partnerRoleIndicator != 'Carrier'][@partnerRoleIndicator != 'Consignee']">
                     <xsl:variable name="contactType" select="@partnerRoleIndicator"/>
                     <xsl:variable name="getPartyrole"
                        select="($cXMLPIDXLookupList/Lookups/Roles/Role[PIDXCode = $contactType]/CXMLCode)[1]"/>
                     <xsl:variable name="addressID">
                        <xsl:choose>
                           <xsl:when
                              test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                              <xsl:value-of
                                 select="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'])"
                              />
                           </xsl:when>
                           <xsl:when
                              test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySupplier'] != ''">
                              <xsl:value-of
                                 select="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySupplier'])"
                              />
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:if test="$getPartyrole != ''">
                        <Contact>
                           <xsl:attribute name="role">
                              <xsl:value-of select="$getPartyrole"/>
                           </xsl:attribute>
                           <xsl:if test="$addressID != ''">
                              <xsl:attribute name="addressID">
                                 <xsl:value-of select="$addressID"/>
                              </xsl:attribute>
                           </xsl:if>
                           <xsl:call-template name="CreateContact">
                              <xsl:with-param name="partyInfo" select="."/>
                              <xsl:with-param name="partyRole" select="$getPartyrole"/>
                           </xsl:call-template>
                        </Contact>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:for-each select="pidx:AdvancedShipNoticeProperties/pidx:Comment">
                     <Comments>
                        <xsl:value-of select="normalize-space(.)"/>
                     </Comments>
                  </xsl:for-each>
                  <xsl:if test="pidx:AdvancedShipNoticeProperties/pidx:ShipmentTerms">
                     <TermsOfDelivery>
                        <TermsOfDeliveryCode>
                           <xsl:attribute name="value"
                              select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:ShipmentTerms/pidx:ShipmentTermsCode)"
                           />
                        </TermsOfDeliveryCode>
                        <xsl:variable name="spm"
                           select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:ShipmentMethodOfPayment)"/>
                        <xsl:if
                           test="$cXMLPIDXLookupList/Lookups/ShipPayMethods/ShipPayMethod[PIDXCode = $spm]/CXMLCode != ''">
                           <ShippingPaymentMethod>
                              <xsl:attribute name="value"
                                 select="$cXMLPIDXLookupList/Lookups/ShipPayMethods/ShipPayMethod[PIDXCode = $spm]/CXMLCode"
                              />
                           </ShippingPaymentMethod>
                        </xsl:if>
                        <xsl:for-each
                           select="pidx:AdvancedShipNoticeProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Consignee']">
                           <xsl:variable name="addressID">
                              <xsl:choose>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'] != ''">
                                    <xsl:value-of
                                       select="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedByBuyer'])"
                                    />
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySupplier'] != ''">
                                    <xsl:value-of
                                       select="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'AssignedBySupplier'])"
                                    />
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number'] != ''">
                                    <xsl:value-of
                                       select="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNS+4Number'])"
                                    />
                                 </xsl:when>
                                 <xsl:when
                                    test="pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber'] != ''">
                                    <xsl:value-of
                                       select="normalize-space(pidx:PartnerIdentifier[@partnerIdentifierIndicator = 'DUNSNumber'])"
                                    />
                                 </xsl:when>
                              </xsl:choose>
                           </xsl:variable>
                           <Address>
                              <xsl:if test="$addressID != ''">
                                 <xsl:attribute name="addressID" select="$addressID"/>
                                 <xsl:attribute name="addressIDDomain"
                                    select="normalize-space(pidx:PartnerIdentifier/@partnerIdentifierIndicator)"
                                 />
                              </xsl:if>
                              <xsl:call-template name="CreateContact">
                                 <xsl:with-param name="partyInfo" select="."/>
                                 <xsl:with-param name="partyRole" select="'Consignee'"/>
                              </xsl:call-template>
                           </Address>
                        </xsl:for-each>
                     </TermsOfDelivery>
                  </xsl:if>
                  <xsl:if test="pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails">
                     <TermsOfTransport>
                        <xsl:if
                           test="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:SealNumber) != ''">
                           <SealID>
                              <xsl:value-of
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:SealNumber)"
                              />
                           </SealID>
                        </xsl:if>
                        <xsl:if
                           test="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:CarrierEquipmentCode) != ''">
                           <EquipmentIdentificationCode>
                              <xsl:value-of
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:CarrierEquipmentCode)"
                              />
                           </EquipmentIdentificationCode>
                        </xsl:if>
                        <xsl:if
                           test="pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Height">
                           <Dimension>
                              <xsl:attribute name="quantity"
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Height/pidx:Quantity)"/>
                              <xsl:attribute name="type" select="'height'"/>
                              <xsl:call-template name="UOMCodeConversion">
                                 <xsl:with-param name="UOMCode"
                                    select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Height/pidx:UnitOfMeasureCode)"
                                 />
                              </xsl:call-template>
                           </Dimension>
                        </xsl:if>
                        <xsl:if
                           test="pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Width">
                           <Dimension>
                              <xsl:attribute name="quantity"
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Width/pidx:Quantity)"/>
                              <xsl:attribute name="type" select="'width'"/>
                              <xsl:call-template name="UOMCodeConversion">
                                 <xsl:with-param name="UOMCode"
                                    select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Width/pidx:UnitOfMeasureCode)"
                                 />
                              </xsl:call-template>
                           </Dimension>
                        </xsl:if>
                        <xsl:if
                           test="pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Length">
                           <Dimension>
                              <xsl:attribute name="quantity"
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Length/pidx:Quantity)"/>
                              <xsl:attribute name="type" select="'length'"/>
                              <xsl:call-template name="UOMCodeConversion">
                                 <xsl:with-param name="UOMCode"
                                    select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:Length/pidx:UnitOfMeasureCode)"
                                 />
                              </xsl:call-template>
                           </Dimension>
                        </xsl:if>
                        <xsl:if
                           test="pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:GrossWeight">
                           <Dimension>
                              <xsl:attribute name="quantity"
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:GrossWeight/pidx:Quantity)"/>
                              <xsl:attribute name="type" select="'grossWeight'"/>
                              <xsl:call-template name="UOMCodeConversion">
                                 <xsl:with-param name="UOMCode"
                                    select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:GrossWeight/pidx:UnitOfMeasureCode)"
                                 />
                              </xsl:call-template>
                           </Dimension>
                        </xsl:if>
                        <xsl:if
                           test="pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:GrossVolume">
                           <Dimension>
                              <xsl:attribute name="quantity"
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:GrossVolume/pidx:Quantity)"/>
                              <xsl:attribute name="type" select="'grossVolume'"/>
                              <xsl:call-template name="UOMCodeConversion">
                                 <xsl:with-param name="UOMCode"
                                    select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:GrossVolume/pidx:UnitOfMeasureCode)"
                                 />
                              </xsl:call-template>
                           </Dimension>
                        </xsl:if>
                        <xsl:if
                           test="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:EquipmentIdentifier) != ''">
                           <Extrinsic name="EquipmentID">
                              <xsl:value-of
                                 select="normalize-space(pidx:AdvancedShipNoticeDetails/pidx:ShipNoticeEquipmentDetails/pidx:EquipmentIdentifier)"
                              />
                           </Extrinsic>
                        </xsl:if>
                     </TermsOfTransport>
                  </xsl:if>
                  <xsl:for-each
                     select="pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'MutuallyDefined']">
                     <xsl:if test="normalize-space(pidx:DocumentIdentifier) != ''">
                        <Extrinsic>
                           <xsl:attribute name="name"
                              select="normalize-space(pidx:DocumentIdentifier)"/>
                           <xsl:if
                              test="normalize-space(pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber) != ''">
                              <xsl:value-of
                                 select="normalize-space(pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']/pidx:ReferenceNumber)"
                              />
                           </xsl:if>
                        </Extrinsic>
                     </xsl:if>
                  </xsl:for-each>
               </ShipNoticeHeader>
               <xsl:if
                  test="pidx:AdvancedShipNoticeProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Carrier'] and pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'ShipmentIdentifier']/pidx:ReferenceInformation[@referenceInformationIndicator = 'Other']">
                  <ShipControl>
                     <xsl:for-each
                        select="pidx:AdvancedShipNoticeProperties/pidx:PartnerInformation[@partnerRoleIndicator = 'Carrier']/pidx:PartnerIdentifier">
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(@partnerIdentifierIndicator) = 'Other' and normalize-space(@definitionOfOther) = 'SCAC'">
                              <CarrierIdentifier domain="SCAC">
                                 <xsl:value-of select="normalize-space(.)"/>
                              </CarrierIdentifier>
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(@partnerIdentifierIndicator) = 'AssignedByBuyer'">
                              <CarrierIdentifier domain="assignedByBuyer">
                                 <xsl:value-of select="normalize-space(.)"/>
                              </CarrierIdentifier>
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(@partnerIdentifierIndicator) = 'AssignedBySupplier'">
                              <CarrierIdentifier domain="assignedBySeller">
                                 <xsl:value-of select="normalize-space(.)"/>
                              </CarrierIdentifier>
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(@partnerIdentifierIndicator) = 'DUNS+4Number'">
                              <CarrierIdentifier domain="duns4">
                                 <xsl:value-of select="normalize-space(.)"/>
                              </CarrierIdentifier>
                           </xsl:when>
                           <xsl:when
                              test="normalize-space(@partnerIdentifierIndicator) = 'DUNSNumber'">
                              <CarrierIdentifier domain="duns">
                                 <xsl:value-of select="normalize-space(.)"/>
                              </CarrierIdentifier>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:for-each>
                     <xsl:for-each
                        select="pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'ShipmentIdentifier']">
                        <ShipmentIdentifier>
                           <xsl:attribute name="domain"
                              select="concat(lower-case(substring(normalize-space(pidx:ReferenceInformation/pidx:Description), 1, 1)), substring(normalize-space(pidx:ReferenceInformation/pidx:Description), 2))"/>
                           <xsl:value-of select="pidx:DocumentIdentifier"/>
                        </ShipmentIdentifier>
                     </xsl:for-each>
                     <xsl:variable name="transMethod"
                        select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:TransportMethod)"/>
                     <xsl:variable name="transMethodLookup"
                        select="$cXMLPIDXLookupList/Lookups/TransportMethods/TransportMethod[PIDXCode = $transMethod]/CXMLCode"/>
                     <xsl:variable name="shipContractNum"
                        select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'ShippingContract']/pidx:DocumentIdentifier[1])"/>
                     <xsl:variable name="shipInstructions">
                        <xsl:for-each
                           select="pidx:AdvancedShipNoticeProperties/pidx:SpecialInstructions[@instructionIndicator = 'ShipperInstructions']">
                           <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                     </xsl:variable>
                     <xsl:if
                        test="$transMethodLookup != '' or $shipContractNum != '' or $shipInstructions != ''">
                        <TransportInformation>
                           <xsl:if test="$transMethodLookup != ''">
                              <Route>
                                 <xsl:attribute name="method" select="$transMethodLookup"/>
                              </Route>
                           </xsl:if>
                           <xsl:if test="$shipContractNum != ''">
                              <ShippingContractNumber>
                                 <xsl:value-of select="$shipContractNum"/>
                              </ShippingContractNumber>
                           </xsl:if>
                           <xsl:if test="$shipInstructions != ''">
                              <ShippingInstructions>
                                 <Description>
                                    <xsl:attribute name="xml:lang">
                                       <xsl:choose>
                                          <xsl:when
                                             test="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:LanguageCode) != ''">
                                             <xsl:value-of
                                                select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:LanguageCode)"
                                             />
                                          </xsl:when>
                                          <xsl:otherwise>en</xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="$shipInstructions"/>
                                 </Description>
                              </ShippingInstructions>
                           </xsl:if>
                        </TransportInformation>
                     </xsl:if>
                  </ShipControl>
               </xsl:if>
               <xsl:choose>
                  <xsl:when
                     test="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:PurchaseOrderReferenceInformation/pidx:OrderNumber) != '' and normalize-space(pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'ContractNumber']/pidx:DocumentIdentifier) != ''">
                     <ShipNoticePortion>
                        <xsl:element name="OrderReference">
                           <xsl:attribute name="orderID"
                              select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:PurchaseOrderReferenceInformation/pidx:OrderNumber)"/>
                           <xsl:attribute name="orderDate">
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:PurchaseOrderReferenceInformation/pidx:OrderDate)"
                                 />
                              </xsl:call-template>
                           </xsl:attribute>
                           <DocumentReference payloadID=""/>
                        </xsl:element>
                        <xsl:element name="MasterAgreementIDInfo">
                           <xsl:attribute name="agreementID"
                              select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'ContractNumber']/pidx:DocumentIdentifier)"/>
                           <xsl:attribute name="agreementDate">
                              <xsl:call-template name="formatDate">
                                 <xsl:with-param name="DocDate"
                                    select="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'ContractNumber']/pidx:DocumentDate)"
                                 />
                              </xsl:call-template>
                           </xsl:attribute>
                           <xsl:if
                              test="normalize-space(pidx:AdvancedShipNoticeProperties/pidx:DocumentReference[@referenceType = 'ContractNumber']/pidx:ReferenceItem) = '1'">
                              <xsl:attribute name="agreementType"
                                 >scheduling_agreement</xsl:attribute>
                           </xsl:if>
                        </xsl:element>
                        <xsl:for-each
                           select="pidx:AdvancedShipNoticeDetails/pidx:AdvancedShipNoticeLineItems">
                           <xsl:apply-templates select="."/>
                        </xsl:for-each>
                     </ShipNoticePortion>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:for-each-group
                        select="pidx:AdvancedShipNoticeDetails/pidx:AdvancedShipNoticeLineItems"
                        group-by="pidx:DocumentReference[@referenceType = 'PurchaseOrderNumber']/pidx:DocumentIdentifier">
                        <xsl:element name="ShipNoticePortion">
                           <xsl:element name="OrderReference">
                              <xsl:attribute name="orderID"
                                 select="normalize-space(pidx:DocumentReference[@referenceType = 'PurchaseOrderNumber']/pidx:DocumentIdentifier)"/>
                              <xsl:attribute name="orderDate">
                                 <xsl:call-template name="formatDate">
                                    <xsl:with-param name="DocDate"
                                       select="normalize-space(pidx:DocumentReference[@referenceType = 'PurchaseOrderNumber']/pidx:DocumentDate)"
                                    />
                                 </xsl:call-template>
                              </xsl:attribute>
                              <DocumentReference payloadID=""/>
                           </xsl:element>
                           <xsl:element name="MasterAgreementIDInfo">
                              <xsl:attribute name="agreementID"
                                 select="normalize-space(pidx:DocumentReference[@referenceType = 'ContractNumber']/pidx:DocumentIdentifier)"/>
                              <xsl:attribute name="agreementDate">
                                 <xsl:call-template name="formatDate">
                                    <xsl:with-param name="DocDate"
                                       select="normalize-space(pidx:DocumentReference[@referenceType = 'ContractNumber']/pidx:DocumentDate)"
                                    />
                                 </xsl:call-template>
                              </xsl:attribute>
                              <xsl:if
                                 test="normalize-space(pidx:DocumentReference[@referenceType = 'ContractNumber']/pidx:ReferenceItem) = '1'">
                                 <xsl:attribute name="agreementType"
                                    >scheduling_agreement</xsl:attribute>
                              </xsl:if>
                           </xsl:element>
                           <xsl:for-each select="current-group()">
                              <xsl:apply-templates select="."/>
                           </xsl:for-each>
                        </xsl:element>
                     </xsl:for-each-group>
                  </xsl:otherwise>
               </xsl:choose>
            </ShipNoticeRequest>
         </Request>
      </cXML>
   </xsl:template>
   <xsl:template match="pidx:AdvancedShipNoticeLineItems">
      <xsl:element name="ShipNoticeItem">
         <xsl:attribute name="shipNoticeLineNumber" select="normalize-space(pidx:LineItemNumber)"/>
         <xsl:attribute name="lineNumber"
            select="normalize-space(pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'PurchaseOrderLineNumber']/pidx:DocumentIdentifier)"/>
         <xsl:attribute name="quantity" select="normalize-space(pidx:ShippedQuantity/pidx:Quantity)"/>
         <xsl:element name="ItemID">
            <xsl:element name="SupplierPartID">
               <xsl:value-of
                  select="normalize-space(pidx:ProductInformation/pidx:ProductIdentifier[@assigningOrganization = 'AssignedBySupplier'])"
               />
            </xsl:element>
            <xsl:if
               test="normalize-space(pidx:ProductInformation/pidx:ProductIdentifier[@assigningOrganization = 'AssignedByBuyer']) != ''">
               <xsl:element name="BuyerPartID">
                  <xsl:value-of
                     select="normalize-space(pidx:ProductInformation/pidx:ProductIdentifier[@assigningOrganization = 'AssignedByBuyer'])"
                  />
               </xsl:element>
            </xsl:if>
         </xsl:element>
         <xsl:if
            test="normalize-space(pidx:ProductInformation/pidx:ProductDescription/pidx:Description) != '' or normalize-space(pidx:ProductInformation/pidx:ProductIdentifier[@assigningOrganization = 'AssignedByManufacturer']) != '' or pidx:ProductInformation/pidx:ProductGradeDescription">
            <xsl:element name="ShipNoticeItemDetail">
               <xsl:if
                  test="normalize-space(pidx:ProductInformation/pidx:ProductDescription/pidx:Description) != ''">
                  <xsl:element name="Description">
                     <xsl:attribute name="xml:lang">
                        <xsl:choose>
                           <xsl:when
                              test="normalize-space(pidx:ProductInformation/pidx:ProductDescription/pidx:LanguageCode) != ''">
                              <xsl:value-of
                                 select="normalize-space(pidx:ProductInformation/pidx:ProductDescription/pidx:LanguageCode[1])"
                              />
                           </xsl:when>
                           <xsl:otherwise>en</xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:for-each select="pidx:ProductInformation/pidx:ProductDescription">
                        <xsl:value-of select="normalize-space(pidx:Description)"/>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:if>
               <xsl:if
                  test="normalize-space(pidx:ProductInformation/pidx:ProductIdentifier[@assigningOrganization = 'AssignedByManufacturer']) != ''">
                  <xsl:element name="ManufacturerPartID">
                     <xsl:value-of
                        select="normalize-space(pidx:ProductInformation/pidx:ProductIdentifier[@assigningOrganization = 'AssignedByManufacturer'])"
                     />
                  </xsl:element>
               </xsl:if>
               <xsl:if test="pidx:ProductInformation/pidx:ProductGradeDescription">
                  <xsl:element name="ItemDetailIndustry">
                     <xsl:element name="ItemDetailRetail">
                        <xsl:for-each select="pidx:ProductInformation/pidx:ProductGradeDescription">
                           <xsl:element name="Characteristic">
                              <xsl:attribute name="domain" select="'grade'"/>
                              <xsl:attribute name="value" select="normalize-space(pidx:Description)"
                              />
                           </xsl:element>
                        </xsl:for-each>
                     </xsl:element>
                  </xsl:element>
               </xsl:if>
            </xsl:element>
         </xsl:if>
         <xsl:call-template name="UOMCodeConversion">
            <xsl:with-param name="UOMCode"
               select="normalize-space(pidx:ShippedQuantity/pidx:UnitOfMeasureCode)"/>
         </xsl:call-template>
         <xsl:if
            test="normalize-space(pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'BuyerBatch']/pidx:DocumentIdentifier) != '' or normalize-space(pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'SupplierBatch']/pidx:DocumentIdentifier) != ''">
            <xsl:element name="Batch">
               <xsl:if
                  test="normalize-space(pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'BuyerBatch']/pidx:DocumentIdentifier) != ''">
                  <xsl:element name="BuyerBatchID">
                     <xsl:value-of
                        select="normalize-space(pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'BuyerBatch']/pidx:DocumentIdentifier)"
                     />
                  </xsl:element>
               </xsl:if>
               <xsl:if
                  test="normalize-space(pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'SupplierBatch']/pidx:DocumentIdentifier) != ''">
                  <xsl:element name="SupplierBatchID">
                     <xsl:value-of
                        select="normalize-space(pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'SupplierBatch']/pidx:DocumentIdentifier)"
                     />
                  </xsl:element>
               </xsl:if>
            </xsl:element>
         </xsl:if>
         <xsl:if
            test="normalize-space(pidx:OrderQuantity/pidx:Quantity) != '' and normalize-space(pidx:OrderQuantity/pidx:UnitOfMeasureCode) != ''">
            <xsl:element name="OrderedQuantity">
               <xsl:attribute name="quantity"
                  select="normalize-space(pidx:OrderQuantity/pidx:Quantity)"/>
               <xsl:call-template name="UOMCodeConversion">
                  <xsl:with-param name="UOMCode"
                     select="normalize-space(pidx:OrderQuantity/pidx:UnitOfMeasureCode)"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:if>
         <xsl:for-each
            select="pidx:DocumentReference[@referenceType = 'Other'][@definitionOfOther = 'MutuallyDefined'][normalize-space(pidx:DocumentIdentifier) != ''][pidx:ReferenceInformation/@referenceInformationIndicator = 'Other'][normalize-space(pidx:ReferenceInformation/pidx:ReferenceNumber) != '']">
            <xsl:element name="Extrinsic">
               <xsl:attribute name="name" select="normalize-space(pidx:DocumentIdentifier)"/>
               <xsl:value-of
                  select="normalize-space(pidx:ReferenceInformation/pidx:ReferenceNumber)"/>
            </xsl:element>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="UOMCodeConversion">
      <xsl:param name="UOMCode"/>
      <xsl:choose>
         <xsl:when
            test="lower-case($anANSILookupFlag) = 'true' and $cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[PIDXCode = $UOMCode]">
            <xsl:element name="UnitOfMeasure">
               <xsl:value-of
                  select="$cXMLPIDXLookupList/Lookups/UOMCodes/UOMCode[PIDXCode = $UOMCode]/CXMLCode"
               />
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="UnitOfMeasure">
               <xsl:value-of select="$UOMCode"/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
